Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDC915129E
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2020 00:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgBCXA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 18:00:27 -0500
Received: from mga18.intel.com ([134.134.136.126]:3227 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgBCXA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 18:00:27 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 15:00:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="231177450"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga003.jf.intel.com with ESMTP; 03 Feb 2020 15:00:26 -0800
Date:   Mon, 3 Feb 2020 15:00:26 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH v2 2/5] KVM: nVMX: Handle pending #DB when injecting INIT
 VM-exit
Message-ID: <20200203230026.GA27485@linux.intel.com>
References: <20200128092715.69429-1-oupton@google.com>
 <20200128092715.69429-3-oupton@google.com>
 <20200203191330.GB19638@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203191330.GB19638@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 03, 2020 at 11:13:30AM -0800, Sean Christopherson wrote:
> On Tue, Jan 28, 2020 at 01:27:12AM -0800, Oliver Upton wrote:
> > SDM 27.3.4 states that the 'pending debug exceptions' VMCS field will
> > be populated if a VM-exit caused by an INIT signal takes priority over a
> > debug-trap. Emulate this behavior when synthesizing an INIT signal
> > VM-exit into L1.
> > 
> > Fixes: 558b8d50dbff ("KVM: x86: Fix INIT signal handling in various CPU states")
> > Signed-off-by: Oliver Upton <oupton@google.com>
> > ---
> >  arch/x86/kvm/vmx/nested.c | 23 +++++++++++++++++++++++
> >  1 file changed, 23 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> > index 95b3f4306ac2..aba16599ca69 100644
> > --- a/arch/x86/kvm/vmx/nested.c
> > +++ b/arch/x86/kvm/vmx/nested.c
> > @@ -3572,6 +3572,27 @@ static void nested_vmx_inject_exception_vmexit(struct kvm_vcpu *vcpu,
> >  	nested_vmx_vmexit(vcpu, EXIT_REASON_EXCEPTION_NMI, intr_info, exit_qual);
> >  }
> >  
> > +static inline bool nested_vmx_check_pending_dbg(struct kvm_vcpu *vcpu)
> 
> Really dislike the name, partially because the code checks @has_payload and
> partially because the part, nested_vmx_set_pending_dbg() "sets" completely
> different state than this checks.
> 
> Checking has_payload may also be wrong, e.g. wouldn't it make sense to
> update GUEST_PENDING_DBG_EXCEPTIONS, even if we crush it with '0'?
> 
> > +{
> > +	return vcpu->arch.exception.nr == DB_VECTOR &&
> > +			vcpu->arch.exception.pending &&
> > +			vcpu->arch.exception.has_payload;
> > +}
> > +
> > +/*
> > + * If a higher priority VM-exit is delivered before a debug-trap, hardware will
> > + * set the 'pending debug exceptions' field appropriately for reinjection on the
> > + * next VM-entry.
> > + */
> > +static void nested_vmx_set_pending_dbg(struct kvm_vcpu *vcpu)
> > +{
> > +	vmcs_writel(GUEST_PENDING_DBG_EXCEPTIONS, vcpu->arch.exception.payload);
> > +	vcpu->arch.exception.has_payload = false;
> > +	vcpu->arch.exception.payload = 0;
> > +	vcpu->arch.exception.pending = false;
> > +	vcpu->arch.exception.injected = true;
> 
> This looks wrong.  The #DB hasn't been injected, KVM is simply emulating
> the side effect of the VMCS field being updated.  E.g. KVM will have
> different architecturally visible behavior depending on @has_payload.

My head is spinning trying to work through the #DB/MTF interactions.  I
think this ends up being a moot point because prepare_vmcs12() will purge
the pending exceptions.  If it is a moot point, then I'd prefer to not do
the explicit arch.exception updates so as to keep this similar to other
exceptions.
