Return-Path: <kvm+bounces-53762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD633B168A7
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 23:57:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7600F3A3D21
	for <lists+kvm@lfdr.de>; Wed, 30 Jul 2025 21:56:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A5D92264D9;
	Wed, 30 Jul 2025 21:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="37CUkCVw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C667D2253FE;
	Wed, 30 Jul 2025 21:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753912601; cv=fail; b=ZMkKKjh19URcgiwbrTKZoRiMiIcoAdeTtaWJLT++oX31Sfm8qDDFZai4MQo1WK28B2gimoxQj/8tSJincpbJ4j46rYfL+JIhaPSQoecuu29XhFs4HyGQMwN5tT6JeOb7wh1amdEW9HJ0X+POk7/nM4J4Xj0tYtocrFiFiLE2AS0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753912601; c=relaxed/simple;
	bh=zAowIoaqt+tdF/GEqGWn+VlfRq5YA1Ze4y7Ixx8UqM0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nJ3uNd0dZ6ei5RqQl4r7p0pSoZyC7+ox8quj3q8YVyerVwh+SPQnf0TWHOGt7Eptoh1c1FCOBTqkyXZ9BW2KmuOVKew5bFKunIV19DDiKIZw/HPxoJoxKGFZxKvk2KmK76N6C1s1TxGvWRopwBovdU76Xaxrj+1Pjy3SRbzJz5Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=37CUkCVw; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IYGktKY4H+Faacd24QjB2i1MQWpMnPfV+AcX/CE3JDc5CIJen79qXoTxmu1dw/c7jGWwVovZgMMWFpYX3EJ0uV7aDB62MWI9qSQIJOMe6daZqiyg86ZUgerKbca/LB+AbTbAUsB4p0XVtpmMY/VNBgWUDNVZxuNz1Py1vWoOooO2vSg7QOd7d5RoH1S+IEpi4+CJ7Jql2w5zaKpJxEBu1uHser4BATgYp5r2y4q8qwQ/z7MMsXhOG4/goRkfb3Q3RVk6A2IK9ibrwkiBYH9lwZDYdMIW3ml4GW+crswNSd0WvyvU4iyMxcHxPHH6zcw3LdIvq3FXJZJ9dRWO65ZwqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jEP0xQSiAuu1Cn7QtSnps5Slla6O9boP5vbIvIbzVQ4=;
 b=zVJIJKYhz1XtQeAzyV2MtO65/dS/v+JaR0zcxnnyeMVBOKGhlg3zRft9x0UDyWdprU4CID+0HxUemqSJAtAQhVzs3My/ordnhzLOUQv2p2opS5C/wtVsUslr+sXju5WTRmiVTStBqkojZAulbNsfAKanu5mEU4+WE71cWOW8v/nCxGJLMb2hs046DGKOG3M2OWSVElpyr9/IpKY6iXE42VyxTDavV/F+zCwu8nwviOSAitBNacktUHyzq4Ugo9oovd359K7S5RYKh6X/3GaPxdpvxbCYejoEZeFrJv5NVvgO1xzr9WUx7eBxdaSig4biXV/eMAlsTHvPKFQyJgAC9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=8bytes.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jEP0xQSiAuu1Cn7QtSnps5Slla6O9boP5vbIvIbzVQ4=;
 b=37CUkCVwxj3hNvx2ac+/jr1QTn11hmov6BObbxPymDBa55hfVsRrE7E7+qXVQgjA4Zh1rF8hwbs+K0E/rGIvJiOl+LvEzxXIxOo8h2mu7+zACx+0s/14KM3EHtCO88IfuaM4DbARjo0QFXms/1N69f8zxS1gg8UWS0UNxNPIQZg=
Received: from BN1PR14CA0027.namprd14.prod.outlook.com (2603:10b6:408:e3::32)
 by CH2PR12MB4312.namprd12.prod.outlook.com (2603:10b6:610:af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.25; Wed, 30 Jul
 2025 21:56:35 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:408:e3:cafe::71) by BN1PR14CA0027.outlook.office365.com
 (2603:10b6:408:e3::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.12 via Frontend Transport; Wed,
 30 Jul 2025 21:56:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8989.10 via Frontend Transport; Wed, 30 Jul 2025 21:56:34 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 30 Jul
 2025 16:56:33 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <joro@8bytes.org>, <suravee.suthikulpanit@amd.com>,
	<thomas.lendacky@amd.com>, <Sairaj.ArunKodilkar@amd.com>,
	<Vasant.Hegde@amd.com>, <herbert@gondor.apana.org.au>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <will@kernel.org>,
	<robin.murphy@arm.com>, <john.allen@amd.com>, <davem@davemloft.net>,
	<michael.roth@amd.com>, <iommu@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v5 3/4] crypto: ccp: Skip SEV and SNP INIT for kdump boot
Date: Wed, 30 Jul 2025 21:56:24 +0000
Message-ID: <71e80dca138ed59bd2a948d7b79c01c30515d789.1753911773.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1753911773.git.ashish.kalra@amd.com>
References: <cover.1753911773.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|CH2PR12MB4312:EE_
X-MS-Office365-Filtering-Correlation-Id: e7e9923e-4ad4-4971-d29f-08ddcfb3f384
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IXizqRY1EhAJG0rCVBaArstRYbgJPWRa5g2SflTSl4LU5pY9dHtpwRUI9RAE?=
 =?us-ascii?Q?uYvjr5Wsg5E7e84fc3rIwN7Osvhtq9BjD6VDM8b4Lyiq3G5dtNb0hUK/mbBA?=
 =?us-ascii?Q?VFpyqLZRP6f9GvdsnBDIA3o3jayrwWG/vI1LBraFLL4qpvcWZIQk56tmXOHV?=
 =?us-ascii?Q?LPIJDQetdaHF1GgkXh48fnhbiWh+VoQhnUGeMyTMlHBBYPlKNLqgFCavIME+?=
 =?us-ascii?Q?/kxLjNd0QPH9nv9ljHt0OFjdzc7zixtwygd8/4kXr6gCQxEpRAplbvsTV77e?=
 =?us-ascii?Q?1sjmcBdoq1drhIfKcacieyKTIhbsuDSpe29mLVsnMxIdeS2pd4RyqYeiGfP8?=
 =?us-ascii?Q?/OpGt4IqYA4NXyQRNXcXEZ1VothaKsg6yhd7CbuCM+Mbx94en4D5EyXgxhKK?=
 =?us-ascii?Q?QLFecp9CfT8U8uyoh9HX7nTny/etDmet2DiwExjGHOzQ71+diGMiO01d8kgN?=
 =?us-ascii?Q?1QzMAWS6oL75LzVUsrtFtzKurH7fYYNhB/hQjfmE0eNMHJ3nRVJmnEexUsFe?=
 =?us-ascii?Q?Q67pqX1/8NZHCKDJoRSIzsWSOHNAPffq+egd6tzjqV0eJNSMhYJvrA7c/fMC?=
 =?us-ascii?Q?jPMmBbxpFx4I0b6ulvEz/jyQJS0+BVnjDLbv3sqJogYUluYBEDKZVbte5uHA?=
 =?us-ascii?Q?0WWQJiyo9CQyDIGHX1EYCsSQ2KUO98HnS3c1SgVVRrYB4LzjHudjeKQ8wxle?=
 =?us-ascii?Q?u/P7fe9kAId2qF9DksVVk9BDSnRfB0j2QeKD+r9SmryFWFNXc5pSlGfk8HrF?=
 =?us-ascii?Q?B0hOArJT8KJOahzIlMocp6YcqgWwqXFN4AIwI3I4EWiwC9LMt8XmOhOhYov8?=
 =?us-ascii?Q?OBR5j+Zhp/QNImidrWZIlwA3AVwtbRsY7FDuRDjxUhMgfJZQAgR5VnCa6kCS?=
 =?us-ascii?Q?PUzLQNDNIMusWzgORmDQUKjHFnPW6o3jqgzeeBuFfb5oNb9deOGvZkWmz/Ha?=
 =?us-ascii?Q?Nmypj7L7o+6OL7MLOozZLxIiJZD6Z1kp1gIPz4nVQFEZzJk8Hq3CnTH9Bz9W?=
 =?us-ascii?Q?wGyD5k+ax0mf00/FbSFfDIN8znzD5hO4kXrL4ZMlop+DHll3HwhTFKpqsP1l?=
 =?us-ascii?Q?ndG8AN+gEfKwWnaAbtlzzNoheeEGfpO7wYg1Xiv+lIufDgGazp9y46lv4SXs?=
 =?us-ascii?Q?0y3XjDvpXKBauqmUsAn8oHUElzmKQ1nnFGZXe/zMxS5rDZ68tuluDLwrh33i?=
 =?us-ascii?Q?kF4ycxT1b/3OlW4q62qwWJ+UzHsxGsSLcJHPDQAymAWpJVBp9R4K/QJgi7Cf?=
 =?us-ascii?Q?eyg1ycKEJtlMNPKhXWw6/0y9eLEDwi8h2AyvQFfxCZZPfa73Zvtarqm32rXF?=
 =?us-ascii?Q?JSzvMXX4zeQTz1p94rS9kBBihfUTlR7HzWzuWO9nSy1ivBq+ollUW9a7m8WU?=
 =?us-ascii?Q?b+ciiy+fdqDpSAzSBsm3Rkb098CrLtmtkT2Zo4DMN77wd9mL0/xeZikRyncX?=
 =?us-ascii?Q?nIgNnFuHcccYAFagp/8e8QGyBFCItCnJ/RbnsieoPCD47ghctrIoV+0oUb+y?=
 =?us-ascii?Q?fpveX65xVGZovtfV7tV5AYkWufpc789rrpqn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2025 21:56:34.7696
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7e9923e-4ad4-4971-d29f-08ddcfb3f384
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4312

From: Ashish Kalra <ashish.kalra@amd.com>

If SNP is enabled and initialized in the previous kernel then SNP is
already initialized for kdump boot and attempting SNP INIT again
during kdump boot causes SNP INIT failure and eventually leads to
IOMMU failures.

For SEV avoid SEV INIT failure warnings during kdump boot if SEV
is enabled and initialized in the previous kernel.

Skip SNP and SEV INIT if doing kdump boot.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
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


