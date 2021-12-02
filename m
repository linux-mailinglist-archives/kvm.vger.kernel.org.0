Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC528466439
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 14:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346633AbhLBNFd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 08:05:33 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35040 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232890AbhLBNFc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 08:05:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638450129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x1DDUlEbW7+TEcKrOe/PwHbaKXvgftYv4zFADOMy298=;
        b=cHijUvy92GgHlTfGpXiWSMaNyVnwZouO58KsDYTCL/25hQftOfxnLyOpXRnOlsGTgjXRkk
        q8ZpMdEkWiIETJRWLOmwH84CuyD7wGSCmDR21IJZqrA/GNux/hA+cFS/NKzXgzXUhNVsPx
        aZGKgytmt0DchN7HFptIqx2ROdpJVJg=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-ygrPi9dcOmWDreVNo01PsQ-1; Thu, 02 Dec 2021 08:02:08 -0500
X-MC-Unique: ygrPi9dcOmWDreVNo01PsQ-1
Received: by mail-wr1-f69.google.com with SMTP id r2-20020adfe682000000b00198af042b0dso5030461wrm.23
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 05:02:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x1DDUlEbW7+TEcKrOe/PwHbaKXvgftYv4zFADOMy298=;
        b=fvLQyDdSu5U9M+9pLL12LomsesoxFn5rRS03PNGbZxZS85Ntgvg7njLj9ZDB09DnTq
         a6vFOiF49z0cYjE143ag57t8YF5UBEISqiw+5dY9a+APyrlfkCnyYcM2YRaC3y4kxH+B
         SBAc7MOfGjXuTqcDs16+1aZD5ypDOb4b2r4S9xQHw07jlsAhb7+qJXQIH9iVyYYjgFOg
         FUgtRODpGxJHD2EatqMsBtblX3SqsYGxPrQvykh7kXHCVV5lcPe9MnwGQP3/b1LrIFG3
         yChL2e/f8HI5IjJJGV9mJxjabt/k25BHNKzV34XHvkzpkIABy4l+K/XKybYgkC0FzDk/
         LlmQ==
X-Gm-Message-State: AOAM531UwmUVizQJV2eev//oAcVVd2HO5mDk4kiKT9KBA5EzUMvyn54P
        oqcDdSzuSdJAQriJY/jDqhQ7J65Id3yLCTzDn1zHOkR4NLnLoVWj6iuTYOrbA89REudiybY9kOB
        9E0XRKEeRL3+8
X-Received: by 2002:a05:6000:143:: with SMTP id r3mr14462652wrx.236.1638450127213;
        Thu, 02 Dec 2021 05:02:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzMvw1j4167feOTyg3bdIJl0KldZ/+JDB+tLVdpAglu6yx0xuOJYBL7gNenCbomHVVt1er+1Q==
X-Received: by 2002:a05:6000:143:: with SMTP id r3mr14462621wrx.236.1638450126984;
        Thu, 02 Dec 2021 05:02:06 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id a22sm2110828wme.19.2021.12.02.05.02.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 05:02:06 -0800 (PST)
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
From:   Eric Auger <eauger@redhat.com>
Message-ID: <f9aa15c3-5d7a-36a0-82c9-1db81dca5beb@redhat.com>
Date:   Thu, 2 Dec 2021 14:02:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAAeT=Fz96dYR2m7UbgVw_SjNV6wheYBfSx+m+zCWbnHWHkcQdw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Reiji,

On 11/30/21 2:29 AM, Reiji Watanabe wrote:
> Hi Eric,
> 
> On Thu, Nov 25, 2021 at 7:35 AM Eric Auger <eauger@redhat.com> wrote:
>>
>> Hi Reiji,
>>
>> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
>>> This patch adds id_reg_info for ID_AA64PFR0_EL1 to make it writable by
>>> userspace.
>>>
>>> The CSV2/CSV3 fields of the register were already writable and values
>>> that were written for them affected all vCPUs before. Now they only
>>> affect the vCPU.
>>> Return an error if userspace tries to set SVE/GIC field of the register
>>> to a value that conflicts with SVE/GIC configuration for the guest.
>>> SIMD/FP/SVE fields of the requested value are validated according to
>>> Arm ARM.
>>>
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> ---
>>>  arch/arm64/kvm/sys_regs.c | 159 ++++++++++++++++++++++++--------------
>>>  1 file changed, 103 insertions(+), 56 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 1552cd5581b7..35400869067a 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -401,6 +401,92 @@ static void id_reg_info_init(struct id_reg_info *id_reg)
>>>               id_reg->init(id_reg);
>>>  }
>>>
>>> +#define      kvm_has_gic3(kvm)               \
>>> +     (irqchip_in_kernel(kvm) &&      \
>>> +      (kvm)->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
>> you may move this macro to kvm/arm_vgic.h as this may be used in
>> vgic/vgic-v3.c too
> 
> Thank you for the suggestion. I will move that to kvm/arm_vgic.h.
> 
> 
>>> +
>>> +static int validate_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>>> +                                 const struct id_reg_info *id_reg, u64 val)
>>> +{
>>> +     int fp, simd;
>>> +     bool vcpu_has_sve = vcpu_has_sve(vcpu);
>>> +     bool pfr0_has_sve = id_aa64pfr0_sve(val);
>>> +     int gic;
>>> +
>>> +     simd = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_ASIMD_SHIFT);
>>> +     fp = cpuid_feature_extract_signed_field(val, ID_AA64PFR0_FP_SHIFT);
>>> +     if (simd != fp)
>>> +             return -EINVAL;
>>> +
>>> +     /* fp must be supported when sve is supported */
>>> +     if (pfr0_has_sve && (fp < 0))
>>> +             return -EINVAL;
>>> +
>>> +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
>>> +     if (vcpu_has_sve ^ pfr0_has_sve)
>>> +             return -EPERM;
>>> +
>>> +     gic = cpuid_feature_extract_unsigned_field(val, ID_AA64PFR0_GIC_SHIFT);
>>> +     if ((gic > 0) ^ kvm_has_gic3(vcpu->kvm))
>>> +             return -EPERM;
>>
>> Sometimes from a given architecture version, some lower values are not
>> allowed. For instance from ARMv8.5 onlt 1 is permitted for CSV3.
>> Shouldn't we handle that kind of check?
> 
> As far as I know, there is no way for guests to identify the
> architecture revision (e.g. v8.1, v8.2, etc).  It might be able
> to indirectly infer the revision though (from features that are
> available or etc).

OK. That sounds weird to me as we do many checks accross different IDREG
settings but we may eventually have a wrong "CPU model" exposed by the
user space violating those spec revision minima. Shouldn't we introduce
some way for the userspace to provide his requirements? via new VCPU
targets for instance?

Thanks

Eric
> 
> 
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static void init_id_aa64pfr0_el1_info(struct id_reg_info *id_reg)
>>> +{
>>> +     u64 limit = id_reg->vcpu_limit_val;
>>> +     unsigned int gic;
>>> +
>>> +     limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_AMU);
>>> +     if (!system_supports_sve())
>>> +             limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
>>> +
>>> +     /*
>>> +      * The default is to expose CSV2 == 1 and CSV3 == 1 if the HW
>>> +      * isn't affected.  Userspace can override this as long as it
>>> +      * doesn't promise the impossible.
>>> +      */
>>> +     limit &= ~(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2) |
>>> +                ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3));
>>> +
>>> +     if (arm64_get_spectre_v2_state() == SPECTRE_UNAFFECTED)
>>> +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV2), 1);
>>> +     if (arm64_get_meltdown_state() == SPECTRE_UNAFFECTED)
>>> +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), 1);
>>> +
>>> +     gic = cpuid_feature_extract_unsigned_field(limit, ID_AA64PFR0_GIC_SHIFT);
>>> +     if (gic > 1) {
>>> +             /* Limit to GICv3.0/4.0 */
>>> +             limit &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
>>> +             limit |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_GIC), 1);
>>> +     }
>>> +     id_reg->vcpu_limit_val = limit;
>>> +}
>>> +
>>> +static u64 get_reset_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
>>> +                                  const struct id_reg_info *idr)
>>> +{
>>> +     u64 val = idr->vcpu_limit_val;
>>> +
>>> +     if (!vcpu_has_sve(vcpu))
>>> +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
>>> +
>>> +     if (!kvm_has_gic3(vcpu->kvm))
>>> +             val &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_GIC);
>>> +
>>> +     return val;
>>> +}
>>> +
>>> +static struct id_reg_info id_aa64pfr0_el1_info = {
>>> +     .sys_reg = SYS_ID_AA64PFR0_EL1,
>>> +     .ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
>>> +                        S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
>> is it needed as it is the default?
> 
>>> +     .ftr_check_types = S_FCT(ID_AA64PFR0_ASIMD_SHIFT, FCT_LOWER_SAFE) |
>>> +                        S_FCT(ID_AA64PFR0_FP_SHIFT, FCT_LOWER_SAFE),
>> is it needed as it is the default?
> 
> They are needed because they are signed fields (the default is unsigned

Ah OK, I did not catch it at first glance while looking at the ARM ARM.

Thanks

Eric

> and FCT_LOWER_SAFE).  Having said that, ftr_check_types itself will be
> gone in the next version (as arm64_ftr_bits will be used instead).
> 
> Thanks,
> Reiji
> 

