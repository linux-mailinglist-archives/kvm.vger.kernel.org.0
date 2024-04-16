Return-Path: <kvm+bounces-14910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D8B8A7944
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 01:43:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57040B21CB7
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 23:43:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FC6913AA3A;
	Tue, 16 Apr 2024 23:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ScFb9Qhc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1988113A415;
	Tue, 16 Apr 2024 23:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713311018; cv=none; b=TqDKpOD84vJ8KCUZxVheUPPp01K1XtiUNGBg9NreijF+zpQkpxixzzWn+HrlsyDEjNl1TjyDDES9zCyZF40VlKD7bBi7VbLX5C/5WtFja22zeW5t7zAm0NUZ/iuhk2WIE74eMHKnZjOOJt7b28UVOTAwE+l8aZJyCfdBhb75fdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713311018; c=relaxed/simple;
	bh=8aUqXz+i9chtNJef9my3dWa4P1+x056EvnBQkIpWUR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4ZwGzCLKjfhB6XKfNBhtcN2HXXP0NeLmbw+X+ROstlqwXqpNtPs0OIuUeAQeUNkCUPrhDOZaljF97zPR0BLRQ8AnFzBBC0pamTsqo3mylrGUZR+hX3BE7EghHPRTHBqfHy1SePXzoS8KPyN7Yf5IchiGrbKS6n8Y9yODq0ODPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ScFb9Qhc; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713311016; x=1744847016;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8aUqXz+i9chtNJef9my3dWa4P1+x056EvnBQkIpWUR8=;
  b=ScFb9QhcCypvNMmgU0lDLbqUYks3Je3MDtnw2AfMuIxOfGztcU7aJX7D
   H8lV6z55FNFM8yaiu0mCVq26oHSA73X8PS7TA1XT3Lx1XM35I3rBMST0d
   l8MJmEGqp7WDfkH+QHhqN0BdzjoPDwLNQfOeXgkzv3aQZBLHSxecwpMh1
   TwnJZpVk5srGakibMsSlJ0+y1tWwgyeFfdfzbhfxYRQuZCNDtKkcf17py
   YLHtnN3mqxL0xiE1I3PCd3DqXFKozaRrPePv9vJvHMWu8CW4+y2iYicFz
   DbQFvS7M9YI+xYnOBLNI8c4EqhSLfn7tNkq/p9+pK47RB0YeX0e3HXgQb
   g==;
X-CSE-ConnectionGUID: TdUH60YqTuKhfLP9reL6YQ==
X-CSE-MsgGUID: jNx1m/9pRuqzBIlHJBLQ1g==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8645383"
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="8645383"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 16:43:35 -0700
X-CSE-ConnectionGUID: fS8w87q+Rv2YO7ZuLxYjmw==
X-CSE-MsgGUID: OGrvR6teSV+HtibVE03PkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,207,1708416000"; 
   d="scan'208";a="22834585"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 16:43:35 -0700
Date: Tue, 16 Apr 2024 16:43:34 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Chao Gao <chao.gao@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org, isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	David Matlack <dmatlack@google.com>,
	Federico Parola <federico.parola@polito.it>,
	Kai Huang <kai.huang@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v2 03/10] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
Message-ID: <20240416234334.GA3039520@ls.amr.corp.intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
 <Zh41S8fh0IvXlKwX@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zh41S8fh0IvXlKwX@chao-email>

On Tue, Apr 16, 2024 at 04:22:35PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> 
> >This patch makes the emulation_type always set irrelevant to the return
> >code.  kvm_mmu_page_fault() is the only caller of kvm_mmu_do_page_fault(),
> >and references the value only when PF_RET_EMULATE is returned.  Therefore,
> >this adjustment doesn't affect functionality.
>
> This is benign. But what's the benefit of doing this?

To avoid increment vcpu->stat.  Because originally this was VM ioctl, I wanted
to avoid touch vCPU stat.  Now it's vCPU ioctl, it's fine to increment them.

Probably we can drop this patch and use kvm_mmu_do_page_fault().

> 
> >+static inline int __kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >+					  u64 err, bool prefetch, int *emulation_type)
> > {
> > 	struct kvm_page_fault fault = {
> > 		.addr = cr2_or_gpa,
> >@@ -318,14 +318,6 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > 		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
> > 	}
> > 
> >-	/*
> >-	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
> >-	 * guest perspective and have already been counted at the time of the
> >-	 * original fault.
> >-	 */
> >-	if (!prefetch)
> >-		vcpu->stat.pf_taken++;
> >-
> > 	if (IS_ENABLED(CONFIG_MITIGATION_RETPOLINE) && fault.is_tdp)
> > 		r = kvm_tdp_page_fault(vcpu, &fault);
> > 	else
> >@@ -333,12 +325,30 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> > 
> > 	if (r == RET_PF_EMULATE && fault.is_private) {
> > 		kvm_mmu_prepare_memory_fault_exit(vcpu, &fault);
> >-		return -EFAULT;
> >+		r = -EFAULT;
> > 	}
> > 
> > 	if (fault.write_fault_to_shadow_pgtable && emulation_type)
> > 		*emulation_type |= EMULTYPE_WRITE_PF_TO_SP;
> > 
> >+	return r;
> >+}
> >+
> >+static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
> >+					u64 err, bool prefetch, int *emulation_type)
> >+{
> >+	int r;
> >+
> >+	/*
> >+	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
> >+	 * guest perspective and have already been counted at the time of the
> >+	 * original fault.
> >+	 */
> >+	if (!prefetch)
> >+		vcpu->stat.pf_taken++;
> >+
> >+	r = __kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, err, prefetch, emulation_type);
> 
> bail out if r < 0?

The following if clauses checks RET_PF_xxx > 0. 
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

