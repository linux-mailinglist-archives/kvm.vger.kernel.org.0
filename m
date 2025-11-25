Return-Path: <kvm+bounces-64479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DFC9C842A8
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 10:14:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 85DC34E8203
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 09:14:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56952FE06F;
	Tue, 25 Nov 2025 09:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NQSRp32x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734FD2D877D;
	Tue, 25 Nov 2025 09:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764062050; cv=none; b=Mxap4Wmfgq9jt1QsvHD4JaKaOIxPTXieqkGNSjXiaK+IyGRiyKTJrasOr+315RLsYeby+FeT2jRueKgMqVAu/J6Se3yaGVkKZhJy+m8PyC5I/3sBmvTP3D0OCZMQw8TcUUFM/aZULCt9o22SPW56M8h+M3EavuFuopuzztNGHzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764062050; c=relaxed/simple;
	bh=3lhJ6hy1eRtw+FaDUJ3gGgqvzhLKanxpNv7sYm/ergk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cqJXYkcd8ggl+C36cLZCWcq5dmt5JhXcscZMrpJY+CmWQlNcNOIcfshrRKODykvKzFzvizWYFHYB+ANJOjxd8HVdqYW139eu+fUQqWr2LkEYJEvNkDuUEaVMjRriohgMiWKDSaDtOqGZYr9UXd6GRGnZyYmtkIpzTjCOmLD34YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NQSRp32x; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764062049; x=1795598049;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=3lhJ6hy1eRtw+FaDUJ3gGgqvzhLKanxpNv7sYm/ergk=;
  b=NQSRp32xVmmglw+bsCSnI1bsMgtY7vHQQtq4DdBnWJUGPfo+jP2RdN+h
   gvD+Vdg4zusn0EYLfY/eNYDsQ+tDCxA+rZe3BRVHhBh1zVvZVFoOwq1wY
   80gksvWaxusGGv7m5NwqIS2pLGRsfjpPRslVSW4W7sbbRwN290C2gjfJ/
   STRagBwXR8wnxmMcPxOFsiSNC9RtrmuG7IiIBxcGXPb8YzmZCPTQVujS0
   3hIm8A6g4OyBltfpIiZ5GN2vRaI6hpMP4Eo1MiIh4yfqRJnATkNJUGy0Q
   Pid9TwvQ0DLDMWhwMnG5ZpnsAuD6IoCSACoYgbCSF3MoxcIkiIVZZ39B5
   A==;
X-CSE-ConnectionGUID: 2K5YJRr2STSnbsJUoi6jAQ==
X-CSE-MsgGUID: IBRqP4GWQDSY6yRc2bppZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="76698419"
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="76698419"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 01:14:08 -0800
X-CSE-ConnectionGUID: 5v6NpJF/QVmKtgmtwRIr5g==
X-CSE-MsgGUID: po6x+6lgTyeUIEXLTACSbg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="197064494"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 01:14:03 -0800
Message-ID: <3e09b8fb-a24c-4c50-9203-30dce333c4fc@linux.intel.com>
Date: Tue, 25 Nov 2025 17:14:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/16] KVM: TDX: Allocate PAMT memory for vCPU control
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
 <20251121005125.417831-11-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-11-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> TDX vCPU control structures are provided to the TDX module at 4KB page
> size and require PAMT backing. This means for Dynamic PAMT they need to
> also have 4KB backings installed.
>
> Previous changes introduced tdx_alloc_page()/tdx_free_page() that can
> allocate a page and automatically handle the DPAMT maintenance. Use them
> for vCPU control structures instead of alloc_page()/__free_page().
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [update log]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
> v3:
>   - Write log. Reame from “Allocate PAMT memory for TDH.VP.CREATE and
>     TDH.VP.ADDCX”.
>   - Remove new line damage
> ---
>   arch/x86/kvm/vmx/tdx.c | 12 +++++-------
>   1 file changed, 5 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 8c4c1221e311..b6d7f4b5f40f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -2882,7 +2882,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>   	int ret, i;
>   	u64 err;
>   
> -	page = alloc_page(GFP_KERNEL);
> +	page = tdx_alloc_page();
>   	if (!page)
>   		return -ENOMEM;
>   	tdx->vp.tdvpr_page = page;
> @@ -2902,7 +2902,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>   	}
>   
>   	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
> -		page = alloc_page(GFP_KERNEL);
> +		page = tdx_alloc_page();
>   		if (!page) {
>   			ret = -ENOMEM;
>   			goto free_tdcx;
> @@ -2924,7 +2924,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>   			 * method, but the rest are freed here.
>   			 */
>   			for (; i < kvm_tdx->td.tdcx_nr_pages; i++) {
> -				__free_page(tdx->vp.tdcx_pages[i]);
> +				tdx_free_page(tdx->vp.tdcx_pages[i]);
>   				tdx->vp.tdcx_pages[i] = NULL;
>   			}
>   			return -EIO;
> @@ -2952,16 +2952,14 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
>   
>   free_tdcx:
>   	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
> -		if (tdx->vp.tdcx_pages[i])
> -			__free_page(tdx->vp.tdcx_pages[i]);
> +		tdx_free_page(tdx->vp.tdcx_pages[i]);
>   		tdx->vp.tdcx_pages[i] = NULL;
>   	}
>   	kfree(tdx->vp.tdcx_pages);
>   	tdx->vp.tdcx_pages = NULL;
>   
>   free_tdvpr:
> -	if (tdx->vp.tdvpr_page)
> -		__free_page(tdx->vp.tdvpr_page);
> +	tdx_free_page(tdx->vp.tdvpr_page);
>   	tdx->vp.tdvpr_page = NULL;
>   	tdx->vp.tdvpr_pa = 0;
>   


