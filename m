Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B667496306
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 17:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351551AbiAUQj7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 11:39:59 -0500
Received: from mail-eopbgr30109.outbound.protection.outlook.com ([40.107.3.109]:14185
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1351529AbiAUQj5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 11:39:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNmxwc6A7iDn/ndQ+i/8nnSBsH66tnx6K5P+8Aq5hXqjFLSz8REZFIHAAhrStY9e1MezxI100psyGn2Digr6wEgPqtKR+3Ue2HJz+fNDpI/KQ4aVNOpMlCziDKlpCpXYioscxHkQku/Q0nrgt9z8+SDiSrc7Go3vEwlbcG6wruWsAJEmUr/04bH7iPwERH4zqcW9zRddx09p0dCsRZHUAQpvf2qWC7mvB5QLH5YvFLoc0w4krM5Wvcw5CCAq4ideRkljWBqEkL+23ZjtuuVFgkwETPw5kXYktczzy2ihQBtmIVVYfKWmnTpJw/cNFObIYVtrLVgIvkvEdlbb6cmvWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CqLzZHN0H995YMchR5QYAKCR7gF5miTDNwenQEef+4Y=;
 b=iKP4aG+ewKZnL/lTo321rHE+rAgTajnYdMaA1Ns5ZyQgS7G8eOuYq7afBOQLzq7eQeBk+A1/vMRoY781F3sGCu1cdGvmMzGfbI7VzjNTsYb4oUwGA1YVnfLST02KfrdFzwvgbMS4PxUf/Dgjw9UgCkzBXfcj1o+qVwKSWvWgmWl2PmNzasUMZDcs/3b85jvGEIxZqtTwExaM9Wyd/NfVs8ud64a2o/N5TI1Qoo2Cdg9Ug/sEEOM9FfjlGM0B1jQ5vgrirclK65A9v6HVMrLW8RHCl0us2M4VgyeM+Wx7T9FgjwVNBC7bYnP7qC2Ueg/Djl3nUq9c8i37zsUVvkhCQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CqLzZHN0H995YMchR5QYAKCR7gF5miTDNwenQEef+4Y=;
 b=Vr+fo4Q/X/JF2vl6I7gqfN/TVdbER150UXSL+cZJV5qlMaS3jrLUUT4ZyLMZWkqZhuZjgkzF5tUEiYVf6n0UQsxzNi8zY5j/YT9OXeZA003hRrcVq2rK5yCnVGjiS7T1e+jqSkhAaPyosDTIJAdxNKfBOwcQd57EXjSps3a5kFI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB6737.eurprd08.prod.outlook.com (2603:10a6:20b:304::18)
 by AM0PR08MB3348.eurprd08.prod.outlook.com (2603:10a6:208:65::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Fri, 21 Jan
 2022 16:39:54 +0000
Received: from AM9PR08MB6737.eurprd08.prod.outlook.com
 ([fe80::4def:4b08:dfe6:b4bd]) by AM9PR08MB6737.eurprd08.prod.outlook.com
 ([fe80::4def:4b08:dfe6:b4bd%3]) with mapi id 15.20.4909.012; Fri, 21 Jan 2022
 16:39:53 +0000
From:   Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        mtosatti@redhat.com, richard.henderson@linaro.org,
        pbonzini@redhat.com, armbru@redhat.com, eblake@redhat.com,
        wangyanan55@huawei.com, f4bug@amsat.org,
        marcel.apfelbaum@gmail.com, eduardo@habkost.net,
        vsementsov@virtuozzo.com, valery.vdovin.s@gmail.com,
        den@openvz.org, Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Subject: [PATCH v17] qapi: introduce 'x-query-x86-cpuid' QMP command.
Date:   Fri, 21 Jan 2022 17:39:43 +0100
Message-Id: <20220121163943.2720015-1-vsementsov@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6PR10CA0097.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:8c::38) To AM9PR08MB6737.eurprd08.prod.outlook.com
 (2603:10a6:20b:304::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e5edb4d-a475-4939-9754-08d9dcfca697
X-MS-TrafficTypeDiagnostic: AM0PR08MB3348:EE_
X-Microsoft-Antispam-PRVS: <AM0PR08MB33486D775D362D413E080E43C15B9@AM0PR08MB3348.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wKwj5a4V0JL9trXUYSHIVKLTrNogxAFFiCDsFVQ9elb7UtaYTrBx9NGMaW9Y07JfQFBvaB6e720JK4Ano2xkELd38asluHpsqUdPniE6pyupssoFDiErmW01/mKxmaAJqngLBSV+Jga4/ROnhs8wi+TbBxvQC7SyNIilBn79xg6tKe/7IjtuaXQCSK7zcL3nM8LmcXDSTlCo9WnoBH1/R5ESO6m1eCLQPvJO2MajoeCGOgbIHec+I4fNWHH1OMhXPpoUWpSFx7WFUjPft8+Zb1wjskZutSJGYoC4X9N27zPBBYPpjXLasL2D6OORYZWYECGeVxx87T5bFOdsH8cihtpV/Q7SdyRI7kVAxAdSXGhE0WQas5r+Tzn2MhzPpWKtHes3OB0qosPLAh8chWDvF1AjkUVvGeBFUV26HeMWlmsXFnekUiOM/7WxeZs0K/1Qojhj7Xikq+B7lGDlcwW+VdWzDi0NxHJxgSg6zQGiEahMx0Aw+rt6JzGYR3aXgwvyHEwHOyuoCrVZ3/3TZotTkGYB7KG35Z4S/tVZvXluWLgrtwwCm8mU3ljZH8+Ox7j3vRE7xtYrp63bbG2eYInqn6HWpSiWs+jqoBctBeReLS5XY2wAZ4nZnQodXUMdxlcDMnZbRGXRFEgKyDmfHPob1jvWSKuDmBF2BRyTI9HTI6KR4SKNNgxPVnhoBmMdcST6bhicstX6FO3BUFbWmg7cVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6737.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(66556008)(5660300002)(38100700002)(36756003)(26005)(508600001)(66946007)(6506007)(6486002)(38350700002)(6666004)(4326008)(107886003)(1076003)(186003)(316002)(83380400001)(2616005)(2906002)(52116002)(6512007)(8676002)(86362001)(8936002)(7416002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?049K0OPxFNbB/GRz9+PDUjA/V6cmr1cKmBpyZwjTXHRh3RMTbdmmLjaCfuMx?=
 =?us-ascii?Q?O8wcWJ8xanY81BXsscpxeM/fW+I8XwG4kMR3CN2oQIbLz0Cw/X6l1Eor1oHk?=
 =?us-ascii?Q?nVLJfQWa1H1rXzXQtfm3fyZENUhUKpqe3PDOpv5cSWegyBAhvJqMwv75fdi1?=
 =?us-ascii?Q?g3IsSMZqS9wCsxQA3JT7AuKqkysHKL2mPbhNu6/WX2u8AFvlsNH1z67lAXhQ?=
 =?us-ascii?Q?+/e6XdzXWtqsBysKFioDQNWXWKeWpnLmtp4zRTxcHuHBjn5J39cD78xU6Jmg?=
 =?us-ascii?Q?NPcPXrYbvz5iH5+XLoIEtwor6qvOY7XPdIT+OPHis6kw6AKnYB2LBbMFH7eY?=
 =?us-ascii?Q?Ty8wALIVFFKrjN8irC0ybjYgFBF/vfVIwm2HnsCiMvUN1o3jFaLl5ratltwq?=
 =?us-ascii?Q?AMWl8ZMKrli6LDZ6ySFYQgfjesxxdSfCru6BjgzfpBBOnAihD6mnc2gCqx9/?=
 =?us-ascii?Q?sm8evf0sdAI2rdXVrggz5xfdJbKD0zxUe1lbdB6Z/8F/P6nNJk6cI30NVAn8?=
 =?us-ascii?Q?EYxy9ugtTQuSfRVuZWm4sUtf2gl7X5CG6WeOCeUDrGPpz70uZ7ZeqFYipdBw?=
 =?us-ascii?Q?MJglIUygxHUyiHusQdzaEdi3WUF9ezRIMpAcnHfRyxXjILjgBbi3Tc4vTLS9?=
 =?us-ascii?Q?a9U5W7gDIe2XTUQ4jqbdHciNsJ/9DTpp6NmRcMVqDAV/I5/zUzmVGg6zSL/x?=
 =?us-ascii?Q?iO9F6qO+xK6IQP0cHMWWP1Qu0ICRXWWazF+v8kqftMf1+HkWGymfsbD4SMHh?=
 =?us-ascii?Q?bbChq3aWtt9P/8UKzZb/ZV9Husa5IfPOyRDBpjyYcsPXofRcOVc7Ut1cR0OZ?=
 =?us-ascii?Q?dFNiNnPkXcOyGHyx1z7uw6gEkHMWzwfmz+HZIUwf0sKgOXwSkerZ1iWbOlnE?=
 =?us-ascii?Q?UGOgr1IecD1vCh/dmv+Bqz2qf0m9SDHf23BIWQmw4mVGvTzgNa+3q8RQIVC0?=
 =?us-ascii?Q?n3Yi6L2HFgRy+SP6rmVgV2QpPTMT3msUhhWmWkSnv5W+f9Ji9eX4NSCpDnli?=
 =?us-ascii?Q?U4b2W3tGmIggC40+3dvrAuhs8dxM85Qu+6J995EvG2qYSV+J3kPn+9aKV0Ii?=
 =?us-ascii?Q?hiVdInpu21E8BqdRI8E6djc51qz2/GVRuk0zcQ3DZEqmlO8y7HDKOTqwEKP/?=
 =?us-ascii?Q?gvUddCPF3EGnOynhtnTz5xts2m6FApztqcvIeFiXgB4DXYfO6/FRNjHiASpW?=
 =?us-ascii?Q?KxjL4ecoDH+4SbGcBchh73XUaW/3x3ZrY7W2O4m2amgTIrIPvZhDFJJgePwe?=
 =?us-ascii?Q?FMgqPnDbqsguHOqTlIO+Kx6D25t5inQ+0dFOL4JOv+XyUNMFAT0eNY8MhQ3F?=
 =?us-ascii?Q?qFZh0GDspumFJ+dhiV22A2MTQTSlDAbVUifQ0wpUF+OWPYOSvWnVt384UNj2?=
 =?us-ascii?Q?ffJVDZOPI2VFlFCDOMGuDm/atP9y7FY4xaN+cDh4pifnweSAUggcMP9PFwpF?=
 =?us-ascii?Q?r8RY+pJRvOpJKEPRf/eLsmVOcWye6q0M/L7aE0mMhl842ccLYnZ4yFBlBkLJ?=
 =?us-ascii?Q?nCcjrwvwZ8TcfCJczJsg/ZQ0IJI5yCnsZ1vB4H7MnTp2t6PDaR8C5ebWvVp+?=
 =?us-ascii?Q?pJ4+ZbXk9LWb4q5qOx6/WLw5O3wea6R8JJ70pVoVUoNFilHFKQy3sMRYuEB8?=
 =?us-ascii?Q?wa4MlWGplTvQ3YorEoC0VhTahnHZ2hm8mmittboYjTXbNKdQ2048B1e3FbUR?=
 =?us-ascii?Q?tPozwQ=3D=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e5edb4d-a475-4939-9754-08d9dcfca697
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6737.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2022 16:39:53.9312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eaNHJdhqdHhU7MCPBqA+keiD3Gcx6+0j87tSUVNu9ZLVS+vVA3IADB6qd0PIAb4x4vmN7yJF7RZ6dg6k6SUyOkhM4We4yS3LTHAK7M8ajH8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3348
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>

Introducing new QMP command 'query-x86-cpuid'. This command can be
used to get virtualized cpu model info generated by QEMU during VM
initialization in the form of cpuid representation.

Diving into more details about virtual CPU generation: QEMU first
parses '-cpu' command line option. From there it takes the name of the
model as the basis for feature set of the new virtual CPU. After that
it uses trailing '-cpu' options, that state if additional cpu features
should be present on the virtual CPU or excluded from it (tokens
'+'/'-' or '=on'/'=off').
After that QEMU checks if the host's cpu can actually support the
derived feature set and applies host limitations to it.
After this initialization procedure, virtual CPU has it's model and
vendor names, and a working feature set and is ready for
identification instructions such as CPUID.

To learn exactly how virtual CPU is presented to the guest machine via
CPUID instruction, new QMP command can be used. By calling
'query-x86-cpuid' command, one can get a full listing of all CPUID
leaves with subleaves which are supported by the initialized virtual
CPU.

Other than debug, the command is useful in cases when we would like to
utilize QEMU's virtual CPU initialization routines and put the
retrieved values into kernel CPUID overriding mechanics for more
precise control over how various processes perceive its underlying
hardware with container processes as a good example.

The command is specific to x86. It is currenly only implemented for
KVM acceleator.

Output format:
The output is a plain list of leaf/subleaf argument combinations, that
return 4 words in registers EAX, EBX, ECX, EDX.

Use example:
qmp_request: {
  "execute": "x-query-x86-cpuid"
}

qmp_response: {
  "return": [
    {
      "eax": 1073741825,
      "edx": 77,
      "in-eax": 1073741824,
      "ecx": 1447775574,
      "ebx": 1263359563
    },
    {
      "eax": 16777339,
      "edx": 0,
      "in-eax": 1073741825,
      "ecx": 0,
      "ebx": 0
    },
    {
      "eax": 13,
      "edx": 1231384169,
      "in-eax": 0,
      "ecx": 1818588270,
      "ebx": 1970169159
    },
    {
      "eax": 198354,
      "edx": 126614527,
      "in-eax": 1,
      "ecx": 2176328193,
      "ebx": 2048
    },
    ....
    {
      "eax": 12328,
      "edx": 0,
      "in-eax": 2147483656,
      "ecx": 0,
      "ebx": 0
    }
  ]
}

Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Signed-off-by: Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
---

v17: wrap long lines, add QAPI feature 'unstable' [Markus]

 qapi/machine-target.json   | 50 ++++++++++++++++++++++++++++++++++++++
 softmmu/cpus.c             |  2 +-
 target/i386/kvm/kvm-stub.c |  9 +++++++
 target/i386/kvm/kvm.c      | 44 +++++++++++++++++++++++++++++++++
 tests/qtest/qmp-cmd-test.c |  1 +
 5 files changed, 105 insertions(+), 1 deletion(-)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index f5ec4bc172..1568e17e74 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -341,3 +341,53 @@
                    'TARGET_I386',
                    'TARGET_S390X',
                    'TARGET_MIPS' ] } }
+
+##
+# @CpuidEntry:
+#
+# A single entry of a CPUID response.
+#
+# One entry holds full set of information (leaf) returned to the guest
+# in response to it calling a CPUID instruction with eax, ecx used as
+# the arguments to that instruction. ecx is an optional argument as
+# not all of the leaves support it.
+#
+# @in-eax: CPUID argument in eax
+# @in-ecx: CPUID argument in ecx
+# @eax: CPUID result in eax
+# @ebx: CPUID result in ebx
+# @ecx: CPUID result in ecx
+# @edx: CPUID result in edx
+#
+# Since: 7.0
+##
+{ 'struct': 'CpuidEntry',
+  'data': { 'in-eax' : 'uint32',
+            '*in-ecx' : 'uint32',
+            'eax' : 'uint32',
+            'ebx' : 'uint32',
+            'ecx' : 'uint32',
+            'edx' : 'uint32'
+          },
+  'if': 'TARGET_I386' }
+
+##
+# @x-query-x86-cpuid:
+#
+# Returns raw data from the emulated CPUID table for the first VCPU.
+# The emulated CPUID table defines the response to the CPUID
+# instruction when executed by the guest operating system.
+#
+# Features:
+# @unstable: This command is experimental.
+#
+# Returns: a list of CpuidEntry. Returns error when qemu is configured
+#          with --disable-kvm flag or if qemu is run with any other
+#          accelerator than KVM.
+#
+# Since: 7.0
+##
+{ 'command': 'x-query-x86-cpuid',
+  'returns': [ 'CpuidEntry' ],
+  'if': 'TARGET_I386',
+  'features': [ 'unstable' ] }
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index 23bca46b07..33045bf45c 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -129,7 +129,7 @@ void hw_error(const char *fmt, ...)
 /*
  * The chosen accelerator is supposed to register this.
  */
-static const AccelOpsClass *cpus_accel;
+const AccelOpsClass *cpus_accel;
 
 void cpu_synchronize_all_states(void)
 {
diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
index f6e7e4466e..71631e560d 100644
--- a/target/i386/kvm/kvm-stub.c
+++ b/target/i386/kvm/kvm-stub.c
@@ -12,6 +12,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "kvm_i386.h"
+#include "qapi/error.h"
 
 #ifndef __OPTIMIZE__
 bool kvm_has_smm(void)
@@ -44,3 +45,11 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
 {
     abort();
 }
+
+CpuidEntryList *qmp_x_query_x86_cpuid(Error **errp);
+
+CpuidEntryList *qmp_x_query_x86_cpuid(Error **errp)
+{
+    error_setg(errp, "Not implemented in --disable-kvm configuration");
+    return NULL;
+}
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2c8feb4a6f..eb73869039 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -20,11 +20,13 @@
 
 #include <linux/kvm.h>
 #include "standard-headers/asm-x86/kvm_para.h"
+#include "qapi/qapi-commands-machine-target.h"
 
 #include "cpu.h"
 #include "host-cpu.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/hw_accel.h"
+#include "sysemu/accel-ops.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
@@ -1565,6 +1567,44 @@ static Error *invtsc_mig_blocker;
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
+struct kvm_cpuid2 *cpuid_data_cached;
+
+
+CpuidEntryList *qmp_x_query_x86_cpuid(Error **errp)
+{
+    int i;
+    struct kvm_cpuid_entry2 *kvm_entry;
+    CpuidEntryList *head = NULL, **tail = &head;
+    CpuidEntry *entry;
+
+    if (!kvm_enabled()) {
+        error_setg(errp, "Not implemented for non-kvm accel");
+        return NULL;
+    }
+
+    if (!cpuid_data_cached) {
+        error_setg(errp, "VCPU was not initialized yet");
+        return NULL;
+    }
+
+    for (i = 0; i < cpuid_data_cached->nent; ++i) {
+        kvm_entry = &cpuid_data_cached->entries[i];
+        entry = g_malloc0(sizeof(*entry));
+        entry->in_eax = kvm_entry->function;
+        if (kvm_entry->flags & KVM_CPUID_FLAG_SIGNIFCANT_INDEX) {
+            entry->in_ecx = kvm_entry->index;
+            entry->has_in_ecx = true;
+        }
+        entry->eax = kvm_entry->eax;
+        entry->ebx = kvm_entry->ebx;
+        entry->ecx = kvm_entry->ecx;
+        entry->edx = kvm_entry->edx;
+        QAPI_LIST_APPEND(tail, entry);
+    }
+
+    return head;
+}
+
 int kvm_arch_init_vcpu(CPUState *cs)
 {
     struct {
@@ -1981,6 +2021,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (r) {
         goto fail;
     }
+    if (!cpuid_data_cached) {
+        cpuid_data_cached = g_malloc0(sizeof(cpuid_data));
+        memcpy(cpuid_data_cached, &cpuid_data, sizeof(cpuid_data));
+    }
 
     if (has_xsave) {
         env->xsave_buf_len = sizeof(struct kvm_xsave);
diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
index 7f103ea3fd..94d9184a84 100644
--- a/tests/qtest/qmp-cmd-test.c
+++ b/tests/qtest/qmp-cmd-test.c
@@ -54,6 +54,7 @@ static int query_error_class(const char *cmd)
         /* Only valid with accel=tcg */
         { "x-query-jit", ERROR_CLASS_GENERIC_ERROR },
         { "x-query-opcount", ERROR_CLASS_GENERIC_ERROR },
+        { "x-query-x86-cpuid", ERROR_CLASS_GENERIC_ERROR },
         { NULL, -1 }
     };
     int i;
-- 
2.31.1

