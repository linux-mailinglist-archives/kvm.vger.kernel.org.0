Return-Path: <kvm+bounces-34548-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9B7A00EC5
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 21:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8FB83A1DCD
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 20:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F5D31B87FC;
	Fri,  3 Jan 2025 20:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sVA7SClf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2077.outbound.protection.outlook.com [40.107.94.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F161BEF6C;
	Fri,  3 Jan 2025 20:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735934553; cv=fail; b=t7qdQ5kRGSNR5k9rdLW5/WUkw0O5w/wxYKc3x1vW/ESekM3y1JwrSpSWQxJkjflkSNFLPel1Cv10SrcWe+kUzZxHB+TUsovcsNxvNpumkEjKJjxrJW+sKX+TMKHb0kZXCEK2+81DFq3k22EmGvzapXDhYnmpH29D+HG1y/kMlyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735934553; c=relaxed/simple;
	bh=V7VoLwJfWfCPOpOaBGkxvtUdLF1A7Y9d/YLU6/XTZuU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CyZdUlhFoW6nmAQJOEQgPYYM2js/SD8z3nvpl5pEx7613cFwnyr5bt9U0ooNLQLI5ePKvhzLm+HowWdqEcCjgDxtjupWLoed63eUI54e1Ot9qTqviaREhzJo59WDg8WVFwmYifbdNXRurA2QCuRWtwRGnd25E3Zsjk2Yf9P4gow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sVA7SClf; arc=fail smtp.client-ip=40.107.94.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oDwhub5Wu5n/P9AHHitzpzn3j7hKZzcUvjzeY0+PZxfjpUMD4wnxKOsjfUVuUKAyJWsBPed1rUEoBAITv5TT0Fu6ybIzD3WC/IbYlyqv43kRepnl4dZDoIES2axdvKxrk3AH6FlMixYkA9dBhH7hKG2SexOs805uxMvwvjOQD5EHae/bzNk2CZuOLyRH6ICj228W/i+O8B9wO/kKa/Fnalf57Y1q6G5EQ+OviWuf7DTJge8XtwkJDBc8HOwCcjELtu4woKG9fwFGLRMnBB5Oo423Jhf/gjNYIs6nNPOBGE2NZ8Rrl3a8heNMDh3qQFke68Z0FdsR73K3yxWMuO42/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PEmz5Fr3bysDhwauhsVFRG25d8gj6d0+aL0ayDKmIKo=;
 b=frszzKK2WiXEdSPBfGs68CwaNv59oIX9+uPzTrrhAixxPtbKe8lhAY+tSXo+8amU2w0ZQxe9arlIU2C6X3T+Zr9iIs7PdROgCp7Qd2aP/L8Yz6b2bMhR52XxcaqEXUadoi3CXOVRb+OMDjul4WzyBGLTVnKNyjqBWDKsP5WAbMkcQhlgN4u6ZGZ5uwv5iM3lcXGYIp+Mji/n1fD4B5QnEeRkSvTrnkRKA99ZF8pgw5MBGv5JwFB+rd7syuoC8a8nCmqrqa1ceNPFJV/4ijwd7CH4p5mwd3pCeOtEnGCQNJ/G/WsDCLhf8bnSBfn4GVIPFtMNM2eFz6dIfy6CagH64g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PEmz5Fr3bysDhwauhsVFRG25d8gj6d0+aL0ayDKmIKo=;
 b=sVA7SClfsAXwoYTcIuQCLZzEY29nxO3UiyPUVuFaqVxpxsPdPuMFDpGLOXC1Nearz3/7rwT+QCHr0cmqVWJwGbY18q6pp0+WsMMCexYr1uAmgDz5drTP/SC0i7XlY49MZsO1vgSFsaoa4YiGJEM/B36Xi3phtzl1EOI2NjC5HDE=
Received: from CH0PR07CA0003.namprd07.prod.outlook.com (2603:10b6:610:32::8)
 by DM3PR12MB9414.namprd12.prod.outlook.com (2603:10b6:0:47::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8293.20; Fri, 3 Jan
 2025 20:02:20 +0000
Received: from CH1PEPF0000A347.namprd04.prod.outlook.com
 (2603:10b6:610:32:cafe::8a) by CH0PR07CA0003.outlook.office365.com
 (2603:10b6:610:32::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.14 via Frontend Transport; Fri,
 3 Jan 2025 20:02:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A347.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Fri, 3 Jan 2025 20:02:20 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 3 Jan
 2025 14:02:19 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v3 7/7] crypto: ccp: Move SEV/SNP Platform initialization to KVM
Date: Fri, 3 Jan 2025 20:02:10 +0000
Message-ID: <f92951e69cd558e7a6315e603c5a97c3e6d0e759.1735931639.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1735931639.git.ashish.kalra@amd.com>
References: <cover.1735931639.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A347:EE_|DM3PR12MB9414:EE_
X-MS-Office365-Filtering-Correlation-Id: 72387c3d-3773-44f7-b37f-08dd2c3187e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?evCAbAqCK+NXbAzH4n3ufylmffc96tZlRMEiYukKdGnn726lDVGt9AZG5VPE?=
 =?us-ascii?Q?KSj66JpHw37UOpXWeuZC2noyly4bWo/b0A7QCodvhB5Fi8yuijhKD8eX3NBS?=
 =?us-ascii?Q?mWj45JCRtiDeY7lkkrNVjJdodLmowQ1kAYdjMWRPMUoF+c4WTIhfn+iRz3Jy?=
 =?us-ascii?Q?fgF+yY142WnlW1SC31KriSuHBY2fFgdPaEp2c7uku2iYB5tE9M2mU+amasiA?=
 =?us-ascii?Q?UlIy70rthxbdXxofOmieQjDDrEAyNJNikEvUH96c5KuS6Fk95u5Ho+rXcPvt?=
 =?us-ascii?Q?buJBa95/TNSZk5UyA+MYGEsTyjtibVe/Oof9xSOETKn6Ug0BTfs0SyubVFbk?=
 =?us-ascii?Q?L6OW4L8Zw1PIsT6Z+SrUKIC+qW75phEHF5vNisL7OzenJVv6x8EmLYgcGSHL?=
 =?us-ascii?Q?qWyi7utSmXrIya7cuht20qhwiljSfYJ8TH3Aiivr1rGJbP0WgkSJtgMv9Ua+?=
 =?us-ascii?Q?YOhhDJ6cj6Dl5pHbkBmvSvPApDRxq0S3ZmrM8LEpZ3gY3/k/N3zABfyd5Eiv?=
 =?us-ascii?Q?AZVtK188FOo1+O4MDCUya+eNzLK1653tqnysM5FnLs1yhxWJWqbP+awNLRIH?=
 =?us-ascii?Q?lvKuqLAxRoWf47T9AM+wFHiL4urt3JWtAzbnE9IDP0tUU6qOjrUJHDjX2ehl?=
 =?us-ascii?Q?m8PfDAI2cj/wmtsUKPEF+WYxCNLGyjsiNk9wCVgBpSMjKZ8omAELZDs/1nqZ?=
 =?us-ascii?Q?3zSw3aTIzQebYl11w/UQc+CrNANWCt9TUCyIaYM29txw/2sg3KiDGyfgWBMl?=
 =?us-ascii?Q?eEWZIxZLdHiObQjF3M3NaVc1h37sevoBg9UMIeyXGtZ4XvLAhA5ZfgINC4K5?=
 =?us-ascii?Q?ACQzi6JXBf9rMvrWLGk4sMhLmLDJj+cSdukdwQRZv6nU0Dg+arHCPR87dapM?=
 =?us-ascii?Q?2foxKiKeS10f85M0L//AUSv7oKaBAWgSfq1n6BpfExJW2PWaMCqop1ACeL+L?=
 =?us-ascii?Q?CLuwANmHaF5r7XpOKYzbUe+/23a3UrwjfzlH5RzycXuOBESQrZtbRNVd8+k2?=
 =?us-ascii?Q?k5D81wPZbaik8KUK/3598YxGt8z0SLdOWJxCpPJLtFyr2iK+QKfOQfdTiSbI?=
 =?us-ascii?Q?pvbJE537l8MOQmYZSd8pl9I3R7105OQ2F7vPcYqprSEZyLLJWah+tDWeXixk?=
 =?us-ascii?Q?L4w+X9xkISCEkEis890UKjyY3WJxuh5+F4UhidmU7Gik2FaQNxT26Xru6/Yi?=
 =?us-ascii?Q?bkg3HEEWmQkmU0N01R+ng2pATTXNtZun6VDX56FbJXQ6eF0WC5abLbEJUDBK?=
 =?us-ascii?Q?Sh9dfKOxVmgGXni+9tCktcFHCrplGwMWzsNiv4VYwJHkrq4zqo0KAeM2XuHk?=
 =?us-ascii?Q?1u0LB/8LFijCpcyUOtBevGnzqOvMm5FgYM77pXeVlL5WC/dxfNfiKWgeJCj7?=
 =?us-ascii?Q?SMECPSBDW/VpF7SdGUJhllHTBO+1IUgvQeWqjEj8DIO3jQ4KK3RMYmwXaj4R?=
 =?us-ascii?Q?nMRwS0vA0njnx9Tz4dvoCAaxL4kIjxhKBYjLCHNGy2GhlSb7nQs76fAkTfSg?=
 =?us-ascii?Q?eJpVJErvcCl35iNQhFPPU9geuHGfx3RbwxG4?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2025 20:02:20.0407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72387c3d-3773-44f7-b37f-08dd2c3187e3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A347.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9414

From: Ashish Kalra <ashish.kalra@amd.com>

SNP initialization is forced during PSP driver probe purely because SNP
can't be initialized if VMs are running.  But the only in-tree user of
SEV/SNP functionality is KVM, and KVM depends on PSP driver for the same.
Forcing SEV/SNP initialization because a hypervisor could be running
legacy non-confidential VMs make no sense.

This patch removes SEV/SNP initialization from the PSP driver probe
time and moves the requirement to initialize SEV/SNP functionality
to KVM if it wants to use SEV/SNP.

Remove the psp_init_on_probe parameter as it not used anymore.
Remove the probe field from struct sev_platform_init_args as it is
not used anymore.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 30 +-----------------------------
 include/linux/psp-sev.h      |  4 ----
 2 files changed, 1 insertion(+), 33 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 1ad66c3451fb..55a8dd762b67 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -69,10 +69,6 @@ static char *init_ex_path;
 module_param(init_ex_path, charp, 0444);
 MODULE_PARM_DESC(init_ex_path, " Path for INIT_EX data; if set try INIT_EX");
 
-static bool psp_init_on_probe = true;
-module_param(psp_init_on_probe, bool, 0444);
-MODULE_PARM_DESC(psp_init_on_probe, "  if true, the PSP will be initialized on module init. Else the PSP will be initialized on the first command requiring it");
-
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model0xh.sbin"); /* 1st gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam17h_model3xh.sbin"); /* 2nd gen EPYC */
 MODULE_FIRMWARE("amd/amd_sev_fam19h_model0xh.sbin"); /* 3rd gen EPYC */
@@ -1342,24 +1338,15 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (sev->state == SEV_STATE_INIT)
 		return 0;
 
-	/*
-	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
-	 * so perform SEV-SNP initialization at probe time.
-	 */
 	rc = __sev_snp_init_locked(&args->error);
 	if (rc && rc != -ENODEV) {
 		/*
 		 * Don't abort the probe if SNP INIT failed,
 		 * continue to initialize the legacy SEV firmware.
 		 */
-		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
-			rc, args->error);
+		dev_err(sev->dev, "SEV-SNP: failed to INIT, continue SEV INIT\n");
 	}
 
-	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
-	if (args->probe && !psp_init_on_probe)
-		return 0;
-
 	return __sev_platform_init_locked(&args->error);
 }
 
@@ -2529,9 +2516,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_platform_init_args args = {0};
 	u8 api_major, api_minor, build;
-	int rc;
 
 	if (!sev)
 		return;
@@ -2554,16 +2539,6 @@ void sev_pci_init(void)
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
@@ -2578,7 +2553,4 @@ void sev_pci_exit(void)
 
 	if (!sev)
 		return;
-
-	sev_firmware_shutdown(sev);
-
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index fea20fbe2a8a..b0884dbe7d33 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -794,13 +794,9 @@ struct sev_data_snp_shutdown_ex {
  * struct sev_platform_init_args
  *
  * @error: SEV firmware error code
- * @probe: True if this is being called as part of CCP module probe, which
- *  will defer SEV_INIT/SEV_INIT_EX firmware initialization until needed
- *  unless psp_init_on_probe module param is set
  */
 struct sev_platform_init_args {
 	int error;
-	bool probe;
 };
 
 /**
-- 
2.34.1


