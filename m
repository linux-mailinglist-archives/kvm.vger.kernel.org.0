Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 414FE48F142
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244664AbiANUcs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:32:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:31978 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244547AbiANUcc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:32:32 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EJQRfc004656;
        Fri, 14 Jan 2022 20:32:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=0Cu9Mtd3By6Wkqi/CSKYI0AEcVTCVp0sh9aRqi/Yvpk=;
 b=Q1SXr+FLXE9slFcqSR2Narn7fSBWz+GFDkpNSQpYSaIiS0SS0Wf8XuUxQAMhGeJRKE9L
 ug1hgFWsbUgNUXnNHYt6ZMwSjz5fnnZ4AAzKGkRzQQD0hPQjplg3Lt1yl1jXcTRA9c0t
 6Mqinm2V3TDXPw2enN1b5kOhUHDAvCwAT9/nmazxJ6u5f2ETrmveNIpASZc3BYRkesT7
 f73ox7UgVLSQE5rP5hAWcqX5pK5G/XEa0M8mAh0iMBHSELk2+ThhLUSSBVd5fGgFnz3T
 JoBLismImO+NzOqP1bK/6vV/gIN0ON4TQpCwanKb9WOrkzgcHibflkf0gB5K2cGeXiEq Dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfb794tn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:31 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKKVbq011371;
        Fri, 14 Jan 2022 20:32:31 GMT
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkfb794tb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:31 +0000
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKMXMT032717;
        Fri, 14 Jan 2022 20:32:30 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 3df28ddyw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:32:30 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKWS0h19071468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:32:28 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 376D2C6077;
        Fri, 14 Jan 2022 20:32:28 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85B7CC6069;
        Fri, 14 Jan 2022 20:32:26 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:32:26 +0000 (GMT)
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
Subject: [PATCH v2 19/30] KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding
Date:   Fri, 14 Jan 2022 15:31:34 -0500
Message-Id: <20220114203145.242984-20-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203145.242984-1-mjrosato@linux.ibm.com>
References: <20220114203145.242984-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QopdVOdP2K5uFswEeTyM4r7vJ4r98iew
X-Proofpoint-GUID: CAQ09aA3ZJghyEx6tNyTKVH-JIKdcbn0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into the vfio_pci_zdev ioctl handlers to
respond to requests to enable / disable a device for Adapter Event
Notifications / Adapter Interuption Forwarding.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |   7 ++
 arch/s390/kvm/pci.c             | 203 ++++++++++++++++++++++++++++++++
 arch/s390/pci/pci_insn.c        |   1 +
 3 files changed, 211 insertions(+)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 072401aa7922..01fe14fffd7a 100644
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
 
 int kvm_s390_pci_dev_open(struct zpci_dev *zdev);
 void kvm_s390_pci_dev_release(struct zpci_dev *zdev);
 void kvm_s390_pci_attach_kvm(struct zpci_dev *zdev, struct kvm *kvm);
 
+int kvm_s390_pci_aif_probe(struct zpci_dev *zdev);
+int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
+			    bool assist);
+int kvm_s390_pci_aif_disable(struct zpci_dev *zdev);
+
 int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
 int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
 int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 122d0992b521..7ed9abc476b6 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -12,6 +12,7 @@
 #include <asm/kvm_pci.h>
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
+#include <asm/pci_io.h>
 #include <asm/sclp.h>
 #include "pci.h"
 #include "kvm-s390.h"
@@ -145,6 +146,204 @@ int kvm_s390_pci_aen_init(u8 nisc)
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
+	fib.fmt0.aibv = virt_to_phys(zdev->aibv->vector);
+	fib.fmt0.aibvo = 0;
+	fib.fmt0.aisb = virt_to_phys(aift->sbv->vector + (zdev->aisb / 64) * 8);
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
+	/* Must have appropriate hardware facilities */
+	if (!(sclp.has_aeni && test_facility(71)))
+		return -EINVAL;
+
+	/* Must have a KVM association registered */
+	if (!zdev->kzdev || !zdev->kzdev->kvm)
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
+	phys_addr_t gaddr;
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
+	gaddr = page_to_phys(aibv_page) + (fib->fmt0.aibv & ~PAGE_MASK);
+	fib->fmt0.aibv = gaddr;
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
+	mutex_lock(&aift->lock);
+	bit = airq_iv_alloc_bit(aift->sbv);
+	if (bit == -1UL)
+		goto unpin2;
+	zdev->aisb = bit;
+	zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
+					      AIRQ_IV_BITLOCK |
+					      AIRQ_IV_GUESTVEC,
+				    (unsigned long *)fib->fmt0.aibv);
+
+	spin_lock_irq(&aift->gait_lock);
+	gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
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
+	gaite->aisb = virt_to_phys(page_address(aisb_page) + (fib->fmt0.aisb &
+							      ~PAGE_MASK));
+	aift->kzdev[zdev->aisb] = zdev->kzdev;
+	spin_unlock_irq(&aift->gait_lock);
+
+	/* Update guest FIB for re-issue */
+	fib->fmt0.aisbo = zdev->aisb & 63;
+	fib->fmt0.aisb = virt_to_phys(aift->sbv->vector + (zdev->aisb / 64) * 8);
+	fib->fmt0.isc = kvm_s390_gisc_register(kvm, gaite->gisc);
+
+	/* Save some guest fib values in the host for later use */
+	zdev->kzdev->fib.fmt0.isc = fib->fmt0.isc;
+	zdev->kzdev->fib.fmt0.aibv = fib->fmt0.aibv;
+	mutex_unlock(&aift->lock);
+
+	/* Issue the clp to setup the irq now */
+	rc = kvm_zpci_set_airq(zdev);
+	return rc;
+
+unpin2:
+	mutex_unlock(&aift->lock);
+	if (fib->fmt0.sum == 1) {
+		gaddr = page_to_phys(aisb_page);
+		kvm_release_pfn_dirty(gaddr >> PAGE_SHIFT);
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
+	mutex_lock(&aift->lock);
+	if (zdev->kzdev->fib.fmt0.aibv == 0)
+		goto out;
+	spin_lock_irq(&aift->gait_lock);
+	gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
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
+		aift->kzdev[zdev->aisb] = 0;
+		/* Clear zdev info */
+		airq_iv_free_bit(aift->sbv, zdev->aisb);
+		airq_iv_release(zdev->aibv);
+		zdev->aisb = 0;
+		zdev->aibv = NULL;
+	}
+	spin_unlock_irq(&aift->gait_lock);
+	kvm_s390_gisc_unregister(kzdev->kvm, isc);
+	kzdev->fib.fmt0.isc = 0;
+	kzdev->fib.fmt0.aibv = 0;
+out:
+	mutex_unlock(&aift->lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
+
 int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
 {
 	/* Must have appropriate hardware facilities */
@@ -221,6 +420,10 @@ int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
 	if (zdev->gd == 0)
 		return -EINVAL;
 
+	/* Forwarding must be turned off before interpretation */
+	if (zdev->kzdev->fib.fmt0.aibv != 0)
+		kvm_s390_pci_aif_disable(zdev);
+
 	/* Remove the host CLP guest designation */
 	zdev->gd = 0;
 
diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
index ca6399d52767..f7d0e29bbf0b 100644
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

