Return-Path: <kvm+bounces-12460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 327DE88644C
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 01:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 75F39B21235
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 00:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 067CD29AF;
	Fri, 22 Mar 2024 00:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vitb3wDF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19C4633;
	Fri, 22 Mar 2024 00:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711066616; cv=none; b=fWOKTYrDvqXKEYTg2x7LPPczzC8hUl9/K9wTIpMV8Usyq7ns/K0UN5m6JQllpvbcQHX5k7hCrrA/AOx/QSRP3nGee4tfoqsw1WKYbw6b5V1QMkqfA0XEuCYJ6laSxkYxHX0I08pOUwETM7pCy7aRb6935Nc0AmksyJXhILqohWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711066616; c=relaxed/simple;
	bh=dKPRrDLl3WDe65oG7nzjL2DbjC1eZAZzwXxTDf+c4AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ce2Gp0K5wwFS4nfgWBXQ2su/7+CgmnQAt2eAjDCsxI6NS7cux49ndCfdNdd/p11XL0eWf8cvpLQTZLwuW7N9H3SFB8eGlmo/a9NTcK2+2FDcLV6KtmB6ozNQgpfkt9IosjcAK/37QzRlFAM00k+OtRse5TKrgQOB9+g94aybqDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vitb3wDF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711066614; x=1742602614;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dKPRrDLl3WDe65oG7nzjL2DbjC1eZAZzwXxTDf+c4AA=;
  b=Vitb3wDFa38OlCPNbcavs/xV1DdZwN5RkZt5j/Yul1JXviRRYDRyCkCY
   chYVDzqCm/4HfhO6Itr5jWdUvCZnkoHsLeQtEApL/Fy03EKIzTQmRX4BQ
   AKc4qWa2i21qX2bnpG8Wa1piqygH1twFUE2IU3IbE1fi0TjW06s+tmWnW
   1f62AR8HohjOi2be1OKfQu/QdhwDxD2D0IxzfZCBseGXw/0mPrC6mJMTq
   TcCekSMDJO0TvhkCKyT5kwDXZY8AEFg3Rqjc0OPheYI1sRjIJBOPvoRYL
   vO0qenfOX3rj0mtz+F0OWfE/eHVC63b4pdmTutuvBh/5c/lGSB05dUA55
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="5929052"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="5929052"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 17:16:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="14674916"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 17:16:52 -0700
Date: Thu, 21 Mar 2024 17:16:52 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>, chen.bo@intel.com,
	hang.yuan@intel.com, tina.zhang@intel.com,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Binbin Wu <binbin.wu@linux.intel.com>,
	Yuan Yao <yuan.yao@intel.com>, isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Message-ID: <20240322001652.GW1994522@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
 <579cb765-8a5e-4058-bc1d-9de7ac4b95d1@intel.com>
 <20240320213600.GI1994522@ls.amr.corp.intel.com>
 <46638b78-eb75-4ab4-af7e-b3cad0d00d7b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46638b78-eb75-4ab4-af7e-b3cad0d00d7b@intel.com>

On Thu, Mar 21, 2024 at 11:37:58AM +1300,
"Huang, Kai" <kai.huang@intel.com> wrote:

> 
> 
> On 21/03/2024 10:36 am, Isaku Yamahata wrote:
> > On Wed, Mar 20, 2024 at 01:03:21PM +1300,
> > "Huang, Kai" <kai.huang@intel.com> wrote:
> > 
> > > > +static inline u64 tdx_seamcall(u64 op, struct tdx_module_args *in,
> > > > +			       struct tdx_module_args *out)
> > > > +{
> > > > +	u64 ret;
> > > > +
> > > > +	if (out) {
> > > > +		*out = *in;
> > > > +		ret = seamcall_ret(op, out);
> > > > +	} else
> > > > +		ret = seamcall(op, in);
> > > 
> > > I think it's silly to have the @out argument in this way.
> > > 
> > > What is the main reason to still have it?
> > > 
> > > Yeah we used to have the @out in __seamcall() assembly function.  The
> > > assembly code checks the @out and skips copying registers to @out when it is
> > > NULL.
> > > 
> > > But it got removed when we tried to unify the assembly for TDCALL/TDVMCALL
> > > and SEAMCALL to have a *SINGLE* assembly macro.
> > > 
> > > https://lore.kernel.org/lkml/cover.1692096753.git.kai.huang@intel.com/
> > > 
> > > To me that means we should just accept the fact we will always have a valid
> > > @out.
> > > 
> > > But there might be some case that you _obviously_ need the @out and I
> > > missed?
> > 
> > As I replied at [1], those four wrappers need to return values.
> > The first three on error, the last one on success.
> > 
> >    [1] https://lore.kernel.org/kvm/20240320202040.GH1994522@ls.amr.corp.intel.com/
> > 
> >    tdh_mem_sept_add(kvm_tdx, gpa, tdx_level, hpa, &entry, &level_state);
> >    tdh_mem_page_aug(kvm_tdx, gpa, hpa, &entry, &level_state);
> >    tdh_mem_page_remove(kvm_tdx, gpa, tdx_level, &entry, &level_state);
> >    u64 tdh_vp_rd(struct vcpu_tdx *tdx, u64 field, u64 *value)
> > 
> > We can delete out from other wrappers.
> 
> Ah, OK.  I got you don't want to invent separate wrappers for each
> seamcall() variants like:
> 
>  - tdx_seamcall(u64 fn, struct tdx_module_args *args);
>  - tdx_seamcall_ret(u64 fn, struct tdx_module_args *args);
>  - tdx_seamcall_saved_ret(u64 fn, struct tdx_module_args *args);
> 
> To be honest I found they were kinda annoying myself during the "unify
> TDCALL/SEAMCALL and TDVMCALL assembly" patchset.
> 
> But life is hard...
> 
> And given (it seems) we are going to remove kvm_spurious_fault(), I think
> the tdx_seamcall() variants are just very simple wrapper of plain seamcall()
> variants.
> 
> So how about we have some macros:
> 
> static inline bool is_seamcall_err_kernel_defined(u64 err)
> {
> 	return err & TDX_SW_ERROR;
> }
> 
> #define TDX_KVM_SEAMCALL(_kvm, _seamcall_func, _fn, _args)	\
> 	({				\
> 		u64 _ret = _seamcall_func(_fn, _args);
> 		KVM_BUG_ON(_kvm, is_seamcall_err_kernel_defined(_ret));
> 		_ret;
> 	})

As we can move out KVM_BUG_ON() to the call site, we can simply have
seamcall() or seamcall_ret().
The call site has to check error. whether it is TDX_SW_ERROR or not.
And if it hit the unexpected error, it will mark the guest bugged.


> #define tdx_kvm_seamcall(_kvm, _fn, _args)	\
> 	TDX_KVM_SEAMCALL(_kvm, seamcall, _fn, _args)
> 
> #define tdx_kvm_seamcall_ret(_kvm, _fn, _args)	\
> 	TDX_KVM_SEAMCALL(_kvm, seamcall_ret, _fn, _args)
> 
> #define tdx_kvm_seamcall_saved_ret(_kvm, _fn, _args)	\
> 	TDX_KVM_SEAMCALL(_kvm, seamcall_saved_ret, _fn, _args)
> 
> This is consistent with what we have in TDX host code, and this handles
> NO_ENTROPY error internally.
> 
> Or, maybe we can just use the seamcall_ret() for ALL SEAMCALLs, except using
> seamcall_saved_ret() for TDH.VP.ENTER.
> 
> u64 tdx_kvm_seamcall(sruct kvm*kvm, u64 fn,
> 			struct tdx_module_args *args)
> {
> 	u64 ret = seamcall_ret(fn, args);
> 
> 	KVM_BUG_ON(kvm, is_seamcall_err_kernel_defined(ret);
> 
> 	return ret;
> }
> 
> IIUC this at least should give us a single tdx_kvm_seamcall() API for
> majority (99%) code sites?

We can eleiminate tdx_kvm_seamcall() and use seamcall() or seamcall_ret()
directly.


> And obviously I'd like other people to weigh in too.
> 
> > Because only TDH.MNG.CREATE() and TDH.MNG.ADDCX() can return TDX_RND_NO_ENTROPY, > we can use __seamcall().  The TDX spec doesn't guarantee such error code
> > convention.  It's very unlikely, though.
> 
> I don't quite follow the "convention" part.  Can you elaborate?
> 
> NO_ENTROPY is already handled in seamcall() variants.  Can we just use them
> directly?

I intended for bad code generation.  If the loop on NO_ENTRY error harms the
code generation, we might be able to use __seamcall() or __seamcall_ret()
instead of seamcall(), seamcall_ret().
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

