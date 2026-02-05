Return-Path: <kvm+bounces-70293-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KCmkIxEbhGmyywMAu9opvQ
	(envelope-from <kvm+bounces-70293-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:22:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EA968EE824
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 05:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B50B43014116
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 04:21:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A70A82E92D4;
	Thu,  5 Feb 2026 04:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PEthJ1Hz"
X-Original-To: kvm@vger.kernel.org
Received: from CH1PR05CU001.outbound.protection.outlook.com (mail-northcentralusazon11010066.outbound.protection.outlook.com [52.101.193.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A502413A258;
	Thu,  5 Feb 2026 04:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.193.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770265302; cv=fail; b=X4ku2y8aVa0dRmsSZZU1AQuGkQ0g3aYHHlp4pX+eF0Fapxb3C07UYXOcjLPdC7/CiR1Tvj7Kp9JjoJZ1zRmthtBzO0jKxUzA90W+5SkBny819YLpi1g6pFXoi2cAa8Mqbv2CNT+h+XWIsnAS/z53jg+a8tJNDWJYjRZdd+4Jy4w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770265302; c=relaxed/simple;
	bh=2r+pYC7i8oRD+OvlWGB6X8q+9gmrRn63tN1+Nu9IwBs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=QhsECVUcgCy/4zn7KLFlGLl2pwBCPZjHxNBQv2Decqpen7M1SAab66F1danwmgh5wkaNixk0q9Dh0Wli6QK5s8AQ3ApSZYJkDkSJwvg4zS587YUxSays8y1VTD1F0ZdFMlKl/QYW1xzu4Q0dKVMdZ0KO6mc3SLlz1tS5seZcMM0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PEthJ1Hz; arc=fail smtp.client-ip=52.101.193.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wp1T3nmvev1dwRNd6s3JiaKVycaPGw6JU6mVfkSakcZ0DVeZEs2uvxofen2BgZ1V41AgDBTyDfbIHNfCw6MecWh+i77juVnoEPe7j3m3ECLixxE98O05neRI6VYmQ83mbHYkEqpdHdHgh18YSpsNBpWaRi9jBwLqFrCt4EH7P2kTUEZXGYkqaoAlQEb73wviitwo/c2LpyH/Bty7nZKGyzhtVZ+EbEHQnJUFP51arKRYe1ueKfoaSIcw4WLGNBbPSUW6VOTleEpuqTPt6QjK2D0Ooh7AqhreTS5b1/FnYXkJU31hekgqLeWO25ujNzbJmMNwUz39P6eK2YyUPaIzVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VWf9xjG/a2CY/IyvPrTGhU1UakddO7OsOgDYRNhVLKA=;
 b=w/HgMZoAQ8sGHDfsliCEBLbQ15RtEGaRcdcy4I4G7Cd6f/znG6hYwxBjPhQKLx1QKHCTgVYq1ESkhb5oqqKnvVLeSfKznLKl8Bp8kYS+/QMzvb5fYP4f86A96MyswZclIAqbwMbLuo/q/sOGKaXObH6HgHIMBQHGpM44YwSPLcmEwGu3NJIVd0tMlaBZbZbgZi9KuXTO44i3JEhBGwkX29Ca7pp9GolWSgq705ithDbC2Vgvq/4Y1X2XU4ZI+nuSTqt5pwdKlrgHMKMdIazDO2UTkm9RHMb2g7UjD6Nqhgpvxj5cah6gsMYKUd8G2cPUzP/dTPgYIZCpAo3a64/41w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VWf9xjG/a2CY/IyvPrTGhU1UakddO7OsOgDYRNhVLKA=;
 b=PEthJ1HzKGJQFrh+rfv7V7aCmm5f/eG2XGUfiJ89qCBXPRygSAigSmo9qCgFo2QX3I4rC/vMnPEJYwAk364CzQDnFd+tL5FoH9c802AdC/gLdK9INv6Zrxya1vA3UiQSFN5gFtnrhdig+9th8OfK3ZYvs9lNndF/8e8prD6nxJw=
Received: from CH5PR02CA0023.namprd02.prod.outlook.com (2603:10b6:610:1ed::24)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.14; Thu, 5 Feb
 2026 04:21:39 +0000
Received: from CH1PEPF0000AD81.namprd04.prod.outlook.com
 (2603:10b6:610:1ed:cafe::5d) by CH5PR02CA0023.outlook.office365.com
 (2603:10b6:610:1ed::24) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.15 via Frontend Transport; Thu,
 5 Feb 2026 04:21:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CH1PEPF0000AD81.mail.protection.outlook.com (10.167.244.89) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Thu, 5 Feb 2026 04:21:38 +0000
Received: from gomati.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 22:21:35 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <bp@alien8.de>
CC: <x86@kernel.org>, <babu.moger@amd.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, <thomas.lendacky@amd.com>, <santosh.shukla@amd.com>,
	<nikunj@amd.com>
Subject: [PATCH] x86/cpufeatures: Add AVX512 Bit Matrix Multiply (BMM) and Bit reversal support
Date: Thu, 5 Feb 2026 04:21:05 +0000
Message-ID: <20260205042105.1224126-1-nikunj@amd.com>
X-Mailer: git-send-email 2.48.1
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000AD81:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a6fffb1-b56e-4b59-8382-08de646e0e9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?46gXkoB/YFDhTsEU3U0fzfzzgX6ijBT1TZoGPfmaE92DQy9bOZzduM9UjvM1?=
 =?us-ascii?Q?CjmYmMfLxWP+YaLZN+kqp0EpFns551Ej8q77DN0b+JFRtRqod4mW9Pxvd3lx?=
 =?us-ascii?Q?02GSMRK2OR6SYuXBySwj3hj2tMmwkohVJta6a4bnvmEHwe7czQOmuJBLLLtM?=
 =?us-ascii?Q?WpYqhz/x6EBcnOEN9DZEVKDZtYjrn9ABheUHJcdqJurDz7oqKRlq32uKZ8Tr?=
 =?us-ascii?Q?eJK41lZvHnlgCLLfX5PJbcBFwxMHFbC7IadZeKFMWORjdoCmg5o7CACf+RMR?=
 =?us-ascii?Q?ZAkifWtMUFp5kM4qsBGVJh1H2l1gncL50mvk996K7q2iy2TV2p+rIUr8QUBR?=
 =?us-ascii?Q?oOGbUrDTOIVmin74onk4l1kQiWVteseUelMhh1cEihOzqYwI4ZK5ZVLbQw9y?=
 =?us-ascii?Q?pCQPoIq3KplSg2MCPJBusYehbWv1KfMmj7SICbso6fjdPQWrF14gNJ7LzGZ0?=
 =?us-ascii?Q?NNdQrQ8L4rgFjfb22RhKjmQpRMyeP0WDDdco5LiczSq8lNqynrofgLMCa/Oa?=
 =?us-ascii?Q?SE7WMTA5quK+mQKGn09jhV/IEp3NeYAbt7yRsq/dZRL6NKxTCR9IQ0UhAL4p?=
 =?us-ascii?Q?e6YX36rQZmIWpCp913SsGgGdM1Dvtv2g/WjSHMy/nMHqEgteF32b2O9Umo0u?=
 =?us-ascii?Q?gP9R2r3uYbHkXmesnERPanEZ8mEupmG2tKzDRQjCrOGCMsKiM1KNSWLhdttU?=
 =?us-ascii?Q?mWDQcMEnMLIsgj8Zp+g/iGf6eOuNDbwyPzjaW00JABYq5FBLHpjVRhJ4bKuH?=
 =?us-ascii?Q?6bj5EMamwB85269TotZ2FR6ygJ67ItCGXUETA9m0jNL3GJk0TunIoMJUEl3g?=
 =?us-ascii?Q?dVj10ZdJejSazNZRgh92xUtOt7EaZflBwtSe4VzLNl2sE0X/6+x89P2lEH20?=
 =?us-ascii?Q?m1KdjwvKIhE/2hHOYc7Jfe7QmYAtOOLSaXqTN+BmyrlaGc1ISUkwYWZjP5dE?=
 =?us-ascii?Q?NZOj6V0FwxjTOkN1aLkWX38dftb2tSdLdAkvx2yT3LJGjgsTu+wTOjE+W0Pj?=
 =?us-ascii?Q?OGOhascoq6bdpZ7dg6srhK+5jtlNoKcB1hEIoMytZsj5qpoI0/j7yF2Fm/6w?=
 =?us-ascii?Q?5CK76++JvQojnhLFDcxh3Rxm+e1yi3QjXYL9ECpxYm14ZMayECs/c16/HPgs?=
 =?us-ascii?Q?16nKD7i4EslCB/Zjez2iVBCypIE4kigBHAvNR+OvSpvg3pxe/VIPIOpQvsWh?=
 =?us-ascii?Q?Afmz0i16AVxH9QXiaI6sSoD04dBiQzrVoEDfpQAywKa5nYH+o7bOrfvRCfmr?=
 =?us-ascii?Q?JAnRDbcQ1CNkv0AdvaIleCjC7Ff9chsIsE5bvsAV9N03jlBKNHj2kqqgL1As?=
 =?us-ascii?Q?+6XW9QaHAhBRULERGk+uorIvsEQt+UYlgxaHjXPBgUf8rRJ8N48cw+U7T5Hu?=
 =?us-ascii?Q?ZZhGkIabMZkocBc9Lme4o7+oDSYLw4fuSmLKrtNXoGlKCs17Lkg0o/kZhvq2?=
 =?us-ascii?Q?apFxj0Nd/F/nVnctVBuFFS+2OO7ZHs//b9pCgcI0g4t3AhTl5ITlPMEWxTm/?=
 =?us-ascii?Q?2dZYbEQODreQc3NDFppTN9O/tFGNC4ocFws2e01pqKaJxNiwYO6UiJHFUAhb?=
 =?us-ascii?Q?MnkXG/uddNUfu531Y0EN5IFCUgxUScF8gjAObjk6l686JtZcT0K8mCZUjR7X?=
 =?us-ascii?Q?zP4Dddda64V0HVmF77ybIXk+sus+ldjiyGsg4h8IAWri72Ph6fVeTmNLqtMd?=
 =?us-ascii?Q?9AQnmA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	aLcwgMAOxNzRr90lQS+c0h3Gvc4dRNL/9c/PQB5P3bs5Z4x4IY0ViDnSrASCjVn3hrVEqldc2V9CBR3RZxcXLL5eW6eeQzPiTtB6/UcWTIGVmnEkGeZZ7JNi/fal/8By2WhDUvJO4ec5EM2Hbn6fnxFA1yq4XzjF/Ta5BEblSyo72eYrVGMlfRSWExrABPbTVhAl/3nJl3ZtJMVa22md5aP2KCcMNUZNwhYKbIpT8EmBoQf4mdXRT/bffjJOLA1tn2ZZTTG7+ctEHoQcdRmqoyTvC6hTaumYkf/aw88sryFSkOxQ34jDgShcFm/iOIiT0RF5wK9CVc1izXBE+CdF+VDqe0STwvsdxXivOGwkLZUQZrbWElwKeTZ7HY/9Jr9PPQm+EqRqwhKjQwcF7NnatePrP54Pdr1NnLVM4Xq1R90YfAGiJPu65LOZFnWueYa6
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2026 04:21:38.7094
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6fffb1-b56e-4b59-8382-08de646e0e9e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000AD81.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+];
	TAGGED_FROM(0.00)[bounces-70293-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,amd.com:dkim,amd.com:email,amd.com:url,amd.com:mid];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nikunj@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_NONE(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: EA968EE824
X-Rspamd-Action: no action

Add support for AVX512 Bit Matrix Multiply (BMM) and Bit Reversal
instructions, a feature that enables bit matrix multiply operations and
bit reversal, which is exposed via CPUID leaf 0x80000021_EAX[23].

Expose the support to guests when available by including it in the CPUID
leaf 0x80000021_EAX feature list.

While at it, reorder PREFETCHI to match the bit position order in CPUID
leaf 0x80000021_EAX for better organization.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---

AMD64 Bit Matrix Multiply and Bit Reversal Instructions
Publication #69192 Revision: 1.00
Issue Date: January 2026

https://docs.amd.com/v/u/en-US/69192-PUB
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c3b53beb1300..2f1583c4bdc0 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -472,6 +472,7 @@
 #define X86_FEATURE_GP_ON_USER_CPUID	(20*32+17) /* User CPUID faulting */
 
 #define X86_FEATURE_PREFETCHI		(20*32+20) /* Prefetch Data/Instruction to Cache Level */
+#define X86_FEATURE_AVX512_BMM		(20*32+23) /* AVX512 Bit Matrix Multiply instructions */
 #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
 #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
 #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88a5426674a1..b36e8f10f509 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1218,11 +1218,12 @@ void kvm_set_cpu_caps(void)
 		F(NULL_SEL_CLR_BASE),
 		/* UpperAddressIgnore */
 		F(AUTOIBRS),
-		F(PREFETCHI),
 		EMULATED_F(NO_SMM_CTL_MSR),
 		/* PrefetchCtlMsr */
 		/* GpOnUserCpuid */
 		/* EPSF */
+		F(PREFETCHI),
+		F(AVX512_BMM),
 		SYNTHESIZED_F(SBPB),
 		SYNTHESIZED_F(IBPB_BRTYPE),
 		SYNTHESIZED_F(SRSO_NO),

base-commit: e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
-- 
2.48.1


