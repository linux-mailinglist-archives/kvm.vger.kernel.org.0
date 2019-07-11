Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A74F65873
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 16:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfGKOGC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 10:06:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:61819 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbfGKOGB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 10:06:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 07:05:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,478,1557212400"; 
   d="scan'208";a="193411363"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga002.fm.intel.com with ESMTP; 11 Jul 2019 07:05:53 -0700
Date:   Thu, 11 Jul 2019 07:05:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <zhexu@redhat.com>
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Luiz Capitulino <lcapitulino@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] tscdeadline_latency: Check condition
 first before loop
Message-ID: <20190711140553.GB7645@linux.intel.com>
References: <20190711071756.2784-1-peterx@redhat.com>
 <20190711073335.GC7847@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711073335.GC7847@xz-x1>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 11, 2019 at 03:33:35PM +0800, Peter Xu wrote:
> On Thu, Jul 11, 2019 at 03:17:56PM +0800, Peter Xu wrote:
> > This patch fixes a tscdeadline_latency hang when specifying a very
> > small breakmax value.  It's easily reproduced on my host with
> > parameters like "200000 10000 10" (set breakmax to 10 TSC clocks).
> > 
> > The problem is test_tsc_deadline_timer() can be very slow because
> > we've got printf() in there.  So when reach the main loop we might
> > have already triggered the IRQ handler for multiple times and we might
> > have triggered the hitmax condition which will turn IRQ off.  Then
> > with no IRQ that first HLT instruction can last forever.
> > 
> > Fix this by simply checking the condition first in the loop.
> > 
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  x86/tscdeadline_latency.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/x86/tscdeadline_latency.c b/x86/tscdeadline_latency.c
> > index 0617a1b..4ee5917 100644
> > --- a/x86/tscdeadline_latency.c
> > +++ b/x86/tscdeadline_latency.c
> > @@ -118,9 +118,9 @@ int main(int argc, char **argv)
> >      test_tsc_deadline_timer();
> >      irq_enable();
> >  
> > -    do {
> > +    /* The condition might have triggered already, so check before HLT. */
> > +    while (!hitmax && table_idx < size)
> 
> Hmm... I think this is not ideal too in that variables (e.g., hitmax)
> could logically still change between the condition check and HLT below
> (though this patch already runs nicely here).  Maybe we can simply use
> "nop" or "pause" instead of "hlt".
> 
> I tested that using pause fixes the problem too.

Ensuring the first hlt lands in an interrupt shadow should prevent getting
into a halted state after the timer has been disabled, e.g.:

    irq_disable();
    test_tsc_deadline_timer();

    do {
        safe_halt();
    } while (!hitmax && table_idx < size);

> 
> >          asm volatile("hlt");
> > -    } while (!hitmax && table_idx < size);
> >  
> >      for (i = 0; i < table_idx; i++) {
> >          if (hitmax && i == table_idx-1)
> > -- 
> > 2.21.0
> > 
> 
> Regards,
> 
> -- 
> Peter Xu
