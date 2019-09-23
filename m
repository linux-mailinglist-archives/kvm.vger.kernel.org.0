Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B992BBF0C
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 01:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408386AbfIWXpC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 19:45:02 -0400
Received: from mga04.intel.com ([192.55.52.120]:15863 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391461AbfIWXpC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 19:45:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Sep 2019 16:45:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,542,1559545200"; 
   d="scan'208";a="190834460"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 23 Sep 2019 16:45:01 -0700
Date:   Mon, 23 Sep 2019 16:45:00 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] KVM: monolithic: x86: handle the
 request_immediate_exit variation
Message-ID: <20190923234500.GR18195@linux.intel.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-4-aarcange@redhat.com>
 <20190923223526.GQ18195@linux.intel.com>
 <20190923230626.GF19996@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923230626.GF19996@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 07:06:26PM -0400, Andrea Arcangeli wrote:
> On Mon, Sep 23, 2019 at 03:35:26PM -0700, Sean Christopherson wrote:
> > On Fri, Sep 20, 2019 at 05:24:55PM -0400, Andrea Arcangeli wrote:
> > > request_immediate_exit is one of those few cases where the pointer to
> > > function of the method isn't fixed at build time and it requires
> > > special handling because hardware_setup() may override it at runtime.
> > > 
> > > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > > ---
> > >  arch/x86/kvm/vmx/vmx_ops.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx_ops.c b/arch/x86/kvm/vmx/vmx_ops.c
> > > index cdcad73935d9..25d441432901 100644
> > > --- a/arch/x86/kvm/vmx/vmx_ops.c
> > > +++ b/arch/x86/kvm/vmx/vmx_ops.c
> > > @@ -498,7 +498,10 @@ int kvm_x86_ops_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
> > >  
> > >  void kvm_x86_ops_request_immediate_exit(struct kvm_vcpu *vcpu)
> > >  {
> > > -	vmx_request_immediate_exit(vcpu);
> > > +	if (likely(enable_preemption_timer))
> > > +		vmx_request_immediate_exit(vcpu);
> > > +	else
> > > +		__kvm_request_immediate_exit(vcpu);
> > 
> > Rather than wrap this in VMX code, what if we instead take advantage of a
> > monolithic module and add an inline to query enable_preemption_timer?
> > That'd likely save a few CALL/RET/JMP instructions and eliminate
> > __kvm_request_immediate_exit.
> > 
> > E.g. something like:
> > 
> > 	if (req_immediate_exit) {
> > 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> > 		if (kvm_x86_has_request_immediate_exit())
> > 			kvm_x86_request_immediate_exit(vcpu);
> > 		else
> > 			smp_send_reschedule(vcpu->cpu);
> > 	}
> 
> Yes, I mentioned the inlining possibilities in part of comment of
> 2/17:
> 
> ===
> Further incremental minor optimizations that weren't possible before
> are now enabled by the monolithic model. For example it would be
> possible later to convert some of the small external methods to inline
> functions from the {svm,vmx}_ops.c file to kvm_ops.h. However that
> will require more Makefile tweaks.
> ===

With a straight rename to kvm_x86_<function>() instead of wrappers, we
shouldn't need kvm_ops.c.  kvm_ops.h might be helpful, but it'd be just
as easy to keep them in kvm_host.h and would likely yield a more
insightful diff[*].

> To implement your kvm_x86_has_request_immediate_exit() we need more
> Makefile tweaking, basically we need a -D__SVM__ -D__VMX__ kind of
> thing so we can put an #ifdef __SVM__ in the kvm_ops.h equivalent to
> put inline code there. Or some other better solution if you think of
> any, that was my only idea so far with regard to inlining.

Hmm, I was thinking more along the lines of extending the kvm_host.h
pattern down into vendor specific code, e.g. arch/x86/kvm/vmx/kvm_host.h.
Probably with a different name though, two of those is confusing enough.

It'd still need Makefile changes, but we wouldn't litter the code with
#ifdefs.  Future enhancments can also take advantage of the per-vendor
header to inline other things.  Such a header would also make it possible
to fully remove kvm_x86_ops in this series (I think).

[*] Tying into the thought above, if we go for a straight rename and
    eliminate the conditionally-implemented kvm_x86_ops ahead of time,
    e.g. with inlines that return -EINVAL or something, then the
    conversion to direct calls can be a straight replacement of
    "kvm_x86_ops->" with "kvm_x86_" at the same time the declarations
    are changed from members of kvm_x86_ops to externs.

Actually, typing out the above made me realize the immediate exit code
can be:

	if (req_immediate_exit) {
		kvm_make_request(KVM_REQ_EVENT, vcpu);
		if (kvm_x86_request_immediate_exit(vcpu))
			smp_send_reschedule(vcpu->cpu);
	}

Where kvm_x86_request_immediate_exit() returns 0 on success, e.g. the SVM
implementation can be "return -EINVAL" or whatever is appropriate, which
I assume the compiler can optimize out.  Or maybe a boolean return is
better in this case?
