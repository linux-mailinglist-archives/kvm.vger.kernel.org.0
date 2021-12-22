Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7F747D1B8
	for <lists+kvm@lfdr.de>; Wed, 22 Dec 2021 13:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240438AbhLVMbk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Dec 2021 07:31:40 -0500
Received: from mail-eopbgr70125.outbound.protection.outlook.com ([40.107.7.125]:63372
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233751AbhLVMbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Dec 2021 07:31:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m98Bf58rnsZm1EXOGGPYSIflp5MAqHX9+1ZO6uA/Y8mfn8e0gC469LuNUQ7Bd6ssYqUoR8wPKqjYhekCWb+H5soIOVGs0VsrOYPus140+8t13fOTA54qCr5RIqzM3+kPa5u7tgniHYURD5ISu2mBczmcV0V+ekZDjo+CfSSKrEh4jEXjwm6IX3DDzgmNNZGd2H4y1Uv6bMFz1j6UlkMFLPej4i1YoOWXuvce+ykGpfKRM0p62JZlSYzqWu5De+PB/CV+lveydGL5rKt7SvcC2Hxjkun/3fbHCZdInz5MOpvGeKPAz6oeb0YGmByr/7+f/gXK05SaGgTwJdGhy4UR0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4ooxVrFi09o+VHUp529JXZtOKO8Ih6d3PpZfvzllRlI=;
 b=AsxjvMKkw6fAt5OCdCRqhTD5NIcAv+Z/xiZHDbd2ug+LnqZCmavcRxJ2YqgIfEtT26gMhf/0CroOsEhhGV0yk+hL+zmga24UwLP3OYeRODtX8l4yqjzc/WXYA3CPWSwRLPZkqmjzFN/QLq79HspxllyyT0rGfUFPkiirXvjIGJch+oM3enc4moiWKlNUZBvPQxFhpuJCXoo4HxSs/Gu+pVWBJZCduw8z38ykbxoUDKu4ob3SOh4VRRYwdJMUUItcT/sSccJLlYPOLoilVIt47/ascUpDc6ML60UQVm1+fqe685wO5mtzGIXAkUZUm4qyp5EUs26oRlFGUtCu7RqLAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4ooxVrFi09o+VHUp529JXZtOKO8Ih6d3PpZfvzllRlI=;
 b=Zxx/gjSPF2uCMnBKjFv5dsn+mhgi+F2oFn60oG4gE2ToiK+2E9B0nCavFk1zEVHFmW4EOv8ol8e6tNL3NvGT2Vntngn/fY6ESQs346KENodaOwdYnmJThtPENQDXw84L+JAQAs4FCGS7HI3INM5ybCGP2dmPokCkyYjxV4e0fL8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB6737.eurprd08.prod.outlook.com (2603:10a6:20b:304::18)
 by AM4PR08MB2897.eurprd08.prod.outlook.com (2603:10a6:205:a::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14; Wed, 22 Dec
 2021 12:31:37 +0000
Received: from AM9PR08MB6737.eurprd08.prod.outlook.com
 ([fe80::b118:483a:d003:3112]) by AM9PR08MB6737.eurprd08.prod.outlook.com
 ([fe80::b118:483a:d003:3112%5]) with mapi id 15.20.4823.016; Wed, 22 Dec 2021
 12:31:36 +0000
From:   Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        mtosatti@redhat.com, pbonzini@redhat.com,
        richard.henderson@linaro.org, armbru@redhat.com, eblake@redhat.com,
        philmd@redhat.com, marcel.apfelbaum@gmail.com, eduardo@habkost.net,
        den@openvz.org, valery.vdovin.s@gmail.com,
        vsementsov@virtuozzo.com,
        Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>
Subject: [PATCH v16] qapi: introduce 'x-query-x86-cpuid' QMP command.
Date:   Wed, 22 Dec 2021 13:31:24 +0100
Message-Id: <20211222123124.130107-1-vsementsov@virtuozzo.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0047.eurprd06.prod.outlook.com
 (2603:10a6:20b:463::9) To AM9PR08MB6737.eurprd08.prod.outlook.com
 (2603:10a6:20b:304::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 16b309f0-1db7-471c-d23e-08d9c546fecf
X-MS-TrafficTypeDiagnostic: AM4PR08MB2897:EE_
X-Microsoft-Antispam-PRVS: <AM4PR08MB2897D748E527BAA457E250BDC17D9@AM4PR08MB2897.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CxeoEHgUcThOhnC0D1MlLSk/jreiiPup3BJxOKmQxer3Irb0dztsitdGpOwyAG5H+CExDzJiA7GUAxESBcuokTe2Ti8OZrJwQMTF8BKwtrx08hRIqsFFg4Qo75kY7B15E6/VJ69mJ03fEO+vlLRh+BcsyEgQ686UOOqZZ0ykHh2OBS1kiUixid/q5X7+aifmCB4tInqKpoCqL5FH/aDGl4ODVSDg342KPgQXKyGgZhjBqW2cZK6qN62lYm07tq/my/z8Kkf8QlDKJuCRYs9xuBwB2D9FByZc6vySGWUQWEbzV1OzVA7IG3xdK10VPh8nWboOiSiCzgcxo9j5QdWQqPFjIdfVe9uEOwb12KDBZQU1/21FUbc4AoM2jBZiaMm5hY02Ebl7n8U4WvekVE+hCpF2tVKxw789YUpRthZa/gN8zwE9sjjxCB7qdGWDK5oxmcLqsrVqfDDGPY9VymfO3BjoL50JAy0/f2WUQ9DtP3B9dpufSPSHlysnHzub04qHLuoHz9KXzKWx5dLBckfKmuL+1d4nzPChy/aZlVnawvZe2QzICj1IhZmw3SoViLhDodo4xU3cttcxx+vU+YGI+fp+FxoNrVDHugbaXfMl/wvIDl7fsrjQauaUCKN9mNBW1P+MKa4i2bMwOlW8qJ8ndyBgUJmEcd8Zeph/qnfugtCt3LJuR9nqwrJ/x/6ld59efvpxZfX+wOBBQqmM/QvJ0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB6737.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(26005)(4326008)(66946007)(66556008)(66476007)(5660300002)(6506007)(36756003)(38350700002)(2906002)(83380400001)(508600001)(7416002)(107886003)(38100700002)(316002)(6916009)(6486002)(1076003)(6666004)(86362001)(52116002)(2616005)(6512007)(8936002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?aAN6plr9bVdsGlONKnFVSEWmcHWOncX+R8blspIv4G3zB8/lfTY35Cftc3CI?=
 =?us-ascii?Q?elrUTLkdv6OnWbPWPftsdiHxCnFrRgEoO5ol5rvdDD9sYJpHo1Ex4rXBZGp3?=
 =?us-ascii?Q?krayqhwE1diQJKGqQHxuLBwI+pMdUnUABi6NwZAL0QlpCV2th1gYMFpepmQ0?=
 =?us-ascii?Q?oa65fV4/GptLQ95fzCWYxdnn5ItWkRYLyXOJVL9ScquTWOxf3Qn3r7IRW515?=
 =?us-ascii?Q?blgT8y60K0ghQSVaGy7PNEVtr2xwgw/vSa6MExAqUPROPCp8zl1ZlV3/DOKZ?=
 =?us-ascii?Q?DqpwB9/HQB80Uhp7gCQy8gUuCuLywHPHZIAaYXjf/0PH6PwakMqwYjHxpadw?=
 =?us-ascii?Q?TCz8JutF1FV1mX1+2qcXn1TsV5eQG1w4zscXc0zrQ/QaIvP+IUqhiifiYc5v?=
 =?us-ascii?Q?PSQsAtXYUa06Nmat2X5vl7GK5cJdF7r6Gsm+E4FPH16+PWxve/qTmksW6ryq?=
 =?us-ascii?Q?Bc6UJKGMQseUCPrT3YJMZYzGJiSUPtjPExL/K9xjD+LOZ8BuQeLv+U0IP948?=
 =?us-ascii?Q?rSCG9CmF33SXKlLFw9VCcCtdqcYaQxmREyza+QBYDKU+r+RiCc2GVSvvteKB?=
 =?us-ascii?Q?o6G7WtuE+7CIq14aB2fyfCu1s0AIl3K9vo159tN1w0J9NaV6P8bMekA8VrV7?=
 =?us-ascii?Q?cuIeWhi64iVxj7+ZQ8Z2NnfUB7elDUCm7goCQE+0ELtFnZwp6q2ptHM5ipYX?=
 =?us-ascii?Q?9AcHfNT+f6IkDyu1k9YUZVJipOeLs55fkwydyf2QFGbZ6eNiCZ6N97GbovDw?=
 =?us-ascii?Q?LM60ZlKGvYqq98RZFiT+eulIdjBM2g3raQOpsUOMAx5T0K+ld44ZmRYN+Q20?=
 =?us-ascii?Q?Ry7ZkyLsa30hEcr8d9j7qWM4YDykJa2S6FegKgI3y5cvdTgfin7iMK5T+Y9H?=
 =?us-ascii?Q?N/uQn8anuRG0ka60ls8cFUuD8lFjdk8rqr9J4Z+NGZ292vhoDtxBFJoNv4eD?=
 =?us-ascii?Q?54SifDfz9rXHxTcmgRJohLEdFxMUe1CEPzqS0WOI74yRUI2oCMUZkPT4To70?=
 =?us-ascii?Q?6CR0E/jVrtm3B01GLjM8S3zoCa4hZ8pD5/h52/f5xo+M0Wwbc5JG2JoCasZ+?=
 =?us-ascii?Q?i32I9dK12+r/LL9WrJaJ2ce5VD4ElLkn1fooEhXB4xJES8MgYuF+gssF+Ii7?=
 =?us-ascii?Q?8WNzjwgAaO6s2SiTIQ6UGQRSzUjOc14IVc2Fl1YjrhHs/9W+iIo62PxUXXyd?=
 =?us-ascii?Q?S26/D/ehS1fotE8NnSUo/fI3vkNgba2XWnyZs4WF+qtZSHKsFh/WRZsOl/74?=
 =?us-ascii?Q?XncatD0i+5EAB186RNm493ZDikfeG+Sqjupxr1ALxqd4CYS6nxLSZ5Re3s93?=
 =?us-ascii?Q?XM+L3qmmVtA38LtzhbJaEqOWiipA6+7yQu0uGX3GdZj+t/PdXCn748S1QxmB?=
 =?us-ascii?Q?HsRxi4fbWrISIsOEtGtTe5sgB0W+p9KUr7pYLcfBCvcpL/XtX1LPC2/95uUD?=
 =?us-ascii?Q?CRUapU9/+zO8iPfUel9c8P5QdXuHHiPe2l+2gJW/QtxbmMwkvR3OwZOrlWfP?=
 =?us-ascii?Q?gQ/lRdZC6HD6liFxXMh/WE8froLam1CcUyV3ficicO1+HGXLxJpmt1O0d8aP?=
 =?us-ascii?Q?0xGdHBTAqNuaPYuHLikZAeetQpndft2cmPNn5162nZJAaNoR5n0tJvEiPgig?=
 =?us-ascii?Q?SjHgabyFakwSpvxB0H9qBglH31sBseBOOvPKPqREwocSwKXh6KuycYMT8ssz?=
 =?us-ascii?Q?Ihpb/g=3D=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b309f0-1db7-471c-d23e-08d9c546fecf
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB6737.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2021 12:31:36.7425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w5xr3iIrCaSV7KKl0O1qwQ3cG/kqkbbcUXkXCxO2X5bP03fDWPjSdGqkoqP8THLg9ocpkqf1FWojFP7ffA/14KTWFx3SrPVOXCB92qDpU2Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR08MB2897
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>

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

v16:
    - rebase on master
    - change since markers from 6.2 to 7.0
    - add x- prefix

v15 was called "[PATCH v15] qapi: introduce 'query-x86-cpuid' QMP command."
Supersedes: <20210816145132.9636-1-valery.vdovin.s@gmail.com>

 qapi/machine-target.json   | 46 ++++++++++++++++++++++++++++++++++++++
 softmmu/cpus.c             |  2 +-
 target/i386/kvm/kvm-stub.c |  9 ++++++++
 target/i386/kvm/kvm.c      | 44 ++++++++++++++++++++++++++++++++++++
 tests/qtest/qmp-cmd-test.c |  1 +
 5 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index f5ec4bc172..0ac575b1b9 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -341,3 +341,49 @@
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
+#
+# Returns: a list of CpuidEntry. Returns error when qemu is configured with
+#          --disable-kvm flag or if qemu is run with any other accelerator than KVM.
+#
+# Since: 7.0
+##
+{ 'command': 'x-query-x86-cpuid',
+  'returns': ['CpuidEntry'],
+  'if': 'TARGET_I386' }
diff --git a/softmmu/cpus.c b/softmmu/cpus.c
index 071085f840..8501081897 100644
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
index 13f8e30c2a..b7f6c7fcec 100644
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
@@ -1564,6 +1566,44 @@ static Error *invtsc_mig_blocker;
 
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
@@ -1980,6 +2020,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
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

