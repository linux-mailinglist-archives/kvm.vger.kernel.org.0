Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBEDA4A6664
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 21:53:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbiBAUxv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 15:53:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBAUxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 15:53:51 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66F8C061714;
        Tue,  1 Feb 2022 12:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0xYxGRcaUzr/hvfiRvKu0N5jwZed3sOAXQn4VPcBuM4=; b=iXeoeavBtyaGAswi5Q29s5M4BC
        uTKo6kHCtOcQpY0sJOv+MZHW8bbBiTG+okRuoWrLm7+QGIHZ7teDkgXjKw+TZLRJ1ZARqu5RTeFuS
        gM+wamExkcUhCeJ4hrE/Oyb3L6AZiyi1SZldvA0Izm1mtDIQNGgdBlwo7R0iVe9Brd666avnuyGcx
        7W5V+LJk+QieirIYt1zh5MOBOJ51Aemvf70xwvqD3Tux3630b4N+sUX3mQE+dqErWK+rACFtVRE7b
        R3KhNiw2bsikvLP3Nnc3TexPNgLa4W67T2OMp/r8JEbgExma5YNoaKcj1m0VIC3UG3rxW0zYkOv4/
        NPdUa3Wg==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09b-00D5CS-Gl; Tue, 01 Feb 2022 20:53:31 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09a-001Ee0-6E; Tue, 01 Feb 2022 20:53:30 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        hushiyuan@huawei.com, luolongjun@huawei.com, hejingxian@huawei.com,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: [PATCH v4 9/9] x86/smpboot: Serialize topology updates for secondary bringup
Date:   Tue,  1 Feb 2022 20:53:28 +0000
Message-Id: <20220201205328.123066-10-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220201205328.123066-1-dwmw2@infradead.org>
References: <20220201205328.123066-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

If we bring up secondaries in parallel they might get confused unless we
impose some ordering here:

[    1.360149] x86: Booting SMP configuration:
[    1.360221] .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #8  #9 #10 #11 #12 #13 #14 #15 #16 #17 #18 #19 #20 #21 #22 #23
[    1.366225] .... node  #1, CPUs:   #24 #25 #26 #27 #28 #29 #30 #31 #32 #33 #34 #35 #36 #37 #38 #39 #40 #41 #42 #43 #44 #45 #46 #47
[    1.370219] .... node  #0, CPUs:   #48 #49 #50 #51 #52 #53 #54 #55 #56 #57 #58 #59 #60 #61 #62 #63 #64 #65 #66 #67 #68 #69 #70 #71
[    1.378226] .... node  #1, CPUs:   #72 #73 #74 #75 #76 #77 #78 #79 #80 #81 #82 #83 #84 #85 #86 #87 #88 #89 #90 #91 #92 #93 #94 #95
[    1.382037] Brought 96 CPUs to x86/cpu:kick in 72232606 cycles
[    0.104104] smpboot: CPU 26 Converting physical 0 to logical die 1
[    0.104104] smpboot: CPU 27 Converting physical 1 to logical package 2
[    0.104104] smpboot: CPU 24 Converting physical 1 to logical package 3
[    0.104104] smpboot: CPU 27 Converting physical 0 to logical die 2
[    0.104104] smpboot: CPU 25 Converting physical 1 to logical package 4
[    1.385609] Brought 96 CPUs to x86/cpu:wait-init in 9269218 cycles
[    1.395285] Brought CPUs online in 28930764 cycles
[    1.395469] smp: Brought up 2 nodes, 96 CPUs
[    1.395689] smpboot: Max logical packages: 2
[    1.396222] smpboot: Total of 96 processors activated (576000.00 BogoMIPS)

Do the full topology update in smp_store_cpu_info() under a spinlock
to ensure that things remain consistent.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/smp.h      |  4 +-
 arch/x86/include/asm/topology.h |  2 -
 arch/x86/kernel/cpu/common.c    |  6 +--
 arch/x86/kernel/smpboot.c       | 73 ++++++++++++++++++++-------------
 arch/x86/xen/smp_pv.c           |  4 +-
 5 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4fe1320c2e8d..1df2951ca0bd 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -59,8 +59,6 @@ struct smp_ops {
 };
 
 /* Globals due to paravirt */
-extern void set_cpu_sibling_map(int cpu);
-
 #ifdef CONFIG_SMP
 extern struct smp_ops smp_ops;
 
@@ -148,7 +146,7 @@ void native_send_call_func_single_ipi(int cpu);
 void x86_idle_thread_init(unsigned int cpu, struct task_struct *idle);
 
 void smp_store_boot_cpu_info(void);
-void smp_store_cpu_info(int id);
+void smp_store_cpu_info(int id, bool force_single_core);
 
 asmlinkage __visible void smp_reboot_interrupt(void);
 __visible void smp_reschedule_interrupt(struct pt_regs *regs);
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 2f0b6be8eaab..a4e14ae3f1e1 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -135,8 +135,6 @@ static inline int topology_max_smt_threads(void)
 	return __max_smt_threads;
 }
 
-int topology_update_package_map(unsigned int apicid, unsigned int cpu);
-int topology_update_die_map(unsigned int dieid, unsigned int cpu);
 int topology_phys_to_logical_pkg(unsigned int pkg);
 int topology_phys_to_logical_die(unsigned int die, unsigned int cpu);
 bool topology_is_primary_thread(unsigned int cpu);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7b8382c11788..623b910971e1 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1517,7 +1517,7 @@ static void generic_identify(struct cpuinfo_x86 *c)
  * Validate that ACPI/mptables have the same information about the
  * effective APIC id and update the package map.
  */
-static void validate_apic_and_package_id(struct cpuinfo_x86 *c)
+static void validate_apic_id(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	unsigned int apicid, cpu = smp_processor_id();
@@ -1528,8 +1528,6 @@ static void validate_apic_and_package_id(struct cpuinfo_x86 *c)
 		pr_err(FW_BUG "CPU%u: APIC id mismatch. Firmware: %x APIC: %x\n",
 		       cpu, apicid, c->initial_apicid);
 	}
-	BUG_ON(topology_update_package_map(c->phys_proc_id, cpu));
-	BUG_ON(topology_update_die_map(c->cpu_die_id, cpu));
 #else
 	c->logical_proc_id = 0;
 #endif
@@ -1716,7 +1714,7 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 	enable_sep_cpu();
 #endif
 	mtrr_ap_init();
-	validate_apic_and_package_id(c);
+	validate_apic_id(c);
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
 }
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e0ae7ee18d34..147eedd93329 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -190,16 +190,12 @@ static void smp_callin(void)
 	apic_ap_setup();
 
 	/*
-	 * Save our processor parameters. Note: this information
-	 * is needed for clock calibration.
-	 */
-	smp_store_cpu_info(cpuid);
-
-	/*
+	 * Save our processor parameters and update topology.
+	 * Note: this information is needed for clock calibration.
 	 * The topology information must be up to date before
 	 * calibrate_delay() and notify_cpu_starting().
 	 */
-	set_cpu_sibling_map(raw_smp_processor_id());
+	smp_store_cpu_info(cpuid, false);
 
 	init_freq_invariance(true, false);
 
@@ -254,6 +250,12 @@ static void notrace start_secondary(void *unused)
 	 * smp_callout_mask to release them.
 	 */
 	cpu_init_secondary();
+
+	/*
+	 * Even though notify_cpu_starting() will do this, it does so too late
+	 * as the AP may already have triggered lockdep splats by then. See
+	 * commit 29368e093 ("x86/smpboot:  Move rcu_cpu_starting() earlier").
+	 */
 	rcu_cpu_starting(raw_smp_processor_id());
 	x86_cpuinit.early_percpu_clock_init();
 
@@ -362,7 +364,7 @@ EXPORT_SYMBOL(topology_phys_to_logical_die);
  * @pkg:	The physical package id as retrieved via CPUID
  * @cpu:	The cpu for which this is updated
  */
-int topology_update_package_map(unsigned int pkg, unsigned int cpu)
+static int topology_update_package_map(unsigned int pkg, unsigned int cpu)
 {
 	int new;
 
@@ -385,7 +387,7 @@ int topology_update_package_map(unsigned int pkg, unsigned int cpu)
  * @die:	The die id as retrieved via CPUID
  * @cpu:	The cpu for which this is updated
  */
-int topology_update_die_map(unsigned int die, unsigned int cpu)
+static int topology_update_die_map(unsigned int die, unsigned int cpu)
 {
 	int new;
 
@@ -416,25 +418,7 @@ void __init smp_store_boot_cpu_info(void)
 	c->initialized = true;
 }
 
-/*
- * The bootstrap kernel entry code has set these up. Save them for
- * a given CPU
- */
-void smp_store_cpu_info(int id)
-{
-	struct cpuinfo_x86 *c = &cpu_data(id);
-
-	/* Copy boot_cpu_data only on the first bringup */
-	if (!c->initialized)
-		*c = boot_cpu_data;
-	c->cpu_index = id;
-	/*
-	 * During boot time, CPU0 has this setup already. Save the info when
-	 * bringing up AP or offlined CPU0.
-	 */
-	identify_secondary_cpu(c);
-	c->initialized = true;
-}
+static arch_spinlock_t topology_lock = __ARCH_SPIN_LOCK_UNLOCKED;
 
 static bool
 topology_same_node(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
@@ -640,7 +624,7 @@ static struct sched_domain_topology_level x86_topology[] = {
  */
 static bool x86_has_numa_in_package;
 
-void set_cpu_sibling_map(int cpu)
+static void set_cpu_sibling_map(int cpu)
 {
 	bool has_smt = smp_num_siblings > 1;
 	bool has_mp = has_smt || boot_cpu_data.x86_max_cores > 1;
@@ -719,6 +703,37 @@ void set_cpu_sibling_map(int cpu)
 	}
 }
 
+/*
+ * The bootstrap kernel entry code has set these up. Save them for
+ * a given CPU
+ */
+void smp_store_cpu_info(int id, bool force_single_core)
+{
+	struct cpuinfo_x86 *c = &cpu_data(id);
+
+	/* Copy boot_cpu_data only on the first bringup */
+	if (!c->initialized)
+		*c = boot_cpu_data;
+	c->cpu_index = id;
+	/*
+	 * During boot time, CPU0 has this setup already. Save the info when
+	 * bringing up AP or offlined CPU0.
+	 */
+	identify_secondary_cpu(c);
+
+	arch_spin_lock(&topology_lock);
+	BUG_ON(topology_update_package_map(c->phys_proc_id, id));
+	BUG_ON(topology_update_die_map(c->cpu_die_id, id));
+	c->initialized = true;
+
+	/* For Xen PV */
+	if (force_single_core)
+		c->x86_max_cores = 1;
+
+	set_cpu_sibling_map(id);
+	arch_spin_unlock(&topology_lock);
+}
+
 /* maps the cpu to the sched domain representing multi-core */
 const struct cpumask *cpu_coregroup_mask(int cpu)
 {
diff --git a/arch/x86/xen/smp_pv.c b/arch/x86/xen/smp_pv.c
index 6a8f3b53ab83..ff37dff20dc0 100644
--- a/arch/x86/xen/smp_pv.c
+++ b/arch/x86/xen/smp_pv.c
@@ -71,9 +71,7 @@ static void cpu_bringup(void)
 		xen_enable_syscall();
 	}
 	cpu = smp_processor_id();
-	smp_store_cpu_info(cpu);
-	cpu_data(cpu).x86_max_cores = 1;
-	set_cpu_sibling_map(cpu);
+	smp_store_cpu_info(cpu, true);
 
 	speculative_store_bypass_ht_init();
 
-- 
2.33.1

