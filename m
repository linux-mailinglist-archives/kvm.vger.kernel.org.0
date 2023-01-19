Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41983674763
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjASXrE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbjASXqK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:46:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 837959F398
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674171919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tqz4YUxIF6mVdgsevg0bA/YI9z+lThvJUzjOoBDwe0o=;
        b=XUE5uv0DsUDX58Rblb7neFQuTva+Zmy660MIMKp+129yBcqMcp9tDqmmUrEE6ENSZIij1Z
        jNim3kO1Is9CedQFX22J2SdkcQ58s2c3ihSUo//r/ILiz74bBrHyT4ctcKVArXtmK6necd
        GUBgdJdSQeLdcg+6++q6QO9q5hlugMU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-502-AYbP35NZNt-BE4ogkexjGg-1; Thu, 19 Jan 2023 18:45:03 -0500
X-MC-Unique: AYbP35NZNt-BE4ogkexjGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9A50B811E9C;
        Thu, 19 Jan 2023 23:45:02 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A86CD2166B2A;
        Thu, 19 Jan 2023 23:44:55 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, maz@kernel.org,
        oliver.upton@linux.dev, will@kernel.org, gshan@redhat.com,
        ricarkol@google.com, eric.auger@redhat.com, yuzhe@nfschina.com,
        renzhengeek@gmail.com, reijiw@google.com, ardb@kernel.org,
        Julia.Lawall@inria.fr, yuzenghui@huawei.com, seanjc@google.com,
        shan.gavin@gmail.com
Subject: [PATCH v2 1/3] KVM: arm64: Add helper vgic_write_guest_lock()
Date:   Fri, 20 Jan 2023 07:44:03 +0800
Message-Id: <20230119234405.349644-2-gshan@redhat.com>
In-Reply-To: <20230119234405.349644-1-gshan@redhat.com>
References: <20230119234405.349644-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
is also renamed to struct vgic_dist::save_tables_in_progress. Besides,
"asm/kvm_mmu.h" needs to be included for "vgic.h" for the definition
of kvm_write_guest_lock().

No functional change intended.

Suggested-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/vgic-sys-reg-v3.c   |  1 +
 arch/arm64/kvm/vgic/vgic-irqfd.c   |  1 +
 arch/arm64/kvm/vgic/vgic-its.c     | 13 +++++--------
 arch/arm64/kvm/vgic/vgic-mmio-v2.c |  1 +
 arch/arm64/kvm/vgic/vgic-mmio.c    |  1 +
 arch/arm64/kvm/vgic/vgic-v4.c      |  1 +
 arch/arm64/kvm/vgic/vgic.c         |  1 +
 arch/arm64/kvm/vgic/vgic.h         | 13 +++++++++++++
 include/kvm/arm_vgic.h             |  2 +-
 9 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 9e7c486b48c2..215ce2dbdb7b 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -7,6 +7,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>
 #include "vgic/vgic.h"
 #include "sys_regs.h"
 
diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index 475059bacedf..f2581fe6620c 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -7,6 +7,7 @@
 #include <linux/kvm_host.h>
 #include <trace/events/kvm.h>
 #include <kvm/arm_vgic.h>
+#include <asm/kvm_mmu.h>
 #include "vgic.h"
 
 /**
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 94a666dd1443..2fe2922533ad 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -2187,7 +2187,7 @@ static int vgic_its_save_ite(struct vgic_its *its, struct its_device *dev,
 	       ((u64)ite->irq->intid << KVM_ITS_ITE_PINTID_SHIFT) |
 		ite->collection->collection_id;
 	val = cpu_to_le64(val);
-	return kvm_write_guest_lock(kvm, gpa, &val, ite_esz);
+	return vgic_write_guest_lock(kvm, gpa, &val, ite_esz);
 }
 
 /**
@@ -2339,7 +2339,7 @@ static int vgic_its_save_dte(struct vgic_its *its, struct its_device *dev,
 	       (itt_addr_field << KVM_ITS_DTE_ITTADDR_SHIFT) |
 		(dev->num_eventid_bits - 1));
 	val = cpu_to_le64(val);
-	return kvm_write_guest_lock(kvm, ptr, &val, dte_esz);
+	return vgic_write_guest_lock(kvm, ptr, &val, dte_esz);
 }
 
 /**
@@ -2526,7 +2526,7 @@ static int vgic_its_save_cte(struct vgic_its *its,
 	       ((u64)collection->target_addr << KVM_ITS_CTE_RDBASE_SHIFT) |
 	       collection->collection_id);
 	val = cpu_to_le64(val);
-	return kvm_write_guest_lock(its->dev->kvm, gpa, &val, esz);
+	return vgic_write_guest_lock(its->dev->kvm, gpa, &val, esz);
 }
 
 /*
@@ -2607,7 +2607,7 @@ static int vgic_its_save_collection_table(struct vgic_its *its)
 	 */
 	val = 0;
 	BUG_ON(cte_esz > sizeof(val));
-	ret = kvm_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
+	ret = vgic_write_guest_lock(its->dev->kvm, gpa, &val, cte_esz);
 	return ret;
 }
 
@@ -2743,7 +2743,6 @@ static int vgic_its_has_attr(struct kvm_device *dev,
 static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 {
 	const struct vgic_its_abi *abi = vgic_its_get_abi(its);
-	struct vgic_dist *dist = &kvm->arch.vgic;
 	int ret = 0;
 
 	if (attr == KVM_DEV_ARM_VGIC_CTRL_INIT) /* Nothing to do */
@@ -2763,9 +2762,7 @@ static int vgic_its_ctrl(struct kvm *kvm, struct vgic_its *its, u64 attr)
 		vgic_its_reset(kvm, its);
 		break;
 	case KVM_DEV_ARM_ITS_SAVE_TABLES:
-		dist->save_its_tables_in_progress = true;
 		ret = abi->save_tables(its);
-		dist->save_its_tables_in_progress = false;
 		break;
 	case KVM_DEV_ARM_ITS_RESTORE_TABLES:
 		ret = abi->restore_tables(its);
@@ -2792,7 +2789,7 @@ bool kvm_arch_allow_write_without_running_vcpu(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
 
-	return dist->save_its_tables_in_progress;
+	return dist->save_tables_in_progress;
 }
 
 static int vgic_its_set_attr(struct kvm_device *dev,
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v2.c b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
index e070cda86e12..90502ce5a97f 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v2.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v2.c
@@ -10,6 +10,7 @@
 
 #include <kvm/iodev.h>
 #include <kvm/arm_vgic.h>
+#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index b32d434c1d4a..36d851ee02d8 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -12,6 +12,7 @@
 #include <kvm/iodev.h>
 #include <kvm/arm_arch_timer.h>
 #include <kvm/arm_vgic.h>
+#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 #include "vgic-mmio.h"
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index ad06ba6c9b00..3396ad1b0f17 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -9,6 +9,7 @@
 #include <linux/irqdomain.h>
 #include <linux/kvm_host.h>
 #include <linux/irqchip/arm-gic-v3.h>
+#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index d97e6080b421..a17a40802af7 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -11,6 +11,7 @@
 #include <linux/nospec.h>
 
 #include <asm/kvm_hyp.h>
+#include <asm/kvm_mmu.h>
 
 #include "vgic.h"
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 0c8da72953f0..d16180eb1a92 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -131,6 +131,19 @@ static inline bool vgic_irq_is_multi_sgi(struct vgic_irq *irq)
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

