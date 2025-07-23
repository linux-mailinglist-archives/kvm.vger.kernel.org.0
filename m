Return-Path: <kvm+bounces-53263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2817CB0F692
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 17:09:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 157287BCCE4
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 15:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674D32E9EAC;
	Wed, 23 Jul 2025 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xmL8YpUt";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="xVNA/Ds4"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A512E542A
	for <kvm@vger.kernel.org>; Wed, 23 Jul 2025 15:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753283343; cv=none; b=s8xrsC4+UeyFw1/rGWHZ9dpF2Ht7JAk8BIE/T8XFZuGE/TZFeMRhssmb8mrUJ90KC64RItMyvrNRBCGrgTG3TT1RGDMg7DmZOIlw3Z0v5qnhV2KcEEgS0qPZa23b3kX1x0ooP+/dJX61KMu7ODJ8Tp5GvHA/ICoFlquVokNkFMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753283343; c=relaxed/simple;
	bh=QA43XiEfOaFgJTirqmi+IbEJSZKoHJdK9IvdLikTk/4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MNN9HmkS3jUxOHCZ2a5GUB+QRnPb2KBmsE0hJWyA4A3D0jgSpakzR/XYC5LYjHKvyBfbJDxTzdJ7yx7uD10pZett0kav6gIHoI/OCeiZtPOzHQAgi40rHXnHAvIp19BaJdlTubwVNB6faQcypv5eLURmq/m8Eb+Ax6NRXww4Otg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=xmL8YpUt; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=xVNA/Ds4; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1753283339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8r9riMhOFfZQys+a565Pp4aGUvRMuwebbmYjY7dm5NA=;
	b=xmL8YpUt0xweFK60hqW5u0dyeONYsxRCihqLFYQovaX6yzPrc2HFHrITfPUblzXiWPfFUj
	49AjIl0SSAV1gbDCDnDbTvNlpG20xz2takmkIrSOvdgW7gvzzmtJm+ABLhnG3MRy7uLr5a
	fMjV/ScxEKka9d2ePCpUoUJc6j8/uwbeHZ7uQvZcPyTPkvbE9dzhTY61pGrPNbNGRHurYf
	IbMFzOdBDEEO63c8tyXi1spQt6MwSQAXtUV2LPm71fo1lrRX+VvoIibflElzGZjxuXkQHp
	IAbNUWdrdEwlrXOEsn/2uL3LQ4eJo7gnqQjVKmnDIbChZc5jOkNaAJE1lOPp+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1753283339;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8r9riMhOFfZQys+a565Pp4aGUvRMuwebbmYjY7dm5NA=;
	b=xVNA/Ds4SCgnZOX6T9E+4P7A00ZasEiys4vFDern/sjSyagjAhopri+/A1ttzI5GFK/gIm
	xbP98ogl9Zjyj2Dw==
To: Hogan Wang <hogan.wang@huawei.com>, x86@kernel.org,
 dave.hansen@linux.intel.com, kvm@vger.kernel.org,
 alex.williamson@redhat.com
Cc: weidong.huang@huawei.com, yechuan@huawei.com, hogan.wang@huawei.com,
 wangxinxin.wang@huawei.com, jianjay.zhou@huawei.com, wangjie88@huawei.com,
 Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] x86/irq: introduce repair_irq try to repair CPU vector
In-Reply-To: <20250723015045.1701-1-hogan.wang@huawei.com>
References: <20250723015045.1701-1-hogan.wang@huawei.com>
Date: Wed, 23 Jul 2025 17:08:59 +0200
Message-ID: <87frenrlkk.ffs@tglx>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Jul 23 2025 at 09:50, Hogan Wang wrote:

I have no idea what that subject line means.

> When the VM irqbalance service adjusts interrupt affinity
> frequently, the VM repeatedly masks MSI-x interrupts.

What has this to do with frequently? The point is that the interrupt is
masked at the PCI level for changing the affinity, which causes a VMEXIT
and activates the VFIO horrorshow vai QEMU.

> During the guest kernel masking MSI-x interrupts, VM exits
> to the Hypervisor.
>
> The Qemu emulator implements the switching between
> kvm_interrupt and qemu_interrupt to achieve MSI-x PBA
> capability.

What's achieved here?

> When the Qemu emulator calls the vfio_msi_set_vector_signal
> interface to switch the kvm_interrupt and qemu_interrupt
> eventfd, it releases and requests IRQs, and correspondingly
> clears and initializes the CPU Vector.
>
> When initializing the CPU Vector, if an unhandled interrupt
> in the APIC is delivered to the kernel, the __common_interrupt
> function is called to handle the interrupt.

I really don't know what that means. Documentation clearly asks you to
provide a proper description of multi-CPU race conditions.

https://www.kernel.org/doc/html/latest/process/maintainer-tip.html#patch-submission-notes

I've reverse engineered this word salad and I have to tell you that this
is not a completely VFIO specific problem. VFIO just makes it more
likely to trigger and adds some VFIO specific twist on top.

> Since the call_irq_handler function assigns vector_irq[vector]

Please use proper function annotation, i.e.:

  Since call_irq_handler() assigns...

> to VECTOR_UNUSED without lock protection, the assignment of
> vector_irq[vector] and the initialization of the CPU Vector
> are concurrent, leading to vector_irq[vector] being mistakenly
> set to VECTOR_UNUSED.

It's not mistakenly. It's the obvious consequence.

As you pointed out correctly there is no lock protection, so why not
fixing that in the first place?

> This ultimately results in the inability of VFIO passthrough
> device interrupts to be delivered, causing packet loss in
> network devices or IO hangs in disk devices.
>
> This patch detects and repairs vector_irq[vector] after the

# git grep 'This patch' Documentation/process/

> interrupt initialization is completed, ensuring that
> vector_irq[vector] can be corrected if it is mistakenly set
> to VECTOR_UNUSED.

That's a patently bad idea and does not even work under all
circumstances. See below.

> +static void x86_vector_repair(struct irq_domain *dom, struct irq_data *irqd)
> +{
> +	struct apic_chip_data *apicd = apic_chip_data(irqd);
> +	struct irq_desc *desc = irq_data_to_desc(irqd);
> +	unsigned int vector = apicd->vector;
> +	unsigned int cpu = apicd->cpu;
> +	unsigned long flags;
> +
> +	raw_spin_lock_irqsave(&vector_lock, flags);
> +	if (per_cpu(vector_irq, cpu)[vector] != desc) {
> +		per_cpu(vector_irq, cpu)[vector] = desc;
> +		pr_warn("irq %u: repair vector %u.%u\n",
> +			irqd->irq, cpu, vector);
> +	}
> +	raw_spin_unlock_irqrestore(&vector_lock, flags);
> +}

> --- a/drivers/vfio/pci/vfio_pci_intrs.c
> +++ b/drivers/vfio/pci/vfio_pci_intrs.c
> @@ -517,6 +517,8 @@ static int vfio_msi_set_vector_signal(struct vfio_pci_core_device *vdev,
>  	}
>  	ctx->trigger = trigger;
>  
> +	repair_irq(irq);
> +

How is that supposed to cure the problem completely?

Let me reverse engineer the actual problem you are trying to solve from
the breadcrumbs you provided:

	CPU0
	vmenter(vCPU0)
   	....
         msi_set_affinity()
           mask(MSI-X)
             vmexit()
        ...

        free_irq()
1         mask();        

2         __synchronize_irq()

          msi_domain_deactivate()
3           write_msg(0);
          x86_vector_deactivate()
4           per_cpu(vector_irq, cpu)[vector] = VECTOR_SHUTDOWN;
       
        request_irq()
          x86_vector_activate()
5           per_cpu(vector_irq, cpu)[vector] = desc;
	  msi_domain_deactivate()
6           write_msg(msg);
7         unmask();

After #1 the device _cannot_ raise the original vector anymore.

After #7 the device _can_ raise an interrupt on the new vector/target
         CPU pair, which might be the same as the previous one.

So the only case where this causes the problem you describe is when

  A) the device raises the old vector _before_ #1. If it raises the
     interrupt _after_ #1, the device is broken.

  B) the old target CPU is delayed handling the interrupt (interrupts
     disabled, NMI, ....)

  C) As a consequence #2 - __synchronize_irq() - cannot observe the
     interrupt handler being executed on the target CPU and x86 has no
     way to query the APIC IRR of a remote CPU to detect the delayed
     case.

  D) x86_vector_deactivate() sets vector_irq to VECTOR_SHUTDOWN

  E) the old target CPU handles the interrupt and observes
     VECTOR_SHUTDOWN and is delayed again

  F) request_irq() gets the same vector/target CPU combo back and writes
     the descriptor into vector_irq

  G) the old target CPU writes VECTOR_UNUSED

In a proper side by side flow the broken case looks like this:

	CPU0				CPU1
	vmenter(vCPU0)
   	....
         msi_set_affinity()
           mask(MSI-X)
             vmexit()
        ...                             interrupt is raised in APIC
                                        but not handled
        free_irq()
          mask();        

          __synchronize_irq()

          msi_domain_deactivate()
            write_msg(0);
          x86_vector_deactivate()
            per_cpu(vector_irq, cpu)[vector] = VECTOR_SHUTDOWN;
       
        request_irq()                   interrupt is handled and
                                        observes VECTOR_SHUTDOWN
          x86_vector_activate()
            per_cpu(vector_irq, cpu)[vector] = desc;

                                        writes VECTOR_UNUSED

	  msi_domain_deactivate()
            write_msg(msg);
          unmask();

That's the kind of analysis, which needs to be provided and is required
to understand the root cause. And if you look carefully at that
analysis, then this is even a problem for regular host side device
drivers:

	CPU0				CPU1
                                        interrupt is raised in APIC
                                        but not handled
        disable_irq_in_device();
        free_irq()
          mask();

          __synchronize_irq()

          msi_domain_deactivate()
            write_msg(0);
          x86_vector_deactivate()
            per_cpu(vector_irq, cpu)[vector] = VECTOR_SHUTDOWN;
       
        request_irq()                   interrupt is handled and
                                        observes VECTOR_SHUTDOWN
          x86_vector_activate()
            per_cpu(vector_irq, cpu)[vector] = desc;

                                        writes VECTOR_UNUSED

	  msi_domain_deactivate()
            write_msg(msg);
          unmask();
        enable_irq_in_device();

See?

Now what to do about that?

Definitely not hacking some ill defined repair function into the code,
which is neither guaranteed to work nor fixes the general problem.

Worse it exposes a functionality which should not be there in the first
place to drivers, which then go and invoke it randomly and for the very
wrong reasons.

As you described correctly, there is a lack of locking in the x86
interrupt entry code. That's the obvious thing to fix. See uncompiled
and untested patch below.

That solves the general overwrite problem _and_ does not rely on an
interrupt sent by the device right afterwards.

But it does not and _cannot_ solve the other VFIO specific problem,
which comes with free_irq()/request_irq() on an active device:

	CPU0				CPU1
	vmenter(vCPU0)
   	....
         msi_set_affinity()
           mask(MSI-X)
             vmexit()
#1      ...                             interrupt is raised in APIC
                                        but not handled
        free_irq()
          mask();        

          __synchronize_irq()

          msi_domain_deactivate()
            write_msg(0);
          x86_vector_deactivate()
            per_cpu(vector_irq, cpu)[vector] = VECTOR_SHUTDOWN;
       
#2                                      interrupt is handled and
                                        observes VECTOR_SHUTDOWN
                                        writes VECTOR_UNUSED
       request_irq()
         x86_vector_activate()
            per_cpu(vector_irq, cpu)[vector] = desc;

	  msi_domain_deactivate()
            write_msg(msg);
          unmask();

#2 discards the interrupt as spurious _after_ shutdown and acknowledges
the APIC with EOI. That means the interrupt is lost.

So when the device logic is:

        raise_interrupt()
          if (!wait_for_driver_ack)
             wait_for_driver_ack = true;
             send_msi_message();

then the device waits forever or in the best case until timeout / driver
interaction that something handles the interrupt and reads the device
status register, which clears 'wait_for_driver_ack'.

That's not a theoretical case, that's what real world hardware devices
implement. If it does not apply to your device, that does not mean that
the problem does not exist.

For a regular device driver this is a non-problem once the locking fix
is applied. But for VFIO this _is_ an unfixable problem and the magic
repair hack can't fix it either.

I've pointed out a gazillion times before, that freeing an interrupt
without quiescing the device interrupt before that, is a patently bad
idea.

Unless VFIO/QEMU has some secret magic to handle that particular case,
the brute force workaround for this is to unconditionaly inject the
interrupt in QEMU after returning from the VFIO syscall. Maybe that's
the case today already, but I can't be bothered to stare at that
code. That's an exercise left for the virt folks. If that exists, then
this want's to be explained in the change log for completeness sake and
ideally in a comment in that VFIO function.

As the fix here is x86 specific, I looked at other architectures as
well. AFAICT on a quick skim, it seems (no guarantee though) none of
them is affected by the generic issue, but _all_ of them are affected by
the VFIO specific one.

Thanks,

        tglx

---
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -256,26 +256,46 @@ static __always_inline void handle_irq(s
 		__handle_irq(desc, regs);
 }
 
-static __always_inline int call_irq_handler(int vector, struct pt_regs *regs)
+static struct irq_desc *reevaluate_vector(int vector)
 {
-	struct irq_desc *desc;
-	int ret = 0;
+	struct irq_desc *desc = __this_cpu_read(vector_irq[vector]);
+
+	if (!IS_ERR_OR_NULL(desc))
+		return desc;
+
+	if (desc == VECTOR_UNUSED) {
+		pr_emerg_ratelimited("%d.%u No irq handler for vector\n",
+				     smp_processor_id(), vector);
+	} else {
+		__this_cpu_write(vector_irq[vector], VECTOR_UNUSED);
+	}
+	return NULL;
+}
+
+static __always_inline bool call_irq_handler(int vector, struct pt_regs *regs)
+{
+	struct irq_desc *desc = __this_cpu_read(vector_irq[vector]);
 
-	desc = __this_cpu_read(vector_irq[vector]);
 	if (likely(!IS_ERR_OR_NULL(desc))) {
 		handle_irq(desc, regs);
-	} else {
-		ret = -EINVAL;
-		if (desc == VECTOR_UNUSED) {
-			pr_emerg_ratelimited("%s: %d.%u No irq handler for vector\n",
-					     __func__, smp_processor_id(),
-					     vector);
-		} else {
-			__this_cpu_write(vector_irq[vector], VECTOR_UNUSED);
-		}
+		return true;
 	}
 
-	return ret;
+	/*
+	 * Reevaluate with vector_lock held.
+	 *
+	 * FIXME: Add a big fat comment explaining the problem
+	 */
+	lock_vector_lock();
+	desc = reevaluate_vector(vector);
+	unlock_vector_lock();
+
+	if (!desc)
+		return false;
+
+	/* Using @desc is safe here as it is RCU protected */
+	handle_irq(desc, regs);
+	return true;
 }
 
 /*
@@ -289,7 +309,7 @@ DEFINE_IDTENTRY_IRQ(common_interrupt)
 	/* entry code tells RCU that we're not quiescent.  Check it. */
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "IRQ failed to wake up RCU");
 
-	if (unlikely(call_irq_handler(vector, regs)))
+	if (unlikely(!call_irq_handler(vector, regs)))
 		apic_eoi();
 
 	set_irq_regs(old_regs);

