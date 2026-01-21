Return-Path: <kvm+bounces-68792-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0C3rOShKcWn2fgAAu9opvQ
	(envelope-from <kvm+bounces-68792-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:50:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id CA72B5E4AE
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:50:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id AB51F7EC11A
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 21:18:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F67F43E485;
	Wed, 21 Jan 2026 21:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5n3U2/KF"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010014.outbound.protection.outlook.com [52.101.85.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E47A43DA23;
	Wed, 21 Jan 2026 21:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769030088; cv=fail; b=HaDtET5mfpNKKkovb7MeeuC/fJI1UC+8di1RauNTnyW80K9QhH/xcNIkhts2NynuZEDzLF2bfXyfo9G67k0og4Qme/3ri12wOMMHLld5wvvzDbCyDquktrE994s909zh0zqVUGeYkxy3A9DXvKwNF9qX3BY0MHT32TPCTnzYLl0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769030088; c=relaxed/simple;
	bh=pQU9Ng5ohZjo4fDHiQ4O4Mg9BTXQjlizDbXF71QILJA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LF9n9gF4fUS5H1krS1sYie4vmXKQbH5ulInoSu6MBQ+qQx+jSAn573HY/4tBO/qedLltZFM5LM+RWMUuKkBgNDJcjf0uoYezA92z50zwR9tuDqq3tjTfRGDbQs449WVHYMdBqpfhfJfuU9huDk+6cMmPXtuAYeYBeZv/yiYdduk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5n3U2/KF; arc=fail smtp.client-ip=52.101.85.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z5Ga3U7TpN2sKC6BoNuzCmJcP0nqofNbhI9pA4TFmR/BYQubzWxGZbwwz1ga8wyijqkXJsmetK8v9CJY9FQZ3yyH2nF6Tp2sXAn9xXF4tzUBu1bdvTDNK3Gl486VpxDBtDZZzymdaAm9QE/JXRu9CbI0sq+ElYE2xGHZ+5C+gzofx3e9uTH+1uqTe7bkFKPEiX+9JxyodbyPsrpKddDk4vN4EyzaPfH79SnLfjCgcTajcguW6EVCh+wWiymfDKUzLeilIZSelciySQXG8NGkF1Wl1BO/zM2AM2vxqdF2smsy/+Sael3VJGR3QJ09gNSuHoz9bFMU//MSo5C7fG58eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8eR6qUZ5+T5NQSMqXaX94qahxXc8MlLikha6eBYjPY=;
 b=TokCmfif5+eKicH1CiYd87/ZT22RSB43WFdKBY4R4Wlhm86Rf5YhY41I5Wg7TI8aiYNPTDDe+8By9UwOW4jiojEnldZBwFFso6GAfNwjyd+Uxjv+9MwfICigr9pgYELM847xVdbDCSUhjVR3mVWLKAchTjUD6UkduaQkTb5V8ffltTYE6R5lLuLZaS84pGNOJdRyT8xhtab/syi9fkNQowXKvKl5Wty+uTReVeC/cM78nWh3R2/wit8XDvYZFPux0Y7LgrDSDcWJB5lTnfcVkMuG/PYSHQ4b92Or+2QcElFmBVrDQmRoxnSouneMxZLwlVIUVFT/ruHgetip9HJfaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8eR6qUZ5+T5NQSMqXaX94qahxXc8MlLikha6eBYjPY=;
 b=5n3U2/KFMMTcDZmOUIfy441jHOOrj00qamw8C9fA4roEfzsrYMlgdid5Jq4M+cYvsxvQFMsTKQpw3I5f+tlwOp+SyqzwAKL4U4peptEBkC38Mq4JzZwVH3E0b0LlPXdDKIB+hmUaEOeindtrqfWXFwP+tahDf2yNY8Phylza4EQ=
Received: from SJ0PR03CA0297.namprd03.prod.outlook.com (2603:10b6:a03:39e::32)
 by CH3PR12MB9344.namprd12.prod.outlook.com (2603:10b6:610:1c8::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 21:14:42 +0000
Received: from SJ1PEPF00001CE8.namprd03.prod.outlook.com
 (2603:10b6:a03:39e:cafe::77) by SJ0PR03CA0297.outlook.office365.com
 (2603:10b6:a03:39e::32) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9542.10 via Frontend Transport; Wed,
 21 Jan 2026 21:14:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SJ1PEPF00001CE8.mail.protection.outlook.com (10.167.242.24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.4 via Frontend Transport; Wed, 21 Jan 2026 21:14:42 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 21 Jan
 2026 15:14:39 -0600
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <babu.moger@amd.com>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <peterz@infradead.org>,
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>,
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>,
	<mgorman@suse.de>, <vschneid@redhat.com>, <akpm@linux-foundation.org>,
	<pawan.kumar.gupta@linux.intel.com>, <pmladek@suse.com>,
	<feng.tang@linux.alibaba.com>, <kees@kernel.org>, <arnd@arndb.de>,
	<fvdl@google.com>, <lirongqing@baidu.com>, <bhelgaas@google.com>,
	<seanjc@google.com>, <xin@zytor.com>, <manali.shukla@amd.com>,
	<dapeng1.mi@linux.intel.com>, <chang.seok.bae@intel.com>,
	<mario.limonciello@amd.com>, <naveen@kernel.org>,
	<elena.reshetova@intel.com>, <thomas.lendacky@amd.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <peternewman@google.com>, <eranian@google.com>,
	<gautham.shenoy@amd.com>
Subject: [RFC PATCH 12/19] x86/resctrl: Add data structures and definitions for PLZA configuration
Date: Wed, 21 Jan 2026 15:12:50 -0600
Message-ID: <d09bd17c80b6ab72202bf31a503b6a2fa0d9344d.1769029977.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1769029977.git.babu.moger@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CE8:EE_|CH3PR12MB9344:EE_
X-MS-Office365-Filtering-Correlation-Id: de3e4a57-0f33-4c9f-1dc9-08de59321847
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?j1lfl0XWBxelCqkQgiQW7XsnhmAsWXnY8pqSqV9xJLN7qENtZ1eoecUhdb1F?=
 =?us-ascii?Q?B/pL+J0N0CpjwFuEu2limWEuS6cGvEjGwGyjrtpM4Quhd9D/0Ie401FW6p9p?=
 =?us-ascii?Q?iSelj9t32IbXSKCZ7GGTcF+xscpQKl4cgkh0YkgxsL7arG66hZZsZzBxcUiS?=
 =?us-ascii?Q?/kbYbgWC9QhNOE71YgDqlSYeSLq0RhtXhvOJ2u0HEvEWd/S6LqWKTm2Qoopq?=
 =?us-ascii?Q?q/8AIz4L3yG+1y6RSAqET/odY75IgMtEGnbyCmhQevzQ7OBh4H4ik8R/0xS/?=
 =?us-ascii?Q?/MHQWNBpyMdrDMrowSH/EXsO7L3xOt6xP82Yb0nJqf9WmN3ZZfVBgXMkF7/L?=
 =?us-ascii?Q?n9rxluaCNJ/EVtCEyHv/oap97fUKZIsmNb3Xa5js8IjZTbFrO/TQw423AJo6?=
 =?us-ascii?Q?p9giTotbGv9IrYXt+3bJ/uon3u7UexRmV+qz/npZcSI5jyJlXwXTOFWqdniC?=
 =?us-ascii?Q?7dk5psnyYf3Ohi/5oAKz5CjTbPJMfNLeu57AnEsB3eASVLa0RNWa2UEKIxn3?=
 =?us-ascii?Q?ZWEXI+BXi26qOZhZQ569feNmtnW0Gt75eZ3cTAD4cJNQDZmUQIuKCWaG5xGZ?=
 =?us-ascii?Q?1QZDhfXk3n0vv/sSrFLwiXibaZyrIp7tpn1Dohv282GSCdo+V5bXNAb7nlVH?=
 =?us-ascii?Q?o0BgaKt2w8BmO8KYs02fY57HJKo/+cE6cMP4MpkvnICDbj5OmJqXsIJ+8bpw?=
 =?us-ascii?Q?XDlKluLX8tEZHSXLbaS5zbAt3tHpjRIgByL80SmDr7e5/hyjBqa8H57dK+b0?=
 =?us-ascii?Q?SEGpdLuVCEkESQPjI2Qm5z98zZy9vZ71vX/2+D0tKPaK+X+M14jlN8qjLnTC?=
 =?us-ascii?Q?0d89wOkd1IvOoZZFxwLVNN9jEOasIa6gb6stW4Ep/+VpohI51B19xkAttcyp?=
 =?us-ascii?Q?9u/RxtMpCyJkvHPxd6Lcqp5Q6cUR4TxnwrbERUU8H2nfBb4P8kpbpwjbUeUK?=
 =?us-ascii?Q?dmXzpOkVY5JRXimLKGbXaKWMwv/2XwU/oi/r/7dByLoc+jzp5Fp+LKAnQ3TY?=
 =?us-ascii?Q?ji1Np+QLBEZFi4q1KjxzUqtICvlGdxkM4RCCK/tsH5rgOH+2l35K+OVoKJ9O?=
 =?us-ascii?Q?smpLBur87GeRRxDiPF8OI83+DrGDX1KsXpot3UgkCoWSz1ujPv9xPQ5DF4eY?=
 =?us-ascii?Q?UNIbxPJjoruQd1ZlKC5RhyRQdTLMRocyDwhQIslSxEOPR0THShzZm7u8Khnx?=
 =?us-ascii?Q?QE8wgHqI3Sj0aQbRfz1UFDRRCdTBKQT+1xG7eidhWNOlHpb8pcKpqvUc2OGx?=
 =?us-ascii?Q?X6KZQyQMEbvDF4X4G4s40xWy4tL9kXEnAv9aEze7MjWjwGXIJJ+zVvgHZLHM?=
 =?us-ascii?Q?kHt51uH0gweh2Bwa3htVUW7yOfxUwOxkTbxPPyO0Wguvyzot9UbnfDadfuzG?=
 =?us-ascii?Q?Vr75TcQYQWlsRAYTNATRIjR5U+DupGJIn4K1ZRfmWxSm9V8b3Tc4oKmdXmoR?=
 =?us-ascii?Q?h7UaaGHkzycB448pGIUzK8iF5sAM7HHA0pAhbRurbuEKR3Et00pJ2Jo6w/qb?=
 =?us-ascii?Q?ES+ti4N4zPns9FucTK9RvdzrhVEmOzFLUTHgrAZmCfunawDYhzfoHhFS6lFg?=
 =?us-ascii?Q?dqfTXrYN5f+nkHCpOxBfn9ggvnkr6pbud+64dg00fvmm8TEOyByeuKeISf1n?=
 =?us-ascii?Q?SnpM9rHMtrTyE/hLqME3TqMta33AYeUbqIC/GoIrijq2b+KaUHhZJR26i+HG?=
 =?us-ascii?Q?L5d07SFJ0kL0UI7VSiYrxo1DoR0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 21:14:42.2661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de3e4a57-0f33-4c9f-1dc9-08de59321847
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CE8.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9344
X-Spamd-Result: default: False [1.54 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68792-lists,kvm=lfdr.de];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_POLICY_ALLOW(0.00)[amd.com,quarantine];
	DKIM_TRACE(0.00)[amd.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo,amd.com:email,amd.com:dkim,amd.com:mid];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_TWELVE(0.00)[44];
	ASN(0.00)[asn:7979, ipnet:213.196.21.0/24, country:US];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: CA72B5E4AE
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Privilege Level Zero Association (PLZA) is configured with a Per Logical
Processor MSR: MSR_IA32_PQR_PLZA_ASSOC (0xc00003fc).

Add the necessary data structures and definitions to support PLZA
configuration.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 arch/x86/include/asm/msr-index.h       |  7 +++++++
 arch/x86/kernel/cpu/resctrl/internal.h | 26 ++++++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 0ef1f6a8f4bc..d42d31beaf3a 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1271,12 +1271,19 @@
 /* - AMD: */
 #define MSR_IA32_MBA_BW_BASE		0xc0000200
 #define MSR_IA32_SMBA_BW_BASE		0xc0000280
+#define MSR_IA32_PQR_PLZA_ASSOC		0xc00003fc
 #define MSR_IA32_L3_QOS_ABMC_CFG	0xc00003fd
 #define MSR_IA32_L3_QOS_EXT_CFG		0xc00003ff
 #define MSR_IA32_EVT_CFG_BASE		0xc0000400
 #define MSR_IA32_GMBA_BW_BASE		0xc0000600
 #define MSR_IA32_GSMBA_BW_BASE		0xc0000680
 
+/* Lower 32 bits of MSR_IA32_PQR_PLZA_ASSOC */
+#define RMID_EN				BIT(31)
+/* Uppper 32 bits of  MSR_IA32_PQR_PLZA_ASSOC */
+#define CLOSID_EN			BIT(15)
+#define PLZA_EN				BIT(31)
+
 /* AMD-V MSRs */
 #define MSR_VM_CR                       0xc0010114
 #define MSR_VM_IGNNE                    0xc0010115
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index 61a283652d39..4ea1ba659a01 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -219,6 +219,32 @@ union l3_qos_abmc_cfg {
 	unsigned long full;
 };
 
+/*
+ * PLZA can be configured on a CPU by writing to MSR_IA32_PQR_PLZA_ASSOC.
+ *
+ * @rmid		: The RMID to be configured for PLZA.
+ * @reserved1		: Reserved.
+ * @rmidid_en		: Asociate RMID or not.
+ * @closid		: The CLOSID to be configured for PLZA.
+ * @reserved2		: Reserved.
+ * @closid_en		: Asociate CLOSID or not.
+ * @reserved3		: Reserved.
+ * @plza_en		: configure PLZA or not
+ */
+union qos_pqr_plza_assoc {
+	struct {
+		unsigned long rmid	:12,
+			      reserved1	:19,
+			      rmid_en	: 1,
+			      closid	: 4,
+			      reserved2	:11,
+			      closid_en	: 1,
+			      reserved3	:15,
+			      plza_en	: 1;
+	} split;
+	unsigned long full;
+};
+
 void rdt_ctrl_update(void *arg);
 
 int rdt_get_l3_mon_config(struct rdt_resource *r);
-- 
2.34.1


