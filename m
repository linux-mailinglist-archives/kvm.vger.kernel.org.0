Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EAFF29911A
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 16:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783969AbgJZPfW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 11:35:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30464 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1783988AbgJZPfV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 11:35:21 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QFXqa3087721;
        Mon, 26 Oct 2020 11:35:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=Xs3LPOdSjvkuN+QoTJKU2Piswe0EF4PyqmLh1v7T+JM=;
 b=fGFY+WIPqXN+rxByHGnQobN8MpO81+JpBJlJGcb8tV9h29/YyC72pvs23KTiMQMDfWeH
 Giqsw7h1rFIrMaTZ6CNR5ggHQRmqBkYCDUBS+M9AwYjMTTem07GAEKId+Lw1mGgHhVc7
 P0jAh5Vh/vu/t3v+L6dJ8kYRCYH7HthfPfOkqBYLijaO3hMulLNf3jofG/CT4SNPrcTI
 6ItpKUysZKx2lP2/9sAAvajFpaGPzlMIqVUwufma+xuwB4AiMJFpcNKeIhG+e8TH2LiF
 evQfnwXnZS9GoTb5MS2XS3ScDcfPzhvHPrEotmlIN/cPSs5KFSxd5Tr4HsV9zXF6AVD/ Lw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34dp3qarth-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:13 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QFYPtA091071;
        Mon, 26 Oct 2020 11:35:12 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34dp3qart2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:12 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QFIHAM023321;
        Mon, 26 Oct 2020 15:35:11 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 34cbw8vt19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 15:35:11 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QFZATR11862728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 15:35:10 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CE0CB112066;
        Mon, 26 Oct 2020 15:35:10 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E003112064;
        Mon, 26 Oct 2020 15:35:08 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.49.29])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 15:35:08 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 06/13] s390x/pci: Add routine to get the vfio dma available count
Date:   Mon, 26 Oct 2020 11:34:34 -0400
Message-Id: <1603726481-31824-7-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 impostorscore=0
 spamscore=0 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create new files for separating out vfio-specific work for s390
pci. Add the first such routine, which issues VFIO_IOMMU_GET_INFO
ioctl to collect the current dma available count.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/s390x/meson.build             |  1 +
 hw/s390x/s390-pci-vfio.c         | 54 ++++++++++++++++++++++++++++++++++++++++
 include/hw/s390x/s390-pci-vfio.h | 17 +++++++++++++
 3 files changed, 72 insertions(+)
 create mode 100644 hw/s390x/s390-pci-vfio.c
 create mode 100644 include/hw/s390x/s390-pci-vfio.h

diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
index 948ceae..3ee4594 100644
--- a/hw/s390x/meson.build
+++ b/hw/s390x/meson.build
@@ -10,6 +10,7 @@ s390x_ss.add(files(
   's390-ccw.c',
   's390-pci-bus.c',
   's390-pci-inst.c',
+  's390-pci-vfio.c',
   's390-skeys.c',
   's390-stattrib.c',
   's390-virtio-hcall.c',
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
new file mode 100644
index 0000000..cb3f4d9
--- /dev/null
+++ b/hw/s390x/s390-pci-vfio.c
@@ -0,0 +1,54 @@
+/*
+ * s390 vfio-pci interfaces
+ *
+ * Copyright 2020 IBM Corp.
+ * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#include <sys/ioctl.h>
+
+#include "qemu/osdep.h"
+#include "hw/s390x/s390-pci-vfio.h"
+#include "hw/vfio/vfio-common.h"
+
+/*
+ * Get the current DMA available count from vfio.  Returns true if vfio is
+ * limiting DMA requests, false otherwise.  The current available count read
+ * from vfio is returned in avail.
+ */
+bool s390_pci_update_dma_avail(int fd, unsigned int *avail)
+{
+    g_autofree struct vfio_iommu_type1_info *info;
+    uint32_t argsz;
+
+    assert(avail);
+
+    argsz = sizeof(struct vfio_iommu_type1_info);
+    info = g_malloc0(argsz);
+
+    /*
+     * If the specified argsz is not large enough to contain all capabilities
+     * it will be updated upon return from the ioctl.  Retry until we have
+     * a big enough buffer to hold the entire capability chain.
+     */
+retry:
+    info->argsz = argsz;
+
+    if (ioctl(fd, VFIO_IOMMU_GET_INFO, info)) {
+        return false;
+    }
+
+    if (info->argsz > argsz) {
+        argsz = info->argsz;
+        info = g_realloc(info, argsz);
+        goto retry;
+    }
+
+    /* If the capability exists, update with the current value */
+    return vfio_get_info_dma_avail(info, avail);
+}
+
diff --git a/include/hw/s390x/s390-pci-vfio.h b/include/hw/s390x/s390-pci-vfio.h
new file mode 100644
index 0000000..2a5a261
--- /dev/null
+++ b/include/hw/s390x/s390-pci-vfio.h
@@ -0,0 +1,17 @@
+/*
+ * s390 vfio-pci interfaces
+ *
+ * Copyright 2020 IBM Corp.
+ * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or (at
+ * your option) any later version. See the COPYING file in the top-level
+ * directory.
+ */
+
+#ifndef HW_S390_PCI_VFIO_H
+#define HW_S390_PCI_VFIO_H
+
+bool s390_pci_update_dma_avail(int fd, unsigned int *avail);
+
+#endif
-- 
1.8.3.1

