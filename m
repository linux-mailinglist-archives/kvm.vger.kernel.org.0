Return-Path: <kvm+bounces-39180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 253C3A44E35
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 22:01:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 07CF717B3E0
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 21:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C49212FB4;
	Tue, 25 Feb 2025 21:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="d+dW8rI0"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B151A9B46;
	Tue, 25 Feb 2025 21:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740517245; cv=fail; b=TurhAJZP6Tw368uiz0L3pSilKf63CvvGJJ+DNWooJs1G1etUSKPjSmWyHACkSF3533ArRi6o2A2a/vLei1iOXoPbzm0/9CyB+I5QPx/H1W/aI+6J0qyK+KV1E3WrO7u+CdxhHjhy85Hl2NySS0YWluUQm0lhJPR2lq+9QBiupjI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740517245; c=relaxed/simple;
	bh=bxu6aHDxurW7WCeciu8PQn22lKV7NeW2rafdMWuQC3o=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WUz9w5wjSLCH2ioa1+Aa9XgvuW3yCU/vMfKGf8UcwTt9s0fLaHhBjdrcQ4NMAXLVORL/A7Zt1Na8HkT8hOO0nYPY2LD7cM0U0hGMGLD/mqMWkF2gKXSL4ZPyDXRpEsfPit3xwzc33tg+PQGC/HAJ2f1S8Qlgmh9g7NtpvFEoUjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=d+dW8rI0; arc=fail smtp.client-ip=40.107.223.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MSLZYi+8Eo8EdLXR4f62GsHfudg7RHTPmbTfANy8dukMZfwi5zJ8jkqrnw0zClWT2CDFf5cluRYx1Fh+dSMRsC2Tg+uCkTQ9005M1qjvkJoZsINaBQyxeOoGrs1UQhvYh/iO9izjpBIy5/1UZzyKjOEdHX1HRaS45knpln4iXogAvF/c22Dadd0IP31BfQGcUx1SUY7T7ZEtXoAe7UHe/tkszBiBSSIsF1ZZKm1WeenQ2w8U1thPb6CjSPdf15I1+qdYkG5SWcWNussH4V9yOnszsO7fXAVmvLjQY9WSaIjKFIcSx9yq97QmJWB1176uWaJ6dKK5WSe1IOaaUrn68A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MqeDz1I+vWNmDjPeeDmgkPG3ekIz/QDE5d1FbJDCgQw=;
 b=Iy9cXqFtu02VBD4vWl0H6LoXRf4/PF3eq8Fl2vtI7GGDtSkYZuoN/Dt78bkRW3w7gPvC3iZeJo7WHs0Zm9FiDnqwH94U0ILVlvoNAMYgWBOZtzX4AXRYHy4pQfLVvJYPiWaEFPJa3IHzGdG41yKuemE9uz221Dnl0R66r7EBLHXdx3cHjugtOXeBdOx4rq1ZbRwX+rPG6GjJXDR5ApaDSRLtiwTF/T2vfmEMheZqbM3Muy0ml0ZkYIbiJPUMQaefeWK7jO5VdZZ+ADS9td83ep3UPUSk5rj4OWOS0qUn54P5k5HxOIh1ZtpsbD7Ynl+/1mO8vkZfNU7/4MaS8+eg6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MqeDz1I+vWNmDjPeeDmgkPG3ekIz/QDE5d1FbJDCgQw=;
 b=d+dW8rI0jrmMiaAX2aPyGABuoYzaJIZtxDaNbDfGDHCJUvtqcDXJLzgr8C+suTkM+dpOoJhbzKqgG163qSelTIcUMfZdvxAqhonnejYVqHoYkBLCpZ5g+G9p1ROc2Mj2Un0DxTBP7/I3qm8KIPvfzaKp4vBzSW0WVNNaxyA/tMs=
Received: from SJ0PR03CA0118.namprd03.prod.outlook.com (2603:10b6:a03:333::33)
 by CH3PR12MB8911.namprd12.prod.outlook.com (2603:10b6:610:169::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.21; Tue, 25 Feb
 2025 21:00:40 +0000
Received: from CO1PEPF000042AD.namprd03.prod.outlook.com
 (2603:10b6:a03:333:cafe::96) by SJ0PR03CA0118.outlook.office365.com
 (2603:10b6:a03:333::33) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.20 via Frontend Transport; Tue,
 25 Feb 2025 21:00:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000042AD.mail.protection.outlook.com (10.167.243.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8489.16 via Frontend Transport; Tue, 25 Feb 2025 21:00:39 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 25 Feb
 2025 15:00:38 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v5 3/7] crypto: ccp: Reset TMR size at SNP Shutdown
Date: Tue, 25 Feb 2025 21:00:29 +0000
Message-ID: <ae532a946106e2ddbc031c0d48ebf2e41c56b550.1740512583.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1740512583.git.ashish.kalra@amd.com>
References: <cover.1740512583.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000042AD:EE_|CH3PR12MB8911:EE_
X-MS-Office365-Filtering-Correlation-Id: a8488425-74a7-44af-a3c6-08dd55df7588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Xs5qGLZq2YXlR3i2eBaam92yfn/sf3ROf98CNQnLKjrp8o9Op7+O92E638yZ?=
 =?us-ascii?Q?bSh2UaF5agAmxHBDs7VFg2IMVz8GB8NFIxCNCpeuF0KP5tFYI5VZtE6qPqEt?=
 =?us-ascii?Q?NCgInL8cQ48w9IV9TX0cXcpVyinq5GXOu4sz5ehVa4j5wUCxQR6gfuoCRU5j?=
 =?us-ascii?Q?+FN05WjVW5HC1ofd2gJBVNrrSz/GhGFHHe8rCYcuDtapOULwCINIGVnLAU+C?=
 =?us-ascii?Q?uTKjEtuhtRq8ncVPgVxkP5F6hHneUvT7pATp8748rRAWk6y+Cud607eR0Vcg?=
 =?us-ascii?Q?eH2zZkyRHeI8UjFuLJ9ZXiRj5p1OgfcxOdMi3wcYZmZRswZSYLxsx8DJ3HCz?=
 =?us-ascii?Q?DANw3QnAnaw8hfRJ9Wk66j6QSb4ScPhh5qGC8IdQ67J5YzGO/UxOZJhMLEzv?=
 =?us-ascii?Q?BFdEyO/56qTzb41ayz+/84GAQDN3qpdnW4pL2qaWaerWl+1Nphn9CnNl7IDo?=
 =?us-ascii?Q?t/4DDSDRVgkm4JcQ2ztpCQjVttyktm2nXjZIcjdNRAYeZh0VEp+5p9AmHiS+?=
 =?us-ascii?Q?+raI7suyxwVl9erUsx9VfZ17sL0kplZ28G6oKVpmMjs/QbCsQjidEhiOxB0B?=
 =?us-ascii?Q?AQ1+MFe/zbzkY6Ygn8d9gsH3IwkCv8Js7AaWJs4Vw3b4Hf9oPGzoCZr8KFrW?=
 =?us-ascii?Q?+NnMV4yLajLj3KHW/fsMFB224MB1YGfWYwlWoWpU+U8+h2yzML0VzjxgKJiv?=
 =?us-ascii?Q?7ot+nEH1GyS1iu/8YxPD284AzeICc3/+ri/TZvLo6pEDo9irIB+vy+Cmz2hm?=
 =?us-ascii?Q?Se+KDfrZW1IMGh2+QLf7izYuvD1OV2GI7C0cx4D5RD2kTZqgLFDutHPHbn2W?=
 =?us-ascii?Q?KpvfktBWla9lJksNninXgoc0a1577llC90BduoFQJGRoTTWzjKSGrwXM6ejc?=
 =?us-ascii?Q?CaPaGHLALZb1Z7rSvjhw9S30n4p+w3UhZWgMlB6/olNRJqQ/f8Mqh9YEdrFM?=
 =?us-ascii?Q?p4XoZ6IAjvl/gSCe79e1xwuO0YZ8K64E04DIhbJkALszuo0CvyDj7OlzGU3p?=
 =?us-ascii?Q?2pArhd0UGQU3JNoIr2/D+BqC0TgNBPkz2zkslkgGfmpH1naHR/5LCtnyNA+T?=
 =?us-ascii?Q?KlcJLsknTnJYoFLF4zLfDZAdNr5Yr9TEaVMR9sK2Nj6snXXdvjG0Ch6XSA8B?=
 =?us-ascii?Q?9meGDwL9N9yzJTYpZNw0uVreuiQXP+PJwS61CQGLRDBs9F6U7/MKAxHXnOIy?=
 =?us-ascii?Q?bQ4WzNxMtVwOceZ0y1trpcaU7moy0r9/3k4CCk4x0Bsew1UG1Bx0K0uLhaD0?=
 =?us-ascii?Q?ijyg6tV9eRbwYKpnnQfOXhvKiOtD6fPYQJO56N06+QsZ+PTMCWrP4hHH+1zR?=
 =?us-ascii?Q?iGByqHH4CepiRP8Quid6OueVC6cYLk6C2rhfu3E++FBWw3+8rQwzuWwpQrHQ?=
 =?us-ascii?Q?7UbpUPFwzyJVRmzwSg01CJF9M7syLCUD1Wk5mr4TJZVIEuoXKKgGibDc/Sys?=
 =?us-ascii?Q?dQBaArEnlcxgoHwFY1HNxcH6cLwZXlXRsQeAtoN6ddH9HPuCfET8/84V4WLZ?=
 =?us-ascii?Q?5Lhv0NnbRsWmGu/nkiJR3gMz5w1lc6cCuB+K?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 21:00:39.2872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a8488425-74a7-44af-a3c6-08dd55df7588
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000042AD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8911

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
index 14847f1c05fc..c784de6c77c3 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1754,6 +1754,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	/* Reset TMR size back to default */
+	sev_es_tmr_size = SEV_TMR_SIZE;
+
 	return ret;
 }
 
-- 
2.34.1


