Return-Path: <kvm+bounces-62196-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E3ADC3C4DE
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:15:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B979B351EA8
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:15:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48773350A3E;
	Thu,  6 Nov 2025 16:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ksak9w1q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C506734EEF5;
	Thu,  6 Nov 2025 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445494; cv=none; b=EdHBXbnrwwFaCE/jq+Lmhxk+8nh9mhFASMyXINSa//kxYPavz1AwLxNrvPaFnEW/M8VjIbfotSVZt65+mKOp9Vaa5wSd8icc4Ex9XMV6bSnUpEOeYlB44GwTJ0F2GlNtka1ELdSApIzNIwCcyKcojS2+7ja7jI/k7fC1azWbxcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445494; c=relaxed/simple;
	bh=pkD2ddhm86liTg8mFUvHFJILmDy1faDlzFG4nx9AXwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWMDoqVKl/oS+5e2p+OBOUIpus/BFobgHTGGVm29qFJlQ7bfdVsgcsqUikzTz7jxucj9MPTnvhZ8RTi6WydFPTmw/JQ3xC8kXpE9zkrSjrf/MilaNRT8F5yPocd5q9YwZQy/aPXufD/9Y7IFi30xGTHo9PtKrMn7fBYaVzfCO68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ksak9w1q; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A66kKoM017849;
	Thu, 6 Nov 2025 16:11:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4swAQbrh+MhVPEzQg
	sqanill+MhBIhCTp8/gOQ9tGPU=; b=ksak9w1qUM1UoALiGHPfQNUuYB/oJSowP
	S9dGDDiuzf7vRY2PAahCfvsdnJvJgtZoUqC/Y0ce0742ddXI5zPnabO1R/JZSd4F
	TAel+9LMkuPgwSInrR62JSwhq5W8Puyv8NytJtIj4Z/DbHcRwT//KBJyXUrDwKfo
	KmXZRsekYAki6wdFt3B0QY4o0BOcZh+XJr2Z42lY7Fj1m3XK/b/Smk0812Qa99Y2
	ZTeJr5KfADMPf6dU79k0fFoaDj/KnD9SaaoHfi7MEOSuI+SfmByK/T0W8nB8Nvv9
	2745h2ZUDmbbcEBQ6/oxs0SoqhOUlJ4+0OH8NB9MhqGRfqfuFZEAg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59vur6v9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:27 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6F8ZAl009869;
	Thu, 6 Nov 2025 16:11:26 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5x1kp93m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:26 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBMRC58393038
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:22 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4E52A20043;
	Thu,  6 Nov 2025 16:11:22 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAF8D2004D;
	Thu,  6 Nov 2025 16:11:21 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:21 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 09/23] KVM: s390: KVM page table management functions: clear and replace
Date: Thu,  6 Nov 2025 17:11:03 +0100
Message-ID: <20251106161117.350395-10-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: IVOxIR2dpwVy5JQp8RtR2tkPFUx4_WOh
X-Proofpoint-GUID: IVOxIR2dpwVy5JQp8RtR2tkPFUx4_WOh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX5c5FRvc093Kj
 0aywEwA/Ngp07cCPPA6dzlL4nhlIs25wNs8bgkWrJKL/1mQQqWnKX/1C538GA0bm0Fi2+uxsFbg
 gIDdc3MzHr4aeNc5e4XQlWGY1POC6h2gQ9mpTX1eBa2R+h1h0mXxZ5HMkCYzgK6zAv2FIQdDUdr
 DmKI2r1JAaV/lqmn86TiWjY0Q5rTNVkEXP3FeUgpf8JdpjtZ4iUX33Lq62vcPvV0TICH7EcFDE/
 ewi9sCzZup8YspZZzds58G5Q5C2YBD88jBrO0t2fOwVC27H8D1kxfzSqwNJ0iHtV0M77Jbgs8Wy
 gAWXgMRCGX6+o9rU0VgbZufxlA8wfJLlctuWcsQ7KqN9dBxf9DWBBCwiSB84/U0/+12Igtu2+my
 ORjSRrPmF1dEblJxZXybebudgPvsuA==
X-Authority-Analysis: v=2.4 cv=U6qfzOru c=1 sm=1 tr=0 ts=690cc8af cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=cTj5uL8xXfUXbJxEK6wA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 impostorscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 suspectscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511010021

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
index 7fcbf80b3858..8bd1f8e0ef91 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -431,6 +431,12 @@ struct kvm_s390_mmu_cache {
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
 
@@ -763,6 +769,21 @@ static inline void pgste_set_unlock(union pte *ptep, union pgste pgste)
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
@@ -800,4 +821,23 @@ static inline struct kvm_s390_mmu_cache *kvm_s390_new_mmu_cache(void)
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
2.51.1


