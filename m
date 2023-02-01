Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93703686FD1
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 21:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjBAUp2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 15:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBAUpT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 15:45:19 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955C27961D
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 12:44:49 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id r2so18489025wrv.7
        for <kvm@vger.kernel.org>; Wed, 01 Feb 2023 12:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m3/r2SgGGjsfHuJnNSpZFlNUSXv8jvj1KYLkjQUwAnE=;
        b=uZok0F+Nsacmd6VTqhDBt1ovy1sIk4RPXpwjQjKo9fsXZWBIziS84xJQtuDb9Iz4wr
         vYYUQYiM+djqSZ0mE03uhIYxvfPNhxlC2p8rcHxrLgBjaq6jvDZ0ZgFGlidQpYHmZ3z4
         q1abOM2IcvZgBu7eLzI3l5nxnFblZB2ayYJkeYW0RF/pR6iuDslQ7vFhPWncB3aEbXC5
         heTsA8QO7iBDgU6UZtXDP0UwUpswRERaFWWCvLWUSm0CDcnXfNWvAJ8jCYgUimmzj9vW
         co9TLqo8cqgZTeXhJQ+M+ZNwzUn6jjbhsFaFpEQ2yphfH6WIaPMhRX8nuX4F1SeaNA4t
         5yxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m3/r2SgGGjsfHuJnNSpZFlNUSXv8jvj1KYLkjQUwAnE=;
        b=wuQ8+sa6obOo6lO9H2rqPUAByPlmcmQnuvEJ1N+Mkt5rcjtK1rv7USbQRuMq28cD/4
         8BSsoZDOyevt6ErwOYV6pzd9YkQwyulLD8U/4uL5aCponH1Hy1jgEi2fJXmo91Yl+WQr
         KyDyTYNePtU4jnqHcbZErByvCl7kDUA3Eb0lCZlbUzHlCvEq2GnxTmzRxVIyYru1fo6v
         E8cG5ps5T1WxxhJ0XRYbnQFpJCmsI/rGPbBrv5EGcZ+KK72HXF+uNyjFQ0x/6Jquddgj
         lpzh7BLPNzVTioWaLb6oRau+owRr9/i1E56kDz/w7pr6tvL+/nLZRwgX+vwt0b1nCWlN
         9szw==
X-Gm-Message-State: AO0yUKXGfO3Rqj7Vx4jX9DQikXwG+8m1G5KoBzh69bwT5iLUGJeAC70/
        kj+XBFfsJrD4KnO2g2dnmoZxCw==
X-Google-Smtp-Source: AK7set+rFfLjebkNvKUYu4AHMQlZ4hQ01j0ux3p6T6D0gP2un9bpLTZrUHKtv3E1ybsG3mcihanoNw==
X-Received: by 2002:a05:6000:a0e:b0:2bf:b389:ae6 with SMTP id co14-20020a0560000a0e00b002bfb3890ae6mr4088125wrb.42.1675284288032;
        Wed, 01 Feb 2023 12:44:48 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:7611:c340:3d8d:d46c])
        by smtp.gmail.com with ESMTPSA id n15-20020a5d598f000000b002bdff778d87sm19993584wri.34.2023.02.01.12.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 12:44:47 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     dwmw2@infradead.org, tglx@linutronix.de
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: [PATCH 1/9] x86/apic/x2apic: Fix parallel handling of cluster_mask
Date:   Wed,  1 Feb 2023 20:43:30 +0000
Message-Id: <20230201204338.1337562-2-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230201204338.1337562-1-usama.arif@bytedance.com>
References: <20230201204338.1337562-1-usama.arif@bytedance.com>
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

For each CPU being brought up, the alloc_clustermask() function
allocates a new struct cluster_mask just in case it's needed. Then the
target CPU actually runs, and in init_x2apic_ldr() it either uses a
cluster_mask from a previous CPU in the same cluster, or consumes the
"spare" one and sets the global pointer to NULL.

That isn't going to parallelise stunningly well.

Ditch the global variable, let alloc_clustermask() install the struct
*directly* in the per_cpu data for the CPU being brought up. As an
optimisation, actually make it do so for *all* present CPUs in the same
cluster, which means only one iteration over for_each_present_cpu()
instead of doing so repeatedly, once for each CPU.

Now, in fact, there's no point in the 'node' or 'clusterid' members of
the struct cluster_mask, so just kill it and use struct cpumask instead.

This was a harmless "bug" while CPU bringup wasn't actually happening in
parallel. It's about to become less harmless...

Fixes: 023a611748fd5 ("x86/apic/x2apic: Simplify cluster management")
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kernel/apic/x2apic_cluster.c | 108 +++++++++++++++-----------
 1 file changed, 62 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index e696e22d0531..e116dfaf5922 100644
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
@@ -105,55 +100,76 @@ static u32 x2apic_calc_apicid(unsigned int cpu)
 
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
+ * As an optimisation during boot, set the cluster_mask for *all*
+ * present CPUs at once, to prevent *each* of them having to iterate
+ * over the others to find the existing cluster_mask.
+ */
+static void prefill_clustermask(struct cpumask *cmsk, u32 cluster)
+{
+	int cpu;
+
+	for_each_present_cpu(cpu) {
+		u32 apicid = apic->cpu_present_to_apicid(cpu);
+		if (apicid != BAD_APICID && apic_cluster(apicid) == cluster) {
+			struct cpumask **cpu_cmsk = &per_cpu(cluster_masks, cpu);
+
+			BUG_ON(*cpu_cmsk && *cpu_cmsk != cmsk);
+			*cpu_cmsk = cmsk;
+		}
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
+	u32 apicid;
+
 	if (per_cpu(cluster_masks, cpu))
 		return 0;
-	/*
-	 * If a hotplug spare mask exists, check whether it's on the right
-	 * node. If not, free it and allocate a new one.
-	 */
-	if (cluster_hotplug_mask) {
-		if (cluster_hotplug_mask->node == node)
-			return 0;
-		kfree(cluster_hotplug_mask);
+
+	/* For the hotplug case, don't always allocate a new one */
+	if (system_state >= SYSTEM_RUNNING) {
+		for_each_present_cpu(cpu_i) {
+			apicid = apic->cpu_present_to_apicid(cpu_i);
+			if (apicid != BAD_APICID && apic_cluster(apicid) == cluster) {
+				cmsk = per_cpu(cluster_masks, cpu_i);
+				if (cmsk)
+					break;
+			}
+		}
+	}
+	if (!cmsk) {
+		cmsk = kzalloc_node(sizeof(*cmsk), GFP_KERNEL, node);
+		if (!cmsk)
+			return -ENOMEM;
 	}
 
-	cluster_hotplug_mask = kzalloc_node(sizeof(*cluster_hotplug_mask),
-					    GFP_KERNEL, node);
-	if (!cluster_hotplug_mask)
-		return -ENOMEM;
-	cluster_hotplug_mask->node = node;
+	per_cpu(cluster_masks, cpu) = cmsk;
+
+	if (system_state < SYSTEM_RUNNING)
+		prefill_clustermask(cmsk, cluster);
+
 	return 0;
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
@@ -162,10 +178,10 @@ static int x2apic_prepare_cpu(unsigned int cpu)
 
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

