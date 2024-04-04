Return-Path: <kvm+bounces-13627-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDA2D899245
	for <lists+kvm@lfdr.de>; Fri,  5 Apr 2024 01:42:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0EE11C240D6
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 23:42:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B707113C80F;
	Thu,  4 Apr 2024 23:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="baOWWQ3e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F63B130E57;
	Thu,  4 Apr 2024 23:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712274161; cv=none; b=e5Nb0F0Y3jIAVKDWmUfmXEIw4HVjIZpgr2QJ7kE8Ycnj19s7xYnuwle1nBvPlgtp+reUhVTZhj8UPrPJQmRQJfEdl5OcjSqsoCCojP8B6+JmSbY8mbIMb6/0aWcLSLNYwY2VEI5rGbALBwhEEo3Cxg5FppYFTf9Aoe8+X7OXgpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712274161; c=relaxed/simple;
	bh=jGMQk68RyS6w08hpKx66Yj4yvkjD4VsCo0MwgbYttoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Svj4VwMygy2WN+/JqtpOzSHywY36CYMcMjnUkckPL9/Hs20n9WOvHyjUyEQZuahqSRDkZazaiYMy1gANxYIUk7HL2zlDhD9BF9CxclL+ZAF5ppwaBytQOQHT8JrGZ6lGzW2hdHs3UdZtFy/uWkcFAVAvxSBgnt8e+5p2Qu1LHm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=baOWWQ3e; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712274160; x=1743810160;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jGMQk68RyS6w08hpKx66Yj4yvkjD4VsCo0MwgbYttoQ=;
  b=baOWWQ3e+HYrLQ/TS8+9A70LjUyU6tQBZ2NYiYeNRWVjqxRNZbqOnh2p
   kbu8bi1YuRDSFjd083EfMiePWBqeiZWOi5dHLEEkNSaf9+0iCGw4yE8i0
   Pfv/5ZlU1j0j4ByPFSgegqnRhTiWnJiCxUZKhqStLKh0SmgiGJtneBiz/
   8Yrg/eiLWW/PxuBlwUNF8yHOqWs/MnabrsPk4lpe9YlcgZDvrtjvhNFys
   p+YO+EJQMNM89HjpaJwZAaza3qgfGtssa4j/wYob9tJDTgXFsjpTUprsV
   tbuZAaz1O0HC9j+MrgbqCuMsONWGd3z2JKD2AVZyge6Y1pycbS0WamvtI
   A==;
X-CSE-ConnectionGUID: 6k2+MGDTQ8yoO32Y3wDBBw==
X-CSE-MsgGUID: Q1P4UBtCT0ebJv9UXaK4uA==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="30063249"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="30063249"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 16:42:39 -0700
X-CSE-ConnectionGUID: vEhCm3w/SJeJlKP6oLcwNg==
X-CSE-MsgGUID: pFH20QEBQYiRwpgQ/+0tyw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="42136781"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 16:42:39 -0700
Date: Thu, 4 Apr 2024 16:42:38 -0700
From: Isaku Yamahata <isaku.yamahata@intel.com>
To: Sean Christopherson <seanjc@google.com>
Cc: isaku.yamahata@intel.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
	Sagi Shahar <sagis@google.com>, Kai Huang <kai.huang@intel.com>,
	chen.bo@intel.com, hang.yuan@intel.com, tina.zhang@intel.com,
	isaku.yamahata@linux.intel.com
Subject: Re: [PATCH v19 111/130] KVM: TDX: Implement callbacks for MSR
 operations for TDX
Message-ID: <20240404234238.GW2444378@ls.amr.corp.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <62f8890cb90e49a3e0b0d5946318c0267b80c540.1708933498.git.isaku.yamahata@intel.com>
 <Zg1yPIV6cVJrwGxX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zg1yPIV6cVJrwGxX@google.com>

On Wed, Apr 03, 2024 at 08:14:04AM -0700,
Sean Christopherson <seanjc@google.com> wrote:

> On Mon, Feb 26, 2024, isaku.yamahata@intel.com wrote:
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 389bb95d2af0..c8f991b69720 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1877,6 +1877,76 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
> >  	*error_code = 0;
> >  }
> >  
> > +static bool tdx_is_emulated_kvm_msr(u32 index, bool write)
> > +{
> > +	switch (index) {
> > +	case MSR_KVM_POLL_CONTROL:
> > +		return true;
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> > +bool tdx_has_emulated_msr(u32 index, bool write)
> > +{
> > +	switch (index) {
> > +	case MSR_IA32_UCODE_REV:
> > +	case MSR_IA32_ARCH_CAPABILITIES:
> > +	case MSR_IA32_POWER_CTL:
> > +	case MSR_IA32_CR_PAT:
> > +	case MSR_IA32_TSC_DEADLINE:
> > +	case MSR_IA32_MISC_ENABLE:
> > +	case MSR_PLATFORM_INFO:
> > +	case MSR_MISC_FEATURES_ENABLES:
> > +	case MSR_IA32_MCG_CAP:
> > +	case MSR_IA32_MCG_STATUS:
> > +	case MSR_IA32_MCG_CTL:
> > +	case MSR_IA32_MCG_EXT_CTL:
> > +	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
> > +	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
> > +		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC, CTL2} */
> > +		return true;
> > +	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
> > +		/*
> > +		 * x2APIC registers that are virtualized by the CPU can't be
> > +		 * emulated, KVM doesn't have access to the virtual APIC page.
> > +		 */
> > +		switch (index) {
> > +		case X2APIC_MSR(APIC_TASKPRI):
> > +		case X2APIC_MSR(APIC_PROCPRI):
> > +		case X2APIC_MSR(APIC_EOI):
> > +		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
> > +		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
> > +		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
> > +			return false;
> > +		default:
> > +			return true;
> > +		}
> > +	case MSR_IA32_APICBASE:
> > +	case MSR_EFER:
> > +		return !write;
> 
> Meh, for literally two MSRs, just open code them in tdx_set_msr() and drop the
> @write param.  Or alternatively add:
> 
> static bool tdx_is_read_only_msr(u32 msr){
> {
> 	return msr == MSR_IA32_APICBASE || msr == MSR_EFER;
> }

Sure will add.

> 
> > +	case 0x4b564d00 ... 0x4b564dff:
> 
> This is silly, just do
> 
> 	case MSR_KVM_POLL_CONTROL:
> 		return false;
> 
> and let everything else go through the default statement, no?

Now tdx_is_emulated_kvm_msr() is trivial, will open code it.


> > +		/* KVM custom MSRs */
> > +		return tdx_is_emulated_kvm_msr(index, write);
> > +	default:
> > +		return false;
> > +	}
> > +}
> > +
> > +int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > +{
> > +	if (tdx_has_emulated_msr(msr->index, false))
> > +		return kvm_get_msr_common(vcpu, msr);
> > +	return 1;
> 
> Please invert these and make the happy path the not-taken path, i.e.
> 
> 	if (!tdx_has_emulated_msr(msr->index))
> 		return 1;
> 
> 	return kvm_get_msr_common(vcpu, msr);
> 
> The standard kernel pattern is
> 
> 	if (error)
> 		return <error thingie>
> 
> 	return <happy thingie>
> 
> > +}
> > +
> > +int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
> > +{
> > +	if (tdx_has_emulated_msr(msr->index, true))
> 
> As above:
> 
> 	if (tdx_is_read_only_msr(msr->index))
> 		return 1;
> 
> 	if (!tdx_has_emulated_msr(msr->index))
> 		return 1;
> 
> 	return kvm_set_msr_common(vcpu, msr);

Sure, will update them.


> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index d5b18cad9dcd..0e1d3853eeb4 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -90,7 +90,6 @@
> >  #include "trace.h"
> >  
> >  #define MAX_IO_MSRS 256
> > -#define KVM_MAX_MCE_BANKS 32
> >  
> >  struct kvm_caps kvm_caps __read_mostly = {
> >  	.supported_mce_cap = MCG_CTL_P | MCG_SER_P,
> > diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> > index 4e40c23d66ed..c87b7a777b67 100644
> > --- a/arch/x86/kvm/x86.h
> > +++ b/arch/x86/kvm/x86.h
> > @@ -9,6 +9,8 @@
> >  #include "kvm_cache_regs.h"
> >  #include "kvm_emulate.h"
> >  
> > +#define KVM_MAX_MCE_BANKS 32
> 
> Split this to a separate.  Yes, it's trivial, but that's _exactly_ why it should
> be in a separate patch.  The more trivial refactoring you split out, the more we
> can apply _now_ and take off your hands.

Will split it.
-- 
Isaku Yamahata <isaku.yamahata@intel.com>

