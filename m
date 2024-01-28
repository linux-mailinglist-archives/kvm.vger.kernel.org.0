Return-Path: <kvm+bounces-7289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A3A183F5AD
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 14:56:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29C5E283858
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 13:56:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 610D22377A;
	Sun, 28 Jan 2024 13:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P7XXZ82h"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AEA23763;
	Sun, 28 Jan 2024 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.55.52.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706450203; cv=none; b=hcXwbakS2HDc8YzzIAz0GQxte/t1ZzM0YGhhherckfVSoyqmkSh4aaVRAqelPa+aDi8l1vAkJw6IBusV3MENAGZzVIaG67zhdGGPkmMvSO8k6YQHTSLJIdL00AWVyU1kEBVCzDsYXS+lD9ssh4LlHdS3TxHAWhWdc+f6WRNmrPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706450203; c=relaxed/simple;
	bh=HYf5vkbs92Q5b1nQIaJMZebTNdj/neOAHlaFnh9VJUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oBFHgWJI5zvhYFDD4ohxSBAxVVu3snHYA2yGhv6gpXPKWdItllPtMox7SYBxuvp2Cfdcm2NxHrL8K3g1Vebp5sWEJ0PY1JATirjUF83q3KCJ1lTSGAr4OJfyNEC8lv6XrIThrIqY8PGGEgHYC7Nn9I+NrRGIVAOdRwFP1eq5VxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P7XXZ82h; arc=none smtp.client-ip=192.55.52.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706450201; x=1737986201;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HYf5vkbs92Q5b1nQIaJMZebTNdj/neOAHlaFnh9VJUM=;
  b=P7XXZ82h2e8Zros2RZi6ilf1T0ytJxgoDJkJGwcpppGpN4+ymjsCYUZL
   noQYd9RxYV+0KOn9sAISBQUaNI744ne8hMz4DdQpBKQJH4wo+KOFYygRh
   zvDe5DO1xNCngCFgrPfSakG7aGp97Y3zmueLA5kYyYrsCebphmnHkW12v
   z0yw6EQShtIr8w7GyRCzqSKwHOf1XqgXTCIXtT6DkqL0YZ2ev4W+rC8+p
   Mi2wRecuVZcWU5DDKD9YfS5n2uaUutx6RWkRnBBsnZqU9nT7Lrzmm/u5v
   4GWOXwixpMguAz5MnwzoEKPcEg+RSV1bh5JUtcrV/f9inho5a6LWQfxzp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10966"; a="399928943"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="399928943"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 05:56:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="3041313"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.92]) ([10.93.8.92])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 05:56:38 -0800
Message-ID: <b99d50a4-f78d-49d6-bf24-80ea4f932b82@linux.intel.com>
Date: Sun, 28 Jan 2024 21:56:35 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 040/121] KVM: x86/mmu: Disallow fast page fault on
 private GPA
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <91c797997b57056224571e22362321a23947172f.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <91c797997b57056224571e22362321a23947172f.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX requires TDX SEAMCALL to operate Secure EPT instead of direct memory
> access and TDX SEAMCALL is heavy operation.  Fast page fault on private GPA
> doesn't make sense.  Disallow fast page fault on private GPA.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index b2924bd9b668..54d4c8f1ba68 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3339,8 +3339,16 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>   	return RET_PF_CONTINUE;
>   }
>   
> -static bool page_fault_can_be_fast(struct kvm_page_fault *fault)
> +static bool page_fault_can_be_fast(struct kvm *kvm, struct kvm_page_fault *fault)
>   {
> +	/*
> +	 * TDX private mapping doesn't support fast page fault because the EPT
> +	 * entry is read/written with TDX SEAMCALLs instead of direct memory
> +	 * access.
> +	 */
> +	if (kvm_is_private_gpa(kvm, fault->addr))
> +		return false;
> +
>   	/*
>   	 * Page faults with reserved bits set, i.e. faults on MMIO SPTEs, only
>   	 * reach the common page fault handler if the SPTE has an invalid MMIO
> @@ -3450,7 +3458,7 @@ static int fast_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
>   	u64 *sptep;
>   	uint retry_count = 0;
>   
> -	if (!page_fault_can_be_fast(fault))
> +	if (!page_fault_can_be_fast(vcpu->kvm, fault))
>   		return ret;
>   
>   	walk_shadow_page_lockless_begin(vcpu);


