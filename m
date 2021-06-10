Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7323A2A16
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 13:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhFJLWX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 07:22:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229935AbhFJLWX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 07:22:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623324026;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H4n1JA5Jw90trbK/fB8qO+KGIvEuz9zEAp96gSp6lxs=;
        b=LvmMAn7RMrDHWYWKnH1wQKAPI5UCSKCiEhzgehNA1g5p5CCkE14C/4MqGAm78ymRM9Wdbg
        xaYu2o+OkbNaqqdaV+TYQxvID6VN5K8kJxVVemMBfnBTBx6USQyxYNLWioeQYXvD3ScdJR
        InytRxuR9Mtf3dcB9GmqevqDeyjokQU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-322-lqwJmU7sOcKc1PUfGn63Eg-1; Thu, 10 Jun 2021 07:20:25 -0400
X-MC-Unique: lqwJmU7sOcKc1PUfGn63Eg-1
Received: by mail-wm1-f69.google.com with SMTP id g14-20020a05600c4eceb02901b609849650so3233350wmq.6
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 04:20:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=H4n1JA5Jw90trbK/fB8qO+KGIvEuz9zEAp96gSp6lxs=;
        b=T3t8PHLB/4NlIAJrKtTU7VKpQGTEaD9ElrsBGCyoGxDNaavyQMpy9AHE/gQ0sLG4gJ
         iIKWErcMFm4Hoqq+ysCJVeyapw3PC83ZmEQn9ymqiT6QGvRahZBHpmSqJ1t8NkxA6ooi
         EZhBKGQhQh/0TMaeb7egEWkcJg5Bp0vTJPq7HLFIKoDdC+8G2jph7Ls4Od16fQJYtyZo
         wrLvmsws/oPxFr1m2gASI3nZTUb+a4NSipmY1/sjtyVQy+/Xi/Niq/twRdZ0a5hQQNHr
         5J7AqaJ4uWoKGEHtDsObcAvkCakrr8HFfW8RdVAN0K0C1oApdQeUXeUs85a9NKoR074D
         +Umw==
X-Gm-Message-State: AOAM530dU+4gx0EVmyqSAVVT0m/eI+uoDM8DHOZtKg0EPl7spQB/Vox4
        yPgaaD2y1coq4fYzKGKhdTYB3ipGV/cAwetQHtCYbjcyPKbS27ZeTIIk/BH4n2KJLuBOsrWMoKf
        TcYmD/8qE1l4h
X-Received: by 2002:adf:ebc4:: with SMTP id v4mr4728622wrn.217.1623324024657;
        Thu, 10 Jun 2021 04:20:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxtgL+TaW5NcfZnCCYZgbLVfeEd+np5aFfDEUY/RGXKvUIEwIe53Q0JRjfE7SvS1kt6u97qHw==
X-Received: by 2002:adf:ebc4:: with SMTP id v4mr4728577wrn.217.1623324024390;
        Thu, 10 Jun 2021 04:20:24 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h9sm9596434wmm.33.2021.06.10.04.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 04:20:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH v5 3/7] KVM: x86: hyper-v: Move the remote TLB flush
 logic out of vmx
In-Reply-To: <4f4e4ca19778437dae502f44363a38e99e3ef5d1.1622730232.git.viremana@linux.microsoft.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
 <4f4e4ca19778437dae502f44363a38e99e3ef5d1.1622730232.git.viremana@linux.microsoft.com>
Date:   Thu, 10 Jun 2021 13:20:22 +0200
Message-ID: <87y2bix8y1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vineeth Pillai <viremana@linux.microsoft.com> writes:

> Currently the remote TLB flush logic is specific to VMX.
> Move it to a common place so that SVM can use it as well.
>
> Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
> ---
>  arch/x86/include/asm/kvm_host.h |   9 +++
>  arch/x86/kvm/Makefile           |   5 ++
>  arch/x86/kvm/kvm_onhyperv.c     |  93 ++++++++++++++++++++++++++++
>  arch/x86/kvm/kvm_onhyperv.h     |  32 ++++++++++
>  arch/x86/kvm/vmx/vmx.c          | 105 +-------------------------------
>  arch/x86/kvm/vmx/vmx.h          |   9 ---
>  arch/x86/kvm/x86.c              |   9 +++
>  7 files changed, 150 insertions(+), 112 deletions(-)
>  create mode 100644 arch/x86/kvm/kvm_onhyperv.c
>  create mode 100644 arch/x86/kvm/kvm_onhyperv.h
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index cbbcee0a84f9..bab305230e8d 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -849,6 +849,10 @@ struct kvm_vcpu_arch {
>  
>  	/* Protected Guests */
>  	bool guest_state_protected;
> +
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	hpa_t hv_root_tdp;
> +#endif
>  };
>  
>  struct kvm_lpage_info {
> @@ -1122,6 +1126,11 @@ struct kvm_arch {
>  	 */
>  	spinlock_t tdp_mmu_pages_lock;
>  #endif /* CONFIG_X86_64 */
> +
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	hpa_t	hv_root_tdp;
> +	spinlock_t hv_root_tdp_lock;
> +#endif
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index c589db5d91b3..a06745c2fef1 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -18,6 +18,11 @@ kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
>  			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o mtrr.o \
>  			   hyperv.o debugfs.o mmu/mmu.o mmu/page_track.o \
>  			   mmu/spte.o
> +
> +ifdef CONFIG_HYPERV
> +kvm-y			+= kvm_onhyperv.o
> +endif
> +
>  kvm-$(CONFIG_X86_64) += mmu/tdp_iter.o mmu/tdp_mmu.o
>  kvm-$(CONFIG_KVM_XEN)	+= xen.o
>  
> diff --git a/arch/x86/kvm/kvm_onhyperv.c b/arch/x86/kvm/kvm_onhyperv.c
> new file mode 100644
> index 000000000000..c7db2df50a7a
> --- /dev/null
> +++ b/arch/x86/kvm/kvm_onhyperv.c
> @@ -0,0 +1,93 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * KVM L1 hypervisor optimizations on Hyper-V.
> + */
> +
> +#include <linux/kvm_host.h>
> +#include <asm/mshyperv.h>
> +
> +#include "hyperv.h"
> +#include "kvm_onhyperv.h"
> +
> +static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
> +		void *data)
> +{
> +	struct kvm_tlb_range *range = data;
> +
> +	return hyperv_fill_flush_guest_mapping_list(flush, range->start_gfn,
> +			range->pages);
> +}
> +
> +static inline int hv_remote_flush_root_tdp(hpa_t root_tdp,
> +					   struct kvm_tlb_range *range)
> +{
> +	if (range)
> +		return hyperv_flush_guest_mapping_range(root_tdp,
> +				kvm_fill_hv_flush_list_func, (void *)range);
> +	else
> +		return hyperv_flush_guest_mapping(root_tdp);
> +}
> +
> +int hv_remote_flush_tlb_with_range(struct kvm *kvm,
> +		struct kvm_tlb_range *range)
> +{
> +	struct kvm_arch *kvm_arch = &kvm->arch;
> +	struct kvm_vcpu *vcpu;
> +	int ret = 0, i, nr_unique_valid_roots;
> +	hpa_t root;
> +
> +	spin_lock(&kvm_arch->hv_root_tdp_lock);
> +
> +	if (!VALID_PAGE(kvm_arch->hv_root_tdp)) {
> +		nr_unique_valid_roots = 0;
> +
> +		/*
> +		 * Flush all valid roots, and see if all vCPUs have converged
> +		 * on a common root, in which case future flushes can skip the
> +		 * loop and flush the common root.
> +		 */
> +		kvm_for_each_vcpu(i, vcpu, kvm) {
> +			root = vcpu->arch.hv_root_tdp;
> +			if (!VALID_PAGE(root) || root == kvm_arch->hv_root_tdp)
> +				continue;
> +
> +			/*
> +			 * Set the tracked root to the first valid root.  Keep
> +			 * this root for the entirety of the loop even if more
> +			 * roots are encountered as a low effort optimization
> +			 * to avoid flushing the same (first) root again.
> +			 */
> +			if (++nr_unique_valid_roots == 1)
> +				kvm_arch->hv_root_tdp = root;
> +
> +			if (!ret)
> +				ret = hv_remote_flush_root_tdp(root, range);
> +
> +			/*
> +			 * Stop processing roots if a failure occurred and
> +			 * multiple valid roots have already been detected.
> +			 */
> +			if (ret && nr_unique_valid_roots > 1)
> +				break;
> +		}
> +
> +		/*
> +		 * The optimized flush of a single root can't be used if there
> +		 * are multiple valid roots (obviously).
> +		 */
> +		if (nr_unique_valid_roots > 1)
> +			kvm_arch->hv_root_tdp = INVALID_PAGE;
> +	} else {
> +		ret = hv_remote_flush_root_tdp(kvm_arch->hv_root_tdp, range);
> +	}
> +
> +	spin_unlock(&kvm_arch->hv_root_tdp_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(hv_remote_flush_tlb_with_range);
> +
> +int hv_remote_flush_tlb(struct kvm *kvm)
> +{
> +	return hv_remote_flush_tlb_with_range(kvm, NULL);
> +}
> +EXPORT_SYMBOL_GPL(hv_remote_flush_tlb);
> diff --git a/arch/x86/kvm/kvm_onhyperv.h b/arch/x86/kvm/kvm_onhyperv.h
> new file mode 100644
> index 000000000000..c03f01024a70
> --- /dev/null
> +++ b/arch/x86/kvm/kvm_onhyperv.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * KVM L1 hypervisor optimizations on Hyper-V.
> + */
> +
> +#ifndef __ARCH_X86_KVM_KVM_ONHYPERV_H__
> +#define __ARCH_X86_KVM_KVM_ONHYPERV_H__
> +
> +#if IS_ENABLED(CONFIG_HYPERV)
> +int hv_remote_flush_tlb_with_range(struct kvm *kvm,
> +		struct kvm_tlb_range *range);
> +int hv_remote_flush_tlb(struct kvm *kvm);
> +
> +static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
> +{
> +	struct kvm_arch *kvm_arch = &vcpu->kvm->arch;
> +
> +	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
> +		spin_lock(&kvm_arch->hv_root_tdp_lock);
> +		vcpu->arch.hv_root_tdp = root_tdp;
> +		if (root_tdp != kvm_arch->hv_root_tdp)
> +			kvm_arch->hv_root_tdp = INVALID_PAGE;
> +		spin_unlock(&kvm_arch->hv_root_tdp_lock);
> +	}
> +}
> +#else
> +static inline void hv_track_root_tdp(struct kvm_vcpu *vcpu, hpa_t root_tdp)
> +{
> +}
> +#endif
> +#endif

Super-nitpick: I'd suggest adding /* __ARCH_X86_KVM_KVM_ONHYPERV_H__ */
to the second '#endif' and /* IS_ENABLED(CONFIG_HYPERV) */ to '#else'
and the first one: files/functions tend to grow and it becomes hard to
see where the particular '#endif/#else' belongs.

> +
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d000cddbd734..117fb88cd354 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -52,6 +52,7 @@
>  #include "cpuid.h"
>  #include "evmcs.h"
>  #include "hyperv.h"
> +#include "kvm_onhyperv.h"
>  #include "irq.h"
>  #include "kvm_cache_regs.h"
>  #include "lapic.h"
> @@ -474,86 +475,6 @@ static const u32 vmx_uret_msrs_list[] = {
>  static bool __read_mostly enlightened_vmcs = true;
>  module_param(enlightened_vmcs, bool, 0444);
>  
> -static int kvm_fill_hv_flush_list_func(struct hv_guest_mapping_flush_list *flush,
> -		void *data)
> -{
> -	struct kvm_tlb_range *range = data;
> -
> -	return hyperv_fill_flush_guest_mapping_list(flush, range->start_gfn,
> -			range->pages);
> -}
> -
> -static inline int hv_remote_flush_root_ept(hpa_t root_ept,
> -					   struct kvm_tlb_range *range)
> -{
> -	if (range)
> -		return hyperv_flush_guest_mapping_range(root_ept,
> -				kvm_fill_hv_flush_list_func, (void *)range);
> -	else
> -		return hyperv_flush_guest_mapping(root_ept);
> -}
> -
> -static int hv_remote_flush_tlb_with_range(struct kvm *kvm,
> -		struct kvm_tlb_range *range)
> -{
> -	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
> -	struct kvm_vcpu *vcpu;
> -	int ret = 0, i, nr_unique_valid_roots;
> -	hpa_t root;
> -
> -	spin_lock(&kvm_vmx->hv_root_ept_lock);
> -
> -	if (!VALID_PAGE(kvm_vmx->hv_root_ept)) {
> -		nr_unique_valid_roots = 0;
> -
> -		/*
> -		 * Flush all valid roots, and see if all vCPUs have converged
> -		 * on a common root, in which case future flushes can skip the
> -		 * loop and flush the common root.
> -		 */
> -		kvm_for_each_vcpu(i, vcpu, kvm) {
> -			root = to_vmx(vcpu)->hv_root_ept;
> -			if (!VALID_PAGE(root) || root == kvm_vmx->hv_root_ept)
> -				continue;
> -
> -			/*
> -			 * Set the tracked root to the first valid root.  Keep
> -			 * this root for the entirety of the loop even if more
> -			 * roots are encountered as a low effort optimization
> -			 * to avoid flushing the same (first) root again.
> -			 */
> -			if (++nr_unique_valid_roots == 1)
> -				kvm_vmx->hv_root_ept = root;
> -
> -			if (!ret)
> -				ret = hv_remote_flush_root_ept(root, range);
> -
> -			/*
> -			 * Stop processing roots if a failure occurred and
> -			 * multiple valid roots have already been detected.
> -			 */
> -			if (ret && nr_unique_valid_roots > 1)
> -				break;
> -		}
> -
> -		/*
> -		 * The optimized flush of a single root can't be used if there
> -		 * are multiple valid roots (obviously).
> -		 */
> -		if (nr_unique_valid_roots > 1)
> -			kvm_vmx->hv_root_ept = INVALID_PAGE;
> -	} else {
> -		ret = hv_remote_flush_root_ept(kvm_vmx->hv_root_ept, range);
> -	}
> -
> -	spin_unlock(&kvm_vmx->hv_root_ept_lock);
> -	return ret;
> -}
> -static int hv_remote_flush_tlb(struct kvm *kvm)
> -{
> -	return hv_remote_flush_tlb_with_range(kvm, NULL);
> -}
> -
>  static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
>  {
>  	struct hv_enlightened_vmcs *evmcs;
> @@ -581,21 +502,6 @@ static int hv_enable_direct_tlbflush(struct kvm_vcpu *vcpu)
>  
>  #endif /* IS_ENABLED(CONFIG_HYPERV) */
>  
> -static void hv_track_root_ept(struct kvm_vcpu *vcpu, hpa_t root_ept)
> -{
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	struct kvm_vmx *kvm_vmx = to_kvm_vmx(vcpu->kvm);
> -
> -	if (kvm_x86_ops.tlb_remote_flush == hv_remote_flush_tlb) {
> -		spin_lock(&kvm_vmx->hv_root_ept_lock);
> -		to_vmx(vcpu)->hv_root_ept = root_ept;
> -		if (root_ept != kvm_vmx->hv_root_ept)
> -			kvm_vmx->hv_root_ept = INVALID_PAGE;
> -		spin_unlock(&kvm_vmx->hv_root_ept_lock);
> -	}
> -#endif
> -}
> -
>  /*
>   * Comment's format: document - errata name - stepping - processor name.
>   * Refer from
> @@ -3202,7 +3108,7 @@ static void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  		eptp = construct_eptp(vcpu, root_hpa, root_level);
>  		vmcs_write64(EPT_POINTER, eptp);
>  
> -		hv_track_root_ept(vcpu, root_hpa);
> +		hv_track_root_tdp(vcpu, root_hpa);
>  
>  		if (!enable_unrestricted_guest && !is_paging(vcpu))
>  			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
> @@ -6980,9 +6886,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  	vmx->pi_desc.nv = POSTED_INTR_VECTOR;
>  	vmx->pi_desc.sn = 1;
>  
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	vmx->hv_root_ept = INVALID_PAGE;
> -#endif
>  	return 0;
>  
>  free_vmcs:
> @@ -6999,10 +6902,6 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
>  
>  static int vmx_vm_init(struct kvm *kvm)
>  {
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	spin_lock_init(&to_kvm_vmx(kvm)->hv_root_ept_lock);
> -#endif
> -
>  	if (!ple_gap)
>  		kvm->arch.pause_in_guest = true;
>  
> diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> index 008cb87ff088..d1363e734a01 100644
> --- a/arch/x86/kvm/vmx/vmx.h
> +++ b/arch/x86/kvm/vmx/vmx.h
> @@ -328,10 +328,6 @@ struct vcpu_vmx {
>  	/* SGX Launch Control public key hash */
>  	u64 msr_ia32_sgxlepubkeyhash[4];
>  
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	u64 hv_root_ept;
> -#endif
> -
>  	struct pt_desc pt_desc;
>  	struct lbr_desc lbr_desc;
>  
> @@ -349,11 +345,6 @@ struct kvm_vmx {
>  	unsigned int tss_addr;
>  	bool ept_identity_pagetable_done;
>  	gpa_t ept_identity_map_addr;
> -
> -#if IS_ENABLED(CONFIG_HYPERV)
> -	hpa_t hv_root_ept;
> -	spinlock_t hv_root_ept_lock;
> -#endif
>  };
>  
>  bool nested_vmx_allowed(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 6eda2834fc05..580f3c6c86f9 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -10279,6 +10279,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>  	vcpu->arch.pending_external_vector = -1;
>  	vcpu->arch.preempted_in_kernel = false;
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	vcpu->arch.hv_root_tdp = INVALID_PAGE;
> +#endif
> +
>  	r = static_call(kvm_x86_vcpu_create)(vcpu);
>  	if (r)
>  		goto free_guest_fpu;
> @@ -10662,6 +10666,11 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	kvm->arch.guest_can_read_msr_platform_info = true;
>  
> +#if IS_ENABLED(CONFIG_HYPERV)
> +	spin_lock_init(&kvm->arch.hv_root_tdp_lock);
> +	kvm->arch.hv_root_tdp = INVALID_PAGE;
> +#endif
> +
>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
>  	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);

-- 
Vitaly

