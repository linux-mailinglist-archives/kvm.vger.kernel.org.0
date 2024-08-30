Return-Path: <kvm+bounces-25506-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A0A2965FE5
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 13:03:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D7701C22DE1
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 11:03:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3282C199949;
	Fri, 30 Aug 2024 11:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h3M9Pqci"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E68B19992E;
	Fri, 30 Aug 2024 11:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015704; cv=none; b=QPZsSY7NVYpDQMoQqgi9f3xGEeZaotJzzsr2uCxG09NrsJ7abZDBSExi2lRUszZnuY8R2tN3MFlMrXsPgA9ZJYVK2R/YCwYHk/KHYfMEUW5L1KM2nGkEm7x99JkLrE2WVeA3Z/hr3dX/CkefcQ+hj3yOypikZR7WjNoY3CQ8Xd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015704; c=relaxed/simple;
	bh=GP9Bk2oV4XilDa9FmBZHZQPmp/feHl1DYZ3IzxwovvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T1Ji/qKZhWpw2hXuTDbA95p+qsWrzh3KDz43xqQh76B4TzTIfZw0jZXw/7jmy3UWT97zpgDCKXa/vn6DlV32IBxpoTatDu98NObd/f84zgp52DCPvNfnEoruKWO0+W5a5d5cSI+mYtfcyEd0IOg+p34EiDJi/NQ5sI8tjzWZrYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h3M9Pqci; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725015702; x=1756551702;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GP9Bk2oV4XilDa9FmBZHZQPmp/feHl1DYZ3IzxwovvQ=;
  b=h3M9PqcizyWIk3XHa+UpMVDJ/r5ts7EMKLtApPTmd8os9dAagdXHIyEV
   BZpPLc7txxYeTDNmyOmjf+XFtaupdcPgMyM24F9XsAEizWGGGgDwpOH5u
   5l1H5lLDPdDdxcjN/LgalW0K97er/INR6vrclhj2GnphuH3nV89saj8UF
   VWHuilZqLVWlh/XD0e4V/XOMbyOudg/KBjx7VqHM8a6Gv3AaZu3GjJxxf
   HXMn52/61J6fC7FyQH75vcGjnAUCJlQjKSzdLkHYo0kqYx3pBO34oOhyr
   ZBZgrNikx0kDLQA8216D6QnUlL0z4OXBYNoXRh7fzUGd0VB3fVDbC2T1j
   A==;
X-CSE-ConnectionGUID: YYKiBSRaRgiyy+FcisC1Iw==
X-CSE-MsgGUID: 4eFB6s0aQ5ebtaVoGkiClg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="23809204"
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="23809204"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:01:40 -0700
X-CSE-ConnectionGUID: +pYUoDjfTP6NqLBSGEA+iw==
X-CSE-MsgGUID: c6+ZF1wSS5i6x/56jQdC8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,188,1719903600"; 
   d="scan'208";a="63492989"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.96.163])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2024 04:01:34 -0700
Message-ID: <0a1a860f-cb46-426e-b586-f33d38b2c912@intel.com>
Date: Fri, 30 Aug 2024 14:01:28 +0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 8/8] x86/virt/tdx: Don't initialize module that doesn't
 support NO_RBP_MOD feature
To: Kai Huang <kai.huang@intel.com>, dave.hansen@intel.com,
 kirill.shutemov@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
 peterz@infradead.org, mingo@redhat.com, hpa@zytor.com,
 dan.j.williams@intel.com, seanjc@google.com, pbonzini@redhat.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, isaku.yamahata@intel.com, chao.gao@intel.com,
 binbin.wu@linux.intel.com
References: <cover.1724741926.git.kai.huang@intel.com>
 <0996e2f1b3e5c72150708b10bff57ad726c69e4b.1724741926.git.kai.huang@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <0996e2f1b3e5c72150708b10bff57ad726c69e4b.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 27/08/24 10:14, Kai Huang wrote:
> Old TDX modules can clobber RBP in the TDH.VP.ENTER SEAMCALL.  However
> RBP is used as frame pointer in the x86_64 calling convention, and
> clobbering RBP could result in bad things like being unable to unwind
> the stack if any non-maskable exceptions (NMI, #MC etc) happens in that
> gap.
> 
> A new "NO_RBP_MOD" feature was introduced to more recent TDX modules to
> not clobber RBP.  This feature is reported in the TDX_FEATURES0 global
> metadata field via bit 18.
> 
> Don't initialize the TDX module if this feature is not supported [1].
> 
> Link: https://lore.kernel.org/all/c0067319-2653-4cbd-8fee-1ccf21b1e646@suse.com/T/#mef98469c51e2382ead2c537ea189752360bd2bef [1]
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
> 
> v2 -> v3:
>  - check_module_compatibility() -> check_features().
>  - Improve error message.
> 
>  https://lore.kernel.org/kvm/cover.1721186590.git.kai.huang@intel.com/T/#md9e2eeef927838cbf20d7b361cdbea518b8aec50
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
>  arch/x86/virt/vmx/tdx/tdx.h |  3 +++
>  2 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index fa335ab1ae92..032a53ddf5bc 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -454,6 +454,18 @@ static int get_tdx_sys_info(struct tdx_sys_info *sysinfo)
>  	return get_tdx_sys_info_tdmr(&sysinfo->tdmr);
>  }
>  
> +static int check_features(struct tdx_sys_info *sysinfo)
> +{
> +	u64 tdx_features0 = sysinfo->features.tdx_features0;
> +
> +	if (!(tdx_features0 & TDX_FEATURES0_NO_RBP_MOD)) {
> +		pr_err("frame pointer (RBP) clobber bug present, upgrade TDX module\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
>  /* Calculate the actual TDMR size */
>  static int tdmr_size_single(u16 max_reserved_per_tdmr)
>  {
> @@ -1235,6 +1247,11 @@ static int init_tdx_module(void)
>  
>  	print_basic_sys_info(&sysinfo);
>  
> +	/* Check whether the kernel can support this module */
> +	ret = check_features(&sysinfo);
> +	if (ret)
> +		return ret;
> +
>  	/*
>  	 * To keep things simple, assume that all TDX-protected memory
>  	 * will come from the page allocator.  Make sure all pages in the
> diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
> index e7bed9e717c7..831361e6d0fb 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.h
> +++ b/arch/x86/virt/vmx/tdx/tdx.h
> @@ -154,6 +154,9 @@ struct tdx_sys_info_features {
>  	u64 tdx_features0;
>  };
>  
> +/* Architectural bit definitions of TDX_FEATURES0 metadata field */
> +#define TDX_FEATURES0_NO_RBP_MOD	_BITULL(18)
> +
>  /* Class "TDX Module Version" */
>  struct tdx_sys_info_version {
>  	u16 major;


