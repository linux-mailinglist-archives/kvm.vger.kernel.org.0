Return-Path: <kvm+bounces-23360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F2A948FA4
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 14:55:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 520541F219F3
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 12:55:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FB041C4637;
	Tue,  6 Aug 2024 12:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CmSC6YQJ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2062.outbound.protection.outlook.com [40.107.243.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5661C37B3;
	Tue,  6 Aug 2024 12:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722948915; cv=fail; b=DIeTU/5m0Jbe7v5hvoeEnr1lyF8eCX0O6FCHCXbjI/jbBDGN/3rYn5g2R+n9L62t7K8Pd0EmtCbU8zNRbEyw4EOjebQyjt4XsPqd47E7pwySDmtXb8M6GiWIWb/JnWt258HRSUSXZXixKG52Dfv6djpp3wSy18Ox1yJyoRKoue4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722948915; c=relaxed/simple;
	bh=/oV/dc0JH5e5Lc8Z0yDZ2Ufy+RpDhhqt3zK6dh6NVAA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=OhD00OSO3t6CtrwsD41BbVl1q+beHF9nb8RyDBuDI8JzJiDYfGs0KNSnXmn6cjj5p6flWPAkxNfaX+Ge4lniAHqIE5HqcmjJE7xoEZTVAjx2ZElZ/KKTJAFeVyr9LqO9ji9auYsPx/jQu9hKkPE6L/Q7dH1PCzWnToIKjhDT+NY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CmSC6YQJ; arc=fail smtp.client-ip=40.107.243.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SEK2btKG70g8khy+yKtwHpKCVjtcTN9yQoYE5GnU/aj9O4fC6jjtT1cgWU+Jv3hFnaTZwdYk0PQI2k4SxDqar8gl8tDDrG3x1+xAs8O7wYLr0humG+guReCFy4W6oZ5QJBnVw+rvMYvTGta5FJ1ge9EAumzYmMQ7bvc2wrN+1l3/yQNW7W5sR0A7jY491dTcb9hPp3s4X02o0Rjkvk3f5REIcvutnEGBsxb1bxt6ay5q1hOaWIC1+bhuA8y4Iycws/30NSsUSqUcOJc0gU3I8XApyaAWxyqm5FxJptJ/zlqwCqvnfHDwyDtkAdiHP+u6Yc+CpWbG2D6tmL2swnCyew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sSYZKyNf6GRknlo0Fcri6BTUquHNtN1xjuILnf6AiY=;
 b=yY+Dh5xvRV5U82b8Qa06ymtzDbb2gsAyfykB1BRTeUd3l9QUTelLAwbUHy2nNS6CMv4cHyLlvhiitn9hTB1UA+HUhL+JnDjM6wXfzlPmLjKK8u2MWHm83nA3K6fEjYwFWitVOvER/CZ0A7X8OtyVkFIQLrEw48t19vRTf9lDO2iITi2WZba6eXObh8nsfNSeBvMEnM65RiPnmxZpA0vhedfPbJLxqrYHSRpLgCMNvJQ2m0Uhug4RKarvmBXBU7TcuyH5L/JmUBM8i7tRALfRQ4WGisW0wNgITRgdTxWHFgWLzPuQu/Do/FQH9JrAxv8gXLogsSCzLs89IhbfS774gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sSYZKyNf6GRknlo0Fcri6BTUquHNtN1xjuILnf6AiY=;
 b=CmSC6YQJTB8rx/E7W0+8MkVhGeMyeJo95sM+11xFbDYE1HTMv+lnDi922GCMOCoWsWGuzByW5LXL/otWns/lvixVcom61UzHrGC8rBD6APCMMbHCF5jdnBFolh2DwxmvG8GXUUoiqUKlQLyMLJmD8M640JcAq4zAU+2p6R05mlA=
Received: from BY5PR20CA0028.namprd20.prod.outlook.com (2603:10b6:a03:1f4::41)
 by PH8PR12MB7423.namprd12.prod.outlook.com (2603:10b6:510:229::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.23; Tue, 6 Aug
 2024 12:55:10 +0000
Received: from SJ5PEPF000001CD.namprd05.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::2c) by BY5PR20CA0028.outlook.office365.com
 (2603:10b6:a03:1f4::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.26 via Frontend
 Transport; Tue, 6 Aug 2024 12:55:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001CD.mail.protection.outlook.com (10.167.242.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Tue, 6 Aug 2024 12:55:09 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 6 Aug
 2024 07:54:56 -0500
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
Subject: [PATCH v3 0/4] x86/cpu: Add Bus Lock Detect support for AMD
Date: Tue, 6 Aug 2024 12:54:38 +0000
Message-ID: <20240806125442.1603-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001CD:EE_|PH8PR12MB7423:EE_
X-MS-Office365-Filtering-Correlation-Id: f73ba4b7-62ca-46b2-d5e5-08dcb617013b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8vPL9S02xjzTm3Ub927smaV3/JB5i6e5S6vhmWr9yKga6nVmWPIEA76+7YjT?=
 =?us-ascii?Q?1xOuROVSxGkzp4lDpxFfgYJQQgbFmV+4f3x4PbYsGOfXzA7pXMq4P1kTwnob?=
 =?us-ascii?Q?caZeE4kzGkRUf84VQHtFisQEirk6jBgmPfikOxfK0qBWpYBoP5Y5ZNjpfRPW?=
 =?us-ascii?Q?kK3DztnYQvyf8kI9ZR4tJ2rh5Bevt+VRoZf9Z79pmkYacRK+7/Pqz0kDZHzY?=
 =?us-ascii?Q?X/gL3O2q5YZ0ODSEu/463/T8v6xzhNdnypkv6h+XWH04mVoQ6wn6kphbsiMs?=
 =?us-ascii?Q?vVf7bQ4P1RSTaG0APVr+on+SL56K5lRldW2a9YaB9PvNMo9gtG/n6h/Csygl?=
 =?us-ascii?Q?soc1xIH5MZDgQ73QQ8I8oi017U/RHvzViOItz/tocYbVVxZATNLoYX4PUdrT?=
 =?us-ascii?Q?u0aLqWfbIxQKOHs+W+bA54oeULTYxC7cdXG8mQ8JWeyTd1xctFXcsxo4eLdA?=
 =?us-ascii?Q?K9DDJotjMIGD0cPF4X+dcCIJeeHae3JvGjmuD0wNDeSdd1OeCHLt0K1YCWfI?=
 =?us-ascii?Q?pFbuJOOEywOnllu/0gAY/FtRwC2g1+Un0DQKrBZF54DTzhEr4LbLkD1XdW1T?=
 =?us-ascii?Q?2Cvc9SQ8/gETbbzHatFNABHq2uC8dNwyPWrwNUnNrHJE8OYkxB/AaNfnbWh1?=
 =?us-ascii?Q?gx4VcpNEgiD/nyhP79BgjMz0cgyIDdAwJYBQk2ba7PK3kMzr5+wwayVUgaXv?=
 =?us-ascii?Q?f2pXYOcgo7gEALB7V4iErHAc+W0eMF4t+oi2iYoeFMQLgZWsVgnzOnIEkMae?=
 =?us-ascii?Q?QPsJPhJMgqdP31CpncQYlkc9suVKRWQlu7COuxvk4LBX6PIh3o0CP4TlscrB?=
 =?us-ascii?Q?1B37udeaaiKXK7dnWcUe+H9e/uu270w9IGwHVOHXZL//0XCnDZ4Uxz21MXLF?=
 =?us-ascii?Q?MYQBTh1pORC+MmLi+BxO+gQRQK47CYgKVpDMxWImoPujcCnnG7Jn+rzU5PhM?=
 =?us-ascii?Q?tyJ72Qo+qYhxWf/xpJa9y0wHr6orwWmTUsJ73oCETw+D2KZbB6dcZk/1xocd?=
 =?us-ascii?Q?8Dp+uQI/zeWSdq31xAwrMbwRiquSAm2cwLVGPVaUx0XXLPKdcFlSY3JBneSw?=
 =?us-ascii?Q?qQKDgmxIKg50lrfXdGeyZ9CBHBi9NrkWEs/BlOFS4d/aghFzD6ULmDvPjZ2o?=
 =?us-ascii?Q?LH/hqD3S351fjkcxipfJAzc1KnocIccYagTA2Rp/jjph5gZJZwkvLcwPb5hC?=
 =?us-ascii?Q?hWo8V5Esi8YpplIKjBmFOSj6ZjrbJoVDb/y//ArFK4c42mXugSS5Q7F46R3S?=
 =?us-ascii?Q?jcARnvMpNQu7yjfcw1IwhMxbauXPiIopne4tYP8+C1pSgnmykSh4Q1tDtuML?=
 =?us-ascii?Q?MAGJPKFaervqginHL+b8p4KtwbR1JQTybbrNLa/9qaN6y4DVmW72gExiOyNm?=
 =?us-ascii?Q?wcFK6xMEfwfrovP1jB9kuwEt7jAwBC5HhePBCKtW11EkTaPzcQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2024 12:55:09.9563
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f73ba4b7-62ca-46b2-d5e5-08dcb617013b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001CD.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7423

Add Bus Lock Detect (called Bus Lock Trap in AMD docs) support for AMD
platforms. Bus Lock Detect is enumerated with CPUID Fn0000_0007_ECX_x0
bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
When enabled, hardware clears DR6[11] and raises a #DB exception on
occurrence of Bus Lock if CPL > 0. More detail about the feature can be
found in AMD APM[1].

Patches are prepared on tip/master (435dfff07e5b).

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

v2: https://lore.kernel.org/r/20240712093943.1288-1-ravi.bangoria@amd.com
v2->v3:
 - Fix build failure reported by LKP test bot
 - Reword commit messages

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

 arch/x86/include/asm/cpu.h     |  12 +-
 arch/x86/kernel/cpu/Makefile   |   1 +
 arch/x86/kernel/cpu/bus_lock.c | 410 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/common.c   |   2 +
 arch/x86/kernel/cpu/intel.c    | 407 --------------------------------
 arch/x86/kvm/svm/nested.c      |   3 +-
 arch/x86/kvm/svm/svm.c         |  16 +-
 include/linux/sched.h          |   2 +-
 8 files changed, 440 insertions(+), 413 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/bus_lock.c

-- 
2.34.1


