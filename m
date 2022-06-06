Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301EE53F006
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiFFUkW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbiFFUkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:40:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E05EAB0EE
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 13:36:51 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KUw6C005289;
        Mon, 6 Jun 2022 20:36:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nLoiENdo4G+MSGXq+sMeriBC+mC3/IynDD0fDmjuW7E=;
 b=li/Y1scZDk8Fx7dET7Bo3bZnNR94lmycPziiXX1Kk1pBP+xa30UfryCr7l+Iy55m9fgY
 FYHnIPOcu3aTpu7jWYCNhDwUfjsGRpPmuUCT7BTeaUV7cTMGb1GLps3nmnhtkXp9PCmf
 49raH3zXAeD+xMVVnRzCbLhTjQtMBFYqS6ulUMxR5+2DqOqiLrVU45JK/SQYcxIeJNuJ
 Kd3/9Kucrvvc8L0tbfIb4aVPcT7F71vcPqUTZz87eps0qqY6GXNvFxXIh0tf+rJaSluO
 NqqegxdHVN6FLWTTMe9icmVxWlnYimu8xNOK2OVfcOYb+szJcWS/if7qT20GTXAb2f0h zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqpeh17t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:36:47 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KWWXi010510;
        Mon, 6 Jun 2022 20:36:46 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghqpeh179-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:36:46 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KKUeB024177;
        Mon, 6 Jun 2022 20:36:45 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 3gfy19uu2w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:36:45 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256Kahn427460062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:36:44 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCB6F2805A;
        Mon,  6 Jun 2022 20:36:43 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18D3C28058;
        Mon,  6 Jun 2022 20:36:40 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.20.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:36:39 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v7 5/8] s390x/pci: enable adapter event notification for interpreted devices
Date:   Mon,  6 Jun 2022 16:36:11 -0400
Message-Id: <20220606203614.110928-6-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220606203614.110928-1-mjrosato@linux.ibm.com>
References: <20220606203614.110928-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: FvBuE4YmpUy4G6ougJd78dURkA65odRn
X-Proofpoint-ORIG-GUID: AO_qYdUyG9VzzKat9XXJiJIAf6OpQz4-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501
 adultscore=0 impostorscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206060081
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
index 0f16104a74..9134fe185f 100644
--- a/hw/s390x/s390-pci-kvm.c
+++ b/hw/s390x/s390-pci-kvm.c
@@ -11,12 +11,42 @@
 
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
 {
     return kvm_s390_get_zpci_op() && !s390_is_pv();
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

