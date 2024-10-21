Return-Path: <kvm+bounces-29233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C5109A5A09
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 07:58:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC79328202B
	for <lists+kvm@lfdr.de>; Mon, 21 Oct 2024 05:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5E01CFEDE;
	Mon, 21 Oct 2024 05:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SJnnIc2T"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2076.outbound.protection.outlook.com [40.107.96.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF07199E89;
	Mon, 21 Oct 2024 05:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729490291; cv=fail; b=RWSVgsN9x476XcixZPxRjJhUHPu4nmbauIhOQlZHgJ0gFPaarOqDZGQu7MFVYvXK6x3S6a+XF96PMx2zm1qUWZGapRrOdEVH21JNi4YgIEfWYJUz6a55e42FYvGU9jpN1Y4XwrMzzLsO9xAGUrfqMd+XvSkOOJFaiNcyZiGJXNQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729490291; c=relaxed/simple;
	bh=OB/6ASxdYsnfcl4J0jmZ0yh5aIWCHB0Fx5bvb3/XE7g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dlNczenyJV1mnUksHRBkzFTpEnZQ40+Q8vpB7I47LlQgoExrq/xfqU6Inv57/On2EoSzVaybmMyxQV9jFTOUIGeXD9fsQfyQ07on8OLAWjg55XkKEo3UY+l+0j1htktf9G3XU1oLGisvq+MMWgEr/vjN63SUUFuR5Zvr1GEQ8PA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SJnnIc2T; arc=fail smtp.client-ip=40.107.96.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QKdjK4vNxp6CZtYt/p0vmuY3y7p6SiSW3IeWnzA2o49WnA0Wd/MQB0qC6HK4XNT/io8K2GdlQpVttPHuwo9+2iZu0rAT6/f2FVXFnxoyd58hpsp4XPLALNFUj7qiVzUqnZEzNU0MlY2nDVwYx8EgD1cc9HvWc4kyK81vhJmjP3dxTj38KnOgmFU122JOn7VoP23hMRaO/GAIaye6+nXzd7s3AT84l7sgxImT5bLs0YQB0XVzVBQqmEBX01J8ravrEMDSxS/imXV6Rdy6Gufsw1Rndz/IrrYQQzcqtdLxjWzVBYBCGHakFCdzEt3hfQZVkAdh9lshKOuz2B/9rSjMPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sYYQW7AgR12vwgxAo6ihnztYZVBXhW9FEUsl9seDdjA=;
 b=MQ0c3idygmmP92zPv9QR9ysYw+nKMP/BviCohYsXfvBjbl5zNLB8Cd4oNuMy2YALC49NuvS3L6UFUbJXNTpmTJUR851G4Xt6zfKZD3pAQ+HF0PVDEdIw/mpGmDFYKxG+oxK20wFHQQO6pJqAIkGSAh7IcOUbgzUhs5FYOHnwjGfscs+XMnK4oWRnZJVPXyA9/xqta8GkTzEJxtU0gP6OEyfPbK++Yy8vwQ9/o0hATMHx4oQi8qFisrG1CXj+fgXWZ1Y0sRwxA0ggTcp4nUOlVtrK/xmFgOPIKvfl7bovTDIQOBA8ZRemAcUVDVFSgA60uOExLbtElCwFPfK4DP4yYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sYYQW7AgR12vwgxAo6ihnztYZVBXhW9FEUsl9seDdjA=;
 b=SJnnIc2TsAB/8f5W9wi00+pXN/Jnl+vZksa1jA51aLhZjjv7mnntxrTK6GB3siXpUxA6YyNdNkMAbCqdVzFqEDJBQ8ps4rTmjil4N1tKx2rGDeQtH41qkFAlYaw7k8pIl9abrfrKARdXxkAsxgG0i9fWINoIpqHV4vsbFh00yMY=
Received: from BYAPR08CA0034.namprd08.prod.outlook.com (2603:10b6:a03:100::47)
 by DS0PR12MB7747.namprd12.prod.outlook.com (2603:10b6:8:138::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28; Mon, 21 Oct
 2024 05:58:07 +0000
Received: from SJ5PEPF000001D1.namprd05.prod.outlook.com
 (2603:10b6:a03:100:cafe::c2) by BYAPR08CA0034.outlook.office365.com
 (2603:10b6:a03:100::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Mon, 21 Oct 2024 05:58:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D1.mail.protection.outlook.com (10.167.242.53) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8093.14 via Frontend Transport; Mon, 21 Oct 2024 05:58:07 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Oct
 2024 00:57:53 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v13 08/13] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Mon, 21 Oct 2024 11:21:51 +0530
Message-ID: <20241021055156.2342564-9-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241021055156.2342564-1-nikunj@amd.com>
References: <20241021055156.2342564-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D1:EE_|DS0PR12MB7747:EE_
X-MS-Office365-Filtering-Correlation-Id: d2898d62-fe2a-4fde-b570-08dcf19555cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Q09FVAtYCu5qLOmgXvhyT4FNrgEiEMoFYxrEza4ckk64Ml4uoXXZ2sQub6sm?=
 =?us-ascii?Q?bcqDlsUaabJMTeWhyA4TSAwrJjQHYHNCZ2wk+JBTJGGOyu9YszJ4GssTfm/b?=
 =?us-ascii?Q?gXMh/XQgDOqcl+ZSfbc5mtBWxp0cpkIRBmPVjx3xJwZ4qsggMLycBYioOJqp?=
 =?us-ascii?Q?7Z7toNkrYOOeAI6ZuVWmZsrXWp9o93GtmazmMdu5Pfu+o/L+vI/0a19RiyBt?=
 =?us-ascii?Q?mDdfsDSK+r713SMsZFasZ/5Ifhx/eASMOZarBCPuMmVaWWBMwu4sa8I1RR1U?=
 =?us-ascii?Q?3Rqw90ox8Jw95CQKWfYkRl91X3coD8pFJxGZ/wl7PvErXy1l7a44qkRSZIQa?=
 =?us-ascii?Q?IXzl1QXilXRofhE7cjvzG9hlziGiwa8yQgjoYNXxOxa3/JJXJIZ1q+Ge4DcC?=
 =?us-ascii?Q?ZGDH4zEVIpQ9jszvbAsPqJc1Ba5Nk4dLr+tJfRNBq5qZ3u8EYBqVOVjKKDoa?=
 =?us-ascii?Q?snG1Bg/a3JVctrYPxtwr9Y/AiiUIaBeMKwsOBPN+b5bdmYGa2rNl8DT4c57p?=
 =?us-ascii?Q?Czf1PcXS3t7APeuiPBOs58JOn2f7FylfrMAccY2C+jqnGwUbWfGCgBjW1MAN?=
 =?us-ascii?Q?pAVOItk8dTQkA2h2ESGSLn31TlmOU0fH14OU1+Af6fEanKV5eoZbs9AD+T9P?=
 =?us-ascii?Q?ohwb24KdTFgdsW/IwF014vgHhHK8X9yvFFYnaPq3Fd6ePJSMJpazZAfUqT4w?=
 =?us-ascii?Q?gAOycUEeaUU2HtAiXRULbwBJvfCMMLf+tbBpIKJ5SrWycLRDLQgry9Fqxz0Y?=
 =?us-ascii?Q?AAbcU2IgR+lXW/lxOsOIBIo3dwdm4g75ChzIqa0pFt+qm32YAgYA5omoqmSd?=
 =?us-ascii?Q?oWnMONr3tGwuk84fpAtGKZf3kNZFV0MsVbbIerQEqYd4xTUOp4SvLdZ3iOGm?=
 =?us-ascii?Q?9d5/jgzcMIEiZ7FRoT80hpVM0Zb47wR9FAcHnoX1YfUmAnaaU5ZY1ImdZuC2?=
 =?us-ascii?Q?D95PfOtS3kGHjp0VHN7UPtPqZhdEYkk1RjI36JTqVnbbJwrMbY84bo/9ouLY?=
 =?us-ascii?Q?YNoigARNWHiv/Ei0KWSolTUc11Aj6iSpXEQvqQfg2cJD+Xaw5fGEsgEhondJ?=
 =?us-ascii?Q?JPdB3xsczoQ1RlWYXCI2rUNOLwyV6LSHImjn9GdK7tD3n2ZmtRbvzAVO2H9x?=
 =?us-ascii?Q?SEEg+r0ViEZq1ThVhyyTHgn7mDzrJRrjLE2RHljVNn5OkMGgy6uVijXBBFwv?=
 =?us-ascii?Q?+IfbFfQ5GiaAm7kaqejwZIE0emUATX4jEJcepGgcm16mBQPzksbREKid6kIh?=
 =?us-ascii?Q?wryG9TWoc9CtqTu/SeVjNY8868meAip5LjVFWR3CB7HBlXq6/oK1xT4S9mDT?=
 =?us-ascii?Q?wWwVignTLJw6/KhZrVW+aHtzhwF05almXezMeN+ENVcq79LspIq2iUE0YOnY?=
 =?us-ascii?Q?Fkwbem3U+Eik5zCuCTg6xRHxtbLHYjWfWR2DHVYi+AEupUoMsw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2024 05:58:07.0796
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d2898d62-fe2a-4fde-b570-08dcf19555cd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D1.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7747

When Secure TSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
is set, the kernel complains with the below firmware bug:

[Firmware Bug]: TSC doesn't count with P0 frequency!

Secure TSC does not need to run at P0 frequency; the TSC frequency is set
by the VMM as part of the SNP_LAUNCH_START command. Skip this check when
Secure TSC is enabled

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 015971adadfc..4769c10cba04 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -370,7 +370,8 @@ static void bsp_determine_snp(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
+	    !cc_platform_has(CC_ATTR_GUEST_SNP_SECURE_TSC)) {
 
 		if (c->x86 > 0x10 ||
 		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-- 
2.34.1


