Return-Path: <kvm+bounces-11623-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BF10878D08
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 03:38:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B6D51C2135B
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 229EF8472;
	Tue, 12 Mar 2024 02:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="emmaWASc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A90179C0;
	Tue, 12 Mar 2024 02:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710211093; cv=none; b=KlvSA0S5ZatoKhd1qUjAsSFCKabI2Zh+D7q7jkNh70JOXAe+0pf3gtPB3zs9OJr42bYp8wgefuKEX0wrijwE3gr9whs3nshf8brybl9qlpHQ+q+KYUGahHOYrI/uKDWUM/CC6ANA3KQziUOth+bXx43APPTRoJ05+lsva44RLQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710211093; c=relaxed/simple;
	bh=1FtJ+OreJxOlXP0TuZygG4IJfQyebhABpsh4S9e7fa8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IPa0v7nZY6XlOQJjzEIdtp0QGZJ5b7RO4aiNzYSRJDCOo50Qt94Mr4YAhPnfIXs2YmAygohQ7KapfGqHZQcAMhJBqmmmEPKQG69yK4xMv78RgXxhryDVYvCi9i65GZJyddWy0bT+IEXT188sMl2h/yRy6t/CQ/CrOKBEvP3C2m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=emmaWASc; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710211092; x=1741747092;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=1FtJ+OreJxOlXP0TuZygG4IJfQyebhABpsh4S9e7fa8=;
  b=emmaWASce/wg7dDb9LqMNB83GLAQHgJyNyt8FHi5wyiaLeXMmbRejopE
   +vz5Wc4+543fMwPqKbOpK0bnXam5RpWyJJtJnEVv9k9Rk32uhDGQ2UgRk
   f9fjSWJfnUalH0SVGH4/yM9g6dYztv4cb6ejqJ9m3rLWfjPvbpvPksNjw
   ojDq61P7nuu06mhnWmvmTlxxMQi3AjKCjNduzZWr7hX8yDTYoVnoAp3du
   ILzxcNWLZwjC+k7CQO/wEnpunwbyq39VKqCRDG3Vx/FyBONUl9DerJ4Ov
   EFMgewBn5fiplHPPNbPnPb73qvldUJ9nLrRDAU1G5YnlYx7seOF2+cYE3
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="4758346"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="4758346"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:38:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="11289744"
Received: from xiaoyaol-hp-g830.ccr.corp.intel.com (HELO [10.125.243.127]) ([10.125.243.127])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 19:38:07 -0700
Message-ID: <69628e0d-a1c8-4bf2-8eea-abfc0da1a6aa@intel.com>
Date: Tue, 12 Mar 2024 10:38:04 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] kvm/cpuid: remove GuestPhysBits code.
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
 <20240311104118.284054-2-kraxel@redhat.com>
From: Xiaoyao Li <xiaoyao.li@intel.com>
In-Reply-To: <20240311104118.284054-2-kraxel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/2024 6:41 PM, Gerd Hoffmann wrote:
 > [PATCH v3 1/2] kvm/cpuid: remove GuestPhysBits code.

No need for a ending . in the title.

> GuestPhysBits (cpuid leaf 80000008, eax[23:16]) is intended for software
> use.  Physical CPUs do not set that field.  The current code which
> propagates the host's GuestPhysBits to the guest's PhysBits does not
> make sense.  Remove it.
> 
> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> ---
>   arch/x86/kvm/cpuid.c | 32 ++++++++++++++------------------
>   1 file changed, 14 insertions(+), 18 deletions(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index adba49afb5fe..c638b5fb2144 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1221,26 +1221,22 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>   		entry->eax = entry->ebx = entry->ecx = 0;
>   		break;
>   	case 0x80000008: {
> -		unsigned g_phys_as = (entry->eax >> 16) & 0xff;
> -		unsigned virt_as = max((entry->eax >> 8) & 0xff, 48U);
> -		unsigned phys_as = entry->eax & 0xff;
> +		unsigned int virt_as = max((entry->eax >> 8) & 0xff, 48U);
> +		unsigned int phys_as;
>   
> -		/*
> -		 * If TDP (NPT) is disabled use the adjusted host MAXPHYADDR as
> -		 * the guest operates in the same PA space as the host, i.e.
> -		 * reductions in MAXPHYADDR for memory encryption affect shadow
> -		 * paging, too.
> -		 *
> -		 * If TDP is enabled but an explicit guest MAXPHYADDR is not
> -		 * provided, use the raw bare metal MAXPHYADDR as reductions to
> -		 * the HPAs do not affect GPAs.
> -		 */
> -		if (!tdp_enabled)
> -			g_phys_as = boot_cpu_data.x86_phys_bits;
> -		else if (!g_phys_as)
> -			g_phys_as = phys_as;
> +		if (!tdp_enabled) {
> +			/*
> +			 * If TDP (NPT) is disabled use the adjusted host
> +			 * MAXPHYADDR as the guest operates in the same PA
> +			 * space as the host, i.e.  reductions in MAXPHYADDR
> +			 * for memory encryption affect shadow paging, too.
> +			 */

I suggest keeping as the original comment to stay out of if check, and 
keeping the second paragraph with guest MAXPHYADDR thing removed as 
below, because the second paragraph is also useful.

   If TDP is enabled, use the raw bare metal MAXPHYADDR as reductions to
   the HPAs do not affect GPAs.

Otherwise,

Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>

> +			phys_as = boot_cpu_data.x86_phys_bits;
> +		} else {
> +			phys_as = entry->eax & 0xff;
> +		}
>   
> -		entry->eax = g_phys_as | (virt_as << 8);
> +		entry->eax = phys_as | (virt_as << 8);
>   		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
>   		entry->edx = 0;
>   		cpuid_entry_override(entry, CPUID_8000_0008_EBX);


