Return-Path: <kvm+bounces-12227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE16C880D5B
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:44:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 27CC61F23DE1
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:44:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5521E38DE9;
	Wed, 20 Mar 2024 08:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tFPWASVd"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F88938DC0
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.70
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924242; cv=fail; b=eUKPMu9r7o5p9IAT+6sFzj5NzFYhhb62455BGL5RB7ynpyO+kcvA2oJ6s8s+ToLb6f2yI/nZiNr+cyOd/o8NdyABYxLJ567RYPNVBz80EjR/zjcxROJgEJWltKV3MVgu3MGT1/p6PgRMgiqt9axTKTB3YL/T5Ngte5ux+5bhp/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924242; c=relaxed/simple;
	bh=HswgvmCLAMIxave67B1PL5ZnO/+xvJf8lMmQ0cff+BY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nrNbRgJxZWcu8430MidjOt2FjA8bpXXOMK916dwtPCHCcBoux5xGJG5e/CKempISe3mdVYH/xvvCiVZXDsNxbVpVAUYpwoJQ7zpJ1snLBRZysar0FQ2TtbsdUECFrHiWgMjn5HmVRpntmhFKS1RoC7MSYpSHz4FRWljIPICTBEY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tFPWASVd; arc=fail smtp.client-ip=40.107.243.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rz8v6XJsQk9kW9CVHcCuPQIQp2E0h5nk59CI8mmUgbGXr7yoiAlSepc+Dpg7wk6/H0bQW7xlldCGXtLQjaKK3k1vUJ5IDVlkPZq3WHu2uFmv0eN5LWAUGUt6qA31u1XZvHdAB6Ulxs89+Gd4MLnJ+gxvHP188k0YxmNq72HEcZP04bKj6gUNeg6jnhrSqLWT3oFhG9dLslyXtmO+C4pRjdpx960KC5LJXRX7D8CnJEM2I5jX/UQBAMwC3OvI4QOkRh4oC1AJjPUOS/pyjzoBPscBJvKv9O9prmQSL/+la5PnqAceBTvk8qK+3qstYwCTRzfvz48bOr2vPsAyw8PC4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSrmrJQbHUAMRL8clL1jsbrz1sxVZn/0yeZ/G0uTirA=;
 b=SOHMYBuG5LtqFK+aFTSMLO44QIxWQtLGnZTaWI/fjNmn+XPieuR0sTX3jEH2FqDW1sLnQl4JTTvUspPqFNpyQx4xeMB5dzFq8syyJuX3FNsUQ9U9KoLyiGBeGDcooHzSm0lgok9o7/VjvDNwePfPG8Zx2LHi4eV4/mGBqg1QTLFIpfUhfR0hxXpfQPCNx3Ef3l38/7DKB0NKT81VKzz41FHuBaXuyYJtR6/jgM/A2DtCsFNhA4gf+V20XsnwNV7eYWRFtQXoQpeg1ExUwLBBhIGYgIqwjtC31x2VSOV0Ie6No563fG/fhUh69EfCHdbVbQh2FjtqMa7rzRr0P9CIng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSrmrJQbHUAMRL8clL1jsbrz1sxVZn/0yeZ/G0uTirA=;
 b=tFPWASVdcMGSrZGZrq0wzeP1lZA/oDqGdnQn5ysKry2u+XpD02xghojbA7D3w6X9DxkLl7pQd0lkR2NpiI1oWnyFt2QCXS59dolXIHduMO6G77RCrdy3Yuhi/3JDsJrcuPjhRMsbgGlX1/4vsbeTILAayZFUwBpjPf2mO00XYl8=
Received: from PR0P264CA0093.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::33)
 by CY5PR12MB6345.namprd12.prod.outlook.com (2603:10b6:930:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Wed, 20 Mar
 2024 08:43:58 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10a6:100:18:cafe::4e) by PR0P264CA0093.outlook.office365.com
 (2603:10a6:100:18::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.29 via Frontend
 Transport; Wed, 20 Mar 2024 08:43:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:43:57 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:43:55 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>
Subject: [PATCH v3 16/49] memory: Introduce memory_region_init_ram_guest_memfd()
Date: Wed, 20 Mar 2024 03:39:12 -0500
Message-ID: <20240320083945.991426-17-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|CY5PR12MB6345:EE_
X-MS-Office365-Filtering-Correlation-Id: 70e605d4-8ac9-46e9-7353-08dc48b9e19e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	f/W8UtLvqFlkTugE9YUplWeyQBakIaTLYh56iS68VPf9BUgWng9wFwnSLAizsESXGLHZiwIzJUaaFBzRGJDtSlXsFhF3oWL4n0iriXev544Jmnx3l2Is7z30+KorCBTVb53LkyG1jkVNkk/3xoGf0wDTYdKuyu21ofQ00DjN2ChSXMqoxphPWd284qRJqpy/G+3vns1kBbL2arN3p45C4LbCp/WUAAR2wwF0UeB6QAclwPUpFEzqiI1JZV5J4fFO8gZeB5bBHQRpLOqyI/wvoBD0GNuJrXn0sbBdnVh1o+s7lcV0ZurbGqWuFCFaSTPG0VIKAVtbJB3ko1lqiHpbpLbgD8Brz3eYHYOBVcwfkqhQMV5XY4U8irKNMPWS9TXBOosj8M6isGtDKX/7HjneEpx/znFCXhQ2O9T6gBAV72IAGNxUiSSxSb/FDNbwj4e6UsSkAGf9HOJVwtRhLq8mzgLiWVGm1dEnL2LKZckEki25QwGIR3uODn+g8+sXUZ+nOnMe7W5py3Phw0d98wlQk6AnHOM4aQamjQNHYEElu8KW0lU3ZDXFm1i1Yvqps5wezpZCHZJ+OTEKRndteCw2mr7LP0IP683fkF+JfRpVpWq2La+lxINd1zsMYCiM+/YlfpNIveSxuaRiribFA+bEbpLCtpi8Kre/z+0b1cFuR2jqKkIs4UTcUpsedBTgYMjn0AhndokzKwaE5csKxM6b5AQrs3gqNnF+js0QWPmVANWJtAeCx8clXJVCFNEtbIJh
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(376005)(82310400014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:43:57.0706
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70e605d4-8ac9-46e9-7353-08dc48b9e19e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6345

From: Xiaoyao Li <xiaoyao.li@intel.com>

Introduce memory_region_init_ram_guest_memfd() to allocate private
guset memfd on the MemoryRegion initialization. It's for the use case of
TDVF, which must be private on TDX case.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v5:
- drop memory_region_set_default_private() because this function is
  dropped in this v5 series;

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 include/exec/memory.h |  6 ++++++
 system/memory.c       | 25 +++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 679a847685..1e351f6fc8 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1603,6 +1603,12 @@ bool memory_region_init_ram(MemoryRegion *mr,
                             uint64_t size,
                             Error **errp);
 
+bool memory_region_init_ram_guest_memfd(MemoryRegion *mr,
+                                        Object *owner,
+                                        const char *name,
+                                        uint64_t size,
+                                        Error **errp);
+
 /**
  * memory_region_init_rom: Initialize a ROM memory region.
  *
diff --git a/system/memory.c b/system/memory.c
index c756950c0c..85a22408e9 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -3606,6 +3606,31 @@ bool memory_region_init_ram(MemoryRegion *mr,
     return true;
 }
 
+bool memory_region_init_ram_guest_memfd(MemoryRegion *mr,
+                                        Object *owner,
+                                        const char *name,
+                                        uint64_t size,
+                                        Error **errp)
+{
+    DeviceState *owner_dev;
+
+    if (!memory_region_init_ram_flags_nomigrate(mr, owner, name, size,
+                                                RAM_GUEST_MEMFD, errp)) {
+        return false;
+    }
+
+    /* This will assert if owner is neither NULL nor a DeviceState.
+     * We only want the owner here for the purposes of defining a
+     * unique name for migration. TODO: Ideally we should implement
+     * a naming scheme for Objects which are not DeviceStates, in
+     * which case we can relax this restriction.
+     */
+    owner_dev = DEVICE(owner);
+    vmstate_register_ram(mr, owner_dev);
+
+    return true;
+}
+
 bool memory_region_init_rom(MemoryRegion *mr,
                             Object *owner,
                             const char *name,
-- 
2.25.1


