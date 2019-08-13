Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A16C68AE52
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2019 06:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfHME7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Aug 2019 00:59:12 -0400
Received: from ozlabs.org ([203.11.71.1]:59483 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbfHME7M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Aug 2019 00:59:12 -0400
Received: by ozlabs.org (Postfix, from userid 1003)
        id 4670qd1zdnz9sP6; Tue, 13 Aug 2019 14:59:09 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ozlabs.org; s=201707;
        t=1565672349; bh=8UJ/fbVBjvn5G6GKUqcRf7p6NknlS77OKW7AcNAtHL4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SBcQsiXNS7jhwDQ+ruoR8BLpmEmdUp3VIS6DbaCA6/7WHzWV/WxO2I02unWgw/XsL
         NOWgWeLBEf4QNT78DtcCoFrydtjH+qe9BasscDCNTMamE4Fn+NUnSYuSZ4eIY4ghoH
         S2+++uPhY300Xlz4lyGVnrnYgf66XdmovrL1tgUhqdeZTSBWJa95xxC9+c8JZpgKEw
         FQF9iWL5g9xFscCp7h3M/3yNlZ9s4eUwL+9M/mfbYidARcrco+iJPJJf23aFqvj0tc
         ySUdvdenHKSQx544w1RWlf12tJbLD1MUNukXtKAA6jx1hVcHKguaNckRC1fHnxsgSP
         JdE7206A16yqg==
Date:   Tue, 13 Aug 2019 14:56:39 +1000
From:   Paul Mackerras <paulus@ozlabs.org>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     linuxppc-dev@ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 2/2] powerpc/xive: Implement get_irqchip_state method for
 XIVE to fix shutdown race
Message-ID: <20190813045639.lm443zsouievhtne@oak.ozlabs.ibm.com>
References: <20190812050623.ltla46gh5futsqv4@oak.ozlabs.ibm.com>
 <20190812050743.aczgcqwmtqpkbx2l@oak.ozlabs.ibm.com>
 <E547965E-CC31-470F-8849-0F2A899A121F@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E547965E-CC31-470F-8849-0F2A899A121F@linux.vnet.ibm.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 12, 2019 at 10:52:11PM -0500, Lijun Pan wrote:
> 
> 
> > On Aug 12, 2019, at 12:07 AM, Paul Mackerras <paulus@ozlabs.org> wrote:

[snip]

> > +static void cleanup_single_escalation(struct kvm_vcpu *vcpu,
> > +				      struct kvmppc_xive_vcpu *xc, int irq)
> > +{
> > +	struct irq_data *d = irq_get_irq_data(irq);
> > +	struct xive_irq_data *xd = irq_data_get_irq_handler_data(d);
> > +
> > +	/*
> > +	 * This slightly odd sequence gives the right result
> > +	 * (i.e. stale_p set if xive_esc_on is false) even if
> > +	 * we race with xive_esc_irq() and xive_irq_eoi().
> > +	 */
> 
> Hi Paul,
> 
> I don’t quite understand the logic here.
> Are you saying the code sequence is
> vcpu->arch.xive_esc_on = false; (xive_esc_irq)
> then
> xd->stale_p = true; (cleanup_single_escaltion)
> 
> > +	xd->stale_p = false;
> > +	smp_mb();		/* paired with smb_wmb in xive_esc_irq */
> > +	if (!vcpu->arch.xive_esc_on)
> > +		xd->stale_p = true;

The natural sequence would be just
	xd->stale_p = !vcpu->arch.xive_esc_on;

However, imagine that vcpu->arch.xive_esc_on is true, and the
escalation interrupt gets handled on another CPU between the load of
vcpu->arch.xive_esc_on and the store to xd->stale_p.  The interrupt
code calls xive_esc_irq(), which clears vcpu->arch.xive_esc_on, and
then xive_irq_eoi(), which sets xd->stale_p.  The natural sequence
could read vcpu->arch.xive_esc_on before the interrupt and see 1, then
write 0 to xd->stale_p after xive_irq_eoi() has set it.  That would
mean the final value of xd->stale_p was 0, which is wrong, since in
fact the queue entry has been removed.

With the code I wrote, because the clearing of xd->stale_p comes
before the load from vcpu->arch.xive_esc_on (with a barrier to make
sure they don't get reordered), then if a racing escalation interrupt
on another CPU stores 1 to xd->stale_p before we clear it, then we
must see vcpu->arch.xive_esc_on as 0, and we will set xd->stale_p
again, giving the correct final state (xd->stale_p == 1).  If the
racing interrupt clears vcpu->arch.xive_esc_on after we load it and
see 1, then its store to set xd->stale_p must come after our store to
clear it because of the barrier that I added to xive_esc_irq, so the
final result is once again correct.

[snip]

> > @@ -397,11 +411,16 @@ static void xive_do_source_set_mask(struct xive_irq_data *xd,
> > 	 */
> > 	if (mask) {
> > 		val = xive_esb_read(xd, XIVE_ESB_SET_PQ_01);
> > -		xd->saved_p = !!(val & XIVE_ESB_VAL_P);
> > -	} else if (xd->saved_p)
> > +		if (!xd->stale_p && !!(val & XIVE_ESB_VAL_P))
> > +			xd->saved_p = true;
> > +		xd->stale_p = false;
> > +	} else if (xd->saved_p) {
> > 		xive_esb_read(xd, XIVE_ESB_SET_PQ_10);
> > -	else
> > +		xd->saved_p = false;
> 
> Should we also explicitly set xd->stale_p = true; here?

We don't need to because xd->saved_p and xd->stale_p can never be both
set, and we just saw that xd->saved_p was set.

> > +	} else {
> > 		xive_esb_read(xd, XIVE_ESB_SET_PQ_00);
> > +		xd->stale_p = false;
> 
> Should we also explicitly set xd->saved_p = true; here?

No, that would be incorrect.  This is the case where we are unmasking
the interrupt and there is no queue entry currently.  Setting saved_p
would imply that there is a queue entry, which there isn't.

Paul.
