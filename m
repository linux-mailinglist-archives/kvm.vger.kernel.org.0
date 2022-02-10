Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4AC4B0CE1
	for <lists+kvm@lfdr.de>; Thu, 10 Feb 2022 12:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbiBJL5N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Feb 2022 06:57:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiBJL5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Feb 2022 06:57:12 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5E6EA2616
        for <kvm@vger.kernel.org>; Thu, 10 Feb 2022 03:57:13 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DEDD113E;
        Thu, 10 Feb 2022 03:57:13 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FCF13F73B;
        Thu, 10 Feb 2022 03:57:11 -0800 (PST)
Date:   Thu, 10 Feb 2022 11:57:24 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     seanjc@google.com, pbonzini@redhat.com, thuth@redhat.com,
        drjones@redhat.com, kvm@vger.kernel.org
Subject: [kvm-unit-tests BUG] x86: debug.c compilation error with --target-efi
Message-ID: <YgT9ZIEkSSWJ+YTX@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When compiling kvm-unit-tests configured with --target-efi I get the following
error:

[..]
gcc -mno-red-zone -mno-sse -mno-sse2  -fcf-protection=full -m64 -O1 -g -MMD -MF x86/.debug.d -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Werror -Wno-missing-braces  -fno-omit-frame-pointer  -fno-stack-protector    -Wno-frame-address  -DTARGET_EFI -maccumulate-outgoing-args -fshort-wchar -fPIC  -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes -std=gnu99 -ffreestanding -I /path/to/kvm-unit-tests/lib -I /path/to/kvm-unit-tests/lib/x86 -I lib   -c -o x86/debug.o x86/debug.c
ld -T /path/to/kvm-unit-tests/x86/efi/elf_x86_64_efi.lds -Bsymbolic -shared -nostdlib -o x86/debug.so \
	x86/debug.o x86/efi/efistart64.o lib/libcflat.a
ld: x86/debug.o: relocation R_X86_64_32S against `.text' can not be used when making a shared object; recompile with -fPIC
make: *** [/path/to/kvm-unit-tests/x86/Makefile.common:51: x86/debug.so] Error 1
rm x86/emulator.o x86/tsc.o x86/msr.o x86/tsc_adjust.o x86/idt_test.o x86/sieve.o x86/s3.o x86/asyncpf.o x86/rmap_chain.o x86/init.o x86/xsave.o x86/debug.o x86/pmu.o x86/kvmclock_test.o x86/pcid.o x86/umip.o x86/setjmp.o x86/eventinj.o x86/hyperv_connections.o x86/apic.o x86/dummy.o x86/hypercall.o x86/vmexit.o x86/tsx-ctrl.o x86/hyperv_synic.o x86/smap.o x86/hyperv_stimer.o x86/efi/efistart64.o x86/smptest.o

The error does not happen if the test is not configured with --target-efi.

I bisected the error to commit 9734b4236294 ("x86/debug: Add framework for
single-step #DB tests"). Changing the Makefile to build x86/debug.o when
!TARGET_EFI has fixed the issue for me (it might be that the inline assembly
added by the commit contains absolute addresses, but my knowledge of x86
assembly is sketchy at best):

diff --git a/x86/Makefile.x86_64 b/x86/Makefile.x86_64
index a3cb75ae5868..7532de46e0fd 100644
--- a/x86/Makefile.x86_64
+++ b/x86/Makefile.x86_64
@@ -21,9 +21,9 @@ cflatobjs += lib/x86/usermode.o
 tests = $(TEST_DIR)/apic.$(exe) \
          $(TEST_DIR)/emulator.$(exe) $(TEST_DIR)/idt_test.$(exe) \
          $(TEST_DIR)/xsave.$(exe) $(TEST_DIR)/rmap_chain.$(exe) \
-         $(TEST_DIR)/pcid.$(exe) $(TEST_DIR)/debug.$(exe) \
-         $(TEST_DIR)/ioapic.$(exe) $(TEST_DIR)/memory.$(exe) \
-         $(TEST_DIR)/pku.$(exe) $(TEST_DIR)/hyperv_clock.$(exe)
+         $(TEST_DIR)/pcid.$(exe) $(TEST_DIR)/ioapic.$(exe) \
+         $(TEST_DIR)/memory.$(exe) $(TEST_DIR)/pku.$(exe) \
+         $(TEST_DIR)/hyperv_clock.$(exe)
 tests += $(TEST_DIR)/syscall.$(exe)
 tests += $(TEST_DIR)/tscdeadline_latency.$(exe)
 tests += $(TEST_DIR)/intel-iommu.$(exe)
@@ -43,6 +43,7 @@ ifneq ($(TARGET_EFI),y)
 tests += $(TEST_DIR)/access_test.$(exe)
 tests += $(TEST_DIR)/svm.$(exe)
 tests += $(TEST_DIR)/vmx.$(exe)
+tests += $(TEST_DIR)/debug.$(exe)
 endif

 ifneq ($(fcf_protection_full),)

For reference:

$ gcc --version
gcc (GCC) 11.1.0
Copyright (C) 2021 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ cat config.mak
SRCDIR=/path/to/kvm-unit-tests
PREFIX=/usr/local
HOST=x86_64
ARCH=x86_64
ARCH_NAME=x86_64
PROCESSOR=x86_64
CC=gcc
CFLAGS=
LD=ld
OBJCOPY=objcopy
OBJDUMP=objdump
AR=ar
ADDR2LINE=addr2line
TEST_DIR=x86
TEST_SUBDIR=x86/efi
FIRMWARE=
ENDIAN=
PRETTY_PRINT_STACKS=yes
ENVIRON_DEFAULT=yes
ERRATATXT=/path/to/kvm-unit-tests/errata.txt
U32_LONG_FMT=
WA_DIVIDE=
GENPROTIMG=genprotimg
HOST_KEY_DOCUMENT=
TARGET_EFI=y
GEN_SE_HEADER=

Thanks,
Alex
