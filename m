Return-Path: <kvm+bounces-17811-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A24118CA50D
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 01:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E78041F2136F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 23:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6134D137C3C;
	Mon, 20 May 2024 23:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SsV5iUFb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E52013B182;
	Mon, 20 May 2024 23:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716247951; cv=none; b=C+0uPeIaR0qKLToNuxfJeOD4zt3dsyXvuv12ffn+8wOAjhzAirTZoPwAR8bGbcDTdY0CBlJOHPmuV4OYmoXCOP5XGV2r+gSRcfUFwuV9fTYCQjpxkwNgo1RLp71WbSbL5yGJdBAPirC83A4u1bpmYrpY6TkP5bFqjF4i8A2NEZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716247951; c=relaxed/simple;
	bh=mUH0poo3WZu/D2vzVGjR2Slhhbi30/G99BYiOxkqqbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmV9T2EZA/eVpbtczUlqWhCoKNWaN+aCTWTh/81spMtfZcTLYLild7qDEmzQF/7OF+dhOdD/b1GuJekBGNoN4Xmxi9HGEgDlDUr7P2k141QiGNUr0CtiEjXnKRVDnrk0rwcViVVieESeKtZP+c0V+h5yK5x4y4yU1mTAM6lbZ6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SsV5iUFb; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716247950; x=1747783950;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=mUH0poo3WZu/D2vzVGjR2Slhhbi30/G99BYiOxkqqbc=;
  b=SsV5iUFbGUMHjNCFeRn66NuQoiMJC+Xk1ZmtldY9e4V02QE6Ty5oKWn7
   Zj0I8jqhdIOWfFQ9JdnACY99WlhsXEmOFVUUSdnop5Ib/YWgtKc6ge1S/
   YE4hNMQlQdg9Ial0UEuWXBI7j6hsJalCNa3u/3EbbCfwbsnzRWELrFj5X
   6+2PjNuz1SVjA6EJqoWBn7sd00DPPyTyL8MAiatTOflgiwco+jf1r0MlR
   sXXSj2xFPhKfR1Urdl+O8yHf5aTwYZPdX7cqYKNplqnO4yC6vlr5ug+ki
   OyMn+1NUK/y/MvsvnUL/IUhTXdusvZFs0MZADYGh9xk6h9RSMvUUBz91u
   Q==;
X-CSE-ConnectionGUID: OWujaOo8TCGoovj05dQM2w==
X-CSE-MsgGUID: NufEeuHoR7mLHOyEBxD4eg==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="34926531"
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="34926531"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 16:32:29 -0700
X-CSE-ConnectionGUID: LKe7FXzcRZGNzaYobLkH/g==
X-CSE-MsgGUID: OvKM7GrQT92aUUZKzWGXrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,176,1712646000"; 
   d="scan'208";a="32738300"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.54])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 16:32:27 -0700
Date: Mon, 20 May 2024 16:32:27 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc: "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@linux.intel.com" <isaku.yamahata@linux.intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/16] KVM: x86/tdp_mmu: Support TDX private mapping for
 TDP MMU
Message-ID: <20240520233227.GA29916@ls.amr.corp.intel.com>
References: <1d247b658f3e9b14cefcfcf7bca01a652d0845a0.camel@intel.com>
 <a08779dc-056c-421c-a573-f0b1ba9da8ad@intel.com>
 <588d801796415df61136ce457156d9ff3f2a2661.camel@intel.com>
 <021e8ee11c87bfac90e886e78795d825ddab32ee.camel@intel.com>
 <eb7417cccf1065b9ac5762c4215195150c114ef8.camel@intel.com>
 <20240516194209.GL168153@ls.amr.corp.intel.com>
 <55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com>
 <20240517090348.GN168153@ls.amr.corp.intel.com>
 <d7b5a1e327d6a91e8c2596996df3ff100992dc6c.camel@intel.com>
 <20240517191630.GC412700@ls.amr.corp.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240517191630.GC412700@ls.amr.corp.intel.com>

On Fri, May 17, 2024 at 12:16:30PM -0700,
Isaku Yamahata <isaku.yamahata@intel.com> wrote:

> > 4. mmio spte doesn't have the shared bit, as previous (no effect)
> > 5. Some zapping code (__tdp_mmu_zap_root(), tdp_mmu_zap_leafs()) intends to
> > actually operating on the raw_gfn. It wants to iterate the whole EPT, so it goes
> > from 0 to tdp_mmu_max_gfn_exclusive(). So now for mirrored it does, but for
> > shared it only covers the shared range. Basically kvm_mmu_max_gfn() is wrong if
> > we pretend shared GFNs are just strangely mapped normal GFNs. Maybe we could
> > just fix this up to report based on GPAW for TDX? Feels wrong.
> 
> Yes, it's broken with kvm_mmu_max_gfn().

I looked into this one.  I think we need to adjust the value even for VMX case.
I have something at the bottom.  What do you think?  I compiled it only at the
moment. This is to show the idea.


Based on "Intel Trust Domain CPU Architectural Extensions"
There are four cases to consider.
- TDX Shared-EPT with 5-level EPT with host max_pa > 47
  mmu_max_gfn should be host max gfn - (TDX key bits)

- TDX Shared-EPT with 4-level EPT with host max_pa > 47
  The host allows 5-level.  The guest doesn't need it. So use 4-level.
  mmu_max_gfn should be 47 = min(47, host max gfn - (TDX key bits))).

- TDX Shared-EPT with 4-level EPT with host max_pa < 48
  mmu_max_gfn should be min(47, host max gfn - (TDX key bits)))

- The value for Shared-EPT works for TDX Secure-EPT.

- For VMX case (with TDX CPU extension enabled)
  mmu_max_gfn should be host max gfn - (TDX key bits)
  For VMX only with TDX disabled, TDX key bits == 0.

So kvm_mmu_max_gfn() need to be per-VM value.  And now gfn_shared_mask() is
out side of guest max PA.  
(Maybe we'd like to check if guest cpuid[0x8000:0008] matches with those.)

Citation from "Intel Trust Domain CPU Architectural Extensions" for those
interested in the related sentences:

1.4.2 Guest Physical Address Translation
  Transition to SEAM VMX non-root operation is formatted to require Extended
  Page Tables (EPT) to be enabled. In SEAM VMX non-root operation, there should
  be two EPTs active: the private EPT specified using the EPTP field of the VMCS
  and a shared EPT specified using the Shared-EPTP field of the VMCS.
  When translating a GPA using the shared EPT, an EPT misconfiguration can occur
  if the entry is present and the physical address bits in the range
  (MAXPHYADDR-1) to (MAXPHYADDR-TDX_RESERVED_KEYID_BITS) are set, i.e., if
  configured with a TDX private KeyID.
  If the CPU's maximum physical-address width (MAXPA) is 52 and the guest
  physical address width is configured to be 48, accesses with GPA bits 51:48
  not all being 0 can cause an EPT-violation, where such EPT-violations are not
  mutated to #VE, even if the “EPT-violations #VE” execution control is 1.
  If the CPU's physical-address width (MAXPA) is less than 48 and the SHARED bit
  is configured to be in bit position 47, GPA bit 47 would be reserved, and GPA
  bits 46:MAXPA would be reserved. On such CPUs, setting bits 51:48 or bits
  46:MAXPA in any paging structure can cause a reserved bit page fault on
  access.

1.5 OPERATION OUTSIDE SEAM
  The physical address bits reserved for encoding TDX private KeyID are meant to
  be treated as reserved bits when not in SEAM operation.
  When translating a linear address outside SEAM, if any paging structure entry
  has bits reserved for TDX private KeyID encoding in the physical address set,
  then the processor helps generate a reserved bit page fault exception.  When
  translating a guest physical address outside SEAM, if any EPT structure entry
  has bits reserved for TDX private KeyID encoding in the physical address set,
  then the processor helps generate an EPT misconfiguration


diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e3df14142db0..4ea6ad407a3d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1559,6 +1559,7 @@ struct kvm_arch {
 #define SPLIT_DESC_CACHE_MIN_NR_OBJECTS (SPTE_ENT_PER_PAGE + 1)
 	struct kvm_mmu_memory_cache split_desc_cache;
 
+	gfn_t mmu_max_gfn;
 	gfn_t gfn_shared_mask;
 };
 
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index bab9b0c4f0a9..fcb7197f7487 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -64,7 +64,7 @@ static __always_inline u64 rsvd_bits(int s, int e)
  */
 extern u8 __read_mostly shadow_phys_bits;
 
-static inline gfn_t kvm_mmu_max_gfn(void)
+static inline gfn_t __kvm_mmu_max_gfn(void)
 {
 	/*
 	 * Note that this uses the host MAXPHYADDR, not the guest's.
@@ -82,6 +82,11 @@ static inline gfn_t kvm_mmu_max_gfn(void)
 	return (1ULL << (max_gpa_bits - PAGE_SHIFT)) - 1;
 }
 
+static inline gfn_t kvm_mmu_max_gfn(struct kvm *kvm)
+{
+	return kvm->arch.mmu_max_gfn;
+}
+
 static inline u8 kvm_get_shadow_phys_bits(void)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1fb6055b1565..25da520e81d6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3333,7 +3333,7 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
 	 * only if L1's MAXPHYADDR is inaccurate with respect to the
 	 * hardware's).
 	 */
-	if (unlikely(fault->gfn > kvm_mmu_max_gfn()))
+	if (unlikely(fault->gfn > kvm_mmu_max_gfn(vcpu->kvm)))
 		return RET_PF_EMULATE;
 
 	return RET_PF_CONTINUE;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 630acf2b17f7..04b3c83f21a0 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -952,7 +952,7 @@ static inline bool __must_check tdp_mmu_iter_cond_resched(struct kvm *kvm,
 	return iter->yielded;
 }
 
-static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
+static inline gfn_t tdp_mmu_max_gfn_exclusive(struct kvm *kvm)
 {
 	/*
 	 * Bound TDP MMU walks at host.MAXPHYADDR.  KVM disallows memslots with
@@ -960,7 +960,7 @@ static inline gfn_t tdp_mmu_max_gfn_exclusive(void)
 	 * MMIO SPTEs for "impossible" gfns, instead sending such accesses down
 	 * the slow emulation path every time.
 	 */
-	return kvm_mmu_max_gfn() + 1;
+	return kvm_mmu_max_gfn(kvm) + 1;
 }
 
 static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
@@ -968,7 +968,7 @@ static void __tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	gfn_t end = tdp_mmu_max_gfn_exclusive();
+	gfn_t end = tdp_mmu_max_gfn_exclusive(kvm);
 	gfn_t start = 0;
 
 	for_each_tdp_pte_min_level(kvm, iter, root, zap_level, start, end) {
@@ -1069,7 +1069,7 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 {
 	struct tdp_iter iter;
 
-	end = min(end, tdp_mmu_max_gfn_exclusive());
+	end = min(end, tdp_mmu_max_gfn_exclusive(kvm));
 
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a3c39bd783d6..025d51a55505 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -12,6 +12,8 @@
 static bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
 
+static gfn_t __ro_after_init mmu_max_gfn;
+
 #if IS_ENABLED(CONFIG_HYPERV) || IS_ENABLED(CONFIG_INTEL_TDX_HOST)
 static int vt_flush_remote_tlbs(struct kvm *kvm);
 #endif
@@ -24,6 +26,27 @@ static void vt_hardware_disable(void)
 	vmx_hardware_disable();
 }
 
+#define MSR_IA32_TME_ACTIVATE	0x982
+#define MKTME_UNINITIALIZED	2
+#define TME_ACTIVATE_LOCKED	BIT_ULL(0)
+#define TME_ACTIVATE_ENABLED	BIT_ULL(1)
+#define TDX_RESERVED_KEYID_BITS(tme_activate)	\
+	(((tme_activate) & GENMASK_ULL(39, 36)) >> 36)
+
+static void vt_adjust_max_pa(void)
+{
+	u64 tme_activate;
+
+	mmu_max_gfn = __kvm_mmu_max_gfn();
+
+	rdmsrl(MSR_IA32_TME_ACTIVATE, tme_activate);
+	if (!(tme_activate & TME_ACTIVATE_LOCKED) ||
+	    !(tme_activate & TME_ACTIVATE_ENABLED))
+		return;
+
+	mmu_max_gfn -= (gfn_t)TDX_RESERVED_KEYID_BITS(tme_activate);
+}
+
 static __init int vt_hardware_setup(void)
 {
 	int ret;
@@ -69,6 +92,8 @@ static __init int vt_hardware_setup(void)
 		vt_x86_ops.flush_remote_tlbs = vt_flush_remote_tlbs;
 #endif
 
+	vt_adjust_max_pa();
+
 	return 0;
 }
 
@@ -89,6 +114,8 @@ static int vt_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 
 static int vt_vm_init(struct kvm *kvm)
 {
+	kvm->arch.mmu_max_gfn = mmu_max_gfn;
+
 	if (is_td(kvm))
 		return tdx_vm_init(kvm);
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 3be4b8ff7cb6..206ad053cbad 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2610,8 +2610,11 @@ static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 
 	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
 		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(51));
-	else
+	else {
 		kvm->arch.gfn_shared_mask = gpa_to_gfn(BIT_ULL(47));
+		kvm->arch.mmu_max_gfn = min(kvm->arch.mmu_max_gfn,
+					    gpa_to_gfn(BIT_ULL(47)));
+	}
 
 out:
 	/* kfree() accepts NULL. */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7f89405c8bc4..c519bb9c9559 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12693,6 +12693,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (ret)
 		goto out;
 
+	kvm->arch.mmu_max_gfn = __kvm_mmu_max_gfn();
 	kvm_mmu_init_vm(kvm);
 
 	ret = static_call(kvm_x86_vm_init)(kvm);
@@ -13030,7 +13031,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 		return -EINVAL;
 
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE) {
-		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn())
+		if ((new->base_gfn + new->npages - 1) > kvm_mmu_max_gfn(kvm))
 			return -EINVAL;
 
 #if 0
  
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

