Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B48EF6ED288
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232200AbjDXQej (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjDXQeY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:34:24 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2082.outbound.protection.outlook.com [40.107.220.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F802D8
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:34:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OpkuO8ZkRjEwa/jTLcOFhu3PwW9jtt6dxC1x1Odx66a3S4kWA7vB5bSpPnZsCcUaTus5Tpfs3AsKKr3oJtq8TvlgAWyQUIXBxhYYfZ7nsaUK//RBOazYJIGHBHQI5QsA3s3ql8NZ3764SgiW+N5RE6UihPm02JSx1WEcHgnMJFp5IrpyK2V96n81qrHqH3ib5jDqjBT/1t6eQCdAlM1CmMEknrHmstgq45dnyF4ivxME3nVglhSfUMIcPmjxkO4IsZTutttWNDDb1urdJzmg0iLOaJpjayfs5fj2xRkEmlEv3/md/th3skSZN08McnTC+kk02Ez+hGeLwtP0KpaG0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qqUhbOTDOsipRhUkT8jAqemJJDaZTCblBrK8bF7E34=;
 b=Fpa8Y5MD9kXn+AlFmM5YGyIQRjQecCoUwCczHBNV98b3IR0iOXGUjt85csUyk5y8aKoaLZA+0v2XCVTAcERerPFYoiOLPBICmipIv5LC+U4SqVpwIHs3Ev/VtRMuleKqCYgW+WD1Y0eK/mdYCXO9d2f24+04+pNg/iyVMFnopFXs8pw9RaLlp3vM7iy+fuQa6VTbtQKiPE+UtdEE18OCM52od7i3ExfgKLryliRwYpGHPtBLeAzyqjsW93RLba4bDc09WeggOKXwhRfeSN1nl75S4oQn9IVmi2lHhZoIRMRiAkdvJZ87/xbg97xI+QBFAznZ9eoZihEb4U3ZuC7yew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7qqUhbOTDOsipRhUkT8jAqemJJDaZTCblBrK8bF7E34=;
 b=aZSTMIo8Sfg8oD9RgBC72TE5Q5Pq+zg+H3TWxkCFxlN1BgoQhuMARmj2rsvNAnHgR3iasc+cPq9R3pem07hffxZI79Z4ltcCYgAK25dVqYLNQDoXIcaNRo3uZKYAmCWYKnK6LD8A3rvubYfMwHXtvb1USePnxRi75ZvWT+WDozc=
Received: from DM6PR03CA0027.namprd03.prod.outlook.com (2603:10b6:5:40::40) by
 CY8PR12MB7564.namprd12.prod.outlook.com (2603:10b6:930:97::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.33; Mon, 24 Apr 2023 16:34:20 +0000
Received: from DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::3c) by DM6PR03CA0027.outlook.office365.com
 (2603:10b6:5:40::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 16:34:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT064.mail.protection.outlook.com (10.13.172.234) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 16:34:19 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 24 Apr
 2023 11:34:18 -0500
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
Subject: [PATCH v3 2/7] target/i386: Add new EPYC CPU versions with updated  cache_info
Date:   Mon, 24 Apr 2023 11:33:56 -0500
Message-ID: <20230424163401.23018-3-babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230424163401.23018-1-babu.moger@amd.com>
References: <20230424163401.23018-1-babu.moger@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT064:EE_|CY8PR12MB7564:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bfd7633-ee3d-46e9-c491-08db44e1c110
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fkg6fyCzJONd04avIZLXJww9A5sPwRvM5KU9nId5mqLJGUkR6O8l1AhFI+KPTiHju1wo+OJyssW8i0UnvMQrDCZeuEcTZHxUqZLrKsNTV8fz1kzVLgl3nYGEJhwiwYoboyhOoOHfkWVc4r2Ug0V3Ms/3R7eZc6bfGOd7MS1i2SLZAjexM81++hfG2F/2JbT5kNtBPXUb/Qu5YSbU+bKVun9bLm2OTOQRcq568Zv+Eo5AttGDngemqHpicbguoBhKcQiBR4Lm0IdMe7XKgo8RSIIjg152l6v6jU9fpECBh3uZ8LJAIBWFkfqe9sdrf1vwhL0GpbhYar73/ssk7Ob3DZYEgfj4i0NV7DCtIMlKdEJw6Y0cPBjr9jty9v9YocOoldNVNyRCB+H0QdfADnEImVCqARjV/KDieDZGtcNNkQLDBGT/FMNnHBcox62n0WrQMrHRe+ewuaSsN/xNFV/FJkDKl+cNCl6MbfhVgY5yUW56ZV3WlGSctlBXBMZXlEn4KkA5AD38RtZElV2B4z7VfM8zi0P5tT7YUSuW0sh6qEnDtXwE0NwhM6FihQQad8UcuKy0Co9EDN69M3hdTSGvqfo2i8/c9kew0CeqegDT6gs5ya6KPAmFzSi/RGqnOp7M188eIlTos9An9lS7n59Zw+7pTzL8hrE2fNloVJIhRobS5rZ9FVN4dqJZlC2Xk5hYM11OvDQ04NV7dsr+ndSzWxEgCycGLHOgymv9k3cCZqE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199021)(36840700001)(46966006)(40470700004)(2906002)(7696005)(15650500001)(2616005)(6666004)(16526019)(1076003)(26005)(186003)(40480700001)(70586007)(70206006)(8676002)(8936002)(316002)(41300700001)(4326008)(478600001)(44832011)(5660300002)(7416002)(54906003)(110136005)(82740400003)(356005)(81166007)(82310400005)(36756003)(86362001)(40460700003)(36860700001)(47076005)(426003)(336012)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:34:19.9707
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bfd7633-ee3d-46e9-c491-08db44e1c110
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7564
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
index e3d9eaa307..c1bc47661d 100644
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

