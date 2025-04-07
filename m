Return-Path: <kvm+bounces-42850-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CB9EA7E39D
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 17:12:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3299164665
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 15:06:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E89991F8922;
	Mon,  7 Apr 2025 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b="e+bTi3Li"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA3C1EF369
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 15:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744038288; cv=none; b=MLMGlRZmMQjeG5NCuBEyFB3tP8I6cKz0Ki/WzLiUYFTGUabA6e3WYNfwsY6/7izBe3EbUDrT3qOw073LDgLjg4koIrNqpY1K0Ye4LRzjoIz+eaEprb97YlOdEdSokDzh02hbu9uexLtWfZDoQKHXXcGq5h/+fW6qI488SN3VBxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744038288; c=relaxed/simple;
	bh=si/HAeASKMwVMe4jysDMPvylshFfyJJu+MA6s1Nfta0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mwCymZvFZ5Tk5a0RoS92zSEbpCqKxAB1cS1p3rNWCnU+CZrA9CsaB7bfVNggQtIeaekCz8nKHRlsfus11RBY2bMR01nt0ouzOY4u3U0M2V7KehIbtu4uxcl23vExThPXvRQZu6FBj0lg92m4ZLL45EFtRqiY9QC1K4OTCNZuZLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw; spf=pass smtp.mailfrom=csie.ntu.edu.tw; dkim=pass (2048-bit key) header.d=csie.ntu.edu.tw header.i=@csie.ntu.edu.tw header.b=e+bTi3Li; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.ntu.edu.tw
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=csie.ntu.edu.tw
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-227b650504fso39543145ad.0
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 08:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=csie.ntu.edu.tw; s=google; t=1744038283; x=1744643083; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=I9kdmTO4tcqMNv0b+m3Ev3puZ8xn/klk3TOQNZ1xzZQ=;
        b=e+bTi3LiI++yrkUGWoXou4HD52hEOpCUk79WSkBHmDCR26MazPYyt1Wx39w6KHNaql
         g/VKKxAe5y8RsP3oVncN1GFNc2wASHcSKKRlSlQ0vQPiPQ2G7O2dkm5d1Ple877eFAUY
         NlajDHGYJ5Ok2bem6rO670T9NIHvoJF66RFbFsTSzhjXdBw/OJVpylcWKFq4YBBGbxWA
         m2L+gDOGINIKZ7V8V8Z6JepyGs9vjzepS5k6NYVtBGl7pO5JdIKpIPTdj78Hp/hyzipn
         kxCj3FHOas0t7sO+I9SbE7L3WrKARqkjIyPRUrmhm5bW2D0phhUi0z3ALubY2bptBucL
         +x1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744038283; x=1744643083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I9kdmTO4tcqMNv0b+m3Ev3puZ8xn/klk3TOQNZ1xzZQ=;
        b=mKnfNLLF6sjAX6+rydO/AUcqcYyJ+kDlzdLO971InZKiSe8rnwpnSo14kbMRWCNqPT
         jiP8o0Ft438RuTOWuZRv87Ub40GBTSvmdgk09sxS3fTD/sqYdg2Vgi02F26wpmdEr0ak
         TqqPZprBIj9T9qB+G20AK+xHzAgmauOIArHIyJohzCDvt3Y7B6HA1dhQtQA6XlE25iFm
         +Fg+m3tlfcPzA8RtyivPPzaUtQ6ZCiN3ikLBao8pfP4hryjnSbDdMn/wmATpLGdtXRxy
         fL93yVHG0LOW6o2CX2BFkl5qse8/ChgLqB6mneHfdTF2KusxZOlWoQAVS9m8qP8K0kfB
         9UCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUa0SH45jNDZH5dHWk/L4DDKTKm9JBLR5kpzrdufoPJX3QHrQ9m3d6LHCZf3MDaoAR76qk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMALa3kgmETGLpEsM97kFQ1kY/JnOnq3R9JxVku90ag1Y/3FFl
	FHx+0pRynVBSgyx+xQ2cyIAJP+KuiZkywygxvbPvYro+oBzMbUVlEKvn6UNyTr3+1Sx5pGzk7m/
	3L3Luok+jDUZq0YEKTs36Vu+bZudBg7pCVPZ2hga57OU=
X-Gm-Gg: ASbGncvTGjoMMUbPuQ7M0v2XTrTxWdDzQ+BqPLlg4qeqDumJk1KMuZ/vy2oYYb0ez8h
	VTCDrVjwXBOzfD4IRSWcjDWm8TFl8YnoiDQK9B6Y6VIz801qJU26G7fd5CEvXjwjYGleEiLOJaD
	tOz/gFpq+sxBEUMoiZWWCH9bHil+kB/CjX464YD03srZURq/D0s9spTVTD4pojZtfsO9+Hg56Y4
	mPA1lzVZ548TBUeh30+cbB+QM3XhV5ci0pKoecdS00hcnHNMWeyd/w/3MnbuC7GuzvDEcYqg/Ca
	+rL/Vfm7sShoH1GorVvGod7uHytoKIRJTRTzyClvAwuUMKQLDkyL+uGLXWt/4L1911xw9sXhMKY
	1JclV
X-Google-Smtp-Source: AGHT+IH2oVXyQ3zs/hUIZ8h7pbZlqmcCBM70vrTswgR9PuCbdJMakAfyi957MMSEaZ9tPm8qDM8Oug==
X-Received: by 2002:a17:902:ef10:b0:216:53fa:634f with SMTP id d9443c01a7336-22a8a1d4617mr200860295ad.48.1744038282789;
        Mon, 07 Apr 2025 08:04:42 -0700 (PDT)
Received: from zenbook (1-162-87-224.dynamic-ip.hinet.net. [1.162.87.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-229787778efsm81770435ad.259.2025.04.07.08.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 08:04:42 -0700 (PDT)
Date: Mon, 7 Apr 2025 23:06:23 +0800
From: Wei-Lin Chang <r09922117@csie.ntu.edu.tw>
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org, 
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, 
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, 
	Fuad Tabba <tabba@google.com>, linux-coco@lists.linux.dev, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Gavin Shan <gshan@redhat.com>, 
	Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun <alpergun@google.com>, 
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>, r09922117@csie.ntu.edu.tw
Subject: Re: [PATCH v7 12/45] arm64: RME: Allocate/free RECs to match vCPUs
Message-ID: <omfhugkuqmbvijitmlq2tluspjhsh43d32ecvr5uubnnhukapk@up6i7g4nbovb>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-13-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213161426.102987-13-steven.price@arm.com>
X-Gm-Spam: 0
X-Gm-Phishy: 0

Hi Steven,

On Thu, Feb 13, 2025 at 04:13:52PM +0000, Steven Price wrote:
> The RMM maintains a data structure known as the Realm Execution Context
> (or REC). It is similar to struct kvm_vcpu and tracks the state of the
> virtual CPUs. KVM must delegate memory and request the structures are
> created when vCPUs are created, and suitably tear down on destruction.
> 
> RECs must also be supplied with addition pages - auxiliary (or AUX)
> granules - for storing the larger registers state (e.g. for SVE). The
> number of AUX granules for a REC depends on the parameters with which
> the Realm was created - the RMM makes this information available via the
> RMI_REC_AUX_COUNT call performed after creating the Realm Descriptor (RD).
> 
> Note that only some of register state for the REC can be set by KVM, the
> rest is defined by the RMM (zeroed). The register state then cannot be
> changed by KVM after the REC is created (except when the guest
> explicitly requests this e.g. by performing a PSCI call). The RMM also
> requires that the VMM creates RECs in ascending order of the MPIDR.
> 
> See Realm Management Monitor specification (DEN0137) for more information:
> https://developer.arm.com/documentation/den0137/
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v6:
>  * Avoid reporting the KVM_ARM_VCPU_REC feature if the guest isn't a
>    realm guest.
>  * Support host page size being larger than RMM's granule size when
>    allocating/freeing aux granules.
> Changes since v5:
>  * Separate the concept of vcpu_is_rec() and
>    kvm_arm_vcpu_rec_finalized() by using the KVM_ARM_VCPU_REC feature as
>    the indication that the VCPU is a REC.
> Changes since v2:
>  * Free rec->run earlier in kvm_destroy_realm() and adapt to previous patches.
> ---
>  arch/arm64/include/asm/kvm_emulate.h |   7 ++
>  arch/arm64/include/asm/kvm_host.h    |   3 +
>  arch/arm64/include/asm/kvm_rme.h     |  18 +++
>  arch/arm64/kvm/arm.c                 |  13 +-
>  arch/arm64/kvm/reset.c               |  11 ++
>  arch/arm64/kvm/rme.c                 | 179 +++++++++++++++++++++++++++
>  6 files changed, 229 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
> index 909c5c3b7632..f7b5a78f2e91 100644
> --- a/arch/arm64/include/asm/kvm_emulate.h
> +++ b/arch/arm64/include/asm/kvm_emulate.h
> @@ -711,7 +711,14 @@ static inline bool kvm_realm_is_created(struct kvm *kvm)
>  
>  static inline bool vcpu_is_rec(struct kvm_vcpu *vcpu)
>  {
> +	if (static_branch_unlikely(&kvm_rme_is_available))
> +		return vcpu_has_feature(vcpu, KVM_ARM_VCPU_REC);
>  	return false;
>  }
>  
> +static inline bool kvm_arm_rec_finalized(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->arch.rec.mpidr != INVALID_HWID;
> +}
> +
>  #endif /* __ARM64_KVM_EMULATE_H__ */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 992eb2a6f56f..016d0685958d 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -803,6 +803,9 @@ struct kvm_vcpu_arch {
>  
>  	/* Per-vcpu CCSIDR override or NULL */
>  	u32 *ccsidr;
> +
> +	/* Realm meta data */
> +	struct realm_rec rec;
>  };
>  
>  /*
> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/asm/kvm_rme.h
> index 698bb48a8ae1..5db377943db4 100644
> --- a/arch/arm64/include/asm/kvm_rme.h
> +++ b/arch/arm64/include/asm/kvm_rme.h
> @@ -6,6 +6,7 @@
>  #ifndef __ASM_KVM_RME_H
>  #define __ASM_KVM_RME_H
>  
> +#include <asm/rmi_smc.h>
>  #include <uapi/linux/kvm.h>
>  
>  /**
> @@ -65,6 +66,21 @@ struct realm {
>  	unsigned int ia_bits;
>  };
>  
> +/**
> + * struct realm_rec - Additional per VCPU data for a Realm
> + *
> + * @mpidr: MPIDR (Multiprocessor Affinity Register) value to identify this VCPU
> + * @rec_page: Kernel VA of the RMM's private page for this REC
> + * @aux_pages: Additional pages private to the RMM for this REC
> + * @run: Kernel VA of the RmiRecRun structure shared with the RMM
> + */
> +struct realm_rec {
> +	unsigned long mpidr;
> +	void *rec_page;
> +	struct page *aux_pages[REC_PARAMS_AUX_GRANULES];
> +	struct rec_run *run;
> +};
> +
>  void kvm_init_rme(void);
>  u32 kvm_realm_ipa_limit(void);
>  
> @@ -72,6 +88,8 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
>  int kvm_init_realm_vm(struct kvm *kvm);
>  void kvm_destroy_realm(struct kvm *kvm);
>  void kvm_realm_destroy_rtts(struct kvm *kvm, u32 ia_bits);
> +int kvm_create_rec(struct kvm_vcpu *vcpu);
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu);
>  
>  static inline bool kvm_realm_is_private_address(struct realm *realm,
>  						unsigned long addr)
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 917ee7c674f5..a6a3034a2f50 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -496,6 +496,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	/* Force users to call KVM_ARM_VCPU_INIT */
>  	vcpu_clear_flag(vcpu, VCPU_INITIALIZED);
>  
> +	vcpu->arch.rec.mpidr = INVALID_HWID;
> +
>  	vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>  
>  	/* Set up the timer */
> @@ -1433,7 +1435,7 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
>  	return -EINVAL;
>  }
>  
> -static unsigned long system_supported_vcpu_features(void)
> +static unsigned long system_supported_vcpu_features(struct kvm *kvm)
>  {
>  	unsigned long features = KVM_VCPU_VALID_FEATURES;
>  
> @@ -1454,6 +1456,9 @@ static unsigned long system_supported_vcpu_features(void)
>  	if (!cpus_have_final_cap(ARM64_HAS_NESTED_VIRT))
>  		clear_bit(KVM_ARM_VCPU_HAS_EL2, &features);
>  
> +	if (!kvm_is_realm(kvm))
> +		clear_bit(KVM_ARM_VCPU_REC, &features);
> +
>  	return features;
>  }
>  
> @@ -1471,7 +1476,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>  			return -ENOENT;
>  	}
>  
> -	if (features & ~system_supported_vcpu_features())
> +	if (features & ~system_supported_vcpu_features(vcpu->kvm))
>  		return -EINVAL;
>  
>  	/*
> @@ -1493,6 +1498,10 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
>  	if (test_bit(KVM_ARM_VCPU_HAS_EL2, &features))
>  		return -EINVAL;
>  
> +	/* RME is incompatible with AArch32 */
> +	if (test_bit(KVM_ARM_VCPU_REC, &features))
> +		return -EINVAL;
> +
>  	return 0;
>  }
>  
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index 803e11b0dc8f..a6423ef20144 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -137,6 +137,11 @@ int kvm_arm_vcpu_finalize(struct kvm_vcpu *vcpu, int feature)
>  			return -EPERM;
>  
>  		return kvm_vcpu_finalize_sve(vcpu);
> +	case KVM_ARM_VCPU_REC:
> +		if (!kvm_is_realm(vcpu->kvm) || !vcpu_is_rec(vcpu))
> +			return -EINVAL;
> +
> +		return kvm_create_rec(vcpu);
>  	}
>  
>  	return -EINVAL;
> @@ -147,6 +152,11 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu)
>  	if (vcpu_has_sve(vcpu) && !kvm_arm_vcpu_sve_finalized(vcpu))
>  		return false;
>  
> +	if (kvm_is_realm(vcpu->kvm) &&
> +	    !(vcpu_is_rec(vcpu) && kvm_arm_rec_finalized(vcpu) &&
> +	      READ_ONCE(vcpu->kvm->arch.realm.state) == REALM_STATE_ACTIVE))
> +		return false;
> +
>  	return true;
>  }
>  
> @@ -159,6 +169,7 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>  		kvm_unshare_hyp(sve_state, sve_state + vcpu_sve_state_size(vcpu));
>  	kfree(sve_state);
>  	kfree(vcpu->arch.ccsidr);
> +	kvm_destroy_rec(vcpu);
>  }
>  
>  static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
> index f5d79efee454..0aa1f29b0610 100644
> --- a/arch/arm64/kvm/rme.c
> +++ b/arch/arm64/kvm/rme.c
> @@ -474,6 +474,185 @@ void kvm_destroy_realm(struct kvm *kvm)
>  	kvm_free_stage2_pgd(&kvm->arch.mmu);
>  }
>  
> +static void free_rec_aux(struct page **aux_pages,
> +			 unsigned int num_aux)
> +{
> +	unsigned int i, j;
> +	unsigned int page_count = 0;
> +
> +	for (i = 0; i < num_aux;) {
> +		struct page *aux_page = aux_pages[page_count++];
> +		phys_addr_t aux_page_phys = page_to_phys(aux_page);
> +		bool undelegate_failed = false;
> +
> +		for (j = 0; j < PAGE_SIZE && i < num_aux; j += RMM_PAGE_SIZE) {
> +			if (WARN_ON(rmi_granule_undelegate(aux_page_phys)))
> +				undelegate_failed = true;
> +			aux_page_phys += RMM_PAGE_SIZE;
> +			i++;
> +		}
> +		if (!undelegate_failed)
> +			__free_page(aux_page);
> +	}
> +}
> +

Just a small stylistic comment:
I feel it can be slightly clearer if the double negative

bool undelegate_failed = false;

can be just:
bool undelegate_succeeded = true;

with the other true/false flipped, the if condition also won't need to be
negated.

Thanks,
Wei-Lin Chang

> +static int alloc_rec_aux(struct page **aux_pages,
> +			 u64 *aux_phys_pages,
> +			 unsigned int num_aux)
> +{
> +	struct page *aux_page;
> +	int page_count = 0;
> +	unsigned int i, j;
> +	int ret;
> +
> +	for (i = 0; i < num_aux;) {
> +		phys_addr_t aux_page_phys;
> +
> +		aux_page = alloc_page(GFP_KERNEL);
> +		if (!aux_page) {
> +			ret = -ENOMEM;
> +			goto out_err;
> +		}
> +
> +		aux_page_phys = page_to_phys(aux_page);
> +		for (j = 0; j < PAGE_SIZE && i < num_aux; j += RMM_PAGE_SIZE) {
> +			if (rmi_granule_delegate(aux_page_phys)) {
> +				ret = -ENXIO;
> +				goto err_undelegate;
> +			}
> +			aux_phys_pages[i++] = aux_page_phys;
> +			aux_page_phys += RMM_PAGE_SIZE;
> +		}
> +		aux_pages[page_count++] = aux_page;
> +	}
> +
> +	return 0;
> +err_undelegate:
> +	while (j > 0) {
> +		j -= RMM_PAGE_SIZE;
> +		i--;
> +		if (WARN_ON(rmi_granule_undelegate(aux_phys_pages[i]))) {
> +			/* Leak the page if the undelegate fails */
> +			goto out_err;
> +		}
> +	}
> +	__free_page(aux_page);
> +out_err:
> +	free_rec_aux(aux_pages, i);
> +	return ret;
> +}
> +
> +int kvm_create_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct user_pt_regs *vcpu_regs = vcpu_gp_regs(vcpu);
> +	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +	struct rec_params *params;
> +	int r, i;
> +
> +	if (kvm_realm_state(vcpu->kvm) != REALM_STATE_NEW)
> +		return -ENOENT;
> +
> +	if (rec->run)
> +		return -EBUSY;
> +
> +	/*
> +	 * The RMM will report PSCI v1.0 to Realms and the KVM_ARM_VCPU_PSCI_0_2
> +	 * flag covers v0.2 and onwards.
> +	 */
> +	if (!vcpu_has_feature(vcpu, KVM_ARM_VCPU_PSCI_0_2))
> +		return -EINVAL;
> +
> +	BUILD_BUG_ON(sizeof(*params) > PAGE_SIZE);
> +	BUILD_BUG_ON(sizeof(*rec->run) > PAGE_SIZE);
> +
> +	params = (struct rec_params *)get_zeroed_page(GFP_KERNEL);
> +	rec->rec_page = (void *)__get_free_page(GFP_KERNEL);
> +	rec->run = (void *)get_zeroed_page(GFP_KERNEL);
> +	if (!params || !rec->rec_page || !rec->run) {
> +		r = -ENOMEM;
> +		goto out_free_pages;
> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(params->gprs); i++)
> +		params->gprs[i] = vcpu_regs->regs[i];
> +
> +	params->pc = vcpu_regs->pc;
> +
> +	if (vcpu->vcpu_id == 0)
> +		params->flags |= REC_PARAMS_FLAG_RUNNABLE;
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	if (rmi_granule_delegate(rec_page_phys)) {
> +		r = -ENXIO;
> +		goto out_free_pages;
> +	}
> +
> +	r = alloc_rec_aux(rec->aux_pages, params->aux, realm->num_aux);
> +	if (r)
> +		goto out_undelegate_rmm_rec;
> +
> +	params->num_rec_aux = realm->num_aux;
> +	params->mpidr = mpidr;
> +
> +	if (rmi_rec_create(virt_to_phys(realm->rd),
> +			   rec_page_phys,
> +			   virt_to_phys(params))) {
> +		r = -ENXIO;
> +		goto out_free_rec_aux;
> +	}
> +
> +	rec->mpidr = mpidr;
> +
> +	free_page((unsigned long)params);
> +	return 0;
> +
> +out_free_rec_aux:
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +out_undelegate_rmm_rec:
> +	if (WARN_ON(rmi_granule_undelegate(rec_page_phys)))
> +		rec->rec_page = NULL;
> +out_free_pages:
> +	free_page((unsigned long)rec->run);
> +	free_page((unsigned long)rec->rec_page);
> +	free_page((unsigned long)params);
> +	return r;
> +}
> +
> +void kvm_destroy_rec(struct kvm_vcpu *vcpu)
> +{
> +	struct realm *realm = &vcpu->kvm->arch.realm;
> +	struct realm_rec *rec = &vcpu->arch.rec;
> +	unsigned long rec_page_phys;
> +
> +	if (!vcpu_is_rec(vcpu))
> +		return;
> +
> +	if (!rec->run) {
> +		/* Nothing to do if the VCPU hasn't been finalized */
> +		return;
> +	}
> +
> +	free_page((unsigned long)rec->run);
> +
> +	rec_page_phys = virt_to_phys(rec->rec_page);
> +
> +	/*
> +	 * The REC and any AUX pages cannot be reclaimed until the REC is
> +	 * destroyed. So if the REC destroy fails then the REC page and any AUX
> +	 * pages will be leaked.
> +	 */
> +	if (WARN_ON(rmi_rec_destroy(rec_page_phys)))
> +		return;
> +
> +	free_rec_aux(rec->aux_pages, realm->num_aux);
> +
> +	free_delegated_granule(rec_page_phys);
> +}
> +
>  int kvm_init_realm_vm(struct kvm *kvm)
>  {
>  	struct realm_params *params;
> -- 
> 2.43.0
> 

