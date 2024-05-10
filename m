Return-Path: <kvm+bounces-17230-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9344E8C2BCC
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 23:24:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B6E711C20AE8
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 21:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFFF313BC09;
	Fri, 10 May 2024 21:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="rxHBbdFZ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2087.outbound.protection.outlook.com [40.107.93.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFB8495E5;
	Fri, 10 May 2024 21:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715376201; cv=fail; b=ZnqD6kCInpwzWS+jzreEt1flNtdg37IwP6Pwc4s6nqXiK+sJfTu6oSdH3OMR4zQNADaKK10x261xpoxkCHRvG3ii2Nd3eX8ubI6e2uTjb6M4LxzltiOHWNXwZv2p8iXdoe+5Kh9u4gsGrSydx+eNzM6fPELq2WpqwnF7CTLl83s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715376201; c=relaxed/simple;
	bh=Gn/oiY0yOolQrRRDRdSHYpW4FdOjuCwG53+hfv1xhdc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bsJB/8aryCyr4l1JtmOVnL1nOW791JQj5rQjtL9u9utTQRjH4CiDotnenYlmlPP++4oiy7igD2Yu9iRIsb5K1Su5XTicV8Knr+qTEYdLtMkXsS5RFMgik1SE27owdHzfiiYe47YrGorjZeooqdPbkwwyReQRiaXsGjPi5UgNpv4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=rxHBbdFZ; arc=fail smtp.client-ip=40.107.93.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMMZ51K0pCoY8wC/D+TQp7ua+Lipsrx5/s6ReOGTGSAhZdfR5EVgYElvF+y0xqdvoFWCxGRZ+G5jEjVNPspLf8FEDfsdxmepd/1K5qTCtKUvoU2R/z+slHnovTX6pnLzOi/Bd2UET/bJh0wj6Nt0aEaEkAJ//58ezgyc+JSmlJyTXX33blmUsJuPJc7iG0E9tMgUHWHq6oNkF8g3L9e7Y6txEVJlmUamkJ4aQtabjp6h23hf2J23AxrF284Pg3GLZdKA5KVuqVOmZhQbPHOtGREmPsJzANz3jkusy2IglK4H3JbT2Avq3JeC7FUZIghEnEFY1nTqHeWICF5YPa/MCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=q/2cwL3HB1cDl0yv5lORVTiUiHMVQkwQTdlawJgJkiw=;
 b=ZdjO/qpFvR23OmJZGsYAmNakjI75cJlGTyguYQ2NHNuUOIiT+5xGzklJiDlRVSWQ6Kx/54kFZLPTMEALfKlhhg27X5gxh4MQGK+YnhHty+e9ik2TLzG0eWXGF6MdKsbGjeIe61iwyokzu1xfxoKP10JcFPrQLNXoGPzm72kkN3adM0g4wQWe44D+3oZHT3WrslLc9sEHCTmdwJbYY9uhBDCh4zBxEgijzJjngNL59HCM/KvCWa5TRIHVM6oRCftzGmotOw8V16q0NZU/Uj/4EJQTDik8PraNJyvN5v9DM1CmpXx7SYJmkTnu7ekDz4WgIKmeJdKzAhI4CMX4GZBIPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q/2cwL3HB1cDl0yv5lORVTiUiHMVQkwQTdlawJgJkiw=;
 b=rxHBbdFZiiFD8bOQeb+mPQZFs/4WSX1LWJ0vOMTJZ6T0Zce9Ws9ElQqUqU83vLj1CBZUbLeqk7zr4AjiagGv82m7XbJqFoGw1yIH/pjqwQx9U6yRoLEGMS7u39UwI+PSsCZu29OS1PAvUTarD/l2TFZC3OmeA8f6T3Nzw5u4Vn8=
Received: from BN9PR03CA0779.namprd03.prod.outlook.com (2603:10b6:408:13a::34)
 by PH7PR12MB5830.namprd12.prod.outlook.com (2603:10b6:510:1d5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Fri, 10 May
 2024 21:23:12 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:13a:cafe::e2) by BN9PR03CA0779.outlook.office365.com
 (2603:10b6:408:13a::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.46 via Frontend
 Transport; Fri, 10 May 2024 21:23:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 21:23:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 16:23:10 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Sean Christopherson
	<seanjc@google.com>, Brijesh Singh <brijesh.singh@amd.com>, Ashish Kalra
	<ashish.kalra@amd.com>
Subject: [PULL 07/19] KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
Date: Fri, 10 May 2024 16:10:12 -0500
Message-ID: <20240510211024.556136-8-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240510211024.556136-1-michael.roth@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|PH7PR12MB5830:EE_
X-MS-Office365-Filtering-Correlation-Id: 44b2ecff-6638-4a61-7503-08dc7137658c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|376005|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2NLK+PiyGjdwGELDPcpbRESR8U5QPtQ9ZfmjaOcrLgOe004PUB6zuWWTBbVC?=
 =?us-ascii?Q?YnaC9HlDNKCGFDTGgUlfMigLlARBZToCwU68+SDZe324oIlCQ2n68yRiIu11?=
 =?us-ascii?Q?CQUGGprQCE4Bjqr258/2E0tOxKJUiPzozhaGG182aOaiLKRkElg3SXLqLLDb?=
 =?us-ascii?Q?OkXBED79Jcr01MTTqRZ5ZyGF4E4kLHRApa5KgvH/DSBvuc4NcJUcdRqHR9Im?=
 =?us-ascii?Q?jhaVlE0OLDxa8Sm+BNjUDDkXdlrNXw9KYLX8wWtHstYUOHxQmcld01CgzXwD?=
 =?us-ascii?Q?hiEU1ZlRAMD3mtz8wSEoaJtXOHRAJ5hhbGaDFqJatGYSB3hdhxg893hrv/r5?=
 =?us-ascii?Q?uLH9VLb8EzzXNsAbFhIQZpG63TYuPwJ7X+sMvA5hTgvOdHm/lyMAuYktu4vn?=
 =?us-ascii?Q?fZEyNstmnHMVVI4JhFZu+ZM/qzm47VkxE0YgfIuyBPeEfLWI23OP6Hba4lUk?=
 =?us-ascii?Q?AOvMPMPKjSw6/jLdvpEpqcZLSc0LBO87HKcBK4voA2ulAw1luLcg4H9tis6j?=
 =?us-ascii?Q?h6WLWhRQd8ZkEs51s7tlH5+eVd2VsCb1ZBnRKXn8jFtLMrTRSPTBH979WvpI?=
 =?us-ascii?Q?R6glheOHssJf+cxo2oj9K3Wi5znCiRUv+QqEMbtT8wQeMSi4dLyZu0SIh3G0?=
 =?us-ascii?Q?4pegAXpPS575AdW5mshgr66tmKhkcEI1PG0zEl40F26cRTDhXcxSg+jHs6M+?=
 =?us-ascii?Q?rWzFEyaScWjfYCcZI2MeDuvDiXzwOlvi0/K544ky6CfPrdepKNoB4hMaCYKx?=
 =?us-ascii?Q?dGd42rOIYdQbJx174wYGYIyKDPbwrWBP0PKZJl/vnBqt6EgyXnKrwqkr1ByR?=
 =?us-ascii?Q?kORi/vrtukchtVehvfD+oyDzGh57TdWstivtw/IDcRRR+V/K4OnUrdoI7YLR?=
 =?us-ascii?Q?93au9nkNjtQjFgdRakFYxyC0tnIOQKhK3IZwfspAid2oJWQ4VegptGGVTYec?=
 =?us-ascii?Q?GE/onWIPHxKzg70UE1ZmPrS0xKaHvkgQVLYniGpRcExXvan0m4r+y89wm7Xo?=
 =?us-ascii?Q?Uw+jN9fy8cGrZaPHQS+X3txHGegi3SlAvdL6fLC9PTLQFMCT/ctw08jHNNyQ?=
 =?us-ascii?Q?VXHv0Zx+yi8/C5ag9BDybpp+RN4v1DreWuC075U5YebuI4uPrDyS9/YzWQDn?=
 =?us-ascii?Q?KRgM6VQbH+vtk2HYQPYubOCp3O8i1vsVOYXJeJIwl0yROpdHPmVg4Tzb4aRm?=
 =?us-ascii?Q?yYC+QOcD1kAApc13+fKjutNvDyAov+UqUWtUBKw5b+5NV0i9R2vryvxgrwtP?=
 =?us-ascii?Q?/5mW3yJd49JPlZrDfBlG/NEUusWZDJz3shfWT37O8+bZXOz3Qy3vMg6OTunD?=
 =?us-ascii?Q?62pKyn4PZuZrIrboHB7vZANGSSrvTqO/nZgGMfYVhjY75VCY6+PnuXN+yGvk?=
 =?us-ascii?Q?uJLUAM9ZImskj7lDZrJ5+eovtOCo?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 21:23:11.9986
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b2ecff-6638-4a61-7503-08dc7137658c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5830

From: Brijesh Singh <brijesh.singh@amd.com>

SEV-SNP guests are required to perform a GHCB GPA registration. Before
using a GHCB GPA for a vCPU the first time, a guest must register the
vCPU GHCB GPA. If hypervisor can work with the guest requested GPA then
it must respond back with the same GPA otherwise return -1.

On VMEXIT, verify that the GHCB GPA matches with the registered value.
If a mismatch is detected, then abort the guest.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Message-ID: <20240501085210.2213060-9-michael.roth@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/sev-common.h |  8 ++++++
 arch/x86/kvm/svm/sev.c            | 48 +++++++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.h            |  7 +++++
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
index 5a8246dd532f..1006bfffe07a 100644
--- a/arch/x86/include/asm/sev-common.h
+++ b/arch/x86/include/asm/sev-common.h
@@ -59,6 +59,14 @@
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_POS	12
 #define GHCB_MSR_AP_RESET_HOLD_RESULT_MASK	GENMASK_ULL(51, 0)
 
+/* Preferred GHCB GPA Request */
+#define GHCB_MSR_PREF_GPA_REQ		0x010
+#define GHCB_MSR_GPA_VALUE_POS		12
+#define GHCB_MSR_GPA_VALUE_MASK		GENMASK_ULL(51, 0)
+
+#define GHCB_MSR_PREF_GPA_RESP		0x011
+#define GHCB_MSR_PREF_GPA_NONE		0xfffffffffffff
+
 /* GHCB GPA Register */
 #define GHCB_MSR_REG_GPA_REQ		0x012
 #define GHCB_MSR_REG_GPA_REQ_VAL(v)			\
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 208bb8170d3f..557f462fde04 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3540,6 +3540,32 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		set_ghcb_msr_bits(svm, GHCB_MSR_HV_FT_RESP,
 				  GHCB_MSR_INFO_MASK, GHCB_MSR_INFO_POS);
 		break;
+	case GHCB_MSR_PREF_GPA_REQ:
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_NONE, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_PREF_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	case GHCB_MSR_REG_GPA_REQ: {
+		u64 gfn;
+
+		if (!sev_snp_guest(vcpu->kvm))
+			goto out_terminate;
+
+		gfn = get_ghcb_msr_bits(svm, GHCB_MSR_GPA_VALUE_MASK,
+					GHCB_MSR_GPA_VALUE_POS);
+
+		svm->sev_es.ghcb_registered_gpa = gfn_to_gpa(gfn);
+
+		set_ghcb_msr_bits(svm, gfn, GHCB_MSR_GPA_VALUE_MASK,
+				  GHCB_MSR_GPA_VALUE_POS);
+		set_ghcb_msr_bits(svm, GHCB_MSR_REG_GPA_RESP, GHCB_MSR_INFO_MASK,
+				  GHCB_MSR_INFO_POS);
+		break;
+	}
 	case GHCB_MSR_TERM_REQ: {
 		u64 reason_set, reason_code;
 
@@ -3552,12 +3578,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 		pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
 			reason_set, reason_code);
 
-		vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
-		vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
-		vcpu->run->system_event.ndata = 1;
-		vcpu->run->system_event.data[0] = control->ghcb_gpa;
-
-		return 0;
+		goto out_terminate;
 	}
 	default:
 		/* Error, keep GHCB MSR value as-is */
@@ -3568,6 +3589,14 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 					    control->ghcb_gpa, ret);
 
 	return ret;
+
+out_terminate:
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SEV_TERM;
+	vcpu->run->system_event.ndata = 1;
+	vcpu->run->system_event.data[0] = control->ghcb_gpa;
+
+	return 0;
 }
 
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
@@ -3603,6 +3632,13 @@ int sev_handle_vmgexit(struct kvm_vcpu *vcpu)
 	trace_kvm_vmgexit_enter(vcpu->vcpu_id, svm->sev_es.ghcb);
 
 	sev_es_sync_from_ghcb(svm);
+
+	/* SEV-SNP guest requires that the GHCB GPA must be registered */
+	if (sev_snp_guest(svm->vcpu.kvm) && !ghcb_gpa_is_registered(svm, ghcb_gpa)) {
+		vcpu_unimpl(&svm->vcpu, "vmgexit: GHCB GPA [%#llx] is not registered.\n", ghcb_gpa);
+		return -EINVAL;
+	}
+
 	ret = sev_es_validate_vmgexit(svm);
 	if (ret)
 		return ret;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 305772d36490..202ac5494c19 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -209,6 +209,8 @@ struct vcpu_sev_es_state {
 	u32 ghcb_sa_len;
 	bool ghcb_sa_sync;
 	bool ghcb_sa_free;
+
+	u64 ghcb_registered_gpa;
 };
 
 struct vcpu_svm {
@@ -362,6 +364,11 @@ static __always_inline bool sev_snp_guest(struct kvm *kvm)
 #endif
 }
 
+static inline bool ghcb_gpa_is_registered(struct vcpu_svm *svm, u64 val)
+{
+	return svm->sev_es.ghcb_registered_gpa == val;
+}
+
 static inline void vmcb_mark_all_dirty(struct vmcb *vmcb)
 {
 	vmcb->control.clean = 0;
-- 
2.25.1


