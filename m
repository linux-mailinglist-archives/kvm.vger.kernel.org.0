Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D584D8D37
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 20:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244558AbiCNTvX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 15:51:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244492AbiCNTvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 15:51:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03953EB8E;
        Mon, 14 Mar 2022 12:49:47 -0700 (PDT)
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22EJlVUQ008854;
        Mon, 14 Mar 2022 19:49:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=BuOxTyadE41kqSKYuMuuX5q6+0wx51sOLt41XPhPEhA=;
 b=oGgkxa9XJsfNezBK3HDlUzTGVJ681pyYNhLZSR3F/XhAV0D/+vwI3cx7eia8PDfIdWiI
 r5FufB/98XgpN7ga9FdK3wWdkaLVDvHmTkCm4Ch5bHtqezcIMn6F1ATZSR9Vg2fyYP5u
 TqRKBd/8l1KsuQChvGoZGdyvT6xWII5gYQxQ1h/jMNoZxB1pWeYV+rdflSGNjgmmUAdy
 jIrwGvaUiFjyLkVcs9JIW3P7+gfjycVnoY+GkCeQ7IIELenMtoCc7hZ/oSzrghLQul2m
 kHtmfM3eWUHzeI9Y7xLWuxNWcE1HY/H8Le9sUgAzNxlWdzFbH12aecS2Q/B0QR+UQ4zI zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6d28p2s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:11 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22EJlpKn009751;
        Mon, 14 Mar 2022 19:49:11 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3et6d28p2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:11 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22EJltJT010586;
        Mon, 14 Mar 2022 19:49:10 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma03dal.us.ibm.com with ESMTP id 3erk594d64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Mar 2022 19:49:10 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22EJn8l53277758
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Mar 2022 19:49:08 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D0D9112070;
        Mon, 14 Mar 2022 19:49:08 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA4D211206D;
        Mon, 14 Mar 2022 19:48:59 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.32.184])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Mar 2022 19:48:59 +0000 (GMT)
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
Subject: [PATCH v4 24/32] KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding
Date:   Mon, 14 Mar 2022 15:44:43 -0400
Message-Id: <20220314194451.58266-25-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220314194451.58266-1-mjrosato@linux.ibm.com>
References: <20220314194451.58266-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lcsrZ7qSxi6fl3ZIXCnToUGnDsKDp4yg
X-Proofpoint-GUID: rEKm1lirw--Tp5JDE9lDmA65uHfxx7dh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-14_13,2022-03-14_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=855 adultscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

These routines will be wired into a kvm ioctl in order to respond to
requests to enable / disable a device for Adapter Event Notifications /
Adapter Interuption Forwarding.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/include/asm/kvm_pci.h |   2 +
 arch/s390/kvm/pci.c             | 201 +++++++++++++++++++++++++++++++-
 arch/s390/pci/pci_insn.c        |   1 +
 3 files changed, 203 insertions(+), 1 deletion(-)

diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
index 47ce18b5bddd..ed596880fb06 100644
--- a/arch/s390/include/asm/kvm_pci.h
+++ b/arch/s390/include/asm/kvm_pci.h
@@ -16,11 +16,13 @@
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
 #include <linux/pci.h>
+#include <asm/pci_insn.h>
 
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
 	struct iommu_domain *dom; /* Used to invoke IOMMU API for RPCIT */
+	struct zpci_fib fib;
 	struct notifier_block nb;
 	struct list_head entry;
 };
diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index df50dd6114c3..2287c1c6a3e5 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -13,6 +13,7 @@
 #include <asm/kvm_pci.h>
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
+#include <asm/pci_io.h>
 #include <asm/sclp.h>
 #include "pci.h"
 #include "kvm-s390.h"
@@ -172,6 +173,200 @@ int kvm_s390_pci_aen_init(u8 nisc)
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
+static int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
+				   bool assist)
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
+
+static int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force)
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
+
 static int kvm_s390_pci_interp_enable(struct zpci_dev *zdev)
 {
 	u32 gisa;
@@ -226,13 +421,17 @@ static int kvm_s390_pci_interp_enable(struct zpci_dev *zdev)
 	return rc;
 }
 
-static int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
+static int kvm_s390_pci_interp_disable(struct zpci_dev *zdev, bool force)
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

