Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F016F3A6C
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 00:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbjEAW1i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 May 2023 18:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjEAW1h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 May 2023 18:27:37 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E7742123
        for <kvm@vger.kernel.org>; Mon,  1 May 2023 15:27:34 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 572104B3;
        Mon,  1 May 2023 15:28:18 -0700 (PDT)
Received: from [192.168.5.23] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 34AA33F5A1;
        Mon,  1 May 2023 15:27:33 -0700 (PDT)
Message-ID: <658590ba-1c73-87cd-b1b1-bcbf3e556f29@arm.com>
Date:   Mon, 1 May 2023 23:27:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.1
Subject: Re: [kvm-unit-tests PATCH v5 00/29] EFI and ACPI support for arm64
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com, seanjc@google.com
References: <20230428120405.3770496-1-nikos.nikoleris@arm.com>
 <20230429-6da987552a8d15281f8444c9@orel>
 <20230429-342c8a26e5db45474631a307@orel>
 <6857da77-8d1e-ebcb-1571-6419d463fa53@arm.com>
 <20230501-85b5dca6ed2d86d8bb0e55b6@orel>
Content-Language: en-GB
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <20230501-85b5dca6ed2d86d8bb0e55b6@orel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/05/2023 12:21, Andrew Jones wrote:
> On Sun, Apr 30, 2023 at 01:02:42AM +0100, Nikos Nikoleris wrote:
>> On 29/04/2023 17:21, Andrew Jones wrote:
>>> On Sat, Apr 29, 2023 at 06:18:25PM +0200, Andrew Jones wrote:
>>>> On Fri, Apr 28, 2023 at 01:03:36PM +0100, Nikos Nikoleris wrote:
>>>>> Hello,
>>>>>
>>>>> This series adds initial support for building arm64 tests as EFI
>>>>> apps and running them under QEMU. Much like x86_64, we import external
>>>>> dependencies from gnu-efi and adapt them to work with types and other
>>>>> assumptions from kvm-unit-tests. In addition, this series adds support
>>>>> for enumerating parts of the system using ACPI.
>>>>>
>>>>> The first set of patches, moves the existing ACPI code to the common
>>>>> lib path. Then, it extends definitions and functions to allow for more
>>>>> robust discovery of ACPI tables. We add support for setting up the PSCI
>>>>> conduit, discovering the UART, timers, GIC and cpus via ACPI. The code
>>>>> retains existing behavior and gives priority to discovery through DT
>>>>> when one has been provided.
>>>>>
>>>>> In the second set of patches, we add support for getting the command
>>>>> line from the EFI shell. This is a requirement for many of the
>>>>> existing arm64 tests.
>>>>>
>>>>> In the third set of patches, we import code from gnu-efi, make minor
>>>>> changes and add an alternative setup sequence from arm64 systems that
>>>>> boot through EFI. Finally, we add support in the build system and a
>>>>> run script which is used to run an EFI app.
>>>>>
>>>>> After this set of patches one can build arm64 EFI tests:
>>>>>
>>>>> $> ./configure --enable-efi
>>>>> $> make
>>>>>
>>>>> And use the run script to run an EFI tests:
>>>>>
>>>>> $> ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 -append "setup smp=2 mem=256"
>>>>>
>>>>> Or all tests:
>>>>>
>>>>> $> ./run_tests.sh
>>>>>
>>>>> There are a few items that this series does not address but they would
>>>>> be useful to have:
>>>>>    - Support for booting the system from EL2. Currently, we assume that a
>>>>>      test starts EL1. This will be required to run EFI tests on sytems
>>>>>      that implement EL2.
>>>>>    - Support for reading environment variables and populating __envp.
>>>>>    - Support for discovering the PCI subsystem using ACPI.
>>>>>    - Get rid of other assumptions (e.g., vmalloc area) that don't hold on
>>>>>      real HW.
>>>>>    - Various fixes related to cache maintaince to better support turn the
>>>>>      MMU off.
>>>>>    - Switch to a new stack and avoid relying on the one provided by EFI.
>>>>>
>>>>> git branch: https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v5
>>>>>
>>>>> v4: https://lore.kernel.org/kvmarm/20230213101759.2577077-1-nikos.nikoleris@arm.com/
>>>>> v3: https://lore.kernel.org/all/20220630100324.3153655-1-nikos.nikoleris@arm.com/
>>>>> v2: https://lore.kernel.org/kvm/20220506205605.359830-1-nikos.nikoleris@arm.com/
>>>>>
>>>>> Changes in v5:
>>>>>    - Minor style changes (thanks Shaoqin).
>>>>>    - Avoid including lib/acpi.o to cflatobjs twice (thanks Drew).
>>>>>    - Increase NR_INITIAL_MEM_REGIONS to avoid overflows and add check when
>>>>>      we run out of space (thanks Shaoqin).
>>>>>
>>>>> Changes in v4:
>>>>>    - Removed patch that reworks cache maintenance when turning the MMU
>>>>>      off. This is not strictly required for EFI tests running with tcg and
>>>>>      will be addressed in a separate series by Alex.
>>>>>    - Fix compilation for arm (Alex).
>>>>>    - Convert ACPI tables to Linux style (Alex).
>>>>>
>>>>> Changes in v3:
>>>>>    - Addressed feedback from Drew, Alex and Ricardo. Many thanks for the reviews!
>>>>>    - Added support for discovering the GIC through ACPI
>>>>>    - Added a missing header file (<elf.h>)
>>>>>    - Added support for correctly parsing the outcome of tests (./run_tests)
>>>>>
>>>>
>>>> Thanks, Nikos!
>>>>
>>>> I'd like to get an ack from either Paolo or Sean on the changes to ACPI,
>>>> as they're shared with x86, and there are also some x86 code changes.
>>>
>>> Actually, there are two build pipeline failures with the new ACPI code.
>>> Please take a look at
>>>
>>> https://gitlab.com/jones-drew/kvm-unit-tests/-/pipelines/852864569
>>>
>>
>> Thanks for reviewing the series!
>>
>> I think this fixes the compilation issues:
>>
>> diff --git a/lib/acpi.h b/lib/acpi.h
>> index 202d832e..c330c877 100644
>> --- a/lib/acpi.h
>> +++ b/lib/acpi.h
>> @@ -292,7 +292,8 @@ struct acpi_table_gtdt {
>>          u32 platform_timer_offset;
>>   };
>>
>> -#pragma pack(0)
>> +/* Reset to default packing */
>> +#pragma pack()
>>
>>   void set_efi_rsdp(struct acpi_table_rsdp *rsdp);
>>   void *find_acpi_table_addr(u32 sig);
>> diff --git a/lib/acpi.c b/lib/acpi.c
>> index 760cd8b2..0440cddb 100644
>> --- a/lib/acpi.c
>> +++ b/lib/acpi.c
>> @@ -70,7 +70,7 @@ void *find_acpi_table_addr(u32 sig)
>>                  return rsdt;
>>
>>          if (rsdp->revision >= 2) {
>> -               xsdt = (void *)rsdp->xsdt_physical_address;
>> +               xsdt = (void *)(ulong) rsdp->xsdt_physical_address;
>>                  if (xsdt && xsdt->signature != XSDT_SIGNATURE)
>>                          xsdt = NULL;
>>          }
>>
>>> Thanks,
>>> drew
>>>
>>>>
>>>> Also,
>>>>
>>>>     1) It'd be nice if this worked with DT, too. We can use UEFI with DT
>>>>        when adding '-no-acpi' to the QEMU command line. setup_efi() needs
>>>>        to learn how to find the dtb and most the '#ifdef CONFIG_EFI's
>>>>        would need to change to a new CONFIG_ACPI guard.
>>>>
>>
>> I had a quick look at it at some point and it didn't look straightforward
>> but I'll check again.
>>
>>>>     2) The debug bp and ss tests fail with EFI, but not without, for me.
>>>>
>>
>> I think, I've found the problem, the patch below fixes it for me.
>>
>> diff --git a/arm/debug.c b/arm/debug.c
>> index b3e9749c..126fa267 100644
>> --- a/arm/debug.c
>> +++ b/arm/debug.c
>> @@ -292,11 +292,14 @@ static noinline void test_hw_bp(bool migrate)
>>          hw_bp_idx = 0;
>>
>>          /* Trap on up to 16 debug exception unmask instructions. */
>> -       asm volatile("hw_bp0:\n"
>> -            "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr
>> daifclr, #8\n"
>> -            "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr
>> daifclr, #8\n"
>> -            "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr
>> daifclr, #8\n"
>> -            "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8; msr
>> daifclr, #8\n");
>> +       asm volatile(
>> +               ".globl hw_bp0\n"
>> +               "hw_bp0:\n"
>> +                       "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8;
>> msr daifclr, #8\n"
>> +                       "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8;
>> msr daifclr, #8\n"
>> +                       "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8;
>> msr daifclr, #8\n"
>> +                       "msr daifclr, #8; msr daifclr, #8; msr daifclr, #8;
>> msr daifclr, #8\n"
>> +               );
>>
>>          for (i = 0, addr = (uint64_t)&hw_bp0; i < num_bp; i++, addr += 4)
>>                  report(hw_bp_addr[i] == addr, "hw breakpoint: %d", i);
>> @@ -367,11 +370,14 @@ static noinline void test_ss(bool migrate)
>>
>>          asm volatile("msr daifclr, #8");
>>
>> -       asm volatile("ss_start:\n"
>> +       asm volatile(
>> +               ".globl ss_start\n"
>> +               "ss_start:\n"
>>                          "mrs x0, esr_el1\n"
>>                          "add x0, x0, #1\n"
>>                          "msr daifset, #8\n"
>> -                       : : : "x0");
>> +                       : : : "x0"
>> +               );
>>
>>          report(ss_addr[0] == (uint64_t)&ss_start, "single step");
>>   }
>>
>>>>     3) The timer test runs (and succeeds) when run with
>>>>        './arm/efi/run ./arm/timer.efi', but not when run with
>>>>        './run_tests.sh -g timer'. This is because UEFI takes
>>>>        up all the given timeout time (10s), and then the test times out.
>>>>        The hackyish fix below resolves it for me. I'll consider posting it
>>>>        as a real patch
>>>>
>>
>> I see. I didn't hit the timeout on my test machine but I tried on a slower
>> machine and I did.
>>
>> New branch with the fixups here:
>>
>> https://github.com/relokin/kvm-unit-tests/pull/new/target-efi-upstream-v5
> 
> Thanks for the quick fixes. Can you update your tree and make an MR? I
> no longer use github.com/rhdrjones/kvm-unit-tests. I use
> 
> https://gitlab.com/jones-drew/kvm-unit-tests.git
> 

You mean a MR into your repo and to the branch arm/queue, don't you? 
I've tried doing that but I get an error: "Target branch "arm/queue" 
does not exist", but it allows me to create a MR into other repos. Am I 
doing something wrong?

My branch on gitlab:

https://gitlab.com/nnikoleris/kvm-unit-tests/-/tree/target-efi-upstream-v6-pre

Has the new fixups squashed and I've added Shaoqin's Reviewed-by tags. 
And the branch with the fixups separately lives here:

https://gitlab.com/nnikoleris/kvm-unit-tests/-/tree/target-efi-upstream-v5-fixups

Do you want me to add your patch as well? Or are you going to add it 
afterwards? Meanwhile, I've tried adding support for booting using a 
fdt. I think it's not too hard, but I wouldn't mind merging this series 
first and looking at the patches for the fdt support later.

Thanks,

Nikos


> Thanks,
> drew
> 
>>
>> Many thanks,
>>
>> Nikos
>>
>>>> Thanks,
>>>> drew
>>>>
>>>> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
>>>> index 51e4b97b27d1..72ce718b1170 100644
>>>> --- a/scripts/arch-run.bash
>>>> +++ b/scripts/arch-run.bash
>>>> @@ -94,7 +94,17 @@ run_qemu_status ()
>>>>    timeout_cmd ()
>>>>    {
>>>> +	local s
>>>> +
>>>>    	if [ "$TIMEOUT" ] && [ "$TIMEOUT" != "0" ]; then
>>>> +		if [ "$CONFIG_EFI" = 'y' ]; then
>>>> +			s=${TIMEOUT: -1}
>>>> +			if [ "$s" = 's' ]; then
>>>> +				TIMEOUT=${TIMEOUT:0:-1}
>>>> +				((TIMEOUT += 10)) # Add 10 seconds for booting UEFI
>>>> +				TIMEOUT="${TIMEOUT}s"
>>>> +			fi
>>>> +		fi
>>>>    		echo "timeout -k 1s --foreground $TIMEOUT"
>>>>    	fi
>>>>    }
