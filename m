Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D9C4D8CAB
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244184AbiCNTqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244199AbiCNTqk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:46:40 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA993DA79
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:45:29 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id h21so3893363ila.7
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BWFI5h416BXkQSSoLp6it0M+QIIpZiht4kihVcXhZts=;
        b=VZ2cAUX8Ar0g9XwlSwMUsAJFJ+x9WoBP8ZUB6v4eL265wgG+R7Yg+AHG6eBB9s36q+
         acas52nuQwIOC2kAnffOOIPVbaZ9CsbEUqvZ9ubN/y27tiGvuGx7f55KXJCuPs5g4L0B
         Zvb0HwQblFcZjAHSFwulEWa84Nh7s+o1qSje5u9ZWBlI29Mxdd/h0T5AVmH3Ip/J/cEy
         Xo+rB9DWuAhQkC1vuQA0G75aFWpioKs+9NpJ380LPswDKkyS1ZPp/ovsKyUcA4nK5OHs
         6A0Q1xlpuoF+4ZuF3LvkEBES9Z4bFPvPSacHgcHRgM4y8kaKq1fjZcfltW/52aCw2zLF
         tzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BWFI5h416BXkQSSoLp6it0M+QIIpZiht4kihVcXhZts=;
        b=RoK0CbK4Ec9gVVrLIwI54PixubNVCPBYtiJ2KL2+b7rgktu6HKB6/qfEofSBJabwJf
         z7bu5Kyk3esaQTMD/KubZcz+SnCq+xnMNI3Sqqpt9gfReo5kkfF50an8BqZqpUEdFUSy
         zy+qxZjV8JNfbS8RMeYgil3Xp/5w7a7LBdwaPaQ0HG3Ccm0xi7vQwzaOoMAnrnaLFdwk
         F3mY385SyCJ88OuVBo7tnoQ8KcWqG/WPTiol20Z7R15zfk/PyftBGMfrQMq07w0UNLOF
         Gb8ZbAMORJ13pggoi8X/HVgS0E5hHF3wLYHcbNTd13l9zPOX10IKJbleW7SuhCm6MsZZ
         RLaQ==
X-Gm-Message-State: AOAM533w8Z45aedRHol81B+fJaWLQtcTSlnbUJfpoMAMsFqLDDMDYcre
        X+n5z7oZWySm695VQHEJ/EPyhA==
X-Google-Smtp-Source: ABdhPJwQ3i+7pigTCE79ECMNKcgYpSK4txWbWXeonLwGpNYGsyXDVr849fLZJT/ZuycgWpgB3cB76g==
X-Received: by 2002:a05:6e02:1a2c:b0:2c7:89cb:6bc8 with SMTP id g12-20020a056e021a2c00b002c789cb6bc8mr11174471ile.236.1647287128338;
        Mon, 14 Mar 2022 12:45:28 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id c6-20020a056e020bc600b002c6731e7cb8sm9091010ilu.31.2022.03.14.12.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 12:45:27 -0700 (PDT)
Date:   Mon, 14 Mar 2022 19:45:24 +0000
From:   Oliver Upton <oupton@google.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Andrew Jones <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 06/13] KVM: arm64: Add standard hypervisor firmware
 register
Message-ID: <Yi+bVM742+9W4TYj@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-7-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-7-rananta@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 05:25:52PM +0000, Raghavendra Rao Ananta wrote:
> Introduce the firmware register to hold the standard hypervisor
> service calls (owner value 5) as a bitmap. The bitmap represents
> the features that'll be enabled for the guest, as configured by
> the user-space. Currently, this includes support only for
> Paravirtualized time, represented by bit-0.
> 
> The register is also added to the kvm_arm_vm_scope_fw_regs[] list
> as it maintains its state per-VM.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
>  arch/arm64/kvm/guest.c            |  1 +
>  arch/arm64/kvm/hypercalls.c       | 20 +++++++++++++++++++-
>  include/kvm/arm_hypercalls.h      |  3 +++
>  5 files changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1909ced3208f..318148b69279 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -105,9 +105,11 @@ struct kvm_arch_memory_slot {
>   * struct kvm_hvc_desc: KVM ARM64 hypercall descriptor
>   *
>   * @hvc_std_bmap: Bitmap of standard secure service calls
> + * @hvc_std_hyp_bmap: Bitmap of standard hypervisor service calls
>   */
>  struct kvm_hvc_desc {
>  	u64 hvc_std_bmap;
> +	u64 hvc_std_hyp_bmap;
>  };
>  
>  struct kvm_arch {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 2decc30d6b84..9a2caead7359 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -295,6 +295,10 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_REG_ARM_STD_BIT_TRNG_V1_0		BIT(0)
>  #define KVM_REG_ARM_STD_BMAP_BIT_MAX		0       /* Last valid bit */
>  
> +#define KVM_REG_ARM_STD_HYP_BMAP		KVM_REG_ARM_FW_BMAP_REG(1)
> +#define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
> +#define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0       /* Last valid bit */
> +
>  /* SVE registers */
>  #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
>  
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index d66e6c742bbe..c42426d6137e 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -66,6 +66,7 @@ static const u64 kvm_arm_vm_scope_fw_regs[] = {
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>  	KVM_REG_ARM_STD_BMAP,
> +	KVM_REG_ARM_STD_HYP_BMAP,
>  };
>  
>  /**
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index 48c126c3da72..ebc0cc26cf2e 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -75,6 +75,10 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
>  	case ARM_SMCCC_TRNG_RND64:
>  		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_bmap,
>  						KVM_REG_ARM_STD_BIT_TRNG_V1_0);
> +	case ARM_SMCCC_HV_PV_TIME_FEATURES:
> +	case ARM_SMCCC_HV_PV_TIME_ST:
> +		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_hyp_bmap,
> +					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
>  	default:
>  		/* By default, allow the services that aren't listed here */
>  		return true;
> @@ -83,6 +87,7 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
>  
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  {
> +	struct kvm_hvc_desc *hvc_desc = &vcpu->kvm->arch.hvc_desc;
>  	u32 func_id = smccc_get_function(vcpu);
>  	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
>  	u32 feature;
> @@ -134,7 +139,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  			}
>  			break;
>  		case ARM_SMCCC_HV_PV_TIME_FEATURES:
> -			val[0] = SMCCC_RET_SUCCESS;
> +			if (kvm_arm_fw_reg_feat_enabled(
> +					hvc_desc->hvc_std_hyp_bmap,

It is probably OK to keep this parameter on the line above (just stay
under 100 characters a line).

> +					KVM_REG_ARM_STD_HYP_BIT_PV_TIME))
> +				val[0] = SMCCC_RET_SUCCESS;
>  			break;
>  		}
>  		break;
> @@ -179,6 +187,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1,
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>  	KVM_REG_ARM_STD_BMAP,
> +	KVM_REG_ARM_STD_HYP_BMAP,
>  };
>  
>  void kvm_arm_init_hypercalls(struct kvm *kvm)
> @@ -186,6 +195,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
>  	struct kvm_hvc_desc *hvc_desc = &kvm->arch.hvc_desc;
>  
>  	hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
> +	hvc_desc->hvc_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
>  }
>  
>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> @@ -272,6 +282,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	case KVM_REG_ARM_STD_BMAP:
>  		val = READ_ONCE(hvc_desc->hvc_std_bmap);
>  		break;
> +	case KVM_REG_ARM_STD_HYP_BMAP:
> +		val = READ_ONCE(hvc_desc->hvc_std_hyp_bmap);
> +		break;
>  	default:
>  		return -ENOENT;
>  	}
> @@ -294,6 +307,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
>  		fw_reg_bmap = &hvc_desc->hvc_std_bmap;
>  		fw_reg_features = ARM_SMCCC_STD_FEATURES;
>  		break;
> +	case KVM_REG_ARM_STD_HYP_BMAP:
> +		fw_reg_bmap = &hvc_desc->hvc_std_hyp_bmap;
> +		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
> +		break;
>  	default:
>  		return -ENOENT;
>  	}
> @@ -398,6 +415,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  
>  		return 0;
>  	case KVM_REG_ARM_STD_BMAP:
> +	case KVM_REG_ARM_STD_HYP_BMAP:
>  		return kvm_arm_set_fw_reg_bmap(vcpu, reg_id, val);
>  	default:
>  		return -ENOENT;
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index 64d30b452809..a1cb6e839c74 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -9,6 +9,9 @@
>  #define ARM_SMCCC_STD_FEATURES \
>  	GENMASK_ULL(KVM_REG_ARM_STD_BMAP_BIT_MAX, 0)
>  
> +#define ARM_SMCCC_STD_HYP_FEATURES \
> +	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>  
>  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
