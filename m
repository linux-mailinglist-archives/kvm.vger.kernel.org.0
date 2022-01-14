Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8B748F148
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244732AbiANUcz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:55 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29962 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244603AbiANUcj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:39 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIQX8T014090;
        Fri, 14 Jan 2022 20:32:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=qp9vVYG5GckGz0KgYpMV5xbXAc7dfA7b91vH4eOYxz0=;
 b=Z7AAgfkiZ+Auhgcd5ibgCfHXX/GHB8Q8y7/mdoBqEBgKoJe0X20XuSU5k7hMLDVOO24v
 /P6p8ZkxfQzX+aA5CTA1GZalTSWe8NC/MKgi6x0A516AqFi8pFKWHQNeYr9CsfpJooQh
 RAARl29sE/RnTuuJXNbsqrL1rkhit3epx4MFJhoVENMZicbbyefMGlf8bv2BNliXTOr7
 lbS76pjvMqOQjELlU7UyLfxSQYtu5gIMYYtlnvEgx9z8hyMdDUWbyx+HzoQ3G4ZrL8hu
 NMfXInQ05cbXBXZaIT0lkjsmYIhI7cAye6giII/QdUZAMyUt3jxeQ36kAkvq3Ed0EDCN Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a95b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:38 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKQgGG004917;
        Fri, 14 Jan 2022 20:32:38 GMT
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkef5a94y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:38 +0000
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMaJq018462;
        Fri, 14 Jan 2022 20:32:37 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma02wdc.us.ibm.com with ESMTP id 3df28cqdps-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:37 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWZwC21496132
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:35 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB9A2C6070;
        Fri, 14 Jan 2022 20:32:35 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 17426C605F;
        Fri, 14 Jan 2022 20:32:34 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:33 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 23/30] vfio/pci: re-introduce CONFIG_VFIO_PCI_ZDEV
Date:   Fri, 14 Jan 2022 15:31:38 -0500
Message-Id: <20220114203145.242984-24-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fC2CuRruIdlL7xtqv_iFKO-NuI1SxE0k
X-Proofpoint-ORIG-GUID: 65DphuXZ7K0kpAB97BXpj5s8G3_zhXJ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 malwarescore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This was previously removed as unnecessary; while that was true, subsequent
changes will make KVM an additional required component for vfio-pci-zdev.
Let's re-introduce CONFIG_VFIO_PCI_ZDEV as now there is actually a reason
to say 'n' for it (when not planning to CONFIG_KVM).

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/pci/Kconfig      | 11 +++++++++++
 drivers/vfio/pci/Makefile     |  2 +-
 include/linux/vfio_pci_core.h |  2 +-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 860424ccda1b..fedd1d4cb592 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -42,5 +42,16 @@ config VFIO_PCI_IGD
 	  and LPC bridge config space.
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
+
+config VFIO_PCI_ZDEV
+	bool "VFIO PCI extensions for s390x KVM passthrough"
+	depends on S390 && KVM
+	default y
+	help
+	  Support s390x-specific extensions to enable support for enhancements
+	  to KVM passthrough capabilities, such as interpretive execution of
+	  zPCI instructions.
+
+	  To enable s390x KVM vfio-pci extensions, say Y.
 endif
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 349d68d242b4..01b1f83d83d7 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 vfio-pci-core-y := vfio_pci_core.o vfio_pci_intrs.o vfio_pci_rdwr.o vfio_pci_config.o
-vfio-pci-core-$(CONFIG_S390) += vfio_pci_zdev.o
+vfio-pci-core-$(CONFIG_VFIO_PCI_ZDEV) += vfio_pci_zdev.o
 obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 
 vfio-pci-y := vfio_pci.o
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..5e2bca3b89db 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -195,7 +195,7 @@ static inline int vfio_pci_igd_init(struct vfio_pci_core_device *vdev)
 }
 #endif
 
-#ifdef CONFIG_S390
+#ifdef CONFIG_VFIO_PCI_ZDEV
 extern int vfio_pci_info_zdev_add_caps(struct vfio_pci_core_device *vdev,
 				       struct vfio_info_cap *caps);
 #else
-- 
2.27.0

