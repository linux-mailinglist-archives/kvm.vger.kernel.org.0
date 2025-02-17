Return-Path: <kvm+bounces-38358-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DA61A38010
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:27:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 75951171DE1
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED9DB216E28;
	Mon, 17 Feb 2025 10:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DZRPaElm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79FB213224
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 10:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739787793; cv=fail; b=MPpyjW1QFE0FxqcanCNoeGmoyhwK+XJuDAwaUf/YoIlRbJCUmJdFQpgmAgPLQUSJTRXc0XIcUtGHkG2uRDnYuQxUqsSTG3UJtJ6izHGSh9iCGiofFAXa1g49nElcKiG+xK6v/7k755nw7HVNfMFdEj1KhvP7jeqZBLgMSlLpZRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739787793; c=relaxed/simple;
	bh=uDbx5XzUWyHj4AaucnZQxPsJw5BFbWLyAOkje9nYnbw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mdrFjayEbU8jXRTggIhuwX3OqmBF0/zGNacbhSzlZdzWFHhyWCzgjZpKhNEva0xJxncQx9xajMkV1ndD9FdWjr5WGgEaZZVBe3vjlvWHscAhvPVq8T5SIM2uD9ZDJaZvKY2vizcumQW+qYrv2Rxw2S9JC8yEwbHCApHVO+NYxtE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DZRPaElm; arc=fail smtp.client-ip=40.107.236.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R0o3lMWNrYmPlNQlU7hCyz0hO4whdFXm1gfIKBp4rHIyP8q6pJCg1vJWyqIdic+O2gefv4UM6nsUV71C9QhZSox587g6fd+06lcN0bp9X8A8bhHbmT8jRPal9fcum7eZgxmUW0Sid3MxL7u7awqv/kCK2ZBJPU+/LYCQpZv/FpMhkd7SrpENbt9nbJtEOjXZO3pXTu6M4z4senLlfXvA/5ouMbTT+aPgXVtvhjApkL6JYIkkVCCtVdtv4Mo3MhZTaHGRLbzKwVYtHVNMfatS5oe003aoAbRm8P/LeDdBbtzJAieSI/B47T4Vg8yZqdyEm9INQUByS1Hrht1zvYbPWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/v+cTVTV9dehohiPGCxufORnYwzwF5WQo5ZtzGPuA7s=;
 b=JzWvCwAbM/gVjrvf+bsPfpPk7qju8b/sfIHU3oq9xTs9UwGl7/DuTZ476gSwDqgYkPNMZ8JX2B7Jly235ZApwG9JXy7j72CRHItIZ0gAsMjeCkCHB77kNFJMskNfGvAnknyk7m2MbOTGBwd6OIzMWK5USqDHIgCL2MnSYCZTwDQgYtEV3Kt7tJlzER8WH61oxLG5gwxO64qQOegs/kPKhht37u14P8zqFp0K8Wxnu6VE2oPMXTH6EJOUzKa94TJ92QFyY5JSEgl9GVxjIuM+04HlOtzShnRPVD7klwkWOsazBOkK+zjzZzGxW20G83JxtyTMM+d+bn6s/mO6Z+dTKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/v+cTVTV9dehohiPGCxufORnYwzwF5WQo5ZtzGPuA7s=;
 b=DZRPaElmMce9xUSMW4BognlPkIWSzVp1TwuaWkWeHP4APt0vz1ePjd8wUkIMAB7qJl6Hqt7hNM7d5pO5Ew6YaJ6YLixu9wtCGtkiwjhbharcwIDt3LwKaBRssY4+EsXDlOo8wxvVn9sUoagExXti9E02LZM2hKdT+VIuG/Yt5Ws=
Received: from DS7P220CA0019.NAMP220.PROD.OUTLOOK.COM (2603:10b6:8:223::14) by
 CH2PR12MB4232.namprd12.prod.outlook.com (2603:10b6:610:a4::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8445.18; Mon, 17 Feb 2025 10:23:06 +0000
Received: from DS3PEPF000099E0.namprd04.prod.outlook.com
 (2603:10b6:8:223:cafe::5) by DS7P220CA0019.outlook.office365.com
 (2603:10b6:8:223::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8445.17 via Frontend Transport; Mon,
 17 Feb 2025 10:23:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099E0.mail.protection.outlook.com (10.167.17.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Mon, 17 Feb 2025 10:23:06 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 17 Feb
 2025 04:23:02 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>, <bp@alien8.de>,
	<nikunj@amd.com>, <isaku.yamahata@intel.com>
Subject: [PATCH v3 4/5] KVM: SVM: Prevent writes to TSC MSR when Secure TSC is enabled
Date: Mon, 17 Feb 2025 15:52:36 +0530
Message-ID: <20250217102237.16434-5-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250217102237.16434-1-nikunj@amd.com>
References: <20250217102237.16434-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099E0:EE_|CH2PR12MB4232:EE_
X-MS-Office365-Filtering-Correlation-Id: 9150d299-82aa-4c5c-bd07-08dd4f3d11a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?z/CdTxaQW6EF0aTAE3SacNWFXC4oUszw60pclwbD/r1xOmjSHX0+alVYgM3S?=
 =?us-ascii?Q?Iw01ZjaTX+8S+q3nVb2QZBqPSZFhU89ISPU8f20tmrM3+kXWXnXreQDEo/mR?=
 =?us-ascii?Q?TLAsXszMYX8OE4cPgUWpf2DmdHqgVo2IY8lB7LJwsQ3f/yC3cOw55y7pXraF?=
 =?us-ascii?Q?RKh1HPjC4X8zqTuAjZNiHmg9j0FNN4vNg3E+mfxSWnP6WplWDZ+6ukBM6FuD?=
 =?us-ascii?Q?0Sl7+TtEP4F0xPHRD2jFbS6UkPsXpueLbc0fd6EsAh+3610dBu7VkMw0dd6J?=
 =?us-ascii?Q?UTSagq89ePOSYmg8WRLpcgBSyMo/OE8REldjoe5DKaW7+5o+2sWDxZTeODke?=
 =?us-ascii?Q?y57eUIuPb0m01lkQZKTd6gfXC00HJKJ5jS4Bl6lWeaCYL3knzVtIY2chGPLQ?=
 =?us-ascii?Q?Us7TX+V5uEc3m/gFdByIpjFbROoUaWjcHomdSrmL2lGtJ+/5RBhirVkShgir?=
 =?us-ascii?Q?JK7Qx2MX4RN4yyyiuMeCM/KYSvU8H5SCuQK/CxmvW/MrWGKzqubg+/3JIcWM?=
 =?us-ascii?Q?b3gRw9AsGTJJm4daUJsjYn/3f95IbB0gcvfgJOSEeBC/ajvn6Rdxv53Gtdi4?=
 =?us-ascii?Q?MewYvfvObr9VMlLslLMmFRx/+OX6jqgk+0yvU330m9azCrWboYm7FFoxWE8d?=
 =?us-ascii?Q?LMa0o4XFVfNnvuomPWBmCnsHITl/lXPCwTERryxwr8v4bnilKaJZIkDCesuZ?=
 =?us-ascii?Q?dNRKfVBVCPVXJN1FhAjQD/7yvgGkfZyQQJuXlA1haD9UhocVR0ZLwCMAZjMq?=
 =?us-ascii?Q?0EFrV7EfW94PBZ/13RTgJ5d6CP2E/d4G4jjg4IaGKtjcHZWASvryLG8RuNYy?=
 =?us-ascii?Q?Cszt7hmM5AI/5emSSBzuCrhrfFRqjsFf3whe0U6eBYszCYhUV+KpwzSLxMvl?=
 =?us-ascii?Q?ZrsMOyW7JQ3A2se7LpgLaRWv6iNsfDt85/sP6p8bwLpZZawdU/UknygsjkLF?=
 =?us-ascii?Q?hcSntl6U/YKIhIKkUryilU5fvIqGnnShjGZUVyfgPfVXK2uPqM2vu6l+LAS3?=
 =?us-ascii?Q?QGLMTMbTl/CK1vFXiK0R0BWWxutfHHspXuTZYR+1i78SNIUEkgNIREFlgK7k?=
 =?us-ascii?Q?j8kSVy2fBr/Ezw7gXp22JmUwfSU83EmaEiti42DIRAiast3DhbWArXOsI8tp?=
 =?us-ascii?Q?i2wdhYDv56IdL7kCNujgteIYtcwnxeKvk+elswLWFAZfQwYsaK93OyzWTdyM?=
 =?us-ascii?Q?LcvGauIvrCPf/QvEqcF41FiDUTRsAHfEp8aMdwy/1M1oZk6jnM4J9HIpR0fB?=
 =?us-ascii?Q?LCQ8o7XwCdkF+kmv5r9FzIHON4dPjqPJ9FU8ZYEkuq1gFwoKRVO0rsvdXVde?=
 =?us-ascii?Q?JeILVTAJIxrw7yrGCFf83ABlPSh0ZyOUNKTUu+6cCVXil13N44SkfERrSrSL?=
 =?us-ascii?Q?z4OPQcbFnJAssyRdCJJF/vgQNYgnhC0iER/QvKhWpPM2j+iyTFlfHGrB/NE8?=
 =?us-ascii?Q?FV7jJT194QmMDtjLXkypmxSfULK4L7x/GT+GXvje/IPwRGIN3SHtDcnCNzJ4?=
 =?us-ascii?Q?SNfTZOoGPMUblnQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2025 10:23:06.3255
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9150d299-82aa-4c5c-bd07-08dd4f3d11a8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099E0.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4232

Disallow writes to MSR_IA32_TSC for Secure TSC enabled SNP guests. Even if
KVM attempts to emulate such writes, TSC calculation will ignore the
TSC_SCALE and TSC_OFFSET present in the VMCB. Instead, it will use
GUEST_TSC_SCALE and GUEST_TSC_OFFSET stored in the VMSA.

Additionally, incorporate a check for protected guest state to allow the
VMM to initialize the TSC MSR.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/svm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 93cf508f983c..7463466f5126 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3161,6 +3161,20 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		svm->tsc_aux = data;
 		break;
+	case MSR_IA32_TSC:
+		/*
+		 * If Secure TSC is enabled, do not emulate TSC write as TSC calculation
+		 * ignores the TSC_OFFSET and TSC_SCALE control fields, record the error
+		 * and return a #GP. Allow the TSC to be initialized until the guest state
+		 * is protected to prevent unexpected VMM errors.
+		 */
+		if (vcpu->arch.guest_state_protected && snp_secure_tsc_enabled(vcpu->kvm)) {
+			vcpu_unimpl(vcpu, "unimplemented IA32_TSC for secure tsc\n");
+			return 1;
+		}
+
+		ret = kvm_set_msr_common(vcpu, msr);
+		break;
 	case MSR_IA32_DEBUGCTLMSR:
 		if (!lbrv) {
 			kvm_pr_unimpl_wrmsr(vcpu, ecx, data);
-- 
2.43.0


