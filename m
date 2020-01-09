Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99F4C135666
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 11:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbgAIKBh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 05:01:37 -0500
Received: from foss.arm.com ([217.140.110.172]:56152 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbgAIKBh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 05:01:37 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 513C131B;
        Thu,  9 Jan 2020 02:01:36 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 43E793F6C4;
        Thu,  9 Jan 2020 02:01:35 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 00/18] arm/arm64: Various fixes
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
References: <1577808589-31892-1-git-send-email-alexandru.elisei@arm.com>
 <20200106092815.bxmiuai3ltv7nl64@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <029bacc5-36b5-ca55-0ae2-a2994fcab12e@arm.com>
Date:   Thu, 9 Jan 2020 10:01:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200106092815.bxmiuai3ltv7nl64@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 1/6/20 9:28 AM, Andrew Jones wrote:
> On Tue, Dec 31, 2019 at 04:09:31PM +0000, Alexandru Elisei wrote:
>> This is a combination of the fixes from my EL2 series [1] and other new
>> fixes. I've rebased the series on top of 2c6589bc4e8b ("Update AMD
>> instructions to conform to LLVM assembler"), which means that I had to
>> switch the order of parameters for the report function.
>>
>> This time around I tried to do a better job at testing. I've ran
>> kvm-unit-tests in the following configurations:
>>
>> - with kvmtool, on an arm64 host kernel: 64 and 32 bit tests, with GICv3
>>   (on an Ampere eMAG) and GICv2 (on a AMD Seattle box).
>>
>> - with qemu, on an arm64 host kernel:
>>     a. with accel=kvm, 64 and 32 bit tests, with GICv3 (Ampere eMAG) and
>>        GICv2 (Seattle).
>>     b. with accel=tcg, 64 and 32 bit tests, on the Ampere eMAG machine.
>>
>> I didn't run the 32 bit tests under a 32 bit host kernel because I don't
>> have a 32 bit arm board at hand at the moment. It's also worth noting that
>> when I tried running the selftest-vectors-kernel tests on an ancient
>> version of qemu (QEMU emulator version 2.5.0 (Debian
>> 1:2.5+dfsg-5ubuntu10.42)) I got the following error:
>>
>>  $ arm/run arm/selftest.flat -append vectors-kernel
>> /usr/bin/qemu-system-aarch64 -nodefaults -machine virt,accel=tcg -cpu cortex-a57 -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd -device pci-testdev -display none -serial stdio -kernel arm/selftest.flat -append vectors-kernel # -initrd /tmp/tmp.zNO1kWtmuM
>> PASS: selftest: vectors-kernel: und
>> PASS: selftest: vectors-kernel: svc
>> qemu: fatal: Trying to execute code outside RAM or ROM at 0x0000003fffff0000
>>
>> PC=0000003fffff0000  SP=00000000400aff70
>> X00=00000000400805a0 X01=0000000040092f20 X02=0000003fffff0000 X03=0000000040092f20
>> X04=0000000000000010 X05=00000000400aff40 X06=00000000400aff70 X07=00000000400aff70
>> X08=00000000400afde0 X09=ffffff80ffffffc8 X10=00000000400afe20 X11=00000000400afe20
>> X12=00000000400b0000 X13=00000000400afeac X14=00000000400b0000 X15=0000000000000000
>> X16=0000000000000000 X17=0000000000000000 X18=0000000000000000 X19=0000000040092000
>> X20=0000000000000004 X21=0000000040092e98 X22=0000000040092f20 X23=0000000000000000
>> X24=0000000000000000 X25=0000000000000000 X26=0000000000000000 X27=0000000000000000
>> X28=0000000000000000 X29=0000000000000000 X30=000000004008052c 
>> PSTATE=800003c5 N--- EL1h
>> q00=0000000000000000:0000000000000000 q01=0000000000000000:0000000000000000
>> q02=0000000000000000:0000000000000000 q03=0000000000000000:0000000000000000
>> q04=0000000000000000:0000000000000000 q05=0000000000000000:0000000000000000
>> q06=0000000000000000:0000000000000000 q07=0000000000000000:0000000000000000
>> q08=0000000000000000:0000000000000000 q09=0000000000000000:0000000000000000
>> q10=0000000000000000:0000000000000000 q11=0000000000000000:0000000000000000
>> q12=0000000000000000:0000000000000000 q13=0000000000000000:0000000000000000
>> q14=0000000000000000:0000000000000000 q15=0000000000000000:0000000000000000
>> q16=0000000000000000:0000000000000000 q17=0000000000000000:0000000000000000
>> q18=0000000000000000:0000000000000000 q19=0000000000000000:0000000000000000
>> q20=0000000000000000:0000000000000000 q21=0000000000000000:0000000000000000
>> q22=0000000000000000:0000000000000000 q23=0000000000000000:0000000000000000
>> q24=0000000000000000:0000000000000000 q25=0000000000000000:0000000000000000
>> q26=0000000000000000:0000000000000000 q27=0000000000000000:0000000000000000
>> q28=0000000000000000:0000000000000000 q29=0000000000000000:0000000000000000
>> q30=0000000000000000:0000000000000000 q31=0000000000000000:0000000000000000
>> FPCR: 00000000  FPSR: 00000000
>> QEMU Aborted
>>
>> I'm not sure if we support such an old version of qemu. If we do, please
>> let me know, and I'll try to come up with a solution. I am reluctant to
>> drop the prefetch abort test because it uncovered a bug in the nested
>> virtualization patches.
>>
>> Summary of the patches:
>> * Patch 1 adds coherent translation table walks for ARMv7 and removes
>>   unneeded dcache maintenance.
>> * Patches 2-4 make translation table updates more robust.
>> * Patches 5-6 fix a pretty serious bug in our PSCI test, which was causing
>>   an infinite loop of prefetch aborts.
>> * Patches 7-10 add a proper test for prefetch aborts. The test now uses
>>   mmu_clear_user.
>> * Patches 11-13 are fixes for the timer test.
>> * Patches 14-15 fix turning the MMU off.
>> * Patches 16-18 are small fixes to make the code more robust, and perhaps
>>   more important, remove unnecessary operations that might hide real bugs
>>   in KVM.
>>
>> Patches 1-4, 9, 18 are new. The rest are taken from the EL2 series, and
>> I've kept the Reviewed-by tag where appropriate.
>>
>> Changes in v3:
>> * Implemented review comments.
>> * Minor cosmetic changes to the commit messages here and there.
>> * Removed the duplicate DSB ISHST that I had added to mmu.c in patch #1.
>>   flush_tlb_page already has the needed barriers.
>> * Replaced patch #2 "lib: arm64: Remove barriers before TLB operations"
>>   with "lib: arm: Add proper data synchronization barriers for TLBIs".
>>   I've decided to keep the needed barriers in the flush_tlb_* functions, to
>>   match what the kernel does.
>> * Added a missing DSB ISHST in flush_tlb_all in patch #8 "lib: arm:
>>   Implement flush_tlb_all"
>> * The address for the prefetch abort test is now in hexadecimal to prevent
>>   a compile error.
>> * Added information about the KVM bug that patch #13 "arm64: timer: Test
>>   behavior when timer disabled or masked" helped find.
>> * Explained in the commit message for #15 how to reproduce some of the
>>   errors that I was seeing without the patch.
>>
>> Changes in v2:
>> * Fixed the prefetch abort test on QEMU by changing the address used to
>>   cause the abort.
>>
>> [1] https://www.spinics.net/lists/kvm/msg196797.html
>>
>> Alexandru Elisei (18):
>>   lib: arm/arm64: Remove unnecessary dcache maintenance operations
>>   lib: arm: Add proper data synchronization barriers for TLBIs
>>   lib: Add WRITE_ONCE and READ_ONCE implementations in compiler.h
>>   lib: arm/arm64: Use WRITE_ONCE to update the translation tables
>>   lib: arm/arm64: Remove unused CPU_OFF parameter
>>   arm/arm64: psci: Don't run C code without stack or vectors
>>   lib: arm/arm64: Add missing include for alloc_page.h in pgtable.h
>>   lib: arm: Implement flush_tlb_all
>>   lib: arm/arm64: Teach mmu_clear_user about block mappings
>>   arm/arm64: selftest: Add prefetch abort test
>>   arm64: timer: Write to ICENABLER to disable timer IRQ
>>   arm64: timer: EOIR the interrupt after masking the timer
>>   arm64: timer: Test behavior when timer disabled or masked
>>   lib: arm/arm64: Refuse to disable the MMU with non-identity stack
>>     pointer
>>   arm/arm64: Perform dcache clean + invalidate after turning MMU off
>>   arm: cstart64.S: Downgrade TLBI to non-shareable in asm_mmu_enable
>>   arm/arm64: Invalidate TLB before enabling MMU
>>   arm: cstart64.S: Remove icache invalidation from asm_mmu_enable
>>
>>  lib/linux/compiler.h          |  83 +++++++++++++++++++++++++++++++
>>  lib/arm/asm/gic-v3.h          |   1 +
>>  lib/arm/asm/gic.h             |   1 +
>>  lib/arm/asm/mmu-api.h         |   2 +-
>>  lib/arm/asm/mmu.h             |  18 ++++---
>>  lib/arm/asm/pgtable-hwdef.h   |  11 +++++
>>  lib/arm/asm/pgtable.h         |  20 ++++++--
>>  lib/arm/asm/processor.h       |   6 +++
>>  lib/arm64/asm/esr.h           |   3 ++
>>  lib/arm64/asm/pgtable-hwdef.h |   3 ++
>>  lib/arm64/asm/pgtable.h       |  15 +++++-
>>  lib/arm64/asm/processor.h     |   6 +++
>>  lib/arm/mmu.c                 |  60 ++++++++++++----------
>>  lib/arm/processor.c           |  10 ++++
>>  lib/arm/psci.c                |   4 +-
>>  lib/arm/setup.c               |   2 +
>>  lib/arm64/processor.c         |  11 +++++
>>  arm/cstart.S                  |  40 ++++++++++++++-
>>  arm/cstart64.S                |  35 +++++++++++--
>>  arm/cache.c                   |   3 +-
>>  arm/psci.c                    |   5 +-
>>  arm/selftest.c                | 112 +++++++++++++++++++++++++++++++++++++++++-
>>  arm/timer.c                   |  38 +++++++++-----
>>  23 files changed, 425 insertions(+), 64 deletions(-)
>>  create mode 100644 lib/linux/compiler.h
>>
>> -- 
>> 2.7.4
>>
> Thanks Alexandru. I'm queuing everything except
>
>  arm/arm64: psci: Don't run C code without stack or vectors
>  arm/arm64: selftest: Add prefetch abort test
>  arm64: timer: EOIR the interrupt after masking the timer
>  arm64: timer: Test behavior when timer disabled or masked
>  arm/arm64: Perform dcache clean + invalidate after turning MMU off
>
> as those had comments from Andre and myself to address.

I noticed that Paolo merged the pull request, I'll send the remaining patches as v4.

Thanks,
Alex
>
> Thanks,
> drew 
>
