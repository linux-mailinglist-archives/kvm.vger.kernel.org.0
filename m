Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AD5A79EAC
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 04:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbfG3C2p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 22:28:45 -0400
Received: from mga03.intel.com ([134.134.136.65]:13410 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731194AbfG3C2p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 22:28:45 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 19:28:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,325,1559545200"; 
   d="scan'208";a="165683404"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 29 Jul 2019 19:28:44 -0700
Date:   Mon, 29 Jul 2019 19:28:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Peter Xu <zhexu@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190730022844.GK21120@linux.intel.com>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-4-peterx@redhat.com>
 <20190729162338.GE21120@linux.intel.com>
 <20190730014339.GC19232@xz-x1>
 <20190730020607.GJ21120@linux.intel.com>
 <20190730021245.GE19232@xz-x1>
 <20190730022525.GF19232@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730022525.GF19232@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 30, 2019 at 10:25:25AM +0800, Peter Xu wrote:
> On Tue, Jul 30, 2019 at 10:12:45AM +0800, Peter Xu wrote:
> > On Mon, Jul 29, 2019 at 07:06:07PM -0700, Sean Christopherson wrote:
> > > > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > > > index d98eac371c0a..cc1f98130e6a 100644
> > > > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > > > @@ -5214,7 +5214,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
> > > > > >  	if (vmx->ple_window != old)
> > > > > >  		vmx->ple_window_dirty = true;
> > > > > >  
> > > > > > -	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
> > > > > > +	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);
> > > > > 
> > > > > No need for the macro, the snippet right about already checks 'new != old'.
> > > > > Though I do like the rename, i.e. rename the trace function to
> > > > > trace_kvm_ple_window_changed().
> > > > 
> > > > Do you mean this one?
> > > > 
> > > > 	if (vmx->ple_window != old)
> > > > 		vmx->ple_window_dirty = true;
> > > 
> > > Yep.
> > > 
> > > > It didn't return, did it? :)
> > > 
> > > You lost me.  What's wrong with:
> > > 
> > > 	if (vmx->ple_window != old) {
> > > 		vmx->ple_window_dirty = true;
> > > 		trace_kvm_ple_window_update(vcpu->vcpu_id, vmx_ple->window, old);
> > > 	}
> > 
> > Yes this looks fine to me.  I'll switch.
> 
> Btw, I noticed we have this:
> 
>   EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_ple_window);
> 
> Is that trying to expose the tracepoints to the outter world?  Is that
> whole chunk of EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_*) really needed?

It's needed to invoke tracepoints from VMX/SVM as the implementations live
in kvm.ko.  Same reason functions in x86.c and company need to be exported
if they're called by VMX/SVM code.
