Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79734135EC4
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 17:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732133AbgAIQyN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 11:54:13 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24430 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727738AbgAIQyN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jan 2020 11:54:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578588851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9kKHMcsYX/2pX7iLpzc+Kf3IMCkj1tCMKoecB+pyXhI=;
        b=RXLXp//EO5h+lSuGa92NpeBcW2wtksXCkOQvaA6PrurTFg/TQpA84+5l5ZJRRp5t+J0B0s
        3lBjhWurBlNKcVoQo/Cu2fz5CFLBETTwJCQsJaW/fJhMG+XJphBWVffJVmUi73/9xc5Fhf
        ECuS3dd52RJ7uc+AzxPkWG7oXnzgEZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-312-bBW5FKprOTO-ocWw6H6t7A-1; Thu, 09 Jan 2020 11:54:08 -0500
X-MC-Unique: bBW5FKprOTO-ocWw6H6t7A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C7192100F191;
        Thu,  9 Jan 2020 16:54:06 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB4E686CBD;
        Thu,  9 Jan 2020 16:54:03 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 04/10] arm: pmu: Check Required Event
 Support
To:     Andre Przywara <andre.przywara@arm.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andrew.murray@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com
References: <20191216204757.4020-1-eric.auger@redhat.com>
 <20191216204757.4020-5-eric.auger@redhat.com>
 <20200103181251.72cfcae2@donnerap.cambridge.arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <ce0ce49f-7e19-21d4-5eba-386dd2f96301@redhat.com>
Date:   Thu, 9 Jan 2020 17:54:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20200103181251.72cfcae2@donnerap.cambridge.arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 1/3/20 7:12 PM, Andre Przywara wrote:
> On Mon, 16 Dec 2019 21:47:51 +0100
> Eric Auger <eric.auger@redhat.com> wrote:
> 
> Hi Eric,
> 
>> If event counters are implemented check the common events
>> required by the PMUv3 are implemented.
>>
>> Some are unconditionally required (SW_INCR, CPU_CYCLES,
>> either INST_RETIRED or INST_SPEC). Some others only are
>> required if the implementation implements some other features.
>>
>> Check those wich are unconditionally required.
>>
>> This test currently fails on TCG as neither INST_RETIRED
>> or INST_SPEC are supported.
>>
>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>
>> ---
>>
>> v1 ->v2:
>> - add a comment to explain the PMCEID0/1 splits
>> ---
>>  arm/pmu.c         | 71 +++++++++++++++++++++++++++++++++++++++++++++++
>>  arm/unittests.cfg |  6 ++++
>>  2 files changed, 77 insertions(+)
>>
>> diff --git a/arm/pmu.c b/arm/pmu.c
>> index d24857e..d88ef22 100644
>> --- a/arm/pmu.c
>> +++ b/arm/pmu.c
>> @@ -101,6 +101,10 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>>  	: [pmcr] "r" (pmcr), [z] "r" (0)
>>  	: "cc");
>>  }
>> +
>> +/* event counter tests only implemented for aarch64 */
>> +static void test_event_introspection(void) {}
>> +
>>  #elif defined(__aarch64__)
>>  #define ID_AA64DFR0_PERFMON_SHIFT 8
>>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>> @@ -139,6 +143,70 @@ static inline void precise_instrs_loop(int loop, uint32_t pmcr)
>>  	: [pmcr] "r" (pmcr)
>>  	: "cc");
>>  }
>> +
>> +#define PMCEID1_EL0 sys_reg(11, 3, 9, 12, 7)
>> +
>> +static bool is_event_supported(uint32_t n, bool warn)
>> +{
>> +	uint64_t pmceid0 = read_sysreg(pmceid0_el0);
>> +	uint64_t pmceid1 = read_sysreg_s(PMCEID1_EL0);
>> +	bool supported;
>> +	uint32_t reg;
>> +
>> +	/*
>> +	 * The low 32-bits of PMCEID0/1 respectly describe
>> +	 * event support for events 0-31/32-63. Their High
>> +	 * 32-bits describe support for extended events
>> +	 * starting at 0x4000, using the same split.
>> +	 */
>> +	if (n >= 0x0  && n <= 0x1F)
>> +		reg = pmceid0 & 0xFFFFFFFF;
>> +	else if  (n >= 0x4000 && n <= 0x401F)
>> +		reg = pmceid0 >> 32;
>> +	else if (n >= 0x20  && n <= 0x3F)
>> +		reg = pmceid1 & 0xFFFFFFFF;
>> +	else if (n >= 0x4020 && n <= 0x403F)
>> +		reg = pmceid1 >> 32;
>> +	else
>> +		abort();
>> +
>> +	supported =  reg & (1 << n);
> 
> Don't we need to mask off everything but the lowest 5 bits of "n"? Probably also using "1U" is better.
I added an assert to check n is less or equal than 0x3F
> 
>> +	if (!supported && warn)
>> +		report_info("event %d is not supported", n);
>> +	return supported;
>> +}
>> +
>> +static void test_event_introspection(void)
> 
> "introspection" sounds quite sophisticated. Are you planning to extend this? If not, could we maybe rename it to "test_available_events"?
Yes this test is a placeholder for looking at the PMU characteristics
and we may add some other queries there.
> 
>> +{
>> +	bool required_events;
>> +
>> +	if (!pmu.nb_implemented_counters) {
>> +		report_skip("No event counter, skip ...");
>> +		return;
>> +	}
>> +
>> +	/* PMUv3 requires an implementation includes some common events */
>> +	required_events = is_event_supported(0x0, true) /* SW_INCR */ &&
>> +			  is_event_supported(0x11, true) /* CPU_CYCLES */ &&
>> +			  (is_event_supported(0x8, true) /* INST_RETIRED */ ||
>> +			   is_event_supported(0x1B, true) /* INST_PREC */);
>> +
>> +	if (pmu.version == 0x4) {
>> +		/* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
>> +		required_events = required_events ||
>> +				  is_event_supported(0x23, true) ||
> 
> Shouldn't those two operators be '&&' instead?
yes definitively
> 
>> +				  is_event_supported(0x24, true);
>> +	}
>> +
>> +	/*
>> +	 * L1D_CACHE_REFILL(0x3) and L1D_CACHE(0x4) are only required if
>> +	 * L1 data / unified cache. BR_MIS_PRED(0x10), BR_PRED(0x12) are only
>> +	 * required if program-flow prediction is implemented.
>> +	 */
> 
> Is this a TODO?
yes. Added TODO. I do not know how to check whether the conditions are
satisfied? Do you have any idea?

Thank you for the review!

Eric
> 
> Cheers,
> Andre
> 
> 
>> +
>> +	report(required_events, "Check required events are implemented");
>> +}
>> +
>>  #endif
>>  
>>  /*
>> @@ -326,6 +394,9 @@ int main(int argc, char *argv[])
>>  		       "Monotonically increasing cycle count");
>>  		report(check_cpi(cpi), "Cycle/instruction ratio");
>>  		pmccntr64_test();
>> +	} else if (strcmp(argv[1], "event-introspection") == 0) {
>> +		report_prefix_push(argv[1]);
>> +		test_event_introspection();
>>  	} else {
>>  		report_abort("Unknown sub-test '%s'", argv[1]);
>>  	}
>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>> index 79f0d7a..4433ef3 100644
>> --- a/arm/unittests.cfg
>> +++ b/arm/unittests.cfg
>> @@ -66,6 +66,12 @@ file = pmu.flat
>>  groups = pmu
>>  extra_params = -append 'cycle-counter 0'
>>  
>> +[pmu-event-introspection]
>> +file = pmu.flat
>> +groups = pmu
>> +arch = arm64
>> +extra_params = -append 'event-introspection'
>> +
>>  # Test PMU support (TCG) with -icount IPC=1
>>  #[pmu-tcg-icount-1]
>>  #file = pmu.flat
> 

