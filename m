Return-Path: <kvm+bounces-49874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D056BADECD4
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 14:43:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1805216BFAB
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 12:38:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AA6B2DE1F3;
	Wed, 18 Jun 2025 12:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W9Owv5Dt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926281DA5F;
	Wed, 18 Jun 2025 12:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750250201; cv=none; b=qg7zm2GdKccdzUKBA1lmiQGocf0FGsWkAPStAD/Fn8XYL89j9vb67v1OeJk0jZPUcu/uSzyCyggI3wqA+Q35jexcLdq6oMa2+A2oM4R+Y5CF1pgB7JB/aig/jpG5roG3ywyVSZZYr9kgLeCdNBmobMsP8wZoaywBZOwBe0l1DPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750250201; c=relaxed/simple;
	bh=LnZj30mu7Xgaz2Ry38U7J1WAcWO6GtqUiXkiHEyn7o8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oClZvGghmuTIqNwYb24+KD+hDZ55SddXFDGCfiZogNjKpygVtABzQYsZkbQ9XI1B3JtGOCo0XO6aasFWbp+I/Cr4kR8Y92Zrmzkz5Z9cPPNdhsUkHn58OIxG45rAKMjA4rmlGFshgkdGYwHJhtwQBU6+pvT3suJYXskhSdQMGrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W9Owv5Dt; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750250200; x=1781786200;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LnZj30mu7Xgaz2Ry38U7J1WAcWO6GtqUiXkiHEyn7o8=;
  b=W9Owv5Dtfng/NeVU6dPe4KVvbbWmxQbZc1TzhK9hFQIWGxGgwnO+oXtq
   YFqkTLpdlJIKGjIaGTKPhuQUQ66cLF9jekcWoW/8PKH8Qd7wEjVwaGJQI
   lhRc/QflpaMT21uH1WKIX0jvTtE5Tjv2MnjDyVDKmeIwjVK8ITF/FqtP5
   GyFKTu3cKSsq5bU3FLD3l9cuobn7y/Wq2MmNV1NQ71pMD3BBYlJuoQmsh
   F97ykiOkexijV+m06weuKqhqYgpRZRZExbNMWtzyUUPiJujlFBLBjzfLp
   63o4hamM6JDXa/6ViCVmVWBzojr/V7n3a7giPZzwdnqeCgCgnUIs2Rw1l
   g==;
X-CSE-ConnectionGUID: 0hYbw/3jT7K2N+l7wi1Ptg==
X-CSE-MsgGUID: jl2T1STfSU2RD95RQZe9ug==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="63815600"
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="63815600"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:36:38 -0700
X-CSE-ConnectionGUID: 49nLlOKuRk+B2IRrlwDIhA==
X-CSE-MsgGUID: XVu3bsCLSeaIL5x+hhY5JQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,246,1744095600"; 
   d="scan'208";a="154235571"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 05:36:30 -0700
Message-ID: <eaf6343a-dbb1-453a-a258-f3bab35740a1@intel.com>
Date: Wed, 18 Jun 2025 20:36:27 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
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
 <20250618120806.113884-2-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250618120806.113884-2-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/2025 8:08 PM, Adrian Hunter wrote:
> Commit 8a01ec97dc066 ("x86/mce: Mask out non-address bits from machine
> check bank") introduced a new #define MCI_ADDR_PHYSADDR for the mask of
> valid physical address bits within the machine check bank address register.
> 
> This is particularly needed in the case of errors in TDX/SEAM non-root mode
> because the reported address contains the TDX KeyID.  Refer to TDX and
> TME-MK documentation for more information about KeyIDs.
> 
> Commit 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM
> non-root mode") uses the address to mark the affected page as poisoned, but
> omits to use the aforementioned mask.
> 
> Mask the address with MCI_ADDR_PHYSADDR so that the page can be found.
> 
> Fixes: 7911f145de5fe ("x86/mce: Implement recovery for errors in TDX/SEAM non-root mode")
> Cc: stable@vger.kernel.org

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   arch/x86/kernel/cpu/mce/core.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
> index e9b3c5d4a52e..76c4634c6a5f 100644
> --- a/arch/x86/kernel/cpu/mce/core.c
> +++ b/arch/x86/kernel/cpu/mce/core.c
> @@ -1665,7 +1665,8 @@ noinstr void do_machine_check(struct pt_regs *regs)
>   		 * be added to free list when the guest is terminated.
>   		 */
>   		if (mce_usable_address(m)) {
> -			struct page *p = pfn_to_online_page(m->addr >> PAGE_SHIFT);
> +			unsigned long pfn = (m->addr & MCI_ADDR_PHYSADDR) >> PAGE_SHIFT;
> +			struct page *p = pfn_to_online_page(pfn);
>   
>   			if (p)
>   				SetPageHWPoison(p);


