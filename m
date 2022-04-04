Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610134F1BA7
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:24:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380783AbiDDVWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379877AbiDDSUD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 14:20:03 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F7453EA8F
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 11:18:06 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234HwHV3002440;
        Mon, 4 Apr 2022 18:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=woDMg3IxYqSBkM+KVbrnZLVkI2PIdAq16zFQYZphh2c=;
 b=OOZNfW1CiLRdKt5lrWYABhrJhP8qYeycHFYr06/Ouq4F+ot98xrky6ZPkZJLT8EuCRXw
 27ZDPd0akgEjtljE4HGPhypJkhAfTqkqcYsv+ML/7AlHE9z3SyugG/3mP/mQp7UKyVO6
 WXferF1780dTBkWE7K3mUbfUmc4BTV6mke3sJozaTAfPzQkA0jrmQ8qlbJOZ7aBovl8r
 PmNhXOeLJRYJ7qaMkSLMLWwFa5K+P1lFeLPnocpLvYtPY6P8+g9hOoQYQ4L+hnkrMnpV
 cm40vgs93YMXriPjCNfS2rmADUlxaeWbw9tl9qL77as1XrNNusI9b6qO0cwpfywuBLUE 9g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yv6d8yq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 18:18:01 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234Hv87e018731;
        Mon, 4 Apr 2022 18:18:01 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yv6d8yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 18:18:01 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234IGu6v029314;
        Mon, 4 Apr 2022 18:18:00 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03dal.us.ibm.com with ESMTP id 3f6e49dpyb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 18:18:00 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234IHxF830933440
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 18:17:59 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FDBBAE05F;
        Mon,  4 Apr 2022 18:17:59 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30BFAAE060;
        Mon,  4 Apr 2022 18:17:56 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 18:17:56 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v5 7/9] s390x/pci: enable adapter event notification for interpreted devices
Date:   Mon,  4 Apr 2022 14:17:24 -0400
Message-Id: <20220404181726.60291-8-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220404181726.60291-1-mjrosato@linux.ibm.com>
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SDg_ZwR6c8sQ-2fQDdvOJr5uLWgFUDXo
X-Proofpoint-GUID: qaIcE1l0hAGjOCu_74-OCk01OyL978ie
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
index 9c02d31250..47918d2ce9 100644
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
@@ -1078,6 +1081,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                 } else {
                     DPRINTF("zPCI interpretation facilities missing.\n");
                     pbdev->interp = false;
+                    pbdev->forwarding_assist = false;
                 }
             }
             pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
@@ -1086,11 +1090,13 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
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
@@ -1240,7 +1246,10 @@ static void s390_pcihost_reset(DeviceState *dev)
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
@@ -1378,7 +1387,10 @@ static void s390_pci_device_reset(DeviceState *dev)
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
@@ -1424,6 +1436,8 @@ static Property s390_pci_device_properties[] = {
     DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
     DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
     DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
+    DEFINE_PROP_BOOL("forwarding_assist", S390PCIBusDevice, forwarding_assist,
+                     true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index c898c8abe9..c3a34da73d 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -1062,6 +1062,32 @@ static void fmb_update(void *opaque)
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
@@ -1116,7 +1142,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
 
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
@@ -1125,7 +1156,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
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
index 8bfce9ef18..cb20b8dcb9 100644
--- a/hw/s390x/s390-pci-kvm.c
+++ b/hw/s390x/s390-pci-kvm.c
@@ -11,11 +11,41 @@
 
 #include "qemu/osdep.h"
 
+#include <linux/kvm.h>
+
 #include "kvm/kvm_s390x.h"
+#include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/s390-pci-kvm.h"
+#include "hw/s390x/s390-pci-inst.h"
 #include "cpu_models.h"
 
 bool s390_pci_kvm_interp_allowed(void)
 {
     return s390_has_feat(S390_FEAT_ZPCI_INTERP) && kvm_s390_get_zpci_op();
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

