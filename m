Return-Path: <kvm+bounces-33347-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 011649EA2C7
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:27:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A608F280199
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 23:27:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA521F63F7;
	Mon,  9 Dec 2024 23:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XLnwj0Qo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0807D1BEF97;
	Mon,  9 Dec 2024 23:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733786796; cv=fail; b=mnWHFPhYP0mgKmAxF+425QySbS2MjCM9pumwYXCkuoB2WbGtpo/ze1FMfQfbZi5cfhr+Ha/AqSTnpLHcDCvA0dQhH1dlj8BiKDeL1Z9ik3Gu3U6qrt/sdx/cOxWeyrbkQrVhjHo6B5iJRcePCVKhgdYfcD1hTLdfBpI1GbdPo3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733786796; c=relaxed/simple;
	bh=F/35dmvZkldhrQbnwFCsE8SqWQPzl6ppWOkk7uyXRnI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WXioWPhAReYPAAT1N83gA7IwuML4bdiaHGTPHQhQbf2SdfSL+ZUHEfA2dMjt/S5GgEpOQFLAKguS1WKtEHfcQxXkflmGl33OJqwtDbTcvDC0plco3dfo+FlQv29gY7IGu4LOKRLygihQNW5NNVpOMiu+kaS+0s7wsKWvsiBNDqQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XLnwj0Qo; arc=fail smtp.client-ip=40.107.220.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lZDCU6zOnQgapBNUYcD0Kc0TQFF3X0NY3VkeRk5oYwK6Lct/lQ5AbM9GD0WXD3RFeUg9AywVG8i1QbHQZxns58j5Et5A7nPSlTd+HoG0L2Gq7JhQx3G2X9yXlfSq0IOl6AxivfcL/OJ58XgeRXVILG1vBU8fhv091x7vcnGEBKuBTbmMo4kJ2P2vFb2HS4RW2GC+l7krY2em1wiO+6rthoyH2SJd1FfgVoTv8Kfwl2vpe0Yjhb5gqXPmEiba8MobcWI78DvXy3jwKNMbv0YxT1NAO4IZ3GKOMMtgWtQg1Q8kuOCqOMz6yWDOBLyKZfnKA9FzjGuThWY+DSNvSBEFTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lEVj5KqtcuT71cWqXxzZRa5CQVzK5eTVd6RS65Lz3k=;
 b=BkSwiLCMcLuhRWNUM1rjS2liHFFfv8nA92PQ0quZKCIAVCB+ZNdCcZGWoe1Yyu/X5gC3aq8L3hr7WXmKNo7GN+k7R3Nn4NSrroPNoB9ItyrgK+VC2xsNnkINwPmKsJmaoKFqoxJycLoVPgpoxzzbsxlcHM651L3QBgD//kWpAN2jEzVSnYx1HjKcwmanfTUt9oCXmIvifuZ83bZOI/lu7NOIMCD1qRGznwSbHY9Hmai2aQEAho4oZjxPc33/bzME+N17Nd7DNoT1OOUvyyFr96QxiTSR5INCjJwiqI+dIeGQtWrR5Lw7BqDWans9x7AgcJqYsTmz12etbePm+c6oTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lEVj5KqtcuT71cWqXxzZRa5CQVzK5eTVd6RS65Lz3k=;
 b=XLnwj0QozrPv6N2ev4+UDKTKyPbHTIAPvKZlPcw4dwu5ZLkj2ey1fWWm5T1XcZzaIkLPBtV7h8jgo8lLZg7NKEYUcpPzvPUWwoG1mLIh5T1VvcKWxlUoEXH3mCy+saeKSNCBACfQ77KmkRXz1dIS5vSNYe8VSxbhbWwNko3WnLY=
Received: from SN7P222CA0009.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::34)
 by DS7PR12MB9526.namprd12.prod.outlook.com (2603:10b6:8:251::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Mon, 9 Dec
 2024 23:26:31 +0000
Received: from SA2PEPF00003F64.namprd04.prod.outlook.com
 (2603:10b6:806:124:cafe::5a) by SN7P222CA0009.outlook.office365.com
 (2603:10b6:806:124::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.15 via Frontend Transport; Mon,
 9 Dec 2024 23:26:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F64.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Mon, 9 Dec 2024 23:26:30 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 9 Dec
 2024 17:26:29 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 6/7] KVM: SVM: Add support to initialize SEV/SNP functionality in KVM
Date: Mon, 9 Dec 2024 23:26:20 +0000
Message-ID: <d52e765e558afc021a7cf97e515dbec28bc492a3.1733785468.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1733785468.git.ashish.kalra@amd.com>
References: <cover.1733785468.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F64:EE_|DS7PR12MB9526:EE_
X-MS-Office365-Filtering-Correlation-Id: 34a8658f-cbee-48d1-c3e8-08dd18a8e98c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?n+dGOxg+SAjUyGDGJFgodO/20f4S1C0X59t7rZ1JsTV7x/vevykgrTdJkPqf?=
 =?us-ascii?Q?ApAIC6ZAokjaV7CedP1U91UsZDPw2jDYO6BIE6e0nseR0T0Hw/qaFhhDCYz/?=
 =?us-ascii?Q?Mt7D6EUT2AAqkV7MbVu/J0t8pTF6lyEBdtTnb7ejSuRCONo+Y5buEAIlKdlJ?=
 =?us-ascii?Q?4RR7lNmicnGq0MIrkePzYTAjUvC0vZgCRzXRjxShyl1X0ZCD9BPpO4RgRpaA?=
 =?us-ascii?Q?tpkOAO8Y1fMxrhuSWh8leg/Vsl8irHNMNwUy/+211wi9ybfmbvcOnhW9zfmw?=
 =?us-ascii?Q?kAD52szT22k1kBYLJ8twppnuREt/1oAGXhqF93q58K02hDqHR72I2zuEHXW/?=
 =?us-ascii?Q?+llxpnU/DpTeB4gL6l/Z4FdOybZDXdI+V1cx6IhsG/ON0CWekT601pxoFRFz?=
 =?us-ascii?Q?z9iQvkY/O7v0CViMVxtdx4H/xcbCxvWuvPWkbPg5OWUTpPfLbrHfQwyubo5Q?=
 =?us-ascii?Q?mwOPnNQ51UPChYDxUDhh0HT5RLzg61hQJhCKLnG7WCCBtMiWn7kGxd/oj7UG?=
 =?us-ascii?Q?RQiiCzSwSZG78M+Ae+knSPQiLjMIcQLGquZaJWoPLX3kRylqo4yzvkFAMHe1?=
 =?us-ascii?Q?/P8efwC34wkfG3WO8iiLMIUdGdyidLZRTQ7ozIJqSlBm+F4yuJfJVnuwTJL0?=
 =?us-ascii?Q?WZVBQexeH5SfLhb9dUj+UD3qszE7MfM8pT8SVdO0K0ciqq8M6fzqk6SgMgky?=
 =?us-ascii?Q?9l27TrEB2/1ZyKHhdg+qlvs4+LHefq3VghAjkj4uVDA2UenRIc2875wshNHn?=
 =?us-ascii?Q?ezbIgxlm5bXRxhNdLzF2aMt3XVet296lt0vSqC7wHOR69a7+8OSvyieKEzds?=
 =?us-ascii?Q?lFHyNQMNPT1NMCPTna1YKV7Ev4wCcDh/7uO1v5lJVSk0pbBWVF6KJWhRmAN/?=
 =?us-ascii?Q?x4y+1QCjplTMHj5BtBMJhf7+bN94nqLhy/sNTt1Pj1n9oum8evYoIS2gQyhJ?=
 =?us-ascii?Q?E0iH1H5V+agQPDeUpdY9fKq1dDWNJCnmOwxAtEg4P9x8SkjgyLBt3AxCzRjg?=
 =?us-ascii?Q?PxuvbG6wIkSZR//Axx6hw6CBZTahiJHPvm2XnNMe4yHp35Azp3AcbBpO3Qp0?=
 =?us-ascii?Q?OHvEbAbbzHWnjX3p47NxzCa+2dFEGayiaT0V0i70uKfZCu1zzXrbcPAZtQQI?=
 =?us-ascii?Q?XbC0wgsrHllRClgHnHjlZqdLv5GHnrC3l1mDqE/xBDzon3tQMkESBE2YPjQt?=
 =?us-ascii?Q?8NyH2MfR3bem5laTyhMst/wNyUUGTxmUJc3HEyuMU2vWnnKEYdx/wix4Dhjs?=
 =?us-ascii?Q?xbxZ4UWHJPeDZn5o14chTjvo6sN24Pc84EnjuTEB8W9NKj2cnvas7BH4+pXU?=
 =?us-ascii?Q?wM4riVmOR/vB4H4+iR7eBaiG2M9F4oDFloydj89AqQGEr6LOm020OGqsQiwl?=
 =?us-ascii?Q?COxEd8EGaTd9acRn8Ss+WY34LYYDcLMTyHSv6ZuPpA/wgWPAHiBucdWXcsNW?=
 =?us-ascii?Q?XDV81R64VvYiZOKJ5onDKLciAbx7XLLfqTqrba5bgwFnlgLTKuem6Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 23:26:30.7586
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a8658f-cbee-48d1-c3e8-08dd18a8e98c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB9526

From: Ashish Kalra <ashish.kalra@amd.com>

Remove platform initialization of SEV/SNP from PSP driver probe time and
move it to KVM module load time so that KVM can do SEV/SNP platform
initialization explicitly if it actually wants to use SEV/SNP
functionality.

With this patch, KVM will explicitly call into the PSP driver at load time
to initialize SEV/SNP by default but this behavior can be altered with KVM
module parameters to not do SEV/SNP platform initialization at module load
time if required. Additionally SEV/SNP platform shutdown is invoked during
KVM module unload time.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/kvm/svm/sev.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 72674b8825c4..ffb5c907c5bb 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2966,6 +2966,7 @@ void __init sev_set_cpu_caps(void)
 void __init sev_hardware_setup(void)
 {
 	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
+	struct sev_platform_init_args init_args = {0};
 	bool sev_snp_supported = false;
 	bool sev_es_supported = false;
 	bool sev_supported = false;
@@ -3082,6 +3083,13 @@ void __init sev_hardware_setup(void)
 	sev_supported_vmsa_features = 0;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
+
+	if (!sev_enabled)
+		return;
+
+	/* Do SEV/SNP INIT */
+	init_args.probe = true;
+	sev_platform_init(&init_args);
 }
 
 void sev_hardware_unsetup(void)
@@ -3097,6 +3105,9 @@ void sev_hardware_unsetup(void)
 
 	misc_cg_set_capacity(MISC_CG_RES_SEV, 0);
 	misc_cg_set_capacity(MISC_CG_RES_SEV_ES, 0);
+
+	/* Do SEV/SNP Shutdown */
+	sev_platform_shutdown();
 }
 
 int sev_cpu_init(struct svm_cpu_data *sd)
-- 
2.34.1


