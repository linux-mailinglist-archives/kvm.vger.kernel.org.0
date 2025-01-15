Return-Path: <kvm+bounces-35558-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7336A12644
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 15:40:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DBC82168E59
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 14:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8AA512AAE2;
	Wed, 15 Jan 2025 14:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nGBLbdVy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04A4A86350;
	Wed, 15 Jan 2025 14:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736952036; cv=none; b=NSck2MFeqUqso3EODPakQi81ChEj8qv75Utnr+jkgf9VkaBNUFtDn7LlJ6e3ycttV4WPKB7ZFJYSFwcEeI0b1w43mDX/24A5YmKj2+aTVOrmx4qe88Ef0hIssIqKnHE0DnKAtyZCkEAS7NHW3lpgSr2JsLkMTjT1p6gQZ+Y54Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736952036; c=relaxed/simple;
	bh=f5ugfE9b4D4CFORjFju/YSQJY5wVgTJk0sXjIXSPCpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QcTGIWEK8FdhXSZ6o362z2kuFrw5T5oa673LpCRePFmGUt6cU0PgH12jcQmrlMTDA7xAff5NaFQqcVsqldc1WVctI0phoKpLIA9BQF5lLlEmR9uis57dDBcWjtrtCqlZEnWuso1uPbBKyGNF4mvJi8fg0Do1hHI/4UQ/oFlqyIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nGBLbdVy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50F85mvb017903;
	Wed, 15 Jan 2025 14:40:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Xd98BqG0uZLws1rzL
	6/e5RwRk8WhkMxd8z1ZoOfRVPI=; b=nGBLbdVyF9FLGODaJysJOPoRoC1BLfc8c
	QzVxOOaENxksD9yFgmOT1MzFGxYs9csO84ZsDBMSVxFgXwcO/OnWCriBrRe6FOJa
	9gq+EDYzEo54w2udOOIfjjHE34PjGx7zjSbUdybOR2XePpG5SqkJ7+92V6dCxDCX
	4TAbMV5EdTSX0eauHehVPPpM6/B6O5mNK81hEv6tuRicSLkAlvXDRIKzBpGmWrP+
	j+hs93SehD2h1fz80eIJ30AkyZJpqWJ23Hy9PenyfJ08ZPl0pGgZW7aP70Oog/du
	biY19MXmaGac4fpUDdZQtBrxUoAYFs5Vf6JibfULBPbtjMwryv1FQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4469731re7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:24 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50FEPED0013131;
	Wed, 15 Jan 2025 14:40:24 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4469731rdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:23 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FEKaRx007371;
	Wed, 15 Jan 2025 14:40:23 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4443yn8sjy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:23 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FEeJws65143134
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 14:40:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 736BF20043;
	Wed, 15 Jan 2025 14:40:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBB3D20040;
	Wed, 15 Jan 2025 14:40:15 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.24.117])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Jan 2025 14:40:15 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Wed, 15 Jan 2025 20:10:14 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com
Subject: [PATCH v2 5/6] powerpc/book3s-hv-pmu: Implement GSB message-ops for hostwide counters
Date: Wed, 15 Jan 2025 20:09:46 +0530
Message-ID: <20250115143948.369379-6-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250115143948.369379-1-vaibhav@linux.ibm.com>
References: <20250115143948.369379-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: aF9rln4--FuGPTFL6tiv10AyVSDseRUT
X-Proofpoint-GUID: IPYCwL9oa2mRhSRFYxkioStVi0YkYeH4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_05,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 suspectscore=0 spamscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150110

Implement and setup necessary structures to send a prepolulated
Guest-State-Buffer(GSB) requesting hostwide counters to L0-PowerVM and have
the returned GSB holding the values of these counters parsed. This is done
via existing GSB implementation and with the newly added support of
Hostwide elements in GSB.

The request to L0-PowerVM to return Hostwide counters is done using a
pre-allocated GSB named 'gsb_l0_stats'. To be able to populate this GSB
with the needed Guest-State-Elements (GSIDs) a instance of 'struct
kvmppc_gs_msg' named 'gsm_l0_stats' is introduced. The 'gsm_l0_stats' is
tied to an instance of 'struct kvmppc_gs_msg_ops' named  'gsb_ops_l0_stats'
which holds various callbacks to be compute the size ( hostwide_get_size()
), populate the GSB ( hostwide_fill_info() ) and
refresh ( hostwide_refresh_info() ) the contents of
'l0_stats' that holds the Hostwide counters returned from L0-PowerVM.

To protect these structures from simultaneous access a spinlock
'lock_l0_stats' has been introduced. The allocation and initialization of
the above structures is done in newly introduced kvmppc_init_hostwide() and
similarly the cleanup is performed in newly introduced
kvmppc_cleanup_hostwide().

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

---
Changelog

v1->v2:
* Added error handling to hostwide_fill_info() [Gautam]
---
 arch/powerpc/kvm/book3s_hv_pmu.c | 199 +++++++++++++++++++++++++++++++
 1 file changed, 199 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_pmu.c b/arch/powerpc/kvm/book3s_hv_pmu.c
index 8c6ed30b7654..0107ed3b03e3 100644
--- a/arch/powerpc/kvm/book3s_hv_pmu.c
+++ b/arch/powerpc/kvm/book3s_hv_pmu.c
@@ -27,10 +27,31 @@
 #include <asm/plpar_wrappers.h>
 #include <asm/firmware.h>
 
+#include "asm/guest-state-buffer.h"
+
 enum kvmppc_pmu_eventid {
 	KVMPPC_EVENT_MAX,
 };
 
+#define KVMPPC_PMU_EVENT_ATTR(_name, _id) \
+	PMU_EVENT_ATTR_ID(_name, power_events_sysfs_show, _id)
+
+/* Holds the hostwide stats */
+static struct kvmppc_hostwide_stats {
+	u64 guest_heap;
+	u64 guest_heap_max;
+	u64 guest_pgtable_size;
+	u64 guest_pgtable_size_max;
+	u64 guest_pgtable_reclaim;
+} l0_stats;
+
+/* Protect access to l0_stats */
+static DEFINE_SPINLOCK(lock_l0_stats);
+
+/* GSB related structs needed to talk to L0 */
+static struct kvmppc_gs_msg *gsm_l0_stats;
+static struct kvmppc_gs_buff *gsb_l0_stats;
+
 static struct attribute *kvmppc_pmu_events_attr[] = {
 	NULL,
 };
@@ -90,6 +111,177 @@ static void kvmppc_pmu_read(struct perf_event *event)
 {
 }
 
+/* Return the size of the needed guest state buffer */
+static size_t hostwide_get_size(struct kvmppc_gs_msg *gsm)
+
+{
+	size_t size = 0;
+	const u16 ids[] = {
+		KVMPPC_GSID_L0_GUEST_HEAP,
+		KVMPPC_GSID_L0_GUEST_HEAP_MAX,
+		KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE,
+		KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX,
+		KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM
+	};
+
+	for (int i = 0; i < ARRAY_SIZE(ids); i++)
+		size += kvmppc_gse_total_size(kvmppc_gsid_size(ids[i]));
+	return size;
+}
+
+/* Populate the request guest state buffer */
+static int hostwide_fill_info(struct kvmppc_gs_buff *gsb,
+			      struct kvmppc_gs_msg *gsm)
+{
+	int rc = 0;
+	struct kvmppc_hostwide_stats  *stats = gsm->data;
+
+	/*
+	 * It doesn't matter what values are put into request buffer as
+	 * they are going to be overwritten anyways. But for the sake of
+	 * testcode and symmetry contents of existing stats are put
+	 * populated into the request guest state buffer.
+	 */
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_HEAP))
+		rc = kvmppc_gse_put_u64(gsb,
+					KVMPPC_GSID_L0_GUEST_HEAP,
+					stats->guest_heap);
+
+	if (!rc && kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_HEAP_MAX))
+		rc = kvmppc_gse_put_u64(gsb,
+					KVMPPC_GSID_L0_GUEST_HEAP_MAX,
+					stats->guest_heap_max);
+
+	if (!rc && kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE))
+		rc = kvmppc_gse_put_u64(gsb,
+					KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE,
+					stats->guest_pgtable_size);
+	if (!rc &&
+	    kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX))
+		rc = kvmppc_gse_put_u64(gsb,
+					KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX,
+					stats->guest_pgtable_size_max);
+	if (!rc &&
+	    kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM))
+		rc = kvmppc_gse_put_u64(gsb,
+					KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM,
+					stats->guest_pgtable_reclaim);
+
+	return rc;
+}
+
+/* Parse and update the host wide stats from returned gsb */
+static int hostwide_refresh_info(struct kvmppc_gs_msg *gsm,
+				 struct kvmppc_gs_buff *gsb)
+{
+	struct kvmppc_gs_parser gsp = { 0 };
+	struct kvmppc_hostwide_stats *stats = gsm->data;
+	struct kvmppc_gs_elem *gse;
+	int rc;
+
+	rc = kvmppc_gse_parse(&gsp, gsb);
+	if (rc < 0)
+		return rc;
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_HEAP);
+	if (gse)
+		stats->guest_heap = kvmppc_gse_get_u64(gse);
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_HEAP_MAX);
+	if (gse)
+		stats->guest_heap_max = kvmppc_gse_get_u64(gse);
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE);
+	if (gse)
+		stats->guest_pgtable_size = kvmppc_gse_get_u64(gse);
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX);
+	if (gse)
+		stats->guest_pgtable_size_max = kvmppc_gse_get_u64(gse);
+
+	gse = kvmppc_gsp_lookup(&gsp, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM);
+	if (gse)
+		stats->guest_pgtable_reclaim = kvmppc_gse_get_u64(gse);
+
+	return 0;
+}
+
+/* gsb-message ops for setting up/parsing */
+static struct kvmppc_gs_msg_ops gsb_ops_l0_stats = {
+	.get_size = hostwide_get_size,
+	.fill_info = hostwide_fill_info,
+	.refresh_info = hostwide_refresh_info,
+};
+
+static int kvmppc_init_hostwide(void)
+{
+	int rc = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&lock_l0_stats, flags);
+
+	/* already registered ? */
+	if (gsm_l0_stats) {
+		rc = 0;
+		goto out;
+	}
+
+	/* setup the Guest state message/buffer to talk to L0 */
+	gsm_l0_stats = kvmppc_gsm_new(&gsb_ops_l0_stats, &l0_stats,
+				      GSM_SEND, GFP_KERNEL);
+	if (!gsm_l0_stats) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* Populate the Idents */
+	kvmppc_gsm_include(gsm_l0_stats, KVMPPC_GSID_L0_GUEST_HEAP);
+	kvmppc_gsm_include(gsm_l0_stats, KVMPPC_GSID_L0_GUEST_HEAP_MAX);
+	kvmppc_gsm_include(gsm_l0_stats, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE);
+	kvmppc_gsm_include(gsm_l0_stats, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX);
+	kvmppc_gsm_include(gsm_l0_stats, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM);
+
+	/* allocate GSB. Guest/Vcpu Id is ignored */
+	gsb_l0_stats = kvmppc_gsb_new(kvmppc_gsm_size(gsm_l0_stats), 0, 0,
+				      GFP_KERNEL);
+	if (!gsb_l0_stats) {
+		rc = -ENOMEM;
+		goto out;
+	}
+
+	/* ask the ops to fill in the info */
+	rc = kvmppc_gsm_fill_info(gsm_l0_stats, gsb_l0_stats);
+	if (rc)
+		goto out;
+out:
+	if (rc) {
+		if (gsm_l0_stats)
+			kvmppc_gsm_free(gsm_l0_stats);
+		if (gsb_l0_stats)
+			kvmppc_gsb_free(gsb_l0_stats);
+		gsm_l0_stats = NULL;
+		gsb_l0_stats = NULL;
+	}
+	spin_unlock_irqrestore(&lock_l0_stats, flags);
+	return rc;
+}
+
+static void kvmppc_cleanup_hostwide(void)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&lock_l0_stats, flags);
+
+	if (gsm_l0_stats)
+		kvmppc_gsm_free(gsm_l0_stats);
+	if (gsb_l0_stats)
+		kvmppc_gsb_free(gsb_l0_stats);
+	gsm_l0_stats = NULL;
+	gsb_l0_stats = NULL;
+
+	spin_unlock_irqrestore(&lock_l0_stats, flags);
+}
+
 /* L1 wide counters PMU */
 static struct pmu kvmppc_pmu = {
 	.task_ctx_nr = perf_sw_context,
@@ -108,6 +300,10 @@ int kvmppc_register_pmu(void)
 
 	/* only support events for nestedv2 right now */
 	if (kvmhv_is_nestedv2()) {
+		rc = kvmppc_init_hostwide();
+		if (rc)
+			goto out;
+
 		/* Setup done now register the PMU */
 		pr_info("Registering kvm-hv pmu");
 
@@ -117,6 +313,7 @@ int kvmppc_register_pmu(void)
 					       -1) : 0;
 	}
 
+out:
 	return rc;
 }
 EXPORT_SYMBOL_GPL(kvmppc_register_pmu);
@@ -124,6 +321,8 @@ EXPORT_SYMBOL_GPL(kvmppc_register_pmu);
 void kvmppc_unregister_pmu(void)
 {
 	if (kvmhv_is_nestedv2()) {
+		kvmppc_cleanup_hostwide();
+
 		if (kvmppc_pmu.type != -1)
 			perf_pmu_unregister(&kvmppc_pmu);
 
-- 
2.47.1


