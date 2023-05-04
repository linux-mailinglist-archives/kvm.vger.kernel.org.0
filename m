Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCEF6F7780
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 22:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbjEDUya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 16:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbjEDUy1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 16:54:27 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2072.outbound.protection.outlook.com [40.107.100.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6C7A270
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 13:54:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErqjifAuANbJsZEVJ6QoqzkxjKYDvihSnkuMt8FIi0H/GA1szp62hDvioevQhdRcv3lsFLhLBe7bZnG/1uyp7vtvWb5T3PrJemliWwq3IDuOaZihOZQB7dJyt1hwNQ8veqzx6zThSw+TY5qw9sSul7JEnnk+YfhGuVkQM8PVaWMc7wlRVUK2lm9Hw9gKLI7N4AL4rCNsouWhzjCb+AhdHzVtkdQ7wP/103EAoXtnBJrbkRQXhrHYwIj5TpAJ6/YFj5yGN2Z+W8ICIB33ecF3lm3xhUWfjZ4GVtnJB2JKswhpjpc9lH2ucuDI42JjoUnUftadh8hFXj8xWkLFdN1pMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYcnc4H9ARvb3HyRAdSp8NVzqXsbscxUazPWWvlYKzo=;
 b=Wa1MGN1eo8DtB0YKAVcejkptc/JBU1dogPAAtBzI9QZJtpp+GO0lLvWzZVJsoR6q0ffmcDgnNKuIKuoC/0L4ouwA9/6IqxJUh5qn6czOVzJtR2F8FssZDUgzMw+UPOg3RjIMTPwgLiya/DCpp6jLzip2JqNfNoVXL+CL51GwJmCYSOKtg/a60IQ9OamiWJq7TsuIOKgx1TaEiN28xlrxJBsqVxKH92mQh4to5Z69OTyTAa1HzjxqPVkgk4r+3nfN6G+cVCXNSoq3oAg+S0BW9bNLCBXKbL3TtaDipzVeXAhV+Wpa0oxu1L8ve43Ii3Lh9oq+OVPS4uZgjqk+LCPVhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYcnc4H9ARvb3HyRAdSp8NVzqXsbscxUazPWWvlYKzo=;
 b=3OO7Z1f6DOBUMGM36b02j8WmCrXHwgwsii5yC0djtaooGuigGkr8tN3TWkF/kf8CjCPyGx0WsAomPHFenoDH8F23XwgKN4r1KKTwPi3aebDGiS9A9D0oQrWpMyWR3WwyRD6W43Yb16HKByq25mxVif2orX+c27/ksJSWOdnI1D4=
Received: from MW4PR04CA0192.namprd04.prod.outlook.com (2603:10b6:303:86::17)
 by DS7PR12MB8204.namprd12.prod.outlook.com (2603:10b6:8:e1::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.22; Thu, 4 May 2023 20:53:30 +0000
Received: from CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:86:cafe::48) by MW4PR04CA0192.outlook.office365.com
 (2603:10b6:303:86::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 20:53:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT046.mail.protection.outlook.com (10.13.174.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.27 via Frontend Transport; Thu, 4 May 2023 20:53:30 +0000
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 4 May
 2023 15:53:23 -0500
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
Subject: [PATCH v4 1/7] target/i386: allow versioned CPUs to specify new cache_info
Date:   Thu, 4 May 2023 15:53:06 -0500
Message-ID: <20230504205313.225073-2-babu.moger@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT046:EE_|DS7PR12MB8204:EE_
X-MS-Office365-Filtering-Correlation-Id: ac4a66cc-2100-4f0b-60dc-08db4ce19e05
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6GG0c9rqeXrA2n9ltWtHpWenRMvOfIQmAae5Y05yCdh3QTADOjbG/dc/Rt55TJ5p11Wj7ZIw17a9/WCImoesVNhMjMphM1b4lglQ34abte0XusaiVi0FwxJixw04f9qPF+AGD5BjWnLAAly96EVgC9FoHfgADKY2WUIaamaj7hViXVak5+h6aSVGgcAzIZOHEkW9pgNONzY2TgOlbH7+9j8S7cGYnJHd2mzPtnq0qinGtGJL0mv4SWD/jP8rkfoPH61DFIdSrNGkz88rju2upWJRbhHZpOrgPKHc8rtx4xgxpDd5Z1XaoofffQbkxsbdJZA8cCYEDotzAHQ2yS6wvzbuzGrXzOQTWu7VVY5QR+o4vXD6Kgx5h7oZrUlS5OmKsn1ZhSx2/l1JcVhOexA2NITJ+O0tnk8igDLjLZsPsxybrdb3o81nDtAiH609JGllCX6DiKWHrjxPg2IZoHZWzI+qrjNDvGjtKbdmFZln33S0c3VdYArAT2bGpa0PQ/Gh93zZpbSm7lkTL4BaLCw4KoKNz0medSNrb73Jkry7tR7MtiMnATFdwBtzeYpejFQTbeUhNf4xXuPq/hM1FamrvSsPx4+E4feVrPT7aW6PBB+JkEdeE0S9uZIgi0+53wP0woM9Dbunff7i5wTqmImc1Mh6vyR7IAavTWtxpY4jNgYCksmb3dPm7WXobo1QqKg6nhrtijJLGPFz1Va6fvmIgGCnf3hMpVyTmxLZEo3Tkc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199021)(46966006)(40470700004)(36840700001)(40460700003)(478600001)(4326008)(70206006)(7696005)(70586007)(6666004)(54906003)(316002)(110136005)(86362001)(36756003)(426003)(47076005)(336012)(26005)(36860700001)(1076003)(8676002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(2906002)(82310400005)(40480700001)(356005)(81166007)(16526019)(186003)(83380400001)(2616005)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 20:53:30.3843
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ac4a66cc-2100-4f0b-60dc-08db4ce19e05
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT046.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8204
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

New EPYC CPUs versions require small changes to their cache_info's.
Because current QEMU x86 CPU definition does not support versioned
cach_info, we would have to declare a new CPU type for each such case.
To avoid the dup work, add "cache_info" in X86CPUVersionDefinition",
to allow new cache_info pointers to be specified for a new CPU version.

Co-developed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 target/i386/cpu.c | 35 ++++++++++++++++++++++++++++++++---
 1 file changed, 32 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 6576287e5b..6e5d2779c9 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1598,6 +1598,7 @@ typedef struct X86CPUVersionDefinition {
     const char *alias;
     const char *note;
     PropValue *props;
+    const CPUCaches *const cache_info;
 } X86CPUVersionDefinition;
 
 /* Base definition for a CPU model */
@@ -5192,6 +5193,31 @@ static void x86_cpu_apply_version_props(X86CPU *cpu, X86CPUModel *model)
     assert(vdef->version == version);
 }
 
+static const CPUCaches *x86_cpu_get_versioned_cache_info(X86CPU *cpu,
+                                                         X86CPUModel *model)
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
@@ -5224,7 +5250,7 @@ static void x86_cpu_load_model(X86CPU *cpu, X86CPUModel *model)
     }
 
     /* legacy-cache defaults to 'off' if CPU model provides cache info */
-    cpu->legacy_cache = !def->cache_info;
+    cpu->legacy_cache = !x86_cpu_get_versioned_cache_info(cpu, model);
 
     env->features[FEAT_1_ECX] |= CPUID_EXT_HYPERVISOR;
 
@@ -6703,14 +6729,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
     /* Cache information initialization */
     if (!cpu->legacy_cache) {
-        if (!xcc->model || !xcc->model->cpudef->cache_info) {
+        const CPUCaches *cache_info =
+            x86_cpu_get_versioned_cache_info(cpu, xcc->model);
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

