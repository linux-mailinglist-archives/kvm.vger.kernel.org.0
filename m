Return-Path: <kvm+bounces-63911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D085CC75ACB
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 18:30:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 4304135CDCD
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 17:25:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C69D369996;
	Thu, 20 Nov 2025 17:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HGeCSZz8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFF6371A1F;
	Thu, 20 Nov 2025 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763659012; cv=none; b=IVWEvLnj8ZhnZ3HXUWimFA1ZGCJuMfIDX6zU8VBz7Tf0vIQjdRE854Q4PptaDcx8qUHXZ/S9EQsd2KCQSJy3VtQ/YhSBzT3MKwofKZavzipuJOB7pNZFpKDrh0j72g/FpPvJOPFbCVWfEqrQijJufxtnuBXR+wADRWVdpCmClJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763659012; c=relaxed/simple;
	bh=UD2BOFv8ugFzu5joTLi9gHrf/7eaVj1CTkHpG0AiODM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KD8hSwh9OVd7IYjermXJx+9EkjKtt24nwOgcq8jxpuE2jYgv+tlxvjH04r601k76XJrWwVi9uyVP4rAPuMLxVcoIAwg9+xTIlAT1dpL6CTqBz86wzyMZtdCzl18a8/SqwkHJgulaffhc7nDfzx8VtfuKxDMg58QxgpVoesPC13k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HGeCSZz8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKCk5xS007069;
	Thu, 20 Nov 2025 17:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=vqvKCP4YcF0uXyoA/
	ypSZpyoP61wolJsZAO0p7Q3YmI=; b=HGeCSZz8MK4Th0LEPcwAqAyaESRN6r0J2
	dvrd9ItChmVbwqp+pKbonkrRh9n0OYv9g3mBkBbzUZ0l555nTHj009UNvw9+RJ0I
	YXGclbx9T4lJVskkea4tcZ7oC8ESm0AEsS4T6g9CQL6TlANa8QtC7OAF7HwPYtmP
	J35U64AVO1GVm9Z3dU7NAI9DD1vJ2Zh7OV15YGh1joDJw/e4ID9t2u3oR7p4h1t4
	/HhCDHE9CQX//tvKHSGYkCbEkrw+eXbOSWnlFkiGmfNjjZGZkCDFpFosxssHEZjk
	kagyMdPc4iHIlzPv6srwB5KugZbFeJfKvHYZ7Qyb2kkTMpdz24inQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aejmsxbsh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:46 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AKH0nRl022311;
	Thu, 20 Nov 2025 17:16:33 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4af4un7mh0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 20 Nov 2025 17:16:32 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AKHGSgU31326714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 17:16:28 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3AD1D2004B;
	Thu, 20 Nov 2025 17:16:28 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBE8D20040;
	Thu, 20 Nov 2025 17:16:25 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.12.33])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 20 Nov 2025 17:16:25 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v4 21/23] KVM: S390: Remove PGSTE code from linux/s390 mm
Date: Thu, 20 Nov 2025 18:15:42 +0100
Message-ID: <20251120171544.96841-22-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251120171544.96841-1-imbrenda@linux.ibm.com>
References: <20251120171544.96841-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MPE324GEvcEaXOi0nYvmJBU6CBBEbcMG
X-Authority-Analysis: v=2.4 cv=Rv3I7SmK c=1 sm=1 tr=0 ts=691f4cfe cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=iGo5jALgg6wKPfVY9XUA:9
X-Proofpoint-GUID: MPE324GEvcEaXOi0nYvmJBU6CBBEbcMG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfXxqEX7y4P4Tqe
 kNy000UgpaAzkn8pIs4eIYJnSGS8fW1+hkhkVaBgq+EFcP9BHv/NF8dXHu/F5K221fhiC908acJ
 ed1OHUe2370Ohl5hTuDiijy3IZyELQROx09UuC+LrrCGmYWi6nXsR8ZuGH5DE9aoKJR4YIc2zB3
 1uQP6LLGF9ZFGnR53tiunKoJXBs4CZWWBUN16B2Kj4pU8cMpQU/10XYa34MvyYH6qz3Dtj7Zruy
 lYf+EihhuoNjTs0z2KnpqhhiBeJRoSt66gO/zmRA/iPMGOgvPbGZVFFGZyF4++n0ribNuUSBifp
 b0Frg+xiJq9GAdhOAw6b+Zuygf3q15XFw1+V8bmM8OHIUqlA860pWei6TaGDvJlCYK+GPmjpNZv
 Ox2iWe3Ul+qWONSuY9wmJLoXnUDJaA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-20_06,2025-11-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 priorityscore=1501
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511150032

Remove the PGSTE config option.
Remove all code from linux/s390 mm that involves PGSTEs.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/Kconfig               |   3 -
 arch/s390/include/asm/mmu.h     |  13 -
 arch/s390/include/asm/page.h    |   4 -
 arch/s390/include/asm/pgalloc.h |   4 -
 arch/s390/include/asm/pgtable.h | 121 +----
 arch/s390/kvm/dat.h             |   1 +
 arch/s390/mm/hugetlbpage.c      |  24 -
 arch/s390/mm/pgalloc.c          |  24 -
 arch/s390/mm/pgtable.c          | 829 +-------------------------------
 mm/khugepaged.c                 |   9 -
 10 files changed, 17 insertions(+), 1015 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 3b4ba19a3611..162dc930092e 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -32,9 +32,6 @@ config GENERIC_BUG_RELATIVE_POINTERS
 config GENERIC_LOCKBREAK
 	def_bool y if PREEMPTION
 
-config PGSTE
-	def_bool n
-
 config AUDIT_ARCH
 	def_bool y
 
diff --git a/arch/s390/include/asm/mmu.h b/arch/s390/include/asm/mmu.h
index f07e49b419ab..d4fd7bf3692e 100644
--- a/arch/s390/include/asm/mmu.h
+++ b/arch/s390/include/asm/mmu.h
@@ -18,24 +18,11 @@ typedef struct {
 	unsigned long vdso_base;
 	/* The mmu context belongs to a secure guest. */
 	atomic_t protected_count;
-	/*
-	 * The following bitfields need a down_write on the mm
-	 * semaphore when they are written to. As they are only
-	 * written once, they can be read without a lock.
-	 */
-	/* The mmu context uses extended page tables. */
-	unsigned int has_pgste:1;
-	/* The mmu context uses storage keys. */
-	unsigned int uses_skeys:1;
-	/* The mmu context uses CMM. */
-	unsigned int uses_cmm:1;
 	/*
 	 * The mmu context allows COW-sharing of memory pages (KSM, zeropage).
 	 * Note that COW-sharing during fork() is currently always allowed.
 	 */
 	unsigned int allow_cow_sharing:1;
-	/* The gmaps associated with this context are allowed to use huge pages. */
-	unsigned int allow_gmap_hpage_1m:1;
 } mm_context_t;
 
 #define INIT_MM_CONTEXT(name)						   \
diff --git a/arch/s390/include/asm/page.h b/arch/s390/include/asm/page.h
index 9240a363c893..5047a0a9450c 100644
--- a/arch/s390/include/asm/page.h
+++ b/arch/s390/include/asm/page.h
@@ -78,7 +78,6 @@ static inline void copy_page(void *to, void *from)
 #ifdef STRICT_MM_TYPECHECKS
 
 typedef struct { unsigned long pgprot; } pgprot_t;
-typedef struct { unsigned long pgste; } pgste_t;
 typedef struct { unsigned long pte; } pte_t;
 typedef struct { unsigned long pmd; } pmd_t;
 typedef struct { unsigned long pud; } pud_t;
@@ -94,7 +93,6 @@ static __always_inline unsigned long name ## _val(name ## _t name)	\
 #else /* STRICT_MM_TYPECHECKS */
 
 typedef unsigned long pgprot_t;
-typedef unsigned long pgste_t;
 typedef unsigned long pte_t;
 typedef unsigned long pmd_t;
 typedef unsigned long pud_t;
@@ -110,7 +108,6 @@ static __always_inline unsigned long name ## _val(name ## _t name)	\
 #endif /* STRICT_MM_TYPECHECKS */
 
 DEFINE_PGVAL_FUNC(pgprot)
-DEFINE_PGVAL_FUNC(pgste)
 DEFINE_PGVAL_FUNC(pte)
 DEFINE_PGVAL_FUNC(pmd)
 DEFINE_PGVAL_FUNC(pud)
@@ -120,7 +117,6 @@ DEFINE_PGVAL_FUNC(pgd)
 typedef pte_t *pgtable_t;
 
 #define __pgprot(x)	((pgprot_t) { (x) } )
-#define __pgste(x)	((pgste_t) { (x) } )
 #define __pte(x)        ((pte_t) { (x) } )
 #define __pmd(x)        ((pmd_t) { (x) } )
 #define __pud(x)	((pud_t) { (x) } )
diff --git a/arch/s390/include/asm/pgalloc.h b/arch/s390/include/asm/pgalloc.h
index a16e65072371..a5de9e61ea9e 100644
--- a/arch/s390/include/asm/pgalloc.h
+++ b/arch/s390/include/asm/pgalloc.h
@@ -27,10 +27,6 @@ unsigned long *page_table_alloc_noprof(struct mm_struct *);
 #define page_table_alloc(...)	alloc_hooks(page_table_alloc_noprof(__VA_ARGS__))
 void page_table_free(struct mm_struct *, unsigned long *);
 
-struct ptdesc *page_table_alloc_pgste_noprof(struct mm_struct *mm);
-#define page_table_alloc_pgste(...)	alloc_hooks(page_table_alloc_pgste_noprof(__VA_ARGS__))
-void page_table_free_pgste(struct ptdesc *ptdesc);
-
 static inline void crst_table_init(unsigned long *crst, unsigned long entry)
 {
 	memset64((u64 *)crst, entry, _CRST_ENTRIES);
diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index b6ec18999c62..fc1915b8e379 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -413,28 +413,6 @@ void setup_protection_map(void);
  * SW-bits: y young, d dirty, r read, w write
  */
 
-/* Page status table bits for virtualization */
-#define PGSTE_ACC_BITS	0xf000000000000000UL
-#define PGSTE_FP_BIT	0x0800000000000000UL
-#define PGSTE_PCL_BIT	0x0080000000000000UL
-#define PGSTE_HR_BIT	0x0040000000000000UL
-#define PGSTE_HC_BIT	0x0020000000000000UL
-#define PGSTE_GR_BIT	0x0004000000000000UL
-#define PGSTE_GC_BIT	0x0002000000000000UL
-#define PGSTE_ST2_MASK	0x0000ffff00000000UL
-#define PGSTE_UC_BIT	0x0000000000008000UL	/* user dirty (migration) */
-#define PGSTE_IN_BIT	0x0000000000004000UL	/* IPTE notify bit */
-#define PGSTE_VSIE_BIT	0x0000000000002000UL	/* ref'd in a shadow table */
-
-/* Guest Page State used for virtualization */
-#define _PGSTE_GPS_ZERO			0x0000000080000000UL
-#define _PGSTE_GPS_NODAT		0x0000000040000000UL
-#define _PGSTE_GPS_USAGE_MASK		0x0000000003000000UL
-#define _PGSTE_GPS_USAGE_STABLE		0x0000000000000000UL
-#define _PGSTE_GPS_USAGE_UNUSED		0x0000000001000000UL
-#define _PGSTE_GPS_USAGE_POT_VOLATILE	0x0000000002000000UL
-#define _PGSTE_GPS_USAGE_VOLATILE	_PGSTE_GPS_USAGE_MASK
-
 /*
  * A user page table pointer has the space-switch-event bit, the
  * private-space-control bit and the storage-alteration-event-control
@@ -566,15 +544,6 @@ static inline bool mm_pmd_folded(struct mm_struct *mm)
 }
 #define mm_pmd_folded(mm) mm_pmd_folded(mm)
 
-static inline int mm_has_pgste(struct mm_struct *mm)
-{
-#ifdef CONFIG_PGSTE
-	if (unlikely(mm->context.has_pgste))
-		return 1;
-#endif
-	return 0;
-}
-
 static inline int mm_is_protected(struct mm_struct *mm)
 {
 #if IS_ENABLED(CONFIG_KVM)
@@ -584,16 +553,6 @@ static inline int mm_is_protected(struct mm_struct *mm)
 	return 0;
 }
 
-static inline pgste_t clear_pgste_bit(pgste_t pgste, unsigned long mask)
-{
-	return __pgste(pgste_val(pgste) & ~mask);
-}
-
-static inline pgste_t set_pgste_bit(pgste_t pgste, unsigned long mask)
-{
-	return __pgste(pgste_val(pgste) | mask);
-}
-
 static inline pte_t clear_pte_bit(pte_t pte, pgprot_t prot)
 {
 	return __pte(pte_val(pte) & ~pgprot_val(prot));
@@ -639,15 +598,6 @@ static inline int mm_forbids_zeropage(struct mm_struct *mm)
 	return 0;
 }
 
-static inline int mm_uses_skeys(struct mm_struct *mm)
-{
-#ifdef CONFIG_PGSTE
-	if (mm->context.uses_skeys)
-		return 1;
-#endif
-	return 0;
-}
-
 static inline void csp(unsigned int *ptr, unsigned int old, unsigned int new)
 {
 	union register_pair r1 = { .even = old, .odd = new, };
@@ -1367,45 +1317,13 @@ static inline int ptep_set_access_flags(struct vm_area_struct *vma,
 {
 	if (pte_same(*ptep, entry))
 		return 0;
-	if (cpu_has_rdp() && !mm_has_pgste(vma->vm_mm) && pte_allow_rdp(*ptep, entry))
+	if (cpu_has_rdp() && pte_allow_rdp(*ptep, entry))
 		ptep_reset_dat_prot(vma->vm_mm, addr, ptep, entry);
 	else
 		ptep_xchg_direct(vma->vm_mm, addr, ptep, entry);
 	return 1;
 }
 
-/*
- * Additional functions to handle KVM guest page tables
- */
-void ptep_set_pte_at(struct mm_struct *mm, unsigned long addr,
-		     pte_t *ptep, pte_t entry);
-void ptep_set_notify(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
-int ptep_force_prot(struct mm_struct *mm, unsigned long gaddr,
-		    pte_t *ptep, int prot, unsigned long bit);
-void ptep_zap_unused(struct mm_struct *mm, unsigned long addr,
-		     pte_t *ptep , int reset);
-void ptep_zap_key(struct mm_struct *mm, unsigned long addr, pte_t *ptep);
-int ptep_shadow_pte(struct mm_struct *mm, unsigned long saddr,
-		    pte_t *sptep, pte_t *tptep, pte_t pte);
-void ptep_unshadow_pte(struct mm_struct *mm, unsigned long saddr, pte_t *ptep);
-
-bool ptep_test_and_clear_uc(struct mm_struct *mm, unsigned long address,
-			    pte_t *ptep);
-int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
-			  unsigned char key, bool nq);
-int cond_set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
-			       unsigned char key, unsigned char *oldkey,
-			       bool nq, bool mr, bool mc);
-int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr);
-int get_guest_storage_key(struct mm_struct *mm, unsigned long addr,
-			  unsigned char *key);
-
-int set_pgste_bits(struct mm_struct *mm, unsigned long addr,
-				unsigned long bits, unsigned long value);
-int get_pgste(struct mm_struct *mm, unsigned long hva, unsigned long *pgstep);
-int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
-			unsigned long *oldpte, unsigned long *oldpgste);
-
 #define pgprot_writecombine	pgprot_writecombine
 pgprot_t pgprot_writecombine(pgprot_t prot);
 
@@ -1420,23 +1338,12 @@ static inline void set_ptes(struct mm_struct *mm, unsigned long addr,
 {
 	if (pte_present(entry))
 		entry = clear_pte_bit(entry, __pgprot(_PAGE_UNUSED));
-	if (mm_has_pgste(mm)) {
-		for (;;) {
-			ptep_set_pte_at(mm, addr, ptep, entry);
-			if (--nr == 0)
-				break;
-			ptep++;
-			entry = __pte(pte_val(entry) + PAGE_SIZE);
-			addr += PAGE_SIZE;
-		}
-	} else {
-		for (;;) {
-			set_pte(ptep, entry);
-			if (--nr == 0)
-				break;
-			ptep++;
-			entry = __pte(pte_val(entry) + PAGE_SIZE);
-		}
+	for (;;) {
+		set_pte(ptep, entry);
+		if (--nr == 0)
+			break;
+		ptep++;
+		entry = __pte(pte_val(entry) + PAGE_SIZE);
 	}
 }
 #define set_ptes set_ptes
@@ -2037,18 +1944,4 @@ extern pte_t *vmem_get_alloc_pte(unsigned long addr, bool alloc);
 #define pmd_pgtable(pmd) \
 	((pgtable_t)__va(pmd_val(pmd) & -sizeof(pte_t)*PTRS_PER_PTE))
 
-static inline unsigned long gmap_pgste_get_pgt_addr(unsigned long *pgt)
-{
-	unsigned long *pgstes, res;
-
-	pgstes = pgt + _PAGE_ENTRIES;
-
-	res = (pgstes[0] & PGSTE_ST2_MASK) << 16;
-	res |= pgstes[1] & PGSTE_ST2_MASK;
-	res |= (pgstes[2] & PGSTE_ST2_MASK) >> 16;
-	res |= (pgstes[3] & PGSTE_ST2_MASK) >> 32;
-
-	return res;
-}
-
 #endif /* _S390_PAGE_H */
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index 4190a54224c0..21a096dec9d7 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -108,6 +108,7 @@ union pte {
 #define _PAGE_SD 0x002
 
 /* Needed as macro to perform atomic operations */
+#define PGSTE_PCL_BIT		0x0080000000000000UL	/* PCL lock, HW bit */
 #define PGSTE_CMMA_D_BIT	0x0000000000008000UL	/* CMMA dirty soft-bit */
 
 enum pgste_gps_usage {
diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index 72e8fa136af5..2597c1766a62 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -136,29 +136,6 @@ static inline pte_t __rste_to_pte(unsigned long rste)
 	return __pte(pteval);
 }
 
-static void clear_huge_pte_skeys(struct mm_struct *mm, unsigned long rste)
-{
-	struct folio *folio;
-	unsigned long size, paddr;
-
-	if (!mm_uses_skeys(mm) ||
-	    rste & _SEGMENT_ENTRY_INVALID)
-		return;
-
-	if ((rste & _REGION_ENTRY_TYPE_MASK) == _REGION_ENTRY_TYPE_R3) {
-		folio = page_folio(pud_page(__pud(rste)));
-		size = PUD_SIZE;
-		paddr = rste & PUD_MASK;
-	} else {
-		folio = page_folio(pmd_page(__pmd(rste)));
-		size = PMD_SIZE;
-		paddr = rste & PMD_MASK;
-	}
-
-	if (!test_and_set_bit(PG_arch_1, &folio->flags.f))
-		__storage_key_init_range(paddr, paddr + size);
-}
-
 void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t pte)
 {
@@ -174,7 +151,6 @@ void __set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
 	} else if (likely(pte_present(pte)))
 		rste |= _SEGMENT_ENTRY_LARGE;
 
-	clear_huge_pte_skeys(mm, rste);
 	set_pte(ptep, __pte(rste));
 }
 
diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index 626fca116cd7..3dc2aebf8e6e 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -114,30 +114,6 @@ int crst_table_upgrade(struct mm_struct *mm, unsigned long end)
 	return -ENOMEM;
 }
 
-#ifdef CONFIG_PGSTE
-
-struct ptdesc *page_table_alloc_pgste_noprof(struct mm_struct *mm)
-{
-	struct ptdesc *ptdesc;
-	u64 *table;
-
-	ptdesc = pagetable_alloc_noprof(GFP_KERNEL_ACCOUNT, 0);
-	if (ptdesc) {
-		table = (u64 *)ptdesc_address(ptdesc);
-		__arch_set_page_dat(table, 1);
-		memset64(table, _PAGE_INVALID, PTRS_PER_PTE);
-		memset64(table + PTRS_PER_PTE, 0, PTRS_PER_PTE);
-	}
-	return ptdesc;
-}
-
-void page_table_free_pgste(struct ptdesc *ptdesc)
-{
-	pagetable_free(ptdesc);
-}
-
-#endif /* CONFIG_PGSTE */
-
 unsigned long *page_table_alloc_noprof(struct mm_struct *mm)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT;
diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 9cbd1552f918..ed39b1c6bed3 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -115,171 +115,14 @@ static inline pte_t ptep_flush_lazy(struct mm_struct *mm,
 	return old;
 }
 
-static inline pgste_t pgste_get_lock(pte_t *ptep)
-{
-	unsigned long value = 0;
-#ifdef CONFIG_PGSTE
-	unsigned long *ptr = (unsigned long *)(ptep + PTRS_PER_PTE);
-
-	do {
-		value = __atomic64_or_barrier(PGSTE_PCL_BIT, ptr);
-	} while (value & PGSTE_PCL_BIT);
-	value |= PGSTE_PCL_BIT;
-#endif
-	return __pgste(value);
-}
-
-static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
-{
-#ifdef CONFIG_PGSTE
-	barrier();
-	WRITE_ONCE(*(unsigned long *)(ptep + PTRS_PER_PTE), pgste_val(pgste) & ~PGSTE_PCL_BIT);
-#endif
-}
-
-static inline pgste_t pgste_get(pte_t *ptep)
-{
-	unsigned long pgste = 0;
-#ifdef CONFIG_PGSTE
-	pgste = *(unsigned long *)(ptep + PTRS_PER_PTE);
-#endif
-	return __pgste(pgste);
-}
-
-static inline void pgste_set(pte_t *ptep, pgste_t pgste)
-{
-#ifdef CONFIG_PGSTE
-	*(pgste_t *)(ptep + PTRS_PER_PTE) = pgste;
-#endif
-}
-
-static inline pgste_t pgste_update_all(pte_t pte, pgste_t pgste,
-				       struct mm_struct *mm)
-{
-#ifdef CONFIG_PGSTE
-	unsigned long address, bits, skey;
-
-	if (!mm_uses_skeys(mm) || pte_val(pte) & _PAGE_INVALID)
-		return pgste;
-	address = pte_val(pte) & PAGE_MASK;
-	skey = (unsigned long) page_get_storage_key(address);
-	bits = skey & (_PAGE_CHANGED | _PAGE_REFERENCED);
-	/* Transfer page changed & referenced bit to guest bits in pgste */
-	pgste = set_pgste_bit(pgste, bits << 48); /* GR bit & GC bit */
-	/* Copy page access key and fetch protection bit to pgste */
-	pgste = clear_pgste_bit(pgste, PGSTE_ACC_BITS | PGSTE_FP_BIT);
-	pgste = set_pgste_bit(pgste, (skey & (_PAGE_ACC_BITS | _PAGE_FP_BIT)) << 56);
-#endif
-	return pgste;
-
-}
-
-static inline void pgste_set_key(pte_t *ptep, pgste_t pgste, pte_t entry,
-				 struct mm_struct *mm)
-{
-#ifdef CONFIG_PGSTE
-	unsigned long address;
-	unsigned long nkey;
-
-	if (!mm_uses_skeys(mm) || pte_val(entry) & _PAGE_INVALID)
-		return;
-	VM_BUG_ON(!(pte_val(*ptep) & _PAGE_INVALID));
-	address = pte_val(entry) & PAGE_MASK;
-	/*
-	 * Set page access key and fetch protection bit from pgste.
-	 * The guest C/R information is still in the PGSTE, set real
-	 * key C/R to 0.
-	 */
-	nkey = (pgste_val(pgste) & (PGSTE_ACC_BITS | PGSTE_FP_BIT)) >> 56;
-	nkey |= (pgste_val(pgste) & (PGSTE_GR_BIT | PGSTE_GC_BIT)) >> 48;
-	page_set_storage_key(address, nkey, 0);
-#endif
-}
-
-static inline pgste_t pgste_set_pte(pte_t *ptep, pgste_t pgste, pte_t entry)
-{
-#ifdef CONFIG_PGSTE
-	if ((pte_val(entry) & _PAGE_PRESENT) &&
-	    (pte_val(entry) & _PAGE_WRITE) &&
-	    !(pte_val(entry) & _PAGE_INVALID)) {
-		if (!machine_has_esop()) {
-			/*
-			 * Without enhanced suppression-on-protection force
-			 * the dirty bit on for all writable ptes.
-			 */
-			entry = set_pte_bit(entry, __pgprot(_PAGE_DIRTY));
-			entry = clear_pte_bit(entry, __pgprot(_PAGE_PROTECT));
-		}
-		if (!(pte_val(entry) & _PAGE_PROTECT))
-			/* This pte allows write access, set user-dirty */
-			pgste = set_pgste_bit(pgste, PGSTE_UC_BIT);
-	}
-#endif
-	set_pte(ptep, entry);
-	return pgste;
-}
-
-static inline pgste_t pgste_pte_notify(struct mm_struct *mm,
-				       unsigned long addr,
-				       pte_t *ptep, pgste_t pgste)
-{
-#ifdef CONFIG_PGSTE
-	unsigned long bits;
-
-	bits = pgste_val(pgste) & (PGSTE_IN_BIT | PGSTE_VSIE_BIT);
-	if (bits) {
-		pgste = __pgste(pgste_val(pgste) ^ bits);
-		ptep_notify(mm, addr, ptep, bits);
-	}
-#endif
-	return pgste;
-}
-
-static inline pgste_t ptep_xchg_start(struct mm_struct *mm,
-				      unsigned long addr, pte_t *ptep)
-{
-	pgste_t pgste = __pgste(0);
-
-	if (mm_has_pgste(mm)) {
-		pgste = pgste_get_lock(ptep);
-		pgste = pgste_pte_notify(mm, addr, ptep, pgste);
-	}
-	return pgste;
-}
-
-static inline pte_t ptep_xchg_commit(struct mm_struct *mm,
-				    unsigned long addr, pte_t *ptep,
-				    pgste_t pgste, pte_t old, pte_t new)
-{
-	if (mm_has_pgste(mm)) {
-		if (pte_val(old) & _PAGE_INVALID)
-			pgste_set_key(ptep, pgste, new, mm);
-		if (pte_val(new) & _PAGE_INVALID) {
-			pgste = pgste_update_all(old, pgste, mm);
-			if ((pgste_val(pgste) & _PGSTE_GPS_USAGE_MASK) ==
-			    _PGSTE_GPS_USAGE_UNUSED)
-				old = set_pte_bit(old, __pgprot(_PAGE_UNUSED));
-		}
-		pgste = pgste_set_pte(ptep, pgste, new);
-		pgste_set_unlock(ptep, pgste);
-	} else {
-		set_pte(ptep, new);
-	}
-	return old;
-}
-
 pte_t ptep_xchg_direct(struct mm_struct *mm, unsigned long addr,
 		       pte_t *ptep, pte_t new)
 {
-	pgste_t pgste;
 	pte_t old;
-	int nodat;
 
 	preempt_disable();
-	pgste = ptep_xchg_start(mm, addr, ptep);
-	nodat = !!(pgste_val(pgste) & _PGSTE_GPS_NODAT);
-	old = ptep_flush_direct(mm, addr, ptep, nodat);
-	old = ptep_xchg_commit(mm, addr, ptep, pgste, old, new);
+	old = ptep_flush_direct(mm, addr, ptep, 1);
+	set_pte(ptep, new);
 	preempt_enable();
 	return old;
 }
@@ -313,15 +156,11 @@ EXPORT_SYMBOL(ptep_reset_dat_prot);
 pte_t ptep_xchg_lazy(struct mm_struct *mm, unsigned long addr,
 		     pte_t *ptep, pte_t new)
 {
-	pgste_t pgste;
 	pte_t old;
-	int nodat;
 
 	preempt_disable();
-	pgste = ptep_xchg_start(mm, addr, ptep);
-	nodat = !!(pgste_val(pgste) & _PGSTE_GPS_NODAT);
-	old = ptep_flush_lazy(mm, addr, ptep, nodat);
-	old = ptep_xchg_commit(mm, addr, ptep, pgste, old, new);
+	old = ptep_flush_lazy(mm, addr, ptep, 1);
+	set_pte(ptep, new);
 	preempt_enable();
 	return old;
 }
@@ -330,43 +169,22 @@ EXPORT_SYMBOL(ptep_xchg_lazy);
 pte_t ptep_modify_prot_start(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t *ptep)
 {
-	pgste_t pgste;
-	pte_t old;
-	int nodat;
-	struct mm_struct *mm = vma->vm_mm;
-
-	pgste = ptep_xchg_start(mm, addr, ptep);
-	nodat = !!(pgste_val(pgste) & _PGSTE_GPS_NODAT);
-	old = ptep_flush_lazy(mm, addr, ptep, nodat);
-	if (mm_has_pgste(mm)) {
-		pgste = pgste_update_all(old, pgste, mm);
-		pgste_set(ptep, pgste);
-	}
-	return old;
+	preempt_disable();
+	return ptep_flush_lazy(vma->vm_mm, addr, ptep, 1);
 }
 
 void ptep_modify_prot_commit(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t *ptep, pte_t old_pte, pte_t pte)
 {
-	pgste_t pgste;
-	struct mm_struct *mm = vma->vm_mm;
-
-	if (mm_has_pgste(mm)) {
-		pgste = pgste_get(ptep);
-		pgste_set_key(ptep, pgste, pte, mm);
-		pgste = pgste_set_pte(ptep, pgste, pte);
-		pgste_set_unlock(ptep, pgste);
-	} else {
-		set_pte(ptep, pte);
-	}
+	set_pte(ptep, pte);
+	preempt_enable();
 }
 
 static inline void pmdp_idte_local(struct mm_struct *mm,
 				   unsigned long addr, pmd_t *pmdp)
 {
 	if (machine_has_tlb_guest())
-		__pmdp_idte(addr, pmdp, IDTE_NODAT | IDTE_GUEST_ASCE,
-			    mm->context.asce, IDTE_LOCAL);
+		__pmdp_idte(addr, pmdp, IDTE_NODAT | IDTE_GUEST_ASCE, mm->context.asce, IDTE_LOCAL);
 	else
 		__pmdp_idte(addr, pmdp, 0, 0, IDTE_LOCAL);
 }
@@ -422,40 +240,6 @@ static inline pmd_t pmdp_flush_lazy(struct mm_struct *mm,
 	return old;
 }
 
-#ifdef CONFIG_PGSTE
-static int pmd_lookup(struct mm_struct *mm, unsigned long addr, pmd_t **pmdp)
-{
-	struct vm_area_struct *vma;
-	pgd_t *pgd;
-	p4d_t *p4d;
-	pud_t *pud;
-
-	/* We need a valid VMA, otherwise this is clearly a fault. */
-	vma = vma_lookup(mm, addr);
-	if (!vma)
-		return -EFAULT;
-
-	pgd = pgd_offset(mm, addr);
-	if (!pgd_present(*pgd))
-		return -ENOENT;
-
-	p4d = p4d_offset(pgd, addr);
-	if (!p4d_present(*p4d))
-		return -ENOENT;
-
-	pud = pud_offset(p4d, addr);
-	if (!pud_present(*pud))
-		return -ENOENT;
-
-	/* Large PUDs are not supported yet. */
-	if (pud_leaf(*pud))
-		return -EFAULT;
-
-	*pmdp = pmd_offset(pud, addr);
-	return 0;
-}
-#endif
-
 pmd_t pmdp_xchg_direct(struct mm_struct *mm, unsigned long addr,
 		       pmd_t *pmdp, pmd_t new)
 {
@@ -579,598 +363,3 @@ pgtable_t pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp)
 	return pgtable;
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
-
-#ifdef CONFIG_PGSTE
-void ptep_set_pte_at(struct mm_struct *mm, unsigned long addr,
-		     pte_t *ptep, pte_t entry)
-{
-	pgste_t pgste;
-
-	/* the mm_has_pgste() check is done in set_pte_at() */
-	preempt_disable();
-	pgste = pgste_get_lock(ptep);
-	pgste = clear_pgste_bit(pgste, _PGSTE_GPS_ZERO);
-	pgste_set_key(ptep, pgste, entry, mm);
-	pgste = pgste_set_pte(ptep, pgste, entry);
-	pgste_set_unlock(ptep, pgste);
-	preempt_enable();
-}
-
-void ptep_set_notify(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	pgste_t pgste;
-
-	preempt_disable();
-	pgste = pgste_get_lock(ptep);
-	pgste = set_pgste_bit(pgste, PGSTE_IN_BIT);
-	pgste_set_unlock(ptep, pgste);
-	preempt_enable();
-}
-
-/**
- * ptep_force_prot - change access rights of a locked pte
- * @mm: pointer to the process mm_struct
- * @addr: virtual address in the guest address space
- * @ptep: pointer to the page table entry
- * @prot: indicates guest access rights: PROT_NONE, PROT_READ or PROT_WRITE
- * @bit: pgste bit to set (e.g. for notification)
- *
- * Returns 0 if the access rights were changed and -EAGAIN if the current
- * and requested access rights are incompatible.
- */
-int ptep_force_prot(struct mm_struct *mm, unsigned long addr,
-		    pte_t *ptep, int prot, unsigned long bit)
-{
-	pte_t entry;
-	pgste_t pgste;
-	int pte_i, pte_p, nodat;
-
-	pgste = pgste_get_lock(ptep);
-	entry = *ptep;
-	/* Check pte entry after all locks have been acquired */
-	pte_i = pte_val(entry) & _PAGE_INVALID;
-	pte_p = pte_val(entry) & _PAGE_PROTECT;
-	if ((pte_i && (prot != PROT_NONE)) ||
-	    (pte_p && (prot & PROT_WRITE))) {
-		pgste_set_unlock(ptep, pgste);
-		return -EAGAIN;
-	}
-	/* Change access rights and set pgste bit */
-	nodat = !!(pgste_val(pgste) & _PGSTE_GPS_NODAT);
-	if (prot == PROT_NONE && !pte_i) {
-		ptep_flush_direct(mm, addr, ptep, nodat);
-		pgste = pgste_update_all(entry, pgste, mm);
-		entry = set_pte_bit(entry, __pgprot(_PAGE_INVALID));
-	}
-	if (prot == PROT_READ && !pte_p) {
-		ptep_flush_direct(mm, addr, ptep, nodat);
-		entry = clear_pte_bit(entry, __pgprot(_PAGE_INVALID));
-		entry = set_pte_bit(entry, __pgprot(_PAGE_PROTECT));
-	}
-	pgste = set_pgste_bit(pgste, bit);
-	pgste = pgste_set_pte(ptep, pgste, entry);
-	pgste_set_unlock(ptep, pgste);
-	return 0;
-}
-
-int ptep_shadow_pte(struct mm_struct *mm, unsigned long saddr,
-		    pte_t *sptep, pte_t *tptep, pte_t pte)
-{
-	pgste_t spgste, tpgste;
-	pte_t spte, tpte;
-	int rc = -EAGAIN;
-
-	if (!(pte_val(*tptep) & _PAGE_INVALID))
-		return 0;	/* already shadowed */
-	spgste = pgste_get_lock(sptep);
-	spte = *sptep;
-	if (!(pte_val(spte) & _PAGE_INVALID) &&
-	    !((pte_val(spte) & _PAGE_PROTECT) &&
-	      !(pte_val(pte) & _PAGE_PROTECT))) {
-		spgste = set_pgste_bit(spgste, PGSTE_VSIE_BIT);
-		tpgste = pgste_get_lock(tptep);
-		tpte = __pte((pte_val(spte) & PAGE_MASK) |
-			     (pte_val(pte) & _PAGE_PROTECT));
-		/* don't touch the storage key - it belongs to parent pgste */
-		tpgste = pgste_set_pte(tptep, tpgste, tpte);
-		pgste_set_unlock(tptep, tpgste);
-		rc = 1;
-	}
-	pgste_set_unlock(sptep, spgste);
-	return rc;
-}
-
-void ptep_unshadow_pte(struct mm_struct *mm, unsigned long saddr, pte_t *ptep)
-{
-	pgste_t pgste;
-	int nodat;
-
-	pgste = pgste_get_lock(ptep);
-	/* notifier is called by the caller */
-	nodat = !!(pgste_val(pgste) & _PGSTE_GPS_NODAT);
-	ptep_flush_direct(mm, saddr, ptep, nodat);
-	/* don't touch the storage key - it belongs to parent pgste */
-	pgste = pgste_set_pte(ptep, pgste, __pte(_PAGE_INVALID));
-	pgste_set_unlock(ptep, pgste);
-}
-
-static void ptep_zap_swap_entry(struct mm_struct *mm, swp_entry_t entry)
-{
-	if (!non_swap_entry(entry))
-		dec_mm_counter(mm, MM_SWAPENTS);
-	else if (is_migration_entry(entry)) {
-		struct folio *folio = pfn_swap_entry_folio(entry);
-
-		dec_mm_counter(mm, mm_counter(folio));
-	}
-	free_swap_and_cache(entry);
-}
-
-void ptep_zap_unused(struct mm_struct *mm, unsigned long addr,
-		     pte_t *ptep, int reset)
-{
-	unsigned long pgstev;
-	pgste_t pgste;
-	pte_t pte;
-
-	/* Zap unused and logically-zero pages */
-	preempt_disable();
-	pgste = pgste_get_lock(ptep);
-	pgstev = pgste_val(pgste);
-	pte = *ptep;
-	if (!reset && pte_swap(pte) &&
-	    ((pgstev & _PGSTE_GPS_USAGE_MASK) == _PGSTE_GPS_USAGE_UNUSED ||
-	     (pgstev & _PGSTE_GPS_ZERO))) {
-		ptep_zap_swap_entry(mm, pte_to_swp_entry(pte));
-		pte_clear(mm, addr, ptep);
-	}
-	if (reset)
-		pgste = clear_pgste_bit(pgste, _PGSTE_GPS_USAGE_MASK | _PGSTE_GPS_NODAT);
-	pgste_set_unlock(ptep, pgste);
-	preempt_enable();
-}
-
-void ptep_zap_key(struct mm_struct *mm, unsigned long addr, pte_t *ptep)
-{
-	unsigned long ptev;
-	pgste_t pgste;
-
-	/* Clear storage key ACC and F, but set R/C */
-	preempt_disable();
-	pgste = pgste_get_lock(ptep);
-	pgste = clear_pgste_bit(pgste, PGSTE_ACC_BITS | PGSTE_FP_BIT);
-	pgste = set_pgste_bit(pgste, PGSTE_GR_BIT | PGSTE_GC_BIT);
-	ptev = pte_val(*ptep);
-	if (!(ptev & _PAGE_INVALID) && (ptev & _PAGE_WRITE))
-		page_set_storage_key(ptev & PAGE_MASK, PAGE_DEFAULT_KEY, 0);
-	pgste_set_unlock(ptep, pgste);
-	preempt_enable();
-}
-
-/*
- * Test and reset if a guest page is dirty
- */
-bool ptep_test_and_clear_uc(struct mm_struct *mm, unsigned long addr,
-		       pte_t *ptep)
-{
-	pgste_t pgste;
-	pte_t pte;
-	bool dirty;
-	int nodat;
-
-	pgste = pgste_get_lock(ptep);
-	dirty = !!(pgste_val(pgste) & PGSTE_UC_BIT);
-	pgste = clear_pgste_bit(pgste, PGSTE_UC_BIT);
-	pte = *ptep;
-	if (dirty && (pte_val(pte) & _PAGE_PRESENT)) {
-		pgste = pgste_pte_notify(mm, addr, ptep, pgste);
-		nodat = !!(pgste_val(pgste) & _PGSTE_GPS_NODAT);
-		ptep_ipte_global(mm, addr, ptep, nodat);
-		if (machine_has_esop() || !(pte_val(pte) & _PAGE_WRITE))
-			pte = set_pte_bit(pte, __pgprot(_PAGE_PROTECT));
-		else
-			pte = set_pte_bit(pte, __pgprot(_PAGE_INVALID));
-		set_pte(ptep, pte);
-	}
-	pgste_set_unlock(ptep, pgste);
-	return dirty;
-}
-EXPORT_SYMBOL_GPL(ptep_test_and_clear_uc);
-
-int set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
-			  unsigned char key, bool nq)
-{
-	unsigned long keyul, paddr;
-	spinlock_t *ptl;
-	pgste_t old, new;
-	pmd_t *pmdp;
-	pte_t *ptep;
-
-	/*
-	 * If we don't have a PTE table and if there is no huge page mapped,
-	 * we can ignore attempts to set the key to 0, because it already is 0.
-	 */
-	switch (pmd_lookup(mm, addr, &pmdp)) {
-	case -ENOENT:
-		return key ? -EFAULT : 0;
-	case 0:
-		break;
-	default:
-		return -EFAULT;
-	}
-again:
-	ptl = pmd_lock(mm, pmdp);
-	if (!pmd_present(*pmdp)) {
-		spin_unlock(ptl);
-		return key ? -EFAULT : 0;
-	}
-
-	if (pmd_leaf(*pmdp)) {
-		paddr = pmd_val(*pmdp) & HPAGE_MASK;
-		paddr |= addr & ~HPAGE_MASK;
-		/*
-		 * Huge pmds need quiescing operations, they are
-		 * always mapped.
-		 */
-		page_set_storage_key(paddr, key, 1);
-		spin_unlock(ptl);
-		return 0;
-	}
-	spin_unlock(ptl);
-
-	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-	if (!ptep)
-		goto again;
-	new = old = pgste_get_lock(ptep);
-	new = clear_pgste_bit(new, PGSTE_GR_BIT | PGSTE_GC_BIT |
-				   PGSTE_ACC_BITS | PGSTE_FP_BIT);
-	keyul = (unsigned long) key;
-	new = set_pgste_bit(new, (keyul & (_PAGE_CHANGED | _PAGE_REFERENCED)) << 48);
-	new = set_pgste_bit(new, (keyul & (_PAGE_ACC_BITS | _PAGE_FP_BIT)) << 56);
-	if (!(pte_val(*ptep) & _PAGE_INVALID)) {
-		unsigned long bits, skey;
-
-		paddr = pte_val(*ptep) & PAGE_MASK;
-		skey = (unsigned long) page_get_storage_key(paddr);
-		bits = skey & (_PAGE_CHANGED | _PAGE_REFERENCED);
-		skey = key & (_PAGE_ACC_BITS | _PAGE_FP_BIT);
-		/* Set storage key ACC and FP */
-		page_set_storage_key(paddr, skey, !nq);
-		/* Merge host changed & referenced into pgste  */
-		new = set_pgste_bit(new, bits << 52);
-	}
-	/* changing the guest storage key is considered a change of the page */
-	if ((pgste_val(new) ^ pgste_val(old)) &
-	    (PGSTE_ACC_BITS | PGSTE_FP_BIT | PGSTE_GR_BIT | PGSTE_GC_BIT))
-		new = set_pgste_bit(new, PGSTE_UC_BIT);
-
-	pgste_set_unlock(ptep, new);
-	pte_unmap_unlock(ptep, ptl);
-	return 0;
-}
-EXPORT_SYMBOL(set_guest_storage_key);
-
-/*
- * Conditionally set a guest storage key (handling csske).
- * oldkey will be updated when either mr or mc is set and a pointer is given.
- *
- * Returns 0 if a guests storage key update wasn't necessary, 1 if the guest
- * storage key was updated and -EFAULT on access errors.
- */
-int cond_set_guest_storage_key(struct mm_struct *mm, unsigned long addr,
-			       unsigned char key, unsigned char *oldkey,
-			       bool nq, bool mr, bool mc)
-{
-	unsigned char tmp, mask = _PAGE_ACC_BITS | _PAGE_FP_BIT;
-	int rc;
-
-	/* we can drop the pgste lock between getting and setting the key */
-	if (mr | mc) {
-		rc = get_guest_storage_key(current->mm, addr, &tmp);
-		if (rc)
-			return rc;
-		if (oldkey)
-			*oldkey = tmp;
-		if (!mr)
-			mask |= _PAGE_REFERENCED;
-		if (!mc)
-			mask |= _PAGE_CHANGED;
-		if (!((tmp ^ key) & mask))
-			return 0;
-	}
-	rc = set_guest_storage_key(current->mm, addr, key, nq);
-	return rc < 0 ? rc : 1;
-}
-EXPORT_SYMBOL(cond_set_guest_storage_key);
-
-/*
- * Reset a guest reference bit (rrbe), returning the reference and changed bit.
- *
- * Returns < 0 in case of error, otherwise the cc to be reported to the guest.
- */
-int reset_guest_reference_bit(struct mm_struct *mm, unsigned long addr)
-{
-	spinlock_t *ptl;
-	unsigned long paddr;
-	pgste_t old, new;
-	pmd_t *pmdp;
-	pte_t *ptep;
-	int cc = 0;
-
-	/*
-	 * If we don't have a PTE table and if there is no huge page mapped,
-	 * the storage key is 0 and there is nothing for us to do.
-	 */
-	switch (pmd_lookup(mm, addr, &pmdp)) {
-	case -ENOENT:
-		return 0;
-	case 0:
-		break;
-	default:
-		return -EFAULT;
-	}
-again:
-	ptl = pmd_lock(mm, pmdp);
-	if (!pmd_present(*pmdp)) {
-		spin_unlock(ptl);
-		return 0;
-	}
-
-	if (pmd_leaf(*pmdp)) {
-		paddr = pmd_val(*pmdp) & HPAGE_MASK;
-		paddr |= addr & ~HPAGE_MASK;
-		cc = page_reset_referenced(paddr);
-		spin_unlock(ptl);
-		return cc;
-	}
-	spin_unlock(ptl);
-
-	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-	if (!ptep)
-		goto again;
-	new = old = pgste_get_lock(ptep);
-	/* Reset guest reference bit only */
-	new = clear_pgste_bit(new, PGSTE_GR_BIT);
-
-	if (!(pte_val(*ptep) & _PAGE_INVALID)) {
-		paddr = pte_val(*ptep) & PAGE_MASK;
-		cc = page_reset_referenced(paddr);
-		/* Merge real referenced bit into host-set */
-		new = set_pgste_bit(new, ((unsigned long)cc << 53) & PGSTE_HR_BIT);
-	}
-	/* Reflect guest's logical view, not physical */
-	cc |= (pgste_val(old) & (PGSTE_GR_BIT | PGSTE_GC_BIT)) >> 49;
-	/* Changing the guest storage key is considered a change of the page */
-	if ((pgste_val(new) ^ pgste_val(old)) & PGSTE_GR_BIT)
-		new = set_pgste_bit(new, PGSTE_UC_BIT);
-
-	pgste_set_unlock(ptep, new);
-	pte_unmap_unlock(ptep, ptl);
-	return cc;
-}
-EXPORT_SYMBOL(reset_guest_reference_bit);
-
-int get_guest_storage_key(struct mm_struct *mm, unsigned long addr,
-			  unsigned char *key)
-{
-	unsigned long paddr;
-	spinlock_t *ptl;
-	pgste_t pgste;
-	pmd_t *pmdp;
-	pte_t *ptep;
-
-	/*
-	 * If we don't have a PTE table and if there is no huge page mapped,
-	 * the storage key is 0.
-	 */
-	*key = 0;
-
-	switch (pmd_lookup(mm, addr, &pmdp)) {
-	case -ENOENT:
-		return 0;
-	case 0:
-		break;
-	default:
-		return -EFAULT;
-	}
-again:
-	ptl = pmd_lock(mm, pmdp);
-	if (!pmd_present(*pmdp)) {
-		spin_unlock(ptl);
-		return 0;
-	}
-
-	if (pmd_leaf(*pmdp)) {
-		paddr = pmd_val(*pmdp) & HPAGE_MASK;
-		paddr |= addr & ~HPAGE_MASK;
-		*key = page_get_storage_key(paddr);
-		spin_unlock(ptl);
-		return 0;
-	}
-	spin_unlock(ptl);
-
-	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
-	if (!ptep)
-		goto again;
-	pgste = pgste_get_lock(ptep);
-	*key = (pgste_val(pgste) & (PGSTE_ACC_BITS | PGSTE_FP_BIT)) >> 56;
-	paddr = pte_val(*ptep) & PAGE_MASK;
-	if (!(pte_val(*ptep) & _PAGE_INVALID))
-		*key = page_get_storage_key(paddr);
-	/* Reflect guest's logical view, not physical */
-	*key |= (pgste_val(pgste) & (PGSTE_GR_BIT | PGSTE_GC_BIT)) >> 48;
-	pgste_set_unlock(ptep, pgste);
-	pte_unmap_unlock(ptep, ptl);
-	return 0;
-}
-EXPORT_SYMBOL(get_guest_storage_key);
-
-/**
- * pgste_perform_essa - perform ESSA actions on the PGSTE.
- * @mm: the memory context. It must have PGSTEs, no check is performed here!
- * @hva: the host virtual address of the page whose PGSTE is to be processed
- * @orc: the specific action to perform, see the ESSA_SET_* macros.
- * @oldpte: the PTE will be saved there if the pointer is not NULL.
- * @oldpgste: the old PGSTE will be saved there if the pointer is not NULL.
- *
- * Return: 1 if the page is to be added to the CBRL, otherwise 0,
- *	   or < 0 in case of error. -EINVAL is returned for invalid values
- *	   of orc, -EFAULT for invalid addresses.
- */
-int pgste_perform_essa(struct mm_struct *mm, unsigned long hva, int orc,
-			unsigned long *oldpte, unsigned long *oldpgste)
-{
-	struct vm_area_struct *vma;
-	unsigned long pgstev;
-	spinlock_t *ptl;
-	pgste_t pgste;
-	pte_t *ptep;
-	int res = 0;
-
-	WARN_ON_ONCE(orc > ESSA_MAX);
-	if (unlikely(orc > ESSA_MAX))
-		return -EINVAL;
-
-	vma = vma_lookup(mm, hva);
-	if (!vma || is_vm_hugetlb_page(vma))
-		return -EFAULT;
-	ptep = get_locked_pte(mm, hva, &ptl);
-	if (unlikely(!ptep))
-		return -EFAULT;
-	pgste = pgste_get_lock(ptep);
-	pgstev = pgste_val(pgste);
-	if (oldpte)
-		*oldpte = pte_val(*ptep);
-	if (oldpgste)
-		*oldpgste = pgstev;
-
-	switch (orc) {
-	case ESSA_GET_STATE:
-		break;
-	case ESSA_SET_STABLE:
-		pgstev &= ~(_PGSTE_GPS_USAGE_MASK | _PGSTE_GPS_NODAT);
-		pgstev |= _PGSTE_GPS_USAGE_STABLE;
-		break;
-	case ESSA_SET_UNUSED:
-		pgstev &= ~_PGSTE_GPS_USAGE_MASK;
-		pgstev |= _PGSTE_GPS_USAGE_UNUSED;
-		if (pte_val(*ptep) & _PAGE_INVALID)
-			res = 1;
-		break;
-	case ESSA_SET_VOLATILE:
-		pgstev &= ~_PGSTE_GPS_USAGE_MASK;
-		pgstev |= _PGSTE_GPS_USAGE_VOLATILE;
-		if (pte_val(*ptep) & _PAGE_INVALID)
-			res = 1;
-		break;
-	case ESSA_SET_POT_VOLATILE:
-		pgstev &= ~_PGSTE_GPS_USAGE_MASK;
-		if (!(pte_val(*ptep) & _PAGE_INVALID)) {
-			pgstev |= _PGSTE_GPS_USAGE_POT_VOLATILE;
-			break;
-		}
-		if (pgstev & _PGSTE_GPS_ZERO) {
-			pgstev |= _PGSTE_GPS_USAGE_VOLATILE;
-			break;
-		}
-		if (!(pgstev & PGSTE_GC_BIT)) {
-			pgstev |= _PGSTE_GPS_USAGE_VOLATILE;
-			res = 1;
-			break;
-		}
-		break;
-	case ESSA_SET_STABLE_RESIDENT:
-		pgstev &= ~_PGSTE_GPS_USAGE_MASK;
-		pgstev |= _PGSTE_GPS_USAGE_STABLE;
-		/*
-		 * Since the resident state can go away any time after this
-		 * call, we will not make this page resident. We can revisit
-		 * this decision if a guest will ever start using this.
-		 */
-		break;
-	case ESSA_SET_STABLE_IF_RESIDENT:
-		if (!(pte_val(*ptep) & _PAGE_INVALID)) {
-			pgstev &= ~_PGSTE_GPS_USAGE_MASK;
-			pgstev |= _PGSTE_GPS_USAGE_STABLE;
-		}
-		break;
-	case ESSA_SET_STABLE_NODAT:
-		pgstev &= ~_PGSTE_GPS_USAGE_MASK;
-		pgstev |= _PGSTE_GPS_USAGE_STABLE | _PGSTE_GPS_NODAT;
-		break;
-	default:
-		/* we should never get here! */
-		break;
-	}
-	/* If we are discarding a page, set it to logical zero */
-	if (res)
-		pgstev |= _PGSTE_GPS_ZERO;
-
-	pgste = __pgste(pgstev);
-	pgste_set_unlock(ptep, pgste);
-	pte_unmap_unlock(ptep, ptl);
-	return res;
-}
-EXPORT_SYMBOL(pgste_perform_essa);
-
-/**
- * set_pgste_bits - set specific PGSTE bits.
- * @mm: the memory context. It must have PGSTEs, no check is performed here!
- * @hva: the host virtual address of the page whose PGSTE is to be processed
- * @bits: a bitmask representing the bits that will be touched
- * @value: the values of the bits to be written. Only the bits in the mask
- *	   will be written.
- *
- * Return: 0 on success, < 0 in case of error.
- */
-int set_pgste_bits(struct mm_struct *mm, unsigned long hva,
-			unsigned long bits, unsigned long value)
-{
-	struct vm_area_struct *vma;
-	spinlock_t *ptl;
-	pgste_t new;
-	pte_t *ptep;
-
-	vma = vma_lookup(mm, hva);
-	if (!vma || is_vm_hugetlb_page(vma))
-		return -EFAULT;
-	ptep = get_locked_pte(mm, hva, &ptl);
-	if (unlikely(!ptep))
-		return -EFAULT;
-	new = pgste_get_lock(ptep);
-
-	new = clear_pgste_bit(new, bits);
-	new = set_pgste_bit(new, value & bits);
-
-	pgste_set_unlock(ptep, new);
-	pte_unmap_unlock(ptep, ptl);
-	return 0;
-}
-EXPORT_SYMBOL(set_pgste_bits);
-
-/**
- * get_pgste - get the current PGSTE for the given address.
- * @mm: the memory context. It must have PGSTEs, no check is performed here!
- * @hva: the host virtual address of the page whose PGSTE is to be processed
- * @pgstep: will be written with the current PGSTE for the given address.
- *
- * Return: 0 on success, < 0 in case of error.
- */
-int get_pgste(struct mm_struct *mm, unsigned long hva, unsigned long *pgstep)
-{
-	struct vm_area_struct *vma;
-	spinlock_t *ptl;
-	pte_t *ptep;
-
-	vma = vma_lookup(mm, hva);
-	if (!vma || is_vm_hugetlb_page(vma))
-		return -EFAULT;
-	ptep = get_locked_pte(mm, hva, &ptl);
-	if (unlikely(!ptep))
-		return -EFAULT;
-	*pgstep = pgste_val(pgste_get(ptep));
-	pte_unmap_unlock(ptep, ptl);
-	return 0;
-}
-EXPORT_SYMBOL(get_pgste);
-#endif
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..0a17225ffe41 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -342,15 +342,6 @@ int hugepage_madvise(struct vm_area_struct *vma,
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
-#ifdef CONFIG_S390
-		/*
-		 * qemu blindly sets MADV_HUGEPAGE on all allocations, but s390
-		 * can't handle this properly after s390_enable_sie, so we simply
-		 * ignore the madvise to prevent qemu from causing a SIGSEGV.
-		 */
-		if (mm_has_pgste(vma->vm_mm))
-			return 0;
-#endif
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		/*
-- 
2.51.1


