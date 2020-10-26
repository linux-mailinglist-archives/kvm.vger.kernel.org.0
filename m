Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C352F299132
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 16:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1784057AbgJZPg5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 11:36:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:2254 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1784056AbgJZPg5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 11:36:57 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QFX4px191216;
        Mon, 26 Oct 2020 11:36:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=pZbViX+FqQ9sYagGOKjZx+VWsfimQDk7TvCgaEG+Vc4=;
 b=TwOW//y6eesQWG2l+8nJ7Tda95dviXQJ1LP6Hb2g+gfwwrHwLGdDg3F25zuQjW467nx1
 ikeQga2kM8+PBxxmflAZgOPPEr5lauxqLdCOvaXu/IbKt97UOZudPeSxHR0ifyLM3Vza
 McyNi0JmAKI5L1mnryxqn+Cg0fBsMrv9Ydm5l2ly0Vf5HdqgMAyI8O9Bln7Qa7QVByrU
 4eLKmHF0E8DcGk+7y4wHf1EKAFYKL1os2L9UbHytcZ30SD0SzGYWfczn8T6jFgffrHFF
 svT7x90HlhJPGIo7ugZ4eIUC0cFg0RdjuiNR4ACg5ERubSp/qdFuslGC7HprxrPERP6g /w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dxaxnwkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:36:50 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QFX0qt190867;
        Mon, 26 Oct 2020 11:36:49 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34dxaxnwk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:36:49 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QFIHot023423;
        Mon, 26 Oct 2020 15:36:48 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma03dal.us.ibm.com with ESMTP id 34cbw8vth7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 15:36:48 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QFZX2q55968030
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 15:35:33 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F197112064;
        Mon, 26 Oct 2020 15:35:33 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0CA21112062;
        Mon, 26 Oct 2020 15:35:30 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.49.29])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 15:35:29 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 13/13] s390x/pci: get zPCI function info from host
Date:   Mon, 26 Oct 2020 11:34:41 -0400
Message-Id: <1603726481-31824-14-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=2 priorityscore=1501 malwarescore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We use the capability chains of the VFIO_DEVICE_GET_INFO ioctl to retrieve
the CLP information that the kernel exports.

To be compatible with previous kernel versions we fall back on previous
predefined values, same as the emulation values, when the ioctl is found
to not support capability chains. If individual CLP capabilities are not
found, we fall back on default values for only those capabilities missing
from the chain.

This patch is based on work previously done by Pierre Morel.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c          |   9 +-
 hw/s390x/s390-pci-vfio.c         | 180 +++++++++++++++++++++++++++++++++++++++
 hw/s390x/trace-events            |   6 ++
 include/hw/s390x/s390-pci-bus.h  |   1 +
 include/hw/s390x/s390-pci-clp.h  |  12 ++-
 include/hw/s390x/s390-pci-vfio.h |   1 +
 6 files changed, 202 insertions(+), 7 deletions(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 072b56e..48a3be8 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -738,7 +738,7 @@ static void s390_pci_iommu_free(S390pciState *s, PCIBus *bus, int32_t devfn)
     object_unref(OBJECT(iommu));
 }
 
-static S390PCIGroup *s390_group_create(int id)
+S390PCIGroup *s390_group_create(int id)
 {
     S390PCIGroup *group;
     S390pciState *s = s390_get_phb();
@@ -783,7 +783,7 @@ static void set_pbdev_info(S390PCIBusDevice *pbdev)
     pbdev->zpci_fn.sdma = ZPCI_SDMA_ADDR;
     pbdev->zpci_fn.edma = ZPCI_EDMA_ADDR;
     pbdev->zpci_fn.pchid = 0;
-    pbdev->zpci_fn.ug = ZPCI_DEFAULT_FN_GRP;
+    pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
     pbdev->zpci_fn.fid = pbdev->fid;
     pbdev->zpci_fn.uid = pbdev->uid;
     pbdev->pci_group = s390_group_find(ZPCI_DEFAULT_FN_GRP);
@@ -863,7 +863,8 @@ static int s390_pci_msix_init(S390PCIBusDevice *pbdev)
     name = g_strdup_printf("msix-s390-%04x", pbdev->uid);
     memory_region_init_io(&pbdev->msix_notify_mr, OBJECT(pbdev),
                           &s390_msi_ctrl_ops, pbdev, name, PAGE_SIZE);
-    memory_region_add_subregion(&pbdev->iommu->mr, ZPCI_MSI_ADDR,
+    memory_region_add_subregion(&pbdev->iommu->mr,
+                                pbdev->pci_group->zpci_group.msia,
                                 &pbdev->msix_notify_mr);
     g_free(name);
 
@@ -1016,6 +1017,8 @@ static void s390_pcihost_plug(HotplugHandler *hotplug_dev, DeviceState *dev,
         if (object_dynamic_cast(OBJECT(dev), "vfio-pci")) {
             pbdev->fh |= FH_SHM_VFIO;
             pbdev->iommu->dma_limit = s390_pci_start_dma_count(s, pbdev);
+            /* Fill in CLP information passed via the vfio region */
+            s390_pci_get_clp_info(pbdev);
         } else {
             pbdev->fh |= FH_SHM_EMUL;
         }
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
index 0621fa3..d5c7806 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -10,9 +10,13 @@
  */
 
 #include <sys/ioctl.h>
+#include <linux/vfio.h>
+#include <linux/vfio_zdev.h>
 
 #include "qemu/osdep.h"
+#include "trace.h"
 #include "hw/s390x/s390-pci-bus.h"
+#include "hw/s390x/s390-pci-clp.h"
 #include "hw/s390x/s390-pci-vfio.h"
 #include "hw/vfio/pci.h"
 #include "hw/vfio/vfio-common.h"
@@ -94,3 +98,179 @@ void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt)
         QTAILQ_REMOVE(&s->zpci_dma_limit, cnt, link);
     }
 }
+
+static void s390_pci_read_base(S390PCIBusDevice *pbdev,
+                               struct vfio_device_info *info)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_device_info_cap_zpci_base *cap;
+    VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_BASE);
+
+    /* If capability not provided, just leave the defaults in place */
+    if (hdr == NULL) {
+        trace_s390_pci_clp_cap(vpci->vbasedev.name,
+                               VFIO_DEVICE_INFO_CAP_ZPCI_BASE);
+        return;
+    }
+    cap = (void *) hdr;
+
+    pbdev->zpci_fn.sdma = cap->start_dma;
+    pbdev->zpci_fn.edma = cap->end_dma;
+    pbdev->zpci_fn.pchid = cap->pchid;
+    pbdev->zpci_fn.vfn = cap->vfn;
+    pbdev->zpci_fn.pfgid = cap->gid;
+    /* The following values remain 0 until we support other FMB formats */
+    pbdev->zpci_fn.fmbl = 0;
+    pbdev->zpci_fn.pft = 0;
+}
+
+static void s390_pci_read_group(S390PCIBusDevice *pbdev,
+                                struct vfio_device_info *info)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_device_info_cap_zpci_group *cap;
+    ClpRspQueryPciGrp *resgrp;
+    VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
+
+    /* If capability not provided, just use the default group */
+    if (hdr == NULL) {
+        trace_s390_pci_clp_cap(vpci->vbasedev.name,
+                               VFIO_DEVICE_INFO_CAP_ZPCI_GROUP);
+        pbdev->zpci_fn.pfgid = ZPCI_DEFAULT_FN_GRP;
+        pbdev->pci_group = s390_group_find(ZPCI_DEFAULT_FN_GRP);
+        return;
+    }
+    cap = (void *) hdr;
+
+    /* See if the PCI group is already defined, create if not */
+    pbdev->pci_group = s390_group_find(pbdev->zpci_fn.pfgid);
+
+    if (!pbdev->pci_group) {
+        pbdev->pci_group = s390_group_create(pbdev->zpci_fn.pfgid);
+
+        resgrp = &pbdev->pci_group->zpci_group;
+        if (cap->flags & VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH) {
+            resgrp->fr = 1;
+        }
+        stq_p(&resgrp->dasm, cap->dasm);
+        stq_p(&resgrp->msia, cap->msi_addr);
+        stw_p(&resgrp->mui, cap->mui);
+        stw_p(&resgrp->i, cap->noi);
+        stw_p(&resgrp->maxstbl, cap->maxstbl);
+        stb_p(&resgrp->version, cap->version);
+    }
+}
+
+static void s390_pci_read_util(S390PCIBusDevice *pbdev,
+                               struct vfio_device_info *info)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_device_info_cap_zpci_util *cap;
+    VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_UTIL);
+
+    /* If capability not provided, just leave the defaults in place */
+    if (hdr == NULL) {
+        trace_s390_pci_clp_cap(vpci->vbasedev.name,
+                               VFIO_DEVICE_INFO_CAP_ZPCI_UTIL);
+        return;
+    }
+    cap = (void *) hdr;
+
+    if (cap->size > CLP_UTIL_STR_LEN) {
+        trace_s390_pci_clp_cap_size(vpci->vbasedev.name, cap->size,
+                                    VFIO_DEVICE_INFO_CAP_ZPCI_UTIL);
+        return;
+    }
+
+    pbdev->zpci_fn.flags |= CLP_RSP_QPCI_MASK_UTIL;
+    memcpy(pbdev->zpci_fn.util_str, cap->util_str, CLP_UTIL_STR_LEN);
+}
+
+static void s390_pci_read_pfip(S390PCIBusDevice *pbdev,
+                               struct vfio_device_info *info)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_device_info_cap_zpci_pfip *cap;
+    VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_PFIP);
+
+    /* If capability not provided, just leave the defaults in place */
+    if (hdr == NULL) {
+        trace_s390_pci_clp_cap(vpci->vbasedev.name,
+                               VFIO_DEVICE_INFO_CAP_ZPCI_PFIP);
+        return;
+    }
+    cap = (void *) hdr;
+
+    if (cap->size > CLP_PFIP_NR_SEGMENTS) {
+        trace_s390_pci_clp_cap_size(vpci->vbasedev.name, cap->size,
+                                    VFIO_DEVICE_INFO_CAP_ZPCI_PFIP);
+        return;
+    }
+
+    memcpy(pbdev->zpci_fn.pfip, cap->pfip, CLP_PFIP_NR_SEGMENTS);
+}
+
+/*
+ * This function will issue the VFIO_DEVICE_GET_INFO ioctl and look for
+ * capabilities that contain information about CLP features provided by the
+ * underlying host.
+ * On entry, defaults have already been placed into the guest CLP response
+ * buffers.  On exit, defaults will have been overwritten for any CLP features
+ * found in the capability chain; defaults will remain for any CLP features not
+ * found in the chain.
+ */
+void s390_pci_get_clp_info(S390PCIBusDevice *pbdev)
+{
+    g_autofree struct vfio_device_info *info;
+    VFIOPCIDevice *vfio_pci;
+    uint32_t argsz;
+    int fd;
+
+    argsz = sizeof(*info);
+    info = g_malloc0(argsz);
+
+    vfio_pci = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+    fd = vfio_pci->vbasedev.fd;
+
+    /*
+     * If the specified argsz is not large enough to contain all capabilities
+     * it will be updated upon return from the ioctl.  Retry until we have
+     * a big enough buffer to hold the entire capability chain.  On error,
+     * just exit and rely on CLP defaults.
+     */
+retry:
+    info->argsz = argsz;
+
+    if (ioctl(fd, VFIO_DEVICE_GET_INFO, info)) {
+        trace_s390_pci_clp_dev_info(vfio_pci->vbasedev.name);
+        return;
+    }
+
+    if (info->argsz > argsz) {
+        argsz = info->argsz;
+        info = g_realloc(info, argsz);
+        goto retry;
+    }
+
+    /*
+     * Find the CLP features provided and fill in the guest CLP responses.
+     * Always call s390_pci_read_base first as information from this could
+     * determine which function group is used in s390_pci_read_group.
+     * For any feature not found, the default values will remain in the CLP
+     * response.
+     */
+    s390_pci_read_base(pbdev, info);
+    s390_pci_read_group(pbdev, info);
+    s390_pci_read_util(pbdev, info);
+    s390_pci_read_pfip(pbdev, info);
+
+    return;
+}
diff --git a/hw/s390x/trace-events b/hw/s390x/trace-events
index 0dc5b81..0e27b95 100644
--- a/hw/s390x/trace-events
+++ b/hw/s390x/trace-events
@@ -14,3 +14,9 @@ css_do_sic(uint16_t mode, uint8_t isc) "CSS: set interruption mode 0x%x on isc 0
 virtio_ccw_interpret_ccw(int cssid, int ssid, int schid, int cmd_code) "VIRTIO-CCW: %x.%x.%04x: interpret command 0x%x"
 virtio_ccw_new_device(int cssid, int ssid, int schid, int devno, const char *devno_mode) "VIRTIO-CCW: add subchannel %x.%x.%04x, devno 0x%04x (%s)"
 virtio_ccw_set_ind(uint64_t ind_loc, uint8_t ind_old, uint8_t ind_new) "VIRTIO-CCW: indicator at %" PRIu64 ": 0x%x->0x%x"
+
+# s390-pci-vfio.c
+s390_pci_clp_cap(const char *id, uint32_t cap) "PCI: %s: missing expected CLP capability %u"
+s390_pci_clp_cap_size(const char *id, uint32_t size, uint32_t cap) "PCI: %s: bad size (%u) for CLP capability %u"
+s390_pci_clp_dev_info(const char *id) "PCI: %s: cannot read vfio device info"
+
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index fe36f16..49ae9f0 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -322,6 +322,7 @@ typedef struct S390PCIGroup {
     int id;
     QTAILQ_ENTRY(S390PCIGroup) link;
 } S390PCIGroup;
+S390PCIGroup *s390_group_create(int id);
 S390PCIGroup *s390_group_find(int id);
 
 struct S390PCIBusDevice {
diff --git a/include/hw/s390x/s390-pci-clp.h b/include/hw/s390x/s390-pci-clp.h
index 3708acd..ea2b137 100644
--- a/include/hw/s390x/s390-pci-clp.h
+++ b/include/hw/s390x/s390-pci-clp.h
@@ -79,6 +79,7 @@ typedef struct ClpFhListEntry {
 #define CLP_SET_DISABLE_PCI_FN 1 /* Yes, 1 disables it */
 
 #define CLP_UTIL_STR_LEN 64
+#define CLP_PFIP_NR_SEGMENTS 4
 
 #define CLP_MASK_FMT 0xf0000000
 
@@ -120,14 +121,17 @@ typedef struct ClpRspQueryPci {
     uint32_t fmt;
     uint64_t reserved1;
     uint16_t vfn; /* virtual fn number */
-#define CLP_RSP_QPCI_MASK_UTIL  0x100
-#define CLP_RSP_QPCI_MASK_PFGID 0xff
-    uint16_t ug;
+#define CLP_RSP_QPCI_MASK_UTIL  0x01
+    uint8_t flags;
+    uint8_t pfgid;
     uint32_t fid; /* pci function id */
     uint8_t bar_size[PCI_BAR_COUNT];
     uint16_t pchid;
     uint32_t bar[PCI_BAR_COUNT];
-    uint64_t reserved2;
+    uint8_t pfip[CLP_PFIP_NR_SEGMENTS];
+    uint16_t reserved2;
+    uint8_t fmbl;
+    uint8_t pft;
     uint64_t sdma; /* start dma as */
     uint64_t edma; /* end dma as */
     uint32_t reserved3[11];
diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
index 9613783..e72fa7e 100644
--- a/include/hw/s390x/s390-pci-vfio.h
+++ b/include/hw/s390x/s390-pci-vfio.h
@@ -18,5 +18,6 @@ bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
 S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
                                           S390PCIBusDevice *pbdev);
 void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt);
+void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
 
 #endif
-- 
1.8.3.1

