Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CDE6ED28D
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbjDXQep (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:34:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjDXQeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:34:31 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2070.outbound.protection.outlook.com [40.107.212.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D594EB
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQdeXJSj3HSm2FouDF481bZ8hczpuzGU+E+0WlqHX7Lf2tqhAF468JrciVuj4Sn2KsSmXybOmdYh+oa6M9dO1tmvHtwVXgdSakZk4lK4VogDVYarakdsXOcDhQcDyxAYdMsNPLwjYfx0R4yoyHHjYe6Wu8Zv17mojOcVYt9UZWwnIZF1b0BdgHjFSlA27AxQKDiw38sPCgLN7s5wWMQcBgqJziQpbBvCSoOl6q5p2eehWfyOV85AE6YHArcp5SYh/swQVBAZKtPCbgZx+DnmC5+glxkJ9pzhU37ucOrD8BLOr3RqVOVDG2BlFrmBDjzKhiXaNzoyQynnySIRN2ZCzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoEkdo/a+Z9HKProYBCe60hENHdZBmvrwHTv9S1GF0A=;
 b=Tw9Qx4LSCeGgbAa6ttSjrDMOf8gmIA2Ye6J29DyLif5phJ/wxajZ84gqmBFRvOOLS25ZfveGJLmezb5iYq3cacOusqZatv/wpEyCkOKY0MR2ZiC4gjNEohm8tkwHdzIq98jJqlbvwncys15RLdV4+2VCTjeOIHzvjA6ZqfXaYk2atJCIl+Ngq+7IstDegneGcV894QYG/8MWirrLD1SPexfNua+VZhHjUmuTN2Z3oA49DcpMohvHWd0fPrQY1CTfmoV1mTQ5qPyYWBXsVgNvcXUCf3KsIBVbEB0xwGGDiITTukK7LH4dlbQLEnlDxtnRz7rob6+z1p2ZJKhlkhlFug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoEkdo/a+Z9HKProYBCe60hENHdZBmvrwHTv9S1GF0A=;
 b=IKrsF+H4pb6OaLE3VIJDzttNIwMnkg6gnla/xwz8kbfCaaOBrTd/HKe4HZ93TIgiQoeSeiyjM6ZvXZ3s7cBdYrZ/y3CVbN2Olp72mhAMAqnxlEVeK2/PpJm8B4kiuChrfGPiI9RX4lJM/8w8tLLa/Gxut2Xxz+ytSA5ZegqA2d8=
Received: from DM6PR11CA0055.namprd11.prod.outlook.com (2603:10b6:5:14c::32)
 by PH0PR12MB7078.namprd12.prod.outlook.com (2603:10b6:510:21d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 16:34:24 +0000
Received: from DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::90) by DM6PR11CA0055.outlook.office365.com
 (2603:10b6:5:14c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 16:34:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT080.mail.protection.outlook.com (10.13.173.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 16:34:23 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 24 Apr
 2023 11:34:21 -0500
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>, <richard.henderson@linaro.org>
CC:     <weijiang.yang@intel.com>, <philmd@linaro.org>,
        <dwmw@amazon.co.uk>, <paul@xen.org>, <joao.m.martins@oracle.com>,
        <qemu-devel@nongnu.org>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>,
        <berrange@redhat.com>, <babu.moger@amd.com>
Subject: [PATCH v3 4/7] target/i386: Add feature bits for CPUID_Fn80000021_EAX
Date:   Mon, 24 Apr 2023 11:33:58 -0500
Message-ID: <20230424163401.23018-5-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230424163401.23018-1-babu.moger@amd.com>
References: <20230424163401.23018-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT080:EE_|PH0PR12MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: 1a3b7c4e-fe86-4625-b931-08db44e1c331
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 781jX+wDmQUhH/n8KOEUGgCaPoxeo8X2djHohDQbNn24QxypgUwLGW+75/QM5fJSvf49uSYyqR4p54ca4XXrE8v2WcxZ3OuoBxE4jpLTua7DczqJlv6XE208WVsgVoc4AxDPRsdLKUdYscqj9Q9RQdKJuu04HZdAeNfA7rNn7rzBlfz9v7zRy+bUNBUr+SFn+u+fWYLjnLwa0aDMOaX/ee+/5zVs8UH2yuIa6gpS1iB/kKmj/TOAs9DekwNrnlwwvCbl7GWYt/1G+18O5MX1u4KeD35QNyhtKK1h475X3M2R5HltlgcQKdLO1RysKUeORhS8jl3M+K2gpnECS7lk1o+LlOf0mhrzvJ2g7VygXuZrvDP3Qq+QAMB+03Q80PDh52KNzz8LlcHhORoqCxgWHdzf30OrHQx/OdiK2DOIJGltpH0goy574uxvP4bm6kqQx58+2cbH2AaoS6aMcF6XlFhiuZryfxgJehtH5dFcDD+Q5NPmYWIQUVmDwpDpF9hYrxt3X+8jYkPpWgJ38H22H4QJm43f+GwQvAr56iINeMJcaChW4t2b+1u9PqXTZvBrLvlQPK+b8T5D3FeipT2NfFfbKXBxkVWebT/XZP7ZirDl6uj381J20EAZbQ3SRO76JGn024nQsJZ4ZriJ1Y1MboANbfRGBt2UfL9zApowwSWporRhS6N/e7olQp1+9LFQSaagf22IyHJKtEq1Hie159SY5vbNyCPj4DNZ6Z2XbhotNQivDy6k2D7MCZGaBA8EMTm6CfkwTJj4Gu5D80B5Zw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(346002)(396003)(451199021)(46966006)(36840700001)(40470700004)(40460700003)(2906002)(70206006)(70586007)(316002)(4326008)(44832011)(7416002)(8676002)(8936002)(5660300002)(41300700001)(82310400005)(36756003)(86362001)(40480700001)(356005)(16526019)(26005)(186003)(1076003)(81166007)(478600001)(6666004)(966005)(7696005)(36860700001)(47076005)(2616005)(336012)(426003)(110136005)(82740400003)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:34:23.5422
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3b7c4e-fe86-4625-b931-08db44e1c331
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7078
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following feature bits.
no-nested-data-bp	  : Processor ignores nested data breakpoints.
lfence-always-serializing : LFENCE instruction is always serializing.
null-sel-cls-base	  : Null Selector Clears Base. When this bit is
			    set, a null segment load clears the segment base.

The documentation for the features are available in the links below.
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,
   Revision B1 Processors
b. AMD64 Architecture Programmer’s Manual Volumes 1–5 Publication No. Revision
    40332 4.05 Date October 2022

Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
Link: https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
---
 target/i386/cpu.c | 24 ++++++++++++++++++++++++
 target/i386/cpu.h |  8 ++++++++
 2 files changed, 32 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 64a1fdd6ca..d584a9488b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -920,6 +920,22 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .tcg_features = 0,
         .unmigratable_flags = 0,
     },
+    [FEAT_8000_0021_EAX] = {
+        .type = CPUID_FEATURE_WORD,
+        .feat_names = {
+            "no-nested-data-bp", NULL, "lfence-always-serializing", NULL,
+            NULL, NULL, "null-sel-clr-base", NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+            NULL, NULL, NULL, NULL,
+        },
+        .cpuid = { .eax = 0x80000021, .reg = R_EAX, },
+        .tcg_features = 0,
+        .unmigratable_flags = 0,
+    },
     [FEAT_XSAVE] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
@@ -6136,6 +6152,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             *ebx |= sev_get_reduced_phys_bits() << 6;
         }
         break;
+    case 0x80000021:
+        *eax = env->features[FEAT_8000_0021_EAX];
+        *ebx = *ecx = *edx = 0;
+        break;
     default:
         /* reserved values: zero */
         *eax = 0;
@@ -6565,6 +6585,10 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
             x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x8000001F);
         }
 
+        if (env->features[FEAT_8000_0021_EAX]) {
+            x86_cpu_adjust_level(cpu, &env->cpuid_min_xlevel, 0x80000021);
+        }
+
         /* SGX requires CPUID[0x12] for EPC enumeration */
         if (env->features[FEAT_7_0_EBX] & CPUID_7_0_EBX_SGX) {
             x86_cpu_adjust_level(cpu, &env->cpuid_min_level, 0x12);
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 14645e3cb8..7cf811d8fe 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -600,6 +600,7 @@ typedef enum FeatureWord {
     FEAT_8000_0001_ECX, /* CPUID[8000_0001].ECX */
     FEAT_8000_0007_EDX, /* CPUID[8000_0007].EDX */
     FEAT_8000_0008_EBX, /* CPUID[8000_0008].EBX */
+    FEAT_8000_0021_EAX, /* CPUID[8000_0021].EAX */
     FEAT_C000_0001_EDX, /* CPUID[C000_0001].EDX */
     FEAT_KVM,           /* CPUID[4000_0001].EAX (KVM_CPUID_FEATURES) */
     FEAT_KVM_HINTS,     /* CPUID[4000_0001].EDX */
@@ -939,6 +940,13 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 /* Predictive Store Forwarding Disable */
 #define CPUID_8000_0008_EBX_AMD_PSFD    (1U << 28)
 
+/* Processor ignores nested data breakpoints */
+#define CPUID_8000_0021_EAX_No_NESTED_DATA_BP    (1U << 0)
+/* LFENCE is always serializing */
+#define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
+/* Null Selector Clears Base */
+#define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE    (1U << 6)
+
 #define CPUID_XSAVE_XSAVEOPT   (1U << 0)
 #define CPUID_XSAVE_XSAVEC     (1U << 1)
 #define CPUID_XSAVE_XGETBV1    (1U << 2)
-- 
2.34.1

