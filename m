Return-Path: <kvm+bounces-51-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C70637DB395
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:39:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9FDBB20C52
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 432D4D281;
	Mon, 30 Oct 2023 06:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZbFewnrC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5772CD267
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:39:01 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFF010B;
	Sun, 29 Oct 2023 23:38:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UvcuOqc1zG+17SXElJE6bj405zMTmGU+KhYZNcfQELPeMUbqn0UTyT8wQGLIjXdX3jfHbmGuKVQC57GvBNnVa9midKCsiF0u/N2Ul3/AoNpTPNb/IdNkwKj9thhXOK704XCxNvzH3DZBnjEH9TQDXJE6AA00JaI8dCV35wIQ9D4JHCsGGp7keCQWTEzq2Pj3F9N6/TJcblaM1Drq/V01PMUgJ+z2L2dnIFt776NhhFEvuaworJ7zVA/1TDmVWPTQaI7rtKkeJSESYVCCZQMbvu65GINuzSrlq1eS6Cwq/uA0MnAdJAtnwVg+7a50IPkdJlGQV5QvdS/0ivoEt4WKHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CajR7H0v8b75lpkKFGuIKYljP/FvQJmTNFH361NhMwU=;
 b=J/bIEIkNglW8FTCXhvR2bDxPo4Aw6sbtPwV/bruij5ab5AQAjMWKU/VQyHPvJpZsPFafa61hVIdw7Er1spYj7GZUuTCZocbM2hRLHxGkxR2NTgfusRVLQeU5Kqy8pey4Ku5miiP2+9HkF92wgglitKV9mOUfgXyR3NUcgZwyN50Ov93HsgLs9tu40Ly/npDMWIJHrFNDqc9J22f/TqVZ8xnSOYeP3HOKOP7iMyrmfL+w58lx9cooqPxP61rPuCso2507QUdn3gd/O1iL+qCyyO8hamb4LOUiU0sTq5zGf0JLefGNerjefJazPebacojShRTomFm32+QnX0vfXOXgGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CajR7H0v8b75lpkKFGuIKYljP/FvQJmTNFH361NhMwU=;
 b=ZbFewnrC/JGBY58/4XD63ceuE7sr5b3kGh8kSDOjAkwbdVkC9ejjXRc1Gi1BdsYU5dCaqi24qLrCCGW0L/BGu28tTjIW/cYUHk/PYQPH/csDvz5ufiahABRWibziY9L/aNQUzlhpvG+Mg356rKrN031QnrkpiMdmNqTCtD/mIdM=
Received: from BL1PR13CA0004.namprd13.prod.outlook.com (2603:10b6:208:256::9)
 by DS7PR12MB5863.namprd12.prod.outlook.com (2603:10b6:8:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.24; Mon, 30 Oct
 2023 06:38:46 +0000
Received: from BL6PEPF0001AB71.namprd02.prod.outlook.com
 (2603:10b6:208:256:cafe::ab) by BL1PR13CA0004.outlook.office365.com
 (2603:10b6:208:256::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.15 via Frontend
 Transport; Mon, 30 Oct 2023 06:38:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB71.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.22 via Frontend Transport; Mon, 30 Oct 2023 06:38:45 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:38:40 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 12/14] x86/kvmclock: Skip kvmclock when Secure TSC is available
Date: Mon, 30 Oct 2023 12:06:50 +0530
Message-ID: <20231030063652.68675-13-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB71:EE_|DS7PR12MB5863:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ebcc115-74af-441a-1546-08dbd912ddce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	n7/9EJPb0/dwMl/8G7bq1TqmQ9V6w4GFLLRyOhcl8BamSRba+2mURnvUDmliHtaR3Y/JRBfgSjyXIzOq/1Sy82ESctCGsw+deqx1aphv8+yqqhhRmKfapo1VAyynT5UaxzecTatfvTny170apNwTrOKUOWPlM5+NdEQCh0tNf1i1/QxoncZ5PoPHr0yd9PQIv2wzjv2Ek6xmAeliVJZxS19t2MHZ0wg6ufF56EIv7yFltjF2z8xn7hsxN0fcYhfB9GmA9NtF9Z0ySDSfBcADSCWHs9vNdZ4xHNWk29axTxs+domUksj5tkAEEB6g6CaScERYkGKXLW6KgdMl7eaT9Ns9N1zYFVaEU8ruN4cDRhS6behvdzcyfv2lQGSYUWWEkrBI9ddyeDD3y3DF99tlnIJJlZI2lM+vKNbO5wPc3acIFL/4v9nNYsXVqnFGvpGn6TlX7vpRF6if4Aos6BqIDIVroBnZzS36GlZpyM9+aLTrQ/pc+ys2YQsWndzqHCgDVg3FYoM4Oi9H29qSp/l/ra7UYkEiKDLvC2OSiI50GN+BzrHtMh/XhRs1m95u8ba5vO9065SqiL5LfACT3zxgVotbmqkhJ5VTuw+FJntSM+cICdkMOrnwWgx/wE3FNFdD2TIV3VBUqQI9MI278KdRliHq+CkAObQEhmswQtEMi8C9SgcgTsUcvglB4WT5w/0nB6p6t95UgvOGfFGTC3Ul7NzS6Dhe5/uh+SL9bF6du4oOtMXjSyCtazy0X8liJTAXrM2o+JjAgjuusrPcFZx9HA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(346002)(136003)(39860400002)(230922051799003)(64100799003)(1800799009)(82310400011)(186009)(451199024)(40470700004)(36840700001)(46966006)(6666004)(478600001)(7696005)(70206006)(70586007)(110136005)(26005)(16526019)(336012)(426003)(1076003)(2616005)(41300700001)(2906002)(316002)(4744005)(8676002)(4326008)(8936002)(54906003)(5660300002)(7416002)(36756003)(36860700001)(83380400001)(47076005)(81166007)(356005)(82740400003)(40460700003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:38:45.6497
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ebcc115-74af-441a-1546-08dbd912ddce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB71.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5863

For AMD SNP guests having Secure TSC enabled, skip using the kvmclock.
The guest kernel will fallback and use Secure TSC based clocksource.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index fb8f52149be9..779e7311fa6f 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -288,7 +288,7 @@ void __init kvmclock_init(void)
 {
 	u8 flags;
 
-	if (!kvm_para_available() || !kvmclock)
+	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
-- 
2.34.1


