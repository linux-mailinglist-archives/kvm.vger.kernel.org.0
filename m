Return-Path: <kvm+bounces-38602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8650CA3CA7B
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 21:56:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 149FB7A8FB0
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 20:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19845250BE0;
	Wed, 19 Feb 2025 20:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Bv21L0lU"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D1F24E4B4;
	Wed, 19 Feb 2025 20:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739998503; cv=fail; b=DVFnjzIv8Ik0lRBSmODMYDe05PIlqL7uR5JjyQrgsiyFiPa4rcj9qiBLEfS+5p/i/4J6adYqkioc/I+Y8g+m14sqju6uQX2gB39UFhhhGJPMoMIwvJo9LW54Q09srCdAUxCySYuV+4ZY45AxzAU61870gzoRyCQXMa53yukJw2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739998503; c=relaxed/simple;
	bh=iGVKnAsE1ba95GWCRw58c/50CmL9pjDOget8VIkoeU0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QETh07e4j6iNI9/8wa7YSgO1LJII7shL7hH5qOdXPIRZGav99sSrh4uyWliAtjaw+DDpYOWrRsjgj+nyJjscxFmUAUBkUA6po/FA1z4kH8DmaXaLCSIUtfjSkdwAtAWuNQeWt+Y03NEsZybhpNW7Nim0aWY36ojrI49RR+UazG4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Bv21L0lU; arc=fail smtp.client-ip=40.107.220.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xISBvrI+wmknMchk0YHJb3t7aWTF4G+yUoKqXbGrDAHmf97z491q5EWNkiGPgPGeZr2LfN5uG4RTlqqZquVozMzu7nBM757VFLQg162H3pmezOpOWGAZoJqDJea9+ghKt3tn32ikcZ2j+dKhAiK+/t+pyoE3osO+NMMnfksdxNJKR0PDrUzj+F/tyE95GWuNYQQfjmaMIbUWPTNAHNOpmlJ4Gz+kmvAIXhleoWJJqI1S/y2Zw3fql9NLkLLYyb4MUC8+v1w8GwtqnmB0VSBi+onyN8sjzeTeLjAF0eWGkpNuwqp37CZhQs1SY654iLjdCG0HxmuELl21S/609PSmIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WihQCoGliPJv20KI8JNgvXzX95k2sNXJNrEBuEfF0RI=;
 b=oABhEdj51cVI3LJ5o/0jIcClDUtR7wZ9+Co7Oba1VLnSc2TXJSBeR8CDwMcfOEbNrTL3Mr4JnnH7QwC6brnix7Aux1gAwak+iyiwaQlh52fkPlsfkmAh21meaA6BWwYvw5gfir8bxYk0g3DNYM0kVBEYzQAR7HDxxmyVqWTJUJ2JYG5TNNjU9HODTySnOF+iO5a8ozjXP0DYem8EK61SQ9L067ZhhSDlDwgdx8PLTHYMLID//Rlj3tzWkcsz/1wYDXkTjJHrmoTfJbkWkz8jfdiksRh9aQi9y1Fomby0W3QSOPsvWOAMcc/HFvk4TK6dw4k/Inlm7L0Ou2Y8Bcqolw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WihQCoGliPJv20KI8JNgvXzX95k2sNXJNrEBuEfF0RI=;
 b=Bv21L0lUx8Rwd2tW990bF6avWv2qA+4VCxZJuJ1/9g7JATlIkBb55PRR6U611JqRIe9+GWgd/K8v2oQQIEfNAnqECuFp9fexrrvgS/NN4uknFa4KqT7+kPrPx3iWsPtCjpDBMItRs4BKWelV+VRQNM9DEsQ+CVTTwRyacdrkZHs=
Received: from SA0PR13CA0020.namprd13.prod.outlook.com (2603:10b6:806:130::25)
 by DS0PR12MB7778.namprd12.prod.outlook.com (2603:10b6:8:151::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.14; Wed, 19 Feb
 2025 20:54:53 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:806:130:cafe::e4) by SA0PR13CA0020.outlook.office365.com
 (2603:10b6:806:130::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.14 via Frontend Transport; Wed,
 19 Feb 2025 20:54:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 20:54:52 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 14:54:51 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v4 6/7] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Wed, 19 Feb 2025 20:54:42 +0000
Message-ID: <5346a666758c21ec25d26ae184a2d1a9324f3b55.1739997129.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1739997129.git.ashish.kalra@amd.com>
References: <cover.1739997129.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|DS0PR12MB7778:EE_
X-MS-Office365-Filtering-Correlation-Id: b63c6abe-502b-4ae8-024f-08dd5127a89b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?p8v4dSLJ9m0PHA49UxCpaA+EZjbHhY+IH1vBECAFeGvhpXoysGVqNDYkjT+i?=
 =?us-ascii?Q?BuI5+v7t1JgeJ83BDE2r6ckL0YhqRp8y3LIHtvgS6tuCqQffMNWHERYtN5FG?=
 =?us-ascii?Q?zyNL9m82VMOwV2U1vMpU67BcYYysvmQmbGZOkI/1epfNHiBO8E2J9hxSenpI?=
 =?us-ascii?Q?CNvLmdkT4CXeYFbSaZ3mv2lahZbbJ4D89BrIb2ym3iiTyzSW1oo03vBihMbZ?=
 =?us-ascii?Q?sF/2rJ33sFDrBOx3YCi9tSmCCWK0/HfrGWUSO8PEIb43T0Up5jX0OY/cib11?=
 =?us-ascii?Q?vwrtD38JPQyi8fcwzvCOOImeZV9TsKsAx5UvPNRjR9AmrZtr4/81wYieuW3z?=
 =?us-ascii?Q?zzBVrnJz4GPOM9eQxJ2CeDY7nfTRvz1yAQWWOaf52AhcnAOaJ5snnd3IBVD4?=
 =?us-ascii?Q?NQgHf3wEWRj6V4rorabrqBu7Ph9oYB/3L8g6CbMHVVVV268IELezgBulnbal?=
 =?us-ascii?Q?bYLNtZHTyd8K8cHUpW2yVuW9gRy6g+jhd4+C1Zzd5WIr0Q8bzFe4Vv8yyEMG?=
 =?us-ascii?Q?1fr377qVH+9Z6XTUklXyiZa+WsCcBW0+Wyb18kc0M373sFYHZbtYPkkxAitI?=
 =?us-ascii?Q?Y4VN7wFaBJvO3qA0U0gcMc1S2vSNalbrj/z7SlDwNGDVf+WFGhBeM8WCQRzN?=
 =?us-ascii?Q?f74Je8cK2tvFvNsC1OAX6DUz3EnaecxVTDGftoTDEkO3jn125H6IUUQadiwp?=
 =?us-ascii?Q?xZf77Ra4XwhJQvDRTiRJCxnhCrKrXXTqZ5OrasIQ3UPuU+9wc0aOJygejmJ3?=
 =?us-ascii?Q?Wlo5y1XUuVY58LcQ1ThZMfBlUuRtT1nsCdTY7vJnwgGS6MYPyp8zbp+KVYDf?=
 =?us-ascii?Q?1NZY8hrR3mXvpQ7+8TX2LeFTkZboTKYfhHpORLKt047jsoYrdEAaHWPNPnqH?=
 =?us-ascii?Q?eCOCnJ/DdYAGPDmqBiZp9gzJ+A5ZosRlQgOE1clErhn/AwsROTnevC77B0iU?=
 =?us-ascii?Q?mrvBOCP1/b/mM8scyD38NXT8QP95WwxONSPXThxcAyjXK7WhMaJcxUD7EiAL?=
 =?us-ascii?Q?/HjAqF7Fjp5qT33aLbPm17Ao7/Oaovbdc7uArFp1BtnXIOkLIFbwh1r9ivLo?=
 =?us-ascii?Q?D54xxdqDgY8oDGFj4/IbjoEZsmzsvoukepkKrMPDWmoPdSnaeSndvPF6Hdj8?=
 =?us-ascii?Q?/XefrCGnJkyMKvAQPdvGw/fAQlJDdtAotb4Dmm6lVw5fVnOjnpqhXohuIkLP?=
 =?us-ascii?Q?00aNHzXMZXabfmh67S0dBZTqHAJVkbuY28t49T2cKAShniLSI7StcGbIa6nV?=
 =?us-ascii?Q?GduFk2Akz7GFMjXNk+wDyPmKhc4CY1uQ2K3kNLnC3GOscHY8IIPH92j/udL2?=
 =?us-ascii?Q?Im9kfu3XeF5laQAZ9ZJj+7Ge6RxDrwWxPhcSgiPW43s1TYcLRS3bXAQ8E4r1?=
 =?us-ascii?Q?ljMUXXkliVh8uKpaOkOnknN+MpKuQANRtMkqpCCq34ybihedG/VQ9f9WkAmd?=
 =?us-ascii?Q?aKLmM2iWS1M3i7+Zve6xzz8gle7S1TthrcuxelYCV9iXeEBOz/7vxtN+NG3I?=
 =?us-ascii?Q?KtTuZ9vBlMywEdRb15e06rtIdZ9lEqzbJOy7?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 20:54:52.9846
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b63c6abe-502b-4ae8-024f-08dd5127a89b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7778

From: Ashish Kalra <ashish.kalra@amd.com>

Move platform initialization of SEV/SNP from PSP driver probe time to
KVM module load time so that KVM can do SEV/SNP platform initialization
explicitly if it actually wants to use SEV/SNP functionality.

Add support for KVM to explicitly call into the PSP driver at load time
to initialize SEV/SNP by default but this behavior can be altered with KVM
module parameters to not do SEV/SNP platform initialization at module load
time if required. Additionally SEV/SNP platform shutdown is invoked during
KVM module unload time.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 74525651770a..213d4c15a9da 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2933,6 +2933,7 @@ void __init sev_set_cpu_caps(void)
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	struct sev_platform_init_args init_args = {0};
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3059,6 +3060,17 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (!sev_enabled)
+		return;
+
+	/*
+	 * NOTE: Always do SNP INIT regardless of sev_snp_supported
+	 * as SNP INIT has to be done to launch legacy SEV/SEV-ES
+	 * VMs in case SNP is enabled system-wide.
+	 */
+	init_args.probe = true;
+	sev_platform_init(&init_args);
 }
 
 void sev_hardware_unsetup(void)
@@ -3074,6 +3086,9 @@ void sev_hardware_unsetup(void)
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
+
+	/* Do SEV and SNP Shutdown */
+	sev_platform_shutdown();
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
-- 
2.34.1


