Return-Path: <kvm+bounces-53429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A426AB11721
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 05:36:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBDD15668BB
	for <lists+kvm@lfdr.de>; Fri, 25 Jul 2025 03:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DDF0239E75;
	Fri, 25 Jul 2025 03:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LEn0fqwe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643C92E3718;
	Fri, 25 Jul 2025 03:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753414558; cv=none; b=hsvDG/vb3vbjNdISCpq7fpjXTj3l2GksY/ML98YVZb5ZYXAPGloK5MwHVeMeMNb3rZGVH+vBVwkar/EqmiwWxZW4T2ri+FG18ENty3dLxrQhx7xtN6LvCzbBno9qswkQMp/ctZs50WHg0W+lbLbhn3M4ONCRhlLj7f5OkWDbk5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753414558; c=relaxed/simple;
	bh=fSM8qKBVwuoT20nVh9UyGtR9/eq3hRTfSoz1iu805H0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IKqvGPNlb3Klsz2QaGpibiBBaBOeUPV/H8eLK4wKA60rmG2a28kC+IaPse714cD0Hq89jDBx4pr0zDo0Egoy40Jp5n0hgbu+6tz9dkVx6krsMGA18m3w6qiVi3kWGIsjld9bb3H+IHRv4aaOiFigMW9yLMGxf9ejuYlhl54HC4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LEn0fqwe; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753414556; x=1784950556;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=fSM8qKBVwuoT20nVh9UyGtR9/eq3hRTfSoz1iu805H0=;
  b=LEn0fqweGsOh84XrGmZOC9D8kk9y6285S7I5sZ8jtZgOzinJzhQAPYYk
   DCVIDRPKTLKTqCmO6U3cbITz2cTGTwj/r00Jq3P4brI8LlvppX+KRm4uZ
   jtVdKSlFm7KrhQPGYE5nOYWFLY9Zwn/4kt2pHr2FYNvmhErTmvMmM+ryx
   2dn2+vfiWCJ2Js1LzTc9SY/DxPHdHeZiV8JmVCwbf/QvzlYWflyFh2pQm
   0zBICbmiYFsTkJ6e7rPX3D4HAy7pgWJRugGFg4U+S2VUfH/JZ4fuo6DMQ
   Z8UTaJoyOQsoYF7KYNKCTBcRSjhOJHcdxkaWwzJAnUVKTBzOWHuIWLbNg
   Q==;
X-CSE-ConnectionGUID: jxJpZZl9SM+8JklzvY6Zxw==
X-CSE-MsgGUID: PU0fLAwzSz+IYtP4aw7Ntg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="59559665"
X-IronPort-AV: E=Sophos;i="6.16,338,1744095600"; 
   d="scan'208";a="59559665"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 20:35:54 -0700
X-CSE-ConnectionGUID: E/pMqGuFQQ2rAbiEeRc3ag==
X-CSE-MsgGUID: ObbI6PRXSmyELsQdBFwfxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,338,1744095600"; 
   d="scan'208";a="197778297"
Received: from unknown (HELO [10.238.3.238]) ([10.238.3.238])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 20:35:49 -0700
Message-ID: <09554ace-68f7-44ed-b798-28197b2cd195@linux.intel.com>
Date: Fri, 25 Jul 2025 11:35:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 3/3] x86/tdx: Skip clearing reclaimed pages unless
 X86_BUG_TDX_PW_MCE is present
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, pbonzini@redhat.com,
 seanjc@google.com, vannapurve@google.com, Tony Luck <tony.luck@intel.com>,
 Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, x86@kernel.org, H Peter Anvin
 <hpa@zytor.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 rick.p.edgecombe@intel.com, kas@kernel.org, kai.huang@intel.com,
 reinette.chatre@intel.com, xiaoyao.li@intel.com,
 tony.lindgren@linux.intel.com, isaku.yamahata@intel.com,
 yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250724130354.79392-1-adrian.hunter@intel.com>
 <20250724130354.79392-4-adrian.hunter@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250724130354.79392-4-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/24/2025 9:03 PM, Adrian Hunter wrote:
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
>       access (refer TDX Module Base spec. 1348549-006US section 6.5.
>       Handling Machine Check Events during Guest TD Operation).
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

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

>
> Reviewed-by: Kirill A. Shutemov <kas@kernel.org>
> Acked-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>
>
> Changes in V6:
>
> 	Add Xiaoyao's Rev'd-by
>
> Changes in V5:
>
> 	None
>
> Changes in V4:
>
> 	Add TDX Module Base spec. version (Rick)
> 	Add Rick's Rev'd-by
>
> Changes in V3:
>
> 	Remove "flush cache" comments (Rick)
> 	Update function comment to better relate to "quirk" naming (Rick)
> 	Add "via MOVDIR64B" to comment (Xiaoyao)
> 	Add Rev'd-by, Ack'd-by tags
>
> Changes in V2:
>
> 	Improve the comment
>
>
>   arch/x86/virt/vmx/tdx/tdx.c | 10 +++++++---
>   1 file changed, 7 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 9e4638f68ba0..823850399bb7 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -633,15 +633,19 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
>   }
>   
>   /*
> - * Convert TDX private pages back to normal by using MOVDIR64B to
> - * clear these pages.  Note this function doesn't flush cache of
> - * these TDX private pages.  The caller should make sure of that.
> + * Convert TDX private pages back to normal by using MOVDIR64B to clear these
> + * pages. Typically, any write to the page will convert it from TDX private back
> + * to normal kernel memory. Systems with the X86_BUG_TDX_PW_MCE erratum need to
> + * do the conversion explicitly via MOVDIR64B.
>    */
>   static void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
>   {
>   	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
>   	unsigned long phys, end;
>   
> +	if (!boot_cpu_has_bug(X86_BUG_TDX_PW_MCE))
> +		return;
> +
>   	end = base + size;
>   	for (phys = base; phys < end; phys += 64)
>   		movdir64b(__va(phys), zero_page);


