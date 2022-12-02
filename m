Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EAE1640EB8
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiLBTru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234864AbiLBTrp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:47:45 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2048.outbound.protection.outlook.com [40.107.212.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BD01B1CA
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:47:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VWtsMTL+kRctq0cmY134vYtk38dT8Qg0RJz23v2Tm47+TYKcTXesbPNOvRy3GmLwRA94puU/4iXCfkT0YKfQFRMHi7cOiS+z3YR84HmhX449QEgSNhR/RyE4CNR34qpgIRxm2reYvad5j+ucC2PAZ92T3L6XneNwIow0TKy4LZNhTBN4t1cxORMekNmRNXpK83t/fhNIMb8ACJn7K3WuI7p8/Xercw4UJZZxe2ERIN8JoTkYSWaMNVFrMLpOPPFvVVHPTvGHF6d8B9QKo87G2sbMeeEhDyKB2Z9qASph2hG+6RMJhdhhlTEi/G+LOu2nxECgiXdKg3MEoO249RNAww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qMazTAYRqbSTnaRIEEhec7Xbfh7ocx1Pe/rEqwsYOd8=;
 b=UajD9LroYw0absX6TxTSmw2aJkxl/AZKXfDbKu0rL12Mnqhrb42LzyWxJVv1VrXJdND0Dx+BK38mReomRAJGcNot4JcpQrlb/P67FZObTN3HzjVVHzFnV1RBMsQhQA5femYfAiBolUA8BBYPifkHP+q1z+SQNjRLR6pZxLjZFEsW9u8cFwGZU6AkkYewhgCtnr8w21m1jucOWQoY3EcW2pHfRTXzjVsm/SKBKz0mAl/s4kMhJD4w2FJOdcdYkQc1wfzyuc3GOOwx4t1hevNi0RWNWohQscLPoWsYfc9BU7JMrQ+l/8rToqVnTiluE5Tq3WwfdnuDnjFPCuiyapAKlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qMazTAYRqbSTnaRIEEhec7Xbfh7ocx1Pe/rEqwsYOd8=;
 b=P3UZ8sNuyUfBYwAJweprd2gMVELporC/b3XI4gWS6s2iuDMzhU5odNAIAiVPuMRWkry2BaX513iROCsyGZmpNUY6LDMuEFpn3Dwzt3kwhk+bvOr5k1zuG+/FoAcQoBGaJbHaR9c/6uX7RHirLp9nupzjnF0sH0nc/JvloW5Km1g=
Received: from DS7PR07CA0010.namprd07.prod.outlook.com (2603:10b6:5:3af::29)
 by IA1PR12MB7494.namprd12.prod.outlook.com (2603:10b6:208:41a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 19:47:39 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:5:3af:cafe::46) by DS7PR07CA0010.outlook.office365.com
 (2603:10b6:5:3af::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 19:47:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.11 via Frontend Transport; Fri, 2 Dec 2022 19:47:39 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 13:47:37 -0600
Subject: [PATCH 5/5] target/i386: Add missing feature bits in EPYC-Milan model
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <qemu-devel@nongnu.org>, <michael.roth@amd.com>
Date:   Fri, 2 Dec 2022 13:47:37 -0600
Message-ID: <167001045745.62456.2099841557167523615.stgit@bmoger-ubuntu>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|IA1PR12MB7494:EE_
X-MS-Office365-Filtering-Correlation-Id: 207d70a1-902f-4f7a-5cfe-08dad49e11ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jxmSUBKx5i8x2BeA5ES0ygkqPyQ1Vek0NK3azru3KqusjijTC6hvrdp39obIuGOIEjhvGEUDFebXFk+567zO4FmLzba6NYF6lvSAH7NIZfHXOvt84Xa2ZbfK6S6UJ+WlSt+K6sd5uWzOZ9Q5XTwy6fRYxa9WR89FwEIaSSWk2orZTJ0/LbAQ7krUTss0yde0N2K6IkndNqvCEo41MSF+u3gvEYAwnWulfFcQrzGnV7J92MK88TTBB/adectB9FuJJv5jS9ZPlKss6tR+f7T1Rhy/nWaUpVtQ/e7bW1aAjAQUv9GuadeMqIa0xu3oX8+aeMBlB2zKJpp3VvLCZTZ1oijONPxCAYqC+QKrXGk0xe4YQoyarx0tKCnXGTrJIT6GSPjPSNAgZmvZV48QjxIpFqvHFx980xdTHhiF1kQxe4uC849YH6c7ei8k5uTZCvZFPrwRfjq/1nNxwq/zUsHDjDzFNCYXL8t6Ny2AY5Yy5tDPFmKajGB92UHQ486SqZYFdy/i9fs3MulH3s7OMZO8pxDCj+WyW+93KaZfj9Qks5OTicRLfN3e8HDVcmqH3AUaxVfBvOEfSSkjcApKzhB+kIQQqc57uqlPSeea0pYbOK3/sR6NCJ3I+1JMGJr6Bwpa3GMrIW/5aRA8YpC+LazCejh/OEAUATsAJ7DZFyzBQ5uctBSLJrkZY+K+0jJ4MAka0o62D7xs6UL5sbyUX2M/aHsK0xrwsNL3o/w+0l1pCXqxK7Bn4EDi+VXng56Ynzcw9oBo0wAwPkQBICbJNWtKCzY1NGBScYYQf9FuJHiMchcHWhNddMnCFVE5EO6xqfZKzoOhlHg/9+4fjbaD68RmJw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(7916004)(39860400002)(136003)(346002)(376002)(396003)(451199015)(36840700001)(40470700004)(46966006)(40480700001)(40460700003)(186003)(2906002)(86362001)(356005)(7416002)(16526019)(478600001)(966005)(81166007)(36860700001)(8936002)(44832011)(26005)(316002)(70586007)(5660300002)(33716001)(41300700001)(6916009)(4326008)(70206006)(16576012)(54906003)(8676002)(82740400003)(9686003)(336012)(103116003)(82310400005)(83380400001)(47076005)(426003)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 19:47:39.3648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 207d70a1-902f-4f7a-5cfe-08dad49e11ca
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7494
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

And the following feature bits for EPYC-Milan model and bump the version.=
=0A=
vaes            : Vector VAES(ENC|DEC), VAES(ENC|DEC)LAST instruction suppo=
rt=0A=
vpclmulqdq	: Vector VPCLMULQDQ instruction support=0A=
stibp-always-on : Single Thread Indirect Branch Prediction Mode has enhance=
d=0A=
                  performance and may be left Always on=0A=
amd-psfd	: Predictive Store Forward Disable=0A=
no-nested-data-bp         : Processor ignores nested data breakpoints=0A=
lfence-always-serializing : LFENCE instruction is always serializing=0A=
null-select-clears-base   : Null Selector Clears Base. When this bit is=0A=
                            set, a null segment load clears the segment bas=
e=0A=
=0A=
These new features will be added in EPYC-Milan-v2. The -cpu help output=0A=
after the change.=0A=
=0A=
    x86 EPYC-Milan             (alias configured by machine type)=0A=
    x86 EPYC-Milan-v1          AMD EPYC-Milan Processor=0A=
    x86 EPYC-Milan-v2          AMD EPYC-Milan Processor=0A=
=0A=
The documentation for the features are available in the links below.=0A=
a. Processor Programming Reference (PPR) for AMD Family 19h Model 01h,=0A=
   Revision B1 Processors=0A=
b. SECURITY ANALYSIS OF AMD PREDICTIVE STORE FORWARDING=0A=
c. AMD64 Architecture Programmer=E2=80=99s Manual Volumes 1=E2=80=935 Publi=
cation No. Revision=0A=
    40332 4.05 Date October 2022=0A=
=0A=
Link: https://www.amd.com/system/files/TechDocs/55898_B1_pub_0.50.zip=0A=
Link: https://www.amd.com/system/files/documents/security-analysis-predicti=
ve-store-forwarding.pdf=0A=
Link: https://www.amd.com/system/files/TechDocs/40332_4.05.pdf=0A=
Signed-off-by: Babu Moger <Babu.Moger@amd.com>=0A=
---=0A=
 target/i386/cpu.c |   70 +++++++++++++++++++++++++++++++++++++++++++++++++=
++++=0A=
 1 file changed, 70 insertions(+)=0A=
=0A=
diff --git a/target/i386/cpu.c b/target/i386/cpu.c=0A=
index e9175da92f..54549a5127 100644=0A=
--- a/target/i386/cpu.c=0A=
+++ b/target/i386/cpu.c=0A=
@@ -1921,6 +1921,56 @@ static const CPUCaches epyc_milan_cache_info =3D {=
=0A=
     },=0A=
 };=0A=
 =0A=
+static const CPUCaches epyc_milan_v2_cache_info =3D {=0A=
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
+        .size =3D 32 * MiB,=0A=
+        .line_size =3D 64,=0A=
+        .associativity =3D 16,=0A=
+        .partitions =3D 1,=0A=
+        .sets =3D 32768,=0A=
+        .lines_per_tag =3D 1,=0A=
+        .self_init =3D true,=0A=
+        .inclusive =3D true,=0A=
+        .complex_indexing =3D false,=0A=
+    },=0A=
+};=0A=
+=0A=
 /* The following VMX features are not supported by KVM and are left out in=
 the=0A=
  * CPU definitions:=0A=
  *=0A=
@@ -4270,6 +4320,26 @@ static const X86CPUDefinition builtin_x86_defs[] =3D=
 {=0A=
         .xlevel =3D 0x8000001E,=0A=
         .model_id =3D "AMD EPYC-Milan Processor",=0A=
         .cache_info =3D &epyc_milan_cache_info,=0A=
+        .versions =3D (X86CPUVersionDefinition[]) {=0A=
+            { .version =3D 1 },=0A=
+            {=0A=
+                .version =3D 2,=0A=
+                .props =3D (PropValue[]) {=0A=
+                    { "model-id",=0A=
+                      "AMD EPYC-Milan-v2 Processor" },=0A=
+                    { "vaes", "on" },=0A=
+                    { "vpclmulqdq", "on" },=0A=
+                    { "stibp-always-on", "on" },=0A=
+                    { "amd-psfd", "on" },=0A=
+                    { "no-nested-data-bp", "on" },=0A=
+                    { "lfence-always-serializing", "on" },=0A=
+                    { "null-select-clears-base", "on" },=0A=
+                    { /* end of list */ }=0A=
+                },=0A=
+                .cache_info =3D &epyc_milan_v2_cache_info=0A=
+            },=0A=
+            { /* end of list */ }=0A=
+        }=0A=
     },=0A=
 };=0A=
 =0A=
=0A=

