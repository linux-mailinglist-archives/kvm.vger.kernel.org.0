Return-Path: <kvm+bounces-17300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE0258C3B7A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:40:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2AF481C20F2A
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 06:40:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91A9514659C;
	Mon, 13 May 2024 06:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LmDFOlv8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83592E827;
	Mon, 13 May 2024 06:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715582420; cv=none; b=iehkJa1amsshWSXa2iOl6zcpL81LChqAU0HAQlMNsJ17wB8zmn1GuJsUkhwQxPKow9H+HObPgVoCNICAYq9qnMVR2X+x1BNYUIkWKlzWF07qWyPshySrIlmN8Na3Us79q4LF0R5I0hjJhy5Tvfkqc8ZYwRpwIP280gNWhK8OooE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715582420; c=relaxed/simple;
	bh=uzG1NRYWi2yexEAuHB1CHE56OAEUXMvlfKLTIAXojUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jp2oAFvWwZFxf31yyPv+BKQ7E8ixokWdAxyDO3e5KuZh97MGsFIjiiZyGsVBU77mIs5ecbw4NRBOysecQBZCjNPP69bb2TFGtWcbpau+zAbbF5SLr/vVpcEG76MPq9Dn9K85CHUViRHtSTOzoPl69DtWrSdxngcyl6iM/q9uS7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LmDFOlv8; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715582419; x=1747118419;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uzG1NRYWi2yexEAuHB1CHE56OAEUXMvlfKLTIAXojUY=;
  b=LmDFOlv85Jdflbtrkm38mq3/8paf7eVay3JM2hv2s3EI5cNNGIOHFaEb
   y6uNlnDF1S1sbl5qz178WCLhoNRaC35UpmryxLkClr0Qcnl0UM0eGQRQx
   WvxCcCMRbWb0HQbgWcBNjTyIj8Hwmz4B3cdoitZxd6Fc1tKBYiFpTsDVs
   Qkqat5Kak+Xzbov4AsS/aLUX7gfUeRvXOE59In2nb25pZ3LYIfJ+O3TIJ
   cqC8lQHDpd1GLMAKy/bTc9utVOqnfbXEXLJfU6cYukfRqB9n34qz6CCj3
   E8UlHRBkkOHqBk0GwrexjchT0RWQjE21plJX4VaFzTiH3hvfTooOjdF5i
   g==;
X-CSE-ConnectionGUID: 6m/hWYqcRAKpviY0vPeroA==
X-CSE-MsgGUID: 99RIpY1NTE6puAKovfHBiA==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="11656502"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="11656502"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:40:18 -0700
X-CSE-ConnectionGUID: 8k/GcUwASuqewR+5Xp1/AQ==
X-CSE-MsgGUID: GoGUzR3ATxa89SO6Hx8+FQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30318975"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:40:15 -0700
Message-ID: <90795694-93ce-4668-9059-efbaafd7f4f9@intel.com>
Date: Mon, 13 May 2024 14:40:13 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/17] KVM: x86/mmu: Sanity check that __kvm_faultin_pfn()
 doesn't create noslot pfns
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Kai Huang <kai.huang@intel.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-18-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-18-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> WARN if __kvm_faultin_pfn() generates a "no slot" pfn, and gracefully
> handle the unexpected behavior instead of continuing on with dangerous
> state, e.g. tdp_mmu_map_handle_target_level() _only_ checks fault->slot,
> and so could install a bogus PFN into the guest.
> 
> The existing code is functionally ok, because kvm_faultin_pfn() pre-checks
> all of the cases that result in KVM_PFN_NOSLOT, but it is unnecessarily
> unsafe as it relies on __gfn_to_pfn_memslot() getting the _exact_ same
> memslot, i.e. not a re-retrieved pointer with KVM_MEMSLOT_INVALID set.
> And checking only fault->slot would fall apart if KVM ever added a flag or
> condition that forced emulation, similar to how KVM handles writes to
> read-only memslots.
> 
> Cc: David Matlack <dmatlack@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Message-ID: <20240228024147.41573-17-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index d717d60c6f19..510eb1117012 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -4425,7 +4425,7 @@ static int kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>   	if (unlikely(is_error_pfn(fault->pfn)))
>   		return kvm_handle_error_pfn(vcpu, fault);
>   
> -	if (WARN_ON_ONCE(!fault->slot))
> +	if (WARN_ON_ONCE(!fault->slot || is_noslot_pfn(fault->pfn)))
>   		return kvm_handle_noslot_fault(vcpu, fault, access);
>   
>   	/*


