Return-Path: <kvm+bounces-8760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D335D8561BC
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:36:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03A041C2218F
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:36:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC4213173B;
	Thu, 15 Feb 2024 11:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="SkpZ3dOJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C2C12BF02;
	Thu, 15 Feb 2024 11:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996774; cv=fail; b=nwdZohJ8Gj5mI8yTcVkPiYlydi4oCTl6oRw3cee8Rn8QOn3ila/9hDvjBeuKwkQYgcnHwe4kWrhHvrvJttPX+lDJWZh/Mws8pahWVKbeSx4qJrgBwTkUSvI7ZKJjvvB02oFadosKUR1WTr3QoAx4q3WkCbUerq8zdYT7WCA+bD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996774; c=relaxed/simple;
	bh=uGgZAo0i/Hn8m7N+pwioGOWd6EDffGbLTj4lf6gEpQc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DMcNFc7t5bmlVhkDHPSSd7/HFwYCSdfhoWdy0pIsnf5wD2axouNZ2YiryTeGaVWoWgu7Ph6bVTcT21U72ShjkEU8hQC4PIshroFAJSxSwWHh79P4I8qc6jtzvHBhuykxQyZ3KekWfmP4xzBuWFbwwvt9Ntnhlx2+LDhOFUCgrXo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=SkpZ3dOJ; arc=fail smtp.client-ip=40.107.223.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b73AkIt6YQYr+w4YBZQw7cIlluzc7lW5sf+kqxhxqoXkbklHrxT6h/NLUz5KDGtodzsFYNftcYNaXZ6elZLRPH0JHmd0Vf1brb+SpLrrARvmLkaG3x4oh3HnF42arhlFZVEGL1084o217B3mY/1/nMZx853QNt6pG9OZDGBE+GJaiLQCoG9vzt1cFIkP0FCkK05HnUeHTiGGTbYvre4qJ3JYE2N0LiJkEkuJu+uY2XGoRf77TtFiuedx1nqZLFvsQ5kCRUsr3CItYs6HCkoBVvGYuk0/mLsI3BVY3LmrDn9tl0L0zR6l92LLVQWKJYvRzxEddisF9lxF0tadFZklNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+6Azz9JKP+iWwyMpqCx1n9PztIoAiGoKnWnk6LRpHj0=;
 b=LzqosGu8caCtzPEqL3qex2DpXKgEatNYabqImb7JZjmAE7HbZrLCsmXiszQAmUGjFEJO7jT2yHVClZlgqUv6vCej21NRe6brKGDb0zXtoyKEpS1pWL+tk3rig5XWlgwUWG1vuVR1QWl9ysTNz5NrVSJZdgYxGf8Rp/gSGP67RkIIBIb7UMD7Q0Zx1dQU07PtXk3+y1ZlEetpzwhTRLvGKkDU2ufk8p16E2mPgE+EvsCwGiyT3xxmYXkXhr1d4eg/mCMD+Jx9WJzDMaR/d2S3Wh3atuH7+IM2SIewEkY0eXLKl5WyhX36UsUVpJhZ4XQyFJIshQBs1CvuVlM3jVESRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+6Azz9JKP+iWwyMpqCx1n9PztIoAiGoKnWnk6LRpHj0=;
 b=SkpZ3dOJAL1Fwvz5Pkzw3BVa6dREfyiGMGC6uWeEt6AmUoYgeyx/GLtc7YT4WVFoadrQtFNvZXqhSuD1v4XlL96mXmDZ+BH4qQHu8/dOYDFbnzsG0TFsJn6VAs7szn6RDDL+6ZiSJ2HucAJIAcqJXMZB+3+I51FqewsBm8+nAUw=
Received: from SA9PR13CA0129.namprd13.prod.outlook.com (2603:10b6:806:27::14)
 by BL1PR12MB5112.namprd12.prod.outlook.com (2603:10b6:208:316::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.14; Thu, 15 Feb
 2024 11:32:50 +0000
Received: from SN1PEPF0002BA50.namprd03.prod.outlook.com
 (2603:10b6:806:27:cafe::a1) by SA9PR13CA0129.outlook.office365.com
 (2603:10b6:806:27::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.29 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002BA50.mail.protection.outlook.com (10.167.242.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:49 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:45 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 14/16] x86/sev: Mark Secure TSC as reliable
Date: Thu, 15 Feb 2024 17:01:26 +0530
Message-ID: <20240215113128.275608-15-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002BA50:EE_|BL1PR12MB5112:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fed4423-593b-4db1-8f95-08dc2e19d6f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+Ynpfy8a4opFPEVOMbIHZEQQVutNxzcxkQZd2D+akFsETvIC23M59QAc7QVCSUM4Odi93FxI2nN0fGPJ2qBhSODFAcy7ZBY1H6ZHNWLuu8A7Is2ILBcyWBVc/LO2G43lXKVEIdVE3KP6Y/Jizkn5P6KcnmOweS9Xoo2yM8+NRRP+VbyBMGfv+WlWCDbR6ZDsUjsayI7VY3SQzKJJiUzdW8BG0OSB53iJ2qx8HPwdPHUEDR9HONK6EsSEUCGkWLN22+I+KD5fEk8Z/rfaYKpEuSRPwY/VbkEjzRLIXElpdJuTdp5HIEcCiUkHpAqVt2RauUfmUqiNO1mJgJ49V7Cx8zSejM4XcNtyDZ/Y8hJQ15m1sVCW/L8N+YGeaymubhNKI4FpK9zq7GhjTywUlTcOsIKmMODeZTKYqn1xiSECPVg8AdqY8W/WAOYZcCW4RByHbHESuU81hgTWWgLe+OTYcXp8oX8byClqHongIY97bYu0BWhb7JEoa3oGK+WP491FjXRTLNWhhu1HoHo1uZoiFKaMix77TZ9EAGxcMYw0k3magS+SKwE6D7gKYemV5Co2JnnBwLPr/9SyOpQohddvKKFnV60C3A4fbtPEXSjc1r9ej0o5Lc2b/OPpJDlXZNKfOngRq5y8XPIBkbtMiHiBy1SuJFtB5s6SHwzCIx2vu4E=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(1800799012)(451199024)(186009)(64100799003)(82310400011)(36860700004)(40470700004)(46966006)(4744005)(7416002)(5660300002)(8936002)(4326008)(8676002)(70206006)(70586007)(2906002)(26005)(83380400001)(16526019)(426003)(336012)(81166007)(356005)(82740400003)(36756003)(1076003)(110136005)(54906003)(6666004)(316002)(2616005)(41300700001)(7696005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:49.4358
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fed4423-593b-4db1-8f95-08dc2e19d6f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002BA50.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5112

AMD SNP guests may have Secure TSC feature enabled. Use the Secure TSC
as the only reliable clock source in SEV-SNP guests when enabled,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index c81b57ca03b6..cc936999efc8 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -498,6 +498,10 @@ void __init sme_early_init(void)
 	 */
 	if (sev_status & MSR_AMD64_SEV_ENABLED)
 		ia32_disable();
+
+	/* Mark the TSC as reliable when Secure TSC is enabled */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


