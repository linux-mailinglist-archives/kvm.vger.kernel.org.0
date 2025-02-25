Return-Path: <kvm+bounces-39181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 609AAA44E39
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:02:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4772317B4C4
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:02:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA48221481A;
	Tue, 25 Feb 2025 21:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NWNvDGuB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2088.outbound.protection.outlook.com [40.107.102.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914E820FA9A;
	Tue, 25 Feb 2025 21:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740517264; cv=fail; b=lZ4niW1ote4jjHauvJLNmx/iYeC1KPbmNQy14TqF8JQmaKWReLvXwfOC9OJKR+6Drl4f7dI5ntRyGPPiaTFUIs5uHzqHQiVYUrMivnJIWpt2KJBZV3977iDrovRxk7LsucXVmh5GCqJNfl0zKFPPXGTWprvhig/Zxg7kwFFDRzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740517264; c=relaxed/simple;
	bh=GDcns6ImL1n54rhNMMUmFOcZEjdqnAV3IeIcu+bWrDA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AKd5a8FdqV13XCnvbAgeW4UdvAdbf4lyBBH7kBdDfAM9eWCtJYMlQ+00ch1CneFRI62miKL9ZLbBvkDBWN8noF/e1t/+9Qc/V/SNUpHFyj4q3A1IuCZ3pN6MTxfDZtReoI0MoFqC/jTcTm/tlxbee7WSlQqgYVhUOjgq8LXq1VM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NWNvDGuB; arc=fail smtp.client-ip=40.107.102.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Bi800vAiyt5OeZryBWOYDcHA5ix2eJb84F3dFJm2etfFxdWl1qxFJNHiUyJTpUfxIO6awndeOi/1zWxCwGR3meHz3OdyAEepvlUUzWzwQskUmeTm0Sketxe0zMZ6EU8iHFiou5I5/bb0MtLuRa/bZb4DGyVuqrTUkXJq6zEjcYlEDAKZhspoyGVFszcNO065YQ1wOLiEiBd5CZP9au6v07GRRUFZytJmLLkgB7K8siiVIkd/XkfOG94Y4GIksKRInQ85Hq8tI/U0ncj6lRbeldhrIkpTPDHVe0UY6MW8Kf+Ad33Hpr8J7DA2MvJYhcT02EHblB0Hs2BE/fwFqqZ1Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mToQB7N40CXBzM0v7vvsPNe3+CmyYg6yXdtPOCLDuCk=;
 b=FSm7dwRFdyjTlc4OTH0HNwiLiWBDjLrdmjWi3NMcNyTRjw1rm80wzSW0g2GfABob6uR8ZebEKLbncMvt8L0nI6fZNlzkXPKpcEPbFNXKjy4IYiyp6wIDE5YJekSxpCfdQZq96TWcG8SEZ2VipahzfBF0CNh3Jt+RrOy6JI4RsvXqRnuCbCGlPrpoSwq0aK79cXBplNUEh2KpU5uZO01ACB2D0bN8WqOxjsr66ecBsp+dUVXy6QKGKDA1dUeYKbyqUAnetkHBFRdAqtlIUL4IeGVYK0+pzuO5ExT0zNYBL+Bsdvm5fJPhQbagO14Wxx/0iW64GANE3FOwaw8RYF+S7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mToQB7N40CXBzM0v7vvsPNe3+CmyYg6yXdtPOCLDuCk=;
 b=NWNvDGuBg9r/DdkK3UzcGDvsZw4TBWWqQnfsCsvbr0RJSKgqJs+dbiyx5r4WJImJk7h4Ua8wNELBulpf2rkStQMFpSx68CVd859ob6F//vEOiwe1E4Qgau4LO1kru3fj8Uw5l93kty/kFp9t+hjgScYRrdhmBnDmPvWCaRrtweA=
Received: from BY3PR05CA0015.namprd05.prod.outlook.com (2603:10b6:a03:254::20)
 by MN2PR12MB4271.namprd12.prod.outlook.com (2603:10b6:208:1d7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Tue, 25 Feb
 2025 21:00:58 +0000
Received: from CO1PEPF000042AB.namprd03.prod.outlook.com
 (2603:10b6:a03:254:cafe::e1) by BY3PR05CA0015.outlook.office365.com
 (2603:10b6:a03:254::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8489.16 via Frontend Transport; Tue,
 25 Feb 2025 21:00:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AB.mail.protection.outlook.com (10.167.243.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 21:00:57 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 15:00:56 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v5 4/7] crypto: ccp: Register SNP panic notifier only if SNP is enabled
Date: Tue, 25 Feb 2025 21:00:47 +0000
Message-ID: <29e8c21eae96b2cbe0614d04cfa1014b424134b1.1740512583.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AB:EE_|MN2PR12MB4271:EE_
X-MS-Office365-Filtering-Correlation-Id: b14eb413-21bf-49aa-7ad2-08dd55df8073
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BzS35aADPdPVlYI31yQMscCONgkE3meNJfmx9PuEBvptSbEvhCvoU+sZpXwT?=
 =?us-ascii?Q?yeViUOuKwMU0X88Ub1/ugAbQjbVdPG3WT7N2rZY6nCDd5VeXtMid2dU435E5?=
 =?us-ascii?Q?wwy87/TLTNVG0ArpkHKvvPrqinsGf12c3atL1TCClSXpUGvJkEhS9gXWmYho?=
 =?us-ascii?Q?3xOZUSq1HAVR15zS9RBs08bCQGGLou4M614kyHZFXhzYfyVy1OzpLQageFB3?=
 =?us-ascii?Q?4FzeXSIF/49zxm3fobpgECKLGWEEKrm8m3frO+tCPygkU6R9ROkdnII1xtr2?=
 =?us-ascii?Q?NKwe7sOTbLj1LiwIfj+LcBHxX88gKCotzlCaFTrTbgJgUyIX7NvwcTvEbs/4?=
 =?us-ascii?Q?e8indsfWPLmGZhAGis/SkpzQhLKv//OgHd0Hybtmein56XDgdxBShrxtFzBD?=
 =?us-ascii?Q?7gviOMknbyZpwtPnEaj/2obVVn/sUq6zTIoucD6PFFfH7d05mV+yc1QC4b93?=
 =?us-ascii?Q?RoV6r7COW2Ed90fCA9V71qGLYQdk12TylEMdjAnU63txg9LF++8u8CH1kbl8?=
 =?us-ascii?Q?1LR324s0t2um7gEwnPudPW6aBwUbQGcbVj9wwXFYm20Bw9xzhoYL3NMRKCLx?=
 =?us-ascii?Q?3XG4rn/tZnLTf+g1qxk0dpjCf94Z9+KZMLkTVWFHPmSbSCm7nnftNgSDAizq?=
 =?us-ascii?Q?CX59EOMtgXHRwMKTE/A3172kHFuwHJPJ1X1AkMD3OtPowoKYUqKvaA1H2BAo?=
 =?us-ascii?Q?EEYs+sKGfSlqGURrGF7xUl1OubHYnPpdmhELCo6gU05A0iCsrVWf5N4m8jvh?=
 =?us-ascii?Q?O8BWcQfXtTaZd5xgvDBx2jhTwSRwDPwzPd7QtU/sWCIjfSpJWenYPv9P2Ex7?=
 =?us-ascii?Q?MOYQHvQ0iNdYRdWRGdX3uHMFW/Wf9QQ7+baMTg/KWOw4btO3YgHJarHW9wLQ?=
 =?us-ascii?Q?mAJ83OHPv5JJEro24XawjroKyZCacOJceN+IKc98d5Tqpot/VdU2vn9Likiy?=
 =?us-ascii?Q?OKM2qQi9mvvFgj6e68Qi1kvAUv1dxKrymt+xYM6v5BdZcq/GYCFmSZgsuOK9?=
 =?us-ascii?Q?BQHdiHTqoRTV29Kl/tM22dhXbQvYxkHzePhOrDzqlVAmGj61eWKkCQCPqbKR?=
 =?us-ascii?Q?LJajvLewvVS4myjJTXGFXzwi3lJ/+xk/QRuencDSglkyLgNhclNgFwAhQri9?=
 =?us-ascii?Q?ptyCS0IBkYUy9nMQvYAV30vDvccFZRRDEgNLPZR1jErENRXnv2PhVKINPTi7?=
 =?us-ascii?Q?L2b2ctBt98djqgbqitApEwbdJxCz07F0InrHXXIhQkNehqP3d3rUdNvlcc5M?=
 =?us-ascii?Q?eASmHtw92Fr77JxBTFulVtuQZJbLrw4PQq8pCBuye0ozNKLWbya62uv7goXH?=
 =?us-ascii?Q?XF+qIwCgD2LRhqye8RNCmDAfG+TtiG6TEJ5mzcnYXBm/PV7liHn7KkPuirY8?=
 =?us-ascii?Q?1pXj+WHoa0oKMq2Rsgpeqo5d1+ihuVMO66DyBJqnL63PSYT90jwoxCvgFxEA?=
 =?us-ascii?Q?Bw+UlC6hLPs0xmOLj/XZlNUV/voWAnTgHcjZSmY1pYXRk3orl+SnjDxV8YlQ?=
 =?us-ascii?Q?WHPHElU76yEFVUs6vbxLdshehgOJcIfTrtFA?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 21:00:57.6191
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b14eb413-21bf-49aa-7ad2-08dd55df8073
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4271

From: Ashish Kalra <ashish.kalra@amd.com>

Currently, the SNP panic notifier is registered on module initialization
regardless of whether SNP is being enabled or initialized.

Instead, register the SNP panic notifier only when SNP is actually
initialized and unregister the notifier when SNP is shutdown.

Reviewed-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Alexey Kardashevskiy <aik@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index c784de6c77c3..b3479a2896d0 100644
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
@@ -1198,6 +1205,9 @@ static int __sev_snp_init_locked(int *error)
 	dev_info(sev->dev, "SEV-SNP API:%d.%d build:%d\n", sev->api_major,
 		 sev->api_minor, sev->build);
 
+	atomic_notifier_chain_register(&panic_notifier_list,
+				       &snp_panic_notifier);
+
 	sev_es_tmr_size = SNP_TMR_SIZE;
 
 	return 0;
@@ -1754,6 +1764,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &snp_panic_notifier);
+
 	/* Reset TMR size back to default */
 	sev_es_tmr_size = SEV_TMR_SIZE;
 
@@ -2481,10 +2494,6 @@ static int snp_shutdown_on_panic(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block snp_panic_notifier = {
-	.notifier_call = snp_shutdown_on_panic,
-};
-
 int sev_issue_cmd_external_user(struct file *filep, unsigned int cmd,
 				void *data, int *error)
 {
@@ -2533,8 +2542,6 @@ void sev_pci_init(void)
 	dev_info(sev->dev, "SEV%s API:%d.%d build:%d\n", sev->snp_initialized ?
 		"-SNP" : "", sev->api_major, sev->api_minor, sev->build);
 
-	atomic_notifier_chain_register(&panic_notifier_list,
-				       &snp_panic_notifier);
 	return;
 
 err:
@@ -2551,7 +2558,4 @@ void sev_pci_exit(void)
 		return;
 
 	sev_firmware_shutdown(sev);
-
-	atomic_notifier_chain_unregister(&panic_notifier_list,
-					 &snp_panic_notifier);
 }
-- 
2.34.1


