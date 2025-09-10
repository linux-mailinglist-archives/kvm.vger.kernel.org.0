Return-Path: <kvm+bounces-57237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EE534B51FE6
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:09:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89A07174F71
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7B7B3451A5;
	Wed, 10 Sep 2025 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X32MDk9c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58BE33CE8D;
	Wed, 10 Sep 2025 18:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527688; cv=none; b=DbvAEIpNm2Czlkq+kwFN2eSauhnQTMTRL1Om1PEquSNQsP/CiC1f8fBYpbNd8bR/Jq3zQLyF52bAIMW+EMtbz1JfsXAtovKT2jg4dFEfZO/yqWTGhPlThYa5aNrBNWLsJZDSJhX+fTwn3tIAv9tLHq0EE7/8uSphhhppH/Tjv2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527688; c=relaxed/simple;
	bh=W12Tr8qSUsZ/e5eNL0q7KxZsrNVLs9L+Grlu/6keDY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORn3DKJ0k7dZmxbzjP/FDJSb0ZkOIp2W99y/kYCfIMurSN2hHpWd2gCbidteABm9mULDYuq4DqGDrxftZoZmZplV1FfoaY/nxCaYtAQwxgfEsrveMs3L1fLZ6fgnzn8VPpsMjG5Qrha7x8wY+ZDyGhBzkLm/EgML73GOZN0xKK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X32MDk9c; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58ADIVfe012534;
	Wed, 10 Sep 2025 18:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=75RmrWtLjgOn3QpQc
	etPzXeDfw26iOHO+MdAz3nefiQ=; b=X32MDk9cLnJnRt9MLspXBtvmvMiHkpV0c
	od2EYhdTulDCRfE5K9jn+4UqU802fL+7DT5z/tJ90dN0WEKPCSmpCF0r+xTj99Iv
	58tKRXjFVWwbVIf9AesEajxM+eSEK5zruyM4vlaoLyqjT4JfK6ed4fThkFQQ0+zC
	NCJPtW7KwabPLdcyb6D0hBWjWXNyAEtvSKeaiV+VVl2mnE7pHzLsqjpgBiQUzj29
	9RtEe3yXc4ouk7+m2PXajfcVb72+2OMV+/6tg09TSfPuIQKW+N6kxCyeG3OypBpw
	8gEPvgHhDBhE3kXO9AUYYkSz7pbXZq2ZKZWlHdwRBQFOvCMYTSYsQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffg2c2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:54 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AG8eVa011443;
	Wed, 10 Sep 2025 18:07:53 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9uj3uf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7oid28050088
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E49732004B;
	Wed, 10 Sep 2025 18:07:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A670920049;
	Wed, 10 Sep 2025 18:07:49 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 10 Sep 2025 18:07:49 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        nsg@linux.ibm.com, nrb@linux.ibm.com, seiden@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v2 12/20] KVM: s390: KVM page table management functions: lifecycle management
Date: Wed, 10 Sep 2025 20:07:38 +0200
Message-ID: <20250910180746.125776-13-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 0ybvEzlcsh-ux4DRZFot73tn_5dH86sN
X-Proofpoint-GUID: 0ybvEzlcsh-ux4DRZFot73tn_5dH86sN
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c1be7a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=qWHIkmYJ-ivBDaRrMOAA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX9rTafuceC04x
 xsgXoGE6QyIfhKMxy0+zREWTohBsEd79LLCsHkS07Q9d2zMJI/rPUAcTku0tdTRNhTyIc4tj4Jp
 IkahC5UENCiDhG/YU/7u/1RIbHfYuZp/Dxv0LTi+jvsh2GvJmVDNfaUX9fgYWwnptoWVi8xVXxS
 2RnnYmAxzelS8yt7fVONzGEeVf5Tk09T9+je+f15UELfzQQkTBvyZan9H6yzX2+mCvzO+buBreV
 SrhRmv9jywhxULX1/zj5XgEMFSPujnNNK8Xe3VVR6jP0suQ3En+3nmMkivAOJ830lHGdOTRiDnS
 NBV3rSN+iIjMqz3TXgyiUQ7pvkX8yJGsY0RxtJCvbiKO3wZIAbX8mFiurIcWwBjB8jn3hfKVRUe
 GtgTGS49
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060020

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to handle memslot creation and destruction,
additional per-pagetable data stored in the PGSTEs, mapping physical
addresses into the gmap, and marking address ranges as prefix.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 227 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  35 +++++++
 2 files changed, 262 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index f626e8c37770..4249400a9d21 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -772,3 +772,230 @@ long dat_reset_skeys(union asce asce, gfn_t start)
 
 	return _dat_walk_gfn_range(start, asce_end(asce), asce, &ops, DAT_WALK_IGN_HOLES, NULL);
 }
+
+static long _dat_slot_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	union crste dummy = { .val = (unsigned long)walk->priv };
+	union pte new_pte, pte = READ_ONCE(*ptep);
+
+	new_pte = _PTE_TOK(dummy.tok.type, dummy.tok.par);
+
+	/* Table entry already in the desired state */
+	if (pte.val == new_pte.val)
+		return 0;
+
+	dat_ptep_xchg(ptep, new_pte, gfn, walk->asce, false);
+	return 0;
+}
+
+static long _dat_slot_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	union crste new_crste, crste = READ_ONCE(*crstep);
+
+	new_crste.val = (unsigned long)walk->priv;
+	new_crste.h.tt = crste.h.tt;
+
+	/* Table entry already in the desired state */
+	if (crste.val == new_crste.val)
+		return 0;
+
+	/* This table entry needs to be updated */
+	if (walk->start <= gfn && walk->end >= next) {
+		dat_crstep_xchg_atomic(crstep, crste, new_crste, gfn, walk->asce);
+		/* A lower level table was present, needs to be freed */
+		if (!crste.h.fc && !crste.h.i)
+			dat_free_level(dereference_crste(crste), true);
+		return 0;
+	}
+
+	/* A lower level table is present, things will handled there */
+	if (!crste.h.fc && !crste.h.i)
+		return 0;
+	/* Split (install a lower level table), and handle things there */
+	return dat_split_crste(crstep, gfn, walk->asce);
+}
+
+static const struct dat_walk_ops dat_slot_ops = {
+	.pte_entry = _dat_slot_pte,
+	.crste_ops = { _dat_slot_crste, _dat_slot_crste, _dat_slot_crste, _dat_slot_crste, },
+};
+
+int dat_set_slot(union asce asce, gfn_t start, gfn_t end, u16 type, u16 param)
+{
+	unsigned long token = _CRSTE_TOK(0, type, param).val;
+
+	return _dat_walk_gfn_range(start, end, asce, &dat_slot_ops,
+				   DAT_WALK_IGN_HOLES | DAT_WALK_ANY, (void *)token);
+}
+
+unsigned long dat_get_ptval(struct page_table *table, struct ptval_param param)
+{
+	union pgste *pgstes = table->pgstes + param.offset;
+	struct page *page = virt_to_page(table);
+	unsigned long res = 0;
+
+	lock_page(page);
+	switch (param.len) {
+	case 3:
+		res = pgstes->val16;
+		pgstes++;
+		fallthrough;
+	case 2:
+		res = res << 16 | pgstes->val16;
+		pgstes++;
+		fallthrough;
+	case 1:
+		res = res << 16 | pgstes->val16;
+		pgstes++;
+		fallthrough;
+	case 0:
+		res = res << 16 | pgstes->val16;
+		break;
+	}
+	unlock_page(page);
+
+	return res;
+}
+
+void dat_set_ptval(struct page_table *table, struct ptval_param param, unsigned long val)
+{
+	union pgste *pgstes = table->pgstes + param.offset;
+	struct page *page = virt_to_page(table);
+
+	lock_page(page);
+	switch (param.len) {
+	case 3:
+		pgstes->val16 = val >> 48;
+		pgstes++;
+		fallthrough;
+	case 2:
+		pgstes->val16 = val >> 32;
+		pgstes++;
+		fallthrough;
+	case 1:
+		pgstes->val16 = val >> 16;
+		pgstes++;
+		fallthrough;
+	case 0:
+		pgstes->val16 = val;
+		break;
+	}
+	unlock_page(page);
+}
+
+static long _dat_test_young_pte(union pte *ptep, gfn_t start, gfn_t end, struct dat_walk *walk)
+{
+	return ptep->s.y;
+}
+
+static long _dat_test_young_crste(union crste *crstep, gfn_t start, gfn_t end,
+				  struct dat_walk *walk)
+{
+	return crstep->h.fc && crstep->s.fc1.y;
+}
+
+static const struct dat_walk_ops test_age_ops = {
+	.pte_entry = _dat_test_young_pte,
+	.pmd_entry = _dat_test_young_crste,
+	.pud_entry = _dat_test_young_crste,
+};
+
+/**
+ * dat_test_age_gfn() - test young
+ * @kvm: the kvm instance
+ * @range: the range of guest addresses whose young status needs to be cleared
+ *
+ * Context: called by KVM common code with the kvm mmu write lock held
+ * Return: 1 if any page in the given range is young, otherwise 0.
+ */
+bool dat_test_age_gfn(union asce asce, gfn_t start, gfn_t end)
+{
+	return _dat_walk_gfn_range(start, end, asce, &test_age_ops, 0, NULL) > 0;
+}
+
+int dat_link(kvm_pfn_t pfn, gfn_t gfn, union asce asce, int level, bool w, bool d, bool s, bool sk)
+{
+	union crste oldval, newval;
+	union pte newpte, oldpte;
+	union crste *crstep;
+	union pgste pgste;
+	union pte *ptep;
+	int rc = 0;
+
+	rc = dat_entry_walk(gfn, asce, DAT_WALK_ALLOC_CONTINUE, level, &crstep, &ptep);
+	if (rc)
+		return rc == -EINVAL ? rc : -EAGAIN;
+
+	if (WARN_ON_ONCE(unlikely(get_level(crstep, ptep) > level)))
+		return -EINVAL;
+
+	if (ptep)  {
+		pgste = pgste_get_lock(ptep);
+		oldpte = *ptep;
+		newpte = _pte(pfn, w, d | oldpte.s.d, s);
+		newpte.s.sd = oldpte.s.sd;
+		oldpte.s.sd = 0;
+		if (oldpte.val == _PTE_EMPTY.val || oldpte.h.pfra == pfn)
+			pgste = __dat_ptep_xchg(ptep, pgste, newpte, gfn, asce, sk);
+		else
+			rc = -EAGAIN;
+		pgste_set_unlock(ptep, pgste);
+	} else {
+		oldval = READ_ONCE(*crstep);
+		newval = _crste_fc1(pfn, oldval.h.tt, w, d | oldval.s.fc1.d);
+		newval.s.fc1.sd = oldval.s.fc1.sd;
+		if (oldval.val != _CRSTE_EMPTY(oldval.h.tt).val &&
+		    crste_origin_large(oldval) != crste_origin_large(newval))
+			return -EAGAIN;
+		if (!dat_crstep_xchg_atomic(crstep, oldval, newval, gfn, asce))
+			return -EAGAIN;
+	}
+
+	return rc;
+}
+
+static long dat_set_pn_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	union crste crste = READ_ONCE(*crstep);
+	int *n = walk->priv;
+
+	if (!crste.h.fc || crste.h.i || crste.h.p)
+		return 0;
+
+	*n = 2;
+	if (crste.s.fc1.prefix_notif)
+		return 0;
+	crste.s.fc1.prefix_notif = 1;
+	dat_crstep_xchg(crstep, crste, gfn, walk->asce);
+	return 0;
+}
+
+static long dat_set_pn_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	int *n = walk->priv;
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	if (!ptep->h.i && !ptep->h.p) {
+		pgste.prefix_notif = 1;
+		*n += 1;
+	}
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+int dat_set_prefix_notif_bit(union asce asce, gfn_t gfn)
+{
+	static const struct dat_walk_ops ops = {
+		.pte_entry = dat_set_pn_pte,
+		.pmd_entry = dat_set_pn_crste,
+		.pud_entry = dat_set_pn_crste,
+	};
+
+	int n = 0;
+
+	_dat_walk_gfn_range(gfn, gfn + 2, asce, &ops, DAT_WALK_IGN_HOLES, &n);
+	if (n != 2)
+		return -EAGAIN;
+	return 0;
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index 40f5c1371ef3..b695eae5d763 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -374,6 +374,11 @@ struct dat_walk {
 	void *priv;
 };
 
+struct ptval_param {
+	unsigned char offset : 6;
+	unsigned char len : 2;
+};
+
 static inline union pte _pte(kvm_pfn_t pfn, bool w, bool d, bool s)
 {
 	union pte res = { .val = PFN_PHYS(pfn) };
@@ -413,6 +418,18 @@ static inline union crste _crste_fc1(kvm_pfn_t pfn, int tt, bool w, bool d)
 	return res;
 }
 
+/**
+ *	0	1	2	3	4	5	6	7
+ *	+-------+-------+-------+-------+-------+-------+-------+-------+
+ *  0	|				|	    PGT_ADDR		|
+ *  8	|	 VMADDR		|SPLTCNT|				|
+ * 16	|								|
+ * 24	|								|
+ */
+#define MKPTVAL(o, l) ((struct ptval_param) { .offset = (o), .len = ((l) + 1) / 2 - 1})
+#define PTVAL_PGT_ADDR	MKPTVAL(4, 8)
+#define PTVAL_VMADDR	MKPTVAL(8, 6)
+
 union pgste __must_check __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new,
 					 gfn_t gfn, union asce asce, bool has_skeys);
 bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
@@ -434,6 +451,14 @@ int dat_cond_set_storage_key(union asce asce, gfn_t gfn, union skey skey, union
 int dat_reset_reference_bit(union asce asce, gfn_t gfn);
 long dat_reset_skeys(union asce asce, gfn_t start);
 
+unsigned long dat_get_ptval(struct page_table *table, struct ptval_param param);
+void dat_set_ptval(struct page_table *table, struct ptval_param param, unsigned long val);
+
+int dat_set_slot(union asce asce, gfn_t start, gfn_t end, u16 type, u16 param);
+int dat_set_prefix_notif_bit(union asce asce, gfn_t gfn);
+bool dat_test_age_gfn(union asce asce, gfn_t start, gfn_t end);
+int dat_link(kvm_pfn_t pfn, gfn_t gfn, union asce asce, int level, bool w, bool d, bool s, bool sk);
+
 static inline struct crst_table *crste_table_start(union crste *crstep)
 {
 	return (struct crst_table *)ALIGN_DOWN((unsigned long)crstep, _CRST_TABLE_SIZE);
@@ -778,4 +803,14 @@ static inline int get_level(union crste *crstep, union pte *ptep)
 	return ptep ? LEVEL_PTE : crstep->h.tt;
 }
 
+static inline int dat_delete_slot(union asce asce, gfn_t start, unsigned long npages)
+{
+	return dat_set_slot(asce, start, start + npages, _DAT_TOKEN_PIC, PGM_ADDRESSING);
+}
+
+static inline int dat_create_slot(union asce asce, gfn_t start, unsigned long npages)
+{
+	return dat_set_slot(asce, start, start + npages, _DAT_TOKEN_NONE, 0);
+}
+
 #endif /* __KVM_S390_DAT_H */
-- 
2.51.0


