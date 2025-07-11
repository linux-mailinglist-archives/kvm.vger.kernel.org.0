Return-Path: <kvm+bounces-52165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1A6B01E05
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 15:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E33F3AD7DB
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 13:41:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 116792DCF67;
	Fri, 11 Jul 2025 13:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KrExhKKa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CB12D23A8;
	Fri, 11 Jul 2025 13:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752241243; cv=none; b=AjW6qRMAVy/6IqntZ0pFZs053JkzJbA57OeSZ+NL4RRQb8RjXjIg+V04I8UUTDJHwp46PPTJSS400oYl4kB3S+uRH0ysa1TP8G8m4ZaTZ2aFuO7lYdti+QBg1c6qgXkefoV6ee/HP5nIwT1+fxV2mjI6BIRZo1XQXIu/WXR/KzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752241243; c=relaxed/simple;
	bh=EBt9gGW1TAOYC9qx6L/o8/rbeB4z1Wz05fhzW4EdrBM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qEt5UXMrPf6ZCF4t4EtML9NtVcBUskxgphe7SaTA16k3ureT6bN6ciogBv3yfoXuzO6bSwA+en5QeKS3WUKq8rfJ493rdqMN5NlGb6f3oRVOWzknA/2iK3YD9orY5K0wJcbPSwRoM+wit40LO+mZt3Q/JDbvDfsIScsIpEI3v6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KrExhKKa; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752241242; x=1783777242;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=EBt9gGW1TAOYC9qx6L/o8/rbeB4z1Wz05fhzW4EdrBM=;
  b=KrExhKKa7xHN+lhTATRdDH5oF3alucgPTUSoVPYeDCABTMhEsY86Ywsc
   F5oaWIpdK5pXOYUW7E4rd/+mQXjD/VVA17rHv4Yy3sh/dA0wfhUIjxEbu
   d0trJIS+vkL8Tr3gHpuZQDaFx88ZtiB+X9D2K+s8832754ZNOFIHUpcx3
   q3DyvRe/gSOzF1ufzHZr70aPGwb0lBopTAlcGMnkPz2PwBJJSPrHVzmBI
   ymlIx0M+nOZVuqv3pnkPIz47BdZijwEFX8+hyRYrN+GUiMwXx7c5S6imD
   FS97WUZuXTZWmRugA1mfKLupCflviGOyRVEae3l0xKqaj7Ul7oSC2qDql
   A==;
X-CSE-ConnectionGUID: 1XEH+H8GTbyFGOBc5dZGZg==
X-CSE-MsgGUID: zc7xtv6MSZODzZ3LP5Ubkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54476939"
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="54476939"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 06:40:41 -0700
X-CSE-ConnectionGUID: /BPaOl2BRyKfPAOcE4Ov4w==
X-CSE-MsgGUID: 7yPTvQdtRaeGVbVl6EVhKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,303,1744095600"; 
   d="scan'208";a="180067842"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 06:40:36 -0700
Message-ID: <3989f123-6888-459b-bb65-4571f5cad8ce@intel.com>
Date: Fri, 11 Jul 2025 21:40:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V4 0/1] KVM: TDX: Decrease TDX VM shutdown time
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, Adrian Hunter <adrian.hunter@intel.com>,
 kvm@vger.kernel.org, rick.p.edgecombe@intel.com,
 kirill.shutemov@linux.intel.com, kai.huang@intel.com,
 reinette.chatre@intel.com, tony.lindgren@linux.intel.com,
 binbin.wu@linux.intel.com, isaku.yamahata@intel.com,
 linux-kernel@vger.kernel.org, yan.y.zhao@intel.com, chao.gao@intel.com
References: <20250611095158.19398-1-adrian.hunter@intel.com>
 <175088949072.720373.4112758062004721516.b4-ty@google.com>
 <aF1uNonhK1rQ8ViZ@google.com>
 <7103b312-b02d-440e-9fa6-ba219a510c2d@intel.com>
 <aHEMBuVieGioMVaT@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <aHEMBuVieGioMVaT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/11/2025 9:05 PM, Sean Christopherson wrote:
> On Fri, Jul 11, 2025, Xiaoyao Li wrote:
>> On 6/26/2025 11:58 PM, Sean Christopherson wrote:
>>> On Wed, Jun 25, 2025, Sean Christopherson wrote:
>>>> On Wed, 11 Jun 2025 12:51:57 +0300, Adrian Hunter wrote:
>>>>> Changes in V4:
>>>>>
>>>>> 	Drop TDX_FLUSHVP_NOT_DONE change.  It will be done separately.
>>>>> 	Use KVM_BUG_ON() instead of WARN_ON().
>>>>> 	Correct kvm_trylock_all_vcpus() return value.
>>>>>
>>>>> Changes in V3:
>>>>> 	Refer:
>>>>>               https://lore.kernel.org/r/aAL4dT1pWG5dDDeo@google.com
>>>>>
>>>>> [...]
>>>>
>>>> Applied to kvm-x86 vmx, thanks!
>>>>
>>>> [1/1] KVM: TDX: Add sub-ioctl KVM_TDX_TERMINATE_VM
>>>>         https://github.com/kvm-x86/linux/commit/111a7311a016
>>>
>>> Fixed up to address a docs goof[*], new hash:
>>>
>>>         https://github.com/kvm-x86/linux/commit/e4775f57ad51
>>>
>>> [*] https://lore.kernel.org/all/20250626171004.7a1a024b@canb.auug.org.au
>>
>> Hi Sean,
>>
>> I think it's targeted for v6.17, right?
>>
>> If so, do we need the enumeration for the new TDX ioctl? Yes, the userspace
>> could always try and ignore the failure. But since the ship has not sailed,
>> I would like to report it and hear your opinion.
> 
> Bugger, you're right.  It's sitting at the top of 'kvm-x86 vmx', so it should be
> easy enough to tack on a capability.
> 
> This?

I'm wondering if we need a TDX centralized enumeration interface, e.g., 
new field in struct kvm_tdx_capabilities. I believe there will be more 
and more TDX new features, and assigning each a KVM_CAP seems wasteful.

> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index f0d961436d0f..dcb879897cab 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -9147,6 +9147,13 @@ KVM exits with the register state of either the L1 or L2 guest
>   depending on which executed at the time of an exit. Userspace must
>   take care to differentiate between these cases.
>   
> +8.46 KVM_CAP_TDX_TERMINATE_VM
> +-----------------------------
> +
> +:Architectures: x86
> +
> +This capability indicates that KVM supports the KVM_TDX_TERMINATE_VM sub-ioctl.
> +
>   9. Known KVM API problems
>   =========================
>   
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b58a74c1722d..e437a50429d3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4823,6 +4823,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>          case KVM_CAP_READONLY_MEM:
>                  r = kvm ? kvm_arch_has_readonly_mem(kvm) : 1;
>                  break;
> +       case KVM_CAP_TDX_TERMINATE_VM:
> +               r = !!(kvm_caps.supported_vm_types & BIT(KVM_X86_TDX_VM));
> +               break;
>          default:
>                  break;
>          }
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 7a4c35ff03fe..54293df4a342 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -960,6 +960,7 @@ struct kvm_enable_cap {
>   #define KVM_CAP_ARM_EL2 240
>   #define KVM_CAP_ARM_EL2_E2H0 241
>   #define KVM_CAP_RISCV_MP_STATE_RESET 242
> +#define KVM_CAP_TDX_TERMINATE_VM 243
>   
>   struct kvm_irq_routing_irqchip {
>          __u32 irqchip;


