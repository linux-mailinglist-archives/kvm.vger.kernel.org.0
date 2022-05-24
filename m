Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA56F5330FD
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 21:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240851AbiEXTAi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 15:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240708AbiEXTA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 15:00:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA0D58BD13;
        Tue, 24 May 2022 11:59:54 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24OIIWt7028608;
        Tue, 24 May 2022 18:59:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=E9ajTcD3MrwTSmj9e6FzxVdYHwy3iATm1+tisBQa91E=;
 b=dXSOx56GnjuJCd2GaRTBMw/g20sDzBJXZxWqjrB0YOxSu2VW+8KO9Gv3MV06YAoPk+vz
 NnRGMLffx//mUVeuPFztcHQ01Z2Exs/cDNj5IyncHhj3KdJqsd4el0QfM9J7cJrD2/u4
 2zJkgr05KZ7sCUYtUZ2VLUBGeISf0Yrf5tSwW1zGB9z54we99a7rHXsjCqev9hM4D6ng
 S63jk38xEoGSryVL/pDz2e/OzsnsgVsQC4sokXg7S/1x7YwUs665FuPLy8z6pftbrNZI
 c2DzEWycAvi3EdEw7UwS7hFI+tpM01pPEi5YJfb5VCeHCzr5Yv+JXhWY/xX564G2F9GA Iw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94hd0pm5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:51 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24OIST0C031230;
        Tue, 24 May 2022 18:59:51 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g94hd0pkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:51 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24OIqsvu031355;
        Tue, 24 May 2022 18:59:50 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3g93v80nn3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 May 2022 18:59:50 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24OIxm8k30212468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 May 2022 18:59:48 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD467BE05A;
        Tue, 24 May 2022 18:59:48 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4FB3FBE056;
        Tue, 24 May 2022 18:59:46 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.163.3.233])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 24 May 2022 18:59:46 +0000 (GMT)
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
        jgg@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v8 15/22] KVM: s390: pci: provide routines for enabling/disabling interrupt forwarding
Date:   Tue, 24 May 2022 14:59:00 -0400
Message-Id: <20220524185907.140285-16-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220524185907.140285-1-mjrosato@linux.ibm.com>
References: <20220524185907.140285-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2Ra0NH-exGVzf-d2v4N34aAWseq45_XZ
X-Proofpoint-GUID: V07KcB8vMFeiLtfW4YNX9tGQgqJ8tes7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-24_09,2022-05-23_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2205240090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These routines will be wired into a kvm ioctl in order to respond to
requests to enable / disable a device for Adapter Event Notifications /
Adapter Interuption Forwarding.

Reviewed-by: Christian Borntraeger <borntraeger@linux.ibm.com>
Acked-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 arch/s390/kvm/pci.c        | 247 +++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/pci.h        |   1 +
 arch/s390/pci/pci_insn.c   |   1 +
 include/linux/sched/user.h |   3 +-
 4 files changed, 251 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pci.c b/arch/s390/kvm/pci.c
index 268cbe99fbac..5a9bc954e677 100644
--- a/arch/s390/kvm/pci.c
+++ b/arch/s390/kvm/pci.c
@@ -11,6 +11,7 @@
 #include <linux/pci.h>
 #include <asm/pci.h>
 #include <asm/pci_insn.h>
+#include <asm/pci_io.h>
 #include "pci.h"
 
 struct zpci_aift *aift;
@@ -152,6 +153,252 @@ int kvm_s390_pci_aen_init(u8 nisc)
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
+static inline void unaccount_mem(unsigned long nr_pages)
+{
+	struct user_struct *user = get_uid(current_user());
+
+	if (user)
+		atomic_long_sub(nr_pages, &user->locked_vm);
+	if (current->mm)
+		atomic64_sub(nr_pages, &current->mm->pinned_vm);
+}
+
+static inline int account_mem(unsigned long nr_pages)
+{
+	struct user_struct *user = get_uid(current_user());
+	unsigned long page_limit, cur_pages, new_pages;
+
+	page_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+
+	do {
+		cur_pages = atomic_long_read(&user->locked_vm);
+		new_pages = cur_pages + nr_pages;
+		if (new_pages > page_limit)
+			return -ENOMEM;
+	} while (atomic_long_cmpxchg(&user->locked_vm, cur_pages,
+					new_pages) != cur_pages);
+
+	atomic64_add(nr_pages, &current->mm->pinned_vm);
+
+	return 0;
+}
+
+static int kvm_s390_pci_aif_enable(struct zpci_dev *zdev, struct zpci_fib *fib,
+				   bool assist)
+{
+	struct page *pages[1], *aibv_page, *aisb_page = NULL;
+	unsigned int msi_vecs, idx;
+	struct zpci_gaite *gaite;
+	unsigned long hva, bit;
+	struct kvm *kvm;
+	phys_addr_t gaddr;
+	int rc = 0, gisc, npages, pcount = 0;
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
+	hva = gfn_to_hva(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aibv));
+	npages = pin_user_pages_fast(hva, 1, FOLL_WRITE | FOLL_LONGTERM, pages);
+	srcu_read_unlock(&kvm->srcu, idx);
+	if (npages < 1) {
+		rc = -EIO;
+		goto out;
+	}
+	aibv_page = pages[0];
+	pcount++;
+	gaddr = page_to_phys(aibv_page) + (fib->fmt0.aibv & ~PAGE_MASK);
+	fib->fmt0.aibv = gaddr;
+
+	/* Pin the guest AISB if one was specified */
+	if (fib->fmt0.sum == 1) {
+		idx = srcu_read_lock(&kvm->srcu);
+		hva = gfn_to_hva(kvm, gpa_to_gfn((gpa_t)fib->fmt0.aisb));
+		npages = pin_user_pages_fast(hva, 1, FOLL_WRITE | FOLL_LONGTERM,
+					     pages);
+		srcu_read_unlock(&kvm->srcu, idx);
+		if (npages < 1) {
+			rc = -EIO;
+			goto unpin1;
+		}
+		aisb_page = pages[0];
+		pcount++;
+	}
+
+	/* Account for pinned pages, roll back on failure */
+	if (account_mem(pcount))
+		goto unpin2;
+
+	/* AISB must be allocated before we can fill in GAITE */
+	mutex_lock(&aift->aift_lock);
+	bit = airq_iv_alloc_bit(aift->sbv);
+	if (bit == -1UL)
+		goto unlock;
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
+unlock:
+	mutex_unlock(&aift->aift_lock);
+unpin2:
+	if (fib->fmt0.sum == 1)
+		unpin_user_page(aisb_page);
+unpin1:
+	unpin_user_page(aibv_page);
+out:
+	return rc;
+}
+
+static int kvm_s390_pci_aif_disable(struct zpci_dev *zdev, bool force)
+{
+	struct kvm_zdev *kzdev = zdev->kzdev;
+	struct zpci_gaite *gaite;
+	struct page *vpage = NULL, *spage = NULL;
+	int rc, pcount = 0;
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
+		vpage = phys_to_page(kzdev->fib.fmt0.aibv);
+		if (gaite->aisb != 0)
+			spage = phys_to_page(gaite->aisb);
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
+
+	if (vpage) {
+		unpin_user_page(vpage);
+		pcount++;
+	}
+	if (spage) {
+		unpin_user_page(spage);
+		pcount++;
+	}
+	if (pcount > 0)
+		unaccount_mem(pcount);
+out:
+	mutex_unlock(&aift->aift_lock);
+
+	return rc;
+}
+
 static int kvm_s390_pci_dev_open(struct zpci_dev *zdev)
 {
 	struct kvm_zdev *kzdev;
diff --git a/arch/s390/kvm/pci.h b/arch/s390/kvm/pci.h
index 9f7828d97605..9d091033fc02 100644
--- a/arch/s390/kvm/pci.h
+++ b/arch/s390/kvm/pci.h
@@ -20,6 +20,7 @@
 struct kvm_zdev {
 	struct zpci_dev *zdev;
 	struct kvm *kvm;
+	struct zpci_fib fib;
 };
 
 struct zpci_gaite {
diff --git a/arch/s390/pci/pci_insn.c b/arch/s390/pci/pci_insn.c
index 4c6967b73932..cd9fb186a6be 100644
--- a/arch/s390/pci/pci_insn.c
+++ b/arch/s390/pci/pci_insn.c
@@ -60,6 +60,7 @@ u8 zpci_mod_fc(u64 req, struct zpci_fib *fib, u8 *status)
 
 	return cc;
 }
+EXPORT_SYMBOL_GPL(zpci_mod_fc);
 
 /* Refresh PCI Translations */
 static inline u8 __rpcit(u64 fn, u64 addr, u64 range, u8 *status)
diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index 00ed419dd464..f054d0360a75 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -24,7 +24,8 @@ struct user_struct {
 	kuid_t uid;
 
 #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
-    defined(CONFIG_NET) || defined(CONFIG_IO_URING)
+	defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
+	defined(CONFIG_VFIO_PCI_ZDEV_KVM)
 	atomic_long_t locked_vm;
 #endif
 #ifdef CONFIG_WATCH_QUEUE
-- 
2.27.0

