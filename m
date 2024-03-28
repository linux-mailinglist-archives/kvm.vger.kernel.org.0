Return-Path: <kvm+bounces-12917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11AFF88F3B0
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB5222A7682
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:27:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B252AF9E4;
	Thu, 28 Mar 2024 00:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="akOphw9O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24FBBE4F;
	Thu, 28 Mar 2024 00:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711585505; cv=none; b=dElDsgcr1r8evbqgqVU507GXVK0EJ2VyJqp3Rs1PCOpgNaH823gJ3uN7G8ykHLXWhGhx+F6HL3JkhydLh9n36rqXMk3FIDfx3f8ke+Ut6YqGB+wz+9egFebCoEcjT22ju3VuE9pFvukKY+5Nwr/ksfXCCOIBZ+t3rTEbAdEZWik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711585505; c=relaxed/simple;
	bh=wpGIuibnrkqUFYM1zvbRlOwDJNADae7qqIAevX/+Jks=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qLtui+ZtmvOXJ3N8UdRjFWpeHMgib3ReGuu6IoL12/jD9SxEg5BqfMSSwNHzYr4hM3PT1F0CSVnPmg+D3Nc5+g3yPvYG3MvkwdLYVhBwGg599TCoIQWR9AgxxwTt9w0Vj7m8TbS4bOwWARIZ+Xv3Fwd7uruckPSxq+JftlXa4VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=akOphw9O; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711585504; x=1743121504;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=wpGIuibnrkqUFYM1zvbRlOwDJNADae7qqIAevX/+Jks=;
  b=akOphw9ONMJB+DARg9bBCz08J7T8QqNGSlGJGMAzoPmTZ5saCxQvuWzN
   HP0OIz0dhVl/UyhXCtsU1OJxy+6AmZUPX2YQsxGmhaj8/ntywFRtGG9Yr
   TeWmYvOYEdNQxuvMcfVzB3pSf9l+8RyxXB3H/ipqLqcpwzZJI6feII0/y
   dXimntZLH/zM9GCunKzRk1V/ylPwxaxHpN2mTn9vRLO6+WvqHAhWprIRL
   qPTwccAcyKt/05+luevH/8i/jsnnbt4AjBlRSqxYMepE6Wg6ZH7nHB7Dg
   Z9vDCcRxzq7wSo/WFmO1IQfm7HSb6UjVTi18RMs2gKYOM6tOxm8dvj55O
   g==;
X-CSE-ConnectionGUID: 9iKD8o90S+uRNcyKYUQZ8A==
X-CSE-MsgGUID: ceDbED2sTDy4UijyvmRVuA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="10501479"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="10501479"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:25:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21183958"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:25:03 -0700
Date: Wed, 27 Mar 2024 17:25:02 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 062/130] KVM: x86/tdp_mmu: Support TDX private
 mapping for TDP MMU
Message-ID: <20240328002502.GL2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <fc97847d04f2b469d8f4cfceee84c7ef055ab1ac.1708933498.git.isaku.yamahata@intel.com>
 <ZgQaCcdb4AshplI6@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgQaCcdb4AshplI6@chao-email>

On Wed, Mar 27, 2024 at 09:07:21PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> > 			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
> >@@ -4662,6 +4667,7 @@ int kvm_mmu_map_tdp_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> > 	};
> > 
> > 	WARN_ON_ONCE(!vcpu->arch.mmu->root_role.direct);
> >+	fault.gfn = gpa_to_gfn(fault.addr) & ~kvm_gfn_shared_mask(vcpu->kvm);
> 
> Could you clarify when shared bits need to be masked out or kept? shared bits
> are masked out here but kept in the hunk right above and ..

Sure, it deserves comment. I'll add a comment.

When we gets pfn, kvm_faultin_pfn() or loop with kvm memslot,
drop shared bits because KVM memslot doesn't know about shared bit.

When walks in EPT tables, keep the shared bit because we need to find the EPT
entry including shared bit.



> >+++ b/arch/x86/kvm/mmu/tdp_iter.h
> >@@ -91,7 +91,7 @@ struct tdp_iter {
> > 	tdp_ptep_t pt_path[PT64_ROOT_MAX_LEVEL];
> > 	/* A pointer to the current SPTE */
> > 	tdp_ptep_t sptep;
> >-	/* The lowest GFN mapped by the current SPTE */
> >+	/* The lowest GFN (shared bits included) mapped by the current SPTE */
> > 	gfn_t gfn;
> 
> .. in @gfn of tdp_iter.
> 
> > 	/* The level of the root page given to the iterator */
> > 	int root_level;
> 
> 
> > 
> >-hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> >+static struct kvm_mmu_page *kvm_tdp_mmu_get_vcpu_root(struct kvm_vcpu *vcpu,
> 
> Maybe fold it into its sole caller.

Sure.


> 
> >+						      bool private)
> > {
> > 	union kvm_mmu_page_role role = vcpu->arch.mmu->root_role;
> > 	struct kvm *kvm = vcpu->kvm;
> >@@ -221,6 +225,8 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> > 	 * Check for an existing root before allocating a new one.  Note, the
> > 	 * role check prevents consuming an invalid root.
> > 	 */
> >+	if (private)
> >+		kvm_mmu_page_role_set_private(&role);
> > 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
> > 		if (root->role.word == role.word &&
> > 		    kvm_tdp_mmu_get_root(root))
> >@@ -244,12 +250,17 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
> > 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > 
> > out:
> >-	return __pa(root->spt);
> >+	return root;
> >+}
> >+
> >+hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu, bool private)
> >+{
> >+	return __pa(kvm_tdp_mmu_get_vcpu_root(vcpu, private)->spt);
> > }
> > 
> > static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
> >-				u64 old_spte, u64 new_spte, int level,
> >-				bool shared);
> >+				u64 old_spte, u64 new_spte,
> >+				union kvm_mmu_page_role role, bool shared);
> > 
> > static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
> > {
> >@@ -376,12 +387,78 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
> > 							  REMOVED_SPTE, level);
> > 		}
> > 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
> >-				    old_spte, REMOVED_SPTE, level, shared);
> >+				    old_spte, REMOVED_SPTE, sp->role,
> >+				    shared);
> >+	}
> >+
> >+	if (is_private_sp(sp) &&
> >+	    WARN_ON(static_call(kvm_x86_free_private_spt)(kvm, sp->gfn, sp->role.level,
> 
> WARN_ON_ONCE()?
> 
> >+							  kvm_mmu_private_spt(sp)))) {
> >+		/*
> >+		 * Failed to unlink Secure EPT page and there is nothing to do
> >+		 * further.  Intentionally leak the page to prevent the kernel
> >+		 * from accessing the encrypted page.
> >+		 */
> >+		kvm_mmu_init_private_spt(sp, NULL);
> > 	}
> > 
> > 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
> > }
> > 
> 
> > 	rcu_read_lock();
> > 
> > 	for_each_tdp_pte_min_level(iter, root, PG_LEVEL_4K, start, end) {
> >@@ -960,10 +1158,26 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
> > 
> > 	if (unlikely(!fault->slot))
> > 		new_spte = make_mmio_spte(vcpu, iter->gfn, ACC_ALL);
> >-	else
> >-		wrprot = make_spte(vcpu, sp, fault->slot, ACC_ALL, iter->gfn,
> >-					 fault->pfn, iter->old_spte, fault->prefetch, true,
> >-					 fault->map_writable, &new_spte);
> >+	else {
> >+		unsigned long pte_access = ACC_ALL;
> >+		gfn_t gfn = iter->gfn;
> >+
> >+		if (kvm_gfn_shared_mask(vcpu->kvm)) {
> >+			if (fault->is_private)
> >+				gfn |= kvm_gfn_shared_mask(vcpu->kvm);
> 
> this is an open-coded kvm_gfn_to_shared().
> 
> I don't get why a spte is installed for a shared gfn when fault->is_private
> is true. could you elaborate?

This is stale code. And you're right. I'll remove this part.


> >+			else
> >+				/*
> >+				 * TDX shared GPAs are no executable, enforce
> >+				 * this for the SDV.
> >+				 */
> 
> what do you mean by the SDV?

That's development nonsense. I'll remove the second sentence.


> >+				pte_access &= ~ACC_EXEC_MASK;
> >+		}
> >+
> >+		wrprot = make_spte(vcpu, sp, fault->slot, pte_access, gfn,
> >+				   fault->pfn, iter->old_spte,
> >+				   fault->prefetch, true, fault->map_writable,
> >+				   &new_spte);
> >+	}
> > 
> > 	if (new_spte == iter->old_spte)
> > 		ret = RET_PF_SPURIOUS;
> >@@ -1041,6 +1255,8 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > 	struct kvm *kvm = vcpu->kvm;
> > 	struct tdp_iter iter;
> > 	struct kvm_mmu_page *sp;
> >+	gfn_t raw_gfn;
> >+	bool is_private = fault->is_private && kvm_gfn_shared_mask(kvm);
> > 	int ret = RET_PF_RETRY;
> > 
> > 	kvm_mmu_hugepage_adjust(vcpu, fault);
> >@@ -1049,7 +1265,17 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > 
> > 	rcu_read_lock();
> > 
> >-	tdp_mmu_for_each_pte(iter, mmu, fault->gfn, fault->gfn + 1) {
> >+	raw_gfn = gpa_to_gfn(fault->addr);
> >+
> >+	if (is_error_noslot_pfn(fault->pfn) ||
> >+	    !kvm_pfn_to_refcounted_page(fault->pfn)) {
> >+		if (is_private) {
> >+			rcu_read_unlock();
> >+			return -EFAULT;
> 
> This needs a comment. why this check is necessary? does this imply some
> kernel bugs?

Will add a comment. It's due to the current TDX KVM implementation that
increments the page refcount.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

