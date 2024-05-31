Return-Path: <kvm+bounces-18485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8543F8D597F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:37:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 359962896B0
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:37:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C6B81AB1;
	Fri, 31 May 2024 04:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D4YyPTRV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08A9781730;
	Fri, 31 May 2024 04:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130078; cv=fail; b=fx2QaxYAL1rTbAt7ix6FoejcIFvzM9C3gTt16vdBRnc/82IXb5adIVXJsQkCdfmvSXswpQfBaWYhYr2+7NOZdisW+1blrAXOsAaisAaOX6x36fe/YnsB4bDbrzaJxtrEOK5NiiFXOncWAtjadhlUYdjhIjk1FjlfITfo4AeTRiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130078; c=relaxed/simple;
	bh=cQGOlved0tQmJKoUYAdNx2BMn1EbWhqcNlTE0N0mVI0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BSj/ZwQtXymEBQf5zdX6nn74WL/MpwU6ElYibcbK+Y5Ue7ZLE3Ybm53E1N6C6ZZhnUWj/6JrJucDjedfMpK1pafhHxJAUt4nuE8IUpv4JRTIKgbS+E5Sn75qUrh8dIVsMr9+1yJqYlSTAL2LCPaPNQ5+PLwXfCRX0W9kwzn7Hzg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D4YyPTRV; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bM20h0yyZvmvhiI44rp215zV/6JOBKZgooCCHPnwuM1qEo/kxNvWQEjOuVJHdtH+JFUHWOujY90I6yFBGan9arvryE9XOVOvNCaZtc0478XNXe8WoQswklnnz0CSaJsQgJ/8vXbnO21P6XgyB2RgIzu/Jk2jpQkrGnWT05LeLaF2TKsjqK9A1DBZAv39wwKCE1DAxxmIFfktnb6YTP5+ny/ru7GJSEVRK6Q1bUqPIJSVc1ogTXViwBx5dola3FZ0K5KvEyyRiODc+jEl1GJ1YSye6K1mZf5x4i59y8AULDlbdT4hYP4Xji8nh2KgK8aEm/02OioF6jYdUIY/0blfHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BJGPFCKzNEwl3egjrviH4RCpCB7V93sRbJj49WF3LQM=;
 b=APYlB4n6pUyO+imFUppInP8ciC1BDBcbFoDsXLGYrz0UwSDZgjgO8+EcPsniDluleMIEvfzV8Irqh5LZGx7gSvrYLCdUTQo9QjfcMyo1S+HgQMMWi/srk/dFFvVsnTxVLEyVadetc1on2r98aZ7TDujN9h88QN6Yuo6PfylDMVhuD5Qj2SMUpEe8LSyPihXw4+c0/zpCX8mDb7nMbsJpRzqK9zaWAeUpQVV32fxzoIAsz6a4hX3VkoqyVxXKIhYTAuMzY5fX3MzXrziGoitmaIeJmjVelo3kopCtEmGMcm/guOc1cBnQWufvZrgeBsfaWopQqA7jFZMzgtRFbolpwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BJGPFCKzNEwl3egjrviH4RCpCB7V93sRbJj49WF3LQM=;
 b=D4YyPTRV+IkrCI9hx4bYiinYInhrEpCudBjNSWb+h065KjBNVFVEKwAPrrja0iK6kBRmcNKkY/Y4H1jEIyjX1IdFZpbKLLTKrDttki1EiBMwRuRLoS4NOKpVNLUS8Btd4tXfJseaaMWudO4vzgI/gAKvjXqKfBfbO/R0Li5xRlE=
Received: from CH2PR17CA0019.namprd17.prod.outlook.com (2603:10b6:610:53::29)
 by IA0PR12MB7676.namprd12.prod.outlook.com (2603:10b6:208:432::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.25; Fri, 31 May
 2024 04:34:32 +0000
Received: from DS3PEPF000099D5.namprd04.prod.outlook.com
 (2603:10b6:610:53:cafe::b3) by CH2PR17CA0019.outlook.office365.com
 (2603:10b6:610:53::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.18 via Frontend
 Transport; Fri, 31 May 2024 04:34:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D5.mail.protection.outlook.com (10.167.17.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:34:32 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:34:03 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 16/24] x86/sev: Drop sev_guest_platform_data structure
Date: Fri, 31 May 2024 10:00:30 +0530
Message-ID: <20240531043038.3370793-17-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D5:EE_|IA0PR12MB7676:EE_
X-MS-Office365-Filtering-Correlation-Id: 71de84fb-8915-46cb-5437-08dc812af7da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|376005|7416005|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mNCday6T2p5gKxF4RKv1jPVN8gBsVjO6CTo4QAOErve5XUGpKuIKsWp4qgEC?=
 =?us-ascii?Q?p51/pLKUHyOAcGVBsjZf5W5UlksH+n9WuRD6E56ohjLSQy126menS303fk6z?=
 =?us-ascii?Q?EU/BuG4/b2GM47v+WI0v7WaNj34TmOk0v8fEWDoUFRPAtBW0R7uNo3Fi/J/6?=
 =?us-ascii?Q?qxPmFpD3LjDAjEO+rPsw+KXJNvLcv0qVZ90txsPfhpuE0T/kDYXj23+sbNQl?=
 =?us-ascii?Q?uChp7TYKQREbVlbHS3ZdoYd4EyGLmnaz9DUa5HOLe5j1yD7Ofui2VU10Knpg?=
 =?us-ascii?Q?NgMonFXPLG3h5MZg60Sz+8FsruHmmi2Y/Z0M3pFpTPjHqFA2k30NTOx8IvNX?=
 =?us-ascii?Q?0K5z0FINL7r59tyzX2YHK15fHU5zvl9V+BSccSJpMDf7ZFLzhf9rDydw4J/o?=
 =?us-ascii?Q?vAZ/O5zixF3Fgv4z/ZB9VmRAJ7FB4wWixbTl5YIqezjLQtU8ju7T6d/pWGGf?=
 =?us-ascii?Q?nMXUzDTu7CejO2nvN3BgAqgZYFeJMwo3P7i4M2hk5k65Pec29cffLJhb2MT4?=
 =?us-ascii?Q?YE7Q1cTo8r2nkDgqFB31/a56CEC5CZLfaaA4XGj6LQpQp0ubtXfsMNAPk8Xf?=
 =?us-ascii?Q?SuI4hyKU/0uxjYnPsPHsx26I5ez/puxsM0LKEABkMeODEzoV9k1fl280wcWm?=
 =?us-ascii?Q?cC/LkezMswZ8KSFCcNPkr/aJTSLXLEhVVkkWfH9kii52vb93nv5qx2eP9I2A?=
 =?us-ascii?Q?PkSFI/Sm7E3eKR8nxOspo8Hf3QjY/O0itHv+swNs7peKdsBTDzr+PpSvb1I/?=
 =?us-ascii?Q?YShradNYXjklkIx2iuCVCPwCP4i/2oB2/kNIAleLvgP+Zds3/iZ6CjvZx07H?=
 =?us-ascii?Q?oluTGlTuLNVuJ6ParRrAJc48qjk1h5QKiqPqXNlFG1W5N7nU8qmV5055dC9n?=
 =?us-ascii?Q?E5DeYQsjk7wWnvBFfLjMKGZNaxJlS33p3iO0Jg2ynVHbSHPN6E56sYDxbdo0?=
 =?us-ascii?Q?QSuwfEW36v9fS7Q2dkvqqWfZuqiIb+VZ7JpZllpVh42OmdzZWDVQcPSbjblD?=
 =?us-ascii?Q?Kx69N2eCubhgVU5lgWkNmF7V20z2okGOcmT2IXngJ7EFPwrKn+X0LpPtdLun?=
 =?us-ascii?Q?VGb+g6v83YqyBqjCJHniFHxV9fh65dToXahdGG5KPMhCpYCJjOWz+lGDf0YS?=
 =?us-ascii?Q?FGT6GwwuM4HcSy4Wz+u23/oaObeWnVtk+yAzry3w2EJoLBl9K76B8uGC3ylF?=
 =?us-ascii?Q?tjM5ecnBkwfuqL1OPhbRjelyeeUFOqXxKGr1B4rYf1etDJjzvbh+ze/fqgmI?=
 =?us-ascii?Q?MxQtCb7xJ/+1f71zoDNIFJgDOkcTS9LtP3C+qfc1uEExJQ3mclAHATi+eLMi?=
 =?us-ascii?Q?9LG7iuzmaeGjTY8B1kdw3SszAG3hHw36LwS86oKmg2xpwWStSJXR76wkut2T?=
 =?us-ascii?Q?zdz0N3/uqXO8X2lIp7fCdTr8LlS6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(376005)(7416005)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:34:32.5720
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 71de84fb-8915-46cb-5437-08dc812af7da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7676

SEV guest platform data structure was used to pass the secrets page
physical address. As the SNP guest messaging initialization routines are
local and secrets page address is cached in sev.c, use that instead of
sending it to the SEV guest driver and getting the same address back.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              |  9 ++-------
 arch/x86/kernel/sev.c                   | 10 ++--------
 drivers/virt/coco/sev-guest/sev-guest.c |  8 +-------
 3 files changed, 5 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index f58052fd6cb3..128bf71302a3 100644
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
@@ -324,7 +320,7 @@ u64 sev_get_status(void);
 void sev_show_status(void);
 bool snp_assign_vmpck(struct snp_guest_dev *snp_dev, unsigned int vmpck_id);
 bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev);
-int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa);
+int snp_guest_messaging_init(struct snp_guest_dev *snp_dev);
 void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev);
 int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
 			   struct snp_guest_request_ioctl *rio);
@@ -393,8 +389,7 @@ static inline void sev_show_status(void) { }
 static inline bool snp_assign_vmpck(struct snp_guest_dev *snp_dev,
 				    unsigned int vmpck_id) { return false; }
 static inline bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev) { return true; }
-static inline int
-snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa) { return -EINVAL; }
+static inline int snp_guest_messaging_init(struct snp_guest_dev *snp_dev) { return -EINVAL; }
 static inline void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev) { }
 static inline int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
 					 struct snp_guest_request_ioctl *rio) { return -EINVAL; }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 141a670d2a85..c56cb2f15ec7 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2239,15 +2239,9 @@ static struct platform_device sev_guest_device = {
 
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
 
@@ -2597,11 +2591,11 @@ int snp_send_guest_request(struct snp_guest_dev *snp_dev,
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
index 41878bd968d5..8d026d485028 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -406,7 +406,6 @@ static void unregister_sev_tsm(void *data)
 
 static int __init sev_guest_probe(struct platform_device *pdev)
 {
-	struct sev_guest_platform_data *data;
 	struct device *dev = &pdev->dev;
 	struct snp_guest_dev *snp_dev;
 	struct miscdevice *misc;
@@ -415,11 +414,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
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
@@ -430,7 +424,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	if (snp_guest_messaging_init(snp_dev, data->secrets_gpa)) {
+	if (snp_guest_messaging_init(snp_dev)) {
 		dev_err(dev, "Unable to setup SNP Guest messaging using VMPCK%u\n",
 			snp_dev->vmpck_id);
 		return ret;
-- 
2.34.1


