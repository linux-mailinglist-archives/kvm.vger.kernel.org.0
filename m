Return-Path: <kvm+bounces-64609-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CB3BC88313
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 06:57:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E9E80352921
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 05:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3B3315D40;
	Wed, 26 Nov 2025 05:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MfmWcR5x"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FB3F30DEB0;
	Wed, 26 Nov 2025 05:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764136630; cv=none; b=X81SW9RqWxwU9XuG7ETcO3C5p6JBMCASs80K91fWtAT6p1cZfTWy33Jp42EYq/pYT+v8A2c88jyJWlHJ5QShknm5zdxzMsTj43247PmPqQ0Z+xa3DDnVFrO38PHzTDswtfMETbqpJvt2qx2sgpZhptqpKl0hT7jOf36MSKrgXqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764136630; c=relaxed/simple;
	bh=OTho8qU9BnrmvKsPVD0CjGlxrwouddko8CkHyyFCX0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vEGq/gP09hcrziQPgS21SRF/LENu2wrHq3vVxtpsrZOQH6YL9uT9mG98O+mQy0zATUPE/JDMOrziqtDfWkBDLWf2knnlCTHB+NFHr7rUZl7tWs61RStUHAQhxWJPTbqWOFwysQ/u+PNjYQbtsFZUFcuXiUG5qEkJOFCXugY9LF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MfmWcR5x; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764136628; x=1795672628;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OTho8qU9BnrmvKsPVD0CjGlxrwouddko8CkHyyFCX0E=;
  b=MfmWcR5xcRSAa5rSRgb56MVrCr6KBio5ZS0MWUMuo8sPHsRQTVDOChDj
   ZBbC6LZ7vyHE1aceN8th2nlAscbZotqV+AUV+nSCYttec7Zts7OUQRDgd
   p/Kk8S44qwSEEnwGN4LnlgRfLy4neY6QYEQ790kCduNJjp2sJ1kB7WXDl
   aNi1iC9nvC8yFgQP7FDUic4jWocmwK/A1AxyE0U3RrhZjHZPsRwvvvaad
   7lTNwwgygnUK7yv2h0ztWtaXPiUaG0PNA6/slIs3yImSg1aY0aA1lU25V
   9d7ni6LlF2dbt90auVzX+bYV3kcQeljF7vz0DmWOwgOFg2eh6M5bEjeCT
   w==;
X-CSE-ConnectionGUID: Ve+gy9OpRR2s4rhtf1LKgw==
X-CSE-MsgGUID: z1VapiLFRRaglemiciyTnw==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="77531157"
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="77531157"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 21:57:05 -0800
X-CSE-ConnectionGUID: gOmtEBbFQkeeWX6QiWeAIw==
X-CSE-MsgGUID: rsdwU4YdSpumb6k26X48/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,227,1758610800"; 
   d="scan'208";a="223550488"
Received: from yinghaoj-desk.ccr.corp.intel.com (HELO [10.238.1.225]) ([10.238.1.225])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 21:57:00 -0800
Message-ID: <8d5c0f57-bf91-4ea3-bd7e-5a02bcb5cc09@linux.intel.com>
Date: Wed, 26 Nov 2025 13:56:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 13/16] KVM: TDX: Handle PAMT allocation in fault path
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: bp@alien8.de, chao.gao@intel.com, dave.hansen@intel.com,
 isaku.yamahata@intel.com, kai.huang@intel.com, kas@kernel.org,
 kvm@vger.kernel.org, linux-coco@lists.linux.dev,
 linux-kernel@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com,
 seanjc@google.com, tglx@linutronix.de, vannapurve@google.com,
 x86@kernel.org, yan.y.zhao@intel.com, xiaoyao.li@intel.com,
 binbin.wu@intel.com
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
 <20251121005125.417831-14-rick.p.edgecombe@intel.com>
Content-Language: en-US
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <20251121005125.417831-14-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/21/2025 8:51 AM, Rick Edgecombe wrote:
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
>
> Install PAMT pages for TDX call backs called during the fault path.
>
> There are two distinct cases when the kernel needs to allocate PAMT memory
> in the fault path: for SEPT page tables in tdx_sept_link_private_spt() and
> for leaf pages in tdx_sept_set_private_spte().
>
> These code paths run in atomic context. Previous changes have made the
> fault path top up the per-VCPU pool for memory allocations. Use it to do
> tdx_pamt_get/put() for the fault path operations.
>
> In the generic MMU these ops are inside functions that don’t always
> operate from the vCPU contexts (for example zap paths), which means they
> don’t have a struct kvm_vcpu handy. But for TDX they are always in a vCPU
> context. Since the pool of pre-allocated pages is on the vCPU, use
> kvm_get_running_vcpu() to get the vCPU. In case a new path appears where
> this is not the  case, leave some KVM_BUG_ON()’s.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> [Add feedback, update log]
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
> v4:
>   - Do prealloc.page_list initialization in tdx_td_vcpu_init() in case
>     userspace doesn't call KVM_TDX_INIT_VCPU.
>
> v3:
>   - Use new pre-allocation method
>   - Updated log
>   - Some extra safety around kvm_get_running_vcpu()
> ---
>   arch/x86/kvm/vmx/tdx.c | 44 ++++++++++++++++++++++++++++++++++++------
>   1 file changed, 38 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 61a058a8f159..24322263ac27 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -683,6 +683,8 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
>   	if (!irqchip_split(vcpu->kvm))
>   		return -EINVAL;
>   
> +	INIT_LIST_HEAD(&tdx->prealloc.page_list);
> +

Should this change be moved to patch 12?
Because the pre-alloc page list has started to be used in patch 12 for external
page tables even without enabling dynamic PAMT.

>   	fpstate_set_confidential(&vcpu->arch.guest_fpu);
>   	vcpu->arch.apic->guest_apic_protected = true;
>   	INIT_LIST_HEAD(&tdx->vt.pi_wakeup_list);
>
[...]

