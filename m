Return-Path: <kvm+bounces-47067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 89F61ABCEB1
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 07:41:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85D44189D88E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 05:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190B025B1DA;
	Tue, 20 May 2025 05:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WNHAIq1O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701C7BE49;
	Tue, 20 May 2025 05:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747719657; cv=none; b=eAqBvPArqR3V8GzAle7XzF241R0W1VAmpCXmMUqyGTiPqsAtOqZM/uiRZpsnvmQlhx/BE7GYZmzphsSy/yYSIUru5lTGXGPUtazNEzq4zQaBJ1+qchNAds3uOljMi90aWryQYfJV39IipC7Uu7MlesCos/0X/Lagqol1AJGbiEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747719657; c=relaxed/simple;
	bh=qlj/6e6X01GkMcGwCxlRwl1VobEAwal3xID5pNyK+dM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sLgBdvL8rmUuh1IB61tVoPeAnDvbmDi8HQGdE2fRtpKAHFseeVxBoNrqPqHH0ZuHjXawI0OCH918lqU6cdxRsy2D0oJoE1XJhXFjlV8gfpL8URIXWnTEUDvnohrCPnkMYJw0EepRTb+I5f6RdiDyGCItJBs2NKIN3Dxdj1NJwMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WNHAIq1O; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747719656; x=1779255656;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qlj/6e6X01GkMcGwCxlRwl1VobEAwal3xID5pNyK+dM=;
  b=WNHAIq1Ozrc1qxbLod5iowKd8VxxgwOFcF7V5JuJfKgYtEWcehReTOuz
   GkyX/KBjH0NdTx92DYahTH3eFsWRHKM0Sdeuk+ATj3Ouez2EJfFG61Asr
   j52N5f/wb71CT+fyq3AzsKHNxmUPWEzRbLePck8cyHhDTzsAWj5maSju+
   hlloAGMI6xTB2+ANm5wTKg9Zizy1RAI1kFVArnHrJflvspJp0SU9jv/1w
   9F/KhrqbXzx4doioN1M2Z4ZeNoY1yio8EUUYoqc4TVDaOM5T0jvWeR/m8
   K4+FcTE2QU8gMyWN3csHroMcsvKA7jFMG3h/UMGGcSz7kWVUTHqRl6LkG
   g==;
X-CSE-ConnectionGUID: Aop2VF/TSwO7CU/DoCZ1TA==
X-CSE-MsgGUID: JeyccDEiRymccn520OeBhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="61028900"
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="61028900"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 22:40:55 -0700
X-CSE-ConnectionGUID: 0Vv3Su49SAuaWuj6M1qcYQ==
X-CSE-MsgGUID: 6q6mvkm4S9SBgPjoFkWBpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,302,1739865600"; 
   d="scan'208";a="144334532"
Received: from unknown (HELO [10.238.12.207]) ([10.238.12.207])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 22:40:49 -0700
Message-ID: <1e1b26b5-2f42-4451-b9a4-69f9805ea05a@linux.intel.com>
Date: Tue, 20 May 2025 13:40:46 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: pbonzini@redhat.com, seanjc@google.com, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, rick.p.edgecombe@intel.com,
 dave.hansen@intel.com, kirill.shutemov@intel.com, tabba@google.com,
 ackerleytng@google.com, quic_eberman@quicinc.com, michael.roth@amd.com,
 david@redhat.com, vannapurve@google.com, vbabka@suse.cz, jroedel@suse.de,
 thomas.lendacky@amd.com, pgonda@google.com, zhiquan1.li@intel.com,
 fan.du@intel.com, jun.miao@intel.com, ira.weiny@intel.com,
 isaku.yamahata@intel.com, xiaoyao.li@intel.com, chao.p.peng@intel.com
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030744.435-1-yan.y.zhao@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250424030744.435-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/2025 11:07 AM, Yan Zhao wrote:
[...]
>   
> +static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
> +			      u64 new_spte, int level)
> +{
> +	void *external_spt = get_external_spt(gfn, new_spte, level);
> +	int ret;
> +
> +	KVM_BUG_ON(!external_spt, kvm);
> +
> +	ret = static_call(kvm_x86_split_external_spt)(kvm, gfn, level, external_spt);
Better to use kvm_x86_call() instead of static_call().

> +	KVM_BUG_ON(ret, kvm);
> +
> +	return ret;
> +}
>   /**
>    * handle_removed_pt() - handle a page table removed from the TDP structure
>    *
> @@ -764,13 +778,13 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
>   
>   	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
>   
> -	/*
> -	 * Users that do non-atomic setting of PTEs don't operate on mirror
> -	 * roots, so don't handle it and bug the VM if it's seen.
> -	 */
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


