Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 379A0780A6D
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376379AbjHRKr3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358466AbjHRKr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:47:26 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DAF26A8
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 03:47:24 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bdbbede5d4so6140115ad.2
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 03:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1692355644; x=1692960444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q8CljcIzSD3WaMhdJV7oVB8dUjB3pQnvG2zo52838eU=;
        b=VsRs0skD+GCCH+F6uh2DHoduYb2ierVpOlgnlqR/iPlMMIg9mqizLqEQnu8i2xoCDY
         n506eI/BIs5kb9X2y79er6ve2qnZYc5EnojAANk/uAcEYpOCNcFVO3jwHJzAPGgr2nLV
         rkyshAUpkt8ZfTuLI/l0ORVSmjlV738OGHS0Q0dCuVqibGYhg6wLIpL/tH3A2LHYEZaY
         dIccQgHexQ+D+FivR0/3ou41T4jPaWm0MPVRiXkgtHoQupe8fBG+QWzGIwCIuw98NY1b
         IFQacaIkBaeV1xIC/Z40OmK01uHDMaDyALMoXl178BkPGG+YmmNnele759+nVvDeccYY
         Q4/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692355644; x=1692960444;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q8CljcIzSD3WaMhdJV7oVB8dUjB3pQnvG2zo52838eU=;
        b=JO/oGyN+3dnGO62YADeit7vQxumlykpgzPu2OtUEDDJONu3sdx1lnfF9j+D2y3+8z8
         RU0x9yuDMKk22if7cov30BoSISo6YIc0B7swNK5dPRrIpuujl4H31wMEYjRyN9njVzIF
         4tpy++9skaQSk4CubfR3inQT7tp4Obg9keViL1vfqfLtxvY6VCsq9roQMmvb3w4FbB07
         s6WAy1KfGbFILpVw7aEZd2D+pphsuEHQLlMA8f8Eqqu2/cOBp782VZzdMu6j8nSUifta
         U3WazIYfy0LTQvgoN3lfZGd+vvHlYQ9hGMNz7B9YT723xC9nQ9kIseGLKt8CxaSMZJvo
         rF2w==
X-Gm-Message-State: AOJu0YyGOUU0mnirXeyyJnpyfQy5QxhoduM9MIcOP5msF/KyUcPUydBC
        gXgQKgGKj2jWwjaEkh5FNdfmEe+eC/TVKoI/QIK64t6nc0MHuA==
X-Google-Smtp-Source: AGHT+IF6ywlDdZ5abmAaOQevkPHRjhcmS8Ador2BLzOrNbprU0uyh4EOmRodNngTymdDkQf++3qARw==
X-Received: by 2002:a17:902:ee4d:b0:1bb:b34b:73a with SMTP id 13-20020a170902ee4d00b001bbb34b073amr2384001plo.25.1692355643840;
        Fri, 18 Aug 2023 03:47:23 -0700 (PDT)
Received: from C02D83NFML85.bytedance.net ([61.213.176.11])
        by smtp.gmail.com with ESMTPSA id jk24-20020a170903331800b001b9c960ffeasm1443581plb.47.2023.08.18.03.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 03:47:23 -0700 (PDT)
From:   Xu Zhao <zhaoxu.35@bytedance.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhouyibo@bytedance.com, zhouliang.001@bytedance.com,
        Xu Zhao <zhaoxu.35@bytedance.com>
Subject: [RFC] KVM: arm/arm64: optimize vSGI injection performance
Date:   Fri, 18 Aug 2023 18:47:04 +0800
Message-Id: <20230818104704.7651-1-zhaoxu.35@bytedance.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the worst case scenario, it may iterate over all vCPUs in the vm in order to complete
injecting an SGI interrupt. However, the ICC_SGI_* register provides affinity routing information,
and we are interested in exploring the possibility of utilizing this information to reduce iteration
times from a total of vcpu numbers to 16 (the length of the targetlist), or even 8 times.

This work is based on v5.4, and here is test data:
4 cores with vcpu pinning:
	  	 |               ipi benchmark           |	 vgic_v3_dispatch_sgi      |
		 |    original  |  with patch  | impoved | original | with patch | impoved |
| core0 -> core1 | 292610285 ns	| 299856696 ns |  -2.5%	 |  1471 ns |   1508 ns  |  -2.5%  |
| core0 -> core3 | 333815742 ns	| 327647989 ns |  +1.8%  |  1578 ns |   1532 ns  |  +2.9%  |
|  core0 -> all  | 439754104 ns | 433987192 ns |  +1.3%  |  2970 ns |   2875 ns  |  +3.2%  |

32 cores with vcpu pinning:
                  |               ipi benchmark                |        vgic_v3_dispatch_sgi      |
                  |    original    |    with patch  |  impoved | original | with patch | impoved  |
|  core0 -> core1 |  269153219 ns  |   261636906 ns |  +2.8%   |  1743 ns |   1706 ns  |  +2.1%   |
| core0 -> core31 |  685199666 ns  |   355250664 ns |  +48.2%  |  4238 ns |   1838 ns  |  +56.6%  |
|   core0 -> all  |  7281278980 ns |  3403240773 ns |  +53.3%  | 30879 ns |  13843 ns  |  +55.2%  |

Based on the test results, the performance of vm  with less than 16 cores remains almost the same,
while significant improvement can be observed with more than 16 cores.

Signed-off-by: Xu Zhao <zhaoxu.35@bytedance.com>
---
 include/linux/kvm_host.h         |   5 ++
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 136 +++++++++++++++----------------
 2 files changed, 73 insertions(+), 68 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 027e155daf8c..efc7b96946c1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -580,6 +580,11 @@ static inline struct kvm_vcpu *kvm_get_vcpu(struct kvm *kvm, int i)
 	     (vcpup = kvm_get_vcpu(kvm, idx)) != NULL; \
 	     idx++)
 
+#define kvm_for_each_target_vcpus(idx, target_cpus) \
+	for (idx = target_cpus & 0xff ? 0 : (ICC_SGI1R_AFFINITY_1_SHIFT>>1); \
+		(1 << idx) <= target_cpus; \
+		idx++)
+
 static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 {
 	struct kvm_vcpu *vcpu = NULL;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 24011280c4b1..bb64148ab75b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -852,44 +852,60 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 
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
+ *     aff3       aff2       aff1            aff0
+ * |- 8 bits -|- 8 bits -|- 8 bits -|- 4 bits or 8bits -|
  */
-static int match_mpidr(u64 sgi_aff, u16 sgi_cpu_mask, struct kvm_vcpu *vcpu)
+static u64 sgi_to_affinity(unsigned long reg)
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
+	/* if use range selector, TargetList[n] represents aff0 value ((RS * 16) + n) */
+	if ((reg) & ICC_SGI1R_RS_MASK) {
+		aff <<= 4;
+		aff |= (reg) & ICC_SGI1R_RS_MASK;
+	}
 
-	/* Is this VCPU's bit set in the mask ? */
-	if (!(sgi_cpu_mask & BIT(level0)))
-		return -1;
+	/* aff0, the length of targetlist in sgi register is 16, which is 4bit  */
+	aff <<= 4;
 
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
+		irq->pending_latch = true;
+		vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
+	} else {
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	}
+
+	vgic_put_irq(vcpu->kvm, irq);
+}
 
 /**
  * vgic_v3_dispatch_sgi - handle SGI requests from VCPUs
@@ -910,64 +926,48 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_vcpu *c_vcpu;
 	u16 target_cpus;
-	u64 mpidr;
 	int sgi, c;
 	int vcpu_id = vcpu->vcpu_id;
 	bool broadcast;
-	unsigned long flags;
+	u64 aff_index;
 
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
-
-		/* Don't signal the calling VCPU */
-		if (broadcast && c == vcpu_id)
-			continue;
+	if (likely(!broadcast)) {
+		/* compute affinity routing index */
+		aff_index = sgi_to_affinity(reg);
 
-		if (!broadcast) {
-			int level0;
+		/* Exit if meet a wrong affinity value */
+		if (aff_index >= atomic_read(&kvm->online_vcpus))
+			return;
 
-			level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
-			if (level0 == -1)
+		/* Iterate target list */
+		kvm_for_each_target_vcpus(c, target_cpus) {
+			if (!(target_cpus & (1 << c)))
 				continue;
 
-			/* remove this matching VCPU from the mask */
-			target_cpus &= ~BIT(level0);
-		}
-
-		irq = vgic_get_irq(vcpu->kvm, c_vcpu, sgi);
-
-		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+			c_vcpu = kvm_get_vcpu_by_id(kvm, aff_index+c);
+			if (!c_vcpu)
+				break;
 
-		/*
-		 * An access targetting Group0 SGIs can only generate
-		 * those, while an access targetting Group1 SGIs can
-		 * generate interrupts of either group.
-		 */
-		if (!irq->group || allow_group1) {
-			irq->pending_latch = true;
-			vgic_queue_irq_unlock(vcpu->kvm, irq, flags);
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
 
-- 
2.20.1

