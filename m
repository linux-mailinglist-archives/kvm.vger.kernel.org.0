Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B36CB135F6D
	for <lists+kvm@lfdr.de>; Thu,  9 Jan 2020 18:37:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731731AbgAIRhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jan 2020 12:37:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48709 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728220AbgAIRhm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jan 2020 12:37:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578591459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+hd1spx0j5nExGhcsZntaXPkm5mIhaB1M+8iBPreXT8=;
        b=dHaKFgpKDLROGqoAhMr0cwQv3RsAqcc4qV08nPsb7rM/yt5AgR4hp70TIuiIVprGyHdZqj
        ZJjHC1lZIV7BYPWQug/aWRQsYIR1FrN/dhNFMgWMja6lQ2oDR4v5WyojUiNfoiXmu168Yv
        OUva8qSM3FRVh4O88WKtbB2wbfNWybs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-98-x2Z3y9lrNSyM08zcJ_75fg-1; Thu, 09 Jan 2020 12:37:38 -0500
X-MC-Unique: x2Z3y9lrNSyM08zcJ_75fg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E5B310054E3;
        Thu,  9 Jan 2020 17:37:36 +0000 (UTC)
Received: from [10.36.117.108] (ovpn-117-108.ams2.redhat.com [10.36.117.108])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C210F10013A7;
        Thu,  9 Jan 2020 17:37:33 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH 04/10] arm: pmu: Check Required Event
 Support
To:     =?UTF-8?Q?Andr=c3=a9_Przywara?= <andre.przywara@arm.com>
Cc:     eric.auger.pro@gmail.com, maz@kernel.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, qemu-arm@nongnu.org, drjones@redhat.com,
        andrew.murray@arm.com, peter.maydell@linaro.org,
        alexandru.elisei@arm.com
References: <20191216204757.4020-1-eric.auger@redhat.com>
 <20191216204757.4020-5-eric.auger@redhat.com>
 <20200103181251.72cfcae2@donnerap.cambridge.arm.com>
 <ce0ce49f-7e19-21d4-5eba-386dd2f96301@redhat.com>
 <380b27cb-a762-0622-af9c-1d2afc3a4b5e@arm.com>
From:   Auger Eric <eric.auger@redhat.com>
Message-ID: <c1831b6c-dc75-1bd3-6657-0375682c30af@redhat.com>
Date:   Thu, 9 Jan 2020 18:37:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <380b27cb-a762-0622-af9c-1d2afc3a4b5e@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Andre,

On 1/9/20 6:30 PM, Andr=E9 Przywara wrote:
> On 09/01/2020 16:54, Auger Eric wrote:
>=20
> Hi Eric,
>=20
>> On 1/3/20 7:12 PM, Andre Przywara wrote:
>>> On Mon, 16 Dec 2019 21:47:51 +0100
>>> Eric Auger <eric.auger@redhat.com> wrote:
>>>
>>> Hi Eric,
>>>
>>>> If event counters are implemented check the common events
>>>> required by the PMUv3 are implemented.
>>>>
>>>> Some are unconditionally required (SW_INCR, CPU_CYCLES,
>>>> either INST_RETIRED or INST_SPEC). Some others only are
>>>> required if the implementation implements some other features.
>>>>
>>>> Check those wich are unconditionally required.
>>>>
>>>> This test currently fails on TCG as neither INST_RETIRED
>>>> or INST_SPEC are supported.
>>>>
>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
>>>>
>>>> ---
>>>>
>>>> v1 ->v2:
>>>> - add a comment to explain the PMCEID0/1 splits
>>>> ---
>>>>  arm/pmu.c         | 71 ++++++++++++++++++++++++++++++++++++++++++++=
+++
>>>>  arm/unittests.cfg |  6 ++++
>>>>  2 files changed, 77 insertions(+)
>>>>
>>>> diff --git a/arm/pmu.c b/arm/pmu.c
>>>> index d24857e..d88ef22 100644
>>>> --- a/arm/pmu.c
>>>> +++ b/arm/pmu.c
>>>> @@ -101,6 +101,10 @@ static inline void precise_instrs_loop(int loop=
, uint32_t pmcr)
>>>>  	: [pmcr] "r" (pmcr), [z] "r" (0)
>>>>  	: "cc");
>>>>  }
>>>> +
>>>> +/* event counter tests only implemented for aarch64 */
>>>> +static void test_event_introspection(void) {}
>>>> +
>>>>  #elif defined(__aarch64__)
>>>>  #define ID_AA64DFR0_PERFMON_SHIFT 8
>>>>  #define ID_AA64DFR0_PERFMON_MASK  0xf
>>>> @@ -139,6 +143,70 @@ static inline void precise_instrs_loop(int loop=
, uint32_t pmcr)
>>>>  	: [pmcr] "r" (pmcr)
>>>>  	: "cc");
>>>>  }
>>>> +
>>>> +#define PMCEID1_EL0 sys_reg(11, 3, 9, 12, 7)
>>>> +
>>>> +static bool is_event_supported(uint32_t n, bool warn)
>>>> +{
>>>> +	uint64_t pmceid0 =3D read_sysreg(pmceid0_el0);
>>>> +	uint64_t pmceid1 =3D read_sysreg_s(PMCEID1_EL0);
>>>> +	bool supported;
>>>> +	uint32_t reg;
>>>> +
>>>> +	/*
>>>> +	 * The low 32-bits of PMCEID0/1 respectly describe
>>>> +	 * event support for events 0-31/32-63. Their High
>>>> +	 * 32-bits describe support for extended events
>>>> +	 * starting at 0x4000, using the same split.
>>>> +	 */
>>>> +	if (n >=3D 0x0  && n <=3D 0x1F)
>>>> +		reg =3D pmceid0 & 0xFFFFFFFF;
>>>> +	else if  (n >=3D 0x4000 && n <=3D 0x401F)
>>>> +		reg =3D pmceid0 >> 32;
>>>> +	else if (n >=3D 0x20  && n <=3D 0x3F)
>>>> +		reg =3D pmceid1 & 0xFFFFFFFF;
>>>> +	else if (n >=3D 0x4020 && n <=3D 0x403F)
>>>> +		reg =3D pmceid1 >> 32;
>>>> +	else
>>>> +		abort();
>>>> +
>>>> +	supported =3D  reg & (1 << n);
>>>
>>> Don't we need to mask off everything but the lowest 5 bits of "n"? Pr=
obably also using "1U" is better.
>> I added an assert to check n is less or equal than 0x3F
>=20
> But "n" will definitely be bigger than that in case of an extended
> event, won't it? So you adjust "reg" accordingly, but miss to do
> something similar to "n"?
ouch yes. Sorry. I Will do what you suggest. Nethertheless this would be
test code error.
>=20
>>>
>>>> +	if (!supported && warn)
>>>> +		report_info("event %d is not supported", n);
>>>> +	return supported;
>>>> +}
>>>> +
>>>> +static void test_event_introspection(void)
>>>
>>> "introspection" sounds quite sophisticated. Are you planning to exten=
d this? If not, could we maybe rename it to "test_available_events"?
>> Yes this test is a placeholder for looking at the PMU characteristics
>> and we may add some other queries there.
>>>
>>>> +{
>>>> +	bool required_events;
>>>> +
>>>> +	if (!pmu.nb_implemented_counters) {
>>>> +		report_skip("No event counter, skip ...");
>>>> +		return;
>>>> +	}
>>>> +
>>>> +	/* PMUv3 requires an implementation includes some common events */
>>>> +	required_events =3D is_event_supported(0x0, true) /* SW_INCR */ &&
>>>> +			  is_event_supported(0x11, true) /* CPU_CYCLES */ &&
>>>> +			  (is_event_supported(0x8, true) /* INST_RETIRED */ ||
>>>> +			   is_event_supported(0x1B, true) /* INST_PREC */);
>>>> +
>>>> +	if (pmu.version =3D=3D 0x4) {
>>>> +		/* ARMv8.1 PMU: STALL_FRONTEND and STALL_BACKEND are required */
>>>> +		required_events =3D required_events ||
>>>> +				  is_event_supported(0x23, true) ||
>>>
>>> Shouldn't those two operators be '&&' instead?
>> yes definitively
>>>
>>>> +				  is_event_supported(0x24, true);
>>>> +	}
>>>> +
>>>> +	/*
>>>> +	 * L1D_CACHE_REFILL(0x3) and L1D_CACHE(0x4) are only required if
>>>> +	 * L1 data / unified cache. BR_MIS_PRED(0x10), BR_PRED(0x12) are o=
nly
>>>> +	 * required if program-flow prediction is implemented.
>>>> +	 */
>>>
>>> Is this a TODO?
>> yes. Added TODO. I do not know how to check whether the conditions are
>> satisfied? Do you have any idea?
>=20
> Well, AFAICS KVM doesn't filter PMCEIDn, right? So some basic checks ar=
e
> surely fine, but I wouldn't go crazy about checking every possible
> aspect of it. After all you would just check the hardware, as we pass
> this register on.

I agree I can skip those.

Thanks

Eric
>=20
> Cheers,
> Andre.
>=20
>> Thank you for the review!
>>
>> Eric
>>>
>>> Cheers,
>>> Andre
>>>
>>>
>>>> +
>>>> +	report(required_events, "Check required events are implemented");
>>>> +}
>>>> +
>>>>  #endif
>>>> =20
>>>>  /*
>>>> @@ -326,6 +394,9 @@ int main(int argc, char *argv[])
>>>>  		       "Monotonically increasing cycle count");
>>>>  		report(check_cpi(cpi), "Cycle/instruction ratio");
>>>>  		pmccntr64_test();
>>>> +	} else if (strcmp(argv[1], "event-introspection") =3D=3D 0) {
>>>> +		report_prefix_push(argv[1]);
>>>> +		test_event_introspection();
>>>>  	} else {
>>>>  		report_abort("Unknown sub-test '%s'", argv[1]);
>>>>  	}
>>>> diff --git a/arm/unittests.cfg b/arm/unittests.cfg
>>>> index 79f0d7a..4433ef3 100644
>>>> --- a/arm/unittests.cfg
>>>> +++ b/arm/unittests.cfg
>>>> @@ -66,6 +66,12 @@ file =3D pmu.flat
>>>>  groups =3D pmu
>>>>  extra_params =3D -append 'cycle-counter 0'
>>>> =20
>>>> +[pmu-event-introspection]
>>>> +file =3D pmu.flat
>>>> +groups =3D pmu
>>>> +arch =3D arm64
>>>> +extra_params =3D -append 'event-introspection'
>>>> +
>>>>  # Test PMU support (TCG) with -icount IPC=3D1
>>>>  #[pmu-tcg-icount-1]
>>>>  #file =3D pmu.flat
>>>
>>
>=20

