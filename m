Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E376F172D
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 14:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346022AbjD1MFo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 08:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346010AbjD1MFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 08:05:35 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F01A96582
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 05:05:19 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B00D61576;
        Fri, 28 Apr 2023 05:06:03 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE7333F5A1;
        Fri, 28 Apr 2023 05:05:18 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v5 27/29] arm64: Add support for efi in Makefile
Date:   Fri, 28 Apr 2023 13:04:03 +0100
Message-Id: <20230428120405.3770496-28-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Users can now build kvm-unit-tests as efi apps by supplying an extra
argument when invoking configure:

$> ./configure --enable-efi

This patch is based on an earlier version by
Andrew Jones <drjones@redhat.com>

Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
Reviewed-by: Ricardo Koller <ricarkol@google.com>
---
 configure           | 17 +++++++++++++----
 arm/Makefile.arm    |  6 ++++++
 arm/Makefile.arm64  | 18 ++++++++++++++----
 arm/Makefile.common | 45 ++++++++++++++++++++++++++++++++++-----------
 4 files changed, 67 insertions(+), 19 deletions(-)

diff --git a/configure b/configure
index c36fd290..b665f7d5 100755
--- a/configure
+++ b/configure
@@ -86,7 +86,7 @@ usage() {
 	               pl011,mmio32,ADDR
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
-	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 only)
+	    --[enable|disable]-efi Boot and run from UEFI (disabled by default, x86_64 and arm64 only)
 	    --[enable|disable]-werror
 	                           Select whether to compile with the -Werror compiler flag
 EOF
@@ -208,14 +208,19 @@ else
     fi
 fi
 
-if [ "$efi" ] && [ "$arch" != "x86_64" ]; then
+if [ "$efi" ] && [ "$arch" != "x86_64" ] && [ "$arch" != "arm64" ]; then
     echo "--[enable|disable]-efi is not supported for $arch"
     usage
 fi
 
 if [ -z "$page_size" ]; then
-    [ "$arch" = "arm64" ] && page_size="65536"
-    [ "$arch" = "arm" ] && page_size="4096"
+    if [ "$efi" = 'y' ] && [ "$arch" = "arm64" ]; then
+        page_size="4096"
+    elif [ "$arch" = "arm64" ]; then
+        page_size="65536"
+    elif [ "$arch" = "arm" ]; then
+        page_size="4096"
+    fi
 else
     if [ "$arch" != "arm64" ]; then
         echo "--page-size is not supported for $arch"
@@ -230,6 +235,10 @@ else
         echo "arm64 doesn't support page size of $page_size"
         usage
     fi
+    if [ "$efi" = 'y' ] && [ "$page_size" != "4096" ]; then
+        echo "efi must use 4K pages"
+        exit 1
+    fi
 fi
 
 [ -z "$processor" ] && processor="$arch"
diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 01fd4c7b..2ce00f52 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -7,6 +7,10 @@ bits = 32
 ldarch = elf32-littlearm
 machine = -marm -mfpu=vfp
 
+ifeq ($(CONFIG_EFI),y)
+$(error Cannot build arm32 tests as EFI apps)
+endif
+
 # stack.o relies on frame pointers.
 KEEP_FRAME_POINTER := y
 
@@ -32,6 +36,8 @@ cflatobjs += lib/arm/stack.o
 cflatobjs += lib/ldiv32.o
 cflatobjs += lib/arm/ldivmod.o
 
+exe = flat
+
 # arm specific tests
 tests =
 
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 6dff6cad..eada7f9a 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -31,11 +31,21 @@ endif
 
 OBJDIRS += lib/arm64
 
+ifeq ($(CONFIG_EFI),y)
+# avoid jump tables before all relocations have been processed
+arm/efi/reloc_aarch64.o: CFLAGS += -fno-jump-tables
+cflatobjs += arm/efi/reloc_aarch64.o
+
+exe = efi
+else
+exe = flat
+endif
+
 # arm64 specific tests
-tests = $(TEST_DIR)/timer.flat
-tests += $(TEST_DIR)/micro-bench.flat
-tests += $(TEST_DIR)/cache.flat
-tests += $(TEST_DIR)/debug.flat
+tests = $(TEST_DIR)/timer.$(exe)
+tests += $(TEST_DIR)/micro-bench.$(exe)
+tests += $(TEST_DIR)/cache.$(exe)
+tests += $(TEST_DIR)/debug.$(exe)
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
 
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 647b0fb1..a133309d 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -4,14 +4,14 @@
 # Authors: Andrew Jones <drjones@redhat.com>
 #
 
-tests-common  = $(TEST_DIR)/selftest.flat
-tests-common += $(TEST_DIR)/spinlock-test.flat
-tests-common += $(TEST_DIR)/pci-test.flat
-tests-common += $(TEST_DIR)/pmu.flat
-tests-common += $(TEST_DIR)/gic.flat
-tests-common += $(TEST_DIR)/psci.flat
-tests-common += $(TEST_DIR)/sieve.flat
-tests-common += $(TEST_DIR)/pl031.flat
+tests-common  = $(TEST_DIR)/selftest.$(exe)
+tests-common += $(TEST_DIR)/spinlock-test.$(exe)
+tests-common += $(TEST_DIR)/pci-test.$(exe)
+tests-common += $(TEST_DIR)/pmu.$(exe)
+tests-common += $(TEST_DIR)/gic.$(exe)
+tests-common += $(TEST_DIR)/psci.$(exe)
+tests-common += $(TEST_DIR)/sieve.$(exe)
+tests-common += $(TEST_DIR)/pl031.$(exe)
 
 tests-all = $(tests-common) $(tests)
 all: directories $(tests-all)
@@ -54,6 +54,9 @@ cflatobjs += lib/arm/smp.o
 cflatobjs += lib/arm/delay.o
 cflatobjs += lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
 cflatobjs += lib/arm/timer.o
+ifeq ($(CONFIG_EFI),y)
+cflatobjs += lib/efi.o
+endif
 
 OBJDIRS += lib/arm
 
@@ -61,6 +64,25 @@ libeabi = lib/arm/libeabi.a
 eabiobjs = lib/arm/eabi_compat.o
 
 FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
+
+ifeq ($(CONFIG_EFI),y)
+%.so: EFI_LDFLAGS += -defsym=EFI_SUBSYSTEM=0xa --no-undefined
+%.so: %.o $(FLATLIBS) $(SRCDIR)/arm/efi/elf_aarch64_efi.lds $(cstart.o)
+	$(CC) $(CFLAGS) -c -o $(@:.so=.aux.o) $(SRCDIR)/lib/auxinfo.c \
+		-DPROGNAME=\"$(@:.so=.efi)\" -DAUXFLAGS=$(AUXFLAGS)
+	$(LD) $(EFI_LDFLAGS) -o $@ -T $(SRCDIR)/arm/efi/elf_aarch64_efi.lds \
+		$(filter %.o, $^) $(FLATLIBS) $(@:.so=.aux.o) \
+		$(EFI_LIBS)
+	$(RM) $(@:.so=.aux.o)
+
+%.efi: %.so
+	$(call arch_elf_check, $^)
+	$(OBJCOPY) \
+		-j .text -j .sdata -j .data -j .dynamic -j .dynsym \
+		-j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
+		-j .reloc \
+		-O binary $^ $@
+else
 %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
 	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
@@ -74,13 +96,14 @@ FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 	$(call arch_elf_check, $^)
 	$(OBJCOPY) -O binary $^ $@
 	@chmod a-x $@
+endif
 
 $(libeabi): $(eabiobjs)
 	$(AR) rcs $@ $^
 
 arm_clean: asm_offsets_clean
-	$(RM) $(TEST_DIR)/*.{o,flat,elf} $(libeabi) $(eabiobjs) \
-	      $(TEST_DIR)/.*.d lib/arm/.*.d
+	$(RM) $(TEST_DIR)/*.{o,flat,elf,so,efi} $(libeabi) $(eabiobjs) \
+	      $(TEST_DIR)/.*.d $(TEST_DIR)/efi/.*.d lib/arm/.*.d
 
 generated-files = $(asm-offsets)
-$(tests-all:.flat=.o) $(cstart.o) $(cflatobjs): $(generated-files)
+$(tests-all:.$(exe)=.o) $(cstart.o) $(cflatobjs): $(generated-files)
-- 
2.25.1

