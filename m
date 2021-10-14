Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAC0342CFA9
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 02:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229927AbhJNAv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 20:51:28 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14348 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhJNAv1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 20:51:27 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HV9dq3bZ4z908L;
        Thu, 14 Oct 2021 08:44:31 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 08:49:22 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Thu, 14 Oct 2021 08:49:21 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <alex.williamson@redhat.com>, <pbonzini@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <arei.gonglei@huawei.com>, "Longpeng(Mike)" <longpeng2@huawei.com>
Subject: [PATCH v4 4/6] kvm: irqchip: extract kvm_irqchip_add_deferred_msi_route
Date:   Thu, 14 Oct 2021 08:48:50 +0800
Message-ID: <20211014004852.1293-5-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20211014004852.1293-1-longpeng2@huawei.com>
References: <20211014004852.1293-1-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.148.223]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml100016.china.huawei.com (7.185.36.216)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract a common helper that add MSI route for specific vector
but does not commit immediately.

Signed-off-by: Longpeng(Mike) <longpeng2@huawei.com>
---
 accel/kvm/kvm-all.c  | 15 +++++++++++++--
 include/sysemu/kvm.h |  6 ++++++
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index db8d83b..8627f7c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -1953,7 +1953,7 @@ int kvm_irqchip_send_msi(KVMState *s, MSIMessage msg)
     return kvm_set_irq(s, route->kroute.gsi, 1);
 }
 
-int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
+int kvm_irqchip_add_deferred_msi_route(KVMState *s, int vector, PCIDevice *dev)
 {
     struct kvm_irq_routing_entry kroute = {};
     int virq;
@@ -1996,7 +1996,18 @@ int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
 
     kvm_add_routing_entry(s, &kroute);
     kvm_arch_add_msi_route_post(&kroute, vector, dev);
-    kvm_irqchip_commit_routes(s);
+
+    return virq;
+}
+
+int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev)
+{
+    int virq;
+
+    virq = kvm_irqchip_add_deferred_msi_route(s, vector, dev);
+    if (virq >= 0) {
+        kvm_irqchip_commit_routes(s);
+    }
 
     return virq;
 }
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a1ab1ee..8de0d9a 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -476,6 +476,12 @@ void kvm_init_cpu_signals(CPUState *cpu);
  * @return: virq (>=0) when success, errno (<0) when failed.
  */
 int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev);
+/**
+ * Add MSI route for specific vector but does not commit to KVM
+ * immediately
+ */
+int kvm_irqchip_add_deferred_msi_route(KVMState *s, int vector,
+                                       PCIDevice *dev);
 int kvm_irqchip_update_msi_route(KVMState *s, int virq, MSIMessage msg,
                                  PCIDevice *dev);
 void kvm_irqchip_commit_routes(KVMState *s);
-- 
1.8.3.1

