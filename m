Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8EA265AA3
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 09:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725730AbgIKHkR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 03:40:17 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:57808 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbgIKHkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Sep 2020 03:40:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599810013; x=1631346013;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=UtU8cHk7dC7NJ+X6wTkUmJT4/ZJ7Wx++LRb1OyZmff4=;
  b=ZywYr5qgbPqRiw+NcwXi6EzvioIoDfI3fxsKtQJk2F/P+BkOxokVjRR2
   TVlx+3bxVxMqmeeU4euXyeavEFucB6ymn6YRdTYIB1xyakMLkbqXl5L0S
   9PSu3o0ZimxNNcqesztf+F1O7IvRdIzS3qlvhO6ioYCysVHJO6ncDlwyR
   w=;
X-IronPort-AV: E=Sophos;i="5.76,414,1592870400"; 
   d="scan'208";a="67167348"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-e7be2041.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 11 Sep 2020 07:40:11 +0000
Received: from EX13MTAUWC002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-e7be2041.us-west-2.amazon.com (Postfix) with ESMTPS id EAA65A213F;
        Fri, 11 Sep 2020 07:40:09 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Sep 2020 07:40:09 +0000
Received: from Alexanders-MacBook-Air.local (10.43.162.73) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Fri, 11 Sep 2020 07:40:06 +0000
Subject: Re: [PATCH v3] KVM: arm64: Preserve PMCR immutable values across
 reset
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvmarm@lists.cs.columbia.edu>, Marc Zyngier <maz@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Suzuki K Poulose" <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Eric Auger <eric.auger@redhat.com>
References: <20200910164243.29253-1-graf@amazon.com>
 <20200910173609.niujn2ngnjzvx7ub@kamzik.brq.redhat.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <2938f7ef-a723-2ee3-0a87-25cbde177d23@amazon.com>
Date:   Fri, 11 Sep 2020 09:40:04 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200910173609.niujn2ngnjzvx7ub@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.43.162.73]
X-ClientProxiedBy: EX13D49UWB003.ant.amazon.com (10.43.163.121) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.09.20 19:36, Andrew Jones wrote:
> =

> On Thu, Sep 10, 2020 at 06:42:43PM +0200, Alexander Graf wrote:
>> We allow user space to set the PMCR register to any value. However,
>> when time comes for a vcpu reset (for example on PSCI online), PMCR
>> is reset to the hardware capabilities.
>>
>> I would like to explicitly expose different PMU capabilities (number
>> of supported event counters) to the guest than hardware supports.
>> Ideally across vcpu resets.
>>
>> So this patch adopts the reset path to only populate the immutable
>> PMCR register bits from hardware when they were not initialized
>> previously. This effectively means that on a normal reset, only the
>> guest settable fields are reset, while on vcpu creation the register
>> gets populated from hardware like before.
>>
>> With this in place and a change in user space to invoke SET_ONE_REG
>> on the PMCR for every vcpu, I can reliably set the PMU event counter
>> number to arbitrary values.
>>
>> Signed-off-by: Alexander Graf <graf@amazon.com>
>> ---
>>   arch/arm64/kvm/sys_regs.c | 9 ++++++++-
>>   1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 20ab2a7d37ca..28f67550db7f 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -663,7 +663,14 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r)
>>   {
>>        u64 pmcr, val;
>>
>> -     pmcr =3D read_sysreg(pmcr_el0);
>> +     /*
>> +      * If we already received PMCR from a previous ONE_REG call,
>> +      * maintain its immutable flags
>> +      */
>> +     pmcr =3D __vcpu_sys_reg(vcpu, r->reg);
>> +     if (!__vcpu_sys_reg(vcpu, r->reg))
>> +             pmcr =3D read_sysreg(pmcr_el0);
>> +
>>        /*
>>         * Writable bits of PMCR_EL0 (ARMV8_PMU_PMCR_MASK) are reset to U=
NKNOWN
>>         * except PMCR.E resetting to zero.
>> --
>> 2.16.4
>>
> =

> Aha, a much simpler patch than I expected. With this approach we don't
> need a get_user() function, or to use 'val', but don't we still want to
> add sanity checks with a set_user() function? At least to ensure immutable
> flags match and that PMCR_EL0.N isn't too big?

We don't check for any flags today, so in a way adding checks would be =

ABI breakage.

And as Marc pointed out, all of the counters are basically virtual =

through perf. So if you report 31 counters, you end up spawning 31 perf =

counters which get multiplexed, so it would work (albeit not be terribly =

accurate).

That leaves identification bits as something we can check for. But do we =

really have to? What's the worst thing that can happen? KVM user space =

can shoot themselves in the foot. Well, they can also set PC to an =

invalid value. If you do bad things you get bad results :). As long as =

it's not a security risk, I'm not sure the benefits of checking outweigh =

the risks.

> Silently changing the user's input, which I see we also do for e.g. MPIDR,
> isn't super user friendly.

Yes :).


Alex



Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



