Return-Path: <kvm+bounces-18405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5EA28D4A39
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:18:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FEB42827A7
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:18:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39D9617FAAC;
	Thu, 30 May 2024 11:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="2bnEgYDF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC74F17D352
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067820; cv=fail; b=giFFejccGhgrPb8PfueMV30fowKu0tzvDH7kg2Rex8vdjKNLYtDwmOOp5tZb3k8Rf0rBKnj9k04c3wMulVZM//VFYxAOvbVLvchdYlqHmZmoMvFhwccWLmQXlSt2OV7fM5+E+35+Oq7mRu3xB4tM55SR4Gk+da19xMUByyAYtBo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067820; c=relaxed/simple;
	bh=ojqv6/oXEnyhA2IUP0tV0HMwD9JwQksvBmmv1dNLvIk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SiKClxWYLasSjlFCHD5P9sqmi5wD/yVoMcJSWA+/WXsimgCQfEj/6G8UZ00Xpe/LAE8xbU6frbhK/HqDk3xa9yIvzolVM6+xaypnIJ0zH1tfFLOOiPaWNqIigH2xd1iEhzrPwPmujjqtd0NZLOLaL0k3/HQffsVMKGFXKz3qwHw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=2bnEgYDF; arc=fail smtp.client-ip=40.107.94.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m6q2GJnwhzU9+iE9504rzXfazGKW71gvVTu91bw4C6WE6P1+S0JAOrn8AB9ugjmUwwpXxaQA8m/0t3EpPNepe0VDXn64UnYj8JlbuBq8M3AO/Ut9oMV5Hz9cRu8xqPpt0xH0XY+p769Xi9NY50jAmH3kcILAi0hKfdGYgO7DeNwoERQ0GBrUXclEyC83qlDC6LdbzAO9SDMR8atnV/YE6WZH2e9vAqAzQv8dEo70mPXqKBUuwTCry9Z0IWolwwmVIEpMRzpcoZakMOUvsK6TuOqYwatwQzkMINAd62uKwVEf9hi54srgx+eI3QdM3/jn4any9aeCEdSsdfL3A9kFNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i4N2QE8nZbmvRULIPkR4fibQE16sS5tOuiopYo9eqHo=;
 b=F85KuEOqfS180uX7+E5E7uk+SxUcgxMGJihzFiEztOUJ0ccfGrUT2Wc+4i9v5pcg8Sxw0Bpg10Ce0C0ovM4L95+ysHupqNgN2kyxVpigJg7zW99uDZGlyrXmgL8KKy9ewqEg7W99SreCiRO0RRVaVQDFG4nlSgKja47qvkLExP1PZSPkuTXCfmCdtMdqhgWzIsdEwrzlHkPfeEGOBVDPO2BpLKC5YV/g476yglJZX/3Yb/5ST/sJZtU8dhHF/0Sb2OA58HrXUOLTorgCjX4fU1lB86mqBENyyjwalPs1uvjKDcBQHKV+XSmHoTcpt61yP3D99dujxEgtQ9abWAcdeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i4N2QE8nZbmvRULIPkR4fibQE16sS5tOuiopYo9eqHo=;
 b=2bnEgYDFfTt8NYicbr9GGHHEdgCccv71pnCMnLT2r/AucMYyOpUWbIZpG0haKoLMN/mVmannldBYPiMnhH6hkhiVrjSOZB61lagMp+R7s6Bes+MWpwleWc/RqPwwO6RQQgdEjAM7fkdHqOsZYLuPzjvZkMhmzMQ/LjiqVWJu7nQ=
Received: from BN1PR14CA0021.namprd14.prod.outlook.com (2603:10b6:408:e3::26)
 by SJ1PR12MB6051.namprd12.prod.outlook.com (2603:10b6:a03:48a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Thu, 30 May
 2024 11:16:54 +0000
Received: from BN2PEPF00004FBC.namprd04.prod.outlook.com
 (2603:10b6:408:e3:cafe::ef) by BN1PR14CA0021.outlook.office365.com
 (2603:10b6:408:e3::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.20 via Frontend
 Transport; Thu, 30 May 2024 11:16:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 BN2PEPF00004FBC.mail.protection.outlook.com (10.167.243.182) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:54 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:53 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:53 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:52 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 14/31] i386/sev: Update query-sev QAPI format to handle SEV-SNP
Date: Thu, 30 May 2024 06:16:26 -0500
Message-ID: <20240530111643.1091816-15-pankaj.gupta@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240530111643.1091816-1-pankaj.gupta@amd.com>
References: <20240530111643.1091816-1-pankaj.gupta@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Received-SPF: None (SATLEXMB05.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBC:EE_|SJ1PR12MB6051:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e57bc75-3b5a-467b-1d08-08dc809a02dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|82310400017|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?CnVdhMeEzTFTxQh63AGoFkV+ajxQaxYTUcumdx8Oic3ml9rrYFHeYU3x2UGU?=
 =?us-ascii?Q?1iZAPjwdA4dzGM3Zyopk2kOAWC8sgIbYKZINCnJK+GfZ0I75E82A/mF9h2IR?=
 =?us-ascii?Q?zgu2Jfy3mQjCbVwdqYaSt79RwwPH9F9U9XV0cd+rL1p67sRITCdM5KnJStWU?=
 =?us-ascii?Q?Zm+oo2Dh0sCjLqxWCLGKcS0fjIDAvbZR31iHDX/8bdYFxfwfbWItoWX2+732?=
 =?us-ascii?Q?WJ8/JAodqxcpNri5ApCeCoSk1v54j0h6bqjG6zwqFCA5Uk5TGDbmTndpjZPf?=
 =?us-ascii?Q?YF0UbulfhS0KJ3pGnf4yHlS/kA9TH9QtU/rglXIzx7FdlgxxfVkcj711QHg5?=
 =?us-ascii?Q?tPBZzWWvxqzq+l5Gj1kj4EmfqAwGbXJTHQDE92zWMLmk/EPW6HwH3gbrnI3I?=
 =?us-ascii?Q?KGH40W7YCtaq/aGRUieXK+TE5cN+tSwZUVoeQUPPc7+UZGwHBTcSSXM5/4GZ?=
 =?us-ascii?Q?6M4hCq2QgvjIt1mTIhbx6RWI/unPbYnS8iG0rkSc2k68x7ah2tyxdBRlJ/4q?=
 =?us-ascii?Q?RICwtKolXgpLzmF9o7T++V+zymVPy4/ayQgEykx7/F+E3UIeNCNVa/5vtVVN?=
 =?us-ascii?Q?E5hkRJUiWm09KkwGHhYz3l2GwJNbuTC3LAX61/RvrlgxaRI4kt4/+Vixx1D2?=
 =?us-ascii?Q?RsbgEYZ1rRlHcKE2PLMn7Yl3oyUWG9X6EBSfbbDalJ+DQdN4mMpK21c6App+?=
 =?us-ascii?Q?4m2Q/lpxwOeV/ri6PQ1MU+Vac1g6SG2+c0CuFTmVjhZOvq00/kW5YiCir1uJ?=
 =?us-ascii?Q?NaNAjd5a5QcFD67K49kqc0kKtqrgsS6Fdjwv1tu1cpQ/HDGLdJ5KJ3+6gjCs?=
 =?us-ascii?Q?BmrsDqvaRXPdRfQJCl6Qj/VdYWXyDCa3W3mWBRL9Lb8YIdcp1JsJ5StNCs80?=
 =?us-ascii?Q?FNRPEtXGLU0GnIruHJKgRgAro01By8yMwG4tVgAO9Xck0jRB3XOrajNZCJgX?=
 =?us-ascii?Q?ZVxhJXPU/DN7q7nxcPIgJL1zNPvkdttOrtjzglAWaEsI8vaQrjtIxlRaAfvn?=
 =?us-ascii?Q?xU0x5dcWV0aI6+owvzjj1NwKfgaa7CuLlf5wq1a+EiF8aRpD0ZavBnfsCLnA?=
 =?us-ascii?Q?/KpWEK6QhR60HCv2BQER9Ewx2SbpyQHe4vyVS7vDEJymZ7MZJMhmy2reZ1ji?=
 =?us-ascii?Q?/08BJbbUZteHoKqsMf+BdGnPhNygCzM4fl0NCdtcZGT+Afy5/gIEP4YROI1K?=
 =?us-ascii?Q?1yVQuG71adkZujy1VmBqtW+66tCjEFfJP7YQtR6QGmTA5CmIDv40HvBBb5Pj?=
 =?us-ascii?Q?fODoEdrhXaQdzT75MPYdpFi4FqfbHb4dE3bLRjxWiwArlSaFmlL8myRXKyXb?=
 =?us-ascii?Q?54wciKuGLTiGaUCmHQ5FmxU/ebVLIRi1+26jRsMc1GbfwTxfTnPDQux/bHMb?=
 =?us-ascii?Q?fnUcPXZkdCAGEqPovCoW8x4Yg6Sr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400017)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:54.0663
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e57bc75-3b5a-467b-1d08-08dc809a02dd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBC.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6051

From: Michael Roth <michael.roth@amd.com>

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
Co-developed-by:Pankaj Gupta <pankaj.gupta@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 qapi/misc-target.json | 72 ++++++++++++++++++++++++++++++++++---------
 target/i386/sev.c     | 55 +++++++++++++++++++++------------
 target/i386/sev.h     |  3 ++
 3 files changed, 96 insertions(+), 34 deletions(-)

diff --git a/qapi/misc-target.json b/qapi/misc-target.json
index 4e0a6492a9..2d7d4d89bd 100644
--- a/qapi/misc-target.json
+++ b/qapi/misc-target.json
@@ -47,6 +47,50 @@
            'send-update', 'receive-update' ],
   'if': 'TARGET_I386' }
 
+##
+# @SevGuestType:
+#
+# An enumeration indicating the type of SEV guest being run.
+#
+# @sev: The guest is a legacy SEV or SEV-ES guest.
+#
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
+# Since: 9.1
+##
+{ 'struct': 'SevSnpGuestInfo',
+  'data': { 'snp-policy': 'uint64' },
+  'if': 'TARGET_I386' }
+
 ##
 # @SevInfo:
 #
@@ -60,25 +104,25 @@
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
index 8ca486f5d2..101661bf71 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -377,25 +377,27 @@ static SevInfo *sev_get_info(void)
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
@@ -418,20 +420,33 @@ void hmp_info_sev(Monitor *mon, const QDict *qdict)
 {
     SevInfo *info = sev_get_info();
 
-    if (info && info->enabled) {
-        monitor_printf(mon, "handle: %d\n", info->handle);
-        monitor_printf(mon, "state: %s\n", SevState_str(info->state));
-        monitor_printf(mon, "build: %d\n", info->build_id);
-        monitor_printf(mon, "api version: %d.%d\n",
-                       info->api_major, info->api_minor);
+    if (!info || !info->enabled) {
+        monitor_printf(mon, "SEV is not enabled\n");
+        goto out;
+    }
+
+    monitor_printf(mon, "SEV type: %s\n", SevGuestType_str(info->sev_type));
+    monitor_printf(mon, "state: %s\n", SevState_str(info->state));
+    monitor_printf(mon, "build: %d\n", info->build_id);
+    monitor_printf(mon, "api version: %d.%d\n", info->api_major,
+                   info->api_minor);
+
+    if (sev_snp_enabled()) {
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
+        monitor_printf(mon, "debug: %s\n",
+                       info->u.sev.policy & SEV_POLICY_NODBG ? "off" : "on");
+        monitor_printf(mon, "key-sharing: %s\n",
+                       info->u.sev.policy & SEV_POLICY_NOKS ? "off" : "on");
     }
 
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
2.34.1


