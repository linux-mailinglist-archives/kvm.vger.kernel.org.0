Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4434C136D
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240708AbiBWM6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240736AbiBWM55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:57:57 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4A62511A13
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 04:57:20 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 80B61139F;
        Wed, 23 Feb 2022 04:57:20 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 536F93F70D;
        Wed, 23 Feb 2022 04:57:18 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     pbonzini@redhat.com, thuth@redhat.com, drjones@redhat.com,
        varad.gautam@suse.com, zixuanwang@google.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH v2 3/3] Rename --target-efi to --[enable|disable]-efi
Date:   Wed, 23 Feb 2022 12:55:37 +0000
Message-Id: <20220223125537.41529-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220223125537.41529-1-alexandru.elisei@arm.com>
References: <20220223125537.41529-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename --target-efi to --enable-efi to make it similar to autoconf's
configure script options. Add the --disable-efi option for symmetry and to
make it easy for the option to change from disabled by default to enabled
by default in the future.

Suggested-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile             |  6 +++---
 configure            | 19 +++++++++++--------
 lib/x86/acpi.c       |  4 ++--
 lib/x86/amd_sev.h    |  4 ++--
 lib/x86/asm/page.h   |  8 ++++----
 lib/x86/asm/setup.h  |  4 ++--
 lib/x86/setup.c      |  4 ++--
 lib/x86/vm.c         | 12 ++++++------
 scripts/runtime.bash |  4 ++--
 x86/Makefile.common  |  6 +++---
 x86/Makefile.x86_64  |  6 +++---
 x86/access_test.c    |  2 +-
 x86/efi/README.md    |  2 +-
 x86/efi/run          |  2 +-
 x86/run              |  4 ++--
 15 files changed, 45 insertions(+), 42 deletions(-)

diff --git a/Makefile b/Makefile
index 5af17f129ced..24686dddb4fd 100644
--- a/Makefile
+++ b/Makefile
@@ -39,9 +39,9 @@ LIBFDT_archive = $(LIBFDT_objdir)/libfdt.a
 OBJDIRS += $(LIBFDT_objdir)
 
 # EFI App
-ifeq ($(TARGET_EFI),y)
+ifeq ($(CONFIG_EFI),y)
 EFI_ARCH = x86_64
-EFI_CFLAGS := -DTARGET_EFI
+EFI_CFLAGS := -DCONFIG_EFI
 # The following CFLAGS and LDFLAGS come from:
 #   - GNU-EFI/Makefile.defaults
 #   - GNU-EFI/apps/Makefile
@@ -81,7 +81,7 @@ COMMON_CFLAGS += $(fno_stack_protector)
 COMMON_CFLAGS += $(fno_stack_protector_all)
 COMMON_CFLAGS += $(wno_frame_address)
 COMMON_CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
-ifeq ($(TARGET_EFI),y)
+ifeq ($(CONFIG_EFI),y)
 COMMON_CFLAGS += $(EFI_CFLAGS)
 else
 COMMON_CFLAGS += $(fno_pic) $(no_pie)
diff --git a/configure b/configure
index 6620e78ec09c..6b5229b91cbb 100755
--- a/configure
+++ b/configure
@@ -29,7 +29,7 @@ host_key_document=
 gen_se_header=
 page_size=
 earlycon=
-target_efi=
+efi=
 
 usage() {
     cat <<-EOF
@@ -74,7 +74,7 @@ usage() {
 	               pl011,mmio32,ADDR
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
-	    --target-efi           Boot and run from UEFI (x86_64 only)
+	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
 EOF
     exit 1
 }
@@ -142,8 +142,11 @@ while [[ "$1" = -* ]]; do
 	--earlycon)
 	    earlycon="$arg"
 	    ;;
-	--target-efi)
-	    target_efi=y
+	--enable-efi)
+	    efi=y
+	    ;;
+	--disable-efi)
+	    efi=n
 	    ;;
 	--help)
 	    usage
@@ -177,8 +180,8 @@ else
     fi
 fi
 
-if [ "$target_efi" ] && [ "$arch" != "x86_64" ]; then
-    echo "--target-efi is not supported for $arch"
+if [ "$efi" ] && [ "$arch" != "x86_64" ]; then
+    echo "--[enable|disable]-efi is not supported for $arch"
     usage
 fi
 
@@ -278,7 +281,7 @@ if [ -f "$srcdir/$testdir/run" ]; then
 fi
 
 testsubdir=$testdir
-if [ -n "$target_efi" ]; then
+if [ "$efi" = "y" ]; then
     testsubdir=$testdir/efi
 fi
 
@@ -367,7 +370,7 @@ U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
-TARGET_EFI=$target_efi
+CONFIG_EFI=$efi
 GEN_SE_HEADER=$gen_se_header
 EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
diff --git a/lib/x86/acpi.c b/lib/x86/acpi.c
index 1a82ced0b90f..de275caf3146 100644
--- a/lib/x86/acpi.c
+++ b/lib/x86/acpi.c
@@ -1,7 +1,7 @@
 #include "libcflat.h"
 #include "acpi.h"
 
-#ifdef TARGET_EFI
+#ifdef CONFIG_EFI
 struct rsdp_descriptor *efi_rsdp = NULL;
 
 void set_efi_rsdp(struct rsdp_descriptor *rsdp)
@@ -34,7 +34,7 @@ static struct rsdp_descriptor *get_rsdp(void)
 
 	return rsdp;
 }
-#endif /* TARGET_EFI */
+#endif /* CONFIG_EFI */
 
 void* find_acpi_table_addr(u32 sig)
 {
diff --git a/lib/x86/amd_sev.h b/lib/x86/amd_sev.h
index 6a10f845daba..ed6e3385340c 100644
--- a/lib/x86/amd_sev.h
+++ b/lib/x86/amd_sev.h
@@ -12,7 +12,7 @@
 #ifndef _X86_AMD_SEV_H_
 #define _X86_AMD_SEV_H_
 
-#ifdef TARGET_EFI
+#ifdef CONFIG_EFI
 
 #include "libcflat.h"
 #include "desc.h"
@@ -58,6 +58,6 @@ void setup_ghcb_pte(pgd_t *page_table);
 unsigned long long get_amd_sev_c_bit_mask(void);
 unsigned long long get_amd_sev_addr_upperbound(void);
 
-#endif /* TARGET_EFI */
+#endif /* CONFIG_EFI */
 
 #endif /* _X86_AMD_SEV_H_ */
diff --git a/lib/x86/asm/page.h b/lib/x86/asm/page.h
index c25bc66b7aa4..298e7e8efb57 100644
--- a/lib/x86/asm/page.h
+++ b/lib/x86/asm/page.h
@@ -25,11 +25,11 @@ typedef unsigned long pgd_t;
 #define LARGE_PAGE_SIZE	(1024 * PAGE_SIZE)
 #endif
 
-#ifdef TARGET_EFI
+#ifdef CONFIG_EFI
 /* lib/x86/amd_sev.c */
 extern unsigned long long get_amd_sev_c_bit_mask(void);
 extern unsigned long long get_amd_sev_addr_upperbound(void);
-#endif /* TARGET_EFI */
+#endif /* CONFIG_EFI */
 
 #define PT_PRESENT_MASK		(1ull << 0)
 #define PT_WRITABLE_MASK	(1ull << 1)
@@ -47,11 +47,11 @@ extern unsigned long long get_amd_sev_addr_upperbound(void);
  */
 #define PT_ADDR_UPPER_BOUND_DEFAULT	(51)
 
-#ifdef TARGET_EFI
+#ifdef CONFIG_EFI
 #define PT_ADDR_UPPER_BOUND	(get_amd_sev_addr_upperbound())
 #else
 #define PT_ADDR_UPPER_BOUND	(PT_ADDR_UPPER_BOUND_DEFAULT)
-#endif /* TARGET_EFI */
+#endif /* CONFIG_EFI */
 
 #define PT_ADDR_LOWER_BOUND	(PAGE_SHIFT)
 #define PT_ADDR_MASK		GENMASK_ULL(PT_ADDR_UPPER_BOUND, PT_ADDR_LOWER_BOUND)
diff --git a/lib/x86/asm/setup.h b/lib/x86/asm/setup.h
index dbfb2a22bc1b..24d4fa9dc76a 100644
--- a/lib/x86/asm/setup.h
+++ b/lib/x86/asm/setup.h
@@ -3,7 +3,7 @@
 
 unsigned long setup_tss(u8 *stacktop);
 
-#ifdef TARGET_EFI
+#ifdef CONFIG_EFI
 #include "x86/acpi.h"
 #include "x86/apic.h"
 #include "x86/processor.h"
@@ -14,6 +14,6 @@ unsigned long setup_tss(u8 *stacktop);
 
 efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo);
 void setup_5level_page_table(void);
-#endif /* TARGET_EFI */
+#endif /* CONFIG_EFI */
 
 #endif /* _X86_ASM_SETUP_H_ */
diff --git a/lib/x86/setup.c b/lib/x86/setup.c
index bbd34682b79e..38893eddef96 100644
--- a/lib/x86/setup.c
+++ b/lib/x86/setup.c
@@ -167,7 +167,7 @@ void setup_multiboot(struct mbi_bootinfo *bi)
 	initrd_size = mods->end - mods->start;
 }
 
-#ifdef TARGET_EFI
+#ifdef CONFIG_EFI
 
 /* From x86/efi/efistart64.S */
 extern void load_idt(void);
@@ -330,7 +330,7 @@ efi_status_t setup_efi(efi_bootinfo_t *efi_bootinfo)
 	return EFI_SUCCESS;
 }
 
-#endif /* TARGET_EFI */
+#endif /* CONFIG_EFI */
 
 void setup_libcflat(void)
 {
diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 56be57be673a..25a4f5fbfe17 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -26,9 +26,9 @@ pteval_t *install_pte(pgd_t *cr3,
                 pt_page = 0;
 	    memset(new_pt, 0, PAGE_SIZE);
 	    pt[offset] = virt_to_phys(new_pt) | PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask;
-#ifdef TARGET_EFI
+#ifdef CONFIG_EFI
 	    pt[offset] |= get_amd_sev_c_bit_mask();
-#endif /* TARGET_EFI */
+#endif /* CONFIG_EFI */
 	}
 	pt = phys_to_virt(pt[offset] & PT_ADDR_MASK);
     }
@@ -98,18 +98,18 @@ pteval_t *get_pte_level(pgd_t *cr3, void *virt, int pte_level)
 pteval_t *install_large_page(pgd_t *cr3, phys_addr_t phys, void *virt)
 {
     phys_addr_t flags = PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask | PT_PAGE_SIZE_MASK;
-#ifdef TARGET_EFI
+#ifdef CONFIG_EFI
     flags |= get_amd_sev_c_bit_mask();
-#endif /* TARGET_EFI */
+#endif /* CONFIG_EFI */
     return install_pte(cr3, 2, virt, phys | flags, 0);
 }
 
 pteval_t *install_page(pgd_t *cr3, phys_addr_t phys, void *virt)
 {
     phys_addr_t flags = PT_PRESENT_MASK | PT_WRITABLE_MASK | pte_opt_mask;
-#ifdef TARGET_EFI
+#ifdef CONFIG_EFI
     flags |= get_amd_sev_c_bit_mask();
-#endif /* TARGET_EFI */
+#endif /* CONFIG_EFI */
     return install_pte(cr3, 1, virt, phys | flags, 0);
 }
 
diff --git a/scripts/runtime.bash b/scripts/runtime.bash
index 6d5fced94246..b4771f9c0e28 100644
--- a/scripts/runtime.bash
+++ b/scripts/runtime.bash
@@ -82,7 +82,7 @@ function run()
     local accel="$8"
     local timeout="${9:-$TIMEOUT}" # unittests.cfg overrides the default
 
-    if [ "${TARGET_EFI}" == "y" ]; then
+    if [ "${CONFIG_EFI}" == "y" ]; then
         kernel=$(basename $kernel .flat)
     fi
 
@@ -132,7 +132,7 @@ function run()
 
     last_line=$(premature_failure > >(tail -1)) && {
         skip=true
-        if [ "${TARGET_EFI}" == "y" ] && [[ "${last_line}" =~ "enabling apic" ]]; then
+        if [ "${CONFIG_EFI}" == "y" ] && [[ "${last_line}" =~ "enabling apic" ]]; then
             skip=false
         fi
         if [ ${skip} == true ]; then
diff --git a/x86/Makefile.common b/x86/Makefile.common
index ff02d9822321..b90398829e7b 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -22,7 +22,7 @@ cflatobjs += lib/x86/acpi.o
 cflatobjs += lib/x86/stack.o
 cflatobjs += lib/x86/fault_test.o
 cflatobjs += lib/x86/delay.o
-ifeq ($(TARGET_EFI),y)
+ifeq ($(CONFIG_EFI),y)
 cflatobjs += lib/x86/amd_sev.o
 cflatobjs += lib/efi.o
 cflatobjs += x86/efi/reloc_x86_64.o
@@ -44,7 +44,7 @@ KEEP_FRAME_POINTER := y
 
 FLATLIBS = lib/libcflat.a
 
-ifeq ($(TARGET_EFI),y)
+ifeq ($(CONFIG_EFI),y)
 .PRECIOUS: %.efi %.so
 
 %.so: %.o $(FLATLIBS) $(SRCDIR)/x86/efi/elf_x86_64_efi.lds $(cstart.o)
@@ -89,7 +89,7 @@ tests-common = $(TEST_DIR)/vmexit.$(exe) $(TEST_DIR)/tsc.$(exe) \
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
 # with the '-fPIC' flag
-ifneq ($(TARGET_EFI),y)
+ifneq ($(CONFIG_EFI),y)
 tests-common += $(TEST_DIR)/realmode.$(exe)
 endif
 
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index a3cb75ae5868..f18c1e20fd27 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -1,7 +1,7 @@
 cstart.o = $(TEST_DIR)/cstart64.o
 bits = 64
 ldarch = elf64-x86-64
-ifeq ($(TARGET_EFI),y)
+ifeq ($(CONFIG_EFI),y)
 exe = efi
 bin = so
 FORMAT = efi-app-x86_64
@@ -32,14 +32,14 @@ tests += $(TEST_DIR)/rdpru.$(exe)
 tests += $(TEST_DIR)/pks.$(exe)
 tests += $(TEST_DIR)/pmu_lbr.$(exe)
 
-ifeq ($(TARGET_EFI),y)
+ifeq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/amd_sev.$(exe)
 endif
 
 # The following test cases are disabled when building EFI tests because they
 # use absolute addresses in their inline assembly code, which cannot compile
 # with the '-fPIC' flag
-ifneq ($(TARGET_EFI),y)
+ifneq ($(CONFIG_EFI),y)
 tests += $(TEST_DIR)/access_test.$(exe)
 tests += $(TEST_DIR)/svm.$(exe)
 tests += $(TEST_DIR)/vmx.$(exe)
diff --git a/x86/access_test.c b/x86/access_test.c
index ef1243f0c151..67e9a08081c9 100644
--- a/x86/access_test.c
+++ b/x86/access_test.c
@@ -10,7 +10,7 @@ int main(void)
     printf("starting test\n\n");
     r = ac_test_run(PT_LEVEL_PML4);
 
-#ifndef TARGET_EFI
+#ifndef CONFIG_EFI
     /*
      * Not supported yet for UEFI, because setting up 5
      * level page table requires entering real mode.
diff --git a/x86/efi/README.md b/x86/efi/README.md
index a39f509cd9aa..aa1dbcdd405f 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -15,7 +15,7 @@ The following dependencies should be installed:
 
 To build:
 
-    ./configure --target-efi
+    ./configure --enable-efi
     make
 
 ### Run test cases with UEFI
diff --git a/x86/efi/run b/x86/efi/run
index ac368a59ba9f..322cb7567fdc 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -8,7 +8,7 @@ if [ $# -eq 0 ]; then
 fi
 
 if [ ! -f config.mak ]; then
-	echo "run './configure --target-efi && make' first. See ./configure -h"
+	echo "run './configure --enable-efi && make' first. See ./configure -h"
 	exit 2
 fi
 source config.mak
diff --git a/x86/run b/x86/run
index 582d1eda0fd9..4d53b72e8358 100755
--- a/x86/run
+++ b/x86/run
@@ -39,12 +39,12 @@ fi
 
 command="${qemu} --no-reboot -nodefaults $pc_testdev -vnc none -serial stdio $pci_testdev"
 command+=" -machine accel=$ACCEL"
-if [ "${TARGET_EFI}" != y ]; then
+if [ "${CONFIG_EFI}" != y ]; then
 	command+=" -kernel"
 fi
 command="$(timeout_cmd) $command"
 
-if [ "${TARGET_EFI}" = y ]; then
+if [ "${CONFIG_EFI}" = y ]; then
 	# Set ENVIRON_DEFAULT=n to remove '-initrd' flag for QEMU (see
 	# 'scripts/arch-run.bash' for more details). This is because when using
 	# UEFI, the test case binaries are passed to QEMU through the disk
-- 
2.35.1

