Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F152D6F778A
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjEDUzL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbjEDUyx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:54:53 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0666E5FD7
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:54:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EIoeZ0D6il5AURmWl1JhinW7X9Gl8bth6k6aaa/6m0hHRL7SDJGr/Du6g1Czw7Ie0//a61LvTfNrWex7C1luOFK/D/kto184EZyi+UtdLgM9ELUwatsPJ5Rtf8ePkTgEPseng3irhJkxsKvTzYDNSgwh/gCac/xRyjtIMgs6dcCpXLmn2yNYc7mbnFw68ex/EESXtGI4b/XMBaKJfHShzxHn1eTbIETxO7jkn7xwVEcS56zag5BIiNO4jjWAoZLHyD+yDGpyGe2D7VkhKcPJ6Y9OUT7yA5vqXuTfIjl0wzapXUCt/tG5VxD30X08AVrWEmVVex1+oF8ZE+49gGV7Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rnZEhJAISTg6ODYqVysWyZFD73jAhHNQFTEEwqWkkII=;
 b=nVleNvxQOaIscG4Qj07PdkOMcIS5bHL5Rs5tz37NsV0JLD32WtjeXGWhPDG0+JbNaAUt1wG+8KSVf1wYcxG6NGb9IBlZbMKo0Z8pEwunL6gRXIyCy0Q+8igkYpxt8eZBIfjxi1NY3V1PShUaIZPHkHYFBWO4jt+VGMDBlAMnD7THVirL23r/NDX4ChLIPGECJTcMeBT6jZo7uzUFQ4gHBlJDlP5Hhw4It1ICgAJSQgaGYgBXzYHsKsBbO9RlusRKRufxfZppj8kAkLDaZWgKP8qj1Qe4W4XdeCzlzaLgBO4Qz+FInx7NV3Y36Rm+AMQlXAUa8IOg83B25E11NtJYyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rnZEhJAISTg6ODYqVysWyZFD73jAhHNQFTEEwqWkkII=;
 b=v98CJRGTVbV7JckIWgLxpOkcFuGVcxQe2VjgRorFnCrbH3v/JwekhiaxKV1Hf+adUfYvGoaSXVpsMfiU8WJ6NjX97S/9hS2jjdFxMIuyte4wLgNgouNI68lwMV6vPVqePYYpze/Pa3HoJMEB/m6oM0ZfnQI8Z0z7VdIGYk1Z6W0=
Received: from MW4PR04CA0207.namprd04.prod.outlook.com (2603:10b6:303:86::32)
 by MN0PR12MB6368.namprd12.prod.outlook.com (2603:10b6:208:3d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 20:53:31 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::5d) by MW4PR04CA0207.outlook.office365.com
 (2603:10b6:303:86::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 20:53:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.27 via Frontend Transport; Thu, 4 May 2023 20:53:30 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 4 May
 2023 15:53:27 -0500
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>, <richard.henderson@linaro.org>
CC:     <weijiang.yang@intel.com>, <philmd@linaro.org>,
        <dwmw@amazon.co.uk>, <paul@xen.org>, <joao.m.martins@oracle.com>,
        <qemu-devel@nongnu.org>, <mtosatti@redhat.com>,
        <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>,
        <berrange@redhat.com>, <babu.moger@amd.com>, <bdas@redhat.com>
Subject: [PATCH v4 4/7] target/i386: Add feature bits for CPUID_Fn80000021_EAX
Date:   Thu, 4 May 2023 15:53:09 -0500
Message-ID: <20230504205313.225073-5-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230504205313.225073-1-babu.moger@amd.com>
References: <20230504205313.225073-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT046:EE_|MN0PR12MB6368:EE_
X-MS-Office365-Filtering-Correlation-Id: c0352203-2189-45d0-33fa-08db4ce19e5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yPNj5+hsiVTZMVhyJrv0GGKOTkUpPnFXt0Y+2neRtnxzLohIqJSaYZtvUJCUhsOaROWOChRpZY6OjSJOFh+0w0F/SSCxM7QCCa3hMnh66I/uX7f8PegyY4GSwMAokSAu+ebkIfoBg3lxcDOx+cwhbHkph42d5x3Lg5xwp6R7c3mZmrAEHrYdZOQPKJfQqygK/8qjMdAmrQEdcGMdj2ptCRnGlqvtY0/Eg5jsETvmzXyLCEBZxLUKaGlFYZ1cDIrApaiLxtnIuyXpeDXAshEwd1LoCP38tucbaqYjKIqnRWii56U9rj6/Q0ghfbUSHl9wVtFX9+Lzhsb4OVuS+IYxP7dBcSZ9ZcJAoU+I6XcFT5zXco/lMox4oalPsSn8UoLg9NN+BpQ/xuB1ZQtJQR8I5QZAbYIXquLeXj75HaSk1Ancq0//rMB7ud97lYxYm05UaAuTlBdnoLaxKYmeSktBy8Cqqfdl9LFZAbepeRfhwwOZRfCP7vyJJ2TDqZ8YhXjusZtrpxsbSFJCFk6iItjPNkIs+A1CJfD7vnF9O6WAe4EPZAoDrygRu+9EdGABHfUCJiZpbe9bfsiYsEIHYmlL6vo/FNDh6cRzjNHp1NUSBiVKId20P9f+pPr+jVOnnEgNiQ0faBeihQjcgOHFpN7xm4E6tf0zKiYdn5mQHBM+g6sCAtBnqZ6v7xEYJ4ik1IQc1Ap9Q3ZwSIpOUPz/DrGo41GPz7FX8m91CeJKIOFkV80G6u/MNgI5FLezFq8k8CrzqhOrmYWITlYWHq6yd3BDdg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(376002)(396003)(346002)(451199021)(40470700004)(36840700001)(46966006)(41300700001)(36860700001)(336012)(47076005)(426003)(316002)(8936002)(8676002)(5660300002)(2616005)(70206006)(4326008)(70586007)(7416002)(44832011)(2906002)(186003)(16526019)(82740400003)(356005)(40460700003)(26005)(1076003)(81166007)(7696005)(82310400005)(40480700001)(6666004)(54906003)(966005)(36756003)(86362001)(478600001)(110136005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:53:30.9468
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0352203-2189-45d0-33fa-08db4ce19e5b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6368
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
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

Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
Link: https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
---
 target/i386/cpu.c | 24 ++++++++++++++++++++++++
 target/i386/cpu.h |  8 ++++++++
 2 files changed, 32 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1a79d224da..5c93c230e6 100644
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
@@ -6135,6 +6151,10 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
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
@@ -6564,6 +6584,10 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
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

