Return-Path: <kvm+bounces-48826-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id EE228AD416A
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 20:00:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A43F77AEF9D
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:58:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EDF247289;
	Tue, 10 Jun 2025 17:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DhuN3/Xh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2084.outbound.protection.outlook.com [40.107.100.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C1F7244693;
	Tue, 10 Jun 2025 17:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749578308; cv=fail; b=W4+Wjk8ZbzMMHryL3Z6sT7UmVV22JWsmL+vb86q77Z14B5lt+Rv2Idu/6d6jzM1LHR7QGVM1379mIfmWhg7dr6qdsVIofo19F5p2oTIUFww36GzJkVaW1Z9UOxp4iaZjmngab/YaerzJB/POfuuAnZp0A5PM0qz59mngda6r/EM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749578308; c=relaxed/simple;
	bh=sk1j6J+dLI3X2VC7x9EPkYBnTz1nTiFszOnyFx0sFeQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N+kPzHz9kWGSfjzpIMXbvsHev2M0B/m6MuWEVp39DcSUsOuM4wDziFXepiHPmU45CwNJPQHfURqT2akgUQ0QzuYsVHTyIVprt38fS5qGJkcMq1wV720jy2nOFzdwkmCHAM0H4suidbNC3SFdu4rZhxPqPQjyxB9j/ocPb+T5w3o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DhuN3/Xh; arc=fail smtp.client-ip=40.107.100.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I3qnsLYBp0uie37JuF+VdCyUoEU0GsypLw8x55Kkz3rf7+Dpc0Y3mmD6nk4XRRCkOcXdanmiyxk7AUi9R7IBCX7c1VI47C8r30ur4T6B2whnFdwup0bqSNGTHkoHSkl5LOHAYzpHeqEGwphj0mhhpbwe15hU4eSvKE/G+XLfhBLADOY6S06gGN8SWTbW4NV/OgrYjVF65gk//N/PxTpoQBxV4DU6Zn3zfK51s3L8rKg+A9YO/AvfrJaoqI4yQ733P9JC2kSbOvNZ0cfYhibDaZe2c44OUw02poh8yNyc/BtexQYeEI8fOmlomk0GdeHatnFGxp7K5/Cz4u1nU9+9Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfIodZbsNFCHoOQGRMpwxfSTsfuBBnMTLEVH1hdFWhQ=;
 b=Zd4Kw1CJKz3lB57aLK7Z8lJgovtNCP+zeyYhu5Sl+3ergHJcVxt3aMqHx+WTqdtL5cB5YflZdJghwJoBLdNg9iGG7x5MqFPUf5uIfwKrkKb/OgO1zTHsmcqr+r8V4arXYS9u1WxwHNNivOaGBqRsHiiP/Pqs1G48KLmLCQeuUJYzjWqkotDhdewbf+sUpTwL6mK9NgUqThJ8K+ngLLOSp+4q0uWw5JNHeRhR+beXS0sgx18bYya0qrUQzshtom/0dzIraxTzuajgn10QQr3VjoH0ICzDlQoa6K5JxWBjGi2Em0ahFHhj0TOqvoMshU+qonPRQQLF6IUnOAq9kRgNVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfIodZbsNFCHoOQGRMpwxfSTsfuBBnMTLEVH1hdFWhQ=;
 b=DhuN3/XhANqrFM2EvKblk7ApXhs4yO5iDNfiegJJAcxuSqfyXmsQkG0LQPNKq1lVx7qWuR2CMLnv20DR+XYqrwAtT9RHp+5uUeLYYuTPPBo0bhjeXGrAqtzeeWnYv50YClBSorR/5ZlqJtCho70Rk6XREt+E0xwIL1U0HpwUj5k=
Received: from CH5PR05CA0012.namprd05.prod.outlook.com (2603:10b6:610:1f0::10)
 by DM4PR12MB5746.namprd12.prod.outlook.com (2603:10b6:8:5d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.39; Tue, 10 Jun
 2025 17:58:20 +0000
Received: from CH1PEPF0000AD76.namprd04.prod.outlook.com
 (2603:10b6:610:1f0:cafe::af) by CH5PR05CA0012.outlook.office365.com
 (2603:10b6:610:1f0::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.17 via Frontend Transport; Tue,
 10 Jun 2025 17:58:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD76.mail.protection.outlook.com (10.167.244.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Tue, 10 Jun 2025 17:58:20 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 10 Jun
 2025 12:58:12 -0500
From: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
To: <linux-kernel@vger.kernel.org>
CC: <bp@alien8.de>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<dave.hansen@linux.intel.com>, <Thomas.Lendacky@amd.com>, <nikunj@amd.com>,
	<Santosh.Shukla@amd.com>, <Vasant.Hegde@amd.com>,
	<Suravee.Suthikulpanit@amd.com>, <David.Kaplan@amd.com>, <x86@kernel.org>,
	<hpa@zytor.com>, <peterz@infradead.org>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<kirill.shutemov@linux.intel.com>, <huibo.wang@amd.com>,
	<naveen.rao@amd.com>, <francescolavra.fl@gmail.com>, <tiala@microsoft.com>
Subject: [RFC PATCH v7 10/37] KVM: lapic: Mark apic_find_highest_vector() inline
Date: Tue, 10 Jun 2025 23:23:57 +0530
Message-ID: <20250610175424.209796-11-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
References: <20250610175424.209796-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD76:EE_|DM4PR12MB5746:EE_
X-MS-Office365-Filtering-Correlation-Id: 344bb0fa-cbf0-47a5-d5cc-08dda8486309
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7+8iDgzDs5VA+vdvzvYuNoOIcAKRPSqv1QgHroJeJ2y/kbRHHGeN25cTZQwT?=
 =?us-ascii?Q?Lr7oka1OlPSSudgLbm0kwUQk2rWGP02Y5qXNlLhNhG++dvv/QDc68IVqHnNr?=
 =?us-ascii?Q?fYf4sk2XAeIcytnrJXBBWCdICnLWIdcgjrSeA5cswBqQSd6gVdwBB/NfR2md?=
 =?us-ascii?Q?T21g3LdZ0CTwpyhmLiBfIcJiZg/152Xoyp8ctwOOcfJugOmuwBsk/hFC2eMu?=
 =?us-ascii?Q?/K5jg3El1iAJJm162xCmlOgDC4XuwFu5VxhEbVEjfbhInVdWuuzy7dl/tpCB?=
 =?us-ascii?Q?ijXPK8w5Mqjj3eT26J+q1oHlNOV/RxQb4Rtr8RIz+Oi+XRAA2WOoDb+khkFO?=
 =?us-ascii?Q?Mzj6s4J/InBDkgWyxPdAAcB63SAAw7dqtsNyewCkl3qNOo0x5Nq5n3MifF+c?=
 =?us-ascii?Q?5BdxGX69CWf5t78Z9ric4JgZi3/xfuwCc3NOORWunrStwBUkYyOQEt4zyDKd?=
 =?us-ascii?Q?66hVhklbYSxR/gE0giiV/zWdhylF/RIDwoBoq/LxYscvR1HXLZJwq6CGZf+l?=
 =?us-ascii?Q?oAN0pHDpzrb45nxdMmpUWWSk/cy4BtZ+gSrWwCnaY/GBrhBfv7Fgq5exI7FZ?=
 =?us-ascii?Q?fA724pZtfw1VbfUNdSREwhspZNVbFODcHXJHVQ994lruYqMY95ag6gYoHKUO?=
 =?us-ascii?Q?e6imUxdX0jTSUunNiFgqFq/xJeEKwwNWqqBF+BKU3C0CpkFH0R921ax1DdDW?=
 =?us-ascii?Q?trXfOKHXnFo42g5olpiKIKUBAKKAahAUXRB8EyPRmQaLdrk4fGLKKs1u2NAH?=
 =?us-ascii?Q?lQd4uRGjfZ2dbUfKmebjTPoU/m43FrrcypYinBZSGGpUXy4JXM5Rl0Qbo9TP?=
 =?us-ascii?Q?3JKX800ofo3NeyFj2pYEmx0Cz671f1l/QxUsq+cqB1NjEU4+3P1MjhPfc6qm?=
 =?us-ascii?Q?M8eaF1yIYdgdkeovp1HOwloRPFgSyHt+kJarY49iJeo9OeNFbtSlY3p9hGTN?=
 =?us-ascii?Q?cEzkDee2eeKr9214E5BCaQoM2P/A1ALmF0ch5/rEl7kyZf1x/ZUj50DbHuwR?=
 =?us-ascii?Q?WRzm9iu5sTHppPeyLIjD6bhZJV2oVv8/ZrhyCO8KG1kw6dzaB+q7K5YGtdE5?=
 =?us-ascii?Q?lwPDH7H8FHY8a7eGPg+u+jwk7x8r6uN5TD/u6E50DKSJPhTinUVjvleOkgWb?=
 =?us-ascii?Q?0cNoutVe+7AWAi0S3XOwcMcVEMI62O9XhWZoixjuRA3ZoHS3ZQocZ+AwPULP?=
 =?us-ascii?Q?119BlT2ge4V3sGigs1ElxqEeHoLWyRv0p45ZjohssUI0aofhi0srxgt17Rfd?=
 =?us-ascii?Q?iCF3esCKHqAL5a5NfgqSlik3ubusLxGJ1+vt9I5p3JhgkZxX19iiaDp4HMLK?=
 =?us-ascii?Q?TdU4g6WI7NWRaoTOa/QaW5Em60RyiYi2IwuiIsVM1ZlhFdBfOQQcmMm5mXrD?=
 =?us-ascii?Q?ZZV2k/DJacVgcE2CvWiYyv5VkjrwrVfKGMO/JGwyszzVkCjdZI3/+7lrnViU?=
 =?us-ascii?Q?/kAfe3UVy6Q6WdVivt8z4yPvZy8lLl++ztaS+9vsPu/JwjF+cd/nK86iDbzE?=
 =?us-ascii?Q?X60eUkD9qIak1rF8bbUt0y5MMEf5prj/kanT?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 17:58:20.8635
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 344bb0fa-cbf0-47a5-d5cc-08dda8486309
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD76.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5746

In preparation for moving apic_find_highest_vector() to
common apic.h header, annotate apic_find_highest_vector() as
inline.

This results (on gcc-13) in slight increase in text size of the
binaries:

Obj-file    Old-bytes    New-bytes
lapic.o     28455        28563
kvm.o       664638       664746
kvm.ko      701907       702015

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v6:

 - New change.

 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 20e2ceb965b7..1f44bbc63f17 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -616,7 +616,7 @@ static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_CMCI] = LVT_MASK | APIC_MODE_MASK
 };
 
-static int apic_find_highest_vector(void *bitmap)
+static inline int apic_find_highest_vector(void *bitmap)
 {
 	int vec;
 	u32 *reg;
-- 
2.34.1


