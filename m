Return-Path: <kvm+bounces-40294-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB521A55ABE
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 00:11:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 566F1176518
	for <lists+kvm@lfdr.de>; Thu,  6 Mar 2025 23:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1894927E1B0;
	Thu,  6 Mar 2025 23:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="kU0XIbz8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2064.outbound.protection.outlook.com [40.107.93.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB43320458B;
	Thu,  6 Mar 2025 23:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741302631; cv=fail; b=dm2aif8wr0R+R1tOp3sOU41abRgl1BjZ+g8JkxZRcUu/R1sJQ7p5Bx+tOwL7o02pNNcF9OCUclweCw6C5AGtdSyk0uH95+eXEyvPvTVxFF+znQA4CEL6bjaY7t8qzy1grTD0nuRqrPZe2TySb3pyIYylu0/tbgM062oNGLJcWCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741302631; c=relaxed/simple;
	bh=h0idtQKPZLSPA9p3DBpWA8DE+QhQcqieyJQqq0ysLes=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XBy1sribD6OLJ772jiKBeaSE+tJdVtWC/0x9xHVKbLzJ/n9XYMsxV7QMb0smpq8sy3fjKOsS1ZYywB6R6NvSswVw2ISXbEhLT651MFzz1yFvXHfe7xt3JDFDTYqjwMcMeBa1ndTbfWd0RZBgXya6EaJu34VMIss70Gd1lQY/4kI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=kU0XIbz8; arc=fail smtp.client-ip=40.107.93.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ito4n+ztP/48uMS+yCOVmOzvKbDZ1bRcvuPSh0/3F26t+USj4Pzf7rqctRStD/1B69GTbiISEe1xZEkG4IqtGnPWBag4c3trAE/yARnR9pT7kN6ayTxhU0nIvSTMZw7FtQ9y/Q2ncDAtnAb/bujjoX+B/2KUr55EQSQkyfvRHtG8dR2bce6V1A7tnJejATIoSyp5o9hJafS/2PLrcDxlE88PuqU+wdWFUjuwcndR2GgUknn0rRV9VjHLLeuO5RikCKcGxehtgumGek2bRqfaW7kqpkr1pDrmXeHKqZnS3CDngDh80nDfWxHrRKQE7kvVmxPTSX0StxMoMaCP9iKrWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a9S5ixd8ovR+GatCwKB4CaC0KmwPJsHXJagfAeboRX8=;
 b=rueMSdiduzrrYAdN3+v7kcf5TOt/BXGU5kv6mMkS0/Vwv0yc5FIIw6ZAlp5tNcZTI/D6Hes+yM2Pz3cJSNppxUpQTbhx6EtZLmmkrrUFMJESwdUZDKO24+DKP5LzrqY+yeC9TAKUw0AXl71gg2Jb++KcKm4l3RY0nk6lArc58MnNZUtfDIBlFq5GjS6A0bHO2wEBxCnxzfsTgeAC5DwGCX2JcaYPKhaYW528sRdciObgllzO+50ie1ojiOzQK44wo1eIKIkBLAfa6HAzpnne9mXEXLnlDPoTc8ayVSYZ6IZdYLTZsibdHAL0l6mYs/M0ao/BYJBNbbAqPqeeQKdH7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9S5ixd8ovR+GatCwKB4CaC0KmwPJsHXJagfAeboRX8=;
 b=kU0XIbz8H/Q8KzUuaQxg4wFbeJjqvAPg3qodV8SnrwKw/I9HctC5EOG4lJDAfpeY6Zdsa6BD8UnmCZwnUM6jasuybBbGrkq5Q3z87C/3mF3n45zh8y54bzpDIZvtNPUaEfd+eaeeVrg83CFCX9eIPpVPozLYG6/Rsci63zxWFJw=
Received: from PH7P221CA0044.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:33c::14)
 by DM4PR12MB6009.namprd12.prod.outlook.com (2603:10b6:8:69::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.17; Thu, 6 Mar
 2025 23:10:26 +0000
Received: from SN1PEPF000397B1.namprd05.prod.outlook.com
 (2603:10b6:510:33c:cafe::71) by PH7P221CA0044.outlook.office365.com
 (2603:10b6:510:33c::14) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8511.17 via Frontend Transport; Thu,
 6 Mar 2025 23:10:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B1.mail.protection.outlook.com (10.167.248.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8511.15 via Frontend Transport; Thu, 6 Mar 2025 23:10:25 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 6 Mar
 2025 17:10:24 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v6 4/8] crypto: ccp: Reset TMR size at SNP Shutdown
Date: Thu, 6 Mar 2025 23:10:15 +0000
Message-ID: <a7c0c46e76e79cb6aac9adb6362c7f64fd67fe48.1741300901.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1741300901.git.ashish.kalra@amd.com>
References: <cover.1741300901.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B1:EE_|DM4PR12MB6009:EE_
X-MS-Office365-Filtering-Correlation-Id: 52602a3a-b14f-4562-59b8-08dd5d04145e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xqtABCePz9O2ZnJPZq0S6J4CVwm2OM3tVCJPQ8UN/lJ9JNDFSP+R+Bn4Px9Z?=
 =?us-ascii?Q?FU1EFbJIAiGaChAjrfnQpCgztXICPX2bxGDl+FGVA49C+xDvrif8CrHnzalW?=
 =?us-ascii?Q?s0+tCtYWWkDlwy6TBUvtMgBbenXCPAY2q7oAgkLVISRQAsVqRxKbvVUiW98Y?=
 =?us-ascii?Q?JCl3USO0Uc9qiuC/SdvbSe8J/inquBIH2ryhT6Q00PSIvEiMsK+4VriBp7tm?=
 =?us-ascii?Q?pBudfpHQS3N+UAEx1g/DZuxniIxLQvZR1F1nbmrt+9GLHzOdrmUob0X3xgLJ?=
 =?us-ascii?Q?RtAHG+7owYCWkPKoc+bfJM8YYLBSsTyup0Iy9Szqg3V5+g49g3FUDBUrHj5+?=
 =?us-ascii?Q?/DoVBBgZE2Bg4++RPsQHF1UJSh3+aNkscZJPX+89vmu8kU88dQQtZJYvs3dJ?=
 =?us-ascii?Q?gN3e8a363Yx1h6YSTY4teP6kxYSB8ZN2wvs1BevNUKPHvK/kku3P9+0GNj1Z?=
 =?us-ascii?Q?rVjDJc+q9uUv9E6GrqyY73AMnLv9CwPA069AC9KHg3hjHQeICnuK7YvWT3Tg?=
 =?us-ascii?Q?Adh5yK9cqBWeKzxEJl85tB9YO77y5oxyKjKOJH3K7D2bmvfqNvKxSt3cvQR1?=
 =?us-ascii?Q?eJOC9dvALkfgwUGjk4TODrQvsJvQ1e82LHJ3IH/AubA+xzFvqpiHHNWrjeBm?=
 =?us-ascii?Q?MK0ewgpZOSiJ040gkWiayLG8TuTKlBb+VvszLs9IYDtpY+Oz+BeyLMmvgmaF?=
 =?us-ascii?Q?tu/jzR3wB4NZW5GwYO91n7cIH2PRfWdvFMI23A1NQrNzRM3OI+DEREhQJqqL?=
 =?us-ascii?Q?BfMdKPvWKnM2HFF9KwkZoP6yO1bZJN2hQwhSOrB2CgfE3xUqzCXI7eZNmd6V?=
 =?us-ascii?Q?g2fOU7Uj4iiTAYrrPY07hk+snB7NwKLboxX5zclWKQZIwnZRnuZe8Q9iI5jf?=
 =?us-ascii?Q?7A8eNLPg8clHZjkrvnGyTtpZ/NZjTu7WdFvwd4EI6jy7lOoTaJxXqK1Brj9F?=
 =?us-ascii?Q?mCNEef6L3ZFJohBEZv25LDdwbA/ko0lDQbngO0lHnYBMuKb7bd+R/afQ8mpS?=
 =?us-ascii?Q?RMbN0jIs8V4nidg5fUWdGZGwcpxNn88UaE1ImgUbdCrF/FB/QqBEeqWWlMoF?=
 =?us-ascii?Q?Mk8Q+c8J4kewkx5D+UNhCCOsvTkBF0AOOZe8bv4hsM0v9lwNhBRxqvD6XnUG?=
 =?us-ascii?Q?hB67/0Gm85pfT+8rdLgvjmDIOnknK7YdRiDWDd6NW08gem/xzM8sl7Ri1sx9?=
 =?us-ascii?Q?Az78x+Cu/BuA1s0niTF+EaON3t7KNy1Jtt9jvhYvL2ON6PlZ6kX7+W1X3cc9?=
 =?us-ascii?Q?fC5z81JDtXGt9X7bAyhazyTMVASi18iSsthFu+aA1g5GI+cVI3mknc7EHMK8?=
 =?us-ascii?Q?zzQuTDlmwN/M/u4JdG4tETGuvEFLyxOaMaTvL2tYBjRGNnTX3td3oHieIBXx?=
 =?us-ascii?Q?z0w5gtQulpi5SzSxoI9X2IzI+2wU62qqUJBTaU9rTyRt+DS7sgO8z4bDJOP0?=
 =?us-ascii?Q?LHAcN2flS4eSQLrNXQi/r3S0MTflY1xUrbwSGjVYtOQ6fb6LkvzVHUHegbCw?=
 =?us-ascii?Q?h+hccbEK4e0MI3hRPGYOMymv6nTNwTsuIEOZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2025 23:10:25.8520
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52602a3a-b14f-4562-59b8-08dd5d04145e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6009

From: Ashish Kalra <ashish.kalra@amd.com>

Implicit SNP initialization as part of some SNP ioctls modify TMR size
to be SNP compliant which followed by SNP shutdown will leave the
TMR size modified and then subsequently cause SEV only initialization
to fail, hence, reset TMR size to default at SNP Shutdown.

Acked-by: Dionna Glaze <dionnaglaze@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 5bd3df377370..08a6160f0072 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1778,6 +1778,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	/* Reset TMR size back to default */
+	sev_es_tmr_size = SEV_TMR_SIZE;
+
 	return ret;
 }
 
-- 
2.34.1


