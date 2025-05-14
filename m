Return-Path: <kvm+bounces-46434-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E9AC9AB6400
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 09:21:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 765F016CA62
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 07:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE7F2080E8;
	Wed, 14 May 2025 07:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="m5UzS5QF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2087.outbound.protection.outlook.com [40.107.101.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12AF205501;
	Wed, 14 May 2025 07:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.87
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747207254; cv=fail; b=GDjXfcZ2M5ODsjUAdxx/3pKsrdSeeKoYbyurA3WBZFlKOcw+dI1aIt6v7LSblxOEpkHvk8nBSwEoRhzOp5i8NXbYwq5JHlRUQHOItthMqn6h7OMuavJIE1Ra1yzRd8M8p1rsr6ytq4u9BvaSkGMuR1vuCq/wGm99H1PjbmZGh4U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747207254; c=relaxed/simple;
	bh=J0frIIb/BQlFW2NWbPyjEZDeQc8pQ7PRD7CZKuNvEYw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ml8+OcEXt0hAonOgPjBSsa7VY0J9OX/AkkIP738q48Mc7Bm70BZMTVznwN65o0CcchjNAa/log4SpAv+PEIanU7GHeCoVeAVQMcXrGG/gtumdmHh/zVBo5qf5K4jxKiwWY+RgZ9Pe0iSVvEHwkqivugOU2xNJvpQ6+1tC8sqTHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=m5UzS5QF; arc=fail smtp.client-ip=40.107.101.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R2bD4fGo8MwbiLlbEjJaPcTWFpwRJLWkdDuOK1GJxqzb3ylJBfDY82G6+k3uCY13Ewo/L41MwREy6/1FcDGtoIaolztZ+yqoxbuW5iRtqzcaxhCPJ+m9T6HcyQH1wVyjjwywpYZ3DNyFl2eH4gezdtA/fSzqgquLIAGTjVloXgi39fHMT3iOKV1KLu0gZHkVuk9HOWXJ/xFC3XLPjoGklrotRCXwP6mVZumzUjU7vIkKCzhe1HoJsqtyyoRS8r7R3orhTs2g/sxzyTJFXK9rlwmhrNEDBRFMH/I9cJa/S6bA3bKNDoPzFiA2LBrCcGKzJ+KOIdJ/uWL4ufNPgNrd/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ihYiOQ2cJ2eqrVq71wxgTZhmo7ec7BXg/HSpYhrwHqg=;
 b=D5HP9pjpi2S4C01QSbM37xpO8eMA/3REjxNwxnGkgg8Y7VUqLyGkg6OapKEFBQgR28AMhFw+2Y/PXlkV8gCkUAQoZil3ZSm9iNzOyQAgQgsPBN8rw2iu7naxGe8Cu4KTtwwqGnt6CLvbwscvEuSg11s6JP4ZY2lCc7u6eVAuBFgs3WTijIMlWFxwKWBa3q53rU1nwF42bdgkL2n3XXV96dxMq2RZ1KSHW3K3AeKBXSmlzoJjjx785bez8R6o4qECJQRiK4MSKPEQpy9fIQrpsYXtScjrbhE3g6RWX/5IBos040gl6t2Ha3zGmi7YKyJAUGsigzQBtiEi7vnnHElEYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ihYiOQ2cJ2eqrVq71wxgTZhmo7ec7BXg/HSpYhrwHqg=;
 b=m5UzS5QF7hEgEXnp6v55M9I+88eh78BzlRsW5CKJjfHPuEv6680IG3qKuqg/AH2bit4xEOt+rZ0EIaOzBEeN1+otfluoRNAeMaQbBfD8Mw874Ix56iVIJhue3nFjcCVNdYtx3jKNiHPX7HiBmSkMXhvjivCZ/Qjd6I3vcQ0Ylns=
Received: from PH7P221CA0015.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::11)
 by PH7PR12MB7428.namprd12.prod.outlook.com (2603:10b6:510:203::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.29; Wed, 14 May
 2025 07:20:46 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:510:32a:cafe::ad) by PH7P221CA0015.outlook.office365.com
 (2603:10b6:510:32a::11) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8746.16 via Frontend Transport; Wed,
 14 May 2025 07:20:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Wed, 14 May 2025 07:20:40 +0000
Received: from BLR-L-NUPADHYA.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 14 May 2025 02:20:30 -0500
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
Subject: [RFC PATCH v6 06/32] KVM: x86: Move {REG,VEC}_POS() macros to lapic.c
Date: Wed, 14 May 2025 12:47:37 +0530
Message-ID: <20250514071803.209166-7-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
References: <20250514071803.209166-1-Neeraj.Upadhyay@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|PH7PR12MB7428:EE_
X-MS-Office365-Filtering-Correlation-Id: d192b9a1-8d90-41d3-88ac-08dd92b7d4ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?ZmtkaHl5NU1VMmVQdDlyRXpJMjkzazhpN3Fpd1JsRmlXemxGcFNZbW9ZcmN4?=
 =?utf-8?B?b2h6ZjNDOTBrUFZCSzUxWGZJUWFaK0VnZ2VYaCtaR3U2NFJwNmJrWGhXUzZZ?=
 =?utf-8?B?bjJRRDJXUXRWeDcvcE14NmRKMC9ORmUzWVg0RVJoM3hVVzlLWng4NkE5RGtF?=
 =?utf-8?B?TnVCSEE2bEN3M09lR1RETzNRR1VINkwyWFhIQlpsbDRTQko2Vm9mblROZHJz?=
 =?utf-8?B?V254T3pwMXUySlFjdEJqaUkyc2tDRnNlQ1NyYnB1emY5QnJMWHIxVEg4emVY?=
 =?utf-8?B?aEpyTHg5Y2VRek5XakZOY2x3eTkxV3NXN3IweWNjQ3ZkL0RZUEVQTUkxUmlu?=
 =?utf-8?B?Qjh3NGF3T3g4SnpOSmloVndBSEd2VVJPNzJPUGpyMVhUQUVCMC9WN0ZNY0N3?=
 =?utf-8?B?VDFpclk5My9aRDcwenU4T3djcXU0T1JIRmlpTEZBNHphZ1NCUUJzdlRXL0Vk?=
 =?utf-8?B?S0Fra2Z4ZVhqRWVkd3hpdkdpbWVyaGZ0RmdadG1VQ2haSkhDYVo0N3VKM21j?=
 =?utf-8?B?M1d4UjltUUN1K1FvazMzeTgvYXBXNHpVMGViNHZFWU4zWi9XL3J2S1JPOTY4?=
 =?utf-8?B?RXA2OVJQZ3d0V1J3NHUzWlRnaWRrWk10NktWTVFZWXlMMEVXTW1pK1BIWTlJ?=
 =?utf-8?B?b21lREZHTkp4aE0wSkZsdUxJOFNSUytNTzViNFZScUpoSmd6bzh1UXJ1eHVE?=
 =?utf-8?B?TlZPZlcxNk9ObVk5M2JMUy9SQk1WdGMxVUFQTFp4RExxVkYycklhY3JIUXcr?=
 =?utf-8?B?dWJiWWpmWjlQSW1KZWJDS0l6VWw2VURqNXlPRmJ1dTNudVRHOHFjODlJN1V1?=
 =?utf-8?B?eEt1azBJUEQ4aWlXUTVEQ3I3QktpOU5xU29rQ3JqY01xaHVETGJRUHNLRWhZ?=
 =?utf-8?B?TDF6b1F4QmZBMkpscVNyNU9TQ0xuRDJJTGJMdXRPeXVORGNXci83MmhXUXZC?=
 =?utf-8?B?Q2VuSTlUSzNZT29qRXpTd2dEN0dDQ0JGTXZkejVlUVlDTUR1M3BRTDAybCtW?=
 =?utf-8?B?TXFzUmlFTGM1M1FRNHBHSXA0Q1E1aHpjNklLb00rQTBiVnhGNVU4MVlvakMz?=
 =?utf-8?B?bDhGRzhQZlp0bytTSk4vUmpmdVJoTzRQZmhiVDNqYzgyd3M3WjVmV0J6QjIz?=
 =?utf-8?B?aE5NbDN5SmdjLzZUUGhvQjZRUEdHZ0FWSEo0UmkxVWJGQTJOdnVUKzV1dlpH?=
 =?utf-8?B?WkZYdjhmRmZydzlIdFNoZ3I4bG84NGJVVTV3a0JvelNITkoySWZDZ1p2VkZw?=
 =?utf-8?B?ZWpRaW8zdGFPejRpQUZlajh5MVVYcTdkU3JvOE5mTU4rRDZDZS9sQkZabThT?=
 =?utf-8?B?OUxKa1d5NEhuZjFYUVF4SUFpWjVGWWJ0QjY4TlFuVmVwSERxWXlrVUJwV2ds?=
 =?utf-8?B?UDFyN21FRVJMUkZ5RjdnYi9NbTR2NFZqTEYzQ3lLSVU2NVNUYVpITjlsVlhY?=
 =?utf-8?B?MU92U0MzNndSVGNRMU9uZ2F5c1d3ZENYMkgva0J2SFNVWGwrSmQ0NVBEWENw?=
 =?utf-8?B?bXZlMGFNWWFoQkJvYUozTmtQMkFYZk9QZFJqbnJlNlJMKzVZZGVsdTRzdlZE?=
 =?utf-8?B?aGZFTFlzQUdQTDYvdUdoVm1KU0lFcUFobUYvMVE1d1IwSjh4QUZhdm50NTlZ?=
 =?utf-8?B?Y0ZvYjVnLzlnTnh3cjhla0N4VUFmRnl1UU9lZ3V4a1l1d0l3OWRFNEIrRy92?=
 =?utf-8?B?MkQ0d1NFOUJncmlreTZwV1pyajhDZjJTVm9Jc1pkSmtWN2FiVHAya2p6Qk9J?=
 =?utf-8?B?RHBUVG1DQTRRVXBVRXl1VGtjemtRd3FmYVIzQ2tLd3BZVG91aHlRK2VpMXR0?=
 =?utf-8?B?eWJKNS9YL3dZdlJYUVU1NWZxRittVmE1aGJBc2tCYW8rM3NkdEtlTWRlQ3J4?=
 =?utf-8?B?YTRCMTZVQUtGeThNdXgxc2twOWVBbDlQSzErcFhteHk1VWdkZkZUVkppYmsz?=
 =?utf-8?B?NmlZK1pIZm9wejVHRVl5Y2tOaFlOUXk1eFdUR0JvcFl6cXhMWUd6Q1BLUUNJ?=
 =?utf-8?B?a3JpMU5qOGhVWlJMQTRFN1JOaVA0UFZBRkR3MTU4OXRKZkRiMTNJYU5aSzc5?=
 =?utf-8?Q?eziEHl?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2025 07:20:40.0478
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d192b9a1-8d90-41d3-88ac-08dd92b7d4ab
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7428

Since the {REG,VEC}_POS() macros are no longer used in lapic.h,
move them to lapic.c.

No functional changes intended.

Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v5:

 - New change.

 arch/x86/kvm/lapic.c | 3 +++
 arch/x86/kvm/lapic.h | 3 ---
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 23d0a2f585bd..25fd4ad72554 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -57,6 +57,9 @@
 #define APIC_VERSION			0x14UL
 #define LAPIC_MMIO_LENGTH		(1 << 12)
 
+#define VEC_POS(v) APIC_VECTOR_TO_BIT_NUMBER(v)
+#define REG_POS(v) APIC_VECTOR_TO_REG_OFFSET(v)
+
 /*
  * Enable local APIC timer advancement (tscdeadline mode only) with adaptive
  * tuning.  When enabled, KVM programs the host timer event to fire early, i.e.
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 50f22f12a1ad..f6e5b3b77a05 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -145,9 +145,6 @@ void kvm_lapic_exit(void);
 
 u64 kvm_lapic_readable_reg_mask(struct kvm_lapic *apic);
 
-#define VEC_POS(v) APIC_VECTOR_TO_BIT_NUMBER(v)
-#define REG_POS(v) APIC_VECTOR_TO_REG_OFFSET(v)
-
 static inline void kvm_lapic_set_irr(int vec, struct kvm_lapic *apic)
 {
 	apic_set_vector(vec, apic->regs + APIC_IRR);
-- 
2.34.1


