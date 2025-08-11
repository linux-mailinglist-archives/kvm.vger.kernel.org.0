Return-Path: <kvm+bounces-54392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 014BCB20441
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 11:48:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 25E62422EE7
	for <lists+kvm@lfdr.de>; Mon, 11 Aug 2025 09:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B475230D14;
	Mon, 11 Aug 2025 09:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="BFH2D9aX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DA11C3C14;
	Mon, 11 Aug 2025 09:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754905600; cv=fail; b=R01Og2OLIu76/pxhGbpLSmtGVJI61tiycvi20032YEHcyYlTr6L7ZoiQXelwJuvtgVHG6XkTtqbeUxzIYIzYwUzWePKyeg3dArwcPh0VOkWxsEN4d6us+MSLwyqzlBPDthWLFzSdOF3YbHjzKIDxykai5btVVCMTUFazoyKS3V8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754905600; c=relaxed/simple;
	bh=JVzoSC2t+wn8suJnGOJOvZyBNQUZREdZGl4MFl1iv5U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Od4Mp2ZGcS8RqzMYl3ebtWKVJUaAKyjnyNfzQjnJPge135OU2Z6Dl0QfKO1Vg28+llSw9WnRi1av+19+hYqA89b8EiTUiUQy09SShTViYfkfiFi59mQocLREQD37mKc0c5QqVuPTFMN8n9sVRy13qOCQ1M1TwoJy1DRP64CMZls=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=BFH2D9aX; arc=fail smtp.client-ip=40.107.95.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Re4aCvVsE/Qnp9n4uaWacwlhXhgSuIDY0kPk6rba0ULyJbdHyQ6LwSPNFH/sVnEXNRKlxfKwTqNFgw5qPuB7nQOECnpNlybXBMXj3q5A2cMtlxmDH3cqDRfvBiwF2Ra8BoufLFCtSElAAOXIgNB8uPGRPVbpNadUlm8hWQ4LHP3PxX42tNOYETQ1+WsLwYIWIFBeQHZbZzlwRFKPfYE31oHdHeLCON+FoOCBqyG/KcZwpsRG7PhRYcxHz17peudSU6T10yiKRBz5ndGc0uii/BMh4M5PuG8nfKcm8SuqemfIA7NkpabJuOuw9fR0guH/LxbkU3l3ZBwZAOKp1W22YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/UHz7TjjvKaiYPs3YIFTWuPFq3Ky2H+T9CXCLZSjZh8=;
 b=J7+xxrbiMUq9VPm+03TD8UxnTq/gyGMCBUwxvLIL/Wn3aaA1FfqnWDG6SW98pqAgoEscVJ6i1N4Y9EyYe7ygqKMQOn9hWUF4qaEkMncLJ5Mg5zC14+KRbt583AeugnIdQWpyZVTFPkjHm4OTiYIPVQrrn4gXKyn64VKapqW6AeyMXEq4XnZsi6QWvAaJAKub0rmQFDMkQORXJg9RcctjSWJsZd6jjuhuUy4+TiwLYFeDxLr0jkn6kJND5hU1jvm/lDBTWnn7WFYQevgVtr6cMeCm3k+X6vz1zs7gNSqo3GstkPXgoUnMutLjGZG/lVS3UcHwbGbGGycwtk+qhRvmEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/UHz7TjjvKaiYPs3YIFTWuPFq3Ky2H+T9CXCLZSjZh8=;
 b=BFH2D9aXpX7S00+lXEl8npzN4nWGlH9sAq8zoqHAnbNDZCVcpB3vF4JpW92OrqTB0vc6y9WCXzPnaPDv4rv+yP99/pDQxUCVAa8/3ro6S6D5n7Z03xK62Mjyl8iajGggLG3G1no5lfmG56aChNgav4sK4poBJ1t/FSeEisqANUE=
Received: from CH2PR14CA0048.namprd14.prod.outlook.com (2603:10b6:610:56::28)
 by MW6PR12MB8899.namprd12.prod.outlook.com (2603:10b6:303:248::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 11 Aug
 2025 09:46:26 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::ae) by CH2PR14CA0048.outlook.office365.com
 (2603:10b6:610:56::28) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.22 via Frontend Transport; Mon,
 11 Aug 2025 09:46:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9031.11 via Frontend Transport; Mon, 11 Aug 2025 09:46:25 +0000
Received: from BLR-L-NUPADHYA.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 11 Aug
 2025 04:46:18 -0500
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
Subject: [PATCH v9 04/18] x86/apic: Initialize APIC ID for Secure AVIC
Date: Mon, 11 Aug 2025 15:14:30 +0530
Message-ID: <20250811094444.203161-5-Neeraj.Upadhyay@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
References: <20250811094444.203161-1-Neeraj.Upadhyay@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|MW6PR12MB8899:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e77108c-03b8-4981-0a24-08ddd8bbf039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ES/GsCK9RlywsSQMc1MRCg8TOwZhDde12HqPot8d0h9fDi3rq+LINvRKv+yy?=
 =?us-ascii?Q?089hVuULIC3MeQqtiWc++V2wso+Hnvv+sJEgUp7l4jFydY8XbtL0YjoLiq/k?=
 =?us-ascii?Q?MyHw2ifmlRozKdOol2XMqRItZ6uutbkbFzxZpABTEmJ+HubZfZBmi8vJr+VJ?=
 =?us-ascii?Q?XbmfMzf6qmE+qEtyy1k1WS/k0xHwQvJt+dgOeCSMHRehDMfp5Y5vaaG0GAOj?=
 =?us-ascii?Q?UV2wQd8dbUX25HF+LWOXTpL7QNkL18v6pvBWRbSGsk7KtSk7CPqzIQ3ysCrO?=
 =?us-ascii?Q?mMgO6EXmKv4lBcbpTMbMxSqyJBKUReBnT2AiDyBuFGEbjmK0vuh9+vLMsGKM?=
 =?us-ascii?Q?cCeut/i1qCVvPf5qBYB0OH03bdc9CkbmsZlUwkVxRw+nD1CScHahzl7qsN45?=
 =?us-ascii?Q?i+fx5j0DvuhR6wkTHPXxLaal8wZtS3DWtybYRnzKAke4sunCyEyzpn3I4Qey?=
 =?us-ascii?Q?J0ji48k1PcVfrdnJjnWX2w0EhlL69sCT8efZWzBcCQehOtDlAvqaJoT6T03w?=
 =?us-ascii?Q?FFZb1I+aivioRA+CZYU0HGoK0FAJCn4p91kKsfv6jp7UlIA5kPs/DMk5SM0g?=
 =?us-ascii?Q?U24UDW0LLwdxRBpvnk4rLjzvnxB/IOyHPnCJtyBMV8GzrX7pT9/huuR8YjfL?=
 =?us-ascii?Q?Q05/wWi7cQU1m0+J8bz77v3S5xU3dkiXqOqIHZFYAfRf9+a3GNvAbSwlao4X?=
 =?us-ascii?Q?lbOu450qwANZB3RTqkk9Lj/xhe+3ydGq6hp7pBQXJPv/btGzl2vUgRVJp2EV?=
 =?us-ascii?Q?LBpdv3Yj10spZ/6/YgaG5yCyhfd8WfYRBugmqRsowNIBHnJLsyGPkpQRLx7+?=
 =?us-ascii?Q?GHSaMWKZXogR3QI3p39yEEcCq6ggauGhwW9JQKifHWutE1AW0Z+BWVYVEDvo?=
 =?us-ascii?Q?uyKrEdYjAMpMcpTvk1lTnb7vm2M0LMbnZi4BPDHLgseH1MY14p2eljkRHO3a?=
 =?us-ascii?Q?OM9rzQCVKhErGRl4FoTwnhZgsAaQBc74RtH/hTAWR9HYV/Qkh2XaTHT9BMdS?=
 =?us-ascii?Q?3txEMxvbqMu8GDdYymbuOGQY+GUJg/AtMhgv1al9j59HA3KXMU7Wkb8YpkoM?=
 =?us-ascii?Q?eu75dRtxM9KVrD2cnfJTEvvaG7rPZDmAUjH4VYfFi8i5ehZCAzmHLcxnJ2xB?=
 =?us-ascii?Q?fI6C7ogj6eXTpojmqlNZApywXZrbRoa53N/f3LF8cTL/7SaSm2EAGJyAfPyr?=
 =?us-ascii?Q?3IgotA9MpPHGHT4gN+YQNEjdOzmujWmHmTgaqQgsVThOnTmb9OSJGU0UIaA6?=
 =?us-ascii?Q?Yt2rQaHtQkDwcsr9tgznqXwlHmWV4ZE1E1IMcXvJ00ww8KVH4fxP00RRXVjZ?=
 =?us-ascii?Q?9H8dVXZfJupojZ1muXOFS3+lriWu57aceLjOcyihtZ8qGFQPW/r2xMrz3U4u?=
 =?us-ascii?Q?FUnPYzDNZtRxBlfUmpzzwlGE6K2YpYmL6W5z3NUdaMwAVBR5TPrcGEr855Bn?=
 =?us-ascii?Q?ON9Ohq8g1YId5sV35SCUa76SAEmiDTocUzUBS4IGA9qnuSuM84V629d8a53N?=
 =?us-ascii?Q?PxBKcZBZtcDYfHHuL0N1eELu9TCB4zz2A2m6?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 09:46:25.6711
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e77108c-03b8-4981-0a24-08ddd8bbf039
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8899

Initialize the APIC ID in the Secure AVIC APIC backing page with
the APIC_ID msr value read from Hypervisor. CPU topology evaluation
later during boot would catch and report any duplicate APIC ID for
two CPUs.

Reviewed-by: Tianyu Lan <tiala@microsoft.com>
Signed-off-by: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
---
Changes since v8:
 - Added Tianyu's Reviewed-by.
 - Code cleanup.

 arch/x86/kernel/apic/x2apic_savic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/apic/x2apic_savic.c b/arch/x86/kernel/apic/x2apic_savic.c
index 86a522685230..55edc6c30ba4 100644
--- a/arch/x86/kernel/apic/x2apic_savic.c
+++ b/arch/x86/kernel/apic/x2apic_savic.c
@@ -141,6 +141,12 @@ static void savic_setup(void)
 	enum es_result res;
 	unsigned long gpa;
 
+	/*
+	 * Before Secure AVIC is enabled, APIC msr reads are intercepted.
+	 * APIC_ID msr read returns the value from the Hypervisor.
+	 */
+	apic_set_reg(ap, APIC_ID, native_apic_msr_read(APIC_ID));
+
 	gpa = __pa(ap);
 
 	/*
-- 
2.34.1


