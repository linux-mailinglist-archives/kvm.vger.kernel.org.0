Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA06151F8A
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 18:36:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbgBDRgx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 12:36:53 -0500
Received: from foss.arm.com ([217.140.110.172]:39272 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727310AbgBDRgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 12:36:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB149101E;
        Tue,  4 Feb 2020 09:36:52 -0800 (PST)
Received: from [10.1.196.63] (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id CF3233F68E;
        Tue,  4 Feb 2020 09:36:51 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v4 00/10] arm/arm64: Various fixes
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
 <20200203185949.btxvofvgj6brxmzi@kamzik.brq.redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d6c31196-14f6-4cbc-9ade-3bbcf2294136@arm.com>
Date:   Tue, 4 Feb 2020 17:36:50 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200203185949.btxvofvgj6brxmzi@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andrew,

On 2/3/20 6:59 PM, Andrew Jones wrote:
> On Fri, Jan 31, 2020 at 04:37:18PM +0000, Alexandru Elisei wrote:
>> These are the patches that were left unmerged from the previous version of
>> the series, plus a few new patches. Patch #1 "Makefile: Use
>> no-stack-protector compiler options" is straightforward and came about
>> because of a compile error I experienced on RockPro64.
>>
>> Patches #3 and #5 are the result of Andre's comments on the previous
>> version. When adding ISBs after register writes I noticed in the ARM ARM
>> that a read of the timer counter value can be reordered, and patch #4
>> tries to avoid that.
>>
>> Patch #7 is also the result of a review comment. For the GIC tests, we wait
>> up to 5 seconds for the interrupt to be asserted. However, the GIC tests
>> can use more than one CPU, which is not the case with the timer test. And
>> waiting for the GIC to assert the interrupt can happen up to 6 times (8
>> times after patch #9), so I figured that a timeout of 10 seconds for the
>> test is acceptable.
>>
>> Patch #8 tries to improve the way we test how the timer generates the
>> interrupt. If the GIC asserts the timer interrupt, but the device itself is
>> not generating it, that's a pretty big problem.
>>
>> Ran the same tests as before:
>>
>> - with kvmtool, on an arm64 host kernel: 64 and 32 bit tests, with GICv3
>>   (on an Ampere eMAG) and GICv2 (on a AMD Seattle box).
>>
>> - with qemu, on an arm64 host kernel:
>>     a. with accel=kvm, 64 and 32 bit tests, with GICv3 (Ampere eMAG) and
>>        GICv2 (Seattle).
>>     b. with accel=tcg, 64 and 32 bit tests, on the Ampere eMAG machine.
>>
>> Changes:
>> * Patches #1, #3, #4, #5, #7, #8 are new.
>> * For patch #2, as per Drew's suggestion, I changed the entry point to halt
>>   because the test is supposed to test if CPU_ON is successful.
>> * Removed the ISB from patch #6 because that was fixed by #3.
>> * Moved the architecture dependent function init_dcache_line_size to
>>   cpu_init in lib/arm/setup.c as per Drew's suggestion.
>>
>> Alexandru Elisei (10):
>>   Makefile: Use no-stack-protector compiler options
>>   arm/arm64: psci: Don't run C code without stack or vectors
>>   arm64: timer: Add ISB after register writes
>>   arm64: timer: Add ISB before reading the counter value
>>   arm64: timer: Make irq_received volatile
>>   arm64: timer: EOIR the interrupt after masking the timer
>>   arm64: timer: Wait for the GIC to sample timer interrupt state
>>   arm64: timer: Check the timer interrupt state
>>   arm64: timer: Test behavior when timer disabled or masked
>>   arm/arm64: Perform dcache clean + invalidate after turning MMU off
>>
>>  Makefile                  |  4 +-
>>  lib/arm/asm/processor.h   | 13 +++++++
>>  lib/arm64/asm/processor.h | 12 ++++++
>>  lib/arm/setup.c           |  8 ++++
>>  arm/cstart.S              | 22 +++++++++++
>>  arm/cstart64.S            | 23 ++++++++++++
>>  arm/psci.c                | 15 ++++++--
>>  arm/timer.c               | 79 ++++++++++++++++++++++++++++++++-------
>>  arm/unittests.cfg         |  2 +-
>>  9 files changed, 158 insertions(+), 20 deletions(-)
>>
>> -- 
>> 2.20.1
>>
> The series looks good to me. The first patch probably could have been
> posted separately, but I'll try to test the whole series tomorrow. If

Noted, next time I will try to do a better job separating the patches. I found the
bug while testing the arm64 fixes, and I was getting ready to send the patches, so
I just figured I'll send it as part of the series.

> all looks well, I'll prepare a pull request for Paolo.

Thank you very much for taking the time to review the patches! Much appreciated.

Thanks,
Alex
>
> Thanks,
> drew 
>
