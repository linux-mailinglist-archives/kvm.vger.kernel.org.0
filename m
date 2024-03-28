Return-Path: <kvm+bounces-12987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DEE2688FA04
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 09:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4935D29403A
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 08:30:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E95356441;
	Thu, 28 Mar 2024 08:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="euVUhZE7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C294B26AD8;
	Thu, 28 Mar 2024 08:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711614597; cv=none; b=N7sSZAQf9HIjXtyts8QBNj4JvS/0cUzLAcFTwi4xFbS0vdb8cp/F+1Ye3xBbifKhsvQh2MWzFDvXy/EJDHpJiHpiLJsWMWT4VlFQOFS/XBpW+1XQWfrb+uBvjzFfy9SJUY19H7yYMOAZswucgimPgOr21uoIsp3Trovkw6Y3vAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711614597; c=relaxed/simple;
	bh=Xn5SRbo/tLLp83oxDcrfhoXAe/uHOAEhMew1J903Plo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pgjs8zvUEtoPWhI5kXV+7ox5QroeZo7JYhZpzB3MJQXkwCvnnVBur7IoXamv1W2xrDjG5nI07MrbTYyIcPakJytjbzpAT4DMc9e7+cqos+j0mW5YiFQvVkxjeNH0aFX/ZDXWABib0sCuv/2yS2a3VeaMT0KBhEKO2c3PnngGUS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=euVUhZE7; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711614596; x=1743150596;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Xn5SRbo/tLLp83oxDcrfhoXAe/uHOAEhMew1J903Plo=;
  b=euVUhZE7FIukN1euL84833Fd+GVjjvNXQqoyhHjHC2ocVPkjoOYPe1Bd
   lBVkMAqt+uatu41qeCwLs+j57F2DL3RYiHJpuVbFzkCwfS62ngtcSeVQ1
   vhxBV+PJ74bxus0SYxsd2szQU5z8HoJFgzHX8+kDqFyGXJZGz8zwcxOR3
   7xKGPI1hl0939YP6hrYoe3t33kCt6wg1D2k1QYJ6/GsxKR3GbcxHplvmv
   VR+3G4/L26hY+VXdQw+JB3TMtILfnmacg1YKQmGuxg8jvDNyws28m4Cq+
   g3Aih16rx2KonZ1T/bf5/oyJkf4CsQW39fDsHXi4kQGRz3PcRfApL+wTI
   w==;
X-CSE-ConnectionGUID: Pep6WMONSfWA3qWYbL29iQ==
X-CSE-MsgGUID: b4zQk01GR9urSzFUcOgUbA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6689945"
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="6689945"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 01:29:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,161,1708416000"; 
   d="scan'208";a="16518109"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.238.10.225]) ([10.238.10.225])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2024 01:29:52 -0700
Message-ID: <2f2b4b37-2b99-4373-8d0d-cc6bc5eed33f@linux.intel.com>
Date: Thu, 28 Mar 2024 16:29:50 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 060/130] KVM: x86/tdp_mmu: Apply mmu notifier callback
 to only shared GPA
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <dead197f278d047a00996f636d7eef4f0c8a67e8.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <dead197f278d047a00996f636d7eef4f0c8a67e8.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:26 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> The private GPAs that typically guest memfd backs aren't subject to MMU
> notifier because it isn't mapped into virtual address of user process.
> kvm_tdp_mmu_handle_gfn() handles the callback of the MMU notifier,
> clear_flush_young(), clear_young(), test_young()() and change_pte().  Make
                                                    ^
                                                    an extra "()"
> kvm_tdp_mmu_handle_gfn() aware of private mapping and skip private mapping.
>
> Even with AS_UNMOVABLE set, those mmu notifier are called.  For example,
> ksmd triggers change_pte().

The description about the "AS_UNMOVABLE", you are refering to shared 
memory, right?
Then, it seems not related to the change of this patch.

>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> ---
> v19:
> - type: test_gfn() => test_young()
>
> v18:
> - newly added
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/mmu/tdp_mmu.c | 22 +++++++++++++++++++++-
>   1 file changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index e7514a807134..10507920f36b 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1157,9 +1157,29 @@ static __always_inline bool kvm_tdp_mmu_handle_gfn(struct kvm *kvm,
>   	 * into this helper allow blocking; it'd be dead, wasteful code.
>   	 */
>   	for_each_tdp_mmu_root(kvm, root, range->slot->as_id) {
> +		gfn_t start, end;
> +
> +		/*
> +		 * This function is called on behalf of mmu_notifier of
> +		 * clear_flush_young(), clear_young(), test_young()(), and

^
                                                                an extra 
"()""

> +		 * change_pte().  They apply to only shared GPAs.
> +		 */
> +		WARN_ON_ONCE(range->only_private);
> +		WARN_ON_ONCE(!range->only_shared);
> +		if (is_private_sp(root))
> +			continue;
> +
> +		/*
> +		 * For TDX shared mapping, set GFN shared bit to the range,
> +		 * so the handler() doesn't need to set it, to avoid duplicated
> +		 * code in multiple handler()s.
> +		 */
> +		start = kvm_gfn_to_shared(kvm, range->start);
> +		end = kvm_gfn_to_shared(kvm, range->end);
> +
>   		rcu_read_lock();
>   
> -		tdp_root_for_each_leaf_pte(iter, root, range->start, range->end)
> +		tdp_root_for_each_leaf_pte(iter, root, start, end)
>   			ret |= handler(kvm, &iter, range);
>   
>   		rcu_read_unlock();


