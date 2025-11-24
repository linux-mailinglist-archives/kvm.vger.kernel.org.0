Return-Path: <kvm+bounces-64364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 13CCAC8050E
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 13:00:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AEEDC4E6E5B
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 11:58:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A36A305040;
	Mon, 24 Nov 2025 11:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QAM4aK3x"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC43303A15;
	Mon, 24 Nov 2025 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763985391; cv=none; b=lF0mphEaD/Vy9K36njUMjMpuPtMW/oObj6+Ez8rfonrozeOqmX+rM2IHDBspAoedxnd/sd8R/fG8Xl8dovESlPAjiFrIUmhnxPKPQZP5R7Ete8KqUU6K6y2oJz2NbqdIgAzudPB8fldI1Is/sd3M/gBXHVyLUMeRdvSWbpK7sfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763985391; c=relaxed/simple;
	bh=cDF9QfRk4KmQkzN+O3hGXDs4rJ0qCMQcZ7vRqzi1HNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jv8YAGgjgpNjl7L79fXHMVvpAn99jhoLIqUziadYB62ZGsWuDH5c1dKEMEyGkR+z608QQWS9uQaL62vlyZ6j5woj6P6NIaQHERJYDhPmSRa+OAHjQb2E4u7vA/aSNINvER5ECnMdMS24PlNR8/dRnfrdKr97l8mubiDggX4TXzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QAM4aK3x; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ANNgwOj006577;
	Mon, 24 Nov 2025 11:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=NehZAcFLNgCECBINh
	+4yW4MejKnQ38LymiQ2711iBOA=; b=QAM4aK3xlL+X+UdxW4HJm7T2pmKp2b2ZP
	5F+sp5BRP7irc6KB7b8vki7+iTHJdQM+lwj9p2UWi/z8mVQ3tvkcnLEgS4FuDASt
	K9LyVgkiCiCpWAeS4vbPKhs6nAZ0FWjHsVj0UIHWukaR+sYXTByt2buXdPzTp/Z+
	M1NfvIGuBKFJakskZGFmdq0zVTiZ3hib+1+pxondLMIUqBqjpTju6/td/RwZo+Po
	C3XUdmGL1iy90m4ewYSbqwYP0zxiITiho6y6gvOCG1AvPJ3gDML8A5loooKDzeKn
	5eRLGfjQsrRRi1xW0TsE6sb1nx4Aj8pzMvc/05N9jFRd1KGnokWrg==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak2kpqnru-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:24 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AOBnQgG019041;
	Mon, 24 Nov 2025 11:56:24 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aksqjdg4s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 24 Nov 2025 11:56:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AOBuKI060686788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 24 Nov 2025 11:56:20 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49DD12004B;
	Mon, 24 Nov 2025 11:56:20 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A291420040;
	Mon, 24 Nov 2025 11:56:18 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.111.31.86])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 24 Nov 2025 11:56:18 +0000 (GMT)
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, seiden@linux.ibm.com, gra@linux.ibm.com,
        schlameuss@linux.ibm.com, hca@linux.ibm.com, svens@linux.ibm.com,
        agordeev@linux.ibm.com, gor@linux.ibm.com, david@redhat.com,
        gerald.schaefer@linux.ibm.com
Subject: [PATCH v5 13/23] KVM: s390: KVM page table management functions: CMMA
Date: Mon, 24 Nov 2025 12:55:44 +0100
Message-ID: <20251124115554.27049-14-imbrenda@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAwMCBTYWx0ZWRfX5d8btDiI+v/3
 s0Gaawu1ReZyJP8JAjiMTseh9Vl0c3IWfGkKxY5PIMicPUqCFKqenivDQTHCjRBGrfqZqpyz5qc
 nWqOC0l0tH+2Sa+s4WWzTn8PpSaMSPhBaITZwIqDaY/B1BQ9D+yrOmLqCtYSuQuBZU3uv7z1Nh0
 w7b3HyrCZNn7F2T57jWqnSBJnizaobdS2i/bi2OoSPogYj42RByLrTdduLx/rpvUjsvfMnkFLsw
 Y1K8ZGUt2a/qZ+KHpwadGPDrS1FPgCKrzsfwiybeQ6Tb5Q0bGdAth1kIVwbXKSWuuFMMmTK7Qjb
 7ycbnfcDAFfAMvAQHV7bXUF7I4CZTiQTnVOoRE6MsaP3pu8WzzJyOujGGtDh1OdbgwcqvYmUU00
 JxM8SjjoCxxn7vfMGbHDzNHoBcc3uw==
X-Authority-Analysis: v=2.4 cv=fJM0HJae c=1 sm=1 tr=0 ts=692447e9 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8
 a=XQIW6j_J4to4VNKvMa8A:9
X-Proofpoint-GUID: m2QZg-XITv0ByaBnGGCJ3LJJYo1SmVCf
X-Proofpoint-ORIG-GUID: m2QZg-XITv0ByaBnGGCJ3LJJYo1SmVCf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-24_04,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 priorityscore=1501 impostorscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 adultscore=0 bulkscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220000

Add page table management functions to be used for KVM guest (gmap)
page tables.

This patch adds functions to handle CMMA and the ESSA instruction.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 262 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  27 +++++
 2 files changed, 289 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index cafbcb665da4..458e725315cc 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -1104,3 +1104,265 @@ int dat_set_prefix_notif_bit(union asce asce, gfn_t gfn)
 		return -EAGAIN;
 	return 0;
 }
+
+/**
+ * dat_perform_essa() - perform ESSA actions on the PGSTE.
+ * @asce: the asce to operate on.
+ * @gfn: the guest page frame to operate on.
+ * @orc: the specific action to perform, see the ESSA_SET_* macros.
+ * @state: the storage attributes to be returned to the guest.
+ * @dirty: returns whether the function dirtied a previously clean entry.
+ *
+ * Context: Called with kvm->mmu_lock held.
+ *
+ * Return:
+ * * 1 if the page state has been altered and the page is to be added to the CBRL
+ * * 0 if the page state has been altered, but the page is not to be added to the CBRL
+ * * -1 if the page state has not been altered and the page is not to be added to the CBRL
+ */
+int dat_perform_essa(union asce asce, gfn_t gfn, int orc, union essa_state *state, bool *dirty)
+{
+	union crste *crstep;
+	union pgste pgste;
+	union pte *ptep;
+	int res = 0;
+
+	if (dat_entry_walk(NULL, gfn, asce, 0, TABLE_TYPE_PAGE_TABLE, &crstep, &ptep)) {
+		*state = (union essa_state) { .exception = 1 };
+		return -1;
+	}
+
+	pgste = pgste_get_lock(ptep);
+
+	*state = (union essa_state) {
+		.content = (ptep->h.i << 1) + (ptep->h.i && pgste.zero),
+		.nodat = pgste.nodat,
+		.usage = pgste.usage,
+		};
+
+	switch (orc) {
+	case ESSA_GET_STATE:
+		res = -1;
+		break;
+	case ESSA_SET_STABLE:
+		pgste.usage = PGSTE_GPS_USAGE_STABLE;
+		pgste.nodat = 0;
+		break;
+	case ESSA_SET_UNUSED:
+		pgste.usage = PGSTE_GPS_USAGE_UNUSED;
+		if (ptep->h.i)
+			res = 1;
+		break;
+	case ESSA_SET_VOLATILE:
+		pgste.usage = PGSTE_GPS_USAGE_VOLATILE;
+		if (ptep->h.i)
+			res = 1;
+		break;
+	case ESSA_SET_POT_VOLATILE:
+		if (!ptep->h.i) {
+			pgste.usage = PGSTE_GPS_USAGE_POT_VOLATILE;
+		} else if (pgste.zero) {
+			pgste.usage = PGSTE_GPS_USAGE_VOLATILE;
+		} else if (!pgste.gc) {
+			pgste.usage = PGSTE_GPS_USAGE_VOLATILE;
+			res = 1;
+		}
+		break;
+	case ESSA_SET_STABLE_RESIDENT:
+		pgste.usage = PGSTE_GPS_USAGE_STABLE;
+		/*
+		 * Since the resident state can go away any time after this
+		 * call, we will not make this page resident. We can revisit
+		 * this decision if a guest will ever start using this.
+		 */
+		break;
+	case ESSA_SET_STABLE_IF_RESIDENT:
+		if (!ptep->h.i)
+			pgste.usage = PGSTE_GPS_USAGE_STABLE;
+		break;
+	case ESSA_SET_STABLE_NODAT:
+		pgste.usage = PGSTE_GPS_USAGE_STABLE;
+		pgste.nodat = 1;
+		break;
+	default:
+		WARN_ONCE(1, "Invalid ORC!");
+		res = -1;
+		break;
+	}
+	/* If we are discarding a page, set it to logical zero */
+	pgste.zero = res == 1;
+	if (orc > 0) {
+		*dirty = !pgste.cmma_d;
+		pgste.cmma_d = 1;
+	}
+
+	pgste_set_unlock(ptep, pgste);
+
+	return res;
+}
+
+static long dat_reset_cmma_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	pgste.usage = 0;
+	pgste.nodat = 0;
+	pgste.cmma_d = 0;
+	pgste_set_unlock(ptep, pgste);
+	if (need_resched())
+		return next;
+	return 0;
+}
+
+long dat_reset_cmma(union asce asce, gfn_t start)
+{
+	const struct dat_walk_ops dat_reset_cmma_ops = {
+		.pte_entry = dat_reset_cmma_pte,
+	};
+
+	return _dat_walk_gfn_range(start, asce_end(asce), asce, &dat_reset_cmma_ops,
+				   DAT_WALK_IGN_HOLES, NULL);
+}
+
+struct dat_get_cmma_state {
+	gfn_t start;
+	gfn_t end;
+	unsigned int count;
+	u8 *values;
+	atomic64_t *remaining;
+};
+
+static long __dat_peek_cmma_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct dat_get_cmma_state *state = walk->priv;
+	union pgste pgste;
+
+	pgste = pgste_get_lock(ptep);
+	state->values[gfn - walk->start] = pgste.usage | (pgste.nodat << 6);
+	pgste_set_unlock(ptep, pgste);
+	state->end = next;
+
+	return 0;
+}
+
+static long __dat_peek_cmma_crste(union crste *crstep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct dat_get_cmma_state *state = walk->priv;
+
+	if (crstep->h.i)
+		state->end = min(walk->end, next);
+	return 0;
+}
+
+int dat_peek_cmma(gfn_t start, union asce asce, unsigned int *count, u8 *values)
+{
+	const struct dat_walk_ops ops = {
+		.pte_entry = __dat_peek_cmma_pte,
+		.pmd_entry = __dat_peek_cmma_crste,
+		.pud_entry = __dat_peek_cmma_crste,
+		.p4d_entry = __dat_peek_cmma_crste,
+		.pgd_entry = __dat_peek_cmma_crste,
+	};
+	struct dat_get_cmma_state state = { .values = values, };
+	int rc;
+
+	rc = _dat_walk_gfn_range(start, start + *count, asce, &ops, DAT_WALK_DEFAULT, &state);
+	*count = state.end - start;
+	/* Return success if at least one value was saved, otherwise an error. */
+	return (rc == -EFAULT && *count > 0) ? 0 : rc;
+}
+
+static long __dat_get_cmma_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct dat_get_cmma_state *state = walk->priv;
+	union pgste pgste;
+
+	if (state->start != -1) {
+		if ((gfn - state->end) > KVM_S390_MAX_BIT_DISTANCE)
+			return 1;
+		if (gfn - state->start >= state->count)
+			return 1;
+	}
+
+	if (!READ_ONCE(*pgste_of(ptep)).cmma_d)
+		return 0;
+
+	pgste = pgste_get_lock(ptep);
+	if (pgste.cmma_d) {
+		if (state->start == -1)
+			state->start = gfn;
+		pgste.cmma_d = 0;
+		atomic64_dec(state->remaining);
+		state->values[gfn - state->start] = pgste.usage | pgste.nodat << 6;
+		state->end = next;
+	}
+	pgste_set_unlock(ptep, pgste);
+	return 0;
+}
+
+int dat_get_cmma(union asce asce, gfn_t *start, unsigned int *count, u8 *values, atomic64_t *rem)
+{
+	const struct dat_walk_ops ops = { .pte_entry = __dat_get_cmma_pte, };
+	struct dat_get_cmma_state state = {
+		.remaining = rem,
+		.values = values,
+		.count = *count,
+		.start = -1,
+	};
+
+	_dat_walk_gfn_range(*start, asce_end(asce), asce, &ops, DAT_WALK_IGN_HOLES, &state);
+
+	if (state.start == -1) {
+		*count = 0;
+	} else {
+		*count = state.end - state.start;
+		*start = state.start;
+	}
+
+	return 0;
+}
+
+struct dat_set_cmma_state {
+	unsigned long mask;
+	const u8 *bits;
+};
+
+static long __dat_set_cmma_pte(union pte *ptep, gfn_t gfn, gfn_t next, struct dat_walk *walk)
+{
+	struct dat_set_cmma_state *state = walk->priv;
+	union pgste pgste, tmp;
+
+	tmp.val = (state->bits[gfn - walk->start] << 24) & state->mask;
+
+	pgste = pgste_get_lock(ptep);
+	pgste.usage = tmp.usage;
+	pgste.nodat = tmp.nodat;
+	pgste_set_unlock(ptep, pgste);
+
+	return 0;
+}
+
+/*
+ * This function sets the CMMA attributes for the given pages. If the input
+ * buffer has zero length, no action is taken, otherwise the attributes are
+ * set and the mm->context.uses_cmm flag is set.
+ */
+int dat_set_cmma_bits(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
+		      unsigned long count, unsigned long mask, const uint8_t *bits)
+{
+	const struct dat_walk_ops ops = { .pte_entry = __dat_set_cmma_pte, };
+	struct dat_set_cmma_state state = { .mask = mask, .bits = bits, };
+	union crste *crstep;
+	union pte *ptep;
+	gfn_t cur;
+	int rc;
+
+	for (cur = ALIGN_DOWN(gfn, _PAGE_ENTRIES); cur < gfn + count; cur += _PAGE_ENTRIES) {
+		rc = dat_entry_walk(mc, cur, asce, DAT_WALK_ALLOC, TABLE_TYPE_PAGE_TABLE,
+				    &crstep, &ptep);
+		if (rc)
+			return rc;
+	}
+	return _dat_walk_gfn_range(gfn, gfn + count, asce, &ops, DAT_WALK_IGN_HOLES, &state);
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index c8df33f95160..4190a54224c0 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -17,6 +17,15 @@
 #include <asm/tlbflush.h>
 #include <asm/dat-bits.h>
 
+/*
+ * Base address and length must be sent at the start of each block, therefore
+ * it's cheaper to send some clean data, as long as it's less than the size of
+ * two longs.
+ */
+#define KVM_S390_MAX_BIT_DISTANCE (2 * sizeof(void *))
+/* For consistency */
+#define KVM_S390_CMMA_SIZE_MAX ((u32)KVM_S390_SKEYS_MAX)
+
 #define _ASCE(x) ((union asce) { .val = (x), })
 #define NULL_ASCE _ASCE(0)
 
@@ -433,6 +442,17 @@ static inline union crste _crste_fc1(kvm_pfn_t pfn, int tt, bool writable, bool
 	return res;
 }
 
+union essa_state {
+	unsigned char val;
+	struct {
+		unsigned char		: 2;
+		unsigned char nodat	: 1;
+		unsigned char exception	: 1;
+		unsigned char usage	: 2;
+		unsigned char content	: 2;
+	};
+};
+
 /**
  * struct vsie_rmap - reverse mapping for shadow page table entries
  * @next: pointer to next rmap in the list
@@ -522,6 +542,13 @@ bool dat_test_age_gfn(union asce asce, gfn_t start, gfn_t end);
 int dat_link(struct kvm_s390_mmu_cache *mc, union asce asce, int level,
 	     bool uses_skeys, struct guest_fault *f);
 
+int dat_perform_essa(union asce asce, gfn_t gfn, int orc, union essa_state *state, bool *dirty);
+long dat_reset_cmma(union asce asce, gfn_t start_gfn);
+int dat_peek_cmma(gfn_t start, union asce asce, unsigned int *count, u8 *values);
+int dat_get_cmma(union asce asce, gfn_t *start, unsigned int *count, u8 *values, atomic64_t *rem);
+int dat_set_cmma_bits(struct kvm_s390_mmu_cache *mc, union asce asce, gfn_t gfn,
+		      unsigned long count, unsigned long mask, const uint8_t *bits);
+
 int kvm_s390_mmu_cache_topup(struct kvm_s390_mmu_cache *mc);
 
 #define GFP_KVM_S390_MMU_CACHE (GFP_ATOMIC | __GFP_ACCOUNT | __GFP_NOWARN)
-- 
2.51.1


