Return-Path: <kvm+bounces-47926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CEF7AC7721
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 06:27:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA2D31BA1A51
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 04:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A61BD252287;
	Thu, 29 May 2025 04:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EaqPtWz9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747E735957;
	Thu, 29 May 2025 04:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748492841; cv=none; b=EiZKTMVkOGVIzZMFIXuvsVSxKSByzkJ9eQrpnep+yjH+T0bbUbyNJZNj9d7+pZWqQ4Hs1yt0HWzSGvMNARzoJxAGYjsQU2R1oydB+Eg0+fDte0P7io+5YutWHbRDVx4dilAL/WdmsbO1RcYgWvg6lgtQ1hC+qzyzP5SSlaImNc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748492841; c=relaxed/simple;
	bh=L5O901KRHAvHYa0ybdJQAt7qrlHkOolZqYMzzsrukZ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=barlo5s0TrwUMXuhpBNjlzxNsw0n4eYoghLQd3mJ+4KNtNoDXPq7/Ax4F6+9jnPnyCJLklHvbFTNvhPAkiOwQl3ryIoPY6mwVFkD6WiLoC0om8l3WfwM/qQp2JDB4WSyw49+dKBjC2/P/ys1T43gqopDaUP02qAAVSUEY730hLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EaqPtWz9; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748492840; x=1780028840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=L5O901KRHAvHYa0ybdJQAt7qrlHkOolZqYMzzsrukZ8=;
  b=EaqPtWz9GECSzD3NHkLpVfqCBkTuPaY7kGM0p4xdarsn9Bx1tDXJipQy
   iK4OFe9FB+hrBzq/8reot5eh+TYZccuIQoW0ngvRQxEN/E/3XiNl+0ZEn
   k2igV0AUyRMT00PZtg8laaDJP6Or+ZXj71NNyTosH0WoLFqXaNXS3IadQ
   ZyIZHxZNjD5K84EkCJPWVqMeV0HCQpvzGcT2UltEODU9F+1C3Luobf04h
   kQpA6XOVpWaMeO837riSMNDxYyoaFtJfhRxLQWDnyet+yh51QFI9yqU70
   P7019qdtlxHYeOPGlaasl+NdPTVIl0hISaf/sWRGMP2FBGrj7xdpp9k2i
   g==;
X-CSE-ConnectionGUID: TGDebsn0QDSK3dMYcmcMDw==
X-CSE-MsgGUID: 5lfGNL+7RTW6aC5LiW4PAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="54202886"
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="54202886"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 21:27:18 -0700
X-CSE-ConnectionGUID: XHqJGtUVRveuLBOaAYfHIw==
X-CSE-MsgGUID: WSqhFQStSPOa0QeXEKG3Yg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,322,1739865600"; 
   d="scan'208";a="143769450"
Received: from josephbr-mobl1.amr.corp.intel.com (HELO desk) ([10.125.146.30])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2025 21:27:17 -0700
Date: Wed, 28 May 2025 21:27:10 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
	Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH 3/5] KVM: VMX: Apply MMIO Stale Data mitigation if KVM
 maps MMIO into the guest
Message-ID: <20250529042710.crjcc76dqpiak4pn@desk>
References: <20250523011756.3243624-1-seanjc@google.com>
 <20250523011756.3243624-4-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250523011756.3243624-4-seanjc@google.com>

On Thu, May 22, 2025 at 06:17:54PM -0700, Sean Christopherson wrote:
> Enforce the MMIO State Data mitigation if KVM has ever mapped host MMIO
> into the VM, not if the VM has an assigned device.  VFIO is but one of
> many ways to map host MMIO into a KVM guest, and even within VFIO,
> formally attaching a device to a VM via KVM_DEV_VFIO_FILE_ADD is entirely
> optional.
> 
> Track whether or not the guest can access host MMIO on a per-MMU basis,
> i.e. based on whether or not the vCPU has a mapping to host MMIO.  For
> simplicity, track MMIO mappings in "special" rools (those without a
> kvm_mmu_page) at the VM level, as only Intel CPUs are vulnerable, and so
> only legacy 32-bit shadow paging is affected, i.e. lack of precise
> tracking is a complete non-issue.
> 
> Make the per-MMU and per-VM flags sticky.  Detecting when *all* MMIO
> mappings have been removed would be absurdly complex.  And in practice,
> removing MMIO from a guest will be done by deleting the associated memslot,
> which by default will force KVM to re-allocate all roots.  Special roots
> will forever be mitigated, but as above, the affected scenarios are not
> expected to be performance sensitive.
> 
> Use a VMX_RUN flag to communicate the need for a buffers flush to
> vmx_vcpu_enter_exit() so that kvm_vcpu_can_access_host_mmio() and all its
> dependencies don't need to be marked __always_inline, e.g. so that KASAN
> doesn't trigger a noinstr violation.
> 
> Cc: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Fixes: 8cb861e9e3c9 ("x86/speculation/mmio: Add mitigation for Processor MMIO Stale Data")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/mmu/mmu_internal.h |  3 +++
>  arch/x86/kvm/mmu/spte.c         | 21 +++++++++++++++++++++
>  arch/x86/kvm/mmu/spte.h         | 10 ++++++++++
>  arch/x86/kvm/vmx/run_flags.h    | 10 ++++++----
>  arch/x86/kvm/vmx/vmx.c          |  8 +++++++-
>  6 files changed, 48 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 01edcefbd937..043be00ec5b8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1458,6 +1458,7 @@ struct kvm_arch {
>  	bool x2apic_format;
>  	bool x2apic_broadcast_quirk_disabled;
>  
> +	bool has_mapped_host_mmio;
>  	bool guest_can_read_msr_platform_info;
>  	bool exception_payload_enabled;
>  
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index db8f33e4de62..65f3c89d7c5d 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -103,6 +103,9 @@ struct kvm_mmu_page {
>  		int root_count;
>  		refcount_t tdp_mmu_root_count;
>  	};
> +
> +	bool has_mapped_host_mmio;
> +
>  	union {
>  		/* These two members aren't used for TDP MMU */
>  		struct {
> diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
> index 3f16c91aa042..5fb43a834d48 100644
> --- a/arch/x86/kvm/mmu/spte.c
> +++ b/arch/x86/kvm/mmu/spte.c
> @@ -138,6 +138,22 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn, int *is_host_mmio)
>  	return *is_host_mmio;
>  }
>  
> +static void kvm_track_host_mmio_mapping(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
> +
> +	if (root)
> +		WRITE_ONCE(root->has_mapped_host_mmio, true);
> +	else
> +		WRITE_ONCE(vcpu->kvm->arch.has_mapped_host_mmio, true);
> +
> +	/*
> +	 * Force vCPUs to exit and flush CPU buffers if the vCPU is using the
> +	 * affected root(s).
> +	 */
> +	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_OUTSIDE_GUEST_MODE);
> +}
> +
>  /*
>   * Returns true if the SPTE needs to be updated atomically due to having bits
>   * that may be changed without holding mmu_lock, and for which KVM must not
> @@ -276,6 +292,11 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
>  		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
>  	}
>  
> +	if (static_branch_unlikely(&mmio_stale_data_clear) &&
> +	    !kvm_vcpu_can_access_host_mmio(vcpu) &&
> +	    kvm_is_mmio_pfn(pfn, &is_host_mmio))
> +		kvm_track_host_mmio_mapping(vcpu);
> +
>  	*new_spte = spte;
>  	return wrprot;
>  }
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 1e94f081bdaf..3133f066927e 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -280,6 +280,16 @@ static inline bool is_mirror_sptep(tdp_ptep_t sptep)
>  	return is_mirror_sp(sptep_to_sp(rcu_dereference(sptep)));
>  }
>  
> +static inline bool kvm_vcpu_can_access_host_mmio(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
> +
> +	if (root)
> +		return READ_ONCE(root->has_mapped_host_mmio);
> +
> +	return READ_ONCE(vcpu->kvm->arch.has_mapped_host_mmio);
> +}
> +
>  static inline bool is_mmio_spte(struct kvm *kvm, u64 spte)
>  {
>  	return (spte & shadow_mmio_mask) == kvm->arch.shadow_mmio_value &&
> diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
> index 6a9bfdfbb6e5..2f20fb170def 100644
> --- a/arch/x86/kvm/vmx/run_flags.h
> +++ b/arch/x86/kvm/vmx/run_flags.h
> @@ -2,10 +2,12 @@
>  #ifndef __KVM_X86_VMX_RUN_FLAGS_H
>  #define __KVM_X86_VMX_RUN_FLAGS_H
>  
> -#define VMX_RUN_VMRESUME_SHIFT		0
> -#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT	1
> +#define VMX_RUN_VMRESUME_SHIFT				0
> +#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
> +#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
>  
> -#define VMX_RUN_VMRESUME		BIT(VMX_RUN_VMRESUME_SHIFT)
> -#define VMX_RUN_SAVE_SPEC_CTRL		BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> +#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
> +#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
> +#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
>  
>  #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index f79604bc0127..27e870d83122 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -74,6 +74,8 @@
>  #include "vmx_onhyperv.h"
>  #include "posted_intr.h"
>  
> +#include "mmu/spte.h"
> +
>  MODULE_AUTHOR("Qumranet");
>  MODULE_DESCRIPTION("KVM support for VMX (Intel VT-x) extensions");
>  MODULE_LICENSE("GPL");
> @@ -959,6 +961,10 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
>  	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
>  		flags |= VMX_RUN_SAVE_SPEC_CTRL;
>  
> +	if (static_branch_unlikely(&mmio_stale_data_clear) &&
> +	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
> +		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
> +
>  	return flags;
>  }
>  
> @@ -7282,7 +7288,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>  	if (static_branch_unlikely(&vmx_l1d_should_flush))
>  		vmx_l1d_flush(vcpu);
>  	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
> -		 kvm_arch_has_assigned_device(vcpu->kvm))
> +		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
>  		mds_clear_cpu_buffers();

I think this also paves way for buffer clear for MDS and MMIO to be done at
a single place. Please let me know if below is feasible:


diff --git a/arch/x86/kvm/vmx/run_flags.h b/arch/x86/kvm/vmx/run_flags.h
index 2f20fb170def..004fe1ca89f0 100644
--- a/arch/x86/kvm/vmx/run_flags.h
+++ b/arch/x86/kvm/vmx/run_flags.h
@@ -2,12 +2,12 @@
 #ifndef __KVM_X86_VMX_RUN_FLAGS_H
 #define __KVM_X86_VMX_RUN_FLAGS_H
 
-#define VMX_RUN_VMRESUME_SHIFT				0
-#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT			1
-#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT	2
+#define VMX_RUN_VMRESUME_SHIFT			0
+#define VMX_RUN_SAVE_SPEC_CTRL_SHIFT		1
+#define VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT		2
 
-#define VMX_RUN_VMRESUME			BIT(VMX_RUN_VMRESUME_SHIFT)
-#define VMX_RUN_SAVE_SPEC_CTRL			BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
-#define VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO_SHIFT)
+#define VMX_RUN_VMRESUME		BIT(VMX_RUN_VMRESUME_SHIFT)
+#define VMX_RUN_SAVE_SPEC_CTRL		BIT(VMX_RUN_SAVE_SPEC_CTRL_SHIFT)
+#define VMX_RUN_CLEAR_CPU_BUFFERS	BIT(VMX_RUN_CLEAR_CPU_BUFFERS_SHIFT)
 
 #endif /* __KVM_X86_VMX_RUN_FLAGS_H */
diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index f6986dee6f8c..ab602ce4967e 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -141,6 +141,8 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Check if vmlaunch or vmresume is needed */
 	bt   $VMX_RUN_VMRESUME_SHIFT, %ebx
 
+	test $VMX_RUN_CLEAR_CPU_BUFFERS, %ebx
+
 	/* Load guest registers.  Don't clobber flags. */
 	mov VCPU_RCX(%_ASM_AX), %_ASM_CX
 	mov VCPU_RDX(%_ASM_AX), %_ASM_DX
@@ -161,8 +163,11 @@ SYM_FUNC_START(__vmx_vcpu_run)
 	/* Load guest RAX.  This kills the @regs pointer! */
 	mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
+	/* Check EFLAGS.ZF from the VMX_RUN_CLEAR_CPU_BUFFERS bit test above */
+	jz .Lskip_clear_cpu_buffers
 	/* Clobbers EFLAGS.ZF */
 	CLEAR_CPU_BUFFERS
+.Lskip_clear_cpu_buffers:
 
 	/* Check EFLAGS.CF from the VMX_RUN_VMRESUME bit test above. */
 	jnc .Lvmlaunch
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1e4790c8993a..1415aeea35f7 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -958,9 +958,10 @@ unsigned int __vmx_vcpu_run_flags(struct vcpu_vmx *vmx)
 	if (!msr_write_intercepted(vmx, MSR_IA32_SPEC_CTRL))
 		flags |= VMX_RUN_SAVE_SPEC_CTRL;
 
-	if (static_branch_unlikely(&mmio_stale_data_clear) &&
-	    kvm_vcpu_can_access_host_mmio(&vmx->vcpu))
-		flags |= VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO;
+	if (cpu_feature_enabled(X86_FEATURE_CLEAR_CPU_BUF) ||
+	    (static_branch_unlikely(&mmio_stale_data_clear) &&
+	     kvm_vcpu_can_access_host_mmio(&vmx->vcpu)))
+		flags |= VMX_RUN_CLEAR_CPU_BUFFERS;
 
 	return flags;
 }
@@ -7296,9 +7297,6 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
-	else if (static_branch_unlikely(&mmio_stale_data_clear) &&
-		 (flags & VMX_RUN_CLEAR_CPU_BUFFERS_FOR_MMIO))
-		mds_clear_cpu_buffers();
 
 	vmx_disable_fb_clear(vmx);
 

