Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0E7B4D8D5C
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244699AbiCNTwc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244690AbiCNTwR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:52:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B303ED0D
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:50:46 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlVuE009185;
        Mon, 14 Mar 2022 19:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0Vfelxcx5BY4MlQ6QOML3av4XFGN5L+cn8E61h1TWiA=;
 b=hCAbJMAcXbXwHCG38lXAQJCIGuZUwEkpK8nq13ksllfLaPw/c8ihdcBfigkdSWMSxNRP
 coH+ES2kwZjJB5WKO/uNR+NRLmJuUHOSn2BjE2YmNudMvvmwr2Bf8XI6bZ2qIdnPUkDT
 MdjTbjJ0kWaBJA62kIUnPPRzNqf6sf0SsQ0tuHRnK936fNdc/e4Qn9+8NABFXXlxulh9
 NtTjgIiUS7BqulG3pMCg8B6KT571p1GD0iUG51iiR6/J+FaAvOKTVVf0m7ZeDMz8m3po
 SV4LOG4xjK7XxzBcL5HOLXS/RJuYxUE1dRQdXvltaPnK3Ngshp8eubpn+h1YatnPWN6a Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6mer3vm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:50:10 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJngGD017826;
        Mon, 14 Mar 2022 19:50:09 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6mer3v6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:50:09 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJm5XL002536;
        Mon, 14 Mar 2022 19:50:08 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03wdc.us.ibm.com with ESMTP id 3erk58r9bk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:50:08 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJo6Vx19071364
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:50:06 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AEF6F112065;
        Mon, 14 Mar 2022 19:50:06 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDC3F112067;
        Mon, 14 Mar 2022 19:50:00 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:50:00 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 07/11] s390x/pci: enable adapter event notification for interpreted devices
Date:   Mon, 14 Mar 2022 15:49:16 -0400
Message-Id: <20220314194920.58888-8-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194920.58888-1-mjrosato@linux.ibm.com>
References: <20220314194920.58888-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C7HMTVEBmGd6nQ6KciOj82Ow9JJUvHl5
X-Proofpoint-ORIG-GUID: vl4XuRqee3pIEutEK4d8mmaGWi0xrAt9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 adultscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 suspectscore=0 mlxscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
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
 hw/s390x/s390-pci-kvm.c         | 27 ++++++++++++++++++++++
 include/hw/s390x/s390-pci-bus.h |  1 +
 include/hw/s390x/s390-pci-kvm.h | 12 ++++++++++
 5 files changed, 95 insertions(+), 5 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index acc91af64c..5043b8c85c 100644
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
@@ -1072,6 +1075,7 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
                 } else {
                     DPRINTF("zPCI interpretation facilities missing.\n");
                     pbdev->interp = false;
+                    pbdev->forwarding_assist = false;
                 }
             }
             pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
@@ -1080,11 +1084,13 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
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
@@ -1241,7 +1247,10 @@ static void s390_pcihost_reset(DeviceState *dev)
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
@@ -1379,7 +1388,10 @@ static void s390_pci_device_reset(DeviceState *dev)
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
@@ -1425,6 +1437,8 @@ static Property s390_pci_device_properties[] = {
     DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
     DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
     DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
+    DEFINE_PROP_BOOL("forwarding_assist", S390PCIBusDevice, forwarding_assist,
+                     true),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 92ea7b73e4..f7b01e2059 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -1102,6 +1102,32 @@ static void fmb_update(void *opaque)
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
@@ -1156,7 +1182,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
 
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
@@ -1165,7 +1196,12 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
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
index 755ea0618a..ebb862abd0 100644
--- a/hw/s390x/s390-pci-kvm.c
+++ b/hw/s390x/s390-pci-kvm.c
@@ -16,6 +16,7 @@
 #include "kvm/kvm_s390x.h"
 #include "hw/s390x/s390-pci-bus.h"
 #include "hw/s390x/s390-pci-kvm.h"
+#include "hw/s390x/s390-pci-inst.h"
 #include "hw/s390x/s390-pci-vfio.h"
 
 bool s390_pci_kvm_zpciop_allowed(void)
@@ -110,3 +111,29 @@ int s390_pci_kvm_interp_disable(S390PCIBusDevice *pbdev)
 
     return rc;
 }
+
+int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, bool assist)
+{
+    struct kvm_s390_zpci_op args = {
+        .fh = pbdev->fh,
+        .op = KVM_S390_ZPCIOP_REG_INT,
+        .u.reg_int.ibv = fib->aibv,
+        .u.reg_int.sb = fib->aisb,
+        .u.reg_int.noi = FIB_DATA_NOI(fib->data),
+        .u.reg_int.isc = FIB_DATA_ISC(fib->data),
+        .u.reg_int.sbo = FIB_DATA_AISBO(fib->data),
+        .u.reg_int.flags = (assist) ? 0 : KVM_S390_ZPCIOP_REGINT_HOST
+    };
+
+    return kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
+}
+
+int s390_pci_kvm_aif_disable(S390PCIBusDevice *pbdev)
+{
+    struct kvm_s390_zpci_op args = {
+        .fh = pbdev->fh,
+        .op = KVM_S390_ZPCIOP_DEREG_INT
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
index 6b2528cf82..09004d3f6c 100644
--- a/include/hw/s390x/s390-pci-kvm.h
+++ b/include/hw/s390x/s390-pci-kvm.h
@@ -13,6 +13,7 @@
 #define HW_S390_PCI_KVM_H
 
 #include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-inst.h"
 
 #ifdef CONFIG_KVM
 bool s390_pci_kvm_zpciop_allowed(void);
@@ -20,6 +21,8 @@ int s390_pci_kvm_plug(S390PCIBusDevice *pbdev);
 int s390_pci_kvm_unplug(S390PCIBusDevice *pbdev);
 int s390_pci_kvm_interp_enable(S390PCIBusDevice *pbdev);
 int s390_pci_kvm_interp_disable(S390PCIBusDevice *pbdev);
+int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, bool assist);
+int s390_pci_kvm_aif_disable(S390PCIBusDevice *pbdev);
 #else
 static inline bool s390_pci_kvm_zpciop_allowed(void)
 {
@@ -41,6 +44,15 @@ static inline int s390_pci_kvm_interp_enable(S390PCIBusDevice *pbdev)
 {
     return -EINVAL;
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

