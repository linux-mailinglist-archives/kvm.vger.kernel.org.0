Return-Path: <kvm+bounces-39818-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ADC11A4B3CD
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 18:31:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 099533B0E05
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 17:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F95C1EA7F0;
	Sun,  2 Mar 2025 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k+UZ31KX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF1F18EAB;
	Sun,  2 Mar 2025 17:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740936670; cv=none; b=QgCQINmZ0uO7C1s9MJLmOcrq6+m1/XfFR0YX6PKrmsfCGsEU/q/lp7uVPWrkhyCPIcnLDC6kqa59rE4/Kppp1lPV+ln144V+uU4ZIrpDjJiUhkrB0dGFqbGHHhZQEA4GgLYHwGlmvEsIhHcykP1FE6kwXHM34TIHL8hWjOifB3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740936670; c=relaxed/simple;
	bh=NJ1mX83JsUul65tgXZ3JR8aYuPxYZcrQ9v/eeypdf7U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QAUzeo3Gzoj2TIjteev3FaNXU05TPtYaFB0k4w6BKCF34hyrANleAojA7EWKs+Kz2n6aVZvgswuWnTase5SQu3L8TDJZYzpEKBVGCeUcE/CRPBwIOr+zy9oJKNVT44mM6942IMOqwmmTFCzvvUdCgiSuU/I8mGtqQmjUWFjXiww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k+UZ31KX; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740936667; x=1772472667;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NJ1mX83JsUul65tgXZ3JR8aYuPxYZcrQ9v/eeypdf7U=;
  b=k+UZ31KXAVrM9EyZE1aH/LwRweweeH6iaSkL3rFY1OxCuMX3fhk5Tt3Z
   fc5VJMsH1ZE+5tFzGQP2BTMyuFjDRapa+Mc92rRQYT91aRGqQ2Pak/qm9
   Lne10hVfXOQ1WZvOukBKHAbX8ZANNSs2yHcH6OnzRp8VxYrU8yGXgRnpX
   pg27itqLGFmQLVkllDgwq5BKTszYQ5TGOGzwJvGIKGQaJ+j4LH16uai02
   ecpa3ZDPnPAwu7omzdVNz5zYLQQ+kZqWm5gdL+l2uKnxg0jWAJ5ckMeiE
   fcNtS+GceTM9DSR9GZTPIEv1bbfS/rYRrI+nc5V5d92GlZq5T5J92Vq6G
   g==;
X-CSE-ConnectionGUID: totDmv6dQ9KlDejTsK3sXw==
X-CSE-MsgGUID: S3i67uJHQC+n1VskEhKA5Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41841871"
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="41841871"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 09:30:41 -0800
X-CSE-ConnectionGUID: ZTl4MPsUROe/ipMdyfPInw==
X-CSE-MsgGUID: wqcrZ86oRm+7t/wssHk6AA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="117554400"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 09:30:39 -0800
Message-ID: <074f1cef-1a1f-4854-8566-8fdc0d788044@intel.com>
Date: Mon, 3 Mar 2025 01:30:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] KVM: x86: Introduce Intel specific quirk
 KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, yan.y.zhao@intel.com, Kevin Tian <kevin.tian@intel.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-4-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250301073428.2435768-4-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/2025 3:34 PM, Paolo Bonzini wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Introduce an Intel specific quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT to have
> KVM ignore guest PAT when this quirk is enabled.
> 
> KVM is able to safely honor guest PAT on Intel platforms when CPU feature
> self-snoop is supported. However, KVM honoring guest PAT was reverted after
> commit 9d70f3fec144 ("Revert "KVM: VMX: Always honor guest PAT on CPUs that
> support self-snoop""), due to UC access on certain Intel platforms being
> very slow [1]. Honoring guest PAT on those platforms may break some old
> guests that accidentally specify PAT as UC. Those old guests may never
> expect the slowness since KVM always forces WB previously. See [2].
> 
> So, introduce an Intel specific quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT.
> KVM enables the quirk on all Intel platforms by default to avoid breaking
> old unmodifiable guests. Newer userspace can disable this quirk to turn on
> honoring guest PAT.
> 
> The quirk is only valid on Intel's platforms and is absent on AMD's
> platforms as KVM always honors guest PAT when running on AMD.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Cc: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Link: https://lore.kernel.org/all/Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com # [1]
> Link: https://lore.kernel.org/all/87jzfutmfc.fsf@redhat.com # [2]
> Message-ID: <20250224070946.31482-1-yan.y.zhao@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   Documentation/virt/kvm/api.rst  | 22 +++++++++++++++++++
>   arch/x86/include/uapi/asm/kvm.h |  1 +
>   arch/x86/kvm/mmu.h              |  2 +-
>   arch/x86/kvm/mmu/mmu.c          | 11 ++++++----
>   arch/x86/kvm/svm/svm.c          |  1 +
>   arch/x86/kvm/vmx/vmx.c          | 39 +++++++++++++++++++++++++++------
>   arch/x86/kvm/x86.c              |  2 +-
>   7 files changed, 65 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 2d75edc9db4f..1f13e47a65fa 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -8157,6 +8157,28 @@ KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
>                                       and 0x489), as KVM does now allow them to
>                                       be set by userspace (KVM sets them based on
>                                       guest CPUID, for safety purposes).
> +
> +KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT  By default, on Intel platforms, KVM ignores
> +                                    guest PAT and forces the effective memory
> +                                    type to WB in EPT.  The quirk is not available
> +                                    on Intel platforms which are incapable of
> +                                    safely honoring guest PAT (i.e., without CPU
> +                                    self-snoop, KVM always ignores guest PAT and
> +                                    forces effective memory type to WB).  It is
> +                                    also ignored on AMD platforms or, on Intel,
> +                                    when a VM has non-coherent DMA devices
> +                                    assigned; KVM always honors guest PAT in
> +                                    such case. The quirk is needed to avoid
> +                                    slowdowns on certain Intel Xeon platforms
> +                                    (e.g. ICX, SPR) where self-snoop feature is
> +                                    supported but UC is slow enough to cause
> +                                    issues with some older guests that use
> +                                    UC instead of WC to map the video RAM.
> +                                    Userspace can disable the quirk to honor
> +                                    guest PAT if it knows that there is no such
> +                                    guest software, for example if it does not
> +                                    expose a bochs graphics device (which is
> +                                    known to have had a buggy driver).
>   =================================== ============================================
>   
>   7.32 KVM_CAP_MAX_VCPU_ID
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 89cc7a18ef45..db55a70e173c 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -441,6 +441,7 @@ struct kvm_sync_regs {
>   #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
>   #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
>   #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
> +#define KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT	(1 << 9)
>   
>   #define KVM_STATE_NESTED_FORMAT_VMX	0
>   #define KVM_STATE_NESTED_FORMAT_SVM	1
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 47e64a3c4ce3..f999c15d8d3e 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -232,7 +232,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   	return -(u32)fault & errcode;
>   }
>   
> -bool kvm_mmu_may_ignore_guest_pat(void);
> +bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm);
>   
>   int kvm_mmu_post_init_vm(struct kvm *kvm);
>   void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index e6eb3a262f8d..bcf395d7ec53 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4663,17 +4663,20 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
>   }
>   #endif
>   
> -bool kvm_mmu_may_ignore_guest_pat(void)
> +bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm)
>   {
>   	/*
>   	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
>   	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
>   	 * honor the memtype from the guest's PAT so that guest accesses to
>   	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
> -	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
> -	 * KVM _always_ ignores guest PAT (when EPT is enabled).
> +	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA.
> +	 * KVM _always_ ignores guest PAT, when EPT is enabled and when quirk
> +	 * KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is enabled or the CPU lacks the
> +	 * ability to safely honor guest PAT.
>   	 */
> -	return shadow_memtype_mask;
> +	return shadow_memtype_mask &&
> +	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT);
>   }
>   
>   int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index ebaa5a41db07..2254dbebddac 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -5426,6 +5426,7 @@ static __init int svm_hardware_setup(void)
>   	 */
>   	allow_smaller_maxphyaddr = !npt_enabled;
>   
> +	kvm_caps.inapplicable_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
>   	return 0;
>   
>   err:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 75df4caea2f7..5365efb22e96 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7599,6 +7599,33 @@ int vmx_vm_init(struct kvm *kvm)
>   	return 0;
>   }
>   
> +/*
> + * Ignore guest PAT when the CPU doesn't support self-snoop to safely honor
> + * guest PAT, or quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is turned on.  Always
> + * honor guest PAT when there's non-coherent DMA device attached.
> + *
> + * Honoring guest PAT means letting the guest control memory types.
> + * - On Intel CPUs that lack self-snoop feature, honoring guest PAT may result
> + *   in unexpected behavior. So always ignore guest PAT on those CPUs.
> + *
> + * - KVM's ABI is to trust the guest for attached non-coherent DMA devices to
> + *   function correctly (non-coherent DMA devices need the guest to flush CPU
> + *   caches properly). So honoring guest PAT to avoid breaking existing ABI.
> + *
> + * - On certain Intel CPUs (e.g. SPR, ICX), though self-snoop feature is
> + *   supported, UC is slow enough to cause issues with some older guests (e.g.
> + *   an old version of bochs driver uses ioremap() instead of ioremap_wc() to
> + *   map the video RAM, causing wayland desktop to fail to get started
> + *   correctly). To avoid breaking those old guests that rely on KVM to force
> + *   memory type to WB, only honoring guest PAT when quirk
> + *   KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is disabled.
> + */
> +static inline bool vmx_ignore_guest_pat(struct kvm *kvm)
> +{
> +	return !kvm_arch_has_noncoherent_dma(kvm) &&
> +	       kvm_check_has_quirk(kvm, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT);
> +}
> +
>   u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>   {
>   	/*
> @@ -7608,13 +7635,8 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
>   	if (is_mmio)
>   		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
>   
> -	/*
> -	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
> -	 * device attached.  Letting the guest control memory types on Intel
> -	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
> -	 * the guest to behave only as a last resort.
> -	 */
> -	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
> +	/* Force WB if ignoring guest PAT */
> +	if (vmx_ignore_guest_pat(vcpu->kvm))
>   		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
>   
>   	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
> @@ -8506,6 +8528,9 @@ __init int vmx_hardware_setup(void)
>   
>   	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
>   
> +	/* Must use WB if the CPU does not have self-snoop.  */
> +	if (!static_cpu_has(X86_FEATURE_SELFSNOOP))
> +		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;

It seems missing the code to add KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT into 
KVM_X86_VALID_QUIRKS?

>   	kvm_caps.inapplicable_quirks = KVM_X86_QUIRK_CD_NW_CLEARED;
>   	return r;
>   }
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index a97e58916b6a..b221f273ec77 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13544,7 +13544,7 @@ static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
>   	 * (or last) non-coherent device is (un)registered to so that new SPTEs
>   	 * with the correct "ignore guest PAT" setting are created.
>   	 */
> -	if (kvm_mmu_may_ignore_guest_pat())
> +	if (kvm_mmu_may_ignore_guest_pat(kvm))
>   		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
>   }
>   


