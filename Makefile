NAME=unity-grub2
DISTREL=1
VERSION=2.02

RPMBUILD=$(shell which rpmbuild)
CAT=$(shell which cat)
SED=$(shell which sed)
RM=$(shell which rm)
SPECTOOL=$(shell which spectool)

all:

$(NAME).spec: $(NAME).spec.in
	@$(CAT) $(NAME).spec.in | \
		$(SED) -e 's,@VERSION@,$(VERSION),g' | \
		$(SED) -e 's,@DISTREL@,$(DISTREL),g' \
			>$(NAME).spec
	@echo
	@echo "$(NAME).spec generated in $$PWD"
	@echo

spec: $(NAME).spec

srpm_build:
	$(RPMBUILD) "--undefine=_disable_source_fetch" "--define" "_sourcedir $(shell pwd)" "--define" "_topdir $(shell pwd)" -bs $(NAME).spec
	@$(RM) -rf SOURCES SPECS BUILD BUILDROOT RPMS

srpm: spec srpm_build

clean:
	@$(RM) -f *.spec
	@$(RM) -rf SRPMS RPMS SOURCES SPECS BUILD BUILDROOT
	@$(RM) -rf *.tar.*
	@find -name '*~' -exec $(RM) {} \;
	@echo
	@echo "Cleaning complete"
	@echo
