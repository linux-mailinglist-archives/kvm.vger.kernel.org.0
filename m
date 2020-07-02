Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36ABB211F48
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 10:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727819AbgGBI5I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 04:57:08 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6802 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgGBI5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 04:57:08 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9329F22751AFE755B360;
        Thu,  2 Jul 2020 16:57:03 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.487.0; Thu, 2 Jul 2020
 16:56:57 +0800
Subject: Re: [kvm-unit-tests PATCH v2 8/8] arm64: microbench: Add vtimer
 latency test
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-9-wangjingyi11@huawei.com>
 <20200702054456.bsy5njbcxu7fzwcs@kamzik.brq.redhat.com>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <5fe971f8-a0f5-d24c-39bc-c96c9c7c41dd@huawei.com>
Date:   Thu, 2 Jul 2020 16:56:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200702054456.bsy5njbcxu7fzwcs@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 7/2/2020 1:44 PM, Andrew Jones wrote:
> On Thu, Jul 02, 2020 at 11:01:32AM +0800, Jingyi Wang wrote:
>> Trigger PPIs by setting up a 10msec timer and test the latency.
>>
>> Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
>> ---
>>   arm/micro-bench.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++-
>>   1 file changed, 55 insertions(+), 1 deletion(-)
>>
>> diff --git a/arm/micro-bench.c b/arm/micro-bench.c
>> index 4c962b7..6822084 100644
>> --- a/arm/micro-bench.c
>> +++ b/arm/micro-bench.c
>> @@ -23,8 +23,13 @@
>>   #include <asm/gic-v3-its.h>
>>   
>>   #define NTIMES (1U << 16)
>> +#define NTIMES_MINOR (1U << 8)
> 
> As mentioned in the previous patch, no need for this define, just put the
> number in the table.
> 
>>   #define MAX_NS (5 * 1000 * 1000 * 1000UL)
>>   
>> +#define IRQ_VTIMER		27
> 
> As you can see in the timer test (arm/timer.c) we've been doing our best
> not to hard code stuff like this. I'd prefer we don't start now. Actually,
> since the timer irqs may come in handy for other tests I'll extract the
> DT stuff from arm/timer.c and save those irqs at setup time. I'll send
> a patch for that now, then this patch can use the new saved state.
> 
>> +#define ARCH_TIMER_CTL_ENABLE	(1 << 0)
>> +#define ARCH_TIMER_CTL_IMASK	(1 << 1)
> 
> I'll put these defines somewhere common as well.
> 

The common implement for timer irqs will be much helpful, I will
rebase this patch on that.

>> +
>>   static u32 cntfrq;
>>   
>>   static volatile bool irq_ready, irq_received;
>> @@ -33,9 +38,16 @@ static void (*write_eoir)(u32 irqstat);
>>   
>>   static void gic_irq_handler(struct pt_regs *regs)
>>   {
>> +	u32 irqstat = gic_read_iar();
>>   	irq_ready = false;
>>   	irq_received = true;
>> -	gic_write_eoir(gic_read_iar());
>> +	gic_write_eoir(irqstat);
>> +
>> +	if (irqstat == IRQ_VTIMER) {
>> +		write_sysreg((ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE),
>> +			     cntv_ctl_el0);
>> +		isb();
>> +	}
>>   	irq_ready = true;
>>   }
>>   
>> @@ -189,6 +201,47 @@ static void lpi_exec(void)
>>   	assert_msg(irq_received, "failed to receive LPI in time, but received %d successfully\n", received);
>>   }
>>   
>> +static bool timer_prep(void)
>> +{
>> +	static void *gic_isenabler;
>> +
>> +	gic_enable_defaults();
>> +	install_irq_handler(EL1H_IRQ, gic_irq_handler);
>> +	local_irq_enable();
>> +
>> +	gic_isenabler = gicv3_sgi_base() + GICR_ISENABLER0;
>> +	writel(1 << 27, gic_isenabler);
> 
> You should have used your define here.
> 

Done.

>> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>> +	isb();
>> +
>> +	gic_prep_common();
>> +	return true;
>> +}
>> +
>> +static void timer_exec(void)
>> +{
>> +	u64 before_timer;
>> +	u64 timer_10ms;
>> +	unsigned tries = 1 << 28;
>> +	static int received = 0;
>> +
>> +	irq_received = false;
>> +
>> +	before_timer = read_sysreg(cntvct_el0);
>> +	timer_10ms = cntfrq / 100;
>> +	write_sysreg(before_timer + timer_10ms, cntv_cval_el0);
>> +	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
>> +	isb();
>> +
>> +	while (!irq_received && tries--)
>> +		cpu_relax();
>> +
>> +	if (irq_received)
>> +		++received;
>> +
>> +	assert_msg(irq_received, "failed to receive PPI in time, but received %d successfully\n", received);
>> +}
>> +
>>   static void hvc_exec(void)
>>   {
>>   	asm volatile("mov w0, #0x4b000000; hvc #0" ::: "w0");
>> @@ -236,6 +289,7 @@ static struct exit_test tests[] = {
>>   	{"ipi",			ipi_prep,	ipi_exec,		NTIMES,		true},
>>   	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NTIMES,		true},
>>   	{"lpi",			lpi_prep,	lpi_exec,		NTIMES,		true},
>> +	{"timer_10ms",		timer_prep,	timer_exec,		NTIMES_MINOR,	true},
>>   };
>>   
>>   struct ns_time {
>> -- 
>> 2.19.1
>>
>>
> 
> Thanks,
> drew
> 
> 
> .
> 

Thanks,
Jingyi

