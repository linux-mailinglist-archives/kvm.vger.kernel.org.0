Return-Path: <kvm+bounces-34295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 062E99FA5F0
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 15:04:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8493C166564
	for <lists+kvm@lfdr.de>; Sun, 22 Dec 2024 14:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E06018E023;
	Sun, 22 Dec 2024 14:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HjzD3+gD"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83A5185B67;
	Sun, 22 Dec 2024 14:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734876220; cv=none; b=PxvbYthPMrpXFbqhFFo3Gn6xF4DNppMMW2gZ9Cta2b063FbwbdydSRT5b7FQq8S1Dq27WiWxv98DDbZZII/vTRlf5e2RqbicbsYUKhE1fiJhCrPozydzSKsn8R/fCbqdLNKnhUJfvzaIC/65yDFXeigIz32P9Vg4V5edL4hkUt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734876220; c=relaxed/simple;
	bh=m9NJw3YkPQQsGJU2OimkUoRl4fJ6BDGPQcaZVc4Cymg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKDjzO6s9kyAs3zdbS6jf0IkJIQzj8zQ3aWRQMO7yyBONktudxqtFAgHFRq5Mht+zGtf+TfsYJA240O5BDSG25vOHmc9DYgtACsQHlV86JNZvxAG5UX+DmPeL2dvGQTVtB80yOjtT1cepq5DcmLyFvDUINEA3OlRqcxK/+2J48Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HjzD3+gD; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BMDrMpL032573;
	Sun, 22 Dec 2024 14:03:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=yjbzD/JYtfnryQW1Q
	xefhChetM5kodTzGvqTwOeuREc=; b=HjzD3+gDTLhsLM/p/BKh8mkBPXtEYrAkf
	POEkxiI/IOyw5XwH3/RJIXfXPtIlvG7wm2iSXu4Y4kXJl2wuExGe0R6aEjxhkDCb
	C1RhwMYq5efiG8pOmM/f9N992S2ShN+7L+tcLmosSaLI4p6XAQ1kZYcGKo8z/Ck+
	5BxDzSQAKErRUtLY3GojIZDVRQNC1eEWP22U2uGMz/wmusMRVovW3efiRx6Gk6t8
	kISs3e5XkwpWkfS5DosBPQpcupc9IAaT/eGhaQEj5t2bElYFUCCc8LXK7DAVndvI
	xH+yFvx6e+QKqk6QnkI+SBdyBwL0y1xJr8QVuReJcaBKb5KGu20Rw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ny54axat-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:27 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BME3R8s020445;
	Sun, 22 Dec 2024 14:03:27 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ny54axaq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BMBd7eV002332;
	Sun, 22 Dec 2024 14:03:26 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 43p80sa4b4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 22 Dec 2024 14:03:26 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BME3Mup37290416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 22 Dec 2024 14:03:22 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A7F5920040;
	Sun, 22 Dec 2024 14:03:22 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25B3020043;
	Sun, 22 Dec 2024 14:03:19 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.24.11])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Sun, 22 Dec 2024 14:03:18 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Sun, 22 Dec 2024 19:33:18 +0530
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
Subject: [PATCH 5/6] powerpc/book3s-hv-pmu: Implement GSB message-ops for hostwide counters
Date: Sun, 22 Dec 2024 19:32:33 +0530
Message-ID: <20241222140247.174998-6-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241222140247.174998-1-vaibhav@linux.ibm.com>
References: <20241222140247.174998-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: U0jcQnnerAV80OZ1UKuSu_v8gsGqPDQj
X-Proofpoint-GUID: 4g3Lo8NXpb0W7rO2k7x022NPH3ffnUrI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 suspectscore=0 clxscore=1011
 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412220124

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
 arch/powerpc/kvm/book3s_hv_pmu.c | 189 +++++++++++++++++++++++++++++++
 1 file changed, 189 insertions(+)

diff --git a/arch/powerpc/kvm/book3s_hv_pmu.c b/arch/powerpc/kvm/book3s_hv_pmu.c
index e72542d5e750..f7fd5190ecf7 100644
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
@@ -90,6 +111,167 @@ static void kvmppc_pmu_read(struct perf_event *event)
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
+	struct kvmppc_hostwide_stats  *stats = gsm->data;
+
+	/*
+	 * It doesn't matter what values are put into request buffer as
+	 * they are going to be overwritten anyways. But for the sake of
+	 * testcode and symmetry contents of existing stats are put
+	 * populated into the request guest state buffer.
+	 */
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_HEAP))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_HEAP,
+				   stats->guest_heap);
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_HEAP_MAX))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_HEAP_MAX,
+				   stats->guest_heap_max);
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE,
+				   stats->guest_pgtable_size);
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_PGTABLE_SIZE_MAX,
+				   stats->guest_pgtable_size_max);
+	if (kvmppc_gsm_includes(gsm, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM))
+		kvmppc_gse_put_u64(gsb, KVMPPC_GSID_L0_GUEST_PGTABLE_RECLAIM,
+				   stats->guest_pgtable_reclaim);
+
+	return 0;
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
@@ -108,6 +290,10 @@ int kvmppc_register_pmu(void)
 
 	/* only support events for nestedv2 right now */
 	if (kvmhv_is_nestedv2()) {
+		rc = kvmppc_init_hostwide();
+		if (rc)
+			goto out;
+
 		/* Setup done now register the PMU */
 		pr_info("Registering kvm-hv pmu");
 
@@ -117,6 +303,7 @@ int kvmppc_register_pmu(void)
 					       -1) : 0;
 	}
 
+out:
 	return rc;
 }
 EXPORT_SYMBOL_GPL(kvmppc_register_pmu);
@@ -124,6 +311,8 @@ EXPORT_SYMBOL_GPL(kvmppc_register_pmu);
 void kvmppc_unregister_pmu(void)
 {
 	if (kvmhv_is_nestedv2()) {
+		kvmppc_cleanup_hostwide();
+
 		if (kvmppc_pmu.type != -1)
 			perf_pmu_unregister(&kvmppc_pmu);
 
-- 
2.47.1


