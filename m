Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67C0E6A80C9
	for <lists+kvm@lfdr.de>; Thu,  2 Mar 2023 12:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCBLMi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Mar 2023 06:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCBLMg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Mar 2023 06:12:36 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81F994345F
        for <kvm@vger.kernel.org>; Thu,  2 Mar 2023 03:12:33 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id m25-20020a7bcb99000000b003e7842b75f2so1265143wmi.3
        for <kvm@vger.kernel.org>; Thu, 02 Mar 2023 03:12:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbhas2uqRPBmSN9AHCLEH2K+C2q38zTMyGQqhw7QwxQ=;
        b=NvSZRs8YRO/jub40nOEJn2tzG/RmvqDlBUFQPSCuqUOik6/JDMLLZDbbOSbR1HCHXE
         uw4I10wJVuzSIkyKaeqKhqNmtAYuhTXgih4rGONdfzlbDgzzwZYbSqsvHtWPHFE8xcpZ
         3n8YamaBi3M5/ygCaCG5nX/FpVJNJ4gVz1mAyjx6Okf0ttFYej0qVp53stP8BSKLm4WH
         fVjRjT/JsyDNB7/gvgyWmh2OKha7+0jwai7+x5IpWZlMbAPwZCJnG6OHFZcL9V5CFCCw
         aiumuNptqGVUy+TbqPA/lffjkxvcWnD7UM9r+YJo0mGr/BAqNMTzlhO0jUFgAftMaVvc
         WJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mbhas2uqRPBmSN9AHCLEH2K+C2q38zTMyGQqhw7QwxQ=;
        b=Wv0BIq6BXBoY/1zNIZISCB8JmcrWjlwZYT7FHHKHcU5vmhHqKLgmmtIbuAQgQkSVff
         TRA+FmszkrVm4JQ/b/IImP4hIeXIYv4+4KiyY1VqQTkJsacw10obIkWzwy2qk6GqDzWt
         /k32YSHr9117vLgHbTyZZVZhqlwe9uHeyzIRMixSQ1RmuWGU7IbPO7hlF83l+ed3MFcB
         yk7LGZG1N2YPD/NI4HXtxlMu1Jn3zb/TVt9u8cBHwxZUOn8zlKWwhBvsnhWVpSCapM7R
         oGgQDzfAmqDx48lO0p3hLbTno28oAKfrqEC8EoRY+k9rw90pwwlELbipJou6LevAs1Fe
         2DOQ==
X-Gm-Message-State: AO0yUKUa5IfDntdxVIQeRtkBc/E9kBpHZZhNt755mMnwM5mpnKGRlWkg
        UJdshvrlYeaTy8rb24we4obzCw==
X-Google-Smtp-Source: AK7set9+idwyrX+xaXAWGKBGXzB34IGlxmvchYIks/ybPzji1BllaS3MN+MwAFpNzSZSQqdTAgYTkw==
X-Received: by 2002:a05:600c:43d5:b0:3eb:29fe:7bad with SMTP id f21-20020a05600c43d500b003eb29fe7badmr7439369wmn.1.1677755551985;
        Thu, 02 Mar 2023 03:12:31 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6a:b566:0:11aa:3c13:d3e:eb29])
        by smtp.gmail.com with ESMTPSA id a5-20020a5d4565000000b002c3f81c51b6sm14724830wrc.90.2023.03.02.03.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:12:31 -0800 (PST)
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
Subject: [PATCH v13 01/11] x86/apic/x2apic: Allow CPU cluster_mask to be populated in parallel
Date:   Thu,  2 Mar 2023 11:12:17 +0000
Message-Id: <20230302111227.2102545-2-usama.arif@bytedance.com>
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
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Kim Phillips <kim.phillips@amd.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Tested-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c | 126 +++++++++++++++++---------
 1 file changed, 82 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index e696e22d0531..b2b2b7f3e03f 100644
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
+	/*
+	 * No CPU in the cluster has ever been initialized, so fall through to
+	 * the boot time code which will also populate the cluster mask for any
+	 * other CPU in the cluster which is (now) present.
+	 */
+alloc:
+	cmsk = kzalloc_node(sizeof(*cmsk), GFP_KERNEL, node);
+	if (!cmsk)
 		return -ENOMEM;
-	cluster_hotplug_mask->node = node;
+	per_cpu(cluster_masks, cpu) = cmsk;
+	prefill_clustermask(cmsk, cpu, cluster);
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

