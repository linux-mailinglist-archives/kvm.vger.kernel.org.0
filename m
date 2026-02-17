Return-Path: <kvm+bounces-71179-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mII1CgnLlGluHwIAu9opvQ
	(envelope-from <kvm+bounces-71179-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:09:45 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 80D1114FD5A
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 21:09:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 905683043AE3
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 20:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98FE37881F;
	Tue, 17 Feb 2026 20:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BGW+vX3J"
X-Original-To: kvm@vger.kernel.org
Received: from CO1PR03CU002.outbound.protection.outlook.com (mail-westus2azon11010019.outbound.protection.outlook.com [52.101.46.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD5E2C3255;
	Tue, 17 Feb 2026 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.46.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771358980; cv=fail; b=n1sj/skxgm58HxL0OcoZOzOXOXxjtRPbp7L0yiTO33Rwdnpwu1V0pYXkINiiOgzEyQ+MrvwJP6+nZ7eaQzEEvBhHuOSjuFgUNVaS4i7P44u7NhGklqQCZ9GOoTQ5JskyAR6ElZ1D2vU/QdZk19oqqEbbqQgCz4wupyPwhwtHIwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771358980; c=relaxed/simple;
	bh=42iAD4yNR0BHytSVc0BwrwEATm9HNltn86vyDwCRC+0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sSVTcB/tvi7QMFi1OX2LmCOeLsvfXWiJfvQYquUH5prLqhBdmtp038A/Wm242SjggRcrD+s6ABhi2aqI5eD5lL/nKNLCvvsmvwZXbJOg6ecP3nuMLNMd4zQ2OcZ4zo/OHHJ8oUfaSWsNJ07DfajRMb8JqbmhSgoCS6vg4K7ypRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BGW+vX3J; arc=fail smtp.client-ip=52.101.46.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DkxSIvhJvgNNByS/HRfVreVfqchFj40A7AkDv2Bdv5Iv/zoD8eG2gEgGN9YZnF8Gf+DlmMZs4XpOaf0u8CMB9XrlhB2ZzkmpoP6HuYjfsTWoJ1jTyS99withS0fNPDEUhnx7W/H8q5DhKFry8eYzNOJVM76ZO476hSc5r09baCkau8uoTwHDgv4uyTBN4uJUDJxVuc2GCIkyH+ZCBC7qAvhwV3fk3Ox2CIbka7dD9m8/DOigQj3cYUicTcZF3gvC6clWXILRHKPhzkox0gvOdWtBfxVXiXl8HaNXw/wj9uK6G5DgzEYh8fBr2KRNRe2pUD48FuP+DOinO9hUCmhcGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2XoWPMZjBR56Mc1kgY1SJsdsppsFl/AmWTP5xZdRzY=;
 b=mjBhz19eU6U6LVlP71nbJ9xrXMRyAGi5ln1TiNs06oNt6fjEXChoFb1GVlpHWtmByHEexPDbuomz7WqelqYS5rw0tabLo45g2wf18+8MxMT2sLswDxXLzBVp3bof5PRbQgEctwlJo0XoRnQSE9JR+3TFcK2noJeHVD/rCYUxbxkDPWHREM69qHgmSrgn0xBwDOIoQs9S7oO1dLaCN2EIYvNHN/wZ/lA2ETb16HXIOKVzeq1c3/MaDG9kKCFjq+B5U+Yo4l7Z9bQ8LWmRnPNMgjtfvyTT5Rc4hTdYHgWC3Rc+QfQZj2ObupDOb7ubSZLb0J/E9ykTJpts+DaE3z6Tzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2XoWPMZjBR56Mc1kgY1SJsdsppsFl/AmWTP5xZdRzY=;
 b=BGW+vX3JvyFRo/nZKpqZqdZ7xwhKafE+7MOMVH0dXZFcJvsjfjku1P7NHS7JEWv2pnIaTQaN8adAcosoCuNRYkVRa2POvki2pPwe+shiXolFtJyW1e3ZteoiUYrHbSbckHJla17+6wD1fwtUrH3nHpKGN9kcyHkL/bihmhZ1wG8=
Received: from MN2PR11CA0025.namprd11.prod.outlook.com (2603:10b6:208:23b::30)
 by PH7PR12MB7916.namprd12.prod.outlook.com (2603:10b6:510:26a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Tue, 17 Feb
 2026 20:09:33 +0000
Received: from BL6PEPF0001AB58.namprd02.prod.outlook.com
 (2603:10b6:208:23b:cafe::90) by MN2PR11CA0025.outlook.office365.com
 (2603:10b6:208:23b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.13 via Frontend Transport; Tue,
 17 Feb 2026 20:09:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF0001AB58.mail.protection.outlook.com (10.167.241.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9611.8 via Frontend Transport; Tue, 17 Feb 2026 20:09:33 +0000
Received: from nigeria-2635-os.aus-spse (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 17 Feb
 2026 14:09:31 -0600
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
Subject: [PATCH 1/6] x86/cpufeatures: Add X86_FEATURE_AMD_RMPOPT feature flag
Date: Tue, 17 Feb 2026 20:09:07 +0000
Message-ID: <6e004cd8c4deb4660bc5887309fc64aece0a5b25.1771321114.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB58:EE_|PH7PR12MB7916:EE_
X-MS-Office365-Filtering-Correlation-Id: c8303793-5cda-4e3b-25fe-08de6e607750
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|7416014|1800799024|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mxfLN0y69GFq8z1MB/57h/uMt533RqiaQ9C9nlQDOIehiBUWzGWl1E3gKWVG?=
 =?us-ascii?Q?BcpYK786WEiQEiRfUeKcfDUqVMCGj+H2jXg5SNSus3LV3TmOuQrluR6EPWwB?=
 =?us-ascii?Q?bcCXFuczkMWl0sWOmrzUbJ1GVv0GVrNFeN7l7jNml0NNitTN058/ljA/uI0R?=
 =?us-ascii?Q?0IomHV8jpwUSOJO97FWki3jYtA4zmYH5ZoIVdIXadaUKmxHmtRgaAZ9XL+Rc?=
 =?us-ascii?Q?6htzk8TdwAEaylfs6cSqeQ8PG8/t4KZ22xEdPSu4w+HkTb4kXMeHh8y/v1Bw?=
 =?us-ascii?Q?IkcnRn97DzEJQqGQCPXS/ccCsWAgyDQUFCZKkL2TX/99h4FOk3aBEDKG2zfI?=
 =?us-ascii?Q?1vy/B6G384aaFr2p340R8Pc9V7B8NrUYu2tdpSmhSbYgljhKmfj9PD/SUaDb?=
 =?us-ascii?Q?N2E5onmpJcIxpxIpoAijmua9tOtYe2xZ7qbAH0up9/gSAc2y9qVInnT+x/Te?=
 =?us-ascii?Q?tMBYSUENkjwU/kFIJhoYAG2PmHB9X+FzwAwya3GbRDP/7hAkyC8E8DW3b18d?=
 =?us-ascii?Q?uCH6F0h4pmurALZ3RviM26cVdDhQyHHwP6GNA7dcnu8lMe3jWPIv9Pv19qGZ?=
 =?us-ascii?Q?O0O8oPDCnwpW+vQQs2YdK84Q9XCbM1Rfhp5M6M9Lc0VvyAorblOoBiDdHcJ1?=
 =?us-ascii?Q?xX6waafaO0PAxJmEZrD5MCVj6A+s47OR6eFW3noiymLgq9iWVvBeFfG4lOfm?=
 =?us-ascii?Q?g2Fd+mWB1zXvwHHDY9cHsvEMSN4JsGkhVyOsi8OyrkE9CpzfymRLUPzOF9ou?=
 =?us-ascii?Q?wspQpmmsAFLbkoDjESoc2fmvGTQ6M1V5Gie0yo+cQqBv7sFS7HvP3nRsRPyh?=
 =?us-ascii?Q?MpNuxnhvvOX7noopsdz6Ggs5wSRYj6GdvFiIX7BBhpiaQXpg/3nPpwUxm7h5?=
 =?us-ascii?Q?+ZTKwrt4RnldDWWPd/X83plbwyVLONED8zzeExhZh+7OaFrrHxHCG1At5iIl?=
 =?us-ascii?Q?vSyyHZ88KQXMwOUzSYA//AzA0uEIIkyYOtJW7giyxgsq9t8cu9P79SS79319?=
 =?us-ascii?Q?e8VameqaEOQO+SmIxMsjW8wNLYDCfgqOeYoxsHFecEJAwNNk3pJIzxGsf7sE?=
 =?us-ascii?Q?dr+AuK5CGeUniVOlgIzV+HyeJ2uYPHjq4jddhhs4vnVkkTS3UfEvq+7kSIQ6?=
 =?us-ascii?Q?nXCAhlZEY0YqyASCsrnR2SQ/dgoT5AQdWHa4CT5fx4kdsa8J9cAnODLs1aet?=
 =?us-ascii?Q?aKXM0tvWj9ARFMQ+QoNSraXTA7fGBYzNJNKnK647r2eK7YsL6Yj6n1F2QT2q?=
 =?us-ascii?Q?qEj+AMPikxcOHTNd9Uk2NM3QhD1bKGDjyoirkIkEhiefAEkMp9TJ9DqCQH21?=
 =?us-ascii?Q?H0iGHuOnObiKroinSKTjYyMizrscz6kEbRpe9oucpOI8vmBBjscaH5Ws2ZX6?=
 =?us-ascii?Q?3Ugpb68pg4r8PwxWFL4BwBxFfrp+XKX9wBYsLpqK6ftC9zbEJUoqKKDCpzgr?=
 =?us-ascii?Q?qNLgCiU+ZBoeSr6WySkJZorbQBQwY1i0fhq6ZdjwQ34o2LGH5Vp8K+kvvRo/?=
 =?us-ascii?Q?TZAK07UKyBL6fvR5j/YfIcbGJVOvFQoz1oLeJqLFuZtkCCbUyC+UV1Yijp9M?=
 =?us-ascii?Q?pnt/6w/iqeH2+2ujdZ8l1WRmqjf1v+RXdPB7c62GcHX4sXCXoe4KU4kQmj4H?=
 =?us-ascii?Q?Ru41koHVCx4d/swtkWNJixI6KJfLR+mYpGgpXzSrRGRFF3nqqR02czVSBp1+?=
 =?us-ascii?Q?sR8b7w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(7416014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	1lfRBswbFYA6YOLE163xQHue+sgXtCct3QFVKzPOsZbinwtPsStuZRgFpkSLqpwTAKdXSrnlN//EZLLsYaF4/GY6l5vciRn3MMDckmJqrtFsY5Ld28mT6s7LuQHeNq0CjCIpxxtpD7gt88XZgpkhw/Bf9OU58AL1YLnqIrJFvoI4owzHhwKOVz8RgkFxKVslUkheuquDYAAyWOJFcBqTSwXccQa9TBnYgPdP18E5lw0hBdKeacU6ExDM3NUuumbItqK4kH9Q5zkds2z5Ebipl1AKie+intbzTLaXAX2wBFbDSOEAsx6+bh7EugDnjVXfefwobzmPRcLKeUOwqxzoLPptB40E0Ke3FjEtAaB1F91+HsppWxZd1TVoTJQp8/3Mn9LR+JtzfSjWV+eWWGqZWv+ry/pI5RVAg1CAoErrVIhoUDM96/yQ3/WADJSY7tCq
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 20:09:33.0402
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8303793-5cda-4e3b-25fe-08de6e607750
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB58.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7916
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71179-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_TWELVE(0.00)[33];
	FROM_NEQ_ENVFROM(0.00)[Ashish.Kalra@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:mid,amd.com:dkim,amd.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 80D1114FD5A
X-Rspamd-Action: no action

From: Ashish Kalra <ashish.kalra@amd.com>

Add a flag indicating whether RMPOPT instruction is supported.

RMPOPT is a new instruction designed to minimize the performance
overhead of RMP checks on the hypervisor and on non-SNP guests by
allowing RMP checks to be skipped when 1G regions of memory are known
not to contain any SEV-SNP guest memory.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dbe104df339b..bce1b2e2a35c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -76,7 +76,7 @@
 #define X86_FEATURE_K8			( 3*32+ 4) /* Opteron, Athlon64 */
 #define X86_FEATURE_ZEN5		( 3*32+ 5) /* CPU based on Zen5 microarchitecture */
 #define X86_FEATURE_ZEN6		( 3*32+ 6) /* CPU based on Zen6 microarchitecture */
-/* Free                                 ( 3*32+ 7) */
+#define X86_FEATURE_RMPOPT		( 3*32+ 7) /* Support for AMD RMPOPT instruction */
 #define X86_FEATURE_CONSTANT_TSC	( 3*32+ 8) /* "constant_tsc" TSC ticks at a constant rate */
 #define X86_FEATURE_UP			( 3*32+ 9) /* "up" SMP kernel running on UP */
 #define X86_FEATURE_ART			( 3*32+10) /* "art" Always running timer (ART) */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 42c7eac0c387..7ac3818c4502 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -65,6 +65,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PERFMON_V2,		CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,		CPUID_EAX,  1, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_PMC_FREEZE,	CPUID_EAX,  2, 0x80000022, 0 },
+	{ X86_FEATURE_RMPOPT,			CPUID_EDX,  0, 0x80000025, 0 },
 	{ X86_FEATURE_AMD_HTR_CORES,		CPUID_EAX, 30, 0x80000026, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
-- 
2.43.0


