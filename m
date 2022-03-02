Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7654CAD10
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 19:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244457AbiCBSMj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Mar 2022 13:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231247AbiCBSMi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Mar 2022 13:12:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8BF90CDC;
        Wed,  2 Mar 2022 10:11:51 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 222GO5bI021051;
        Wed, 2 Mar 2022 18:11:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=6VtpbBcqtZzJNfRNQ8Djkc+EgsrAekJZoNkfoY0Ohws=;
 b=Wot6Tl5ppokE3YXaOvfht0vyXTRqLPfF2avJvcdOTF44YC2XVx/Iy4B9iIN4KDD1H/MJ
 +t6UXiLy5aVohdcZO4SILrs/fydAw5qbDySctseLgjijn+h8Xwo3x6vHZmsYzqfDtrZJ
 1Ux3UQWKJLKsjhYAJmRujkQ5qJknHtI6CnUBAA0/bOa+XDFS5LE37qNZ3/L99bYkjbti
 RjVg8C11CLp5RkWWqKifQxaX1uj+K+o5YsbeSnDUYXVAd23Glh1m+eBbP/pSaaSXbIJg
 4V6dYn56mOB/H4egLZRjQ2iiPjNDpyr4bQvM4nSBqXdlF/BVZ3KbVkepfd/diwz0rb9W pw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejc2rt608-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:50 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 222HxCoe017045;
        Wed, 2 Mar 2022 18:11:50 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ejc2rt5yf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:50 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 222I8tOj010832;
        Wed, 2 Mar 2022 18:11:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06fra.de.ibm.com with ESMTP id 3efbfj6410-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 18:11:48 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 222IBjj152887930
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Mar 2022 18:11:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F09495204E;
        Wed,  2 Mar 2022 18:11:44 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.5.37])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7DBF952059;
        Wed,  2 Mar 2022 18:11:44 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, frankja@linux.ibm.com, thuth@redhat.com,
        pasic@linux.ibm.com, david@redhat.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, scgl@linux.ibm.com,
        mimu@linux.ibm.com, nrb@linux.ibm.com
Subject: [PATCH v8 01/17] KVM: s390: pv: leak the topmost page table when destroy fails
Date:   Wed,  2 Mar 2022 19:11:27 +0100
Message-Id: <20220302181143.188283-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302181143.188283-1-imbrenda@linux.ibm.com>
References: <20220302181143.188283-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YedrFEOcx36sH19DvLouQ0fSEcNgr2a4
X-Proofpoint-ORIG-GUID: AzRGCU3n_Fr-zEqeGEl6EVmCRGFyrGce
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_12,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 adultscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 malwarescore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203020078
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each secure guest must have a unique ASCE (address space control
element); we must avoid that new guests use the same page for their
ASCE, to avoid errors.

Since the ASCE mostly consists of the address of the topmost page table
(plus some flags), we must not return that memory to the pool unless
the ASCE is no longer in use.

Only a successful Destroy Secure Configuration UVC will make the ASCE
reusable again.

If the Destroy Configuration UVC fails, the ASCE cannot be reused for a
secure guest (either for the ASCE or for other memory areas). To avoid
a collision, it must not be used again. This is a permanent error and
the page becomes in practice unusable, so we set it aside and leak it.
On failure we already leak other memory that belongs to the ultravisor
(i.e. the variable and base storage for a guest) and not leaking the
topmost page table was an oversight.

This error (and thus the leakage) should not happen unless the hardware
is broken or KVM has some unknown serious bug.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Fixes: 29b40f105ec8d55 ("KVM: s390: protvirt: Add initial vm and cpu lifecycle handling")
---
 arch/s390/include/asm/gmap.h |  2 +
 arch/s390/kvm/pv.c           |  9 +++--
 arch/s390/mm/gmap.c          | 71 ++++++++++++++++++++++++++++++++++++
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 40264f60b0da..746e18bf8984 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -148,4 +148,6 @@ void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
 int gmap_mark_unmergeable(void);
 void s390_reset_acc(struct mm_struct *mm);
+void s390_remove_old_asce(struct gmap *gmap);
+int s390_replace_asce(struct gmap *gmap);
 #endif /* _ASM_S390_GMAP_H */
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 7f7c0d6af2ce..3c59ef763dde 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -166,10 +166,13 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	atomic_set(&kvm->mm->context.is_protected, 0);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
-	/* Inteded memory leak on "impossible" error */
-	if (!cc)
+	/* Intended memory leak on "impossible" error */
+	if (!cc) {
 		kvm_s390_pv_dealloc_vm(kvm);
-	return cc ? -EIO : 0;
+		return 0;
+	}
+	s390_replace_asce(kvm->arch.gmap);
+	return -EIO;
 }
 
 int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index dfee0ebb2fac..e78857d6942a 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2714,3 +2714,74 @@ void s390_reset_acc(struct mm_struct *mm)
 	mmput(mm);
 }
 EXPORT_SYMBOL_GPL(s390_reset_acc);
+
+/**
+ * s390_remove_old_asce - Remove the topmost level of page tables from the
+ * list of page tables of the gmap.
+ * @gmap the gmap whose table is to be removed
+ *
+ * This means that it will not be freed when the VM is torn down, and needs
+ * to be handled separately by the caller, unless an intentional leak is
+ * intended. Notice that this function will only remove the page from the
+ * list, the page will still be used as a top level page table (and ASCE).
+ */
+void s390_remove_old_asce(struct gmap *gmap)
+{
+	struct page *old;
+
+	old = virt_to_page(gmap->table);
+	spin_lock(&gmap->guest_table_lock);
+	list_del(&old->lru);
+	/*
+	 * in case the ASCE needs to be "removed" multiple times, for example
+	 * if the VM is rebooted into secure mode several times
+	 * concurrently.
+	 */
+	INIT_LIST_HEAD(&old->lru);
+	spin_unlock(&gmap->guest_table_lock);
+}
+EXPORT_SYMBOL_GPL(s390_remove_old_asce);
+
+/**
+ * s390_replace_asce - Try to replace the current ASCE of a gmap with
+ * another equivalent one.
+ * @gmap the gmap
+ *
+ * If the allocation of the new top level page table fails, the ASCE is not
+ * replaced.
+ * In any case, the old ASCE is always removed from the list. Therefore the
+ * caller has to make sure to save a pointer to it beforehands, unless an
+ * intentional leak is intended.
+ */
+int s390_replace_asce(struct gmap *gmap)
+{
+	unsigned long asce;
+	struct page *page;
+	void *table;
+
+	s390_remove_old_asce(gmap);
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	if (!page)
+		return -ENOMEM;
+	table = page_to_virt(page);
+	memcpy(table, gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
+
+	/*
+	 * The caller has to deal with the old ASCE, but here we make sure
+	 * the new one is properly added to the list of page tables, so that
+	 * it will be freed when the VM is torn down.
+	 */
+	spin_lock(&gmap->guest_table_lock);
+	list_add(&page->lru, &gmap->crst_list);
+	spin_unlock(&gmap->guest_table_lock);
+
+	/* Set new table origin while preserving existing ASCE control bits */
+	asce = (gmap->asce & _ASCE_ORIGIN) | __pa(table);
+	WRITE_ONCE(gmap->asce, asce);
+	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
+	WRITE_ONCE(gmap->table, table);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s390_replace_asce);
-- 
2.34.1

