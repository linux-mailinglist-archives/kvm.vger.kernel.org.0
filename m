Return-Path: <kvm+bounces-31889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DC0369C9352
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 21:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40B98B26557
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 20:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0361F1AC450;
	Thu, 14 Nov 2024 20:37:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="waWrgb9F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2082.outbound.protection.outlook.com [40.107.94.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4B0136327
	for <kvm@vger.kernel.org>; Thu, 14 Nov 2024 20:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731616630; cv=fail; b=rCQXyFjMrc+w+x2Pk1AWrrIFigygcrs9KfWDrBXhrJQoZSyNSvMq0wr1d4ovpvKwAhMJJ4Mbq02NkzuYgGWLx9Pvqie062AvqkTYrNC11AUafsapFigimiCiFuDS6wNTVQFSSj+DAKEjQdgFBWm6PKq7VdARMTJ7K17RJ8L4XbU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731616630; c=relaxed/simple;
	bh=YbzaT205nW2vhtux4lUKWQUHJ0l5pBYxG/vlztoVU7E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rV7r0+4GnQB6vbmwmBkqFtFuvR0cWZeIpDpjI83GOGAAnycWM5yLsj5yy6Ee0i34CZjoHmNf4uAsuPkLRH2NnhCi+IHcRCQblhgNeMviIWq74ybx/Tg9HMxbyzqabJq/WVY7pc47HjfwDRvMxhq48bCjk31Ji9yZCw81h3/qGns=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=waWrgb9F; arc=fail smtp.client-ip=40.107.94.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=imgbMVQJhCRmUivn6+cucbzgyNQ3lgmjr5+7WdYjd/pp3p557v9N15mWw25qePmXB0DJbi9iKd4qG6iP4om+DZcnKzG2SXl+eWZsuE+5CpDfEIT6wouFCc2dD5n24y2ZbD/oU3p2Nu0ICSwSs1/+UWKL9PvUs9xBgdPNorWIxOlZFQi93Ms5xEw16ibQiOanVwHADwEr4Vp7EiUBP91uO1RyqH25nVaUtZRD5MHEhtSBR4v8pUgMRC1PruEYyFNSwqG/E9wRET5U99DPPCcwvi2gW00TulHIPpztMbGQgJ2c2q55YfXsoa4yWuI/nFtC/nFV5AO7vddBJzR53ziNSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xXc3UYcXqqOn6qQ0hrlHUtlgGaASMlynTNnWXp+x17E=;
 b=uXZk4qE2NqtqxSDdpFWmMoi35RdUl3SISNlGcdzbbDTUKViYQYqQPaN1glx3h7/odm7dDExmeqrJoPfsrKh6rBRHowTTTZ1u8UdUCqOM8RhrHyjBfRF3dU97EB+2tDbhD/WT+BwR5zlldSFeNuUEamjWHPKYYeFzERL2fwhABrFDIVc+7OMkzI9KcC1qJKH7eT4VZevnPvcHCYpzee27m4DZfaNyvyscq8AH6FI8jOC7AMzHnab9asnshYM0JgY4lqlZ3pDPlkaYQFF861ksBdyhM/L8aMimKhiSKKCb5Y2fSXXsEXhA8SeoiSKvIRO4911fmYhDA8ipPqDf0X68dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xXc3UYcXqqOn6qQ0hrlHUtlgGaASMlynTNnWXp+x17E=;
 b=waWrgb9FWuMze0+g1+p5s3ysRf2ELFtEuc0r163J5FLZ17DivjOu9i76Y6fjNEoRBGuhXjoNiAzOcVBk38/D5Qf1Zq6z/XI6epxt9B/Mxjw1OEB6txKxe/a16zbYjCdN1CRylRdaSRloUmUYR559rQkirkHfeUuLW/vnOmdhERw=
Received: from BN1PR10CA0008.namprd10.prod.outlook.com (2603:10b6:408:e0::13)
 by SA3PR12MB8048.namprd12.prod.outlook.com (2603:10b6:806:31e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Thu, 14 Nov
 2024 20:37:06 +0000
Received: from BN2PEPF000055E1.namprd21.prod.outlook.com
 (2603:10b6:408:e0:cafe::92) by BN1PR10CA0008.outlook.office365.com
 (2603:10b6:408:e0::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17 via Frontend
 Transport; Thu, 14 Nov 2024 20:37:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E1.mail.protection.outlook.com (10.167.245.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8182.1 via Frontend Transport; Thu, 14 Nov 2024 20:37:05 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 14 Nov
 2024 14:37:05 -0600
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <davydov-max@yandex-team.ru>, <qemu-devel@nongnu.org>,
	<kvm@vger.kernel.org>
Subject: [PATCH v4 4/5] target/i386: Add feature that indicates WRMSR to BASE reg is non-serializing
Date: Thu, 14 Nov 2024 14:36:31 -0600
Message-ID: <fc71932d31bfdd0a2fd796b66eb1957b147142c3.1731616198.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1731616198.git.babu.moger@amd.com>
References: <cover.1731616198.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E1:EE_|SA3PR12MB8048:EE_
X-MS-Office365-Filtering-Correlation-Id: 4860d559-da3c-4731-12b7-08dd04ec1a6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?q0tQ+Nk+eCcev2xbSQYxFSo9m+UEmQEYk2njhVOwp5qo/ySVreRXJ9amIhRK?=
 =?us-ascii?Q?V4e3ExzlCWJuDfeo2UKW5HsCh/vqYR8tJcme/oIk+qUhkpfCvRKOKWP8mmgm?=
 =?us-ascii?Q?Ssd4F47HUYB0KzLT80XFQoANGpZhkA51FwSVnwuHe8fxEFLWzG5c2uOuSdq0?=
 =?us-ascii?Q?7Hjy79Fk1qdGZLFtrD1KR5rzWKiOL1la7twpGHwxKDSFKApMFdtpuSeRix7H?=
 =?us-ascii?Q?n6cLZTwxrrW4Omzzo6nkqdGjSK3huPX1crLTQ0ejSwmAmagZn0qlyCgav5At?=
 =?us-ascii?Q?JVv/0E9wOV/TsvcW8cBUzSntTgnuzVIjaeIzUYwpV0YTgKPuAtbVwY0qum78?=
 =?us-ascii?Q?ZfDTXZuMLn/tP/s3OomQqIT+0gbDj7B0Ez/m6dtJyW9BvowAcfBUryO84HuZ?=
 =?us-ascii?Q?eZFCMEWM1+uyYpbMHrN/rCGbtFKyHgyrMn0zYVFwPj1Xwa34FdKJCktvZcXy?=
 =?us-ascii?Q?wj+K2/heugkUgyEHTqMm7gpMBJL3UIf9asCvMkv8cU294KWmDih43wlSs2OL?=
 =?us-ascii?Q?je5LcPZJN85ZZ79ybJFrMrVgDtDzAQ2EJziwg4NUtKfAYfZpNw5O8bUddXNk?=
 =?us-ascii?Q?waSXZ0/daHMGKbPavU/k+ICPg+NXvLXpoUwRn30wXow7Eww45uMIzMwEj3VV?=
 =?us-ascii?Q?s1nKswRtdFhCDbyNQpD6SvMpwZX2+Q8wMmMvgM6AE4Iu/zqDHVhuUzTXTfTC?=
 =?us-ascii?Q?twl6fJuDp3R8eWxgqQscx/KSHJ6cSoKKAPLFP4xhcxPN1v3eBsdCP6AQydyq?=
 =?us-ascii?Q?ufxo8sr8oJiy7GNRMUdn/TI2ltyqRgxBhnmxZlpHFKjFMZI2VuwfncYDFxu0?=
 =?us-ascii?Q?TwI1/286+QlJgE9mWJnoias5vulvQjGRRrMiaI8+/nUPOznNSv111x2/P9S2?=
 =?us-ascii?Q?jl9QVs50CZn1n6dpLMrXa1Z1C99+V5Ovm28snC64T/dPsh7542sfIAeM/plw?=
 =?us-ascii?Q?7LRLQCbncfocF2i8TNWqZVZC8dA3UPQPcMzJdekzrjrIPjwKjfyvAYmHk558?=
 =?us-ascii?Q?WAewDtrdq8YbkmMfSi/nPso1joXFJVZN1cEo2jVqWNLved801cpBsoRH4tBR?=
 =?us-ascii?Q?WhCDzIpgP7lExBjOR7rswZWqueU0OJ906/m1wyqZy0pL/vwGBL2dfn3xA4sk?=
 =?us-ascii?Q?CL3IjVsG61OeF5OeUphFfTR6HY3HJwGchyoMMWl7LYSAYu18xo4gvJaGdl0G?=
 =?us-ascii?Q?Ib6bjZrY+wW7JYYKohIU0EqBEjVf28hR3S2ywDBezBWa+OEvzf2rs2KZ/pNt?=
 =?us-ascii?Q?90bR9ZnhLIl7vArVS1KwdIWmRPiBFLsI8WB40lB/RufCeEZkM1zSPHBYMNCo?=
 =?us-ascii?Q?zySivitc9nqS3yMWLRX/mSXED12D9QmJV26RCN+U/FH3PnuR71TNP3MEhy2+?=
 =?us-ascii?Q?fKRxS5xPCz5eYx96uWAGGPrlDsMmcTXSD3DCga6F7rpH2ay+9g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 20:37:05.7947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4860d559-da3c-4731-12b7-08dd04ec1a6d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E1.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8048

Add the CPUID bit indicates that a WRMSR to MSR_FS_BASE, MSR_GS_BASE, or
MSR_KERNEL_GS_BASE is non-serializing.

CPUID_Fn80000021_EAX
Bit    Feature description
1      FsGsKernelGsBaseNonSerializing.
       WRMSR to FS_BASE, GS_BASE and KernelGSbase are non-serializing.

Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 2 +-
 target/i386/cpu.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 4a4e9b81d8..107ecd2bde 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1235,7 +1235,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     [FEAT_8000_0021_EAX] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
-            "no-nested-data-bp", NULL, "lfence-always-serializing", NULL,
+            "no-nested-data-bp", "fs-gs-base-ns", "lfence-always-serializing", NULL,
             NULL, NULL, "null-sel-clr-base", NULL,
             "auto-ibrs", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index b65eedb617..12dafc9b32 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1032,6 +1032,8 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 
 /* Processor ignores nested data breakpoints */
 #define CPUID_8000_0021_EAX_NO_NESTED_DATA_BP            (1U << 0)
+/* WRMSR to FS_BASE, GS_BASE, or KERNEL_GS_BASE is non-serializing */
+#define CPUID_8000_0021_EAX_FS_GS_BASE_NS                (1U << 1)
 /* LFENCE is always serializing */
 #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
 /* Null Selector Clears Base */
-- 
2.34.1


