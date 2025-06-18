Return-Path: <kvm+bounces-49875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B5DADECDE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:44:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0C1DE1895AB8
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 12:40:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 325942D12F6;
	Wed, 18 Jun 2025 12:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KsTR72qF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD7F28B503;
	Wed, 18 Jun 2025 12:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750250403; cv=none; b=FcJnSAA6mdZayYs5IXzqv3vWwNum3w9ZQ6A8/wVUyG0L6easi66/EU7QtiRH5bH6x6BnhqZYkfs3pjThAEyW5noUjaDZCD8MCCtd6fziBcQSVp7i+Y3XxGlRfybOE/j7H6EaDRyR772wsNO6dIsSQGt8La6Q7LqHAsJx3Hziuxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750250403; c=relaxed/simple;
	bh=gtPi66+hfTTTDE0soYLd3r6RNixK6xtDDPTsnM7s8AI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLVub+NWSnVH+ybUNqqywbHW80gtjY2APuxyodM1XFOokLrhjUDtT2lWekq989wu7I9Q+p1rYXzqUUI3Qejbn9wEI6/tsfO+OUnOPgquhjzcyeja/3kKGciiz4zZAJzA8TAe2hLpthUaeXBmGrhqpGnURHTUyIAyCfB+EOCfrf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KsTR72qF; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750250402; x=1781786402;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gtPi66+hfTTTDE0soYLd3r6RNixK6xtDDPTsnM7s8AI=;
  b=KsTR72qFfNWvN2A7jU/fDRFJEgUkNcdaOI+rd9dr9Fv0ehyjk2rxgBwR
   WgOkP1lu38JxZuwjwDYRAc19bMdGzUtR72YNV33S7vLR24kJlK4vXoZYY
   xExR1sP6TAV7OuSVrHcmXwXtv5LPwQ1U0T73dxfq8tQx/nd0vmGji+ErS
   ZOQ5IYgGkAlVumG6hdXLpfz1NCgIH5la7eJB5zdxsWXwVJ2fdYO4q+wwN
   bmTHQeZ9P+t2JZYfwKyeWKhkNTHTnsVMGKcGNQAYWP7BCb3c91epInDX7
   p4YLCGmcEaxFU6wb+YNmbaMO42qKN78+9EWTD3GvHBq/yk41h7jjPDdCK
   g==;
X-CSE-ConnectionGUID: 9bJXNDKMTd+RvM01ZtThag==
X-CSE-MsgGUID: oF6zxxobRoufNIAB+wLCtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="51690100"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="51690100"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:40:01 -0700
X-CSE-ConnectionGUID: Aj2E/VTBRu++q7aFtIp7iQ==
X-CSE-MsgGUID: nCSKsEt0RXaxnLgpFD+xMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="150262264"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:39:53 -0700
Message-ID: <27b983f2-a6da-4b2c-a5d4-c84e2c80f193@intel.com>
Date: Wed, 18 Jun 2025 20:39:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] KVM: TDX: Do not clear poisoned pages
To: Adrian Hunter <adrian.hunter@intel.com>, Tony Luck <tony.luck@intel.com>,
 pbonzini@redhat.com, seanjc@google.com
Cc: vannapurve@google.com, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 H Peter Anvin <hpa@zytor.com>, linux-edac@vger.kernel.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kirill.shutemov@linux.intel.com,
 kai.huang@intel.com, reinette.chatre@intel.com,
 tony.lindgren@linux.intel.com, binbin.wu@linux.intel.com,
 isaku.yamahata@intel.com, yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250618120806.113884-1-adrian.hunter@intel.com>
 <20250618120806.113884-3-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250618120806.113884-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/2025 8:08 PM, Adrian Hunter wrote:
> Skip clearing a private page if it is marked as poisoned.
> 
> The machine check architecture may have the capability to recover from
> memory corruption in SEAM non-root (i.e. TDX VM guest) mode.  In that
> case the page is marked as poisoned, and the TDX Module puts the TDX VM
> into a FATAL error state where the only operation permitted is to tear it
> down.
> 
> During tear down, reclaimed pages are cleared which, in some cases,  helps
> to avoid integrity violation or TD bit mismatch detection when later being
> read using a shared HKID.
> 
> However a poisoned page will never be allocated again, so clearing is not
> necessary, and in any case poisoned pages should not be touched.
> 
> Note that while it is possible that memory corruption arises from integrity
> violation which could be cleared by MOVDIR64B, that is not necessarily the
> cause of the machine check.
> 
> Suggested-by: Kai Huang <kai.huang@intel.com>
> Fixes: 8d032b683c299 ("KVM: TDX: create/destroy VM structure")
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 457f91b95147..f4263f7a3924 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -282,10 +282,10 @@ static void tdx_clear_page(struct page *page)
>   	void *dest = page_to_virt(page);
>   	unsigned long i;
>   
> -	/*
> -	 * The page could have been poisoned.  MOVDIR64B also clears
> -	 * the poison bit so the kernel can safely use the page again.
> -	 */
> +	/* Machine check handler may have poisoned the page */

This doesn't read correct. The page is not poisoned by the machine check 
handler. Machine check handler just marks the page as poisoned.

With it fixed,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> +	if (PageHWPoison(page))
> +		return;
> +
>   	for (i = 0; i < PAGE_SIZE; i += 64)
>   		movdir64b(dest + i, zero_page);
>   	/*


