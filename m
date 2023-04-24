Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6513B6ED28B
	for <lists+kvm@lfdr.de>; Mon, 24 Apr 2023 18:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbjDXQem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Apr 2023 12:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232207AbjDXQea (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Apr 2023 12:34:30 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2069.outbound.protection.outlook.com [40.107.220.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FDF271D
        for <kvm@vger.kernel.org>; Mon, 24 Apr 2023 09:34:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bg1cTDN1/O8bffrW3M8KU/p46eLJEAyRsAaR2cmy0itExYcZXGpCGbFn97aDhNC0BPiHFl9tFQX1xJCcHnrOyyFkyTEmjWRyYU8QG5MvMk6gF5X+OpGjc1eFEevh071DflSoXIeN43r1yM6wPuNFurFmBYlc/0E95SMjVKn0sowLLDMyT15M1QbzdVhdg4zC5QtgcwhKxcssJhvCHnBklfVoTK4n30beiNVpJFeeAm5nSv/NkQ30EN0KKwiBtj2sCQGAPFqfPJTLJd91/p3csmEYQ23A3+S96076WrIfPj4Zzf4qVQMhw/kHFShfiq0sLqQG9brnyINKMoEVnxcdQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqsR4ZQEVVGqOdSyAkJvwzSCea5fZ/kfXZURQvTieKM=;
 b=SLfT3c8hqIXqLMNLYNGNtz14ajG5han2Ary7aOsf1yDNIW6R8pULngmJ6/JvNLNqQ3Sa0FpRsegch6Lq4/iOyYQHr0t8fuztOfGETVB5pK+pOR4gODMvhNcfLDA1tsWw45q3GjO0absF1y+eEBKv7ExIVqf96Os4i+o6XiG4ZeJ5jc5nmlA/n7pc396eH6P5RFcIXJQynPpFsVGRx+Bc4gieI3ikfsvBiPNjhOqAXOi9dbxwDSkiCO8oCG3aJhS8g5uI1rTFFqVvH1UKpawT/20vis761xtFmuJQ5n2wkLypDrbAaz2qUHPdu2Uj+CXTPlAQN+9SBRwnfcHy5LTglw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqsR4ZQEVVGqOdSyAkJvwzSCea5fZ/kfXZURQvTieKM=;
 b=kUK7vIgOvpTOAvQk/0z6IIWrxx93tlU5cUagJxrlWKpkky333I+euCd+DgLKSleDUctY9qGKcTwO5iOK+5lQ0kqlGYB1pDdRXJlR2DNEOG62Ka4gXBIRo2/9l+CM5cL3ag34k8esns7pxV4Y9RN9Vr4dvpKTi98pz280htcZUBE=
Received: from DM6PR11CA0070.namprd11.prod.outlook.com (2603:10b6:5:14c::47)
 by SN7PR12MB6957.namprd12.prod.outlook.com (2603:10b6:806:263::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.28; Mon, 24 Apr
 2023 16:34:25 +0000
Received: from DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::70) by DM6PR11CA0070.outlook.office365.com
 (2603:10b6:5:14c::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33 via Frontend
 Transport; Mon, 24 Apr 2023 16:34:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT080.mail.protection.outlook.com (10.13.173.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.19 via Frontend Transport; Mon, 24 Apr 2023 16:34:25 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 24 Apr
 2023 11:34:23 -0500
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
Subject: [PATCH v3 5/7] target/i386: Add missing feature bits in EPYC-Milan model
Date:   Mon, 24 Apr 2023 11:33:59 -0500
Message-ID: <20230424163401.23018-6-babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT080:EE_|SN7PR12MB6957:EE_
X-MS-Office365-Filtering-Correlation-Id: d6d93a77-b3ad-4dae-6757-08db44e1c48b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B5vSVzGP4QPih/13JoofKpx5gBXWXpE61YqeEKPnl6ch9EmKVcyo5/qf9kiSfhgbvtgd3cTAWqyatc1QJyfc1tlUmo3jPurthq7psS/woM/wDMIVOWmI1ppFgp2EvEhH1XLFplRAL1pQrPcGsbKsFAfEEOfdep9EJ2nBgyDVJGMM44ohrKUXx4qDmq01pVuNXsXjx3rg7fk+2K9ljU4oYUr/eE2dcRcrGFH8eTTiHWWDSHbbp2LvbsIPPh8FxTxN1WmheKBTraZts6vQW185GTZ5FgmRyzCCVuVfzSFzk+4lF/ikhEuhxgrV4ppahs78rJPyi0XhR9QOTrAuCHlgymvOEmc7LBbJicqmbVSwLRz4JFP7I1/mre3pUqgyTGtj7DH5VlDW0y+g3PcBjElV7g9WvgBZMu41EIs81kF3vjDNgGyYMDD28yy64Kx1yUraqE08RXxgWw5g6TGYg7SojkWmfZwourrp6sEVmmB/VFuPmPO6VVz97o1pGE9TDUicC2bGJx4JNGp1Jz37FBIVw3eNLdiFMgk3LCxnbz5c+2lxqvH7ol70Rju2DK2B56gBXGgJAg+e4MiNG0mQY9Pmm0YnZsDo7ItqTPDzAlN+xmCERyl8rSi8Co1td2+xf/I6OBVDMQINdwZBhqic6qLoNPiAeJPr8QcvNuDDam3dUOd4lgt1BYLgEy6UQe2KNFJ8wKkU3lt4i3NJbdkZX9g1a1OY6f0BdHcJrP5KcSS/J5JyV7FswQGejMdn0djc/IUafLgQYUIsUJA7cvctY+XQnw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199021)(40470700004)(46966006)(36840700001)(86362001)(44832011)(7416002)(2906002)(5660300002)(316002)(82310400005)(356005)(81166007)(8676002)(8936002)(41300700001)(82740400003)(70206006)(4326008)(70586007)(36756003)(54906003)(36860700001)(110136005)(478600001)(40480700001)(26005)(83380400001)(6666004)(186003)(16526019)(1076003)(47076005)(7696005)(40460700003)(2616005)(336012)(966005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 16:34:25.8076
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6d93a77-b3ad-4dae-6757-08db44e1c48b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6957
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip
Link: https://www.amd.com/system/files/documents/security-analysis-predictive-store-forwarding.pdf
Link: https://www.amd.com/system/files/TechDocs/40332_4.05.pdf
---
 target/i386/cpu.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index d584a9488b..7fcdd33467 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1923,6 +1923,56 @@ static const CPUCaches epyc_milan_cache_info = {
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
@@ -4401,6 +4451,26 @@ static const X86CPUDefinition builtin_x86_defs[] = {
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

