Return-Path: <kvm+bounces-21832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A06AE934D6C
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:50:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1FC1E1F2382F
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5BB913C801;
	Thu, 18 Jul 2024 12:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="sqpfBb+m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7210654645
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721306996; cv=fail; b=edrf3Szqru27x1Df4qoMiSNTXRJPCCo79vXVmTDYIGxLX8ZPvSjIoWDRXVlpDESNsvuetUAVgGU74alI5cihUMguTNrsG0JIcbZxQ9qIAhHPLdzMOgCZCMJggZRuApR90mhpgXDbIgOLcYozhOIwaxcAihF6yC01DXwwTUs0iZI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721306996; c=relaxed/simple;
	bh=1iX6YLNIFSEh7KMPj9kMom2gHAfLIsQmq3Tx5oDIh3g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMvw3t5Dtpt6icJ+ftO3+pZHj6VSxK+d7IpKWkqxxUuTKy+UnZ8ELpsgZVmSa1HPFudYC4a1QW9MPV2/NLLyxbvkZyK5CvJMvEfCicEqotVkpabSYTM9VIeg1oaHV46As++S5pXbJkoJgAjaK2wWtr/++U8v3vDT2PwdvhXu87Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=sqpfBb+m; arc=fail smtp.client-ip=40.107.92.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S8ovq7bOtzRt/U1pSVYQNNteY6BCpKnHSG9o4v1pV7BZsKX+FyTBXrih1wEXXfz9XfkJTZKInUOUcMNS9eT3Yokt5efhuDeBvBGKmPUcq8ZmEzca8TjB/WdNTFLzK2/Egy7HV+8ENLkoUNQ2G7WOI1NsAaexNRxqMsITGYQAexDncxNGQPmjwsNbWZ1sESnvDhA178uya08ERnBTTQQfdWFkbubDQKeKFLjYMQmwXT33pYHZ6ubCiKHNIPEajSk4EfM4QvYvDVKIDExlSOBqdY6fYwSKepL54X2YoFYq8ZlxnADSqm5x7nVUh90RYRN8RRWp3aWeq6EFOO5ohQ5WhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A3RoF+vzRQjPy6w2YlDtR/acKhHExPTvmZXWrXlEWsI=;
 b=mxaJLBVYqGzHloa2c5iSarrDv1Zqsvfu4D3o/dLjXiH0+V3pthHvmSf/81er0AfH800NwnkydVCkgXjoECG741Uac8/Z32oc6D/aw/dRIR9SIea9m0HpKXYZXlMzgs36q7pwsGCvAv1eZZ1OVPpviJYF4er1R2ldMmZAldt5I18w+tSwacuLRK/jBC/t5Z/F5ZXzMNjcA/tcjhuXuLxgomh16tBX3dCNjxtU72ZvWiqaZSH2CjcBYyAQiBF/w2j8AzR0lVhCrnH4Zf4i/735WeZ7M8qguvtYJnx873NE/Wgs7cTs6pA8lO5OIPrB199MTo7G0U7+R+MgyW71xwR2hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A3RoF+vzRQjPy6w2YlDtR/acKhHExPTvmZXWrXlEWsI=;
 b=sqpfBb+mtZEwu7sVUj0h54IZGFX66fEwaFMcF495LxUTY5OGyagYHB7aIvj1zPccyxQ++gPCIlOl1r2jBJgf3VYiifUOAQA9pSRGhdraDIKfpmB8qwCtcqAMsVe5FFMtkAscckkGxBuXrq0LXXGO6WxAijXiQTQUfCR4KK48G/U=
Received: from BLAPR03CA0137.namprd03.prod.outlook.com (2603:10b6:208:32e::22)
 by IA1PR12MB7591.namprd12.prod.outlook.com (2603:10b6:208:429::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.18; Thu, 18 Jul
 2024 12:49:51 +0000
Received: from BN2PEPF000044A7.namprd04.prod.outlook.com
 (2603:10b6:208:32e:cafe::99) by BLAPR03CA0137.outlook.office365.com
 (2603:10b6:208:32e::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.16 via Frontend
 Transport; Thu, 18 Jul 2024 12:49:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A7.mail.protection.outlook.com (10.167.243.101) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 12:49:51 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:49:50 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 01/16] x86/apic: Use common library outb() implementation
Date: Thu, 18 Jul 2024 07:49:17 -0500
Message-ID: <20240718124932.114121-2-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A7:EE_|IA1PR12MB7591:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bfb8d7d-8a19-4759-8196-08dca7281d7b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VUxud0QwdEI4YlV2MVZtbmlObEVXcmlhR1VOWkdwRzA3UVM1SEc0MlU4dG5q?=
 =?utf-8?B?WG1ndEpUbU5VdFJHanAxMEZkM2VrRVJwQk9zYnJzOVJ6bjVXeVlqSmsrcGZ2?=
 =?utf-8?B?NXBjWC9VcWtmVTN4Zy9paisxaFFCdWoxRmpMdW04U21wR3ZZZmRLQkZvZldv?=
 =?utf-8?B?OGFOU2lnNFFCZjgzTnlrSVZoVkhKUzZQbXladjF4bmVBbEFzeXBGeGk2N3R5?=
 =?utf-8?B?dDh6YlZKdGkvaGhBanZ0aHNMREhTZzhmV1FtYWZrTUxwMGlCSUcxMHlKVTRJ?=
 =?utf-8?B?TStHVzdocEVmMWxaNXAweDVyY0gxRFlnaFB3WU1JQjdNRkR0cmxkTWNzdXdV?=
 =?utf-8?B?YnlCb0J1Z1pqczc0SndNcGU2MEJydExpNlJIQVhRN3pCT21MTHc2OUFla0ht?=
 =?utf-8?B?elNoeGg5d1lJS2hZZlFyYThPTFlJTEQ0U1c3OEx6U1dRUHk3RzRtYmJycnFt?=
 =?utf-8?B?SkRVRE9WZVUvL0l3dHI3eTlmaTV5RjNhRmIvOHpmNzc0N1VvWkFOdG94YkJG?=
 =?utf-8?B?QmtDOUFOTWNDek1FbUVkUDFSN2Z3NTlpWUVrSXFjcUZoaXd4T00zVHdsUWE1?=
 =?utf-8?B?UnR6UE1aamxoaDN1ZC9JYTVUVTRENC9GMXMwV3o2YkxHZHFlellKcHE2Y0xR?=
 =?utf-8?B?eUMvNDc5TUpvUjJQYjlVTC84YUY1YkVNcXV4YVp4ZnFSNGN2SXFxUUFSelR2?=
 =?utf-8?B?cExMVTl4TG1ScG81d3RxS0hFNWEra0VJWTd0UERnSVdud2tVV3FDazBObVgr?=
 =?utf-8?B?UnFIUEN4bXZPeXhYQ0lFWDNHMHhRZ29JYlRUNm56ejIwcE1YK3VLc0NLTEFo?=
 =?utf-8?B?VlVSQllLYUVhS2tzeHpHMUdZY2Q3ZTNlMjcrNDI4TXFlYk1xOXFhMG51c0po?=
 =?utf-8?B?UDBXYXZ0dDV3VnNlK3EyeEVtQlRPci8yRWhOVC9iQ3ZHdUdsZCtWaEVuNGpr?=
 =?utf-8?B?UjFtQVNxMzBFdFRlczY1dzhjRThzeVZSY2NyalFEVXhhY1VYYis4M2JvaFZ6?=
 =?utf-8?B?L1VqeU1GNEJzTExvcXpmL01UUmJIbTRDR1VDNGVMaTRUeVNzT3BIeDExYUkw?=
 =?utf-8?B?Smt1M1JxNzlmdVREcElaY011enZHQXQvQ1BkUHRxc3puZUJmTkRqSndHeHJC?=
 =?utf-8?B?cmR2SUljQmdtbEtJWWxBS1E2YjhYMnN1Z0dWS1ZkY0MyZjVPVG9CcU12Njlq?=
 =?utf-8?B?cWpMVFpMZnRjVTVHOWM1d0crbGhZWUJ3cUtvS2ppbFhJUllmdmk5N04yZnp5?=
 =?utf-8?B?dnFYRlcxMnpQQWpDSDBZd3kwUTZtNkx4dmpSdnB5VFgyaFlGc0FjbFMzQUt3?=
 =?utf-8?B?WmZZM0xLeHA4QllsWmhKVEJDdk5QVWpvRFptb3hxUU1XWUFSSjk3d3p3ZlNQ?=
 =?utf-8?B?WkFyYWRsNmQxS2dNanlhcDA1bGRFeDh2M280TFBXS0FtNnF4MHZTWEJieFZR?=
 =?utf-8?B?WHgwZWNBOCtWN0JDdkZZb0E3UlR5bWJEeDJxTnIwNHUyRmVESjg5NXlxSTdi?=
 =?utf-8?B?RTJGVG9xNmljRjVQWmV0ZzVkYWZkMStFVHVLR1pYM1J5L3VRTzQ3SnZpYWU0?=
 =?utf-8?B?Tks1MFVXU2FSZ2R2bzR5cy9FcnUxbmIxcjZ1K0xMVmNwb0JYTlFqSEE0Z0JU?=
 =?utf-8?B?RnMxR3dCMC9qTUs0QU5EWi9RV2NONkV1S3VNYjY2WnVZdFErOVVxV3NyU1lZ?=
 =?utf-8?B?emxNNFRYWVNRM1lMT2hSd2R4aTM1TFB4Z3hocjVnaFF2R3RUQUNsaGhMQnlv?=
 =?utf-8?B?U3A4eGhXZ0FOdGRGVjdhNjJjY3VEUUZvdktuLzNYUm5nUkhlUXd2ZGFwY2U0?=
 =?utf-8?B?ZEJTYy9ML0Y1QjF0Vkp2OTlWa1B0emZxK3ZpTXFtSytCbHZEVjNmKy9ERUw5?=
 =?utf-8?B?aHlaUTJYdUJJK0Z4bFBoakcxWGV3SHN2Vk1kckdWV2dDQ3hNc1NRbFBnUXJ2?=
 =?utf-8?Q?ezJYpMmqGaNoDmFOIFIouTFNPDPKRbhy?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:49:51.4306
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bfb8d7d-8a19-4759-8196-08dca7281d7b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7591

Remove the redundant local outb() implementation in favour of using the
common outb() implementation defined in lib/x86/asm/io.h, and convert
set_irq_line() to not open-code the out instruction.

Verfied no changes in assembly output for all three callsites, tested,
no functional changes were observed.

The rationale behind this change is that, support for SNP tests that are
introduced later will need apic sources to include common library io
code and if we don't remove apic's local outb() implementation, then we
get the following compilation conflicts:

In file included from lib/x86/apic.c:7:
lib/x86/asm/io.h:30:14: error: conflicting types for ‘outb’; have ‘void(unsigned char,  short unsigned int)’
   30 | #define outb outb
      |              ^~~~

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/apic.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index 0d15147677dd..bbc2d8ae85b1 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -4,6 +4,7 @@
 #include "processor.h"
 #include "smp.h"
 #include "asm/barrier.h"
+#include "asm/io.h"
 
 /* xAPIC and I/O APIC are identify mapped, and never relocated. */
 static void *g_apic = (void *)APIC_DEFAULT_PHYS_BASE;
@@ -23,11 +24,6 @@ static struct apic_ops *get_apic_ops(void)
 	return this_cpu_read_apic_ops();
 }
 
-static void outb(unsigned char data, unsigned short port)
-{
-	asm volatile ("out %0, %1" : : "a"(data), "d"(port));
-}
-
 void eoi(void)
 {
 	apic_write(APIC_EOI, 0);
@@ -232,7 +228,7 @@ void set_mask(unsigned line, int mask)
 
 void set_irq_line(unsigned line, int val)
 {
-	asm volatile("out %0, %1" : : "a"((u8)val), "d"((u16)(0x2000 + line)));
+	outb((u8)val, (u16)(0x2000 + line));
 }
 
 void enable_apic(void)
-- 
2.34.1


