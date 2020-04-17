Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B73031ADD89
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 14:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbgDQMlp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 08:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727877AbgDQMlp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Apr 2020 08:41:45 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6F39208E4;
        Fri, 17 Apr 2020 12:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587127304;
        bh=4T98gtPCSxGLgiWPtiulTPepHOmvOepN/1LoJ6yZug8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jOps9UDN7qbE9+Hg6CJf94Y1bYI84GEEXKq5hTSY2LodT7xMm/oZ+pRuGhzox8oZG
         zkWaBUF7mDGhvDCs6MiOtnI/SWa05XgCilMueQtq7WhEBNBsWaxLIG+JJAk9XsyKLG
         S1XuIsVYAltKRTz6A7v2wwEAXOL/BvcwQTzQxo/Q=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jPQJS-004BBh-80; Fri, 17 Apr 2020 13:41:42 +0100
Date:   Fri, 17 Apr 2020 13:41:40 +0100
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
Message-ID: <20200417134140.0a901749@why>
In-Reply-To: <4133d5f2-ed0e-9c4a-8a66-953fb6bf6e70@arm.com>
References: <20200417083319.3066217-1-maz@kernel.org>
        <20200417083319.3066217-5-maz@kernel.org>
        <4133d5f2-ed0e-9c4a-8a66-953fb6bf6e70@arm.com>
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

On Fri, 17 Apr 2020 12:22:10 +0100
James Morse <james.morse@arm.com> wrote:

Hi James,

> Hi Marc,
> 
> On 17/04/2020 09:33, Marc Zyngier wrote:
> > There is no point in accessing the HW when writing to any of the
> > ISPENDR/ICPENDR registers from userspace, as only the guest should
> > be allowed to change the HW state.
> > 
> > Introduce new userspace-specific accessors that deal solely with
> > the virtual state. Note that the API differs from that of GICv3,
> > where userspace exclusively uses ISPENDR to set the state. Too
> > bad we can't reuse it.  
> 
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > index f51c6e939c76..a016f07adc28 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > @@ -417,10 +417,12 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
> >  		NULL, vgic_uaccess_write_cenable, 1,
> >  		VGIC_ACCESS_32bit),
> >  	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
> > -		vgic_mmio_read_pending, vgic_mmio_write_spending, NULL, NULL, 1,
> > +		vgic_mmio_read_pending, vgic_mmio_write_spending,
> > +		NULL, vgic_uaccess_write_spending, 1,
> >  		VGIC_ACCESS_32bit),  
> 
> vgic_mmio_write_spending() has some homebrew detection for is_uaccess, which causes
> vgic_hw_irq_spending() to do nothing. Isn't that now dead-code with this change?

Very good point, this deserves a cleanup.

> > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> > index 6e30034d1464..f1927ae02d2e 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> > @@ -321,6 +321,27 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,  
> 
> > +int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
> > +				gpa_t addr, unsigned int len,
> > +				unsigned long val)
> > +{
> > +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> > +	int i;
> > +	unsigned long flags;
> > +
> > +	for_each_set_bit(i, &val, len * 8) {
> > +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);  
> 
> vgic_mmio_write_spending() has:
> |	/* GICD_ISPENDR0 SGI bits are WI *
> 
> and bales out early. Is GIC_DIST_PENDING_SET the same register?
> (If so, shouldn't that be true for PPI too?)

Hmmm. It's a bit more complicated (surprisingly).

Yes, the SGI pending bits are WI from the guest perspective (as
required by the spec). But we still need to be able to restore them
from userspace, and I bet 82e40f558de56 ("KVM: arm/arm64: vgic-v2:
Handle SGI bits in GICD_I{S,C}PENDR0 as WI") has broken migration with
GICv2 (if you migrated with a pending SGI, you cannot restore it...).

Now, there is still a bug here, in the sense that we need to indicate
which vcpu is the source of the SGI (this is a GICv2-special).
Unfortunately, we don't have a way to communicate this architecturally.
The only option we have is to make it up (as a self-SGI, for example).
But this is pretty broken at the architectural level TBH.

On the other hand, PPIs are just fine.

> 
> 
> > +		raw_spin_lock_irqsave(&irq->irq_lock, flags);
> > +		irq->pending_latch = true;
> > +		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
> > +
> > +		vgic_put_irq(vcpu->kvm, irq);
> > +	}
> > +
> > +	return 0;
> > +}  
> 
> > @@ -390,6 +411,26 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,  
> 
> > +int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
> > +				gpa_t addr, unsigned int len,
> > +				unsigned long val)
> > +{
> > +	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> > +	int i;
> > +	unsigned long flags;
> > +
> > +	for_each_set_bit(i, &val, len * 8) {
> > +		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);  
> 
> Same dumb question about GICD_ICPENDR0!?

Not dumb at all! Given that we previously allowed this to be accessed
from userspace (well, before we broke it again), it should be able to
clear *something*. If we adopt the self-SGI behaviour as above, we will
get away with it.

Here's what I'm proposing to add to this patch, together with a
Fixes: 82e40f558de56 ("KVM: arm/arm64: vgic-v2: Handle SGI bits in GICD_I{S,C}PENDR0 as WI")

Nobody is using GICv2, obviously... :-/

Thanks,

	M.

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index f1927ae02d2e..974cdcf2f232 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -261,17 +261,6 @@ unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
 	return value;
 }
 
-/* Must be called with irq->irq_lock held */
-static void vgic_hw_irq_spending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-				 bool is_uaccess)
-{
-	if (is_uaccess)
-		return;
-
-	irq->pending_latch = true;
-	vgic_irq_set_phys_active(irq, true);
-}
-
 static bool is_vgic_v2_sgi(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
 	return (vgic_irq_is_sgi(irq->intid) &&
@@ -282,7 +271,6 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
-	bool is_uaccess = !kvm_get_running_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -312,10 +300,10 @@ void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
 			continue;
 		}
 
+		irq->pending_latch = true;
 		if (irq->hw)
-			vgic_hw_irq_spending(vcpu, irq, is_uaccess);
-		else
-			irq->pending_latch = true;
+			vgic_irq_set_phys_active(irq, true);
+
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 		vgic_put_irq(vcpu->kvm, irq);
 	}
@@ -334,6 +322,15 @@ int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
 		irq->pending_latch = true;
+
+		/*
+		 * GICv2 SGIs are terribly broken. We can't restore
+		 * the source of the interrupt, so just pick the vcpu
+		 * itself as the source...
+		 */
+		if (is_vgic_v2_sgi(vcpu, irq))
+			irq->source |= BIT(vcpu->vcpu_id);
+
 		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);
@@ -343,12 +340,8 @@ int vgic_uaccess_write_spending(struct kvm_vcpu *vcpu,
 }
 
 /* Must be called with irq->irq_lock held */
-static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
-				 bool is_uaccess)
+static void vgic_hw_irq_cpending(struct kvm_vcpu *vcpu, struct vgic_irq *irq)
 {
-	if (is_uaccess)
-		return;
-
 	irq->pending_latch = false;
 
 	/*
@@ -371,7 +364,6 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val)
 {
-	bool is_uaccess = !kvm_get_running_vcpu();
 	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
 	int i;
 	unsigned long flags;
@@ -402,7 +394,7 @@ void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
 		}
 
 		if (irq->hw)
-			vgic_hw_irq_cpending(vcpu, irq, is_uaccess);
+			vgic_hw_irq_cpending(vcpu, irq);
 		else
 			irq->pending_latch = false;
 
@@ -423,7 +415,22 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
 
 		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-		irq->pending_latch = false;
+		/*
+		 * More fun with GICv2 SGIs! If we're clearing one of them
+		 * from userspace, which source vcpu to clear?  Let's pick
+		 * the target vcpu itself (consistent whith the way we
+		 * populate them on the ISPENDR side), and only clear the
+		 * pending state if no sources are left (insert expletive
+		 * here).
+		 */
+		if (is_vgic_v2_sgi(vcpu, irq)) {
+			irq->source &= ~BIT(vcpu->vcpu_id);
+			if (!irq->source)
+				irq->pending_latch = false;
+		} else {
+			irq->pending_latch = false;
+		}
+
 		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 
 		vgic_put_irq(vcpu->kvm, irq);

-- 
Jazz is not dead. It just smells funny...
