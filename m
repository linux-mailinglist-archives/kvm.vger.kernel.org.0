Return-Path: <kvm+bounces-33344-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 53DA99EA2BD
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2024 00:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94EE5281F77
	for <lists+kvm@lfdr.de>; Mon,  9 Dec 2024 23:26:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34EF01F63FC;
	Mon,  9 Dec 2024 23:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lYT16ELS"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2049.outbound.protection.outlook.com [40.107.244.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D70521F63F1;
	Mon,  9 Dec 2024 23:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733786744; cv=fail; b=qzbzq66zETVwZC5i6xSUsKr03XurqWqoreYFk8V/RQ5UCSpRR9SrwdIoltoqkudlYhNSFYjVr8QxPqGdVmLpCcZqQb8wZDBk2g6I3d984LEJC04SYUAumnyI9QtNoVks+8V8QS2rfgYaHaOlQlUsbiDS/+Q2pMbt2nXTumvQfDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733786744; c=relaxed/simple;
	bh=i5jU1X56vzj1nFBc7I+Miw+DhGUHikyugO0P89N9wrQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YjJOGfdg7lOVC6ZlI6XWajULOCIY1nDBJmQrUt0Vm1Ms/Nn86lgTjui0RW5B5FrjOi85BsoCPBfzg6Ue2Ks6KpXaJO8dwQnEnsWRoA5iM76+tfBdl9HKuVW8d+5wtqvpGOeZrTbqXvzTmf22osXc3QvOaAryinY/v7HCvX5oZpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lYT16ELS; arc=fail smtp.client-ip=40.107.244.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XWtSOZoNCwcITu897bjBauF71PiJg52/GErzVbcrcf+Aq5VRNyucDoOJR10XLFH9eHH0rRdsJrYzDsJjnxSB6bnC/T2e0QqYHepmYc2lpbOqcUh7LRtYkV69JYDZrqLmyMgofmtCWUkk/dIQ01ge1boSobTg5wi7wylOCnCvMzKOhu+TuuklMmjQmuIpAVhdUURFH4SNtImjnzsfJTA9xyuGWmnzFtpG2ZfvRuy8ExZovjM2l4uWW6v7R+Vnw4OQzag6Qoiqv+qCbfngLdLpPdn7A8qJJPTTs7ic95zKVxgVzOJt4tlGeePVubVW9WpMhEbaBb/j012LiUr6ZYWaLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXBJ7t7MKmDFRuKxWJRhNMkHsBmKAyCkraYottVCnAQ=;
 b=KHOiByA2GwgQMY8d8JMJ95BWEZ8/qtiVcIfONmd8PwdkgGnlWc4ZPznmttsWxdGUV3tZn7WaK2Wyu1CxVrguOLG5j6pqIGrzZSKnW8hBb2WiZzkd1n6zm5J47QOiQUlOFKJGPoH7nVmnlDLJGuM2Q/UxWHV0aiRPV1izVS7BwlAfMjRkKul6rLiUa1+R/NvzgljxvRzZlrMZ2HWcTUM/BTmsb4okJhD6v2oE/mqRDJNVyUoC/JJ3IS60eUV30qVz0talEmne5KcMWhK9vsd39pyl1qBW34bDFpFoYmzD76J1dRXQMcCnEuWMDp/J5RnQujZPnxNDukYJOLNj0LripQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXBJ7t7MKmDFRuKxWJRhNMkHsBmKAyCkraYottVCnAQ=;
 b=lYT16ELSU/RXH6up1ETqcxW9SdPrZvrHTsCGKE7OfBuX1ma932PGhJ20cWGxZSmbYjE1ukpafNwB2e95GuXknJIeBXO/1mHut9VYFEw2tW5Dx6fKSlaG2DX7HzVvKe0UHVz4SuSe9KUiwf7bA9p8hbptmzHT+UPblB+J1lXdTTM=
Received: from SN1PR12CA0067.namprd12.prod.outlook.com (2603:10b6:802:20::38)
 by CY8PR12MB7658.namprd12.prod.outlook.com (2603:10b6:930:9e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8230.11; Mon, 9 Dec
 2024 23:25:39 +0000
Received: from SA2PEPF00003F68.namprd04.prod.outlook.com
 (2603:10b6:802:20:cafe::7f) by SN1PR12CA0067.outlook.office365.com
 (2603:10b6:802:20::38) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.12 via Frontend Transport; Mon,
 9 Dec 2024 23:25:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003F68.mail.protection.outlook.com (10.167.248.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Mon, 9 Dec 2024 23:25:39 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 9 Dec
 2024 17:25:38 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <thomas.lendacky@amd.com>,
	<john.allen@amd.com>, <herbert@gondor.apana.org.au>, <davem@davemloft.net>
CC: <michael.roth@amd.com>, <dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 3/7] crypto: ccp: Reset TMR size at SNP Shutdown
Date: Mon, 9 Dec 2024 23:25:29 +0000
Message-ID: <38fd273759f9dc3d8703634cd921b08296997494.1733785468.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1733785468.git.ashish.kalra@amd.com>
References: <cover.1733785468.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F68:EE_|CY8PR12MB7658:EE_
X-MS-Office365-Filtering-Correlation-Id: cfc4cf91-682a-43df-953b-08dd18a8cb0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ux3kyJfOxhOVKD/HkiM8s6wcvWW7SwoizlJe3BWui4MXYCI594ZJ+SXrvrKw?=
 =?us-ascii?Q?RsEkhrcKtI1Wj0Myi/K4dV+JYfulQbV59CAmP8FD3+mtf6O8o3df/LgZ2oPA?=
 =?us-ascii?Q?aKupqpLoyEYk+VKULfN+7kbPoTAdlt/RDIZSLIH2w3PZaGxps4Rjj8WO1ZtG?=
 =?us-ascii?Q?GbIIqorzYEKu0CtomLdjlbrbHKnkJ7L7NO1GOEYpSF8zFdx8+h/d96wsNCrt?=
 =?us-ascii?Q?rkZIaDcPFO93jck0qOS21+JxfvS5s1VgrEYUcFyYhA915HYIctaPyr+K4LJb?=
 =?us-ascii?Q?hsRAuKpURpu/AlXoP+5zHRs6MU22qZTYGnp9b+IrtbXUuwjJg+6/oK4FG7V3?=
 =?us-ascii?Q?4O/ritm+8p7KWviQkiRRrTtSfJ79+0CtS+A1JFrK4G2qWnRomID8N+iW+24Z?=
 =?us-ascii?Q?TQ/JQRz5laZxnf4zltuMrzEZXXL2zZktCiVHdYqtRo/gNfNlxq0+t+I71Aoh?=
 =?us-ascii?Q?uYImQbmumZj8wao0un1YNKEyXpuZZyMwEGQGW1g1VyzQGVfztbtaKmoA94mf?=
 =?us-ascii?Q?TPGCBEtwxnurZ5ZlYE4zZYcJb/69YXaHfzkIdR912YRMTMzMm03GD9h5i1SX?=
 =?us-ascii?Q?iJ8ACWPYckRuVpQC6LFgEyhSFYuVMlbFF1ry+wgeoWc3DRty3gE6VmSnLxQf?=
 =?us-ascii?Q?wcSPqQTyx97rBHRNvgCDmoP6YQB62nCJrAgRxj0eQI2ASnMKAGsWP+NbXQqJ?=
 =?us-ascii?Q?5IuXbvvXAoNdtxANgnZcy5S0vNfkmC6NLrW3zzJgIPjS8TAqI+iEKW8HAnpD?=
 =?us-ascii?Q?YOy0Eq1K+1tGHbL1zqiGyi7mA6q+ksW60WLUrs+JZLjmqKoq7Ejc8qBfIilp?=
 =?us-ascii?Q?ymF6tIxBwwjYzPuqkHYGIJWOyQdCBVmZ6ciPP7QezXAyZWtGSCvp0OhRuyIR?=
 =?us-ascii?Q?TXmKthmLfa5a7pT8utQjutfuYX9Dtd8qTHODb+ZxazjOLGsy8oPADL5yixuH?=
 =?us-ascii?Q?LCZI00I2FbuTynj6lElJKTw6hI6J72QBDeEYtBcd5ghZ3olgjLh3uoKwJILv?=
 =?us-ascii?Q?doEkBejeQeLETJ5hT6Z0Ow7FOQ57fz7zHwL816GDs/gUWnmu5J/y+AiNuvfG?=
 =?us-ascii?Q?D+5Xo6z8uWEGmfcSb1wLTo69+By5ap7cwRvASgL9yKf1gBRGjpsTkbHD5/5X?=
 =?us-ascii?Q?dQaOqxGB78OlEhzU31z2u5xD0H1i8O3W3gs677r4LFv0MVhaDhS/PXoMqgCp?=
 =?us-ascii?Q?NZFr4q/oRDRNtIO/ENEFmNw3QT2yyQShxS+12zyQu9BdSifaH+fs3wOzlt9c?=
 =?us-ascii?Q?suGFwij/j108R36L2IjHMur/jbiTrDa2NP1RsdwMpbMGfq+1itk+csL+GASA?=
 =?us-ascii?Q?8ZTIymecVNWj2910MB7k/CEjjWXIAC6LKwOG4sDZ33LYgE7xeM88Z8Cn+heg?=
 =?us-ascii?Q?KDEWoOlrJR6Bi0TqJCVFhdpwcqfFt+WK7R3KQ9k68No9Op4cyxP9bLyViePj?=
 =?us-ascii?Q?Xpvj6ARZHBSmVmGjF2rdRx2WAWai6mFtqT8GI1pQY6yfdnlFx7wGZw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2024 23:25:39.6066
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfc4cf91-682a-43df-953b-08dd18a8cb0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F68.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7658

From: Ashish Kalra <ashish.kalra@amd.com>

When SEV-SNP is enabled the TMR needs to be 2MB aligned and 2MB sized,
ensure that TMR size is reset back to default when SNP is shutdown.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 drivers/crypto/ccp/sev-dev.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index d8673d8836f1..bc121ad9ec26 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1750,6 +1750,9 @@ static int __sev_snp_shutdown_locked(int *error, bool panic)
 	sev->snp_initialized = false;
 	dev_dbg(sev->dev, "SEV-SNP firmware shutdown\n");
 
+	/* Reset TMR size back to default */
+	sev_es_tmr_size = SEV_TMR_SIZE;
+
 	return ret;
 }
 
-- 
2.34.1


