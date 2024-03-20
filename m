Return-Path: <kvm+bounces-12257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B3F11880DEF
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:54:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A754281C32
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A068F3BBFB;
	Wed, 20 Mar 2024 08:54:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bmGrQo43"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E9963BBDD
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924875; cv=fail; b=XbQnzV2fKfe6G+ahWV4/8zksl03l35Vg8+eu/ERaFZQ+w3pxg1rJCAf8hjBbVZfXZ7O0ocUTnlJqfoa1rhiYaOo9Pc5y1bWcBGSZD5QdBDXWMESW32rRvtoNij7knr2973yqiAdl2PoI6SaLG6UTsDiTM/xS+WSLDvt7lzEALS8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924875; c=relaxed/simple;
	bh=KO8/dvZTtls1HKti5f2Etl8pDSJZyJ8nKw2VntqoRwM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=phx5s2sEpAo59FqI9uZTBBLzWEJM69j2na8EUSnuRXh5sEfdLW3UF97IgD7v81Du985LYf+JH7NCzEN9GmgDMKfelrmFZKljO3ohHRKvGH8zAU25sWfKkl1MppNMMrd+kRsL8zFNYDOFOWs8ftmUAEWwk9g0JMcU+tbuUIQOQLY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bmGrQo43; arc=fail smtp.client-ip=40.107.244.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HsR9AWqVBYq5IFCwrq5S25hEttgBSBwjExY1EfPBQaqxzuTKgI+7YwYRBuNbRMRkQsvj5ipgU0X41kbbWYykG3308/V38cXHp/zS5lDSs+F3K3gEnfUNC0ikTGb+Z6mgo6ypMr9SI+wTRqrGUIsEu3MgHIMPbl8Uk1zHkMoNwL14jhg2DEOUEkO/oE+MfiUp43hL5Bn6O45sVxTv0mM3SuCqB/pQgm/ABgANnZXPKa6CZRmgGZAHaF073eDBiPUhVZlXzU33X/jtRyBx1si+D2l81oE7xGaRzpXBn5g1v7R5DkMQutV5M72zIpCgOgq2PoGQEvmVJzu6a0A+imR5iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=46Y1YUFzn4ag32XDe16B1pD4yA1plw2W8p/d0aiXcY0=;
 b=h1ikS38qMtdIQrckqg5ehOYisv7Mikx0R723eT1iJRwMQ7kNSNFYRX78x4hxEJACkVph7AIxBkqnFKC/sMy8DJTLCg0gKMQEEQFCmGCitEOjiBujHk/FaK82I0eRxao3+lspcxosDcH/DC1zvoq537MOk1p5TrrZG6Q7kKiW3EPNsjIeAgk9I+mFUmiTfWds+qZDo0rOhvYNSp7Z/3MlLib0TnlAMQ+LMWStFg3W1ezfGFnKNbn989fmmPDhlFkldiY7Eqb/XPJEqWOFgt6Ewqeoog+nTLs2HcXjNVybeCJW8YPwVQF50u4UySV67l/tJkS3gygHbDwMdqjHDVydPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=46Y1YUFzn4ag32XDe16B1pD4yA1plw2W8p/d0aiXcY0=;
 b=bmGrQo43wJeSZRlpNfSNYuBU5ly8j+FJNUd+6nadC1LR/b9S3uSG3YIUF1bKa6Mc/nE7xuJGs8ffDZl4o2sMuVdrBLPPc04OhmrrlH8u2yiSX5EKxicC+UPiUYzg3WmFCRtNuAKKUsj4hLPH/U78s/38nip/F0gCPtISt+rkuAg=
Received: from SJ0PR05CA0042.namprd05.prod.outlook.com (2603:10b6:a03:33f::17)
 by PH7PR12MB6442.namprd12.prod.outlook.com (2603:10b6:510:1fa::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.34; Wed, 20 Mar
 2024 08:54:27 +0000
Received: from CO1PEPF000044F5.namprd05.prod.outlook.com
 (2603:10b6:a03:33f:cafe::66) by SJ0PR05CA0042.outlook.office365.com
 (2603:10b6:a03:33f::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12 via Frontend
 Transport; Wed, 20 Mar 2024 08:54:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F5.mail.protection.outlook.com (10.167.241.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:54:27 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:54:24 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Dov Murik <dovmurik@linux.ibm.com>
Subject: [PATCH v3 43/49] qapi, i386: Move kernel-hashes to SevCommonProperties
Date: Wed, 20 Mar 2024 03:39:39 -0500
Message-ID: <20240320083945.991426-44-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F5:EE_|PH7PR12MB6442:EE_
X-MS-Office365-Filtering-Correlation-Id: 76ebdcf3-3a7d-419c-c57d-08dc48bb593d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	AhFU7LT1aypHTXClsR+Gk7dUa3WwySkRKT1gpusJc5QZtlw6gZ2DkZH/lCmfbFMhdc689D96od1ghp8DfYAe4CKMRchYBB4vmzwtfU3QmOmnVc93fQf7uanLUR9Ub1tlJpS/zejwbjDc5qza7shajr74ES+vpf+SSrDVx4PPREGlmu0cLt+CUbje302e0XzSEPZqG8Rc2CEiT/L+stYoQ2ZuBxiK0gWy899WIOafQhRabxTWDjY7OmOK8oTb9Nln5cStNhFjFwasjWx9Z4ekG5irUUYsF6lLitJ9b8Su5q0ey9TEUAXadOuUYG+Hd8hRIhJixGRLrTbYP4y/E/dcw+gPqF0ku5+1LXDPL6iCoBSicDDkHu9G4fSisnwC3uEv3kqhS2ymIfFov8WzsQ5cCNc0edrAD1GPdvAbuIBPYdAOiQa5jpMA1JdmftK79A3rTCnS86nnMW5IeRcogLuyPQP7CDMamXGjMypRZdvYiyebBvUvf8ckzwLUDRKS0q2CU1Z/IgwFCf7cIerA+AKKOZCw7XFB1ycAdigmmJhWM8y/OdNAq9gESvCD/Y3uuuC2ca3QssZGF+iWbsO/sbMz5wiECHw60tK8AGxTOxM5eGNJ7Y/h+64hhiNDlAPSCGfiFRn38QaIBcr9Qv0cezfnC6OcLvlXE1mteEgF5zw7Pfb6pAqUsg8ShxZQa45hHjbU5y0w+vUF0oTcWaOnZnV0osBst7FEMvn63TyWcyYjkKNxBNQJHpBcHWmv7Ymxau3m
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:54:27.1509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 76ebdcf3-3a7d-419c-c57d-08dc48bb593d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6442

From: Dov Murik <dovmurik@linux.ibm.com>

In order to enable kernel-hashes for SNP, pull it from
SevGuestProperties to its parent SevCommonProperties so
it will be available for both SEV and SNP.

Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 qapi/qom.json     | 14 +++++++-------
 target/i386/sev.c | 44 ++++++++++++++++++--------------------------
 2 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index 7ba778af91..ea8832a8c3 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -886,12 +886,17 @@
 # @reduced-phys-bits: number of bits in physical addresses that become
 #     unavailable when SEV is enabled
 #
+# @kernel-hashes: if true, add hashes of kernel/initrd/cmdline to a
+#     designated guest firmware page for measured boot with -kernel
+#     (default: false) (since 6.2)
+#
 # Since: 2.12
 ##
 { 'struct': 'SevCommonProperties',
   'data': { '*sev-device': 'str',
             '*cbitpos': 'uint32',
-            'reduced-phys-bits': 'uint32' } }
+            'reduced-phys-bits': 'uint32',
+            '*kernel-hashes': 'bool' } }
 
 ##
 # @SevGuestProperties:
@@ -906,10 +911,6 @@
 #
 # @handle: SEV firmware handle (default: 0)
 #
-# @kernel-hashes: if true, add hashes of kernel/initrd/cmdline to a
-#     designated guest firmware page for measured boot with -kernel
-#     (default: false) (since 6.2)
-#
 # Since: 2.12
 ##
 { 'struct': 'SevGuestProperties',
@@ -917,8 +918,7 @@
   'data': { '*dh-cert-file': 'str',
             '*session-file': 'str',
             '*policy': 'uint32',
-            '*handle': 'uint32',
-            '*kernel-hashes': 'bool' } }
+            '*handle': 'uint32' } }
 
 ##
 # @SevSnpGuestProperties:
diff --git a/target/i386/sev.c b/target/i386/sev.c
index db888afb53..3187b3dee8 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -54,6 +54,7 @@ struct SevCommonState {
     char *sev_device;
     uint32_t cbitpos;
     uint32_t reduced_phys_bits;
+    bool kernel_hashes;
 
     /* runtime state */
     uint8_t api_major;
@@ -86,7 +87,6 @@ struct SevGuestState {
     uint32_t policy;
     char *dh_cert_file;
     char *session_file;
-    bool kernel_hashes;
 };
 
 struct SevSnpGuestState {
@@ -1696,16 +1696,12 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     MemTxAttrs attrs = { 0 };
     bool ret = true;
     SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
-    SevGuestState *sev_guest =
-        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
-                                             TYPE_SEV_GUEST);
 
     /*
      * Only add the kernel hashes if the sev-guest configuration explicitly
-     * stated kernel-hashes=on. Currently only enabled for SEV/SEV-ES guests,
-     * so check for TYPE_SEV_GUEST as well.
+     * stated kernel-hashes=on.
      */
-    if (sev_guest && !sev_guest->kernel_hashes) {
+    if (!sev_common->kernel_hashes) {
         return false;
     }
 
@@ -2037,6 +2033,16 @@ sev_common_set_sev_device(Object *obj, const char *value, Error **errp)
     SEV_COMMON(obj)->sev_device = g_strdup(value);
 }
 
+static bool sev_common_get_kernel_hashes(Object *obj, Error **errp)
+{
+    return SEV_COMMON(obj)->kernel_hashes;
+}
+
+static void sev_common_set_kernel_hashes(Object *obj, bool value, Error **errp)
+{
+    SEV_COMMON(obj)->kernel_hashes = value;
+}
+
 static void
 sev_common_class_init(ObjectClass *oc, void *data)
 {
@@ -2051,6 +2057,11 @@ sev_common_class_init(ObjectClass *oc, void *data)
                                   sev_common_set_sev_device);
     object_class_property_set_description(oc, "sev-device",
             "SEV device to use");
+    object_class_property_add_bool(oc, "kernel-hashes",
+                                   sev_common_get_kernel_hashes,
+                                   sev_common_set_kernel_hashes);
+    object_class_property_set_description(oc, "kernel-hashes",
+            "add kernel hashes to guest firmware for measured Linux boot");
 }
 
 static void
@@ -2109,20 +2120,6 @@ sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
     SEV_GUEST(obj)->session_file = g_strdup(value);
 }
 
-static bool sev_guest_get_kernel_hashes(Object *obj, Error **errp)
-{
-    SevGuestState *sev_guest = SEV_GUEST(obj);
-
-    return sev_guest->kernel_hashes;
-}
-
-static void sev_guest_set_kernel_hashes(Object *obj, bool value, Error **errp)
-{
-    SevGuestState *sev = SEV_GUEST(obj);
-
-    sev->kernel_hashes = value;
-}
-
 static void
 sev_guest_class_init(ObjectClass *oc, void *data)
 {
@@ -2136,11 +2133,6 @@ sev_guest_class_init(ObjectClass *oc, void *data)
                                   sev_guest_set_session_file);
     object_class_property_set_description(oc, "session-file",
             "guest owners session parameters (encoded with base64)");
-    object_class_property_add_bool(oc, "kernel-hashes",
-                                   sev_guest_get_kernel_hashes,
-                                   sev_guest_set_kernel_hashes);
-    object_class_property_set_description(oc, "kernel-hashes",
-            "add kernel hashes to guest firmware for measured Linux boot");
 }
 
 static void
-- 
2.25.1


