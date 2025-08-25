Return-Path: <kvm+bounces-55632-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E54C6B3459B
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 17:21:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3689A1A8837A
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 15:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E36B2FDC49;
	Mon, 25 Aug 2025 15:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dDXmAuvk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2070.outbound.protection.outlook.com [40.107.236.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C82092FD1D9
	for <kvm@vger.kernel.org>; Mon, 25 Aug 2025 15:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756135241; cv=fail; b=OtL5bVD+8zahXKrxrheQghorNiOdKud25pdsB49s7ErlV1FeIYLUgcqd9fURzJQ+rls3MC6QcMABMI4CCotQtQRbe+lG6BU7jpL4Rkm7RGavYdxZNPdIJI0J/g67DqQwm0lvOQkVH77ENRokVndDZhTPQ+Ht7yR7S+ZMUXuVbaE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756135241; c=relaxed/simple;
	bh=swcR8EhrDmxObGm8Eog+yDoBvoQBbNn8Ovb3aMuWT7Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=og1zfN9K2Ibkce09EtndkKntAl05U66Lm8RZtFi3gd6/teGouKvCc0d0IGwYMJp1nBHDHxrwCqHZTNC5mi4FRATX/F8frdFMYyImmO4lVWlhvpc3l2coE8hEhigFlarPy5XFLFGorRlLX/sEcK5vflLxehcklOdNLZuUigVPgR0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dDXmAuvk; arc=fail smtp.client-ip=40.107.236.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vwWSdQnWU7WwsHrxAb26gEFTu44P/j0VGT7b6PzdUWAWEwboak/iJage0tEjz83wVMHBpBA62mLLtV4LG7eVug7dyQELk7JOJuXHG+yfU/HrR0ckunlHhP9vWYedy3GDd5mJeCJgSrEsi6NccWG4V3nCIrwVksQ4PsBm6Mra4NuOpPiaxfAxGBagsuQq50nKn0z+dua4HVrxiZrf/xIKfu7EAASUt2anAAH2Ak8NHyD9n4Apj3IlviaX2pv8qvTB01jZy2xcxCZd6/Q78qpjG3ZEYeY35vYxgpb1P4RwsIeF1zxkgIm5ELw3xw1MKXA1I1Asm0jyJ16qChpE0rTbig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k+0cp8MnFO+rW+12Hv+Swxc1sfiO0nyTPH4U3/XWphI=;
 b=LJxaVvN+8b/IiUr9nXfDPFFu4lHLtk/+ETKw8xFW8Mc6BJFGoJ38xUz6C5lCBAW1qYCJvctv5+o4qF3yglfIkZFRCj75awLkf1U0xgPUcAg+dHVaB+Pp5vpCt8A0UhVZHqQOmy3wOaAaFpYjfM+i3G5xtQI8P0q2DsE+MP4mSoyPd7SD/uVY9jTXcnYnFmFqUBeqP9inJ/WRxYD/mvq/4T/rWBownbiZTnXjuXSWsl0uCMzvXdxZAc6B9pnCsXpHbZpksK+Hhp6fkNE9x0ODNbgiG1fny8eBIinUNuARMdUt6XHeppl21l5c69Q/q9xusrK9tQr/DCQGB4os2tY3GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k+0cp8MnFO+rW+12Hv+Swxc1sfiO0nyTPH4U3/XWphI=;
 b=dDXmAuvkQZtMudjHG342LVXq1hf1dmto1jlnlufIGcUrbQla3/L4MpNaCcrWmj+me8j4tAvtzGCRT3qsd+p6DAzKhtZ/Yf3KPDMCkQkUtvLJth4yPVDNSdW8PnAT2j9JM4kOIESVI7rA7sOHzzCAcz1RNrD9Ogj52OKuLs6VQZs=
Received: from MN2PR19CA0058.namprd19.prod.outlook.com (2603:10b6:208:19b::35)
 by DM4PR12MB5963.namprd12.prod.outlook.com (2603:10b6:8:6a::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9052.20; Mon, 25 Aug 2025 15:20:32 +0000
Received: from BN3PEPF0000B06B.namprd21.prod.outlook.com
 (2603:10b6:208:19b:cafe::1) by MN2PR19CA0058.outlook.office365.com
 (2603:10b6:208:19b::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.15 via Frontend Transport; Mon,
 25 Aug 2025 15:20:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06B.mail.protection.outlook.com (10.167.243.70) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.0 via Frontend Transport; Mon, 25 Aug 2025 15:20:31 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 10:20:28 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>
Subject: [RFC PATCH 2/4] KVM: SEV: Skip SNP-safe allocation when HvInUseWrAllowed is supported
Date: Mon, 25 Aug 2025 15:20:07 +0000
Message-ID: <20250825152009.3512-3-nikunj@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825152009.3512-1-nikunj@amd.com>
References: <20250825152009.3512-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06B:EE_|DM4PR12MB5963:EE_
X-MS-Office365-Filtering-Correlation-Id: a7a02269-8e61-4e23-a718-08dde3eaee5c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iIpHgrLTASJvoQNHGN6cNeYdzG0d+DSMgkF2SBaZuwSvMlyRwa1eSkEe9Vwy?=
 =?us-ascii?Q?w3apH07D4AAQ730iU1KMDni1B4QkxqNb3xIfriRRrNzK9kJkiMoiOK7pw2HY?=
 =?us-ascii?Q?k/sCB8m7QIeTqOM6T0p1XRyymVhjzS5j9JwBmnOFvX/4iChjUpO5bbIXt1oJ?=
 =?us-ascii?Q?M2sEypZ24NQwFKcXUUiZHFlw5Z16zizCX5580chHbpNnVN7mUlrVSrYCSM6T?=
 =?us-ascii?Q?DchBVWFddbxYHEN7YfNQ+we6+CsHqVOF7LUbhMndTia5s27e7UQfkpVdOrbM?=
 =?us-ascii?Q?RFY5fITsCVgdSf07h2wXppjzRJ0XkwzHnQNzlTharnS5JB+sWgUPZWO42crr?=
 =?us-ascii?Q?5ItAEnCtANcKqUTv7kXXHkJ1/UTXBLkn+vkIZXpq/xkaJQArAHU+u+/kA4N/?=
 =?us-ascii?Q?DXDK/dBU5fCxEEqQnEmevnIrFkz0JkSQewjWzjsZrV4alrZviQlPFoEXQGEh?=
 =?us-ascii?Q?LKbvAEYFDdsUMpQYLAlP8yKkZ6Gf45pYGjcUDrdydp53h8Vzbi0GBFaLHWiX?=
 =?us-ascii?Q?93keY87ECBGpKZr1Wyu+tjuOKt/A1JVwFE4l4p9G9wcCwjIjBlu7UhYggLV6?=
 =?us-ascii?Q?RSVu5TpOzUo5TAsbAH783v1N4K1sSKz7p00TeiRcfDk9rY/faQDOV5eXMa0Q?=
 =?us-ascii?Q?/iPLFgssrHlDPkwAhLy2TkiBRkSRkZqLrsWk7rsdIL1RpXNdE2fVKWzEdh+l?=
 =?us-ascii?Q?51qIkETa30zy4SErWEQMNZawUupx4i2UW5twqgNlZzJBLdEOdYnKTAct3ale?=
 =?us-ascii?Q?UNZyiyfl6Eqp88I2jOTdo+oDxcAZyku5NPt3gUjjue5NQvgYKup8ZFqn/+sK?=
 =?us-ascii?Q?EsFmbRWdLCyGU6JkZpKKyLsh912AL71HBekekiwrVA5mFp6v7PfQ9OSZzX1U?=
 =?us-ascii?Q?R5jwjpEHyMC04hiLjP/Zv9tc5d5hiY3Qd9we2MGdpz5axfyUeUXrb1ygaE4H?=
 =?us-ascii?Q?X3jbnDCQIwnLbzNIGB1qmBpSZInlMSBNndZeJiXTZDPq3QImaoWhmgmA7C96?=
 =?us-ascii?Q?oFmG6xJKJJm5OOKSCGWG1qgA/4j4ir9J4OQoO191/N3MWAyHzdARn7o2ifXA?=
 =?us-ascii?Q?KXdbPtpEfxz/16wKyx6la9OSZwVkUwWThctxUTiQWfj/S/2l1zi+DnwHQKLD?=
 =?us-ascii?Q?sc1iazBGG5T+G6svNuYUVppbmDTdiS/UQYnBitRzL57OOpxHwa5DGH/96z0n?=
 =?us-ascii?Q?K30493w9hUVPRB4tqmisSoIK/OY8VC6VasjWAhSUutSzAF4WkVPp1c4SGA9S?=
 =?us-ascii?Q?N1/NDQRlhNzCuoamVqPfEJS+xJ1LsS0ugeml0bIZC0eDhwqh2qOghhEP1EkP?=
 =?us-ascii?Q?evHEyjhrFYX5VFyjDwCmqdzitIj9rFJ09drdmqCfcIoJAJW+rjLg8vwuMh5n?=
 =?us-ascii?Q?EPihomVB4IdY2kmJJ7UQ3V0uilad0AwqTOCe1HUpuQPFJ0RaGmirwwJC5Uze?=
 =?us-ascii?Q?J76KuUe+ujTq/w5zEX/gqrVjXeLG+ZZ+wB9SbK+qVLIVgw8VqvA8KDiz/UM/?=
 =?us-ascii?Q?DTuiN4AOtp+9qiv5yYRsuYaWxqCB/03O2gxm?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 15:20:31.6942
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a7a02269-8e61-4e23-a718-08dde3eaee5c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06B.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5963

When HvInUseWrAllowed (CPUID 8000001F EAX[30]) is supported, the CPU allows
hypervisor writes to in-use pages without RMP violations, making the 2MB
alignment workaround unnecessary. Check for this capability to avoid the
allocation overhead when it's not needed.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kvm/svm/sev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..c5477efc90b9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4666,7 +4666,8 @@ struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 	unsigned long pfn;
 	struct page *p;
 
-	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP))
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP) ||
+	    cpu_feature_enabled(X86_FEATURE_HV_INUSE_WR_ALLOWED))
 		return alloc_pages_node(node, gfp | __GFP_ZERO, 0);
 
 	/*
-- 
2.43.0


