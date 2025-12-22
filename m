Return-Path: <kvm+bounces-66504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9588ECD6D36
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 18:27:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CBAA03100905
	for <lists+kvm@lfdr.de>; Mon, 22 Dec 2025 17:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7947C348883;
	Mon, 22 Dec 2025 16:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="GxZYeeCB"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B0A346A0F;
	Mon, 22 Dec 2025 16:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766422277; cv=none; b=Hu1YZb5Y47XIBKpF/bQEczhxB51GdybDpKj5z30QQX8LLHEvU0Al1j3rhc/FVeNNssBlNUHoH0PNrplULjiT5V5jcPiwgWZTlwywcxR9FuLBkLNnkyYOLP/EZwkQ/Hr52ffnge5Y84s8uuX4UrbHjBRnPZrJAlVktzZtMsaLOws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766422277; c=relaxed/simple;
	bh=of3lYvcLbms99qSG5RwvlyIFH06bv0/41A95CrzPfsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYDdSGSR+lML1ILVAiVsRv56SCNL7jXmrdWR5PMjws+i+GfTlO+HBhTAGgTM4+8l+Hb4KzwZlai/GoVrliVcYAj23QSGCd96b6VArGZNst4kjY3WcxxZQbEhnqOqkW2uzSeTeKT0Vfuz8kKAU1eYR5HgUgYGWBAh8CQWo232C/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=GxZYeeCB; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5BM8e8V2011222;
	Mon, 22 Dec 2025 16:51:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=grH8tOJZn9+NERonw
	cyRmROq4CPB+nBGfXbnHu/EVdM=; b=GxZYeeCBvVYVcLWyH2auDbPFbLZ6EO1+W
	0zR/5tVy0CuWh42pUrg17FVLMAeXl/CjwdrOB/eV5dF3vRBcSnEKlE6KM06NTqUa
	29B8oOtaxmRG3ixZP7IvQl0lmnlqxifya+Vs8OgRE752CScmJ7YillPJx32r7Bav
	zMEWUS41SFdJRzhET5DDX4EgcONKWF1dBmsXLzCX0twpQ1aTtQ2Q0IdyFEyinmbv
	g0pQwbaghXzPzvCxK1Zz9eGce5XJWtaThL7JfolQOf1ElAOXqHg1WxXtvCb5FSIB
	ZJaIIcbRaedhQSvpB4BNkq8qTtoeDtYOx1lc8j5JeLDG8HTAnj86w==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4b5ka399g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:02 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5BME7GhC026979;
	Mon, 22 Dec 2025 16:51:02 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4b6r93487g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 Dec 2025 16:51:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5BMGowkV51315036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 22 Dec 2025 16:50:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0EE0620040;
	Mon, 22 Dec 2025 16:50:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7FE220043;
	Mon, 22 Dec 2025 16:50:56 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.79.149])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 22 Dec 2025 16:50:56 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v6 17/28] KVM: s390: KVM page table management functions: lifecycle management
Date: Mon, 22 Dec 2025 17:50:22 +0100
Message-ID: <20251222165033.162329-18-imbrenda@linux.ibm.com>
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
X-Proofpoint-GUID: lYkHhPywXz3KU29ZPRmKWegKyNj3i5Vd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIyMDE1NCBTYWx0ZWRfXxMAjhhEaY8lA
 RKTytjESpZxuV9VccXxh/dP0OSisnDCX+E90bBnbl0aIuN5ssdK8LjcGp5oV+VBsNP2sn9WCzEi
 Sk3dwPtSQygpW4TDIbMjJztjy0aNlnvgHx2l883lZY+dSnYKiGiPrn2HHpydIkpgl7YY6+GkcsY
 PxMnmTmXveLq6tFJjGiw7kxX4afcF9Yj/dh2Tk4GfcuQAb/WSNVsMBXApozvKcdCVUDujVAzzu8
 jP/kbsmIzQ42VLXsHhI2ed5VNkWAoxbDchkbPd3Xt37arg7xHsbQFzsN2Dio1q1sBYz5tXvnwDg
 jUjqhJ/cbcBa5eaZTZ093ggWFarBtOpHyTj9OjHIRBbnfKDoC+Wtr/hL1lHgarsPJnzra7tlYr+
 SgfWK9EKbFmiH31u0mmMScY7DFjX46/iewwK9XfBm/HtBo+ILrSYILebQxxST78q+TEj0UwAK9V
 hAjIKcgcoVyx2NlWU8Q==
X-Proofpoint-ORIG-GUID: lYkHhPywXz3KU29ZPRmKWegKyNj3i5Vd
X-Authority-Analysis: v=2.4 cv=dqHWylg4 c=1 sm=1 tr=0 ts=694976f7 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=wP3pNCr1ah4A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=iJ2WplcNSJuwDbTYnpEA:9
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

This patch adds functions to handle memslot creation and destruction,
additional per-pagetable data stored in the PGSTEs, mapping physical
addresses into the gmap, and marking address ranges as prefix.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 284 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  54 +++++++++
 2 files changed, 338 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index d75329cf1f47..cafbcb665da4 100644
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
@@ -820,3 +852,255 @@ long dat_reset_skeys(union asce asce, gfn_t start)
 
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
+ * @asce: the ASCE whose address range is to be tested
+ * @start: the first guest frame of the range to check
+ * @end: the guest frame after the last in the range
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
+	if (rc == -EINVAL || rc == -ENOMEM)
+		return rc;
+	if (rc)
+		return -EAGAIN;
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
index 4cd573fcbdd6..11573b1002f6 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -361,6 +361,11 @@ struct dat_walk {
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
@@ -459,6 +464,32 @@ struct kvm_s390_mmu_cache {
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
@@ -472,6 +503,7 @@ int dat_entry_walk(struct kvm_s390_mmu_cache *mc, gfn_t gfn, union asce asce, in
 		   int walk_level, union crste **last, union pte **ptepp);
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
+int dat_set_asce_limit(struct kvm_s390_mmu_cache *mc, union asce *asce, int newtype);
 int dat_get_storage_key(union asce asce, gfn_t gfn, union skey *skey);
 int dat_set_storage_key(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
 			union skey skey, bool nq);
@@ -480,6 +512,16 @@ int dat_cond_set_storage_key(struct kvm_s390_mmu_cache *mmc, union asce asce, gf
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
@@ -880,4 +922,16 @@ static inline int get_level(union crste *crstep, union pte *ptep)
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
2.52.0


