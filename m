Return-Path: <kvm+bounces-17294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ABB88C3B44
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 08:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4301A1F2150D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 06:26:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97ABB1465A7;
	Mon, 13 May 2024 06:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GXwvyxGd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4EA14C81;
	Mon, 13 May 2024 06:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715581577; cv=none; b=aWD9HeEsHymLGBHKphtgwzmYWRcPBsUu2gJ9oYjuWMkhGZ1VqQIbUYpbLm6yw18lnuhOf4TvdB9SKoz5RM0O+8DLAF6qIwHyOpQuhEkO34DlQ17elQ7ULfguuuVsOjVEamllWyXQObHYCC1Z0DbkO9Jk600BcAVZmGrsrmC2JYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715581577; c=relaxed/simple;
	bh=MWdlplndc9rDiHkP16y3eslcMJfUqvRXaa/TbMqhlVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HUV6p61qzpxFcZM/AnOnzSyl5sTYQ3keUoRYDqRgf46UmwBP7GDZimAep6mcUW7jdarWKd2UTWy2FPq3gXcTDi0fh4WfblxYs4JbHezUpZby4Z1v605KGSuSX3bLI5u1dxWfLXzY/mk2sGw5C2UyXVIV8obePimQ78CAxKDxLA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GXwvyxGd; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715581575; x=1747117575;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=MWdlplndc9rDiHkP16y3eslcMJfUqvRXaa/TbMqhlVs=;
  b=GXwvyxGdRqeyir4fwxDGGlBZE7779Q0MdBM/7ePzq6gIdg0OY06fep0N
   pQDqxIdVufY3vLnNPECzgToqXjZ8Iwx+KVnkyzbvyAIU5+zGKuYemrLfM
   lswHhCTCmdNp9QizN5X5CT2BXiTRDfrbof5ITL8PczC+e6UzIzaAGLHpM
   M9cGi+0Td4o5zqsy0PBH6szAiimb3fmaGiwvkCs9A1Gh0a7iRlA2A1wev
   FwxkH4VdFNXhZJnPE/AsbY+H4/lp3arQkLodvzRywjQ2zYC4Bb+o/q5ff
   qugjHI4OZtB2ISchPpf31KP36pm/nUHY/CuxKkWXLjx+bMi4FjELfaN2S
   A==;
X-CSE-ConnectionGUID: eLShf6ddThKEpOkqsI2cRA==
X-CSE-MsgGUID: 06TLwTV3R7iusA16bqVBOg==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="22074077"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="22074077"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:26:15 -0700
X-CSE-ConnectionGUID: Vu7dyGRTQ9emitIYQZ1E/w==
X-CSE-MsgGUID: ad4RAOq4TnmfTZf47a+oIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="67724664"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.198]) ([10.125.243.198])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 May 2024 23:26:14 -0700
Message-ID: <7ac92806-b2a4-42da-b223-e5dc1cd65884@intel.com>
Date: Mon, 13 May 2024 14:26:11 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/17] KVM: x86/mmu: Explicitly disallow private accesses
 to emulated MMIO
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>
References: <20240507155817.3951344-1-pbonzini@redhat.com>
 <20240507155817.3951344-13-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240507155817.3951344-13-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/2024 11:58 PM, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Explicitly detect and disallow private accesses to emulated MMIO in
> kvm_handle_noslot_fault() instead of relying on kvm_faultin_pfn_private()
> to perform the check.  This will allow the page fault path to go straight
> to kvm_handle_noslot_fault() without bouncing through __kvm_faultin_pfn().
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Message-ID: <20240228024147.41573-12-seanjc@google.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> ---
>   arch/x86/kvm/mmu/mmu.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a8e14c2b68a7..fdae6d19e72b 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -3262,6 +3262,11 @@ static int kvm_handle_noslot_fault(struct kvm_vcpu *vcpu,
>   {
>   	gva_t gva = fault->is_tdp ? 0 : fault->addr;
>   
> +	if (fault->is_private) {
> +		kvm_mmu_prepare_memory_fault_exit(vcpu, fault);
> +		return -EFAULT;
> +	}
> +
>   	vcpu_cache_mmio_info(vcpu, gva, fault->gfn,
>   			     access & shadow_mmio_access_mask);
>   


