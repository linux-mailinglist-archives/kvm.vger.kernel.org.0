Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B13213245
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 05:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgGCDme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 23:42:34 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:51734 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725937AbgGCDme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 23:42:34 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 48E51D56D85A85D98164;
        Fri,  3 Jul 2020 11:42:29 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Fri, 3 Jul 2020
 11:42:18 +0800
Subject: Re: [kvm-unit-tests PATCH v2 7/8] arm64: microbench: Add time limit
 for each individual test
To:     Auger Eric <eric.auger@redhat.com>, <drjones@redhat.com>,
        <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-8-wangjingyi11@huawei.com>
 <49bf0b58-38b9-1cd6-8396-b8561d6f90cb@redhat.com>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <9db9c741-8c1c-4c59-269e-9bb3c1a626f8@huawei.com>
Date:   Fri, 3 Jul 2020 11:42:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <49bf0b58-38b9-1cd6-8396-b8561d6f90cb@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 7/2/2020 9:23 PM, Auger Eric wrote:
> Hi Jingyi,
> 
> On 7/2/20 5:01 AM, Jingyi Wang wrote:
>> Besides using separate running times parameter, we add time limit
>> for loop_test to make sure each test should be done in a certain
>> time(5 sec here).
>>
>> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
>> ---
>>   arm/micro-bench.c | 17 +++++++++++------
>>   1 file changed, 11 insertions(+), 6 deletions(-)
>>
>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>> index 506d2f9..4c962b7 100644
>> --- a/arm/micro-bench.c
>> +++ b/arm/micro-bench.c
>> @@ -23,6 +23,7 @@
>>   #include <asm/gic-v3-its.h>
>>   
>>   #define NTIMES (1U << 16)
>> +#define MAX_NS (5 * 1000 * 1000 * 1000UL)
>>   
>>   static u32 cntfrq;
>>   
>> @@ -258,22 +259,26 @@ static void loop_test(struct exit_test *test)
>>   	uint64_t start, end, total_ticks, ntimes = 0;
>>   	struct ns_time total_ns, avg_ns;
>>   
>> +	total_ticks = 0;
>>   	if (test->prep) {
>>   		if(!test->prep()) {
>>   			printf("%s test skipped\n", test->name);
>>   			return;
>>   		}
>>   	}
>> -	isb();
>> -	start = read_sysreg(cntpct_el0);
>> -	while (ntimes < test->times) {
>> +
>> +	while (ntimes < test->times && total_ns.ns < MAX_NS) {
>> +		isb();
>> +		start = read_sysreg(cntpct_el0);
>>   		test->exec();
>> +		isb();
>> +		end = read_sysreg(cntpct_el0);
>> +
>>   		ntimes++;
>> +		total_ticks += (end - start);
>> +		ticks_to_ns_time(total_ticks, &total_ns);
>>   	}
> you don't need the
> ticks_to_ns_time(total_ticks, &total_ns);
> 
> after the loop

Okay, I forgot to delete it here. Thanks for reviewing.

>> -	isb();
>> -	end = read_sysreg(cntpct_el0);
>>   
>> -	total_ticks = end - start;
>>   	ticks_to_ns_time(total_ticks, &total_ns);
>>   	avg_ns.ns = total_ns.ns / ntimes;
>>   	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
>>
> 
> Besides
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> 
> Thanks
> 
> Eric
> 
> 
> .
> 

Thanks,
Jingyi

