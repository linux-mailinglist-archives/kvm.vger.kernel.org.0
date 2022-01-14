Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D2F48F139
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244432AbiANUcl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:41 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:16566 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244495AbiANUcX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:23 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EJuhHn001298;
        Fri, 14 Jan 2022 20:32:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LWd+InoElyMFMJaAwV1fOxBtUMOue8oQyK7vapoO4Uw=;
 b=XGmEQS8lC5t9U8h2wapG4lYD65IDzXTk5n44BbZmk9DBIn42ZAfmhxoYlqN3In+zzzvq
 vNS26zSgexIHi64B5R0JJX7ZYbn3k1Jhb4hnaddwjBuKFzU8AwKkv26bLAo3OeOvBwQW
 DEEqkEvIJXY/byb3ed5T2NbGBBtYHK3mv/9u50aDqaViHKnowxAojpbaZ/D9lIjonFOF
 4I4R3LtgjVJL4nsaNvIRBL85kUfnn6YBeTMjhByt/gwLaGQWDC7Pj4AVKtR54FcLQBR2
 rOuudTtqSO1sVKhyjURHxSBDKRjjUYF6vOemLgS9d7qJ1xx7+MLnx0yp4QegCYD6OAD6 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfsd8m24-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:23 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKGXWa021566;
        Fri, 14 Jan 2022 20:32:22 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfsd8m1m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:22 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLrMQ027851;
        Fri, 14 Jan 2022 20:32:21 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma05wdc.us.ibm.com with ESMTP id 3df28cyfec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:21 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWIVg22938052
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:18 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C504C6066;
        Fri, 14 Jan 2022 20:32:18 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7778C605D;
        Fri, 14 Jan 2022 20:32:16 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:16 +0000 (GMT)
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
Subject: [PATCH v2 14/30] KVM: s390: pci: add basic kvm_zdev structure
Date:   Fri, 14 Jan 2022 15:31:29 -0500
Message-Id: <20220114203145.242984-15-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 62Vq9Nk3F01GeQGh_8HG0jzEw6siTLFp
X-Proofpoint-GUID: cOQc7guBDU00HQaBLbMIcOams4PpvmlL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 phishscore=0 priorityscore=1501 impostorscore=0 adultscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 mlxlogscore=976 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This structure will be used to carry kvm passthrough information related to
zPCI devices.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h | 29 +++++++++++++++++++++
 arch/s390/include/asm/pci.h     |  3 +++
 arch/s390/kvm/Makefile          |  2 +-
 arch/s390/kvm/pci.c             | 46 +++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 1 deletion(-)
 create mode 100644 arch/s390/include/asm/kvm_pci.h
 create mode 100644 arch/s390/kvm/pci.c

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
new file mode 100644
index 000000000000..aafee2976929
--- /dev/null
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * KVM PCI Passthrough for virtual machines on s390
+ *
+ * Copyright IBM Corp. 2021
+ *
+ *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
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
+void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
+
+#endif /* ASM_KVM_PCI_H */
diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index f3cd2da8128c..9b6c657d8d31 100644
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
index b3aaadc60ead..a26f4fe7b680 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -11,5 +11,5 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-objs := $(common-objs) kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-objs += diag.o gaccess.o guestdbg.o vsie.o pv.o
-
+kvm-$(CONFIG_PCI) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
new file mode 100644
index 000000000000..1c33bc7bf2bd
--- /dev/null
+++ b/arch/s390/kvm/pci.c
@@ -0,0 +1,46 @@
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
+
+void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm)
+{
+	struct kvm_zdev *kzdev = zdev->kzdev;
+
+	kzdev->kvm = kvm;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
-- 
2.27.0

