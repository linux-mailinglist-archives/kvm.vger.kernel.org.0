Return-Path: <kvm+bounces-11597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E3E0878B00
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 23:56:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E65112824EA
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 22:56:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48EF58AA1;
	Mon, 11 Mar 2024 22:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d3/GJRCq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 219A55820E;
	Mon, 11 Mar 2024 22:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710197774; cv=none; b=iAd3V8ys+JKCGXb7zFfHcWDtztuc2r7zMdUauuxek5JzRNrbZDlrCZrjHPdmqlMtu18ynjSCAzx7xMOBkZm32c5jh+3lO9xiL97KWtvUO6KCeCJv1qe7v2d5U6qyotHP6CSOFD0qllaN4LvBBIAmYtojjy3BLuU8ozpaU6+bj+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710197774; c=relaxed/simple;
	bh=WF8Ohh64A76fCksRVYwYwuKxjTuUn10ghM+Q4PVZSRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=itZMViIOCL0IuDgiDdpz02aN7OIMTlP90ONxVszhCFaT+/iwTkddnjsBQah3jq4rGFWv3ALWNKGMvIWv63c+iuWRD0svMXSLf6vuZn0KyebHzEtTSsMr/59jXtrhtkLlqz8PidLRaprTgWigQA2gsc0IV+EeUOT9Pucv/8s1yXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d3/GJRCq; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710197773; x=1741733773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WF8Ohh64A76fCksRVYwYwuKxjTuUn10ghM+Q4PVZSRM=;
  b=d3/GJRCqe/Q8T48YKS/SDwMFJhTV+9YrPmSo2wFPiojStUwvYpELgR9/
   lsDjfGPKBt6nm79Ca8cfXDdf9POcsdzCk0iaJ0/EvY89zJhLrzRoz94li
   cOQHxPEbpx6oGDJB1O/o6r6xfVLTruFq36IEBatsggnQC5exRh+YTXAOQ
   2EQqjOXEY3oSSvVZi0E/yaJTU5nri1zzRX0no2emeoVtJoYSpY1hZgCq3
   gQqIQB+BMdwegkWt/FvKfqyNqQmYOLtOKaukKbDGRYO4Z5NZfC+J9eWmB
   FJeQI5j+SA0gUxn2Xb2tOt8mpAs3GeBaHbZREG8D7jGvp9J/RUu+Hv0ZE
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="15524628"
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="15524628"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 15:56:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,117,1708416000"; 
   d="scan'208";a="34497033"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 15:56:12 -0700
Date: Mon, 11 Mar 2024 15:56:11 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	isaku.yamahata@linux.intel.com
Subject: Re: [RFC PATCH 3/8] KVM: x86/mmu: Introduce initialier macro for
 struct kvm_page_fault
Message-ID: <20240311225611.GB935089@ls.amr.corp.intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
 <b045dc17abd4f1330406964528ade5722ab63aa1.1709288671.git.isaku.yamahata@intel.com>
 <Ze8-YlvprcKou-Ho@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ze8-YlvprcKou-Ho@google.com>

On Mon, Mar 11, 2024 at 10:24:50AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Mar 01, 2024, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Another function will initialize struct kvm_page_fault.  Add initializer
> > macro to unify the big struct initialization.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/mmu/mmu_internal.h | 44 +++++++++++++++++++--------------
> >  1 file changed, 26 insertions(+), 18 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> > index 0669a8a668ca..72ef09fc9322 100644
> > --- a/arch/x86/kvm/mmu/mmu_internal.h
> > +++ b/arch/x86/kvm/mmu/mmu_internal.h
> > @@ -279,27 +279,35 @@ enum {
> >  	RET_PF_SPURIOUS,
> >  };
> >  
> > +#define KVM_PAGE_FAULT_INIT(_vcpu, _cr2_or_gpa, _err, _prefetch, _max_level) {	\
> > +	.addr = (_cr2_or_gpa),							\
> > +	.error_code = (_err),							\
> > +	.exec = (_err) & PFERR_FETCH_MASK,					\
> > +	.write = (_err) & PFERR_WRITE_MASK,					\
> > +	.present = (_err) & PFERR_PRESENT_MASK,					\
> > +	.rsvd = (_err) & PFERR_RSVD_MASK,					\
> > +	.user = (_err) & PFERR_USER_MASK,					\
> > +	.prefetch = (_prefetch),						\
> > +	.is_tdp =								\
> > +	likely((_vcpu)->arch.mmu->page_fault == kvm_tdp_page_fault),		\
> > +	.nx_huge_page_workaround_enabled =					\
> > +	is_nx_huge_page_enabled((_vcpu)->kvm),					\
> > +										\
> > +	.max_level = (_max_level),						\
> > +	.req_level = PG_LEVEL_4K,						\
> > +	.goal_level = PG_LEVEL_4K,						\
> > +	.is_private =								\
> > +	kvm_mem_is_private((_vcpu)->kvm, (_cr2_or_gpa) >> PAGE_SHIFT),		\
> > +										\
> > +	.pfn = KVM_PFN_ERR_FAULT,						\
> > +	.hva = KVM_HVA_ERR_BAD, }
> > +
> 
> Oof, no.  I would much rather refactor kvm_mmu_do_page_fault() as needed than
> have to maintain a macro like this.

Ok, I updated it as follows.

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0669a8a668ca..e57cc3c56a6d 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -279,8 +279,8 @@ enum {
 	RET_PF_SPURIOUS,
 };
 
-static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch, int *emulation_type)
+static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+					  u32 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
@@ -307,6 +307,21 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
 	}
 
+	if (IS_ENABLED(CONFIG_RETPOLINE) && fault.is_tdp)
+		r = kvm_tdp_page_fault(vcpu, &fault);
+	else
+		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
+
+	if (fault.write_fault_to_shadow_pgtable && emulation_type)
+		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
+	return r;
+}
+
+static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+					u32 err, bool prefetch, int *emulation_type)
+{
+	int r;
+
 	/*
 	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
 	 * guest perspective and have already been counted at the time of the
@@ -315,13 +330,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	if (!prefetch)
 		vcpu->stat.pf_taken++;
 
-	if (IS_ENABLED(CONFIG_RETPOLINE) && fault.is_tdp)
-		r = kvm_tdp_page_fault(vcpu, &fault);
-	else
-		r = vcpu->arch.mmu->page_fault(vcpu, &fault);
-
-	if (fault.write_fault_to_shadow_pgtable && emulation_type)
-		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
+	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch, emulation_type);
 
 	/*
 	 * Similar to above, prefetch faults aren't truly spurious, and the
-- 
2.43.2

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

