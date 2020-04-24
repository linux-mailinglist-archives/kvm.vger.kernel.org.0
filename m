Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6DD1B787B
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 16:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgDXOpz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 10:45:55 -0400
Received: from mga06.intel.com ([134.134.136.31]:23091 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726707AbgDXOpy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 10:45:54 -0400
IronPort-SDR: Z6E6llFs1p5UHGGq8swL2WPGTblmy9b5KrLLeRg0C1nJB6hxRsXbHuu3EiBs9CZJBM7ZPtMsxh
 uFA34RMpzsQA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 07:45:51 -0700
IronPort-SDR: bIq/sAdTuo5CqfgSdHbFHEzG5kckZHnXZyykIfjeUd6lJxDPY2iCTu08LBycgVzPIWdNAr/hI2
 pzvLLweCispQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="457364053"
Received: from unknown (HELO localhost) ([10.239.159.128])
  by fmsmga005.fm.intel.com with ESMTP; 24 Apr 2020 07:45:49 -0700
Date:   Fri, 24 Apr 2020 22:47:51 +0800
From:   Yang Weijiang <weijiang.yang@intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        jmattson@google.com, yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v11 5/9] KVM: X86: Refresh CPUID once guest XSS MSR
 changes
Message-ID: <20200424144751.GJ24039@local-michael-cet-test>
References: <20200326081847.5870-1-weijiang.yang@intel.com>
 <20200326081847.5870-6-weijiang.yang@intel.com>
 <20200423173450.GJ17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423173450.GJ17824@linux.intel.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 10:34:50AM -0700, Sean Christopherson wrote:
> On Thu, Mar 26, 2020 at 04:18:42PM +0800, Yang Weijiang wrote:
> > CPUID(0xd, 1) reports the current required storage size of
 
> >  	struct kvm_pio_request pio;
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 78d461be2102..25e9a11291b3 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -95,9 +95,24 @@ int kvm_update_cpuid(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	best = kvm_find_cpuid_entry(vcpu, 0xD, 1);
> > -	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
> > -		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
> > -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
> > +	if (best) {
> > +		if (best->eax & (F(XSAVES) | F(XSAVEC))) {
> 
> Please use cpuid_entry_has() to preserve the automagic register lookup and
> compile-time assertions that are provided.  E.g. I don't know off the top
> of my whether %eax is the correct register, and I don't want to know :-).
>
Got it, will fix it.

> > +			u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
> > +
> > +			best->ebx = xstate_required_size(xstate, true);
> > +		}
> > +
> > +		if (best->eax & F(XSAVES)) {
> 
> Same thing here.
> 
> > +			vcpu->arch.guest_supported_xss =
> > +			(best->ecx | ((u64)best->edx << 32)) & supported_xss;
> 
> The indentation is funky, I'm guessing you're trying to squeak in less than
> 80 chars.  Maybe this?
> 
> 		if (!cpuid_entry_has(best, X86_FEATURE_XSAVES)) {
> 			best->ecx = 0;
> 			best->edx = 0;
> 		}
> 
> 		 vcpu->arch.guest_supported_xss =
> 			(((u64)best->edx << 32) | best->ecx) & supported_xss;
> 
> Nit: my preference is to have the high half first, x86 is little endian
> (the xcr0 code is "wrong" :-D).  For me, this also makes it more obvious
> that the effective size is a u64.
>
Good suggestion, will fixed it together the xcr0 part!

> > +		} else {
> > +			best->ecx = 0;
> > +			best->edx = 0;
> > +			vcpu->arch.guest_supported_xss = 0;
> > +		}
> > +	} else {
> > +		vcpu->arch.guest_supported_xss = 0;
> > +	}
> >  
> >  	/*
> >  	 * The existing code assumes virtual address is 48-bit or 57-bit in the
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 90acdbbb8a5a..51ecb496d47d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2836,9 +2836,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> >  		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
> >  		 * XSAVES/XRSTORS to save/restore PT MSRs.
> >  		 */
> > -		if (data & ~supported_xss)
> > +		if (data & ~vcpu->arch.guest_supported_xss)
> >  			return 1;
> > -		vcpu->arch.ia32_xss = data;
> > +		if (vcpu->arch.ia32_xss != data) {
> > +			vcpu->arch.ia32_xss = data;
> > +			kvm_update_cpuid(vcpu);
> > +		}
> >  		break;
> >  	case MSR_SMI_COUNT:
> >  		if (!msr_info->host_initiated)
> > @@ -9635,6 +9638,8 @@ int kvm_arch_hardware_setup(void)
> >  
> >  	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> >  		supported_xss = 0;
> > +	else
> > +		supported_xss = host_xss & KVM_SUPPORTED_XSS;
> 
> Silly nit: I'd prefer to invert the check, e.g.
> 
> 	if (kvm_cpu_cap_has(X86_FEATURE_XSAVES))
> 		supported_xss = host_xss & KVM_SUPPORTED_XSS;
> 	else
> 		supported_xss = 0;
Fair enough!
> 
> >  
> >  	cr4_reserved_bits = kvm_host_cr4_reserved_bits(&boot_cpu_data);
> >  
> > -- 
> > 2.17.2
> > 
