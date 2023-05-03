Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 169236F607B
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 23:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjECVTF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 17:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjECVTD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 17:19:03 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B99F983E6
        for <kvm@vger.kernel.org>; Wed,  3 May 2023 14:18:49 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 958BE2F4;
        Wed,  3 May 2023 14:19:33 -0700 (PDT)
Received: from [10.57.58.91] (unknown [10.57.58.91])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 602513F5A1;
        Wed,  3 May 2023 14:18:48 -0700 (PDT)
Message-ID: <f41bb1d0-d3d3-0f5e-f7a0-ec605a6762db@arm.com>
Date:   Wed, 3 May 2023 22:18:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [kvm-unit-tests PATCH v5 00/29] EFI and ACPI support for arm64
Content-Language: en-GB
To:     Shaoqin Huang <shahuang@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, andrew.jones@linux.dev
Cc:     pbonzini@redhat.com, alexandru.elisei@arm.com, ricarkol@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <b6e3bc3f-d409-00ae-df0f-4bcea9ec0330@redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <b6e3bc3f-d409-00ae-df0f-4bcea9ec0330@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Shaoqin,

On 01/05/2023 13:09, Shaoqin Huang wrote:
> Hi Nikos,
> 
> When I test this series by simply run ./run_tests.sh, some migration
> test will hang up forever, like the `its-migration` test.
> 
> After have a quick look, when do the migration test, the guest can't be
> migrated due to:
> 
> {"return": {"blocked-reasons": ["The qcow format used by node
> '#block389' does not support live migration", "The vvfat (rw) format
> used by node '#block085' does not support live migration"]}}
> 
> Although the guest will be timeout, but the script itself will not be
> timeout. The infinite loop happened at here:
> 
> // script/arch-run.bash
>     151         # Wait for the migration to complete
>     152         migstatus=`qmp ${qmp1} '"query-migrate"' | grep return`
>     153         while ! grep -q '"completed"' <<<"$migstatus" ; do
>     154                 sleep 1
>     155                 migstatus=`qmp ${qmp1} '"query-migrate"' | grep
> return`
>     156                 if grep -q '"failed"' <<<"$migstatus" ; then
>     157                         echo "ERROR: Migration failed." >&2
>     158                         qmp ${qmp1} '"quit"'> ${qmpout1} 2>/dev/null
>     159                         qmp ${qmp2} '"quit"'> ${qmpout2} 2>/dev/null
>     160                         return 2
>     161                 fi
>     162         done
> 
> Since the "query-migrate" here will never get "completed" or "failed",
> so it will never exit.
> > Have you ever meet this problem?

I haven't encountered any problems on Linux but I think I am running 
into something like this when I run on a MacOS. Unfortunately, I don't 
know much about the migration tests and I don't know how they are 
supposed to work in this case. Maybe the problem is that when we can 
run_tests.sh for each test we first run dummy.efi?

Thanks,

Nikos

> 
> Thanks,
> Shaoqin
> 
> On 4/28/23 20:03, Nikos Nikoleris wrote:
>> Hello,
>>
>> This series adds initial support for building arm64 tests as EFI
>> apps and running them under QEMU. Much like x86_64, we import external
>> dependencies from gnu-efi and adapt them to work with types and other
>> assumptions from kvm-unit-tests. In addition, this series adds support
>> for enumerating parts of the system using ACPI.
>>
>> The first set of patches, moves the existing ACPI code to the common
>> lib path. Then, it extends definitions and functions to allow for more
>> robust discovery of ACPI tables. We add support for setting up the PSCI
>> conduit, discovering the UART, timers, GIC and cpus via ACPI. The code
>> retains existing behavior and gives priority to discovery through DT
>> when one has been provided.
>>
>> In the second set of patches, we add support for getting the command
>> line from the EFI shell. This is a requirement for many of the
>> existing arm64 tests.
>>
>> In the third set of patches, we import code from gnu-efi, make minor
>> changes and add an alternative setup sequence from arm64 systems that
>> boot through EFI. Finally, we add support in the build system and a
>> run script which is used to run an EFI app.
>>
>> After this set of patches one can build arm64 EFI tests:
>>
>> $> ./configure --enable-efi
>> $> make
>>
>> And use the run script to run an EFI tests:
>>
>> $> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
>>
>> Or all tests:
>>
>> $> ./run_tests.sh
>>
>> There are a few items that this series does not address but they would
>> be useful to have:
>>    - Support for booting the system from EL2. Currently, we assume that a
>>      test starts EL1. This will be required to run EFI tests on sytems
>>      that implement EL2.
>>    - Support for reading environment variables and populating __envp.
>>    - Support for discovering the PCI subsystem using ACPI.
>>    - Get rid of other assumptions (e.g., vmalloc area) that don't hold on
>>      real HW.
>>    - Various fixes related to cache maintaince to better support turn the
>>      MMU off.
>>    - Switch to a new stack and avoid relying on the one provided by EFI.
>>
>> git branch: https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v5
>>
>> v4: https://lore.kernel.org/kvmarm/20230213101759.2577077-1-nikos.nikoleris@arm.com/
>> v3: https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
>> v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/
>>
>> Changes in v5:
>>    - Minor style changes (thanks Shaoqin).
>>    - Avoid including lib/acpi.o to cflatobjs twice (thanks Drew).
>>    - Increase NR_INITIAL_MEM_REGIONS to avoid overflows and add check when
>>      we run out of space (thanks Shaoqin).
>>
>> Changes in v4:
>>    - Removed patch that reworks cache maintenance when turning the MMU
>>      off. This is not strictly required for EFI tests running with tcg and
>>      will be addressed in a separate series by Alex.
>>    - Fix compilation for arm (Alex).
>>    - Convert ACPI tables to Linux style (Alex).
>>
>> Changes in v3:
>>    - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
>>    - Added support for discovering the GIC through ACPI
>>    - Added a missing header file (<elf.h>)
>>    - Added support for correctly parsing the outcome of tests (./run_tests)
>>
>> Thanks,
>>
>> Nikos
>>
>> Alexandru Elisei (2):
>>     lib/acpi: Convert table names to Linux style
>>     lib: arm: Print test exit status
>>
>> Andrew Jones (2):
>>     arm/arm64: Rename etext to _etext
>>     arm64: Add a new type of memory type flag MR_F_RESERVED
>>
>> Nikos Nikoleris (25):
>>     lib: Move acpi header and implementation to lib
>>     x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
>>     lib: Apply Lindent to acpi.{c,h}
>>     lib: Fix style for acpi.{c,h}
>>     x86: Avoid references to fields of ACPI tables
>>     lib/acpi: Ensure all struct definition for ACPI tables are packed
>>     lib/acpi: Add support for the XSDT table
>>     lib/acpi: Extend the definition of the FADT table
>>     devicetree: Check that fdt is not NULL in dt_available()
>>     arm64: Add support for setting up the PSCI conduit through ACPI
>>     arm64: Add support for discovering the UART through ACPI
>>     arm64: Add support for timer initialization through ACPI
>>     arm64: Add support for cpu initialization through ACPI
>>     arm64: Add support for gic initialization through ACPI
>>     lib/printf: Support for precision modifier in printf
>>     lib/printf: Add support for printing wide strings
>>     lib/efi: Add support for getting the cmdline
>>     lib: Avoid ms_abi for calls related to EFI on arm64
>>     arm64: Add a setup sequence for systems that boot through EFI
>>     arm64: Copy code from GNU-EFI
>>     arm64: Change GNU-EFI imported code to use defined types
>>     arm64: Use code from the gnu-efi when booting with EFI
>>     lib: Avoid external dependency in libelf
>>     arm64: Add support for efi in Makefile
>>     arm64: Add an efi/run script
>>
>>    scripts/runtime.bash        |  13 +-
>>    arm/efi/run                 |  61 ++++++++
>>    arm/run                     |  14 +-
>>    configure                   |  17 +-
>>    Makefile                    |   4 -
>>    arm/Makefile.arm            |   6 +
>>    arm/Makefile.arm64          |  22 ++-
>>    arm/Makefile.common         |  47 ++++--
>>    x86/Makefile.common         |   2 +-
>>    x86/Makefile.x86_64         |   4 +
>>    lib/linux/efi.h             |  25 +++
>>    lib/arm/asm/setup.h         |   9 ++
>>    lib/arm/asm/timer.h         |   2 +
>>    lib/x86/asm/setup.h         |   2 +-
>>    lib/acpi.h                  | 301 ++++++++++++++++++++++++++++++++++++
>>    lib/argv.h                  |   1 +
>>    lib/elf.h                   |  57 +++++++
>>    lib/libcflat.h              |   1 +
>>    lib/x86/acpi.h              | 112 --------------
>>    lib/acpi.c                  | 129 ++++++++++++++++
>>    lib/argv.c                  |   2 +-
>>    lib/arm/gic.c               | 139 ++++++++++++++++-
>>    lib/arm/io.c                |  41 ++++-
>>    lib/arm/mmu.c               |   4 +
>>    lib/arm/psci.c              |  37 ++++-
>>    lib/arm/setup.c             | 269 ++++++++++++++++++++++++++------
>>    lib/arm/timer.c             |  92 +++++++++++
>>    lib/devicetree.c            |   2 +-
>>    lib/efi.c                   | 102 ++++++++++++
>>    lib/printf.c                | 194 +++++++++++++++++++++--
>>    lib/x86/acpi.c              |  82 ----------
>>    lib/x86/setup.c             |   2 +-
>>    arm/efi/elf_aarch64_efi.lds |  63 ++++++++
>>    arm/flat.lds                |   2 +-
>>    arm/cstart.S                |   1 +
>>    arm/cstart64.S              |   7 +
>>    arm/efi/crt0-efi-aarch64.S  | 141 +++++++++++++++++
>>    arm/dummy.c                 |  12 ++
>>    arm/efi/reloc_aarch64.c     |  94 +++++++++++
>>    arm/micro-bench.c           |   4 +-
>>    arm/timer.c                 |  10 +-
>>    x86/s3.c                    |  21 +--
>>    x86/vmexit.c                |   4 +-
>>    43 files changed, 1831 insertions(+), 323 deletions(-)
>>    create mode 100755 arm/efi/run
>>    create mode 100644 lib/acpi.h
>>    create mode 100644 lib/elf.h
>>    delete mode 100644 lib/x86/acpi.h
>>    create mode 100644 lib/acpi.c
>>    create mode 100644 lib/arm/timer.c
>>    delete mode 100644 lib/x86/acpi.c
>>    create mode 100644 arm/efi/elf_aarch64_efi.lds
>>    create mode 100644 arm/efi/crt0-efi-aarch64.S
>>    create mode 100644 arm/dummy.c
>>    create mode 100644 arm/efi/reloc_aarch64.c
>>
> 
