Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 153FA697ED9
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 15:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjBOOzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 09:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjBOOzB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 09:55:01 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB5A39CC6
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:54:31 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id co8so15678608wrb.1
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 06:54:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=davZpZrHKqcK9/fGgGK/yHqe9BiOZs8yrjIgwy5MeSU=;
        b=5S3dXQ2q8rFnOsuNvry/KzR1D7Nr4TML7MUZ95MT7I+s/DI/sVyPytbPWT1SkdpEjP
         d3UC+1f6pWD4PtLrJAvr2jLC8hYzDyzpMEPA1OUED67bozktxRzSYAWKb4zvWebuAwj0
         OoaJpq31a2148TSNqGXBe0orWUHSJhHptaISIHXMYjftSk6hApezB72heFNgsvyMAiDh
         gb1e2dXMysjKNzHSSDhCEFLOep8fHJxetIZzFc9FMZl2qU4prOYVmK2nJwHrBVetmpTx
         0qbyIH6pdaZ6THJapfZiYBUouiqnCGztX/qKqPH0K1m91QQyxMfOghVGQUOpnywgDx5/
         SKKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=davZpZrHKqcK9/fGgGK/yHqe9BiOZs8yrjIgwy5MeSU=;
        b=TQQM8uUzmntPaA8iVx1gJM7/Snpz6dWiPpwV0s/7lcHYiBorq4KskrAcEC44hgX+id
         jGIXDcaPOkgOQ/0Gg7PVxDxF1gcttEZ8EkCmFsRn01jO5cF1EvUpVqt3gXBRgDxcA4ba
         KA9fSiZGXlCVVmlXfIM/O10ycGvY3JmJcRgMp78bw4Yza3WOHCFhma4I/KzbXXpol3tQ
         ySsDvVsn8Q8TH5HCy5PuQIgYCFKjkvSjFi/Ff+vwvKY1lsJdtMVBTaZeghoVHd6BKjq0
         f8XF69067GgSChGXVssEY/2mSzYwYtW4s+hBOir5bKFdDmwJ6r858PsW6pj/PwrqAYpQ
         vseQ==
X-Gm-Message-State: AO0yUKWbAE3rxvB0E4HBjlwPR2IOnOhwuAsgZrK6IhH8sF9+9s7YujGE
        C1qH4eG9UtqpcZgUAdf+ya7jIw==
X-Google-Smtp-Source: AK7set9bmBlb+d8LePHD9fRGUiRQiTwi4t+2xvWZFzuYkMy7+BxsVk/DhQlYDoa4gn7i0lYsBf2kuQ==
X-Received: by 2002:adf:e701:0:b0:2c5:5331:5516 with SMTP id c1-20020adfe701000000b002c553315516mr1952908wrm.51.1676472869918;
        Wed, 15 Feb 2023 06:54:29 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8487:6a9a:3a67:11aa])
        by smtp.gmail.com with ESMTPSA id t13-20020adfe44d000000b002c557f82e27sm8495508wrm.99.2023.02.15.06.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 06:54:29 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de, kim.phillips@amd.com
Cc:     arjan@linux.intel.com, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, x86@kernel.org,
        pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com,
        David Woodhouse <dwmw@amazon.co.uk>,
        Usama Arif <usama.arif@bytedance.com>
Subject: [PATCH v9 1/8] x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
Date:   Wed, 15 Feb 2023 14:54:18 +0000
Message-Id: <20230215145425.420125-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230215145425.420125-1-usama.arif@bytedance.com>
References: <20230215145425.420125-1-usama.arif@bytedance.com>
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

Each of the sibling CPUs in a cluster uses the same clustermask. The first
CPU in a cluster will need a new clustermask allocated, while subsequent
siblings will use the same clustermask as the first.

However, the CPU being brought up cannot yet perform memory allocations
at the point that this occurs in init_x2apic_ldr().

So at present, the alloc_clustermask() function allocates a clustermask
just in case it's needed, storing it in the global cluster_hotplug_mask.
A CPU which is the first sibling of a cluster will "take" it from there
and set cluster_hotplug_mask to NULL, in order for alloc_clustermask()
to allocate a new one before bringing up the next CPU.

To facilitate parallel bringup of CPUs in future, switch to a model
where alloc_clustermask() prepopulates the clustermask in the per_cpu
data for each present CPU in the cluster in advance. All that the CPU
needs to do for itself in init_x2apic_ldr() is set its own bit in that
mask.

The 'node' and 'clusterid' members of struct cluster_mask are thus
redundant, and it can become a simple struct cpumask instead.

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c | 130 +++++++++++++++++---------
 1 file changed, 84 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index e696e22d0531..d8f513a2287b 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -9,11 +9,7 @@
 
 #include "local.h"
 
-struct cluster_mask {
-	unsigned int	clusterid;
-	int		node;
-	struct cpumask	mask;
-};
+#define apic_cluster(apicid) ((apicid) >> 4)
 
 /*
  * __x2apic_send_IPI_mask() possibly needs to read
@@ -23,8 +19,7 @@ struct cluster_mask {
 static u32 *x86_cpu_to_logical_apicid __read_mostly;
 
 static DEFINE_PER_CPU(cpumask_var_t, ipi_mask);
-static DEFINE_PER_CPU_READ_MOSTLY(struct cluster_mask *, cluster_masks);
-static struct cluster_mask *cluster_hotplug_mask;
+static DEFINE_PER_CPU_READ_MOSTLY(struct cpumask *, cluster_masks);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
@@ -60,10 +55,10 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 
 	/* Collapse cpus in a cluster so a single IPI per cluster is sent */
 	for_each_cpu(cpu, tmpmsk) {
-		struct cluster_mask *cmsk = per_cpu(cluster_masks, cpu);
+		struct cpumask *cmsk = per_cpu(cluster_masks, cpu);
 
 		dest = 0;
-		for_each_cpu_and(clustercpu, tmpmsk, &cmsk->mask)
+		for_each_cpu_and(clustercpu, tmpmsk, cmsk)
 			dest |= x86_cpu_to_logical_apicid[clustercpu];
 
 		if (!dest)
@@ -71,7 +66,7 @@ __x2apic_send_IPI_mask(const struct cpumask *mask, int vector, int apic_dest)
 
 		__x2apic_send_IPI_dest(dest, vector, APIC_DEST_LOGICAL);
 		/* Remove cluster CPUs from tmpmask */
-		cpumask_andnot(tmpmsk, tmpmsk, &cmsk->mask);
+		cpumask_andnot(tmpmsk, tmpmsk, cmsk);
 	}
 
 	local_irq_restore(flags);
@@ -105,55 +100,98 @@ static u32 x2apic_calc_apicid(unsigned int cpu)
 
 static void init_x2apic_ldr(void)
 {
-	struct cluster_mask *cmsk = this_cpu_read(cluster_masks);
-	u32 cluster, apicid = apic_read(APIC_LDR);
-	unsigned int cpu;
+	struct cpumask *cmsk = this_cpu_read(cluster_masks);
 
-	x86_cpu_to_logical_apicid[smp_processor_id()] = apicid;
+	BUG_ON(!cmsk);
 
-	if (cmsk)
-		goto update;
-
-	cluster = apicid >> 16;
-	for_each_online_cpu(cpu) {
-		cmsk = per_cpu(cluster_masks, cpu);
-		/* Matching cluster found. Link and update it. */
-		if (cmsk && cmsk->clusterid == cluster)
-			goto update;
+	cpumask_set_cpu(smp_processor_id(), cmsk);
+}
+
+/*
+ * As an optimisation during boot, set the cluster_mask for all present
+ * CPUs at once, to prevent each of them having to iterate over the others
+ * to find the existing cluster_mask.
+ */
+static void prefill_clustermask(struct cpumask *cmsk, unsigned int cpu, u32 cluster)
+{
+	int cpu_i;
+
+	for_each_present_cpu(cpu_i) {
+		struct cpumask **cpu_cmsk = &per_cpu(cluster_masks, cpu_i);
+		u32 apicid = apic->cpu_present_to_apicid(cpu_i);
+
+		if (apicid == BAD_APICID || cpu_i == cpu || apic_cluster(apicid) != cluster)
+			continue;
+
+		if (WARN_ON_ONCE(*cpu_cmsk == cmsk))
+			continue;
+
+		BUG_ON(*cpu_cmsk);
+		*cpu_cmsk = cmsk;
 	}
-	cmsk = cluster_hotplug_mask;
-	cmsk->clusterid = cluster;
-	cluster_hotplug_mask = NULL;
-update:
-	this_cpu_write(cluster_masks, cmsk);
-	cpumask_set_cpu(smp_processor_id(), &cmsk->mask);
 }
 
-static int alloc_clustermask(unsigned int cpu, int node)
+static int alloc_clustermask(unsigned int cpu, u32 cluster, int node)
 {
+	struct cpumask *cmsk = NULL;
+	unsigned int cpu_i;
+
+	/*
+	 * At boot time, the CPU present mask is stable. The cluster mask is
+	 * allocated for the first CPU in the cluster and propagated to all
+	 * present siblings in the cluster. If the cluster mask is already set
+	 * on entry to this function for a given CPU, there is nothing to do.
+	 */
 	if (per_cpu(cluster_masks, cpu))
 		return 0;
+
+	if (system_state < SYSTEM_RUNNING)
+		goto alloc;
+
 	/*
-	 * If a hotplug spare mask exists, check whether it's on the right
-	 * node. If not, free it and allocate a new one.
+	 * On post boot hotplug for a CPU which was not present at boot time,
+	 * iterate over all possible CPUs (even those which are not present
+	 * any more) to find any existing cluster mask.
 	 */
-	if (cluster_hotplug_mask) {
-		if (cluster_hotplug_mask->node == node)
-			return 0;
-		kfree(cluster_hotplug_mask);
+	for_each_possible_cpu(cpu_i) {
+		u32 apicid = apic->cpu_present_to_apicid(cpu_i);
+
+		if (apicid != BAD_APICID && apic_cluster(apicid) == cluster) {
+			cmsk = per_cpu(cluster_masks, cpu_i);
+			/*
+			 * If the cluster is already initialized, just store
+			 * the mask and return. There's no need to propagate.
+			 */
+			if (cmsk) {
+				per_cpu(cluster_masks, cpu) = cmsk;
+				return 0;
+			}
+		}
 	}
-
-	cluster_hotplug_mask = kzalloc_node(sizeof(*cluster_hotplug_mask),
-					    GFP_KERNEL, node);
-	if (!cluster_hotplug_mask)
-		return -ENOMEM;
-	cluster_hotplug_mask->node = node;
-	return 0;
+	/*
+	 * No CPU in the cluster has ever been initialized, so fall through to
+	 * the boot time code which will also populate the cluster mask for any
+	 * other CPU in the cluster which is (now) present.
+	 */
+ alloc:
+	cmsk = kzalloc_node(sizeof(*cmsk), GFP_KERNEL, node);
+	if (!cmsk)
+ 		return -ENOMEM;
+	per_cpu(cluster_masks, cpu) = cmsk;
+	prefill_clustermask(cmsk, cpu, cluster);
+
+ 	return 0;
 }
 
 static int x2apic_prepare_cpu(unsigned int cpu)
 {
-	if (alloc_clustermask(cpu, cpu_to_node(cpu)) < 0)
+	u32 phys_apicid = apic->cpu_present_to_apicid(cpu);
+	u32 cluster = apic_cluster(phys_apicid);
+	u32 logical_apicid = (cluster << 16) | (1 << (phys_apicid & 0xf));
+
+	x86_cpu_to_logical_apicid[cpu] = logical_apicid;
+
+	if (alloc_clustermask(cpu, cluster, cpu_to_node(cpu)) < 0)
 		return -ENOMEM;
 	if (!zalloc_cpumask_var(&per_cpu(ipi_mask, cpu), GFP_KERNEL))
 		return -ENOMEM;
@@ -162,10 +200,10 @@ static int x2apic_prepare_cpu(unsigned int cpu)
 
 static int x2apic_dead_cpu(unsigned int dead_cpu)
 {
-	struct cluster_mask *cmsk = per_cpu(cluster_masks, dead_cpu);
+	struct cpumask *cmsk = per_cpu(cluster_masks, dead_cpu);
 
 	if (cmsk)
-		cpumask_clear_cpu(dead_cpu, &cmsk->mask);
+		cpumask_clear_cpu(dead_cpu, cmsk);
 	free_cpumask_var(per_cpu(ipi_mask, dead_cpu));
 	return 0;
 }
-- 
2.25.1

