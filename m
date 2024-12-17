Return-Path: <kvm+bounces-33892-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1096E9F3E9F
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 01:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1925416E3F0
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 832231DA10C;
	Tue, 17 Dec 2024 00:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dxOVpn9F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2041.outbound.protection.outlook.com [40.107.94.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1576838DFC;
	Tue, 17 Dec 2024 00:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393641; cv=fail; b=t9LwIafTkIxRVd5WC2YJsh7kLAG2np2rTvwyPuG3sw/lbpMn45F0/d7tRkag+D/yqRwF4RUvRjfNvb3ODw3ZbOF9G13Ud/2IpoPf0TMNUelvbDn4HTA/wtsMv6YCRoIG/zc7n042zhqviOuac6/Ywkt6u/aTqUK696VT39fIxGM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393641; c=relaxed/simple;
	bh=PebFWXEvxsjrQYh6nYq6ZCWbChYEbjXWUE/LfFMhB3s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RipyLdxuYWf3dM3PT2ryrf6ksDsGC88NrvhkJ6+zxv00mtHyae7BzwaV6fKiO+qfBA3IVnHqSLLc+wAJJqiBENURciSd5mg5lDx4tgSguBAs9URmA43c11uQ7vhYaq2nY3QPEx+nImBdVAMa8bEISsaPcaJnQzVEi7x69RLlPKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dxOVpn9F; arc=fail smtp.client-ip=40.107.94.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJipte6snzIuYuJ2TsoswrYPThu25B8rVNDw6wcYPhjjsuR2ASBbQiD8Lk07rxX3lInOa/nI99jWzaHRCRBSM3AHam2510NESOmYkymFayKJop5KJE507GnBT2GS/ZU4k3xQoszyE3yppuwJ1XvK7TJiX6oDQZLPvOY1w+VBiyK87QG5uNayhCf512n4BLCr/zoe2jKm5jJEc7c3bFY2+OcrDVhSZHODDBKqjZFhmFIPG6EmbGkmW4n1xPFpeD+p3HxtxZbO7U3kCkJDyWK+nq9ez8cXklv8EdRkNJrM8jwfLuQyp5kDu9dMlMxREiEylYddcVVn5j/Z4EilwXcbqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Ebe++m3yQETovXXaW1Z1bLMYtiw/m6q/PNJ8zPBVJc=;
 b=Jydc89lhD5RT0FK4/7Jq1v0B/MIY+FEmUBJecwH0gAaPZi6swocQ8frnsO0YAzUMPaN3oGTCpJU3IulyTK9zbsP9rodw+S6W0YPqyLPl9tesu8s1AQsuvEg7yFq2BGadvNsJ58o5R7qnv7Ts3HptTKXFCJJw4B3w0sERsaW8s/XGGYJlQSOgU1/VdNl7CUm8ENiS0oYjs39drH0iNXqW+NGG8aVc/zkxiZJ6K3ZhYt5sRbP1zqDB2zPw+5Rdo4V6JPpRZQcJNUtKdYe38IsNjp4PdSOR89mzRLdIkld5dv81vzP69oYL9TuzzaxXPDZs0WHSWh1iuN0HblC5iTGTog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Ebe++m3yQETovXXaW1Z1bLMYtiw/m6q/PNJ8zPBVJc=;
 b=dxOVpn9FdZ+Ufn9NinPwwcuyaWNAPgNEuz/aF/66GCu8x4nety9y5S33h4j0R2KUsQJyBIo8HZwwE7KhzntLpJ+TlUOiPTEedTpyWYmFvme2+3luDB/y9t2gqrgNNsdrycqn4+fuZRD2R8eb86nMf7d10kblcx8e8JQiLjcVOMQ=
Received: from BN9PR03CA0444.namprd03.prod.outlook.com (2603:10b6:408:113::29)
 by CYYPR12MB8856.namprd12.prod.outlook.com (2603:10b6:930:c0::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.22; Tue, 17 Dec
 2024 00:00:36 +0000
Received: from BN1PEPF0000468D.namprd05.prod.outlook.com
 (2603:10b6:408:113:cafe::ec) by BN9PR03CA0444.outlook.office365.com
 (2603:10b6:408:113::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.22 via Frontend Transport; Tue,
 17 Dec 2024 00:00:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF0000468D.mail.protection.outlook.com (10.167.243.138) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Tue, 17 Dec 2024 00:00:36 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 18:00:35 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 9/9] crypto: ccp: Move SEV/SNP Platform initialization to KVM
Date: Tue, 17 Dec 2024 00:00:26 +0000
Message-ID: <f7129ef82e622ce52b194ab017fee9b1881b0cc8.1734392473.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1734392473.git.ashish.kalra@amd.com>
References: <cover.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN1PEPF0000468D:EE_|CYYPR12MB8856:EE_
X-MS-Office365-Filtering-Correlation-Id: f140c2c4-41a7-4d9e-56e3-08dd1e2dd5a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BXVDuu9N/2dK2DAIgqVH2jHKAVLb0rCpSdnJ66yMOCJs/8x2MuHEWWdWvhSz?=
 =?us-ascii?Q?WLC0ogzud3B7eZoFN0YJN+xiOiZETcy9nihHv3lQMtohYheTXjcuEYqwjgqh?=
 =?us-ascii?Q?dh9vvMyCk2yRS8dddWqt1lCfl9pww7JWLVv7QOOALsDTsQEHIAUuxmSl6zgw?=
 =?us-ascii?Q?otv4NDz10yQDBxL2lEZ5yTCHrkB/TSi8XKV84vMU7NQBLQ4o9MdwEYuRyBG6?=
 =?us-ascii?Q?Je+HpSrJB8EHM623qYAABEYelDAKuRXQN3wBHgd7X8+trUq5QfFGDi502QII?=
 =?us-ascii?Q?s2ZSmNj0FRjrN4vuohKJFuXfq61vFt5BJUXvGIkhQvcL1fwcNpYi6FIcpfC9?=
 =?us-ascii?Q?JrPynPwucv/eBO3RQ7cK8CVt7uzNys5/j1aBHItq2sXplEecoz0jIlVVx2dz?=
 =?us-ascii?Q?fHjynyM6jMJPaU/WoGYJ3jCaQoT4lOFL8NZCWXyxQrZKtM0rh1WotLsJq3e2?=
 =?us-ascii?Q?rLHi6Yqg4RvVyfYrzepXoTIb8S1eHXr0XuuIUpUZdSk42Ygud4/KgVLrkX8U?=
 =?us-ascii?Q?WLuy7kXSE5kQsonnt7EHSBrXkJ2JWHPPJHkex68l0twgOYLdMGd2xwY4bpWP?=
 =?us-ascii?Q?YQAOFKvmJw0Xv8+CEsQ3FTcNHIZXJOKmjly1f8X6rzWLpO6MxF4r5sGsUJWQ?=
 =?us-ascii?Q?DzaPIT3B6CpXu5DTPoTaMyBIlK2+vbLzxRTnJ16bqzHbEiKjMaVAIJjvpKAe?=
 =?us-ascii?Q?wF6RS1oBZ0umeBpnpAkqAEogURdgN/II7/0UfhiqYVpciOYEmMVYCb7Z4v8N?=
 =?us-ascii?Q?k0P3e7OTb9jLKFDm/DdgbzY69ugo2xVbNwJ40/kCGXLab5ODm5X9c9oHfZCT?=
 =?us-ascii?Q?VQTAs8f4CCSDba3NNqzP5n5IXD5nZBWXZ6Ri+lEXC1UHF3W8QNkqQc9aacW9?=
 =?us-ascii?Q?KM6uoi9MrnGceeqZomr1y/BacHOduXCyLu3Q8gl+whn7pcIZavgi32XHSZgT?=
 =?us-ascii?Q?Am6jskgaCSPX020xl6A8uEsxcyJ7JcBk8ic1WxXnyJggHok3QvSspVfgGSZG?=
 =?us-ascii?Q?FkS2U3AT1KU46emNcCsOVNiaW8evvZJOIxXIqB8xLIRbsUAHGyfXa41pM1NA?=
 =?us-ascii?Q?cBXHKsMAvzfwPyRxSZTALYy/v8cuisC+KFWUxkwN7ptFy9I6xOD6xGgVG362?=
 =?us-ascii?Q?qrRVBWATpSm2YIXoRM+5MFsoqro1uz5CRLYUtsJkuDBId3QbEPYJE3vIaKOO?=
 =?us-ascii?Q?VdDTr29K7JvKQi4bfuGyZrFAPhXuGYAHn5kQnUd78CwdrWhon1HRjFs8bsbK?=
 =?us-ascii?Q?y1WgypWVSLPvGkCPQOTpx78lT7tVLrsGreQIPpSys7ZjmDZdFkn1b+CvJyL5?=
 =?us-ascii?Q?FYYrqT5va/MQfyPZ0+5hCm+96exd9Rb2IaMqwaMNcwnr6GAgKksB6CNEGUpd?=
 =?us-ascii?Q?dXK1jQq2p8OIFf5g6oCBRuekm5E3q7mwkUJJ773X9fnAV39fmrdswXWnyONz?=
 =?us-ascii?Q?dsY8x/tUktmVlkrNMvLJEWONVuU0N86FRin+yDpUs1UbIPEFui7Pryzi/EdR?=
 =?us-ascii?Q?3Hi9cDDq0qLiQILH2OTccm8T586Hu7v2tsHb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2024 00:00:36.2310
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f140c2c4-41a7-4d9e-56e3-08dd1e2dd5a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF0000468D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8856

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
Remove _sev_platform_init_locked() as it not used anymore and to
support separate SNP and SEV initialization sev_platform_init() is
now modified to do only SEV initialization and call
__sev_platform_init_locked() directly.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 55 +-----------------------------------
 include/linux/psp-sev.h      |  4 ---
 2 files changed, 1 insertion(+), 58 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 53c438b2b712..fbae688e4b7d 100644
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
@@ -1329,46 +1325,12 @@ static int __sev_platform_init_locked(int *error)
 	return rc;
 }
 
-static int _sev_platform_init_locked(struct sev_platform_init_args *args)
-{
-	struct sev_device *sev;
-	int rc;
-
-	if (!psp_master || !psp_master->sev_data)
-		return -ENODEV;
-
-	sev = psp_master->sev_data;
-
-	if (sev->state == SEV_STATE_INIT)
-		return 0;
-
-	/*
-	 * Legacy guests cannot be running while SNP_INIT(_EX) is executing,
-	 * so perform SEV-SNP initialization at probe time.
-	 */
-	rc = __sev_snp_init_locked(&args->error);
-	if (rc && rc != -ENODEV) {
-		/*
-		 * Don't abort the probe if SNP INIT failed,
-		 * continue to initialize the legacy SEV firmware.
-		 */
-		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
-			rc, args->error);
-	}
-
-	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
-	if (args->probe && !psp_init_on_probe)
-		return 0;
-
-	return __sev_platform_init_locked(&args->error);
-}
-
 int sev_platform_init(struct sev_platform_init_args *args)
 {
 	int rc;
 
 	mutex_lock(&sev_cmd_mutex);
-	rc = _sev_platform_init_locked(args);
+	rc = __sev_platform_init_locked(&args->error);
 	mutex_unlock(&sev_cmd_mutex);
 
 	return rc;
@@ -2556,9 +2518,7 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_platform_init_args args = {0};
 	u8 api_major, api_minor, build;
-	int rc;
 
 	if (!sev)
 		return;
@@ -2581,16 +2541,6 @@ void sev_pci_init(void)
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
@@ -2605,7 +2555,4 @@ void sev_pci_exit(void)
 
 	if (!sev)
 		return;
-
-	sev_firmware_shutdown(sev);
-
 }
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index e50643aef8a9..dec89fc0b356 100644
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


