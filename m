Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF8A46ED28C
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjDXQeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbjDXQeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:34:31 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2045.outbound.protection.outlook.com [40.107.95.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 271F93A8C
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:34:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z28Z7vrNdMjaJ31ulPYGa3QvgnCxROgon4JBJCzVZrCpj1IA1CUOugW0aEWBohpTUrA796J0OJMY4HlY7rO8DLFwq8AZ3irsGTeNRBG4BIs9VRqvhDJ7IGHbFA8MOzMEwWPuAgrZr4lqSiJpzfVkWGKJYsZAVdYwk2Bc41n7FVgKeRFFqpflYp+C+s0jlV7RmE2DqSh9bR4MN7i8Rb9ZGzrJTByox1jIBN6XcugcZBkZqLUFRK9kP0DkrtT7maaUiU9Aes4C3QN2hnBAUh1NcCRk8jE7n9sN6OJ90ruaBmYKAxbxuOtK8xfaH2s+Ky9Z6aJZEzTB8JYChMhSvzjk+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s2RXZq6xnqXUjVEI0SKciH5tnYXyjK6P96Y9biP5E4U=;
 b=Ph/5+mPXu2Q4EksnzZSYaY5blC9z4JQH5JJ0wLUqowMIL1d6rwbAYtWZLRwOgxuH8CXcc5FflHYowLZUv+fd5AbpNsMbCO9JFrF3T0i1kby5KkAFLwS3aZIfmsbA5L+ZxjMIdXIunNp87U3TKKMChAjF/g18cDJhb5TRNfs//PfuRjybiBZupKyRwqZHvKDNMJiRau3E103Et1SCSR0xYDdeGmGTvG3LZCcHfCmvUrwHheWvyT7/KDqN7jpfxOiy01LDINnbGX/MBSLVzbjpYzhq10YxEEAgRVWwchpTwDfoSRvZhwDpmJMcHhca3pSyNR55gJ90WDKb9BF53ab73Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2RXZq6xnqXUjVEI0SKciH5tnYXyjK6P96Y9biP5E4U=;
 b=OJUvkZ5GHIrWcXRJJvfgSmjCsL4gd7H7xKmf/ZIWYrsFpbCaZsuybR+s7UY2JdEhcTzhBrgrgp/x83QtNkXwdHkhDQB4BvfldjbKWIZMVM7+V8xVVOnlkeYaVpa63ScJU/qc5howvz3uPUN4v1miz5ykzPCMhzp78XCGflepC/I=
Received: from DM6PR11CA0049.namprd11.prod.outlook.com (2603:10b6:5:14c::26)
 by SN7PR12MB8818.namprd12.prod.outlook.com (2603:10b6:806:34b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 16:34:27 +0000
Received: from DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::f3) by DM6PR11CA0049.outlook.office365.com
 (2603:10b6:5:14c::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 16:34:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT080.mail.protection.outlook.com (10.13.173.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 16:34:26 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 24 Apr
 2023 11:34:24 -0500
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
Subject: [PATCH v3 6/7] target/i386: Add VNMI and automatic IBRS feature bits
Date:   Mon, 24 Apr 2023 11:34:00 -0500
Message-ID: <20230424163401.23018-7-babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT080:EE_|SN7PR12MB8818:EE_
X-MS-Office365-Filtering-Correlation-Id: 653af9b5-fbea-4dcc-48a8-08db44e1c532
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9GA1mvYE7hPd+P4MmJJ+iBlNKznxET4EnfVf4eF9Naa4zKGWbG+FnkYOhNQ+DMWjjF537lDmyiL6d0fERkDE8mR5o2hPR2vs/5KJCOMdMu1HtWyBOc0aVOF2n8PwRdoXyZRNvQ+cGIgG/bR7bIK1Own8TKMr1A6Ak3WVhSosiH0vD2dmj50qt17OryiH2hvdsyKz8sXn4WfOeUlvGFIk1iucHtX0uPC3yOWLbTdxihiLKoZ3yXW67mvimFBkpljK8aiiDFy7AUi/5zdpl2JXDjbC58flAQ8VF3LBtBzDbsKsQuXJgTVLHI5ZPAZvdZCccFyIPInRQHm13NIPI3wNPmKPYSgM41JzYIc0ExPwZpNhVus8DExuGyCkHJZq+0MB2VAtD0HfwP5pD2cEMqlqIX+K0SKvMfqwHU2yy/T3ojhTa+1/5vzKKGmdM1aKH8dHCuF8csJbAyww3bIIM6yjxirqJKr6YRJM5XiD7bLwXaLTu9ImnqxHo/XQCXgLyQJcJQwR2yworVPbF6CEySN5udHnbsO1v4Jd9WT7DvwvXoX5bD4RpcPbuRQzzhs4AFoak+OiOl+QE1fEMffyFlpc+nuYrIqx2zTP8gr8hcwWXFqoD+eGPW9nl4CH5DYTH+9pxn4opFb9BEzTV53Vi3CwLMJ+4egsaO5OGJa2UL6jZMA2560Hqf1+JaKfglR36sAB157xfkdq6gtVQPGtK9+FYonlWWPhTQwbjxgeH8Z4HiMEuF1jFqqIeKn1QFGp9dUot/T2N2U54ZXRnp3xXy1MiA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199021)(40470700004)(46966006)(36840700001)(36756003)(8676002)(8936002)(110136005)(54906003)(40460700003)(478600001)(4326008)(70206006)(70586007)(7416002)(40480700001)(356005)(44832011)(81166007)(316002)(41300700001)(82740400003)(2906002)(5660300002)(2616005)(86362001)(186003)(36860700001)(16526019)(966005)(336012)(426003)(26005)(1076003)(7696005)(6666004)(47076005)(83380400001)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:34:26.9013
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 653af9b5-fbea-4dcc-48a8-08db44e1c532
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8818
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the following featute bits.

vnmi: Virtual NMI (VNMI) allows the hypervisor to inject the NMI into the
      guest without using Event Injection mechanism meaning not required to
      track the guest NMI and intercepting the IRET.
      The presence of this feature is indicated via the CPUID function
      0x8000000A_EDX[25].


automatic-ibrs :
      The AMD Zen4 core supports a new feature called Automatic IBRS.
      It is a "set-and-forget" feature that means that, unlike e.g.,
      s/w-toggled SPEC_CTRL.IBRS, h/w manages its IBRS mitigation
      resources automatically across CPL transitions.
      The presence of this feature is indicated via the CPUID function
      0x80000021_EAX[8].

The documention for the features are available in the links below.
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,
   Revision B1 Processors
b. AMD64 Architecture Programmer’s Manual Volumes 1–5 Publication No. Revision
   40332 4.05 Date October 2022

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
Link: https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 7fcdd33467..ce26e955d8 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -806,7 +806,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             "pfthreshold", "avic", NULL, "v-vmsave-vmload",
             "vgif", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
-            NULL, NULL, NULL, NULL,
+            NULL, "vnmi", NULL, NULL,
             "svme-addr-chk", NULL, NULL, NULL,
         },
         .cpuid = { .eax = 0x8000000A, .reg = R_EDX, },
@@ -925,7 +925,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
         .feat_names = {
             "no-nested-data-bp", NULL, "lfence-always-serializing", NULL,
             NULL, NULL, "null-sel-clr-base", NULL,
-            NULL, NULL, NULL, NULL,
+            "auto-ibrs", NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 7cf811d8fe..f6575f1f01 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -773,6 +773,7 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_SVM_AVIC            (1U << 13)
 #define CPUID_SVM_V_VMSAVE_VMLOAD (1U << 15)
 #define CPUID_SVM_VGIF            (1U << 16)
+#define CPUID_SVM_VNMI            (1U << 25)
 #define CPUID_SVM_SVME_ADDR_CHK   (1U << 28)
 
 /* Support RDFSBASE/RDGSBASE/WRFSBASE/WRGSBASE */
@@ -946,6 +947,8 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_8000_0021_EAX_LFENCE_ALWAYS_SERIALIZING    (1U << 2)
 /* Null Selector Clears Base */
 #define CPUID_8000_0021_EAX_NULL_SEL_CLR_BASE    (1U << 6)
+/* Automatic IBRS */
+#define CPUID_8000_0021_EAX_AUTO_IBRS   (1U << 8)
 
 #define CPUID_XSAVE_XSAVEOPT   (1U << 0)
 #define CPUID_XSAVE_XSAVEC     (1U << 1)
-- 
2.34.1

