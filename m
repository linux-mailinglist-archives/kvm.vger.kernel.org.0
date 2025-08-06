Return-Path: <kvm+bounces-54192-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68BE0B1CE0C
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 22:50:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24CEE3A9E52
	for <lists+kvm@lfdr.de>; Wed,  6 Aug 2025 20:50:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAABF230BFF;
	Wed,  6 Aug 2025 20:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UNO6mcXo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A0B22B8AB;
	Wed,  6 Aug 2025 20:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754513189; cv=fail; b=GjzHC2nIAINsZrfFR/9Bz21zqktO3thIxseLWkacbPZb/iyWsUBqHFyNdntdpm5kPQeVE5WVHHabsLcxgc0Crw34StevWt+cNxIN1unF2K2YNEr2n6Pw8hJvA++kWezZR0OSbsDK+N0SXaLn2eALrwUlDnlRsRCawWJS0Q0iE3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754513189; c=relaxed/simple;
	bh=40ytrx1c9oHzGV61S8oOixnVt6siySHGhZw7WaKhWwk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gVJ6R3fc2m+HdYEKyeJvUEAZf/aNb3U2E9PLiK94St2paVTREtHYT8EmFDlRTRPMcrfNesUgUUFJgGzCgm+X4O9za8J0IHce/A27GiyNgelKW42+FuBknOKdgBxCQl3C9Qjbur3aBBw03OL2y+chyFduV43xP2AzgZwDT+ibdFg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UNO6mcXo; arc=fail smtp.client-ip=40.107.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EcA4XhzUNhpHRtWgtaHbXTtZ7ZYmZ3XRjfRBh7veZGa/XcjA7zicIw+3MdckSThtssdalvkVHy7tgoMJTWaX4rarSk7diATeT3r1UyB4MPszaMhjS5QgRKatJ4SYtZ/mgOaIhl1RqieZ2ZhoGmWDXv7r+lcbneyGEPL13OHqq6yHO9nnF/kGH/pjNuRcjTS54v5HT8+Y5EWcOsIiAaUVjUGIJ27eIh4QG+Pe5MAdHz3eIkwb8SliN1vqQPt/88SxmSHosdj1aRtdVhZIcW048S2/sEBCxot8vHUcavE8vatMUR3aYT0hESD1b2F1FLAUEx8gv66WE0gewqNjCN8pqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IHQo39paOYRDFG3GuN1N8z/3wYEC+7CL1343XH9g3C4=;
 b=U4mg1cbXo2NHSb+zDXCK6DGDRgxD/wZPFH4n+dafHSnwl7lnDgVa9OQK0W2eE0T7Hoa2bvjNAZyIYdrsTQEMeHQ/BjeDXNIAaPbsW9/1dUhRVY1wWBK6I7zYpZRgCoZxywkCWEgdp8bc3XHQidF6TCOhIY2YwofYraBEld6nRWZes1W1JeLn3EMoJQDx9JDuaY+rr+jkN85ZguWvD7bXubuka94lVPP0DJUDaekUVqqT1QPyVPZYdfouhnGEKbym2FvbxhCdFCsLhZbI99otZ8aaXe9e4f8Ex7UqVUTbYS1lo2PtljNcenNK8PxHxSCc/r/TZlsPe/cnmyhYy4AwsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IHQo39paOYRDFG3GuN1N8z/3wYEC+7CL1343XH9g3C4=;
 b=UNO6mcXo+lsdofuzRM1L7RE2lT4KD23tReCT5tNe23KqkBjkEpBtaTxlr95iTl+CwijJG630Via1MbQ/qz9GXg8kpPrgA560k/J2cFf9khQj/Vb6wisLzzVwPTVtx0/e1MU9uvMF3hseOFSkRunq5RKZpEpMayrBP2m/FhbVxVc=
Received: from BL0PR05CA0012.namprd05.prod.outlook.com (2603:10b6:208:91::22)
 by PH7PR12MB5805.namprd12.prod.outlook.com (2603:10b6:510:1d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.15; Wed, 6 Aug
 2025 20:46:26 +0000
Received: from MN1PEPF0000F0E2.namprd04.prod.outlook.com
 (2603:10b6:208:91:cafe::6b) by BL0PR05CA0012.outlook.office365.com
 (2603:10b6:208:91::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.6 via Frontend Transport; Wed, 6
 Aug 2025 20:46:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MN1PEPF0000F0E2.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9009.8 via Frontend Transport; Wed, 6 Aug 2025 20:46:25 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 6 Aug
 2025 15:46:25 -0500
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>
CC: <rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>,
	<weijiang.yang@intel.com>, <chao.gao@intel.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <mingo@redhat.com>,
	<tglx@linutronix.de>, <thomas.lendacky@amd.com>, John Allen
	<john.allen@amd.com>
Subject: [PATCH v3 5/5] KVM: SVM: Enable shadow stack virtualization for SVM
Date: Wed, 6 Aug 2025 20:45:10 +0000
Message-ID: <20250806204510.59083-6-john.allen@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250806204510.59083-1-john.allen@amd.com>
References: <20250806204510.59083-1-john.allen@amd.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E2:EE_|PH7PR12MB5805:EE_
X-MS-Office365-Filtering-Correlation-Id: e4f8e22a-ba17-4ac4-bfe2-08ddd52a4fbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D17LX+wWSnfzNHA1wlgAAiBOgT1BiStPQOKlVTw3KFaMDwDmeoYkKLkjVg3J?=
 =?us-ascii?Q?Eg9I3iJiWjohY/XEgDZE797T3IGeR7c5FgHM4L7jTYycWf8UgtTnTHsDe6+h?=
 =?us-ascii?Q?PJTTyLjOWIjAU6Qr0FUMOSyiHjSO2dySohPzygs7s8uHtcX+Qadbn8Vy+dYQ?=
 =?us-ascii?Q?xF73VBzr0GLsXUovPdbCoAC4mgx1OOcp/AIpQsuhk5RQH76TBBm3B1q/fmHp?=
 =?us-ascii?Q?l44aFVczO0M3+b8rFzlV7+M4JWiUCzBE/jT2m/Ef9xxcT5aTP7SeMRiI18mN?=
 =?us-ascii?Q?JjbAd9yayDwltskD5o/HhET+rqlicitjmO5RS0W7TR/efuID37ObYK1uRjTI?=
 =?us-ascii?Q?y4rxs95IFG/0Y5BqXBxBGdVSi059AR8aZrTCIB/p8oEGF5obn+uthHZvlejg?=
 =?us-ascii?Q?8v3v+FA74YB0hlcwd05FwqdY/6r1AHZJ4YpeCAmn+m1bAVcpO7PQIqdwbOiU?=
 =?us-ascii?Q?nnMGlpMPvdbXOhTNbpIo9YcHuHFjJjn/wexE9gQqLi0i//ojRt1Y5z1lzPHj?=
 =?us-ascii?Q?RtQ3hAjFSezii1gGzmYGwFWrJMVLaPaatgcOXHtxoe9ZNsbToptYbPpp7QoE?=
 =?us-ascii?Q?wGsGC/yNreJdl2YbximvI/RIrF2asN4ghB3e0OfbIKHA1u+IBIPXy4FmuQWX?=
 =?us-ascii?Q?fcP0O0XMWQqq28V2qvand1GHisd52a8LGvYPTPQ9VbZPNjsMwacMt3b51RnJ?=
 =?us-ascii?Q?Xz1PcTffkLa/G9zK8TVbVda448WGb6c2UAiU/UDR9tQtirwU3pJBlhPBJ9ga?=
 =?us-ascii?Q?3YBFOCCra0zxn25/ycYCrZCr4w1D9+epUPPEyIKojT5exLpRDsN58SdK6fUD?=
 =?us-ascii?Q?4YVm183F317cWK5uoJorLjIMSUsAkZPNyFaxlkxMaGOvB74KUsMcIZVRpdX2?=
 =?us-ascii?Q?WQByAKHryBqqiQongTB51rz8bL7QaFV72AUZFalUL9WqqJE6XZAkcPwQN7dc?=
 =?us-ascii?Q?7Aqsu+Y0m1u6vuH/R6T/DQisX11oFuZ1wFec6LEy2OL1orgQLnjolp/RLG9d?=
 =?us-ascii?Q?G3ua/yF6JGTKICry9OU1a1uiHPl/wzz7PRXCLwMgXzyI7cZYoCxnc8+XeEE3?=
 =?us-ascii?Q?/2/2J255CQLzudpN2IpGOhH3EcmAtGtIeAt1++lNFdynxMvSVB7PMQ8JK60i?=
 =?us-ascii?Q?0gUSAQaQoLDf7VDC+PJwLTbr2Rg+YnpcwASyfdhVUQ0awDRXlFCKrDLA9pJv?=
 =?us-ascii?Q?Y4fbA7mHvBo9/ALOT6FNK4PMGShF7zaUao4YCmrd787ppjYTUQSAdxiDWdPA?=
 =?us-ascii?Q?FmJ/DVvxYEzQb66TgC4qCrUrd41Qy3BkQYUPceo7a+8+0CZSkXcp/OLlpcXr?=
 =?us-ascii?Q?qqb1OVQnUmme+DYtUrjlPCvib3ufaAIaG+jMpLLTsPC1wVhwc4BeFXiTmOih?=
 =?us-ascii?Q?0rdD9Gqc4D3O8JPK6REc+k6ZcfumE5a6GHFUbAuGXBuytO6HSLtb69VWR0vV?=
 =?us-ascii?Q?DcZREwBglY24KqBJH/nGhnLudz4zRGvtFuagVdo4Aoz2xHKPnMz7frDU3cOn?=
 =?us-ascii?Q?0kjW2IwtWxrTNKmh9zdo0d9pD3VvwfznCy0i?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2025 20:46:25.9078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4f8e22a-ba17-4ac4-bfe2-08ddd52a4fbb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E2.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5805

Remove the explicit clearing of shadow stack CPU capabilities.

Signed-off-by: John Allen <john.allen@amd.com>
---
v3:
  - New in v3.
---
 arch/x86/kvm/svm/svm.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 82cde3578c96..b67aa546d8f4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5255,11 +5255,6 @@ static __init void svm_set_cpu_caps(void)
 	kvm_set_cpu_caps();
 
 	kvm_caps.supported_perf_cap = 0;
-	kvm_caps.supported_xss = 0;
-
-	/* KVM doesn't yet support CET virtualization for SVM. */
-	kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
-	kvm_cpu_cap_clear(X86_FEATURE_IBT);
 
 	/* CPUID 0x80000001 and 0x8000000A (SVM features) */
 	if (nested) {
-- 
2.34.1


