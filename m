Return-Path: <kvm+bounces-4946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C541581A21A
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:20:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A37B1F21BE1
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A3347A6F;
	Wed, 20 Dec 2023 15:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ix0dwMoM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C799440BF3;
	Wed, 20 Dec 2023 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dulU5zm8zqla+R9iHTRy7kOmGfS8lvwtjl1Nmfgy7rsu8tqSN+dghr/kiBpVIVRyRSIO/HPtGAf+dalxzhRVskUb+yt/SjK+lB/XDQOr8T0n44Rj6lHq7TBI3l4zMX4Kac01uyEQwh2iGPRE4wbsacLZk+j5VqT6dDytODVbAOIa7Bb44ugmGQFwwJ69qRxXHqxt+LyJWYAyG4vrtikcWrDoRVVN5cLQTh6+LVTmjAhcpqEwudarUaRBHvueymKyplUTF4EczbCjaptbPX89GGBCq/NnVDbMVebSz8jVcRlADRN4nX48UJ/ljyQZo6X06/5pcB0NLHr71IvnsXXGkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CxuUj5hGtvUcLr+OZKSpkJejm8QgagWyrs/yKHPhDoQ=;
 b=jazJlIw1iuH2F+d7/0UG0ajrEqSsddS8vnzmbNFMVl0Y0Wp759zOHrhHiZmUSe/1iHp/kjcS4/6ZtJHKeEKBen3qDojX2LHhjXjYle1VtQbP73xB4yhD57Tyo5JKOpTceuctBOa22l0bYI1GDeqD57rDffm+EOJuCnXj9/ejhQ/TiXTPOctHwNoMq2XF9OXNKvbcBQ/11gXYTjMXaiCSb+iG+2GEB/1XJpNjL+9XiRomqrNfbu63n23ZBOY6BmKsnApew7cmAoaNAny0ZGg5yxIjc2ngN/qTvrwS6ZyPHUd/M2iTWL78CYHsqhTAE3k4GvTawGVYZzNDC59VbOWMww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CxuUj5hGtvUcLr+OZKSpkJejm8QgagWyrs/yKHPhDoQ=;
 b=Ix0dwMoMKfnPJhUncFXBr59Cez1+IcJnf6DQ9nNkb5w2a1qKg9XbGdIomi6ctwPK74RFamwH4Z7dXrOeX8k9jS652G1Jm12r2Ev/4ADfRDk244DNFqGsXzaaNg7/+/a8aMmoQ5/v74dGspDv0OFOMs6+YV/U7RuoIo97im4QYRo=
Received: from DM6PR05CA0050.namprd05.prod.outlook.com (2603:10b6:5:335::19)
 by BY5PR12MB4244.namprd12.prod.outlook.com (2603:10b6:a03:204::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18; Wed, 20 Dec
 2023 15:15:54 +0000
Received: from DS2PEPF0000343B.namprd02.prod.outlook.com
 (2603:10b6:5:335:cafe::fd) by DM6PR05CA0050.outlook.office365.com
 (2603:10b6:5:335::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.17 via Frontend
 Transport; Wed, 20 Dec 2023 15:15:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343B.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:15:54 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:15:50 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 11/16] x86/sev: Change TSC MSR behavior for Secure TSC enabled guests
Date: Wed, 20 Dec 2023 20:43:53 +0530
Message-ID: <20231220151358.2147066-12-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343B:EE_|BY5PR12MB4244:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ab5b957-ebac-47fa-6392-08dc016e8f78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	SiUNzyxpaAvN1KOH1pJY9Y9XfTwPpuG+Qawypo2xdlNXVTDiYyvXp6N9jqqtvpsgiTk1tb5snxTMx/9joF9hKjFD5nQmTukq0aOsOTGGLKZbdt4UHgNxWBYxTFZ45ugfhBwIqemPP0mSmGClG+MstLavrvd23U+zlaNhi2xjVl5XRZTTgH0NmIbCnbWv7eie04a6rrUDaQPAaKTm1Wz9scL7tZGNzXWJjozs9o/jFSuq7wCmtwNeBiP5h+Z4zkBg32AT/EtztrpL2hPj7phS/FkMkDJQKaDDAEbl0d3SdA01GtAqOkfQxN9yAjqA09aLA8efhxokqGq/7pYvo0ZqcpozFJ7MQu4fLzmwe+iDCaUBuxepPUgK4Sa1jKTQrvs/FYrrPAeTpKz/NupB6KktDrguA11GxkQOhXJrSh3bwPdXI695jrzaOyF/4+nEUZq24fNxTpM+FRPlQwCW61RFGYtwSwVBEjUhddohTXExevZe9IBYt10QYA6TCHir4XOm6CwcqzB8Rh1jbNFjfF0gEJy/eTLE2sNTN/1sgIF0WzXHTBtO4SRnCGu9olHiY0s9Y5cAMMaDxARBkFnWx/y/xNRky6st053sCjdGan0qeIzYAeNjbJyBZM4v9VDXKd6tJdxzn+95oaaW9HvCN9sk2Sa6lJj86RQ8lPnSeTbS39sqADeSFk+2oU9SMW5B/CMtkBBBBu6P2GOxVD0krx+O0lRYj8X+O/Mi7pmrn0yktOAocv7UjwdaT/FBHfMO+azw375m6U/ZIjYfUcbPeXi8Mg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(136003)(39860400002)(346002)(230922051799003)(82310400011)(1800799012)(64100799003)(186009)(451199024)(40470700004)(46966006)(36840700001)(1076003)(40480700001)(16526019)(478600001)(2616005)(336012)(426003)(316002)(54906003)(26005)(47076005)(40460700003)(8936002)(5660300002)(8676002)(4326008)(83380400001)(70586007)(70206006)(110136005)(36860700001)(7416002)(7696005)(2906002)(82740400003)(81166007)(356005)(41300700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:15:54.4048
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab5b957-ebac-47fa-6392-08dc016e8f78
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4244

Secure TSC enabled guests should not write MSR_IA32_TSC(10H) register
as the subsequent TSC value reads are undefined. MSR_IA32_TSC related
accesses should not exit to the hypervisor for such guests.

Accesses to MSR_IA32_TSC needs special handling in the #VC handler for
the guests with Secure TSC enabled. Writes to MSR_IA32_TSC should be
ignored, and reads of MSR_IA32_TSC should return the result of the
RDTSC instruction.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/sev.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 1d6200b57643..393d3be13934 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1280,6 +1280,30 @@ static enum es_result vc_handle_msr(struct ghcb *ghcb, struct es_em_ctxt *ctxt)
 	/* Is it a WRMSR? */
 	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
 
+	/*
+	 * TSC related accesses should not exit to the hypervisor when a
+	 * guest is executing with SecureTSC enabled, so special handling
+	 * is required for accesses of MSR_IA32_TSC:
+	 *
+	 * Writes: Writing to MSR_IA32_TSC can cause subsequent reads
+	 *         of the TSC to return undefined values, so ignore all
+	 *         writes.
+	 * Reads:  Reads of MSR_IA32_TSC should return the current TSC
+	 *         value, use the value returned by RDTSC.
+	 */
+	if (regs->cx == MSR_IA32_TSC && cpu_feature_enabled(X86_FEATURE_SNP_SECURE_TSC)) {
+		u64 tsc;
+
+		if (exit_info_1)
+			return ES_OK;
+
+		tsc = rdtsc();
+		regs->ax = UINT_MAX & tsc;
+		regs->dx = UINT_MAX & (tsc >> 32);
+
+		return ES_OK;
+	}
+
 	ghcb_set_rcx(ghcb, regs->cx);
 	if (exit_info_1) {
 		ghcb_set_rax(ghcb, regs->ax);
-- 
2.34.1


