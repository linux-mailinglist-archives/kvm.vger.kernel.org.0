Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F214F1BA1
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380642AbiDDVVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379656AbiDDRqU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:46:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D76613EBA;
        Mon,  4 Apr 2022 10:44:24 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 234EwA6F018684;
        Mon, 4 Apr 2022 17:44:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=p9n3cCVIWRebwGgLHVPBdH2sQpucpAX4L74C1vYCuaw=;
 b=s/7U0EQ2rRVK1at+8mQ9I25dKf/MjCHFLk0JI2b7in3g6mOS5FfUYyGSzuzUbEjkOaVU
 psXYLo3MGpWDzG9nmzln1nWeygrl/0PGf9bY+EI8F7NOf77jxLzXPCVxd9n49yyigrg2
 L7+UJ7jnfzbNtuZufu6V4kpQCnD7pKXfjFhdX75lRGHvL1zVDz/V1AV7cr0jampA1800
 L+tJXRjfSEGeVKOvtSqN+7RHfKyJdnXU/h5xV4wzrsI6g5oS8OAccR9IEHUreAu6uBF7
 MW86ob+z1FYutqwgYqi9kwCTD8LWlRSBiE41JaNPuEsT1ff2WSUL21fdxnFkP2hLJS5O VA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f80hxj3fq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:22 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 234HGHSR004807;
        Mon, 4 Apr 2022 17:44:21 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f80hxj3f8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:21 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 234Hh2SI002353;
        Mon, 4 Apr 2022 17:44:21 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03wdc.us.ibm.com with ESMTP id 3f6e48s68m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Apr 2022 17:44:21 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 234HiKjF21823762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Apr 2022 17:44:20 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 077B313605E;
        Mon,  4 Apr 2022 17:44:20 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0940D136051;
        Mon,  4 Apr 2022 17:44:18 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.125])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon,  4 Apr 2022 17:44:17 +0000 (GMT)
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
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v5 10/21] KVM: s390: pci: add basic kvm_zdev structure
Date:   Mon,  4 Apr 2022 13:43:38 -0400
Message-Id: <20220404174349.58530-11-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220404174349.58530-1-mjrosato@linux.ibm.com>
References: <20220404174349.58530-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bHTm7p5UsCgtrZK42O4aYO1JuSkOKcXK
X-Proofpoint-ORIG-GUID: CNPTI4rOHMrYxkK3NAo-wbFko41B6gG5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-04_06,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 mlxlogscore=928 bulkscore=0 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 clxscore=1015 malwarescore=0 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204040099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This structure will be used to carry kvm passthrough information related to
zPCI devices.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h |  3 +++
 arch/s390/kvm/Makefile      |  1 +
 arch/s390/kvm/pci.c         | 38 +++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h         | 21 ++++++++++++++++++++
 4 files changed, 63 insertions(+)
 create mode 100644 arch/s390/kvm/pci.c
 create mode 100644 arch/s390/kvm/pci.h

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 4c5b8fbc2079..9eb20cebaa18 100644
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
index 26f4a74e5ce4..00cf6853d93f 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -10,4 +10,5 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
 
+kvm-$(CONFIG_PCI) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
new file mode 100644
index 000000000000..213be236c05a
--- /dev/null
+++ b/arch/s390/kvm/pci.c
@@ -0,0 +1,38 @@
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

