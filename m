Return-Path: <kvm+bounces-18477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 78C508D596F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:34:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0010B1F2589F
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:34:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729F07F7FD;
	Fri, 31 May 2024 04:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DQSMmF6S"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2044.outbound.protection.outlook.com [40.107.223.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0025D7F7F6;
	Fri, 31 May 2024 04:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129996; cv=fail; b=H0UiqN1aYPMhKSGeiqbzlSIbklczow5cUUXXa/zMr3n9H324SwIXmLqmqCGzYGl7N9bAsdSadfzb2fY/xVhEd+nz6/rwIF3FlhBXuKgFZ++HKSw+TE9f1Q4xVn3pxTvCwhrTpu1O3artYc89IGZA/i3d5Rp1Ke89MSLOcnsbmks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129996; c=relaxed/simple;
	bh=NhjoRkKbsqbDncxFAPYBLTSpqNw6ya6nNTQd2/IhpNo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hXcvO0GFHacTDkQ0ZwWiKw7scCBU5fOL7dOzZKP3jaOh5eaEfemPY0aaCXsoM0JM0/pcpKit9494c+iljMSn2UsRr/AQ5LOjSQq8zRu9eQZBLwgLZb/PITzbSd913wgINB3Li4pDrp1LMWbo6THmUTFcJ0K0IBhS364iRey9rZI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DQSMmF6S; arc=fail smtp.client-ip=40.107.223.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCa15YAY4slRIyiFyazVvjDisLjX+0YsglfgQSGRYARJog0wofJeWYSI5EV0NU3CegL1ZMEBUZuFsExCYdsNzwtXK8Tw6hipV3jmPNznEUsTEoQNpV3iJPZJM7Hx28W4n4mtQjEMsFbl8fAXyLlB06BnHgyzhZO4GnRGX2GsMOKhIlVcBuRC2cM7q6II6Ztf/LYzV13Q/LJLnXuuyweslFKHsLGqCokl4l2P4TTb804YOzYPWerXoG8hjHMRLQnapBkhUsWoPjDk7YBBNQZmXmLSGgyh5MK+FxJmqBSNVgFu2QZgbNwWuWjsG9Q7Ryxv5Db/mGm3Cy6IGCHsH0zljA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o/I6itsDr0fon0lLuHBDsAu/5e/dtkW4j3PsfC78/2A=;
 b=Pt6jViBivIknx0XuwLI8ZsACZ0Q33MmmdFTkguMFqhmt2Xwi9i4T4ynOW0MIQ5TBEFql/waCclfJjJOoyn/7f5VZcUETsa3rXdPzA7RZ76FgD+rGGAwbyQcyl8pE3MFjInkaAqPv5vBUEOG1Q9VZC7K5e8cZh3tVutuD6v+SXe/BFn65Ij6rwx+LFFN2WP8WPFBWq/AYS0cxvW20ncOQuFRCCt/dbs/NGXa7PFULJkiaiMgWDnV3zPgtgFULRxCyq0zuYEuTaFRJKo+PrpEzu/X6BOY+rWqj8ZkQUdfo/prwYyBlpuFT024r98lV4LocZ661ZeH2SpiaRtXsdZhwmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o/I6itsDr0fon0lLuHBDsAu/5e/dtkW4j3PsfC78/2A=;
 b=DQSMmF6S4XBqpt626NDtyX1bm3R55+uC6yJ5cCcU2wH9hYOAZULVe1PRtzDkf6nXH+axyI/SikxQjFcKnKAGMdQkVPLeeydBcDxRq0pq9/W5GwS3B88GRO197qhHqPUX+NY1hHJCSCCLGLHMnQ6ypG3ne1gLERGtRf5l6H1vCFk=
Received: from DM6PR08CA0049.namprd08.prod.outlook.com (2603:10b6:5:1e0::23)
 by LV8PR12MB9154.namprd12.prod.outlook.com (2603:10b6:408:190::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 04:33:08 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::12) by DM6PR08CA0049.outlook.office365.com
 (2603:10b6:5:1e0::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24 via Frontend
 Transport; Fri, 31 May 2024 04:33:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:33:07 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:33:02 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 09/24] virt: sev-guest: Carve out SNP guest messaging init/exit
Date: Fri, 31 May 2024 10:00:23 +0530
Message-ID: <20240531043038.3370793-10-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|LV8PR12MB9154:EE_
X-MS-Office365-Filtering-Correlation-Id: cd766aa1-6e33-409a-0dfe-08dc812ac555
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2oxwwPMsrq1FgRa6d1l0jenwps4WxUcyYw16jXIj9+CmPHN2FSTnoroO7tJ9?=
 =?us-ascii?Q?oI4GdHXS5cImDHnglAuk9ZycteCe5uihwOQEdfC7Rh2EZMdT9+ccfUh79oUI?=
 =?us-ascii?Q?yApJTEDIUYzdwReaKCmjB3bjqfIi3bxm1URWw9tO6HpjsP2VdDHeiG3Ay2n7?=
 =?us-ascii?Q?Thj9vAGqzmCrZpI5pnbsQDtSl2GCkdzYSJSi5OWk7QposHV1kQ0oJgjfpKBs?=
 =?us-ascii?Q?i47Sh9hbBdaef9rnbdfxajsuhEF77HgbiitllcMtePjBoDBUn0FDJ8NJR68Z?=
 =?us-ascii?Q?2DiYyHtc7VBnh8u9RM7wL8+x6/rJbj6B0hj471HdqX8TXxjrRA1qXeezipD2?=
 =?us-ascii?Q?eb224VQ6Rs31bzRFGlD85NvAmDJeb0L9x6p0xyd5KUX2N3dHABKp+Lr8Frh/?=
 =?us-ascii?Q?TlEiteL3sP/nwQy48eRiTLx3tQhnxfz7mkIik22j8iZSdjOkX4OEr54NlfMd?=
 =?us-ascii?Q?jSIv0JjNbKPcOl3/gIgTtbdyuiCDWoAOGxLxPyAOhEw5mOrSHho5Dp8+d/qp?=
 =?us-ascii?Q?X5oYlQgSEJbGEUYYn2W+73JpoKMEFrBAOl+Fl6H9opwmWH6WDVFFayAdrN2/?=
 =?us-ascii?Q?QV0ThU9J2UevmS+ss4XoXMNXoJPzqaxjAWmWpXvmJa2QgBbBn8aG984ig/ji?=
 =?us-ascii?Q?ZMzhGSrUrt4M6hMqiABvK2Z0mOiNYDYMKuEHBaGui+D/rNTe3+BNizjHdyMX?=
 =?us-ascii?Q?0bK5eiIpv5XAZxMvF3g8ivYAYJF8h6lzJBK43cWuCufQeeVimmerL2d8grLg?=
 =?us-ascii?Q?FMk+yxVlXUvGG5BW4h+S/ci2uxgzzu8zu0ri2iv/LXBu1dwRotTFUIqm35W9?=
 =?us-ascii?Q?I9AwOSPgyqM48iAzTXwkjSYO9w2rCPgSqszKk7wO5ZiWh2BKoyytoEJXGBvy?=
 =?us-ascii?Q?PLkEi6of3K4uN6dRq87SEpj355hLuwYJ58/7Rs4Cl76ZKSfc4sKqTgRXzfVb?=
 =?us-ascii?Q?pW6aUkLj1uo4Z8Mb3EwEz4EqvjgIUeolt+Ta8/6oGXKjFLtKusmnTddP55Fy?=
 =?us-ascii?Q?b37KLcjFiQ7IAXoAL0Xi4nxEfgHxPbcC1WOfC1+u+ITauFd0dEb02xWFPyho?=
 =?us-ascii?Q?qo2c+arvPUaHHW/PSMdW8f9Q1LM+dmcnfs0EQFcIOig0kp0P3usH0K3CprnB?=
 =?us-ascii?Q?LqSRALWqgdPRBNlnEUY6IboCajPcF7nwU5kcmYx4DdqnuGpkPM31WVul7S3v?=
 =?us-ascii?Q?ynXTbdmvykyc4Ano03VT5vwPE2OviY0thqjg5HTMtTxcQv03t8pqAPwEZGQO?=
 =?us-ascii?Q?6yT8K+r/4PLz1IBZCwzQkI4AIiR5xDSjHMza3yXhdbThIdPfDeVIUNB9AsRE?=
 =?us-ascii?Q?6oGOV2v0kaKTT/EaHhxF+2Hwi7V07hB9JiqrEjIvwnUTgu+4j/Lbihjx6U/M?=
 =?us-ascii?Q?/tWFffwZmldv5bPR9BBB0LP8xXFo?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:33:07.8281
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cd766aa1-6e33-409a-0dfe-08dc812ac555
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9154

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
index 19ee85fcfd08..0ec376f7edec 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -150,6 +150,11 @@ static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
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
@@ -629,7 +634,7 @@ static void free_shared_pages(void *buf, size_t sz)
 	__free_pages(virt_to_page(buf), get_order(sz));
 }
 
-static void *alloc_shared_pages(struct device *dev, size_t sz)
+static void *alloc_shared_pages(size_t sz)
 {
 	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
 	struct page *page;
@@ -641,7 +646,7 @@ static void *alloc_shared_pages(struct device *dev, size_t sz)
 
 	ret = set_memory_decrypted((unsigned long)page_address(page), npages);
 	if (ret) {
-		dev_err(dev, "failed to mark page shared, ret=%d\n", ret);
+		pr_err("failed to mark page shared, ret=%d\n", ret);
 		__free_pages(page, get_order(sz));
 		return NULL;
 	}
@@ -786,14 +791,80 @@ static void unregister_sev_tsm(void *data)
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
@@ -803,69 +874,36 @@ static int __init sev_guest_probe(struct platform_device *pdev)
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
 	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
 	if (ret)
 		goto e_free_cert_data;
@@ -876,25 +914,15 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 
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
 
@@ -903,11 +931,7 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
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


