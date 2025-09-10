Return-Path: <kvm+bounces-57240-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 56F6CB51FEB
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:09:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B62F9483F2C
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE2D345725;
	Wed, 10 Sep 2025 18:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="U7MLzf+U"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F203451A3;
	Wed, 10 Sep 2025 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527694; cv=none; b=p0l3Peq7KGhtyaPPXG+RXvucbaleZFYXbC1V3Q4C0i2wKYT7u1EZn7HAeH6+MzKoA33pVyxAi8Q4U4a+bmKlMAH5GODcZR4K+qWD/XDP6B2m6to+PNOOUKu3nkIt0OB0tthIwfhx41WiBsmDhQPPeJFhoDhpoSf2TG+pzP7isSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527694; c=relaxed/simple;
	bh=8X137cAPXk9DZLDrbzPLtS5I7nYlTiPzsFwHn2qagW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3aTlOjOo2atqQtQD8W94iEu7khH8D4PEgEIyCSEQlCtTUzwI1D3KRpsOsDDyOLG6net4OgFVROddxOEF5zPIGpjmiDiRlFSY95cxLyqHcxGe6XM34PkkZyGrs7XWPzOCKPE1/S1I6NNlwRNFAK4KSiRKZILxbvbBYezn3TjNmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=U7MLzf+U; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AEvoV2005802;
	Wed, 10 Sep 2025 18:07:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ifX5QNMTYJ2kxvDap
	vmmWsNMLXgSy23kbRWc5Xyo1nY=; b=U7MLzf+U9PjUpVw2g6nGlmi1EK0qOi3TF
	52ZxM5oaihqa0TwTr72+n0LJbCezkA3VjLu8o9OzE+r5uPVQDxWmZ+z9MKELPdG3
	4rr0YyivFdfHGty5mFzzKZMO+lOWFoPuRcLnJ2pMd695NHRvPK9MTik0TtkcIJ07
	mTXAg/xCveT0t6VdUYYqmZ65hbQI5V59lPeNfjBfznFS4IrB9t9LZnYhnI9InZdh
	NOQ79g2OW+fQ93+9myeyHPhYRTKrk+HFOa3GJqTyiv87PazGunMy120RmeG6HSIt
	1IYOLrhNRo3uAhcTMxMdpbYO20Kr1CGLD8NarlUjYo7BhmlGoNVQQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acr7ky8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:56 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AH7fgh007950;
	Wed, 10 Sep 2025 18:07:56 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49109psv35-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:55 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7p8746399840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:51 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A51E20040;
	Wed, 10 Sep 2025 18:07:51 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1A1E20049;
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
Subject: [PATCH v2 16/20] KVM: s390: Switch to new gmap
Date: Wed, 10 Sep 2025 20:07:42 +0200
Message-ID: <20250910180746.125776-17-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: EFfXuel0Gu63QSl3Th1a5oZCD6kXYTA0
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68c1be7d cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=4tmyAYEMGYu-2ymtJYgA:9
 a=P3EiLnY056Xx_FnP:21
X-Proofpoint-ORIG-GUID: EFfXuel0Gu63QSl3Th1a5oZCD6kXYTA0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfX339c++22KDgy
 mFXDbEAmqedvYc8zeoVrBWhh7d4YXS9iIzQzkXCf80T4dENbr2HaNOPyYXMcnU4ca6yD9JjoQAj
 CxoihcJPOlJ1SZ8G+jKxEOy1NI806G99QP6uuvuK0dELJ/xOMXr2kDD5AGwEBjRP1Wp6n9TmIsI
 3GbSlukybC/5fh6zulj/PhTuWuLdsBMiS223AbTdIXifjAPz0M5sklifYCONAAB/B4mmKXFI25s
 wqZZ7DARxxVzGGR38e5lWIE2/VPB5lRdyewYFRZ5wS0ZtyLwyzCf6QEs6lsTuLQL1obpgLhhURJ
 IJ1QdRXolRdd1CgdOA0Ng19crYsSdKUI1WU3jQBafujB6FOk95CJaQe8xg3u45BpBxEBKzZVXyJ
 1POD8VUb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000

Switch KVM/s390 to use the new gmap code.

Remove includes to <gmap.h> and include "gmap.h" instead; fix all the
existing users of the old gmap functions to use the new ones instead.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/Kconfig                   |   2 +-
 arch/s390/include/asm/mmu_context.h |   4 -
 arch/s390/include/asm/tlb.h         |   3 -
 arch/s390/kvm/Makefile              |   2 +-
 arch/s390/kvm/diag.c                |   2 +-
 arch/s390/kvm/gaccess.c             | 526 ++++++++++++----------
 arch/s390/kvm/gaccess.h             |  16 +-
 arch/s390/kvm/gmap-vsie.c           | 141 ------
 arch/s390/kvm/gmap.c                |   6 +-
 arch/s390/kvm/intercept.c           |   8 +-
 arch/s390/kvm/interrupt.c           |   2 +-
 arch/s390/kvm/kvm-s390.c            | 671 ++++++++--------------------
 arch/s390/kvm/kvm-s390.h            |  19 +-
 arch/s390/kvm/priv.c                | 206 +++------
 arch/s390/kvm/pv.c                  |  84 ++--
 arch/s390/kvm/vsie.c                | 116 +++--
 16 files changed, 672 insertions(+), 1136 deletions(-)
 delete mode 100644 arch/s390/kvm/gmap-vsie.c

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 0c16dc443e2f..d43f7a8a77fa 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -33,7 +33,7 @@ config GENERIC_LOCKBREAK
 	def_bool y if PREEMPTION
 
 config PGSTE
-	def_bool y if KVM
+	def_bool n
 
 config AUDIT_ARCH
 	def_bool y
diff --git a/arch/s390/include/asm/mmu_context.h b/arch/s390/include/asm/mmu_context.h
index 48e548c01daa..bd1ef5e2d2eb 100644
--- a/arch/s390/include/asm/mmu_context.h
+++ b/arch/s390/include/asm/mmu_context.h
@@ -30,11 +30,7 @@ static inline int init_new_context(struct task_struct *tsk,
 	mm->context.gmap_asce = 0;
 	mm->context.flush_mm = 0;
 #if IS_ENABLED(CONFIG_KVM)
-	mm->context.has_pgste = 0;
-	mm->context.uses_skeys = 0;
-	mm->context.uses_cmm = 0;
 	mm->context.allow_cow_sharing = 1;
-	mm->context.allow_gmap_hpage_1m = 0;
 #endif
 	switch (mm->context.asce_limit) {
 	default:
diff --git a/arch/s390/include/asm/tlb.h b/arch/s390/include/asm/tlb.h
index 1e50f6f1ad9d..7354b42ee994 100644
--- a/arch/s390/include/asm/tlb.h
+++ b/arch/s390/include/asm/tlb.h
@@ -36,7 +36,6 @@ static inline bool __tlb_remove_folio_pages(struct mmu_gather *tlb,
 
 #include <asm/tlbflush.h>
 #include <asm-generic/tlb.h>
-#include <asm/gmap.h>
 
 /*
  * Release the page cache reference for a pte removed by
@@ -85,8 +84,6 @@ static inline void pte_free_tlb(struct mmu_gather *tlb, pgtable_t pte,
 	tlb->mm->context.flush_mm = 1;
 	tlb->freed_tables = 1;
 	tlb->cleared_pmds = 1;
-	if (mm_has_pgste(tlb->mm))
-		gmap_unlink(tlb->mm, (unsigned long *)pte, address);
 	tlb_remove_ptdesc(tlb, virt_to_ptdesc(pte));
 }
 
diff --git a/arch/s390/kvm/Makefile b/arch/s390/kvm/Makefile
index 21088265402c..1d092b75adc0 100644
--- a/arch/s390/kvm/Makefile
+++ b/arch/s390/kvm/Makefile
@@ -8,7 +8,7 @@ include $(srctree)/virt/kvm/Makefile.kvm
 ccflags-y := -Ivirt/kvm -Iarch/s390/kvm
 
 kvm-y += kvm-s390.o intercept.o interrupt.o priv.o sigp.o
-kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o gmap-vsie.o
+kvm-y += diag.o gaccess.o guestdbg.o vsie.o pv.o
 kvm-y += dat.o gmap.o
 
 kvm-$(CONFIG_VFIO_PCI_ZDEV_KVM) += pci.o
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 53233dec8cad..d89d1c381522 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -10,13 +10,13 @@
 
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
-#include <asm/gmap.h>
 #include <asm/gmap_helpers.h>
 #include <asm/virtio-ccw.h>
 #include "kvm-s390.h"
 #include "trace.h"
 #include "trace-s390.h"
 #include "gaccess.h"
+#include "gmap.h"
 
 static void do_discard_gfn_range(struct kvm_vcpu *vcpu, gfn_t gfn_start, gfn_t gfn_end)
 {
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 05fd3ee4b20d..6b2e07ed5de3 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -11,15 +11,42 @@
 #include <linux/err.h>
 #include <linux/pgtable.h>
 #include <linux/bitfield.h>
+#include <linux/kvm_host.h>
+#include <linux/kvm_types.h>
+#include <asm/diag.h>
 #include <asm/access-regs.h>
 #include <asm/fault.h>
-#include <asm/gmap.h>
 #include <asm/dat-bits.h>
 #include "kvm-s390.h"
+#include "dat.h"
+#include "gmap.h"
 #include "gaccess.h"
 
 #define GMAP_SHADOW_FAKE_TABLE 1ULL
 
+union dat_table_entry {
+	unsigned long val;
+	union region1_table_entry pgd;
+	union region2_table_entry p4d;
+	union region3_table_entry pud;
+	union segment_table_entry pmd;
+	union page_table_entry pte;
+};
+
+#define WALK_N_ENTRIES 7
+#define LEVEL_MEM -2
+struct pgtwalk {
+	struct guest_fault raw_entries[WALK_N_ENTRIES];
+	gpa_t last_addr;
+	int level;
+	bool p;
+};
+
+static inline struct guest_fault *get_entries(struct pgtwalk *w)
+{
+	return w->raw_entries - LEVEL_MEM;
+}
+
 /*
  * raddress union which will contain the result (real or absolute address)
  * after a page table walk. The rfaa, sfaa and pfra members are used to
@@ -618,28 +645,19 @@ static int low_address_protection_enabled(struct kvm_vcpu *vcpu,
 static int vm_check_access_key_gpa(struct kvm *kvm, u8 access_key,
 				   enum gacc_mode mode, gpa_t gpa)
 {
-	u8 storage_key, access_control;
-	bool fetch_protected;
-	unsigned long hva;
+	union skey storage_key;
 	int r;
 
 	if (access_key == 0)
 		return 0;
 
-	hva = gfn_to_hva(kvm, gpa_to_gfn(gpa));
-	if (kvm_is_error_hva(hva))
-		return PGM_ADDRESSING;
-
-	mmap_read_lock(current->mm);
-	r = get_guest_storage_key(current->mm, hva, &storage_key);
-	mmap_read_unlock(current->mm);
+	scoped_guard(read_lock, &kvm->mmu_lock)
+		r = dat_get_storage_key(kvm->arch.gmap->asce, gpa_to_gfn(gpa), &storage_key);
 	if (r)
 		return r;
-	access_control = FIELD_GET(_PAGE_ACC_BITS, storage_key);
-	if (access_control == access_key)
+	if (storage_key.acc == access_key)
 		return 0;
-	fetch_protected = storage_key & _PAGE_FP_BIT;
-	if ((mode == GACC_FETCH || mode == GACC_IFETCH) && !fetch_protected)
+	if ((mode == GACC_FETCH || mode == GACC_IFETCH) && !storage_key.fp)
 		return 0;
 	return PGM_PROTECTION;
 }
@@ -682,8 +700,7 @@ static int vcpu_check_access_key_gpa(struct kvm_vcpu *vcpu, u8 access_key,
 				     enum gacc_mode mode, union asce asce, gpa_t gpa,
 				     unsigned long ga, unsigned int len)
 {
-	u8 storage_key, access_control;
-	unsigned long hva;
+	union skey storage_key;
 	int r;
 
 	/* access key 0 matches any storage key -> allow */
@@ -693,26 +710,23 @@ static int vcpu_check_access_key_gpa(struct kvm_vcpu *vcpu, u8 access_key,
 	 * caller needs to ensure that gfn is accessible, so we can
 	 * assume that this cannot fail
 	 */
-	hva = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gpa));
-	mmap_read_lock(current->mm);
-	r = get_guest_storage_key(current->mm, hva, &storage_key);
-	mmap_read_unlock(current->mm);
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+		r = dat_get_storage_key(vcpu->arch.gmap->asce, gpa_to_gfn(gpa), &storage_key);
 	if (r)
 		return r;
-	access_control = FIELD_GET(_PAGE_ACC_BITS, storage_key);
 	/* access key matches storage key -> allow */
-	if (access_control == access_key)
+	if (storage_key.acc == access_key)
 		return 0;
 	if (mode == GACC_FETCH || mode == GACC_IFETCH) {
 		/* it is a fetch and fetch protection is off -> allow */
-		if (!(storage_key & _PAGE_FP_BIT))
+		if (!storage_key.fp)
 			return 0;
 		if (fetch_prot_override_applicable(vcpu, mode, asce) &&
 		    fetch_prot_override_applies(ga, len))
 			return 0;
 	}
 	if (storage_prot_override_applicable(vcpu) &&
-	    storage_prot_override_applies(access_control))
+	    storage_prot_override_applies(storage_key.acc))
 		return 0;
 	return PGM_PROTECTION;
 }
@@ -1173,304 +1187,332 @@ int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra)
 }
 
 /**
- * kvm_s390_shadow_tables - walk the guest page table and create shadow tables
+ * walk_guest_tables() - walk the guest page table and pin the dat tables
  * @sg: pointer to the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
- * @pgt: pointer to the beginning of the page table for the given address if
- *	 successful (return value 0), or to the first invalid DAT entry in
- *	 case of exceptions (return value > 0)
- * @dat_protection: referenced memory is write protected
- * @fake: pgt references contiguous guest memory block, not a pgtable
+ * @w: will be filled with information on the pinned pages
+ * @wr: indicates a write access if true
+ *
+ * Return:
+ * * 0 in case of success,
+ * * a PIC code > 0 in case the address translation fails
+ * * an error code < 0 if other errors happen in the host
  */
-static int kvm_s390_shadow_tables(struct gmap *sg, unsigned long saddr,
-				  unsigned long *pgt, int *dat_protection,
-				  int *fake)
+static int walk_guest_tables(struct gmap *sg, unsigned long saddr, struct pgtwalk *w, bool wr)
 {
-	struct kvm *kvm;
-	struct gmap *parent;
-	union asce asce;
+	struct gmap *parent = sg->parent;
+	struct guest_fault *entries;
+	union dat_table_entry table;
 	union vaddress vaddr;
 	unsigned long ptr;
+	struct kvm *kvm;
+	union asce asce;
 	int rc;
 
-	*fake = 0;
-	*dat_protection = 0;
-	kvm = sg->private;
-	parent = sg->parent;
+	kvm = parent->kvm;
+	asce = sg->guest_asce;
+	entries = get_entries(w);
+
+	w->level = LEVEL_MEM;
+	w->last_addr = saddr;
+	if (asce.r)
+		return __kvm_s390_faultin_gfn(kvm, entries + LEVEL_MEM, gpa_to_gfn(saddr), wr);
+
 	vaddr.addr = saddr;
-	asce.val = sg->orig_asce;
 	ptr = asce.rsto * PAGE_SIZE;
-	if (asce.r) {
-		*fake = 1;
-		ptr = 0;
-		asce.dt = ASCE_TYPE_REGION1;
-	}
+
+	if (!asce_contains_gfn(asce, gpa_to_gfn(saddr)))
+		return PGM_ASCE_TYPE;
 	switch (asce.dt) {
 	case ASCE_TYPE_REGION1:
-		if (vaddr.rfx01 > asce.tl && !*fake)
+		if (vaddr.rfx01 > asce.tl)
 			return PGM_REGION_FIRST_TRANS;
 		break;
 	case ASCE_TYPE_REGION2:
-		if (vaddr.rfx)
-			return PGM_ASCE_TYPE;
 		if (vaddr.rsx01 > asce.tl)
 			return PGM_REGION_SECOND_TRANS;
 		break;
 	case ASCE_TYPE_REGION3:
-		if (vaddr.rfx || vaddr.rsx)
-			return PGM_ASCE_TYPE;
 		if (vaddr.rtx01 > asce.tl)
 			return PGM_REGION_THIRD_TRANS;
 		break;
 	case ASCE_TYPE_SEGMENT:
-		if (vaddr.rfx || vaddr.rsx || vaddr.rtx)
-			return PGM_ASCE_TYPE;
 		if (vaddr.sx01 > asce.tl)
 			return PGM_SEGMENT_TRANSLATION;
 		break;
 	}
 
+	w->level = asce.dt;
 	switch (asce.dt) {
-	case ASCE_TYPE_REGION1: {
-		union region1_table_entry rfte;
-
-		if (*fake) {
-			ptr += vaddr.rfx * _REGION1_SIZE;
-			rfte.val = ptr;
-			goto shadow_r2t;
-		}
-		*pgt = ptr + vaddr.rfx * 8;
-		rc = gmap_read_table(parent, ptr + vaddr.rfx * 8, &rfte.val);
+	case ASCE_TYPE_REGION1:
+		w->last_addr = ptr + vaddr.rfx * 8;
+		rc = __kvm_s390_faultin_read_gpa(kvm, entries + w->level, w->last_addr, &table.val);
 		if (rc)
 			return rc;
-		if (rfte.i)
+		if (table.pgd.i)
 			return PGM_REGION_FIRST_TRANS;
-		if (rfte.tt != TABLE_TYPE_REGION1)
+		if (table.pgd.tt != TABLE_TYPE_REGION1)
 			return PGM_TRANSLATION_SPEC;
-		if (vaddr.rsx01 < rfte.tf || vaddr.rsx01 > rfte.tl)
+		if (vaddr.rsx01 < table.pgd.tf || vaddr.rsx01 > table.pgd.tl)
 			return PGM_REGION_SECOND_TRANS;
 		if (sg->edat_level >= 1)
-			*dat_protection |= rfte.p;
-		ptr = rfte.rto * PAGE_SIZE;
-shadow_r2t:
-		rc = gmap_shadow_r2t(sg, saddr, rfte.val, *fake);
-		if (rc)
-			return rc;
-		kvm->stat.gmap_shadow_r1_entry++;
-	}
+			w->p |= table.pgd.p;
+		ptr = table.pgd.rto * PAGE_SIZE;
+		w->level--;
 		fallthrough;
-	case ASCE_TYPE_REGION2: {
-		union region2_table_entry rste;
-
-		if (*fake) {
-			ptr += vaddr.rsx * _REGION2_SIZE;
-			rste.val = ptr;
-			goto shadow_r3t;
-		}
-		*pgt = ptr + vaddr.rsx * 8;
-		rc = gmap_read_table(parent, ptr + vaddr.rsx * 8, &rste.val);
+	case ASCE_TYPE_REGION2:
+		w->last_addr = ptr + vaddr.rsx * 8;
+		rc = __kvm_s390_faultin_read_gpa(kvm, entries + w->level, w->last_addr, &table.val);
 		if (rc)
 			return rc;
-		if (rste.i)
+		if (table.p4d.i)
 			return PGM_REGION_SECOND_TRANS;
-		if (rste.tt != TABLE_TYPE_REGION2)
+		if (table.p4d.tt != TABLE_TYPE_REGION2)
 			return PGM_TRANSLATION_SPEC;
-		if (vaddr.rtx01 < rste.tf || vaddr.rtx01 > rste.tl)
+		if (vaddr.rtx01 < table.p4d.tf || vaddr.rtx01 > table.p4d.tl)
 			return PGM_REGION_THIRD_TRANS;
 		if (sg->edat_level >= 1)
-			*dat_protection |= rste.p;
-		ptr = rste.rto * PAGE_SIZE;
-shadow_r3t:
-		rste.p |= *dat_protection;
-		rc = gmap_shadow_r3t(sg, saddr, rste.val, *fake);
-		if (rc)
-			return rc;
-		kvm->stat.gmap_shadow_r2_entry++;
-	}
+			w->p |= table.p4d.p;
+		ptr = table.p4d.rto * PAGE_SIZE;
+		w->level--;
 		fallthrough;
-	case ASCE_TYPE_REGION3: {
-		union region3_table_entry rtte;
-
-		if (*fake) {
-			ptr += vaddr.rtx * _REGION3_SIZE;
-			rtte.val = ptr;
-			goto shadow_sgt;
-		}
-		*pgt = ptr + vaddr.rtx * 8;
-		rc = gmap_read_table(parent, ptr + vaddr.rtx * 8, &rtte.val);
+	case ASCE_TYPE_REGION3:
+		w->last_addr = ptr + vaddr.rtx * 8;
+		rc = __kvm_s390_faultin_read_gpa(kvm, entries + w->level, w->last_addr, &table.val);
 		if (rc)
 			return rc;
-		if (rtte.i)
+		if (table.pud.i)
 			return PGM_REGION_THIRD_TRANS;
-		if (rtte.tt != TABLE_TYPE_REGION3)
+		if (table.pud.tt != TABLE_TYPE_REGION3)
 			return PGM_TRANSLATION_SPEC;
-		if (rtte.cr && asce.p && sg->edat_level >= 2)
+		if (table.pud.cr && asce.p && sg->edat_level >= 2)
 			return PGM_TRANSLATION_SPEC;
-		if (rtte.fc && sg->edat_level >= 2) {
-			*dat_protection |= rtte.fc0.p;
-			*fake = 1;
-			ptr = rtte.fc1.rfaa * _REGION3_SIZE;
-			rtte.val = ptr;
-			goto shadow_sgt;
+		if (sg->edat_level >= 1)
+			w->p |= table.pud.p;
+		if (table.pud.fc && sg->edat_level >= 2) {
+			table.val = u64_replace_bits(table.val, saddr, ~_REGION3_MASK);
+			goto edat_applies;
 		}
-		if (vaddr.sx01 < rtte.fc0.tf || vaddr.sx01 > rtte.fc0.tl)
+		if (vaddr.sx01 < table.pud.fc0.tf || vaddr.sx01 > table.pud.fc0.tl)
 			return PGM_SEGMENT_TRANSLATION;
-		if (sg->edat_level >= 1)
-			*dat_protection |= rtte.fc0.p;
-		ptr = rtte.fc0.sto * PAGE_SIZE;
-shadow_sgt:
-		rtte.fc0.p |= *dat_protection;
-		rc = gmap_shadow_sgt(sg, saddr, rtte.val, *fake);
-		if (rc)
-			return rc;
-		kvm->stat.gmap_shadow_r3_entry++;
-	}
+		ptr = table.pud.fc0.sto * PAGE_SIZE;
+		w->level--;
 		fallthrough;
-	case ASCE_TYPE_SEGMENT: {
-		union segment_table_entry ste;
-
-		if (*fake) {
-			ptr += vaddr.sx * _SEGMENT_SIZE;
-			ste.val = ptr;
-			goto shadow_pgt;
-		}
-		*pgt = ptr + vaddr.sx * 8;
-		rc = gmap_read_table(parent, ptr + vaddr.sx * 8, &ste.val);
+	case ASCE_TYPE_SEGMENT:
+		w->last_addr = ptr + vaddr.sx * 8;
+		rc = __kvm_s390_faultin_read_gpa(kvm, entries + w->level, w->last_addr, &table.val);
 		if (rc)
 			return rc;
-		if (ste.i)
+		if (table.pmd.i)
 			return PGM_SEGMENT_TRANSLATION;
-		if (ste.tt != TABLE_TYPE_SEGMENT)
+		if (table.pmd.tt != TABLE_TYPE_SEGMENT)
 			return PGM_TRANSLATION_SPEC;
-		if (ste.cs && asce.p)
+		if (table.pmd.cs && asce.p)
 			return PGM_TRANSLATION_SPEC;
-		*dat_protection |= ste.fc0.p;
-		if (ste.fc && sg->edat_level >= 1) {
-			*fake = 1;
-			ptr = ste.fc1.sfaa * _SEGMENT_SIZE;
-			ste.val = ptr;
-			goto shadow_pgt;
+		w->p |= table.pmd.p;
+		if (table.pmd.fc && sg->edat_level >= 1) {
+			table.val = u64_replace_bits(table.val, saddr, ~_SEGMENT_MASK);
+			goto edat_applies;
 		}
-		ptr = ste.fc0.pto * (PAGE_SIZE / 2);
-shadow_pgt:
-		ste.fc0.p |= *dat_protection;
-		rc = gmap_shadow_pgt(sg, saddr, ste.val, *fake);
-		if (rc)
-			return rc;
-		kvm->stat.gmap_shadow_sg_entry++;
+		ptr = table.pmd.fc0.pto * (PAGE_SIZE / 2);
+		w->level--;
 	}
-	}
-	/* Return the parent address of the page table */
-	*pgt = ptr;
+	w->last_addr = ptr + vaddr.px * 8;
+	rc = __kvm_s390_faultin_read_gpa(kvm, entries + w->level, w->last_addr, &table.val);
+	if (rc)
+		return rc;
+	if (table.pte.i)
+		return PGM_PAGE_TRANSLATION;
+	if (table.pte.z)
+		return PGM_TRANSLATION_SPEC;
+	w->p |= table.pte.p;
+edat_applies:
+	if (wr && w->p)
+		return PGM_PROTECTION;
+	return __kvm_s390_faultin_gfn(kvm, entries + LEVEL_MEM, table.pte.pfra, wr);
+}
+
+static int _do_shadow_pte(struct gmap *sg, gpa_t raddr, union pte *ptep_h, union pte *ptep,
+			  struct guest_fault *f, bool p)
+{
+	union pgste pgste;
+	union pte newpte;
+	int rc;
+
+	scoped_guard(spinlock, &sg->host_to_rmap_lock)
+		rc = gmap_insert_rmap(sg, f->gfn, gpa_to_gfn(raddr), LEVEL_PTE);
+	if (rc)
+		return rc;
+
+	pgste = pgste_get_lock(ptep_h);
+	newpte = _pte(f->pfn, f->writable, !p, 0);
+	newpte.s.d |= ptep->s.d;
+	newpte.s.sd |= ptep->s.sd;
+	newpte.h.p &= ptep->h.p;
+	pgste = gmap_ptep_xchg(sg->parent, ptep_h, newpte, pgste, f->gfn);
+	pgste.vsie_notif = 1;
+	pgste_set_unlock(ptep_h, pgste);
+
+	newpte = _pte(f->pfn, 0, !p, 0);
+	pgste = pgste_get_lock(ptep);
+	pgste = __dat_ptep_xchg(ptep, pgste, newpte, gpa_to_gfn(raddr), sg->asce, sg->uses_skeys);
+	pgste_set_unlock(ptep, pgste);
+
 	return 0;
 }
 
-/**
- * shadow_pgt_lookup() - find a shadow page table
- * @sg: pointer to the shadow guest address space structure
- * @saddr: the address in the shadow aguest address space
- * @pgt: parent gmap address of the page table to get shadowed
- * @dat_protection: if the pgtable is marked as protected by dat
- * @fake: pgt references contiguous guest memory block, not a pgtable
- *
- * Returns 0 if the shadow page table was found and -EAGAIN if the page
- * table was not found.
- *
- * Called with sg->mm->mmap_lock in read.
- */
-static int shadow_pgt_lookup(struct gmap *sg, unsigned long saddr, unsigned long *pgt,
-			     int *dat_protection, int *fake)
+static int _do_shadow_crste(struct gmap *sg, gpa_t raddr, union crste *host, union crste *table,
+			    struct guest_fault *f, bool p)
 {
-	unsigned long pt_index;
-	unsigned long *table;
-	struct page *page;
+	union crste newcrste;
+	gfn_t gfn;
 	int rc;
 
-	spin_lock(&sg->guest_table_lock);
-	table = gmap_table_walk(sg, saddr, 1); /* get segment pointer */
-	if (table && !(*table & _SEGMENT_ENTRY_INVALID)) {
-		/* Shadow page tables are full pages (pte+pgste) */
-		page = pfn_to_page(*table >> PAGE_SHIFT);
-		pt_index = gmap_pgste_get_pgt_addr(page_to_virt(page));
-		*pgt = pt_index & ~GMAP_SHADOW_FAKE_TABLE;
-		*dat_protection = !!(*table & _SEGMENT_ENTRY_PROTECT);
-		*fake = !!(pt_index & GMAP_SHADOW_FAKE_TABLE);
-		rc = 0;
-	} else  {
-		rc = -EAGAIN;
+	lockdep_assert_held_write(&sg->kvm->mmu_lock);
+
+	gfn = f->gfn & gpa_to_gfn(is_pmd(*table) ? _SEGMENT_MASK : _REGION3_MASK);
+	scoped_guard(spinlock, &sg->host_to_rmap_lock)
+		rc = gmap_insert_rmap(sg, gfn, gpa_to_gfn(raddr), host->h.tt);
+	if (rc)
+		return rc;
+
+	newcrste = _crste_fc1(f->pfn, host->h.tt, f->writable, !p);
+	newcrste.s.fc1.d |= host->s.fc1.d;
+	newcrste.s.fc1.sd |= host->s.fc1.sd;
+	newcrste.h.p &= host->h.p;
+	newcrste.s.fc1.vsie_notif = 1;
+	newcrste.s.fc1.prefix_notif = host->s.fc1.prefix_notif;
+	gmap_crstep_xchg(sg->parent, host, newcrste, f->gfn);
+
+	newcrste = _crste_fc1(f->pfn, host->h.tt, 0, !p);
+	dat_crstep_xchg(table, newcrste, gpa_to_gfn(raddr), sg->asce);
+	return 0;
+}
+
+static int _gaccess_do_shadow(struct gmap *sg, unsigned long saddr, struct pgtwalk *w)
+{
+	union crste *table, *host;
+	int i, hl, gl, l, rc;
+	struct guest_fault *entries;
+	union pte *ptep, *ptep_h;
+
+	lockdep_assert_held(&sg->kvm->mmu_lock);
+	entries = get_entries(w);
+	ptep_h = NULL;
+	ptep = NULL;
+
+	rc = dat_entry_walk(gpa_to_gfn(saddr), sg->asce, DAT_WALK_ANY, LEVEL_PTE, &table, &ptep);
+	if (rc)
+		return rc;
+
+	/* A race occourred. The shadow mapping is already valid, nothing to do */
+	if ((ptep && !ptep->h.i) || (!ptep && crste_leaf(*table)))
+		return 0;
+
+	gl = get_level(table, ptep);
+	if (KVM_BUG_ON(gl < w->level, sg->kvm))
+		return -EFAULT;
+
+	/*
+	 * Skip levels that are already protected. For each level, protect
+	 * only the page containing the entry, not the whole table.
+	 */
+	for (i = gl ; i > w->level; i--)
+		gmap_protect_rmap(sg, entries[i - 1].gfn, gpa_to_gfn(saddr),
+				  entries[i - 1].pfn, i, entries[i - 1].writable);
+
+	rc = dat_entry_walk(entries[LEVEL_MEM].gfn, sg->parent->asce, DAT_WALK_LEAF, LEVEL_PTE,
+			    &host, &ptep_h);
+	if (rc)
+		return rc;
+
+	hl = get_level(host, ptep_h);
+	/* Get the smallest granularity */
+	l = min(hl, w->level);
+
+	/* If necessary, create the shadow mapping */
+	if (l < gl) {
+		rc = dat_entry_walk(gpa_to_gfn(saddr), sg->asce, DAT_WALK_SPLIT_ALLOC,
+				    l, &table, &ptep);
+		if (rc)
+			return rc;
 	}
-	spin_unlock(&sg->guest_table_lock);
-	return rc;
+	if (l < hl) {
+		rc = dat_entry_walk(entries[LEVEL_MEM].gfn, sg->parent->asce, DAT_WALK_SPLIT_ALLOC,
+				    l, &host, &ptep_h);
+		if (rc)
+			return rc;
+	}
+
+	if (KVM_BUG_ON(l > LEVEL_PUD, sg->kvm))
+		return -EFAULT;
+	if (l == LEVEL_PTE)
+		return _do_shadow_pte(sg, saddr, ptep_h, ptep, entries + LEVEL_MEM, w->p);
+	return _do_shadow_crste(sg, saddr, host, table, entries + LEVEL_MEM, w->p);
 }
 
 /**
- * kvm_s390_shadow_fault - handle fault on a shadow page table
- * @vcpu: virtual cpu
- * @sg: pointer to the shadow guest address space structure
+ * __kvm_s390_shadow_fault() - handle fault on a shadow page table
+ * @vcpu: virtual cpu that triggered the action
+ * @sg: the shadow guest address space structure
  * @saddr: faulting address in the shadow gmap
  * @datptr: will contain the address of the faulting DAT table entry, or of
  *	    the valid leaf, plus some flags
+ * @wr: whether this is a write access
  *
- * Returns: - 0 if the shadow fault was successfully resolved
- *	    - > 0 (pgm exception code) on exceptions while faulting
- *	    - -EAGAIN if the caller can retry immediately
- *	    - -EFAULT when accessing invalid guest addresses
- *	    - -ENOMEM if out of memory
+ * Return:
+ * * 0 if the shadow fault was successfully resolved
+ * * > 0 (pgm exception code) on exceptions while faulting
+ * * -EAGAIN if the caller can retry immediately
+ * * -EFAULT when accessing invalid guest addresses
+ * * -ENOMEM if out of memory
  */
-int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg,
-			  unsigned long saddr, unsigned long *datptr)
+static int __gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
+				  union mvpg_pei *datptr, bool wr)
 {
-	union vaddress vaddr;
-	union page_table_entry pte;
-	unsigned long pgt = 0;
-	int dat_protection, fake;
+	struct pgtwalk walk = {	.p = false, };
+	unsigned long seq;
 	int rc;
 
-	if (KVM_BUG_ON(!gmap_is_shadow(sg), vcpu->kvm))
-		return -EFAULT;
+	seq = vcpu->kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
 
-	mmap_read_lock(sg->mm);
-	/*
-	 * We don't want any guest-2 tables to change - so the parent
-	 * tables/pointers we read stay valid - unshadowing is however
-	 * always possible - only guest_table_lock protects us.
-	 */
-	ipte_lock(vcpu->kvm);
+	rc = walk_guest_tables(sg, saddr, &walk, wr);
+	if (datptr) {
+		datptr->val = walk.last_addr;
+		datptr->dat_prot = wr && walk.p;
+		datptr->not_pte = walk.level > LEVEL_PTE;
+		datptr->real = sg->guest_asce.r;
+	}
+	if (rc) {
+		release_faultin_array(vcpu->kvm, walk.raw_entries, true);
+		return rc;
+	}
 
-	rc = shadow_pgt_lookup(sg, saddr, &pgt, &dat_protection, &fake);
-	if (rc)
-		rc = kvm_s390_shadow_tables(sg, saddr, &pgt, &dat_protection,
-					    &fake);
+	if (__kvm_s390_fault_array_needs_retry(vcpu->kvm, seq, walk.raw_entries, true))
+		return -EAGAIN;
 
-	vaddr.addr = saddr;
-	if (fake) {
-		pte.val = pgt + vaddr.px * PAGE_SIZE;
-		goto shadow_page;
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
+		if (__kvm_s390_fault_array_needs_retry(vcpu->kvm, seq, walk.raw_entries, false))
+			return -EAGAIN;
+		scoped_guard(spinlock, &sg->parent->children_lock)
+			rc = _gaccess_do_shadow(sg, saddr, &walk);
+		release_faultin_array(vcpu->kvm, walk.raw_entries, !!rc);
 	}
+	return rc;
+}
 
-	switch (rc) {
-	case PGM_SEGMENT_TRANSLATION:
-	case PGM_REGION_THIRD_TRANS:
-	case PGM_REGION_SECOND_TRANS:
-	case PGM_REGION_FIRST_TRANS:
-		pgt |= PEI_NOT_PTE;
-		break;
-	case 0:
-		pgt += vaddr.px * 8;
-		rc = gmap_read_table(sg->parent, pgt, &pte.val);
-	}
-	if (datptr)
-		*datptr = pgt | dat_protection * PEI_DAT_PROT;
-	if (!rc && pte.i)
-		rc = PGM_PAGE_TRANSLATION;
-	if (!rc && pte.z)
-		rc = PGM_TRANSLATION_SPEC;
-shadow_page:
-	pte.p |= dat_protection;
-	if (!rc)
-		rc = gmap_shadow_page(sg, saddr, __pte(pte.val));
-	vcpu->kvm->stat.gmap_shadow_pg_entry++;
+int gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
+			 union mvpg_pei *datptr, bool wr)
+{
+	int rc;
+
+	if (KVM_BUG_ON(!sg->is_shadow, vcpu->kvm))
+		return -EFAULT;
+
+	ipte_lock(vcpu->kvm);
+	rc = __gaccess_shadow_fault(vcpu, sg, saddr, datptr, wr || sg->guest_asce.r);
 	ipte_unlock(vcpu->kvm);
-	mmap_read_unlock(sg->mm);
 	return rc;
 }
diff --git a/arch/s390/kvm/gaccess.h b/arch/s390/kvm/gaccess.h
index 9c82f7460821..cd19a29d31d8 100644
--- a/arch/s390/kvm/gaccess.h
+++ b/arch/s390/kvm/gaccess.h
@@ -450,12 +450,18 @@ void ipte_unlock(struct kvm *kvm);
 int ipte_lock_held(struct kvm *kvm);
 int kvm_s390_check_low_addr_prot_real(struct kvm_vcpu *vcpu, unsigned long gra);
 
-/* MVPG PEI indication bits */
-#define PEI_DAT_PROT 2
-#define PEI_NOT_PTE 4
+union mvpg_pei {
+	unsigned long val;
+	struct {
+		unsigned long addr    : 61;
+		unsigned long not_pte :  1;
+		unsigned long dat_prot:  1;
+		unsigned long real    :  1;
+	};
+};
 
-int kvm_s390_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *shadow,
-			  unsigned long saddr, unsigned long *datptr);
+int gaccess_shadow_fault(struct kvm_vcpu *vcpu, struct gmap *sg, gpa_t saddr,
+			 union mvpg_pei *datptr, bool wr);
 
 static inline int __kvm_s390_faultin_read_gpa(struct kvm *kvm, struct guest_fault *f, gpa_t gaddr,
 					      unsigned long *val)
diff --git a/arch/s390/kvm/gmap-vsie.c b/arch/s390/kvm/gmap-vsie.c
deleted file mode 100644
index 56ef153eb8fe..000000000000
--- a/arch/s390/kvm/gmap-vsie.c
+++ /dev/null
@@ -1,141 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- * Guest memory management for KVM/s390 nested VMs.
- *
- * Copyright IBM Corp. 2008, 2020, 2024
- *
- *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
- *               Martin Schwidefsky <schwidefsky@de.ibm.com>
- *               David Hildenbrand <david@redhat.com>
- *               Janosch Frank <frankja@linux.vnet.ibm.com>
- */
-
-#include <linux/compiler.h>
-#include <linux/kvm.h>
-#include <linux/kvm_host.h>
-#include <linux/pgtable.h>
-#include <linux/pagemap.h>
-#include <linux/mman.h>
-
-#include <asm/lowcore.h>
-#include <asm/gmap.h>
-#include <asm/uv.h>
-
-#include "kvm-s390.h"
-
-/**
- * gmap_find_shadow - find a specific asce in the list of shadow tables
- * @parent: pointer to the parent gmap
- * @asce: ASCE for which the shadow table is created
- * @edat_level: edat level to be used for the shadow translation
- *
- * Returns the pointer to a gmap if a shadow table with the given asce is
- * already available, ERR_PTR(-EAGAIN) if another one is just being created,
- * otherwise NULL
- *
- * Context: Called with parent->shadow_lock held
- */
-static struct gmap *gmap_find_shadow(struct gmap *parent, unsigned long asce, int edat_level)
-{
-	struct gmap *sg;
-
-	lockdep_assert_held(&parent->shadow_lock);
-	list_for_each_entry(sg, &parent->children, list) {
-		if (!gmap_shadow_valid(sg, asce, edat_level))
-			continue;
-		if (!sg->initialized)
-			return ERR_PTR(-EAGAIN);
-		refcount_inc(&sg->ref_count);
-		return sg;
-	}
-	return NULL;
-}
-
-/**
- * gmap_shadow - create/find a shadow guest address space
- * @parent: pointer to the parent gmap
- * @asce: ASCE for which the shadow table is created
- * @edat_level: edat level to be used for the shadow translation
- *
- * The pages of the top level page table referred by the asce parameter
- * will be set to read-only and marked in the PGSTEs of the kvm process.
- * The shadow table will be removed automatically on any change to the
- * PTE mapping for the source table.
- *
- * Returns a guest address space structure, ERR_PTR(-ENOMEM) if out of memory,
- * ERR_PTR(-EAGAIN) if the caller has to retry and ERR_PTR(-EFAULT) if the
- * parent gmap table could not be protected.
- */
-struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce, int edat_level)
-{
-	struct gmap *sg, *new;
-	unsigned long limit;
-	int rc;
-
-	if (KVM_BUG_ON(parent->mm->context.allow_gmap_hpage_1m, (struct kvm *)parent->private) ||
-	    KVM_BUG_ON(gmap_is_shadow(parent), (struct kvm *)parent->private))
-		return ERR_PTR(-EFAULT);
-	spin_lock(&parent->shadow_lock);
-	sg = gmap_find_shadow(parent, asce, edat_level);
-	spin_unlock(&parent->shadow_lock);
-	if (sg)
-		return sg;
-	/* Create a new shadow gmap */
-	limit = -1UL >> (33 - (((asce & _ASCE_TYPE_MASK) >> 2) * 11));
-	if (asce & _ASCE_REAL_SPACE)
-		limit = -1UL;
-	new = gmap_alloc(limit);
-	if (!new)
-		return ERR_PTR(-ENOMEM);
-	new->mm = parent->mm;
-	new->parent = gmap_get(parent);
-	new->private = parent->private;
-	new->orig_asce = asce;
-	new->edat_level = edat_level;
-	new->initialized = false;
-	spin_lock(&parent->shadow_lock);
-	/* Recheck if another CPU created the same shadow */
-	sg = gmap_find_shadow(parent, asce, edat_level);
-	if (sg) {
-		spin_unlock(&parent->shadow_lock);
-		gmap_free(new);
-		return sg;
-	}
-	if (asce & _ASCE_REAL_SPACE) {
-		/* only allow one real-space gmap shadow */
-		list_for_each_entry(sg, &parent->children, list) {
-			if (sg->orig_asce & _ASCE_REAL_SPACE) {
-				spin_lock(&sg->guest_table_lock);
-				gmap_unshadow(sg);
-				spin_unlock(&sg->guest_table_lock);
-				list_del(&sg->list);
-				gmap_put(sg);
-				break;
-			}
-		}
-	}
-	refcount_set(&new->ref_count, 2);
-	list_add(&new->list, &parent->children);
-	if (asce & _ASCE_REAL_SPACE) {
-		/* nothing to protect, return right away */
-		new->initialized = true;
-		spin_unlock(&parent->shadow_lock);
-		return new;
-	}
-	spin_unlock(&parent->shadow_lock);
-	/* protect after insertion, so it will get properly invalidated */
-	mmap_read_lock(parent->mm);
-	rc = __kvm_s390_mprotect_many(parent, asce & _ASCE_ORIGIN,
-				      ((asce & _ASCE_TABLE_LENGTH) + 1),
-				      PROT_READ, GMAP_NOTIFY_SHADOW);
-	mmap_read_unlock(parent->mm);
-	spin_lock(&parent->shadow_lock);
-	new->initialized = true;
-	if (rc) {
-		list_del(&new->list);
-		gmap_free(new);
-		new = ERR_PTR(rc);
-	}
-	spin_unlock(&parent->shadow_lock);
-	return new;
-}
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 42c936362e3e..001b069a6c7b 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -673,13 +673,13 @@ static int _gmap_enable_skeys(struct gmap *gmap)
 	gfn_t start = 0;
 	int rc;
 
-	if (mm_uses_skeys(gmap->kvm->mm))
+	if (gmap->uses_skeys)
 		return 0;
 
-	gmap->kvm->mm->context.uses_skeys = 1;
+	WRITE_ONCE(gmap->uses_skeys, 1);
 	rc = gmap_helper_disable_cow_sharing();
 	if (rc) {
-		gmap->kvm->mm->context.uses_skeys = 0;
+		WRITE_ONCE(gmap->uses_skeys, 0);
 		return rc;
 	}
 
diff --git a/arch/s390/kvm/intercept.c b/arch/s390/kvm/intercept.c
index c7908950c1f4..0481a30b2629 100644
--- a/arch/s390/kvm/intercept.c
+++ b/arch/s390/kvm/intercept.c
@@ -367,7 +367,9 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg2, &srcaddr, GACC_FETCH, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = kvm_s390_handle_dat_fault(vcpu, srcaddr, 0);
+	do {
+		rc = kvm_s390_handle_dat_fault(vcpu, srcaddr, 0);
+	} while (rc == -EAGAIN);
 	if (rc != 0)
 		return rc;
 
@@ -376,7 +378,9 @@ static int handle_mvpg_pei(struct kvm_vcpu *vcpu)
 					      reg1, &dstaddr, GACC_STORE, 0);
 	if (rc)
 		return kvm_s390_inject_prog_cond(vcpu, rc);
-	rc = kvm_s390_handle_dat_fault(vcpu, dstaddr, FOLL_WRITE);
+	do {
+		rc = kvm_s390_handle_dat_fault(vcpu, dstaddr, FOLL_WRITE);
+	} while (rc == -EAGAIN);
 	if (rc != 0)
 		return rc;
 
diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 60c360c18690..7f07f6c0ab85 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -26,7 +26,6 @@
 #include <linux/uaccess.h>
 #include <asm/sclp.h>
 #include <asm/isc.h>
-#include <asm/gmap.h>
 #include <asm/nmi.h>
 #include <asm/airq.h>
 #include <asm/tpi.h>
@@ -34,6 +33,7 @@
 #include "gaccess.h"
 #include "trace-s390.h"
 #include "pci.h"
+#include "gmap.h"
 
 #define PFAULT_INIT 0x0600
 #define PFAULT_DONE 0x0680
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index af8a62abec48..1d6c15601a20 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -39,7 +39,6 @@
 #include <asm/lowcore.h>
 #include <asm/machine.h>
 #include <asm/stp.h>
-#include <asm/gmap.h>
 #include <asm/gmap_helpers.h>
 #include <asm/nmi.h>
 #include <asm/isc.h>
@@ -52,6 +51,7 @@
 #include <asm/uv.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
+#include "gmap.h"
 #include "pci.h"
 
 #define CREATE_TRACE_POINTS
@@ -262,15 +262,11 @@ static DECLARE_BITMAP(kvm_s390_available_cpu_feat, KVM_S390_VM_CPU_FEAT_NR_BITS)
 /* available subfunctions indicated via query / "test bit" */
 static struct kvm_s390_vm_cpu_subfunc kvm_s390_available_subfunc;
 
-static struct gmap_notifier gmap_notifier;
-static struct gmap_notifier vsie_gmap_notifier;
 debug_info_t *kvm_s390_dbf;
 debug_info_t *kvm_s390_dbf_uv;
 
 /* Section: not file related */
 /* forward declarations */
-static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
-			      unsigned long end);
 static int sca_switch_to_extended(struct kvm *kvm);
 
 static void kvm_clock_sync_scb(struct kvm_s390_sie_block *scb, u64 delta)
@@ -528,10 +524,6 @@ static int __init __kvm_s390_init(void)
 	if (rc)
 		goto err_gib;
 
-	gmap_notifier.notifier_call = kvm_gmap_notifier;
-	gmap_register_pte_notifier(&gmap_notifier);
-	vsie_gmap_notifier.notifier_call = kvm_s390_vsie_gmap_notifier;
-	gmap_register_pte_notifier(&vsie_gmap_notifier);
 	atomic_notifier_chain_register(&s390_epoch_delta_notifier,
 				       &kvm_clock_notifier);
 
@@ -551,8 +543,6 @@ static int __init __kvm_s390_init(void)
 
 static void __kvm_s390_exit(void)
 {
-	gmap_unregister_pte_notifier(&gmap_notifier);
-	gmap_unregister_pte_notifier(&vsie_gmap_notifier);
 	atomic_notifier_chain_unregister(&s390_epoch_delta_notifier,
 					 &kvm_clock_notifier);
 
@@ -568,7 +558,7 @@ long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg)
 {
 	if (ioctl == KVM_S390_ENABLE_SIE)
-		return s390_enable_sie();
+		return 0;
 	return -EINVAL;
 }
 
@@ -694,32 +684,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 
 void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
 {
-	int i;
-	gfn_t cur_gfn, last_gfn;
-	unsigned long gaddr, vmaddr;
-	struct gmap *gmap = kvm->arch.gmap;
-	DECLARE_BITMAP(bitmap, _PAGE_ENTRIES);
-
-	/* Loop over all guest segments */
-	cur_gfn = memslot->base_gfn;
-	last_gfn = memslot->base_gfn + memslot->npages;
-	for (; cur_gfn <= last_gfn; cur_gfn += _PAGE_ENTRIES) {
-		gaddr = gfn_to_gpa(cur_gfn);
-		vmaddr = gfn_to_hva_memslot(memslot, cur_gfn);
-		if (kvm_is_error_hva(vmaddr))
-			continue;
-
-		bitmap_zero(bitmap, _PAGE_ENTRIES);
-		gmap_sync_dirty_log_pmd(gmap, bitmap, gaddr, vmaddr);
-		for (i = 0; i < _PAGE_ENTRIES; i++) {
-			if (test_bit(i, bitmap))
-				mark_page_dirty(kvm, cur_gfn + i);
-		}
+	gfn_t last_gfn = memslot->base_gfn + memslot->npages;
 
-		if (fatal_signal_pending(current))
-			return;
-		cond_resched();
-	}
+	scoped_guard(read_lock, &kvm->mmu_lock)
+		gmap_sync_dirty_log(kvm->arch.gmap, memslot->base_gfn, last_gfn);
 }
 
 /* Section: vm related */
@@ -879,9 +847,6 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 			r = -EINVAL;
 		else {
 			r = 0;
-			mmap_write_lock(kvm->mm);
-			kvm->mm->context.allow_gmap_hpage_1m = 1;
-			mmap_write_unlock(kvm->mm);
 			/*
 			 * We might have to create fake 4k page
 			 * tables. To avoid that the hardware works on
@@ -948,7 +913,7 @@ static int kvm_s390_get_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *attr)
 {
 	int ret;
-	unsigned int idx;
+
 	switch (attr->attr) {
 	case KVM_S390_VM_MEM_ENABLE_CMMA:
 		ret = -ENXIO;
@@ -959,8 +924,6 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		mutex_lock(&kvm->lock);
 		if (kvm->created_vcpus)
 			ret = -EBUSY;
-		else if (kvm->mm->context.allow_gmap_hpage_1m)
-			ret = -EINVAL;
 		else {
 			kvm->arch.use_cmma = 1;
 			/* Not compatible with cmma. */
@@ -969,7 +932,9 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		}
 		mutex_unlock(&kvm->lock);
 		break;
-	case KVM_S390_VM_MEM_CLR_CMMA:
+	case KVM_S390_VM_MEM_CLR_CMMA: {
+		gfn_t start_gfn = 0;
+
 		ret = -ENXIO;
 		if (!sclp.has_cmma)
 			break;
@@ -978,13 +943,13 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 			break;
 
 		VM_EVENT(kvm, 3, "%s", "RESET: CMMA states");
-		mutex_lock(&kvm->lock);
-		idx = srcu_read_lock(&kvm->srcu);
-		s390_reset_cmma(kvm->arch.gmap->mm);
-		srcu_read_unlock(&kvm->srcu, idx);
-		mutex_unlock(&kvm->lock);
+		do {
+			start_gfn = dat_reset_cmma(kvm->arch.gmap->asce, start_gfn);
+			cond_resched();
+		} while (start_gfn);
 		ret = 0;
 		break;
+	}
 	case KVM_S390_VM_MEM_LIMIT_SIZE: {
 		unsigned long new_limit;
 
@@ -1001,29 +966,14 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		if (!new_limit)
 			return -EINVAL;
 
-		/* gmap_create takes last usable address */
-		if (new_limit != KVM_S390_NO_MEM_LIMIT)
-			new_limit -= 1;
-
 		ret = -EBUSY;
-		mutex_lock(&kvm->lock);
-		if (!kvm->created_vcpus) {
-			/* gmap_create will round the limit up */
-			struct gmap *new = gmap_create(current->mm, new_limit);
-
-			if (!new) {
-				ret = -ENOMEM;
-			} else {
-				gmap_remove(kvm->arch.gmap);
-				new->private = kvm;
-				kvm->arch.gmap = new;
-				ret = 0;
-			}
+		scoped_guard(write_lock, &kvm->mmu_lock) {
+			if (!kvm->created_vcpus)
+				ret = gmap_set_limit(kvm->arch.gmap, gpa_to_gfn(new_limit));
 		}
-		mutex_unlock(&kvm->lock);
 		VM_EVENT(kvm, 3, "SET: max guest address: %lu", new_limit);
 		VM_EVENT(kvm, 3, "New guest asce: 0x%p",
-			 (void *) kvm->arch.gmap->asce);
+			 (void *)kvm->arch.gmap->asce.val);
 		break;
 	}
 	default:
@@ -1188,19 +1138,13 @@ static int kvm_s390_vm_start_migration(struct kvm *kvm)
 		kvm->arch.migration_mode = 1;
 		return 0;
 	}
-	/* mark all the pages in active slots as dirty */
 	kvm_for_each_memslot(ms, bkt, slots) {
 		if (!ms->dirty_bitmap)
 			return -EINVAL;
-		/*
-		 * The second half of the bitmap is only used on x86,
-		 * and would be wasted otherwise, so we put it to good
-		 * use here to keep track of the state of the storage
-		 * attributes.
-		 */
-		memset(kvm_second_dirty_bitmap(ms), 0xff, kvm_dirty_bitmap_bytes(ms));
 		ram_pages += ms->npages;
 	}
+	/* mark all the pages as dirty */
+	gmap_set_cmma_all_dirty(kvm->arch.gmap);
 	atomic64_set(&kvm->arch.cmma_dirty_pages, ram_pages);
 	kvm->arch.migration_mode = 1;
 	kvm_s390_sync_request_broadcast(kvm, KVM_REQ_START_MIGRATION);
@@ -2112,40 +2056,32 @@ static int kvm_s390_vm_has_attr(struct kvm *kvm, struct kvm_device_attr *attr)
 
 static int kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 {
-	uint8_t *keys;
-	uint64_t hva;
-	int srcu_idx, i, r = 0;
+	union skey *keys;
+	int i, r = 0;
 
 	if (args->flags != 0)
 		return -EINVAL;
 
 	/* Is this guest using storage keys? */
-	if (!mm_uses_skeys(current->mm))
+	if (!kvm->arch.gmap->uses_skeys)
 		return KVM_S390_GET_SKEYS_NONE;
 
 	/* Enforce sane limit on memory allocation */
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
+	keys = kvmalloc_array(args->count, sizeof(*keys), GFP_KERNEL_ACCOUNT);
 	if (!keys)
 		return -ENOMEM;
 
-	mmap_read_lock(current->mm);
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-	for (i = 0; i < args->count; i++) {
-		hva = gfn_to_hva(kvm, args->start_gfn + i);
-		if (kvm_is_error_hva(hva)) {
-			r = -EFAULT;
-			break;
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		for (i = 0; i < args->count; i++) {
+			r = dat_get_storage_key(kvm->arch.gmap->asce,
+						args->start_gfn + i, keys + i);
+			if (r)
+				break;
 		}
-
-		r = get_guest_storage_key(current->mm, hva, &keys[i]);
-		if (r)
-			break;
 	}
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	mmap_read_unlock(current->mm);
 
 	if (!r) {
 		r = copy_to_user((uint8_t __user *)args->skeydata_addr, keys,
@@ -2160,10 +2096,8 @@ static int kvm_s390_get_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 
 static int kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 {
-	uint8_t *keys;
-	uint64_t hva;
-	int srcu_idx, i, r = 0;
-	bool unlocked;
+	union skey *keys;
+	int i, r = 0;
 
 	if (args->flags != 0)
 		return -EINVAL;
@@ -2172,7 +2106,7 @@ static int kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	if (args->count < 1 || args->count > KVM_S390_SKEYS_MAX)
 		return -EINVAL;
 
-	keys = kvmalloc_array(args->count, sizeof(uint8_t), GFP_KERNEL_ACCOUNT);
+	keys = kvmalloc_array(args->count, sizeof(*keys), GFP_KERNEL_ACCOUNT);
 	if (!keys)
 		return -ENOMEM;
 
@@ -2184,161 +2118,29 @@ static int kvm_s390_set_skeys(struct kvm *kvm, struct kvm_s390_skeys *args)
 	}
 
 	/* Enable storage key handling for the guest */
-	r = s390_enable_skey();
+	r = gmap_enable_skeys(kvm->arch.gmap);
 	if (r)
 		goto out;
 
-	i = 0;
-	mmap_read_lock(current->mm);
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-        while (i < args->count) {
-		unlocked = false;
-		hva = gfn_to_hva(kvm, args->start_gfn + i);
-		if (kvm_is_error_hva(hva)) {
-			r = -EFAULT;
-			break;
-		}
-
+	r = -EINVAL;
+	for (i = 0; i < args->count; i++) {
 		/* Lowest order bit is reserved */
-		if (keys[i] & 0x01) {
-			r = -EINVAL;
-			break;
-		}
-
-		r = set_guest_storage_key(current->mm, hva, keys[i], 0);
-		if (r) {
-			r = fixup_user_fault(current->mm, hva,
-					     FAULT_FLAG_WRITE, &unlocked);
+		if (keys[i].zero)
+			goto out;
+	}
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		for (i = 0; i < args->count; i++) {
+			r = dat_set_storage_key(kvm->arch.gmap->asce,
+						args->start_gfn + i, keys[i], 0);
 			if (r)
 				break;
 		}
-		if (!r)
-			i++;
 	}
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	mmap_read_unlock(current->mm);
 out:
 	kvfree(keys);
 	return r;
 }
 
-/*
- * Base address and length must be sent at the start of each block, therefore
- * it's cheaper to send some clean data, as long as it's less than the size of
- * two longs.
- */
-#define KVM_S390_MAX_BIT_DISTANCE (2 * sizeof(void *))
-/* for consistency */
-#define KVM_S390_CMMA_SIZE_MAX ((u32)KVM_S390_SKEYS_MAX)
-
-static int kvm_s390_peek_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
-			      u8 *res, unsigned long bufsize)
-{
-	unsigned long pgstev, hva, cur_gfn = args->start_gfn;
-
-	args->count = 0;
-	while (args->count < bufsize) {
-		hva = gfn_to_hva(kvm, cur_gfn);
-		/*
-		 * We return an error if the first value was invalid, but we
-		 * return successfully if at least one value was copied.
-		 */
-		if (kvm_is_error_hva(hva))
-			return args->count ? 0 : -EFAULT;
-		if (get_pgste(kvm->mm, hva, &pgstev) < 0)
-			pgstev = 0;
-		res[args->count++] = (pgstev >> 24) & 0x43;
-		cur_gfn++;
-	}
-
-	return 0;
-}
-
-static struct kvm_memory_slot *gfn_to_memslot_approx(struct kvm_memslots *slots,
-						     gfn_t gfn)
-{
-	return ____gfn_to_memslot(slots, gfn, true);
-}
-
-static unsigned long kvm_s390_next_dirty_cmma(struct kvm_memslots *slots,
-					      unsigned long cur_gfn)
-{
-	struct kvm_memory_slot *ms = gfn_to_memslot_approx(slots, cur_gfn);
-	unsigned long ofs = cur_gfn - ms->base_gfn;
-	struct rb_node *mnode = &ms->gfn_node[slots->node_idx];
-
-	if (ms->base_gfn + ms->npages <= cur_gfn) {
-		mnode = rb_next(mnode);
-		/* If we are above the highest slot, wrap around */
-		if (!mnode)
-			mnode = rb_first(&slots->gfn_tree);
-
-		ms = container_of(mnode, struct kvm_memory_slot, gfn_node[slots->node_idx]);
-		ofs = 0;
-	}
-
-	if (cur_gfn < ms->base_gfn)
-		ofs = 0;
-
-	ofs = find_next_bit(kvm_second_dirty_bitmap(ms), ms->npages, ofs);
-	while (ofs >= ms->npages && (mnode = rb_next(mnode))) {
-		ms = container_of(mnode, struct kvm_memory_slot, gfn_node[slots->node_idx]);
-		ofs = find_first_bit(kvm_second_dirty_bitmap(ms), ms->npages);
-	}
-	return ms->base_gfn + ofs;
-}
-
-static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
-			     u8 *res, unsigned long bufsize)
-{
-	unsigned long mem_end, cur_gfn, next_gfn, hva, pgstev;
-	struct kvm_memslots *slots = kvm_memslots(kvm);
-	struct kvm_memory_slot *ms;
-
-	if (unlikely(kvm_memslots_empty(slots)))
-		return 0;
-
-	cur_gfn = kvm_s390_next_dirty_cmma(slots, args->start_gfn);
-	ms = gfn_to_memslot(kvm, cur_gfn);
-	args->count = 0;
-	args->start_gfn = cur_gfn;
-	if (!ms)
-		return 0;
-	next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
-	mem_end = kvm_s390_get_gfn_end(slots);
-
-	while (args->count < bufsize) {
-		hva = gfn_to_hva(kvm, cur_gfn);
-		if (kvm_is_error_hva(hva))
-			return 0;
-		/* Decrement only if we actually flipped the bit to 0 */
-		if (test_and_clear_bit(cur_gfn - ms->base_gfn, kvm_second_dirty_bitmap(ms)))
-			atomic64_dec(&kvm->arch.cmma_dirty_pages);
-		if (get_pgste(kvm->mm, hva, &pgstev) < 0)
-			pgstev = 0;
-		/* Save the value */
-		res[args->count++] = (pgstev >> 24) & 0x43;
-		/* If the next bit is too far away, stop. */
-		if (next_gfn > cur_gfn + KVM_S390_MAX_BIT_DISTANCE)
-			return 0;
-		/* If we reached the previous "next", find the next one */
-		if (cur_gfn == next_gfn)
-			next_gfn = kvm_s390_next_dirty_cmma(slots, cur_gfn + 1);
-		/* Reached the end of memory or of the buffer, stop */
-		if ((next_gfn >= mem_end) ||
-		    (next_gfn - args->start_gfn >= bufsize))
-			return 0;
-		cur_gfn++;
-		/* Reached the end of the current memslot, take the next one. */
-		if (cur_gfn - ms->base_gfn >= ms->npages) {
-			ms = gfn_to_memslot(kvm, cur_gfn);
-			if (!ms)
-				return 0;
-		}
-	}
-	return 0;
-}
-
 /*
  * This function searches for the next page with dirty CMMA attributes, and
  * saves the attributes in the buffer up to either the end of the buffer or
@@ -2350,8 +2152,7 @@ static int kvm_s390_get_cmma(struct kvm *kvm, struct kvm_s390_cmma_log *args,
 static int kvm_s390_get_cmma_bits(struct kvm *kvm,
 				  struct kvm_s390_cmma_log *args)
 {
-	unsigned long bufsize;
-	int srcu_idx, peek, ret;
+	int peek, ret;
 	u8 *values;
 
 	if (!kvm->arch.use_cmma)
@@ -2364,8 +2165,8 @@ static int kvm_s390_get_cmma_bits(struct kvm *kvm,
 	if (!peek && !kvm->arch.migration_mode)
 		return -EINVAL;
 	/* CMMA is disabled or was not used, or the buffer has length zero */
-	bufsize = min(args->count, KVM_S390_CMMA_SIZE_MAX);
-	if (!bufsize || !kvm->mm->context.uses_cmm) {
+	args->count = min(args->count, KVM_S390_CMMA_SIZE_MAX);
+	if (!args->count || !kvm->arch.gmap->uses_cmm) {
 		memset(args, 0, sizeof(*args));
 		return 0;
 	}
@@ -2375,18 +2176,18 @@ static int kvm_s390_get_cmma_bits(struct kvm *kvm,
 		return 0;
 	}
 
-	values = vmalloc(bufsize);
+	values = vmalloc(args->count);
 	if (!values)
 		return -ENOMEM;
 
-	mmap_read_lock(kvm->mm);
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-	if (peek)
-		ret = kvm_s390_peek_cmma(kvm, args, values, bufsize);
-	else
-		ret = kvm_s390_get_cmma(kvm, args, values, bufsize);
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	mmap_read_unlock(kvm->mm);
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		if (peek)
+			ret = dat_peek_cmma(args->start_gfn, kvm->arch.gmap->asce, &args->count,
+					    values);
+		else
+			ret = dat_get_cmma(kvm->arch.gmap->asce, &args->start_gfn, &args->count,
+					   values, &kvm->arch.cmma_dirty_pages);
+	}
 
 	if (kvm->arch.migration_mode)
 		args->remaining = atomic64_read(&kvm->arch.cmma_dirty_pages);
@@ -2408,11 +2209,8 @@ static int kvm_s390_get_cmma_bits(struct kvm *kvm,
 static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 				  const struct kvm_s390_cmma_log *args)
 {
-	unsigned long hva, mask, pgstev, i;
 	uint8_t *bits;
-	int srcu_idx, r = 0;
-
-	mask = args->mask;
+	int r = 0;
 
 	if (!kvm->arch.use_cmma)
 		return -ENXIO;
@@ -2436,28 +2234,9 @@ static int kvm_s390_set_cmma_bits(struct kvm *kvm,
 		goto out;
 	}
 
-	mmap_read_lock(kvm->mm);
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-	for (i = 0; i < args->count; i++) {
-		hva = gfn_to_hva(kvm, args->start_gfn + i);
-		if (kvm_is_error_hva(hva)) {
-			r = -EFAULT;
-			break;
-		}
-
-		pgstev = bits[i];
-		pgstev = pgstev << 24;
-		mask &= _PGSTE_GPS_USAGE_MASK | _PGSTE_GPS_NODAT;
-		set_pgste_bits(kvm->mm, hva, mask, pgstev);
-	}
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-	mmap_read_unlock(kvm->mm);
+	dat_set_cmma_bits(kvm->arch.gmap->asce, args->start_gfn, args->count, args->mask, bits);
 
-	if (!kvm->mm->context.uses_cmm) {
-		mmap_write_lock(kvm->mm);
-		kvm->mm->context.uses_cmm = 1;
-		mmap_write_unlock(kvm->mm);
-	}
+	WRITE_ONCE(kvm->arch.gmap->uses_cmm, 1);
 out:
 	vfree(bits);
 	return r;
@@ -3348,11 +3127,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	if (type)
 		goto out_err;
 #endif
-
-	rc = s390_enable_sie();
-	if (rc)
-		goto out_err;
-
 	rc = -ENOMEM;
 
 	if (!sclp.has_64bscao)
@@ -3432,6 +3206,12 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	debug_register_view(kvm->arch.dbf, &debug_sprintf_view);
 	VM_EVENT(kvm, 3, "vm created with type %lu", type);
 
+	kvm->arch.mem_limit = type & KVM_VM_S390_UCONTROL ? KVM_S390_NO_MEM_LIMIT : sclp.hamax + 1;
+	kvm->arch.gmap = gmap_new(kvm, gpa_to_gfn(kvm->arch.mem_limit));
+	if (!kvm->arch.gmap)
+		goto out_err;
+	kvm->arch.gmap->pfault_enabled = 0;
+
 	if (type & KVM_VM_S390_UCONTROL) {
 		struct kvm_userspace_memory_region2 fake_memslot = {
 			.slot = KVM_S390_UCONTROL_MEMSLOT,
@@ -3441,23 +3221,15 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 			.flags = 0,
 		};
 
-		kvm->arch.gmap = NULL;
-		kvm->arch.mem_limit = KVM_S390_NO_MEM_LIMIT;
 		/* one flat fake memslot covering the whole address-space */
 		mutex_lock(&kvm->slots_lock);
 		KVM_BUG_ON(kvm_set_internal_memslot(kvm, &fake_memslot), kvm);
 		mutex_unlock(&kvm->slots_lock);
+		kvm->arch.gmap->is_ucontrol = 1;
 	} else {
-		if (sclp.hamax == U64_MAX)
-			kvm->arch.mem_limit = TASK_SIZE_MAX;
-		else
-			kvm->arch.mem_limit = min_t(unsigned long, TASK_SIZE_MAX,
-						    sclp.hamax + 1);
-		kvm->arch.gmap = gmap_create(current->mm, kvm->arch.mem_limit - 1);
-		if (!kvm->arch.gmap)
-			goto out_err;
-		kvm->arch.gmap->private = kvm;
-		kvm->arch.gmap->pfault_enabled = 0;
+		struct crst_table *table = dereference_asce(kvm->arch.gmap->asce);
+
+		crst_table_init((void *)table, _CRSTE_HOLE(table->crstes[0].h.tt).val);
 	}
 
 	kvm->arch.use_pfmfi = sclp.has_pfmfi;
@@ -3491,8 +3263,10 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 		sca_del_vcpu(vcpu);
 	kvm_s390_update_topology_change_report(vcpu->kvm, 1);
 
-	if (kvm_is_ucontrol(vcpu->kvm))
-		gmap_remove(vcpu->arch.gmap);
+	if (kvm_is_ucontrol(vcpu->kvm)) {
+		gmap_remove_child(vcpu->arch.gmap);
+		gmap_dispose(vcpu->arch.gmap);
+	}
 
 	if (vcpu->kvm->arch.use_cmma)
 		kvm_s390_vcpu_unsetup_cmma(vcpu);
@@ -3526,25 +3300,13 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 
 	debug_unregister(kvm->arch.dbf);
 	free_page((unsigned long)kvm->arch.sie_page2);
-	if (!kvm_is_ucontrol(kvm))
-		gmap_remove(kvm->arch.gmap);
 	kvm_s390_destroy_adapters(kvm);
 	kvm_s390_clear_float_irqs(kvm);
 	kvm_s390_vsie_destroy(kvm);
+	gmap_dispose(kvm->arch.gmap);
 	KVM_EVENT(3, "vm 0x%p destroyed", kvm);
 }
 
-/* Section: vcpu related */
-static int __kvm_ucontrol_vcpu_init(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.gmap = gmap_create(current->mm, -1UL);
-	if (!vcpu->arch.gmap)
-		return -ENOMEM;
-	vcpu->arch.gmap->private = vcpu->kvm;
-
-	return 0;
-}
-
 static void sca_del_vcpu(struct kvm_vcpu *vcpu)
 {
 	if (!kvm_s390_use_sca_entries())
@@ -4024,8 +3786,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 		vcpu->run->kvm_valid_regs |= KVM_SYNC_FPRS;
 
 	if (kvm_is_ucontrol(vcpu->kvm)) {
-		rc = __kvm_ucontrol_vcpu_init(vcpu);
-		if (rc)
+		rc = -ENOMEM;
+		vcpu->arch.gmap = gmap_new_child(vcpu->kvm->arch.gmap, -1UL);
+		if (!vcpu->arch.gmap)
 			goto out_free_sie_block;
 	}
 
@@ -4041,8 +3804,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	return 0;
 
 out_ucontrol_uninit:
-	if (kvm_is_ucontrol(vcpu->kvm))
-		gmap_remove(vcpu->arch.gmap);
+	if (kvm_is_ucontrol(vcpu->kvm)) {
+		gmap_remove_child(vcpu->arch.gmap);
+		gmap_dispose(vcpu->arch.gmap);
+	}
 out_free_sie_block:
 	free_page((unsigned long)(vcpu->arch.sie_block));
 	return rc;
@@ -4106,32 +3871,6 @@ void kvm_s390_sync_request(int req, struct kvm_vcpu *vcpu)
 	kvm_s390_vcpu_request(vcpu);
 }
 
-static void kvm_gmap_notifier(struct gmap *gmap, unsigned long start,
-			      unsigned long end)
-{
-	struct kvm *kvm = gmap->private;
-	struct kvm_vcpu *vcpu;
-	unsigned long prefix;
-	unsigned long i;
-
-	trace_kvm_s390_gmap_notifier(start, end, gmap_is_shadow(gmap));
-
-	if (gmap_is_shadow(gmap))
-		return;
-	if (start >= 1UL << 31)
-		/* We are only interested in prefix pages */
-		return;
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		/* match against both prefix pages */
-		prefix = kvm_s390_get_prefix(vcpu);
-		if (prefix <= end && start <= prefix + 2*PAGE_SIZE - 1) {
-			VCPU_EVENT(vcpu, 2, "gmap notifier for %lx-%lx",
-				   start, end);
-			kvm_s390_sync_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
-		}
-	}
-}
-
 bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 {
 	/* do not poll with more than halt_poll_max_steal percent of steal time */
@@ -4515,72 +4254,51 @@ static bool ibs_enabled(struct kvm_vcpu *vcpu)
 	return kvm_s390_test_cpuflags(vcpu, CPUSTAT_IBS);
 }
 
-static int __kvm_s390_fixup_fault_sync(struct gmap *gmap, gpa_t gaddr, unsigned int flags)
+static int vcpu_ucontrol_translate(struct kvm_vcpu *vcpu, gpa_t *gaddr)
 {
-	struct kvm *kvm = gmap->private;
-	gfn_t gfn = gpa_to_gfn(gaddr);
-	bool unlocked;
-	hva_t vmaddr;
-	gpa_t tmp;
+	union crste *crstep;
+	union pte *ptep;
 	int rc;
 
-	if (kvm_is_ucontrol(kvm)) {
-		tmp = __gmap_translate(gmap, gaddr);
-		gfn = gpa_to_gfn(tmp);
-	}
-
-	vmaddr = gfn_to_hva(kvm, gfn);
-	rc = fixup_user_fault(gmap->mm, vmaddr, FAULT_FLAG_WRITE, &unlocked);
-	if (!rc)
-		rc = __gmap_link(gmap, gaddr, vmaddr);
-	return rc;
-}
-
-/**
- * __kvm_s390_mprotect_many() - Apply specified protection to guest pages
- * @gmap: the gmap of the guest
- * @gpa: the starting guest address
- * @npages: how many pages to protect
- * @prot: indicates access rights: PROT_NONE, PROT_READ or PROT_WRITE
- * @bits: pgste notification bits to set
- *
- * Returns: 0 in case of success, < 0 in case of error - see gmap_protect_one()
- *
- * Context: kvm->srcu and gmap->mm need to be held in read mode
- */
-int __kvm_s390_mprotect_many(struct gmap *gmap, gpa_t gpa, u8 npages, unsigned int prot,
-			     unsigned long bits)
-{
-	unsigned int fault_flag = (prot & PROT_WRITE) ? FAULT_FLAG_WRITE : 0;
-	gpa_t end = gpa + npages * PAGE_SIZE;
-	int rc;
-
-	for (; gpa < end; gpa = ALIGN(gpa + 1, rc)) {
-		rc = gmap_protect_one(gmap, gpa, prot, bits);
-		if (rc == -EAGAIN) {
-			__kvm_s390_fixup_fault_sync(gmap, gpa, fault_flag);
-			rc = gmap_protect_one(gmap, gpa, prot, bits);
+	if (kvm_is_ucontrol(vcpu->kvm)) {
+		/*
+		 * This translates the per-vCPU guest address into a
+		 * fake guest address, which can then be used with the
+		 * fake memslots that are identity mapping userspace.
+		 * This allows ucontrol VMs to use the normal fault
+		 * resolution path, like normal VMs.
+		 */
+		rc = dat_entry_walk(gpa_to_gfn(*gaddr), vcpu->arch.gmap->asce,
+				    0, LEVEL_PTE, &crstep, &ptep);
+		if (rc) {
+			vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
+			vcpu->run->s390_ucontrol.trans_exc_code = *gaddr;
+			vcpu->run->s390_ucontrol.pgm_code = PGM_SEGMENT_TRANSLATION;
+			return -EREMOTE;
 		}
-		if (rc < 0)
-			return rc;
+		*gaddr &= ~_SEGMENT_MASK;
+		*gaddr |= dat_get_ptval(pte_table_start(ptep), PTVAL_VMADDR) << _SEGMENT_SHIFT;
 	}
-
 	return 0;
 }
 
-static int kvm_s390_mprotect_notify_prefix(struct kvm_vcpu *vcpu)
+static int kvm_s390_fixup_prefix(struct kvm_vcpu *vcpu)
 {
-	gpa_t gaddr = kvm_s390_get_prefix(vcpu);
-	int idx, rc;
-
-	idx = srcu_read_lock(&vcpu->kvm->srcu);
-	mmap_read_lock(vcpu->arch.gmap->mm);
-
-	rc = __kvm_s390_mprotect_many(vcpu->arch.gmap, gaddr, 2, PROT_WRITE, GMAP_NOTIFY_MPROT);
+	gpa_t gaddr;
+	int rc;
 
-	mmap_read_unlock(vcpu->arch.gmap->mm);
-	srcu_read_unlock(&vcpu->kvm->srcu, idx);
+	gaddr = kvm_s390_get_prefix(vcpu);
+	if (vcpu_ucontrol_translate(vcpu, &gaddr))
+		return -EREMOTE;
+	rc = kvm_s390_handle_dat_fault(vcpu, gaddr, FOLL_WRITE);
+	if (rc)
+		return rc;
+	rc = kvm_s390_handle_dat_fault(vcpu, gaddr + PAGE_SIZE, FOLL_WRITE);
+	if (rc)
+		return rc;
 
+	scoped_guard(write_lock, &vcpu->kvm->mmu_lock)
+		rc = dat_set_prefix_notif_bit(vcpu->kvm->arch.gmap->asce, gpa_to_gfn(gaddr));
 	return rc;
 }
 
@@ -4600,7 +4318,7 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 	if (kvm_check_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu)) {
 		int rc;
 
-		rc = kvm_s390_mprotect_notify_prefix(vcpu);
+		rc = kvm_s390_fixup_prefix(vcpu);
 		if (rc) {
 			kvm_make_request(KVM_REQ_REFRESH_GUEST_PREFIX, vcpu);
 			return rc;
@@ -4650,7 +4368,7 @@ static int kvm_s390_handle_requests(struct kvm_vcpu *vcpu)
 		 * CMM has been used.
 		 */
 		if ((vcpu->kvm->arch.use_cmma) &&
-		    (vcpu->kvm->mm->context.uses_cmm))
+		    (vcpu->arch.gmap->uses_cmm))
 			vcpu->arch.sie_block->ecb2 |= ECB2_CMMA;
 		goto retry;
 	}
@@ -4912,88 +4630,76 @@ int __kvm_s390_faultin_gfn(struct kvm *kvm, struct guest_fault *guest_fault, gfn
  * Return: 0 on success, < 0 in case of error.
  * Context: The mm lock must not be held before calling. May sleep.
  */
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int foll)
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int foll,
+				bool pfault)
 {
 	struct kvm_memory_slot *slot;
-	unsigned int fault_flags;
-	bool writable, unlocked;
-	unsigned long vmaddr;
+	unsigned long inv_seq;
+	bool writable, dirty;
 	struct page *page;
 	kvm_pfn_t pfn;
+	gfn_t gfn;
 	int rc;
 
-	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
-		return vcpu_post_run_addressing_exception(vcpu);
+	dirty = foll & FOLL_WRITE;
+	gfn = gpa_to_gfn(gaddr);
 
-	fault_flags = foll & FOLL_WRITE ? FAULT_FLAG_WRITE : 0;
-	if (vcpu->arch.gmap->pfault_enabled)
-		foll |= FOLL_NOWAIT;
-	vmaddr = __gfn_to_hva_memslot(slot, gfn);
+	if (gmap_try_fixup_minor(vcpu->kvm->arch.gmap, gfn, foll & FOLL_WRITE) == 0)
+		return 0;
+retry:
+	inv_seq = vcpu->kvm->mmu_invalidate_seq;
+	/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+	smp_rmb();
 
-try_again:
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
 	pfn = __kvm_faultin_pfn(slot, gfn, foll, &writable, &page);
 
-	/* Access outside memory, inject addressing exception */
-	if (is_noslot_pfn(pfn))
-		return vcpu_post_run_addressing_exception(vcpu);
-	/* Signal pending: try again */
-	if (pfn == KVM_PFN_ERR_SIGPENDING)
-		return -EAGAIN;
-
 	/* Needs I/O, try to setup async pfault (only possible with FOLL_NOWAIT) */
 	if (pfn == KVM_PFN_ERR_NEEDS_IO) {
+		if (!pfault)
+			return -EAGAIN;
 		trace_kvm_s390_major_guest_pfault(vcpu);
 		if (kvm_arch_setup_async_pf(vcpu))
 			return 0;
 		vcpu->stat.pfault_sync++;
 		/* Could not setup async pfault, try again synchronously */
 		foll &= ~FOLL_NOWAIT;
-		goto try_again;
+		pfn = __kvm_faultin_pfn(slot, gfn, foll, &writable, &page);
 	}
+
+	/* Access outside memory, inject addressing exception */
+	if (is_noslot_pfn(pfn))
+		return vcpu_post_run_addressing_exception(vcpu);
+	/* Signal pending: try again */
+	if (pfn == KVM_PFN_ERR_SIGPENDING)
+		return -EAGAIN;
 	/* Any other error */
 	if (is_error_pfn(pfn))
 		return -EFAULT;
+	if (mmu_invalidate_retry_gfn_unsafe(vcpu->kvm, inv_seq, gfn)) {
+		kvm_release_faultin_page(vcpu->kvm, page, true, false);
+		goto retry;
+	}
 
-	/* Success */
-	mmap_read_lock(vcpu->arch.gmap->mm);
-	/* Mark the userspace PTEs as young and/or dirty, to avoid page fault loops */
-	rc = fixup_user_fault(vcpu->arch.gmap->mm, vmaddr, fault_flags, &unlocked);
-	if (!rc)
-		rc = __gmap_link(vcpu->arch.gmap, gaddr, vmaddr);
 	scoped_guard(read_lock, &vcpu->kvm->mmu_lock) {
-		kvm_release_faultin_page(vcpu->kvm, page, false, writable);
+		if (!mmu_invalidate_retry_gfn(vcpu->kvm, inv_seq, gfn)) {
+			rc = gmap_link(vcpu->kvm->arch.gmap, pfn, page, gfn, writable, dirty);
+			kvm_release_faultin_page(vcpu->kvm, page, !!rc, dirty);
+			return rc;
+		}
 	}
-	mmap_read_unlock(vcpu->arch.gmap->mm);
-	return rc;
+
+	kvm_release_faultin_page(vcpu->kvm, page, true, false);
+	goto retry;
 }
 
-static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, unsigned long gaddr, unsigned int foll)
+static int vcpu_dat_fault_handler(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int foll)
 {
-	unsigned long gaddr_tmp;
-	gfn_t gfn;
-
-	gfn = gpa_to_gfn(gaddr);
-	if (kvm_is_ucontrol(vcpu->kvm)) {
-		/*
-		 * This translates the per-vCPU guest address into a
-		 * fake guest address, which can then be used with the
-		 * fake memslots that are identity mapping userspace.
-		 * This allows ucontrol VMs to use the normal fault
-		 * resolution path, like normal VMs.
-		 */
-		mmap_read_lock(vcpu->arch.gmap->mm);
-		gaddr_tmp = __gmap_translate(vcpu->arch.gmap, gaddr);
-		mmap_read_unlock(vcpu->arch.gmap->mm);
-		if (gaddr_tmp == -EFAULT) {
-			vcpu->run->exit_reason = KVM_EXIT_S390_UCONTROL;
-			vcpu->run->s390_ucontrol.trans_exc_code = gaddr;
-			vcpu->run->s390_ucontrol.pgm_code = PGM_SEGMENT_TRANSLATION;
-			return -EREMOTE;
-		}
-		gfn = gpa_to_gfn(gaddr_tmp);
-	}
-	return __kvm_s390_handle_dat_fault(vcpu, gfn, gaddr, foll);
+	if (vcpu_ucontrol_translate(vcpu, &gaddr))
+		return -EREMOTE;
+	if (vcpu->arch.gmap->pfault_enabled)
+		foll |= FOLL_NOWAIT;
+	return __kvm_s390_handle_dat_fault(vcpu, gaddr, foll, true);
 }
 
 static int vcpu_post_run_handle_fault(struct kvm_vcpu *vcpu)
@@ -5139,7 +4845,7 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
 		}
 		exit_reason = sie64a(vcpu->arch.sie_block,
 				     vcpu->run->s.regs.gprs,
-				     vcpu->arch.gmap->asce);
+				     vcpu->arch.gmap->asce.val);
 		if (kvm_s390_pv_cpu_is_protected(vcpu)) {
 			memcpy(vcpu->run->s.regs.gprs,
 			       sie_page->pv_grregs,
@@ -5907,37 +5613,39 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	}
 #ifdef CONFIG_KVM_S390_UCONTROL
 	case KVM_S390_UCAS_MAP: {
-		struct kvm_s390_ucas_mapping ucasmap;
+		struct kvm_s390_ucas_mapping ucas;
 
-		if (copy_from_user(&ucasmap, argp, sizeof(ucasmap))) {
-			r = -EFAULT;
+		r = -EFAULT;
+		if (copy_from_user(&ucas, argp, sizeof(ucas)))
 			break;
-		}
 
-		if (!kvm_is_ucontrol(vcpu->kvm)) {
-			r = -EINVAL;
+		r = -EINVAL;
+		if (!kvm_is_ucontrol(vcpu->kvm))
+			break;
+		if (!IS_ALIGNED(ucas.user_addr | ucas.vcpu_addr | ucas.length, _SEGMENT_SIZE))
 			break;
-		}
 
-		r = gmap_map_segment(vcpu->arch.gmap, ucasmap.user_addr,
-				     ucasmap.vcpu_addr, ucasmap.length);
+		r = gmap_ucas_map(vcpu->arch.gmap, gpa_to_gfn(ucas.user_addr),
+				  gpa_to_gfn(ucas.vcpu_addr),
+				  ucas.length >> _SEGMENT_SHIFT);
 		break;
 	}
 	case KVM_S390_UCAS_UNMAP: {
-		struct kvm_s390_ucas_mapping ucasmap;
+		struct kvm_s390_ucas_mapping ucas;
 
-		if (copy_from_user(&ucasmap, argp, sizeof(ucasmap))) {
-			r = -EFAULT;
+		r = -EFAULT;
+		if (copy_from_user(&ucas, argp, sizeof(ucas)))
 			break;
-		}
 
-		if (!kvm_is_ucontrol(vcpu->kvm)) {
-			r = -EINVAL;
+		r = -EINVAL;
+		if (!kvm_is_ucontrol(vcpu->kvm))
+			break;
+		if (!IS_ALIGNED(ucas.vcpu_addr | ucas.length, _SEGMENT_SIZE))
 			break;
-		}
 
-		r = gmap_unmap_segment(vcpu->arch.gmap, ucasmap.vcpu_addr,
-			ucasmap.length);
+		gmap_ucas_unmap(vcpu->arch.gmap, gpa_to_gfn(ucas.vcpu_addr),
+				ucas.length >> _SEGMENT_SHIFT);
+		r = 0;
 		break;
 	}
 #endif
@@ -6112,24 +5820,17 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
 {
 	int rc = 0;
 
-	if (kvm_is_ucontrol(kvm))
-		return;
-
 	switch (change) {
 	case KVM_MR_DELETE:
-		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
-					old->npages * PAGE_SIZE);
+		rc = dat_delete_slot(kvm->arch.gmap->asce, old->base_gfn, old->npages);
 		break;
 	case KVM_MR_MOVE:
-		rc = gmap_unmap_segment(kvm->arch.gmap, old->base_gfn * PAGE_SIZE,
-					old->npages * PAGE_SIZE);
+		rc = dat_delete_slot(kvm->arch.gmap->asce, old->base_gfn, old->npages);
 		if (rc)
 			break;
 		fallthrough;
 	case KVM_MR_CREATE:
-		rc = gmap_map_segment(kvm->arch.gmap, new->userspace_addr,
-				      new->base_gfn * PAGE_SIZE,
-				      new->npages * PAGE_SIZE);
+		rc = dat_create_slot(kvm->arch.gmap->asce, new->base_gfn, new->npages);
 		break;
 	case KVM_MR_FLAGS_ONLY:
 		break;
@@ -6151,7 +5852,8 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
  */
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return false;
+	scoped_guard(read_lock, &kvm->mmu_lock)
+		return dat_test_age_gfn(kvm->arch.gmap->asce, range->start, range->end);
 }
 
 /**
@@ -6164,7 +5866,8 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
  */
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return false;
+	scoped_guard(read_lock, &kvm->mmu_lock)
+		return gmap_age_gfn(kvm->arch.gmap, range->start, range->end);
 }
 
 /**
@@ -6181,7 +5884,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
  */
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return false;
+	return gmap_unmap_gfn_range(kvm->arch.gmap, range->slot, range->start, range->end);
 }
 
 static inline unsigned long nonhyp_mask(int i)
diff --git a/arch/s390/kvm/kvm-s390.h b/arch/s390/kvm/kvm-s390.h
index dabcf65f58ff..21d93eb9dee4 100644
--- a/arch/s390/kvm/kvm-s390.h
+++ b/arch/s390/kvm/kvm-s390.h
@@ -19,6 +19,8 @@
 #include <asm/facility.h>
 #include <asm/processor.h>
 #include <asm/sclp.h>
+#include "dat.h"
+#include "gmap.h"
 
 #define KVM_S390_UCONTROL_MEMSLOT (KVM_USER_MEM_SLOTS + 0)
 
@@ -115,9 +117,7 @@ static inline int is_vcpu_idle(struct kvm_vcpu *vcpu)
 static inline int kvm_is_ucontrol(struct kvm *kvm)
 {
 #ifdef CONFIG_KVM_S390_UCONTROL
-	if (kvm->arch.gmap)
-		return 0;
-	return 1;
+	return kvm->arch.gmap->is_ucontrol;
 #else
 	return 0;
 #endif
@@ -441,14 +441,10 @@ int kvm_s390_skey_check_enable(struct kvm_vcpu *vcpu);
 /* implemented in vsie.c */
 int kvm_s390_handle_vsie(struct kvm_vcpu *vcpu);
 void kvm_s390_vsie_kick(struct kvm_vcpu *vcpu);
-void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
-				 unsigned long end);
+void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, gpa_t start, gpa_t end);
 void kvm_s390_vsie_init(struct kvm *kvm);
 void kvm_s390_vsie_destroy(struct kvm *kvm);
-int gmap_shadow_valid(struct gmap *sg, unsigned long asce, int edat_level);
-
-/* implemented in gmap-vsie.c */
-struct gmap *gmap_shadow(struct gmap *parent, unsigned long asce, int edat_level);
+int gmap_shadow_valid(struct gmap *sg, union asce asce, int edat_level);
 
 /* implemented in sigp.c */
 int kvm_s390_handle_sigp(struct kvm_vcpu *vcpu);
@@ -470,14 +466,15 @@ void kvm_s390_vcpu_unsetup_cmma(struct kvm_vcpu *vcpu);
 void kvm_s390_set_cpu_timer(struct kvm_vcpu *vcpu, __u64 cputm);
 __u64 kvm_s390_get_cpu_timer(struct kvm_vcpu *vcpu);
 int kvm_s390_cpus_from_pv(struct kvm *kvm, u16 *rc, u16 *rrc);
-int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gfn_t gfn, gpa_t gaddr, unsigned int flags);
+int __kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr,
+				unsigned int flags, bool pfault);
 int __kvm_s390_mprotect_many(struct gmap *gmap, gpa_t gpa, u8 npages, unsigned int prot,
 			     unsigned long bits);
 int __kvm_s390_faultin_gfn(struct kvm *kvm, struct guest_fault *f, gfn_t gfn, bool wr);
 
 static inline int kvm_s390_handle_dat_fault(struct kvm_vcpu *vcpu, gpa_t gaddr, unsigned int flags)
 {
-	return __kvm_s390_handle_dat_fault(vcpu, gpa_to_gfn(gaddr), gaddr, flags);
+	return __kvm_s390_handle_dat_fault(vcpu, gaddr, flags, false);
 }
 
 static inline void release_faultin_multiple(struct kvm *kvm, struct guest_fault *guest_faults,
diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
index 9253c70897a8..b6539c4d69f0 100644
--- a/arch/s390/kvm/priv.c
+++ b/arch/s390/kvm/priv.c
@@ -21,13 +21,14 @@
 #include <asm/ebcdic.h>
 #include <asm/sysinfo.h>
 #include <asm/page-states.h>
-#include <asm/gmap.h>
 #include <asm/ptrace.h>
 #include <asm/sclp.h>
 #include <asm/ap.h>
+#include <asm/gmap_helpers.h>
 #include "gaccess.h"
 #include "kvm-s390.h"
 #include "trace.h"
+#include "gmap.h"
 
 static int handle_ri(struct kvm_vcpu *vcpu)
 {
@@ -222,7 +223,7 @@ int kvm_s390_skey_check_enable(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.skey_enabled)
 		return 0;
 
-	rc = s390_enable_skey();
+	rc = gmap_enable_skeys(vcpu->arch.gmap);
 	VCPU_EVENT(vcpu, 3, "enabling storage keys for guest: %d", rc);
 	if (rc)
 		return rc;
@@ -255,10 +256,9 @@ static int try_handle_skey(struct kvm_vcpu *vcpu)
 
 static int handle_iske(struct kvm_vcpu *vcpu)
 {
-	unsigned long gaddr, vmaddr;
-	unsigned char key;
+	unsigned long gaddr;
 	int reg1, reg2;
-	bool unlocked;
+	union skey key;
 	int rc;
 
 	vcpu->stat.instruction_iske++;
@@ -275,37 +275,21 @@ static int handle_iske(struct kvm_vcpu *vcpu)
 	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
 	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
 	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
-	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
-	if (kvm_is_error_hva(vmaddr))
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-retry:
-	unlocked = false;
-	mmap_read_lock(current->mm);
-	rc = get_guest_storage_key(current->mm, vmaddr, &key);
-
-	if (rc) {
-		rc = fixup_user_fault(current->mm, vmaddr,
-				      FAULT_FLAG_WRITE, &unlocked);
-		if (!rc) {
-			mmap_read_unlock(current->mm);
-			goto retry;
-		}
-	}
-	mmap_read_unlock(current->mm);
-	if (rc == -EFAULT)
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+		rc = dat_get_storage_key(vcpu->arch.gmap->asce, gpa_to_gfn(gaddr), &key);
+	if (rc > 0)
+		return kvm_s390_inject_program_int(vcpu, rc);
 	if (rc < 0)
 		return rc;
 	vcpu->run->s.regs.gprs[reg1] &= ~0xff;
-	vcpu->run->s.regs.gprs[reg1] |= key;
+	vcpu->run->s.regs.gprs[reg1] |= key.skey;
 	return 0;
 }
 
 static int handle_rrbe(struct kvm_vcpu *vcpu)
 {
-	unsigned long vmaddr, gaddr;
+	unsigned long gaddr;
 	int reg1, reg2;
-	bool unlocked;
 	int rc;
 
 	vcpu->stat.instruction_rrbe++;
@@ -322,24 +306,10 @@ static int handle_rrbe(struct kvm_vcpu *vcpu)
 	gaddr = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
 	gaddr = kvm_s390_logical_to_effective(vcpu, gaddr);
 	gaddr = kvm_s390_real_to_abs(vcpu, gaddr);
-	vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(gaddr));
-	if (kvm_is_error_hva(vmaddr))
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-retry:
-	unlocked = false;
-	mmap_read_lock(current->mm);
-	rc = reset_guest_reference_bit(current->mm, vmaddr);
-	if (rc < 0) {
-		rc = fixup_user_fault(current->mm, vmaddr,
-				      FAULT_FLAG_WRITE, &unlocked);
-		if (!rc) {
-			mmap_read_unlock(current->mm);
-			goto retry;
-		}
-	}
-	mmap_read_unlock(current->mm);
-	if (rc == -EFAULT)
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+		rc = dat_reset_reference_bit(vcpu->arch.gmap->asce, gpa_to_gfn(gaddr));
+	if (rc > 0)
+		return kvm_s390_inject_program_int(vcpu, rc);
 	if (rc < 0)
 		return rc;
 	kvm_s390_set_psw_cc(vcpu, rc);
@@ -354,9 +324,8 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 {
 	unsigned char m3 = vcpu->arch.sie_block->ipb >> 28;
 	unsigned long start, end;
-	unsigned char key, oldkey;
+	union skey key, oldkey;
 	int reg1, reg2;
-	bool unlocked;
 	int rc;
 
 	vcpu->stat.instruction_sske++;
@@ -377,7 +346,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 
 	kvm_s390_get_regs_rre(vcpu, &reg1, &reg2);
 
-	key = vcpu->run->s.regs.gprs[reg1] & 0xfe;
+	key.skey = vcpu->run->s.regs.gprs[reg1] & 0xfe;
 	start = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
 	start = kvm_s390_logical_to_effective(vcpu, start);
 	if (m3 & SSKE_MB) {
@@ -389,27 +358,11 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 	}
 
 	while (start != end) {
-		unsigned long vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(start));
-		unlocked = false;
-
-		if (kvm_is_error_hva(vmaddr))
-			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-
-		mmap_read_lock(current->mm);
-		rc = cond_set_guest_storage_key(current->mm, vmaddr, key, &oldkey,
-						m3 & SSKE_NQ, m3 & SSKE_MR,
-						m3 & SSKE_MC);
-
-		if (rc < 0) {
-			rc = fixup_user_fault(current->mm, vmaddr,
-					      FAULT_FLAG_WRITE, &unlocked);
-			rc = !rc ? -EAGAIN : rc;
-		}
-		mmap_read_unlock(current->mm);
-		if (rc == -EFAULT)
+		rc = dat_cond_set_storage_key(vcpu->arch.gmap->asce, gpa_to_gfn(start),
+					      key, &oldkey, m3 & SSKE_NQ,
+					      m3 & SSKE_MR, m3 & SSKE_MC);
+		if (rc > 1)
 			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-		if (rc == -EAGAIN)
-			continue;
 		if (rc < 0)
 			return rc;
 		start += PAGE_SIZE;
@@ -422,7 +375,7 @@ static int handle_sske(struct kvm_vcpu *vcpu)
 		} else {
 			kvm_s390_set_psw_cc(vcpu, rc);
 			vcpu->run->s.regs.gprs[reg1] &= ~0xff00UL;
-			vcpu->run->s.regs.gprs[reg1] |= (u64) oldkey << 8;
+			vcpu->run->s.regs.gprs[reg1] |= (u64)oldkey.skey << 8;
 		}
 	}
 	if (m3 & SSKE_MB) {
@@ -1074,7 +1027,7 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	bool mr = false, mc = false, nq;
 	int reg1, reg2;
 	unsigned long start, end;
-	unsigned char key;
+	union skey key;
 
 	vcpu->stat.instruction_pfmf++;
 
@@ -1102,7 +1055,7 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	}
 
 	nq = vcpu->run->s.regs.gprs[reg1] & PFMF_NQ;
-	key = vcpu->run->s.regs.gprs[reg1] & PFMF_KEY;
+	key.skey = vcpu->run->s.regs.gprs[reg1] & PFMF_KEY;
 	start = vcpu->run->s.regs.gprs[reg2] & PAGE_MASK;
 	start = kvm_s390_logical_to_effective(vcpu, start);
 
@@ -1133,14 +1086,6 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 	}
 
 	while (start != end) {
-		unsigned long vmaddr;
-		bool unlocked = false;
-
-		/* Translate guest address to host address */
-		vmaddr = gfn_to_hva(vcpu->kvm, gpa_to_gfn(start));
-		if (kvm_is_error_hva(vmaddr))
-			return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-
 		if (vcpu->run->s.regs.gprs[reg1] & PFMF_CF) {
 			if (kvm_clear_guest(vcpu->kvm, start, PAGE_SIZE))
 				return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
@@ -1151,19 +1096,10 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 
 			if (rc)
 				return rc;
-			mmap_read_lock(current->mm);
-			rc = cond_set_guest_storage_key(current->mm, vmaddr,
-							key, NULL, nq, mr, mc);
-			if (rc < 0) {
-				rc = fixup_user_fault(current->mm, vmaddr,
-						      FAULT_FLAG_WRITE, &unlocked);
-				rc = !rc ? -EAGAIN : rc;
-			}
-			mmap_read_unlock(current->mm);
-			if (rc == -EFAULT)
-				return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-			if (rc == -EAGAIN)
-				continue;
+			rc = dat_cond_set_storage_key(vcpu->arch.gmap->asce, gpa_to_gfn(start), key,
+						      NULL, nq, mr, mc);
+			if (rc > 1)
+				return kvm_s390_inject_program_int(vcpu, rc);
 			if (rc < 0)
 				return rc;
 		}
@@ -1187,8 +1123,10 @@ static int handle_pfmf(struct kvm_vcpu *vcpu)
 static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 {
 	int r1, r2, nappended, entries;
-	unsigned long gfn, hva, res, pgstev, ptev;
+	union essa_state state;
 	unsigned long *cbrlo;
+	unsigned long gfn;
+	bool dirtied;
 
 	/*
 	 * We don't need to set SD.FPF.SK to 1 here, because if we have a
@@ -1197,33 +1135,12 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 
 	kvm_s390_get_regs_rre(vcpu, &r1, &r2);
 	gfn = vcpu->run->s.regs.gprs[r2] >> PAGE_SHIFT;
-	hva = gfn_to_hva(vcpu->kvm, gfn);
 	entries = (vcpu->arch.sie_block->cbrlo & ~PAGE_MASK) >> 3;
 
-	if (kvm_is_error_hva(hva))
-		return kvm_s390_inject_program_int(vcpu, PGM_ADDRESSING);
-
-	nappended = pgste_perform_essa(vcpu->kvm->mm, hva, orc, &ptev, &pgstev);
-	if (nappended < 0) {
-		res = orc ? 0x10 : 0;
-		vcpu->run->s.regs.gprs[r1] = res; /* Exception Indication */
+	nappended = dat_perform_essa(vcpu->arch.gmap->asce, gfn, orc, &state, &dirtied);
+	vcpu->run->s.regs.gprs[r1] = state.val;
+	if (nappended < 0)
 		return 0;
-	}
-	res = (pgstev & _PGSTE_GPS_USAGE_MASK) >> 22;
-	/*
-	 * Set the block-content state part of the result. 0 means resident, so
-	 * nothing to do if the page is valid. 2 is for preserved pages
-	 * (non-present and non-zero), and 3 for zero pages (non-present and
-	 * zero).
-	 */
-	if (ptev & _PAGE_INVALID) {
-		res |= 2;
-		if (pgstev & _PGSTE_GPS_ZERO)
-			res |= 1;
-	}
-	if (pgstev & _PGSTE_GPS_NODAT)
-		res |= 0x20;
-	vcpu->run->s.regs.gprs[r1] = res;
 	/*
 	 * It is possible that all the normal 511 slots were full, in which case
 	 * we will now write in the 512th slot, which is reserved for host use.
@@ -1235,17 +1152,34 @@ static inline int __do_essa(struct kvm_vcpu *vcpu, const int orc)
 		cbrlo[entries] = gfn << PAGE_SHIFT;
 	}
 
-	if (orc) {
-		struct kvm_memory_slot *ms = gfn_to_memslot(vcpu->kvm, gfn);
-
-		/* Increment only if we are really flipping the bit */
-		if (ms && !test_and_set_bit(gfn - ms->base_gfn, kvm_second_dirty_bitmap(ms)))
-			atomic64_inc(&vcpu->kvm->arch.cmma_dirty_pages);
-	}
+	if (dirtied)
+		atomic64_inc(&vcpu->kvm->arch.cmma_dirty_pages);
 
 	return nappended;
 }
 
+static void _essa_clear_cbrl(struct kvm_vcpu *vcpu, unsigned long *cbrl, int len)
+{
+	union crste *crstep;
+	union pgste pgste;
+	union pte *ptep;
+	int i;
+
+	lockdep_assert_held(&vcpu->kvm->mmu_lock);
+
+	for (i = 0; i < len; i++) {
+		if (dat_entry_walk(gpa_to_gfn(cbrl[i]), vcpu->arch.gmap->asce,
+				   0, LEVEL_PTE, &crstep, &ptep))
+			continue;
+		if (!ptep || ptep->s.pr)
+			continue;
+		pgste = pgste_get_lock(ptep);
+		if (pgste.usage == PGSTE_GPS_USAGE_UNUSED || pgste.zero)
+			gmap_helper_zap_one_page(vcpu->kvm->mm, cbrl[i]);
+		pgste_set_unlock(ptep, pgste);
+	}
+}
+
 static int handle_essa(struct kvm_vcpu *vcpu)
 {
 	lockdep_assert_held(&vcpu->kvm->srcu);
@@ -1281,11 +1215,7 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 		 * value really needs to be written to; if the value is
 		 * already correct, we do nothing and avoid the lock.
 		 */
-		if (vcpu->kvm->mm->context.uses_cmm == 0) {
-			mmap_write_lock(vcpu->kvm->mm);
-			vcpu->kvm->mm->context.uses_cmm = 1;
-			mmap_write_unlock(vcpu->kvm->mm);
-		}
+		WRITE_ONCE(vcpu->arch.gmap->uses_cmm, 1);
 		/*
 		 * If we are here, we are supposed to have CMMA enabled in
 		 * the SIE block. Enabling CMMA works on a per-CPU basis,
@@ -1299,20 +1229,22 @@ static int handle_essa(struct kvm_vcpu *vcpu)
 		/* Retry the ESSA instruction */
 		kvm_s390_retry_instr(vcpu);
 	} else {
-		mmap_read_lock(vcpu->kvm->mm);
-		i = __do_essa(vcpu, orc);
-		mmap_read_unlock(vcpu->kvm->mm);
+		scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+			i = __do_essa(vcpu, orc);
 		if (i < 0)
 			return i;
 		/* Account for the possible extra cbrl entry */
 		entries += i;
 	}
-	vcpu->arch.sie_block->cbrlo &= PAGE_MASK;	/* reset nceo */
+	/* reset nceo */
+	vcpu->arch.sie_block->cbrlo &= PAGE_MASK;
 	cbrlo = phys_to_virt(vcpu->arch.sie_block->cbrlo);
-	mmap_read_lock(gmap->mm);
-	for (i = 0; i < entries; ++i)
-		__gmap_zap(gmap, cbrlo[i]);
-	mmap_read_unlock(gmap->mm);
+
+	mmap_read_lock(vcpu->kvm->mm);
+	scoped_guard(read_lock, &vcpu->kvm->mmu_lock)
+		_essa_clear_cbrl(vcpu, cbrlo, entries);
+	mmap_read_unlock(vcpu->kvm->mm);
+
 	return 0;
 }
 
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index ede790798fa3..7da8aa17458a 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -10,13 +10,15 @@
 #include <linux/minmax.h>
 #include <linux/pagemap.h>
 #include <linux/sched/signal.h>
-#include <asm/gmap.h>
 #include <asm/uv.h>
 #include <asm/mman.h>
 #include <linux/pagewalk.h>
 #include <linux/sched/mm.h>
 #include <linux/mmu_notifier.h>
 #include "kvm-s390.h"
+#include "dat.h"
+#include "gaccess.h"
+#include "gmap.h"
 
 bool kvm_s390_pv_is_protected(struct kvm *kvm)
 {
@@ -297,35 +299,6 @@ static int kvm_s390_pv_dispose_one_leftover(struct kvm *kvm,
 	return 0;
 }
 
-/**
- * kvm_s390_destroy_lower_2g - Destroy the first 2GB of protected guest memory.
- * @kvm: the VM whose memory is to be cleared.
- *
- * Destroy the first 2GB of guest memory, to avoid prefix issues after reboot.
- * The CPUs of the protected VM need to be destroyed beforehand.
- */
-static void kvm_s390_destroy_lower_2g(struct kvm *kvm)
-{
-	const unsigned long pages_2g = SZ_2G / PAGE_SIZE;
-	struct kvm_memory_slot *slot;
-	unsigned long len;
-	int srcu_idx;
-
-	srcu_idx = srcu_read_lock(&kvm->srcu);
-
-	/* Take the memslot containing guest absolute address 0 */
-	slot = gfn_to_memslot(kvm, 0);
-	/* Clear all slots or parts thereof that are below 2GB */
-	while (slot && slot->base_gfn < pages_2g) {
-		len = min_t(u64, slot->npages, pages_2g - slot->base_gfn) * PAGE_SIZE;
-		s390_uv_destroy_range(kvm->mm, slot->userspace_addr, slot->userspace_addr + len);
-		/* Take the next memslot */
-		slot = gfn_to_memslot(kvm, slot->base_gfn + slot->npages);
-	}
-
-	srcu_read_unlock(&kvm->srcu, srcu_idx);
-}
-
 static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
 {
 	struct uv_cb_destroy_fast uvcb = {
@@ -340,7 +313,6 @@ static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
 		*rc = uvcb.header.rc;
 	if (rrc)
 		*rrc = uvcb.header.rrc;
-	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DESTROY VM FAST: rc %x rrc %x",
 		     uvcb.header.rc, uvcb.header.rrc);
 	WARN_ONCE(cc && uvcb.header.rc != 0x104,
@@ -389,7 +361,7 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EINVAL;
 
 	/* Guest with segment type ASCE, refuse to destroy asynchronously */
-	if ((kvm->arch.gmap->asce & _ASCE_TYPE_MASK) == _ASCE_TYPE_SEGMENT)
+	if (kvm->arch.gmap->asce.dt == TABLE_TYPE_SEGMENT)
 		return -EINVAL;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -402,8 +374,7 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 		priv->stor_var = kvm->arch.pv.stor_var;
 		priv->stor_base = kvm->arch.pv.stor_base;
 		priv->handle = kvm_s390_pv_get_handle(kvm);
-		priv->old_gmap_table = (unsigned long)kvm->arch.gmap->table;
-		WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
+		priv->old_gmap_table = (unsigned long)dereference_asce(kvm->arch.gmap->asce);
 		if (s390_replace_asce(kvm->arch.gmap))
 			res = -ENOMEM;
 	}
@@ -413,7 +384,7 @@ int kvm_s390_pv_set_aside(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return res;
 	}
 
-	kvm_s390_destroy_lower_2g(kvm);
+	gmap_pv_destroy_range(kvm->arch.gmap, 0, gpa_to_gfn(SZ_2G), false);
 	kvm_s390_clear_pv_state(kvm);
 	kvm->arch.pv.set_aside = priv;
 
@@ -447,7 +418,6 @@ int kvm_s390_pv_deinit_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 
 	cc = uv_cmd_nodata(kvm_s390_pv_get_handle(kvm),
 			   UVC_CMD_DESTROY_SEC_CONF, rc, rrc);
-	WRITE_ONCE(kvm->arch.gmap->guest_handle, 0);
 	if (!cc) {
 		atomic_dec(&kvm->mm->context.protected_count);
 		kvm_s390_pv_dealloc_vm(kvm);
@@ -530,7 +500,7 @@ int kvm_s390_pv_deinit_cleanup_all(struct kvm *kvm, u16 *rc, u16 *rrc)
 	 * cleanup has been performed.
 	 */
 	if (need_zap && mmget_not_zero(kvm->mm)) {
-		s390_uv_destroy_range(kvm->mm, 0, TASK_SIZE);
+		gmap_pv_destroy_range(kvm->arch.gmap, 0, asce_end(kvm->arch.gmap->asce), false);
 		mmput(kvm->mm);
 	}
 
@@ -568,7 +538,7 @@ int kvm_s390_pv_deinit_aside_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		return -EINVAL;
 
 	/* When a fatal signal is received, stop immediately */
-	if (s390_uv_destroy_range_interruptible(kvm->mm, 0, TASK_SIZE_MAX))
+	if (gmap_pv_destroy_range(kvm->arch.gmap, 0, asce_end(kvm->arch.gmap->asce), true))
 		goto done;
 	if (kvm_s390_pv_dispose_one_leftover(kvm, p, rc, rrc))
 		ret = -EIO;
@@ -640,7 +610,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	/* Inputs */
 	uvcb.guest_stor_origin = 0; /* MSO is 0 for KVM */
 	uvcb.guest_stor_len = kvm->arch.pv.guest_len;
-	uvcb.guest_asce = kvm->arch.gmap->asce;
+	uvcb.guest_asce = kvm->arch.gmap->asce.val;
 	uvcb.guest_sca = virt_to_phys(kvm->arch.sca);
 	uvcb.conf_base_stor_origin =
 		virt_to_phys((void *)kvm->arch.pv.stor_base);
@@ -667,7 +637,6 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 		}
 		return -EIO;
 	}
-	kvm->arch.gmap->guest_handle = uvcb.guest_handle;
 	return 0;
 }
 
@@ -702,26 +671,33 @@ static int unpack_one(struct kvm *kvm, unsigned long addr, u64 tweak,
 		.tweak[1] = offset,
 	};
 	int ret = kvm_s390_pv_make_secure(kvm, addr, &uvcb);
-	unsigned long vmaddr;
-	bool unlocked;
+	gfn_t gfn;
 
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
+	gfn = gpa_to_gfn(addr);
 
 	if (ret == -ENXIO) {
-		mmap_read_lock(kvm->mm);
-		vmaddr = gfn_to_hva(kvm, gpa_to_gfn(addr));
-		if (kvm_is_error_hva(vmaddr)) {
-			ret = -EFAULT;
-		} else {
-			ret = fixup_user_fault(kvm->mm, vmaddr, FAULT_FLAG_WRITE, &unlocked);
-			if (!ret)
-				ret = __gmap_link(kvm->arch.gmap, addr, vmaddr);
+		unsigned long inv_seq;
+		struct guest_fault f;
+
+		inv_seq = kvm->mmu_invalidate_seq;
+		/* Pairs with the smp_wmb() in kvm_mmu_invalidate_end(). */
+		smp_rmb();
+
+		ret = __kvm_s390_faultin_gfn(kvm, &f, gfn, true);
+		if (ret > 0)
+			return -EFAULT;
+		if (ret)
+			return ret;
+
+		scoped_guard(read_lock, &kvm->mmu_lock) {
+			ret = -EAGAIN;
+			if (!mmu_invalidate_retry_gfn(kvm, inv_seq, gfn))
+				ret = gmap_link(kvm->arch.gmap, f.pfn, f.page, gfn, true, true);
+			kvm_release_faultin_page(kvm, f.page, !ret, true);
 		}
-		mmap_read_unlock(kvm->mm);
-		if (!ret)
-			return -EAGAIN;
-		return ret;
+		return ret ? ret : -EAGAIN;
 	}
 
 	if (ret && ret != -EAGAIN)
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index 13a9661d2b28..c08aa252de14 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -15,7 +15,6 @@
 #include <linux/io.h>
 #include <linux/mman.h>
 
-#include <asm/gmap.h>
 #include <asm/mmu_context.h>
 #include <asm/sclp.h>
 #include <asm/nmi.h>
@@ -23,6 +22,7 @@
 #include <asm/facility.h>
 #include "kvm-s390.h"
 #include "gaccess.h"
+#include "gmap.h"
 
 enum vsie_page_flags {
 	VSIE_PAGE_IN_USE = 0,
@@ -62,11 +62,15 @@ struct vsie_page {
 	 * looked up by other CPUs.
 	 */
 	unsigned long flags;			/* 0x0260 */
-	__u8 reserved[0x0700 - 0x0268];		/* 0x0268 */
+	/* Per-gmap list of vsie_pages that use that gmap */
+	struct list_head list;			/* 0x0268 */
+	__u8 reserved[0x0700 - 0x0278];		/* 0x0278 */
 	struct kvm_s390_crypto_cb crycb;	/* 0x0700 */
 	__u8 fac[S390_ARCH_FAC_LIST_SIZE_BYTE];	/* 0x0800 */
 };
 
+static_assert(sizeof(struct vsie_page) == PAGE_SIZE);
+
 /**
  * gmap_shadow_valid() - check if a shadow guest address space matches the
  *                       given properties and is still valid
@@ -78,11 +82,11 @@ struct vsie_page {
  * properties, the caller can continue using it. Returns 0 otherwise; the
  * caller has to request a new shadow gmap in this case.
  */
-int gmap_shadow_valid(struct gmap *sg, unsigned long asce, int edat_level)
+int gmap_shadow_valid(struct gmap *sg, union asce asce, int edat_level)
 {
 	if (sg->removed)
 		return 0;
-	return sg->orig_asce == asce && sg->edat_level == edat_level;
+	return sg->guest_asce.val == asce.val && sg->edat_level == edat_level;
 }
 
 /* trigger a validity icpt for the given scb */
@@ -612,31 +616,29 @@ static int shadow_scb(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	return rc;
 }
 
-void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, unsigned long start,
-				 unsigned long end)
+void kvm_s390_vsie_gmap_notifier(struct gmap *gmap, gpa_t start, gpa_t end)
 {
-	struct kvm *kvm = gmap->private;
-	struct vsie_page *cur;
+	struct vsie_page *cur, *next;
 	unsigned long prefix;
-	int i;
 
-	if (!gmap_is_shadow(gmap))
-		return;
+	KVM_BUG_ON(!gmap->is_shadow, gmap->kvm);
+	KVM_BUG_ON(!gmap->parent, gmap->kvm);
+	lockdep_assert_held(&gmap->parent->children_lock);
 	/*
 	 * Only new shadow blocks are added to the list during runtime,
 	 * therefore we can safely reference them all the time.
 	 */
-	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
-		cur = READ_ONCE(kvm->arch.vsie.pages[i]);
-		if (!cur)
-			continue;
-		if (READ_ONCE(cur->gmap) != gmap)
-			continue;
+	list_for_each_entry_safe(cur, next, &gmap->scb_users, list) {
 		prefix = cur->scb_s.prefix << GUEST_PREFIX_SHIFT;
 		/* with mso/msl, the prefix lies at an offset */
 		prefix += cur->scb_s.mso;
-		if (prefix <= end && start <= prefix + 2 * PAGE_SIZE - 1)
+		if (prefix <= end && start <= prefix + 2 * PAGE_SIZE - 1) {
 			prefix_unmapped_sync(cur);
+			if (gmap->removed) {
+				list_del(&cur->list);
+				cur->gmap = NULL;
+			}
+		}
 	}
 }
 
@@ -667,10 +669,10 @@ static int map_prefix(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	/* with mso/msl, the prefix lies at offset *mso* */
 	prefix += scb_s->mso;
 
-	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, prefix, NULL);
+	rc = gaccess_shadow_fault(vcpu, vsie_page->gmap, prefix, NULL, true);
 	if (!rc && (scb_s->ecb & ECB_TE))
-		rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-					   prefix + PAGE_SIZE, NULL);
+		rc = gaccess_shadow_fault(vcpu, vsie_page->gmap,
+					  prefix + PAGE_SIZE, NULL, true);
 	/*
 	 * We don't have to mprotect, we will be called for all unshadows.
 	 * SIE will detect if protection applies and trigger a validity.
@@ -953,6 +955,7 @@ static int inject_fault(struct kvm_vcpu *vcpu, __u16 code, __u64 vaddr,
  */
 static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
+	bool wr = kvm_s390_cur_gmap_fault_is_write();
 	int rc;
 
 	if ((current->thread.gmap_int_code & PGM_INT_CODE_MASK) == PGM_PROTECTION)
@@ -960,12 +963,11 @@ static int handle_fault(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		return inject_fault(vcpu, PGM_PROTECTION,
 				    current->thread.gmap_teid.addr * PAGE_SIZE, 1);
 
-	rc = kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				   current->thread.gmap_teid.addr * PAGE_SIZE, NULL);
+	rc = gaccess_shadow_fault(vcpu, vsie_page->gmap,
+				  current->thread.gmap_teid.addr * PAGE_SIZE, NULL, wr);
 	if (rc > 0) {
 		rc = inject_fault(vcpu, rc,
-				  current->thread.gmap_teid.addr * PAGE_SIZE,
-				  kvm_s390_cur_gmap_fault_is_write());
+				  current->thread.gmap_teid.addr * PAGE_SIZE, wr);
 		if (rc >= 0)
 			vsie_page->fault_addr = current->thread.gmap_teid.addr * PAGE_SIZE;
 	}
@@ -982,8 +984,8 @@ static void handle_last_fault(struct kvm_vcpu *vcpu,
 			      struct vsie_page *vsie_page)
 {
 	if (vsie_page->fault_addr)
-		kvm_s390_shadow_fault(vcpu, vsie_page->gmap,
-				      vsie_page->fault_addr, NULL);
+		gaccess_shadow_fault(vcpu, vsie_page->gmap,
+				     vsie_page->fault_addr, NULL, true);
 	vsie_page->fault_addr = 0;
 }
 
@@ -1068,8 +1070,9 @@ static u64 vsie_get_register(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page,
 static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 {
 	struct kvm_s390_sie_block *scb_s = &vsie_page->scb_s;
-	unsigned long pei_dest, pei_src, src, dest, mask, prefix;
+	unsigned long src, dest, mask, prefix;
 	u64 *pei_block = &vsie_page->scb_o->mcic;
+	union mvpg_pei pei_dest, pei_src;
 	int edat, rc_dest, rc_src;
 	union ctlreg0 cr0;
 
@@ -1083,8 +1086,8 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	src = vsie_get_register(vcpu, vsie_page, scb_s->ipb >> 16) & mask;
 	src = _kvm_s390_real_to_abs(prefix, src) + scb_s->mso;
 
-	rc_dest = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest);
-	rc_src = kvm_s390_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src);
+	rc_dest = gaccess_shadow_fault(vcpu, vsie_page->gmap, dest, &pei_dest, true);
+	rc_src = gaccess_shadow_fault(vcpu, vsie_page->gmap, src, &pei_src, false);
 	/*
 	 * Either everything went well, or something non-critical went wrong
 	 * e.g. because of a race. In either case, simply retry.
@@ -1119,8 +1122,8 @@ static int vsie_handle_mvpg(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		rc_src = rc_src != PGM_PAGE_TRANSLATION ? rc_src : 0;
 	}
 	if (!rc_dest && !rc_src) {
-		pei_block[0] = pei_dest;
-		pei_block[1] = pei_src;
+		pei_block[0] = pei_dest.val;
+		pei_block[1] = pei_src.val;
 		return 1;
 	}
 
@@ -1184,7 +1187,7 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 	current->thread.gmap_int_code = 0;
 	barrier();
 	if (!kvm_s390_vcpu_sie_inhibited(vcpu))
-		rc = sie64a(scb_s, vcpu->run->s.regs.gprs, vsie_page->gmap->asce);
+		rc = sie64a(scb_s, vcpu->run->s.regs.gprs, vsie_page->gmap->asce.val);
 	barrier();
 	vcpu->arch.sie_block->prog0c &= ~PROG_IN_SIE;
 
@@ -1233,21 +1236,30 @@ static int do_vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 
 static void release_gmap_shadow(struct vsie_page *vsie_page)
 {
-	if (vsie_page->gmap)
-		gmap_put(vsie_page->gmap);
-	WRITE_ONCE(vsie_page->gmap, NULL);
+	struct gmap *gmap = vsie_page->gmap;
+
+	KVM_BUG_ON(!gmap->parent, gmap->kvm);
+	lockdep_assert_held(&gmap->parent->children_lock);
+
+	vsie_page->gmap = NULL;
+	list_del(&vsie_page->list);
+
+	if (list_empty(&gmap->scb_users)) {
+		gmap_remove_child(gmap);
+		gmap_dispose(gmap);
+	}
 	prefix_unmapped(vsie_page);
 }
 
 static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
 			       struct vsie_page *vsie_page)
 {
-	unsigned long asce;
 	union ctlreg0 cr0;
 	struct gmap *gmap;
+	union asce asce;
 	int edat;
 
-	asce = vcpu->arch.sie_block->gcr[1];
+	asce.val = vcpu->arch.sie_block->gcr[1];
 	cr0.val = vcpu->arch.sie_block->gcr[0];
 	edat = cr0.edat && test_kvm_facility(vcpu->kvm, 8);
 	edat += edat && test_kvm_facility(vcpu->kvm, 78);
@@ -1263,12 +1275,19 @@ static int acquire_gmap_shadow(struct kvm_vcpu *vcpu,
 	}
 
 	/* release the old shadow - if any, and mark the prefix as unmapped */
-	release_gmap_shadow(vsie_page);
-	gmap = gmap_shadow(vcpu->arch.gmap, asce, edat);
+	scoped_guard(spinlock, &vcpu->kvm->arch.gmap->children_lock) {
+		if (vsie_page->gmap)
+			release_gmap_shadow(vsie_page);
+	}
+	gmap = gmap_create_shadow(vcpu->kvm->arch.gmap, asce, edat);
 	if (IS_ERR(gmap))
 		return PTR_ERR(gmap);
-	vcpu->kvm->stat.gmap_shadow_create++;
-	WRITE_ONCE(vsie_page->gmap, gmap);
+	scoped_guard(spinlock, &vcpu->kvm->arch.gmap->children_lock) {
+		vcpu->kvm->stat.gmap_shadow_create++;
+		list_add(&vsie_page->list, &gmap->scb_users);
+		vsie_page->gmap = gmap;
+		prefix_unmapped(vsie_page);
+	}
 	return 0;
 }
 
@@ -1451,8 +1470,7 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	vsie_page->scb_gpa = ULONG_MAX;
 
 	/* Double use of the same address or allocation failure. */
-	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9,
-			      vsie_page)) {
+	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9, vsie_page)) {
 		put_vsie_page(vsie_page);
 		mutex_unlock(&kvm->arch.vsie.mutex);
 		return NULL;
@@ -1461,7 +1479,11 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
 	mutex_unlock(&kvm->arch.vsie.mutex);
 
 	memset(&vsie_page->scb_s, 0, sizeof(struct kvm_s390_sie_block));
-	release_gmap_shadow(vsie_page);
+	if (vsie_page->gmap) {
+		scoped_guard(spinlock, &vsie_page->gmap->parent->children_lock)
+			release_gmap_shadow(vsie_page);
+	}
+	prefix_unmapped(vsie_page);
 	vsie_page->fault_addr = 0;
 	vsie_page->scb_s.ihcpu = 0xffffU;
 	return vsie_page;
@@ -1538,8 +1560,10 @@ void kvm_s390_vsie_destroy(struct kvm *kvm)
 	mutex_lock(&kvm->arch.vsie.mutex);
 	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
 		vsie_page = kvm->arch.vsie.pages[i];
+		scoped_guard(spinlock, &kvm->arch.gmap->children_lock)
+			if (vsie_page->gmap)
+				release_gmap_shadow(vsie_page);
 		kvm->arch.vsie.pages[i] = NULL;
-		release_gmap_shadow(vsie_page);
 		/* free the radix tree entry */
 		if (vsie_page->scb_gpa != ULONG_MAX)
 			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
-- 
2.51.0


