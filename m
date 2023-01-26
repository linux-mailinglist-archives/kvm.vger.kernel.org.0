Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E441667DA0A
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 00:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbjAZX4W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 18:56:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232141AbjAZX4S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 18:56:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE30442D3
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 15:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674777325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x/0EMt1THyulqv9ZI+2w89IGqHaZMQ5iccsFYm5z1og=;
        b=dKx/knhDui5ApfPqPZgp7sA+y7HQ8YzDvu+Zn48DXPdbt4W7pxXUPmwrYggAWhdMyRUe8v
        pzN3h+gXcyaPMVqyw0WKZ5y/9h6CLLS4KWaLKm+pS/6Wi4IWhwWt13jolHzYYKo/4BNOpj
        tBB2+QzGuYXVu6WQiC9z70CcaHShHZo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-671-c6_-ctMeOP2_gwuiYcznTg-1; Thu, 26 Jan 2023 18:55:22 -0500
X-MC-Unique: c6_-ctMeOP2_gwuiYcznTg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47C0A38012C9;
        Thu, 26 Jan 2023 23:55:21 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 90C162166B26;
        Thu, 26 Jan 2023 23:55:13 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com,
        corbet@lwn.net, maz@kernel.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        yuzhe@nfschina.com, isaku.yamahata@intel.com, seanjc@google.com,
        ricarkol@google.com, eric.auger@redhat.com, renzhengeek@gmail.com,
        reijiw@google.com, shan.gavin@gmail.com
Subject: [PATCH v3 2/4] KVM: arm64: Add helper vgic_write_guest_lock()
Date:   Fri, 27 Jan 2023 07:54:49 +0800
Message-Id: <20230126235451.469087-3-gshan@redhat.com>
In-Reply-To: <20230126235451.469087-1-gshan@redhat.com>
References: <20230126235451.469087-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, the unknown no-running-vcpu sites are reported when a
dirty page is tracked by mark_page_dirty_in_slot(). Until now, the
only known no-running-vcpu site is saving vgic/its tables through
KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on KVM device
"kvm-arm-vgic-its". Unfortunately, there are more unknown sites to
be handled and no-running-vcpu context will be allowed in these
sites: (1) KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES} command
on KVM device "kvm-arm-vgic-its" to restore vgic/its tables. The
vgic3 LPI pending status could be restored. (2) Save vgic3 pending
table through KVM_DEV_ARM_{VGIC_GRP_CTRL, VGIC_SAVE_PENDING_TABLES}
command on KVM device "kvm-arm-vgic-v3".

In order to handle those unknown cases, we need a unified helper
vgic_write_guest_lock(). struct vgic_dist::save_its_tables_in_progress
is also renamed to struct vgic_dist::save_tables_in_progress.

No functional change intended.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-its.c | 13 +++++--------
 arch/arm64/kvm/vgic/vgic.h     | 13 +++++++++++++
 include/kvm/arm_vgic.h         |  2 +-
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index ad4bb69ab83e..887dfa6cc79d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2186,7 +2186,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
-	return kvm_write_guest_lock(kvm, gpa, &val, ite_esz);
+	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
 }
 
 /**
@@ -2338,7 +2338,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
-	return kvm_write_guest_lock(kvm, ptr, &val, dte_esz);
+	return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
 }
 
 /**
@@ -2525,7 +2525,7 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
-	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
+	return vgic_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
 /*
@@ -2606,7 +2606,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	 */
 	val = 0;
 	BUG_ON(cte_esz > sizeof(val));
-	ret = kvm_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
+	ret = vgic_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
 	return ret;
 }
 
@@ -2742,7 +2742,6 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
 	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT) /* Nothing to do */
@@ -2762,9 +2761,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		vgic_its_reset(kvm, its);
 		break;
 	case KVM_DEV_ARM_ITS_SAVE_TABLES:
-		dist->save_its_tables_in_progress = true;
 		ret = abi->save_tables(its);
-		dist->save_its_tables_in_progress = false;
 		break;
 	case KVM_DEV_ARM_ITS_RESTORE_TABLES:
 		ret = abi->restore_tables(its);
@@ -2791,7 +2788,7 @@ bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	return dist->save_its_tables_in_progress;
+	return dist->save_tables_in_progress;
 }
 
 static int vgic_its_set_attr(struct kvm_device *dev,
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 056425e3a490..3804b3e946fd 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -132,6 +132,19 @@ static inline bool vgic_irq_is_multi_sgi(struct vgic_irq *irq)
 	return vgic_irq_get_lr_count(irq) > 1;
 }
 
+static inline int vgic_write_guest_lock(struct kvm *kvm, gpa_t gpa,
+					const void *data, unsigned long len)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	int ret;
+
+	dist->save_tables_in_progress = true;
+	ret = kvm_write_guest_lock(kvm, gpa, data, len);
+	dist->save_tables_in_progress = false;
+
+	return ret;
+}
+
 /*
  * This struct provides an intermediate representation of the fields contained
  * in the GICH_VMCR and ICH_VMCR registers, such that code exporting the GIC
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9270cd87da3f..a0be53bc5703 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -263,7 +263,7 @@ struct vgic_dist {
 	struct vgic_io_device	dist_iodev;
 
 	bool			has_its;
-	bool			save_its_tables_in_progress;
+	bool			save_tables_in_progress;
 
 	/*
 	 * Contains the attributes and gpa of the LPI configuration table.
-- 
2.23.0

