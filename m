Return-Path: <kvm+bounces-2610-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BC1457FBAC9
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:02:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5CCA6B21EA9
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D952358117;
	Tue, 28 Nov 2023 13:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KjMNtqwh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2047.outbound.protection.outlook.com [40.107.92.47])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8222122;
	Tue, 28 Nov 2023 05:02:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9egqB2OYyCInoPNffxj8eEIC4egHk5PQAXlp1GhVk44uFldj6WzAogo/adUICiQBCdhZdrPxdhSGlWedoxfdMxi1lr7aZMpiRtvo0zE//EuV4Yrse8UNL0wYxHb4ub/GYmF7X6iB9Vhq7jm9r+E3tp61QhCqgXNXS1q7ouXdZg8y65+pefWXvnrRCWU9gagFoWLOE5VRCl8Vkh9yo840N8OjBjfmxSwOMpnGyC2QHsdFUIImyjsLx/GetAy8/bGqOcWTpW5vtvKmSFpMhoNqtrd8ccu1lAuumqQVUkx0PKhycJaiw0nbFo5rpiVJEIfx7C0J3yFc6blou05L7O0Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DoIGXPWW2u6BNrthiQutl9QcdfJ2vIgLXlXyGNU9zEE=;
 b=ZroXsjowuetI5ovJrssMwJj0CwGKesanlPlkITco5jaMWPBDKkJ5mfZQa5O/LJ6xx/vSc4Z4KUU1nfjzmUrhD6+89YzyaFs8NAFx1ZwmiBEgQP7vyEK+lmpWpUfkHxEPtNuz7buUQ5zDzr6Ee7TkWuCppYu2OXtQppcvJBagu9/uC6+LMgfhFPlX/gcQWLVcej+CTVGHRqmiHQ0j/DxDSdNrLHvAZ8dTiP0uurd8CHJbgjQfO0ubHcPnMi6KzDhfY/qce9cwN8xWafxqojKd6FJ/TasaiQbzqIonyRHpLjFklC8owxlHqnPFfR17NTf5AM6qgRQV+z2lmer9wtoGVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DoIGXPWW2u6BNrthiQutl9QcdfJ2vIgLXlXyGNU9zEE=;
 b=KjMNtqwhylVimXpXcfdtF3bEpBdihdBJ1gsvuAO0wKXlsyekr021rtwAxe+gCx2Wej4X061YWdXdalvARbZ6DMz+cBwEt0L5XWx4mUZLiaN2+u/Cm4MLqADV/xUEAnYNdY6kEbLqNcjSWeX/ADSCnpQ/mZ3KXOyzFvJAlOXOmgw=
Received: from CY8PR22CA0019.namprd22.prod.outlook.com (2603:10b6:930:45::26)
 by IA1PR12MB7759.namprd12.prod.outlook.com (2603:10b6:208:420::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.27; Tue, 28 Nov
 2023 13:02:05 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:930:45:cafe::be) by CY8PR22CA0019.outlook.office365.com
 (2603:10b6:930:45::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Tue, 28 Nov 2023 13:02:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:02:04 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:02:00 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 13/16] x86/kvmclock: Skip kvmclock when Secure TSC is available
Date: Tue, 28 Nov 2023 18:29:56 +0530
Message-ID: <20231128125959.1810039-14-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
References: <20231128125959.1810039-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|IA1PR12MB7759:EE_
X-MS-Office365-Filtering-Correlation-Id: aef4f6a6-cad2-4f16-074a-08dbf0123860
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KtDimcCuPih2xIwHjueioPijoKBhNzbi2I9lyhSM6petuhXgFG17U0JQH4D95O+4M11cyslgyRtygCOzQyn6rVn3eK6ElZlO9d1Y8XVDYWiQDu+hiMy7lOgnayNtn/792hyOrqhG2vv0CdjdVzJqR5SWL33IhB6FRDcgzovsKcIeuZd8ggFXvurZplg4nSSDGS68v1ctyu+w4+fTme+13mniE9IIyhlSiqqFdDuQMwnPEQT88TZc7zD/z4fyY+AMUlHX8VDwBzQsjie6kEL2IylxZxl09qvA6KGFd+QhBsWROzEKHwbpBs/IeovmdYDP/nfZ5jblJiP7sM8fzzMGIZAjDJIfhvhl70jw9PPt5j2ZP3CeHFmf0cp87uDf5NgmIhpEtQu9gjbqYQgIimwe2ExeP7A5FqaKiyjeGbzA6jFT0JbLj3FwTck25sVWTkaXSYSO13F6ze6mAiW2gdBwiMdTZLOUu0UjF3/AEtLRQCED0WcFxqG184moGVZRz6dRVwdVCK1hNI0J8nwp8ILHQqihAOewQw9pcn/EAg+rXGkMnt4NjAyK0acb4sPoXyQf+8IACWmQupj1kFEbVE7RQ2tyHZCB0RMaUf5cd29nhqxhdxST+F20GQx9QmslqDW5ryV8THOLQCDV8MmGDurfsdoZf8k7bX8GTFXUUsnbCzCqiI8AcX+fG9Ppzzsj+F1fUlIpqJEcC3JUyEbGYWeKLYFxaXTY/FLajMZ34k/NH2kEfhZAK3cn0VotrumGkY1smBL8EVU5Xsbm0AhN2NRpZA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(82310400011)(36840700001)(46966006)(40470700004)(40460700003)(7416002)(2906002)(4744005)(5660300002)(4326008)(8936002)(8676002)(36756003)(41300700001)(336012)(426003)(16526019)(82740400003)(26005)(83380400001)(40480700001)(7696005)(1076003)(2616005)(36860700001)(81166007)(47076005)(356005)(54906003)(316002)(110136005)(70586007)(478600001)(70206006)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:02:04.7858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aef4f6a6-cad2-4f16-074a-08dbf0123860
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7759

For AMD SNP guests having Secure TSC enabled, skip using the kvmclock.
The guest kernel will fallback and use Secure TSC based clocksource.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index fb8f52149be9..e3de354abf74 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -288,7 +288,7 @@ void __init kvmclock_init(void)
 {
 	u8 flags;
 
-	if (!kvm_para_available() || !kvmclock)
+	if (!kvm_para_available() || !kvmclock || cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC))
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
-- 
2.34.1


