Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A59F03754A6
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhEFNWp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbhEFNWi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 09:22:38 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849CCC061574;
        Thu,  6 May 2021 06:21:40 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620307297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=k3SAmK6PNHm2b2zFkrHARkJbvGAqBIerSBhAmmsNkFM=;
        b=OApNYyCD6aEdUkgUnti0+ogPOHAugcEFF8S9McbFYvTz4yS+6tx6RGxzKkSChnkU0qfOUj
        sYjDxz0ejpaXyQDVlinDUEExWHfkLn+3DIobnheS+9ylYYmGpsgeTrsBVjduAG90bHO3P8
        0tvijCl7Z+TNU1atlcnPQrPwB1frehR93OI8IveIMaqQaJeXdiJa9QTF5UE742LLgIUsQT
        /9mND3Jv2DbE4MaOWSObmNff1Bh1B84a2t/VPgyp56VCkg6q5sICWO1UcradqkJE3Ox6tE
        32XDhqKt+f7XIdFWoHgw/YQJWKBrbD2v8nUv81k5rtDBJQTdk4xbGGcy8pt3cQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620307297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=k3SAmK6PNHm2b2zFkrHARkJbvGAqBIerSBhAmmsNkFM=;
        b=5HVx8sqEMjvqJ0Z615RK83KbwMf3vhMjvfhE20dwTHjYH2pvEai0C12uGtEFElVI3MYoxT
        XdZbaO3+A7uweiBQ==
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: KVM: x86: Prevent deadlock against tk_core.seq
Date:   Thu, 06 May 2021 15:21:37 +0200
Message-ID: <87h7jgm1zy.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

syzbot reported a possible deadlock in pvclock_gtod_notify():

CPU 0  		  	   	    	    CPU 1
write_seqcount_begin(&tk_core.seq);
  pvclock_gtod_notify()			    spin_lock(&pool->lock);
    queue_work(..., &pvclock_gtod_work)	    ktime_get()
     spin_lock(&pool->lock);		      do {
     						seq = read_seqcount_begin(tk_core.seq)
						...
				              } while (read_seqcount_retry(&tk_core.seq, seq);

While this is unlikely to happen, it's possible.

Delegate queue_work() to irq_work() which postpones it until the
tk_core.seq write held region is left and interrupts are reenabled.

Fixes: 16e8d74d2da9 ("KVM: x86: notifier for clocksource changes")
Reported-by: syzbot+6beae4000559d41d80f8@syzkaller.appspotmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
Link: https://lore.kernel.org/r/0000000000001d43ac05c0f5c6a0@google.com
---
 arch/x86/kvm/x86.c |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8040,6 +8040,18 @@ static void pvclock_gtod_update_fn(struc
 static DECLARE_WORK(pvclock_gtod_work, pvclock_gtod_update_fn);
 
 /*
+ * Indirection to move queue_work() out of the tk_core.seq write held
+ * region to prevent possible deadlocks against time accessors which
+ * are invoked with work related locks held.
+ */
+static void pvclock_irq_work_fn(struct irq_work *w)
+{
+	queue_work(system_long_wq, &pvclock_gtod_work);
+}
+
+static DEFINE_IRQ_WORK(pvclock_irq_work, pvclock_irq_work_fn);
+
+/*
  * Notification about pvclock gtod data update.
  */
 static int pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
@@ -8050,13 +8062,14 @@ static int pvclock_gtod_notify(struct no
 
 	update_pvclock_gtod(tk);
 
-	/* disable master clock if host does not trust, or does not
-	 * use, TSC based clocksource.
+	/*
+	 * Disable master clock if host does not trust, or does not use,
+	 * TSC based clocksource. Delegate queue_work() to irq_work as
+	 * this is invoked with tk_core.seq write held.
 	 */
 	if (!gtod_is_based_on_tsc(gtod->clock.vclock_mode) &&
 	    atomic_read(&kvm_guest_has_master_clock) != 0)
-		queue_work(system_long_wq, &pvclock_gtod_work);
-
+		irq_work_queue(&pvclock_irq_work);
 	return 0;
 }
 
@@ -8168,6 +8181,7 @@ void kvm_arch_exit(void)
 	cpuhp_remove_state_nocalls(CPUHP_AP_X86_KVM_CLK_ONLINE);
 #ifdef CONFIG_X86_64
 	pvclock_gtod_unregister_notifier(&pvclock_gtod_notifier);
+	irq_work_sync(&pvclock_irq_work);
 	cancel_work_sync(&pvclock_gtod_work);
 #endif
 	kvm_x86_ops.hardware_enable = NULL;
