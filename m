Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2551C57A2FC
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 17:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiGSP2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 11:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiGSP2K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 11:28:10 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 803F456BA9
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 08:28:00 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8F291570;
        Tue, 19 Jul 2022 08:28:00 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 100D73F70D;
        Tue, 19 Jul 2022 08:27:58 -0700 (PDT)
Date:   Tue, 19 Jul 2022 16:28:31 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, pbonzini@redhat.com,
        jade.alglave@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 00/27] EFI and ACPI support for arm64
Message-ID: <YtbNin3VTyIT/yYF@monolith.localdoman>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I've been trying to test the seris and I've come across some issues.

I've been using the target-efi-upstream-v3-rebased branch.

When compiling, I encounter this error:

gcc -mstrict-align  -mno-outline-atomics -std=gnu99 -ffreestanding -O2 -I /path/to/kvm-unit-tests/lib -I /path/to/kvm-unit-tests/lib/libfdt -I lib -g -MMD -MF lib/arm/.timer.d -fno-strict-aliasing -fno-common -Wall -Wwrite-strings -Wempty-body -Wuninitialized -Wignored-qualifiers -Wno-missing-braces -Werror  -fomit-frame-pointer  -fno-stack-protector    -Wno-frame-address   -fno-pic  -no-pie  -Wclobbered  -Wunused-but-set-parameter  -Wmissing-parameter-type  -Wold-style-declaration -Woverride-init -Wmissing-prototypes -Wstrict-prototypes   -c -o lib/arm/timer.o lib/arm/timer.c
lib/arm/gic.c: In function ‘gic_init_acpi’:
lib/arm/gic.c:241:21: error: the comparison will always evaluate as ‘true’ for the address of ‘redist_base’ will never be NULL [-Werror=address]
  241 |                 if (!gicv3_data.redist_base)
      |                     ^
In file included from /path/to//kvm-unit-tests/lib/asm/gic-v3.h:1,
                 from /path/to//kvm-unit-tests/lib/asm/../../arm/asm/gic.h:43,
                 from /path/to//kvm-unit-tests/lib/asm/gic.h:1,
                 from lib/arm/gic.c:8:
/path/to//kvm-unit-tests/lib/asm/../../arm/asm/gic-v3.h:82:15: note: ‘redist_base’ declared here
   82 |         void *redist_base[NR_CPUS];
      |               ^~~~~~~~~~~

This happens with --enable-efi both set and unset (the above snippet is
from when I didn't specify --enable-efi).

For reference:

$ gcc --version
gcc (GCC) 12.1.0
Copyright (C) 2022 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

I managed to fix the compilation error by commenting out the
gicv3_acpi_parse_madt_gicc call:

diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 69521c3fde4f..66066ca84a96 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -179,6 +179,7 @@ static int gicv2_acpi_parse_madt_dist(struct acpi_subtable_header *header)
        return 0;
 }

+/*
 static int gicv3_acpi_parse_madt_gicc(struct acpi_subtable_header *header)
 {
        struct acpi_madt_generic_interrupt *gicc = (void *)header;
@@ -195,6 +196,7 @@ static int gicv3_acpi_parse_madt_gicc(struct acpi_subtable_header *header)

        return 0;
 }
+*/

 static int gicv3_acpi_parse_madt_dist(struct acpi_subtable_header *header)
 {
@@ -238,9 +240,11 @@ static int gic_init_acpi(void)
                                      gicv3_acpi_parse_madt_dist);
                acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
                                      gicv3_acpi_parse_madt_redist);
+               /*
                if (!gicv3_data.redist_base)
                        acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
                                              gicv3_acpi_parse_madt_gicc);
+                                             */
                acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_TRANSLATOR,
                                      gicv3_acpi_parse_madt_its);

I don't think this is the right fix, but I made the changes to get
kvm-unit-test to build.

The second error I'm encountering is when I try the selftest-setup test:

[..]
ProtectUefiImageCommon - 0x4D046040
  - 0x000000004BEC4000 - 0x000000000001F600
SetUefiImageMemoryAttributes - 0x000000004BEC4000 - 0x0000000000001000 (0x0000000000004008)
SetUefiImageMemoryAttributes - 0x000000004BEC5000 - 0x0000000000010000 (0x0000000000020008)
SetUefiImageMemoryAttributes - 0x000000004BED5000 - 0x000000000000F000 (0x0000000000004008)
InstallProtocolInterface: 752F3136-4E16-4FDC-A22A-E5F46812F4CA 4F8014E8
SetUefiImageMemoryAttributes - 0x000000004F640000 - 0x0000000000040000 (0x0000000000000008)
SetUefiImageMemoryAttributes - 0x000000004C2D0000 - 0x0000000000040000 (0x0000000000000008)
SetUefiImageMemoryAttributes - 0x000000004C280000 - 0x0000000000040000 (0x0000000000000008)
SetUefiImageMemoryAttributes - 0x000000004C230000 - 0x0000000000040000 (0x0000000000000008)
SetUefiImageMemoryAttributes - 0x000000004C140000 - 0x0000000000040000 (0x0000000000000008)
SetUefiImageMemoryAttributes - 0x000000004F600000 - 0x0000000000030000 (0x0000000000000008)
SetUefiImageMemoryAttributes - 0x000000004C040000 - 0x0000000000030000 (0x0000000000000008)
SetUefiImageMemoryAttributes - 0x000000004BFC0000 - 0x0000000000030000 (0x0000000000000008)
Load address: 4bec4000
PC: 4beca400 PC offset: 6400
Unhandled exception ec=0x25 (DABT_EL1)
Vector: 4 (el1h_sync)
ESR_EL1:         96000000, ec=0x25 (DABT_EL1)
FAR_EL1: 0000fffffffff0f8 (valid)
Exception frame registers:
pc : [<000000004beca400>] lr : [<000000004beca42c>] pstate: 400002c5
sp : 000000004f7ffe40
x29: 000000004f7ffff0 x28: 0000000000000000
x27: 000000004d046040 x26: 0000000000000000
x25: 0000000000000703 x24: 0000000000000050
x23: 0000000009011000 x22: 0000000000000000
x21: 000000000000001f x20: 0000fffffffff000
x19: 0000000043f92000 x18: 0000000000000000
x17: 00000000ffffa6ab x16: 000000004f513ebc
x15: 0000000000000002 x14: 000000004bed5000
x13: 000000004bee4000 x12: 000000004bed4000
x11: 000000004bec4000 x10: 000000004c03febc
x9 : 000000004bee2938 x8 : 0000000000000000
x7 : 0000000000000000 x6 : 000000004bee2900
x5 : 000000004bee2908 x4 : 0000000048000000
x3 : 0000000048000000 x2 : 000000004bee2928
x1 : 0000000000000003 x0 : ffffffffffffffff


EXIT: STATUS=127

The preceding lines were omitted for brevity, the entire log can be found
at [1] (expires in 6 months).

Command used to launch the test:

$ QEMU=/path/to/qemu/build/qemu-system-aarch64 EFI_UEFI=/path/to/QEMU_EFI.fd taskset -c 4-5 arm/efi/run arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"

qemu has been built from source, tag v7.0.0, configured with:

$ ./configure --target-list=aarch64-softmmu --disable-vnc --disable-gtk --disable-bpf

EDK2 image has been built from commit e1eef3a8b01a ("NetworkPkg: Add Wi-Fi
Wpa3 support in WifiConnectManager"):

$ build -a AARCH64 -t GCC5 -p ArmVirtPkg/ArmVirtQemu.dsc -b DEBUG

I tried to disassemble selftest.efi: $ objdump -d selftest.efi, but there
were no debug symbols in the output and it was impossible to figure what is
going on.

[1] https://pastebin.com/0mcap1BU

Thanks,
Alex

On Thu, Jun 30, 2022 at 11:02:57AM +0100, Nikos Nikoleris wrote:
> Hello,
> 
> This patch series adds initial support for building arm64 tests as EFI
> tests and running them under QEMU. Much like x86_64 we import external
> dependencies from gnu-efi and adapt them to work with types and other
> assumptions from kvm-unit-tests. In addition, this series adds support
> for enumerating parts of the system using ACPI.
> 
> The first set of patches moves the existing ACPI code to the common
> lib path. Then, it extends definitions and functions to allow for more
> robust discovery of ACPI tables. In arm64, we add support for setting
> up the PSCI conduit, discovering the UART, timers and cpus via
> ACPI. The code retains existing behavior and gives priority to
> discovery through DT when one has been provided.
> 
> In the second set of patches, we add support for getting the command
> line from the EFI shell. This is a requirement for many of the
> existing arm64 tests.
> 
> In the third set of patches, we import code from gnu-efi, make minor
> changes and add an alternative setup sequence from arm64 systems that
> boot through EFI. Finally, we add support in the build system and a
> run script which is used to run an EFI app.
> 
> After this set of patches one can build arm64 EFI tests:
> 
> $> ./configure --enable-efi
> $> make
> 
> And use the run script to run an EFI tests:
> 
> $> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
> 
> Or all tests:
> 
> $> ./run_tests.sh
> 
> There are a few items that this series does not address but they would
> be useful to have:
>  - Support for booting the system from EL2. Currently, we assume that a
>    tests starts running at EL1. This the case when we run with EFI, it's
>    not always the case in hardware.
>  - Support for reading environment variables and populating __envp.
>  - Support for discovering the PCI subsystem using ACPI.
>  - Get rid of other assumptions (e.g., vmalloc area) that don't hold on real HW.
> 
> git branch: https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v3-rebased
> 
> v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/
> 
> Changes in v3:
>  - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
>  - Added support for discovering the GIC through ACPI
>  - Added a missing header file (<elf.h>)
>  - Added support for correctly parsing the outcome of tests (./run_tests)
> 
> Thanks,
> 
> Nikos
> 
> Alexandru Elisei (1):
>   lib: arm: Print test exit status
> 
> Andrew Jones (3):
>   arm/arm64: mmu_disable: Clean and invalidate before disabling
>   arm/arm64: Rename etext to _etext
>   arm64: Add a new type of memory type flag MR_F_RESERVED
> 
> Nikos Nikoleris (23):
>   lib: Fix style for acpi.{c,h}
>   x86: Avoid references to fields of ACPI tables
>   lib: Ensure all struct definition for ACPI tables are packed
>   lib: Add support for the XSDT ACPI table
>   lib: Extend the definition of the ACPI table FADT
>   devicetree: Check if fdt is NULL before returning that a DT is
>     available
>   arm/arm64: Add support for setting up the PSCI conduit through ACPI
>   arm/arm64: Add support for discovering the UART through ACPI
>   arm/arm64: Add support for timer initialization through ACPI
>   arm/arm64: Add support for cpu initialization through ACPI
>   arm/arm64: Add support for gic initialization through ACPI
>   lib/printf: Support for precision modifier in printf
>   lib/printf: Add support for printing wide strings
>   lib/efi: Add support for getting the cmdline
>   lib: Avoid ms_abi for calls related to EFI on arm64
>   arm/arm64: Add a setup sequence for systems that boot through EFI
>   arm64: Copy code from GNU-EFI
>   arm64: Change GNU-EFI imported file to use defined types
>   arm64: Use code from the gnu-efi when booting with EFI
>   lib: Avoid external dependency in libelf
>   x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
>   arm64: Add support for efi in Makefile
>   arm64: Add an efi/run script
> 
>  scripts/runtime.bash        |  14 +-
>  arm/efi/run                 |  61 +++++++
>  arm/run                     |  14 +-
>  configure                   |  15 +-
>  Makefile                    |   4 -
>  arm/Makefile.arm            |   6 +
>  arm/Makefile.arm64          |  18 +-
>  arm/Makefile.common         |  48 +++--
>  x86/Makefile.x86_64         |   4 +
>  lib/linux/efi.h             |  25 +++
>  lib/arm/asm/setup.h         |   3 +
>  lib/arm/asm/timer.h         |   2 +
>  lib/acpi.h                  | 348 ++++++++++++++++++++++++++++--------
>  lib/argv.h                  |   1 +
>  lib/elf.h                   |  57 ++++++
>  lib/libcflat.h              |   1 +
>  lib/acpi.c                  | 129 ++++++++-----
>  lib/argv.c                  |   2 +-
>  lib/arm/gic.c               | 127 ++++++++++++-
>  lib/arm/io.c                |  29 ++-
>  lib/arm/mmu.c               |   4 +
>  lib/arm/psci.c              |  25 ++-
>  lib/arm/setup.c             | 247 ++++++++++++++++++++-----
>  lib/arm/timer.c             |  79 ++++++++
>  lib/devicetree.c            |   2 +-
>  lib/efi.c                   | 102 +++++++++++
>  lib/printf.c                | 194 ++++++++++++++++++--
>  arm/efi/elf_aarch64_efi.lds |  63 +++++++
>  arm/flat.lds                |   2 +-
>  arm/cstart.S                |  29 ++-
>  arm/cstart64.S              |  28 ++-
>  arm/efi/crt0-efi-aarch64.S  | 143 +++++++++++++++
>  arm/dummy.c                 |   4 +
>  arm/efi/reloc_aarch64.c     |  93 ++++++++++
>  arm/micro-bench.c           |   4 +-
>  arm/timer.c                 |  10 +-
>  x86/s3.c                    |  19 +-
>  x86/vmexit.c                |   2 +-
>  38 files changed, 1700 insertions(+), 258 deletions(-)
>  create mode 100755 arm/efi/run
>  create mode 100644 lib/elf.h
>  create mode 100644 lib/arm/timer.c
>  create mode 100644 arm/efi/elf_aarch64_efi.lds
>  create mode 100644 arm/efi/crt0-efi-aarch64.S
>  create mode 100644 arm/dummy.c
>  create mode 100644 arm/efi/reloc_aarch64.c
> 
> -- 
> 2.25.1
> 
