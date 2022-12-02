Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77038640EB4
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiLBTrT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:47:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiLBTrS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:47:18 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2053.outbound.protection.outlook.com [40.107.96.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CD8F3FAA
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:47:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bLjyPNhA40BoKLpucglLCnNssMQBGKv2TMgVQqaiXvQa5OXWG6sIC+qSrmFrxNhJMvo9qL9YltaiePaxrhLcZJkzwE9XKTEQ3yVterfV4EvV5PEE2KvjmEJ1vAkP1Q+K4o9846WOQgeL83Kf59eMiw4j7w0dRJ1xuaapN6quHxCun8xeELHuX7txtx6wndtdlmFQMwX95vIDAYUoLLI92ivoorMMEEsMGCBGMLR9E3tDmqbvumXVbLlhZbinvcgV0NY3nuuMzD7JDVlHpLdpQkkOzXoVNWtkoibFMqogtZ+07VAtWrfiOn4yJdG5qB4BJFSoERbimekfgpVn7MD9Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uWfDBlZvYp0pAL7ZKdAB9nWdsXDVsh4xy+8ulKBP1l0=;
 b=hAgENHHRsCg1VZ+NcTX0xERAPcQgZXvEpdQ0q7vOECnrCMNwEdCrAw3FYtSWN5DzFcQPl3m8Vl2L+HEA/7LtGXUMbPJ8ncI+BBft4NDeP9tn6ViO9fbKkiRrONtpZ+te7IyKY03kmIcep3G3RUf1bbH6Qisw+apLvGRQnT6i+yiq30wIf+EzgmErQZDJCMRue8J+AQONgEoisvX/xytyc6Y9iDU67dTstx4zjA0Z4hfv9Y0v4xIZPHo66EcJBxdaX7Fanso++syh7nRAUFPlC2HnYRR75cLALNCGnQLMpCTY7KRi8d56kQ1IbLXiCsEPze2MkJmlu8Nxe1x//W6UnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uWfDBlZvYp0pAL7ZKdAB9nWdsXDVsh4xy+8ulKBP1l0=;
 b=msh4Kc24myEPeOZyZFoQ8XZY0aZGhXaydHfJfhhbgaAZNp7VBdzx2Sj7oYzifhlHKdFN4IYzth5dXUGjhcnB2C7NT0XoyloDR/lwCLyiFGO+CcJ0q13+DiVLcaV12tRePfAPSHUAWdmPQc8JExbVoKkjucO/FAt0yblGF0Our04=
Received: from CY5PR10CA0016.namprd10.prod.outlook.com (2603:10b6:930:1c::8)
 by MN0PR12MB6269.namprd12.prod.outlook.com (2603:10b6:208:3c3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 19:47:14 +0000
Received: from CY4PEPF0000B8E8.namprd05.prod.outlook.com
 (2603:10b6:930:1c:cafe::c4) by CY5PR10CA0016.outlook.office365.com
 (2603:10b6:930:1c::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Fri, 2 Dec 2022 19:47:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000B8E8.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5813.11 via Frontend Transport; Fri, 2 Dec 2022 19:47:13 +0000
Received: from [127.0.1.1] (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Dec
 2022 13:47:12 -0600
Subject: [PATCH 1/5] target/i386: allow versioned CPUs to specify new
 cache_info
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <qemu-devel@nongnu.org>, <michael.roth@amd.com>
Date:   Fri, 2 Dec 2022 13:47:12 -0600
Message-ID: <167001043207.62456.2927120221893260110.stgit@bmoger-ubuntu>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8E8:EE_|MN0PR12MB6269:EE_
X-MS-Office365-Filtering-Correlation-Id: 988a6386-6c7b-4d8f-e5b3-08dad49e02ab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t5cG3dMPUpLQvzfimGyQvKvgjWPOIXGeWpoqThvu5O3/LyP/tKPX25uu5lriEB2WxwIm/+z476B3M8GgOHSPEawvoC79S2zQpZXTaq0lP/K/6Wy5RcuibJMDdHiWCt8+Wzo8flMlc60i6UnGqvZ368DXtL7nupC1FLqpo61uexmMMBpGQeMfQPSiTJE1Tj5pOO6YjN7USTUnzRgBa0A/qEVGGAbfCSalPXV5Q+m4unSdx9vJCFjIGkhZPk1gXF/0edyv0v4XDI3n6bl5LQA9jPcQ+Mp9eFA5Nxfbf8un6w1+zeJCM7QaHGiEf6HS519X4lUvtB1g26voxzNlVoI+Xgh6sb2c2g03Wn6jbEkIPlABM0GuvPV9pAtn9re8yklHpU0mFzln+UsZlRBvMFAgQ/16Zgkn39WfU9wURSBR1O8RsIzbl63/TdFHvgt+QCZRfUVT9c9Dc24vezCM79EW2+yljKZ2RGJbvQq2mSkKcFdi6H9u3vdyLuF7tx1DpTOQb2zilYI9/0uSBiqxhehK/5LY713bSG+7nFYfga3uF0rp88NeSDpug07xDED4Uln3TUxuKej21UYqzEuGuQFgK9f5VvZihaMQ1uLaMNgtrnrex3wFq3y7PrNG1NNq+FaIP2PnuVBtuI4+Ep8HL1S8yg600PyoV6P6IY9SKG9eYCQE1MnyBuSCcTmTnKtVe/9ebfBGK2h74e4669oM2FJ5OEmz245cruR5BXlVxlf/XpU9GIb5P/SeiM9ou4lokHxFQFkYhWYHE3epqVkEWHeXOg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(7916004)(136003)(396003)(39860400002)(376002)(346002)(451199015)(46966006)(40470700004)(36840700001)(356005)(81166007)(40480700001)(40460700003)(86362001)(103116003)(9686003)(26005)(5660300002)(8676002)(7416002)(41300700001)(2906002)(316002)(54906003)(4326008)(36860700001)(6916009)(70206006)(16576012)(44832011)(70586007)(8936002)(186003)(82310400005)(82740400003)(478600001)(336012)(16526019)(47076005)(426003)(83380400001)(33716001)(71626007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 19:47:13.9838
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 988a6386-6c7b-4d8f-e5b3-08dad49e02ab
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6269
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
New EPYC CPUs versions require small changes to their cache_info's.=0A=
Because current QEMU x86 CPU definition does not support cache=0A=
versions, we would have to declare a new CPU type for each such case.=0A=
To avoid this duplication, the patch allows new cache_info pointers=0A=
to be specified for a new CPU version.=0A=
=0A=
Co-developed-by: Wei Huang <wei.huang2@amd.com>=0A=
Signed-off-by: Wei Huang <wei.huang2@amd.com>=0A=
Signed-off-by: Michael Roth <michael.roth@amd.com>=0A=
Signed-off-by: Babu Moger <babu.moger@amd.com>=0A=
---=0A=
 target/i386/cpu.c |   36 +++++++++++++++++++++++++++++++++---=0A=
 1 file changed, 33 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/target/i386/cpu.c b/target/i386/cpu.c=0A=
index 22b681ca37..b0f1d4618e 100644=0A=
--- a/target/i386/cpu.c=0A=
+++ b/target/i386/cpu.c=0A=
@@ -1596,6 +1596,7 @@ typedef struct X86CPUVersionDefinition {=0A=
     const char *alias;=0A=
     const char *note;=0A=
     PropValue *props;=0A=
+    const CPUCaches *const cache_info;=0A=
 } X86CPUVersionDefinition;=0A=
 =0A=
 /* Base definition for a CPU model */=0A=
@@ -5058,6 +5059,32 @@ static void x86_cpu_apply_version_props(X86CPU *cpu,=
 X86CPUModel *model)=0A=
     assert(vdef->version =3D=3D version);=0A=
 }=0A=
 =0A=
+/* Apply properties for the CPU model version specified in model */=0A=
+static const CPUCaches *x86_cpu_get_version_cache_info(X86CPU *cpu,=0A=
+                                                       X86CPUModel *model)=
=0A=
+{=0A=
+    const X86CPUVersionDefinition *vdef;=0A=
+    X86CPUVersion version =3D x86_cpu_model_resolve_version(model);=0A=
+    const CPUCaches *cache_info =3D model->cpudef->cache_info;=0A=
+=0A=
+    if (version =3D=3D CPU_VERSION_LEGACY) {=0A=
+        return cache_info;=0A=
+    }=0A=
+=0A=
+    for (vdef =3D x86_cpu_def_get_versions(model->cpudef); vdef->version; =
vdef++) {=0A=
+        if (vdef->cache_info) {=0A=
+            cache_info =3D vdef->cache_info;=0A=
+        }=0A=
+=0A=
+        if (vdef->version =3D=3D version) {=0A=
+            break;=0A=
+        }=0A=
+    }=0A=
+=0A=
+    assert(vdef->version =3D=3D version);=0A=
+    return cache_info;=0A=
+}=0A=
+=0A=
 /*=0A=
  * Load data from X86CPUDefinition into a X86CPU object.=0A=
  * Only for builtin_x86_defs models initialized with x86_register_cpudef_t=
ypes.=0A=
@@ -5090,7 +5117,7 @@ static void x86_cpu_load_model(X86CPU *cpu, X86CPUMod=
el *model)=0A=
     }=0A=
 =0A=
     /* legacy-cache defaults to 'off' if CPU model provides cache info */=
=0A=
-    cpu->legacy_cache =3D !def->cache_info;=0A=
+    cpu->legacy_cache =3D !x86_cpu_get_version_cache_info(cpu, model);=0A=
 =0A=
     env->features[FEAT_1_ECX] |=3D CPUID_EXT_HYPERVISOR;=0A=
 =0A=
@@ -6562,14 +6589,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Err=
or **errp)=0A=
 =0A=
     /* Cache information initialization */=0A=
     if (!cpu->legacy_cache) {=0A=
-        if (!xcc->model || !xcc->model->cpudef->cache_info) {=0A=
+        const CPUCaches *cache_info =3D=0A=
+            x86_cpu_get_version_cache_info(cpu, xcc->model);=0A=
+=0A=
+        if (!xcc->model || !cache_info) {=0A=
             g_autofree char *name =3D x86_cpu_class_get_model_name(xcc);=
=0A=
             error_setg(errp,=0A=
                        "CPU model '%s' doesn't support legacy-cache=3Doff"=
, name);=0A=
             return;=0A=
         }=0A=
         env->cache_info_cpuid2 =3D env->cache_info_cpuid4 =3D env->cache_i=
nfo_amd =3D=0A=
-            *xcc->model->cpudef->cache_info;=0A=
+            *cache_info;=0A=
     } else {=0A=
         /* Build legacy cache information */=0A=
         env->cache_info_cpuid2.l1d_cache =3D &legacy_l1d_cache;=0A=
=0A=

