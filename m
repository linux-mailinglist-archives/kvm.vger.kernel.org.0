Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BDD69EA3E
	for <lists+kvm@lfdr.de>; Tue, 21 Feb 2023 23:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjBUWgW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Feb 2023 17:36:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjBUWgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Feb 2023 17:36:15 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0046032E72
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 14:35:51 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id l1so5725148wry.10
        for <kvm@vger.kernel.org>; Tue, 21 Feb 2023 14:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bj9CUV8vjaGL25Nfj8i8AmfUTFTRKgkfhmGgcP6GeP0=;
        b=TC2D0b0TOaTsrqR3AISAO7tU61dQWbvTtz4LgeB0fWZEnOLgO73k+im/2OkMx/B0g5
         vz+WExgAGzdWTEEj4yIQfpHssV94ebleSt7BoyR4O0N1m27YntKvBZWNBX0iSJFr5X6p
         sD0lQ2ue2MsTZuqVw2qIc6VFkQ9ZUU+wTBi+oFVP4hqVFn0RzPtJXzDiIevT1r/fxiXf
         wVAVcXaSZRglpYNrEU8id2zdlAh5ay8abEk1aWjWYCaFfAHx6wu1raAlKSy/WJW3bw6P
         4USzeF32p4gNkaWAiVJTHNBSf50SUjf8+Om5EO3RpL5ygI3afJoW0lkmoKFp5jQ+/XSg
         holA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bj9CUV8vjaGL25Nfj8i8AmfUTFTRKgkfhmGgcP6GeP0=;
        b=vzd77TjMvIlBlE3fA8BSHA9hvjUeuNP97X94U3mrBcLi/i2urNjfoLJJLF1epLKgRW
         ePUS0WPKwe8qXZCNO6AWdQ760pnPV5/MSTsKNgvAa6w6YBKPV2RJndRp06q909wGc60k
         HSriPzRQ5yOSYJx9SXTQhAv3B4k5Cp7bMU8mxBMXGJsmnHVrXziSfs+CaT0ZXSSU+06Y
         lSijqLbXavof6U4PpjVSuKAjU/ZR5zdZAmBV8By8f70YNbrdjdpgFwnIiUaOtdG7v5X7
         4BP8nnh2vhGXT7DnSxfiFzsHdIm43Syg3Nl4EHHf1bDVYbCh24hjtahfnS82JChoTCJi
         JMWw==
X-Gm-Message-State: AO0yUKXxALvoSRmas4XanbA+ftCcwMvQq4uE4wUJPU3pAsJ6NBaqBldA
        SWeyukzIUqAh6ghZ6VpytoYyDQ==
X-Google-Smtp-Source: AK7set/U0xfb/8AVvZ+CNdQo2DV3bRe0qdwf7ZyE0fjksBo8Fvw0fByrT+dwjy3keViCPcnJz6BiQg==
X-Received: by 2002:a5d:4b81:0:b0:2c4:35d:f838 with SMTP id b1-20020a5d4b81000000b002c4035df838mr5622139wrt.17.1677018950460;
        Tue, 21 Feb 2023 14:35:50 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:1a14:8be6:b3a9:a95e])
        by smtp.gmail.com with ESMTPSA id u13-20020a5d434d000000b002c55ec7f661sm4501254wrr.5.2023.02.21.14.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 14:35:50 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com
Cc:     piotrgorski@cachyos.org, oleksandr@natalenko.name,
        arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v10 8/8] x86/smpboot: Serialize topology updates for secondary bringup
Date:   Tue, 21 Feb 2023 22:33:52 +0000
Message-Id: <20230221223352.2288528-9-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230221223352.2288528-1-usama.arif@bytedance.com>
References: <20230221223352.2288528-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The toplogy update is performed by the AP via smp_callin() after the BSP
has called do_wait_cpu_initialized(), setting the AP's bit in
cpu_callout_mask to allow it to proceed.

In preparation to enable further parallelism of AP bringup, add locking to
serialize the update even if multiple APs are (in future) permitted to
proceed through the next stages of bringup in parallel.

Without such ordering (and with that future extra parallelism), confusion
ensues:

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

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
---
 arch/x86/include/asm/smp.h      |  4 +-
 arch/x86/include/asm/topology.h |  2 -
 arch/x86/kernel/cpu/common.c    |  6 +--
 arch/x86/kernel/smpboot.c       | 73 ++++++++++++++++++++-------------
 arch/x86/xen/smp_pv.c           |  4 +-
 5 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 33c0d5fd8af6..b4b29e052b6e 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -48,8 +48,6 @@ struct smp_ops {
 };
 
 /* Globals due to paravirt */
-extern void set_cpu_sibling_map(int cpu);
-
 #ifdef CONFIG_SMP
 extern struct smp_ops smp_ops;
 
@@ -137,7 +135,7 @@ void native_send_call_func_single_ipi(int cpu);
 void x86_idle_thread_init(unsigned int cpu, struct task_struct *idle);
 
 void smp_store_boot_cpu_info(void);
-void smp_store_cpu_info(int id);
+void smp_store_cpu_info(int id, bool force_single_core);
 
 asmlinkage __visible void smp_reboot_interrupt(void);
 __visible void smp_reschedule_interrupt(struct pt_regs *regs);
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 458c891a8273..4bccbd949a99 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -136,8 +136,6 @@ static inline int topology_max_smt_threads(void)
 	return __max_smt_threads;
 }
 
-int topology_update_package_map(unsigned int apicid, unsigned int cpu);
-int topology_update_die_map(unsigned int dieid, unsigned int cpu);
 int topology_phys_to_logical_pkg(unsigned int pkg);
 int topology_phys_to_logical_die(unsigned int die, unsigned int cpu);
 bool topology_is_primary_thread(unsigned int cpu);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f3cc7699e1e1..06d7f9e55d45 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1771,7 +1771,7 @@ static void generic_identify(struct cpuinfo_x86 *c)
  * Validate that ACPI/mptables have the same information about the
  * effective APIC id and update the package map.
  */
-static void validate_apic_and_package_id(struct cpuinfo_x86 *c)
+static void validate_apic_id(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	unsigned int apicid, cpu = smp_processor_id();
@@ -1782,8 +1782,6 @@ static void validate_apic_and_package_id(struct cpuinfo_x86 *c)
 		pr_err(FW_BUG "CPU%u: APIC id mismatch. Firmware: %x APIC: %x\n",
 		       cpu, apicid, c->initial_apicid);
 	}
-	BUG_ON(topology_update_package_map(c->phys_proc_id, cpu));
-	BUG_ON(topology_update_die_map(c->cpu_die_id, cpu));
 #else
 	c->logical_proc_id = 0;
 #endif
@@ -1974,7 +1972,7 @@ void identify_secondary_cpu(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_32
 	enable_sep_cpu();
 #endif
-	validate_apic_and_package_id(c);
+	validate_apic_id(c);
 	x86_spec_ctrl_setup_ap();
 	update_srbds_msr();
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index a8f52e03d55d..47093e6356de 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -180,16 +180,12 @@ static void smp_callin(void)
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
 
 	ap_init_aperfmperf();
 
@@ -243,6 +239,12 @@ static void notrace start_secondary(void *unused)
 	 * its bit in cpu_callout_mask to release it.
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
 
@@ -351,7 +353,7 @@ EXPORT_SYMBOL(topology_phys_to_logical_die);
  * @pkg:	The physical package id as retrieved via CPUID
  * @cpu:	The cpu for which this is updated
  */
-int topology_update_package_map(unsigned int pkg, unsigned int cpu)
+static int topology_update_package_map(unsigned int pkg, unsigned int cpu)
 {
 	int new;
 
@@ -374,7 +376,7 @@ int topology_update_package_map(unsigned int pkg, unsigned int cpu)
  * @die:	The die id as retrieved via CPUID
  * @cpu:	The cpu for which this is updated
  */
-int topology_update_die_map(unsigned int die, unsigned int cpu)
+static int topology_update_die_map(unsigned int die, unsigned int cpu)
 {
 	int new;
 
@@ -405,25 +407,7 @@ void __init smp_store_boot_cpu_info(void)
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
@@ -629,7 +613,7 @@ static struct sched_domain_topology_level x86_topology[] = {
  */
 static bool x86_has_numa_in_package;
 
-void set_cpu_sibling_map(int cpu)
+static void set_cpu_sibling_map(int cpu)
 {
 	bool has_smt = smp_num_siblings > 1;
 	bool has_mp = has_smt || boot_cpu_data.x86_max_cores > 1;
@@ -708,6 +692,37 @@ void set_cpu_sibling_map(int cpu)
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
index 6175f2c5c822..09f94f940689 100644
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
2.25.1

