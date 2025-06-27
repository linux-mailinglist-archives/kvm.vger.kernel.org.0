Return-Path: <kvm+bounces-51017-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3632DAEBD3B
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 18:27:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D0E0D562AAD
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 16:27:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A5732EACFC;
	Fri, 27 Jun 2025 16:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E7f1TMc4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2056.outbound.protection.outlook.com [40.107.101.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14B6D2EA158;
	Fri, 27 Jun 2025 16:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751041601; cv=fail; b=XclAPMdVmVnUBjXtTpA3DWgMxCp7ddmohivJuZGcRNRH2jdgYjVfp/UKV4Fi8eHfCwS+aXA1lGOlbPgq9w/OUu49PELVOQmMYwW5zO3xEgX4jut1RtEI0HgDWFcb1qlNs4P6STP+Ge7oBYZnYcsGGM75fNE5YtQJpZZPYwKeFWM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751041601; c=relaxed/simple;
	bh=f0Mg4vHM9ACmLT38GVSz7SbbUCYSTsD81FztpLCu+pQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bdxhWeMZeB6m/lhgkerG30LuVQYtRl4CVpQv9IGrtdnLX/Fo5z5LmwriGsMFsW6JhRPNE2y/LFYaMpqmZIpFmZeR+FcqKgU09g8+9JDDDS9K5XDPSCQqRLLnInfO997oIW96jGn6BgFC024xsLxaxAg4fru7VWk6NNpzHHOxgXM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E7f1TMc4; arc=fail smtp.client-ip=40.107.101.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RHZlyqWYLHWglEeOKwAabBF9LndAof9+kXUno971DbmuDBQn2KJJI+zYI6/TVSvMYzEgBSdyVlpXBWxzIHjVKoNbtbxVYFQaKybtvUeK2xee6y8ooxdAbFsC3ipDjBNrttKbFyDo1ZO3k27aLc/IBSzeCo2PfQzFhoShluUz+tQo5Cv/B8vgtOJdwRtLUiw5Y06x+9NnZ+q0dm1hsR1BgoRDcqBme6EhddFkwKcsODIIi4h8462tltdHF68MnEZ1ZqSEHdoYmwNgi3Paq/nJB/PVim6JLa35GeNGWQ3qsc4tREcxdJ2yWQ/69hhhv4g5JQSLSX/YebHiheGji/8Sww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdwPBhMrwDx0GeGiwiQhcQXe4SkmCwL4LDrOMmNs93E=;
 b=EIUVX7+VdvkmiEUNyaY+JuJuEsVU0jYmhAM39c8G9ZjWZobfJCoWiQD/4K0xN/jvMa8CV3UE9BTL7zHAfQoXEgYmMWLTMcZNUOsyS3HXXwMQ3kt1lx7N1grsMYFjmEG3AYzo1kNhuufq3oNqLDeJymZHlFr1jCgbY6ainXKyh13CbWoN7V0aU+Cdd9KU70Fl6IrSy0r7zSAdd98/Wqu4hS8XUrPbP5b3Jdn1Tb9YCS9Ixs4a7UY0N+hS6a1qw1cJxWKWo5bP4XLDBZCjaR7lMQLFYZl9g/dF5NsXYj5dpJ6o9CC43xjmFidE1J0K0TyHc5BG3RznvRVtQ2/san0hog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdwPBhMrwDx0GeGiwiQhcQXe4SkmCwL4LDrOMmNs93E=;
 b=E7f1TMc40cUZIvJfUDyWBPmE859Jv/Gq+NUochb2vqoHY3zHUglvEI1rolxNvcCBz2p0Dxa+PcPNlqn0u9ldkapFoVrmbRQT2axYYXbocSnMP5NkZpVOXgoeqdzsoQmVLn7aiRDt13LaCeCSxXQcLh8sNNQHTSYPDUoo8UOvUMQ=
Received: from SN6PR05CA0023.namprd05.prod.outlook.com (2603:10b6:805:de::36)
 by IA1PR12MB9030.namprd12.prod.outlook.com (2603:10b6:208:3f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.29; Fri, 27 Jun
 2025 16:26:36 +0000
Received: from SN1PEPF000397B3.namprd05.prod.outlook.com
 (2603:10b6:805:de:cafe::60) by SN6PR05CA0023.outlook.office365.com
 (2603:10b6:805:de::36) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8901.10 via Frontend Transport; Fri,
 27 Jun 2025 16:26:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000397B3.mail.protection.outlook.com (10.167.248.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8880.14 via Frontend Transport; Fri, 27 Jun 2025 16:26:35 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 27 Jun
 2025 11:26:31 -0500
From: Manali Shukla <manali.shukla@amd.com>
To: <kvm@vger.kernel.org>, <linux-perf-users@vger.kernel.org>,
	<linux-doc@vger.kernel.org>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>,
	<manali.shukla@amd.com>, <bp@alien8.de>, <peterz@infradead.org>,
	<mingo@redhat.com>, <mizhang@google.com>, <thomas.lendacky@amd.com>,
	<ravi.bangoria@amd.com>, <Sandipan.Das@amd.com>
Subject: [PATCH v1 05/11] x86/cpufeatures: Add CPUID feature bit for VIBS in SVM/SEV guests
Date: Fri, 27 Jun 2025 16:25:33 +0000
Message-ID: <20250627162550.14197-6-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250627162550.14197-1-manali.shukla@amd.com>
References: <20250627162550.14197-1-manali.shukla@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000397B3:EE_|IA1PR12MB9030:EE_
X-MS-Office365-Filtering-Correlation-Id: 52759e07-26e1-4e8e-f887-08ddb59762b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uTez1NfJPOaz5ygL7fqqumjLjldap3bJbh6do2gJucyfcYoV3LDq/6QhvTsM?=
 =?us-ascii?Q?wEwvph5vHkgVq4RTJynDiCeOQZNlD3S8wD0lrzuvE5WomsWOvPvxhygAbeXX?=
 =?us-ascii?Q?sE4E5giBy9iieuuGTYQ06Frtn05Wy8togtwWjV5aVWUoPXoMDrDWvemfS3RN?=
 =?us-ascii?Q?zJwX6h2XoRG1faqdJcCuV76qPpb9wkQ3Ey0dUY9yl8sFdO9e7ySVxCw8S+vv?=
 =?us-ascii?Q?wsVnXXkKeWgw8IJqpsW21cqCGMGeP8TkFthw4f5vrHVqyH0hQefMoogkx3/Z?=
 =?us-ascii?Q?8rhnpsg65o0S5RyxFZkRtu+yp48vrUSINEm48OB3zXEbeZnlLOgn2VrMYO/+?=
 =?us-ascii?Q?wosx2sJQ5A4I7WTQooASHCnfyaNZodMaPlb7rvN05iSF2/nNVNICyGSz4XKY?=
 =?us-ascii?Q?A+fQWGrzMepZRO1M97BvWmnhr/YdiZvLTIVxJeYzRcURqfbtkeDS1q64Ws4h?=
 =?us-ascii?Q?QPgPJgUDvGfZA26IbRoo71Fm1h9VXDcOWEaDFDejNb5hJ9UGvFmqPn1nEtSN?=
 =?us-ascii?Q?J6BErHOwK15JASh5muYY9gaWNYYYb9eLo50fIlR96LUOyRmLrO5qbF3pu9GC?=
 =?us-ascii?Q?9d48NAYaktv3v3aUu+2Fpk5IP/VKFx8LNTmFyhCTQFEdLTK4g1k4+yCsVI9X?=
 =?us-ascii?Q?oM5jf3SjFc+Ov8tJmP3tR5c6VS01CFKl69YDwmb6gi7M/imFasAeEKu2eXvQ?=
 =?us-ascii?Q?ehWlWFSruYdGyO2/tS17YR8T3LsfVw29UGE63MyJCuOzgCBI97I86QrvnNgI?=
 =?us-ascii?Q?35j2pYR2NL+Z+gSTk2ElV2AZ0OjljpurOBIQNtIRF+/GJ06R7udVXx32JLAp?=
 =?us-ascii?Q?dhG70zasgxg9K2pooLxU6eIXZBKfJqlyUT4/dMvgN4tokuBOlhGvKEJH4LPM?=
 =?us-ascii?Q?oL01hxvjo9BZNavTM9IjDnomFlpXLKBhJ7PW7GyENdoJWm3pSo0lJnZiTl/2?=
 =?us-ascii?Q?cTJSznAmnifumTjiTliCPRtj/qXChngl85J5FSGeZ5E0hOPUhGgj2vK7mtbW?=
 =?us-ascii?Q?bzVd9wtFbauukeo2hkHar4bARWds+YfsIWF6X8E2ibv1s1XMU3wE4QzFe7K8?=
 =?us-ascii?Q?UZRLvhCix8YqIdann0UB1UtfiMdtwf7koO2GyxYflPFa2Tkw4aRbVJ5MHajW?=
 =?us-ascii?Q?kzmlWOUQZVEgwaY+FxDLRhAlJKdbhcIE3hIccH+Zj/+WSpV7fNel5qXesjjM?=
 =?us-ascii?Q?ixdALoh7Ifijkon0Yax0TI1Su2Cqc066LZNR+0gcSsnJi0JUlDamNr1Oy8Qm?=
 =?us-ascii?Q?z51fLVV61cg8o2hQZP6s0QHbFrZzEpt99Vf1tHprRtXRR6M93OISHTiyPb4x?=
 =?us-ascii?Q?5UJzILLQaK7j9zUpGs2BwLxU+Er/jJFGWDHp1gUC60mReCIWfV4IWMQwE65K?=
 =?us-ascii?Q?SXPzA0RNaYkl38OmyLlODCTBVrlYWahvj0Uq/JgtUUiE69E7HqC2LNVXRk16?=
 =?us-ascii?Q?xxpHPPAamJvIO0c/PZ3r3EpWIekWJVG4ZaIz0axqyFUBEXVwnuolqsdk9stW?=
 =?us-ascii?Q?hVcMFBxpjbLYV+k4ip9paF4XeLJuDyY873OP?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2025 16:26:35.6340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 52759e07-26e1-4e8e-f887-08ddb59762b1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000397B3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9030

From: Santosh Shukla <santosh.shukla@amd.com>

The virtualized IBS (VIBS) feature allows the guest to collect IBS
samples without exiting the guest.

Presence of the VIBS feature is indicated via CPUID function
0x8000000A_EDX[26].

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index d2ad0dd1e8db..32032e2ff961 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -379,6 +379,7 @@
 #define X86_FEATURE_V_SPEC_CTRL		(15*32+20) /* "v_spec_ctrl" Virtual SPEC_CTRL */
 #define X86_FEATURE_VNMI		(15*32+25) /* "vnmi" Virtual NMI */
 #define X86_FEATURE_EXTLVT		(15*32+27) /* Extended Local vector Table */
+#define X86_FEATURE_VIBS		(15*32+26) /* Virtual IBS */
 #define X86_FEATURE_SVME_ADDR_CHK	(15*32+28) /* SVME addr check */
 #define X86_FEATURE_BUS_LOCK_THRESHOLD	(15*32+29) /* Bus lock threshold */
 #define X86_FEATURE_IDLE_HLT		(15*32+30) /* IDLE HLT intercept */
-- 
2.43.0


