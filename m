Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A04A16606BB
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 19:58:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbjAFS5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 13:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbjAFS5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 13:57:17 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2074.outbound.protection.outlook.com [40.107.237.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEBA78A45
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 10:57:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OUjGlPX5cVvxxkeWd5BZvFCo2OpVTxszsMt4XT2JK8CDC2p6bHgh7DyJW1y3vdVbShoJ8NDEo+ryvtWkiyK1uOQD793CC9ThGOkDLQRUDJnULYgat9Fdbtp7bDM/ZKZiiSusedkBQ4y/5CwTcFQxUIfRaVdDJWASI5g0RXIP+PB2R7t8Em72VtURODnrBEEYAeDLr1FmBWrJ/zOa7IVRiFcmSLb/UMomRh5Gz9wPeWtIU/vMYKwBAFU5eLRJiZGnLKrIiXp3NQcOLcJ9kuD3WVnWyKdEvhhQ0AvLUL7ByIOzbnp+rGWJCUiX8Vfjii6s0BjcQ69Rexqqcj+pIlHUUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=70lMAHVbr0duwXfIU+6M5mZ7yO5m7RpMtV5+D5vMDAE=;
 b=kFMsm/fLV6wGTtVcGfjyKii225TDOBFNu7/tGUkN04yFNx1hRhkfNcu14KMGjk+CR/VVVGSYD9nR07sLYA1kMtkMOaMyw5/s2T3GKAGCcoK5kdNk7LW2XostL22cPMEbI+S6ysv4553OysDWt9F+jpvjkfdx2g14r0gjODsW4OD03LT1utPlEgsK00m3deeTXsgFa5uFbkG6RMVlcIEUdOHYNDpRRpUgVeKGyIL7fjNsV3B7lXWmf17icuMCj6SKz334BbnClNVeDaYA2X3NpapjoKiTLDV851EQucnumG9L0GcZhzC8imXmTmggGo9KtglwQuyMJZ1vqq0TjMW5/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=70lMAHVbr0duwXfIU+6M5mZ7yO5m7RpMtV5+D5vMDAE=;
 b=HmHUigS0ln4psAOO681QIyAW/7HkhzJPzhdwcIMAD2Rl+m/I3GiqrQY7w7kRW+BjC1F8QIaxKhL1LX+hKc3uHjf7tqE3dSg62ASCYYbqiJgxSx7U9tXp6yyfij8cw4QTIATJA2vzk9J8TsXfnmptV5FdjNjmfjZhphyd0UNbkjI=
Received: from MN2PR08CA0025.namprd08.prod.outlook.com (2603:10b6:208:239::30)
 by DS0PR12MB7779.namprd12.prod.outlook.com (2603:10b6:8:150::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 18:57:12 +0000
Received: from BL02EPF00010208.namprd05.prod.outlook.com
 (2603:10b6:208:239:cafe::d9) by MN2PR08CA0025.outlook.office365.com
 (2603:10b6:208:239::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 18:57:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010208.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.15 via Frontend Transport; Fri, 6 Jan 2023 18:57:12 +0000
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
Subject: [PATCH v2 5/5] target/i386: Add missing feature bits in EPYC-Milan model
Date:   Fri, 6 Jan 2023 12:57:00 -0600
Message-ID: <20230106185700.28744-6-babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00010208:EE_|DS0PR12MB7779:EE_
X-MS-Office365-Filtering-Correlation-Id: c7d4d18e-8d8f-494b-9e07-08daf017d21f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pO/I8ig6XcmYzFo4scjaSM5QU/qvtvY1odWrg534ioHDStkJI2PwwUscfPS5e+fH0FvVWRx2HU2SGaWEj8T20y6uEwrmdit8Yg8JfbrY7xChc516fwHyDb9EdKhltTuTS0s4qwDWdPK/nEIcLx0tzgkACXV+mjI+1cNyMQsWMHAPp5Rgd5rflXbL75ubM8KNJ49Fm9YbkdAXqTKtuRtS4Up68Sno3JGPC/HTWFnoZ2TTS4LVbEKPPVMyCMEQ9UHM4M8aJFPy0HOG0mz/UmAMS+e1bUMMUx2WAh6cxLryMd2Fq8Xmeo7i/i55WNSNVsAn+2yeN3eLxVsdtFxkA2R+VwH5stPGzQQssA8eNbOtyVvt4icu4cZOdamqnsqlgFDfseZZ7wD2QfLTuqR3hncA/2XJSWDvtX/7tIZ7NL9Nw+mJE754nhgtaELHIY1B/SRy1ZOGZjKp+q6ZC2P8ZefGpCF2noa9K1OFEFaXA+dRIenF3GQYE9Cw71B49APbZOyT7nGAsxap9cNV41l8DKKmnbgPC+WwIWNG7pHXHYGYHA4sDuTHnQTXeGU/xASAQh2fLbVyg/Esz0vOOvys8T+XLdPCWDQB1ZK0vJHb/lLh20BfRPMmcr84xSkAQ6WtWDf5fbjf3ipi8dj9hD9/770HvIuRts/k0otgxwNk8FfMrmAvQ/f8eyhMQ5HgJBCruzmTv1Ci9GNhd14gmtoT66Rwy6W1gSJZtav+Djgbt5/UwwmRKzJP9Mq4GNx7eU2SH+K/8N6M24a+h7HnsUfxRVnKrUadTv1B+VacmIas7+tTa4kSG/S6nohP2DcaWxYS6Oi+
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199015)(40470700004)(36840700001)(46966006)(16526019)(54906003)(6666004)(6916009)(316002)(26005)(186003)(7696005)(70586007)(1076003)(4326008)(70206006)(336012)(2616005)(8676002)(966005)(478600001)(82740400003)(41300700001)(44832011)(426003)(47076005)(7416002)(8936002)(5660300002)(83380400001)(2906002)(36756003)(36860700001)(356005)(40460700003)(86362001)(40480700001)(81166007)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:57:12.6079
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7d4d18e-8d8f-494b-9e07-08daf017d21f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7779
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And the following feature bits for EPYC-Milan model and bump the version.
vaes            : Vector VAES(ENC|DEC), VAES(ENC|DEC)LAST instruction support
vpclmulqdq	: Vector VPCLMULQDQ instruction support
stibp-always-on : Single Thread Indirect Branch Prediction Mode has enhanced
                  performance and may be left Always on
amd-psfd	: Predictive Store Forward Disable
no-nested-data-bp         : Processor ignores nested data breakpoints
lfence-always-serializing : LFENCE instruction is always serializing
null-sel-clr-base         : Null Selector Clears Base. When this bit is
                            set, a null segment load clears the segment base

These new features will be added in EPYC-Milan-v2. The -cpu help output
after the change.

    x86 EPYC-Milan             (alias configured by machine type)
    x86 EPYC-Milan-v1          AMD EPYC-Milan Processor
    x86 EPYC-Milan-v2          AMD EPYC-Milan Processor

The documentation for the features are available in the links below.
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,
   Revision B1 Processors
b. SECURITY ANALYSIS OF AMD PREDICTIVE STORE FORWARDING
c. AMD64 Architecture Programmer’s Manual Volumes 1–5 Publication No. Revision
    40332 4.05 Date October 2022

Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
Link: https://www.amd.com/system/files/documents/security-analysis-predictive-store-forwarding.pdf
Link: https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 63c4675569..c2bb11b82a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1921,6 +1921,56 @@ static const CPUCaches epyc_milan_cache_info = {
     },
 };
 
+static const CPUCaches epyc_milan_v2_cache_info = {
+    .l1d_cache = &(CPUCacheInfo) {
+        .type = DATA_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l1i_cache = &(CPUCacheInfo) {
+        .type = INSTRUCTION_CACHE,
+        .level = 1,
+        .size = 32 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 64,
+        .lines_per_tag = 1,
+        .self_init = 1,
+        .no_invd_sharing = true,
+    },
+    .l2_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 2,
+        .size = 512 * KiB,
+        .line_size = 64,
+        .associativity = 8,
+        .partitions = 1,
+        .sets = 1024,
+        .lines_per_tag = 1,
+    },
+    .l3_cache = &(CPUCacheInfo) {
+        .type = UNIFIED_CACHE,
+        .level = 3,
+        .size = 32 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 32768,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = false,
+    },
+};
+
 /* The following VMX features are not supported by KVM and are left out in the
  * CPU definitions:
  *
@@ -4270,6 +4320,26 @@ static const X86CPUDefinition builtin_x86_defs[] = {
         .xlevel = 0x8000001E,
         .model_id = "AMD EPYC-Milan Processor",
         .cache_info = &epyc_milan_cache_info,
+        .versions = (X86CPUVersionDefinition[]) {
+            { .version = 1 },
+            {
+                .version = 2,
+                .props = (PropValue[]) {
+                    { "model-id",
+                      "AMD EPYC-Milan-v2 Processor" },
+                    { "vaes", "on" },
+                    { "vpclmulqdq", "on" },
+                    { "stibp-always-on", "on" },
+                    { "amd-psfd", "on" },
+                    { "no-nested-data-bp", "on" },
+                    { "lfence-always-serializing", "on" },
+                    { "null-sel-clr-base", "on" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_milan_v2_cache_info
+            },
+            { /* end of list */ }
+        }
     },
 };
 
-- 
2.34.1

