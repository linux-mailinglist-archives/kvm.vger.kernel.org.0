Return-Path: <kvm+bounces-64360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A6681C804E4
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:58:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 27FB14E5C77
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:57:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53FD1302746;
	Mon, 24 Nov 2025 11:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="E2iu8gzD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83818302156;
	Mon, 24 Nov 2025 11:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985380; cv=none; b=HSBI5hIeDopppSqNRNOBuxDyoJBK0IKyWFWufoCY84Fn25rzo+DYEZzAptvzlXeJKFMY2NckycApFwzcm+imltYy4r25uID8u7JHSIU7pbY31hVFKUwbq6+seeunzN5oFy4nBUdhcu0b69922abcvTidQMjfVybmWYt/qh1YGMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985380; c=relaxed/simple;
	bh=drRAYhaKeCpm2Wb5BXeML0ALeSOTJoZaXmajlaaUhG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZOEIjFvC+/dicbDVwW5tGG+F0MNll3LxICJTbo0BH0sfpgSUaw8mRw7IRbs6pen6I3U6UAhVeTdRCwvvZbqEtPtcvZ553anIDy5OMFiAHwJYXiU73CFtEkMdbJAVtPMxEfJY16p9vVQ6hHD5A7xKkSHZuw4LIc+byyXaEIurzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=E2iu8gzD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO9flWw003417;
	Mon, 24 Nov 2025 11:56:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=T6CKg4sqfm3emsu/q
	zexgqOn1j36sSwAQAN4WhUZ42Q=; b=E2iu8gzDUFeTqwG92ybj3ZnEkYXZwRWed
	+/KtrKC8elhspoEt2MGiew0YCRxs8FOpoGBjcGoMVNxqYwsDpzEuaueI/415IWr0
	C8SS2+ZPTOO8xTBM2IhhLBk90TIbT2tHoh2964s177Ff/qJGqTGWBJU81L5Cvh4+
	50d3u22qFNWlExwbD6bD6K5rbUW7Hkf/3oH6VlRfUqXmLPNJVTzv+LvrlhKorG1F
	WitcBFNopo9lCv6ddcDN+t4wPhQ6IVA4jMNjpwm3L+mr0bcMUwoeHW3zcvgiDGVf
	2FTwSKhdtrmvjMSH+nx2F6dzYn/ShOY/qG9N4g6SeZ8Wk0KbJNz4g==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4u1qdt5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:16 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOAEGCJ000861;
	Mon, 24 Nov 2025 11:56:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4akqvxnupc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:15 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBuBk840501608
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:11 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9EC020043;
	Mon, 24 Nov 2025 11:56:11 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA1DC20040;
	Mon, 24 Nov 2025 11:56:09 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:09 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 08/23] KVM: s390: KVM page table management functions: allocation
Date: Mon, 24 Nov 2025 12:55:39 +0100
Message-ID: <20251124115554.27049-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251124115554.27049-1-imbrenda@linux.ibm.com>
References: <20251124115554.27049-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX2C6JTKo8rNHN
 WfhOrK0gZI6lnqo4Tpm0Rpr2meu15T0zeUMSTS2XYdazBRfwO/0DQIrHdWIMttJySsa29V5JhI9
 kYTZryp5N4PT9iJ5SCn6lWBd8O4MZGxlV3FTHTCe2s5bLHtUJT4i+VuszeZzUC9AVK5haSFBZak
 UoWx2tAxoicYzStQdRWBK5lUfueX4xw2X73C/rCHyg2lAOJVL0SSF7vDAetz7r/54DwueBB+ipd
 7Xd5cDpa1rs6l+3JUZWyVkTNjMGVQQ4I7hjnlCG4w/4q7E6yjfLJQ3b8lsbLxDgJqSdcDWsUFJ5
 Dp09y6itNEQnfKUZ90wdzy+BqihdblESpj+6yojjXUzwTRaUuoKZpa/UFUzu3yPOVBuk9u2ck58
 0pzVAzHKg0YIX/UH6v/Foltj4uy4vA==
X-Authority-Analysis: v=2.4 cv=SuidKfO0 c=1 sm=1 tr=0 ts=692447e0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8
 a=ciOewYurfqE_QU1RCzEA:9
X-Proofpoint-ORIG-GUID: RvJcqyPakJCVhVRgZPNbVyaICqMFSkJO
X-Proofpoint-GUID: RvJcqyPakJCVhVRgZPNbVyaICqMFSkJO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220021

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds the boilerplate and functions for the allocation and
deallocation of DAT tables.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/Makefile     |   1 +
 arch/s390/kvm/dat.c        | 103 +++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h        |  77 +++++++++++++++++++++++++++
 arch/s390/mm/page-states.c |   1 +
 4 files changed, 182 insertions(+)
 create mode 100644 arch/s390/kvm/dat.c

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 9a723c48b05a..84315d2f75fb 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,6 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
+kvm-y += dat.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
new file mode 100644
index 000000000000..c324a27f379f
--- /dev/null
+++ b/arch/s390/kvm/dat.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2020, 2024
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ *		 Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *		 David Hildenbrand <david@redhat.com>
+ *		 Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/pagewalk.h>
+#include <linux/swap.h>
+#include <linux/smp.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/swapops.h>
+#include <linux/ksm.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/pgtable.h>
+#include <linux/kvm_types.h>
+#include <linux/kvm_host.h>
+#include <linux/pgalloc.h>
+
+#include <asm/page-states.h>
+#include <asm/tlb.h>
+#include "dat.h"
+
+int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc)
+{
+	void *o;
+
+	for ( ; mc->n_crsts < KVM_S390_MMU_CACHE_N_CRSTS; mc->n_crsts++) {
+		o = (void *)__get_free_pages(GFP_KERNEL_ACCOUNT | __GFP_COMP, CRST_ALLOC_ORDER);
+		if (!o)
+			return -ENOMEM;
+		mc->crsts[mc->n_crsts] = o;
+	}
+	for ( ; mc->n_pts < KVM_S390_MMU_CACHE_N_PTS; mc->n_pts++) {
+		o = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
+		if (!o)
+			return -ENOMEM;
+		mc->pts[mc->n_pts] = o;
+	}
+	for ( ; mc->n_rmaps < KVM_S390_MMU_CACHE_N_RMAPS; mc->n_rmaps++) {
+		o = kzalloc(sizeof(*mc->rmaps[0]), GFP_KERNEL_ACCOUNT);
+		if (!o)
+			return -ENOMEM;
+		mc->rmaps[mc->n_rmaps] = o;
+	}
+	return 0;
+}
+
+static inline struct page_table *dat_alloc_pt_noinit(struct kvm_s390_mmu_cache *mc)
+{
+	struct page_table *res;
+
+	res = kvm_s390_mmu_cache_alloc_pt(mc);
+	if (res)
+		__arch_set_page_dat(res, 1);
+	return res;
+}
+
+static inline struct crst_table *dat_alloc_crst_noinit(struct kvm_s390_mmu_cache *mc)
+{
+	struct crst_table *res;
+
+	res = kvm_s390_mmu_cache_alloc_crst(mc);
+	if (res)
+		__arch_set_page_dat(res, 1UL << CRST_ALLOC_ORDER);
+	return res;
+}
+
+struct crst_table *dat_alloc_crst_sleepable(unsigned long init)
+{
+	struct page *page;
+	void *virt;
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_COMP, CRST_ALLOC_ORDER);
+	if (!page)
+		return NULL;
+	virt = page_to_virt(page);
+	__arch_set_page_dat(virt, 1UL << CRST_ALLOC_ORDER);
+	crst_table_init(virt, init);
+	return virt;
+}
+
+void dat_free_level(struct crst_table *table, bool owns_ptes)
+{
+	unsigned int i;
+
+	for (i = 0; i < _CRST_ENTRIES; i++) {
+		if (table->crstes[i].h.fc || table->crstes[i].h.i)
+			continue;
+		if (!is_pmd(table->crstes[i]))
+			dat_free_level(dereference_crste(table->crstes[i]), owns_ptes);
+		else if (owns_ptes)
+			dat_free_pt(dereference_pmd(table->crstes[i].pmd));
+	}
+	dat_free_crst(table);
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index 4d2b7a7bf898..486b7dfc5df2 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -418,6 +418,46 @@ struct vsie_rmap {
 
 static_assert(sizeof(struct vsie_rmap) == 2 * sizeof(long));
 
+#define KVM_S390_MMU_CACHE_N_CRSTS	6
+#define KVM_S390_MMU_CACHE_N_PTS	2
+#define KVM_S390_MMU_CACHE_N_RMAPS	16
+struct kvm_s390_mmu_cache {
+	void *crsts[KVM_S390_MMU_CACHE_N_CRSTS];
+	void *pts[KVM_S390_MMU_CACHE_N_PTS];
+	void *rmaps[KVM_S390_MMU_CACHE_N_RMAPS];
+	short int n_crsts;
+	short int n_pts;
+	short int n_rmaps;
+};
+
+void dat_free_level(struct crst_table *table, bool owns_ptes);
+struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
+
+int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc);
+
+#define GFP_KVM_S390_MMU_CACHE (GFP_ATOMIC | __GFP_ACCOUNT | __GFP_NOWARN)
+
+static inline struct page_table *kvm_s390_mmu_cache_alloc_pt(struct kvm_s390_mmu_cache *mc)
+{
+	if (mc->n_pts)
+		return mc->pts[--mc->n_pts];
+	return (void *)__get_free_page(GFP_KVM_S390_MMU_CACHE);
+}
+
+static inline struct crst_table *kvm_s390_mmu_cache_alloc_crst(struct kvm_s390_mmu_cache *mc)
+{
+	if (mc->n_crsts)
+		return mc->crsts[--mc->n_crsts];
+	return (void *)__get_free_pages(GFP_KVM_S390_MMU_CACHE | __GFP_COMP, CRST_ALLOC_ORDER);
+}
+
+static inline struct vsie_rmap *kvm_s390_mmu_cache_alloc_rmap(struct kvm_s390_mmu_cache *mc)
+{
+	if (mc->n_rmaps)
+		return mc->rmaps[--mc->n_rmaps];
+	return kzalloc(sizeof(struct vsie_rmap), GFP_KVM_S390_MMU_CACHE);
+}
+
 static inline struct crst_table *crste_table_start(union crste *crstep)
 {
 	return (struct crst_table *)ALIGN_DOWN((unsigned long)crstep, _CRST_TABLE_SIZE);
@@ -717,4 +757,41 @@ static inline void pgste_set_unlock(union pte *ptep, union pgste pgste)
 	WRITE_ONCE(*pgste_of(ptep), pgste);
 }
 
+static inline void dat_free_pt(struct page_table *pt)
+{
+	free_page((unsigned long)pt);
+}
+
+static inline void _dat_free_crst(struct crst_table *table)
+{
+	free_pages((unsigned long)table, CRST_ALLOC_ORDER);
+}
+
+#define dat_free_crst(x) _dat_free_crst(_CRSTP(x))
+
+static inline void kvm_s390_free_mmu_cache(struct kvm_s390_mmu_cache *mc)
+{
+	if (!mc)
+		return;
+	while (mc->n_pts)
+		dat_free_pt(mc->pts[--mc->n_pts]);
+	while (mc->n_crsts)
+		_dat_free_crst(mc->crsts[--mc->n_crsts]);
+	while (mc->n_rmaps)
+		kfree(mc->rmaps[--mc->n_rmaps]);
+	kfree(mc);
+}
+
+DEFINE_FREE(kvm_s390_mmu_cache, struct kvm_s390_mmu_cache *, if (_T) kvm_s390_free_mmu_cache(_T))
+
+static inline struct kvm_s390_mmu_cache *kvm_s390_new_mmu_cache(void)
+{
+	struct kvm_s390_mmu_cache *mc __free(kvm_s390_mmu_cache);
+
+	mc = kzalloc(sizeof(*mc), GFP_KERNEL_ACCOUNT);
+	if (mc && !kvm_s390_mmu_cache_topup(mc))
+		return_ptr(mc);
+	return NULL;
+}
+
 #endif /* __KVM_S390_DAT_H */
diff --git a/arch/s390/mm/page-states.c b/arch/s390/mm/page-states.c
index 01f9b39e65f5..5bee173db72e 100644
--- a/arch/s390/mm/page-states.c
+++ b/arch/s390/mm/page-states.c
@@ -13,6 +13,7 @@
 #include <asm/page.h>
 
 int __bootdata_preserved(cmma_flag);
+EXPORT_SYMBOL(cmma_flag);
 
 void arch_free_page(struct page *page, int order)
 {
-- 
2.51.1


