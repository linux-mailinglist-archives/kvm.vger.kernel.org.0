Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C07953EFD0
	for <lists+kvm@lfdr.de>; Mon,  6 Jun 2022 22:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbiFFUgo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 16:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234069AbiFFUgW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 16:36:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6640FC1EEB;
        Mon,  6 Jun 2022 13:34:50 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 256KTwsi027943;
        Mon, 6 Jun 2022 20:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=IxKcJKAmaZ/NECSTJ88wPzErTNJlIjAwNzgdtJlm9ZQ=;
 b=XjwerRdsdYUAKvdTfKWGeN0iuUcS3HcdRIPah5f5noiIPB4G61nvGV7Y4Zw1zlYHvoX1
 mOm1/TcYFCXxrwwAbdZk6LdP75n2SbID/oMz4xB0ltJlZaZedQxetnSKtvoCGjG6a1fY
 d4Tu2Qw/5ajZBO1xt6l1GutDwlbyKD+CFy/ASI5tJJXoFaqdRQssjHk9mabniCnl8MUs
 mJFQasE3W6JsscZvaYcS0xSt8v8AoZulgXGrGjbL7d0wjan1ivRCSOKYX1+uxAqY6Yx6
 KyBCqRDllPUYH4XLTbW/2vaseimRqgnY2SED5EnGQQ75KezBCIvTt4FOJvkEdbFyAeiv zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghpxpj0pu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:34:48 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 256KU9EV029486;
        Mon, 6 Jun 2022 20:34:47 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ghpxpj0pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:34:47 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 256KKxWC016379;
        Mon, 6 Jun 2022 20:34:46 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma04dal.us.ibm.com with ESMTP id 3gfy19utcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Jun 2022 20:34:46 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 256KYjwi34472224
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Jun 2022 20:34:45 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 82A7A28059;
        Mon,  6 Jun 2022 20:34:45 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60FBD28058;
        Mon,  6 Jun 2022 20:34:41 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.20.188])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon,  6 Jun 2022 20:34:41 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, corbet@lwn.net,
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v9 11/21] KVM: s390: pci: add basic kvm_zdev structure
Date:   Mon,  6 Jun 2022 16:33:15 -0400
Message-Id: <20220606203325.110625-12-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220606203325.110625-1-mjrosato@linux.ibm.com>
References: <20220606203325.110625-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mbGFsHliLIiVdlpMEzqZ5WewbBT6HYYI
X-Proofpoint-GUID: 0N652mq6ky0YUSHdtFk9Q-rC9Pyj1FLZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-06_06,2022-06-03_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=744 spamscore=0
 bulkscore=0 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 malwarescore=0
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

This structure will be used to carry kvm passthrough information related to
zPCI devices.

Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Pierre Morel <pmorel@linux.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h |  3 +++
 arch/s390/kvm/Makefile      |  1 +
 arch/s390/kvm/pci.c         | 36 ++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h         | 21 +++++++++++++++++++++
 4 files changed, 61 insertions(+)
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 4c5b8fbc2079..50f1851edfbe 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -97,6 +97,7 @@ struct zpci_bar_struct {
 };
 
 struct s390_domain;
+struct kvm_zdev;
 
 #define ZPCI_FUNCTIONS_PER_BUS 256
 struct zpci_bus {
@@ -189,7 +190,9 @@ struct zpci_dev {
 
 	struct dentry	*debugfs_dev;
 
+	/* IOMMU and passthrough */
 	struct s390_domain *s390_domain; /* s390 IOMMU domain data */
+	struct kvm_zdev *kzdev;
 };
 
 static inline bool zdev_enabled(struct zpci_dev *zdev)
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 26f4a74e5ce4..02217fb4ae10 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -10,4 +10,5 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
 
+kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
new file mode 100644
index 000000000000..e27191ea27c4
--- /dev/null
+++ b/arch/s390/kvm/pci.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * s390 kvm PCI passthrough support
+ *
+ * Copyright IBM Corp. 2022
+ *
+ *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/pci.h>
+#include "pci.h"
+
+static int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
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
+
+static void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
+{
+	struct kvm_zdev *kzdev;
+
+	kzdev = zdev->kzdev;
+	WARN_ON(kzdev->zdev != zdev);
+	zdev->kzdev = NULL;
+	kfree(kzdev);
+}
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
new file mode 100644
index 000000000000..ce93978e8913
--- /dev/null
+++ b/arch/s390/kvm/pci.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * s390 kvm PCI passthrough support
+ *
+ * Copyright IBM Corp. 2022
+ *
+ *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
+#ifndef __KVM_S390_PCI_H
+#define __KVM_S390_PCI_H
+
+#include <linux/kvm_host.h>
+#include <linux/pci.h>
+
+struct kvm_zdev {
+	struct zpci_dev *zdev;
+	struct kvm *kvm;
+};
+
+#endif /* __KVM_S390_PCI_H */
-- 
2.27.0

