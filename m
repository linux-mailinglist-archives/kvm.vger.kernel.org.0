Return-Path: <kvm+bounces-43483-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 262D6A908EB
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 18:29:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 827385A048A
	for <lists+kvm@lfdr.de>; Wed, 16 Apr 2025 16:28:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD9DA213E69;
	Wed, 16 Apr 2025 16:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MXkT8zAl"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAFE211A33;
	Wed, 16 Apr 2025 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744820915; cv=none; b=lisgzvyYcChC6mv7F09Uifr68UmtYpe0lQjLAQ8hzFZui3tDb7TnyWazpIiO9LlRanDzTZUpXd7AVwHldGa31TA7NHd9dUiyzzXEfwJC+GnGrccodYiptaZ5ScE2NecO55q0ZUtJT/xPNyNlBEr1d6cbFdidjSh2flBoHw1HFdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744820915; c=relaxed/simple;
	bh=hZu6Sy+hcS6e8dxo8ZqcdXAo2uWy3bq/nHb98AGWZvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHbPA2ElBNgsMl6mNQVfDBlVcqaHsCaPd+64eCdWVyNonJ1r/1LH8uNeh4QWLPTCsRgO4WkrG/4f3SgXHKc4dqJmGaAJvhE46fpUuwWR1O921+r/UXY8N+qbF9L9QMP1RpQYtUaA/jUWg2Xij16UdhVRMtFKXgN2UKFcoRAd1pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MXkT8zAl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53GBO4Zd026666;
	Wed, 16 Apr 2025 16:28:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=kpR9ApYESI8ONP00o
	LkNubpGw18bXN5MrCGGEe6WWtk=; b=MXkT8zAlzOof1qWELVSuUIFGBv1YRqk38
	dsMZapRk0mJfW+bVx756o2B2GByKryAT5UyjtORjeZ6Ma/yKyCsETUGu98hVcYzr
	QIfSgAausBYHk4579s89BJXEBZ66ln2bjEBdBVcPuVaKBfNgKpPINzitzsGjg3bT
	5+CHK4CgGIiQjCx/JF53ysauIc+fw5KTlKh2DZ8VJ11wI2tb96n6gZ41VyA2FXMz
	hRTK+3FpHkCkgdAy8mSQ+6lDyr+IbFn6z7wTwCq6hGkAIRq8X1qIUIMBBquoG6BX
	gg8PQzEY1UCR9OjDkMiGp5tgaycNrD6rIj1yyzJ1W8ZIA4N6HZk0g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 461ykt4nj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 16:28:24 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53GG7xcJ011024;
	Wed, 16 Apr 2025 16:28:23 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 461ykt4nj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 16:28:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53GEfhU5017174;
	Wed, 16 Apr 2025 16:28:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46040m12ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 16 Apr 2025 16:28:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53GGSJM331719844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 16 Apr 2025 16:28:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 745D420043;
	Wed, 16 Apr 2025 16:28:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 78A7E20040;
	Wed, 16 Apr 2025 16:28:15 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.210.156])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 16 Apr 2025 16:28:15 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Wed, 16 Apr 2025 21:58:14 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com, Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
        Athira Rajeev <atrajeev@linux.ibm.com>
Subject: [RESEND PATCH v5 6/6] powerpc/kvm-hv-pmu: Add perf-events for Hostwide counters
Date: Wed, 16 Apr 2025 21:57:36 +0530
Message-ID: <20250416162740.93143-7-vaibhav@linux.ibm.com>
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
X-Proofpoint-GUID: UzK_yXKWKGUw13iE2jn62rPfAaPo6yq7
X-Proofpoint-ORIG-GUID: xZSag7QZkAPvLao85RLEWZxmFaWBbis7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-16_04,2025-04-15_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2502280000 definitions=main-2504160127

Update 'kvm-hv-pmu.c' to add five new perf-events mapped to the five
Hostwide counters. Since these newly introduced perf events are at system
wide scope and can be read from any L1-Lpar CPU, 'kvmppc_pmu' scope and
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
Reviewed-by: Athira Rajeev <atrajeev@linux.ibm.com>
---
Changelog

v5->resend:
* Rebase the patch to latest upstream kernel tree
* Added Athira's reviewed-by.

v4->v5:
* Call kvmppc_pmu_event_update() during pmu's 'del()' callback [ Athira ]

v3->v4:
* Minor tweaks to patch description and code as its now being built as a
separate kernel module.

v2->v3:
None

v1->v2:
None
---
 arch/powerpc/perf/kvm-hv-pmu.c | 92 +++++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/perf/kvm-hv-pmu.c b/arch/powerpc/perf/kvm-hv-pmu.c
index 705be24ccb43..ae264c9080ef 100644
--- a/arch/powerpc/perf/kvm-hv-pmu.c
+++ b/arch/powerpc/perf/kvm-hv-pmu.c
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
 
@@ -61,8 +66,14 @@ static DEFINE_SPINLOCK(lock_l0_stats);
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
 
@@ -71,7 +82,7 @@ static const struct attribute_group kvmppc_pmu_events_group = {
 	.attrs = kvmppc_pmu_events_attr,
 };
 
-PMU_FORMAT_ATTR(event, "config:0");
+PMU_FORMAT_ATTR(event, "config:0-5");
 static struct attribute *kvmppc_pmu_format_attr[] = {
 	&format_attr_event.attr,
 	NULL,
@@ -88,6 +99,79 @@ static const struct attribute_group *kvmppc_pmu_attr_groups[] = {
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
@@ -110,15 +194,19 @@ static int kvmppc_pmu_event_init(struct perf_event *event)
 
 static void kvmppc_pmu_del(struct perf_event *event, int flags)
 {
+	kvmppc_pmu_event_update(event);
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
@@ -302,6 +390,8 @@ static struct pmu kvmppc_pmu = {
 	.read = kvmppc_pmu_read,
 	.attr_groups = kvmppc_pmu_attr_groups,
 	.type = -1,
+	.scope = PERF_PMU_SCOPE_SYS_WIDE,
+	.capabilities = PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 static int __init kvmppc_register_pmu(void)
-- 
2.49.0


