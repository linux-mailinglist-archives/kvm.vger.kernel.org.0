Return-Path: <kvm+bounces-12228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38355880D5C
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 09:44:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 577541C20F71
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 08:44:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E84E38FA5;
	Wed, 20 Mar 2024 08:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DMW+MTms"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE0D38F84
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 08:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710924262; cv=fail; b=hQo2b0UDPvjhA3vKSsKACivTKdxOeuKPfoyX03iQ5nm11cPM6yVhxUDJsSvKyRV1XouB3QlgToQN5BUAedty3t61ouamtNZfSoAMGhahBZKPLFiNZyBYJqdcauXJXWzI/pizZECvMKl6wn3pEbxxZ4MUBeIzA7yK/CVPdPRAAQY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710924262; c=relaxed/simple;
	bh=2YLRqvUunWTeR5+spAsAeWaRnSoKsi0ToHZERijOkGA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a4vvYXKniiEM6trh2jnLJosDxRU7u9gfBJqzKp03gt6jyJi1IO9QHm6lo2d7xm98EnP66YW6A5IAGcv/JnQzr+Aq3/3KHcK+HiCa0lt22uKQqV1hfu8j2pfw8eczWkPg/WMEkZubBMkzGQ7Xa1LYCLiuapod5GX7G5tR5Pkitb8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DMW+MTms; arc=fail smtp.client-ip=40.107.94.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CengPR3DbByT0r33AT8ribI9wVhrOtyyp3i4a3t6xJeRKU0TEcmaT/e2rDk8Iv64Rt7E9GqOyQ6cW964ivTfE9M3yzHNBjMRzbyqDQwtV6rBzRWyDIfdEkZwqvXOoZG35Py/2QjQHUKusNrrv8oRejslCTLj3ipqC7xveasYw48ECDr0Ltj2FDmFrBZHESDWebGRPlQM/FlP90m5K/Ao35BPEufefHwymK6mvt41/vwsaqAKaCHiGrmx6Do0nt/T5AR+bBLVbpBeZPspVtlKtHGKa7DZlgCE37CyizQ2MNU0l+05SI8dNGIAGQ8JKYyUH/mzfKxKfzMUE3ni8woNgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HILu8zKv5gIRtw1eQPy3a+lxRUBPKHDNxM2VhGKvB2s=;
 b=cp/u9IDO38bvo2aThGmUg3vayXnEkw+4mlRFaO1bPlc8bx0j399shAN55q+hQJWRT8MWNbivCmAOQmqLuwQAmv+mnw3vljvdGTJAL8Z6ow2Bv2tYjyUsjsWccb4CR7h9DRydnE+Z9IouMv5aM3io94tmjMgGVG1Ng6Q8q3MG9wup2+zOYhhLbj32sdvP4E5yUfRsuPZe5iwQG0liQfVzbGltOHvMNeqsOdJbgtyAsQ0Zi8Hs/MUg5WvlfJ2NEefMldBdMA3oCgx4AAvYa7BWcqj+HPoyXj3Vceghth7OVX9iluxeU650e7ZK1IHSqag+hzJ6RMBCzR4ntwRCHi6aYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=nongnu.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HILu8zKv5gIRtw1eQPy3a+lxRUBPKHDNxM2VhGKvB2s=;
 b=DMW+MTmsuqqW35N5i7HLoVcRdOpaCUiG2mEStvEsGF7ONtP4UkaJGVYUpTbAVHcSsGTz8+U2qzK1dcArhFSwpcior0+0MMolKMglhqkN31jTGGqb07f2neNA1jWnn8k/8eILZQUy+R6Q7k4tXL3iVVqo4ZDfAMQqTdBZjL7e1g4=
Received: from MW4PR03CA0293.namprd03.prod.outlook.com (2603:10b6:303:b5::28)
 by IA1PR12MB6652.namprd12.prod.outlook.com (2603:10b6:208:38a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.30; Wed, 20 Mar
 2024 08:44:18 +0000
Received: from MWH0EPF000A672F.namprd04.prod.outlook.com
 (2603:10b6:303:b5:cafe::d7) by MW4PR03CA0293.outlook.office365.com
 (2603:10b6:303:b5::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27 via Frontend
 Transport; Wed, 20 Mar 2024 08:44:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A672F.mail.protection.outlook.com (10.167.249.21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Wed, 20 Mar 2024 08:44:17 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 20 Mar
 2024 03:44:16 -0500
From: Michael Roth <michael.roth@amd.com>
To: <qemu-devel@nongnu.org>
CC: <kvm@vger.kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?=
	<berrange@redhat.com>, Markus Armbruster <armbru@redhat.com>, Pankaj Gupta
	<pankaj.gupta@amd.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata
	<isaku.yamahata@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v3 17/49] pci-host/q35: Move PAM initialization above SMRAM initialization
Date: Wed, 20 Mar 2024 03:39:13 -0500
Message-ID: <20240320083945.991426-18-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: MWH0EPF000A672F:EE_|IA1PR12MB6652:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d020731-a33f-4ebe-839d-08dc48b9edd4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	0mulvIQFUeiAC5TB9TJ6UmuVGUBqGZFYpELY6CY5kiW/tkw6VHqqTEEPzZQE+2U1KN+n/+K6/7zT11XNpTdVxokk0gBOyva+OH0VhHGszRVAoWaFUpVCBTUJx5cPuaenZui8qV2pSVrIJL/c0phRH62K9wn45UIXkyLDp2v5W/nAvCZbstFSgGfEstCUk7YgL06hX/MztzQsDHzbA9lT8tAhe+EiM0YfXRMhP/S0UZltgNgNqKnR21aaxSDGfowmgBeh83QyF4pUP1ChEHjHee8hnaxZbaDLHf4Jwxf4MfXVARAdHAqU3cg9jTB/nxy3nhiuXBEE5HuVbJpvtotQGKEmgLs1pc3lcdkEpIA+9RVNKqENyZfZbMFFU2g45Cr76SPEGFZuMx8tcPObwwgtUNCqkFVycZolIu20Qw0eUk1Lda4S8zQTq1IajYvNKvZ1dzCI5uatwvPjLY7g/nYhTD1BIaeRDwuf0D9aTRH8sPJ3fMI4g30rtQRyUGbUpBhJtHZwyf9h8WgPjD68ZwDGNwh+6lxJZB7ZyGEQGJZI3XT2SviO6RE76gq7P5585NuyBxLFRA+fqG29HTWoVm576BIqb42Xs6fwIIjNGxyBUxGQRLEJz3xOhm8DfAjielvc2H30jRr03arAOCXc0RQHM/pDr+ZG/cT+Tq1vCJA1sM1aGnB0U2Fm2rXY1emh5aw6IxRJnHzZS8AqTnMCE8TVzZh/tpPSbc1URaQQWUaOylZebDsPnBWdgXExtM/qCyNV
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(82310400014)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2024 08:44:17.4482
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d020731-a33f-4ebe-839d-08dc48b9edd4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A672F.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6652

From: Isaku Yamahata <isaku.yamahata@intel.com>

In mch_realize(), process PAM initialization before SMRAM initialization so
that later patch can skill all the SMRAM related with a single check.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 hw/pci-host/q35.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/hw/pci-host/q35.c b/hw/pci-host/q35.c
index 0d7d4e3f08..98d4a7c253 100644
--- a/hw/pci-host/q35.c
+++ b/hw/pci-host/q35.c
@@ -568,6 +568,16 @@ static void mch_realize(PCIDevice *d, Error **errp)
     /* setup pci memory mapping */
     pc_pci_as_mapping_init(mch->system_memory, mch->pci_address_space);
 
+    /* PAM */
+    init_pam(&mch->pam_regions[0], OBJECT(mch), mch->ram_memory,
+             mch->system_memory, mch->pci_address_space,
+             PAM_BIOS_BASE, PAM_BIOS_SIZE);
+    for (i = 0; i < ARRAY_SIZE(mch->pam_regions) - 1; ++i) {
+        init_pam(&mch->pam_regions[i + 1], OBJECT(mch), mch->ram_memory,
+                 mch->system_memory, mch->pci_address_space,
+                 PAM_EXPAN_BASE + i * PAM_EXPAN_SIZE, PAM_EXPAN_SIZE);
+    }
+
     /* if *disabled* show SMRAM to all CPUs */
     memory_region_init_alias(&mch->smram_region, OBJECT(mch), "smram-region",
                              mch->pci_address_space, MCH_HOST_BRIDGE_SMRAM_C_BASE,
@@ -634,15 +644,6 @@ static void mch_realize(PCIDevice *d, Error **errp)
 
     object_property_add_const_link(qdev_get_machine(), "smram",
                                    OBJECT(&mch->smram));
-
-    init_pam(&mch->pam_regions[0], OBJECT(mch), mch->ram_memory,
-             mch->system_memory, mch->pci_address_space,
-             PAM_BIOS_BASE, PAM_BIOS_SIZE);
-    for (i = 0; i < ARRAY_SIZE(mch->pam_regions) - 1; ++i) {
-        init_pam(&mch->pam_regions[i + 1], OBJECT(mch), mch->ram_memory,
-                 mch->system_memory, mch->pci_address_space,
-                 PAM_EXPAN_BASE + i * PAM_EXPAN_SIZE, PAM_EXPAN_SIZE);
-    }
 }
 
 uint64_t mch_mcfg_base(void)
-- 
2.25.1


