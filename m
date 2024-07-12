Return-Path: <kvm+bounces-21497-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D21992F822
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 11:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A02BA1F23CC1
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C55DA15B141;
	Fri, 12 Jul 2024 09:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="D+a7phdk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6333314E2E9;
	Fri, 12 Jul 2024 09:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720777277; cv=fail; b=syQpDtoVbXcBvYM/i00Nu3/kMI04zYXKo6IZEZgxSDcKNCskJ6YhdMk1ExKzPMbF645RmIcOzs/xKjjqIrIrToTzIRa+tPPV22cUIKIryekoYcl6wMn9mvjrXyZqXSqR0VecD4tMHOQIxq3Xy6yZVP6RGU+lnNOH0Kb4uh1ZO2c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720777277; c=relaxed/simple;
	bh=ZJeYgHoE2heWABlyYrKq8jcm4ycRim7/NlsjXAcQkRI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Hu81DS7hTkt6wT0hlIncTGMUhGCP73Q5sO/nPLa7qK5/8ZpjUxUkj7j5k62n1mxUmmhD3OcEvN16N7HatHsX8eZk61b8iuIcytl6fY53CyR+Grr56BytgMmkn0GWxKMyLIHaLhk/sW3bl7JwwL0K9OZQBLGbkIRMk+7GUHlmAqs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=D+a7phdk; arc=fail smtp.client-ip=40.107.92.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qTfsoj5TM1tZ0PLymBuAcsdzpwawZOmqbGL33sfKB9sLUu/9jid3dHD9cmFhBLi6BJJiekw8M4BKQDpwo7PPi0s3GUs+NDi3mJw45K+420Nh9rfXfy5qP8D982U3zJkGB2oLIKPIVUy4SFnz/wTNcB92TSuAoXoeVY+hGAGT3MLw376tF0UXXBpiJoinzTEHzNJs/pO82wiEIDnC7d390FWsvTYkbtJYn+VTpTxt2WgjkNaYS25KCZxL0rS5MUYkbg0B6mnwVcfVQ2CavRfv5zXY+Gwd1TsC8/acIJYV3ktnTSrmGufx2WwbrhNFvMInymSQWgPEQqFdchEjMF3AUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2VRfcUMaTK1uUwOjU23QxEqD/e9C7IWLvN7ZICcxKec=;
 b=fWO5A7ZVy1E88sfb5Er/8FaHU5i8HStqlLYNYWI/1lnO7+XORAw4FLtL186WqWUOJtLK3nGg2UTf1bXh6Fl2mn9qoaaMicHj50UerGbVftSnY951yR8PQ4QY/sXVZ+KP3kuSXqfO5ScHIO9DuyWFc6AjbINJDHxrBu214jkb4W8IsdXVMWq938gKXbP3Zo3ZppisxxSpuqghY7Y3W6rSfJauUMf7a2knj3x5n9763XflHSeeU3tVp63j+QepXRf9d50xY/Kfaz78+7v//hYrIfT7Xb8t9gJbyLjQqH9Mm5DTEZm2hQowxMY0BlUc785s+xBNkd5d2h83SDnGnPor2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VRfcUMaTK1uUwOjU23QxEqD/e9C7IWLvN7ZICcxKec=;
 b=D+a7phdkLoehmIIyeLjlOQLa5zJB2ir6IRthfy5ERad9DYldjHvf14fW+Sw2Iy6SeP2KzVC86GRv/aNut8Lcz3QKUM+mFVHFq3o5rfDPZe+rsITQbDkw4/Pe5sup9IDd05VaHYi8hl4Joo1h1s8ysfUaaSkEDHQ0doa6Yt8olaE=
Received: from CH0PR03CA0442.namprd03.prod.outlook.com (2603:10b6:610:10e::32)
 by DM4PR12MB7669.namprd12.prod.outlook.com (2603:10b6:8:106::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.20; Fri, 12 Jul
 2024 09:41:12 +0000
Received: from DS3PEPF0000C37A.namprd04.prod.outlook.com
 (2603:10b6:610:10e:cafe::87) by CH0PR03CA0442.outlook.office365.com
 (2603:10b6:610:10e::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Fri, 12 Jul 2024 09:41:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37A.mail.protection.outlook.com (10.167.23.4) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.17 via Frontend Transport; Fri, 12 Jul 2024 09:41:11 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 12 Jul
 2024 04:41:03 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>, <manali.shukla@amd.com>,
	<jmattson@google.com>
Subject: [PATCH v2 2/4] x86/bus_lock: Add support for AMD
Date: Fri, 12 Jul 2024 09:39:41 +0000
Message-ID: <20240712093943.1288-3-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240712093943.1288-1-ravi.bangoria@amd.com>
References: <20240712093943.1288-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37A:EE_|DM4PR12MB7669:EE_
X-MS-Office365-Filtering-Correlation-Id: b57664f6-0712-452b-0037-08dca256c3ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tmAZyTptNRAutLAkOmJJ8Wo9NqixJf3As0Uaytx2LnCWcw6usnA7pzZ/kDV5?=
 =?us-ascii?Q?m0CJNVO1gfKT+2eef+uKhGCDn3NM37cqyfbC5+vlQAkAW/dK9Gpv6ST44+9X?=
 =?us-ascii?Q?yjNdZEhktYoGXp0KeUU21a8IuTLZ6E70gbHMwDkUIxguNZm8Va/ksU/A2Ito?=
 =?us-ascii?Q?V6GB+EMiYaGLOFGG8lCNRHFjMGubOXMm9bVbZV4Jr+IXQJ9kgOLiDabIsWML?=
 =?us-ascii?Q?QUK88J2Ywm4ClvLBY3Adm3OrM1jEusOEWICVqBqsAzLYuFK+0cCfPgs3rTcz?=
 =?us-ascii?Q?uR7p5zTHR0+VGyYWGo1giN0uQhlDCli1ufl3D9xuxW0rBJpx+oeDmqoGg490?=
 =?us-ascii?Q?wuJiH5bRSkYMkZmfYDy6SDEO8ZYuI21Qs0HTGg9sKQewaAKUX/Ah3LSJPI4P?=
 =?us-ascii?Q?FILLfh2pRL/GcmrKY/cVGCdvbnnsu6q58dsabZvwqWZbhfrPoThKZmRRhrXQ?=
 =?us-ascii?Q?sg7/kC7WcEPw9TKmjR9JQYAIJ+FrwGDJCH7nTW3MW/ygZn2M48fQKokn/mk0?=
 =?us-ascii?Q?8k5VqSl2SOCmxkyzjIk0+z4UuwVicC/mVuQNQJREsopt6tYK2w7C8pBoJM0a?=
 =?us-ascii?Q?X4/UEjqlhMcjX8huRm4cFk3hU+bbdolxlm6pK1/x4dJx9jSk0eMTqx7FQb9u?=
 =?us-ascii?Q?PB5fdSqR4iARhd9qEZPbeVkP8dwu90taW/HApmH/bmnHOlRd4xALeYTiIHhx?=
 =?us-ascii?Q?95mYqKce2/vRQROWGUS+dKl91uvNZ+kmYHotVwDSbyxXLNftGizncTo2O38A?=
 =?us-ascii?Q?uvJ1jtdQGPi8HXg+iDw4yd0O8zpBojuaE6AQvDElXO4+493ZsGBIkC4jfqm3?=
 =?us-ascii?Q?KeUTcM6q86C2TkTSYpxV7hxzVrYXQG9tLqfvNGNmbKCUDU0sbXTWhI9bWFAF?=
 =?us-ascii?Q?70N8Bpj8A3WtjS1kHrPNC6ikwY7TA0k6hN0EFRC7S0Nm7f5ss4rjTx3fsciI?=
 =?us-ascii?Q?LzHCOqYoqp8tEuAeV6eQzbiTRwoc9RTK0qy7ZMCqraax3Ov2+VD5vq/Qye95?=
 =?us-ascii?Q?8RZbUNiOr5OD7HKgNQ8eKEAtGCB4h8Jv+uc3QUCUKE1VwIH3TL86Q454GrJU?=
 =?us-ascii?Q?Rq+jiMER4dhj7c3i2TmVX47zuto8ohZJRawHPPIG3WD9pDv+2J3ZTIM06pzu?=
 =?us-ascii?Q?oAUbJa4Q0ezssz81A89g6/Vz+Gsm6TcBQqK7GQyTJRVO9RKGFl+/nMM5Moov?=
 =?us-ascii?Q?jAcdViZX4WCQDJB3TXp2hK0u1aHifK9vilAAPHh1Og4b07x5JdkHZePnCmqs?=
 =?us-ascii?Q?iT57PpmgLEdjJQfvRwoONAPPP3CYyGXDdpZZGLZj+nwqwCRT4oZ22a9XVvK0?=
 =?us-ascii?Q?gCJ6/rA/Y5XMOp80qmSRIQxfR2UpdkG0AZ21bnkdcZ2YjMFtgN2nOlXSAu8f?=
 =?us-ascii?Q?m4gBTW4UOQQHZzqHjvzmc7nVY8G5?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 09:41:11.6584
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b57664f6-0712-452b-0037-08dca256c3ec
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37A.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7669

Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
in AMD docs). Add support for the same in Linux. Bus Lock Detect is
enumerated with cpuid CPUID Fn0000_0007_ECX_x0 bit [24 / BUSLOCKTRAP].
It can be enabled through MSR_IA32_DEBUGCTLMSR. When enabled, hardware
clears DR6[11] and raises a #DB exception on occurrence of Bus Lock if
CPL > 0. More detail about the feature can be found in AMD APM[1].

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
---
 arch/x86/kernel/cpu/common.c | 2 ++
 arch/x86/kernel/cpu/intel.c  | 1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index d4e539d4e158..a37670e1ab4d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1832,6 +1832,8 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 	if (this_cpu->c_init)
 		this_cpu->c_init(c);
 
+	bus_lock_init();
+
 	/* Disable the PN if appropriate */
 	squash_the_stupid_serial_number(c);
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8a483f4ad026..799f18545c6e 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -610,7 +610,6 @@ static void init_intel(struct cpuinfo_x86 *c)
 	init_intel_misc_features(c);
 
 	split_lock_init();
-	bus_lock_init();
 
 	intel_init_thermal(c);
 }
-- 
2.34.1


