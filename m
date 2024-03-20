Return-Path: <kvm+bounces-12233-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D52E2880D6A
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:46:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8673C281D7C
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:46:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D0C38F9A;
	Wed, 20 Mar 2024 08:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="r0IAJplK"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA2A38DE5
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924368; cv=fail; b=SYKis9LzVAlwepjr1O7rtSdlzV03pvo3lGlk5z7peXoKQWoIHb+kTjWDgFGxM3o9X+mxdH5Nd0J7xMXY5PCObiBQ0ioLr+ZTR6n49lFZjV/KHxW1UjMn/TkCFbO2e3eJ/G1kC2pDiAnc4Hbjw8pBNzXwSedPKORi9DLk8avZcM4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924368; c=relaxed/simple;
	bh=2otGYn1OBsulKlSd+nuR7CaCz60pziEmc+mcFm6p6H4=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nX2WpC9eKuuKPsp3KIeEXCiMiRfkrY4UaLsc6saNrnu4wXcJ4rEG8kuch+B3hn6yt1BVCsyc5nSPwztFz3J/OXPMzWKLuI+htjNBOxsGJvAnyW9D5eWCDfd30qTWOsFIp0LNnjKsGcYjSMRvkw2jN2N8BwV9LpK7AVk4EKsBP7E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=r0IAJplK; arc=fail smtp.client-ip=40.107.92.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RKBbO0CaEhuTxCJXfv5scGZ7R1aKOKP84OZU1haI/uLUYLvB9nS0U3Xqf+qjk3OW4f/hR3kxJDJl51nDIQ/TpP2RNDlL67XkYs64NmDhiWiEQdr5YdOTEXeDjLB3odnRsn1xe2lWfWahC/Y3zn0aV2ppmAGO3wyolP3Z66X+DUhTlvFPmbHchs/iRG99NmH+WOsZW428fCaxS2blmmWy9eLhGfET9GmmJui5t9SXgYLADERtRUAq8Dsr09CTTqPZa2SdnkdTFNLAmIpeqrOYjJy1QJo6bL/dNg4O5IHJJLbRmtEiEWnnWwP/PXNYq6912Izd6rjDcQJWlRUwcNQfcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nabb/ZLx53NOJVnViJd0UclO546NdwaLnwg/o8wtWdk=;
 b=fNq8sPtDF1f+Off4dYGGCWe9fSst9RPGi9AXEcggpkx5rZxMsK6waVwaUdeRlqtD/ykMLSlgoHJq08BtE9t9K5cis0uVSU1Wk6LFSAr4EPAc2RcU8Dn5IBhij9SVAnM1y1eoBI+JAmZgGwhVfnWBevcE7x3El/m641g4OsLURr1eqwKhQf7ldjtnJn0ItAS1LsNHz5+lRoIhMW3X99InoNmNq+4BSsh6ZSvy2Bj/cS8LHmLfDRXUA8WM8l9vy8fg/OuqVinv7Gp4wLC7TlEfU8oJ1IYJ4lpVpKIW3zF8MnntPj6n+vM/kbt8BK2F3n62ALLmOsYmxtm8eHdrTUZgpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nabb/ZLx53NOJVnViJd0UclO546NdwaLnwg/o8wtWdk=;
 b=r0IAJplKY5pn5RAIyatyXWoHMRZABPkiEyy8t5wv4w0ZDnjBMTQA9pHikHe8DDwH+Vd21b43ENoxmjMuelfMDSmgkxznPpQEU/xV47IiivsXsGqqTRMSyzOV6EV2Wuf0/sA+XLP4Z8POCBLn4grOjMo3qSj0qQNEFQQDPmhCFM0=
Received: from MW4PR03CA0239.namprd03.prod.outlook.com (2603:10b6:303:b9::34)
 by MW4PR12MB7360.namprd12.prod.outlook.com (2603:10b6:303:21a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:46:02 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:303:b9:cafe::a) by MW4PR03CA0239.outlook.office365.com
 (2603:10b6:303:b9::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.28 via Frontend
 Transport; Wed, 20 Mar 2024 08:46:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:46:02 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:46:01 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 21/49] i386/sev: Introduce "sev-common" type to encapsulate common SEV state
Date: Wed, 20 Mar 2024 03:39:17 -0500
Message-ID: <20240320083945.991426-22-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|MW4PR12MB7360:EE_
X-MS-Office365-Filtering-Correlation-Id: d4244442-135b-4a37-0801-08dc48ba2c63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	jp6Qf+XRkjYfcTKRknvwQbeCHAGGxfKeFht2AwnAO2dmXY68uWg0xjZpjWF0Uw03d5uDwcSuCKVpgIIUNYWb+yVvunAL5xvdFcBXtKtaImrJbRO+VMDcJlMEt5MzjDzEu/ZZXaDJAtar4HxkIESTVKv8Baw8JqJOcyv7Op8qpHYtiYmSjFGRHitMsBcQo1mZSdRIIvKo92fo4cTC18EbwVm1mzqjSvbUmABPvH7Ze6WA7PxrAzh51btxE7QFS4yc2bbOqmFTzNIAnHV4uhf+HgWPFn3Om0Bx6eMpKUKlI5NhNotHNzcLO1eGrAFjvfyfD2Tk59eJ3dHDHIbeyVsaildB4GuGu3jhpcoi6rdCX2djigYRkuxupZ2hzWAAAq5QVKfbimhmXSEerf2pNkEW7jz05UPsdZZc0MHIbysulwhN0ZEC2lcHUUZKGNwR4v9ddutLQ6cm8uHKU4RHKitMZ9xiMb9/zHW75KwcWkn+LkGPQ0W3kDFjwLIa+3kR/0wdZDzwqjEf2oydXVh6/1LISF71MljxL7nyhqP92wB3le5qRQpGkYOulT1w63xXpoDT0EFs/IDm7pKcgb+uLgrhgXvPQgKJPaGm+pmECgF1ATO3alqdQZW0bA9krAsYZH7bzlxnAfS99jj7o03geTKDIWRk60npTP2lQt5VrGGRXStyJZeTWanxR/yJ0irZF64OfZsOF8VdFupzq3AxAWA3IizVKfujEMw9TnYdu3crSAI2SyN1uL4+rQDIZlmgETJw
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(82310400014)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:46:02.4009
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d4244442-135b-4a37-0801-08dc48ba2c63
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7360

Currently all SEV/SEV-ES functionality is managed through a single
'sev-guest' QOM type. With upcoming support for SEV-SNP, taking this
same approach won't work well since some of the properties/state
managed by 'sev-guest' is not applicable to SEV-SNP, which will instead
rely on a new QOM type with its own set of properties/state.

To prepare for this, this patch moves common state into an abstract
'sev-common' parent type to encapsulate properties/state that are
common to both SEV/SEV-ES and SEV-SNP, leaving only SEV/SEV-ES-specific
properties/state in the current 'sev-guest' type. This should not
affect current behavior or command-line options.

As part of this patch, some related changes are also made:

  - a static 'sev_guest' variable is currently used to keep track of
    the 'sev-guest' instance. SEV-SNP would similarly introduce an
    'sev_snp_guest' static variable. But these instances are now
    available via qdev_get_machine()->cgs, so switch to using that
    instead and drop the static variable.

  - 'sev_guest' is currently used as the name for the static variable
    holding a pointer to the 'sev-guest' instance. Re-purpose the name
    as a local variable referring the 'sev-guest' instance, and use
    that consistently throughout the code so it can be easily
    distinguished from sev-common/sev-snp-guest instances.

  - 'sev' is generally used as the name for local variables holding a
    pointer to the 'sev-guest' instance. In cases where that now points
    to common state, use the name 'sev_common'; in cases where that now
    points to state specific to 'sev-guest' instance, use the name
    'sev_guest'

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 qapi/qom.json     |  32 ++--
 target/i386/sev.c | 457 ++++++++++++++++++++++++++--------------------
 target/i386/sev.h |   3 +
 3 files changed, 281 insertions(+), 211 deletions(-)

diff --git a/qapi/qom.json b/qapi/qom.json
index baae3a183f..66b5781ca6 100644
--- a/qapi/qom.json
+++ b/qapi/qom.json
@@ -875,12 +875,29 @@
   'data': { '*filename': 'str' } }
 
 ##
-# @SevGuestProperties:
+# @SevCommonProperties:
 #
-# Properties for sev-guest objects.
+# Properties common to objects that are derivatives of sev-common.
 #
 # @sev-device: SEV device to use (default: "/dev/sev")
 #
+# @cbitpos: C-bit location in page table entry (default: 0)
+#
+# @reduced-phys-bits: number of bits in physical addresses that become
+#     unavailable when SEV is enabled
+#
+# Since: 2.12
+##
+{ 'struct': 'SevCommonProperties',
+  'data': { '*sev-device': 'str',
+            '*cbitpos': 'uint32',
+            'reduced-phys-bits': 'uint32' } }
+
+##
+# @SevGuestProperties:
+#
+# Properties for sev-guest objects.
+#
 # @dh-cert-file: guest owners DH certificate (encoded with base64)
 #
 # @session-file: guest owners session parameters (encoded with base64)
@@ -889,11 +906,6 @@
 #
 # @handle: SEV firmware handle (default: 0)
 #
-# @cbitpos: C-bit location in page table entry (default: 0)
-#
-# @reduced-phys-bits: number of bits in physical addresses that become
-#     unavailable when SEV is enabled
-#
 # @kernel-hashes: if true, add hashes of kernel/initrd/cmdline to a
 #     designated guest firmware page for measured boot with -kernel
 #     (default: false) (since 6.2)
@@ -901,13 +913,11 @@
 # Since: 2.12
 ##
 { 'struct': 'SevGuestProperties',
-  'data': { '*sev-device': 'str',
-            '*dh-cert-file': 'str',
+  'base': 'SevCommonProperties',
+  'data': { '*dh-cert-file': 'str',
             '*session-file': 'str',
             '*policy': 'uint32',
             '*handle': 'uint32',
-            '*cbitpos': 'uint32',
-            'reduced-phys-bits': 'uint32',
             '*kernel-hashes': 'bool' } }
 
 ##
diff --git a/target/i386/sev.c b/target/i386/sev.c
index 9dab4060b8..63a220de5e 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -40,48 +40,53 @@
 #include "hw/i386/pc.h"
 #include "exec/address-spaces.h"
 
-#define TYPE_SEV_GUEST "sev-guest"
+OBJECT_DECLARE_SIMPLE_TYPE(SevCommonState, SEV_COMMON)
 OBJECT_DECLARE_SIMPLE_TYPE(SevGuestState, SEV_GUEST)
 
-
-/**
- * SevGuestState:
- *
- * The SevGuestState object is used for creating and managing a SEV
- * guest.
- *
- * # $QEMU \
- *         -object sev-guest,id=sev0 \
- *         -machine ...,memory-encryption=sev0
- */
-struct SevGuestState {
+struct SevCommonState {
     X86ConfidentialGuest parent_obj;
 
     int kvm_type;
 
     /* configuration parameters */
     char *sev_device;
-    uint32_t policy;
-    char *dh_cert_file;
-    char *session_file;
     uint32_t cbitpos;
     uint32_t reduced_phys_bits;
-    bool kernel_hashes;
 
     /* runtime state */
-    uint32_t handle;
     uint8_t api_major;
     uint8_t api_minor;
     uint8_t build_id;
     int sev_fd;
     SevState state;
-    gchar *measurement;
 
     uint32_t reset_cs;
     uint32_t reset_ip;
     bool reset_data_valid;
 };
 
+/**
+ * SevGuestState:
+ *
+ * The SevGuestState object is used for creating and managing a SEV
+ * guest.
+ *
+ * # $QEMU \
+ *         -object sev-guest,id=sev0 \
+ *         -machine ...,memory-encryption=sev0
+ */
+struct SevGuestState {
+    SevCommonState sev_common;
+    gchar *measurement;
+
+    /* configuration parameters */
+    uint32_t handle;
+    uint32_t policy;
+    char *dh_cert_file;
+    char *session_file;
+    bool kernel_hashes;
+};
+
 #define DEFAULT_GUEST_POLICY    0x1 /* disable debug */
 #define DEFAULT_SEV_DEVICE      "/dev/sev"
 
@@ -127,7 +132,6 @@ typedef struct QEMU_PACKED PaddedSevHashTable {
 
 QEMU_BUILD_BUG_ON(sizeof(PaddedSevHashTable) % 16 != 0);
 
-static SevGuestState *sev_guest;
 static Error *sev_mig_blocker;
 
 static const char *const sev_fw_errlist[] = {
@@ -208,21 +212,21 @@ fw_error_to_str(int code)
 }
 
 static bool
-sev_check_state(const SevGuestState *sev, SevState state)
+sev_check_state(const SevCommonState *sev_common, SevState state)
 {
-    assert(sev);
-    return sev->state == state ? true : false;
+    assert(sev_common);
+    return sev_common->state == state ? true : false;
 }
 
 static void
-sev_set_guest_state(SevGuestState *sev, SevState new_state)
+sev_set_guest_state(SevCommonState *sev_common, SevState new_state)
 {
     assert(new_state < SEV_STATE__MAX);
-    assert(sev);
+    assert(sev_common);
 
-    trace_kvm_sev_change_state(SevState_str(sev->state),
+    trace_kvm_sev_change_state(SevState_str(sev_common->state),
                                SevState_str(new_state));
-    sev->state = new_state;
+    sev_common->state = new_state;
 }
 
 static void
@@ -289,111 +293,61 @@ static struct RAMBlockNotifier sev_ram_notifier = {
     .ram_block_removed = sev_ram_block_removed,
 };
 
-static void
-sev_guest_finalize(Object *obj)
-{
-}
-
-static char *
-sev_guest_get_session_file(Object *obj, Error **errp)
-{
-    SevGuestState *s = SEV_GUEST(obj);
-
-    return s->session_file ? g_strdup(s->session_file) : NULL;
-}
-
-static void
-sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
-{
-    SevGuestState *s = SEV_GUEST(obj);
-
-    s->session_file = g_strdup(value);
-}
-
-static char *
-sev_guest_get_dh_cert_file(Object *obj, Error **errp)
-{
-    SevGuestState *s = SEV_GUEST(obj);
-
-    return g_strdup(s->dh_cert_file);
-}
-
-static void
-sev_guest_set_dh_cert_file(Object *obj, const char *value, Error **errp)
-{
-    SevGuestState *s = SEV_GUEST(obj);
-
-    s->dh_cert_file = g_strdup(value);
-}
-
-static char *
-sev_guest_get_sev_device(Object *obj, Error **errp)
-{
-    SevGuestState *sev = SEV_GUEST(obj);
-
-    return g_strdup(sev->sev_device);
-}
-
-static void
-sev_guest_set_sev_device(Object *obj, const char *value, Error **errp)
-{
-    SevGuestState *sev = SEV_GUEST(obj);
-
-    sev->sev_device = g_strdup(value);
-}
-
-static bool sev_guest_get_kernel_hashes(Object *obj, Error **errp)
-{
-    SevGuestState *sev = SEV_GUEST(obj);
-
-    return sev->kernel_hashes;
-}
-
-static void sev_guest_set_kernel_hashes(Object *obj, bool value, Error **errp)
-{
-    SevGuestState *sev = SEV_GUEST(obj);
-
-    sev->kernel_hashes = value;
-}
-
 bool
 sev_enabled(void)
 {
-    return !!sev_guest;
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+
+    return !!object_dynamic_cast(OBJECT(cgs), TYPE_SEV_COMMON);
 }
 
 bool
 sev_es_enabled(void)
 {
-    return sev_enabled() && (sev_guest->policy & SEV_POLICY_ES);
+    ConfidentialGuestSupport *cgs = MACHINE(qdev_get_machine())->cgs;
+
+    return sev_enabled() && (SEV_GUEST(cgs)->policy & SEV_POLICY_ES);
 }
 
 uint32_t
 sev_get_cbit_position(void)
 {
-    return sev_guest ? sev_guest->cbitpos : 0;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
+    return sev_common ? sev_common->cbitpos : 0;
 }
 
 uint32_t
 sev_get_reduced_phys_bits(void)
 {
-    return sev_guest ? sev_guest->reduced_phys_bits : 0;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
+    return sev_common ? sev_common->reduced_phys_bits : 0;
 }
 
 static SevInfo *sev_get_info(void)
 {
     SevInfo *info;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    SevGuestState *sev_guest =
+        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
+                                             TYPE_SEV_GUEST);
 
     info = g_new0(SevInfo, 1);
     info->enabled = sev_enabled();
 
     if (info->enabled) {
-        info->api_major = sev_guest->api_major;
-        info->api_minor = sev_guest->api_minor;
-        info->build_id = sev_guest->build_id;
-        info->policy = sev_guest->policy;
-        info->state = sev_guest->state;
-        info->handle = sev_guest->handle;
+        if (sev_guest) {
+            info->handle = sev_guest->handle;
+        }
+        info->api_major = sev_common->api_major;
+        info->api_minor = sev_common->api_minor;
+        info->build_id = sev_common->build_id;
+        info->state = sev_common->state;
+        /* we only report the lower 32-bits of policy for SNP, ok for now... */
+        info->policy =
+            (uint32_t)object_property_get_uint(OBJECT(sev_common),
+                                               "policy", NULL);
     }
 
     return info;
@@ -519,6 +473,8 @@ static SevCapability *sev_get_capabilities(Error **errp)
     size_t pdh_len = 0, cert_chain_len = 0, cpu0_id_len = 0;
     uint32_t ebx;
     int fd;
+    SevCommonState *sev_common;
+    char *sev_device;
 
     if (!kvm_enabled()) {
         error_setg(errp, "KVM not enabled");
@@ -529,12 +485,21 @@ static SevCapability *sev_get_capabilities(Error **errp)
         return NULL;
     }
 
-    fd = open(DEFAULT_SEV_DEVICE, O_RDWR);
+    sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    if (!sev_common) {
+        error_setg(errp, "SEV is not configured");
+    }
+
+    sev_device = object_property_get_str(OBJECT(sev_common), "sev-device",
+                                         &error_abort);
+    fd = open(sev_device, O_RDWR);
     if (fd < 0) {
         error_setg_errno(errp, errno, "SEV: Failed to open %s",
                          DEFAULT_SEV_DEVICE);
+        g_free(sev_device);
         return NULL;
     }
+    g_free(sev_device);
 
     if (sev_get_pdh_info(fd, &pdh_data, &pdh_len,
                          &cert_chain_data, &cert_chain_len, errp)) {
@@ -577,7 +542,7 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
 {
     struct kvm_sev_attestation_report input = {};
     SevAttestationReport *report = NULL;
-    SevGuestState *sev = sev_guest;
+    SevCommonState *sev_common;
     g_autofree guchar *data = NULL;
     g_autofree guchar *buf = NULL;
     gsize len;
@@ -602,8 +567,10 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
         return NULL;
     }
 
+    sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
     /* Query the report length */
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
             &input, &err);
     if (ret < 0) {
         if (err != SEV_RET_INVALID_LEN) {
@@ -619,7 +586,7 @@ static SevAttestationReport *sev_get_attestation_report(const char *mnonce,
     memcpy(input.mnonce, buf, sizeof(input.mnonce));
 
     /* Query the report */
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_GET_ATTESTATION_REPORT,
             &input, &err);
     if (ret) {
         error_setg_errno(errp, errno, "SEV: Failed to get attestation report"
@@ -659,26 +626,27 @@ sev_read_file_base64(const char *filename, guchar **data, gsize *len)
 }
 
 static int
-sev_launch_start(SevGuestState *sev)
+sev_launch_start(SevGuestState *sev_guest)
 {
     gsize sz;
     int ret = 1;
     int fw_error, rc;
     struct kvm_sev_launch_start start = {
-        .handle = sev->handle, .policy = sev->policy
+        .handle = sev_guest->handle, .policy = sev_guest->policy
     };
     guchar *session = NULL, *dh_cert = NULL;
+    SevCommonState *sev_common = SEV_COMMON(sev_guest);
 
-    if (sev->session_file) {
-        if (sev_read_file_base64(sev->session_file, &session, &sz) < 0) {
+    if (sev_guest->session_file) {
+        if (sev_read_file_base64(sev_guest->session_file, &session, &sz) < 0) {
             goto out;
         }
         start.session_uaddr = (unsigned long)session;
         start.session_len = sz;
     }
 
-    if (sev->dh_cert_file) {
-        if (sev_read_file_base64(sev->dh_cert_file, &dh_cert, &sz) < 0) {
+    if (sev_guest->dh_cert_file) {
+        if (sev_read_file_base64(sev_guest->dh_cert_file, &dh_cert, &sz) < 0) {
             goto out;
         }
         start.dh_uaddr = (unsigned long)dh_cert;
@@ -686,15 +654,15 @@ sev_launch_start(SevGuestState *sev)
     }
 
     trace_kvm_sev_launch_start(start.policy, session, dh_cert);
-    rc = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_START, &start, &fw_error);
+    rc = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_START, &start, &fw_error);
     if (rc < 0) {
         error_report("%s: LAUNCH_START ret=%d fw_error=%d '%s'",
                 __func__, ret, fw_error, fw_error_to_str(fw_error));
         goto out;
     }
 
-    sev_set_guest_state(sev, SEV_STATE_LAUNCH_UPDATE);
-    sev->handle = start.handle;
+    sev_set_guest_state(sev_common, SEV_STATE_LAUNCH_UPDATE);
+    sev_guest->handle = start.handle;
     ret = 0;
 
 out:
@@ -704,7 +672,7 @@ out:
 }
 
 static int
-sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
+sev_launch_update_data(SevGuestState *sev_guest, uint8_t *addr, uint64_t len)
 {
     int ret, fw_error;
     struct kvm_sev_launch_update_data update;
@@ -716,7 +684,7 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
     update.uaddr = (uintptr_t)addr;
     update.len = len;
     trace_kvm_sev_launch_update_data(addr, len);
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
+    ret = sev_ioctl(SEV_COMMON(sev_guest)->sev_fd, KVM_SEV_LAUNCH_UPDATE_DATA,
                     &update, &fw_error);
     if (ret) {
         error_report("%s: LAUNCH_UPDATE ret=%d fw_error=%d '%s'",
@@ -727,11 +695,12 @@ sev_launch_update_data(SevGuestState *sev, uint8_t *addr, uint64_t len)
 }
 
 static int
-sev_launch_update_vmsa(SevGuestState *sev)
+sev_launch_update_vmsa(SevGuestState *sev_guest)
 {
     int ret, fw_error;
 
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_UPDATE_VMSA, NULL, &fw_error);
+    ret = sev_ioctl(SEV_COMMON(sev_guest)->sev_fd, KVM_SEV_LAUNCH_UPDATE_VMSA,
+                    NULL, &fw_error);
     if (ret) {
         error_report("%s: LAUNCH_UPDATE_VMSA ret=%d fw_error=%d '%s'",
                 __func__, ret, fw_error, fw_error_to_str(fw_error));
@@ -743,18 +712,19 @@ sev_launch_update_vmsa(SevGuestState *sev)
 static void
 sev_launch_get_measure(Notifier *notifier, void *unused)
 {
-    SevGuestState *sev = sev_guest;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    SevGuestState *sev_guest = SEV_GUEST(sev_common);
     int ret, error;
     g_autofree guchar *data = NULL;
     struct kvm_sev_launch_measure measurement = {};
 
-    if (!sev_check_state(sev, SEV_STATE_LAUNCH_UPDATE)) {
+    if (!sev_check_state(sev_common, SEV_STATE_LAUNCH_UPDATE)) {
         return;
     }
 
     if (sev_es_enabled()) {
         /* measure all the VM save areas before getting launch_measure */
-        ret = sev_launch_update_vmsa(sev);
+        ret = sev_launch_update_vmsa(sev_guest);
         if (ret) {
             exit(1);
         }
@@ -762,7 +732,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     }
 
     /* query the measurement blob length */
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_MEASURE,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_MEASURE,
                     &measurement, &error);
     if (!measurement.len) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
@@ -774,7 +744,7 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
     measurement.uaddr = (unsigned long)data;
 
     /* get the measurement blob */
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_MEASURE,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_MEASURE,
                     &measurement, &error);
     if (ret) {
         error_report("%s: LAUNCH_MEASURE ret=%d fw_error=%d '%s'",
@@ -782,17 +752,19 @@ sev_launch_get_measure(Notifier *notifier, void *unused)
         return;
     }
 
-    sev_set_guest_state(sev, SEV_STATE_LAUNCH_SECRET);
+    sev_set_guest_state(sev_common, SEV_STATE_LAUNCH_SECRET);
 
     /* encode the measurement value and emit the event */
-    sev->measurement = g_base64_encode(data, measurement.len);
-    trace_kvm_sev_launch_measurement(sev->measurement);
+    sev_guest->measurement = g_base64_encode(data, measurement.len);
+    trace_kvm_sev_launch_measurement(sev_guest->measurement);
 }
 
 static char *sev_get_launch_measurement(void)
 {
+    SevGuestState *sev_guest = SEV_GUEST(MACHINE(qdev_get_machine())->cgs);
+
     if (sev_guest &&
-        sev_guest->state >= SEV_STATE_LAUNCH_SECRET) {
+        SEV_COMMON(sev_guest)->state >= SEV_STATE_LAUNCH_SECRET) {
         return g_strdup(sev_guest->measurement);
     }
 
@@ -821,19 +793,20 @@ static Notifier sev_machine_done_notify = {
 };
 
 static void
-sev_launch_finish(SevGuestState *sev)
+sev_launch_finish(SevGuestState *sev_guest)
 {
     int ret, error;
 
     trace_kvm_sev_launch_finish();
-    ret = sev_ioctl(sev->sev_fd, KVM_SEV_LAUNCH_FINISH, 0, &error);
+    ret = sev_ioctl(SEV_COMMON(sev_guest)->sev_fd, KVM_SEV_LAUNCH_FINISH, 0,
+                    &error);
     if (ret) {
         error_report("%s: LAUNCH_FINISH ret=%d fw_error=%d '%s'",
                      __func__, ret, error, fw_error_to_str(error));
         exit(1);
     }
 
-    sev_set_guest_state(sev, SEV_STATE_RUNNING);
+    sev_set_guest_state(SEV_COMMON(sev_guest), SEV_STATE_RUNNING);
 
     /* add migration blocker */
     error_setg(&sev_mig_blocker,
@@ -844,38 +817,39 @@ sev_launch_finish(SevGuestState *sev)
 static void
 sev_vm_state_change(void *opaque, bool running, RunState state)
 {
-    SevGuestState *sev = opaque;
+    SevCommonState *sev_common = opaque;
 
     if (running) {
-        if (!sev_check_state(sev, SEV_STATE_RUNNING)) {
-            sev_launch_finish(sev);
+        if (!sev_check_state(sev_common, SEV_STATE_RUNNING)) {
+            sev_launch_finish(SEV_GUEST(sev_common));
         }
     }
 }
 
 static int sev_kvm_type(X86ConfidentialGuest *cg)
 {
-    SevGuestState *sev = SEV_GUEST(cg);
+    SevCommonState *sev_common = SEV_COMMON(cg);
+    SevGuestState *sev_guest = SEV_GUEST(sev_common);
     int kvm_type;
 
-    if (sev->kvm_type != -1) {
+    if (sev_common->kvm_type != -1) {
         goto out;
     }
 
-    kvm_type = (sev->policy & SEV_POLICY_ES) ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
+    kvm_type = (sev_guest->policy & SEV_POLICY_ES) ? KVM_X86_SEV_ES_VM : KVM_X86_SEV_VM;
     if (kvm_is_vm_type_supported(kvm_type)) {
-        sev->kvm_type = kvm_type;
+        sev_common->kvm_type = kvm_type;
     } else {
-        sev->kvm_type = KVM_X86_DEFAULT_VM;
+        sev_common->kvm_type = KVM_X86_DEFAULT_VM;
     }
 
 out:
-    return sev->kvm_type;
+    return sev_common->kvm_type;
 }
 
 static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
-    SevGuestState *sev = SEV_GUEST(cgs);
+    SevCommonState *sev_common = SEV_COMMON(cgs);
     char *devname;
     int ret, fw_error, cmd;
     uint32_t ebx;
@@ -888,8 +862,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
-    sev_guest = sev;
-    sev->state = SEV_STATE_UNINIT;
+    sev_common->state = SEV_STATE_UNINIT;
 
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
     host_cbitpos = ebx & 0x3f;
@@ -899,9 +872,9 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
      * register of CPUID 0x8000001F. No need to verify the range as the
      * comparison against the host value accomplishes that.
      */
-    if (host_cbitpos != sev->cbitpos) {
+    if (host_cbitpos != sev_common->cbitpos) {
         error_setg(errp, "%s: cbitpos check failed, host '%d' requested '%d'",
-                   __func__, host_cbitpos, sev->cbitpos);
+                   __func__, host_cbitpos, sev_common->cbitpos);
         goto err;
     }
 
@@ -910,16 +883,16 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
      * the EBX register of CPUID 0x8000001F, so verify the supplied value
      * is in the range of 1 to 63.
      */
-    if (sev->reduced_phys_bits < 1 || sev->reduced_phys_bits > 63) {
+    if (sev_common->reduced_phys_bits < 1 || sev_common->reduced_phys_bits > 63) {
         error_setg(errp, "%s: reduced_phys_bits check failed,"
                    " it should be in the range of 1 to 63, requested '%d'",
-                   __func__, sev->reduced_phys_bits);
+                   __func__, sev_common->reduced_phys_bits);
         goto err;
     }
 
-    devname = object_property_get_str(OBJECT(sev), "sev-device", NULL);
-    sev->sev_fd = open(devname, O_RDWR);
-    if (sev->sev_fd < 0) {
+    devname = object_property_get_str(OBJECT(sev_common), "sev-device", NULL);
+    sev_common->sev_fd = open(devname, O_RDWR);
+    if (sev_common->sev_fd < 0) {
         error_setg(errp, "%s: Failed to open %s '%s'", __func__,
                    devname, strerror(errno));
         g_free(devname);
@@ -927,7 +900,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
     g_free(devname);
 
-    ret = sev_platform_ioctl(sev->sev_fd, SEV_PLATFORM_STATUS, &status,
+    ret = sev_platform_ioctl(sev_common->sev_fd, SEV_PLATFORM_STATUS, &status,
                              &fw_error);
     if (ret) {
         error_setg(errp, "%s: failed to get platform status ret=%d "
@@ -935,9 +908,9 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
                    fw_error_to_str(fw_error));
         goto err;
     }
-    sev->build_id = status.build;
-    sev->api_major = status.api_major;
-    sev->api_minor = status.api_minor;
+    sev_common->build_id = status.build;
+    sev_common->api_major = status.api_major;
+    sev_common->api_minor = status.api_minor;
 
     if (sev_es_enabled()) {
         if (!kvm_kernel_irqchip_allowed()) {
@@ -955,14 +928,14 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     }
 
     trace_kvm_sev_init();
-    if (sev_kvm_type(X86_CONFIDENTIAL_GUEST(sev)) == KVM_X86_DEFAULT_VM) {
+    if (sev_kvm_type(X86_CONFIDENTIAL_GUEST(sev_common)) == KVM_X86_DEFAULT_VM) {
         cmd = sev_es_enabled() ? KVM_SEV_ES_INIT : KVM_SEV_INIT;
 
-        ret = sev_ioctl(sev->sev_fd, cmd, NULL, &fw_error);
+        ret = sev_ioctl(sev_common->sev_fd, cmd, NULL, &fw_error);
     } else {
         struct kvm_sev_init args = { 0 };
 
-        ret = sev_ioctl(sev->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
+        ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_INIT2, &args, &fw_error);
     }
 
     if (ret) {
@@ -971,7 +944,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         goto err;
     }
 
-    ret = sev_launch_start(sev);
+    ret = sev_launch_start(SEV_GUEST(sev_common));
     if (ret) {
         error_setg(errp, "%s: failed to create encryption context", __func__);
         goto err;
@@ -979,13 +952,12 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     ram_block_notifier_add(&sev_ram_notifier);
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
-    qemu_add_vm_change_state_handler(sev_vm_state_change, sev);
+    qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
 
     cgs->ready = true;
 
     return 0;
 err:
-    sev_guest = NULL;
     ram_block_discard_disable(false);
     return -1;
 }
@@ -993,13 +965,15 @@ err:
 int
 sev_encrypt_flash(uint8_t *ptr, uint64_t len, Error **errp)
 {
-    if (!sev_guest) {
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+
+    if (!sev_common) {
         return 0;
     }
 
     /* if SEV is in update state then encrypt the data else do nothing */
-    if (sev_check_state(sev_guest, SEV_STATE_LAUNCH_UPDATE)) {
-        int ret = sev_launch_update_data(sev_guest, ptr, len);
+    if (sev_check_state(sev_common, SEV_STATE_LAUNCH_UPDATE)) {
+        int ret = sev_launch_update_data(SEV_GUEST(sev_common), ptr, len);
         if (ret < 0) {
             error_setg(errp, "SEV: Failed to encrypt pflash rom");
             return ret;
@@ -1019,16 +993,17 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
     void *hva;
     gsize hdr_sz = 0, data_sz = 0;
     MemoryRegion *mr = NULL;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
-    if (!sev_guest) {
+    if (!sev_common) {
         error_setg(errp, "SEV not enabled for guest");
         return 1;
     }
 
     /* secret can be injected only in this state */
-    if (!sev_check_state(sev_guest, SEV_STATE_LAUNCH_SECRET)) {
+    if (!sev_check_state(sev_common, SEV_STATE_LAUNCH_SECRET)) {
         error_setg(errp, "SEV: Not in correct state. (LSECRET) %x",
-                     sev_guest->state);
+                   sev_common->state);
         return 1;
     }
 
@@ -1062,7 +1037,7 @@ int sev_inject_launch_secret(const char *packet_hdr, const char *secret,
     trace_kvm_sev_launch_secret(gpa, input.guest_uaddr,
                                 input.trans_uaddr, input.trans_len);
 
-    ret = sev_ioctl(sev_guest->sev_fd, KVM_SEV_LAUNCH_SECRET,
+    ret = sev_ioctl(sev_common->sev_fd, KVM_SEV_LAUNCH_SECRET,
                     &input, &error);
     if (ret) {
         error_setg(errp, "SEV: failed to inject secret ret=%d fw_error=%d '%s'",
@@ -1169,9 +1144,10 @@ void sev_es_set_reset_vector(CPUState *cpu)
 {
     X86CPU *x86;
     CPUX86State *env;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
     /* Only update if we have valid reset information */
-    if (!sev_guest || !sev_guest->reset_data_valid) {
+    if (!sev_common || !sev_common->reset_data_valid) {
         return;
     }
 
@@ -1183,11 +1159,11 @@ void sev_es_set_reset_vector(CPUState *cpu)
     x86 = X86_CPU(cpu);
     env = &x86->env;
 
-    cpu_x86_load_seg_cache(env, R_CS, 0xf000, sev_guest->reset_cs, 0xffff,
+    cpu_x86_load_seg_cache(env, R_CS, 0xf000, sev_common->reset_cs, 0xffff,
                            DESC_P_MASK | DESC_S_MASK | DESC_CS_MASK |
                            DESC_R_MASK | DESC_A_MASK);
 
-    env->eip = sev_guest->reset_ip;
+    env->eip = sev_common->reset_ip;
 }
 
 int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
@@ -1195,6 +1171,7 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
     CPUState *cpu;
     uint32_t addr;
     int ret;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
 
     if (!sev_es_enabled()) {
         return 0;
@@ -1208,9 +1185,9 @@ int sev_es_save_reset_vector(void *flash_ptr, uint64_t flash_size)
     }
 
     if (addr) {
-        sev_guest->reset_cs = addr & 0xffff0000;
-        sev_guest->reset_ip = addr & 0x0000ffff;
-        sev_guest->reset_data_valid = true;
+        sev_common->reset_cs = addr & 0xffff0000;
+        sev_common->reset_ip = addr & 0x0000ffff;
+        sev_common->reset_data_valid = true;
 
         CPU_FOREACH(cpu) {
             sev_es_set_reset_vector(cpu);
@@ -1256,12 +1233,17 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     hwaddr mapped_len = sizeof(*padded_ht);
     MemTxAttrs attrs = { 0 };
     bool ret = true;
+    SevCommonState *sev_common = SEV_COMMON(MACHINE(qdev_get_machine())->cgs);
+    SevGuestState *sev_guest =
+        (SevGuestState *)object_dynamic_cast(OBJECT(sev_common),
+                                             TYPE_SEV_GUEST);
 
     /*
      * Only add the kernel hashes if the sev-guest configuration explicitly
-     * stated kernel-hashes=on.
+     * stated kernel-hashes=on. Currently only enabled for SEV/SEV-ES guests,
+     * so check for TYPE_SEV_GUEST as well.
      */
-    if (!sev_guest->kernel_hashes) {
+    if (sev_guest && !sev_guest->kernel_hashes) {
         return false;
     }
 
@@ -1352,8 +1334,20 @@ bool sev_add_kernel_loader_hashes(SevKernelLoaderContext *ctx, Error **errp)
     return ret;
 }
 
+static char *
+sev_common_get_sev_device(Object *obj, Error **errp)
+{
+    return g_strdup(SEV_COMMON(obj)->sev_device);
+}
+
 static void
-sev_guest_class_init(ObjectClass *oc, void *data)
+sev_common_set_sev_device(Object *obj, const char *value, Error **errp)
+{
+    SEV_COMMON(obj)->sev_device = g_strdup(value);
+}
+
+static void
+sev_common_class_init(ObjectClass *oc, void *data)
 {
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
     X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
@@ -1362,10 +1356,85 @@ sev_guest_class_init(ObjectClass *oc, void *data)
     x86_klass->kvm_type = sev_kvm_type;
 
     object_class_property_add_str(oc, "sev-device",
-                                  sev_guest_get_sev_device,
-                                  sev_guest_set_sev_device);
+                                  sev_common_get_sev_device,
+                                  sev_common_set_sev_device);
     object_class_property_set_description(oc, "sev-device",
             "SEV device to use");
+}
+
+static void
+sev_common_instance_init(Object *obj)
+{
+    SevCommonState *sev_common = SEV_COMMON(obj);
+
+    sev_common->kvm_type = -1;
+
+    sev_common->sev_device = g_strdup(DEFAULT_SEV_DEVICE);
+
+    object_property_add_uint32_ptr(obj, "cbitpos", &sev_common->cbitpos,
+                                   OBJ_PROP_FLAG_READWRITE);
+    object_property_add_uint32_ptr(obj, "reduced-phys-bits",
+                                   &sev_common->reduced_phys_bits,
+                                   OBJ_PROP_FLAG_READWRITE);
+}
+
+/* sev guest info common to sev/sev-es/sev-snp */
+static const TypeInfo sev_common_info = {
+    .parent = TYPE_X86_CONFIDENTIAL_GUEST,
+    .name = TYPE_SEV_COMMON,
+    .instance_size = sizeof(SevCommonState),
+    .class_init = sev_common_class_init,
+    .instance_init = sev_common_instance_init,
+    .abstract = true,
+    .interfaces = (InterfaceInfo[]) {
+        { TYPE_USER_CREATABLE },
+        { }
+    }
+};
+
+static char *
+sev_guest_get_dh_cert_file(Object *obj, Error **errp)
+{
+    return g_strdup(SEV_GUEST(obj)->dh_cert_file);
+}
+
+static void
+sev_guest_set_dh_cert_file(Object *obj, const char *value, Error **errp)
+{
+    SEV_GUEST(obj)->dh_cert_file = g_strdup(value);
+}
+
+static char *
+sev_guest_get_session_file(Object *obj, Error **errp)
+{
+    SevGuestState *sev_guest = SEV_GUEST(obj);
+
+    return sev_guest->session_file ? g_strdup(sev_guest->session_file) : NULL;
+}
+
+static void
+sev_guest_set_session_file(Object *obj, const char *value, Error **errp)
+{
+    SEV_GUEST(obj)->session_file = g_strdup(value);
+}
+
+static bool sev_guest_get_kernel_hashes(Object *obj, Error **errp)
+{
+    SevGuestState *sev_guest = SEV_GUEST(obj);
+
+    return sev_guest->kernel_hashes;
+}
+
+static void sev_guest_set_kernel_hashes(Object *obj, bool value, Error **errp)
+{
+    SevGuestState *sev = SEV_GUEST(obj);
+
+    sev->kernel_hashes = value;
+}
+
+static void
+sev_guest_class_init(ObjectClass *oc, void *data)
+{
     object_class_property_add_str(oc, "dh-cert-file",
                                   sev_guest_get_dh_cert_file,
                                   sev_guest_set_dh_cert_file);
@@ -1386,40 +1455,28 @@ sev_guest_class_init(ObjectClass *oc, void *data)
 static void
 sev_guest_instance_init(Object *obj)
 {
-    SevGuestState *sev = SEV_GUEST(obj);
+    SevGuestState *sev_guest = SEV_GUEST(obj);
 
-    sev->kvm_type = -1;
-
-    sev->sev_device = g_strdup(DEFAULT_SEV_DEVICE);
-    sev->policy = DEFAULT_GUEST_POLICY;
-    object_property_add_uint32_ptr(obj, "policy", &sev->policy,
-                                   OBJ_PROP_FLAG_READWRITE);
-    object_property_add_uint32_ptr(obj, "handle", &sev->handle,
-                                   OBJ_PROP_FLAG_READWRITE);
-    object_property_add_uint32_ptr(obj, "cbitpos", &sev->cbitpos,
+    sev_guest->policy = DEFAULT_GUEST_POLICY;
+    object_property_add_uint32_ptr(obj, "handle", &sev_guest->handle,
                                    OBJ_PROP_FLAG_READWRITE);
-    object_property_add_uint32_ptr(obj, "reduced-phys-bits",
-                                   &sev->reduced_phys_bits,
+    object_property_add_uint32_ptr(obj, "policy", &sev_guest->policy,
                                    OBJ_PROP_FLAG_READWRITE);
 }
 
-/* sev guest info */
+/* guest info specific sev/sev-es */
 static const TypeInfo sev_guest_info = {
-    .parent = TYPE_X86_CONFIDENTIAL_GUEST,
+    .parent = TYPE_SEV_COMMON,
     .name = TYPE_SEV_GUEST,
     .instance_size = sizeof(SevGuestState),
-    .instance_finalize = sev_guest_finalize,
-    .class_init = sev_guest_class_init,
     .instance_init = sev_guest_instance_init,
-    .interfaces = (InterfaceInfo[]) {
-        { TYPE_USER_CREATABLE },
-        { }
-    }
+    .class_init = sev_guest_class_init,
 };
 
 static void
 sev_register_types(void)
 {
+    type_register_static(&sev_common_info);
     type_register_static(&sev_guest_info);
 }
 
diff --git a/target/i386/sev.h b/target/i386/sev.h
index 9e10d09539..668374eef3 100644
--- a/target/i386/sev.h
+++ b/target/i386/sev.h
@@ -20,6 +20,9 @@
 
 #include "exec/confidential-guest-support.h"
 
+#define TYPE_SEV_COMMON "sev-common"
+#define TYPE_SEV_GUEST "sev-guest"
+
 #define SEV_POLICY_NODBG        0x1
 #define SEV_POLICY_NOKS         0x2
 #define SEV_POLICY_ES           0x4
-- 
2.25.1


