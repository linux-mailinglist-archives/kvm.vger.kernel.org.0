Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A514846C5A2
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbhLGVDq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:03:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25692 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237501AbhLGVD0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:03:26 -0500
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JbfE7015274;
        Tue, 7 Dec 2021 20:59:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bEEMEYbjYuAdoosQMyPQD6SAc6tq85SOu+4CtzfSHuw=;
 b=dIAiwEVSXsH/SUKSq8sJGF2EvBzDmrV7Zs7MFJK1yVAEfKCttKbihdaBCkOaOWNNP8q1
 9MwdpUhoBibJe2zguKjdJarnnYQ7y09Lsu+xGVwH5/9FI734bpF/ZvDSOUjsWkQlCojk
 v0r8UFhk6nQZZmIBFwfqqpZQk781F4WcgJ2MvAzUlJgjQfnUquqHXm9PNMd7EE0LBeQ7
 WJiUz1oYRtMSJ4IMWm16vHk1tvhjHbhhT6cDfP16sBZXeb8Bssx7ywicmnh8lHJRseVO
 c4mj2zE4VFLNVlLYa3vRILUUFJFG+SOPtpl0Cvft6aKT77+QzabVPN3YbMGOzMurSI7C XA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctdcda2xb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:54 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7JfCB7036424;
        Tue, 7 Dec 2021 20:59:53 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctdcda2wv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:53 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KvreO031498;
        Tue, 7 Dec 2021 20:59:52 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma05wdc.us.ibm.com with ESMTP id 3cqyyamn23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:52 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KxpEr64749968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:59:51 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E9AC7AE05F;
        Tue,  7 Dec 2021 20:59:50 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4CED2AE062;
        Tue,  7 Dec 2021 20:59:46 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:59:46 +0000 (GMT)
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
Subject: [PATCH 22/32] KVM: s390: pci: provide routines for enabling/disabling IOAT assist
Date:   Tue,  7 Dec 2021 15:57:33 -0500
Message-Id: <20211207205743.150299-23-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 9oIjAq5XGOUoNSwh1xiLYl9Q6EAbytYW
X-Proofpoint-GUID: EMJqUr2Xjcke_2eYneqje3dvAcuYgE8l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 phishscore=0 spamscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=990
 clxscore=1015 mlxscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2112070126
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
 arch/s390/kvm/pci.c             | 133 ++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h             |   2 +
 4 files changed, 152 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 54a0afdbe7d0..254275399f21 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -16,11 +16,21 @@
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
+	struct mutex lock;
+};
 
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
+	struct kvm_zdev_ioat ioat;
 	struct zpci_fib fib;
 };
 
@@ -33,6 +43,11 @@ extern int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
 				   bool assist);
 extern int kvm_s390_pci_aif_disable(struct zpci_dev *zdev);
 
+extern int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev);
+extern int kvm_s390_pci_ioat_enable(struct zpci_dev *zdev, u64 iota);
+extern int kvm_s390_pci_ioat_disable(struct zpci_dev *zdev);
+extern u8 kvm_s390_pci_get_dtsm(struct zpci_dev *zdev);
+
 extern int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
 extern int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
 extern int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
diff --git a/arch/s390/include/asm/pci_dma.h b/arch/s390/include/asm/pci_dma.h
index 3b8e89d4578a..e1d3c1d3fc8a 100644
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
index 3a29398dd53b..a1c0c0881332 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -12,6 +12,7 @@
 #include <asm/kvm_pci.h>
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
+#include <asm/pci_dma.h>
 #include <asm/sclp.h>
 #include "pci.h"
 #include "kvm-s390.h"
@@ -315,6 +316,131 @@ int kvm_s390_pci_aif_disable(struct zpci_dev *zdev)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
 
+int kvm_s390_pci_ioat_probe(struct zpci_dev *zdev)
+{
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
+	int i, rc = 0;
+
+	if (!zdev->kzdev || !zdev->kzdev->kvm || zdev->kzdev->ioat.head[0])
+		return -EINVAL;
+
+	/* Ensure supported type specified */
+	if ((iota & ZPCI_IOTA_RTTO_FLAG) != ZPCI_IOTA_RTTO_FLAG)
+		return -EINVAL;
+
+	kvm = zdev->kzdev->kvm;
+	ioat = &zdev->kzdev->ioat;
+	mutex_lock(&ioat->lock);
+	idx = srcu_read_lock(&kvm->srcu);
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		page = gfn_to_page(kvm, gpa_to_gfn(gpa));
+		if (is_error_page(page)) {
+			srcu_read_unlock(&kvm->srcu, idx);
+			rc = -EIO;
+			goto out;
+		}
+		iaddr = page_to_virt(page) + (gpa & ~PAGE_MASK);
+		ioat->head[i] = (unsigned long *)iaddr;
+		gpa += PAGE_SIZE;
+	}
+	srcu_read_unlock(&kvm->srcu, idx);
+
+	zdev->kzdev->ioat.seg = kcalloc(ZPCI_TABLE_ENTRIES_PAGES,
+					sizeof(unsigned long *), GFP_KERNEL);
+	if (!zdev->kzdev->ioat.seg)
+		goto unpin;
+	zdev->kzdev->ioat.pt = kcalloc(ZPCI_TABLE_ENTRIES,
+				       sizeof(unsigned long **), GFP_KERNEL);
+	if (!zdev->kzdev->ioat.pt)
+		goto free_seg;
+
+out:
+	mutex_unlock(&ioat->lock);
+	return rc;
+
+free_seg:
+	kfree(zdev->kzdev->ioat.seg);
+unpin:
+	for (i = 0; i < ZPCI_TABLE_PAGES; i++) {
+		kvm_release_pfn_dirty((u64)ioat->head[i] >> PAGE_SHIFT);
+		ioat->head[i] = 0;
+	}
+	mutex_unlock(&ioat->lock);
+	return -ENOMEM;
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
+	if (!zdev->kzdev || !zdev->kzdev->kvm || !zdev->kzdev->ioat.head[0])
+		return -EINVAL;
+
+	ioat = &zdev->kzdev->ioat;
+	mutex_lock(&ioat->lock);
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
+	mutex_unlock(&ioat->lock);
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
 	if (!(sclp.has_zpci_interp && test_facility(69)))
@@ -387,6 +513,10 @@ int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
 	if (zdev->kzdev->fib.fmt0.aibv != 0)
 		kvm_s390_pci_aif_disable(zdev);
 
+	/* If we are using the IOAT assist, disable it now */
+	if (zdev->kzdev->ioat.head[0])
+		kvm_s390_pci_ioat_disable(zdev);
+
 	/* Remove the host CLP guest designation */
 	zdev->gd = 0;
 
@@ -419,6 +549,8 @@ int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 	if (!kzdev)
 		return -ENOMEM;
 
+	mutex_init(&kzdev->ioat.lock);
+
 	kzdev->zdev = zdev;
 	zdev->kzdev = kzdev;
 
@@ -436,6 +568,7 @@ void kvm_s390_pci_dev_release(struct zpci_dev *zdev)
 	kzdev = zdev->kzdev;
 	WARN_ON(kzdev->zdev != zdev);
 	zdev->kzdev = 0;
+	mutex_destroy(&kzdev->ioat.lock);
 	kfree(kzdev);
 
 }
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 776b2745c675..3c86888fe1b3 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -16,6 +16,8 @@
 #include <asm/airq.h>
 #include <asm/kvm_pci.h>
 
+#define KVM_S390_PCI_DTSM_MASK 0x40
+
 struct zpci_gaite {
 	unsigned int gisa;
 	u8 gisc;
-- 
2.27.0

