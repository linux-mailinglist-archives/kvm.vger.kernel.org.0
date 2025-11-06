Return-Path: <kvm+bounces-62207-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CFB90C3C55D
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 17:18:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 56D2C346EAD
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 16:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D3F4357A3A;
	Thu,  6 Nov 2025 16:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DTbfUZ1w"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3013563D2;
	Thu,  6 Nov 2025 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762445503; cv=none; b=u02FxN9kgKkDi4Dvlyc8sQ03ij7c4L4XbSnUjg4MhWxj/8+I/2dn0btLJ1FVb3+N1TCmUe/HszSGpo9c9GukcQtULIFIOKM2ytYtkBdER7wA9UdsH4hp3CdpCRB+tnvgSWLiOD6peRziIm8ePKzWk+CKUuxNiNVhXcZ+u5yVMr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762445503; c=relaxed/simple;
	bh=50KA5iT5kzgQI9Ar5R8XjQAEd22z1zYJFLkcUXI7ByY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2tD7mqWhaSwmN0eGbpmYyLhNLYusMueQi9ahBjGtntHyxpM77M0wdAe5ZHREj+cFoig8+enWEIxd1rJ1jmvw3vcEm6HT5XVPoKzGBBpezeozZDzcrlx44lOS53MoLRzZtkMml8gJBbOeh3d0vdQmtX8AtKoOHL4y2UA5E/Fbqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DTbfUZ1w; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A67WULu009552;
	Thu, 6 Nov 2025 16:11:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9OExJKpuPW6gbgmp2
	i3sU0WmIJKCmHfaXuvvJVi0A1Y=; b=DTbfUZ1w9Q54oW1Q+5Pz6KVaqy1Oidq2I
	xBekHQ8CW2/8ndRMrmc9lycjsXG0qw+SrhXzBEGseUCRbDBsc47RKKXz9S3dFkRz
	okcWeC6G2XKvr5KxADsQ23jMhM5v+FH7ZNPeUxLbR+aqwxZtYUQxWEZQfuvIJUQx
	nt+9NQ9LlEpsgrxga2kdX0hy8N4knPWDtZBY6MfGXtGKFS1ugqtbxtI6G8N7bcsE
	P8ESJXK2QC2zmeCrZSDtMr29dWMg2b6tmiB1lCS3a5xuxDD6QqGAAEJzEZhLQWkD
	3WJBl0Cb6FpMix548CoOKslEsP9Hjajl2n1FvrCMOhieJ8phB+yyA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59v276b2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A6EZ0Zq027394;
	Thu, 6 Nov 2025 16:11:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4a5vwypfta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Nov 2025 16:11:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A6GBNdD29753790
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Nov 2025 16:11:24 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE35620043;
	Thu,  6 Nov 2025 16:11:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61E3D2004B;
	Thu,  6 Nov 2025 16:11:23 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.155.209.42])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  6 Nov 2025 16:11:23 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, schlameuss@linux.ibm.com,
        hca@linux.ibm.com, svens@linux.ibm.com, agordeev@linux.ibm.com,
        gor@linux.ibm.com, david@redhat.com, gerald.schaefer@linux.ibm.com
Subject: [PATCH v3 12/23] KVM: s390: KVM page table management functions: lifecycle management
Date: Thu,  6 Nov 2025 17:11:06 +0100
Message-ID: <20251106161117.350395-13-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: UqPzpF6PECC85Wiq54BjEsv3M_T2QA8z
X-Proofpoint-ORIG-GUID: UqPzpF6PECC85Wiq54BjEsv3M_T2QA8z
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX38yEqZzqj7TG
 hqpvAj7NRO/l6WZ3OfJvuLz64SiXHLwLQUZSecjmkCe328gFujD9JSNPgY0Lw6M5lm+BaK0vfQs
 +lejzUcHJi/E780bI+1aJGATcBeehdD8YMXTGJMhxHVNOr5TG9ORQZUpQhoJcMyi+0sIXJN0rUX
 31wu0ylupZ/M973rYTmkqy0s14+R9fM9tl5B5JXcu1786AYTn/JwqfWEIPU7QaaQREczGODtCKU
 02+/BnQvYCPIqPmEJMGOGdQKuZGnhVCjFu+g5sO2dkFMyWVFBF73/khufk+iSXSH9JMm3BA7NzX
 CxMyf7rwQsBUpdiemiZKwuMp6fPOrmX9XR3kCVHaW7Bo+nSgS7gYSCi7XVdotvvhrbujcm2okUC
 SHII/kwrh3r1rj3ESrD+rVdwasxNJA==
X-Authority-Analysis: v=2.4 cv=H8HWAuYi c=1 sm=1 tr=0 ts=690cc8b0 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=iJ2WplcNSJuwDbTYnpEA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-06_03,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 clxscore=1015 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to handle memslot creation and destruction,
additional per-pagetable data stored in the PGSTEs, mapping physical
addresses into the gmap, and marking address ranges as prefix.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 281 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  54 +++++++++
 2 files changed, 335 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index 121f99335ae9..666aebec72eb 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -102,6 +102,38 @@ void dat_free_level(struct crst_table *table, bool owns_ptes)
 	dat_free_crst(table);
 }
 
+int dat_set_asce_limit(struct kvm_s390_mmu_cache *mc, union asce *asce, int newtype)
+{
+	struct crst_table *table;
+	union crste crste;
+
+	while (asce->dt > newtype) {
+		table = dereference_asce(*asce);
+		crste = table->crstes[0];
+		if (crste.h.fc)
+			return 0;
+		if (!crste.h.i) {
+			asce->rsto = crste.h.fc0.to;
+			dat_free_crst(table);
+		} else {
+			crste.h.tt--;
+			crst_table_init((void *)table, crste.val);
+		}
+		asce->dt--;
+	}
+	while (asce->dt < newtype) {
+		crste = _crste_fc0(asce->rsto, asce->dt + 1);
+		table = dat_alloc_crst_noinit(mc);
+		if (!table)
+			return -ENOMEM;
+		crst_table_init((void *)table, _CRSTE_HOLE(crste.h.tt).val);
+		table->crstes[0] = crste;
+		asce->rsto = __pa(table) >> PAGE_SHIFT;
+		asce->dt++;
+	}
+	return 0;
+}
+
 /**
  * dat_crstep_xchg - exchange a gmap CRSTE with another
  * @crstep: pointer to the CRST entry
@@ -817,3 +849,252 @@ long dat_reset_skeys(union asce asce, gfn_t start)
 
 	return _dat_walk_gfn_range(start, asce_end(asce), asce, &ops, DAT_WALK_IGN_HOLES, NULL);
 }
+
+struct slot_priv {
+	unsigned long token;
+	struct kvm_s390_mmu_cache *mc;
+};
+
+static long _dat_slot_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct slot_priv *p = walk->priv;
+	union crste dummy = { .val = p->token };
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
+	struct slot_priv *p = walk->priv;
+
+	new_crste.val = p->token;
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
+	return dat_split_crste(p->mc, crstep, gfn, walk->asce, false);
+}
+
+static const struct dat_walk_ops dat_slot_ops = {
+	.pte_entry = _dat_slot_pte,
+	.crste_ops = { _dat_slot_crste, _dat_slot_crste, _dat_slot_crste, _dat_slot_crste, },
+};
+
+int dat_set_slot(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t start, gfn_t end,
+		 u16 type, u16 param)
+{
+	struct slot_priv priv = {
+		.token = _CRSTE_TOK(0, type, param).val,
+		.mc = mc,
+	};
+
+	return _dat_walk_gfn_range(start, end, asce, &dat_slot_ops,
+				   DAT_WALK_IGN_HOLES | DAT_WALK_ANY, &priv);
+}
+
+static void pgste_set_unlock_multiple(union pte *first, int n, union pgste *pgstes)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		if (!pgstes[i].pcl)
+			break;
+		pgste_set_unlock(first + i, pgstes[i]);
+	}
+}
+
+static bool pgste_get_trylock_multiple(union pte *first, int n, union pgste *pgstes)
+{
+	int i;
+
+	for (i = 0; i < n; i++) {
+		if (!pgste_get_trylock(first + i, pgstes + i))
+			break;
+	}
+	if (i == n)
+		return true;
+	pgste_set_unlock_multiple(first, n, pgstes);
+	return false;
+}
+
+unsigned long dat_get_ptval(struct page_table *table, struct ptval_param param)
+{
+	union pgste pgstes[4] = {};
+	unsigned long res = 0;
+	int i, n;
+
+	n = param.len + 1;
+
+	while (!pgste_get_trylock_multiple(table->ptes + param.offset, n, pgstes))
+		cpu_relax();
+
+	for (i = 0; i < n; i++)
+		res = res << 16 | pgstes[i].val16;
+
+	pgste_set_unlock_multiple(table->ptes + param.offset, n, pgstes);
+	return res;
+}
+
+void dat_set_ptval(struct page_table *table, struct ptval_param param, unsigned long val)
+{
+	union pgste pgstes[4] = {};
+	int i, n;
+
+	n = param.len + 1;
+
+	while (!pgste_get_trylock_multiple(table->ptes + param.offset, n, pgstes))
+		cpu_relax();
+
+	for (i = param.len; i >= 0; i--) {
+		pgstes[i].val16 = val;
+		val = val >> 16;
+	}
+
+	pgste_set_unlock_multiple(table->ptes + param.offset, n, pgstes);
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
+int dat_link(struct kvm_s390_mmu_cache *mc, union asce asce, int level,
+	     bool uses_skeys, struct guest_fault *f)
+{
+	union crste oldval, newval;
+	union pte newpte, oldpte;
+	union pgste pgste;
+	int rc = 0;
+
+	rc = dat_entry_walk(mc, f->gfn, asce, DAT_WALK_ALLOC_CONTINUE, level, &f->crstep, &f->ptep);
+	if (rc)
+		return rc == -EINVAL ? rc : -EAGAIN;
+
+	if (WARN_ON_ONCE(unlikely(get_level(f->crstep, f->ptep) > level)))
+		return -EINVAL;
+
+	if (f->ptep) {
+		pgste = pgste_get_lock(f->ptep);
+		oldpte = *f->ptep;
+		newpte = _pte(f->pfn, f->writable, f->write_attempt | oldpte.s.d, !f->page);
+		newpte.s.sd = oldpte.s.sd;
+		oldpte.s.sd = 0;
+		if (oldpte.val == _PTE_EMPTY.val || oldpte.h.pfra == f->pfn) {
+			pgste = __dat_ptep_xchg(f->ptep, pgste, newpte, f->gfn, asce, uses_skeys);
+			if (f->callback)
+				f->callback(f);
+		} else {
+			rc = -EAGAIN;
+		}
+		pgste_set_unlock(f->ptep, pgste);
+	} else {
+		oldval = READ_ONCE(*f->crstep);
+		newval = _crste_fc1(f->pfn, oldval.h.tt, f->writable,
+				    f->write_attempt | oldval.s.fc1.d);
+		newval.s.fc1.sd = oldval.s.fc1.sd;
+		if (oldval.val != _CRSTE_EMPTY(oldval.h.tt).val &&
+		    crste_origin_large(oldval) != crste_origin_large(newval))
+			return -EAGAIN;
+		if (!dat_crstep_xchg_atomic(f->crstep, oldval, newval, f->gfn, asce))
+			return -EAGAIN;
+		if (f->callback)
+			f->callback(f);
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
index bbfb141ffcb4..0dc80893ed7c 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -362,6 +362,11 @@ struct dat_walk {
 	void *priv;
 };
 
+struct ptval_param {
+	unsigned char offset : 6;
+	unsigned char len : 2;
+};
+
 /**
  * _pte() - Useful constructor for union pte
  * @pfn: the pfn this pte should point to.
@@ -460,6 +465,32 @@ struct kvm_s390_mmu_cache {
 	short int n_rmaps;
 };
 
+struct guest_fault {
+	gfn_t gfn;		/* Guest frame */
+	kvm_pfn_t pfn;		/* Host PFN */
+	struct page *page;	/* Host page */
+	union pte *ptep;	/* Used to resolve the fault, or NULL */
+	union crste *crstep;	/* Used to resolve the fault, or NULL */
+	bool writable;		/* Mapping is writable */
+	bool write_attempt;	/* Write access attempted */
+	bool attempt_pfault;	/* Attempt a pfault first */
+	bool valid;		/* This entry contains valid data */
+	void (*callback)(struct guest_fault *f);
+	void *priv;
+};
+
+/*
+ *	0	1	2	3	4	5	6	7
+ *	+-------+-------+-------+-------+-------+-------+-------+-------+
+ *  0	|				|	    PGT_ADDR		|
+ *  8	|	 VMADDR		|					|
+ * 16	|								|
+ * 24	|								|
+ */
+#define MKPTVAL(o, l) ((struct ptval_param) { .offset = (o), .len = ((l) + 1) / 2 - 1})
+#define PTVAL_PGT_ADDR	MKPTVAL(4, 8)
+#define PTVAL_VMADDR	MKPTVAL(8, 6)
+
 union pgste __must_check __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new,
 					 gfn_t gfn, union asce asce, bool uses_skeys);
 bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste new, gfn_t gfn,
@@ -473,6 +504,7 @@ int dat_entry_walk(struct kvm_s390_mmu_cache *mc, gfn_t gfn, union asce asce, in
 		   int walk_level, union crste **last, union pte **ptepp);
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
+int dat_set_asce_limit(struct kvm_s390_mmu_cache *mc, union asce *asce, int newtype);
 int dat_get_storage_key(union asce asce, gfn_t gfn, union skey *skey);
 int dat_set_storage_key(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
 			union skey skey, bool nq);
@@ -481,6 +513,16 @@ int dat_cond_set_storage_key(struct kvm_s390_mmu_cache *mmc, union asce asce, gf
 int dat_reset_reference_bit(union asce asce, gfn_t gfn);
 long dat_reset_skeys(union asce asce, gfn_t start);
 
+unsigned long dat_get_ptval(struct page_table *table, struct ptval_param param);
+void dat_set_ptval(struct page_table *table, struct ptval_param param, unsigned long val);
+
+int dat_set_slot(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t start, gfn_t end,
+		 u16 type, u16 param);
+int dat_set_prefix_notif_bit(union asce asce, gfn_t gfn);
+bool dat_test_age_gfn(union asce asce, gfn_t start, gfn_t end);
+int dat_link(struct kvm_s390_mmu_cache *mc, union asce asce, int level,
+	     bool uses_skeys, struct guest_fault *f);
+
 int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc);
 
 #define GFP_KVM_S390_MMU_CACHE (GFP_ATOMIC | __GFP_ACCOUNT | __GFP_NOWARN)
@@ -886,4 +928,16 @@ static inline int get_level(union crste *crstep, union pte *ptep)
 	return ptep ? TABLE_TYPE_PAGE_TABLE : crstep->h.tt;
 }
 
+static inline int dat_delete_slot(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t start,
+				  unsigned long npages)
+{
+	return dat_set_slot(mc, asce, start, start + npages, _DAT_TOKEN_PIC, PGM_ADDRESSING);
+}
+
+static inline int dat_create_slot(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t start,
+				  unsigned long npages)
+{
+	return dat_set_slot(mc, asce, start, start + npages, _DAT_TOKEN_NONE, 0);
+}
+
 #endif /* __KVM_S390_DAT_H */
-- 
2.51.1


