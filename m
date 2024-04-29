Return-Path: <kvm+bounces-16133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 103468B502D
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 06:23:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 34BBA1C2125D
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 04:23:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F39DCC129;
	Mon, 29 Apr 2024 04:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kNM3cAeL"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29298F6A;
	Mon, 29 Apr 2024 04:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714364623; cv=none; b=JG1z+kxhznA9QYroDKOkBHVQP7tgsMaLcqJ+2AvmDozCAiqlhG/YICa4aJZKrZ2tTSOWWCKV5sMhCimQp3r0n2EEN1QAz5xf7z+XW12reoOTGIncRERu5IR1iydSGJQO4K+0f5q4ZY+yuoYNoEj7dwdztSf67C4jNfNw64GV6qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714364623; c=relaxed/simple;
	bh=1IVjWFDE0ZPVxEX7QCLOdk64+2ARx2EGinwsO9xJAqY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uOD53jkvfZroWp+8uQzj8S48zGQ0i8CsOCk2clJax/3RTOBeLhUIkX59ghj3N54QunyimCnGcq68mt28/kKgN6+RDTA/sWvAyfWXghs4T1z4FcKwxcitOOse+zIwowtjuYQl+zslWUfR1AFQgqsCAvpm52x53h69fu+ibAWyEj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kNM3cAeL; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714364621; x=1745900621;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1IVjWFDE0ZPVxEX7QCLOdk64+2ARx2EGinwsO9xJAqY=;
  b=kNM3cAeLbRgpcIgxxZqB/VrrksKw3lHS3+WxmmmTaar1DnkuRovKghJu
   UFJ24L/SqMGwdovB2aR5VFHw9ReNZ6SzW0f+9P5b8EqZkd1wIZ9MFWHL7
   X9wJNh+H1tPhkFO2PGY5cBASv5lQgWKZ3NMX8gJxnAEfTjJ888GckuTYg
   tDTnLwWJefeX8i++tx4q5htpKJETGnCrSe2VW7+KxyErvg7sni91pO3H8
   c9z5anioUb6KHArd/Qhi3ipHs0uGHLla+RWiEPrsQU7tsvIIVxLL9Dtbb
   AK3lT6FTGU6CZjKjDd/vsYn4pXl9NCUdgVdt8WUP/N3NoTeSzd4w5g50/
   A==;
X-CSE-ConnectionGUID: L7DH/PiJS66Oj6LBUCRX0w==
X-CSE-MsgGUID: NruxqcKyTnyNeXdcM+Lslw==
X-IronPort-AV: E=McAfee;i="6600,9927,11057"; a="10134618"
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="10134618"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 21:23:40 -0700
X-CSE-ConnectionGUID: lTeYmOudT8mJd96kUL1tRA==
X-CSE-MsgGUID: kxGWAuvMTTmiz79jYMjsdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,238,1708416000"; 
   d="scan'208";a="56886981"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2024 21:23:36 -0700
Message-ID: <1398f18e-b490-4c2c-93f1-e210f7e74794@intel.com>
Date: Mon, 29 Apr 2024 12:23:33 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V5 2/4] KVM: x86: Make nsec per APIC bus cycle a VM
 variable
To: Reinette Chatre <reinette.chatre@intel.com>, isaku.yamahata@intel.com,
 pbonzini@redhat.com, erdemaktas@google.com, vkuznets@redhat.com,
 seanjc@google.com, vannapurve@google.com, jmattson@google.com,
 mlevitsk@redhat.com, chao.gao@intel.com, rick.p.edgecombe@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1714081725.git.reinette.chatre@intel.com>
 <ae75ce37c6c38bb4efd10a0a41932984c40b24ac.1714081726.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ae75ce37c6c38bb4efd10a0a41932984c40b24ac.1714081726.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 4/26/2024 6:07 AM, Reinette Chatre wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Introduce the VM variable "nanoseconds per APIC bus cycle" in
> preparation to make the APIC bus frequency configurable.
> 
> The TDX architecture hard-codes the core crystal clock frequency to
> 25MHz and mandates exposing it via CPUID leaf 0x15. The TDX architecture
> does not allow the VMM to override the value.
> 
> In addition, per Intel SDM:
>      "The APIC timer frequency will be the processor’s bus clock or core
>       crystal clock frequency (when TSC/core crystal clock ratio is
>       enumerated in CPUID leaf 0x15) divided by the value specified in
>       the divide configuration register."
> 
> The resulting 25MHz APIC bus frequency conflicts with the KVM hardcoded
> APIC bus frequency of 1GHz.
> 
> Introduce the VM variable "nanoseconds per APIC bus cycle" to prepare
> for allowing userspace to tell KVM to use the frequency that TDX mandates
> instead of the default 1Ghz. Doing so ensures that the guest doesn't have
> a conflicting view of the APIC bus frequency.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> [reinette: rework changelog]
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
> Changes v5:
> - Add Rick's Reviewed-by tag.
> 
> Changes v4:
> - Reword changelog to address comments related to "bus clock" vs
>    "core crystal clock" frequency. (Xiaoyao)
> - Typo in changelog ("APIC APIC" -> "APIC").
> - Change logic "APIC bus cycles per nsec" -> "nanoseconds per
>    APIC bus cycle".
> 
> Changes V3:
> - Update commit message.
> - Dropped apic_bus_frequency according to Maxim Levitsky.
> 
> Changes v2:
> - No change.
> 
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/hyperv.c           | 3 ++-
>   arch/x86/kvm/lapic.c            | 6 ++++--
>   arch/x86/kvm/lapic.h            | 2 +-
>   arch/x86/kvm/x86.c              | 1 +
>   5 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1d13e3cd1dc5..f2735582c7e0 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1358,6 +1358,7 @@ struct kvm_arch {
>   
>   	u32 default_tsc_khz;
>   	bool user_set_tsc;
> +	u64 apic_bus_cycle_ns;
>   
>   	seqcount_raw_spinlock_t pvclock_sc;
>   	bool use_master_clock;
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 1030701db967..5c31e715d2ad 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1737,7 +1737,8 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
>   		data = (u64)vcpu->arch.virtual_tsc_khz * 1000;
>   		break;
>   	case HV_X64_MSR_APIC_FREQUENCY:
> -		data = div64_u64(1000000000ULL, APIC_BUS_CYCLE_NS);
> +		data = div64_u64(1000000000ULL,
> +				 vcpu->kvm->arch.apic_bus_cycle_ns);
>   		break;
>   	default:
>   		kvm_pr_unimpl_rdmsr(vcpu, msr);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index cf37586f0466..3e66a0a95999 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1547,7 +1547,8 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
>   		remaining = 0;
>   
>   	ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
> -	return div64_u64(ns, (APIC_BUS_CYCLE_NS * apic->divide_count));
> +	return div64_u64(ns, (apic->vcpu->kvm->arch.apic_bus_cycle_ns *
> +			      apic->divide_count));
>   }
>   
>   static void __report_tpr_access(struct kvm_lapic *apic, bool write)
> @@ -1965,7 +1966,8 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
>   
>   static inline u64 tmict_to_ns(struct kvm_lapic *apic, u32 tmict)
>   {
> -	return (u64)tmict * APIC_BUS_CYCLE_NS * (u64)apic->divide_count;
> +	return (u64)tmict * apic->vcpu->kvm->arch.apic_bus_cycle_ns *
> +		(u64)apic->divide_count;
>   }
>   
>   static void update_target_expiration(struct kvm_lapic *apic, uint32_t old_divisor)
> diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
> index a20cb006b6c8..51e09f5a7fc5 100644
> --- a/arch/x86/kvm/lapic.h
> +++ b/arch/x86/kvm/lapic.h
> @@ -16,7 +16,7 @@
>   #define APIC_DEST_NOSHORT		0x0
>   #define APIC_DEST_MASK			0x800
>   
> -#define APIC_BUS_CYCLE_NS       1
> +#define APIC_BUS_CYCLE_NS_DEFAULT	1
>   
>   #define APIC_BROADCAST			0xFF
>   #define X2APIC_BROADCAST		0xFFFFFFFFul
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e9ef1fa4b90b..10e6315103f4 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12629,6 +12629,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>   
>   	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
> +	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
>   	kvm->arch.guest_can_read_msr_platform_info = true;
>   	kvm->arch.enable_pmu = enable_pmu;
>   


