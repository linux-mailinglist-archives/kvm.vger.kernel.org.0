Return-Path: <kvm+bounces-64630-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 843E5C88C67
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 09:55:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 836B84E279A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 08:54:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFDE331B102;
	Wed, 26 Nov 2025 08:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="chjvhDSv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922BA219A86;
	Wed, 26 Nov 2025 08:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764147236; cv=none; b=vCxmlwxne/a5UyvFpMuao3LmW/88Z6nvyTdTVsg7JCAKOpSL/Ul+43En+9uCY05syeDG/+DZPbWRUpJQBKfjhugpr5kQZP8cjcIVKRXT9J5/fDdEwNZ/kMp3z8Qf4Isw1c5S8N8r2r0hAPTAVg+PYfmjof++2hf64Wvk8IqBhRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764147236; c=relaxed/simple;
	bh=GcJCeUzYW3rAHS/xy3+BKcSNNgv9xvPJbkZ7fPqWYQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qDjpS+F2c+HLmz6BQSSIPWqbvE9vArvvJyogD6aZIsJ5LwUWThwoUS5VIpYqQihW4jFHmx0ILlm1kLQ7INqVskirEa/u1RPEi7yx7T9/3E10CwfyBF3gZqSEnxyP5kwErQjt8jP1ed420X05k0txHigYl7hlIDWUPTT4Mdjt5Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=chjvhDSv; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764147234; x=1795683234;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=GcJCeUzYW3rAHS/xy3+BKcSNNgv9xvPJbkZ7fPqWYQg=;
  b=chjvhDSvMGI4wfEKxYGP0p56QW6dBYlbpaY0SczjkSHliFqdM+HUx3Ih
   tDsqf1rYMO3lA4EMzfmHOhytNEFnstGM/IzOOOpwlRlbikD47WMVrhjvM
   qurPTQDgfeCPAZfMu3fJLt5qDXnDshwK3gAK1jTLgUrScAu6wFklhCt3S
   zpAvxhdykup1kyfNZ/zZeB0BlC4DWYQhLVUHAD63eZAAflufp//LuPDIm
   msFToqro9UnojgJMkeeLyf9hhcuQ/o2ata354MAc6UxY+2+QgN4J5ngTx
   ewEO4omXvLv1n5Gavepfr6N3Z00rGeSrnXKFnLMZeHUnY0O7UuNC1E9I3
   g==;
X-CSE-ConnectionGUID: wqr9vRX7QpyKLi8QmwPAGg==
X-CSE-MsgGUID: TJ3+yJCbQZWWfJfuR+eTjw==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="77287063"
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="77287063"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 00:53:54 -0800
X-CSE-ConnectionGUID: CHD+AxMoQRajwuhy4D9fjg==
X-CSE-MsgGUID: 8fH566+MS1S78xX7KuTHSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,228,1758610800"; 
   d="scan'208";a="192015221"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 00:53:50 -0800
Message-ID: <7fd9ebae-58f9-4908-87db-4317f30deae6@linux.intel.com>
Date: Wed, 26 Nov 2025 16:53:47 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/16] KVM: TDX: Reclaim PAMT memory
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-15-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-15-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Call tdx_free_page() and tdx_pamt_put() on the paths that free TDX
> pages.
>
> The PAMT memory holds metadata for TDX-protected memory. With Dynamic
> PAMT, PAMT_4K is allocated on demand. The kernel supplies the TDX module
> with a few pages that cover 2M of host physical memory.
>
> PAMT memory can be reclaimed when the last user is gone. It can happen
> in a few code paths:
>
> - On TDH.PHYMEM.PAGE.RECLAIM in tdx_reclaim_td_control_pages() and
>    tdx_reclaim_page().
>
> - On TDH.MEM.PAGE.REMOVE in tdx_sept_drop_private_spte().
>
> - In tdx_sept_zap_private_spte() for pages that were in the queue to be
>    added with TDH.MEM.PAGE.ADD, but it never happened due to an error.
>
> - In tdx_sept_free_private_spt() for SEPT pages;
>
> Add tdx_pamt_put() for memory that comes from guest_memfd and use
> tdx_free_page() for the rest.

External page table pages are not from guest_memfd,  but tdx_pamt_put() is used
in tdx_sept_free_private_spt() for them.

>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [Minor log tweak]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> v4:
>   - Rebasing on post-populate series required some changes on how PAMT
>     refcounting was handled in the KVM_TDX_INIT_MEM_REGION path. Now
>     instead of incrementing DPAMT refcount on the fake add in the fault
>     path, it only increments it when tdh_mem_page_add() actually succeeds,
>     like in tdx_mem_page_aug(). Because of this, the special handling for
>     the case tdx_is_sept_zap_err_due_to_premap() cared about is unneeded.
>
> v3:
>   - Minor log tweak to conform kvm/x86 style.
> ---
>   arch/x86/kvm/vmx/tdx.c | 14 +++++++++++---
>   1 file changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 24322263ac27..f8de50e7dc7f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -360,7 +360,7 @@ static void tdx_reclaim_control_page(struct page *ctrl_page)
>   	if (tdx_reclaim_page(ctrl_page))
>   		return;
>   
> -	__free_page(ctrl_page);
> +	tdx_free_page(ctrl_page);
>   }
>   
>   struct tdx_flush_vp_arg {
> @@ -597,7 +597,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
>   
>   	tdx_quirk_reset_page(kvm_tdx->td.tdr_page);
>   
> -	__free_page(kvm_tdx->td.tdr_page);
> +	tdx_free_page(kvm_tdx->td.tdr_page);
>   	kvm_tdx->td.tdr_page = NULL;
>   }
>   
> @@ -1827,6 +1827,8 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
>   				     enum pg_level level, void *private_spt)
>   {
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> +	struct page *page = virt_to_page(private_spt);
> +	int ret;
>   
>   	/*
>   	 * free_external_spt() is only called after hkid is freed when TD is
> @@ -1843,7 +1845,12 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
>   	 * The HKID assigned to this TD was already freed and cache was
>   	 * already flushed. We don't have to flush again.
>   	 */
> -	return tdx_reclaim_page(virt_to_page(private_spt));
> +	ret = tdx_reclaim_page(virt_to_page(private_spt));
> +	if (ret)
> +		return ret;
> +
> +	tdx_pamt_put(page);
> +	return 0;
>   }
>   
>   static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> @@ -1895,6 +1902,7 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   		return;
>   
>   	tdx_quirk_reset_page(page);
> +	tdx_pamt_put(page);
>   }
>   
>   void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,


