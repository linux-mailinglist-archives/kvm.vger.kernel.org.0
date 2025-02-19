Return-Path: <kvm+bounces-38603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D53FA3CA98
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 21:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3A903A99B9
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 20:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF97D2512C8;
	Wed, 19 Feb 2025 20:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wYRMalgX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2066.outbound.protection.outlook.com [40.107.101.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FD2124E4D6;
	Wed, 19 Feb 2025 20:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739998537; cv=fail; b=QjezJijVF+2ZKAvJpjGbrNNJCHCimsHX3ts3Z6Cuo+VbFgUhL+7V6RN4W/OjDNX6aDPIJg/eYmhGkRkU81ZcJvKlTyRFRNZ2eC3ZjsVeWdXTuhxPnT/g3+NRhihVt18o4R4MDL7r8dp1QbFAJaa1m0zNThLqQBY1sr5YDoy9MFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739998537; c=relaxed/simple;
	bh=CRtSmnyk7QUzZKw4wxQgUCGOs555cCW45JMunGHi14k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o7wzlbjdKXAtKx0nABMdrks25cP3NKOeYzE1ZY0T9QJuXCm64720N3hV9rg+bOAVvu2+Yi1VxpII6lzoHR2v/9QbKmn9YMBL1Dr5164eOfZS9RAVc3+oBOhV+LnxhHoae7Rc3h6ieXGnxPibJIcTHzks+4JOKy7nOXtCArZ+UvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wYRMalgX; arc=fail smtp.client-ip=40.107.101.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cS0Zvv0pZkhntr1YZdcNk25s7lND27FEQLf12OBSpV9anJM1MTIAiGiu/zttKtOBekyRAmXj+rKrz0lfrF/E8zlZ1PhuhYv7GSgW2Qyd5D1PBYMNRD1MnxvnxXhZk1s/eissQlB5TWPxMB3TmnH4v3Jn8ouOOlNxdlnvS4SchRt0F7khWUBSQpiv/CJDoulIYWwEDLg2KsjvdchX89EFHv0Oa+WtaL8mzmV++TOOLFqJJy/MKHJJhZAOGQbiMYzQdckx5R+SZ4tkFgd5olZ5dXZbIHrVn181PLSQpq/6GC//oXIdXYkuiFa4P+AAjmYr8O0NOSFIzTb8pHeM7eoHzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+OMf7YKzdonrl+A/dNaQSnqr9xhHGzFSjksCHYi/ids=;
 b=RqbTiGWRN9wGMJ49dtioPmnBUSNAWX63zoJaB+b/611Tx9dEAkh57mB/rGeEuwRViygmREZaLY1DBxD7yt5UI7bzIHko1hwlLorutGXXcCxRniQI/M3wMYsDHIoJD/AAOnnubhcZOOBwezcqfRaPxrPj2fxhuACEcnWqAoY0ACysxGXeO49RH4gdXYRMCOy+5lboIhEWOgvtlxRC2KkB19uvJt/Je1M7kP3Rkz6d9lgXLIh1T0YqvIIEOXM5Zy9B/3HTIWpqptFv08us0eYxZsnTzz9lfCrnCVMDbQG8JLJ3uo3dCJrnjFRFSxMWBvq6kdaFseShADF1BhORszu/gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+OMf7YKzdonrl+A/dNaQSnqr9xhHGzFSjksCHYi/ids=;
 b=wYRMalgX2ko6/UjYI7ie1N8ukBLD8oRqNrUt/cUz2Kw/ZdQPlJEAVnVMQvvtUWO91H2nC/gOa1/thZleDlBUKHtD8wxH7nk7n9U7hDXhHu0q4iCo2ff7Sbh3MthSyn9UJ/tRE4wfUaROKPQCANHsEX/rp57oYZFJ0xEIUtpEtGM=
Received: from SN7PR04CA0057.namprd04.prod.outlook.com (2603:10b6:806:120::32)
 by SJ0PR12MB6926.namprd12.prod.outlook.com (2603:10b6:a03:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 20:55:30 +0000
Received: from SA2PEPF00003F65.namprd04.prod.outlook.com
 (2603:10b6:806:120:cafe::94) by SN7PR04CA0057.outlook.office365.com
 (2603:10b6:806:120::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.16 via Frontend Transport; Wed,
 19 Feb 2025 20:55:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F65.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 20:55:30 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 14:55:29 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v4 7/7] crypto: ccp: Move SEV/SNP Platform initialization to KVM
Date: Wed, 19 Feb 2025 20:55:18 +0000
Message-ID: <8ddb15b23f5c7c9a250109a402b6541e5bc72d0f.1739997129.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F65:EE_|SJ0PR12MB6926:EE_
X-MS-Office365-Filtering-Correlation-Id: 18fecac6-0a95-45ec-eaa7-08dd5127bebc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|921020|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JAEvTWLJyTtDBpFX+1HGI/SdBOAHK7yQuU/df2TGchilKRmLYMj5wDiBEfaS?=
 =?us-ascii?Q?oIwTI1a8u1RZH0ouaz8eHOFq5QRLRYD/V4+Ok71zLrj/Zbmev6QHc0yaP6uU?=
 =?us-ascii?Q?srsGsQZYgNVTNuKvtQ2df26yeXlx/a/rscRaAZTvTCnjCacGH2GRdc8aqy0S?=
 =?us-ascii?Q?iuBvyl9xPzBUQrPxTiz3tn8MZk4UBX5WqY3SCrNU3FyqIjRMD3UnHOnY5zaM?=
 =?us-ascii?Q?EoFAiUw1n3YLK3y6WF5KU346UNteb+7eDFWmk4tN2rIisyKsggV4q2ZVtXME?=
 =?us-ascii?Q?RLSFiiI1nNANku/y3psMnsySUmVDEsOccaTkm0TRsJXDE0sDNNuTIPYjHEHo?=
 =?us-ascii?Q?mfjQH6ib9Rq76kf94tzW3+oTojRfA5UkYiIZO0gedaiQZpVaybdJUF500M8G?=
 =?us-ascii?Q?xx98P+mVbSBkcyzhq5BE++GAacVpx8yTpkxmUHamykSMHihjJLsYDy/tescw?=
 =?us-ascii?Q?6leg/2+uvOoevaRFc/xjg9nr4Sc9nL0I4vMcluhvB9bay6jXK6H50Jphnls2?=
 =?us-ascii?Q?mCxeost/nGhXLE+Q+y5kc0Tete61AQb54/9YbJT839jiM1C6VXLdlTyEfTJp?=
 =?us-ascii?Q?oHbNBZ1KAaJa1XZpchHAyue6Lz/alaqCMsM/44di0ThqwMqpsrYlk1LIs7xH?=
 =?us-ascii?Q?lPT86wEC+r7WTSbH3UrMbFqiyJUltO/TAa4B7ZQKxtzKJyRFqfAVUwJPJQIS?=
 =?us-ascii?Q?TCbSqodqfo7OXCy2ZKxjdPK2u95EmyquAHMnv49pqyZEBPCATq8qFID+G3Jm?=
 =?us-ascii?Q?IQ45HjUZeVrX6yaTDT+v5kypMcQSDkUYZHSEaXybvTOH+s452KSM9uf5YOl2?=
 =?us-ascii?Q?RIxZpjuXPEfzf6WgYWqq0jCJ8Tf0a2/Hx0t5vw/iDmjKPZ8hI0rpBAUk1euI?=
 =?us-ascii?Q?IVBIxpMvbLwRfK31IhnaScHQJSjB/FPXxWOEgWSEd5Q5MZv1sMCNotz2BAV6?=
 =?us-ascii?Q?kpyqW8uMIHm7zYnsUYPG/5fd3xwWGfQZfxaiIJJwDdFm8r/GJRpAwSr7SGUI?=
 =?us-ascii?Q?TL3Hi1DI/J8YPwbntyZ5HsKFr4WrD6ZW0K8cnWKTayyhLfqKo6xX611y7Er8?=
 =?us-ascii?Q?CmIiOMEfj4tD+AQ9F9xeBTBmxk4UOKp0bX8o2xjfFoOfphZrkteYQHIkMD5s?=
 =?us-ascii?Q?plcWeMwHY+DBLH6MXD146eMC/kd6J3VC4xSespQfgGTzXUmlyNZWif4FICcF?=
 =?us-ascii?Q?yD5jDEa+6dmMuqMCm8OAhUwyyja517TBAmEyopiURnTZsnsh7EDSCC3e7l/f?=
 =?us-ascii?Q?b5t76me2xSpQiqXZnSPjPSQSf6K8r7VzSkaknBX9tapoDTGXMo99MlfLSD65?=
 =?us-ascii?Q?MMtrENWhbZyJd3JRXwlQe7QUtr4wuWVCgnEpsy0FkXriJP99AGdTBI/zlNVT?=
 =?us-ascii?Q?fsFWeQTKpvIQ2fqpDNXmzfvzWNPa29aE7kcemuNcFhlzIYAu9aaidf6bRVCz?=
 =?us-ascii?Q?JxC3PtX3tD/5EbBv5BlKtAB9tMBwuGlFV4cFwAGXirGsnB/i4u2UFBXSDE+z?=
 =?us-ascii?Q?HonKUrGIQSkUNq6b05hRoWSwFRnJoVYEsO4M?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(921020)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 20:55:30.1323
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18fecac6-0a95-45ec-eaa7-08dd5127bebc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6926

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
 drivers/crypto/ccp/sev-dev.c | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index f0f3e6d29200..99a663dbc2b6 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1346,18 +1346,13 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
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
 
 	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
@@ -2505,9 +2500,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_platform_init_args args = {0};
 	u8 api_major, api_minor, build;
-	int rc;
 
 	if (!sev)
 		return;
@@ -2530,16 +2523,6 @@ void sev_pci_init(void)
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
@@ -2550,10 +2533,4 @@ void sev_pci_init(void)
 
 void sev_pci_exit(void)
 {
-	struct sev_device *sev = psp_master->sev_data;
-
-	if (!sev)
-		return;
-
-	sev_firmware_shutdown(sev);
 }
-- 
2.34.1


