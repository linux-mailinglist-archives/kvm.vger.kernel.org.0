Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9A174D8DA5
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 21:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244804AbiCNUAo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 16:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbiCNUAn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 16:00:43 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194D83EA87
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:59:33 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id d3so11841656ilr.10
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KhNnP/oPOEf+AzAoi7FbFVFnff3zDauVn+R3czZgO30=;
        b=XLvy0a2P3yr/7QgZ7XMz4vy53ApIYN+UaK82GHgDQ3xtEeRMJaOGOuG2NBzVDDsczs
         gElxMFyo00E2THZcl/7wUoIInd0phepsqCVLF4ktfce/OL5We+yjBBwq4+/KbnAKdDs/
         i8i11DhG4zSg8SmvsE6lTDr23OlmYpe8CEYCatPaheYkh6KcW0E8x2Z67gNTMyClFDkF
         6y/NDv4N5ePxfgJCTLgrZm0Np/Cv+5hx1cxjqXiMcHyJ+Jgz73ZPg9D9AlK8u1TpnnRo
         M2dAkMParYP6FpJ1TqAN3Cl34l4/84E3t5Nn6+esqE2OtgU7+1jhwXzua3n1hSeHJ18n
         HhnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KhNnP/oPOEf+AzAoi7FbFVFnff3zDauVn+R3czZgO30=;
        b=JbxaQFA4xOay91W2WpgPhCoHyTHwtn1uYBTzQdKFAzoa1rTSS0tIUjtctRkMKs4KHt
         vYYW34ziPqXvGDvhWdpnYCYwZKq5lzHRdGgQH7Jn8OjrSx8QzSvrQ1Yq5Rp+SFSZgpl4
         5w3gtUw26hESajBgAovfzv0Rg70TFPmnqSgcGzx0KDVg/PpmKHr1jk7ZGYqLuurqeYLx
         2YzeU3GezIP9bimx/Mv9mP9u4hQ1x8+lfVtaZUUd7+0Il9uTgZFa5NHZN5m1LukdJEdD
         QhmuooaiakwTyQRKW5EAlvp9KT1LhTZ258bV+SfMTC+KLCDFp1af6sCWyk9cmTsN3EgB
         t9TQ==
X-Gm-Message-State: AOAM532gRT/ISicX/DkVelSFz0VM5SxeGqImLlwy8j36truBqK3Z/35T
        RNGO7oAV/0PDDntluAKwm/RKXA==
X-Google-Smtp-Source: ABdhPJz/yPGOPSHTvHZXLM/c6Q7JI6z6lCmpGsm8deY68JVPwct+uxdlkutPxjPpDeKxc+BLSWOk9A==
X-Received: by 2002:a92:c088:0:b0:2c7:9421:3c7b with SMTP id h8-20020a92c088000000b002c794213c7bmr9146321ile.280.1647287972235;
        Mon, 14 Mar 2022 12:59:32 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id r15-20020a056e0219cf00b002c77a3f2a85sm6286928ill.6.2022.03.14.12.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 12:59:31 -0700 (PDT)
Date:   Mon, 14 Mar 2022 19:59:28 +0000
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
Subject: Re: [PATCH v4 07/13] KVM: arm64: Add vendor hypervisor firmware
 register
Message-ID: <Yi+eoHWYgt6A5z+1@google.com>
References: <20220224172559.4170192-1-rananta@google.com>
 <20220224172559.4170192-8-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224172559.4170192-8-rananta@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022 at 05:25:53PM +0000, Raghavendra Rao Ananta wrote:
> Introduce the firmware register to hold the vendor specific
> hypervisor service calls (owner value 6) as a bitmap. The
> bitmap represents the features that'll be enabled for the
> guest, as configured by the user-space. Currently, this
> includes support only for Precision Time Protocol (PTP),
> represented by bit-0.
> 
> The register is also added to the kvm_arm_vm_scope_fw_regs[]
> list as it maintains its state per-VM.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/include/uapi/asm/kvm.h |  4 ++++
>  arch/arm64/kvm/guest.c            |  1 +
>  arch/arm64/kvm/hypercalls.c       | 22 +++++++++++++++++++++-
>  include/kvm/arm_hypercalls.h      |  3 +++
>  5 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 318148b69279..d999456c4604 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -106,10 +106,12 @@ struct kvm_arch_memory_slot {
>   *
>   * @hvc_std_bmap: Bitmap of standard secure service calls
>   * @hvc_std_hyp_bmap: Bitmap of standard hypervisor service calls
> + * @hvc_vendor_hyp_bmap: Bitmap of vendor specific hypervisor service calls
>   */
>  struct kvm_hvc_desc {
>  	u64 hvc_std_bmap;
>  	u64 hvc_std_hyp_bmap;
> +	u64 hvc_vendor_hyp_bmap;
>  };
>  
>  struct kvm_arch {
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 9a2caead7359..ed470bde13d8 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -299,6 +299,10 @@ struct kvm_arm_copy_mte_tags {
>  #define KVM_REG_ARM_STD_HYP_BIT_PV_TIME		BIT(0)
>  #define KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX	0       /* Last valid bit */
>  
> +#define KVM_REG_ARM_VENDOR_HYP_BMAP		KVM_REG_ARM_FW_BMAP_REG(2)
> +#define KVM_REG_ARM_VENDOR_HYP_BIT_PTP		BIT(0)
> +#define KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX	0       /* Last valid bit */
> +
>  /* SVE registers */
>  #define KVM_REG_ARM64_SVE		(0x15 << KVM_REG_ARM_COPROC_SHIFT)
>  
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index c42426d6137e..fc3656f91aed 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -67,6 +67,7 @@ static const u64 kvm_arm_vm_scope_fw_regs[] = {
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>  	KVM_REG_ARM_STD_BMAP,
>  	KVM_REG_ARM_STD_HYP_BMAP,
> +	KVM_REG_ARM_VENDOR_HYP_BMAP,
>  };
>  
>  /**
> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
> index ebc0cc26cf2e..5c5098c8f1f9 100644
> --- a/arch/arm64/kvm/hypercalls.c
> +++ b/arch/arm64/kvm/hypercalls.c
> @@ -79,6 +79,9 @@ static bool kvm_hvc_call_supported(struct kvm_vcpu *vcpu, u32 func_id)
>  	case ARM_SMCCC_HV_PV_TIME_ST:
>  		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_std_hyp_bmap,
>  					KVM_REG_ARM_STD_HYP_BIT_PV_TIME);
> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
> +		return kvm_arm_fw_reg_feat_enabled(hvc_desc->hvc_vendor_hyp_bmap,
> +					KVM_REG_ARM_VENDOR_HYP_BIT_PTP);
>  	default:
>  		/* By default, allow the services that aren't listed here */
>  		return true;
> @@ -162,7 +165,14 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>  		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
> -		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
> +
> +		/*
> +		 * The feature bits exposed to user-space doesn't include
> +		 * ARM_SMCCC_KVM_FUNC_FEATURES. However, we expose this to
> +		 * the guest as bit-0. Hence, left-shift the user-space
> +		 * exposed bitmap by 1 to accommodate this.
> +		 */
> +		val[0] |= hvc_desc->hvc_vendor_hyp_bmap << 1;

Having an off-by-one difference between the userspace and guest
representations of this bitmap seems like it could be a source of bugs
in the future. Its also impossible for the guest to completely hide the
vendor range if it so chooses.

Why not tie ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID and
ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID to BIT(0)? PTP would then
become BIT(1).

>  		break;
>  	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>  		kvm_ptp_get_time(vcpu, val);
> @@ -188,6 +198,7 @@ static const u64 kvm_arm_fw_reg_ids[] = {
>  	KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2,
>  	KVM_REG_ARM_STD_BMAP,
>  	KVM_REG_ARM_STD_HYP_BMAP,
> +	KVM_REG_ARM_VENDOR_HYP_BMAP,
>  };
>  
>  void kvm_arm_init_hypercalls(struct kvm *kvm)
> @@ -196,6 +207,7 @@ void kvm_arm_init_hypercalls(struct kvm *kvm)
>  
>  	hvc_desc->hvc_std_bmap = ARM_SMCCC_STD_FEATURES;
>  	hvc_desc->hvc_std_hyp_bmap = ARM_SMCCC_STD_HYP_FEATURES;
> +	hvc_desc->hvc_vendor_hyp_bmap = ARM_SMCCC_VENDOR_HYP_FEATURES;
>  }
>  
>  int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
> @@ -285,6 +297,9 @@ int kvm_arm_get_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  	case KVM_REG_ARM_STD_HYP_BMAP:
>  		val = READ_ONCE(hvc_desc->hvc_std_hyp_bmap);
>  		break;
> +	case KVM_REG_ARM_VENDOR_HYP_BMAP:
> +		val = READ_ONCE(hvc_desc->hvc_vendor_hyp_bmap);
> +		break;
>  	default:
>  		return -ENOENT;
>  	}
> @@ -311,6 +326,10 @@ static int kvm_arm_set_fw_reg_bmap(struct kvm_vcpu *vcpu, u64 reg_id, u64 val)
>  		fw_reg_bmap = &hvc_desc->hvc_std_hyp_bmap;
>  		fw_reg_features = ARM_SMCCC_STD_HYP_FEATURES;
>  		break;
> +	case KVM_REG_ARM_VENDOR_HYP_BMAP:
> +		fw_reg_bmap = &hvc_desc->hvc_vendor_hyp_bmap;
> +		fw_reg_features = ARM_SMCCC_VENDOR_HYP_FEATURES;
> +		break;
>  	default:
>  		return -ENOENT;
>  	}
> @@ -416,6 +435,7 @@ int kvm_arm_set_fw_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
>  		return 0;
>  	case KVM_REG_ARM_STD_BMAP:
>  	case KVM_REG_ARM_STD_HYP_BMAP:
> +	case KVM_REG_ARM_VENDOR_HYP_BMAP:
>  		return kvm_arm_set_fw_reg_bmap(vcpu, reg_id, val);
>  	default:
>  		return -ENOENT;
> diff --git a/include/kvm/arm_hypercalls.h b/include/kvm/arm_hypercalls.h
> index a1cb6e839c74..91be758ca58e 100644
> --- a/include/kvm/arm_hypercalls.h
> +++ b/include/kvm/arm_hypercalls.h
> @@ -12,6 +12,9 @@
>  #define ARM_SMCCC_STD_HYP_FEATURES \
>  	GENMASK_ULL(KVM_REG_ARM_STD_HYP_BMAP_BIT_MAX, 0)
>  
> +#define ARM_SMCCC_VENDOR_HYP_FEATURES \
> +	GENMASK_ULL(KVM_REG_ARM_VENDOR_HYP_BMAP_BIT_MAX, 0)
> +
>  int kvm_hvc_call_handler(struct kvm_vcpu *vcpu);
>  
>  static inline u32 smccc_get_function(struct kvm_vcpu *vcpu)
> -- 
> 2.35.1.473.g83b2b277ed-goog
> 
