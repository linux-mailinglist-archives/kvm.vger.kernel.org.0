Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1713E30BD
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2019 13:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408168AbfJXLmH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 07:42:07 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24740 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2409216AbfJXLmH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Oct 2019 07:42:07 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x9OBb8N2137768
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:06 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2vub4qgek5-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 07:42:06 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <frankja@linux.ibm.com>;
        Thu, 24 Oct 2019 12:42:03 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 24 Oct 2019 12:42:01 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x9OBfxhO60882960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 11:42:00 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B94F55204F;
        Thu, 24 Oct 2019 11:41:59 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.152.224.131])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 37B5252051;
        Thu, 24 Oct 2019 11:41:58 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        borntraeger@de.ibm.com, imbrenda@linux.ibm.com,
        mihajlov@linux.ibm.com, mimu@linux.ibm.com, cohuck@redhat.com,
        gor@linux.ibm.com, frankja@linux.ibm.com
Subject: [RFC 09/37] KVM: s390: protvirt: Implement on-demand pinning
Date:   Thu, 24 Oct 2019 07:40:31 -0400
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024114059.102802-1-frankja@linux.ibm.com>
References: <20191024114059.102802-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19102411-0020-0000-0000-0000037DCE84
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19102411-0021-0000-0000-000021D414EA
Message-Id: <20191024114059.102802-10-frankja@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-24_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=741 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1910240115
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Claudio Imbrenda <imbrenda@linux.ibm.com>

Pin the guest pages when they are first accessed, instead of all at
the same time when starting the guest.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/include/asm/gmap.h |  1 +
 arch/s390/include/asm/uv.h   |  6 +++++
 arch/s390/kernel/uv.c        | 20 ++++++++++++++
 arch/s390/kvm/kvm-s390.c     |  2 ++
 arch/s390/kvm/pv.c           | 51 ++++++++++++++++++++++++++++++------
 5 files changed, 72 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 99b3eedda26e..483f64427c0e 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -63,6 +63,7 @@ struct gmap {
 	struct gmap *parent;
 	unsigned long orig_asce;
 	unsigned long se_handle;
+	struct page **pinned_pages;
 	int edat_level;
 	bool removed;
 	bool initialized;
diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index 99cdd2034503..9ce9363aee1c 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -298,6 +298,7 @@ static inline int uv_convert_from_secure(unsigned long paddr)
 	return -EINVAL;
 }
 
+int kvm_s390_pv_pin_page(struct gmap *gmap, unsigned long gpa);
 /*
  * Requests the Ultravisor to make a page accessible to a guest
  * (import). If it's brought in the first time, it will be cleared. If
@@ -317,6 +318,11 @@ static inline int uv_convert_to_secure(struct gmap *gmap, unsigned long gaddr)
 		.gaddr = gaddr
 	};
 
+	down_read(&gmap->mm->mmap_sem);
+	cc = kvm_s390_pv_pin_page(gmap, gaddr);
+	up_read(&gmap->mm->mmap_sem);
+	if (cc)
+		return cc;
 	cc = uv_call(0, (u64)&uvcb);
 
 	if (!cc)
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index f7778493e829..36554402b5c6 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -98,4 +98,24 @@ void adjust_to_uv_max(unsigned long *vmax)
 	if (prot_virt_host && *vmax > uv_info.max_sec_stor_addr)
 		*vmax = uv_info.max_sec_stor_addr;
 }
+
+int kvm_s390_pv_pin_page(struct gmap *gmap, unsigned long gpa)
+{
+	unsigned long hva, gfn = gpa / PAGE_SIZE;
+	int rc;
+
+	if (!gmap->pinned_pages)
+		return -EINVAL;
+	hva = __gmap_translate(gmap, gpa);
+	if (IS_ERR_VALUE(hva))
+		return -EFAULT;
+	if (gmap->pinned_pages[gfn])
+		return -EEXIST;
+	rc = get_user_pages_fast(hva, 1, FOLL_WRITE, gmap->pinned_pages + gfn);
+	if (rc < 0)
+		return rc;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(kvm_s390_pv_pin_page);
+
 #endif
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index d1ba12f857e7..490fde080107 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -2196,6 +2196,7 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		/* All VCPUs have to be destroyed before this call. */
 		mutex_lock(&kvm->lock);
 		kvm_s390_vcpu_block_all(kvm);
+		kvm_s390_pv_unpin(kvm);
 		r = kvm_s390_pv_destroy_vm(kvm);
 		if (!r)
 			kvm_s390_pv_dealloc_vm(kvm);
@@ -2680,6 +2681,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	kvm_s390_gisa_destroy(kvm);
 	if (IS_ENABLED(CONFIG_KVM_S390_PROTECTED_VIRTUALIZATION_HOST) &&
 	    kvm_s390_pv_is_protected(kvm)) {
+		kvm_s390_pv_unpin(kvm);
 		kvm_s390_pv_destroy_vm(kvm);
 		kvm_s390_pv_dealloc_vm(kvm);
 	}
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 80aecd5bea9e..383e660e2221 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -15,8 +15,35 @@
 #include <asm/mman.h>
 #include "kvm-s390.h"
 
+static void unpin_destroy(struct page **pages, int nr)
+{
+	int i;
+	struct page *page;
+	u8 *val;
+
+	for (i = 0; i < nr; i++) {
+		page = pages[i];
+		if (!page)	/* page was never used */
+			continue;
+		val = (void *)page_to_phys(page);
+		READ_ONCE(*val);
+		put_page(page);
+	}
+}
+
+void kvm_s390_pv_unpin(struct kvm *kvm)
+{
+	unsigned long npages = kvm->arch.pv.guest_len / PAGE_SIZE;
+
+	mutex_lock(&kvm->slots_lock);
+	unpin_destroy(kvm->arch.gmap->pinned_pages, npages);
+	mutex_unlock(&kvm->slots_lock);
+}
+
 void kvm_s390_pv_dealloc_vm(struct kvm *kvm)
 {
+	vfree(kvm->arch.gmap->pinned_pages);
+	kvm->arch.gmap->pinned_pages = NULL;
 	vfree(kvm->arch.pv.stor_var);
 	free_pages(kvm->arch.pv.stor_base,
 		   get_order(uv_info.guest_base_stor_len));
@@ -28,7 +55,6 @@ int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	unsigned long base = uv_info.guest_base_stor_len;
 	unsigned long virt = uv_info.guest_virt_var_stor_len;
 	unsigned long npages = 0, vlen = 0;
-	struct kvm_memslots *slots;
 	struct kvm_memory_slot *memslot;
 
 	kvm->arch.pv.stor_var = NULL;
@@ -43,22 +69,26 @@ int kvm_s390_pv_alloc_vm(struct kvm *kvm)
 	 * Slots are sorted by GFN
 	 */
 	mutex_lock(&kvm->slots_lock);
-	slots = kvm_memslots(kvm);
-	memslot = slots->memslots;
+	memslot = kvm_memslots(kvm)->memslots;
 	npages = memslot->base_gfn + memslot->npages;
-
 	mutex_unlock(&kvm->slots_lock);
+
+	kvm->arch.gmap->pinned_pages = vzalloc(npages * sizeof(struct page *));
+	if (!kvm->arch.gmap->pinned_pages)
+		goto out_err;
 	kvm->arch.pv.guest_len = npages * PAGE_SIZE;
 
 	/* Allocate variable storage */
 	vlen = ALIGN(virt * ((npages * PAGE_SIZE) / HPAGE_SIZE), PAGE_SIZE);
 	vlen += uv_info.guest_virt_base_stor_len;
 	kvm->arch.pv.stor_var = vzalloc(vlen);
-	if (!kvm->arch.pv.stor_var) {
-		kvm_s390_pv_dealloc_vm(kvm);
-		return -ENOMEM;
-	}
+	if (!kvm->arch.pv.stor_var)
+		goto out_err;
 	return 0;
+
+out_err:
+	kvm_s390_pv_dealloc_vm(kvm);
+	return -ENOMEM;
 }
 
 int kvm_s390_pv_destroy_vm(struct kvm *kvm)
@@ -216,6 +246,11 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 	for (i = 0; i < size / PAGE_SIZE; i++) {
 		uvcb.gaddr = addr + i * PAGE_SIZE;
 		uvcb.tweak[1] = i * PAGE_SIZE;
+		down_read(&kvm->mm->mmap_sem);
+		rc = kvm_s390_pv_pin_page(kvm->arch.gmap, uvcb.gaddr);
+		up_read(&kvm->mm->mmap_sem);
+		if (rc && (rc != -EEXIST))
+			break;
 retry:
 		rc = uv_call(0, (u64)&uvcb);
 		if (!rc)
-- 
2.20.1

