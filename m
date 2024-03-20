Return-Path: <kvm+bounces-12244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BBCDE880DC3
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 330791F25083
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:52:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5986640845;
	Wed, 20 Mar 2024 08:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="wL8SnHBb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2085.outbound.protection.outlook.com [40.107.93.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF874405CD
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924597; cv=fail; b=BhL7rmMZQ/bF0ZGmOv09S99jdF+TfVqXEQ4evRp8kj4xfyPHgeKqoUgQsdBy24os6MKGvxdS2HIU6spOP6K9aFHYcqYb+1VAmiJVDC1HbVcIfH3sJyZuDjCohDGBnFKygWO0SKfVgPp6rUqiC4nojLLlsWWk5pU//0Q1zt3crLI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924597; c=relaxed/simple;
	bh=F7l4T6yhIleALrcayESNOVV62fCH54qbarfk53+tn6g=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o6DVdCM3+Jj2zLCUcZxAxYtyO03bcdbdwPX0WR1veWwHfGO/4aGiglwG6yd0ulZYyixE6v9I9sElgsIHLJvU0/H5pCdxjV4HGNjjpmajtlC1I6To/DDrK7c+7RDaDvQa9lZKoNyTdf9pckgo66+h5EvT8Hay/GIdwt6683ZTQRQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=wL8SnHBb; arc=fail smtp.client-ip=40.107.93.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDyYSN/vzWuAnETeAHx0fKUhFj50ueS4ZLd4bE29V7XQENjU9J0hTsO07JXYG62VVUMP4vnL5xSgLqt8W3kxBRexV5PrlgO3SoAeP6M7brqhAOgROTaj63uTh0p5bqIeX89Ky51DISvPt/eZtwYSIFSbELVS2Lix4OvR6V2DazHsPRRX3/Em8bnSK4q2j+xDyXM14uC6XuMxNIzvoszioASpzEzBPwcgUT/INYkWv3NxE0r2bihB/7E232nsNYZKOJQ5hJ6t0ENXAam1cqA+sUgzq4rBL6Wzeaq0Hgpi2AfjpInkd0etCS0rWShbJYPNcYISFa6yCpgzORb111qhmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OHLk61mz3wbuJbwl4cL2T2h5Mpbmdf9D4LvAKsodhi4=;
 b=TNkRSfZvlAw61Mkz3YvLLra+hlwaaG7bXio83GnQdFklR5dumQv9LpWsxuOFzRaOditiSwbbVK7oJR7XWgZy6W3McOGeqeXZ+IzyQfRDUgGZxyxJmp22+JUjVK0a81vib+brb5nhxPg2vFVoAo4MWZBCkuNDUacXS13ARPYwLlDdpkewIXdJyNz24zKrgTyOA1PoGXietzIENeitkpV3cKURMGTTWfT61GZ9vJ/tv76uyH2lbbTUV7CzAepbQdQdlpmgoAWKju1t4zfieiktnEpScFswv5PBnyKV7sYNdWDNkoSTNppUiSZHVzNe0+PP4BsLMeaABiRmgzPcqxwMYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OHLk61mz3wbuJbwl4cL2T2h5Mpbmdf9D4LvAKsodhi4=;
 b=wL8SnHBbvljNwIAIIEE10GL/b8F0yoSSPQPtcicQkeKnRYFyvZRG1zW4c8wh5vH0s2/aSs9DAW9HEtE4t0uBignpSiUZxD6uPOduTs8LbFF+AjCDNEcjuw3XBrxcmEvCHVCNReUW1hV8SYAeTuh6R1MbFAspeOFRX9HC7rbZe18=
Received: from BN9PR03CA0205.namprd03.prod.outlook.com (2603:10b6:408:f9::30)
 by BY5PR12MB4179.namprd12.prod.outlook.com (2603:10b6:a03:211::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 08:49:53 +0000
Received: from BN1PEPF00004686.namprd03.prod.outlook.com
 (2603:10b6:408:f9:cafe::fd) by BN9PR03CA0205.outlook.office365.com
 (2603:10b6:408:f9::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:49:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004686.mail.protection.outlook.com (10.167.243.91) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:49:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:49:52 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 31/49] i386/sev: Update query-sev QAPI format to handle SEV-SNP
Date: Wed, 20 Mar 2024 03:39:27 -0500
Message-ID: <20240320083945.991426-32-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240320083945.991426-1-michael.roth@amd.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004686:EE_|BY5PR12MB4179:EE_
X-MS-Office365-Filtering-Correlation-Id: 39f4c8ba-00ae-40d9-55de-08dc48bab58e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	cYCUAy1zFQ5Ipu0Ni/xZmMc+pSIO/QPDBG9AunLUNsGAohEx/BpMaYFl1Jj1Rp46Xx28tPsOmra87VWJ9wHbJwGpOjLpJybd39Zl7fD44do/A9TdcRiTAGQ70kOW+oVYw2NPlhTAA1naxekGWMGuvlOUj5j9gctULEQ4F4VNydAsr8Ap/fh2pGExPYTNIuQFnX8ywK+7rrEy+g8nyHKWW2E3PIcfAGEcU3NqglgAUQ0Q69XTIBT+uCM0CAj9l5srTZRx3k+cVfvEPA8kksDBnkU1160SyWKPaQ8xAR91mimHDzuFXcz8VtQFwqsfEpYMxppmAgIJ4D65B62Qn0kggR4LQrCMfUPHA0CjN1PKakdSgF4wn2bMMegimxeZqYi22wSFSwChX9aDVpp8fzmHi8K9FvzKGsG5vMuvTKR9JQMKBcuMhJW90gisVS5C5Kx0Wrw0+cgFYYpF/x13tAHJjxsoQDIarr5nIGkFyR+EwmO9f8G2YSrt4Uu4iD8SvJiUrCNPCQmWbCq3L7rwbR5y/6w3wWUIYBjAbng87QZSNDKvuu/a8yvsRNguvJdFZ28wiwRrQAYF3AWda+/8iMYqhv2fWaNX4G54QvzMmvBw2XT8fzWOm3IEhDxqlcCDGGPzl//KjLC4zzu0btPVlwHyTaAGPWDTMvIICwoFJXDi7HKU5Tqqfw8x1UqjSqjG/Fry8ezwitqUJdZMKSOWZGnO+lhcuk7yM2SLHYfpRPvsjvCS1hBHj8YDKulC6b42oX5P
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:49:52.6420
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 39f4c8ba-00ae-40d9-55de-08dc48bab58e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004686.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4179

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
 qapi/misc-target.json | 71 ++++++++++++++++++++++++++++++++++---------
 target/i386/sev.c     | 50 ++++++++++++++++++++----------
 target/i386/sev.h     |  3 ++
 3 files changed, 94 insertions(+), 30 deletions(-)

diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 4e0a6492a9..daceb85d95 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -47,6 +47,49 @@
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
+# @snp-policy: SEV-SNP policy value
+#
+# Since: 6.2
+##
+{ 'struct': 'SevSnpGuestInfo',
+  'data': { 'snp-policy': 'uint64' },
+  'if': 'TARGET_I386' }
+
 ##
 # @SevInfo:
 #
@@ -60,25 +103,25 @@
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
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 43e6c0172f..b03d70a3d1 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -353,25 +353,27 @@ static SevInfo *sev_get_info(void)
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
+            info->u.sev_snp.snp_policy =
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
@@ -394,20 +396,36 @@ void hmp_info_sev(Monitor *mon, const QDict *qdict)
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
+                       info->u.sev_snp.snp_policy & SEV_SNP_POLICY_DBG ? "on"
+                                                                       : "off");
+        monitor_printf(mon, "SMT allowed: %s\n",
+                       info->u.sev_snp.snp_policy & SEV_SNP_POLICY_SMT ? "on"
+                                                                       : "off");
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
     }
+    monitor_printf(mon, "SEV type: %s\n", SevGuestType_str(info->sev_type));
 
+out:
     qapi_free_SevInfo(info);
 }
 
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 94295ee74f..5dc4767b1e 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -31,6 +31,9 @@
 #define SEV_POLICY_DOMAIN       0x10
 #define SEV_POLICY_SEV          0x20
 
+#define SEV_SNP_POLICY_SMT      0x10000
+#define SEV_SNP_POLICY_DBG      0x80000
+
 typedef struct SevKernelLoaderContext {
     char *setup_data;
     size_t setup_size;
-- 
2.25.1


