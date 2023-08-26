Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5EE789382
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 04:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbjHZClb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 22:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231766AbjHZClX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 22:41:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E21F269F
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 19:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693017636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6J2d/6ucs55iHF4wv09A97r3+xoxjcihY+TOMGOHcY4=;
        b=ExXC0hD91qzXrWBwqPARjv4OzcOHtxvKiYTUWZb9jzcwn9LqX5xBlxzixDck4xQy84H2xu
        tbN8k+LQED/MdJX4y7ld4VlsTuCg5gl92g5o8ESkcLlGGegCF3I4EIRsbZ9/cQ5vr+DCJT
        cTBp2mpEDEZAG4Pe6sfFiGbOpSk/dHQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-F2ZwauVTN2yco8qBJZPW_g-1; Fri, 25 Aug 2023 22:40:34 -0400
X-MC-Unique: F2ZwauVTN2yco8qBJZPW_g-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1bf43b0131cso3962295ad.0
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 19:40:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693017632; x=1693622432;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6J2d/6ucs55iHF4wv09A97r3+xoxjcihY+TOMGOHcY4=;
        b=D1ZrDoezicmL4xWRGkC+WG9Hc5xuNggiZLljnUamMDuVmTgyNDmXvxKxiC5SlMxgRv
         r0DwoCvJhsWzg+Hy/AX7P84ocUuRGG2gQ77AY4sK8pa3CgVNBEzBEbr85+RT7z59QYjn
         guitoPlL9X8l6z7G+TCCSBZgQI/8lNNTSky6os2vJIpjtqLlE59keJ5xWRuBE4Qez+KV
         Woggm4hDfwqgca1A2mg0vJjC5HnPUYZEsow2lHGiJMp0zgELuHG+vNAIwCOksOxfAmAE
         Re++B046e6qTRYCbl5JEA+5408+wDgnPM9NrvJ4VTuVQJcKC+fr+bqXcNTMqUgeovGE2
         tVtQ==
X-Gm-Message-State: AOJu0YzsHU2xogfTHOJ8s0O7k1m4n2iEL7Ta+SXRn6zxCgKq0YxHim5H
        nlDq4zEvxac0L2RJjVSpBlksk95vHGKZJ4RmwpCJy3u8hXwy7zG4ZVL7g2gNH9SKr+NY/VIjYrn
        Mgi7RXajRxJ5E
X-Received: by 2002:a17:903:230c:b0:1bb:ac37:384b with SMTP id d12-20020a170903230c00b001bbac37384bmr22549056plh.6.1693017632500;
        Fri, 25 Aug 2023 19:40:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH0ABPCrrzcKML1YBEVGaqQK6gmek61xmaO7dOSVK58UrEmzdH9+LLcPYV32k6jneAwL8fHkA==
X-Received: by 2002:a17:903:230c:b0:1bb:ac37:384b with SMTP id d12-20020a170903230c00b001bbac37384bmr22549037plh.6.1693017632090;
        Fri, 25 Aug 2023 19:40:32 -0700 (PDT)
Received: from [10.72.112.57] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id iz15-20020a170902ef8f00b001bc6fe1b9absm2472399plb.276.2023.08.25.19.40.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Aug 2023 19:40:31 -0700 (PDT)
Message-ID: <82689ad4-5e68-b882-4fbe-aaf564e1e358@redhat.com>
Date:   Sat, 26 Aug 2023 10:40:26 +0800
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
 <1c6c07af-f6d0-89a6-1b7d-164ca100ac88@redhat.com>
 <CAJHc60x=rZTpeJ3PDUWmc08Aziow6S+2nndcL90vHfru5GhXtA@mail.gmail.com>
 <a0543866-1fac-6a3f-20cd-43b6d1263c0e@redhat.com>
 <CAJHc60z=+LG8kayRzYEZ6rCZuov7zC-nLMmzAabPiPKY5OhSEg@mail.gmail.com>
From:   Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAJHc60z=+LG8kayRzYEZ6rCZuov7zC-nLMmzAabPiPKY5OhSEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/26/23 06:34, Raghavendra Rao Ananta wrote:
> On Thu, Aug 24, 2023 at 1:50 AM Shaoqin Huang <shahuang@redhat.com> wrote:
>>
>>
>>
>> On 8/24/23 00:06, Raghavendra Rao Ananta wrote:
>>> On Tue, Aug 22, 2023 at 3:06 AM Shaoqin Huang <shahuang@redhat.com> wrote:
>>>>
>>>> Hi Raghavendra,
>>>>
>>>> On 8/17/23 08:30, Raghavendra Rao Ananta wrote:
>>>>> From: Reiji Watanabe <reijiw@google.com>
>>>>>
>>>>> KVM does not yet support userspace modifying PMCR_EL0.N (With
>>>>> the previous patch, KVM ignores what is written by upserspace).
>>>>> Add support userspace limiting PMCR_EL0.N.
>>>>>
>>>>> Disallow userspace to set PMCR_EL0.N to a value that is greater
>>>>> than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
>>>>> support more event counters than the host HW implements.
>>>>> Although this is an ABI change, this change only affects
>>>>> userspace setting PMCR_EL0.N to a larger value than the host.
>>>>> As accesses to unadvertised event counters indices is CONSTRAINED
>>>>> UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
>>>>> on every vCPU reset before this series, I can't think of any
>>>>> use case where a user space would do that.
>>>>>
>>>>> Also, ignore writes to read-only bits that are cleared on vCPU reset,
>>>>> and RES{0,1} bits (including writable bits that KVM doesn't support
>>>>> yet), as those bits shouldn't be modified (at least with
>>>>> the current KVM).
>>>>>
>>>>> Signed-off-by: Reiji Watanabe <reijiw@google.com>
>>>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>>>> ---
>>>>>     arch/arm64/include/asm/kvm_host.h |  3 ++
>>>>>     arch/arm64/kvm/pmu-emul.c         |  1 +
>>>>>     arch/arm64/kvm/sys_regs.c         | 49 +++++++++++++++++++++++++++++--
>>>>>     3 files changed, 51 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>>> index 0f2dbbe8f6a7e..c15ec365283d1 100644
>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>> @@ -259,6 +259,9 @@ struct kvm_arch {
>>>>>         /* PMCR_EL0.N value for the guest */
>>>>>         u8 pmcr_n;
>>>>>
>>>>> +     /* Limit value of PMCR_EL0.N for the guest */
>>>>> +     u8 pmcr_n_limit;
>>>>> +
>>>>>         /* Hypercall features firmware registers' descriptor */
>>>>>         struct kvm_smccc_features smccc_feat;
>>>>>         struct maple_tree smccc_filter;
>>>>> diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
>>>>> index ce7de6bbdc967..39ad56a71ad20 100644
>>>>> --- a/arch/arm64/kvm/pmu-emul.c
>>>>> +++ b/arch/arm64/kvm/pmu-emul.c
>>>>> @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
>>>>>          * while the latter does not.
>>>>>          */
>>>>>         kvm->arch.pmcr_n = arm_pmu->num_events - 1;
>>>>> +     kvm->arch.pmcr_n_limit = arm_pmu->num_events - 1;
>>>>>
>>>>>         return 0;
>>>>>     }
>>>>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>>>>> index 2075901356c5b..c01d62afa7db4 100644
>>>>> --- a/arch/arm64/kvm/sys_regs.c
>>>>> +++ b/arch/arm64/kvm/sys_regs.c
>>>>> @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>>>>>         return 0;
>>>>>     }
>>>>>
>>>>> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
>>>>> +                 u64 val)
>>>>> +{
>>>>> +     struct kvm *kvm = vcpu->kvm;
>>>>> +     u64 new_n, mutable_mask;
>>>>> +     int ret = 0;
>>>>> +
>>>>> +     new_n = FIELD_GET(ARMV8_PMU_PMCR_N, val);
>>>>> +
>>>>> +     mutex_lock(&kvm->arch.config_lock);
>>>>> +     if (unlikely(new_n != kvm->arch.pmcr_n)) {
>>>>> +             /*
>>>>> +              * The vCPU can't have more counters than the PMU
>>>>> +              * hardware implements.
>>>>> +              */
>>>>> +             if (new_n <= kvm->arch.pmcr_n_limit)
>>>>> +                     kvm->arch.pmcr_n = new_n;
>>>>> +             else
>>>>> +                     ret = -EINVAL;
>>>>> +     }
>>>>> +     mutex_unlock(&kvm->arch.config_lock);
>>>>
>>>> Another thing I am just wonder is that should we block any modification
>>>> to the pmcr_n after vm start to run? Like add one more checking
>>>> kvm_vm_has_ran_once() at the beginning of the set_pmcr() function.
>>>>
>>> Thanks for bringing it up. Reiji and I discussed about this. Checking
>>> for kvm_vm_has_ran_once() will be a good move, however, it will go
>>> against the ABI expectations of setting the PMCR. I'd like others to
>>> weigh in on this as well. What do you think?
>>>
>>> Thank you.
>>> Raghavendra
>>
>> Before this change, kvm not allowed userspace to change the pmcr_n, but
>> allowed to change the lower ARMV8_PMU_PMCR_MASK bits. With this change,
>> we now allow to change the pmcr_n, we should not block the change to
>> ARMV8_PMU_PMCR_MASK after vm start to run, but how about we just block
>> the change to ARMV8_PMU_PMCR_N after vm start to run?
>>
> I believe you are referring to the guest trap access part of it
> (access_pmcr()). This patch focuses on the userspace access of PMCR
> via the KVM_SET_ONE_REG ioctl. Before this patch, KVM did not control
> the writes to the reg and userspace was free to write to any bits at
> any time.
> 

Oh yeah. Thanks for your explanation. My head sometimes broken down.

Thanks,
Shaoqin

> Thank you.
> Raghavendra
>> Thanks,
>> Shaoqin
>>
>>>> Thanks,
>>>> Shaoqin
>>>>
>>>>> +     if (ret)
>>>>> +             return ret;
>>>>> +
>>>>> +     /*
>>>>> +      * Ignore writes to RES0 bits, read only bits that are cleared on
>>>>> +      * vCPU reset, and writable bits that KVM doesn't support yet.
>>>>> +      * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
>>>>> +      * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the vCPU.
>>>>> +      * But, we leave the bit as it is here, as the vCPU's PMUver might
>>>>> +      * be changed later (NOTE: the bit will be cleared on first vCPU run
>>>>> +      * if necessary).
>>>>> +      */
>>>>> +     mutable_mask = (ARMV8_PMU_PMCR_MASK | ARMV8_PMU_PMCR_N);
>>>>> +     val &= mutable_mask;
>>>>> +     val |= (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
>>>>> +
>>>>> +     /* The LC bit is RES1 when AArch32 is not supported */
>>>>> +     if (!kvm_supports_32bit_el0())
>>>>> +             val |= ARMV8_PMU_PMCR_LC;
>>>>> +
>>>>> +     __vcpu_sys_reg(vcpu, r->reg) = val;
>>>>> +     return 0;
>>>>> +}
>>>>> +
>>>>>     /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
>>>>>     #define DBG_BCR_BVR_WCR_WVR_EL1(n)                                  \
>>>>>         { SYS_DESC(SYS_DBGBVRn_EL1(n)),                                 \
>>>>> @@ -2147,8 +2192,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>>>>>         { SYS_DESC(SYS_CTR_EL0), access_ctr },
>>>>>         { SYS_DESC(SYS_SVCR), undef_access },
>>>>>
>>>>> -     { PMU_SYS_REG(PMCR_EL0), .access = access_pmcr,
>>>>> -       .reset = reset_pmcr, .reg = PMCR_EL0, .get_user = get_pmcr },
>>>>> +     { PMU_SYS_REG(PMCR_EL0), .access = access_pmcr, .reset = reset_pmcr,
>>>>> +       .reg = PMCR_EL0, .get_user = get_pmcr, .set_user = set_pmcr },
>>>>>         { PMU_SYS_REG(PMCNTENSET_EL0),
>>>>>           .access = access_pmcnten, .reg = PMCNTENSET_EL0 },
>>>>>         { PMU_SYS_REG(PMCNTENCLR_EL0),
>>>>
>>>> --
>>>> Shaoqin
>>>>
>>>
>>
>> --
>> Shaoqin
>>
> 

-- 
Shaoqin

