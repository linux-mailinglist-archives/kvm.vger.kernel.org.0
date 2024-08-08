Return-Path: <kvm+bounces-23597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8DA194B6C0
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 08:32:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBD591C212B3
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2024 06:32:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1308018785E;
	Thu,  8 Aug 2024 06:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PA8lhuc2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2050.outbound.protection.outlook.com [40.107.96.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B0C187856;
	Thu,  8 Aug 2024 06:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723098678; cv=fail; b=Cly7YrFw1I2WnYaYm5Aqr3rCA2fuHDbXM10B7LVfQLAq/hq3Sp7GcBSiRxmUN+kkg+TIxfrPRWdVrQ2FnoUpMp0/U0WFkajn/scqFgnMTz7TQQNG22XOpt9mgcJoXVTmDTFxvOfPwUpIGpkOrMDQVCJpXW4Abvy2FFU+SZcukwY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723098678; c=relaxed/simple;
	bh=1h86h35Xg5dGdtM2vlbPZl8m7VT2yE7gO8kYOeB0LKM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nVEB2gJag+iEr7M7OvIjhRRheC921iP7TEArhNeTRb1WttR1WqAt5ghZn6MLleSTAcRUqldl/tHn4WW4Llm4WzBYCLKQvCqEhibtzHjoXB1OQsTOwrn9+Fhd1ItEPDBl1JDsFoGzCJQQzObKKA0YxpBGti9XHk+WFOEq7/5ozQc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PA8lhuc2; arc=fail smtp.client-ip=40.107.96.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GSvaB7PjSiHOtHoVJPbUMIKC7NmgGw+0fpUX2NqsYBO+SQYFazfkr7VBjEnn2Pp8szkQx0aoPbaOgginwzGkG0ES+aixRxXj0wXiBgT+tj0Z66hIGrkYQoDCIvfCQCHUFhGv7vreZAoHz9w/X3E7TfrzjBsPMmxHa204bvO2kTTvtZP5ag5jrrJISRnVPPoMKhkRMCt1GgXSjCEnR2jS/pmaIBDGByZyAsBBZY5oNzb0G9vq2nGWSN0aFEf7X49ft1xXsuS3BOulcrLg3dxj27/YHlSKoDGwmf/b8taOvEZjvK9y/7EyLzzBX7XStTihmO62FC2LTTBxMOYMwZi4HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vrN/hIW+1SUQESJawbX8KfRDUh7JL+yazdWLFHSH/QI=;
 b=TfgZZkEIErsIQAIA0pVsKVUc4Or9MjvFpqd1dvR9EtHvg6DDqh7WYSCHQlwSNcKptTuxsFFXk741R5es0Q9T2YSZmhEirRFlnO3HEisnoEUwoq+9tOKxOO8EozB9l7uSHLXNvh88Rtx6fTe7Mfi+y61CRUrMUJJeSKs1ILdgF1Tz0mshD1raWGZs/41jvXij6+OuxJazSGcwSqf4DaI1vwDGpc/1ygMvmkvGMys/l6UK/y/KsGt1zdNjAUgZzRXMnwq4tf7au8AzZn/nbdQJIksvSTtZhhejV4GThgjKhxUxEgdHpZ0rcGtTDg0pLML1fjcrQd7pdwMvfvScRbePgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrN/hIW+1SUQESJawbX8KfRDUh7JL+yazdWLFHSH/QI=;
 b=PA8lhuc2eJK5rkyZdXKHihNniAQD0vfkItmqyjO+FLBMyR3uRs7diJyToHxpqm3wt5v0Q05f6f6E3YhZb2DsMWx8tHVL26D15OmDWAkgsSrjCV3HsEDTF4ik59MokR1pRXoCbtsEXVBv7wwZoK/Bd5Rdeyz3nS6rkpNHBYbZ2Wo=
Received: from BN8PR16CA0022.namprd16.prod.outlook.com (2603:10b6:408:4c::35)
 by CH2PR12MB4135.namprd12.prod.outlook.com (2603:10b6:610:7c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.15; Thu, 8 Aug
 2024 06:31:11 +0000
Received: from BN2PEPF000044A4.namprd02.prod.outlook.com
 (2603:10b6:408:4c:cafe::d0) by BN8PR16CA0022.outlook.office365.com
 (2603:10b6:408:4c::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7849.12 via Frontend
 Transport; Thu, 8 Aug 2024 06:31:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A4.mail.protection.outlook.com (10.167.243.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7849.8 via Frontend Transport; Thu, 8 Aug 2024 06:31:11 +0000
Received: from BLR-L-RBANGORI.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 8 Aug
 2024 01:31:02 -0500
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
Subject: [PATCH v4 2/4] x86/bus_lock: Add support for AMD
Date: Thu, 8 Aug 2024 06:29:35 +0000
Message-ID: <20240808062937.1149-3-ravi.bangoria@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808062937.1149-1-ravi.bangoria@amd.com>
References: <20240808062937.1149-1-ravi.bangoria@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A4:EE_|CH2PR12MB4135:EE_
X-MS-Office365-Filtering-Correlation-Id: 44432e38-2ab6-45cd-8a9d-08dcb773b1c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|7416014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7y2fyf93cdJ+YjmXsfuoz9ALgDOJ/TgaRKoavqU1B7Xd3vD0miCEmJ76v3SL?=
 =?us-ascii?Q?bPQ03ESReqWOcigRTv1DK6pQ6KImmXaOTrdcXDj3vwt1wsqssXNfL9KY4Ly8?=
 =?us-ascii?Q?eY4OZdbidX0dOi++9OGAOQBla+WF7kR7VUA/wjn2RDpi8G4jHSJmPltl/Max?=
 =?us-ascii?Q?FvO8aOiMeimmeGiEc7Jd6ZlXDew/AMqzHETJ8RDNPDKpsNOtGsTgF8WcpXi3?=
 =?us-ascii?Q?HzE+xJAvxAfIvQpMpsarMU7sjCDgG+O9R5wExEt7KvdppZuDYwDPUk2tCLOE?=
 =?us-ascii?Q?6RfvlIVaGgUnDQIZNWVx4eJt19aQAkwftXGYLOkpKKK+ioEPICX9vArhAIeo?=
 =?us-ascii?Q?N9c96nEjafueGYx/SN5oq/LgF7tN9rh5X+P7Q+hCxUoy3vixZD89T2YFFdCV?=
 =?us-ascii?Q?KfhUNqGfnUB7gmMIf2xCykvTkj6UEbKpa3pzByVPSvgUD4FjNcppo8Pjdb2N?=
 =?us-ascii?Q?mvla/2qMA45iC42qzKYAzNlrUdFZ1kxUXu9+XKOvm45vSw8+6PwLIecMECyk?=
 =?us-ascii?Q?GqYGkr7BeRueSFRcrAHPZrVtTM7UORNqaeKEndW+dBNrGFxaW5xNEcFqLkNt?=
 =?us-ascii?Q?5nhhrQE8I4Y4/SrgCoWHjQZ/vvus2/Insnm8MalT/F19AgeujsPqq4N2zMzI?=
 =?us-ascii?Q?ZAAwCWI+RT3IQpMrSe+2/fwESNqMJIW93Trjy2lagZfPrJRqutEQjXoaNuT/?=
 =?us-ascii?Q?WEa3IfKuHSB8bQcuaFcJYbMDXvVPxMr8dend4ltHzmAN+dYoDpw0xu2i1M5s?=
 =?us-ascii?Q?GBa5mhS9hKSoqsBvP6Ky0SpllxrfIk5TFnNtwFEhxnLhWtvtqbaAfo9aUVLM?=
 =?us-ascii?Q?NmRQzPBDZN+FJBTAmtw4+btnj+GTim8kQ5SmGtxS8t95CWpGLgCAoMv+2eTm?=
 =?us-ascii?Q?nbtqJN9I8B0r/BO5L+Nv5mTwWdJHayVgOD9kp8Qrs2H+n13pRXI+cxlg8v74?=
 =?us-ascii?Q?mjS6Vt3Zv+sR0DL3UOPU8XepHoabuFl/DzAMZDkbSz2pufacEeM3A8zC68EE?=
 =?us-ascii?Q?629fevQ0fMIb1rhIEJq8e4VdTJ2IYs5yIrOY7SZM6R+HPtWsPLwydmpJx+cR?=
 =?us-ascii?Q?4eyDCNbLNy3jYqhFUvDaGBc8c3PATMJuVk2GQUaiBDy1q0+wp/OESqW+ZMqY?=
 =?us-ascii?Q?YSzGyb/1J1xDhKVvE7dUCs4WKAkyjvBPJv/itJx/Qy+4SveKPWMMS+Suq+Oh?=
 =?us-ascii?Q?axZ+Zh/RnnlJuekwFHh1qhcS4vNsPLSalQGg5AEruVTdC4/IOcb78mV/rY78?=
 =?us-ascii?Q?hPJkbYpRA02j3Qyc7/JIVhhcFvZoJfCZhr1cOa0WNJzxrpwg/lIrSYYynv/d?=
 =?us-ascii?Q?VBCAK5TmZ1/pPsA3TiBqlEC6WjXj0nhWfYUn05T+HkUAaYb1/C0QgMuZWg1/?=
 =?us-ascii?Q?zsRJH64QWogOeM+RkqcdICz3dsGg3X6vgJlcJfTHmoDflQRvYg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(7416014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Aug 2024 06:31:11.0047
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44432e38-2ab6-45cd-8a9d-08dcb773b1c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A4.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4135

Add Bus Lock Detect (called Bus Lock Trap in AMD docs) support for AMD
platforms. Bus Lock Detect is enumerated with CPUID Fn0000_0007_ECX_x0
bit [24 / BUSLOCKTRAP]. It can be enabled through MSR_IA32_DEBUGCTLMSR.
When enabled, hardware clears DR6[11] and raises a #DB exception on
occurrence of Bus Lock if CPL > 0. More detail about the feature can be
found in AMD APM[1].

[1]: AMD64 Architecture Programmer's Manual Pub. 40332, Rev. 4.07 - June
     2023, Vol 2, 13.1.3.6 Bus Lock Trap
     https://bugzilla.kernel.org/attachment.cgi?id=304653

Signed-off-by: Ravi Bangoria <ravi.bangoria@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 Documentation/arch/x86/buslock.rst | 3 ++-
 arch/x86/Kconfig                   | 2 +-
 arch/x86/kernel/cpu/common.c       | 2 ++
 arch/x86/kernel/cpu/intel.c        | 1 -
 4 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/Documentation/arch/x86/buslock.rst b/Documentation/arch/x86/buslock.rst
index 4c5a4822eeb7..31f1bfdff16f 100644
--- a/Documentation/arch/x86/buslock.rst
+++ b/Documentation/arch/x86/buslock.rst
@@ -26,7 +26,8 @@ Detection
 =========
 
 Intel processors may support either or both of the following hardware
-mechanisms to detect split locks and bus locks.
+mechanisms to detect split locks and bus locks. Some AMD processors also
+support bus lock detect.
 
 #AC exception for split lock detection
 --------------------------------------
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index db2aad850a8f..d422247b2882 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2429,7 +2429,7 @@ source "kernel/livepatch/Kconfig"
 
 config X86_BUS_LOCK_DETECT
 	bool "Split Lock Detect and Bus Lock Detect support"
-	depends on CPU_SUP_INTEL
+	depends on CPU_SUP_INTEL || CPU_SUP_AMD
 	default y
 	help
 	  Enable Split Lock Detect and Bus Lock Detect functionalities.
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


