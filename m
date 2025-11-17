Return-Path: <kvm+bounces-63337-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E2EC62FC5
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 09:54:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id C98B94EB2D4
	for <lists+kvm@lfdr.de>; Mon, 17 Nov 2025 08:53:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF91A1DF248;
	Mon, 17 Nov 2025 08:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQZjklGL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E61320A0F;
	Mon, 17 Nov 2025 08:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763369609; cv=none; b=CpWrnKNB+0hFqlAf8uDNMQErYnMl4cARkOA0WvSyCGqEj8NrnyD0Z6r2C2D2Kb0INCsmB+A2iHuB767hox6THRN46wiXt1Pdeuwg2EbJX+WM8YyONPmcf5mBjL94qEC9SURmWfH8jTQWYfUKzNWUIc8CMAD7wW14mi1lf+uMjDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763369609; c=relaxed/simple;
	bh=AunLOyJgC5jZdtspWty73Gl8zbB+LD4+e4vJdXSs2Cc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F0beFE3OlxawhuspmG+T5dexMjZOqKehKsO0seMwLVt6fagIdL3uAQ90Y31Nc47sj5lwBQAAHsEe9Tdz5eD3L/ndDnAPicJutResT/DiGmqcIsthbVcT1xMWFGE9SlZF1nowDz0lrdYxmAnQUB1oMh+Wgm2Z8fVfQIFtv0RoKSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EQZjklGL; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763369606; x=1794905606;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=AunLOyJgC5jZdtspWty73Gl8zbB+LD4+e4vJdXSs2Cc=;
  b=EQZjklGLk+j9j3Q/jDn5v+tTQVacHilZNDBk76dTzDgHqQPaTSHO+/4F
   fyjBIUtXT5/EfwSzQP1DNmgbKQavQGqt7gzkql/PpopLNvrxKoAM4ZF7o
   IJ+g814j3koYn1COXmxfZeyH7yGOTg9LQdSGxUlcgPzHwzYSNWRK55a4S
   whzIUXhjz31J/X0gxXI0FtqeYQjaqsRyfhNVGsOtv0ky+Ea98zVXNcSEC
   QCiIsdGPyb4MCXOa/x8EcW8etzEtxWTwSJIQ38DEY0EvRRtev8YA3iYDp
   JpJslHCqU70V6GrU4rEUgKiU8gKmcPI65sFsT6rMjing89U2KTgi7VchC
   w==;
X-CSE-ConnectionGUID: haAbpKmmR7WpVb4TSfFrGw==
X-CSE-MsgGUID: 0h1jkkGwSQmqOfLHqhEixA==
X-IronPort-AV: E=McAfee;i="6800,10657,11615"; a="65264668"
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="65264668"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 00:53:25 -0800
X-CSE-ConnectionGUID: oKmuX6bpQRaHZBBMKhKZig==
X-CSE-MsgGUID: CRw9wYg1SgitB4ulQQEVgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,311,1754982000"; 
   d="scan'208";a="190190560"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Nov 2025 00:53:20 -0800
Message-ID: <60da8b1c-07ea-47fe-9bfd-d87bde294e3e@linux.intel.com>
Date: Mon, 17 Nov 2025 16:53:17 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 09/23] KVM: x86/tdp_mmu: Add split_external_spt
 hook called during write mmu_lock
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
 <20250807094320.4565-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250807094320.4565-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/7/2025 5:43 PM, Yan Zhao wrote:
[...]
>   /**
>    * handle_removed_pt() - handle a page table removed from the TDP structure
>    *
> @@ -765,12 +778,20 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>   	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
>   
>   	/*
> -	 * Users that do non-atomic setting of PTEs don't operate on mirror
> -	 * roots, so don't handle it and bug the VM if it's seen.
> +	 * Propagate changes of SPTE to the external page table under write
> +	 * mmu_lock.
> +	 * Current valid transitions:
> +	 * - present leaf to !present.
> +	 * - present non-leaf to !present.

Nit:
Maybe add a small note to limit the scenario, such as "after releasing the HKID"
or "during the TD teardown"?

> +	 * - present leaf to present non-leaf (splitting)
>   	 */
>   	if (is_mirror_sptep(sptep)) {
> -		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
> -		remove_external_spte(kvm, gfn, old_spte, level);
> +		if (!is_shadow_present_pte(new_spte))
> +			remove_external_spte(kvm, gfn, old_spte, level);
> +		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
> +			split_external_spt(kvm, gfn, old_spte, new_spte, level);
> +		else
> +			KVM_BUG_ON(1, kvm);
>   	}
>   
>   	return old_spte;


