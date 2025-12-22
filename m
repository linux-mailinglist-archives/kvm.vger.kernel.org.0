Return-Path: <kvm+bounces-66487-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AFFCACD6D27
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9520230CF509
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:22:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9319633A00F;
	Mon, 22 Dec 2025 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="co7TePSq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CA53358C7;
	Mon, 22 Dec 2025 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422251; cv=none; b=m2R2TtAJog/EULjyV8Es3NdIPhp8+0Jk8TZUnCfLtZKPX/byeUR9eTYIwPAVrYXcX6EkxUdccvHThzSbjFFPMpIdmMgu5vnKVbZ4446oqs/WHh+kM1tigX6uEVOioALXcIrAgyp+1a8uRmEumJYxtC7Vwri3AjsiuJHMZVPCBCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422251; c=relaxed/simple;
	bh=wZIM7tTYqqSB7gE+7VmQ8HvdCuIZC1gLeC4DpqWpcvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aD6r8uj4HRnUJdbU+cjO1JvF+x9VW9EIvyJW7bDklA4dxG/Hv2oCNA29cFCJmq1HrI9KDOEYIacqp/xZP1fZO25joMQRD+YYifJX5rb4Hq7nMbpunug5150aRJY3J3DP7sQkpOt6Jda/tyMCLJAniBUD1qTnnea3wtR1aUfgk7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=co7TePSq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMGG7bP007593;
	Mon, 22 Dec 2025 16:50:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CE4JpDSEghk1nwVFo
	3HYe4mFC7f75/s97B715bNStdc=; b=co7TePSqjA6sbiYkSIrjESWYN7+IpJ7jB
	z6eOttgpeWxxUiqmw0nZNzpbUb2zM6A/U8hM7BBgVwIuoeMAe1bW26f4dkTQQM3z
	j2strqIcAGSZqf/B6IJtzCb5PV2jpZfMDKMGWTE+YV/a4OpskRnvdwNvfVn9obG3
	a3v2/OkQSCknzcjW3B4yNezlfOcnNSa3u8ntp2yv3dSSzMBkIkVFeAzAQbOWJG71
	tiF21cddvv02tXZrVuC8IPIExu0JFFXJQqW+4onkSEO7g0egBjFidYRUB/2W2N3l
	rVzyO/pFtwrwlH8JO7dg9osyZVZDGeYaBmu6N4TNPysnjhw/sUPbw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5kh49693-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:46 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BME7hoH027014;
	Mon, 22 Dec 2025 16:50:46 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b6r934860-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:45 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGofsF51184118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:41 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C83B720043;
	Mon, 22 Dec 2025 16:50:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2895420040;
	Mon, 22 Dec 2025 16:50:40 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:40 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 05/28] KVM: s390: Add gmap_helper_set_unused()
Date: Mon, 22 Dec 2025 17:50:10 +0100
Message-ID: <20251222165033.162329-6-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251222165033.162329-1-imbrenda@linux.ibm.com>
References: <20251222165033.162329-1-imbrenda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=bulBxUai c=1 sm=1 tr=0 ts=694976e6 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=F2Av9RbSm_i__n-hslAA:9
X-Proofpoint-ORIG-GUID: A8wfDoF-JV2lBbZPqcutWcJyRttNmwKA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX18FoV4JY51A6
 /cvZVJsZMM+LX7Cfd/KP5myFPm4y74o73//LT42wThJvOJLCI1nm8sGQfGk66EXp3YkizQ279Gj
 VwBubpxiNIPy/B0aHvw3NXj3l/sJycQOqL3fYAaaTrogSyPQHdD3X80WOQDM7IOeJ9fyENMpEL4
 GIalxya+COy4QDHBIWy1llRlFrMd/gwWKGn2wsTluolJnkKCSD2079gz75XqUZQdFYSn15ovBT2
 XrellpggvbL+IyTGcRKVvKIAsXT5EOIL0g5GSUlZLrugldYodrbHrjmAbCQ0gbc2HWa1hsqM+RE
 x1QRtzxCEiz0x7bmQAwl0z2P5Upmq8CgjW+5CHF8wTNj5foDzvLo3xecgIAPUvir0F5MGF19nA9
 WH+MidIRZYZSq/KS93GqK3NJLpyV8n0uzyh6Fygppv77JxsRK76NQosDNl5s2rRCgps0DSrzVxm
 13lyBM0Q36+DHXN+uIw==
X-Proofpoint-GUID: A8wfDoF-JV2lBbZPqcutWcJyRttNmwKA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2512220154

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
index 4fba13675950..4864cb35fc25 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -129,6 +129,85 @@ void gmap_helper_discard(struct mm_struct *mm, unsigned long vmaddr, unsigned lo
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
2.52.0


