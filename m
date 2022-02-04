Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00E14AA1EC
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242050AbiBDVRU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:17:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29900 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241622AbiBDVQ3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:29 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214L2tMp015915;
        Fri, 4 Feb 2022 21:16:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bL0tk3lLqAggK8Z5WMLaCYQCJPhbjjqs32HKAtitwj8=;
 b=lN3M6Qz3NAobQqnQdVQ8RCPQyMDjQ7LpBqLXtXF8hkUPQK/XKYqAR4T0gGRFR2zP1PtX
 1uoEjOjUL1EhZnDJ+ubk8zWRG65b1c8Nv2dg6z91D7ed/aErvsOn6PmUjXxk8dQri4GY
 HPvM2iYRP4UVCFJ53J9654IqwoIfR2UjtiY+mDFmdR41ZW9SEuzCgUq2QBttpdlpSa+c
 srmIdTBDJ/QNt3NPvhZ0vtNJjLl48x8yq1eA1PvNYHxCQWChogk40mykime+KtsQt7Id
 VnbCp5tP44zIcLFcMpHL2nYQhkxwGIkFqDeWYr+hH6MhAgTWOip29ZV0uoqeWyjiVvhC 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt5nn0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:29 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LGSbO003916;
        Fri, 4 Feb 2022 21:16:28 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e0rt5nmyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:28 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LDNQn006172;
        Fri, 4 Feb 2022 21:16:28 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 3e0r0yaw2q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:28 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGPjX16384314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:25 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2A905136066;
        Fri,  4 Feb 2022 21:16:25 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 635E9136055;
        Fri,  4 Feb 2022 21:16:23 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:23 +0000 (GMT)
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
Subject: [PATCH v3 21/30] KVM: s390: pci: provide routines for enabling/disabling IOAT assist
Date:   Fri,  4 Feb 2022 16:15:27 -0500
Message-Id: <20220204211536.321475-22-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: UCFS3e6dX3-19Fc3x_CN7KSryGV9VAsA
X-Proofpoint-ORIG-GUID: Pn9dJu1eJlpzO3IfvmUmD6HI3PM5rYrB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into the vfio_pci_zdev ioctl handlers to
respond to requests to enable / disable a device for PCI I/O Address
Translation assistance.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |  15 ++++
 arch/s390/include/asm/pci_dma.h |   2 +
 arch/s390/kvm/pci.c             | 142 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h             |   2 +
 4 files changed, 161 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 377eebcba2d1..370d6ba041fe 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -15,11 +15,21 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/pci.h>
+#include <linux/mutex.h>
 #include <asm/pci_insn.h>
+#include <asm/pci_dma.h>
+
+struct kvm_zdev_ioat {
+	unsigned long *head[ZPCI_TABLE_PAGES];
+	unsigned long **seg;
+	unsigned long ***pt;
+	struct mutex ioat_lock; /* Must be held when modifying head/seg/pt */
+};
 
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
+	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
 };
 
@@ -31,6 +41,11 @@ int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
 			    bool assist);
 int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force);
 
+int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev);
+int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota);
+int kvm_s390_pci_ioat_disable(struct zpci_dev *zdev);
+u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev);
+
 int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
 int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
 int kvm_s390_pci_interp_disable(struct zpci_dev *zdev, bool force);
diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
index 91e63426bdc5..69e616d0712c 100644
--- a/arch/s390/include/asm/pci_dma.h
+++ b/arch/s390/include/asm/pci_dma.h
@@ -50,6 +50,8 @@ enum zpci_ioat_dtype {
 #define ZPCI_TABLE_ALIGN		ZPCI_TABLE_SIZE
 #define ZPCI_TABLE_ENTRY_SIZE		(sizeof(unsigned long))
 #define ZPCI_TABLE_ENTRIES		(ZPCI_TABLE_SIZE / ZPCI_TABLE_ENTRY_SIZE)
+#define ZPCI_TABLE_PAGES		(ZPCI_TABLE_SIZE >> PAGE_SHIFT)
+#define ZPCI_TABLE_ENTRIES_PAGES	(ZPCI_TABLE_ENTRIES * ZPCI_TABLE_PAGES)
 
 #define ZPCI_TABLE_BITS			11
 #define ZPCI_PT_BITS			8
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 8e9044a7bce7..fa9d6ac1755b 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -13,12 +13,15 @@
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
 #include <asm/pci_io.h>
+#include <asm/pci_dma.h>
 #include <asm/sclp.h>
 #include "pci.h"
 #include "kvm-s390.h"
 
 struct zpci_aift *aift;
 
+#define shadow_ioat_init zdev->kzdev->ioat.head[0]
+
 static inline int __set_irq_noiib(u16 ctl, u8 isc)
 {
 	union zpci_sic_iib iib = {{0}};
@@ -366,6 +369,138 @@ int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
 
+int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev)
+{
+	/*
+	 * Using the IOAT assist is only valid for a device with a KVM guest
+	 * registered
+	 */
+	if (!zdev->kzdev->kvm)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_ioat_probe);
+
+int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota)
+{
+	gpa_t gpa = (gpa_t)(iota & ZPCI_RTE_ADDR_MASK);
+	struct kvm_zdev_ioat *ioat;
+	struct page *page;
+	struct kvm *kvm;
+	unsigned int idx;
+	void *iaddr;
+	int i, rc;
+
+	if (shadow_ioat_init)
+		return -EINVAL;
+
+	/* Ensure supported type specified */
+	if ((iota & ZPCI_IOTA_RTTO_FLAG) != ZPCI_IOTA_RTTO_FLAG)
+		return -EINVAL;
+
+	kvm = zdev->kzdev->kvm;
+	ioat = &zdev->kzdev->ioat;
+	mutex_lock(&ioat->ioat_lock);
+	idx = srcu_read_lock(&kvm->srcu);
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		page = gfn_to_page(kvm, gpa_to_gfn(gpa));
+		if (is_error_page(page)) {
+			srcu_read_unlock(&kvm->srcu, idx);
+			rc = -EIO;
+			goto unpin;
+		}
+		iaddr = page_to_virt(page) + (gpa & ~PAGE_MASK);
+		ioat->head[i] = (unsigned long *)iaddr;
+		gpa += PAGE_SIZE;
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	ioat->seg = kcalloc(ZPCI_TABLE_ENTRIES_PAGES, sizeof(unsigned long *),
+			    GFP_KERNEL);
+	if (!ioat->seg)
+		goto unpin;
+	ioat->pt = kcalloc(ZPCI_TABLE_ENTRIES, sizeof(unsigned long **),
+			   GFP_KERNEL);
+	if (!ioat->pt)
+		goto free_seg;
+
+	mutex_unlock(&ioat->ioat_lock);
+	return 0;
+
+free_seg:
+	kfree(ioat->seg);
+	rc = -ENOMEM;
+unpin:
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		kvm_release_pfn_dirty((u64)ioat->head[i] >> PAGE_SHIFT);
+		ioat->head[i] = 0;
+	}
+	mutex_unlock(&ioat->ioat_lock);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_ioat_enable);
+
+static void free_pt_entry(struct kvm_zdev_ioat *ioat, int st, int pt)
+{
+	if (!ioat->pt[st][pt])
+		return;
+
+	kvm_release_pfn_dirty((u64)ioat->pt[st][pt]);
+}
+
+static void free_seg_entry(struct kvm_zdev_ioat *ioat, int entry)
+{
+	int i, st, count = 0;
+
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		if (ioat->seg[entry + i]) {
+			kvm_release_pfn_dirty((u64)ioat->seg[entry + i]);
+			count++;
+		}
+	}
+
+	if (count == 0)
+		return;
+
+	st = entry / ZPCI_TABLE_PAGES;
+	for (i = 0; i < ZPCI_TABLE_ENTRIES; i++)
+		free_pt_entry(ioat, st, i);
+	kfree(ioat->pt[st]);
+}
+
+int kvm_s390_pci_ioat_disable(struct zpci_dev *zdev)
+{
+	struct kvm_zdev_ioat *ioat;
+	int i;
+
+	if (!shadow_ioat_init)
+		return -EINVAL;
+
+	ioat = &zdev->kzdev->ioat;
+	mutex_lock(&ioat->ioat_lock);
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		kvm_release_pfn_dirty((u64)ioat->head[i] >> PAGE_SHIFT);
+		ioat->head[i] = 0;
+	}
+
+	for (i = 0; i < ZPCI_TABLE_ENTRIES_PAGES; i += ZPCI_TABLE_PAGES)
+		free_seg_entry(ioat, i);
+
+	kfree(ioat->seg);
+	kfree(ioat->pt);
+	mutex_unlock(&ioat->ioat_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_ioat_disable);
+
+u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev)
+{
+	return (zdev->dtsm & KVM_S390_PCI_DTSM_MASK);
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_get_dtsm);
+
 int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
 {
 	/* Must have appropriate hardware facilities */
@@ -449,6 +584,10 @@ int kvm_s390_pci_interp_disable(struct zpci_dev *zdev, bool force)
 	if (zdev->kzdev->fib.fmt0.aibv != 0)
 		kvm_s390_pci_aif_disable(zdev, force);
 
+	/* If we are using the IOAT assist, disable it now */
+	if (zdev->kzdev->ioat.head[0])
+		kvm_s390_pci_ioat_disable(zdev);
+
 	/* Remove the host CLP guest designation */
 	zdev->gisa = 0;
 
@@ -478,6 +617,8 @@ int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 	if (!kzdev)
 		return -ENOMEM;
 
+	mutex_init(&kzdev->ioat.ioat_lock);
+
 	kzdev->zdev = zdev;
 	zdev->kzdev = kzdev;
 
@@ -492,6 +633,7 @@ void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
 	kzdev = zdev->kzdev;
 	WARN_ON(kzdev->zdev != zdev);
 	zdev->kzdev = 0;
+	mutex_destroy(&kzdev->ioat.ioat_lock);
 	kfree(kzdev);
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_dev_release);
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 4d3db58beb74..0fa0e3d61aaa 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -16,6 +16,8 @@
 #include <asm/airq.h>
 #include <asm/kvm_pci.h>
 
+#define KVM_S390_PCI_DTSM_MASK 0x40
+
 struct zpci_gaite {
 	u32 gisa;
 	u8 gisc;
-- 
2.27.0

