Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0105451E071
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 22:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444070AbiEFVAS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444048AbiEFVAR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:00:17 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECA1F6A064
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 13:56:32 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C557B14BF;
        Fri,  6 May 2022 13:56:32 -0700 (PDT)
Received: from godel.lab.cambridge.arm.com (godel.lab.cambridge.arm.com [10.7.66.42])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EC2893F800;
        Fri,  6 May 2022 13:56:31 -0700 (PDT)
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, pbonzini@redhat.com, jade.alglave@arm.com,
        alexandru.elisei@arm.com
Subject: [kvm-unit-tests PATCH v2 00/23] EFI and ACPI support for arm64
Date:   Fri,  6 May 2022 21:55:42 +0100
Message-Id: <20220506205605.359830-1-nikos.nikoleris@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-ARM-No-Footer: FoSSMail
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patch series adds initial support for building arm64 tests as EFI
tests and running them under QEMU. Much like x86_64 we import external
dependencies from gnu-efi and adopt them to work with types and other
assumptions from kvm-unit-tests. In addition, this series adds support
for discovering parts of the machine using ACPI.

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

* Support for booting the system from EL2. Currently, we assume that a
tests starts running at EL1. This the case when we run with EFI, it's
not always the case in hardware.

* Support for reading environment variables and populating __envp.

* Support for discovering the chr-testdev through ACPI.

PS: Apologies for the mess with v1. Due to a mistake in my git
send-email configuration some patches didn't make it to the list and
the right recipients.

Thanks,

Nikos

Andrew Jones (3):
  arm/arm64: mmu_disable: Clean and invalidate before disabling
  arm/arm64: Rename etext to _etext
  arm64: Add a new type of memory type flag MR_F_RESERVED

Nikos Nikoleris (20):
  lib: Move acpi header and implementation to lib
  lib: Ensure all struct definition for ACPI tables are packed
  lib: Add support for the XSDT ACPI table
  lib: Extend the definition of the ACPI table FADT
  arm/arm64: Add support for setting up the PSCI conduit through ACPI
  arm/arm64: Add support for discovering the UART through ACPI
  arm/arm64: Add support for timer initialization through ACPI
  arm/arm64: Add support for cpu initialization through ACPI
  lib/printf: Support for precision modifier in printing strings
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
 arm/efi/run                 |  61 +++++++++
 arm/run                     |   8 +-
 configure                   |  15 ++-
 Makefile                    |   4 -
 arm/Makefile.arm            |   6 +
 arm/Makefile.arm64          |  18 ++-
 arm/Makefile.common         |  48 +++++--
 x86/Makefile.common         |   2 +-
 x86/Makefile.x86_64         |   4 +
 lib/linux/efi.h             |  44 ++++++
 lib/arm/asm/setup.h         |   3 +
 lib/arm/asm/timer.h         |   2 +
 lib/x86/asm/setup.h         |   2 +-
 lib/acpi.h                  | 260 ++++++++++++++++++++++++++++++++++++
 lib/stdlib.h                |   1 +
 lib/x86/acpi.h              | 112 ----------------
 lib/acpi.c                  | 124 +++++++++++++++++
 lib/arm/io.c                |  21 ++-
 lib/arm/mmu.c               |   4 +
 lib/arm/psci.c              |  25 +++-
 lib/arm/setup.c             | 247 +++++++++++++++++++++++++++-------
 lib/arm/timer.c             |  73 ++++++++++
 lib/devicetree.c            |   2 +-
 lib/efi.c                   | 123 +++++++++++++++++
 lib/printf.c                | 183 +++++++++++++++++++++++--
 lib/string.c                |   2 +-
 lib/x86/acpi.c              |  82 ------------
 arm/efi/elf_aarch64_efi.lds |  63 +++++++++
 arm/flat.lds                |   2 +-
 arm/cstart.S                |  29 +++-
 arm/cstart64.S              |  28 +++-
 arm/efi/crt0-efi-aarch64.S  | 143 ++++++++++++++++++++
 arm/dummy.c                 |   4 +
 arm/efi/reloc_aarch64.c     |  93 +++++++++++++
 x86/s3.c                    |  20 +--
 x86/vmexit.c                |   4 +-
 37 files changed, 1556 insertions(+), 320 deletions(-)
 create mode 100755 arm/efi/run
 create mode 100644 lib/acpi.h
 delete mode 100644 lib/x86/acpi.h
 create mode 100644 lib/acpi.c
 create mode 100644 lib/arm/timer.c
 delete mode 100644 lib/x86/acpi.c
 create mode 100644 arm/efi/elf_aarch64_efi.lds
 create mode 100644 arm/efi/crt0-efi-aarch64.S
 create mode 100644 arm/dummy.c
 create mode 100644 arm/efi/reloc_aarch64.c

-- 
2.25.1

