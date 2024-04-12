Return-Path: <kvm+bounces-14369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5009C8A231D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 03:09:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00206283EE1
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 01:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE3604C92;
	Fri, 12 Apr 2024 01:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mw1PM+/g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5EB2107;
	Fri, 12 Apr 2024 01:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712884131; cv=none; b=ZMH24yjkmPaXPHhCk/1nmR9f0H7kW+CEL03O6KGMicyy9ITeFmqXf/Aob0J4r+35bnYM+u6fE3Eugo7BqpA1ZqQuP+ONmnKeWMzGCQsx0zof2pgjEPO1xrV7eDcKiBSoMrqHxFj9cknlKrvBI3n8jBNA7I3VNFTAcUnjsbwe1xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712884131; c=relaxed/simple;
	bh=5Rc5Ohs7uARYwHGsC78cxD9bAGtjdVXz16yyPP8HT5Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k2TmGn15ggZgPdvtRTKgjhB/nNwYzLQwU5toWnNLg1StWNmOzQo3kFrFv3pD/6uxCGvXP4ZgzanGnFur5rPBBl89yKTQroRNrvG/lg2q1AOpCdQw+XNQ5E8anEDPIPn8H2eodWWkquZ9bVrgOkoIsTzyA7U4NApqfvSnU9w2tVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mw1PM+/g; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712884130; x=1744420130;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5Rc5Ohs7uARYwHGsC78cxD9bAGtjdVXz16yyPP8HT5Y=;
  b=mw1PM+/g88e6hSDmNZwrJsq1JRcDQGTvF/7AMJ91D3HLG2K1zNL9LS0f
   dCQCkhI5F18K8VoD96oIW1x9DGFSO8DnOuZVFKFylRdTfxHl6IzDAbMKj
   8su6sjoiBHZSJzu2gsirn4+mFvBt4W3kOQqN61xhU/v67ndI4wtVPk9dz
   ttwr/hWUDz2nfaDS8hP5KOa23Sg7BdO4zCeNIm7dewIJmuYZENYQKnnv1
   oSu5Mnb6N8Cv+Ocj3kpMgsjk3BDalfq/+0wz/bk+ig1RVmKGgyJofJcGP
   Q/LHkbcxzRjm490J0RX2OdkViHGA0J2EM7yOgzOuA/ozeLUKR64rdkxb5
   A==;
X-CSE-ConnectionGUID: 1lcs5rFvQKa4eOI/OtgNnw==
X-CSE-MsgGUID: XchhopjhSu6fRMyb3jkMgQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="18934978"
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="18934978"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 18:08:49 -0700
X-CSE-ConnectionGUID: yaP7HcRmTCOqE4wLEXawZg==
X-CSE-MsgGUID: em0huLgCTieYF/okvrIAwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,194,1708416000"; 
   d="scan'208";a="21055297"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 18:08:49 -0700
Date: Thu, 11 Apr 2024 18:08:48 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 076/130] KVM: TDX: Finalize VM initialization
Message-ID: <20240412010848.GG3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <e3c862ae9c78bda2988768c1038fec100bb372cf.1708933498.git.isaku.yamahata@intel.com>
 <f3381541-822b-4e94-93f7-699afc6aa6a3@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f3381541-822b-4e94-93f7-699afc6aa6a3@intel.com>

On Thu, Apr 11, 2024 at 07:39:11PM +0300,
Adrian Hunter <adrian.hunter@intel.com> wrote:

> On 26/02/24 10:26, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > To protect the initial contents of the guest TD, the TDX module measures
> > the guest TD during the build process as SHA-384 measurement.  The
> > measurement of the guest TD contents needs to be completed to make the
> > guest TD ready to run.
> > 
> > Add a new subcommand, KVM_TDX_FINALIZE_VM, for VM-scoped
> > KVM_MEMORY_ENCRYPT_OP to finalize the measurement and mark the TDX VM ready
> > to run.
> 
> Perhaps a spruced up commit message would be:
> 
> <BEGIN>
> Add a new VM-scoped KVM_MEMORY_ENCRYPT_OP IOCTL subcommand,
> KVM_TDX_FINALIZE_VM, to perform TD Measurement Finalization.
> 
> Documentation for the API is added in another patch:
> "Documentation/virt/kvm: Document on Trust Domain Extensions(TDX)"
> 
> For the purpose of attestation, a measurement must be made of the TDX VM
> initial state. This is referred to as TD Measurement Finalization, and
> uses SEAMCALL TDH.MR.FINALIZE, after which:
> 1. The VMM adding TD private pages with arbitrary content is no longer
>    allowed
> 2. The TDX VM is runnable
> <END>
> 
> History:
> 
> This code is essentially unchanged from V1, as below.
> Except for V5, the code has never had any comments.
> Paolo's comment from then still appears unaddressed.
> 
> V19:		Unchanged
> V18:		Undoes change of V17
> V17:		Also change tools/arch/x86/include/uapi/asm/kvm.h
> V16:		Unchanged
> V15:		Undoes change of V10
> V11-V14:	Unchanged
> V10:		Adds a hack (related to TDH_MEM_TRACK)
> 		that was later removed in V15
> V6-V9:		Unchanged
> V5		Broke out the code into a separate patch and
> 		received its only comments, which were from Paolo:
> 
> 	"Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> 	Note however that errors should be passed back in the struct."
> 		
> 	This presumably refers to struct kvm_tdx_cmd which has an "error"
> 	member, but that is not updated by tdx_td_finalizemr()
> 
> V4 was a cut-down series and the code was not present
> V3 introduced WARN_ON_ONCE for the error condition
> V2 accommodated renaming the seamcall function and ID

Thank you for creating histories. Let me update the commit message.


> Outstanding:
> 
> 1. Address Paolo's comment about the error code
> 2. Is WARN_ON sensible?

See below.


> Final note:
> 
> It might be possible to make TD Measurement Finalization
> transparent to the user space VMM and forego another API, but it seems
> doubtful that would really make anything much simpler.
> 
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > ---
> > v18:
> > - Remove the change of tools/arch/x86/include/uapi/asm/kvm.h.
> > 
> > v14 -> v15:
> > - removed unconditional tdx_track() by tdx_flush_tlb_current() that
> >   does tdx_track().
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/include/uapi/asm/kvm.h |  1 +
> >  arch/x86/kvm/vmx/tdx.c          | 21 +++++++++++++++++++++
> >  2 files changed, 22 insertions(+)
> > 
> > diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> > index 34167404020c..c160f60189d1 100644
> > --- a/arch/x86/include/uapi/asm/kvm.h
> > +++ b/arch/x86/include/uapi/asm/kvm.h
> > @@ -573,6 +573,7 @@ enum kvm_tdx_cmd_id {
> >  	KVM_TDX_INIT_VM,
> >  	KVM_TDX_INIT_VCPU,
> >  	KVM_TDX_EXTEND_MEMORY,
> > +	KVM_TDX_FINALIZE_VM,
> >  
> >  	KVM_TDX_CMD_NR_MAX,
> >  };
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 3cfba63a7762..6aff3f7e2488 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1400,6 +1400,24 @@ static int tdx_extend_memory(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> >  	return ret;
> >  }
> >  
> > +static int tdx_td_finalizemr(struct kvm *kvm)
> > +{
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	u64 err;
> > +
> > +	if (!is_hkid_assigned(kvm_tdx) || is_td_finalized(kvm_tdx))
> > +		return -EINVAL;
> > +
> > +	err = tdh_mr_finalize(kvm_tdx->tdr_pa);
> > +	if (WARN_ON_ONCE(err)) {
> 
> Is a failed SEAMCALL really something to WARN over?

Because user can trigger an error in some cases, we shouldn't WARN in such case.
Except those, TDH.MR.FINALIZE() shouldn't return error.  If we hit such error,
it typically implies serious error so that the recovery is difficult.  For
example, the TDX module was broken by the host overwriting private pages.
That's the reason why we have KVM_BUN_ON.  So the error check should be
something like
 

        /* We can hit busy error to exclusively access TDR. */
 	if (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX))
		return -EAGAIN;
        /* User can call KVM_TDX_INIT_VM without any vCPUs created. */
	if (err == TDX_NO_VCPUS)
		return -EIO;
        /* Other error shouldn't happen. */
        if (KVM_BUG_ON(err, kvm)) {
                pr_tdx_error(TDH_MR_FINALIZE, err);
                return -EIO;
        }


> > +		pr_tdx_error(TDH_MR_FINALIZE, err, NULL);
> 
> As per Paolo, error code is not returned in struct kvm_tdx_cmd


It will be something like the followings. No compile test yet.


diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0d3b79b5c42a..c7ff819ccaf1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2757,6 +2757,12 @@ static int tdx_td_finalizemr(struct kvm *kvm)
 		return -EINVAL;
 
 	err = tdh_mr_finalize(kvm_tdx);
+	kvm_tdx->hw_error = err;
+
+	if (err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX))
+		return -EAGAIN;
+	if (err == TDX_NO_VCPUS)
+		return -EIO;
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_MR_FINALIZE, err);
 		return -EIO;
@@ -2768,6 +2774,7 @@ static int tdx_td_finalizemr(struct kvm *kvm)
 
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 {
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct kvm_tdx_cmd tdx_cmd;
 	int r;
 
@@ -2777,6 +2784,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 		return -EINVAL;
 
 	mutex_lock(&kvm->lock);
+	kvm_tdx->hw_error = 0;
 
 	switch (tdx_cmd.id) {
 	case KVM_TDX_CAPABILITIES:
@@ -2793,6 +2801,7 @@ int tdx_vm_ioctl(struct kvm *kvm, void __user *argp)
 		goto out;
 	}
 
+	tdx_cmd.error = kvm_tdx->hw_error;
 	if (copy_to_user(argp, &tdx_cmd, sizeof(struct kvm_tdx_cmd)))
 		r = -EFAULT;
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 98f5d7c5891a..dc150b8bdd5f 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -18,6 +18,9 @@ struct kvm_tdx {
 	u64 xfam;
 	int hkid;
 
+	/* For KVM_TDX ioctl to return SEAMCALL status code. */
+	u64 hw_error;
+
 	/*
 	 * Used on each TD-exit, see tdx_user_return_update_cache().
 	 * TSX_CTRL value on TD exit
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index a8aa8b79e9a1..6c701856c9a8 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -41,6 +41,7 @@
 #define TDX_TD_FATAL				0xC000060400000000ULL
 #define TDX_TD_NON_DEBUG			0xC000060500000000ULL
 #define TDX_LIFECYCLE_STATE_INCORRECT		0xC000060700000000ULL
+#define TDX_NO_VCPUS				0xC000060900000000ULL
 #define TDX_TDCX_NUM_INCORRECT			0xC000061000000000ULL
 #define TDX_VCPU_STATE_INCORRECT		0xC000070000000000ULL
 #define TDX_VCPU_ASSOCIATED			0x8000070100000000ULL
-- 
2.43.2
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

