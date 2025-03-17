Return-Path: <kvm+bounces-41191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B279EA648E1
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 11:09:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04BF7165589
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 10:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D42E231CAE;
	Mon, 17 Mar 2025 10:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f2kTVNph"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240C0231C9F;
	Mon, 17 Mar 2025 10:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742206171; cv=none; b=gTUaptajBvNPT/+p3bsuYVawfk17LWJi40cvdtL8P0qYvqYUxnciyeeoZcYEzByf69IQaOJraTVqicBITNMaYUnYCvg6jC9XZ259CBuO1l1ZA7YSiXygOo3kFnz1g6SnmaEApDdCJW9qKrrlAK+YJMSWeGMKUTZ8I4xEOWX2HAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742206171; c=relaxed/simple;
	bh=uBC8n/3dLEPCTUfOtW5NNrU3Pvde9MqlXm1gD3UL6lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOJWAhPn7hdCqI+Mbx9+P0sk9D9W8Cr7CXMHqLWV+khF/ahR7w5R14eL+x19z3cN/N4t0WdRtO/NR7wqgZZ+GEB2hpcTgYnWDvJKhksJ4KLLo/9BrqWcWlUncGCxGxKd2MsfNsT7paMfDSTbXhMM4NxCYlwyhr7mK3rKOKiTHHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f2kTVNph; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52H3k4lG018771;
	Mon, 17 Mar 2025 10:09:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=RnNXfEw+1zbJDfF16
	BhfgUTV4yagkWSz1L0CDPFt+fU=; b=f2kTVNphUobVQkVzOFrVClBULHfwgO0mV
	I1e1pE58oed3bDPme/JETh/guStJlrdY5BFFpKdA0iex0UBJ2NEPoXp9QD/Gmzud
	A4qs0DOmLXzLSwq/4ph7vUiVmh4yX2BjHZ7GN2ATg11tTN7OYuKONUWs1W3d6iop
	k+655kczotiwUtM+HD1KU6DAtOKOyu3EJQXyWlXh0CrKNXmokoTjsFeuqJzhv27+
	bOoh+GNpwNsejh6Ckmc7uGz61wjn3brXscPXGtv/nQ/GibdIJrX6ChiGHqy/STlq
	rsRy/Z2MSXqLIBugad8i6RaeeuIhXfGz5wC4Z3+OgfE+LgfW52gCQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45ec499jbk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Mar 2025 10:09:21 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 52H9oiU8001128;
	Mon, 17 Mar 2025 10:09:21 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 45ec499jbh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Mar 2025 10:09:21 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 52H6eAnc005803;
	Mon, 17 Mar 2025 10:09:20 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 45dpk257c3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Mar 2025 10:09:20 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 52HA9Gwj38994380
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Mar 2025 10:09:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF59F20163;
	Mon, 17 Mar 2025 10:09:16 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7A85520161;
	Mon, 17 Mar 2025 10:09:12 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.124.208.110])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 17 Mar 2025 10:09:12 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Mon, 17 Mar 2025 15:39:11 +0530
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
Subject: [PATCH v5 6/6] powerpc/kvm-hv-pmu: Add perf-events for Hostwide counters
Date: Mon, 17 Mar 2025 15:38:33 +0530
Message-ID: <20250317100834.451452-7-vaibhav@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250317100834.451452-1-vaibhav@linux.ibm.com>
References: <20250317100834.451452-1-vaibhav@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2f9Edj7xxDZP-d0jQlPcg3NdOEPglp1o
X-Proofpoint-ORIG-GUID: exwcGFNq2uFqlral_hoLXnnTK8qWlwud
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_03,2025-03-17_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 adultscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 mlxscore=0 impostorscore=0
 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2502280000 definitions=main-2503170073

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
---
Changelog

v4->v5:
* Call kvmppc_pmu_event_update() during pmu's 'del()' callback [ Atheera ]

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
2.48.1


