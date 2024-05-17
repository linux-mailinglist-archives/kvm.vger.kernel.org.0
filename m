Return-Path: <kvm+bounces-17586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B2AE68C82FA
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 11:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DE4151C20DCB
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 09:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26A6D1EB37;
	Fri, 17 May 2024 09:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HW2jEbKW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABD91CFBC;
	Fri, 17 May 2024 09:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715936917; cv=none; b=qnxEP/wRd1ahVCXjysHt6Qv1MMkRsVHnPmCti56JLo6GXgU1uO6RQELUi6hTaK1Z7vxIIrcoaUG1NfiHdd8AMz3vMJpzunsZeCPpuG9uH9+5AuANk3nJHPt5ZuJyB4zIYsbflLzVoOCKesB7fWN38LCegE336y71oNpMtLIbciY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715936917; c=relaxed/simple;
	bh=YODNO5tbB4PJIVxHwYE0QICZOUVnQn6CrE6O71s2KIg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eTairyaYbK4H4ICP1CulW+6NlsflLfCscpv19o4LRegIBlU0arS/LwB9fnaVej+R7bcl0qc46lb5iWEri7d/qLq+bY/0GdlSKsu3ora+DvrAjrNLlz9eCN7aqi4rPgYl/nkIsv6GpcnFNN+wka17z7nfk+Kx5+oG3rhKvB5+mAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HW2jEbKW; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715936916; x=1747472916;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YODNO5tbB4PJIVxHwYE0QICZOUVnQn6CrE6O71s2KIg=;
  b=HW2jEbKW4rOQ7V8kUZImXCc7SNBZHoddolb4ZI79JWEB1cgqLYLrViWu
   43NI6kUGEET2RY053k43o3TnWhcVcgxKi7Wt/XpgRx7PCLTXqmk/JlTIf
   PmteNUuRYSLCwHprr3Ljh59WuwTFD2wylOmmImLWNKdKh3jpz+vX9zmWZ
   TrLG2GLIgVkJm80hbNumL4RvfxYvlODkifFM+6q4c5kUIDLDAWLU9fA+0
   2abAH1xrDJNakPGI/1TVIJzWkM+wh6XjjkmfQzAZmUeAYetvkAHhK6Z6D
   G+XK16+04BvK6JJDXwJwWSoEAIUQvQ7gkFNQjNbve0catgdz6V7dwo2g3
   w==;
X-CSE-ConnectionGUID: vH2iSxVNSiC/WQpi2DTNRg==
X-CSE-MsgGUID: MgombG2jSrm2E45GOIpw9g==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22682940"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="22682940"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 02:08:36 -0700
X-CSE-ConnectionGUID: vR/Uf+HMSOaNiTDCwOhGcA==
X-CSE-MsgGUID: yOB/NKFRQamYLLbHzwz/aA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="36469812"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 02:08:35 -0700
Date: Fri, 17 May 2024 02:08:34 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com,
	seanjc@google.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	erdemaktas@google.com, sagis@google.com, yan.y.zhao@intel.com,
	dmatlack@google.com
Subject: Re: [PATCH 03/16] KVM: x86/tdp_mmu: Add a helper function to walk
 down the TDP MMU
Message-ID: <20240517090834.GO168153@ls.amr.corp.intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-4-rick.p.edgecombe@intel.com>
 <ZkcK29svLIlX3Jr9@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZkcK29svLIlX3Jr9@chao-email>

On Fri, May 17, 2024 at 03:44:27PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Tue, May 14, 2024 at 05:59:39PM -0700, Rick Edgecombe wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >Export a function to walk down the TDP without modifying it.
> >
> >Future changes will support pre-populating TDX private memory. In order to
> >implement this KVM will need to check if a given GFN is already
> >pre-populated in the mirrored EPT, and verify the populated private memory
> >PFN matches the current one.[1]
> >
> >There is already a TDP MMU walker, kvm_tdp_mmu_get_walk() for use within
> >the KVM MMU that almost does what is required. However, to make sense of
> >the results, MMU internal PTE helpers are needed. Refactor the code to
> >provide a helper that can be used outside of the KVM MMU code.
> >
> >Refactoring the KVM page fault handler to support this lookup usage was
> >also considered, but it was an awkward fit.
> >
> >Link: https://lore.kernel.org/kvm/ZfBkle1eZFfjPI8l@google.com/ [1]
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> >---
> >This helper will be used in the future change that implements
> >KVM_TDX_INIT_MEM_REGION. Please refer to the following commit for the
> >usage:
> >https://github.com/intel/tdx/commit/2832c6d87a4e6a46828b193173550e80b31240d4
> >
> >TDX MMU Part 1:
> > - New patch
> >---
> > arch/x86/kvm/mmu.h         |  3 +++
> > arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++++++++++++++++----
> > 2 files changed, 36 insertions(+), 4 deletions(-)
> >
> >diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> >index dc80e72e4848..3c7a88400cbb 100644
> >--- a/arch/x86/kvm/mmu.h
> >+++ b/arch/x86/kvm/mmu.h
> >@@ -275,6 +275,9 @@ extern bool tdp_mmu_enabled;
> > #define tdp_mmu_enabled false
> > #endif
> > 
> >+int kvm_tdp_mmu_get_walk_private_pfn(struct kvm_vcpu *vcpu, u64 gpa,
> >+				     kvm_pfn_t *pfn);
> >+
> > static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
> > {
> > 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
> >diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> >index 1259dd63defc..1086e3b2aa5c 100644
> >--- a/arch/x86/kvm/mmu/tdp_mmu.c
> >+++ b/arch/x86/kvm/mmu/tdp_mmu.c
> >@@ -1772,16 +1772,14 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
> >  *
> >  * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
> >  */
> >-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> >-			 int *root_level)
> >+static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> >+				  bool is_private)
> 
> is_private isn't used.
> 
> > {
> > 	struct tdp_iter iter;
> > 	struct kvm_mmu *mmu = vcpu->arch.mmu;
> > 	gfn_t gfn = addr >> PAGE_SHIFT;
> > 	int leaf = -1;
> > 
> >-	*root_level = vcpu->arch.mmu->root_role.level;
> >-
> > 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> > 		leaf = iter.level;
> > 		sptes[leaf] = iter.old_spte;
> >@@ -1790,6 +1788,37 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> > 	return leaf;
> > }
> > 
> >+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> >+			 int *root_level)
> >+{
> >+	*root_level = vcpu->arch.mmu->root_role.level;
> >+
> >+	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, false);
> >+}
> >+
> >+int kvm_tdp_mmu_get_walk_private_pfn(struct kvm_vcpu *vcpu, u64 gpa,
> >+				     kvm_pfn_t *pfn)
> 
> private_pfn probably is a misnomer. shared/private is an attribute of
> GPA rather than pfn. Since the function is to get pfn from gpa, how about
> kvm_tdp_mmu_gpa_to_pfn()?
> 
> And the function is limited to handle private gpa only. It is an artificial
> limitation we can get rid of easily. e.g., by making the function take
> "is_private" boolean and relay it to __kvm_tdp_mmu_get_walk(). I know TDX
> just calls the function to convert private gpa but having a generic API
> can accommodate future use cases (e.g., get hpa from shared gpa) w/o the
> need of refactoring.

Agreed.  Based on a patch at [1], we can have something like
int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 gpa,
                         enum kvm_tdp_mmu_root_types root_type,
                         kvm_pfn_t *pfn);


[1] https://lore.kernel.org/kvm/55c24448fdf42d383d45601ff6c0b07f44f61787.camel@intel.com/
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

