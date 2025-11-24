Return-Path: <kvm+bounces-64367-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B4978C80538
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8D2CA4E7776
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CC23002CF;
	Mon, 24 Nov 2025 11:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jWMo2vle"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483A530496A;
	Mon, 24 Nov 2025 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985395; cv=none; b=eN8Ul7FWy3LOeBDX8ypPeD/gc8tDMy5LgAi1EZitqvxuZL04j/BLy9jszr+aRpQvdHtND3g81iNRxIt1Mvyfu4XWRcmA6+HDPTjEjIx5bxLZKAmudRVPvZbmQK1lyAW+MoMWbFsCh/Ov7LaCpzBX0JnSU/+G4+lvY6zNyh+llRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985395; c=relaxed/simple;
	bh=M2fDLRQcIUeYi+jtANrxorU8dpywiuJ/OYFL+jrCc/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ItC4Y5mASZsJsEh7d2LHgfAfqbhc2Lu0wZLjI8Bs3rjP96ZfcSFjV78d8WBG5t5yiauXU2AoP1Qyqf/JPiQ6Cdavae0goRIXJH9RWRpkn3ms+0Z4LvLsDV4Eh6TxDtUFrV/NOrxkVAs3U4kEL9ZlmW/OGrC7enT9FJY+65nFch0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jWMo2vle; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ANJjiQ7006252;
	Mon, 24 Nov 2025 11:56:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=mY/UakLG1hkWM9BAE
	MId+JSyIzShls9pkDbQKLHFqqQ=; b=jWMo2vleBMoYuPwigzBQrHGZmpIbgHsic
	DYfxsenptwECbqY5AppUjQANgOhLDMrWNKY4uq+eV47trFloaRnqYYqiXLL22RBL
	r6mlEiESG2DBB+tyw6jv9pIXIDQ87GxyHipxZjeMv8wLK1M9o7ZEYi3/3p6kBbOH
	K1voXAbh9CPEFfZV8AD/OUV/3oigYq0eJECrknoewpGLmao7N+9+hrIqClJXAHf8
	FqnGBo1ED7Fukk8oeFRyxg6pvEtRKvWDkVW9PLcLQUhSCygwywJdwWZ1s2jPfMUF
	LW/MDvEW3wMC13fdd+bU1gW7T5OQbIACr7kfVG4oKiMoTxfKCrAZQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4uuywv3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:19 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AO8F3pi025116;
	Mon, 24 Nov 2025 11:56:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akt715e6h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:18 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBuFWs39059808
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:15 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2059F20043;
	Mon, 24 Nov 2025 11:56:15 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8568520040;
	Mon, 24 Nov 2025 11:56:13 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:13 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 10/23] KVM: s390: KVM page table management functions: walks
Date: Mon, 24 Nov 2025 12:55:41 +0100
Message-ID: <20251124115554.27049-11-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAyMSBTYWx0ZWRfXxMQwDw6WJegR
 Q9NEs8OV2BsPsFW4y5SnCjobBQp5QdrToTWFMw/GxNTB0bcQ8BflYdZQNe9PYq10xbuUIMw0Vj0
 VSZOqO7GuH6zkPHGcp4MD5GA+HxgX68vdLmqOX2mIbP+3GCyHPm7btAz8OBDz6RXy3NxDQDqucW
 at6Y8aLF1r/WQZACFaadFEfVz8DjCpSURrdPsv6KZqsOh8VvznQFJVUfwBqPEth3mb9KOdf5J9d
 4XGHS0u2iMagW/JGXnYIFIcq3IbMmvKfzp1Q3qhb7t2ISazrggk9uEXRH6f/VCfdU9qHbhku6/H
 79nue73ocMx+C9EZkbqmR1ao3x+vSFPFDJxy9nND8b+D3tlgl3MbdlQmngcwEhitZ1Uwvs34XUl
 bZnU57qAGfeYVzIW3xCdqtfrlw/q+w==
X-Authority-Analysis: v=2.4 cv=PLoCOPqC c=1 sm=1 tr=0 ts=692447e3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=FjFqaoouhZgXAMKSwZQA:9
X-Proofpoint-ORIG-GUID: zwdxoCMpiPL13H1gPUeA9gj20J9Lm0bI
X-Proofpoint-GUID: zwdxoCMpiPL13H1gPUeA9gj20J9Lm0bI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 spamscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 clxscore=1015 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511220021

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to walk to specific table entries, or to
perform actions on a range of entries.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 386 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  39 +++++
 2 files changed, 425 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index a9d5b49ac411..3158652dbe8e 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -219,3 +219,389 @@ union pgste __dat_ptep_xchg(union pte *ptep, union pgste pgste, union pte new, g
 	WRITE_ONCE(*ptep, new);
 	return pgste;
 }
+
+/*
+ * dat_split_ste - Split a segment table entry into page table entries
+ *
+ * Context: This function is assumed to be called with kvm->mmu_lock held.
+ *
+ * Return: 0 in case of success, -ENOMEM if running out of memory.
+ */
+static int dat_split_ste(struct kvm_s390_mmu_cache *mc, union pmd *pmdp, gfn_t gfn,
+			 union asce asce, bool uses_skeys)
+{
+	union pgste pgste_init;
+	struct page_table *pt;
+	union pmd new, old;
+	union pte init;
+	int i;
+
+	BUG_ON(!mc);
+	old = READ_ONCE(*pmdp);
+
+	/* Already split, nothing to do */
+	if (!old.h.i && !old.h.fc)
+		return 0;
+
+	pt = dat_alloc_pt_noinit(mc);
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
+		pgste_init.val = 0;
+		if (old.h.fc) {
+			for (i = 0; i < _PAGE_ENTRIES; i++)
+				pt->ptes[i].val = init.val | i * PAGE_SIZE;
+			/* no need to take locks as the page table is not installed yet */
+			pgste_init.prefix_notif = old.s.fc1.prefix_notif;
+			pgste_init.pcl = uses_skeys && init.h.i;
+			dat_init_pgstes(pt, pgste_init.val);
+		} else {
+			dat_init_page_table(pt, init.val, 0);
+		}
+
+		if (dat_pmdp_xchg_atomic(pmdp, old, new, gfn, asce)) {
+			if (!pgste_init.pcl)
+				return 0;
+			for (i = 0; i < _PAGE_ENTRIES; i++) {
+				union pgste pgste = pt->pgstes[i];
+
+				pgste = dat_save_storage_key_into_pgste(pt->ptes[i], pgste);
+				pgste_set_unlock(pt->ptes + i, pgste);
+			}
+			return 0;
+		}
+		old = READ_ONCE(*pmdp);
+	}
+
+	dat_free_pt(pt);
+	return 0;
+}
+
+/*
+ * dat_split_crste - Split a crste into smaller crstes
+ *
+ * Context: This function is assumed to be called with kvm->mmu_lock held.
+ *
+ * Return: 0 in case of success, -ENOMEM if running out of memory.
+ */
+static int dat_split_crste(struct kvm_s390_mmu_cache *mc, union crste *crstep,
+			   gfn_t gfn, union asce asce, bool uses_skeys)
+{
+	struct crst_table *table;
+	union crste old, new, init;
+	int i;
+
+	old = READ_ONCE(*crstep);
+	if (is_pmd(old))
+		return dat_split_ste(mc, &crstep->pmd, gfn, asce, uses_skeys);
+
+	BUG_ON(!mc);
+
+	/* Already split, nothing to do */
+	if (!old.h.i && !old.h.fc)
+		return 0;
+
+	table = dat_alloc_crst_noinit(mc);
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
+ * @mc: cache to use to allocate dat tables, if needed; can be NULL if neither
+ *      @DAT_WALK_SPLIT or @DAT_WALK_ALLOC is specified.
+ * @gfn: guest frame
+ * @asce: the ASCE of the address space
+ * @flags: flags from WALK_* macros
+ * @walk_level: level to walk to, from LEVEL_* macros
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
+ * * @DAT_WALK_USES_SKEYS: storage keys are in use
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
+int dat_entry_walk(struct kvm_s390_mmu_cache *mc, gfn_t gfn, union asce asce, int flags,
+		   int walk_level, union crste **last, union pte **ptepp)
+{
+	union vaddress vaddr = { .addr = gfn_to_gpa(gfn) };
+	bool continue_anyway = flags & DAT_WALK_CONTINUE;
+	bool uses_skeys = flags & DAT_WALK_USES_SKEYS;
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
+		*last = table->crstes + vaddr.rfx;
+		entry = READ_ONCE(**last);
+		if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_REGION1))
+			return -EINVAL;
+		if (crste_hole(entry) && !ign_holes)
+			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+		if (walk_level == TABLE_TYPE_REGION1)
+			return 0;
+		if (entry.pgd.h.i) {
+			if (!allocate)
+				return any ? 0 : -ENOENT;
+			rc = dat_split_crste(mc, *last, gfn, asce, uses_skeys);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		table = dereference_crste(entry.pgd);
+	}
+
+	if (asce.dt >= ASCE_TYPE_REGION2) {
+		*last = table->crstes + vaddr.rsx;
+		entry = READ_ONCE(**last);
+		if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_REGION2))
+			return -EINVAL;
+		if (crste_hole(entry) && !ign_holes)
+			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+		if (walk_level == TABLE_TYPE_REGION2)
+			return 0;
+		if (entry.p4d.h.i) {
+			if (!allocate)
+				return any ? 0 : -ENOENT;
+			rc = dat_split_crste(mc, *last, gfn, asce, uses_skeys);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		table = dereference_crste(entry.p4d);
+	}
+
+	if (asce.dt >= ASCE_TYPE_REGION3) {
+		*last = table->crstes + vaddr.rtx;
+		entry = READ_ONCE(**last);
+		if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_REGION3))
+			return -EINVAL;
+		if (crste_hole(entry) && !ign_holes)
+			return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+		if (walk_level == TABLE_TYPE_REGION3 &&
+		    continue_anyway && !entry.pud.h.fc && !entry.h.i) {
+			walk_level = TABLE_TYPE_PAGE_TABLE;
+			allocate = false;
+		}
+		if (walk_level == TABLE_TYPE_REGION3 || ((leaf || any) && entry.pud.h.fc))
+			return 0;
+		if (entry.pud.h.i && !entry.pud.h.fc) {
+			if (!allocate)
+				return any ? 0 : -ENOENT;
+			rc = dat_split_crste(mc, *last, gfn, asce, uses_skeys);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		if (walk_level <= TABLE_TYPE_SEGMENT && entry.pud.h.fc) {
+			if (!split)
+				return -EFBIG;
+			rc = dat_split_crste(mc, *last, gfn, asce, uses_skeys);
+			if (rc)
+				return rc;
+			entry = READ_ONCE(**last);
+		}
+		table = dereference_crste(entry.pud);
+	}
+
+	*last = table->crstes + vaddr.sx;
+	entry = READ_ONCE(**last);
+	if (WARN_ON_ONCE(entry.h.tt != TABLE_TYPE_SEGMENT))
+		return -EINVAL;
+	if (crste_hole(entry) && !ign_holes)
+		return entry.tok.type == _DAT_TOKEN_PIC ? entry.tok.par : -EFAULT;
+	if (continue_anyway && !entry.pmd.h.fc && !entry.h.i) {
+		walk_level = TABLE_TYPE_PAGE_TABLE;
+		allocate = false;
+	}
+	if (walk_level == TABLE_TYPE_SEGMENT || ((leaf || any) && entry.pmd.h.fc))
+		return 0;
+
+	if (entry.pmd.h.i && !entry.pmd.h.fc) {
+		if (!allocate)
+			return any ? 0 : -ENOENT;
+		rc = dat_split_ste(mc, &(*last)->pmd, gfn, asce, uses_skeys);
+		if (rc)
+			return rc;
+		entry = READ_ONCE(**last);
+	}
+	if (walk_level <= TABLE_TYPE_PAGE_TABLE && entry.pmd.h.fc) {
+		if (!split)
+			return -EFBIG;
+		rc = dat_split_ste(mc, &(*last)->pmd, gfn, asce, uses_skeys);
+		if (rc)
+			return rc;
+		entry = READ_ONCE(**last);
+	}
+	pgtable = dereference_pmd(entry.pmd);
+	*ptepp = pgtable->ptes + vaddr.px;
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
index 6a336c3c6f62..5488bdc1a79b 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -45,6 +45,7 @@ enum {
 #define TABLE_TYPE_PAGE_TABLE -1
 
 enum dat_walk_flags {
+	DAT_WALK_USES_SKEYS	= 0x40,
 	DAT_WALK_CONTINUE	= 0x20,
 	DAT_WALK_IGN_HOLES	= 0x10,
 	DAT_WALK_SPLIT		= 0x08,
@@ -332,6 +333,34 @@ struct page_table {
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
 /**
  * _pte() - Useful constructor for union pte
  * @pfn: the pfn this pte should point to.
@@ -436,6 +465,11 @@ bool dat_crstep_xchg_atomic(union crste *crstep, union crste old, union crste ne
 			    union asce asce);
 void dat_crstep_xchg(union crste *crstep, union crste new, gfn_t gfn, union asce asce);
 
+long _dat_walk_gfn_range(gfn_t start, gfn_t end, union asce asce,
+			 const struct dat_walk_ops *ops, int flags, void *priv);
+
+int dat_entry_walk(struct kvm_s390_mmu_cache *mc, gfn_t gfn, union asce asce, int flags,
+		   int walk_level, union crste **last, union pte **ptepp);
 void dat_free_level(struct crst_table *table, bool owns_ptes);
 struct crst_table *dat_alloc_crst_sleepable(unsigned long init);
 
@@ -834,4 +868,9 @@ static inline void dat_crstep_clear(union crste *crstep, gfn_t gfn, union asce a
 	dat_crstep_xchg(crstep, newcrste, gfn, asce);
 }
 
+static inline int get_level(union crste *crstep, union pte *ptep)
+{
+	return ptep ? TABLE_TYPE_PAGE_TABLE : crstep->h.tt;
+}
+
 #endif /* __KVM_S390_DAT_H */
-- 
2.51.1


