Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37402C241F
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2019 17:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731921AbfI3PTq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Sep 2019 11:19:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:6202 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730809AbfI3PTq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Sep 2019 11:19:46 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Sep 2019 08:19:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,567,1559545200"; 
   d="scan'208";a="195352698"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 30 Sep 2019 08:19:45 -0700
Date:   Mon, 30 Sep 2019 08:19:45 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
Subject: Re: [PATCH v2 4/8] KVM: VMX: Optimize vmx_set_rflags() for
 unrestricted guest
Message-ID: <20190930151945.GB14693@linux.intel.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <20190927214523.3376-5-sean.j.christopherson@intel.com>
 <87muem40wi.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87muem40wi.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 30, 2019 at 10:57:17AM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > Rework vmx_set_rflags() to avoid the extra code need to handle emulation
> > of real mode and invalid state when unrestricted guest is disabled.  The
> > primary reason for doing so is to avoid the call to vmx_get_rflags(),
> > which will incur a VMREAD when RFLAGS is not already available.  When
> > running nested VMs, the majority of calls to vmx_set_rflags() will occur
> > without an associated vmx_get_rflags(), i.e. when stuffing GUEST_RFLAGS
> > during transitions between vmcs01 and vmcs02.
> >
> > Note, vmx_get_rflags() guarantees RFLAGS is marked available.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 28 ++++++++++++++++++----------
> >  1 file changed, 18 insertions(+), 10 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 83fe8b02b732..814d3e6d0264 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -1426,18 +1426,26 @@ unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
> >  void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
> >  {
> >  	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > -	unsigned long old_rflags = vmx_get_rflags(vcpu);
> > +	unsigned long old_rflags;
> >  
> > -	__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
> > -	vmx->rflags = rflags;
> > -	if (vmx->rmode.vm86_active) {
> > -		vmx->rmode.save_rflags = rflags;
> > -		rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
> > +	if (enable_unrestricted_guest) {
> > +		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
> > +
> > +		vmx->rflags = rflags;
> > +		vmcs_writel(GUEST_RFLAGS, rflags);
> > +	} else {
> > +		old_rflags = vmx_get_rflags(vcpu);
> > +
> > +		vmx->rflags = rflags;
> > +		if (vmx->rmode.vm86_active) {
> > +			vmx->rmode.save_rflags = rflags;
> > +			rflags |= X86_EFLAGS_IOPL | X86_EFLAGS_VM;
> > +		}
> > +		vmcs_writel(GUEST_RFLAGS, rflags);
> > +
> > +		if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
> > +			vmx->emulation_required = emulation_required(vcpu);
> >  	}
> > -	vmcs_writel(GUEST_RFLAGS, rflags);
> 
> We're doing vmcs_writel() in both branches so it could've stayed here, right?

Yes, but the resulting code is a bit ugly.  emulation_required() consumes
vmcs.GUEST_RFLAGS, i.e. the if statement that reads old_rflags would also
need to be outside of the else{} case.  

This isn't too bad:

	if (!enable_unrestricted_guest && 
	    ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM))
		vmx->emulation_required = emulation_required(vcpu);

but gcc isn't smart enough to understand old_rflags won't be used if
enable_unrestricted_guest, so old_rflags either needs to be tagged with
uninitialized_var() or explicitly initialized in the if(){} case.

Duplicating a small amount of code felt like the lesser of two evils.

> > -
> > -	if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
> > -		vmx->emulation_required = emulation_required(vcpu);
> >  }
> >  
> >  u32 vmx_get_interrupt_shadow(struct kvm_vcpu *vcpu)
> 
> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> -- 
> Vitaly
