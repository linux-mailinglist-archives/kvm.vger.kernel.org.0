Return-Path: <kvm+bounces-8762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FBBF8561EF
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:44:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3AA6DB29CBA
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C11131E42;
	Thu, 15 Feb 2024 11:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a0ep//mH"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9E4131E2D;
	Thu, 15 Feb 2024 11:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996781; cv=fail; b=Nt47btmP42nBprgNrtdrb0HnHxr5FYo2b8vEkjszEhiTyZruUkALZqLGTuXaHNxWs51/DXiU+qauMMyu09iC7GGow21y7MgbaKJuhtTG32/UXpG/e3Gm1mCbD/sYzW6vrrOs+5KA6Mr48HtCg7lEBPddac3Ij698r97tvQuT4KQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996781; c=relaxed/simple;
	bh=Z+J45amBNDKTWsvLll8fDWyRtLwPalX5W8keus48IK4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CY0W/WM4eDCHahzXBFJtjRohsijQKB1c25cphalEmUrq43P+tK+MM0wVuRzY1BJyp6uW/6ioNOpG61P+B883pOeHalntw4wIz8pb5MwuUN+nPJP+KS/ywPfzftMQg3yUMhFTSKqX8/wXvKaRJyUgZPZPAeNytWT0sMNU0pjmpVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a0ep//mH; arc=fail smtp.client-ip=40.107.243.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gMi+esLQAgjblL/n6JNpC55Vaqg76iXttJPJ1le1Cq3wNYRcj1uTQNy43gkPDrI6XNAJkzejSAbTAuHVLOjEy5f1QzOGrScW5HRskgI607e7mc1ukdT05pr7d8mSrU7X6JbohRWjhLM+r6RB3D1OwdTFW5raoL1cYN4L161RihINIVeN3UC1txroOIAVrF9H0SL3nZtlA/nPUifFReJn2khWXEXznHsKHEoabqbQ+fG/pQC55Nl7arIwgazL5jg4Oy/6G3Ygde8HQPB/c0WPBWhFueaXlmLv/X4SXNhbc2rJJBBOkp1v6AfcUC032xl5cmQFW5Db4zxQe92ta2EkSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5VWwGIqHnngs1QoNx8JMfi5AErKWM9Q23Vl8/MRxZGw=;
 b=MeefV723c8jhDyZ+Co8dCtDpUviu8Pp2reDymAZLc2SGlqOYyxRdU35ijWh0nmUVnOW3Vs3laaJZnic0T+2uPYIB5JjBBShUY7Zg6F+QCvwjjTmdx4Q78wAGxApvW8/ocf8/TSEuszIHtp2ouMXc6icnd9kfT2gwipqkN2fVAfTjB7gcOeohKCoAGfquFXsugbtElBDXm2fXGKyjIHUVK/729ZURMDivOqGlK0oy+i4qXZT1duVFXjb6/+nCpTBxd59aEVSq25pllHrW4/fmpPtbqCU+8ompMWIkUM5/6Kl2SRkfiRbGyl0jmMZrzxjkRRXCZzGXW5NwBo2skgAS8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5VWwGIqHnngs1QoNx8JMfi5AErKWM9Q23Vl8/MRxZGw=;
 b=a0ep//mHSRWCKkhGKOtKF4XSep9i4cKRJzy43eIeIDMej21Y/53cIQBfURDKrg7lcAr7fGycWiXDblC8hQDR6JphEc3hjWQXnHLuamsP0whqMGqdRCXUZCEaV8Lqby8H80JjVdM3yK6Bu35D5dte6FiEvDU20ZQG7iqZNJoMs64=
Received: from DM6PR05CA0053.namprd05.prod.outlook.com (2603:10b6:5:335::22)
 by DS7PR12MB8417.namprd12.prod.outlook.com (2603:10b6:8:eb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 11:32:57 +0000
Received: from SN1PEPF0002BA51.namprd03.prod.outlook.com
 (2603:10b6:5:335:cafe::74) by DM6PR05CA0053.outlook.office365.com
 (2603:10b6:5:335::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA51.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:56 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:52 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 16/16] x86/sev: Enable Secure TSC for SNP guests
Date: Thu, 15 Feb 2024 17:01:28 +0530
Message-ID: <20240215113128.275608-17-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA51:EE_|DS7PR12MB8417:EE_
X-MS-Office365-Filtering-Correlation-Id: e890a8be-b9c5-4b51-cd3b-08dc2e19db40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	TFzXdzsv6J9PnxfRWlm9wiFUAl6FRLFZX/+/0Qiy6pzKOddH7opq+VJ18HFZtD06eF5N6hXkZeL8SK73E/F3QNBX/ilr/Ty6mUSqTI6Nx433iaMAG8kUz7rTtUMjT0JIzh0V7TRn0Y22vugz8BDcvlZL7oQuqxFhZtmi0aDKC9i2QXALbk0EeAXqfIpEAAqp+BKtdy50oy4oxrYBiPAbTxAOUOIfV0s+7zCjhKSbV9dEGvpzK1ry5aayv9ZDuOZw80799L/HI+3AIh18cn44cuiwWs8W7DhPDomXN3f2FiNvJOnko1SbesVBdvELPZZ8RMY+Ikd35oWrElkuxrBQBp1VVLqx2GGmaRbAN/VceRgdS2xKguhQkpj/XQl2Uyoisl9OiiukidOvUHRvV3uMPVcK9+rfeD32m+Dxyyl5pjdtcW5SH4C/B4WYFMrGF91xN0+/i31DA4m+7+hH2yVcIO1lJI/Rs5ci++hNN9K6NwUo6mRP+GK+Xb1Rm6L1BP18W9nZ8FfW9kf1S6wqVnwTCnJ5A//eWU5vy7mjBzGZpvJhWwkPKC8yQQh9vcKAWbPjfh2tjKLVme4H2XiXt+LbBqwTRlTZilpcPIT3/yUIAtwlUuXJsZxhAIzO+rE5zSX5HA83fXGs2zW2m3XbWnnDqPMsCwQ29nx3r5yOlviQzfc=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(346002)(376002)(39860400002)(396003)(230922051799003)(451199024)(64100799003)(1800799012)(82310400011)(36860700004)(186009)(46966006)(40470700004)(478600001)(41300700001)(4326008)(8936002)(7416002)(5660300002)(8676002)(2906002)(7696005)(54906003)(6666004)(70586007)(316002)(83380400001)(2616005)(336012)(70206006)(426003)(356005)(81166007)(36756003)(1076003)(82740400003)(26005)(110136005)(16526019);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:56.6660
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e890a8be-b9c5-4b51-cd3b-08dc2e19db40
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA51.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8417

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to snp features present list.

Set the CPUID feature bit (X86_FEATURE_SNP_SECURE_TSC) when SNP guest is
started with Secure TSC.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/boot/compressed/sev.c |  3 ++-
 arch/x86/mm/mem_encrypt.c      | 10 ++++++++--
 arch/x86/mm/mem_encrypt_amd.c  |  4 +++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 073291832f44..d7e28084333a 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -379,7 +379,8 @@ static void enforce_vmpl0(void)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 68aa06852466..350ba605509d 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -70,8 +70,14 @@ static void print_mem_encrypt_feature_info(void)
 			pr_cont(" SEV-ES");
 
 		/* Secure Nested Paging */
-		if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-			pr_cont(" SEV-SNP");
+		if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
+			pr_cont(" SEV-SNP\n");
+			pr_cont("SNP Features active: ");
+
+			/* SNP Secure TSC */
+			if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+				pr_cont(" SECURE-TSC");
+		}
 
 		pr_cont("\n");
 		break;
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index cc936999efc8..7ee0a537a22e 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -500,8 +500,10 @@ void __init sme_early_init(void)
 		ia32_disable();
 
 	/* Mark the TSC as reliable when Secure TSC is enabled */
-	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC) {
+		setup_force_cpu_cap(X86_FEATURE_SNP_SECURE_TSC);
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
+	}
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


