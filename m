Return-Path: <kvm+bounces-52540-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF4BB066D3
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 21:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD7603A1B21
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 19:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB2EC2BEFF2;
	Tue, 15 Jul 2025 19:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yq/VS7gT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2065.outbound.protection.outlook.com [40.107.236.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961852BDC26;
	Tue, 15 Jul 2025 19:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752607667; cv=fail; b=ftDbLuRzRgtuziZ33ZzpBkzEvJGg6PCDDj1PBwBrGWOU80CmuyEpZJWvDOUZb4RKcGybBDvBMoKF3bX3VIRqzXllUM/RTIJHN8bEKgrZWG6gBX4iDEuPWX+VRiMN0LEzz8MKRiDR5OXMU9rPNZRB+hNf7xTBCPV3z6/TzorbySE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752607667; c=relaxed/simple;
	bh=Rdd6j5H4ow7aQ43PPLbmwmlL3meCvbDLDnWRj9/gA2g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O8hgznWh2Y3NjQRTA6Arm7lCuPJQfIyldU1N/dj7t1DQYjrAA3wwtQCWc7lBc8s3m/aR0vCK6jqXwLxspKzHAuXq/fLfVGpKAA9x65EFl+UB4P4ByyvhuLmv353q2tYfB6TnDegLle/HgfRyAKtJ26z78XKNlhV4FbBkcvCX1MA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yq/VS7gT; arc=fail smtp.client-ip=40.107.236.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dDeqJchCQur2Ry1dvWpCiH4Y9dDqTMQbFdiNxMx1+dO9X3LUJO2qsoTJyrefMBr7TGPm5S8gG4foz1ThrNw9x+Rq5V9jqRYdMyIzHyLyJtu9zQiZ/x9mkcyEpHY+Z7aFKggth4p6EeJrDk+bB8+12rXq07dbIdWRg+EtJ4OJofbte423H2KF0897pn0U2Dkb9yiQXOYTFbFvuD+Cc53aqKRUEOkOHV1Tb6AgyTzPYNSPdS2YmeNWUfbry3wGlUXLUuVrJyQOaasOovB0R0Mzzoxu68wib/8siHWHCUE+Wh08W6RpRQmp1ZyDfC/K+lEXQh4fHukFg/i9fDkbV58I3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vaI4Yt3JQ2fcCv8cdcIfSTcwVEyRQ8n9pIkJdMNnh+E=;
 b=LXVFdzHTZ2LzHZ8shVtbccLsUuy09NAuUHBw6x6Ok9UG3Vh1nO0nJKie6dRTSbDyMnD9EHRAQEqhaYeMiU+Q41y++eGZr16lLfwy0LVmRcgzccbXFzunQIhYs+jhYI4BqGmSBLmAEWFhxcdb8R3uZ+S/wppIFQPiNMw97MuUGM+z65AivqnVTwHdezT1yZRVUoaAL8YdKnzX6j9BisFoM3Wkwq6LVIhh7xTai/ryXpidl9j/hylHXioXQR3R8njXnsZyDiMOv0W08UIoiiA+LDmB7jEITtkepNi176G0nIeeprIuN+T6DO2scaOVy345WgV/zpVyhot6fJRsHNhHWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vaI4Yt3JQ2fcCv8cdcIfSTcwVEyRQ8n9pIkJdMNnh+E=;
 b=yq/VS7gTe2B+uzhmnT9GoeAcWwlSb2xB6f0WUnvLULQSvEZ3CaXgfoh6WAwK+BKLNYTYep4OdPZEwGxzx0CON9+W4B/FaTsF8ScH44i1NIr7NoTk7biZ1tZd68CKZhMnYWx2F5rjhRvgSxY2ixTz1VzwlZvKDRutrv4lVH4X8XI=
Received: from SJ0PR03CA0374.namprd03.prod.outlook.com (2603:10b6:a03:3a1::19)
 by CH1PR12MB9669.namprd12.prod.outlook.com (2603:10b6:610:2af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Tue, 15 Jul
 2025 19:27:41 +0000
Received: from SJ1PEPF00001CEB.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1:cafe::eb) by SJ0PR03CA0374.outlook.office365.com
 (2603:10b6:a03:3a1::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8943.17 via Frontend Transport; Tue,
 15 Jul 2025 19:27:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CEB.mail.protection.outlook.com (10.167.242.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Tue, 15 Jul 2025 19:27:40 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 15 Jul
 2025 14:27:39 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<bp@alien8.de>, <michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v3 3/4] crypto: ccp: Skip SNP INIT for kdump boot
Date: Tue, 15 Jul 2025 19:27:24 +0000
Message-ID: <ef1b21891b8aea8ffab90b521c37ab79d5513a7b.1752605725.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1752605725.git.ashish.kalra@amd.com>
References: <cover.1752605725.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CEB:EE_|CH1PR12MB9669:EE_
X-MS-Office365-Filtering-Correlation-Id: a63fc0e7-81e3-4986-8384-08ddc3d5aa41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AK7kOh1X95T5fulbQZWJ1r3wyp5kp+6kvR4guXb2dQtbgvspLGqY7LkMKUzH?=
 =?us-ascii?Q?DpOdKZRfoXlShaIDJBwoLGuUexOctjGedknCg/w/xyQb7NVRNGdYrr2XOIyL?=
 =?us-ascii?Q?BSrnnqPegp74ZLf9Dvkq1sm2hAub2nbjZ0mZRIlij+tqrQ/5+ZiXH3mAfRo9?=
 =?us-ascii?Q?AkYbGxuJDNbGwCRPaKhwT0kwXwQ26kw4S9p77u0XH6a3oIMd1TQHdERgn5oW?=
 =?us-ascii?Q?4fXRk1rMxJswhS5iuGY39cLNHGF75SB+r4VaBLYSdxrDI7EEFNslPbqgyVHc?=
 =?us-ascii?Q?O31fRoXKgxslu8ia7wguNEaORdYkfkA5vdxxaV6SZ4h0NcfTpngEZgzjPgMv?=
 =?us-ascii?Q?sVeZfSD/hhdb1++0LOogytjcUanuVemWzEmh2WoiMf5RJsYz28w6I5WMwskC?=
 =?us-ascii?Q?TBtRwrqI1L3oTr7Nlm4Mki1uBi1IARZj9fgwA8runruBvHzc7v5U0C7u9rjc?=
 =?us-ascii?Q?Us+fXT8xEJssyrAHO44/k3DH5Ac49LcaCTcjpsSfUi8oTF6VSJJVTzjUwZF1?=
 =?us-ascii?Q?1b9F6i9osPWatbdpp5PN8fpdC0yiC1ZkCcAy3bN8TGqOdHLCgFb4KTRrk6yL?=
 =?us-ascii?Q?qJ1gWJfB6mSZDZ5LnpLu0yCnpbE17ICA/+92A1k/hvmNiveh6L8zrm6YDRXW?=
 =?us-ascii?Q?1Mf+dyeIW8oIVoEzD6hoe03iDzmQcvErqS5e27fvZpCi6VT0OmXtH9UqsqOt?=
 =?us-ascii?Q?XCoxxnTXaWoFLncHHClCHX7MC/RSj+cG/MTPYKLlmq6LwBMMVCBUOssVZH4z?=
 =?us-ascii?Q?omBaugu1NVBs+7hO2qX1SzPabqJixbRg0Nuza5kpV/kpcmFhYmafJqnO5Jmb?=
 =?us-ascii?Q?D3xZ42JKOrMF4KASXZWrlUmMVrcZWFw9HVIPv1meYEtQ7mNEB6HxtbJo07kA?=
 =?us-ascii?Q?VwTodk1zwSc7EcKG9HfU6WP0vPN4apeB/ephYza04+WsjoC8XdYjzjaHoubG?=
 =?us-ascii?Q?iE7uNxAJaOkK+nCFH6sObfenZ+Ociw6/NDOsj8jKLSHBI/WGlN9rf2EXZkvo?=
 =?us-ascii?Q?903XiUNvTUs5lYeWeXmMgZfLcGp4tSdQkbR4tktk+wtUIDjW58AEgo+/bhBn?=
 =?us-ascii?Q?A3yQAAsTG9EHR61BiQ1esRtUuYo41F78pUEP8pAVZTb7QX+1iuTpvVId63f2?=
 =?us-ascii?Q?pQbIVrORzezoqvofsbvwFYvCZll5JNf0hykujjOt1a+h6nrAKmw1rhY/d17B?=
 =?us-ascii?Q?QwnYc+Cq/MwmzT1Hb5PMaQaGl8gvWbo2oh50VBoTLaFRmg9OE19ZDv2mldlh?=
 =?us-ascii?Q?PpbSBbtJwv8a/UFsbPe6wRItMqa1zuldkwQ5cx9YoTP6Kzap6iKiXXMrZ29H?=
 =?us-ascii?Q?IJCXRqJ3bwPYKw6e/QFwHV9BAQvQMjUpg7TihqAB9Ydt7B2G1KCMHysj37JG?=
 =?us-ascii?Q?ZfHltO2B6euZVWvmAJ3ILR0g5HTr/bZ2/6Im0WSn/vvw1vLN9jdRIcb9bZIL?=
 =?us-ascii?Q?WA18zF3I5Xy8Fb+59TgltW7gKa/XTlC8+YY+Nts6ECbcXC8PeiUg8r+Q8kNc?=
 =?us-ascii?Q?KqWI4/p/GTI48h3FdiKE3fKfcZSYoWDTzqbD?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2025 19:27:40.7003
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a63fc0e7-81e3-4986-8384-08ddc3d5aa41
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CEB.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH1PR12MB9669

From: Ashish Kalra <ashish.kalra@amd.com>

If SNP is enabled and initialized in the previous kernel then SNP is
already initialized for kdump boot and attempting SNP INIT again
during kdump boot causes SNP INIT failure and eventually leads to
IOMMU failures.

Skip SNP INIT if doing kdump boot.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 17edc6bf5622..19df68963602 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -28,6 +28,7 @@
 #include <linux/fs_struct.h>
 #include <linux/psp.h>
 #include <linux/amd-iommu.h>
+#include <linux/crash_dump.h>
 
 #include <asm/smp.h>
 #include <asm/cacheflush.h>
@@ -1114,6 +1115,13 @@ static int __sev_snp_init_locked(int *error)
 	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
 		return -ENODEV;
 
+	/*
+	 * Skip SNP INIT for kdump boot as SNP is already initialized if
+	 * SNP is enabled.
+	 */
+	if (is_kdump_kernel())
+		return 0;
+
 	sev = psp->sev_data;
 
 	if (sev->snp_initialized)
-- 
2.34.1


