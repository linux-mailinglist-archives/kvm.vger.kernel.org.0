Return-Path: <kvm+bounces-33887-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A62D79F3E90
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:59:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDD8E7A5CF0
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 23:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BAF31DB520;
	Mon, 16 Dec 2024 23:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d8/FcNLI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2060.outbound.protection.outlook.com [40.107.101.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66851D9A48;
	Mon, 16 Dec 2024 23:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393532; cv=fail; b=WlaPn1QtT0tQu1VXr4kViViVPntXxn0Q78uH39LTNJSnCscen9FQqBBB4RoLDbV7qnplaY9ImwKuBik75X63D5ZLTajxqQ/bU9Y0YMNYwlgAcR7huuRP/9KWZxPDx+Hk/GzPg3fO2syNo00h2Us33WCpDokMhCCa+zXKFAeq41I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393532; c=relaxed/simple;
	bh=syGqMyaizm6LEec9pfcxvi7BPhvLcG+T+ty2iLvU3mk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BFmTCp4My1l3THJtItsbGu+j+vgeIEziEGPZyAJrQCo2nDi82JSO8U+B09dy+ikBwqUAYX4nOpM+7BW0EiFJrxgjgiFsfukBhZ599U/IMJmDpZh+GVr05V/nV5dgoz86i3FY/1Ah8CWj5/YakvDNN12v3bt/Io4idcaoE8eEhWI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d8/FcNLI; arc=fail smtp.client-ip=40.107.101.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QPfnCGZRFkR8hPvugunwBKTpJOgXmhLgnvwTAHDKXIVRSZ1JwhmPU0p9z3T+69kKn2DyaN5l0ETvNdGnsujNW8qvitc8ud9W9po8T88hNfvM7rD2VamZ9J0gNXr/iwbDBkPhHZA/n4FrvELuJiqRCnvU+A7eyZFTVrEJqv7jnDvXIxyUUt8lqKdH9n7hDEq8lmoLycmzjsktNBRUnKmsKIZOAZ4PRYV1R2vJDOnzx5muVZyr5bB1EE5K59mCn0g+xrTDjRMrtj5rQ7KC3b/SdAXV1vOuKbUwLsIbWnvEsPbqMK6AZGep//cgG7yXjVavZE+PdlgdI62/LvlwXSjm2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhTHE/dT4zAyu9CTo6Xv6Y3HGPzAIfnLVVr2hn0wfg4=;
 b=TiuRTQ+fYg830qTd/2CLa23wO4n/B0H0JaYREQQYlGwT50/nDFRqOitE+isVpUPvw5mpmv4/CAxWWjXocDZTXkQ2MqiZWkMYON8syuyS0v7a+PW6bx0Ov1KaB2R+Jdn41bfaZSHgargLEoD83yGq20ltkBY5sanloHt+Aa7OIdOVZ15s8RvRHrAZOgm41FoVma8IbhKewJESVWsVmyJAmhrUsCq50DOgtAKfOfcDMBoRQCPeGSzaDCuEVrqhpxiTK/VWG1K6DvBc9ibDGK8zHGXutgCYA26bb1FeKO3KW/PUKi9TGYWYPsYgPb+D7uJI6AQGujPuLups7GPmbexglQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhTHE/dT4zAyu9CTo6Xv6Y3HGPzAIfnLVVr2hn0wfg4=;
 b=d8/FcNLIkhgRyQRBzGosDokOyt0OKFPxBlI+9Jo71wJpDMGsXCn+2PNJylxMU66eL0hab4GhzKp+MwkCgY5Mpe8c/PuFOUdEtnyn1PfeytjGRAVMZ+gakbTxolMgbU57F7VGnGS8eTJt1mJ5UXADuJfz4jBxnRc6E03inIS4Bec=
Received: from PH7PR17CA0072.namprd17.prod.outlook.com (2603:10b6:510:325::20)
 by DM4PR12MB5843.namprd12.prod.outlook.com (2603:10b6:8:66::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Mon, 16 Dec
 2024 23:58:46 +0000
Received: from SJ5PEPF00000204.namprd05.prod.outlook.com
 (2603:10b6:510:325:cafe::71) by PH7PR17CA0072.outlook.office365.com
 (2603:10b6:510:325::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.21 via Frontend Transport; Mon,
 16 Dec 2024 23:58:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000204.mail.protection.outlook.com (10.167.244.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Mon, 16 Dec 2024 23:58:46 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 17:58:44 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 4/9] crypto: ccp: Register SNP panic notifier only if SNP is enabled
Date: Mon, 16 Dec 2024 23:58:35 +0000
Message-ID: <a148a9d450b3c1dfd4e171d2c1d326381f11b504.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000204:EE_|DM4PR12MB5843:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c8bc5b4-bb84-4083-ba7d-08dd1e2d941c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tX7UnQxgmZ6us/l0R7qQZyhC7jls6RHG0xS/8apCKq/RjR7SqM33s42t642D?=
 =?us-ascii?Q?CsX4jImEIbbgT66zeG90PpT2iQ84v96VwQlftT+/xqjQHmfEl4hEtTa3vnf1?=
 =?us-ascii?Q?7otwYcu3juzb2Cjjydu64WwMljCd24Qh2vLPMNxJXVqAwKILlT0Mkj0v8ipR?=
 =?us-ascii?Q?/QInamZsvzjyNwtlxroXY30j/7P8sndBwxz8GAgJK6yfqBll4ol3aLUL8IA4?=
 =?us-ascii?Q?B/iTSjbPR5HobqJfOw+XA45Qvg4zrhX94AmHROzyDlls5a2LoqRf8gsdGntJ?=
 =?us-ascii?Q?k7sUFK94C9ISKJX1I+UoM3zdYDRYF0r5S8XZ8cMtHu46Qgof3UM1rFlFg/oi?=
 =?us-ascii?Q?XnnjHZtcQnlVPFfuiexz++zQ07oZsOwFtjhPU418bt0467vgdrr97XITdVEE?=
 =?us-ascii?Q?fpQlDRM0NcKHEiwtsgoreujIsP37L92y6ntoYBtjB4Aipr97wFYlqJjtC4bH?=
 =?us-ascii?Q?OV8UnhDTb+k+6brSkZ2oaiFy3qtU5kUefJXLYX9qsh3MyAnKdkdS2AP936hn?=
 =?us-ascii?Q?4tdf0PmK36Z/znnAwaC7po+fWBs4wjQrFn8AEyPoQLSaKOfBrAwvjsYOLmrN?=
 =?us-ascii?Q?dxb2oxyUxFRFwl3RgYG6l7Bo175bh+8W1Lbe+8n9W5Rokn7yY/xWYS1QqUOT?=
 =?us-ascii?Q?K/fBbeWgiGIxt7TH5atT4mP6b6kJ+4jDWz+dkk0KII+6gBGW/pG3WI5l5xp/?=
 =?us-ascii?Q?0pYzn9gz8ehuYF+nGkSR5g1U8XsvW9FPwLeVc/D/xDBHDNV5XBNwIH2nW1bI?=
 =?us-ascii?Q?0ULj/1mU9G7qzh6EL+mZ+AelDSHP6g8dh8YLdhxETY8FT2/Ev7BtPsRjJpmV?=
 =?us-ascii?Q?ThDYr/MnJoHRcwt9xb9x/b8W1mB9xV4E7grx/t89IXciWc8MAbsmWMeIa9n1?=
 =?us-ascii?Q?wgIul0p0P3ho+8XLEjyqw6dVcJWkSG3RpfMhmcTsjKIt6yg5vH8GrrW7Sbem?=
 =?us-ascii?Q?GqfhYGwH9HluGM1D8DLPpEh/dZ+OI9Bp6tmTPrPLOfy5/GWMHd8OQ3Mdz01n?=
 =?us-ascii?Q?ToJK/ry6pXPawIGUhGFer3wEejwoX/fMhWUbHWZsBUgGNFT9/HtYZRxHYTV1?=
 =?us-ascii?Q?le6Y83RGKG6lQOn3nr5MorzevhF+xTwCf6CyuUJzf0eaPeAjQDy9cYyoLKku?=
 =?us-ascii?Q?g+s9F6UJm89jiuN7sdWS6lgfesM6QkQP4jWgBjKjch39UkrlVisHzAnYx0Gb?=
 =?us-ascii?Q?NdGM1Fp7fHEFRgEWNMRD9FH4cgbqpZL5GEhdndwPkwucO6Sz+4kZFl2pOuXp?=
 =?us-ascii?Q?Yn1g90RPSOzupfMmAem0+pOcqs8AIAEuEhQBTnVHRFfQoABN64D3Hm5okqFd?=
 =?us-ascii?Q?jwzzuDqx4DddoleCYS/3+qpVguqZ24xUfLaAZQv0JDHODDtA65GzJTcJo16U?=
 =?us-ascii?Q?+0+MTwbsAxZ92MJor0CJ67sq2nEFIvuw42VftkX8ztINJsKGMhlplAQhk3d8?=
 =?us-ascii?Q?6iov6z5bWED4B9sRKJaheUS853RG1AykcpsohUWQnY2ZNNAEYfSHgHy4Ihdb?=
 =?us-ascii?Q?htZd3cPuVyPABJ3p34f3IDPaN4KgbXIIY/vW?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 23:58:46.2188
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c8bc5b4-bb84-4083-ba7d-08dd1e2d941c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000204.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5843

From: Ashish Kalra <ashish.kalra@amd.com>

Register the SNP panic notifier if and only if SNP is actually
initialized and deregistering the notifier when shutting down
SNP in PSP driver when KVM module is unloaded.

Currently the SNP panic notifier is being registered
irrespective of SNP being enabled/initialized and with this
change the SNP panic notifier is registered only if SNP
support is enabled and initialized.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 9632a9a5c92e..7c15dec55f58 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -109,6 +109,13 @@ static void *sev_init_ex_buffer;
  */
 static struct sev_data_range_list *snp_range_list;
 
+static int snp_shutdown_on_panic(struct notifier_block *nb,
+				 unsigned long reason, void *arg);
+
+static struct notifier_block snp_panic_notifier = {
+	.notifier_call = snp_shutdown_on_panic,
+};
+
 static inline bool sev_version_greater_or_equal(u8 maj, u8 min)
 {
 	struct sev_device *sev = psp_master->sev_data;
@@ -1191,6 +1198,9 @@ static int __sev_snp_init_locked(int *error)
 	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
 		 sev->api_minor, sev->build);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &snp_panic_notifier);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
 	return 0;
@@ -1751,6 +1761,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &snp_panic_notifier);
+
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
 
@@ -2490,10 +2503,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block snp_panic_notifier = {
-	.notifier_call = snp_shutdown_on_panic,
-};
-
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2542,8 +2551,6 @@ void sev_pci_init(void)
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2561,6 +2568,4 @@ void sev_pci_exit(void)
 
 	sev_firmware_shutdown(sev);
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
 }
-- 
2.34.1


