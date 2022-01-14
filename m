Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E55B48F13C
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244495AbiANUcm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:42 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244497AbiANUcY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:24 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIw97T030085;
        Fri, 14 Jan 2022 20:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=G7P5R/MZJRd9JQ2mv0u23rDFCdKjdayyOx+7WQ9QY9M=;
 b=GE2zIleg5O3uejS6WZpBgFEfkwxoeDmKb9b6igcFGOS8oQcKatYN2jIqECwJ3DUpgKkQ
 VVtLm8ZuZDMoHWk+mUUpM77KOyk1QalmZ0r/DN61HrDebOeOSey4u1I5px8Cwtdr/BDT
 R3bozvoRNhQEy3fB8gxmXLOsi7paur4t6v7McJdfmrLsM7WIauUNvzqfohBIYdgTLzal
 wAvoV9hFcYBaaS3yR4cmHkLwwUHJgNQHlaLbOdIiaurZt+ALD1wV0UXz0UGZdo2S4PE0
 +6SGoEIiqVqVf2Fenge6nJf0NtQAOwgeARccv+FbDG/4ms71kzk8Sk+4a7BfPn0u4yBq Mg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkewyhqud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:23 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKTQB3020277;
        Fri, 14 Jan 2022 20:32:23 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkewyhqu4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:23 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMKcC025084;
        Fri, 14 Jan 2022 20:32:22 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 3df28d695p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:22 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWKYW30146894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:20 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A2C8C6070;
        Fri, 14 Jan 2022 20:32:20 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BE7CEC6069;
        Fri, 14 Jan 2022 20:32:18 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:18 +0000 (GMT)
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
Subject: [PATCH v2 15/30] KVM: s390: pci: do initial setup for AEN interpretation
Date:   Fri, 14 Jan 2022 15:31:30 -0500
Message-Id: <20220114203145.242984-16-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0JanFnHqvwFqi388IeNJxO3wCWUgHd7W
X-Proofpoint-GUID: 5qLcri7SDxy-zvQ8sEfXY4G0fjWnD8Z8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Initial setup for Adapter Event Notification Interpretation for zPCI
passthrough devices.  Specifically, allocate a structure for forwarding of
adapter events and pass the address of this structure to firmware.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/pci.h      |   4 +
 arch/s390/include/asm/pci_insn.h |  12 +++
 arch/s390/kvm/interrupt.c        |  14 +++
 arch/s390/kvm/kvm-s390.c         |   9 ++
 arch/s390/kvm/pci.c              | 144 +++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h              |  42 +++++++++
 arch/s390/pci/pci.c              |   6 ++
 7 files changed, 231 insertions(+)
 create mode 100644 arch/s390/kvm/pci.h

diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
index 9b6c657d8d31..9ff8dc19975e 100644
--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -9,6 +9,7 @@
 #include <asm-generic/pci.h>
 #include <asm/pci_clp.h>
 #include <asm/pci_debug.h>
+#include <asm/pci_insn.h>
 #include <asm/sclp.h>
 
 #define PCIBIOS_MIN_IO		0x1000
@@ -204,6 +205,9 @@ extern const struct attribute_group *zpci_attr_groups[];
 extern unsigned int s390_pci_force_floating __initdata;
 extern unsigned int s390_pci_no_rid;
 
+extern union zpci_sic_iib *zpci_aipb;
+extern struct airq_iv *zpci_aif_sbv;
+
 /* -----------------------------------------------------------------------------
   Prototypes
 ----------------------------------------------------------------------------- */
diff --git a/arch/s390/include/asm/pci_insn.h b/arch/s390/include/asm/pci_insn.h
index 32759c407b8f..ad9000295c82 100644
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
index f9b872e358c6..a591b8cd662f 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -32,6 +32,7 @@
 #include "kvm-s390.h"
 #include "gaccess.h"
 #include "trace-s390.h"
+#include "pci.h"
 
 #define PFAULT_INIT 0x0600
 #define PFAULT_DONE 0x0680
@@ -3278,6 +3279,11 @@ void kvm_s390_gib_destroy(void)
 {
 	if (!gib)
 		return;
+	if (IS_ENABLED(CONFIG_PCI) && sclp.has_aeni && aift) {
+		mutex_lock(&aift->lock);
+		kvm_s390_pci_aen_exit();
+		mutex_unlock(&aift->lock);
+	}
 	chsc_sgib(0);
 	unregister_adapter_interrupt(&gib_alert_irq);
 	free_page((unsigned long)gib);
@@ -3315,6 +3321,14 @@ int kvm_s390_gib_init(u8 nisc)
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
index 14a18ba5ff2c..01dc3f6883d0 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -48,6 +48,7 @@
 #include <asm/fpu/api.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
+#include "pci.h"
 
 #define CREATE_TRACE_POINTS
 #include "trace.h"
@@ -503,6 +504,14 @@ int kvm_arch_init(void *opaque)
 		goto out;
 	}
 
+	if (IS_ENABLED(CONFIG_PCI)) {
+		rc = kvm_s390_pci_init();
+		if (rc) {
+			pr_err("Unable to allocate AIFT for PCI\n");
+			goto out;
+		}
+	}
+
 	rc = kvm_s390_gib_init(GAL_ISC);
 	if (rc)
 		goto out;
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 1c33bc7bf2bd..dae853da6df1 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -10,6 +10,138 @@
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
 #include <asm/kvm_pci.h>
+#include <asm/pci.h>
+#include <asm/pci_insn.h>
+#include "pci.h"
+
+struct zpci_aift *aift;
+
+static inline int __set_irq_noiib(u16 ctl, u8 isc)
+{
+	union zpci_sic_iib iib = {{0}};
+
+	return zpci_set_irq_ctrl(ctl, isc, &iib);
+}
+
+/* Caller must hold the aift lock before calling this function */
+void kvm_s390_pci_aen_exit(void)
+{
+	unsigned long flags;
+	struct kvm_zdev **gait_kzdev;
+
+	/*
+	 * Contents of the aipb remain registered for the life of the host
+	 * kernel, the information preserved in zpci_aipb and zpci_aif_sbv
+	 * in case we insert the KVM module again later.  Clear the AIFT
+	 * information and free anything not registered with underlying
+	 * firmware.
+	 */
+	spin_lock_irqsave(&aift->gait_lock, flags);
+	gait_kzdev = aift->kzdev;
+	aift->gait = 0;
+	aift->sbv = 0;
+	aift->kzdev = 0;
+	spin_unlock_irqrestore(&aift->gait_lock, flags);
+
+	kfree(gait_kzdev);
+}
+
+int kvm_s390_pci_aen_init(u8 nisc)
+{
+	struct page *page;
+	int rc = 0, size;
+	bool first = false;
+
+	/* If already enabled for AEN, bail out now */
+	if (aift->gait || aift->sbv)
+		return -EPERM;
+
+	mutex_lock(&aift->lock);
+	aift->kzdev = kcalloc(ZPCI_NR_DEVICES, sizeof(struct kvm_zdev),
+			      GFP_KERNEL);
+	if (!aift->kzdev) {
+		rc = -ENOMEM;
+		goto unlock;
+	}
+
+	if (!zpci_aipb) {
+		zpci_aipb = kzalloc(sizeof(union zpci_sic_iib), GFP_KERNEL);
+		if (!zpci_aipb) {
+			rc = -ENOMEM;
+			goto free_zdev;
+		}
+		first = true;
+		aift->sbv = airq_iv_create(ZPCI_NR_DEVICES, AIRQ_IV_ALLOC, 0);
+		if (!aift->sbv) {
+			rc = -ENOMEM;
+			goto free_aipb;
+		}
+		zpci_aif_sbv = aift->sbv;
+		size = get_order(PAGE_ALIGN(ZPCI_NR_DEVICES *
+					    sizeof(struct zpci_gaite)));
+		page = alloc_pages(GFP_KERNEL | __GFP_ZERO, size);
+		if (!page) {
+			rc = -ENOMEM;
+			goto free_sbv;
+		}
+		aift->gait = (struct zpci_gaite *)page_to_phys(page);
+
+		zpci_aipb->aipb.faisb = virt_to_phys(aift->sbv->vector);
+		zpci_aipb->aipb.gait = virt_to_phys(aift->gait);
+		zpci_aipb->aipb.afi = nisc;
+		zpci_aipb->aipb.faal = ZPCI_NR_DEVICES;
+
+		/* Setup Adapter Event Notification Interpretation */
+		if (zpci_set_irq_ctrl(SIC_SET_AENI_CONTROLS, 0, zpci_aipb)) {
+			rc = -EIO;
+			goto free_gait;
+		}
+	} else {
+		/*
+		 * AEN registration can only happen once per system boot.  If
+		 * an aipb already exists then AEN was already registered and
+		 * we can re-use the aipb contents.  This can only happen if
+		 * the KVM module was removed and re-inserted.
+		 */
+		if (zpci_aipb->aipb.afi != nisc ||
+		    zpci_aipb->aipb.faal != ZPCI_NR_DEVICES) {
+			rc = -EINVAL;
+			goto free_zdev;
+		}
+		aift->sbv = zpci_aif_sbv;
+		aift->gait = (struct zpci_gaite *)zpci_aipb->aipb.gait;
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
+	free_pages((unsigned long)aift->gait, size);
+free_sbv:
+	if (first) {
+		/* If AEN setup failed, only free a newly-allocated sbv */
+		airq_iv_release(aift->sbv);
+		zpci_aif_sbv = 0;
+	}
+free_aipb:
+	if (first) {
+		/* If AEN setup failed, only free a newly-allocated aipb */
+		kfree(zpci_aipb);
+		zpci_aipb = 0;
+	}
+free_zdev:
+	kfree(aift->kzdev);
+unlock:
+	mutex_unlock(&aift->lock);
+	return rc;
+}
 
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 {
@@ -44,3 +176,15 @@ void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm)
 	kzdev->kvm = kvm;
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_attach_kvm);
+
+int kvm_s390_pci_init(void)
+{
+	aift = kzalloc(sizeof(struct zpci_aift), GFP_KERNEL);
+	if (!aift)
+		return -ENOMEM;
+
+	spin_lock_init(&aift->gait_lock);
+	mutex_init(&aift->lock);
+
+	return 0;
+}
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
new file mode 100644
index 000000000000..b2000ed7b8c3
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
+	u32 gisa;
+	u8 gisc;
+	u8 count;
+	u8 reserved;
+	u8 aisbo;
+	u64 aisb;
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
+extern struct zpci_aift *aift;
+
+int kvm_s390_pci_aen_init(u8 nisc);
+void kvm_s390_pci_aen_exit(void);
+
+int kvm_s390_pci_init(void);
+
+#endif /* __KVM_S390_PCI_H */
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 1e939b4cf25e..2a19becbc14c 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -61,6 +61,12 @@ DEFINE_STATIC_KEY_FALSE(have_mio);
 
 static struct kmem_cache *zdev_fmb_cache;
 
+/* AEN structures that must be preserved over KVM module re-insertion */
+union zpci_sic_iib *zpci_aipb;
+EXPORT_SYMBOL_GPL(zpci_aipb);
+struct airq_iv *zpci_aif_sbv;
+EXPORT_SYMBOL_GPL(zpci_aif_sbv);
+
 struct zpci_dev *get_zdev_by_fid(u32 fid)
 {
 	struct zpci_dev *tmp, *zdev = NULL;
-- 
2.27.0

