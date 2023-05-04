Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFF16F7781
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbjEDUyb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjEDUy3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:54:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A77F11DA2
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:54:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jw7duSI1ksf2PS8CvH7lXPwmhKFUd5oT2WuKm42XHF9YQ6c0WcZTLG7kuKMQcWGY3n64oOq3XqM1y3BaR+RqWp2PxXpN89F/zMH3+8HM8VE/rs9WHQ/cc3o5dnwK1no36/AFVuFTcbbTJI6Iw4mpxNcYdSa94S2C7JprTTzQHZhp7OxPopFNNYa4FNCK6hgE3rnyJD0DuSrz7huMI67fzQFcipfbS8N0kfNyM/BfIxjIRSpK8YaOtiPjKKhEEi0F38VwZ7JF1JxNvORribpZwS3KbxkBBc+BW2ix3UltUmTi14Dq0DX9ULOELymBGXETdH9vFR9JtKQ1UHQiwkdjtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVKaQfSRr/cnJ8adibRf57IBypTIAIUZWNHemCMo5Qs=;
 b=aCNW0CeDdqlBbHrCgKbL90+Phjm5MkJyggK9YskHYb5QtDZqwGuNRIwWrB+SEUV68EDFd2HZ9+bpf91hGXSYUPF4b6LGexM971p3GRO/6oTgOPzdeQvtYg5Fwsut4ldUFu/DAY4n82TnrPJDJkHba0uF7IPnUH17K8NX314NBDxWr0aoadFJYkRuin4LPeE2Ss4rR7t3uzVVWOXEF1WVNgrQ8pauKAr+RZkmeB2qvco/J6GLu7XuL4Nxvp4TL3M5j7/jjN+O/i9lYiqUO2KZUEVhWLw9XsJCuKS/zmzq3JkdMLxJjhlH7IGCbMo/pY94ILF41SObhaVJt+EOPPwf6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVKaQfSRr/cnJ8adibRf57IBypTIAIUZWNHemCMo5Qs=;
 b=lJhoJW1QTNykjnX75orUl8i2mm45+ViBYMiQf2NglSLvMPCRQd8XBfeBZIf9lkUZyBGivKHgBrc+nfxhm3R6MyLfE0YNo80Tu1WTxFDz148RqfDVfHpPNNTRI8mrRL/LjL/JcadzRTCy9oorV8ksjzQ37cPRtpsn9ZAnqwlrpQ8=
Received: from MW4P222CA0028.NAMP222.PROD.OUTLOOK.COM (2603:10b6:303:114::33)
 by BL1PR12MB5729.namprd12.prod.outlook.com (2603:10b6:208:384::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22; Thu, 4 May
 2023 20:53:29 +0000
Received: from CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:114:cafe::22) by MW4P222CA0028.outlook.office365.com
 (2603:10b6:303:114::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 20:53:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT098.mail.protection.outlook.com (10.13.174.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.26 via Frontend Transport; Thu, 4 May 2023 20:53:28 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 4 May
 2023 15:53:24 -0500
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
Subject: [PATCH v4 2/7] target/i386: Add new EPYC CPU versions with updated  cache_info
Date:   Thu, 4 May 2023 15:53:07 -0500
Message-ID: <20230504205313.225073-3-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230504205313.225073-1-babu.moger@amd.com>
References: <20230504205313.225073-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT098:EE_|BL1PR12MB5729:EE_
X-MS-Office365-Filtering-Correlation-Id: 15a7d20b-f5b3-42c3-de76-08db4ce19d15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zWT4KbQiojcR2l+Sl1w/EHfb3r4u6qoorZRQPWZDJxUeawx8OndMHKN6+AGCUoUZyHzvCRq++P/MIX0ccAbfbewl/5Mw8EuBrFSqW9OBBkzAT4u0/CZiMFhqN/6dYHqGb5y3opw8Xb8VFwj4R5XR9/TVUd0JsGjpBaf2zGPnKigSi5OXYyqSJXGmaWe10OPL+I0SF9BFHZR/6FEvUMZBTrPpNBr68Iq/D+e4hCFUCwVBzXmuPE4CUEsWv3q5f4lPIqoGeEgsaA6jhCMVnMfS5A/cu1v2/QqkLDgKHcCeWflcGAkXpqDSrFMKm2cRJrVVYu2h7Nw9azWD83lt7G/cD2Cxn6RGGzI2syIuteia+WfNDN65oEVGl/scri1Th42odVsviaVVQFO4HP6SLoQGs600vtY+fTrBXWaLhjjPg36tGc0KQtBDcC+ZQwQ0QtYR2wbdBZguZFreV5oI8nFkHcRzl1ZCd5Y1aPDolULjbC5+4QghD9kTmlQ4kjCGKfGvx3FXzYBykzS3gJJfIjm953UhqJXPtMNgUvjevu0g0vq0nh4ANmGhtvg9Is4k7uUfcDtUYTFer+9pOjsk0qc0jVbmCzsfGeg83mSDYiEUO1gI5UmUnekgxQvUJsvrZbAmES8TC/kD/XgZ3Bq/uO7UuKkFnV+51WIkkjy7sm5WWmX1SVdjf+wnMrtuZsD8wKAhAnh+xqCCOxn8NVvyOCFIFQ1REvnCGxv9piBLpN22Nhs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199021)(40470700004)(46966006)(36840700001)(8676002)(8936002)(36860700001)(40480700001)(36756003)(356005)(41300700001)(82310400005)(82740400003)(6666004)(70206006)(81166007)(70586007)(4326008)(316002)(86362001)(478600001)(110136005)(54906003)(40460700003)(7696005)(2906002)(2616005)(5660300002)(336012)(15650500001)(426003)(1076003)(16526019)(26005)(186003)(7416002)(47076005)(83380400001)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:53:28.7522
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15a7d20b-f5b3-42c3-de76-08db4ce19d15
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT098.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5729
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 target/i386/cpu.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6e5d2779c9..6c20ce86d1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1707,6 +1707,56 @@ static const CPUCaches epyc_cache_info = {
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
@@ -1757,6 +1807,56 @@ static const CPUCaches epyc_rome_cache_info = {
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
@@ -4091,6 +4191,15 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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
@@ -4210,6 +4319,15 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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

