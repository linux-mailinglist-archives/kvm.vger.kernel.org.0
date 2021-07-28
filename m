Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43C83D9154
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 16:55:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237370AbhG1Oz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 10:55:28 -0400
Received: from mail-eopbgr00118.outbound.protection.outlook.com ([40.107.0.118]:14086
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237352AbhG1OzP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jul 2021 10:55:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hi3x1Myp8cAuiuxLNmpgQi5Pyn83BTv0QPeixrgc2/OoTSCFw5Sb+qW2A4u3a5lohVPl16S34AStUuE8o9dqiVVntJV6bBuNrMJcnjHWGxWQB8NBE8AvMcMvbHRv3/KwBIAcsETvd7rCSFNp4gJ+KkkJqOf0L6Gm5OGdXrB6cW8d7xBHc9uMYxRtRcKj/TXAtsjQ45Jl17JKGCKgdKa54zMgr7m4ihYLl3PMxCDcp5gGo6pgIk4aJJVCinfMvRDLNjUYFF0KiDA8wJxdhIPHebX1k9T+amigc7tqzXnFjVWL4r0pmQpzUxAERFEbqt6+jGWTX44N2gIBzy5b9zvxrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blojPQ1ja9lnW+TXqDp5T58KdVwDk1bbeKJqWw5xoLA=;
 b=a5r39SEgZmviZzV0iREgUArhzJKGAEbgMDbhcAvXU2LWbQlH/mzjNWxD45B2V3KIrQcKpjW0YLP2Clp55HWKoh9/DNNCHK8J8a3rGutrOe/YpPN5tCW4vdyfKsi988FWlqwVmzRbCkqSOLr9aeBM5hldjmUT0LnPlhuv3hTXOI02dtuN4+wdawzY7/EvSR1XHtTYZcW+EFaTfprwdl8mDHzFZokQZCFUTzNshU4sLu0f01UcESCL0NK30ZQ3tXcmcoiQS6o5Hz7COvsMhxpBpXhBs8wGDbJfYoNgpl4yIv7nbVzm+8pXPG870HxLXISpqUsZgRIifHVaSOc+HBt/tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=blojPQ1ja9lnW+TXqDp5T58KdVwDk1bbeKJqWw5xoLA=;
 b=a4aVZ+y5ztfM/QSQHgVrIdMcl+hHseUJxwhWKKPrbKqJhZl1XDb99NE8t1IyKEfT/lwrHz/n7jtWMg9I11Q/a0VtNB0xzvGD3WGka+9iKCzp9AdDqGplcwIZigwzzQcTsl1Q/EAd+jhozH+3X7RcSYgNCr5li6tUunjADAhJgvk=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM9PR08MB6997.eurprd08.prod.outlook.com (2603:10a6:20b:418::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Wed, 28 Jul
 2021 14:55:11 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::2d48:8cfb:a44e:f543]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::2d48:8cfb:a44e:f543%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 14:55:11 +0000
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
Subject: [PATCH v13] qapi: introduce 'query-x86-cpuid' QMP command.
Date:   Wed, 28 Jul 2021 17:54:54 +0300
Message-Id: <20210728145454.3506-1-valeriy.vdovin@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: AS8P250CA0021.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:330::26) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (176.106.247.78) by AS8P250CA0021.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:330::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.17 via Frontend Transport; Wed, 28 Jul 2021 14:55:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0fbe9ea-c3f4-4b96-bee5-08d951d7b2d4
X-MS-TrafficTypeDiagnostic: AM9PR08MB6997:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9PR08MB69978321DEF21425DF06800187EA9@AM9PR08MB6997.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Nlb4JJ7MAFT1AgRn57wvt6ANzp7zg12/a37fkbqhNoS74O9Lb23SkYa7yafpCNBA5bZtnGRPgpD7QhVN/PgSCDuIiFxq5UHDfSkpF3at+vkJ3DFPwV6VVTqkHBF3KoObpfD4xSdHkT6ebElttCUEW6ox+YXs+0V8ZH/lcn/LfwoXumrV+9TEXhYfKcOi2dGmoWIvm53V0waQBYowkfIJdahxkvL9GyswZIiT01U6D8pEqWP4BWleLhFTy6sOmTY6nW4Be8voVSe1U9wu1R7e7pzNcLsfL26S1604dlfEuYarDaIjuMZxsA1e81/Wonwx3g7ikhNgmNVelfUHsxUYcZ6Fpf7sMune+DC8BzkZZ5J1YcvKhh6qdUKCfjy1+5Lvyfehl3bPRU8B3AjOEMXvcBL4mJIxdKQ8g1yWHpHftNQ3LvbHelV4KRiR26ABSCYBKZBuhI94oZbab8AoW8HeEaIl0Qkz2BZlw58vAzTtJvJF7o3eAjrc7GH4pwZnVsqnLGnEI7NhIGx2mhZQGGyOhdZzj3OHS6cAno7ARG9h273W8q2mranEMau5gU3Go4Ix5Xyk9eaf3NMgscwwMdzWjAwL8aHpI4y1oVtW/3R0mOFirGEPvbRwSZneKmAtGRagDU8lNPuhq7pSpPBM+nEePFld59ADm2UT+mnCfX2HLdNKP2nZ6nAyYtq5qhByIDWbXqWjyd3SzeNUQubYgrhGKw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39840400004)(396003)(6666004)(26005)(6512007)(316002)(186003)(6506007)(66556008)(66946007)(8676002)(66476007)(1076003)(6486002)(478600001)(2906002)(7416002)(107886003)(8936002)(44832011)(2616005)(956004)(54906003)(4326008)(38100700002)(38350700002)(86362001)(36756003)(6916009)(83380400001)(5660300002)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GAA47iGqZ9jSdQCggSqnHOvoG/tpDP1Zpc6ByBHv4GbHR2AWhSxGCkWzm/gx?=
 =?us-ascii?Q?3S4i8AL4hvRiIT25YoGBsX5p/hjsDmoRDJxSVWCInNTdUSZLTyZzhf+Si4uz?=
 =?us-ascii?Q?xzJpMUcNVY3YW1Ic9znfRXICF6XLZ16ydpsdlBKp9BNSEcyKIKpANSCbDxEO?=
 =?us-ascii?Q?sjkrRoX+SUm6vg+7cAw0N7ltr4LZ5TeC2sZP6WE5fmyFrfy+8g0UtUe80T/b?=
 =?us-ascii?Q?5WYD5GLkYVPdPJTRZR8NeDdaBjVKaLo8fVWIfSjy8nNGH0zVNNM64ZT7bhpl?=
 =?us-ascii?Q?vYwmTtjT+Dj7MTcmsA6S+wBJit+pD6Aa/S6elWe5ig9CJR8CPGR/30kN9oOI?=
 =?us-ascii?Q?E0ubMX+uj6G7qbjvXtl11Dt5cjSKpCGHImNRJjqVmAE9Wj5xCo8B4FIfZkgC?=
 =?us-ascii?Q?ZR3XazUfQNl72lh33LhU+BLnggrXoP2oHGEray+TT94E3GOPPDgo9os4P0/V?=
 =?us-ascii?Q?HRlNL7ZNTmHA6b0vhvkXeMhl5iNS4GEP9kEp3huBYI5T5FATVVxfCXKp9hOh?=
 =?us-ascii?Q?EYycD58AErutBupYfKxOB80ZZf4vTrkegRFzbMt/fDLG21nx8TBzXHilrG51?=
 =?us-ascii?Q?TQYDVvy+IQ63Vw+yxChErex+1Na4Q2gl48bi7d3ltv0m5Ap/timvxlPB65Ye?=
 =?us-ascii?Q?ZjB5dUvhVNW0ynuIKts8F4KaSzPskYRmC06kt2drQba6fSoe3/67A76Usxv7?=
 =?us-ascii?Q?BIY8k5MJBPqKySNfFDZ+rpOB2psCuZOmu7RrtnA0qdL03LPT8C6Bi/uhk6ju?=
 =?us-ascii?Q?nAE9H2TM4xJ1dwe7H42Z2AKgLXxEQSiGy1kCk4H/18ZSUmjS3M7Egfj6j2yF?=
 =?us-ascii?Q?/IDnyz0pBCr4pOhiCA2WQiPgZSzjpN/qPAGjCWZrnoWwpCWcVpQiRfvsKyBb?=
 =?us-ascii?Q?BveRV+Ag7XsDljlokcOdmNSEk7CBBRFo0rmcqb2KhwHhLZ5l+G5T7K9XZQUW?=
 =?us-ascii?Q?4QbaG166XWQScI+Wuops7/2ucEmaNZTN0/Ehq9mny7tazLvALzkzr5JZD7FD?=
 =?us-ascii?Q?wjbgiiFxxtRSGQR/JX4FEI19iOmJXpEDLUsKEOKUq6X2IETBmn4HLxenJyb7?=
 =?us-ascii?Q?ptRi4EcSYrTuFL1pnoiih5/1KbPwTG1R/duKsbB+13jNyofl7jPu3k1Lm3qE?=
 =?us-ascii?Q?ply8KP0C+FGvsIdTEkqTS8uA931s4OC6tEbcZ3hjSLZUvGk9qFty26FRwC5r?=
 =?us-ascii?Q?0pWHf+tvP5Sd1G9wmgfcjXbqmlWzjLpB4lUotebw5DXsmF55tyPTIIp0kH0U?=
 =?us-ascii?Q?41Uva9tNEjVyfuzqgFnmwdWJt6M2rdXdVonA9WUJqQDtqzqQoFu7oeaBagpn?=
 =?us-ascii?Q?pFtHEXIUob2Z1bVDWh+PfnDA?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0fbe9ea-c3f4-4b96-bee5-08d951d7b2d4
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 14:55:11.1593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CLHTB6XAxuqaB2jXY6+wgb+QIdR6OLnZKRH0w0DQNur+K8Pas7pK4nLHR07DN5gdF8TG7bOzEnSI1QNaVO62mWZybOSD+F5/7BGA+R4lxrg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6997
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing new QMP command 'query-x86-cpuid'. This command can be used to
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
instruction, new QMP command can be used. By calling 'query-x86-cpuid'
command, one can get a full listing of all CPUID leaves with subleaves which are
supported by the initialized virtual CPU.

Other than debug, the command is useful in cases when we would like to
utilize QEMU's virtual CPU initialization routines and put the retrieved
values into kernel CPUID overriding mechanics for more precise control
over how various processes perceive its underlying hardware with
container processes as a good example.

The command is specific to x86. It is currenly only implemented for KVM acceleator.

Output format:
The output is a plain list of leaf/subleaf argument combinations, that
return 4 words in registers EAX, EBX, ECX, EDX.

Use example:
qmp_request: {
  "execute": "query-x86-cpuid"
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
v11:
    - Added explanation about CONFIG_KVM to the commit message.
v12:
    - Changed title from query-kvm-cpuid to query-x86-cpuid
    - Removed CONFIG_KVM ifdefs
    - Added detailed error messages for some stub/unimplemented cases.
v13:
    - Tagged with since 6.2

 qapi/machine-target.json   | 44 ++++++++++++++++++++++++++++++++
 softmmu/cpus.c             |  2 +-
 target/i386/kvm/kvm-stub.c | 10 ++++++++
 target/i386/kvm/kvm.c      | 51 ++++++++++++++++++++++++++++++++++++++
 tests/qtest/qmp-cmd-test.c |  1 +
 5 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index e7811654b7..599394d067 100644
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
+# Since: 6.2
+##
+{ 'struct': 'CpuidEntry',
+  'data': { 'in-eax' : 'uint32',
+            '*in-ecx' : 'uint32',
+            'eax' : 'uint32',
+            'ebx' : 'uint32',
+            'ecx' : 'uint32',
+            'edx' : 'uint32'
+          },
+  'if': 'defined(TARGET_I386)' }
+
+##
+# @query-x86-cpuid:
+#
+# Returns raw data from the emulated CPUID table for the first VCPU.
+# The emulated CPUID table defines the response to the CPUID
+# instruction when executed by the guest operating system.
+#
+# Returns: a list of CpuidEntry
+#
+# Since: 6.2
+##
+{ 'command': 'query-x86-cpuid',
+  'returns': ['CpuidEntry'],
+  'if': 'defined(TARGET_I386)' }
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index a7ee431187..74fa6b9af4 100644
--- a/softmmu/cpus.c
+++ b/softmmu/cpus.c
@@ -128,7 +128,7 @@ void hw_error(const char *fmt, ...)
 /*
  * The chosen accelerator is supposed to register this.
  */
-static const AccelOpsClass *cpus_accel;
+const AccelOpsClass *cpus_accel;
 
 void cpu_synchronize_all_states(void)
 {
diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
index 92f49121b8..27305fc458 100644
--- a/target/i386/kvm/kvm-stub.c
+++ b/target/i386/kvm/kvm-stub.c
@@ -12,6 +12,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "kvm_i386.h"
+#include "qapi/error.h"
 
 #ifndef __OPTIMIZE__
 bool kvm_has_smm(void)
@@ -39,3 +40,12 @@ bool kvm_hv_vpindex_settable(void)
 {
     return false;
 }
+
+typedef struct CpuidEntryList CpuidEntryList;
+CpuidEntryList *qmp_query_x86_cpuid(Error **errp);
+
+CpuidEntryList *qmp_query_x86_cpuid(Error **errp)
+{
+    error_setg(errp, "Not implemented in --disable-kvm configuration");
+    return NULL;
+}
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7fe9f52710..114ed76493 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -20,10 +20,12 @@
 
 #include <linux/kvm.h>
 #include "standard-headers/asm-x86/kvm_para.h"
+#include "qapi/qapi-commands-machine-target.h"
 
 #include "cpu.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/hw_accel.h"
+#include "sysemu/accel-ops.h"
 #include "sysemu/kvm_int.h"
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
@@ -1464,6 +1466,51 @@ static Error *invtsc_mig_blocker;
 
 #define KVM_MAX_CPUID_ENTRIES  100
 
+struct kvm_cpuid2 *cpuid_data_cached;
+extern const AccelOpsClass *cpus_accel;
+
+static inline int is_kvm_accel(AccelOpsClass *class)
+{
+    ObjectClass *parent_class;
+
+    parent_class = &class->parent_class;
+    return strcmp(object_class_get_name(parent_class),
+        "kvm-accel-ops") == 0;
+}
+
+CpuidEntryList *qmp_query_x86_cpuid(Error **errp)
+{
+    int i;
+    struct kvm_cpuid_entry2 *kvm_entry;
+    CpuidEntryList *head = NULL, **tail = &head;
+    CpuidEntry *entry;
+
+    if (!cpuid_data_cached) {
+         if (cpus_accel && !is_kvm_accel((AccelOpsClass *)cpus_accel))
+             error_setg(errp, "Not implemented for non-kvm accel");
+         else
+             error_setg(errp, "VCPU was not initialized yet");
+         return NULL;
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
@@ -1833,6 +1880,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
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
index c98b78d033..bd883f7f52 100644
--- a/tests/qtest/qmp-cmd-test.c
+++ b/tests/qtest/qmp-cmd-test.c
@@ -46,6 +46,7 @@ static int query_error_class(const char *cmd)
         { "query-balloon", ERROR_CLASS_DEVICE_NOT_ACTIVE },
         { "query-hotpluggable-cpus", ERROR_CLASS_GENERIC_ERROR },
         { "query-vm-generation-id", ERROR_CLASS_GENERIC_ERROR },
+        { "query-x86-cpuid", ERROR_CLASS_GENERIC_ERROR },
         { NULL, -1 }
     };
     int i;
-- 
2.17.1

