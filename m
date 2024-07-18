Return-Path: <kvm+bounces-21838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A56A3934D75
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 14:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C90B01C21998
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 12:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A66213C699;
	Thu, 18 Jul 2024 12:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vQYgHcg/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F8054645
	for <kvm@vger.kernel.org>; Thu, 18 Jul 2024 12:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721307077; cv=fail; b=j28EjilbbIpalqFjYNpphtmqpwNtlqE1IgtHmYya3FfLAynBxT+ErrX7W6TiCj9x4SSJDd2CoxRp93H4R2v+/lz5mg7e8hw9hGLhFxXpPM2+MW3rNqXmiAWgBL8BHZrUSNTps+rOm9BXC87nDhqzkM1oagrB2Mj7FtZH5tFkFFw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721307077; c=relaxed/simple;
	bh=ULyTX36OSyP58/7GQaDYbNNIktcZmRrd4nxFyZ9Xh5A=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qB/AT6VLizAKso8r7nTFRQFXXr3d39cBgQk0nYNo4dErdbZilIO7D402HA/KJKPPeMAkJ3eiGke72uA8U0lcD3jOG+5AORwYHZ0/OYHQ8+lDooKsVcKqxKk7/R/Mu825J70qj9xi/iLrMRmKvnoOsNw5+MHPJalQo2tGo9vBVfg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vQYgHcg/; arc=fail smtp.client-ip=40.107.92.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qjvHgnKou/9FeIZIzWE3VptkNTYenvCCNRaOcbukIcE4Ltbm0YdCYFccoiXMNr0HS1ii1pFzTlYib9kBkM05MqgLvYNqVBy7Y9/5H1O/YogIzaaouARul4c2TltYOAe9v+ipX62L8H7plxo+dxxsDp4wpGUjt4r0Ujm03lt87JmKU10+/ooJh46gKP3gE4Jm2O6kmBdo8/sDPDYfl9kwzWjuM+JMcyL6p47FhN285ZH9/q1O5K/pPWB7T3xm6VHxwG5bgG9OzpsUboL+0Y3I2RT59XvRiQjOA+PCc67WXmPbW/LPFxVPchwvilnU23dehZwcVEoHlXqbZuGHej09mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5xboMsfu4N+Dk+tDQNQ/aFht+bh1mL+dzYMIiLRF/Z0=;
 b=YBE9DWpGPgAIbTbmXZh12N6EnSemyUSB/Oywi6Ir95GSX6ptssklZJSvwY/qmalccc+JWJs818Qk05xEfn2VWPLZ57nPJrJCzDZGi2SWcbwB0I7xra9G+PrWaYnAYdxS+8v+f4/gtE1It+dgjX8OUfYgkw/cJO1qIi6C3bKzVHTGMSOG8zmsLM0WagG/xfwoIOSwCecksoQKmX66GNCvAaqgcV7pZCpyStBJmlRdy0/uflvNeLTsWyLTM7kMEUI/Hfz/HB0SDsujKdunnJFygzQ3ngK5Jv9JcRKsbV413vNdz+pGLirXCso+hwofvmQwYOp2ld3WPHD7bmFMqefUrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5xboMsfu4N+Dk+tDQNQ/aFht+bh1mL+dzYMIiLRF/Z0=;
 b=vQYgHcg/KPjkB8RNtl/aOXoTB7FfqjVOkqNgBAwMfm57i4rHgUucTcoTSifnK+eBbZbDc5cEG8t56y3yNUSGnIIBCFQIdpgnvYnqMcQijyr15utmP0Pp/JtfMRtJ6bzMytzyU+AkI1t3QrhyrZJHIwGD09bA6aigIZb9K6pu8B0=
Received: from CH2PR17CA0012.namprd17.prod.outlook.com (2603:10b6:610:53::22)
 by SA1PR12MB7175.namprd12.prod.outlook.com (2603:10b6:806:2b2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Thu, 18 Jul
 2024 12:51:11 +0000
Received: from CH3PEPF00000012.namprd21.prod.outlook.com
 (2603:10b6:610:53:cafe::70) by CH2PR17CA0012.outlook.office365.com
 (2603:10b6:610:53::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29 via Frontend
 Transport; Thu, 18 Jul 2024 12:51:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000012.mail.protection.outlook.com (10.167.244.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.5 via Frontend Transport; Thu, 18 Jul 2024 12:51:11 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 18 Jul
 2024 07:51:10 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests PATCH v2 07/16] x86 AMD SEV-ES: Set GHCB page attributes for a new page table
Date: Thu, 18 Jul 2024 07:49:23 -0500
Message-ID: <20240718124932.114121-8-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718124932.114121-1-papaluri@amd.com>
References: <20240718124932.114121-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH3PEPF00000012:EE_|SA1PR12MB7175:EE_
X-MS-Office365-Filtering-Correlation-Id: b389d7b8-7643-457d-bb27-08dca7284d49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nfixZth7CaiLbu4D0lEoWW0kNEa1zm+dOhoWhcdvg4TjOiir7ZONDrYApXAF?=
 =?us-ascii?Q?JfTqLHj2c/JUzsfdtMoD8t1hY/DeNafkGg9dFZ6QjKfV76GzM/3x0Tsf9cwc?=
 =?us-ascii?Q?d2p6qQa7vwx1PZ9mYIRuQmDBfLt8m/nuAKBxpLA8mBbFHGyIC9OyJ0zbeTdk?=
 =?us-ascii?Q?NyT+b9JptkLrxvIeuwngVsFtxMh4uk//gaXBJHwloTcZO1qiXBDVlLfGawkH?=
 =?us-ascii?Q?c2PqZIfNQwp00zuZuFV9f4GJ3dSxKvBUCSbHi4YJurumScwxnSJsiweqacVz?=
 =?us-ascii?Q?tWQFL03jLZK5BxLqn9JGpW3V5xrQCc3RZtNp7GIVNKCV8js9Unjl1DW0i4cs?=
 =?us-ascii?Q?yxcZGG1LS80ltsDAxvEm8uRNTl9TsFr5daZUKJqjr+ZvgR2n62HI712gRDFU?=
 =?us-ascii?Q?L15gtcxEKnowheyTNMKJozxVR5zbM43IN4KIUEkkfnjOt4ZWM5B/IRZ31nkO?=
 =?us-ascii?Q?YOz/r3Ja2UUD9MNwCKUshhqDS1/MC4BPI5FQ24lElAS5md+BCCjeNMab2RxR?=
 =?us-ascii?Q?9GO2Zt5+pHHqYeMCnP1tbuMGFZ4QZ8S9SZc0IEkb2YXl8wNnpLq4APFpkoiw?=
 =?us-ascii?Q?+6o/oYZMFo2lNmDzZbkifuLRrOuCnK2o87/CzcoavhXYJV1cbobHo8JaU/LI?=
 =?us-ascii?Q?hMzENGUyikz7V8eyRvuO4tpIUJbbcfThz+6hHaOLOlK9FwD0NZtPKsKKMTWd?=
 =?us-ascii?Q?D/wRqUiHu0i+6wVwBfOVxnV9wa+MNbn/I6xqKnNq8/w3tkIH5Ku3HO1kPDbb?=
 =?us-ascii?Q?fkPluWXHU3AkRs2Au0PrrI1m57CbPEhmz2G4YS50snYaVpmElcyOfvW9a0Ih?=
 =?us-ascii?Q?ojmMIx8OFiBxjjajmdoUrXMYXmKcSmGH9dtCCnviiwTy+2HRHGoEAQfMeuZh?=
 =?us-ascii?Q?DDHc+5P9vm+MgxfNbvklH9fGFpjLtnGtuJJnLAGp2YW/zKwOl9GvmsJm/ppR?=
 =?us-ascii?Q?nBP5sqs4haihWeNlAr+jGE80s8vv87omcgI5U6EfjxgcqamJZiPBA/e9rsMW?=
 =?us-ascii?Q?BJAoQCLOo4qqXpH3lZmw2vgMdaW5ihzWTGG6zpWEEcnx9T8RkdszByo19924?=
 =?us-ascii?Q?X+sUpm5cTNXzsiw3M7PnPKCSdbXzzbmmoLGwOZEz27AjaUruoQtA1K8PJKVr?=
 =?us-ascii?Q?vdEz6rWwuW7UfJp+ZT8NaDMD0Bv2sETNIIHHpWdQOxc8OZIdhCTwtpU6xhC3?=
 =?us-ascii?Q?URqF/RDuyUMvWwDq/zqwchEPLE++EgG4VW4invJWtca+v4uEfrKrgaxxQ4iM?=
 =?us-ascii?Q?yZog4yDbX26p4dLteMi6ywxR+j36iaOTGNbucVSxbFSpnbeKKGjTKprqIOAD?=
 =?us-ascii?Q?SAznmPBEPLsBCaFvAPfudEB87is2W9nyD/a4jCaH8aDYpCt/VKFnC/oI7yDl?=
 =?us-ascii?Q?/1Z0RjeawzzTuOBZpqE069/+9NW24xzgdHyKXrGGbxG6DPuuuaVGHDe5BVMM?=
 =?us-ascii?Q?5L1PMPcInDLnW20ojXUVcj3QfxtgqRox?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2024 12:51:11.6194
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b389d7b8-7643-457d-bb27-08dca7284d49
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000012.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7175

SEV-ES/SNP guest uses GHCB page to communicate with the host. Such a
page should remain unencrypted (its C-bit should be unset in the guest page
table). Therefore, call setup_ghcb_pte() in the path of setup_vm() to ensure
C-bit of GHCB's pte is unset for a new page table that will be setup as
a part of page allocation for UEFI-based SEV-ES/SNP tests later on.

It is important to note that setup_ghcb_pte() is also called from
setup_page_table() in lib/x86/setup.c. However, page allocation callers
return a null address (0x0) for UEFI based tests with the initial page
table setup via this path. Hence, a new page table is setup via
setup_vm() to allocate valid pages.

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 lib/x86/vm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index 90f73fbb2dfd..ce2063aee75d 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -3,6 +3,7 @@
 #include "vmalloc.h"
 #include "alloc_page.h"
 #include "smp.h"
+#include "amd_sev.h"
 
 static pteval_t pte_opt_mask;
 
@@ -197,6 +198,11 @@ void *setup_mmu(phys_addr_t end_of_memory, void *opt_mask)
     init_alloc_vpage((void*)(3ul << 30));
 #endif
 
+#ifdef CONFIG_EFI
+	if (amd_sev_es_enabled())
+		setup_ghcb_pte(cr3);
+#endif
+
     write_cr3(virt_to_phys(cr3));
 #ifndef __x86_64__
     write_cr4(X86_CR4_PSE);
-- 
2.34.1


