Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F9F162971
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 16:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgBRPbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 10:31:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726399AbgBRPbG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 10:31:06 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0E2121D56;
        Tue, 18 Feb 2020 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582039865;
        bh=udD8rg+CA1YXTU1bGuclVUv2oJiw9GqsIWaBCOxNdkY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=x5AF/AGM3GG8YvanUK7HIQtXlKCLUtGoHnBAU6G0RgsLdoxiMWiXNNUICKUVIhClY
         E0S8c7Fw/IOYpqEzVexuhhSQqGhCCe4K70fsrElaAvDAp71ybRX7Lhh4fO4brQFxTs
         GDHWWM7SpQCkbKt/rCF7tnfxBJD9CQwsDqCsnok0=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j44py-006FQ4-UG; Tue, 18 Feb 2020 15:31:03 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 18 Feb 2020 15:31:02 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v4 08/20] irqchip/gic-v4.1: Plumb get/set_irqchip_state
 SGI callbacks
In-Reply-To: <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
References: <20200214145736.18550-1-maz@kernel.org>
 <20200214145736.18550-9-maz@kernel.org>
 <4b7f71f1-5e7f-e6af-f47d-7ed0d3a8739f@huawei.com>
 <75597af0d2373ac4d92d8162a1338cbb@kernel.org>
Message-ID: <19a7c193f0e4b97343e822a35f0911ed@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 2020-02-18 09:27, Marc Zyngier wrote:
> Hi Zenghui,
> 
> On 2020-02-18 07:00, Zenghui Yu wrote:
>> Hi Marc,

[...]

>> There might be a race on reading the 'vpe->col_idx' against a 
>> concurrent
>> vPE schedule (col_idx will be modified in its_vpe_set_affinity)? Will 
>> we
>> end up accessing the GICR_VSGI* registers of the old redistributor,
>> while the vPE is now resident on the new one? Or is it harmful?
> 
> Very well spotted. There is a potential problem if old and new RDs are 
> not part
> of the same CommonLPIAff group.
> 
>> The same question for direct_lpi_inv(), where 'vpe->col_idx' will be
>> used in irq_to_cpuid().
> 
> Same problem indeed. We need to ensure that no VMOVP operation can 
> occur whilst
> we use col_idx to access a redistributor. This means a vPE lock of some 
> sort
> that will protect the affinity.
> 
> But I think there is a slightly more general problem here, which we 
> failed to
> see initially: the same issue exists for physical LPIs, as col_map[] 
> can be
> updated (its_set_affinity()) in parallel with a direct invalidate.
> 
> The good old invalidation through the ITS does guarantee that the two 
> operation
> don't overlap, but direct invalidation breaks it.
> 
> Let me have a think about it.

So I've thought about it, wrote a patch, and I don't really like the 
look of it.
This is pretty invasive, and we end-up serializing a lot more than we 
used to
(the repurposing of vlpi_lock to a general "lpi mapping lock" is 
probably too
coarse).

It of course needs splitting over at least three patches, but it'd be 
good if
you could have a look (applies on top of the whole series).

Thanks,

         M.

diff --git a/drivers/irqchip/irq-gic-v3-its.c 
b/drivers/irqchip/irq-gic-v3-its.c
index 7656b353a95f..0ed286dba827 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -144,7 +144,7 @@ struct event_lpi_map {
  	u16			*col_map;
  	irq_hw_number_t		lpi_base;
  	int			nr_lpis;
-	raw_spinlock_t		vlpi_lock;
+	raw_spinlock_t		map_lock;
  	struct its_vm		*vm;
  	struct its_vlpi_map	*vlpi_maps;
  	int			nr_vlpis;
@@ -240,15 +240,33 @@ static struct its_vlpi_map *get_vlpi_map(struct 
irq_data *d)
  	return NULL;
  }

-static int irq_to_cpuid(struct irq_data *d)
+static int irq_to_cpuid_lock(struct irq_data *d, unsigned long *flags)
  {
-	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
  	struct its_vlpi_map *map = get_vlpi_map(d);
+	int cpu;

-	if (map)
-		return map->vpe->col_idx;
+	if (map) {
+		raw_spin_lock_irqsave(&map->vpe->vpe_lock, *flags);
+		cpu = map->vpe->col_idx;
+	} else {
+		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+		raw_spin_lock_irqsave(&its_dev->event_map.map_lock, *flags);
+		cpu = its_dev->event_map.col_map[its_get_event_id(d)];
+	}

-	return its_dev->event_map.col_map[its_get_event_id(d)];
+	return cpu;
+}
+
+static void irq_to_cpuid_unlock(struct irq_data *d, unsigned long 
flags)
+{
+	struct its_vlpi_map *map = get_vlpi_map(d);
+
+	if (map) {
+		raw_spin_unlock_irqrestore(&map->vpe->vpe_lock, flags);
+	} else {
+		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
+		raw_spin_unlock_irqrestore(&its_dev->event_map.map_lock, flags);
+	}
  }

  static struct its_collection *valid_col(struct its_collection *col)
@@ -1384,6 +1402,8 @@ static void direct_lpi_inv(struct irq_data *d)
  {
  	struct its_vlpi_map *map = get_vlpi_map(d);
  	void __iomem *rdbase;
+	unsigned long flags;
+	int cpu;
  	u64 val;

  	if (map) {
@@ -1399,10 +1419,12 @@ static void direct_lpi_inv(struct irq_data *d)
  	}

  	/* Target the redistributor this LPI is currently routed to */
-	rdbase = per_cpu_ptr(gic_rdists->rdist, irq_to_cpuid(d))->rd_base;
+	cpu = irq_to_cpuid_lock(d, &flags);
+	rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
  	gic_write_lpir(val, rdbase + GICR_INVLPIR);

  	wait_for_syncr(rdbase);
+	irq_to_cpuid_unlock(d, flags);
  }

  static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
@@ -1471,11 +1493,11 @@ static void its_unmask_irq(struct irq_data *d)
  static int its_set_affinity(struct irq_data *d, const struct cpumask 
*mask_val,
  			    bool force)
  {
-	unsigned int cpu;
  	const struct cpumask *cpu_mask = cpu_online_mask;
  	struct its_device *its_dev = irq_data_get_irq_chip_data(d);
  	struct its_collection *target_col;
-	u32 id = its_get_event_id(d);
+	unsigned int from, cpu;
+	unsigned long flags;

  	/* A forwarded interrupt should use irq_set_vcpu_affinity */
  	if (irqd_is_forwarded_to_vcpu(d))
@@ -1496,12 +1518,16 @@ static int its_set_affinity(struct irq_data *d, 
const struct cpumask *mask_val,
  		return -EINVAL;

  	/* don't set the affinity when the target cpu is same as current one 
*/
-	if (cpu != its_dev->event_map.col_map[id]) {
+	from = irq_to_cpuid_lock(d, &flags);
+	if (cpu != from) {
+		u32 id = its_get_event_id(d);
+
  		target_col = &its_dev->its->collections[cpu];
  		its_send_movi(its_dev, target_col, id);
  		its_dev->event_map.col_map[id] = cpu;
  		irq_data_update_effective_affinity(d, cpumask_of(cpu));
  	}
+	irq_to_cpuid_unlock(d, flags);

  	return IRQ_SET_MASK_OK_DONE;
  }
@@ -1636,7 +1662,7 @@ static int its_vlpi_map(struct irq_data *d, struct 
its_cmd_info *info)
  	if (!info->map)
  		return -EINVAL;

-	raw_spin_lock(&its_dev->event_map.vlpi_lock);
+	raw_spin_lock(&its_dev->event_map.map_lock);

  	if (!its_dev->event_map.vm) {
  		struct its_vlpi_map *maps;
@@ -1685,7 +1711,7 @@ static int its_vlpi_map(struct irq_data *d, struct 
its_cmd_info *info)
  	}

  out:
-	raw_spin_unlock(&its_dev->event_map.vlpi_lock);
+	raw_spin_unlock(&its_dev->event_map.map_lock);
  	return ret;
  }

@@ -1695,7 +1721,7 @@ static int its_vlpi_get(struct irq_data *d, struct 
its_cmd_info *info)
  	struct its_vlpi_map *map;
  	int ret = 0;

-	raw_spin_lock(&its_dev->event_map.vlpi_lock);
+	raw_spin_lock(&its_dev->event_map.map_lock);

  	map = get_vlpi_map(d);

@@ -1708,7 +1734,7 @@ static int its_vlpi_get(struct irq_data *d, struct 
its_cmd_info *info)
  	*info->map = *map;

  out:
-	raw_spin_unlock(&its_dev->event_map.vlpi_lock);
+	raw_spin_unlock(&its_dev->event_map.map_lock);
  	return ret;
  }

@@ -1718,7 +1744,7 @@ static int its_vlpi_unmap(struct irq_data *d)
  	u32 event = its_get_event_id(d);
  	int ret = 0;

-	raw_spin_lock(&its_dev->event_map.vlpi_lock);
+	raw_spin_lock(&its_dev->event_map.map_lock);

  	if (!its_dev->event_map.vm || !irqd_is_forwarded_to_vcpu(d)) {
  		ret = -EINVAL;
@@ -1748,7 +1774,7 @@ static int its_vlpi_unmap(struct irq_data *d)
  	}

  out:
-	raw_spin_unlock(&its_dev->event_map.vlpi_lock);
+	raw_spin_unlock(&its_dev->event_map.map_lock);
  	return ret;
  }

@@ -3193,7 +3219,7 @@ static struct its_device *its_create_device(struct 
its_node *its, u32 dev_id,
  	dev->event_map.col_map = col_map;
  	dev->event_map.lpi_base = lpi_base;
  	dev->event_map.nr_lpis = nr_lpis;
-	raw_spin_lock_init(&dev->event_map.vlpi_lock);
+	raw_spin_lock_init(&dev->event_map.map_lock);
  	dev->device_id = dev_id;
  	INIT_LIST_HEAD(&dev->entry);

@@ -3560,6 +3586,7 @@ static int its_vpe_set_affinity(struct irq_data 
*d,
  {
  	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
  	int from, cpu = cpumask_first(mask_val);
+	unsigned long flags;

  	/*
  	 * Changing affinity is mega expensive, so let's be as lazy as
@@ -3567,6 +3594,7 @@ static int its_vpe_set_affinity(struct irq_data 
*d,
  	 * into the proxy device, we need to move the doorbell
  	 * interrupt to its new location.
  	 */
+	raw_spin_lock_irqsave(&vpe->vpe_lock, flags);
  	if (vpe->col_idx == cpu)
  		goto out;

@@ -3586,6 +3614,7 @@ static int its_vpe_set_affinity(struct irq_data 
*d,

  out:
  	irq_data_update_effective_affinity(d, cpumask_of(cpu));
+	raw_spin_unlock_irqrestore(&vpe->vpe_lock, flags);

  	return IRQ_SET_MASK_OK_DONE;
  }
@@ -3695,11 +3724,15 @@ static void its_vpe_send_inv(struct irq_data *d)

  	if (gic_rdists->has_direct_lpi) {
  		void __iomem *rdbase;
+		unsigned long flags;
+		int cpu;

  		/* Target the redistributor this VPE is currently known on */
-		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
+		cpu = irq_to_cpuid_lock(d, &flags);
+		rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
  		gic_write_lpir(d->parent_data->hwirq, rdbase + GICR_INVLPIR);
  		wait_for_syncr(rdbase);
+		irq_to_cpuid_unlock(d, flags);
  	} else {
  		its_vpe_send_cmd(vpe, its_send_inv);
  	}
@@ -3735,14 +3768,18 @@ static int its_vpe_set_irqchip_state(struct 
irq_data *d,

  	if (gic_rdists->has_direct_lpi) {
  		void __iomem *rdbase;
+		unsigned long flags;
+		int cpu;

-		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
+		cpu = irq_to_cpuid_lock(d, &flags);
+		rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
  		if (state) {
  			gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_SETLPIR);
  		} else {
  			gic_write_lpir(vpe->vpe_db_lpi, rdbase + GICR_CLRLPIR);
  			wait_for_syncr(rdbase);
  		}
+		irq_to_cpuid_unlock(d, flags);
  	} else {
  		if (state)
  			its_vpe_send_cmd(vpe, its_send_int);
@@ -3854,14 +3891,17 @@ static void its_vpe_4_1_deschedule(struct 
its_vpe *vpe,
  static void its_vpe_4_1_invall(struct its_vpe *vpe)
  {
  	void __iomem *rdbase;
+	unsigned long flags;
  	u64 val;

  	val  = GICR_INVALLR_V;
  	val |= FIELD_PREP(GICR_INVALLR_VPEID, vpe->vpe_id);

  	/* Target the redistributor this vPE is currently known on */
+	raw_spin_lock_irqsave(&vpe->vpe_lock, flags);
  	rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
  	gic_write_lpir(val, rdbase + GICR_INVALLR);
+	raw_spin_unlock_irqrestore(&vpe->vpe_lock, flags);
  }

  static int its_vpe_4_1_set_vcpu_affinity(struct irq_data *d, void 
*vcpu_info)
@@ -3960,13 +4000,17 @@ static int its_sgi_get_irqchip_state(struct 
irq_data *d,
  				     enum irqchip_irq_state which, bool *val)
  {
  	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
-	void __iomem *base = gic_data_rdist_cpu(vpe->col_idx)->rd_base + 
SZ_128K;
+	void __iomem *base;
+	unsigned long flags;
  	u32 count = 1000000;	/* 1s! */
  	u32 status;
+	int cpu;

  	if (which != IRQCHIP_STATE_PENDING)
  		return -EINVAL;

+	cpu = irq_to_cpuid_lock(d, &flags);
+	base = gic_data_rdist_cpu(cpu)->rd_base + SZ_128K;
  	writel_relaxed(vpe->vpe_id, base + GICR_VSGIR);
  	do {
  		status = readl_relaxed(base + GICR_VSGIPENDR);
@@ -3983,6 +4027,7 @@ static int its_sgi_get_irqchip_state(struct 
irq_data *d,
  	} while(count);

  out:
+	irq_to_cpuid_unlock(d, flags);
  	*val = !!(status & (1 << d->hwirq));

  	return 0;
@@ -4102,6 +4147,7 @@ static int its_vpe_init(struct its_vpe *vpe)
  		return -ENOMEM;
  	}

+	raw_spin_lock_init(&vpe->vpe_lock);
  	vpe->vpe_id = vpe_id;
  	vpe->vpt_page = vpt_page;
  	if (gic_rdists->has_rvpeid)
diff --git a/include/linux/irqchip/arm-gic-v4.h 
b/include/linux/irqchip/arm-gic-v4.h
index 46c167a6349f..fc43a63875a3 100644
--- a/include/linux/irqchip/arm-gic-v4.h
+++ b/include/linux/irqchip/arm-gic-v4.h
@@ -60,6 +60,7 @@ struct its_vpe {
  		};
  	};

+	raw_spinlock_t		vpe_lock;
  	/*
  	 * This collection ID is used to indirect the target
  	 * redistributor for this VPE. The ID itself isn't involved in

-- 
Jazz is not dead. It just smells funny...
