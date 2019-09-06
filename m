Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50144AB40F
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 10:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387580AbfIFIdR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 04:33:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:46198 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732683AbfIFIdR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 04:33:17 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id B1284F9680A2F91B9579;
        Fri,  6 Sep 2019 16:33:15 +0800 (CST)
Received: from HGHY1z004218071.china.huawei.com (10.177.29.32) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.439.0; Fri, 6 Sep 2019 16:33:08 +0800
From:   Xiang Zheng <zhengxiang9@huawei.com>
To:     <pbonzini@redhat.com>, <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>,
        <gengdongjiu@huawei.com>, <mtosatti@redhat.com>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <jonathan.cameron@huawei.com>,
        <xuwei5@huawei.com>, <kvm@vger.kernel.org>,
        <qemu-devel@nongnu.org>, <qemu-arm@nongnu.org>,
        <linuxarm@huawei.com>
CC:     <zhengxiang9@huawei.com>, <wanghaibin.wang@huawei.com>
Subject: [PATCH v18 1/6] hw/arm/virt: Introduce RAS platform version and RAS machine option
Date:   Fri, 6 Sep 2019 16:31:47 +0800
Message-ID: <20190906083152.25716-2-zhengxiang9@huawei.com>
X-Mailer: git-send-email 2.15.1.windows.2
In-Reply-To: <20190906083152.25716-1-zhengxiang9@huawei.com>
References: <20190906083152.25716-1-zhengxiang9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.177.29.32]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dongjiu Geng <gengdongjiu@huawei.com>

Support RAS Virtualization feature since version 4.2, disable it by
default in the old versions. Also add a machine option which allows user
to enable it explicitly.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
---
 hw/arm/virt.c         | 33 +++++++++++++++++++++++++++++++++
 include/hw/arm/virt.h |  2 ++
 2 files changed, 35 insertions(+)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index d74538b021..e0451433c8 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -1783,6 +1783,20 @@ static void virt_set_its(Object *obj, bool value, Error **errp)
     vms->its = value;
 }
 
+static bool virt_get_ras(Object *obj, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    return vms->ras;
+}
+
+static void virt_set_ras(Object *obj, bool value, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    vms->ras = value;
+}
+
 static char *virt_get_gic_version(Object *obj, Error **errp)
 {
     VirtMachineState *vms = VIRT_MACHINE(obj);
@@ -2026,6 +2040,19 @@ static void virt_instance_init(Object *obj)
                                     "Valid values are none and smmuv3",
                                     NULL);
 
+    if (vmc->no_ras) {
+        vms->ras = false;
+    } else {
+        /* Default disallows RAS instantiation */
+        vms->ras = false;
+        object_property_add_bool(obj, "ras", virt_get_ras,
+                                 virt_set_ras, NULL);
+        object_property_set_description(obj, "ras",
+                                        "Set on/off to enable/disable "
+                                        "RAS instantiation",
+                                        NULL);
+    }
+
     vms->irqmap = a15irqmap;
 
     virt_flash_create(vms);
@@ -2058,8 +2085,14 @@ DEFINE_VIRT_MACHINE_AS_LATEST(4, 2)
 
 static void virt_machine_4_1_options(MachineClass *mc)
 {
+    VirtMachineClass *vmc = VIRT_MACHINE_CLASS(OBJECT_CLASS(mc));
+
     virt_machine_4_2_options(mc);
     compat_props_add(mc->compat_props, hw_compat_4_1, hw_compat_4_1_len);
+    /* Disable memory recovery feature for 4.1 as RAS support was
+     * introduced with 4.2.
+     */
+    vmc->no_ras = true;
 }
 DEFINE_VIRT_MACHINE(4, 1)
 
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index a72094204e..04ab42ca42 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -103,6 +103,7 @@ typedef struct {
     bool disallow_affinity_adjustment;
     bool no_its;
     bool no_pmu;
+    bool no_ras;
     bool claim_edge_triggered_timers;
     bool smbios_old_sys_ver;
     bool no_highmem_ecam;
@@ -119,6 +120,7 @@ typedef struct {
     bool highmem_ecam;
     bool its;
     bool virt;
+    bool ras;
     int32_t gic_version;
     VirtIOMMUType iommu;
     struct arm_boot_info bootinfo;
-- 
2.19.1


