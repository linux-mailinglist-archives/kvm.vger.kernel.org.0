Return-Path: <kvm+bounces-23595-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D85FC94B6BA
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:31:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10B0C1C217C2
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 06:31:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52B4A187850;
	Thu,  8 Aug 2024 06:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NSxokfdz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED1313D62E;
	Thu,  8 Aug 2024 06:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723098658; cv=fail; b=EgW0oFdPCbCo8LwHVGeCs1naPf7zZolktJXG4eIIsL1ljWEKQCLjQDGWWcEtEGxLlwo6kRfFdKBE3UZhQkRjpPeswp+aNNt8pPLQD1PHrnSdplQnHoXLzrdE1TC7elwOi9K6c3XaDIBIVmdAko7J6RkhVsS3bWBUqVwOhO2z7rc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723098658; c=relaxed/simple;
	bh=F6vcQJLAD4axfMvyW4ciqnsJnw5GbLWzaM0UUO7w4BE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=S9LjLxmbQX/d4P2qNjZNFJWWhmBPnhojzFc92EZW32PYjBpf/y2/jHk3nRCYvXhJB7ZJX0fRcMoif8ymMS7ih7m5R5+sd9/1gmgGFnNLqECO/a85LrGJM4nsEIkzzhyXQTPRyfCdkuhJsJGtsakz79gmsSNB7KtKdG86YhUvLsE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NSxokfdz; arc=fail smtp.client-ip=40.107.102.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fAJytP6MuqNQS8dGeMgdX8WwFKX1z9k5YlaIpATQSCNRXzIy310Aa5Sva7Bi5wdx7FUBsKdnWqaSuKoeCecDtxeOmJWEtPs7Cc2yi/mY7EwLUJLl1ayC8LXWQIITMIYPo8BEmvGmFZT6D6RaqypYsj97bLx69IFG5ZwF31i5YjX1bTvJxf9oYSAa73iEyozGK9NX1HSQGXBrBPBZba6iX6zfS0401r1RjRG3aHExoWS64eLREPZy+4OkXN0maN8EW9dLk9KSB5BCrELqJCTJfbyVd0mEs3dVaHEWt52/ak4aK7o9ApQxjplbzM22Uf6UlkZI52S2Ci4gFzH1PhfO7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hX62E9rzMpmlIlxZXGiwyl8Jkj0aiOrBJyYLld3LTjk=;
 b=IjHO9Cktv4It16tJORNMkRhn5okBLL6Ft6uOGyJXRQhzyZ5H0Vmbhd6O2IwnsC38JYOy/mnBrBA0fDDPn6gv9j4odlZihwJwp7fDVHCirzcPSLsGfqfjjj1YETCDqpfphuzmbkKm3N0iUDeVjWwKHWRvp2ZFOYjEU0d12g3JfgU2++Gnj9He0DICjND7WddVuitHDlp62W8yVS1GJr9UR1/I8cSS/pSXaGUTh03vNx//HTTVK4v0hV/ZY44gwnJ3VNa2waLmWD2eraoh8hLaUr6baeE5WBj56ddwXj47Y/7Oj7znitVPvKPJFPQwBKo3YbDwkuXMq9rC9RCEGIu1Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hX62E9rzMpmlIlxZXGiwyl8Jkj0aiOrBJyYLld3LTjk=;
 b=NSxokfdzkseHTbbXtV2D9N6R/sDxwB6UDjPv5OyKPOX3GgKfRHgMHDHkuqKkNNZjSLyoVjTs1r6VruWvyhgP2vmRAIqduhtWKaXed1DtcXXKVhnmhGHQzqlos1JDssPlqPSjz2FmRyxnq2A4kiZaZztx1eXKI78cUek2MWPsA0Q=
Received: from BN1PR10CA0028.namprd10.prod.outlook.com (2603:10b6:408:e0::33)
 by CH2PR12MB4086.namprd12.prod.outlook.com (2603:10b6:610:7c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.14; Thu, 8 Aug
 2024 06:30:53 +0000
Received: from BN2PEPF0000449F.namprd02.prod.outlook.com
 (2603:10b6:408:e0:cafe::d1) by BN1PR10CA0028.outlook.office365.com
 (2603:10b6:408:e0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.14 via Frontend
 Transport; Thu, 8 Aug 2024 06:30:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF0000449F.mail.protection.outlook.com (10.167.243.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Thu, 8 Aug 2024 06:30:53 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 Aug
 2024 01:30:44 -0500
From: Ravi Bangoria <ravi.bangoria@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<thomas.lendacky@amd.com>, <jmattson@google.com>
CC: <ravi.bangoria@amd.com>, <hpa@zytor.com>, <rmk+kernel@armlinux.org.uk>,
	<peterz@infradead.org>, <james.morse@arm.com>, <lukas.bulwahn@gmail.com>,
	<arjan@linux.intel.com>, <j.granados@samsung.com>, <sibs@chinatelecom.cn>,
	<nik.borisov@suse.com>, <michael.roth@amd.com>, <nikunj.dadhania@amd.com>,
	<babu.moger@amd.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <santosh.shukla@amd.com>,
	<ananth.narayan@amd.com>, <sandipan.das@amd.com>, <manali.shukla@amd.com>
Subject: [PATCH v4 0/4] x86/cpu: Add Bus Lock Detect support for AMD
Date: Thu, 8 Aug 2024 06:29:33 +0000
Message-ID: <20240808062937.1149-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF0000449F:EE_|CH2PR12MB4086:EE_
X-MS-Office365-Filtering-Correlation-Id: 1356c174-a666-430a-98af-08dcb773a74d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?16wdQi/uZ+eYTZRA5k56nUfvCh9LPdztNL5C3czcbLZvlLOQI/ok0GUY6DN3?=
 =?us-ascii?Q?ZsuPiTHOMGgi0FtCdJZc7dTKgalFuq+OyAMRt899P3PfPkQ69iKXTcj2H7PI?=
 =?us-ascii?Q?sQM5K+245J6algm9d7F8/PaFW9az9mlxcnfHMVDTiLW/n4Wu+tgQi348Cm3v?=
 =?us-ascii?Q?ViFhrVqkhC/vt3THgFYnrHbtw/n7QoDcQ6WyLiM8Qsirot8tmCwAEyQxWPvY?=
 =?us-ascii?Q?foHQ3OBu3gRKmdFKWAEwJirXpYLgOb6BOu9HoXXbf3ttCZRv4VZkGOy3r5db?=
 =?us-ascii?Q?knOyj0OkVIk4qoDrr6Qq4ctLHnjK1udTI83ERGjkiE8638MYYniw8WDVnvQa?=
 =?us-ascii?Q?dIKoRNAFGaImV5BvYnu1aehOaap8snH0APqzcMB71RIiBtO3JztY/LGVhxTq?=
 =?us-ascii?Q?q4016AhnSyxRMcdLoS19kKyPCIa/11nFo8QR54E7/7bPee2ON/Cd0krUf7Cs?=
 =?us-ascii?Q?p9wo7oeWxKGZk+OTUeg6FCyWk2zlU15C5CMZuwlfBDueHzl8KOVF+CJoLStE?=
 =?us-ascii?Q?wR24FOPphuOiq4PbzRud2RhX0q8gPUSNQnbR8w1rkL1oBRmnoouQxLqriA8G?=
 =?us-ascii?Q?KExCUv1dve8a3qD7JAE9WcYDHw8TK/4SSO+t+RD53mZ6mStpl2odKit4slkJ?=
 =?us-ascii?Q?zbnmmfjwsDIuFttpQPl/bz3qnUebgZzccqzpXzwN2xiCGoEm88xKIDW7cOJp?=
 =?us-ascii?Q?JPkXnxdqtpDzc0wAMOBaruK+gqJ1KIN10E5Gg88TnccKcE0cri9esXQAHVTp?=
 =?us-ascii?Q?ZQH2PH+5X+A3+C2uDiPZiaf/3HoN22kHwdgOvUzaa2DrN4fLYPkiprEQlqjw?=
 =?us-ascii?Q?Acen2CjscYe47cAElK8dJFNA6/YMHhe/u8jh3jFXcymwhmgzeUTEAodnlpqE?=
 =?us-ascii?Q?I5ggCj7BPqocNGHGNBQqBfOU8lnTDjNarubBs+EcRuioAVuhpcsJbBhz0jBD?=
 =?us-ascii?Q?r+DlgSntOfyJqUQvM1Fv2scZJ93/bc9PhaZteuAnea0wPJkNgq5LVbHfHgag?=
 =?us-ascii?Q?o97DxhUYLuUiAE5Z7Yq7G44gDHPYkVSqvwc2vitMn0gDlzg4jSEpkc7VQr4r?=
 =?us-ascii?Q?kRaZYOiqBSEkSwZurloTYbCT2/6AeLscGjGBp8cSC6jeO4qIM2kZa7CRpjuL?=
 =?us-ascii?Q?CwsneJGzMz0s+NZQQRZKaXGvaIecx2QUwBhQisEb627lsJUyUVwbhTM3+3gh?=
 =?us-ascii?Q?87gu09aUJl7ISykQQjXPiU1fxwwuB1n+i2NgLSg34cZ2ND6sHK+2CigqbPuf?=
 =?us-ascii?Q?EJLw3OQ+5Aa9FJscNnlY7DKrD5LGJu5Fpon9WS8qdgyCuvOSJaKqxadxb2yc?=
 =?us-ascii?Q?lHVStD4xSSXSxYwfO/X51OXSKz9Goe2KesjSGGZ34Eo5IGmaTtQjQLVgk1z1?=
 =?us-ascii?Q?lOWZwVA+fd69bkmioUi14hlJUDzzJ9zewQHAlFG0XRjmhRW2+Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 06:30:53.4989
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1356c174-a666-430a-98af-08dcb773a74d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF0000449F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4086

Add Bus Lock Detect (called Bus Lock Trap in AMD docs) support for AMD
platforms. Bus Lock Detect is enumerated with CPUID Fn0000_0007_ECX_x0
bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
When enabled, hardware clears DR6[11] and raises a #DB exception on
occurrence of Bus Lock if CPL > 0. More detail about the feature can be
found in AMD APM:

  AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
  2023, Vol 2, 13.1.3.6 Bus Lock Trap
  https://bugzilla.kernel.org/attachment.cgi?id=304653

Patches are prepared on tip/master (532361ba3a0e).

v3: https://lore.kernel.org/r/20240806125442.1603-1-ravi.bangoria@amd.com
v3->v4:
 - Introduce CONFIG_X86_BUS_LOCK_DETECT, make it dependent on
   (CONFIG_CPU_SUP_INTEL || CONFIG_CPU_SUP_AMD). And make Bus Lock Detect
   feature dependent on CONFIG_X86_BUS_LOCK_DETECT.
 - Update documentation about Bus Lock Detect support on AMD.

Note:
A Qemu fix is also require to handle a corner case where a hardware
instruction or data breakpoint is created by Qemu remote debugger (gdb)
on the same instruction which also causes a Bus Lock. Qemu patch to
handle it can be found at:
https://lore.kernel.org/r/20240712095208.1553-1-ravi.bangoria@amd.com

Ravi Bangoria (4):
  x86/split_lock: Move Split and Bus lock code to a dedicated file
  x86/bus_lock: Add support for AMD
  KVM: SVM: Don't advertise Bus Lock Detect to guest if SVM support is
    missing
  KVM: SVM: Add Bus Lock Detect support

 Documentation/arch/x86/buslock.rst |   3 +-
 arch/x86/Kconfig                   |   8 +
 arch/x86/include/asm/cpu.h         |  11 +-
 arch/x86/kernel/cpu/Makefile       |   2 +
 arch/x86/kernel/cpu/bus_lock.c     | 406 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c       |   2 +
 arch/x86/kernel/cpu/intel.c        | 407 -----------------------------
 arch/x86/kvm/svm/nested.c          |   3 +-
 arch/x86/kvm/svm/svm.c             |  16 +-
 include/linux/sched.h              |   2 +-
 kernel/fork.c                      |   2 +-
 11 files changed, 448 insertions(+), 414 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/bus_lock.c

-- 
2.34.1


