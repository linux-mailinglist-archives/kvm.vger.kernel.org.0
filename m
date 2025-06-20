Return-Path: <kvm+bounces-50131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D19CAE20CC
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:22:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 865F21C241D1
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:23:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A17BA1FDA94;
	Fri, 20 Jun 2025 17:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WD3BNNzG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC4F1FDA6D
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 17:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750440155; cv=none; b=OjeZ+4/uT7BPFR9k9mMMPk/le0fYICAken/KDw59Afg6Irseb5GMHv2/wAzzN2pO+XOvw/uZt/dJSKN15/O/+XkUFuJh55B+0vPFi7IbGKwrf2eqhB7zL6Qv4yIiBKjl/ecM5dl+ohsIz5mk11/o+B+56vG8thrGzRwa3Wr/1As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750440155; c=relaxed/simple;
	bh=6ISGtVsG/IWGFssbzjNwBrProURsy368G0H6yNcnXt4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KK2GC65RZNpKlEtOmcmajzEZkbU0EBcJFs9gI/2CUspiELeNclJm4IPxdYL4bfD5lgAlx4kOtdKJQ75h1dd5l3ZJKaygBTyFgi5x85we+7yDDzQ4XcZtuCqU0Oi8CcMHny4kKaIQP8TK3uWWVYErAXgygGnOhBmK4syjNqalHmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WD3BNNzG; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b31831b0335so2386780a12.3
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 10:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750440154; x=1751044954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NErYkcwCW0ofBX6e5hYOIbXlxwjpJ4sRagkANyVcFH4=;
        b=WD3BNNzGo66SSCOANOUgWSqxjoAh1kImp6E1z9KSY9+CUvytNzWAWFKTyhBbR6qceh
         +3IlkTqUDoocH5/xXyUsnUWVoiAF1jSxP/D0jaYrcLYc9olaU7U4YpoNvo+f4FtKNhaN
         5fm9ArCmO9XuctdiWE2pFUJyfGKLXxUZoyxoVZgZyoisir9ttEbuO6NnPqL+ljEOdfZ0
         3E/A+YTUeeVOzd/uixm6uWWq8bbpIos10nBSINoYNGCEBW6rrlhMX3GVR7qjdH0XAzSz
         eWDLBH6ZnGU5AvLqOcC9pjanqf7OV/Xwe9RmKbM6E0Jup/VwtYcUVEvWMbj4ULLcgmqA
         A2Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750440154; x=1751044954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NErYkcwCW0ofBX6e5hYOIbXlxwjpJ4sRagkANyVcFH4=;
        b=n4dzccNKU9Q1sl6MMPJ6uvi4f6JGxbgulbvNZTgg1IdxIhX5hUrnrMO1VSDV21RngB
         SeuSzMHMKMu3q7+S0Qv7Py0HXbZbsuk7+K/x3d7f/CVTc19HAR6IowWcltbmWIO3F3Eh
         NIlVJauq/xnSPhWM3Z7UtYNXgMxIFpGUh7AWtM+xjcUqIZyNrYDSLw90nX9USS9Yac1Q
         zL1Ecf1qEM+NVF7FWnWfldE6JX7iQ+lQNT4no61+xTMZi7MjkCkThwCyr3o/1e6684wO
         m/03X1UzfksBGk7tZbzTkPtGiOH52qWYa+d14acbIPUvKeDs6YIt/tOyLirNCqooLcpJ
         m1iA==
X-Forwarded-Encrypted: i=1; AJvYcCXnWjfULJ9gOY4Jl0Hcy3hIyv8x9dLT2UU44v5NM5lG9/GNU+z0e4PblXMAjqK0Z3jePg0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+vDZIl30MhjsGk2XVgWx+2Y2EgEE4d+cMDWB9554ijx9MBw+L
	Zc4kK4uwXkpAfWTWTu0z2lSuJTAG/SiaLB//XWU4rtOqpKrKvsZXBXBh4YA4+3WFX/lFgw/cnE5
	Dmgh+jA==
X-Google-Smtp-Source: AGHT+IHXGxBdpxT88k3O204/zN4ifc12tJw1aK+nMcKj7rx2Ml8z17hcOCexso6J6CnRpxLft2px3MEAX6w=
X-Received: from pjbpl17.prod.google.com ([2002:a17:90b:2691:b0:311:4aa8:2179])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:c883:b0:311:ab20:159a
 with SMTP id 98e67ed59e1d1-3159d8d9098mr6199506a91.29.1750440153664; Fri, 20
 Jun 2025 10:22:33 -0700 (PDT)
Date: Fri, 20 Jun 2025 10:22:32 -0700
In-Reply-To: <aEyOcJJsys9mm_Xs@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-4-seanjc@google.com>
 <86tt4lcgs3.wl-maz@kernel.org> <aErlezuoFJ8u0ue-@google.com> <aEyOcJJsys9mm_Xs@linux.dev>
Message-ID: <aFWY2LTVIxz5rfhh@google.com>
Subject: Re: [PATCH v3 02/62] KVM: arm64: WARN if unmapping vLPI fails
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="us-ascii"

On Fri, Jun 13, 2025, Oliver Upton wrote:
> On Thu, Jun 12, 2025 at 07:34:35AM -0700, Sean Christopherson wrote:
> > On Thu, Jun 12, 2025, Marc Zyngier wrote:
> > > But not having an VLPI mapping for an interrupt at the point where we're
> > > tearing down the forwarding is pretty benign. IRQs *still* go where they
> > > should, and we don't lose anything.
> 
> The VM may not actually be getting torn down, though. The series of
> fixes [*] we took for 6.16 addressed games that VMMs might be playing on
> irqbypass for a live VM.
> 
> [*] https://lore.kernel.org/kvmarm/20250523194722.4066715-1-oliver.upton@linux.dev/
> 
> > All of those failure scenario seem like warnable offences when KVM thinks it has
> > configured the IRQ to be forwarded to a vCPU.
> 
> I tend to agree here, especially considering how horribly fragile GICv4
> has been in some systems. I know of a couple implementations where ITS
> command failures and/or unmapped MSIs are fatal for the entire machine.
> Debugging them has been a genuine pain in the ass.
> 
> WARN'ing when state tracking for vLPIs is out of whack would've made it
> a little easier.

Marc, does this look and read better?

I'd really, really like to get this sorted out asap, as it's the only thing
blocking the series, and I want to get the series into linux-next early next
week, before I go OOO for ~10 days.

--
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 12 Jun 2025 16:51:47 -0700
Subject: [PATCH] KVM: arm64: WARN if unmapping a vLPI fails in any path

When unmapping a vLPI, WARN if nullifying vCPU affinity fails, not just if
failure occurs when freeing an ITE.  If undoing vCPU affinity fails, then
odds are very good that vLPI state tracking has has gotten out of whack,
i.e. that KVM and the GIC disagree on the state of an IRQ/vLPI.  At best,
inconsistent state means there is a lurking bug/flaw somewhere.  At worst,
the inconsistency could eventually be fatal to the host, e.g. if an ITS
command fails because KVM's view of things doesn't match reality/hardware.

Note, only the call from kvm_arch_irq_bypass_del_producer() by way of
kvm_vgic_v4_unset_forwarding() doesn't already WARN.  Common KVM's
kvm_irq_routing_update() WARNs if kvm_arch_update_irqfd_routing() fails.
For that path, if its_unmap_vlpi() fails in kvm_vgic_v4_unset_forwarding(),
the only possible causes are that the GIC doesn't have a v4 ITS (from
its_irq_set_vcpu_affinity()):

        /* Need a v4 ITS */
        if (!is_v4(its_dev->its))
                return -EINVAL;

        guard(raw_spinlock)(&its_dev->event_map.vlpi_lock);

        /* Unmap request? */
        if (!info)
                return its_vlpi_unmap(d);

or that KVM has gotten out of sync with the GIC/ITS (from its_vlpi_unmap()):

        if (!its_dev->event_map.vm || !irqd_is_forwarded_to_vcpu(d))
                return -EINVAL;

All of the above failure scenarios are warnable offences, as they should
never occur absent a kernel/KVM bug.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/arm64/kvm/vgic/vgic-its.c     | 2 +-
 arch/arm64/kvm/vgic/vgic-v4.c      | 4 ++--
 drivers/irqchip/irq-gic-v4.c       | 4 ++--
 include/linux/irqchip/arm-gic-v4.h | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 534049c7c94b..98630dae910d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -758,7 +758,7 @@ static void its_free_ite(struct kvm *kvm, struct its_ite *ite)
 	if (irq) {
 		scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
 			if (irq->hw)
-				WARN_ON(its_unmap_vlpi(ite->irq->host_irq));
+				its_unmap_vlpi(ite->irq->host_irq);
 
 			irq->hw = false;
 		}
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 193946108192..911170d4a9c8 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -545,10 +545,10 @@ int kvm_vgic_v4_unset_forwarding(struct kvm *kvm, int host_irq)
 	if (irq->hw) {
 		atomic_dec(&irq->target_vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count);
 		irq->hw = false;
-		ret = its_unmap_vlpi(host_irq);
+		its_unmap_vlpi(host_irq);
 	}
 
 	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
 	vgic_put_irq(kvm, irq);
-	return ret;
+	return 0;
 }
diff --git a/drivers/irqchip/irq-gic-v4.c b/drivers/irqchip/irq-gic-v4.c
index 58c28895f8c4..8455b4a5fbb0 100644
--- a/drivers/irqchip/irq-gic-v4.c
+++ b/drivers/irqchip/irq-gic-v4.c
@@ -342,10 +342,10 @@ int its_get_vlpi(int irq, struct its_vlpi_map *map)
 	return irq_set_vcpu_affinity(irq, &info);
 }
 
-int its_unmap_vlpi(int irq)
+void its_unmap_vlpi(int irq)
 {
 	irq_clear_status_flags(irq, IRQ_DISABLE_UNLAZY);
-	return irq_set_vcpu_affinity(irq, NULL);
+	WARN_ON_ONCE(irq_set_vcpu_affinity(irq, NULL));
 }
 
 int its_prop_update_vlpi(int irq, u8 config, bool inv)
diff --git a/include/linux/irqchip/arm-gic-v4.h b/include/linux/irqchip/arm-gic-v4.h
index 7f1f11a5e4e4..0b0887099fd7 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -146,7 +146,7 @@ int its_commit_vpe(struct its_vpe *vpe);
 int its_invall_vpe(struct its_vpe *vpe);
 int its_map_vlpi(int irq, struct its_vlpi_map *map);
 int its_get_vlpi(int irq, struct its_vlpi_map *map);
-int its_unmap_vlpi(int irq);
+void its_unmap_vlpi(int irq);
 int its_prop_update_vlpi(int irq, u8 config, bool inv);
 int its_prop_update_vsgi(int irq, u8 priority, bool group);
 

base-commit: 4fc39a165c70a49991b7cc29be3a19eddcd9e5b9
--

