Return-Path: <kvm+bounces-56248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B9AAB3B341
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 08:20:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 161F317932C
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 06:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CACF7239E8B;
	Fri, 29 Aug 2025 06:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EuY6Lb29"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6811FF7B3;
	Fri, 29 Aug 2025 06:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756448414; cv=none; b=mzFMkRrF5QHSLumb8xAR9oB914impTtduOD1TU1xp0XfCiVqY6qmQ9M5ZpJxw+TxozkuPDGjZXXMkHiCmaiAvpW8fmaIZdMD6zeZt5Tpy448I80nKs9vKQy1U0HTQ5MH52eK1QSvi7oi+2F2pNhd5XAPYDhJz40envrcHdw3vIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756448414; c=relaxed/simple;
	bh=vlNKkb1WrX314l7NI4WiDwPMbvh6QYy2ovez8YrbOFM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EKllzB0ZAE3bGmqbGy929o8Ou+eBdLjERY1qX7M1WVCya2IBQXXazTtn2oHUJ5DzTOqd6V0UlzSrQqIwFxTRwOPhCVXsr+gdm9SvJXefzzj37LbmdOxp0cOyfyI2ReFXlhCyPrB/s9XkqUYYpufOMOx9VppmVLEmrNHwjKitC5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EuY6Lb29; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756448412; x=1787984412;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=vlNKkb1WrX314l7NI4WiDwPMbvh6QYy2ovez8YrbOFM=;
  b=EuY6Lb29Po+kVQUw0vwID1uXmNGOccaou7viFKrHpFyXvKtBIZt5/j/M
   lYHqRVig4OaH3U+mCTtzDTomvkWtFQjrdionFvau/IYaNPW3zabndnjAm
   47+bXUlgDWC5TJ6GNauw0o1Kp5jFRcJeBwORoZt1YrLsTZ9k+hY1A0A2i
   LBKh1cofxXGF4kV5MnjaMp73T3p2tooUaQ51QEbuAJcEHRIgDrOfbw7+4
   3id1LaXL4cqabP6Nz6kfnZ8uT8jDTqCuWYVw2ySHOv2VQ3ISZ9KFbj2h5
   aVFSWixextZpTPBfI9UFb73tT3XozgiXzF0GzBbT2baRagHVmu8TEST/i
   g==;
X-CSE-ConnectionGUID: dfdlHPLRQ3uMBDY8V814aQ==
X-CSE-MsgGUID: b22UB2hpRYyov8RkXh3cdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="70100494"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="70100494"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:20:11 -0700
X-CSE-ConnectionGUID: z2iEO37NSxqTGOqrsQkT5Q==
X-CSE-MsgGUID: PKx+GO9cSlWoILj6NBzspA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169874675"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 23:20:08 -0700
Message-ID: <bf223bec-98f4-420f-a7fb-1056ea8725b4@linux.intel.com>
Date: Fri, 29 Aug 2025 14:20:05 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 01/18] KVM: TDX: Drop PROVE_MMU=y sanity check on
 to-be-populated mappings
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>,
 Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>,
 Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-2-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250829000618.351013-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/29/2025 8:06 AM, Sean Christopherson wrote:
> Drop TDX's sanity check that an S-EPT mapping isn't zapped between creating
                                  ^
                                 should be M-EPT?

> said mapping and doing TDH.MEM.PAGE.ADD, as the check is simultaneously
> superfluous and incomplete.  Per commit 2608f1057601 ("KVM: x86/tdp_mmu:
> Add a helper function to walk down the TDP MMU"), the justification for
> introducing kvm_tdp_mmu_gpa_is_mapped() was to check that the target gfn
> was pre-populated, with a link that points to this snippet:
>
>   : > One small question:
>   : >
>   : > What if the memory region passed to KVM_TDX_INIT_MEM_REGION hasn't been pre-
>   : > populated?  If we want to make KVM_TDX_INIT_MEM_REGION work with these regions,
>   : > then we still need to do the real map.  Or we can make KVM_TDX_INIT_MEM_REGION
>   : > return error when it finds the region hasn't been pre-populated?
>   :
>   : Return an error.  I don't love the idea of bleeding so many TDX details into
>   : userspace, but I'm pretty sure that ship sailed a long, long time ago.
>
> But that justification makes little sense for the final code, as simply
> doing TDH.MEM.PAGE.ADD without a paranoid sanity check will return an error
> if the S-EPT mapping is invalid (as evidenced by the code being guarded
> with CONFIG_KVM_PROVE_MMU=y).

I think this also needs to be updated.
As Yan mentioned in https://lore.kernel.org/lkml/aK6+TQ0r1j5j2PCx@yzhao56-desk.sh.intel.com/
TDH.MEM.PAGE.ADD would succeed without error, but error is still can be detected
via the value of nr_premapped in the end.

>
> The sanity check is also incomplete in the sense that mmu_lock is dropped
> between the check and TDH.MEM.PAGE.ADD, i.e. will only detect KVM bugs that
> zap SPTEs in a very specific window.
>
> Removing the sanity check will allow removing kvm_tdp_mmu_gpa_is_mapped(),
> which has no business being exposed to vendor code.
>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 14 --------------
>   1 file changed, 14 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 6784aaaced87..71da245d160f 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -3175,20 +3175,6 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>   	if (ret < 0)
>   		goto out;
>   
> -	/*
> -	 * The private mem cannot be zapped after kvm_tdp_map_page()
> -	 * because all paths are covered by slots_lock and the
> -	 * filemap invalidate lock.  Check that they are indeed enough.
> -	 */
> -	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
> -		scoped_guard(read_lock, &kvm->mmu_lock) {
> -			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
> -				ret = -EIO;
> -				goto out;
> -			}
> -		}
> -	}
> -
>   	ret = 0;
>   	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
>   			       src_page, &entry, &level_state);


