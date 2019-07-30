Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E108279E73
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2019 04:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730005AbfG3CGI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 22:06:08 -0400
Received: from mga17.intel.com ([192.55.52.151]:52110 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727539AbfG3CGI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 22:06:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Jul 2019 19:06:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,325,1559545200"; 
   d="scan'208";a="176630927"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 29 Jul 2019 19:06:07 -0700
Date:   Mon, 29 Jul 2019 19:06:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <zhexu@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 3/3] KVM: X86: Tune PLE Window tracepoint
Message-ID: <20190730020607.GJ21120@linux.intel.com>
References: <20190729053243.9224-1-peterx@redhat.com>
 <20190729053243.9224-4-peterx@redhat.com>
 <20190729162338.GE21120@linux.intel.com>
 <20190730014339.GC19232@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730014339.GC19232@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 30, 2019 at 09:43:39AM +0800, Peter Xu wrote:
> On Mon, Jul 29, 2019 at 09:23:38AM -0700, Sean Christopherson wrote:
> > On Mon, Jul 29, 2019 at 01:32:43PM +0800, Peter Xu wrote:
> > > The PLE window tracepoint triggers easily and it can be a bit
> > > confusing too.  One example line:
> > > 
> > >   kvm_ple_window: vcpu 0: ple_window 4096 (shrink 4096)
> > > 
> > > It easily let people think of "the window now is 4096 which is
> > > shrinked", but the truth is the value actually didn't change (4096).
> > > 
> > > Let's only dump this message if the value really changed, and we make
> > > the message even simpler like:
> > > 
> > >   kvm_ple_window: vcpu 4 (4096 -> 8192)
> > 
> > This seems a bit too terse, e.g. requires a decent amount of effort to
> > do relatively simple things like show only cases where the windows was
> > shrunk, or grew/shrunk by a large amount.  In this case, more is likely
> > better, e.g.: 
> > 
> >   kvm_ple_window_changed: vcpu 4 ple_window 8192 old 4096 grow 4096
> > 
> > and
> > 
> >   kvm_ple_window_changed: vcpu 4 ple_window 4096 old 8192 shrink 4096
> 
> How about:
> 
>    kvm_ple_window: vcpu 4 (4096 -> 8192, growed)
> 
> Or:
> 
>    kvm_ple_window: vcpu 4 old 4096 new 8192 growed
> 
> I would prefer the arrow which is very clear to me to show a value
> change, but I'd be fine to see what's your final preference or any
> further reviewers.  Anyway I think any of them is clearer than the
> original version...

For tracepoints, I prefer to err on the side of more info as it's easy to
filter out unwanted date.  But odds are I'll never use this particular
tracepoint, so I'll defer to folks who are actually affected.

> > 
> > 
> > Tangentially related, it'd be nice to settle on a standard format for
> > printing field+val.  Right now there are four different styles, e.g.
> > "field=val", "field = val", "field: val" and "field val".
> 
> Right, I ses "field val" is used most frequently.  But I didn't touch
> those up because they haven't yet caused any confusion to me.

Ya, it was more of a general complaint :-)

> [...]
> 
> > >  	TP_STRUCT__entry(
> > > -		__field(                bool,      grow         )
> > 
> > Side note, if the tracepoint is invoked only on changes the "grow" field
> > can be removed even if the tracepoint prints grow vs. shrink, i.e. there's
> > no ambiguity since new==old will never happen.
> 
> But I do see it happen...  Please see below.

...

> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index d98eac371c0a..cc1f98130e6a 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -5214,7 +5214,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
> > >  	if (vmx->ple_window != old)
> > >  		vmx->ple_window_dirty = true;
> > >  
> > > -	trace_kvm_ple_window_grow(vcpu->vcpu_id, vmx->ple_window, old);
> > > +	trace_kvm_ple_window_changed(vcpu->vcpu_id, vmx->ple_window, old);
> > 
> > No need for the macro, the snippet right about already checks 'new != old'.
> > Though I do like the rename, i.e. rename the trace function to
> > trace_kvm_ple_window_changed().
> 
> Do you mean this one?
> 
> 	if (vmx->ple_window != old)
> 		vmx->ple_window_dirty = true;

Yep.

> It didn't return, did it? :)

You lost me.  What's wrong with:

	if (vmx->ple_window != old) {
		vmx->ple_window_dirty = true;
		trace_kvm_ple_window_update(vcpu->vcpu_id, vmx_ple->window, old);
	}
