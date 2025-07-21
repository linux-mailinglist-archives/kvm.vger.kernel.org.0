Return-Path: <kvm+bounces-53036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C5EC9B0CCEC
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 23:54:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39E441AA75F5
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 21:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19E22417C8;
	Mon, 21 Jul 2025 21:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="00CKu6uL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC5520D50B;
	Mon, 21 Jul 2025 21:53:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753134817; cv=fail; b=UweNrYjIi7Rcdq5gOjKC4n78/5AoUg7svGg/gvTpWGmF1i1MoinwT1xCUWYOhgRQK2j5BAzbs7FDCXAsfeWEbDMGzy40OoSRy5tmjcOshZIHGTyXK6+xPWedkUtAxp0FbNTrmoZxRD4odY+uB9x2a5O1eszwgX+btkT4i4EyXCs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753134817; c=relaxed/simple;
	bh=pLwf8LV5dG+Ovi0XOL1OaqBLshOcInP7jWtA2MnttUI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C3E1YF7gcc92BNr5tL4zptNUwLK+2lb8SQp+dXPc81tnjtz20aWFiclGopE041/5g4k5Ro5mAUHT+OtMpOccwLP14MDai2SDQHKAVzbfbDfvB3Revr1MrVbiT8ftYNVASGqih5CRKy9oLBCpGISOAbNndj9Tjd57oPACjyDqfnY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=00CKu6uL; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fizCm47JHYrg+BBLgBEMPFZiUJkIvrdrMMQFzKLpFwX5vEMjsgPDWRZ7wbul02Xc7iAofWYcX+SQ5qEkD+MKL23kPMGOU+O7SMXw4/qqC3EU5MgA6RwZAvUi3jCSvJYZFvqzeacAHacI5B28doMNeDklgInopVM2Tyt2JdDtAQwNyLYKftCr2oa1R6wU1PwOtIKaq6SMm7CG2KQd6i+L0py4GWIQVGs+WzIOJzgMWBQdwJt1U7JW/dVtAuoMXORkxR0zbi6kITO787sJEOTIZDDk2wI6jbvnVqlkllWg9uX/rQRo08mVMwr6PJUklrfLMdkdgE9OyJurcgpLb3YO0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wMlGVixqPbT3sm/jEQkBjQiIxTqymqdaL4twxSRqqeo=;
 b=WiKuyAbKMmphi6M2xEYw6U9RqnLBVKCkUQDzbd+GR7Wh7lultLGhXCP8bRugCiKzVCWDseJnxqieG73Yg3TiBOTuA7bVxuuHwTNqVl6uUyLSAHJJmOOkaSyA/nSeOK1TE+PefTXbouw0qHRqr1f83WMXHL/PMG2DVHQr4TsufoE5Y4gcF9cNLBfhI5eJdqLrNY25/XPwC5Zekxa8aJUt82UZqUR8Q7MtKvV5DGRGDVw2PYGPUfxCU1lWgLWqMWqprLLL4VV7FqTYIEH0ST4GEuOwBn5RAKjiu2o0ROq4A+Q/vufWPHSw0Jtv+Kw2+xtaWq1BmmKYv6nVXLCNGUf5lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wMlGVixqPbT3sm/jEQkBjQiIxTqymqdaL4twxSRqqeo=;
 b=00CKu6uLQmTl0wCl2cZY95C3SbGTp5oEqzErebVU94BnemkomgVJl2hAGTuRphOYIHdjoJu1ams5BYkucCKWRRjcmdURd1vxnQwtezBH4lxX+xli0xYnGJozfUw3ADR+1mbUQSCHLvnBT3vX/h8WYP9jkt6Nc0ThEvvq5iC7hDU=
Received: from MW4PR04CA0159.namprd04.prod.outlook.com (2603:10b6:303:85::14)
 by PH7PR12MB6538.namprd12.prod.outlook.com (2603:10b6:510:1f1::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 21:53:29 +0000
Received: from SJ1PEPF000023D5.namprd21.prod.outlook.com
 (2603:10b6:303:85:cafe::d9) by MW4PR04CA0159.outlook.office365.com
 (2603:10b6:303:85::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.29 via Frontend Transport; Mon,
 21 Jul 2025 21:53:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF000023D5.mail.protection.outlook.com (10.167.244.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.1 via Frontend Transport; Mon, 21 Jul 2025 21:53:29 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Jul
 2025 16:53:28 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v4 3/4] crypto: ccp: Skip SEV and SNP INIT for kdump boot
Date: Mon, 21 Jul 2025 21:53:18 +0000
Message-ID: <f42f30fc6c2d1bf2fdfc8995be86f1005a66f4fe.1753133022.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753133022.git.ashish.kalra@amd.com>
References: <cover.1753133022.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D5:EE_|PH7PR12MB6538:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a8e1214-ac3c-432e-1cdf-08ddc8a10737
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?63BcNptKXIkEwIa+jT18mNwO/BP1pHm+5JijlUJGLaUr5jNVDHuuftGamDO6?=
 =?us-ascii?Q?Y9yNk5rdambd0XdgF/j4TBTWF6drXEC6Dlhgjs9LqtJeqSY+zFOlbIg32Kqx?=
 =?us-ascii?Q?ohcX137FMBFVNWIUd/6o/KdTE5mT4R9S5FwXxBy2zlfs8dhtqGAnfx0+/9ek?=
 =?us-ascii?Q?nqaqiqzhcIWBS3oXOOUjqgt/x8uZoDPu9YQtL6P/FpKul3SZskOaySzn9Twq?=
 =?us-ascii?Q?hLQz+MhcICBhcc9tSxhAH28ZA/CCiA7yPg1XKCA2H/KMqnSiXHbb8d/F/15t?=
 =?us-ascii?Q?rdkEVrfpGprFIbS7lIoyz5Eh0aQsH8A3qd/XuSbrvsIcjKodbr0iUWLNWXp/?=
 =?us-ascii?Q?L1JPFoy1GjNcK/rIpaWPr7fDs0Kiy0aihHsWdRbv3fCCMyGNqQqiVspgxrdn?=
 =?us-ascii?Q?j8/yFHU8H9fK6cfCzPxHod7tj2zDEllGQr6bhZfAUeOOl/Icw6YEJHF+HAH5?=
 =?us-ascii?Q?Ii268nE5Dwhg2mS9i2DA1c7gh2yXkBkEAkV6CjE85V/QKdTgLzZj+l9DuHic?=
 =?us-ascii?Q?lsD8pC4Rf3MgBNlENMBcjsb9Cg/0HVlrx4NtPUiUlh7/IZXT7YFAuxMtEP1G?=
 =?us-ascii?Q?7S5myGG1CbkNhI4U46ZTH3tmGfFeoNBBdgNSYWqhL5e9K+YAFfDIUmspP49m?=
 =?us-ascii?Q?QhRKtjsmRsm/+xzlgSnBhQrY/ZbEMTaesxcscu1Ubh5dmfvF3OkgjkzeA3U5?=
 =?us-ascii?Q?i0u4kCk3eGq2pk+j1+v/KkYmW1wqTspeCPU95/MmzHa0uPVgpFAYhRkeFSnB?=
 =?us-ascii?Q?tiv9UOA4eQffUnyVyqljXV5MC4ucwLWoCwzkrw6LizJSjjAr5kwTLTESqsB3?=
 =?us-ascii?Q?JDJ1riK4jtGKF5s+cOXEJRtejQv5bmJmF1BmyTGMOzHdq+ARL2OLIXui264p?=
 =?us-ascii?Q?1d8dL9J3V1AlAXbK5s6EC1HZAVVsinBFcyKQmZ/anJ8s8qBYttnHIPZgHnuu?=
 =?us-ascii?Q?vsKJn7s3XcIwz/bj5hMc5kjh0fqcriXeOyntvWLGou55xWXY/imyZIXmq7Gz?=
 =?us-ascii?Q?YgiAudbr+uvJFsXz8QiH5OEP0mBtPHeKkjJNC4cozXLdtLo3w1PdYhBwYFEI?=
 =?us-ascii?Q?5yJL61bbQle+V/hx5R5OuHzT9kM75ZoTheMgc+eLHIKEdb7e1ntdGXMh67oP?=
 =?us-ascii?Q?Efyf09R3Lns2XWfT/+0fDN5dlbajlu/0mCWDLlntguJ2fRHAJ4zSeQgIXBa5?=
 =?us-ascii?Q?dS8E6G5W0FwM19n/pXGRkgkndYDRxqIx0uyM3NY23WohpyP534AcvXzt11yq?=
 =?us-ascii?Q?i7k8RWrqVB9tUQ1E3Zl6HM56Rxu7H4hgIb/a6CaZOtgUNsTcAZhqAHLFYybd?=
 =?us-ascii?Q?1TXaxZhakKok2r3jDi8t2a9ZAGY3fmUR1RRswGxRx8hQCVuK9pNTjjPRPdur?=
 =?us-ascii?Q?KXhxi1na1tC+BJI1eCIB6GyMqkgw/tm15a5ecX2/Ph412D3NKF6QA5/yTzuv?=
 =?us-ascii?Q?Nqcr0Okl9lwcRqlcgmqUstiNs5c+I/AKTWRalFLzJIUFEz7SDGRfzHi5rAvX?=
 =?us-ascii?Q?ugl//WtpJtIVbl3sK+7e2BB6N5/cL/WDXFeM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 21:53:29.1423
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a8e1214-ac3c-432e-1cdf-08ddc8a10737
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D5.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6538

From: Ashish Kalra <ashish.kalra@amd.com>

If SNP is enabled and initialized in the previous kernel then SNP is
already initialized for kdump boot and attempting SNP INIT again
during kdump boot causes SNP INIT failure and eventually leads to
IOMMU failures.

For SEV avoid SEV INIT failure warnings during kdump boot if SEV
is enabled and initialized in the previous kernel.

Skip SNP and SEV INIT if doing kdump boot.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index e058ba027792..c204831ca4a6 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -28,6 +28,7 @@
 #include <linux/fs_struct.h>
 #include <linux/psp.h>
 #include <linux/amd-iommu.h>
+#include <linux/crash_dump.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1345,6 +1346,13 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	if (!psp_master || !psp_master->sev_data)
 		return -ENODEV;
 
+	/*
+	 * Skip SNP/SEV INIT for kdump boot as SEV/SNP is already initialized
+	 * in previous kernel if SEV/SNP is enabled.
+	 */
+	if (is_kdump_kernel())
+		return 0;
+
 	sev = psp_master->sev_data;
 
 	if (sev->state == SEV_STATE_INIT)
-- 
2.34.1


