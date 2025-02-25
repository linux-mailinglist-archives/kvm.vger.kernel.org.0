Return-Path: <kvm+bounces-39184-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 960EEA44E4E
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 171C21883C65
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6D9D212FAC;
	Tue, 25 Feb 2025 21:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0OtJOAnf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2067.outbound.protection.outlook.com [40.107.96.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC331ACED7;
	Tue, 25 Feb 2025 21:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740517344; cv=fail; b=VIMSvH9ELhQUFkMua/lNEDI0Wsn56Eh41hkUNysV1V6L55s6JPVmoy98K0oC2dOYJej+tHthzppU7mbNwwZBrmkLmqcp+1L2L0NhL1heIakYgzl3sA051W+EZE3FS46dUieTQ3S1BeJRK6adimn2WE7l+7vCWoTjbhiCVhGYxic=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740517344; c=relaxed/simple;
	bh=p0BgXyh+NOtBXF5xbIBRRyWoW75l4NOMwGMQj6OYf1g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I8MyFmvQKdUp5gbhPrQZXnkYd1JkwexSjsTqNd99Cm1VQOrYnNbAwHINWJVJd/TBfgXHtk7OuGt/dCIjghqUGXQrN3I5DXN0+bd6V5cluXrWQf0qrSTEbwr61nNDvaFuvVD5UMC4kkpd9tzu4F6mQ/D2a1x2BNXIhXsAf68KKfc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0OtJOAnf; arc=fail smtp.client-ip=40.107.96.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wLwQRKqAwDzo4vpfL2FwGE6zuNfLV/sYzWCj33A56H8Y2ENYzFDmot/aCGEU5pHCKCB0xSTbWUo6YFwJumZ+uqa8bCpE2f0bS8l6pCRbAd5/NYwM269Q92JyvbU15IVS3h2iLRfPs+gfg4llMB+V2xWcnL0LlKTtS70n8mTGNXVZu4mL6XZfSJAlscIgJkvm2ZNwa+Z/CfEULoLcYP75UdnkZ9AYx8Foio15Z+9xurBN61trb2SeS3i4ut9p3GVuVWXQQACz/vA2H3BicZsg4izcQ4HEDyB7rD8YZglLAzx/HvO/d1DgBiLVByQf03ysr577SOWgRXatfLbn13M+OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiulrPXwQOQQq5n5DhfafszW8wKDlwGwHkJVWNgxFpE=;
 b=qgMIXi9Y/nLmZz8x1/siag3dyHL6I7x5JmQsGOePOecOe3P/eQ9d9IO+e3nuTTfzNvZmjiGhYx8hs/30HXac1jlkZVGsL8dgexFrVGrA9CF1n30RflPl2XI76ChaIpa0SOFopZstHNFL31CH/j0t9xuc+36P6behzoDiw2+RugQ3QL9Op1w4oIXxp5oekkG1uhFdhZ65PamcZAJtVOauHU/gDicpO5GDoKZ1mLEaMo0YGfqAe2vyIz92nez524Aaf09xRBCfdO0SCwcmpKurkYUBk/N8xY+GMb+AUODAPtB6Y9YK+U+FUEYCb3hr8N1/eFlDkM0aFBSulvP4t8YWEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiulrPXwQOQQq5n5DhfafszW8wKDlwGwHkJVWNgxFpE=;
 b=0OtJOAnf5TfYJROXJ0C4sprtt48J0PHm/h2a5uimZ7xDNuEKMbsf9J04wvJJ+6+wgXWZ822dprTtxlB5Udq1F0Ed8Zp5EmCrT8n9T3eArFDeo2pW9Ab/RwVzPt4x7T+C/pdOkNEa3D5NzR5PzNZm0PiN6D/VYiQxANsl/ZqpoJE=
Received: from BN9P223CA0027.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::32)
 by PH7PR12MB9075.namprd12.prod.outlook.com (2603:10b6:510:2f0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Tue, 25 Feb
 2025 21:02:17 +0000
Received: from BN1PEPF00006000.namprd05.prod.outlook.com
 (2603:10b6:408:10b:cafe::f8) by BN9P223CA0027.outlook.office365.com
 (2603:10b6:408:10b::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.18 via Frontend Transport; Tue,
 25 Feb 2025 21:02:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006000.mail.protection.outlook.com (10.167.243.232) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 21:02:17 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 15:02:14 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v5 7/7] crypto: ccp: Move SEV/SNP Platform initialization to KVM
Date: Tue, 25 Feb 2025 21:02:02 +0000
Message-ID: <6c8dbb978e0785ee5a33165a9c43d555991fc505.1740512583.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF00006000:EE_|PH7PR12MB9075:EE_
X-MS-Office365-Filtering-Correlation-Id: 6de0b60f-0e07-4158-ac0f-08dd55dfafbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|7053199007|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9LqfDprtQ5lVTWs/tQ5c/N/fsC4YX8eZVq/IRLqHXZMdGTNvrjjoWj1bleI7?=
 =?us-ascii?Q?tkvrV0+X/9+I/5724t2jKTJ4jgMVXN0fxrwXcRbp1Ye12AedNpArc1tqfmjF?=
 =?us-ascii?Q?egR3Iz/DWUVY5d1HpQed1XTMyM/bD0UCJCci80dC0njJPJ1OxLqPhoKpkbmk?=
 =?us-ascii?Q?lei9UFks55Vw9inmojy+tNM57ahG5QA9FOL+Ln4oOrM8olOMVGmGFu+QMu5R?=
 =?us-ascii?Q?5EpmLqIFiX/cLU+b+TnVyjzfZsYR29Z3KAW5qJDV4GxfKGouTsN6o1DczCRq?=
 =?us-ascii?Q?eiRNwjh4JmXJwvgDzcVyCuVjTfmPeSiCZaoqpO/vwzduu6DQKveK+8HuT1Ng?=
 =?us-ascii?Q?YUq97mgNh0vReRxKUaTVHHgLafHVKDtW1qXATtG0wQ0pU+51kUdjgVnKURTS?=
 =?us-ascii?Q?yZOqJYukuu943mw2EoukUg2JuEBGVUDU14UhntaTZQlmDPm9mp2rgei2cjYA?=
 =?us-ascii?Q?gYZWKWYAI9V/s9mvcE7yDBZ2V8AzmOCzVUkFAk0WGiddKV7OVWX8Hi2Zqus8?=
 =?us-ascii?Q?DorVWPKhWeaoc33jjQ1H015OU6rn83JeNW2dJMhuvqqc0t+8LlD61pNimqZg?=
 =?us-ascii?Q?iFl6qLZcE5jwmNjfd44iK0fpaUn8Qhkb/Ge9FJrPN1ECskuq89N8pWgXE0nR?=
 =?us-ascii?Q?OVzVhvbmT/azu5GIhZofXmJ13bRCICI9PMB+Dw0hV9VRmGcIi0DCQw3NZ+ZW?=
 =?us-ascii?Q?p6AMo2aWU2tEGZI6pTHsutqCvodeg4xShbMphfV1iFnsihd0ef16p0Ar+ZjV?=
 =?us-ascii?Q?qthrVDZx93haFTRfNvPhebCbBOzNOFoY1YifvzSW0wtLOWyEYpFykVWQgdDD?=
 =?us-ascii?Q?XJRTqjbievvsFG+1muKAZsZl9NiXeE0361dxFsxRxe4obahBjPR4yxBIE98K?=
 =?us-ascii?Q?FWjm8uDICPIXrLk/EFrW+XGwH0DU5FncMVgeUeWuedICW6JAn4MJRUXfMcuR?=
 =?us-ascii?Q?Nfafu59YzCdhOILJndtH8ozqFN24WO7vmWco8YpfOYi/ReWYyaiyt7Lvz84L?=
 =?us-ascii?Q?aZDvUSl671G14froCK1RsdGsJXz9NWLfuk8LmfNj2Hmcockgtmm5sMFq8YT2?=
 =?us-ascii?Q?in3+8tez08CPy5lQbpzsfGV1gUKCodixYYoHxPNXVW5FeLBKnB2rE2IcwSlt?=
 =?us-ascii?Q?Vg5SUpY+QV9rJJysKeOSD1oSpyP154ePjgmyOrjVLnHmvIRpIg8YBXH7LdvD?=
 =?us-ascii?Q?Ghe5yctb/I+/VLiNynTnI2XwVDMu1AvREXKOcDfMjOd1mZKEOH9EP8NyaE3H?=
 =?us-ascii?Q?hEhNisXZXARvvmKaGtsxKqCYWPTIz6Lq0ixuWFGhgJ5G4NfvIXm683vVKM0Q?=
 =?us-ascii?Q?xIyRTjKZfxAxepmmitKzxxkgyrty8im+UmawsRJDkbmiqzwm9RDRX+QeK9zx?=
 =?us-ascii?Q?4WfDZJvgogi4imkLno+Hvkio6rzYwTmItn9ers4iHdeW9hXKpVvhgpyvbMdF?=
 =?us-ascii?Q?wGDH21bt/+U2DpnahBQwqkqkarSxDyIFo6LL4I1kdOZDpx6TQKhxsD3gBq7X?=
 =?us-ascii?Q?i7zXOWF1jiUIxM0Ms83dLAwwyLfA157FebIC?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(7053199007)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 21:02:17.0389
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6de0b60f-0e07-4158-ac0f-08dd55dfafbb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006000.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9075

From: Ashish Kalra <ashish.kalra@amd.com>

SNP initialization is forced during PSP driver probe purely because SNP
can't be initialized if VMs are running.  But the only in-tree user of
SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
Forcing SEV/SNP initialization because a hypervisor could be running
legacy non-confidential VMs make no sense.

This patch removes SEV/SNP initialization from the PSP driver probe
time and moves the requirement to initialize SEV/SNP functionality
to KVM if it wants to use SEV/SNP.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index cde6ebab589d..42988d757665 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1345,10 +1345,6 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	/*
-	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
-	 * so perform SEV-SNP initialization at probe time.
-	 */
 	rc = __sev_snp_init_locked(&args->error);
 	if (rc && rc != -ENODEV) {
 		/*
@@ -2516,9 +2512,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_platform_init_args args = {0};
 	u8 api_major, api_minor, build;
-	int rc;
 
 	if (!sev)
 		return;
@@ -2541,16 +2535,6 @@ void sev_pci_init(void)
 			 api_major, api_minor, build,
 			 sev->api_major, sev->api_minor, sev->build);
 
-	/* Initialize the platform */
-	args.probe = true;
-	rc = sev_platform_init(&args);
-	if (rc)
-		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
-			args.error, rc);
-
-	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
-		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
-
 	return;
 
 err:
-- 
2.34.1


