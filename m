Return-Path: <kvm+bounces-58358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3ED9B8F420
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 09:17:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 986153AE53B
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 07:17:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8942F361C;
	Mon, 22 Sep 2025 07:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JWi+FLuB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5F5A59;
	Mon, 22 Sep 2025 07:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758525448; cv=none; b=KEsigHOqftGV9U4+h3fJP6Zihl855ubdaavPzG5oGaJuelvqNFJoU+4ihdkbDiu5+OKY/3xNBi8pUFTw+GZ0eGZ6hV7/ZcjaGHto90R9I6p3wMna6fWmSR0hKoEzo17vIDZAsQrNphxIoCGiFDHX13jzkcPPUbMkbNb7WrSa3Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758525448; c=relaxed/simple;
	bh=xhJzjdVpCWCxnGVYZvRiniOhNKc51qLY1XcE0UQu0p4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jH4J2i9ImVEW8gjm6/xOyaVlqRKzjvbi+YRoWeJ4PEOtFNUCaNjqpMFJuj4m9oujfaTW23Rn51VuqatzjMVyv4w4qNMLssQ2rQn5x2DT04zXo14MYUWBDI0eoRm7vDgNjam3uOfeuUzHCFA6PmUu8PhbLkb6voRr2VdPEdGWd/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JWi+FLuB; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758525447; x=1790061447;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=xhJzjdVpCWCxnGVYZvRiniOhNKc51qLY1XcE0UQu0p4=;
  b=JWi+FLuBc+1RxCevYyGDHW/tdxAqdRC7yEA2lw0iU2/HY+uRpw4P4GFk
   s3SS6mb0NBFGCSOmSV4AAR9r+rH6mugMxvdll17dv4sBviV4UEl7dnh1x
   ukqWUwZytbv6Zjnarmj5fAuBLtssp5lHqgn2rbIddCNgDaNIZuJ0OWbeW
   CnAz63gbXwB5IgcPx4sPXWNbL1IrOtIGBB0HmIA36W0+xzHrwZN8BXg5E
   ngZG3yqKh/Me2keqZfndy3c4SErWtQ8sSUohClFp5sWvagKKJ1weg6KsM
   cvMJT1FsM88TnLuj4lNq/7PwebWswsAAW1lG8jmxchD5XHeWx9JXjghjE
   Q==;
X-CSE-ConnectionGUID: z8nIa8h1S/6qPCKcZ2ZVsw==
X-CSE-MsgGUID: fMgBImKqQ2ecqggf7Xew7Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11560"; a="60839460"
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="60839460"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:17:26 -0700
X-CSE-ConnectionGUID: InhUzUbfQrqYo6GzGHBWJQ==
X-CSE-MsgGUID: A3CsxddkSHW6jDv79s0sog==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,284,1751266800"; 
   d="scan'208";a="176845829"
Received: from unknown (HELO [10.238.0.107]) ([10.238.0.107])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 00:17:23 -0700
Message-ID: <8b91ca86-6301-4645-a9c2-c2de3a16327c@linux.intel.com>
Date: Mon, 22 Sep 2025 15:17:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v16 21/51] KVM: x86/mmu: WARN on attempt to check
 permissions for Shadow Stack #PF
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
 Zhang Yi Z <yi.z.zhang@linux.intel.com>, Xin Li <xin@zytor.com>
References: <20250919223258.1604852-1-seanjc@google.com>
 <20250919223258.1604852-22-seanjc@google.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20250919223258.1604852-22-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/20/2025 6:32 AM, Sean Christopherson wrote:
> Add PFERR_SS_MASK, a.k.a. Shadow Stack access, and WARN if KVM attempts to
> check permissions for a Shadow Stack access as KVM hasn't been taught to
> understand the magic Writable=0,Dirty=0 combination that is required for
> Shadow Stack accesses, and likely will never learn.  There are no plans to
> support Shadow Stacks with the Shadow MMU, and the emulator rejects all
> instructions that affect Shadow Stacks, i.e. it should be impossible for
> KVM to observe a #PF due to a shadow stack access.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/mmu.h              | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7a7e6356a8dd..554d83ff6135 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -267,6 +267,7 @@ enum x86_intercept_stage;
>   #define PFERR_RSVD_MASK		BIT(3)
>   #define PFERR_FETCH_MASK	BIT(4)
>   #define PFERR_PK_MASK		BIT(5)
> +#define PFERR_SS_MASK		BIT(6)
>   #define PFERR_SGX_MASK		BIT(15)
>   #define PFERR_GUEST_RMP_MASK	BIT_ULL(31)
>   #define PFERR_GUEST_FINAL_MASK	BIT_ULL(32)
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index b4b6860ab971..f63074048ec6 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -212,7 +212,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
>   
>   	fault = (mmu->permissions[index] >> pte_access) & 1;
>   
> -	WARN_ON(pfec & (PFERR_PK_MASK | PFERR_RSVD_MASK));
> +	WARN_ON_ONCE(pfec & (PFERR_PK_MASK | PFERR_SS_MASK | PFERR_RSVD_MASK));
>   	if (unlikely(mmu->pkru_mask)) {
>   		u32 pkru_bits, offset;
>   


