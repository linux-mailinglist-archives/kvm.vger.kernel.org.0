Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35B246C609
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:05:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbhLGVIn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:08:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:53770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236698AbhLGVIm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:08:42 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JbfxH027676;
        Tue, 7 Dec 2021 21:05:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nexuBwgoy2xPcNxsjOUbwFloBXHOtLqNc+wBnENH81A=;
 b=c8Z/zP+sjz85BptEKFJIHI6hYhh6n+aLESTM6SFcMlZvTjx3sSQfa0+sCDE6JY1XDuVh
 FTF8RMJsqtdIIrh5eEUX5QIMonehtCfwQmn8rlKvfYiXS/AykpMS2JAkAQallxTyG7TX
 7W+gocqaWYX1pWjhbXuhJm0YmogKEdL+vSGsSTtlDTVAsoMuXRArPap+EAoaBnDauXJY
 rDht6M2CFOt/bDRHYK/TQ6YfMGmYWXmp2cXrQt2a2DEVgwo578ke4juWw6pwNV8lBs7t
 vn4EIai6nqL40FUX+HSJslCZnNxnRXE+hRtIzsBNqzqxoABcS/QAKitzVK7h85VTEK3I YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctdqf9sx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:05:07 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KV4G1007370;
        Tue, 7 Dec 2021 21:05:06 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctdqf9sws-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:05:06 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kvo8S002360;
        Tue, 7 Dec 2021 21:05:05 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01dal.us.ibm.com with ESMTP id 3cqyyc38mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:05:05 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L53TL56820080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:05:03 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B31B9AE062;
        Tue,  7 Dec 2021 21:05:03 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC7CAAE06A;
        Tue,  7 Dec 2021 21:04:59 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:04:59 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 07/12] s390x/pci: enable for load/store intepretation
Date:   Tue,  7 Dec 2021 16:04:20 -0500
Message-Id: <20211207210425.150923-8-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207210425.150923-1-mjrosato@linux.ibm.com>
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sTqQwUxZk5stJhm-LNYK329rOiU-lqD2
X-Proofpoint-ORIG-GUID: nPw2Cu6aLSk2Xo5V3rNIEROkRvwLu2HR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 mlxscore=0 clxscore=1015 impostorscore=0 malwarescore=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the associated vfio feature ioctl to enable interpretation for devices
when requested.  As part of this process, we must use the host function
handle rather than a QEMU-generated one -- this is provided as part of the
ioctl payload.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c          | 69 +++++++++++++++++++++++++++++++-
 hw/s390x/s390-pci-inst.c         | 63 ++++++++++++++++++++++++++++-
 hw/s390x/s390-pci-vfio.c         | 55 +++++++++++++++++++++++++
 include/hw/s390x/s390-pci-bus.h  |  1 +
 include/hw/s390x/s390-pci-vfio.h | 15 +++++++
 5 files changed, 201 insertions(+), 2 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 01b58ebc70..451bd32d92 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -971,12 +971,57 @@ static void s390_pci_update_subordinate(PCIDevice *dev, uint32_t nr)
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
+     * The host device is in an enabled state, but the device must
+     * begin as disabled for the guest so mask off the enable bit
+     * from the passthrough handle.
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
+         * If the relinquised idx is lower than next_idx, use it
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
@@ -1022,12 +1067,33 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         set_pbdev_info(pbdev);
 
         if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
-            pbdev->fh |= FH_SHM_VFIO;
+            /*
+             * By default, interpretation is always requested; if the available
+             * facilities indicate it is not available, fallback to the
+             * intercept model.
+             */
+            if (pbdev->interp && !s390_has_feat(S390_FEAT_ZPCI_INTERP)) {
+                    DPRINTF("zPCI interpretation facilities missing.\n");
+                    pbdev->interp = false;
+                }
+            if (pbdev->interp) {
+                rc = s390_pci_interp_plug(s, pbdev);
+                if (rc) {
+                    error_setg(errp, "zpci interp plug failed: %d", rc);
+                    return;
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
@@ -1360,6 +1426,7 @@ static Property s390_pci_device_properties[] = {
     DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
     DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
     DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
+    DEFINE_PROP_BOOL("interp", S390PCIBusDevice, interp, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 0cef7fbace..ba4017474e 100644
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
index 6f80a47e29..78093aaac7 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -97,6 +97,61 @@ void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt)
     }
 }
 
+int s390_pci_probe_interp(S390PCIBusDevice *pbdev)
+{
+    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+    struct vfio_device_feature feat = {
+        .argsz = sizeof(struct vfio_device_feature),
+        .flags = VFIO_DEVICE_FEATURE_PROBE + VFIO_DEVICE_FEATURE_ZPCI_INTERP
+    };
+
+    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, &feat);
+}
+
+int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable)
+{
+    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+    g_autofree struct vfio_device_feature *feat;
+    struct vfio_device_zpci_interp *data;
+    int size;
+
+    size = sizeof(*feat) + sizeof(*data);
+    feat = g_malloc0(size);
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
+    VFIOPCIDevice *vdev = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+    g_autofree struct vfio_device_feature *feat;
+    struct vfio_device_zpci_interp *data;
+    int size, rc;
+
+    size = sizeof(*feat) + sizeof(*data);
+    feat = g_malloc0(size);
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
index ff708aef50..42533e38f7 100644
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
+int s390_pci_probe_interp(S390PCIBusDevice *pbdev)
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

