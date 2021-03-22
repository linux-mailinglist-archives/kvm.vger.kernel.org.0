Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 580C8343D2D
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 10:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhCVJpp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 05:45:45 -0400
Received: from foss.arm.com ([217.140.110.172]:56716 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhCVJpM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 05:45:12 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 839441063;
        Mon, 22 Mar 2021 02:45:11 -0700 (PDT)
Received: from C02W217MHV2R.local (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0DD83F718;
        Mon, 22 Mar 2021 02:45:10 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 1/4] arm/arm64: Avoid calling
 cpumask_test_cpu for CPUs above nr_cpu
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, alexandru.elisei@arm.com
References: <20210319122414.129364-1-nikos.nikoleris@arm.com>
 <20210319122414.129364-2-nikos.nikoleris@arm.com>
 <20210322093125.qlbr3wjvinyu7o6m@kamzik.brq.redhat.com>
From:   Nikos Nikoleris <nikos.nikoleris@arm.com>
Message-ID: <df9a70d0-0129-d3a4-9530-77a7354b8e47@arm.com>
Date:   Mon, 22 Mar 2021 09:45:09 +0000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210322093125.qlbr3wjvinyu7o6m@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 22/03/2021 09:31, Andrew Jones wrote:
> On Fri, Mar 19, 2021 at 12:24:11PM +0000, Nikos Nikoleris wrote:
>> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
>> ---
>>   lib/arm/asm/cpumask.h | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/lib/arm/asm/cpumask.h b/lib/arm/asm/cpumask.h
>> index 6683bb6..02124de 100644
>> --- a/lib/arm/asm/cpumask.h
>> +++ b/lib/arm/asm/cpumask.h
>> @@ -105,7 +105,7 @@ static inline void cpumask_copy(cpumask_t *dst, const cpumask_t *src)
>>   
>>   static inline int cpumask_next(int cpu, const cpumask_t *mask)
>>   {
>> -	while (cpu < nr_cpus && !cpumask_test_cpu(++cpu, mask))
>> +	while (++cpu < nr_cpus && !cpumask_test_cpu(cpu, mask))
>>   		;
>>   	return cpu;
> 

Thanks for reviewing this!


> This looks like the right thing to do, but I'm surprised that
> I've never seen an assert in cpumask_test_cpu, even though
> it looks like we call cpumask_next with cpu == nr_cpus - 1
> in several places.
> 

cpumask_next() would trigger one of the assertions in the 4th patch in 
this series without this fix. The 4th patch is a way to demonstrate (if 
we apply it without the rest) the problem of using cpu0's 
thread_info->cpu uninitialized.

> Can you please add a commit message explaining how you found
> this bug?
> 

Yes I'll do that.

Thanks,

Nikos

> Thanks,
> drew
> 
