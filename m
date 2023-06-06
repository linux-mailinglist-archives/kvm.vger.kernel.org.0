Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33D16724DAE
	for <lists+kvm@lfdr.de>; Tue,  6 Jun 2023 22:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239653AbjFFUJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 16:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbjFFUJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 16:09:07 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BBB10F3;
        Tue,  6 Jun 2023 13:09:06 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1686082144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dKfeNRDWpLHUEEC01i9Rlsx18vHA0whT8VRGD7XtedM=;
        b=xLBE8261NbfQa21cZUhMzi4zbsJZJpSuXjRrLztVj9Eo9+RaVlRlHYAG3+Wt81IgfFP9gO
        RjPvWQZZA/B2ZoDu5plQstMi9yqH+ZM+LdIs64WVmb2E9NFY/Q79mZ2IRvBV1iK6KuntJF
        IteSC6RFbrrFH9lnLMKS2uXCYIJHqG1K6aj/JvbOVLZ2vvYd+JpCyBZDv0qMiPzWVN2h24
        FoABQpRJbPNRSw7UWEZKryMgPtOLdZ9lRqTSBP7rmc5DwHkyYs+0Pbg0yNXDI3sOEXiayj
        p1LPEb2/6jIwLYjxYbiWp3vAxu6kRgQXWiF/JYu7PS08TWeEsBCyl0BRgzzr2g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1686082144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dKfeNRDWpLHUEEC01i9Rlsx18vHA0whT8VRGD7XtedM=;
        b=ZOzeXIJdsqhx4kcEoZWhZeQ+p2mmum1y7Ixvn0vCSKKuP8V/s2NuKBC2tvxNDRRbPbW5YY
        gS5bN76qyyKR5nAw==
To:     "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin3.li@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        peterz@infradead.org, andrew.cooper3@citrix.com, seanjc@google.com,
        pbonzini@redhat.com, ravi.v.shankar@intel.com,
        jiangshanlai@gmail.com, shan.kang@intel.com
Subject: Re: [PATCH v8 01/33] x86/traps: let common_interrupt() handle
 IRQ_MOVE_CLEANUP_VECTOR
In-Reply-To: <70ef07f1-e3b7-7c4e-01ac-11f159a87a6b@zytor.com>
References: <20230410081438.1750-1-xin3.li@intel.com>
 <20230410081438.1750-2-xin3.li@intel.com> <87leh08e1h.ffs@tglx>
 <87edmp6doh.ffs@tglx> <70ef07f1-e3b7-7c4e-01ac-11f159a87a6b@zytor.com>
Date:   Tue, 06 Jun 2023 22:09:03 +0200
Message-ID: <877csgl5eo.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 05 2023 at 10:09, H. Peter Anvin wrote:
> On 6/5/23 10:07, Thomas Gleixner wrote:
>> There is zero reason for this to be an IPI. This can be delegated to a
>> worker or whatever delayed mechanism.
>> 
> As we discussed offline, I agree that this is a better solution (and 
> should be a separate changeset before the FRED one.)

The untested below should do the trick. Wants to be split in several
patches, but you get the idea.

Thanks,

        tglx
---
Subject: x86/vector: Get rid of IRQ_MOVE_CLEANUP_VECTOR
From: Thomas Gleixner <tglx@linutronix.de>

No point to waste a vector for cleaning up the leftovers of a moved
interrupt. Aside of that this must be the lowest priority of all vectors
which makes FRED systems utilizing vectors 0x10-0x1f more complicated
than necessary.

Schedule a timer instead.

Not-Yet-Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/hw_irq.h       |    4 -
 arch/x86/include/asm/idtentry.h     |    1 
 arch/x86/include/asm/irq_vectors.h  |    7 ---
 arch/x86/kernel/apic/vector.c       |   83 ++++++++++++++++++++++++++----------
 arch/x86/kernel/idt.c               |    1 
 arch/x86/platform/uv/uv_irq.c       |    2 
 drivers/iommu/amd/iommu.c           |    2 
 drivers/iommu/hyperv-iommu.c        |    4 -
 drivers/iommu/intel/irq_remapping.c |    2 
 9 files changed, 68 insertions(+), 38 deletions(-)

--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -97,10 +97,10 @@ extern struct irq_cfg *irqd_cfg(struct i
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
 #ifdef CONFIG_SMP
-extern void send_cleanup_vector(struct irq_cfg *);
+extern void vector_schedule_cleanup(struct irq_cfg *);
 extern void irq_complete_move(struct irq_cfg *cfg);
 #else
-static inline void send_cleanup_vector(struct irq_cfg *c) { }
+static inline void vector_schedule_cleanup(struct irq_cfg *c) { }
 static inline void irq_complete_move(struct irq_cfg *c) { }
 #endif
 
--- a/arch/x86/include/asm/idtentry.h
+++ b/arch/x86/include/asm/idtentry.h
@@ -648,7 +648,6 @@ DECLARE_IDTENTRY_SYSVEC(X86_PLATFORM_IPI
 
 #ifdef CONFIG_SMP
 DECLARE_IDTENTRY(RESCHEDULE_VECTOR,			sysvec_reschedule_ipi);
-DECLARE_IDTENTRY_SYSVEC(IRQ_MOVE_CLEANUP_VECTOR,	sysvec_irq_move_cleanup);
 DECLARE_IDTENTRY_SYSVEC(REBOOT_VECTOR,			sysvec_reboot);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_SINGLE_VECTOR,	sysvec_call_function_single);
 DECLARE_IDTENTRY_SYSVEC(CALL_FUNCTION_VECTOR,		sysvec_call_function);
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -35,13 +35,6 @@
  */
 #define FIRST_EXTERNAL_VECTOR		0x20
 
-/*
- * Reserve the lowest usable vector (and hence lowest priority)  0x20 for
- * triggering cleanup after irq migration. 0x21-0x2f will still be used
- * for device interrupts.
- */
-#define IRQ_MOVE_CLEANUP_VECTOR		FIRST_EXTERNAL_VECTOR
-
 #define IA32_SYSCALL_VECTOR		0x80
 
 /*
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -44,7 +44,18 @@ static cpumask_var_t vector_searchmask;
 static struct irq_chip lapic_controller;
 static struct irq_matrix *vector_matrix;
 #ifdef CONFIG_SMP
-static DEFINE_PER_CPU(struct hlist_head, cleanup_list);
+
+static void vector_cleanup_callback(struct timer_list *tmr);
+
+struct vector_cleanup {
+	struct hlist_head	head;
+	struct timer_list	timer;
+};
+
+static DEFINE_PER_CPU(struct vector_cleanup, vector_cleanup) = {
+	.head	= HLIST_HEAD_INIT,
+	.timer	= __TIMER_INITIALIZER(vector_cleanup_callback, TIMER_PINNED),
+};
 #endif
 
 void lock_vector_lock(void)
@@ -843,8 +854,12 @@ void lapic_online(void)
 
 void lapic_offline(void)
 {
+	struct vector_cleanup *cl = this_cpu_ptr(&vector_cleanup);
+
 	lock_vector_lock();
 	irq_matrix_offline(vector_matrix);
+	WARN_ON_ONCE(try_to_del_timer_sync(&cl->timer) < 0);
+	WARN_ON_ONCE(!hlist_empty(&cl->head));
 	unlock_vector_lock();
 }
 
@@ -934,62 +949,86 @@ static void free_moved_vector(struct api
 	apicd->move_in_progress = 0;
 }
 
-DEFINE_IDTENTRY_SYSVEC(sysvec_irq_move_cleanup)
+static void vector_cleanup_callback(struct timer_list *tmr)
 {
-	struct hlist_head *clhead = this_cpu_ptr(&cleanup_list);
+	struct vector_cleanup *cl = container_of(tmr, typeof(*cl), timer);
 	struct apic_chip_data *apicd;
 	struct hlist_node *tmp;
+	bool rearm = false;
 
-	ack_APIC_irq();
 	/* Prevent vectors vanishing under us */
-	raw_spin_lock(&vector_lock);
+	raw_spin_lock_irq(&vector_lock);
 
-	hlist_for_each_entry_safe(apicd, tmp, clhead, clist) {
+	hlist_for_each_entry_safe(apicd, tmp, &cl->head, clist) {
 		unsigned int irr, vector = apicd->prev_vector;
 
 		/*
 		 * Paranoia: Check if the vector that needs to be cleaned
-		 * up is registered at the APICs IRR. If so, then this is
-		 * not the best time to clean it up. Clean it up in the
-		 * next attempt by sending another IRQ_MOVE_CLEANUP_VECTOR
-		 * to this CPU. IRQ_MOVE_CLEANUP_VECTOR is the lowest
-		 * priority external vector, so on return from this
-		 * interrupt the device interrupt will happen first.
+		 * up is registered at the APICs IRR. That's clearly a
+		 * hardware issue if the vector arrived on the old target
+		 * _after_ interrupts were disabled above. Keep @apicd
+		 * on the list and schedule the timer again to give the CPU
+		 * a chance to handle the pending interrupt.
 		 */
 		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
 		if (irr & (1U << (vector % 32))) {
-			apic->send_IPI_self(IRQ_MOVE_CLEANUP_VECTOR);
+			pr_warn_once("Moved interrupt pending in old target APIC %u\n", apicd->irq);
+			rearm = true;
 			continue;
 		}
 		free_moved_vector(apicd);
 	}
 
-	raw_spin_unlock(&vector_lock);
+	/*
+	 * Must happen under vector_lock to make the timer_pending() check
+	 * in __vector_schedule_cleanup() race free against the rearm here.
+	 */
+	if (rearm)
+		mod_timer(tmr, jiffies + 1);
+
+	raw_spin_unlock_irq(&vector_lock);
 }
 
-static void __send_cleanup_vector(struct apic_chip_data *apicd)
+static void __vector_schedule_cleanup(struct apic_chip_data *apicd)
 {
-	unsigned int cpu;
+	unsigned int cpu = apicd->prev_cpu;
 
 	raw_spin_lock(&vector_lock);
 	apicd->move_in_progress = 0;
-	cpu = apicd->prev_cpu;
 	if (cpu_online(cpu)) {
-		hlist_add_head(&apicd->clist, per_cpu_ptr(&cleanup_list, cpu));
-		apic->send_IPI(cpu, IRQ_MOVE_CLEANUP_VECTOR);
+		struct vector_cleanup *cl = per_cpu_ptr(&vector_cleanup, cpu);
+
+		/*
+		 * The lockless timer_pending() check is safe here. If it
+		 * returns true, then the callback will observe this new
+		 * apic data in the hlist as everything is serialized by
+		 * vector lock.
+		 *
+		 * If it returns false then the timer is either not armed
+		 * or the other CPU executes the callback, which again
+		 * would be blocked on vector lock. Rearming it in the
+		 * latter case makes it fire for nothing.
+		 *
+		 * This is also safe against the callback rearming the timer
+		 * because that's serialized via vector lock too.
+		 */
+		if (!timer_pending(&cl->timer)) {
+			cl->timer.expires = jiffies + 1;
+			add_timer_on(&cl->timer, cpu);
+		}
 	} else {
 		apicd->prev_vector = 0;
 	}
 	raw_spin_unlock(&vector_lock);
 }
 
-void send_cleanup_vector(struct irq_cfg *cfg)
+void vector_schedule_cleanup(struct irq_cfg *cfg)
 {
 	struct apic_chip_data *apicd;
 
 	apicd = container_of(cfg, struct apic_chip_data, hw_irq_cfg);
 	if (apicd->move_in_progress)
-		__send_cleanup_vector(apicd);
+		__vector_schedule_cleanup(apicd);
 }
 
 void irq_complete_move(struct irq_cfg *cfg)
@@ -1007,7 +1046,7 @@ void irq_complete_move(struct irq_cfg *c
 	 * on the same CPU.
 	 */
 	if (apicd->cpu == smp_processor_id())
-		__send_cleanup_vector(apicd);
+		__vector_schedule_cleanup(apicd);
 }
 
 /*
--- a/arch/x86/kernel/idt.c
+++ b/arch/x86/kernel/idt.c
@@ -131,7 +131,6 @@ static const __initconst struct idt_data
 	INTG(RESCHEDULE_VECTOR,			asm_sysvec_reschedule_ipi),
 	INTG(CALL_FUNCTION_VECTOR,		asm_sysvec_call_function),
 	INTG(CALL_FUNCTION_SINGLE_VECTOR,	asm_sysvec_call_function_single),
-	INTG(IRQ_MOVE_CLEANUP_VECTOR,		asm_sysvec_irq_move_cleanup),
 	INTG(REBOOT_VECTOR,			asm_sysvec_reboot),
 #endif
 
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -58,7 +58,7 @@ uv_set_irq_affinity(struct irq_data *dat
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret >= 0) {
 		uv_program_mmr(cfg, data->chip_data);
-		send_cleanup_vector(cfg);
+		vector_schedule_cleanup(cfg);
 	}
 
 	return ret;
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3639,7 +3639,7 @@ static int amd_ir_set_affinity(struct ir
 	 * at the new destination. So, time to cleanup the previous
 	 * vector allocation.
 	 */
-	send_cleanup_vector(cfg);
+	vector_schedule_cleanup(cfg);
 
 	return IRQ_SET_MASK_OK_DONE;
 }
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -51,7 +51,7 @@ static int hyperv_ir_set_affinity(struct
 	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
 		return ret;
 
-	send_cleanup_vector(cfg);
+	vector_schedule_cleanup(cfg);
 
 	return 0;
 }
@@ -257,7 +257,7 @@ static int hyperv_root_ir_set_affinity(s
 	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
 		return ret;
 
-	send_cleanup_vector(cfg);
+	vector_schedule_cleanup(cfg);
 
 	return 0;
 }
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1180,7 +1180,7 @@ intel_ir_set_affinity(struct irq_data *d
 	 * at the new destination. So, time to cleanup the previous
 	 * vector allocation.
 	 */
-	send_cleanup_vector(cfg);
+	vector_schedule_cleanup(cfg);
 
 	return IRQ_SET_MASK_OK_DONE;
 }
