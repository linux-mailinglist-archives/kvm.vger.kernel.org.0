Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 538676606BA
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 19:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235960AbjAFS5i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 13:57:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235969AbjAFS5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 13:57:17 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F263277D0B
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 10:57:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CIDYKfhMT5ohtbZpCz3BbYM57kOHIaYzcFv/IF10dpWL9I74VCKp/4p+kjoeIUaUuqtqDNS44ggzToxYWHUsv6FocNqA3jrlxWD+seXX71+Ndgys4yXV4h5Fgct356ZPkOBbchHsP/H0tOdpbQ/LBTUk2z5GJkxTnZxZpnyihm0i2HjbRaO9xzgiie8KbRZfTC4OCCjMtxZdGDW2pXngWi0du4HjqYMbudoIYR/4sg8o+YuVGCOgaC1GEnFiLijH/hSedkWTly4u1VmQA2J55adNoTJY9Y/j63c7IlcnWU0t+I9Pe2DUFXzwwLTQR/H8bHRjI6JsoPuNDEyjJhRNGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5pJh7ODxvxdX+W3oZbhk4DWgy8Ysj0AN92bMByXrSzE=;
 b=GauukCWQxW5VFqGYONak1uWcv3U85daB0120t5tyI/KRsuoY1q0XKl+dFnNIGQbZ17Q3vSQK8Sx/Ap3NqBzsh7YMxVvpDnVqOkaXeJ9n1hcMMBRDH5WE+JlOk6PN7UcgTscHfp02vWF+AeGko612P64MAKBh/dN/UDEAdyzKwCZWuDYRTGesyAjuqEAbjrvzd2e6NBIXksJxNx85OGh3R6p/lPIiiP3DODt4WoChvbTRi+A/js9MjBIruPWBS2TWVOoJa2XBUUouyz4tT4MYHvK07oVm+xSq1ITFeoEP/ii/30v7xzEfqEM+MnvTMUvyY4mSyy9RdJxpdO4co1VEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5pJh7ODxvxdX+W3oZbhk4DWgy8Ysj0AN92bMByXrSzE=;
 b=GFMba8JwVoYcwTkEjcg2nfIz3I4yCO+qqYLUWwrcw7DBac4QnzBZBv+tDf35y39BHHVMcUJhS/TFeHY9aEUbRPx9TKZzLaLrcx6d1LWXnVCe5XOfyD33qccUvCdOu1H3ngc0Wx8vdEllGVfb31/s5UW9vQvwUJGsGIMlp5AHnN0=
Received: from MN2PR08CA0007.namprd08.prod.outlook.com (2603:10b6:208:239::12)
 by DS0PR12MB8413.namprd12.prod.outlook.com (2603:10b6:8:f9::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5944.19; Fri, 6 Jan 2023 18:57:11 +0000
Received: from BL02EPF00010208.namprd05.prod.outlook.com
 (2603:10b6:208:239:cafe::61) by MN2PR08CA0007.outlook.office365.com
 (2603:10b6:208:239::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 18:57:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010208.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.15 via Frontend Transport; Fri, 6 Jan 2023 18:57:11 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 6 Jan
 2023 12:57:10 -0600
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>
Subject: [PATCH v2 4/5] target/i386: Add feature bits for CPUID_Fn80000021_EAX
Date:   Fri, 6 Jan 2023 12:56:59 -0600
Message-ID: <20230106185700.28744-5-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106185700.28744-1-babu.moger@amd.com>
References: <20230106185700.28744-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010208:EE_|DS0PR12MB8413:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dfb5045-1f42-4faf-b5b3-08daf017d14b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9FE3mrBC5C5zC2ZNs3qxDtZ+3oITBDa1bOeJYGYryPHNK+fDA5LwbB2cSHKD4n87gDuQNvs5EGmAB52++jjKhHwumxsyu2OWMDuSfHxDRCvk5JvMauCvxBmS0lc4ltmkZ4t6oCgYEgpSzCNY6q8Vjj+J+QQH6V38Cb5JXnLCK17jgb8VYvYW3xiVVHmfRmyRaqacgJQEWWgJBqDYxxTbfaoaE0/rv0q/pkfna91PddZ5IYVugdcbYFpIgsDuvyl81cwvXBDT+vB6q425yh9SJqNTW4fInWARjIcKsDRbHKSuJD8bZbcXSn8y5ClHFDZ5AYybvRdGPOH3RA/5XgZVb9Na4EG64Wyqmat0RMpoI0JMDBUNzaEOkD3ivO42wxwDsXUZ2dkHnybace2R+SESpdMN7Tfi3ggX34TV3+8ju4fhP+7LIbS4AeOjluGHz55acTng+YwKODXjETTJ1qFQc/xc2wBSCJZZ6Rsqe7SJgFxw0HWEDJAeHfuicfFTT4vlYjeD0FHN/O/UFPzZXjhmxgH7z9bipg50VA1w4wUxOapIbVsiwIv55ltDi8uJvuKKBFAePDoAXunaMi493B/W/J7WZQZ2H9yceygBOYlZbn1hFgS3P6ZvFNw39vQUlR7gTLJl39ZfKOObDSqV8eSUgRBVNqW3rhT0rYQlZiujA83Sl6NJQbeTwRgzibmAlPKzq6OmfEJfKikVhvxf4dAogjbwpDFSIz/4nokAKxZDc1EouVckELGCNjRq2k6ueytVWW2f1yXxJkvLFXe9moGcnz/gNAN660xcNb4BP1hZ4xFEyEWUSrmThKktgUUUz+4D
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(7416002)(5660300002)(41300700001)(8936002)(4326008)(70206006)(8676002)(70586007)(54906003)(2906002)(6916009)(316002)(7696005)(966005)(6666004)(186003)(26005)(478600001)(44832011)(16526019)(40480700001)(36756003)(86362001)(2616005)(336012)(36860700001)(1076003)(426003)(47076005)(81166007)(82740400003)(356005)(40460700003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:57:11.2172
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dfb5045-1f42-4faf-b5b3-08daf017d14b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8413
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
Link: https://www.amd.com/system/files/TechDocs/40332_4.05.pdf

Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 24 ++++++++++++++++++++++++
 target/i386/cpu.h |  8 ++++++++
 2 files changed, 32 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 117130fba1..63c4675569 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -918,6 +918,22 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
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
@@ -6001,6 +6017,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
@@ -6430,6 +6450,10 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
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
index 8c65c92131..519dcdc23d 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -597,6 +597,7 @@ typedef enum FeatureWord {
     FEAT_8000_0001_ECX, /* CPUID[8000_0001].ECX */
     FEAT_8000_0007_EDX, /* CPUID[8000_0007].EDX */
     FEAT_8000_0008_EBX, /* CPUID[8000_0008].EBX */
+    FEAT_8000_0021_EAX, /* CPUID[8000_0021].EAX */
     FEAT_C000_0001_EDX, /* CPUID[C000_0001].EDX */
     FEAT_KVM,           /* CPUID[4000_0001].EAX (KVM_CPUID_FEATURES) */
     FEAT_KVM_HINTS,     /* CPUID[4000_0001].EDX */
@@ -925,6 +926,13 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
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

