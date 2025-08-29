Return-Path: <kvm+bounces-56261-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 464E9B3B79A
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 11:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A51F93AE991
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 09:40:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2626304BA8;
	Fri, 29 Aug 2025 09:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W0hLJHgY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76901220F49;
	Fri, 29 Aug 2025 09:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756460409; cv=none; b=bcY3Lw52VkY7Qd+UN342yRwMR+6dBEi78Q2AlTm6nheUzqkVWmoDkvOxRTuLNFtmCGNkKYLnQI4MCvKc8TSl2BMbXWUUGU73LCghN42vWxAvFCzZOMQMMj7Xr9no2sRF9RMCsVChgtDJIVXe06ArQcXyBzxVYYbrJNqtuyc5YGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756460409; c=relaxed/simple;
	bh=Q5/9XsFtWSJoZmQhiX9wJOsCdwjpvOkcJd8IyfdNQNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iqkexCHnpIOw4flz4UpS3UX6PGMLEAp/+YKpMA4IL2mV6ptA86+75dGkNnkueCe7dNnhnkjiWCx7HcR1nKDLxRHg75umM/n1YHGJ6Z5xbWaRL3R3gmx33yWZ4RaXI2nwFDYWnvDLpo/yrtM4h0NLW7m80UGB7WwjBxxjww0H8og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W0hLJHgY; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756460408; x=1787996408;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Q5/9XsFtWSJoZmQhiX9wJOsCdwjpvOkcJd8IyfdNQNo=;
  b=W0hLJHgYy4OZyc/vselz2HcdJs7/n2pO5JDN6JY5RbB7GUrbclePLTjG
   v/G1MR8De7hDgPoZ8j/Dv2pdgW1cC/uFw9BxuXk6fakgkeR/VPIrznZLK
   uEjv5UZwHkHiOWibBfrQk1uXLObKR3c1vlulI23KZeniXG/N3Z88gK4aK
   kX6HhYlLAitRLuFHE+vvlYZZreo04RrxdI0/Tt0+z3LrnjtZzM5IZnGaB
   O99c3Bk6bGhJJOcOrRoPuljsx8ovjFkntlLrNJ0qCmZTlHAaOBJxVrrwJ
   rxKpx6Ax+eKSWF8pNX4gwRrQVBHPENwFRuaAPmsdSqMNuUriBZGxdRESv
   g==;
X-CSE-ConnectionGUID: OTcI6THtQ6eo4+vfVb11ew==
X-CSE-MsgGUID: R0IPGc9fRtqocktSJSxGPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="69452300"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="69452300"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:40:08 -0700
X-CSE-ConnectionGUID: k9vGSEupRdW+j1M1Z0AHBA==
X-CSE-MsgGUID: Aq0UkuUZQo23z76f+3dUug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="175636874"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 02:40:04 -0700
Message-ID: <506f90ed-ff2b-49f9-b1c3-4fb84577dbee@linux.intel.com>
Date: Fri, 29 Aug 2025 17:40:01 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 06/18] KVM: TDX: Return -EIO, not -EINVAL, on a
 KVM_BUG_ON() condition
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-7-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250829000618.351013-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/2025 8:06 AM, Sean Christopherson wrote:
> Return -EIO when a KVM_BUG_ON() is tripped, as KVM's ABI is to return -EIO
> when a VM has been killed due to a KVM bug, not -EINVAL.  Note, many (all?)
> of the affected paths never propagate the error code to userspace, i.e.
> this is about internal consistency more than anything else.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index f24f8635b433..50a9d81dad53 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1624,7 +1624,7 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
>   	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>   
>   	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
> -		return -EINVAL;
> +		return -EIO;
>   
>   	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
>   	atomic64_inc(&kvm_tdx->nr_premapped);
> @@ -1638,7 +1638,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>   
>   	/* TODO: handle large pages. */
>   	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> -		return -EINVAL;
> +		return -EIO;
>   
>   	/*
>   	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
> @@ -1661,10 +1661,10 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
>   
>   	/* TODO: handle large pages. */
>   	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> -		return -EINVAL;
> +		return -EIO;
>   
>   	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
> -		return -EINVAL;
> +		return -EIO;
>   
>   	/*
>   	 * When zapping private page, write lock is held. So no race condition
> @@ -1849,7 +1849,7 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
>   	 * and slot move/deletion.
>   	 */
>   	if (KVM_BUG_ON(is_hkid_assigned(kvm_tdx), kvm))
> -		return -EINVAL;
> +		return -EIO;
>   
>   	/*
>   	 * The HKID assigned to this TD was already freed and cache was
> @@ -1870,7 +1870,7 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
>   	 * there can't be anything populated in the private EPT.
>   	 */
>   	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
> -		return -EINVAL;
> +		return -EIO;
>   
>   	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
>   	if (ret <= 0)


