Return-Path: <kvm+bounces-33888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D1EA59F3E94
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 00:59:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D32C416AC4E
	for <lists+kvm@lfdr.de>; Mon, 16 Dec 2024 23:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7DF41DCB2D;
	Mon, 16 Dec 2024 23:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0AHslTqp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2086.outbound.protection.outlook.com [40.107.244.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED201DA305;
	Mon, 16 Dec 2024 23:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734393548; cv=fail; b=Q0dF3uXm2kdACaoaks1xStVd6DInwBZNEFrvnccPRYSS+Mu6VAluEOUkpmVrkPx1D080fn0Ar980V6LM8vik5wBxLmQmfezm9HuVAyNew13TTkJvjRuhi1ndHSWAjhSIfz8tOqwIwJmJFGdmeAztAIg1UG2ukyoz1XFJrlgFHIY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734393548; c=relaxed/simple;
	bh=X+Tul13C2YnR5knAv/7vYzF3jklUIG51PvTE/u1niTA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FizVJkGw6zrIyukuZsPZJIQts1VDrldEnKLD1I8G4B8lOJTwTS5wGs/9TxKVJyW9OFEGJNMEbA4ke4QVu+IrS7pVi0VSoL2frPjSvU3JwjX1yt4WKq4ZngHmJDQUjY37XQ630OeIucDLedz4CIGm10IFNRiFQkiauEQPS8JeDLU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0AHslTqp; arc=fail smtp.client-ip=40.107.244.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M5TOLr/Y5j4GT3ygPrPWswVaRyCfFsq3Bu620Je+eczVvT3X5PjKPs/tLkWAHsw9gnLxDiccx9KHmEEws67WTKszZ4Qn6ccehYJFmV8dNLp9P7J+ttYaRI7e2iC14Cq+FADpAOJd5IwBTwSInEr92AcFrsiBm+LV9ixL1vsYsg3M1g6D5P1T5ko2rodOqvN0cdifrAif/9x3mypN4j9PaCy5Tqcj/W74Y89mNcvaSZ+xT5ikbAq5LC+taF2aVOJZEShtvt16HJ0IgB3RG8VmeUFLdivwKX5prj8yWJgbzl9ij9aTdbjD1PJfA57Gx+onyDReVgpH1RtVJ/B+BFAuQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pE3ahtKGMBxz5RhM+/fBvQ+08387osZgTaWFX//dHwY=;
 b=Ekkz5bBKgwd12UkuUe78+jPFB58JrzUdbEghVvOMdwlm0/AT8K8TwE0Z8v4LoTvfPiDi1pqeXwhpqLXils0Ro4PvrDYjyJsehg7OvtnIg+Kz25QgClIGb43ajHUckOH75mnTxDN9knChQD3+ar2ZS/Lc/9HVPCDQk/cRsaLMB08UJ22Vw6l0WD6bU/iL6tALdLKlRAYALOcBkEcKYtJXHiCqG80CHrNrEN63Kju01xLkVNmTCm63tX3HysjAqiCV3+ggvzhFF+q7POCzXUc9MJg+C+cQ0F4oKHc7cROAmu1BEHQkDc3VNJbkcBb2gqGLChN0HrQ1U5Tv9clphY7h2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pE3ahtKGMBxz5RhM+/fBvQ+08387osZgTaWFX//dHwY=;
 b=0AHslTqpX678Sx0dzETPjO1XsHxhCoQhkXQSZP4kfKqQm1hwokmoadyQqLv81MOoEOXsa9EJPYpZS+zt1SnD0dsK3Lc4gjS6f4MVLGN26dr5lawM65tlilrWT16hXCsd8rr9kjzCt//w7hHN7oG8ZhYL/NHBoCHnQzQwPBz6wg4=
Received: from SJ0PR03CA0333.namprd03.prod.outlook.com (2603:10b6:a03:39c::8)
 by SN7PR12MB6912.namprd12.prod.outlook.com (2603:10b6:806:26d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Mon, 16 Dec
 2024 23:59:03 +0000
Received: from SJ5PEPF00000205.namprd05.prod.outlook.com
 (2603:10b6:a03:39c:cafe::ec) by SJ0PR03CA0333.outlook.office365.com
 (2603:10b6:a03:39c::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8251.20 via Frontend Transport; Mon,
 16 Dec 2024 23:59:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF00000205.mail.protection.outlook.com (10.167.244.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8251.15 via Frontend Transport; Mon, 16 Dec 2024 23:59:02 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 16 Dec
 2024 17:59:01 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH v2 5/9] crypto: ccp: Add new SEV platform shutdown API
Date: Mon, 16 Dec 2024 23:58:52 +0000
Message-ID: <2313ee66c9d5bdc8aeb6ab86b6f958315e77cdc4.1734392473.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000205:EE_|SN7PR12MB6912:EE_
X-MS-Office365-Filtering-Correlation-Id: f3c7ebd6-2a10-4df9-75ed-08dd1e2d9df2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+yTadvtC0gjjhhBO0LhdB0s6NpiC2qEOEs3XqpnSCBOHohCdtpa9IvYAbwY6?=
 =?us-ascii?Q?88H2Fmkhe7c0YrJFUIudqWcL7ajwOLaK7o7o8EpEHM8DJx1kE3IqTPvr4Hh2?=
 =?us-ascii?Q?P2sYz5kVQiZ425ICkKwgz6YXByNAZTSL92T/zY9TNxaym1ZNlzte3xSDqsQJ?=
 =?us-ascii?Q?xR+97Gk6egHB5ifTbL/0xoqFhWaQRkUw+Z9u3kPgWn/Ljnfy9/4y/JSaW2yN?=
 =?us-ascii?Q?1XLPtBdzyvEts01yG+5rwVET4scZwMqZgoiv5ygKDE9lIr8uDAnfQJzplMbt?=
 =?us-ascii?Q?U/QEzR1DPiTtDP92JcYIEzsfGN5+GdtyeISnRq8T8BHIKMsIpCtYORDa1b3m?=
 =?us-ascii?Q?9dscG2aUK0iTXKB3CZnpWXqpMWocFECCNUb9kMsrzTcYorwNjqvXR0mNVv4c?=
 =?us-ascii?Q?uXYmVBusFGHqyiti2Mgk81gf919Rkn/b6gHTQoxOqC9oH7n8sBgFGA76enLw?=
 =?us-ascii?Q?ZJFS+QyOGUnbZGeH8UGXev+5thXA7js5Rw5PPoIA5BYXBkCEgm5yaDLmaO/E?=
 =?us-ascii?Q?SpB64fL7WoDkt41nW74K02aG1iphlhfojIVAiYCItQrINwcNIpS3n9sAPtWg?=
 =?us-ascii?Q?vy+v+aUsCgXTXSssmTqpH5Ej9R22YlUFFqeLpgVN4O1IsmUtEvPiWAJ5Tc9+?=
 =?us-ascii?Q?m4Amw3AljB1Je683nZbqlDTx1Jgf20GaMcV4i8fpfhvGLKIAAEIWk4fR3o3d?=
 =?us-ascii?Q?akWagyVJyjTV/4qskso47/zGz2ALn0eK5yyj2JBOdoPIhst4qED1PTuzuBV1?=
 =?us-ascii?Q?kSp89v2gfBuXCpKb8UZ1LyeGrt/wmDqfiKTqw+Bd6M5GaMuexsKtTU5Lm4hQ?=
 =?us-ascii?Q?jzcIOl1lp9U65ob8kUmMGoG6mYeVzxtbUfA74eHxngUR+De7UmWE74vOclI+?=
 =?us-ascii?Q?vWbwPeiAvuVywbKW8tBmesl6BAB6STXdsiNFSG8CGF7eBJu9M70V5sVNPYVc?=
 =?us-ascii?Q?PC7Y6Cdb/0fEgGSYggvyOAUIS/wCAEz2ecr6iYbJtHhDIUd3HT/sJfkQK7Ku?=
 =?us-ascii?Q?2RUkQdCeWyiTgQXaz3MmI38dR2csx0hljrwA905SukfW/U2eO2DGjhLm9ee0?=
 =?us-ascii?Q?wsvpwv/ATlYWwMe17Bjjmc3f9ZqmTHp9jvryEvfaaCqqsqVOPltr1P7SaBnj?=
 =?us-ascii?Q?uR15QU6hrTsiX74DfUEQ4xw8I62FB+zqO083WNgcfz7oYK5w+iiRvtYo4YOs?=
 =?us-ascii?Q?5vOy/rjrch52UtGuVHZiV9T1vQ+3eSIC4WiJvBBzuALU23Ho2Z4F8mQFOhhh?=
 =?us-ascii?Q?eLBO/5FZ0rOGxEDOtC4NPWLuKhEYgjFeEyv3aXohs99YewWH8kFvp0yjUhR7?=
 =?us-ascii?Q?nXkNDJK98SXWWeTBluJi+ATP/jlmqOJ7iTa1ISiLEoETLpPv+umsLTUWikTJ?=
 =?us-ascii?Q?i0h2V5K/GyhPtKsv6bScnghrpMmimU8P2ifIEZdUx1tbWHlQuNDiIAWK6nVf?=
 =?us-ascii?Q?58/LxxfIOTnmZ9R3UJtz/C4KZ7M9pxByAeKxHlhjA97/ZLgu8t+/JwrA2+Vl?=
 =?us-ascii?Q?KT1poNghxBFkRGWa4Tq1Y2neo8F6MXucnJYx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2024 23:59:02.7190
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3c7ebd6-2a10-4df9-75ed-08dd1e2d9df2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000205.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6912

From: Ashish Kalra <ashish.kalra@amd.com>

Add new API interface to do SEV platform shutdown, separating SNP and SEV
platform shutdown interfaces allow KVM the ability to shutdown SEV when
last SEV VM is destroyed which will assist in SEV firmware hotloading as
SEV must be in UNINIT state for SNP DOWNLOAD_FIRMWARE_EX command.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 12 ++++++++++++
 include/linux/psp-sev.h      |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 7c15dec55f58..cef0b590ca66 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -2469,6 +2469,18 @@ static void sev_firmware_shutdown(struct sev_device *sev)
 	mutex_unlock(&sev_cmd_mutex);
 }
 
+void sev_platform_shutdown(void)
+{
+	if (!psp_master || !psp_master->sev_data)
+		return;
+
+	mutex_lock(&sev_cmd_mutex);
+	__sev_platform_shutdown_locked(NULL);
+	mutex_unlock(&sev_cmd_mutex);
+
+}
+EXPORT_SYMBOL_GPL(sev_platform_shutdown);
+
 void sev_dev_destroy(struct psp_device *psp)
 {
 	struct sev_device *sev = psp->sev_data;
diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
index 903ddfea8585..fea20fbe2a8a 100644
--- a/include/linux/psp-sev.h
+++ b/include/linux/psp-sev.h
@@ -945,6 +945,7 @@ int sev_do_cmd(int cmd, void *data, int *psp_ret);
 void *psp_copy_user_blob(u64 uaddr, u32 len);
 void *snp_alloc_firmware_page(gfp_t mask);
 void snp_free_firmware_page(void *addr);
+void sev_platform_shutdown(void);
 
 #else	/* !CONFIG_CRYPTO_DEV_SP_PSP */
 
@@ -979,6 +980,8 @@ static inline void *snp_alloc_firmware_page(gfp_t mask)
 
 static inline void snp_free_firmware_page(void *addr) { }
 
+static inline void sev_platform_shutdown(void) { }
+
 #endif	/* CONFIG_CRYPTO_DEV_SP_PSP */
 
 #endif	/* __PSP_SEV_H__ */
-- 
2.34.1


