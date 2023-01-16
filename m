Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4286466B680
	for <lists+kvm@lfdr.de>; Mon, 16 Jan 2023 05:05:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231916AbjAPEFt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 23:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbjAPEFj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 23:05:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549B983CA
        for <kvm@vger.kernel.org>; Sun, 15 Jan 2023 20:04:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673841890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QaWOUNPCOLrCK48ZZkRvvzXiWltPmrtQJNoTHypPAnc=;
        b=HKDbWkaDlwvANzXdGDMBuAvQQLQ5wZgG+kfzUKN96ItVWuO08B1eTLHdqFAUx13ulTRGvK
        4LOKJxSep5X2Nv+N/e6NPSJoLlwkOjqD64tpL8uxWLDhU9mAjVLoY5Oh/UyJYc6cxN2Pbk
        MFUrAZbHzwSrdqSCn5TRMAydDtxLIrA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-556-v6iwQVNQNJqo5UeIelcYkA-1; Sun, 15 Jan 2023 23:04:45 -0500
X-MC-Unique: v6iwQVNQNJqo5UeIelcYkA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3F8691C08DA2;
        Mon, 16 Jan 2023 04:04:44 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 44027492B05;
        Mon, 16 Jan 2023 04:04:36 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        corbet@lwn.net, james.morse@arm.com, suzuki.poulose@arm.com,
        oliver.upton@linux.dev, yuzenghui@huawei.com,
        catalin.marinas@arm.com, will@kernel.org, ricarkol@google.com,
        eric.auger@redhat.com, yuzhe@nfschina.com, renzhengeek@gmail.com,
        ardb@kernel.org, peterx@redhat.com, seanjc@google.com,
        shan.gavin@gmail.com
Subject: [PATCH 1/4] KVM: arm64: Allow saving vgic3 LPI pending status in no running vcpu context
Date:   Mon, 16 Jan 2023 12:04:02 +0800
Message-Id: <20230116040405.260935-2-gshan@redhat.com>
In-Reply-To: <20230116040405.260935-1-gshan@redhat.com>
References: <20230116040405.260935-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dirty ring is enabled, the dirty page information is pushed to
the dirty ring if there is a running VCPU context. Otherwise, the
dirty page information is still tracked by the backup dirty bitmap.
In order to detect if there is a running VCPU context when a guest
page becomes dirty, kvm_arch_allow_write_without_running_vcpu() was
introduced to warn when no running VCPU context exists on unknown
cases.

Other than the site of saving ITS tables, it's possible to save vgic3
LPI pending status in no running vcpu context because it can happen when
ITS ITE is restored through the command KVM_DEV_ARM_ITS_RESTORE_TABLES
on 'kvm-arm-vgic-its' device.

Fix it by allowing to save vgic3 LPI pending status in no running
vcpu context.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 arch/arm64/kvm/vgic/vgic-its.c | 3 ++-
 arch/arm64/kvm/vgic/vgic-v3.c  | 3 +++
 include/kvm/arm_vgic.h         | 1 +
 4 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9807b05a1b57..18b245a0ba02 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8071,8 +8071,9 @@ state is final and avoid missing dirty pages from another ioctl ordered
 after the bitmap collection.
 
 NOTE: One example of using the backup bitmap is saving arm64 vgic/its
-tables through KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_SAVE_TABLES} command on
-KVM device "kvm-arm-vgic-its" when dirty ring is enabled.
+tables and vgic3 LPI pending status through KVM_DEV_ARM_{VGIC_GRP_CTRL,
+ITS_SAVE_TABLES} and KVM_DEV_ARM_{VGIC_GRP_CTRL, ITS_RESTORE_TABLES}
+command on KVM device "kvm-arm-vgic-its" when dirty ring is enabled.
 
 8.30 KVM_CAP_XEN_HVM
 --------------------
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 94a666dd1443..119a9c7a0a52 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2792,7 +2792,8 @@ bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	return dist->save_its_tables_in_progress;
+	return dist->save_vgic_v3_tables_in_progress ||
+	       dist->save_its_tables_in_progress;
 }
 
 static int vgic_its_set_attr(struct kvm_device *dev,
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index 2074521d4a8c..32998c8587a8 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -304,6 +304,7 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
 int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 {
 	struct kvm_vcpu *vcpu;
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	int byte_offset, bit_nr;
 	gpa_t pendbase, ptr;
 	bool status;
@@ -339,7 +340,9 @@ int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
 	if (status) {
 		/* clear consumed data */
 		val &= ~(1 << bit_nr);
+		dist->save_vgic_v3_tables_in_progress = true;
 		ret = kvm_write_guest_lock(kvm, ptr, &val, 1);
+		dist->save_vgic_v3_tables_in_progress = false;
 		if (ret)
 			return ret;
 	}
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 9270cd87da3f..0485b4e82b00 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -264,6 +264,7 @@ struct vgic_dist {
 
 	bool			has_its;
 	bool			save_its_tables_in_progress;
+	bool			save_vgic_v3_tables_in_progress;
 
 	/*
 	 * Contains the attributes and gpa of the LPI configuration table.
-- 
2.23.0

