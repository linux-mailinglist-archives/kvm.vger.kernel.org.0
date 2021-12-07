Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FFA46C59F
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241558AbhLGVDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:03:42 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241569AbhLGVDV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:03:21 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7JbgF2029460;
        Tue, 7 Dec 2021 20:59:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=oP2bx01GAi4Z0Q4RFamD9Z28xVp0tE/6Z23XVZgz90o=;
 b=Q+jn4NqO0DtKLg1OQqwJlRmE0ZDKC4luIXtLYFaG4FwKDO78xygftdyX2gkTanXlym+V
 jYnbfY6JddwAU/XMBReSqvB1mNX+RZbFfCK6Ym63eV/mBNZVg9oK6ZntqZaAPf5pjqJ2
 ucvF1AbgPMPX1m0QCxOzk9GAl6dciTXqqgwCiI7mTO18T5FIfFDD7TTSErMeAdo6UtMV
 ckSSHuYX7pDo1gXUIpV/kDjgxrpglG5Ak4Ut4Cp86gDGZrkPgHzThMAvOb1aL33xK/0/
 ZWTCKwWTcGaf87kp4eJjbFuVHRTnUJXyQRAte9XFWz0orac7UiVRP0Bn7nGvC1fGsGQV cA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctcd8unag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:49 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7JsGEG005490;
        Tue, 7 Dec 2021 20:59:49 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctcd8una8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:48 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kvmb6002326;
        Tue, 7 Dec 2021 20:59:48 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma01dal.us.ibm.com with ESMTP id 3cqyyc33wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 20:59:48 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7KxkbW32244084
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 20:59:46 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F1224AE063;
        Tue,  7 Dec 2021 20:59:45 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4F74AE05C;
        Tue,  7 Dec 2021 20:59:40 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 20:59:40 +0000 (GMT)
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
Subject: [PATCH 21/32] KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding
Date:   Tue,  7 Dec 2021 15:57:32 -0500
Message-Id: <20211207205743.150299-22-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207205743.150299-1-mjrosato@linux.ibm.com>
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: bSK0RR6BT1efFDKwbCDXbtoq4leSv4MF
X-Proofpoint-ORIG-GUID: a7V7r_OkZVHlqk1s9uOwc4Sz1U2eXTl3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 clxscore=1015 phishscore=0 priorityscore=1501 suspectscore=0
 lowpriorityscore=0 mlxlogscore=963 malwarescore=0 impostorscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into the vfio_pci_zdev ioctl handlers to
respond to requests to enable / disable a device for Adapter Event
Notifications / Adapter Interuption Forwarding.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |   7 ++
 arch/s390/kvm/pci.c             | 199 ++++++++++++++++++++++++++++++++
 arch/s390/pci/pci_insn.c        |   1 +
 3 files changed, 207 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 5d6283acb54c..54a0afdbe7d0 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -16,16 +16,23 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/pci.h>
+#include <asm/pci_insn.h>
 
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
+	struct zpci_fib fib;
 };
 
 extern int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
 extern void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
 extern int kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
 
+extern int kvm_s390_pci_aif_probe(struct zpci_dev *zdev);
+extern int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
+				   bool assist);
+extern int kvm_s390_pci_aif_disable(struct zpci_dev *zdev);
+
 extern int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
 extern int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
 extern int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 57cbe3827ea6..3a29398dd53b 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -10,6 +10,8 @@
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
 #include <asm/kvm_pci.h>
+#include <asm/pci.h>
+#include <asm/pci_insn.h>
 #include <asm/sclp.h>
 #include "pci.h"
 #include "kvm-s390.h"
@@ -120,6 +122,199 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+/* Modify PCI: Register floating adapter interruption forwarding */
+static int kvm_zpci_set_airq(struct zpci_dev *zdev)
+{
+	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_REG_INT);
+	struct zpci_fib fib = {0};
+	u8 status;
+
+	fib.fmt0.isc = zdev->kzdev->fib.fmt0.isc;
+	fib.fmt0.sum = 1;       /* enable summary notifications */
+	fib.fmt0.noi = airq_iv_end(zdev->aibv);
+	fib.fmt0.aibv = (unsigned long) zdev->aibv->vector;
+	fib.fmt0.aibvo = 0;
+	fib.fmt0.aisb = (unsigned long) aift.sbv->vector + (zdev->aisb/64) * 8;
+	fib.fmt0.aisbo = zdev->aisb & 63;
+	fib.gd = zdev->gd;
+
+	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
+}
+
+/* Modify PCI: Unregister floating adapter interruption forwarding */
+static int kvm_zpci_clear_airq(struct zpci_dev *zdev)
+{
+	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_DEREG_INT);
+	struct zpci_fib fib = {0};
+	u8 cc, status;
+
+	fib.gd = zdev->gd;
+
+	cc = zpci_mod_fc(req, &fib, &status);
+	if (cc == 3 || (cc == 1 && status == 24))
+		/* Function already gone or IRQs already deregistered. */
+		cc = 0;
+
+	return cc ? -EIO : 0;
+}
+
+int kvm_s390_pci_aif_probe(struct zpci_dev *zdev)
+{
+	if (!(sclp.has_aeni && test_facility(71)))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_probe);
+
+int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
+			    bool assist)
+{
+	struct page *aibv_page, *aisb_page = NULL;
+	unsigned int msi_vecs, idx;
+	struct zpci_gaite *gaite;
+	unsigned long bit;
+	struct kvm *kvm;
+	void *gaddr;
+	int rc = 0;
+
+	/*
+	 * Interrupt forwarding is only applicable if the device is already
+	 * enabled for interpretation
+	 */
+	if (zdev->gd == 0)
+		return -EINVAL;
+
+	kvm = zdev->kzdev->kvm;
+	msi_vecs = min_t(unsigned int, fib->fmt0.noi, zdev->max_msi);
+
+	/* Replace AIBV address */
+	idx = srcu_read_lock(&kvm->srcu);
+	aibv_page = gfn_to_page(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aibv));
+	srcu_read_unlock(&kvm->srcu, idx);
+	if (is_error_page(aibv_page)) {
+		rc = -EIO;
+		goto out;
+	}
+	gaddr = page_to_virt(aibv_page) + (fib->fmt0.aibv & ~PAGE_MASK);
+	fib->fmt0.aibv = (u64)gaddr;
+
+	/* Pin the guest AISB if one was specified */
+	if (fib->fmt0.sum == 1) {
+		idx = srcu_read_lock(&kvm->srcu);
+		aisb_page = gfn_to_page(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aisb));
+		srcu_read_unlock(&kvm->srcu, idx);
+		if (is_error_page(aisb_page)) {
+			rc = -EIO;
+			goto unpin1;
+		}
+	}
+
+	/* AISB must be allocated before we can fill in GAITE */
+	mutex_lock(&aift.lock);
+	bit = airq_iv_alloc_bit(aift.sbv);
+	if (bit == -1UL)
+		goto unpin2;
+	zdev->aisb = bit;
+	zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
+					      AIRQ_IV_BITLOCK |
+					      AIRQ_IV_GUESTVEC,
+				    (unsigned long *)fib->fmt0.aibv);
+
+	spin_lock_irq(&aift.gait_lock);
+	gaite = (struct zpci_gaite *) aift.gait + (zdev->aisb *
+						   sizeof(struct zpci_gaite));
+
+	/* If assist not requested, host will get all alerts */
+	if (assist)
+		gaite->gisa = (u32)(u64)&kvm->arch.sie_page2->gisa;
+	else
+		gaite->gisa = 0;
+
+	gaite->gisc = fib->fmt0.isc;
+	gaite->count++;
+	gaite->aisbo = fib->fmt0.aisbo;
+	gaite->aisb = (u64)(page_address(aisb_page) + (fib->fmt0.aisb &
+						       ~PAGE_MASK));
+	aift.kzdev[zdev->aisb] = zdev->kzdev;
+	spin_unlock_irq(&aift.gait_lock);
+
+	/* Update guest FIB for re-issue */
+	fib->fmt0.aisbo = zdev->aisb & 63;
+	fib->fmt0.aisb = (unsigned long) aift.sbv->vector + (zdev->aisb/64)*8;
+	fib->fmt0.isc = kvm_s390_gisc_register(kvm, gaite->gisc);
+
+	/* Save some guest fib values in the host for later use */
+	zdev->kzdev->fib.fmt0.isc = fib->fmt0.isc;
+	zdev->kzdev->fib.fmt0.aibv = fib->fmt0.aibv;
+	mutex_unlock(&aift.lock);
+
+	/* Issue the clp to setup the irq now */
+	rc = kvm_zpci_set_airq(zdev);
+	return rc;
+
+unpin2:
+	mutex_unlock(&aift.lock);
+	if (fib->fmt0.sum == 1) {
+		gaddr = page_to_virt(aisb_page);
+		kvm_release_pfn_dirty((u64)gaddr >> PAGE_SHIFT);
+	}
+unpin1:
+	kvm_release_pfn_dirty(fib->fmt0.aibv >> PAGE_SHIFT);
+out:
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_enable);
+
+int kvm_s390_pci_aif_disable(struct zpci_dev *zdev)
+{
+	struct kvm_zdev *kzdev = zdev->kzdev;
+	struct zpci_gaite *gaite;
+	int rc;
+	u8 isc;
+
+	if (zdev->gd == 0)
+		return -EINVAL;
+
+	/* Even if the clear fails due to an error, clear the GAITE */
+	rc = kvm_zpci_clear_airq(zdev);
+
+	mutex_lock(&aift.lock);
+	if (zdev->kzdev->fib.fmt0.aibv == 0)
+		goto out;
+	spin_lock_irq(&aift.gait_lock);
+	gaite = (struct zpci_gaite *) aift.gait + (zdev->aisb *
+						   sizeof(struct zpci_gaite));
+	isc = gaite->gisc;
+	gaite->count--;
+	if (gaite->count == 0) {
+		/* Release guest AIBV and AISB */
+		kvm_release_pfn_dirty(kzdev->fib.fmt0.aibv >> PAGE_SHIFT);
+		if (gaite->aisb != 0)
+			kvm_release_pfn_dirty(gaite->aisb >> PAGE_SHIFT);
+		/* Clear the GAIT entry */
+		gaite->aisb = 0;
+		gaite->gisc = 0;
+		gaite->aisbo = 0;
+		gaite->gisa = 0;
+		aift.kzdev[zdev->aisb] = 0;
+		/* Clear zdev info */
+		airq_iv_free_bit(aift.sbv, zdev->aisb);
+		airq_iv_release(zdev->aibv);
+		zdev->aisb = 0;
+		zdev->aibv = NULL;
+	}
+	spin_unlock_irq(&aift.gait_lock);
+	kvm_s390_gisc_unregister(kzdev->kvm, isc);
+	kzdev->fib.fmt0.isc = 0;
+	kzdev->fib.fmt0.aibv = 0;
+out:
+	mutex_unlock(&aift.lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
+
 int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
 {
 	if (!(sclp.has_zpci_interp && test_facility(69)))
@@ -188,6 +383,10 @@ int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
 	if (zdev->gd == 0)
 		return -EINVAL;
 
+	/* Forwarding must be turned off before interpretation */
+	if (zdev->kzdev->fib.fmt0.aibv != 0)
+		kvm_s390_pci_aif_disable(zdev);
+
 	/* Remove the host CLP guest designation */
 	zdev->gd = 0;
 
diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
index 0d1ab268ec24..b57d3f594113 100644
--- a/arch/s390/pci/pci_insn.c
+++ b/arch/s390/pci/pci_insn.c
@@ -59,6 +59,7 @@ u8 zpci_mod_fc(u64 req, struct zpci_fib *fib, u8 *status)
 
 	return cc;
 }
+EXPORT_SYMBOL_GPL(zpci_mod_fc);
 
 /* Refresh PCI Translations */
 static inline u8 __rpcit(u64 fn, u64 addr, u64 range, u8 *status)
-- 
2.27.0

