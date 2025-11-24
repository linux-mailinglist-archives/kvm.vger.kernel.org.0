Return-Path: <kvm+bounces-64423-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AF275C8239C
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 20:06:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 26EFE4E7CBC
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 19:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 902D331B839;
	Mon, 24 Nov 2025 18:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Hs4wPT+8";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="tpL9B7Eb"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A6631AF3C;
	Mon, 24 Nov 2025 18:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764010781; cv=none; b=meKMoQxFCMfRwLAMQfKQBh6Bl7S6h3Qau+j7CsxN6eIYLVe1oQ7sNrQVCluUyqMBoVmAB0KNG7yX05RYpPWPiStCx6mV0m9LuuLwD0W45FpgU9i0xBIrj9wMTtZa40UCy9yPkRIX/r9s0AdhFDq0d2LN06Ziz+N5QfGBBC1RX0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764010781; c=relaxed/simple;
	bh=WEirBTyw4QbPluwuZC94Anu1P7dJ2zFHBBU/zRjsaDg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=iTXpltP8a6b37Gvcvb/eTdiwG8+MX+f9C9TEUVK9s+LQg1ZVZpyoHT7In5Ki0lcsEZ1bBT8F6vAEZuDDDIyZhjWpCUNenwXbVSlssLcG2Nhv7JyK9VAypJQttEdMsTfVCDaVgxvKfYqWEnxYKXNNMSVsgXoGbmaCmLMLBipy5Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Hs4wPT+8; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=tpL9B7Eb; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1764010776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3TGm1jTazKtXhqpWzoFCV87Q4ifbrKjw41CVyfgN0DI=;
	b=Hs4wPT+80CjAslhYclKPkoH9EHovlefF/rZ+AxQmaOcjvxpRq/hPa61MElvKCsBqP8bO8e
	x1qTnLK8n+IaT+j7YwvFYprbIKN9lDZkEeGEUu5i+eEXYrv2lNw0SyfrK4OI74qswA+JKk
	15UIvH6KFgFokUBWrGsnzQpGdtvhDae6iBVyBHK9p4p6wzQ56SIeOIKn0P4YgBiPeFLy4h
	uUi81KRUGov4cT6520B2K/z9/0cIYoi3Vs+L/Dqh1KwxovkKdjv7VRdSnqOvFfYMSmK6qZ
	aDJCOqVl1Z3PsaILCdMTvJBa3RHkl/W6cdvWLJvCQ8GyTaSZ/GNn+tKUYIKN7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1764010776;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3TGm1jTazKtXhqpWzoFCV87Q4ifbrKjw41CVyfgN0DI=;
	b=tpL9B7EbZJwFfWk1resOwaK5udnuh2bPYcw3P8s+MfW+nGB6ZB8dBzEMumsWAw7J36nz9l
	tfKNR3TGgFzWFGDg==
To: Luigi Rizzo <lrizzo@google.com>, jacob.jun.pan@linux.intel.com,
 lrizzo@google.com, rizzo.unipi@gmail.com, seanjc@google.com
Cc: a.manzanares@samsung.com, acme@kernel.org, axboe@kernel.dk,
 baolu.lu@linux.intel.com, bp@alien8.de, dan.j.williams@intel.com,
 dave.hansen@intel.com, guang.zeng@intel.com, helgaas@kernel.org,
 hpa@zytor.com, iommu@lists.linux.dev, jim.harris@samsung.com,
 joro@8bytes.org, kevin.tian@intel.com, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, maz@kernel.org, mingo@redhat.com,
 oliver.sang@intel.com, paul.e.luse@intel.com, peterz@infradead.org,
 robert.hoo.linux@gmail.com, robin.murphy@arm.com, x86@kernel.org
Subject: Re: [PATCH v3  00/12] Coalesced Interrupt Delivery with posted MSI
In-Reply-To: <20251124104836.3685533-1-lrizzo@google.com>
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
 <20251124104836.3685533-1-lrizzo@google.com>
Date: Mon, 24 Nov 2025 19:59:35 +0100
Message-ID: <87a50bi7e0.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Nov 24 2025 at 10:48, Luigi Rizzo wrote:
> I think there is an inherent race condition when intremap=posted_msi
> and the IRQ subsystem resends pending interrupts via __apic_send_IPI().
>
> In detail:
> intremap=posted_msi does not process vectors for which the
> corresponding bit in the PIR register is set.
>
> Now say that, for whatever reason, the IRQ infrastructure intercepts
> an interrupt marking it as PENDING. . handle_edge_irq() and many other
> places in kernel/irq have sections of code like this:
>
>     if (!irq_may_run(desc)) {
>         desc->istate |= IRQS_PENDING;
> 	mask_ack_irq(desc);
> 	goto out_unlock;
>     }
>
> Then eventually check_irq_resend() will try to resend pending interrupts
>
>     desc->istate &= ~IRQS_PENDING;
>     if (!try_retrigger(desc))
>         err = irq_sw_resend(desc);
>
> try_retrigger() on x86 eventually calls apic_retrigger_irq() which
> uses __apic_send_IPI(). Unfortunately the latter does not seem to
> set the 'vector' bit in the PIR (nor sends the POSTED_MSI interrupt)
> thus potentially causing a lost interrupt unless there is some other
> spontaneous interrupt coming from the device.

It sends an IPI to the actual vector, which invokes the handler
directly. That works only once because the remap interrupt chip does not
issue an EOI, so the vector becomes stale.... Clearly nobody ever tested
that code.

> I could verify the stall (forcing the path that sets IRQS_PENDING),
> and could verify that the patch below fixes the problem

You can do the same with

    echo trigger > /sys/kernel/debug/irq/irqs/$IRQNR

>  static int apic_retrigger_irq(struct irq_data *irqd)
>  {
>         struct apic_chip_data *apicd = apic_chip_data(irqd);
>         unsigned long flags;
> +       uint vec;
>
>         raw_spin_lock_irqsave(&vector_lock, flags);
> +       vec = apicd->vector;
> +       if (posted_msi_supported() &&
> +           vec >= FIRST_EXTERNAL_VECTOR && vec < FIRST_SYSTEM_VECTOR) {
> +               struct pi_desc *pid = per_cpu_ptr(&posted_msi_pi_desc, apicd->cpu);

Won't build with CONFIG_X86_POSTED_MSI=n

> +               set_bit(vec, (unsigned long *)pid->pir64);
> +               __apic_send_IPI(apicd->cpu, POSTED_MSI_NOTIFICATION_VECTOR);

That's wrong as it affects all interrupts and not just the MSI ones
which are going through the posted vector. As the interrupt chip of
those other ones is different, that retriggered handler would issue two
EOIs, which is not what we want.

That's what the interrupt hierarchy is for.

While that _is_ solvable, there is another issue which is not solvable
by that at all.

If there is ever a stray interrupt on such a vector, then the related
APIC ISR bit becomes stale due to the lack of EOI, which means all
vectors below that vector are never serviced again. Unlikely to happen,
but if it happens it's not debuggable at all.

So instead of playing games with the PIR, this can be actually solved
for both cases. See below.

Thanks,

        tglx
---
 arch/x86/include/asm/irq_remapping.h |    7 +++++++
 arch/x86/kernel/irq.c                |   28 +++++++++++++++++++++++-----
 drivers/iommu/intel/irq_remapping.c  |    8 ++++----
 3 files changed, 34 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -87,4 +87,11 @@ static inline void panic_if_irq_remap(co
 }
 
 #endif /* CONFIG_IRQ_REMAP */
+
+#ifdef CONFIG_X86_POSTED_MSI
+void intel_ack_posted_msi_irq(struct irq_data *irqd);
+#else
+#define intel_ack_posted_msi_irq(irqd)	irq_move_irq(irdq)
+#endif
+
 #endif /* __X86_IRQ_REMAPPING_H */
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -396,6 +396,7 @@ DEFINE_IDTENTRY_SYSVEC_SIMPLE(sysvec_kvm
 
 /* Posted Interrupt Descriptors for coalesced MSIs to be posted */
 DEFINE_PER_CPU_ALIGNED(struct pi_desc, posted_msi_pi_desc);
+static DEFINE_PER_CPU_CACHE_HOT(bool, posted_msi_handler_active);
 
 void intel_posted_msi_init(void)
 {
@@ -413,6 +414,24 @@ void intel_posted_msi_init(void)
 	this_cpu_write(posted_msi_pi_desc.ndst, destination);
 }
 
+void intel_ack_posted_msi_irq(struct irq_data *irqd)
+{
+	irq_move_irq(irqd);
+	/*
+	 * Handle the rare case that irq_retrigger() raised the actual
+	 * assigned vector on the target CPU, which means that it was not
+	 * invoked via the posted MSI handler below. In that case APIC EOI
+	 * is required as otherwise the ISR entry becomes stale and lower
+	 * priority interrupts are never going to be delivered after that.
+	 *
+	 * If the posted handler invoked the device interrupt handler then
+	 * the EOI would be premature because it would acknowledge the
+	 * posted vector.
+	 */
+	if (unlikely(!this_cpu_read(posted_msi_handler_active)))
+		apic_eoi();
+}
+
 static __always_inline bool handle_pending_pir(unsigned long *pir, struct pt_regs *regs)
 {
 	unsigned long pir_copy[NR_PIR_WORDS];
@@ -439,12 +458,10 @@ static __always_inline bool handle_pendi
  */
 DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi_notification)
 {
+	struct pi_desc *pid = this_cpu_ptr(&posted_msi_pi_desc);
 	struct pt_regs *old_regs = set_irq_regs(regs);
-	struct pi_desc *pid;
-	int i = 0;
-
-	pid = this_cpu_ptr(&posted_msi_pi_desc);
 
+	this_cpu_write(posted_msi_handler_active, true);
 	inc_irq_stat(posted_msi_notification_count);
 	irq_enter();
 
@@ -453,7 +470,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi
 	 * after clearing the outstanding notification bit. Hence, at most
 	 * MAX_POSTED_MSI_COALESCING_LOOP - 1 loops are executed here.
 	 */
-	while (++i < MAX_POSTED_MSI_COALESCING_LOOP) {
+	for (int i = 1; i < MAX_POSTED_MSI_COALESCING_LOOP; i++) {
 		if (!handle_pending_pir(pid->pir, regs))
 			break;
 	}
@@ -473,6 +490,7 @@ DEFINE_IDTENTRY_SYSVEC(sysvec_posted_msi
 
 	apic_eoi();
 	irq_exit();
+	this_cpu_write(posted_msi_handler_active, false);
 	set_irq_regs(old_regs);
 }
 #endif /* X86_POSTED_MSI */
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1303,17 +1303,17 @@ static struct irq_chip intel_ir_chip = {
  *	irq_enter();
  *		handle_edge_irq()
  *			irq_chip_ack_parent()
- *				irq_move_irq(); // No EOI
+ *				intel_ack_posted_msi_irq(); // No EOI
  *			handle_irq_event()
  *				driver_handler()
  *		handle_edge_irq()
  *			irq_chip_ack_parent()
- *				irq_move_irq(); // No EOI
+ *				intel_ack_posted_msi_irq(); // No EOI
  *			handle_irq_event()
  *				driver_handler()
  *		handle_edge_irq()
  *			irq_chip_ack_parent()
- *				irq_move_irq(); // No EOI
+ *				intel_ack_posted_msi_irq(); // No EOI
  *			handle_irq_event()
  *				driver_handler()
  *	apic_eoi()
@@ -1322,7 +1322,7 @@ static struct irq_chip intel_ir_chip = {
  */
 static struct irq_chip intel_ir_chip_post_msi = {
 	.name			= "INTEL-IR-POST",
-	.irq_ack		= irq_move_irq,
+	.irq_ack		= intel_ack_posted_msi_irq,
 	.irq_set_affinity	= intel_ir_set_affinity,
 	.irq_compose_msi_msg	= intel_ir_compose_msi_msg,
 	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,


