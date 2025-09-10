Return-Path: <kvm+bounces-57238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BBC3B51FE8
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:09:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E076B48017A
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:09:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5C73451BD;
	Wed, 10 Sep 2025 18:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="I1L3K18E"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7272C33CE8C;
	Wed, 10 Sep 2025 18:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527689; cv=none; b=HRNppUZfl7HGCt3KfRIRoUT4LWqaOhUuVnVvcflQozaUo7EFYpX6BghR6mWwoM5n9zisvbYYjimKWtxTU61kXOlKQqCQobk6Thfbk5L6IFSlK+nZ2SuKyq0o1ry66GRvi1soQtC4IusbAAvA11AZeZM22SLKOOKGT3ODI0/1c84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527689; c=relaxed/simple;
	bh=5el3JhVh2lCm+rG07xdUOS2AskBlHGvlH234+E4/nws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1OKrZ2oWgUygH1XuLjlzKLMn8gUUGEfSSbDNJ65AxiosOXBxMwnO4oGo3oJDSs1y0S0MrDnvctYv0uZoxVKJMutUCzrV7zb3wqpfQ+NYi59/lQtvXSoL66+Moi+Wt3Gqm92feg5Pd/PNvkoc8cQGMaMPUKGQMg7Y/Aa/Kvkwnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=I1L3K18E; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AFUTkj009648;
	Wed, 10 Sep 2025 18:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=szUlTQh0aKqj19qMX
	WDItcFZhP5rvdAvA8Ss3hS2UBQ=; b=I1L3K18EXvcK7WtJ9MESY1N7zWkm3ZyzX
	MwZY3UGE7eBMEEQhkYSYJfVfKbFgqqhnALUv1r7vvpbNkmQ9jF7OqDoMuoYdszrI
	ZwAwHQrdFJHZ8xn7eCnulrEU7ofiy9CgfOYjzI50QBzxL2Rj4nLlGogXCdqrRNO2
	94E8vY7JV2MF/S+tAZvH7EdLtfTsuxqzrqpz6/tNup/P7BccBANOkC5FWii/ewhA
	O+pW0lAhHvtvMo4O0t0GLHvTEo8081mgAdTWL+CoLh+lHKkQ2i8LZ2e4UCZUtYeS
	oYhy5JDwvZf18gUf6uzoHSLZpYB9iAKtW1mJMbphnvdPvTehWdqcw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490xyd4uv6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:54 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AH8Std010671;
	Wed, 10 Sep 2025 18:07:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4910sn1t1v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:53 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7nJY59310474
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61FE820040;
	Wed, 10 Sep 2025 18:07:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 244ED20049;
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
Subject: [PATCH v2 10/20] KVM: s390: KVM page table management functions: walks
Date: Wed, 10 Sep 2025 20:07:36 +0200
Message-ID: <20250910180746.125776-11-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: ukgfADkcXE06XW7jJbtarOCXr_na6W_d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDIzNSBTYWx0ZWRfX9bo7KLsRi37N
 eurl778/0MJjni/7lWrSTHiaLAlNkaZWJxzRS0JeRPDD3vve0TZq8MklAWVZR2MUIgDMaJkplOc
 L7hFKBEUGKNNdbfIwicTLPsL7q48W6ae9Xe686OYORiHnrXOqZ3UM32yp2bXn6DvS9n+3Yu3S6U
 vipLXKOiLOjiBCrrERG0eoWAzplOUCBNyCiqol/n7o6iCvM1RbnYbjd+hc/tkIc7N171I9ROHyr
 kJLmtIQ/X68dWOAE5OpjOcuSb191Wf+BpweVRvqng7oLLSIA8KRcwg4C5z58dj1bi3EI6yVzOz6
 c8oB1R60d7Myp/KlutZIgrS4OgaheV7albFZtSeNvt4qGuK/Q34KjVF5i8umnp97UUncKelABWr
 lm8u4Uy5
X-Proofpoint-GUID: ukgfADkcXE06XW7jJbtarOCXr_na6W_d
X-Authority-Analysis: v=2.4 cv=F59XdrhN c=1 sm=1 tr=0 ts=68c1be7a cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=yPCFVO9ZvQzR1xJ941sA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_03,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015
 impostorscore=0 bulkscore=0 adultscore=0 spamscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509060235

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to walk to specific table entries, or to
perform actions on a range of entries.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 351 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  38 +++++
 2 files changed, 389 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index f26e3579bd77..fe93e1c07158 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -209,3 +209,354 @@ union pgste __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new, g
 	WRITE_ONCE(*ptep, new);
 	return pgste;
 }
+
+/*
+ * dat_split_pmd is assumed to be called with mmap_lock held in read or write mode
+ */
+static int dat_split_pmd(union pmd *pmdp, gfn_t gfn, union asce asce)
+{
+	struct page_table *pt;
+	union pmd new, old;
+	union pte init;
+	int i;
+
+	old = READ_ONCE(*pmdp);
+
+	/* Already split, nothing to do */
+	if (!old.h.i && !old.h.fc)
+		return 0;
+
+	pt = dat_alloc_pt_noinit();
+	if (!pt)
+		return -ENOMEM;
+	new.val = virt_to_phys(pt);
+
+	while (old.h.i || old.h.fc) {
+		init.val = pmd_origin_large(old);
+		init.h.p = old.h.p;
+		init.h.i = old.h.i;
+		init.s.d = old.s.fc1.d;
+		init.s.w = old.s.fc1.w;
+		init.s.y = old.s.fc1.y;
+		init.s.sd = old.s.fc1.sd;
+		init.s.pr = old.s.fc1.pr;
+		if (old.h.fc) {
+			for (i = 0; i < _PAGE_ENTRIES; i++)
+				pt->ptes[i].val = init.val | i * PAGE_SIZE;
+			/* no need to take locks as the page table is not installed yet */
+			dat_init_pgstes(pt, old.s.fc1.prefix_notif ? PGSTE_IN_BIT : 0);
+		} else {
+			dat_init_page_table(pt, init.val, 0);
+		}
+
+		if (dat_pmdp_xchg_atomic(pmdp, old, new, gfn, asce))
+			return 0;
+		old = READ_ONCE(*pmdp);
+	}
+
+	dat_free_pt(pt);
+	return 0;
+}
+
+static int dat_split_crste(union crste *crstep, gfn_t gfn, union asce asce)
+{
+	struct crst_table *table;
+	union crste old, new, init;
+	int i;
+
+	old = READ_ONCE(*crstep);
+	if (is_pmd(old))
+		return dat_split_pmd(&crstep->pmd, gfn, asce);
+
+	/* Already split, nothing to do */
+	if (!old.h.i && !old.h.fc)
+		return 0;
+
+	table = dat_alloc_crst_noinit();
+	if (!table)
+		return -ENOMEM;
+
+	new.val = virt_to_phys(table);
+	new.h.tt = old.h.tt;
+	new.h.fc0.tl = _REGION_ENTRY_LENGTH;
+
+	while (old.h.i || old.h.fc) {
+		init = old;
+		init.h.tt--;
+		if (old.h.fc) {
+			for (i = 0; i < _CRST_ENTRIES; i++)
+				table->crstes[i].val = init.val | i * HPAGE_SIZE;
+		} else {
+			crst_table_init((void *)table, init.val);
+		}
+		if (dat_crstep_xchg_atomic(crstep, old, new, gfn, asce))
+			return 0;
+		old = READ_ONCE(*crstep);
+	}
+
+	dat_free_crst(table);
+	return 0;
+}
+
+/**
+ * dat_entry_walk() - walk the gmap page tables
+ * @gfn: guest frame
+ * @asce: the ASCE of the address space
+ * @flags: flags from WALK_* macros
+ * @level: level to walk to, from LEVEL_* macros
+ * @last: will be filled the last visited non-pte DAT entry
+ * @ptepp: will be filled the last visited pte entry, if any, otherwise NULL
+ *
+ * Returns a table entry pointer for the given guest address and @level
+ *
+ * The @flags have the following meanings:
+ * * @DAT_WALK_IGN_HOLES: consider holes as normal table entries
+ * * @DAT_WALK_ALLOC: allocate new tables to reach the requested level, if needed
+ * * @DAT_WALK_SPLIT: split existing large pages to reach the requested level, if needed
+ * * @DAT_WALK_LEAF: return successfully whenever a large page is encountered
+ * * @DAT_WALK_ANY: return successfully even if the requested level could not be reached
+ * * @DAT_WALK_CONTINUE: walk to the requested level with the specified flags, and then try to
+ *                       continue walking to ptes with only DAT_WALK_ANY
+ *
+ * Context: called with kvm->mmu_lock held.
+ *
+ * Return:
+ * * PGM_ADDRESSING if the requested address lies outside memory
+ * * a PIC number if the requested address lies in a memory hole of type _DAT_TOKEN_PIC
+ * * -EFAULT if the requested address lies inside a memory hole of a different type
+ * * -EINVAL if the given ASCE is not compatible with the requested level
+ * * -EFBIG if the requested level could not be reached because a larger frame was found
+ * * -ENOENT if the requested level could not be reached for other reasons
+ * * -ENOMEM if running out of memory while allocating or splitting a table
+ */
+int dat_entry_walk(gfn_t gfn, union asce asce, int flags, int walk_level,
+		   union crste **last, union pte **ptepp)
+{
+	bool continue_anyway = flags & DAT_WALK_CONTINUE;
+	bool ign_holes = flags & DAT_WALK_IGN_HOLES;
+	bool allocate = flags & DAT_WALK_ALLOC;
+	bool split = flags & DAT_WALK_SPLIT;
+	bool leaf = flags & DAT_WALK_LEAF;
+	bool any = flags & DAT_WALK_ANY;
+	struct page_table *pgtable;
+	struct crst_table *table;
+	union crste entry;
+	int rc;
+
+	*last = NULL;
+	*ptepp = NULL;
+	if (WARN_ON_ONCE(unlikely(!asce.val)))
+		return -EINVAL;
+	if (WARN_ON_ONCE(unlikely(walk_level > asce.dt)))
+		return -EINVAL;
+	if (!asce_contains_gfn(asce, gfn))
+		return PGM_ADDRESSING;
+
+	table = dereference_asce(asce);
+	if (asce.dt >= ASCE_TYPE_REGION1) {
+		*last = table->crstes + pgd_index(gfn_to_gpa(gfn));
+		entry = READ_ONCE(**last);
+		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_PGD)))
+			return -EINVAL;
+		if (crste_hole(entry) && !ign_holes)
+			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+		if (walk_level == LEVEL_PGD)
+			return 0;
+		if (entry.pgd.h.i) {
+			if (!allocate)
+				return any ? 0 : -ENOENT;
+			rc = dat_split_crste(*last, gfn, asce);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		table = dereference_crste(entry.pgd);
+	}
+
+	if (asce.dt >= ASCE_TYPE_REGION2) {
+		*last = table->crstes + p4d_index(gfn_to_gpa(gfn));
+		entry = READ_ONCE(**last);
+		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_P4D)))
+			return -EINVAL;
+		if (crste_hole(entry) && !ign_holes)
+			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+		if (walk_level == LEVEL_P4D)
+			return 0;
+		if (entry.p4d.h.i) {
+			if (!allocate)
+				return any ? 0 : -ENOENT;
+			rc = dat_split_crste(*last, gfn, asce);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		table = dereference_crste(entry.p4d);
+	}
+
+	if (asce.dt >= ASCE_TYPE_REGION3) {
+		*last = table->crstes + pud_index(gfn_to_gpa(gfn));
+		entry = READ_ONCE(**last);
+		if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_PUD)))
+			return -EINVAL;
+		if (crste_hole(entry) && !ign_holes)
+			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+		if (walk_level == LEVEL_PUD && continue_anyway && !entry.pud.h.fc && !entry.h.i) {
+			walk_level = LEVEL_PTE;
+			allocate = false;
+		}
+		if (walk_level == LEVEL_PUD || ((leaf || any) && entry.pud.h.fc))
+			return 0;
+		if (entry.pud.h.i && !entry.pud.h.fc) {
+			if (!allocate)
+				return any ? 0 : -ENOENT;
+			rc = dat_split_crste(*last, gfn, asce);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		if (walk_level <= LEVEL_PMD && entry.pud.h.fc) {
+			if (!split)
+				return -EFBIG;
+			rc = dat_split_crste(*last, gfn, asce);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		table = dereference_crste(entry.pud);
+	}
+
+	*last = table->crstes + pmd_index(gfn_to_gpa(gfn));
+	entry = READ_ONCE(**last);
+	if (WARN_ON_ONCE(unlikely(entry.h.tt != LEVEL_PMD)))
+		return -EINVAL;
+	if (crste_hole(entry) && !ign_holes)
+		return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+	if (continue_anyway && !entry.pmd.h.fc && !entry.h.i) {
+		walk_level = LEVEL_PTE;
+		allocate = false;
+	}
+	if (walk_level == LEVEL_PMD || ((leaf || any) && entry.pmd.h.fc))
+		return 0;
+
+	if (entry.pmd.h.i && !entry.pmd.h.fc) {
+		if (!allocate)
+			return any ? 0 : -ENOENT;
+		rc = dat_split_crste(*last, gfn, asce);
+		if (rc)
+			return rc;
+		entry = READ_ONCE(**last);
+	}
+	if (walk_level <= LEVEL_PTE && entry.pmd.h.fc) {
+		if (!split)
+			return -EFBIG;
+		rc = dat_split_crste(*last, gfn, asce);
+		if (rc)
+			return rc;
+		entry = READ_ONCE(**last);
+	}
+	pgtable = dereference_pmd(entry.pmd);
+	*ptepp = pgtable->ptes + pte_index(gfn_to_gpa(gfn));
+	if (pte_hole(**ptepp) && !ign_holes)
+		return (*ptepp)->tok.type == _DAT_TOKEN_PIC ? (*ptepp)->tok.par : -EFAULT;
+	return 0;
+}
+
+static long dat_pte_walk_range(gfn_t gfn, gfn_t end, struct page_table *table, struct dat_walk *w)
+{
+	unsigned int idx = gfn & (_PAGE_ENTRIES - 1);
+	long rc = 0;
+
+	for ( ; gfn < end; idx++, gfn++) {
+		if (pte_hole(READ_ONCE(table->ptes[idx]))) {
+			if (!(w->flags & DAT_WALK_IGN_HOLES))
+				return -EFAULT;
+			if (!(w->flags & DAT_WALK_ANY))
+				continue;
+		}
+
+		rc = w->ops->pte_entry(table->ptes + idx, gfn, gfn + 1, w);
+		if (rc)
+			break;
+	}
+	return rc;
+}
+
+static long dat_crste_walk_range(gfn_t start, gfn_t end, struct crst_table *table,
+				 struct dat_walk *walk)
+{
+	unsigned long idx, cur_shift, cur_size;
+	dat_walk_op the_op;
+	union crste crste;
+	gfn_t cur, next;
+	long rc = 0;
+
+	cur_shift = 8 + table->crstes[0].h.tt * 11;
+	idx = (start >> cur_shift) & (_CRST_ENTRIES - 1);
+	cur_size = 1UL << cur_shift;
+
+	for (cur = ALIGN_DOWN(start, cur_size); cur < end; idx++, cur = next) {
+		next = cur + cur_size;
+		walk->last = table->crstes + idx;
+		crste = READ_ONCE(*walk->last);
+
+		if (crste_hole(crste)) {
+			if (!(walk->flags & DAT_WALK_IGN_HOLES))
+				return -EFAULT;
+			if (!(walk->flags & DAT_WALK_ANY))
+				continue;
+		}
+
+		the_op = walk->ops->crste_ops[crste.h.tt];
+		if (the_op) {
+			rc = the_op(walk->last, cur, next, walk);
+			crste = READ_ONCE(*walk->last);
+		}
+		if (rc)
+			break;
+		if (!crste.h.i && !crste.h.fc) {
+			if (!is_pmd(crste))
+				rc = dat_crste_walk_range(max(start, cur), min(end, next),
+							  _dereference_crste(crste), walk);
+			else if (walk->ops->pte_entry)
+				rc = dat_pte_walk_range(max(start, cur), min(end, next),
+							dereference_pmd(crste.pmd), walk);
+		}
+	}
+	return rc;
+}
+
+/**
+ * _dat_walk_gfn_range() - walk DAT tables
+ * @start: the first guest page frame to walk
+ * @end: the guest page frame immediately after the last one to walk
+ * @asce: the ASCE of the guest mapping
+ * @ops: the gmap_walk_ops that will be used to perform the walk
+ * @flags: flags from WALK_* (currently only WALK_IGN_HOLES is supported)
+ * @priv: will be passed as-is to the callbacks
+ *
+ * Any callback returning non-zero causes the walk to stop immediately.
+ *
+ * Return: -EINVAL in case of error, -EFAULT if @start is too high for the given
+ *         asce unless the DAT_WALK_IGN_HOLES flag is specified, otherwise it
+ *         returns whatever the callbacks return.
+ */
+long _dat_walk_gfn_range(gfn_t start, gfn_t end, union asce asce,
+			 const struct dat_walk_ops *ops, int flags, void *priv)
+{
+	struct crst_table *table = dereference_asce(asce);
+	struct dat_walk walk = {
+		.ops	= ops,
+		.asce	= asce,
+		.priv	= priv,
+		.flags	= flags,
+		.start	= start,
+		.end	= end,
+	};
+
+	if (WARN_ON_ONCE(unlikely(!asce.val)))
+		return -EINVAL;
+	if (!asce_contains_gfn(asce, start))
+		return (flags & DAT_WALK_IGN_HOLES) ? 0 : -EFAULT;
+
+	return dat_crste_walk_range(start, min(end, asce_end(asce)), table, &walk);
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index 9e23f6cdbf73..de4bd2298945 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -346,6 +346,34 @@ struct page_table {
 static_assert(sizeof(struct crst_table) == _CRST_TABLE_SIZE);
 static_assert(sizeof(struct page_table) == PAGE_SIZE);
 
+struct dat_walk;
+
+typedef long (*dat_walk_op)(union crste *crste, gfn_t gfn, gfn_t next, struct dat_walk *w);
+
+struct dat_walk_ops {
+	union {
+		dat_walk_op crste_ops[4];
+		struct {
+			dat_walk_op pmd_entry;
+			dat_walk_op pud_entry;
+			dat_walk_op p4d_entry;
+			dat_walk_op pgd_entry;
+		};
+	};
+	long (*pte_entry)(union pte *pte, gfn_t gfn, gfn_t next, struct dat_walk *w);
+};
+
+struct dat_walk {
+	const struct dat_walk_ops *ops;
+	union crste *last;
+	union pte *last_pte;
+	union asce asce;
+	gfn_t start;
+	gfn_t end;
+	int flags;
+	void *priv;
+};
+
 static inline union pte _pte(kvm_pfn_t pfn, bool w, bool d, bool s)
 {
 	union pte res = { .val = PFN_PHYS(pfn) };
@@ -391,6 +419,11 @@ bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste ne
 			    union asce asce);
 void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce);
 
+long _dat_walk_gfn_range(gfn_t start, gfn_t end, union asce asce,
+			 const struct dat_walk_ops *ops, int flags, void *priv);
+
+int dat_entry_walk(gfn_t gfn, union asce asce, int flags, int walk_level,
+		   union crste **last, union pte **ptepp);
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct page_table *dat_alloc_pt(unsigned long pte_bits, unsigned long pgste_bits);
 struct crst_table *dat_alloc_crst(unsigned long init);
@@ -734,4 +767,9 @@ static inline void dat_crstep_clear(union crste *crstep, gfn_t gfn, union asce a
 	dat_crstep_xchg(crstep, newcrste, gfn, asce);
 }
 
+static inline int get_level(union crste *crstep, union pte *ptep)
+{
+	return ptep ? LEVEL_PTE : crstep->h.tt;
+}
+
 #endif /* __KVM_S390_DAT_H */
-- 
2.51.0


