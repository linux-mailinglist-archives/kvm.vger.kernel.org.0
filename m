Return-Path: <kvm+bounces-47842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A85BCAC6054
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 05:51:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1E2C3A28E6
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 03:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D17120FA85;
	Wed, 28 May 2025 03:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mP7q0S07"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2153320AF9A;
	Wed, 28 May 2025 03:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748404193; cv=none; b=XvZRRpTakiwju+gcF08EcG2ApQFvyZGVgvPglbnzRLrwF2bi8gOSrFjBoPqRse6AFd7Id6LNr+vur0VTSk/zeN1rmxrVqzgt7wXhNqOxiHbVWTX6tJDluR1WMmXdv5O6Tj2UrYxpwbgF7IN7HIdZEzfLCKli2f3Y/fkdJUsvDPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748404193; c=relaxed/simple;
	bh=SStq2Kg36LwwImXTfsqwBrWtQT75EeqyD8rTkP6l/2U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pGKUiwwZW8R7PVcDlqqngZOLcl3C2BibCm7UXYaSKuV7HjCXfzsmfKiefmNo59oW0HulavCL/5y9AFhs58Mq29tuUmy+YWTwmyHzxaU4u1ASdNjEjBs+0jCNf9RxQfcWtU36LCRNM3sxP+QSoHfT6EPjyaCmE1mVONe5EM63wms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mP7q0S07; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748404192; x=1779940192;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=SStq2Kg36LwwImXTfsqwBrWtQT75EeqyD8rTkP6l/2U=;
  b=mP7q0S07UhK3bwLgYe2/SMoKo4vK0DlVZdquoMASlRHeMKP2+1Km3iKC
   BF4+Fb4/7FeOejGMFS7GT+I73dxTUwctN0fK2farVW+fwC5Kd3nUPDWVK
   AOmR9LKvlIIkmLIkw9N6qsN1xDVR4dOHAqlWRCul9EC2UYyoYrfuTe3a6
   wUJQq12d/MqnipAVdrSz9mNUbYyJM1KmZA7Fw/yZ0bjPX+2ehRuInmkqz
   ZsS75J1g54h+dcqoLg+mEm8SZ9j/jwtFo4LA4wfGB/VLNsR2yJEbWffDS
   izVj3G5EYHOShvw594+PweyqO7l/Bj9mnIS12H9h17kBiZmOKc9BpBEyo
   w==;
X-CSE-ConnectionGUID: ixD6mfJOS/+/pSDlCWHgYg==
X-CSE-MsgGUID: 3aqZBTNiRMGe8k4Mh0vFXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="38036375"
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="38036375"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 20:49:51 -0700
X-CSE-ConnectionGUID: WZ3w0+xfTH+yxStttC2htA==
X-CSE-MsgGUID: X5XLgWTTQhi8D5droaSxpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,320,1739865600"; 
   d="scan'208";a="148227554"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 20:49:49 -0700
Message-ID: <b9c47a7d-80fc-49c7-9bda-3626f72a70a9@intel.com>
Date: Wed, 28 May 2025 11:49:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/tdx: Always inline tdx_tdvpr_pa()
To: Rick Edgecombe <rick.p.edgecombe@intel.com>, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lkp@intel.com,
 kai.huang@intel.com, seanjc@google.com, x86@kernel.org, dave.hansen@intel.com
References: <20250527220453.3107617-1-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250527220453.3107617-1-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/2025 6:04 AM, Rick Edgecombe wrote:
> In some cases tdx_tdvpr_pa() is not fully inlined into tdh_vp_enter(),
> which causes the following warning:
> 
>    vmlinux.o: warning: objtool: tdh_vp_enter+0x8: call to tdx_tdvpr_pa() leaves .noinstr.text section
> 
> tdh_vp_enter() is marked noinstr and so can't accommodate the function
> being outlined. Previously this didn't cause issues because the compiler
> inlined the function. However, newer Clang compilers are deciding to
> outline it.
> 
> So mark the function __always_inline to force it to be inlined. This
> would leave the similar function tdx_tdr_pa() looking a bit asymmetric
> and odd, as it is marked inline but actually doesn't need to be inlined.
> So somewhat opportunistically remove the inline from tdx_tdr_pa() so that
> it is clear that it does not need to be inlined, unlike tdx_tdvpr_pa().
> 
> tdx_tdvpr_pa() uses page_to_phys() which can make further calls to
> outlines functions, but not on x86 following commit cba5d9b3e99d
> ("x86/mm/64: Make SPARSEMEM_VMEMMAP the only memory model").
> 
> Fixes: 69e23faf82b4 ("x86/virt/tdx: Add SEAMCALL wrapper to enter/exit TDX guest")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202505240530.5KktQ5mX-lkp@intel.com/
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>

Reviewed-by: Xiaoyao Li <Xiaoyao.li@intel.com>

> ---
> Previous discussion here:
> https://lore.kernel.org/kvm/20250526204523.562665-1-pbonzini@redhat.com/
> 
> FWIW, I'm ok with the flatten version of the fix too, but posting this
> just to speed things along in case.
> 
> And note, for full correctness, this and the flatten fix will depend on
> the queued tip commit:
> https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git/commit/?id=cba5d9b3e99d6268d7909a65c2bd78f4d195aead
> 
> ---
>   arch/x86/virt/vmx/tdx/tdx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index f5e2a937c1e7..626cc2f37dec 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1496,12 +1496,12 @@ void tdx_guest_keyid_free(unsigned int keyid)
>   }
>   EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
>   
> -static inline u64 tdx_tdr_pa(struct tdx_td *td)
> +static u64 tdx_tdr_pa(struct tdx_td *td)
>   {
>   	return page_to_phys(td->tdr_page);
>   }
>   
> -static inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
> +static __always_inline u64 tdx_tdvpr_pa(struct tdx_vp *td)
>   {
>   	return page_to_phys(td->tdvpr_page);
>   }


