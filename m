Return-Path: <kvm+bounces-47868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2A65AC6662
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:56:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B2D2C7B266D
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 09:55:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 396DC278E44;
	Wed, 28 May 2025 09:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="gidguwpK"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FEF27584C;
	Wed, 28 May 2025 09:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748426123; cv=none; b=buDRQjqxwOoURIZ7CcD3TI2+SEZxh8maTDGLXZ/Qcct056J96hV4u4c0M258Vqr7fwaHmv2CSPZTzpK7PLjWgF8rny8pB1ADLLoNTuraztLDdT3sjcqRU/UwxtVI516ZlWtK0UyPL2VWFNCodEd2eWn9934zHlgD/EYdfUwMDpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748426123; c=relaxed/simple;
	bh=5jTVyJKUeMhKpLfBcdAHCzZbxYU/ffeCdR3EUFUlSfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPM+MsIKFtoCvG31p2WSa01eENLvmrkiNeyLxyxlnR+NwEq/qwv2m8bVgR17cycwznT8d8aj1tsw7uZ5b/oFfflcL/wM7uzlAfoaK14ErpLPOb4oQQYBQgVsZqRXeQUJWWibxq4EbapSh9abmGA3ZN6KPfrdj5NdzGEZqmXvGjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=gidguwpK; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S8eZde003181;
	Wed, 28 May 2025 09:55:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=jGkJDTZ35H2AciaeK
	F+HnHfWMKA8/LQUQjAqoiPQDq8=; b=gidguwpK9zI73aZzcLfnobDqnwxzZEKyy
	mtUbhJxTV7BoNCwTEEl6I/N7jaLwlwfKHwPd+dzqZgVcVev3uz7PTe4/CpiFkOMD
	BgopawiIe0o5YjlIrnyNmrukeA45hLWSgKzGa2MVbJc5/hfPomqGCpzSZnqkhyFk
	8NlRPbiJbyzIYUkCqwPcMVREIzekrZuv+Vj/1vxk+BXzSgA8sppqoVfphVYBu+K/
	BwUcsQutyshP/eYvHmG1qeSZvKlW5bxOWVg2KFZYNW49/gCq9P+7/TWNxh/CE3HF
	FxwiFchVA1niqd1xyqEIz9kkuMXrP3OqUmdenhVklolZvNv94hcrA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wy690atp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:55:15 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54S6c0m2015850;
	Wed, 28 May 2025 09:55:15 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46uu536m72-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 09:55:14 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54S9tBoQ58327366
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 09:55:11 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49F2D2004B;
	Wed, 28 May 2025 09:55:11 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7ED1D20043;
	Wed, 28 May 2025 09:55:10 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.111.56.81])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 09:55:10 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v5 3/4] KVM: s390: Refactor and split some gmap helpers
Date: Wed, 28 May 2025 11:55:01 +0200
Message-ID: <20250528095502.226213-4-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250528095502.226213-1-imbrenda@linux.ibm.com>
References: <20250528095502.226213-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UP3dHDfy c=1 sm=1 tr=0 ts=6836dd83 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=d4WBFxBnqJN_BTi7uaAA:9
X-Proofpoint-GUID: E_ebmvVhktNi8gd2p3Nwy6-C0H_fAde3
X-Proofpoint-ORIG-GUID: E_ebmvVhktNi8gd2p3Nwy6-C0H_fAde3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA4MiBTYWx0ZWRfX22yXva0QRIIq FO+JjXOD4oPUE8dHm/k2MlXHU6gewDhaGAwYwl5VAQwEbfnw9gLd8iQ5J8Rv0vZzdJN3puW782m kiAzqsDWX0ymNb86eOuW7SHQVumS0lnyqbSPMHl2n545C/+EllpNwVu2agqhSPNaW3WMRdPSF1o
 /u0yp8onv00zjy5AMs7O+BUX3ZUT7HBuIVAVU8RiCf0WdhsGsV5JGWI3rOXRl0bi0+0teYziEiM 3zLfROVMiVji5xdoTI6nakjQeOcas5cU6tR/ypGy4N1OSGHOsRoIjMCuWf77iaFM1hltCaFDfxb ArYrsOgJRE5NAfXUUs/pld//DFWZVe4mliS5XcBVaMO8JHgTAHGGa9GKyC3rVrzN/wQGRzKr93k
 MmHAd71xTsWRDCoc8MMhleTkfmfN1Am55dwCu07lwpGtiPVL0rPJVV+sYebRsYCBEfoUAEYh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_05,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280082

Refactor some gmap functions; move the implementation into a separate
file with only helper functions. The new helper functions work on vm
addresses, leaving all gmap logic in the gmap functions, which mostly
become just wrappers.

The whole gmap handling is going to be moved inside KVM soon, but the
helper functions need to touch core mm functions, and thus need to
stay in the core of kernel.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
---
 MAINTAINERS                          |   2 +
 arch/s390/include/asm/gmap.h         |   2 -
 arch/s390/include/asm/gmap_helpers.h |  15 ++
 arch/s390/kvm/diag.c                 |  30 +++-
 arch/s390/kvm/kvm-s390.c             |   5 +-
 arch/s390/mm/Makefile                |   2 +
 arch/s390/mm/gmap.c                  | 184 +---------------------
 arch/s390/mm/gmap_helpers.c          | 221 +++++++++++++++++++++++++++
 8 files changed, 274 insertions(+), 187 deletions(-)
 create mode 100644 arch/s390/include/asm/gmap_helpers.h
 create mode 100644 arch/s390/mm/gmap_helpers.c

diff --git a/MAINTAINERS b/MAINTAINERS
index f21f1dabb5fe..b0a8fb5a254c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13093,12 +13093,14 @@ S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git
 F:	Documentation/virt/kvm/s390*
 F:	arch/s390/include/asm/gmap.h
+F:	arch/s390/include/asm/gmap_helpers.h
 F:	arch/s390/include/asm/kvm*
 F:	arch/s390/include/uapi/asm/kvm*
 F:	arch/s390/include/uapi/asm/uvdevice.h
 F:	arch/s390/kernel/uv.c
 F:	arch/s390/kvm/
 F:	arch/s390/mm/gmap.c
+F:	arch/s390/mm/gmap_helpers.c
 F:	drivers/s390/char/uvdevice.c
 F:	tools/testing/selftests/drivers/s390x/uvdevice/
 F:	tools/testing/selftests/kvm/*/s390/
diff --git a/arch/s390/include/asm/gmap.h b/arch/s390/include/asm/gmap.h
index 9f2814d0e1e9..66c5808fd011 100644
--- a/arch/s390/include/asm/gmap.h
+++ b/arch/s390/include/asm/gmap.h
@@ -110,7 +110,6 @@ int gmap_map_segment(struct gmap *gmap, unsigned long from,
 int gmap_unmap_segment(struct gmap *gmap, unsigned long to, unsigned long len);
 unsigned long __gmap_translate(struct gmap *, unsigned long gaddr);
 int __gmap_link(struct gmap *gmap, unsigned long gaddr, unsigned long vmaddr);
-void gmap_discard(struct gmap *, unsigned long from, unsigned long to);
 void __gmap_zap(struct gmap *, unsigned long gaddr);
 void gmap_unlink(struct mm_struct *, unsigned long *table, unsigned long vmaddr);
 
@@ -134,7 +133,6 @@ int gmap_protect_one(struct gmap *gmap, unsigned long gaddr, int prot, unsigned
 
 void gmap_sync_dirty_log_pmd(struct gmap *gmap, unsigned long dirty_bitmap[4],
 			     unsigned long gaddr, unsigned long vmaddr);
-int s390_disable_cow_sharing(void);
 int s390_replace_asce(struct gmap *gmap);
 void s390_uv_destroy_pfns(unsigned long count, unsigned long *pfns);
 int __s390_uv_destroy_range(struct mm_struct *mm, unsigned long start,
diff --git a/arch/s390/include/asm/gmap_helpers.h b/arch/s390/include/asm/gmap_helpers.h
new file mode 100644
index 000000000000..5356446a61c4
--- /dev/null
+++ b/arch/s390/include/asm/gmap_helpers.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Helper functions for KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2025
+ */
+
+#ifndef _ASM_S390_GMAP_HELPERS_H
+#define _ASM_S390_GMAP_HELPERS_H
+
+void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr);
+void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end);
+int gmap_helper_disable_cow_sharing(void);
+
+#endif /* _ASM_S390_GMAP_HELPERS_H */
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 74f73141f9b9..53233dec8cad 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -11,12 +11,30 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <asm/gmap.h>
+#include <asm/gmap_helpers.h>
 #include <asm/virtio-ccw.h>
 #include "kvm-s390.h"
 #include "trace.h"
 #include "trace-s390.h"
 #include "gaccess.h"
 
+static void do_discard_gfn_range(struct kvm_vcpu *vcpu, gfn_t gfn_start, gfn_t gfn_end)
+{
+	struct kvm_memslot_iter iter;
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	unsigned long start, end;
+
+	slots = kvm_vcpu_memslots(vcpu);
+
+	kvm_for_each_memslot_in_gfn_range(&iter, slots, gfn_start, gfn_end) {
+		slot = iter.slot;
+		start = __gfn_to_hva_memslot(slot, max(gfn_start, slot->base_gfn));
+		end = __gfn_to_hva_memslot(slot, min(gfn_end, slot->base_gfn + slot->npages));
+		gmap_helper_discard(vcpu->kvm->mm, start, end);
+	}
+}
+
 static int diag_release_pages(struct kvm_vcpu *vcpu)
 {
 	unsigned long start, end;
@@ -32,12 +50,13 @@ static int diag_release_pages(struct kvm_vcpu *vcpu)
 
 	VCPU_EVENT(vcpu, 5, "diag release pages %lX %lX", start, end);
 
+	mmap_read_lock(vcpu->kvm->mm);
 	/*
 	 * We checked for start >= end above, so lets check for the
 	 * fast path (no prefix swap page involved)
 	 */
 	if (end <= prefix || start >= prefix + 2 * PAGE_SIZE) {
-		gmap_discard(vcpu->arch.gmap, start, end);
+		do_discard_gfn_range(vcpu, gpa_to_gfn(start), gpa_to_gfn(end));
 	} else {
 		/*
 		 * This is slow path.  gmap_discard will check for start
@@ -45,13 +64,14 @@ static int diag_release_pages(struct kvm_vcpu *vcpu)
 		 * prefix and let gmap_discard make some of these calls
 		 * NOPs.
 		 */
-		gmap_discard(vcpu->arch.gmap, start, prefix);
+		do_discard_gfn_range(vcpu, gpa_to_gfn(start), gpa_to_gfn(prefix));
 		if (start <= prefix)
-			gmap_discard(vcpu->arch.gmap, 0, PAGE_SIZE);
+			do_discard_gfn_range(vcpu, 0, 1);
 		if (end > prefix + PAGE_SIZE)
-			gmap_discard(vcpu->arch.gmap, PAGE_SIZE, 2 * PAGE_SIZE);
-		gmap_discard(vcpu->arch.gmap, prefix + 2 * PAGE_SIZE, end);
+			do_discard_gfn_range(vcpu, 1, 2);
+		do_discard_gfn_range(vcpu, gpa_to_gfn(prefix) + 2, gpa_to_gfn(end));
 	}
+	mmap_read_unlock(vcpu->kvm->mm);
 	return 0;
 }
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 3f3175193fd7..10cfc047525d 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -40,6 +40,7 @@
 #include <asm/machine.h>
 #include <asm/stp.h>
 #include <asm/gmap.h>
+#include <asm/gmap_helpers.h>
 #include <asm/nmi.h>
 #include <asm/isc.h>
 #include <asm/sclp.h>
@@ -2674,7 +2675,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
 		if (r)
 			break;
 
-		r = s390_disable_cow_sharing();
+		mmap_write_lock(kvm->mm);
+		r = gmap_helper_disable_cow_sharing();
+		mmap_write_unlock(kvm->mm);
 		if (r)
 			break;
 
diff --git a/arch/s390/mm/Makefile b/arch/s390/mm/Makefile
index 9726b91fe7e4..bd0401cc7ca5 100644
--- a/arch/s390/mm/Makefile
+++ b/arch/s390/mm/Makefile
@@ -12,3 +12,5 @@ obj-$(CONFIG_HUGETLB_PAGE)	+= hugetlbpage.o
 obj-$(CONFIG_PTDUMP)		+= dump_pagetables.o
 obj-$(CONFIG_PGSTE)		+= gmap.o
 obj-$(CONFIG_PFAULT)		+= pfault.o
+
+obj-$(subst m,y,$(CONFIG_KVM))	+= gmap_helpers.o
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 4869555ff403..012a4366a2ad 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -22,6 +22,7 @@
 #include <asm/page-states.h>
 #include <asm/pgalloc.h>
 #include <asm/machine.h>
+#include <asm/gmap_helpers.h>
 #include <asm/gmap.h>
 #include <asm/page.h>
 
@@ -619,63 +620,20 @@ EXPORT_SYMBOL(__gmap_link);
  */
 void __gmap_zap(struct gmap *gmap, unsigned long gaddr)
 {
-	struct vm_area_struct *vma;
 	unsigned long vmaddr;
-	spinlock_t *ptl;
-	pte_t *ptep;
+
+	mmap_assert_locked(gmap->mm);
 
 	/* Find the vm address for the guest address */
 	vmaddr = (unsigned long) radix_tree_lookup(&gmap->guest_to_host,
 						   gaddr >> PMD_SHIFT);
 	if (vmaddr) {
 		vmaddr |= gaddr & ~PMD_MASK;
-
-		vma = vma_lookup(gmap->mm, vmaddr);
-		if (!vma || is_vm_hugetlb_page(vma))
-			return;
-
-		/* Get pointer to the page table entry */
-		ptep = get_locked_pte(gmap->mm, vmaddr, &ptl);
-		if (likely(ptep)) {
-			ptep_zap_unused(gmap->mm, vmaddr, ptep, 0);
-			pte_unmap_unlock(ptep, ptl);
-		}
+		gmap_helper_zap_one_page(gmap->mm, vmaddr);
 	}
 }
 EXPORT_SYMBOL_GPL(__gmap_zap);
 
-void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long to)
-{
-	unsigned long gaddr, vmaddr, size;
-	struct vm_area_struct *vma;
-
-	mmap_read_lock(gmap->mm);
-	for (gaddr = from; gaddr < to;
-	     gaddr = (gaddr + PMD_SIZE) & PMD_MASK) {
-		/* Find the vm address for the guest address */
-		vmaddr = (unsigned long)
-			radix_tree_lookup(&gmap->guest_to_host,
-					  gaddr >> PMD_SHIFT);
-		if (!vmaddr)
-			continue;
-		vmaddr |= gaddr & ~PMD_MASK;
-		/* Find vma in the parent mm */
-		vma = find_vma(gmap->mm, vmaddr);
-		if (!vma)
-			continue;
-		/*
-		 * We do not discard pages that are backed by
-		 * hugetlbfs, so we don't have to refault them.
-		 */
-		if (is_vm_hugetlb_page(vma))
-			continue;
-		size = min(to - gaddr, PMD_SIZE - (gaddr & ~PMD_MASK));
-		zap_page_range_single(vma, vmaddr, size, NULL);
-	}
-	mmap_read_unlock(gmap->mm);
-}
-EXPORT_SYMBOL_GPL(gmap_discard);
-
 static LIST_HEAD(gmap_notifier_list);
 static DEFINE_SPINLOCK(gmap_notifier_lock);
 
@@ -2268,138 +2226,6 @@ int s390_enable_sie(void)
 }
 EXPORT_SYMBOL_GPL(s390_enable_sie);
 
-static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
-				   unsigned long end, struct mm_walk *walk)
-{
-	unsigned long *found_addr = walk->private;
-
-	/* Return 1 of the page is a zeropage. */
-	if (is_zero_pfn(pte_pfn(*pte))) {
-		/*
-		 * Shared zeropage in e.g., a FS DAX mapping? We cannot do the
-		 * right thing and likely don't care: FAULT_FLAG_UNSHARE
-		 * currently only works in COW mappings, which is also where
-		 * mm_forbids_zeropage() is checked.
-		 */
-		if (!is_cow_mapping(walk->vma->vm_flags))
-			return -EFAULT;
-
-		*found_addr = addr;
-		return 1;
-	}
-	return 0;
-}
-
-static const struct mm_walk_ops find_zeropage_ops = {
-	.pte_entry	= find_zeropage_pte_entry,
-	.walk_lock	= PGWALK_WRLOCK,
-};
-
-/*
- * Unshare all shared zeropages, replacing them by anonymous pages. Note that
- * we cannot simply zap all shared zeropages, because this could later
- * trigger unexpected userfaultfd missing events.
- *
- * This must be called after mm->context.allow_cow_sharing was
- * set to 0, to avoid future mappings of shared zeropages.
- *
- * mm contracts with s390, that even if mm were to remove a page table,
- * and racing with walk_page_range_vma() calling pte_offset_map_lock()
- * would fail, it will never insert a page table containing empty zero
- * pages once mm_forbids_zeropage(mm) i.e.
- * mm->context.allow_cow_sharing is set to 0.
- */
-static int __s390_unshare_zeropages(struct mm_struct *mm)
-{
-	struct vm_area_struct *vma;
-	VMA_ITERATOR(vmi, mm, 0);
-	unsigned long addr;
-	vm_fault_t fault;
-	int rc;
-
-	for_each_vma(vmi, vma) {
-		/*
-		 * We could only look at COW mappings, but it's more future
-		 * proof to catch unexpected zeropages in other mappings and
-		 * fail.
-		 */
-		if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma))
-			continue;
-		addr = vma->vm_start;
-
-retry:
-		rc = walk_page_range_vma(vma, addr, vma->vm_end,
-					 &find_zeropage_ops, &addr);
-		if (rc < 0)
-			return rc;
-		else if (!rc)
-			continue;
-
-		/* addr was updated by find_zeropage_pte_entry() */
-		fault = handle_mm_fault(vma, addr,
-					FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
-					NULL);
-		if (fault & VM_FAULT_OOM)
-			return -ENOMEM;
-		/*
-		 * See break_ksm(): even after handle_mm_fault() returned 0, we
-		 * must start the lookup from the current address, because
-		 * handle_mm_fault() may back out if there's any difficulty.
-		 *
-		 * VM_FAULT_SIGBUS and VM_FAULT_SIGSEGV are unexpected but
-		 * maybe they could trigger in the future on concurrent
-		 * truncation. In that case, the shared zeropage would be gone
-		 * and we can simply retry and make progress.
-		 */
-		cond_resched();
-		goto retry;
-	}
-
-	return 0;
-}
-
-static int __s390_disable_cow_sharing(struct mm_struct *mm)
-{
-	int rc;
-
-	if (!mm->context.allow_cow_sharing)
-		return 0;
-
-	mm->context.allow_cow_sharing = 0;
-
-	/* Replace all shared zeropages by anonymous pages. */
-	rc = __s390_unshare_zeropages(mm);
-	/*
-	 * Make sure to disable KSM (if enabled for the whole process or
-	 * individual VMAs). Note that nothing currently hinders user space
-	 * from re-enabling it.
-	 */
-	if (!rc)
-		rc = ksm_disable(mm);
-	if (rc)
-		mm->context.allow_cow_sharing = 1;
-	return rc;
-}
-
-/*
- * Disable most COW-sharing of memory pages for the whole process:
- * (1) Disable KSM and unmerge/unshare any KSM pages.
- * (2) Disallow shared zeropages and unshare any zerpages that are mapped.
- *
- * Not that we currently don't bother with COW-shared pages that are shared
- * with parent/child processes due to fork().
- */
-int s390_disable_cow_sharing(void)
-{
-	int rc;
-
-	mmap_write_lock(current->mm);
-	rc = __s390_disable_cow_sharing(current->mm);
-	mmap_write_unlock(current->mm);
-	return rc;
-}
-EXPORT_SYMBOL_GPL(s390_disable_cow_sharing);
-
 /*
  * Enable storage key handling from now on and initialize the storage
  * keys with the default key.
@@ -2467,7 +2293,7 @@ int s390_enable_skey(void)
 		goto out_up;
 
 	mm->context.uses_skeys = 1;
-	rc = __s390_disable_cow_sharing(mm);
+	rc = gmap_helper_disable_cow_sharing();
 	if (rc) {
 		mm->context.uses_skeys = 0;
 		goto out_up;
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
new file mode 100644
index 000000000000..a45d417ad951
--- /dev/null
+++ b/arch/s390/mm/gmap_helpers.c
@@ -0,0 +1,221 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  Helper functions for KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2025
+ */
+#include <linux/mm_types.h>
+#include <linux/mmap_lock.h>
+#include <linux/mm.h>
+#include <linux/hugetlb.h>
+#include <linux/swap.h>
+#include <linux/swapops.h>
+#include <linux/pagewalk.h>
+#include <linux/ksm.h>
+#include <asm/gmap_helpers.h>
+
+/**
+ * ptep_zap_swap_entry() - discard a swap entry.
+ * @mm: the mm
+ * @entry: the swap entry that needs to be zapped
+ *
+ * Discards the given swap entry. If the swap entry was an actual swap
+ * entry (and not a migration entry, for example), the actual swapped
+ * page is also discarded from swap.
+ */
+static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
+{
+	if (!non_swap_entry(entry))
+		dec_mm_counter(mm, MM_SWAPENTS);
+	else if (is_migration_entry(entry))
+		dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
+	free_swap_and_cache(entry);
+}
+
+/**
+ * gmap_helper_zap_one_page() - discard a page if it was swapped.
+ * @mm: the mm
+ * @vmaddr: the userspace virtual address that needs to be discarded
+ *
+ * If the given address maps to a swap entry, discard it.
+ *
+ * Context: needs to be called while holding the mmap lock.
+ */
+void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr)
+{
+	struct vm_area_struct *vma;
+	spinlock_t *ptl;
+	pte_t *ptep;
+
+	mmap_assert_locked(mm);
+
+	/* Find the vm address for the guest address */
+	vma = vma_lookup(mm, vmaddr);
+	if (!vma || is_vm_hugetlb_page(vma))
+		return;
+
+	/* Get pointer to the page table entry */
+	ptep = get_locked_pte(mm, vmaddr, &ptl);
+	if (unlikely(!ptep))
+		return;
+	if (pte_swap(*ptep))
+		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
+	pte_unmap_unlock(ptep, ptl);
+}
+EXPORT_SYMBOL_GPL(gmap_helper_zap_one_page);
+
+/**
+ * gmap_helper_discard() - discard user pages in the given range
+ * @mm: the mm
+ * @vmaddr: starting userspace address
+ * @end: end address (first address outside the range)
+ *
+ * All userpace pages in the range [@vamddr, @end) are discarded and unmapped.
+ *
+ * Context: needs to be called while holding the mmap lock.
+ */
+void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end)
+{
+	struct vm_area_struct *vma;
+
+	mmap_assert_locked(mm);
+
+	while (vmaddr < end) {
+		vma = find_vma_intersection(mm, vmaddr, end);
+		if (!vma)
+			return;
+		if (!is_vm_hugetlb_page(vma))
+			zap_page_range_single(vma, vmaddr, min(end, vma->vm_end) - vmaddr, NULL);
+		vmaddr = vma->vm_end;
+	}
+}
+EXPORT_SYMBOL_GPL(gmap_helper_discard);
+
+static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
+				   unsigned long end, struct mm_walk *walk)
+{
+	unsigned long *found_addr = walk->private;
+
+	/* Return 1 of the page is a zeropage. */
+	if (is_zero_pfn(pte_pfn(*pte))) {
+		/*
+		 * Shared zeropage in e.g., a FS DAX mapping? We cannot do the
+		 * right thing and likely don't care: FAULT_FLAG_UNSHARE
+		 * currently only works in COW mappings, which is also where
+		 * mm_forbids_zeropage() is checked.
+		 */
+		if (!is_cow_mapping(walk->vma->vm_flags))
+			return -EFAULT;
+
+		*found_addr = addr;
+		return 1;
+	}
+	return 0;
+}
+
+static const struct mm_walk_ops find_zeropage_ops = {
+	.pte_entry      = find_zeropage_pte_entry,
+	.walk_lock      = PGWALK_WRLOCK,
+};
+
+/** __gmap_helper_unshare_zeropages() - unshare all shared zeropages
+ * @mm: the mm whose zero pages are to be unshared
+ *
+ * Unshare all shared zeropages, replacing them by anonymous pages. Note that
+ * we cannot simply zap all shared zeropages, because this could later
+ * trigger unexpected userfaultfd missing events.
+ *
+ * This must be called after mm->context.allow_cow_sharing was
+ * set to 0, to avoid future mappings of shared zeropages.
+ *
+ * mm contracts with s390, that even if mm were to remove a page table,
+ * and racing with walk_page_range_vma() calling pte_offset_map_lock()
+ * would fail, it will never insert a page table containing empty zero
+ * pages once mm_forbids_zeropage(mm) i.e.
+ * mm->context.allow_cow_sharing is set to 0.
+ */
+static int __gmap_helper_unshare_zeropages(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma;
+	VMA_ITERATOR(vmi, mm, 0);
+	unsigned long addr;
+	vm_fault_t fault;
+	int rc;
+
+	for_each_vma(vmi, vma) {
+		/*
+		 * We could only look at COW mappings, but it's more future
+		 * proof to catch unexpected zeropages in other mappings and
+		 * fail.
+		 */
+		if ((vma->vm_flags & VM_PFNMAP) || is_vm_hugetlb_page(vma))
+			continue;
+		addr = vma->vm_start;
+
+retry:
+		rc = walk_page_range_vma(vma, addr, vma->vm_end,
+					 &find_zeropage_ops, &addr);
+		if (rc < 0)
+			return rc;
+		else if (!rc)
+			continue;
+
+		/* addr was updated by find_zeropage_pte_entry() */
+		fault = handle_mm_fault(vma, addr,
+					FAULT_FLAG_UNSHARE | FAULT_FLAG_REMOTE,
+					NULL);
+		if (fault & VM_FAULT_OOM)
+			return -ENOMEM;
+		/*
+		 * See break_ksm(): even after handle_mm_fault() returned 0, we
+		 * must start the lookup from the current address, because
+		 * handle_mm_fault() may back out if there's any difficulty.
+		 *
+		 * VM_FAULT_SIGBUS and VM_FAULT_SIGSEGV are unexpected but
+		 * maybe they could trigger in the future on concurrent
+		 * truncation. In that case, the shared zeropage would be gone
+		 * and we can simply retry and make progress.
+		 */
+		cond_resched();
+		goto retry;
+	}
+
+	return 0;
+}
+
+/**
+ * gmap_helper_disable_cow_sharing() - disable all COW sharing
+ *
+ * Disable most COW-sharing of memory pages for the whole process:
+ * (1) Disable KSM and unmerge/unshare any KSM pages.
+ * (2) Disallow shared zeropages and unshare any zerpages that are mapped.
+ *
+ * Not that we currently don't bother with COW-shared pages that are shared
+ * with parent/child processes due to fork().
+ */
+int gmap_helper_disable_cow_sharing(void)
+{
+	struct mm_struct *mm = current->mm;
+	int rc;
+
+	mmap_assert_write_locked(mm);
+
+	if (!mm->context.allow_cow_sharing)
+		return 0;
+
+	mm->context.allow_cow_sharing = 0;
+
+	/* Replace all shared zeropages by anonymous pages. */
+	rc = __gmap_helper_unshare_zeropages(mm);
+	/*
+	 * Make sure to disable KSM (if enabled for the whole process or
+	 * individual VMAs). Note that nothing currently hinders user space
+	 * from re-enabling it.
+	 */
+	if (!rc)
+		rc = ksm_disable(mm);
+	if (rc)
+		mm->context.allow_cow_sharing = 1;
+	return rc;
+}
+EXPORT_SYMBOL_GPL(gmap_helper_disable_cow_sharing);
-- 
2.49.0


