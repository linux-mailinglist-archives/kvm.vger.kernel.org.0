Return-Path: <kvm+bounces-4950-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C634681A226
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:22:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3B7CF1F24ECA
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFC14B5B7;
	Wed, 20 Dec 2023 15:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="eMeym2Kg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333304B15F;
	Wed, 20 Dec 2023 15:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a4jnmlpDgFTWPODPq6UTIe1iFwnS9ijeU35vOpFw5kOpl6iS7nydnFmq/w3damV4cE930LTUqXCWTLiji8RRp4BvMcn9+CmVJdtHWyWmGiXJVAvv5UXjjR/P0+MfGzbtVNhHRAYsMNWC4wAiXbyEESmspgTHonM21x4qNs9wQUJ0/zxCzi4Xz2Th391rr/LNNyejuCDMvZfCvM6PfGtWqRH8x/ZDaSF6sleohz6wTXkrAu6+ZlNLjOb+5Ocl9+zj7sXkfPjmJCjd/UjQEnEr9/8qlAp6CLbpNMsHFo4WVOVIlRm63kQiBpCV9u3WxS2ikR/aLVECjIJ8s5z9Z1L9Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5BAl/XLM/rlMjMN/4SdcK9ZDmFihMXk+ofAfsG81DVQ=;
 b=RZMhOOFd+6D6AlHtDtrk5C8WxilK4O4ElsAIgQlbGM5Hk2QhhOeX4zec++j2xiv6Yt2gceQEVMWeUVaetlM5vg+kXCV7FLm9bprMHZEcUaHB2+fzJ2OYDw9SvEYpklKp30d5Vs2yvAe8q79M61dTq7QlCG7In4mDPdBPDQL7RAFrfLzYR7wkAurOCAT/cK930igsERGPmgVHX0NrKWl0+uXIH3o2k7OnK0608ACgGSx4VHbg1vhhpT4TP6PNOpKSK6Qr6/yc1lzN22Sq/ugUeZWNcIYgyPKGKiAuH+tdoaV29RPz008MQWxo9HbjtO/OkV2L5xTK4siPlgaCIwgRyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5BAl/XLM/rlMjMN/4SdcK9ZDmFihMXk+ofAfsG81DVQ=;
 b=eMeym2KgX6hCPZxk8r2h8puNgDsCnb9VYHMDaMlELt7O/JWFzcvoLzrOckDBEn09T9Dhj3jBn0NdBlB/8nOWcIjIV3ejvcH6jO924nm+ciSF1vouSU7csDkx/7N+8Utv21JYlY/KME/Pm9eyA600xrMRVHIVBhgobe/HdQfbUQE=
Received: from DM6PR01CA0018.prod.exchangelabs.com (2603:10b6:5:296::23) by
 DM4PR12MB5248.namprd12.prod.outlook.com (2603:10b6:5:39c::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7091.38; Wed, 20 Dec 2023 15:16:18 +0000
Received: from DS2PEPF0000343E.namprd02.prod.outlook.com
 (2603:10b6:5:296:cafe::34) by DM6PR01CA0018.outlook.office365.com
 (2603:10b6:5:296::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.39 via Frontend
 Transport; Wed, 20 Dec 2023 15:16:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343E.mail.protection.outlook.com (10.167.18.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:16:18 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:16:05 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 15/16] x86/cpu/amd: Do not print FW_BUG for Secure TSC
Date: Wed, 20 Dec 2023 20:43:57 +0530
Message-ID: <20231220151358.2147066-16-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343E:EE_|DM4PR12MB5248:EE_
X-MS-Office365-Filtering-Correlation-Id: 48473493-789b-4b82-8cb1-08dc016e9da2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	K/kPcVlK230PTTlpFR4HnIFZW4lxd6ckRKOXP1IpBOA6YNUw82McmuiXE9/tj8RPXDJt858BZLyy/KdI2IrRB3nVQBuIL6tdSBbL6nWnx8gjLHeU16H1ZJ18k4PKhfpt+3UC4iFWu3SrYB91HL0qJ4zp2YpLkacRs9tyNBmIYl0VMAdN7S64aL1xL2dsQM71YIQJKLKbIMoOoSQP6PRCsLH3H33FDlMVrqos7MPrgZC+X4PWPiQySaS9UXpkbOOBpsk38fTGvDeAcG986i7FfuLqFDz7FI7+5+TZa3gCEhFaFZ0m3H1hOFQaKW+Q5r+ZwXTEe+NHEnKzA+aP4TA8KwnQmauMMbZtYolxJ1sYG5PvhCnkWZBjhw/OSv5EbGFalnn8QrKKKuyQZBofzZBStqcSr1AatjPttpXrhVX+Fmr+eFXvwtJxAETaiY0nwNFaY05y4XJVgVAFybLM+UK6ECU0CiOq7v03A3cXtqiKIko0jur6GxDv2iPYN09ZcZeiIHmF9YOyMzzV+mi5WvUWYLAvqudbK9kaNoPANx3DiXxIgqacJTfB8DCwsTZMqfMRDIlvJMhoDDTcYh4DP0mrlVsqE54EgNpFOKh9yj3QU3Ijl/Z7KvyNdXa1iNDmmnJ0zfTxPxTb5f76NC2uxAuFPUoRwBpoZTT8oQSXUO6nVIwGaFiABXdZhwAi2Izu1WbaWt7e8eO8BeL5rMKZMCF6036c5rejXWFuU02K8BpgbccUxrr8pzRK6HuGt5b7JGgFnHxGJifZjA7V3Dt6s3A2vA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(376002)(396003)(136003)(230922051799003)(82310400011)(64100799003)(186009)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(82740400003)(40480700001)(36756003)(356005)(81166007)(40460700003)(7696005)(478600001)(70586007)(6666004)(54906003)(70206006)(26005)(2616005)(16526019)(47076005)(426003)(83380400001)(336012)(1076003)(110136005)(41300700001)(2906002)(7416002)(5660300002)(36860700001)(316002)(8936002)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:16:18.1223
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 48473493-789b-4b82-8cb1-08dc016e9da2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5248

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
index f322ebd053a9..b4a19e3fda8d 100644
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


