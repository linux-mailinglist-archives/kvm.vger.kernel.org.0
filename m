Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E50AD58DBAA
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 18:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244805AbiHIQJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 12:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244637AbiHIQJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 12:09:56 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E744E113A
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 09:09:54 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7458123A;
        Tue,  9 Aug 2022 09:09:55 -0700 (PDT)
Received: from [192.168.12.23] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8B7FA3F5A1;
        Tue,  9 Aug 2022 09:09:52 -0700 (PDT)
Message-ID: <d93612b3-5fca-48ee-4c80-94e11c045dcd@arm.com>
Date:   Tue, 9 Aug 2022 17:09:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [kvm-unit-tests PATCH v3 00/27] EFI and ACPI support for arm64
Content-Language: en-GB
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, drjones@redhat.com,
        pbonzini@redhat.com, jade.alglave@arm.com, ricarkol@google.com,
        seanjc@google.com, zixuanwang@google.com
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <YvJB/KCLSQK836ae@monolith.localdoman>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <YvJB/KCLSQK836ae@monolith.localdoman>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 09/08/2022 12:16, Alexandru Elisei wrote:
> Hi,
> 
> Adding Sean and Zixuan, as they were involved in the initial x86 UEFI
> support.
> 
> This version of the UEFI support for arm64 jumps to lib/efi.c::efi_main
> after performing the relocation. I'll post an abbreviated/simplified
> version of efi_main() for reference:
> 
> efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> {
> 	/* Get image, cmdline and memory map parameters from UEFI */
> 
>          efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> 
>          /* Set up arch-specific resources */
>          setup_efi(&efi_bootinfo);
> 
>          /* Run the test case */
>          ret = main(__argc, __argv, __environ);
> 
>          /* Shutdown the guest VM */
>          efi_exit(ret);
> 
>          /* Unreachable */
>          return EFI_UNSUPPORTED;
> }
> 
> Note that the assumption that efi_main() makes is that setup_efi() doesn't
> change the stack from the stack that the UEFI implementation allocated, in
> order for setup_efi() to be able to return to efi_main().
> 
> arm64 requires explicit data cache maintenance to keep the contents of the
> caches in sync with memory when writing with MMU off/reading with MMU on
> and viceversa. More details of what is needed is why here [1] and here [2].
> These operations must also be performed for the stack because the stack is
> always used when running C code.
> 
> What this means is that if arm64 wants to be able to run C code when the
> MMU is disabled and when it is enabled, then it must perform data cache
> operations for the stack memory. Which is impossible if the stack has been
> allocated by UEFI, as kvm-unit-tests has no way of knowing its size, as it
> isn't specified in the UEFI spec*. As a result, either efi_main needs to be
> changed such that setup_efi() never returns, or arm64 must implement its
> own version of efi_main() (or however it will end up being called).
> 

I think it's possible to know the size of the stack. In 22/27 "arm64: 
Use code from the gnu-efi when booting with EFI", we change the top of 
the stack we start executing C code. Then at any point we can get the 
bottom of the stack.

But I doubt cleaning the stack is sufficient. What about the .data 
segment. Take for example, mem_regions. We populate them with the MMU 
on. We then use them to create page tables. We will need to clean them 
too. I won't be surprised if there is more data we would need to clean.

Thanks,

Nikos

> One way to get around this is never to run C code with the MMU off. That's
> relatively easy to do in the boot code, as the translation tables can be
> constructed with the MMU on, and then a fairly small assembly sequence is
> required to install them.
> 
> But arm64 also has two mechanisms for disabling the MMU:
> 
> 1. At compile time, the user can request a test to start with the MMU off,
> by setting the flag AUXINFO_MMU_OFF. So when booting as an UEFI app,
> kvm-unit-tests must disable the MMU.
> 
> 2. A function called mmu_disable() which allows a test to explicitly
> disable the MMU.
> 
> If we want to keep the UEFI allocated stack, then both mechanism must be
> forbidden when running under UEFI. I dislike this idea, because those two
> mechanisms allow kvm-unit-tests to run tests which otherwise wouldn't have
> been possible with a normal operating system, which, except for the early
> boot code, runs with the MMU enabled.
> 
> Any thoughts or comments about this?
> 
> *UEFI v2.8 states about the stack: "128 KiB or more of available stack
> space" (page 35), but EDK2 allocates 64KiB [3]. So without any firmware
> call to query the size of the stack, kvm-unit-tests cannot rely on it being
> a specific size.
> 
> [1] https://lore.kernel.org/kvm/20220809091558.14379-19-alexandru.elisei@arm.com/
> [2] https://lore.kernel.org/kvm/20220809091558.14379-20-alexandru.elisei@arm.com/
> [3] https://github.com/tianocore/edk2/blob/master/ArmPlatformPkg/ArmPlatformPkg.dec#L71
> 
> Thanks,
> Alex
> 
> On Thu, Jun 30, 2022 at 11:02:57AM +0100, Nikos Nikoleris wrote:
>> Hello,
>>
>> This patch series adds initial support for building arm64 tests as EFI
>> tests and running them under QEMU. Much like x86_64 we import external
>> dependencies from gnu-efi and adapt them to work with types and other
>> assumptions from kvm-unit-tests. In addition, this series adds support
>> for enumerating parts of the system using ACPI.
>>
>> The first set of patches moves the existing ACPI code to the common
>> lib path. Then, it extends definitions and functions to allow for more
>> robust discovery of ACPI tables. In arm64, we add support for setting
>> up the PSCI conduit, discovering the UART, timers and cpus via
>> ACPI. The code retains existing behavior and gives priority to
>> discovery through DT when one has been provided.
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
>>   - Support for booting the system from EL2. Currently, we assume that a
>>     tests starts running at EL1. This the case when we run with EFI, it's
>>     not always the case in hardware.
>>   - Support for reading environment variables and populating __envp.
>>   - Support for discovering the PCI subsystem using ACPI.
>>   - Get rid of other assumptions (e.g., vmalloc area) that don't hold on real HW.
>>
>> git branch: https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v3-rebased
>>
>> v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/
>>
>> Changes in v3:
>>   - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
>>   - Added support for discovering the GIC through ACPI
>>   - Added a missing header file (<elf.h>)
>>   - Added support for correctly parsing the outcome of tests (./run_tests)
>>
>> Thanks,
>>
>> Nikos
>>
>> Alexandru Elisei (1):
>>    lib: arm: Print test exit status
>>
>> Andrew Jones (3):
>>    arm/arm64: mmu_disable: Clean and invalidate before disabling
>>    arm/arm64: Rename etext to _etext
>>    arm64: Add a new type of memory type flag MR_F_RESERVED
>>
>> Nikos Nikoleris (23):
>>    lib: Fix style for acpi.{c,h}
>>    x86: Avoid references to fields of ACPI tables
>>    lib: Ensure all struct definition for ACPI tables are packed
>>    lib: Add support for the XSDT ACPI table
>>    lib: Extend the definition of the ACPI table FADT
>>    devicetree: Check if fdt is NULL before returning that a DT is
>>      available
>>    arm/arm64: Add support for setting up the PSCI conduit through ACPI
>>    arm/arm64: Add support for discovering the UART through ACPI
>>    arm/arm64: Add support for timer initialization through ACPI
>>    arm/arm64: Add support for cpu initialization through ACPI
>>    arm/arm64: Add support for gic initialization through ACPI
>>    lib/printf: Support for precision modifier in printf
>>    lib/printf: Add support for printing wide strings
>>    lib/efi: Add support for getting the cmdline
>>    lib: Avoid ms_abi for calls related to EFI on arm64
>>    arm/arm64: Add a setup sequence for systems that boot through EFI
>>    arm64: Copy code from GNU-EFI
>>    arm64: Change GNU-EFI imported file to use defined types
>>    arm64: Use code from the gnu-efi when booting with EFI
>>    lib: Avoid external dependency in libelf
>>    x86: Move x86_64-specific EFI CFLAGS to x86_64 Makefile
>>    arm64: Add support for efi in Makefile
>>    arm64: Add an efi/run script
>>
>>   scripts/runtime.bash        |  14 +-
>>   arm/efi/run                 |  61 +++++++
>>   arm/run                     |  14 +-
>>   configure                   |  15 +-
>>   Makefile                    |   4 -
>>   arm/Makefile.arm            |   6 +
>>   arm/Makefile.arm64          |  18 +-
>>   arm/Makefile.common         |  48 +++--
>>   x86/Makefile.x86_64         |   4 +
>>   lib/linux/efi.h             |  25 +++
>>   lib/arm/asm/setup.h         |   3 +
>>   lib/arm/asm/timer.h         |   2 +
>>   lib/acpi.h                  | 348 ++++++++++++++++++++++++++++--------
>>   lib/argv.h                  |   1 +
>>   lib/elf.h                   |  57 ++++++
>>   lib/libcflat.h              |   1 +
>>   lib/acpi.c                  | 129 ++++++++-----
>>   lib/argv.c                  |   2 +-
>>   lib/arm/gic.c               | 127 ++++++++++++-
>>   lib/arm/io.c                |  29 ++-
>>   lib/arm/mmu.c               |   4 +
>>   lib/arm/psci.c              |  25 ++-
>>   lib/arm/setup.c             | 247 ++++++++++++++++++++-----
>>   lib/arm/timer.c             |  79 ++++++++
>>   lib/devicetree.c            |   2 +-
>>   lib/efi.c                   | 102 +++++++++++
>>   lib/printf.c                | 194 ++++++++++++++++++--
>>   arm/efi/elf_aarch64_efi.lds |  63 +++++++
>>   arm/flat.lds                |   2 +-
>>   arm/cstart.S                |  29 ++-
>>   arm/cstart64.S              |  28 ++-
>>   arm/efi/crt0-efi-aarch64.S  | 143 +++++++++++++++
>>   arm/dummy.c                 |   4 +
>>   arm/efi/reloc_aarch64.c     |  93 ++++++++++
>>   arm/micro-bench.c           |   4 +-
>>   arm/timer.c                 |  10 +-
>>   x86/s3.c                    |  19 +-
>>   x86/vmexit.c                |   2 +-
>>   38 files changed, 1700 insertions(+), 258 deletions(-)
>>   create mode 100755 arm/efi/run
>>   create mode 100644 lib/elf.h
>>   create mode 100644 lib/arm/timer.c
>>   create mode 100644 arm/efi/elf_aarch64_efi.lds
>>   create mode 100644 arm/efi/crt0-efi-aarch64.S
>>   create mode 100644 arm/dummy.c
>>   create mode 100644 arm/efi/reloc_aarch64.c
>>
>> -- 
>> 2.25.1
>>
