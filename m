Return-Path: <kvm+bounces-20263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CDD6D9125CD
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:46:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 536E51F21B62
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96FC71552F9;
	Fri, 21 Jun 2024 12:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HUeYX3+d"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2054.outbound.protection.outlook.com [40.107.92.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37BC5174EC5;
	Fri, 21 Jun 2024 12:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973629; cv=fail; b=R30S7XGzM/Ra7Ud+rNhL1CxV6AIuF9nJEJLbR6OpgS/tGzd9IVlFdEqwVz8ST+ANzqZfwsCUQhkwpwca1XkNailjj6Viv2O20embEucbpKJdE3wa+xRVDdJvam9wJrD0k86mmTum79ino6lA5uJsjL0jfkAksgMoo4l4aKx6wjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973629; c=relaxed/simple;
	bh=1+3213QQ769gxx+1IShr/BrI9pCNudrk1GvzhlEViEg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K4ketJJCNrxCBLQovNc+6kIHHNFKHlUKZOSrI/zBy1qq8PYHh0acGRr0/8hq+jBc5HqqQR5OvU+nt/FDZ1G1izGLExuK2JQQrzU/NfaCnoOUT2zK5yMWwmsQuwvSTDT9IHqoxCCxn5UdMMD+Q+OWKhZSx3Uhf9xRNy5aLNI1iFE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=HUeYX3+d; arc=fail smtp.client-ip=40.107.92.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mWIYmCsyNuKnVRy6xOrnbeeWR0z84fOqOsdwpFBIA35nW8zQUMrKi2R8nHXlJ4qYt6Fj1I6SWXE4nHg4dwiHPAUnEfiwrlmjYH/bLVre0Sz5aPNqTxD9WuE0067Y6jDxn0TXtQ93MXxmXHw8goxi+bumOFwV6nMoOgzDfx+glZrw1mWGzYyt2/ran4h0B2oBhQWp5qSnIQfajBABGiyYU89HkCRTiLZUbHSUFS/ORSn6HWZl9IplvwHUxuCExblAOuE6rCzciWOlp9VtZ8aePwezFvY9RMnrs8EH7AkmpbiMcTGIfVIXJX/zfgjej9JWDB2tgVNdGmyY/yWNm+X6cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YcD3QQjTZ665rMp9/oJhPT+mMUI2guKQwU1ndHc7nMg=;
 b=WKhmh43ocu9X3chbXBBXIU+k0K5f1h8K+g4G/g2yhITKQLR4Bm02m1iTwX+2LulCaW3CGGp5fjw/bTaD+pqs/VGJxegd53vU5X9/ZzzXnSgVNMz4xlD+dHFoQqabpzB95yX8DvI4drlUTffIDdAGJJ0kIzYnCOE6MUC2lAndToN7tSuxYYAZw8eyBR1xK2MChRnFeB1bfFmrDGW8oxGlrUxiHZeTEk496ULbKKhNkSOiDsa2cl1QS4tlaAEWA6PDUpR//Unto682DV5dz3ownrXOywfCq76TZ8s2IOJvNLr+p6kzr3B/AyvbZM/D6xnO0G5Z1n7HUYOuSQdsIuBCsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YcD3QQjTZ665rMp9/oJhPT+mMUI2guKQwU1ndHc7nMg=;
 b=HUeYX3+d6ggcXiF88vFsFQKl23YtpD8+3ctYAGnMpTLUPfZBSA+1vS3aHNTshk0/rMcduAQoxX/tYrAZ0mw9MrDW3BkhZvu/HAezqsVniBUGzF8g9UzaAIxyeJFRjuybTBM0RidDWEQGC6zMQZ7lq8s3wOb2KEAA1DzSxibtqKE=
Received: from DM5PR07CA0078.namprd07.prod.outlook.com (2603:10b6:4:ad::43) by
 MW4PR12MB7440.namprd12.prod.outlook.com (2603:10b6:303:223::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.37; Fri, 21 Jun
 2024 12:40:24 +0000
Received: from DS3PEPF0000C380.namprd04.prod.outlook.com
 (2603:10b6:4:ad:cafe::ca) by DM5PR07CA0078.outlook.office365.com
 (2603:10b6:4:ad::43) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.37 via Frontend
 Transport; Fri, 21 Jun 2024 12:40:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C380.mail.protection.outlook.com (10.167.23.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:40:24 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:40:20 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 16/24] x86/sev: Drop sev_guest_platform_data structure
Date: Fri, 21 Jun 2024 18:08:55 +0530
Message-ID: <20240621123903.2411843-17-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C380:EE_|MW4PR12MB7440:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cdc0265-6296-4661-c4f6-08dc91ef527d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|36860700010|376011|82310400023|7416011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FNGHpjD6q+TyigrnIqY1dwGKsaCN12jlhac3MQKBD1+jK5v+HlyplrG/ejtp?=
 =?us-ascii?Q?rPrB8hbtD4fPLmK+MJYZMXI0z6eGmkcw1QLQg7Xwa2kg3rjHfqvqlZaDesBS?=
 =?us-ascii?Q?/diCkPpezuCwGvyTfw5bHWRrarZFBINpmeUNJH6yBdQ8fE3MeJGUIQJEPCCD?=
 =?us-ascii?Q?abxuH0nbBvSuA5yKbBW9yvAt6hn1EA8nRZbXiUjueH26gLhNbIddCecMQerL?=
 =?us-ascii?Q?7riCptEm0h1/dr604rE6uwz8cWqEwj6b/u6Pw/aAq1XnuA7sgvQiCc+FzOrd?=
 =?us-ascii?Q?5zRApZZqVXPWm7hU7/VFHOQ1hUN/OcFiU8SLNDlgD0+bAAF+f57Q1P8t3Vf8?=
 =?us-ascii?Q?KNm1JkeKZiVma0m9ksr0n+dKzZ2O+Zv0gkUexLkUFQSYSuEmaDDnfDF6P/4x?=
 =?us-ascii?Q?C7OMcJ6UF9ey1HvdY7J38nRRND0vhL8oU95UUfwjJ/J0NLshS+oYqD1NTmOY?=
 =?us-ascii?Q?hJpazYGkpS353TMdDcVa30NNp5SNhRCvlbodZxcnUq7GkRwmiLKEX1vTAwoz?=
 =?us-ascii?Q?exP/285egDlyxHiITlSPePhfd2BGNf1Z3GxCHoviAT8tO4zjh/DPpEZG3VGC?=
 =?us-ascii?Q?TktDEiAUXO6hOj0/4VuXzQ++Am9pePq1KWyqdNo3W+Iya73PLr+TehaqrfSB?=
 =?us-ascii?Q?5bCsP8zpXudTKf2GoHFG1vun6/F8zSPTuya17NtaI58NU75bLhfuW+liCApD?=
 =?us-ascii?Q?YfZ6IaFCtHnKIWE2Qq7O/pWf3YPX0OIMqXIf9rcWa4BVAiKDY8epEqxupYLi?=
 =?us-ascii?Q?puRjZEXrZ6HDgfMDrhtei4xVP6SWdbyw/dL3Txa9tyR7yIcfQbF03q0VGlj8?=
 =?us-ascii?Q?jRurm9WyBZ59vH+vHKkz+THWPR1Bex7hJuyqQb36av3tWnGHcjzBxKoJzHcI?=
 =?us-ascii?Q?4vEgdNNIj2cgRd/nITOuhhs7TKGyKJUSFXrBBaRHGYSZlJuHn2v/y9nyow90?=
 =?us-ascii?Q?Wd/FshdO+5lf0HZoDomw/OO/7DWOur5BEkZkMzYO2VFNRwPoMYnkiJP6Lpj5?=
 =?us-ascii?Q?8Z6zMxr4/SKPKD4J1dr/Gmb//abxNECr9hAIj2tGbmFJRO2n7JFd40dSh3oJ?=
 =?us-ascii?Q?2yFC6sT+xJUYXGU9CuYWFzLXk2ndZqdVPkmFL0Er+BEbZ2TQtK46wZVXCU5M?=
 =?us-ascii?Q?4WKufYtuhESmHtBX8d8J+CLcAbYGFwgDsAtp4YIOKN2mULjzvNQTOZ6ZpHNY?=
 =?us-ascii?Q?vLgXlv2mcaaxhY+tvR3bP69bVAPO2DX0yMNi5fBcxbT5K9e6f/O97YHnHxG3?=
 =?us-ascii?Q?qgudzvkRA0Eodti1tDTUVF3gOOcGYlgZXyBpJdW0OutY5am+dZq2306hhtZv?=
 =?us-ascii?Q?f/9SMdtWDFQ193z9m/kmVZnvsGsSGS7f1b40APabmoDYXFIS2hfqQv2UAvoB?=
 =?us-ascii?Q?1+0FvbfIq2AzCyaflqNxbp0dqVjBPSpr/Qq6S3vFq1jyJSsJEw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(36860700010)(376011)(82310400023)(7416011)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:40:24.5859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cdc0265-6296-4661-c4f6-08dc91ef527d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C380.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7440

SEV guest platform data structure was used to pass the secrets page
physical address. As the SNP guest messaging initialization routines are
local and secrets page address is cached in sev.c, use that instead of
sending it to the SEV guest driver and getting the same address back.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              |  9 ++-------
 arch/x86/coco/sev/core.c                | 10 ++--------
 drivers/virt/coco/sev-guest/sev-guest.c |  8 +-------
 3 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index cdd37ad9e4b8..c5ead3230d18 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -116,10 +116,6 @@ struct snp_req_data {
 	unsigned long resp_gpa;
 };
 
-struct sev_guest_platform_data {
-	u64 secrets_gpa;
-};
-
 #define VMPCK_MAX_NUM		4
 
 /*
@@ -443,7 +439,7 @@ void sev_show_status(void);
 void snp_update_svsm_ca(void);
 bool snp_assign_vmpck(struct snp_guest_dev *snp_dev, unsigned int vmpck_id);
 bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev);
-int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa);
+int snp_guest_messaging_init(struct snp_guest_dev *snp_dev);
 void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev);
 int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
 			   struct snp_guest_request_ioctl *rio);
@@ -520,8 +516,7 @@ static inline void snp_update_svsm_ca(void) { }
 static inline bool snp_assign_vmpck(struct snp_guest_dev *snp_dev,
 				    unsigned int vmpck_id) { return false; }
 static inline bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev) { return true; }
-static inline int
-snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa) { return -EINVAL; }
+static inline int snp_guest_messaging_init(struct snp_guest_dev *snp_dev) { return -EINVAL; }
 static inline void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev) { }
 static inline int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
 					 struct snp_guest_request_ioctl *rio) { return -EINVAL; }
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 8bf573d44b0c..e0b79e292fcf 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2489,15 +2489,9 @@ static struct platform_device sev_guest_device = {
 
 static int __init snp_init_platform_device(void)
 {
-	struct sev_guest_platform_data data;
-
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	data.secrets_gpa = secrets_pa;
-	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
-		return -ENODEV;
-
 	if (platform_device_register(&sev_guest_device))
 		return -ENODEV;
 
@@ -2902,11 +2896,11 @@ int snp_send_guest_request(struct snp_guest_dev *snp_dev,
 }
 EXPORT_SYMBOL_GPL(snp_send_guest_request);
 
-int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
+int snp_guest_messaging_init(struct snp_guest_dev *snp_dev)
 {
 	int ret = -ENOMEM;
 
-	snp_dev->secrets = (__force void *)ioremap_encrypted(secrets_gpa, PAGE_SIZE);
+	snp_dev->secrets = (__force void *)ioremap_encrypted(secrets_pa, PAGE_SIZE);
 	if (!snp_dev->secrets) {
 		pr_err("Failed to map SNP secrets page.\n");
 		return ret;
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 0631271e5b9c..76be49da08de 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -591,7 +591,6 @@ static void unregister_sev_tsm(void *data)
 
 static int __init sev_guest_probe(struct platform_device *pdev)
 {
-	struct sev_guest_platform_data *data;
 	struct device *dev = &pdev->dev;
 	struct snp_guest_dev *snp_dev;
 	struct miscdevice *misc;
@@ -600,11 +599,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	if (!dev->platform_data)
-		return -ENODEV;
-
-	data = (struct sev_guest_platform_data *)dev->platform_data;
-
 	snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
 	if (!snp_dev)
 		return -ENOMEM;
@@ -619,7 +613,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (snp_guest_messaging_init(snp_dev, data->secrets_gpa)) {
+	if (snp_guest_messaging_init(snp_dev)) {
 		dev_err(dev, "Unable to setup SNP Guest messaging using VMPCK%u\n",
 			snp_dev->vmpck_id);
 		return ret;
-- 
2.34.1


