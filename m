Return-Path: <kvm+bounces-20256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 561389125B9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:43:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5DDD1F262EB
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:43:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACB931607A8;
	Fri, 21 Jun 2024 12:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Zv9S9EWx"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2087.outbound.protection.outlook.com [40.107.92.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1776A160785;
	Fri, 21 Jun 2024 12:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973604; cv=fail; b=WO839+DERRv5IUuwAG8MgkkrSHrWia2ixUbvCn756DFo7v9LHZKPjfhMrfyhyeepJiTjsiaJ3dyoi6YI0lOgEiU15eqicljSNve/sPhENLCkiOrS4JoHSLE065r879qYSneiP2+YhQxMLTU9SQsedBdn2uPBOTrkdg6VVjr3rqU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973604; c=relaxed/simple;
	bh=F4nvjMJ01C7up0tkfbbxDOnA+7ZN+7MUs/HD68+R65o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jFlj/fikyiE7djKaeH2iJGPH1uvdAv3QRWXWV3qCH7APNYj3kPC2PAbNiy4sm6Zr+HmWs7lPPRU3v/sJKYH06uwjOsOGuxUwANl87e8vXkV/w/wUoAfF6apDo1/ApNuPFRspr5+dZBqEdmznZw/Knc0MclH/nXYTKRh4aNdmaQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Zv9S9EWx; arc=fail smtp.client-ip=40.107.92.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EvwKLLljF4dryQKo3dyTqIdrdVZU8hang/Fq+lPnG0BjeIlqDcAZpR5kXr1cZIH9imzyHY8+mnJIvPujkoAHMws3L2mGIlwiPt/KGrs46gnx+7GdO9mLnEV7/he/uBnAhbYiVkzVQH2oE5atVOeQuRVTikVHCfplHSvAIlcuPgTw0pMThZ+e83NTB7jp/YMgByIuEpVp1z2kLXsEJ2s5clyIGfHBwLpSbPORoZ3ZX2npO0vSe4uFZElUjdIJNF8ZTwaZN5YxuCUlfn4MAS14LLQ3jS4MBfyvMJUgDxBUE234LdA9orpoYynWNprQfp3Wmzvp8pXfL6+qR2adTOCuog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZSO6r2yNeKYfj2Ua1o8fKr8aQZgpnuHohoX02r2igXw=;
 b=c8q5QDTxfluRY1t9cA4U/tJvrMcR0Iqq7rdQvPzWpBY+GceLHear3pA1nfoPd6dAG62NcYCFnNJEuITgIZxQI1uuFb9gL7trUoOnf6aLSxyzV9w92OKTO9+039X4O/ooGvL2Cuvukb1BqHMGkRnhlQWbdqSZmJhJoxeBRVnas/H48wPntCfTk6RZrrBwFWWwkupwoDsOwb1/37yng/42f+DewcJyLOVn+J6vaThMZ4GQhmqJCiTsyTyegXCn2ENDTl5tLaMppmbwIYIXiFABXXnzPmnp5SRCO1/bolpyUxKferLXdV9WtgVEGcVS8ON6J0/ay1OThWPNTP0t+ekotA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZSO6r2yNeKYfj2Ua1o8fKr8aQZgpnuHohoX02r2igXw=;
 b=Zv9S9EWxpMj1YblmbFQBm0Ka1pait2yUk63ur/9A+dqS8bIT+j5eht5fUaQlVLR2BtCC34yFMeIPAtHvWeY9a6Ldo9bNIP7MomK/eLtj/gGRLY6lwS5FrLKyVywStHDrZcUWsTAN5EApJCdomF0830WTdN5Q6UVoHNYgKnERaxg=
Received: from PH8PR02CA0009.namprd02.prod.outlook.com (2603:10b6:510:2d0::22)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 12:39:59 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:510:2d0:cafe::c5) by PH8PR02CA0009.outlook.office365.com
 (2603:10b6:510:2d0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:39:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:39:59 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:39:54 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 09/24] virt: sev-guest: Carve out SNP guest messaging init/exit
Date: Fri, 21 Jun 2024 18:08:48 +0530
Message-ID: <20240621123903.2411843-10-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: f0cde540-90ab-4e34-a9c4-08dc91ef4349
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|7416011|36860700010|82310400023|376011|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YadlzZt2GTDmYtB9jCuD5Uf3oNbUMQ0dwMBNlDbusose585+U2YVv3TeYesd?=
 =?us-ascii?Q?/aHDTYzdUy9rS6VUjaRsTtorwReUpF4jPgiRc4XyBFIJ+/fyPp6i9SyjOMtJ?=
 =?us-ascii?Q?CCFdu43ujEFTpYGJ8exLyz7yCpYsAB6rzAXhQ/zjJzqy3oVqB0/LcjUuH2kx?=
 =?us-ascii?Q?fhhBIuf3fhooYa/JZE1Ah4FHCcUug2xvfT2aMsN7/CNTA0Dv3+Gls4UhU9gD?=
 =?us-ascii?Q?zd6ET98hWFnrR5a0DRMaNqxYKgxDQb9AUFd1d6XhjYeHZxznZ8Xa7pHAV2zo?=
 =?us-ascii?Q?mAiV2HqhaYAEBJdYAOGkweE3U7K/ALd4c5DXlP51Kw8Vo9UhBnhh8EcjcJUb?=
 =?us-ascii?Q?3dFfBlo0YKlAj4neXSC+gk0Air+juNAeOX1QBq5TMC0rfU+f4Gp6iI6GnV1n?=
 =?us-ascii?Q?7kP3WI5hX1Q7ZrFHb3nLW3RDyZgx8xTTcj4urUxFHEl9f/KJpTrifVP4d44S?=
 =?us-ascii?Q?0sN8SdmwjTdXCp9M/3ljORT9cZa1GaNDZLOg+jvZv5hPZ0MVzW62JFb6BB0c?=
 =?us-ascii?Q?BSX3X2sOk9vfkbnRk2wqyiyjtmyLTNuyxogHwc2IsfVehMtXaQYsxjGiSQo2?=
 =?us-ascii?Q?J3igZ8U/98FW4h/H8lg+QyBRJe4URQgYwfx9H9Q/DV/1T1vkbO4LR74jq0/N?=
 =?us-ascii?Q?KX8xuZDIyJnras0W1szQx+Z27LOK4Os+c4cQuzH6X4ru7ODfMFr7UBL/O76h?=
 =?us-ascii?Q?4+wMjw4NVGMRwqhdBUaaOn1M8PPzmykySAxSHw3U2jF4plQMOZrSr9edPOwI?=
 =?us-ascii?Q?LBRPL/Z6WQamo1/oj31L3wS/Y4yKEepL6BEozYizRUwPgirVvCqdsAtj91cH?=
 =?us-ascii?Q?RmSLQZTy/T74G0XvtDYLq0+xU+YZtmGE5yjveFCIARoC9MJBNgPXB/M+sVTe?=
 =?us-ascii?Q?eL4rY03NyZwxAmgfBiaDJ+AmpxqdkH/6APL/5MwDhLSxnvU9dWc30XLs0b3I?=
 =?us-ascii?Q?xRNfkBI/Wx7YDx+mfcSIyj7k6ppG30WoXq8gddg7xqhyMT4U62HWhf8k6av2?=
 =?us-ascii?Q?G3D6N8WFFqUqCEYndP7MwfZB3ogfo1Bn2Bvf30oaM8mW2hqr7VJwYagPsF3Y?=
 =?us-ascii?Q?7FExicKP2F5RvPpQJZHxk5ujsLFm49ufTeXFYOQ/9wERdNDiEfaF1IXmmGpt?=
 =?us-ascii?Q?1CzywEhom4rPzQ0lNEA1pIA1QN5EUt0ITvLnB+ALDQmyW7/88q/PC9Af3Mld?=
 =?us-ascii?Q?taPRuQxygyHE6ICNUNuLzYLck6/+LYX0yyWDlZUa3VWntFQqXcb+18eUwaFo?=
 =?us-ascii?Q?eAVDXMI1Jl733b8qUpT4D0rWzJZ/YmX9EwhGQR9Ye0mw7H+p4Wt7RPbtp/5t?=
 =?us-ascii?Q?busnoQOQU0jhDdIJoxsfd19CejBWz6yto5H2OPdR7AcrJ8vZUuFbCBNt/wT8?=
 =?us-ascii?Q?HuIyWOhp44OyJ+lGNa2RxrSNxnpng30JlNItZusi8Tc5YGIPog=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(7416011)(36860700010)(82310400023)(376011)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:39:59.0786
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0cde540-90ab-4e34-a9c4-08dc91ef4349
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395

In preparation for the movement of common code required for both SEV guest
driver and Secure TSC, carve out initializaton and cleanup routines.

While at it, the device pointer in alloc_shared_pages() is used only in the
print routines, replace dev_err() with pr_err() and drop the device pointer
from the function prototype.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 152 ++++++++++++++----------
 1 file changed, 88 insertions(+), 64 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index ed00c21ca821..ec1ae5c3f4be 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -161,6 +161,11 @@ static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
 	struct aesgcm_ctx *ctx;
 	u8 *key;
 
+	if (is_vmpck_empty(snp_dev)) {
+		pr_err("VM communication key VMPCK%u is invalid\n", snp_dev->vmpck_id);
+		return NULL;
+	}
+
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
 	if (!ctx)
 		return NULL;
@@ -640,7 +645,7 @@ static void free_shared_pages(void *buf, size_t sz)
 	__free_pages(virt_to_page(buf), get_order(sz));
 }
 
-static void *alloc_shared_pages(struct device *dev, size_t sz)
+static void *alloc_shared_pages(size_t sz)
 {
 	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
 	struct page *page;
@@ -652,7 +657,7 @@ static void *alloc_shared_pages(struct device *dev, size_t sz)
 
 	ret = set_memory_decrypted((unsigned long)page_address(page), npages);
 	if (ret) {
-		dev_err(dev, "failed to mark page shared, ret=%d\n", ret);
+		pr_err("failed to mark page shared, ret=%d\n", ret);
 		__free_pages(page, get_order(sz));
 		return NULL;
 	}
@@ -972,14 +977,80 @@ static void unregister_sev_tsm(void *data)
 	tsm_unregister(&sev_tsm_ops);
 }
 
+static int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
+{
+	int ret = -ENOMEM;
+
+	snp_dev->secrets = (__force void *)ioremap_encrypted(secrets_gpa, PAGE_SIZE);
+	if (!snp_dev->secrets) {
+		pr_err("Failed to map SNP secrets page.\n");
+		return ret;
+	}
+
+	/* Allocate secret request and response message for double buffering */
+	snp_dev->secret_request = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
+	if (!snp_dev->secret_request)
+		goto e_unmap;
+
+	snp_dev->secret_response = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
+	if (!snp_dev->secret_response)
+		goto e_free_secret_req;
+
+	/* Allocate the shared page used for the request and response message. */
+	snp_dev->request = alloc_shared_pages(SNP_GUEST_MSG_SIZE);
+	if (!snp_dev->request)
+		goto e_free_secret_resp;
+
+	snp_dev->response = alloc_shared_pages(SNP_GUEST_MSG_SIZE);
+	if (!snp_dev->response)
+		goto e_free_request;
+
+	/* Initialize the input addresses for guest request */
+	snp_dev->input.req_gpa = __pa(snp_dev->request);
+	snp_dev->input.resp_gpa = __pa(snp_dev->response);
+
+	ret = -EIO;
+	snp_dev->ctx = snp_init_crypto(snp_dev);
+	if (!snp_dev->ctx) {
+		pr_err("SNP crypto context initialization failed\n");
+		goto e_free_response;
+	}
+
+	return 0;
+
+e_free_response:
+	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
+e_free_request:
+	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+e_free_secret_resp:
+	kfree(snp_dev->secret_response);
+e_free_secret_req:
+	kfree(snp_dev->secret_request);
+e_unmap:
+	iounmap(snp_dev->secrets);
+
+	return ret;
+}
+
+static void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
+{
+	if (!snp_dev)
+		return;
+
+	kfree(snp_dev->ctx);
+	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+	kfree(snp_dev->secret_response);
+	kfree(snp_dev->secret_request);
+	iounmap(snp_dev->secrets);
+}
+
 static int __init sev_guest_probe(struct platform_device *pdev)
 {
 	struct sev_guest_platform_data *data;
-	struct snp_secrets_page *secrets;
 	struct device *dev = &pdev->dev;
 	struct snp_guest_dev *snp_dev;
 	struct miscdevice *misc;
-	void __iomem *mapping;
 	int ret;
 
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
@@ -989,73 +1060,40 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	data = (struct sev_guest_platform_data *)dev->platform_data;
-	mapping = ioremap_encrypted(data->secrets_gpa, PAGE_SIZE);
-	if (!mapping)
-		return -ENODEV;
-
-	secrets = (__force void *)mapping;
 
-	ret = -ENOMEM;
 	snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
 	if (!snp_dev)
-		goto e_unmap;
+		return -ENOMEM;
 
 	/* Adjust the default VMPCK key based on the executing VMPL level */
 	if (vmpck_id == VMPCK_MAX_NUM)
 		vmpck_id = snp_vmpl;
 
 	ret = -EINVAL;
-	snp_dev->secrets = secrets;
 	if (!assign_vmpck(snp_dev, vmpck_id)) {
 		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
-		goto e_unmap;
+		return ret;
 	}
 
-	/* Verify that VMPCK is not zero. */
-	if (is_vmpck_empty(snp_dev)) {
-		dev_err(dev, "Empty VMPCK%d communication key\n", snp_dev->vmpck_id);
-		goto e_unmap;
+	if (snp_guest_messaging_init(snp_dev, data->secrets_gpa)) {
+		dev_err(dev, "Unable to setup SNP Guest messaging using VMPCK%u\n",
+			snp_dev->vmpck_id);
+		return ret;
 	}
 
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
 
-	/* Allocate secret request and response message for double buffering */
-	snp_dev->secret_request = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
-	if (!snp_dev->secret_request)
-		goto e_unmap;
-
-	snp_dev->secret_response = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
-	if (!snp_dev->secret_response)
-		goto e_free_secret_req;
-
-	/* Allocate the shared page used for the request and response message. */
-	snp_dev->request = alloc_shared_pages(dev, SNP_GUEST_MSG_SIZE);
-	if (!snp_dev->request)
-		goto e_free_secret_resp;
-
-	snp_dev->response = alloc_shared_pages(dev, SNP_GUEST_MSG_SIZE);
-	if (!snp_dev->response)
-		goto e_free_request;
-
-	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
+	ret = -ENOMEM;
+	snp_dev->certs_data = alloc_shared_pages(SEV_FW_BLOB_MAX_SIZE);
 	if (!snp_dev->certs_data)
-		goto e_free_response;
-
-	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev);
-	if (!snp_dev->ctx)
-		goto e_free_cert_data;
+		goto e_cleanup_msg_init;
 
 	misc = &snp_dev->misc;
 	misc->minor = MISC_DYNAMIC_MINOR;
 	misc->name = DEVICE_NAME;
 	misc->fops = &snp_guest_fops;
 
-	/* Initialize the input addresses for guest request */
-	snp_dev->input.req_gpa = __pa(snp_dev->request);
-	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-
 	/* Set the privlevel_floor attribute based on the vmpck_id */
 	sev_tsm_ops.privlevel_floor = vmpck_id;
 
@@ -1069,25 +1107,15 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 
 	ret =  misc_register(misc);
 	if (ret)
-		goto e_free_ctx;
+		goto e_free_cert_data;
 
 	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
 	return 0;
 
-e_free_ctx:
-	kfree(snp_dev->ctx);
 e_free_cert_data:
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
-e_free_response:
-	free_shared_pages(snp_dev->response, SNP_GUEST_MSG_SIZE);
-e_free_request:
-	free_shared_pages(snp_dev->request, SNP_GUEST_MSG_SIZE);
-e_free_secret_resp:
-	kfree(snp_dev->secret_response);
-e_free_secret_req:
-	kfree(snp_dev->secret_request);
-e_unmap:
-	iounmap(mapping);
+e_cleanup_msg_init:
+	snp_guest_messaging_exit(snp_dev);
 	return ret;
 }
 
@@ -1096,11 +1124,7 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
-	free_shared_pages(snp_dev->response, SNP_GUEST_MSG_SIZE);
-	free_shared_pages(snp_dev->request, SNP_GUEST_MSG_SIZE);
-	kfree(snp_dev->secret_response);
-	kfree(snp_dev->secret_request);
-	kfree(snp_dev->ctx);
+	snp_guest_messaging_exit(snp_dev);
 	misc_deregister(&snp_dev->misc);
 }
 
-- 
2.34.1


