Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E26337A8B80
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjITSRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbjITSRr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:17:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989BFDD
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:17:41 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0B3C43391;
        Wed, 20 Sep 2023 18:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695233861;
        bh=wzE7HqcraBe9mrlMhJ+Pu6o6vKM3Z/OrOZBJZhhfoAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVjPeXYl+oeQ42iz3scoQeXLapBq339ixBgZa4YEeTBP1NtSKwhrDju4+2ef8G2vx
         WlQJpjeThcva37UNOpL8IuZUBYC5HtfB72ml5He9XXy7g3+lhELGIg7I7rwE5nKP7V
         ctdVtxMPlIpVPkj+gd/iwKbptbXs+xJ9dWe6Pq8VCUTYbhhs5FjqcSKPBzHlTxGD7e
         1H+TPtjU14mkV8G01mkfqCLeu2n8mvMm2PgHRcQTNsW74tq2ixuBxOtc0nBujg4Tt1
         7he5lkc2iUjF3/0CzVFsLNyot/AzvLabt+bz81A5z6m94PxWAztiWEv50AhWCq1YOS
         V2oiQL09Du9ag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qj1lb-00Ejx0-72;
        Wed, 20 Sep 2023 19:17:39 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Joey Gouly <joey.gouly@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2 10/11] KVM: arm64: vgic-v3: Optimize affinity-based SGI injection
Date:   Wed, 20 Sep 2023 19:17:30 +0100
Message-Id: <20230920181731.2232453-11-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230920181731.2232453-1-maz@kernel.org>
References: <20230920181731.2232453-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, shameerali.kolothum.thodi@huawei.com, zhaoxu.35@bytedance.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our affinity-based SGI injection code is a bit daft. We iterate
over all the CPUs trying to match the set of affinities that the
guest is trying to reach, leading to some very bad behaviours
if the selected targets are at a high vcpu index.

Instead, we can now use the fact that we have an optimised
MPIDR to vcpu mapping, and only look at the relevant values.

This results in a much faster injection for large VMs, and
in a near constant time, irrespective of the position in the
vcpu index space.

As a bonus, this is mostly deleting a lot of hard-to-read
code. Nobody will complain about that.

Suggested-by: Xu Zhao <zhaoxu.35@bytedance.com>
Tested-by: Joey Gouly <joey.gouly@arm.com>
Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 56 ++++--------------------------
 1 file changed, 6 insertions(+), 50 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 88b8d4524854..c7337a0fd242 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -1013,35 +1013,6 @@ int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 
 	return 0;
 }
-/*
- * Compare a given affinity (level 1-3 and a level 0 mask, from the SGI
- * generation register ICC_SGI1R_EL1) with a given VCPU.
- * If the VCPU's MPIDR matches, return the level0 affinity, otherwise
- * return -1.
- */
-static int match_mpidr(u64 sgi_aff, u16 sgi_cpu_mask, struct kvm_vcpu *vcpu)
-{
-	unsigned long affinity;
-	int level0;
-
-	/*
-	 * Split the current VCPU's MPIDR into affinity level 0 and the
-	 * rest as this is what we have to compare against.
-	 */
-	affinity = kvm_vcpu_get_mpidr_aff(vcpu);
-	level0 = MPIDR_AFFINITY_LEVEL(affinity, 0);
-	affinity &= ~MPIDR_LEVEL_MASK;
-
-	/* bail out if the upper three levels don't match */
-	if (sgi_aff != affinity)
-		return -1;
-
-	/* Is this VCPU's bit set in the mask ? */
-	if (!(sgi_cpu_mask & BIT(level0)))
-		return -1;
-
-	return level0;
-}
 
 /*
  * The ICC_SGI* registers encode the affinity differently from the MPIDR,
@@ -1104,7 +1075,7 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 	struct kvm_vcpu *c_vcpu;
 	unsigned long target_cpus;
 	u64 mpidr;
-	u32 sgi;
+	u32 sgi, aff0;
 	unsigned long c;
 
 	sgi = FIELD_GET(ICC_SGI1R_SGI_ID_MASK, reg);
@@ -1122,31 +1093,16 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg, bool allow_group1)
 		return;
 	}
 
+	/* We iterate over affinities to find the corresponding vcpus */
 	mpidr = SGI_AFFINITY_LEVEL(reg, 3);
 	mpidr |= SGI_AFFINITY_LEVEL(reg, 2);
 	mpidr |= SGI_AFFINITY_LEVEL(reg, 1);
 	target_cpus = FIELD_GET(ICC_SGI1R_TARGET_LIST_MASK, reg);
 
-	/*
-	 * We iterate over all VCPUs to find the MPIDRs matching the request.
-	 * If we have handled one CPU, we clear its bit to detect early
-	 * if we are already finished. This avoids iterating through all
-	 * VCPUs when most of the times we just signal a single VCPU.
-	 */
-	kvm_for_each_vcpu(c, c_vcpu, kvm) {
-		int level0;
-
-		/* Exit early if we have dealt with all requested CPUs */
-		if (target_cpus == 0)
-			break;
-		level0 = match_mpidr(mpidr, target_cpus, c_vcpu);
-		if (level0 == -1)
-			continue;
-
-		/* remove this matching VCPU from the mask */
-		target_cpus &= ~BIT(level0);
-
-		vgic_v3_queue_sgi(c_vcpu, sgi, allow_group1);
+	for_each_set_bit(aff0, &target_cpus, hweight_long(ICC_SGI1R_TARGET_LIST_MASK)) {
+		c_vcpu = kvm_mpidr_to_vcpu(kvm, mpidr | aff0);
+		if (c_vcpu)
+			vgic_v3_queue_sgi(c_vcpu, sgi, allow_group1);
 	}
 }
 
-- 
2.34.1

