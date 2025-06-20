Return-Path: <kvm+bounces-50156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97548AE2282
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 20:49:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 529883A7CE7
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 18:49:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009162EAB93;
	Fri, 20 Jun 2025 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Uv+9F3kf"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C5028F528
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 18:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750445369; cv=none; b=mn8wvCuBiTGaPyAIRGqPKCKv8kE8JldHMHhsDRLmy0b9G9xthe+R93vSLYxFgfauOZaGOJOikbmqMG2g37lAC0OOVOy+y4YcaArmbqN+lIJipvxP++7+PaymGRdvJVv4/xgzleJ5KBPe+WFinEv2oDuvzg6biMoQdWCc9ZU/Gr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750445369; c=relaxed/simple;
	bh=+pHGxwbyLZaUIRCP3poa1QzCgDmZnXzfvoY65I7GZPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Qc3btgepz/C92TGlGT87hRvVp+si1JvnMHF4DOzGf8A8lUPf4/WJyN99/erZghKrsRXKbW8UpcneOthQOyvnBvWsMctg0yx15+1jdHoWhiMwfrdBtyBk90QrNyhTEJ+560UYtxSHVqEw3xOcNuLRYdKChzIiiG8XjlTXQb66Nho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Uv+9F3kf; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 20 Jun 2025 11:48:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750445349;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SCWfCfaZ3u6KNLTf3q+pHDxfcJpIR3G2GwUv6btP+Lc=;
	b=Uv+9F3kf+uawsW/hRSt0qY1C/WI5g9xdumI1n+LnBI60VZNdEmkQYEaHL5g5ZExXcc+as6
	QUhbhNdcxCDNrcOlA8K+d1EC2hpMHuNMfm0G1BQgs59RGSbjCYzL7dpN5580FwA4iPVAYB
	rU+Gk24NczndMIpU5aNVPd4GUJSYLx0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Joerg Roedel <joro@8bytes.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	kvm@vger.kernel.org, iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org, Sairaj Kodilkar <sarunkod@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
Message-ID: <aFWtB6Vmn9MnfkEi@linux.dev>
References: <20250611224604.313496-2-seanjc@google.com>
 <20250611224604.313496-4-seanjc@google.com>
 <86tt4lcgs3.wl-maz@kernel.org>
 <aErlezuoFJ8u0ue-@google.com>
 <aEyOcJJsys9mm_Xs@linux.dev>
 <aFWY2LTVIxz5rfhh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFWY2LTVIxz5rfhh@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, Jun 20, 2025 at 10:22:32AM -0700, Sean Christopherson wrote:
> On Fri, Jun 13, 2025, Oliver Upton wrote:
> > On Thu, Jun 12, 2025 at 07:34:35AM -0700, Sean Christopherson wrote:
> > > On Thu, Jun 12, 2025, Marc Zyngier wrote:
> > > > But not having an VLPI mapping for an interrupt at the point where we're
> > > > tearing down the forwarding is pretty benign. IRQs *still* go where they
> > > > should, and we don't lose anything.
> > 
> > The VM may not actually be getting torn down, though. The series of
> > fixes [*] we took for 6.16 addressed games that VMMs might be playing on
> > irqbypass for a live VM.
> > 
> > [*] https://lore.kernel.org/kvmarm/20250523194722.4066715-1-oliver.upton@linux.dev/
> > 
> > > All of those failure scenario seem like warnable offences when KVM thinks it has
> > > configured the IRQ to be forwarded to a vCPU.
> > 
> > I tend to agree here, especially considering how horribly fragile GICv4
> > has been in some systems. I know of a couple implementations where ITS
> > command failures and/or unmapped MSIs are fatal for the entire machine.
> > Debugging them has been a genuine pain in the ass.
> > 
> > WARN'ing when state tracking for vLPIs is out of whack would've made it
> > a little easier.
> 
> Marc, does this look and read better?
> 
> I'd really, really like to get this sorted out asap, as it's the only thing
> blocking the series, and I want to get the series into linux-next early next
> week, before I go OOO for ~10 days.

Can you just send it out as a standalone patch? It's only tangientally
related to the truckload of x86 stuff that I'd rather not pull in the
event of conflict resolution.

Thanks,
Oliver

> --
> From: Sean Christopherson <seanjc@google.com>
> Date: Thu, 12 Jun 2025 16:51:47 -0700
> Subject: [PATCH] KVM: arm64: WARN if unmapping a vLPI fails in any path
> 
> When unmapping a vLPI, WARN if nullifying vCPU affinity fails, not just if
> failure occurs when freeing an ITE.  If undoing vCPU affinity fails, then
> odds are very good that vLPI state tracking has has gotten out of whack,
> i.e. that KVM and the GIC disagree on the state of an IRQ/vLPI.  At best,
> inconsistent state means there is a lurking bug/flaw somewhere.  At worst,
> the inconsistency could eventually be fatal to the host, e.g. if an ITS
> command fails because KVM's view of things doesn't match reality/hardware.
> 
> Note, only the call from kvm_arch_irq_bypass_del_producer() by way of
> kvm_vgic_v4_unset_forwarding() doesn't already WARN.  Common KVM's
> kvm_irq_routing_update() WARNs if kvm_arch_update_irqfd_routing() fails.
> For that path, if its_unmap_vlpi() fails in kvm_vgic_v4_unset_forwarding(),
> the only possible causes are that the GIC doesn't have a v4 ITS (from
> its_irq_set_vcpu_affinity()):
> 
>         /* Need a v4 ITS */
>         if (!is_v4(its_dev->its))
>                 return -EINVAL;
> 
>         guard(raw_spinlock)(&its_dev->event_map.vlpi_lock);
> 
>         /* Unmap request? */
>         if (!info)
>                 return its_vlpi_unmap(d);
> 
> or that KVM has gotten out of sync with the GIC/ITS (from its_vlpi_unmap()):
> 
>         if (!its_dev->event_map.vm || !irqd_is_forwarded_to_vcpu(d))
>                 return -EINVAL;
> 
> All of the above failure scenarios are warnable offences, as they should
> never occur absent a kernel/KVM bug.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/arm64/kvm/vgic/vgic-its.c     | 2 +-
>  arch/arm64/kvm/vgic/vgic-v4.c      | 4 ++--
>  drivers/irqchip/irq-gic-v4.c       | 4 ++--
>  include/linux/irqchip/arm-gic-v4.h | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
> index 534049c7c94b..98630dae910d 100644
> --- a/arch/arm64/kvm/vgic/vgic-its.c
> +++ b/arch/arm64/kvm/vgic/vgic-its.c
> @@ -758,7 +758,7 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
>  	if (irq) {
>  		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
>  			if (irq->hw)
> -				WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
> +				its_unmap_vlpi(ite->irq->host_irq);
>  
>  			irq->hw = false;
>  		}
> diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
> index 193946108192..911170d4a9c8 100644
> --- a/arch/arm64/kvm/vgic/vgic-v4.c
> +++ b/arch/arm64/kvm/vgic/vgic-v4.c
> @@ -545,10 +545,10 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
>  	if (irq->hw) {
>  		atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
>  		irq->hw = false;
> -		ret = its_unmap_vlpi(host_irq);
> +		its_unmap_vlpi(host_irq);
>  	}
>  
>  	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
>  	vgic_put_irq(kvm, irq);
> -	return ret;
> +	return 0;
>  }
> diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
> index 58c28895f8c4..8455b4a5fbb0 100644
> --- a/drivers/irqchip/irq-gic-v4.c
> +++ b/drivers/irqchip/irq-gic-v4.c
> @@ -342,10 +342,10 @@ int its_get_vlpi(int irq, struct its_vlpi_map *map)
>  	return irq_set_vcpu_affinity(irq, &info);
>  }
>  
> -int its_unmap_vlpi(int irq)
> +void its_unmap_vlpi(int irq)
>  {
>  	irq_clear_status_flags(irq, IRQ_DISABLE_UNLAZY);
> -	return irq_set_vcpu_affinity(irq, NULL);
> +	WARN_ON_ONCE(irq_set_vcpu_affinity(irq, NULL));
>  }
>  
>  int its_prop_update_vlpi(int irq, u8 config, bool inv)
> diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
> index 7f1f11a5e4e4..0b0887099fd7 100644
> --- a/include/linux/irqchip/arm-gic-v4.h
> +++ b/include/linux/irqchip/arm-gic-v4.h
> @@ -146,7 +146,7 @@ int its_commit_vpe(struct its_vpe *vpe);
>  int its_invall_vpe(struct its_vpe *vpe);
>  int its_map_vlpi(int irq, struct its_vlpi_map *map);
>  int its_get_vlpi(int irq, struct its_vlpi_map *map);
> -int its_unmap_vlpi(int irq);
> +void its_unmap_vlpi(int irq);
>  int its_prop_update_vlpi(int irq, u8 config, bool inv);
>  int its_prop_update_vsgi(int irq, u8 priority, bool group);
>  
> 
> base-commit: 4fc39a165c70a49991b7cc29be3a19eddcd9e5b9
> --
> 

