Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF8B783876
	for <lists+kvm@lfdr.de>; Tue, 22 Aug 2023 05:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbjHVD1Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 23:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjHVD1W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 23:27:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D58185
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 20:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692674793;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pmreV8p+7mi3GD+UaUl5/7KYIJy0KTAW/4WtYkugdaM=;
        b=FXSRMpVjXiXQCYlPRjH6+Y1WZcr73u8nLOB79Fej67+kjz0jk1XqopIpy8/T5Yl21hTd9g
        LK1JOe1wAG+3sDw2U+DiMQCo1ShLwHzpuWfcdgmvOctrUyA3E9bUymBKNaphvmLYSlpPtS
        3bBxHkGFOzmc+l9GBftOwcjCapnIqf8=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-283-46FzDZZhOEaEOmPRcCPcyw-1; Mon, 21 Aug 2023 23:26:32 -0400
X-MC-Unique: 46FzDZZhOEaEOmPRcCPcyw-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-26f56e28c4eso577367a91.0
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 20:26:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692674789; x=1693279589;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pmreV8p+7mi3GD+UaUl5/7KYIJy0KTAW/4WtYkugdaM=;
        b=J8BeTYbyfBUpCi9cX2+uNO2fQgqxBO/mG4YA3UuGxosicXoYeRGGPQMgaDqSYCRS07
         N12qkDdjyLnqD9VsASDX7WBqzSBF8la6tjJKTo99A3lC2rRvEOGRpRh1s+PGQ/6/bzVg
         t9sO5vinP70G3qc8TV5x604P8p0jIs9yxFmIHx/hMRipVIYKNVioOx+iwaY1TnTzZXDN
         A8ETOyz1tZI+9Grz9tehIgd13dZWHK2hail6DuyKkYWPbYduHt912xSEZ9vZMJEsY4lp
         HSjrN4vPHjznlK1g5EvXxIkA3aHUl28egppD7br3E9U7T5A3VxODYexhXX0n1FJKgWru
         31NQ==
X-Gm-Message-State: AOJu0Yx3qie9G8SYyLxVHJt+Edyhav5kE8KsVke5ERpyZ2Ec/Tuo0vdS
        nWSTR6jxqV0xogE9KlHM2BxdIiLWMNCKymDtfydyxlo7pOp2o3IGRp/42jTW2CdExSGRYj0rcZ/
        89sEY1xpyp9UE
X-Received: by 2002:a05:6a21:78aa:b0:133:7a67:b477 with SMTP id bf42-20020a056a2178aa00b001337a67b477mr11980353pzc.1.1692674789516;
        Mon, 21 Aug 2023 20:26:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEEQ60pTli4q5eZjcCkIIbN45Jc/PtHAhXhxtVA03u4/sI7RjpcbFrvCXLtDwUBFhFzUKi3Wg==
X-Received: by 2002:a05:6a21:78aa:b0:133:7a67:b477 with SMTP id bf42-20020a056a2178aa00b001337a67b477mr11980333pzc.1.1692674789176;
        Mon, 21 Aug 2023 20:26:29 -0700 (PDT)
Received: from [10.72.112.73] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id j16-20020a170902da9000b001bf6ea340a9sm4039664plx.159.2023.08.21.20.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Aug 2023 20:26:28 -0700 (PDT)
Message-ID: <e479914b-7ba2-3a9a-2b07-9965532cbcfa@redhat.com>
Date:   Tue, 22 Aug 2023 11:26:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
Content-Language: en-US
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230817003029.3073210-1-rananta@google.com>
 <20230817003029.3073210-9-rananta@google.com>
 <6dc460d2-c7fb-e299-b0a3-55b43de31555@redhat.com>
 <CAJHc60whpvOHYCFueqh0Q=SbmmeRBG_x90QOvX+vOun73ttjPA@mail.gmail.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAJHc60whpvOHYCFueqh0Q=SbmmeRBG_x90QOvX+vOun73ttjPA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On 8/22/23 07:28, Raghavendra Rao Ananta wrote:
> Hi Shaoqin,
> 
> On Mon, Aug 21, 2023 at 5:12 AM Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>> Hi Raghavendra,
>>
>> On 8/17/23 08:30, Raghavendra Rao Ananta wrote:
>>> From: Reiji Watanabe <reijiw@google.com>
>>>
>>> KVM does not yet support userspace modifying PMCR_EL0.N (With
>>> the previous patch, KVM ignores what is written by upserspace).
>>> Add support userspace limiting PMCR_EL0.N.
>>>
>>> Disallow userspace to set PMCR_EL0.N to a value that is greater
>>> than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
>>> support more event counters than the host HW implements.
>>> Although this is an ABI change, this change only affects
>>> userspace setting PMCR_EL0.N to a larger value than the host.
>>> As accesses to unadvertised event counters indices is CONSTRAINED
>>> UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
>>> on every vCPU reset before this series, I can't think of any
>>> use case where a user space would do that.
>>>
>>> Also, ignore writes to read-only bits that are cleared on vCPU reset,
>>> and RES{0,1} bits (including writable bits that KVM doesn't support
>>> yet), as those bits shouldn't be modified (at least with
>>> the current KVM).
>>>
>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>> ---
>>>    arch/arm64/include/asm/kvm_host.h |  3 ++
>>>    arch/arm64/kvm/pmu-emul.c         |  1 +
>>>    arch/arm64/kvm/sys_regs.c         | 49 +++++++++++++++++++++++++++++--
>>>    3 files changed, 51 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 0f2dbbe8f6a7e..c15ec365283d1 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -259,6 +259,9 @@ struct kvm_arch {
>>>        /* PMCR_EL0.N value for the guest */
>>>        u8 pmcr_n;
>>>
>>> +     /* Limit value of PMCR_EL0.N for the guest */
>>> +     u8 pmcr_n_limit;
>>> +
>>>        /* Hypercall features firmware registers' descriptor */
>>>        struct kvm_smccc_features smccc_feat;
>>>        struct maple_tree smccc_filter;
>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>> index ce7de6bbdc967..39ad56a71ad20 100644
>>> --- a/arch/arm64/kvm/pmu-emul.c
>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>> @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>>>         * while the latter does not.
>>>         */
>>>        kvm->arch.pmcr_n = arm_pmu->num_events - 1;
>>> +     kvm->arch.pmcr_n_limit = arm_pmu->num_events - 1;
>>>
>>>        return 0;
>>>    }
>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>> index 2075901356c5b..c01d62afa7db4 100644
>>> --- a/arch/arm64/kvm/sys_regs.c
>>> +++ b/arch/arm64/kvm/sys_regs.c
>>> @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>>>        return 0;
>>>    }
>>>
>>> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>>> +                 u64 val)
>>> +{
>>> +     struct kvm *kvm = vcpu->kvm;
>>> +     u64 new_n, mutable_mask;
>>> +     int ret = 0;
>>> +
>>> +     new_n = FIELD_GET(ARMV8_PMU_PMCR_N, val);
>>> +
>>> +     mutex_lock(&kvm->arch.config_lock);
>>> +     if (unlikely(new_n != kvm->arch.pmcr_n)) {
>>> +             /*
>>> +              * The vCPU can't have more counters than the PMU
>>> +              * hardware implements.
>>> +              */
>>> +             if (new_n <= kvm->arch.pmcr_n_limit)
>>> +                     kvm->arch.pmcr_n = new_n;
>>> +             else
>>> +                     ret = -EINVAL;
>>> +     }
>>
>> Since we have set the default value of pmcr_n, if we want to set a new
>> pmcr_n, shouldn't it be a different value?
>>
>> So how about change the checking to:
>>
>> if (likely(new_n <= kvm->arch.pmcr_n_limit)
>>          kvm->arch.pmcr_n = new_n;
>> else
>>          ret = -EINVAL;
>>
>> what do you think?
>>
> Sorry, I guess I didn't fully understand your suggestion. Are you
> saying that it's 'likely' that userspace would configure the correct
> value?
>
It depends on how userspace use this api to limit the number of pmcr. I 
think what you mean in the code is that userspace need to set every 
vcpu's pmcr to the same value, so the `unlikely` here is right, only one 
vcpu can change the kvm->arch.pmcr.n, it saves the cpu cycles.

What suggest above might be wrong. Since I think when userspace want to 
limit the number of pmcr, it may just set the new_n on one vcpu, since 
the kvm->arch.pmcr_n is a VM-local value, every vcpu can see it, so it's 
`likely` the (new_n <= kvm->arch.pmcr_n_limit), it can decrease one 
checking statement.

Thanks,
Shaoqin

>>> +     mutex_unlock(&kvm->arch.config_lock);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     /*
>>> +      * Ignore writes to RES0 bits, read only bits that are cleared on
>>> +      * vCPU reset, and writable bits that KVM doesn't support yet.
>>> +      * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
>>> +      * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the vCPU.
>>> +      * But, we leave the bit as it is here, as the vCPU's PMUver might
>>> +      * be changed later (NOTE: the bit will be cleared on first vCPU run
>>> +      * if necessary).
>>> +      */
>>> +     mutable_mask = (ARMV8_PMU_PMCR_MASK | ARMV8_PMU_PMCR_N);
>>> +     val &= mutable_mask;
>>> +     val |= (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
>>> +
>>> +     /* The LC bit is RES1 when AArch32 is not supported */
>>> +     if (!kvm_supports_32bit_el0())
>>> +             val |= ARMV8_PMU_PMCR_LC;
>>> +
>>> +     __vcpu_sys_reg(vcpu, r->reg) = val;
>>> +     return 0;
>>> +}
>>> +
>>>    /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>>>    #define DBG_BCR_BVR_WCR_WVR_EL1(n)                                  \
>>>        { SYS_DESC(SYS_DBGBVRn_EL1(n)),                                 \
>>> @@ -2147,8 +2192,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>>        { SYS_DESC(SYS_CTR_EL0), access_ctr },
>>>        { SYS_DESC(SYS_SVCR), undef_access },
>>>
>>> -     { PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
>>> -       .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
>>> +     { PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
>>> +       .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
>>
>> A little confusing, since the PMU_SYS_REG() defines the default
>> visibility which is pmu_visibility can return REG_HIDDEN, the set_user
>> to pmcr will be blocked, how can it being set?
>>
>> Maybe I lose some details.
>>
> pmu_visibility() returns REG_HIDDEN only if userspace has not added
> support for PMUv3 via KVM_ARM_PREFERRED_TARGET ioctl. Else, it should
> return 0, and give access.
> 

Got it. Thanks.

> Thank you.
> Raghavendra
> 
>> Thanks,
>> Shaoqin
>>
>>>        { PMU_SYS_REG(PMCNTENSET_EL0),
>>>          .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
>>>        { PMU_SYS_REG(PMCNTENCLR_EL0),
>>
>> --
>> Shaoqin
>>
> 

-- 
Shaoqin

