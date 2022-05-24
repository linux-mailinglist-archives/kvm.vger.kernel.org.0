Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5277C533144
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238225AbiEXTF2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240803AbiEXTEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:04:45 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02DEC3EA9C
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 12:03:47 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OHj0R4010471;
        Tue, 24 May 2022 19:03:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4qd6KxyJXM7QOBMK7H85FDvjoCWxRNLXIOMlt1kRYEY=;
 b=GSiasTLYGzyaL+L6Fqcv/ukWBRrDkJnzzlt3tsvNsiCugQXGVmwA2tzzhCmPpniRKVik
 9FQLPtXyhT7XcK50BNoQV3MSlCapt0OLfqjtPYZTNMJTJG0+WgaGxKC+58Hb0XVwF5p8
 X+ASHsGG4LsuqOoGUipGusAmrYPoBAz8atmyd+lmscNKKVAqS23a9N4znnBd4iudW7OX
 5IXsgER7nrBEFIAo8yd9Daomro9rS2zXQkkk2qPJeu4AfVRlmuLDaD4DK1lsCzCWDGWE
 6Bv6ORadCWgOYpNn2k9p1ASvQcs8RqEQ/Oy4048Bk1hvLEUmYMv2PfPoW1dixZG/3pRv ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g941phds1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:39 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIm0mH007689;
        Tue, 24 May 2022 19:03:39 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3g941phdrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:39 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OJ2xMd017171;
        Tue, 24 May 2022 19:03:38 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3g93v8gq94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:38 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OJ3aU27012758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 19:03:36 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CFC72124053;
        Tue, 24 May 2022 19:03:36 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B89F12405C;
        Tue, 24 May 2022 19:03:34 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 19:03:33 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v6 6/8] s390x/pci: enable adapter event notification for interpreted devices
Date:   Tue, 24 May 2022 15:03:03 -0400
Message-Id: <20220524190305.140717-7-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524190305.140717-1-mjrosato@linux.ibm.com>
References: <20220524190305.140717-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9i_qEa2lES_GyMRLetJDOKVMS6PODJkk
X-Proofpoint-GUID: IOiU2aO1a0xLIOyi1Iqn4IxjMakCIXsi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the associated kvm ioctl operation to enable adapter event notification
and forwarding for devices when requested.  This feature will be set up
with or without firmware assist based upon the 'forwarding_assist' setting.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c         | 20 ++++++++++++++---
 hw/s390x/s390-pci-inst.c        | 40 +++++++++++++++++++++++++++++++--
 hw/s390x/s390-pci-kvm.c         | 30 +++++++++++++++++++++++++
 include/hw/s390x/s390-pci-bus.h |  1 +
 include/hw/s390x/s390-pci-kvm.h | 14 ++++++++++++
 5 files changed, 100 insertions(+), 5 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 816d17af99..e66a0dfbef 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -190,7 +190,10 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
         rc = SCLP_RC_NO_ACTION_REQUIRED;
         break;
     default:
-        if (pbdev->summary_ind) {
+        if (pbdev->interp && (pbdev->fh & FH_MASK_ENABLE)) {
+            /* Interpreted devices were using interrupt forwarding */
+            s390_pci_kvm_aif_disable(pbdev);
+        } else if (pbdev->summary_ind) {
             pci_dereg_irqs(pbdev);
         }
         if (pbdev->iommu->enabled) {
@@ -1082,6 +1085,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                 } else {
                     DPRINTF("zPCI interpretation facilities missing.\n");
                     pbdev->interp = false;
+                    pbdev->forwarding_assist = false;
                 }
             }
             pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
@@ -1090,11 +1094,13 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
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
@@ -1244,7 +1250,10 @@ static void s390_pcihost_reset(DeviceState *dev)
     /* Process all pending unplug requests */
     QTAILQ_FOREACH_SAFE(pbdev, &s->zpci_devs, link, next) {
         if (pbdev->unplug_requested) {
-            if (pbdev->summary_ind) {
+            if (pbdev->interp && (pbdev->fh & FH_MASK_ENABLE)) {
+                /* Interpreted devices were using interrupt forwarding */
+                s390_pci_kvm_aif_disable(pbdev);
+            } else if (pbdev->summary_ind) {
                 pci_dereg_irqs(pbdev);
             }
             if (pbdev->iommu->enabled) {
@@ -1382,7 +1391,10 @@ static void s390_pci_device_reset(DeviceState *dev)
         break;
     }
 
-    if (pbdev->summary_ind) {
+    if (pbdev->interp && (pbdev->fh & FH_MASK_ENABLE)) {
+        /* Interpreted devices were using interrupt forwarding */
+        s390_pci_kvm_aif_disable(pbdev);
+    } else if (pbdev->summary_ind) {
         pci_dereg_irqs(pbdev);
     }
     if (pbdev->iommu->enabled) {
@@ -1428,6 +1440,8 @@ static Property s390_pci_device_properties[] = {
     DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
     DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
     DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
+    DEFINE_PROP_BOOL("forwarding_assist", S390PCIBusDevice, forwarding_assist,
+                     true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 651ec38635..20a9bcc7af 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -1066,6 +1066,32 @@ static void fmb_update(void *opaque)
     timer_mod(pbdev->fmb_timer, t + pbdev->pci_group->zpci_group.mui);
 }
 
+static int mpcifc_reg_int_interp(S390PCIBusDevice *pbdev, ZpciFib *fib)
+{
+    int rc;
+
+    rc = s390_pci_kvm_aif_enable(pbdev, fib, pbdev->forwarding_assist);
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
+    rc = s390_pci_kvm_aif_disable(pbdev);
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
@@ -1120,7 +1146,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
 
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
@@ -1129,7 +1160,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
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
diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
index e503aaf1ca..69b04a36ea 100644
--- a/hw/s390x/s390-pci-kvm.c
+++ b/hw/s390x/s390-pci-kvm.c
@@ -11,9 +11,13 @@
 
 #include "qemu/osdep.h"
 
+#include <linux/kvm.h>
+
 #include "kvm/kvm_s390x.h"
 #include "hw/s390x/pv.h"
+#include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/s390-pci-kvm.h"
+#include "hw/s390x/s390-pci-inst.h"
 #include "cpu_models.h"
 
 bool s390_pci_kvm_interp_allowed(void)
@@ -21,3 +25,29 @@ bool s390_pci_kvm_interp_allowed(void)
     return (s390_has_feat(S390_FEAT_ZPCI_INTERP) && kvm_s390_get_zpci_op() &&
             !s390_is_pv());
 }
+
+int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, bool assist)
+{
+    struct kvm_s390_zpci_op args = {
+        .fh = pbdev->fh,
+        .op = KVM_S390_ZPCIOP_REG_AEN,
+        .u.reg_aen.ibv = fib->aibv,
+        .u.reg_aen.sb = fib->aisb,
+        .u.reg_aen.noi = FIB_DATA_NOI(fib->data),
+        .u.reg_aen.isc = FIB_DATA_ISC(fib->data),
+        .u.reg_aen.sbo = FIB_DATA_AISBO(fib->data),
+        .u.reg_aen.flags = (assist) ? 0 : KVM_S390_ZPCIOP_REGAEN_HOST
+    };
+
+    return kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
+}
+
+int s390_pci_kvm_aif_disable(S390PCIBusDevice *pbdev)
+{
+    struct kvm_s390_zpci_op args = {
+        .fh = pbdev->fh,
+        .op = KVM_S390_ZPCIOP_DEREG_AEN
+    };
+
+    return kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
+}
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
 
diff --git a/include/hw/s390x/s390-pci-kvm.h b/include/hw/s390x/s390-pci-kvm.h
index 80a2e7d0ca..933814a402 100644
--- a/include/hw/s390x/s390-pci-kvm.h
+++ b/include/hw/s390x/s390-pci-kvm.h
@@ -12,13 +12,27 @@
 #ifndef HW_S390_PCI_KVM_H
 #define HW_S390_PCI_KVM_H
 
+#include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-inst.h"
+
 #ifdef CONFIG_KVM
 bool s390_pci_kvm_interp_allowed(void);
+int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, bool assist);
+int s390_pci_kvm_aif_disable(S390PCIBusDevice *pbdev);
 #else
 static inline bool s390_pci_kvm_interp_allowed(void)
 {
     return false;
 }
+static inline int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib,
+                                          bool assist)
+{
+    return -EINVAL;
+}
+static inline int s390_pci_kvm_aif_disable(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
 #endif
 
 #endif
-- 
2.27.0

