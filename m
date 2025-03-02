Return-Path: <kvm+bounces-39817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69F4FA4B3B6
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 18:13:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57D77188A23B
	for <lists+kvm@lfdr.de>; Sun,  2 Mar 2025 17:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83CFE1EB5DD;
	Sun,  2 Mar 2025 17:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fHIOptCr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031511E9B04;
	Sun,  2 Mar 2025 17:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740935608; cv=none; b=s/M4GyhwWRSOo/3A2O4MOP71fKS/vpmotG0ibTvA9cJAV6TxiF3NqM5cujaoxNbfbxGlOBFP/oMGw4DAmPYulfr4QPL1i4kMRi7nWaC+BKKerXngfuumMzYWdRRnSF8UJqmqm2QcNGOzWpf7FvPmO3ECwEC/LZviRXdPqMgwfss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740935608; c=relaxed/simple;
	bh=hwmESsf+xGzrUKg+gX8cZEYQO8BzA0xc/8yTwlAlj7g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nugdJT1df4WWXx2/TbnAHmnpr1kvSugp2oaMJNwkHMrck/M2M7DaJlKJzSaOOfmyRqEKQGeHvsBOwLvFiObD2rljZwmDBKy0PVzIlcyycfVk9meo7vFG8CtkR85b+BfP8DO3BjcRvHkl4DlgIhCCTgEcXBJwv4Qds1qX8RUadgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fHIOptCr; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740935606; x=1772471606;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hwmESsf+xGzrUKg+gX8cZEYQO8BzA0xc/8yTwlAlj7g=;
  b=fHIOptCrLk8wM6Ci3Myjgv8XmlWB/Q4S3CiZtBjBLdQdbv/jT2CJSpAy
   J9APOeMvLOdpuQX3uPQJJOKhO5ppS84xfHH5ppZcvNXLfXdv7QQ01MNr/
   IEaG7Cj2Lq/eOftNliGeXyucLvTDWB4KGD1jYlCLqYXbRwezuEAsEMbyP
   3qHAGeFPa8fGSFZGaziVenLJDMYehvbCsVju6PAWKedAuiRezL6eeyeoI
   0dAF+oisjnViO3wM/UjI0qv4i0iD9w42mQH4jS+2N4qnnljR1mmHLb4F3
   wKWGWYXbAPybIsln4zxCP9CnFHcoYVfl2inlnmnwylVqdsMeQs49FkjX3
   A==;
X-CSE-ConnectionGUID: grWmnjpbRhq1RzmkXG5qdg==
X-CSE-MsgGUID: 1ZglHj5IT6ODMCQnFoPakA==
X-IronPort-AV: E=McAfee;i="6700,10204,11361"; a="59355019"
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="59355019"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 09:13:25 -0800
X-CSE-ConnectionGUID: KTbyoH6KQwaWcsZtKlrKGA==
X-CSE-MsgGUID: 7FsQC8dPRYOlqJH76sUQpw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,327,1732608000"; 
   d="scan'208";a="141022583"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.247.1]) ([10.124.247.1])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2025 09:13:23 -0800
Message-ID: <38fe9d44-a89f-44de-bc07-84aef82c469f@intel.com>
Date: Mon, 3 Mar 2025 01:13:20 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] KVM: x86: Introduce supported_quirks to block
 disabling quirks
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
Cc: seanjc@google.com, yan.y.zhao@intel.com
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-3-pbonzini@redhat.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20250301073428.2435768-3-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/2025 3:34 PM, Paolo Bonzini wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
> 
> Introduce supported_quirks in kvm_caps to store platform-specific force-enabled
> quirks.  Any quirk removed from kvm_caps.supported_quirks will never be
> included in kvm->arch.disabled_quirks, and will cause the ioctl to fail if
> passed to KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2).
> 
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/x86.c | 7 ++++---
>   arch/x86/kvm/x86.h | 2 ++
>   2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index fd0a44e59314..a97e58916b6a 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4782,7 +4782,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>   		r = enable_pmu ? KVM_CAP_PMU_VALID_MASK : 0;
>   		break;
>   	case KVM_CAP_DISABLE_QUIRKS2:
> -		r = KVM_X86_VALID_QUIRKS;
> +		r = kvm_caps.supported_quirks;
>   		break;
>   	case KVM_CAP_X86_NOTIFY_VMEXIT:
>   		r = kvm_caps.has_notify_vmexit;
> @@ -6521,11 +6521,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>   	switch (cap->cap) {
>   	case KVM_CAP_DISABLE_QUIRKS2:
>   		r = -EINVAL;
> -		if (cap->args[0] & ~KVM_X86_VALID_QUIRKS)
> +		if (cap->args[0] & ~kvm_caps.supported_quirks)
>   			break;
>   		fallthrough;
>   	case KVM_CAP_DISABLE_QUIRKS:
> -		kvm->arch.disabled_quirks = cap->args[0];
> +		kvm->arch.disabled_quirks = cap->args[0] & kvm_caps.supported_quirks;

Don't need this. It's redundant with the above, which ensures
cap->args[0] is the subset of kvm_caps.supported_quirks

Otherwise,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>   		r = 0;
>   		break;
>   	case KVM_CAP_SPLIT_IRQCHIP: {
> @@ -9775,6 +9775,7 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
>   		kvm_host.xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>   		kvm_caps.supported_xcr0 = kvm_host.xcr0 & KVM_SUPPORTED_XCR0;
>   	}
> +	kvm_caps.supported_quirks = KVM_X86_VALID_QUIRKS;
>   	kvm_caps.inapplicable_quirks = 0;
>   
>   	rdmsrl_safe(MSR_EFER, &kvm_host.efer);
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 9af199c8e5c8..f2672b14388c 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -34,6 +34,8 @@ struct kvm_caps {
>   	u64 supported_xcr0;
>   	u64 supported_xss;
>   	u64 supported_perf_cap;
> +
> +	u64 supported_quirks;
>   	u64 inapplicable_quirks;
>   };
>   


