Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB11547143B
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 15:27:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhLKO1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 09:27:20 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:15728 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbhLKO1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 09:27:17 -0500
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4JB9503QBGzZmdV;
        Sat, 11 Dec 2021 22:24:20 +0800 (CST)
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 22:27:15 +0800
Received: from DESKTOP-27KDQMV.china.huawei.com (10.174.148.223) by
 dggpeml100016.china.huawei.com (7.185.36.216) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 22:27:14 +0800
From:   "Longpeng(Mike)" <longpeng2@huawei.com>
To:     <pbonzini@redhat.com>, <alex.williamson@redhat.com>,
        <mst@redhat.com>, <mtosatti@redhat.com>
CC:     <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <arei.gonglei@huawei.com>, Longpeng <longpeng2@huawei.com>
Subject: [PATCH 1/2] kvm-irqchip: introduce new API to support route change
Date:   Sat, 11 Dec 2021 22:27:02 +0800
Message-ID: <20211211142703.1941-2-longpeng2@huawei.com>
X-Mailer: git-send-email 2.25.0.windows.1
In-Reply-To: <20211211142703.1941-1-longpeng2@huawei.com>
References: <20211211142703.1941-1-longpeng2@huawei.com>
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

From: Longpeng <longpeng2@huawei.com>

As suggested by Paolo [1], add the new API to support route changes.
We should invoke kvm_irqchip_begin_route_changes() before changing the
routes, increase the KVMRouteChange.changes if the routes are changed,
and commit the changes at last.

[1] https://lists.gnu.org/archive/html/qemu-devel/2021-11/msg02898.html

Signed-off-by: Longpeng <longpeng2@huawei.com>
---
 include/sysemu/kvm.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 7b22aeb6ae..ef143c2da4 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -209,6 +209,11 @@ DECLARE_INSTANCE_CHECKER(KVMState, KVM_STATE,
 extern KVMState *kvm_state;
 typedef struct Notifier Notifier;
 
+typedef struct KVMRouteChange {
+     KVMState *s;
+     int changes;
+} KVMRouteChange;
+
 /* external API */
 
 bool kvm_has_free_slot(MachineState *ms);
@@ -479,6 +484,20 @@ int kvm_irqchip_add_msi_route(KVMState *s, int vector, PCIDevice *dev);
 int kvm_irqchip_update_msi_route(KVMState *s, int virq, MSIMessage msg,
                                  PCIDevice *dev);
 void kvm_irqchip_commit_routes(KVMState *s);
+
+static inline KVMRouteChange kvm_irqchip_begin_route_changes(KVMState *s)
+{
+     return (KVMRouteChange) { .s = s, .changes = 0 };
+}
+
+static inline void kvm_irqchip_commit_route_changes(KVMRouteChange *c)
+{
+     if (c->changes) {
+         kvm_irqchip_commit_routes(c->s);
+         c->changes = 0;
+    }
+}
+
 void kvm_irqchip_release_virq(KVMState *s, int virq);
 
 int kvm_irqchip_add_adapter_route(KVMState *s, AdapterInfo *adapter);
-- 
2.23.0

