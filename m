Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7626E46C601
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234430AbhLGVI1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:08:27 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25410 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232444AbhLGVI0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:08:26 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JfPoC004346;
        Tue, 7 Dec 2021 21:04:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=eqqX3XaxQzg6Lr6Q5zfXaA/6dXNPla//zmUONnWqo2M=;
 b=oobZHFmx5tMDV0Ca2Y8k9Eb+rwFh9H/FY8TcTLbemyhqyXDW/iPPX2MFRZWQ6T6YdaMB
 YQnY7YLzZk1Iahcc/8H6qLbFxLKO4Us86hBfQPE6engn0bND/o5nXfxTc0muOroLi6+P
 yDDSk//bVa+cc81AThmmZJbkUKT3JNpuMr5vQhu/I513RqRa1mMGYvhCQBPb88tRZkOx
 HlwXuDwfL8/xm2ySKhfTwTvSIiwkz88l+Wyq7z1rhvo9n2Fax4PKOc7xywZv4p2emACI
 vVnBkQ018S4F8KERbo2EOZsvved2VgXxmWuKbrdWTse4yUkNak4cNcqnuIqj076vpjxk tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctd9kj8yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:49 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7L49tg018689;
        Tue, 7 Dec 2021 21:04:48 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctd9kj8ym-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:48 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kx9DN004018;
        Tue, 7 Dec 2021 21:04:47 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma02dal.us.ibm.com with ESMTP id 3cqyyb38fa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:47 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L4kqB44761464
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:04:46 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2EDD3AE068;
        Tue,  7 Dec 2021 21:04:46 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 979DFAE066;
        Tue,  7 Dec 2021 21:04:42 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:04:42 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 03/12] s390x/pci: add supported DT information to clp response
Date:   Tue,  7 Dec 2021 16:04:16 -0500
Message-Id: <20211207210425.150923-4-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207210425.150923-1-mjrosato@linux.ibm.com>
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZkhpstbBoXRxtK9aYgX9TwJURq2aJoUv
X-Proofpoint-ORIG-GUID: S49Fl1Si-f_oW2iWUajgX_61sELsijR0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The DTSM is a mask that specifies which I/O Address Translation designation
types are supported.  Today QEMU only supports DT=1.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 hw/s390x/s390-pci-bus.c         | 1 +
 hw/s390x/s390-pci-inst.c        | 1 +
 hw/s390x/s390-pci-vfio.c        | 1 +
 include/hw/s390x/s390-pci-bus.h | 1 +
 include/hw/s390x/s390-pci-clp.h | 3 ++-
 5 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/hw/s390x/s390-pci-bus.c b/hw/s390x/s390-pci-bus.c
index 1b51a72838..01b58ebc70 100644
--- a/hw/s390x/s390-pci-bus.c
+++ b/hw/s390x/s390-pci-bus.c
@@ -782,6 +782,7 @@ static void s390_pci_init_default_group(void)
     resgrp->i = 128;
     resgrp->maxstbl = 128;
     resgrp->version = 0;
+    resgrp->dtsm = ZPCI_DTSM;
 }
 
 static void set_pbdev_info(S390PCIBusDevice *pbdev)
diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
index 11b7f6bfa1..0cef7fbace 100644
--- a/hw/s390x/s390-pci-inst.c
+++ b/hw/s390x/s390-pci-inst.c
@@ -329,6 +329,7 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
         stw_p(&resgrp->i, group->zpci_group.i);
         stw_p(&resgrp->maxstbl, group->zpci_group.maxstbl);
         resgrp->version = group->zpci_group.version;
+        resgrp->dtsm = group->zpci_group.dtsm;
         stw_p(&resgrp->hdr.rsp, CLP_RC_OK);
         break;
     }
diff --git a/hw/s390x/s390-pci-vfio.c b/hw/s390x/s390-pci-vfio.c
index 2a153fa8c9..6f80a47e29 100644
--- a/hw/s390x/s390-pci-vfio.c
+++ b/hw/s390x/s390-pci-vfio.c
@@ -160,6 +160,7 @@ static void s390_pci_read_group(S390PCIBusDevice *pbdev,
         resgrp->i = cap->noi;
         resgrp->maxstbl = cap->maxstbl;
         resgrp->version = cap->version;
+        resgrp->dtsm = ZPCI_DTSM;
     }
 }
 
diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
index 2727e7bdef..da3cde2bb4 100644
--- a/include/hw/s390x/s390-pci-bus.h
+++ b/include/hw/s390x/s390-pci-bus.h
@@ -37,6 +37,7 @@
 #define ZPCI_MAX_UID 0xffff
 #define UID_UNDEFINED 0
 #define UID_CHECKING_ENABLED 0x01
+#define ZPCI_DTSM 0x40
 
 OBJECT_DECLARE_SIMPLE_TYPE(S390pciState, S390_PCI_HOST_BRIDGE)
 OBJECT_DECLARE_SIMPLE_TYPE(S390PCIBus, S390_PCI_BUS)
diff --git a/include/hw/s390x/s390-pci-clp.h b/include/hw/s390x/s390-pci-clp.h
index 96b8e3f133..cc8c8662b8 100644
--- a/include/hw/s390x/s390-pci-clp.h
+++ b/include/hw/s390x/s390-pci-clp.h
@@ -163,7 +163,8 @@ typedef struct ClpRspQueryPciGrp {
     uint8_t fr;
     uint16_t maxstbl;
     uint16_t mui;
-    uint64_t reserved3;
+    uint8_t dtsm;
+    uint8_t reserved3[7];
     uint64_t dasm; /* dma address space mask */
     uint64_t msia; /* MSI address */
     uint64_t reserved4;
-- 
2.27.0

