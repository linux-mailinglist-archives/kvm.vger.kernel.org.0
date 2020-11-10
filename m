Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D485B2ADB30
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 17:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732720AbgKJQDo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Nov 2020 11:03:44 -0500
Received: from foss.arm.com ([217.140.110.172]:58062 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730870AbgKJQDo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Nov 2020 11:03:44 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 26C9C1396;
        Tue, 10 Nov 2020 08:03:43 -0800 (PST)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3955F3F718;
        Tue, 10 Nov 2020 08:03:42 -0800 (PST)
Subject: Re: [kvm-unit-tests PATCH v3 0/2] arm64: Add support for configuring
 the translation granule
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Andrew Jones <drjones@redhat.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, mark.rutland@arm.com, jade.alglave@arm.com,
        luc.maranget@inria.fr, andre.przywara@arm.com
References: <20201104130352.17633-1-nikos.nikoleris@arm.com>
 <20201109154103.j3zewa2sndw2veda@kamzik.brq.redhat.com>
 <a4a3e3fe-2090-955a-f1d3-48591806b213@arm.com>
Message-ID: <e59cc026-c4a9-e383-9bcc-df8be69d6102@arm.com>
Date:   Tue, 10 Nov 2020 16:04:58 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <a4a3e3fe-2090-955a-f1d3-48591806b213@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On 11/9/20 4:16 PM, Alexandru Elisei wrote:
> Hi Andrew,
>
> On 11/9/20 3:41 PM, Andrew Jones wrote:
>> On Wed, Nov 04, 2020 at 01:03:50PM +0000, Nikos Nikoleris wrote:
>>> Hi all,
>>>
>>> One more update to the series that allows us to configure the
>>> translation granule in arm64. Again, thanks to Drew and Alex for
>>> their reviews and their suggestions.
>>>
>>> v1: 
>>> https://lore.kernel.org/kvm/006a19c0-cdf7-e76c-8335-03034bea9c7e@arm.com/T
>>> v2: 
>>> https://lore.kernel.org/kvm/20201102113444.103536-1-nikos.nikoleris@arm.com/
>>>
>>>
>>> Changes in v3:
>>>   - Re-ordered the two changes in the series
>>>   - Moved much of the code to check the configured granule from the C
>>>     preprocessor to run time.
>>>   - Avoid block mappings at the PUD level (Thanks Alex!)
>>>   - Formatting changes
>>>
>>> Changes in v2:
>>>   - Change the configure option from page-shift to page-size
>>>   - Check and warn if the configured granule is not supported
>>>
>>> Thanks,
>>>
>>> Nikos
>>>
>>>
>>> Nikos Nikoleris (2):
>>>   arm64: Check if the configured translation granule is supported
>>>   arm64: Add support for configuring the translation granule
>>>
>>>  configure                     | 27 ++++++++++++++
>>>  lib/arm/asm/page.h            |  4 +++
>>>  lib/arm/asm/pgtable-hwdef.h   |  4 +++
>>>  lib/arm/asm/pgtable.h         |  6 ++++
>>>  lib/arm/asm/thread_info.h     |  4 ++-
>>>  lib/arm64/asm/page.h          | 35 ++++++++++++++----
>>>  lib/arm64/asm/pgtable-hwdef.h | 42 +++++++++++++++++-----
>>>  lib/arm64/asm/pgtable.h       | 68 +++++++++++++++++++++++++++++++++--
>>>  lib/arm64/asm/processor.h     | 36 +++++++++++++++++++
>>>  lib/libcflat.h                | 20 ++++++-----
>>>  lib/arm/mmu.c                 | 31 ++++++++++------
>>>  arm/cstart64.S                | 10 +++++-
>>>  12 files changed, 249 insertions(+), 38 deletions(-)
>>>
>>> -- 
>>> 2.17.1
>>>
>> Looks good to me.
>>
>> Alex, did you plan to review again?
> Yes, I forgot about it, sorry. I'll review them as soon as possible (tomorrow most
> likely).

Tested on a rockpro64, on the little (A53) and the big (A72) cores, 4k and 64k
pages. Results are similar, with a few peculiarities:

- If you change the page size and compile without doing make clean, the
assert(pgd_valid(*pgd)) from mmu_clear_user() fails. If the function is modified
to use mmu_idmap instead of the pgtable argument (which should be the same thing)
everything works as expected. My guess is that something doesn't get recompiled
properly, but that doesn't affect the correctness of this series. I don't think
that kvm-unit-tests supports changing the configuration and not cleaning previous
build artifacts (changing --arch without make clean definitely breaks compilation).

- Some of the PMU tests are failing on the big cores. I remember running into the
same issue some time ago, I believe it was because KVM doesn't really support
big.little configurations. Did some digging at that time and if memory serves me
right it had to do with the fact that there are 2 PMUs in the system and KVM was
creating the events on the little cores (on the pmu pmu_a53 from the DTB) and an
error was returned when trying to install it on a big cores (pmu pmu_a72).

Also tested on my x86 machine using qemu TCG (still only 4k and 64k pages).

Regardless of the observations above, I believe the series works as expected. For
the entire series:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
