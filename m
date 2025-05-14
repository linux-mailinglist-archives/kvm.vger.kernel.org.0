Return-Path: <kvm+bounces-46461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E3E8CAB6472
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:32:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70F2B463D63
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:32:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8A820C46B;
	Wed, 14 May 2025 07:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Waa5jtq6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A592040B0;
	Wed, 14 May 2025 07:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207891; cv=fail; b=fQ2QINys3yXRPRpRMk9zeBd+RVvEv/IDxdtYVNgrEKmVpC5WbuyanPJHZDYyntbRQRpBhU4XpOnZhR+deYe0ckp93ok42VfbjuWIjICpsV+FmGnvH0L5CSp5w/tImjnxbNxzP2NOgRR2Y32Ey8vAZlHZYFvuLgBkARCMmfc+HVU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207891; c=relaxed/simple;
	bh=rJewQjmD1CKrI9gWu8x72T0uwscdolZLJvEFsl70no8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cmC5Es5LSD3549juyys4mooUC9blg4RxY4gap+WPn2WYKZ9cOr7Xuv/ppHx53pA5CVhkIQ2bLWaNzU94x+DuWMbJgg8LuzzQKNMx+wCeej1/0vQ75GqWx38vw/4zGdRh6RvXVdfzJTpBd+8udL36euC+pAo+j80xjhUQ36L9Vsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Waa5jtq6; arc=fail smtp.client-ip=40.107.244.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccFxomiUej0FibGxxA7VyQvjXTTWxIy7eDk9+UEoXlmB5xzl4FR461VjFogUo8KAVQ/6DXWO6ZAk0ErYEpAZIHMdrwv8bEz6MeYHlUn1ZVIiiCBz/9u4TImsThChhLqaBOQWxiILhv4WmAqc2OlromB4d6KFEa4bV1hpVeb8b70B9Ut24vC/PQS9S1fNRp0uJ2403Mn+dbjWQXQzHQA7kS7Nq5FK9JeKDTL6/nPm/hwZ8UqF/ZsJyRo3wyxvf/feCdnFuuHo16pg8TrVM3iHbYMm99tZetRXOuuP4Tg6d5qzGq0gDUsXdpho8kJiHJ1soE3xX/Hlu500wDBlE49qlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pK3+m1EcTzUu/U2IMOd+Lo8AG4ZRj/SeqHTzSFuJjeo=;
 b=Dgrrd3MnEE4dhIeEJS2PP8Wh7wmiQj3wm0NfQTrGo79aBraXjdH22mTxTr5maVakQGfgB7qpV9pb2CR6WZaNQQDTHH9/e3AWQPMJ1wqQP7hOrLJBYg+v6crMfX3cuoRPzdimn+Vk0xGdQ1rQfKZtfJhx6250sYCBivZWbMf1amCv+9AQLYE0MlxnrmCLUSEYMezagKRJ1/9XYY0LKhSHx83r1e6oHZdNQuOzClIwl4weBvxbjw6HqN2/nFWrhku+UQ6kjgq/Hfd+PzfM7W2qt3ldpcQOKgvp9DA5U9kOLRA01T7lDyFfZ3kyyjDreTu1aa1wHdnF37Yf5hlXCv/8uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pK3+m1EcTzUu/U2IMOd+Lo8AG4ZRj/SeqHTzSFuJjeo=;
 b=Waa5jtq6zCjBuo3qBuRCQce47//SHdiKSK531X400SRXeY9IUdK41ihmV0oVLffCwyzWZKhbkfN/x/kwdRD1pgulnavdRjIwGi/nPxoTLTx/Pm3+VpA+aDmbZ0qPve4y4+1HhkUjQOfUr4SV/FzBRZMHi2+gGnBZv054kobQfps=
Received: from CH0PR04CA0084.namprd04.prod.outlook.com (2603:10b6:610:74::29)
 by IA0PR12MB8086.namprd12.prod.outlook.com (2603:10b6:208:403::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:31:26 +0000
Received: from CH1PEPF0000AD77.namprd04.prod.outlook.com
 (2603:10b6:610:74:cafe::88) by CH0PR04CA0084.outlook.office365.com
 (2603:10b6:610:74::29) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:31:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000AD77.mail.protection.outlook.com (10.167.244.55) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:31:25 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:31:16 -0500
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
Subject: [RFC PATCH v6 32/32] x86/sev: Indicate SEV-SNP guest supports Secure AVIC
Date: Wed, 14 May 2025 12:48:03 +0530
Message-ID: <20250514071803.209166-33-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD77:EE_|IA0PR12MB8086:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cd7a7dc-f335-4a6a-09ec-08dd92b95594
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V3QAFfLZ38F2Tk4x/l/tAyceJSaDSWrIj/FCda2ApjWPxcxTNhmvz3rhhNTl?=
 =?us-ascii?Q?TX1d/RUgQS8VNJS+PGrOcufnFC+ONIGXHCG0FBwEJQiqmGQm9llZ0XkqE34o?=
 =?us-ascii?Q?eNf4tU34+0PfuUcBWsdZvSyrERbkCVfWG8X3kw1ws5vf5WGv2LzU0cEdw+yZ?=
 =?us-ascii?Q?VsF0LwCwBb4+mrnjPLNTa84JeteKxmq5J6p3OgWU2Z+cmJfA11XsF5XsqWE4?=
 =?us-ascii?Q?KOqZDgT0cgTquZ5qXAzCYiT25anew8FYqwKxf1N5uIgmoYhbyTiMDNBL50JD?=
 =?us-ascii?Q?ORJypCpk0JVvJKf8CGdKovDf0pBiTN8EMHGaUXScJ3CyFxZZWQ/IYBuwXGIu?=
 =?us-ascii?Q?TKkdsUjw/kkP+2RZBnNo0j0GqhypV6/nud0dZbcGYjK653TbXuKugUriRXL0?=
 =?us-ascii?Q?rT9BG3lNbuKk6lJzzGGHyLQNDOJjHeXfp9DUkJLpdRwzbDLNBIsfZUezoYKf?=
 =?us-ascii?Q?prBnMei688n30sKmWc0Kv+Q/ap3wOol3Vb66teGX67mvFO6voWdZnWid/nSL?=
 =?us-ascii?Q?hV3rrWIxujPFcVpMxF3w60lN0114oNTU3+Ik/Hreuj7TvSj0aL6JQrz4Hey1?=
 =?us-ascii?Q?uErHEr5RaFzPRej5hW/Qw1Mx1PZrQcnZ5ePXAFjYo70hYicbGJIpYBnz94Dh?=
 =?us-ascii?Q?cqYD+T/GZ0z7S7QH5l34E5w2eDyQisZXyHKwOsRz6BfWaH/5tmH9lCK3FX0G?=
 =?us-ascii?Q?YEDi+oylBMseJTrTAFG59bCdBCM38NUspbkPa1KfweSXa5oQmqsIgCZIQ+Qh?=
 =?us-ascii?Q?xkF+GYqi2njKsQlR+r9WWRpUZXLmIqYuZuMVdTNyNipK7PEYexcNsq8OAHhV?=
 =?us-ascii?Q?ztHFV94KQTwSNoi6oexsyFxiO5wu9lFIvuowfc2Ru1LjOKD3xRLp4GpJW/ZS?=
 =?us-ascii?Q?IH9Z5LremXGkKRoNF8uL00YSrLNwTDoU6wisnxz+CMdqhDt9NW1a2D6Fl545?=
 =?us-ascii?Q?HOq/ER4l8EmsL0U3fWhrLvqNoDqeWSoJRSxJ/dHc6AbzYHoxY36iR6+O3v4n?=
 =?us-ascii?Q?kc5SVCpIkNYLbfwFlYyXaNDyM7VxqnptRhK6jBEvDxQoRJFkRrMvtVu0lvcS?=
 =?us-ascii?Q?ADDhmuk6/RR2Sc9MxvsWH2InYADYgrzxVOyRLKqKod9a8mUx/em4xRG1jAu4?=
 =?us-ascii?Q?tNoQ6boArpeSnVY+Ax+8zRPL/YND708X1vBJlVLOajfd8LaKaxOT7Cnst2mP?=
 =?us-ascii?Q?MLc+ja47DIwUMG6ZkDcjSulRKQaytyTqgpmtEribE/76TBaycKWoQ/vkXMzO?=
 =?us-ascii?Q?1QU/QPam4PbqceQIgqP3apVHoiIikSbqLifS6lGCKVFyd3fg8mxNpR/0o74a?=
 =?us-ascii?Q?lp3TLIZdxfKWfUDjgxEJ6KZYFUms/mYjD7MkV6lp9AZycbv9HJyFGgZFpaCO?=
 =?us-ascii?Q?PRM0CqkPxKxH/RKhaEceqYY8QJOpr2PBFkyNtguOC/RALCskMFTgyqpx32Y6?=
 =?us-ascii?Q?1YbXepnWDQicXlRjnfk55jJXJcnd0NE7HZFQsHkad/CgY1IH/MMTDCBS5z8d?=
 =?us-ascii?Q?b2IBccaXoXCMcQOvPmp7QRC5EQZFirHai+1Y?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:31:25.8282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd7a7dc-f335-4a6a-09ec-08dd92b95594
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD77.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8086

Now that Secure AVIC support is added in the guest, indicate SEV-SNP
guest supports Secure AVIC feature if AMD_SECURE_AVIC config is
enabled.

Co-developed-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Kishon Vijay Abraham I <kvijayab@amd.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 No change.

 arch/x86/boot/compressed/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 31287003a249..af03dc1190e0 100644
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


