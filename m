Return-Path: <kvm+bounces-32905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A4FE49E18CC
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 11:06:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C8FEFB3450E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11E691D47BC;
	Tue,  3 Dec 2024 09:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="G4kX5rgy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A822D1E0B7F;
	Tue,  3 Dec 2024 09:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216501; cv=fail; b=AjlUfTNtqoM5b0Ywey4FE5SDr5kVqqw0sr3apYEUxvA2P6CEtWZSka+L+uSq9Whp0ZrqrT7ZdC05fWpP4rct529r4GCWSXxLcW3i38y1JsXQnpVg3LOw6FKxam2lN6/O9xVo0Rzy0P1d/X/gTkGF1cVf/zpQvDSGKZG8/aJACdE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216501; c=relaxed/simple;
	bh=f6vubs2pvTm3eVh/13qnd4PIdAdCj7J+u1+haCnCZe8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDe20Ap9sOgszNBEAxfTf50NXU/JApNcvZSuPQMsjyWTWoIbB+AixA2L9lFq3HhqHHXoCxhC+H6wuqpiHNvEoytvtaKkm7fmg2zwgAk0kOQGRmzJUmErZa7LKU3JagruXpjXA0wm+Fq4P2rE+8iog7t3TpHA+CBdOS8GFs0O1oI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=G4kX5rgy; arc=fail smtp.client-ip=40.107.237.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z6zDC6uguGTIBPPp/jzyZsJL2C9HFQ7oOLrT2FyGwzgVJmBPg0yJn4dIk28k0gsoF883aH3egjDwWilvM9GnnVsU7nPC4CLvZ04k2NqgQxf03Btr6MPus2gA3bEkDvum2yRhc9fmB3HR5yQT5QX8aEXRfHeJCiQQgmFPCwJ8nqSfxGXOrU7eL4OQFS7MrJ9kV1Jl0t7Id83vi/HkZL4UEBHKBfTAGJ+GZU4jnhmjS5TtRvv5gZ1LOpGCyAo6DViY9Y3suC2lBQnWbSB10KWPRerzaTb4NGvQgBuvSJ1htgDWy0gb5+SfensPzaAJ+oLtKwhQ88LI13jwGQs1tS0mdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QqfnoyTzYJGKUa3O0n3sbxeLFTWLytTIonx8E3wq6Yo=;
 b=rFKuriVOajD9aWAhh751l8yu+nk+N0iiDBOLvTgLxyT+ZZEjQ22uiRZgZ6UMhkklDPHhL145JaLcj5G8h1ZYQJcuRNlk/JjwSiGz1ZF2FSoJ8sENR8v03yiKHlq19se+zOdnwJ9Kj7S+efrCMkK/Fde8eV3w8jH0d8lcHYGa6elMkjaAVgnE0KbLYUk5dSSuVvufe4OqGSIXp2UBFVuuU4BEEGuy98Ub1aShjvmIi0Glj7kKUQbKqw2ES4flb7p75WkWhdEKHI7X/SosAywHZbTbuY6JHdIqCZWt6H5PBxqYsYDPTKEXQVUQFD3aHtRp4BwfzrK97sCOWn/lItETfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QqfnoyTzYJGKUa3O0n3sbxeLFTWLytTIonx8E3wq6Yo=;
 b=G4kX5rgyJiYaokBLh8X4zjs/3LZ+w/JgFFcbMQuuYIOoXk7ZISS/yMfzXo6KPw1jaYBjRZgUX29v7Xqx9rQWsqhBXHq0gHj3JUwNXH0iIO16Z6tdrx6kcgj9QHx+1BRWQvms5+IBzizsItLslV9j+GnJePE+ovQBwcg6GbHh6RE=
Received: from CH0PR03CA0120.namprd03.prod.outlook.com (2603:10b6:610:cd::35)
 by PH8PR12MB6940.namprd12.prod.outlook.com (2603:10b6:510:1bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Tue, 3 Dec
 2024 09:01:34 +0000
Received: from CH1PEPF0000A347.namprd04.prod.outlook.com
 (2603:10b6:610:cd:cafe::70) by CH0PR03CA0120.outlook.office365.com
 (2603:10b6:610:cd::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.19 via Frontend Transport; Tue,
 3 Dec 2024 09:01:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A347.mail.protection.outlook.com (10.167.244.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:33 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:30 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 07/13] x86/sev: Mark Secure TSC as reliable clocksource
Date: Tue, 3 Dec 2024 14:30:39 +0530
Message-ID: <20241203090045.942078-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A347:EE_|PH8PR12MB6940:EE_
X-MS-Office365-Filtering-Correlation-Id: 86ba68f0-7b72-4e7f-2563-08dd13791624
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|7416014|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0etoc8hubzlFNREKmHjZxmugrindgNLUt9l6XNhPhCoVXxTRspBQ+Cbph64x?=
 =?us-ascii?Q?GAYzkHy38tBz76TtXzsJn4Z6GYTC3/QGrSMJ7FwP2EGOxqg75IgPYPnVP9O1?=
 =?us-ascii?Q?REuu06AkOy8qQcMtT2SV5MMEpwmt5rioGYnGhZHopEAzDQXRdmlNF/2HSkny?=
 =?us-ascii?Q?TT+9aOHwULDzj0nQBigo60cSMAhpVJvqKUnx/Bk5qIsPFsHg5O8oN7s9YfvF?=
 =?us-ascii?Q?7TXula7uQMkwWlYtwjysZvkJ8VGrvjEbUcv0pVSgEmrt8RPil0Qdn1Ddsab6?=
 =?us-ascii?Q?ucYXTS5H4wl9/9R9uhFNUWcF1GpMQqNr5JzGvP78xGLpjsfVzNKkfl6Vrh4L?=
 =?us-ascii?Q?rUehbjZjXM7kHmW8mbwNXfExroT6qAtqCcGsBpnq6FCtJP2UY963I+X4DrNE?=
 =?us-ascii?Q?ohvmmRlskcCFgMDxzbv4FuDpTkWt18n291HWgUMPt6QRbx23T/DxbWplmrWR?=
 =?us-ascii?Q?3tp4y9SXLJP7DfrmA/lB88RbKg6AYSIQgJHMDcdzdMeB5C8MfQ1FutQ8jWv5?=
 =?us-ascii?Q?SEchya6Xw9f4FUjEemMX1Jwbm0pih02BHq6xUwA9m39Lsib93aPeRP7hM6wd?=
 =?us-ascii?Q?M4E+x7uQuoh5lUJsTAhqWWSDn0VLVmS1Nzhr71S0rGTafXi/e+QZ+FBFGNRf?=
 =?us-ascii?Q?m0XyJNFZ2zimZI6TDh77o5ACa0MuaxNKNwvPJjLGtzbAkWYTFGQNC81yGm5q?=
 =?us-ascii?Q?RbvkOALG61BCYcQ8lmfy4b9Zh+mEjYu0lLz866zI68q6St8rGtuMn+3rB0Ri?=
 =?us-ascii?Q?02ttx0Px7edOmjCs7xhNBvLBdRtgWCoARNZSWdaqB8RgKxzA86ytdAaQ4WLW?=
 =?us-ascii?Q?y5VPTzxpNVt8PdtHhXnFzmyH7qRIgPb5SCPxLR2ORj41StnDdzjcjnF/zLtF?=
 =?us-ascii?Q?czmIS0yLkokSgPr+a5KIhasjaC6j5gHdZZaAKR5YDXprlSnWWT6nquZdtRvR?=
 =?us-ascii?Q?jCIQZmOfAX7nvNdfEbjieM+sbc6gEKyqDxs5JaDQ9wntOStkzl+cC1yJu6/s?=
 =?us-ascii?Q?UUAGr1QqCsIb8exTTBSJvjeoBY2dQHBEbZQDE8oF1yNTav4y30BZYjzDIuEL?=
 =?us-ascii?Q?Xe9lMhs08tu67eSTlvc8layfzw/BKgm17Yf6dTjmuswMp2ZX1WptWzOLuCOJ?=
 =?us-ascii?Q?sSyAR9B2FzC5DTdpCvjabtygTAvr05iFga6NCPnx8/eHl6s2SqfBIt41F+UW?=
 =?us-ascii?Q?HCkBAUhGgrjOHY21FoJrk0wms7HocWjBfH4LlOA+UcTj1Bpmppyn/bUpLZAy?=
 =?us-ascii?Q?3WR8BXmkQm1tm3wrduSNBlhQi+IwJP4E1Z2taum0gtuMk5o+xYazv7iNfa6z?=
 =?us-ascii?Q?0Gcp/iuaFNPa/bNDEPaC/t1+PTr9zXjdKuRJeSDdyhLZUXaeGi94igfjtL0t?=
 =?us-ascii?Q?DYSuGj6RHztTUPQZH/kI1MIWxBKBmY2QhTrkHSFbBiXgo5UW/Jm3M0NUcO9G?=
 =?us-ascii?Q?Y4zIawtFF8VEGsc+1vGtbr0yplOHEr4i?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(7416014)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:33.9447
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 86ba68f0-7b72-4e7f-2563-08dd13791624
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A347.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6940

In SNP guest environment with Secure TSC enabled, unlike other clock
sources (such as HPET, ACPI timer, APIC, etc.), the RDTSC instruction is
handled without causing a VM exit, resulting in minimal overhead and
jitters. Hence, mark Secure TSC as the only reliable clock source,
bypassing unstable calibration.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/mem_encrypt_amd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt_amd.c b/arch/x86/mm/mem_encrypt_amd.c
index 774f9677458f..fa0bc52ef707 100644
--- a/arch/x86/mm/mem_encrypt_amd.c
+++ b/arch/x86/mm/mem_encrypt_amd.c
@@ -541,6 +541,10 @@ void __init sme_early_init(void)
 	 * kernel mapped.
 	 */
 	snp_update_svsm_ca();
+
+	/* Mark the TSC as reliable when Secure TSC is enabled */
+	if (sev_status & MSR_AMD64_SNP_SECURE_TSC)
+		setup_force_cpu_cap(X86_FEATURE_TSC_RELIABLE);
 }
 
 void __init mem_encrypt_free_decrypted_mem(void)
-- 
2.34.1


