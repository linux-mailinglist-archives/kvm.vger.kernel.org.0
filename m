Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BED7A8B76
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 20:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbjITSRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 14:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjITSRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 14:17:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DFF7CC
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 11:17:39 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46247C433C9;
        Wed, 20 Sep 2023 18:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695233859;
        bh=mxL4P7yUgjR3S1y0KT4GUtyVKfhUolb+zKoehUiWAHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BRWEweCA1x2R+uB7ZiO+9jL93VB0/YkVcs5fiCXmN18+MlMuN2on4ZE8czaNC1wkL
         w4S/WjIAevHqYGC0bIvf8qIRVJRXMpuw+1ghtgLkpaxfErhitQgGhIKKYuUGD6edJq
         QDd5yAZIidb3m1XCSVSH6u98szBhiXaFv7gPpLmTdpqonkZqJICrHaCcln0qEu/F9m
         25T/7fL5mFeKW1H6byW6r8BBdJ0rVRyduw2s8tZS8toR7hv0GcymjAgr6gIfUdLZ+M
         XELHsCJLEXu26F71Iz9nrvmfN6QX9zAJATJwQxTvfyQzo+jizDyre34M/NcsUV7zmK
         U7sq+RCMN5KEQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1qj1lZ-00Ejx0-5D;
        Wed, 20 Sep 2023 19:17:37 +0100
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
Subject: [PATCH v2 02/11] KVM: arm64: vgic-its: Treat the collection target address as a vcpu_id
Date:   Wed, 20 Sep 2023 19:17:22 +0100
Message-Id: <20230920181731.2232453-3-maz@kernel.org>
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

Since our emulated ITS advertises GITS_TYPER.PTA=0, the target
address associated to a collection is a PE number and not
an address. So far, so good. However, the PE number is what userspace
has provided given us (aka the vcpu_id), and not the internal vcpu
index.

Make sure we consistently retrieve the vcpu by ID rather than
by index, adding a helper that deals with most of the cases.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-its.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 5fe2365a629f..4aadcd24f6f6 100644
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
@@ -1382,7 +1388,7 @@ static int vgic_its_cmd_handle_invall(struct kvm *kvm, struct vgic_its *its,
 	if (!its_is_collection_mapped(collection))
 		return E_ITS_INVALL_UNMAPPED_COLLECTION;
 
-	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
+	vcpu = collection_to_vcpu(kvm, collection);
 	vgic_its_invall(vcpu);
 
 	return 0;
@@ -1413,8 +1419,9 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 	if (target1_addr == target2_addr)
 		return 0;
 
-	vcpu1 = kvm_get_vcpu(kvm, target1_addr);
-	vcpu2 = kvm_get_vcpu(kvm, target2_addr);
+	/* We advertise GITS_TYPER.PTA==0, making the address the vcpu ID */
+	vcpu1 = kvm_get_vcpu_by_id(kvm, target1_addr);
+	vcpu2 = kvm_get_vcpu_by_id(kvm, target2_addr);
 
 	irq_count = vgic_copy_lpi_list(kvm, vcpu1, &intids);
 	if (irq_count < 0)
-- 
2.34.1

