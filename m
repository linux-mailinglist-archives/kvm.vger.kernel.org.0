Return-Path: <kvm+bounces-64083-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D85C1C77F1B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 9863B2D3F0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:37:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE4252FCC01;
	Fri, 21 Nov 2025 08:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="43bA8Zo1"
X-Original-To: kvm@vger.kernel.org
Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010064.outbound.protection.outlook.com [52.101.56.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E562156230
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 08:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763714253; cv=fail; b=M92qm1LeH0pI4bvUMel0Gav4s3MneyxJbUyRnIIyUVRdco5O7K10NRsFFmdhrkS1Squ4sy8PoAdF61FOnWgKy/JCmOMigJCh1cxzhaF/JZ44lBj9Fc2xbIXphtG0tSJYVLtfknu2g2lOoKgL/PF46t/bAHJ7UX0m1pYWwkVlAiA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763714253; c=relaxed/simple;
	bh=5ZBejDHt7b3bspveqgjyARlUTb2ZncxL8wtzRCXXzFs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lpniqJnrBe6mXSUWCJyw5lL/SVfkSKzMfLwS7Fg/Bb6ReFhZEfvRLMxQHP0xHZOYBPZLpYgfJSnkV2lHkt1djupOuILg7pt8emO/gECevxBR5ri7G4JlRBsYVkD4yivi7eYTd2PILEM9F0Em2oulNq4cwWamMsz6BZzS7+pNJB0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=43bA8Zo1; arc=fail smtp.client-ip=52.101.56.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=K8qZ9MgTtgz4vLehh1r/7EwrJym4gN5gon0gDUwN5kVYPZN2s9TqHNcG+df1uJ+aIYiKAovmZJqFD6bpVZ/8KncsK5IlQJza8CtcIBEN/vABLG9D2OO8zjqHOI8rSBUyUQONWyA1adwLI5rHHjxjCNLMivApSuQkgBrRbbqbCu6A3qHQ22T39FX/2KO1v7oEyOzZkQdiHlAl4qUR9o5Zt3APOdurxfCokMR0vZQoGDzKrWI4KzkQOfSN9KMklDhmhLiw1/jh/kkFi9QunB2CiLO+2AkR4/oM9iumaZIiCTyMXvxKeQKsAKsC4MBRsfls8Ma6DSRl4kdQqItL0+FhwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXhv61nONhbhl9R9HnyIcIs6s6XFIbwUzS+V8scz/pQ=;
 b=fkqAIk8TR7Y+xDR6AH8Pdqcj/uLoYU8q3WwpfWn0HWTxYdy8xTKzq0iRHlTrCWdccXJsB4c/PKNbu2IHgg9YlNb4Ib0QLv8SqW/fwsqqEBCvfvzMjmSR0j9fNb0RAEmw5LNee9j2bWtiXZ9A6Xa/f9A+f+x/AMTyZvTZWXsMZzA+6T5GwPcRdu0Ih8mYqTaH2cKV9BNhLpc+vKrCCXVhNJolYNXrN1NXFAggfDaFWaCl7/WRTync/FdJrZQHwWDzvKhg/x+2gw4S2yFxPB8u6hiH347rfeGbAzE9J50rMIMvhH+mauMb4dCb2LESowS3wo/s1eaG8c56wH274JA+gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OXhv61nONhbhl9R9HnyIcIs6s6XFIbwUzS+V8scz/pQ=;
 b=43bA8Zo1VIxyOToX1sbmL9FTy+KocKHhNxT7IgHPFu3HJ7CurSp7yhPQUHr6Il79/M932xiQ/s4ZvjGhb/k1nNB9LkDvZV1tUYKzIedNFu26jhUWa/e8lh6fKNpQ3DECRcvEY+XuZyw/PtqOmpXiuCFEYlIM5vMgWDIPvUubk3c=
Received: from MN2PR20CA0048.namprd20.prod.outlook.com (2603:10b6:208:235::17)
 by SA1PR12MB8600.namprd12.prod.outlook.com (2603:10b6:806:257::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 08:37:27 +0000
Received: from BN2PEPF000044A8.namprd04.prod.outlook.com
 (2603:10b6:208:235:cafe::93) by MN2PR20CA0048.outlook.office365.com
 (2603:10b6:208:235::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9343.12 via Frontend Transport; Fri,
 21 Nov 2025 08:37:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BN2PEPF000044A8.mail.protection.outlook.com (10.167.243.102) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9343.9 via Frontend Transport; Fri, 21 Nov 2025 08:37:26 +0000
Received: from purico-abeahost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Fri, 21 Nov
 2025 00:37:23 -0800
From: Shivansh Dhiman <shivansh.dhiman@amd.com>
To: <pbonzini@redhat.com>, <zhao1.liu@intel.com>, <mtosatti@redhat.com>,
	<kvm@vger.kernel.org>
CC: <qemu-devel@nongnu.org>, <seanjc@google.com>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <ravi.bangoria@amd.com>, <babu.moger@amd.com>,
	<shivansh.dhiman@amd.com>
Subject: [PATCH 3/5] i386: Enable CPUID 80000026 for EPYC-Genoa/Turin vCPU
Date: Fri, 21 Nov 2025 08:34:50 +0000
Message-ID: <20251121083452.429261-4-shivansh.dhiman@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251121083452.429261-1-shivansh.dhiman@amd.com>
References: <20251121083452.429261-1-shivansh.dhiman@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A8:EE_|SA1PR12MB8600:EE_
X-MS-Office365-Filtering-Correlation-Id: d9987d76-26c1-42ef-00ae-08de28d9337f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?3gMtBR9+D2FgL+LAFSZXAcoTKuA+XRv+crcIP2S4xh28dhtPkBh41in4D0jw?=
 =?us-ascii?Q?TrxGKRHnG/XAi4aHUtw934yozVj9ESJDoR2MRg3OP+cVkBaEjTw/dEYB02yY?=
 =?us-ascii?Q?M3NZi1WTKopeJQ5KN9/vOKJi5C9gfXTYvcPokasD7yyAsBQFka0D8ZMqK1yA?=
 =?us-ascii?Q?/fYVUsIkzjAw9t46UgAKwxs6Dq+6Zsjmy25hng74B8IUZKmLX6K9YdOz2YVp?=
 =?us-ascii?Q?4AYAw89V+fU8d72kOOrEO6p2l6UNiZRJ064RvqrjYS0CzLrjmgIx91cXo7XB?=
 =?us-ascii?Q?NO54QnNkXY27DnvpalOlsuCDTA4IUqtm2A32U4TlajfQTaJtw05xb4HRHo9D?=
 =?us-ascii?Q?yxOoK6l+VjH7TNhK3vfhMH2lGoi0Sin8wf2A8AsKSBw94HKI0FwBVS6YBsNK?=
 =?us-ascii?Q?m7Mezyccv4N1UjpyLjqlCa75JocUPxwCib48TjEyTVWwG/6qZZWy9urtNOMA?=
 =?us-ascii?Q?qJ29LF6084wr9Xtf+3pHUWlRaJvRAwfmFvouXXagRwwyGRLTBA/MoxTjc0xA?=
 =?us-ascii?Q?jsF9gWyP77x+ZCd/ZHvAHaXxxFrUfFafiOEu0vI3TVA+jdY5swiYr68wVDJc?=
 =?us-ascii?Q?FDS070/yv7LKqtHve/dXPg6RNu8xvFWGgcJa5OMQuW5Yg4I6lPKZvsKTWpxo?=
 =?us-ascii?Q?1c8FA/UYgpSAf6/UJJsqPyChL5E+V+3F4EHXx0bye+hbmCZyQ/02cNuJIXkT?=
 =?us-ascii?Q?QanVvbsrL4xiVSvvsiZt/bWCFgekfpCA4y4ixRH1Acd8VVP+Ti6ohx/rKaao?=
 =?us-ascii?Q?y2JfncNlYWKRLWHmLfyNEoD0UwRPAas9BZFTk+y3VUCM2Pl6+5im8av28KKi?=
 =?us-ascii?Q?glxs0j1I+WIXAQWhDHZxTNa+9OqnJ41fBE1mABc8uKa9hAq6KE/F8czcuft/?=
 =?us-ascii?Q?llpzyiZSonMH1wUSOozWxUvU6bsd8bCNDO5uzH8QiiiXja/7vUsPI4Ofa2CO?=
 =?us-ascii?Q?gDhgGZoC79r9uJyyNaDQSJZn5sGx5/QtlgaHCUnFpDfW7ecJ/f6ofHMUKyil?=
 =?us-ascii?Q?u+nUF/5iqkYFsecdhFD7VCLiGxxp4SaCbVBrrdxbtt7DII9+pPa128CZ5jHz?=
 =?us-ascii?Q?Hatl/DbgQoYvsrh9ZEKJ7JTnhap4R4ljKeWeOOHac8p5V1CuCV5AOK63uhzd?=
 =?us-ascii?Q?fLr3BOpNlTm4h8iTdrW6PN0n7QUoA75YiuzFJS24T+dDTDyFfsdIOfWFHheN?=
 =?us-ascii?Q?GXoM4hgsk6FKCkI1AipuOpiSRNe7xz2VqW9JFf/CkvyEJrL21OVb8D1j1mGc?=
 =?us-ascii?Q?4aH47MdilRJIZws6FpFxFUA3cxQT+dh4Azel+lkezTM29SGZkutrESoFcNQ9?=
 =?us-ascii?Q?0JcrMrDtDYUjpye/99Frzug7Rjp6dIxkGiufXbLYlgvu21AwIx98y4l4WPDI?=
 =?us-ascii?Q?Uk47/iqNTHqNhdSxXktzZsPnBLEEm0RYb67xctOqzPhyMXUy0sCVKLeQ7buy?=
 =?us-ascii?Q?lWxqLllwHP8Nd7s/ixFqYPV+YjF/kYZ1mSwuZF3a7Cp3E+LrczERcpU1cvUX?=
 =?us-ascii?Q?jM6tzj+B2WpizSmphKairJtwAQfQdo+86/wCrDIFA8aJg/B3VTkwS5+14IKg?=
 =?us-ascii?Q?vUnO+fHey1gltlPzCY0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 08:37:26.9756
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9987d76-26c1-42ef-00ae-08de28d9337f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A8.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8600

Enable CPUID leaf 0x80000026 (Extended CPU Topology) for AMD Zen4+ processors,
i.e, Genoa and above. Add version 3 to EPYC-Genoa and version 2 to EPYC-Turin
CPU models with x-force-cpuid-0x80000026 property enabled.

Signed-off-by: Shivansh Dhiman <shivansh.dhiman@amd.com>
---
 target/i386/cpu.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 01c4da7cf134..12500d6b7bed 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6505,6 +6505,13 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                 },
                 .cache_info = &epyc_genoa_v2_cache_info
             },
+            {
+                .version = 3,
+                .props = (PropValue[]) {
+                    { "x-force-cpuid-0x80000026", "on" },
+                    { /* end of list */ }
+                }
+            },
             { /* end of list */ }
         }
     },
@@ -6735,6 +6742,17 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .xlevel = 0x80000022,
         .model_id = "AMD EPYC-Turin Processor",
         .cache_info = &epyc_turin_cache_info,
+        .versions = (X86CPUVersionDefinition[]) {
+            { .version = 1 },
+            {
+                .version = 2,
+                .props = (PropValue[]) {
+                    { "x-force-cpuid-0x80000026", "on" },
+                    { /* end of list */ }
+                }
+            },
+            { /* end of list */ }
+        }
     },
 };
 
-- 
2.43.0


