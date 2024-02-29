Return-Path: <kvm+bounces-10431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 195D086C196
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 08:04:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 725A128658C
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:04:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9321446B6;
	Thu, 29 Feb 2024 07:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fSsWhUrx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429F03A1A7;
	Thu, 29 Feb 2024 07:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709190265; cv=none; b=NCbDMiu7gFaeRinurFRv8x4aCajaAquVTDuM6UrqDL87cu678cTqNeci9/O7OvArRDBiGLDRv2HrmldnxYU1jB5p4L9gOMEQNbW+DS/hmTW7oylA+TmiAsUgUmEpP4bdC92t1j1bqCTXg4EsqKnsIhnZzKbMzsvVzWmQHtnYnkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709190265; c=relaxed/simple;
	bh=oCcSrOSitVTGnp+3Z+lxM2uvxgOKnut/TyUvCifotlI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFyhgvdTWtF4TQlmRfmSiYdSW9XQrHAtQC5WViYwNb64B7RhTVyLTZqAAvxDORYHBu8hjUDvJF2KkSy05aWYDNO3Ty2HGYw4S2YbbvJOPHm6Y8W5UNhPSkcZU76CcJQcudrtsBl6/hdRyvv82OciZ0mjLQ51ZSmaX+LkwDNDvG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fSsWhUrx; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709190263; x=1740726263;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oCcSrOSitVTGnp+3Z+lxM2uvxgOKnut/TyUvCifotlI=;
  b=fSsWhUrxPH+Vk900O+gzecsnO/BihHOZDbWEYIo9X6pxQG6AB6zKk4Cw
   rgVQoxQhb0ZgbfzbAOT+3tpJ9DCmi/HNognh+lub0OzLMcko61U7U6wh3
   UIBVMx+G2ZLpeifqZ2Zb6MRaC0Wn2bD2Xk7cNUhGvCHiU2L+t+DZsWW0T
   n3oeplscM//x4fQfeip4jduwjqcw1gkgAHTrqTyZ8NfqEC9WoZ6NSqWh0
   5AQlZqLwvpFgHFMqrGgKQLTA20D2NMXYCXGmStznG2t7RouBLD9OwglJQ
   SD0+1ykuXSYFymTTHEFwSya86gaaNDyhirhMct6ukJ4E64cPX3JF2NWz5
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3563686"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3563686"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 23:04:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="12418862"
Received: from yilunxu-optiplex-7050.sh.intel.com (HELO localhost) ([10.239.159.165])
  by orviesa005.jf.intel.com with ESMTP; 28 Feb 2024 23:04:20 -0800
Date: Thu, 29 Feb 2024 15:00:14 +0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com,
	michael.roth@amd.com, isaku.yamahata@intel.com,
	thomas.lendacky@amd.com, Binbin Wu <binbin.wu@linux.intel.com>
Subject: Re: [PATCH 04/21] KVM: x86/mmu: Allow non-zero value for non-present
 SPTE and removed SPTE
Message-ID: <ZeArfhFJnftccuaZ@yilunxu-OptiPlex-7050>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-5-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240227232100.478238-5-pbonzini@redhat.com>

On Tue, Feb 27, 2024 at 06:20:43PM -0500, Paolo Bonzini wrote:
> From: Sean Christopherson <seanjc@google.com>
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
> the #VE instead of EPT misconfiguration unlike VMX case.  For the shared GPA
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
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
> Message-Id: <a99cb866897c7083430dce7f24c63b17d7121134.1705965635.git.isaku.yamahata@intel.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/mmu/spte.h | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> index 4d1799ba2bf8..26bc95bbc962 100644
> --- a/arch/x86/kvm/mmu/spte.h
> +++ b/arch/x86/kvm/mmu/spte.h
> @@ -149,7 +149,20 @@ static_assert(MMIO_SPTE_GEN_LOW_BITS == 8 && MMIO_SPTE_GEN_HIGH_BITS == 11);
>  
>  #define MMIO_SPTE_GEN_MASK		GENMASK_ULL(MMIO_SPTE_GEN_LOW_BITS + MMIO_SPTE_GEN_HIGH_BITS - 1, 0)
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
>  #define SHADOW_NONPRESENT_VALUE	0ULL
> +#endif
>  
>  extern u64 __read_mostly shadow_host_writable_mask;
>  extern u64 __read_mostly shadow_mmu_writable_mask;
> @@ -196,7 +209,7 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;

    * vulnerability.  Use only low bits to avoid 64-bit immediates.
                      ^

We may remove this comment. Others are fine.

Reviewed-by: Xu Yilun <yilun.xu@linux.intel.com>

>   *
>   * Only used by the TDP MMU.
>   */
> -#define REMOVED_SPTE	0x5a0ULL
> +#define REMOVED_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
>  
>  /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
>  static_assert(!(REMOVED_SPTE & SPTE_MMU_PRESENT_MASK));
> -- 
> 2.39.0
> 
> 
> 

