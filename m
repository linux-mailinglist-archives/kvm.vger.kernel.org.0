Return-Path: <kvm+bounces-7076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2643483D3C9
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 05:51:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3D3128CDC3
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 04:51:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0B60C139;
	Fri, 26 Jan 2024 04:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tkqtAq22"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2056.outbound.protection.outlook.com [40.107.244.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259E134B5;
	Fri, 26 Jan 2024 04:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706244565; cv=fail; b=OGcj0zdE/j9UlTiiHWPzLy0evQRst9UdRLSGaP5tEjxq0mj8JNZcjAEnWsRpcmTbES0etFmBHTrIQpsSS5psWwJnfCbvUTwYQDApmwQ9Oo+w3nSa8tkzoxuszuxTRQlOiUmST+5DQpypW1VovLhbgVX1jKwpNg4uHPlabyXheL8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706244565; c=relaxed/simple;
	bh=qmd0HiFjl6AgJdoM8m7Xoo3YL2eJ2Q7Q9E5NaKQQn8E=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FsLQ4ajUEj2H1j4O12WvcSKGkybuLltZXrEGvvAKZYbq4cG4ws89zTWkz9qMGXe5ap0x/f1kbowvVd6SVVBCfivbMyTyKjenKy7iv/5/5rWp9BqO7/AHVRz24cod5aZPaTsuRtZHT/HYVfqyS03KxRRkHs07im1o638hdu6E9sE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tkqtAq22; arc=fail smtp.client-ip=40.107.244.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=as2DK2Bfajk95Lg0jcbXcWM8yXeMmXNwYy5xj9qcrO07OWxS9uHMcZdgboZHY/QiEMjnUUXSVMk3SsuxubPGXT4ikoWuhXNzL52WHLQCy+i+QAI6lNx6jJMK/+d1iLogM0h2YVTPxIjmC1TH2jpxLJ2lREvwLIhq59lU0Xiw1QvJvmltZwXsSrbSLOXFp98/Q6tv6QajGH2mN0Z13NEhPKHgp7RevsYTv6JsDupXqrtTQNotoSFQAE85yWXp9T2YWyWUjP5ogo9A6lMqdYuoMRQAUg1bB+KaNIo82KE2Bp2sqdWhaqei7rrSm2XKfH2bVVvoZ5CBE0IjsU9olsp57A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3U3JEpITMWrdJUCfljL+TeerAiuU7ufrDQlHJ3pkGqI=;
 b=jlsDZ89QTE3Ca71M7pcDugcg3MOYVtUJELp3u687xd+XAqROX3J6V7B8juFc2ztutc/dcInvZiSbtk6Rbi6ymgDQvZud4+QynlOJ08m2Q0fNQ5odXnjo6q2edYvYH1DxyRVTUebdPGwmZZcAZX7mQk/FGZxIlQyS0/GsJU6jTxaR1zn5O9ca+31U3vaLig6vI8MohgYeJhAqmGWQhW9xZHsC/EMc2Vsw14iAghgJpqQiFLrUEftJ3vkonrHBhLSuyJGwbL7WoGyVl3nF4eSqUj4A1xURGSoFXaiLn5yVwONxnlP+s2v/HKVuY21T6OXtOngIiiYoHgpj0I6pVk03uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3U3JEpITMWrdJUCfljL+TeerAiuU7ufrDQlHJ3pkGqI=;
 b=tkqtAq22rRfxOOf6dhvzdxc4kK1pXOStAtMkFGUfvf7XU2rfJxvcPcJu0ldQKTeElET5IhHc0T9mzyoGmPvEXfzLovU+rZB6tjDwUwhcIXhtnLbuoP1or1YqVPR+K1mArVqFGNwFcc7oPrTk0ZRREHKHYhdyBjDTrqZqkXahaKs=
Received: from CH5PR02CA0001.namprd02.prod.outlook.com (2603:10b6:610:1ed::17)
 by DM4PR12MB5152.namprd12.prod.outlook.com (2603:10b6:5:393::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 04:49:18 +0000
Received: from DS2PEPF00003440.namprd02.prod.outlook.com
 (2603:10b6:610:1ed:cafe::c9) by CH5PR02CA0001.outlook.office365.com
 (2603:10b6:610:1ed::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27 via Frontend
 Transport; Fri, 26 Jan 2024 04:49:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003440.mail.protection.outlook.com (10.167.18.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7228.16 via Frontend Transport; Fri, 26 Jan 2024 04:49:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Thu, 25 Jan
 2024 22:49:14 -0600
From: Michael Roth <michael.roth@amd.com>
To: <x86@kernel.org>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v2 08/25] x86/traps: Define RMP violation #PF error code
Date: Thu, 25 Jan 2024 22:11:08 -0600
Message-ID: <20240126041126.1927228-9-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240126041126.1927228-1-michael.roth@amd.com>
References: <20240126041126.1927228-1-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF00003440:EE_|DM4PR12MB5152:EE_
X-MS-Office365-Filtering-Correlation-Id: 6473a4cb-ba7d-4781-7266-08dc1e2a27b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	EMlA1XpWP772hJ+SIi8tdaA8NpZT4Q/4+zomJ+PnNHgCfBRXcb5myQ/MfxYziLCilGju1KYixxBhtl1yBxFWwj50ToqUSDXXkVxlyPbk2pUU8zU5C23T8Uq5Xm8H++HHRJz8jw/7RkKpvH24KqYpFkPLttLM/bikHVm1v7x58CWJPy3JZtUTlyYRpagWlYuvahPqQnboHKpr62kCikhRx90BVZ5pl03TSYjku83faJOE9L0QJsJ5Zcmky/qA0h0M9JY28PPOOJcoQFLW73Hixo93nWPQDs5R+BFiygCBe0chwXIXH5BiBb63I8040HzusKahKKAudQZurGl8b6IiHzhWIY9Wvdr5+TrXNPFWk/zG0rxhRDlMmd+cc73TkBZd0dH1A46ISsB7/kvD3YWOk5zOW8FHpVe00jvAEUZzvSNTCm/urPKZ0BZNFdWbI6V/yIdYHmFrfBapcOTDbKd1kp8mkFXd8H1RzN5aGPdzZqANV+saMNwZ9JO5kqLfKxiOdErnUDL+pKRPUouLeEfTXCWwv0rylqGQo2YeoYqohfckfTI8ddSmSZQXnWg1WVbPGx0iKLZY49fg4QVGm8VeBZO6uFE8HQK63yLMtS+pbbfBF4N2I7/5HJPA3dgwrKKC2OAUVmp0+PVXgWTID3jDWk5H3QB3XLkR/m+KMkzzv62zkYpoWieCyI0Dci2a5yTX/0xl9OEtgyS1Yzwa54cQAPtMzlQ1ecFJYq45GZMyiSQ8PCUkuTQynuqFF+vrf5N081Nqo9qa12pUZ6PaMLt9tA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(39860400002)(396003)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(82310400011)(36840700001)(40470700004)(46966006)(26005)(16526019)(2616005)(1076003)(6666004)(83380400001)(336012)(426003)(8936002)(8676002)(4326008)(44832011)(5660300002)(478600001)(6916009)(54906003)(316002)(70206006)(70586007)(86362001)(356005)(36860700001)(82740400003)(81166007)(47076005)(41300700001)(7416002)(40480700001)(40460700003)(36756003)(2906002)(7406005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 04:49:18.2714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6473a4cb-ba7d-4781-7266-08dc1e2a27b6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003440.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5152

From: Brijesh Singh <brijesh.singh@amd.com>

Bit 31 in the page fault-error bit will be set when processor encounters
an RMP violation.

While at it, use the BIT() macro.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off by: Ashish Kalra <ashish.kalra@amd.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/include/asm/trap_pf.h | 20 ++++++++++++--------
 arch/x86/mm/fault.c            |  1 +
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/trap_pf.h b/arch/x86/include/asm/trap_pf.h
index afa524325e55..7fc4db774dd6 100644
--- a/arch/x86/include/asm/trap_pf.h
+++ b/arch/x86/include/asm/trap_pf.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_TRAP_PF_H
 #define _ASM_X86_TRAP_PF_H
 
+#include <linux/bits.h>  /* BIT() macro */
+
 /*
  * Page fault error code bits:
  *
@@ -13,16 +15,18 @@
  *   bit 5 ==				1: protection keys block access
  *   bit 6 ==				1: shadow stack access fault
  *   bit 15 ==				1: SGX MMU page-fault
+ *   bit 31 ==				1: fault was due to RMP violation
  */
 enum x86_pf_error_code {
-	X86_PF_PROT	=		1 << 0,
-	X86_PF_WRITE	=		1 << 1,
-	X86_PF_USER	=		1 << 2,
-	X86_PF_RSVD	=		1 << 3,
-	X86_PF_INSTR	=		1 << 4,
-	X86_PF_PK	=		1 << 5,
-	X86_PF_SHSTK	=		1 << 6,
-	X86_PF_SGX	=		1 << 15,
+	X86_PF_PROT	=		BIT(0),
+	X86_PF_WRITE	=		BIT(1),
+	X86_PF_USER	=		BIT(2),
+	X86_PF_RSVD	=		BIT(3),
+	X86_PF_INSTR	=		BIT(4),
+	X86_PF_PK	=		BIT(5),
+	X86_PF_SHSTK	=		BIT(6),
+	X86_PF_SGX	=		BIT(15),
+	X86_PF_RMP	=		BIT(31),
 };
 
 #endif /* _ASM_X86_TRAP_PF_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 679b09cfe241..8805e2e20df6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -547,6 +547,7 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code, unsigned long ad
 		 !(error_code & X86_PF_PROT) ? "not-present page" :
 		 (error_code & X86_PF_RSVD)  ? "reserved bit violation" :
 		 (error_code & X86_PF_PK)    ? "protection keys violation" :
+		 (error_code & X86_PF_RMP)   ? "RMP violation" :
 					       "permissions violation");
 
 	if (!(error_code & X86_PF_USER) && user_mode(regs)) {
-- 
2.25.1


