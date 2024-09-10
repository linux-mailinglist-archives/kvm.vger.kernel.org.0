Return-Path: <kvm+bounces-26202-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B092997293B
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 08:05:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D46751C23E70
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 06:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C962F175D37;
	Tue, 10 Sep 2024 06:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bM/E1Yc2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8AF16F27F;
	Tue, 10 Sep 2024 06:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725948307; cv=fail; b=UoSTIF45+7gPrDnnygGSdaf6jXeKgk8mTIM+Q3DOirFFxQb26weoT421ew9ghmWqAogopOKILDgHk57Z5xEsIWZ6UoijR0Xq7kFneiWRNPvEJG90UjsS8J+OYK1QT4QjSfQcI4/unFNvlCDesS0LRNWCknpGJON0me9nMvVuhvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725948307; c=relaxed/simple;
	bh=/iZcmVHvLp87cV5AdKdsq72/WWP3MMEvAOMYhuHyG6U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lclc48LjJdmlHrPXrXbgXWg2ov2kbXbjw81zIvTJFEvTlAW5df1fPEJYB2Uxgf3nJ5o0cB/XXlb/JVxZs5mvpETT7fmn5pI+eAW41cpNaiFEE3HKOkptI0tiZOS7pA/cvwgwoaCwfMgsmrZC2/JmOxR/W5jHWuFFLL1E5Cx4Wf0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bM/E1Yc2; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YJF0dy1//Fucub6SG8iwacYJHkNYI0bXyvX5MopjBfCGyxbKSg0LIV5P4tV5X6fKMu134FY/WJ4UqNAYmpY/xdHmVTGssWaC8maR0T1OrrZqqINUKTuGusGsW9+6M70th/Ex2G6HZIe6dT1dQhjrfrJs8dv0QexpR8JHQzZIkysdbxFd3ZD2HdesaV5j/1x7lHUN9t0tK0Ynh6Nb7r8//bjrngHEMhLY0MOf4r8TO4XumEwL+RSj5kjM/eCvexlhssj5ZlUk9fJz1jfxeZwN1masb5tWn7NDyGeZL4Ep0+swmRslxKKHW0yFYW7eOSm/HOoHTGXOMZ1x7JDwNrbOow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wgBrHR3vovwPjkVSH4po1UMbWgN5ps6EnO53x6EYXKY=;
 b=AybOk5deGXUYicxQThtWxrC11Sw60enbxJB4XR3V6S+GkJUAB9BvwxUBSEVaNLb/zO+etQNQFAlSaiWQ8g0UcLUApyeS7xEuym82UJMwoweUcgENoAnNMjsTpLnqSaus8FC7j6y6kbhOO1cYZ955tN9j++KeVCalpQVkdaR6ucTcs85+DGeQ+wlKhvk+Z+kBlEgs75Hag1bsBVHjN1ORcVfG99WPhZ2haEXUIb+mLbxKxYh/GJuy0szRoWiXbDjP33EZ5uILIC4zTMnbmeHN+BprhYwk8/u7XVdS+6yV0G9d1z8/MQ0OldW5Ildye70+NsbQJCKdh8ebEQQm35m+NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wgBrHR3vovwPjkVSH4po1UMbWgN5ps6EnO53x6EYXKY=;
 b=bM/E1Yc2Ac5i0XeDFeUICDsm1Ufzc31cioWYsOso1rJQcOmltjYi/sIbrX55+fVTR99u/ZS7kzfSco4y1dCFL8kHQm2r/Nl0DmfyUyNhwrp3JhwhGjUmIU2ihxoQHnyLBZ7ciFm5EuvxzRdyRBKouIfi5jx+RkH6fU/msTXK710=
Received: from SJ0PR03CA0389.namprd03.prod.outlook.com (2603:10b6:a03:3a1::34)
 by MN0PR12MB6080.namprd12.prod.outlook.com (2603:10b6:208:3c8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.25; Tue, 10 Sep
 2024 06:05:00 +0000
Received: from CO1PEPF000075F2.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::e4) by SJ0PR03CA0389.outlook.office365.com
 (2603:10b6:a03:3a1::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24 via Frontend
 Transport; Tue, 10 Sep 2024 06:04:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1PEPF000075F2.mail.protection.outlook.com (10.167.249.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7918.13 via Frontend Transport; Tue, 10 Sep 2024 06:04:59 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Sep
 2024 01:04:57 -0500
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>, Michael Roth <michael.roth@amd.com>, Melody Wang
	<huibo.wang@amd.com>
Subject: [PATCH v2 3/6] KVM: SVM: Inject #HV when restricted injection is active
Date: Tue, 10 Sep 2024 06:03:33 +0000
Message-ID: <f521f21d1e4386024593b3f69b82f5c32d7b78fd.1725945912.git.huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1725945912.git.huibo.wang@amd.com>
References: <cover.1725945912.git.huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000075F2:EE_|MN0PR12MB6080:EE_
X-MS-Office365-Filtering-Correlation-Id: cd37f508-6bfc-44d3-4cd3-08dcd15e80a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MPMua0iO4DU5KE/+vwYz60X0NKHnDJp/yxONfbd63zz/MzikcwhnfWWrgTmR?=
 =?us-ascii?Q?mhSByMBIC/65BtOMJyHaE/AEcx6u3wmg6GrPe1ZhsPgFHsWjI80OiYamE+6I?=
 =?us-ascii?Q?fXhnitYv47OFtf/vWKAQeDbcwahXnhI02zDCU2PB1DlsdPbPWpLOwUNhLO8G?=
 =?us-ascii?Q?+wXvShjbxd2h6u9FCx/mnHbJEXAPS5aHRWGxKxXzs3LlqUvieIyIIg8deWpK?=
 =?us-ascii?Q?k1I9m5dSGAbGMeogAtKYIz0BLaSqIbq4lQwcLjnFHnFnl3sGZqI5cfIfohgQ?=
 =?us-ascii?Q?vnU6a8owhxjwx7cWr484h/+2vfMBqSMTo2UT9U4oUlNuS2p11nq8lEZrIfXe?=
 =?us-ascii?Q?Gybms8J5cwDCwX4pPuAqACsdoew2Qg53zBqdeJrmj2qc/DJ9Z6UmFR38dSzV?=
 =?us-ascii?Q?DqqTjdX+vFcCWe4ZVuXFos5N6/xXT8HQSIml4pt53fNJk2+ApvVIssrYKeqm?=
 =?us-ascii?Q?6gBPGLCf7qEvZvQli71Ts+nVHxhO9AjS8OXwBmtn2HHQlkX7dgBMEXb85qJ5?=
 =?us-ascii?Q?n9WnieKX3klgfC8CdhUTLGsT9XQmfM1F1RTbOGmh5YFvWUhp4z1ijdfuvi8P?=
 =?us-ascii?Q?V/KOVxTgFlaolOScHU2mF6EzcPIYARUqjqoSqaNgoWXIbNviplqcBPgf6IMb?=
 =?us-ascii?Q?P5NKTfAYUcGq4fszR8q8eEN8xT0w8pkCi47Fx+euXY2W4jTBpc2KweExohmP?=
 =?us-ascii?Q?j0jyfYK1WmvMuEcpIJXKFuvMoGD1f3U95O7wQ4zHlY1GENCNcmSE/0gtNz5I?=
 =?us-ascii?Q?4eaij1r/Kn7BSxO5MlvBvuTVEaKlCN/GKCJ2WgMJOe2fvfNUndMg5cO3/5/C?=
 =?us-ascii?Q?ofY/ZWcJ5dAyhSGD+HQVXOJelPP7JwhoBVokcO8K6pgBv43dCnwvM03NBcbY?=
 =?us-ascii?Q?ylwG08OEXWUNt5+Vg7BQh1nk3ljjXSDm9heHa17vAJbW7/dsGGO2WHhxQnw+?=
 =?us-ascii?Q?joQ4jYi8nZhb4AWRcpRKkbOJQRjSKo07Mhn191SRBhlkDnZChcQH4nu8w/fk?=
 =?us-ascii?Q?cancb4Hf7RuIy97+oBB184NhkbgxDZ7Y1AfR+dsNglVudOECd2pLOPpXLJIP?=
 =?us-ascii?Q?OcTsPsK9Y/6xgE9uPjOGcSCx3nNBokR2G93RYW18WePquNlRibjx/vTUSfZc?=
 =?us-ascii?Q?bNPo+mZC66jX7FiaaOS0XKmOcorPCConVuRYHYiB6+dWhlAMsOQlFaDQ8CBQ?=
 =?us-ascii?Q?ZrMhk7ATCR+dTXaECgdQZrvDMhkLQ5rVHnOU8bcPx2MbA5dKMwplPKTpnzVB?=
 =?us-ascii?Q?aU18uj5Jkz5KKHNZuz1ofW3xA0uDQjeKXfuSuutG7RusUetzFu8jifCy8Rj3?=
 =?us-ascii?Q?T8/YMb7+zuXrE3ThzQIy9F6/V2eAMBzT67Y/c5kxMNm7sVcmXDrSLtDV9M/3?=
 =?us-ascii?Q?QnSKoV0fu8c3cVC0Ak3gVxgC+M1IgoBhvDwqz8I/DmLAMe/FGGBjRM0/u1N9?=
 =?us-ascii?Q?WIy/xodU5Jj7IVGr1i+k1PS0D8tv91+n?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2024 06:04:59.3758
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd37f508-6bfc-44d3-4cd3-08dcd15e80a9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000075F2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6080

When restricted injection is active, only #HV exceptions can be injected into
the SEV-SNP guest.

Detect that restricted injection feature is active for the guest, and then
follow the #HV doorbell communication from the GHCB specification to inject the
interrupt or exception.

Co-developed-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Thomas Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Melody Wang <huibo.wang@amd.com>
---
 arch/x86/include/uapi/asm/kvm.h |   1 +
 arch/x86/kvm/svm/sev.c          | 153 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  19 +++-
 arch/x86/kvm/svm/svm.h          |  21 ++++-
 4 files changed, 190 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf57a824f722..f5d85174e658 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -35,6 +35,7 @@
 #define MC_VECTOR 18
 #define XM_VECTOR 19
 #define VE_VECTOR 20
+#define HV_VECTOR 28
 
 /* Select x86 specific features in <linux/kvm.h> */
 #define __KVM_HAVE_PIT
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index e65867ea768d..f7623fa64307 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5023,3 +5023,156 @@ int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 
 	return level;
 }
+
+static void prepare_hv_injection(struct vcpu_svm *svm, struct hvdb *hvdb)
+{
+	if (hvdb->events.no_further_signal)
+		return;
+
+	svm->vmcb->control.event_inj = HV_VECTOR |
+				       SVM_EVTINJ_TYPE_EXEPT |
+				       SVM_EVTINJ_VALID;
+	svm->vmcb->control.event_inj_err = 0;
+
+	hvdb->events.no_further_signal = 1;
+}
+
+static void unmap_hvdb(struct kvm_vcpu *vcpu, struct kvm_host_map *map)
+{
+	kvm_vcpu_unmap(vcpu, map, true);
+}
+
+static struct hvdb *map_hvdb(struct kvm_vcpu *vcpu, struct kvm_host_map *map)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!VALID_PAGE(svm->sev_es.hvdb_gpa))
+		return NULL;
+
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->sev_es.hvdb_gpa), map)) {
+		/* Unable to map #HV doorbell page from guest */
+		vcpu_unimpl(vcpu, "snp: error mapping #HV doorbell page [%#llx] from guest\n",
+			    svm->sev_es.hvdb_gpa);
+
+		return NULL;
+	}
+
+	return map->hva;
+}
+
+static bool __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map hvdb_map;
+	struct hvdb *hvdb;
+
+	hvdb = map_hvdb(vcpu, &hvdb_map);
+	if (!hvdb)
+		return false;
+
+	hvdb->events.vector = vcpu->arch.interrupt.nr;
+
+	prepare_hv_injection(svm, hvdb);
+
+	unmap_hvdb(vcpu, &hvdb_map);
+
+	return true;
+}
+
+bool sev_snp_queue_exception(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	if (!sev_snp_is_rinj_active(vcpu))
+		return false;
+
+	/*
+	 * Restricted injection is enabled, only #HV is supported.
+	 * If the vector is not HV_VECTOR, do not inject the exception,
+	 * then return true to skip the original injection path.
+	 */
+	if (WARN_ONCE(vcpu->arch.exception.vector != HV_VECTOR,
+		      "restricted injection enabled, exception %u injection not supported\n",
+		      vcpu->arch.exception.vector))
+		return true;
+
+	/*
+	 * An intercept likely occurred during #HV delivery, so re-inject it
+	 * using the current HVDB pending event values.
+	 */
+	svm->vmcb->control.event_inj = HV_VECTOR |
+				       SVM_EVTINJ_TYPE_EXEPT |
+				       SVM_EVTINJ_VALID;
+	svm->vmcb->control.event_inj_err = 0;
+
+	return true;
+}
+
+bool sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
+{
+	if (!sev_snp_is_rinj_active(vcpu))
+		return false;
+
+	return __sev_snp_inject(type, vcpu);
+}
+
+void sev_snp_cancel_injection(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map hvdb_map;
+	struct hvdb *hvdb;
+
+	if (!sev_snp_is_rinj_active(vcpu))
+		return;
+
+	if (!svm->vmcb->control.event_inj)
+		return;
+
+	if ((svm->vmcb->control.event_inj & SVM_EVTINJ_VEC_MASK) != HV_VECTOR)
+		return;
+
+	/*
+	 * Copy the information in the doorbell page into the event injection
+	 * fields to complete the cancellation flow.
+	 */
+	hvdb = map_hvdb(vcpu, &hvdb_map);
+	if (!hvdb)
+		return;
+
+	if (!hvdb->events.pending_events) {
+		/* No pending events, then event_inj field should be 0 */
+		WARN_ON_ONCE(svm->vmcb->control.event_inj);
+		goto out;
+	}
+
+	/* Copy info back into event_inj field (replaces #HV) */
+	svm->vmcb->control.event_inj = SVM_EVTINJ_VALID;
+
+	if (hvdb->events.vector)
+		svm->vmcb->control.event_inj |= hvdb->events.vector |
+						SVM_EVTINJ_TYPE_INTR;
+
+	hvdb->events.pending_events = 0;
+
+out:
+	unmap_hvdb(vcpu, &hvdb_map);
+}
+
+bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_map hvdb_map;
+	struct hvdb *hvdb;
+	bool blocked;
+
+	/* Indicate interrupts are blocked if doorbell page can't be mapped */
+	hvdb = map_hvdb(vcpu, &hvdb_map);
+	if (!hvdb)
+		return true;
+
+	/* Indicate interrupts blocked based on guest acknowledgment */
+	blocked = !!hvdb->events.vector;
+
+	unmap_hvdb(vcpu, &hvdb_map);
+
+	return blocked;
+}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d6f252555ab3..a48388d99c97 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -447,6 +447,9 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
 	svm->soft_int_old_rip = old_rip;
 	svm->soft_int_next_rip = rip;
 
+	if (sev_snp_queue_exception(vcpu))
+		return 0;
+
 	if (nrips)
 		kvm_rip_write(vcpu, old_rip);
 
@@ -467,6 +470,9 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 	    svm_update_soft_interrupt_rip(vcpu))
 		return;
 
+	if (sev_snp_queue_exception(vcpu))
+		return;
+
 	svm->vmcb->control.event_inj = ex->vector
 		| SVM_EVTINJ_VALID
 		| (ex->has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
@@ -3662,10 +3668,12 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 
 	trace_kvm_inj_virq(vcpu->arch.interrupt.nr,
 			   vcpu->arch.interrupt.soft, reinjected);
-	++vcpu->stat.irq_injections;
 
-	svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
-				       SVM_EVTINJ_VALID | type;
+	if (!sev_snp_inject(INJECT_IRQ, vcpu))
+		svm->vmcb->control.event_inj = vcpu->arch.interrupt.nr |
+						SVM_EVTINJ_VALID | type;
+
+	++vcpu->stat.irq_injections;
 }
 
 void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
@@ -3810,6 +3818,9 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return true;
 
+	if (sev_snp_is_rinj_active(vcpu))
+		return sev_snp_blocked(INJECT_IRQ, vcpu);
+
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
 		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
@@ -4128,6 +4139,8 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
+	sev_snp_cancel_injection(vcpu);
+
 	control->exit_int_info = control->event_inj;
 	control->exit_int_info_err = control->event_inj_err;
 	control->event_inj = 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f0f14801e122..95c0a7070bd1 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -41,6 +41,10 @@ extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
 
+enum inject_type {
+	INJECT_IRQ,
+};
+
 /*
  * Clean bits in VMCB.
  * VMCB_ALL_CLEAN_MASK might also need to
@@ -751,6 +755,17 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
 int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
+bool sev_snp_queue_exception(struct kvm_vcpu *vcpu);
+bool sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu);
+void sev_snp_cancel_injection(struct kvm_vcpu *vcpu);
+bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu);
+static inline bool sev_snp_is_rinj_active(struct kvm_vcpu *vcpu)
+{
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+
+	return sev_snp_guest(vcpu->kvm) &&
+		(sev->vmsa_features & SVM_SEV_FEAT_RESTRICTED_INJECTION);
+};
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -781,7 +796,11 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
 	return 0;
 }
-
+static inline bool sev_snp_queue_exception(struct kvm_vcpu *vcpu) { return false; }
+static inline bool sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu) { return false; }
+static inline void sev_snp_cancel_injection(struct kvm_vcpu *vcpu) {}
+static inline bool sev_snp_blocked(enum inject_type type, struct kvm_vcpu *vcpu) { return false; }
+static inline bool sev_snp_is_rinj_active(struct kvm_vcpu *vcpu) { return false; }
 #endif
 
 /* vmenter.S */
-- 
2.34.1


