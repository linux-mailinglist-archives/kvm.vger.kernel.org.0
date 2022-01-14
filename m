Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B4848F193
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244317AbiANUjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:39:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:62068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S240457AbiANUjL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:39:11 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EK0xgp021764;
        Fri, 14 Jan 2022 20:39:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oZo9oprVkEgtyKGnabLYz+6/nXxzMuGXYwZpbxvYdw0=;
 b=hvK9bASK1jMOsDVmliSoXnuit8Qffte6twB4ZOYXsJMxgqrYI2mF/J3pzz32S9+qQK4M
 8vCTwwCnXkaDvwO2z6eN8DZq0DNLsL2JljmiV6o1eivCyfVPdQ2T7rJil/0Os72tQvxI
 Dp1gRnAxlVGMOc+u2sfOOmX7Xqa6wmoWBPPpfPinRXBtt7uf7E59xiN6gBHTbDaDffyI
 dDG7+AbvJRe0rmv/jn9mKtoQFWuyKh176qYxOJcCdP+UoUhbOdUYJb/r7K1lRxl/wzNL
 hV/o/MDIPCp++GXSFUNWWQMBY96mFr+rNJAaV3jMt9cLLB8kKAEqlol/Kss2GbEHAc8C bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dkfue8my8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:39:07 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EK2AXh029013;
        Fri, 14 Jan 2022 20:39:06 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dkfue8my0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:39:06 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMVTI032707;
        Fri, 14 Jan 2022 20:39:05 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 3df28de37d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:39:05 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKd30q17498580
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:39:03 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9EC84C6066;
        Fri, 14 Jan 2022 20:39:03 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B17AC6063;
        Fri, 14 Jan 2022 20:39:02 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:39:02 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 6/9] s390x/pci: enable adapter event notification for interpreted devices
Date:   Fri, 14 Jan 2022 15:38:46 -0500
Message-Id: <20220114203849.243657-7-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203849.243657-1-mjrosato@linux.ibm.com>
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RoUztUunjOr7hcsflCuJFoFsgqjXNobu
X-Proofpoint-GUID: ChlX25OuBTc6HPUv4EhsFigcuH06ylf1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the associated vfio feature ioctl to enable adapter event notification
and forwarding for devices when requested.  This feature will be set up
with or without firmware assist based upon the 'intassist' setting.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c          | 24 ++++++++--
 hw/s390x/s390-pci-inst.c         | 54 +++++++++++++++++++++-
 hw/s390x/s390-pci-vfio.c         | 79 ++++++++++++++++++++++++++++++++
 include/hw/s390x/s390-pci-bus.h  |  1 +
 include/hw/s390x/s390-pci-vfio.h | 20 ++++++++
 5 files changed, 173 insertions(+), 5 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 66649af6e0..6ee70446ca 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -189,7 +189,10 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
         rc = SCLP_RC_NO_ACTION_REQUIRED;
         break;
     default:
-        if (pbdev->summary_ind) {
+        if (pbdev->interp) {
+            /* Interpreted devices were using interrupt forwarding */
+            s390_pci_set_aif(pbdev, NULL, false, pbdev->intassist);
+        } else if (pbdev->summary_ind) {
             pci_dereg_irqs(pbdev);
         }
         if (pbdev->iommu->enabled) {
@@ -981,6 +984,11 @@ static int s390_pci_interp_plug(S390pciState *s, S390PCIBusDevice *pbdev)
         return rc;
     }
 
+    rc = s390_pci_probe_aif(pbdev);
+    if (rc) {
+        return rc;
+    }
+
     rc = s390_pci_update_passthrough_fh(pbdev);
     if (rc) {
         return rc;
@@ -1076,6 +1084,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
             if (pbdev->interp && !s390_has_feat(S390_FEAT_ZPCI_INTERP)) {
                     DPRINTF("zPCI interpretation facilities missing.\n");
                     pbdev->interp = false;
+                    pbdev->intassist = false;
                 }
             if (pbdev->interp) {
                 rc = s390_pci_interp_plug(s, pbdev);
@@ -1090,11 +1099,13 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
             if (!pbdev->interp) {
                 /* Do vfio passthrough but intercept for I/O */
                 pbdev->fh |= FH_SHM_VFIO;
+                pbdev->intassist = false;
             }
         } else {
             pbdev->fh |= FH_SHM_EMUL;
             /* Always intercept emulated devices */
             pbdev->interp = false;
+            pbdev->intassist = false;
         }
 
         if (s390_pci_msix_init(pbdev) && !pbdev->interp) {
@@ -1244,7 +1255,10 @@ static void s390_pcihost_reset(DeviceState *dev)
     /* Process all pending unplug requests */
     QTAILQ_FOREACH_SAFE(pbdev, &s->zpci_devs, link, next) {
         if (pbdev->unplug_requested) {
-            if (pbdev->summary_ind) {
+            if (pbdev->interp) {
+                /* Interpreted devices were using interrupt forwarding */
+                s390_pci_set_aif(pbdev, NULL, false, pbdev->intassist);
+            } else if (pbdev->summary_ind) {
                 pci_dereg_irqs(pbdev);
             }
             if (pbdev->iommu->enabled) {
@@ -1382,7 +1396,10 @@ static void s390_pci_device_reset(DeviceState *dev)
         break;
     }
 
-    if (pbdev->summary_ind) {
+    if (pbdev->interp) {
+        /* Interpreted devices were using interrupt forwarding */
+        s390_pci_set_aif(pbdev, NULL, false, pbdev->intassist);
+    } else if (pbdev->summary_ind) {
         pci_dereg_irqs(pbdev);
     }
     if (pbdev->iommu->enabled) {
@@ -1428,6 +1445,7 @@ static Property s390_pci_device_properties[] = {
     DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
     DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
     DEFINE_PROP_BOOL("interp", S390PCIBusDevice, interp, true),
+    DEFINE_PROP_BOOL("intassist", S390PCIBusDevice, intassist, true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index e9a0dc12e4..121e07cc41 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -1111,6 +1111,46 @@ static void fmb_update(void *opaque)
     timer_mod(pbdev->fmb_timer, t + pbdev->pci_group->zpci_group.mui);
 }
 
+static int mpcifc_reg_int_interp(S390PCIBusDevice *pbdev, ZpciFib *fib)
+{
+    int rc;
+
+    /* Interpreted devices must also use interrupt forwarding */
+    rc = s390_pci_get_aif(pbdev, false, pbdev->intassist);
+    if (rc) {
+        DPRINTF("Bad interrupt forwarding state\n");
+        return rc;
+    }
+
+    rc = s390_pci_set_aif(pbdev, fib, true, pbdev->intassist);
+    if (rc) {
+        DPRINTF("Failed to enable interrupt forwarding\n");
+        return rc;
+    }
+
+    return 0;
+}
+
+static int mpcifc_dereg_int_interp(S390PCIBusDevice *pbdev, ZpciFib *fib)
+{
+    int rc;
+
+    /* Interpreted devices were using interrupt forwarding */
+    rc = s390_pci_get_aif(pbdev, true, pbdev->intassist);
+    if (rc) {
+        DPRINTF("Bad interrupt forwarding state\n");
+        return rc;
+    }
+
+    rc = s390_pci_set_aif(pbdev, fib, false, pbdev->intassist);
+    if (rc) {
+        DPRINTF("Failed to disable interrupt forwarding\n");
+        return rc;
+    }
+
+    return 0;
+}
+
 int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
                         uintptr_t ra)
 {
@@ -1165,7 +1205,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
 
     switch (oc) {
     case ZPCI_MOD_FC_REG_INT:
-        if (pbdev->summary_ind) {
+        if (pbdev->interp) {
+            if (mpcifc_reg_int_interp(pbdev, &fib)) {
+                cc = ZPCI_PCI_LS_ERR;
+                s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
+            }
+        } else if (pbdev->summary_ind) {
             cc = ZPCI_PCI_LS_ERR;
             s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
         } else if (reg_irqs(env, pbdev, fib)) {
@@ -1174,7 +1219,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
         }
         break;
     case ZPCI_MOD_FC_DEREG_INT:
-        if (!pbdev->summary_ind) {
+        if (pbdev->interp) {
+            if (mpcifc_dereg_int_interp(pbdev, &fib)) {
+                cc = ZPCI_PCI_LS_ERR;
+                s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
+            }
+        } else if (!pbdev->summary_ind) {
             cc = ZPCI_PCI_LS_ERR;
             s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
         } else {
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
index 2cab3a9e89..73f3b3ed19 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -149,6 +149,85 @@ int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
     return 0;
 }
 
+int s390_pci_probe_aif(S390PCIBusDevice *pbdev)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
+    struct vfio_device_feature feat = {
+        .argsz = sizeof(struct vfio_device_feature),
+        .flags = VFIO_DEVICE_FEATURE_PROBE + VFIO_DEVICE_FEATURE_ZPCI_AIF
+    };
+
+    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, &feat);
+}
+
+int s390_pci_set_aif(S390PCIBusDevice *pbdev, ZpciFib *fib, bool enable,
+                     bool assist)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
+    struct vfio_device_zpci_aif *data;
+    int size = sizeof(struct vfio_device_feature) + sizeof(*data);
+    g_autofree struct vfio_device_feature *feat = g_malloc0(size);
+
+    feat->argsz = size;
+    feat->flags = VFIO_DEVICE_FEATURE_SET + VFIO_DEVICE_FEATURE_ZPCI_AIF;
+
+    data = (struct vfio_device_zpci_aif *)&feat->data;
+    if (enable) {
+        data->flags = VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT;
+        if (!pbdev->intassist) {
+            data->flags |= VFIO_DEVICE_ZPCI_FLAG_AIF_HOST;
+        }
+        /* Fill in the guest fib info */
+        data->ibv = fib->aibv;
+        data->sb = fib->aisb;
+        data->noi = FIB_DATA_NOI(fib->data);
+        data->isc = FIB_DATA_ISC(fib->data);
+        data->sbo = FIB_DATA_AISBO(fib->data);
+    } else {
+        data->flags = 0;
+    }
+
+    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
+}
+
+int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enable, bool assist)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
+    struct vfio_device_zpci_aif *data;
+    int size = sizeof(struct vfio_device_feature) + sizeof(*data);
+    g_autofree struct vfio_device_feature *feat = g_malloc0(size);
+    int rc;
+
+    feat->argsz = size;
+    feat->flags = VFIO_DEVICE_FEATURE_GET + VFIO_DEVICE_FEATURE_ZPCI_AIF;
+
+    rc = ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
+    if (rc) {
+        return rc;
+    }
+
+    /* Determine if current interrupt settings match the host */
+    data = (struct vfio_device_zpci_aif *)&feat->data;
+    if (enable && (!(data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT))) {
+        rc = -EINVAL;
+    } else if (!enable && (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT)) {
+        rc = -EINVAL;
+    }
+
+    /*
+     * When enabled for interrupts, the assist and forced host-delivery are
+     * mututally exclusive
+     */
+    if (enable && assist && (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_HOST)) {
+        rc = -EINVAL;
+    } else if (enable && (!assist) && (!(data->flags &
+                                         VFIO_DEVICE_ZPCI_FLAG_AIF_HOST))) {
+        rc = -EINVAL;
+    }
+
+    return rc;
+}
+
 static void s390_pci_read_base(S390PCIBusDevice *pbdev,
                                struct vfio_device_info *info)
 {
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index a9843dfe97..9941ca0084 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -351,6 +351,7 @@ struct S390PCIBusDevice {
     bool pci_unplug_request_processed;
     bool unplug_requested;
     bool interp;
+    bool intassist;
     QTAILQ_ENTRY(S390PCIBusDevice) link;
 };
 
diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
index 42533e38f7..6cec38a863 100644
--- a/include/hw/s390x/s390-pci-vfio.h
+++ b/include/hw/s390x/s390-pci-vfio.h
@@ -13,6 +13,7 @@
 #define HW_S390_PCI_VFIO_H
 
 #include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-inst.h"
 #include CONFIG_DEVICES
 
 #ifdef CONFIG_VFIO
@@ -23,6 +24,11 @@ void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt);
 int s390_pci_probe_interp(S390PCIBusDevice *pbdev);
 int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable);
 int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev);
+int s390_pci_probe_aif(S390PCIBusDevice *pbdev);
+int s390_pci_set_aif(S390PCIBusDevice *pbdev, ZpciFib *fib, bool enable,
+                     bool assist);
+int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enable, bool assist);
+
 void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
 #else
 static inline bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
@@ -48,6 +54,20 @@ static inline int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
 {
     return -EINVAL;
 }
+static inline int s390_pci_probe_aif(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
+static inline int s390_pci_set_aif(S390PCIBusDevice *pbdev, ZpciFib *fib,
+                                   bool enable, bool assist)
+{
+    return -EINVAL;
+}
+static inline int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enable,
+                                   bool assist)
+{
+    return -EINVAL;
+}
 static inline void s390_pci_get_clp_info(S390PCIBusDevice *pbdev) { }
 #endif
 
-- 
2.27.0

