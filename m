Return-Path: <kvm+bounces-25930-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3901296D35A
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 11:33:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC2C028933F
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 09:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51069198E90;
	Thu,  5 Sep 2024 09:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e5795zeE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6163197A77;
	Thu,  5 Sep 2024 09:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725528699; cv=none; b=Uo5ybCFm5aKa9nbC/Y+811l7Tj+Dr3y+eWeYzqPKrdo8/vlZD60AVpD3r4rYKcQAXXop5bWK5xrLs0hgxzCMimzNmCDnzfyIvDPMIK+rGIFIDN7tir2sLEVSZtgh+07w68TQYG5jRF2L6fnnL29OmHH+BfjdV1T6adXmpDPc5RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725528699; c=relaxed/simple;
	bh=086CJU3xj3vqkfEQ8ZJx6ssAsn3JtiLdqrG90LXtwfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qis5e5l0g7v+ewGWQiyh/WsuIFIJDyKL1I3oZHxSlIGOq1XJTN+2a2U8eH1hdsTjYoMWzqrc9kmwBv1gzkHls3ntdYSwOpAB8wEuAa3ILIkVDx+vg/dhJSECY7ywSm8JlbyEHUl/qJl6EazrUxQWf3WbGWcijLuajf9ZbUjVNc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e5795zeE; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725528698; x=1757064698;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=086CJU3xj3vqkfEQ8ZJx6ssAsn3JtiLdqrG90LXtwfo=;
  b=e5795zeEOUckBAMm8cMM20QwbMVBgGztMf6M6FCsWBuKqHICD+JaKl2c
   qby0np2u7IIhfLgm508WUH3JEm0K9puuHk6WpdvVPSRQ5EpxPp8m/q4N5
   TbjlaDlkyJMYUavLxBr5E8a6feZXG9yBbWYqv1f03b8wZF8L/H5ZOiaYN
   +AESDwNzSKqGmOkIuLBXLzIJc307AZQvaQ6Q9pLek+MBPHZGtEa/jhst6
   OcgdDJWUyLsfw0TDEb406mgiQQuC8ADJ/mXMo/5RBlcfAlI/V8j6qOOLK
   p4VMSsWcFEwG1FcUPodeNrAuiwnrlVaxQkCqRn7zymkL9CcA4bccBuPxH
   g==;
X-CSE-ConnectionGUID: 1PKB7GXPRVmOzQv5iIGmBg==
X-CSE-MsgGUID: WuI+pNrvSnKVVTD561UXMQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24394656"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="24394656"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 02:31:37 -0700
X-CSE-ConnectionGUID: NbcObBuxSlm459nDSKj5Mg==
X-CSE-MsgGUID: cRxlMwArSUWmAvtcHovaYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="69976282"
Received: from fdefranc-mobl3.ger.corp.intel.com (HELO tlindgre-MOBL1) ([10.245.246.103])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 02:31:33 -0700
Date: Thu, 5 Sep 2024 12:31:26 +0300
From: Tony Lindgren <tony.lindgren@linux.intel.com>
To: Chenyi Qiang <chenyi.qiang@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, seanjc@google.com,
	pbonzini@redhat.com, kvm@vger.kernel.org, kai.huang@intel.com,
	isaku.yamahata@gmail.com, xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <Ztl6bg2vfah35Zlj@tlindgre-MOBL1>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
 <43a12ed3-90a7-4d44-aef9-e1ca61008bab@intel.com>
 <ZtaiNi09UQ1o-tPP@tlindgre-MOBL1>
 <dd48cb68-1051-48ec-ae29-874c2a77f30f@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd48cb68-1051-48ec-ae29-874c2a77f30f@intel.com>

On Tue, Sep 03, 2024 at 04:04:47PM +0800, Chenyi Qiang wrote:
> 
> 
> On 9/3/2024 1:44 PM, Tony Lindgren wrote:
> > On Tue, Sep 03, 2024 at 10:58:11AM +0800, Chenyi Qiang wrote:
> >> On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> >>> From: Isaku Yamahata <isaku.yamahata@intel.com>
> >>> @@ -543,10 +664,23 @@ static int __tdx_td_init(struct kvm *kvm)
> >>>  		}
> >>>  	}
> >>>  
> >>> -	/*
> >>> -	 * Note, TDH_MNG_INIT cannot be invoked here.  TDH_MNG_INIT requires a dedicated
> >>> -	 * ioctl() to define the configure CPUID values for the TD.
> >>> -	 */
> >>> +	err = tdh_mng_init(kvm_tdx, __pa(td_params), &rcx);
> >>> +	if ((err & TDX_SEAMCALL_STATUS_MASK) == TDX_OPERAND_INVALID) {
> >>> +		/*
> >>> +		 * Because a user gives operands, don't warn.
> >>> +		 * Return a hint to the user because it's sometimes hard for the
> >>> +		 * user to figure out which operand is invalid.  SEAMCALL status
> >>> +		 * code includes which operand caused invalid operand error.
> >>> +		 */
> >>> +		*seamcall_err = err;
> >>
> >> I'm wondering if we could return or output more hint (i.e. the value of
> >> rcx) in the case of invalid operand. For example, if seamcall returns
> >> with INVALID_OPERAND_CPUID_CONFIG, rcx will contain the CPUID
> >> leaf/sub-leaf info.
> > 
> > Printing a decriptive error here would be nice when things go wrong.
> > Probably no need to return that information.
> > 
> > Sounds like you have a patch already in mind though :) Care to post a
> > patch against the current kvm-coco branch? If not, I can do it after all
> > the obvious comment changes are out of the way.
> 
> According to the comment above, this patch wants to return the hint to
> user as the user gives operands. I'm still uncertain if we should follow
> this to return value in some way or special-case the
> INVALID_OPERAND_CPUID_CONFIG like:
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index c00c73b2ad4c..dd6e3149ff5a 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2476,8 +2476,14 @@ static int __tdx_td_init(struct kvm *kvm, struct
> td_params *td_params,
>                  * Return a hint to the user because it's sometimes hard
> for the
>                  * user to figure out which operand is invalid.
> SEAMCALL status
>                  * code includes which operand caused invalid operand error.
> +                *
> +                * TDX_OPERAND_INVALID_CPUID_CONFIG contains more info
> +                * in rcx (i.e. leaf/sub-leaf), warn it to help figure
> +                * out the invalid CPUID config.
>                  */
>                 *seamcall_err = err;
> +               if (err == (TDX_OPERAND_INVALID |
> TDX_OPERAND_ID_CPUID_CONFIG))
> +                       pr_tdx_error_1(TDH_MNG_INIT, err, rcx);
>                 ret = -EINVAL;
>                 goto teardown;
>         } else if (WARN_ON_ONCE(err)) {
> diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
> index f9dbb3a065cc..311c3f03d398 100644
> --- a/arch/x86/kvm/vmx/tdx_errno.h
> +++ b/arch/x86/kvm/vmx/tdx_errno.h
> @@ -30,6 +30,7 @@
>   * detail information
>   */
>  #define TDX_OPERAND_ID_RCX                     0x01
> +#define TDX_OPERAND_ID_CPUID_CONFIG            0x45
>  #define TDX_OPERAND_ID_TDR                     0x80
>  #define TDX_OPERAND_ID_SEPT                    0x92
>  #define TDX_OPERAND_ID_TD_EPOCH                        0xa9
> 

OK yes that should take care of the issue, I doubt that this can be
automatically be handled by the caller even a better error code
was returned.

Regards,

Tony

