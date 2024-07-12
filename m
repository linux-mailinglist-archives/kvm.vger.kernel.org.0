Return-Path: <kvm+bounces-21495-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FFF492F81B
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 11:41:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE54F1C2177A
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 09:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFB314E2E8;
	Fri, 12 Jul 2024 09:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="R8qnlByp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2060.outbound.protection.outlook.com [40.107.102.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556E014884E;
	Fri, 12 Jul 2024 09:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720777262; cv=fail; b=rzG6+Ru4H9zI5+JFtSyuuMTOH+JGetKVs8MOHdky+wStJ5MkF3mrpBcPCM7jLbIJukmILw4pTC3/GbtNSQre8JY1hUzPYlhkk6MhVjF1AzWt7NF64A845+g443JGUnSUFD91NKVJDi/MFbbuxSbrw9eOcOyK5uj+PqsJmJv8XNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720777262; c=relaxed/simple;
	bh=cUCbqBu3WZjjYMLel3czDGZznRwyS/yOAfBLaw4zJfQ=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=kbMC/nmTrc6CpojowUdtDi23vfw9xaf2DZtuKEZqwF+pCM3DNqOaKSaEoPUuKLwWbky1h4xs4DqYLhMhySGAa7EvCfKmdcwExOUdc91uHxTMl/FLCa/DZp1ERJL8PGNHMDz27p8hljoGCX6SNXFM+gr2vUBD5zN5B+LNXsFnDpw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=R8qnlByp; arc=fail smtp.client-ip=40.107.102.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y5YIFNLrvVanO13yxsr32N63d21HpGP36RtUDuwdBx1JllU6pxDhaS/cffl18aaDYICpAyGVBIVdJgWEf/rFPiur1Rp60A2JcO3Hb14OhRZLTrxLkA4hGDGzMz5mMVBAYFdVPexkq3FVZ7lf9eMcUjM4AwvtXsPE9AOEReq9R9d7y89AUI23XWdhDkpA3mGBfhzJAyXYiJ1crpZxlS2R2BcT75UBtQCq4r+Wte89QfgeiC7z8vveriA2Pkehbsw5dZ06ku1J1hs83JeTJ/fVEjaINUvWjKU8eVV4tZgA3RiNXfWp9LNul/I8Rae8wEXixgciWPgbV/r46vYSch7bAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4iAzIhXRS23uxup2OTH7bZGTs1kGjAjiZY8GzVTtDNw=;
 b=FIkkhRnAgBO3pvTZUQWN4xYg9D15bPPeWdsk19v3UknQj4WzSUVOE1FaiHthYokg7FSLbsPmdDYMMn/juixP05bFeGCQWIjLTokJ1R8zADsGDbL+uXy8rI0a67KJRtgOgOdnaFn/MX6RhmE+elHGHnh/hKegR71wKvIz7vXDHHoUG0XbJnTxqjfbW060Zj6/GS0/hjh/CTXK//+FdUGt5RB/aJbaggXQ+IM7H4YniaYt2lTebcqWF21yIHXhITR+fHTloiycq1sQFA6tFJnmptviQfZ6iMKtxza33m35rEC10bHko6jHCBoOPJXxqdvwd/RYbPkjJD75rk2kbkbuzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4iAzIhXRS23uxup2OTH7bZGTs1kGjAjiZY8GzVTtDNw=;
 b=R8qnlBypsNG/DuL7kZfCKPRwsFkc03L1WSXNlY5KSoc3s0xBtNVyAlr+H1nxdob6j++5jZPktJnCUQPL8Jdbjkx9s8S1W6fr/PfR9RtzceCfreW5bOo89FGxaGTNLMbGd1d22x368ghybI79dD0Kf1GUgywhKB16fP9rAsCeYys=
Received: from DM6PR06CA0045.namprd06.prod.outlook.com (2603:10b6:5:54::22) by
 CY5PR12MB6430.namprd12.prod.outlook.com (2603:10b6:930:3a::12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7741.36; Fri, 12 Jul 2024 09:40:56 +0000
Received: from CY4PEPF0000E9CE.namprd03.prod.outlook.com
 (2603:10b6:5:54:cafe::fa) by DM6PR06CA0045.outlook.office365.com
 (2603:10b6:5:54::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23 via Frontend
 Transport; Fri, 12 Jul 2024 09:40:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000E9CE.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7762.17 via Frontend Transport; Fri, 12 Jul 2024 09:40:56 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 12 Jul
 2024 04:40:48 -0500
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
Subject: [PATCH v2 0/4] x86/cpu: Add Bus Lock Detect support for AMD
Date: Fri, 12 Jul 2024 09:39:39 +0000
Message-ID: <20240712093943.1288-1-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000E9CE:EE_|CY5PR12MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: db9c784a-d086-4e2d-79a7-08dca256babf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+0o8V7AE5pLmK6aDArByL8ZRpLzzwR47MsNOUdfdtSV0uvgxFvkemh3Nqfyy?=
 =?us-ascii?Q?y/ncKRy62e8+n0qkjkL4f8l6eq2mGf1brh6TytQFYLiiOkBxot72nBabLfGP?=
 =?us-ascii?Q?5N2zl3yHLUYqgAukI82+47yc8dg5ixgkIQvP3stpVcVHjRmRLM5COqYrREaH?=
 =?us-ascii?Q?VvfJytttSnlzzM+/SnPdoWUVnD02eke+0CVNPBNyMh2vBQpkYpayGPP+Rp4R?=
 =?us-ascii?Q?qaeP+2Xxd3JNIlIkYF17lw9CckQ62v5+cU1AAoFWVZDCp9uXOV/dgRj191di?=
 =?us-ascii?Q?by+qaBm0DlMRUl3v89fyB5WyB5JdJ51hlz+BEz7fshf5Yt5CVVUuEQrz9tPN?=
 =?us-ascii?Q?Br8iojzERVWXP0iZTyCPNRYqG9tGTWxhm0PX75YrKCD3lYI3zo3H+5sDJOCc?=
 =?us-ascii?Q?NAL5nqYze+s8AXkNTbOhoAXJDrxlHss3qmDrGS9RsO5rLqAV4calK2/RkZ43?=
 =?us-ascii?Q?/LpLALEUoWbULcB5+15ELFKyOx6ghihstbtEFN/6H1Wi82fqAWZCxptlcUYz?=
 =?us-ascii?Q?u/ocGAxdJzIch2AaLdCXqI0Y2rDaiC/WIzkKAgpXw0llDH/tVcjapNqqov1a?=
 =?us-ascii?Q?7XaoFyZupuRxs+uQAifsnFqOnJm4yLir+LvEJuaGdRebY4KlXmKt+QqFFhKh?=
 =?us-ascii?Q?fwG+XbAjPv3cEAbkjJ8VL/s8aOhaXTOPU4AKGdneTyvbP8HbAiff2vGp6nTP?=
 =?us-ascii?Q?aOGanxyMEiElZQDFOYy4sKwxYdNi+WZLmAf8K65rWIpcy6EQ6vytYxVS6YaW?=
 =?us-ascii?Q?BXMRzw3Fs/xOZZrbsXl2XACQuJIrC9B0rorJU1O2YEgfO2lQIWfVKBYj3bL5?=
 =?us-ascii?Q?vV7+49fDZIn4uXcUQqfBU/QPrI7W+BbXc/X/rtvQvQrskCvhruRKFuqSz41J?=
 =?us-ascii?Q?7yg4d110ctbKvgwvX5bSBp8Gepgqp/Ud5XKt9NqDoR684grZBiieuIh9ejhJ?=
 =?us-ascii?Q?cRW3gf6IeIEiv3RLwaOvRfj1uiBKxMk3NG16DWTh9PAXKCtIS3rViBGJZCPl?=
 =?us-ascii?Q?7QvVkQw6Z5FU4wJ1tsZKbMwXTeY0j8E5Llls9sRvC7OWjkUz9TmQ8cg2Cnxz?=
 =?us-ascii?Q?szh2jmsxQ6bJxn5cnmJFLM9cYY6a2asKcNfsraPbndG23mXkdVpNf8QnYBkI?=
 =?us-ascii?Q?AURYzBL0A4Evf4Wg4ECdjxuBb8k4TmxN3Em/0nRd11ALhWFtjeqx+2OfRxHc?=
 =?us-ascii?Q?QjDZfLH44Cj5cR7B4j9+FcBZX2fJ/4D5iJlzrwKjYREmhJFwdVqcIF8+S3e3?=
 =?us-ascii?Q?T4k7EIJQcqzQRVdCYNkrqTPQ47ZuwdoWnVl4b54oP/WPKsjFR1+WQHykPUTF?=
 =?us-ascii?Q?I5wRmrCxUpsLzV33Q76gHL3BYCpC+3ueGQyw/w3vPjLjJfIEUcBVM+ksK6+u?=
 =?us-ascii?Q?WZBWfIkI96d0IzVoErIu6XzKb+8mm9jWAvnK16Zn13RdxNSglg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 09:40:56.2515
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db9c784a-d086-4e2d-79a7-08dca256babf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000E9CE.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6430

Upcoming AMD uarch will support Bus Lock Detect (called Bus Lock Trap
in AMD docs). Add support for the same in Linux. Bus Lock Detect is
enumerated with cpuid CPUID Fn0000_0007_ECX_x0 bit [24 / BUSLOCKTRAP].
It can be enabled through MSR_IA32_DEBUGCTLMSR. When enabled, hardware
clears DR6[11] and raises a #DB exception on occurrence of Bus Lock if
CPL > 0. More detail about the feature can be found in AMD APM[1].

Patches are prepared on tip/master (a6fffa92da54).

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

v1: https://lore.kernel.org/r/20240429060643.211-1-ravi.bangoria@amd.com
v1->v2:
- Call bus_lock_init() from common.c. Although common.c is shared across
  all X86_VENDOR_*, bus_lock_init() internally checks for
  X86_FEATURE_BUS_LOCK_DETECT, hence it's safe to call it from common.c.
- s/split-bus-lock.c/bus_lock.c/ for a new filename.
- Add a KVM patch to disable Bus Lock Trap unconditionally when SVM
  support is missing.

Note:
A Qemu fix is also require to handle corner case where a hardware
instruction or data breakpoint is created by Qemu remote debugger (gdb)
on the same instruction which also causes a Bus Lock. I'll post a Qemu
patch separately.

Ravi Bangoria (4):
  x86/split_lock: Move Split and Bus lock code to a dedicated file
  x86/bus_lock: Add support for AMD
  KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support is
    missing
  KVM: SVM: Add Bus Lock Detect support

 arch/x86/include/asm/cpu.h     |   4 +
 arch/x86/kernel/cpu/Makefile   |   1 +
 arch/x86/kernel/cpu/bus_lock.c | 406 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c   |   2 +
 arch/x86/kernel/cpu/intel.c    | 407 ---------------------------------
 arch/x86/kvm/svm/nested.c      |   3 +-
 arch/x86/kvm/svm/svm.c         |  16 +-
 7 files changed, 430 insertions(+), 409 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/bus_lock.c

-- 
2.34.1


