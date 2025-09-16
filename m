Return-Path: <kvm+bounces-57672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88B35B58E21
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 07:52:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3EC84487DA8
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 05:52:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BC6C2DE714;
	Tue, 16 Sep 2025 05:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QMdHxslb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65391E9B12;
	Tue, 16 Sep 2025 05:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758001964; cv=none; b=rkzeZuaiF781fUYpKvXE6MoiVecirrf3yEn4dMQmG6G9T5PxLWNkXr7taG/flr1tRihEmqj1eYftnb0STgNjPHe+u40ANGqG4M9qzhqK92xUBFbH4irfGtIUJdE1gH5kSFcPQhZQT0b7pQCk/x9o3Jdtt1ZAlmrouBCHRAzFJ9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758001964; c=relaxed/simple;
	bh=H/YPUdnUnEI/UdRxVPLVDcuWuPFJCqxFolqeBXJ/mgM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QZjSbs98vkonnTVmkEyyK0w6+JD5Ozivw2NPBf1cRTqBSXTxyPSKIHlp+ByO8kMKjl4Mmj2+3E0/4NStBRGjGNoVfG6fKu1cp8+zFSINWAZAGlcUrkI/UP1RyfCIUnFXoh5qUYio60qyExu5hZuifB5Dr25Ws5ezRC1vatEVgdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QMdHxslb; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758001963; x=1789537963;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=H/YPUdnUnEI/UdRxVPLVDcuWuPFJCqxFolqeBXJ/mgM=;
  b=QMdHxslbeW2JWsCUog5u0+UIHLef3t7Lj2CaLWYmo0Y9kPiTl2VCfb2W
   Ci8LdtvONmO6fbKC+aFNkWjeax2DyLzRODt5kfghZS/L3GIZpD2fUmWa1
   FdGH6w6pFAs1WUBDO+6kM4ZXzW2N8MODABbuN+zJJqB/IwoX5+6rYZvQq
   krX9EaZskjxQhYcNICkaiuiYI8nNqWUL+9cgRHv/8+eKb9km6iRBssgax
   vAGXI0XyfLQpkFaIKSI+KQm1xMrj8H+UGwtcdHpm6KkF+wUMfJocy1cNM
   221FZyeKbfZfPB3qL3Ymo19+kLoBKCaJHmEtbINl8kdObeXx6OH5s+na3
   w==;
X-CSE-ConnectionGUID: RmIphdViRwysmR2581ctKA==
X-CSE-MsgGUID: RIu9NhNXRO6RmCEfVfMuLQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11554"; a="82866294"
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="82866294"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 22:52:42 -0700
X-CSE-ConnectionGUID: d905ExmrSaew3FdMmXNsnw==
X-CSE-MsgGUID: XtBJ7krpT1G97wGjsmhK9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,268,1751266800"; 
   d="scan'208";a="174776240"
Received: from junlongf-mobl.ccr.corp.intel.com (HELO [10.238.1.52]) ([10.238.1.52])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 22:52:38 -0700
Message-ID: <d1bfb652-19ff-434f-bd51-b990543d14d6@intel.com>
Date: Tue, 16 Sep 2025 13:52:36 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 13/41] KVM: x86: Enable guest SSP read/write interface
 with new uAPIs
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-14-seanjc@google.com>
 <aca9d389-f11e-4811-90cf-d98e345a5cc2@intel.com>
 <aMiPTEu_WfmEZiqT@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aMiPTEu_WfmEZiqT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/16/2025 6:12 AM, Sean Christopherson wrote:
> On Mon, Sep 15, 2025, Xiaoyao Li wrote:
>> On 9/13/2025 7:22 AM, Sean Christopherson wrote:
>>> @@ -6097,11 +6105,22 @@ static int kvm_get_set_one_reg(struct kvm_vcpu *vcpu, unsigned int ioctl,
>>>    static int kvm_get_reg_list(struct kvm_vcpu *vcpu,
>>>    			    struct kvm_reg_list __user *user_list)
>>>    {
>>> -	u64 nr_regs = 0;
>>> +	u64 nr_regs = guest_cpu_cap_has(vcpu, X86_FEATURE_SHSTK) ? 1 : 0;
>>
>> I wonder what's the semantic of KVM returning KVM_REG_GUEST_SSP on
>> KVM_GET_REG_LIST. Does it ensure KVM_{G,S}ET_ONE_REG returns -EINVAL on
>> KVM_REG_GUEST_SSP when it's not enumerated by KVM_GET_REG_LIST?
>>
>> If so, but KVM_{G,S}ET_ONE_REG can succeed on GUEST_SSP even if
>> !guest_cpu_cap_has() when @ignore_msrs is true.
> 
> Ugh, great catch.  Too many knobs.  The best idea I've got it to to exempt KVM-
> internal MSRs from ignore_msrs and report_ignored_msrs on host-initiated writes.
> That's unfortunately still a userspace visible change, and would continue to be
> userspace-visible, e.g. if we wanted to change the magic value for
> MSR_KVM_INTERNAL_GUEST_SSP.
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c78acab2ff3f..6a50261d1c5c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -511,6 +511,11 @@ static bool kvm_is_advertised_msr(u32 msr_index)
>          return false;
>   }
>   
> +static bool kvm_is_internal_msr(u32 msr)
> +{
> +       return msr == MSR_KVM_INTERNAL_GUEST_SSP;
> +}
> +
>   typedef int (*msr_access_t)(struct kvm_vcpu *vcpu, u32 index, u64 *data,
>                              bool host_initiated);
>   
> @@ -544,6 +549,9 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
>          if (host_initiated && !*data && kvm_is_advertised_msr(msr))
>                  return 0;
>   
> +       if (host_initiated && kvm_is_internal_msr(msr))
> +               return ret;
> +
>          if (!ignore_msrs) {
>                  kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
>                                        op, msr, *data);
> 
> Alternatively, simply exempt host writes from ignore_msrs.  Aha!  And KVM even
> documents that as the behavior:
> 
> 	kvm.ignore_msrs=[KVM] Ignore guest accesses to unhandled MSRs.
> 			Default is 0 (don't ignore, but inject #GP)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c78acab2ff3f..177253e75b41 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -544,7 +544,7 @@ static __always_inline int kvm_do_msr_access(struct kvm_vcpu *vcpu, u32 msr,
>          if (host_initiated && !*data && kvm_is_advertised_msr(msr))
>                  return 0;
>   
> -       if (!ignore_msrs) {
> +       if (host_initiated || !ignore_msrs) {
>                  kvm_debug_ratelimited("unhandled %s: 0x%x data 0x%llx\n",
>                                        op, msr, *data);
>                  return ret;
> 
> So while it's technically an ABI change (arguable since it's guarded by an
> off-by-default param), I suspect we can get away with it.  Hmm, commit 6abe9c1386e5
> ("KVM: X86: Move ignore_msrs handling upper the stack") exempted KVM-internal
> MSR accesses from ignore_msrs, but doesn't provide much in the way of justification
> for _why_ that's desirable.
> 
> Argh, and that same mini-series extended the behavior to feature MSRs, again
> without seeming to consider whether or not it's actually desirable to suppress
> bad VMM accesses.  Even worse, that decision likely generated an absurd amount
> of churn and noise due to splattering helpers and variants all over the place. :-(
> 
> commit 12bc2132b15e0a969b3f455d90a5f215ef239eff
> Author:     Peter Xu <peterx@redhat.com>
> AuthorDate: Mon Jun 22 18:04:42 2020 -0400
> Commit:     Paolo Bonzini <pbonzini@redhat.com>
> CommitDate: Wed Jul 8 16:21:40 2020 -0400
> 
>      KVM: X86: Do the same ignore_msrs check for feature msrs
>      
>      Logically the ignore_msrs and report_ignored_msrs should also apply to feature
>      MSRs.  Add them in.
> 
> For 6.18, I think the safe play is to go with the first path (exempt KVM-internal
> MSRs), and then try to go for the second approach (exempt all host accesses) for
> 6.19.  KVM's ABI for ignore_msrs=true is already all kinds of messed up, so I'm
> not terribly concerned about temporarily making it marginally worse.

Looks OK to me.

