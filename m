Return-Path: <kvm+bounces-20252-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB3A9125AF
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:42:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 467E61F24763
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:42:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B99715CD57;
	Fri, 21 Jun 2024 12:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bMvGLNbW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2055.outbound.protection.outlook.com [40.107.101.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFD815B558;
	Fri, 21 Jun 2024 12:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973587; cv=fail; b=Y2/LCk8aIA5HK2wyJ4z61X4AMx4w1a19tX4amcj+wRyhLZ7KUtazBF3oALYQcXao5lBJzIwDm5twKaVEpS+XzjBZLY4FpcRwYJtk+7fXQFiGhcvHwmuS1WwNW3u6Our3l45FTya0CW0llj+uI0Lzu9A4y3niSvnjcMmGvxCehuE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973587; c=relaxed/simple;
	bh=NraT8e5d4Mi8Px0VzCjkHpmEBL3XQcCv0FiowaI4NKg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OBTLONs48ifNNZKfHxc/WymVquD/+eysCBVpcvbaQQrNg6/ddKjcxoEXkbJ8IFbOB686APK/hFp06LVPCvcZi1U+rfENCmxX2SqgXpWNOU5JEcQ99LuSyTDP7v/8Oo/bPEmrgibHKwQKErWtEpPqDio1jyOaacF4RfwDnbKQdhE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bMvGLNbW; arc=fail smtp.client-ip=40.107.101.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eRJ8m/qt46njt+i4QYuElRIjbySh49TWwdlx+F7VLZ+AqM/ItLygte2LIqLeSmNhD51hTnNZflRTgY9evuBduisvwoj95RI/VplrHulEqRp6ELnI34k51H3c2ejDKaZkwk1yzbzy1xfuQrDyE2kl9XygZ9hC4jOWQy6XUK01doBcVOKj5HaPVm1jDYGwh5EwenOOkd2kI1Ryz9EzqwSEeAmvSVzq9XRvKf2rCCiQQ89W7wwhQoq2Rwpt4uugVhiKyz2rrC7t0qFkeZSLx+qS8G8GcZargCQjrjL2GCYa3juVIzfy40oKU7uoWLiiZwWa1AeiYMZso5tYL0vusT60DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FkeG9EOfc+HMDARCiGLMQy242FCTjXuoXr0l/l4t9bE=;
 b=RyzNte1jdHzfHJkoQGE8VRNYNimWDfyeHVGGLdLFBZ0MSlFMGIC63LYlwFm1KRFpHFn67vU7CpQxen2xb6K2IUoGQ9onkGm8b3WH9hsDMagyFGbjdJRQga/oIIL6n6T5tgduT670uLXDGBuOnWjNMiGfBuh8ADJIYFr/vKXvPGLIwaFu5WUknnfn5+2diCbFwf5fwqkESj71SSiS/idfJ+i2bleIn+Qbvq5er5tqsGcEyFvKPmCmkyV/CAlCeJfgofEmG1xLtSGnpF/0e/1M/akGMKJS4Nxsd83hmTp4o+IjOeXBFEuYq6Vs8ySYZ6UTwH7O4V/QhmBQvKo/iqROgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FkeG9EOfc+HMDARCiGLMQy242FCTjXuoXr0l/l4t9bE=;
 b=bMvGLNbWRBfxDfqGBPACdPfaLPVxUp7/scfuRGY8yXr1SZ3JFxFke8jBY7rmQJUV/pdGXq9QfI2S/Q/fXTDFAWhZ7/skVrt/Qcl7/ly2ByfuqcsqawBZ9SHsSremuGDHSbyjgr/JxBUm1ygZGCZJKO0OrlqRF6id5lWJfU/V17A=
Received: from SN6PR05CA0021.namprd05.prod.outlook.com (2603:10b6:805:de::34)
 by SA1PR12MB5616.namprd12.prod.outlook.com (2603:10b6:806:22a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.20; Fri, 21 Jun
 2024 12:39:44 +0000
Received: from SN1PEPF00036F3E.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::b9) by SN6PR05CA0021.outlook.office365.com
 (2603:10b6:805:de::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:39:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F3E.mail.protection.outlook.com (10.167.248.22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:39:44 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:39:40 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 05/24] virt: sev-guest: Fix user-visible strings
Date: Fri, 21 Jun 2024 18:08:44 +0530
Message-ID: <20240621123903.2411843-6-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F3E:EE_|SA1PR12MB5616:EE_
X-MS-Office365-Filtering-Correlation-Id: db7193a3-7eff-468b-8b01-08dc91ef3a53
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|376011|7416011|36860700010|82310400023|1800799021;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1HKzfEwqauadKFUT44gjufO6nryz3ns+ro1j8S0V9ySllm/BCh8qRE0+nv9W?=
 =?us-ascii?Q?JOar2vXhmOrr5jhBUzQRdVGVdwosO6h/t9jf/AgJGcJqHYoQ2NpN7x8wyTmq?=
 =?us-ascii?Q?IJHTYpdmuVzUwkkj/QfdsCXJzBr+qibzva5+YXCoUroxxxpv0sa/ND4+MfwD?=
 =?us-ascii?Q?Pl1hh2tOmFnJQEGtdp5PGarpPt2rQPv1EzUXpBWY1eOuo4O2u2qgfPJ+/Kkw?=
 =?us-ascii?Q?MTZRcYr7kMNFW/i+XN7GCzgoZ2vQ59hV4pl3R+4c7GlsmBqMYRJKrd+RqzN3?=
 =?us-ascii?Q?RFtGxkXWgzGs99CHpnfN9HtabZDlzz8ayu4esT3MqWxqmGwHDRWOK0z0A05t?=
 =?us-ascii?Q?QpPc6aw1DzWTyheZjqXxXzU+YTKhmQifLgbZ4gfjw1sD8e3olXJIbf/gIdJn?=
 =?us-ascii?Q?+mun1xeJtXJD/RsbPXgyZXgO2vwIYCTfbwPZnSlRkL/9Hiq7xarxpJ/BOBsE?=
 =?us-ascii?Q?qO6Hfw29hKOP4C6loc/eSyvjm9wK8zmYallp+G2mqrfvoQHi5RzMBWrGcN5r?=
 =?us-ascii?Q?oOi/XF+dubXZqxWyoQqipK/29UFS7iaGqhEII3DdAmXSbU4/XQv3oqXTne5a?=
 =?us-ascii?Q?SgVTGP2o6yMv7HqNzdpRJ6YdPjSz69pFbRwxxImDihYv3/PT9nUZjDocLOnW?=
 =?us-ascii?Q?ndatI9KaXI24vg6256IUCydUwvhrzMfE3axZw7Ft02sYtZ/Itw5DAwZk1wZh?=
 =?us-ascii?Q?Z9jNFlQmYwMC493dU5Xj8TwnnKzhXiTtU6tgsO/TDkQd5EGriXJ4rfh+WDcV?=
 =?us-ascii?Q?H6nsOHGLmZFJhuiwzCYsSTIjApQzm4GyCct8PmjY13BZZVENQgduPRgu8O3J?=
 =?us-ascii?Q?rsheVrIEx+t+Xf2Bmhd7xzRWxrgspddtmwH+cJYgg8ewoy/k/4Ziymg6u3PJ?=
 =?us-ascii?Q?AfjR4I/LAZRYZvJLJzD2LOhRkApz70eBxG0N/u5wInmj2GJ5WXaIZda++ZAq?=
 =?us-ascii?Q?1eEf17t9R4Nu6YHB/r/BTIrnxp9gs18Atg4XO3dtbfvuNRwI2zBiismpy/1Q?=
 =?us-ascii?Q?xNnCD/ADKmEkpLvr7aNI2VLCe+bZrpSQINoUqDO/sLx+xOqnkM1yAFbqmQF4?=
 =?us-ascii?Q?HqZQK48j7+uSs3pfPNctK1sW1iwksh6q1urvp9ihLZbyEtX8v5gXrp9gcqIG?=
 =?us-ascii?Q?UXq+S3f8AmuODS0lTqmRxJAkJMNqlMbZD7cfoTGOEbbFhnB8aJ22PxMECzjH?=
 =?us-ascii?Q?uxQtIqE0z3aMcIIWoUz99lmqJox4fV7dUk2qo21hh0NJS8nnNc2tHnnBUgYI?=
 =?us-ascii?Q?mkdmmz23E5gzPbcdsYgc9ZyAHluPtkNxTMoBPRAEucoJ+BWTebaQvk4pHwCs?=
 =?us-ascii?Q?Xz0x7D+ucVR4KLllVuCn+C8jTmF7Hrg3xhVEDsC1IxpL/pXwkIo2G7Bdkbjw?=
 =?us-ascii?Q?kkFQ9fMd3b5GntX77RoxnJhXUTydVH0/sIGPhqiCSdbi1QYx6w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(376011)(7416011)(36860700010)(82310400023)(1800799021);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:39:44.0438
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db7193a3-7eff-468b-8b01-08dc91ef3a53
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F3E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB5616

User-visible abbreviations should be in capitals, ensure messages are
readable and clear.

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 85e3d39bd5a9..61e190ecfa3a 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -105,7 +105,7 @@ static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
  */
 static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
 {
-	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
+	dev_alert(snp_dev->dev, "Disabling VMPCK%d communication key to prevent IV reuse.\n",
 		  vmpck_id);
 	memzero_explicit(snp_dev->vmpck, VMPCK_KEY_LEN);
 	snp_dev->vmpck = NULL;
@@ -1040,13 +1040,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	ret = -EINVAL;
 	snp_dev->vmpck = get_vmpck(vmpck_id, secrets, &snp_dev->os_area_msg_seqno);
 	if (!snp_dev->vmpck) {
-		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
+		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
 	/* Verify that VMPCK is not zero. */
 	if (is_vmpck_empty(snp_dev)) {
-		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
+		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
 		goto e_unmap;
 	}
 
@@ -1105,7 +1105,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_free_ctx;
 
-	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
+	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
 	return 0;
 
 e_free_ctx:
-- 
2.34.1


