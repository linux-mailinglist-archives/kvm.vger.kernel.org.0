Return-Path: <kvm+bounces-57228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30081B51FD3
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCB80168F61
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 171DC338F26;
	Wed, 10 Sep 2025 18:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IF1qCx5C"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB4433CE8C;
	Wed, 10 Sep 2025 18:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527678; cv=none; b=oPNgClTTnVqReokcSkO486FxHcJqB5tD3iK/KdLdRjNCjMOWKPMVjHJI7ix4IZ0QphTXTuWDbJ1dPEs4UCFnb2sCd1WZYWLW0kuiYENaJf+Inq7Tl/bDFMhzdd5UOZhs947l9tWQXY9VtGw/lLUsIKzHt2rTQ2epxS3WzqvpNsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527678; c=relaxed/simple;
	bh=jtiOmdqum2tw9V0FhC3HdIsUpFaldArNrtg/8IBCs3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBdJaKOSyjOBPVQkD7c7EejexJ3MKjqKVbhPKjfljSwSY/ybGEkCpGsf+i/VAMfHa1m+OB+IWlTR0OMps8PUgaEqOeD1W4jaAWHm2o/QMZGMsN7NWmhvQ1WOenB5eu3RTFcu1J3S5ltQC+6/bIk8gpqsOo4/Kj5q+rjkq76+OYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IF1qCx5C; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AET8lN029522;
	Wed, 10 Sep 2025 18:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=aPGpOqcDu63jpqLQz
	QEcK+CGAJo7qyygJiVR5U0RrAg=; b=IF1qCx5CPUTctN3IF0Rjm5nLJRWpo1oXH
	zTb54EshhpjW+/XWS3NyecJk+M2TFwCdHac3/9IAhdRPCXAyNcV1VMsjGx3GUF9d
	U1qUPFTPnbbAv7sLCiBL4eEaMKyL+aJLOl0wI4IaUXiyVmd0dUmWxcNc5psNb2dD
	a64VkZ+JEqqLOAlB1Qxf+1O23ij4/ZmduioqMh7yPVkE2W9m7HcnpZNirrGpT3aa
	Hedm4fhky5F7wxTr9xbh5IjkYKUskQIC0mX9xtKjjDbUEcPtZjXvq8gNhZrHP5v5
	PiZaBM2hi2RmSmfUzYpTfxBM1rByBpWJjsCicctfqT1arj+HUDtig==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490ukemvr3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AEwoO4001177;
	Wed, 10 Sep 2025 18:07:52 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203hjp3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7nTE59310472
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1CE1E20040;
	Wed, 10 Sep 2025 18:07:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DAA652004B;
	Wed, 10 Sep 2025 18:07:48 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 18:07:48 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v2 09/20] KVM: s390: KVM page table management functions: clear and replace
Date: Wed, 10 Sep 2025 20:07:35 +0200
Message-ID: <20250910180746.125776-10-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDE5NSBTYWx0ZWRfX5Vc+h7Lo686N
 T37qVNxqnHMMXrZpHGcGEu6ccOHfDBTqkjAvMbt5IncC1X2vSN+ww+37LUe9nLk/mt47gJJwP6C
 te4T53K2e4ZW7a9u2zFCgN2qe1O74rRLXyRlqFpR1aSrvlew4yyBl6DrOWmiX6tgE+dlS79L9gX
 yM9zQQwLSAn3A6LKGROUrbYp35LKZUmlWvPg5rUqQmxJqXC2tkyOAgIFMKr2CLP2rSoLIIHqoV7
 iZGMwBMx3frvekhYhoORNn2GPzwMQWkWmWLaEQhIhleCTpY2lSFWytxxd16fLlJuhObxmcw6US0
 aMwbY6a8UiV/vIBNjnu731vS3afVgAGXnOnZxzygeaMXpMLZ4ybNc+CkTxegIbivU4Ow8VXry9+
 BuwA2264
X-Proofpoint-ORIG-GUID: GzJDjgY0WUJFetfNjv79auJDmlja9Vyw
X-Proofpoint-GUID: GzJDjgY0WUJFetfNjv79auJDmlja9Vyw
X-Authority-Analysis: v=2.4 cv=StCQ6OO0 c=1 sm=1 tr=0 ts=68c1be79 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=cTj5uL8xXfUXbJxEK6wA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060195

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to clear, replace or exchange DAT table
entries.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 120 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  40 +++++++++++++++
 2 files changed, 160 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index 326be78adcda..f26e3579bd77 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -89,3 +89,123 @@ void dat_free_level(struct crst_table *table, bool owns_ptes)
 	}
 	dat_free_crst(table);
 }
+
+/**
+ * dat_crstep_xchg - exchange a guest CRST with another
+ * @crstep: pointer to the CRST entry
+ * @new: replacement entry
+ * @gfn: the affected guest address
+ * @asce: the ASCE of the address space
+ *
+ * This function is assumed to be called with the guest_table_lock
+ * held.
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
+	else if (cpu_has_idte())
+		idte_crste(crstep, gfn, 0, NULL_ASCE, IDTE_GLOBAL);
+	else
+		csp_invalidate_crste(crstep);
+	WRITE_ONCE(*crstep, new);
+}
+
+/**
+ * dat_crstep_xchg_atomic - exchange a gmap pmd with another
+ * @crstep: pointer to the crste entry
+ * @old: expected old value
+ * @new: replacement entry
+ * @gfn: the affected guest address
+ * @asce: the asce of the address space
+ *
+ * This function should only be called on invalid crstes, or on crstes with
+ * FC = 1, as that guarantees the presence of CSPG.
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
+	if (cpu_has_idte())
+		return cspg_crste(crstep, old, new);
+
+	WARN_ONCE(1, "Machine does not have CSPG and DAT table was not invalid.");
+	return false;
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
+			    union asce asce, bool has_skeys)
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
+	if (has_skeys) {
+		if (old.h.i && !new.h.i)
+			/* Invalid to valid: restore storage keys from PGSTE */
+			dat_set_storage_key_from_pgste(new, pgste);
+		else if (!old.h.i && new.h.i)
+			/* Valid to invalid: save storage keys to PGSTE */
+			pgste = dat_save_storage_key_into_pgste(new, pgste);
+		else if (!old.h.i && !new.h.i)
+			/* Valid to valid: move storage keys */
+			if (old.h.pfra != new.h.pfra)
+				dat_move_storage_key(*ptep, new);
+		/* Invalid to invalid: nothing to do */
+	}
+
+	WRITE_ONCE(*ptep, new);
+	return pgste;
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index 5056cfa02619..9e23f6cdbf73 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -385,6 +385,12 @@ static inline union crste _crste_fc1(kvm_pfn_t pfn, int tt, bool w, bool d)
 	return res;
 }
 
+union pgste __must_check __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new,
+					 gfn_t gfn, union asce asce, bool has_skeys);
+bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
+			    union asce asce);
+void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce);
+
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct page_table *dat_alloc_pt(unsigned long pte_bits, unsigned long pgste_bits);
 struct crst_table *dat_alloc_crst(unsigned long init);
@@ -677,6 +683,21 @@ static inline void pgste_set_unlock(union pte *ptep, union pgste pgste)
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
 static inline struct page_table *dat_alloc_empty_pt(void)
 {
 	return dat_alloc_pt(_PAGE_INVALID, 0);
@@ -694,4 +715,23 @@ static inline void _dat_free_crst(struct crst_table *table)
 
 #define dat_free_crst(x) _dat_free_crst(_CRSTP(x))
 
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
2.51.0


