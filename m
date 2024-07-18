Return-Path: <kvm+bounces-21833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4092934D6D
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:50:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D6DD21C21D29
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A08413C80B;
	Thu, 18 Jul 2024 12:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0kmoKSn8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC35D13A407
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307013; cv=fail; b=VhtivCxHpeUf6kXJzxkuSIGbYxheEdvVFhYZwQ3lwwPueRN4aA+1TBjO8ysy6yy36+aO8WA+Km3z0ROcJ67AebYrrgJ3GWn1B/Lt0g5i7GZuhabXtAOXmALHOlYgUzC1SoPnvlNM78i+vn5GZCN79X6a8tYx2GXnLlS/YW9qQJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307013; c=relaxed/simple;
	bh=5zq1M9/gH/fJbK7AgZisPL7XAsfvsyTFpCEiGnZPUgc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ijqw+ujiObEZdXCPNk6TVgOJssD4TQvEdaKb54uG49ch9Em/TP45ZViMQ59UNCptNp7rMe9DaFUaXPddUnccoyIcrfFkcKa0ry8hh9UhlZcVMP2WjdMGkjTBe1rg/sLHS7OGZqALCKqndul60MjcWCcr9jaUJGQ+rqQuA+/k+Kg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0kmoKSn8; arc=fail smtp.client-ip=40.107.94.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=T6XoMSsLQqIzmgZZKFNiKnBshvf+aC5bLsKFpC4HinwtW8KCQC08do+tVoMcUcnq+jAgN/wL4ZaQt105Ce2iSp6eNkGm70tKyb5NF1HdDLyNYf1txIYI2hKKt7J3CDyfFgunEYjRIwekavI7yGbf4ZesQAikfCOVvBCOb8AOALSAutmhGd0cuDMzXK1JB1LSHpX2p+IQ0bqLiqN6oH09rQXFtZ2EuXbiWrew/giB4h9pWJLpPVSzqQRl1qoaNLguARdBi+bVLsaIZqICMlwHVY3whYJ2c9RNWV2/zyZHjbq8gPjjIxmdO+iqTJyJeEOK7JWiJrrTGrTzYlvN6Z++9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KcglEVddZ7ujVZEojR+EPCaZ1ff+iPeVwE/mx01yjaA=;
 b=JGpm39LD6/kDmwub2yt8cq2cfXIje8JBz1JX/YqEX1A7KsbbfAy9ST+AfVQG535G9s5gD9FqpxJ/qaStODW6LHI3SxFbRgqpM015fc7/W9uH2rvgmD+KYOI7JG23CzNZLYLiJG9OYIn6ArmoP4NrDVYcAEy0mx+54mwAB3vdVeOqbh/rXT9ob9crq+dg77DlWoWwc5V0dUVcjbdtPK0JZ/F7F3WzWy4x5EEeO93wJq2tyEDDDcz+trfR5aR5oLKAA3aCXIBn2eqRyBXkZQTMWU2E+gzHLGfX8nQDly+ya8AXldkutzr9hUqvCeL10G0MxIwVqizfLTA1/4YrUB1uqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KcglEVddZ7ujVZEojR+EPCaZ1ff+iPeVwE/mx01yjaA=;
 b=0kmoKSn8rdtumzes2Uvmn8LKNv+0p1/ODq+rd+AcTNmVEPUXvRhEjBarGRZjvc6pfWumviOYHf8mDbnJNHiwXgrumNu+8r5YfR80/NVLqHXGVcHo61H0Tb/FAQtUbE2KpTmcVzPejj4yl/b4BB8beD0tVz5+jwkmCtSVUwRczGs=
Received: from BN0PR04CA0021.namprd04.prod.outlook.com (2603:10b6:408:ee::26)
 by SN7PR12MB7180.namprd12.prod.outlook.com (2603:10b6:806:2a8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.25; Thu, 18 Jul
 2024 12:50:07 +0000
Received: from BN2PEPF000044A6.namprd04.prod.outlook.com
 (2603:10b6:408:ee:cafe::d0) by BN0PR04CA0021.outlook.office365.com
 (2603:10b6:408:ee::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.20 via Frontend
 Transport; Thu, 18 Jul 2024 12:50:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A6.mail.protection.outlook.com (10.167.243.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Thu, 18 Jul 2024 12:50:07 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:50:06 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 02/16] x86/apic: Add MMIO access support for SEV-ES/SNP guest with C-bit unset
Date: Thu, 18 Jul 2024 07:49:18 -0500
Message-ID: <20240718124932.114121-3-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A6:EE_|SN7PR12MB7180:EE_
X-MS-Office365-Filtering-Correlation-Id: b19bd1d4-2df5-4869-f251-08dca72826f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9JOmZdzsjA5UC/tHiec6fmbTMnmgm+vg4QrMT6dmpyP3zu+bDTMyGw39/0wV?=
 =?us-ascii?Q?DD6jC3T57rSgPGIVDJ8tez1DWwDRr2t5JjsKTXMGddbsibi8nWGRK6NqokIN?=
 =?us-ascii?Q?YudBh2nSWXEugE6ckqIBnKltyBJPSZsXlw4CDKqGB0uAysnI+DPwZtnFYnWm?=
 =?us-ascii?Q?PlBx7tlIUkt8ncPc0yKScuwgLTWnJ7rOCSfHttpmuz74HZITzBgs7U/L1KI8?=
 =?us-ascii?Q?3//Jh5JVXOxmFxWz4gmFSzo6SueGUJ/kWvtEkbq+lnHV6VEk/U92MbgzYM/+?=
 =?us-ascii?Q?eFAXOd18Qon70wY1VNRrunda6kaLfMktkXWdkKUyacTuJISqgJ5A8oDkLWRl?=
 =?us-ascii?Q?neqWkkJIIxq/wsUf+udZgMX+5mrVzWqYXey2ps2p8abCq21octb89JalxXnB?=
 =?us-ascii?Q?u9RkjNWZfNzLvkpb40OfIxqEePubJijkt5hwegdT3nTuFMtc9aquSy/H9Ryu?=
 =?us-ascii?Q?ulEs9XjBTUTCcq0N/oWMJnRei3WmWIg36kBa0ccEEJ5EZX70BNIJDoFc5ZDv?=
 =?us-ascii?Q?IF4VLpIM8goLM1Fznmj5kT/3kWvWTArD+DipcNBCklD/SRto+ZOko4nSU31H?=
 =?us-ascii?Q?8I+ow9pOxsylmN+3KEeBySJRWM3jVmHTvzxCxAAz+1adUBYJvLMAHkIkpMKO?=
 =?us-ascii?Q?LhzWBlIRQsZuGGcPB0V7EbmDSrT5FSTSfQLDDSlf+pIiZqLhvLbJne0CbhGp?=
 =?us-ascii?Q?LkNvxP0mDo62pYRfHcB5HS1txkDXLyMEEteQ6JfogpR8WeSZZouiDuL2NUtO?=
 =?us-ascii?Q?2mNnWD5f7vKTp4xI+yWlNITZatndqPav7IcH1ni8NB7hs7bMBt0zB15HkADa?=
 =?us-ascii?Q?I8imO8p+kSXa8d8UH1lqv62jWaBbmbyKGlgwXiweVzIFMAo2ndfkY4hA4Ha0?=
 =?us-ascii?Q?hLThSjMqFyFiDbaOND/YnCEdb/E70BKXbQ5neGDHgQniR8TWzL2FQEcRq4+u?=
 =?us-ascii?Q?MgpLaFFPddFVFOHSX8qRl1UJdYKi6sgkJc2KJVtSEel8IMiNswnHVm71yHzv?=
 =?us-ascii?Q?J22OEPH0rSGlTw+nFDvNS1SY6MFhtBekyF9jZyfzWyo75nTw7tV3t+xh43ZJ?=
 =?us-ascii?Q?tUuOey2xR+9CNrEhlX/yLhkx3aiJCQr3d2sa80kq8vEEfe1y9Q3Mf+O3AhVi?=
 =?us-ascii?Q?kZxHmU0zXxuGtvDi9auT7C0abQMH8heFZIhn/FvN3WErfn4lCfYm0sXYTgDw?=
 =?us-ascii?Q?0z5YNCioSEHH2EWbM1HVF9AOivxjDiKWI/c02VoBjcpXf8mvUY4466JQhMrd?=
 =?us-ascii?Q?upazcsosLaMkOmT7qkkMPQgbm5+tESN+XTCI+cE6qtL2FgDJTQA44kR+cYk0?=
 =?us-ascii?Q?puU/oW9S6bA7ZsjG91N/FIhebzUyrMRocyQsRqw0qS/5Fvi02ZYxB+DDC2Rh?=
 =?us-ascii?Q?WGOT2unBfsWNX6cCdEZJn7UPpAoQbFzPhIW95Er330WUkkdV4nh1m6L1LPwk?=
 =?us-ascii?Q?78P89Pbwm3yVKoxSXA+QlmeFMuz9FJhE?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:50:07.3194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b19bd1d4-2df5-4869-f251-08dca72826f3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A6.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7180

MMIO access to APIC's private GPA with C-bit set that is not backed by
memslots is no longer treated as MMIO access and is treated as an
invalid guest access. So unset the C-bit on APIC page for it to be treated
as a valid MMIO access. This applies to both SEV-ES/SNP guests.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/apic.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/lib/x86/apic.c b/lib/x86/apic.c
index bbc2d8ae85b1..45ac36c5cbaf 100644
--- a/lib/x86/apic.c
+++ b/lib/x86/apic.c
@@ -5,6 +5,8 @@
 #include "smp.h"
 #include "asm/barrier.h"
 #include "asm/io.h"
+#include "amd_sev.h"
+#include "x86/vm.h"
 
 /* xAPIC and I/O APIC are identify mapped, and never relocated. */
 static void *g_apic = (void *)APIC_DEFAULT_PHYS_BASE;
@@ -233,7 +235,19 @@ void set_irq_line(unsigned line, int val)
 
 void enable_apic(void)
 {
+	pteval_t *pte;
+
 	printf("enabling apic\n");
+
+	if (amd_sev_es_enabled()) {
+		pte = get_pte((pgd_t *)read_cr3(),
+			      (void *)APIC_DEFAULT_PHYS_BASE);
+
+		flush_tlb();
+		*pte &= ~get_amd_sev_c_bit_mask();
+		flush_tlb();
+	}
+
 	xapic_write(APIC_SPIV, 0x1ff);
 }
 
-- 
2.34.1


