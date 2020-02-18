Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F63B1635FF
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 23:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgBRWVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 17:21:10 -0500
Received: from mga04.intel.com ([192.55.52.120]:34226 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726659AbgBRWVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 17:21:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Feb 2020 14:21:09 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,458,1574150400"; 
   d="scan'208";a="224290608"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 18 Feb 2020 14:21:08 -0800
Date:   Tue, 18 Feb 2020 14:21:08 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Suppress warning in __kvm_gfn_to_hva_cache_init
Message-ID: <20200218222108.GK28156@linux.intel.com>
References: <20200218184756.242904-1-oupton@google.com>
 <20200218190729.GD28156@linux.intel.com>
 <20200218213433.GA164161@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218213433.GA164161@google.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 18, 2020 at 01:34:33PM -0800, Oliver Upton wrote:
> Hey Sean,
> 
> On Tue, Feb 18, 2020 at 11:07:29AM -0800, Sean Christopherson wrote:
> > On Tue, Feb 18, 2020 at 10:47:56AM -0800, Oliver Upton wrote:
> > > Particularly draconian compilers warn of a possible uninitialized use of
> > > the nr_pages_avail variable. Silence this warning by initializing it to
> > > zero.
> > 
> > Can you check if the warning still exists with commit 6ad1e29fe0ab ("KVM:
> > Clean up __kvm_gfn_to_hva_cache_init() and its callers")?  I'm guessing
> > (hoping?) the suppression is no longer necessary.
> 
> Hmm. I rebased this patch right before sending out + it seems that it is
> required (at least for me) to silence the compiler warning. For good
> measure, I ran git branch --contains to ensure I had your change. Looks
> like my topic branch did in fact have your fix.

Bummer.  By "particularly draconian compilers", do you mean "clang"?  Not
that it really matters, but it'd explain why no one else is complaining.

Anyways, comment on the code below... 

> --
> Oliver
> 
> > commit 6ad1e29fe0aba843dfffc714fced0ef6a2e19502
> > Author: Sean Christopherson <sean.j.christopherson@intel.com>
> > Date:   Thu Jan 9 14:58:55 2020 -0500
> > 
> >     KVM: Clean up __kvm_gfn_to_hva_cache_init() and its callers
> > 
> >     Barret reported a (technically benign) bug where nr_pages_avail can be
> >     accessed without being initialized if gfn_to_hva_many() fails.
> > 
> >       virt/kvm/kvm_main.c:2193:13: warning: 'nr_pages_avail' may be
> >       used uninitialized in this function [-Wmaybe-uninitialized]
> > 
> >     Rather than simply squashing the warning by initializing nr_pages_avail,
> >     fix the underlying issues by reworking __kvm_gfn_to_hva_cache_init() to
> >     return immediately instead of continuing on.  Now that all callers check
> >     the result and/or bail immediately on a bad hva, there's no need to
> >     explicitly nullify the memslot on error.
> > 
> >     Reported-by: Barret Rhoden <brho@google.com>
> >     Fixes: f1b9dd5eb86c ("kvm: Disallow wraparound in kvm_gfn_to_hva_cache_init")
> >     Cc: Jim Mattson <jmattson@google.com>
> >     Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> >     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > 
> > 
> > > Signed-off-by: Oliver Upton <oupton@google.com>
> > > ---
> > >  virt/kvm/kvm_main.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 70f03ce0e5c1..dc8a67ad082d 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -2219,7 +2219,7 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
> > >  	gfn_t start_gfn = gpa >> PAGE_SHIFT;
> > >  	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
> > >  	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
> > > -	gfn_t nr_pages_avail;
> > > +	gfn_t nr_pages_avail = 0;

Since the warning is technically bogus, uninitialized_var() can be used,
which will hopefully make it more obvious (well, less misleading), that the
loop's post-condition isn't broken.

	gfn uninitialized_var(nr_pages_avail);

> > >  
> > >  	/* Update ghc->generation before performing any error checks. */
> > >  	ghc->generation = slots->generation;
> > > -- 
> > > 2.25.0.265.gbab2e86ba0-goog
> > > 
