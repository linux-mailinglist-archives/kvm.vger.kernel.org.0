Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70CEB4AA236
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243748AbiBDVT7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:19:59 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41104 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242698AbiBDVTn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:19:43 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214JxVtj006064;
        Fri, 4 Feb 2022 21:19:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kJvO/OcnXKfunlvsM9zpmb1gZ/6V5ZxJlwtymv9jSZ4=;
 b=UtQ0S8R+NgDm4IHsReZ+ptVNxWpepWTqueI+gnkn7NcGmi09XHY49teNcdA7w0ncCXpC
 8rGG589EO82m14k76/DO/Qdo20Sqv/hoHz3DBDSjJDstokUDQGQsNjorvCdECo3qQt36
 kgbBAh2H1SZi8nYsv1SZNy3OcsrICEfpYK0/7jZPMc1JMfnsEwv6VrHx778ETE0HdJ9b
 2r29AEAJKRYF2pmq9QhXdIm7MBHiKToG6jdUrvhwAI03TcHCGLCjVlu1YCu1z3atBD07
 GlMtP6iGjh2zW9b7GcfGXOan8/aVEhJm27cqzyT+4fCSaenWhouWb4UVVWf7UknOCymS Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx4esph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:35 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214L9cEV002157;
        Fri, 4 Feb 2022 21:19:34 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx4esp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:34 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCouM008549;
        Fri, 4 Feb 2022 21:19:33 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02dal.us.ibm.com with ESMTP id 3e0r0pyjex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:33 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LJUqC29557214
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:19:30 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6B051C605F;
        Fri,  4 Feb 2022 21:19:30 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E814DC6055;
        Fri,  4 Feb 2022 21:19:28 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:19:28 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 3/8] s390x/pci: enable for load/store intepretation
Date:   Fri,  4 Feb 2022 16:19:13 -0500
Message-Id: <20220204211918.321924-4-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211918.321924-1-mjrosato@linux.ibm.com>
References: <20220204211918.321924-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: v1i3EAAgch0lG0Az5Y327to4XpmTeWQU
X-Proofpoint-ORIG-GUID: -O3GVuFKOfu6tJfey4_YFhVb0-wWxUc0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 bulkscore=0 phishscore=0 spamscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 suspectscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the associated vfio feature ioctl to enable interpretation for devices
when requested.  As part of this process, we must use the host function
handle rather than a QEMU-generated one -- this is provided as part of the
ioctl payload.
By default, unless interpret=off is specified, interpretation support will
always be assumed and exploited if the necessary ioctls and CPU features are
available on the host kernel.  When these are unavailable, we will silently
revert to the interception model; this allows existing guest configurations
to work unmodified on hosts with and without zPCI interpretation support,
allowing QEMU to choose the best support model available.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c          | 72 +++++++++++++++++++++++++++++++-
 hw/s390x/s390-pci-inst.c         | 63 +++++++++++++++++++++++++++-
 hw/s390x/s390-pci-vfio.c         | 52 +++++++++++++++++++++++
 include/hw/s390x/s390-pci-bus.h  |  1 +
 include/hw/s390x/s390-pci-vfio.h | 15 +++++++
 5 files changed, 201 insertions(+), 2 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 01b58ebc70..4f89df18cd 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -971,12 +971,58 @@ static void s390_pci_update_subordinate(PCIDevice *dev, uint32_t nr)
     }
 }
 
+static int s390_pci_interp_plug(S390pciState *s, S390PCIBusDevice *pbdev)
+{
+    uint32_t idx;
+    int rc;
+
+    rc = s390_pci_probe_interp(pbdev);
+    if (rc) {
+        return rc;
+    }
+
+    rc = s390_pci_update_passthrough_fh(pbdev);
+    if (rc) {
+        return rc;
+    }
+
+    /*
+     * The host device is already in an enabled state, but we always present
+     * the initial device state to the guest as disabled (ZPCI_FS_DISABLED).
+     * Therefore, mask off the enable bit from the passthrough handle until
+     * the guest issues a CLP SET PCI FN later to enable the device.
+     */
+    pbdev->fh &= ~FH_MASK_ENABLE;
+
+    /* Next, see if the idx is already in-use */
+    idx = pbdev->fh & FH_MASK_INDEX;
+    if (pbdev->idx != idx) {
+        if (s390_pci_find_dev_by_idx(s, idx)) {
+            return -EINVAL;
+        }
+        /*
+         * Update the idx entry with the passed through idx
+         * If the relinquished idx is lower than next_idx, use it
+         * to replace next_idx
+         */
+        g_hash_table_remove(s->zpci_table, &pbdev->idx);
+        if (idx < s->next_idx) {
+            s->next_idx = idx;
+        }
+        pbdev->idx = idx;
+        g_hash_table_insert(s->zpci_table, &pbdev->idx, pbdev);
+    }
+
+    return 0;
+}
+
 static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                               Error **errp)
 {
     S390pciState *s = S390_PCI_HOST_BRIDGE(hotplug_dev);
     PCIDevice *pdev = NULL;
     S390PCIBusDevice *pbdev = NULL;
+    int rc;
 
     if (object_dynamic_cast(OBJECT(dev), TYPE_PCI_BRIDGE)) {
         PCIBridge *pb = PCI_BRIDGE(dev);
@@ -1022,12 +1068,35 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         set_pbdev_info(pbdev);
 
         if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
-            pbdev->fh |= FH_SHM_VFIO;
+            /*
+             * By default, interpretation is always requested; if the available
+             * facilities indicate it is not available, fallback to the
+             * interception model.
+             */
+            if (pbdev->interp) {
+                if (s390_has_feat(S390_FEAT_ZPCI_INTERP)) {
+                    rc = s390_pci_interp_plug(s, pbdev);
+                    if (rc) {
+                        error_setg(errp, "Plug failed for zPCI device in "
+                                   "interpretation mode: %d", rc);
+                        return;
+                    }
+                } else {
+                    DPRINTF("zPCI interpretation facilities missing.\n");
+                    pbdev->interp = false;
+                }
+            }
             pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
             /* Fill in CLP information passed via the vfio region */
             s390_pci_get_clp_info(pbdev);
+            if (!pbdev->interp) {
+                /* Do vfio passthrough but intercept for I/O */
+                pbdev->fh |= FH_SHM_VFIO;
+            }
         } else {
             pbdev->fh |= FH_SHM_EMUL;
+            /* Always intercept emulated devices */
+            pbdev->interp = false;
         }
 
         if (s390_pci_msix_init(pbdev)) {
@@ -1360,6 +1429,7 @@ static Property s390_pci_device_properties[] = {
     DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
     DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
     DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
+    DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 6d400d4147..e9a0dc12e4 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -18,6 +18,7 @@
 #include "sysemu/hw_accel.h"
 #include "hw/s390x/s390-pci-inst.h"
 #include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-vfio.h"
 #include "hw/s390x/tod.h"
 
 #ifndef DEBUG_S390PCI_INST
@@ -156,6 +157,47 @@ out:
     return rc;
 }
 
+static int clp_enable_interp(S390PCIBusDevice *pbdev)
+{
+    int rc;
+
+    rc = s390_pci_set_interp(pbdev, true);
+    if (rc) {
+        DPRINTF("Failed to enable interpretation\n");
+        return rc;
+    }
+    rc = s390_pci_update_passthrough_fh(pbdev);
+    if (rc) {
+        DPRINTF("Failed to update passthrough fh\n");
+        return rc;
+    }
+    if (!(pbdev->fh & FH_MASK_ENABLE)) {
+        DPRINTF("Passthrough handle is not enabled\n");
+        return -EINVAL;
+    }
+
+    return 0;
+}
+
+static int clp_disable_interp(S390PCIBusDevice *pbdev)
+{
+    int rc;
+
+    rc = s390_pci_set_interp(pbdev, false);
+    if (rc) {
+        DPRINTF("Failed to disable interpretation\n");
+        return rc;
+    }
+
+    rc = s390_pci_update_passthrough_fh(pbdev);
+    if (rc) {
+        DPRINTF("Failed to update passthrough fh\n");
+        return rc;
+    }
+
+    return 0;
+}
+
 int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
 {
     ClpReqHdr *reqh;
@@ -246,7 +288,19 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
                 goto out;
             }
 
-            pbdev->fh |= FH_MASK_ENABLE;
+            /*
+             * If interpretation is specified, attempt to enable this now and
+             * update with the host fh
+             */
+            if (pbdev->interp) {
+                if (clp_enable_interp(pbdev)) {
+                    stw_p(&ressetpci->hdr.rsp, CLP_RC_SETPCIFN_ERR);
+                    goto out;
+                }
+            } else {
+                pbdev->fh |= FH_MASK_ENABLE;
+            }
+
             pbdev->state = ZPCI_FS_ENABLED;
             stl_p(&ressetpci->fh, pbdev->fh);
             stw_p(&ressetpci->hdr.rsp, CLP_RC_OK);
@@ -257,6 +311,13 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
                 goto out;
             }
             device_legacy_reset(DEVICE(pbdev));
+            if (pbdev->interp) {
+                if (clp_disable_interp(pbdev)) {
+                    stw_p(&ressetpci->hdr.rsp, CLP_RC_SETPCIFN_ERR);
+                    goto out;
+                }
+            }
+            /* Mask off the enabled bit for interpreted devices too */
             pbdev->fh &= ~FH_MASK_ENABLE;
             pbdev->state = ZPCI_FS_DISABLED;
             stl_p(&ressetpci->fh, pbdev->fh);
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
index 6f80a47e29..2cab3a9e89 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -97,6 +97,58 @@ void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt)
     }
 }
 
+int s390_pci_probe_interp(S390PCIBusDevice *pbdev)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
+    struct vfio_device_feature feat = {
+        .argsz = sizeof(struct vfio_device_feature),
+        .flags = VFIO_DEVICE_FEATURE_PROBE | VFIO_DEVICE_FEATURE_ZPCI_INTERP
+    };
+
+    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, &feat);
+}
+
+int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
+    struct vfio_device_zpci_interp *data;
+    int size = sizeof(struct vfio_device_feature) + sizeof(*data);
+    g_autofree struct vfio_device_feature *feat = g_malloc0(size);
+
+    feat->argsz = size;
+    feat->flags = VFIO_DEVICE_FEATURE_SET + VFIO_DEVICE_FEATURE_ZPCI_INTERP;
+
+    data = (struct vfio_device_zpci_interp *)&feat->data;
+    if (enable) {
+        data->flags = VFIO_DEVICE_ZPCI_FLAG_INTERP;
+    } else {
+        data->flags = 0;
+    }
+
+    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
+}
+
+int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
+    struct vfio_device_zpci_interp *data;
+    int size = sizeof(struct vfio_device_feature) + sizeof(*data);
+    g_autofree struct vfio_device_feature *feat = g_malloc0(size);
+    int rc;
+
+    feat->argsz = size;
+    feat->flags = VFIO_DEVICE_FEATURE_GET + VFIO_DEVICE_FEATURE_ZPCI_INTERP;
+
+    rc = ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
+    if (rc) {
+        return rc;
+    }
+
+    data = (struct vfio_device_zpci_interp *)&feat->data;
+    pbdev->fh = data->fh;
+    return 0;
+}
+
 static void s390_pci_read_base(S390PCIBusDevice *pbdev,
                                struct vfio_device_info *info)
 {
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index da3cde2bb4..a9843dfe97 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -350,6 +350,7 @@ struct S390PCIBusDevice {
     IndAddr *indicator;
     bool pci_unplug_request_processed;
     bool unplug_requested;
+    bool interp;
     QTAILQ_ENTRY(S390PCIBusDevice) link;
 };
 
diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
index ff708aef50..33e82ea370 100644
--- a/include/hw/s390x/s390-pci-vfio.h
+++ b/include/hw/s390x/s390-pci-vfio.h
@@ -20,6 +20,9 @@ bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
 S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
                                           S390PCIBusDevice *pbdev);
 void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt);
+int s390_pci_probe_interp(S390PCIBusDevice *pbdev);
+int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable);
+int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev);
 void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
 #else
 static inline bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
@@ -33,6 +36,18 @@ static inline S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
 }
 static inline void s390_pci_end_dma_count(S390pciState *s,
                                           S390PCIDMACount *cnt) { }
+static inline int s390_pci_probe_interp(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
+static inline int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable)
+{
+    return -EINVAL;
+}
+static inline int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
 static inline void s390_pci_get_clp_info(S390PCIBusDevice *pbdev) { }
 #endif
 
-- 
2.27.0

