Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF1077FDAE
	for <lists+kvm@lfdr.de>; Thu, 17 Aug 2023 20:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354272AbjHQSTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Aug 2023 14:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354238AbjHQSTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Aug 2023 14:19:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2085.outbound.protection.outlook.com [40.107.92.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02892D75;
        Thu, 17 Aug 2023 11:19:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ctjobi0E5ZW8wuB6ZPVyGnao6Yrz7QGv7tuJig/UvSsv3h6+9ItfE4RwQbQvFanhJYXBQCk6UghUUbx1yHkHqhUj3QxCCVO2OPXaelrTf2oY/TJi/jsIvjp76DOSVYHKj3ily5WHrWbnob/D+FA05L0cBkVnS/xdwDMl4FKUpRw281IyJNfY3g765oWz1jiuk36/sEEpFvB3bDl/duBQmStO/rKg+LXQ9EUBVzl/iXGdBG89Z9YG1Lo8l3ZGpx4b615s/KRyMf1X8j66Uxxte8k8d0GU5gWc8PPVBVpTR6ZMd348TipRMqrpN/UaTZIZAJSXx/JYkQZoaYGATw0RPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ac3a6gZe3/Xkxj4CGYSHjfoXS3T2cAThSFV1wbR8HnE=;
 b=apVQDZP6QwzG/gDr2GCn0TPa37MnmSt5FusfaKeIYmNprPXLp3IJst/dDsA301l27ekJLWntoSqFELKRzxrpT30hHwX3kYM5scNKmn9GT+yi3CgqUfuQbqJSiaAPhOVV7JMkInBohjWQcZsMuxUquTLgl4BBRbYve4d1/BYQiDZuw+hFguTvFP9rvnR7tRB83qjrMtW9tsozeSgo01hZDEHLVrSNGpoZELDeCaIvYcDBz75t0FYos0FKWH43J/bRygKMcvr6ABZ68HTn0h/kyxbUkUH923582YlKeAY8zS4Ft3DA/ahAXmHl1gAKdrTo/Tv/xH2HjWfx2A4KJ4xS1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ac3a6gZe3/Xkxj4CGYSHjfoXS3T2cAThSFV1wbR8HnE=;
 b=Lv+YVZsQ/xQgbKWd84CT7TFz7RQsV5uyLQETqucOFmy/91bQ2P6m/p2WxFQcrjTZH2aQLdrNgRMCAbMKOOrUvFIp1oieuYy35firkeRm+5G7HZ6XFn5kjoIx4ebuJq4lIVqGjzxKdqYD052bm5L6YE5pGK+01BYsZUDYMc2ugKw=
Received: from SA1P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:22c::29)
 by SJ2PR12MB9116.namprd12.prod.outlook.com (2603:10b6:a03:557::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6678.29; Thu, 17 Aug
 2023 18:19:18 +0000
Received: from SN1PEPF00026368.namprd02.prod.outlook.com
 (2603:10b6:806:22c:cafe::bc) by SA1P222CA0013.outlook.office365.com
 (2603:10b6:806:22c::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.33 via Frontend
 Transport; Thu, 17 Aug 2023 18:19:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00026368.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6699.14 via Frontend Transport; Thu, 17 Aug 2023 18:19:18 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Thu, 17 Aug
 2023 13:19:17 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [RFC PATCH v3 6/8] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
Date:   Thu, 17 Aug 2023 18:18:18 +0000
Message-ID: <20230817181820.15315-7-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230817181820.15315-1-john.allen@amd.com>
References: <20230817181820.15315-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00026368:EE_|SJ2PR12MB9116:EE_
X-MS-Office365-Filtering-Correlation-Id: ed093b8a-008b-4adc-820b-08db9f4e7895
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TMHPZ2aA0zpxPu2bfPvY2UgGRDCDLwPGGG03XBG3GRDvmOwBdpyzcN8acFb4ACrrkBXWDTojdywDQaTwheTtGnmQ9SIs0paZ3SU/cbXxqxa96kRXlsCXJt6hiSdT4zkzcHUu7YIsMD4mvhQEhHiIG3eWbmP/EQjWqQcMu8FysKlnyvzsh1Juzq2InXnjOxQS5z7CJngc6TmACq486mZT6YfHdoHkJDdeaUSrRO3+xlrD9DnlT+AtqYPhLJt3UlH/4i2MiGI4t4V0TNibMZuv1GT4nwmrVeQWZFzDUcsDjFkBGw19XRAswR0X3kBgvzJUUTf/oUBwFPnNO7O9eFo7+EF6wKcQeXzgbqrwamcBUaEfUN6Wpqi8JYWnfdi0tRR34pIrFPiEEc5XNbrrqO6laTycjmH42bd9d4Yeqy1kcjJdumgEopEL3DGFLlAeGugQKLTuq2tQSKGl3y3+WUz9PBuyg4pVJAvtZ1JjskbG5W1BkaqN6nXzyfhrg8+kc1DHRFdAqh4abCmwuI3REN/7kHx/GGfUu++8P+YCmeN6SEOcyOPUCP3bf2trlbCI1mj8GbT3HJhPaZwp8GGLpcQVDFr7a8ect0CIO+/sjILDLW2DKtrJEXfDiUYsHjJNQcRxZDJnqfDPVENL03aIX3ObpG4/Z0r84ntyusKa5x8RHkiun5KR+7Se+N7fU0J28sVB9ccRMtj0yQIj+w6t6pRnimduZLBsPwzg1xLT1wNCeuAvG7zQCHAom9rKGiKIPLg6nJ3aHlULcgDvHKFN/vlF3g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199024)(186009)(1800799009)(82310400011)(46966006)(40470700004)(36840700001)(316002)(54906003)(82740400003)(356005)(81166007)(70206006)(70586007)(6916009)(5660300002)(41300700001)(36860700001)(44832011)(47076005)(8676002)(8936002)(4326008)(26005)(40460700003)(2906002)(83380400001)(16526019)(478600001)(40480700001)(336012)(426003)(86362001)(36756003)(7696005)(1076003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2023 18:19:18.1605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ed093b8a-008b-4adc-820b-08db9f4e7895
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF00026368.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9116
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a guest issues a cpuid instruction for Fn0000000D_x0B
(CetUserOffset), KVM will intercept and need to access the guest
MSR_IA32_XSS value. For SEV-ES, this is encrypted and needs to be
included in the GHCB to be visible to the hypervisor.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/include/asm/svm.h |  1 +
 arch/x86/kvm/svm/sev.c     | 12 ++++++++++--
 arch/x86/kvm/svm/svm.c     |  1 +
 arch/x86/kvm/svm/svm.h     |  2 +-
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index d14536761309..890ec51eb9d6 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -678,5 +678,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
+DEFINE_GHCB_ACCESSORS(xss)
 
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 021ead4dd201..5db76675b416 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2442,8 +2442,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 
 	svm->vmcb->save.cpl = ghcb_get_cpl_if_valid(ghcb);
 
-	if (ghcb_xcr0_is_valid(ghcb)) {
-		vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+	if (ghcb_xcr0_is_valid(ghcb) || ghcb_xss_is_valid(ghcb)) {
+		if (ghcb_xcr0_is_valid(ghcb))
+			vcpu->arch.xcr0 = ghcb_get_xcr0(ghcb);
+
+		if (ghcb_xss_is_valid(ghcb))
+			vcpu->arch.ia32_xss = ghcb_get_xss(ghcb);
+
 		kvm_update_cpuid_runtime(vcpu);
 	}
 
@@ -3031,6 +3036,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
 			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
 	}
+
+	if (kvm_caps.supported_xss)
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dd67f435cd33..683bf18b965d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -147,6 +147,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
 	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
 	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
+	{ .index = MSR_IA32_XSS,                        .always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f824dde86e96..87b6831bac42 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -29,7 +29,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	53
+#define MAX_DIRECT_ACCESS_MSRS	54
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.39.1

