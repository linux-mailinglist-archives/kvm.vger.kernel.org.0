Return-Path: <kvm+bounces-8761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4AE08561BE
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B1762944D4
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:37:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85D93131E22;
	Thu, 15 Feb 2024 11:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="dh97JsU+"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2049.outbound.protection.outlook.com [40.107.92.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5989713174A;
	Thu, 15 Feb 2024 11:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996777; cv=fail; b=eZNrO9ZnEVxh0br5R7lbjLc30+L7FQfWFNE4PMRzox3J1SMU0DQIzqOxrIoKQQfubNmT13OHDVcX3HmE4faOqmAtnJoUC44Y1OhoFxQsG950bI31jrwWuJGQejr+ONwJyZdO/B6Svj0kukWpdBqB3nU12W9Mhj2RVXiEV03mhdI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996777; c=relaxed/simple;
	bh=jYRoDNxaPzcwAKifKNoKOTLDc/85teuq1fZpIL6JErg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rkKfgUmjf6S+ItDk/ivGjFi0VmSEN9pAcAq6VJ5A2WLb6uUMz/PCDQwaUbIu0pES3z9VDT2zTAoz6YEjdfTKbl+KOacmzeTPYfyJTa2ppRtiKZEOLHL2R0FT+fMtHNXt4Ff+0zTqzswpegQ6+voPCAfkSBng6Vi0xnU/k/VS2qA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=dh97JsU+; arc=fail smtp.client-ip=40.107.92.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ayXeZgpRQxjvD55hWEhh3grs3UobhIXP2NG08iW3jbB1u8j8WclKkRkP7ASLru/IguyZGBzc9wj2cjFj5yjU5qGZC8n+5loksrMXeShlOeK0LhX+z+iItV3O/1Wmpzt+jQIHgdpulI1AIEZGV4YhN5W5Pwyroj/9nu9YNAN9Xk+0QxL/f5ClZtxcrBnr+iMfovVOqgZo4DxWo9ghNqn4w7abHlhOiT69bwAaiu7CW+JaUpWibPc794HD52kyFGQwyKeQNtRL96bvPz0nQCk5lSs+Eivfo9XDmTqkZ3Yhc1uR7YQSp/jx/8LnbgPND8F73qn3Q/hvvXx7dYUiMTfenA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+fcY3Ww2nuto0h/qG2CHtGykyESDFZsMFxgR0WpEqK0=;
 b=Ir/Htq0DEW8YVzAxBy5xWRN+iCPdIRBs+sX0uVbWkGNUOiGmtrPszK6ddQojmi9YVNm1be7bezpN4o/80lbXuVqGNE1/xXDVkBMx83IItAbOY48qCMZ7kpyQAKyqoSgbBQmz5jG8hm2qBIvVmUr9Zn0j+F6HJ9jw675fM9yFG59tHVTPQgYo2cOsADUXm3eXfpjkZYd3Qao6EGH3eNviTLsI/ZaH6Hw0h46gVjNQXr2YGpuNU/tZF2h4ZCxlCAB2oS29Sf6Fte2qi/RDgMOio6O5Yl5JgbMpfbhP2eK2HKp2OMC9th9fQrs9doS1K8+OOVvB86/BAcj1mD9Lh101xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+fcY3Ww2nuto0h/qG2CHtGykyESDFZsMFxgR0WpEqK0=;
 b=dh97JsU+p7iG9TkqwOJv4yUCdWphrB2+R83pvNVLw/Gk2cNmJ3U195Z9QXfvu/asj+i4FebcqQ7FPHZIjfiHju7DP0kaSJJuhgBmwyqNQfZ2ChYV4iODjy45P/ftQ0hlT9JUcVxAK2b3U+dCqHItUuBbdAkVOiYIE4rvcXq7Y5k=
Received: from DS7PR06CA0017.namprd06.prod.outlook.com (2603:10b6:8:2a::24) by
 BL1PR12MB5849.namprd12.prod.outlook.com (2603:10b6:208:384::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Thu, 15 Feb
 2024 11:32:53 +0000
Received: from SN1PEPF0002BA4C.namprd03.prod.outlook.com
 (2603:10b6:8:2a:cafe::ee) by DS7PR06CA0017.outlook.office365.com
 (2603:10b6:8:2a::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.41 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA4C.mail.protection.outlook.com (10.167.242.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:53 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:49 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 15/16] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Thu, 15 Feb 2024 17:01:27 +0530
Message-ID: <20240215113128.275608-16-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA4C:EE_|BL1PR12MB5849:EE_
X-MS-Office365-Filtering-Correlation-Id: bc2fa721-c2df-4caf-2792-08dc2e19d918
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	uW0rJueWIUV3yg9JkNkgSL4mo8/F/yXRlVZ4CkFgRpuh/Gu3Y1eWfdDYeOEzNrkMDN+tXu0DT9wyN/m2+jJbSzwk1W3XnX8PL+idlkLKVb/jSdEQ7yIj51ANUb3u3vWidGuhUvz3XLI7H33NWi0JMAcbbrtmPE6MOxOo2OKB0wxkAHLw9cUTg3o1b648Aj2KDow9GpEc/hUltVe28xkNKZvUWG91DJZykidnwGvkO+7CWkwLPRIur79Go4jY2QiWe++ZUnXjk4kcm9GQun0Zxs2Ka6PW3qJEpbG8otBK1LrVKq/p+FGGwbM4LNXy3Xem6fozdG9UWigMiHED6DASQi4ZT29j1wYmZdYwSFpyabxMYFKm8O43RF5gJ6rosM3X/QcSDQ8w9ZEdPqbae5bkWUpW3X0JdPzcpMJNa2ddOPG5qjAe8kxCw2qbCZgSyI7kIXFcRrLFBb+tksJ0IgBEiyZ92AmrAlri/JLTgUgLw8N9elBZarj/Vw/Z0lM5BqWuG1Uj5bFFiylDo1ndKgL4zu88DDZBW3LD1b2D5XfUnVTDFBB9/3kk5wiqMTlGsUnrtLkoppMc/tgVn/WFHIaMt8nzY2AaYzCWI5Br04G9Al/VrttlcswWcGOqLcdAXxKQ0aAMAMPNWlIWCl0tWkQ3S7JjqZAV1qL6f/L+6vyE7eM=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(64100799003)(1800799012)(451199024)(186009)(36860700004)(82310400011)(40470700004)(46966006)(478600001)(7696005)(8676002)(70586007)(8936002)(70206006)(4326008)(41300700001)(316002)(6666004)(81166007)(54906003)(110136005)(356005)(82740400003)(2616005)(1076003)(83380400001)(336012)(426003)(36756003)(26005)(16526019)(5660300002)(2906002)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:53.0441
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bc2fa721-c2df-4caf-2792-08dc2e19d918
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA4C.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5849

When SecureTSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
is set, kernel complains with the below firmware bug:

[Firmware Bug]: TSC doesn't count with P0 frequency!

Secure TSC need not run at P0 frequency, the TSC frequency is set by the
VMM as part of the SNP_LAUNCH_START command. Avoid the check when Secure
TSC is enabled

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/cpu/amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index ce89281640a9..2e7d67e1f795 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -471,7 +471,8 @@ static void early_init_amd_mc(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
+	    !cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC)) {
 
 		if (c->x86 > 0x10 ||
 		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-- 
2.34.1


