Return-Path: <kvm+bounces-66495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 64C85CD6D1B
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4CF6630BF0CA
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:22:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3096C34252F;
	Mon, 22 Dec 2025 16:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lLwzAL83"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97D4D341AB1;
	Mon, 22 Dec 2025 16:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422265; cv=none; b=EncK/G0NyyRqhyHdbvXYKw0xThjhqRTByMrUMGEYXlc7bc6zzTs889sIYV+4994pBb0hqhtjmZB+kYfVB3lInTVYqBT1kbZd3BopGi/ZSEwzUC8vomVjb8FXzPGUwvXU2B1SPA1/AtEWWTqOiXdX7kMhARBHJY4vkxd+VVhbCdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422265; c=relaxed/simple;
	bh=X2TJVC2pFsJBNiUDyEEdwK8qIoifTxXHQZk0Ly1TXR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elIDoxcD6i7bQ40BWw8yPpkZsGlwCg8TqvNX4SzzjjxlO2hsLAjXZijgUjtYDxbRsoxmjYcbkMUv3H+PlW/CgEs5kj+tMaI5oPxawBUA8gUXEz6Bls6/SroEFJJdhYOOzWYNbxqQUzlhphLrHk6vSNq+FSPcCouh7PYeVawFYgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lLwzAL83; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMFmoUG028485;
	Mon, 22 Dec 2025 16:50:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Giij1mw98ZfVYgxs9
	QmMMATXaIoF0clrpmC5B56yKYM=; b=lLwzAL83Y6PXVZqA5oyInWDstvHZFm4+q
	V42q9Q9L1wcJPnRJs05fTOaUJ7iLllFqRAkFI3F1Em9wWq7+uAkaXIH4ZlSg/GgF
	gCcJ+0KzxX1SZKaZR69BDB/w+ybKq6WTfhkDWZC2unWEL/JN2FNiPO4432bVMBkS
	d4ESxhBxyIcxSM7GCaf5UztKi6C0tl3Pzr24Ug8Zq81WxX+gjIraYOGdpCfqxdy4
	Z2zxKDs2HlkZZtOhrfPju7oKl1ZLNmr9mzzg/wg9m7r+DLnp+VTX+DN6jk6CL+5i
	ca/gCGk2QPSnZ86CwkcuRWZBUN4iwNH2oynItqNTAX1s1X792MRDw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ka399g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:59 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMFeVx5030236;
	Mon, 22 Dec 2025 16:50:58 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b66gxq973-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:50:58 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGosYK25100984
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FB6E20040;
	Mon, 22 Dec 2025 16:50:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DC03720043;
	Mon, 22 Dec 2025 16:50:52 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:52 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 14/28] KVM: s390: KVM page table management functions: clear and replace
Date: Mon, 22 Dec 2025 17:50:19 +0100
Message-ID: <20251222165033.162329-15-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: DCgaGH-PWnNhBf5YB_9QRoNjze1e6Z0I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX9MIYhYSlSzPK
 E8nqJ9CBcgBd5J8dqlgauzXxkNzB37ZHqaIckXfA7rqh+F/ZVRUZnSv+LHVwSVqo5L1TSq+52n3
 GdzeTkVPPubIv6I4lQdgUBglgXCVt2U+LLQVnJomk2ivCDhK7eG7BDk3XtDExCsHZbsKeSK+2VB
 T48MgWKtA/Y32VeF7AmQ/GaLgVtSiFDUjzKcnmMnWlVzTWCmEB5bdNQzARGVEhhaKJmyrsUIJJA
 8Uj9e6tP2ZcwWkQfusNs523JuF1Lg+RH0OvDz5Yp1UDh9TF2Ry8MXooMoiBVHapL9RHJ34FeHpG
 eCn68tvpkfIs+21R/FrwA5DZAbP9NP02FxlHZtumGJks0UOgOic6PanxyhV7666DUf569cPc01A
 bW9GcYRN2Q5SuqRqVycXX5MvMt3iQ0fTl+JgYOQkPsI/9TmcyFpwVfkduDjD6XKZ5rS7gFtVk2f
 TghzvgQTfMRz4fPf8nA==
X-Proofpoint-ORIG-GUID: DCgaGH-PWnNhBf5YB_9QRoNjze1e6Z0I
X-Authority-Analysis: v=2.4 cv=dqHWylg4 c=1 sm=1 tr=0 ts=694976f3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=cTj5uL8xXfUXbJxEK6wA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2512220154

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to clear, replace or exchange DAT table
entries.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 118 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  40 +++++++++++++++
 2 files changed, 158 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index c324a27f379f..a9d5b49ac411 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -101,3 +101,121 @@ void dat_free_level(struct crst_table *table, bool owns_ptes)
 	}
 	dat_free_crst(table);
 }
+
+/**
+ * dat_crstep_xchg - exchange a gmap CRSTE with another
+ * @crstep: pointer to the CRST entry
+ * @new: replacement entry
+ * @gfn: the affected guest address
+ * @asce: the ASCE of the address space
+ *
+ * Context: This function is assumed to be called with kvm->mmu_lock held.
+ */
+void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce)
+{
+	if (crstep->h.i) {
+		WRITE_ONCE(*crstep, new);
+		return;
+	} else if (cpu_has_edat2()) {
+		crdte_crste(crstep, *crstep, new, gfn, asce);
+		return;
+	}
+
+	if (machine_has_tlb_guest())
+		idte_crste(crstep, gfn, IDTE_GUEST_ASCE, asce, IDTE_GLOBAL);
+	else
+		idte_crste(crstep, gfn, 0, NULL_ASCE, IDTE_GLOBAL);
+	WRITE_ONCE(*crstep, new);
+}
+
+/**
+ * dat_crstep_xchg_atomic - atomically exchange a gmap CRSTE with another
+ * @crstep: pointer to the CRST entry
+ * @old: expected old value
+ * @new: replacement entry
+ * @gfn: the affected guest address
+ * @asce: the asce of the address space
+ *
+ * This function should only be called on invalid crstes, or on crstes with
+ * FC = 1, as that guarantees the presence of CSPG.
+ *
+ * This function is needed to atomically exchange a CRSTE that potentially
+ * maps a prefix area, without having to invalidate it inbetween.
+ *
+ * Context: This function is assumed to be called with kvm->mmu_lock held.
+ *
+ * Return: true if the exchange was successful.
+ */
+bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
+			    union asce asce)
+{
+	if (old.h.i)
+		return arch_try_cmpxchg((long *)crstep, &old.val, new.val);
+	if (cpu_has_edat2())
+		return crdte_crste(crstep, old, new, gfn, asce);
+	return cspg_crste(crstep, old, new);
+}
+
+static void dat_set_storage_key_from_pgste(union pte pte, union pgste pgste)
+{
+	union skey nkey = { .acc = pgste.acc, .fp = pgste.fp };
+
+	page_set_storage_key(pte_origin(pte), nkey.skey, 0);
+}
+
+static void dat_move_storage_key(union pte old, union pte new)
+{
+	page_set_storage_key(pte_origin(new), page_get_storage_key(pte_origin(old)), 1);
+}
+
+static union pgste dat_save_storage_key_into_pgste(union pte pte, union pgste pgste)
+{
+	union skey skey;
+
+	skey.skey = page_get_storage_key(pte_origin(pte));
+
+	pgste.acc = skey.acc;
+	pgste.fp = skey.fp;
+	pgste.gr |= skey.r;
+	pgste.gc |= skey.c;
+
+	return pgste;
+}
+
+union pgste __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new, gfn_t gfn,
+			    union asce asce, bool uses_skeys)
+{
+	union pte old = READ_ONCE(*ptep);
+
+	/* Updating only the software bits while holding the pgste lock */
+	if (!((ptep->val ^ new.val) & ~_PAGE_SW_BITS)) {
+		WRITE_ONCE(ptep->swbyte, new.swbyte);
+		return pgste;
+	}
+
+	if (!old.h.i) {
+		unsigned long opts = IPTE_GUEST_ASCE | (pgste.nodat ? IPTE_NODAT : 0);
+
+		if (machine_has_tlb_guest())
+			__ptep_ipte(gfn_to_gpa(gfn), (void *)ptep, opts, asce.val, IPTE_GLOBAL);
+		else
+			__ptep_ipte(gfn_to_gpa(gfn), (void *)ptep, 0, 0, IPTE_GLOBAL);
+	}
+
+	if (uses_skeys) {
+		if (old.h.i && !new.h.i)
+			/* Invalid to valid: restore storage keys from PGSTE */
+			dat_set_storage_key_from_pgste(new, pgste);
+		else if (!old.h.i && new.h.i)
+			/* Valid to invalid: save storage keys to PGSTE */
+			pgste = dat_save_storage_key_into_pgste(old, pgste);
+		else if (!old.h.i && !new.h.i)
+			/* Valid to valid: move storage keys */
+			if (old.h.pfra != new.h.pfra)
+				dat_move_storage_key(old, new);
+		/* Invalid to invalid: nothing to do */
+	}
+
+	WRITE_ONCE(*ptep, new);
+	return pgste;
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index 4c75d3f75b33..c0644021c92f 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -430,6 +430,12 @@ struct kvm_s390_mmu_cache {
 	short int n_rmaps;
 };
 
+union pgste __must_check __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new,
+					 gfn_t gfn, union asce asce, bool uses_skeys);
+bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
+			    union asce asce);
+void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce);
+
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
 
@@ -757,6 +763,21 @@ static inline void pgste_set_unlock(union pte *ptep, union pgste pgste)
 	WRITE_ONCE(*pgste_of(ptep), pgste);
 }
 
+static inline void dat_ptep_xchg(union pte *ptep, union pte new, gfn_t gfn, union asce asce,
+				 bool has_skeys)
+{
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	pgste = __dat_ptep_xchg(ptep, pgste, new, gfn, asce, has_skeys);
+	pgste_set_unlock(ptep, pgste);
+}
+
+static inline void dat_ptep_clear(union pte *ptep, gfn_t gfn, union asce asce, bool has_skeys)
+{
+	dat_ptep_xchg(ptep, _PTE_EMPTY, gfn, asce, has_skeys);
+}
+
 static inline void dat_free_pt(struct page_table *pt)
 {
 	free_page((unsigned long)pt);
@@ -794,4 +815,23 @@ static inline struct kvm_s390_mmu_cache *kvm_s390_new_mmu_cache(void)
 	return NULL;
 }
 
+static inline bool dat_pmdp_xchg_atomic(union pmd *pmdp, union pmd old, union pmd new,
+					gfn_t gfn, union asce asce)
+{
+	return dat_crstep_xchg_atomic(_CRSTEP(pmdp), _CRSTE(old), _CRSTE(new), gfn, asce);
+}
+
+static inline bool dat_pudp_xchg_atomic(union pud *pudp, union pud old, union pud new,
+					gfn_t gfn, union asce asce)
+{
+	return dat_crstep_xchg_atomic(_CRSTEP(pudp), _CRSTE(old), _CRSTE(new), gfn, asce);
+}
+
+static inline void dat_crstep_clear(union crste *crstep, gfn_t gfn, union asce asce)
+{
+	union crste newcrste = _CRSTE_EMPTY(crstep->h.tt);
+
+	dat_crstep_xchg(crstep, newcrste, gfn, asce);
+}
+
 #endif /* __KVM_S390_DAT_H */
-- 
2.52.0


