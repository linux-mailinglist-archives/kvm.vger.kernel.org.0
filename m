Return-Path: <kvm+bounces-51533-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F6AFAF853B
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 03:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D86C51C48467
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 01:32:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 365A313D51E;
	Fri,  4 Jul 2025 01:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BbwY/pZW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83FC182D7;
	Fri,  4 Jul 2025 01:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751592738; cv=none; b=EF/tKchT/YFCCsjGc/D/DVbobIx7OGXtYcuiIu1E6Z+o1r7SAfkMu8Kp2r4bT3yAzXrf7gsffCJoeDLBdZcvnprWUokd3ydrvYxcka7fhhrmZz61sXTph1n4CQEA5uAwon6q6uUWTgdN0ydYa2f4GMLDmIoYKi/N94FUWqW1O9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751592738; c=relaxed/simple;
	bh=cVajWqbMaA8FdWsImYY7QMdtU6iMOS61HOPiAKw5xLQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OjgkYuy+NBi8ehrsATOQPgWHddZD76PGdrnbX0jy0NHaYKBvWtEG2JJ6Sv4DzhbOTwbruvqAoHM+hhDqvcR6yZulZAZJ4/SvCKKHQyqIXjv/uUguyhX+R6mgidPDkJYveN7UKFw4h7RZwuaNZXmKu5Tk5uk/N1aQiRQ+sn8iR+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BbwY/pZW; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751592736; x=1783128736;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=cVajWqbMaA8FdWsImYY7QMdtU6iMOS61HOPiAKw5xLQ=;
  b=BbwY/pZWo1q9TpB7eI+Y8gQhxKugCWqdXaGQO0rULvCgNYxt6fBZlbQg
   quZOulHu6oaKXye9zduo+fXP3MnGadwRrcbCjbrrbq3YXsSbS/dLYkZP8
   y+UOML1HR9cAGlMI/G8MsaMa4EazgQ7+AqaKc6QCHwda+uKmXiJj0fAd4
   q09lG7e02+uGCh8l3lAF9jxZXXeclP8XeEYuHVpuvQr7U2aPmSBwIIzSm
   QLxkTg0I6ri5h/BDBnb4fZ5dSmiK4fcou0wrjD4s4iiB7Zqyr7uDSJ5M8
   CheOgT66d8CHVVGnRL06HPD4vDuw/7ISvtAgaryjZadnLjrfdsKhq50cO
   A==;
X-CSE-ConnectionGUID: /J+kJCmjQN20861Ecy0/0A==
X-CSE-MsgGUID: ig33fD0vTfmFp5T+Dg92Dw==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="56550996"
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="56550996"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 18:32:15 -0700
X-CSE-ConnectionGUID: lLbGmm3wRs6oQvZyeAd2xg==
X-CSE-MsgGUID: ETxZ+JWFQYys57YZkpM9SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,285,1744095600"; 
   d="scan'208";a="158867833"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 18:32:10 -0700
Message-ID: <d1cd2b34-9a3f-4dfc-93a2-2a20e9f16e1d@intel.com>
Date: Fri, 4 Jul 2025 09:32:07 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 2/2] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
To: Adrian Hunter <adrian.hunter@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, vannapurve@google.com
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 x86@kernel.org, H Peter Anvin <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kirill.shutemov@linux.intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, isaku.yamahata@intel.com, yan.y.zhao@intel.com,
 chao.gao@intel.com
References: <20250703153712.155600-1-adrian.hunter@intel.com>
 <20250703153712.155600-3-adrian.hunter@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250703153712.155600-3-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/2025 11:37 PM, Adrian Hunter wrote:
> Avoid clearing reclaimed TDX private pages unless the platform is affected
> by the X86_BUG_TDX_PW_MCE erratum. This significantly reduces VM shutdown
> time on unaffected systems.
> 
> Background
> 
> KVM currently clears reclaimed TDX private pages using MOVDIR64B, which:
> 
>     - Clears the TD Owner bit (which identifies TDX private memory) and
>       integrity metadata without triggering integrity violations.
>     - Clears poison from cache lines without consuming it, avoiding MCEs on
>       access (refer TDX Module Base spec. 16.5. Handling Machine Check
>       Events during Guest TD Operation).
> 
> The TDX module also uses MOVDIR64B to initialize private pages before use.
> If cache flushing is needed, it sets TDX_FEATURES.CLFLUSH_BEFORE_ALLOC.
> However, KVM currently flushes unconditionally, refer commit 94c477a751c7b
> ("x86/virt/tdx: Add SEAMCALL wrappers to add TD private pages")
> 
> In contrast, when private pages are reclaimed, the TDX Module handles
> flushing via the TDH.PHYMEM.CACHE.WB SEAMCALL.
> 
> Problem
> 
> Clearing all private pages during VM shutdown is costly. For guests
> with a large amount of memory it can take minutes.
> 
> Solution
> 
> TDX Module Base Architecture spec. documents that private pages reclaimed
> from a TD should be initialized using MOVDIR64B, in order to avoid
> integrity violation or TD bit mismatch detection when later being read
> using a shared HKID, refer April 2025 spec. "Page Initialization" in
> section "8.6.2. Platforms not Using ACT: Required Cache Flush and
> Initialization by the Host VMM"
> 
> That is an overstatement and will be clarified in coming versions of the
> spec. In fact, as outlined in "Table 16.2: Non-ACT Platforms Checks on
> Memory" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
> Mode" in the same spec, there is no issue accessing such reclaimed pages
> using a shared key that does not have integrity enabled. Linux always uses
> KeyID 0 which never has integrity enabled. KeyID 0 is also the TME KeyID
> which disallows integrity, refer "TME Policy/Encryption Algorithm" bit
> description in "Intel Architecture Memory Encryption Technologies" spec
> version 1.6 April 2025. So there is no need to clear pages to avoid
> integrity violations.
> 
> There remains a risk of poison consumption. However, in the context of
> TDX, it is expected that there would be a machine check associated with the
> original poisoning. On some platforms that results in a panic. However
> platforms may support "SEAM_NR" Machine Check capability, in which case
> Linux machine check handler marks the page as poisoned, which prevents it
> from being allocated anymore, refer commit 7911f145de5fe ("x86/mce:
> Implement recovery for errors in TDX/SEAM non-root mode")
> 
> Improvement
> 
> By skipping the clearing step on unaffected platforms, shutdown time
> can improve by up to 40%.
> 
> On platforms with the X86_BUG_TDX_PW_MCE erratum (SPR and EMR), continue
> clearing because these platforms may trigger poison on partial writes to
> previously-private pages, even with KeyID 0, refer commit 1e536e1068970
> ("x86/cpu: Detect TDX partial write machine check erratum")
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
> 
> 
> Changes in V2:
> 
> 	Improve the comment
> 
> 
>   arch/x86/virt/vmx/tdx/tdx.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 14d93ed05bd2..4fa86188aa40 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -642,6 +642,14 @@ void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
>   	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
>   	unsigned long phys, end;
>   
> +	/*
> +	 * Typically, any write to the page will convert it from TDX
> +	 * private back to normal kernel memory. Systems with the
> +	 * erratum need to do the conversion explicitly.

Can we call out that "system with erratum need to do the conversion 
explicitly via MOVDIR64B" ?

Without "via MOVDIR64B", it leads to the impression that explicit 
conversion with any write is OK for system with the erratum, and maybe 
the following code just happened to use movdir64b().

> +	 */
> +	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
> +		return;
> +
>   	end = base + size;
>   	for (phys = base; phys < end; phys += 64)
>   		movdir64b(__va(phys), zero_page);


