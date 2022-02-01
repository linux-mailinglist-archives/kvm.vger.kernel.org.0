Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8EC4A6676
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 21:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbiBAUyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 15:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbiBAUyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 15:54:11 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7990C06173E;
        Tue,  1 Feb 2022 12:54:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0uhVm1PS9ApvjdwQ4kuC+bPf3QKLru7DZhQXihM6vjY=; b=k+DwfbSeK5MR/YAptj86poOB/N
        kR4hlFAoXomqSnVF3HKK8YhEyApscMPFj2ChJTl5ZoX48l+eLI/BFJyzsMrc2RjBh0X2sYNRLzSgD
        kVItPIREfu8lnF+Unv9WB372oVVfYg0efKFIZ0a+Pr5zj/iosQtraQE4gXe82ewvSQXY7snxsSSrz
        ZrFxnwe9VLCtWeV0J0lxn+l3hoghtYoD647m5kty6etOt2RVc8ztJgVe1SSrzZ3SxDdscBlaKfneO
        e0WUBlXp5uAONZ1Ov/0IM8VIeWU8i1RYUviQ+Whsn59Aw+lq1/XsS0RVDNXrO+z19G7+9qAiPCtbv
        q/MiJNNQ==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09b-005yYR-Uk; Tue, 01 Feb 2022 20:53:32 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nF09Z-001Edc-Vq; Tue, 01 Feb 2022 20:53:29 +0000
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
Subject: [PATCH v4 1/9] x86/apic/x2apic: Fix parallel handling of cluster_mask
Date:   Tue,  1 Feb 2022 20:53:20 +0000
Message-Id: <20220201205328.123066-2-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220201205328.123066-1-dwmw2@infradead.org>
References: <20220201205328.123066-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
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
2.33.1

