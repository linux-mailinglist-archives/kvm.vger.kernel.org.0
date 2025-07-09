Return-Path: <kvm+bounces-51869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A8D2AAFDE7B
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 05:45:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 22DDD7AD45E
	for <lists+kvm@lfdr.de>; Wed,  9 Jul 2025 03:43:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8386217F26;
	Wed,  9 Jul 2025 03:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fz/ekhpR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2101FBCB1;
	Wed,  9 Jul 2025 03:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752032640; cv=fail; b=EanWtJktshe7ZXQumqeX2FRk6hFY/4IurnP59d6AGMfx7vBdyhA5u4N1g7cYf1gqfcx7QOR4mNjdcCnZ6gzxjFIVRFAwpxr5cfwevHRc+DueyKR1s82bqn+KqyuPu/o4/k/5LunttNFoE1hlu6xX91V/AwQTVKqgUhrzPD9/UkU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752032640; c=relaxed/simple;
	bh=dcUOdwXyQpIrbncpp0Ry+CPSdeqDiUPWcIhGMqdjeVo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tf+LzoTC2rf70Di5Pnkdnab8NmqaDYvZbxDD1XL6LZ0wN1O0Dw/qUZRksVfS+L9cHKPYKPpSuxdwp+Jh5lpifiXo5TqpM4EqZCbXO/x/LO22Xlk/G4yMLqnHrRCUHEzH7Mj5F+N2S6wpeXntoQFWEVWcSFK0zDYFPUqcMAj1RXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fz/ekhpR; arc=fail smtp.client-ip=40.107.220.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MxDAq8O3+Ls8lPzNaMqLcE0/ids5EVD/xcJsud5S0j08ONyCOXemtRvxgz56eMZdVfdvvhDQKzDBQVZImjEIdJMyY4QqaaGoSyDDRSTpIK88dhLi8YsPDLPSkWmuN4jOz0ecC+bP9FzBZX807tRA/4H9YnVIuFTvk18zCQkQLAgmPKWqJJjYw791EUFXFNszp8Mh4TrcSZBhaoHMMsQ0XJsIHiHTNXeotG3xBO64v8KPux9WzjTT2FYoEWxIFF48VefhzMyIU7mOuccmAmkh2F0YQoEiQb2oPvNRfIjgdOJYRGhQBiVKYYrlVVbPC5uXf7INOD1qy5C5jmD+9K1tkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3huU9gwsgBtqDBT/BU8sRv34jahVFiLZYLt+ewquco=;
 b=JIC72h++HCnott5KR+OPh3mOGIczP/mwoSn1wWcq2NkROUfbCYyNjfEYZCc+8WEgNFaC0QE+ohkuLVZevC8hnX/dsWlfLhohO7hwcrZec00rZLbCyXpL6a7v//GcxNby+TLR+suLcPF+JR4JSM5sTClGGMPLtPLe/zxkgPiumu24Xdbrw5mPJbmuQZRylMZb6+bIQ4gk3nmWwz2CGVUvhMZU3Jyoqj/4LbJzRPSlZN+WUIM0D/JvbT1bZVVNcxVQ/t1f1HN1Dd6OoIxWiySzMF7W3+RBagr8YgxTNPnVsl0rTvj7y5j+Pn7UJk/oSvv97mR0PvXfi7ntffhvw/nBMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3huU9gwsgBtqDBT/BU8sRv34jahVFiLZYLt+ewquco=;
 b=fz/ekhpReth7abmjB1/MSiyLtRjJYl2WlBd1euO8wAgytQ+KXvemQNQ06CWJgk6iKEj2eRh3MsUcz+VZObzS1ps1X4U0P7ULlrAYjR5v6xYFnE3R6K/ydbtN7cYt3rLSUvHjKljf9Gkv5DPYX4iI65lopVskbuVS+Oc4e140pmk=
Received: from MW4PR04CA0089.namprd04.prod.outlook.com (2603:10b6:303:6b::34)
 by DM3PR12MB9288.namprd12.prod.outlook.com (2603:10b6:0:4a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.24; Wed, 9 Jul
 2025 03:43:55 +0000
Received: from CO1PEPF000044FC.namprd21.prod.outlook.com
 (2603:10b6:303:6b:cafe::29) by MW4PR04CA0089.outlook.office365.com
 (2603:10b6:303:6b::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.21 via Frontend Transport; Wed,
 9 Jul 2025 03:43:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044FC.mail.protection.outlook.com (10.167.241.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8943.1 via Frontend Transport; Wed, 9 Jul 2025 03:43:55 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 8 Jul
 2025 22:43:49 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <kai.huang@intel.com>
Subject: [RFC PATCH v8 35/35] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Wed, 9 Jul 2025 09:02:42 +0530
Message-ID: <20250709033242.267892-36-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
References: <20250709033242.267892-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044FC:EE_|DM3PR12MB9288:EE_
X-MS-Office365-Filtering-Correlation-Id: a88b3be2-a9b0-4bd3-c2a4-08ddbe9ad469
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|1800799024|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WOaOyLPBUjDJ5HrfQg3jXo9OW5YR/Zs5SXT8cI0q/hnOO6z1r/bkjuCgJvLU?=
 =?us-ascii?Q?5Kr9fM2iTwxpBEeANX2czKpJcvao3HbLEC9znBWNrvpxr+pq3q/tbu2e/zsJ?=
 =?us-ascii?Q?4MWc6Skc8wZNbx6yKUsxZZbbGbkE/IHgTl8AstBMY9W/dKGTdImhFGXYXPfI?=
 =?us-ascii?Q?M1vM5rNjnFq5vFsK9N7LLbc7FVZDTWy1l2dkYsBhDIlX/eeJS9Ri5xlf4F0P?=
 =?us-ascii?Q?Ei38bj7eF3jber6a0+/1RoEsb3GsncsTtjgpP1CVC6azzt2YUMkXuK3+Vq65?=
 =?us-ascii?Q?WHIN0Gh/6XuHMWJagYawXb7UWcWMUIAOOHedPU0v6kkXqUteKBrkEiNv6MNc?=
 =?us-ascii?Q?1U9c9cbKGAGtlywJpg4JJ2vpB44fBO9kbFuz5zBraaLxHah7mD1Iugfgu/sF?=
 =?us-ascii?Q?swy2HMa9B43zHNlPNh6LZnssblzTTyI2nxw61UtdN+Lt46HZLmeR236hNhXe?=
 =?us-ascii?Q?scdRJPAc+YWVGYd5w0yPOPMpRlvD3zlk3EcMhHFLkUAvsXYmZ0eZyvbHUeJJ?=
 =?us-ascii?Q?pc/GnHS6s43qgVavQcAOGPbzP3Utd1t2RcuM72AVcJNinSvV6thnrzUHAYh3?=
 =?us-ascii?Q?n5pwZiaeQxxCc0cbatWaaWdgmsQRQgzH0nC/eKhEUZA8QR3kDK5xLZls1y4K?=
 =?us-ascii?Q?0UDo9bBsMLL3b/rBMkXrKZ9VdWKPTj0lxyKXKgM6GUGIht+sCnZdLde3C2OR?=
 =?us-ascii?Q?+cTyXttvbRfFzBR346jt06nayKjRw6oTLCx8D+e6eU/phfOiT5PoVjENBqke?=
 =?us-ascii?Q?aMbUylw9HjXeHvmN1GGKtJwxlEpMSYffxTbZE+6VXuo2cBGPkKi2Eg2i0A0u?=
 =?us-ascii?Q?ymhQ8iZaTYcN2+RMbko72mZQydUdfyN1lSc36Ju90YCBtWHcCViR8scqwWUK?=
 =?us-ascii?Q?aADs16dEHkpb3UEVbXTSD90E41asqY+x9MD0ZfWdRfMV5gy1YHG8V84Ufmm0?=
 =?us-ascii?Q?f1DbxpJBbGBlBmHWy+XNLam6wTEOruCvXC9Xewkue0sEIKT0oGd4Gz/Qxfta?=
 =?us-ascii?Q?dBEYHR/5NmGI1OGUEH7zc8AnNCjiPdwVWTOvyk66Ir3YqJFj81X0laIPwckV?=
 =?us-ascii?Q?N6j4HKclqUfVvgTjJtEcEGAq3nWcMgAeN3Wfux16WiuUA/p8V4/l7RVuesL9?=
 =?us-ascii?Q?Zq9QgQTvaoLip6n99GLmkU6mFLSZ7pwJx9QKXtQp3GSsbhoEYSqRYdZDchdI?=
 =?us-ascii?Q?DodDUhqvDtFwewprRexYO/eATJ41XzvMPhoJ8QE5v3hs5pjrkADihZe0nzbu?=
 =?us-ascii?Q?ZzqHJyJTbNVaS5cyJU0Xy0K/yELwmkS9JJm8XGl87kMA8FnTy1iDMm2oBnTu?=
 =?us-ascii?Q?LqRN1mCJ/nnPBbRwYgLX5LXd7EyMVKNx57FYfY7fAZkaog9EvcPgaj3y8ksq?=
 =?us-ascii?Q?g7EA/prX2VsA5ebfu+XpKFSuqkPo8+lkyFWQrIytjNmr9ga9LMxDYsXXHhKW?=
 =?us-ascii?Q?QQ8dwasGAC7xc1fYnK/+xVECbQuAFhv6LCL5UMa2nQh/HZIDdMfShSx6b53d?=
 =?us-ascii?Q?Co5Lsy2u+WbuBt5uL+uSmAzHPdn7nXIetUc6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(1800799024)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2025 03:43:55.3074
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a88b3be2-a9b0-4bd3-c2a4-08ddbe9ad469
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044FC.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9288

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC feature if AMD_SECURE_AVIC config is
enabled.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v7:
 - No change.

 arch/x86/boot/compressed/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 74e083feb2d9..048d3e8839c3 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -238,13 +238,20 @@ bool sev_es_check_ghcb_fault(unsigned long address)
 				 MSR_AMD64_SNP_SECURE_AVIC |		\
 				 MSR_AMD64_SNP_RESERVED_MASK)
 
+#ifdef CONFIG_AMD_SECURE_AVIC
+#define SNP_FEATURE_SECURE_AVIC		MSR_AMD64_SNP_SECURE_AVIC
+#else
+#define SNP_FEATURE_SECURE_AVIC		0
+#endif
+
 /*
  * SNP_FEATURES_PRESENT is the mask of SNP features that are implemented
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
 #define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
-				 MSR_AMD64_SNP_SECURE_TSC)
+				 MSR_AMD64_SNP_SECURE_TSC |	\
+				 SNP_FEATURE_SECURE_AVIC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
-- 
2.34.1


