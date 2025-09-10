Return-Path: <kvm+bounces-57231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FE94B51FD9
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:09:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE31916E48F
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE7E3342C9E;
	Wed, 10 Sep 2025 18:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MjVnuL3c"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D5B34166D;
	Wed, 10 Sep 2025 18:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527680; cv=none; b=LNYceJoI8NtMZlmhknECFtklOLjWtoqg4m0MIIi5ow4aDeCfEJlJa7sYAZUqwUl00xfG1alua5ULrqOM6Ob6YdQjdKglUBLJ9MwnYIyojnPnFCmW5L4qtpkRvuXtgS4JevB2VkkngVuD322Px/2d3uAodLGti/UtNuXd7TqXWSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527680; c=relaxed/simple;
	bh=25gccYSXKzmo2RknenSFoa+wIOabwTs8xPwFDRlfZAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijcsjcVmCD1C4Lxf2X8smEgylwYVO2vFjRKtf5N+kKBi69b7f+tFuAspkfs2jJTsnmzIUqT2IO8HNmWZzFNOcRKdPSxaBbU1svSKKBUX2rUSjQ7Nk3zhx7kMXzQ11DmrlskhLxFwplGS8mNLJ7SMippKOr0ijkkdQG6/i5hpOQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MjVnuL3c; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AA288o011537;
	Wed, 10 Sep 2025 18:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9c/+RTChx7wx0U93v
	dI4bcxq7+ry+cBPh+2QFndzg4g=; b=MjVnuL3cqrPWlnzD6/dotdXF/5XjlVri9
	cRuGCYPkQRPXjBMVz8MT5/JX/IkZ5X8HEUJNYfiI1vMUE2bNJNZgpPj8u4xWZlqh
	OcN3RZOsXUYzhq6eWx2eccJGdrILoMhr4xu6fcnsSAjfFyoH3W1htor/h7rN/i6s
	odlghO5CvfRe3fx5NtJy+qX2VQW/xEqS9HaYBWhQxyMNRXveiNUvcv0tUzIdml4w
	7XoWz2JdBP1lvc0AXD22rPzsVo7kMrx1nLXP1gKnDBd6omdOSBEeWmfClvLX0gW0
	Pow2l4Q4feYCuCrhnPFmO9jLKF14sbD6qUPWHhMeUbdbk//nUWDHA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490acr7ky0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:54 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGn41I011435;
	Wed, 10 Sep 2025 18:07:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 490y9uj3ue-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7no659310476
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9F41420040;
	Wed, 10 Sep 2025 18:07:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 692382004B;
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
Subject: [PATCH v2 11/20] KVM: s390: KVM page table management functions: storage keys
Date: Wed, 10 Sep 2025 20:07:37 +0200
Message-ID: <20250910180746.125776-12-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: fb_BEaHN_EFGWi2a6B7U-x0ViBdFUTNT
X-Authority-Analysis: v=2.4 cv=Mp1S63ae c=1 sm=1 tr=0 ts=68c1be7a cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=_ODGHmKQ2toS0TApCK4A:9
X-Proofpoint-ORIG-GUID: fb_BEaHN_EFGWi2a6B7U-x0ViBdFUTNT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAwMCBTYWx0ZWRfXy8cjwlya5Hmo
 +FYEsx52ImPhH904mQz4Y4Ne8TlSeKH51dW4R9FnoEIFGlo+YFovyp7I/DGqp54WnN4vh9hCiVO
 eDdiFaIZArE5R7f/vU/TN1vDd/4fv/IN+po5eGasVpLmSTMHQkxisVy7qgpOGHpS10b7HOaEdw9
 SoLeWBGX3wmim0g7uCUPNtvz2nv1o8w9Dmea5Yl2Vrjq0JNiywCrD7WVigw+i46/6hXXLGMVAPy
 qoSkHM1ssPEyUjcE/x4KLuBfG1+beFCmZCcxpAl+3PidfyXf4yWcEK/plzLOS4JBq/kM6jeuY28
 wfTn9XqRfFS8itQjIxZRzRtt4y8VqdbDw1bTaJe5GEvBKMdFVEDEkWoOJn0+ke4bfKmFJSmYWfs
 rs/khZqB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1015 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060000

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions related to storage key handling.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 212 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |   6 ++
 2 files changed, 218 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index fe93e1c07158..f626e8c37770 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -560,3 +560,215 @@ long _dat_walk_gfn_range(gfn_t start, gfn_t end, union asce asce,
 
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
+	rc = dat_entry_walk(gfn, asce, DAT_WALK_ANY, LEVEL_PTE, &crstep, &ptep);
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
+int dat_set_storage_key(union asce asce, gfn_t gfn, union skey skey, bool nq)
+{
+	union pgste pgste, old;
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(gfn, asce, DAT_WALK_LEAF_ALLOC, LEVEL_PTE, &crstep, &ptep);
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
+int dat_cond_set_storage_key(union asce asce, gfn_t gfn, union skey skey, union skey *oldkey,
+			     bool nq, bool mr, bool mc)
+{
+	union pgste pgste, old;
+	union crste *crstep;
+	union pte *ptep;
+	int rc;
+
+	rc = dat_entry_walk(gfn, asce, DAT_WALK_LEAF_ALLOC, LEVEL_PTE, &crstep, &ptep);
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
+	rc = dat_entry_walk(gfn, asce, DAT_WALK_ANY, LEVEL_PTE, &crstep, &ptep);
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
index de4bd2298945..40f5c1371ef3 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -427,6 +427,12 @@ int dat_entry_walk(gfn_t gfn, union asce asce, int flags, int walk_level,
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct page_table *dat_alloc_pt(unsigned long pte_bits, unsigned long pgste_bits);
 struct crst_table *dat_alloc_crst(unsigned long init);
+int dat_get_storage_key(union asce asce, gfn_t gfn, union skey *skey);
+int dat_set_storage_key(union asce asce, gfn_t gfn, union skey skey, bool nq);
+int dat_cond_set_storage_key(union asce asce, gfn_t gfn, union skey skey, union skey *oldkey,
+			     bool nq, bool mr, bool mc);
+int dat_reset_reference_bit(union asce asce, gfn_t gfn);
+long dat_reset_skeys(union asce asce, gfn_t start);
 
 static inline struct crst_table *crste_table_start(union crste *crstep)
 {
-- 
2.51.0


