Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69BB640EB5
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234850AbiLBTrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:47:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiLBTrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:47:23 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95F08F3F9A
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:47:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VDvk6hnO37ctA5Zb6/PqjdREASoxKtecQ4iDqESsmKhrZC92bykaqLrpFlsfuV6VPJWvRJtD3VDprLPHKFF5C4r99Kr+RMk12QujJlQ04j8Q2C2adJoeEnQ4/t1X9i57jng7jJDbgb0wmuoQT727UzxI9mtB3+m8uQeLVhgZ6BETkpGX6s7zUT7qx3a7xgSURmnjhTqYM28xhkmBrg1QZvfqi0QYv42hwW1D/YJU0Y8Fp3dJUpbaufVfspyRCM7X904Oqbakiyq4T2R810znfxTYh9+CwLjx7vCodLGNWjKKH9SnIaKAYKiMsjkeAG/pzbzjE1m9clFf4UcpaZxhmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O31LoqzLfvFT2tyv7MtdI8A4EHqOcGXJc8f7sSCGyxw=;
 b=CXoIrpIv0mYLFEM2Oh75aHiLpOqaZKYwYVXi3lTA8MQhFXWArZ3Rj91lAYqH/OGgT5k6xzJI8s+bVV+qISdryfDwWltM7l48JuIOWLG+X6LGj5uxEHT3+lpT38WdYrshoHAyQvp8nFU10V3xAeBzSiqetxxDERwqk5ZouOTgKiVKvRD3i/keDjW0nRgOUOMzQgN30gzWTOal1g8zNK4Le/mIMMduMh9/E1TNya+2zbzHB78C4aDuHuskRTWW8elPX/tv/np6suop6IIpcnJyKUjBXrntOoB23c7OhKPxZqE9HHUcs5aT6nvOYwSRj3+eZou/015UuD3ERfReacereg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O31LoqzLfvFT2tyv7MtdI8A4EHqOcGXJc8f7sSCGyxw=;
 b=OUC9w7hEywSMGe6zZDp6xCnriihouiZJ/Kz6vJJjJv5n3h1Y3s5k7VPC9ew0yDgARkm4+CUJlNOw8zebeU1GN/xBiJHJMZ7PB+ChQYUAZqDtDbofXCkh3+ONyuzSv73yzwy29TH1+jGF/j9Fy7n5UpZqHI6ECc9PuZxDpqPn9vQ=
Received: from DS7PR05CA0013.namprd05.prod.outlook.com (2603:10b6:5:3b9::18)
 by DM4PR12MB6349.namprd12.prod.outlook.com (2603:10b6:8:a4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Fri, 2 Dec 2022 19:47:20 +0000
Received: from CY4PEPF0000B8EF.namprd05.prod.outlook.com
 (2603:10b6:5:3b9:cafe::4d) by DS7PR05CA0013.outlook.office365.com
 (2603:10b6:5:3b9::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5901.8 via Frontend
 Transport; Fri, 2 Dec 2022 19:47:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EF.mail.protection.outlook.com (10.167.241.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.11 via Frontend Transport; Fri, 2 Dec 2022 19:47:20 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 13:47:18 -0600
Subject: [PATCH 2/5] target/i386: Add new EPYC CPU versions with updated
 cache_info
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <qemu-devel@nongnu.org>, <michael.roth@amd.com>
Date:   Fri, 2 Dec 2022 13:47:18 -0600
Message-ID: <167001043837.62456.11154289019185424380.stgit@bmoger-ubuntu>
In-Reply-To: <167001034454.62456.7111414518087569436.stgit@bmoger-ubuntu>
References: <167001034454.62456.7111414518087569436.stgit@bmoger-ubuntu>
User-Agent: StGit/1.1.dev103+g5369f4c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EF:EE_|DM4PR12MB6349:EE_
X-MS-Office365-Filtering-Correlation-Id: c40f2448-bc2a-48b8-70c1-08dad49e067f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4G+8PJGKLlRrdWDK2B8N/zYTS6XOz2N8k3A+HyT9yZKkW4AHIYZpY05St+d+E9NprP5mKe1SM+/OQ6yJ2u1rvDy0gOD6rj6J+jQ+FkRb/IHjMCG+lzA2leupnRcCdJJvBJMbw3kEo1um3m4+1X4CloTtwklOylb6ZX84SFQIoNcTeGNTdi+DaKOr15O6nSowFdBARyRkbfZHPXZG4gOZPNotiCguoR0WTiAp6v+KAza+kuLoRVV5fmGU4EUnM+6OQMKUhlAOSP3/9q0P9iZapT4+BN8LgRoarMfLK8fLJKj6CQ0GaIdNDkUJevuaAimu8VGg+/OyQBKhai6rF/nwymKQ63Y6PHQRLhbrebFx+Q8pNECfANLA1/5/0ORmEZ36gjE18QEAs13X9hoKj4lPwKI6uYAaRH2Kg35+g6n09CyY9fiUm1xf+buoWkDQF/6sIKOKitNlk3YyNQ1nMWt1Dlpjp7cktbBaP7GZMxxXDQ2pypDxYC8pIVC4RkJZzbadZRCfacdSdG9F3Rr1VvKixBpCvIF4HAAlfO3qX19JW8FsaMOAbcYy/EuMgstilamhl27wBLfOC/xZJi312WjOa+zIxogK+vPreBN5vEweDG884ZKwepq9sSdimAgYhCaHosqNZVPhVGaZozU4FMPFNyEaDrixmU06kMCQwnMaHJnqIqyoh269MIZV1w++VLeeM2r0fq+o3zNdakYa/IZSKOcq6tX4IQEvD33EZrblO36LdgbAD9PXXypcu67SG4vQ
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(7916004)(346002)(39860400002)(136003)(376002)(396003)(451199015)(40470700004)(46966006)(36840700001)(8936002)(4326008)(8676002)(86362001)(40460700003)(15650500001)(2906002)(70206006)(82740400003)(7416002)(5660300002)(82310400005)(103116003)(186003)(47076005)(36860700001)(336012)(16526019)(70586007)(426003)(33716001)(356005)(16576012)(83380400001)(6916009)(316002)(81166007)(54906003)(26005)(478600001)(40480700001)(41300700001)(9686003)(44832011)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 19:47:20.4189
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c40f2448-bc2a-48b8-70c1-08dad49e067f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EF.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6349
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>=0A=
=0A=
Introduce new EPYC cpu versions: EPYC-v4 and EPYC-Rome-v3.=0A=
The only difference vs. older models is an updated cache_info with=0A=
the 'complex_indexing' bit unset, since this bit is not currently=0A=
defined for AMD and may cause problems should it be used for=0A=
something else in the future. Setting this bit will also cause=0A=
CPUID validation failures when running SEV-SNP guests.=0A=
=0A=
Signed-off-by: Michael Roth <michael.roth@amd.com>=0A=
Signed-off-by: Babu Moger <babu.moger@amd.com>=0A=
---=0A=
 target/i386/cpu.c |  118 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++=0A=
 1 file changed, 118 insertions(+)=0A=
=0A=
diff --git a/target/i386/cpu.c b/target/i386/cpu.c=0A=
index b0f1d4618e..81918e10ba 100644=0A=
--- a/target/i386/cpu.c=0A=
+++ b/target/i386/cpu.c=0A=
@@ -1705,6 +1705,56 @@ static const CPUCaches epyc_cache_info =3D {=0A=
     },=0A=
 };=0A=
 =0A=
+static CPUCaches epyc_v4_cache_info =3D {=0A=
+    .l1d_cache =3D &(CPUCacheInfo) {=0A=
+        .type =3D DATA_CACHE,=0A=
+        .level =3D 1,=0A=
+        .size =3D 32 * KiB,=0A=
+        .line_size =3D 64,=0A=
+        .associativity =3D 8,=0A=
+        .partitions =3D 1,=0A=
+        .sets =3D 64,=0A=
+        .lines_per_tag =3D 1,=0A=
+        .self_init =3D 1,=0A=
+        .no_invd_sharing =3D true,=0A=
+    },=0A=
+    .l1i_cache =3D &(CPUCacheInfo) {=0A=
+        .type =3D INSTRUCTION_CACHE,=0A=
+        .level =3D 1,=0A=
+        .size =3D 64 * KiB,=0A=
+        .line_size =3D 64,=0A=
+        .associativity =3D 4,=0A=
+        .partitions =3D 1,=0A=
+        .sets =3D 256,=0A=
+        .lines_per_tag =3D 1,=0A=
+        .self_init =3D 1,=0A=
+        .no_invd_sharing =3D true,=0A=
+    },=0A=
+    .l2_cache =3D &(CPUCacheInfo) {=0A=
+        .type =3D UNIFIED_CACHE,=0A=
+        .level =3D 2,=0A=
+        .size =3D 512 * KiB,=0A=
+        .line_size =3D 64,=0A=
+        .associativity =3D 8,=0A=
+        .partitions =3D 1,=0A=
+        .sets =3D 1024,=0A=
+        .lines_per_tag =3D 1,=0A=
+    },=0A=
+    .l3_cache =3D &(CPUCacheInfo) {=0A=
+        .type =3D UNIFIED_CACHE,=0A=
+        .level =3D 3,=0A=
+        .size =3D 8 * MiB,=0A=
+        .line_size =3D 64,=0A=
+        .associativity =3D 16,=0A=
+        .partitions =3D 1,=0A=
+        .sets =3D 8192,=0A=
+        .lines_per_tag =3D 1,=0A=
+        .self_init =3D true,=0A=
+        .inclusive =3D true,=0A=
+        .complex_indexing =3D false,=0A=
+    },=0A=
+};=0A=
+=0A=
 static const CPUCaches epyc_rome_cache_info =3D {=0A=
     .l1d_cache =3D &(CPUCacheInfo) {=0A=
         .type =3D DATA_CACHE,=0A=
@@ -1755,6 +1805,56 @@ static const CPUCaches epyc_rome_cache_info =3D {=0A=
     },=0A=
 };=0A=
 =0A=
+static const CPUCaches epyc_rome_v3_cache_info =3D {=0A=
+    .l1d_cache =3D &(CPUCacheInfo) {=0A=
+        .type =3D DATA_CACHE,=0A=
+        .level =3D 1,=0A=
+        .size =3D 32 * KiB,=0A=
+        .line_size =3D 64,=0A=
+        .associativity =3D 8,=0A=
+        .partitions =3D 1,=0A=
+        .sets =3D 64,=0A=
+        .lines_per_tag =3D 1,=0A=
+        .self_init =3D 1,=0A=
+        .no_invd_sharing =3D true,=0A=
+    },=0A=
+    .l1i_cache =3D &(CPUCacheInfo) {=0A=
+        .type =3D INSTRUCTION_CACHE,=0A=
+        .level =3D 1,=0A=
+        .size =3D 32 * KiB,=0A=
+        .line_size =3D 64,=0A=
+        .associativity =3D 8,=0A=
+        .partitions =3D 1,=0A=
+        .sets =3D 64,=0A=
+        .lines_per_tag =3D 1,=0A=
+        .self_init =3D 1,=0A=
+        .no_invd_sharing =3D true,=0A=
+    },=0A=
+    .l2_cache =3D &(CPUCacheInfo) {=0A=
+        .type =3D UNIFIED_CACHE,=0A=
+        .level =3D 2,=0A=
+        .size =3D 512 * KiB,=0A=
+        .line_size =3D 64,=0A=
+        .associativity =3D 8,=0A=
+        .partitions =3D 1,=0A=
+        .sets =3D 1024,=0A=
+        .lines_per_tag =3D 1,=0A=
+    },=0A=
+    .l3_cache =3D &(CPUCacheInfo) {=0A=
+        .type =3D UNIFIED_CACHE,=0A=
+        .level =3D 3,=0A=
+        .size =3D 16 * MiB,=0A=
+        .line_size =3D 64,=0A=
+        .associativity =3D 16,=0A=
+        .partitions =3D 1,=0A=
+        .sets =3D 16384,=0A=
+        .lines_per_tag =3D 1,=0A=
+        .self_init =3D true,=0A=
+        .inclusive =3D true,=0A=
+        .complex_indexing =3D false,=0A=
+    },=0A=
+};=0A=
+=0A=
 static const CPUCaches epyc_milan_cache_info =3D {=0A=
     .l1d_cache =3D &(CPUCacheInfo) {=0A=
         .type =3D DATA_CACHE,=0A=
@@ -3960,6 +4060,15 @@ static const X86CPUDefinition builtin_x86_defs[] =3D=
 {=0A=
                     { /* end of list */ }=0A=
                 }=0A=
             },=0A=
+            {=0A=
+                .version =3D 4,=0A=
+                .props =3D (PropValue[]) {=0A=
+                    { "model-id",=0A=
+                      "AMD EPYC-v4 Processor" },=0A=
+                    { /* end of list */ }=0A=
+                },=0A=
+                .cache_info =3D &epyc_v4_cache_info=0A=
+            },=0A=
             { /* end of list */ }=0A=
         }=0A=
     },=0A=
@@ -4079,6 +4188,15 @@ static const X86CPUDefinition builtin_x86_defs[] =3D=
 {=0A=
                     { /* end of list */ }=0A=
                 }=0A=
             },=0A=
+            {=0A=
+                .version =3D 3,=0A=
+                .props =3D (PropValue[]) {=0A=
+                    { "model-id",=0A=
+                      "AMD EPYC-Rome-v3 Processor" },=0A=
+                    { /* end of list */ }=0A=
+                },=0A=
+                .cache_info =3D &epyc_rome_v3_cache_info=0A=
+            },=0A=
             { /* end of list */ }=0A=
         }=0A=
     },=0A=
=0A=

