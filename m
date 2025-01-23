Return-Path: <kvm+bounces-36349-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 026B1A1A3E5
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 13:09:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4CD0C1884AEC
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 12:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 690C620F07A;
	Thu, 23 Jan 2025 12:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MJQ7fJE9"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED38120E71C;
	Thu, 23 Jan 2025 12:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737634119; cv=none; b=DcrjKSsCBBzSrihSr0/W/iRtegzGeT6aLNGt+nMqnlpao9a9IURKcXaGiFiN6Tv0iRwyBLMG/ew+6xYxndoFTVIchXqx3IrFZsQT2obQ5C+luLsyPdzcxONWmI3blPYcj5gY7hh8bcqbAR91a2OzQwNlvqDVm/hfLdl9N46uPs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737634119; c=relaxed/simple;
	bh=8DpOYvRS18x/+RXLrSZWrahdxZSwOT0LE4tXASXZNIE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gvuf355OksuNap67K4S9khwoBoYCccOb8FHp1aYNMcpJZasgmEVCfNm67LIJildGZS1/elgNJAxFNBEdB01mYqp7vowXFz+zA1Ahlcdfpwdqx8KaexjDERbDODEYQA5ncRA+1J/o/3OIjzmFN0Lcc5Pd96km89lSX+LcyFiG8PM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MJQ7fJE9; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50N7X3US028427;
	Thu, 23 Jan 2025 12:08:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=B1z0MHxC6gPXv4Qq0
	GOeux5hNdGD0JVs+IwvXZ3fbMs=; b=MJQ7fJE9OgPoA0Ibo7N3nErXUOg7Ptstt
	ZStkm514VSAs4Amtu9zY6kZtYqTNqCSsjXFJNCod/RyJ6ZLisuaEO6+pEIXYroHy
	XMqFcuVve5xooyd5/jr34N7/s3HE3uczJd1dOdF8oK+LhoQq4fm80RDNALen+uHw
	tdw2uc20N4YI4EUnaFOhB/GxHFLMgZ3kKNr1oo5ktfI5F+iB92cl2TWu0xnfrw+Z
	jMOKuJJycdVvgzx1eR0eIvM3A9pFlr1XqgkAdyadqlm3p05ayjJyg/stybx6ZbW+
	xp7EIPpUUJVcJEnt+lyUleRJuTKSBVC95jXYSzwvB493Db9e9naFg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bhfph82n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 12:08:28 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50NC8H5n007904;
	Thu, 23 Jan 2025 12:08:28 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44bhfph82h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 12:08:28 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50NBBTgi022449;
	Thu, 23 Jan 2025 12:08:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 448r4kdae9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 Jan 2025 12:08:27 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50NC8N7U53870896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 Jan 2025 12:08:23 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 92E2B20043;
	Thu, 23 Jan 2025 12:08:23 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E7A0B20040;
	Thu, 23 Jan 2025 12:08:19 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.210.34])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 23 Jan 2025 12:08:19 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Thu, 23 Jan 2025 17:38:19 +0530
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
Subject: [PATCH v3 6/6] kvm powerpc/book3s-hv-pmu: Add perf-events for Hostwide counters
Date: Thu, 23 Jan 2025 17:37:48 +0530
Message-ID: <20250123120749.90505-7-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250123120749.90505-1-vaibhav@linux.ibm.com>
References: <20250123120749.90505-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Yhn4NkMHq-4zxrQdXJoLu8WKvmZTykrA
X-Proofpoint-ORIG-GUID: R6AtYOAa7jNvAoqZY8mi5WQgtDo7FLh_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_05,2025-01-22_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 clxscore=1015 mlxscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501230091

Update 'book3s_hv_pmu.c' to add five new perf-events mapped to the five
Hostwide counters. Since these newly introduced perf events are at system
wide scope and can be read from any L1-Lpar CPU, 'kvmppv_pmu's scope and
capabilities are updated appropriately.

Also introduce two new helpers. First is kvmppc_update_l0_stats() that uses
the infrastructure introduced in previous patches to issues the
H_GUEST_GET_STATE hcall L0-PowerVM to fetch guest-state-buffer holding the
latest values of these counters which is then parsed and 'l0_stats'
variable updated.

Second helper is kvmppc_pmu_event_update() which is called from
'kvmppv_pmu' callbacks and uses kvmppc_update_l0_stats() to update
'l0_stats' and the update the 'struct perf_event's event-counter.

Some minor updates to kvmppc_pmu_{add, del, read}() to remove some debug
scaffolding code.

Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>
---
Changelog

v2->v3:
None

v1->v2:
None
---
 arch/powerpc/kvm/book3s_hv_pmu.c | 92 +++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_pmu.c b/arch/powerpc/kvm/book3s_hv_pmu.c
index a4f8c37d9b39..8121ff3ca7b2 100644
--- a/arch/powerpc/kvm/book3s_hv_pmu.c
+++ b/arch/powerpc/kvm/book3s_hv_pmu.c
@@ -30,6 +30,11 @@
 #include "asm/guest-state-buffer.h"
 
 enum kvmppc_pmu_eventid {
+	KVMPPC_EVENT_HOST_HEAP,
+	KVMPPC_EVENT_HOST_HEAP_MAX,
+	KVMPPC_EVENT_HOST_PGTABLE,
+	KVMPPC_EVENT_HOST_PGTABLE_MAX,
+	KVMPPC_EVENT_HOST_PGTABLE_RECLAIM,
 	KVMPPC_EVENT_MAX,
 };
 
@@ -51,8 +56,14 @@ static DEFINE_SPINLOCK(lock_l0_stats);
 /* GSB related structs needed to talk to L0 */
 static struct kvmppc_gs_msg *gsm_l0_stats;
 static struct kvmppc_gs_buff *gsb_l0_stats;
+static struct kvmppc_gs_parser gsp_l0_stats;
 
 static struct attribute *kvmppc_pmu_events_attr[] = {
+	KVMPPC_PMU_EVENT_ATTR(host_heap, KVMPPC_EVENT_HOST_HEAP),
+	KVMPPC_PMU_EVENT_ATTR(host_heap_max, KVMPPC_EVENT_HOST_HEAP_MAX),
+	KVMPPC_PMU_EVENT_ATTR(host_pagetable, KVMPPC_EVENT_HOST_PGTABLE),
+	KVMPPC_PMU_EVENT_ATTR(host_pagetable_max, KVMPPC_EVENT_HOST_PGTABLE_MAX),
+	KVMPPC_PMU_EVENT_ATTR(host_pagetable_reclaim, KVMPPC_EVENT_HOST_PGTABLE_RECLAIM),
 	NULL,
 };
 
@@ -61,7 +72,7 @@ static const struct attribute_group kvmppc_pmu_events_group = {
 	.attrs = kvmppc_pmu_events_attr,
 };
 
-PMU_FORMAT_ATTR(event, "config:0");
+PMU_FORMAT_ATTR(event, "config:0-5");
 static struct attribute *kvmppc_pmu_format_attr[] = {
 	&format_attr_event.attr,
 	NULL,
@@ -78,6 +89,79 @@ static const struct attribute_group *kvmppc_pmu_attr_groups[] = {
 	NULL,
 };
 
+/*
+ * Issue the hcall to get the L0-host stats.
+ * Should be called with l0-stat lock held
+ */
+static int kvmppc_update_l0_stats(void)
+{
+	int rc;
+
+	/* With HOST_WIDE flags guestid and vcpuid will be ignored */
+	rc = kvmppc_gsb_recv(gsb_l0_stats, KVMPPC_GS_FLAGS_HOST_WIDE);
+	if (rc)
+		goto out;
+
+	/* Parse the guest state buffer is successful */
+	rc = kvmppc_gse_parse(&gsp_l0_stats, gsb_l0_stats);
+	if (rc)
+		goto out;
+
+	/* Update the l0 returned stats*/
+	memset(&l0_stats, 0, sizeof(l0_stats));
+	rc = kvmppc_gsm_refresh_info(gsm_l0_stats, gsb_l0_stats);
+
+out:
+	return rc;
+}
+
+/* Update the value of the given perf_event */
+static int kvmppc_pmu_event_update(struct perf_event *event)
+{
+	int rc;
+	u64 curr_val, prev_val;
+	unsigned long flags;
+	unsigned int config = event->attr.config;
+
+	/* Ensure no one else is modifying the l0_stats */
+	spin_lock_irqsave(&lock_l0_stats, flags);
+
+	rc = kvmppc_update_l0_stats();
+	if (!rc) {
+		switch (config) {
+		case KVMPPC_EVENT_HOST_HEAP:
+			curr_val = l0_stats.guest_heap;
+			break;
+		case KVMPPC_EVENT_HOST_HEAP_MAX:
+			curr_val = l0_stats.guest_heap_max;
+			break;
+		case KVMPPC_EVENT_HOST_PGTABLE:
+			curr_val = l0_stats.guest_pgtable_size;
+			break;
+		case KVMPPC_EVENT_HOST_PGTABLE_MAX:
+			curr_val = l0_stats.guest_pgtable_size_max;
+			break;
+		case KVMPPC_EVENT_HOST_PGTABLE_RECLAIM:
+			curr_val = l0_stats.guest_pgtable_reclaim;
+			break;
+		default:
+			rc = -ENOENT;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&lock_l0_stats, flags);
+
+	/* If no error than update the perf event */
+	if (!rc) {
+		prev_val = local64_xchg(&event->hw.prev_count, curr_val);
+		if (curr_val > prev_val)
+			local64_add(curr_val - prev_val, &event->count);
+	}
+
+	return rc;
+}
+
 static int kvmppc_pmu_event_init(struct perf_event *event)
 {
 	unsigned int config = event->attr.config;
@@ -100,15 +184,19 @@ static int kvmppc_pmu_event_init(struct perf_event *event)
 
 static void kvmppc_pmu_del(struct perf_event *event, int flags)
 {
+	/* Do nothing */
 }
 
 static int kvmppc_pmu_add(struct perf_event *event, int flags)
 {
+	if (flags & PERF_EF_START)
+		return kvmppc_pmu_event_update(event);
 	return 0;
 }
 
 static void kvmppc_pmu_read(struct perf_event *event)
 {
+	kvmppc_pmu_event_update(event);
 }
 
 /* Return the size of the needed guest state buffer */
@@ -291,6 +379,8 @@ static struct pmu kvmppc_pmu = {
 	.read = kvmppc_pmu_read,
 	.attr_groups = kvmppc_pmu_attr_groups,
 	.type = -1,
+	.scope = PERF_PMU_SCOPE_SYS_WIDE,
+	.capabilities = PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 int kvmppc_register_pmu(void)
-- 
2.48.1


