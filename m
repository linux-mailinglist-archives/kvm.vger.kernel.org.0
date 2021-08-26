Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E45B3F90AF
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243757AbhHZW17 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:27:59 -0400
Received: from mail-dm6nam11hn2214.outbound.protection.outlook.com ([52.100.172.214]:9051
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243741AbhHZW15 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:27:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vwo/dxYc7V1MeNHaXfi+vsuv5zfT+2M4TQy6nrrjmUkVGHCTRT0iosQSzECAX32z0rPnJN4pgWxPAftBJMRKT2nAaWlKKqrTM3jTv4tqNQZHbDQVdrY5908dRNt8T1rD7OHKXc4tGwKo4o3AF6bjDq/JX+7P7r7VD8iZxw27P0fIkfTKWnBrlealxiqZfsq43RLSfsdTgZZ259apdtiLbo+JKHNJgB89cGVJzXXAvIVxTu0tUFupFHfyRXa65n0DB3nUhgzUk1swgJtoTZxQTW/GzUfHcBd59o7JL1cGbP3s0UqTIw0zmOq/Vzck7g6zidWRm4NjaqNwZIfgLiTcSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AINeXt4JL6rLvM2kc+eJBxIf24grk+YWdOJHS+kPyiI=;
 b=H/zR4L6goJIT73jhiM3ebbRZ7PH+yC7o11kfLcbsvRZ0yCbrYNcTlg5T/CS72E520xrVj4W1o+oOtiZoMZq0mZIsC27SOKD4/7Zq10ExcyCuUuucXmTsXsjNGioKwck1EcCLTz01Zu9uhH8XTaET+g4mpU21zT11G1zcq0g1Iq3aCAlytAPg2Ax/fHyBO5oFSVxb8+q/rtWEobw/KqB424Sj2nfG0p3lGxg1H+FK4vkXUefV3o7mm0fZJQbUEDbqlZmCbopS7dNHkliIt7PlsOfmCsQBk4nPXjdss8FN5xzlsIMK4MjCz5UO0wMAW7L+EUE8ioe3TxLO+cCRv7D/gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AINeXt4JL6rLvM2kc+eJBxIf24grk+YWdOJHS+kPyiI=;
 b=xczVXvj+kuxj/6oad3FdjWu2OOMR5/ko/bnuX6wF/LN7WsJeN/UWrzkMIN25apstLyp58cCUXC0jhTF86iQ3l6Gq4XQKWIk28NvMPdchNk92Tk5BjtkNmw1UcID7KgWQMHZwDUNK8Mes3gelOkFYQnrccvNKrsZ1QT3cu/u7Ysg=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB4293.namprd12.prod.outlook.com (2603:10b6:610:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Thu, 26 Aug
 2021 22:27:07 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:07 +0000
From:   Michael Roth <michael.roth@amd.com>
To:     qemu-devel@nongnu.org
Cc:     Connor Kuehl <ckuehl@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>
Subject: [RFC PATCH v2 09/12] target/i386: allow versioned CPUs to specify new cache_info
Date:   Thu, 26 Aug 2021 17:26:24 -0500
Message-Id: <20210826222627.3556-10-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN7PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:806:f2::23) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SN7PR04CA0018.namprd04.prod.outlook.com (2603:10b6:806:f2::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Thu, 26 Aug 2021 22:27:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4d802d89-6ba4-4fba-d299-08d968e0a355
X-MS-TrafficTypeDiagnostic: CH2PR12MB4293:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4293A015DABF4B1F40B184E095C79@CH2PR12MB4293.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2I3JaCcLtzSLC62FE6lNTV8U9nAUYt5TY1/yndmraqGixe7gFhsr4c07vIMR?=
 =?us-ascii?Q?ZDwB7OZBIJ8Lf48ucBrgKyNL/0RY9RVYICXE7HiEBog86+c1td3S+Y+mtErB?=
 =?us-ascii?Q?7nEMSaPa3c3TFexmm+eWP437cHAnHz0Aar7iVjSpAMlK7o1hovQROoV3qSob?=
 =?us-ascii?Q?tDomlQgJF3iO2YBdI7NDoa7j2xd9wmaAdWx2Q3oWKbxh0kZ+NLzBBVVldmp7?=
 =?us-ascii?Q?bePXhPOdDL5DKyuuGvu772I53vaFAfyvT7TPi+OPrAySus8E0gG7MP+t5LaN?=
 =?us-ascii?Q?2jSDJASLIzVsddtDuZ9Py3EwfNFJ2/DY0hu6mHQTQ8Hjfx2UXRQ1naf+rrBv?=
 =?us-ascii?Q?oCvjgk0MntR2bReuOd0wn1IE47pBoQSwza6Z7T+gZs/gxobpU46VzkYMcVls?=
 =?us-ascii?Q?jhj/Q4XXEfu1imBB9Utlm4fTEt4QLP4misjW7OkW1ybWN7ujsaHwMzYGIlEB?=
 =?us-ascii?Q?gV2y35X2K31cgJhYSKt+nUSuzuwTObuyrwxSkpSJSoLj13S9IrUA9gCiZ+nI?=
 =?us-ascii?Q?l9effZbzpzvIDj7+8FHufOQnPASH/hULA7Q4F3qM5PT7O1vPf3LM0MGFE88u?=
 =?us-ascii?Q?9T4JmqyPLwBa7nAWNzyI2BUY2OWfoe+on/LLXDUZULDpYCEL0VrtDCJY6Wz8?=
 =?us-ascii?Q?8h/kZXnURUcfCzhGp7Iw7USybS2KhgnG8/jwzrjqZz8QSaT+6JNF35dg/yke?=
 =?us-ascii?Q?g4mEXYB5CzYvSZtUk9K2VlR71NRJGjpClRqaj3rhMcvdgkI7Fwax27YYV980?=
 =?us-ascii?Q?KkrkN0m+8LcV/LIP8s6IGs7D0I/PY/v9aUC2WVkJ6fqbnFkP/ps/R8QdcUJQ?=
 =?us-ascii?Q?zq6glH1rZQXeFLvFnHP2l08+u2TkMHN67QPyasH7OSuZ9lSKJHkoj6u7uJK/?=
 =?us-ascii?Q?GDDg+Mxsdl6AE99xqRAy/oJqqvADk+kkFDzAdHuFn3FIrOuiby6RSsF2QCbE?=
 =?us-ascii?Q?prhdmbf4aQMKbVFcPkw/onUQgPyQQKtxXYJv6sEhto0EbHUpNFIaxHIMmIGK?=
 =?us-ascii?Q?MfGAqMb9Q5tOnTX0cdEfcozhBAi5O8hwlNUJON6KtGwW7ms=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(366004)(38100700002)(38350700002)(508600001)(6916009)(54906003)(66556008)(66476007)(1076003)(2906002)(5660300002)(6496006)(8936002)(52116002)(86362001)(316002)(186003)(6486002)(6666004)(2616005)(4326008)(26005)(83380400001)(66946007)(36756003)(44832011)(956004)(8676002)(7416002)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iQe56Ny+wWkxF0aPxLPegwdaMPKwg4Zyf8tBVgoyVpwYk8mzl7aD1zFmVQn+?=
 =?us-ascii?Q?ZY2WubfDfXjxwGQh9C9zyD35iP7x0U6V3VUetG9NV/ML68XwpzTb7TYv00rt?=
 =?us-ascii?Q?Ng036mFxAST5Knlqr0JHiZ+tl7ey1wVIx52YHiXarRYLp/RzXraedTycAyJQ?=
 =?us-ascii?Q?bg5/D5EcYseGEFudbGbrt2YdkoRzX6NZUb4hVMOj30jINc0uDx/o3oVZ/k1v?=
 =?us-ascii?Q?yypA0wrFcoO5UNR6xRIpIzNXxdShnV9lAliehfT3S/RU7vJkN7BwOgBY8frp?=
 =?us-ascii?Q?uXrFdTJyY8lH5wJBdAP+nDPnlt8Sw7lS8yjZWjMc90Xks7mnqY/4pmp3PbNz?=
 =?us-ascii?Q?tzBK3dPTE0io6KTpLQR8bNBYtQ9YIRwwanoGMKR2uN04afkXdAcZQGF2el1e?=
 =?us-ascii?Q?587QXsV1uOzH9akK2uKqkpMsX5LnsHPq+uxePJA7wFc+2SzAIKNlc5ox2Dqi?=
 =?us-ascii?Q?WBOKEQKvS2lxQ2E4HL9+jZDKdDFwRjY3HBKB7CahkuVQETOF1BVTjXhSjUuc?=
 =?us-ascii?Q?6Ybq/auFtMYan6JxGa7uVkJflLMf8wOsFVLLWt/CHYYXY62NudKgfmY2VYFl?=
 =?us-ascii?Q?jy9BSOyzYTTPUNjOtfDZm7vy0beEnT1BjEyHODKZrb8OBkPG5fIpcON8vOq3?=
 =?us-ascii?Q?P30TvH2+7raJdw+597qfYI9geIVpQORXXHtfSNk2YmzrGXbO156PL7msPGcw?=
 =?us-ascii?Q?xdLgnb5M6O0s6ciENh7tsoiv2t+kFXbaxrNDkkP9jkXOW55Uls/lI8Z9LiY9?=
 =?us-ascii?Q?UzRAVamAm7Ve+MwJqlSkzL2vgY5FVGjCSfRwKzhsZq8CJM+R3cBQbT0G0WkE?=
 =?us-ascii?Q?57kzKF24UkqUMiu2cPtYgFt7ykAKi7etpdRBgBOImhUq5i47dZ5dJjpsvKHL?=
 =?us-ascii?Q?0ba0Is89BR3urLojrNZVDd5+QFDTJkBkRw7qWo5lie2CAZCuF3Wlwihc6Yvj?=
 =?us-ascii?Q?r0fiLyxFH+DSTu3LnrAR9uiI5WcL8rqfwsSdbczKz9U1tkkU/EFc9tIGvXmY?=
 =?us-ascii?Q?sjdlG2DevYTRAwUvMhbliOYxuQfUJs5aKVCQbov3IRrAsiDST3LtqnhdV7cV?=
 =?us-ascii?Q?x6/hshHGYfeUDyPTM5WmkvOwufEK0IrodbHyp3n9+JvB3CbVX9Wza8Ga/BqV?=
 =?us-ascii?Q?lvllplaIkOsYyRcij27n3sV99f5vCbqPzplUA3knemK8VJzRzifHM3ZFAnNf?=
 =?us-ascii?Q?qynipef2A7bSKCQH7ToXG97HRVUwNTc7e2z5G2hAEbKg34p8Pa8LXMk76vSl?=
 =?us-ascii?Q?I4FfVKrUv8Osl4uZPeE1i8VI8HnfF61+BOuOADj3bAkjqFY9zQPIVJMGw+IK?=
 =?us-ascii?Q?NL2Cahj8NqYXp7Rp0FKn1C8R?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d802d89-6ba4-4fba-d299-08d968e0a355
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:07.4508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +d3go2orx/l6cReyVCl//T9b17QP/XUgKYEhO8/cnKzSC/3ca08hMWEffT8NG3rY/fxy1bDVbN6YQEb5pEKZuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4293
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

New EPYC CPUs versions require small changes to their cache_info's.
Because current QEMU x86 CPU definition does not support cache
versions, we would have to declare a new CPU type for each such case.
To avoid this duplication, the patch allows new cache_info pointers to
be specificed for a new CPU version.

Co-developed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 target/i386/cpu.c | 36 +++++++++++++++++++++++++++++++++---
 1 file changed, 33 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index f0b441f692..85d387163a 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1458,6 +1458,7 @@ typedef struct X86CPUVersionDefinition {
     const char *alias;
     const char *note;
     PropValue *props;
+    const CPUCaches *const cache_info;
 } X86CPUVersionDefinition;
 
 /* Base definition for a CPU model */
@@ -4975,6 +4976,32 @@ static void x86_cpu_apply_version_props(X86CPU *cpu, X86CPUModel *model)
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
@@ -5007,7 +5034,7 @@ static void x86_cpu_load_model(X86CPU *cpu, X86CPUModel *model)
     }
 
     /* legacy-cache defaults to 'off' if CPU model provides cache info */
-    cpu->legacy_cache = !def->cache_info;
+    cpu->legacy_cache = !x86_cpu_get_version_cache_info(cpu, model);
 
     env->features[FEAT_1_ECX] |= CPUID_EXT_HYPERVISOR;
 
@@ -6234,14 +6261,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
 
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
2.25.1

