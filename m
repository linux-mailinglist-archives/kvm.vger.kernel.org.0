Return-Path: <kvm+bounces-33890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A683A9F3E9A
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 01:00:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 40DB018852D7
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B91D1DA628;
	Mon, 16 Dec 2024 23:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Bz6rIiu2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4A01D45F2;
	Mon, 16 Dec 2024 23:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393578; cv=fail; b=GdnN2kQG1MpkxcdR3SNz5//QpgYXOZCslqAgIyBtc5quo8y4k+N7FEKhusG/VLBhIjeUjstuKDPHejuCrF+qH481Ndz9UZB3QiPF7x/bzSZANGJTF8ItS0BGbokhkID6XkSHMO09W0BTmgxmac7QvKfFTO77tEc0rQix7nvjGAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393578; c=relaxed/simple;
	bh=0duPIt7pde62qBFgWC4Manbp7tIa3/7JuniaJjmyW60=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=miOLvjYZJ/BPYwS2O/jNWq8wG7b2wIsLZC3kGJyuen+OY7C29GfaflEDgdWAmJ6+s4JYOhuqfKEYwRvr8+s7uzO6cfIrafMUnUYBuHvoCcF2nxiaSo3DzOmEvJbb5dpi598+GRzB/j9n669vdKS2pMAFpg9iLr68zhO6zGKK2UU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Bz6rIiu2; arc=fail smtp.client-ip=40.107.223.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vCF+bA/D7pP155iR2DytiJj7Bxvcfpe21uqLbQSo14J4JDgGeB/EE5giN6luvgZCkWAuOqRHxPVwSpVfdmQ/KHcEJfwyf12yZHUyARPPNU9pPtBN4EhDWkj5Y91UC9tVzyV1u61EHGKRhYUTLddv56Hxga8IiTQj0v5KRRey92WpKo9XWA7xqfjrNOzD6ySE5WuxDr8uUwXJhjRGZvJt4v5FfIa8/a7v3HKlGeL5H7E1MB7bDGyUV0AJ3NBEbNghDLO17aFUjqVHvLtSiLPiwvB4KefKTWy7SvVjWsBmQis6wzpjgxOsQkBD/aeQRTe4D79H7Dgliyyom4/sJKwInQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pq7l/AAI+sd8lDvQMzzaAAjzwqysM8JSeEe0t0Gmsxg=;
 b=FC39FEPMO1Re/XeWljid+4Ucs5PizDx7uGYJiNi6p4oI9KbEDS56BJ3aCZFOUmHYBQkYjgdU3cTcbYz6k92TgTXC+w4wDXeiHmotY06jZE8xGnnG8O8vkBQY7RyN0Fg0eoxbIevW9zPjRjL3PFsgDIuLgDOUyQp0PN2WnCaTA3FHJMwkKEHJcgzwmB3KzXD86mZmGgMk+VND0BSG+m7zyT+Kr0+VQaJRpAxaTgc/8gaS2DJoBMGh5YkbNzUHkcE6/UemFaKqKjK0jZw7nOueMz0/a6zS6xfzgKCuGXbDZBGEnrYnkN4h592EOqLU+k7Oja1fAklR4BOHi5o/rFkJlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pq7l/AAI+sd8lDvQMzzaAAjzwqysM8JSeEe0t0Gmsxg=;
 b=Bz6rIiu2/Uqsn8l/3+uUVZW/t+H5Uf4Ky1syoFZLwDlXG5qwuTUlYZ+mA28+sCBEwsvGh6UPAbNCjZNXY/5iHmjOcR6nKemnccjV2B/zmsUyCMJmQ7z+w/L+JaZphRNIUQw8tUsuM5FR+ZhsiWMn1WzWblEMTP+TwedsVI5uaFk=
Received: from SJ0PR13CA0034.namprd13.prod.outlook.com (2603:10b6:a03:2c2::9)
 by DM4PR12MB7645.namprd12.prod.outlook.com (2603:10b6:8:107::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Mon, 16 Dec
 2024 23:59:33 +0000
Received: from SJ5PEPF00000206.namprd05.prod.outlook.com
 (2603:10b6:a03:2c2:cafe::27) by SJ0PR13CA0034.outlook.office365.com
 (2603:10b6:a03:2c2::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8272.7 via Frontend Transport; Mon,
 16 Dec 2024 23:59:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000206.mail.protection.outlook.com (10.167.244.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Mon, 16 Dec 2024 23:59:33 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 17:59:31 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 7/9] crypto: ccp: Add new SEV/SNP platform initialization API
Date: Mon, 16 Dec 2024 23:59:23 +0000
Message-ID: <a6e6bb0d16e70be61c1ecb2460c90803b937d42a.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000206:EE_|DM4PR12MB7645:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c67cd06-5a33-49e7-7f8a-08dd1e2db040
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|376014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GiQex63VHTTg9qXOBXYE0EkFM998b7N2LN2iJOeyNvHv0lf+ZpSsrWnoWPwu?=
 =?us-ascii?Q?X3Y5Jv10j3DZ4Q5GSN+JyNfdTRLSZlYp04rWcA922cEnhFnv7WINkL87IRru?=
 =?us-ascii?Q?VDKXyyXjHoK/Ecsvtzwz22XUxBp9DyXVdI8qu3A/2dZoMxtrF43vsK0HJa8v?=
 =?us-ascii?Q?7/kGdEbMRlIyy1wk3+G5oH7vk9rQPrN5GOEo3xvduGcyxw0NLFoLElqMul0K?=
 =?us-ascii?Q?68GaGbP0YXTiKwo37+Oi6f1DfGHcw8GqlYFKvlF9YxHcsXy8iz/TR1PF0Go6?=
 =?us-ascii?Q?+WAZ7TyyiovaisyNb/REGngTtlNpPDDNCRN2ETdBLzpm2C+jtIYxhHwXVZV7?=
 =?us-ascii?Q?WsYWT0HALH02H7uUkKb2zCdPsg18IUu/qu3zAF/LF0DzFS0zS3DjPKUHRqpt?=
 =?us-ascii?Q?yKV2kyqq+YzBO8uWe60G3vNehsQz2h1ftaY2DBPcSXP8xTrWwpjrk3DwEpjV?=
 =?us-ascii?Q?v+e/jE6HG8JH3rTGqkIRDGjfsdG8DvHJvDR7fa4/XRCVG3M8cEA8fPjRgkPH?=
 =?us-ascii?Q?LCIx2xOtkiHl5YMgJJQG8ZqcyK8DpS7UFJwUQkaSB/7jsmnd8gPlw3RESTmp?=
 =?us-ascii?Q?mAWMbxnHP+Ow8VKdEiU9++LHMnMx7q/iLNQVh3aLYaKSNlo5IN2m7xcrG8vK?=
 =?us-ascii?Q?sTku+gj3rFYlji1OPZA4E0m4jQdYfHv2K5rUBq5cyjejUfs8t7hEwWNooUl5?=
 =?us-ascii?Q?bu5himjYMBYs0C0OKnprT52gVLykJiuW9jS//0I6FZ1UdLrfYEVE1zxNEz6W?=
 =?us-ascii?Q?lP4jZwqrRnyI8J2EE2gqx/fapHUSuVTaSg1FyP4t0/WBxEE+96dyZPjjuR/6?=
 =?us-ascii?Q?AsiNgsaREXy6hIjV21pGz0GWOOWwe4fpKaem7nlAlpxXRCD8b+rGXqXxzXTx?=
 =?us-ascii?Q?DGMqkBjVFsvVDMwUA+VksCFDO1QxUr/SJJFBXKSexU5HZM1uPMIzCqWRulqd?=
 =?us-ascii?Q?D5Uf4VWJFwTz2RP4cwtQXQBQWL7KlQGbBfnD27TZ7vxhLAwrZOg1pUf54s2z?=
 =?us-ascii?Q?E8K8Xsf8HzNA1M18az88JOLD57obh/sUI/sdBTVMouF+4TS6rp4BFcqVxJJC?=
 =?us-ascii?Q?FtUSNecWaaGsASGj/Tk5b9aRJAS0+d/P3nuVKUxlplNP/6ZzqLQm6f2MppKD?=
 =?us-ascii?Q?bd0mH+Fn7IHOzZB1OMLL0oyC1jzBXDsiGirxw59+tHLBfi6IiC3JCw0eHrii?=
 =?us-ascii?Q?mciOk4NE70z+nky59xq/7+q/wBaQjDwbCcbQQ8HNJS0IueuC1YYQYmCQSODG?=
 =?us-ascii?Q?RsGH6e8hnXits9BfxSxRo+ndkfNAntfijbN9oYoWXe8UFXw5fLg965+5Ivld?=
 =?us-ascii?Q?5u+DPty63a3jjvDjj6y7rmx/oo0ANKLYuqh79m2cQTa1iukxB+oDR5Urff4O?=
 =?us-ascii?Q?EUOCRZjVPAnzsIX0/y/vtxiCZCMQoo01uYGwkYvf1AV0tfw8EnZGswoqXRjA?=
 =?us-ascii?Q?+iHRqv3D6q9xvHlRlpNNPT0P4si5ZTnF4kWu4mdqGDXxBOAILAqWXQgGRhyx?=
 =?us-ascii?Q?KXW8FTtp1ivLPv4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(376014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 23:59:33.4294
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c67cd06-5a33-49e7-7f8a-08dd1e2db040
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000206.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7645

From: Ashish Kalra <ashish.kalra@amd.com>

Add new SNP platform initialization API to allow separate SEV and SNP
initialization.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 15 +++++++++++++++
 include/linux/psp-sev.h      | 17 +++++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 001e7a401a6d..53c438b2b712 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1375,6 +1375,21 @@ int sev_platform_init(struct sev_platform_init_args *args)
 }
 EXPORT_SYMBOL_GPL(sev_platform_init);
 
+int sev_snp_platform_init(struct sev_platform_init_args *args)
+{
+	int rc;
+
+	if (!psp_master || !psp_master->sev_data)
+		return -ENODEV;
+
+	mutex_lock(&sev_cmd_mutex);
+	rc = __sev_snp_init_locked(&args->error);
+	mutex_unlock(&sev_cmd_mutex);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(sev_snp_platform_init);
+
 static int __sev_platform_shutdown_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 335b29b31457..e50643aef8a9 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -828,6 +828,21 @@ struct sev_data_snp_commit {
  */
 int sev_platform_init(struct sev_platform_init_args *args);
 
+/**
+ * sev_snp_platform_init - perform SNP INIT command
+ *
+ * @args: struct sev_platform_init_args to pass in arguments
+ *
+ * Returns:
+ * 0 if the SEV successfully processed the command
+ * -%ENODEV    if the SNP support is not enabled
+ * -%ENOMEM    if the SNP range list allocation failed
+ * -%E2BIG     if the HV_Fixed list is too big
+ * -%ETIMEDOUT if the SEV command timed out
+ * -%EIO       if the SEV returned a non-zero return code
+ */
+int sev_snp_platform_init(struct sev_platform_init_args *args);
+
 /**
  * sev_platform_status - perform SEV PLATFORM_STATUS command
  *
@@ -955,6 +970,8 @@ sev_platform_status(struct sev_user_data_status *status, int *error) { return -E
 
 static inline int sev_platform_init(struct sev_platform_init_args *args) { return -ENODEV; }
 
+static inline int sev_snp_platform_init(struct sev_platform_init_args *args) { return -ENODEV; }
+
 static inline int
 sev_guest_deactivate(struct sev_data_deactivate *data, int *error) { return -ENODEV; }
 
-- 
2.34.1


