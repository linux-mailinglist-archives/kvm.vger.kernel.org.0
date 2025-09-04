Return-Path: <kvm+bounces-56806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82486B435C7
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:31:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3E1AC5A0F35
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97D052C0303;
	Thu,  4 Sep 2025 08:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FBQibgZv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345F832F775;
	Thu,  4 Sep 2025 08:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756974653; cv=none; b=t/drxuFhl6C/RNtfcgZKzDjjwM1cmVTOESx9YCzDilB9O7Byzcvz4IoXTa9laJL/i9yRfUITyNxXgB+tYMqwQz+mP4cSImAL7itxNccXFqCmlWvuW70TnRDW4TbdrTosynCpcBPqAmh9o8FCnMrvBsBlFktu8PQL9N7cwyzVmpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756974653; c=relaxed/simple;
	bh=MsF1HR3chZW/DsuL6znagb7Yadd+L8PV3E//3Vse2Aw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aO8rV6ZD3cCcpXe8XVnpsyx3DXc5A2sHHQoLKv9tSec4+Rflwza3Voa7octRGgSFsGBSliTiQ9dxxV2t0R5ZpC47h+TAAUu22tyrL7tYwO4NAPYvu51LsbXAdPiJNwFHV0WFGxneHKBXqReQrZOMI+PC6mAgYq3L6Sf4oMesoQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FBQibgZv; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756974652; x=1788510652;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MsF1HR3chZW/DsuL6znagb7Yadd+L8PV3E//3Vse2Aw=;
  b=FBQibgZvRQg7AswJLwi3zHy+H+OQ7/S6rbZgavJburtLWhSSIIYIuSjr
   /80+mEhhniddRaC+Q9klOCgAgoTxasHPNR0XJpzDNZpuWPQ2v2SWB1/11
   Ub+vq6znqb45TGzAF07Hpu5wF7eZSw+XWWrQ3iKbeyU+hf0nuuIrgwJem
   bkwNVajBS5AW9SAhlGzUkFTou77ZILSvYui9EI9WAo2E5G8YygEFH2x1s
   LAx+u2xxSEsGGctLiAHBwblaoJpo63wTPOgLV6scuAA5RN3Za+/8GwFrb
   O8GFqMN7vGlBxqDx2A3gjIiKC9xsE5AExQcKzKTwbxDPVf06BEO7yOKeB
   g==;
X-CSE-ConnectionGUID: LeV1r7zkRb6hJx1zKA4bPg==
X-CSE-MsgGUID: 1Iy4a2YbTcOnyWhslgbOiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11542"; a="76908978"
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="76908978"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 01:30:52 -0700
X-CSE-ConnectionGUID: HYfq4vrQQwikTfgDBeAQxw==
X-CSE-MsgGUID: d267pWpoSLaa865mT0NTUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,237,1751266800"; 
   d="scan'208";a="171410140"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2025 01:30:46 -0700
Message-ID: <6fc69050-bd96-401f-8226-947b94a1f027@linux.intel.com>
Date: Thu, 4 Sep 2025 16:30:44 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 19/23] KVM: TDX: Pass down pfn to
 split_external_spt()
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kas@kernel.org, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094537.4732-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094537.4732-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/7/2025 5:45 PM, Yan Zhao wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Pass down pfn to kvm_x86_ops::split_external_spt(). It is required for
> handling Dynamic PAMT in tdx_sept_split_private_spt().
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> ---
> RFC v2:
> - Pulled from
>    git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git tdx/dpamt-huge.
> - Rebased on top of TDX huge page RFC v2 (Yan)
> ---
>   arch/x86/include/asm/kvm_host.h | 3 ++-
>   arch/x86/kvm/mmu/tdp_mmu.c      | 6 +++++-
>   arch/x86/kvm/vmx/tdx.c          | 3 ++-
>   3 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 6cb5b422dd1d..6b6c46c27390 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1841,7 +1841,8 @@ struct kvm_x86_ops {
>   
>   	/* Split the external page table into smaller page tables */
>   	int (*split_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> -				  void *external_spt, bool mmu_lock_shared);
> +				  kvm_pfn_t pfn_for_gfn, void *external_spt,
> +				  bool mmu_lock_shared);
>   
>   	bool (*has_wbinvd_exit)(void);
>   
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 62a09a9655c3..eb758aaa4374 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -389,11 +389,15 @@ static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
>   			      u64 new_spte, int level, bool shared)
>   {
>   	void *external_spt = get_external_spt(gfn, new_spte, level);
> +	kvm_pfn_t pfn_for_gfn = spte_to_pfn(old_spte);
>   	int ret;
>   
>   	KVM_BUG_ON(!external_spt, kvm);
>   
> -	ret = kvm_x86_call(split_external_spt)(kvm, gfn, level, external_spt, shared);
> +	ret = kvm_x86_call(split_external_spt)(kvm, gfn, level,
> +					       pfn_for_gfn, external_spt,
> +					       shared);

It can save one line by moving "pfn_for_gfn" up.

> +
>   	return ret;
>   }
>   /**
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 71115058e5e6..24aa9aaad6d8 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1941,7 +1941,8 @@ static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
>   }
>   
>   static int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> -				      void *private_spt, bool mmu_lock_shared)
> +				      kvm_pfn_t pfn_for_gfn, void *private_spt,
> +				      bool mmu_lock_shared)
>   {
>   	struct page *page = virt_to_page(private_spt);
>   	int ret;


