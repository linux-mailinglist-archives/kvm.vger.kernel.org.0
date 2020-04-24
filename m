Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242AB1B7884
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 16:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbgDXOq0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 10:46:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:50190 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726872AbgDXOq0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 10:46:26 -0400
IronPort-SDR: mJJ2rrqmJflWUMSKnZursi+zbiU5GL+9B2Oan3LUfc+98ckEUXmphJoNKsS/5XMpqkXzd897kF
 om0D3sJNwDqw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 07:46:25 -0700
IronPort-SDR: dc/ovCJOroXtCeCVuyJiWfqaWNBHsarWs+X7LIcYDJwXCIGcyQcDvhc9il1r3ZaHPZkaeulybn
 TStm3iJ3kRJw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="457925573"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga006.fm.intel.com with ESMTP; 24 Apr 2020 07:46:25 -0700
Date:   Fri, 24 Apr 2020 07:46:25 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Li RongQing <lirongqing@baidu.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, tglx@linutronix.de, joro@8bytes.org,
        jmattson@google.com, wanpengli@tencent.com, vkuznets@redhat.com,
        pbonzini@redhat.com
Subject: Re: [PATCH] [RFC] kvm: x86: emulate APERF/MPERF registers
Message-ID: <20200424144625.GB30013@linux.intel.com>
References: <1587704935-30960-1-git-send-email-lirongqing@baidu.com>
 <20200424100143.GZ20730@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424100143.GZ20730@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 12:01:43PM +0200, Peter Zijlstra wrote:
> On Fri, Apr 24, 2020 at 01:08:55PM +0800, Li RongQing wrote:
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 901cd1fdecd9..00e4993cb338 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -558,7 +558,10 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  	case 6: /* Thermal management */
> >  		entry->eax = 0x4; /* allow ARAT */
> >  		entry->ebx = 0;
> > -		entry->ecx = 0;
> > +		if (boot_cpu_has(X86_FEATURE_APERFMPERF))
> > +			entry->ecx = 0x1;
> > +		else
> > +			entry->ecx = 0x0;
> >  		entry->edx = 0;
> >  		break;
> >  	/* function 7 has additional index. */
> 
> AFAICT this is generic x86 code, that is, this will tell an AMD SVM
> guest it has APERFMPERF on.
> 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 91749f1254e8..f20216fc0b57 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1064,6 +1064,11 @@ static inline void pt_save_msr(struct pt_ctx *ctx, u32 addr_range)
> >  
> >  static void pt_guest_enter(struct vcpu_vmx *vmx)
> >  {
> > +	struct kvm_vcpu *vcpu = &vmx->vcpu;
> > +
> > +	rdmsrl(MSR_IA32_MPERF, vcpu->arch.host_mperf);
> > +	rdmsrl(MSR_IA32_APERF, vcpu->arch.host_aperf);

Why are these buried in Processor Trace code?  Is APERFMERF in any way
dependent on PT?

> > +
> >  	if (vmx_pt_mode_is_system())
> >  		return;
> >  
> > @@ -1081,6 +1086,15 @@ static void pt_guest_enter(struct vcpu_vmx *vmx)
> >  
> >  static void pt_guest_exit(struct vcpu_vmx *vmx)
> >  {
> > +	struct kvm_vcpu *vcpu = &vmx->vcpu;
> > +	u64 perf;
> > +
> > +	rdmsrl(MSR_IA32_MPERF, perf);
> > +	vcpu->arch.v_mperf += perf - vcpu->arch.host_mperf;
> > +
> > +	rdmsrl(MSR_IA32_APERF, perf);
> > +	vcpu->arch.v_aperf += perf - vcpu->arch.host_aperf;

This requires four RDMSRs per VMX transition.  Doing that unconditionally
will drastically impact performance.  Not to mention that reading the MSRs
without checking for host support will generate #GPs and WARNs on hardware
without APERFMPERF.

Assuming we're going forward with this, at an absolute minimum the RDMSRs
need to be wrapped with checks on host _and_ guest support for the emulated
behavior.  Given the significant overhead, this might even be something
that should require an extra opt-in from userspace to enable.

> > +
> >  	if (vmx_pt_mode_is_system())
> >  		return;
> >  
> > @@ -1914,6 +1928,12 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
> >  			return 1;
> >  		goto find_shared_msr;
> > +	case MSR_IA32_MPERF:
> > +		msr_info->data = vcpu->arch.v_mperf;
> > +		break;
> > +	case MSR_IA32_APERF:
> > +		msr_info->data = vcpu->arch.v_aperf;
> > +		break;
> >  	default:
> >  	find_shared_msr:
> >  		msr = find_msr_entry(vmx, msr_info->index);
> 
> But then here you only emulate it for VMX, which then results in SVM
> guests going wobbly.

Ya.

> Also, on Intel, the moment you advertise APERFMPERF, we'll try and read
> MSR_PLATFORM_INFO / MSR_TURBO_RATIO_LIMIT*, I don't suppose you're
> passing those through as well?

AFAICT, the proposed patch isn't fully advertising APERFMPERF, it's
advertising Turbo Boost / Dynamic Acceleration to the guest when APERFMPERF
can be used by the host to emulate IDA.  The transliteration of the
above code to be VMX-only is:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 766303b31949..7e459b66b06e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7191,6 +7191,9 @@ static __init void vmx_set_cpu_caps(void)
        if (nested)
                kvm_cpu_cap_set(X86_FEATURE_VMX);

+       if (boot_cpu_has(X86_FEATURE_APERFMPERF))
+               kvm_cpu_cap_set(X86_FEATURE_IDA);
+
        /* CPUID 0x7 */
        if (kvm_mpx_supported())
                kvm_cpu_cap_check_and_set(X86_FEATURE_MPX);

I have no clue as to whether that's sane/correct.
