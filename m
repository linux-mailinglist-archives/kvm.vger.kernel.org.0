Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF377AFF7A
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 11:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbjI0JJa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 05:09:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjI0JJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 05:09:21 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53768BF
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 02:09:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3E9C433CA;
        Wed, 27 Sep 2023 09:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695805759;
        bh=k1vK2l5uy6QPUr7z0mkBh4JWQyKPl6kf9ryuSnEUE1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WEX7ydZjwIxb2aNA3/a/s2swNoambupqWeHQks9eVlPtHOnGpr9mYz/jPYnQZuznG
         fcAn93oqQY/yueClV9yZdOTePaZ8mD8caJbN2/sbdipnG4UmdrAGrMh4OXzwQDfJ0Q
         uAUl1f2r9O2UdUrAr6jOOCXUIxfyxcOWkL03AZU1Fc0nI7UMDn1N9TwKQJiww2qoHA
         Hh4Z5aTyAlSbogzIUYxGaO7Mj65aV0IVJsj6DZAKyATgcDiLAdIP2WpEVM1UlLL1aB
         s7WMEyEaiTGLYi4XtE+wPUXaPwwSsMQUXNOMzYdotkKJNf1pq1aoAVJxIca+XdOYfm
         /g3LqtFbXX5Bg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qlQXk-00GaLb-JP;
        Wed, 27 Sep 2023 10:09:16 +0100
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
Subject: [PATCH v3 02/11] KVM: arm64: vgic-its: Treat the collection target address as a vcpu_id
Date:   Wed, 27 Sep 2023 10:09:02 +0100
Message-Id: <20230927090911.3355209-3-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230927090911.3355209-1-maz@kernel.org>
References: <20230927090911.3355209-1-maz@kernel.org>
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

Since our emulated ITS advertises GITS_TYPER.PTA=0, the target
address associated to a collection is a PE number and not
an address. So far, so good. However, the PE number is what userspace
has provided given us (aka the vcpu_id), and not the internal vcpu
index.

Make sure we consistently retrieve the vcpu by ID rather than
by index, adding a helper that deals with most of the cases.

We also get rid of the pointless (and bogus) comparisons to
online_vcpus, which don't really make sense.

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 49 +++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 5fe2365a629f..2dad2d095160 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -378,6 +378,12 @@ static int update_affinity(struct vgic_irq *irq, struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static struct kvm_vcpu *collection_to_vcpu(struct kvm *kvm,
+					   struct its_collection *col)
+{
+	return kvm_get_vcpu_by_id(kvm, col->target_addr);
+}
+
 /*
  * Promotes the ITS view of affinity of an ITTE (which redistributor this LPI
  * is targeting) to the VGIC's view, which deals with target VCPUs.
@@ -391,7 +397,7 @@ static void update_affinity_ite(struct kvm *kvm, struct its_ite *ite)
 	if (!its_is_collection_mapped(ite->collection))
 		return;
 
-	vcpu = kvm_get_vcpu(kvm, ite->collection->target_addr);
+	vcpu = collection_to_vcpu(kvm, ite->collection);
 	update_affinity(ite->irq, vcpu);
 }
 
@@ -679,7 +685,7 @@ int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 	if (!ite || !its_is_collection_mapped(ite->collection))
 		return E_ITS_INT_UNMAPPED_INTERRUPT;
 
-	vcpu = kvm_get_vcpu(kvm, ite->collection->target_addr);
+	vcpu = collection_to_vcpu(kvm, ite->collection);
 	if (!vcpu)
 		return E_ITS_INT_UNMAPPED_INTERRUPT;
 
@@ -887,7 +893,7 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 		return E_ITS_MOVI_UNMAPPED_COLLECTION;
 
 	ite->collection = collection;
-	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+	vcpu = collection_to_vcpu(kvm, collection);
 
 	vgic_its_invalidate_cache(kvm);
 
@@ -1121,7 +1127,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	}
 
 	if (its_is_collection_mapped(collection))
-		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+		vcpu = collection_to_vcpu(kvm, collection);
 
 	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
 	if (IS_ERR(irq)) {
@@ -1242,21 +1248,22 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 				    u64 *its_cmd)
 {
 	u16 coll_id;
-	u32 target_addr;
 	struct its_collection *collection;
 	bool valid;
 
 	valid = its_cmd_get_validbit(its_cmd);
 	coll_id = its_cmd_get_collection(its_cmd);
-	target_addr = its_cmd_get_target_addr(its_cmd);
-
-	if (target_addr >= atomic_read(&kvm->online_vcpus))
-		return E_ITS_MAPC_PROCNUM_OOR;
 
 	if (!valid) {
 		vgic_its_free_collection(its, coll_id);
 		vgic_its_invalidate_cache(kvm);
 	} else {
+		struct kvm_vcpu *vcpu;
+
+		vcpu = kvm_get_vcpu_by_id(kvm, its_cmd_get_target_addr(its_cmd));
+		if (!vcpu)
+			return E_ITS_MAPC_PROCNUM_OOR;
+
 		collection = find_collection(its, coll_id);
 
 		if (!collection) {
@@ -1270,9 +1277,9 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 							coll_id);
 			if (ret)
 				return ret;
-			collection->target_addr = target_addr;
+			collection->target_addr = vcpu->vcpu_id;
 		} else {
-			collection->target_addr = target_addr;
+			collection->target_addr = vcpu->vcpu_id;
 			update_affinity_collection(kvm, its, collection);
 		}
 	}
@@ -1382,7 +1389,7 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 	if (!its_is_collection_mapped(collection))
 		return E_ITS_INVALL_UNMAPPED_COLLECTION;
 
-	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+	vcpu = collection_to_vcpu(kvm, collection);
 	vgic_its_invall(vcpu);
 
 	return 0;
@@ -1399,23 +1406,21 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 				      u64 *its_cmd)
 {
-	u32 target1_addr = its_cmd_get_target_addr(its_cmd);
-	u32 target2_addr = its_cmd_mask_field(its_cmd, 3, 16, 32);
 	struct kvm_vcpu *vcpu1, *vcpu2;
 	struct vgic_irq *irq;
 	u32 *intids;
 	int irq_count, i;
 
-	if (target1_addr >= atomic_read(&kvm->online_vcpus) ||
-	    target2_addr >= atomic_read(&kvm->online_vcpus))
+	/* We advertise GITS_TYPER.PTA==0, making the address the vcpu ID */
+	vcpu1 = kvm_get_vcpu_by_id(kvm, its_cmd_get_target_addr(its_cmd));
+	vcpu2 = kvm_get_vcpu_by_id(kvm, its_cmd_mask_field(its_cmd, 3, 16, 32));
+
+	if (!vcpu1 || !vcpu2)
 		return E_ITS_MOVALL_PROCNUM_OOR;
 
-	if (target1_addr == target2_addr)
+	if (vcpu1 == vcpu2)
 		return 0;
 
-	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
-	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
-
 	irq_count = vgic_copy_lpi_list(kvm, vcpu1, &intids);
 	if (irq_count < 0)
 		return irq_count;
@@ -2258,7 +2263,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 		return PTR_ERR(ite);
 
 	if (its_is_collection_mapped(collection))
-		vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+		vcpu = kvm_get_vcpu_by_id(kvm, collection->target_addr);
 
 	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
 	if (IS_ERR(irq)) {
@@ -2573,7 +2578,7 @@ static int vgic_its_restore_cte(struct vgic_its *its, gpa_t gpa, int esz)
 	coll_id = val & KVM_ITS_CTE_ICID_MASK;
 
 	if (target_addr != COLLECTION_NOT_MAPPED &&
-	    target_addr >= atomic_read(&kvm->online_vcpus))
+	    !kvm_get_vcpu_by_id(kvm, target_addr))
 		return -EINVAL;
 
 	collection = find_collection(its, coll_id);
-- 
2.34.1

