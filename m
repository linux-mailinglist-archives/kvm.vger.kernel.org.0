Return-Path: <kvm+bounces-64478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 245F6C84287
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:11:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EBCAD4E824D
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 09:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 146C92FF644;
	Tue, 25 Nov 2025 09:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SSCV/SLF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1E62D8390;
	Tue, 25 Nov 2025 09:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764061894; cv=none; b=LnC4yXzz2+QV9aFICQ5dWHtewxRtK4PAyFegJm8XTV2xV8KJHkT+HmFDfbn4nKEF3VqsEaD8qbPLUGZx147AZEGZNZCCPD8aMbwMicrjISHg7GURAPV3YPLgV86fdFGNvrKh6XMF/G1mJaYxP+V8XD/1xTD+WbgAtrWzBPcL4Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764061894; c=relaxed/simple;
	bh=Pv2x6/d7lrO6sZIW1bbnKCxbfhqsZJJdNkWShg2nV0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kauW7ZX5U78Hcaq5LEhgi6FekNC0eeCIIpK4fTqx6fhgM+cCQIpr0FNje1YjzHUo1S3LlnzIu9z9MAzgvPiT1/8pfE7Mpf+GMTWAODGy7ovA2HnpaP08U5E7XdENtVFyBqw4SeQxSBulLuSJuN00Pnx3fUOQAHA6qmZyZVry8TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SSCV/SLF; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764061889; x=1795597889;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Pv2x6/d7lrO6sZIW1bbnKCxbfhqsZJJdNkWShg2nV0I=;
  b=SSCV/SLFZ7HDctrWWPvd4pzy5VCgyZzG0hGJFDz6xGAlBIUS2MSrBuCG
   93LfbWRc792Ne1bQij7wJ0Bpy6+0AQeo0ydYZ+36asLxXEfEfY3AwpWy1
   e2enZOab8nNG4YAaByKkbQ/mOlrOilid8L4x24Md4PYom0exuQxg9xvbE
   3Zp6dg1VI8rsSW8ySWGgxMAL1Ef4Wfw0U69s1GynR/cDvoKuumd6vkHmc
   qkc0WE4rk3IYHPO+D6MDdJYS6liKUlqHZY1dSzE4QHsgg8oQ0k0YF/XCX
   aQRvWlJrnnlagTjEd8nzg5K/UUv8X42EJ9UXcEH37+T0KHNOo7UCW9+al
   g==;
X-CSE-ConnectionGUID: W+oyeAvMR1q+OmZF1TaMcA==
X-CSE-MsgGUID: 7J1IGdZyRu2GwcID77XcGw==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76698156"
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="76698156"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 01:11:28 -0800
X-CSE-ConnectionGUID: 6ZY5i+58QsusNzHaoxfOTQ==
X-CSE-MsgGUID: skGEpnpPT5qsyZhF307jUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="197063699"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 01:11:22 -0800
Message-ID: <516a8e3d-cae6-440c-94f2-a648cd6c1749@linux.intel.com>
Date: Tue, 25 Nov 2025 17:11:19 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 09/16] KVM: TDX: Allocate PAMT memory for TD control
 structures
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-10-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-10-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> TDX TD control structures are provided to the TDX module at 4KB page size
> and require PAMT backing. This means for Dynamic PAMT they need to also
> have 4KB backings installed.
>
> Previous changes introduced tdx_alloc_page()/tdx_free_page() that can
> allocate a page and automatically handle the DPAMT maintenance. Use them
> for vCPU control structures instead of alloc_page()/__free_page().

vCPU -> TD

>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [update log]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
One typo above.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
> v3:
>   - Write log. Rename from “KVM: TDX: Allocate PAMT memory in __tdx_td_init()”
> ---
>   arch/x86/kvm/vmx/tdx.c | 16 ++++++----------
>   1 file changed, 6 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 0eed334176b3..8c4c1221e311 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2398,7 +2398,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>   
>   	atomic_inc(&nr_configured_hkid);
>   
> -	tdr_page = alloc_page(GFP_KERNEL);
> +	tdr_page = tdx_alloc_page();
>   	if (!tdr_page)
>   		goto free_hkid;
>   
> @@ -2411,7 +2411,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>   		goto free_tdr;
>   
>   	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
> -		tdcs_pages[i] = alloc_page(GFP_KERNEL);
> +		tdcs_pages[i] = tdx_alloc_page();
>   		if (!tdcs_pages[i])
>   			goto free_tdcs;
>   	}
> @@ -2529,10 +2529,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>   teardown:
>   	/* Only free pages not yet added, so start at 'i' */
>   	for (; i < kvm_tdx->td.tdcs_nr_pages; i++) {
> -		if (tdcs_pages[i]) {
> -			__free_page(tdcs_pages[i]);
> -			tdcs_pages[i] = NULL;
> -		}
> +		tdx_free_page(tdcs_pages[i]);
> +		tdcs_pages[i] = NULL;
>   	}
>   	if (!kvm_tdx->td.tdcs_pages)
>   		kfree(tdcs_pages);
> @@ -2548,15 +2546,13 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
>   
>   free_tdcs:
>   	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
> -		if (tdcs_pages[i])
> -			__free_page(tdcs_pages[i]);
> +		tdx_free_page(tdcs_pages[i]);
>   	}
>   	kfree(tdcs_pages);
>   	kvm_tdx->td.tdcs_pages = NULL;
>   
>   free_tdr:
> -	if (tdr_page)
> -		__free_page(tdr_page);
> +	tdx_free_page(tdr_page);
>   	kvm_tdx->td.tdr_page = NULL;
>   
>   free_hkid:


