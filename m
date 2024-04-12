Return-Path: <kvm+bounces-14577-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B9FC58A3715
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 22:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 257BBB2177D
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 20:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8ACF22EE0;
	Fri, 12 Apr 2024 20:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IDE/034i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A5B1FBB;
	Fri, 12 Apr 2024 20:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712953967; cv=none; b=FWiy/Yu4FcqzIIyhJMjpn2Cuzx6iKs1uZTlem1GC2gTlf/UP9wz2hYVHnzEoPr2ZoLYzMVBc32cRyUQmpJ/dcyBJGzsrW6GFaHjHArDbBupIl3zO2imGTaDvuuzu/dxhj+NCHwsUDgQCBIuLEcpNW8ALFBQl332qZ5isl3cT7lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712953967; c=relaxed/simple;
	bh=O25czTNqLB/PBuG1lJZszDA0K8OkgcmYNFRCQjnUK/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dCf4DcDbZdw7h9QQJE2jL1fAdX/qualIHBXTCkxf2EY89aavV/OM1uKx440zm3XpMoEd9e/i3F8LtaAi2Hh4INFcPzlTfOSgz5ko5R07LNevc2zWgR53cG/BWkaGR7dVesdHki7fOVq4l2MWkQcSGIwftGQAeufI+D4lUDd7HA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IDE/034i; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712953966; x=1744489966;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=O25czTNqLB/PBuG1lJZszDA0K8OkgcmYNFRCQjnUK/A=;
  b=IDE/034iLCTvLTynUiKzf1zO9HEXELjI8ewbR1vswiXtxKB8Q00BGuVv
   z01wONQRrSLj5tGcSl+gjKa2Zobr64YGCP2ljf87vNbEZ60BkkcXhn49w
   H4L8AGDBE907okajZvHJ0dM9EWGBFNLmb/DKiGxdQqZd2aIi2GrWHCp8T
   g9bKnbWbODKc6FesETfo0ePHdf5g5irT3+02kMrlSFz8wVLhhfcKg+ba5
   jTsTX0X7kqeL7GG3JzeMixf8SvbS5fYDCAhO1jaVoi9ODBzKMp1ubm4Xp
   Kw+VzRSPh/RtoPU58OWyVCFF+I5CNIDUG6pD21GTl/4dySldBRKvFIMi2
   w==;
X-CSE-ConnectionGUID: +0QGNrzTQjS07zApwLVOXw==
X-CSE-MsgGUID: 8D8YboAJRO2qn4FGIX77hg==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="8641721"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="8641721"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:32:45 -0700
X-CSE-ConnectionGUID: MMKbDxSHRY+Gl4FTbMk2zQ==
X-CSE-MsgGUID: aBtZeeHiSgWaHQX3jRNQwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="26133214"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 13:32:45 -0700
Date: Fri, 12 Apr 2024 13:32:44 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 082/130] KVM: TDX: restore user ret MSRs
Message-ID: <20240412203244.GM3039520@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <8ba41a08c98034fd4f3886791d1d068b0d390f86.1708933498.git.isaku.yamahata@intel.com>
 <c0a1de41-79fc-49f2-87a2-0ac2918ca84f@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c0a1de41-79fc-49f2-87a2-0ac2918ca84f@linux.intel.com>

On Sun, Apr 07, 2024 at 01:59:03PM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> 
> 
> On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Several user ret MSRs are clobbered on TD exit.  Restore those values on
> > TD exit
> 
> Here "Restore" is not accurate, since the previous patch just updates the
> cached value on TD exit.

Sure, let me update it.


> > and before returning to ring 3.  Because TSX_CTRL requires special
> > treat, this patch doesn't address it.
> > 
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/x86/kvm/vmx/tdx.c | 43 ++++++++++++++++++++++++++++++++++++++++++
> >   1 file changed, 43 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 199226c6cf55..7e2b1e554246 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -535,6 +535,28 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
> >   	 */
> >   }
> > +struct tdx_uret_msr {
> > +	u32 msr;
> > +	unsigned int slot;
> > +	u64 defval;
> > +};
> > +
> > +static struct tdx_uret_msr tdx_uret_msrs[] = {
> > +	{.msr = MSR_SYSCALL_MASK, .defval = 0x20200 },
> > +	{.msr = MSR_STAR,},
> > +	{.msr = MSR_LSTAR,},
> > +	{.msr = MSR_TSC_AUX,},
> > +};
> > +
> > +static void tdx_user_return_update_cache(void)
> > +{
> > +	int i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
> > +		kvm_user_return_update_cache(tdx_uret_msrs[i].slot,
> > +					     tdx_uret_msrs[i].defval);
> > +}
> > +
> >   static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
> >   {
> >   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> > @@ -627,6 +649,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu)
> >   	tdx_vcpu_enter_exit(tdx);
> > +	tdx_user_return_update_cache();
> >   	tdx_restore_host_xsave_state(vcpu);
> >   	tdx->host_state_need_restore = true;
> > @@ -1972,6 +1995,26 @@ int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> >   		return -EINVAL;
> >   	}
> > +	for (i = 0; i < ARRAY_SIZE(tdx_uret_msrs); i++) {
> > +		/*
> > +		 * Here it checks if MSRs (tdx_uret_msrs) can be saved/restored
> > +		 * before returning to user space.
> > +		 *
> > +		 * this_cpu_ptr(user_return_msrs)->registered isn't checked
> > +		 * because the registration is done at vcpu runtime by
> > +		 * kvm_set_user_return_msr().
> Should be tdx_user_return_update_cache(), if it's the final API name.

Yes, it will be tdx_user_reutrn_msr_update_cache().


> > +		 * Here is setting up cpu feature before running vcpu,
> > +		 * registered is already false.
>                                   ^
>                            remove "already"?

We can this sentence.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

