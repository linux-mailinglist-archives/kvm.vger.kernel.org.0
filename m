Return-Path: <kvm+bounces-16135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E42DA8B50F7
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 08:07:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id ECD38B216D0
	for <lists+kvm@lfdr.de>; Mon, 29 Apr 2024 06:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CF1111A5;
	Mon, 29 Apr 2024 06:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AWr+lnqo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64881118E;
	Mon, 29 Apr 2024 06:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714370832; cv=fail; b=LZQBI3XBWvRNEy8l2Q9B6/BB1FT0m2AGuJSbJpWm9iKFssRWhMxN3ZLWeffoBD8tYpIyCzhyh0Nco54p2b595J5TfRJgIIdA3S57Gdvfyixz/VMsYgpeLR8+uLDwkMV4rY0WFrIXUOxpT6/ggQO7Stnn+jBzGjszqumIME5VFHk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714370832; c=relaxed/simple;
	bh=+zOTj0NEnYB/z5AGERqCslJaBpgdpwL7oSfWRuUYLUQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Url8jdllYr98F15+geE2Ec3tqKyBmbqAcszyEscFpCWuul/KnXE7G/9/GEkKYO2YOsJxOUyueFshG5rl7FhkxiFV/3Ln3nIPfljEmwORTejMSDN9UkF2YYhaEK+e1maT6cABA+U2kB+S8veAaTJm6TC2kKfgghPggEOoemEUS/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AWr+lnqo; arc=fail smtp.client-ip=40.107.243.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1luz2VNwHTGp3aAwD0n5Sd+hTWrWAaZJdViH9dPdDSorCBQFFLkzDCueREFDOk3R872A/bsaWwowY4mmzZViQMxKidOD8qQ+SS616UuWeyGTJeastQnF9Zdlx6JcAlNyTIOwE3fmy1IPFXE8yxQZngyaaBfBDvtQi4dzpeUPbWhgbJnITXNTjhKzhI244n3FsH5c756mo2nRtyE7/BtJedXU6s4PpuYD+APCjlc/uDYkQOB0xJ7Hp3QcNS41YxH0fhlPr/SLul4ow0addsWHClVNYj77MUnP5QvG7LHtaY/6CVGnh2P9vta3TzPuSWGi9ucXe8LbQObtKKSCyRrNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JGIZWMNHfQBigxUt6Q67X+tErMKpYpAJE1kKOlS9iFE=;
 b=a6COBK6dfckYWvbnMFvm3amqlR9wDB4A3i/zqfdliW+qXI/Z+DfTnXm5v2HIOdGDz9x1pRFyocxROkOy3smMtKiEoOgxtWcQHWe5Uww44ZueiBWlQrA7/y1JvAFY5S6ePKzHbiW81Kcr7G0OFTmH5chv9IW6MxPuDTVpuATRtZ+cTgOXyYLyp40Dhx8e+1yf1Mzo7HuEE9d1cKbwJ7IPu2+yLqkwoYjI5GsD1p3MeWTpbC2A14AiPYRZaSTfrIB+mwF2RKo3FZwOAA5vEWx+xunTeSzqiN7K0hVCqHRHNyrrTwQ+bWZFCP2kUXTMi2SAL2o51ELQGqKZc+lZ7GGHvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JGIZWMNHfQBigxUt6Q67X+tErMKpYpAJE1kKOlS9iFE=;
 b=AWr+lnqotNmc19dx+MuTDn///u0P12nQyBnaZwKfkA86R1HkAzWuYbRWY4LW4F7jF+WH8XmkJlDEB2lX5Nswx4GLyPHHyeHLV3MQ3r7uMQ/FcXkj0f2L7G5RxvENGGk8jPlgJb67NuhFCpcdq+H/wHNIVZj82rxJ7dWjWDzCeMQ=
Received: from CH2PR14CA0046.namprd14.prod.outlook.com (2603:10b6:610:56::26)
 by LV2PR12MB5824.namprd12.prod.outlook.com (2603:10b6:408:176::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.34; Mon, 29 Apr
 2024 06:07:08 +0000
Received: from CH2PEPF00000148.namprd02.prod.outlook.com
 (2603:10b6:610:56:cafe::f0) by CH2PR14CA0046.outlook.office365.com
 (2603:10b6:610:56::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7339.38 via Frontend
 Transport; Mon, 29 Apr 2024 06:07:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000148.mail.protection.outlook.com (10.167.244.105) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Mon, 29 Apr 2024 06:07:08 +0000
Received: from BLR-5CG113396H.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 29 Apr
 2024 01:06:57 -0500
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
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>
Subject: [PATCH 0/3] x86/cpu: Add Bus Lock Detect support for AMD
Date: Mon, 29 Apr 2024 11:36:40 +0530
Message-ID: <20240429060643.211-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.34.1
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
X-MS-TrafficTypeDiagnostic: CH2PEPF00000148:EE_|LV2PR12MB5824:EE_
X-MS-Office365-Filtering-Correlation-Id: 573c6836-eb55-4b2e-1362-08dc68129a01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|376005|7416005|1800799015|82310400014|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F4wnNPMA+7LOwlD1VggdBPg0UtxxbdHpNzLuZegwK+kccNM+YGdCgpa+8z17?=
 =?us-ascii?Q?EOnNEV8JJwec8B1z8pcyAO9E4HNUkk0vkWrm4rHvX+GoDrOTGU+nfH8Jui0d?=
 =?us-ascii?Q?vaNnbojh2wkbaQy1JRfpyEQfe1V5o/CjHrd8AZLgxycrca0TLaPaRW3LUhGI?=
 =?us-ascii?Q?88jcBpD/Q5SpJxirEerW9jdYu9SRTtO60NVnmvhlDLpmhqFuaPNFKfzmiE2L?=
 =?us-ascii?Q?YPvYK8k1cThwutKlDND3OsPhBbZzJG3i2Jv/ktb4X3HTWaww8e7ywkVUpQRQ?=
 =?us-ascii?Q?5whHGp0dNPUFU9BcSDrBubmj6T1R1L0io7siqtzRJEe1B50uXDyxeWdiA4EA?=
 =?us-ascii?Q?BgqOfCFHRcl43xIgv5llEiPY1s2DITjzzxn+pePm28TUEQvKRrEedbOmPf10?=
 =?us-ascii?Q?LReJATBs4TKv1a7Z7WcCL6Xq9qFj43CBUqg0n+l4OmhTGQUKC18ADAa4hOqX?=
 =?us-ascii?Q?naO/QkflI3FbPFH2abjk57I2keUrkRTAsmvsli7g8MtP/O+8z2Dl9zcwmaFR?=
 =?us-ascii?Q?t+1eP3l5BEw7A2u/PYMJZnxlG6qbHt5q3RXtUd8oMAB1u8NnUD/+BE+XEWsC?=
 =?us-ascii?Q?zTJs3ThK4gnZntj9J3pnTNEjXqnHJtgQ/Pbdvn8b2u0zIthPcDvlGCvggGj6?=
 =?us-ascii?Q?aYOAX3GOt48/O1OU+tizR9YsMmKUPLnwmxylcd9QTbaFmbPkrr5OBcR0Rjv1?=
 =?us-ascii?Q?A8ZExAm00/mOUfXm33R9qfZJdmWcmGBbCl4bw0WZmm4NHroIBYevP5KLoc1d?=
 =?us-ascii?Q?42zIbEwGEhxyEzwrbaExq+3aEcxa2I+bolScY4AFJ+kni3gND38iyctFkBNb?=
 =?us-ascii?Q?+anZ04Iy6SvNHTbetdokuSPhaQ3H0YnrtaiN8TH4x6rqjF4lR6vsTTrbxCOP?=
 =?us-ascii?Q?3otXtwDGbaCN2xoZgT82sBDCYUcS/1x3QC/Im4bKTh06XWfdhBT8YgjX3ayB?=
 =?us-ascii?Q?6OKMZDprMivAUAEVAmleOlBh6Z70okDpB1izyIGdSQ2HvJ62aYWOIIjkOF0v?=
 =?us-ascii?Q?KzcbJ+3I3lexMp0zj+s70Q3pTB3EPIfOfZQD2ilV+VeC1xlN1OFj4BxXMypK?=
 =?us-ascii?Q?AWQVGXi1qYycjDQAmctnxH302yYcGgeEkLFEcFHashLj9YwVY+u0yt9y2W6e?=
 =?us-ascii?Q?Gs+f0jQTMO1wKDWB+sgeRKt0HOwm07mz6eNVy4Dv2oqBnPaQ28bGPN/Qqva8?=
 =?us-ascii?Q?waDbvQiZOxQH5tqwmcCbBofPcmTDndrCpjYvF/8XTcWHSipgxTe/o4JLuDgy?=
 =?us-ascii?Q?wJIHsxus+xMF5vBrBJ1oiP0xwD+bRuH++1IbczwY/cjzjaQvAIph+D06cARj?=
 =?us-ascii?Q?Tvwc55evAcvP2k9pSJsU6MjOwL5ZwHKLP8JL5qBru9k5JQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2024 06:07:08.1604
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 573c6836-eb55-4b2e-1362-08dc68129a01
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000148.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5824

Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
in AMD docs). Add support for the same in Linux. Bus Lock Detect is
enumerated with cpuid CPUID Fn0000_0007_ECX_x0 bit [24 / BUSLOCKTRAP].
It can be enabled through MSR_IA32_DEBUGCTLMSR. When enabled, hardware
clears DR6[11] and raises a #DB exception on occurrence of Bus Lock if
CPL > 0. More detail about the feature can be found in AMD APM[1].

Patches are prepared on tip/x86/cpu (e063b531d4e8)

Patch #3 depends on SEV-ES LBRV fix:
https://lore.kernel.org/r/20240416050338.517-1-ravi.bangoria@amd.com

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Ravi Bangoria (3):
  x86/split_lock: Move Split and Bus lock code to a dedicated file
  x86/bus_lock: Add support for AMD
  KVM SVM: Add Bus Lock Detect support

 arch/x86/include/asm/cpu.h           |   4 +
 arch/x86/kernel/cpu/Makefile         |   1 +
 arch/x86/kernel/cpu/amd.c            |   2 +
 arch/x86/kernel/cpu/intel.c          | 407 ---------------------------
 arch/x86/kernel/cpu/split-bus-lock.c | 406 ++++++++++++++++++++++++++
 arch/x86/kvm/svm/nested.c            |   3 +-
 arch/x86/kvm/svm/svm.c               |  16 +-
 7 files changed, 430 insertions(+), 409 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/split-bus-lock.c

-- 
2.44.0


