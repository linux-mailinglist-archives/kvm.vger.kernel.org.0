Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 409BA7C408D
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 22:03:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234417AbjJJUDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 16:03:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234365AbjJJUDO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 16:03:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6EAECC;
        Tue, 10 Oct 2023 13:03:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BYKqq6+qAy7EkIqaYsqHr4rtO2WgbO9FvVxjSzar3TuSM11GLrBuYciEQOnD+bFr6F7Bj47mzVrPGUXVq37FnPjHV/oVUw3SiBapntz4+3mcEPMOUnv213thNyh5ykVyAESAhxBrkTGSEFnDAPP0W7A5jXNRG86YL5ngXY8lRlK88BXESTml+s0nCsxojWpIeoNVh/P+UV8HVfVufWKAsl4Yu5JGeNO53tgyaAVnDMQ8+tMmSG3KAG5JP7sKiLxUPOdDR171YDeKSFqwqIXE9yWKYp7dJ+is+wbNXf70VQgliu+0qHXGzVf4cVwGh2CYFQB/LxYa75VxU8de8MqKHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dV0595VjvOmV1IaYkOEutOQmELGCffnog47vHBHmL4Y=;
 b=B6VZBtNj9+lRF4Xo22OaMrvyGaYVokpebcLRhEc1XetsuJYcs04WL9oa18LXI/4fk71KdSQBu79aeOk8FuMaZs1oiPl25iQID1jJoAvxVuqtT9+o0J0T/VfkJzwA3+cRErlqqwHSMqLCBFT/MGaT6nvsCuIJpA6vmZFcmpgJ+m9rCANc5cfmPLVa2pjfzXuArEaCjojcD/t3/r6ual0Orj/OE2FaA2RXFFna0Ckrqu0pY/LRYWc2kxZz73lUQEA0UUr8yzI2WqfRfUGBwYUlJvfYpj8+Jg97G8a9jZF/x2APhKLAntEFwt0pXKpmlHD8b4s82NEhxiI7UCMMmVyyXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV0595VjvOmV1IaYkOEutOQmELGCffnog47vHBHmL4Y=;
 b=CdmcoG7sNTagcrbYtNwUB4MLuWYvXNeA+YVQaulwtfEFUwxc/uUHTcthIoIF+F9bjFHTtpQkLVOVkKRofjS3KrIxWwZwWFJGe/TSTWwIThduwPFVO7DFefepDfqTDIFgwG66vUwv128kRbK45lTkwJZuRb/A9dQGLTbrsv06Xwk=
Received: from CH0P220CA0018.NAMP220.PROD.OUTLOOK.COM (2603:10b6:610:ef::30)
 by CY8PR12MB7242.namprd12.prod.outlook.com (2603:10b6:930:59::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.36; Tue, 10 Oct
 2023 20:03:09 +0000
Received: from DS2PEPF00003440.namprd02.prod.outlook.com
 (2603:10b6:610:ef:cafe::e1) by CH0P220CA0018.outlook.office365.com
 (2603:10b6:610:ef::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.38 via Frontend
 Transport; Tue, 10 Oct 2023 20:03:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003440.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Tue, 10 Oct 2023 20:03:08 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Tue, 10 Oct
 2023 15:03:08 -0500
From:   John Allen <john.allen@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <pbonzini@redhat.com>,
        <weijiang.yang@intel.com>, <rick.p.edgecombe@intel.com>,
        <seanjc@google.com>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
        <bp@alien8.de>, John Allen <john.allen@amd.com>
Subject: [PATCH 3/9] KVM: x86: SVM: Pass through shadow stack MSRs
Date:   Tue, 10 Oct 2023 20:02:14 +0000
Message-ID: <20231010200220.897953-4-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231010200220.897953-1-john.allen@amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003440:EE_|CY8PR12MB7242:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e616259-a969-48ba-6716-08dbc9cbecbf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dwhSFk1V+y1oT/0xDrqkFI5ZkoUjDVmV2F5EYmDLTl7/d/c35AW+yN/WisXGCq7g0qxEyp8bHKx/j0SvfL5sYQnekSg050h09FCD/Bl84y8o7oSsKOjdaVGgxDOj7Mgyn/OnvGFjwMqtDnuQCbNcAgw0qk8BZE+nTEMPtN3+gxw5b0nUjUhvb9jcw85Egwn/h6JFTME3OO/ReA/wQyFEJiZ3jbkPkV7tqpcvFbg2ACkfK51UqZD3oC/rDSg8uGzwzZayc53kMfNFIU5R/UXJaEcFcAmEsfUe2m8X2g9LV9F0l1J20iyFECoBt5s0xC2oOA1ufaWYKZEsfR6pvyM0m4Janqg+jw2xeqQxDuqpOiWA26dnCdQDHWq/VuiXTD1lUuOOpcWrgtzS4KB8bIyipDz9k3ZTdEj+AlhDSr82n6Ryxj5r930ybnyILSriAWwrz0lIYZmJ5erS1Wrl3+PPG9XXObfbTP9mnNKPgjeJIsvKSVOJYoL0DD3TuBqUx1WEWlyH2GOItXpiegXe7CCzuHt1+JRQgFVGCNZ5+WSuIMMOFKFostqPzeKiYEqJYkCPXom8PANrvxald9Y+v0u/6hAkLaO2isQ8IFobPfV9n0nBsRDTisAAM+9+gaaLcL4YmGYA3OpP/gX8LorqWNbsuOdTR8uIQEuxyrYoAkGGan1HnaH6mFeOxrl44lBqyvCD6L091AYqjJpZkai/8QCmedfIQbhbbFdq5Eo9xQsFs75E4wwyWS7EdccvrP0tbAjKvxENkfx4YGGZVq1nNRVKtg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(396003)(39860400002)(346002)(230922051799003)(186009)(451199024)(64100799003)(1800799009)(82310400011)(36840700001)(40470700004)(46966006)(6666004)(83380400001)(16526019)(426003)(26005)(336012)(2616005)(1076003)(5660300002)(81166007)(82740400003)(86362001)(40460700003)(40480700001)(36756003)(356005)(4326008)(478600001)(44832011)(2906002)(8676002)(7696005)(36860700001)(47076005)(8936002)(41300700001)(316002)(6916009)(70206006)(70586007)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Oct 2023 20:03:08.9630
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e616259-a969-48ba-6716-08dbc9cbecbf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS2PEPF00003440.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7242
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If kvm supports shadow stack, pass through shadow stack MSRs to improve
guest performance.

Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/kvm/svm/svm.c | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.h |  2 +-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index e435e4fbadda..984e89d7a734 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -139,6 +139,13 @@ static const struct svm_direct_access_msrs {
 	{ .index = X2APIC_MSR(APIC_TMICT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TMCCT),		.always = false },
 	{ .index = X2APIC_MSR(APIC_TDCR),		.always = false },
+	{ .index = MSR_IA32_U_CET,                      .always = false },
+	{ .index = MSR_IA32_S_CET,                      .always = false },
+	{ .index = MSR_IA32_INT_SSP_TAB,                .always = false },
+	{ .index = MSR_IA32_PL0_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL1_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL2_SSP,                    .always = false },
+	{ .index = MSR_IA32_PL3_SSP,                    .always = false },
 	{ .index = MSR_INVALID,				.always = false },
 };
 
@@ -1225,6 +1232,25 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
 	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK)) {
+		bool shstk_enabled = guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
+
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_U_CET,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_S_CET,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_INT_SSP_TAB,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL0_SSP,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL1_SSP,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL2_SSP,
+				     shstk_enabled, shstk_enabled);
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_PL3_SSP,
+				     shstk_enabled, shstk_enabled);
+	}
 }
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f41253958357..bdc39003b955 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	46
+#define MAX_DIRECT_ACCESS_MSRS	53
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.40.1

