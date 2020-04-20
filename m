Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D541B0627
	for <lists+kvm@lfdr.de>; Mon, 20 Apr 2020 12:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgDTKD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Apr 2020 06:03:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgDTKDz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Apr 2020 06:03:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73D1F20857;
        Mon, 20 Apr 2020 10:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587377034;
        bh=T+IkyhCGWmGjFb1dkbRxqVNqlQocAwEx9c7HtptLrJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=I2Q0vwOApagpSZa8aKZX6jIxWVVd//vWr1lsY6oqJu7WvRNttvnjyXCU52yI/HlO/
         3fJNsnCAPSdBsdFE5Am5IsFfQ5F+vfavyJ4H75E9RWVIEckbZu8RBshUvb4qqvpzs9
         AMSEgFyr/xJ5+t6rM272GwgMznGGkHGkBmg16dLw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jQTHM-004pNG-EA; Mon, 20 Apr 2020 11:03:52 +0100
Date:   Mon, 20 Apr 2020 11:03:50 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     James Morse <james.morse@arm.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Zenghui Yu <yuzenghui@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Julien Grall <julien@xen.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v2 4/6] KVM: arm: vgic-v2: Only use the virtual state
 when userspace accesses pending bits
Message-ID: <20200420110350.675a3393@why>
In-Reply-To: <7b001ee4-0a8e-d79c-1be4-563dab4ca452@arm.com>
References: <20200417083319.3066217-1-maz@kernel.org>
        <20200417083319.3066217-5-maz@kernel.org>
        <4133d5f2-ed0e-9c4a-8a66-953fb6bf6e70@arm.com>
        <20200417134140.0a901749@why>
        <7b001ee4-0a8e-d79c-1be4-563dab4ca452@arm.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, yuzenghui@huawei.com, eric.auger@redhat.com, Andre.Przywara@arm.com, julien@xen.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 17 Apr 2020 17:48:34 +0100
James Morse <james.morse@arm.com> wrote:

Hi James,

> Hi Marc,
> 
> On 17/04/2020 13:41, Marc Zyngier wrote:
> > On Fri, 17 Apr 2020 12:22:10 +0100 James Morse <james.morse@arm.com> wrote:  
> >> On 17/04/2020 09:33, Marc Zyngier wrote:  
> >>> There is no point in accessing the HW when writing to any of the
> >>> ISPENDR/ICPENDR registers from userspace, as only the guest should
> >>> be allowed to change the HW state.
> >>>
> >>> Introduce new userspace-specific accessors that deal solely with
> >>> the virtual state. Note that the API differs from that of GICv3,
> >>> where userspace exclusively uses ISPENDR to set the state. Too
> >>> bad we can't reuse it.    
> 
> >>> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> >>> index 6e30034d1464..f1927ae02d2e 100644
> >>> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> >>> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> >>> @@ -321,6 +321,27 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,    
> >>  
> >>> +int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
> >>> +				gpa_t addr, unsigned int len,
> >>> +				unsigned long val)
> >>> +{
> >>> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> >>> +	int i;
> >>> +	unsigned long flags;
> >>> +
> >>> +	for_each_set_bit(i, &val, len * 8) {
> >>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);    
> >>
> >> vgic_mmio_write_spending() has:
> >> |	/* GICD_ISPENDR0 SGI bits are WI *
> >>
> >> and bales out early. Is GIC_DIST_PENDING_SET the same register?
> >> (If so, shouldn't that be true for PPI too?)  
> > 
> > Hmmm. It's a bit more complicated (surprisingly).
> > 
> > Yes, the SGI pending bits are WI from the guest perspective (as
> > required by the spec).  
> 
> > But we still need to be able to restore them
> > from userspace, and I bet 82e40f558de56 ("KVM: arm/arm64: vgic-v2:
> > Handle SGI bits in GICD_I{S,C}PENDR0 as WI") has broken migration with
> > GICv2 (if you migrated with a pending SGI, you cannot restore it...).  
> 
> Fun! It looks like the ioctl() would succeed, but nothing happened. Once you restart the
> guest one CPU may wait forever for the victim to respond.

Yup. I can only see two reason for this not being reported: nobody
tests live migration with GICv2 (most probable), or we're incredibly
lucky by having never take a snapshot of a pending SGI. Either way,
this needs fixing.

> > Now, there is still a bug here, in the sense that we need to indicate
> > which vcpu is the source of the SGI (this is a GICv2-special).
> > Unfortunately, we don't have a way to communicate this architecturally.
> > The only option we have is to make it up (as a self-SGI, for example).
> > But this is pretty broken at the architectural level TBH.
> > On the other hand, PPIs are just fine.  
> 
> Yup, wrong spec, I was looking at the same register in GICv3! It looks like the GICv3 text
> is there because those registers live in the redistributor instead... duh!
> 
> 
> >>> @@ -390,6 +411,26 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,    
> >>  
> >>> +int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
> >>> +				gpa_t addr, unsigned int len,
> >>> +				unsigned long val)
> >>> +{
> >>> +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> >>> +	int i;
> >>> +	unsigned long flags;
> >>> +
> >>> +	for_each_set_bit(i, &val, len * 8) {
> >>> +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);    
> >>
> >> Same dumb question about GICD_ICPENDR0!?  
> > 
> > Not dumb at all! Given that we previously allowed this to be accessed
> > from userspace (well, before we broke it again), it should be able to
> > clear *something*. If we adopt the self-SGI behaviour as above, we will
> > get away with it.
> > 
> > Here's what I'm proposing to add to this patch, together with a
> > Fixes: 82e40f558de56 ("KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI")
> > 
> > Nobody is using GICv2, obviously... :-/  
> 
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> > index f1927ae02d2e..974cdcf2f232 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio.c  
> 
> > @@ -334,6 +322,15 @@ int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
> >  
> >  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> >  		irq->pending_latch = true;
> > +
> > +		/*
> > +		 * GICv2 SGIs are terribly broken. We can't restore
> > +		 * the source of the interrupt, so just pick the vcpu
> > +		 * itself as the source...  
> 
> Makes sense, this way you can't have an SGI coming from an offline CPU!
> 
> 
> > +		 */
> > +		if (is_vgic_v2_sgi(vcpu, irq))
> > +			irq->source |= BIT(vcpu->vcpu_id);
> > +
> >  		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> >  
> >  		vgic_put_irq(vcpu->kvm, irq);  
> 
> > @@ -423,7 +415,22 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
> >  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >  
> >  		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> > -		irq->pending_latch = false;
> > +		/*
> > +		 * More fun with GICv2 SGIs! If we're clearing one of them
> > +		 * from userspace, which source vcpu to clear?  Let's pick
> > +		 * the target vcpu itself (consistent whith the way we
> > +		 * populate them on the ISPENDR side), and only clear the
> > +		 * pending state if no sources are left (insert expletive
> > +		 * here).  
> 
> But I'm not so sure about this. Doesn't this mean that user-space can't clear pending-SGI?
> Only if its pending due to self-SGI. I'm not sure when user-space would want to do this,
> so it may not matter.

In general, userspace just sets the pending bit, and doesn't bother
clearing anything (because by default, there is nothing to clear).

> Using ffs() you could clear the lowest pending source, I assume if its pending, there is
> likely only one source. If not, user-space can eventually clear pending SGI with at most
> nr-vcpu calls ... and ffs() could double up as the missing expletive!

;-)

> (but if user-space never actually does this, then we should do the simplest thing)

A third way would be to align on what GICv3 does, which is that ISPENDR
is used for both setting and clearing in one go. Given that the current
state it broken (and has been for some time now), I'm tempted to adopt
the same behaviour...

What do you think?

	M.
-- 
Jazz is not dead. It just smells funny...
