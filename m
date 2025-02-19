Return-Path: <kvm+bounces-38599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ACF8A3CA7D
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 21:57:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CA593B1AA6
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 20:54:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A12224FC11;
	Wed, 19 Feb 2025 20:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FwrEObf0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2072.outbound.protection.outlook.com [40.107.92.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D1022AE42;
	Wed, 19 Feb 2025 20:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739998426; cv=fail; b=G8gU9dFZbOBP92wnszIRasEMAHBgbfhe+igKqeSBAA+4j7x8sQN9dKOLhIX8SlIc9yMnqhpWtN24TT1skkgdtsbdEDWNc1Hr9xSJ8lyaMocB6KXFvKD+GQeEiRyGvoKtRnunJepeXg1EctgEpga9L9+QZKokeDv8ERKGVtgbY30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739998426; c=relaxed/simple;
	bh=rc0PEVZEPyl5upwRQRbB2iIgu6Md90RXtS/d5UICpjo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NNbpYEXKRNRP4P7YN1d+9RCRIS9UmZrq+mtB70twofMudsrqTu1mBhXrHm6YizCNQtyifNvWToyGzFGLNMRs1YsyGOeLbOe4F3zb3zQhlybw8HvUzymq+59BQyHOsL0aNBcd70DRNOCfKXHCmt8l+FrK7Izv2oYjkPgFrjnzCHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FwrEObf0; arc=fail smtp.client-ip=40.107.92.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MuouIKmJAgaKS+dIAVG5I3U17dp2/fyMz56lnbL8gKHpm+A1bZb7d6p1KTVMi056DFS+SF7H71HBv3M9Doy5o3QtWa8d0uW3eMo/6g8Xq+z7KqPbIopUWeJJa6DYYxJOqY7t7x3XJ7SB2G0bPgqiYPvBTJMtc/qP1UcNzwHJ0EPyK8067AWSAirYWddOBlemOaZGSZ56mu9YouyQCSq3dMhIrSeqmxTqtFOdXdECBQYznnH8g1aeDzWun4ie3hV9aMYMLRV5TM1WT1KNuukTpq6uZr8gsJzrJ/qeYpPpFwxWVuI9t9H1LpGvVgZj0n11xYamGXWNokM2YdA+Y0IYDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CMvHjYc5ynOjQ/EDweMX4f3PwadTvtrXejG+AecteXw=;
 b=WmdhCU6KDwa9rY3OENVGXYilCyz78rYJYLr9jmMx/jSEtEPj56e86/UtYAx+KwdvzRPuuG5T1cxe6tqp5Lq2Gk7xBAc6f6HHn8jNhEoTkcWUzJz3FfkG8a91wZMvQREz1iESzAXyh5JwspcJ5vuzup3JMtQev/IJ/XxQE0MATq1kN/KjVbq9Q11EshFxc8dgfilkhenExXQvoEZ27XNNMBZTCHmrATPmeUAaoFwHhV99uEKNqpso/a7puV79gNKjfWVsQJIlnEXG/c3P176k9pZCrNniN5P1+TV3QMAplcdubRAuQ/QIOCu7/JwmO1UgAXyalwvJaaHc4IWFmjKawA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CMvHjYc5ynOjQ/EDweMX4f3PwadTvtrXejG+AecteXw=;
 b=FwrEObf062//H6WEpzFAPMsQrFNmq7/Yb45jeTOumzIo1cbuowGv+7rUPNxk/50FVOnM/u6iCA7uT/Z124cwHKuCWOZ6WMXYU8r/GdsKym4X7RTYe4nsq9Pl0PijgS6GT0x+D0hMj3l+kTtOImKoUciVjXmCvuqFKbBdEwy5RAU=
Received: from SA1PR04CA0009.namprd04.prod.outlook.com (2603:10b6:806:2ce::25)
 by PH0PR12MB7957.namprd12.prod.outlook.com (2603:10b6:510:281::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 20:53:39 +0000
Received: from SA2PEPF00003F61.namprd04.prod.outlook.com
 (2603:10b6:806:2ce:cafe::b0) by SA1PR04CA0009.outlook.office365.com
 (2603:10b6:806:2ce::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.15 via Frontend Transport; Wed,
 19 Feb 2025 20:53:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F61.mail.protection.outlook.com (10.167.248.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 20:53:39 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 14:53:38 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v4 3/7] crypto: ccp: Reset TMR size at SNP Shutdown
Date: Wed, 19 Feb 2025 20:53:27 +0000
Message-ID: <e13263246be91e4e0073b4c81d4d9e2fc41a6e1d.1739997129.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1739997129.git.ashish.kalra@amd.com>
References: <cover.1739997129.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F61:EE_|PH0PR12MB7957:EE_
X-MS-Office365-Filtering-Correlation-Id: d8c72760-17e0-465f-3db0-08dd51277c9b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|376014|7416014|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tRNGUmPPv5coBME/+2SrJyqOP19ai3jfXDDSaHDALHG8NBQeff+ncvy/E7qb?=
 =?us-ascii?Q?Pcqs8eeSnax46BUyOuUHy9vrO3IWDXqjHUABm4SNlmDZJOvLLi0XPiUvniQw?=
 =?us-ascii?Q?q86+YnZeQ1g1e5ExWgxqm/LGY84aK59aNQNGfy1fAuBmiu66Dnpng3ZHPRbC?=
 =?us-ascii?Q?K4RjFVFFpGYrnpr2GsLiP9jZOLoam3MFdg44qSAHlroz7f8yR1KqI68FByFe?=
 =?us-ascii?Q?ey896lVg21X5MJ+fOYwlyZNAulippx77pWmNUQaicSXozJFZiuSkj0wVITLu?=
 =?us-ascii?Q?pzDyQpBBoa4+jQ6GP63lUPIzkLSKNJrhYzd/QOCTMGIuArcKB1YaVpzQAeYd?=
 =?us-ascii?Q?WcYvml+etQp71zDIOAOD+9aMEuOahsOBj8nByU2K4qltZjKVE7I3Kly6Njfw?=
 =?us-ascii?Q?nlFvyNMoJkzERP6z17313XLzDsZL1hrpJdJl1JHS8a8lmjqdICVbKK/MyiP8?=
 =?us-ascii?Q?V3OTttfJhBdBCsVKRQLx6jq4Y8DiGhshm8+jf4WLi5T1RnN7STPQwd0LpdaH?=
 =?us-ascii?Q?EB4wkZu1cE9NCwcG5+OpRqB0gCDw1wcZ+YB4Z/u8gJQAnTBA+vwO55lVe+VE?=
 =?us-ascii?Q?2Fxx+/3E0IB0dZioexlFOJiEWmT5Jm9SsxSTjPI9oqV4balGCfyCnCBXayr0?=
 =?us-ascii?Q?epCymojrBpVceH/f8Ts5cgHdjkUGB8A20yOdDr8Y6S5Kmm+kG356DOxpqxw+?=
 =?us-ascii?Q?xulecxBQ6qtg7h+LXh6lbccjYMCWve2WKrcbIOyXKE6RMCYX8TnMPWdutid4?=
 =?us-ascii?Q?3uCfZEsfrU5eSkVQdxnBMc2zJN4crrqvBu6dzqeHuaLx6BG7tUJZt17YgAMU?=
 =?us-ascii?Q?DF12JPtfQErPEUkmQJR+i6SV2SM7wffO8CBC8geKQ3SC6EU9jvFylg2hbgTL?=
 =?us-ascii?Q?c8o0C59YjrMBDK4/w0I5AZzxrmPChdoKJ/dP3sG2gjgkAQD7uY9kp+ugUa1T?=
 =?us-ascii?Q?OwPlhlAmyw9F/B6xTer72Dm7xGz7xmRN9m3Dab2kQLozc3fKSpYGcOK3wueJ?=
 =?us-ascii?Q?u+hITck0peSgezd+i6KH0vu/cbWQck+65OZ9HHqeQZ+Wcfr6FfO0YgzloLAr?=
 =?us-ascii?Q?2i5Bvvl0omIICO1bBTpW9HjpyFbCAX84beDDNzy7UyI3YFsoORZvM+YmqJkM?=
 =?us-ascii?Q?NGL27tFBimYJ9d/AoeBSAdB3XvJAQiNrK26I02yLrPyUsI/5TDPdZl6ltgZw?=
 =?us-ascii?Q?HJiTMMLkAQ+XYCjKU9gxNvlecHE8MbbKMyY0pTQvp1+hZWTCHyvwt9jIi3G3?=
 =?us-ascii?Q?DHTijxwTib5E+G0pRqqBkUfhjUgu/8TTwcoiBFPJusWyiGkZjQBxxzh8h/UJ?=
 =?us-ascii?Q?YjVqnt08h7v1vwuHEXXJeD0HX+cG4s/YNL18yq1rm+qIfX/EPlOeCpvz534H?=
 =?us-ascii?Q?UXjtQX5kKTsyj3MHz0/gkEEaaWwmo1GZ+1Af/FxaT2/XjNsS9NDgXLLJpFKV?=
 =?us-ascii?Q?d1pA11gDsf4eM1jxtwWJbOdpcvWjg60RZ0ycgrFQN6eSUtri6pkTQb8I3dRU?=
 =?us-ascii?Q?ko4vXuK1tFLE8ksENvnk2oX39xUTOyjP6+VB?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(376014)(7416014)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 20:53:39.1664
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8c72760-17e0-465f-3db0-08dd51277c9b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F61.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7957

From: Ashish Kalra <ashish.kalra@amd.com>

When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
ensure that TMR size is reset back to default when SNP is shutdown as
SNP initialization and shutdown as part of some SNP ioctls may leave
TMR size modified and cause subsequent SEV only initialization to fail.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b06f43eb18f7..be8a84ce24c7 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1751,6 +1751,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	/* Reset TMR size back to default */
+	sev_es_tmr_size = SEV_TMR_SIZE;
+
 	return ret;
 }
 
-- 
2.34.1


