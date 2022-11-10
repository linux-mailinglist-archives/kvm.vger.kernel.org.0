Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEF562405C
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 11:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiKJKvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 05:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbiKJKvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 05:51:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BCCD21247
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 02:50:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668077410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OuxR8ic4ApH6s9+fblgd/D12V3g7wPb1hOXM4M8lNfM=;
        b=gp2rAIXb+TA3pX3Ze2M5M77D4fPFHw9vDsqG7fqQ6MpwIx7uldHWOcjDxHvW4sVFFjYdEo
        Cqt5uZTTpfQdDQR82SbQmT+WGXYYtqK1YLmsxyqSP6+bMcfHT39ciHBRGRlm9RkUsCm96X
        rsTGvNWevxjZYwhG12EaImuZHjoIiSc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-478-jvvqsgAeOLCYg-xJfXYEWA-1; Thu, 10 Nov 2022 05:50:08 -0500
X-MC-Unique: jvvqsgAeOLCYg-xJfXYEWA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F07BC801231;
        Thu, 10 Nov 2022 10:50:07 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-49.bne.redhat.com [10.64.54.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BC66C1415114;
        Thu, 10 Nov 2022 10:49:55 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, maz@kernel.org,
        seanjc@google.com, shuah@kernel.org, catalin.marinas@arm.com,
        andrew.jones@linux.dev, ajones@ventanamicro.com,
        bgardon@google.com, dmatlack@google.com, will@kernel.org,
        suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: [PATCH v10 4/7] KVM: arm64: Enable ring-based dirty memory tracking
Date:   Thu, 10 Nov 2022 18:49:11 +0800
Message-Id: <20221110104914.31280-5-gshan@redhat.com>
In-Reply-To: <20221110104914.31280-1-gshan@redhat.com>
References: <20221110104914.31280-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enable ring-based dirty memory tracking on ARM64:

  - Enable CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL.

  - Enable CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP.

  - Set KVM_DIRTY_LOG_PAGE_OFFSET for the ring buffer's physical page
    offset.

  - Add ARM64 specific kvm_arch_allow_write_without_running_vcpu() to
    keep the site of saving vgic/its tables out of the no-running-vcpu
    radar.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst    |  2 +-
 arch/arm64/include/uapi/asm/kvm.h |  1 +
 arch/arm64/kvm/Kconfig            |  2 ++
 arch/arm64/kvm/arm.c              |  3 +++
 arch/arm64/kvm/vgic/vgic-its.c    | 20 ++++++++++++++++++++
 include/kvm/arm_vgic.h            |  1 +
 6 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1f1b09aa6db4..773e4b202f47 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7921,7 +7921,7 @@ regardless of what has actually been exposed through the CPUID leaf.
 8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
 ----------------------------------------------------------
 
-:Architectures: x86
+:Architectures: x86, arm64
 :Parameters: args[0] - size of the dirty log ring
 
 KVM is capable of tracking dirty memory using ring buffers that are
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 316917b98707..a7a857f1784d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -43,6 +43,7 @@
 #define __KVM_HAVE_VCPU_EVENTS
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+#define KVM_DIRTY_LOG_PAGE_OFFSET 64
 
 #define KVM_REG_SIZE(id)						\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 815cc118c675..05da3c8f7e88 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -32,6 +32,8 @@ menuconfig KVM
 	select KVM_VFIO
 	select HAVE_KVM_EVENTFD
 	select HAVE_KVM_IRQFD
+	select HAVE_KVM_DIRTY_RING_ACQ_REL
+	select NEED_KVM_DIRTY_RING_WITH_BITMAP
 	select HAVE_KVM_MSI
 	select HAVE_KVM_IRQCHIP
 	select HAVE_KVM_IRQ_ROUTING
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..6b097605e38c 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -746,6 +746,9 @@ static int check_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_SUSPEND, vcpu))
 			return kvm_vcpu_suspend(vcpu);
+
+		if (kvm_dirty_ring_check_request(vcpu))
+			return 0;
 	}
 
 	return 1;
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 733b53055f97..94a666dd1443 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2743,6 +2743,7 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
+	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
 	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT) /* Nothing to do */
@@ -2762,7 +2763,9 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		vgic_its_reset(kvm, its);
 		break;
 	case KVM_DEV_ARM_ITS_SAVE_TABLES:
+		dist->save_its_tables_in_progress = true;
 		ret = abi->save_tables(its);
+		dist->save_its_tables_in_progress = false;
 		break;
 	case KVM_DEV_ARM_ITS_RESTORE_TABLES:
 		ret = abi->restore_tables(its);
@@ -2775,6 +2778,23 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 	return ret;
 }
 
+/*
+ * kvm_arch_allow_write_without_running_vcpu - allow writing guest memory
+ * without the running VCPU when dirty ring is enabled.
+ *
+ * The running VCPU is required to track dirty guest pages when dirty ring
+ * is enabled. Otherwise, the backup bitmap should be used to track the
+ * dirty guest pages. When vgic/its tables are being saved, the backup
+ * bitmap is used to track the dirty guest pages due to the missed running
+ * VCPU in the period.
+ */
+bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+
+	return dist->save_its_tables_in_progress;
+}
+
 static int vgic_its_set_attr(struct kvm_device *dev,
 			     struct kvm_device_attr *attr)
 {
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4df9e73a8bb5..9270cd87da3f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -263,6 +263,7 @@ struct vgic_dist {
 	struct vgic_io_device	dist_iodev;
 
 	bool			has_its;
+	bool			save_its_tables_in_progress;
 
 	/*
 	 * Contains the attributes and gpa of the LPI configuration table.
-- 
2.23.0

