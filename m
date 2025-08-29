Return-Path: <kvm+bounces-56267-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B363B3B817
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 12:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C8743B1166
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 10:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 148B23081CA;
	Fri, 29 Aug 2025 10:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JZwU9MUh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76499307ADA;
	Fri, 29 Aug 2025 10:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756461997; cv=none; b=lIgCDtA/e3OvPo/NJpjBHTw8tGODLpT+ZoBnDNMFXN9frMElHfMMwX3WXTtqdQiIzrbOqq2WhnT9hi9ueEkpShJsjPxAZohUsTGGXAdddEKLmEcprozt7C3kzf3+d4wDwDUJrXioprvmBnS4Y9QHoFzqidA2qOiGRThLhw8UlTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756461997; c=relaxed/simple;
	bh=NIMAGfxANMu7klhzsaxA6BjLgRez3q6HvW0h6mx3HA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qQHLZxNlJS/UiWFlf3Gpzu3pFj5PVggoR9mhBveMNJHQQqGTkjgHnoZF0VGEKwZAO0MQKwT7gB+6jPa2SFUX2rwX3YzWTySnvdrIxNaKl3sif5V4Xx/pRQ8bsQWZEb8YDtJtgh0btNOvS7sTOG5hb4yfK/IEMFQiqhYr4RD01h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JZwU9MUh; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756461995; x=1787997995;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NIMAGfxANMu7klhzsaxA6BjLgRez3q6HvW0h6mx3HA4=;
  b=JZwU9MUhttMY12xBAv0Svd342Hn1OaN42Da95+cBK7NDGBKetMnOOS31
   YzLsAropWJOeiLIm+d8uZqgrzJlpFHoqorhSSKRU4REWrlKCZzuFrL5gs
   +2Gno91dtE5xT/zpzK4bGGuR55fIn3qmtDZ8npb4+d0DB9KQPw9TVcyyL
   kzKlE1HeeT4pZiPp3hHOroh9xLvOcAZIvQhQ55LiAF30Ox5F7A1ab7DBs
   H/C24A8WCQ0Y8ylTymQ7990BKRvIQ1UH+KPqb/g6b0Kp7Sj4LiDWa/Jkg
   FXCIM7CcBfvv9V4E7oAiK6zHwcrSDQxB+tEbas+EwzghqeDC39nZnDaOb
   w==;
X-CSE-ConnectionGUID: we3XaqEOQDmeIfMX+1rK1Q==
X-CSE-MsgGUID: mcn1ISsmSOWdKJ1+4RuPVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58815373"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58815373"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 03:06:35 -0700
X-CSE-ConnectionGUID: Ix7pv8sYSUWfLu98Akt3Tg==
X-CSE-MsgGUID: lnwNeFyRRryj3EZMOYmnew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="170243930"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 03:06:23 -0700
Message-ID: <77514e15-2aa0-4a95-8ea3-641ddd7e2c43@linux.intel.com>
Date: Fri, 29 Aug 2025 18:06:18 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 10/18] KVM: TDX: Use atomic64_dec_return() instead
 of a poor equivalent
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>,
 Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>,
 Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ackerley Tng <ackerleytng@google.com>
References: <20250829000618.351013-1-seanjc@google.com>
 <20250829000618.351013-11-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250829000618.351013-11-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/29/2025 8:06 AM, Sean Christopherson wrote:
> Use atomic64_dec_return() when decrementing the number of "pre-mapped"
> S-EPT pages to ensure that the count can't go negative without KVM
> noticing.  In theory, checking for '0' and then decrementing in a separate
> operation could miss a 0=>-1 transition.  In practice, such a condition is
> impossible because nr_premapped is protected by slots_lock, i.e. doesn't
> actually need to be an atomic (that wart will be addressed shortly).
>
> Don't bother trying to keep the count non-negative, as the KVM_BUG_ON()
> ensures the VM is dead, i.e. there's no point in trying to limp along.
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> Reviewed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/vmx/tdx.c | 6 ++----
>   1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index cafd618ca43c..fe0815d542e3 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1725,10 +1725,9 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
>   		tdx_no_vcpus_enter_stop(kvm);
>   	}
>   	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
> -		if (KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
> +		if (KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm))
>   			return -EIO;
>   
> -		atomic64_dec(&kvm_tdx->nr_premapped);
>   		return 0;
>   	}
>   
> @@ -3151,8 +3150,7 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
>   		goto out;
>   	}
>   
> -	if (!KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
> -		atomic64_dec(&kvm_tdx->nr_premapped);
> +	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
>   
>   	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
>   		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {


