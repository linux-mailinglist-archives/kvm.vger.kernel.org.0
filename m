Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E560946EAC3
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 16:10:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbhLIPNo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 10:13:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239294AbhLIPNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 10:13:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCFEC061746;
        Thu,  9 Dec 2021 07:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=lxBY67adLmha1Pne970fDGNjCl8CoikI/L4exsGzfnA=; b=TTxQAFmdq4aa8UNSU4H50E4cbu
        vHzDMR25ALg3s4ySldXlGM/0pOgj8j+pt0md0f0XYTUn12chEB8gUiIG/MtDJEckqKIpcvWB3COyc
        TaukxtbXzpSLYU7dgo3Que2mnbJ458bOpdeZlWEmc//f7pvspNy3lKsDusbqDQm3IjXzb0HYM7ImT
        RkSUBsKyKA5Fn27rMMEh7lOmLN2S/N7M4bTGQs7jRhM7Oz73C8mqm2D+VoX3gZbz7UWMlATR5C+7T
        VKfmQHW1QUBzKHUkWtRBJrDxfLx5xEGTn5CP1+KMcIFITbW6zfW2boK8R8utZggVVhsYWVEznfWjt
        ECOEt2vg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3K-000Noy-5I; Thu, 09 Dec 2021 15:09:46 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mvL3J-0000y7-PY; Thu, 09 Dec 2021 15:09:45 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH 06/11] x86/smpboot: Split up native_cpu_up into separate phases
Date:   Thu,  9 Dec 2021 15:09:33 +0000
Message-Id: <20211209150938.3518-7-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211209150938.3518-1-dwmw2@infradead.org>
References: <20211209150938.3518-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

There are four logical parts to what native_cpu_up() does.

First it actually wakes the AP.

Second, it waits for the AP to make it as far as wait_for_master_cpu()
which sets that CPU's bit in cpu_initialized_mask, and sets the bit in
cpu_callout_mask to let the AP proceed through cpu_init().

Then, it waits for the AP to finish cpu_init() and get as far as the
smp_callin() call, which sets that CPU's bit in cpu_callin_mask.

Finally, it does the TSC synchronization and waits for the AP to actually
mark itself online in cpu_online_mask.

This commit should have no behavioural change, but merely splits those
phases out into separate functions so that future commits can make them
happen in parallel for all APs.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/smpboot.c | 136 +++++++++++++++++++++++---------------
 1 file changed, 82 insertions(+), 54 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 99c705935f94..11ef434a93a1 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -1080,9 +1080,7 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 {
 	/* start_ip had better be page-aligned! */
 	unsigned long start_ip = real_mode_header->trampoline_start;
-
 	unsigned long boot_error = 0;
-	unsigned long timeout;
 
 	idle->thread.sp = (unsigned long)task_pt_regs(idle);
 	early_gdt_descr.address = (unsigned long)get_cpu_gdt_rw(cpu);
@@ -1135,55 +1133,70 @@ static int do_boot_cpu(int apicid, int cpu, struct task_struct *idle,
 		boot_error = wakeup_cpu_via_init_nmi(cpu, start_ip, apicid,
 						     cpu0_nmi_registered);
 
-	if (!boot_error) {
-		/*
-		 * Wait 10s total for first sign of life from AP
-		 */
-		boot_error = -1;
-		timeout = jiffies + 10*HZ;
-		while (time_before(jiffies, timeout)) {
-			if (cpumask_test_cpu(cpu, cpu_initialized_mask)) {
-				/*
-				 * Tell AP to proceed with initialization
-				 */
-				cpumask_set_cpu(cpu, cpu_callout_mask);
-				boot_error = 0;
-				break;
-			}
-			schedule();
-		}
-	}
+	return boot_error;
+}
 
-	if (!boot_error) {
-		/*
-		 * Wait till AP completes initial initialization
-		 */
-		while (!cpumask_test_cpu(cpu, cpu_callin_mask)) {
-			/*
-			 * Allow other tasks to run while we wait for the
-			 * AP to come online. This also gives a chance
-			 * for the MTRR work(triggered by the AP coming online)
-			 * to be completed in the stop machine context.
-			 */
-			schedule();
-		}
+static int do_wait_cpu_cpumask(unsigned int cpu, const struct cpumask *mask)
+{
+	unsigned long timeout;
+
+	/*
+	 * Wait up to 10s for the CPU to report in.
+	 */
+	timeout = jiffies + 10*HZ;
+	while (time_before(jiffies, timeout)) {
+		if (cpumask_test_cpu(cpu, mask))
+			return 0;
+
+		schedule();
 	}
+	return -1;
+}
 
-	if (x86_platform.legacy.warm_reset) {
-		/*
-		 * Cleanup possible dangling ends...
-		 */
-		smpboot_restore_warm_reset_vector();
+static int do_wait_cpu_initialized(unsigned int cpu)
+{
+	/*
+	 * Wait for first sign of life from AP.
+	 */
+	if (do_wait_cpu_cpumask(cpu, cpu_initialized_mask))
+		return -1;
+
+	cpumask_set_cpu(cpu, cpu_callout_mask);
+	return 0;
+}
+
+static int do_wait_cpu_callin(unsigned int cpu)
+{
+	/*
+	 * Wait till AP completes initial initialization.
+	 */
+	return do_wait_cpu_cpumask(cpu, cpu_callin_mask);
+}
+
+static int do_wait_cpu_online(unsigned int cpu)
+{
+	unsigned long flags;
+
+	/*
+	 * Check TSC synchronization with the AP (keep irqs disabled
+	 * while doing so):
+	 */
+	local_irq_save(flags);
+	check_tsc_sync_source(cpu);
+	local_irq_restore(flags);
+
+	while (!cpu_online(cpu)) {
+		cpu_relax();
+		touch_nmi_watchdog();
 	}
 
-	return boot_error;
+	return 0;
 }
 
-int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
+int do_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int apicid = apic->cpu_present_to_apicid(cpu);
 	int cpu0_nmi_registered = 0;
-	unsigned long flags;
 	int err, ret = 0;
 
 	lockdep_assert_irqs_enabled();
@@ -1230,19 +1243,6 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 		goto unreg_nmi;
 	}
 
-	/*
-	 * Check TSC synchronization with the AP (keep irqs disabled
-	 * while doing so):
-	 */
-	local_irq_save(flags);
-	check_tsc_sync_source(cpu);
-	local_irq_restore(flags);
-
-	while (!cpu_online(cpu)) {
-		cpu_relax();
-		touch_nmi_watchdog();
-	}
-
 unreg_nmi:
 	/*
 	 * Clean up the nmi handler. Do this after the callin and callout sync
@@ -1254,6 +1254,34 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
+int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
+{
+	int ret;
+
+	ret = do_cpu_up(cpu, tidle);
+	if (ret)
+		return ret;
+
+	ret = do_wait_cpu_initialized(cpu);
+	if (ret)
+		return ret;
+
+	ret = do_wait_cpu_callin(cpu);
+	if (ret)
+		return ret;
+
+	ret = do_wait_cpu_online(cpu);
+
+	if (x86_platform.legacy.warm_reset) {
+		/*
+		 * Cleanup possible dangling ends...
+		 */
+		smpboot_restore_warm_reset_vector();
+	}
+
+	return ret;
+}
+
 /**
  * arch_disable_smp_support() - disables SMP support for x86 at runtime
  */
-- 
2.31.1

