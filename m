Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F506A80DE
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 12:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCBLNq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 06:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbjCBLNW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 06:13:22 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9F648E35
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 03:12:42 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id bx12so12979089wrb.11
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 03:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aU6X+IkB1tYCm8FSmx7Fnspq3CSVi+8kgBfodr0YJNA=;
        b=UtNZZZsECpfETa2HZk0JkfvVTXpd4JBZbQzNb+H9hBukNN6PWMr53LTT2t161qAIGV
         5u2ZuyQPGD24Dkr/6vpqRnrZQ5CrWUSIhyoys5P0aw+i9Vr7YGpJfE0xXfWIgikPytUp
         lYZ1ZbQJkExeRotW8MRu1Po9vAqxMLmRSxanrkFl14QH+s1O2Ezgx7JutU98D0r2mkQo
         x6m543I2bpxZ47hgRIZBydAMjkkV3gnO8BU7+toyYuLC8wbUB/C07loxxhDXYItyZkGX
         hSoK2Utegdtfn/RNIzuYSY51YOyE6q0oOO/T/vMT4nWMfVUsGdkOfljpnj23cNZlUYbt
         L06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aU6X+IkB1tYCm8FSmx7Fnspq3CSVi+8kgBfodr0YJNA=;
        b=u2ABlbc11xqUWyH4+JPScMZWVH6Xb5x57rwp6aYmNjXD+UyaAmgqQfvZbUaCmphvOq
         1lAxV6tu+fT9r5b4h/Idj7flGVuWsulOuTRFxDhqF6I76yDNbGTsJoJr3OMrodgGcAjC
         Xoz4m0SK4DhYyqi/kRUqvrTWyCUSgYP7EZM4TAwTCLt241qApnA1Wh77KolZ6A0e9QTx
         hvN9QSQ7VGGwvVMk68uR76phxr7Eik5peyY584NaSCvpNRTVWSNuXuquadVx8+xvYu6L
         odhA2KTW0IIqe6WT/snC6HxAYYsk4BGHxC2MqkH4CrBEgwwFGfMY/Rzqo2amDbzcouIX
         F9Ug==
X-Gm-Message-State: AO0yUKUXq+8BmsPLgDgN9H1yjSyPXumZ+OAGXhgmZDf8FzywKLQRXpXL
        XmNFdJFM3Na2prC5v+Aq1JxZ5o733LB48ucm
X-Google-Smtp-Source: AK7set/U5c+kGLKANw9hVtu5/4pTHILF1cTzwQGX0d9HxQRL8AISXJNbcTCPyfC14xYlN+cSefJRWQ==
X-Received: by 2002:a5d:50c5:0:b0:2c9:e34e:7cd with SMTP id f5-20020a5d50c5000000b002c9e34e07cdmr7427320wrt.32.1677755561488;
        Thu, 02 Mar 2023 03:12:41 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:11aa:3c13:d3e:eb29])
        by smtp.gmail.com with ESMTPSA id a5-20020a5d4565000000b002c3f81c51b6sm14724830wrc.90.2023.03.02.03.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:12:41 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com,
        brgerst@gmail.com
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
        Usama Arif <usama.arif@bytedance.com>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH v13 11/11] x86/smpboot: Serialize topology updates for secondary bringup
Date:   Thu,  2 Mar 2023 11:12:27 +0000
Message-Id: <20230302111227.2102545-12-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230302111227.2102545-1-usama.arif@bytedance.com>
References: <20230302111227.2102545-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/x86/include/asm/smp.h      |  4 +-
 arch/x86/include/asm/topology.h |  2 -
 arch/x86/kernel/cpu/common.c    |  6 +--
 arch/x86/kernel/smpboot.c       | 73 ++++++++++++++++++++-------------
 arch/x86/xen/smp_pv.c           |  4 +-
 5 files changed, 48 insertions(+), 41 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 1cf4f1e57570..defe76ee9e64 100644
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
index 711573cd9b87..9d956571ecc1 100644
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

