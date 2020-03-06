Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8840017BF42
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 14:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbgCFNkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 08:40:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55364 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726090AbgCFNkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 08:40:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583502018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MTN85EDGHhLSRrRisKA51huPDatllgHXkn8nG5dIrk8=;
        b=fxY5si8/vhUyRWgppwzv6RNckRpc5BnTm8NXyjAZKnCNCUuLmRf2lc48ecP7Jkyfbp1mLD
        qfp73Y8DiP8ZdHl7SSzCdS7btNUFXYZRNUxcMhfPOpWAUSAYuL0LYbiZuAnk7cum+tcCNW
        Ng1nVutsJrqhSeTjhENxsIaPsuxaVHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-fdIQDuJVMWCtoADx9jmuyA-1; Fri, 06 Mar 2020 08:40:15 -0500
X-MC-Unique: fdIQDuJVMWCtoADx9jmuyA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21CB4107ACC7;
        Fri,  6 Mar 2020 13:40:13 +0000 (UTC)
Received: from [10.36.116.59] (ovpn-116-59.ams2.redhat.com [10.36.116.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6D7635C545;
        Fri,  6 Mar 2020 13:40:08 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH v3 11/14] arm/arm64: ITS: INT functional
 tests
To:     Andrew Jones <drjones@redhat.com>
Cc:     peter.maydell@linaro.org, thuth@redhat.com, kvm@vger.kernel.org,
        maz@kernel.org, qemu-devel@nongnu.org, qemu-arm@nongnu.org,
        andre.przywara@arm.com, yuzenghui@huawei.com,
        alexandru.elisei@arm.com, kvmarm@lists.cs.columbia.edu,
        eric.auger.pro@gmail.com
References: <20200128103459.19413-1-eric.auger@redhat.com>
 <20200128103459.19413-12-eric.auger@redhat.com>
 <20200207131547.rlj44nwu32xa4tyd@kamzik.brq.redhat.com>
 <5f5b7136-61e5-6464-f359-5925ceaa49a2@redhat.com>
 <20200306132957.ztjlr2g2ngqigfwq@kamzik.brq.redhat.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <9ba9979c-3d0e-c416-f616-ab0a154ab236@redhat.com>
Date:   Fri, 6 Mar 2020 14:40:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200306132957.ztjlr2g2ngqigfwq@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 3/6/20 2:29 PM, Andrew Jones wrote:
> On Fri, Mar 06, 2020 at 01:55:09PM +0100, Auger Eric wrote:
>> Hi Drew,
>>
>> On 2/7/20 2:15 PM, Andrew Jones wrote:
>>> On Tue, Jan 28, 2020 at 11:34:56AM +0100, Eric Auger wrote:
>>>> Triggers LPIs through the INT command.
>>>>
>>>> the test checks the LPI hits the right CPU and triggers
>>>> the right LPI intid, ie. the translation is correct.
>>>>
>>>> Updates to the config table also are tested, along with inv
>>>> and invall commands.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>>
>>>> v2 -> v3:
>>>> - add comments
>>>> - keep the report_skip in case there aren't 4 vcpus to be able to
>>>>   run other tests in the its category.
>>>> - fix the prefix pop
>>>> - move its_event and its_stats to arm/gic.c
>>>> ---
>>>>  arm/gic.c         | 228 +++++++++++++++++++++++++++++++++++++++++++---
>>>>  arm/unittests.cfg |   7 ++
>>>>  2 files changed, 224 insertions(+), 11 deletions(-)
>>>>
>>>> diff --git a/arm/gic.c b/arm/gic.c
>>>> index 4d7dd03..50104b1 100644
>>>> --- a/arm/gic.c
>>>> +++ b/arm/gic.c
>>>> @@ -160,6 +160,87 @@ static void ipi_handler(struct pt_regs *regs __unused)
>>>>  	}
>>>>  }
>>>>  
>>>> +static void setup_irq(handler_t handler)
>>>> +{
>>>> +	gic_enable_defaults();
>>>> +#ifdef __arm__
>>>> +	install_exception_handler(EXCPTN_IRQ, handler);
>>>> +#else
>>>> +	install_irq_handler(EL1H_IRQ, handler);
>>>> +#endif
>>>> +	local_irq_enable();
>>>> +}
>>>> +
>>>> +#if defined(__aarch64__)
>>>> +struct its_event {
>>>> +	int cpu_id;
>>>> +	int lpi_id;
>>>> +};
>>>> +
>>>> +struct its_stats {
>>>> +	struct its_event expected;
>>>> +	struct its_event observed;
>>>> +};
>>>> +
>>>> +static struct its_stats lpi_stats;
>>>> +
>>>> +static void lpi_handler(struct pt_regs *regs __unused)
>>>> +{
>>>> +	u32 irqstat = gic_read_iar();
>>>> +	int irqnr = gic_iar_irqnr(irqstat);
>>>> +
>>>> +	gic_write_eoir(irqstat);
>>>> +	if (irqnr < 8192)
>>>> +		report(false, "Unexpected non LPI interrupt received");
>>>
>>> report_info
>> why? This is an error case. We do not expect other interrupts than LPIs
> 
> If there's almost no chance this will happen and it means something quite
> unexpected has occurred, then it should probably be an assert. If this is
> a real test case, then it should be
> 
>  report(irqnr >= 8192, "Got LPI");
> 
> or something like that. If it's something that shouldn't ever happen, so
> it doesn't really deserve its own PASS/FAIL test output each execution
> of the unit test, but you don't want to assert for some reason, then it
> should be a report_info, but it should probably also contain a "WARNING"
> prefix in that case.
OK so the assert should be OK.
> 
>>>
>>>> +	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
>>>> +	lpi_stats.observed.cpu_id = smp_processor_id();
>>>> +	lpi_stats.observed.lpi_id = irqnr;
>>>> +	smp_wmb(); /* pairs with rmb in check_lpi_stats */
>>>> +}
>>>> +
>>>> +static void lpi_stats_expect(int exp_cpu_id, int exp_lpi_id)
>>>> +{
>>>> +	lpi_stats.expected.cpu_id = exp_cpu_id;
>>>> +	lpi_stats.expected.lpi_id = exp_lpi_id;
>>>> +	lpi_stats.observed.cpu_id = -1;
>>>> +	lpi_stats.observed.lpi_id = -1;
>>>> +	smp_wmb(); /* pairs with rmb in handler */
>>>> +}
>>>> +
>>>> +static void check_lpi_stats(void)
>>>
>>> static void check_lpi_stats(const char *testname)
>>> {
>>>    bool pass = false;
>>>
>>>> +{
>>>> +	mdelay(100);
>>>> +	smp_rmb(); /* pairs with wmb in lpi_handler */
>>>> +	if ((lpi_stats.observed.cpu_id != lpi_stats.expected.cpu_id) ||
>>>> +	    (lpi_stats.observed.lpi_id != lpi_stats.expected.lpi_id)) {
>>>
>>> nit: extra ()
>>>
>>>> +		if (lpi_stats.observed.cpu_id == -1 &&
>>>> +		    lpi_stats.observed.lpi_id == -1) {
>>>> +			report(false,
>>>> +			       "No LPI received whereas (cpuid=%d, intid=%d) "
>>>> +			       "was expected", lpi_stats.expected.cpu_id,
>>>> +			       lpi_stats.expected.lpi_id);
>>>
>>> report_info
>> What's the problem keeping those. Those are error reports. The message
>> is something like that:
>> FAIL: gicv3: its-trigger: mapc valid=false: No LPI received whereas
>> (cpuid=1, intid=8192) was expected.
>>
>> So the testname is already part of the message.
> 
> This one has two problems with being report() vs. report_info. The same
> comment as above, where the condition for a report() should be the test,
> rather than if (cond) report(false, ...), which implies it's not expected
> to report at all. A pattern like that needs to be extended at least to
> something like this
> 
> if (cond)
>   report(true, ...)
> else
>   report(false, ...)
OK understood. I should have use the test as the 1st param.
> 
> so we get the PASS/FAIL each execution. The other problem with this
> particular report() is the dynamic info in it (cpuid and maybe intid).
> A report() should only have consistent info so test output parsers
> can count on finding the PASS/FAIL for a given report line. If you
> need a test like this, then it can be structured like
> 
> report_info(...); // dynamic info
> if (cond) {
>    report(true, MSG1); // no dynamic info
>    report(true, MSG2); // no dynamic info
> } else {
>    report(false, MSG1); // no dynamic info
>    report(false, MSG2); // no dynamic info
> }
> 
> Notice how the MSG's match on both paths of the condition.
> 
> Or just 
> 
> report_info(...);
> report(cond, ...);
OK I see what you mean now. I will rewrite it accordingly.

Thank you for the extra explanation

Eric
> 
>>>
>>>> +		} else {
>>>> +			report(false, "Unexpected LPI (cpuid=%d, intid=%d)",
>>>> +			       lpi_stats.observed.cpu_id,
>>>> +			       lpi_stats.observed.lpi_id);
>>>
>>> report_info
>>>
>>>> +		}
>>>
>>> pass = false;
>>>
>>>> +	} else if (lpi_stats.expected.lpi_id != -1) {
>>>> +		report(true, "LPI %d on CPU %d", lpi_stats.observed.lpi_id,
>>>> +		       lpi_stats.observed.cpu_id);
>>>
>>> report_info
>>>
>>>> +	} else {
>>>> +		report(true, "no LPI received, as expected");
>>>
>>> report_info
> 
> This if, else if, ..., else with report() would be fine if the messages
> would all match, resulting in a single 'PASS: MSG' line. report_info can
> be used to get the dynamic info output too.
> 
>>>
>>>
>>>> +	}
>>>
>>> report(pass, "%s", testname);
>>>
>>>> +}
>>>> +
>>>> +static void secondary_lpi_test(void)
>>>> +{
>>>> +	setup_irq(lpi_handler);
>>>> +	cpumask_set_cpu(smp_processor_id(), &ready);
>>>> +	while (1)
>>>> +		wfi();
>>>> +}
>>>> +#endif
>>>> +
>>>>  static void gicv2_ipi_send_self(void)
>>>>  {
>>>>  	writel(2 << 24 | IPI_IRQ, gicv2_dist_base() + GICD_SGIR);
>>>> @@ -217,17 +298,6 @@ static void ipi_test_smp(void)
>>>>  	report_prefix_pop();
>>>>  }
>>>>  
>>>> -static void setup_irq(handler_t handler)
>>>> -{
>>>> -	gic_enable_defaults();
>>>> -#ifdef __arm__
>>>> -	install_exception_handler(EXCPTN_IRQ, handler);
>>>> -#else
>>>> -	install_irq_handler(EL1H_IRQ, handler);
>>>> -#endif
>>>> -	local_irq_enable();
>>>> -}
>>>> -
>>>>  static void ipi_send(void)
>>>>  {
>>>>  	setup_irq(ipi_handler);
>>>> @@ -522,6 +592,7 @@ static void gic_test_mmio(void)
>>>>  #if defined(__arm__)
>>>>  
>>>>  static void test_its_introspection(void) {}
>>>> +static void test_its_trigger(void) {}
>>>>  
>>>>  #else /* __arch64__ */
>>>>  
>>>> @@ -561,6 +632,137 @@ static void test_its_introspection(void)
>>>>  	report_info("collection baser entry_size = 0x%x", coll_baser->esz);
>>>>  }
>>>>  
>>>> +static bool its_prerequisites(int nb_cpus)
>>>> +{
>>>> +	int cpu;
>>>> +
>>>> +	if (!gicv3_its_base()) {
>>>> +		report_skip("No ITS, skip ...");
>>>> +		return true;
>>>> +	}
>>>> +
>>>> +	if (nr_cpus < 4) {
>>>
>>> nr_cpus < nb_cpus, or just drop the nb_cpus parameter and hard code 4
>>> here.
>> sure
>>>
>>>> +		report_skip("Test requires at least %d vcpus", nb_cpus);
>>>> +		return true;
>>>> +	}
>>>> +
>>>> +	stats_reset();
>>>> +
>>>> +	setup_irq(lpi_handler);
>>>> +
>>>> +	for_each_present_cpu(cpu) {
>>>> +		if (cpu == 0)
>>>> +			continue;
>>>> +		smp_boot_secondary(cpu, secondary_lpi_test);
>>>> +	}
>>>> +	wait_on_ready();
>>>> +
>>>> +	its_enable_defaults();
>>>> +
>>>> +	lpi_stats_expect(-1, -1);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	return false;
>>>
>>> Reverse logic. I'd expect 'return true' for success.
>> I am going to return an int. In case of error a std negative error will
>> be returned.
>>>
>>>> +}
>>>> +
>>>> +static void test_its_trigger(void)
>>>> +{
>>>> +	struct its_collection *col3, *col2;
>>>> +	struct its_device *dev2, *dev7;
>>>> +
>>>> +	if (its_prerequisites(4))
>>>
>>> if (!its_prerequisites(...))
>>>
>>>> +		return;
>>>> +
>>>> +	dev2 = its_create_device(2 /* dev id */, 8 /* nb_ites */);
>>>> +	dev7 = its_create_device(7 /* dev id */, 8 /* nb_ites */);
>>>> +
>>>> +	col3 = its_create_collection(3 /* col id */, 3/* target PE */);
>>>> +	col2 = its_create_collection(2 /* col id */, 2/* target PE */);
>>>> +
>>>> +	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>>>> +	gicv3_lpi_set_config(8196, LPI_PROP_DEFAULT);
>>>> +
>>>> +	its_send_invall(col2);
>>>> +	its_send_invall(col3);
>>>> +
>>>> +	report_prefix_push("int");
>>>> +	/*
>>>> +	 * dev=2, eventid=20  -> lpi= 8195, col=3
>>>> +	 * dev=7, eventid=255 -> lpi= 8196, col=2
>>>> +	 * Trigger dev2, eventid=20 and dev7, eventid=255
>>>> +	 * Check both LPIs hit
>>>> +	 */
>>>> +
>>>> +	its_send_mapd(dev2, true);
>>>> +	its_send_mapd(dev7, true);
>>>> +
>>>> +	its_send_mapc(col3, true);
>>>> +	its_send_mapc(col2, true);
>>>> +
>>>> +	its_send_mapti(dev2, 8195 /* lpi id */,
>>>> +		       20 /* event id */, col3);
>>>> +	its_send_mapti(dev7, 8196 /* lpi id */,
>>>> +		       255 /* event id */, col2);
>>>
>>> No need for line breaks, with the embedded comments it's hard to read
>> OK
>>>
>>>> +
>>>> +	lpi_stats_expect(3, 8195);
>>>> +	its_send_int(dev2, 20);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	lpi_stats_expect(2, 8196);
>>>> +	its_send_int(dev7, 255);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	report_prefix_pop();
>>>
>>> I think a table of parameters and loop would be nicer than all the
>>> repeated function calls.
>> Frankly speaking I am not sure this would really help. We are just
>> enabling 2 translation paths. I think I prefer to manipulate the low
>> level objects and helpers rather than playing with a loop and potential
>> new structs of params.
> 
> OK, but you could probably at least wrap the common sequence into one
> function
> 
> void master_function(a1, a2, a3, a4)
> {
>   lpi_stats_expect(a1, a2);
>   its_send_int(a3, a4);
>   check_lpi_stats();
> }
> 
> but whatever, it's not so important.
> 
>>>
>>>> +
>>>> +	report_prefix_push("inv/invall");
>>>> +
>>>> +	/*
>>>> +	 * disable 8195, check dev2/eventid=20 does not trigger the
>>>> +	 * corresponding LPI
>>>> +	 */
>>>> +	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT & ~0x1);
>>>
>>> LPI_PROP_DEFAULT & ~LPI_PROP_ENABLED
>> ok
>>>
>>>> +	its_send_inv(dev2, 20);
>>>> +
>>>> +	lpi_stats_expect(-1, -1);
>>>> +	its_send_int(dev2, 20);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	/*
>>>> +	 * re-enable the LPI but willingly do not call invall
>>>> +	 * so the change in config is not taken into account.
>>>> +	 * The LPI should not hit
>>>> +	 */
>>>> +	gicv3_lpi_set_config(8195, LPI_PROP_DEFAULT);
>>>> +	lpi_stats_expect(-1, -1);
>>>> +	its_send_int(dev2, 20);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	/* Now call the invall and check the LPI hits */
>>>> +	its_send_invall(col3);
>>>> +	lpi_stats_expect(3, 8195);
>>>> +	its_send_int(dev2, 20);
>>>> +	check_lpi_stats();
>>>> +
>>>> +	report_prefix_pop();
>>>
>>> Need blank line here.
>> OK
>>>
>>>> +	/*
>>>> +	 * Unmap device 2 and check the eventid 20 formerly
>>>> +	 * attached to it does not hit anymore
>>>> +	 */
>>>> +	report_prefix_push("mapd valid=false");
>>>
>>> Above you have the prefix-push before the comment explaining the test.
>>> After is probably better, but whatever, as long as it's consistent.
>> moved after
>>>
>>>> +	its_send_mapd(dev2, false);
>>>> +	lpi_stats_expect(-1, -1);
>>>> +	its_send_int(dev2, 20);
>>>> +	check_lpi_stats();
>>>> +	report_prefix_pop();
>>>> +
>>>> +	/* Unmap the collection this time and check no LPI does hit */
>>>> +	report_prefix_push("mapc valid=false");
>>>> +	its_send_mapc(col2, false);
>>>> +	lpi_stats_expect(-1, -1);
>>>> +	its_send_int(dev7, 255);
>>>> +	check_lpi_stats();
>>>> +	report_prefix_pop();
>>>> +}
>>>>  #endif
>>>>  
>>>>  int main(int argc, char **argv)
>>>> @@ -594,6 +796,10 @@ int main(int argc, char **argv)
>>>>  		report_prefix_push(argv[1]);
>>>>  		gic_test_mmio();
>>>>  		report_prefix_pop();
>>>> +	} else if (!strcmp(argv[1], "its-trigger")) {
>>>> +		report_prefix_push(argv[1]);
>>>> +		test_its_trigger();
>>>> +		report_prefix_pop();
>>>>  	} else if (strcmp(argv[1], "its-introspection") == 0) {
>>>>  		report_prefix_push(argv[1]);
>>>>  		test_its_introspection();
>>>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>>>> index ba2b31b..bfafec5 100644
>>>> --- a/arm/unittests.cfg
>>>> +++ b/arm/unittests.cfg
>>>> @@ -129,6 +129,13 @@ extra_params = -machine gic-version=3 -append 'its-introspection'
>>>>  groups = its
>>>>  arch = arm64
>>>>  
>>>> +[its-trigger]
>>>> +file = gic.flat
>>>> +smp = $MAX_SMP
>>>> +extra_params = -machine gic-version=3 -append 'its-trigger'
>>>> +groups = its
>>>> +arch = arm64
>>>> +
>>>>  # Test PSCI emulation
>>>>  [psci]
>>>>  file = psci.flat
>>>> -- 
>>>> 2.20.1
>>>>
>>>
>>> Thanks,
>>> drew 
>>>
>> Thanks
>>
>> Eric
>>
>>
> 

