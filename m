Return-Path: <kvm+bounces-55530-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 22F6DB3242B
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 23:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 013D7B65DCA
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 21:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8038633CEB0;
	Fri, 22 Aug 2025 21:26:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="q+RAkXFy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2040.outbound.protection.outlook.com [40.107.237.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0268C33CE94;
	Fri, 22 Aug 2025 21:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755897974; cv=fail; b=c7hMUKrSXUT3XYoB9W+FNM5QQF1WAixi1kEmXkWYcuqfMRK8rJGrLqHkYto0wzsavoONgvzT/7zQ3ZUXsRtvMILWlx7Iss8MpMWgPh+SuZgQ3WK6zAWpktB0eKi9FM4Gbp3D6Q0Ys7OoDM5hTWlQRH9D/LHTLpIlyHcIMbJnvGA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755897974; c=relaxed/simple;
	bh=gV4gxwfeA+xwLIYks9A6tODs336WbWjYm6MD2uV0RzQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=enDFSbbWx4ruzgMnOGWrq61MR12oGxhx6+dAjs1rlVpktYcfrpGTD0aieoSuPOUPKc+cdDfftmtZ/km4ILnUd0fPpBDmjY5cpsdDW8izkJkq4bFBqTDPto7oweJsEQvHB7Gwd/pNZ9r65xQJ0rIv5FOldZ8IVfnR0pTto0zkwqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=q+RAkXFy; arc=fail smtp.client-ip=40.107.237.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EUrn0RxzAFzExZrCGLjzPS6+2rqD+nbSNaerK+PS3VGO4euVQs9EuAn25iO6Gi9qCQqJQt8Zt0nTJsUmo3aDnZY5ASxKmr2m3YJvhS0UkRn/SeRn/NI5dYNLflAXuxaiOq9y1RVEHM76VrBjdy9FiJqK5fgQIj8Njr1gDqadM7xGg9bXXjyP0JMmruL2tQz31d8zvq/8Cifg2FjMcGyWIwV9nrSrf8h0bITV8gPhtgB2GDWlRFGpLQ7SNywYuPURYBwWaqknP+gDqKxtCFOO/nn/yEP25t+GXY2ocsAX1OJao3FT9sunMguN13HN2EvCpMQRzB9i4cbTWRE3oTQwzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=64FtdNmtlsjMeTveq10OeReqRxhsy1X9GPf0nuDzGS8=;
 b=yTVy5wjgyiYqsRIF+PBcOnKI5zRYreDgbIOlIi7ODh4pi6IRqox6/GG4UtOyKLS+1hNQe7bpMGqz+yqnqpYKw/oXG0Vfmjth0x78AMfw7Mr9By3006ITRwPHxA8pz1j62s/JUQZL9cm2ccK/fsZikYuVMOMij7XPO7BmmLsqz0F9wlWZcibwowQyfCRa93jIasYNeuV7nHOUiOC5KoCvTY+j5Ta4A0GWKHtwstci5aJD9hYOn3UGD2qRzG/2g4ILh3rrjmuk/U9vAxJrIpFscJpc7i28bxyY0+taLB8wG2xKkY96BUCqQDI2YV12WP1HjmHTk1cIFV8SZNRgBunoXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=64FtdNmtlsjMeTveq10OeReqRxhsy1X9GPf0nuDzGS8=;
 b=q+RAkXFyhShWCTx0un1xxfzpSodLl8b2LqkHISRtGYcSJUOxOQOTOWKIYdLpVBdj4WXkdod0o8mbMiTImDsIjotVPUye5yuLhutPiCRm6+/FL0HZQQ2lFJg69ScftCyM/zK+X5orSuy0uLWC5wiJiZEYym14aaGDh1hDwxpuNaQ=
Received: from BY3PR10CA0020.namprd10.prod.outlook.com (2603:10b6:a03:255::25)
 by DM4PR12MB6229.namprd12.prod.outlook.com (2603:10b6:8:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Fri, 22 Aug
 2025 21:26:06 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:a03:255:cafe::9b) by BY3PR10CA0020.outlook.office365.com
 (2603:10b6:a03:255::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.19 via Frontend Transport; Fri,
 22 Aug 2025 21:26:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Fri, 22 Aug 2025 21:26:06 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 22 Aug
 2025 16:26:02 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-crypto@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David Miller" <davem@davemloft.net>
Subject: [RFC PATCH 2/4] KVM: SEV: Consolidate the SEV policy bits in a single header file
Date: Fri, 22 Aug 2025 16:25:32 -0500
Message-ID: <efeb1c3979170c4c4d544eac3888f194b7712f88.1755897933.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1755897933.git.thomas.lendacky@amd.com>
References: <cover.1755897933.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|DM4PR12MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: 517bebfc-beac-4d9b-da0b-08dde1c2813d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IyZBjoRy4F9q2OLpV8iFK3l1j7hwnnppBJ4PQ0hQ33ySMAsfq9Ksdqr28gb9?=
 =?us-ascii?Q?aahWUAiDUAtpQh7WapFhj2pr2DmR7Qa8nDbZHarQEn6SyfPmJ+p3Zcn42Pek?=
 =?us-ascii?Q?xHp1bBRivzoJvX6XMo3My80x4XoF9Ej1V2ZSj9E7P7I5XvaHIxE6WSrhze/p?=
 =?us-ascii?Q?c8FaC4tjE8KmFxm3qix3gZzJzV+ZfYr5pakPSIicIKQknksW+D7hO+cLN1Kl?=
 =?us-ascii?Q?FVecj4XvxBdBrcYlTk5A+eYu7Z1nG8IIdp+pSSNRFOB0kdXNvjgdJBGdbR1o?=
 =?us-ascii?Q?kHzUfuJ/ctQgiehhxCi1g70QmeOlvdhJcq6MO0omW65b4V1xW1UZHPeezmOG?=
 =?us-ascii?Q?bIdh1paE1LnQGuDqJ9d8ru8uTRgFyqE/OzK7gWeVm26UTtEzM4QmJ8C59tZT?=
 =?us-ascii?Q?NYDtMyIicYhbo0IBsD7GCRN8nGD17rGRgDWpzQE4IaFGeAmzOxZKEhqS8RIt?=
 =?us-ascii?Q?4fDO1Z3Qn9kO1Eu6mhESyACx+WzhfTqaSAJIfB1jPuX2+YUeaF1IzeW1Vn6b?=
 =?us-ascii?Q?LYVbKnffrngFGypliPmd1DtvjUXPFkS/nI/BDi2KJR/q8k00L0bUwyoOF3Yy?=
 =?us-ascii?Q?nA7Uye8XnNkHMRI6MUwKs5AtzIMe1bqyEWFDDXpfYLmz1p+z5ZmE5GXeIfLX?=
 =?us-ascii?Q?wh6mi85u05bQrEdMcopclyTliHFxUDgSMQr84dg/kUGPMTid/sgHn4h8cV8N?=
 =?us-ascii?Q?TqypXHHZxmMInUIlIDCZYAdICXf7oQqNZZTv1RTmlBeEetIfQ124zR2DjPwx?=
 =?us-ascii?Q?IC+MsUzW6DSAV/ITWHEbWjEVQ/KEwq42ThzskplBTrxK0tE2wrTNoYuVskkJ?=
 =?us-ascii?Q?P28ltgyv/8hx9TAiPiN2TSDiyoydhDnypfyEMXVNG8n4DYYHzjQtHu5HCw/Q?=
 =?us-ascii?Q?aCI1Q1ifeETaHyMQwsKpb8eH4y2ORJNYjwyOAvUOdQcclby62HIOVAbnzKYp?=
 =?us-ascii?Q?p2t11emtJ+/QMpyAq9Ipos09QGfC1bwxkuJDEA9MlVrPo1eMX4s9BoUOxkfM?=
 =?us-ascii?Q?Yfjmf5UxUxzWU/fvewXeoIQCwZVBDseUTSXlLdxvF2ytY9PbfYY6HTzsmZak?=
 =?us-ascii?Q?/TnNe0N4IndceaH5hwuRnP45sSVapLk10G+lAu8yTPuiOdY5YPuQ+iD+zhkL?=
 =?us-ascii?Q?kN95490Tiglmou5HhKFZEjA7N3U6n3RbXvHE6ckrg5M+dUevoZRh6siJgFQ9?=
 =?us-ascii?Q?JzpnsVfbERh8Y8Rk2ldAGzMlHA7sKWSwpRilb+FbEs1JrCfJWqxNM7/uIBkf?=
 =?us-ascii?Q?ysznz5F7j6VmehVP7u13ZcrivcsOB2NwUA9jlyHDkNZz3VUTsIBsVqbcDy8m?=
 =?us-ascii?Q?1RHeor20mlcoQoVM96w7NvHTBpakEjgzoJcp5GXeB0UbShoNneeiLuIRR6YJ?=
 =?us-ascii?Q?WGVfzBsdpeL5BrKnYwSwPbCoWNHYpXWtz+ZI31lnmFcT+GxWTht4DeiyLzwJ?=
 =?us-ascii?Q?2iM/yJZ2Ff2CjsmMFjAywmevHQThbpf6P9AlyYstaKWRnYzw7rn6MLWIKoY+?=
 =?us-ascii?Q?o2sQ0qc8d/JKCLU5JNGdyMpaSUJn/C6AZsUd?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Aug 2025 21:26:06.3795
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 517bebfc-beac-4d9b-da0b-08dde1c2813d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6229

Consolidate SEV policy bit definitions into a single file. Use
include/linux/psp-sev.h to hold the definitions and remove the current
definitions from the arch/x86/kvm/svm/sev.c and arch/x86/include/svm.h
files.

No functional change intended.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c  | 16 ++++------------
 arch/x86/kvm/svm/svm.h  |  3 ---
 include/linux/psp-sev.h | 19 +++++++++++++++++++
 3 files changed, 23 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 7e6ce092628a..b21376e83ca7 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -63,15 +63,7 @@ static u64 sev_supported_vmsa_features;
 #define AP_RESET_HOLD_NAE_EVENT		1
 #define AP_RESET_HOLD_MSR_PROTO		2
 
-/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
-#define SNP_POLICY_MASK_API_MINOR	GENMASK_ULL(7, 0)
-#define SNP_POLICY_MASK_API_MAJOR	GENMASK_ULL(15, 8)
-#define SNP_POLICY_MASK_SMT		BIT_ULL(16)
-#define SNP_POLICY_MASK_RSVD_MBO	BIT_ULL(17)
-#define SNP_POLICY_MASK_DEBUG		BIT_ULL(19)
-#define SNP_POLICY_MASK_SINGLE_SOCKET	BIT_ULL(20)
-
-#define SNP_POLICY_MASK_VALID		(SNP_POLICY_MASK_API_MINOR	| \
+#define KVM_SNP_POLICY_MASK_VALID	(SNP_POLICY_MASK_API_MINOR	| \
 					 SNP_POLICY_MASK_API_MAJOR	| \
 					 SNP_POLICY_MASK_SMT		| \
 					 SNP_POLICY_MASK_RSVD_MBO	| \
@@ -3062,7 +3054,7 @@ void __init sev_hardware_setup(void)
 			sev_snp_supported = is_sev_snp_initialized();
 
 		if (sev_snp_supported)
-			snp_supported_policy_bits = SNP_POLICY_MASK_VALID;
+			snp_supported_policy_bits = KVM_SNP_POLICY_MASK_VALID;
 	}
 
 	if (boot_cpu_has(X86_FEATURE_SEV))
@@ -4993,10 +4985,10 @@ struct vmcb_save_area *sev_decrypt_vmsa(struct kvm_vcpu *vcpu)
 
 	/* Check if the SEV policy allows debugging */
 	if (sev_snp_guest(vcpu->kvm)) {
-		if (!(sev->policy & SNP_POLICY_DEBUG))
+		if (!(sev->policy & SNP_POLICY_MASK_DEBUG))
 			return NULL;
 	} else {
-		if (sev->policy & SEV_POLICY_NODBG)
+		if (sev->policy & SEV_POLICY_MASK_NODBG)
 			return NULL;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 58b9d168e0c8..61911a2b78c3 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -113,9 +113,6 @@ struct kvm_sev_info {
 	cpumask_var_t have_run_cpus; /* CPUs that have done VMRUN for this VM. */
 };
 
-#define SEV_POLICY_NODBG	BIT_ULL(0)
-#define SNP_POLICY_DEBUG	BIT_ULL(19)
-
 struct kvm_svm {
 	struct kvm kvm;
 
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index e0dbcb4b4fd9..27c92543bf38 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -14,6 +14,25 @@
 
 #include <uapi/linux/psp-sev.h>
 
+/* As defined by SEV API, under "Guest Policy". */
+#define SEV_POLICY_MASK_NODBG			BIT(0)
+#define SEV_POLICY_MASK_NOKS			BIT(1)
+#define SEV_POLICY_MASK_ES			BIT(2)
+#define SEV_POLICY_MASK_NOSEND			BIT(3)
+#define SEV_POLICY_MASK_DOMAIN			BIT(4)
+#define SEV_POLICY_MASK_SEV			BIT(5)
+#define SEV_POLICY_MASK_API_MAJOR		GENMASK(23, 16)
+#define SEV_POLICY_MASK_API_MINOR		GENMASK(31, 24)
+
+/* As defined by SEV-SNP Firmware ABI, under "Guest Policy". */
+#define SNP_POLICY_MASK_API_MINOR		GENMASK_ULL(7, 0)
+#define SNP_POLICY_MASK_API_MAJOR		GENMASK_ULL(15, 8)
+#define SNP_POLICY_MASK_SMT			BIT_ULL(16)
+#define SNP_POLICY_MASK_RSVD_MBO		BIT_ULL(17)
+#define SNP_POLICY_MASK_MIGRATE_MA		BIT_ULL(18)
+#define SNP_POLICY_MASK_DEBUG			BIT_ULL(19)
+#define SNP_POLICY_MASK_SINGLE_SOCKET		BIT_ULL(20)
+
 #define SEV_FW_BLOB_MAX_SIZE	0x4000	/* 16KB */
 
 /**
-- 
2.46.2


