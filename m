Return-Path: <kvm+bounces-57230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C9FB51FD7
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 20:08:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3AFB16A2E2
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 18:08:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9F68338F38;
	Wed, 10 Sep 2025 18:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R4gtk66t"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D22340DAE;
	Wed, 10 Sep 2025 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527679; cv=none; b=P6fN7Kfi02v9wO48cYQNzyT/SaYmj9dWBzqjE5ltpRFchFRNu99jUWopoMqEQhv85fdDA+PgacO2jJdk9qKpb37nF8qcJSDQWjp9wrWJ/UbGUL79xhFHwLj1gUwajIUGWKzcoASr4H35UfjJLUBxjyIphTp0fKTx7Y2TmwL7GJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527679; c=relaxed/simple;
	bh=uwC7sYimXv8BwQ/XcKGdmMsGBZ11LpmlOY7irHUsWtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rs8qYgHEixLxZDk3MnEsJL61rW8MCBO+6s2hK9fRnQgF1ikxqT2Gpg5s19uor77izA4MOX0lDXvSxbqBqnbv21kBvglX71QuPq1EZElXVZXZNbXhYXNdBRHcmVgKxobNqZ2CqkHCCFfWF+xq2PmJspAYiECWYLhPCVezHH5TcgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R4gtk66t; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AFfXiq015555;
	Wed, 10 Sep 2025 18:07:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ddkthkXP9gPSiHTwD
	E83KWJuFtztblfRaUKGIJJukfk=; b=R4gtk66t/yW6Ll/RVFH8kLptXQ4nZeXFz
	IVBC3fBVigNzpH/nziqi4lihcTd5YGLhsf8FDdfAQL63tHYwN7PNevkTD8x4LUe3
	coF58WY4yAW2NCr/r+zRBTjZvFxWjc6Z8M4Jp/0YVg0jAxdVbAop2zKb4uRfsq9+
	dkvxKJ6CQ9vcHai+R1DZ8kX4lbLjYxI6U6xo16wF5c1L1WIfZ2B9E0s3mmhy/KUh
	cXpmG8AYu3tY4HLC6uYH82RREhrItVetY8miV7GE7UtPnce2kAEulR/FvCqlkHa6
	xzN4h0c5bJwlZK9tLCYf5JrhDPEQCDzwwPid3YhTqtCaA01qr3JzQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cffg2c4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58AHAGm5007965;
	Wed, 10 Sep 2025 18:07:54 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49109psv30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 10 Sep 2025 18:07:54 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58AI7oe728050090
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 18:07:50 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3834E2004B;
	Wed, 10 Sep 2025 18:07:50 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EE92F2004D;
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
Subject: [PATCH v2 13/20] KVM: s390: KVM page table management functions: CMMA
Date: Wed, 10 Sep 2025 20:07:39 +0200
Message-ID: <20250910180746.125776-14-imbrenda@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: k3MCy8utcfo-BB326fd_mI58ekU6YEZu
X-Proofpoint-GUID: k3MCy8utcfo-BB326fd_mI58ekU6YEZu
X-Authority-Analysis: v=2.4 cv=EYDIQOmC c=1 sm=1 tr=0 ts=68c1be7b cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=XQIW6j_J4to4VNKvMa8A:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyMCBTYWx0ZWRfX/QvjtkeYaN9P
 kk3bmsBoaeM0Lool+9AiFgL6tlKDDDPz2/2udarcrNK3Adfa0Qk0ptjvaLCqTQcsRzPdmF/yyrR
 maKyQqmLFadL+oIGlfAIjjwGPfC2HdV2VCDOcktY4gwp/kwyY+dyU+3W9yeEtWmKaqeDG0Hn09z
 dmL9JSyhbtgVMxciVZ1JvFnyuRQRJ5oniO9kTDIA/YCc9P5Komyzaz1VIGn5lxmnE1xt8yrOxyZ
 m0JqndqH8MM2IPG2H4UXW+xAm+r80O805FKfUHXMiuCJe1fFOF1jV1NA+SWefn5we8LPoYuwd+2
 CLzPYuGwTVGkVa05xRVha9vFcg41DL35VpJzib4ck9vuARDD8o3+DNY0coBXECzkDy6R8sU2ATe
 mIfABEES
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

This patch adds functions to handle CMMA and the ESSA instruction.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 arch/s390/kvm/dat.c | 259 ++++++++++++++++++++++++++++++++++++++++++++
 arch/s390/kvm/dat.h |  27 +++++
 2 files changed, 286 insertions(+)

diff --git a/arch/s390/kvm/dat.c b/arch/s390/kvm/dat.c
index 4249400a9d21..bf9c8af1d74a 100644
--- a/arch/s390/kvm/dat.c
+++ b/arch/s390/kvm/dat.c
@@ -999,3 +999,262 @@ int dat_set_prefix_notif_bit(union asce asce, gfn_t gfn)
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
+	if (dat_entry_walk(gfn, asce, 0, LEVEL_PTE, &crstep, &ptep)) {
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
+int dat_set_cmma_bits(union asce asce, gfn_t gfn, unsigned long count,
+		      unsigned long mask, const uint8_t *bits)
+{
+	const struct dat_walk_ops ops = { .pte_entry = __dat_set_cmma_pte, };
+	struct dat_set_cmma_state state = { .mask = mask, .bits = bits, };
+	union crste *crstep;
+	union pte *ptep;
+	gfn_t cur;
+	int rc;
+
+	for (cur = ALIGN_DOWN(gfn, _PAGE_ENTRIES); cur < gfn + count; cur += _PAGE_ENTRIES)
+		dat_entry_walk(cur, asce, DAT_WALK_ALLOC, LEVEL_PTE, &crstep, &ptep);
+	rc = _dat_walk_gfn_range(gfn, gfn + count, asce, &ops, DAT_WALK_IGN_HOLES, &state);
+	return rc;
+}
diff --git a/arch/s390/kvm/dat.h b/arch/s390/kvm/dat.h
index b695eae5d763..4d0ceeada40f 100644
--- a/arch/s390/kvm/dat.h
+++ b/arch/s390/kvm/dat.h
@@ -18,6 +18,15 @@
 #include <asm/pgalloc.h>
 #include <asm/dat-bits.h>
 
+/*
+ * Base address and length must be sent at the start of each block, therefore
+ * it's cheaper to send some clean data, as long as it's less than the size of
+ * two longs.
+ */
+#define KVM_S390_MAX_BIT_DISTANCE (2 * sizeof(void *))
+/* for consistency */
+#define KVM_S390_CMMA_SIZE_MAX ((u32)KVM_S390_SKEYS_MAX)
+
 #define _ASCE(x) ((union asce) { .val = (x), })
 #define NULL_ASCE _ASCE(0)
 
@@ -418,6 +427,17 @@ static inline union crste _crste_fc1(kvm_pfn_t pfn, int tt, bool w, bool d)
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
  *	0	1	2	3	4	5	6	7
  *	+-------+-------+-------+-------+-------+-------+-------+-------+
@@ -459,6 +479,13 @@ int dat_set_prefix_notif_bit(union asce asce, gfn_t gfn);
 bool dat_test_age_gfn(union asce asce, gfn_t start, gfn_t end);
 int dat_link(kvm_pfn_t pfn, gfn_t gfn, union asce asce, int level, bool w, bool d, bool s, bool sk);
 
+int dat_perform_essa(union asce asce, gfn_t gfn, int orc, union essa_state *state, bool *dirty);
+long dat_reset_cmma(union asce asce, gfn_t start_gfn);
+int dat_peek_cmma(gfn_t start, union asce asce, unsigned int *count, u8 *values);
+int dat_get_cmma(union asce asce, gfn_t *start, unsigned int *count, u8 *values, atomic64_t *rem);
+int dat_set_cmma_bits(union asce asce, gfn_t gfn, unsigned long count, unsigned long mask,
+		      const uint8_t *bits);
+
 static inline struct crst_table *crste_table_start(union crste *crstep)
 {
 	return (struct crst_table *)ALIGN_DOWN((unsigned long)crstep, _CRST_TABLE_SIZE);
-- 
2.51.0


