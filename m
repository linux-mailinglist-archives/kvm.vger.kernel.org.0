Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC073AB042
	for <lists+kvm@lfdr.de>; Thu, 17 Jun 2021 11:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhFQJxB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 05:53:01 -0400
Received: from mail-db8eur05on2104.outbound.protection.outlook.com ([40.107.20.104]:5984
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231294AbhFQJw6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 05:52:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=naALHfHJpByDSBI1x4L7DtMZ1JKvihR3HqUh/cLCKo6WFQEiMqu7NWJg1a+7/W+vi3kpcqJfECAkXJLbv0pzcLeuVROpZCukxI/34aK7HY4WseKS5XpsjKqmrDk1KRXKYXk42QYin074w2dJwwP5owTYAIurNIVG7FP5qfg9kfirPaKll6hSgXz4rde3qnl4TqexYU/ovhaVAlUzsylRWRVu8QUCXpOfPrB/EC+bMzAjdLBNxls1t8Ij2kaUyLJcfXshOXzYnm+L2tPgDGN8+r/+UU2ZuhGmTjGAhw686aZhU/PH0TXB+T8WZgiLGKsWuX7n2dkesVLer50CA+StUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NMogps9S4/BHjtnHOFcSEoy2Mue5q23e4PjW2rBwEA=;
 b=f1Y8lbTm2W6Y6gIsgZxKx1n9dfNOGx8H8mMQMVsGh+RWkdsx8wM95iXdBHWkFUpobugAUomOWtPB3+ahbVSAqEIRiUUttRJCnoNcl6kL3H9b/YRTIkJDlmuFczMOj8Dc9OE/9CY2u747Q1yeGlSfhEtuodIdDuLobs8NqwDXEnoNQUMkHp2K09EoNFRGg+dor1MO5oYEpkqDdwgZB/5HE62Jcp/dHH9Vz4aHuW9q0H86AvJB7v7FtY6c8/5IxAFTtoyI3+iDcYEX0oAt4vySDCS5yRPR8KrdUCnSTzHt+7pH6Hk6lSPAmAL7P/eFb05G8EQgIFSznFUrOn5gWwka9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/NMogps9S4/BHjtnHOFcSEoy2Mue5q23e4PjW2rBwEA=;
 b=G6MDoTH0Jpe0+N5d+kcSnugdBKn055Cs1qR7VFMojPxi+U3tq6tMiEf26EOEw3I72TObO9s4VEVD+RYS4sidp2RpxqF86Vz37jQKZS+voSrq/1c0l+UxaoYKekjhw4xUWfgfUqUKf11axW+nuMEhlpXw7ByMORHYnUG4vsh4h5M=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM0PR08MB4611.eurprd08.prod.outlook.com (2603:10a6:208:10c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Thu, 17 Jun
 2021 09:50:48 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::c6c:281b:77e6:81b6%6]) with mapi id 15.20.4242.019; Thu, 17 Jun 2021
 09:50:48 +0000
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
Subject: [PATCH v10] qapi: introduce 'query-kvm-cpuid' QMP command.
Date:   Thu, 17 Jun 2021 12:50:34 +0300
Message-Id: <20210617095034.7506-1-valeriy.vdovin@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [176.106.247.78]
X-ClientProxiedBy: AM6PR04CA0011.eurprd04.prod.outlook.com
 (2603:10a6:20b:92::24) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (176.106.247.78) by AM6PR04CA0011.eurprd04.prod.outlook.com (2603:10a6:20b:92::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Thu, 17 Jun 2021 09:50:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dde9d095-18f8-4d74-222a-08d931756270
X-MS-TrafficTypeDiagnostic: AM0PR08MB4611:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB4611E7499E135BAD6BD6A94B870E9@AM0PR08MB4611.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I7Ij6RY8MkUWXL1VgOl35mWmEa5bgIhhpoLtdm6dc9dSn95mVXHczlMfdJJ5J8qtRQG2t9HiAIpRi+Yff2cgVuLsLz39Ozk/p/+4wZKflUduV43EMkWmWBbrDs8ieF+7+OWOoiYzu4GjygWPGdXCUq1BMFpByAixUr8hu0MBlBvDh+3jAoUXMeKK6b4IOmOpJeff6DLMuQLC/tU4AtIdFgdFvddpjGYjhVE4sNZz5PcxgLAXK3NWcSEzWislAO58VR9Vxzj+YwpO8IA9DOCZrhc54V9Hx7NGbgXP/46XEpM+a1Vj/WidGSOvRulZagU36pnfAhHCRv0K3SwBpYcb7dhAHbvquzQvYmkU1bCIImS8tGInmwvz5qPObql+/dUlj10G8olqr2PBNocMr1XzQNCOn0gEEvHy0GQy6RPjpuVVdEyN6ywCzfBb93xMw7vVdzKgZoxZ1I95bFCQleGM4Q00FPDn8dc/UQ/DH39Rsc1s+ee8gFDuUlM45TRadDbqZ7YyjPFFIYH1QwWiT4oixpIwHs4zRGw4EK8+8enW8i0aourg0KIyBSeaty4MBpM/augOCcUDyqbhAoQqSW7fbHZdf7DF7knFVrtXxuAYsJ2RNCLHg8SdTfbBqz5/dBwFdPDImxDWMuo60Sw6SS6tTK5Segoad2+7sHbRjrLsybVv3Mux0Br0KCjUAZtRB3YzuyxsjOQS4awjs1EAlKTyQKM/zYmVOW9Ae6tHXWzJ7Jleg/EDOgq5L09pblA9CzZ8+FTVjPFFXzG0D6UKAYCKybyVwxFowul3rN1P2rsroLs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39830400003)(52116002)(16526019)(7416002)(38350700002)(8936002)(38100700002)(6916009)(66946007)(186003)(83380400001)(8676002)(6486002)(316002)(54906003)(6666004)(478600001)(6506007)(956004)(966005)(4326008)(44832011)(36756003)(107886003)(1076003)(26005)(5660300002)(2616005)(6512007)(2906002)(66476007)(66556008)(86362001)(69590400013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d8FfCg8M+8Po6TekeudlKKPQDZuqPuXuLXPD52NhUGdvZIQd2G6X6TbeU1aM?=
 =?us-ascii?Q?raa7f/G/inBkjS56MwK4nKVqwnFpKaEp3vzV+4gRX78cvVM/+Qs7ffcnhhv1?=
 =?us-ascii?Q?6UmyekKIFGVFpTbG+ghcVyrRSVhaIwnldE5i4CQDTFlskJrbGo8/esVnq4Ix?=
 =?us-ascii?Q?FSr/i5wvlQHxGG3C67fLsu9wfOHZVug4JCg2kgOHYwlNtPSsa9ZQTS8FWPgN?=
 =?us-ascii?Q?n5I4Orwa8HsnfdlCvNFHFFn6gYL1ri+iuUClNp1xCLgkVwHtLaW1KMvYNPgd?=
 =?us-ascii?Q?V44iij160MeyfLoSUxAdAuTK/XRNWb725iufIFJ0zmGpLYQ9Wr6pn5tnJ1Ju?=
 =?us-ascii?Q?P/WbWHJrzWARVrh+nlxKO/8FnPu67dJGHSDd8+16O/bUuBfUJZ1Ou3FDHgEZ?=
 =?us-ascii?Q?0ad3zRKu3LkpaP3ag5zW2vSVIuin+gE6SJrlWLvFh5CnBxCX8/2USTi6bVzJ?=
 =?us-ascii?Q?/5OLMyLf/pq218DMflFtkj1l956TuhhtyclYQAv5Vevvv/OYdgeS4TAqtE7k?=
 =?us-ascii?Q?r+t0uK6hAeWsp3zqLr1aFbKusaWXKAcvnbEZqLSLTSZ25T+8/tByhkpnOGNz?=
 =?us-ascii?Q?Yqlv3SjPJsFV2t2mUoUxsWMWTo+2KdOKL86pA26z1jb9mOUdJUOk7Dcmmx6y?=
 =?us-ascii?Q?1sNZ+cEEfczCFJUHz2k0OO+kIuBNabaGifE2uHffGNtBVsMb4iWyPiuaOuzF?=
 =?us-ascii?Q?H0C9ywG94r6V2O3uymJu6OC+GQexTquFviHj9ZWYzPMq7EZDfjXVzpi5k25a?=
 =?us-ascii?Q?9+prtYfURl4eo9oY1uOPGWEIURyWY5J9aJrMOs7B3/0mVkaIhaecFHKyCU4+?=
 =?us-ascii?Q?+85SJi8vr9GM/ZdchqMhMiR5/io4oyd8HeYNo8FgBBaeBErxjL5I0Uwp5+1b?=
 =?us-ascii?Q?LZzOhuS4EnM1N2q62iOXrHt2tEFMIbP9gDTRPXiZyFKLbB4g0s/RMQCJINBw?=
 =?us-ascii?Q?2Bz2h2mQYr2qHY7EwSicid6kGKkB+GDr+0dUMHPwKZ9T5Ro4PBkeeg5lLvBa?=
 =?us-ascii?Q?x0xoGBxcoeQjE6KyS7vr3mZnztSvpTMlW26c+Ska99pgUVIy4nIS5Sod+/lB?=
 =?us-ascii?Q?AQhuAkXDKe+Qb8hA20irKQPSaLyDCgxLNCOmgU5w+RQxwGZyPAMm4RTVWsYF?=
 =?us-ascii?Q?kfVbq5uY9S51rek4ziL9g49r+sXUapSbRXUjn/Iq7lCl1j4hTJS3YSXu2a3w?=
 =?us-ascii?Q?EdDXSWD4IK06TKd9gJ+kfgwPxULJQgrnTexE14WMTzco5dv6PtTJtAmM+4Gt?=
 =?us-ascii?Q?KL7JPbL8AvP4qwU5xUwYDuGOdUOrLAPfAgGCanqmjXMx/o2zANiwnfMgDT8m?=
 =?us-ascii?Q?MIKCJp23JZoFS8FiLISgKeF+?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dde9d095-18f8-4d74-222a-08d931756270
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2021 09:50:48.3908
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ghsQSEuSiswOnteC97AxaSqPHfk5x3l3snuN8641ajdrCZ0bg/0IgGkMltrw9nKN6uCBIWHxqAlpSt5qP1U4cxuC/AgPISj0+KLlAnFBAq4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4611
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing new QMP command 'query-kvm-cpuid'. This command can be used to
get virtualized cpu model info generated by QEMU during VM initialization in
the form of cpuid representation.

Diving into more details about virtual CPU generation: QEMU first parses '-cpu'
command line option. From there it takes the name of the model as the basis for
feature set of the new virtual CPU. After that it uses trailing '-cpu' options,
that state if additional cpu features should be present on the virtual CPU or
excluded from it (tokens '+'/'-' or '=on'/'=off').
After that QEMU checks if the host's cpu can actually support the derived
feature set and applies host limitations to it.
After this initialization procedure, virtual CPU has it's model and
vendor names, and a working feature set and is ready for identification
instructions such as CPUID.

To learn exactly how virtual CPU is presented to the guest machine via CPUID
instruction, new QMP command can be used. By calling 'query-kvm-cpuid'
command, one can get a full listing of all CPUID leafs with subleafs which are
supported by the initialized virtual CPU.

Other than debug, the command is useful in cases when we would like to
utilize QEMU's virtual CPU initialization routines and put the retrieved
values into kernel CPUID overriding mechanics for more precise control
over how various processes perceive its underlying hardware with
container processes as a good example.

Output format:
The output is a plain list of leaf/subleaf argument combinations, that
return 4 words in registers EAX, EBX, ECX, EDX.

Use example:
qmp_request: {
  "execute": "query-kvm-cpuid"
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
---
This patch is next version (v10) of a patch with a changed subject
Previous subject: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
https://patchew.org/QEMU/20210603090753.11688-1-valeriy.vdovin@virtuozzo.com/
Supersedes: 20210603090753.11688-1-valeriy.vdovin@virtuozzo.com

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
v8: - Renamed qmp method to query-kvm-cpuid and some fields in response.
    - Modified documentation to qmp method
    - Removed helper struct declaration
v9: - Renamed 'in_eax' / 'in_ecx' fields to 'in-eax' / 'in-ecx'
    - Pasted more complete response to commit message.
v10:
    - Subject changed
    - Fixes in commit message
    - Small fixes in QMP command docs

 qapi/machine-target.json   | 44 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm.c      | 37 ++++++++++++++++++++++++++++++++
 tests/qtest/qmp-cmd-test.c |  1 +
 3 files changed, 82 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index e7811654b7..e9ac7a334e 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -329,3 +329,47 @@
 ##
 { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
   'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
+
+##
+# @CpuidEntry:
+#
+# A single entry of a CPUID response.
+#
+# One entry holds full set of information (leaf) returned to the guest
+# in response to it calling a CPUID instruction with eax, ecx used as
+# the agruments to that instruction. ecx is an optional argument as
+# not all of the leaves support it.
+#
+# @in-eax: CPUID argument in eax
+# @in-ecx: CPUID argument in ecx
+# @eax: CPUID result in eax
+# @ebx: CPUID result in ebx
+# @ecx: CPUID result in ecx
+# @edx: CPUID result in edx
+#
+# Since: 6.1
+##
+{ 'struct': 'CpuidEntry',
+  'data': { 'in-eax' : 'uint32',
+            '*in-ecx' : 'uint32',
+            'eax' : 'uint32',
+            'ebx' : 'uint32',
+            'ecx' : 'uint32',
+            'edx' : 'uint32'
+          },
+  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
+
+##
+# @query-kvm-cpuid:
+#
+# Returns raw data from the KVM CPUID table for the first VCPU.
+# The KVM CPUID table defines the response to the CPUID
+# instruction when executed by the guest operating system.
+#
+# Returns: a list of CpuidEntry
+#
+# Since: 6.1
+##
+{ 'command': 'query-kvm-cpuid',
+  'returns': ['CpuidEntry'],
+  'if': 'defined(TARGET_I386) && defined(CONFIG_KVM)' }
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7fe9f52710..a59d6efa41 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -20,6 +20,7 @@
 
 #include <linux/kvm.h>
 #include "standard-headers/asm-x86/kvm_para.h"
+#include "qapi/qapi-commands-machine-target.h"
 
 #include "cpu.h"
 #include "sysemu/sysemu.h"
@@ -1464,6 +1465,38 @@ static Error *invtsc_mig_blocker;
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
+struct kvm_cpuid2 *cpuid_data_cached;
+
+CpuidEntryList *qmp_query_kvm_cpuid(Error **errp)
+{
+    int i;
+    struct kvm_cpuid_entry2 *kvm_entry;
+    CpuidEntryList *head = NULL, **tail = &head;
+    CpuidEntry *entry;
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
index c98b78d033..48add3ada1 100644
--- a/tests/qtest/qmp-cmd-test.c
+++ b/tests/qtest/qmp-cmd-test.c
@@ -46,6 +46,7 @@ static int query_error_class(const char *cmd)
         { "query-balloon", ERROR_CLASS_DEVICE_NOT_ACTIVE },
         { "query-hotpluggable-cpus", ERROR_CLASS_GENERIC_ERROR },
         { "query-vm-generation-id", ERROR_CLASS_GENERIC_ERROR },
+        { "query-kvm-cpuid", ERROR_CLASS_GENERIC_ERROR },
         { NULL, -1 }
     };
     int i;
-- 
2.17.1

