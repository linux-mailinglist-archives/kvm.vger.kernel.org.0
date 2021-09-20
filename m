Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6E6411585
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 15:25:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbhITN0r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 09:26:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43856 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239339AbhITN0k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Sep 2021 09:26:40 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD3v0008176;
        Mon, 20 Sep 2021 09:25:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=i0LjC2TuwXjTVgrM00A60r5isHFYucLdjsTqz6Xte90=;
 b=KEw9UA9+4dpL3UlLbeDlzXtbxkdpXtlmYwnzgMvBeP42u5MwCKz6VSfdKK+dwzqo7cYn
 x48QvnP41zxPhzwNu7ZBfcyimqEIv60IdlstxhePktKnqAYFFkOcqBe3Z7VP7XRu0J0h
 gbpJYXaLhAq/dxQe3GJvSXlldmgzbxP0vATRTrRXXghxeYXjudgw8XjgksdTcD4HPTDy
 RbEGWALysX0rwpKjiLCot612980H8FpvMBQ22Bgk/xzwi03pU7ojyuRp+7cTqt1Nio9L
 SZ0xz81dvlPW7vTf6Jh7cPlT/NjCteOMAUMwOWr3awqgYCMOz3846SgZSAjE+HXT4jeK 8A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wjy1je8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:13 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18KDFECf017775;
        Mon, 20 Sep 2021 09:25:12 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b5wjy1jd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 09:25:12 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18KDD6h6031002;
        Mon, 20 Sep 2021 13:25:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3b57cj86sh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 20 Sep 2021 13:25:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18KDP69H40042988
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Sep 2021 13:25:06 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41DBAA4057;
        Mon, 20 Sep 2021 13:25:06 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB5CAA4055;
        Mon, 20 Sep 2021 13:25:05 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.9.241])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 20 Sep 2021 13:25:05 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ulrich.Weigand@de.ibm.com
Subject: [PATCH v5 05/14] KVM: s390: pv: leak the topmost page table when destroy fails
Date:   Mon, 20 Sep 2021 15:24:53 +0200
Message-Id: <20210920132502.36111-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210920132502.36111-1-imbrenda@linux.ibm.com>
References: <20210920132502.36111-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: X9x0nMNu_vjgNNIvE_zM7mijciIYwSaU
X-Proofpoint-ORIG-GUID: yd5mALIlkL8ufTArLZ5cwZtJyFXm-3_I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-20_07,2021-09-20_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 clxscore=1015 suspectscore=0 priorityscore=1501
 adultscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109200079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Each secure guest must have a unique address space control element and
we must avoid that new guests use the same ASCE, to avoid errors.
Since the ASCE mostly consists of the topmost page table address (and
flags), we must not return that memory to the pool unless the ASCE is
no longer in use.

Only a successful Destroy Secure Configuration UVC will make the ASCE
reusable again. If the Destroy Configuration UVC fails, the ASCE
cannot be reused for a secure guest (either for the ASCE or for other
memory areas). To avoid a collision, it must not be used again.

This is a permanent error and the page becomes in practice unusable, so
we set it aside and leak it. On failure we already leak other memory
that belongs to the ultravisor (i.e. the variable and base storage for
a guest) and not leaking the topmost page table was an oversight.

This error should not happen unless the hardware is broken or KVM has
some unknown serious bug.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  2 ++
 arch/s390/kvm/pv.c           |  4 ++-
 arch/s390/mm/gmap.c          | 55 ++++++++++++++++++++++++++++++++++++
 3 files changed, 60 insertions(+), 1 deletion(-)

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
index 00d272d134c2..76b0d64ce8fa 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -168,9 +168,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	atomic_set(&kvm->mm->context.is_protected, 0);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
-	/* Inteded memory leak on "impossible" error */
+	/* Intended memory leak on "impossible" error */
 	if (!cc)
 		kvm_s390_pv_dealloc_vm(kvm);
+	else
+		s390_replace_asce(kvm->arch.gmap);
 	return cc ? -EIO : 0;
 }
 
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 9bb2c7512cd5..5a138f6220c4 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2706,3 +2706,58 @@ void s390_reset_acc(struct mm_struct *mm)
 	mmput(mm);
 }
 EXPORT_SYMBOL_GPL(s390_reset_acc);
+
+/*
+ * Remove the topmost level of page tables from the list of page tables of
+ * the gmap.
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
+/*
+ * Try to replace the current ASCE with another equivalent one.
+ * If the allocation of the new top level page table fails, the ASCE is not
+ * replaced.
+ * In any case, the old ASCE is removed from the list, therefore the caller
+ * has to make sure to save a pointer to it beforehands, unless an
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

