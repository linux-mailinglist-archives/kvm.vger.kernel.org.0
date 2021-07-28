Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B1933D907D
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 16:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237108AbhG1O0z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 10:26:55 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:19490 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236979AbhG1O0p (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 10:26:45 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SENPiO052655;
        Wed, 28 Jul 2021 10:26:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=pSD6iL4VbgZFGdwWWZaBv3AxV71jLUzQK3+a44HALS8=;
 b=NLlyYJE4hyLMKillLZ6kIHkiCkBFfQIIxZCIzK0snE7jtKOhuGlYqjI901rOikxh2bvg
 p371NXDsGv/VHOK+1S3AeX/vEb9Mx1IqPn+kduNAopwRTl9WFJXS291G4VVJJUC3CHe4
 UvVTyToLvV5L06uhe0lCN9orIzI95S7G9pG1XeSvwlBzx+y9AqMWzdUj5smsfv0s4+df
 9c/Y+qQiKKrhKlnI8yHLESOd/BCI2iruwPKEqeFNSMc3vmpdG5Rpyj/R4qqq5x0kfaMF
 PNDcHELTdGF6qti3c3T74NKvhuDRxL62WO75XJF/9hVc/69BS1pLsUEsFEc2dLMfPbpC Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a38tere17-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:43 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16SENT29053225;
        Wed, 28 Jul 2021 10:26:43 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a38tere0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 10:26:43 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16SEJ87m024334;
        Wed, 28 Jul 2021 14:26:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3a235yh4k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 28 Jul 2021 14:26:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16SEQbru25821656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Jul 2021 14:26:37 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BBEEEA4053;
        Wed, 28 Jul 2021 14:26:37 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61189A4040;
        Wed, 28 Jul 2021 14:26:37 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.9.194])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 28 Jul 2021 14:26:37 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     cohuck@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, david@redhat.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 02/13] KVM: s390: pv: leak the ASCE page when destroy fails
Date:   Wed, 28 Jul 2021 16:26:20 +0200
Message-Id: <20210728142631.41860-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210728142631.41860-1-imbrenda@linux.ibm.com>
References: <20210728142631.41860-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9xoDUcRIV-yvPjGk0GOmJo43ddEZ3al2
X-Proofpoint-ORIG-GUID: TruLFZDE12OHVgwNsCrzEq1RWVPbhflv
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-28_08:2021-07-27,2021-07-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 spamscore=0
 clxscore=1015 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0
 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a protected VM is created, the topmost level of page tables of its
ASCE is marked by the Ultravisor; any attempt to use that memory for
protected virtualization will result in failure.

Only a successful Destroy Configuration UVC will remove the marking.

When the Destroy Configuration UVC fails, the topmost level of page
tables of the VM does not get its marking cleared; to avoid issues it
must not be used again.

Since the page becomes in practice unusable, we set it aside and leak it.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/pv.c | 53 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index e007df11a2fe..1ecdc1769ed9 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -155,6 +155,55 @@ static int kvm_s390_pv_alloc_vm(struct kvm *kvm)
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
@@ -169,9 +218,11 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
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

