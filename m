Return-Path: <kvm+bounces-40292-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 942EBA55AB8
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:10:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEA46176730
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F0E27CCFD;
	Thu,  6 Mar 2025 23:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aSJ6WYat"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2078.outbound.protection.outlook.com [40.107.95.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2D127CCE3;
	Thu,  6 Mar 2025 23:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302601; cv=fail; b=UqIX69uzyBSMzZ7rrq4Mx0TEv/IKtwYvX5xHRGj+bzEovpHYMu1EKYlW104AZfCVnm0k1mu5gEdKG7WVnmEkHO8OTDtEIY2pvgeN5Z9LV4HAU35C5FOLsojexNhNqv/0dUa30ixeDBEdZNqbtcR7sr/QTjqtBs9tT3g7o3eE2WM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302601; c=relaxed/simple;
	bh=UoIyQkldedVuTN88EL4FhGUqrCl9/z/Ia7UL+92cHAA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JPSp0Uzkuh9/T/GHETQi5MRkbuapfoNLET35ik+pszZl81BfbryIih22NNpUNNwglrZBI2M7/C1VyoTHvaNHEx+qHFJV/vFNJJ5st0zvkqcajxr9Ts8ddDEjr0rvgpcxvNC1YNs4Zx+DYoGPJfHdWP2qUMt1ruQ3x8ukfALfzUM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aSJ6WYat; arc=fail smtp.client-ip=40.107.95.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vCAth8u97dnO72YTx5Tt/5KrP/NkRcvN3X2PsdwlvpY5+L1Os7f8SD2l7zXIiEi2nRt67tswbTJDhbYJ7gacw1yCtVWspiKZv+ae5q9mxvkO99nWVVC3PPL8nmn8PIgC7UCIoJyJTo24Fy+ADAjYvgjmdTlxBEg4kkD2aXYg2r/gc9kUbDVviVWI6vGMPnoIl2CJTHY9ODu+6GryT9qLxbfmPojOVj51DFyEQmpjrZ0vGMaVdBYkjhsTokFLJ6bzIeTwO+l7LXnkIkoRLR+kykfaOOUsOpnBHrIAI2uDhJGGl0Dh0GjqeMU4hyV9x9KalbgGCRqYyC0LWfbPGgjSRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBKhe853dgLIjNuMtBJEm5godZxw9sBH743hHNzs13E=;
 b=iDHxhquyaPSauYRsRvEovi+ZgoDtMEV8SKP7oH4ijjnUvnYxJtcMxHHmY01FsAam7FTBifnqQYkhSMmk8IJl7c0GmZJ53PLvKGkuA/dULwpnP3suvvs0i2IlsfnaN3GE4RliYmexct836hzDqF4mvZ1s4OQ5h5DLuzbymYsIq0TeNQ6ja2ow0Vlo36Hm7BzNhEn4pu5jeUX18RDj0f68PlKPJ+PmSg2JQyftWZuK//t5LDfn6OuJo54OXn+Cfddoe5vqL9NApxDlo+ADSnQYeVL9h8ZPwubXZz5nw3/9+yzMlbPZSZfo/9Umw4wjooEqVzlSToR+4nR3jcsRpiWyDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBKhe853dgLIjNuMtBJEm5godZxw9sBH743hHNzs13E=;
 b=aSJ6WYat2T6QeQzRSaEXEeEB6O35Ra5tKGv4KnDUQ4q49EijFqjQxdAnGclnUXU8Ca9KAAPibPH9Q8PLMxgIgxUaAACAX+dtZZz9RLj2QvMuFDD/IDSEdn9LLC9v458XjqpTVljJUJSeRdTB7V93lrTAjFs29BWHGi8rb+hhP9Q=
Received: from SA1P222CA0044.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2d0::9)
 by PH0PR12MB5680.namprd12.prod.outlook.com (2603:10b6:510:146::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.29; Thu, 6 Mar
 2025 23:09:55 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:806:2d0:cafe::41) by SA1P222CA0044.outlook.office365.com
 (2603:10b6:806:2d0::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.16 via Frontend Transport; Thu,
 6 Mar 2025 23:09:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:09:54 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:09:53 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v6 2/8] crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
Date: Thu, 6 Mar 2025 23:09:44 +0000
Message-ID: <41ff363d1bfb339371b66aa16cde9a2ad2b8215b.1741300901.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1741300901.git.ashish.kalra@amd.com>
References: <cover.1741300901.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|PH0PR12MB5680:EE_
X-MS-Office365-Filtering-Correlation-Id: 9c758fd3-e828-4b63-3c69-08dd5d0401db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DUjmRwETRuvNDGxT6LL91mybphL1ICxa1fYcpo7iuHWCGkpR/2zBdrINETq+?=
 =?us-ascii?Q?5Ouc5P4mFup/X3cGczRb2NmieM+roc4XWc2RvtGMWeOMQGFiIfIl9Rn5xU4c?=
 =?us-ascii?Q?qjNYGvXGzbjqFD3Q8Svsc+/E+vsCt0NL8MJmWSxv7bPTYSPzgozwVEVUIZ5o?=
 =?us-ascii?Q?eyMLZ9ko4XjpVN4HEKzUADL93FP/lxqExc1KAjGKKmWLgfbd0t2onO/5Xds4?=
 =?us-ascii?Q?V/raRtTBLZUNfv1mMwhRtXdyfbx5xiF8vRwjm2ln4Z0lxMj1m4gDz64eNl11?=
 =?us-ascii?Q?9JS/BBmcfRGLrXLHbqcPhTpEoPBkWlCN+UkG9V/DRQOOxVnrmz2kTzdJgNkE?=
 =?us-ascii?Q?wCRPGifUnn+BY3TW+BrlSbI28ZmhqTbMAFH4WiY+RpAdSr1QtcgCWW64Gps4?=
 =?us-ascii?Q?doDD/SqIxtvYBkOoB7xXvBU78SiNBPY64p0sVK5axwQX6GUWyJNbf9FgaoxX?=
 =?us-ascii?Q?7zQYW1IK/XbVDByNWGW3jg/7sohyFnmkhCVBXJhk7loixKDR/k/+97ByUdrc?=
 =?us-ascii?Q?RUdvDufmxu/0dXTb4eR5DVl0dnh/6XtizHRS58tIkcxbCTyWRw+4azlS9mcr?=
 =?us-ascii?Q?KwhRgXloZkN/jK8IkXYF+kp6mAM712vCyHhbsw2/HkUmf4KJwDQq7E5nAqlR?=
 =?us-ascii?Q?IsgKYSSNpvIvkw9ZLfEGMNyTg1tBiHBIsu/axj0IUFDQ1/qLK03QmnICJTql?=
 =?us-ascii?Q?pDMV3gJ5IM+kweQlUx3RpM1UuD25lhzgLrhOirI++icjCnG3IY+C4NxSSsRv?=
 =?us-ascii?Q?GkQYWCSRcDxLZHboc40oE+knETzDN8+AyMaowsaTOEH2DvA7ITTVbTEbOk0p?=
 =?us-ascii?Q?kfTIt59NxwwQhTT4LR6T5Gc59teB2ZKA8UMXrmAWlU+XoB5l/1Tjubl9EyHr?=
 =?us-ascii?Q?Yb8YWEPHx8G45s8emT5DRc5qKyvPw+W0PVsozxlZS6avU3Nje1LX1CjOeyTo?=
 =?us-ascii?Q?bi91l1c5psbeYUt+Kdnhtm0FcrIAxpvwwvyG83AkWkLdWIAesZIyUk7ZVVgp?=
 =?us-ascii?Q?IGySkQeck4M1jioLpwtyMbo5boxvr1GJvzqwqWV7d6/+AzG8lvNb3acqUUxl?=
 =?us-ascii?Q?22r2TyssMrl7GOehqFzYicEjqrejZN78xjYgWWL98ABwsKUrWhBeKpXUuy1v?=
 =?us-ascii?Q?J1iiELBc6SWEGYuweTjKULf65bkyM5npa92Gj+Z3q6YiUejQLomGNZksqk3+?=
 =?us-ascii?Q?Nsd2ScIwJIN64PjQvznPCy/telCPAyKFFJFgANF8wRS2xrT4VJrKSfeVccFb?=
 =?us-ascii?Q?fHYp44iJdcFUeZCZWtVgApnMUk/KVgjHVvj3WYMIe85zXXXpLWslLfd9oBIv?=
 =?us-ascii?Q?O7UiwAr1PUwmfX1qCTfhEtbMdiw4k2D4TzYpUzldgg4rX/v9JauRDYCx0G/O?=
 =?us-ascii?Q?J8AExYqraOUnVRFtK8aTrplIi/45EN6EYljIeGhac+OF9X6OMf5ayC+50czs?=
 =?us-ascii?Q?r18Z46OEDI+BnY0BTDxUKFd9ub97V4h/gF+47HgaRmvbAbU9h/oDEQ8S0Lf4?=
 =?us-ascii?Q?amXG4W6uPsBNUqXQg+IKioy6mzHEll9+C7Ow?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:09:54.7938
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c758fd3-e828-4b63-3c69-08dd5d0401db
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5680

From: Ashish Kalra <ashish.kalra@amd.com>

Move dev_info and dev_err messages related to SEV/SNP initialization
and shutdown into __sev_platform_init_locked(), __sev_snp_init_locked()
and __sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() so
that they don't need to be issued from callers.

This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
to call __sev_platform_init_locked(), __sev_snp_init_locked() and
__sev_platform_shutdown_locked(), __sev_snp_shutdown_locked() for
implicit SEV/SNP initialization and shutdown without additionally
printing any errors/success messages.

Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 49 ++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index a0e3de94704e..ccd7cc4b36d1 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1176,21 +1176,31 @@ static int __sev_snp_init_locked(int *error)
 	wbinvd_on_all_cpus();
 
 	rc = __sev_do_cmd_locked(cmd, arg, error);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV-SNP: %s failed rc %d, error %#x\n",
+			cmd == SEV_CMD_SNP_INIT_EX ? "SNP_INIT_EX" : "SNP_INIT",
+			rc, *error);
 		return rc;
+	}
 
 	/* Prepare for first SNP guest launch after INIT. */
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV-SNP: SNP_DF_FLUSH failed rc %d, error %#x\n",
+			rc, *error);
 		return rc;
+	}
 
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
+		 sev->api_minor, sev->build);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
-	return rc;
+	return 0;
 }
 
 static void __sev_platform_init_handle_tmr(struct sev_device *sev)
@@ -1287,16 +1297,22 @@ static int __sev_platform_init_locked(int *error)
 	if (error)
 		*error = psp_ret;
 
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: %s failed %#x, rc %d\n",
+			sev_init_ex_buffer ? "INIT_EX" : "INIT", psp_ret, rc);
 		return rc;
+	}
 
 	sev->state = SEV_STATE_INIT;
 
 	/* Prepare for first SEV guest launch after INIT */
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
-	if (rc)
+	if (rc) {
+		dev_err(sev->dev, "SEV: DF_FLUSH failed %#x, rc %d\n",
+			*error, rc);
 		return rc;
+	}
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
@@ -1324,11 +1340,8 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	 * so perform SEV-SNP initialization at probe time.
 	 */
 	rc = __sev_snp_init_locked(&args->error);
-	if (rc && rc != -ENODEV) {
-		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
-			rc, args->error);
+	if (rc && rc != -ENODEV)
 		return rc;
-	}
 
 	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
 	if (args->probe && !psp_init_on_probe)
@@ -1364,8 +1377,11 @@ static int __sev_platform_shutdown_locked(int *error)
 		return 0;
 
 	ret = __sev_do_cmd_locked(SEV_CMD_SHUTDOWN, NULL, error);
-	if (ret)
+	if (ret) {
+		dev_err(sev->dev, "SEV: failed to SHUTDOWN error %#x, rc %d\n",
+			*error, ret);
 		return ret;
+	}
 
 	sev->state = SEV_STATE_UNINIT;
 	dev_dbg(sev->dev, "SEV firmware shutdown\n");
@@ -1679,9 +1695,12 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	ret = __sev_do_cmd_locked(SEV_CMD_SNP_SHUTDOWN_EX, &data, error);
 	/* SHUTDOWN may require DF_FLUSH */
 	if (*error == SEV_RET_DFFLUSH_REQUIRED) {
-		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, NULL);
+		int dfflush_error;
+
+		ret = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, &dfflush_error);
 		if (ret) {
-			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed\n");
+			dev_err(sev->dev, "SEV-SNP DF_FLUSH failed, ret = %d, error = %#x\n",
+				ret, dfflush_error);
 			return ret;
 		}
 		/* reissue the shutdown command */
@@ -1689,7 +1708,8 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 					  error);
 	}
 	if (ret) {
-		dev_err(sev->dev, "SEV-SNP firmware shutdown failed\n");
+		dev_err(sev->dev, "SEV-SNP firmware shutdown failed, rc %d, error %#x\n",
+			ret, *error);
 		return ret;
 	}
 
@@ -2419,9 +2439,6 @@ void sev_pci_init(void)
 		dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
 			args.error, rc);
 
-	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
-		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
-
 	atomic_notifier_chain_register(&panic_notifier_list,
 				       &snp_panic_notifier);
 	return;
-- 
2.34.1


