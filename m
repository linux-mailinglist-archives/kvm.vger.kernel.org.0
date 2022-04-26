Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE40750F11E
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 08:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245356AbiDZGhd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 02:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238317AbiDZGha (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 02:37:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89CB0EA369
        for <kvm@vger.kernel.org>; Mon, 25 Apr 2022 23:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650954861;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w4dhiPP8Whq3trW5BVjcRejEN2S0dxMhL+DAIMdhf2A=;
        b=h8b3e8OA9cNECEEGL6aQkS1GfuKHu3gasF1vZDCWTlk4qw+wrEejm86tJFzLa0s6CUwyX2
        GfnimelmM8i0tch9PBTYkj4Y3Ckf9yB9GxCkwS2jASq2H0+SjIYYonIeOcXEcfaJafDMoK
        KbGdl2W2n/hJ/z2a+/ogqkSPg6NgN0g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231--WPk7TroOxmY3SBkONy8Rw-1; Tue, 26 Apr 2022 02:34:16 -0400
X-MC-Unique: -WPk7TroOxmY3SBkONy8Rw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4B73B1014A6E;
        Tue, 26 Apr 2022 06:33:34 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48A5D4047D0A;
        Tue, 26 Apr 2022 06:33:10 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v6 2/9] KVM: arm64: Setup a framework for hypercall bitmap
 firmware registers
To:     Raghavendra Rao Ananta <rananta@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Cc:     kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
References: <20220423000328.2103733-1-rananta@google.com>
 <20220423000328.2103733-3-rananta@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <bbaf7dcf-e776-49df-7a12-04b45e4af881@redhat.com>
Date:   Tue, 26 Apr 2022 14:33:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20220423000328.2103733-3-rananta@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Raghavendra,

On 4/23/22 8:03 AM, Raghavendra Rao Ananta wrote:
> KVM regularly introduces new hypercall services to the guests without
> any consent from the userspace. This means, the guests can observe
> hypercall services in and out as they migrate across various host
> kernel versions. This could be a major problem if the guest
> discovered a hypercall, started using it, and after getting migrated
> to an older kernel realizes that it's no longer available. Depending
> on how the guest handles the change, there's a potential chance that
> the guest would just panic.
> 
> As a result, there's a need for the userspace to elect the services
> that it wishes the guest to discover. It can elect these services
> based on the kernels spread across its (migration) fleet. To remedy
> this, extend the existing firmware pseudo-registers, such as
> KVM_REG_ARM_PSCI_VERSION, but by creating a new COPROC register space
> for all the hypercall services available.
> 
> These firmware registers are categorized based on the service call
> owners, but unlike the existing firmware pseudo-registers, they hold
> the features supported in the form of a bitmap.
> 
> During the VM initialization, the registers are set to upper-limit of
> the features supported by the corresponding registers. It's expected
> that the VMMs discover the features provided by each register via
> GET_ONE_REG, and write back the desired values using SET_ONE_REG.
> KVM allows this modification only until the VM has started.
> 
> Some of the standard features are not mapped to any bits of the
> registers. But since they can recreate the original problem of
> making it available without userspace's consent, they need to
> be explicitly added to the case-list in
> kvm_hvc_call_default_allowed(). Any function-id that's not enabled
> via the bitmap, or not listed in kvm_hvc_call_default_allowed, will
> be returned as SMCCC_RET_NOT_SUPPORTED to the guest.
> 
> Older userspace code can simply ignore the feature and the
> hypercall services will be exposed unconditionally to the guests,
> thus ensuring backward compatibility.
> 
> In this patch, the framework adds the register only for ARM's standard
> secure services (owner value 4). Currently, this includes support only
> for ARM True Random Number Generator (TRNG) service, with bit-0 of the
> register representing mandatory features of v1.0. Other services are
> momentarily added in the upcoming patches.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 12 ++++
>   arch/arm64/include/uapi/asm/kvm.h |  9 +++
>   arch/arm64/kvm/arm.c              |  1 +
>   arch/arm64/kvm/guest.c            |  8 ++-
>   arch/arm64/kvm/hypercalls.c       | 94 +++++++++++++++++++++++++++++++
>   arch/arm64/kvm/psci.c             | 13 +++++
>   include/kvm/arm_hypercalls.h      |  6 ++
>   include/kvm/arm_psci.h            |  2 +-
>   8 files changed, 142 insertions(+), 3 deletions(-)
> 

Some nits as below, please consider to improve if you need another
respin.

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 94a27a7520f4..df07f4c10197 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -101,6 +101,15 @@ struct kvm_s2_mmu {
>   struct kvm_arch_memory_slot {
>   };
>   
> +/**
> + * struct kvm_smccc_features: Descriptor the hypercall services exposed to the guests
> + *
> + * @std_bmap: Bitmap of standard secure service calls
> + */
> +struct kvm_smccc_features {
> +	unsigned long std_bmap;
> +};
> +

s/Descriptor/Descriptor of

>   struct kvm_arch {
>   	struct kvm_s2_mmu mmu;
>   
> @@ -150,6 +159,9 @@ struct kvm_arch {
>   
>   	u8 pfr0_csv2;
>   	u8 pfr0_csv3;
> +
> +	/* Hypercall features firmware registers' descriptor */
> +	struct kvm_smccc_features smccc_feat;
>   };
>   
>   struct kvm_vcpu_fault_info {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index c1b6ddc02d2f..0b79d2dc6ffd 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -332,6 +332,15 @@ struct kvm_arm_copy_mte_tags {
>   #define KVM_ARM64_SVE_VLS_WORDS	\
>   	((KVM_ARM64_SVE_VQ_MAX - KVM_ARM64_SVE_VQ_MIN) / 64 + 1)
>   
> +/* Bitmap feature firmware registers */
> +#define KVM_REG_ARM_FW_FEAT_BMAP		(0x0016 << KVM_REG_ARM_COPROC_SHIFT)
> +#define KVM_REG_ARM_FW_FEAT_BMAP_REG(r)		(KVM_REG_ARM64 | KVM_REG_SIZE_U64 | \
> +						KVM_REG_ARM_FW_FEAT_BMAP |	\
> +						((r) & 0xffff))
> +
> +#define KVM_REG_ARM_STD_BMAP			KVM_REG_ARM_FW_FEAT_BMAP_REG(0)
> +#define KVM_REG_ARM_STD_BIT_TRNG_V1_0		0
> +
>   /* Device Control API: ARM VGIC */
>   #define KVM_DEV_ARM_VGIC_GRP_ADDR	0
>   #define KVM_DEV_ARM_VGIC_GRP_DIST_REGS	1
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 523bc934fe2f..a37fadbd617e 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -156,6 +156,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	kvm->arch.max_vcpus = kvm_arm_default_max_vcpus();
>   
>   	set_default_spectre(kvm);
> +	kvm_arm_init_hypercalls(kvm);
>   
>   	return ret;
>   out_free_stage2_pgd:
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 0d5cca56cbda..8c607199cad1 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -756,7 +756,9 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   
>   	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>   	case KVM_REG_ARM_CORE:	return get_core_reg(vcpu, reg);
> -	case KVM_REG_ARM_FW:	return kvm_arm_get_fw_reg(vcpu, reg);
> +	case KVM_REG_ARM_FW:
> +	case KVM_REG_ARM_FW_FEAT_BMAP:
> +		return kvm_arm_get_fw_reg(vcpu, reg);
>   	case KVM_REG_ARM64_SVE:	return get_sve_reg(vcpu, reg);
>   	}
>   
> @@ -774,7 +776,9 @@ int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   
>   	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
>   	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
> -	case KVM_REG_ARM_FW:	return kvm_arm_set_fw_reg(vcpu, reg);
> +	case KVM_REG_ARM_FW:
> +	case KVM_REG_ARM_FW_FEAT_BMAP:
> +		return kvm_arm_set_fw_reg(vcpu, reg);
>   	case KVM_REG_ARM64_SVE:	return set_sve_reg(vcpu, reg);
>   	}
>   
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index fa6d9378d8e7..df55a04d2fe8 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -58,6 +58,48 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
>   	val[3] = lower_32_bits(cycles);
>   }
>   
> +static bool kvm_arm_fw_reg_feat_enabled(unsigned long *reg_bmap, unsigned long feat_bit)
> +{
> +	return test_bit(feat_bit, reg_bmap);
> +}
> +

Might be worhty to be 'inline'. This function would be called
frequently.

> +static bool kvm_hvc_call_default_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> +{
> +	switch (func_id) {
> +	/*
> +	 * List of function-ids that are not gated with the bitmapped feature
> +	 * firmware registers, and are to be allowed for servicing the call by default.
> +	 */
> +	case ARM_SMCCC_VERSION_FUNC_ID:
> +	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
> +	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> +	case ARM_SMCCC_HV_PV_TIME_ST:
> +	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
> +	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +		return true;
> +	default:
> +		return kvm_psci_func_id_is_valid(vcpu, func_id);
> +	}
> +}
> +
> +static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
> +{
> +	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
> +
> +	switch (func_id) {
> +	case ARM_SMCCC_TRNG_VERSION:
> +	case ARM_SMCCC_TRNG_FEATURES:
> +	case ARM_SMCCC_TRNG_GET_UUID:
> +	case ARM_SMCCC_TRNG_RND32:
> +	case ARM_SMCCC_TRNG_RND64:
> +		return kvm_arm_fw_reg_feat_enabled(&smccc_feat->std_bmap,
> +						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> +	default:
> +		return kvm_hvc_call_default_allowed(vcpu, func_id);
> +	}
> +}
> +
>   int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   {
>   	u32 func_id = smccc_get_function(vcpu);
> @@ -65,6 +107,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   	u32 feature;
>   	gpa_t gpa;
>   
> +	if (!kvm_hvc_call_allowed(vcpu, func_id))
> +		goto out;
> +
>   	switch (func_id) {
>   	case ARM_SMCCC_VERSION_FUNC_ID:
>   		val[0] = ARM_SMCCC_VERSION_1_1;
> @@ -155,6 +200,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>   		return kvm_psci_call(vcpu);
>   	}
>   
> +out:
>   	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
>   	return 1;
>   }
> @@ -164,8 +210,16 @@ static const u64 kvm_arm_fw_reg_ids[] = {
>   	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
>   	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>   	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3,
> +	KVM_REG_ARM_STD_BMAP,
>   };
>   
> +void kvm_arm_init_hypercalls(struct kvm *kvm)
> +{
> +	struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> +
> +	smccc_feat->std_bmap = KVM_ARM_SMCCC_STD_FEATURES;
> +}
> +
>   int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
>   {
>   	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
> @@ -237,6 +291,7 @@ static int get_kernel_wa_level(u64 regid)
>   
>   int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   {
> +	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
>   	void __user *uaddr = (void __user *)(long)reg->addr;
>   	u64 val;
>   
> @@ -249,6 +304,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	case KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_3:
>   		val = get_kernel_wa_level(reg->id) & KVM_REG_FEATURE_LEVEL_MASK;
>   		break;
> +	case KVM_REG_ARM_STD_BMAP:
> +		val = READ_ONCE(smccc_feat->std_bmap);
> +		break;
>   	default:
>   		return -ENOENT;
>   	}
> @@ -259,6 +317,40 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   	return 0;
>   }
>   
> +static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
> +{
> +	int ret = 0;
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_smccc_features *smccc_feat = &kvm->arch.smccc_feat;
> +	unsigned long *fw_reg_bmap, fw_reg_features;
> +
> +	switch (reg_id) {
> +	case KVM_REG_ARM_STD_BMAP:
> +		fw_reg_bmap = &smccc_feat->std_bmap;
> +		fw_reg_features = KVM_ARM_SMCCC_STD_FEATURES;
> +		break;
> +	default:
> +		return -ENOENT;
> +	}
> +
> +	/* Check for unsupported bit */
> +	if (val & ~fw_reg_features)
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	/* Return -EBUSY if the VM (any vCPU) has already started running. */
> +	if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &kvm->arch.flags)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	WRITE_ONCE(*fw_reg_bmap, val);
> +out:
> +	mutex_unlock(&kvm->lock);
> +	return ret;
> +}
> +
>   int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   {
>   	void __user *uaddr = (void __user *)(long)reg->addr;
> @@ -337,6 +429,8 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>   			return -EINVAL;
>   
>   		return 0;
> +	case KVM_REG_ARM_STD_BMAP:
> +		return kvm_arm_set_fw_reg_bmap(vcpu, reg->id, val);
>   	default:
>   		return -ENOENT;
>   	}
> diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
> index 346535169faa..67d1273e8086 100644
> --- a/arch/arm64/kvm/psci.c
> +++ b/arch/arm64/kvm/psci.c
> @@ -436,3 +436,16 @@ int kvm_psci_call(struct kvm_vcpu *vcpu)
>   		return -EINVAL;
>   	}
>   }
> +
> +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id)
> +{
> +	/* PSCI 0.1 doesn't comply with the standard SMCCC */
> +	if (kvm_psci_version(vcpu) == KVM_ARM_PSCI_0_1)
> +		return (func_id == KVM_PSCI_FN_CPU_OFF || func_id == KVM_PSCI_FN_CPU_ON);
> +
> +	if (ARM_SMCCC_OWNER_NUM(func_id) == ARM_SMCCC_OWNER_STANDARD &&
> +		ARM_SMCCC_FUNC_NUM(func_id) >= 0 && ARM_SMCCC_FUNC_NUM(func_id) <= 0x1f)
> +		return true;
> +
> +	return false;
> +}
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 5d38628a8d04..499b45b607b6 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -6,6 +6,11 @@
>   
>   #include <asm/kvm_emulate.h>
>   
> +/* Last valid bits of the bitmapped firmware registers */
> +#define KVM_REG_ARM_STD_BMAP_BIT_MAX		0
> +
> +#define KVM_ARM_SMCCC_STD_FEATURES		GENMASK(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
> +

s/bits of/bit of

>   int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>   
>   static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> @@ -42,6 +47,7 @@ static inline void smccc_set_retval(struct kvm_vcpu *vcpu,
>   
>   struct kvm_one_reg;
>   
> +void kvm_arm_init_hypercalls(struct kvm *kvm);
>   int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu);
>   int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices);
>   int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg);
> diff --git a/include/kvm/arm_psci.h b/include/kvm/arm_psci.h
> index 6e55b9283789..c47be3e26965 100644
> --- a/include/kvm/arm_psci.h
> +++ b/include/kvm/arm_psci.h
> @@ -36,7 +36,7 @@ static inline int kvm_psci_version(struct kvm_vcpu *vcpu)
>   	return KVM_ARM_PSCI_0_1;
>   }
>   
> -
>   int kvm_psci_call(struct kvm_vcpu *vcpu);
> +bool kvm_psci_func_id_is_valid(struct kvm_vcpu *vcpu, u32 func_id);
>   
>   #endif /* __KVM_ARM_PSCI_H__ */
> 

Thanks,
Gavin

