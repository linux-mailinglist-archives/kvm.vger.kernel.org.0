Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E561805CB
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 19:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCJSHL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 14:07:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726269AbgCJSHL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 14:07:11 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 110802146E;
        Tue, 10 Mar 2020 18:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583863630;
        bh=rHYS2dfliP5kBBFI8WXzNz2+NnXttJ2pOTUrYGHzrPs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NvQi3eK//4yMrQUAifYnYu1PWXL+qiDJEyW/u+fxmWzYSscjcFAkzncBvknsJMDgu
         yJVMiSJom2dyM3axRabWI01RADaSXS3ohbIc7WSgmuyu7pFmH/xcwQop4RRQTv5EiD
         wIkQwTkihaIqbjVQ6J4yoIjMS4YMwZfM+Ge2tS48=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jBjHY-00Bh7w-9n; Tue, 10 Mar 2020 18:07:08 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 10 Mar 2020 18:07:08 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Document PMU filtering API
In-Reply-To: <867c7926-df43-7ab0-d20a-211a59d7612d@redhat.com>
References: <20200309124837.19908-1-maz@kernel.org>
 <20200309124837.19908-3-maz@kernel.org>
 <7943c896-013b-d9cb-ba89-2040b46437fe@redhat.com>
 <07f4ef9b5ff6c6c5086c9723c64c035f@kernel.org>
 <867c7926-df43-7ab0-d20a-211a59d7612d@redhat.com>
Message-ID: <79f80ab568138e1287d0a515e0caa98c@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, robin.murphy@arm.com, mark.rutland@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-10 17:30, Auger Eric wrote:
> Hi Marc,
> 
> On 3/10/20 12:54 PM, Marc Zyngier wrote:
>> On 2020-03-09 18:17, Auger Eric wrote:
>>> Hi Marc,
>>> 
>>> On 3/9/20 1:48 PM, Marc Zyngier wrote:
>>>> Add a small blurb describing how the event filtering API gets used.
>>>> 
>>>> Signed-off-by: Marc Zyngier <maz@kernel.org>
>>>> ---
>>>>  Documentation/virt/kvm/devices/vcpu.rst | 40 
>>>> +++++++++++++++++++++++++
>>>>  1 file changed, 40 insertions(+)
>>>> 
>>>> diff --git a/Documentation/virt/kvm/devices/vcpu.rst
>>>> b/Documentation/virt/kvm/devices/vcpu.rst
>>>> index 9963e680770a..7262c0469856 100644
>>>> --- a/Documentation/virt/kvm/devices/vcpu.rst
>>>> +++ b/Documentation/virt/kvm/devices/vcpu.rst
>>>> @@ -55,6 +55,46 @@ Request the initialization of the PMUv3.  If 
>>>> using
>>>> the PMUv3 with an in-kernel
>>>>  virtual GIC implementation, this must be done after initializing 
>>>> the
>>>> in-kernel
>>>>  irqchip.
>>>> 
>>>> +1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
>>>> +---------------------------------------
>>>> +
>>>> +:Parameters: in kvm_device_attr.addr the address for a PMU event
>>>> filter is a
>>>> +             pointer to a struct kvm_pmu_event_filter
>>>> +
>>>> +:Returns:
>>>> +
>>>> +     =======  
>>>> ======================================================
>>>> +     -ENODEV: PMUv3 not supported or GIC not initialized
>>>> +     -ENXIO:  PMUv3 not properly configured or in-kernel irqchip 
>>>> not
>>>> +           configured as required prior to calling this attribute
>>>> +     -EBUSY:  PMUv3 already initialized
>>> maybe document -EINVAL?
>> 
>> Yup, definitely.
>> 
>>>> +     =======  
>>>> ======================================================
>>>> +
>>>> +Request the installation of a PMU event filter describe as follows:
>>> s/describe/described
>>>> +
>>>> +struct kvm_pmu_event_filter {
>>>> +    __u16    base_event;
>>>> +    __u16    nevents;
>>>> +
>>>> +#define KVM_PMU_EVENT_ALLOW    0
>>>> +#define KVM_PMU_EVENT_DENY    1
>>>> +
>>>> +    __u8    action;
>>>> +    __u8    pad[3];
>>>> +};
>>>> +
>>>> +A filter range is defined as the range [@base_event, @base_event +
>>>> @nevents[,
>>>> +together with an @action (KVM_PMU_EVENT_ALLOW or
>>>> KVM_PMU_EVENT_DENY). The
>>>> +first registered range defines the global policy (global ALLOW if
>>>> the first
>>>> +@action is DENY, global DENY if the first @action is ALLOW).
>>>> Multiple ranges
>>>> +can be programmed, and must fit within the 16bit space defined by
>>>> the ARMv8.1
>>>> +PMU architecture.
>>> what about before 8.1 where the range was 10 bits? Should it be 
>>> tested
>>> in the code?
>> 
>> It's a good point. We could test that upon installing the filter and 
>> limit
>> the bitmap allocation to the minimum.
>> 
>>> nitpicking: It is not totally obvious what does happen if the user 
>>> space
>>> sets a deny filter on a range and then an allow filter on the same
>>> range. it is supported but may be worth telling so? Also explain the 
>>> the
>>> default filtering remains "allow" by default?
>> 
>> Overlapping filters are easy: the last one wins. And yes, no filter 
>> means
>> just that: no filter.
> Actually the point I wanted to put forward is
> 1) set allow filter on range [0-a] -> default setting is deny and allow
> [0-a] only
> 2) deny deny filter on rang [0-a] -> there is no "real" active 
> filtering
> anymore but default behavior still is deny. ie. you do not destroy the
> bitmap on the last filter removal but on the VM removal.

Ah, gotcha. Yes, this is odd. The solution to this is to re-apply a 
default
behaviour. But this needs documenting...

Thanks,

        M.
-- 
Jazz is not dead. It just smells funny...
