Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94B464AA23B
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241535AbiBDVUO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:20:14 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41626 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S242886AbiBDVTn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:19:43 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214Kq8sm026576;
        Fri, 4 Feb 2022 21:19:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=4r4ZoR7fuj6d/PeGdSRWFPiOEta+0fJ1tnb2QrfnJJg=;
 b=Ot/C1WF/DIZedj/aLIqUVhy4yAGCK+wAnue+Aly+QLA6f2OCdTidurjdl5YAbdFEzao5
 5PdVRUDxtUNijCKBxqFl9hRcL+wz5zJtxly5nujWZavmuxzRHsWZBFDHgcYGEqvWMjkc
 qWEKes0isC31N22ZYrqwSMBewaPCSV8+RfNwLx56BO6paJUu7OHn7w5VTbZLPNahDUFe
 wHh5Fui4dI1DZiSxY15elyWryBAX2/HtBig1VVuPxm4MsC78YMAfe0OVG6WbCXqJOuWE
 2LsldVUHBjJ9r26AD1n2VCcdSgD9b0TwHAMdzaPn97IHZBdYMQLZk0RVW9Qzk++aALxu DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0yu5q6v7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:39 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214Kj25v011108;
        Fri, 4 Feb 2022 21:19:39 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0yu5q6v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:39 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LD768009819;
        Fri, 4 Feb 2022 21:19:38 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01dal.us.ibm.com with ESMTP id 3e0r0syhyh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:38 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LJZcQ19071414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:19:35 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A128C6055;
        Fri,  4 Feb 2022 21:19:35 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A15D4C6057;
        Fri,  4 Feb 2022 21:19:33 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:19:33 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 6/8] s390x/pci: use I/O Address Translation assist when interpreting
Date:   Fri,  4 Feb 2022 16:19:16 -0500
Message-Id: <20220204211918.321924-7-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211918.321924-1-mjrosato@linux.ibm.com>
References: <20220204211918.321924-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2oS7y05oWchggvW0wXO4l7r7XIxe7GGz
X-Proofpoint-GUID: SrDp11bLGIN5XuHlrtchSVTDFninGOzW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 phishscore=0 clxscore=1015 mlxscore=0 bulkscore=0
 malwarescore=0 spamscore=0 mlxlogscore=958 lowpriorityscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow the underlying kvm host to handle the Refresh PCI Translation
instruction intercepts.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c          |  6 ++--
 hw/s390x/s390-pci-inst.c         | 51 ++++++++++++++++++++++++++++++--
 hw/s390x/s390-pci-vfio.c         | 27 +++++++++++++++++
 include/hw/s390x/s390-pci-inst.h |  2 +-
 include/hw/s390x/s390-pci-vfio.h | 10 +++++++
 5 files changed, 89 insertions(+), 7 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index e15c104175..e49dbafbc9 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -196,7 +196,7 @@ void s390_pci_sclp_deconfigure(SCCB *sccb)
             pci_dereg_irqs(pbdev);
         }
         if (pbdev->iommu->enabled) {
-            pci_dereg_ioat(pbdev->iommu);
+            pci_dereg_ioat(pbdev);
         }
         pbdev->state = ZPCI_FS_STANDBY;
         rc = SCLP_RC_NORMAL_COMPLETION;
@@ -1264,7 +1264,7 @@ static void s390_pcihost_reset(DeviceState *dev)
                 pci_dereg_irqs(pbdev);
             }
             if (pbdev->iommu->enabled) {
-                pci_dereg_ioat(pbdev->iommu);
+                pci_dereg_ioat(pbdev);
             }
             pbdev->state = ZPCI_FS_STANDBY;
             s390_pci_perform_unplug(pbdev);
@@ -1405,7 +1405,7 @@ static void s390_pci_device_reset(DeviceState *dev)
         pci_dereg_irqs(pbdev);
     }
     if (pbdev->iommu->enabled) {
-        pci_dereg_ioat(pbdev->iommu);
+        pci_dereg_ioat(pbdev);
     }
 
     fmb_timer_free(pbdev);
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index dae2012646..ec435039d3 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -978,6 +978,24 @@ int pci_dereg_irqs(S390PCIBusDevice *pbdev)
     return 0;
 }
 
+static int reg_ioat_interp(S390PCIBusDevice *pbdev, uint64_t iota)
+{
+    int rc;
+
+    rc = s390_pci_probe_ioat(pbdev);
+    if (rc) {
+        return rc;
+    }
+
+    rc = s390_pci_set_ioat(pbdev, iota);
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
@@ -995,6 +1013,16 @@ static int reg_ioat(CPUS390XState *env, S390PCIBusDevice *pbdev, ZpciFib fib,
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
@@ -1011,8 +1039,25 @@ static int reg_ioat(CPUS390XState *env, S390PCIBusDevice *pbdev, ZpciFib fib,
     return 0;
 }
 
-void pci_dereg_ioat(S390PCIIOMMU *iommu)
+static void dereg_ioat_interp(S390PCIBusDevice *pbdev)
 {
+    if (s390_pci_probe_ioat(pbdev) != 0) {
+        return;
+    }
+
+    s390_pci_set_ioat(pbdev, 0);
+    pbdev->iommu->enabled = false;
+}
+
+void pci_dereg_ioat(S390PCIBusDevice *pbdev)
+{
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
@@ -1251,7 +1296,7 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
             cc = ZPCI_PCI_LS_ERR;
             s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
         } else {
-            pci_dereg_ioat(pbdev->iommu);
+            pci_dereg_ioat(pbdev);
         }
         break;
     case ZPCI_MOD_FC_REREG_IOAT:
@@ -1262,7 +1307,7 @@ int mpcifc_service_call(S390CPU *cpu, uint8_t r1, uint64_t fiba, uint8_t ar,
             cc = ZPCI_PCI_LS_ERR;
             s390_set_status_code(env, r1, ZPCI_MOD_ST_SEQUENCE);
         } else {
-            pci_dereg_ioat(pbdev->iommu);
+            pci_dereg_ioat(pbdev);
             if (reg_ioat(env, pbdev, fib, ra)) {
                 cc = ZPCI_PCI_LS_ERR;
                 s390_set_status_code(env, r1, ZPCI_MOD_ST_INSUF_RES);
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
index 381cbb437a..d696adf3ed 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -230,6 +230,33 @@ int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enabled,
     return rc;
 }
 
+int s390_pci_probe_ioat(S390PCIBusDevice *pbdev)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
+    struct vfio_device_feature feat = {
+        .argsz = sizeof(struct vfio_device_feature),
+        .flags = VFIO_DEVICE_FEATURE_PROBE + VFIO_DEVICE_FEATURE_ZPCI_IOAT
+    };
+
+    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, &feat);
+}
+
+int s390_pci_set_ioat(S390PCIBusDevice *pbdev, uint64_t iota)
+{
+    VFIOPCIDevice *vdev = VFIO_PCI(pbdev->pdev);
+    struct vfio_device_zpci_ioat *data;
+    int size = sizeof(struct vfio_device_feature) + sizeof(*data);
+    g_autofree struct vfio_device_feature *feat = g_malloc0(size);
+
+    feat->argsz = size;
+    feat->flags = VFIO_DEVICE_FEATURE_SET + VFIO_DEVICE_FEATURE_ZPCI_IOAT;
+
+    data = (struct vfio_device_zpci_ioat *)&feat->data;
+    data->iota = iota;
+
+    return ioctl(vdev->vbasedev.fd, VFIO_DEVICE_FEATURE, feat);
+}
+
 static void s390_pci_read_base(S390PCIBusDevice *pbdev,
                                struct vfio_device_info *info)
 {
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
diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
index 7096d4a0b0..c46a800f98 100644
--- a/include/hw/s390x/s390-pci-vfio.h
+++ b/include/hw/s390x/s390-pci-vfio.h
@@ -29,6 +29,8 @@ int s390_pci_set_aif(S390PCIBusDevice *pbdev, ZpciFib *fib, bool enable,
                      bool assist);
 int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enabled,
                      bool forwarding_assist);
+int s390_pci_probe_ioat(S390PCIBusDevice *pbdev);
+int s390_pci_set_ioat(S390PCIBusDevice *pbdev, uint64_t iota);
 
 void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
 #else
@@ -69,6 +71,14 @@ static inline int s390_pci_get_aif(S390PCIBusDevice *pbdev, bool enabled,
 {
     return -EINVAL;
 }
+static inline int s390_pci_probe_ioat(S390PCIBusDevice *pbdev)
+{
+    return -EINVAL;
+}
+static inline int s390_pci_set_ioat(S390PCIBusDevice *pbdev, uint64_t iota)
+{
+    return -EINVAL;
+}
 static inline void s390_pci_get_clp_info(S390PCIBusDevice *pbdev) { }
 #endif
 
-- 
2.27.0

