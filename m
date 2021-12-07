Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE1D246B7B5
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234203AbhLGJpo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:45:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33807 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234183AbhLGJpm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 04:45:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638870132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IfdtTnAi2J8orsL+RMPenY5oP4wZsK7814Lhx3qxSSo=;
        b=CCkFvqgxZc8nTDBrnDLfFmcIogiVmS+oFKkIK5EEor6juKFtruxkYmrXuDL7XSDvDM5LKO
        +vURZ2NFUKn4I4vmng/ys+H+XEdwKNFuhyqt0eDPdNohzjKNDHjfKkXX9AXx6LznsOPYJ7
        wVL52ZTdnuD9Zsvy1diMUwgM6cYJ1Fw=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-157-44H-T0C5OL-xJgbj_GFgEg-1; Tue, 07 Dec 2021 04:42:11 -0500
X-MC-Unique: 44H-T0C5OL-xJgbj_GFgEg-1
Received: by mail-wm1-f69.google.com with SMTP id m14-20020a05600c3b0e00b0033308dcc933so1122725wms.7
        for <kvm@vger.kernel.org>; Tue, 07 Dec 2021 01:42:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IfdtTnAi2J8orsL+RMPenY5oP4wZsK7814Lhx3qxSSo=;
        b=lYT/fX6R801hapk4L1qVJDTDVcV8e/yLOzQDCVQADmoTx8tNCsMpK3YynvplcN+mlQ
         WN3Hhw1FRsNl3kkQDf3CuXTZVWzB5wd2IFKxtTrkkO+O/agKGE/uFlFZGBFx+bWW5Vg3
         vJRSiKJLzMNh7R110qZ0mALOCATEIjR9zuK2uXF2DvBwYkHXYJVnCE5mVdSTTIjkObYj
         TCDJckb9UAh70D11tOLGQX8rEKa1wJedGcYIgpuVI8YimBZxw/1Y49lEPnlXrnAjRk3P
         PYv+Qi/84ah1WG595ZrcnWYTRQljXD3B3KE24EIBA+49xvVM7M8oabZ4Lhw6M4iUAd4B
         1pbg==
X-Gm-Message-State: AOAM532ZMMbIA63Ydq8fON9G6SMnhwSzUNMkVWhIkcnKeEL2OpE50ptC
        Z5XwkDE1hmFP5x8ob4voLXKtD67+KTdQHZMcatKXU58eutAR52qRz9VzPRda2rnTxbddv20qnYc
        BaTSt1q2atvvi
X-Received: by 2002:a05:600c:35c8:: with SMTP id r8mr5642760wmq.8.1638870129230;
        Tue, 07 Dec 2021 01:42:09 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzgiz4h3rob+EwyRswCrpRZGyj0kE1qIofZJRmkuP700RK+ws81XqcftlJ91CeLT3kVM2yBuA==
X-Received: by 2002:a05:600c:35c8:: with SMTP id r8mr5642733wmq.8.1638870129012;
        Tue, 07 Dec 2021 01:42:09 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id d15sm18436814wri.50.2021.12.07.01.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 01:42:08 -0800 (PST)
Subject: Re: [RFC PATCH v3 04/29] KVM: arm64: Make ID_AA64PFR0_EL1 writable
To:     Reiji Watanabe <reijiw@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
References: <20211117064359.2362060-1-reijiw@google.com>
 <20211117064359.2362060-5-reijiw@google.com>
 <b56f871c-11da-e8ff-e90e-0ec3b4c0207f@redhat.com>
 <CAAeT=Fz96dYR2m7UbgVw_SjNV6wheYBfSx+m+zCWbnHWHkcQdw@mail.gmail.com>
 <f9aa15c3-5d7a-36a0-82c9-1db81dca5beb@redhat.com>
 <CAAeT=Fz2tLMDOkZ4kQYV0tS44MEtSUxPH71+XD3r+VyJxbjd_g@mail.gmail.com>
From:   Eric Auger <eauger@redhat.com>
Message-ID: <728dae43-c97e-0982-b7d0-dd7d6eed6d6b@redhat.com>
Date:   Tue, 7 Dec 2021 10:42:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=Fz2tLMDOkZ4kQYV0tS44MEtSUxPH71+XD3r+VyJxbjd_g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 12/4/21 8:59 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Dec 2, 2021 at 5:02 AM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/30/21 2:29 AM, Reiji Watanabe wrote:
>>> Hi Eric,
>>>
>>> On Thu, Nov 25, 2021 at 7:35 AM Eric Auger <eauger@redhat.com> wrote:
>>>>
>>>> Hi Reiji,
>>>>
>>>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>>>> This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
>>>>> userspace.
>>>>>
>>>>> The CSV2/CSV3 fields of the register were already writable and values
>>>>> that were written for them affected all vCPUs before. Now they only
>>>>> affect the vCPU.
>>>>> Return an error if userspace tries to set SVE/GIC field of the register
>>>>> to a value that conflicts with SVE/GIC configuration for the guest.
>>>>> SIMD/FP/SVE fields of the requested value are validated according to
>>>>> Arm ARM.
>>>>>
>>>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>>>> ---
>>>>>  arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
>>>>>  1 file changed, 103 insertions(+), 56 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>>> index 1552cd5581b7..35400869067a 100644
>>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>>> @@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
>>>>>               id_reg->init(id_reg);
>>>>>  }
>>>>>
>>>>> +#define      kvm_has_gic3(kvm)               \
>>>>> +     (irqchip_in_kernel(kvm) &&      \
>>>>> +      (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
>>>> you may move this macro to kvm/arm_vgic.h as this may be used in
>>>> vgic/vgic-v3.c too
>>>
>>> Thank you for the suggestion. I will move that to kvm/arm_vgic.h.
>>>
>>>
>>>>> +
>>>>> +static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>>>>> +                                 const struct id_reg_info *id_reg, u64 val)
>>>>> +{
>>>>> +     int fp, simd;
>>>>> +     bool vcpu_has_sve = vcpu_has_sve(vcpu);
>>>>> +     bool pfr0_has_sve = id_aa64pfr0_sve(val);
>>>>> +     int gic;
>>>>> +
>>>>> +     simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
>>>>> +     fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
>>>>> +     if (simd != fp)
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     /* fp must be supported when sve is supported */
>>>>> +     if (pfr0_has_sve && (fp < 0))
>>>>> +             return -EINVAL;
>>>>> +
>>>>> +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
>>>>> +     if (vcpu_has_sve ^ pfr0_has_sve)
>>>>> +             return -EPERM;
>>>>> +
>>>>> +     gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
>>>>> +     if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
>>>>> +             return -EPERM;
>>>>
>>>> Sometimes from a given architecture version, some lower values are not
>>>> allowed. For instance from ARMv8.5 onlt 1 is permitted for CSV3.
>>>> Shouldn't we handle that kind of check?
>>>
>>> As far as I know, there is no way for guests to identify the
>>> architecture revision (e.g. v8.1, v8.2, etc).  It might be able
>>> to indirectly infer the revision though (from features that are
>>> available or etc).
>>
>> OK. That sounds weird to me as we do many checks accross different IDREG
>> settings but we may eventually have a wrong "CPU model" exposed by the
>> user space violating those spec revision minima. Shouldn't we introduce
>> some way for the userspace to provide his requirements? via new VCPU
>> targets for instance?
> 
> Thank you for sharing your thoughts and providing the suggestion !
> 
> Does the "new vCPU targets" mean Armv8.0, armv8.1, and so on ?

Yeah my suggestion probably is not a good idea, ie. introducing such
VCPU targets. I was simply confused by the fact we introduce in this
series quite intricate consistency checks but given the fact we miss the
spec rev information we are not exhaustive in terms of checking. So it
is sometimes difficult to review against the spec.

> 
> The ID registers' consistency checking in the series is to not
> promise more to userspace than what KVM (on the host) can provide,
> and to not expose ID register values that are not supported on
> any ARM v8 architecture for guests (I think those are what the
> current KVM is trying to assure).  I'm not trying to have KVM
> provide full consistency checking of ID registers to completely
> prevent userspace's bugs in setting ID registers.
> 
> I agree that it's quite possible that userspace exposes such wrong
> CPU models, and KVM's providing more consistency checking would be
> nicer in general.  But should it be KVM's responsibility to completely
> prevent such ID register issues due to userspace bugs ?
> 
> Honestly, I'm a bit reluctant to do that so far yet:)

understood. I will look at the spec in more details on my next review
cycle. Looking forward to reviewing the next version ;-)

Thanks

Eric
> If that is something useful that userspace or we (KVM developers)
> really want or need, or such userspace issue could affect KVM,
> I would be happy to add such extra consistency checking though.
> 
> Thanks,
> Reiji
> 

