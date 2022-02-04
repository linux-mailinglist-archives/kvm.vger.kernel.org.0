Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80124AA1E9
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbiBDVRS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:17:18 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:29354 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241678AbiBDVQ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:16:27 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214KKx4n005571;
        Fri, 4 Feb 2022 21:16:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=h3FKPKin2SVg5XJRUV66QBhHu5Fva/dFwXTOoBi64M8=;
 b=DXm+DoNjYqRsFxpBmg/SHhZHA70x97EiqRds1zYWSMqqZeUjxrt9qEtevFr4b935MySc
 xJZiI+f+yqo56uwUOzxr/QgG/Wtkmc12u3Vx0gRcPUPNLi36euk+C7lmvDyFfYQA5Bes
 rAXUiuNCfmyKfMvFsMpn+yZntQN6txNwrl6HB8J6/l0HrPPpYduMwxXAhaoYwGwhG7Hj
 sOZboGr0tR5yD72N5EeXH7r/jkRrjHcAy7JCIWROnO+Vfpm1B7xde/ISMOcW5iT8Zvg3
 +HROdTFV01/seFFG40/tKDW3Lz9isDh9WvpxFJI47xsrOwzPviXia/RJRvmTa+GPl0hQ CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12pbmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:26 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LGQtQ021787;
        Fri, 4 Feb 2022 21:16:26 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0r12pbm1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:26 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LCc7q021946;
        Fri, 4 Feb 2022 21:16:25 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 3e0r0k7gxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:16:25 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LGNAn32178490
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:16:23 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35FDD136055;
        Fri,  4 Feb 2022 21:16:23 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 64D7F13606F;
        Fri,  4 Feb 2022 21:16:21 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:16:21 +0000 (GMT)
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
Subject: [PATCH v3 20/30] KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding
Date:   Fri,  4 Feb 2022 16:15:26 -0500
Message-Id: <20220204211536.321475-21-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211536.321475-1-mjrosato@linux.ibm.com>
References: <20220204211536.321475-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8ywpZxeX8Uq5H2rdEnCdiMKsGObnoMOo
X-Proofpoint-ORIG-GUID: 68vekUC4Sao2n5RjwAe7v3294NQYR1Zb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 suspectscore=0 adultscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into the vfio_pci_zdev ioctl handlers to
respond to requests to enable / disable a device for Adapter Event
Notifications / Adapter Interuption Forwarding.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |   9 +-
 arch/s390/kvm/pci.c             | 217 +++++++++++++++++++++++++++++++-
 arch/s390/pci/pci_insn.c        |   1 +
 3 files changed, 225 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 422701d526dd..377eebcba2d1 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -15,17 +15,24 @@
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
 
+int kvm_s390_pci_aif_probe(struct zpci_dev *zdev);
+int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
+			    bool assist);
+int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force);
+
 int kvm_s390_pci_interp_probe(struct zpci_dev *zdev);
 int kvm_s390_pci_interp_enable(struct zpci_dev *zdev);
-int kvm_s390_pci_interp_disable(struct zpci_dev *zdev);
+int kvm_s390_pci_interp_disable(struct zpci_dev *zdev, bool force);
 
 #endif /* ASM_KVM_PCI_H */
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 16bef3935284..8e9044a7bce7 100644
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
@@ -155,6 +156,216 @@ int kvm_s390_pci_aen_init(u8 nisc)
 	return rc;
 }
 
+/* Modify PCI: Register floating adapter interruption forwarding */
+static int kvm_zpci_set_airq(struct zpci_dev *zdev)
+{
+	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_REG_INT);
+	struct zpci_fib fib = {};
+	u8 status;
+
+	fib.fmt0.isc = zdev->kzdev->fib.fmt0.isc;
+	fib.fmt0.sum = 1;       /* enable summary notifications */
+	fib.fmt0.noi = airq_iv_end(zdev->aibv);
+	fib.fmt0.aibv = virt_to_phys(zdev->aibv->vector);
+	fib.fmt0.aibvo = 0;
+	fib.fmt0.aisb = virt_to_phys(aift->sbv->vector + (zdev->aisb / 64) * 8);
+	fib.fmt0.aisbo = zdev->aisb & 63;
+	fib.gd = zdev->gisa;
+
+	return zpci_mod_fc(req, &fib, &status) ? -EIO : 0;
+}
+
+/* Modify PCI: Unregister floating adapter interruption forwarding */
+static int kvm_zpci_clear_airq(struct zpci_dev *zdev)
+{
+	u64 req = ZPCI_CREATE_REQ(zdev->fh, 0, ZPCI_MOD_FC_DEREG_INT);
+	struct zpci_fib fib = {};
+	u8 cc, status;
+
+	fib.gd = zdev->gisa;
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
+	int rc = 0, gisc;
+
+	/*
+	 * Interrupt forwarding is only applicable if the device is already
+	 * enabled for interpretation
+	 */
+	if (zdev->gisa == 0)
+		return -EINVAL;
+
+	kvm = zdev->kzdev->kvm;
+	msi_vecs = min_t(unsigned int, fib->fmt0.noi, zdev->max_msi);
+
+	/* Get the associated forwarding ISC - if invalid, return the error */
+	gisc = kvm_s390_gisc_register(kvm, fib->fmt0.isc);
+	if (gisc < 0)
+		return gisc;
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
+	mutex_lock(&aift->aift_lock);
+	bit = airq_iv_alloc_bit(aift->sbv);
+	if (bit == -1UL)
+		goto unpin2;
+	zdev->aisb = bit; /* store the summary bit number */
+	zdev->aibv = airq_iv_create(msi_vecs, AIRQ_IV_DATA |
+				    AIRQ_IV_BITLOCK |
+				    AIRQ_IV_GUESTVEC,
+				    phys_to_virt(fib->fmt0.aibv));
+
+	spin_lock_irq(&aift->gait_lock);
+	gaite = (struct zpci_gaite *)aift->gait + (zdev->aisb *
+						   sizeof(struct zpci_gaite));
+
+	/* If assist not requested, host will get all alerts */
+	if (assist)
+		gaite->gisa = (u32)virt_to_phys(&kvm->arch.sie_page2->gisa);
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
+	fib->fmt0.isc = gisc;
+
+	/* Save some guest fib values in the host for later use */
+	zdev->kzdev->fib.fmt0.isc = fib->fmt0.isc;
+	zdev->kzdev->fib.fmt0.aibv = fib->fmt0.aibv;
+	mutex_unlock(&aift->aift_lock);
+
+	/* Issue the clp to setup the irq now */
+	rc = kvm_zpci_set_airq(zdev);
+	return rc;
+
+unpin2:
+	mutex_unlock(&aift->aift_lock);
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
+int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force)
+{
+	struct kvm_zdev *kzdev = zdev->kzdev;
+	struct zpci_gaite *gaite;
+	int rc;
+	u8 isc;
+
+	if (zdev->gisa == 0)
+		return -EINVAL;
+
+	mutex_lock(&aift->aift_lock);
+
+	/*
+	 * If the clear fails due to an error, leave now unless we know this
+	 * device is about to go away (force) -- In that case clear the GAITE
+	 * regardless.
+	 */
+	rc = kvm_zpci_clear_airq(zdev);
+	if (rc && !force)
+		goto out;
+
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
+	mutex_unlock(&aift->aift_lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pci_aif_disable);
+
 int kvm_s390_pci_interp_probe(struct zpci_dev *zdev)
 {
 	/* Must have appropriate hardware facilities */
@@ -227,13 +438,17 @@ int kvm_s390_pci_interp_enable(struct zpci_dev *zdev)
 }
 EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_enable);
 
-int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
+int kvm_s390_pci_interp_disable(struct zpci_dev *zdev, bool force)
 {
 	int rc;
 
 	if (zdev->gisa == 0)
 		return -EINVAL;
 
+	/* Forwarding must be turned off before interpretation */
+	if (zdev->kzdev->fib.fmt0.aibv != 0)
+		kvm_s390_pci_aif_disable(zdev, force);
+
 	/* Remove the host CLP guest designation */
 	zdev->gisa = 0;
 
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

