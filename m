Return-Path: <kvm+bounces-11914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B54F87D05F
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 16:32:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF22BB23881
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 15:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A893E3E474;
	Fri, 15 Mar 2024 15:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FV5dLuva"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09FE3CF63;
	Fri, 15 Mar 2024 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516754; cv=none; b=d75yGiAM+EbsgHKhD38h8WBYRSp5PGcq6mi3G0wJxd+Lvt2W6XzHd/P5HFjf1lFwTkd9P75Lt4e9rgwk7N6P+LOlVop6qxx+TtjRmZmKdaKynWk6W6acFCcgRNGTHoa1/nhao4xaQK80QBTCrz8MyVYMZIwDBTQVMHUadrgw/tI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516754; c=relaxed/simple;
	bh=qIWHRg8+eu5c29VD4Zm6n7oQubxdYCjfi82fseL+o50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b3f5BOYneF/P4fslT4UX7guwErE0shfGP1JVQpzYHfQRNVsumxP4egJop5xoXquG/lwFJSoXe9sicVZb/lca3GNqKDUfzNaithNVW0Cdd7VXXCbSyOCmIAofHSByDmRytecY3CgAbNE9ONRqIcIxldZb6P60wPrMfBTZbS98Uxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FV5dLuva; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710516749; x=1742052749;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qIWHRg8+eu5c29VD4Zm6n7oQubxdYCjfi82fseL+o50=;
  b=FV5dLuva2oEybl9ytZX6JtmeGxh958I3i79qxGbF2uk5AnG0vLQvPKQt
   xmVzG3Zj5ifas37wzJrxEVYfA8RCmObB4dcuQ/E8nVAy91/CklYJxmmXb
   J0vCHl4sz9OTsGwZHYcNwG69DtAFRAakTEA5uFCQ/LWT6jKulRbB61/qy
   qL1kllXHKPd3PZ51F0S7ek6aF2/pHBdEE59qYn315O8M/2tCZyIRuxfWt
   XzZGuMFXoXckaGPP9vyXg9/9F4cQE1H1g5rKB2exonQ1ETXkVDMyHfr/m
   uoybLkf4Qav5SouIl3wgZ4uwmoT72L+V0Y2x2YsxgyYeGW8bGrqRsDvOg
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11014"; a="5600794"
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="5600794"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2024 08:32:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,128,1708416000"; 
   d="scan'208";a="12783740"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.36])
  by fmviesa006.fm.intel.com with ESMTP; 15 Mar 2024 08:32:25 -0700
Date: Fri, 15 Mar 2024 23:46:16 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Shan Kang <shan.kang@intel.com>,
	Kai Huang <kai.huang@intel.com>, Xin Li <xin3.li@intel.com>
Subject: Re: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate
 mask in its accessor
Message-ID: <ZfRtSKcXTI/lAQxE@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
 <20240309012725.1409949-9-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240309012725.1409949-9-seanjc@google.com>

On Fri, Mar 08, 2024 at 05:27:24PM -0800, Sean Christopherson wrote:
> Date: Fri,  8 Mar 2024 17:27:24 -0800
> From: Sean Christopherson <seanjc@google.com>
> Subject: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask
>  in its accessor
> X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
> 
> From: Xin Li <xin3.li@intel.com>
> 
> Use vmx_misc_preemption_timer_rate() to get the rate in hardware_setup(),
> and open code the rate's bitmask in vmx_misc_preemption_timer_rate() so
> that the function looks like all the helpers that grab values from
> VMX_BASIC and VMX_MISC MSR values.
> 
> No functional change intended.
> 
> Cc: Shan Kang <shan.kang@intel.com>
> Cc: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Xin Li <xin3.li@intel.com>
> [sean: split to separate patch, write changelog]
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/vmx.h | 3 +--
>  arch/x86/kvm/vmx/vmx.c     | 2 +-
>  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 6ff179b11235..90ed559076d7 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -148,7 +148,6 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
>  	return (vmx_basic & GENMASK_ULL(53, 50)) >> 50;
>  }
>  
> -#define VMX_MISC_PREEMPTION_TIMER_RATE_MASK	GENMASK_ULL(4, 0)
>  #define VMX_MISC_SAVE_EFER_LMA			BIT_ULL(5)
>  #define VMX_MISC_ACTIVITY_HLT			BIT_ULL(6)
>  #define VMX_MISC_ACTIVITY_SHUTDOWN		BIT_ULL(7)
> @@ -162,7 +161,7 @@ static inline u32 vmx_basic_vmcs_mem_type(u64 vmx_basic)
>  
>  static inline int vmx_misc_preemption_timer_rate(u64 vmx_misc)
>  {
> -	return vmx_misc & VMX_MISC_PREEMPTION_TIMER_RATE_MASK;
> +	return vmx_misc & GENMASK_ULL(4, 0);
>  }

I feel keeping VMX_MISC_PREEMPTION_TIMER_RATE_MASK is clearer than
GENMASK_ULL(4, 0), and the former improves code readability.

May not need to drop VMX_MISC_PREEMPTION_TIMER_RATE_MASK?

Thanks,
Zhao

