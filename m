Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF6B74D8D05
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244492AbiCNTtp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244539AbiCNTtg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:49:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C6D53ED3D;
        Mon, 14 Mar 2022 12:48:09 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlVxk009409;
        Mon, 14 Mar 2022 19:48:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kCDw090+mnOqOV0AKY4gRGgkIfsKtTXvrNrv0uShJbo=;
 b=OLigEpHp/hjNJK6xcj8IZyHuD7CzWk3acRRkVgezurwScDYxNgmGHKLx9ji2lcf7vLSz
 ohxTRDxUZBPpn0HfGt7tdnlrrk6yr448BZznm8i2x+mCiCHdSUEATBEKKJdyWFBR78Mv
 4iialU+1My1sC8c3hvIuFvHSdVGAGM+YAXgpFTipZ0VKl6NrNq74+mBSr/t38V1CITdJ
 9GNwV3stPc5l4pDLa4iL7kJowLY2NDh1KAznYVVDd52Zpl2JyItZRviVF2LsFZMPcaEj
 lk7R2NAEDmugxx405XrDDJoZLl3NvVlssEuBMApNPeluqbdJHjdhqrRFXO4Dgag2RPyK Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6d2rffa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:00 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJm0XZ011600;
        Mon, 14 Mar 2022 19:48:00 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6d2rff2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:48:00 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlB1B005387;
        Mon, 14 Mar 2022 19:47:59 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 3erk59897u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:47:59 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJlw5q4260736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:47:58 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44889112067;
        Mon, 14 Mar 2022 19:47:58 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FCFC112064;
        Mon, 14 Mar 2022 19:47:50 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:47:50 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com, farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, vneethv@linux.ibm.com,
        oberpar@linux.ibm.com, freude@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, joro@8bytes.org, will@kernel.org,
        pbonzini@redhat.com, corbet@lwn.net, jgg@nvidia.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-doc@vger.kernel.org
Subject: [PATCH v4 17/32] KVM: s390: pci: add basic kvm_zdev structure
Date:   Mon, 14 Mar 2022 15:44:36 -0400
Message-Id: <20220314194451.58266-18-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1Mn35uRJ3i3xLvAUTPndzA7keYgPfFm3
X-Proofpoint-ORIG-GUID: RX_8gz8j4AKbKw4Q2TOqJ8KI5KIsjATO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=777 clxscore=1015 spamscore=0 impostorscore=0 phishscore=0
 mlxscore=0 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203140116
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
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
 arch/s390/include/asm/kvm_pci.h | 27 +++++++++++++++++++++++
 arch/s390/include/asm/pci.h     |  3 +++
 arch/s390/kvm/Makefile          |  1 +
 arch/s390/kvm/pci.c             | 38 +++++++++++++++++++++++++++++++++
 4 files changed, 69 insertions(+)
 create mode 100644 arch/s390/include/asm/kvm_pci.h
 create mode 100644 arch/s390/kvm/pci.c

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
new file mode 100644
index 000000000000..ae8669105f72
--- /dev/null
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * KVM PCI Passthrough for virtual machines on s390
+ *
+ * Copyright IBM Corp. 2022
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
index 000000000000..612faf87126d
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

