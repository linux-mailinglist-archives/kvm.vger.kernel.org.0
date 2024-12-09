Return-Path: <kvm+bounces-33345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C41859EA2C0
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:26:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A5F0F165D1E
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 23:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E1711FD7A2;
	Mon,  9 Dec 2024 23:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pcJdeoXQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2080.outbound.protection.outlook.com [40.107.95.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F371F63F1;
	Mon,  9 Dec 2024 23:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733786762; cv=fail; b=Kv/gSD3eUYurogemtDGqwb1AS0t+N2Jlj6x0jw3tSEd7ZvYs7p3sRZgzGyAbvGRVrf9ndnQMymWxjJkzasCDOMEKX10CDN/riyteKZqG3oCD4JzGgfUyLXE6b1rTCbhFduxDoB6QX2kNJ8dX+ZEVDHjgDsqGWy3tKXHwARNmPP4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733786762; c=relaxed/simple;
	bh=XRLuIHd6NAb/t02SM3hp2yGUDoL8UifW160vn1Sn5pM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ShlgkKRgIo6fEWWIG1umUV2NF+Gf5yCF/mHxgVHKzRhBOcXS0uDKuV4ljgwLwp7TA0qk9ve/k2srzrLdM2MiblghJ7Kw4kV6x8yXXpRV+FqCBp1Suk4aZWdVziZLAJZQGMkPMT2DfC2EcIApBgC119CwPp7kQgw7+DXZq6kLJ/g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=pcJdeoXQ; arc=fail smtp.client-ip=40.107.95.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wvEJj4okxEmQSrWZ1kykljPeVtPpQOZ1SHFPiWb/3Af+R5t7XRCb/+/+htRj9NygNyAuB+4bb6H6j9/bSx8e5+nSNBR3xWtbwqw3Hlnreb3FOuZPMFDAHi0WQZLuYh5LiD/qwYsCpFoWHiFJeiBls4cACP6YcBfG9VxLHivbpz/ekcS1XjnKJjLVVhPLChFfLkrFray03i8bMeJLZL2K0yzd9kUWzdJKpBq3EBBlHsqU/0wbCUHJMdQHJT8iNb2QcWikeHvus2norgAm/vfSMjeb36uQBLK6HFcDCHwZKePhqEHoDk9m3yQo36r+h/8dbvMk56uvTz+k9DHu0ZCMGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gyG780XwFfTd6tHy6LEsfWfQuw2LNmfo4IVc60oMAJU=;
 b=mH93MfgcxXXsctIA3CQ3rxa4PaKbmqahJbz9jIOTjRzs/qCsULxXUsw/fN8NWWURMbAp1vbWP07Ck+o3YFCA8N+k9pNK7iIS+bfuQyzwkpwI65buOanflqqdLxXRG+mRUjMlDE/WAdzovKDnRGk5iSFRjdXUT+FTHrEgExDTeFyb1dIMTzzusLWsg9PdZQIQnc1bhHkns8UaSdLwJw/cxcn2UumSqOMCUoHvnMHH199k1ByJQQqUU0mKsUK55iSbxUH3k+RpuIFuSdWVUS15QWTBr0NM5jgoCd64ySKTEbDPkJIL1F42QcxQl4mWbcztfz1itKwlN6RZ0BZoDjCJmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gyG780XwFfTd6tHy6LEsfWfQuw2LNmfo4IVc60oMAJU=;
 b=pcJdeoXQuQUYbmAjK4ZPT/HG5VmyVoaok+X+NNIoNOA5JMvuqbnmdWtYL9iJe9vs9q9ZxWjJ6NVzztAqXQeq4QbTfataiHI6kgHcikRTlmSybc1edTKYj50jwCtjo3bGa3Xp2o8ZIr3H52nN2qw7EnJcs36masxCNTjUhROO37U=
Received: from SA1P222CA0124.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c5::12)
 by CY5PR12MB6227.namprd12.prod.outlook.com (2603:10b6:930:21::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Mon, 9 Dec
 2024 23:25:57 +0000
Received: from SA2PEPF00003F65.namprd04.prod.outlook.com
 (2603:10b6:806:3c5:cafe::1c) by SA1P222CA0124.outlook.office365.com
 (2603:10b6:806:3c5::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.15 via Frontend Transport; Mon,
 9 Dec 2024 23:25:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F65.mail.protection.outlook.com (10.167.248.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Mon, 9 Dec 2024 23:25:57 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 9 Dec
 2024 17:25:56 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 4/7] crypto: ccp: Register SNP panic notifier only if SNP is enabled
Date: Mon, 9 Dec 2024 23:25:47 +0000
Message-ID: <cf956c36ee9f89a5273cbccd55e2ab50855d754f.1733785468.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F65:EE_|CY5PR12MB6227:EE_
X-MS-Office365-Filtering-Correlation-Id: 143f93e3-2c0c-45c0-3995-08dd18a8d590
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|82310400026|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eKvQlk3MPkGJk5D4xA8eJOIgXupJKISxnLrYiwqpiAIK5VTSK8EVsNR2F1bN?=
 =?us-ascii?Q?3B/ARSFmLw/CMPTzM4MbLk9EeP8FuYUAXDbivKhGMa/uSOR1yrnp/XZMfoec?=
 =?us-ascii?Q?E3E230C2ludt4grkYSH+aYrOYZLAYwgyiMeZwWkqOclWMK131Z7Kjcln/m6u?=
 =?us-ascii?Q?/SQGB/4rMphZXgf+trA1a57WXdjXbtC0j4xwMKm0tKWC6BwkE2c8ZH8nbOIh?=
 =?us-ascii?Q?+z5A8K36oHuW2oIGVmsIxMVcQnDJ3aR01A8h74su6hOgfrP2glEs2gmX5nkk?=
 =?us-ascii?Q?EVT5ROgqeSvc8IEHMSsk4Y5Kt92SSUikql42HJkAaEwSSuMq0x679oKjNl/h?=
 =?us-ascii?Q?g8NPy1wyyiBi0QmsDPMxAoUBAoA0XYOWpqTZXR3rLZnPyR5EbDYR+SHU4cAm?=
 =?us-ascii?Q?XrZR5WjtsuGndZQ+O0bU8qbiL0fcmaE8nyCdf94ddoClZcCBTxjIF76ZPZuV?=
 =?us-ascii?Q?/n2Lico/m1yZlbdEdGmE/QY5vzetmk6Cim/KEvsi9ri7s9RmOhNAh5Y+xCpC?=
 =?us-ascii?Q?14ZlecYj/mOCzVs8E2Ksfb6KAXxixCx5Q1G8BfOKEnVmhqmZXWP6GZyp2yjm?=
 =?us-ascii?Q?rieBLfTYqBOU8koVXOApK+oiJ/cPpJF6z6iJw5yefBuMBhdHwk+8PucxHa2a?=
 =?us-ascii?Q?iaVNP3onpnVY1TqvOjsI+TFO7+H4rX3YPgMMKhwt5O9uRnSIkg7CYpko5hnu?=
 =?us-ascii?Q?bRgdEU04HUuH5ljT8dQVYfeBeCsOmiRFGkjd2qnmoQ/eAsWjz5oYVe+xNxik?=
 =?us-ascii?Q?FtBdS9HzcJVCUF/cQTcYbHHKvbr2zrbxtSSh46oMeO/5dQ1O55gtt0OpB4cF?=
 =?us-ascii?Q?3q93dlM+WwU3YWcHInGK54LRciRv4D9SFrSdkk+VtLkcgxuWC0T5ft0YnHF4?=
 =?us-ascii?Q?IIIwj9u4daccJyHcm/eBOcP5J21VIMPxx0Tvhy3uHuSZUYLlMT7k4C0GqcwT?=
 =?us-ascii?Q?6a0KIuoIVRMB36jI1cLAwt2DNWSwFfczCr3UbjeGZg5en7OpXSlzvXzFmXXP?=
 =?us-ascii?Q?zDGoqPc3NwAPofghtnsNswi3+KPFc+c6QdhAK4uL1G0tgAzLvwJD593AmbQ/?=
 =?us-ascii?Q?z4k3IjQtAb6bJatS2yOOqLZUzNTZtfcR5JnPZJRabsB5f/pMMD2zEcBncx1z?=
 =?us-ascii?Q?6BjG+T/+tOi+CmpTxkcQRP6oLMbuG62XYj1eAeteUwqbWGdgLVChbSpo+dCo?=
 =?us-ascii?Q?UKBlqlhsFbYYFODL4hsFnNc5CNC7EeoDE1uBH8cX70RwWFj7u734numZXdJe?=
 =?us-ascii?Q?zwY0IYNiyaKFXM/xQHX43OWVkA+H44ADXuCVWdXwWAEDb4KMm6stqgffgG9Y?=
 =?us-ascii?Q?6a6rnr8VIqSQx64XvsE/9OQR7Sfh7izNeVfonv/WU8bhlnTcAjHRKcI0Xqr8?=
 =?us-ascii?Q?PwbaBbF40BUc2to0g0h23L7djW9l6DarK5WmFnBxQuzDPheIGc96CtAY3An2?=
 =?us-ascii?Q?xPL3cPyAc0Fq6/kVqpDQhpA1Edb9ka1Zs4J20zgoRoS+AhV/H+sknQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(82310400026)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 23:25:57.2268
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 143f93e3-2c0c-45c0-3995-08dd18a8d590
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F65.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6227

From: Ashish Kalra <ashish.kalra@amd.com>

Register the SNP panic notifier if and only if SNP is actually
initialized and deregistering the notifier when shutting down
SNP in PSP driver when KVM module is unloaded.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index bc121ad9ec26..21faf4c4c4ec 100644
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
@@ -1750,6 +1760,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &snp_panic_notifier);
+
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
 
@@ -2489,10 +2502,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block snp_panic_notifier = {
-	.notifier_call = snp_shutdown_on_panic,
-};
-
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2541,8 +2550,6 @@ void sev_pci_init(void)
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2560,6 +2567,4 @@ void sev_pci_exit(void)
 
 	sev_firmware_shutdown(sev);
 
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
 }
-- 
2.34.1


