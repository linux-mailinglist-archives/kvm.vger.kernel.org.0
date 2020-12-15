Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1EA2DAE70
	for <lists+kvm@lfdr.de>; Tue, 15 Dec 2020 15:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728889AbgLOOAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Dec 2020 09:00:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34241 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728359AbgLON7k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Dec 2020 08:59:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608040693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y5H2NuQC/MSdaMvMfhoeO2uJ50SNRXmY0D41iGHmGoc=;
        b=ENp8sQXH6VS9u4aTyxMn9Js5b18k8pMC3RW4UYIcfWKI50ERRSF9tSH6txLNDi89YovOHg
        VkG8wBoenoyFINsEyyEFXu254UHpzu7bvDQ3sE/WNTrKoXH6r7h59p/TTf2uIy+/nN3nsL
        d2RWKg/SkyTOnH6+inQyl5yzW3VS6Jw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-516-usT7VE3kPB6E6pI2L1fGaQ-1; Tue, 15 Dec 2020 08:58:12 -0500
X-MC-Unique: usT7VE3kPB6E6pI2L1fGaQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AE79259;
        Tue, 15 Dec 2020 13:58:10 +0000 (UTC)
Received: from [10.36.115.92] (ovpn-115-92.ams2.redhat.com [10.36.115.92])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02EC560873;
        Tue, 15 Dec 2020 13:58:05 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 08/10] arm/arm64: gic: Split check_acked()
 into two functions
To:     Alexandru Elisei <alexandru.elisei@arm.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc:     andre.przywara@arm.com
References: <20201125155113.192079-1-alexandru.elisei@arm.com>
 <20201125155113.192079-9-alexandru.elisei@arm.com>
 <0eb98cb0-835c-e257-484e-8210f1279f2c@redhat.com>
 <2b8d774e-9398-e24b-6989-8643f5dd2492@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <b5ccedb2-5f8d-50d5-8caf-776013613d90@redhat.com>
Date:   Tue, 15 Dec 2020 14:58:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <2b8d774e-9398-e24b-6989-8643f5dd2492@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 12/10/20 3:45 PM, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 12/3/20 1:39 PM, Auger Eric wrote:
>>
>> On 11/25/20 4:51 PM, Alexandru Elisei wrote:
>>> check_acked() has several peculiarities: is the only function among the
>>> check_* functions which calls report() directly, it does two things
>>> (waits for interrupts and checks for misfired interrupts) and it also
>>> mixes printf, report_info and report calls.
>>>
>>> check_acked() also reports a pass and returns as soon all the target CPUs
>>> have received interrupts, However, a CPU not having received an interrupt
>>> *now* does not guarantee not receiving an eroneous interrupt if we wait
>> erroneous
>>> long enough.
>>>
>>> Rework the function by splitting it into two separate functions, each with
>>> a single responsability: wait_for_interrupts(), which waits for the
>>> expected interrupts to fire, and check_acked() which checks that interrupts
>>> have been received as expected.
>>>
>>> wait_for_interrupts() also waits an extra 100 milliseconds after the
>>> expected interrupts have been received in an effort to make sure we don't
>>> miss misfiring interrupts.
>>>
>>> Splitting check_acked() into two functions will also allow us to
>>> customize the behavior of each function in the future more easily
>>> without using an unnecessarily long list of arguments for check_acked().
>>>
>>> CC: Andre Przywara <andre.przywara@arm.com>
>>> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
>>> ---
>>>  arm/gic.c | 73 +++++++++++++++++++++++++++++++++++--------------------
>>>  1 file changed, 47 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/arm/gic.c b/arm/gic.c
>>> index 544c283f5f47..dcdab7d5f39a 100644
>>> --- a/arm/gic.c
>>> +++ b/arm/gic.c
>>> @@ -62,41 +62,42 @@ static void stats_reset(void)
>>>  	}
>>>  }
>>>  
>>> -static void check_acked(const char *testname, cpumask_t *mask)
>>> +static void wait_for_interrupts(cpumask_t *mask)
>>>  {
>>> -	int missing = 0, extra = 0, unexpected = 0;
>>>  	int nr_pass, cpu, i;
>>> -	bool bad = false;
>>>  
>>>  	/* Wait up to 5s for all interrupts to be delivered */
>>> -	for (i = 0; i < 50; ++i) {
>>> +	for (i = 0; i < 50; i++) {
>>>  		mdelay(100);
>>>  		nr_pass = 0;
>>>  		for_each_present_cpu(cpu) {
>>> +			/*
>>> +			 * A CPU having receied more than one interrupts will
>> received
>>> +			 * show up in check_acked(), and no matter how long we
>>> +			 * wait it cannot un-receive it. Consier at least one
>> consider
> 
> Will fix all three typos, thanks.
> 
>>> +			 * interrupt as a pass.
>>> +			 */
>>>  			nr_pass += cpumask_test_cpu(cpu, mask) ?
>>> -				acked[cpu] == 1 : acked[cpu] == 0;
>>> -			smp_rmb(); /* pairs with smp_wmb in ipi_handler */
>>> -
>>> -			if (bad_sender[cpu] != -1) {
>>> -				printf("cpu%d received IPI from wrong sender %d\n",
>>> -					cpu, bad_sender[cpu]);
>>> -				bad = true;
>>> -			}
>>> -
>>> -			if (bad_irq[cpu] != -1) {
>>> -				printf("cpu%d received wrong irq %d\n",
>>> -					cpu, bad_irq[cpu]);
>>> -				bad = true;
>>> -			}
>>> +				acked[cpu] >= 1 : acked[cpu] == 0;
>>>  		}
>>> +
>>>  		if (nr_pass == nr_cpus) {
>>> -			report(!bad, "%s", testname);
>>>  			if (i)
>>> -				report_info("took more than %d ms", i * 100);
>>> +				report_info("interrupts took more than %d ms", i * 100);
>>> +			mdelay(100);
>>>  			return;
>>>  		}
>>>  	}
>>>  
>>> +	report_info("interrupts timed-out (5s)");
>>> +}
>>> +
>>> +static bool check_acked(cpumask_t *mask)
>>> +{
>>> +	int missing = 0, extra = 0, unexpected = 0;
>>> +	bool pass = true;
>>> +	int cpu;
>>> +
>>>  	for_each_present_cpu(cpu) {
>>>  		if (cpumask_test_cpu(cpu, mask)) {
>>>  			if (!acked[cpu])
>>> @@ -107,11 +108,28 @@ static void check_acked(const char *testname, cpumask_t *mask)
>>>  			if (acked[cpu])
>>>  				++unexpected;
>>>  		}
>>> +		smp_rmb(); /* pairs with smp_wmb in ipi_handler */
>>> +
>>> +		if (bad_sender[cpu] != -1) {
>>> +			report_info("cpu%d received IPI from wrong sender %d",
>>> +					cpu, bad_sender[cpu]);
>>> +			pass = false;
>>> +		}
>>> +
>>> +		if (bad_irq[cpu] != -1) {
>>> +			report_info("cpu%d received wrong irq %d",
>>> +					cpu, bad_irq[cpu]);
>>> +			pass = false;
>>> +		}
>>> +	}
>>> +
>>> +	if (missing || extra || unexpected) {
>>> +		report_info("ACKS: missing=%d extra=%d unexpected=%d",
>>> +				missing, extra, unexpected);
>>> +		pass = false;
>>>  	}
>>>  
>>> -	report(false, "%s", testname);
>>> -	report_info("Timed-out (5s). ACKS: missing=%d extra=%d unexpected=%d",
>>> -		    missing, extra, unexpected);
>>> +	return pass;
>>>  }
>>>  
>>>  static void check_spurious(void)
>>> @@ -300,7 +318,8 @@ static void ipi_test_self(void)
>>>  	cpumask_clear(&mask);
>>>  	cpumask_set_cpu(smp_processor_id(), &mask);
>>>  	gic->ipi.send_self();
>>> -	check_acked("IPI: self", &mask);
>>> +	wait_for_interrupts(&mask);
>>> +	report(check_acked(&mask), "Interrupts received");
>>>  	report_prefix_pop();
>>>  }
>>>  
>>> @@ -315,7 +334,8 @@ static void ipi_test_smp(void)
>>>  	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
>>>  		cpumask_clear_cpu(i, &mask);
>>>  	gic_ipi_send_mask(IPI_IRQ, &mask);
>>> -	check_acked("IPI: directed", &mask);
>>> +	wait_for_interrupts(&mask);
>>> +	report(check_acked(&mask), "Interrupts received");
>> both ipi_test_smp and ipi_test_self are called from the same test so
>> better to use different error messages like it was done originally.
> 
> I used the same error message because the tests have a different prefix
> ("target-list" versus "broadcast"). Do you think there are cases where that's not
> enough?
I think in "ipi" test,
ipi_test -> ipi_send -> ipi_test_self, ipi_test_smp

Thanks

Eric
> 
> Thanks,
> Alex
> 

