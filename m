Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E41868CB82
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2019 08:05:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbfHNGF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Aug 2019 02:05:58 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:38045 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726383AbfHNGF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Aug 2019 02:05:58 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 467fGC3B5jz9sN1; Wed, 14 Aug 2019 16:05:55 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1565762755; bh=YCkXcmC5Gsb762TGg9wJ63z1nfs5Twv2q5POXiB4PoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=idIoTCYld2PtIDlihu7HiUCqhxl9LN2erk0m4g4ujaio5FWKqGaTm84CO4YZM1/PN
         psPOyN9aQBKbhzSnPhrqVNddZBZjxCg7AM5YJc9rmD4zr62pbVBi+0rxfnLrd+0LeE
         cphbdnEWVY/n94T7/hZdclGGP55HHt9gaOAHn/kPmWAIhKwyTCi5aKXicY5OyeW442
         2hHfYwylJHbatRCdn9OA92ytnvLODcynsJcN1Z7UbhxCYbZb5WlpZgEywcpCJ2M6yq
         LnUolWMsHxh4HDJvQMzhbQOi0wghqJgC2+JAvm4wd+Ut7+G/LQrzpg+ENRv2QRtwVY
         QyF00GLqNyuMQ==
Date:   Wed, 14 Aug 2019 16:05:52 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Jordan Niethe <jniethe5@gmail.com>
Cc:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH v2 1/3] KVM: PPC: Book3S HV: Fix race in re-enabling XIVE
 escalation interrupts
Message-ID: <20190814060552.kh2gnfmnbmmtixvh@oak.ozlabs.ibm.com>
References: <20190813095845.GA9567@blackberry>
 <20190813100349.GD9567@blackberry>
 <53a17acd0330bc38190ab36625e48d1727a16fa4.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53a17acd0330bc38190ab36625e48d1727a16fa4.camel@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 14, 2019 at 02:46:38PM +1000, Jordan Niethe wrote:
> On Tue, 2019-08-13 at 20:03 +1000, Paul Mackerras wrote:

[snip]
> > diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > index 337e644..2e7e788 100644
> > --- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > +++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
> > @@ -2831,29 +2831,39 @@ kvm_cede_prodded:
> >  kvm_cede_exit:
> >  	ld	r9, HSTATE_KVM_VCPU(r13)
> >  #ifdef CONFIG_KVM_XICS
> > -	/* Abort if we still have a pending escalation */
> > +	/* are we using XIVE with single escalation? */
> > +	ld	r10, VCPU_XIVE_ESC_VADDR(r9)
> > +	cmpdi	r10, 0
> > +	beq	3f
> > +	li	r6, XIVE_ESB_SET_PQ_00
> Would it make sense to put the above instruction down into the 4: label
> instead? If we do not branch to 4, r6 is overwriten anyway. 

Right.

> I think that would save a load when we do not branch to 4. Also it

Well, li is a load immediate rather than a load ("load" would normally
imply a load from memory).  Load-immediate instructions are
essentially free since they can easily be executed in parallel with
other instructions and execute in a single cycle.

> would mean that you could use r5 everywhere instead of changing it to
> r6? 

Yes.  If I have to respin the patch for other reasons then I will
rearrange things as you suggest.  I don't think it's worth respinning
just for this change -- it won't reduce the total number of
instructions, and I strongly doubt there would be any measurable
performance difference.

> > +	/*
> > +	 * If we still have a pending escalation, abort the cede,
> > +	 * and we must set PQ to 10 rather than 00 so that we don't
> > +	 * potentially end up with two entries for the escalation
> > +	 * interrupt in the XIVE interrupt queue.  In that case
> > +	 * we also don't want to set xive_esc_on to 1 here in
> > +	 * case we race with xive_esc_irq().
> > +	 */
> >  	lbz	r5, VCPU_XIVE_ESC_ON(r9)
> >  	cmpwi	r5, 0
> > -	beq	1f
> > +	beq	4f
> >  	li	r0, 0
> >  	stb	r0, VCPU_CEDED(r9)
> > -1:	/* Enable XIVE escalation */
> > -	li	r5, XIVE_ESB_SET_PQ_00
> > +	li	r6, XIVE_ESB_SET_PQ_10
> > +	b	5f
> > +4:	li	r0, 1
> > +	stb	r0, VCPU_XIVE_ESC_ON(r9)
> > +	/* make sure store to xive_esc_on is seen before xive_esc_irq
> > runs */
> > +	sync
> > +5:	/* Enable XIVE escalation */
> >  	mfmsr	r0
> >  	andi.	r0, r0, MSR_DR		/* in real mode? */
> >  	beq	1f
> > -	ld	r10, VCPU_XIVE_ESC_VADDR(r9)
> > -	cmpdi	r10, 0
> > -	beq	3f
> > -	ldx	r0, r10, r5
> > +	ldx	r0, r10, r6
> >  	b	2f
> >  1:	ld	r10, VCPU_XIVE_ESC_RADDR(r9)
> > -	cmpdi	r10, 0
> > -	beq	3f
> > -	ldcix	r0, r10, r5
> > +	ldcix	r0, r10, r6
> >  2:	sync
> > -	li	r0, 1
> > -	stb	r0, VCPU_XIVE_ESC_ON(r9)
> >  #endif /* CONFIG_KVM_XICS */
> >  3:	b	guest_exit_cont
> >  

Paul.
