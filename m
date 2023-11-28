Return-Path: <kvm+bounces-2612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 820BB7FBACD
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38139282E77
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BB2E58ABA;
	Tue, 28 Nov 2023 13:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uBKKM226"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2081.outbound.protection.outlook.com [40.107.100.81])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1866B2126;
	Tue, 28 Nov 2023 05:02:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D66yO6U3eFKLSDcKxJMR+hA056K40H7207YoQCcTL8KZ9jwWARWkb7ITnULBqppFtilNaWiaJcP3EbUGK4VF6QW3gAt0qyrYV0aHlKu4nBRXke9uPjufACGGFBh76bUqxRieYgszm8TUm6/kIuuLvOwTSVAxhOq0YSSy713Ym8heivwKjwhz19c+bEKUcrmxjIfEkfnmrjbsVyjJd0e57LptKrv9CwwXIWReLiIqMiPkkBy+Mm7EsVDV26VsDDzEPOeayNjaQjHKjcbvR2QVtgRQgGYN7o2KbzqT7hTP4WnXQttnVankc/QT0RdzwgoicwJSrydAtw314or1Ja3NUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dugs95Hj+tOk0V2ks0J2fCcDN8SZXA3/1orRt+znSmE=;
 b=ogjfPKS2IDDMSJb3ZJGLWQc+TXegQR20z5XuGXcMkqJfD3bFYjkhbWBFLX3oeYwKUk+Ohu9+JSM69L4Dz2bEBdghcbRGqSmfyZdWBAMWVMAPNxyDF68tZBX1Us4ZLVp9I18Jf2vYSSxknB8JVdP9FSk/4MAnqm0PWSYmGe7loTiN/1zlJ/QYNoWLQEN3wuTiPHnEtT4ri4WhEPwMDzDSP97Oj+eM604LGzUt+zLAER9/O0aa3CZ1bcK7b5afDIW+/2F6uxSpcKrzH81gu2Mh43CNlpDDs7IMuDAJrZiD7n/g9DvvGp9PCEV9KNG1sppJVin+RTSLpdZTupsuhP6j6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dugs95Hj+tOk0V2ks0J2fCcDN8SZXA3/1orRt+znSmE=;
 b=uBKKM226uXjYaaXTtK6wi3L0t6WZyY0P76oEaQSzPXm1VYcEVEKtgecNg3tJSp+e1GpCEPbkSatsVPwwUhV0Gam+5yh+g7S/0VTykX0pTYsgmwSxVWPfmmcy2WIlIoR9On1XBLpcTcSthS/yd4avbsFarKS0C7SVsdd4NVXDvIQ=
Received: from CY8P222CA0011.NAMP222.PROD.OUTLOOK.COM (2603:10b6:930:6b::18)
 by SA3PR12MB7782.namprd12.prod.outlook.com (2603:10b6:806:31c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 13:02:12 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:930:6b:cafe::b6) by CY8P222CA0011.outlook.office365.com
 (2603:10b6:930:6b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Tue, 28 Nov 2023 13:02:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:02:12 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:02:07 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 15/16] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Tue, 28 Nov 2023 18:29:58 +0530
Message-ID: <20231128125959.1810039-16-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
References: <20231128125959.1810039-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|SA3PR12MB7782:EE_
X-MS-Office365-Filtering-Correlation-Id: c578c474-ade1-4079-bf5e-08dbf0123cae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	QBQE3w2kvXRE4wewRLKFK8hMwlkFZpBy2HRkSRAOaBPEzUWH3u1pcOrLg6BQkxSP1c9ngrdHajDDUOd4adDYe8TtxCpbMl3fqVZ4YsTZ+swP1lU+pNRDpGTJka8D6lNTcHyZHZOalWmqKVbSQk0QVqkJb7A3VdetujnKBbDU7dsQnmiJA9LgoR7swx/AzMdN5Occtkshr+P0T7Y1+3fFvpc3/FwNNEQYbkINqmE9xeBiNN0y1p69dtekGejs6eQ7j1WaZABm0JX39k06LZAme2J+XssAJbxgCYmVnSgw9b2EXeFsPqBgihWQgxwQ/0h2R8zz1hdRS64E3lgkXNJZdl4RYDmRrjHTdb3gcBdw7iXbq8lDV9pxhLDMgVNo9RzUchsGCG1EP/+W6ocZsElZcGcZSDGrbD+jjmqUNKUOEwxvmSPgOvR7NhdXEh0vhjM27Ea2gqMp/YQaWPmDomlh+9W7L+dL1qpJOCUvoozDPeJ75POwMZ2sqZzxA7Rl11Fg7pOpUcRWrVpSil19xw8O1w41zsEaQqhlynMAkmAEhf7X5sG9mrd8d8g9rnfpeGSq8ZX1i4l1NBdjKtEf7c5LTl7cXlszL24KxoB3efxZ7XQLSFNcmnZAQjI8x9y0lWLEJiF4bU3we6wcu05+axhX0D74j65oKzQIxQJtin4KdK1cdX1oHYJUgct4Evwj4DWvT4xM8+gigKdiwMyBvbPWNLtdSOkeK3hr+r7IAjLo+8k2RhlrIftAlnpuS0lFFzBLEHO+BkYJ3TPpIj658cfKww==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(451199024)(64100799003)(82310400011)(1800799012)(186009)(40470700004)(36840700001)(46966006)(40480700001)(26005)(7696005)(1076003)(6666004)(2616005)(478600001)(82740400003)(36860700001)(81166007)(356005)(36756003)(7416002)(41300700001)(2906002)(110136005)(70586007)(336012)(5660300002)(47076005)(16526019)(83380400001)(4744005)(426003)(40460700003)(70206006)(316002)(54906003)(8936002)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:02:12.0282
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c578c474-ade1-4079-bf5e-08dbf0123cae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB7782

When SecureTSC is enabled and TscInvariant (bit 8) in CPUID_8000_0007_edx
is set, kernel complains with the below firmware bug:

[Firmware Bug]: TSC doesn't count with P0 frequency!

Secure TSC need not run at P0 frequency, the TSC frequency is set by the
VMM as part of the SNP_LAUNCH_START command. Avoid the check when Secure
TSC is enabled

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/cpu/amd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index a7eab05e5f29..4826a7393e5b 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -551,7 +551,8 @@ static void early_init_amd_mc(struct cpuinfo_x86 *c)
 
 static void bsp_init_amd(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC)) {
+	if (cpu_has(c, X86_FEATURE_CONSTANT_TSC) &&
+	    !cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC)) {
 
 		if (c->x86 > 0x10 ||
 		    (c->x86 == 0x10 && c->x86_model >= 0x2)) {
-- 
2.34.1


