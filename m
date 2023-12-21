Return-Path: <kvm+bounces-4976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99E1B81AE6D
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 06:35:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC3F71C22D09
	for <lists+kvm@lfdr.de>; Thu, 21 Dec 2023 05:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C96156EF;
	Thu, 21 Dec 2023 05:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eHjepU3K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFE3156C3;
	Thu, 21 Dec 2023 05:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1703136900; x=1734672900;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PRYGXM6LLYdzhhppomGJKie9Wm42BTuE9Xp6KzFpHxg=;
  b=eHjepU3KqiMwQbIWefh/nMa7TFGkmSQHwYan5zYSFgBRJq2C+APrwSM2
   cWUYcEKEr401xpPJWiCZaQnj4rPInRSdebgPceUWdg07fo4IFAAy6JSnb
   1gR763JgSMZJJ5WtdAcviLkXHLIX82aygHScet7G/yYSbvOPwHD9WkRU8
   n0a4888gMgts03fjSPjz7I0vzlKZg5GTywKfX736706OryyLYRogk0WrL
   RucsDrvNHfu9u7/hNaprLB4UuzJ/SMnNuejUr+NVgtZzqIQgrk/va0hZj
   xo6a6VoN75aHBbFce0QN8kH4LfAIm/FeGvFwB4Prqg+Powa1rqU+upOVL
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="482104168"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="482104168"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 21:35:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10930"; a="899967454"
X-IronPort-AV: E=Sophos;i="6.04,293,1695711600"; 
   d="scan'208";a="899967454"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.93.12.199]) ([10.93.12.199])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2023 21:34:56 -0800
Message-ID: <59fd76e3-1849-419c-8570-9de38953e5f7@intel.com>
Date: Thu, 21 Dec 2023 13:34:53 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/4] KVM: x86: Make the APIC bus cycles per nsec VM
 variable
Content-Language: en-US
To: Isaku Yamahata <isaku.yamahata@intel.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Vishal Annapurve <vannapurve@google.com>, Jim Mattson <jmattson@google.com>,
 Maxim Levitsky <mlevitsk@redhat.com>
Cc: isaku.yamahata@gmail.com
References: <cover.1702974319.git.isaku.yamahata@intel.com>
 <d989708bacb78dc22deaf3f1520a876551eb97e7.1702974319.git.isaku.yamahata@intel.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <d989708bacb78dc22deaf3f1520a876551eb97e7.1702974319.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/19/2023 4:34 PM, Isaku Yamahata wrote:
> Introduce the VM variable of the APIC cycles per nano second as the
> preparation to make the APIC APIC bus frequency configurable.
> 
> The TDX architecture hard-codes the APIC bus frequency to 25MHz in the
> CPUID leaf 0x15. 

The intend from TDX architecture is not to hard code APIC bus frequency.
It is just a side effect of "TDX architecture uses CPUID leaf 0x15 to 
expose TSC frequency for TD guest and choose a hard-coded 25MHz (the 
same as the hardware that supports TDX) as the core crystal frequency"

SDM says "The APIC timer frequency will be the processor’s bus clock or 
core crystal clock frequency (when TSC/core crystal clock ratio is 
enumerated in CPUID leaf 0x15) divided by the value specified in the 
divide configuration register."

> The TDX mandates it to be exposed and doesn't allow the
> VMM to override its value.  The KVM APIC timer emulation hard-codes the
> frequency to 1GHz.  To ensure that the guest doesn't have a conflicting
> view of the APIC bus frequency, allow the userspace to tell KVM to use the
> same frequency that TDX mandates instead of the default 1Ghz.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
> Changes v3:
> - Update commit message.
> - Dropped apic_bus_frequency according to Maxim Levitsky.
> 
> Changes v2:
> - no change.
> ---
>   arch/x86/include/asm/kvm_host.h | 1 +
>   arch/x86/kvm/hyperv.c           | 3 ++-
>   arch/x86/kvm/lapic.c            | 6 ++++--
>   arch/x86/kvm/lapic.h            | 2 +-
>   arch/x86/kvm/x86.c              | 1 +
>   5 files changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index d7036982332e..45ee7a1d13f6 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1334,6 +1334,7 @@ struct kvm_arch {
>   
>   	u32 default_tsc_khz;
>   	bool user_set_tsc;
> +	u64 apic_bus_cycle_ns;
>   
>   	seqcount_raw_spinlock_t pvclock_sc;
>   	bool use_master_clock;
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index a40ca2fef58c..37ff31c18ad1 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1687,7 +1687,8 @@ static int kvm_hv_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata,
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
> index 245b20973cae..73956b0ac1f1 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1542,7 +1542,8 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
>   		remaining = 0;
>   
>   	ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
> -	return div64_u64(ns, (APIC_BUS_CYCLE_NS * apic->divide_count));
> +	return div64_u64(ns, (apic->vcpu->kvm->arch.apic_bus_cycle_ns *
> +			      apic->divide_count));
>   }
>   
>   static void __report_tpr_access(struct kvm_lapic *apic, bool write)
> @@ -1960,7 +1961,8 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
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
> index 1a3aaa7dafae..d7d865f7c847 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12466,6 +12466,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>   	raw_spin_unlock_irqrestore(&kvm->arch.tsc_write_lock, flags);
>   
>   	kvm->arch.default_tsc_khz = max_tsc_khz ? : tsc_khz;
> +	kvm->arch.apic_bus_cycle_ns = APIC_BUS_CYCLE_NS_DEFAULT;
>   	kvm->arch.guest_can_read_msr_platform_info = true;
>   	kvm->arch.enable_pmu = enable_pmu;
>   


