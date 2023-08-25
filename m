Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576EE787D74
	for <lists+kvm@lfdr.de>; Fri, 25 Aug 2023 04:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjHYB7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 21:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240082AbjHYB67 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 21:58:59 -0400
Received: from mail-oa1-x41.google.com (mail-oa1-x41.google.com [IPv6:2001:4860:4864:20::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1FAE4E
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:58:33 -0700 (PDT)
Received: by mail-oa1-x41.google.com with SMTP id 586e51a60fabf-1cc61f514baso289827fac.1
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 18:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1692928712; x=1693533512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ruDEdGF6thZk2mcTIP3xCS1ljQPI4op9YI2FgBKug94=;
        b=kkRw7sl9geHK0ITXL+hdZUjcIW2cln5iPPPyDeBP0zsXiuU15Y9srDxgZOVUSJVaMA
         /IeLwqY1c7EMDpzhGgCr3Q4OyEoZRTpNYQgWk2uQkJ8iMoqhn6jSJ5ZiHe1sihmxs8P4
         pntAkQPLa0hSu3cp8+MchlcaYGUW0GG/cGGqxN1pwRwH2aN24qGAoT5Z2VN9Udev3GpB
         aBzQgtiL5+QviX2r88kSDhv2D6vnlYarsug5AWbaLBJrjjZvxVQFFN0hDPWhricm46TY
         Wz04u55qSf5HGJtd3yk52CAXVu8pWXKBehbrx+BiKBiwpQN0lI7+XJ7W0241T5GnSSce
         BXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692928712; x=1693533512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ruDEdGF6thZk2mcTIP3xCS1ljQPI4op9YI2FgBKug94=;
        b=WPaKbf3GmxmxcCf4eNPvhUsaTqKAoA0LUgUMzCKOidlcOJndX9rMUZ9+wCevJluHFR
         Sx6QXA85S+mPt4SOg9UqYrHWKjNQGaan40sIvOTwyWNqniD8zrxvsIYWGanHsp/epWGA
         36oFez07U6BcyfQ0uD+xIYGEX32O7srSMBcBzKo4bXJUAGUVXLiV76JsZlEVuki+de0R
         6JKTQvcwkCirgqrgTgRtYIy5NN0aqieosEhHDWdgyEgZ4/3O039psGNWDCuuln+7M/Su
         UfF82VuifYhG1jTxU3Djljw1u442QedAsm9ABsCDlLTotsAqc4FsNEJqjMz2mn9ROq6W
         +P6g==
X-Gm-Message-State: AOJu0YxBxydRFgVdx/+06vVkRO/sLgqPOiHVngMJLt0SVTOxo0m6ZT1S
        7h4Np80Qx8E1AWaW6FY23+HDOw==
X-Google-Smtp-Source: AGHT+IFKjYg67WWgMahVAYejNR9bJkWDWmOjy8i9DB2w6tNxCHeHQ6DClpswFML76gPvcfJQ314fLQ==
X-Received: by 2002:a05:6870:e242:b0:1be:e6d6:15c4 with SMTP id d2-20020a056870e24200b001bee6d615c4mr1565726oac.9.1692928711896;
        Thu, 24 Aug 2023 18:58:31 -0700 (PDT)
Received: from C02D83NFML85.bytedance.net ([139.177.225.229])
        by smtp.gmail.com with ESMTPSA id pq8-20020a17090b3d8800b00263dfe9b972sm2299502pjb.0.2023.08.24.18.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 18:58:31 -0700 (PDT)
From:   Xu Zhao <zhaoxu.35@bytedance.com>
To:     maz@kernel.org, oliver.upton@linux.dev, james.morse@arm.com
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: [RFC v2] KVM: arm/arm64: optimize vSGI injection performance
Date:   Fri, 25 Aug 2023 09:58:11 +0800
Message-Id: <20230825015811.5292-1-zhaoxu.35@bytedance.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In a VM with more than 16 vCPUs (with multiple aff0 groups), if the target 
vCPU of a vSGI exceeds 16th vCPU, kvm needs to iterate from vCPU0 until 
the target vCPU is found. However, affinity routing information is provided 
by the ICC_SGI* register, which allows kvm to bypass other aff0 groups, 
iterating only on the aff0 group that the target vCPU located. It reduces 
the maximum iteration times from the total number of vCPUs to 16, or even 
8 times.

This patch aims to optimize the vSGI injecting performance of injecting 
target exceeds 16th vCPU in vm with more than 16 vCPUs.

Here comes the test data.

Test environment
	Host kernel: v6.5
	Guest kernel: v5.4.143
	Benchmark: ipi_benchmark, https://patchwork.kernel.org/project/linux-arm-kernel/patch/2017121
1141600.24401-1-ynorov@caviumnetworks.com.
	run times: each case runs for 5*100000 times

4 cores with vcpu pinning:
	  	      |               ipi benchmark           |	      vgic_v3_dispatch_sgi      |
| No |		      |    original  |  with patch  | impoved | original | with patch | impoved |
| 0  | vcpu0 -> vcpu1 | 222994694 ns | 208198673 ns |  +6.6%  |  1505 ns |   1215 ns  |  +19.3% |
| 1  | vcpu0 -> vcpu3 | 216790218 ns | 198613251 ns |  +8.4%  |  1266 ns |   1174 ns  |  +7.3%  |

32 cores with vcpu pinning:
                       |               ipi benchmark             |        vgic_v3_dispatch_sgi      |
| No |                 |    original   |   with patch  | impoved | original | with patch | impoved  |
| 2  | vcpu0 -> vcpu1  |  205954986 ns |  208735352 ns |  -1.3%  |  1655 ns |   1258 ns  |  +24.0%  |
| 3  | vcpu0 -> vcpu15 |  327822710 ns |  268791736 ns | +18.0%  |  2053 ns |   1591 ns  |  +22.5%  |
| 4  | vcpu0 -> vcpu16 |  319203289 ns |  265857795 ns | +16.7%  |  2080 ns |   1612 ns  |  +22.5%  |
| 5  | vcpu0 -> vcpu31 |  399790803 ns |  316207724 ns | +20.9%  |  2426 ns |   1511 ns  |  +37.7%  |

The test results indicate that VM with less than 16 vcpus have similar 
performance to the original.

The performance of VM witch 32 cores improvement can be observed. When 
injecting SGI into the first vCPU of the first aff0 group, the performance 
remains the same as before (because the number of iteration is also 1), 
but there is an improvement in performance when injecting interrupts into 
the last vCPU. When injecting vSGI into the first and last vCPU of the 
second aff0 group, the performance improvement is significant because 
compared to the original algorithm, it skipped iterates the first aff0 
group.

BTW, performance improvement can also be observed by microbench in 
kvm-unit-test with little modification :add 32 cores initialization, 
then change IPI target CPU in function ipi_exec.

The more vcpu a VM has, the greater the performance improvement of injecting 
vSGI into the vCPU in the last aff0 group.

Signed-off-by: Xu Zhao <zhaoxu.35@bytedance.com>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 152 ++++++++++++++---------------
 include/linux/kvm_host.h           |   5 +
 2 files changed, 78 insertions(+), 79 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 188d2187eede..af8f2d6b18c3 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -1013,44 +1013,64 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 
 	return 0;
 }
+
 /*
- * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
- * generation register ICC_SGI1R_EL1) with a given VCPU.
- * If the VCPU's MPIDR matches, return the level0 affinity, otherwise
- * return -1.
+ * Get affinity routing index from ICC_SGI_* register
+ * format:
+ *     aff3       aff2       aff1	aff0
+ * |- 8 bits -|- 8 bits -|- 8 bits -|- 4 bits -|
  */
-static int match_mpidr(u64 sgi_aff, u16 sgi_cpu_mask, struct kvm_vcpu *vcpu)
+static unsigned long sgi_to_affinity(unsigned long reg)
 {
-	unsigned long affinity;
-	int level0;
+	u64 aff;
 
-	/*
-	 * Split the current VCPU's MPIDR into affinity level 0 and the
-	 * rest as this is what we have to compare against.
-	 */
-	affinity = kvm_vcpu_get_mpidr_aff(vcpu);
-	level0 = MPIDR_AFFINITY_LEVEL(affinity, 0);
-	affinity &= ~MPIDR_LEVEL_MASK;
+	/* aff3 - aff1 */
+	aff = (((reg) & ICC_SGI1R_AFFINITY_3_MASK) >> ICC_SGI1R_AFFINITY_3_SHIFT) << 16 |
+		(((reg) & ICC_SGI1R_AFFINITY_2_MASK) >> ICC_SGI1R_AFFINITY_2_SHIFT) << 8 |
+		(((reg) & ICC_SGI1R_AFFINITY_1_MASK) >> ICC_SGI1R_AFFINITY_1_SHIFT);
 
-	/* bail out if the upper three levels don't match */
-	if (sgi_aff != affinity)
-		return -1;
+	/* aff0, the length of targetlist in sgi register is 16, which is 4bit  */
+	aff <<= 4;
 
-	/* Is this VCPU's bit set in the mask ? */
-	if (!(sgi_cpu_mask & BIT(level0)))
-		return -1;
-
-	return level0;
+	return aff;
 }
 
 /*
- * The ICC_SGI* registers encode the affinity differently from the MPIDR,
- * so provide a wrapper to use the existing defines to isolate a certain
- * affinity level.
+ * inject a vsgi to vcpu
  */
-#define SGI_AFFINITY_LEVEL(reg, level) \
-	((((reg) & ICC_SGI1R_AFFINITY_## level ##_MASK) \
-	>> ICC_SGI1R_AFFINITY_## level ##_SHIFT) << MPIDR_LEVEL_SHIFT(level))
+static inline void vgic_v3_inject_sgi(struct kvm_vcpu *vcpu, int sgi, bool allow_group1)
+{
+	struct vgic_irq *irq;
+	unsigned long flags;
+
+	irq = vgic_get_irq(vcpu->kvm, vcpu, sgi);
+
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+
+	/*
+	 * An access targeting Group0 SGIs can only generate
+	 * those, while an access targeting Group1 SGIs can
+	 * generate interrupts of either group.
+	 */
+	if (!irq->group || allow_group1) {
+		if (!irq->hw) {
+			irq->pending_latch = true;
+			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+		} else {
+			/* HW SGI? Ask the GIC to inject it */
+			int err;
+			err = irq_set_irqchip_state(irq->host_irq,
+						    IRQCHIP_STATE_PENDING,
+						     true);
+			WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
+			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+		}
+	} else {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	}
+
+	vgic_put_irq(vcpu->kvm, irq);
+}
 
 /**
  * vgic_v3_dispatch_sgi - handle SGI requests from VCPUs
@@ -1071,74 +1091,48 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *c_vcpu;
 	u16 target_cpus;
-	u64 mpidr;
 	int sgi;
 	int vcpu_id = vcpu->vcpu_id;
 	bool broadcast;
-	unsigned long c, flags;
+	unsigned long c, aff_index;
 
 	sgi = (reg & ICC_SGI1R_SGI_ID_MASK) >> ICC_SGI1R_SGI_ID_SHIFT;
 	broadcast = reg & BIT_ULL(ICC_SGI1R_IRQ_ROUTING_MODE_BIT);
 	target_cpus = (reg & ICC_SGI1R_TARGET_LIST_MASK) >> ICC_SGI1R_TARGET_LIST_SHIFT;
-	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
-	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
-	mpidr |= SGI_AFFINITY_LEVEL(reg, 1);
 
 	/*
-	 * We iterate over all VCPUs to find the MPIDRs matching the request.
-	 * If we have handled one CPU, we clear its bit to detect early
-	 * if we are already finished. This avoids iterating through all
-	 * VCPUs when most of the times we just signal a single VCPU.
+	 * Writing IRM bit is not a frequent behavior, so separate SGI injection into two parts.
+	 * If it is not broadcast, compute the affinity routing index first,
+	 * then iterate targetlist to find the target VCPU.
+	 * Or, inject sgi to all VCPUs but the calling one.
 	 */
-	kvm_for_each_vcpu(c, c_vcpu, kvm) {
-		struct vgic_irq *irq;
-
-		/* Exit early if we have dealt with all requested CPUs */
-		if (!broadcast && target_cpus == 0)
-			break;
+	if (likely(!broadcast)) {
+		/* compute affinity routing index */
+		aff_index = sgi_to_affinity(reg);
 
-		/* Don't signal the calling VCPU */
-		if (broadcast && c == vcpu_id)
-			continue;
-
-		if (!broadcast) {
-			int level0;
+		/* exit if meet a wrong affinity value */
+		if (aff_index >= atomic_read(&kvm->online_vcpus))
+			return;
 
-			level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
-			if (level0 == -1)
+		/* Iterate target list */
+		kvm_for_each_target_list(c, target_cpus) {
+			if (!(target_cpus & (1 << c)))
 				continue;
 
-			/* remove this matching VCPU from the mask */
-			target_cpus &= ~BIT(level0);
-		}
+			c_vcpu = kvm_get_vcpu_by_id(kvm, aff_index+c);
+			if (!c_vcpu)
+				break;
 
-		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
-
-		raw_spin_lock_irqsave(&irq->irq_lock, flags);
-
-		/*
-		 * An access targeting Group0 SGIs can only generate
-		 * those, while an access targeting Group1 SGIs can
-		 * generate interrupts of either group.
-		 */
-		if (!irq->group || allow_group1) {
-			if (!irq->hw) {
-				irq->pending_latch = true;
-				vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
-			} else {
-				/* HW SGI? Ask the GIC to inject it */
-				int err;
-				err = irq_set_irqchip_state(irq->host_irq,
-							    IRQCHIP_STATE_PENDING,
-							    true);
-				WARN_RATELIMIT(err, "IRQ %d", irq->host_irq);
-				raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-			}
-		} else {
-			raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+			vgic_v3_inject_sgi(c_vcpu, sgi, allow_group1);
 		}
+	} else {
+		kvm_for_each_vcpu(c, c_vcpu, kvm) {
+			/* don't signal the calling vcpu  */
+			if (c_vcpu->vcpu_id == vcpu_id)
+				continue;
 
-		vgic_put_irq(vcpu->kvm, irq);
+			vgic_v3_inject_sgi(c_vcpu, sgi, allow_group1);
+		}
 	}
 }
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 9d3ac7720da9..9b4afea7a1ee 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -910,6 +910,11 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 	xa_for_each_range(&kvm->vcpu_array, idx, vcpup, 0, \
 			  (atomic_read(&kvm->online_vcpus) - 1))
 
+#define kvm_for_each_target_list(idx, target_cpus) \
+	for (idx = target_cpus & 0xff ? 0 : (ICC_SGI1R_AFFINITY_1_SHIFT>>1); \
+		(1 << idx) <= target_cpus; \
+		idx++)
+
 static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 {
 	struct kvm_vcpu *vcpu = NULL;
-- 
2.20.1

