Return-Path: <kvm+bounces-43482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 042EDA908E8
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 18:28:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8F6D916FB65
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 16:28:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06D5821324F;
	Wed, 16 Apr 2025 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jpkfWsao"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C86B21171A;
	Wed, 16 Apr 2025 16:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744820909; cv=none; b=egftQn+8I7qEbf2LvMFYnD8iox1U8hxcEdgOvBoch/ZqN6aGco3ERaWkIbxOGsmdeZV4X/v7eyJ0Dvzb0hkXz0MhFYgokNqKnCYLCp43zO0v96BsBMA1FESCJIyPDC9uaRKFckwciLr3Jg9hqmEqSDeRAYca20w9jBZCGAGu00Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744820909; c=relaxed/simple;
	bh=z+WM+z2ZPQZKnKLgCL2tfF62XD+5cL8p2WFNk7sOxnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZwHqG7mgZldKQGmI2rAHfwkviUyYDPO+btcOM8sM0AC1zbbgpldI8HiWNSqaoLpwEb5MG1oM5ZnMGgFQUeA/9hlLjiL0jTqGXXHa9I8wPrepA0PHbM4zD18NgLxaCKzRj4sI2LhHRrKaUeezjfvrVHyAIUC5gdZi12BbJYJkec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jpkfWsao; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53GFMsso018902;
	Wed, 16 Apr 2025 16:28:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tHamPCWDbqLknj9v4
	24INB5EBqJgrI06xjbBlQ9Infc=; b=jpkfWsao1WZYNvmsa3MJJ9I0R0rPjYBqD
	dDNtDE0v+V+pm5DnCMfuLj81ppTzzW7znLzHAZmXgUSbUvB/1HMD/aSWbMymKDT9
	may2/DE5MRhUaHBi/nmzk6VH9fwD20uS6b9lbcvwrQwHKo7ImOWClAvxPn7h0qp4
	oQw0FAp3ZLyIj6rA8/ACww6eepAqlKN6pTbQH3ypleKgM/jA1iibpPfnQxA0RLcL
	lRpa9ebNjEo/Yr3wJCAW5kdBKao2JDypS2G/mL1UUb07I4upOSjKLBKi+5Z1xV2H
	NQHNd/DZVQByNRrNzdYva5voMpjmYHDYaKaY1CGb6V17MK8tCIf9Q==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 461y1gd1ac-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 16:28:19 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53GGOHIa032405;
	Wed, 16 Apr 2025 16:28:18 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 461y1gd1a9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 16:28:18 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53GDR3Q4024888;
	Wed, 16 Apr 2025 16:28:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4602gthhhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 16:28:17 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53GGSEw949742172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 16:28:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 45B4220043;
	Wed, 16 Apr 2025 16:28:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7142320040;
	Wed, 16 Apr 2025 16:28:10 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.210.156])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 16 Apr 2025 16:28:10 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Wed, 16 Apr 2025 21:58:09 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Subject: [RESEND PATCH v5 5/6] powerpc/kvm-hv-pmu: Implement GSB message-ops for hostwide counters
Date: Wed, 16 Apr 2025 21:57:35 +0530
Message-ID: <20250416162740.93143-6-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250416162740.93143-1-vaibhav@linux.ibm.com>
References: <20250416162740.93143-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hkW-ki63ZFLzuXugbbNNn5JpKuGfxT2p
X-Proofpoint-GUID: Nya_ppTox9MmQKHyeBE1-b2trarN3pl6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_04,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 mlxscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 priorityscore=1501 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504160127

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

v5->resend:
* Rebase the patch to latest upstream kernel tree

v4->v5:
* Update kvmppc_register_pmu() to refactor the module init path.

v3->v4:
* Minor tweaks to code and patch description since this code is now being
built as a kernel module.
* Introduced kvmppc_events_sysfs_show() as power_events_sysfs_show() is not
exported to modules.

v2->v3:
Removed a redundant branch in kvmppc_init_hostwide() [Gautam]

v1->v2:
* Added error handling to hostwide_fill_info() [Gautam]
---
 arch/powerpc/perf/kvm-hv-pmu.c | 207 +++++++++++++++++++++++++++++++++
 1 file changed, 207 insertions(+)

diff --git a/arch/powerpc/perf/kvm-hv-pmu.c b/arch/powerpc/perf/kvm-hv-pmu.c
index 12f40a7b3ced..705be24ccb43 100644
--- a/arch/powerpc/perf/kvm-hv-pmu.c
+++ b/arch/powerpc/perf/kvm-hv-pmu.c
@@ -27,10 +27,41 @@
 #include <asm/plpar_wrappers.h>
 #include <asm/firmware.h>
 
+#include "asm/guest-state-buffer.h"
+
 enum kvmppc_pmu_eventid {
 	KVMPPC_EVENT_MAX,
 };
 
+#define KVMPPC_PMU_EVENT_ATTR(_name, _id) \
+	PMU_EVENT_ATTR_ID(_name, kvmppc_events_sysfs_show, _id)
+
+static ssize_t kvmppc_events_sysfs_show(struct device *dev,
+					struct device_attribute *attr,
+					char *page)
+{
+	struct perf_pmu_events_attr *pmu_attr;
+
+	pmu_attr = container_of(attr, struct perf_pmu_events_attr, attr);
+	return sprintf(page, "event=0x%02llx\n", pmu_attr->id);
+}
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
@@ -90,6 +121,176 @@ static void kvmppc_pmu_read(struct perf_event *event)
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
+
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
 	.module = THIS_MODULE,
@@ -109,6 +310,10 @@ static int __init kvmppc_register_pmu(void)
 
 	/* only support events for nestedv2 right now */
 	if (kvmhv_is_nestedv2()) {
+		rc = kvmppc_init_hostwide();
+		if (rc)
+			goto out;
+
 		/* Register the pmu */
 		rc = perf_pmu_register(&kvmppc_pmu, kvmppc_pmu.name, -1);
 		if (rc)
@@ -124,6 +329,8 @@ static int __init kvmppc_register_pmu(void)
 static void __exit kvmppc_unregister_pmu(void)
 {
 	if (kvmhv_is_nestedv2()) {
+		kvmppc_cleanup_hostwide();
+
 		if (kvmppc_pmu.type != -1)
 			perf_pmu_unregister(&kvmppc_pmu);
 
-- 
2.49.0


