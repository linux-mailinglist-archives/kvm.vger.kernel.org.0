Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6FA4AA1BF
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243984AbiBDVQq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:16:46 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242519AbiBDVQS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:18 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214JT7YM001661;
        Fri, 4 Feb 2022 21:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CZzB9rRtEpapWdmcf1wnwL9Cq8Gl2MEwRRLww4IebgY=;
 b=EYGDvdvWy7D1yxlysaXWODy3WSC0GOYhtvVVg/QOyYK5yz0YY2orob9gBSOH6FrrX7of
 nZb4w+Dj6PixzfsVkql4gKeBFJhvsi5p3J0onakY3+TJQRBLlEEwSO4rh07FgLQ+tEsk
 ojRD65ynZXbvSdHIIPi9N0U/7ZimYm+Rb9aBR9LQLKM/RtHakgim/RDDyvRwl4MhxA6L
 kcJ07ekUfATToVmEkTgxTFjKfFreVbl34wFOyvg83+jQqU2UZcCYVX6yxrns11uUBRIR
 E7VnZoer6iSl8SDVYduasFxrBOU5/7kObHrOItdSOl9qXUQ7meLduYML7sA9bsP0VsWM lQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx3frkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:18 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214KxUOt025295;
        Fri, 4 Feb 2022 21:16:17 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx3frkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:17 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCaPr021810;
        Fri, 4 Feb 2022 21:16:16 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3e0r0k7guy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:16 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGDQc37617922
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:13 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A589136060;
        Fri,  4 Feb 2022 21:16:13 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B9DB3136053;
        Fri,  4 Feb 2022 21:16:11 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:11 +0000 (GMT)
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
Subject: [PATCH v3 15/30] KVM: s390: pci: add basic kvm_zdev structure
Date:   Fri,  4 Feb 2022 16:15:21 -0500
Message-Id: <20220204211536.321475-16-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PzaE6hUkSK6BIFEFrJ90gEwpb4corLdY
X-Proofpoint-GUID: 6C1FNCFQQRVxB0er_EjlFNQZRI8Bs22C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=943 priorityscore=1501 malwarescore=0
 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0 adultscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This structure will be used to carry kvm passthrough information related to
zPCI devices.

Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h | 27 +++++++++++++++++++++++
 arch/s390/include/asm/pci.h     |  3 +++
 arch/s390/kvm/Makefile          |  1 +
 arch/s390/kvm/pci.c             | 38 +++++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+)
 create mode 100644 arch/s390/include/asm/kvm_pci.h
 create mode 100644 arch/s390/kvm/pci.c

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
new file mode 100644
index 000000000000..ef10f9e46e37
--- /dev/null
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * KVM PCI Passthrough for virtual machines on s390
+ *
+ * Copyright IBM Corp. 2021
+ *
+ *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
+#ifndef ASM_KVM_PCI_H
+#define ASM_KVM_PCI_H
+
+#include <linux/types.h>
+#include <linux/kvm_types.h>
+#include <linux/kvm_host.h>
+#include <linux/kvm.h>
+#include <linux/pci.h>
+
+struct kvm_zdev {
+	struct zpci_dev *zdev;
+	struct kvm *kvm;
+};
+
+int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
+void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
+
+#endif /* ASM_KVM_PCI_H */
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index e8a3fd5bc169..4faff673078b 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -97,6 +97,7 @@ struct zpci_bar_struct {
 };
 
 struct s390_domain;
+struct kvm_zdev;
 
 #define ZPCI_FUNCTIONS_PER_BUS 256
 struct zpci_bus {
@@ -190,6 +191,8 @@ struct zpci_dev {
 	struct dentry	*debugfs_dev;
 
 	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
+
+	struct kvm_zdev *kzdev; /* passthrough data */
 };
 
 static inline bool zdev_enabled(struct zpci_dev *zdev)
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 26f4a74e5ce4..b8263a160df8 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -10,4 +10,5 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
 
+kvm-$(CONFIG_VFIO_PCI_ZDEV) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
new file mode 100644
index 000000000000..bc1b7a564e55
--- /dev/null
+++ b/arch/s390/kvm/pci.c
@@ -0,0 +1,38 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * s390 kvm PCI passthrough support
+ *
+ * Copyright IBM Corp. 2021
+ *
+ *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/pci.h>
+#include <asm/kvm_pci.h>
+
+int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
+{
+	struct kvm_zdev *kzdev;
+
+	kzdev = kzalloc(sizeof(struct kvm_zdev), GFP_KERNEL);
+	if (!kzdev)
+		return -ENOMEM;
+
+	kzdev->zdev = zdev;
+	zdev->kzdev = kzdev;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_open);
+
+void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
+{
+	struct kvm_zdev *kzdev;
+
+	kzdev = zdev->kzdev;
+	WARN_ON(kzdev->zdev != zdev);
+	zdev->kzdev = 0;
+	kfree(kzdev);
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
-- 
2.27.0

