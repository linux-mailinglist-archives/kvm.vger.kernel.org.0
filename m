Return-Path: <kvm+bounces-41860-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A2B4BA6E565
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 22:17:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D9CC18836D4
	for <lists+kvm@lfdr.de>; Mon, 24 Mar 2025 21:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BFA61DFD9A;
	Mon, 24 Mar 2025 21:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0XiVYpp6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2049.outbound.protection.outlook.com [40.107.93.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2D586334;
	Mon, 24 Mar 2025 21:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742850858; cv=fail; b=OTjx1k7R10V/xqmHgzRlHrtT++RjciwwCASN3gyHYKR+OTiHH1Ia41xlqREda8Zi9GMTgrfA2j/tQcsWptO4va9kd5wyXD5Tm5Xg26T8cMkeKPOabzXxNbm4UbJZOQyGcUW29S2/pM9G+IfnyQ0E+dn6HCAmwNB8QO10p6xaNIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742850858; c=relaxed/simple;
	bh=qfHJi1AkyGV+Mt8JV6pNhP9DyM2xbxgXLBXy4/3kAsk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pjkvpaCGLbr76Z0R+XrNKcuqzjdKBIJTeXBC7FxlxDT5GP08MBnHOwYRH29ZBqhMMUDUMIvjgpM3LS2TDaKEbQmMaQFqtXy4VeW7/EOsoItfUlbWZDmGhIXUFHsqYAqAudIoZd/vDdF5bpMvv9fnJCRU/b1ZWHiz61svR5DDHC4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0XiVYpp6; arc=fail smtp.client-ip=40.107.93.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g2LwXB2q0hVailVBf7l7nYT2XiACvex9CufHUJ7PUqYEBaIpIAAQs4t0XhOcpvKiiwO3B4KRe/Tl3GeXe8b+MVyYjLaGPuOPiAQ77QlLn5Jx7tRXOMQxymsi0ZFfWEecGdMzDJjYEC99xdU07/O4qr+Ox0egATcFFO4rXM4z0c7qnzbhdFh2ogGnYd5n4E8Py6dnG9IesIOW6xydA2not6DGNRxY5RWsEOv7RR1fkIESweJCZ0Tl0g7BEJdQbg8Of1Q6W1rKb/s90wwc1/MHHjq09iQgQC+UvufmFuzSHqlD8mfBwe53ohn5wHICVm4PRJeVSLS0VjAjAf8XklTKAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78+2mfqJ//YG2LMkTATTVQ4zeGHg08CUTPW70IqfTik=;
 b=fk6LNoi7A9hjx8OKmNWD33YXNEZR5JnulgpOCHQ/Ze53NNd5bJ/+X6cBqXSQ9Iz/rXJ1VKMyEWlkHe4a0A4G5zdZLfspJ/aDDv1ySWKv63BI9n2uzhTJcMxlKrjphoW0SZfnElZZfGXTYwJ0A9U0CZcQ5Q3VXMm0SDC6QoIwlQ5NRXBaQwPIDjE5wLa7K0cq6bzKgrcfAnAqXPT465CAACvVJ0HA1yPcw8gvK7LcSsQTOPqEMU2X3z+u5p9197+U+O13imIR5D3uVhPh84h31NSnGDBUHr5pYEugsX4rj7HRNyI31ey7BtAqxCWfLURJDdpAylNHUUYfatfX2qJWSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78+2mfqJ//YG2LMkTATTVQ4zeGHg08CUTPW70IqfTik=;
 b=0XiVYpp6p0hofuSPxrys4ppcaPycwERqiPxP9/ItbdmkxShAmnK7rcjTepgO2luA9wMHFRuEsKA7L9CPtC4d/dDTn/Yq6lOQVZzbMFU6n9llQ+hgKDE6OhfNOjTpc5vgmZhqWnllyh2IpfLCA5m+IKTzPzySNGwvD3CxfqN1qfs=
Received: from BYAPR07CA0033.namprd07.prod.outlook.com (2603:10b6:a02:bc::46)
 by PH8PR12MB6796.namprd12.prod.outlook.com (2603:10b6:510:1c7::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.42; Mon, 24 Mar
 2025 21:14:09 +0000
Received: from SJ1PEPF00001CE3.namprd05.prod.outlook.com
 (2603:10b6:a02:bc:cafe::19) by BYAPR07CA0033.outlook.office365.com
 (2603:10b6:a02:bc::46) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.42 via Frontend Transport; Mon,
 24 Mar 2025 21:14:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CE3.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8534.20 via Frontend Transport; Mon, 24 Mar 2025 21:14:09 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 24 Mar
 2025 16:14:07 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <nikunj@amd.com>,
	<ardb@kernel.org>, <kevinloughlin@google.com>, <Neeraj.Upadhyay@amd.com>,
	<aik@amd.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <linux-coco@lists.linux.dev>
Subject: [PATCH v7 1/8] crypto: ccp: Abort doing SEV INIT if SNP INIT fails
Date: Mon, 24 Mar 2025 21:13:57 +0000
Message-ID: <ab9a028cf232663f9fc839f48cfcf97694846c13.1742850400.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1742850400.git.ashish.kalra@amd.com>
References: <cover.1742850400.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE3:EE_|PH8PR12MB6796:EE_
X-MS-Office365-Filtering-Correlation-Id: 80e1ef2a-4f7e-41b9-8d5c-08dd6b18d184
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700013|82310400026|1800799024|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yQwtjf9ibkJmCuENFpUhIPcLlGlNjUSSTfLz3OCyjsg0cAzget/+okhIPmU5?=
 =?us-ascii?Q?KnXpYj2R5v+nFfv4Z3hjuiqexFE4rdlDrSY7PRrqdCOvKouVsBmxuPfbE4zn?=
 =?us-ascii?Q?W4KPv8cjibbYNqR/+YvBV6InL4cdcDQ7FNPhHOynwIN8hYA12G+4rrEu3c1X?=
 =?us-ascii?Q?i8w0/2J6hdLYOIIkafA+LU8tvQJBXCX1SgcMfuBN2FfMq/CNZSsNEkQX7cHW?=
 =?us-ascii?Q?xNafzNG9W5y3K5XI4G4mC+OHXII25YiYnxYIfhh/Ut5hObmOgBmuTJb0wD1g?=
 =?us-ascii?Q?kOk/vzGgcXr8bS778dqUwCddM1SiMgrfhRJNVy9qMkdMP7BbUIp8CWCov5st?=
 =?us-ascii?Q?NyRAD/BQpAmmDh8cRT3a9KAVK6UwcrPiFnQta5lZntid0cMiInMcf+SCopAd?=
 =?us-ascii?Q?YncLbpBl/qBvqKqV4gGv2uRhOxIZ70eCWtV3IDdepMv/+bKoy54hmJlr/3D+?=
 =?us-ascii?Q?L3xQZend3fXpcDLYTIE1DHll+hzmutp4gh1o7Di58WE65o4WEihOUNJNqXNO?=
 =?us-ascii?Q?vu+xyMHL+JAH1srzFFtwPAWZbYV1tkpGI5VhYLU8ctcX/y8VcpFyQwB7xVrT?=
 =?us-ascii?Q?qQguTMVcIUgTclJp7wxsGqWHtJ9VJwOCMo+4/Wk4FJu1lvsRKgo+mfymvNbb?=
 =?us-ascii?Q?4K2BHzOsTwgev/3bDFdFrqc6TCBKTbmP1ADHrWCHrimTz8pstQki13veNKBi?=
 =?us-ascii?Q?QcxLm6kNF/elQ6b6fmDd7ZwQ72IGkLi8noEROY4CyBk5lldALrIJq3/MEGbh?=
 =?us-ascii?Q?B9JdNBZYkqlilKoKtl1pfg4G2uy+yiLAH321uXxqQc41ZqtoB/Vmpodei5TN?=
 =?us-ascii?Q?zfbkZ52g5eR5Ox9Pi5445RK/YyT7+rCsrwQK8Sr/DBoBea8hA3KgJag4OyKN?=
 =?us-ascii?Q?FbtJXT40uRQJnrEi7gGh+an7p9iKYsKuB7C2ddGKI3HkQBMBZKfNh+SYZndN?=
 =?us-ascii?Q?YWMIyk12ZOS9ixcLlSSjB+GD8DjyYz4Crn5IKhcf4HkbWhm3/qJEIA8JMors?=
 =?us-ascii?Q?A1ZZKbEucoOoJLmZ6LUyeTPcBj19W++kXINdACG6QoemxNLwq8YYnJsMujJE?=
 =?us-ascii?Q?kfqY0Q9F6EnY/YjLx3RMKFsSy6/wsFNTOoF/LzWfXV9ipQzXiC/TYFNdttPr?=
 =?us-ascii?Q?HnFhwQcKvnaDoJBqfCYjzEZRe4UJhhNbN1lwR1ZMXMDicOd/94L80guSp3oa?=
 =?us-ascii?Q?2wWDiPHh66ypkZ30v2JK90Z2/VrQgHlRTRVClUzozPNo+Y6sKDJUUX5UNwqD?=
 =?us-ascii?Q?RXARJ/5L0RupnpJV76tJeTimLYaRa7AGQcCqykm0Z6QpyawG8Tq/X/BULFhn?=
 =?us-ascii?Q?j4z4Yfl7ARV1Hylxsk9XPEABDwuuLBU5GuskkUoK/bMY69kovrL2Y+nIXUxI?=
 =?us-ascii?Q?jn0d7nGhSm0Ng86bFKPruUz9t+ZhqYxAIKSwWK6KB0PvghcjUtIhgyDhzMT2?=
 =?us-ascii?Q?O6nAvYdN/wHcT/2Htds3txLm0bdjzbK08FYj+kIzTTs23vsPoTafU/WizOWM?=
 =?us-ascii?Q?UesNnRW4QLTj2Jw8TIdj6CSWNYujPSuXtqaU?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700013)(82310400026)(1800799024)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2025 21:14:09.3740
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80e1ef2a-4f7e-41b9-8d5c-08dd6b18d184
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6796

From: Ashish Kalra <ashish.kalra@amd.com>

If SNP host support (SYSCFG.SNPEn) is set, then the RMP table must
be initialized before calling SEV INIT.

In other words, if SNP_INIT(_EX) is not issued or fails then
SEV INIT will fail if SNP host support (SYSCFG.SNPEn) is enabled.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 2e87ca0e292a..a0e3de94704e 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
 	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
 		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
 			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
-		return 0;
+		return -EOPNOTSUPP;
 	}
 
 	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
@@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
 	 */
 	rc = __sev_snp_init_locked(&args->error);
 	if (rc && rc != -ENODEV) {
-		/*
-		 * Don't abort the probe if SNP INIT failed,
-		 * continue to initialize the legacy SEV firmware.
-		 */
 		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
 			rc, args->error);
+		return rc;
 	}
 
 	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
-- 
2.34.1


