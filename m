Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CA0727807
	for <lists+kvm@lfdr.de>; Thu,  8 Jun 2023 09:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235152AbjFHHBz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 03:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234536AbjFHHBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 03:01:53 -0400
Received: from out-44.mta0.migadu.com (out-44.mta0.migadu.com [91.218.175.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7482D48
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 00:01:27 -0700 (PDT)
Date:   Thu, 8 Jun 2023 09:01:17 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686207678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=O99V07931WAzoQqtYHFkFDBm7gi9yCsTg5pV0VJ30JY=;
        b=HAcv2qC4Ur+N4vgCN2p1r/8Z5nnmzyd98a6YAGy+YoH3oZIGqJEvgik7wWBIkS4DOP6pSv
        MijyZ6xRnX2Yyj/3AxMwwuk68RoIkJKJIt8EYsXa7RSpkFA2s31RhvKtGB+iwIREx3vXlo
        u2T5+dA4Fuv0TpBLVOB7C9He9XE7DMU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com, shahuang@redhat.com,
        seanjc@google.com
Subject: Re: [kvm-unit-tests PATCH v6 00/32] EFI and ACPI support for arm64
Message-ID: <20230608-6fddfefd0f1de86a90192d50@orel>
References: <20230530160924.82158-1-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530160924.82158-1-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Paolo and Sean,

This series touches common ACPI code and even a bit of x86 code.
Can I get an x86 ack on those bits?

Thanks,
drew


On Tue, May 30, 2023 at 05:08:52PM +0100, Nikos Nikoleris wrote:
> Hello,
> 
> This series adds initial support for building arm64 tests as EFI
> apps and running them under QEMU. Much like x86_64, we import external
> dependencies from gnu-efi and adapt them to work with types and other
> assumptions from kvm-unit-tests. In addition, this series adds support
> for enumerating parts of the system using ACPI.
> 
> The first set of patches, moves the existing ACPI code to the common
> lib path. Then, it extends definitions and functions to allow for more
> robust discovery of ACPI tables. We add support for setting up the PSCI
> conduit, discovering the UART, timers, GIC and cpus via ACPI. The code
> retains existing behavior and gives priority to discovery through DT
> when one has been provided.
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
>    test starts EL1. This will be required to run EFI tests on sytems
>    that implement EL2.
>  - Support for reading environment variables and populating __envp.
>  - Support for discovering the PCI subsystem using ACPI.
>  - Get rid of other assumptions (e.g., vmalloc area) that don't hold on
>    real HW.
>  - Various fixes related to cache maintaince to better support turn the
>    MMU off.
>  - Switch to a new stack and avoid relying on the one provided by EFI.
> 
> git branch: https://gitlab.com/nnikoleris/kvm-unit-tests/-/tree/target-efi-upstream-v6 
> 
> v5: https://lore.kernel.org/kvmarm/20230428120405.3770496-1-nikos.nikoleris@arm.com/
> v4: https://lore.kernel.org/kvmarm/20230213101759.2577077-1-nikos.nikoleris@arm.com/
> v3: https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
> v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/
> 
> Changes in v6:
>  - Fixed a symbol issue in the debug tests that would cause them to fail
>    when build with fPIC.
>  - Added support for booting with FDT.
> 
> Changes in v5:
>  - Minor style changes (thanks Shaoqin).
>  - Avoid including lib/acpi.o to cflatobjs twice (thanks Drew).
>  - Increase NR_INITIAL_MEM_REGIONS to avoid overflows and add check when
>    we run out of space (thanks Shaoqin).
> 
> Changes in v4:
>  - Removed patch that reworks cache maintenance when turning the MMU
>    off. This is not strictly required for EFI tests running with tcg and
>    will be addressed in a separate series by Alex.
>  - Fix compilation for arm (Alex).
>  - Convert ACPI tables to Linux style (Alex).
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
> Alexandru Elisei (2):
>   lib/acpi: Convert table names to Linux style
>   lib: arm: Print test exit status
> 
> Andrew Jones (2):
>   arm/arm64: Rename etext to _etext
>   arm64: Add a new type of memory type flag MR_F_RESERVED
> 
> Nikos Nikoleris (28):
>   lib: Move acpi header and implementation to lib
>   x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
>   lib: Apply Lindent to acpi.{c,h}
>   lib: Fix style for acpi.{c,h}
>   x86: Avoid references to fields of ACPI tables
>   lib/acpi: Ensure all struct definition for ACPI tables are packed
>   lib/acpi: Add support for the XSDT table
>   lib/acpi: Extend the definition of the FADT table
>   devicetree: Check that fdt is not NULL in dt_available()
>   arm64: Add support for setting up the PSCI conduit through ACPI
>   arm64: Add support for discovering the UART through ACPI
>   arm64: Add support for timer initialization through ACPI
>   arm64: Add support for cpu initialization through ACPI
>   arm64: Add support for gic initialization through ACPI
>   lib/printf: Support for precision modifier in printf
>   lib/printf: Add support for printing wide strings
>   lib/efi: Add support for getting the cmdline
>   lib/efi: Add support for reading an FDT
>   lib: Avoid ms_abi for calls related to EFI on arm64
>   arm64: Add a setup sequence for systems that boot through EFI
>   arm64: Copy code from GNU-EFI
>   arm64: Change GNU-EFI imported code to use defined types
>   arm64: Use code from the gnu-efi when booting with EFI
>   lib: Avoid external dependency in libelf
>   arm64: Add support for efi in Makefile
>   arm64: debug: Make inline assembly symbols global
>   arm64: Add an efi/run script
>   arm64: Use the provided fdt when booting through EFI
> 
>  scripts/runtime.bash        |  13 +-
>  arm/efi/run                 |  70 +++++++++
>  arm/run                     |  14 +-
>  configure                   |  17 +-
>  Makefile                    |   4 -
>  arm/Makefile.arm            |   6 +
>  arm/Makefile.arm64          |  22 ++-
>  arm/Makefile.common         |  47 ++++--
>  x86/Makefile.common         |   2 +-
>  x86/Makefile.x86_64         |   4 +
>  lib/linux/efi.h             | 126 +++++++++++++++
>  lib/arm/asm/setup.h         |   9 ++
>  lib/arm/asm/timer.h         |   2 +
>  lib/x86/asm/setup.h         |   2 +-
>  lib/acpi.h                  | 302 ++++++++++++++++++++++++++++++++++++
>  lib/argv.h                  |   1 +
>  lib/efi.h                   |  12 ++
>  lib/elf.h                   |  57 +++++++
>  lib/libcflat.h              |   1 +
>  lib/x86/acpi.h              | 112 -------------
>  lib/acpi.c                  | 129 +++++++++++++++
>  lib/argv.c                  |   2 +-
>  lib/arm/gic.c               | 139 ++++++++++++++++-
>  lib/arm/io.c                |  41 ++++-
>  lib/arm/mmu.c               |   4 +
>  lib/arm/psci.c              |  37 ++++-
>  lib/arm/setup.c             | 284 +++++++++++++++++++++++++++------
>  lib/arm/timer.c             |  92 +++++++++++
>  lib/devicetree.c            |   2 +-
>  lib/efi.c                   | 222 ++++++++++++++++++++++++++
>  lib/printf.c                | 194 +++++++++++++++++++++--
>  lib/x86/acpi.c              |  82 ----------
>  lib/x86/setup.c             |   2 +-
>  arm/efi/elf_aarch64_efi.lds |  63 ++++++++
>  arm/flat.lds                |   2 +-
>  arm/cstart.S                |   1 +
>  arm/cstart64.S              |   7 +
>  arm/efi/crt0-efi-aarch64.S  | 141 +++++++++++++++++
>  arm/debug.c                 |  20 ++-
>  arm/dummy.c                 |  12 ++
>  arm/efi/reloc_aarch64.c     |  94 +++++++++++
>  arm/micro-bench.c           |   4 +-
>  arm/timer.c                 |  10 +-
>  x86/s3.c                    |  21 +--
>  x86/vmexit.c                |   4 +-
>  45 files changed, 2102 insertions(+), 330 deletions(-)
>  create mode 100755 arm/efi/run
>  create mode 100644 lib/acpi.h
>  create mode 100644 lib/elf.h
>  delete mode 100644 lib/x86/acpi.h
>  create mode 100644 lib/acpi.c
>  create mode 100644 lib/arm/timer.c
>  delete mode 100644 lib/x86/acpi.c
>  create mode 100644 arm/efi/elf_aarch64_efi.lds
>  create mode 100644 arm/efi/crt0-efi-aarch64.S
>  create mode 100644 arm/dummy.c
>  create mode 100644 arm/efi/reloc_aarch64.c
> 
> -- 
> 2.25.1
> 
