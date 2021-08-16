Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF67F3ED742
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239386AbhHPNaf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:30:35 -0400
Received: from mail-dm6nam12on2053.outbound.protection.outlook.com ([40.107.243.53]:56800
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239895AbhHPN1a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:27:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X0iyhJklMGPyTu24xKbqOOOOalaeubNz3u7gm9wp1ein7HJi/S4cKCldlVq8cF7dzSihLUrqBctnpO7dmmW6XOP+dpDSKJaduzTlmjtUV62vuolRRxDkA229EPjFLpxAqhP+lyyKhc2N4wzm0NIAlrrEa5PP0pc4+av36d9rd0zVAsdlH1P4po3BwuQ+DTLUyBjiCV9VUycUEwApv04tlASfGxOmbOFoK2PlBbl3CtcphXq5mui4aSJO9Wp4N5oO9kIZ1xmL0UlGAEZrG9O+PTK7KURJxxXM7DLz+aAkco+iv20lW+MsDB3G88di/22MExo2wSPOc2m+Q6e9YmTVgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2/vfiKGkBZh7xqG6K++PpK/aGCYKc5ObEunM5vU8Bc=;
 b=aJ0W7GFub4CT/n6eXlDP3gtYsSDhV5e+zhHi7OEbmTwuwOF4mSv7GI6ay2E4tHRhukKY+g6rSb+0/mVKxuIdK3u6v3isHm8DiDyTHVTD7ULn4PmHWfSco6TZXA8PwX13sf3Z/WBKvz//O/pm42WXA+8VFTFyYxgIO8iKkNlC1ivKMxeDGDst/pXIqNQ0zVnpAl4OLhHo2lSf1XqBpkK2eKA/hp6kfnXcQY6BjC6fpJR/W8i/Qo1buoqKq9WIWh97E4rf4+NfNzvphsQ5UgASkLVqBXN/Fe3J9C+dPAYG3rqVBfCTEFQpHCxNOEkq4djek1C+hs1o8kcmR2IlDDGsPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z2/vfiKGkBZh7xqG6K++PpK/aGCYKc5ObEunM5vU8Bc=;
 b=gYw+gsDhujUTRABntbCxjyFTvLC79fNs8oe6BYANjCZ/iNaVXIY3qyQfy6JDmsHxyM/2svJdEL2ytpbCES4bs03l61HGNMuI6HMnA+9sRGo6I0URKevSJGwiPeILTm7S09tL5HPEypZte4L7z3Ka5Hoto1RnokfsgJOeIqrpCMs=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2829.namprd12.prod.outlook.com (2603:10b6:805:e8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 13:26:56 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:26:56 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 01/13] machine: Add mirrorvcpus=N suboption to -smp
Date:   Mon, 16 Aug 2021 13:26:45 +0000
Message-Id: <235c91b1b09f11c75bfc60597938c97d3ebb0861.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:805:ca::29) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR16CA0052.namprd16.prod.outlook.com (2603:10b6:805:ca::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend Transport; Mon, 16 Aug 2021 13:26:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b1c7611-0478-4c98-b57f-08d960b98494
X-MS-TrafficTypeDiagnostic: SN6PR12MB2829:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB28298C9143A778680589D3578EFD9@SN6PR12MB2829.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: keR5MjWXwpeRQK34KdYB94cgnGtwTKxehpzHynMxP0PmaKHZ8fHJYsCjSeGzNfE0QJqoMs7G/ImMrg/LkVhMlrRz2nhatEpu/9SsD+ulupPxs1HAMDjOVGauMXoI4+FWhCLSv4BEvUM1qfvlnpCno+52uyr5b/bn8MpcDMcmqfwGrVN2ML8m6ZdmrBnocIIaFG3zMWPfGnS2pR0z+QauPg+JJJ5228qZh1BZNJ6FkFokQ8OOZ6JILp1uZdFpaF4ujMYQmtavx02DeabD9BOc71XAjf/OQwYOcfvE/ZylxYqr/Ba9bmwgAv/BYk6bH6aVr6Uqdq33tnz5+GZ3bhCX5Mh0oI3x3m2a4bMWM/B2+8OTvP/DKRXdPYx/2AexVpfQ9UYXvtLkSlw8i6DXZCHCSg97oer+uIjc9+WaqGKyZfAf0OzYbeRHGCfoPutQ75wQXDUX1XQjsL5s2CLjFa+B3R2kBsJN+HVPLcbyxnubwUKWv+RbnkG5kfmgZNwW/gv64dYPYuHsoBoZhuCIsexLL8Qjep6r9ueIJDZuMfd+8a8EbJ2BWsDbOwukj36F8+qpCpZnDA2HIFqzuLFiN3/LTC09QpBBLLeVAacjQYP/qMCpoPS+SHOGQbHC9s5yvP3QVDB5jORf84JKc2sXlCOKvPdvDKR51FgpMqz97euWyNhY36wvkWNdzSldoUHM4JVPqe+vvnvY+64XnzPapNn5ww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(86362001)(7696005)(26005)(2906002)(508600001)(6916009)(956004)(5660300002)(6486002)(66556008)(66476007)(2616005)(66946007)(316002)(36756003)(6666004)(38100700002)(38350700002)(4326008)(186003)(7416002)(83380400001)(8936002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rrL6hSm4/JmB8fBVCfAfaCeTWzZm9qwWb7/gjAgBiAdaAFRpIkOO9dFsJs6b?=
 =?us-ascii?Q?LFiiglAP33rwlrLcU4nPoCX2W2Si8uPa7lenbtsLCDj7pVs1WEW6j43qiyYk?=
 =?us-ascii?Q?7HvAxK9+4Sceb6Jc7qviNadA51UuTd+NmQ1ptzaHB6CNZpKaoV5qPpSvp9Fi?=
 =?us-ascii?Q?lELbQYk0+dOF8AmktcBKGeC4uBXVXOBfBvSCNW+WOgYAg8/GYB3LoA+GNTWo?=
 =?us-ascii?Q?Z99jSyuMfKMXeTj3A9C/HvFZNlmvnIRum8tX+jJwgDQ9vbhF1HbtZMUf3ESh?=
 =?us-ascii?Q?4RjAkpHAkHAL891ZpcF6Omb4SzSgDNvRkIRvq5mu+jxLrKUEsKTDIKwwykMp?=
 =?us-ascii?Q?tMIdiiXxdy6J+nTshxaj4QRQ6k1S5hQjUdGWpFDB7FjmnXeqdEpyjyfMfmJH?=
 =?us-ascii?Q?/YW5f2AkdlLWxBV0QjDmwMrvash4Ai8dEEVJdCa+MnBizBgjp3HvlWlqR7m+?=
 =?us-ascii?Q?xm0Ak83t5XbdG4ApmN16tzAeQ56tDNPthIDEL1esHtzegPRdNPAERCyUfNFg?=
 =?us-ascii?Q?L3SkSiALfgzdl6xdU9dl6E72MaGLVH2WmO/k6tgm/2mdJ1EEQ+LGG5nR4UwF?=
 =?us-ascii?Q?HJPydJBHF1K4ntgO271iTemQl5ZCxONHfj+KzSVfwQI62/9gJNSL06Z+IF5A?=
 =?us-ascii?Q?WC3JO/g1Tw5Y2xjC33KBshmfnpTv2KzbMJnYOuEACOegZiQNrXRWJvZ6bSVe?=
 =?us-ascii?Q?YSRFH03hSfro8vOz2yT4n5ThZU7/qdE5ZOWGzBjIVtz1A2qJHqKhHOLqQGR8?=
 =?us-ascii?Q?jMVYdFoHYsk7mp5Asb32kv9CBYBu++8KTsMgYKeaNM6TfoYHM/MZ3mXQxg4Z?=
 =?us-ascii?Q?ckselGw6i7uezJzbUNQ0Z1n9NluKb7mP0ONliNj5/NG1E2yBunitDlR9yaYj?=
 =?us-ascii?Q?XcND0ajNJnsz8Tzpx2y9QxydFCbJYnxnH4mfTqpCkM/TVQElGMKE75G9vq+n?=
 =?us-ascii?Q?kcL3xKhYVWRhm4AomS5nLJonYTPsaPqYYgbQxRbGrVGOceLVQYBblQmnj8HV?=
 =?us-ascii?Q?sEBoAocEvwe9c2RHi5QmqbBvCnGb2fBhH00RJyD7DWT2GG5CTdkYwQbttxTP?=
 =?us-ascii?Q?pzOqlkmfNtzQrmnAKZ4nAwIgh/Rt9O0jRfRe1IN7wLTp0bNmS2v6mZDZS/fx?=
 =?us-ascii?Q?fvW+zINRr9cB+4aBobQ2Q5ylgWqJaxbarR5b/uRgz/eXJ/gXxT2EAriyaUC+?=
 =?us-ascii?Q?A262Ryrg5MfcHbzHXHkyvWwakkCM2bJ+7NMlJ1NIr2CKjMqRqFOUPX23FYqR?=
 =?us-ascii?Q?xPYasu/m4NY9xEvkoq/pEs10sA5/mUswTX4H7kV2HQmbXCMQkyk9xwwXO/nR?=
 =?us-ascii?Q?EwxiwWeW1kMY0ixYrgUFglTJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b1c7611-0478-4c98-b57f-08d960b98494
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:26:56.1349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 50KMEQTtfwaAyZpPZrBZJobqckz8lIr9V4XDN1SWnBfE9G6LGv5dcngbmQwtJznit6ukmmBHc00SZ13jg4LnSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2829
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dov Murik <dovmurik@linux.vnet.ibm.com>

Add a notion of mirror vcpus to CpuTopology, which will allow to
designate a few vcpus (normally 1) for running the guest
migration handler (MH).

Example usage for starting a 4-vcpu guest, of which 1 vcpu is marked as
mirror vcpu.

    qemu-system-x86_64 -smp 4,mirrorvcpus=1 ...

Signed-off-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 hw/core/machine.c   | 7 +++++++
 hw/i386/pc.c        | 7 +++++++
 include/hw/boards.h | 1 +
 qapi/machine.json   | 5 ++++-
 softmmu/vl.c        | 3 +++
 5 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 943974d411..059262f914 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -749,6 +749,7 @@ static void smp_parse(MachineState *ms, SMPConfiguration *config, Error **errp)
     unsigned sockets = config->has_sockets ? config->sockets : 0;
     unsigned cores   = config->has_cores ? config->cores : 0;
     unsigned threads = config->has_threads ? config->threads : 0;
+    unsigned mirror_vcpus = config->has_mirrorvcpus ? config->mirrorvcpus : 0;
 
     if (config->has_dies && config->dies != 0 && config->dies != 1) {
         error_setg(errp, "dies not supported by this machine's CPU topology");
@@ -787,6 +788,11 @@ static void smp_parse(MachineState *ms, SMPConfiguration *config, Error **errp)
         return;
     }
 
+    if (mirror_vcpus > ms->smp.max_cpus) {
+        error_setg(errp, "mirror vcpus must be less than max cpus");
+        return;
+    }
+
     if (sockets * cores * threads != ms->smp.max_cpus) {
         error_setg(errp, "Invalid CPU topology: "
                    "sockets (%u) * cores (%u) * threads (%u) "
@@ -800,6 +806,7 @@ static void smp_parse(MachineState *ms, SMPConfiguration *config, Error **errp)
     ms->smp.cores = cores;
     ms->smp.threads = threads;
     ms->smp.sockets = sockets;
+    ms->smp.mirror_vcpus = mirror_vcpus;
 }
 
 static void machine_get_smp(Object *obj, Visitor *v, const char *name,
diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index c2b9d62a35..3856a47390 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -719,6 +719,7 @@ static void pc_smp_parse(MachineState *ms, SMPConfiguration *config, Error **err
     unsigned dies    = config->has_dies ? config->dies : 1;
     unsigned cores   = config->has_cores ? config->cores : 0;
     unsigned threads = config->has_threads ? config->threads : 0;
+    unsigned mirror_vcpus = config->has_mirrorvcpus ? config->mirrorvcpus : 0;
 
     /* compute missing values, prefer sockets over cores over threads */
     if (cpus == 0 || sockets == 0) {
@@ -753,6 +754,11 @@ static void pc_smp_parse(MachineState *ms, SMPConfiguration *config, Error **err
         return;
     }
 
+    if (mirror_vcpus > ms->smp.max_cpus) {
+        error_setg(errp, "mirror vcpus must be less than max cpus");
+        return;
+    }
+
     if (sockets * dies * cores * threads != ms->smp.max_cpus) {
         error_setg(errp, "Invalid CPU topology deprecated: "
                    "sockets (%u) * dies (%u) * cores (%u) * threads (%u) "
@@ -767,6 +773,7 @@ static void pc_smp_parse(MachineState *ms, SMPConfiguration *config, Error **err
     ms->smp.threads = threads;
     ms->smp.sockets = sockets;
     ms->smp.dies = dies;
+    ms->smp.mirror_vcpus = mirror_vcpus;
 }
 
 static
diff --git a/include/hw/boards.h b/include/hw/boards.h
index accd6eff35..b0e599096a 100644
--- a/include/hw/boards.h
+++ b/include/hw/boards.h
@@ -286,6 +286,7 @@ typedef struct CpuTopology {
     unsigned int threads;
     unsigned int sockets;
     unsigned int max_cpus;
+    unsigned int mirror_vcpus;
 } CpuTopology;
 
 /**
diff --git a/qapi/machine.json b/qapi/machine.json
index c3210ee1fb..7888601715 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -1303,6 +1303,8 @@
 #
 # @maxcpus: maximum number of hotpluggable virtual CPUs in the virtual machine
 #
+# @mirrorvcpus: maximum number of mirror virtual CPUs in the virtual machine
+#
 # Since: 6.1
 ##
 { 'struct': 'SMPConfiguration', 'data': {
@@ -1311,4 +1313,5 @@
      '*dies': 'int',
      '*cores': 'int',
      '*threads': 'int',
-     '*maxcpus': 'int' } }
+     '*maxcpus': 'int',
+     '*mirrorvcpus': 'int' } }
diff --git a/softmmu/vl.c b/softmmu/vl.c
index 5ca11e7469..6261f1cfb1 100644
--- a/softmmu/vl.c
+++ b/softmmu/vl.c
@@ -710,6 +710,9 @@ static QemuOptsList qemu_smp_opts = {
         }, {
             .name = "maxcpus",
             .type = QEMU_OPT_NUMBER,
+        }, {
+            .name = "mirrorvcpus",
+            .type = QEMU_OPT_NUMBER,
         },
         { /*End of list */ }
     },
-- 
2.17.1

