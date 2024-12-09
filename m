Return-Path: <kvm+bounces-33342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E4D9EA2B3
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:25:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A8FF21884DF4
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 23:25:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09CA31FA246;
	Mon,  9 Dec 2024 23:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XVCDK+LS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2065.outbound.protection.outlook.com [40.107.244.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C991F63EC;
	Mon,  9 Dec 2024 23:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733786710; cv=fail; b=bjTSSKt6Xk3XoFtWC/HXNLQP7DpQLo+5lFL4lRtF+DGGPRtkXGXMdWRLnY8PLeHWQJatOTLvwmz38MSTT/r1jualn/MYJyC9roRKXRkyJ8htSfa6ZkD2U4oz/g2FdHzyHVbN3rWfjhiOa5Sz7LIrPjsfnDWhytltssD4FiJ2BaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733786710; c=relaxed/simple;
	bh=nC4nDhhuZhiejHkgsKkG6b3O7AfJhMWx+eGgOnSCiUw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m0en/MkYujBO24tNR2oQyxPbsRsFP8pfwYE7EulwBppwbZUGndGur0lKnR6+xZ0ZygwbqcG87wgpleFKge+IGxctn7J8sRGb1fPUXUnnDPINGtRtWpPnsPCoMSMw3Ay+wuS5ZlQgi1Dv1vQtj4mQF2izwFElX5wXfIT/N2hFdLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XVCDK+LS; arc=fail smtp.client-ip=40.107.244.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VV+9OS3UaGI4CkGzfXt2Ar7FUrtC5zyZSXhfaZwmUgywvQ0Qqc2PPHtKByROLvoOLVig8g2R+4LE9mF7vfmEfD73hTSQMRjC7/xi1GawceyraMP4Rmq0mcMKuANolrTt4GBU9zI10ssM4BaX1ikNGaPCUXkm0tMlcK8cac90petM3QTgYtipcQP/BYHaxI8C53okVo8uMbjQxymuTbGqy2/OhHJFVfwUyl4UAowbDSojYnjON1dyeOmSX6SQQ2tNuvjA1C/2nMIkr9WaMmZ4WHdv+yqsBcghLQArQwa/woBTTvon+WraJjGzyx4K9oMqDQdU/r3sIRj/T1RqbxUCnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d3aTvgJf/NX3OYxmFkFXPUTlVTg10nZpFvubQL8+Luo=;
 b=Dbd8CetUfki/oZfb1xEoMHxBr6Xcl3quJwVxTCnDsB30zE9vA4ZZXcyAy/c+epRaNclLRAAbqVRF8T9jwAECqdBbVHz4fgNV/AqpxZ7ov6drWiN2zrent58ljHsTLsz30AZ1C5WozXQMMN8GwoG5SwmL1rI1B3lrIllTf4kZTlmkEY31n5CyVNSNdtuISYXOCta5++PnuQv/06+jYx5FnhQ6q+qxFMBEmfVo3x0meLN/wJpzJIpMdep9BhXEsmqpv7qoCHqpBzIY2RBhouwxoV/pn4L3dcHKZJe6pDlPi7zAOvufwYB429F4UggMqOW+UCs6hduPbRk9NK4L4Ts6cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d3aTvgJf/NX3OYxmFkFXPUTlVTg10nZpFvubQL8+Luo=;
 b=XVCDK+LSPr+33yVbhwLGbAGR/L/0gOCHSFF663n1F/xgYN3wRFd8ALvqh96CNgVbQE9KlUZfjQ60EyYfnSQEcbIdZyg+ZOGLTDU6MLz2bCQFAc/r5Sm+XJCw/dKtzMY6PVitJ7fjwuawErI1PVdoKGqg+sCjuFZfNGO+T8ePlQ8=
Received: from SN7P222CA0021.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::6)
 by DM3PR12MB9352.namprd12.prod.outlook.com (2603:10b6:0:4a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.12; Mon, 9 Dec
 2024 23:25:05 +0000
Received: from SA2PEPF00003F64.namprd04.prod.outlook.com
 (2603:10b6:806:124:cafe::73) by SN7P222CA0021.outlook.office365.com
 (2603:10b6:806:124::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.14 via Frontend Transport; Mon,
 9 Dec 2024 23:25:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F64.mail.protection.outlook.com (10.167.248.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Mon, 9 Dec 2024 23:25:05 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 9 Dec
 2024 17:25:03 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 1/7] crypto: ccp: Move dev_info/err messages for SEV/SNP initialization
Date: Mon, 9 Dec 2024 23:24:42 +0000
Message-ID: <d1658358fa8c55dca2f1869ef8a8475fc303e9c8.1733785468.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F64:EE_|DM3PR12MB9352:EE_
X-MS-Office365-Filtering-Correlation-Id: 66818e36-bf14-4ba4-e306-08dd18a8b680
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|36860700013|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?K077LqdKrFmshcr4X4ivu9BjorUpVT6P7TbmlbA7m4Qn/SZE9DeYRunVmDVp?=
 =?us-ascii?Q?2q8zrTadyH6AsyNEfeV9FMhM99YIO0vHlc8IIm//+A0eCasBATLgIguJzdFy?=
 =?us-ascii?Q?F+3j2db29Ub6YRkgUlzaOO2iVG0DWecBu1ty6R+VnaCQ/mu/5R7QAbyzBQP0?=
 =?us-ascii?Q?fL+B7IlsU2nWl/tWkmb3TRY5Lr2TBTqN0U88drHZX7LPuY64BYHkGPxEbn/0?=
 =?us-ascii?Q?eAB7XsphlquT4uF1XgIsqS6s6dA+0rHDeWoyIgd+pIvw+XD8yKtbzVqTUTjQ?=
 =?us-ascii?Q?pZxVNF9/dx/c3t9q2lueJ9S0syffaXzu6+fXGJO2Bbr2mnFH3GmrWkVUqepl?=
 =?us-ascii?Q?V1N4tlz/XlLWdHQG+ec+sS35eLiZ/b9piq6zbVCeVIOpwLwJjyABcTTpIxEv?=
 =?us-ascii?Q?gWWBO0KhuaH2HUc9xEdxSNcoQR7VtLY3FjytWC2UxEFMWUcF6ZrSqrcEQYoO?=
 =?us-ascii?Q?5//P71mPf1SEPH/1GnRi+4/69KMaSGOsTu4SXFJLEGQBHbIvs4Z+3GR6bnR9?=
 =?us-ascii?Q?UJPFyouSe5xK26tkuavwgmP6TJu3pu1DG47tQWNnfD3/8VEI3EwAa9pZMaLJ?=
 =?us-ascii?Q?SukDAiwSYEw9g3tfzKptemQm/jH48igu2CQXZvBbzoKb9JiY/f1FddCC1KcX?=
 =?us-ascii?Q?DmSj2+BdlpR5khehkBXN4Wxin1b/jms7exajWG2zOhylgHTJvLMnqZccGUi+?=
 =?us-ascii?Q?z492No6NY8341+IMt6bw/DAv3u0cgNHCUQQWNlXG+G/JEXPWCs2brWnhS9wR?=
 =?us-ascii?Q?TsConachGp5HeaLm+6a/QJ+BPOCgEWEHgAG/p9zr/iNmusrWP7RMWkppONuM?=
 =?us-ascii?Q?kbQVbT3IZYXEAcK/+4mQ+Cl05EtmY4uNwE6W0PuBO8wfQABbgIhRgm6jdMBM?=
 =?us-ascii?Q?soyUzqSgcyuoLiXFSiTdamm9dbp0/+FqSWxN/EhMDj+lo7FMxy4sImvtSTIZ?=
 =?us-ascii?Q?f1Taz5mZpUVcYAQn5N0fq0ifRj+iyk0dr/wmbHi6bTOH6qKHi3L4Zf8Ve1EH?=
 =?us-ascii?Q?rmn503Osf0IDcCBuOQyqGZfqzGi/wKG8qK+bZZndCAj3U3m81XdCQbeftLYc?=
 =?us-ascii?Q?CsRJi+NLnq9kOTp+CKs5FGRTLKy9TXQTb5nw1MFooKW9dHfqoyn6VVic0/Hs?=
 =?us-ascii?Q?LFGfXf8FZG/83p+lAkIPiZd+XaBkhutp/yFOtVWGiCnO781K4kXsGfR+8MQX?=
 =?us-ascii?Q?+MtXAHdj4Ke2ougx09aqWWZGEc1IsVW8kiqkautlRSw7Za35YQ6dfmqN/PeD?=
 =?us-ascii?Q?3J/gRXLs0mU95ostF7yVqBAiUS0j7RUP8+cNIGojtOvgXmOl90ey70XB0yCl?=
 =?us-ascii?Q?pukg4DjIO9xNtCmzgUFZ/wCGUhdx3fKGFhxTrsCqDgz5Ot58Su/RrksiCID6?=
 =?us-ascii?Q?GLqmHqvuAM4R40tf2QcI6gcyV0G33Cdrl9A2RhjJt3A+UvajVKGHauhP6jp8?=
 =?us-ascii?Q?zTNxAoMF9Hl9x1mW31miytdlVNsfNI6XSjxxzdD9kPW6SHDJpLQAsQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(36860700013)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 23:25:05.1169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66818e36-bf14-4ba4-e306-08dd18a8b680
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F64.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9352

From: Ashish Kalra <ashish.kalra@amd.com>

Remove dev_info and dev_err messages related to SEV/SNP initialization
from callers and instead move those inside __sev_platform_init_locked()
and __sev_snp_init_locked().

This allows both _sev_platform_init_locked() and various SEV/SNP ioctls
to call __sev_platform_init_locked() and __sev_snp_init_locked() for
implicit SEV/SNP initialization and shutdown without additionally
printing any errors/success messages.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index af018afd9cd7..a17796729725 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1177,19 +1177,27 @@ static int __sev_snp_init_locked(int *error)
 
 	rc = __sev_do_cmd_locked(cmd, arg, error);
 	if (rc)
-		return rc;
+		goto err;
 
 	/* Prepare for first SNP guest launch after INIT. */
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_SNP_DF_FLUSH, NULL, error);
 	if (rc)
-		return rc;
+		goto err;
 
 	sev->snp_initialized = true;
 	dev_dbg(sev->dev, "SEV-SNP firmware initialized\n");
 
+	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
+		 sev->api_minor, sev->build);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
+	return 0;
+
+err:
+	dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
+		rc, *error);
 	return rc;
 }
 
@@ -1268,7 +1276,7 @@ static int __sev_platform_init_locked(int *error)
 
 	rc = __sev_platform_init_handle_init_ex_path(sev);
 	if (rc)
-		return rc;
+		goto err;
 
 	rc = __sev_do_init_locked(&psp_ret);
 	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
@@ -1288,7 +1296,7 @@ static int __sev_platform_init_locked(int *error)
 		*error = psp_ret;
 
 	if (rc)
-		return rc;
+		goto err;
 
 	sev->state = SEV_STATE_INIT;
 
@@ -1296,7 +1304,7 @@ static int __sev_platform_init_locked(int *error)
 	wbinvd_on_all_cpus();
 	rc = __sev_do_cmd_locked(SEV_CMD_DF_FLUSH, NULL, error);
 	if (rc)
-		return rc;
+		goto err;
 
 	dev_dbg(sev->dev, "SEV firmware initialized\n");
 
@@ -1304,6 +1312,11 @@ static int __sev_platform_init_locked(int *error)
 		 sev->api_minor, sev->build);
 
 	return 0;
+
+err:
+	dev_err(sev->dev, "SEV: failed to INIT error %#x, rc %d\n",
+		psp_ret, rc);
+	return rc;
 }
 
 static int _sev_platform_init_locked(struct sev_platform_init_args *args)
@@ -1329,8 +1342,7 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 		 * Don't abort the probe if SNP INIT failed,
 		 * continue to initialize the legacy SEV firmware.
 		 */
-		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
-			rc, args->error);
+		dev_info(sev->dev, "SEV-SNP: failed, continue to INIT SEV firmware\n");
 	}
 
 	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
-- 
2.34.1


