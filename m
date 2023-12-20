Return-Path: <kvm+bounces-4948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8683781A222
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:21:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BB8D1F24ABF
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE6154A9BA;
	Wed, 20 Dec 2023 15:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JCeWi2Fu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D098C4A9A0;
	Wed, 20 Dec 2023 15:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bF5seuj+78E+raXnqrkKGLQY6lz1HYG+0q0PPuMIT3JIpHesgyeKR0/KCnxwso+aSE8Fc7S8f7k8zRqY+SAMOTTLiHThUUxcNPFutnXfBQoH1ALpPYGc03xZ18kUbH9yhoLXwFH9zbzI8IYtfxBlC9WdEj0JyDzJOladjuD65buc51BWyXXXJIwHW6Ekoz6Clvdh3NRGq1PXxypE3tCzDnkUFPC1J4muOXgDsE8nRzNRnYZkf313qRSErjmcLBOBj5p5/vhq0tBKV/eEYUwnB6rz4dnrYvLFiuNJTDSD3EaAnnv8Z3qTvYI2M73j/gG68qznUMjqIhSdJE/6xO/Y6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lxMh2gFafVbbSg5ON5U0cELcw5bQfEXak4dRapTlmAA=;
 b=BqK8oiiXjZ/5VDzlDT9KZw9cPiOTKY95NDRxNoqMkBzG6wXCTtNsYf5vG567vdUp3BxjtYadgNC17lcxtUeUv8HM0IgJD20/2gkwL8IO2mVOhr9313SHFqU3Pz5+bl2vRnHd92shng0wlYWCBz9Q9oeuew2M0wLN2xZtfF97F59oK8uQEzrZuoDcBGxemRgR/PFKvS+bMgNXMUVyl1bpbHG3h0YVzk7b3r5lozqPitSCf5NHbemHi1LQfSFZuGf4OyuF5Y5ajRPTy8HQMBYd51DzNPFAwjvnWIfvW9XDnHzhfnzAbyC2eikBTWjJ5jPKhM4TfWDpIfZ39RSO7nZ/Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lxMh2gFafVbbSg5ON5U0cELcw5bQfEXak4dRapTlmAA=;
 b=JCeWi2FuQYeF+1o65k6MsJergf05KMZoyM9+QJt4HV7eEIU3wn2jDnDwgXt4OkXQGhkDMC5AR85NFtRoyVx+WNP1XavtHxndCpixsKYFC04AuKqbEKKuYsgr1g/63qeQqoZVS2rwO7q+pKDPUf55bez2mXtl1qE75/NhC2OeEfY=
Received: from DS7PR03CA0240.namprd03.prod.outlook.com (2603:10b6:5:3ba::35)
 by DM4PR12MB5327.namprd12.prod.outlook.com (2603:10b6:5:39e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:16:02 +0000
Received: from DS2PEPF0000343D.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::17) by DS7PR03CA0240.outlook.office365.com
 (2603:10b6:5:3ba::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 15:16:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343D.mail.protection.outlook.com (10.167.18.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:16:02 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:15:58 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 13/16] x86/kvmclock: Skip kvmclock when Secure TSC is available
Date: Wed, 20 Dec 2023 20:43:55 +0530
Message-ID: <20231220151358.2147066-14-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343D:EE_|DM4PR12MB5327:EE_
X-MS-Office365-Filtering-Correlation-Id: d597b634-d478-44eb-3af7-08dc016e9415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	LkezmpRgtC7G/BPmO+19IqsDIr/TKlIaREe8gvmeRZKEWTtn/cZc3EdzhYZAsmRBef71pHgmKBiPWqON4xPd0vvz6OLHvwWXL9AEVaod9bjq6VNTJM3pPavRenoE5LDcbwPUzpmCiEEbcj4fZkx+3sblCW42mT8BKmCkmRyQrrRN2rMA64840PEnuxlGDiefouxjwP4VdvhscAB0RvLyDCiBhjDMwywIORwdL9WTQd6lrqTi9WLTQuMiKNr7t+BM2pzwYI0dDpu15BrGax6y7P6swE+THJ0g1Jgw2tH7HoBsbYbAisDqAJmswYIDW19wT0ytRm33ithjlvc2g/04+SQJzX4iZ3qqMSoIcEI99vwY/r+gmIJUkQ74kx5tmyiF9pQJjfVJqxHS/m3uNKQXZtHuHxUWfnuhokoNyBEATuRqvCmjyUWhJgweDYa7JnwCWc/zGFmiENstbcBLVmhG/ftpd4tNPh4ZzoRIVIKiuzO0n7IKHUlvGNtKr5+Hq2vEn/TDj7I9xaxqFGNffnHFZMA87JjkSy+3/3GHjqdyLjaN2mmleH/D9bMsq73FEZ1cQhdBUysNc0quOefxmbqy1Cj6JqQ1TsbPAEyL3qBxcKY3Yso+Aymxxzx9C80NqC7zyVqUF9VuX8w+FMAj+3t8kiGCcWGLr174adUDtVsbhm/dkaIpF8Y9tMY7RbvVLzwNdMJHQGEuimIs7I3RXpMRF6Tk2705tsxNMS9o/7dSbr2wFOYZWJI1bOt6pfNxMIz2AWZyid0Yq8VZYkNooM/sVg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(346002)(396003)(230922051799003)(451199024)(82310400011)(1800799012)(186009)(64100799003)(46966006)(36840700001)(40470700004)(356005)(81166007)(82740400003)(7696005)(41300700001)(36860700001)(16526019)(26005)(36756003)(83380400001)(336012)(426003)(47076005)(4744005)(2616005)(7416002)(1076003)(5660300002)(2906002)(8936002)(8676002)(4326008)(70206006)(70586007)(316002)(54906003)(478600001)(110136005)(40480700001)(40460700003)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:16:02.1436
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d597b634-d478-44eb-3af7-08dc016e9415
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343D.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5327

For AMD SNP guests having Secure TSC enabled, skip using the kvmclock.
The guest kernel will fallback and use Secure TSC based clocksource.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
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


