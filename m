Return-Path: <kvm+bounces-15221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 651998AAC66
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 888231C21447
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 988CE7CF17;
	Fri, 19 Apr 2024 10:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EJsB1bHd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0504777F11;
	Fri, 19 Apr 2024 10:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713521074; cv=none; b=b2JTgLBkfGmKUJRhf98AtiLkSTZTI8vxgl7gNfl60NBN+Kq7ObQjqzNrsbTCiB/7yFUNlmlUh/uh82zQtD29voXsK41jPCGEqlV1cEcNVxnzi3AXkyX9gu6nRMXq5eGrWEiVXrGrK+WzaAmy2Ie5UsDGc7eSWXVZSFNYNZvRyVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713521074; c=relaxed/simple;
	bh=eIiUR8TFqcjvqCUcxqUDNIUpFeQj9tHx7Y5MGcAWS+M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r8Qs13oVPJi4o+TjsU2XmHhmQUQW2n5DfrSxQ36pAwqL1eT46CywzwL0x7K4C9erZUROdGM96RTAnsjlltbdn3SvrY2HZJ5tr97JUqqkVSnE9TcZc5PjX9eRWFG4dXfxylW/GFb6A9HbRCFvjw2J6isVxWqHDezlgmklLfrDmD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EJsB1bHd; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713521073; x=1745057073;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eIiUR8TFqcjvqCUcxqUDNIUpFeQj9tHx7Y5MGcAWS+M=;
  b=EJsB1bHdE6ELcJF+rri3h6Qcy3L3mrSLlaTVvwUliGwbR6qGaAK3w50T
   yE0dhb2wJZvx4lh88REVWBQXAjqfgl6dKsagaOYzpzPJ3aZqgfrnVvDMy
   w9gasPKzOpp18MzyHxkn4GRPoxTexdG4O/0BfKzG3vGfQJjGIxZ0GjVQA
   aOCYCCDpseI3UZ4Ylk3Olc00ydnEhxDw/ZD8MNO8w7r1FUnIerdMIIGUb
   UyEB9o4X15HhZAIvRj6o4V3Zd6gLu80qLsoQw5UDDafnYNws73JSUluoF
   Bx9xZNU5ctol6kbqnn344VNgm8mNfAcbR4B2aHVek8dzdOP04kPSH5CQ1
   g==;
X-CSE-ConnectionGUID: LDEd0kGuQUaC/f8XqGc3pw==
X-CSE-MsgGUID: GMkhx0m8QzuKjvx0yL+61Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="8951640"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="8951640"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 03:04:33 -0700
X-CSE-ConnectionGUID: jGPXyKDqQCKmdOMd5O7KMQ==
X-CSE-MsgGUID: Wy6ZEyoFTfOnz5B+o7Hd5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23152552"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.124.225.183]) ([10.124.225.183])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 03:04:13 -0700
Message-ID: <10b79413-f8ee-4e57-8346-0ac525254888@linux.intel.com>
Date: Fri, 19 Apr 2024 18:04:10 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 118/130] KVM: TDX: Add methods to ignore accesses to
 CPU state
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <9258b492295c0ef953f36b9fee60bf3a1873d71b.1708933498.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <9258b492295c0ef953f36b9fee60bf3a1873d71b.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 2/26/2024 4:27 PM, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
>
> TDX protects TDX guest state from VMM.  Implement access methods for TDX
> guest state to ignore them or return zero.  Because those methods can be
> called by kvm ioctls to set/get cpu registers, they don't have KVM_BUG_ON
> except one method.
>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/main.c    | 289 +++++++++++++++++++++++++++++++++----
>   arch/x86/kvm/vmx/tdx.c     |  48 +++++-
>   arch/x86/kvm/vmx/x86_ops.h |  13 ++
>   3 files changed, 321 insertions(+), 29 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
> index 84d2dc818cf7..9fb3f28d8259 100644
> --- a/arch/x86/kvm/vmx/main.c
> +++ b/arch/x86/kvm/vmx/main.c
> @@ -375,6 +375,200 @@ static void vt_vcpu_deliver_init(struct kvm_vcpu *vcpu)
>   	kvm_vcpu_deliver_init(vcpu);
>   }
>   
> +static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_vcpu_after_set_cpuid(vcpu);
> +}
> +
> +static void vt_update_exception_bitmap(struct kvm_vcpu *vcpu)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return;
> +
> +	vmx_update_exception_bitmap(vcpu);
> +}
> +
> +static u64 vt_get_segment_base(struct kvm_vcpu *vcpu, int seg)
> +{
> +	if (is_td_vcpu(vcpu))
> +		return tdx_get_segment_base(vcpu, seg);
Could just return 0?
Not need to add a function, since it's only called here and it's more 
straight forward to read the code without jump to the definition of 
these functions.

Similarly, we can use open code for tdx_get_cpl(), tdx_get_rflags() and 
tdx_get_segment(), which return 0 or memset with 0.


> +
> +	return vmx_get_segment_base(vcpu, seg);
> +}
> +
[...]
>   
> +int tdx_get_cpl(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +
[...]
> +
> +unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +
> +u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg)
> +{
> +	return 0;
> +}
> +
> +void tdx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
> +{
> +	memset(var, 0, sizeof(*var));
> +}
> +
>   static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
>   {
>   	struct kvm_tdx_capabilities __user *user_caps;
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 7c63b2b48125..727c4d418601 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -169,6 +169,12 @@ bool tdx_has_emulated_msr(u32 index, bool write);
>   int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
>   int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
>   
> +int tdx_get_cpl(struct kvm_vcpu *vcpu);
> +void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg);
> +unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu);
> +u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg);
> +void tdx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
> +
>   int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
>   
>   void tdx_flush_tlb(struct kvm_vcpu *vcpu);
> @@ -221,6 +227,13 @@ static inline bool tdx_has_emulated_msr(u32 index, bool write) { return false; }
>   static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
>   static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
>   
> +static inline int tdx_get_cpl(struct kvm_vcpu *vcpu) { return 0; }
> +static inline void tdx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg) {}
> +static inline unsigned long tdx_get_rflags(struct kvm_vcpu *vcpu) { return 0; }
> +static inline u64 tdx_get_segment_base(struct kvm_vcpu *vcpu, int seg) { return 0; }
> +static inline void tdx_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
> +				   int seg) {}
> +
>   static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
>   
>   static inline void tdx_flush_tlb(struct kvm_vcpu *vcpu) {}


