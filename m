Return-Path: <kvm+bounces-46-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D44A7DB38D
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:38:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5D4C281449
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:38:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A95678F68;
	Mon, 30 Oct 2023 06:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="au4RSatn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E6C6AB1
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:38:34 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAD41B5;
	Sun, 29 Oct 2023 23:38:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwwZNNj06xZkCeqAr8c+EjzqM9WVDMkfgdBH4J50hYiqgUx3zOm2ihmVQrf+cwHPxOdGsPzzNfHXuuMoimjfyVlXzHqGMJipG31iFCuUCvlQxWoQzyW3UpPEAHQzxfztabTWrsSJXMJP2cwomLDPyS56Tw+Kxr7vtH34ehifWE1AZsUO1BfQToNqhFEQ0FYqVIUja8zWWJEqZj93rS1DYql9+LEiE37+w9u/a3BQldCWOC8YLQJJ1T67OZLOkJGn2LUuRlYo7e+8arNV+Us6RWmqD7Zjyy3GGjmoxzw+yffMG0jygYo/cgblpsbV/Um1xduzDukARQTCm8HNAkhJaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=alWiO7A6Ev8LgO0RcGXnJcSlOO89CqQ5UkCTINWWERY=;
 b=CV1JXtmRXMxwo1FvWbbbw9/0GmZIWNkNc1/AjFy4nk7Bgw0PXevRdNBl543dgW6JuQll5C/ajbW5tfvqLmnjeti+M4lGuB/Q7iVbAlTe82Ge4eN06NXNx4C4BD694Ar7Gyu6LO9L/V7GMFAV5Zf38DdwZuUqMx9ltT944j0b41bO8tgNm5OLmepxdhJs7jSB2W/2dHMVjfLOLWzfq3vTK79MT91I1F3tfolJa45PtB8hSAlg8gN6bX7oqZu+kgS29jAZkTT3WN2fDInLyoVWiBSvuqdTE+I4f1yQI2oPnXY3HjxIuuSOClIZtbMAXAHKmCY1HZ2L6STnpcihsQRrIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=alWiO7A6Ev8LgO0RcGXnJcSlOO89CqQ5UkCTINWWERY=;
 b=au4RSatnctp+vv7xqyT/2umAho7T7Y5raUu3tup063t/CiNUeV7G1HCbNtzyYtDn6dXzeDO9d0JeqUD7UpRy6VciKqjr+AH5/Bgpic9QCq5MsTQaXzE6X1TAvR/rbMbqJjm/ntLIrt1xlqscsme0l0wiDxJm974VZU8NSrFqSq8=
Received: from MN2PR20CA0041.namprd20.prod.outlook.com (2603:10b6:208:235::10)
 by DM4PR12MB5795.namprd12.prod.outlook.com (2603:10b6:8:62::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.27; Mon, 30 Oct 2023 06:38:28 +0000
Received: from BL6PEPF0001AB73.namprd02.prod.outlook.com
 (2603:10b6:208:235:cafe::b9) by MN2PR20CA0041.outlook.office365.com
 (2603:10b6:208:235::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28 via Frontend
 Transport; Mon, 30 Oct 2023 06:38:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB73.mail.protection.outlook.com (10.167.242.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.22 via Frontend Transport; Mon, 30 Oct 2023 06:38:28 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:38:24 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 08/14] x86/mm: Add generic guest initialization hook
Date: Mon, 30 Oct 2023 12:06:46 +0530
Message-ID: <20231030063652.68675-9-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB73:EE_|DM4PR12MB5795:EE_
X-MS-Office365-Filtering-Correlation-Id: 720eea35-55da-4c42-b6eb-08dbd912d375
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	w28it64YdJQ7VfX4o358WPJKd1Zw/y7iUODJOEoMjIJW15IdIfU0gXaqDUDe+/Cqx0m8DYqAn12eVKLbvji6vJeOluVCjkV540gRo6qb9rH7Du+ln89LXrN8Yrj8P6Ys55MVK6acSoH4uG8jpk1WNtCAkt2xDkrZHqvtDikiYM0ZxaBE4JoTa5OzB45VsvZ9zFv7yO9IQ+/6hGblIMeE+hm8yDt9ZLRZENXGQx4d3yfEJAV5NLaemhji/Y5L2j1/wbWNoQa5v2q64o20ULYKj1bR+c4YcjLroAXP/fkCQbOWIMXeoMsPBYXhxWVrmwhW8NDcHzcE+DR0wJF3PA1cU1NMN+/zPjNsEA/bwojdLF/xDACDnX4xZE/P7uJCf/8M57Mw47QfFwu5ugN8f3BVrhhlLveSz1EtUqRnC1cySywaoI0loFgr8JgH5WNH3u0Lt04gMD/SrS1D6lQtD5QzOj2kkIRBywHwOjs7D/Tv52N5l2Sq09EZrBNAwmtD++xLNTewss+k/TYc8+SiK5W7c5uFAp3K64hJYM95gcd9KhZLLfiKf4iPGH3pFdT7n6ePQX7jlwdXdWRYRawTXR0+1SbXkQ37TEs654ajKDLuCADcj8cykRcjoN942MdhSxcafkCzBRWXS3kFazZf3qt2r41xSxJNCfFK1KZ2B7eE81UULKXYTYiHhnhHbY3bzRe256aV5JLX1AmBoOkA1qCtcpd4vV+0ZNggTBx9Ww1nj4k8AnLwU9zSJ1W+rS9l5qINHl1Wpg6fkhRcusmRsU9qsKspkkT/JOi6cu1QBRejQoM=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(346002)(376002)(136003)(230922051799003)(451199024)(64100799003)(1800799009)(186009)(82310400011)(40470700004)(46966006)(36840700001)(2906002)(40460700003)(36860700001)(110136005)(54906003)(70206006)(70586007)(47076005)(81166007)(356005)(82740400003)(316002)(7696005)(26005)(6666004)(478600001)(83380400001)(2616005)(16526019)(1076003)(426003)(336012)(41300700001)(7416002)(5660300002)(8936002)(8676002)(4326008)(40480700001)(36756003)(41533002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:38:28.2934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 720eea35-55da-4c42-b6eb-08dbd912d375
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB73.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5795

Add generic enc_init guest hook for performing any type of
initialization that is vendor specific.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/x86_init.h | 2 ++
 arch/x86/kernel/x86_init.c      | 2 ++
 arch/x86/mm/mem_encrypt.c       | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 5240d88db52a..6a08dcd1f3c4 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -148,12 +148,14 @@ struct x86_init_acpi {
  * @enc_status_change_finish	Notify HV after the encryption status of a range is changed
  * @enc_tlb_flush_required	Returns true if a TLB flush is needed before changing page encryption status
  * @enc_cache_flush_required	Returns true if a cache flush is needed before changing page encryption status
+ * @enc_init			Prepare and initialize encryption features
  */
 struct x86_guest {
 	bool (*enc_status_change_prepare)(unsigned long vaddr, int npages, bool enc);
 	bool (*enc_status_change_finish)(unsigned long vaddr, int npages, bool enc);
 	bool (*enc_tlb_flush_required)(bool enc);
 	bool (*enc_cache_flush_required)(void);
+	void (*enc_init)(void);
 };
 
 /**
diff --git a/arch/x86/kernel/x86_init.c b/arch/x86/kernel/x86_init.c
index a37ebd3b4773..a07985a96ca5 100644
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@ -136,6 +136,7 @@ static bool enc_status_change_finish_noop(unsigned long vaddr, int npages, bool
 static bool enc_tlb_flush_required_noop(bool enc) { return false; }
 static bool enc_cache_flush_required_noop(void) { return false; }
 static bool is_private_mmio_noop(u64 addr) {return false; }
+static void enc_init_noop(void) { }
 
 struct x86_platform_ops x86_platform __ro_after_init = {
 	.calibrate_cpu			= native_calibrate_cpu_early,
@@ -158,6 +159,7 @@ struct x86_platform_ops x86_platform __ro_after_init = {
 		.enc_status_change_finish  = enc_status_change_finish_noop,
 		.enc_tlb_flush_required	   = enc_tlb_flush_required_noop,
 		.enc_cache_flush_required  = enc_cache_flush_required_noop,
+		.enc_init		   = enc_init_noop,
 	},
 };
 
diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 9f27e14e185f..01abecc9a774 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -84,5 +84,8 @@ void __init mem_encrypt_init(void)
 	/* Call into SWIOTLB to update the SWIOTLB DMA buffers */
 	swiotlb_update_mem_attributes();
 
+	if (x86_platform.guest.enc_init)
+		x86_platform.guest.enc_init();
+
 	print_mem_encrypt_feature_info();
 }
-- 
2.34.1


