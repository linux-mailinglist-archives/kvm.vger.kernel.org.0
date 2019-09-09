Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C51FADA48
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2019 15:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731246AbfIINtC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 09:49:02 -0400
Received: from foss.arm.com ([217.140.110.172]:50562 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730866AbfIINtB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 09:49:01 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04A201650;
        Mon,  9 Sep 2019 06:49:01 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BE2F13F59C;
        Mon,  9 Sep 2019 06:48:58 -0700 (PDT)
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 04/17] KVM: arm/arm64: vgic-its: Invalidate MSI-LPI translation cache on specific commands
Date:   Mon,  9 Sep 2019 14:47:54 +0100
Message-Id: <20190909134807.27978-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LPI translation cache needs to be discarded when an ITS command
may affect the translation of an LPI (DISCARD, MAPC and MAPD with V=0)
or the routing of an LPI to a redistributor with disabled LPIs (MOVI,
MOVALL).

We decide to perform a full invalidation of the cache, irrespective
of the LPI that is affected. Commands are supposed to be rare enough
that it doesn't matter.

Tested-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index cc6b5e49a312..09a179820816 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -722,6 +722,8 @@ static int vgic_its_cmd_handle_discard(struct kvm *kvm, struct vgic_its *its,
 		 * don't bother here since we clear the ITTE anyway and the
 		 * pending state is a property of the ITTE struct.
 		 */
+		vgic_its_invalidate_cache(kvm);
+
 		its_free_ite(kvm, ite);
 		return 0;
 	}
@@ -757,6 +759,8 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	ite->collection = collection;
 	vcpu = kvm_get_vcpu(kvm, collection->target_addr);
 
+	vgic_its_invalidate_cache(kvm);
+
 	return update_affinity(ite->irq, vcpu);
 }
 
@@ -985,6 +989,8 @@ static void vgic_its_free_device(struct kvm *kvm, struct its_device *device)
 	list_for_each_entry_safe(ite, temp, &device->itt_head, ite_list)
 		its_free_ite(kvm, ite);
 
+	vgic_its_invalidate_cache(kvm);
+
 	list_del(&device->dev_list);
 	kfree(device);
 }
@@ -1090,6 +1096,7 @@ static int vgic_its_cmd_handle_mapc(struct kvm *kvm, struct vgic_its *its,
 
 	if (!valid) {
 		vgic_its_free_collection(its, coll_id);
+		vgic_its_invalidate_cache(kvm);
 	} else {
 		collection = find_collection(its, coll_id);
 
@@ -1238,6 +1245,8 @@ static int vgic_its_cmd_handle_movall(struct kvm *kvm, struct vgic_its *its,
 		vgic_put_irq(kvm, irq);
 	}
 
+	vgic_its_invalidate_cache(kvm);
+
 	kfree(intids);
 	return 0;
 }
-- 
2.20.1

