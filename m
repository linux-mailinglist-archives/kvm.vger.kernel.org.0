Return-Path: <kvm+bounces-11624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 944EB878D1D
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 03:45:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51282282C15
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:45:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDC88BF3;
	Tue, 12 Mar 2024 02:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KipOmKom"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B909F79C0;
	Tue, 12 Mar 2024 02:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710211505; cv=none; b=h78QUDTPEK3pVVC7TCwq1tVTXWlMpKTpWr1Ol9TTG98eu4dcNL5FmaxdPnro9XcfphIYd0BgytiE8rzaGjkMxRaEww/o7XtiLmjAhpfkHmyHGriAWfgGsZatrAdoRb3OQRsdFR+A3mniYUoyaHcmzra6F9ecV3vJf4wa0sn7WFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710211505; c=relaxed/simple;
	bh=0dvdXXyJ1ESxem/rFpA82FAbmKBH4mm6+/qvqOws/sA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VCkbo1AE2zsUI1zT7g09pcK1M/qvk6s2eny8gzeFSNwz/QcBPsT4Cfb4ssXcCxJqYtZHtU32NpXeMtL1Frja/e14SX/uZVtZg31xa4ra2POWu1Hj9PVuV/7JobblBrS5IEdTZRRLIH1IbHXtpDCBsLBpj1AS8xv7xM5jL24bkf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KipOmKom; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710211504; x=1741747504;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0dvdXXyJ1ESxem/rFpA82FAbmKBH4mm6+/qvqOws/sA=;
  b=KipOmKomAq3ANsYJDJtgpgtIRidJRuvNU8YL9y3lBwEvSAmM+q72uRNx
   RVKyXvQqH/OhEqcYxC/7vVUKBioaJZXOJ4cU4QGibuhITQCo8X71e9vB1
   DRpaNRNXrU+kDWTFBGzD4w4CIJ3xXi79PTWH8yhS04FsRal4qy8dLvH6y
   RfxecAWnoFoVVdHoQz579x3sEBlH7p/aOMxq4w2b9WO2BhwSneQSIzWzI
   Ln5qoOzCIBUMEHCV6N1BpEwa/q364tjNSEQPt0+1aOsBQIy6z70Iv46+/
   aDjMVDQHE7wfagNm4o8YpC5NIg5k+MG1JY+3hnR/p2pYQb76rkT5o7gkf
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="4760893"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="4760893"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:45:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="11295410"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:44:59 -0700
Message-ID: <b3650606-712a-468d-9101-04c61c60531a@intel.com>
Date: Tue, 12 Mar 2024 10:44:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] kvm/cpuid: set proper GuestPhysBits in
 CPUID.0x80000008
Content-Language: en-US
To: Gerd Hoffmann <kraxel@redhat.com>, kvm@vger.kernel.org
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>
References: <20240311104118.284054-1-kraxel@redhat.com>
 <20240311104118.284054-3-kraxel@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240311104118.284054-3-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/2024 6:41 PM, Gerd Hoffmann wrote:
> The AMD APM (3.35) defines GuestPhysBits (EAX[23:16]) as:
> 
>    Maximum guest physical address size in bits.  This number applies
>    only to guests using nested paging.  When this field is zero, refer
>    to the PhysAddrSize field for the maximum guest physical address size.
> 
> Tom Lendacky confirmed that the purpose of GuestPhysBits is software use
> and KVM can use it as described below.  Hardware always returns zero
> here.
> 
> Use the GuestPhysBits field to communicate the max addressable GPA to
> the guest.  Typically this is identical to the max effective GPA, except
> in case the CPU supports MAXPHYADDR > 48 but does not support 5-level
> TDP.
> 
> GuestPhysBits is set only in case TDP is enabled, otherwise it is left
> at zero.
> 
> GuestPhysBits will be used by the guest firmware to make sure resources
> like PCI bars are mapped into the addressable GPA.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>   arch/x86/kvm/mmu.h     |  2 ++
>   arch/x86/kvm/cpuid.c   | 31 +++++++++++++++++++++++++++++--
>   arch/x86/kvm/mmu/mmu.c |  5 +++++
>   3 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..b410a227c601 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>   	return boot_cpu_data.x86_phys_bits;
>   }
>   
> +u8 kvm_mmu_get_max_tdp_level(void);
> +
>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>   void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c638b5fb2144..cd627dead9ce 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1221,8 +1221,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		entry->eax = entry->ebx = entry->ecx = 0;
>   		break;
>   	case 0x80000008: {
> +		/*
> +		 * GuestPhysAddrSize (EAX[23:16]) is intended for software
> +		 * use.
> +		 *
> +		 * KVM's ABI is to report the effective MAXPHYADDR for the
> +		 * guest in PhysAddrSize (phys_as), and the maximum
> +		 * *addressable* GPA in GuestPhysAddrSize (g_phys_as).
> +		 *
> +		 * GuestPhysAddrSize is valid if and only if TDP is enabled,
> +		 * in which case the max GPA that can be addressed by KVM may
> +		 * be less than the max GPA that can be legally generated by
> +		 * the guest, e.g. if MAXPHYADDR>48 but the CPU doesn't
> +		 * support 5-level TDP.
> +		 */
>   		unsigned int virt_as = max((entry->eax >> 8) & 0xff, 48U);
> -		unsigned int phys_as;
> +		unsigned int phys_as, g_phys_as;
>   
>   		if (!tdp_enabled) {
>   			/*
> @@ -1232,11 +1246,24 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   			 * for memory encryption affect shadow paging, too.
>   			 */
>   			phys_as = boot_cpu_data.x86_phys_bits;
> +			g_phys_as = 0;
>   		} else {
> +			/*
> +			 * If TDP is enabled, the effective guest MAXPHYADDR
> +			 * is the same as the raw bare metal MAXPHYADDR, as
> +			 * reductions to HPAs don't affect GPAs.  The max
> +			 * addressable GPA is the same as the max effective
> +			 * GPA, except that it's capped at 48 bits if 5-level
> +			 * TDP isn't supported (hardware processes bits 51:48
> +			 * only when walking the fifth level page table).
> +			 */

If the comment in previous patch gets changed as I suggested, this one 
needs to be updated as well.

Anyway, the patch itself looks good.

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

>   			phys_as = entry->eax & 0xff;
> +			g_phys_as = phys_as;
> +			if (kvm_mmu_get_max_tdp_level() < 5)
> +				g_phys_as = min(g_phys_as, 48);
>   		}
>   
> -		entry->eax = phys_as | (virt_as << 8);
> +		entry->eax = phys_as | (virt_as << 8) | (g_phys_as << 16);
>   		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
>   		entry->edx = 0;
>   		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2d6cdeab1f8a..ffd32400fd8c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5267,6 +5267,11 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>   	return max_tdp_level;
>   }
>   
> +u8 kvm_mmu_get_max_tdp_level(void)
> +{
> +	return tdp_root_level ? tdp_root_level : max_tdp_level;
> +}
> +
>   static union kvm_mmu_page_role
>   kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
>   				union kvm_cpu_role cpu_role)


