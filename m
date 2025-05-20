Return-Path: <kvm+bounces-47175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 644E1ABE2AD
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 20:28:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED51A3AEE6E
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 18:27:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7632B284B48;
	Tue, 20 May 2025 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="tDQMKJAr"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CBC28315E;
	Tue, 20 May 2025 18:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747765616; cv=none; b=edzOtB8dFDmkbarLLMn52Pcbyk61oXTSY+gzq+UcJnIMVF66Nx53toxkd05ggN7RvQK4W1oSDhFAgwPgwDCIVT9ZFmCnnL1Px2jLXzohqowbunMQVZRoG0xxmidpYA3MaeuCUvKjULyZdhLGRQ65h5lbNNB+MYbBCasdGc4DqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747765616; c=relaxed/simple;
	bh=ceCbAxTndFQbfADC2Iobc+O2IHhjTNIbgd53PQFR+0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ap44prFeNyBedDGxGt1AqHNCVRhjiPmrk3SzkyTpQ6/kwUoQvtCgs+I6V2GXYOGzfWxprIFzLbx5V29tmXcNQYeMQh4hxZSwnkf6CBUnKQ8ZPLnJQcvM8Vd08ffpTSfE/Jm/24+ii8Ye/yLmkguWuYGretpVc68NpKp4gvAol/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=tDQMKJAr; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54KH6q86024971;
	Tue, 20 May 2025 18:26:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=axiYlgTPCEr8yGoxe
	bF6esHkXpqCnfakea6mtby/RWc=; b=tDQMKJArRV+OEICQu7f3vlkAmWHZErcxZ
	YSzBugMHzMVXEMb0LH38EQtKV0p2YfX1j3LFJNPidRfUQmFbOvql0+2Sc4cFdCtS
	/lfbdOTv/7yCS8AMIbH0yG6877cNnvLNBbSlL/dXEExEy4Pjv17F8QzBWe3geKD1
	FeYfOAW6sd9yU6CVmD2+FIapebWRdRDExqqcDNAVjrThu3esQyINMrPci+HxClSa
	O8CFJ8QV3KifscUkrFqKAdZyrDHpg+eNV8MB8F3O7taKBjxy/goC6UKDdtRrO+W5
	jmBgydqNUhr1aL8y6CZER76uZJTMpizqLkcE+G5po1uKyWfhutFWg==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46rwusrc91-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:46 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54KGrg3t032091;
	Tue, 20 May 2025 18:26:45 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnm8d0f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 20 May 2025 18:26:45 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54KIQfOs46137670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 May 2025 18:26:41 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B2E4C20040;
	Tue, 20 May 2025 18:26:41 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A9B52004B;
	Tue, 20 May 2025 18:26:41 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 20 May 2025 18:26:41 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, hca@linux.ibm.com,
        agordeev@linux.ibm.com, svens@linux.ibm.com, gor@linux.ibm.com,
        schlameuss@linux.ibm.com
Subject: [PATCH v2 4/5] KVM: s390: refactor and split some gmap helpers
Date: Tue, 20 May 2025 20:26:38 +0200
Message-ID: <20250520182639.80013-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520182639.80013-1-imbrenda@linux.ibm.com>
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vh5JBsJOcymzGB8dSeRV-S9bOSPD_dJS
X-Proofpoint-GUID: vh5JBsJOcymzGB8dSeRV-S9bOSPD_dJS
X-Authority-Analysis: v=2.4 cv=Lr+Symdc c=1 sm=1 tr=0 ts=682cc966 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=A87OFeSnFmpXKl82Tx8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIwMDE1MCBTYWx0ZWRfX2WXSSskRoShT pdeZGrOQlEFiwxEvpEK/ZoGKCAn3zbFViF10iHhPIdEyAyXg7ftwA9D+up6oiQcEVkobW2PLu6b 7X0BsUIc/fkQkyzs0ejnduEHdbGw5vOTE2xYUCSiGbeqOXpTTVwUBBTZKnD7Hbv/ldxoHf4hHff
 NLX/ziaQUGjZcF9C3v58KoS5/Akj6qIt6nKCxPXME3RJQ25wb+EoTQ5ERIPJ9TfON3WkCuAJhZg 97USqQo79/g2WNTkL0Ust6iONToMHCDfNEtmPd2V9iZBi+BBKMPjW7fWXNbx4+aj83BhvnkZNPm CmXJr7XUQc8VyZIe4XLd4npgliCMxi64kmQ/SAbE7Uxi5gbuRZn71nsgSkxVsw9CeN1uUH6drYv
 0paPgi0CMvc+oCnffo7k5KWdv7Nk02ruWJUv/3elyZmd5Ie05kEiYcGc5S4nrptt9AoPS/dn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-20_08,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 malwarescore=0
 spamscore=0 adultscore=0 suspectscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam authscore=0 authtc=n/a authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505200150

Refactor some gmap functions; move the implementation into a separate
file with only helper functions. The new helper functions work on vm
addresses, leaving all gmap logic in the gmap functions, which mostly
become just wrappers.

The whole gmap handling is going to be moved inside KVM soon, but the
helper functions need to touch core mm functions, and thus need to
stay in the core of kernel.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 MAINTAINERS                          |   2 +
 arch/s390/include/asm/gmap_helpers.h |  18 ++
 arch/s390/kvm/diag.c                 |  11 +-
 arch/s390/kvm/kvm-s390.c             |   5 +-
 arch/s390/mm/Makefile                |   2 +
 arch/s390/mm/gmap.c                  |  46 ++---
 arch/s390/mm/gmap_helpers.c          | 259 +++++++++++++++++++++++++++
 7 files changed, 302 insertions(+), 41 deletions(-)
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
diff --git a/arch/s390/include/asm/gmap_helpers.h b/arch/s390/include/asm/gmap_helpers.h
new file mode 100644
index 000000000000..1854fe6a8c33
--- /dev/null
+++ b/arch/s390/include/asm/gmap_helpers.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *  Helper functions for KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2025
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ */
+
+#ifndef _ASM_S390_GMAP_HELPERS_H
+#define _ASM_S390_GMAP_HELPERS_H
+
+void __gmap_helper_zap_one(struct mm_struct *mm, unsigned long vmaddr);
+void __gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end);
+void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end);
+void __gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmaddr);
+int gmap_helper_disable_cow_sharing(void);
+
+#endif /* _ASM_S390_GMAP_HELPERS_H */
diff --git a/arch/s390/kvm/diag.c b/arch/s390/kvm/diag.c
index 74f73141f9b9..ce8b2f8125c4 100644
--- a/arch/s390/kvm/diag.c
+++ b/arch/s390/kvm/diag.c
@@ -11,6 +11,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <asm/gmap.h>
+#include <asm/gmap_helpers.h>
 #include <asm/virtio-ccw.h>
 #include "kvm-s390.h"
 #include "trace.h"
@@ -37,7 +38,7 @@ static int diag_release_pages(struct kvm_vcpu *vcpu)
 	 * fast path (no prefix swap page involved)
 	 */
 	if (end <= prefix || start >= prefix + 2 * PAGE_SIZE) {
-		gmap_discard(vcpu->arch.gmap, start, end);
+		gmap_helper_discard(vcpu->kvm->mm, start, end);
 	} else {
 		/*
 		 * This is slow path.  gmap_discard will check for start
@@ -45,12 +46,12 @@ static int diag_release_pages(struct kvm_vcpu *vcpu)
 		 * prefix and let gmap_discard make some of these calls
 		 * NOPs.
 		 */
-		gmap_discard(vcpu->arch.gmap, start, prefix);
+		gmap_helper_discard(vcpu->kvm->mm, start, prefix);
 		if (start <= prefix)
-			gmap_discard(vcpu->arch.gmap, 0, PAGE_SIZE);
+			gmap_helper_discard(vcpu->kvm->mm, 0, PAGE_SIZE);
 		if (end > prefix + PAGE_SIZE)
-			gmap_discard(vcpu->arch.gmap, PAGE_SIZE, 2 * PAGE_SIZE);
-		gmap_discard(vcpu->arch.gmap, prefix + 2 * PAGE_SIZE, end);
+			gmap_helper_discard(vcpu->kvm->mm, PAGE_SIZE, 2 * PAGE_SIZE);
+		gmap_helper_discard(vcpu->kvm->mm, prefix + 2 * PAGE_SIZE, end);
 	}
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
index 4869555ff403..17a2a57de3a2 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -22,6 +22,7 @@
 #include <asm/page-states.h>
 #include <asm/pgalloc.h>
 #include <asm/machine.h>
+#include <asm/gmap_helpers.h>
 #include <asm/gmap.h>
 #include <asm/page.h>
 
@@ -619,58 +620,33 @@ EXPORT_SYMBOL(__gmap_link);
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
+		__gmap_helper_zap_one(gmap->mm, vmaddr);
 	}
 }
 EXPORT_SYMBOL_GPL(__gmap_zap);
 
 void gmap_discard(struct gmap *gmap, unsigned long from, unsigned long to)
 {
-	unsigned long gaddr, vmaddr, size;
-	struct vm_area_struct *vma;
+	unsigned long vmaddr, next, start, end;
 
 	mmap_read_lock(gmap->mm);
-	for (gaddr = from; gaddr < to;
-	     gaddr = (gaddr + PMD_SIZE) & PMD_MASK) {
-		/* Find the vm address for the guest address */
-		vmaddr = (unsigned long)
-			radix_tree_lookup(&gmap->guest_to_host,
-					  gaddr >> PMD_SHIFT);
+	for ( ; from < to; from = next) {
+		next = ALIGN(from + 1, PMD_SIZE);
+		vmaddr = (unsigned long)radix_tree_lookup(&gmap->guest_to_host, from >> PMD_SHIFT);
 		if (!vmaddr)
 			continue;
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
+		start = vmaddr | (from & ~PMD_MASK);
+		end = (vmaddr | (min(to - 1, next - 1) & ~PMD_MASK)) + 1;
+		__gmap_helper_discard(gmap->mm, start, end);
 	}
 	mmap_read_unlock(gmap->mm);
 }
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
new file mode 100644
index 000000000000..4b70bc9cb5e3
--- /dev/null
+++ b/arch/s390/mm/gmap_helpers.c
@@ -0,0 +1,259 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ *  Helper functions for KVM guest address space mapping code
+ *
+ *    Copyright IBM Corp. 2007, 2025
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.ibm.com>
+ *               Martin Schwidefsky <schwidefsky@de.ibm.com>
+ *               David Hildenbrand <david@redhat.com>
+ *               Janosch Frank <frankja@linux.vnet.ibm.com>
+ */
+#include <linux/mm_types.h>
+#include <linux/mmap_lock.h>
+#include <linux/mm.h>
+#include <linux/hugetlb.h>
+#include <linux/pagewalk.h>
+#include <linux/ksm.h>
+#include <asm/gmap_helpers.h>
+
+static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
+{
+	if (!non_swap_entry(entry))
+		dec_mm_counter(mm, MM_SWAPENTS);
+	else if (is_migration_entry(entry))
+		dec_mm_counter(mm, mm_counter(pfn_swap_entry_folio(entry)));
+	free_swap_and_cache(entry);
+}
+
+void __gmap_helper_zap_one(struct mm_struct *mm, unsigned long vmaddr)
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
+	if (!likely(ptep))
+		return;
+	if (pte_swap(*ptep))
+		ptep_zap_swap_entry(mm, pte_to_swp_entry(*ptep));
+	pte_unmap_unlock(ptep, ptl);
+}
+EXPORT_SYMBOL_GPL(__gmap_helper_zap_one);
+
+void __gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end)
+{
+	struct vm_area_struct *vma;
+	unsigned long next;
+
+	mmap_assert_locked(mm);
+
+	while (vmaddr < end) {
+		vma = find_vma_intersection(mm, vmaddr, end);
+		if (!vma)
+			break;
+		vmaddr = max(vmaddr, vma->vm_start);
+		next = min(end, vma->vm_end);
+		if (!is_vm_hugetlb_page(vma))
+			zap_page_range_single(vma, vmaddr, next - vmaddr, NULL);
+		vmaddr = next;
+	}
+}
+
+void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end)
+{
+	mmap_read_lock(mm);
+	__gmap_helper_discard(mm, vmaddr, end);
+	mmap_read_unlock(mm);
+}
+EXPORT_SYMBOL_GPL(gmap_helper_discard);
+
+static int pmd_lookup(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
+{
+	struct vm_area_struct *vma;
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+
+	/* We need a valid VMA, otherwise this is clearly a fault. */
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		return -EFAULT;
+
+	pgd = pgd_offset(mm, addr);
+	if (!pgd_present(*pgd))
+		return -ENOENT;
+
+	p4d = p4d_offset(pgd, addr);
+	if (!p4d_present(*p4d))
+		return -ENOENT;
+
+	pud = pud_offset(p4d, addr);
+	if (!pud_present(*pud))
+		return -ENOENT;
+
+	/* Large PUDs are not supported yet. */
+	if (pud_leaf(*pud))
+		return -EFAULT;
+
+	*pmdp = pmd_offset(pud, addr);
+	return 0;
+}
+
+void __gmap_helper_set_unused(struct mm_struct *mm, unsigned long vmaddr)
+{
+	spinlock_t *ptl;
+	pmd_t *pmdp;
+	pte_t *ptep;
+
+	mmap_assert_locked(mm);
+
+	if (pmd_lookup(mm, vmaddr, &pmdp))
+		return;
+	ptl = pmd_lock(mm, pmdp);
+	if (!pmd_present(*pmdp) || pmd_leaf(*pmdp)) {
+		spin_unlock(ptl);
+		return;
+	}
+	spin_unlock(ptl);
+
+	ptep = pte_offset_map_lock(mm, pmdp, vmaddr, &ptl);
+	if (!ptep)
+		return;
+	/* The last byte of a pte can be changed freely without ipte */
+	__atomic64_or(_PAGE_UNUSED, (long *)ptep);
+	pte_unmap_unlock(ptep, ptl);
+}
+EXPORT_SYMBOL_GPL(__gmap_helper_set_unused);
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
+/*
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
+/*
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


