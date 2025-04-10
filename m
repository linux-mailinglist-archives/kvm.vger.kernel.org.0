Return-Path: <kvm+bounces-43111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD1C9A84F89
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 00:14:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D67A17AC03A
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 22:12:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44B8B20E711;
	Thu, 10 Apr 2025 22:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="klVA0IxL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C906620C48A;
	Thu, 10 Apr 2025 22:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744323233; cv=none; b=W5mZCSFhF986sK+7KqJOoZI4oWFZEwdAgfYyGS+N6zSPD0tQXGbyw+SlmH/fvdBI9YBipG55/91TNmV+XM5kAk3Q5+lOhXQSsCF0PNEJHSNi8iWghcQfN6/pxQfFfes8EAqg8AkgDhKCovlOmGAQpN7MTMiqAedvK4v5Qahir5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744323233; c=relaxed/simple;
	bh=IBo89qHKQdv1YlyiUpkbXqVARTQ+YsXgrEGUhF/Pl7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQQmGC3LqQMdHIEFIqj4o1lvXg+A4u/fifPOla/mlDotjoCpQrvCEwR19p35SNueV7CyvZ2MH3jK3MMgrjzVbbAXSKlyRlGnswmoyEjt0vfOC9/oOj+yxVx/SBiHAUHnOzGASgtm0DvPVYatboNpadQFbygVZh0aIsDGgQHlHrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=klVA0IxL; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744323232; x=1775859232;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=IBo89qHKQdv1YlyiUpkbXqVARTQ+YsXgrEGUhF/Pl7Q=;
  b=klVA0IxL1DtkCE45TnhIXALGOzUSR1KZG5VU5nNXfO/fv4n1sGGyzx3j
   WmR9pWff6s134VLz8V50921FuYFyT1s87+lqsYF3v+9Ibzf6OOEIn5n9/
   sxrqAMbzDrmMa+mC7RjDeg/AoOuKI4rxcetHnf5rU9Yjodx3fw1slUAN9
   M2NCyiK9jzvxFOCE3efqToVFb2eRs2GqkXLjOuS2ex18uS2oJEOHYHiLC
   x5jvhobGh89qILkVyNFX0GjxYCQOeFFtykvFHrENPzZOpaZKSBl2TQyL9
   r0VxN0X5g9N405M05gDOMH1wP9SZvO2k1K72zlp6+PinYy+ym/knzqPQ0
   A==;
X-CSE-ConnectionGUID: ftmE/BIlRS2/esHW/+rUHA==
X-CSE-MsgGUID: 4k6b17HvST6CRuNNzpVSyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="45105407"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="45105407"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:13:51 -0700
X-CSE-ConnectionGUID: SDQvF7IAR3ujJGgrwS0qDQ==
X-CSE-MsgGUID: 8/JxH8PtSo2nCyqO5LulaQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="129577555"
Received: from dstill-mobl.amr.corp.intel.com (HELO desk) ([10.125.145.218])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 15:13:50 -0700
Date: Thu, 10 Apr 2025 15:13:45 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH] x86/bugs/mmio: Rename mmio_stale_data_clear to
 cpu_buf_vm_clear
Message-ID: <20250410221345.ewyagu7coscpr3l7@desk>
References: <20250410-mmio-rename-v1-1-fd4b2e7fc04e@linux.intel.com>
 <Z_gsgHzgGWqnNwKv@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z_gsgHzgGWqnNwKv@google.com>

On Thu, Apr 10, 2025 at 01:39:28PM -0700, Sean Christopherson wrote:
> On Thu, Apr 10, 2025, Pawan Gupta wrote:
> > The static key mmio_stale_data_clear controls the KVM-only mitigation for
> > MMIO Stale Data vulnerability. Rename it to reflect its purpose.
> > 
> > No functional change.
> > 
> > Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > ---
> >  arch/x86/include/asm/nospec-branch.h |  2 +-
> >  arch/x86/kernel/cpu/bugs.c           | 16 ++++++++++------
> >  arch/x86/kvm/vmx/vmx.c               |  2 +-
> >  3 files changed, 12 insertions(+), 8 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
> > index 8a5cc8e70439e10aab4eeb5b0f5e116cf635b43d..c0474e2b741737dad129159adf3b5fc056b6097c 100644
> > --- a/arch/x86/include/asm/nospec-branch.h
> > +++ b/arch/x86/include/asm/nospec-branch.h
> > @@ -561,7 +561,7 @@ DECLARE_STATIC_KEY_FALSE(mds_idle_clear);
> >  
> >  DECLARE_STATIC_KEY_FALSE(switch_mm_cond_l1d_flush);
> >  
> > -DECLARE_STATIC_KEY_FALSE(mmio_stale_data_clear);
> > +DECLARE_STATIC_KEY_FALSE(cpu_buf_vm_clear);
> 
> Could we tack on "if_mmio" or something?  E.g. cpu_buf_vm_clear_if_mmio.  FWIW,
> I don't love that name, so if anyone can come up with something better...

Keeping it generic has an advantage that it plays nicely with "Attack vector
controls" series:

  https://lore.kernel.org/lkml/20250310164023.779191-1-david.kaplan@amd.com/

The idea being to allow mitigations to be enabled/disabled based on
user-defined threat model. MDS/TAA mitigations may be able to take
advantage this KVM-only control.

> I like the idea of tying the static key back to X86_FEATURE_CLEAR_CPU_BUF, but
> when looking at just the usage in KVM, "cpu_buf_vm_clear" doesn't provide any
> hints as to when/why KVM needs to clear buffers.

Thats fair, can we cover that with a comment like below:

---
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c79720aad3df..cddad4a6eb46 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7358,6 +7358,10 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * mitigation for MDS is done late in VMentry and is still
 	 * executed in spite of L1D Flush. This is because an extra VERW
 	 * should not matter much after the big hammer L1D Flush.
+	 *
+	 * cpu_buf_vm_clear is used when system is not vulnerable to MDS/TAA,
+	 * but is affected by MMIO Stale Data that only needs mitigation
+	 * against a rogue guest.
 	 */
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);

