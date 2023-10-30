Return-Path: <kvm+bounces-52-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C95EC7DB396
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:39:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DF70281497
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:39:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A58C7D285;
	Mon, 30 Oct 2023 06:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="HH2zhQyQ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9605D267
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:39:06 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2089.outbound.protection.outlook.com [40.107.102.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74ABDF;
	Sun, 29 Oct 2023 23:38:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8D7RbWzqqDfwxwNZrfLoIGTGBlgYdu00DBrIISNIwFSoFr9HWAs/mYT12ql09hEvE9xxxO3IzRyh3XOEUoK4mIpJeGjRPQ0mxGays2QhyH+4DhuCvEmZQpje7DHiKBeaOkY8r9M5lY1AIOnCaiTxhZrpRxB/OEWuQouLaL21d13V7UHHOFViXWNpRBJn7Vgf/8uuynNaK0sFh2BX7vQCq2WJqydO/FGZpFy+eheTtUialV1xWihvUt9SwAsrMrpMbJ+irB/Czk7/MTnm/MS4x8jFnm4kwRW2R5Lhno+80mbRgpi699vz+zqBMcWsW+AuuN+hDCHhX6E+653HOQKdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILqZIkS9mKKLRTC/aYbD3HD/UriMPsQavoeDP1l02pc=;
 b=cJi9nvvO5RObiqd/KfErLhP06lx67ztjvQMBlfn+D86puSJoow1vzUFMg4gWmE/doEX2Xds74byznSfu2n/IXbAudIVk3ayvRBzzvL82ZtqA4NV0gjjlK6jwC2+xkCV7L+5CHKTd2SrPOaKh1TGAixOCWe6Wp7o7EDY5vFZO9JZqAO+Pjgk6wgj0PPrLDTnzDerXY0b54z+6rFinwRo+XWj8cy686eKhu+aDnvZv2hDpyzbd1b28LaKkKpbVdiLxw/ZvRrkk3UQh0wD/iknJf+5MDQuwIHIKwZxwszE17b9WR9hiFgJ848x5shlFhyuRRrvAJ3DMLfj3VwHUtv0ghg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ILqZIkS9mKKLRTC/aYbD3HD/UriMPsQavoeDP1l02pc=;
 b=HH2zhQyQjQJmcC/BufQOkOpMHG6yv4oPkXXEVZAl07ayjvzJLa7MnZbrPjFe9JhxHZkS26uHjDyHS5Ys25x5HjUPzKt1A2BLscRrTXCz7uyMvav/241w2HK2pZyESHWEvoknVl9rtZZWZ7uDyIXPxOkXqcYbs9pOoOhDTyjf9do=
Received: from BL1PR13CA0300.namprd13.prod.outlook.com (2603:10b6:208:2bc::35)
 by MN6PR12MB8470.namprd12.prod.outlook.com (2603:10b6:208:46d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Mon, 30 Oct
 2023 06:38:49 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:208:2bc:cafe::59) by BL1PR13CA0300.outlook.office365.com
 (2603:10b6:208:2bc::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.14 via Frontend
 Transport; Mon, 30 Oct 2023 06:38:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.15 via Frontend Transport; Mon, 30 Oct 2023 06:38:48 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:38:44 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 13/14] x86/tsc: Mark Secure TSC as reliable clocksource
Date: Mon, 30 Oct 2023 12:06:51 +0530
Message-ID: <20231030063652.68675-14-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030063652.68675-1-nikunj@amd.com>
References: <20231030063652.68675-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|MN6PR12MB8470:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d0a6e4d-48a4-4428-dae3-08dbd912dfc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C8o/5IE+ZRhA/HdMhEAAMTwcW+okMPBeP3X1QvfVK1CzTX94blqazXjKAXGiGurU/zqxEC+s+E5hBlP1iDPlapmldZpjZZHid5Z7+1EnyYPSvRe7W9LDwpaALO/pNSGYuLHJMCSH8fcPTc1zysXmSNVQVOQCL7AW0uGjhnjAnD/8QmJ8311JfgIlSzURdR2YyYKxpAiWR1z2XMVD1nIOhCiZukoTBL7VNDEgcpjEZSAN+ZsM1IZ1pXAKgdpmvowwNckfPmhmLrc8gvRVwjqaPGUBBobQEv5bkbhn5YIkgKMb1hRs8dAEpzPoHyVzmXHgAiRw2Op5tg6qyhlZEz7OtR9TTbZZxyuCacjn65w43ulUz5MB8NG5PeFEy1QC3rXgfsBKTuW62JnNCYdGPi+03nQ3ATC7eVS8dOVzDHrP3+8ZY5h58DJ4WcfmC7U3zrU0u7Ow1Y0QqEVlv2COGuuSJlRKtOetW1A66cv5zAlrop/tneLKBqnMocO3n/ovG4yesp1fv4zMDuncu7KMAz+uICx1OMcHf3Tj1djZLpgfAawO8orC4UjCDa8PPj1CHUGffxvYeobgAIHuuUceK3nrogQxsDouA1rnRqVyCmoZ9EPkv0plGgLfhRyD+INWuIRL4jorNIaVucQSzw5GvJlf8/b4TPWoTDhHnY2p4IFoKEjsFd2CFGnqo3zdLkTKpoQSVB8bQg9aAjqxJrwER6M6qY+fQ9CPKRB/g8oLCJ6CA+wpjhy6dFqdMrfT9PxoStmQks9OPDSW47Z0IPZIglBLDA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(39860400002)(136003)(346002)(230922051799003)(64100799003)(82310400011)(186009)(1800799009)(451199024)(46966006)(36840700001)(40470700004)(7696005)(6666004)(478600001)(83380400001)(16526019)(47076005)(4744005)(26005)(2616005)(1076003)(336012)(426003)(2906002)(5660300002)(7416002)(41300700001)(54906003)(316002)(70206006)(110136005)(4326008)(8676002)(8936002)(70586007)(36860700001)(36756003)(81166007)(356005)(82740400003)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:38:48.9775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d0a6e4d-48a4-4428-dae3-08dbd912dfc9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR12MB8470

AMD SNP guests may have Secure TSC feature enabled. Secure TSC as
clocksource is wrongly marked as unstable, mark Secure TSC as
reliable.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/tsc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 15f97c0abc9d..b0a8546d3703 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -1241,7 +1241,7 @@ static void __init check_system_tsc_reliable(void)
 			tsc_clocksource_reliable = 1;
 	}
 #endif
-	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE))
+	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE) || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
 		tsc_clocksource_reliable = 1;
 
 	/*
-- 
2.34.1


