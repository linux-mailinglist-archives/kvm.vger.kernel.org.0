Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26E5E2273C4
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 02:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgGUA1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jul 2020 20:27:18 -0400
Received: from mga14.intel.com ([192.55.52.115]:57470 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgGUA1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jul 2020 20:27:18 -0400
IronPort-SDR: f/k+W2uA+/eVtrqOtHBHkLzyBIumr4KfXOl4MxW48qKcrrOYJXzXuz7bjldrkilvPKPdm61kTZ
 cF/7rGrpWw1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9688"; a="149192453"
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="149192453"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jul 2020 17:27:17 -0700
IronPort-SDR: KU67nvGdIM567sW9az7dY8E4HkdiF19stJkvANlzratzIpWpnnjpYzW7S4UBW/HnqoosC1N+H7
 HwsPgq+H0Ovg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="487425517"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 20 Jul 2020 17:27:17 -0700
Date:   Mon, 20 Jul 2020 17:27:17 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/7] KVM: x86: Use common definition for
 kvm_nested_vmexit tracepoint
Message-ID: <20200721002717.GC20375@linux.intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com>
 <20200718063854.16017-7-sean.j.christopherson@intel.com>
 <87365mqgcg.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87365mqgcg.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 20, 2020 at 06:52:15PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> > +TRACE_EVENT_KVM_EXIT(kvm_nested_vmexit);
> >  
> >  /*
> >   * Tracepoint for #VMEXIT reinjected to the guest
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index fc70644b916ca..f437d99f4db09 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -5912,10 +5912,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
> >  	exit_intr_info = vmx_get_intr_info(vcpu);
> >  	exit_qual = vmx_get_exit_qual(vcpu);
> >  
> > -	trace_kvm_nested_vmexit(vcpu, exit_reason, exit_qual,
> > -				vmx->idt_vectoring_info, exit_intr_info,
> > -				vmcs_read32(VM_EXIT_INTR_ERROR_CODE),
> > -				KVM_ISA_VMX);
> > +	trace_kvm_nested_vmexit(exit_reason, vcpu, KVM_ISA_VMX);
> >  
> >  	/* If L0 (KVM) wants the exit, it trumps L1's desires. */
> >  	if (nested_vmx_l0_wants_exit(vcpu, exit_reason))
> 
> With so many lines removed I'm almost in love with the patch! However,
> when testing on SVM (unrelated?) my trace log looks a bit ugly:
> 
>            <...>-315119 [010]  3733.092646: kvm_nested_vmexit:    CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason npf rip 0x400433 info1 0x0000000200000006 info2 0x0000000000641000 intr_info 0x00000000 error_code 0x00000000
>            <...>-315119 [010]  3733.092655: kvm_nested_vmexit:    CAN'T FIND FIELD "rip"<CANT FIND FIELD exit_code>vcpu 0 reason npf rip 0x400433 info1 0x0000000100000014 info2 0x0000000000400000 intr_info 0x00000000 error_code 0x00000000
> 
> ...
> 
> but after staring at this for some time I still don't see where this
> comes from :-( ... but reverting this commit helps:

The CAN'T FIND FIELD blurb comes from tools/lib/traceevent/event-parse.c.

I assume you are using tooling of some form to generate the trace, i.e. the
issue doesn't show up in /sys/kernel/debug/tracing/trace.  If that's the
case, this is more or less ABI breakage :-(
 
>  qemu-system-x86-9928  [022]   379.260656: kvm_nested_vmexit:    rip 400433 reason EXIT_NPF info1 200000006 info2 641000 int_info 0 int_info_err 0
>  qemu-system-x86-9928  [022]   379.260666: kvm_nested_vmexit:    rip 400433 reason EXIT_NPF info1 100000014 info2 400000 int_info 0 int_info_err 0
> 
> -- 
> Vitaly
> 
