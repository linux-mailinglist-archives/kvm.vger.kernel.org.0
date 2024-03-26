Return-Path: <kvm+bounces-12712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A316488CB0C
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 18:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DF19DB29BE3
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 17:35:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896A9208B4;
	Tue, 26 Mar 2024 17:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="DXO4Z20K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282651F94D
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 17:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711474481; cv=fail; b=vBkyAVUkR8Qf6r8GKSavB8v8R/VErbaJxEDsP2cCj1TwVqxf9oc5B7f4UXEJbqHvgpQBOzdq2UQfu605wOEzgzPJCFwlU2muCpoTfbZtwj5I48tGvrM+FyFYZ4ZKOglW0efvgPwHgOrl6+3PLBfY2Z6WShsyxeB1QQpjJd53QXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711474481; c=relaxed/simple;
	bh=foaezEub8w3w4KRjUpDjY3MwvtuJonm19FbkVaFMylk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JrRA5nNXrRS/Vt77mzTXSwgTBJgxbDaYuFAdaaNz7c/1KqyVvej0rwNJGcDS5ucn7TXndRYzXSXLnb8rb7F0FA2uYB3bPCFphTZe/PyvYtbOT9IibMvEWryi6by3FQ1Hj4aJD1zY68J5uhginiv15ZEJMrXHcrIp+3lAwyQlTAs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=DXO4Z20K; arc=fail smtp.client-ip=40.107.243.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zdc0aYakoX5kTQ0OYzr2DzzNuhKv3vu+2I02J4fyDnR8EUIgMODXuyPx2YhFWOIBrvEXg27hQGjRvYl9HdRXHmtfX8dBih20DvjmmqroTjUgv7myJDrF9cCcPKHXkrvS2Lg8ySJpPjJwDXuPbj60c3C/H8JjqQnfSuMIHfaH2hyL4IIa72au/2G20HLlPgQOCTZU1y7zpQ+8rtqErNiv9zGUKzWApO9o9nTECnXwSmzo9Q5R736XBB7RUWr/OuFR3rPCixOtNEtPNjQR3N8x8QrDckCUxeI1UHgf6/aagRgiIiJ8+0Nk59eLVMBGX9oJcTYsbpXrW0VbvryzjksSAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OnlPEo1cI5ksYjx05NMY6ADOjb6SbbZErbEm1jgDg98=;
 b=MTujc3LuET41mJ1V02JvtO1CJynqJ7ajU3MqorXm9+xin/rNF6znkCfYQlwDAoClqxvAFYkRXj6vUSJXbSIeXBM0gG2riH4N6hEypPYoMvvKGrd80Xix9uYl3vor3xgKSX3p5thseM7juxsCKYQrIM9yKcqwpiR4FdNLXGMvtRsQwcwE6EXD9Whuk48O4w1tnzx+wIkpSPilWQI+g0ZvYM53AiaSv/n+pNOBzQo0SK+Vw1VYO/udeU+nakk0CvxVd6nWAklmzITPCUUCgigwja1Osofo7F+8CG3OV5OW3LFW2zxQ2DqcpV+uT5CqDZ69okIbCZwO+Bh93E1TR9laAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnlPEo1cI5ksYjx05NMY6ADOjb6SbbZErbEm1jgDg98=;
 b=DXO4Z20KA0aeKZnD2s9XGYZxtfymd6fwTQfiskaev04EHUKZtuXz/9GN9i4EcrdQOKTntrp845/5drLz0Me81Pa49FPdh6+zwpNElTz1dsWNnP3n+2Ux1nJ6o7hdWDce8/g9rMteMsrhB1AnZEJI5wuH6vbFR8s5XRIHbuUfR0E=
Received: from PH8PR22CA0021.namprd22.prod.outlook.com (2603:10b6:510:2d1::7)
 by MW4PR12MB7192.namprd12.prod.outlook.com (2603:10b6:303:22a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Tue, 26 Mar
 2024 17:34:36 +0000
Received: from CY4PEPF0000E9D8.namprd05.prod.outlook.com
 (2603:10b6:510:2d1:cafe::d1) by PH8PR22CA0021.outlook.office365.com
 (2603:10b6:510:2d1::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Tue, 26 Mar 2024 17:34:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9D8.mail.protection.outlook.com (10.167.241.83) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 26 Mar 2024 17:34:36 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 26 Mar
 2024 12:34:35 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: <andrew.jones@linux.dev>, <thomas.lendacky@amd.com>,
	<michael.roth@amd.com>, <papaluri@amd.com>, <amit.shah@amd.com>
Subject: [kvm-unit-tests PATCH v2 3/4] x86 AMD SEV-ES: Set GHCB page attributes for a new page table
Date: Tue, 26 Mar 2024 12:33:59 -0500
Message-ID: <20240326173400.773733-3-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240326173400.773733-1-papaluri@amd.com>
References: <20240326173400.773733-1-papaluri@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9D8:EE_|MW4PR12MB7192:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bed8a46-eaa5-4449-bab2-08dc4dbb01ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	ybVkYR0SrAQ4SwO6gX1L6WjUoienGIIRJJB8M0lQnxOxGZFKVX2140NSo/Z+SEkFLkOHI0nKYbvf0ghOk0gyWn7btpBQzYqVHYn84AiVhYJjtt1JgSNkleLcscADHCmJ/rml6JW6GIoY220eOccMcMA5YvxRdLLFhPyMaxziQPONxxDiV8pl8B6SnoC1WRtC0gNsgofXDk2IlsFvMfv6XasJtPknyvdU7qoWPuMrUGAy7gWV5lMwsow37R9RXOdMoS+PvzULFPdcP6URVddXErfa1eav0xFU9eiRpzZdnG2E5tQ8iknFfh7IGgvNbDb/eoHOzaVQ3s8o2vuEiXhkFEIPSROpTi2So1MKWLLywrp5vTefhO3OzIfloYEsoGbqrzCsuaSNSPBUk3H7ifP/I0oGcN1aIWkrMNn7pqYTnQSvIV+5JCfmbTXdq77wuGaqGsxNRrSy0vrEnVoF4v2uCTjKgPkpeyBv5+SNbSCU2fqhTjEPZA2d3gk7xMpKGnRfsRgwZERcKcAiCWbKx2UfoHFWWqcxJvfKQsr/DUvDFesf1VSnGZ9bff1s/ujAuyHqe8d5kMTYBoVP/JXhyMRyOzp5VUaWTKqB3ZtepPWRk2E/HKw0hkTRFURyi/r60iVebxpcuVZSTk215lwkLQ1DDfZ3WpeehFMNPSKBIIq+/GV7bGkYdBBAZXmWF/QwOP5B1DlJWoCQvXdWfHJLS0ptYFhqw2Af21Sh6vGFmSWwmw4EC3IGTD96k2QTtbCt1F7W
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 17:34:36.3222
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bed8a46-eaa5-4449-bab2-08dc4dbb01ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9D8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7192

SEV-ES/SNP guest uses GHCB page to communicate with the host. Such a
page should remain unencrypted (its c-bit should be unset). Therefore,
call setup_ghcb_pte() in the path of setup_vm() to make sure c-bit of
GHCB's pte is unset, for a new page table that will be setup as a part
of page allocation for SEV-ES/SNP tests later on.

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


