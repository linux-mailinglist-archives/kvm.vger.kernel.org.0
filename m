Return-Path: <kvm+bounces-41861-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06B23A6E57D
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0B663B8AEA
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27791E3DC9;
	Mon, 24 Mar 2025 21:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fdVKAfit"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6148986334;
	Mon, 24 Mar 2025 21:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850869; cv=fail; b=Ok0xpiQMKV63e48UPt0s+FaHcWqeDKiCS1U7SY52jEvMSA8HqqA3OelbpSEMlPK0CkEJDnEMjes4e/JyC3ffdTj4xdCh3CIIXYHaW2t7p+PXfjHbfdg1vtrdF9KsOqlh+F2/n8sUiBXKt4SLiCHaQs0CGTPdwesLwAiCJFu9Vbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850869; c=relaxed/simple;
	bh=UoIyQkldedVuTN88EL4FhGUqrCl9/z/Ia7UL+92cHAA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EIcXptJ/LhY5uNtJy573st5cCeppANdJLoVmnpawb/PSRWh+QKRfTHP88IZZxlck/CJVxAF+HkU7Szyi07sboC1iPiEcVaxPM9TsNhMfmtr+lK8hugTzzN7H1VKU2TUBb4U1II7qTQcH8+o1NHu9mZE+426El8kEksNaVU7cx5g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fdVKAfit; arc=fail smtp.client-ip=40.107.236.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tBs3S43lPt4MIGZb2Ot4idGFQGpBe4OseDBSN0aSkdUIBHc49I4V5HKGRRoxL2r1kQKkIwoq6M6HkFwprBH6XufSzpKpwLHzLeo8Dus5vIwgsz6LvFsfjGQz/OZ8KYj9f1mVNNYDDNEKs3iOuq69bIrnlHFLDpa6LUrnXXTR1ODrfBG5S+Za1NTD38KY4sM+GZt7n9B9piX/OOLHOfJJdn3jNodtkq77TbA9b6DYPEKm5WpvJwAcLr1n6epvexTNMj1Nck97IhtYaUvHwgfUY7e3lW48EqcUAkhG2V6cp8J+xppXEQw16j6p51zw/5AViNopWMQMBeukXBTc+aAHpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aBKhe853dgLIjNuMtBJEm5godZxw9sBH743hHNzs13E=;
 b=Wxi7wg1FxU9PZfXek5t26bIRxSy3FcXFlIWb8zPKnV7f1X0fBjzikwz92z/uh+BKEfGcBpSpuvGf89cAB71njN7N5hiWxO/7Q5cXILTzyF1F8NJcxkgSo+SPLLurAEBvXDSUSEBKfhqP3Klq2Nvbp/OD6y2YA5YftTxYK4AIhB+Lo+nXO4GRESJsKJOnDUGaVSB37DzGHIeb9dIP6uVFI0AUFJuF7o+oCdcziOZyy5kFbEjtHClAvkwFh62RTqNo8ltdzHZUmvayHioIgVB5T5NhprWvSo5Ewqpw6ysQXWBRq1CH7/lJWs93xHzA2+fheBQyfvToriUPddMbJi7QHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aBKhe853dgLIjNuMtBJEm5godZxw9sBH743hHNzs13E=;
 b=fdVKAfit+p4P/4ohAGFO9Lk8vliASd5uPnJu2CHl0zExqddz3j+rfjcUEmZu/zk1ENQLvZ3DkcTTANbDkaRFK/5P0b0ZTuS9tSArTn/+/UjvlrBfzW+8kbfobaoZKOqOC/i2QlIibQzcZywYXIyz1A/ThAMSfEmDxaNvTkfBvck=
Received: from BYAPR07CA0022.namprd07.prod.outlook.com (2603:10b6:a02:bc::35)
 by DS7PR12MB5862.namprd12.prod.outlook.com (2603:10b6:8:79::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.42; Mon, 24 Mar 2025 21:14:24 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a02:bc:cafe::d9) by BYAPR07CA0022.outlook.office365.com
 (2603:10b6:a02:bc::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Mon,
 24 Mar 2025 21:14:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 24 Mar 2025 21:14:23 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Mar
 2025 16:14:22 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v7 2/8] crypto: ccp: Move dev_info/err messages for SEV/SNP init and shutdown
Date: Mon, 24 Mar 2025 21:14:13 +0000
Message-ID: <334dd83b706c722c7de98a37908ca470dfaf1509.1742850400.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1742850400.git.ashish.kalra@amd.com>
References: <cover.1742850400.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|DS7PR12MB5862:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c349e04-af4b-4560-8d8c-08dd6b18da3e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1JjAkUcsDEDS6Mwor+eJwt9XL8Kot74kkgpypGEUKN55MgChiUGB/rLKZelA?=
 =?us-ascii?Q?BYxZPHXfD0WqjyCW63ZJMmPGQP59IzY7aMltlSagwMGI8StjbOnDHG9ayMIA?=
 =?us-ascii?Q?mCx0jLXv0THLm315idaMPmIv8FzSuyh1Kjsqs0ToMkHyp/gLmwMO+qjait9O?=
 =?us-ascii?Q?XZf4tEvvHFxm0CHiDSaERYiOV+FJ2JlWA6hoC4PYGAAu5rSdefawmDrbNkMI?=
 =?us-ascii?Q?+TQJ2TouW2OkLC+oY6a4ytg8sok9OFTKcsc2z/4/M1jvllOQi9yXRiuVzif/?=
 =?us-ascii?Q?bqUc0sGT+EYCzvwNNAz3qeAdQt+/dpArxgy5DaKsQVOjZOnmutytXw36ix4k?=
 =?us-ascii?Q?vIs+zureMwNs7sjIv7ozAjMH3NgQsSgFUWG3p4l8i7VtWXSjzP/kr7MA5GId?=
 =?us-ascii?Q?pB2E2runLrlofcCkKSHECwTf13ox+JiLHEi7QGRGJhLo0Pd6VuYXxcqN78OY?=
 =?us-ascii?Q?okiZLfK2SGzeDDCaTmAihaTEq8msDkY6lDoYZejelxFOEfypRYhvG5KAVwQ1?=
 =?us-ascii?Q?5cwxKMAA/xqL7igpYeUdN+Qg7PRGE2wezVYuY1I/pb2EYEviAF5n0SVwTz/d?=
 =?us-ascii?Q?1x95gj7+tEEORJo7bAdQF07G0a0/5v8RXrSjLbNdYfq8NB69CdcAN42TRgDn?=
 =?us-ascii?Q?z9cQe3ywoa9ruVdmZgUtERrzQO3SwCJAY2xrlICrRdCeLKxwiX88ARkiuo8O?=
 =?us-ascii?Q?WlFrTr2rluTaX02nDoNOfEOfWRnMO3tIuLXJpGKg8OH7LMsSEkN80/GaXDJq?=
 =?us-ascii?Q?6yYd+625noJcfJrsJg+8YcZ/E7b4Wuv1p3/GJcnCU0slvZkK8lpK3uvGku4g?=
 =?us-ascii?Q?AIrSyI8U+pnSvTIUCwPrUBfIFHrMcLxecWLI2O32uRkZ5w36rFO0JCnmAGhH?=
 =?us-ascii?Q?aw+jDM2pD0qoWmNGRepL5BZSC80sf0UK1HJ285eUfhiMsP7r1BuEVUGON2EY?=
 =?us-ascii?Q?Ud2xX7xeG36AmQH3y4zWGTuufU15Pcr8VpvC8LOc6+emkkqXTqpt1KyBEaTL?=
 =?us-ascii?Q?GPdcTecPUrsyqzCfikFpRiWRjnWOReDKSQ/n+nw3vSd1kyEqLeecVq2MWDx9?=
 =?us-ascii?Q?7d+uU98sidsmbO8MNC8kBx+TlO9CQUZ79APO0due4ypjm+kG0pQoQLXIPaM9?=
 =?us-ascii?Q?bPn8CIHl07rQHOilM81GwyWPGhUCfBeBBDiRr4+0reeT5OY6/6w61VpKGH4G?=
 =?us-ascii?Q?mFRYpBH4xhTrfMWIt0NADVhKT1xIG/qCBgUun32vCgfFpKgzZNjNLQtajTlQ?=
 =?us-ascii?Q?PiiPjjNq4nS11unw0P2e3mYP6k9xtreN4mzhmT/SguY2wy2MOvZvgvkdrwOY?=
 =?us-ascii?Q?8YijNd/JmmwO/5edponhkB9l0PJ8QQBUWGqPPgt502d+pf/SJOsX4iYF2OOB?=
 =?us-ascii?Q?GsOlmZ9zQ1xcdTDc6ToDQpmiDrZoF2Rw74k8/cFWAXoNlnfczuKDhj5vhCYJ?=
 =?us-ascii?Q?YVqPljv6NpFQhb/E/fRBwGl4fB0ge4wAS3yt4nDinvqIYtRasASDDyIeibZX?=
 =?us-ascii?Q?s1gIwnhKx4RBLiKalKafH6tCR0Ly4o2ZGBuB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:14:23.9993
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c349e04-af4b-4560-8d8c-08dd6b18da3e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5862

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


