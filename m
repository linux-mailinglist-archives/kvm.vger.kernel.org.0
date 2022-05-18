Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AD952BBEA
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 16:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbiERMrb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 08:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238281AbiERMrC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 08:47:02 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0D7B61BB117
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 05:45:03 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D27E1042;
        Wed, 18 May 2022 05:44:22 -0700 (PDT)
Received: from [10.2.13.43] (Q2TWYV475D.cambridge.arm.com [10.2.13.43])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8AC993F73D;
        Wed, 18 May 2022 05:44:21 -0700 (PDT)
Message-ID: <3376d2b0-7eec-212b-aedf-c4aa34be254c@arm.com>
Date:   Wed, 18 May 2022 13:44:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [kvm-unit-tests PATCH v2 00/23] EFI and ACPI support for arm64
Content-Language: en-GB
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, drjones@redhat.com, pbonzini@redhat.com,
        jade.alglave@arm.com, alexandru.elisei@arm.com
References: <20220506205605.359830-1-nikos.nikoleris@arm.com>
 <YoPhyyz+l3NkcAb5@google.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
In-Reply-To: <YoPhyyz+l3NkcAb5@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Ricardo,

On 17/05/2022 18:56, Ricardo Koller wrote:
> Hi Nikos,
> 
> On Fri, May 06, 2022 at 09:55:42PM +0100, Nikos Nikoleris wrote:
>> Hello,
>>
>> This patch series adds initial support for building arm64 tests as EFI
>> tests and running them under QEMU. Much like x86_64 we import external
>> dependencies from gnu-efi and adopt them to work with types and other
>> assumptions from kvm-unit-tests. In addition, this series adds support
>> for discovering parts of the machine using ACPI.
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
> 
> Thanks very much for this!
> 
> I'm having some issues with the other tests. I'm cross-compiling with
> gcc-11. But then "selftest setup" passes and others, like the timer
> test, fail:
> 
> 	$ ./configure --arch=arm64 --cross-prefix=aarch64-linux-gnu- \
> 		--processor=max --enable-efi
> 	$ make
> 
> 	passes:
> 	$ ./arm/efi/run ./arm/selftest.efi -smp 2 -m 256 \
> 		-append "setup smp=2 mem=256"
> 
> 	fails:
> 	$ ./arm/efi/run ./arm/timer.efi -smp 1 -m 256
> 
> 	Load address: 5833e000
> 	PC: 5834ad20 PC offset: cd20
> 	Unhandled exception ec=0x25 (DABT_EL1)
> 	Vector: 4 (el1h_sync)
> 	ESR_EL1:         96000006, ec=0x25 (DABT_EL1)
> 	FAR_EL1: 0000000000000004 (valid)
> 	Exception frame registers:
> 	pc : [<000000005834ad20>] lr : [<000000005834cadc>] pstate: 600003c5
> 	sp : 000000005f70fd80
> 	x29: 000000005f70ffe0 x28: 0000000000000000
> 	x27: 000000005835dc50 x26: 000000005834eb80
> 	x25: 000000000000d800 x24: 000000005f70fe50
> 	x23: 0000000000000000 x22: 000000005835f000
> 	x21: 000000005834eb80 x20: 0000000000000000
> 	x19: 00000000ffffffff x18: 0000000000000000
> 	x17: 0000000000000009 x16: 000000005bae8c38
> 	x15: 0000000000000002 x14: 0000000000000001
> 	x13: 0000000058350000 x12: 0000000058350000
> 	x11: 000000005833e000 x10: 000000000005833d
> 	x9 : 0000000000000000 x8 : 0000000000000000
> 	x7 : 0000000000000000 x6 : 0000000000000001
> 	x5 : 00000000000000c9 x4 : 000000005f70fe68
> 	x3 : 000000005f70fe68 x2 : 000000005834eb80
> 	x1 : 00000000ffffffff x0 : 0000000000000000
> 

Thank you for having a look!

Apologies, I should have been more explicit about this. At this point, 
not all tests run successfully. There are bits and pieces missing, some 
of which I tried to list in this TODO list and more that I missed. For 
example, to get the timer tests to pass we have to add support for GIC 
initialization through ACPI.

I've continued working on this series, and I will be ironing some of 
these issues out and, in the meantime, I wanted some early feedback on 
whether some of these features are even desirable upstream (e.g., ACPI 
support for arm64).

I don't want to spam the list too much and I will wait for comments 
before I send a v3 but I already have a couple of fixes and one more 
patch [1]. With these applied both the timer and most gicv3 tests pass.

[1]: https://github.com/relokin/kvm-unit-tests/tree/target-efi-upstream

Thanks,

Nikos

> Thanks!
> Ricardo
> 
>> Or all tests:
>>
>> $> ./run_tests.sh
>>
>> There are a few items that this series does not address but they would
>> be useful to have:
>>
>> * Support for booting the system from EL2. Currently, we assume that a
>> tests starts running at EL1. This the case when we run with EFI, it's
>> not always the case in hardware.
>>
>> * Support for reading environment variables and populating __envp.
>>
>> * Support for discovering the chr-testdev through ACPI.
>>
>> PS: Apologies for the mess with v1. Due to a mistake in my git
>> send-email configuration some patches didn't make it to the list and
>> the right recipients.
>>
>> Thanks,
>>
>> Nikos
>>
>> Andrew Jones (3):
>>    arm/arm64: mmu_disable: Clean and invalidate before disabling
>>    arm/arm64: Rename etext to _etext
>>    arm64: Add a new type of memory type flag MR_F_RESERVED
>>
>> Nikos Nikoleris (20):
>>    lib: Move acpi header and implementation to lib
>>    lib: Ensure all struct definition for ACPI tables are packed
>>    lib: Add support for the XSDT ACPI table
>>    lib: Extend the definition of the ACPI table FADT
>>    arm/arm64: Add support for setting up the PSCI conduit through ACPI
>>    arm/arm64: Add support for discovering the UART through ACPI
>>    arm/arm64: Add support for timer initialization through ACPI
>>    arm/arm64: Add support for cpu initialization through ACPI
>>    lib/printf: Support for precision modifier in printing strings
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
>>   arm/efi/run                 |  61 +++++++++
>>   arm/run                     |   8 +-
>>   configure                   |  15 ++-
>>   Makefile                    |   4 -
>>   arm/Makefile.arm            |   6 +
>>   arm/Makefile.arm64          |  18 ++-
>>   arm/Makefile.common         |  48 +++++--
>>   x86/Makefile.common         |   2 +-
>>   x86/Makefile.x86_64         |   4 +
>>   lib/linux/efi.h             |  44 ++++++
>>   lib/arm/asm/setup.h         |   3 +
>>   lib/arm/asm/timer.h         |   2 +
>>   lib/x86/asm/setup.h         |   2 +-
>>   lib/acpi.h                  | 260 ++++++++++++++++++++++++++++++++++++
>>   lib/stdlib.h                |   1 +
>>   lib/x86/acpi.h              | 112 ----------------
>>   lib/acpi.c                  | 124 +++++++++++++++++
>>   lib/arm/io.c                |  21 ++-
>>   lib/arm/mmu.c               |   4 +
>>   lib/arm/psci.c              |  25 +++-
>>   lib/arm/setup.c             | 247 +++++++++++++++++++++++++++-------
>>   lib/arm/timer.c             |  73 ++++++++++
>>   lib/devicetree.c            |   2 +-
>>   lib/efi.c                   | 123 +++++++++++++++++
>>   lib/printf.c                | 183 +++++++++++++++++++++++--
>>   lib/string.c                |   2 +-
>>   lib/x86/acpi.c              |  82 ------------
>>   arm/efi/elf_aarch64_efi.lds |  63 +++++++++
>>   arm/flat.lds                |   2 +-
>>   arm/cstart.S                |  29 +++-
>>   arm/cstart64.S              |  28 +++-
>>   arm/efi/crt0-efi-aarch64.S  | 143 ++++++++++++++++++++
>>   arm/dummy.c                 |   4 +
>>   arm/efi/reloc_aarch64.c     |  93 +++++++++++++
>>   x86/s3.c                    |  20 +--
>>   x86/vmexit.c                |   4 +-
>>   37 files changed, 1556 insertions(+), 320 deletions(-)
>>   create mode 100755 arm/efi/run
>>   create mode 100644 lib/acpi.h
>>   delete mode 100644 lib/x86/acpi.h
>>   create mode 100644 lib/acpi.c
>>   create mode 100644 lib/arm/timer.c
>>   delete mode 100644 lib/x86/acpi.c
>>   create mode 100644 arm/efi/elf_aarch64_efi.lds
>>   create mode 100644 arm/efi/crt0-efi-aarch64.S
>>   create mode 100644 arm/dummy.c
>>   create mode 100644 arm/efi/reloc_aarch64.c
>>
>> -- 
>> 2.25.1
>>
