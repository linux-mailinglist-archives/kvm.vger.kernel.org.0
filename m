Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A40F06606B8
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235841AbjAFS5d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 13:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235957AbjAFS5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 13:57:13 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9A07DE39
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 10:57:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzuKoBgBo4dJblCQBCXgoHHfQpOjC9tLE5FkenNBC2B7FDSjPrbAUlcI2eUBzpOcRiom81ZJTcZ+AfNdxVtDg5If6YHBtE5HAaQvYs9odJJWEF5HfgTDpv4zCfV7YdQBvUY4cnm2uEJuhIRvV+MeNb+y0gf4TRvgyrUOCJXEAb1F87MM8SmSHKNu38ywUeab69G8DLFAq3iYv4Dusq5MTY9aXBzwd7M20x39/G/GsptnkighUfOEmRoC1HiOwY42gjqx1Xdw3UesMp9h1dcb3O+5a4tzcxwdgD/sHB2aW+RAXkr857f7+S7y4LORc/8E0cQr/rmtoyh0M6GSMy2u0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1EkFN6NgGmvojwEQnf8lIZH0TAlg3fYCbFnhalmKizI=;
 b=CCANlQp8RuAFylX/y0Lx6AJK8vWagtayKtbY2KK6IzqRwtAJEiGbou9gApqtmKuCHp2qfdL729Y4yoihHlgxX15dQ17ePoima6BcKddNWSJdtFlhY6oKWh+zFi7AdZ9sqceYlgxq6dbUflKUEogYpkO78EMbGhaMhu1NRRvt3WB1lZO2FVCVMNJIu1ezCE3xrZHJzDZ92tRfT9TdFXCd4+FEeVdfzXqJI+/99p94p5CLFGPz6juxTUJKQxR3SEW+5DB4lVdq4D45DWnTCfPJVVuqCJeeQ3NMkRaZ+qJdkGaJGNMcYYqkfJLqLCblb7yDOm8qU2gnM5Z1Wk3/BDfutA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1EkFN6NgGmvojwEQnf8lIZH0TAlg3fYCbFnhalmKizI=;
 b=AZipt3sw1OHcx0eb7wwlUbjHpUkk0KvVTMjC8yu7Cp86iFMfBzD8Q85A8Lewf5C0FSrGb81Bqz1D+tRWfLVJOr6ciFOf6jSfvet7mJg7XFf0MYJm+tnxzuZiQzx6djh5mzvbNMIrh7apUuXYav7fhd7Td0G+mFpPufM108pv6dU=
Received: from MN2PR20CA0019.namprd20.prod.outlook.com (2603:10b6:208:e8::32)
 by CY5PR12MB6106.namprd12.prod.outlook.com (2603:10b6:930:29::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 18:57:10 +0000
Received: from BL02EPF00010209.namprd05.prod.outlook.com
 (2603:10b6:208:e8:cafe::43) by MN2PR20CA0019.outlook.office365.com
 (2603:10b6:208:e8::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 18:57:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010209.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.15 via Frontend Transport; Fri, 6 Jan 2023 18:57:10 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 6 Jan
 2023 12:57:09 -0600
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>
Subject: [PATCH v2 3/5] target/i386: Add a couple of feature bits in 8000_0008_EBX
Date:   Fri, 6 Jan 2023 12:56:58 -0600
Message-ID: <20230106185700.28744-4-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230106185700.28744-1-babu.moger@amd.com>
References: <20230106185700.28744-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF00010209:EE_|CY5PR12MB6106:EE_
X-MS-Office365-Filtering-Correlation-Id: 96919ed3-6268-439e-afa0-08daf017d0dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Upm4HY+gfeUBS+fZPPj7sfDb3gOrZaqIEwQTK3t1wQxFzrXY+GUNil4u6DKFXJD5mXfgEkLl7GLEK0HXDal6WOBov+MyOvGm5YILUUKV5ifwW/P7a6PHE+JQSE8ptERmrr4BHL1tp4Tlgu9FXY58roJu1ZQcwZDkfJ5ICOIFKfKgjbYFJ7ewYlC1+fGMYHc/kC39cUxTDnNCG6D4MOCicFGebfQvu2kGD33IdMFLd0HnTYPVuy+YZoRW6MisEgEPUtxaLmOYMx4xonFDY8OQStIsXHvdd7+V6n4f0K6oCwkLvoVo1jR2MN4v3rLuzDmek5WnfmqAUzqJe79mAlyNH4hgZnWlVIxZVgzgDBMkm5Qp+m6e5YkL8RDq2aQPxkh0TIqFb3YnBZcMwJJyHPIueVMBwlSpD43VVfmBXi5EwCSGTdbwmvC1W/CQlqYDSMB5f7dbjKg+wII54RvqpeeeqbmEHj0R0NIzXdQzctUg5m/3ouJxeIajZu+kM1QrGFshJIliTJu6WhXdDFfo/ioqStmXThK3RuygQi6RBtObtBShNDoOalat5okKPkOeXqKzLI+qIAfeAcad3Gql61oAvNNxp8BgbBQKGx3w0o87QY9sT4GpFSLUq8wSGs7gjCpDWtNHZYOetqiZZ5TYulJBcF5j0/5Ln0TiWTtTScDE76SUkxF3S85JgUPR44F5b+X+PvSqpnWE8y5zLQiAdbFMA0iK4OD6C0KeeTdOmeBUC1DJzJGIwxt+6ba7LVofnYJ7OlTbYZZLHDzLGSKMBYGJu1dT1VxTjti+mqdE4fTG89oPTNqhXFuM/0IpEdmdfks5
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(376002)(346002)(451199015)(36840700001)(46966006)(40470700004)(2906002)(40480700001)(40460700003)(36756003)(2616005)(86362001)(4326008)(336012)(966005)(70206006)(426003)(1076003)(47076005)(5660300002)(83380400001)(41300700001)(26005)(8936002)(44832011)(186003)(6666004)(478600001)(7696005)(7416002)(6916009)(16526019)(8676002)(70586007)(316002)(54906003)(81166007)(356005)(82310400005)(82740400003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:57:10.4915
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 96919ed3-6268-439e-afa0-08daf017d0dc
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010209.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6106
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

amd-psfd : Predictive Store Forwarding Disable:
           PSF is a hardware-based micro-architectural optimization
           designed to improve the performance of code execution by
           predicting address dependencies between loads and stores.
           While SSBD (Speculative Store Bypass Disable) disables both
           PSF and speculative store bypass, PSFD only disables PSF.
           PSFD may be desirable for the software which is concerned
           with the speculative behavior of PSF but desires a smaller
           performance impact than setting SSBD.
	   Depends on the following kernel commit:
           b73a54321ad8 ("KVM: x86: Expose Predictive Store Forwarding Disable")

stibp-always-on :
           Single Thread Indirect Branch Prediction mode has enhanced
           performance and may be left always on.

The documentation for the features are available in the links below.
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,
   Revision B1 Processors
b. SECURITY ANALYSIS OF AMD PREDICTIVE STORE FORWARDING

Link: https://www.amd.com/system/files/documents/security-analysis-predictive-store-forwarding.pdf
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 4 ++--
 target/i386/cpu.h | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2dffd12081..117130fba1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -909,10 +909,10 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
             NULL, NULL, NULL, NULL,
             NULL, "wbnoinvd", NULL, NULL,
             "ibpb", NULL, "ibrs", "amd-stibp",
-            NULL, NULL, NULL, NULL,
+            NULL, "stibp-always-on", NULL, NULL,
             NULL, NULL, NULL, NULL,
             "amd-ssbd", "virt-ssbd", "amd-no-ssb", NULL,
-            NULL, NULL, NULL, NULL,
+            "amd-psfd", NULL, NULL, NULL,
         },
         .cpuid = { .eax = 0x80000008, .reg = R_EBX, },
         .tcg_features = 0,
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index d4bc19577a..8c65c92131 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -918,8 +918,12 @@ uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
 #define CPUID_8000_0008_EBX_IBRS        (1U << 14)
 /* Single Thread Indirect Branch Predictors */
 #define CPUID_8000_0008_EBX_STIBP       (1U << 15)
+/* STIBP mode has enhanced performance and may be left always on */
+#define CPUID_8000_0008_EBX_STIBP_ALWAYS_ON    (1U << 17)
 /* Speculative Store Bypass Disable */
 #define CPUID_8000_0008_EBX_AMD_SSBD    (1U << 24)
+/* Predictive Store Forwarding Disable */
+#define CPUID_8000_0008_EBX_AMD_PSFD    (1U << 28)
 
 #define CPUID_XSAVE_XSAVEOPT   (1U << 0)
 #define CPUID_XSAVE_XSAVEC     (1U << 1)
-- 
2.34.1

