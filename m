Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DD9154700
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 16:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727443AbgBFPFY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 10:05:24 -0500
Received: from mga06.intel.com ([134.134.136.31]:60363 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727279AbgBFPFX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 10:05:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 07:05:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="220465002"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga007.jf.intel.com with ESMTP; 06 Feb 2020 07:05:23 -0800
Date:   Thu, 6 Feb 2020 07:05:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     linmiaohe <linmiaohe@huawei.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com,
        rkrcmar@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: apic: reuse smp_wmb() in kvm_make_request()
Message-ID: <20200206150523.GA13067@linux.intel.com>
References: <1580954375-5030-1-git-send-email-linmiaohe@huawei.com>
 <87d0asgfh5.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d0asgfh5.fsf@vitty.brq.redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 06, 2020 at 11:47:02AM +0100, Vitaly Kuznetsov wrote:
> linmiaohe <linmiaohe@huawei.com> writes:
> 
> > From: Miaohe Lin <linmiaohe@huawei.com>
> >
> > There is already an smp_mb() barrier in kvm_make_request(). We reuse it
> > here.
> >
> > Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> > ---
> >  arch/x86/kvm/lapic.c | 9 ++++++---
> >  1 file changed, 6 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> > index eafc631d305c..ea871206a370 100644
> > --- a/arch/x86/kvm/lapic.c
> > +++ b/arch/x86/kvm/lapic.c
> > @@ -1080,9 +1080,12 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
> >  			result = 1;
> >  			/* assumes that there are only KVM_APIC_INIT/SIPI */
> >  			apic->pending_events = (1UL << KVM_APIC_INIT);
> > -			/* make sure pending_events is visible before sending
> > -			 * the request */
> > -			smp_wmb();
> > +			/*
> > +			 * Make sure pending_events is visible before sending
> > +			 * the request.
> > +			 * There is already an smp_wmb() in kvm_make_request(),
> > +			 * we reuse that barrier here.
> > +			 */
> 
> Let me suggest an alternative wording,
> 
> "kvm_make_request() provides smp_wmb() so pending_events changes are
> guaranteed to be visible"
> 
> But there is nothing wrong with yours, it's just longer than it could be
> :-)

I usually lean in favor of more comments, but in thise case I'd vote to
drop the comment altogether.  There are lots of places that rely on the
smp_wmb() in kvm_make_request() without a comment, e.g. the cases for
APIC_DM_STARTUP and APIC_DM_REMRD in this same switch, kvm_inject_nmi(),
etc...  One might wonder what makes INIT special.

And on the flip side, APIC_DM_STARTUP is a good example of when a
smp_wmb()/smp_rmb() is needed and commented correctly (though calling out
the exactly location of the other half would be helpful).

> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> 
> >  			kvm_make_request(KVM_REQ_EVENT, vcpu);
> >  			kvm_vcpu_kick(vcpu);
> >  		}
> 
> -- 
> Vitaly
> 
