Return-Path: <kvm+bounces-7287-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF64D83F59D
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 14:30:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6DE771F21E72
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 13:30:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3256D23759;
	Sun, 28 Jan 2024 13:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDB8MS8Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A1C23761;
	Sun, 28 Jan 2024 13:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706448608; cv=none; b=dFkAWlahkJfG1KJKj1b2sVTDG8WWMzPq4XYdbIWW66NbAZXkkaxHZNrzi08sJCmBqeqjwCqQR48ZAsTvnYs6ej0RAiWIYGAUbfOMpsdt5xpwlf5NiEIz5UcczrgsboihhwipWuXzM6kKBKHvBUyYnGBDHAFgUSJ0Va8nkL2tucM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706448608; c=relaxed/simple;
	bh=edA6KdPPNfWm2BtEdfY8oMP0a6+joeslKgk0ety0Rg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=re9D5wQzoNSa19DjSmZ6JNXdbUYawI9e2KKdKq9dZAungjRF0j10mh4W3tJfWwQ4WuuAZdBriIIkgEHa5ShgKrVwgRCYCLZpB4TpWkAPz/yHFNvKxey6A8XWp5HTCXUE/2jIjYb+yeE5EDw/M+TqiXzD2J/NJEKV81XFNPu95To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDB8MS8Z; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706448606; x=1737984606;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=edA6KdPPNfWm2BtEdfY8oMP0a6+joeslKgk0ety0Rg4=;
  b=mDB8MS8ZwtoEVpDyHGiJkrBy/AnQl9/LUEgpoiBkMRn58IIQl/owt0SS
   WboPE8Pjc3Ecm+Cc4dgluO7BWGDXBxcY3RBFl61oSuF2VHmVPyQFlwFyt
   RyyxN0KoX4bLphiGqGvbM8Iwva78D1yCLbuTr3w3idOhz7g9cxB9XaNGp
   Iy3CV77raySLyufDT2qVQLNPlmXoMScSr0fvH3pR8e4RFPFCDfM68qyeT
   I2uR1AExPIqrMdtSME8JEUo1fBHDmkvbYLnAK/8IFfpHpvhRbs/8iLtFr
   RSsfoj6eV4UN91//yb0CnZMMEgU7MhoUp29gdJbzn5EVhEo73H2/QjhIH
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10966"; a="9886555"
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="9886555"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 05:30:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,220,1701158400"; 
   d="scan'208";a="3162430"
Received: from binbinwu-mobl.ccr.corp.intel.com (HELO [10.93.8.92]) ([10.93.8.92])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2024 05:30:01 -0800
Message-ID: <06eae6f9-be90-459d-a808-29de602b7b5f@linux.intel.com>
Date: Sun, 28 Jan 2024 21:29:59 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 037/121] KVM: x86/mmu: Allow non-zero value for
 non-present SPTE and removed SPTE
To: isaku.yamahata@intel.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
 erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
 Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
 chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
 Sean Christopherson <sean.j.christopherson@intel.com>
References: <cover.1705965634.git.isaku.yamahata@intel.com>
 <a99cb866897c7083430dce7f24c63b17d7121134.1705965635.git.isaku.yamahata@intel.com>
From: Binbin Wu <binbin.wu@linux.intel.com>
In-Reply-To: <a99cb866897c7083430dce7f24c63b17d7121134.1705965635.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 1/23/2024 7:53 AM, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
>
> For TD guest, the current way to emulate MMIO doesn't work any more, as KVM
> is not able to access the private memory of TD guest and do the emulation.
> Instead, TD guest expects to receive #VE when it accesses the MMIO and then
> it can explicitly make hypercall to KVM to get the expected information.
>
> To achieve this, the TDX module always enables "EPT-violation #VE" in the
> VMCS control.  And accordingly, for the MMIO spte for the shared GPA,
> 1. KVM needs to set "suppress #VE" bit for the non-present SPTE so that EPT
> violation happens on TD accessing MMIO range.  2. On EPT violation, KVM
> sets the MMIO spte to clear "suppress #VE" bit so the TD guest can receive
> the #VE instead of EPT misconfigration unlike VMX case.  For the shared GPA
s/misconfigration/misconfiguration


> that is not populated yet, EPT violation need to be triggered when TD guest
> accesses such shared GPA.  The non-present SPTE value for shared GPA should
> set "suppress #VE" bit.
>
> Add "suppress #VE" bit (bit 63) to SHADOW_NONPRESENT_VALUE and
> REMOVED_SPTE.  Unconditionally set the "suppress #VE" bit (which is bit 63)
> for both AMD and Intel as: 1) AMD hardware doesn't use this bit when
> present bit is off; 2) for normal VMX guest, KVM never enables the
> "EPT-violation #VE" in VMCS control and "suppress #VE" bit is ignored by
> hardware.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Nit: one typo above.

Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>

> ---
>   arch/x86/kvm/mmu/spte.h | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 4d1799ba2bf8..26bc95bbc962 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -149,7 +149,20 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
>   
>   #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
>   
> +/*
> + * Non-present SPTE value for both VMX and SVM for TDP MMU.
> + * For SVM NPT, for non-present spte (bit 0 = 0), other bits are ignored.
> + * For VMX EPT, bit 63 is ignored if #VE is disabled. (EPT_VIOLATION_VE=0)
> + *              bit 63 is #VE suppress if #VE is enabled. (EPT_VIOLATION_VE=1)
> + * For TDX:
> + *   TDX module sets EPT_VIOLATION_VE for Secure-EPT and conventional EPT
> + */
> +#ifdef CONFIG_X86_64
> +#define SHADOW_NONPRESENT_VALUE	BIT_ULL(63)
> +static_assert(!(SHADOW_NONPRESENT_VALUE & SPTE_MMU_PRESENT_MASK));
> +#else
>   #define SHADOW_NONPRESENT_VALUE	0ULL
> +#endif
>   
>   extern u64 __read_mostly shadow_host_writable_mask;
>   extern u64 __read_mostly shadow_mmu_writable_mask;
> @@ -196,7 +209,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
>    *
>    * Only used by the TDP MMU.
>    */
> -#define REMOVED_SPTE	0x5a0ULL
> +#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
>   
>   /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
>   static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));


