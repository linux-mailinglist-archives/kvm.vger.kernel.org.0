Return-Path: <kvm+bounces-39815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2BAA4B3A6
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 18:04:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB5BA1891B7D
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 17:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB4CF1EB1AA;
	Sun,  2 Mar 2025 17:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VAih4qmY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339A13594F;
	Sun,  2 Mar 2025 17:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740935050; cv=none; b=PQkeJEQLCfRpmhgVqfjPFihYcB52FFR/SryTBXXUOtYDo9pokiU0bvjM0UY4ycpJN2Xd15W8Ergmh8xV1BuX9OUsp108LAB6pTN2/49LoKkeofGvNWLZEHwKEo8LxarqFXkIrisPgIe69412Z1za2fkOjVIfay9SDCtrP20jm+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740935050; c=relaxed/simple;
	bh=J9WBrmbAU7OZTDteavgUdtEXlaP4WWdhY19sHgVOTlk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VnW8MSG96u36/mVJaDuyxNEVnnlpwdLAxyy22Th6Ju/Xoi3M6LDjnVYkkbvi1QgXEJ1zKSvP5yE0qZO8URLThUOi8j1G7kxfoOr726gEhQbWTEVK8U3f+eCKe3fErQsatWchz11+oif9mtzTpVqH0n2LtfINCLRPWmat47oCT20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VAih4qmY; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740935050; x=1772471050;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=J9WBrmbAU7OZTDteavgUdtEXlaP4WWdhY19sHgVOTlk=;
  b=VAih4qmYRbz8aWevqobU94g2ArhUGQQ5MX8/BosT8CBTLJqutagsbg1o
   +Q9O33PBBj2CVgHNMZpNtz6bS9qUq27yZAIC0/9bdFwS0krAVb0FZVrta
   WSrke+d+/KqGsUOf/b0nkR69/fTNYda8diuoOARg6Bk1gFcbVMfHIok4F
   fKpkNTZgFnbd/s0KQQ9ToLaXp0s2X6A+Sx6ahBQuEq3kRaG9YpZAu2FAs
   DV2G5MFCUZ3IKvkXVrBuxRl6CZ9ILeXqd0qwuPvroPLP7wwyQpuI1dt2d
   yzVuiyRnsRC2hmZAATSawpWZamjz+m3FwuGMR9FF6ISKMMXyxor/tTow9
   A==;
X-CSE-ConnectionGUID: M2wA+ZceTJC2M+v8G2w/Ww==
X-CSE-MsgGUID: g9fzfQaDTvatsFS7ONYDiA==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="41840151"
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="41840151"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 09:04:09 -0800
X-CSE-ConnectionGUID: g8BnP3FxTqCP/X5Onneb9g==
X-CSE-MsgGUID: DtrXSek3Q0WDsht5gUoWwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="117821264"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 09:04:07 -0800
Message-ID: <338901b6-4d10-480d-bd0a-0db8ec4afad5@intel.com>
Date: Mon, 3 Mar 2025 01:03:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] KVM: TDX: Always honor guest PAT on TDX enabled
 platforms
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, yan.y.zhao@intel.com
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-5-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250301073428.2435768-5-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/2025 3:34 PM, Paolo Bonzini wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Always honor guest PAT in KVM-managed EPTs on TDX enabled platforms by
> making self-snoop feature a hard dependency for TDX and making quirk
> KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT not a valid quirk once TDX is enabled.
> 
> The quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT only affects memory type of
> KVM-managed EPTs. For the TDX-module-managed private EPT, memory type is
> always forced to WB now.
> 
> Honoring guest PAT in KVM-managed EPTs ensures KVM does not invoke
> kvm_zap_gfn_range() when attaching/detaching non-coherent DMA devices;
> this would cause mirrored EPTs for TDs to be zapped, as well as incorrect
> zapping of the private EPT that is managed by the TDX module.
> 
> As a new platform, TDX always comes with self-snoop feature supported and has
> no worry to break old not-well-written yet unmodifiable guests. So, simply
> force-disable the KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT quirk for TDX VMs.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Message-ID: <20250224071039.31511-1-yan.y.zhao@intel.com>
> [Use disabled_quirks instead of supported_quirks. - Paolo]
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index b6f6f6e2f02e..4450fd99cb4c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -624,6 +624,7 @@ int tdx_vm_init(struct kvm *kvm)
>   
>   	kvm->arch.has_protected_state = true;
>   	kvm->arch.has_private_mem = true;
> +	kvm->arch.disabled_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;

This doesn't present userspace from dropping the 
KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT bit by updating
kvm->arch.disabled_quirk via KVM_CAP_DISABLE_QUIRKS.

I think we can make inapplicable_quirks per VM in Patch 1 and set

     kvm->arch.inapplicable_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;

for TDX VMs.

>   
>   	/*
>   	 * Because guest TD is protected, VMM can't parse the instruction in TD.
> @@ -3470,6 +3471,11 @@ int __init tdx_bringup(void)
>   		goto success_disable_tdx;
>   	}
>   
> +	if (!cpu_feature_enabled(X86_FEATURE_SELFSNOOP)) {
> +		pr_err("Self-snoop is required for TDX\n");
> +		goto success_disable_tdx;
> +	}
> +
>   	if (!cpu_feature_enabled(X86_FEATURE_TDX_HOST_PLATFORM)) {
>   		pr_err("tdx: no TDX private KeyIDs available\n");
>   		goto success_disable_tdx;


