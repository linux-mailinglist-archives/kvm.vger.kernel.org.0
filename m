Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21CA56171A
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 12:05:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234022AbiF3KDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 06:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiF3KDv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 06:03:51 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6ED1F43EEF
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 03:03:50 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 279D81042;
        Thu, 30 Jun 2022 03:03:50 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EB3803F5A1;
        Thu, 30 Jun 2022 03:03:48 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     andrew.jones@linux.dev, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [kvm-unit-tests PATCH v3 00/27] EFI and ACPI support for arm64
Date:   Thu, 30 Jun 2022 11:02:57 +0100
Message-Id: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patch series adds initial support for building arm64 tests as EFI
tests and running them under QEMU. Much like x86_64 we import external
dependencies from gnu-efi and adapt them to work with types and other
assumptions from kvm-unit-tests. In addition, this series adds support
for enumerating parts of the system using ACPI.

The first set of patches moves the existing ACPI code to the common
lib path. Then, it extends definitions and functions to allow for more
robust discovery of ACPI tables. In arm64, we add support for setting
up the PSCI conduit, discovering the UART, timers and cpus via
ACPI. The code retains existing behavior and gives priority to
discovery through DT when one has been provided.

In the second set of patches, we add support for getting the command
line from the EFI shell. This is a requirement for many of the
existing arm64 tests.

In the third set of patches, we import code from gnu-efi, make minor
changes and add an alternative setup sequence from arm64 systems that
boot through EFI. Finally, we add support in the build system and a
run script which is used to run an EFI app.

After this set of patches one can build arm64 EFI tests:

$> ./configure --enable-efi
$> make

And use the run script to run an EFI tests:

$> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"

Or all tests:

$> ./run_tests.sh

There are a few items that this series does not address but they would
be useful to have:
 - Support for booting the system from EL2. Currently, we assume that a
   tests starts running at EL1. This the case when we run with EFI, it's
   not always the case in hardware.
 - Support for reading environment variables and populating __envp.
 - Support for discovering the PCI subsystem using ACPI.
 - Get rid of other assumptions (e.g., vmalloc area) that don't hold on real HW.

git branch: https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v3-rebased

v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/

Changes in v3:
 - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
 - Added support for discovering the GIC through ACPI
 - Added a missing header file (<elf.h>)
 - Added support for correctly parsing the outcome of tests (./run_tests)

Thanks,

Nikos

Alexandru Elisei (1):
  lib: arm: Print test exit status

Andrew Jones (3):
  arm/arm64: mmu_disable: Clean and invalidate before disabling
  arm/arm64: Rename etext to _etext
  arm64: Add a new type of memory type flag MR_F_RESERVED

Nikos Nikoleris (23):
  lib: Fix style for acpi.{c,h}
  x86: Avoid references to fields of ACPI tables
  lib: Ensure all struct definition for ACPI tables are packed
  lib: Add support for the XSDT ACPI table
  lib: Extend the definition of the ACPI table FADT
  devicetree: Check if fdt is NULL before returning that a DT is
    available
  arm/arm64: Add support for setting up the PSCI conduit through ACPI
  arm/arm64: Add support for discovering the UART through ACPI
  arm/arm64: Add support for timer initialization through ACPI
  arm/arm64: Add support for cpu initialization through ACPI
  arm/arm64: Add support for gic initialization through ACPI
  lib/printf: Support for precision modifier in printf
  lib/printf: Add support for printing wide strings
  lib/efi: Add support for getting the cmdline
  lib: Avoid ms_abi for calls related to EFI on arm64
  arm/arm64: Add a setup sequence for systems that boot through EFI
  arm64: Copy code from GNU-EFI
  arm64: Change GNU-EFI imported file to use defined types
  arm64: Use code from the gnu-efi when booting with EFI
  lib: Avoid external dependency in libelf
  x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
  arm64: Add support for efi in Makefile
  arm64: Add an efi/run script

 scripts/runtime.bash        |  14 +-
 arm/efi/run                 |  61 +++++++
 arm/run                     |  14 +-
 configure                   |  15 +-
 Makefile                    |   4 -
 arm/Makefile.arm            |   6 +
 arm/Makefile.arm64          |  18 +-
 arm/Makefile.common         |  48 +++--
 x86/Makefile.x86_64         |   4 +
 lib/linux/efi.h             |  25 +++
 lib/arm/asm/setup.h         |   3 +
 lib/arm/asm/timer.h         |   2 +
 lib/acpi.h                  | 348 ++++++++++++++++++++++++++++--------
 lib/argv.h                  |   1 +
 lib/elf.h                   |  57 ++++++
 lib/libcflat.h              |   1 +
 lib/acpi.c                  | 129 ++++++++-----
 lib/argv.c                  |   2 +-
 lib/arm/gic.c               | 127 ++++++++++++-
 lib/arm/io.c                |  29 ++-
 lib/arm/mmu.c               |   4 +
 lib/arm/psci.c              |  25 ++-
 lib/arm/setup.c             | 247 ++++++++++++++++++++-----
 lib/arm/timer.c             |  79 ++++++++
 lib/devicetree.c            |   2 +-
 lib/efi.c                   | 102 +++++++++++
 lib/printf.c                | 194 ++++++++++++++++++--
 arm/efi/elf_aarch64_efi.lds |  63 +++++++
 arm/flat.lds                |   2 +-
 arm/cstart.S                |  29 ++-
 arm/cstart64.S              |  28 ++-
 arm/efi/crt0-efi-aarch64.S  | 143 +++++++++++++++
 arm/dummy.c                 |   4 +
 arm/efi/reloc_aarch64.c     |  93 ++++++++++
 arm/micro-bench.c           |   4 +-
 arm/timer.c                 |  10 +-
 x86/s3.c                    |  19 +-
 x86/vmexit.c                |   2 +-
 38 files changed, 1700 insertions(+), 258 deletions(-)
 create mode 100755 arm/efi/run
 create mode 100644 lib/elf.h
 create mode 100644 lib/arm/timer.c
 create mode 100644 arm/efi/elf_aarch64_efi.lds
 create mode 100644 arm/efi/crt0-efi-aarch64.S
 create mode 100644 arm/dummy.c
 create mode 100644 arm/efi/reloc_aarch64.c

-- 
2.25.1

