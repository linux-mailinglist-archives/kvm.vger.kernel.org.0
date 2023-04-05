Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 050EB6D83B2
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbjDEQaR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDEQaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:30:16 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 341D62736
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:30:13 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id j1-20020a05600c1c0100b003f04da00d07so2339705wms.1
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680712211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c538Zj8/ZzoWHrsl/6z0orfkIGBCyPJwQzxqT1TQtNk=;
        b=f+U64mz50PENhMb285WO1NXu9mcGs0+/5Y3IdTk0tAptZ1E545gCM11cQGsVUuTuRs
         zh0kgc2PuyWXy+p536JjoYXgU9s+xVjm2nmw3NQsWtlwVk1fpzZtOVMKOjxvdnBgSjbY
         RXCIG8xNFPQiAw5ubmUTB6ML53HYsaGogcdzXPSmmquDllIuEUXeCWdSmYPFyLdOuUqD
         Z8eQXlyuwIg1vghArjOVAIIvRyB0GtMoAEbiOyFDauZx7XVDPU73zRXMErZEioqfaQ+s
         I9VnI+WOv7BUm0aSZAKUqo8HA5LXvDQ1aE0wYP+wD2qcFDgWDmgGCCBX4DXeGk0b46Jq
         kwkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680712211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c538Zj8/ZzoWHrsl/6z0orfkIGBCyPJwQzxqT1TQtNk=;
        b=2vQ94xSjwEVrv6JA1Ie0wiHqRw33LyjnJSihCrqjTAkMsOQ4y5xP0d2ueHh3hjzco/
         l6jc9lFAP6W85AFz0I6lJPw1vMQ9iVU44E0fF2Rv1PoTaV9ThceeawiVdX2clbGY2i3Q
         V2+xgIJwpM1G2Js8BTaEdAjQmOMi3vuzE1EVc4CqdRdFeJFIZC+8fugE9yHIBI6WUENX
         Ubx8ZxsLGvvjoNOGDL5pvn6QpIXONBJndMFIeSy1IXNgf/sYOZTWFmkA0spxvU9gyJ7+
         WuMH8sak3gKHM6bWO99v9iKLoUCKz1E6ZhtJe5SEwF84Wt/p/QGdZi5Hqb/wPD7P5RuV
         GB5g==
X-Gm-Message-State: AAQBX9feu7aR+HNgI4ntQfjlXvmXiP1pk3YfPy0odHrvWu66MelOuBjZ
        1HZNkPKXIf+5N3/3BiwfEFYk8g==
X-Google-Smtp-Source: AKy350ZoLpvSIGR2eLwUNC0gl0hokXAD7gZfx2qqxGT8m2aFFBoBERrG5jnUMBC4FR2n3602amxgWQ==
X-Received: by 2002:a7b:c3ce:0:b0:3ed:8c60:c512 with SMTP id t14-20020a7bc3ce000000b003ed8c60c512mr4944253wmj.17.1680712211351;
        Wed, 05 Apr 2023 09:30:11 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id g6-20020a05600c4ec600b003edc4788fa0sm2796592wmq.2.2023.04.05.09.30.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:30:10 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paul Durrant <paul@xen.org>
Subject: [RFC PATCH 1/2] accel/kvm: Extract 'sysemu/kvm_irq.h' from 'sysemu/kvm.h'
Date:   Wed,  5 Apr 2023 18:30:00 +0200
Message-Id: <20230405163001.98573-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405163001.98573-1-philmd@linaro.org>
References: <20230405163001.98573-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"sysemu/kvm.h" header is meant to contain the 'external' KVM
API accessed by all the code base.

KVM *internal* API aims to reside in "sysemu/kvm_int.h",
accessible by files in accel/kvm/ and each target/ implementation.

Hardware models should only access the external API.
"sysemu/kvm.h" is quite big. Extract the KVM IRQ declarations
to "sysemu/kvm_irq.h" to reduce this header complexity.

This will ease extracting internal prototypes to "sysemu/kvm_int.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h           |  76 -------------------------
 include/sysemu/kvm_irq.h       | 100 +++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h     |   1 +
 accel/kvm/kvm-all.c            |   2 +
 accel/stubs/kvm-stub.c         |   1 +
 hw/arm/virt.c                  |   1 +
 hw/cpu/a15mpcore.c             |   1 +
 hw/hyperv/hyperv.c             |   1 +
 hw/i386/intel_iommu.c          |   1 +
 hw/i386/kvm/apic.c             |   1 +
 hw/i386/kvm/i8259.c            |   1 +
 hw/i386/kvm/ioapic.c           |   1 +
 hw/i386/kvmvapic.c             |   1 +
 hw/i386/pc.c                   |   1 +
 hw/i386/x86-iommu.c            |   1 +
 hw/intc/arm_gic.c              |   1 +
 hw/intc/arm_gic_common.c       |   1 +
 hw/intc/arm_gic_kvm.c          |   1 +
 hw/intc/arm_gicv3_common.c     |   1 +
 hw/intc/arm_gicv3_its_common.c |   1 +
 hw/intc/arm_gicv3_kvm.c        |   1 +
 hw/intc/ioapic.c               |   1 +
 hw/intc/openpic_kvm.c          |   1 +
 hw/intc/s390_flic_kvm.c        |   1 +
 hw/intc/spapr_xive_kvm.c       |   1 +
 hw/intc/xics.c                 |   1 +
 hw/intc/xics_kvm.c             |   1 +
 hw/misc/ivshmem.c              |   1 +
 hw/ppc/e500.c                  |   1 +
 hw/ppc/spapr_irq.c             |   1 +
 hw/remote/proxy.c              |   1 +
 hw/s390x/virtio-ccw.c          |   1 +
 hw/vfio/pci.c                  |   1 +
 hw/vfio/platform.c             |   1 +
 hw/virtio/virtio-pci.c         |   1 +
 target/arm/kvm.c               |   1 +
 target/i386/kvm/kvm.c          |   2 +
 target/i386/kvm/xen-emu.c      |   2 +
 target/i386/sev.c              |   1 +
 target/s390x/kvm/kvm.c         |   2 +
 40 files changed, 142 insertions(+), 76 deletions(-)
 create mode 100644 include/sysemu/kvm_irq.h

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 7902acdfd9..32e223a368 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -187,7 +187,6 @@ extern bool kvm_msi_use_devid;
 #endif  /* CONFIG_KVM_IS_POSSIBLE */
 
 struct kvm_run;
-struct kvm_lapic_state;
 struct kvm_irq_routing_entry;
 
 typedef struct KVMCapabilityInfo {
@@ -223,20 +222,6 @@ int kvm_has_debugregs(void);
 int kvm_max_nested_state_length(void);
 int kvm_has_pit_state2(void);
 int kvm_has_many_ioeventfds(void);
-int kvm_has_gsi_routing(void);
-int kvm_has_intx_set_mask(void);
-
-/**
- * kvm_arm_supports_user_irq
- *
- * Not all KVM implementations support notifications for kernel generated
- * interrupt events to user space. This function indicates whether the current
- * KVM implementation does support them.
- *
- * Returns: true if KVM supports using kernel generated IRQs from user space
- */
-bool kvm_arm_supports_user_irq(void);
-
 
 int kvm_on_sigbus_vcpu(CPUState *cpu, int code, void *addr);
 int kvm_on_sigbus(int code, void *addr);
@@ -395,17 +380,6 @@ int kvm_arch_release_virq_post(int virq);
 
 int kvm_arch_msi_data_to_gsi(uint32_t data);
 
-int kvm_set_irq(KVMState *s, int irq, int level);
-int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg);
-
-void kvm_irqchip_add_irq_route(KVMState *s, int gsi, int irqchip, int pin);
-
-void kvm_irqchip_add_change_notifier(Notifier *n);
-void kvm_irqchip_remove_change_notifier(Notifier *n);
-void kvm_irqchip_change_notify(void);
-
-void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
-
 struct kvm_guest_debug;
 struct kvm_debug_exit_arch;
 
@@ -479,56 +453,6 @@ void kvm_cpu_synchronize_state(CPUState *cpu);
 
 void kvm_init_cpu_signals(CPUState *cpu);
 
-/**
- * kvm_irqchip_add_msi_route - Add MSI route for specific vector
- * @c:      KVMRouteChange instance.
- * @vector: which vector to add. This can be either MSI/MSIX
- *          vector. The function will automatically detect whether
- *          MSI/MSIX is enabled, and fetch corresponding MSI
- *          message.
- * @dev:    Owner PCI device to add the route. If @dev is specified
- *          as @NULL, an empty MSI message will be inited.
- * @return: virq (>=0) when success, errno (<0) when failed.
- */
-int kvm_irqchip_add_msi_route(KVMRouteChange *c, int vector, PCIDevice *dev);
-int kvm_irqchip_update_msi_route(KVMState *s, int virq, MSIMessage msg,
-                                 PCIDevice *dev);
-void kvm_irqchip_commit_routes(KVMState *s);
-
-static inline KVMRouteChange kvm_irqchip_begin_route_changes(KVMState *s)
-{
-    return (KVMRouteChange) { .s = s, .changes = 0 };
-}
-
-static inline void kvm_irqchip_commit_route_changes(KVMRouteChange *c)
-{
-    if (c->changes) {
-        kvm_irqchip_commit_routes(c->s);
-        c->changes = 0;
-    }
-}
-
-void kvm_irqchip_release_virq(KVMState *s, int virq);
-
-int kvm_irqchip_add_adapter_route(KVMState *s, AdapterInfo *adapter);
-int kvm_irqchip_add_hv_sint_route(KVMState *s, uint32_t vcpu, uint32_t sint);
-
-int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
-                                       EventNotifier *rn, int virq);
-int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
-                                          int virq);
-int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
-                                   EventNotifier *rn, qemu_irq irq);
-int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n,
-                                      qemu_irq irq);
-void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi);
-void kvm_pc_setup_irq_routing(bool pci_enabled);
-void kvm_init_irq_routing(KVMState *s);
-
-bool kvm_kernel_irqchip_allowed(void);
-bool kvm_kernel_irqchip_required(void);
-bool kvm_kernel_irqchip_split(void);
-
 /**
  * kvm_arch_irqchip_create:
  * @KVMState: The KVMState pointer
diff --git a/include/sysemu/kvm_irq.h b/include/sysemu/kvm_irq.h
new file mode 100644
index 0000000000..f5f09fa1da
--- /dev/null
+++ b/include/sysemu/kvm_irq.h
@@ -0,0 +1,100 @@
+/*
+ * QEMU KVM IRQ helpers
+ *
+ * Copyright IBM, Corp. 2008
+ *
+ * Authors:
+ *  Anthony Liguori   <aliguori@us.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+
+/* header to be included in hardware (non-KVM-specific) code */
+
+#ifndef QEMU_KVM_IRQ_H
+#define QEMU_KVM_IRQ_H
+
+#include "qemu/notify.h"
+#include "sysemu/kvm.h"
+
+struct kvm_lapic_state;
+
+int kvm_has_gsi_routing(void);
+int kvm_has_intx_set_mask(void);
+
+/**
+ * kvm_arm_supports_user_irq
+ *
+ * Not all KVM implementations support notifications for kernel generated
+ * interrupt events to user space. This function indicates whether the current
+ * KVM implementation does support them.
+ *
+ * Returns: true if KVM supports using kernel generated IRQs from user space
+ */
+bool kvm_arm_supports_user_irq(void);
+
+void kvm_irqchip_add_change_notifier(Notifier *n);
+void kvm_irqchip_remove_change_notifier(Notifier *n);
+void kvm_irqchip_change_notify(void);
+
+/**
+ * kvm_irqchip_add_msi_route - Add MSI route for specific vector
+ * @c:      KVMRouteChange instance.
+ * @vector: which vector to add. This can be either MSI/MSIX
+ *          vector. The function will automatically detect whether
+ *          MSI/MSIX is enabled, and fetch corresponding MSI
+ *          message.
+ * @dev:    Owner PCI device to add the route. If @dev is specified
+ *          as @NULL, an empty MSI message will be inited.
+ * @return: virq (>=0) when success, errno (<0) when failed.
+ */
+int kvm_irqchip_add_msi_route(KVMRouteChange *c, int vector, PCIDevice *dev);
+int kvm_irqchip_update_msi_route(KVMState *s, int virq, MSIMessage msg,
+                                 PCIDevice *dev);
+void kvm_irqchip_commit_routes(KVMState *s);
+
+static inline KVMRouteChange kvm_irqchip_begin_route_changes(KVMState *s)
+{
+    return (KVMRouteChange) { .s = s, .changes = 0 };
+}
+
+static inline void kvm_irqchip_commit_route_changes(KVMRouteChange *c)
+{
+    if (c->changes) {
+        kvm_irqchip_commit_routes(c->s);
+        c->changes = 0;
+    }
+}
+
+void kvm_irqchip_release_virq(KVMState *s, int virq);
+
+int kvm_irqchip_add_adapter_route(KVMState *s, AdapterInfo *adapter);
+int kvm_irqchip_add_hv_sint_route(KVMState *s, uint32_t vcpu, uint32_t sint);
+
+int kvm_irqchip_add_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
+                                       EventNotifier *rn, int virq);
+int kvm_irqchip_remove_irqfd_notifier_gsi(KVMState *s, EventNotifier *n,
+                                          int virq);
+int kvm_irqchip_add_irqfd_notifier(KVMState *s, EventNotifier *n,
+                                   EventNotifier *rn, qemu_irq irq);
+int kvm_irqchip_remove_irqfd_notifier(KVMState *s, EventNotifier *n,
+                                      qemu_irq irq);
+void kvm_irqchip_set_qemuirq_gsi(KVMState *s, qemu_irq irq, int gsi);
+void kvm_pc_setup_irq_routing(bool pci_enabled);
+void kvm_init_irq_routing(KVMState *s);
+
+bool kvm_kernel_irqchip_allowed(void);
+bool kvm_kernel_irqchip_required(void);
+bool kvm_kernel_irqchip_split(void);
+
+
+int kvm_set_irq(KVMState *s, int irq, int level);
+int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg);
+
+void kvm_irqchip_add_irq_route(KVMState *s, int gsi, int irqchip, int pin);
+
+void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
+
+#endif
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index e24753abfe..637485ec96 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -12,6 +12,7 @@
 #define QEMU_KVM_I386_H
 
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 
 #define kvm_apic_in_kernel() (kvm_irqchip_in_kernel())
 
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f2a6ea6a68..982bd8cb7e 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -28,6 +28,8 @@
 #include "hw/pci/msix.h"
 #include "hw/s390x/adapter.h"
 #include "exec/gdbstub.h"
+#include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "sysemu/cpus.h"
diff --git a/accel/stubs/kvm-stub.c b/accel/stubs/kvm-stub.c
index c0e2df3fbf..89cdc5fd09 100644
--- a/accel/stubs/kvm-stub.c
+++ b/accel/stubs/kvm-stub.c
@@ -12,6 +12,7 @@
 
 #include "qemu/osdep.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "hw/pci/msi.h"
 
 KVMState *kvm_state;
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index dbbe639e61..68a2221a94 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -48,6 +48,7 @@
 #include "sysemu/tpm.h"
 #include "sysemu/tcg.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/hvf.h"
 #include "sysemu/qtest.h"
 #include "hw/loader.h"
diff --git a/hw/cpu/a15mpcore.c b/hw/cpu/a15mpcore.c
index 774ca9987a..cae30ed5ca 100644
--- a/hw/cpu/a15mpcore.c
+++ b/hw/cpu/a15mpcore.c
@@ -25,6 +25,7 @@
 #include "hw/irq.h"
 #include "hw/qdev-properties.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "kvm_arm.h"
 
 static void a15mp_priv_set_irq(void *opaque, int irq, int level)
diff --git a/hw/hyperv/hyperv.c b/hw/hyperv/hyperv.c
index 57b402b956..744cff6263 100644
--- a/hw/hyperv/hyperv.c
+++ b/hw/hyperv/hyperv.c
@@ -13,6 +13,7 @@
 #include "qapi/error.h"
 #include "exec/address-spaces.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "qemu/bitops.h"
 #include "qemu/error-report.h"
 #include "qemu/lockable.h"
diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index faade7def8..9b3c08f618 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -33,6 +33,7 @@
 #include "hw/i386/x86-iommu.h"
 #include "hw/pci-host/q35.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/dma.h"
 #include "sysemu/sysemu.h"
 #include "hw/i386/apic_internal.h"
diff --git a/hw/i386/kvm/apic.c b/hw/i386/kvm/apic.c
index 1e89ca0899..6c1cdb13f6 100644
--- a/hw/i386/kvm/apic.c
+++ b/hw/i386/kvm/apic.c
@@ -16,6 +16,7 @@
 #include "hw/pci/msi.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "kvm/kvm_i386.h"
 
 static inline void kvm_apic_set_reg(struct kvm_lapic_state *kapic,
diff --git a/hw/i386/kvm/i8259.c b/hw/i386/kvm/i8259.c
index 3ca0e1ff03..0119c56a08 100644
--- a/hw/i386/kvm/i8259.c
+++ b/hw/i386/kvm/i8259.c
@@ -17,6 +17,7 @@
 #include "hw/intc/kvm_irqcount.h"
 #include "hw/irq.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "qom/object.h"
 
 #define TYPE_KVM_I8259 "kvm-i8259"
diff --git a/hw/i386/kvm/ioapic.c b/hw/i386/kvm/ioapic.c
index cd5ea5d60b..e5b372315f 100644
--- a/hw/i386/kvm/ioapic.c
+++ b/hw/i386/kvm/ioapic.c
@@ -16,6 +16,7 @@
 #include "hw/intc/ioapic_internal.h"
 #include "hw/intc/kvm_irqcount.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 
 /* PC Utility function */
 void kvm_pc_setup_irq_routing(bool pci_enabled)
diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
index 43f8a8f679..796910c0c4 100644
--- a/hw/i386/kvmvapic.c
+++ b/hw/i386/kvmvapic.c
@@ -15,6 +15,7 @@
 #include "sysemu/cpus.h"
 #include "sysemu/hw_accel.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/runstate.h"
 #include "hw/i386/apic_internal.h"
 #include "hw/sysbus.h"
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 1489abf010..0684c00146 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -58,6 +58,7 @@
 #include "sysemu/tcg.h"
 #include "sysemu/numa.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/xen.h"
 #include "sysemu/reset.h"
 #include "sysemu/runstate.h"
diff --git a/hw/i386/x86-iommu.c b/hw/i386/x86-iommu.c
index 01d11325a6..6531678e6f 100644
--- a/hw/i386/x86-iommu.c
+++ b/hw/i386/x86-iommu.c
@@ -26,6 +26,7 @@
 #include "qemu/error-report.h"
 #include "trace.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 
 void x86_iommu_iec_register_notifier(X86IOMMUState *iommu,
                                      iec_notify_fn fn, void *data)
diff --git a/hw/intc/arm_gic.c b/hw/intc/arm_gic.c
index 7a34bc0998..1fe9b5e7d8 100644
--- a/hw/intc/arm_gic.c
+++ b/hw/intc/arm_gic.c
@@ -28,6 +28,7 @@
 #include "qemu/module.h"
 #include "trace.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/qtest.h"
 
 /* #define DEBUG_GIC */
diff --git a/hw/intc/arm_gic_common.c b/hw/intc/arm_gic_common.c
index 889327a8cf..0247764953 100644
--- a/hw/intc/arm_gic_common.c
+++ b/hw/intc/arm_gic_common.c
@@ -27,6 +27,7 @@
 #include "hw/qdev-properties.h"
 #include "migration/vmstate.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 
 static int gic_pre_save(void *opaque)
 {
diff --git a/hw/intc/arm_gic_kvm.c b/hw/intc/arm_gic_kvm.c
index 1d588946bc..05c0a841b3 100644
--- a/hw/intc/arm_gic_kvm.c
+++ b/hw/intc/arm_gic_kvm.c
@@ -24,6 +24,7 @@
 #include "qemu/module.h"
 #include "migration/blocker.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "kvm_arm.h"
 #include "gic_internal.h"
 #include "vgic_common.h"
diff --git a/hw/intc/arm_gicv3_common.c b/hw/intc/arm_gicv3_common.c
index 2ebf880ead..a31052e16a 100644
--- a/hw/intc/arm_gicv3_common.c
+++ b/hw/intc/arm_gicv3_common.c
@@ -32,6 +32,7 @@
 #include "gicv3_internal.h"
 #include "hw/arm/linux-boot-if.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 
 
 static void gicv3_gicd_no_migration_shift_bug_post_load(GICv3State *cs)
diff --git a/hw/intc/arm_gicv3_its_common.c b/hw/intc/arm_gicv3_its_common.c
index abaf77057e..52b55d37ae 100644
--- a/hw/intc/arm_gicv3_its_common.c
+++ b/hw/intc/arm_gicv3_its_common.c
@@ -25,6 +25,7 @@
 #include "qemu/log.h"
 #include "qemu/module.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 
 static int gicv3_its_pre_save(void *opaque)
 {
diff --git a/hw/intc/arm_gicv3_kvm.c b/hw/intc/arm_gicv3_kvm.c
index 72ad916d3d..754f69ae99 100644
--- a/hw/intc/arm_gicv3_kvm.c
+++ b/hw/intc/arm_gicv3_kvm.c
@@ -25,6 +25,7 @@
 #include "qemu/error-report.h"
 #include "qemu/module.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/runstate.h"
 #include "kvm_arm.h"
 #include "gicv3_internal.h"
diff --git a/hw/intc/ioapic.c b/hw/intc/ioapic.c
index 716ffc8bbb..9e49ae585d 100644
--- a/hw/intc/ioapic.c
+++ b/hw/intc/ioapic.c
@@ -31,6 +31,7 @@
 #include "hw/pci/msi.h"
 #include "hw/qdev-properties.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/sysemu.h"
 #include "hw/i386/apic-msidef.h"
 #include "hw/i386/x86-iommu.h"
diff --git a/hw/intc/openpic_kvm.c b/hw/intc/openpic_kvm.c
index 557dd0c2bf..0373d118f2 100644
--- a/hw/intc/openpic_kvm.c
+++ b/hw/intc/openpic_kvm.c
@@ -31,6 +31,7 @@
 #include "hw/qdev-properties.h"
 #include "hw/sysbus.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "qemu/log.h"
 #include "qemu/module.h"
 #include "qom/object.h"
diff --git a/hw/intc/s390_flic_kvm.c b/hw/intc/s390_flic_kvm.c
index 4e86d2d436..84f3520393 100644
--- a/hw/intc/s390_flic_kvm.c
+++ b/hw/intc/s390_flic_kvm.c
@@ -17,6 +17,7 @@
 #include "qemu/module.h"
 #include "qapi/error.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "hw/s390x/s390_flic.h"
 #include "hw/s390x/adapter.h"
 #include "hw/s390x/css.h"
diff --git a/hw/intc/spapr_xive_kvm.c b/hw/intc/spapr_xive_kvm.c
index 61fe7bd2d3..bb9cdcf1bd 100644
--- a/hw/intc/spapr_xive_kvm.c
+++ b/hw/intc/spapr_xive_kvm.c
@@ -14,6 +14,7 @@
 #include "target/ppc/cpu.h"
 #include "sysemu/cpus.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/runstate.h"
 #include "hw/ppc/spapr.h"
 #include "hw/ppc/spapr_cpu_core.h"
diff --git a/hw/intc/xics.c b/hw/intc/xics.c
index c7f8abd71e..75ca07334a 100644
--- a/hw/intc/xics.c
+++ b/hw/intc/xics.c
@@ -39,6 +39,7 @@
 #include "hw/intc/intc.h"
 #include "hw/irq.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/reset.h"
 
 void icp_pic_print_info(ICPState *icp, Monitor *mon)
diff --git a/hw/intc/xics_kvm.c b/hw/intc/xics_kvm.c
index 9719d98a17..cb4eca437c 100644
--- a/hw/intc/xics_kvm.c
+++ b/hw/intc/xics_kvm.c
@@ -29,6 +29,7 @@
 #include "qapi/error.h"
 #include "trace.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "hw/ppc/spapr.h"
 #include "hw/ppc/spapr_cpu_core.h"
 #include "hw/ppc/xics.h"
diff --git a/hw/misc/ivshmem.c b/hw/misc/ivshmem.c
index d66d912172..8f1dd5f92b 100644
--- a/hw/misc/ivshmem.c
+++ b/hw/misc/ivshmem.c
@@ -27,6 +27,7 @@
 #include "hw/pci/msi.h"
 #include "hw/pci/msix.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "migration/blocker.h"
 #include "migration/vmstate.h"
 #include "qemu/error-report.h"
diff --git a/hw/ppc/e500.c b/hw/ppc/e500.c
index 117c9c08ed..7c59a33bac 100644
--- a/hw/ppc/e500.c
+++ b/hw/ppc/e500.c
@@ -29,6 +29,7 @@
 #include "sysemu/block-backend-io.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/reset.h"
 #include "sysemu/runstate.h"
 #include "kvm_ppc.h"
diff --git a/hw/ppc/spapr_irq.c b/hw/ppc/spapr_irq.c
index a0d1e1298e..7347486f70 100644
--- a/hw/ppc/spapr_irq.c
+++ b/hw/ppc/spapr_irq.c
@@ -20,6 +20,7 @@
 #include "hw/qdev-properties.h"
 #include "cpu-models.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 
 #include "trace.h"
 
diff --git a/hw/remote/proxy.c b/hw/remote/proxy.c
index 1c7786b52c..e5dadd9f50 100644
--- a/hw/remote/proxy.c
+++ b/hw/remote/proxy.c
@@ -22,6 +22,7 @@
 #include "qom/object.h"
 #include "qemu/event_notifier.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "util/event_notifier-posix.c"
 
 static void probe_pci_info(PCIDevice *dev, Error **errp);
diff --git a/hw/s390x/virtio-ccw.c b/hw/s390x/virtio-ccw.c
index e33e5207ab..589b478c24 100644
--- a/hw/s390x/virtio-ccw.c
+++ b/hw/s390x/virtio-ccw.c
@@ -14,6 +14,7 @@
 #include "qapi/error.h"
 #include "exec/address-spaces.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "net/net.h"
 #include "hw/virtio/virtio.h"
 #include "migration/qemu-file-types.h"
diff --git a/hw/vfio/pci.c b/hw/vfio/pci.c
index ec9a854361..22688413c6 100644
--- a/hw/vfio/pci.c
+++ b/hw/vfio/pci.c
@@ -36,6 +36,7 @@
 #include "qemu/range.h"
 #include "qemu/units.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/runstate.h"
 #include "pci.h"
 #include "trace.h"
diff --git a/hw/vfio/platform.c b/hw/vfio/platform.c
index 5af73f9287..0bb291298d 100644
--- a/hw/vfio/platform.c
+++ b/hw/vfio/platform.c
@@ -35,6 +35,7 @@
 #include "hw/platform-bus.h"
 #include "hw/qdev-properties.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 
 /*
  * Functions used whatever the injection method
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index 247325c193..945975b66e 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -34,6 +34,7 @@
 #include "hw/pci/msix.h"
 #include "hw/loader.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "hw/virtio/virtio-pci.h"
 #include "qemu/range.h"
 #include "hw/virtio/virtio-bus.h"
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index f022c644d2..99a9cbde73 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -20,6 +20,7 @@
 #include "qapi/error.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/kvm_int.h"
 #include "kvm_arm.h"
 #include "cpu.h"
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index de531842f6..6582611960 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -28,6 +28,8 @@
 #include "host-cpu.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/hw_accel.h"
+#include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
diff --git a/target/i386/kvm/xen-emu.c b/target/i386/kvm/xen-emu.c
index d7c7eb8d9c..2604cba6b1 100644
--- a/target/i386/kvm/xen-emu.c
+++ b/target/i386/kvm/xen-emu.c
@@ -14,6 +14,8 @@
 #include "qemu/main-loop.h"
 #include "qemu/error-report.h"
 #include "hw/xen/xen.h"
+#include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/kvm_xen.h"
 #include "kvm/kvm_i386.h"
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 859e06f6ad..b486f5af1e 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -26,6 +26,7 @@
 #include "qemu/error-report.h"
 #include "crypto/hash.h"
 #include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sev.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/runstate.h"
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index 3ac7ec9acf..8d7e04afaa 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -27,6 +27,8 @@
 #include "cpu.h"
 #include "s390x-internal.h"
 #include "kvm_s390x.h"
+#include "sysemu/kvm.h"
+#include "sysemu/kvm_irq.h"
 #include "sysemu/kvm_int.h"
 #include "qemu/cutils.h"
 #include "qapi/error.h"
-- 
2.38.1

