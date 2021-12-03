Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C786467BF0
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 17:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382268AbhLCRBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Dec 2021 12:01:50 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58632 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1382243AbhLCRBr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Dec 2021 12:01:47 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GIKWC015379;
        Fri, 3 Dec 2021 16:58:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Q8qrLLKV6inlJ+zUEGrwh5vzES2Zq9EO8/b9Ts/Ve3U=;
 b=eppJSwpMv0o2YTolViQneNyv+xfxCobCUIbex6iLXSsuGSP65TII3Fp5xEQoM1vR1qzs
 3+od5i9h+2V55IQz/0djCHhkrxkvda0LA4YRzTWwXa47XP9ylZeFVw7wJsA1Nrq+BvaY
 IfTAvcYfI32UkImKj7QF6hUDo8eaomgzCbtNhXCOFflEEnw5HzoFYWZX41imVrk4lMnm
 Kveqh/TtvkVNraamcQH7/vBcgSmcRDNPYORD0KXHFnvSKxnqc828Lg7MmH1UNoEd9sVB
 w+y491GTV1Q4JeYtMzXwW2VVeGscPBSigPfQBChvJGkuqaRWnpSLY5DCGi8hUYtz+ohw 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqpn28rx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:23 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B3GKcUD026110;
        Fri, 3 Dec 2021 16:58:22 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cqpn28rwb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:22 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B3GuxIA013984;
        Fri, 3 Dec 2021 16:58:20 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3ckcadfrw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 03 Dec 2021 16:58:20 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B3GwGk928639716
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 3 Dec 2021 16:58:16 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0F57F5204F;
        Fri,  3 Dec 2021 16:58:16 +0000 (GMT)
Received: from p-imbrenda.bredband2.com (unknown [9.145.14.21])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 816BC5205A;
        Fri,  3 Dec 2021 16:58:15 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 01/17] KVM: s390: pv: leak the topmost page table when destroy fails
Date:   Fri,  3 Dec 2021 17:57:58 +0100
Message-Id: <20211203165814.73016-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211203165814.73016-1-imbrenda@linux.ibm.com>
References: <20211203165814.73016-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pqttTYSPlcvLAtjSynQzuNkjNmrGrXTs
X-Proofpoint-ORIG-GUID: a2pbecieS7NCSAkI06gJEYqZuQI-m-mM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-03_07,2021-12-02_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112030105
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
 arch/s390/include/asm/gmap.h |  2 ++
 arch/s390/kvm/pv.c           |  9 +++--
 arch/s390/mm/gmap.c          | 65 ++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 3 deletions(-)

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
index 00d272d134c2..b906658ffc2e 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -168,10 +168,13 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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
index dfee0ebb2fac..5d6618016263 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2714,3 +2714,68 @@ void s390_reset_acc(struct mm_struct *mm)
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
+ * intended.
+ */
+void s390_remove_old_asce(struct gmap *gmap)
+{
+	struct page *old;
+
+	old = virt_to_page(gmap->table);
+	spin_lock(&gmap->guest_table_lock);
+	list_del(&old->lru);
+	spin_unlock(&gmap->guest_table_lock);
+	/* in case the ASCE needs to be "removed" multiple times */
+	INIT_LIST_HEAD(&old->lru);
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
+	asce = (gmap->asce & ~PAGE_MASK) | __pa(table);
+	WRITE_ONCE(gmap->asce, asce);
+	WRITE_ONCE(gmap->mm->context.gmap_asce, asce);
+	WRITE_ONCE(gmap->table, table);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(s390_replace_asce);
-- 
2.31.1

