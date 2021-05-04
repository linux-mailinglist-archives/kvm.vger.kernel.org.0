Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01557372A11
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 14:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhEDM1w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 08:27:52 -0400
Received: from mail-db8eur05on2133.outbound.protection.outlook.com ([40.107.20.133]:27872
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230335AbhEDM1v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 08:27:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7+BD5wdiOZqrbp6UFcM//sdMozu9RvKvgO+g5Y4G0QdheAPKqsZ8MFeqY0wKA613ODhhyI4GK3uzCXOVKvNv/855padBUpYZL588Ydy9TmG+pSFZtDYBp1OoltiUwzC1UzZfIW9liyJovLI0RWhRQ+W/XRvNapNg/On7yX/GwDizLru9DDKWnCoq79Z/+0WT4u5X255tTLHVu/J5zNQhQEeIh3cb5m3GpwYcp2VLYwkbRJqgJHWdk+Dqz+HlcnnjeWXw9g47mZPWyNdR8rVZSEB8LYsJgKZlKGXqJ5c/oztUdvBfzLmMd4tZav6pt7Wj3Oysdk3eXDAiWkxxd4o6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyKdb9RB858dBu3Xc9FpJzvVe1/Dzs41jGTz3K/xyS0=;
 b=Grzm25ehsaLxu8atVy1UvCB43kOVET+prCvAAr9D0YkhwGgEXloG08DJ7PNe8p6jqlsOlk5b0FQ4bVsEEikARKcJAVY4ncw2pEvnFgwVyoPplW9U+zOrEn2mOxJbMyLrAm/7h8bPyQT1N4HEz3OLz+x0akDdEdPMVIhLYNQoN8Mc4rYpP+GHY4nOSL+YVhj2XopvtmzAnBMncdRmGAD9ZULK6yesvjjtT/2J54Ubd+RDMVV/kqrJhylmhjv660e+mo0XMsCyoJUQ/EWKNbuj0HGqJtvkqpaNNkHX9klIbggQfsuIq66hJ9FyybHPsvbrapBbDCA2WkS2DEN9ZWhEhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xyKdb9RB858dBu3Xc9FpJzvVe1/Dzs41jGTz3K/xyS0=;
 b=JsQ2Jru5l37fWetc0+CQ2g7caRk0q71OvvLF+fX9FAHFvk2o6dPhXq0a0P6DqHF/Bd90LEBfmLSq8HBkzImd3X8eeAsk3T3cvbppwfTw/yci/ljLArzyAzrwoP9AclxfrSOY8iWGRdg/sXmP1kjRntwmIRx5Sp9KP6p4Udq0XVU=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM0PR08MB3860.eurprd08.prod.outlook.com (2603:10a6:208:10b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.40; Tue, 4 May
 2021 12:26:55 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f%7]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 12:26:55 +0000
From:   Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Subject: [PATCH v7 1/1] qapi: introduce 'query-cpu-model-cpuid' action
Date:   Tue,  4 May 2021 15:26:39 +0300
Message-Id: <20210504122639.18342-2-valeriy.vdovin@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210504122639.18342-1-valeriy.vdovin@virtuozzo.com>
References: <20210504122639.18342-1-valeriy.vdovin@virtuozzo.com>
Content-Type: text/plain
X-Originating-IP: [176.106.247.78]
X-ClientProxiedBy: AM0P190CA0027.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::37) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (176.106.247.78) by AM0P190CA0027.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24 via Frontend Transport; Tue, 4 May 2021 12:26:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d66b66f9-f320-4fd0-33fa-08d90ef7e737
X-MS-TrafficTypeDiagnostic: AM0PR08MB3860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB38608F5F3BEF81EF4D5DD1AF875A9@AM0PR08MB3860.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6sWe/01D1LKwLICbOxscjcLwEkQBaA6jLlavQ6oHUvuz3BIS4mzZc2xxNgx5/It1ZTbtJDb6TWNmNZju8N8k5+eIkGW6xEUqoMCfy4NIv5gQNuYq4KHB7/tDZlyxkwy59dZ2KRnzZ8AC20Gsi7y3WHOlE4hatu2PUXuhU2gv86zfk5vy45nE/bMioH1Rzpuh2NqNKfyQSO24BW27jb7qj92yL0KxcdhpTs9o/3jh7Ct761JtPcl+W26KC1fBg/yKb8CaRNA+5KAy2lVZYeCfy2ePuzM0/eavxsn7/VD6YWEt2aFiN087G0TF7jYvMsmGLkVI+mrWGt4R9DLNRS8hDuVoqwxMuHmLrd746Nq/tOoMuTV+QMG2jhjmV/eTEhDPRlexg4yJTpj/+HiRLuI+GyF8dRE1PQTRN/hk4dU6omFefeNANGSL7OO3W5DdpTvtrf3/iyQXzmRcNJ09+ZgG7M5Z2tvcpsyvvM4RtpcR1LXRIRQZPwo3hE51jsOTuue/lL4QsqeS2KdL3rRVCpPZlnxqaDha7kZ4UwgKppp11EMBtQXsq6mk9S35sleJZw6cFio5zACMb7bGq1BE8u0LkVIT8JTkbqFFwrYpxyq/jt4qt/ztYIfL8wG+u0KfV8Fyu2vwGItJwjdANBD8/FFcuNTrIiAroXZmxnedb9TlDcG9i7cQTRG9WRfZP0nHE5X
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(396003)(39830400003)(366004)(186003)(26005)(16526019)(36756003)(6916009)(7416002)(956004)(8676002)(6486002)(6512007)(8936002)(1076003)(5660300002)(6666004)(2616005)(44832011)(66476007)(66556008)(86362001)(38100700002)(52116002)(6506007)(54906003)(38350700002)(2906002)(83380400001)(107886003)(478600001)(316002)(4326008)(66946007)(69590400013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?nql+L/2h0aSoDyJlAkggTdQa+phCZQNpZBjJ8NkP2pSLWHvKiplEsd/v9Ino?=
 =?us-ascii?Q?K6ZZTm/t7SiyzwdBiHXmniMeoLHxQ/rBRFkuh24O1+nVsW+vAQU9hboFC8uW?=
 =?us-ascii?Q?R9wrbOdiJg7fiN+mlhkSv+OQ/KmL+CNAu66bnnPqf58hFIAieVTXBZSJkLDz?=
 =?us-ascii?Q?O5zW4vHS/yW6M0KzKsaBcOC2i2EgIqmcw8MxIHpdpgPyRUpoNi++PbbAOvAI?=
 =?us-ascii?Q?Uf+S1CfxF7+OZ/m2anMaSjGFl77lbl8MCsEC7478kVb7uaxzaz2yLMC+Ld6y?=
 =?us-ascii?Q?9HikDoU5ZQLu3LfVAxxq5dTzY+zoiCQdgkTUCS5PUp33PkQfxDrxqchfqg9g?=
 =?us-ascii?Q?eFNJdG4XKwVUwGp2R+yJCTXmKLxq3m0hhcv2ozej5wVOuQPY5AvOThPZuNUA?=
 =?us-ascii?Q?te+SarCfmCo1C7wXdfky3hKuWRdYJRySuLXAkwiSOwR9F8EF33KHHlS8Ccfn?=
 =?us-ascii?Q?/VPAfBlpX1QW+9Pd94Ix+tcK//rVz5yr17jS+U8X73Hz7EeYU5iUVR39H84H?=
 =?us-ascii?Q?N2KEll4ldLtrTlPiWmkHu+im285/Xd6ER6d9us6c4bRNf/OmocVi+ss1QxCM?=
 =?us-ascii?Q?d1LSM2auw677+51UOtFpdOAuNNlrAzJ7R71+HMM2Sn+Kw0ecngM5B01+cAKP?=
 =?us-ascii?Q?iAvdOGtzUa5KRD4kskv3X/XFRusYlnYS5Mty9PAChoFr2uDH/2TuPU1hLFIH?=
 =?us-ascii?Q?pheIeELBHhm7NviwbKNttZwyGdjooIoFo2iKQD1JJXUdk31lUpzQrI7DUFWQ?=
 =?us-ascii?Q?b+tzlXI8BcF7zeraZbXIJufjBPQt0SElFPKled312OgMAnaqj8pvCanP/gMJ?=
 =?us-ascii?Q?gfZfMETPrtwkfzrZotQcVITkSdkKMWwIJp3/bLbACU2rS8qXhd6WEpsQYTyl?=
 =?us-ascii?Q?feQ86N7Dg6YCwV0VZrWjisP9/M30nD/H4ifPc4b9JU4dYnOKB3paHpvKefpI?=
 =?us-ascii?Q?7oI07TbWGoKJvv52Z94bohKeI1ECjzAZpDh57C1W5F2WtNoTJThGIlXIzy3Q?=
 =?us-ascii?Q?55plNX4nz9mweAw3HXs3kJ3OY7U5W8ZQzjPEk6n6ZhsT5DDD91hsHLfCkWMW?=
 =?us-ascii?Q?owfb0rXqlnCEKzWZ1UB4LHGcEXf1bABPFaagyQH3zyflLJqwuKQdTiqBB0Fo?=
 =?us-ascii?Q?Zy2lqbd5R1nOsqeLcVdOkvmTFlLqCMbjSCKjgPSE3W/esZFNkC2Fp2hT5iFU?=
 =?us-ascii?Q?CYKkWsEZwJiT6jBhpQkgcPyFyDKAhhc4bGMU1wEwrbXKTaAKEQITQ6SGEz8x?=
 =?us-ascii?Q?2tj2ND7PoLUEFMtZ7QcFjr53/CRCaMW25JF1r4R49TYZs4aqgdcXrQfzRcSW?=
 =?us-ascii?Q?L/gDuH3AxhtCHXgEF7wiUgq4?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d66b66f9-f320-4fd0-33fa-08d90ef7e737
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 12:26:54.9805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uUI7zdmxIXx31OIbiIQFYn+oeE+CtNPsnZ+3O7munxlFVmt0uEzSvxxrMgAYnnrF2zddNRgexaZE5XaulGBfUa7tYHhG20JrOm7jxw0Nsf0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3860
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing new qapi method 'query-cpu-model-cpuid'. This method can be used to
get virtualized cpu model info generated by QEMU during VM initialization in
the form of cpuid representation.

Diving into more details about virtual cpu generation: QEMU first parses '-cpu'
command line option. From there it takes the name of the model as the basis for
feature set of the new virtual cpu. After that it uses trailing '-cpu' options,
that state if additional cpu features should be present on the virtual cpu or
excluded from it (tokens '+'/'-' or '=on'/'=off').
After that QEMU checks if the host's cpu can actually support the derived
feature set and applies host limitations to it.
After this initialization procedure, virtual cpu has it's model and
vendor names, and a working feature set and is ready for identification
instructions such as CPUID.

Currently full output for this method is only supported for x86 cpus.

To learn exactly how virtual cpu is presented to the guest machine via CPUID
instruction, new qapi method can be used. By calling 'query-cpu-model-cpuid'
method, one can get a full listing of all CPUID leafs with subleafs which are
supported by the initialized virtual cpu.

Other than debug, the method is useful in cases when we would like to
utilize QEMU's virtual cpu initialization routines and put the retrieved
values into kernel CPUID overriding mechanics for more precise control
over how various processes perceive its underlying hardware with
container processes as a good example.

Output format:
The output is a plain list of leaf/subleaf agrument combinations, that
return 4 words in registers EAX, EBX, ECX, EDX.

Use example:
qmp_request: {
  "execute": "query-cpu-model-cpuid"
}

qmp_response: [
  {
    "eax": 1073741825,
    "edx": 77,
    "leaf": 1073741824,
    "ecx": 1447775574,
    "ebx": 1263359563,
    "subleaf": 0
  },
  {
    "eax": 16777339,
    "edx": 0,
    "leaf": 1073741825,
    "ecx": 0,
    "ebx": 0,
    "subleaf": 0
  },
  {
    "eax": 13,
    "edx": 1231384169,
    "leaf": 0,
    "ecx": 1818588270,
    "ebx": 1970169159,
    "subleaf": 0
  },
  {
    "eax": 198354,
    "edx": 126614527,
  ....

Signed-off-by: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>

---
v2: - Removed leaf/subleaf iterators.
    - Modified cpu_x86_cpuid to return false in cases when count is
      greater than supported subleaves.
v3: - Fixed structure name coding style.
    - Added more comments
    - Ensured buildability for non-x86 targets.
v4: - Fixed cpu_x86_cpuid return value logic and handling of 0xA leaf.
    - Fixed comments.
    - Removed target check in qmp_query_cpu_model_cpuid.
v5: - Added error handling code in qmp_query_cpu_model_cpuid
v6: - Fixed error handling code. Added method to query_error_class
v7: - Changed implementation in favor of cached cpuid_data for
KVM_SET_CPUID2
 qapi/machine-target.json   | 51 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm.c      | 45 ++++++++++++++++++++++++++++++---
 tests/qtest/qmp-cmd-test.c |  1 +
 3 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index e7811654b7..ad816a50b6 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -329,3 +329,54 @@
 ##
 { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
   'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
+
+##
+# @CpuidEntry:
+#
+# A single entry of a CPUID response.
+#
+# CPUID instruction accepts 'leaf' argument passed in EAX register.
+# A 'leaf' is a single group of information about the CPU, that is returned
+# to the caller in EAX, EBX, ECX and EDX registers. A few of the leaves will
+# also have 'subleaves', the group of information would partially depend on the
+# value passed in the ECX register. The value of ECX is reflected in the 'subleaf'
+# field of this structure.
+#
+# @leaf: CPUID leaf or the value of EAX prior to CPUID execution.
+# @subleaf: value of ECX for leaf that has varying output depending on ECX.
+# @eax: eax
+# @ebx: ebx
+# @ecx: ecx
+# @edx: edx
+#
+# Since: 6.1
+##
+{ 'struct': 'CpuidEntry',
+  'data': { 'leaf' : 'uint32',
+            'subleaf' : 'uint32',
+            'eax' : 'uint32',
+            'ebx' : 'uint32',
+            'ecx' : 'uint32',
+            'edx' : 'uint32'
+          },
+  'if': 'defined(TARGET_I386)' }
+
+##
+# @query-cpu-model-cpuid:
+#
+# Returns description of a virtual CPU model, created by QEMU after cpu
+# initialization routines. The resulting information is a reflection of a parsed
+# '-cpu' command line option, filtered by available host cpu features.
+#
+# Returns:  @CpuModelCpuidDescription
+#
+# Example:
+#
+# -> { "execute": "query-cpu-model-cpuid" }
+# <- { "return": 'CpuModelCpuidDescription' }
+#
+# Since: 6.1
+##
+{ 'command': 'query-cpu-model-cpuid',
+  'returns': ['CpuidEntry'],
+  'if': 'defined(TARGET_I386)' }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7fe9f52710..edc4262efb 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -20,6 +20,7 @@
 
 #include <linux/kvm.h>
 #include "standard-headers/asm-x86/kvm_para.h"
+#include "qapi/qapi-commands-machine-target.h"
 
 #include "cpu.h"
 #include "sysemu/sysemu.h"
@@ -1464,16 +1465,48 @@ static Error *invtsc_mig_blocker;
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
+struct CPUIDEntriesInfo {
+    struct kvm_cpuid2 cpuid;
+    struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
+};
+
+struct CPUIDEntriesInfo *cpuid_data_cached;
+
+CpuidEntryList *
+qmp_query_cpu_model_cpuid(Error **errp)
+{
+    int i;
+    struct kvm_cpuid_entry2 *kvm_entry;
+    CpuidEntryList *head = NULL, **tail = &head;
+    CpuidEntry *entry;
+
+    if (!cpuid_data_cached) {
+        error_setg(errp, "cpuid_data cache not ready");
+        return NULL;
+    }
+
+    for (i = 0; i < cpuid_data_cached->cpuid.nent; ++i) {
+        kvm_entry = &cpuid_data_cached->entries[i];
+        entry = g_malloc0(sizeof(*entry));
+        entry->leaf = kvm_entry->function;
+        entry->subleaf = kvm_entry->index;
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
-    struct {
-        struct kvm_cpuid2 cpuid;
-        struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
-    } cpuid_data;
     /*
      * The kernel defines these structs with padding fields so there
      * should be no extra padding in our cpuid_data struct.
      */
+    struct CPUIDEntriesInfo cpuid_data;
     QEMU_BUILD_BUG_ON(sizeof(cpuid_data) !=
                       sizeof(struct kvm_cpuid2) +
                       sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
@@ -1833,6 +1866,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
     if (r) {
         goto fail;
     }
+    if (!cpuid_data_cached) {
+        cpuid_data_cached = g_malloc0(sizeof(cpuid_data));
+        memcpy(cpuid_data_cached, &cpuid_data, sizeof(cpuid_data));
+    }
 
     if (has_xsave) {
         env->xsave_buf = qemu_memalign(4096, sizeof(struct kvm_xsave));
diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
index c98b78d033..f5a926b61b 100644
--- a/tests/qtest/qmp-cmd-test.c
+++ b/tests/qtest/qmp-cmd-test.c
@@ -46,6 +46,7 @@ static int query_error_class(const char *cmd)
         { "query-balloon", ERROR_CLASS_DEVICE_NOT_ACTIVE },
         { "query-hotpluggable-cpus", ERROR_CLASS_GENERIC_ERROR },
         { "query-vm-generation-id", ERROR_CLASS_GENERIC_ERROR },
+        { "query-cpu-model-cpuid", ERROR_CLASS_GENERIC_ERROR },
         { NULL, -1 }
     };
     int i;
-- 
2.17.1

