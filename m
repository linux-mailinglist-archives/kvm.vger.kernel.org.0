Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6CE68CA70
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:20:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbjBFXUt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:20:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbjBFXUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:20:48 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE5B24116;
        Mon,  6 Feb 2023 15:20:46 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1675725644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JR1NPUgJTRhPCezfKGz5rwW+Lzgv1Ek8JY3fpAZd8c8=;
        b=cJoggIuI4s8xRnQAJM2VhHFKZoZg+e3Xs6Aa5WxCZq0Xgo8BCQ71r7cYCmDWVIbQMLeFP6
        bwFekFTL9DEqp2TissF6oqWPu1Cx5gd6wFnil68LezXdZ28laXVJwns7HEdnFVlwywT3sS
        IaDjg8UFwJyMiod5hdVb9Xugful7UreamZGlzS0of3HCPWKca6LYk1QFntnpcOlVInuQRl
        38X+rOfwXp8A9oSRbQnTVpC5dXGol+RFd05rIhLzO9Dybnmohz0InCS2g+BZ+5PI0xgcOI
        ZFUzE/XJRCAUmAhkpBHqDFebIfp9jKcXzj2Hzsslao09BqHQ7KHwH6MnGSOn+Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1675725644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JR1NPUgJTRhPCezfKGz5rwW+Lzgv1Ek8JY3fpAZd8c8=;
        b=tsWnjlmqkkS0AHc3tsY+lkA18qV7/X/wPvpwR7IGdCTumr2/JMYwhY1n1GZpI42Gla6BJY
        9mr9B/ji4j6Q6MDw==
To:     Usama Arif <usama.arif@bytedance.com>, dwmw2@infradead.org,
        arjan@linux.intel.com
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, x86@kernel.org, pbonzini@redhat.com,
        paulmck@kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, rcu@vger.kernel.org, mimoja@mimoja.de,
        hewenliang4@huawei.com, thomas.lendacky@amd.com, seanjc@google.com,
        pmenzel@molgen.mpg.de, fam.zheng@bytedance.com,
        punit.agrawal@bytedance.com, simon.evans@bytedance.com,
        liangma@liangbit.com, David Woodhouse <dwmw@amazon.co.uk>
Subject: Re: [PATCH v6 01/11] x86/apic/x2apic: Fix parallel handling of
 cluster_mask
In-Reply-To: <20230202215625.3248306-2-usama.arif@bytedance.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-2-usama.arif@bytedance.com>
Date:   Tue, 07 Feb 2023 00:20:43 +0100
Message-ID: <87a61qxtx0.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Usama!

On Thu, Feb 02 2023 at 21:56, Usama Arif wrote:
> For each CPU being brought up, the alloc_clustermask() function
> allocates a new struct cluster_mask just in case it's needed. Then the
> target CPU actually runs, and in init_x2apic_ldr() it either uses a
> cluster_mask from a previous CPU in the same cluster, or consumes the
> "spare" one and sets the global pointer to NULL.
>
> That isn't going to parallelise stunningly well.
>
> Ditch the global variable, let alloc_clustermask() install the struct
> *directly* in the per_cpu data for the CPU being brought up. As an
> optimisation, actually make it do so for *all* present CPUs in the same
> cluster, which means only one iteration over for_each_present_cpu()
> instead of doing so repeatedly, once for each CPU.
>
> Now, in fact, there's no point in the 'node' or 'clusterid' members of
> the struct cluster_mask, so just kill it and use struct cpumask instead.
>
> This was a harmless "bug" while CPU bringup wasn't actually happening in
> parallel. It's about to become less harmless...

Just to be clear. There is no bug in todays code and therefore this:

> Fixes: 023a611748fd5 ("x86/apic/x2apic: Simplify cluster management")

tag is unjustified. It'll just cause the stable robots to backport it
for no reason.

> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Paul E. McKenney <paulmck@kernel.org>

How is this SOB chain correct? It's unclear to me how Paul got involved
here, but let's assume he handed the patch over to you, then this still
lacks a SOB from you.

> +/*
> + * As an optimisation during boot, set the cluster_mask for *all*
> + * present CPUs at once, to prevent *each* of them having to iterate
> + * over the others to find the existing cluster_mask.
> + */
> +static void prefill_clustermask(struct cpumask *cmsk, u32 cluster)
> +{
> +	int cpu;
> +
> +	for_each_present_cpu(cpu) {
> +		u32 apicid = apic->cpu_present_to_apicid(cpu);

Lacks a newline between declaration and code.

> +		if (apicid != BAD_APICID && apic_cluster(apicid) == cluster) {
> +			struct cpumask **cpu_cmsk = &per_cpu(cluster_masks, cpu);
> +
> +			BUG_ON(*cpu_cmsk && *cpu_cmsk != cmsk);

While I agree that changing an in use mask pointer would be fatal, I
really have to ask why this code would be invoked on a partially
initialized cluster at all and why that would be correct.

                        if (WARN_ON_ONCE(*cpu_cmsk == cmsk))
                        	return;
                        BUG_ON(*cpu_mask);

if at all. But of course that falls over with the way how this code is
invoked below.

> +			*cpu_cmsk = cmsk;
> +		}
>  
> -static int alloc_clustermask(unsigned int cpu, int node)
> +static int alloc_clustermask(unsigned int cpu, u32 cluster, int node)
>  {
> +	struct cpumask *cmsk = NULL;
> +	unsigned int cpu_i;
> +	u32 apicid;
> +
>  	if (per_cpu(cluster_masks, cpu))
>  		return 0;
> -	/*
> -	 * If a hotplug spare mask exists, check whether it's on the right
> -	 * node. If not, free it and allocate a new one.
> -	 */
> -	if (cluster_hotplug_mask) {
> -		if (cluster_hotplug_mask->node == node)
> -			return 0;
> -		kfree(cluster_hotplug_mask);
> +
> +	/* For the hotplug case, don't always allocate a new one */

-ENOPARSE

> +	if (system_state >= SYSTEM_RUNNING) {
> +		for_each_present_cpu(cpu_i) {
> +			apicid = apic->cpu_present_to_apicid(cpu_i);
> +			if (apicid != BAD_APICID && apic_cluster(apicid) == cluster) {
> +				cmsk = per_cpu(cluster_masks, cpu_i);
> +				if (cmsk)
> +					break;
> +			}
> +		}
> +	}
> +	if (!cmsk) {
> +		cmsk = kzalloc_node(sizeof(*cmsk), GFP_KERNEL, node);
> +		if (!cmsk)
> +			return -ENOMEM;
>  	}

...
  
> +	per_cpu(cluster_masks, cpu) = cmsk;
> +
> +	if (system_state < SYSTEM_RUNNING)
> +		prefill_clustermask(cmsk, cluster);

TBH. The logic of this code is anything but obvious. Something like the
uncompiled below perhaps?

Thanks,

        tglx
---

@@ -116,44 +109,90 @@
+
+/*
+ * As an optimisation during boot, set the cluster_mask for all present
+ * CPUs at once, to prevent each of them having to iterate over the others
+ * to find the existing cluster_mask.
+ */
+static void prefill_clustermask(struct cpumask *cmsk, unsigned int cpu, u32 cluster)
+{
+	int cpu_i;
 
-	cluster = apicid >> 16;
-	for_each_online_cpu(cpu) {
-		cmsk = per_cpu(cluster_masks, cpu);
-		/* Matching cluster found. Link and update it. */
-		if (cmsk && cmsk->clusterid == cluster)
-			goto update;
+	for_each_present_cpu(cpu_i) {
+		struct cpumask **cpu_cmsk = &per_cpu(cluster_masks, cpu);
+		u32 apicid = apic->cpu_present_to_apicid(cpu_i);
+
+		if (apicid == BAD_APICID || cpu_i == cpu || apic_cluster(apicid) != cluster)
+			continue;
+
+		if (WARN_ON_ONCE(*cpu_mask == cmsk))
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
+	struct cpumask *cmsk;
+	unsigned int cpu_i;
+
 	if (per_cpu(cluster_masks, cpu))
 		return 0;
+
 	/*
-	 * If a hotplug spare mask exists, check whether it's on the right
-	 * node. If not, free it and allocate a new one.
+	 * At boot time CPU present mask is stable. If the cluster is not
+	 * yet initialized, allocate the mask and propagate it to all
+	 * siblings in this cluster.
 	 */
-	if (cluster_hotplug_mask) {
-		if (cluster_hotplug_mask->node == node)
-			return 0;
-		kfree(cluster_hotplug_mask);
-	}
+	if (system_state < SYSTEM_RUNNING)
+		goto alloc;
+
+	/*
+	 * On post boot hotplug iterate over the present CPUs to handle the
+	 * case of partial clusters as they might be presented by
+	 * virtualization.
+	 */
+	for_each_present_cpu(cpu_i) {
+		u32 apicid = apic->cpu_present_to_apicid(cpu_i);
+
+		if (apicid != BAD_APICID && apic_cluster(apicid) == cluster) {
+			cmsk = per_cpu(cluster_masks, cpu_i);
 
-	cluster_hotplug_mask = kzalloc_node(sizeof(*cluster_hotplug_mask),
-					    GFP_KERNEL, node);
-	if (!cluster_hotplug_mask)
+			/*
+			 * If the cluster is already initialized, just
+			 * store the mask and return. No point in trying to
+			 * propagate.
+			 */
+			if (cmsk) {
+				per_cpu(cluster_masks, cpu) = cmsk;
+				return 0;
+			}
+		}
+	}
+	/*
+	 * The cluster is not initialized yet. Fall through to the boot
+	 * time code which might initialize the whole cluster if it is
+	 * in the CPU present mask.
+	 */
+alloc:
+	cmsk = kzalloc_node(sizeof(*cmsk), GFP_KERNEL, node);
+	if (!cmsk)
 		return -ENOMEM;
-	cluster_hotplug_mask->node = node;
+	per_cpu(cluster_masks, cpu) = cmsk;
+	prefill_clustermask(cmsk, cluster);
+
 	return 0;
 }


