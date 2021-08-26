Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B805A3F90B4
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243790AbhHZW2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 18:28:04 -0400
Received: from mail-dm6nam11hn2210.outbound.protection.outlook.com ([52.100.172.210]:54368
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243764AbhHZW2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 18:28:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HN1iLeJAaPoQsdojU21/liyShiO6koabel459X/QiN3buNHmdwGVDZv3tbLZ2pTWfMojJOsws/G0kcWGD+ToGhYtluY9/3jpsyNtdDhF2wuJPGAJC2Ie2+cKkdsTwevUW3urDNZwsDYYcIV5YKCVWmNshifG3JZBfsZitN+C4laPlT4dR3p8WDG8U9oCP7QUiyFOOctApdYireOThwBWCvi6tECHjjkSAA9ZioUkN22D+uddElneXtaqVbkQSBVt5mGrM1s8/geusM9stg7Zlph7KSQRRd2Eyeb9j7ENvSlTjAzEfxhnFWMlk93+W91ZlzQIl+rCeFd8jXV6FaGrrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/wkLwzfkOgt/2bG/cujvUbHRaOsA55eoytZuC+4wqA=;
 b=ZCVBULMRwYhtx8owbPBgJYnCEKmoxf/q1BFvdr0QyLst54qSNBBYD8VUQJEluPRyjpCsDX7mNKzc6vNm9GXJpiAOLmui8dkv+YVAbyzQfrUBR91Pbp1sN/8G6Zxjg+oBxks9sucw2CcGeNjqDQNp4HjxsNbOH9QxlfPwgnLM+ZGXbhB9t5UYsz1LEqPuTP6n4eiHo0fD6BjI9XMCdSMjAa5LXCNP2jzGxv8c+gmQp5IOaR1TlbBk+ze5PbJGZeBtbtAXV7Da/hOMsbQh2PxN0hnL6ibDCdjJua4C5hosAhVlNaOS2F8JuKdKFrFVpTD+foospqkBu25Gx2wLRPrxIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8/wkLwzfkOgt/2bG/cujvUbHRaOsA55eoytZuC+4wqA=;
 b=aRA4I+MtPiLFIIlPruY+yas3xlgGOuFsypUk/zW7MjjfxMuuKp2JO1+0eOdMyt5yuU6sc0jUIjUfMvGl2f5dmpCY/RJ+4DiINxjebpit4lo1cZYdGFhmZ3Ascbz+ldGbmPQPHJCkncsuRfXSHigRppO8RWy+3A/uwCYehq/9+2Y=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from CH2PR12MB4133.namprd12.prod.outlook.com (2603:10b6:610:7a::13)
 by CH2PR12MB3925.namprd12.prod.outlook.com (2603:10b6:610:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 22:27:14 +0000
Received: from CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0]) by CH2PR12MB4133.namprd12.prod.outlook.com
 ([fe80::d19e:b657:5259:24d0%8]) with mapi id 15.20.4436.019; Thu, 26 Aug 2021
 22:27:14 +0000
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
Subject: [RFC PATCH v2 12/12] i386/sev: update query-sev QAPI format to handle SEV-SNP
Date:   Thu, 26 Aug 2021 17:26:27 -0500
Message-Id: <20210826222627.3556-13-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210826222627.3556-1-michael.roth@amd.com>
References: <20210826222627.3556-1-michael.roth@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0082.namprd11.prod.outlook.com
 (2603:10b6:806:d2::27) To CH2PR12MB4133.namprd12.prod.outlook.com
 (2603:10b6:610:7a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (165.204.77.1) by SA0PR11CA0082.namprd11.prod.outlook.com (2603:10b6:806:d2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.18 via Frontend Transport; Thu, 26 Aug 2021 22:27:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5682fe39-3908-4abd-bdb5-08d968e0a78e
X-MS-TrafficTypeDiagnostic: CH2PR12MB3925:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB39257B7A08A53616734920A095C79@CH2PR12MB3925.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?6A4VcQp/oSFycSxY7pSffXkaQZQRZ2bhRkpquDlfXXRkFYQHrKOtk+JW9rE2?=
 =?us-ascii?Q?yGuq7+mElcJrPw/ae72KZ3kfPCykQ6wUJqm7QR7lKLPu5NSq6NWQY8QdGcPH?=
 =?us-ascii?Q?GS+FXWlkwDkAfMUMN2hQN1aIOwyvr8ewKGLoP+JujL6wXO1kpXxwsQrZ4B83?=
 =?us-ascii?Q?Hfh6DVm52oBlz5TD+7yrz+RXCwSZX3sq4lTqXquJp/hcus6i58ldEP7zstAa?=
 =?us-ascii?Q?K1Y94XueOBHKIjxs0DkvB+s0trP34MImbh/FO+rOmi4qj/+z8zhix7Fi0uwZ?=
 =?us-ascii?Q?hA9vLr96bZJHMBEDCdb0yJBCCCK8PHsE7iT41OJn/VMWXv167KVTmmE5Q3g2?=
 =?us-ascii?Q?gbkct56JhdLeBnrc3nDCdsKbRjjbRp5NNn6gjg0ori7bH7beUg0tj3zilARJ?=
 =?us-ascii?Q?/atD1xVVP9rx1tHE2o2Up/dHEKCx0dp3ufDgkQmT6R7Cr95x17OY1KD3vcxU?=
 =?us-ascii?Q?2AF/RrXAuYfnVDMTOzNU08PqAlwmoFpDRLrVGl+jClL4BTXGEx4RrZgE8Fvd?=
 =?us-ascii?Q?AKbQkVgu54QPbcUpOxgzaVdr/vcYKBgdQgDg+GwYwD7DgcUecO83qKBzk40J?=
 =?us-ascii?Q?sMfn+f6R3htAJjjf4d7zkjTT5NJa/KaJkoHlg/Ir7ndDdypkdvvEfLFoJME0?=
 =?us-ascii?Q?V7R0UVuy8ob8BwiRKm4jwyqYPGYuIrGxsorTMXbytl7uTX52+7wLiCTLCmeq?=
 =?us-ascii?Q?TUK9yYh2s5ilmNJ6i3OsdOXv1o1my4GNJE1hyhLTrEJov37lsKi64nwfbMno?=
 =?us-ascii?Q?uGRVBnTC8Ed7OcKZ2cNd2UUJ7fh2WbxZwcQuFp0m4jBf93ss74PV50NuMAVu?=
 =?us-ascii?Q?tQmmcXmenf7PnxQx4ax+u8UWRWVGgYANX2TFgFVnmBtYMouxo/xnmgnd57CG?=
 =?us-ascii?Q?CHFvuwlUtKS+MlOkSY5sU2vAT2co9NewoA+Rn01oSsU72eSfWU6D37H9vgUo?=
 =?us-ascii?Q?TVbutNy1qaQiQw45TMtYDGqW7gukgWSSmrBdYJK5ylBNBMl4rJgETd8qnIVe?=
 =?us-ascii?Q?O9PCcXuh8msICpJq6yeLmbf7dtsE4hbRkphcd0/qHLFDkng=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:CH2PR12MB4133.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(8676002)(38350700002)(66476007)(38100700002)(956004)(2616005)(6666004)(66556008)(83380400001)(186003)(6916009)(478600001)(36756003)(316002)(4326008)(44832011)(54906003)(66946007)(52116002)(6496006)(2906002)(86362001)(1076003)(6486002)(5660300002)(7416002)(8936002)(26005)(15650500001)(23200700001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HYlvLfs+4hRx6MWMDCOVMFiWlZe7riTGugsciDzMw0I1YPf9B3Drhvlnnkoq?=
 =?us-ascii?Q?6KXlkPnqWFvGFnQy8ML6IM0O+N8ITxyGAqWXjqhOU/Jq1qkf2l3t2VZ8RbU8?=
 =?us-ascii?Q?NlxSFYxkL8er969HMq4WtC8+0Cc3PMduKyx2BbY3u1jOCUI6ZfgIz8dbO/Eu?=
 =?us-ascii?Q?3jyAe3V4FZFC/1bzOZUgU8sksW6Vle2xmCXH81o9PcLG4/LLHzrkR3fkNons?=
 =?us-ascii?Q?fnOBJygBpP/4rtaOzchDbTfb3NYcd+KMifluft5wVP6cMeGar07k69APj3fM?=
 =?us-ascii?Q?B+mG+9pG87H6BiYyfm+TIp6/gBlwIMijUTrVT1bKjwUrJkZfcs14/1ibFVUL?=
 =?us-ascii?Q?xu3NoBS2/zDdQmVSOD8qblchepYCvZ2TNG6kzc9IOl6A83JAD/gUmNAZ6+BA?=
 =?us-ascii?Q?X/8RpPzrrM+2OCAUQkb9lBCnmAzNoo1vckIdBqe0cML/wajzQnbkCOehyrFS?=
 =?us-ascii?Q?LJgDCc/+b+5729xbhvpRuwQW9g/yWS9I8+zClyFBGwwJO3brAiV4s+Qj8dLb?=
 =?us-ascii?Q?NcJlygoBKf0Pvs6ZNVfRabhOgkJxLnY/7qARNHAB3dVzSDDcdRgY2mixnSyD?=
 =?us-ascii?Q?ndskBqAP3SoX9laaIULXjx5bqt4zxaHKSCmz1Lt3VoYzb1do3H/HcvfB+DYy?=
 =?us-ascii?Q?EHYxmeYrMSXs3i+0gL/NZEcv9nX0gQt/m/muD+6uuW646xMeO7w8/mpZBDHF?=
 =?us-ascii?Q?dEiZke60dnT8l3O6eZtxcyciilpAmYRaQ7+VcALFj4U2GQBpeKitnOuVOks1?=
 =?us-ascii?Q?pO4Ez0NhFbAHh5Cy9F1nTH57REUnVcAba74+CofaYHqb8tmfkQrbZYhOxto5?=
 =?us-ascii?Q?LXDb6fZBw2qf1gOhqNmEjk8FpG3TcwqUSk69KoH+7MlkgtzDsx+S1oXtkEJJ?=
 =?us-ascii?Q?XHAZ0eX8eZF4chPJ1Q/3kjrP+wmGFoWZdAu2LvY0azoTRZOkc2HwER87YuNQ?=
 =?us-ascii?Q?0zzwx2OxmYlLmg2pRyrnKO7JwgLmPg+Bl4koY1n3uWwwzJYnPVqHeu+Zv8qR?=
 =?us-ascii?Q?2RV59FDk98cVtL2QIjg5cgw2x/pBH/6EljNXETZ9oWtGzHaFQic00OYThEq9?=
 =?us-ascii?Q?yMuOenSwVZddt+O8VBadZouovxBmZ0E63hrVXNNQj+Rx5fYIM3smrjzi6zqN?=
 =?us-ascii?Q?E8JVAJj2pwPMSsgBGaWDtkC0WkmvtOlu6dEPQHhFtQG/MLtx33+imDCWBO5M?=
 =?us-ascii?Q?e/lfrPPzPw0QPIMX2sIEvNk5Ab89CjZ6BwNpC8q1ZZs9HWGgUkrInlyaNXzk?=
 =?us-ascii?Q?hJ/Hn77E1KwI9b2D/xzhIgPZBl8nkWTWwcCLq+v1/SNGRy5Y3p+EwRfVQZ1v?=
 =?us-ascii?Q?BaCVD9r/W7YZA//ZOngP5AmI?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5682fe39-3908-4abd-bdb5-08d968e0a78e
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4133.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 22:27:14.4441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bm+ZOJRI499a0Nvk3qxYqik/smfyARx7SOLZrA4OvBK7VFOMvnWUuU1OO8aIfL2oOczSOZiGCVQNp3KCc37LQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3925
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Most of the current 'query-sev' command is relevant to both legacy
SEV/SEV-ES guests and SEV-SNP guests, with 2 exceptions:

  - 'policy' is a 64-bit field for SEV-SNP, not 32-bit, and
    the meaning of the bit positions has changed
  - 'handle' is not relevant to SEV-SNP

To address this, this patch adds a new 'sev-type' field that can be
used as a discriminator to select between SEV and SEV-SNP-specific
fields/formats without breaking compatibility for existing management
tools (so long as management tools that add support for launching
SEV-SNP guest update their handling of query-sev appropriately).

The corresponding HMP command has also been fixed up similarly.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 qapi/misc-target.json  | 71 +++++++++++++++++++++++++++++++++---------
 target/i386/monitor.c  | 29 +++++++++++++----
 target/i386/sev.c      | 22 +++++++------
 target/i386/sev_i386.h |  3 ++
 4 files changed, 95 insertions(+), 30 deletions(-)

diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 3b05ad3dbf..80f994ff9b 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -81,6 +81,49 @@
            'send-update', 'receive-update' ],
   'if': 'TARGET_I386' }
 
+##
+# @SevGuestType:
+#
+# An enumeration indicating the type of SEV guest being run.
+#
+# @sev:     The guest is a legacy SEV or SEV-ES guest.
+# @sev-snp: The guest is an SEV-SNP guest.
+#
+# Since: 6.2
+##
+{ 'enum': 'SevGuestType',
+  'data': [ 'sev', 'sev-snp' ],
+  'if': 'TARGET_I386' }
+
+##
+# @SevGuestInfo:
+#
+# Information specific to legacy SEV/SEV-ES guests.
+#
+# @policy: SEV policy value
+#
+# @handle: SEV firmware handle
+#
+# Since: 2.12
+##
+{ 'struct': 'SevGuestInfo',
+  'data': { 'policy': 'uint32',
+            'handle': 'uint32' },
+  'if': 'TARGET_I386' }
+
+##
+# @SevSnpGuestInfo:
+#
+# Information specific to SEV-SNP guests.
+#
+# @policy: SEV-SNP policy value
+#
+# Since: 6.2
+##
+{ 'struct': 'SevSnpGuestInfo',
+  'data': { 'policy': 'uint64' },
+  'if': 'TARGET_I386' }
+
 ##
 # @SevInfo:
 #
@@ -94,25 +137,25 @@
 #
 # @build-id: SEV FW build id
 #
-# @policy: SEV policy value
-#
 # @state: SEV guest state
 #
-# @handle: SEV firmware handle
+# @sev-type: Type of SEV guest being run
 #
 # Since: 2.12
 ##
-{ 'struct': 'SevInfo',
-    'data': { 'enabled': 'bool',
-              'api-major': 'uint8',
-              'api-minor' : 'uint8',
-              'build-id' : 'uint8',
-              'policy' : 'uint32',
-              'state' : 'SevState',
-              'handle' : 'uint32'
-            },
-  'if': 'TARGET_I386'
-}
+{ 'union': 'SevInfo',
+  'base': { 'enabled': 'bool',
+            'api-major': 'uint8',
+            'api-minor' : 'uint8',
+            'build-id' : 'uint8',
+            'state' : 'SevState',
+            'sev-type' : 'SevGuestType' },
+  'discriminator': 'sev-type',
+  'data': {
+      'sev': 'SevGuestInfo',
+      'sev-snp': 'SevSnpGuestInfo' },
+  'if': 'TARGET_I386' }
+
 
 ##
 # @query-sev:
diff --git a/target/i386/monitor.c b/target/i386/monitor.c
index 119211f0b0..85a8bc2bef 100644
--- a/target/i386/monitor.c
+++ b/target/i386/monitor.c
@@ -692,20 +692,37 @@ void hmp_info_sev(Monitor *mon, const QDict *qdict)
 {
     SevInfo *info = sev_get_info();
 
-    if (info && info->enabled) {
-        monitor_printf(mon, "handle: %d\n", info->handle);
+    if (!info || !info->enabled) {
+        monitor_printf(mon, "SEV is not enabled\n");
+        goto out;
+    }
+
+    if (sev_snp_enabled()) {
         monitor_printf(mon, "state: %s\n", SevState_str(info->state));
         monitor_printf(mon, "build: %d\n", info->build_id);
         monitor_printf(mon, "api version: %d.%d\n",
                        info->api_major, info->api_minor);
         monitor_printf(mon, "debug: %s\n",
-                       info->policy & SEV_POLICY_NODBG ? "off" : "on");
-        monitor_printf(mon, "key-sharing: %s\n",
-                       info->policy & SEV_POLICY_NOKS ? "off" : "on");
+                       info->u.sev_snp.policy & SEV_SNP_POLICY_DBG ? "on"
+                                                                   : "off");
+        monitor_printf(mon, "SMT allowed: %s\n",
+                       info->u.sev_snp.policy & SEV_SNP_POLICY_SMT ? "on"
+                                                                   : "off");
+        monitor_printf(mon, "SEV type: %s\n", SevGuestType_str(info->sev_type));
     } else {
-        monitor_printf(mon, "SEV is not enabled\n");
+        monitor_printf(mon, "handle: %d\n", info->u.sev.handle);
+        monitor_printf(mon, "state: %s\n", SevState_str(info->state));
+        monitor_printf(mon, "build: %d\n", info->build_id);
+        monitor_printf(mon, "api version: %d.%d\n",
+                       info->api_major, info->api_minor);
+        monitor_printf(mon, "debug: %s\n",
+                       info->u.sev.policy & SEV_POLICY_NODBG ? "off" : "on");
+        monitor_printf(mon, "key-sharing: %s\n",
+                       info->u.sev.policy & SEV_POLICY_NOKS ? "off" : "on");
+        monitor_printf(mon, "SEV type: %s\n", SevGuestType_str(info->sev_type));
     }
 
+out:
     qapi_free_SevInfo(info);
 }
 
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 72a6146295..fac2755e68 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -704,25 +704,27 @@ sev_get_info(void)
 {
     SevInfo *info;
     SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
-    SevGuestState *sev_guest =
-        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
-                                             TYPE_SEV_GUEST);
 
     info = g_new0(SevInfo, 1);
     info->enabled = sev_enabled();
 
     if (info->enabled) {
-        if (sev_guest) {
-            info->handle = sev_guest->handle;
-        }
         info->api_major = sev_common->api_major;
         info->api_minor = sev_common->api_minor;
         info->build_id = sev_common->build_id;
         info->state = sev_common->state;
-        /* we only report the lower 32-bits of policy for SNP, ok for now... */
-        info->policy =
-            (uint32_t)object_property_get_uint(OBJECT(sev_common),
-                                               "policy", NULL);
+
+        if (sev_snp_enabled()) {
+            info->sev_type = SEV_GUEST_TYPE_SEV_SNP;
+            info->u.sev_snp.policy =
+                object_property_get_uint(OBJECT(sev_common), "policy", NULL);
+        } else {
+            info->sev_type = SEV_GUEST_TYPE_SEV;
+            info->u.sev.handle = SEV_GUEST(sev_common)->handle;
+            info->u.sev.policy =
+                (uint32_t)object_property_get_uint(OBJECT(sev_common),
+                                                   "policy", NULL);
+        }
     }
 
     return info;
diff --git a/target/i386/sev_i386.h b/target/i386/sev_i386.h
index e0e1a599be..948d8f1079 100644
--- a/target/i386/sev_i386.h
+++ b/target/i386/sev_i386.h
@@ -28,6 +28,9 @@
 #define SEV_POLICY_DOMAIN       0x10
 #define SEV_POLICY_SEV          0x20
 
+#define SEV_SNP_POLICY_SMT      0x10000
+#define SEV_SNP_POLICY_DBG      0x80000
+
 extern bool sev_es_enabled(void);
 extern bool sev_snp_enabled(void);
 extern uint64_t sev_get_me_mask(void);
-- 
2.25.1

