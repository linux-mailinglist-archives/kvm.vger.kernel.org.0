Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A35562D263
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 05:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234528AbiKQEpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Nov 2022 23:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234000AbiKQEpG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Nov 2022 23:45:06 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2087.outbound.protection.outlook.com [40.107.94.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6304B48747;
        Wed, 16 Nov 2022 20:45:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bvW68UGrHYezazw/HrY3/jbBbIvmayNypy5BeK+Y9YeoAtKiLeEVPsQE/Ae/3tGFRPkJwdn/DwqqzEiY9FaQJgpRQEpE9j2aWqWxuWnxv3qwXx8jMTPwrdEqU4ymysu1RhBWdf+vK1j0A+gEtg88kKFwLcezTpLQ1j/oFcpplzDJQCOBLbkNn83/wiDPxaJ3W08en7jpRbFOz5jOo9/LzdMUNzlyba/STEYfi/8hI35cOuLyoDYgejpKyfqx0JIxD2IkwH9yP/u5bPa0z4f8s7qWiiOZPzwQ8UjMW7hJzAagdDz4ZU4nLd0WXtjk+fuN1ucwJTvr35Kok0DCO+04hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SlrRFHQCFrZ21kW3wSZHbnli+sSJ10JduFtslfmePq0=;
 b=F5pzAcrJ4jaerAPSmHg06zY45isOufPbnj0ynJ0hTCruKegtX879T/RQNUReTJ+KF3E8BJ60r59S2+mWoAzGqU2LjP+aqA067B5QqbtROYw/h438Sbk5N89/fl88yEyAmrOX3pHxpjqKppWSzEH3mxHwIacF+ojTMqVOBkvPWWGhBXVQGMrTxKsJ1WTOqecuq9QAn7Y4MHl8WPjnbPUZMC+bJ6ibxbXQX2UJyHZpJLh2sHGYwt+fqapgEt6NYfvj0ItO6+e+IfFjk8lG0fPo2pBUjk9sinKtZZG3sqYIBK9rKZ3KoD3DAcemMta8NPzUz/Bbe20yAtJNrLEta01ukA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SlrRFHQCFrZ21kW3wSZHbnli+sSJ10JduFtslfmePq0=;
 b=PTvcxJDdufjREdavHkpBI6VyMNxUZUcdSIk4MkoMbG2j8PQCsI3zPUmEJ8nv4oRkA9AlZZ0pOgvZrGN5TRgDjIZxWQjCV1fWNKsO7sqP2GJSXHUgYrDnKK6kz9BEQF2LtKuR99NPeo+sT167+HYmcx9MKDOFgUbgm9O7JexXNOE=
Received: from MW4PR04CA0245.namprd04.prod.outlook.com (2603:10b6:303:88::10)
 by IA1PR12MB6329.namprd12.prod.outlook.com (2603:10b6:208:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Thu, 17 Nov
 2022 04:44:58 +0000
Received: from CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::91) by MW4PR04CA0245.outlook.office365.com
 (2603:10b6:303:88::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20 via Frontend
 Transport; Thu, 17 Nov 2022 04:44:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT078.mail.protection.outlook.com (10.13.175.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Thu, 17 Nov 2022 04:44:57 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 16 Nov
 2022 22:44:53 -0600
From:   Nikunj A Dadhania <nikunj@amd.com>
To:     <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>
CC:     <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
        <dave.hansen@linux.intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <thomas.lendacky@amd.com>, <nikunj@amd.com>,
        <michael.roth@amd.com>, <stable@kernel.org>
Subject: [PATCH] x86/sev: Add SEV-SNP guest feature negotiation support
Date:   Thu, 17 Nov 2022 10:14:33 +0530
Message-ID: <20221117044433.244656-1-nikunj@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT078:EE_|IA1PR12MB6329:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c1838f3-616b-4f28-01a4-08dac8567aaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: clgGznXRavXskn0+EQWLSkCs2LAFHCgoVmNLzNfnPFyMqc6ye5B4U72x7pBGF4YLHdpKL7vPMaZ/TIDyRaBpmACJ0VxKZvywmC6Y1vCRIhcTrXCE2EvX3YR/OfR90EgJlH5w5AmjpnXzaYnq9Wcvm/40/4PhsIyH6BQPC9JkelAqtXrgtuAvt0AaZMAYrU/WjY8XY6dpNtE7opZPdZGDxNVqfbcUKjF95pJAFuOz6tTzB1dwPKZ0SA0gY3J35U1LWe8o3SVOljvbZ9bGW95UY/n2a01hLIWpkcfMjOGCdtzsI0eKfQLrnpmKEy9I8Oc2DHDCGQFKNFXuKTxFYwziU02w1GDnFVSsVWLyHGOEk39XyZQRHmYNqCJTwRh6ywn2F0EsdCpTPljXOcgO1n7gAjrvVnN7GKY3r8BG+lvHiZ+SY/jfuoWiCwVOZEFN+PZ8im1TwjGv5ajSMD9/RJa07twezZMV6+ye9nCmUpj0zCD2fjNiMhdzdbYX/ZeR7IK6u+JxDHLySC86k6Gr1te0m35RAeZQKrxVyFj/lwDwtZCvRdgCx99CLbm/Gh09k0hwM15Yy+O4Eafn0lhlBcq8f71Bn+fk0Q2lNfd0YwUnUh9S0Vc2Pd75UB8vcNfd5eQcJ/pveCV7HgDkUsahSLfQJJnpHme16AZSB05kkW+x9LFvMrQhqoBrEQ7mEZsmoTfVRqhpDKakK6LsLWxeo59Gxshg7uLLW5WlTXTNo0g72vSofMzzRT9vzQg/Oy1IU89HrD96i6tVTPrPJ3rJOnQ66g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(41300700001)(7416002)(4326008)(36756003)(16526019)(2616005)(1076003)(8676002)(8936002)(316002)(5660300002)(70586007)(336012)(26005)(70206006)(186003)(82740400003)(36860700001)(40460700003)(40480700001)(83380400001)(47076005)(82310400005)(426003)(2906002)(81166007)(356005)(6666004)(966005)(478600001)(110136005)(54906003)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 04:44:57.5488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c1838f3-616b-4f28-01a4-08dac8567aaa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6329
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

SEV_STATUS indicates features that hypervisor has enabled. Guest
kernel may not support all the features that the hypervisor has
enabled. If the hypervisor has enabled an unsupported feature,
notify the hypervisor and terminate the boot.

More details in AMD64 APM[1] Vol 2: 15.34.10 SEV_STATUS MSR

[1] https://www.amd.com/system/files/TechDocs/40332_4.05.pdf

Fixes: cbd3d4f7c4e5 ("x86/sev: Check SEV-SNP features support")
CC: Michael Roth <michael.roth@amd.com>
CC: Tom Lendacky <thomas.lendacky@amd.com>
CC: <stable@kernel.org>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/boot/compressed/sev.c   | 18 +++++++++++++
 arch/x86/include/asm/msr-index.h | 46 +++++++++++++++++++++++++++++---
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/arch/x86/boot/compressed/sev.c b/arch/x86/boot/compressed/sev.c
index c93930d5ccbd..847d26e761a6 100644
--- a/arch/x86/boot/compressed/sev.c
+++ b/arch/x86/boot/compressed/sev.c
@@ -270,6 +270,17 @@ static void enforce_vmpl0(void)
 		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_NOT_VMPL0);
 }
 
+static bool snp_guest_feature_supported(void)
+{
+	u64 guest_support = SNP_GUEST_SUPPORT_REQUIRED & ~SNP_GUEST_SUPPORT_AVAILABLE;
+
+	/*
+	 * Return true when SEV features that hypervisor has enabled are
+	 * also supported by SNP guest kernel
+	 */
+	return !(sev_status & guest_support);
+}
+
 void sev_enable(struct boot_params *bp)
 {
 	unsigned int eax, ebx, ecx, edx;
@@ -335,6 +346,13 @@ void sev_enable(struct boot_params *bp)
 		if (!(get_hv_features() & GHCB_HV_FT_SNP))
 			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
 
+		/*
+		 * Terminate the boot if hypervisor has enabled a feature
+		 * unsupported by the guest.
+		 */
+		if (!snp_guest_feature_supported())
+			sev_es_terminate(SEV_TERM_SET_GEN, GHCB_SNP_UNSUPPORTED);
+
 		enforce_vmpl0();
 	}
 
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 4a2af82553e4..d33691b4cb24 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -567,9 +567,49 @@
 #define MSR_AMD64_SEV_ENABLED_BIT	0
 #define MSR_AMD64_SEV_ES_ENABLED_BIT	1
 #define MSR_AMD64_SEV_SNP_ENABLED_BIT	2
-#define MSR_AMD64_SEV_ENABLED		BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
-#define MSR_AMD64_SEV_ES_ENABLED	BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
-#define MSR_AMD64_SEV_SNP_ENABLED	BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_SEV_ENABLED				BIT_ULL(MSR_AMD64_SEV_ENABLED_BIT)
+#define MSR_AMD64_SEV_ES_ENABLED			BIT_ULL(MSR_AMD64_SEV_ES_ENABLED_BIT)
+#define MSR_AMD64_SEV_SNP_ENABLED			BIT_ULL(MSR_AMD64_SEV_SNP_ENABLED_BIT)
+#define MSR_AMD64_SNP_VTOM_ENABLED			BIT_ULL(3)
+#define MSR_AMD64_SNP_REFLECT_VC_ENABLED		BIT_ULL(4)
+#define MSR_AMD64_SNP_RESTRICTED_INJ_ENABLED		BIT_ULL(5)
+#define MSR_AMD64_SNP_ALT_INJ_ENABLED			BIT_ULL(6)
+#define MSR_AMD64_SNP_DEBUG_SWAP_ENABLED		BIT_ULL(7)
+#define MSR_AMD64_SNP_PREVENT_HOST_IBS_ENABLED		BIT_ULL(8)
+#define MSR_AMD64_SNP_BTB_ISOLATION_ENABLED		BIT_ULL(9)
+#define MSR_AMD64_SNP_VMPL_SSS_ENABLED			BIT_ULL(10)
+#define MSR_AMD64_SNP_SECURE_TSC_ENABLED		BIT_ULL(11)
+#define MSR_AMD64_SNP_VMGEXIT_PARAM_ENABLED		BIT_ULL(12)
+#define MSR_AMD64_SNP_IBS_VIRT_ENABLED			BIT_ULL(14)
+#define MSR_AMD64_SNP_VMSA_REG_PROTECTION_ENABLED	BIT_ULL(16)
+#define MSR_AMD64_SNP_SMT_PROTECTION_ENABLED		BIT_ULL(17)
+/* Prevent hypervisor to enable undefined feature bits */
+#define MSR_AMD64_SNP_BIT13_RESERVED			BIT_ULL(13)
+#define MSR_AMD64_SNP_BIT15_RESERVED			BIT_ULL(15)
+#define MSR_AMD64_SNP_MASK_RESERVED			GENMASK_ULL(63, 18)
+
+/*
+ * Features that needs enlightened guest and cannot be supported with
+ * unmodified SNP guest kernel. This is subset of SEV_FEATURES.
+ */
+#define SNP_GUEST_SUPPORT_REQUIRED (MSR_AMD64_SNP_VTOM_ENABLED |		\
+				    MSR_AMD64_SNP_REFLECT_VC_ENABLED |		\
+				    MSR_AMD64_SNP_RESTRICTED_INJ_ENABLED |	\
+				    MSR_AMD64_SNP_ALT_INJ_ENABLED |		\
+				    MSR_AMD64_SNP_VMPL_SSS_ENABLED |		\
+				    MSR_AMD64_SNP_SECURE_TSC_ENABLED |		\
+				    MSR_AMD64_SNP_VMGEXIT_PARAM_ENABLED |	\
+				    MSR_AMD64_SNP_BIT13_RESERVED_ENABLED |	\
+				    MSR_AMD64_SNP_VMSA_REG_PROTECTION_ENABLED | \
+				    MSR_AMD64_SNP_BIT15_RESERVED_ENABLED |	\
+				    MSR_AMD64_SNP_MASK_RESERVED_ENABLED)
+/*
+ * Subset of SNP_GUEST_SUPPORT_REQUIRED, advertising the features that are
+ * supported in this enlightened guest kernel. As and when new features are
+ * added in the guest kernel, corresponding bit for this feature needs to be
+ * added as part of SNP_GUEST_SUPPORT_AVAILABLE.
+ */
+#define SNP_GUEST_SUPPORT_AVAILABLE (0)
 
 #define MSR_AMD64_VIRT_SPEC_CTRL	0xc001011f
 
-- 
2.32.0

