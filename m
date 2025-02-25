Return-Path: <kvm+bounces-39183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BF9FA44E47
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:03:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F23DE3B2766
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:03:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 301A12139B0;
	Tue, 25 Feb 2025 21:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F667efCY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2DD212B32;
	Tue, 25 Feb 2025 21:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740517309; cv=fail; b=OZAC5VbVWN36gvTWr6YrIufn+FvQfrFJk+AIfZpuivFe7BxMBG23ofZYhT7wcXd21VRpMQVLk2R8Y7M2O9pzZiZrLxaCx5+IDf8t5VgmwcL+U/PL99M4oop46YLaS6eIezIJoALuAfbD30xlxafoJij0WldbKuS84mIWRcDNAy8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740517309; c=relaxed/simple;
	bh=5M8q7AlUVMOVcRmAPQbHPU6y74MAsDMBSHiVAW1QVXQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aptq3JzXZ5/odAcLeJeS5hQmZ59Imh9V1x7EZ7WFb0v7/bRhQV7Q277icM4ywlw9Fdr33KRlPj3s20zOTamPePU0An8goRdI8g3MCW8CBnN8Vtkf0rILdEm4NnYWJDUSFCexV4EWjOtkp3YcpUvCaTuvUxkq0XtFoPHWo9DDjbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F667efCY; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fcn4MqTSTUeDRf3N880l5h2clC8alLIzaULcN7Ucclvp7FWBT3iZ8DzVC1RcKATdr2OUj8jm680Y3U7g1a26urAw3YJIw/0T/IhW85KtSnnnf8G4h/zw1BCIPyoZO0rnlpubrDns6x+4DW4b9/BiGmt+O5qrWXo4iu7dadLICGZSWuOk5AADZz83pD8/8D30ejg7pa35z7xBC+4f03GZ4ZG77mHpVX/2GKKqp7CMJ10/0Z7sBu7hI/UAjMU2A80tV6WzjrS6JTYecc6SGOQRTfWgBYJvdbvIjFPvurKNOVcjjU+thbH8MZq6W91UvnwsWophdHq1tns/j9tFiyocJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T/jGJRlHghRALuWwtHv4TbPUQayeCZ2sJZ5IAeU+xr0=;
 b=DT8lQD8fDPG+WAOTclfNE2NU/zY2HbL/z9bReRDBk7KGfvV7hNCohJOMU93TQ7hrBrKcGMGnhV8e39kQRJzSBZxtH4ogQzK1MQfferWBRc3b/1dQFwvdyMnpNCWuGwBUZaCv3mq8tzoR3nMBjfcCwiwdz0TYLMy4jQwRBIWN3wqmqdaVA4pAo91lMzQTYz1BYKi5V4Qmp9FXNr5Xg+ZqH17N1HWX9THPsJ7AOTKnB4Eu5uZ04+olp02kQAUfc/l4FmcN87zPgXDBREPZxXtPM+MlCXGTAN7/B7rBKq2KzOY4CiVBZUQWC4PIn0ATHtL2H9WLZw3bqnjMspcLwvB5/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T/jGJRlHghRALuWwtHv4TbPUQayeCZ2sJZ5IAeU+xr0=;
 b=F667efCY/9v/cI8rkPOLZ8f8niubaNoohr3hJrVoGbT1rGDzPBKWazYY2IMrUPf9L/FufVEsqhlU3PIq0o379FhH8F9oXTxTCJcxlaYavby6RnR2Gzdq20hOzBHrM6j9LgXmLbxFsZnjtRVg5m0FwhZ3c31Dt5uACAS7QEUWzWE=
Received: from BN9P223CA0024.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::29)
 by PH7PR12MB9174.namprd12.prod.outlook.com (2603:10b6:510:2ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.18; Tue, 25 Feb
 2025 21:01:45 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:408:10b:cafe::f) by BN9P223CA0024.outlook.office365.com
 (2603:10b6:408:10b::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Tue,
 25 Feb 2025 21:01:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 21:01:44 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 15:01:43 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v5 6/7] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Tue, 25 Feb 2025 21:01:33 +0000
Message-ID: <27a491ee16015824b416e72921b02a02c27433f7.1740512583.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1740512583.git.ashish.kalra@amd.com>
References: <cover.1740512583.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|PH7PR12MB9174:EE_
X-MS-Office365-Filtering-Correlation-Id: f5db8c53-8b95-4aaa-e8d5-08dd55df9c7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|1800799024|36860700013|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?X+4/Prkj9ffO6wsA8NFKBFmrn1MVkvud22dOv/0i1cu1sZSw4v2/Pd3z/hIj?=
 =?us-ascii?Q?mM83LrobRI+47mjvkHJWRjqMC4PCYuZsMfMkB0vnCaWGLOqPPthgVxAAgFmp?=
 =?us-ascii?Q?B6/cEY71OEMWpn0w9viQhV1edhpXhAE3A31vZlyPSytOYZdSFvSSNw7TcnEg?=
 =?us-ascii?Q?9yNI1ihkrrD3cmXeh+FsE6CvysyOl1opx4fz9oYuiUpwEmKVGsmB21/YUO74?=
 =?us-ascii?Q?FgiP9lNKhQmJGODa9nxlqLLVbta+CUHaNnSvO0TieMsXfmdGmyYEs5uZchRM?=
 =?us-ascii?Q?81H7HJEprzRzJhqdep50oajTM95FeVYTSLrPBpvMGOpV0vL8WXYfnF3No6HD?=
 =?us-ascii?Q?Rw58jvOFW7OjkdhTPW7bvNKe+GprHb9+Gr/gtDaE4z05fatPMv+YE9xE3NPZ?=
 =?us-ascii?Q?9kPVmGT5JceqqdY6AO3x72hE+msoeAqJ/yE//tqvo5b7iYeiEEJ8IODfrNZL?=
 =?us-ascii?Q?2NIPKLqAfLZi1O7LlnwTL6DuAxToVIP6Xqtxz9otEuqIYuFfeEFKYRZ3fcWa?=
 =?us-ascii?Q?8fbVUyLMbKtou2X/J8cu3TwOTse79JsrxdEXZyEZgZM9EEkPqw3Aed3DvtP8?=
 =?us-ascii?Q?ndU8d3c4Zc6V8EJiCJtjTkt8UaaZQK50pKX9RfdrAkUSalybQHqcm9QDPSxx?=
 =?us-ascii?Q?DLx7hnucjfvyF+2sGM2F/KNckU5XLVCiQnD3OZ6wJrfdhmb8qSI/hP4L745O?=
 =?us-ascii?Q?S5vsuhTZn/pdN87YZE6O2Ue/8Orirpv8yeEvNLlgFvu6m6ReWlgGNghTS1En?=
 =?us-ascii?Q?qf5Q/EkF+iPtyxtPx9Irw04qqPJtpaQckgLYVpa7Xk4A2Qod1LRCp5X/jWzI?=
 =?us-ascii?Q?Mn0cIaamZwj1D9Bi/MPTCC9XdeQVKigJZL8M+BbzXc8CrUObYEIGzLMWugrB?=
 =?us-ascii?Q?dq0KqrG4ca36jbwvpOPQt7qCyt7mV6Rs0UgLw+DJIWQ7ZLAVAJGFXyuv1fn7?=
 =?us-ascii?Q?s8IS2D3GMgDFbjGMZ4yHuBKToTfGXd+5Ca0MWx1SGM579QQ6l61fnIF6e27v?=
 =?us-ascii?Q?Hn80wgsRKRz3UQY3KrQNRPU3ntLpbwXgPhWMGk2d8WZjNM35tsrJDPkXc9mE?=
 =?us-ascii?Q?jSKoild7sU5/E07XDRdD5HbTVhpjvUt+LQeubBW4xE8jXJo/UQWvo4AC9wUm?=
 =?us-ascii?Q?J7oMiwoYeMLb7dTUZP0qFWD/H7Dr9F8FxnW8kwyPa66XbxhcZigzN/jQOBkI?=
 =?us-ascii?Q?j0fLk4+GuaOpPXUhJpe1PNeob6JYWL3iHcXZ5mqKtSTHer5UcOS4YdcDeK/T?=
 =?us-ascii?Q?WJMawEUJCYXt4ifiM0QzHzFHInu/ySaNgOpE8avuJ1FiIX9crOjC+48A0s2k?=
 =?us-ascii?Q?XM3KjDw0JFbVhfe2UKv/XzSbOaFmXqRcPcPlQa8/5aaxIWV7BB7FrDRvEwND?=
 =?us-ascii?Q?pp58BKS3SVJ5gfKhoAlk+OISsTwyT6DClESiepVzV4EZuqkWniYv6jZuXhrG?=
 =?us-ascii?Q?OozNgnNWIIEHQHUQt8Hg4ChDmm+MeoZQ0/X1BaPwxWwDWScDF0nzcxsFrcxa?=
 =?us-ascii?Q?6cmwIsYNLEH5g0c91UPReyBony5L2U7yobJc?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(1800799024)(36860700013)(921020)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 21:01:44.7418
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5db8c53-8b95-4aaa-e8d5-08dd55df9c7d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9174

From: Ashish Kalra <ashish.kalra@amd.com>

Move platform initialization of SEV/SNP from CCP driver probe time to
KVM module load time so that KVM can do SEV/SNP platform initialization
explicitly if it actually wants to use SEV/SNP functionality.

Add support for KVM to explicitly call into the CCP driver at load time
to initialize SEV/SNP. If required, this behavior can be altered with KVM
module parameters to not do SEV/SNP platform initialization at module load
time. Additionally, a corresponding SEV/SNP platform shutdown is invoked
during KVM module unload time.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 74525651770a..0bc6c0486071 100644
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
+	 * Always perform SEV initialization at setup time to avoid
+	 * complications when performing SEV initialization later
+	 * (such as suspending active guests, etc.).
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


