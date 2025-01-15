Return-Path: <kvm+bounces-35559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9347FA12649
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 15:41:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCA5D3A9327
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 14:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B00D13698E;
	Wed, 15 Jan 2025 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jYpr2Dj2"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CE778C9C;
	Wed, 15 Jan 2025 14:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736952040; cv=none; b=FWDoPJD7zSFUk3S6n3EVT3cWJGtzCrlt7SioRv/JDnlZTZFAqvMnCfjhL+N1oofrMqP93jqE9mDEiSX8/3mnZuWr80cDdk5RFCTzwZ2G+N1D6CDkmAfbNcgBtSmASO2yg1wTvmNLPbEhUfvlbIPYWXHk3uI1XU9TnEDZ0Emcsjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736952040; c=relaxed/simple;
	bh=b9rSrI+wmfXupI6ty1Lm5OaLAVK44CSHypgS8CgzYZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hY08ukFB7+uSw/ZIlXyEXMwuQ3AiHn61VFif0DfRXkO8sXknDV4sTrAjWFLLgL6i9PirPD6I/GesAPy4alk+UVJRaEwLRwCUCbPIzgL0NzEM0hBPRzh4+PyMZyaw3fHnCjULeDdC9+H+04tAAospo9r6Vr6QelIMJ3yzkIRmU7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jYpr2Dj2; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50FE6HOY022130;
	Wed, 15 Jan 2025 14:40:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tlXKaSEkpPN95aRVt
	sqo4dTAoEIhvpeOu83lqneYylY=; b=jYpr2Dj2zM23FqsOdxolIiX6+PmfHyEr5
	EG5SHsfXHNuB3CTaRDYMRP1nAJjtbMDyt9oS5tNYF9TAkW+raZCHDKdfT/q4CnZF
	VQQ5RsqbwA0IjRFBi5LFjvx4YSk5Ii3cO5hJra21eGLNWMX9hwUCFhOWOxPp8tcB
	89U5Z3C63MJFZ4naSW3FoVVBnyIOdshp1IXXACgX3C6Gpn/rAVXmKU+Ov9IaQWA5
	m2zMVCnbMd3LysOErki9i6wtvepgzNYzIUbP3A/SxPlsjiTV5nxvp80itFhtobZ5
	u+s3yQgkTjGG891rTHdhI/kmLyzoScLq+NPb1a1Vt77fLIy0A/emA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446eg5r6e5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:29 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50FEZJZD028671;
	Wed, 15 Jan 2025 14:40:28 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 446eg5r6e1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50FBeclv001089;
	Wed, 15 Jan 2025 14:40:27 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44456k0hcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Jan 2025 14:40:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50FEeO4054788530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Jan 2025 14:40:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6869F20043;
	Wed, 15 Jan 2025 14:40:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B138920040;
	Wed, 15 Jan 2025 14:40:20 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.24.117])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Wed, 15 Jan 2025 14:40:20 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Wed, 15 Jan 2025 20:10:19 +0530
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
Subject: [PATCH v2 6/6] kvm powerpc/book3s-hv-pmu: Add perf-events for Hostwide counters
Date: Wed, 15 Jan 2025 20:09:47 +0530
Message-ID: <20250115143948.369379-7-vaibhav@linux.ibm.com>
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
X-Proofpoint-GUID: Uogkg42FCU1rqIOyDqtQTkwcqaugRvG1
X-Proofpoint-ORIG-GUID: 0SbFgFNfu5Z_duYw56oS9XWYoGnlxbXH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-15_05,2025-01-15_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 suspectscore=0
 clxscore=1015 phishscore=0 malwarescore=0 spamscore=0 adultscore=0
 mlxscore=0 impostorscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501150110

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
 arch/powerpc/kvm/book3s_hv_pmu.c | 92 +++++++++++++++++++++++++++++++-
 1 file changed, 91 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kvm/book3s_hv_pmu.c b/arch/powerpc/kvm/book3s_hv_pmu.c
index 0107ed3b03e3..4c14c5885269 100644
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
@@ -292,6 +380,8 @@ static struct pmu kvmppc_pmu = {
 	.read = kvmppc_pmu_read,
 	.attr_groups = kvmppc_pmu_attr_groups,
 	.type = -1,
+	.scope = PERF_PMU_SCOPE_SYS_WIDE,
+	.capabilities = PERF_PMU_CAP_NO_EXCLUDE | PERF_PMU_CAP_NO_INTERRUPT,
 };
 
 int kvmppc_register_pmu(void)
-- 
2.47.1


