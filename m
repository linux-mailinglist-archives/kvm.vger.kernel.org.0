Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E45D38653C
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 22:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbhEQUJX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 16:09:23 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30730 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S236497AbhEQUJW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 17 May 2021 16:09:22 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14HK4v2l019616;
        Mon, 17 May 2021 16:08:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=Dq8CDOmkbZsAISdoFN/+ceHwBaHeZdaj9ZesXmFNfbM=;
 b=DtvQ6GVeVfSN5oK8osdoK+S5t40IfjHeXs3d/NGD146PzDeF1u28sKB+1OmyYxpfNW0b
 HijdPwhlTtWm4rd7/8Iba3Vv0lEUEJxYzgf0wPKvAA9aRyZRyprWUO7NoS4xez9FHvQZ
 1SkAKT4krtilROZRryDJ2OGRAUmAZ0yMAFVupQTYQAlw8iBz9Ui6Me4MGkgykIKlmYIG
 5PWzxQiWrwsmg6QWVx7v1EEOciEOEaTHxfDKPOhioSdM+QgOY97VrL+wGTaYLlUlAf3w
 pM+nqCKENhGA9Je5mJNHAVHRqnK3dnT1p5ZK7fz868u3CGnltrlzxf9N7Ra8d8WghEQ0 fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38kxqkgt86-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:05 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14HK5qiM023248;
        Mon, 17 May 2021 16:08:04 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38kxqkgt7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 16:08:04 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14HK821M005715;
        Mon, 17 May 2021 20:08:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 38j5x7s2nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 May 2021 20:08:02 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14HK7W6H14090574
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 May 2021 20:07:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0A545204F;
        Mon, 17 May 2021 20:07:59 +0000 (GMT)
Received: from ibm-vm.ibmuc.com (unknown [9.145.14.34])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7C5F752057;
        Mon, 17 May 2021 20:07:59 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 01/11] KVM: s390: pv: leak the ASCE page when destroy fails
Date:   Mon, 17 May 2021 22:07:48 +0200
Message-Id: <20210517200758.22593-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517200758.22593-1-imbrenda@linux.ibm.com>
References: <20210517200758.22593-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0rB_ZRJ35arQylfAE42yIiqigOF-bIpe
X-Proofpoint-ORIG-GUID: Rwe51-haDvvLR1BBUuc8nIfAQykemdKl
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-17_08:2021-05-17,2021-05-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 lowpriorityscore=0 adultscore=0 spamscore=0 mlxscore=0
 impostorscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105170140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the destroy configuration UVC fails, the page pointed to by the
ASCE of the VM becomes poisoned, and, to avoid issues it must not be
used again.

Since the page becomes in practice unusable, we set it aside and leak it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 53 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 813b6e93dc83..e0532ab725bf 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -150,6 +150,55 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	return -ENOMEM;
 }
 
+/*
+ * Remove the topmost level of page tables from the list of page tables of
+ * the gmap.
+ * This means that it will not be freed when the VM is torn down, and needs
+ * to be handled separately by the caller, unless an intentional leak is
+ * intended.
+ */
+static void kvm_s390_pv_remove_old_asce(struct kvm *kvm)
+{
+	struct page *old;
+
+	old = virt_to_page(kvm->arch.gmap->table);
+	list_del(&old->lru);
+	/* in case the ASCE needs to be "removed" multiple times */
+	INIT_LIST_HEAD(&old->lru);
+}
+
+/*
+ * Try to replace the current ASCE with another equivalent one.
+ * If the allocation of the new top level page table fails, the ASCE is not
+ * replaced.
+ * In any case, the old ASCE is removed from the list, therefore the caller
+ * has to make sure to save a pointer to it beforehands, unless an
+ * intentional leak is intended.
+ */
+static int kvm_s390_pv_replace_asce(struct kvm *kvm)
+{
+	unsigned long asce;
+	struct page *page;
+	void *table;
+
+	kvm_s390_pv_remove_old_asce(kvm);
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, CRST_ALLOC_ORDER);
+	if (!page)
+		return -ENOMEM;
+	list_add(&page->lru, &kvm->arch.gmap->crst_list);
+
+	table = page_to_virt(page);
+	memcpy(table, kvm->arch.gmap->table, 1UL << (CRST_ALLOC_ORDER + PAGE_SHIFT));
+
+	asce = (kvm->arch.gmap->asce & ~PAGE_MASK) | __pa(table);
+	WRITE_ONCE(kvm->arch.gmap->asce, asce);
+	WRITE_ONCE(kvm->mm->context.gmap_asce, asce);
+	WRITE_ONCE(kvm->arch.gmap->table, table);
+
+	return 0;
+}
+
 /* this should not fail, but if it does, we must not free the donated memory */
 int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
@@ -164,9 +213,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	atomic_set(&kvm->mm->context.is_protected, 0);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM: rc %x rrc %x", *rc, *rrc);
 	WARN_ONCE(cc, "protvirt destroy vm failed rc %x rrc %x", *rc, *rrc);
-	/* Inteded memory leak on "impossible" error */
+	/* Intended memory leak on "impossible" error */
 	if (!cc)
 		kvm_s390_pv_dealloc_vm(kvm);
+	else
+		kvm_s390_pv_replace_asce(kvm);
 	return cc ? -EIO : 0;
 }
 
-- 
2.31.1

