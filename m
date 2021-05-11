Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200CC37AAF9
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 17:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbhEKPnp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 11:43:45 -0400
Received: from foss.arm.com ([217.140.110.172]:50072 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231609AbhEKPno (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 11:43:44 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5AF8D6E;
        Tue, 11 May 2021 08:42:37 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F31D13F718;
        Tue, 11 May 2021 08:42:36 -0700 (PDT)
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        kvm-devel <kvm@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [kvm-unit-tests BUG] lib/ldiv32.c breaks arm compilation
Message-ID: <348f023d-f313-3d98-dc18-b53b6879fe45@arm.com>
Date:   Tue, 11 May 2021 16:43:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

Commit 0b2d3dafc0d3 ("libcflat: provide long division routines"), which added the
lib/ldiv32.c file, breaks compilation for the arm architecture; arm64 seems to be
working just fine.

On Arch Linux:

$ ./configure --arch=arm --cross-prefix=arm-none-eabi-
$ make clean && make
rm -f lib/arm/asm-offsets.h lib/arm/asm-offsets.s \
      lib/generated/asm-offsets.h
rm -f arm/*.{o,flat,elf} lib/arm/libeabi.a lib/arm/eabi_compat.o \
      arm/.*.d lib/arm/.*.d
  CLEAN (libfdt)
rm -f lib/libfdt/*.o lib/libfdt/.*.d
rm -f lib/libfdt/libfdt.so.1
rm -f lib/libfdt/libfdt.a
rm -f lib/.*.d lib/libcflat.a lib/argv.o lib/printf.o lib/string.o lib/abort.o
lib/report.o lib/stack.o lib/arm/spinlock.o lib/arm/processor.o lib/arm/stack.o
lib/ldiv32.o lib/util.o lib/getchar.o lib/alloc_phys.o lib/alloc_page.o
lib/vmalloc.o lib/alloc.o lib/devicetree.o lib/pci.o lib/pci-host-generic.o
lib/pci-testdev.o lib/virtio.o lib/virtio-mmio.o lib/chr-testdev.o lib/arm/io.o
lib/arm/setup.o lib/arm/mmu.o lib/arm/bitops.o lib/arm/psci.o lib/arm/smp.o
lib/arm/delay.o lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
[..]
arm-none-eabi-gcc -marm -mfpu=vfp -mcpu=cortex-a15 -mno-unaligned-access
-std=gnu99 -ffreestanding -O2 -I /home/alex/data/repos/kvm-unit-tests/lib -I
/home/alex/data/repos/kvm-unit-tests/lib/libfdt -I lib -g -MMD -MF lib/.ldiv32.d
-fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body
-Wuninitialized -Wignored-qualifiers -Werror  -fno-omit-frame-pointer 
-fno-stack-protector    -Wno-frame-address -D__U32_LONG_FMT__  -fno-pic  -no-pie 
-Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type 
-Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes  
-c -o lib/ldiv32.o lib/ldiv32.c
lib/ldiv32.c: In function '__moddi3':
lib/ldiv32.c:73:11: error: 'rem' may be used uninitialized in this function
[-Werror=maybe-uninitialized]
   73 |  uint64_t rem;
      |           ^~~
lib/ldiv32.c: In function '__umoddi3':
lib/ldiv32.c:75:9: error: 'rem' may be used uninitialized in this function
[-Werror=maybe-uninitialized]
   75 |  return rem;
      |         ^~~
cc1: all warnings being treated as errors
make: *** [<builtin>: lib/ldiv32.o] Error 1
$ arm-none-eabi-gcc --version
arm-none-eabi-gcc (Arch Repository) 10.3.0
Copyright (C) 2020 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

On Fedora 33:

$ ./configure --arch=arm --cross-prefix=arm-linux-gnu-
$ make clean && make
rm -f lib/arm/asm-offsets.h lib/arm/asm-offsets.s \
      lib/generated/asm-offsets.h
rm -f arm/*.{o,flat,elf} lib/arm/libeabi.a lib/arm/eabi_compat.o \
      arm/.*.d lib/arm/.*.d
  CLEAN (libfdt)
rm -f lib/libfdt/*.o lib/libfdt/.*.d
rm -f lib/libfdt/libfdt.so.1
rm -f lib/libfdt/libfdt.a
rm -f lib/.*.d lib/libcflat.a lib/argv.o lib/printf.o lib/string.o lib/abort.o
lib/report.o lib/stack.o lib/arm/spinlock.o lib/arm/processor.o lib/arm/stack.o
lib/ldiv32.o lib/util.o lib/getchar.o lib/alloc_phys.o lib/alloc_page.o
lib/vmalloc.o lib/alloc.o lib/devicetree.o lib/pci.o lib/pci-host-generic.o
lib/pci-testdev.o lib/virtio.o lib/virtio-mmio.o lib/chr-testdev.o lib/arm/io.o
lib/arm/setup.o lib/arm/mmu.o lib/arm/bitops.o lib/arm/psci.o lib/arm/smp.o
lib/arm/delay.o lib/arm/gic.o lib/arm/gic-v2.o lib/arm/gic-v3.o
[..]
arm-linux-gnu-gcc -marm -mfpu=vfp -mcpu=cortex-a15 -mno-unaligned-access
-std=gnu99 -ffreestanding -O2 -I /home/alex/data/repos/kvm-unit-tests/lib -I
/home/alex/data/repos/kvm-unit-tests/lib/libfdt -I lib -g -MMD -MF lib/.ldiv32.d
-fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body
-Wuninitialized -Wignored-qualifiers -Werror  -fno-omit-frame-pointer 
-fno-stack-protector    -Wno-frame-address   -fno-pic  -no-pie  -Wclobbered 
-Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration
-Woverride-init -Wmissing-prototypes -Wstrict-prototypes   -c -o lib/ldiv32.o
lib/ldiv32.c
lib/ldiv32.c:1:10: fatal error: inttypes.h: No such file or directory
    1 | #include <inttypes.h>
      |          ^~~~~~~~~~~~
compilation terminated.
make: *** [<builtin>: lib/ldiv32.o] Error 1
$ arm-linux-gnu-gcc --version
arm-linux-gnu-gcc (GCC) 10.2.1 20200826 (Red Hat Cross 10.2.1-3)
Copyright (C) 2020 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Reverting the commit makes arm build again. I am not familiar with toolchains, and
unfortunately I can't propose a fix.

Thanks,

Alex

