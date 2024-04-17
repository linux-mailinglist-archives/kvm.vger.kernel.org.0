Return-Path: <kvm+bounces-14999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1A5B8A8B68
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 20:44:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B5C1285E19
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 18:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 119121BC40;
	Wed, 17 Apr 2024 18:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lQUQj5zI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AD5E22338;
	Wed, 17 Apr 2024 18:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713379464; cv=none; b=AO1aJUcBi4Pvvfk2fk7yhCyPRJxdwvtV97zDZu39P4glwmUMTCJUJUvTbfBFEk+kfEqdCtHyhUcH6A5+0rLO8+aPIw2sbm5wvJmpe0/3cSiniE73MDZt2mzKW7YeEQXQbtaWZawXDhox4m7iQmWDTLW1UdilqJkju4yoAYuG+HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713379464; c=relaxed/simple;
	bh=/MgPf3JdMf3WsCCU3RTyq2hSaaAaGOGjKybT8hE2a0I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sGa0ChI8bzRsPaJJq4UbJeHL01jSrbflGrowoTURe24+EcjYKKtkxIlLyKv3e7URSdnxyKCkgf6p2kArQ2BMibcFYoL318pzsAxEKc8S2BFSEhSSKc1XOSw/rmVeqNyq6yUB75frR9QUqh5Hon3R8yaFCgi2sViVaFOQop3fyGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lQUQj5zI; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713379463; x=1744915463;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/MgPf3JdMf3WsCCU3RTyq2hSaaAaGOGjKybT8hE2a0I=;
  b=lQUQj5zIIGR6weey/tTW2jLddzXuGwoTJTe+mYjX6rP6idX9WEiy19ps
   0M0rfhDW91jw8A+lvYVksbUUHD9iqTa9kQH0AyNoXBDYMvXvsD4b1k8NZ
   IFtgzHyF75cP2merojVuK28RjSGWlbpIpZDmKcUPWxYRxVzRbFMf60gTM
   raLyiGzqatq/u627rWLyYZxtoel/bgB5lReBOvJhd9elNIcGk+MgZxn10
   II1mZM4bkA85CrWkPxhWV0Bk378vCwHdoPJlS+EM3hIgTOghuXKzixFC/
   BFl080/bXyPyT46Cglr5PUrMqzJBOiXA0UNtuf07Pej3E8yFEF+y6uY0Z
   A==;
X-CSE-ConnectionGUID: ksZfUWL5SiesRffaqWKNYw==
X-CSE-MsgGUID: eMc8i/Z/RuibjJQCwTWIIw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9047005"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="9047005"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 11:44:22 -0700
X-CSE-ConnectionGUID: 2uUunGCcR+SpwJWuzhuYtA==
X-CSE-MsgGUID: dL8AWQALQ66oDjtbRMoRDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="23309529"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 11:44:21 -0700
Date: Wed, 17 Apr 2024 11:44:20 -0700
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
Subject: Re: [PATCH v2 05/10] KVM: x86/mmu: Introduce kvm_tdp_map_page() to
 populate guest memory
Message-ID: <20240417184420.GH3039520@ls.amr.corp.intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <9b866a0ae7147f96571c439e75429a03dcb659b6.1712785629.git.isaku.yamahata@intel.com>
 <Zh90aFh2xr+nEcCQ@chao-email>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zh90aFh2xr+nEcCQ@chao-email>

On Wed, Apr 17, 2024 at 03:04:08PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Wed, Apr 10, 2024 at 03:07:31PM -0700, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >Introduce a helper function to call the KVM fault handler.  It allows a new
> >ioctl to invoke the KVM fault handler to populate without seeing RET_PF_*
> >enums or other KVM MMU internal definitions because RET_PF_* are internal
> >to x86 KVM MMU.  The implementation is restricted to two-dimensional paging
> >for simplicity.  The shadow paging uses GVA for faulting instead of L1 GPA.
> >It makes the API difficult to use.
> >
> >Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> >---
> >v2:
> >- Make the helper function two-dimensional paging specific. (David)
> >- Return error when vcpu is in guest mode. (David)
> >- Rename goal_level to level in kvm_tdp_mmu_map_page(). (Sean)
> >- Update return code conversion. Don't check pfn.
> >  RET_PF_EMULATE => EINVAL, RET_PF_CONTINUE => EIO (Sean)
> >- Add WARN_ON_ONCE on RET_PF_CONTINUE and RET_PF_INVALID. (Sean)
> >- Drop unnecessary EXPORT_SYMBOL_GPL(). (Sean)
> >---
> > arch/x86/kvm/mmu.h     |  3 +++
> > arch/x86/kvm/mmu/mmu.c | 32 ++++++++++++++++++++++++++++++++
> > 2 files changed, 35 insertions(+)
> >
> >diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> >index e8b620a85627..51ff4f67e115 100644
> >--- a/arch/x86/kvm/mmu.h
> >+++ b/arch/x86/kvm/mmu.h
> >@@ -183,6 +183,9 @@ static inline void kvm_mmu_refresh_passthrough_bits(struct kvm_vcpu *vcpu,
> > 	__kvm_mmu_refresh_passthrough_bits(vcpu, mmu);
> > }
> > 
> >+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> >+		     u8 *level);
> >+
> > /*
> >  * Check if a given access (described through the I/D, W/R and U/S bits of a
> >  * page fault error code pfec) causes a permission fault with the given PTE
> >diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >index 91dd4c44b7d8..a34f4af44cbd 100644
> >--- a/arch/x86/kvm/mmu/mmu.c
> >+++ b/arch/x86/kvm/mmu/mmu.c
> >@@ -4687,6 +4687,38 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
> > 	return direct_page_fault(vcpu, fault);
> > }
> > 
> >+int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code,
> >+		     u8 *level)
> >+{
> >+	int r;
> >+
> >+	/* Restrict to TDP page fault. */
> 
> need to explain why. (just as you do in the changelog)

Sure.


> >+	if (vcpu->arch.mmu->page_fault != kvm_tdp_page_fault)
> 
> page fault handlers (i.e., vcpu->arch.mmu->page_fault()) will be called
> finally. why not let page fault handlers reject the request to get rid of
> this ad-hoc check? We just need to plumb a flag indicating this is a
> pre-population request into the handlers. I think this way is clearer.
> 
> What do you think?

__kvm_mmu_do_page_fault() doesn't check if the mmu mode is TDP or not.
If we don't want to check page_fault handler, the alternative check would
be if (!vcpu->arch.mmu->direct).  Or we will require the caller to guarantee
that MMU mode is tdp (direct or tdp_mmu).
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

