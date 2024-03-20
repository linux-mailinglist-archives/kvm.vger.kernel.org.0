Return-Path: <kvm+bounces-12264-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 68A05880E06
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:56:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F3FA28474B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:56:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C80438DE9;
	Wed, 20 Mar 2024 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="w2jnqHXw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2047.outbound.protection.outlook.com [40.107.94.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9064D747F
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924996; cv=fail; b=RLRarqOpkEMJaD+ECf7KEFHiMqWcJ31zOUO1H9Vl7rTACvlsJtqbjJlm2jurHqg/vB9z2tilS3LkrdC3NIbjrcA+6jYE2VdZ95lLeuxHAg4I1ESeU+5+ZMPLK9IKlkK2BYo4oRlBNEcTewo+mZyHwdrUZm5OWOoj0oSkFRqIO1g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924996; c=relaxed/simple;
	bh=+efubz3DzoeXoMpujvuKFCKFVtflLIcmbL4V9d3x4WM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K8aKNigOMJ7BnCMTsRhOTZlEXEyOe3YRMaeSsrRQVng/67s+F/lc2NNDCs7OCWWav5gurS9PmPjfoFnUfnLUAa+UI3iEB8Vr2Ec1bcJ2on5tE2tCyYokZgXLrsDWotr4ji5QjgtV5beufqoOhoBubeR9iNM+LyIlEHn48H17AVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=w2jnqHXw; arc=fail smtp.client-ip=40.107.94.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ERUPASCW6PMt6/5/HkAc9uaW682IecIoXTOsZeL55Aq2u+CIK8ECYZz+IQOc0QNTkhw49JCDCNGup3IiekeSlFBfdtsX3pq8h/f59rYI0eUVAfNb1b8aMwekCQXMTWfHk8I+Mb689jd1f3TCAd670HWOjmolWBTJ4VZODd8vIuQK+VX01EqibPlAzyQPEx6aByI4Jp7+w37CCguiCbWBE91Gg/THWl+JMdvhG8VFI17lDQodm1GsHgSaGcaP0WXbQ/z0am0J2YaV1xtbmK+5eshhAP0oAjkRTxKlmSUjziNVj7BQcG3wA7IUf2QIuSG1SdIXDGwsonVtuOEUr7RloA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B0Ga6hkIq4PMlehO1h4QdPsKNE+e6tDuLWJwPmSvLCE=;
 b=eNfkIB5LwsBqxY9IJcy8uLLs+Gn5+SfwgbpgW1x/YLS9Euc0uexYj5xKvvWdoMmkBJWTNJwWJEtfxaDY78BclfdsSNiramNIj+8S0iPtsr5T/9E4iVWO3JjQyw2OBljjH+hWuy+HRpWW0RFPUO8vaN/kdK+5htmnGlVZ9k7d0yzSlq853PS9ByqxBqRMEGODbDVLx6o73lS90sPviGj9oxTITZAFqr9i63n6E4gq720VFDQzZDDL2u17oK10MaSaPirXukh0f+MdtOLKSBPYpPF350NaqanAn0iB1xrIXtwGZG0RPvHwyPTqEPTCI5Dyjwd4msxglxXshINcYbB4xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B0Ga6hkIq4PMlehO1h4QdPsKNE+e6tDuLWJwPmSvLCE=;
 b=w2jnqHXwNlYrzQTqQNt73DSQwf7WRqUf/h7wsZOUurep7ddWZvmQSFpBHYClE8HuaxwXFuxXpBODy6UiEhQlCt8H4rKUDEbxNo5dx3mSYhTJFM1iiNGFGC3J3YIS+zYCU4gl+ZTrk3PirR3n7QR2+jnegbbrbZiwB5lKqj39o0k=
Received: from BYAPR07CA0045.namprd07.prod.outlook.com (2603:10b6:a03:60::22)
 by DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.28; Wed, 20 Mar 2024 08:56:31 +0000
Received: from CO1PEPF000044F3.namprd05.prod.outlook.com
 (2603:10b6:a03:60:cafe::3c) by BYAPR07CA0045.outlook.office365.com
 (2603:10b6:a03:60::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26 via Frontend
 Transport; Wed, 20 Mar 2024 08:56:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF000044F3.mail.protection.outlook.com (10.167.241.73) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:56:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:56:30 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 49/49] hw/i386: Add support for loading BIOS using guest_memfd
Date: Wed, 20 Mar 2024 03:39:45 -0500
Message-ID: <20240320083945.991426-50-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF000044F3:EE_|DM4PR12MB9072:EE_
X-MS-Office365-Filtering-Correlation-Id: 17a210e5-dd6a-4b73-0ab1-08dc48bba35c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lud8KTiiKCE/PkaJr7NuWRmzXft5G6zDAx+WQKgbC9yxAO6mP5FjVoJSdry30VmDcsq0U4hgDr6KTNeNsBmkKOCNblwPij3dO229DmUFAHyJ1vZeGzc+k5jnITHlDreFVqvtSpDRi3c08wlTv4E2Ql70Z/eqWJ9328mkwPG3erGGBfKQQ9pCxPk8MO7ZHQjb7AC2BVbl/wl65MABhPi2+6MYfMIZ60+z+ZLgZZ2y3wxaxbHwv8Nzs2euTHmUU5EkP3PY8LpHCqYpO/rSgK22nVpB2keVbBbSdDJPH1QUUn38tnEcohph8LS7kyTCD23p/uhvFd+CkSywzFIFcqJoIlRGzDpkxrsX3Ikv8WsvQ/51o+wUraSkc7GjciW0hXmzAnU8+nWuYnyIbRAp001+qIXH6d9M3BeWiGr+iwLm246Xs6Z/oGZbg+ml1EDV8QeWAdKb0giK5gAztFGwKgH+WQNELBR7Y+Q2rH3Tiyt2v0cJoV0Guyk6RMP1LnHubk1Q2t2rimJetPPIjgIyJ+E15BiYcs3jglRIFgim373BZsmsyTRQkUfdXUVIfoiHhWFU8PofW3CNatj/L1vUxZ7Q5/KVXTIFC7YQ74E+BhQT1BtqgwW4yo8YhdBmwUEVbDIea9dmnh7fsVQEj+ZHaNlLjnkZDiqGS2z0nYcpcVMPwH0OPghUY9sNjZwgTWg/zx7K2zH8GESL46JUNkOcXevUBtQMoQeQ7gDRnXIXYv0UK+az4pUdE383eF9v6unPABO3
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:56:31.4851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 17a210e5-dd6a-4b73-0ab1-08dc48bba35c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9072

TODO: - Add proper handling for non-64K-aligned BIOS images.
      - Add proper handling for BIOS pflash area which should be
        initially mapped as shared, resulting in unecessary
        KVM_EXIT_MEMORY_FAULTs

When guest_memfd is enabled, the BIOS is generally part of the initial
encrypted guest image and will be accessed as private guest memory. Add
the necessary changes to set up the associated RAM region with a
guest_memfd backend to allow for this.

Current support centers around using -bios to load the BIOS data.
Support for loading the BIOS via pflash requires additional enablement
since those interfaces rely on the use of ROM memory regions which make
use of the KVM_MEM_READONLY memslot flag, which is not supported for
guest_memfd-backed memslots.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 hw/i386/x86.c | 36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index e3ddc39133..ea2d03cc02 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1147,10 +1147,18 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
     }
     if (bios_size <= 0 ||
         (bios_size % 65536) != 0) {
-        goto bios_error;
+        g_warning("%s: Unaligned BIOS size %d", __func__, bios_size);
+        if (!machine_require_guest_memfd(ms)) {
+            goto bios_error;
+        }
     }
     bios = g_malloc(sizeof(*bios));
-    memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal);
+    if (machine_require_guest_memfd(ms)) {
+        memory_region_init_ram_guest_memfd(bios, NULL, "pc.bios", bios_size,
+                                           &error_fatal);
+    } else {
+        memory_region_init_ram(bios, NULL, "pc.bios", bios_size, &error_fatal);
+    }
     if (sev_enabled()) {
         /*
          * The concept of a "reset" simply doesn't exist for
@@ -1173,17 +1181,19 @@ void x86_bios_rom_init(MachineState *ms, const char *default_firmware,
     }
     g_free(filename);
 
-    /* map the last 128KB of the BIOS in ISA space */
-    isa_bios_size = MIN(bios_size, 128 * KiB);
-    isa_bios = g_malloc(sizeof(*isa_bios));
-    memory_region_init_alias(isa_bios, NULL, "isa-bios", bios,
-                             bios_size - isa_bios_size, isa_bios_size);
-    memory_region_add_subregion_overlap(rom_memory,
-                                        0x100000 - isa_bios_size,
-                                        isa_bios,
-                                        1);
-    if (!isapc_ram_fw) {
-        memory_region_set_readonly(isa_bios, true);
+    if (!machine_require_guest_memfd(ms)) {
+        /* map the last 128KB of the BIOS in ISA space */
+        isa_bios_size = MIN(bios_size, 128 * KiB);
+        isa_bios = g_malloc(sizeof(*isa_bios));
+        memory_region_init_alias(isa_bios, NULL, "isa-bios", bios,
+                                 bios_size - isa_bios_size, isa_bios_size);
+        memory_region_add_subregion_overlap(rom_memory,
+                                            0x100000 - isa_bios_size,
+                                            isa_bios,
+                                            1);
+        if (!isapc_ram_fw) {
+            memory_region_set_readonly(isa_bios, true);
+        }
     }
 
     /* map all the bios at the top of memory */
-- 
2.25.1


