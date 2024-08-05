Return-Path: <kvm+bounces-23185-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C29809475E7
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 09:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84E212810E7
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 07:20:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10C671494D4;
	Mon,  5 Aug 2024 07:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fLLIB/cy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 671361494BC;
	Mon,  5 Aug 2024 07:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722842418; cv=none; b=OQNtxMBW/LNwdRqQQ+S98gPBoqvIItHkBhhWorrgkkNIaW1QvSwLoTI46RwuyGnTHDbeKXPedSQl6LQxMdufBNdi5HZi3nNXJBdXbjVlbsDmHolMYr85Vadd7uFM+oBMcaflHvd//jWJCIXw9c3dm9WPZrkelKy+Ac6ZEfDfn5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722842418; c=relaxed/simple;
	bh=1n6g19dsNSw+2gqbHcdx8WUEJqhDEYIyyfvmlkYwSoE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hBtHka6eik2iejxxHE0INTOza6aL1DJ8xv034HxHyet69qPdRBOZzpwzl5wiD8m84E4chbGIEv6cdkj9zQ+erHGJa7ghhApgiqHsauvpIdtGG1RiGCjex+l/WLYB3wj/QgdnCQ00NHMgTjbmFbLPHwiH9pqz/5eCrtUXzK7n7dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fLLIB/cy; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722842417; x=1754378417;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=1n6g19dsNSw+2gqbHcdx8WUEJqhDEYIyyfvmlkYwSoE=;
  b=fLLIB/cyrhZ2mmzJ5YsI5dzIQV/Ta/x8tAzhRkd6uuTTgkgQ4mCrf7Xi
   Ka5HwpL51jfWMcW5CyZDQ8ZSzwo0+gRAtoxwqlvt8lBWUARBKEVRgYVzw
   7Pw6TKZ1MlgLd9e72I6+yH029QqWV8ek9nKV8KewkzHgsgcz4/AzFP+pS
   teIx3Xx5GqHha0GFRiDxZPIejIJP72nPAsPEJBbLW1kKSZl0CuZBF7C7a
   0+HaF4+YiqQpOVz492URHLoQkewBxKVVue/CIYItJUZE16YE0RDbE8YCO
   n5Kz+q/9zDX94mRKohnwzlP0Vi/ezpHBlcwbH3xrJRUFSjYSrdhakdFAZ
   A==;
X-CSE-ConnectionGUID: TDnc+VKYSOiG2CNZpJ5/Zg==
X-CSE-MsgGUID: kSYc0cLhQw2J6Ko+7X8PdA==
X-IronPort-AV: E=McAfee;i="6700,10204,11154"; a="38289159"
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="38289159"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 00:20:16 -0700
X-CSE-ConnectionGUID: tEmXSW1KTtmPDAKJ7FIAeg==
X-CSE-MsgGUID: SNfEYfy4QZCNJEXNUE7NfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,264,1716274800"; 
   d="scan'208";a="55742296"
Received: from yy-desk-7060.sh.intel.com (HELO localhost) ([10.239.159.76])
  by fmviesa006.fm.intel.com with ESMTP; 05 Aug 2024 00:20:15 -0700
Date: Mon, 5 Aug 2024 15:20:13 +0800
From: Yuan Yao <yuan.yao@linux.intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 5/9] KVM: x86/mmu: Free up A/D bits in FROZEN_SPTE
Message-ID: <20240805072013.i3ib4h7eadlzzglm@yy-desk-7060>
References: <20240801183453.57199-1-seanjc@google.com>
 <20240801183453.57199-6-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240801183453.57199-6-seanjc@google.com>
User-Agent: NeoMutt/20171215

On Thu, Aug 01, 2024 at 11:34:49AM -0700, Sean Christopherson wrote:
> Remove all flavors of A/D bits from FROZEN_SPTE so that KVM can keep A/D
> bits set in SPTEs that are frozen, without getting false positives.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/mmu/spte.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index ba7ff1dfbeb2..d403ecdfcb8e 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -216,15 +216,17 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>   * should not modify the SPTE.
>   *
>   * Use a semi-arbitrary value that doesn't set RWX bits, i.e. is not-present on
> - * both AMD and Intel CPUs, and doesn't set PFN bits, i.e. doesn't create a L1TF
> - * vulnerability.
> + * both AMD and Intel CPUs, doesn't set any A/D bits, and doesn't set PFN bits,
> + * i.e. doesn't create a L1TF vulnerability.
>   *
>   * Only used by the TDP MMU.
>   */
> -#define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
> +#define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x498ULL)

Question:
Why bit3 and bit4 also changed from 0 to 1 ?
They're not part of AD bits fro EPT and CR3 page table/AMD NPT

EPT: Abit:8 Dbit:9
CR3: Abit:5 Dbit:6

>
>  /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
>  static_assert(!(FROZEN_SPTE & SPTE_MMU_PRESENT_MASK));
> +static_assert(!(FROZEN_SPTE & (PT_ACCESSED_MASK | VMX_EPT_ACCESS_BIT)));
> +static_assert(!(FROZEN_SPTE & (PT_DIRTY_MASK | VMX_EPT_DIRTY_BIT)));
>
>  static inline bool is_frozen_spte(u64 spte)
>  {
> --
> 2.46.0.rc1.232.g9752f9e123-goog
>
>

