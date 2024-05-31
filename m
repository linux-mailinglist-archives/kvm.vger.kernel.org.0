Return-Path: <kvm+bounces-18490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 080228D598A
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:38:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 74AC31F24B96
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:38:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2D16136E17;
	Fri, 31 May 2024 04:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="hhJHTjZO"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697E4187572;
	Fri, 31 May 2024 04:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717130098; cv=fail; b=J7Y/PwEdgBy/7j07wb4KG4L49oxUXqrwGOon9+RzoeIXSS61tGaNGzEevHQXW0xBLasrd+HY+aSiwy/msbnwPOJLLVUwG/SPY3BZ9aLPrvgIpei9ZBvn7BF4yU/7xcZRzZWU7i8ZYNU1AhmaAojTHplLgeFL1ZFo8c6fldUHJhA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717130098; c=relaxed/simple;
	bh=wjgsaMYeT1GD78TxdoMUeB43JDwnow8CRuB1a5G31SY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p3V3bot4ueScWZzSXLg3TzSDjr0fdGUj+FRFcSWy+JKql+nfO0t8pAXuW6J/DNjAgqb4Fu8W9dkqnlm23rjKrtp5UIGyPr+8TSQj8rx+ZFYisSRP98h5M4gRIZelnj0W8et/3RWZgiAKiAcS2davPkuGcmGh/Qv+9KzYtTnOs+w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=hhJHTjZO; arc=fail smtp.client-ip=40.107.220.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AI9XakDAJccOJtmrh6ibu5CuDsCEtx85uAYJJtQlmrHjCHSkZ6/KORSOV9mb1Up1F4iGd7O3Gbhns8XpPtb6tx7OCjBViYRavh0c26gX6ZjYdKLjF599X5wR3AzN4d7vsyJUw+d+MF07Y9IzFht5W+roduSqhfNYop+Sc9P9HIlUQNhFybb9+yyOiiLf2cfVHKP6/Du0tI8K4QgTWTDiN+xZTx9RxvSQkzr5Qh1eGBYx+imsA2H/Aw8Xa/A3kf2ssmML6IHptJBBC85Yy0fxiMYlqxVJGUdaqXbsC0TjfLOG5rdKNoR1J22qGvTWnjE4LEtP6kAAUBZoglhB6aWlNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UAaAbe3aro4EM2xBQdGp/o69Ah/mnZD76EyvwIMZKr0=;
 b=lzGnVYNlV3vKtV3sgvcKgcgleSuzke4Ov5G0lN4+3uZyvO7NZhAPSRotPrdHx3ME+4htsfq48sRArLAgkyXMF2gn5oMD62lWdTYhtAssovfVb1fG+s04JTnRgbTx4YIFYpQWz3pDhNwZw/vw2KQ6tV0CFDkn+z2fIV+zkfUYgXCLQABCWrtpmkXt8Qv4qiO/BGf7Mtbtg4wx4tZiZPEC49ieP78oQ9fsm5MESgi88ry2XgoVLOAWej0ZSbSX3CpbA62lLjlMfBrDSc3QzX4DlHFZTE0GOHCiR37/Pjo7jBlHC7wT2ncr56UOQekbCHNb/lyr5YhFqByCnRH0WVEJZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UAaAbe3aro4EM2xBQdGp/o69Ah/mnZD76EyvwIMZKr0=;
 b=hhJHTjZOPJ4M9uFVgC26T9YdfNr+I3hNJ/9qYfaX0G3ZToUtCe5RJ3h/R7uVOlKjjY0Kg8Ab7fnRbfLKBnobh1cq+dRyKy2JvzCFv5ksJ5j7daCwAaKh9gdUspDNEaQ2Y0Mg3BPZ06TMVSj2MBDPaydiqhbb8E4Gn//mozGO8+0=
Received: from DM6PR08CA0054.namprd08.prod.outlook.com (2603:10b6:5:1e0::28)
 by LV2PR12MB5893.namprd12.prod.outlook.com (2603:10b6:408:175::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.21; Fri, 31 May
 2024 04:34:50 +0000
Received: from DS3PEPF000099D7.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::a6) by DM6PR08CA0054.outlook.office365.com
 (2603:10b6:5:1e0::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Fri, 31 May 2024 04:34:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D7.mail.protection.outlook.com (10.167.17.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:34:50 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:34:46 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 21/24] x86/kvmclock: Skip kvmclock when Secure TSC is available
Date: Fri, 31 May 2024 10:00:35 +0530
Message-ID: <20240531043038.3370793-22-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D7:EE_|LV2PR12MB5893:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d9619f1-44d7-43d5-c642-08dc812b02ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|36860700004|7416005|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vMqFn3yiNJCkV1Gr1r+o8GqsAE3DJGcERatRsHP09qqqHfgtrdT5TYAzgkHe?=
 =?us-ascii?Q?uXV9UITW+6rlOEMcwvlovMweQ4vcOw8hjHsrBa/b3OT1IyW2v2W0NMTz24De?=
 =?us-ascii?Q?EJUTcqZYdGzz/PvGl+TSRHyo0X3oP6aHbJ+8sBJ35BT2ZWAHq7CuUt+SZW+C?=
 =?us-ascii?Q?pT0s2kousMFxCq8FHyqHXFpMTyeSZSHWyEjED62MVUF8tZM7PNZg31eN1xeQ?=
 =?us-ascii?Q?2NroQIEnqYkHfjl0Q+v91i2LgeXFpnMhEeEO8Xv93AaaQKi4dUkKr0IZ2+XH?=
 =?us-ascii?Q?/ZriWfmYQCEbmblyZty4Cjzv68o+P/oObVCLnZlcT0hibcKGxvoLocGhpv26?=
 =?us-ascii?Q?Z9ehTON2bsAQBZnTmRtXs9XXRb+KTRab0Mrf7WNrcte1Nuyr0qz2/2LPLg8L?=
 =?us-ascii?Q?fzQIRaAs1e9clux68dFMfZ27v2OX+R7496WD1/3tw0DYnojUOA6S8ubW29OZ?=
 =?us-ascii?Q?X7o4rKKtLj+dassR64Q2feNZL4uM9QwkPwQozFZyZ36sbUUOMzJelZspIXA0?=
 =?us-ascii?Q?6LQM+v5fJfRGQxwPkNagX24GsJosv+1BhtEieAlKFRrsO7Qvbas/3P1wDZ0+?=
 =?us-ascii?Q?KeYtkGb7YOzsxmXAhLGY5fwkqPeAU+FqvPGOt4SUjIjxp3VjacgiRxLYRdp0?=
 =?us-ascii?Q?MnLAy66rEkKMAWQmvxbtiRc+bV69FTNWjidyoBHi0D5vQkqbwqRgXI5j2cq2?=
 =?us-ascii?Q?XDCNGZaB21+FyOlXjdgDaggYGom8GvDqsanw8JA7U4UJTuh7lONvc2MRQCk6?=
 =?us-ascii?Q?iocXza19H2xjtbpbhHmTE3HzvM/2lFF/qjSOyuKyFs1N9fMN9iWuPzjHTcrX?=
 =?us-ascii?Q?we3ny8YPC7wENx3EJqRmmDIbhtpeXfc68xWkPOR9JEB7sHYm1Y/Bg+Vtfoow?=
 =?us-ascii?Q?SHzGlAX0CVBw7/d4bbYAa++PAmVwEm1JjjccMcW026/gsfz0bEP13OghGigD?=
 =?us-ascii?Q?nI2GmR/zvWPUkAwCkpvrI9/daJLTMgbGj0O8nsYMLWxfOycvvF7OxMLTBYk3?=
 =?us-ascii?Q?2f0Yi6qpOF0U+qP/xnrcJnN7YhnSRRhvOqGbOwqnEmp7EYks2FcQAs6wGebV?=
 =?us-ascii?Q?9l6Q26Crhqki9XvLvUL+zPojuQf1Cpfx8ORFSwvHlegr/NcG65/E+6SfsirM?=
 =?us-ascii?Q?K3NLkNVZumc39y63q9ZcbL/v3UVp1u5t5au2ugRm162BKz45gFxngqcY56fF?=
 =?us-ascii?Q?2eybTTO6A69ureBh8IfKxFeEVGnM8Cm8W6i7+IjvQJ1BjQfxNFIAIetfnE90?=
 =?us-ascii?Q?X/Dnr3YV2HZ32IfrFiyfmzLVOuJrfB8YSx8cJDmh2+L+d8//LBXZo5Pbn2tO?=
 =?us-ascii?Q?eQQJkmSQg/471s4vKh7ExeLEmcrICztpL6wSSyl7hLOkixWoLGGhOkS5W9BB?=
 =?us-ascii?Q?FZC4TIvOxDsuAS2k95SCubO3mr56?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(36860700004)(7416005)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:34:50.7571
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d9619f1-44d7-43d5-c642-08dc812b02ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D7.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5893

For AMD SNP guests having Secure TSC enabled, skip using the kvmclock.
The guest kernel will fallback and use Secure TSC based clocksource.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/kernel/kvmclock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/kvmclock.c b/arch/x86/kernel/kvmclock.c
index 5b2c15214a6b..3d03b4c937b9 100644
--- a/arch/x86/kernel/kvmclock.c
+++ b/arch/x86/kernel/kvmclock.c
@@ -289,7 +289,7 @@ void __init kvmclock_init(void)
 {
 	u8 flags;
 
-	if (!kvm_para_available() || !kvmclock)
+	if (!kvm_para_available() || !kvmclock || cc_platform_has(CC_ATTR_GUEST_SECURE_TSC))
 		return;
 
 	if (kvm_para_has_feature(KVM_FEATURE_CLOCKSOURCE2)) {
-- 
2.34.1


