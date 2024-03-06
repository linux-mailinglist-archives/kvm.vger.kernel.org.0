Return-Path: <kvm+bounces-11106-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C71872E7A
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 06:43:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2CBF287EA3
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 05:43:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C3731BC26;
	Wed,  6 Mar 2024 05:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZZ2ovyhU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDD8012E78;
	Wed,  6 Mar 2024 05:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709703823; cv=none; b=uf0HuB7ALFeeQqrdiys7PJd5OU3QqzyKeKc/N2kKVlPKLIU1/pEhxz/ez/w4z0R4YuKH9RRJKIUW9fybLY42TXzfuxxvVvR4O5pB98AHAk7ujBxJcgGfZnBdFXSP6JXZdn3nsPCHojDPOR/mdkOCDm9tZUPTIOm0ANOkvqiygUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709703823; c=relaxed/simple;
	bh=/a5zZ6hcRIn1rjkNmOJWYFt2Nz3D3X6QmzZo3MOttLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nSSxw07xVwhRuhyc3lFtapMMpsdqOCQr9IGY2CBAAfSoAPGzeTrfiyz9qq7SzE+uRTotz7NM0F2EeaoFjXWj0OjiMSXT7cdrjrhbIog3V4FlMpqZVOt7J5Hcuuhtn1d0Uek98hqnWZvxhoCFKXjdQy9hEX26WnsVtproT3tF0eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZZ2ovyhU; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709703822; x=1741239822;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/a5zZ6hcRIn1rjkNmOJWYFt2Nz3D3X6QmzZo3MOttLc=;
  b=ZZ2ovyhU6xho8BGr6NLjWL+k4Tgvcq+gvJByQK6gxC1obf0kQ4q1L7eJ
   UiK+FFtm9exXaJfHcHg+UTgpL+b9N1ugGE1zuQw4B8mB07rZcBH/ZbgEe
   75pNQbq5q/MUD7bm1mTNE5bDZ/bSa/8dKDC8fPoudR/Irbgynop3myY6h
   LOavlkaDRSR1+49RIW3tsvxgIP81BtV5dWOwdJjFW67j11XT12bwmJysZ
   1s+bB+5mmTu3f4+9P1be+SkkT7xUfeL6e9gnCz6UKL1NVoVXFG0UDATkp
   R3URBXCpu8ly9L76klCknV6pKrBk+l241kJCTEQyb6TNyrmmjH4dBJ/5v
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="4235015"
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="4235015"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 21:43:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,207,1705392000"; 
   d="scan'208";a="14327459"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.124.242.48]) ([10.124.242.48])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2024 21:43:37 -0800
Message-ID: <61c01b21-7422-4bcb-895d-57b0eb07b5ff@intel.com>
Date: Wed, 6 Mar 2024 13:43:34 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kvm: set guest physical bits in CPUID.0x80000008
To: Sean Christopherson <seanjc@google.com>, Gerd Hoffmann <kraxel@redhat.com>
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>,
 "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <linux-kernel@vger.kernel.org>
References: <20240305103506.613950-1-kraxel@redhat.com>
 <ZedJ1UmvaYZ4PWp6@google.com>
Content-Language: en-US
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <ZedJ1UmvaYZ4PWp6@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/6/2024 12:35 AM, Sean Christopherson wrote:
> KVM: x86:
> 
> On Tue, Mar 05, 2024, Gerd Hoffmann wrote:
>> Set CPUID.0x80000008:EAX[23:16] to guest phys bits, i.e. the bits which
>> are actually addressable.  In most cases this is identical to the host
>> phys bits, but tdp restrictions (no 5-level paging) can limit this to
>> 48.
>>
>> Quoting AMD APM (revision 3.35):
>>
>>    23:16 GuestPhysAddrSize Maximum guest physical address size in bits.
>>                            This number applies only to guests using nested
>>                            paging. When this field is zero, refer to the
>>                            PhysAddrSize field for the maximum guest
>>                            physical address size. See “Secure Virtual
>>                            Machine” in APM Volume 2.
>>
>> Tom Lendacky confirmed the purpose of this field is software use,
>> hardware always returns zero here.
>>
>> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
>> ---
>>   arch/x86/kvm/mmu.h     |  2 ++
>>   arch/x86/kvm/cpuid.c   |  3 ++-
>>   arch/x86/kvm/mmu/mmu.c | 15 +++++++++++++++
>>   3 files changed, 19 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>> index 60f21bb4c27b..42b5212561c8 100644
>> --- a/arch/x86/kvm/mmu.h
>> +++ b/arch/x86/kvm/mmu.h
>> @@ -100,6 +100,8 @@ static inline u8 kvm_get_shadow_phys_bits(void)
>>   	return boot_cpu_data.x86_phys_bits;
>>   }
>>   
>> +int kvm_mmu_get_guest_phys_bits(void);
>> +
>>   void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 mmio_mask, u64 access_mask);
>>   void kvm_mmu_set_me_spte_mask(u64 me_value, u64 me_mask);
>>   void kvm_mmu_set_ept_masks(bool has_ad_bits, bool has_exec_only);
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index adba49afb5fe..12037f1b017e 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1240,7 +1240,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>>   		else if (!g_phys_as)
> 
> Based on the new information that GuestPhysAddrSize is software-defined, and the
> fact that KVM and QEMU are planning on using GuestPhysAddrSize to communicate
> the maximum *addressable* GPA, deriving PhysAddrSize from GuestPhysAddrSize is
> wrong.
> 
> E.g. if KVM is running as L1 on top of a new KVM, on a CPU with MAXPHYADDR=52,
> and on a CPU without 5-level TDP, then KVM (as L1) will see:
> 
>    PhysAddrSize      = 52
>    GuestPhysAddrSize = 48
> 
> Propagating GuestPhysAddrSize to PhysAddrSize (which is confusingly g_phys_as)
> will yield an L2 with
> 
>    PhysAddrSize      = 48
>    GuestPhysAddrSize = 48
> 
> which is broken, because GPAs with bits 51:48!=0 are *legal*, but not addressable.
> 
>>   			g_phys_as = phys_as;
>>   
>> -		entry->eax = g_phys_as | (virt_as << 8);
>> +		entry->eax = g_phys_as | (virt_as << 8)
>> +			| kvm_mmu_get_guest_phys_bits() << 16;
> 
> The APM explicitly states that GuestPhysAddrSize only applies to NPT.  KVM should
> follow suit to avoid creating unnecessary ABI, and because KVM can address any
> legal GPA when using shadow paging.
> 
>>   		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
>>   		entry->edx = 0;
>>   		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 2d6cdeab1f8a..8bebb3e96c8a 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -5267,6 +5267,21 @@ static inline int kvm_mmu_get_tdp_level(struct kvm_vcpu *vcpu)
>>   	return max_tdp_level;
>>   }
>>   
>> +/*
>> + * return the actually addressable guest phys bits, which might be
>> + * less than host phys bits due to tdp restrictions.
>> + */
>> +int kvm_mmu_get_guest_phys_bits(void)
>> +{
>> +	if (tdp_enabled && shadow_phys_bits > 48) {
>> +		if (tdp_root_level && tdp_root_level != PT64_ROOT_5LEVEL)
>> +			return 48;
>> +		if (max_tdp_level != PT64_ROOT_5LEVEL)
>> +			return 48;
> 
> I would prefer to not use shadow_phys_bits to cap the reported CPUID.0x8000_0008,
> so that the logic isn't spread across the CPUID code and the MMU.  I don't love
> that the two have duplicate logic, but there's no great way to handle that since
> the MMU needs to be able to determine the effective host MAXPHYADDR even if
> CPUID.0x8000_0008 is unsupported.
> 
> I'm thinking this, maybe spread across two patches: one to undo KVM's usage of
> GuestPhysAddrSize, and a second to then set GuestPhysAddrSize for userspace?

Below code looks good to me. And make it into two patches makes sense.

> ---
>   arch/x86/kvm/cpuid.c   | 38 ++++++++++++++++++++++++++++----------
>   arch/x86/kvm/mmu.h     |  2 ++
>   arch/x86/kvm/mmu/mmu.c |  5 +++++
>   3 files changed, 35 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index adba49afb5fe..ae03e69d7fb9 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1221,9 +1221,18 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		entry->eax = entry->ebx = entry->ecx = 0;
>   		break;
>   	case 0x80000008: {
> -		unsigned g_phys_as = (entry->eax >> 16) & 0xff;
> -		unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
> -		unsigned phys_as = entry->eax & 0xff;
> +		unsigned int virt_as = max((entry->eax >> 8) & 0xff, 48U);
> +
> +		/*
> +		 * KVM's ABI is to report the effective MAXPHYADDR for the guest
> +		 * in PhysAddrSize (phys_as), and the maximum *addressable* GPA
> +		 * in GuestPhysAddrSize (g_phys_as).  GuestPhysAddrSize is valid
> +		 * if and only if TDP is enabled, in which case the max GPA that
> +		 * can be addressed by KVM may be less than the max GPA that can
> +		 * be legally generated by the guest, e.g. if MAXPHYADDR>48 but
> +		 * the CPU doesn't support 5-level TDP.
> +		 */
> +		unsigned int phys_as, g_phys_as;
>   
>   		/*
>   		 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
> @@ -1231,16 +1240,25 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		 * reductions in MAXPHYADDR for memory encryption affect shadow
>   		 * paging, too.
>   		 *
> -		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
> -		 * provided, use the raw bare metal MAXPHYADDR as reductions to
> -		 * the HPAs do not affect GPAs.
> +		 * If TDP is enabled, the effective guest MAXPHYADDR is the same
> +		 * as the raw bare metal MAXPHYADDR, as reductions to HPAs don't
> +		 * affect GPAs.  The max addressable GPA is the same as the max
> +		 * effective GPA, except that it's capped at 48 bits if 5-level
> +		 * TDP isn't supported (hardware processes bits 51:48 only when
> +		 * walking the fifth level page table).
>   		 */
> -		if (!tdp_enabled)
> -			g_phys_as = boot_cpu_data.x86_phys_bits;
> -		else if (!g_phys_as)
> +		if (!tdp_enabled) {
> +			phys_as = boot_cpu_data.x86_phys_bits;
> +			g_phys_as = 0;
> +		} else {
> +			phys_as = entry->eax & 0xff;
>   			g_phys_as = phys_as;
>   
> -		entry->eax = g_phys_as | (virt_as << 8);
> +			if (kvm_mmu_get_max_tdp_level() < 5)
> +				g_phys_as = min(g_phys_as, 48);
> +		}
> +
> +		entry->eax = phys_as | (virt_as << 8) | (g_phys_as << 16);
>   		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
>   		entry->edx = 0;
>   		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
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
> 
> base-commit: c0372e747726ce18a5fba8cdc71891bd795148f6


