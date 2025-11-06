Return-Path: <kvm+bounces-62192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F5C8C3C4CF
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:14:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53ACE189DAA3
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23AA434EF0C;
	Thu,  6 Nov 2025 16:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BiGm6LcV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5D7624DCE2;
	Thu,  6 Nov 2025 16:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445488; cv=none; b=hLDGJPtPolvV3P5nZzJC7uUWmGeMUvDG/RX0cag4FHVYKEglJ/JqNk8MMQSV3rWCX5yNvcnVN35MWMo9Y7bMsej+FsEJ+E6uIXTH8eYyc4UcTgiDLtx56BoPYoKjgF+JyI1AnN420yknu8piMLvYMHS2VZyM9quoHqTYpHpuGhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445488; c=relaxed/simple;
	bh=OZH5P4dxDFd2WJGsmXMg0xdDr27PQwA0/s38rjY/6a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlR+AkZxt3aw8VPtsQ+gjNaY+52fQsXHLPqAmNwKqqxkWBNYiIHu00D/dMFf9/gjOU2jtbtNWAytfWTBBjx1syYPaz5VQy061EL8My9OShmvYxAAV6gLHsDzdGnyFQR2ir1WWbnQHMzITZHVUfZP6pCm9BZEWYlp7V14z201u30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BiGm6LcV; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6DkmZE016813;
	Thu, 6 Nov 2025 16:11:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=VY36X1W5L1BhepUXV
	xARtDgUjpKbOBVpBJSoVC491HM=; b=BiGm6LcVi8rJ/RUbGmGlLaJ5k4+LD8HTz
	M8Fv2IpBsOIe4EW/unHEAFmzkbm7Zsj3hv7mGKXGAnVm1BcZKmXOmOKgmKHQLASf
	tkvqI8CmLcsNPR41OFgolV+hd014jhTgGZdM9CrYFqnpOxwAIpwdNJkzVD5TewwT
	g4rAmdTW/HLnli8Indp8PnhOjCRg0BaypnSsJeIYBKBWrF96crBhq7TBtOgtJnJu
	uIO+hB5pJoHRqtj7ouVA/jL/H5OwOW8shIOAbYrT0I0azFFaSSt6XGoXUMG0OCkS
	zcC707YiiME3U0NP2n1XlrYJqUQSY57SlPzUXdoSCeOEJSxylJRrw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59v276a9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:24 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6FSEub009863;
	Thu, 6 Nov 2025 16:11:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5x1kp93b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:23 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBJ6K43712858
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D450520040;
	Thu,  6 Nov 2025 16:11:19 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E1CF20043;
	Thu,  6 Nov 2025 16:11:19 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:19 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 04/23] KVM: s390: Add gmap_helper_set_unused()
Date: Thu,  6 Nov 2025 17:10:58 +0100
Message-ID: <20251106161117.350395-5-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251106161117.350395-1-imbrenda@linux.ibm.com>
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CpI2Elds4N66Js7fjMgzKy_kQD3a_LXF
X-Proofpoint-ORIG-GUID: CpI2Elds4N66Js7fjMgzKy_kQD3a_LXF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX2CwTr+LdQjvh
 yxd522a04RY8ix/Bwq+0PuA5QEqkrBLTn1TPXxi63HMvmAd9K0fDNbutpMQvDZUCcV/QbaY9KDa
 iTxXc6+L3nm4q5Cg9XeEKKv+g7uObwRIto/Z2+irBRxd2ZdEDzLfFkUIL4RUqgqWqfq3Fs08h7u
 0w5NQ2jsZtXUEhq2kgXRejhSkDIsRK6AGTTzjpq7upzC9KwPDavweGEbVJXtAY+Zv6PwbRRKq/J
 qWzTPWJHXnj3ySSSt5gJr/DQ8xI0YHKZnXhlBUwzpnIpQr3ODmxluiA23kROaqy5h9GirTFUics
 p3RsO2T5LFZ7b9CmJajEeprGGHscNYbooNBqpSFpWPaHCs/+YF17ECdCsofpmvwMHnv8C0p+ZGP
 3yKbg3KHpfw0bEgiRFv46pONSGy7lg==
X-Authority-Analysis: v=2.4 cv=H8HWAuYi c=1 sm=1 tr=0 ts=690cc8ac cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=F2Av9RbSm_i__n-hslAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

Add gmap_helper_set_unused() to mark userspace ptes as unused.

Core mm code will use that information to discard unused pages instead
of attempting to swap them.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
---
 arch/s390/include/asm/gmap_helpers.h |  1 +
 arch/s390/mm/gmap_helpers.c          | 79 ++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/arch/s390/include/asm/gmap_helpers.h b/arch/s390/include/asm/gmap_helpers.h
index 5356446a61c4..2d3ae421077e 100644
--- a/arch/s390/include/asm/gmap_helpers.h
+++ b/arch/s390/include/asm/gmap_helpers.h
@@ -11,5 +11,6 @@
 void gmap_helper_zap_one_page(struct mm_struct *mm, unsigned long vmaddr);
 void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned long end);
 int gmap_helper_disable_cow_sharing(void);
+void gmap_helper_try_set_pte_unused(struct mm_struct *mm, unsigned long vmaddr);
 
 #endif /* _ASM_S390_GMAP_HELPERS_H */
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index e14a63119e30..dca783859a73 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -124,6 +124,85 @@ void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned lo
 }
 EXPORT_SYMBOL_GPL(gmap_helper_discard);
 
+/**
+ * gmap_helper_try_set_pte_unused() - mark a pte entry as unused
+ * @mm: the mm
+ * @vmaddr: the userspace address whose pte is to be marked
+ *
+ * Mark the pte corresponding the given address as unused. This will cause
+ * core mm code to just drop this page instead of swapping it.
+ *
+ * This function needs to be called with interrupts disabled (for example
+ * while holding a spinlock), or while holding the mmap lock. Normally this
+ * function is called as a result of an unmap operation, and thus KVM common
+ * code will already hold kvm->mmu_lock in write mode.
+ *
+ * Context: Needs to be called while holding the mmap lock or with interrupts
+ *          disabled.
+ */
+void gmap_helper_try_set_pte_unused(struct mm_struct *mm, unsigned long vmaddr)
+{
+	pmd_t *pmdp, pmd, pmdval;
+	pud_t *pudp, pud;
+	p4d_t *p4dp, p4d;
+	pgd_t *pgdp, pgd;
+	spinlock_t *ptl;	/* Lock for the host (userspace) page table */
+	pte_t *ptep;
+
+	pgdp = pgd_offset(mm, vmaddr);
+	pgd = pgdp_get(pgdp);
+	if (pgd_none(pgd) || !pgd_present(pgd))
+		return;
+
+	p4dp = p4d_offset(pgdp, vmaddr);
+	p4d = p4dp_get(p4dp);
+	if (p4d_none(p4d) || !p4d_present(p4d))
+		return;
+
+	pudp = pud_offset(p4dp, vmaddr);
+	pud = pudp_get(pudp);
+	if (pud_none(pud) || pud_leaf(pud) || !pud_present(pud))
+		return;
+
+	pmdp = pmd_offset(pudp, vmaddr);
+	pmd = pmdp_get_lockless(pmdp);
+	if (pmd_none(pmd) || pmd_leaf(pmd) || !pmd_present(pmd))
+		return;
+
+	ptep = pte_offset_map_rw_nolock(mm, pmdp, vmaddr, &pmdval, &ptl);
+	if (!ptep)
+		return;
+
+	/*
+	 * Several paths exists that takes the ptl lock and then call the
+	 * mmu_notifier, which takes the mmu_lock. The unmap path, instead,
+	 * takes the mmu_lock in write mode first, and then potentially
+	 * calls this function, which takes the ptl lock. This can lead to a
+	 * deadlock.
+	 * The unused page mechanism is only an optimization, if the
+	 * _PAGE_UNUSED bit is not set, the unused page is swapped as normal
+	 * instead of being discarded.
+	 * If the lock is contended the bit is not set and the deadlock is
+	 * avoided.
+	 */
+	if (spin_trylock(ptl)) {
+		/*
+		 * Make sure the pte we are touching is still the correct
+		 * one. In theory this check should not be needed, but
+		 * better safe than sorry.
+		 * Disabling interrupts or holding the mmap lock is enough to
+		 * guarantee that no concurrent updates to the page tables
+		 * are possible.
+		 */
+		if (likely(pmd_same(pmdval, pmdp_get_lockless(pmdp))))
+			__atomic64_or(_PAGE_UNUSED, (long *)ptep);
+		spin_unlock(ptl);
+	}
+
+	pte_unmap(ptep);
+}
+EXPORT_SYMBOL_GPL(gmap_helper_try_set_pte_unused);
+
 static int find_zeropage_pte_entry(pte_t *pte, unsigned long addr,
 				   unsigned long end, struct mm_walk *walk)
 {
-- 
2.51.1


