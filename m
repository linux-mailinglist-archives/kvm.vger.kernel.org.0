Return-Path: <kvm+bounces-32613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0920D9DAF65
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 23:57:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDBBA28164E
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 22:57:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D742E204087;
	Wed, 27 Nov 2024 22:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vzaqpsDA"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2082.outbound.protection.outlook.com [40.107.93.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BD6203704;
	Wed, 27 Nov 2024 22:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732748255; cv=fail; b=U/f0PwdZhCcx1AYigpW2qJ4AgYU1B8hm1/e7zFdx3pdQLbspAzFLKAs0DR8G+sKw5Mup2+d+XVnHZc+L640v4SNURBdwBqTLS7iNPjiGxrGx2WgLRrXgNp16PT2rJ44Bu9uYf71Yf7VPZlVSeLSrZxv/S0vMohecdOiCB6TD0ts=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732748255; c=relaxed/simple;
	bh=74XSjuNJR4yfTOXlTu0upmcncP1IauW8MVha0A7XLac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CEEyR+xHcoh7NWmhwZ8LYAQuyi3wyo1IFPJhje4+BiKX5oTREjyQMIxFJZhB+zlpFu4CR5PaFpwxnMtISaZ7rpElABq0WpdWj8hEd89CNzzSVQb42C/8efUcc5rTfYev4RS97ohf5nW5EBCxBhyMxVbxCVb+q9trF3FgbN7LRX0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vzaqpsDA; arc=fail smtp.client-ip=40.107.93.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zEXTfgJlh+R743GTHtcXkRyF04wozHYVsUtBZGSYGd8VJ7Fqkyoc9Gcr96e+8LhfhqA3a6LjHeb3o91XhYEhcl/YGPR58n6hVYpaix5PcnB2sm6GlZOa5VwgKIUQoTB2Jq5DhbqpS0EMPSVKrEmXkT7Sfbe1BKBq/LpigG6HeubokLQGCbdOToeRmvuPPhlWXfAfTqvgxdPVooo6D8vJxEB9ldS9DWswap5EfWCouZjiUX/QIZDASUfPqpbP9MyRv/UiA4KBFYaU4VROjYsvAeb6WehSfZNxNylcfi1ozQfOdhGh0S3cQISH462C5WO7U3qrVnO0PaNfR52uaAnQfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UN7UVbzhY6KoiLPYLqE9n+rTEZUrpnHPIyIodxuy54k=;
 b=QbjlARhOJQuiyuyDmRcTuOIuJXaEn1Y2hlWR738ZUQMaHtJoEz5Wk7Hs+SsmG6WQOhy2aqEarWszx9WdR8LEgjG2JNJ1pWkRgLQZe1Y41pGMvhQx7wRycq7bcihD7xM+8l+JXKe5PoMyEW8EXXWgHPKQoJl1eNj13wCmmbkjCKd+Q7wykP72l2J+OYkVynmSoOZ89zSdLbd2Y0MZp+iyHrwnAA9OfVMw3YIKbKD8T9Is92Mun+HJThiakplkl2UDERVInTJWmB4j5wsr+FRM88lwuChUNkK3Ut+sAlcK6InT6AKUtJpVsXdapI+R7aU9MX2fAmyB2lEdkcC2mWnVzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UN7UVbzhY6KoiLPYLqE9n+rTEZUrpnHPIyIodxuy54k=;
 b=vzaqpsDAYN6jdi07QJqtxJn98+yrw9z/m+wD5RRkZXcqd62GuKdWGwpNGAl0QmYp2sVpBN9La7T5R9byieA8cxOsEvMv06Xs5jwRwDPz8bXvWftnYhodrWwtvGo9e45CxFPXmoLokf7aVo5uBSPs1552IrTnvHp/UqdgZmeu4Js=
Received: from BL0PR1501CA0012.namprd15.prod.outlook.com
 (2603:10b6:207:17::25) by SJ0PR12MB6831.namprd12.prod.outlook.com
 (2603:10b6:a03:47d::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.23; Wed, 27 Nov
 2024 22:57:25 +0000
Received: from BN2PEPF000055DF.namprd21.prod.outlook.com
 (2603:10b6:207:17:cafe::4c) by BL0PR1501CA0012.outlook.office365.com
 (2603:10b6:207:17::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8182.17 via Frontend Transport; Wed,
 27 Nov 2024 22:57:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055DF.mail.protection.outlook.com (10.167.245.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.0 via Frontend Transport; Wed, 27 Nov 2024 22:57:24 +0000
Received: from ruby-9130host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 27 Nov
 2024 16:57:23 -0600
From: Melody Wang <huibo.wang@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>
CC: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Tom Lendacky <thomas.lendacky@amd.com>, "Neeraj
 Upadhyay" <neeraj.upadhyay@amd.com>, Ashish Kalra <ashish.kalra@amd.com>,
	Michael Roth <michael.roth@amd.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
	Melody Wang <huibo.wang@amd.com>
Subject: [PATCH v3 3/7] KVM: SVM: Inject #HV when restricted injection is active
Date: Wed, 27 Nov 2024 22:55:35 +0000
Message-ID: <20241127225539.5567-4-huibo.wang@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241127225539.5567-1-huibo.wang@amd.com>
References: <20241127225539.5567-1-huibo.wang@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DF:EE_|SJ0PR12MB6831:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f39c428-e135-4914-fba7-08dd0f36dbd6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CkS8PlDG8bOpHnSZVrgmrush2kdtlw6ex9CDkvPh3N8obD7y1/v1HMmtVuIu?=
 =?us-ascii?Q?8WkR0Gw3ptPgxwQg8aFQqwJdS9tSwLbPBbnpUAcQvdxdjFYT8sPwEj0zI5uy?=
 =?us-ascii?Q?GYBUGByOwypatjohL+6TW2z8ELX3C7YmrkGf9kEIzN+L6Fa6y0+UybO4Hlfy?=
 =?us-ascii?Q?3oP2oCXbblHuqoKmYKJ+KP3g4HLAcOIvchTOGbrV8xaDnoh7LHVLAHQFvo6Y?=
 =?us-ascii?Q?23ipHA0k2fFkZ5PyGDXZoTYAdhF98JrySsl6BUOFZnGm0uitxFviJ9O7/RVA?=
 =?us-ascii?Q?CDFk15WwjQhpYx9qYiYl0/OM9yyPuca3pReOTtyo7wADlD3S3hQrk1zsbbts?=
 =?us-ascii?Q?ju7j0sMT34M+HldjH9q4PAQKaTQGxWvTxTcVPrwNEIsixhkhyOYuAEiO1bqk?=
 =?us-ascii?Q?VRXT4d4VdtjTTh6zUMke2Zx+VNBhOHTovLDbfK90/gjp0DG0H+YxcLgXgyqF?=
 =?us-ascii?Q?93DcgxzXK7g9xJd52eNACt07CLJ3RSsaIqOEITiKpXr/IFUeb4aN1aGWh14d?=
 =?us-ascii?Q?nQ/0IZ39d5QJpBt6vXD9a5qHJgbcGrBOLinObTjh5F20rdh5LVfjcsYoxQnE?=
 =?us-ascii?Q?L1p1jOUvIiyisSNj/DUDHxjtYKZywbCMxeNEXug2SlPNar4I9mgA23Ay756P?=
 =?us-ascii?Q?/FIJg8TzNTsmTZslNUczD1iXHkacyEtJBpTpykVOxEIvZs+350yEO7q1kEg6?=
 =?us-ascii?Q?ayWM2jUI/EfgDkjid9YdrfSku6wEPOkbGyCfnIBmLvJYutJvFZYcYxwqwYeq?=
 =?us-ascii?Q?VKds8FtrbIl1lXYcS2Qs6NbSIp/MHPUOip80TIERnAzUOzwmqJ82Jr4UL2LD?=
 =?us-ascii?Q?KbdxvaYW5xGgbs9GuD1ua3Fp/3I41WkozpNC7cWX/qQFwSrN9h4dSsdYTUXJ?=
 =?us-ascii?Q?YeQqi/J2l+E3keC7UOJn4sUIPt4VsLGApVcoDAY1DxaRVWgpkL0tRfbY4h8V?=
 =?us-ascii?Q?50v1o/TFXlfuCNBhEEA56p0u6LDa2nsZc6GYUY6dZValjV7f/KVRs00zU0Y9?=
 =?us-ascii?Q?BTpwrueCZz64r/e1Sz5CqG+qx/wxhmAKXkcSpQZuAUiJAUN1S2KDQcefZobk?=
 =?us-ascii?Q?Bgqp/6DsWkOhul49x0xDDNzHnTMD1PmVaoZrM/zPzIkM6NCb6vMnNWvHmfbQ?=
 =?us-ascii?Q?vZNXW2eKIomJhSI+QgjDGTQkGn8OzwkyI69+9NeYsUrG+0gk+rXWJpTBSZH3?=
 =?us-ascii?Q?Aonh5Fmq5mx8vBFGwbsUZzGm9/g/NG3uaMpxC2SiKX3oVwLEbpBzn23a4pGE?=
 =?us-ascii?Q?/dEQEfoB6a455g0TLm42eXBQ5lopmSc7ggHRRguAkUrwyMXzox8FEBOtZBF/?=
 =?us-ascii?Q?e6tfD06oq+FR/PtADXfs08u9XcfzsFSxvesAU0NSXbquj3XYgpqZQOV03kue?=
 =?us-ascii?Q?+4r+MaizUTvAfxKRppXJ269Tue0T/iH0GHqWxsuudUOaOg6f47SraRJcOdJI?=
 =?us-ascii?Q?hKBDI5dPqGA/XY1yxAIIj+y56apgHZFN?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2024 22:57:24.6803
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f39c428-e135-4914-fba7-08dd0f36dbd6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DF.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6831

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
 arch/x86/kvm/svm/sev.c          | 165 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |  16 +++-
 arch/x86/kvm/svm/svm.h          |  21 +++-
 4 files changed, 199 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 88585c1de416..ec82ab4ef70c 100644
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
index 7cd1c0652d15..77dbc7dea974 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -5028,3 +5028,168 @@ int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 
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
+	kvm_vcpu_unmap(vcpu, map);
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
+static void __sev_snp_inject(enum inject_type type, struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct kvm_host_map hvdb_map;
+	struct hvdb *hvdb;
+
+	hvdb = map_hvdb(vcpu, &hvdb_map);
+	if (!hvdb) {
+		WARN_ONCE(1, "restricted injection enabled, hvdb page mapping failed\n");
+		return;
+	}
+
+	hvdb->events.vector = vcpu->arch.interrupt.nr;
+
+	prepare_hv_injection(svm, hvdb);
+
+	unmap_hvdb(vcpu, &hvdb_map);
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
+		      "restricted injection enabled, exception vector %u injection not supported\n",
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
+	__sev_snp_inject(type, vcpu);
+
+	return true;
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
+	if (WARN_ONCE((svm->vmcb->control.event_inj & SVM_EVTINJ_VEC_MASK) != HV_VECTOR,
+			"restricted injection enabled,  %u vector not supported\n",
+			svm->vmcb->control.event_inj & SVM_EVTINJ_VEC_MASK))
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
+/*
+* sev_snp_blocked() is for each vector - interrupt, nmi and mce,
+* for example, it is checking if there is an interrupt handled or not by
+* the guest when another interrupt is pending. So hvdb->events.vector will
+* be used for checking. While no_further_signal is signaling to the guest
+* that a #HV is presented by the hypervisor. So no_further_signal is checked
+* when a #HV needs to be presented to the guest.
+*/
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
index dd15cc635655..99f35a54b6ad 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -467,6 +467,9 @@ static void svm_inject_exception(struct kvm_vcpu *vcpu)
 	    svm_update_soft_interrupt_rip(vcpu))
 		return;
 
+	if (sev_snp_queue_exception(vcpu))
+		return;
+
 	svm->vmcb->control.event_inj = ex->vector
 		| SVM_EVTINJ_VALID
 		| (ex->has_error_code ? SVM_EVTINJ_VALID_ERR : 0)
@@ -3679,10 +3682,12 @@ static void svm_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 
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
@@ -3827,6 +3832,9 @@ bool svm_interrupt_blocked(struct kvm_vcpu *vcpu)
 	if (!gif_set(svm))
 		return true;
 
+	if (sev_snp_is_rinj_active(vcpu))
+		return sev_snp_blocked(INJECT_IRQ, vcpu);
+
 	if (is_guest_mode(vcpu)) {
 		/* As long as interrupts are being delivered...  */
 		if ((svm->nested.ctl.int_ctl & V_INTR_MASKING_MASK)
@@ -4145,6 +4153,8 @@ static void svm_cancel_injection(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct vmcb_control_area *control = &svm->vmcb->control;
 
+	sev_snp_cancel_injection(vcpu);
+
 	control->exit_int_info = control->event_inj;
 	control->exit_int_info_err = control->event_inj_err;
 	control->event_inj = 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 161bd32b87ad..724e0b197b2c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -55,6 +55,10 @@ extern bool x2avic_enabled;
 extern bool vnmi;
 extern int lbrv;
 
+enum inject_type {
+	INJECT_IRQ,
+};
+
 /*
  * Clean bits in VMCB.
  * VMCB_ALL_CLEAN_MASK might also need to
@@ -765,6 +769,17 @@ void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
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
@@ -795,7 +810,11 @@ static inline int sev_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
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


