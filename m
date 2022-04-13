Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395E34FED5E
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 05:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiDMDNU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 23:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiDMDNQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 23:13:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 74BF9424BD
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 20:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649819454;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d/E8sODF5KkKF51xjTe8pUp1XC3ON6zwSSW28Lw3IVg=;
        b=ZxKp4AqjTP9mjd12fKrbqqh7PdB69UMxSQaGyUoKc/LQGMOt3FSCS1SMLi+SRgf15RVb7d
        V0V3NqHVM3lsZa+5XPzHfdsL1/RWhgEpYi7qCkF03+jFLvENkSF1BKjQlyKIRkWAo6supD
        T5H9ezJl6+tN54k5Cs9/dpiTQGx60DY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-P084io5RPQ-AfGHw1NSHWA-1; Tue, 12 Apr 2022 23:10:50 -0400
X-MC-Unique: P084io5RPQ-AfGHw1NSHWA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A68401C068DC;
        Wed, 13 Apr 2022 03:10:49 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DAA28814B;
        Wed, 13 Apr 2022 03:10:29 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 01/10] KVM: arm64: Factor out firmware register
 handling from psci.c
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20220407011605.1966778-1-rananta@google.com>
 <20220407011605.1966778-2-rananta@google.com>
 <6797f003-85f2-d1af-c106-c17091268a55@redhat.com>
 <CAJHc60x82Az_NeiCmPznp6aidT5ER=Gud=KfZQ07mD5w7So8cA@mail.gmail.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <2b28ed53-8564-482e-992f-abc47a6c2954@redhat.com>
Date:   Wed, 13 Apr 2022 11:10:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <CAJHc60x82Az_NeiCmPznp6aidT5ER=Gud=KfZQ07mD5w7So8cA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On 4/13/22 12:41 AM, Raghavendra Rao Ananta wrote:
> On Tue, Apr 12, 2022 at 12:07 AM Gavin Shan <gshan@redhat.com> wrote:
>> On 4/7/22 9:15 AM, Raghavendra Rao Ananta wrote:
>>> Common hypercall firmware register handing is currently employed
>>> by psci.c. Since the upcoming patches add more of these registers,
>>> it's better to move the generic handling to hypercall.c for a
>>> cleaner presentation.
>>>
>>> While we are at it, collect all the firmware registers under
>>> fw_reg_ids[] to help implement kvm_arm_get_fw_num_regs() and
>>> kvm_arm_copy_fw_reg_indices() in a generic way. Also, define
>>> KVM_REG_FEATURE_LEVEL_MASK using a GENMASK instead.
>>>
>>> No functional change intended.
>>>
>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>> Reviewed-by: Oliver Upton <oupton@google.com>
>>> ---
>>>    arch/arm64/kvm/guest.c       |   2 +-
>>>    arch/arm64/kvm/hypercalls.c  | 185 +++++++++++++++++++++++++++++++++++
>>>    arch/arm64/kvm/psci.c        | 183 ----------------------------------
>>>    include/kvm/arm_hypercalls.h |   7 ++
>>>    include/kvm/arm_psci.h       |   7 --
>>>    5 files changed, 193 insertions(+), 191 deletions(-)
>>>
>>
>> Apart from the below nits:
>>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>
>>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>>> index 7e15b03fbdf8..0d5cca56cbda 100644
>>> --- a/arch/arm64/kvm/guest.c
>>> +++ b/arch/arm64/kvm/guest.c
>>> @@ -18,7 +18,7 @@
>>>    #include <linux/string.h>
>>>    #include <linux/vmalloc.h>
>>>    #include <linux/fs.h>
>>> -#include <kvm/arm_psci.h>
>>> +#include <kvm/arm_hypercalls.h>
>>>    #include <asm/cputype.h>
>>>    #include <linux/uaccess.h>
>>>    #include <asm/fpsimd.h>
>>> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
>>> index 202b8c455724..fa6d9378d8e7 100644
>>> --- a/arch/arm64/kvm/hypercalls.c
>>> +++ b/arch/arm64/kvm/hypercalls.c
>>> @@ -158,3 +158,188 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>        smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>>>        return 1;
>>>    }
>>> +
>>> +static const u64 kvm_arm_fw_reg_ids[] = {
>>> +     KVM_REG_ARM_PSCI_VERSION,
>>> +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
>>> +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>>> +     KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
>>> +};
>>> +
>>> +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>>> +{
>>> +     return ARRAY_SIZE(kvm_arm_fw_reg_ids);
>>> +}
>>> +
>>> +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>>> +{
>>> +     int i;
>>> +
>>> +     for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
>>> +             if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
>>> +                     return -EFAULT;
>>> +     }
>>> +
>>> +     return 0;
>>> +}
>>> +
>>
>> Since we're here, I think we can make this function to return 'ARRAY_SIZE(kvm_arm_fw_reg_ids)',
>> to be consistent with copy_{core, sve}_reg_indices(). With the return value fixed, additional
>> patch can use @ret in kvm_arm_copy_reg_indices().
>>
> Well we can, however, since this is mostly refactoring, I didn't want
> to change the original functionality of the code.
> The only caller of this is kvm_arm_copy_reg_indices()
> (arch/arm64/kvm/guest.c), which only checks for 'ret < 0'.
> Also, do you have a need for it? If yes, I can change it in the next revision.
> 

The current implementation isn't wrong. With the return value fixed,
The individual snippets in kvm_arm_copy_reg_indices() looks similar.
It's not a big deal. If you plan to fix the return value for
kvm_arm_copy_fw_reg_indices() and copy_timer_indices(), a separate
patch can make the changes before this patch [v5 01/10]. Or we
can ignore this and fix it after this series is merged :)

>>> +#define KVM_REG_FEATURE_LEVEL_WIDTH  4
>>> +#define KVM_REG_FEATURE_LEVEL_MASK   GENMASK(KVM_REG_FEATURE_LEVEL_WIDTH, 0)
>>> +
>>
>> It seems 'BIT()' is replaced with 'GENMASK' in the movement, but it's not mentioned
>> in the commit log. I guess it'd better to mention it if you agree.
>>
> The last sentence of the commit text mentions this :)
> Please let me know if it's not clear.
> 

Exactly and it's clear. Sorry that I missed it :)

>>> +/*
>>> + * Convert the workaround level into an easy-to-compare number, where higher
>>> + * values mean better protection.
>>> + */
>>> +static int get_kernel_wa_level(u64 regid)
>>> +{
>>> +     switch (regid) {
>>> +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
>>> +             switch (arm64_get_spectre_v2_state()) {
>>> +             case SPECTRE_VULNERABLE:
>>> +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
>>> +             case SPECTRE_MITIGATED:
>>> +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
>>> +             case SPECTRE_UNAFFECTED:
>>> +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
>>> +             }
>>> +             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
>>> +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
>>> +             switch (arm64_get_spectre_v4_state()) {
>>> +             case SPECTRE_MITIGATED:
>>> +                     /*
>>> +                      * As for the hypercall discovery, we pretend we
>>> +                      * don't have any FW mitigation if SSBS is there at
>>> +                      * all times.
>>> +                      */
>>> +                     if (cpus_have_final_cap(ARM64_SSBS))
>>> +                             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
>>> +                     fallthrough;
>>> +             case SPECTRE_UNAFFECTED:
>>> +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
>>> +             case SPECTRE_VULNERABLE:
>>> +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
>>> +             }
>>> +             break;
>>> +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
>>> +             switch (arm64_get_spectre_bhb_state()) {
>>> +             case SPECTRE_VULNERABLE:
>>> +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
>>> +             case SPECTRE_MITIGATED:
>>> +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL;
>>> +             case SPECTRE_UNAFFECTED:
>>> +                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED;
>>> +             }
>>> +             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
>>> +     }
>>> +
>>> +     return -EINVAL;
>>> +}
>>> +
>>> +int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>> +{
>>> +     void __user *uaddr = (void __user *)(long)reg->addr;
>>> +     u64 val;
>>> +
>>> +     switch (reg->id) {
>>> +     case KVM_REG_ARM_PSCI_VERSION:
>>> +             val = kvm_psci_version(vcpu);
>>> +             break;
>>> +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
>>> +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
>>> +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
>>> +             val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
>>> +             break;
>>> +     default:
>>> +             return -ENOENT;
>>> +     }
>>> +
>>> +     if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
>>> +             return -EFAULT;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>> +{
>>> +     void __user *uaddr = (void __user *)(long)reg->addr;
>>> +     u64 val;
>>> +     int wa_level;
>>> +
>>> +     if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
>>> +             return -EFAULT;
>>> +
>>> +     switch (reg->id) {
>>> +     case KVM_REG_ARM_PSCI_VERSION:
>>> +     {
>>> +             bool wants_02;
>>> +
>>> +             wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
>>> +
>>> +             switch (val) {
>>> +             case KVM_ARM_PSCI_0_1:
>>> +                     if (wants_02)
>>> +                             return -EINVAL;
>>> +                     vcpu->kvm->arch.psci_version = val;
>>> +                     return 0;
>>> +             case KVM_ARM_PSCI_0_2:
>>> +             case KVM_ARM_PSCI_1_0:
>>> +             case KVM_ARM_PSCI_1_1:
>>> +                     if (!wants_02)
>>> +                             return -EINVAL;
>>> +                     vcpu->kvm->arch.psci_version = val;
>>> +                     return 0;
>>> +             }
>>> +             break;
>>> +     }
>>> +
>>> +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
>>> +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
>>> +             if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
>>> +                     return -EINVAL;
>>> +
>>> +             if (get_kernel_wa_level(reg->id) < val)
>>> +                     return -EINVAL;
>>> +
>>> +             return 0;
>>> +
>>> +     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
>>> +             if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
>>> +                         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
>>> +                     return -EINVAL;
>>> +
>>> +             /* The enabled bit must not be set unless the level is AVAIL. */
>>> +             if ((val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED) &&
>>> +                 (val & KVM_REG_FEATURE_LEVEL_MASK) != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL)
>>> +                     return -EINVAL;
>>> +
>>> +             /*
>>> +              * Map all the possible incoming states to the only two we
>>> +              * really want to deal with.
>>> +              */
>>> +             switch (val & KVM_REG_FEATURE_LEVEL_MASK) {
>>> +             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL:
>>> +             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN:
>>> +                     wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
>>> +                     break;
>>> +             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
>>> +             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
>>> +                     wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
>>> +                     break;
>>> +             default:
>>> +                     return -EINVAL;
>>> +             }
>>> +
>>> +             /*
>>> +              * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
>>> +              * other way around.
>>> +              */
>>> +             if (get_kernel_wa_level(reg->id) < wa_level)
>>> +                     return -EINVAL;
>>> +
>>> +             return 0;
>>> +     default:
>>> +             return -ENOENT;
>>> +     }
>>> +
>>> +     return -EINVAL;
>>> +}
>>> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
>>> index 372da09a2fab..bdfa93ca57d1 100644
>>> --- a/arch/arm64/kvm/psci.c
>>> +++ b/arch/arm64/kvm/psci.c
>>> @@ -439,186 +439,3 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
>>>                return -EINVAL;
>>>        }
>>>    }
>>> -
>>> -int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>>> -{
>>> -     return 4;               /* PSCI version and three workaround registers */
>>> -}
>>> -
>>> -int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
>>> -{
>>> -     if (put_user(KVM_REG_ARM_PSCI_VERSION, uindices++))
>>> -             return -EFAULT;
>>> -
>>> -     if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1, uindices++))
>>> -             return -EFAULT;
>>> -
>>> -     if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2, uindices++))
>>> -             return -EFAULT;
>>> -
>>> -     if (put_user(KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3, uindices++))
>>> -             return -EFAULT;
>>> -
>>> -     return 0;
>>> -}
>>> -
>>> -#define KVM_REG_FEATURE_LEVEL_WIDTH  4
>>> -#define KVM_REG_FEATURE_LEVEL_MASK   (BIT(KVM_REG_FEATURE_LEVEL_WIDTH) - 1)
>>> -
>>> -/*
>>> - * Convert the workaround level into an easy-to-compare number, where higher
>>> - * values mean better protection.
>>> - */
>>> -static int get_kernel_wa_level(u64 regid)
>>> -{
>>> -     switch (regid) {
>>> -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
>>> -             switch (arm64_get_spectre_v2_state()) {
>>> -             case SPECTRE_VULNERABLE:
>>> -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
>>> -             case SPECTRE_MITIGATED:
>>> -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL;
>>> -             case SPECTRE_UNAFFECTED:
>>> -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED;
>>> -             }
>>> -             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL;
>>> -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
>>> -             switch (arm64_get_spectre_v4_state()) {
>>> -             case SPECTRE_MITIGATED:
>>> -                     /*
>>> -                      * As for the hypercall discovery, we pretend we
>>> -                      * don't have any FW mitigation if SSBS is there at
>>> -                      * all times.
>>> -                      */
>>> -                     if (cpus_have_final_cap(ARM64_SSBS))
>>> -                             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
>>> -                     fallthrough;
>>> -             case SPECTRE_UNAFFECTED:
>>> -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
>>> -             case SPECTRE_VULNERABLE:
>>> -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
>>> -             }
>>> -             break;
>>> -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
>>> -             switch (arm64_get_spectre_bhb_state()) {
>>> -             case SPECTRE_VULNERABLE:
>>> -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
>>> -             case SPECTRE_MITIGATED:
>>> -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_AVAIL;
>>> -             case SPECTRE_UNAFFECTED:
>>> -                     return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_REQUIRED;
>>> -             }
>>> -             return KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3_NOT_AVAIL;
>>> -     }
>>> -
>>> -     return -EINVAL;
>>> -}
>>> -
>>> -int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>> -{
>>> -     void __user *uaddr = (void __user *)(long)reg->addr;
>>> -     u64 val;
>>> -
>>> -     switch (reg->id) {
>>> -     case KVM_REG_ARM_PSCI_VERSION:
>>> -             val = kvm_psci_version(vcpu);
>>> -             break;
>>> -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
>>> -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
>>> -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
>>> -             val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
>>> -             break;
>>> -     default:
>>> -             return -ENOENT;
>>> -     }
>>> -
>>> -     if (copy_to_user(uaddr, &val, KVM_REG_SIZE(reg->id)))
>>> -             return -EFAULT;
>>> -
>>> -     return 0;
>>> -}
>>> -
>>> -int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>>> -{
>>> -     void __user *uaddr = (void __user *)(long)reg->addr;
>>> -     u64 val;
>>> -     int wa_level;
>>> -
>>> -     if (copy_from_user(&val, uaddr, KVM_REG_SIZE(reg->id)))
>>> -             return -EFAULT;
>>> -
>>> -     switch (reg->id) {
>>> -     case KVM_REG_ARM_PSCI_VERSION:
>>> -     {
>>> -             bool wants_02;
>>> -
>>> -             wants_02 = test_bit(KVM_ARM_VCPU_PSCI_0_2, vcpu->arch.features);
>>> -
>>> -             switch (val) {
>>> -             case KVM_ARM_PSCI_0_1:
>>> -                     if (wants_02)
>>> -                             return -EINVAL;
>>> -                     vcpu->kvm->arch.psci_version = val;
>>> -                     return 0;
>>> -             case KVM_ARM_PSCI_0_2:
>>> -             case KVM_ARM_PSCI_1_0:
>>> -             case KVM_ARM_PSCI_1_1:
>>> -                     if (!wants_02)
>>> -                             return -EINVAL;
>>> -                     vcpu->kvm->arch.psci_version = val;
>>> -                     return 0;
>>> -             }
>>> -             break;
>>> -     }
>>> -
>>> -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
>>> -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
>>> -             if (val & ~KVM_REG_FEATURE_LEVEL_MASK)
>>> -                     return -EINVAL;
>>> -
>>> -             if (get_kernel_wa_level(reg->id) < val)
>>> -                     return -EINVAL;
>>> -
>>> -             return 0;
>>> -
>>> -     case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
>>> -             if (val & ~(KVM_REG_FEATURE_LEVEL_MASK |
>>> -                         KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED))
>>> -                     return -EINVAL;
>>> -
>>> -             /* The enabled bit must not be set unless the level is AVAIL. */
>>> -             if ((val & KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED) &&
>>> -                 (val & KVM_REG_FEATURE_LEVEL_MASK) != KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL)
>>> -                     return -EINVAL;
>>> -
>>> -             /*
>>> -              * Map all the possible incoming states to the only two we
>>> -              * really want to deal with.
>>> -              */
>>> -             switch (val & KVM_REG_FEATURE_LEVEL_MASK) {
>>> -             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL:
>>> -             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN:
>>> -                     wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL;
>>> -                     break;
>>> -             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL:
>>> -             case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED:
>>> -                     wa_level = KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_REQUIRED;
>>> -                     break;
>>> -             default:
>>> -                     return -EINVAL;
>>> -             }
>>> -
>>> -             /*
>>> -              * We can deal with NOT_AVAIL on NOT_REQUIRED, but not the
>>> -              * other way around.
>>> -              */
>>> -             if (get_kernel_wa_level(reg->id) < wa_level)
>>> -                     return -EINVAL;
>>> -
>>> -             return 0;
>>> -     default:
>>> -             return -ENOENT;
>>> -     }
>>> -
>>> -     return -EINVAL;
>>> -}
>>> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
>>> index 0e2509d27910..5d38628a8d04 100644
>>> --- a/include/kvm/arm_hypercalls.h
>>> +++ b/include/kvm/arm_hypercalls.h
>>> @@ -40,4 +40,11 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
>>>        vcpu_set_reg(vcpu, 3, a3);
>>>    }
>>>
>>> +struct kvm_one_reg;
>>> +
>>> +int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
>>> +int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
>>> +int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>>> +int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>>> +
>>>    #endif
>>> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
>>> index 68b96c3826c3..6e55b9283789 100644
>>> --- a/include/kvm/arm_psci.h
>>> +++ b/include/kvm/arm_psci.h
>>> @@ -39,11 +39,4 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
>>>
>>>    int kvm_psci_call(struct kvm_vcpu *vcpu);
>>>
>>> -struct kvm_one_reg;
>>> -
>>> -int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
>>> -int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
>>> -int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>>> -int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
>>> -
>>>    #endif /* __KVM_ARM_PSCI_H__ */
>>>
>>

[...]

> Thank you for the review, Gavin.
> 

No worries. The SDEI virtualization series depends on this to
some extent :)

Thanks,
Gavin


