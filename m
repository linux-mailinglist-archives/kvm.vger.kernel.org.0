Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1D843EF686
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 02:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236950AbhHRAJx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 20:09:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbhHRAJw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 20:09:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A44C061764
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:18 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v130-20020a25c5880000b0290593c8c353ffso968342ybe.7
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 17:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=IMByHBVtVTxpFzJqyKJh8y3OPfYXgAc4758k5xkfS60=;
        b=JznesIJNzG1J4OdEOgZWlbE8DGCN1Lgm5cBoYD9fHTW02iF7lWS59dfQE1FQXownRP
         ODeut2jSKODIbnNTCWe9Dv1CmmTCg5qK51VTqoOtqQqpjCTcOwqKlb7Svlj91YRuqbx/
         Uryx9MoZImtgEZvlapEqRM8onXcYLlLk+Q+YvwjCzDamJQngauQV7zDwuzaLk0Oun03q
         4Irle2iWdovmgZHzFw1Gz6UHkOLloU3SLIAYy7frZl2I/4g/3Gfa4VYv9fjjqrHhVzoo
         pP/tvUggWyF9oXzfh8S+fFK8XMNkJjgwkMF8d7flV4pnJ/phGCLHzQOuo8/joBASHIYd
         WBNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=IMByHBVtVTxpFzJqyKJh8y3OPfYXgAc4758k5xkfS60=;
        b=Pa6ouGvCeU11tBLvLh9/tekkJKu2g/CYmKXLxnC/JB3PmwoGl0dJtYrAP/eUdP3yAt
         j/AO/ltO3CCOntBRTG4udwAGqeoYT6uc3g1alDz4yh0C8NoKE3b9ac5h0fl25Faz8yRz
         WIPCvzzm9cevq6zcBFo6UzcVMufGYCzfjwo/xJnMLTQdZL6vFv7QXZyETZcFr8edesY+
         N74PHW3yzf/yNMg2euJlWK6mqbFNwX3Mf1MnP5UTzu7EBQahTsDd3T/g5wv8wYM4i/g2
         Xk+hkwrFQjRmKvZBQS0QCKpJjXUxrQcZs0y4BXFoIhuIoxZ6NEhlBTFccZ2WOdhQ9mPb
         rSAg==
X-Gm-Message-State: AOAM531koLOfd7Ab2naH6P89xcLTrueybs0F9kUpBsrB9HvMkbs+syJv
        cfHRfrf9Q4hC8kmLObLh1zUs7Nb9MgO9dmKQ/pNlMZ2tAzv3tEo7RvjBRYa8ApoYJAsm+tgreHF
        L1PNQ8yIF5XC0pYy0Bzkv+r+robkArwySmzLykZETo67nnmG7NxRAFzyoKgrzZNTek4f3
X-Google-Smtp-Source: ABdhPJzkli7A7EqrQQ/IQLMoSSfl+RBnB0qyCZ0Pbz1ox3z8PPda+12QNLBDysYgVChYHmMNe/yVt1mmodfY/L4S
X-Received: from zxwang42.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2936])
 (user=zixuanwang job=sendgmr) by 2002:a25:aaa2:: with SMTP id
 t31mr7936530ybi.178.1629245357723; Tue, 17 Aug 2021 17:09:17 -0700 (PDT)
Date:   Wed, 18 Aug 2021 00:08:51 +0000
In-Reply-To: <20210818000905.1111226-1-zixuanwang@google.com>
Message-Id: <20210818000905.1111226-3-zixuanwang@google.com>
Mime-Version: 1.0
References: <20210818000905.1111226-1-zixuanwang@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [kvm-unit-tests RFC 02/16] x86 UEFI: Boot from UEFI
From:   Zixuan Wang <zixuanwang@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com
Cc:     marcorr@google.com, baekhw@google.com, tmroeder@google.com,
        erdemaktas@google.com, rientjes@google.com, seanjc@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com,
        varad.gautam@suse.com, jroedel@suse.de, bp@suse.de,
        Zixuan Wang <zixuanwang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This commit provides initial support for x86 test cases to boot from
UEFI:

   1. UEFI compiler flags are added to Makefile
   2. A new TARGET_EFI macro is added to turn on/off UEFI startup code
   3. Previous Multiboot setup code is refactored and updated for
      supporting UEFI, including the following changes:
      1. GNU-EFI/crt0-efi-x86_64.o: provides entry point and jumps to
         setup code in lib/efi.c. This file comes from GNU-EFI library
         package and is not included in this commit
      2. lib/efi.c: performs UEFI setup, calls arch-related setup
         functions, then jumps to test case main() function
      3. lib/x86/setup.c: provides arch-related setup under UEFI

To build test cases for UEFI, please first install the GNU-EFI library.
Check x86/efi/README.md for more details.

This commit is tested by a simple test calling report() and
report_summayr(). This commit does not include such a test to avoid
unnecessary files added into git history. To build and run this test in
UEFI (assuming file name is x86/dummy.c):

   ./configure --target-efi
   make x86/dummy.efi
   ./x86/efi/run ./x86/dummy.efi

To use the default Multiboot instead of UEFI:

   ./configure
   make x86/dummy.flat
   ./x86/run ./x86/dummy.flat

Some x86 test cases require additional fixes to work in UEFI, e.g.,
converting to position independent code (PIC), setting up page tables,
etc. This commit does not provide these fixes, so compiling and running
UEFI test cases other than x86/dummy.c may trigger compiler errors or
QEMU crashes.

The following code is ported from github.com/rhdrjones/kvm-unit-tests
   - ./configure: 'target-efi'-related code

See original code:
   - Repo: https://github.com/rhdrjones/kvm-unit-tests
   - Branch: target-efi

Signed-off-by: Zixuan Wang <zixuanwang@google.com>
---
 .gitignore          |  3 +++
 Makefile            | 47 +++++++++++++++++++++++++++++++--
 README.md           |  6 +++++
 configure           | 20 ++++++++++++++
 lib/efi.c           | 44 +++++++++++++++++++++++++++++++
 lib/string.c        |  3 +++
 lib/x86/asm/setup.h | 11 ++++++++
 lib/x86/setup.c     | 14 ++++++++++
 x86/Makefile.common | 64 +++++++++++++++++++++++++++++++++------------
 x86/Makefile.i386   |  5 ++--
 x86/Makefile.x86_64 | 54 ++++++++++++++++++++++++--------------
 x86/efi/README.md   | 49 +++++++++++++++++++++++++++++++++-
 x86/efi/run         | 63 ++++++++++++++++++++++++++++++++++++++++++++
 x86/run             | 16 ++++++++++--
 14 files changed, 357 insertions(+), 42 deletions(-)
 create mode 100644 lib/efi.c
 create mode 100644 lib/x86/asm/setup.h
 create mode 100755 x86/efi/run

diff --git a/.gitignore b/.gitignore
index b3cf2cb..dca6d29 100644
--- a/.gitignore
+++ b/.gitignore
@@ -3,7 +3,9 @@ tags
 *.a
 *.d
 *.o
+*.so
 *.flat
+*.efi
 *.elf
 .pc
 patches
@@ -24,3 +26,4 @@ cscope.*
 /api/dirty-log-perf
 /s390x/*.bin
 /s390x/snippets/*/*.gbin
+/efi-tests/*
diff --git a/Makefile b/Makefile
index f7b9f28..7084bac 100644
--- a/Makefile
+++ b/Makefile
@@ -38,6 +38,39 @@ LIBFDT_archive = $(LIBFDT_objdir)/libfdt.a
 
 OBJDIRS += $(LIBFDT_objdir)
 
+# EFI App
+ifeq ($(TARGET_EFI),y)
+ifeq ($(ARCH_NAME),x86_64)
+EFI_ARCH = x86_64
+else
+$(error Cannot build $(ARCH_NAME) tests as EFI apps)
+endif
+ifeq ($(EFI_INCLUDE_PATH),)
+EFI_INCLUDE_PATH:= /usr/include/efi
+endif
+ifeq ($(EFI_LIBS_PATH),)
+EFI_LIBS_PATH := /usr/lib/
+endif
+EFI_LIBS := -L $(EFI_LIBS_PATH) -lgnuefi -lefi
+EFI_CFLAGS := -DTARGET_EFI
+EFI_CFLAGS += -I $(EFI_INCLUDE_PATH) -I $(EFI_INCLUDE_PATH)/$(EFI_ARCH)
+# The following CFLAGS and LDFLAGS come from:
+#   - GNU-EFI/Makefile.defaults
+#   - GNU-EFI/apps/Makefile
+# Tell GNU-EFI to create an ABI that UEFI recognizes
+EFI_CFLAGS += -DGNU_EFI_USE_MS_ABI
+# Function calls must include the number of arguments passed to the functions
+# More details: https://wiki.osdev.org/GNU-EFI
+EFI_CFLAGS += -maccumulate-outgoing-args
+# GCC defines wchar to be 32 bits, but EFI expects 16 bits
+EFI_CFLAGS += -fshort-wchar
+# EFI applications use PIC as they are loaded to dynamic addresses, not a fixed
+# starting address
+EFI_CFLAGS += -fPIC
+# Create shared library
+EFI_LDFLAGS := -Bsymbolic -shared -nostdlib
+endif
+
 #include architecture specific make rules
 include $(SRCDIR)/$(TEST_DIR)/Makefile
 
@@ -62,14 +95,24 @@ COMMON_CFLAGS += $(fno_stack_protector)
 COMMON_CFLAGS += $(fno_stack_protector_all)
 COMMON_CFLAGS += $(wno_frame_address)
 COMMON_CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
+ifeq ($(TARGET_EFI),y)
+COMMON_CFLAGS += $(EFI_CFLAGS)
+else
 COMMON_CFLAGS += $(fno_pic) $(no_pie)
+endif
 COMMON_CFLAGS += $(wclobbered)
 COMMON_CFLAGS += $(wunused_but_set_parameter)
 
 CFLAGS += $(COMMON_CFLAGS)
 CFLAGS += $(wmissing_parameter_type)
 CFLAGS += $(wold_style_declaration)
-CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
+CFLAGS += -Woverride-init
+CFLAGS += -Wmissing-prototypes
+ifeq ($(TARGET_EFI),y)
+# GNU-EFI library header does not pass the strict-prototype check
+else
+CFLAGS += -Wstrict-prototypes
+endif
 
 autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
 
@@ -113,7 +156,7 @@ clean: arch_clean libfdt_clean
 
 distclean: clean
 	$(RM) lib/asm lib/config.h config.mak $(TEST_DIR)-run msr.out cscope.* build-head
-	$(RM) -r tests logs logs.old
+	$(RM) -r tests logs logs.old efi-tests
 
 cscope: cscope_dirs = lib lib/libfdt lib/linux $(TEST_DIR) $(ARCH_LIBDIRS) lib/asm-generic
 cscope:
diff --git a/README.md b/README.md
index b498aaf..6edacfe 100644
--- a/README.md
+++ b/README.md
@@ -17,6 +17,8 @@ in this directory.  Test images are created in ./ARCH/\*.flat
 
 NOTE: GCC cross-compiler is required for [build on macOS](README.macOS.md).
 
+To build with UEFI, check [build and run with UEFI](./x86/efi/README.md).
+
 ## Standalone tests
 
 The tests can be built as standalone.  To create and use standalone tests do:
@@ -54,6 +56,10 @@ ACCEL=name environment variable:
 
     ACCEL=kvm ./x86-run ./x86/msr.flat
 
+## Running the tests with UEFI
+
+Check [build and run with UEFI](./x86/efi/README.md).
+
 # Tests configuration file
 
 The test case may need specific runtime configurations, for
diff --git a/configure b/configure
index 1d4d855..3094375 100755
--- a/configure
+++ b/configure
@@ -28,6 +28,9 @@ erratatxt="$srcdir/errata.txt"
 host_key_document=
 page_size=
 earlycon=
+target_efi=
+efi_include_path=
+efi_libs_path=
 
 usage() {
     cat <<-EOF
@@ -69,6 +72,11 @@ usage() {
 	               pl011,mmio32,ADDR
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
+	    --target-efi           Boot and run from UEFI
+	    --efi-include-path     Path to GNU-EFI headers, e.g. "/usr/include/efi"
+	    --efi-libs-path        Path to GNU-EFI libraries, e.g. "/usr/lib/". This dir should
+	                           contain 3 files from GNU-EFI: crt0-efi-x86_64.o, libefi.a,
+	                           and libgnuefi.a
 EOF
     exit 1
 }
@@ -133,6 +141,15 @@ while [[ "$1" = -* ]]; do
 	--earlycon)
 	    earlycon="$arg"
 	    ;;
+	--target-efi)
+	    target_efi=y
+	    ;;
+	--efi-include-path)
+	    efi_include_path="$arg"
+	    ;;
+	--efi-libs-path)
+	    efi_libs_path="$arg"
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -341,6 +358,9 @@ U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
+TARGET_EFI=$target_efi
+EFI_INCLUDE_PATH=$efi_include_path
+EFI_LIBS_PATH=$efi_libs_path
 EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     echo "TARGET=$target" >> config.mak
diff --git a/lib/efi.c b/lib/efi.c
new file mode 100644
index 0000000..018918a
--- /dev/null
+++ b/lib/efi.c
@@ -0,0 +1,44 @@
+/*
+ * efi_main() function to set up and run test cases in EFI
+ *
+ * Copyright (c) 2021, Google Inc
+ *
+ * Authors:
+ *   Zixuan Wang <zixuanwang@google.com>
+ *
+ * SPDX-License-Identifier: LGPL-2.0-or-later
+ */
+
+#include <libcflat.h>
+#include <asm/setup.h>
+
+#ifdef ALIGN
+#undef ALIGN
+#endif
+#include <efi.h>
+#include <efilib.h>
+
+/* From lib/argv.c */
+extern int __argc, __envc;
+extern char *__argv[100];
+extern char *__environ[200];
+
+extern int main(int argc, char **argv, char **envp);
+
+EFI_STATUS efi_main(EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *systab);
+
+EFI_STATUS efi_main(EFI_HANDLE image_handle, EFI_SYSTEM_TABLE *systab)
+{
+	int ret;
+
+	InitializeLib(image_handle, systab);
+
+	setup_efi();
+	ret = main(__argc, __argv, __environ);
+
+	/* Shutdown the Guest VM */
+	uefi_call_wrapper(RT->ResetSystem, 4, EfiResetShutdown, ret, 0, NULL);
+
+	/* Unreachable */
+	return EFI_UNSUPPORTED;
+}
diff --git a/lib/string.c b/lib/string.c
index ffc7c7e..060955a 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -100,6 +100,8 @@ char *strstr(const char *s1, const char *s2)
     return NULL;
 }
 
+#ifndef TARGET_EFI
+/* GNU-EFI already defines memset and memcpy */
 void *memset(void *s, int c, size_t n)
 {
     size_t i;
@@ -122,6 +124,7 @@ void *memcpy(void *dest, const void *src, size_t n)
 
     return dest;
 }
+#endif /* TARGET_EFI */
 
 int memcmp(const void *s1, const void *s2, size_t n)
 {
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
new file mode 100644
index 0000000..eb1cf73
--- /dev/null
+++ b/lib/x86/asm/setup.h
@@ -0,0 +1,11 @@
+#ifndef _X86_ASM_SETUP_H_
+#define _X86_ASM_SETUP_H_
+
+#ifdef TARGET_EFI
+#include "x86/apic.h"
+#include "x86/smp.h"
+
+void setup_efi(void);
+#endif /* TARGET_EFI */
+
+#endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index 7befe09..e3faf00 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -9,6 +9,7 @@
 #include "fwcfg.h"
 #include "alloc_phys.h"
 #include "argv.h"
+#include "asm/setup.h"
 
 extern char edata;
 
@@ -118,6 +119,19 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 	initrd_size = mods->end - mods->start;
 }
 
+#ifdef TARGET_EFI
+
+void setup_efi(void)
+{
+	reset_apic();
+	mask_pic_interrupts();
+	enable_apic();
+	enable_x2apic();
+	smp_init();
+}
+
+#endif /* TARGET_EFI */
+
 void setup_libcflat(void)
 {
 	if (initrd) {
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 52bb7aa..00adddd 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -22,6 +22,10 @@ cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
+ifeq ($(TARGET_EFI),y)
+cflatobjs += lib/x86/setup.o
+cflatobjs += lib/efi.o
+endif
 
 OBJDIRS += lib/x86
 
@@ -37,10 +41,25 @@ COMMON_CFLAGS += -O1
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
 
+FLATLIBS = lib/libcflat.a
+
+ifeq ($(TARGET_EFI),y)
+.PRECIOUS: %.efi %.so
+
+%.so: %.o $(FLATLIBS) $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(cstart.o)
+	$(LD) -T $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(EFI_LDFLAGS) -o $@ \
+		$(filter %.o, $^) $(FLATLIBS) $(EFI_LIBS)
+	@chmod a-x $@
+
+%.efi: %.so
+	$(OBJCOPY) \
+		-j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
+		-j .rela -j .reloc -S --target=$(FORMAT) $< $@
+	@chmod a-x $@
+else
 # We want to keep intermediate file: %.elf and %.o 
 .PRECIOUS: %.elf %.o
 
-FLATLIBS = lib/libcflat.a
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
 	$(CC) $(CFLAGS) -nostdlib -o $@ -Wl,-T,$(SRCDIR)/x86/flat.lds \
 		$(filter %.o, $^) $(FLATLIBS)
@@ -49,18 +68,29 @@ FLATLIBS = lib/libcflat.a
 %.flat: %.elf
 	$(OBJCOPY) -O elf32-i386 $^ $@
 	@chmod a-x $@
+endif
 
-tests-common = $(TEST_DIR)/vmexit.flat $(TEST_DIR)/tsc.flat \
-               $(TEST_DIR)/smptest.flat  \
-               $(TEST_DIR)/realmode.flat $(TEST_DIR)/msr.flat \
-               $(TEST_DIR)/hypercall.flat $(TEST_DIR)/sieve.flat \
-               $(TEST_DIR)/kvmclock_test.flat  $(TEST_DIR)/eventinj.flat \
-               $(TEST_DIR)/s3.flat $(TEST_DIR)/pmu.flat $(TEST_DIR)/setjmp.flat \
-               $(TEST_DIR)/tsc_adjust.flat $(TEST_DIR)/asyncpf.flat \
-               $(TEST_DIR)/init.flat $(TEST_DIR)/smap.flat \
-               $(TEST_DIR)/hyperv_synic.flat $(TEST_DIR)/hyperv_stimer.flat \
-               $(TEST_DIR)/hyperv_connections.flat \
-               $(TEST_DIR)/umip.flat $(TEST_DIR)/tsx-ctrl.flat
+tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
+               $(TEST_DIR)/smptest.$(exe)  \
+               $(TEST_DIR)/msr.$(exe) \
+               $(TEST_DIR)/hypercall.$(exe) $(TEST_DIR)/sieve.$(exe) \
+               $(TEST_DIR)/kvmclock_test.$(exe) \
+               $(TEST_DIR)/s3.$(exe) $(TEST_DIR)/pmu.$(exe) $(TEST_DIR)/setjmp.$(exe) \
+               $(TEST_DIR)/tsc_adjust.$(exe) $(TEST_DIR)/asyncpf.$(exe) \
+               $(TEST_DIR)/init.$(exe) \
+               $(TEST_DIR)/hyperv_synic.$(exe) $(TEST_DIR)/hyperv_stimer.$(exe) \
+               $(TEST_DIR)/hyperv_connections.$(exe) \
+               $(TEST_DIR)/tsx-ctrl.$(exe)
+
+# The following test cases are disabled when building EFI tests because they
+# use absolute addresses in their inline assembly code, which cannot compile
+# with the '-fPIC' flag
+ifneq ($(TARGET_EFI),y)
+tests-common += $(TEST_DIR)/eventinj.$(exe) \
+                $(TEST_DIR)/smap.$(exe) \
+                $(TEST_DIR)/realmode.$(exe) \
+                $(TEST_DIR)/umip.$(exe)
+endif
 
 test_cases: $(tests-common) $(tests)
 
@@ -72,14 +102,16 @@ $(TEST_DIR)/realmode.elf: $(TEST_DIR)/realmode.o
 
 $(TEST_DIR)/realmode.o: bits = $(if $(call cc-option,-m16,""),16,32)
 
-$(TEST_DIR)/kvmclock_test.elf: $(TEST_DIR)/kvmclock.o
+$(TEST_DIR)/kvmclock_test.$(bin): $(TEST_DIR)/kvmclock.o
 
-$(TEST_DIR)/hyperv_synic.elf: $(TEST_DIR)/hyperv.o
+$(TEST_DIR)/hyperv_synic.$(bin): $(TEST_DIR)/hyperv.o
 
-$(TEST_DIR)/hyperv_stimer.elf: $(TEST_DIR)/hyperv.o
+$(TEST_DIR)/hyperv_stimer.$(bin): $(TEST_DIR)/hyperv.o
 
-$(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
+$(TEST_DIR)/hyperv_connections.$(bin): $(TEST_DIR)/hyperv.o
 
 arch_clean:
 	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
 	$(TEST_DIR)/.*.d lib/x86/.*.d \
+	$(TEST_DIR)/efi/*.o $(TEST_DIR)/efi/.*.d \
+	$(TEST_DIR)/*.so $(TEST_DIR)/*.efi
diff --git a/x86/Makefile.i386 b/x86/Makefile.i386
index 960e274..340c561 100644
--- a/x86/Makefile.i386
+++ b/x86/Makefile.i386
@@ -1,11 +1,12 @@
 cstart.o = $(TEST_DIR)/cstart.o
 bits = 32
 ldarch = elf32-i386
+exe = flat
 COMMON_CFLAGS += -mno-sse -mno-sse2
 
 cflatobjs += lib/x86/setjmp32.o lib/ldiv32.o
 
-tests = $(TEST_DIR)/taskswitch.flat $(TEST_DIR)/taskswitch2.flat \
-	$(TEST_DIR)/cmpxchg8b.flat $(TEST_DIR)/la57.flat
+tests = $(TEST_DIR)/taskswitch.$(exe) $(TEST_DIR)/taskswitch2.$(exe) \
+	$(TEST_DIR)/cmpxchg8b.$(exe) $(TEST_DIR)/la57.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 8134952..7063ba1 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -1,6 +1,15 @@
 cstart.o = $(TEST_DIR)/cstart64.o
 bits = 64
 ldarch = elf64-x86-64
+ifeq ($(TARGET_EFI),y)
+exe = efi
+bin = so
+FORMAT = efi-app-x86_64
+cstart.o = $(EFI_LIBS_PATH)/crt0-efi-x86_64.o
+else
+exe = flat
+bin = elf
+endif
 
 fcf_protection_full := $(call cc-option, -fcf-protection=full,)
 COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
@@ -9,29 +18,36 @@ cflatobjs += lib/x86/setjmp64.o
 cflatobjs += lib/x86/intel-iommu.o
 cflatobjs += lib/x86/usermode.o
 
-tests = $(TEST_DIR)/access.flat $(TEST_DIR)/apic.flat \
-	  $(TEST_DIR)/emulator.flat $(TEST_DIR)/idt_test.flat \
-	  $(TEST_DIR)/xsave.flat $(TEST_DIR)/rmap_chain.flat \
-	  $(TEST_DIR)/pcid.flat $(TEST_DIR)/debug.flat \
-	  $(TEST_DIR)/ioapic.flat $(TEST_DIR)/memory.flat \
-	  $(TEST_DIR)/pku.flat $(TEST_DIR)/hyperv_clock.flat
-tests += $(TEST_DIR)/syscall.flat
-tests += $(TEST_DIR)/svm.flat
-tests += $(TEST_DIR)/vmx.flat
-tests += $(TEST_DIR)/tscdeadline_latency.flat
-tests += $(TEST_DIR)/intel-iommu.flat
-tests += $(TEST_DIR)/vmware_backdoors.flat
-tests += $(TEST_DIR)/rdpru.flat
-tests += $(TEST_DIR)/pks.flat
-tests += $(TEST_DIR)/pmu_lbr.flat
+tests = $(TEST_DIR)/apic.$(exe) \
+	  $(TEST_DIR)/idt_test.$(exe) \
+	  $(TEST_DIR)/xsave.$(exe) $(TEST_DIR)/rmap_chain.$(exe) \
+	  $(TEST_DIR)/pcid.$(exe) $(TEST_DIR)/debug.$(exe) \
+	  $(TEST_DIR)/ioapic.$(exe) $(TEST_DIR)/memory.$(exe) \
+	  $(TEST_DIR)/pku.$(exe) $(TEST_DIR)/hyperv_clock.$(exe)
+tests += $(TEST_DIR)/syscall.$(exe)
+tests += $(TEST_DIR)/tscdeadline_latency.$(exe)
+tests += $(TEST_DIR)/intel-iommu.$(exe)
+tests += $(TEST_DIR)/rdpru.$(exe)
+tests += $(TEST_DIR)/pks.$(exe)
+tests += $(TEST_DIR)/pmu_lbr.$(exe)
 
+# The following test cases are disabled when building EFI tests because they
+# use absolute addresses in their inline assembly code, which cannot compile
+# with the '-fPIC' flag
+ifneq ($(TARGET_EFI),y)
+tests += $(TEST_DIR)/access.$(exe)
+tests += $(TEST_DIR)/emulator.$(exe)
+tests += $(TEST_DIR)/svm.$(exe)
+tests += $(TEST_DIR)/vmx.$(exe)
+tests += $(TEST_DIR)/vmware_backdoors.$(exe)
 ifneq ($(fcf_protection_full),)
-tests += $(TEST_DIR)/cet.flat
+tests += $(TEST_DIR)/cet.$(exe)
+endif
 endif
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
-$(TEST_DIR)/hyperv_clock.elf: $(TEST_DIR)/hyperv_clock.o
+$(TEST_DIR)/hyperv_clock.$(bin): $(TEST_DIR)/hyperv_clock.o
 
-$(TEST_DIR)/vmx.elf: $(TEST_DIR)/vmx_tests.o
-$(TEST_DIR)/svm.elf: $(TEST_DIR)/svm_tests.o
+$(TEST_DIR)/vmx.$(bin): $(TEST_DIR)/vmx_tests.o
+$(TEST_DIR)/svm.$(bin): $(TEST_DIR)/svm_tests.o
diff --git a/x86/efi/README.md b/x86/efi/README.md
index 4deba6e..b7f760a 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -1,4 +1,46 @@
-# EFI Startup Code and Linker Script
+# Build KVM-Unit-Tests with GNU-EFI
+
+## Introduction
+
+This dir provides code to build KVM-Unit-Tests with GNU-EFI and run the test
+cases with QEMU and UEFI.
+
+### Install dependencies
+
+The following dependencies should be installed:
+
+- [GNU-EFI](https://sourceforge.net/projects/gnu-efi): to build test cases as
+  EFI applications
+- [UEFI firmware](https://github.com/tianocore/edk2): to run test cases in QEMU
+
+### Build with GNU-EFI
+
+To build with GNU-EFI, do:
+
+    ./configure --target-efi
+    make
+
+Building UEFI tests requires the
+[GNU-EFI](https://sourceforge.net/projects/gnu-efi) library: the Makefile
+searches GNU-EFI headers under `/usr/include/efi` and static libraries under
+`/usr/lib/` by default. These paths can be overridden by `./configure` flags
+`efi-include-path` and `efi-libs-path`.
+
+### Run test cases with UEFI
+
+To run a test case with UEFI:
+
+    ./x86/efi/run ./x86/dummy.efi
+
+By default the runner script loads the UEFI firmware `/usr/share/ovmf/OVMF.fd`;
+please install UEFI firmware to this path, or specify the correct path through
+the env variable `EFI_UEFI`:
+
+    EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/dummy.efi
+
+## Code structure
+
+### Code from GNU-EFI
 
 This dir contains a linker script copied from
 [GNU-EFI](https://sourceforge.net/projects/gnu-efi/):
@@ -23,3 +65,8 @@ above-mentioned files in its build process:
 
 More details can be found in `GNU-EFI/README.gnuefi`, section "Building
 Relocatable Binaries".
+
+### Startup code for KVM-Unit-Tests in UEFI
+
+This dir also contains KVM-Unit-Tests startup code in UEFI:
+   - efistart64.S: startup code for KVM-Unit-Tests in UEFI
diff --git a/x86/efi/run b/x86/efi/run
new file mode 100755
index 0000000..72ad4a9
--- /dev/null
+++ b/x86/efi/run
@@ -0,0 +1,63 @@
+#!/bin/bash
+
+set -e
+
+if [ $# -eq 0 ]; then
+	echo "Usage $0 TEST_CASE [QEMU_ARGS]"
+	exit 2
+fi
+
+if [ ! -f config.mak ]; then
+	echo "run './configure --target-efi && make' first. See ./configure -h"
+	exit 2
+fi
+source config.mak
+
+: "${EFI_SRC:=$(realpath "$(dirname "$0")/../")}"
+: "${EFI_UEFI:=/usr/share/ovmf/OVMF.fd}"
+: "${EFI_TEST:=efi-tests}"
+: "${EFI_SMP:=1}"
+: "${EFI_CASE:=$(basename $1 .efi)}"
+
+if [ ! -f "$EFI_UEFI" ]; then
+	echo "UEFI firmware not found: $EFI_UEFI"
+	echo "Please install the UEFI firmware to this path"
+	echo "Or specify the correct path with the env variable EFI_UEFI"
+	exit 2
+fi
+
+# Remove the TEST_CASE from $@
+shift 1
+
+# Prepare EFI boot file system
+#   - Copy .efi file to host dir $EFI_TEST/$EFI_CASE/
+#     This host dir will be loaded by QEMU as a FAT32 image
+#   - Make UEFI startup script that runs the .efi on boot
+mkdir -p "$EFI_TEST/$EFI_CASE/"
+cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_TEST/$EFI_CASE/"
+
+pushd "$EFI_TEST/$EFI_CASE" || exit 2
+# 'startup.nsh' is the default script executed by UEFI on boot
+# Use this script to run the test binary automatically
+cat << EOF >startup.nsh
+@echo -off
+fs0:
+"$EFI_CASE.efi"
+EOF
+popd || exit 2
+
+# Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
+# After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
+# memory region is ~42MiB. Although this is sufficient for many test cases to
+# run in UEFI, some test cases, e.g. `x86/pmu.c`, require more free memory. A
+# simple fix is to increase the QEMU default memory size to 256MiB so that
+# UEFI's largest allocatable memory region is large enough.
+EFI_RUN=y \
+"$TEST_DIR/run" \
+	-drive file="$EFI_UEFI",format=raw,if=pflash \
+	-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw \
+	-net none \
+	-nographic \
+	-smp "$EFI_SMP" \
+	-m 256 \
+	"$@"
diff --git a/x86/run b/x86/run
index 8b2425f..4eba2b9 100755
--- a/x86/run
+++ b/x86/run
@@ -38,7 +38,19 @@ else
 fi
 
 command="${qemu} --no-reboot -nodefaults $pc_testdev -vnc none -serial stdio $pci_testdev"
-command+=" -machine accel=$ACCEL -kernel"
+command+=" -machine accel=$ACCEL"
+if ! [ "$EFI_RUN" ]; then
+	command+=" -kernel"
+fi
 command="$(timeout_cmd) $command"
 
-run_qemu ${command} "$@"
+if [ "$EFI_RUN" ]; then
+	# Set ENVIRON_DEFAULT=n to remove '-initrd' flag for QEMU (see
+	# 'scripts/arch-run.bash' for more details). This is because when using
+	# UEFI, the test case binaries are passed to QEMU through the disk
+	# image, not through the '-kernel' flag. And QEMU reports an error if it
+	# gets '-initrd' without a '-kernel'
+	ENVIRON_DEFAULT=n run_qemu ${command} "$@"
+else
+	run_qemu ${command} "$@"
+fi
-- 
2.33.0.rc1.237.g0d66db33f3-goog

