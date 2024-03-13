Return-Path: <kvm+bounces-11708-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA05087A081
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 02:09:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE1A21C225AA
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 01:09:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 834319475;
	Wed, 13 Mar 2024 01:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l/BRS7Vb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B429444;
	Wed, 13 Mar 2024 01:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710292151; cv=none; b=EWqHrUkVzMA7PUb2Ny7txyCRihiJAE8n/GGfVFrSkIdGbBqGI0lnEwesY91UehmBtM3NafFtzALU/0+vdP7csxds276obvv+v/N9l3iOM0VjZmsZZY0Ulfy37gPNU0qKm5ncmpbQ06oApVa7qg0YyJ2aFRZyIm+594RDHppJL/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710292151; c=relaxed/simple;
	bh=XMSgvQxqmXm4qOhJzqmqlGh1fNQViYOclec57iBqaLc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B3Jf3nREAEKCiC9gsugPUojXmDbZwc3ocb4rSGQCitJB99btDwLlzP3O2ZmYMFyOvHL6F2Ln90SxJ9UyYpFzdrqyztMk/UAJT1DhqapUGp1bzS+WvB2ZXvYMsGR8Ukj70vvqvqTJlhEaPKU8Jmehns1lZsbesqjM8j+bQ5bbnLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l/BRS7Vb; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710292150; x=1741828150;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=XMSgvQxqmXm4qOhJzqmqlGh1fNQViYOclec57iBqaLc=;
  b=l/BRS7VbB313umrYaRFRKr08EX5GHd+lc10xaKrNUSNNo9R2mvfFBkrt
   8pOpZiOuP1r10xOux8WoIGssqacz6arDwtpR1W5tS3TMEZWv92HwxG9gK
   6xHtasDRNOmgUjpNxUA/FZl4A+0cUsN+KwVCLQDAmos1tbKN/ZTv0pFfm
   pduJYBDTyVbuF/VlXzP/8giaGpzNYsD0bFwoj5vV4wV8X0yfd+mDdXLt3
   3ER++nPe7UnLtXGXt2twUzLEA2qZkYHk4hc0kpY91k84QUEG5zHCga7dM
   JLmufGCuH0ob32/i8jY7JSWHzkon7EySBnxBkbC12deTC6Z47aTE0on1i
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="22488349"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="22488349"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 18:09:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="16221111"
Received: from linux.bj.intel.com ([10.238.157.71])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 18:09:06 -0700
Date: Wed, 13 Mar 2024 09:06:14 +0800
From: Tao Su <tao1.su@linux.intel.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] kvm/cpuid: set proper GuestPhysBits in
 CPUID.0x80000008
Message-ID: <ZfD8BrVOM9gaTudC@linux.bj.intel.com>
References: <20240311104118.284054-1-kraxel@redhat.com>
 <20240311104118.284054-3-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240311104118.284054-3-kraxel@redhat.com>

On Mon, Mar 11, 2024 at 11:41:17AM +0100, Gerd Hoffmann wrote:
> The AMD APM (3.35) defines GuestPhysBits (EAX[23:16]) as:
> 
>   Maximum guest physical address size in bits.  This number applies
>   only to guests using nested paging.  When this field is zero, refer
>   to the PhysAddrSize field for the maximum guest physical address size.
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
>  arch/x86/kvm/mmu.h     |  2 ++
>  arch/x86/kvm/cpuid.c   | 31 +++++++++++++++++++++++++++++--
>  arch/x86/kvm/mmu/mmu.c |  5 +++++
>  3 files changed, 36 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
> index 60f21bb4c27b..b410a227c601 100644
> --- a/arch/x86/kvm/mmu.h
> +++ b/arch/x86/kvm/mmu.h
> @@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>  	return boot_cpu_data.x86_phys_bits;
>  }
>  
> +u8 kvm_mmu_get_max_tdp_level(void);
> +
>  void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>  void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>  void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index c638b5fb2144..cd627dead9ce 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1221,8 +1221,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = entry->ebx = entry->ecx = 0;
>  		break;
>  	case 0x80000008: {
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
>  		unsigned int virt_as = max((entry->eax >> 8) & 0xff, 48U);
> -		unsigned int phys_as;
> +		unsigned int phys_as, g_phys_as;
>  
>  		if (!tdp_enabled) {
>  			/*
> @@ -1232,11 +1246,24 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  			 * for memory encryption affect shadow paging, too.
>  			 */
>  			phys_as = boot_cpu_data.x86_phys_bits;
> +			g_phys_as = 0;
>  		} else {
> +			/*
> +			 * If TDP is enabled, the effective guest MAXPHYADDR
> +			 * is the same as the raw bare metal MAXPHYADDR, as
> +			 * reductions to HPAs don't affect GPAs.  The max
> +			 * addressable GPA is the same as the max effective
> +			 * GPA, except that it's capped at 48 bits if 5-level
> +			 * TDP isn't supported (hardware processes bits 51:48
> +			 * only when walking the fifth level page table).
> +			 */
>  			phys_as = entry->eax & 0xff;
> +			g_phys_as = phys_as;
> +			if (kvm_mmu_get_max_tdp_level() < 5)
> +				g_phys_as = min(g_phys_as, 48);
>  		}
>  
> -		entry->eax = phys_as | (virt_as << 8);
> +		entry->eax = phys_as | (virt_as << 8) | (g_phys_as << 16);

When g_phys_as==phys_as, I would suggest advertising g_phys_as==0,
otherwise application can easily know whether it is in a VM, I’m
concerned this could be abused by application.

>  		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
>  		entry->edx = 0;
>  		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 2d6cdeab1f8a..ffd32400fd8c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5267,6 +5267,11 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>  	return max_tdp_level;
>  }
>  
> +u8 kvm_mmu_get_max_tdp_level(void)
> +{
> +	return tdp_root_level ? tdp_root_level : max_tdp_level;
> +}
> +
>  static union kvm_mmu_page_role
>  kvm_calc_tdp_mmu_root_page_role(struct kvm_vcpu *vcpu,
>  				union kvm_cpu_role cpu_role)
> -- 
> 2.44.0
> 
> 

