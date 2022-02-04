Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEF9C4AA237
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241543AbiBDVUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:20:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:43438 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243700AbiBDVTo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:19:44 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214KdQvJ026460;
        Fri, 4 Feb 2022 21:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=PZuR/0lw/rZ8p3JNPYb66hH/4vbE6qtRpGb59wWb7lU=;
 b=l7KtovUlUoDlvOXoJwPNNbKW8ystB0ai5IKTIIDbLnBBnszBWQnUIgArdHBvVTRQ6ATE
 gpLL2YqCfcDuJnYE+5hErb1shwRiJfM57Gu06A+2m7KgNvwm0H4iGuGHIennze1KVgWd
 3cY46d/qCnQa0yBP5pCNtMR9YZqMvFSVwepSbceUUXXjPvhKQSlKA5YZN6mxJgFmjueN
 TYj5UXUrO+zwmz1jhql2JjJ3QsbWIgLsuvZktXQw75exqxlf6uPOPXfO7y47Z6cAGc+K
 dG2CZQWNG3AdnwiV8RJvE0WGPL6zrjlN23DP9cCPhtfi7NEzNKri5Lwmb5oEDTQi3WT+ YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0w6tstvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:39 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LEix1029259;
        Fri, 4 Feb 2022 21:19:38 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0w6tstv6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:38 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCaEc022102;
        Fri, 4 Feb 2022 21:19:37 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02wdc.us.ibm.com with ESMTP id 3e0r0kaxqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:37 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LJXT634013478
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:19:33 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7E196C6063;
        Fri,  4 Feb 2022 21:19:33 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 22500C6057;
        Fri,  4 Feb 2022 21:19:32 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:19:32 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 5/8] s390x/pci: enable adapter event notification for interpreted devices
Date:   Fri,  4 Feb 2022 16:19:15 -0500
Message-Id: <20220204211918.321924-6-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211918.321924-1-mjrosato@linux.ibm.com>
References: <20220204211918.321924-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1NTdEJyAjUPt3jC8kdYhTFrh7H_MytNB
X-Proofpoint-ORIG-GUID: oxub0iHrH0viVdnYXNhHuuMFJfDOY0yd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 mlxlogscore=999 lowpriorityscore=0 mlxscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 spamscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the associated vfio feature ioctl to enable adapter event notification
and forwarding for devices when requested.  This feature will be set up
with or without firmware assist based upon the 'forwarding_assist' setting.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c          | 25 ++++++++--
 hw/s390x/s390-pci-inst.c         | 54 ++++++++++++++++++++-
 hw/s390x/s390-pci-vfio.c         | 81 ++++++++++++++++++++++++++++++++
 include/hw/s390x/s390-pci-bus.h  |  1 +
 include/hw/s390x/s390-pci-vfio.h | 21 +++++++++
 5 files changed, 177 insertions(+), 5 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 316b969b5c..e15c104175 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -189,7 +189,10 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
         rc = SCLP_RC_NO_ACTION_REQUIRED;
         break;
     default:
-        if (pbdev->summary_ind) {
+        if (pbdev->interp) {
+            /* Interpreted devices were using interrupt forwarding */
+            s390_pci_set_aif(pbdev, NULL, false, pbdev->forwarding_assist);
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
@@ -1084,6 +1092,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                 } else {
                     DPRINTF("zPCI interpretation facilities missing.\n");
                     pbdev->interp = false;
+                    pbdev->forwarding_assist = false;
                 }
             }
             pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
@@ -1092,11 +1101,13 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
             if (!pbdev->interp) {
                 /* Do vfio passthrough but intercept for I/O */
                 pbdev->fh |= FH_SHM_VFIO;
+                pbdev->forwarding_assist = false;
             }
         } else {
             pbdev->fh |= FH_SHM_EMUL;
             /* Always intercept emulated devices */
             pbdev->interp = false;
+            pbdev->forwarding_assist = false;
         }
 
         if (s390_pci_msix_init(pbdev) && !pbdev->interp) {
@@ -1246,7 +1257,10 @@ static void s390_pcihost_reset(DeviceState *dev)
     /* Process all pending unplug requests */
     QTAILQ_FOREACH_SAFE(pbdev, &s->zpci_devs, link, next) {
         if (pbdev->unplug_requested) {
-            if (pbdev->summary_ind) {
+            if (pbdev->interp) {
+                /* Interpreted devices were using interrupt forwarding */
+                s390_pci_set_aif(pbdev, NULL, false, pbdev->forwarding_assist);
+            } else if (pbdev->summary_ind) {
                 pci_dereg_irqs(pbdev);
             }
             if (pbdev->iommu->enabled) {
@@ -1384,7 +1398,10 @@ static void s390_pci_device_reset(DeviceState *dev)
         break;
     }
 
-    if (pbdev->summary_ind) {
+    if (pbdev->interp) {
+        /* Interpreted devices were using interrupt forwarding */
+        s390_pci_set_aif(pbdev, NULL, false, pbdev->forwarding_assist);
+    } else if (pbdev->summary_ind) {
         pci_dereg_irqs(pbdev);
     }
     if (pbdev->iommu->enabled) {
@@ -1430,6 +1447,8 @@ static Property s390_pci_device_properties[] = {
     DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
     DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
     DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
+    DEFINE_PROP_BOOL("forwarding_assist", S390PCIBusDevice, forwarding_assist,
+                     true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index e9a0dc12e4..dae2012646 100644
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
+    rc = s390_pci_get_aif(pbdev, false, pbdev->forwarding_assist);
+    if (rc) {
+        DPRINTF("Bad interrupt forwarding state\n");
+        return rc;
+    }
+
+    rc = s390_pci_set_aif(pbdev, fib, true, pbdev->forwarding_assist);
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
+    rc = s390_pci_get_aif(pbdev, true, pbdev->forwarding_assist);
+    if (rc) {
+        DPRINTF("Bad interrupt forwarding state\n");
+        return rc;
+    }
+
+    rc = s390_pci_set_aif(pbdev, fib, false, pbdev->forwarding_assist);
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
index 2cab3a9e89..381cbb437a 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -149,6 +149,87 @@ int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
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
+        if (!pbdev->forwarding_assist) {
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
+int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enabled,
+                     bool forwarding_assist)
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
+    /* Ensure that both kernel and QEMU agree on whether AIF is enabled */
+    data = (struct vfio_device_zpci_aif *)&feat->data;
+    if (enabled && (!(data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT))) {
+        rc = -EINVAL;
+    } else if (!enabled && (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT)) {
+        rc = -EINVAL;
+    }
+
+    /*
+     * If AIF is enabled, ensure that kernel and QEMU agree on whether host
+     * delivery is being forced
+     */
+    if (enabled && forwarding_assist &&
+        (data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_HOST)) {
+        rc = -EINVAL;
+    } else if (enabled && (!forwarding_assist) &&
+               (!(data->flags & VFIO_DEVICE_ZPCI_FLAG_AIF_HOST))) {
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
index a9843dfe97..5b09f0cf2f 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -351,6 +351,7 @@ struct S390PCIBusDevice {
     bool pci_unplug_request_processed;
     bool unplug_requested;
     bool interp;
+    bool forwarding_assist;
     QTAILQ_ENTRY(S390PCIBusDevice) link;
 };
 
diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
index 33e82ea370..7096d4a0b0 100644
--- a/include/hw/s390x/s390-pci-vfio.h
+++ b/include/hw/s390x/s390-pci-vfio.h
@@ -13,6 +13,7 @@
 #define HW_S390_PCI_VFIO_H
 
 #include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-inst.h"
 #include CONFIG_DEVICES
 
 #ifdef CONFIG_VFIO
@@ -23,6 +24,12 @@ void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt);
 int s390_pci_probe_interp(S390PCIBusDevice *pbdev);
 int s390_pci_set_interp(S390PCIBusDevice *pbdev, bool enable);
 int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev);
+int s390_pci_probe_aif(S390PCIBusDevice *pbdev);
+int s390_pci_set_aif(S390PCIBusDevice *pbdev, ZpciFib *fib, bool enable,
+                     bool assist);
+int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enabled,
+                     bool forwarding_assist);
+
 void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
 #else
 static inline bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
@@ -48,6 +55,20 @@ static inline int s390_pci_update_passthrough_fh(S390PCIBusDevice *pbdev)
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
+static inline int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enabled,
+                                   bool forwarding_assist)
+{
+    return -EINVAL;
+}
 static inline void s390_pci_get_clp_info(S390PCIBusDevice *pbdev) { }
 #endif
 
-- 
2.27.0

