Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900753BA005
	for <lists+kvm@lfdr.de>; Fri,  2 Jul 2021 13:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhGBLvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jul 2021 07:51:22 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:44702 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbhGBLvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jul 2021 07:51:21 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 522CD20557;
        Fri,  2 Jul 2021 11:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=viaNN5lXbG6i5JvXaa7rqiR1JW41BibUPNd3/VAek/Y=;
        b=qhCczdAnGAOMLnHQGP6b32On5fEW4dncc0c9thEU3gw59QX8KYMKml8A2ZSjlvdQ2xfcAI
        Yf91u2vTieir6EPl6ln9srwmcES+X+LJq0apSY15fCwf9voK6G/4J6fT2YMKwNfa2Nr4TB
        nShu45/RJ/x6UeDlitbxex5pMGJtepM=
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id DDC3411C84;
        Fri,  2 Jul 2021 11:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1625226528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=viaNN5lXbG6i5JvXaa7rqiR1JW41BibUPNd3/VAek/Y=;
        b=qhCczdAnGAOMLnHQGP6b32On5fEW4dncc0c9thEU3gw59QX8KYMKml8A2ZSjlvdQ2xfcAI
        Yf91u2vTieir6EPl6ln9srwmcES+X+LJq0apSY15fCwf9voK6G/4J6fT2YMKwNfa2Nr4TB
        nShu45/RJ/x6UeDlitbxex5pMGJtepM=
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id qHSkNB/93mDDDAAALh3uQQ
        (envelope-from <varad.gautam@suse.com>); Fri, 02 Jul 2021 11:48:47 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, jroedel@suse.de,
        bp@suse.de, thomas.lendacky@amd.com, brijesh.singh@amd.com,
        varad.gautam@suse.com
Subject: [kvm-unit-tests PATCH 1/6] x86: Build tests as PE objects for the EFI loader
Date:   Fri,  2 Jul 2021 13:48:15 +0200
Message-Id: <20210702114820.16712-2-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210702114820.16712-1-varad.gautam@suse.com>
References: <20210702114820.16712-1-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm-unit-tests produces tests as ELF binaries that can't be directly
loaded with EFI. One way of doing so however, is to build the tests
as shared libs (-pic, -shared), and then objcopy-ing out the relevant
sections into a PE32+.

This adds support to compile the tests as an intermediary .so lib,
which is linked via x86/efi.lds to contain 4K aligned COFF-compatible
sections. The linker script sets up _efi_pe_entry as the image
entrypoint, and the .so sections get repackaged to an EFI binary via
`objcopy --target efi-app-x86_64`.

The 32-bit / long mode transition / multiboot / AP setup code within
cstart64.S being incompatible with EFI builds is now hidden behind
!CONFIG_EFI. It stays enabled without `configure --efi`.

Some tests that don't support building with -fpic / -shared (and need
some cleanups) are also moved to build on non-EFI only for now.

This gets us dud EFI binaries that enter into _efi_pe_entry and die.
No change to non- --efi builds.

Signed-off-by: Varad Gautam <varad.gautam@suse.com>
---
 .gitignore          |  2 ++
 Makefile            | 16 +++++++++--
 configure           | 11 ++++++++
 x86/Makefile.common | 44 +++++++++++++++++++----------
 x86/Makefile.x86_64 | 43 ++++++++++++++++++-----------
 x86/cstart64.S      | 27 +++++++++++++++++-
 x86/efi.lds         | 67 +++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 177 insertions(+), 33 deletions(-)
 create mode 100644 x86/efi.lds

diff --git a/.gitignore b/.gitignore
index 8534fb7..81ee499 100644
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
diff --git a/Makefile b/Makefile
index f7b9f28..273b1df 100644
--- a/Makefile
+++ b/Makefile
@@ -50,7 +50,11 @@ fomit_frame_pointer := $(call cc-option, $(frame-pointer-flag), "")
 fno_stack_protector := $(call cc-option, -fno-stack-protector, "")
 fno_stack_protector_all := $(call cc-option, -fno-stack-protector-all, "")
 wno_frame_address := $(call cc-option, -Wno-frame-address, "")
-fno_pic := $(call cc-option, -fno-pic, "")
+ifeq ($(CONFIG_EFI), y)
+opt_pic := -fpic
+else
+opt_pic := $(call cc-option, -fno-pic, "")
+endif
 no_pie := $(call cc-option, -no-pie, "")
 wclobbered := $(call cc-option, -Wclobbered, "")
 wunused_but_set_parameter := $(call cc-option, -Wunused-but-set-parameter, "")
@@ -62,10 +66,15 @@ COMMON_CFLAGS += $(fno_stack_protector)
 COMMON_CFLAGS += $(fno_stack_protector_all)
 COMMON_CFLAGS += $(wno_frame_address)
 COMMON_CFLAGS += $(if $(U32_LONG_FMT),-D__U32_LONG_FMT__,)
-COMMON_CFLAGS += $(fno_pic) $(no_pie)
+COMMON_CFLAGS += $(opt_pic) $(no_pie)
 COMMON_CFLAGS += $(wclobbered)
 COMMON_CFLAGS += $(wunused_but_set_parameter)
 
+ifeq ($(CONFIG_EFI),y)
+COMMON_CFLAGS += -mno-red-zone -fshort-wchar -DCONFIG_EFI -ffreestanding \
+	-fno-stack-check
+endif
+
 CFLAGS += $(COMMON_CFLAGS)
 CFLAGS += $(wmissing_parameter_type)
 CFLAGS += $(wold_style_declaration)
@@ -74,6 +83,9 @@ CFLAGS += -Woverride-init -Wmissing-prototypes -Wstrict-prototypes
 autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d
 
 LDFLAGS += $(CFLAGS)
+ifeq ($(CONFIG_EFI),y)
+LDFLAGS += -nostdlib --warn-common --no-undefined --fatal-warnings
+endif
 
 $(libcflat): $(cflatobjs)
 	$(AR) rcs $@ $^
diff --git a/configure b/configure
index 395c809..e14b9ec 100755
--- a/configure
+++ b/configure
@@ -28,6 +28,7 @@ erratatxt="$srcdir/errata.txt"
 host_key_document=
 page_size=
 earlycon=
+config_efi=
 
 usage() {
     cat <<-EOF
@@ -69,6 +70,7 @@ usage() {
 	               pl011,mmio32,ADDR
 	                           Specify a PL011 compatible UART at address ADDR. Supported
 	                           register stride is 32 bit only.
+	    --efi                  Build with EFI support (x86_64 only).
 EOF
     exit 1
 }
@@ -133,6 +135,9 @@ while [[ "$1" = -* ]]; do
 	--earlycon)
 	    earlycon="$arg"
 	    ;;
+	--efi)
+	    config_efi=y
+	    ;;
 	--help)
 	    usage
 	    ;;
@@ -192,6 +197,11 @@ elif [ "$processor" = "arm" ]; then
     processor="cortex-a15"
 fi
 
+if [ "$config_efi" = y ] && [ "$arch" != "x86_64" ]; then
+    echo "--efi only supported on x86_64"
+    usage
+fi
+
 if [ "$arch" = "i386" ] || [ "$arch" = "x86_64" ]; then
     testdir=x86
 elif [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
@@ -337,6 +347,7 @@ U32_LONG_FMT=$u32_long
 WA_DIVIDE=$wa_divide
 GENPROTIMG=${GENPROTIMG-genprotimg}
 HOST_KEY_DOCUMENT=$host_key_document
+CONFIG_EFI=$config_efi
 EOF
 if [ "$arch" = "arm" ] || [ "$arch" = "arm64" ]; then
     echo "TARGET=$target" >> config.mak
diff --git a/x86/Makefile.common b/x86/Makefile.common
index 52bb7aa..837a8a5 100644
--- a/x86/Makefile.common
+++ b/x86/Makefile.common
@@ -38,7 +38,7 @@ COMMON_CFLAGS += -O1
 KEEP_FRAME_POINTER := y
 
 # We want to keep intermediate file: %.elf and %.o 
-.PRECIOUS: %.elf %.o
+.PRECIOUS: %.elf %.o %.so
 
 FLATLIBS = lib/libcflat.a
 %.elf: %.o $(FLATLIBS) $(SRCDIR)/x86/flat.lds $(cstart.o)
@@ -50,17 +50,33 @@ FLATLIBS = lib/libcflat.a
 	$(OBJCOPY) -O elf32-i386 $^ $@
 	@chmod a-x $@
 
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
+%.so: %.o $(FLATLIBS) $(cstart.o)
+	$(LD) -shared -nostdlib -znocombreloc -Bsymbolic -T $(SRCDIR)/x86/efi.lds $^ \
+		-o $@ $(FLATLIBS)
+	@chmod a-x $@
+
+%.efi: %.so
+	$(OBJCOPY) -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel \
+		    -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* \
+		    -j .reloc -j .init --target efi-app-x86_64 $*.so $@
+	@chmod a-x $@
+
+tests-flatonly = $(TEST_DIR)/realmode.$(out) $(TEST_DIR)/eventinj.$(out)		\
+		$(TEST_DIR)/smap.$(out) $(TEST_DIR)/umip.$(out)
+
+tests-common = $(TEST_DIR)/vmexit.$(out) $(TEST_DIR)/tsc.$(out)				\
+		$(TEST_DIR)/smptest.$(out) $(TEST_DIR)/msr.$(out)			\
+		$(TEST_DIR)/hypercall.$(out) $(TEST_DIR)/sieve.$(out)			\
+		$(TEST_DIR)/kvmclock_test.$(out) $(TEST_DIR)/s3.$(out)			\
+		$(TEST_DIR)/pmu.$(out) $(TEST_DIR)/setjmp.$(out)			\
+		$(TEST_DIR)/tsc_adjust.$(out) $(TEST_DIR)/asyncpf.$(out)		\
+		$(TEST_DIR)/init.$(out) $(TEST_DIR)/hyperv_synic.$(out)			\
+		$(TEST_DIR)/hyperv_stimer.$(out) $(TEST_DIR)/hyperv_connections.$(out)	\
+		$(TEST_DIR)/tsx-ctrl.$(out)
+
+ifneq ($(CONFIG_EFI),y)
+tests-common += $(tests-flatonly)
+endif
 
 test_cases: $(tests-common) $(tests)
 
@@ -81,5 +97,5 @@ $(TEST_DIR)/hyperv_stimer.elf: $(TEST_DIR)/hyperv.o
 $(TEST_DIR)/hyperv_connections.elf: $(TEST_DIR)/hyperv.o
 
 arch_clean:
-	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.flat $(TEST_DIR)/*.elf \
-	$(TEST_DIR)/.*.d lib/x86/.*.d \
+	$(RM) $(TEST_DIR)/*.o $(TEST_DIR)/*.$(out) $(TEST_DIR)/*.elf \
+	$(TEST_DIR)/.*.d lib/x86/.*.d $(TEST_DIR)/*.so  \
diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index 8134952..26970ab 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -5,28 +5,39 @@ ldarch = elf64-x86-64
 fcf_protection_full := $(call cc-option, -fcf-protection=full,)
 COMMON_CFLAGS += -mno-red-zone -mno-sse -mno-sse2 $(fcf_protection_full)
 
+ifeq ($(CONFIG_EFI),y)
+out = efi
+else
+out = flat
+endif
+
 cflatobjs += lib/x86/setjmp64.o
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
+# Tests that have relocation / PIC problems and need more attention for EFI.
+tests_flatonly = $(TEST_DIR)/access.$(out) $(TEST_DIR)/emulator.$(out) \
+	$(TEST_DIR)/svm.$(out) $(TEST_DIR)/vmx.$(out) \
+	$(TEST_DIR)/vmware_backdoors.$(out)
+
+tests = $(TEST_DIR)/apic.$(out) $(TEST_DIR)/idt_test.$(out) \
+	  $(TEST_DIR)/xsave.$(out) $(TEST_DIR)/rmap_chain.$(out) \
+	  $(TEST_DIR)/pcid.$(out) $(TEST_DIR)/debug.$(out) \
+	  $(TEST_DIR)/ioapic.$(out) $(TEST_DIR)/memory.$(out) \
+	  $(TEST_DIR)/pku.$(out) $(TEST_DIR)/hyperv_clock.$(out)
+tests += $(TEST_DIR)/syscall.$(out)
+tests += $(TEST_DIR)/tscdeadline_latency.$(out)
+tests += $(TEST_DIR)/intel-iommu.$(out)
+tests += $(TEST_DIR)/rdpru.$(out)
+tests += $(TEST_DIR)/pks.$(out)
+tests += $(TEST_DIR)/pmu_lbr.$(out)
 
 ifneq ($(fcf_protection_full),)
-tests += $(TEST_DIR)/cet.flat
+tests_flatonly += $(TEST_DIR)/cet.$(out)
+endif
+
+ifneq ($(CONFIG_EFI),y)
+tests += $(tests_flatonly)
 endif
 
 include $(SRCDIR)/$(TEST_DIR)/Makefile.common
diff --git a/x86/cstart64.S b/x86/cstart64.S
index 5c6ad38..404fcac 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -101,20 +101,26 @@ i = i + 1
 	.endr
 tss_end:
 
+#ifndef CONFIG_EFI
 mb_boot_info:	.quad 0
+#endif
 
 pt_root:	.quad ptl4
 
+#ifndef CONFIG_EFI
 .section .init
+#endif
 
 .code32
 
+#ifndef CONFIG_EFI
 mb_magic = 0x1BADB002
 mb_flags = 0x0
 
 	# multiboot header
 	.long mb_magic, mb_flags, 0 - (mb_magic + mb_flags)
 mb_cmdline = 16
+#endif
 
 MSR_GS_BASE = 0xc0000101
 
@@ -140,6 +146,7 @@ MSR_GS_BASE = 0xc0000101
 	wrmsr
 .endm
 
+#ifndef CONFIG_EFI
 .globl start
 start:
 	mov %ebx, mb_boot_info
@@ -231,16 +238,20 @@ ap_start32:
 	setup_percpu_area
 	call prepare_64
 	ljmpl $8, $ap_start64
+#endif	/* CONFIG_EFI */
 
 .code64
 save_id:
+#ifndef CONFIG_EFI
 	movl $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
 	movl (%rax), %eax
 	shrl $24, %eax
 	lock btsl %eax, online_cpus
+#endif
 	retq
 
 ap_start64:
+#ifndef CONFIG_EFI
 	call reset_apic
 	call load_tss
 	call enable_apic
@@ -249,11 +260,18 @@ ap_start64:
 	sti
 	nop
 	lock incw cpu_online_count
-
+#endif
 1:	hlt
 	jmp 1b
 
+#ifdef CONFIG_EFI
+.globl _efi_pe_entry
+_efi_pe_entry:
+	ret
+#endif
+
 start64:
+#ifndef CONFIG_EFI
 	call reset_apic
 	call load_tss
 	call mask_pic_interrupts
@@ -277,9 +295,11 @@ start64:
 	call main
 	mov %eax, %edi
 	call exit
+#endif
 
 .globl setup_5level_page_table
 setup_5level_page_table:
+#ifndef CONFIG_EFI
 	/* Check if 5-level paging has already enabled */
 	mov %cr4, %rax
 	test $0x1000, %eax
@@ -287,6 +307,7 @@ setup_5level_page_table:
 
 	pushq $32
 	pushq $switch_to_5level
+#endif
 	lretq
 lvl5:
 	retq
@@ -299,6 +320,7 @@ online_cpus:
 	.fill (max_cpus + 7) / 8, 1, 0
 
 load_tss:
+#ifndef CONFIG_EFI
 	lidtq idt_descr
 	mov $(APIC_DEFAULT_PHYS_BASE + APIC_ID), %eax
 	mov (%rax), %eax
@@ -317,9 +339,11 @@ load_tss:
 	mov %eax, tss_descr+8(%rbx)
 	lea tss_descr-gdt64(%rbx), %rax
 	ltr %ax
+#endif
 	ret
 
 ap_init:
+#ifndef CONFIG_EFI
 	cld
 	lea sipi_entry, %rsi
 	xor %rdi, %rdi
@@ -332,6 +356,7 @@ ap_init:
 1:	pause
 	cmpw %ax, cpu_online_count
 	jne 1b
+#endif
 	ret
 
 cpu_online_count:	.word 1
diff --git a/x86/efi.lds b/x86/efi.lds
new file mode 100644
index 0000000..9ed1272
--- /dev/null
+++ b/x86/efi.lds
@@ -0,0 +1,67 @@
+/* Same as gnu-efi's elf_x86_64_fbsd_efi.lds. */
+OUTPUT_FORMAT("elf64-x86-64", "elf64-x86-64", "elf64-x86-64")
+OUTPUT_ARCH(i386:x86-64)
+ENTRY(_efi_pe_entry)
+SECTIONS
+{
+	. = 0;
+	ImageBase = .;
+	.hash : { *(.hash) }
+	.gnu.hash : { *(.gnu.hash) }
+	. = ALIGN(4096);
+	.text :
+	{
+		_text = .;
+		*(.text)
+		*(.text.*)
+		*(.gnu.linkonce.t.*)
+		. = ALIGN(16);
+	}
+	_etext = .;
+	_text_size = . - _text;
+	. = ALIGN(4096);
+	.reloc :
+	{
+		LONG(_data);
+		LONG(10);
+		SHORT(0);
+		*(.reloc)
+	}
+	. = ALIGN(4096);
+	.data :
+	{
+		_data = .;
+		exception_table_start = .;
+		*(.data.ex)
+		exception_table_end = .;
+		*(.rodata*)
+		*(.got.plt)
+		*(.got)
+		*(.data*)
+		*(.sdata)
+		*(.sbss)
+		*(.scommon)
+		*(.dynbss)
+		*(.bss)
+		*(COMMON)
+		*(.rel.local)
+	}
+	.note.gnu.build-id : { *(.note.gnu.build-id) }
+	edata = .;
+	_data_size = . - _etext;
+	. = ALIGN(4096);
+	.dynamic  : { *(.dynamic) }
+	. = ALIGN(4096);
+	.rela :
+	{
+		*(.rela.data*)
+		*(.rela.got)
+		*(.rela.stab)
+	}
+	. = ALIGN(4096);
+	.dynsym   : { *(.dynsym) }
+	. = ALIGN(4096);
+	.dynstr   : { *(.dynstr) }
+	. = ALIGN(4096);
+	.comment 0 : { *(.comment) }
+}
-- 
2.30.2

