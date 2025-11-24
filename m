Return-Path: <kvm+bounces-64361-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BA2B3C804F2
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 12:59:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F40084E687F
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:58:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39B00302CDE;
	Mon, 24 Nov 2025 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bjYLzsUq"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D82302CAC;
	Mon, 24 Nov 2025 11:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985387; cv=none; b=P0zT0mgjDo/BuaL8Pde1QOlloN3j78DNWj8owkegv4rPUKYn2ldu98OIcVzfqM4skeAjwZP0Iso80mOCO3FQiPK2yK9myjKocukX4Nawc6fCiZi7MyTFfxH7aogfv0NMuJCxQFiC8y+nO8HC+Nm9vLVhK0oQ4bh0LNmUWirco+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985387; c=relaxed/simple;
	bh=0YHOolvJBGdXHaQi101ZqHbFUSxMBNOiS8gCl++75nY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aG1KcxHI+OXEWEbVFMc0cs0892dnNJugCnbP+H4QwPzJ9w6YhPuRoEfVtd6k1ttN6HS1KWy5WgUhPeY08mQKwBgN6HtT0U2zeACQiMLW5yt0nqL5N/TgDPlJPTV4KDoVWemTQMw3ufptPP+uMBhp+frxg7xD1x006bUNdBd1JkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bjYLzsUq; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ANMRD4D029302;
	Mon, 24 Nov 2025 11:56:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uZwMa5Qjd9fE99c9d
	xvqr+EBpgdvYgdudnKz7DR3C0o=; b=bjYLzsUqmBJjvwSta/Vsd6NKFIYFx2N1g
	R/Voi7WCw+E6o2bZ2sQUhMFQHGLYcayuEfmX+Zpl9AfEYCe7m+bUIwk4rbC0Pg4m
	TBJPziIGOgNyyNa3UX0YZcSg1kCfePhtdZ/cKYfymZuCpwG0XCoKXH6ufZvB4/Z/
	ZX/5gw76WY3KLCp3EzRCoCrX4jwEwldwdWWNmGby9Cgbyy8xAP3xFBwx7bgpCDNe
	6Wt4qepS9UFaHIIavnMSRjmPFLGc96DdbMtBcsxlgLku+yuZzFO5upm7Ukpv/nd4
	Q2SnWgKmHFDu/oIen+r4fVyvtSO/FGy1AfZOUZ6YAN6/vLQo/x4AQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4u1qdtd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO8F3pj025116;
	Mon, 24 Nov 2025 11:56:20 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akt715e6p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBuGbD54788480
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D548720043;
	Mon, 24 Nov 2025 11:56:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5033B20040;
	Mon, 24 Nov 2025 11:56:15 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:15 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 11/23] KVM: s390: KVM page table management functions: storage keys
Date: Mon, 24 Nov 2025 12:55:42 +0100
Message-ID: <20251124115554.27049-12-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfX/46BGCE/Wj8i
 zOfImaVvTh7OKEUmrWkVoeTQgb2by0eIwU/rc88pn0X8uLzUA5LG0nUmuUVTwrb5sQ2mXq+6LH3
 MzGN4kICAlTdaPXZOyZ2LS/lvdFSdAW8CfMD7HVAudSScI+nzE416FkpYePaRVidsuQn9bc9tdA
 5quuAXt6gdADw46NKy0XwW4HorSdhUh6QKsI8lbOb1CNzNiq7vHby6vRBpl7UZmrPLMM7q2fKLP
 ZXKSSQEXaCe+awyqe824/Jh9/wcizVm6F8QphSNNVVvuwX7WNnyXHE+p1VgPcIt8Hl/rhORP4P9
 FgRFx6+Cl/76ZS/921NJ+/2xCeIFSheb7RNyaqogKOHl3JQTEBwJwhWcC9gGcHBieDlverOYP5T
 UErhJ8jOftWyUX6t/6odS98mm7Licw==
X-Authority-Analysis: v=2.4 cv=SuidKfO0 c=1 sm=1 tr=0 ts=692447e5 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=W9Pr6BDoNAxxbfFvkF8A:9
X-Proofpoint-ORIG-GUID: GqKdFtYmfURzqNl-rTTVcZWIuLnQC-b0
X-Proofpoint-GUID: GqKdFtYmfURzqNl-rTTVcZWIuLnQC-b0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 spamscore=0 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220021

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions related to storage key handling.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 215 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |   7 ++
 2 files changed, 222 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index 3158652dbe8e..d75329cf1f47 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -605,3 +605,218 @@ long _dat_walk_gfn_range(gfn_t start, gfn_t end, union asce asce,
 
 	return dat_crste_walk_range(start, min(end, asce_end(asce)), table, &walk);
 }
+
+int dat_get_storage_key(union asce asce, gfn_t gfn, union skey *skey)
+{
+	union crste *crstep;
+	union pgste pgste;
+	union pte *ptep;
+	int rc;
+
+	skey->skey = 0;
+	rc = dat_entry_walk(NULL, gfn, asce, DAT_WALK_ANY, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep);
+	if (rc)
+		return rc;
+
+	if (!ptep) {
+		union crste crste;
+
+		crste = READ_ONCE(*crstep);
+		if (!crste.h.fc || !crste.s.fc1.pr)
+			return 0;
+		skey->skey = page_get_storage_key(large_crste_to_phys(crste, gfn));
+		return 0;
+	}
+	pgste = pgste_get_lock(ptep);
+	if (ptep->h.i) {
+		skey->acc = pgste.acc;
+		skey->fp = pgste.fp;
+	} else {
+		skey->skey = page_get_storage_key(pte_origin(*ptep));
+	}
+	skey->r |= pgste.gr;
+	skey->c |= pgste.gc;
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+static void dat_update_ptep_sd(union pgste old, union pgste pgste, union pte *ptep)
+{
+	if (pgste.acc != old.acc || pgste.fp != old.fp || pgste.gr != old.gr || pgste.gc != old.gc)
+		__atomic64_or(_PAGE_SD, &ptep->val);
+}
+
+int dat_set_storage_key(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
+			union skey skey, bool nq)
+{
+	union pgste pgste, old;
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(mc, gfn, asce, DAT_WALK_LEAF_ALLOC, TABLE_TYPE_PAGE_TABLE,
+			    &crstep, &ptep);
+	if (rc)
+		return rc;
+
+	if (!ptep) {
+		page_set_storage_key(large_crste_to_phys(*crstep, gfn), skey.skey, !nq);
+		return 0;
+	}
+
+	old = pgste_get_lock(ptep);
+	pgste = old;
+
+	pgste.acc = skey.acc;
+	pgste.fp = skey.fp;
+	pgste.gc = skey.c;
+	pgste.gr = skey.r;
+
+	if (!ptep->h.i) {
+		union skey old_skey;
+
+		old_skey.skey = page_get_storage_key(pte_origin(*ptep));
+		pgste.hc |= old_skey.c;
+		pgste.hr |= old_skey.r;
+		skey.r = 0;
+		skey.c = 0;
+		page_set_storage_key(pte_origin(*ptep), skey.skey, !nq);
+	}
+
+	dat_update_ptep_sd(old, pgste, ptep);
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+static bool page_cond_set_storage_key(phys_addr_t paddr, union skey skey, union skey *oldkey,
+				      bool nq, bool mr, bool mc)
+{
+	oldkey->skey = page_get_storage_key(paddr);
+	if (oldkey->acc == skey.acc && oldkey->fp == skey.fp &&
+	    (oldkey->r == skey.r || mr) && (oldkey->c == skey.c || mc))
+		return false;
+	page_set_storage_key(paddr, skey.skey, !nq);
+	return true;
+}
+
+int dat_cond_set_storage_key(struct kvm_s390_mmu_cache *mmc, union asce asce, gfn_t gfn,
+			     union skey skey, union skey *oldkey, bool nq, bool mr, bool mc)
+{
+	union pgste pgste, old;
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(mmc, gfn, asce, DAT_WALK_LEAF_ALLOC, TABLE_TYPE_PAGE_TABLE,
+			    &crstep, &ptep);
+	if (rc)
+		return rc;
+
+	if (!ptep)
+		return page_cond_set_storage_key(large_crste_to_phys(*crstep, gfn), skey, oldkey,
+						 nq, mr, mc);
+
+	old = pgste_get_lock(ptep);
+	pgste = old;
+
+	rc = 1;
+	pgste.acc = skey.acc;
+	pgste.fp = skey.fp;
+	pgste.gc = skey.c;
+	pgste.gr = skey.r;
+
+	if (!ptep->h.i) {
+		union skey prev;
+
+		rc = page_cond_set_storage_key(pte_origin(*ptep), skey, &prev, nq, mr, mc);
+		pgste.hc |= prev.c;
+		pgste.hr |= prev.r;
+		if (oldkey)
+			*oldkey = prev;
+	}
+
+	dat_update_ptep_sd(old, pgste, ptep);
+	pgste_set_unlock(ptep, pgste);
+	return rc;
+}
+
+int dat_reset_reference_bit(union asce asce, gfn_t gfn)
+{
+	union pgste pgste, old;
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(NULL, gfn, asce, DAT_WALK_ANY, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep);
+	if (rc)
+		return rc;
+
+	if (!ptep) {
+		union crste crste = READ_ONCE(*crstep);
+
+		if (!crste.h.fc || !crste.s.fc1.pr)
+			return 0;
+		return page_reset_referenced(large_crste_to_phys(*crstep, gfn));
+	}
+	old = pgste_get_lock(ptep);
+	pgste = old;
+
+	if (!ptep->h.i) {
+		rc = page_reset_referenced(pte_origin(*ptep));
+		pgste.hr = rc >> 1;
+	}
+	rc |= (pgste.gr << 1) | pgste.gc;
+	pgste.gr = 0;
+
+	dat_update_ptep_sd(old, pgste, ptep);
+	pgste_set_unlock(ptep, pgste);
+	return rc;
+}
+
+static long dat_reset_skeys_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	pgste.acc = 0;
+	pgste.fp = 0;
+	pgste.gr = 0;
+	pgste.gc = 0;
+	if (ptep->s.pr)
+		page_set_storage_key(pte_origin(*ptep), PAGE_DEFAULT_KEY, 1);
+	pgste_set_unlock(ptep, pgste);
+
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+static long dat_reset_skeys_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	phys_addr_t addr, end, origin = crste_origin_large(*crstep);
+
+	if (!crstep->h.fc || !crstep->s.fc1.pr)
+		return 0;
+
+	addr = ((max(gfn, walk->start) - gfn) << PAGE_SHIFT) + origin;
+	end = ((min(next, walk->end) - gfn) << PAGE_SHIFT) + origin;
+	while (ALIGN(addr + 1, _SEGMENT_SIZE) <= end)
+		addr = sske_frame(addr, PAGE_DEFAULT_KEY);
+	for ( ; addr < end; addr += PAGE_SIZE)
+		page_set_storage_key(addr, PAGE_DEFAULT_KEY, 1);
+
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+long dat_reset_skeys(union asce asce, gfn_t start)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = dat_reset_skeys_pte,
+		.pmd_entry = dat_reset_skeys_crste,
+		.pud_entry = dat_reset_skeys_crste,
+	};
+
+	return _dat_walk_gfn_range(start, asce_end(asce), asce, &ops, DAT_WALK_IGN_HOLES, NULL);
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index 5488bdc1a79b..6a328a4d1cca 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -472,6 +472,13 @@ int dat_entry_walk(struct kvm_s390_mmu_cache *mc, gfn_t gfn, union asce asce, in
 		   int walk_level, union crste **last, union pte **ptepp);
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
+int dat_get_storage_key(union asce asce, gfn_t gfn, union skey *skey);
+int dat_set_storage_key(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
+			union skey skey, bool nq);
+int dat_cond_set_storage_key(struct kvm_s390_mmu_cache *mmc, union asce asce, gfn_t gfn,
+			     union skey skey, union skey *oldkey, bool nq, bool mr, bool mc);
+int dat_reset_reference_bit(union asce asce, gfn_t gfn);
+long dat_reset_skeys(union asce asce, gfn_t start);
 
 int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc);
 
-- 
2.51.1


