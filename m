Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0BCD618077
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 16:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiKCPEp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 11:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbiKCPDI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 11:03:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2EE1929C
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 08:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667487728;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NQfBuXDOrH1Yycxs8u+vcZb8jI8Lwx8edK3ZcCfcDBg=;
        b=bKORCeOBUZhtvoELvR0yLT+mynVuCa9DiQgGQG6KE/OdEgPZrU6fZKf3ukMSPvbEyMoeMM
        fCevuEC2CVD1sf2nNkcriDVG2AuXsT6pQtygYA55+ui0oco7NghPldKNw89eQz7awcsSKn
        xjamNQz+x38XuZw6NBv59x6LGoPxSMg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-29-5urxHFDhNc25cYgOjomTUw-1; Thu, 03 Nov 2022 11:02:04 -0400
X-MC-Unique: 5urxHFDhNc25cYgOjomTUw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 676D61064B5E;
        Thu,  3 Nov 2022 15:01:52 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5019A200BA7A;
        Thu,  3 Nov 2022 15:01:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: replace direct irq.h inclusion
Date:   Thu,  3 Nov 2022 11:01:51 -0400
Message-Id: <20221103150151.4057338-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

virt/kvm/irqchip.c is including "irq.h" from the arch-specific KVM source
directory (i.e. not from arch/*/include) for the sole purpose of retrieving
irqchip_in_kernel.

Making the function inline in a header that is already included,
such as asm/kvm_host.h, is not possible because it needs to look at
struct kvm which is defined after asm/kvm_host.h is included.  So add a
kvm_arch_irqchip_in_kernel non-inline function; irqchip_in_kernel() is
only performance critical on arm64 and x86, and the non-inline function
is enough on all other architectures.

irq.h can then be deleted from all architectures except x86.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/arm64/kvm/arm.c       |  5 +++++
 arch/arm64/kvm/irq.h       | 16 ----------------
 arch/powerpc/kvm/irq.h     | 22 ----------------------
 arch/powerpc/kvm/powerpc.c | 18 ++++++++++++++++--
 arch/s390/kvm/irq.h        | 19 -------------------
 arch/s390/kvm/kvm-s390.c   |  5 +++++
 arch/x86/kvm/irq.c         |  5 +++++
 include/linux/kvm_host.h   |  2 ++
 virt/kvm/irqchip.c         |  3 +--
 9 files changed, 34 insertions(+), 61 deletions(-)
 delete mode 100644 arch/arm64/kvm/irq.h
 delete mode 100644 arch/powerpc/kvm/irq.h
 delete mode 100644 arch/s390/kvm/irq.h

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..7b107fa540fa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2130,6 +2130,11 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
 	return NULL;
 }
 
+bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
+{
+	return irqchip_in_kernel(kvm);
+}
+
 bool kvm_arch_has_irq_bypass(void)
 {
 	return true;
diff --git a/arch/arm64/kvm/irq.h b/arch/arm64/kvm/irq.h
deleted file mode 100644
index 0d257de42c10..000000000000
--- a/arch/arm64/kvm/irq.h
+++ /dev/null
@@ -1,16 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * irq.h: in kernel interrupt controller related definitions
- * Copyright (c) 2016 Red Hat, Inc.
- *
- * This header is included by irqchip.c. However, on ARM, interrupt
- * controller declarations are located in include/kvm/arm_vgic.h since
- * they are mostly shared between arm and arm64.
- */
-
-#ifndef __IRQ_H
-#define __IRQ_H
-
-#include <kvm/arm_vgic.h>
-
-#endif
diff --git a/arch/powerpc/kvm/irq.h b/arch/powerpc/kvm/irq.h
deleted file mode 100644
index e6463f866abc..000000000000
--- a/arch/powerpc/kvm/irq.h
+++ /dev/null
@@ -1,22 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef __IRQ_H
-#define __IRQ_H
-
-#include <linux/kvm_host.h>
-
-static inline int irqchip_in_kernel(struct kvm *kvm)
-{
-	int ret = 0;
-
-#ifdef CONFIG_KVM_MPIC
-	ret = ret || (kvm->arch.mpic != NULL);
-#endif
-#ifdef CONFIG_KVM_XICS
-	ret = ret || (kvm->arch.xics != NULL);
-	ret = ret || (kvm->arch.xive != NULL);
-#endif
-	smp_rmb();
-	return ret;
-}
-
-#endif
diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
index b850b0efa201..04494a4fb37a 100644
--- a/arch/powerpc/kvm/powerpc.c
+++ b/arch/powerpc/kvm/powerpc.c
@@ -36,7 +36,6 @@
 #include <asm/setup.h>
 
 #include "timing.h"
-#include "irq.h"
 #include "../mm/mmu_decl.h"
 
 #define CREATE_TRACE_POINTS
@@ -2165,10 +2164,25 @@ static int kvm_vm_ioctl_get_pvinfo(struct kvm_ppc_pvinfo *pvinfo)
 	return 0;
 }
 
+bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
+{
+	int ret = 0;
+
+#ifdef CONFIG_KVM_MPIC
+	ret = ret || (kvm->arch.mpic != NULL);
+#endif
+#ifdef CONFIG_KVM_XICS
+	ret = ret || (kvm->arch.xics != NULL);
+	ret = ret || (kvm->arch.xive != NULL);
+#endif
+	smp_rmb();
+	return ret;
+}
+
 int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
 			  bool line_status)
 {
-	if (!irqchip_in_kernel(kvm))
+	if (!kvm_arch_irqchip_in_kernel(kvm))
 		return -ENXIO;
 
 	irq_event->status = kvm_set_irq(kvm, KVM_USERSPACE_IRQ_SOURCE_ID,
diff --git a/arch/s390/kvm/irq.h b/arch/s390/kvm/irq.h
deleted file mode 100644
index 484608c71dd0..000000000000
--- a/arch/s390/kvm/irq.h
+++ /dev/null
@@ -1,19 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * s390 irqchip routines
- *
- * Copyright IBM Corp. 2014
- *
- *    Author(s): Cornelia Huck <cornelia.huck@de.ibm.com>
- */
-#ifndef __KVM_IRQ_H
-#define __KVM_IRQ_H
-
-#include <linux/kvm_host.h>
-
-static inline int irqchip_in_kernel(struct kvm *kvm)
-{
-	return 1;
-}
-
-#endif
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 45d4b8182b07..b08586bebf78 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5559,6 +5559,11 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
+bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
+{
+	return true;
+}
+
 /* Section: memory related */
 int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				   const struct kvm_memory_slot *old,
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index f371f1292ca3..d8d50558f165 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -165,3 +165,8 @@ bool kvm_arch_irqfd_allowed(struct kvm *kvm, struct kvm_irqfd *args)
 
 	return resample ? irqchip_kernel(kvm) : irqchip_in_kernel(kvm);
 }
+
+bool kvm_arch_irqchip_in_kernel(struct kvm *kvm)
+{
+	return irqchip_in_kernel(kvm);
+}
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 18592bdf4c1b..12cfc935a9f1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -653,6 +653,8 @@ struct kvm_irq_routing_table {
 	 */
 	struct hlist_head map[];
 };
+
+bool kvm_arch_irqchip_in_kernel(struct kvm *kvm);
 #endif
 
 #ifndef KVM_INTERNAL_MEM_SLOTS
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 58e4f88b2b9f..1e567d1f6d3d 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -17,7 +17,6 @@
 #include <linux/srcu.h>
 #include <linux/export.h>
 #include <trace/events/kvm.h>
-#include "irq.h"
 
 int kvm_irq_map_gsi(struct kvm *kvm,
 		    struct kvm_kernel_irq_routing_entry *entries, int gsi)
@@ -50,7 +49,7 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi)
 {
 	struct kvm_kernel_irq_routing_entry route;
 
-	if (!irqchip_in_kernel(kvm) || (msi->flags & ~KVM_MSI_VALID_DEVID))
+	if (!kvm_arch_irqchip_in_kernel(kvm) || (msi->flags & ~KVM_MSI_VALID_DEVID))
 		return -EINVAL;
 
 	route.msi.address_lo = msi->address_lo;
-- 
2.31.1

