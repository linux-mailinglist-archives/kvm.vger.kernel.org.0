Return-Path: <kvm+bounces-59873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD089BD1AB2
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 08:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DDB23AA5CC
	for <lists+kvm@lfdr.de>; Mon, 13 Oct 2025 06:26:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1172E6112;
	Mon, 13 Oct 2025 06:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RRNT+yi4"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013019.outbound.protection.outlook.com [40.93.201.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACF82E1EE0
	for <kvm@vger.kernel.org>; Mon, 13 Oct 2025 06:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760336767; cv=fail; b=F6oc/ds9n5qwXUdrVaBjy0iNIb617i91Oe2sGZEQj44TPuHx2d9bmoA/CjysKHEowTC4K6XW4yPVHW77nttshMfL9wZXIbQWOKtF7pICe3Zy5VeNOVyuFd4A19F24CsDGCR5cc/7YXJ44kGwO3FcDvAFQ2JmD8l8GMGQXtVU8S8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760336767; c=relaxed/simple;
	bh=APIh1C+KTM+kNQZrVWZ3DVu3li567mUxbRAw8zajcwg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HyYSVZm1m+GW5Ivc+M+9ZdsFCC4Yfg1/wzPTrIDENwzNPtTzRAXBuWHDzqkDSMBfiYkLlKnkrA6a1W4LuU2WVli4+vWLcrkxTAeV6vlNFKzcz4WQmP/lIl8iPRdGERL1ei4F8wLvLhBAJ6yhIzCpwhUATHBifQlh0F/dsG/EzvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RRNT+yi4; arc=fail smtp.client-ip=40.93.201.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HAcNiQQu17JfE7s0Of5VVVlp+FY6u1ynbtqFN7OXYrnTWtYBHopbYUsGnEQAqCv8KnMyJjaKTJKNT48m9IjaxchQC+geqmZbfRKmtUBw0RtiLnNxMbE+OB1erabHu0TGSof0jzNv9nfXh3rQ0LYdje/ZuI1U1FYUwNkhk4c52u3pxxnjl9kiaBXgtTCcXeAsM6mzqpKOu5gLfWJEWTGdWkf6urZZgReHY5cvpzHZNXgUrJP3pS0fFhSlJeAwDLDc9JFrB5mUgxj8OuirGLtc3q5sknTaHqkzZtzIseg4F5gFlKAvDNtJ17gjhh6jnqRZlI3KWn5/+ZmnQafe/qce7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/iGa2WCo5xCNTRmcb96okwSk2w2xtqAIjUdVxtLM85s=;
 b=EVpXS84bMcI2WmdMnrlxlU9uA7s8JQ2I0YnrAX0ITDWomVWJdEz3nGapX/Lr1uId1eduq49u6J62ZRls5e/MJMwczuPY+nuOZq+GvqA0Gp0IO0EVekp8U1Z8jHU7L0lI6kZPc5jJq1xugmzGp0rhHLdX4SwHTyb9K8dRKhZhB3h+0TtD5zYGEpr263Uk9akhjAilyBsDmrAvBuX8EWS40hPcSPfMON2+4RfO8je+Pke8mn0NCdqPp/LtIaI9qNDPiAvwazK/vtZnn5WlbcYKsSyUodYBIKjwK6qZRUHJrZ5Jv/mkBoCFwaoVtREAEcS6cRuxKhz/Pxcrz4VJZB7y6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/iGa2WCo5xCNTRmcb96okwSk2w2xtqAIjUdVxtLM85s=;
 b=RRNT+yi4gAPenJm0Gwi+NHXnNPP6SWQXT+nC3rD7ekIuMACow62os/nDYuw9IN9EaOo0VrO34en68HqMGrWrww5PzbT7WkOzeP+pnkxsPsbP86/vsRbIk9GXAqQwMfmFoiTxmyrQS8kQSiAs/11ofo/buj4zpJWRA/Q5RP8S/ms=
Received: from DM6PR07CA0088.namprd07.prod.outlook.com (2603:10b6:5:337::21)
 by LV2PR12MB5727.namprd12.prod.outlook.com (2603:10b6:408:17d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.12; Mon, 13 Oct
 2025 06:26:00 +0000
Received: from DS3PEPF0000C37B.namprd04.prod.outlook.com
 (2603:10b6:5:337:cafe::45) by DM6PR07CA0088.outlook.office365.com
 (2603:10b6:5:337::21) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9203.11 via Frontend Transport; Mon,
 13 Oct 2025 06:26:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 DS3PEPF0000C37B.mail.protection.outlook.com (10.167.23.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9228.7 via Frontend Transport; Mon, 13 Oct 2025 06:26:00 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Sun, 12 Oct
 2025 23:25:56 -0700
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<santosh.shukla@amd.com>, <bp@alien8.de>, <joao.m.martins@oracle.com>,
	<nikunj@amd.com>, <kai.huang@intel.com>
Subject: [PATCH v4 5/7] x86/cpufeatures: Add Page modification logging
Date: Mon, 13 Oct 2025 06:25:13 +0000
Message-ID: <20251013062515.3712430-6-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20251013062515.3712430-1-nikunj@amd.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37B:EE_|LV2PR12MB5727:EE_
X-MS-Office365-Filtering-Correlation-Id: ec1f8c27-fc85-4538-b101-08de0a21607a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6nEV/jYgR3QVthdPTUKc0hRiRquw9STrEq7cpLsC1MNgN8NMaNi3QX3QEF8P?=
 =?us-ascii?Q?9tqDDe19FSAxQkRtDA+EQxz8rDY1zGiMjZDBVlZ2c6tWV6gi+rnw5PTmHFMy?=
 =?us-ascii?Q?wEl9GKDYZF0KLK06LqJRF8MnJv1Czpn+CrmlhpJMzy16wUhm0uN3jWCTf6xz?=
 =?us-ascii?Q?CRw8TJxDDJ5Bya2ZnKfP2qVgTSQVNbXJfk+P5t7QiXiUJcwv6tkjQmDJJCHM?=
 =?us-ascii?Q?JVp492PU6xW6RPoyTa7LLrVVj47aNPbwOSqk99+QH0yVOyRL+ITR0V5BqL28?=
 =?us-ascii?Q?9vEg56c238IRGN2jEseY6LN5sLfcpgw5zmzw/OS9MdQsSzallbpEyaKeNMT/?=
 =?us-ascii?Q?EabGXdIag+S6BKQItOdIGI640P7jKriyX1bhTUPx+ODckOGHCINSUw4QKtam?=
 =?us-ascii?Q?sPiDJQqFzFLIJgGwNbxM2OCPtYUE+TXQT5AkiSY/Ez57ENcekm1cVH+5TPDb?=
 =?us-ascii?Q?Xtz50XWGLw1k8xTKn2Uvq2WXvuC1O/ImGJWWmyHaAZwxjXH0XOFetB/fypCP?=
 =?us-ascii?Q?mOLYNr2R+80rVzAsYFLouUAl7vLoPjdiows+2TQ7rk2xstay0Bi+YP42VHMK?=
 =?us-ascii?Q?GgGtoFvwB0CsYsgaY+CnM85bFMJCWlBGSeKmk58gtFBDnTq7e4P0UTTKPYvP?=
 =?us-ascii?Q?LEl1VAbgxg27EZZA3WAURqwzJMxluJ4F10qa+Z/+Qpzg5L/njZp8TQPkeX7f?=
 =?us-ascii?Q?7YXV1pPGVgcsDaErymZU7RbyuZbJHgXKfzlQC16XYY+5B9vydF5H/kHDU/Ab?=
 =?us-ascii?Q?I/EZXJgca4TCKjVDoCP4ezW1vH3F63EPbnz+Vqqed+XmbAQFjxZgyVoYGuHp?=
 =?us-ascii?Q?ZMR/LmzJTOhrwcTyvE3fCKYJA7HewRyW0dGUpxC04FyOLBeHKLxMjA1sBm8O?=
 =?us-ascii?Q?ZLBccejtRJgzTX0mJhLuG8lfnRN6HHEWRkCRn0vcCZaXCMS1l33iPcedCbhs?=
 =?us-ascii?Q?HejaXl+e3pVLp1S0cwWQL14VKE9zW127O0vsZ4kcbeddxEeT/D2ctFzghVTV?=
 =?us-ascii?Q?bYmolNYsqZgbI3jL3p6Er+0yFgBPAzafq/NjEdUGKxCLZFCINLBLWk1NRDG3?=
 =?us-ascii?Q?n8mGQV1GyQiMpQHHOuRtgJyi4n3CZNaQH9fj+0Z0sXNzIvG/9+qZt/RCVuPj?=
 =?us-ascii?Q?CrcWevLYTtm8WnbD+TMnNWzymBwZ6jRFiZg+PVxKOOW06aYqbjapRXNow8mi?=
 =?us-ascii?Q?oaW3FA1CWeSf0DJei4w95ngG8uErHBDgpAuAhJPJfwuY9GQSxfOkGNSDpzvh?=
 =?us-ascii?Q?+QW8/ift0grPsI0UfOOFp9oLi3c4p33e9HDVk4b6oIljYjERXq5uHD6WmlrR?=
 =?us-ascii?Q?IcCFv8dyzln+xD6nrDgXt34774XgxwnrYIyXiX8rBtn3HtK4vCfYeb9L1Myx?=
 =?us-ascii?Q?FKdeSvsNLZ042d0BOJiwY4Uf7lQ63mK811kfN9xVN6SEDuqla5S2dmx0X0qW?=
 =?us-ascii?Q?mS15EZelildqo7RZwo8bjVSL/DFuK+HEeuFPIsFRa7wEBZp2BFd1MMFrDwNj?=
 =?us-ascii?Q?wDvfNa/bvgtqux1ZtSsNXdg+SkPpsgU3BAeYT+/k6Cn3xqeUNRCRYS6/bN0N?=
 =?us-ascii?Q?CwHN9Zc1ZNAe8KWnb1o=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 06:26:00.1232
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1f8c27-fc85-4538-b101-08de0a21607a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5727

Page modification logging(PML) is a hardware feature designed to track
guest modified memory pages. PML enables the hypervisor to identify which
pages in a guest's memory have been changed since the last checkpoint or
during live migration.

The PML feature is advertised via CPUID leaf 0x8000000A ECX[4] bit.

Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f1a9f40622cd..66db158caa13 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -228,6 +228,7 @@
 #define X86_FEATURE_PVUNLOCK		( 8*32+20) /* PV unlock function */
 #define X86_FEATURE_VCPUPREEMPT		( 8*32+21) /* PV vcpu_is_preempted function */
 #define X86_FEATURE_TDX_GUEST		( 8*32+22) /* "tdx_guest" Intel Trust Domain Extensions Guest */
+#define X86_FEATURE_PML			( 8*32+23) /* AMD Page Modification logging */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* "fsgsbase" RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index cf4ae822bcc0..1706b2f1ca4a 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -49,6 +49,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PROC_FEEDBACK,		CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_AMD_FAST_CPPC,		CPUID_EDX, 15, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,			CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_PML,			CPUID_ECX,  4, 0x8000000A, 0 },
 	{ X86_FEATURE_COHERENCY_SFW_NO,		CPUID_EBX, 31, 0x8000001f, 0 },
 	{ X86_FEATURE_SMBA,			CPUID_EBX,  2, 0x80000020, 0 },
 	{ X86_FEATURE_BMEC,			CPUID_EBX,  3, 0x80000020, 0 },
-- 
2.48.1


