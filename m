Return-Path: <kvm+bounces-45979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AEA19AB0437
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 21:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4BC317BECA
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 19:59:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34CD21D5B6;
	Thu,  8 May 2025 19:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AbwK0+2j"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6763421D3C9
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 19:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746734329; cv=fail; b=bOxot8tSGGTLLHtpeab0tK8iPvP0Rfw9JAj9H4MrY/pFrEpfUuwj+vgdTVRdbcAgRw+xwUEjfqYfTnHse9QcZ1Xj7jBuxqNjwZTyxRD/YvwcdhfAsezjz5RIQWvXgW73vzqd+Me1zUbJZIrymzUcKELkjga6ZCalz8W+pVjQzAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746734329; c=relaxed/simple;
	bh=ClVBBbzNkj7Dz64YTSqIfm8Pse0S+ZeofXPaU6j/fm4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f5UHTL27zea7wvXNjcORlWNEAEqTASf6tAo4ulEP6068CJolzHjRvhCNiUXc1reyehSL4BDRrIDUYtlk0dNgzliaXrdbetJXGMR3CeRwKrbo2ZSNd5gb/sPO6BoTvcn5aaLWLykvHlGqO9opOtRhXSJYA0gOhXSJT2arYBXsPwY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AbwK0+2j; arc=fail smtp.client-ip=40.107.93.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HOfMFxybuMY+oZDyUiqKNcfeqt7RmaPCeYeWvtB6/w7fD74R6bbFyfBNR/mmdL8XzO6TN70iL9P/o7LOxYLfvfAvuyUXCJmtdiWRfQv4VWzSy9su+p1ndOu7KRiJX49KolEbH7EeBzyzCTVDsQbTHAYDWFvuXOfoyBBBRrH2uTGyt/gz+gBTcxYS44Bgl8kqZi/HZXCG7JxGHH17/0XhMcR03gZWbfOFKu5zxUqJwly3E/26EWBGH1E32U15ujwLIKhhFusbkNMWGQqUYCIzjDKCgvbE67nxJiA8KTddJz3pIVYJtoo6y6AdQ1wsqOcCmhUPmWik7W4NfKT+l1tcWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UlVHo4nglJ2oRd7FJjo7b3n0lZCDNR4nht21u51PTSA=;
 b=HMA3SNk471aHRRhnRvKXyyJiVQU46aBMW+fz02TdAH8nLHmoR62x8uhUeX3joz69/yXEkIQ44rY5P73MP3nWZJ1q2n3XWIfMTD5ndZbiCjdzj8l8CYy1atz8YGrAeyfWM1na+zu1dxpVzUv5+Kvw+K1wsqkJ+C5EwqcSNSVVTVaIQzzb7k5O72hUUG0wgMZIxDtPsDjW6wkQQNu8HUqPc9QLlPp5G54MbALH/uAfjvUJOyPqR4BGEoEYKYjuWCzfWUjTfdHllFnTJsnZLcHVBRX7j5NInVY9yyrDIunS7g+WOgNY3QrggDnESaWTO/6htaaqnFVEYmE8hgi1/xqxAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UlVHo4nglJ2oRd7FJjo7b3n0lZCDNR4nht21u51PTSA=;
 b=AbwK0+2jgFPSpaz4EKpQoVtXxdwddJarRQIJEl9jQ0V3drETUnD3MNoKDd5NxsPo3Ru7D/uDzJguejrI2dYfpVnAqse72zG/LijvLm1vwiLMAqwR6ywfiXNvYCBzukBqDKnlQz1fk37Rui6jyNqqzS9HWI8eAr5a1AHS6O40zeA=
Received: from DM5PR07CA0097.namprd07.prod.outlook.com (2603:10b6:4:ae::26) by
 SA1PR12MB8143.namprd12.prod.outlook.com (2603:10b6:806:333::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.24; Thu, 8 May
 2025 19:58:39 +0000
Received: from DS3PEPF000099D4.namprd04.prod.outlook.com
 (2603:10b6:4:ae:cafe::d2) by DM5PR07CA0097.outlook.office365.com
 (2603:10b6:4:ae::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8699.30 via Frontend Transport; Thu,
 8 May 2025 19:58:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D4.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8722.18 via Frontend Transport; Thu, 8 May 2025 19:58:38 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 May
 2025 14:58:37 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <zhao1.liu@intel.com>, <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
	<davydov-max@yandex-team.ru>
Subject: [PATCH v7 4/6] target/i386: Add couple of feature bits in CPUID_Fn80000021_EAX
Date: Thu, 8 May 2025 14:58:02 -0500
Message-ID: <a5f6283a59579b09ac345b3f21ecb3b3b2d92451.1746734284.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1746734284.git.babu.moger@amd.com>
References: <cover.1746734284.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D4:EE_|SA1PR12MB8143:EE_
X-MS-Office365-Filtering-Correlation-Id: d5b0c6e6-f90f-4bb9-355a-08dd8e6ab99b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?do6298Jh63ZY7qsPO6ec7GkLEBm5xVBjfp4GPA1emg6R45CuoQDEZ1a7DFcC?=
 =?us-ascii?Q?SbMrGH+fYNE6jsEyv5IA42VBzEdCxMAn6D23CBB5/t/zc54XNdG3orf2MsWZ?=
 =?us-ascii?Q?qi/03e0K4hfa77APVRfBvdFjKXr3+j1ZdFGIBL0CR2HamUSOODE91lSS2hJQ?=
 =?us-ascii?Q?ggsg2Y//RFb3YuMH5+qnDDvKjYeetd2hsjz24nJR8i8ZPzNbHdV/SSQ/lIm5?=
 =?us-ascii?Q?HYei4GjQ18AH+e5RVMD946NGApDE40Yp61wO3Wi67wOYRlk9nItqQ4k2WwIn?=
 =?us-ascii?Q?R4ddPio7HYw3tRqLr0x0quxwwkssU7ACvXbpMeWsKKeu2kIymizvzAnUH0VM?=
 =?us-ascii?Q?ivdHCXJM8X7rIaD6vjhaezYobhL3NTFWwVfTme9GuHqTEK+GXNmtU7gcP5UM?=
 =?us-ascii?Q?ljG3LkJp24nbyKEJEf5X+C1hKG4eG2w2xp+YwqcnbMIaDBmotk4HxPvs8yXg?=
 =?us-ascii?Q?TPi96CfEs6+TOrBrlbYClWw55f4SZ9cNifO/uxNddlAL9kAjUkyLP5dT991R?=
 =?us-ascii?Q?Dn4fVOu8BRtv4OKe91KuXSqGr2GvMt8KleiNHY7ODATYS0joNPYfyNdViwTQ?=
 =?us-ascii?Q?aP4fH5JYjkutqycAO+pVKFxU2IAiYWduP+NPWHrXCdPzi64HvvQiF1OcNkSH?=
 =?us-ascii?Q?Wp/87P+AKN1kFjscO4FxfH+PLxj6x0pHOvAchuXJGG4Z5yKiFmmZwai9Sc5s?=
 =?us-ascii?Q?2D/zLnbh2Od8z6DXCBCP8DjvLS66ZsuKisHjJV41NCcdEJH7ogQLRavdh2lv?=
 =?us-ascii?Q?UI7D9epuuGgDyt10zw2a/Z6BdjvObS88pLt2Tp7DaeK/npX8M6lHqZ1nx/t9?=
 =?us-ascii?Q?x3RsQmsnTLWQl5cijNSmPZhjWqKWZebbm4ZevC2FQYF5ncoYCgmxv2RKegXO?=
 =?us-ascii?Q?yGji6/KJNaYCmzPi2iGZj9LMUcjQgioRQVAesBkoxAoAYxP4OMO+9dlZnr4B?=
 =?us-ascii?Q?bEZDNH7HalsgJSHEwyVES4n43dgiY/TvV53zaegtt4CUJC2UQAsxjFiaXIth?=
 =?us-ascii?Q?032sDjT2EVOCWugiUpQUIXc983rVuXqeBdGdaLrV7N8Jj+3e+aZfn0JHP7Pe?=
 =?us-ascii?Q?1BcgrsiCMvRyZaum760mXkQpLjDvGH/FbG7Llvyo8P9eGlqw/xP36eopkJx6?=
 =?us-ascii?Q?dtf8DwkRZ0vq0GNDMz+C2QstJvRLRBGecLdpZ3zKlFPl2fQOu/TeLqgJEM5x?=
 =?us-ascii?Q?5T70/yUjRi4B0X0GIu+L+xyvM+OkmFzwn0ZXzl238GD+o01p7iuYdyXfRf72?=
 =?us-ascii?Q?JNpzIUrsRikw0Bxro8cjWTtEQlzWOZvtuJLpU1DWpBIefkHYGk4fPgn5ucQr?=
 =?us-ascii?Q?BybRV/+sJ9bfTVURxxAlB7C7yksU58dJmDjv2z3Gv5GRzH62g82Jq1/ul+ef?=
 =?us-ascii?Q?885zRMvd4Qefqesl8DP0FwUy5xDLn7slH4HZLz1M25WkH265KQkW4Dscd9C2?=
 =?us-ascii?Q?V69ofI5PxCEo5SIb5COc6ZuFTICNozVeaT/9KsYLd0MJ2DY1uJF02YWox/or?=
 =?us-ascii?Q?Z9vO+9RU0RMOOlDK8viZ/7UfWW80YQqsFHhj7XOmgtgoTcmHQG9bNKDWMA?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2025 19:58:38.7300
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5b0c6e6-f90f-4bb9-355a-08dd8e6ab99b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D4.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8143

Add CPUID bit indicates that a WRMSR to MSR_FS_BASE, MSR_GS_BASE, or
MSR_KERNEL_GS_BASE is non-serializing amd PREFETCHI that the indicates
support for IC prefetch.

CPUID_Fn80000021_EAX
Bit    Feature description
20     Indicates support for IC prefetch.
1      FsGsKernelGsBaseNonSerializing.
       WRMSR to FS_BASE, GS_BASE and KernelGSbase are non-serializing.

Link: https://www.amd.com/content/dam/amd/en/documents/epyc-technical-docs/programmer-references/57238.zip
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Maksim Davydov <davydov-max@yandex-team.ru>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 98fad3a2f9..741be0eaa8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1239,12 +1239,12 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     [FEAT_8000_0021_EAX] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
-            "no-nested-data-bp", NULL, "lfence-always-serializing", NULL,
+            "no-nested-data-bp", "fs-gs-base-ns", "lfence-always-serializing", NULL,
             NULL, NULL, "null-sel-clr-base", NULL,
             "auto-ibrs", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
+            "prefetchi", NULL, NULL, NULL,
             "eraps", NULL, NULL, "sbpb",
             "ibpb-brtype", "srso-no", "srso-user-kernel-no", NULL,
         },
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 4f8ed8868e..d251e32ae9 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1070,12 +1070,16 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 
 /* Processor ignores nested data breakpoints */
 #define CPUID_8000_0021_EAX_NO_NESTED_DATA_BP            (1U << 0)
+/* WRMSR to FS_BASE, GS_BASE, or KERNEL_GS_BASE is non-serializing */
+#define CPUID_8000_0021_EAX_FS_GS_BASE_NS                (1U << 1)
 /* LFENCE is always serializing */
 #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
 /* Null Selector Clears Base */
 #define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE            (1U << 6)
 /* Automatic IBRS */
 #define CPUID_8000_0021_EAX_AUTO_IBRS                    (1U << 8)
+/* Indicates support for IC prefetch */
+#define CPUID_8000_0021_EAX_PREFETCHI                    (1U << 20)
 /* Enhanced Return Address Predictor Scurity */
 #define CPUID_8000_0021_EAX_ERAPS                        (1U << 24)
 /* Selective Branch Predictor Barrier */
-- 
2.34.1


