Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DC9242E6E
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 20:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgHLSKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Aug 2020 14:10:46 -0400
Received: from mga18.intel.com ([134.134.136.126]:27523 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgHLSKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Aug 2020 14:10:44 -0400
IronPort-SDR: e7GrA8nnDos/9oVKkdc4CR9S2PwJxeeFIiAA6+OgvoXR9v/unp6Fh15ObYYix8VHpPqkRWkrhg
 RK+pqhyWsZsw==
X-IronPort-AV: E=McAfee;i="6000,8403,9711"; a="141662149"
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="141662149"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 11:10:43 -0700
IronPort-SDR: 9CdmcRa1CII4ZcRJgunFyc1x+Aso+Cleiye+QJuKz0Suu0DXE6eS5ZcqE/rQO673V3YXpYsvUX
 IdPiHkgvjCEQ==
X-IronPort-AV: E=Sophos;i="5.76,305,1592895600"; 
   d="scan'208";a="332881602"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.160])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2020 11:10:42 -0700
Date:   Wed, 12 Aug 2020 11:10:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/7] KVM: x86: Use common definition for
 kvm_nested_vmexit tracepoint
Message-ID: <20200812181041.GC6602@linux.intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com>
 <20200718063854.16017-7-sean.j.christopherson@intel.com>
 <87365mqgcg.fsf@vitty.brq.redhat.com>
 <20200721002717.GC20375@linux.intel.com>
 <87imehotp1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imehotp1.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 03:59:06PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Mon, Jul 20, 2020 at 06:52:15PM +0200, Vitaly Kuznetsov wrote:
> >> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> >> > +TRACE_EVENT_KVM_EXIT(kvm_nested_vmexit);
> >> >  
> >> >  /*
> >> >   * Tracepoint for #VMEXIT reinjected to the guest
> >> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >> > index fc70644b916ca..f437d99f4db09 100644
> >> > --- a/arch/x86/kvm/vmx/nested.c
> >> > +++ b/arch/x86/kvm/vmx/nested.c
> >> > @@ -5912,10 +5912,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
> >> >  	exit_intr_info = vmx_get_intr_info(vcpu);
> >> >  	exit_qual = vmx_get_exit_qual(vcpu);
> >> >  
> >> > -	trace_kvm_nested_vmexit(vcpu, exit_reason, exit_qual,
> >> > -				vmx->idt_vectoring_info, exit_intr_info,
> >> > -				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
> >> > -				KVM_ISA_VMX);
> >> > +	trace_kvm_nested_vmexit(exit_reason, vcpu, KVM_ISA_VMX);
> >> >  
> >> >  	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
> >> >  	if (nested_vmx_l0_wants_exit(vcpu, exit_reason))
> >> 
> >> With so many lines removed I'm almost in love with the patch! However,
> >> when testing on SVM (unrelated?) my trace log looks a bit ugly:
> >> 
> >>            <...>-315119 [010]  3733.092646: kvm_nested_vmexit:    CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason npf rip 0x400433 info1 0x0000000200000006 info2 0x0000000000641000 intr_info 0x00000000 error_code 0x00000000
> >>            <...>-315119 [010]  3733.092655: kvm_nested_vmexit:    CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason npf rip 0x400433 info1 0x0000000100000014 info2 0x0000000000400000 intr_info 0x00000000 error_code 0x00000000
> >> 
> >> ...
> >> 
> >> but after staring at this for some time I still don't see where this
> >> comes from :-( ... but reverting this commit helps:
> >
> > The CAN'T FIND FIELD blurb comes from tools/lib/traceevent/event-parse.c.
> >
> > I assume you are using tooling of some form to generate the trace, i.e. the
> > issue doesn't show up in /sys/kernel/debug/tracing/trace.  If that's the
> > case, this is more or less ABI breakage :-(
> >  
> 
> Right you are,
> 
> the tool is called 'trace-cmd record -e kvm ...' / 'trace-cmd report'

Paolo, any thoughts on how to proceed with this series?  E.g. merge KVM
first and fix trace-cmd second?  Something else?
