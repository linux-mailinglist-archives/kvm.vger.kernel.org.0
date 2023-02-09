Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B747B690D3B
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 16:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbjBIPmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 10:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbjBIPmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 10:42:06 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9BB5DC1A
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 07:42:02 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id f47-20020a05600c492f00b003dc584a7b7eso4166470wmp.3
        for <kvm@vger.kernel.org>; Thu, 09 Feb 2023 07:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=davZpZrHKqcK9/fGgGK/yHqe9BiOZs8yrjIgwy5MeSU=;
        b=oj/9tXMdEYgIuNjMHdwfGMRWRTCwV7MD+QwwAxqGQp7XqZGYnxojuYFwjjTwaCdrOt
         SZ1/j0R70pXmmaObSwGdCRGPW1jOevhn3Rxenl7Y2mDvh7un2hH/cpOwViTY+qkGB4vR
         Cq3M/W0zEqmmpkOHiJpC4YFdhHZ3mNtONdOv730PlSUQrXBIFGIAQmv+YCcUds1ajxo7
         w4RCjH0DQERX2119rlpNNREHEpQ43C02H7VSj+FRpHbc28BIKiXMOeM2btQsSB3PPRLH
         oN03hs18IKj6vB/M9BGCSScJwHfGpFhm09OHypmZgyQ8Qy8lQEGCNOdy6TMMzPPkdeF6
         dQ6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=davZpZrHKqcK9/fGgGK/yHqe9BiOZs8yrjIgwy5MeSU=;
        b=8FZcltIP3IVjUzslMexVv6Xpsq2da9bUtKT3DXiPVKk+uNe2tgTs1hegCGDXYeG0RW
         EJBkaPZNJ9dIk0+o6TgMixlHBlKXi23cSh1r5cNxvsTUv/FelINF29A6fK58hzv7xp4k
         cUBLTAPGlvzX4lVLpL8/wd2nE2sAsMFTNk1DC3cgWNRSgsULy/P3O3504s7273tAaNkk
         PYlJnf4YFOOXSerhTYfG3PXc5pU5h4uTEV6DwEhavB+mY/EUxJFwm0tGE2nCw466E2XZ
         vBL94xwtzKS8NLZ5FKNt6dq7JgZuWQJ8lOgrYL254jGIfVQ+MUNTkFbd7DEN4Opw6NGD
         ApKw==
X-Gm-Message-State: AO0yUKWdL1nIBZozXKSStfQvF8OuPlkw5vdRENFMGYTntxSM+CN3N51Q
        fYcPR3qj/mNAeqq+/cJth1qRWw==
X-Google-Smtp-Source: AK7set/HtFUmlYeGUqLovxpYva8OanJk7C6GRUmo7Y8pHSYRBwwSfFm+gPQ8an2swBtX5NLMoHcxgw==
X-Received: by 2002:a05:600c:4b1b:b0:3dc:53da:328b with SMTP id i27-20020a05600c4b1b00b003dc53da328bmr13358092wmp.14.1675957320680;
        Thu, 09 Feb 2023 07:42:00 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:8009:2525:9580:8db2])
        by smtp.gmail.com with ESMTPSA id y6-20020a05600c364600b003df7b40f99fsm5099754wmq.11.2023.02.09.07.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 07:42:00 -0800 (PST)
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
Subject: [PATCH v8 1/9] x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
Date:   Thu,  9 Feb 2023 15:41:48 +0000
Message-Id: <20230209154156.266385-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230209154156.266385-1-usama.arif@bytedance.com>
References: <20230209154156.266385-1-usama.arif@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

