Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240F25FCC2F
	for <lists+kvm@lfdr.de>; Wed, 12 Oct 2022 22:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJLUkX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Oct 2022 16:40:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiJLUkQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Oct 2022 16:40:16 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B3FBBE10;
        Wed, 12 Oct 2022 13:40:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U8iRMN+3fecQpAqI9WhMa1RrgdFHPUgsO8zsc8uzHnfE9Pv2KX6fQ6+Z7zirvaZN0T5DKCBjfkvEMfiT7p9uSny/++DpXS47oy65Lz/4UMqKm8IrhUq9VPssplItF2v7yIQ3BcHM1QCkrUQSKyGc4z0u2GSyFdF7b/8kU88n7P10af+nLR6HiBidT5T0Cvj/NJddPeh4W+RlKyQ14/uavwAcOXGQHlKHiDTEfpvb421dYQJ5SrPeNobjudb+IZ0vol7gSmvEZ/3kCJ/EzwLHOafG61b0OvFZ09hcLMtES2v73QXTnNdtMtDs/ay/XC6j4cxeUq77fU8jobnKTjK7mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H1LTqa+VzJOJfsMqE1nEI75EN3P6FsslOSeF6BcPNPA=;
 b=iIUAe/CS2GkZmJFZBeySbpFyHh5JFWPXL5YBnXHO7dLJQDrNop0SyfMDIGCEv+WRSXJCZRivKrujjD36u+sJ7aX04vzM6VHGSnjbduUZmEPqWQyUQM4X6lzSsZn0yGA/wbZDbGZjlGC71Mf46zjtrN7BxNIUH9QvXTP2v8Qj8tGTpd+sMXUnLnn7XNhIid01ZlR+sWzKoquaJd7YTO9kfJ2sZscOQ0Ozi2cW5b3NOGykzgQfKq66vR0aCvdXwH9T15G+YBDV/1AwAjkmI6vxpPyF78mm0BMUf1Tl2AevxC3AXict6sI1GbURouCkKjVkOTdKfb0FwLTBPWSzY10Y2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H1LTqa+VzJOJfsMqE1nEI75EN3P6FsslOSeF6BcPNPA=;
 b=2QT8zaIV2vB9fNHXY/s8lONupje0/FWpkM+MJPXDbrS5tYS7jPJ11vfQLio7RZN8NYBLEloBC6Lr3UkhfiWhHjjhU364WIlYC7Zz6TM+kuaq6GTr9faw4mR8x5yrn9Un52LO0KjGxv0qMpr84n/Hh/IthVoYGYDumvwW62MRH24=
Received: from DM6PR01CA0017.prod.exchangelabs.com (2603:10b6:5:296::22) by
 PH8PR12MB7207.namprd12.prod.outlook.com (2603:10b6:510:225::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.15; Wed, 12 Oct
 2022 20:39:59 +0000
Received: from DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::41) by DM6PR01CA0017.outlook.office365.com
 (2603:10b6:5:296::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.15 via Frontend
 Transport; Wed, 12 Oct 2022 20:39:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT098.mail.protection.outlook.com (10.13.173.61) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5723.20 via Frontend Transport; Wed, 12 Oct 2022 20:39:58 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 12 Oct
 2022 15:39:57 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Subject: [RFC PATCH 6/7] KVM: SVM: Add MSR_IA32_XSS to the GHCB for hypervisor kernel
Date:   Wed, 12 Oct 2022 20:39:09 +0000
Message-ID: <20221012203910.204793-7-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221012203910.204793-1-john.allen@amd.com>
References: <20221012203910.204793-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT098:EE_|PH8PR12MB7207:EE_
X-MS-Office365-Filtering-Correlation-Id: 72327a0a-ed9a-4b62-c109-08daac91edcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6Kt1ahcXXhbMCWFiMyfFaIGU/6OwARgdTCldJoeKnJTIVbYAip7YRRIXoLsCeeMkJxqobrveKgMta8DAGWO2aAUjONwy0BDq4kR/4JKDr92yLx8eHXA00Amb2zQe+7aZ3Xeyhb7KTtu06L6jFg2R0ek4qeMI6qmEMGRls2S2TQPXhUpC2H9UeexR+JUAQ1u3LqDzp4yv43XO8StYEEAn5cet5nRcdR12/x53+FtMw/DlQE3GrnJCYa3jjMpDX9fUPVHtQdcDYTf1CpeaCeYnKW50Y9hR2GUD8zH2CmBr31cBi4lFoXqXYJU55rW+XA+UzKVJ8mStxJ7BVNVzFQAEaV+7wXkARo4EOQahCW+Vf8H47vPWYUfHBKKJ6O/delm+KV7mmq+hRjv0fvHCFRPSaRHy7aUlnoC6qf3dDe7ihg+HOdqXKe3THlQ3AUv48/LLkwPokYaeb59Z6FnL21PSjJJlfKufji56te1RKGvVkWwY3OF5PPu9zg5prlV5iHjNiS4lxjiGF7LQE1KhaqdR4EImlSHNCjFNaRIhYG+F9ez27MphqaZ/9sAPgAd9lZnwHyQTocGDrTcaDU/FJtnlvxT3vVliZGUlYycSjEHc4NkqTTRCQdSeVe0FSVwRbgJFw4InF32OgXJN63u7k+7E9sWIF6XiGfzvf56pLzlKs1KA3M9lzZqrP4O7xnuIkVMWmqt37pz54otXkBzSpeagc/NmcG7nNuobe7veAK1u3A/mwYw4Pd4+9GoUJirTfiePyCawpSzO9kX82u0Qf+Hy/eOGTGXEaOF8i6rC5wypJiZJjuUJzLdt2bP91aiDGR7s
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(376002)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(316002)(8676002)(2906002)(82740400003)(478600001)(8936002)(70586007)(82310400005)(26005)(7696005)(54906003)(86362001)(70206006)(41300700001)(6916009)(36756003)(356005)(2616005)(81166007)(5660300002)(44832011)(47076005)(4326008)(40480700001)(426003)(336012)(186003)(83380400001)(36860700001)(40460700003)(6666004)(1076003)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2022 20:39:58.5419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 72327a0a-ed9a-4b62-c109-08daac91edcc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7207
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 0361626841bc..b98c2a1087c0 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -625,5 +625,6 @@ DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
 DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
 DEFINE_GHCB_ACCESSORS(sw_scratch)
 DEFINE_GHCB_ACCESSORS(xcr0)
+DEFINE_GHCB_ACCESSORS(xss)
 
 #endif
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index a5e72b2c94aa..55730055ee4c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2418,8 +2418,13 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
 
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
 
@@ -2988,6 +2993,9 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
 			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
 	}
+
+	if (kvm_caps.supported_xss)
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f40d3df2c1be..b474c7e57139 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -141,6 +141,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
 	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
 	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
+	{ .index = MSR_IA32_XSS,                        .always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index c1c3e090ff9d..ad89b1dbe62d 100644
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
2.34.3

