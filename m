Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141F04068AA
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 10:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhIJInl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 04:43:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37505 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231792AbhIJInj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Sep 2021 04:43:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631263348;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4PAmqK0AZfTXsxp0NXAfSvFh8GVmMkYIerkksseWE4E=;
        b=Af48KPnsUsaou6bEFReOxRLS2HBmQeKXp2RCLmCu2a9N/o9V46+7LLnyjdC5wBZRjb4uk7
        n0eI2m0U+QOTTdTbdlJMUtxbouu+DnccoGFz4M2FzioVWSvqHod/ct07dhVMQ5P1fMZ+cl
        CXHR+3irQJakssKo6yiomNnEvpUqw4Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-cqVH_ZaLNKGFBGrbHvDbkw-1; Fri, 10 Sep 2021 04:42:27 -0400
X-MC-Unique: cqVH_ZaLNKGFBGrbHvDbkw-1
Received: by mail-wm1-f71.google.com with SMTP id c2-20020a7bc8420000b0290238db573ab7so634718wml.5
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 01:42:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=4PAmqK0AZfTXsxp0NXAfSvFh8GVmMkYIerkksseWE4E=;
        b=QWHOKlau/H+qWXtkJe13ysjFwi8B00R/f9QNsLCshNk9MHI9rZ8MD+1t+rzFb9qeBA
         yvBk3M2hZ81wvao3CCsZ+O8W4lf5qxHbw1AfQ6kUSZcBazjqGYxg4BTuH29j8wV0BeWM
         j7wa1PzzNg9OfnqmG2RLsSmCItxiSLgs79H6Ex4IPZGgQlRqC4TXi4k6zlD/dxNukCo/
         HmR7RhLhicb1r0p/TlZ9/djJn+IH/3pmlr13uJmchN7naGPQ9GHuaH73ghHyNj75EKp5
         uPeokZBGcnYWgG87Bf2SoU59BekOEglh9ziRpYAIw16321nJrUGfdz1sXbG/yksNtdFe
         XB2Q==
X-Gm-Message-State: AOAM530rJqp9vQ5Kt22VUoAkam/e2iaGteYMs9+HiZL3OP7e/IhTFkC9
        ycxIFC205DQNdIGlnuOplvjmSTigcuhADBDBYA6sMhJhtPJlzkfsKbarH9zgQyJAU9yZSYDLMK+
        dlTic59yNXccV
X-Received: by 2002:a5d:4245:: with SMTP id s5mr8618241wrr.237.1631263346078;
        Fri, 10 Sep 2021 01:42:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyIlkFxf2waJe6/Mor40awy3B6n2CJIC22w+EP8RGLtZz+weP4GXQg+kzR3GTUle7QcuZ7FAg==
X-Received: by 2002:a5d:4245:: with SMTP id s5mr8618224wrr.237.1631263345853;
        Fri, 10 Sep 2021 01:42:25 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a10sm4124367wrd.51.2021.09.10.01.42.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Sep 2021 01:42:25 -0700 (PDT)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        oupton@google.com, james.morse@arm.com, suzuki.poulose@arm.com,
        shuah@kernel.org, jingzhangos@google.com, pshier@google.com,
        rananta@google.com, reijiw@google.com
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com> <YTo6kX7jGeR3XvPg@google.com>
 <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <80bdbdb3-1bff-aa99-c49b-76d6bd960aa9@redhat.com>
Date:   Fri, 10 Sep 2021 10:42:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alexandru,

On 9/10/21 10:28 AM, Alexandru Elisei wrote:
> Hi Ricardo,
>
> On 9/9/21 5:47 PM, Ricardo Koller wrote:
>> On Thu, Sep 09, 2021 at 11:20:15AM +0100, Alexandru Elisei wrote:
>>> Hi Ricardo,
>>>
>>> On 9/8/21 10:03 PM, Ricardo Koller wrote:
>>>> Extend vgic_v3_check_base() to verify that the redistributor regions
>>>> don't go above the VM-specified IPA size (phys_size). This can happen
>>>> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
>>>>
>>>>   base + size > phys_size AND base < phys_size
>>>>
>>>> vgic_v3_check_base() is used to check the redist regions bases when
>>>> setting them (with the vcpus added so far) and when attempting the first
>>>> vcpu-run.
>>>>
>>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>>> ---
>>>>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
>>>>  1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>>>> index 66004f61cd83..5afd9f6f68f6 100644
>>>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>>>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>>>> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>>>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>>>>  			rdreg->base)
>>>>  			return false;
>>>> +
>>>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
>>>> +			kvm_phys_size(kvm))
>>>> +			return false;
>>> Looks to me like this same check (and the overflow one before it) is done when
>>> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_redist_base()
>>> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I can tell,
>>> kvm_vgic_addr() handles both ways of setting the Redistributor address.
>>>
>>> Without this patch, did you manage to set a base address such that base + size >
>>> kvm_phys_size()?
>>>
>> Yes, with the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API. The easiest way
>> to get to this situation is with the selftest in patch 2.  I then tried
>> an extra experiment: map the first redistributor, run the first vcpu,
>> and access the redist from inside the guest. KVM didn't complain in any
>> of these steps.
> Yes, Eric pointed out that I was mistaken and there is no check being done for
> base + size > kvm_phys_size().
>
> What I was trying to say is that this check is better done when the user creates a
> Redistributor region, not when a VCPU is first run. We have everything we need to
> make the check when a region is created, why wait until the VCPU is run?
>
> For example, vgic_v3_insert_redist_region() is called each time the adds a new
> Redistributor region (via either of the two APIs), and already has a check for the
> upper limit overflowing (identical to the check in vgic_v3_check_base()). I would
> add the check against the maximum IPA size there.
you seem to refer to an old kernel as vgic_v3_insert_redist_region was
renamed into  vgic_v3_alloc_redist_region in
e5a35635464b kvm: arm64: vgic-v3: Introduce vgic_v3_free_redist_region()

I think in case you use the old rdist API you do not know yet the size
of the redist region at this point (count=0), hence Ricardo's choice to
do the check latter.
>
> Also, because vgic_v3_insert_redist_region() already checks for overflow, I
> believe the overflow check in vgic_v3_check_base() is redundant.
>
> As far as I can tell, vgic_v3_check_base() is there to make sure that the
> Distributor doesn't overlap with any of the Redistributors, and because the
> Redistributors and the Distributor can be created in any order, we defer the check
> until the first VCPU is run. I might be wrong about this, someone please correct
> me if I'm wrong.
>
> Also, did you verify that KVM is also doing this check for GICv2? KVM does
> something similar and calls vgic_v2_check_base() when mapping the GIC resources,
> and I don't see a check for the maximum IPA size in that function either.

I think vgic_check_ioaddr() called in kvm_vgic_addr() does the job (it
checks the base @)

Thanks

Eric
>
> Thanks,
>
> Alex
>
>> Thanks,
>> Ricardo
>>
>>> Thanks,
>>>
>>> Alex
>>>
>>>>  	}
>>>>  
>>>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))

