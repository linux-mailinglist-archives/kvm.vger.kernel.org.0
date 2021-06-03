Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CA2399D70
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 11:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhFCJKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 05:10:53 -0400
Received: from mail-eopbgr140119.outbound.protection.outlook.com ([40.107.14.119]:26885
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229506AbhFCJKw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 05:10:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iuBXMRg64J4fh1eR7d+/SZrjLpApQ7Wyjd8BALxX0wF10ngKV7+RTs91pkatGIIPJvtGsIykXuoHCFSnS4gASP4TcUHotLLMsd35tBpG4TVYYaNTWau+Rvz/DAv4XnU867cE6tFtsIj7BcgfzPhKhnXH7AkgRFPG9ezNz8L8aCeQk5nCRhJfSU0NYEkfqlFtiyg99kGTr9eK6iQMzxZUD5NrGLV/5iWqQXwJ5PeFzzL1jqZ6W1xx6ak/svFtgn8EEquCmYmuZmrWVwctWwyvAsYeQFt6w0UX5Oqd673xFKTUJomRq+jSH3GjfPi1YFijXD5zc/f44t9bBn9CuLoClQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpyJ8uuEVkGHa9pmH1qKU8+qSBkMF9gFNLe/yYyxjtw=;
 b=oL7tIFGyc5hFFQl2lB/GPp3nyzYEwoJO0F5Xe7Nq7THlu9Dp7gfQH4522sNSM/dO3zHyPdh09JIi8HRhzdWApw0Oux+R4I8OcXnSKQHpTW9fZrUqpsrrvFQQGW/5UUcKpEzOLO0iPf1aAdJRRza220HTTDLe8reqFThE7Thiq/b60WH5bpc+Jsvp12gsPQd69jgG7Z0M8M+eK0As1DsYMWpTt0qsNaBgQFebMWOhBrr3ZDIAlQdZP30ejMJrFZ+IgLV1tjBUuk1tc6T3eZuErhGkX/Xhxs2W8IHQ8OHMKAB857vtQfIOLFDPPdakLyKgXHAepO97Yo3PONbe0rmw2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vpyJ8uuEVkGHa9pmH1qKU8+qSBkMF9gFNLe/yYyxjtw=;
 b=F2xgoaL2oX18NsJTnrlrPrnayPZbDsT6+4+BLqmedngwxXZ05zQIDps/vGcIn+fsOVS/ge4/ySedbyP6PQ6V0mL93ML3vryAUXeQnmjeOHPMW9QJeU1wdbbOYyoq2fwiIUUX0lVVdjvcs0enY6YxpT/9ecJxmREBMVX/cT4ZfMI=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com (2603:10a6:20b:283::19)
 by AM0PR08MB4130.eurprd08.prod.outlook.com (2603:10a6:208:132::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Thu, 3 Jun
 2021 09:09:05 +0000
Received: from AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f]) by AM9PR08MB5988.eurprd08.prod.outlook.com
 ([fe80::7d3f:e291:9411:c50f%7]) with mapi id 15.20.4195.022; Thu, 3 Jun 2021
 09:09:05 +0000
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
Subject: [PATCH v9] qapi: introduce 'query-kvm-cpuid' action
Date:   Thu,  3 Jun 2021 12:07:53 +0300
Message-Id: <20210603090753.11688-1-valeriy.vdovin@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [176.106.247.78]
X-ClientProxiedBy: AM0PR10CA0026.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::36) To AM9PR08MB5988.eurprd08.prod.outlook.com
 (2603:10a6:20b:283::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (176.106.247.78) by AM0PR10CA0026.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 09:09:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 483690ab-8118-4d0c-a526-08d9266f3ca0
X-MS-TrafficTypeDiagnostic: AM0PR08MB4130:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR08MB4130C992C3BB6C262C896990873C9@AM0PR08MB4130.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 69NN4nrYZut1GMNngy+W7/PuOmDir1Afq/fvi8Vv1OZV/LhsdQ4DViM7zKtTt9mB5S1rcmhOaCkawXcqylq0lsvdt6MXSyE0t4Prbk95mZBygnKRp/qcMjJubELaRcliU1vZsfURrsfvQxbNecyHcV+cYrugEVLl+MNrSixGLSdB7Ry1eHkM2bvOlKYAUoBehnSPiDYmAtizRUaXyLBtpOlrjVeU3eIft4Pbdq5isC4/IQE7iVhvzg4ZDufWomwtrRDPtYIRN6QRb26A4e6NpSqCvCbKqQrqf/bi305FOdIzTVzK8uzw83O9InXv8GV9m6tSwPwiF1N+/zcq5/Opcjl/eXv6079jQ6C44FRSrftbxbG9+HMyheLUyWjhyBuX5NOXuKSTIHAkwSC5sj1HZCBCttZt81wbTpjsr50VukxOievpT0WvrPL5mt1JErwjtnb3uxB00eK6LRwh41t7JXBG3RG/Vc6X8ZwGZL0VnPtkQ5ESbdDfPvQeeKW6chDfrEnYZYmy77KvvgkyX8dNk5IHVlmRP6KGne7Z7H27MsTf8Kic31pp8hxsreJjoBMxmxtFYOpBmC40XfRr3hB2pioXEhmaltCA0GsDQEWBNPK6ps8ETyOGRbpMD5xRw27B3l3O9MfHaiT2N4dR0qiPACcdIDtAa90zQa9x1+nt97k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB5988.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(346002)(39840400004)(376002)(6512007)(5660300002)(4326008)(186003)(8936002)(1076003)(6916009)(7416002)(38100700002)(2616005)(38350700002)(54906003)(44832011)(6506007)(36756003)(6666004)(16526019)(956004)(66476007)(107886003)(478600001)(83380400001)(6486002)(8676002)(66556008)(66946007)(2906002)(52116002)(316002)(86362001)(26005)(69590400013);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VxEXd4ePEpXIwQTaMz/BugjvzmRFCS3s8wrLU1ebodfKinAoqdQcChabr/D+?=
 =?us-ascii?Q?NzLd+8CIevEeQtn2mK3eGGvjjzFPGP4pqOWWe1z+YKhGilpe99OcKxWjT0Pn?=
 =?us-ascii?Q?cfvsZzC0EYXx+aLSA52yKOskgmIiE13l55b1iVc+0ZBJWlEC5JuQzzX539VA?=
 =?us-ascii?Q?dtp7KsnzL4y4nSIDl+MEUZLwzruKi7oQyBteb0lRD8vFJQ+q9K0mQLAolgnE?=
 =?us-ascii?Q?hgU55j9rVe6C4axGxSFd6FgGDeYzzgzZWa7P1oXFe1x4GAuQLML+5gsX7A7R?=
 =?us-ascii?Q?g6nVcrEfmOD/2/anWI/trSQoIawTLp86FUbGUuLAvvYf5aRd+UMoChgQCDtn?=
 =?us-ascii?Q?DifEZ18D1SJhdlIieePPbQXnN90kExu/0F+2Iv5nP4uZ0jF8L8QcFJQqNZL8?=
 =?us-ascii?Q?EDH8NwVZLjPVSw2dFDmmxk2SLHRE5o71YefeEbaVfquor9u9dA+s5iPfGL2K?=
 =?us-ascii?Q?WpALKOdUI3Rcg1Yt/b/HCWiY8c9xhc/sfdS2Sbms4Lf0uMxyWLmLe8dmyYzb?=
 =?us-ascii?Q?0IrL6pZx7etgybzfnpXC3Wr9iD2eA1tvU9mArkmv/6pNWoKD3d5dKcsno5J0?=
 =?us-ascii?Q?jqRy3PoXuuT8NGiwl0o+NYBQeiajRsGuKUpkbDwhs7+UHPfg5D3PLNo2TMcp?=
 =?us-ascii?Q?Za2JvQYADsD6ztdXXmfB3UStOl9eVGlYyyQwQXy7K5Yr7mulMRntqHPtynxS?=
 =?us-ascii?Q?xrm4hv8UQGPkonOJLHt4BU/fLccyKe0fo1t4Nv0f6AVs93UPIYxwFnLFEcoz?=
 =?us-ascii?Q?X0OysdQoRRIgJydO2rrmi3CjN3+1p9hBHFPWW0v4vGyeWDUkJAg4VqwZuyRB?=
 =?us-ascii?Q?4Oz9iuGv5M1jteHZvkaHB4H+/Q6mWqgypFfmBZzrFSHpufj4JGsfLord1RSL?=
 =?us-ascii?Q?kssuB9YHj+dRUVJtGn6XYwQ+ypO2k34SsK7Gp4QDwMwIiV6fNsw5ND0xHCKW?=
 =?us-ascii?Q?PiPstMli6ZIteXqvhsEKn3kVSl2M1gbr/t0vJfWdSMNlpZ9Wlf0amDeQdXcZ?=
 =?us-ascii?Q?4Qevd6DsaYhq4VCLPjrUZ+AB2xLpqz+k05W1Rst1m+zsJJdOQLakSiOFaG+X?=
 =?us-ascii?Q?neKMaq/7+Ni6jc6N4Ugy6gzK5dmQzi/aH8E9qi6UHzPMzvpmh1YDKLLGz+ni?=
 =?us-ascii?Q?ZDtG++3Wo81VXLSOtzSoSCEKmE5jf1STJj0y/KLYaWzrbb7sfsJGU7Ug5MFm?=
 =?us-ascii?Q?U90hI8MCxIMzrp9w8ncI7S6j9xgDbUUdhiP+edvrNlYdma7o7lws4VLmFqs0?=
 =?us-ascii?Q?XKVHQY5jKVTIk/NgNub1NI8YaAKZDIwXSFIXJg5jg55f3VBI7YqFOFkXoTDU?=
 =?us-ascii?Q?KfJSAFk4m4zWQcNnv+qilmt4?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 483690ab-8118-4d0c-a526-08d9266f3ca0
X-MS-Exchange-CrossTenant-AuthSource: AM9PR08MB5988.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 09:09:05.1605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SHVLGJwVKpUvtinNuOIRoohS1vIsOqjq0jfS5/Fv6k/3VGgDVkRNN+U1k6IbxYlJ7+l9ZkIjX0ZZ2GjAAuqL7yAX3CcYriTlDaU1iBHLATY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB4130
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introducing new qapi method 'query-kvm-cpuid'. This method can be used to
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
instruction, new qapi method can be used. By calling 'query-kvm-cpuid'
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

 qapi/machine-target.json   | 43 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm.c      | 37 ++++++++++++++++++++++++++++++++
 tests/qtest/qmp-cmd-test.c |  1 +
 3 files changed, 81 insertions(+)

diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index e7811654b7..1e591ba481 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -329,3 +329,46 @@
 ##
 { 'command': 'query-cpu-definitions', 'returns': ['CpuDefinitionInfo'],
   'if': 'defined(TARGET_PPC) || defined(TARGET_ARM) || defined(TARGET_I386) || defined(TARGET_S390X) || defined(TARGET_MIPS)' }
+
+##
+# @CpuidEntry:
+#
+# A single entry of a CPUID response.
+#
+# One entry holds full set of information (leaf) returned to the guest in response
+# to it calling a CPUID instruction with eax, ecx used as the agruments to that
+# instruction. ecx is an optional argument as not all of the leaves support it.
+#
+# @in-eax: CPUID argument in eax
+# @in-ecx: CPUID argument in ecx
+# @eax: eax
+# @ebx: ebx
+# @ecx: ecx
+# @edx: edx
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

