Return-Path: <kvm+bounces-17298-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BFA838C3B51
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:29:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76F2D1F21567
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 06:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 023E51465B3;
	Mon, 13 May 2024 06:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hnUOUzo2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDE1D14659C;
	Mon, 13 May 2024 06:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715581762; cv=none; b=SPxcxyM6QB7BbuJsnFTbjzgq0A/6QdWRZhjisSQlH0YWnYHLuiXSgsekhStscDS/oenMC0NJ16wdI18+fBVrygf049wibrDA8LyKzfDyQQyxYS/Nyqt4lbZDH/BlfwlKMTE0zEeEOuNhtVpWwOTlEMgQcLy7o09P1Cku56TGr3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715581762; c=relaxed/simple;
	bh=K7+q6mEcm0MecmJSlBCIXqsx3wgnaExLsqGzVizM7Xo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=itQUZ52xL4wLXKcH8Xft1dypKEi0u1OAarb4YkwzQx2FgUDeD3vF2a8tyz4UKkh8vtdZAAEVWCuk8H5qam3C123rj/lYJfVNEdMEEcHjtwk8dn+K95zHN5bsyYmcizjjHb/+atu7jGTTiVUYW3TV+mN9H+O/z7Qc22x/NwRs1qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hnUOUzo2; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715581760; x=1747117760;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=K7+q6mEcm0MecmJSlBCIXqsx3wgnaExLsqGzVizM7Xo=;
  b=hnUOUzo2x4jMNABw42639RXHQAgDkiKsB/hgWlmRajPuHEOhtxjRETdb
   6E8Q/HJfcZTIdrvptcde8QYL3dUm33x15waVQ0vpXUiLx1Fgd3yQrUuAY
   QmDHtTQ5E7I0wYdmaOt40t49daw1OGBtIfqbD89LniDW44OODLNzvs/rH
   k7asF4d8enWHehJw24RV5fps3Vaq1o20ER2r8FVm+1DRj9ruOhmyM5wY9
   L1MOfguspv8W571cldqIoGAHf8+zh38BBwgfWNEnlJHflqEmUdcHGIOpm
   GoDTQwIqJYdTYq93IsDSoMc+4HBssr7HH9XbRPwkZdpAvnxOhqITXVSDR
   A==;
X-CSE-ConnectionGUID: qaXgFiLhTBSut6dXHmBifw==
X-CSE-MsgGUID: 5g9tkjAqQT2ZvwizQvkQUA==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="11655697"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="11655697"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:29:19 -0700
X-CSE-ConnectionGUID: iqHQaP97SoWQmYvu0WAhNQ==
X-CSE-MsgGUID: 2F7NualDTfS34ToEW564sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30317533"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:29:18 -0700
Message-ID: <e9b58170-8746-42b9-a4a5-413736d47a7d@intel.com>
Date: Mon, 13 May 2024 14:29:15 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/17] KVM: x86/mmu: Initialize kvm_page_fault's pfn and
 hva to error values
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-17-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-17-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Explicitly set "pfn" and "hva" to error values in kvm_mmu_do_page_fault()
> to harden KVM against using "uninitialized" values.  In quotes because the
> fields are actually zero-initialized, and zero is a legal value for both
> page frame numbers and virtual addresses.  E.g. failure to set "pfn" prior
> to creating an SPTE could result in KVM pointing at physical address '0',
> which is far less desirable than KVM generating a SPTE with reserved PA
> bits set and thus effectively killing the VM.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Message-ID: <20240228024147.41573-16-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu_internal.h | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index dfd9ff383663..ce2fcd19ba6b 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -307,6 +307,9 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>   		.req_level = PG_LEVEL_4K,
>   		.goal_level = PG_LEVEL_4K,
>   		.is_private = err & PFERR_PRIVATE_ACCESS,
> +
> +		.pfn = KVM_PFN_ERR_FAULT,
> +		.hva = KVM_HVA_ERR_BAD,
>   	};
>   	int r;
>   


