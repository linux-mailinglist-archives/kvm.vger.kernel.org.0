Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A717B69428D
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 11:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjBMKSL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 05:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230130AbjBMKSH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 05:18:07 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 58E8F9778
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 02:18:05 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B5F3C4B3;
        Mon, 13 Feb 2023 02:18:47 -0800 (PST)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 420613F703;
        Mon, 13 Feb 2023 02:18:04 -0800 (PST)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
Subject: [PATCH v4 00/30] EFI and ACPI support for arm64
Date:   Mon, 13 Feb 2023 10:17:29 +0000
Message-Id: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This series adds initial support for building arm64 tests as EFI
apps and running them under QEMU. Much like x86_64, we import external
dependencies from gnu-efi and adapt them to work with types and other
assumptions from kvm-unit-tests. In addition, this series adds support
for enumerating parts of the system using ACPI.

The first set of patches, moves the existing ACPI code to the common
lib path. Then, it extends definitions and functions to allow for more
robust discovery of ACPI tables. We add support for setting up the PSCI
conduit, discovering the UART, timers, GIC and cpus via ACPI. The code
retains existing behavior and gives priority to discovery through DT
when one has been provided.

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
   test starts EL1. This will be required to run EFI tests on sytems
   that implement EL2.
 - Support for reading environment variables and populating __envp.
 - Support for discovering the PCI subsystem using ACPI.
 - Get rid of other assumptions (e.g., vmalloc area) that don't hold on
   real HW.
 - Various fixes related to cache maintaince to better support turn the
   MMU off.
 - Switch to a new stack and avoid relying on the one provided by EFI.

git branch: https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v4

v3: https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/

Changes in v4:
 - Removed patch that reworks cache maintenance when turning the MMU
   off. This is not strictly required for EFI tests running with tcg and
   will be addressed in a separate series by Alex.
 - Fix compilation for arm (Alex).
 - Convert ACPI tables to Linux style (Alex).

Changes in v3:
 - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
 - Added support for discovering the GIC through ACPI
 - Added a missing header file (<elf.h>)
 - Added support for correctly parsing the outcome of tests (./run_tests)

Thanks,

Nikos

Alexandru Elisei (3):
  arm/Makefile.common: Compile lib/acpi.c if CONFIG_EFI=y
  lib/acpi: Convert table names to Linux style
  lib: arm: Print test exit status

Andrew Jones (2):
  arm/arm64: Rename etext to _etext
  arm64: Add a new type of memory type flag MR_F_RESERVED

Nikos Nikoleris (25):
  lib: Move acpi header and implementation to lib
  x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
  lib: Apply Lindent to acpi.{c,h}
  lib: Fix style for acpi.{c,h}
  x86: Avoid references to fields of ACPI tables
  lib/acpi: Ensure all struct definition for ACPI tables are packed
  lib/acpi: Add support for the XSDT table
  lib/acpi: Extend the definition of the FADT table
  devicetree: Check that fdt is not NULL in dt_available()
  arm64: Add support for setting up the PSCI conduit through ACPI
  arm64: Add support for discovering the UART through ACPI
  arm64: Add support for timer initialization through ACPI
  arm64: Add support for cpu initialization through ACPI
  arm64: Add support for gic initialization through ACPI
  lib/printf: Support for precision modifier in printf
  lib/printf: Add support for printing wide strings
  lib/efi: Add support for getting the cmdline
  lib: Avoid ms_abi for calls related to EFI on arm64
  arm64: Add a setup sequence for systems that boot through EFI
  arm64: Copy code from GNU-EFI
  arm64: Change GNU-EFI imported file to use defined types
  arm64: Use code from the gnu-efi when booting with EFI
  lib: Avoid external dependency in libelf
  arm64: Add support for efi in Makefile
  arm64: Add an efi/run script

 Makefile                    |   4 -
 arm/Makefile.arm            |   6 +
 arm/Makefile.arm64          |  22 ++-
 arm/Makefile.common         |  51 ++++--
 arm/cstart.S                |   1 +
 arm/cstart64.S              |   7 +
 arm/dummy.c                 |  12 ++
 arm/efi/crt0-efi-aarch64.S  | 141 +++++++++++++++++
 arm/efi/elf_aarch64_efi.lds |  63 ++++++++
 arm/efi/reloc_aarch64.c     |  93 +++++++++++
 arm/efi/run                 |  61 ++++++++
 arm/flat.lds                |   2 +-
 arm/micro-bench.c           |   4 +-
 arm/run                     |  14 +-
 arm/timer.c                 |  10 +-
 configure                   |  15 +-
 lib/acpi.c                  | 129 +++++++++++++++
 lib/acpi.h                  | 303 ++++++++++++++++++++++++++++++++++++
 lib/argv.c                  |   2 +-
 lib/argv.h                  |   1 +
 lib/arm/asm/setup.h         |   9 ++
 lib/arm/asm/timer.h         |   2 +
 lib/arm/gic.c               | 139 ++++++++++++++++-
 lib/arm/io.c                |  41 ++++-
 lib/arm/mmu.c               |   4 +
 lib/arm/psci.c              |  37 ++++-
 lib/arm/setup.c             | 264 +++++++++++++++++++++++++------
 lib/arm/timer.c             |  92 +++++++++++
 lib/devicetree.c            |   2 +-
 lib/efi.c                   | 102 ++++++++++++
 lib/elf.h                   |  57 +++++++
 lib/libcflat.h              |   1 +
 lib/linux/efi.h             |  25 +++
 lib/printf.c                | 194 +++++++++++++++++++++--
 lib/x86/acpi.c              |  82 ----------
 lib/x86/acpi.h              | 112 -------------
 lib/x86/asm/setup.h         |   2 +-
 lib/x86/setup.c             |   2 +-
 scripts/runtime.bash        |  13 +-
 x86/Makefile.common         |   2 +-
 x86/Makefile.x86_64         |   4 +
 x86/s3.c                    |  21 +--
 x86/vmexit.c                |   4 +-
 43 files changed, 1831 insertions(+), 321 deletions(-)
 create mode 100644 arm/dummy.c
 create mode 100644 arm/efi/crt0-efi-aarch64.S
 create mode 100644 arm/efi/elf_aarch64_efi.lds
 create mode 100644 arm/efi/reloc_aarch64.c
 create mode 100755 arm/efi/run
 create mode 100644 lib/acpi.c
 create mode 100644 lib/acpi.h
 create mode 100644 lib/arm/timer.c
 create mode 100644 lib/elf.h
 delete mode 100644 lib/x86/acpi.c
 delete mode 100644 lib/x86/acpi.h

-- 
2.25.1

