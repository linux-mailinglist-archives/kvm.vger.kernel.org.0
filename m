Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECE853313D
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240809AbiEXTFG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241010AbiEXTEo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:04:44 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC6F28998
        for <kvm@vger.kernel.org>; Tue, 24 May 2022 12:03:45 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIIlr0015153;
        Tue, 24 May 2022 19:03:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=RmEBmyYM5Gz9ciSMbGWfakRuAQqPIc32fcku6p/KEm4=;
 b=UOXzYg+y7J1Dh/QOZmeBFJDjC37mT1jWUsZKWRP4JBnr14MnlzCjeLhRnQvb42/MAx9o
 yPtjrwEpnK+SPQU5k1RuebbAtioX4weKaLuJKixMZmNV0hujhKVnndZqJvWrzBRuO0F2
 MAI+1WTgJu7LfRoylzoPEZ1NS7z0OgFJYG+fPDGW4S63+9CYbz+cbd5r9PV55HJZaS24
 0SZ1+FvD+LJdQiyPVGCA60e9P0iBvCSvMrdO6p63VsxL4rEZgX3BwrTkxdYf6r4bHTr1
 QS2CZv09SYrhiHPEurPfNg66IqgVYdJR0UsiD+IFtXtbCWedwVrd+OpVk633ZcP92TzM jg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94hggsxe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:29 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OJ0SEg014407;
        Tue, 24 May 2022 19:03:29 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94hggswx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:29 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OJ2vlr022736;
        Tue, 24 May 2022 19:03:28 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma03wdc.us.ibm.com with ESMTP id 3g93v8rjea-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 19:03:28 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OJ3RYM34013588
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 19:03:27 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36EC5124052;
        Tue, 24 May 2022 19:03:27 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F88A12405C;
        Tue, 24 May 2022 19:03:24 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 19:03:23 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v6 3/8] s390x/pci: add routine to get host function handle from CLP info
Date:   Tue, 24 May 2022 15:03:00 -0400
Message-Id: <20220524190305.140717-4-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524190305.140717-1-mjrosato@linux.ibm.com>
References: <20220524190305.140717-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vNirbEE_E-ET7oT4TQFoMcuILWwMSTS4
X-Proofpoint-ORIG-GUID: SONTvMC6o30Z4PlYWwOW0kQ7SZCm5sAw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 mlxlogscore=971 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to interface with the underlying host zPCI device, we need
to know it's function handle.  Add a routine to grab this from the
vfio CLP capabilities chain.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-vfio.c         | 83 ++++++++++++++++++++++++++------
 include/hw/s390x/s390-pci-vfio.h |  5 ++
 2 files changed, 72 insertions(+), 16 deletions(-)

diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
index 6f80a47e29..4bf0a7e22d 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -124,6 +124,27 @@ static void s390_pci_read_base(S390PCIBusDevice *pbdev,
     pbdev->zpci_fn.pft = 0;
 }
 
+static bool get_host_fh(S390PCIBusDevice *pbdev, struct vfio_device_info *info,
+                        uint32_t *fh)
+{
+    struct vfio_info_cap_header *hdr;
+    struct vfio_device_info_cap_zpci_base *cap;
+    VFIOPCIDevice *vpci =  container_of(pbdev->pdev, VFIOPCIDevice, pdev);
+
+    hdr = vfio_get_device_info_cap(info, VFIO_DEVICE_INFO_CAP_ZPCI_BASE);
+
+    /* Can only get the host fh with version 2 or greater */
+    if (hdr == NULL || hdr->version < 2) {
+        trace_s390_pci_clp_cap(vpci->vbasedev.name,
+                               VFIO_DEVICE_INFO_CAP_ZPCI_BASE);
+        return false;
+    }
+    cap = (void *) hdr;
+
+    *fh = cap->fh;
+    return true;
+}
+
 static void s390_pci_read_group(S390PCIBusDevice *pbdev,
                                 struct vfio_device_info *info)
 {
@@ -217,25 +238,13 @@ static void s390_pci_read_pfip(S390PCIBusDevice *pbdev,
     memcpy(pbdev->zpci_fn.pfip, cap->pfip, CLP_PFIP_NR_SEGMENTS);
 }
 
-/*
- * This function will issue the VFIO_DEVICE_GET_INFO ioctl and look for
- * capabilities that contain information about CLP features provided by the
- * underlying host.
- * On entry, defaults have already been placed into the guest CLP response
- * buffers.  On exit, defaults will have been overwritten for any CLP features
- * found in the capability chain; defaults will remain for any CLP features not
- * found in the chain.
- */
-void s390_pci_get_clp_info(S390PCIBusDevice *pbdev)
+static struct vfio_device_info *get_device_info(S390PCIBusDevice *pbdev,
+                                                uint32_t argsz)
 {
-    g_autofree struct vfio_device_info *info = NULL;
+    struct vfio_device_info *info = g_malloc0(argsz);
     VFIOPCIDevice *vfio_pci;
-    uint32_t argsz;
     int fd;
 
-    argsz = sizeof(*info);
-    info = g_malloc0(argsz);
-
     vfio_pci = container_of(pbdev->pdev, VFIOPCIDevice, pdev);
     fd = vfio_pci->vbasedev.fd;
 
@@ -250,7 +259,8 @@ retry:
 
     if (ioctl(fd, VFIO_DEVICE_GET_INFO, info)) {
         trace_s390_pci_clp_dev_info(vfio_pci->vbasedev.name);
-        return;
+        free(info);
+        return NULL;
     }
 
     if (info->argsz > argsz) {
@@ -259,6 +269,47 @@ retry:
         goto retry;
     }
 
+    return info;
+}
+
+/*
+ * Get the host function handle from the vfio CLP capabilities chain.  Returns
+ * true if a fh value was placed into the provided buffer.  Returns false
+ * if a fh could not be obtained (ioctl failed or capabilitiy version does
+ * not include the fh)
+ */
+bool s390_pci_get_host_fh(S390PCIBusDevice *pbdev, uint32_t *fh)
+{
+    g_autofree struct vfio_device_info *info = NULL;
+
+    assert(fh);
+
+    info = get_device_info(pbdev, sizeof(*info));
+    if (!info) {
+        return false;
+    }
+
+    return get_host_fh(pbdev, info, fh);
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
+    g_autofree struct vfio_device_info *info = NULL;
+
+    info = get_device_info(pbdev, sizeof(*info));
+    if (!info) {
+        return;
+    }
+
     /*
      * Find the CLP features provided and fill in the guest CLP responses.
      * Always call s390_pci_read_base first as information from this could
diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
index ff708aef50..ae1b126ff7 100644
--- a/include/hw/s390x/s390-pci-vfio.h
+++ b/include/hw/s390x/s390-pci-vfio.h
@@ -20,6 +20,7 @@ bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
 S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
                                           S390PCIBusDevice *pbdev);
 void s390_pci_end_dma_count(S390pciState *s, S390PCIDMACount *cnt);
+bool s390_pci_get_host_fh(S390PCIBusDevice *pbdev, uint32_t *fh);
 void s390_pci_get_clp_info(S390PCIBusDevice *pbdev);
 #else
 static inline bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
@@ -33,6 +34,10 @@ static inline S390PCIDMACount *s390_pci_start_dma_count(S390pciState *s,
 }
 static inline void s390_pci_end_dma_count(S390pciState *s,
                                           S390PCIDMACount *cnt) { }
+static inline bool s390_pci_get_host_fh(S390PCIBusDevice *pbdev, uint32_t *fh)
+{
+    return false;
+}
 static inline void s390_pci_get_clp_info(S390PCIBusDevice *pbdev) { }
 #endif
 
-- 
2.27.0

