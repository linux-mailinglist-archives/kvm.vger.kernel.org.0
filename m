Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE03D4D8D6E
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242627AbiCNTxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244727AbiCNTwY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:52:24 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA40ACD0
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 12:50:56 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlVUD035046;
        Mon, 14 Mar 2022 19:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MXSsAsZuVnM/s6D6tfMaszmULKzq0LzIfX0tqQlVki4=;
 b=GMLWyWjHJ36+VdAJHGtsDNXo8PvtITHKQm7NVG2+7YlcefuBJbr7KHl3ICPBgQBcAEBL
 Ut14k9fR8mCmYR8AKpIVqUpMG+EtXW8p/RAwqm2N8tb/Fs+ViUXTnKEUU584PI/K5imj
 WUVK1neGxDQytr6rtmYJfjy7gA+Wr4AvZ/kVXOhN7/Nw7zjC51XSoPCJWy2dIQMdIuLo
 J1AyVWW/c8qKTs3sMdtarQVEQLVwCyCqcuXIdbnSdIQidCFD6gmM6URnjA1waHocei/0
 Q5Z3PobXP2apcdEGy5A9oqP1JwAiVtZxDUArCgpincZtBQkC77+bNO0vNyslkYhi+Zj+ 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6d9gqep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:50:21 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJoK3D004883;
        Mon, 14 Mar 2022 19:50:20 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3et6d9gqec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:50:20 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJl8BA004527;
        Mon, 14 Mar 2022 19:50:19 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 3erk59g81j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:50:19 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJoIeZ11338090
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:50:18 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7AB4112062;
        Mon, 14 Mar 2022 19:50:17 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1653F112069;
        Mon, 14 Mar 2022 19:50:13 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:50:12 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v4 09/11] s390x/pci: use I/O Address Translation assist when interpreting
Date:   Mon, 14 Mar 2022 15:49:18 -0400
Message-Id: <20220314194920.58888-10-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194920.58888-1-mjrosato@linux.ibm.com>
References: <20220314194920.58888-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NbFzwao48man5RQf4j-kVcGkoa3sDd4g
X-Proofpoint-ORIG-GUID: edorsVmVLiMcbCy9gktR_3R4-slSyxuU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 phishscore=0 impostorscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 clxscore=1015 mlxlogscore=924 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the underlying kvm host to handle the Refresh PCI Translation
instruction intercepts.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c          |  6 ++---
 hw/s390x/s390-pci-inst.c         | 42 +++++++++++++++++++++++++++++---
 hw/s390x/s390-pci-kvm.c          | 21 ++++++++++++++++
 include/hw/s390x/s390-pci-inst.h |  2 +-
 include/hw/s390x/s390-pci-kvm.h  | 10 ++++++++
 5 files changed, 74 insertions(+), 7 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 513a276711..32894fbe9c 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -197,7 +197,7 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
             pci_dereg_irqs(pbdev);
         }
         if (pbdev->iommu->enabled) {
-            pci_dereg_ioat(pbdev->iommu);
+            pci_dereg_ioat(pbdev);
         }
         pbdev->state = ZPCI_FS_STANDBY;
         rc = SCLP_RC_NORMAL_COMPLETION;
@@ -1265,7 +1265,7 @@ static void s390_pcihost_reset(DeviceState *dev)
                 pci_dereg_irqs(pbdev);
             }
             if (pbdev->iommu->enabled) {
-                pci_dereg_ioat(pbdev->iommu);
+                pci_dereg_ioat(pbdev);
             }
             pbdev->state = ZPCI_FS_STANDBY;
             s390_pci_perform_unplug(pbdev);
@@ -1406,7 +1406,7 @@ static void s390_pci_device_reset(DeviceState *dev)
         pci_dereg_irqs(pbdev);
     }
     if (pbdev->iommu->enabled) {
-        pci_dereg_ioat(pbdev->iommu);
+        pci_dereg_ioat(pbdev);
     }
 
     fmb_timer_free(pbdev);
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index f7b01e2059..86bb04e859 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -969,6 +969,19 @@ int pci_dereg_irqs(S390PCIBusDevice *pbdev)
     return 0;
 }
 
+static int reg_ioat_interp(S390PCIBusDevice *pbdev, uint64_t iota)
+{
+    int rc;
+
+    rc = s390_pci_kvm_ioat_enable(pbdev, iota);
+    if (rc) {
+        return rc;
+    }
+
+    pbdev->iommu->enabled = true;
+    return 0;
+}
+
 static int reg_ioat(CPUS390XState *env, S390PCIBusDevice *pbdev, ZpciFib fib,
                     uintptr_t ra)
 {
@@ -986,6 +999,16 @@ static int reg_ioat(CPUS390XState *env, S390PCIBusDevice *pbdev, ZpciFib fib,
         return -EINVAL;
     }
 
+    /* If this is an interpreted device, we must use the IOAT assist */
+    if (pbdev->interp) {
+        if (reg_ioat_interp(pbdev, g_iota)) {
+            error_report("failure starting ioat assist");
+            s390_program_interrupt(env, PGM_OPERAND, ra);
+            return -EINVAL;
+        }
+        return 0;
+    }
+
     /* currently we only support designation type 1 with translation */
     if (!(dt == ZPCI_IOTA_RTTO && t)) {
         error_report("unsupported ioat dt %d t %d", dt, t);
@@ -1002,8 +1025,21 @@ static int reg_ioat(CPUS390XState *env, S390PCIBusDevice *pbdev, ZpciFib fib,
     return 0;
 }
 
-void pci_dereg_ioat(S390PCIIOMMU *iommu)
+static void dereg_ioat_interp(S390PCIBusDevice *pbdev)
+{
+    s390_pci_kvm_ioat_disable(pbdev);
+    pbdev->iommu->enabled = false;
+}
+
+void pci_dereg_ioat(S390PCIBusDevice *pbdev)
 {
+    S390PCIIOMMU *iommu = pbdev->iommu;
+
+    if (pbdev->interp) {
+        dereg_ioat_interp(pbdev);
+        return;
+    }
+
     s390_pci_iommu_disable(iommu);
     iommu->pba = 0;
     iommu->pal = 0;
@@ -1228,7 +1264,7 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
             cc = ZPCI_PCI_LS_ERR;
             s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
         } else {
-            pci_dereg_ioat(pbdev->iommu);
+            pci_dereg_ioat(pbdev);
         }
         break;
     case ZPCI_MOD_FC_REREG_IOAT:
@@ -1239,7 +1275,7 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
             cc = ZPCI_PCI_LS_ERR;
             s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
         } else {
-            pci_dereg_ioat(pbdev->iommu);
+            pci_dereg_ioat(pbdev);
             if (reg_ioat(env, pbdev, fib, ra)) {
                 cc = ZPCI_PCI_LS_ERR;
                 s390_set_status_code(env, r1, ZPCI_MOD_ST_INSUF_RES);
diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
index ebb862abd0..2332efd676 100644
--- a/hw/s390x/s390-pci-kvm.c
+++ b/hw/s390x/s390-pci-kvm.c
@@ -137,3 +137,24 @@ int s390_pci_kvm_aif_disable(S390PCIBusDevice *pbdev)
 
     return kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
 }
+
+int s390_pci_kvm_ioat_enable(S390PCIBusDevice *pbdev, uint64_t iota)
+{
+    struct kvm_s390_zpci_op args = {
+        .fh = pbdev->fh,
+        .op = KVM_S390_ZPCIOP_REG_IOAT,
+        .u.reg_ioat.iota = iota
+    };
+
+    return kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
+}
+
+int s390_pci_kvm_ioat_disable(S390PCIBusDevice *pbdev)
+{
+    struct kvm_s390_zpci_op args = {
+        .fh = pbdev->fh,
+        .op = KVM_S390_ZPCIOP_DEREG_IOAT
+    };
+
+    return kvm_vm_ioctl(kvm_state, KVM_S390_ZPCI_OP, &args);
+}
diff --git a/include/hw/s390x/s390-pci-inst.h b/include/hw/s390x/s390-pci-inst.h
index a55c448aad..13566fb7b4 100644
--- a/include/hw/s390x/s390-pci-inst.h
+++ b/include/hw/s390x/s390-pci-inst.h
@@ -99,7 +99,7 @@ typedef struct ZpciFib {
 } QEMU_PACKED ZpciFib;
 
 int pci_dereg_irqs(S390PCIBusDevice *pbdev);
-void pci_dereg_ioat(S390PCIIOMMU *iommu);
+void pci_dereg_ioat(S390PCIBusDevice *pbdev);
 int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra);
 int pcilg_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra);
 int pcistg_service_call(S390CPU *cpu, uint8_t r1, uint8_t r2, uintptr_t ra);
diff --git a/include/hw/s390x/s390-pci-kvm.h b/include/hw/s390x/s390-pci-kvm.h
index 09004d3f6c..e52e92d0f0 100644
--- a/include/hw/s390x/s390-pci-kvm.h
+++ b/include/hw/s390x/s390-pci-kvm.h
@@ -23,6 +23,8 @@ int s390_pci_kvm_interp_enable(S390PCIBusDevice *pbdev);
 int s390_pci_kvm_interp_disable(S390PCIBusDevice *pbdev);
 int s390_pci_kvm_aif_enable(S390PCIBusDevice *pbdev, ZpciFib *fib, bool assist);
 int s390_pci_kvm_aif_disable(S390PCIBusDevice *pbdev);
+int s390_pci_kvm_ioat_enable(S390PCIBusDevice *pbdev, uint64_t iota);
+int s390_pci_kvm_ioat_disable(S390PCIBusDevice *pbdev);
 #else
 static inline bool s390_pci_kvm_zpciop_allowed(void)
 {
@@ -53,6 +55,14 @@ static inline int s390_pci_kvm_aif_disable(S390PCIBusDevice *pbdev)
 {
     return -EINVAL;
 }
+int s390_pci_kvm_ioat_enable(S390PCIBusDevice *pbdev, uint64_t iota)
+{
+    return -EINVAL;
+}
+int s390_pci_kvm_ioat_disable(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
 #endif
 
 #endif
-- 
2.27.0

