Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F11006606B9
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235873AbjAFS5f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 13:57:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235947AbjAFS5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 13:57:13 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6507C7DE38
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 10:57:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VT1wGvnuk+SIbtbeoPjVpMQppgMtzfeyIfWFo4IQroKlui+2DXm24p8sggX+vs/N0p1lmfpfSKSCpqN6MhQYDOQVxr8JYM4mnkUe288jIWY1523x12DloReL4P4DQHgQ5o3UFi6a+EMaN7ZSkFa8WXWeGWlhdGO02E6MI5SRqV0SH+lBlhoQVojma8FhjhnWcuL6mFgLhGCP+Uy/fYuBnAVQlZfmtFVjfL4KvGQyz/BsiGgqMu2tQPBqFKn9wvrIqDJa79PpwQth2hp24EP2dGz/OLhN2vwBhbSYGM6mHswwVgI0jUdQ5orVye53Qf0/UzERdEPr3e7duW04kGn60g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3yaRK8we4lg/TWohnvK5tbBrCA+FSO/4p/X35E0J6+Y=;
 b=jRnY8O9pHoHNJlakXrUIXCsqOBUfa4+/hc0M1caxks052m8YjHRnThoND/rlWcdvMtCe+BevATHwqJKfPM2baYpx8NawjPQm1McXEXQQFfnVtRYMC6A3D5kZJaPtLzcjfCwKU016L1shTPOZRZTf/AUcM11xVdDJZ15XnlKZFcLsttJ+18ZDr4fGIbkRouR+wK2AVE4PjTN6UcdRzeYL7U5W2pzBLGLrHnHTAiiol3//4YD7Pfto5RaExcHHNYe0Rqw0oJePySBtemMt1b0502LfMIMwomsSJIJhSgu3dSuJHJX8RcRMhPKfXcB4JTJj77DUZ7PTDi13zhT6qTSSBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3yaRK8we4lg/TWohnvK5tbBrCA+FSO/4p/X35E0J6+Y=;
 b=xZk/y78OyOKTVoyWAimW7VhqVb3wOPzkBGUmS06JQOwe34arnd/rmxv1B0JjKwipig24aq+oHCvdzA8QhB/Hc8iu2o++bOaS4gSCRnbpXV/WK0rmpH8HuN3Vgra9DBFJbQfrxNSQXyeKxwl5z6LDiA6NBbRLH+lmInjgd+5lc+w=
Received: from MN2PR08CA0014.namprd08.prod.outlook.com (2603:10b6:208:239::19)
 by BN9PR12MB5147.namprd12.prod.outlook.com (2603:10b6:408:118::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 18:57:09 +0000
Received: from BL02EPF00010208.namprd05.prod.outlook.com
 (2603:10b6:208:239:cafe::f1) by MN2PR08CA0014.outlook.office365.com
 (2603:10b6:208:239::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 18:57:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010208.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.15 via Frontend Transport; Fri, 6 Jan 2023 18:57:09 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 6 Jan
 2023 12:57:08 -0600
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>
Subject: [PATCH v2 2/5] target/i386: Add new EPYC CPU versions with updated cache_info
Date:   Fri, 6 Jan 2023 12:56:57 -0600
Message-ID: <20230106185700.28744-3-babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00010208:EE_|BN9PR12MB5147:EE_
X-MS-Office365-Filtering-Correlation-Id: 654b8dcb-c9c6-43cb-b0ed-08daf017d06d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nKpw1B6wfCGNgTn5X/mMFHlnT/ZeoI4kSz2QJXexIHocS3s/SBaKwt+9o4GX9wfgx5ZlZhK9mBrwehS6bknoB17QB36il8OB60swe9m0FLZi9NUOA7bo4uqyfqbpHh+o5Sh9t4hILZZo8//vhXUpYHWzuFeXxw9ZVnNGOpYe9MoBrexFAHoKof9RXf7oiyGsUsa/wCqpTIeGbTU44FUX23U12p2PtyrYQIbLRb95XFXbb+d6WVgmawNy36D2DKv33CutlQ9QzdLtys9NtRsrFh609n8z9yoUoPIWbs4zbqWbVFI6bazCgRfx1fbliwp6gYPTzqGbNdrWz+fVbszs/C2MrjsMgYvVGu2qglZqeErmDvxQAhBjleQzTeve2E6mJowXXVrEoODdtgY3qP4pdTeg7VUgR0iiC9enxMauT1iGRMUdSEm3KCUTwBlBTUvBe3Jo7OhsHHqjfu8KkGL0Aohk7XlOdbuwk6L5OWih+c1CWn4wilYhr82SIq1ugrdrcerYDNAj4GW/VJW1BRF5yEXGi9xJxvJ920Me49YyXLb19mHJyVP5K81A7V8u6XHBNGoDLhAkX18szuy+ZpZMsw1nakuZxgs/s+mjvYYbYY4gACTCICy3EsKE+g2JXvKHaBu8HKXf1Cz84IzQ7/yaQvxEKLsiMuZkiPRu76DpWo42p5VpdnWl3t+u3gjIGO8gkR0WMDFWgEWL6Q63VyoAsPgJqDfCORUGpiIyQI41tlc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(83380400001)(36860700001)(82740400003)(70206006)(8676002)(15650500001)(81166007)(4326008)(7416002)(6916009)(70586007)(2906002)(2616005)(82310400005)(41300700001)(47076005)(186003)(26005)(40480700001)(16526019)(7696005)(6666004)(1076003)(426003)(8936002)(86362001)(40460700003)(54906003)(336012)(316002)(478600001)(356005)(44832011)(5660300002)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:57:09.7485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 654b8dcb-c9c6-43cb-b0ed-08daf017d06d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5147
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

Introduce new EPYC cpu versions: EPYC-v4 and EPYC-Rome-v3.
The only difference vs. older models is an updated cache_info with
the 'complex_indexing' bit unset, since this bit is not currently
defined for AMD and may cause problems should it be used for
something else in the future. Setting this bit will also cause
CPUID validation failures when running SEV-SNP guests.

Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index ab1b49f08f..2dffd12081 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1705,6 +1705,56 @@ static const CPUCaches epyc_cache_info = {
     },
 };
 
+static CPUCaches epyc_v4_cache_info = {
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
+        .size = 64 * KiB,
+        .line_size = 64,
+        .associativity = 4,
+        .partitions = 1,
+        .sets = 256,
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
+        .size = 8 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 8192,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = false,
+    },
+};
+
 static const CPUCaches epyc_rome_cache_info = {
     .l1d_cache = &(CPUCacheInfo) {
         .type = DATA_CACHE,
@@ -1755,6 +1805,56 @@ static const CPUCaches epyc_rome_cache_info = {
     },
 };
 
+static const CPUCaches epyc_rome_v3_cache_info = {
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
+        .size = 16 * MiB,
+        .line_size = 64,
+        .associativity = 16,
+        .partitions = 1,
+        .sets = 16384,
+        .lines_per_tag = 1,
+        .self_init = true,
+        .inclusive = true,
+        .complex_indexing = false,
+    },
+};
+
 static const CPUCaches epyc_milan_cache_info = {
     .l1d_cache = &(CPUCacheInfo) {
         .type = DATA_CACHE,
@@ -3960,6 +4060,15 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ }
                 }
             },
+            {
+                .version = 4,
+                .props = (PropValue[]) {
+                    { "model-id",
+                      "AMD EPYC-v4 Processor" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_v4_cache_info
+            },
             { /* end of list */ }
         }
     },
@@ -4079,6 +4188,15 @@ static const X86CPUDefinition builtin_x86_defs[] = {
                     { /* end of list */ }
                 }
             },
+            {
+                .version = 3,
+                .props = (PropValue[]) {
+                    { "model-id",
+                      "AMD EPYC-Rome-v3 Processor" },
+                    { /* end of list */ }
+                },
+                .cache_info = &epyc_rome_v3_cache_info
+            },
             { /* end of list */ }
         }
     },
-- 
2.34.1

