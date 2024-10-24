Return-Path: <kvm+bounces-29672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 961FD9AF532
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2024 00:19:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD9241F22A94
	for <lists+kvm@lfdr.de>; Thu, 24 Oct 2024 22:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CE2F217338;
	Thu, 24 Oct 2024 22:18:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="itIlbqew"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2085.outbound.protection.outlook.com [40.107.96.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66D8A22B674
	for <kvm@vger.kernel.org>; Thu, 24 Oct 2024 22:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729808325; cv=fail; b=mZBfBkGHaFrEHHGl2e3jZUQn8XwvNhNe7DcZ72j3+eU/41e9Jx7S0FBhIQkkAWAbjBb8RI1u8wLwNZdMpZrrHilRsJoIkAqRjgVydAZuBNeOc6csre5hajX3ISMzkUj5KHtM+3nb8yy8PWVCfeMAQraJmxSMGGtS/jFeknAWHCw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729808325; c=relaxed/simple;
	bh=ay90qHnexYZ2RxCejUS9Y3GNMWpu//RrCBHTrBtRT5E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eG+eB8L92Pr8t8vtRhCX4PXOdD9MO2sSFDMsdI5FTBzjnR6Gsx48OVipYLvETwdsTYiHABnOHGFYGqG//4pdbpxWrrxhBKNQlmXUv1eVlgupSB5YDVM8EdhF62I0BJWEM1k4WB7ro5juPPdqGJYpMBh7Wk08fmD4zgOnpr8KLQY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=itIlbqew; arc=fail smtp.client-ip=40.107.96.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJ++OFrgydUXfAOX/oNCgsae2YKGF9+uNfutk8V6CGW/Lh3Mx2GC0IJ5vVdR00iZlKVjeNLvnggRmV8aah2rS5QWOeLKcBc5MS9VeHau72Zl0HMdrXYC6WAYp07z/6q/F34nmF1R48lLQbxEvRJFqGiamhA18Xim7TQ/jNgfyTrt1Jj0tgGmO7Zr39m3lBcQTOMoNB34AIx3gF513TFXi+ZdAr0ZW511LVXb98V4NKNhnt2OB4KZ4T5duOko73dRyekAjavWj2MZ3WjEEx5VZ+mRB8/cf3MkryX3k2t4F/X2XFt/xA3YWQyEvEa3wbF6xscobmPD/pUisqHrxVERSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rmiIcjcjIW4/tzY0k7YnP/2MehBjhH7SA3zxM77lgwk=;
 b=YAR0yCMJUn1DMIK6hsth0KnIwVVHE8gv02HqCE4hiYwcphiLmo6DLfwrR3e3FfDQWLBSpbBoUhJIucUZjAsvfCS4q+YUDbzuhWs5PbsIoyw3TEzy1jBXcsutHSstlghwidScVnYcVR9cC2Rjnol/e6R8dcwg0AQe8eEemxuhljGzHfK160c7uwp3NIj9CuEMKsQZiRJGuD7pbmsCWXBcSnfQOlaUaPaCtDh1oW4atjIRx5gvyXFjN4+3BRW/714UMGoBngeKg0ZXtMZZed/924m/XQlAjW3AuTpG6KXm81bTiUfx7LudYniaNLUZsFQ/W7eOo+P4v/W1mrdjERRkQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmiIcjcjIW4/tzY0k7YnP/2MehBjhH7SA3zxM77lgwk=;
 b=itIlbqewLrC56idmEfpVlDFGPH1mwWIf3JhlwmEbzOUFTU7dV4om5PSTzilXgVqIFmGrj3yFrXWP+nh7utc2t+VsUaURYhEaDfYJWXlkBFJ9hUW4+2lNwfHh9c7zcsLo1oGNJ6q9FxqYV5bXXmYBGOA4O02vYMQKBm8dbBJoMwk=
Received: from BN9PR03CA0792.namprd03.prod.outlook.com (2603:10b6:408:13f::17)
 by DS7PR12MB5888.namprd12.prod.outlook.com (2603:10b6:8:7b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.27; Thu, 24 Oct
 2024 22:18:38 +0000
Received: from BN2PEPF000055E1.namprd21.prod.outlook.com
 (2603:10b6:408:13f:cafe::48) by BN9PR03CA0792.outlook.office365.com
 (2603:10b6:408:13f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.18 via Frontend
 Transport; Thu, 24 Oct 2024 22:18:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000055E1.mail.protection.outlook.com (10.167.245.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.2 via Frontend Transport; Thu, 24 Oct 2024 22:18:38 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 24 Oct
 2024 17:18:38 -0500
From: Babu Moger <babu.moger@amd.com>
To: <pbonzini@redhat.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>
Subject: [PATCH v3 1/7] target/i386: Fix minor typo in NO_NESTED_DATA_BP feature bit
Date: Thu, 24 Oct 2024 17:18:19 -0500
Message-ID: <a6749acd125670d3930f4ca31736a91b1d965f2f.1729807947.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1729807947.git.babu.moger@amd.com>
References: <cover.1729807947.git.babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055E1:EE_|DS7PR12MB5888:EE_
X-MS-Office365-Filtering-Correlation-Id: 308b0fd6-8453-4733-b1e0-08dcf479cf71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?yBfvPWMGYaVRxmPGU2d+AReor1D8HwgKCJt9InWgg6y0Os7nKlL5u9XcQO2C?=
 =?us-ascii?Q?tHDxCSRCvcoaPoLD/49y6ql+IDC3lF3p048UoOGrqJXK9URJ8WQZSZ2OZ+HA?=
 =?us-ascii?Q?B865cuowMftLRzPrTLscCyU6mmEuzQnkr5KmlJdG4Wz43g5JVQlxm8XGoj2c?=
 =?us-ascii?Q?LKXTsP5kBwQg36o34vssoXyWU4lA+ncWL5nsMgOU1F2mqG2GpUCaqk6pgebk?=
 =?us-ascii?Q?gk33BqIu8roilc5WowGMYCsrVHQLgUyyJhcOkES/kiiJKt4kH9WXMr7BK/eE?=
 =?us-ascii?Q?B4SX6zcDbEoikqQ4a10sAbZpZFU258/D2EtM+Zosp1TUNCvfs7XV7KIp8TFW?=
 =?us-ascii?Q?5JX5TpAOTM1mJcT8adbaqxcPMYr/vUCCcw3IPU4ZjNYC90+IOYsu4xxF6bZq?=
 =?us-ascii?Q?3/jHKrEOfXI0NcQVb5hFkn2RSeaDPKdoDFPn7NVWUGUd2yhni0UfbulSfclw?=
 =?us-ascii?Q?zSKs2TFRloaauQOU1AuDcXLbqxkxd87jf2ZofP93mAO4ukRNHUMGN8tn5/T6?=
 =?us-ascii?Q?xlC4SklbbRG6S2zsUd4Psy9hVCKM/3lH29phK/EhJ0xrMfArZ/H5PMeCzKV3?=
 =?us-ascii?Q?wuC9kcB/ZRTx5bpqSt0tp+kNHR6Kr1ruFaSkTIMMcZfpW4Sdq62BttXr4rh7?=
 =?us-ascii?Q?E8/qROwH1FpQzkv+jJtrbYtF6/M9KXLs9xTCd32UgLTZbVEvPPdmvQCYknjQ?=
 =?us-ascii?Q?8bFDTxjKuxOmC6jNlLivA3UDs+lJUUpd4UtriyfRrwiPu+ZRKBfC3byReGNs?=
 =?us-ascii?Q?jZxxkTP5ccHBmDzUoEoAYSc9MMXqERBekZ5rkrDvO1Fis1mOTBRF6ExGXiSX?=
 =?us-ascii?Q?n1xqsn8w1aXgy/6LwqpNnCxJZF2nMaqp2DzJwVnyVxh54WEZYGctbdQhOT2T?=
 =?us-ascii?Q?MasJJAdTgeNNoT/eyI1t2urvPmu+JCzZxCQKORv/E9K74wQlJy6rFzjOHVlH?=
 =?us-ascii?Q?ai9FGyqUw8JQ6ywoTqdZARjIG3TAx47H9L82iCE40kYwz7h280paB8Hc2qbm?=
 =?us-ascii?Q?DmDIAf8yN/A4XkR28G5PkWi/0PTfrYCF6I6+/olrU2dR6vei7BfLcILiAIVT?=
 =?us-ascii?Q?gLJ3q7dOgzWdIa0xccFBdXkbrSCp4v5tmgfMROtr090VFuTnJ9kK2cU+yZ+t?=
 =?us-ascii?Q?ctqJf7/9p7AceGaosHPbtvhSMj2KeBKOMU7yhIB5mTzbJumwN4jKiXfZK71a?=
 =?us-ascii?Q?XXD3QEQwx8T0mHO18VdLwA1a2Z68toSkvSNOLBn3VWmQKl8hAZlwlW6xDhTg?=
 =?us-ascii?Q?YJ+lidD1Sv0I7UEsvPzEUqV5LlYS2x2mf/XxvQ4q0fpJeJIJKPD0Fjxnf514?=
 =?us-ascii?Q?6mTHBejDyhNrmaSv1DWXzAXC0t3kWxDqLDJNO8bJ9Gro6+dvqSeRVBxLjri+?=
 =?us-ascii?Q?rUarPwPmE3KLox+v17YB9z/ZIwdW3COhIANGsDp8muHgqRK4TQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2024 22:18:38.7697
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 308b0fd6-8453-4733-b1e0-08dcf479cf71
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055E1.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5888

Rename CPUID_8000_0021_EAX_No_NESTED_DATA_BP to
       CPUID_8000_0021_EAX_NO_NESTED_DATA_BP.

No functional change intended.

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
v3: New patch.
---
 target/i386/cpu.c | 2 +-
 target/i386/cpu.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1ff1af032e..94faff83cd 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5226,7 +5226,7 @@ static const X86CPUDefinition builtin_x86_defs[] = {
             CPUID_8000_0008_EBX_STIBP_ALWAYS_ON |
             CPUID_8000_0008_EBX_AMD_SSBD | CPUID_8000_0008_EBX_AMD_PSFD,
         .features[FEAT_8000_0021_EAX] =
-            CPUID_8000_0021_EAX_No_NESTED_DATA_BP |
+            CPUID_8000_0021_EAX_NO_NESTED_DATA_BP |
             CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING |
             CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE |
             CPUID_8000_0021_EAX_AUTO_IBRS,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 74886d1580..9eb45faa65 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1014,7 +1014,7 @@ uint64_t x86_cpu_get_supported_feature_word(X86CPU *cpu, FeatureWord w);
 #define CPUID_8000_0008_EBX_AMD_PSFD    (1U << 28)
 
 /* Processor ignores nested data breakpoints */
-#define CPUID_8000_0021_EAX_No_NESTED_DATA_BP    (1U << 0)
+#define CPUID_8000_0021_EAX_NO_NESTED_DATA_BP    (1U << 0)
 /* LFENCE is always serializing */
 #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
 /* Null Selector Clears Base */
-- 
2.34.1


