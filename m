Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520FB475B28
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 15:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243609AbhLOO52 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 09:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243624AbhLOO5A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 09:57:00 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F150C061401;
        Wed, 15 Dec 2021 06:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=lhHn2kiA8oUwFBYVA6aNjog75ME7409J8cIOPHIQIpI=; b=lUQPyR4MiG9Yw4CsE31SxFtqB0
        GsFhRFTnq41iFyE+qmzWtehWFay53VKh6Yv6BoPE6vP0Tn3pl+rU6m7DqvcINHAMh25O2JCedRUk5
        8bCs8DVgHYvQPYPni9n+vPQ4U2Pk0NDul2j5kQNOKb3ffiEN4+eqQqgjNQ1lqhigzBO8bSlX1/ssd
        yaYtcAwi6C6N0s00F3vnYrBxhNBZ0Ni9eyMVEAtHatB7VkKbQjU/jRl11xpafw/CR+4nDifQuK/mt
        QEVfR30sUh5ZKTUV5qrN8U5Udqma6chc4+JurUVGf31lHc+LwUA0gXYBW0m4yeSGCKBCTTol/0KyD
        g69jgfdg==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxVhr-001WOw-MF; Wed, 15 Dec 2021 14:56:35 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mxVhr-0001O4-Be; Wed, 15 Dec 2021 14:56:35 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com
Subject: [PATCH v3 7/9] x86/smpboot: Send INIT/SIPI/SIPI to secondary CPUs in parallel
Date:   Wed, 15 Dec 2021 14:56:31 +0000
Message-Id: <20211215145633.5238-8-dwmw2@infradead.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211215145633.5238-1-dwmw2@infradead.org>
References: <20211215145633.5238-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

When the APs can find their own APIC ID without assistance, we can do
the AP bringup in parallel.

Register a CPUHP_BP_PARALLEL_DYN stage "x86/cpu:kick" which just calls
do_boot_cpu() to deliver INIT/SIPI/SIPI to each AP in turn before the
normal native_cpu_up() does the rest of the hand-holding.

The APs will then take turns through the real mode code (which has its
own bitlock for exclusion) until they make it to their own stack, then
proceed through the first few lines of start_secondary() and execute
these parts in parallel:

 start_secondary()
    -> cr4_init()
    -> (some 32-bit only stuff so not in the parallel cases)
    -> cpu_init_secondary()
       -> cpu_init_exception_handling()
       -> cpu_init()
          -> wait_for_master_cpu()

At this point they wait for the BSP to set their bit in cpu_callout_mask
(from do_wait_cpu_initialized()), and release them to continue through
the rest of cpu_init() and beyond.

This reduces the time taken for bringup on my 28-thread Haswell system
from about 120ms to 80ms. On a socket 96-thread Skylake it takes the
bringup time from 500ms to 100ms.

There is more speedup to be had by doing the remaining parts in parallel
too — especially notify_cpu_starting() in which the AP takes itself
through all the stages from CPUHP_BRINGUP_CPU to CPUHP_ONLINE. But those
require careful auditing to ensure they are reentrant, before we can go
that far.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/smpboot.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 1e38d44c3603..d194116305a7 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -57,6 +57,7 @@
 #include <linux/pgtable.h>
 #include <linux/overflow.h>
 #include <linux/syscore_ops.h>
+#include <linux/smpboot.h>
 
 #include <asm/acpi.h>
 #include <asm/desc.h>
@@ -1309,13 +1310,26 @@ int do_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
+static bool do_parallel_bringup = true;
+
+static int __init no_parallel_bringup(char *str)
+{
+	do_parallel_bringup = false;
+
+	return 0;
+}
+early_param("no_parallel_bringup", no_parallel_bringup);
+
 int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 
-	ret = do_cpu_up(cpu, tidle);
-	if (ret)
-		return ret;
+	/* If parallel AP bringup isn't enabled, perform the first steps now. */
+	if (!do_parallel_bringup) {
+		ret = do_cpu_up(cpu, tidle);
+		if (ret)
+			return ret;
+	}
 
 	ret = do_wait_cpu_initialized(cpu);
 	if (ret)
@@ -1337,6 +1351,12 @@ int native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
+/* Bringup step one: Send INIT/SIPI to the target AP */
+static int native_cpu_kick(unsigned int cpu)
+{
+	return do_cpu_up(cpu, idle_thread_get(cpu));
+}
+
 /**
  * arch_disable_smp_support() - disables SMP support for x86 at runtime
  */
@@ -1515,6 +1535,17 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 	smp_quirk_init_udelay();
 
 	speculative_store_bypass_ht_init();
+
+	/*
+	 * We can do 64-bit AP bringup in parallel if the CPU reports its
+	 * APIC ID in CPUID leaf 0x0B. Otherwise it's too hard.
+	 */
+	if (IS_ENABLED(CONFIG_X86_32) || boot_cpu_data.cpuid_level < 0x0B)
+		do_parallel_bringup = false;
+
+	if (do_parallel_bringup)
+		cpuhp_setup_state_nocalls(CPUHP_BP_PARALLEL_DYN, "x86/cpu:kick",
+					  native_cpu_kick, NULL);
 }
 
 void arch_thaw_secondary_cpus_begin(void)
-- 
2.31.1

