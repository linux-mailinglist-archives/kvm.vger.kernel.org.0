Return-Path: <kvm+bounces-14709-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 39BDF8A608E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 03:49:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E1E3A281C38
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 01:49:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C0B6A946;
	Tue, 16 Apr 2024 01:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mBqXApRl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8A7523D;
	Tue, 16 Apr 2024 01:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713232174; cv=none; b=C9JPs+V5bXZTYy6qH8AgtUgptTWhYJcD8U2nTAzvPoaqQZysY3tORa9SR1e88kYsuPDgrB4OtRqFQAqhR5/aczeMs3rYjpyjDKg19Naw+vnjryj8E3MqO3DS9SMkLG5FQ4c4yiGDNN1yYEqlg9RsPAIwW3ltrTA4nX26ploG9wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713232174; c=relaxed/simple;
	bh=6Y4/RS0oDUw2DhhxsvAbLpzBeknSxp/eT964rRA6+FA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lUzSPGuTGpEW2A0qciaws67T1vzren702iLJL+wA/A664VVoaLnSgZzSbGm2SDm0TEo8mTkukXYssFoT/+dnNKm31uTK8OFWnBTnRiwo3nvRi5stDq/h777/N5cwQbxWz+jy8cuY8LH0j9ntALIDdXMDlokQL+t7WRy+M1LiP0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mBqXApRl; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713232174; x=1744768174;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=6Y4/RS0oDUw2DhhxsvAbLpzBeknSxp/eT964rRA6+FA=;
  b=mBqXApRl/SrFgSRJ/zlDDvz1gGjhTr3TPvDVNV+Bv+4k2mPmr8Y8YjMn
   sBSdnmKeKNqCfxiQkDNnHmlgSxY5C8pDQtZHvH7+sgWxZhTy2rMIOaABM
   JSwVuvUs+pU9hbpDao94j7YmvvG2W5ww/MjokJGI5xwKIqlGmdrOYTykl
   UMl78P7dBmvwPWiGBpgce5vTzQA8NiF/x9LyREvA5Z1j0Rgbjp7pgLctZ
   MCcqNB9JBhzPEP4s3D1ucuHR326n/Vx/Roz09iO1MWbez+gu7cecrlScH
   7lPaanC7WlqfDsvw2yraxasCiSb+ohUEFzx3V+vtD6fnxsm+4/5+y8WL9
   Q==;
X-CSE-ConnectionGUID: KmP1PwmFRiG9mbd0/H4b2g==
X-CSE-MsgGUID: 95RtQDSsQHS9AU7FQGnnQA==
X-IronPort-AV: E=McAfee;i="6600,9927,11045"; a="8775452"
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="8775452"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 18:49:33 -0700
X-CSE-ConnectionGUID: aX5fHtZASlu0rpJTGptYzg==
X-CSE-MsgGUID: uEVWQssKQquP2MsihFBK+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,204,1708416000"; 
   d="scan'208";a="22172185"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2024 18:49:32 -0700
Date: Mon, 15 Apr 2024 18:49:31 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Isaku Yamahata <isaku.yamahata@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	"federico.parola@polito.it" <federico.parola@polito.it>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v2 07/10] KVM: x86: Always populate L1 GPA for
 KVM_MAP_MEMORY
Message-ID: <20240416014931.GW3039520@ls.amr.corp.intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
 <2f1de1b7b6512280fae4ac05e77ced80a585971b.1712785629.git.isaku.yamahata@intel.com>
 <116179545fafbf39ed01e1f0f5ac76e0467fc09a.camel@intel.com>
 <Zh2ZTt4tXXg0f0d9@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Zh2ZTt4tXXg0f0d9@google.com>

On Mon, Apr 15, 2024 at 02:17:02PM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> > > - Return error on guest mode or SMM mode:  Without this patch.
> > >   Pros: No additional patch.
> > >   Cons: Difficult to use.
> > 
> > Hmm... For the non-TDX use cases this is just an optimization, right? For TDX
> > there shouldn't be an issue. If so, maybe this last one is not so horrible.
> 
> And the fact there are so variables to control (MAXPHADDR, SMM, and guest_mode)
> basically invalidates the argument that returning an error makes the ioctl() hard
> to use.  I can imagine it might be hard to squeeze this ioctl() into QEMU's
> existing code, but I don't buy that the ioctl() itself is hard to use.
> 
> Literally the only thing userspace needs to do is set CPUID to implicitly select
> between 4-level and 5-level paging.  If userspace wants to pre-map memory during
> live migration, or when jump-starting the guest with pre-defined state, simply
> pre-map memory before stuffing guest state.  In and of itself, that doesn't seem
> difficult, e.g. at a quick glance, QEMU could add a hook somewhere in
> kvm_vcpu_thread_fn() without too much trouble (though that comes with a huge
> disclaimer that I only know enough about how QEMU manages vCPUs to be dangerous).
> 
> I would describe the overall cons for this patch versus returning an error
> differently.  Switching MMU state puts the complexity in the kernel.  Returning
> an error punts any complexity to userspace.  Specifically, anything that KVM can
> do regarding vCPU state to get the right MMU, userspace can do too.
>  
> Add on that silently doing things that effectively ignore guest state usually
> ends badly, and I don't see a good argument for this patch (or any variant
> thereof).

Ok, here is a experimental patch on top of the 7/10 to return error.  Is this
a direction? or do we want to invoke KVM page fault handler without any check?

I can see the following options.

- Error if vCPU is in SMM mode or guest mode: This patch
  Defer the decision until the use cases come up.  We can utilize
  KVM_CAP_MAP_MEMORY and struct kvm_map_memory.flags for future
  enhancement.
  Pro: Keep room for future enhancement for unclear use cases to defer
       the decision.
  Con: The use space VMM has to check/switch the vCPU mode.

- No check of vCPU mode and go on
  Pro: It works.
  Con: Unclear how the uAPI should be without concrete use cases.

- Always populate with L1 GPA:
  This is a bad idea.

---
 arch/x86/kvm/x86.c | 32 +++++++++-----------------------
 1 file changed, 9 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8ba9c1720ac9..2f3ceda5c225 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5871,10 +5871,8 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
 			     struct kvm_memory_mapping *mapping)
 {
-	struct kvm_mmu *mmu = NULL, *walk_mmu = NULL;
 	u64 end, error_code = 0;
 	u8 level = PG_LEVEL_4K;
-	bool is_smm;
 	int r;
 
 	/*
@@ -5884,25 +5882,21 @@ int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
 	if (!tdp_enabled)
 		return -EOPNOTSUPP;
 
-	/* Force to use L1 GPA despite of vcpu MMU mode. */
-	is_smm = !!(vcpu->arch.hflags & HF_SMM_MASK);
-	if (is_smm ||
-	    vcpu->arch.mmu != &vcpu->arch.root_mmu ||
-	    vcpu->arch.walk_mmu != &vcpu->arch.root_mmu) {
-		vcpu->arch.hflags &= ~HF_SMM_MASK;
-		mmu = vcpu->arch.mmu;
-		walk_mmu = vcpu->arch.walk_mmu;
-		vcpu->arch.mmu = &vcpu->arch.root_mmu;
-		vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
-		kvm_mmu_reset_context(vcpu);
-	}
+	/*
+	 * SMM mode results in populating SMM memory space with memslots id = 1.
+	 * guest mode results in populating with L2 GPA.
+	 * Don't support those cases for now and punt them for the future
+	 * discussion.
+	 */
+	if (is_smm(vcpu) || is_guest_mode(vcpu))
+		return -EOPNOTSUPP;
 
 	/* reload is optimized for repeated call. */
 	kvm_mmu_reload(vcpu);
 
 	r = kvm_tdp_map_page(vcpu, mapping->base_address, error_code, &level);
 	if (r)
-		goto out;
+		return r;
 
 	/* mapping->base_address is not necessarily aligned to level-hugepage. */
 	end = (mapping->base_address & KVM_HPAGE_MASK(level)) +
@@ -5910,14 +5904,6 @@ int kvm_arch_vcpu_map_memory(struct kvm_vcpu *vcpu,
 	mapping->size -= end - mapping->base_address;
 	mapping->base_address = end;
 
-out:
-	/* Restore MMU state. */
-	if (is_smm || mmu) {
-		vcpu->arch.hflags |= is_smm ? HF_SMM_MASK : 0;
-		vcpu->arch.mmu = mmu;
-		vcpu->arch.walk_mmu = walk_mmu;
-		kvm_mmu_reset_context(vcpu);
-	}
 	return r;
 }
 
-- 
2.43.2

-- 
Isaku Yamahata <isaku.yamahata@intel.com>

