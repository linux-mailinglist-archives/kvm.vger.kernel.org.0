Return-Path: <kvm+bounces-71181-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eFpuN1PLlGluHwIAu9opvQ
	(envelope-from <kvm+bounces-71181-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:10:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A0E3F14FDB1
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:10:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 272703046F1A
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF40E378822;
	Tue, 17 Feb 2026 20:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yVmJqqea"
X-Original-To: kvm@vger.kernel.org
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010041.outbound.protection.outlook.com [52.101.85.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C6B37757B;
	Tue, 17 Feb 2026 20:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.85.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771359034; cv=fail; b=Vs3RtQFwB2EZbQkocBJO1VZhMFS75nmGSs+/6rY8Z2lXj1n5tZXvPgSbFU3ib6+5VBRT4/QQPAt6a4wUjMg/vYHWPqcp4k2P0ESWpZAMEPgzXVsipzBevA4mS9twZWKBZzyWbWsEq9zwJuMbUbnsV2JvMgEKZDhztHrrcQb47ek=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771359034; c=relaxed/simple;
	bh=aTwkGrCwDZxhKyNyWn/R5Mt581M9gH6qa3D+9h8BwAA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pVcBOFfL6bbckEc3XHlnl7ecNBlberu76Mehp8osrD31Nk6bnkG/9NzX9FNdRjBsvgTSDsZVlk/+8wbF3ypgQ+E6msAjBJ/mwuETAXEUU3+Y6dtwhCwjVZBDF4luAnSjny61D0gwWYCMjNm5+FjW69CEWc93IIdCz8ePogHSPeo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yVmJqqea; arc=fail smtp.client-ip=52.101.85.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eA7RCHnEL6gmxV1gTGUxxA84kyzOFIrX2DCtMRqWKaImPyePFg1TWO9nuDpxY+kU+v2BXPTYR7xJfPwxrx2/Zx8Aj0NH3ElRM53G5/v61L+X4BCT6KtfsAhAmIcb+oYUnyNYw7tPGFLh0l8a6Vcr7MB9yXqB/8G1Zsci9avOLobQVRhkFjLBBjZT+pCpvUUEajGIiupSXonmUgTBObGbq6cb5Bw1RKIZ73ZnGx4geeClx/Di214yv0fz0i9VfbeGFAVEq3D6Bn9roGvaqJjICenEWFA3eyEzc8cZxI8FhsLbzgRJurBfWH5Bx/z312P1BGb5PmXFVkB8KI1GI/TgRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ls2hNN1ZZxjZgfEtQ1PCr5cJVtEhFB6Wo6P3T30CpqM=;
 b=pxynAgq4eiBNv++QZwkVyn6SQubGkdhFTZ8um9u1ISss1mB5JKhgT6qiiLzzxJ+xG8siHgGSMPK32r7ABeWdVB5MXYsm8nNl8JGTbrj4La7ZWfeqHUGMa5CH4SzlpsCYagFqb3PBIPyAEBxmOGhfrIt3SXFrTZRVox1tqG5Uy6E8AN0diwXkGBUgLIhSdFnO4z3fV8sn1PKGZUdxcVEhA9QkTPEPcwXtcYdrOJn+gmtPeia4Yoe7qRhzV5GLofoEIiZCg2WbykZl8MJG6I5af7gfndP0osxgi+7SQ8YE8DBTvH5lWDeadqrvT14wZliX1KT2VhAi+1KbDy9XLPVDnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ls2hNN1ZZxjZgfEtQ1PCr5cJVtEhFB6Wo6P3T30CpqM=;
 b=yVmJqqeabFk+oS9RQuED+9ZlGL3F7f151vjJPDiPMojeuXhYk/rLqlPTcgpATmwnVqEKK/EmJWDAKtfh3uWNNJMYak9xnM125cG/HVxGLTMgV83zneruw9gnXRkPKFIcjcxlgy2CpSjfBJqaHTOGNEttTvrZ4RkP5mn9znETm5g=
Received: from MN2PR20CA0058.namprd20.prod.outlook.com (2603:10b6:208:235::27)
 by DM4PR12MB8497.namprd12.prod.outlook.com (2603:10b6:8:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 20:10:25 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::32) by MN2PR20CA0058.outlook.office365.com
 (2603:10b6:208:235::27) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Tue,
 17 Feb 2026 20:10:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Tue, 17 Feb 2026 20:10:23 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 14:10:22 -0600
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <peterz@infradead.org>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <ardb@kernel.org>
CC: <pbonzini@redhat.com>, <aik@amd.com>, <Michael.Roth@amd.com>,
	<KPrateek.Nayak@amd.com>, <Tycho.Andersen@amd.com>,
	<Nathan.Fontenot@amd.com>, <jackyli@google.com>, <pgonda@google.com>,
	<rientjes@google.com>, <jacobhxu@google.com>, <xin@zytor.com>,
	<pawan.kumar.gupta@linux.intel.com>, <babu.moger@amd.com>,
	<dyoung@redhat.com>, <nikunj@amd.com>, <john.allen@amd.com>,
	<darwi@linutronix.de>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>
Subject: [PATCH 2/6] x86/sev: add support for enabling RMPOPT
Date: Tue, 17 Feb 2026 20:10:11 +0000
Message-ID: <7df872903e16ccee9fce73b34280ede8dfc37063.1771321114.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1771321114.git.ashish.kalra@amd.com>
References: <cover.1771321114.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|DM4PR12MB8497:EE_
X-MS-Office365-Filtering-Correlation-Id: 718e790e-b86b-4d68-d6e1-08de6e609545
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xuQAxLfgmCRPH/gr0lfkscrW/S+N17A92d37iUacC4flEtACcNBs1YFTueA5?=
 =?us-ascii?Q?FTh/CpnqLilDNY926JZmL6hcxsHkaiCsDRmTWcj/PYV4bGnJaBwX6ShkvcFy?=
 =?us-ascii?Q?C0I+A62XryH3dzS7e+tcTi7egPojhz0XNQDku75J6R8R3zIdpO1gbpFwxbCZ?=
 =?us-ascii?Q?OR2QMXcq+jZ7hyeU8rhALMRko7LhQKRSyY5JI9IZVdeAW3Eype0FBSIVVq2y?=
 =?us-ascii?Q?zlRATc70mq6AHQdfgk2LAkqR9wGZiPSDSnKszRqruqUTjgQNVOsuD+LeNRss?=
 =?us-ascii?Q?1FjmQlSbvw1kK5d+5MxXuqOSSZlltGt+ZLAdD1HysE1Z2g/e9SCEuycVq8HA?=
 =?us-ascii?Q?ADrEGcCzkiNe+9Se91hr5YNHbANRJYxzw2rNNsfSIJ6vp2Lgmy2KsUxJl7/c?=
 =?us-ascii?Q?LUTiMdQgoDYjI+5WPZvjSAOcYolBUpSvgtEK7za1x5lilfmb3Gl4aIE00Sol?=
 =?us-ascii?Q?SEn3PUKDiu4ghgMvRnZtsOtBK2GYOeFwab/8pi+GT7i0+hCjsA0BZb1pzXM5?=
 =?us-ascii?Q?ZkryY58zQ2Fm6imCAdYNbuvKy90PnWtTLzQBqpWTnniCrrzjKli5mJQcITEN?=
 =?us-ascii?Q?DcDj+DQac2MYpDpxLOqsZqLhadM8oIlccUaXbk8TnUpcBYTyLgG2KS5dyz3K?=
 =?us-ascii?Q?DulZFCHkSVRMhmkb/DmqpvemZbcQJNPS0JzBhNt/vu1iQhEjuU5Mk93+Huds?=
 =?us-ascii?Q?G8Y+pfowLfYx1cgybir+w8Fu/fvHaWqKnBbrtavzrRKybc/Gi2aQ13JLwgwg?=
 =?us-ascii?Q?+mG5GIyFSp+kHyj8CcnuURp2Dgq199x3BbutaroByGxQoWk67+kCdP8KjrYA?=
 =?us-ascii?Q?d3J3floAmGyi+7lk53DjoMj/C/pv6uocL4QQB8pNtb+IpGMKOdK4X8CHIvs4?=
 =?us-ascii?Q?ai+QiId6AU2qGF7fJIynCr1TzcJw+lTECLlffWUezQit4hqX1yYVghxeRJuF?=
 =?us-ascii?Q?WeO6mNYkgLQa4nAOrIoYBVWQ/tZM6I27k3iMa/cjpejDucfeF1Lm1YELOaw9?=
 =?us-ascii?Q?0cWRs57PGHYr2Y76kCdDpHzke6s11s5GMpO5nvX1MyUF/5y0dL6ARxS4KBSD?=
 =?us-ascii?Q?UoxsR21WEifmUZmvY5Tyelvf4kulC884VTjHC5sgRpm4yHDvV8caL77KWRwg?=
 =?us-ascii?Q?kbG0g0cf3pahUarl01C3AWRn/5NhDbfRL9QMXzXifZW2f7nnxWAyHBeUdies?=
 =?us-ascii?Q?tw3eDa0C8t80NpDbe5t+0JDKR+vUjVRUNkpjIRiwUJfxJcGGKGZR4S8HBDKW?=
 =?us-ascii?Q?1UJqJfeVaUlG5TcFrdOtcrkszsuezf91YBAzE8AO6OJsh7Bd40fpgB1QPvw5?=
 =?us-ascii?Q?19eH1eHxLICe0bev+HIxT5549m2QY6fjtgqbLNp8ncsaL7pI1IGeRHOtFWY5?=
 =?us-ascii?Q?t36ZN9SrYYR9Hz8P+gYfPBfzL8kV461eH1UMSkCz39yINSRu5DIJX7IBJ4VT?=
 =?us-ascii?Q?H4z7QBfSc6Zz8YA9BQPvlUazROgRz93F8pBWjvJwxSnJkydTyuQCkTkTfnTB?=
 =?us-ascii?Q?spKaP3Ys/11M2UeLbfws/FitQw6/zBILVT2D2nW6sfIGTOwDu8xK8pzzZruN?=
 =?us-ascii?Q?evCAusz7kVm1ZpFO9vOjzbpZ0T9mZmCxDsTar48S2pgXhNURNN7WZrS6Ll97?=
 =?us-ascii?Q?Mg+70TCnYUSXM2q1jKT2zyHhfQcpet6yKcV/Oab0jmHgLM8dn3Hfo3JB+WHo?=
 =?us-ascii?Q?RAewBzEUaGNtRUH+VyqL0t4S9TQ=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	su9fFWi7xXb69oDXzTBjZThIdkIbF4rqnidNTQKYLjHav3m7MPq/s+LxW49YjTMkMND30lTH85Zr5OFdnzMxB0JQy1U84YL/TA20YjV6YHZMS9NI1F9jRpddMO00daU0RIzH0s7N9z9LDtF3ms1s/eHaTW3+zMKfYccvZfpnMe1fNwJagXVxpw87J59AolmaG43o8la36eGVcYxlS+/ymzXBcxOW6fmPvCw2gg6sF6pcwC5A8mw+piN/271PQqGKTPUzFEHtumBf9INdgIlMboyIzHeIUKlvzSR2z2/FAZT1DVe+aczai8vxMjuqWIcqmR4oRFlf88kYB29FvA2cGjnWNjAUYjH0l3yHXbDtZC3e59FebasHjzoU6SrSdNTfFn8LIvo6F01wSgUV6fT2VLpLBaKAJ8rq6Xb+kmbGzdVZrZaoQzqwNipLZEWZECAB
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 20:10:23.3127
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 718e790e-b86b-4d68-d6e1-08de6e609545
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8497
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71181-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: A0E3F14FDB1
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

The new RMPOPT instruction sets bits in a per-CPU RMPOPT table, which
indicates whether specific 1GB physical memory regions contain SEV-SNP
guest memory.

Per-CPU RMPOPT tables support at most 2 TB of addressable memory for
RMP optimizations. To handle this limitation:

For systems with 2 TB of RAM or less, configure each per-CPU RMPOPT
table base to 0 so that all system RAM is RMP-optimized on every CPU.

For systems with more than 2 TB of RAM, configure per-CPU RMPOPT
tables to cover the memory local to each NUMA node so RMP
optimizations can take advantage of NUMA locality. This must also
accommodate virtualized NUMA software domains (for example, AMD NPS
configurations) and ensure that the 2 TB RAM range local to each
physical socket is RMP-optimized.

Suggested-by: Thomas Lendacky <thomas.lendacky@amd.com>
Suggested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/msr-index.h |   3 +
 arch/x86/virt/svm/sev.c          | 192 +++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index da5275d8eda6..8e7da03abd5b 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -753,6 +753,9 @@
 #define MSR_AMD64_SEG_RMP_ENABLED_BIT	0
 #define MSR_AMD64_SEG_RMP_ENABLED	BIT_ULL(MSR_AMD64_SEG_RMP_ENABLED_BIT)
 #define MSR_AMD64_RMP_SEGMENT_SHIFT(x)	(((x) & GENMASK_ULL(13, 8)) >> 8)
+#define MSR_AMD64_RMPOPT_BASE		0xc0010139
+#define MSR_AMD64_RMPOPT_ENABLE_BIT	0
+#define MSR_AMD64_RMPOPT_ENABLE		BIT_ULL(MSR_AMD64_RMPOPT_ENABLE_BIT)
 
 #define MSR_SVSM_CAA			0xc001f000
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index ee643a6cd691..e6b784d26c33 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -127,6 +127,17 @@ static DEFINE_SPINLOCK(snp_leaked_pages_list_lock);
 
 static unsigned long snp_nr_leaked_pages;
 
+#define RMPOPT_TABLE_MAX_LIMIT_IN_TB	2
+#define NUM_TB(pfn_min, pfn_max)	\
+	(((pfn_max) - (pfn_min)) / (1 << (40 - PAGE_SHIFT)))
+
+struct rmpopt_socket_config {
+	unsigned long start_pfn, end_pfn;
+	cpumask_var_t cpulist;
+	int *node_id;
+	int current_node_idx;
+};
+
 #undef pr_fmt
 #define pr_fmt(fmt)	"SEV-SNP: " fmt
 
@@ -500,6 +511,185 @@ static bool __init setup_rmptable(void)
 	}
 }
 
+/*
+ * Build a cpumask of online primary threads, accounting for primary threads
+ * that have been offlined while their secondary threads are still online.
+ */
+static void get_cpumask_of_primary_threads(cpumask_var_t cpulist)
+{
+	cpumask_t cpus;
+	int cpu;
+
+	cpumask_copy(&cpus, cpu_online_mask);
+	for_each_cpu(cpu, &cpus) {
+		cpumask_set_cpu(cpu, cpulist);
+		cpumask_andnot(&cpus, &cpus, cpu_smt_mask(cpu));
+	}
+}
+
+static void __configure_rmpopt(void *val)
+{
+	u64 rmpopt_base = ((u64)val & PUD_MASK) | MSR_AMD64_RMPOPT_ENABLE;
+
+	wrmsrq(MSR_AMD64_RMPOPT_BASE, rmpopt_base);
+}
+
+static void configure_rmpopt_non_numa(cpumask_var_t primary_threads_cpulist)
+{
+	on_each_cpu_mask(primary_threads_cpulist, __configure_rmpopt, (void *)0, true);
+}
+
+static void free_rmpopt_socket_config(struct rmpopt_socket_config *socket)
+{
+	int i;
+
+	if (!socket)
+		return;
+
+	for (i = 0; i < topology_max_packages(); i++) {
+		free_cpumask_var(socket[i].cpulist);
+		kfree(socket[i].node_id);
+	}
+
+	kfree(socket);
+}
+DEFINE_FREE(free_rmpopt_socket_config, struct rmpopt_socket_config *, free_rmpopt_socket_config(_T))
+
+static void configure_rmpopt_large_physmem(cpumask_var_t primary_threads_cpulist)
+{
+	struct rmpopt_socket_config *socket __free(free_rmpopt_socket_config) = NULL;
+	int max_packages = topology_max_packages();
+	struct rmpopt_socket_config *sc;
+	int cpu, i;
+
+	socket = kcalloc(max_packages, sizeof(struct rmpopt_socket_config), GFP_KERNEL);
+	if (!socket)
+		return;
+
+	for (i = 0; i < max_packages; i++) {
+		sc = &socket[i];
+		if (!zalloc_cpumask_var(&sc->cpulist, GFP_KERNEL))
+			return;
+		sc->node_id = kcalloc(nr_node_ids, sizeof(int), GFP_KERNEL);
+		if (!sc->node_id)
+			return;
+		sc->current_node_idx = -1;
+	}
+
+	/*
+	 * Handle case of virtualized NUMA software domains, such as AMD Nodes Per Socket(NPS)
+	 * configurations. The kernel does not have an abstraction for physical sockets,
+	 * therefore, enumerate the physical sockets and Nodes Per Socket(NPS) information by
+	 * walking the online CPU list.
+	 */
+	for_each_cpu(cpu, primary_threads_cpulist) {
+		int socket_id, nid;
+
+		socket_id = topology_logical_package_id(cpu);
+		nid = cpu_to_node(cpu);
+		sc = &socket[socket_id];
+
+		/*
+		 * For each socket, determine the corresponding nodes and the socket's start
+		 * and end PFNs.
+		 * Record the node and the start and end PFNs of the first node found on the
+		 * socket, then record each subsequent node and update the end PFN for that
+		 * socket as additional nodes are found.
+		 */
+		if (sc->current_node_idx == -1) {
+			sc->current_node_idx = 0;
+			sc->node_id[sc->current_node_idx] = nid;
+			sc->start_pfn = node_start_pfn(nid);
+			sc->end_pfn = node_end_pfn(nid);
+		} else if (sc->node_id[sc->current_node_idx] != nid) {
+			sc->current_node_idx++;
+			sc->node_id[sc->current_node_idx] = nid;
+			sc->end_pfn = node_end_pfn(nid);
+		}
+
+		cpumask_set_cpu(cpu, sc->cpulist);
+	}
+
+	/*
+	 * If the "physical" socket has up to 2TB of memory, the per-CPU RMPOPT tables are
+	 * configured to the starting physical address of the socket, otherwise the tables
+	 * are configured per-node.
+	 */
+	for (i = 0; i < max_packages; i++) {
+		int num_tb_socket;
+		phys_addr_t pa;
+		int j;
+
+		sc = &socket[i];
+		num_tb_socket = NUM_TB(sc->start_pfn, sc->end_pfn) + 1;
+
+		pr_debug("socket start_pfn 0x%lx, end_pfn 0x%lx, socket cpu mask %*pbl\n",
+			 sc->start_pfn, sc->end_pfn, cpumask_pr_args(sc->cpulist));
+
+		if (num_tb_socket <= RMPOPT_TABLE_MAX_LIMIT_IN_TB) {
+			pa = PFN_PHYS(sc->start_pfn);
+			on_each_cpu_mask(sc->cpulist, __configure_rmpopt, (void *)pa, true);
+			continue;
+		}
+
+		for (j = 0; j <= sc->current_node_idx; j++) {
+			int nid = sc->node_id[j];
+			struct cpumask node_mask;
+
+			cpumask_and(&node_mask, cpumask_of_node(nid), sc->cpulist);
+			pa = PFN_PHYS(node_start_pfn(nid));
+
+			pr_debug("RMPOPT_BASE MSR on nodeid %d cpu mask %*pbl set to 0x%llx\n",
+				 nid, cpumask_pr_args(&node_mask), pa);
+			on_each_cpu_mask(&node_mask, __configure_rmpopt, (void *)pa, true);
+		}
+	}
+}
+
+static __init void configure_and_enable_rmpopt(void)
+{
+	cpumask_var_t primary_threads_cpulist;
+	int num_tb;
+
+	if (!cpu_feature_enabled(X86_FEATURE_RMPOPT)) {
+		pr_debug("RMPOPT not supported on this platform\n");
+		return;
+	}
+
+	if (!cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
+		pr_debug("RMPOPT optimizations not enabled as SNP support is not enabled\n");
+		return;
+	}
+
+	if (!(rmp_cfg & MSR_AMD64_SEG_RMP_ENABLED)) {
+		pr_info("RMPOPT optimizations not enabled, segmented RMP required\n");
+		return;
+	}
+
+	if (!zalloc_cpumask_var(&primary_threads_cpulist, GFP_KERNEL))
+		return;
+
+	num_tb = NUM_TB(min_low_pfn, max_pfn) + 1;
+	pr_debug("NUM_TB pages in system %d\n", num_tb);
+
+	/* Only one thread per core needs to set RMPOPT_BASE MSR as it is per-core */
+	get_cpumask_of_primary_threads(primary_threads_cpulist);
+
+	/*
+	 * Per-CPU RMPOPT tables support at most 2 TB of addressable memory for RMP optimizations.
+	 *
+	 * Fastpath RMPOPT configuration and setup:
+	 * For systems with <= 2 TB of RAM, configure each per-core RMPOPT base to 0,
+	 * ensuring all system RAM is RMP-optimized on all CPUs.
+	 */
+	if (num_tb <= RMPOPT_TABLE_MAX_LIMIT_IN_TB)
+		configure_rmpopt_non_numa(primary_threads_cpulist);
+	else
+		configure_rmpopt_large_physmem(primary_threads_cpulist);
+
+	free_cpumask_var(primary_threads_cpulist);
+}
+
 /*
  * Do the necessary preparations which are verified by the firmware as
  * described in the SNP_INIT_EX firmware command description in the SNP
@@ -555,6 +745,8 @@ int __init snp_rmptable_init(void)
 skip_enable:
 	cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "x86/rmptable_init:online", __snp_enable, NULL);
 
+	configure_and_enable_rmpopt();
+
 	/*
 	 * Setting crash_kexec_post_notifiers to 'true' to ensure that SNP panic
 	 * notifier is invoked to do SNP IOMMU shutdown before kdump.
-- 
2.43.0


