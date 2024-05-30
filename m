Return-Path: <kvm+bounces-18395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CE1F8D4A29
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 13:17:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0B12B2444E
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 11:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 059DE17D353;
	Thu, 30 May 2024 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VQvIaYIn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5C317838E
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 11:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717067815; cv=fail; b=Y4p0Bzq2UXDM+ECr1qY0MF7GLk6wq/w3Klh59RqvX+u+VW3yHCMBGUC8hZMQs84fKYuyAnJ8yxMpzvSpRCjEiWAH2HoEx5RDCDIbiKwhc+95SxUyBCuJwCprEFUUDof3QERePZpyFwPMbEtwAZOVmNSp0j/DO9Kmbnbo1aSfGt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717067815; c=relaxed/simple;
	bh=X9mT7OqKgqNWJmje2agliALLFVVFg/h+aIWTFEpM6pY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ipI+pZn6je3zPVAxR4eDOFofbBUg9CdARJ77h43nt3araABFCEJ+6zOBbEX1MXbRjvTSJhqpCz23RjJZq7OOX5ULAJ5ko7mmIGE5EC4zbITpHgJWyHDFCMCD3br8hQdPJBuxw9Zi7VHmkF9Z2xC1rVAi9/g5hkp4XnQa+LKm3Vo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VQvIaYIn; arc=fail smtp.client-ip=40.107.94.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ONVUZweZY5w0Ch6pc/Q57oJz0XXxAM3SIczszZHURqFqBty/sZg8mvZC7dTucqzzN3EFuG8ri8kDA8CHfix+otR71Tt62Kf8nif672S+SOjS6w8Lu6+qkVKbvrlvFFGjWDPAVWDssE8EtkNc7wRS4W83o0qVpq+Fnm6Z6j8Hq59nY7y1vQJ6lzH4883IKXGsL+kYg8+ezlpynij3DzdHyEx+Xr83iSv4XFa1d8jtgrtQ3VCUW2HySVoKOAaVl8M3GQzOfXfg11obHXB2Jfddk5/PpdasW9GNiKoq9uA4BzXK4tv20MMU/aOVmx8Fdy9tfNeCoiZwe9VnfztofsRJEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mOWWd6dpD8Ld5HGARp+HdJAUeUGLVeeCQLe07SgrhPs=;
 b=RTdVwl7PsgXY3LBXLtH4bDxNdJCcEtvb74H4NrP5w+lGnpykXJoYxKAIbAFCkpaAKiFRk598LnCt9dRE3BPkplJugI/dc1i9c5+ocPuXE+HWmYy/CA32cJaT1HkHbTmOM2XrROn5hR2okSBm5vaRhGuec+J4JIUtGNyYhZHVPdXV0eswFubofGhhYs28nMHsYUoenlTiGoG2JZSpmMmzWCs19PD8CFRG64FgHtBfo+KoZdh8Bc2oNcgCJz6jf+SkEb8FtQGrSUDrch6df7zFWvmNafJAN7g8H6sD3vLMQsHh+kSoH+HmSwO8dRkA5BgjVIoDVYllzblgMqGhh8/3NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mOWWd6dpD8Ld5HGARp+HdJAUeUGLVeeCQLe07SgrhPs=;
 b=VQvIaYIntTnTiiE4i4AMjwdLAfihSMqnD1A+VNRT5Zl1i581OM/Zpd1OH+W6sapvjO0AQ/sJXjwTi6QANJRnKiysIFSU46pcDS//e2wEYpgUgXyooHlkFLwJ2u8l7A2QdajyDyEm2qk9DGLHtgngiDWpWcUYa7+ZToPzC75R0hU=
Received: from MN2PR15CA0029.namprd15.prod.outlook.com (2603:10b6:208:1b4::42)
 by LV8PR12MB9154.namprd12.prod.outlook.com (2603:10b6:408:190::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Thu, 30 May
 2024 11:16:50 +0000
Received: from BN3PEPF0000B078.namprd04.prod.outlook.com
 (2603:10b6:208:1b4:cafe::32) by MN2PR15CA0029.outlook.office365.com
 (2603:10b6:208:1b4::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.20 via Frontend
 Transport; Thu, 30 May 2024 11:16:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B078.mail.protection.outlook.com (10.167.243.123) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Thu, 30 May 2024 11:16:50 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 06:16:50 -0500
Received: from pankaj-M75q.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server id 15.1.2507.35 via Frontend
 Transport; Thu, 30 May 2024 06:16:49 -0500
From: Pankaj Gupta <pankaj.gupta@amd.com>
To: <qemu-devel@nongnu.org>
CC: <brijesh.singh@amd.com>, <dovmurik@linux.ibm.com>, <armbru@redhat.com>,
	<michael.roth@amd.com>, <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <isaku.yamahata@intel.com>, <berrange@redhat.com>,
	<kvm@vger.kernel.org>, <anisinha@redhat.com>, <pankaj.gupta@amd.com>
Subject: [PATCH v4 09/31] i386/sev: Add sev_kvm_init() override for SEV class
Date: Thu, 30 May 2024 06:16:21 -0500
Message-ID: <20240530111643.1091816-10-pankaj.gupta@amd.com>
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
Received-SPF: None (SATLEXMB04.amd.com: pankaj.gupta@amd.com does not
 designate permitted sender hosts)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B078:EE_|LV8PR12MB9154:EE_
X-MS-Office365-Filtering-Correlation-Id: 7049c21a-8631-41e3-d364-08dc809a00c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|36860700004|1800799015|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ToKYstlZaP5lZ80eDgTBu/Pm75KqoI0CT6Qo20L8/HKH1Whn6AjMNSHr5Wsk?=
 =?us-ascii?Q?tN395Pg95Bq/Out07yE9AqYQISsjrXPWLhZnDe6WVR0cgJoEcrDYkMelMtnQ?=
 =?us-ascii?Q?FtDtdp4S+ziKgt1PUgEpgjwJJYg0eiN1+/sRlK+9XjIAcmWX8kjnEQzlP0BJ?=
 =?us-ascii?Q?vH0zrN59BSuLdNYk04kFJnHqtazP1QuSUIyEdQ55vWZP+cyPAlc/Szt3+R/Y?=
 =?us-ascii?Q?/xFqB0CCeYLkczGhqCN27Bu2A8/g6BorI8XALhrFG2N+49FiFiVhXwv4DxvO?=
 =?us-ascii?Q?4LiULlcH5G6uPSxuzgFXxdSo1aB6UkoOG7W5dh8Hu9qs+kTpgbq4eRc8adU7?=
 =?us-ascii?Q?E1MTUIF7NMEgCXKWCRDJJwEk+Wcr3s7XMmmiM5otayOnERijAM5YrE3BBFY3?=
 =?us-ascii?Q?O32RMxMaBkeoquoosxX5+XGMlz4fP2CdbyLM0v5NRFStNxE1ut3WVlFwNa4R?=
 =?us-ascii?Q?eC4N0B0+aEDkGYh6gVcXWimLagn01S93MaDkO9+bb8RikHlx/jlLvJ7ofxYT?=
 =?us-ascii?Q?U6bEd1df5j/WAK7UgIv33Kqi7U7TXqzNpW3/+NxbbnJYItTvCP/Ub2buHJCX?=
 =?us-ascii?Q?C5O9x2aRqAEL0ioY3NCzUyzXw7Xm23YHFfK6ZDAeJRf0y1ssYmaVXM2OHR39?=
 =?us-ascii?Q?lUvOoTtlA8UlAkNBnr+iR4mV4PorObILo5h6rLUxC/lO78M7bvN4DvvD0zDJ?=
 =?us-ascii?Q?IPYkAzOHuEV8F2GKehiTopPa2LVfo4Gn0JA8uaalenAA1Z0qpvWn5rbgJ7Vg?=
 =?us-ascii?Q?Tote9T1Ootx7ih/DZfVAouVBERYrC6QP/N7llvBb8m+48JhNxsRVUilna7XO?=
 =?us-ascii?Q?hWiJLHYxefZ/wlQ4Ujs2sBdd77EOvF4kRtW1O/MeErXOtAzzI920IdchbTwQ?=
 =?us-ascii?Q?qdAI/iJtxcVQvuQWoaVnI/L05ejKnIK6KqXPUXWsA5SQsmTYhvyZFua197jm?=
 =?us-ascii?Q?5HOqRTYnCabzqgBFnAk8D0iNksRiEYFoY3BweDB0hkvGxmvSm0FTBARo+bUV?=
 =?us-ascii?Q?apHuNlIKmblTPEnWGw3xDGMfPa8RudZH7cNtcswN/7uwrvL/wK2MieX0dfeR?=
 =?us-ascii?Q?oQdmPPSyDVlgn7VzmYDs/2QuqKGronUakMEAw4TVrP2nY5ag7XEqMOPRYpI8?=
 =?us-ascii?Q?pB1k/Mu0H79nAG8O6CYya13RLwIb2tBBq8KzQx9lwdxCILIbY7jahJLtxywj?=
 =?us-ascii?Q?Vh06DfTSwOdpWI52FrWEDrjP7WfvF/MCI8h0W34f7qcCby7ipnm6cQ9GsNuW?=
 =?us-ascii?Q?o8c+ua4eA8QwqSq25xyc7uH1fQ6zTMkagpvSMCL+0QScVRDOdYk7BEzus3h0?=
 =?us-ascii?Q?7MYu+YqBLFDxPlu626wbomB2JG5fi2N2K//OJCMqyV7s4gFoN8sz5hngsEQ7?=
 =?us-ascii?Q?VUTQLsqGB1H78xi4SM4tekgzZ7Ss?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(1800799015)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2024 11:16:50.5582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7049c21a-8631-41e3-d364-08dc809a00c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B078.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9154

Some aspects of the init routine SEV are specific to SEV and not
applicable for SNP guests, so move the SEV-specific bits into
separate class method and retain only the common functionality.

Co-developed-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Pankaj Gupta <pankaj.gupta@amd.com>
---
 target/i386/sev.c | 72 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 21 deletions(-)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index f4f1971202..2a9a77a2d9 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -73,6 +73,7 @@ struct SevCommonStateClass {
     /* public */
     int (*launch_start)(SevCommonState *sev_common);
     void (*launch_finish)(SevCommonState *sev_common);
+    int (*kvm_init)(ConfidentialGuestSupport *cgs, Error **errp);
 };
 
 /**
@@ -890,7 +891,7 @@ out:
     return sev_common->kvm_type;
 }
 
-static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
+static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     SevCommonState *sev_common = SEV_COMMON(cgs);
     char *devname;
@@ -900,12 +901,6 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     struct sev_user_data_status status = {};
     SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(cgs);
 
-    ret = ram_block_discard_disable(true);
-    if (ret) {
-        error_report("%s: cannot disable RAM discard", __func__);
-        return -1;
-    }
-
     sev_common->state = SEV_STATE_UNINIT;
 
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
@@ -919,7 +914,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     if (host_cbitpos != sev_common->cbitpos) {
         error_setg(errp, "%s: cbitpos check failed, host '%d' requested '%d'",
                    __func__, host_cbitpos, sev_common->cbitpos);
-        goto err;
+        return -1;
     }
 
     /*
@@ -932,7 +927,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         error_setg(errp, "%s: reduced_phys_bits check failed,"
                    " it should be in the range of 1 to 63, requested '%d'",
                    __func__, sev_common->reduced_phys_bits);
-        goto err;
+        return -1;
     }
 
     devname = object_property_get_str(OBJECT(sev_common), "sev-device", NULL);
@@ -941,7 +936,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         error_setg(errp, "%s: Failed to open %s '%s'", __func__,
                    devname, strerror(errno));
         g_free(devname);
-        goto err;
+        return -1;
     }
     g_free(devname);
 
@@ -951,7 +946,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         error_setg(errp, "%s: failed to get platform status ret=%d "
                    "fw_error='%d: %s'", __func__, ret, fw_error,
                    fw_error_to_str(fw_error));
-        goto err;
+        return -1;
     }
     sev_common->build_id = status.build;
     sev_common->api_major = status.api_major;
@@ -961,7 +956,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         if (!kvm_kernel_irqchip_allowed()) {
             error_setg(errp, "%s: SEV-ES guests require in-kernel irqchip"
                        "support", __func__);
-            goto err;
+            return -1;
         }
     }
 
@@ -970,7 +965,7 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
             error_setg(errp, "%s: guest policy requires SEV-ES, but "
                          "host SEV-ES support unavailable",
                          __func__);
-            goto err;
+            return -1;
         }
     }
 
@@ -988,25 +983,59 @@ static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     if (ret) {
         error_setg(errp, "%s: failed to initialize ret=%d fw_error=%d '%s'",
                    __func__, ret, fw_error, fw_error_to_str(fw_error));
-        goto err;
+        return -1;
     }
 
     ret = klass->launch_start(sev_common);
     if (ret) {
         error_setg(errp, "%s: failed to create encryption context", __func__);
-        goto err;
+        return -1;
+    }
+
+    if (klass->kvm_init && klass->kvm_init(cgs, errp)) {
+        return -1;
     }
 
-    ram_block_notifier_add(&sev_ram_notifier);
-    qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, sev_common);
 
     cgs->ready = true;
 
     return 0;
-err:
-    ram_block_discard_disable(false);
-    return -1;
+}
+
+static int sev_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
+{
+     int ret;
+
+    /*
+     * SEV/SEV-ES rely on pinned memory to back guest RAM so discarding
+     * isn't actually possible. With SNP, only guest_memfd pages are used
+     * for private guest memory, so discarding of shared memory is still
+     * possible..
+     */
+    ret = ram_block_discard_disable(true);
+    if (ret) {
+        error_setg(errp, "%s: cannot disable RAM discard", __func__);
+        return -1;
+    }
+
+    /*
+     * SEV uses these notifiers to register/pin pages prior to guest use,
+     * but SNP relies on guest_memfd for private pages, which has it's
+     * own internal mechanisms for registering/pinning private memory.
+     */
+    ram_block_notifier_add(&sev_ram_notifier);
+
+    /*
+     * The machine done notify event is used for SEV guests to get the
+     * measurement of the encrypted images. When SEV-SNP is enabled, the
+     * measurement is part of the guest attestation process where it can
+     * be collected without any reliance on the VMM. So skip registering
+     * the notifier for SNP in favor of using guest attestation instead.
+     */
+    qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
+
+    return 0;
 }
 
 int
@@ -1405,7 +1434,7 @@ sev_common_class_init(ObjectClass *oc, void *data)
     ConfidentialGuestSupportClass *klass = CONFIDENTIAL_GUEST_SUPPORT_CLASS(oc);
     X86ConfidentialGuestClass *x86_klass = X86_CONFIDENTIAL_GUEST_CLASS(oc);
 
-    klass->kvm_init = sev_kvm_init;
+    klass->kvm_init = sev_common_kvm_init;
     x86_klass->kvm_type = sev_kvm_type;
 
     object_class_property_add_str(oc, "sev-device",
@@ -1494,6 +1523,7 @@ sev_guest_class_init(ObjectClass *oc, void *data)
 
     klass->launch_start = sev_launch_start;
     klass->launch_finish = sev_launch_finish;
+    klass->kvm_init = sev_kvm_init;
 
     object_class_property_add_str(oc, "dh-cert-file",
                                   sev_guest_get_dh_cert_file,
-- 
2.34.1


