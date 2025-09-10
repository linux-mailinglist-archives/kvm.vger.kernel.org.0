Return-Path: <kvm+bounces-57239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F87EB51FE9
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:09:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 252001C85837
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:10:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A39E33CEBC;
	Wed, 10 Sep 2025 18:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="YJhZpBn4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F4F343D88;
	Wed, 10 Sep 2025 18:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527690; cv=none; b=lPC6PRAF3aMAjm11C9Hel6dFBczcTfLubBgb9Hkz6b4x+/1xsqudrhSIykJzCj6anQQedlOZW4ehP9j48JtqBijZxCuEJkqG+zdzZlpPu6x0W3ME5KgL/FhNFAGKH2UdWhMBICXXdjNRt9Dkjvja9vR67NdJgEs2x0KZ/aldF9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527690; c=relaxed/simple;
	bh=KMowxuhnH0EKiKUyGDU3Oxgvr4Jj2zrxgswyxyF8uK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bA9LOLIaTcWxTZNT96r613QJ0N9THNYPMQnPfnLyTrmQXUY+Xa2mq/KzRD37Fcjtdt+tTG+q4LNWSZpb61vca3NBXe+dcaVK8L9QrUQZ/SjqLswoJORQsBApOG/9jtXMbxWb/uFncOz9RhULvFAsuKEYt0whL8YG06PniXUZdiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=YJhZpBn4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AHiQKH021580;
	Wed, 10 Sep 2025 18:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=YxIpNA4vaJrFmb3MI
	EqUFyjGJ7zkNbfs2SczLf5SMqA=; b=YJhZpBn4U/U4wxtPurWJ9QjqZKzcSz9QO
	HtYoSB2wyaDmm/jz5jWDi69mt9UzxUXd2P3r1iE4QYqBeG1/gmLCafFsrXd2OeB3
	/ba5wB4ni3OLyoEyIlAWVpr92N7hlBfk6WiDOcPQe7nazEKYmAgT/Yd2tvRXPa1i
	fZ6JHh5TbR858qUdffowtbTjJQyldV19WK2+3kqxVssKNc4lj5knIy9hJ8S3wqzx
	nY1eSU76NeJROEju0S8+g42FpQ+J+dalR8hepHel683OGNHPwDlvo1orkz2YMxAg
	KJV/8mBZsxhBX/+BvLBTOGXLs5jfGVDG3wKYpzdIyDb1b0NCWzK6w==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490bcsygeg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:55 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AFskoR011447;
	Wed, 10 Sep 2025 18:07:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9uj3ug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7oP119005822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AEBF2004B;
	Wed, 10 Sep 2025 18:07:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 436AF2004E;
	Wed, 10 Sep 2025 18:07:50 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 18:07:50 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v2 14/20] KVM: s390: New gmap code
Date: Wed, 10 Sep 2025 20:07:40 +0200
Message-ID: <20250910180746.125776-15-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910180746.125776-1-imbrenda@linux.ibm.com>
References: <20250910180746.125776-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAxMCBTYWx0ZWRfX0J2QJ1/I5810
 Zkia2c1GRB5ktKIlxjg17db5RvHO/s/udwPGMHnwbi5MEwkCsTaO66q8vOCVu1kOqBtWDQkRhBY
 iCylvI6zYPUgTChZvXJIVgfGW/aurFat6ZlCVTEFApYKsJAxBOSYz5BF0Acn4rBjJVn7I4DVXbC
 WtCBBijwnGnXiUH0/AyUc42h6RkICPdWrJrmSUyDzdB9maVUF5j6HyxvC6YIg/0BA+awAvr6KZo
 s+ZhKAsBdNBISER+mXroq9shz/225RFLhVJmxfgTr2ep/K3onyMJOxfd0Ko4dXYo9V/Qyxkk2tX
 YmiRdOSCrmKrt0hRIG3uYUku9hKZz5wLG8Z90vk78rJ5zsHcG6FlzbLl5+H70egQ2jgEo1SjDdr
 XuDruSY0
X-Authority-Analysis: v=2.4 cv=SKNCVPvH c=1 sm=1 tr=0 ts=68c1be7b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=YtlQhoF0TyINYD2ESs0A:9
 a=EJ4Iv7yGYRf0Cjte:21
X-Proofpoint-GUID: 8-IZ1d-1Cww2jn67T1hXwATE18_tll9A
X-Proofpoint-ORIG-GUID: 8-IZ1d-1Cww2jn67T1hXwATE18_tll9A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 adultscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060010

New gmap (guest map) code. This new gmap code will only be used by KVM.

This will replace the existing gmap.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/Makefile |    2 +-
 arch/s390/kvm/gmap.c   | 1066 ++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/gmap.h   |  178 +++++++
 3 files changed, 1245 insertions(+), 1 deletion(-)
 create mode 100644 arch/s390/kvm/gmap.c
 create mode 100644 arch/s390/kvm/gmap.h

diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 84315d2f75fb..21088265402c 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -9,7 +9,7 @@ ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
 kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
-kvm-y += dat.o
+kvm-y += dat.o gmap.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
 obj-$(CONFIG_KVM) += kvm.o
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
new file mode 100644
index 000000000000..42c936362e3e
--- /dev/null
+++ b/arch/s390/kvm/gmap.c
@@ -0,0 +1,1066 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Guest memory management for KVM/s390
+ *
+ * Copyright IBM Corp. 2008, 2020, 2024
+ *
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ *               Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *               David Hildenbrand <david@redhat.com>
+ *               Janosch Frank <frankja@linux.ibm.com>
+ */
+
+#include <linux/compiler.h>
+#include <linux/kvm.h>
+#include <linux/kvm_host.h>
+#include <linux/pgtable.h>
+#include <linux/pagemap.h>
+#include <asm/lowcore.h>
+#include <asm/uv.h>
+#include <asm/gmap_helpers.h>
+
+#include "dat.h"
+#include "gmap.h"
+#include "kvm-s390.h"
+
+static inline bool kvm_s390_is_in_sie(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.sie_block->prog0c & PROG_IN_SIE;
+}
+
+static int gmap_limit_to_type(gfn_t limit)
+{
+	if (!limit)
+		return TABLE_TYPE_REGION1;
+	if (limit <= _REGION3_SIZE >> PAGE_SHIFT)
+		return TABLE_TYPE_SEGMENT;
+	if (limit <= _REGION2_SIZE >> PAGE_SHIFT)
+		return TABLE_TYPE_REGION3;
+	if (limit <= _REGION1_SIZE >> PAGE_SHIFT)
+		return TABLE_TYPE_REGION2;
+	return TABLE_TYPE_REGION1;
+}
+
+/**
+ * gmap_alloc - allocate and initialize a guest address space
+ * @limit: maximum address of the gmap address space
+ *
+ * Returns a guest address space structure.
+ */
+struct gmap *gmap_new(struct kvm *kvm, gfn_t limit)
+{
+	struct crst_table *table;
+	struct gmap *gmap;
+	int type;
+
+	type = gmap_limit_to_type(limit);
+
+	gmap = kzalloc(sizeof(*gmap), GFP_KERNEL_ACCOUNT);
+	if (!gmap)
+		return NULL;
+	INIT_LIST_HEAD(&gmap->children);
+	INIT_LIST_HEAD(&gmap->list);
+	INIT_LIST_HEAD(&gmap->scb_users);
+	INIT_RADIX_TREE(&gmap->host_to_rmap, GFP_ATOMIC | __GFP_ACCOUNT);
+	spin_lock_init(&gmap->children_lock);
+	spin_lock_init(&gmap->host_to_rmap_lock);
+
+	table = dat_alloc_crst(_CRSTE_EMPTY(type).val);
+	if (!table) {
+		kfree(gmap);
+		return NULL;
+	}
+
+	gmap->asce.val = __pa(table);
+	gmap->asce.dt = type;
+	gmap->asce.tl = _ASCE_TABLE_LENGTH;
+	gmap->asce.x = 1;
+	gmap->asce.p = 1;
+	gmap->asce.s = 1;
+	gmap->kvm = kvm;
+	gmap->owns_page_tables = 1;
+
+	return gmap;
+}
+
+static void gmap_add_child(struct gmap *parent, struct gmap *child)
+{
+	KVM_BUG_ON(parent && parent->is_ucontrol && parent->parent, parent->kvm);
+	KVM_BUG_ON(parent && parent->is_ucontrol && !parent->owns_page_tables, parent->kvm);
+	lockdep_assert_held(&parent->children_lock);
+
+	child->parent = parent;
+	child->is_ucontrol = parent->is_ucontrol;
+	child->allow_hpage_1m = parent->allow_hpage_1m;
+	if (kvm_is_ucontrol(parent->kvm))
+		child->owns_page_tables = 0;
+	list_add(&child->list, &parent->children);
+}
+
+struct gmap *gmap_new_child(struct gmap *parent, gfn_t limit)
+{
+	struct gmap *res;
+
+	lockdep_assert_not_held(&parent->children_lock);
+	res = gmap_new(parent->kvm, limit);
+	if (res) {
+		scoped_guard(spinlock, &parent->children_lock)
+			gmap_add_child(parent, res);
+	}
+	return res;
+}
+
+int gmap_set_limit(struct gmap *gmap, gfn_t limit)
+{
+	struct crst_table *table;
+	union crste crste;
+	int type;
+
+	lockdep_assert_held_write(&gmap->kvm->mmu_lock);
+
+	type = gmap_limit_to_type(limit);
+
+	while (gmap->asce.dt > type) {
+		table = dereference_asce(gmap->asce);
+		crste = table->crstes[0];
+		if (crste.h.fc)
+			return 0;
+		if (!crste.h.i) {
+			gmap->asce.rsto = crste.h.fc0.to;
+			dat_free_crst(table);
+		} else {
+			crste.h.tt--;
+			crst_table_init((void *)table, crste.val);
+		}
+		gmap->asce.dt--;
+	}
+	while (gmap->asce.dt < type) {
+		crste = _crste_fc0(gmap->asce.rsto, gmap->asce.dt + 1);
+		table = dat_alloc_crst(_CRSTE_HOLE(crste.h.tt).val);
+		if (!table)
+			return -ENOMEM;
+		table->crstes[0] = crste;
+		gmap->asce.rsto = __pa(table) >> PAGE_SHIFT;
+		gmap->asce.dt++;
+	}
+	return 0;
+}
+
+static void gmap_rmap_radix_tree_free(struct radix_tree_root *root)
+{
+	struct gmap_rmap *rmap, *rnext, *head;
+	struct radix_tree_iter iter;
+	unsigned long indices[16];
+	unsigned long index;
+	void __rcu **slot;
+	int i, nr;
+
+	/* A radix tree is freed by deleting all of its entries */
+	index = 0;
+	do {
+		nr = 0;
+		radix_tree_for_each_slot(slot, root, &iter, index) {
+			indices[nr] = iter.index;
+			if (++nr == 16)
+				break;
+		}
+		for (i = 0; i < nr; i++) {
+			index = indices[i];
+			head = radix_tree_delete(root, index);
+			gmap_for_each_rmap_safe(rmap, rnext, head)
+				kfree(rmap);
+		}
+	} while (nr > 0);
+}
+
+void gmap_remove_child(struct gmap *child)
+{
+	if (KVM_BUG_ON(!child->parent, child->kvm))
+		return;
+	lockdep_assert_held(&child->parent->children_lock);
+
+	list_del(&child->list);
+	child->parent = NULL;
+}
+
+/**
+ * gmap_dispose - remove and free a guest address space and its children
+ * @gmap: pointer to the guest address space structure
+ */
+void gmap_dispose(struct gmap *gmap)
+{
+	/* The gmap must have been removed from the parent beforehands */
+	KVM_BUG_ON(gmap->parent, gmap->kvm);
+	/* All children of this gmap must have been removed beforehands*/
+	KVM_BUG_ON(!list_empty(&gmap->children), gmap->kvm);
+	/* No VSIE shadow block is allowed to use this gmap */
+	KVM_BUG_ON(!list_empty(&gmap->scb_users), gmap->kvm);
+	KVM_BUG_ON(!gmap->asce.val, gmap->kvm);
+
+	/* Flush tlb of all gmaps */
+	asce_flush_tlb(gmap->asce);
+
+	/* Free all DAT tables. */
+	dat_free_level(dereference_asce(gmap->asce), gmap->owns_page_tables);
+
+	/* Free additional data for a shadow gmap */
+	if (gmap->is_shadow)
+		gmap_rmap_radix_tree_free(&gmap->host_to_rmap);
+
+	kfree(gmap);
+}
+
+/**
+ * s390_replace_asce - Try to replace the current ASCE of a gmap with a copy
+ * @gmap: the gmap whose ASCE needs to be replaced
+ *
+ * If the ASCE is a SEGMENT type then this function will return -EINVAL,
+ * otherwise the pointers in the host_to_guest radix tree will keep pointing
+ * to the wrong pages, causing use-after-free and memory corruption.
+ * If the allocation of the new top level page table fails, the ASCE is not
+ * replaced.
+ * In any case, the old ASCE is always removed from the gmap CRST list.
+ * Therefore the caller has to make sure to save a pointer to it
+ * beforehand, unless a leak is actually intended.
+ */
+int s390_replace_asce(struct gmap *gmap)
+{
+	struct crst_table *table;
+	union asce asce;
+
+	/* Replacing segment type ASCEs would cause serious issues */
+	if (gmap->asce.dt == ASCE_TYPE_SEGMENT)
+		return -EINVAL;
+
+	table = dat_alloc_crst(0);
+	if (!table)
+		return -ENOMEM;
+	memcpy(table, dereference_asce(gmap->asce), sizeof(*table));
+
+	/* Set new table origin while preserving existing ASCE control bits */
+	asce = gmap->asce;
+	asce.rsto = virt_to_pfn(table);
+	WRITE_ONCE(gmap->asce, asce);
+
+	return 0;
+}
+
+bool _gmap_unmap_prefix(struct gmap *gmap, gfn_t gfn, gfn_t end, bool hint)
+{
+	struct kvm *kvm = gmap->kvm;
+	struct kvm_vcpu *vcpu;
+	gfn_t prefix_gfn;
+	unsigned long i;
+
+	if (gmap->is_shadow)
+		return false;
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		/* match against both prefix pages */
+		prefix_gfn = gpa_to_gfn(kvm_s390_get_prefix(vcpu));
+		if (prefix_gfn < end && gfn <= prefix_gfn + 1) {
+			if (hint && kvm_s390_is_in_sie(vcpu))
+				return false;
+			VCPU_EVENT(vcpu, 2, "gmap notifier for %llx-%llx",
+				   gfn_to_gpa(gfn), gfn_to_gpa(end));
+			kvm_s390_sync_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
+		}
+	}
+	return true;
+}
+
+struct clear_young_pte_priv {
+	struct gmap *gmap;
+	bool young;
+};
+
+static long gmap_clear_young_pte(union pte *ptep, gfn_t gfn, gfn_t end, struct dat_walk *walk)
+{
+	struct clear_young_pte_priv *p = walk->priv;
+	union pgste pgste;
+	union pte pte, new;
+
+	pte = READ_ONCE(*ptep);
+
+	if (!pte.s.pr || (!pte.s.y && pte.h.i))
+		return 0;
+
+	pgste = pgste_get_lock(ptep);
+	if (!pgste.prefix_notif || gmap_mkold_prefix(p->gmap, gfn, end)) {
+		new = pte;
+		new.h.i = 1;
+		new.s.y = 0;
+		if ((new.s.d || !new.h.p) && !new.s.s)
+			folio_set_dirty(pfn_folio(pte.h.pfra));
+		new.s.d = 0;
+		new.h.p = 1;
+
+		pgste.prefix_notif = 0;
+		pgste = __dat_ptep_xchg(ptep, pgste, new, gfn, walk->asce, p->gmap->uses_skeys);
+	}
+	p->young = 1;
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+static long gmap_clear_young_crste(union crste *crstep, gfn_t gfn, gfn_t end, struct dat_walk *walk)
+{
+	struct clear_young_pte_priv *priv = walk->priv;
+	union crste crste, new;
+
+	crste = READ_ONCE(*crstep);
+
+	if (!crste.h.fc)
+		return 0;
+	if (!crste.s.fc1.y && crste.h.i)
+		return 0;
+	if (!crste_prefix(crste) || gmap_mkold_prefix(priv->gmap, gfn, end)) {
+		new = crste;
+		new.h.i = 1;
+		new.s.fc1.y = 0;
+		new.s.fc1.prefix_notif = 0;
+		if (new.s.fc1.d || !new.h.p)
+			folio_set_dirty(phys_to_folio(crste_origin_large(crste)));
+		new.s.fc1.d = 0;
+		new.h.p = 1;
+		dat_crstep_xchg(crstep, new, gfn, walk->asce);
+	}
+	priv->young = 1;
+	return 0;
+}
+
+/**
+ * gmap_age_gfn() - clear young
+ * @gmap: the guest gmap
+ * @start: the first gfn to test
+ * @end: the gfn after the last one to test
+ *
+ * Context: called with the kvm mmu write lock held
+ * Return: 1 if any page in the given range was young, otherwise 0.
+ */
+bool gmap_age_gfn(struct gmap *gmap, gfn_t start, gfn_t end)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = gmap_clear_young_pte,
+		.pmd_entry = gmap_clear_young_crste,
+		.pud_entry = gmap_clear_young_crste,
+	};
+	struct clear_young_pte_priv priv = {
+		.gmap = gmap,
+		.young = false,
+	};
+
+	_dat_walk_gfn_range(start, end, gmap->asce, &ops, 0, &priv);
+
+	return priv.young;
+}
+
+struct gmap_unmap_priv {
+	struct gmap *gmap;
+	struct kvm_memory_slot *slot;
+};
+
+static long _gmap_unmap_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *w)
+{
+	struct gmap_unmap_priv *priv = w->priv;
+	unsigned long vmaddr;
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	if (ptep->s.pr && pgste.usage == PGSTE_GPS_USAGE_UNUSED) {
+		vmaddr = __gfn_to_hva_memslot(priv->slot, gfn);
+		gmap_helper_set_unused(priv->gmap->kvm->mm, vmaddr);
+	}
+	pgste = gmap_ptep_xchg(priv->gmap, ptep, _PTE_EMPTY, pgste, gfn);
+	pgste_set_unlock(ptep, pgste);
+
+	return 0;
+}
+
+static long _gmap_unmap_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct gmap_unmap_priv *priv = walk->priv;
+
+	if (crstep->h.fc)
+		gmap_crstep_xchg(priv->gmap, crstep, _CRSTE_EMPTY(crstep->h.tt), gfn);
+
+	return 0;
+}
+
+/**
+ * gmap_unmap_gfn_range() - Unmap a range of guest addresses
+ * @gmap: the gmap to act on
+ * @start: the first gfn to unmap
+ * @end: the gfn after the last one to unmap
+ *
+ * Context: called with the kvm mmu write lock held
+ * Return: false
+ */
+bool gmap_unmap_gfn_range(struct gmap *gmap, struct kvm_memory_slot *slot, gfn_t start, gfn_t end)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = _gmap_unmap_pte,
+		.pmd_entry = _gmap_unmap_crste,
+		.pud_entry = _gmap_unmap_crste,
+	};
+	struct gmap_unmap_priv priv = {
+		.gmap = gmap,
+		.slot = slot,
+	};
+
+	lockdep_assert_held_write(&gmap->kvm->mmu_lock);
+
+	_dat_walk_gfn_range(start, end, gmap->asce, &ops, 0, &priv);
+	return false;
+}
+
+static union pgste __pte_test_and_clear_softdirty(union pte *ptep, union pgste pgste, gfn_t gfn,
+						  struct gmap *gmap)
+{
+	union pte pte = READ_ONCE(*ptep);
+
+	if (!pte.s.pr || (pte.h.p && !pte.s.sd))
+		return pgste;
+
+	/*
+	 * If this page contains one or more prefixes of vCPUS that are currently
+	 * running, do not reset the protection, leave it marked as dirty.
+	 */
+	if (!pgste.prefix_notif || gmap_mkold_prefix(gmap, gfn, gfn + 1)) {
+		pte.h.p = 1;
+		pte.s.sd = 0;
+		pgste = gmap_ptep_xchg(gmap, ptep, pte, pgste, gfn);
+	}
+
+	mark_page_dirty(gmap->kvm, gfn);
+
+	return pgste;
+}
+
+static long _pte_test_and_clear_softdirty(union pte *ptep, gfn_t gfn, gfn_t end,
+					  struct dat_walk *walk)
+{
+	struct gmap *gmap = walk->priv;
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	pgste = __pte_test_and_clear_softdirty(ptep, pgste, gfn, gmap);
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+static long _crste_test_and_clear_softdirty(union crste *table, gfn_t gfn, gfn_t end,
+					    struct dat_walk *walk)
+{
+	struct gmap *gmap = walk->priv;
+	union crste crste, new;
+
+	if (fatal_signal_pending(current))
+		return 1;
+	crste = READ_ONCE(*table);
+	if (!crste.h.fc)
+		return 0;
+	if (crste.h.p && !crste.s.fc1.sd)
+		return 0;
+
+	/*
+	 * If this large page contains one or more prefixes of vCPUs that are
+	 * currently running, do not reset the protection, leave it marked as
+	 * dirty.
+	 */
+	if (!crste.s.fc1.prefix_notif || gmap_mkold_prefix(gmap, gfn, end)) {
+		new = crste;
+		new.h.p = 1;
+		new.s.fc1.sd = 0;
+		gmap_crstep_xchg(gmap, table, new, gfn);
+	}
+
+	for ( ; gfn < end; gfn++)
+		mark_page_dirty(gmap->kvm, gfn);
+
+	return 0;
+}
+
+void gmap_sync_dirty_log(struct gmap *gmap, gfn_t start, gfn_t end)
+{
+	const struct dat_walk_ops walk_ops = {
+		.pte_entry = _pte_test_and_clear_softdirty,
+		.pmd_entry = _crste_test_and_clear_softdirty,
+		.pud_entry = _crste_test_and_clear_softdirty,
+	};
+
+	lockdep_assert_held(&gmap->kvm->mmu_lock);
+
+	_dat_walk_gfn_range(start, end, gmap->asce, &walk_ops, 0, gmap);
+}
+
+static int gmap_handle_minor_crste_fault(union asce asce, union crste *crstep, gfn_t gfn, bool w)
+{
+	union crste newcrste, oldcrste = READ_ONCE(*crstep);
+
+	/* Somehow the crste is not large anymore, let the slow path deal with it */
+	if (!oldcrste.h.fc)
+		return 1;
+	/* Appropriate permissions already (race with another handler), nothing to do */
+	if (!oldcrste.h.i && !(w && oldcrste.h.p))
+		return 0;
+
+	if (!w || oldcrste.s.fc1.w) {
+		w |= oldcrste.s.fc1.w && oldcrste.s.fc1.d;
+		newcrste = oldcrste;
+		newcrste.h.i = 0;
+		newcrste.s.fc1.y = 1;
+		if (w) {
+			newcrste.h.p = 0;
+			newcrste.s.fc1.d = 1;
+			newcrste.s.fc1.sd = 1;
+		}
+		if (!oldcrste.s.fc1.d && newcrste.s.fc1.d)
+			SetPageDirty(pfn_to_page(crste_origin_large(newcrste)));
+		/* In case of races, let the slow path deal with it */
+		return !dat_crstep_xchg_atomic(crstep, oldcrste, newcrste, gfn, asce);
+	}
+	/* Trying to write on a read-only page, let the slow path deal with it */
+	return 1;
+}
+
+static int _gmap_handle_minor_pte_fault(struct gmap *gmap, union pte *ptep, union pgste *pgste,
+					gfn_t gfn, bool w)
+{
+	union pte newpte, oldpte = READ_ONCE(*ptep);
+
+	/* Appropriate permissions already (race with another handler), nothing to do */
+	if (!oldpte.h.i && !(w && oldpte.h.p))
+		return 0;
+	/* Trying to write on a read-only page, let the slow path deal with it */
+	if (!oldpte.s.pr || (w && !oldpte.s.w))
+		return 1;
+
+	if (!w || oldpte.s.w) {
+		newpte = oldpte;
+		newpte.h.i = 0;
+		newpte.s.y = 1;
+		if (w) {
+			newpte.h.p = 0;
+			newpte.s.d = 1;
+			newpte.s.sd = 1;
+		}
+		if (!oldpte.s.d && newpte.s.d)
+			SetPageDirty(pfn_to_page(newpte.h.pfra));
+		*pgste = gmap_ptep_xchg(gmap, ptep, newpte, *pgste, gfn);
+	}
+	return 0;
+}
+
+static int gmap_handle_minor_pte_fault(struct gmap *gmap, union pte *ptep, gfn_t gfn, bool w)
+{
+	union pgste pgste;
+	int rc;
+
+	pgste = pgste_get_lock(ptep);
+	rc = _gmap_handle_minor_pte_fault(gmap, ptep, &pgste, gfn, w);
+	pgste_set_unlock(ptep, pgste);
+	return rc;
+}
+
+/**
+ * gmap_try_fixup_minor() -- Try to fixup a minor gmap fault.
+ * @gmap: the gmap whose fault needs to be resolved.
+ * @gfn: the faulting address.
+ * @wr: whether the fault was caused by a write access.
+ *
+ * A minor fault is a fault that can be resolved quickly within gmap.
+ * The page is already mapped, the fault is only due to dirty/young tracking.
+ *
+ * Return: 0 in case of success, < 0 in case of error, > 0 if the fault could
+ *         not be resolved and needs to go through the slow path.
+ */
+int gmap_try_fixup_minor(struct gmap *gmap, gfn_t gfn, bool wr)
+{
+	union crste *crstep = NULL;
+	union pte *ptep = NULL;
+	int rc;
+
+	lockdep_assert_not_held(&gmap->kvm->mmu_lock);
+	guard(read_lock)(&gmap->kvm->mmu_lock);
+
+	rc = dat_entry_walk(gfn, gmap->asce, DAT_WALK_LEAF, LEVEL_PTE, &crstep, &ptep);
+	/* If a PTE or a leaf CRSTE could not be reached, slow path */
+	if (rc)
+		return 1;
+	if (ptep)
+		return gmap_handle_minor_pte_fault(gmap, ptep, gfn, wr);
+	return gmap_handle_minor_crste_fault(gmap->asce, crstep, gfn, wr);
+}
+
+static inline bool gmap_2g_allowed(struct gmap *gmap, gfn_t gfn)
+{
+	return false;
+}
+
+static inline bool gmap_1m_allowed(struct gmap *gmap, gfn_t gfn)
+{
+	return false;
+}
+
+int gmap_link(struct gmap *gmap, kvm_pfn_t pfn, struct page *page, gfn_t gfn, bool w, bool d)
+{
+	unsigned int order;
+	int rc, level;
+
+	lockdep_assert_held(&gmap->kvm->mmu_lock);
+
+	level = LEVEL_PTE;
+	if (page) {
+		order = folio_order(page_folio(page));
+		if (order >= get_order(_REGION3_SIZE) && gmap_2g_allowed(gmap, gfn))
+			level = LEVEL_PUD;
+		else if (order >= get_order(_SEGMENT_SIZE) && gmap_1m_allowed(gmap, gfn))
+			level = LEVEL_PMD;
+	}
+	rc = dat_link(pfn, gfn, gmap->asce, level, w, d, !page, gmap->uses_skeys);
+	KVM_BUG_ON(rc == -EINVAL, gmap->kvm);
+	return rc;
+}
+
+static int gmap_ucas_map_one(struct gmap *gmap, gfn_t p_gfn, gfn_t c_gfn)
+{
+	struct page_table *pt;
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(p_gfn, gmap->parent->asce, DAT_WALK_ALLOC, LEVEL_PTE, &crstep, &ptep);
+	if (rc)
+		return rc;
+	pt = pte_table_start(ptep);
+	dat_set_ptval(pt, PTVAL_VMADDR, p_gfn >> (_SEGMENT_SHIFT - PAGE_SHIFT));
+
+	rc = dat_entry_walk(c_gfn, gmap->asce, DAT_WALK_ALLOC, LEVEL_PMD, &crstep, &ptep);
+	if (rc)
+		return rc;
+	dat_crstep_xchg(crstep, _crste_fc0(virt_to_pfn(pt), TABLE_TYPE_SEGMENT), c_gfn, gmap->asce);
+	return 0;
+}
+
+int gmap_ucas_map(struct gmap *gmap, gfn_t p_gfn, gfn_t c_gfn, unsigned long count)
+{
+	int rc = 0;
+
+	for ( ; !rc && count; count--, c_gfn += _PAGE_ENTRIES, p_gfn += _PAGE_ENTRIES)
+		rc = gmap_ucas_map_one(gmap, p_gfn, c_gfn);
+	return rc;
+}
+
+static void gmap_ucas_unmap_one(struct gmap *gmap, gfn_t c_gfn)
+{
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(c_gfn, gmap->asce, 0, LEVEL_PMD, &crstep, &ptep);
+	if (!rc)
+		dat_crstep_xchg(crstep, _PMD_EMPTY, c_gfn, gmap->asce);
+}
+
+void gmap_ucas_unmap(struct gmap *gmap, gfn_t c_gfn, unsigned long count)
+{
+	for ( ; count; count--, c_gfn += _PAGE_ENTRIES)
+		gmap_ucas_unmap_one(gmap, c_gfn);
+}
+
+static int _gmap_enable_skeys(struct gmap *gmap)
+{
+	gfn_t start = 0;
+	int rc;
+
+	if (mm_uses_skeys(gmap->kvm->mm))
+		return 0;
+
+	gmap->kvm->mm->context.uses_skeys = 1;
+	rc = gmap_helper_disable_cow_sharing();
+	if (rc) {
+		gmap->kvm->mm->context.uses_skeys = 0;
+		return rc;
+	}
+
+	do {
+		scoped_guard(write_lock, &gmap->kvm->mmu_lock)
+			start = dat_reset_skeys(gmap->asce, start);
+		cond_resched();
+	} while (start);
+	return 0;
+}
+
+int gmap_enable_skeys(struct gmap *gmap)
+{
+	int rc;
+
+	mmap_write_lock(gmap->kvm->mm);
+	rc = _gmap_enable_skeys(gmap);
+	mmap_write_unlock(gmap->kvm->mm);
+	return rc;
+}
+
+static long _destroy_pages_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	if (!ptep->s.pr)
+		return 0;
+	__kvm_s390_pv_destroy_page(phys_to_page(pte_origin(*ptep)));
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+static long _destroy_pages_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	phys_addr_t origin, cur, end;
+
+	if (!crstep->h.fc || !crstep->s.fc1.pr)
+		return 0;
+
+	origin = crste_origin_large(*crstep);
+	cur = ((max(gfn, walk->start) - gfn) << PAGE_SHIFT) + origin;
+	end = ((min(next, walk->end) - gfn) << PAGE_SHIFT) + origin;
+	for ( ; cur < end; cur += PAGE_SIZE)
+		__kvm_s390_pv_destroy_page(phys_to_page(cur));
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+int gmap_pv_destroy_range(struct gmap *gmap, gfn_t start, gfn_t end, bool interruptible)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = _destroy_pages_pte,
+		.pmd_entry = _destroy_pages_crste,
+		.pud_entry = _destroy_pages_crste,
+	};
+
+	do {
+		scoped_guard(read_lock, &gmap->kvm->mmu_lock)
+			start = _dat_walk_gfn_range(start, end, gmap->asce, &ops,
+						    DAT_WALK_IGN_HOLES, NULL);
+		if (interruptible && fatal_signal_pending(current))
+			return -EINTR;
+		cond_resched();
+	} while (start && start < end);
+	return 0;
+}
+
+int gmap_insert_rmap(struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn, int level)
+{
+	struct gmap_rmap *temp, *rmap;
+	void __rcu **slot;
+	int rc;
+
+	KVM_BUG_ON(!sg->is_shadow, sg->kvm);
+	lockdep_assert_held(&sg->host_to_rmap_lock);
+
+	rc = -ENOMEM;
+	rmap = kzalloc(sizeof(*rmap), GFP_ATOMIC);
+	if (!rmap)
+		goto out;
+
+	rc = 0;
+	rmap->r_gfn = r_gfn;
+	rmap->level = level;
+	slot = radix_tree_lookup_slot(&sg->host_to_rmap, p_gfn);
+	if (slot) {
+		rmap->next = radix_tree_deref_slot_protected(slot, &sg->host_to_rmap_lock);
+		for (temp = rmap->next; temp; temp = temp->next) {
+			if (temp->val == rmap->val)
+				goto out;
+		}
+		radix_tree_replace_slot(&sg->host_to_rmap, slot, rmap);
+	} else {
+		rmap->next = NULL;
+		radix_tree_insert(&sg->host_to_rmap, p_gfn, rmap);
+	}
+	rmap = NULL;
+out:
+	kfree(rmap);
+	return rc;
+}
+
+int gmap_protect_rmap(struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn, kvm_pfn_t pfn, int level, bool wr)
+{
+	union crste *crstep;
+	union pgste pgste;
+	union pte *ptep;
+	union pte pte;
+	int rc;
+
+	KVM_BUG_ON(!sg->is_shadow, sg->kvm);
+
+	rc = dat_entry_walk(p_gfn, sg->parent->asce, DAT_WALK_SPLIT, LEVEL_PTE, &crstep, &ptep);
+	if (rc)
+		return rc;
+	if (level <= LEVEL_PGD) {
+		scoped_guard(spinlock, &sg->host_to_rmap_lock)
+			rc = gmap_insert_rmap(sg, p_gfn, r_gfn, level);
+	}
+	if (rc)
+		return rc;
+
+	pgste = pgste_get_lock(ptep);
+	pte = ptep->s.pr ? *ptep : _pte(pfn, wr, false, false);
+	pte.h.p = 1;
+	pgste = gmap_ptep_xchg(sg->parent, ptep, pte, pgste, p_gfn);
+	pgste.vsie_notif = 1;
+	pgste_set_unlock(ptep, pgste);
+
+	return 0;
+}
+
+static long __set_cmma_dirty_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	__atomic64_or(PGSTE_UC_BIT, &pgste_of(ptep)->val);
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+void gmap_set_cmma_all_dirty(struct gmap *gmap)
+{
+	const struct dat_walk_ops ops = { .pte_entry = __set_cmma_dirty_pte, };
+	gfn_t gfn = 0;
+
+	do {
+		scoped_guard(read_lock, &gmap->kvm->mmu_lock)
+			gfn = _dat_walk_gfn_range(gfn, asce_end(gmap->asce), gmap->asce, &ops,
+						  DAT_WALK_IGN_HOLES, NULL);
+		cond_resched();
+	} while (gfn);
+}
+
+static void gmap_unshadow_level(struct gmap *sg, gfn_t r_gfn, int level)
+{
+	unsigned long align = PAGE_SIZE;
+	gpa_t gaddr = gfn_to_gpa(r_gfn);
+	union crste *crstep;
+	union crste crste;
+	union pte *ptep;
+
+	if (level > LEVEL_PTE)
+		align = 1UL << (11 * level + _SEGMENT_SHIFT);
+	kvm_s390_vsie_gmap_notifier(sg, ALIGN_DOWN(gaddr, align), ALIGN(gaddr + 1, align));
+	if (dat_entry_walk(r_gfn, sg->asce, 0, level, &crstep, &ptep))
+		return;
+	if (ptep) {
+		dat_ptep_xchg(ptep, _PTE_EMPTY, r_gfn, sg->asce, sg->uses_skeys);
+		return;
+	}
+	crste = READ_ONCE(*crstep);
+	dat_crstep_clear(crstep, r_gfn, sg->asce);
+	if (is_pmd(crste))
+		dat_free_pt(dereference_pmd(crste.pmd));
+	else
+		dat_free_level(dereference_crste(crste), true);
+}
+
+static void gmap_unshadow_and_dispose(struct gmap *sg)
+{
+	KVM_BUG_ON(!sg->is_shadow, sg->kvm);
+	KVM_BUG_ON(!sg->parent, sg->kvm);
+	KVM_BUG_ON(sg->removed, sg->kvm);
+
+	lockdep_assert_held(&sg->parent->children_lock);
+
+	sg->removed = 1;
+	kvm_s390_vsie_gmap_notifier(sg, 0, -1UL);
+
+	KVM_BUG_ON(!list_empty(&sg->scb_users), sg->kvm);
+
+	gmap_remove_child(sg);
+	gmap_dispose(sg);
+}
+
+void gmap_handle_vsie_unshadow_event(struct gmap *parent, gfn_t gfn)
+{
+	struct gmap_rmap *rmap, *rnext, *head;
+	struct gmap *sg, *next;
+	gfn_t start, end;
+
+	guard(spinlock)(&parent->children_lock);
+
+	list_for_each_entry_safe(sg, next, &parent->children, list) {
+		start = sg->guest_asce.rsto;
+		end = start + sg->guest_asce.tl + 1;
+		if (!sg->guest_asce.r && gfn >= start && gfn < end) {
+			gmap_unshadow_and_dispose(sg);
+			continue;
+		}
+		scoped_guard(spinlock, &sg->host_to_rmap_lock)
+			head = radix_tree_delete(&sg->host_to_rmap, gfn);
+		gmap_for_each_rmap_safe(rmap, rnext, head)
+			gmap_unshadow_level(sg, rmap->r_gfn, rmap->level);
+	}
+}
+
+/**
+ * gmap_find_shadow - find a specific asce in the list of shadow tables
+ * @parent: pointer to the parent gmap
+ * @asce: ASCE for which the shadow table is created
+ * @edat_level: edat level to be used for the shadow translation
+ *
+ * Returns the pointer to a gmap if a shadow table with the given asce is
+ * already available, ERR_PTR(-EAGAIN) if another one is just being created,
+ * otherwise NULL
+ *
+ * Context: Called with parent->children_lock held
+ */
+static struct gmap *gmap_find_shadow(struct gmap *parent, union asce asce, int edat_level)
+{
+	struct gmap *sg;
+
+	lockdep_assert_held(&parent->children_lock);
+	list_for_each_entry(sg, &parent->children, list) {
+		if (!gmap_is_shadow_valid(sg, asce, edat_level))
+			continue;
+		if (!sg->initialized)
+			return ERR_PTR(-EAGAIN);
+		return sg;
+	}
+	return NULL;
+}
+
+#define CRST_TABLE_PAGES (_CRST_TABLE_SIZE / PAGE_SIZE)
+static int gmap_protect_asce_top_level(struct gmap *sg)
+{
+	struct guest_fault f[CRST_TABLE_PAGES] = {};
+	union asce asce = sg->guest_asce;
+	unsigned long seq;
+	int rc, i;
+
+	KVM_BUG_ON(!sg->is_shadow, sg->kvm);
+
+	seq = sg->kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
+
+	rc = __kvm_s390_faultin_gfn_range(sg->kvm, f, asce.rsto, asce.dt + 1, false);
+	if (rc) {
+		release_faultin_array(sg->kvm, f, true);
+		return rc > 0 ? -EFAULT : rc;
+	}
+
+	if (__kvm_s390_fault_array_needs_retry(sg->kvm, seq, f, true))
+		return -EAGAIN;
+	scoped_guard(write_lock, &sg->kvm->mmu_lock) {
+		if (__kvm_s390_fault_array_needs_retry(sg->kvm, seq, f, false))
+			return -EAGAIN;
+		for (i = 0; i < CRST_TABLE_PAGES; i++)
+			gmap_protect_rmap(sg, f[i].gfn, 0, f[i].pfn, LEVEL_PGD + 1, f[i].writable);
+		release_faultin_array(sg->kvm, f, false);
+	}
+	return 0;
+}
+
+/**
+ * gmap_create_shadow() - create/find a shadow guest address space
+ * @parent: pointer to the parent gmap
+ * @asce: ASCE for which the shadow table is created
+ * @edat_level: edat level to be used for the shadow translation
+ *
+ * The pages of the top level page table referred by the asce parameter
+ * will be set to read-only and marked in the PGSTEs of the kvm process.
+ * The shadow table will be removed automatically on any change to the
+ * PTE mapping for the source table.
+ *
+ * Returns a guest address space structure, ERR_PTR(-ENOMEM) if out of memory,
+ * ERR_PTR(-EAGAIN) if the caller has to retry and ERR_PTR(-EFAULT) if the
+ * parent gmap table could not be protected.
+ */
+struct gmap *gmap_create_shadow(struct gmap *parent, union asce asce, int edat_level)
+{
+	struct gmap *sg, *new;
+	int rc;
+
+	scoped_guard(spinlock, &parent->children_lock)
+		sg = gmap_find_shadow(parent, asce, edat_level);
+	if (sg)
+		return sg;
+	/* Create a new shadow gmap */
+	new = gmap_new(parent->kvm, asce.r ? 1UL << (64 - PAGE_SHIFT) : asce_end(asce));
+	if (!new)
+		return ERR_PTR(-ENOMEM);
+	new->guest_asce = asce;
+	new->edat_level = edat_level;
+	new->initialized = false;
+	new->is_shadow = true;
+
+	scoped_guard(spinlock, &parent->children_lock) {
+		/* Recheck if another CPU created the same shadow */
+		sg = gmap_find_shadow(parent, asce, edat_level);
+		if (sg) {
+			gmap_dispose(new);
+			return sg;
+		}
+		if (asce.r) {
+			/* only allow one real-space gmap shadow */
+			list_for_each_entry(sg, &parent->children, list) {
+				if (sg->guest_asce.r) {
+					scoped_guard(write_lock, &parent->kvm->mmu_lock)
+						gmap_unshadow_and_dispose(sg); /* ???? */
+					break;
+				}
+			}
+			new->initialized = true;
+		}
+		gmap_add_child(parent, new);
+		/* nothing to protect, return right away */
+		if (asce.r)
+			return new;
+	}
+
+	/* protect after insertion, so it will get properly invalidated */
+	rc = gmap_protect_asce_top_level(new);
+	scoped_guard(spinlock, &parent->children_lock) {
+		if (rc) {
+			gmap_remove_child(new);
+			gmap_dispose(new);
+			return ERR_PTR(rc);
+		}
+		new->initialized = true;
+	}
+	return new;
+}
+
+static long _gmap_split_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct gmap *gmap = walk->priv;
+	union crste crste, newcrste;
+
+	if (need_resched())
+		return next;
+
+	crste = READ_ONCE(*crstep);
+	newcrste = _CRSTE_EMPTY(crste.h.tt);
+
+	while (crste_leaf(crste)) {
+		if (crste_prefix(crste))
+			gmap_unmap_prefix(gmap, gfn, next);
+		if (crste.s.fc1.vsie_notif)
+			gmap_handle_vsie_unshadow_event(gmap, gfn);
+		if (dat_crstep_xchg_atomic(crstep, crste, newcrste, gfn, walk->asce))
+			break;
+		crste = READ_ONCE(*crstep);
+	}
+	return 0;
+}
+
+void gmap_split_huge_pages(struct gmap *gmap)
+{
+	const struct dat_walk_ops ops = {
+		.pmd_entry = _gmap_split_crste,
+		.pud_entry = _gmap_split_crste,
+	};
+	gfn_t start = 0;
+
+	do {
+		scoped_guard(read_lock, &gmap->kvm->mmu_lock)
+			start = _dat_walk_gfn_range(start, asce_end(gmap->asce), gmap->asce,
+						    &ops, DAT_WALK_IGN_HOLES, gmap);
+		cond_resched();
+	} while (start);
+}
diff --git a/arch/s390/kvm/gmap.h b/arch/s390/kvm/gmap.h
new file mode 100644
index 000000000000..1e3ab61f2a65
--- /dev/null
+++ b/arch/s390/kvm/gmap.h
@@ -0,0 +1,178 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2016, 2025
+ *    Author(s): Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *               Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+
+#ifndef ARCH_KVM_S390_GMAP_H
+#define ARCH_KVM_S390_GMAP_H
+
+#include "dat.h"
+
+/**
+ * struct gmap_struct - guest address space
+ * @is_shadow: whether this gmap is a vsie shadow gmap
+ * @owns_page_tables: whether this gmap owns all dat levels; normally 1, is 0
+ *                    only for ucontrol per-cpu gmaps, since they share the page
+ *                    tables with the main gmap.
+ * @is_ucontrol: whether this gmap is ucontrol (main gmap or per-cpu gmap)
+ * @allow_hpage_1m: whether 1M hugepages are allowed for this gmap,
+ *                  independently of whatever page size is used by userspace
+ * @allow_hpage_2g: whether 2G hugepages are allowed for this gmap,
+ *                  independently of whatever page size is used by userspace
+ * @pfault_enabled: whether pfault is enabled for this gmap
+ * @removed: whether this shadow gmap is about to be disposed of
+ * @initialized: flag to indicate if a shadow guest address space can be used
+ * @uses_skeys: indicates if the guest uses storage keys
+ * @uses_cmm: indicates if the guest uses cmm
+ * @edat_level: the edat level of this shadow gmap
+ * @kvm: the vm
+ * @asce: the ASCE used by this gmap
+ * @list: list head used in children gmaps for the children gmap list
+ * @children_lock: protects children and scb_users
+ * @children: list of child gmaps of this gmap
+ * @scb_users: list of vsie_scb that use this shadow gmap
+ * @parent: parent gmap of a child gmap
+ * @guest_asce: original ASCE of this shadow gmap
+ * @host_to_rmap_lock: protects host_to_rmap
+ * @host_to_rmap: radix tree mapping host addresses to guest addresses
+ */
+struct gmap {
+	unsigned char is_shadow:1;
+	unsigned char owns_page_tables:1;
+	unsigned char is_ucontrol:1;
+	bool allow_hpage_1m;
+	bool allow_hpage_2g;
+	bool pfault_enabled;
+	bool removed;
+	bool initialized;
+	bool uses_skeys;
+	bool uses_cmm;
+	unsigned char edat_level;
+	struct kvm *kvm;
+	union asce asce;
+	struct list_head list;
+	spinlock_t children_lock;	/* protects: children, scb_users */
+	struct list_head children;
+	struct list_head scb_users;
+	struct gmap *parent;
+	union asce guest_asce;
+	spinlock_t host_to_rmap_lock;	/* protects host_to_rmap */
+	struct radix_tree_root host_to_rmap;
+};
+
+#define SHADOW_LEVEL_MASK       0x7
+
+/**
+ * struct gmap_rmap - reverse mapping for shadow page table entries
+ * @next: pointer to next rmap in the list
+ * @r_gfn: virtual rmap address in the shadow guest address space
+ */
+struct gmap_rmap {
+	struct gmap_rmap *next;
+	union {
+		unsigned long val;
+		struct {
+			long          level: 8;
+			unsigned long      : 4;
+			unsigned long r_gfn:52;
+		};
+	};
+};
+
+static_assert(sizeof(struct gmap_rmap) == 2 * sizeof(long));
+
+#define gmap_for_each_rmap_safe(pos, n, head) \
+	for (pos = (head); n = pos ? pos->next : NULL, pos; pos = n)
+
+int s390_replace_asce(struct gmap *gmap);
+bool _gmap_unmap_prefix(struct gmap *gmap, gfn_t gfn, gfn_t end, bool hint);
+bool gmap_age_gfn(struct gmap *gmap, gfn_t start, gfn_t end);
+bool gmap_unmap_gfn_range(struct gmap *gmap, struct kvm_memory_slot *slot, gfn_t start, gfn_t end);
+int gmap_try_fixup_minor(struct gmap *gmap, gfn_t gfn, bool wr);
+struct gmap *gmap_new(struct kvm *kvm, gfn_t limit);
+struct gmap *gmap_new_child(struct gmap *parent, gfn_t limit);
+void gmap_remove_child(struct gmap *child);
+void gmap_dispose(struct gmap *gmap);
+int gmap_link(struct gmap *gmap, kvm_pfn_t pfn, struct page *page, gfn_t gfn, bool w, bool d);
+void gmap_sync_dirty_log(struct gmap *gmap, gfn_t start, gfn_t end);
+int gmap_set_limit(struct gmap *gmap, gfn_t limit);
+int gmap_ucas_map(struct gmap *gmap, gfn_t p_gfn, gfn_t c_gfn, unsigned long count);
+void gmap_ucas_unmap(struct gmap *gmap, gfn_t c_gfn, unsigned long count);
+int gmap_enable_skeys(struct gmap *gmap);
+int gmap_pv_destroy_range(struct gmap *gmap, gfn_t start, gfn_t end, bool interruptible);
+int gmap_insert_rmap(struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn, int level);
+int gmap_protect_rmap(struct gmap *sg, gfn_t p_gfn, gfn_t r_gfn, kvm_pfn_t pfn, int level, bool wr);
+void gmap_set_cmma_all_dirty(struct gmap *gmap);
+void gmap_handle_vsie_unshadow_event(struct gmap *parent, gfn_t gfn);
+struct gmap *gmap_create_shadow(struct gmap *gmap, union asce asce, int edat_level);
+void gmap_split_huge_pages(struct gmap *gmap);
+
+static inline bool gmap_mkold_prefix(struct gmap *gmap, gfn_t gfn, gfn_t end)
+{
+	return _gmap_unmap_prefix(gmap, gfn, end, true);
+}
+
+static inline bool gmap_unmap_prefix(struct gmap *gmap, gfn_t gfn, gfn_t end)
+{
+	return _gmap_unmap_prefix(gmap, gfn, end, false);
+}
+
+static inline union pgste gmap_ptep_xchg(struct gmap *gmap, union pte *ptep, union pte newpte,
+					 union pgste pgste, gfn_t gfn)
+{
+	lockdep_assert_held(&gmap->kvm->mmu_lock);
+
+	if (pgste.prefix_notif && (newpte.h.p || newpte.h.i)) {
+		pgste.prefix_notif = 0;
+		gmap_unmap_prefix(gmap, gfn, gfn + 1);
+	}
+	if (pgste.vsie_notif && (ptep->h.p != newpte.h.p || newpte.h.i)) {
+		pgste.vsie_notif = 0;
+		gmap_handle_vsie_unshadow_event(gmap, gfn);
+	}
+	return __dat_ptep_xchg(ptep, pgste, newpte, gfn, gmap->asce, gmap->uses_skeys);
+}
+
+static inline void gmap_crstep_xchg(struct gmap *gmap, union crste *crstep, union crste ne,
+				    gfn_t gfn)
+{
+	unsigned long align = 8 + (is_pmd(*crstep) ? 0 : 11);
+
+	lockdep_assert_held(&gmap->kvm->mmu_lock);
+
+	gfn = ALIGN_DOWN(gfn, align);
+	if (crste_prefix(*crstep) && (ne.h.p || ne.h.i || !crste_prefix(ne))) {
+		ne.s.fc1.prefix_notif = 0;
+		gmap_unmap_prefix(gmap, gfn, gfn + align);
+	}
+	if (crste_leaf(*crstep) && crstep->s.fc1.vsie_notif &&
+	    (ne.h.p || ne.h.i || !ne.s.fc1.vsie_notif)) {
+		ne.s.fc1.vsie_notif = 0;
+		gmap_handle_vsie_unshadow_event(gmap, gfn);
+	}
+	dat_crstep_xchg(crstep, ne, gfn, gmap->asce);
+}
+
+/**
+ * gmap_is_shadow_valid() - check if a shadow guest address space matches the
+ *                          given properties and is still valid
+ * @sg: pointer to the shadow guest address space structure
+ * @asce: ASCE for which the shadow table is requested
+ * @edat_level: edat level to be used for the shadow translation
+ *
+ * Returns true if the gmap shadow is still valid and matches the given
+ * properties, the caller can continue using it. Returns false otherwise; the
+ * caller has to request a new shadow gmap in this case.
+ */
+static inline bool gmap_is_shadow_valid(struct gmap *sg, union asce asce, int edat_level)
+{
+	if (sg->removed)
+		return false;
+	return sg->guest_asce.val == asce.val && sg->edat_level == edat_level;
+}
+
+#endif /* ARCH_KVM_S390_GMAP_H */
-- 
2.51.0


