Return-Path: <kvm+bounces-64357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE74C804C3
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:57:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 357F3343746
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81AAA3016EC;
	Mon, 24 Nov 2025 11:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eZWg5AEx"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AE1E3002B9;
	Mon, 24 Nov 2025 11:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985373; cv=none; b=a+9YxixuHsCGB5XD3+u8MuEbvJzXm3yLk3VpLUObt+/umEOkiuw4t+q4Bez+E1HomZ2HxusbVaau3DhTE7vqPXxOQ9dq8zInvcQ3d640EV5DXrL/oyc2ilCFwpCbLKHXKzDG7RiHBvnj1KN6DNqy0tK52xEKd3UNMYKYtMebPSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985373; c=relaxed/simple;
	bh=f4WlxBljOVtmnwlVgMtzL1RlxFr/CaVwBAvBr7+4HAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Raf8XIpN8n77KsP/MTct3kZL0H8Or4HpwNV/YDd2uT3uM3LqdAyF/OOOnumsPWAmZcjKYkH+9P0bxEwYg2lHIxFlMWCbYBTerHHJY/PyAwyq0PCfjweAzX7ox/JwUuVXK9dQs58IxeJpgmQ9svf/3d/o06+mFUxJKeWaijGLFw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eZWg5AEx; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ANMPn51005274;
	Mon, 24 Nov 2025 11:56:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=aneBqESSUOFJoQfix
	DHvr/+qYDTdya7WXTYhXldWWtY=; b=eZWg5AExf0u8ZEdX6vtZ9V+U+755Ie3iJ
	s+7/vXruCWHLHKqVeKK1HXFJ+Yr2Mh+h5t1Saxp54SOvgAslJUc6DSZS2RQQpIry
	nEqbfoNZCte3iwhajBUlpURfHmc6puXlAFu1azXaOPxII3/Tl7XT5vSkxqtMNvbt
	/6Tf1yCeQoYU4OgpW5OknFHne3+iJGeWduIrQ1TPaLgVq/rV39hxoDa6H2bA0uFu
	oNmNMJoIDEQRIa+s8u7uK/SpOkchvS4w/sMURBEZ2kCuun8jfO67QMiiESwR8i/U
	T4AhnFbAQHl7GgU+CuyF989svl+vBhLSojCGkF269ncMfjQsVSRlA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kpqnqy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:09 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO9kmp2030842;
	Mon, 24 Nov 2025 11:56:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akqgs5w64-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:08 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBu4em33686006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 951AF2004B;
	Mon, 24 Nov 2025 11:56:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1482520040;
	Mon, 24 Nov 2025 11:56:03 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:02 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 04/23] KVM: s390: Add gmap_helper_set_unused()
Date: Mon, 24 Nov 2025 12:55:35 +0100
Message-ID: <20251124115554.27049-5-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfX5bv+PbubAu3y
 9fIfR7xKJUYURCwWMuZiieFgE6JBZEteyLh84j+6Euo9gRSRANu3K+DFRZ0V1+4lmNZpw2MV27B
 FTHRYbgdTRmVXivh2yQKYMO8RwUNvtnKqcSO9rpeFW4JrGvhkR8HAaPIfQ/90/gUf3ejad+l5/b
 fKEr4pt9KVkbNBQSr6Yq1lQOmIk2owSGOTlAagu6NehqouTYbtEIxs6gufhTiGemVgo+n4h/n0Q
 ki1/wRRBNp1jfdoj1vN+ZsW30Rc0/PG775ZpxG9m+6msEws0bMD1wu/w96gpERhhwxS+s17UFG4
 fNvsZ6t2wpSiWdwG35Afztkn1yZ5BBDTdYZ7oC3pMDN+kaIM1OvFiKbB+avS6ssrSwGEcASa/lM
 eBmwkZke4cavQic/afbQ3MjK68zrQw==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=692447d9 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=F2Av9RbSm_i__n-hslAA:9
X-Proofpoint-GUID: vhlfCORu8n9EI8i-eFxqQ-0iIycYlTkU
X-Proofpoint-ORIG-GUID: vhlfCORu8n9EI8i-eFxqQ-0iIycYlTkU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

Add gmap_helper_set_unused() to mark userspace ptes as unused.

Core mm code will use that information to discard unused pages instead
of attempting to swap them.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Tested-by: Nico Boehr <nrb@linux.ibm.com>
Acked-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
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


