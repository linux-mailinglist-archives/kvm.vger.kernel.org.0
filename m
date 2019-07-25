Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5EF74EA9
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2019 14:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfGYM6u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jul 2019 08:58:50 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:48425 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbfGYM6u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jul 2019 08:58:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1564059529; x=1595595529;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=qFECzT41lBG2MySNnYOUd1oQJ9XZpzRrKW7TJx5bGVw=;
  b=kWp+6bdnn8aku8gJOArblTd7dZ74RAlhjeQGwweLsLIDGma3GxYvWR2p
   NmikyrpXLgifB3Zlh/CeSaxmREN3phaeQWcdBPT/WSEHMsbAXxbtO8Jqi
   g6K/x1JRVrv49L2T/zNBL+Nfr39p8za1Rjb1MOTWlP8espDRnfKN9TRo1
   8=;
X-IronPort-AV: E=Sophos;i="5.64,306,1559520000"; 
   d="scan'208";a="776211028"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1a-715bee71.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 25 Jul 2019 12:58:48 +0000
Received: from EX13MTAUWC001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1a-715bee71.us-east-1.amazon.com (Postfix) with ESMTPS id 7F8B4A2EB7;
        Thu, 25 Jul 2019 12:58:46 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC001.ant.amazon.com (10.43.162.135) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 25 Jul 2019 12:58:45 +0000
Received: from 38f9d3867b82.ant.amazon.com (10.43.162.67) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 25 Jul 2019 12:58:43 +0000
Subject: Re: [PATCH kvm-unit-tests v2] arm: Add PL031 test
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>
References: <20190712091938.492-1-graf@amazon.com>
 <20190715164235.z2xar7nqi5guqfuf@kamzik.brq.redhat.com>
 <02a38777-3ec0-0354-8d49-d8ce337e5660@amazon.com>
 <20190725123344.4lmeopzyl4jdnsp7@kamzik.brq.redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <67336ba0-c7dd-e6e5-9910-a85dba46c947@amazon.com>
Date:   Thu, 25 Jul 2019 14:58:41 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725123344.4lmeopzyl4jdnsp7@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.43.162.67]
X-ClientProxiedBy: EX13D01UWA003.ant.amazon.com (10.43.160.107) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 25.07.19 14:33, Andrew Jones wrote:
> On Thu, Jul 25, 2019 at 02:12:19PM +0200, Alexander Graf wrote:
>>
>>
>> On 15.07.19 18:42, Andrew Jones wrote:
>>> On Fri, Jul 12, 2019 at 11:19:38AM +0200, Alexander Graf wrote:
>>>> This patch adds a unit test for the PL031 RTC that is used in the virt machine.
>>>> It just pokes basic functionality. I've mostly written it to familiarize myself
>>>> with the device, but I suppose having the test around does not hurt, as it also
>>>> exercises the GIC SPI interrupt path.
>>>>
>>>> Signed-off-by: Alexander Graf <graf@amazon.com>
>>>>
>>>> ---
>>>>
>>>> v1 -> v2:
>>>>
>>>>     - Use FDT to find base, irq and existence
>>>>     - Put isb after timer read
>>>>     - Use dist_base for gicv3
>>>> ---
>>>>    arm/Makefile.common |   1 +
>>>>    arm/pl031.c         | 265 ++++++++++++++++++++++++++++++++++++++++++++
>>>>    lib/arm/asm/gic.h   |   1 +
>>>>    3 files changed, 267 insertions(+)
>>>>    create mode 100644 arm/pl031.c
>>>>
>>>> diff --git a/arm/Makefile.common b/arm/Makefile.common
>>>> index f0c4b5d..b8988f2 100644
>>>> --- a/arm/Makefile.common
>>>> +++ b/arm/Makefile.common
>>>> @@ -11,6 +11,7 @@ tests-common += $(TEST_DIR)/pmu.flat
>>>>    tests-common += $(TEST_DIR)/gic.flat
>>>>    tests-common += $(TEST_DIR)/psci.flat
>>>>    tests-common += $(TEST_DIR)/sieve.flat
>>>> +tests-common += $(TEST_DIR)/pl031.flat
>>>
>>> Makefile.common is for both arm32 and arm64, but this code is only
>>> compilable on arm64. As there's no reason for it to be arm64 only,
>>> then ideally we'd modify the code to allow compiling and running
>>> on both, but otherwise we need to move this to Makefile.arm64.
>>
>> D'oh. Sorry, I completely missed that bit. Of course we want to test on
>> 32bit ARM as well! I'll fix it up :).
>>
>>
>> [...]
>>
>>>> +static int rtc_fdt_init(void)
>>>> +{
>>>> +	const struct fdt_property *prop;
>>>> +	const void *fdt = dt_fdt();
>>>> +	int node, len;
>>>> +	u32 *data;
>>>> +
>>>> +	node = fdt_node_offset_by_compatible(fdt, -1, "arm,pl031");
>>>> +	if (node < 0)
>>>> +		return -1;
>>>> +
>>>> +	prop = fdt_get_property(fdt, node, "interrupts", &len);
>>>> +	assert(prop && len == (3 * sizeof(u32)));
>>>> +	data = (u32 *)prop->data;
>>>> +	assert(data[0] == 0); /* SPI */
>>>> +	pl031_irq = SPI(fdt32_to_cpu(data[1]));
>>>
>>> Nit: Ideally we'd add some more devicetree API to get interrupts. With
>>> that, and the existing devicetree API, we could remove all low-level fdt
>>> related code in this function.
>>
>> Well, we probably want some really high level fdt API that can traverse reg
>> properly to map bus regs into physical addresses. As long as we don't have
>> all that magic,
> 
> We do have much of that magic already. Skim through lib/devicetree.h to
> see what's available.

Hum, interesting. There really is some good code in there :).

> 
>> I see little point in inventing anything that looks more
>> sophisticated but doesn't actually take the difficult problems into account
>> :).
> 
> Well, for this case, the "interrupts" decoding isn't difficult and could
> be shared among other devices if we added it to devicetree.c. And the
> reg decoding below to get the base address is already supported by the
> devicetree API.

The main problem with interrupts is that its semantics are not generic. 
Items like "SPI/LPI", "EDGE/Level", "vector" are all target defined.

> All that said, it's just a nit that I won't insist on though, because it's
> hard enough to get unit test contributors without asking that they also
> contribute to the framework.

:)


Alex
