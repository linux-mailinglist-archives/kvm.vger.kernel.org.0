Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA36B37A3E
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 18:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbfFFQzO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 12:55:14 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:50762 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728756AbfFFQzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 12:55:13 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6ABCB15BF;
        Thu,  6 Jun 2019 09:55:13 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DE243F690;
        Thu,  6 Jun 2019 09:55:11 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Julien Thierry <julien.thierry@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
Subject: [PATCH 4/8] KVM: arm/arm64: vgic-its: Add kvm parameter to vgic_its_free_collection
Date:   Thu,  6 Jun 2019 17:54:51 +0100
Message-Id: <20190606165455.162478-5-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190606165455.162478-1-marc.zyngier@arm.com>
References: <20190606165455.162478-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we are going to perform some VM-wide operations when freeing
a collection, add the kvm pointer to vgic_its_free_collection.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index bc370b6c5afa..f637edd77e1f 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -885,7 +885,8 @@ static int vgic_its_alloc_collection(struct vgic_its *its,
 	return 0;
 }
 
-static void vgic_its_free_collection(struct vgic_its *its, u32 coll_id)
+static void vgic_its_free_collection(struct kvm *kvm,
+				     struct vgic_its *its, u32 coll_id)
 {
 	struct its_collection *collection;
 	struct its_device *device;
@@ -974,7 +975,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	ite = vgic_its_alloc_ite(device, collection, event_id);
 	if (IS_ERR(ite)) {
 		if (new_coll)
-			vgic_its_free_collection(its, coll_id);
+			vgic_its_free_collection(kvm, its, coll_id);
 		return PTR_ERR(ite);
 	}
 
@@ -984,7 +985,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
 	if (IS_ERR(irq)) {
 		if (new_coll)
-			vgic_its_free_collection(its, coll_id);
+			vgic_its_free_collection(kvm, its, coll_id);
 		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
 	}
@@ -1025,7 +1026,7 @@ static void vgic_its_free_collection_list(struct kvm *kvm, struct vgic_its *its)
 	struct its_collection *cur, *temp;
 
 	list_for_each_entry_safe(cur, temp, &its->collection_list, coll_list)
-		vgic_its_free_collection(its, cur->collection_id);
+		vgic_its_free_collection(kvm, its, cur->collection_id);
 }
 
 /* Must be called with its_lock mutex held */
@@ -1110,7 +1111,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 		return E_ITS_MAPC_PROCNUM_OOR;
 
 	if (!valid) {
-		vgic_its_free_collection(its, coll_id);
+		vgic_its_free_collection(kvm, its, coll_id);
 	} else {
 		collection = find_collection(its, coll_id);
 
-- 
2.20.1

