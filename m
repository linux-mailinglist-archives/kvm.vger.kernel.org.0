Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 193076606B7
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 19:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbjAFS53 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 13:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235935AbjAFS5M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 13:57:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE497D9D8
        for <kvm@vger.kernel.org>; Fri,  6 Jan 2023 10:57:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=db34eAN5UFbrFPRpLXP1lihLm1fD5BwEafbOr+UoTuCXIBjFFm7triTiz8cLttJBogk3BgRV2aJ9MrhZpeoEESn0hRyFZ0378trrA+btB4RZz1J7knL2zkqYRJPnK5jwCHDhuFyfV28F2BphpSUqULhwxx+sAY2I0yzsEGPRUgdnlh55mnCV/0LwWhLYAbTljWlJB2/6lyrvUrw9e6lS8WQB7BmIYO5AVqYuZHtvoTG35NqLmnvUBnVQterLSme8XgyK+6yXGEhKaYv8sIh933ZocGLKYcTDFyNHNBaQnnyV97uSBxihx+so7Bytay51ROPcaF1oXnfN934hbmliXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ur3FFyfsQEPn/1e4O6xwMeJ1yuD7QTpNZd2OV/nmaE=;
 b=V6HF4PGbPDKt4mxhPHhur1Bbu2wMIMWqB+/Ydj7tGD9m9M6nW/1lS1zMggKdbqq8ONCMhrN3qxXe7Ctsx17kOHFuBVryBScskQXD9EYJVYiUCWA2rKJ3VwYSMiRbRmX4+J1f1ofBL8CIo4fYglriJ6ELGmyAsH8xbA+BEQPJILdlXXzy7aFk2UFx8o1o0WMOXZs1FXRqMzzcp1W6MBkrsU2wganR1Kok5QQDjVpHK0TjaMFcwZQj0sryX3W4ByuKeocFkuM0M2TM4dDCziwvLMkc1vTTCU/7Gva7Q5O2y3v8SHMaZ3Y18B14GqU/8qkI+e9wm8DGEUAaFJfJflhDJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ur3FFyfsQEPn/1e4O6xwMeJ1yuD7QTpNZd2OV/nmaE=;
 b=vYXaD4qGHx1rFovyIqdONyTIDoeeJxUNmsG5W5dXtRDWcKzFI9ItB6ueEChvlyDgCbYl7Dq28pz3CcGesspxdDeZZu1edrh2+NSWdvlholZUWOoE87mHtXJOXd0q/BHTwyyw8ZyOUco5I7FndiMOnvDMQpC0PGgTDCZDGw5OBLM=
Received: from MN2PR08CA0017.namprd08.prod.outlook.com (2603:10b6:208:239::22)
 by PH0PR12MB5497.namprd12.prod.outlook.com (2603:10b6:510:eb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Fri, 6 Jan
 2023 18:57:09 +0000
Received: from BL02EPF00010208.namprd05.prod.outlook.com
 (2603:10b6:208:239:cafe::3c) by MN2PR08CA0017.outlook.office365.com
 (2603:10b6:208:239::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.15 via Frontend
 Transport; Fri, 6 Jan 2023 18:57:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00010208.mail.protection.outlook.com (10.167.241.199) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5986.15 via Frontend Transport; Fri, 6 Jan 2023 18:57:08 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 6 Jan
 2023 12:57:07 -0600
From:   Babu Moger <babu.moger@amd.com>
To:     <pbonzini@redhat.com>
CC:     <mtosatti@redhat.com>, <kvm@vger.kernel.org>, <mst@redhat.com>,
        <marcel.apfelbaum@gmail.com>, <imammedo@redhat.com>,
        <richard.henderson@linaro.org>, <yang.zhong@intel.com>,
        <jing2.liu@intel.com>, <vkuznets@redhat.com>,
        <michael.roth@amd.com>, <wei.huang2@amd.com>
Subject: [PATCH v2 1/5] target/i386: allow versioned CPUs to specify new cache_info
Date:   Fri, 6 Jan 2023 12:56:56 -0600
Message-ID: <20230106185700.28744-2-babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00010208:EE_|PH0PR12MB5497:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f167f98-f90a-438d-53e2-08daf017cfef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qUN2gi9yPciAbkWcosyLVZ7V2eD+RkrF2Vp9ZJY4K8s59RVWkpuJ6rPQrzau7mLf1+ihTUtORbQTrnIST8Ksvy3BoN+Muqf02qQcA3cbKZedimmQ/5ES9q899dCVQ4k+ryWkLivrFQKSOCAs8LyBQKRhewL77wuSyRkt/Pj5Tqbf8SVeG1mEHQA2FiBx+wvfWHjNKv2YW0gOpP4AOiZijNqb8obL55207erUc9QO/VbkolG3dRpRiqBkqkD7lcRqoFJje6cfBeVSHFvgh8WX5daqJ3N+ib9WMzQIDd7K+Pj11CV6l9UTLlksfFFGdXG3pAz2hAc8EsL2NOTGmFxXadXFcbcbjsXCMJ96FG5U58QwWP5+wVo0HMIBy2/mSB+lQazDWwYUpZTa5c+FwSncmoXf8L7wj9l3dO3Ofh2utIjxuVZQhAMpd+U4lOU2vTPItH29g0T43yJaBrgIcaYGGSnUn+zghBAtFnmjeA+QT4xroP81vO3QBavWxFF0N+QceTe7sKcZS3gcKUyOjBPzY9vPbVCrOzfL4XmiqlMF0Q6bEi+4J8jp9sjr5jiggHKo8urlT6lF14NPo0OT5t1SD1NgQiGHSuehofnKw7XQ4xSW0BxwnGeNZn09CwVUOS4LXw2PrVMO4eVxBxEqkQhW5WQfhg9sPWLeiBqO5MipPDnI8+1qChW+bnPvfgpznyjAO+1iRpZD4As7NDSVyNjFFX+cxtXeklRtrw/kX5ngbiU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(5660300002)(2906002)(44832011)(8676002)(4326008)(8936002)(7416002)(41300700001)(316002)(70586007)(54906003)(70206006)(6916009)(478600001)(26005)(6666004)(186003)(336012)(16526019)(40480700001)(7696005)(83380400001)(426003)(47076005)(1076003)(82740400003)(81166007)(2616005)(40460700003)(86362001)(356005)(82310400005)(36756003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2023 18:57:08.9360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f167f98-f90a-438d-53e2-08daf017cfef
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF00010208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5497
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

New EPYC CPUs versions require small changes to their cache_info's.
Because current QEMU x86 CPU definition does not support cache
versions, we would have to declare a new CPU type for each such case.
To avoid this duplication, the patch allows new cache_info pointers
to be specified for a new CPU version.

Co-developed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
---
 target/i386/cpu.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3410e5e470..ab1b49f08f 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1596,6 +1596,7 @@ typedef struct X86CPUVersionDefinition {
     const char *alias;
     const char *note;
     PropValue *props;
+    const CPUCaches *const cache_info;
 } X86CPUVersionDefinition;
 
 /* Base definition for a CPU model */
@@ -5057,6 +5058,32 @@ static void x86_cpu_apply_version_props(X86CPU *cpu, X86CPUModel *model)
     assert(vdef->version == version);
 }
 
+/* Apply properties for the CPU model version specified in model */
+static const CPUCaches *x86_cpu_get_version_cache_info(X86CPU *cpu,
+                                                       X86CPUModel *model)
+{
+    const X86CPUVersionDefinition *vdef;
+    X86CPUVersion version = x86_cpu_model_resolve_version(model);
+    const CPUCaches *cache_info = model->cpudef->cache_info;
+
+    if (version == CPU_VERSION_LEGACY) {
+        return cache_info;
+    }
+
+    for (vdef = x86_cpu_def_get_versions(model->cpudef); vdef->version; vdef++) {
+        if (vdef->cache_info) {
+            cache_info = vdef->cache_info;
+        }
+
+        if (vdef->version == version) {
+            break;
+        }
+    }
+
+    assert(vdef->version == version);
+    return cache_info;
+}
+
 /*
  * Load data from X86CPUDefinition into a X86CPU object.
  * Only for builtin_x86_defs models initialized with x86_register_cpudef_types.
@@ -5089,7 +5116,7 @@ static void x86_cpu_load_model(X86CPU *cpu, X86CPUModel *model)
     }
 
     /* legacy-cache defaults to 'off' if CPU model provides cache info */
-    cpu->legacy_cache = !def->cache_info;
+    cpu->legacy_cache = !x86_cpu_get_version_cache_info(cpu, model);
 
     env->features[FEAT_1_ECX] |= CPUID_EXT_HYPERVISOR;
 
@@ -6563,14 +6590,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
     /* Cache information initialization */
     if (!cpu->legacy_cache) {
-        if (!xcc->model || !xcc->model->cpudef->cache_info) {
+        const CPUCaches *cache_info =
+            x86_cpu_get_version_cache_info(cpu, xcc->model);
+
+        if (!xcc->model || !cache_info) {
             g_autofree char *name = x86_cpu_class_get_model_name(xcc);
             error_setg(errp,
                        "CPU model '%s' doesn't support legacy-cache=off", name);
             return;
         }
         env->cache_info_cpuid2 = env->cache_info_cpuid4 = env->cache_info_amd =
-            *xcc->model->cpudef->cache_info;
+            *cache_info;
     } else {
         /* Build legacy cache information */
         env->cache_info_cpuid2.l1d_cache = &legacy_l1d_cache;
-- 
2.34.1

