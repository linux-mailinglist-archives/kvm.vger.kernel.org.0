Return-Path: <kvm+bounces-10139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD3386A0A3
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 21:05:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 279802840B9
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92F4B14A4C6;
	Tue, 27 Feb 2024 20:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Pl88GRRY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2055.outbound.protection.outlook.com [40.107.95.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1336F2260A;
	Tue, 27 Feb 2024 20:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709064291; cv=fail; b=SYPc0/2vCjkuBcDSjGnet9wyAjAK5Rg6Fy4LQFA/1eXfsLFpnDa16PGMd0AdzphKCKeFfy5nDQj7yWPXsN5VkIyJ+Snc4k9bSupKsLSeWahnRf3+SaHs1i9aR4aYej/q6aDuV8gKqmwmDQjoxeZ0f8QYvdk8VcS5y+gdNl3bQvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709064291; c=relaxed/simple;
	bh=M9+bXWsg73l4QCENfYfOSIQg1c3tsFWlDf4P8x9lCO0=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=DEt01TkBIRIgvJrpGbxHZtyAJ0R4M9WQsUh5nKrgBAA39u2tfRUl17Ma0hwF4KDQEpdEI4891/2AyvqBxK1hrJWSzSnC8L08R+JK8nlQjtVQq7SyZvdG0TLV1p9Km5XV0woiSiKF+GNhf3jy23ZbzpNwEdRRMEElQl/3evSMkSY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Pl88GRRY; arc=fail smtp.client-ip=40.107.95.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vqq52YAHPfhC00+Mle33v/QvqugIRDawqn0g5w0CALyUXmXl4vSeq1VvpsZBHnkW1XWaL1li2rJg5aH5wwfGSJadA1jaY+fBR2SnE6Nd6YmUe9CaFNdOzEJTr/YS3fxVW5LtH3x1wHSEGZCnE0aHY5W+nkH9SOtoUcH/fhbxeJ3A8/EOvYGAiyWMuBbLUIeXIJIrAWe5aXp/l3l0z+R6XOF1+5N8oyLjMgRT1U/aguqAU7fPorMUAzcDfWsWQ+dTomwfGSPdQxgckX8+VTg1QEpw36vqxvKtXZ17Xajdkb+Wf2wY1bjbV1oho1Eds7I3HJos/dmHWz9GRRmF0BTyQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qywH2/mDhHSGfqUT3oPQ3bb5JCakNxiJe04tcIGneLE=;
 b=EbD3cdse1ZpXiAdC4BYAvaT6+jjcmfaIGEj37gCnPLbtX2My79jznQ6EqwxRDH5DkCp8dz0fQlSP0F1S/jIoYSjiwkon0YavexBwagiIjENiJyPDUkzDYNZ6A6QFC0anw8vhLoGvx5GM0888NJj9FmIMyxTbRfFmZsbZ5afIcKFJppIin6OFHiIDkBVkysaVSrVbAv3QoWdooBgJ/7ivsOvgFbTgk1kmkxdi0mvLf459fbZwjDYIxor8h7khWBKrXeUsi6ila6NGns7JU5Je3KOzFWtaN2SX6364ELcQf1NEGPaBJ0uXZc1DRe5k54tQFT6+MPJ5AGm8tiFfurPZhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qywH2/mDhHSGfqUT3oPQ3bb5JCakNxiJe04tcIGneLE=;
 b=Pl88GRRY03W+7EYElPqi+81jSQl50e81u8tkeTW+YK+gSi/20gipHFMwnsy7aKItvhNef5HgH9WKX8GZg1Qzx1K5lt7Piyw1IsVJHkilcevR+1fPWsC3Kh0rzukj4hQShYMhHXvPx/L/BLCLU096keOihYesiRnFFl8lWtEwGbY=
Received: from DM6PR07CA0117.namprd07.prod.outlook.com (2603:10b6:5:330::32)
 by CH0PR12MB5153.namprd12.prod.outlook.com (2603:10b6:610:b8::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.39; Tue, 27 Feb
 2024 20:04:44 +0000
Received: from DS2PEPF00003442.namprd04.prod.outlook.com
 (2603:10b6:5:330:cafe::aa) by DM6PR07CA0117.outlook.office365.com
 (2603:10b6:5:330::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.49 via Frontend
 Transport; Tue, 27 Feb 2024 20:04:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003442.mail.protection.outlook.com (10.167.17.69) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Tue, 27 Feb 2024 20:04:44 +0000
Received: from jallen-jump-host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 27 Feb
 2024 14:04:43 -0600
From: John Allen <john.allen@amd.com>
To: <kvm@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <mlevitsk@redhat.com>,
	<bp@alien8.de>, <x86@kernel.org>, <thomas.lendacky@amd.com>,
	<linux-kernel@vger.kernel.org>, John Allen <john.allen@amd.com>
Subject: [PATCH] KVM: SVM: Rename vmplX_ssp -> plX_ssp
Date: Tue, 27 Feb 2024 20:03:56 +0000
Message-ID: <20240227200356.35114-1-john.allen@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003442:EE_|CH0PR12MB5153:EE_
X-MS-Office365-Filtering-Correlation-Id: 8497f3d3-397c-4d9b-2c11-08dc37cf576e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HscLFbJF+DCC3YHYh4kRG6N5i8iQPSup5xaJ6JE0TSyXYyej5PmfMUetO5z9P2NYjXIKQvyEqoYD1W8HJqzqO2Ii/OnNGFEq8nsmvONdeblIKSF0bw9Kegf3Z443hdcf0XsI6QseFBlQgnQ4zMXRwPQPT/F8xoqOiRO/q2R2Vxdv0MeQfWv6Nt0og9JnoxeKkiW3rG9o2fc4UELXo9q/7ndyuM2MUCSCOeqNGrY/ks/pZOpoHOLN8mNt+LnIxG/VxMgbw3OlJfTp/StKXGioSelv/bpwKijyqx63VyV/7G1EuAE2QzZb4tdWMiEi/ivH26UlXuCJAVnQYaHJZr5UtNyMXXSAPZN1Sn3RPGIZenFpzlRsgjVhc2KMQao6xRP/JQt1kdC8DQYvIL/Ycnm/a4oa2UFalkKFZTPNTJvpDU/XBRiZz6i4+jBVKdhiz9Y4Pbv0PgIlu4H/e9kmntFlRKoRBDUZOzPtWZNEDMwPzSn4r+2eL1S1StyBuS0NOPRmusD8zBSg7lipAMUAROqadSIrjf11CSCVOL0cmgQty1LI6EoNNpo8AEoJqJGLtnmPGpmJmd9CgF4JkLdVCaQRxrhjAGzyJgcljA5xwU3ZPcUTBtb30qLxFgheaXhlKT9V4dGjOk2HaCEhiSLrVbrfcLgRGKC4CDJzAbNvOvSQj5QpuzNZEES4hDcT+1lSvS0JwNU6KRX8SRUEmlAZB8TVGhrRf8lpCG4YYXPYKV3T2TkmrADjSAU0Pv7pik9HX6+J
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 20:04:44.3582
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8497f3d3-397c-4d9b-2c11-08dc37cf576e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003442.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5153

The SSP fields in the SEV-ES save area were mistakenly named vmplX_ssp
instead of plX_ssp. Rename these to the correct names as defined in the
APM.

Fixes: 6d3b3d34e39e ("KVM: SVM: Update the SEV-ES save area mapping")
Signed-off-by: John Allen <john.allen@amd.com>
---
 arch/x86/include/asm/svm.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 87a7b917d30e..728c98175b9c 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -358,10 +358,10 @@ struct sev_es_save_area {
 	struct vmcb_seg ldtr;
 	struct vmcb_seg idtr;
 	struct vmcb_seg tr;
-	u64 vmpl0_ssp;
-	u64 vmpl1_ssp;
-	u64 vmpl2_ssp;
-	u64 vmpl3_ssp;
+	u64 pl0_ssp;
+	u64 pl1_ssp;
+	u64 pl2_ssp;
+	u64 pl3_ssp;
 	u64 u_cet;
 	u8 reserved_0xc8[2];
 	u8 vmpl;
-- 
2.40.1


