Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFE66BBEC1
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 01:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407812AbfIWXG1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 19:06:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403884AbfIWXG1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 19:06:27 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 305B110DCC87;
        Mon, 23 Sep 2019 23:06:27 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F107910013A1;
        Mon, 23 Sep 2019 23:06:26 +0000 (UTC)
Date:   Mon, 23 Sep 2019 19:06:26 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/17] KVM: monolithic: x86: handle the
 request_immediate_exit variation
Message-ID: <20190923230626.GF19996@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-4-aarcange@redhat.com>
 <20190923223526.GQ18195@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923223526.GQ18195@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Mon, 23 Sep 2019 23:06:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 03:35:26PM -0700, Sean Christopherson wrote:
> On Fri, Sep 20, 2019 at 05:24:55PM -0400, Andrea Arcangeli wrote:
> > request_immediate_exit is one of those few cases where the pointer to
> > function of the method isn't fixed at build time and it requires
> > special handling because hardware_setup() may override it at runtime.
> > 
> > Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx_ops.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx_ops.c b/arch/x86/kvm/vmx/vmx_ops.c
> > index cdcad73935d9..25d441432901 100644
> > --- a/arch/x86/kvm/vmx/vmx_ops.c
> > +++ b/arch/x86/kvm/vmx/vmx_ops.c
> > @@ -498,7 +498,10 @@ int kvm_x86_ops_check_nested_events(struct kvm_vcpu *vcpu, bool external_intr)
> >  
> >  void kvm_x86_ops_request_immediate_exit(struct kvm_vcpu *vcpu)
> >  {
> > -	vmx_request_immediate_exit(vcpu);
> > +	if (likely(enable_preemption_timer))
> > +		vmx_request_immediate_exit(vcpu);
> > +	else
> > +		__kvm_request_immediate_exit(vcpu);
> 
> Rather than wrap this in VMX code, what if we instead take advantage of a
> monolithic module and add an inline to query enable_preemption_timer?
> That'd likely save a few CALL/RET/JMP instructions and eliminate
> __kvm_request_immediate_exit.
> 
> E.g. something like:
> 
> 	if (req_immediate_exit) {
> 		kvm_make_request(KVM_REQ_EVENT, vcpu);
> 		if (kvm_x86_has_request_immediate_exit())
> 			kvm_x86_request_immediate_exit(vcpu);
> 		else
> 			smp_send_reschedule(vcpu->cpu);
> 	}

Yes, I mentioned the inlining possibilities in part of comment of
2/17:

===
Further incremental minor optimizations that weren't possible before
are now enabled by the monolithic model. For example it would be
possible later to convert some of the small external methods to inline
functions from the {svm,vmx}_ops.c file to kvm_ops.h. However that
will require more Makefile tweaks.
===

To implement your kvm_x86_has_request_immediate_exit() we need more
Makefile tweaking, basically we need a -D__SVM__ -D__VMX__ kind of
thing so we can put an #ifdef __SVM__ in the kvm_ops.h equivalent to
put inline code there. Or some other better solution if you think of
any, that was my only idea so far with regard to inlining.

If you can sort out the solution to enable the inlining of svm/vmx
code that would be great.

However I think all optimizations allowed by the monolithic model that
aren't related to the full retpoline overhead removal, should be kept
incremental.

I rather prefer to keep the inner working of the kvm_x86_ops to be
100% functional equivalent in the initial conversion, so things
remains also more bisectable just in case and to keep the
optimizations incremental.

In addition to the inline optimization there is the cleanup of the
kvm_x86_ops that is lots of work left to do. To do that it requires a
lot of changes to every place that checks the kvm_x86_ops->something
pointer or that isn't initialized statically. I didn't even try to
implement that part because I wanted to get to a point that was fully
equivalent for easier review and fewer risk of breakage. So I sent the
patchset at the point when there were zero reptolines left running in
the KVM code, but more work is required to fully leverage the
monolithic approach and eliminate the now mostly dead code of
kvm_x86_ops structure.

I would rather prioritize on the changes required to the full removal
of kvm_x86_ops before further inline optimizations, but it would be
fine to do inline optimizations first as long as they're not mixed up
with an initial simpler conversion to monolithic model.

Thanks,
Andrea
