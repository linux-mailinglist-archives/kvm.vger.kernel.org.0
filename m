Return-Path: <kvm+bounces-39084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D2C6A43504
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 07:16:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16C14189FD3B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 06:15:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9412256C93;
	Tue, 25 Feb 2025 06:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T5b7b4hQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C9363207;
	Tue, 25 Feb 2025 06:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740464123; cv=none; b=WnQKLTsVZxCNLqtHr8yYZJh+ga3bPr0hMUJ36xzm5f14wSsjX48k6VZc0nHyksN0aNra8zo5mkpv6/U0HkbaX0RdC2PGtYjNYoGfF6754+S4xq0iqvWfc+ni9Ss1kteFSaCcdEf960qDm0wRoPRmNADt3az8PhajLJ5ojy6VvG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740464123; c=relaxed/simple;
	bh=I3qm5+CSklWRZcZj1DbMA18hIAMTOCxMuw2PspIntbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dCSQtBU3zHFCNMbdj0rSKlXKvQrPff7cdfmL/CIbpkm3JehBs0KDoVa03v7HahwjMV5o1bVprRBmDpVt3VHNGdnh3YyUVTHo6zXFKmgBOKaOk3lyo74XX5zK7UpLUIebNoJONpSZi0dF6V5KOEUXcTG+Ev98eK6XUD0++H9/7ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T5b7b4hQ; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740464120; x=1772000120;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=I3qm5+CSklWRZcZj1DbMA18hIAMTOCxMuw2PspIntbg=;
  b=T5b7b4hQ48olhetPg0OpznZ07HfurlWES2rqNfr+0RGJ0wATtb9uEQjJ
   BiNeweTukcyq7IvdkW3XNFBC1BRT/SY/1j9tOsFoBMzjo/J0QlQsEhdw5
   mjK3Vdk6yl/Z7MPlxUkT3QO81kRpGCKLYs+8XSYbb9fauTYux7U4sb0bH
   iOwj/D1lpFptRaRcbxlcVpydqKDxDTPXUoDkRJ0UM/VZxl51JElPKSW9a
   5Dl+yjsaqYVYN3X6v3aoIEIspe/JXpCSu4M0KyCT7WM6wuBchDLgKdi2N
   XPi6a5KnAxGS0b+2ejd9yG9HibB9q7R7mgS1UiC+1201CznBxA/aA68ma
   g==;
X-CSE-ConnectionGUID: tNM7gh2FTlyUh/Xy9bcBQA==
X-CSE-MsgGUID: v+8iw8KnS1WYp4vPILTdKA==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="44911793"
X-IronPort-AV: E=Sophos;i="6.13,313,1732608000"; 
   d="scan'208";a="44911793"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 22:15:20 -0800
X-CSE-ConnectionGUID: ADSFX5fQQGCqJJCwvC5HkA==
X-CSE-MsgGUID: vjCewvt0QCmZAIeTT1Bq4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="153482922"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 22:15:15 -0800
Message-ID: <d9924ccd-7322-48aa-93be-82620f72791c@intel.com>
Date: Tue, 25 Feb 2025 14:15:12 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 05/12] KVM: TDX: Implement TDX vcpu enter/exit path
To: Adrian Hunter <adrian.hunter@intel.com>, pbonzini@redhat.com,
 seanjc@google.com
Cc: kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, dmatlack@google.com, isaku.yamahata@intel.com,
 nik.borisov@suse.com, linux-kernel@vger.kernel.org, yan.y.zhao@intel.com,
 chao.gao@intel.com, weijiang.yang@intel.com
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-6-adrian.hunter@intel.com>
 <06c73413-d751-45bf-bde9-cdb4f56f95b0@intel.com>
 <632ea548-0e64-4a62-8126-120e42f4cd64@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <632ea548-0e64-4a62-8126-120e42f4cd64@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2/24/2025 8:27 PM, Adrian Hunter wrote:
> On 20/02/25 15:16, Xiaoyao Li wrote:
>> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>>> +#define TDX_REGS_UNSUPPORTED_SET    (BIT(VCPU_EXREG_RFLAGS) |    \
>>> +                     BIT(VCPU_EXREG_SEGMENTS))
>>> +
>>> +fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>> +{
>>> +    /*
>>> +     * force_immediate_exit requires vCPU entering for events injection with
>>> +     * an immediately exit followed. But The TDX module doesn't guarantee
>>> +     * entry, it's already possible for KVM to_think_ it completely entry
>>> +     * to the guest without actually having done so.
>>> +     * Since KVM never needs to force an immediate exit for TDX, and can't
>>> +     * do direct injection, just warn on force_immediate_exit.
>>> +     */
>>> +    WARN_ON_ONCE(force_immediate_exit);
>>> +
>>> +    trace_kvm_entry(vcpu, force_immediate_exit);
>>> +
>>> +    tdx_vcpu_enter_exit(vcpu);
>>> +
>>> +    vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
>>
>> I don't understand this. Why only clear RFLAGS and SEGMENTS?
>>
>> When creating the vcpu, vcpu->arch.regs_avail = ~0 in kvm_arch_vcpu_create().
>>
>> now it only clears RFLAGS and SEGMENTS for TDX vcpu, which leaves other bits set. But I don't see any code that syncs the guest value of into vcpu->arch.regs[reg].
> 
> TDX guest registers are generally not known but
> values are placed into vcpu->arch.regs when needed
> to work with common code.
> 
> We used to use ~VMX_REGS_LAZY_LOAD_SET and tdx_cache_reg()
> which has since been removed.
> 
> tdx_cache_reg() did not support RFLAGS, SEGMENTS,
> EXIT_INFO_1/EXIT_INFO_2 but EXIT_INFO_1/EXIT_INFO_2 became
> needed, so that just left RFLAGS, SEGMENTS.

Quote what Sean said [1]

   “I'm also not convinced letting KVM read garbage for RIP, RSP, CR3, or
   PDPTRs is at all reasonable.  CR3 and PDPTRs should be unreachable,
   and I gotta imagine the same holds true for RSP.  Allow reads/writes
   to RIP is fine, in that it probably simplifies the overall code.”

We need to justify why to let KVM read "garbage" of VCPU_REGS_RIP,
VCPU_EXREG_PDPTR, VCPU_EXREG_CR0, VCPU_EXREG_CR3, VCPU_EXREG_CR4,
VCPU_EXREG_EXIT_INFO_1, and VCPU_EXREG_EXIT_INFO_2 are neeed.

The changelog justify nothing for it.

btw, how EXIT_INFO_1/EXIT_INFO_2 became needed? It seems I cannot find 
any TDX code use them.

[1] https://lore.kernel.org/all/Z2GiQS_RmYeHU09L@google.com/

>>
>>> +    trace_kvm_exit(vcpu, KVM_ISA_VMX);
>>> +
>>> +    return EXIT_FASTPATH_NONE;
>>> +}
>>
> 


