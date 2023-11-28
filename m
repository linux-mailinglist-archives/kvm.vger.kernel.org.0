Return-Path: <kvm+bounces-2613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE6A7FBACF
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:02:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68BE9282243
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FBE056453;
	Tue, 28 Nov 2023 13:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ai7lU6VV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2083.outbound.protection.outlook.com [40.107.220.83])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39B310DA;
	Tue, 28 Nov 2023 05:02:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mm0GuEqhhM30VjdsDQVv8xGhXXwQRNYYegRhXKgyG1Wq31k2hEzOzaWEe+x030abWg3bMTQ0YfPHmn87I2sJQ24NluDBdDpvYosV1H9Yt8dFElMLK/Jazp4r8IiUR5S9WOQY9qozABsI+itP2voKsEgHBEmy13tPFwWF013eSaInmb8O4uyNZkU5W3GQsaJ+ljRiq3dmxB9FQijmvAkKy44ELMcBWEYp/4hz+SpeZSDvfV5TnzC/xmMZgVmVHlMV4Tt5qlEymDpuhnwZi778c6X7kWxquHlZImCfLpP2hBoI3v74jcRJfuuj6jPYA5gZ3FRGgs/zNRZFrL0gGUubOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QxeVatY8WznpWN62o//l0lnJmSIYHr4RcSYlfgHgEv0=;
 b=m1zQNfqf1XbYQohE2kA8owbJgO8i6pBFeP3SJPM57UH/wZPCGzzRpjpIXCnWIM3CWJGRfR/so/fzyt2WFH4GQx36jdh8jBjs2vJMJQn9E7JBSNYroUFJ3zFvplBQbeF/P5lyIL3GuknDDJPq2NHVdTVSoOCOlOYRZwnrEibKxnZLTmpjr/+5JcuQ+B2HqhhiACHlZ2UBeuzg3KL9bHj4P00m4Tevmtcs1aHyrYsxB0++UVteC5gQPpXSSnbB9lyiuq5jO0THYQXTpVitI6SnVXhFIEU4dZMyaxOtkyXzW1NLP4RmnkGbPd/4Sl8zmVhtb5xyd4zC6Yvm/9LB9atoFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QxeVatY8WznpWN62o//l0lnJmSIYHr4RcSYlfgHgEv0=;
 b=Ai7lU6VV5go1HSXRctl1CypXAleEqLZmC9RU/K04TTT30PbpuYWkQdw2BkxGS8DrKeMw6+nRJEiq8SnbqU4APVZK8Zp9CSpwfbYRBbk4Ou+1PJsL9N/RDvp8mv7h25KeQ+5UphOhFCB6H2EzacbzkBvz6Hgsbx4EU/yBPAi4ERc=
Received: from CH2PR02CA0007.namprd02.prod.outlook.com (2603:10b6:610:4e::17)
 by MW4PR12MB6754.namprd12.prod.outlook.com (2603:10b6:303:1eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 13:02:16 +0000
Received: from CY4PEPF0000EE36.namprd05.prod.outlook.com
 (2603:10b6:610:4e:cafe::1a) by CH2PR02CA0007.outlook.office365.com
 (2603:10b6:610:4e::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27 via Frontend
 Transport; Tue, 28 Nov 2023 13:02:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE36.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:02:15 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:02:11 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 16/16] x86/sev: Enable Secure TSC for SNP guests
Date: Tue, 28 Nov 2023 18:29:59 +0530
Message-ID: <20231128125959.1810039-17-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE36:EE_|MW4PR12MB6754:EE_
X-MS-Office365-Filtering-Correlation-Id: d4a273b7-b24b-4808-f412-08dbf0123efd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BHcTw1Xtjl9JhdEFqLEto59WqiAwBRXrM8C3edMj3FmyfTM0djRK1bKOhBcUTPOzLFwKQqJGjA+Pgx7qJvIAbJuYLHLFw6EHqFLNOMQHxX1NRdmb0fzn0f9hbXIIn61v3n0kIZyBu+40b7hRrrSvMDOslQdYjnP9jUhOTy51MQ5ovdEzQ9M4UdzVsuMUmQIdyOUAl0H3n4HmnwtouJ5a3TgWglfaPvefsyI4u+ny1Yd9Q/L1UzdWBJIcssbn0vjFFXtKN1eOGnOTTg9uQeBIQPlHBUJC2/9g50vXtoYW9/uI4nSFeomLV81HRKsRwfWFzOgzHne4iz79BjztZ6DNxCWlE/2BWoUJQGzjKM+DhO5zunapb3uzYegmVZRvRExqf6PEcL7LAwl1M/pBLolNba3j0/WEPCVaPS7L29xLRd6bDBJqP690IZ2IwBSoa8mGCV9V92KNGVJY3rvD9QHFotqpfjIKCZ23UApVNsj4hBpXWUZ4DBBfzrlJGbSBtyuIMBEGmW+VnsJxOir5OC+b3yJ74aZU95mPErm6atSyMnnmbNezVPEHCOds2ce4LrrVDrc4FlIbotEclGhBdRbpODUNK3OJUFmtAo2AL1i8pHXM8utLCo8oGQR7+D8iMYzraSZ0MYTQ0CHm/BSjY0JYCi+e4kBZFT/2JmfCZphq2dfkd1lg5LfFSsfUJi2V235bu5E2zljrNWChUExD0jAAUVNuFznqdKq4vgsF6+rYQq7ROLJxbXtrC/reSBJbx5gXhO0AgorumsV24SjUBhagIw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(39860400002)(396003)(230922051799003)(451199024)(64100799003)(186009)(1800799012)(82310400011)(40470700004)(46966006)(36840700001)(6666004)(8936002)(8676002)(4326008)(7696005)(54906003)(110136005)(70586007)(70206006)(316002)(478600001)(40460700003)(36860700001)(81166007)(356005)(47076005)(41300700001)(1076003)(36756003)(26005)(16526019)(2906002)(2616005)(40480700001)(83380400001)(336012)(426003)(7416002)(82740400003)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:02:15.8871
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a273b7-b24b-4808-f412-08dbf0123efd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE36.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6754

Now that all the required plumbing is done for enabling SNP Secure TSC
feature, add Secure TSC to snp features present list.

Set the CPUID feature bit (X86_FEATURE_SNP_SECURE_TSC) when SNP guest is
started with Secure TSC.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/boot/compressed/sev.c |  3 ++-
 arch/x86/mm/mem_encrypt.c      | 10 ++++++++--
 arch/x86/mm/mem_encrypt_amd.c  |  4 +++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index 454acd7a2daf..2829908602e5 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -375,7 +375,8 @@ static void enforce_vmpl0(void)
  * by the guest kernel. As and when a new feature is implemented in the
  * guest kernel, a corresponding bit should be added to the mask.
  */
-#define SNP_FEATURES_PRESENT	MSR_AMD64_SNP_DEBUG_SWAP
+#define SNP_FEATURES_PRESENT	(MSR_AMD64_SNP_DEBUG_SWAP |	\
+				 MSR_AMD64_SNP_SECURE_TSC)
 
 u64 snp_get_unsupported_features(u64 status)
 {
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index d5bcd63211de..b0db76dc4a9d 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -70,8 +70,14 @@ static void print_mem_encrypt_feature_info(void)
 		pr_cont(" SEV-ES");
 
 	/* Secure Nested Paging */
-	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
-		pr_cont(" SEV-SNP");
+	if (cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
+		pr_cont(" SEV-SNP\n");
+		pr_cont("SNP Features active: ");
+
+		/* SNP Secure TSC */
+		if (cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
+			pr_cont(" SECURE-TSC");
+	}
 
 	pr_cont("\n");
 }
diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 8614c3028adb..2d1ab688c866 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -488,8 +488,10 @@ void __init sme_early_init(void)
 	if (sev_status & MSR_AMD64_SEV_ES_ENABLED)
 		x86_cpuinit.parallel_bringup = false;
 
-	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC) {
+		setup_force_cpu_cap(X86_FEATURE_SNP_SECURE_TSC);
 		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
+	}
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


