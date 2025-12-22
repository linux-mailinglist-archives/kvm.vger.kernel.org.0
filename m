Return-Path: <kvm+bounces-66496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 96C16CD6C31
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A240030F3D74
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:02:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5CAC34321E;
	Mon, 22 Dec 2025 16:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ncIRb0TO"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AAE8342504;
	Mon, 22 Dec 2025 16:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422267; cv=none; b=kWKLaKdFo7ZG7QcaWUA2i6dR7ttc06/ljyY2yuIcBfSz7W2c0RCzlPbY5hc4xCEFi+U8sNOb0A7iJo51eMq7Fb8pzqH2qhkG/rkUSzDQhb6GKZyYdxTORU3ghhLqba+ZpVBtAtSC/3WdYksxh39zgEvVKIWJo2N+epPrslnx6Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422267; c=relaxed/simple;
	bh=SNPVmGbDk6iSrTLOy691ONUr2as1d8g3OduFeiPvqW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOmGOnJrqi1NWy2j38MtU5299714io+TkpVi8IN7A3uwlA4vUVOsunM6C1abrHJxO2CphyLJvgNigd8wix5yIm4hInW7+SyyiVDg/At/8ovMVt5B3gL5+GSQKvAw6BtfcvDIYsDcvj390gO2tTa7mo+Gs68WkOmh7h+KDqG3QAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ncIRb0TO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMC0i78030227;
	Mon, 22 Dec 2025 16:51:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ZT9r8islz9PO0XWUm
	+hoR0dy1jVhIG1QR0XXNydAgPM=; b=ncIRb0TO3FhgBe/sUbrEnZxVyjdfdv2OP
	PWHFf3LxPWw55NoFVDoB4+8tHQgxmBTOZcMXPrQS+QeltE3FH162oeIXTFniwlqb
	WVRndWD4uhNlquiZkFU0Bap+3QSmsrbM0nDVvC1AxB1SeRJ2KzMjrU2F2wPY0qWH
	Y85daIANmx34BJLgy5e22N1t/ADfQs01SPiYnDoTdsQgtTQZc5yCc69jv7tXDeIH
	41Tgkpw9mHgQJDT+oCyffktv/aaOAGTCFVIVun5t9/lelAUZu84+nuXXQKueylqD
	/VupFi1X6oI7bZ5mLBs3VgyXgUtMHgIfnbNlpeS3O6WoTEDp8H91g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5h7hs7ed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:01 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BMDcXZB005286;
	Mon, 22 Dec 2025 16:51:01 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4b67mjy3jv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGouFS27394446
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C964C20040;
	Mon, 22 Dec 2025 16:50:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D29720043;
	Mon, 22 Dec 2025 16:50:55 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:55 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 16/28] KVM: s390: KVM page table management functions: storage keys
Date: Mon, 22 Dec 2025 17:50:21 +0100
Message-ID: <20251222165033.162329-17-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfX5tNUWdS/exYC
 WhNuvNz9FidyrQkIfcgJg8OLUkhCovcDCeHdg9+yjIkxZKtB9BIuWjerXf7ZUJ2z/d1Yluztf6l
 iSSeAgCTBD89tU1E/tO/mRPFHdPqaAR0TtmJHsajCfkmi9y8V/uRVIU29IDMUFoFvUKCNxyIYWo
 whWP2tLL91K1QsfAn+tag1Zw5XbfC6qyNvXHOB04q8XFaeO6Je4qf9u9bR+KcgpNzStkjQhoJX7
 iKaO5t0XlfPkgGqR4rfU6R0nIPrD1kIPzpE9mbRA26Bty9OuoRh/2DyHBRTcfSZ/oMiZLyXxTXq
 iiZlvV+JLPGGMLbBoGKpg3NwTygf2qQ06XytomT/QCXmIXIMQgPTZkKUWs+JfYtvJwggZQuKlSK
 KMg3gNllLSKmgAkyzREwu+nLyRTFfx9CfwcpXv1IYaGh2BwTI45ZYWloIM/ZayVaFKXWAF2PHGr
 IWcztaLbVD0IsFYwY5A==
X-Authority-Analysis: v=2.4 cv=Ba3VE7t2 c=1 sm=1 tr=0 ts=694976f5 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=W9Pr6BDoNAxxbfFvkF8A:9
X-Proofpoint-ORIG-GUID: FQBO9Xj6ir5p2Rj1hEpICd0VzBN2fid_
X-Proofpoint-GUID: FQBO9Xj6ir5p2Rj1hEpICd0VzBN2fid_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-22_02,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2512220154

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
index 902d4a044067..4cd573fcbdd6 100644
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
2.52.0


