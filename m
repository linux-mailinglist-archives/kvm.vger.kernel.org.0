Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7B646C57B
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 21:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240604AbhLGVCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:02:49 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34094 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232495AbhLGVCn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:02:43 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JmE2x008182;
        Tue, 7 Dec 2021 20:59:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=r8W0xDxrPdMI+Sh1+VSsW7lPbtjh6hCtNYGhAm3VQCs=;
 b=kmHpHdbRvpmlBxWfH7dSQFpxmVo/8DmV/aWA5uCdJ/AR3jFlF0TpHpf9pJQhOxAPxj3I
 mZ0RKlFU0EFrT0MkarLLpO9302pbpa1n8oSbvEsiFaxgNHj4F3Na/rkFOCPXO/4oSHLY
 btR5QkjRXb5FyOzDFmAKDEcStuCPKKPkIg+eP3yeniR13pVwLPtb3MOJvFk4iT4PZWyN
 sSFT88xd0Vf9rrKG9c/fK6+ytmpmSSGdS9jUcxdg/X7j+5sS1MbGyMwgwIRFWYLHsqxE
 PuKHglv+Y56WDMwLl6O1be3xTluZAejUQjINRkN+tjtuFaLuzMgKwwMnm8PRfz67JrBy mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cte3c18n5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:12 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KUxoH018463;
        Tue, 7 Dec 2021 20:59:11 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cte3c18mn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:11 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvnOq002353;
        Tue, 7 Dec 2021 20:59:10 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01dal.us.ibm.com with ESMTP id 3cqyyc33j7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:10 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7Kx89r17105206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:59:08 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D05BAE06A;
        Tue,  7 Dec 2021 20:59:08 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31573AE077;
        Tue,  7 Dec 2021 20:59:03 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:59:02 +0000 (GMT)
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
Subject: [PATCH 14/32] KVM: s390: pci: do initial setup for AEN interpretation
Date:   Tue,  7 Dec 2021 15:57:25 -0500
Message-Id: <20211207205743.150299-15-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QTamIGu8WPS9XuBAh9KQovI00yIlFJVi
X-Proofpoint-GUID: -8Y0-En3Pw8CRRVy4wrbIV6vhIBLdSrw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 suspectscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 phishscore=0 bulkscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initial setup for Adapter Event Notification Interpretation for zPCI
passthrough devices.  Specifically, allocate a structure for forwarding of
adapter events and pass the address of this structure to firmware.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci_insn.h |  12 ++++
 arch/s390/kvm/interrupt.c        |  17 +++++
 arch/s390/kvm/kvm-s390.c         |   3 +
 arch/s390/kvm/pci.c              | 113 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  42 ++++++++++++
 5 files changed, 187 insertions(+)
 create mode 100644 arch/s390/kvm/pci.h

diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
index 5331082fa516..e5f57cfe1d45 100644
--- a/arch/s390/include/asm/pci_insn.h
+++ b/arch/s390/include/asm/pci_insn.h
@@ -101,6 +101,7 @@ struct zpci_fib {
 /* Set Interruption Controls Operation Controls  */
 #define	SIC_IRQ_MODE_ALL		0
 #define	SIC_IRQ_MODE_SINGLE		1
+#define	SIC_SET_AENI_CONTROLS		2
 #define	SIC_IRQ_MODE_DIRECT		4
 #define	SIC_IRQ_MODE_D_ALL		16
 #define	SIC_IRQ_MODE_D_SINGLE		17
@@ -127,9 +128,20 @@ struct zpci_cdiib {
 	u64 : 64;
 } __packed __aligned(8);
 
+/* adapter interruption parameters block */
+struct zpci_aipb {
+	u64 faisb;
+	u64 gait;
+	u16 : 13;
+	u16 afi : 3;
+	u32 : 32;
+	u16 faal;
+} __packed __aligned(8);
+
 union zpci_sic_iib {
 	struct zpci_diib diib;
 	struct zpci_cdiib cdiib;
+	struct zpci_aipb aipb;
 };
 
 DECLARE_STATIC_KEY_FALSE(have_mio);
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index f9b872e358c6..4efe0e95a40f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -32,6 +32,7 @@
 #include "kvm-s390.h"
 #include "gaccess.h"
 #include "trace-s390.h"
+#include "pci.h"
 
 #define PFAULT_INIT 0x0600
 #define PFAULT_DONE 0x0680
@@ -3276,8 +3277,16 @@ static struct airq_struct gib_alert_irq = {
 
 void kvm_s390_gib_destroy(void)
 {
+	struct zpci_aift *aift;
+
 	if (!gib)
 		return;
+	aift = kvm_s390_pci_get_aift();
+	if (aift) {
+		mutex_lock(&aift->lock);
+		kvm_s390_pci_aen_exit();
+		mutex_unlock(&aift->lock);
+	}
 	chsc_sgib(0);
 	unregister_adapter_interrupt(&gib_alert_irq);
 	free_page((unsigned long)gib);
@@ -3315,6 +3324,14 @@ int kvm_s390_gib_init(u8 nisc)
 		goto out_unreg_gal;
 	}
 
+	if (IS_ENABLED(CONFIG_PCI) && sclp.has_aeni) {
+		if (kvm_s390_pci_aen_init(nisc)) {
+			pr_err("Initializing AEN for PCI failed\n");
+			rc = -EIO;
+			goto out_unreg_gal;
+		}
+	}
+
 	KVM_EVENT(3, "gib 0x%pK (nisc=%d) initialized", gib, gib->nisc);
 	goto out;
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 14a18ba5ff2c..9cd3c8eb59e8 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -48,6 +48,7 @@
 #include <asm/fpu/api.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
+#include "pci.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -503,6 +504,8 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
+	kvm_s390_pci_init();
+
 	rc = kvm_s390_gib_init(GAL_ISC);
 	if (rc)
 		goto out;
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index ecfc458a5b39..f0e5386ff943 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -10,6 +10,113 @@
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
 #include <asm/kvm_pci.h>
+#include "pci.h"
+
+static struct zpci_aift aift;
+
+static inline int __set_irq_noiib(u16 ctl, u8 isc)
+{
+	union zpci_sic_iib iib = {{0}};
+
+	return zpci_set_irq_ctrl(ctl, isc, &iib);
+}
+
+struct zpci_aift *kvm_s390_pci_get_aift(void)
+{
+	return &aift;
+}
+
+/* Caller must hold the aift lock before calling this function */
+void kvm_s390_pci_aen_exit(void)
+{
+	struct zpci_gaite *gait;
+	unsigned long flags;
+	struct airq_iv *sbv;
+	struct kvm_zdev **gait_kzdev;
+	int size;
+
+	/* Clear the GAIT and forwarding summary vector */
+	__set_irq_noiib(SIC_SET_AENI_CONTROLS, 0);
+
+	spin_lock_irqsave(&aift.gait_lock, flags);
+	gait = aift.gait;
+	sbv = aift.sbv;
+	gait_kzdev = aift.kzdev;
+	aift.gait = 0;
+	aift.sbv = 0;
+	aift.kzdev = 0;
+	spin_unlock_irqrestore(&aift.gait_lock, flags);
+
+	if (sbv)
+		airq_iv_release(sbv);
+	size = get_order(PAGE_ALIGN(ZPCI_NR_DEVICES *
+				    sizeof(struct zpci_gaite)));
+	free_pages((unsigned long)gait, size);
+	kfree(gait_kzdev);
+}
+
+int kvm_s390_pci_aen_init(u8 nisc)
+{
+	union zpci_sic_iib iib = {{0}};
+	struct page *page;
+	int rc = 0, size;
+
+	/* If already enabled for AEN, bail out now */
+	if (aift.gait || aift.sbv)
+		return -EPERM;
+
+	mutex_lock(&aift.lock);
+	aift.kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev),
+			     GFP_KERNEL);
+	if (!aift.kzdev) {
+		rc = -ENOMEM;
+		goto unlock;
+	}
+	aift.sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, 0);
+	if (!aift.sbv) {
+		rc = -ENOMEM;
+		goto free_zdev;
+	}
+	size = get_order(PAGE_ALIGN(ZPCI_NR_DEVICES *
+				    sizeof(struct zpci_gaite)));
+	page = alloc_pages(GFP_KERNEL | __GFP_ZERO, size);
+	if (!page) {
+		rc = -ENOMEM;
+		goto free_sbv;
+	}
+	aift.gait = (struct zpci_gaite *)page_to_phys(page);
+
+	iib.aipb.faisb = (u64)aift.sbv->vector;
+	iib.aipb.gait = (u64)aift.gait;
+	iib.aipb.afi = nisc;
+	iib.aipb.faal = ZPCI_NR_DEVICES;
+
+	/* Setup Adapter Event Notification Interpretation */
+	if (zpci_set_irq_ctrl(SIC_SET_AENI_CONTROLS, 0, &iib)) {
+		rc = -EIO;
+		goto free_gait;
+	}
+
+	/* Enable floating IRQs */
+	if (__set_irq_noiib(SIC_IRQ_MODE_SINGLE, nisc)) {
+		rc = -EIO;
+		kvm_s390_pci_aen_exit();
+	}
+
+	goto unlock;
+
+free_gait:
+	size = get_order(PAGE_ALIGN(ZPCI_NR_DEVICES *
+				    sizeof(struct zpci_gaite)));
+	free_pages((unsigned long)aift.gait, size);
+free_sbv:
+	airq_iv_release(aift.sbv);
+free_zdev:
+	kfree(aift.kzdev);
+unlock:
+	mutex_unlock(&aift.lock);
+	return rc;
+}
 
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 {
@@ -55,3 +162,9 @@ int kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm)
 	return 0;
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
+
+void kvm_s390_pci_init(void)
+{
+	spin_lock_init(&aift.gait_lock);
+	mutex_init(&aift.lock);
+}
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
new file mode 100644
index 000000000000..74b06d39be3b
--- /dev/null
+++ b/arch/s390/kvm/pci.h
@@ -0,0 +1,42 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * s390 kvm PCI passthrough support
+ *
+ * Copyright IBM Corp. 2021
+ *
+ *    Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
+#ifndef __KVM_S390_PCI_H
+#define __KVM_S390_PCI_H
+
+#include <linux/pci.h>
+#include <linux/mutex.h>
+#include <asm/airq.h>
+#include <asm/kvm_pci.h>
+
+struct zpci_gaite {
+	unsigned int gisa;
+	u8 gisc;
+	u8 count;
+	u8 reserved;
+	u8 aisbo;
+	unsigned long aisb;
+};
+
+struct zpci_aift {
+	struct zpci_gaite *gait;
+	struct airq_iv *sbv;
+	struct kvm_zdev **kzdev;
+	spinlock_t gait_lock; /* Protects the gait, used during AEN forward */
+	struct mutex lock; /* Protects the other structures in aift */
+};
+
+struct zpci_aift *kvm_s390_pci_get_aift(void);
+
+int kvm_s390_pci_aen_init(u8 nisc);
+void kvm_s390_pci_aen_exit(void);
+
+void kvm_s390_pci_init(void);
+
+#endif /* __KVM_S390_PCI_H */
-- 
2.27.0

