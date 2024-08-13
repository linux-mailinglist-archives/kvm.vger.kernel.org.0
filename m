Return-Path: <kvm+bounces-23945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 460E294FE0C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 08:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 039582810CA
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 06:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A1641C69;
	Tue, 13 Aug 2024 06:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TrpBpHKM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730BA80B;
	Tue, 13 Aug 2024 06:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723531645; cv=none; b=svVPUpOZGePXH142B8u76NK/TjBIsDCOPRGWEp3E+yRjcOK3lF6trc/xJO4/waXyoIC8ufqx7CCHIPUiyqH+bCKm8n39rfXu7hLzicp7BMya4jqgKQzSzelUaO96j4AdJMG4OpNAU124ZkrKByEE0Xd0P913LxnTSjrO4xhoIbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723531645; c=relaxed/simple;
	bh=ChdSfw0AR7o9n0G3g+U1PMyf8JHWQ2KCBgTbA4+uGmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MrYi7K/ozX25uQUlLL9BDMurrCGdzmdGP9TvXjO0HnO9LszqSO6sboA6A/58uLhG1Xo65/YHQ9m5t8DHc+H3oq4v3tzu3FX8ihQtqkM8AyxhMn9OlMRLctJaYvhManW9qsQItrMF7ZEFnH9ZCfkIMmSq0WKr1g5qZQ4PQb1sVY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TrpBpHKM; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723531644; x=1755067644;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ChdSfw0AR7o9n0G3g+U1PMyf8JHWQ2KCBgTbA4+uGmg=;
  b=TrpBpHKMu7URLRzWKvvk882XXK4grJynfaUud18/oid1lA9gn0aAL3lQ
   Pr98QnYhfDbTKW7c3+HjM2AHORQcDZ35ixISBj2xQAbT5EGmSXLTPiya3
   A4kC3kzHdinAXY18z98yGQXUmtLI6DxQNCYwc53b5c0Gk+UUqVTAoQYBf
   p8R63LfbEGGSyWbhTIq8A33bHjnkqrSqVBLvYxPp3IXrKjTWZY1mlkCDX
   lZszefM3XxZGnQj40GSJhHHXhTs/JcawfW1KBiIfUgIexTUtmaU3HCD2l
   YbOHJqFq0shsDCFAYZW7PsWCYguxSms52PCPDNVXTwyo5Y7Pz2WsNvHON
   w==;
X-CSE-ConnectionGUID: EPfR3uGiTHOu6sZoVny3Lw==
X-CSE-MsgGUID: wb8PvlwlRVqogC3HymqDCw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="21486938"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="21486938"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 23:47:22 -0700
X-CSE-ConnectionGUID: RCyIl5YAQSiNMbcwNKXPvg==
X-CSE-MsgGUID: pA0avmJgRD6FrUX0BYkeqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="58243188"
Received: from unknown (HELO [10.238.8.207]) ([10.238.8.207])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 23:47:19 -0700
Message-ID: <42d844c9-2a17-4cb0-8710-328e7774b4d4@linux.intel.com>
Date: Tue, 13 Aug 2024 14:47:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/25] KVM: TDX: Get system-wide info about TDX module on
 initialization
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: seanjc@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
 kai.huang@intel.com, isaku.yamahata@gmail.com,
 tony.lindgren@linux.intel.com, xiaoyao.li@intel.com,
 linux-kernel@vger.kernel.org, Isaku Yamahata <isaku.yamahata@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-10-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20240812224820.34826-10-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit




On 8/13/2024 6:48 AM, Rick Edgecombe wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX KVM needs system-wide information about the TDX module, store it in
> struct tdx_info.  Release the allocated memory on module unloading by
> hardware_unsetup() callback.

It seems the shortlog and changelog are stale or mismatched.

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> uAPI breakout v1:
>   - Mention about hardware_unsetup(). (Binbin)
>   - Added Reviewed-by. (Binbin)
>   - Eliminated tdx_md_read(). (Kai)
>   - Include "x86_ops.h" to tdx.c as the patch to initialize TDX module
>     doesn't include it anymore.
>   - Introduce tdx_vm_ioctl() as the first tdx func in x86_ops.h
>
> v19:
>   - Added features0
>   - Use tdx_sys_metadata_read()
>   - Fix error recovery path by Yuan
>
> Change v18:
>   - Newly Added
> ---
>   arch/x86/include/uapi/asm/kvm.h | 28 +++++++++++++
>   arch/x86/kvm/vmx/tdx.c          | 70 +++++++++++++++++++++++++++++++++
>   2 files changed, 98 insertions(+)
>
[...]
> +
>   #endif /* _ASM_X86_KVM_H */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index de14e80d8f3a..90b44ebaf864 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3,6 +3,7 @@
>   #include <asm/tdx.h>
>   #include "capabilities.h"
>   #include "x86_ops.h"
> +#include "mmu.h"

Is this needed by this patch?


>   #include "tdx.h"
>   
>   #undef pr_fmt
> @@ -30,6 +31,72 @@ static void __used tdx_guest_keyid_free(int keyid)
>   	ida_free(&tdx_guest_keyid_pool, keyid);
>   }
>   
>
[...]

