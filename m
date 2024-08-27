Return-Path: <kvm+bounces-25210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AA6FC9619C7
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2024 00:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33D771F24A7B
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:01:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7A651D54F7;
	Tue, 27 Aug 2024 22:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NfwJf/3e"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF381D54DA;
	Tue, 27 Aug 2024 22:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724796038; cv=fail; b=mwM1pUtDx8L/iG0tmVATxpjvK2/Jf+/dFJi0wuwRMw7A5Wh03dnA0Luw4HbSxzjcF7EZaXva/q0+3ZxriJ3kWt7LgFyCmpI2l1DEl7KlAF9r59nT30OZzJRurHLk00y+edZGuWjXqLhKtFCm8eUaFhZOlqCUXniBWQV0DwgCVgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724796038; c=relaxed/simple;
	bh=7gsgtsp7fPjqi2GzZkuGZecGepka+mlfAypr38lQFXs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MddOZOcSu7MiHZaB0EdplEKneemiTW9AZ+MrgxbuFoNlpeX5IKwNuCfUIgiqO6xvUxVtCvUjwXsVrZumFU5sO1WhUkRTtcbEjR4lsDKPmKlmeLyaxoZDoIOGW7mJEirc+kFDJIGtbIKIB4k6TGdRHlYhuDR3zshDwNGI5Gyfxdg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NfwJf/3e; arc=fail smtp.client-ip=40.107.237.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AE+aXYuEw7Go1Ol5+SBoRwQ0RlNoqEmFb9Hpg/MAdHD/J/yBWjQu6dJ3Aij/jgHr/2fS4wSt95I8/UndabSctGtj3CSFc1AxYac0jPvsI3Tru9aNBchG3iJMnm8OpltvzujYasfdgdBkvuS0ILZYl2iZrhrd2JAih0G6/7Kmpr/3trLREeizruNBBxbnVfc5FUdwv/1BTT1pZV1wqXWIDpLUYO4gPIUww5XaPCWWFo0IX6Nl9iNXQY35GIGEAip9oZiXOIunj168gBRPX0uYeUrE/cZy87QFCze3KD0HIkMhPk7UIVIOU0/12P2dfRgQBh0tBKJNZITJskwcCKiPsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gj2qXXhRtnR0BugKiyAPi7i5qL0MCbnSlW4lR9MZSjQ=;
 b=NfRCCXuoxOXvI2Uc/vwr2vS6YWtVPwlsoMbxC9Grpk4P0LpdwevB+J2e+51NCbzrFOeoCDboRl/KnMtxMNorZa4bdxBR/a0lldvmFM7dtrBjFQ3oMyTsXqWeCjBzO2O0xc+370taqRUryDW3xqeNBtWspwqQCzhx4SDVUD7oHx8G7zO5ETgSRvFbnsV+96qWM6JqU+Lzxod6pP9bMSFvjR1byVzeRyom57+HxwIy8r2D0GdsFUbE2jtFhL0KWJStkccrIJVyyudKX7PQ2G+lK2ax3gh5dv4v+YkKem6dpgpcOx9o8Og63bHIk2Zb4i48OWb7oEnitDVNFXIuXGhuUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gj2qXXhRtnR0BugKiyAPi7i5qL0MCbnSlW4lR9MZSjQ=;
 b=NfwJf/3eSQa5sqtosV4OAj+I2GoF7st25+CMwhtdr3IFtCQw7yV38Jk+IXoVAXkR2mIpGLFMGZuDJAlZeqcCUXdBu1oBBw2AkUz1wGdePZkUfLCiBiMbHH+Ol9Fvwp5EgZk3q5sUZFjdGpEtRQA3i8b4a9HdkhXMLHPxIn1QBjk=
Received: from MN0PR03CA0012.namprd03.prod.outlook.com (2603:10b6:208:52f::25)
 by DM4PR12MB6589.namprd12.prod.outlook.com (2603:10b6:8:b4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 22:00:34 +0000
Received: from BN3PEPF0000B06D.namprd21.prod.outlook.com
 (2603:10b6:208:52f:cafe::93) by MN0PR03CA0012.outlook.office365.com
 (2603:10b6:208:52f::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.26 via Frontend
 Transport; Tue, 27 Aug 2024 22:00:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B06D.mail.protection.outlook.com (10.167.243.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7939.2 via Frontend Transport; Tue, 27 Aug 2024 22:00:32 +0000
Received: from tlendack-t1.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 27 Aug
 2024 17:00:30 -0500
From: Tom Lendacky <thomas.lendacky@amd.com>
To: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Michael Roth <michael.roth@amd.com>, "Ashish
 Kalra" <ashish.kalra@amd.com>, Joerg Roedel <jroedel@suse.de>, Roy Hopkins
	<roy.hopkins@suse.com>
Subject: [RFC PATCH 6/7] KVM: SVM: Support launching an SVSM with Restricted Injection set
Date: Tue, 27 Aug 2024 16:59:30 -0500
Message-ID: <25460ae2dcf050bd26ac58b71b727bda3913529a.1724795971.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <cover.1724795970.git.thomas.lendacky@amd.com>
References: <cover.1724795970.git.thomas.lendacky@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B06D:EE_|DM4PR12MB6589:EE_
X-MS-Office365-Filtering-Correlation-Id: 0bdc5b2d-c074-45bb-e14c-08dcc6e3abc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2srwx/z/vo5BfGli/3SQJ4+aUhci7Thuktfex+zjP266pkn7wSbPiJ8QDm5W?=
 =?us-ascii?Q?giS2mFUmA9hXzRJuNvFHxWn2y4qWKysNM15pu98YGsMbjeXqzoPPEHQprayk?=
 =?us-ascii?Q?rOHnz429RhyRA6YTrJ6o0Uc9MI1M0k4uKAI/lI6VU2iBRsLt3WLQ9+ZNWkMq?=
 =?us-ascii?Q?NNRlTRIMcLhSPujRY86ujSaS2V55VZePWlfJs79yeCwntFqLjGe887PahJ+J?=
 =?us-ascii?Q?FffiD9FfkW+kkQkA3p3igEMk47MyP0BdLIaFLG1tG2solm2qVRS/NkrA2o/U?=
 =?us-ascii?Q?2nNfHgW4kkg1NVw2LPsUYENh7Zgvtlu9Hw5YIxVBiV1+SPQ/BzfUn2LYuoWH?=
 =?us-ascii?Q?cnlHfQJzGKcNUsZYz+bS5MdNa6H5V6AtO6TknDrp2Zww8m4+87m1SJ54XRA+?=
 =?us-ascii?Q?spqHL/OEZxReWcKHKgJupPJ7KO5pi5PVdqp7cIxB80RJ9vDT/gFnWjg6hLyz?=
 =?us-ascii?Q?YYMBb3YBLS3e/9JvMI++P+ZrT+KIGxul85U7hZ7FaWafZbYI/7E0LoZPzDx6?=
 =?us-ascii?Q?BYWDmXKnKASgRFxqc/GB0Pbui8ClBk0fZ9kPm3Ou7Fdroh0ZGF6czpWzBc3m?=
 =?us-ascii?Q?0gj+S5E+TsalIQudaSWaOeuswG0Wyh0MtYLUNHtyiVQ0rWMuvPlVk8Q6x496?=
 =?us-ascii?Q?eWX/4zsOZynmuHMCVhY24HrYj2+qdnWXKh1OM4WHapdKRMeTUubAf/cTSNZN?=
 =?us-ascii?Q?G+Q07wkEG6kQGrzGiOiXIVPDb9Q7/iVIVyj+sTu6cOEXUO+SywT9z/B91eyf?=
 =?us-ascii?Q?uufgwJqNRJZcL9tlErxgWXk5hLRlhHuyLA2YZY9DQlL+NGGWyGankdOe2H3x?=
 =?us-ascii?Q?sEfNZnOGRq4Q0s+xmVU/pfnbGdNfcjMp3AN52dzlOLgJl6tZgFaRljc8yO28?=
 =?us-ascii?Q?D+yPKwgPKR/tBXnJkkP+ME9DGUDnhAx7f7bnsNmJ4QXUlzu/LwYxMPvoumpF?=
 =?us-ascii?Q?uKvrcuUcIPjyrwwRZ5ceEBVTMkAG+fbVWRDKAq06KHE0fCKS5dTejxkZI17q?=
 =?us-ascii?Q?FUmgzu9PHP5jOwu9trM0CXGqnt44AkezfRgyeKCzWaLCGdWa5k3lypVW/rfD?=
 =?us-ascii?Q?+eL3ejmeJCCSEf9r5PqkN0/AxISA3APXczCwdzUD9EM9Dzzr8INkn/CvoP+r?=
 =?us-ascii?Q?YymLs00n67HDh4rc8hxCyqNc3Q/+/7lUjuJKufuGlAV9OChIzfilxlQAYOLh?=
 =?us-ascii?Q?/eEjlaotXJES0e/1S6LluoSkv7j5dZlJL3klm0WW/3u/t7gCWPNoMoEd46yW?=
 =?us-ascii?Q?QCXFIQGFIViR8vKJxnHEMCVVt2ViGYWkjIqogsA8aUkjYZTfF9oqKLg5GEYn?=
 =?us-ascii?Q?mWBkeT9hIxAtMaqmUaoa3N+qK4vXQGPz53qk3MeOVsubqamtlMgZosljhS7k?=
 =?us-ascii?Q?NdWxJ3tBppuNySeCjXnFyngQdffyXt0mhCmDkMtTOCVkDxgR8VHbWB+QgK8D?=
 =?us-ascii?Q?DPPNsYSyoyoxQGEr2cvTGFHpM4+I7pRE?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 22:00:32.0406
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bdc5b2d-c074-45bb-e14c-08dcc6e3abc0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B06D.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6589

Allow Restricted Injection to be set in SEV_FEATURES. When set,
attempts to inject any interrupts other than #HV will make VMRUN fail.
This is done to further reduce the security exposure within the SVSM.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4324a72d35ea..3aa9489786ee 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -3078,6 +3078,7 @@ void __init sev_hardware_setup(void)
 		sev_es_debug_swap_enabled = false;
 
 	sev_supported_vmsa_features = 0;
+	sev_supported_vmsa_features |= SVM_SEV_FEAT_RESTRICTED_INJECTION;
 	if (sev_es_debug_swap_enabled)
 		sev_supported_vmsa_features |= SVM_SEV_FEAT_DEBUG_SWAP;
 }
-- 
2.43.2


