Return-Path: <kvm+bounces-54868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CBE44B29958
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 08:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7B7E8189F009
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 06:06:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6E7271455;
	Mon, 18 Aug 2025 06:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="nQnAHyN3"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2073.outbound.protection.outlook.com [40.107.223.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF59F26FA5E;
	Mon, 18 Aug 2025 06:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755497179; cv=fail; b=NSNb91KXGWwHQ+K4OzFY+khYmK6gZdMJhSeYuZFRolp1uKZarf0lnGPFvFGg/edogKkvbDQqQ+sicqkiDEDUeHu1obAR+Mh9TnqzeO7/jadM2T9QZJuAvdM1n9bahI7xrsbBxT5mtiwC9x05D6j++FEYO5MtDwqwNyJEoRT5SIA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755497179; c=relaxed/simple;
	bh=61vBkg1VtJDji/EdPJ8VB8rDi1s8PkAaTzKBEkz3tcM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LE54olDzijQBOWKOAZ82W5Ii8edNRTxO3D7Ml+93D8hg3eJkEa9gJVQPkyMgglje9kAKfPQ5ea//dTB6VVWad9ARfrzPdBLcbxCxOiczq2QJSGtUHHvzJnQLEX+mzD4X3YdlStxr0uLUBOFxdSBmT2WOSR3Es961FMwGrt/+hEQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=nQnAHyN3; arc=fail smtp.client-ip=40.107.223.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y9o07zZYgDtN/UsJgtIaTcKJi5X7zM8yZhYMhUN0AN3pycBM0rwwAKX1S/QkzlaDlshnuZGI0jSemlnCdzffBDHUBHGMmEAC2ykHjwaKE5V/QxS/MZXLTCO71jEyPULCEuxkbAZspBkNZJIqGN1sl5LLbDTC/srxCx2s6y/Gas9pTan+oppJlARbJ0ykp1K4FntfX+3wvt4X7JURF118dV99Dmqe29tSuY2dgrIXiIGsMe56oJ8P97df/NSrFcJJTY8G1OElPJQjYM7dr3gpVIo6Yqu14gJtkXXe/GlgS0PmgwPBPhwE8T9xoIfq+28G4tXVkRT7i3El78miodwzaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=weWQi3mjuYUaDQFsIv40U3ZFEbKMZBmqY7tOG/ngF5Q=;
 b=gmHTcR2gGsB4conjy1sQef1gBNJnEpmGAqmfPaHyv6oAu30hUgTnInN5PYPf9c4h//CeMviiT9lDOPvtJy42aUyanAwYu524X0eO5CIXrb45r4yCgSi/8FD5LW+wvCEGTqfMdLDrCZ1lL2qIPn3bvQTYoBiiQiD8hwBXAP1NXCY+dInH5V63jOrPXmwqYRpAQU0LigxS8WnAyI7/jTNFnOwz8s06beQ8jh8RSNEyReGlV42wFJ4Iq1CEC3BJitaKEj5i8z8pdgamApt7kraPcGHLnq0Vtd2YbU7IpVFGoGX+xs0fn7fNqmbvKc1v+cTse4D/TlZ9wOeolTQT117ZfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=weWQi3mjuYUaDQFsIv40U3ZFEbKMZBmqY7tOG/ngF5Q=;
 b=nQnAHyN3uGe/+S67BqjSrq9T8qr1+a7vtj+ghI/iPFtbJ5S1Hg2FntybOxM79MBFtnHNFeHVbkR9+tYU0FG/crw3wPZAehyYiCYuIo8Y/zfxekpJwwqkAx3LVWYPYhD15eUTcLLu6JqCaUx0s/xUyD+ZSrNy1xj/P0ZTaLxBiPc=
Received: from BYAPR08CA0013.namprd08.prod.outlook.com (2603:10b6:a03:100::26)
 by CY8PR12MB7705.namprd12.prod.outlook.com (2603:10b6:930:84::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.18; Mon, 18 Aug
 2025 06:06:12 +0000
Received: from SN1PEPF000252A4.namprd05.prod.outlook.com
 (2603:10b6:a03:100:cafe::62) by BYAPR08CA0013.outlook.office365.com
 (2603:10b6:a03:100::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.19 via Frontend Transport; Mon,
 18 Aug 2025 06:06:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A4.mail.protection.outlook.com (10.167.242.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 06:06:11 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 01:06:03 -0500
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Mario Limonciello <mario.limonciello@amd.com>,
	"Gautham R. Shenoy" <gautham.shenoy@amd.com>, Babu Moger
	<babu.moger@amd.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>
Subject: [PATCH v3 3/4] x86/cpu/topology: Always try cpu_parse_topology_ext() on AMD/Hygon
Date: Mon, 18 Aug 2025 06:04:34 +0000
Message-ID: <20250818060435.2452-4-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250818060435.2452-1-kprateek.nayak@amd.com>
References: <20250818060435.2452-1-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A4:EE_|CY8PR12MB7705:EE_
X-MS-Office365-Filtering-Correlation-Id: e4dd1ec3-4e87-4fd0-c38b-08ddde1d551c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BdgcG7YRf7r9/eOUO5e5qvSQ5ucjCFQ/GNJ13SujWpW0/uaJGMo0His/5dYY?=
 =?us-ascii?Q?5KI2G3117Ge7p0OWNF8A9fssO1gwgOLMvy8BfOGPQCpHZw3ZJxmRo0evtvXT?=
 =?us-ascii?Q?Jt1qXJeqGwyUulHe/zf5K7Otr2Vbt06LXTPn8xcblJD76/4PlR4j7Qc//kh9?=
 =?us-ascii?Q?cNXasKaiVBQW4To2hZRLInA9qLUw/ifR0lh1CCkz4nnmys25srz/mP9t04ua?=
 =?us-ascii?Q?NAAGtQbr0RvqF9YnGr/Crxkly8IyEP4OC0UfaXcEu2QDnUSQjVFZmxPuMoB3?=
 =?us-ascii?Q?yM1ol1NwNVge+smqRKqrN6zoz5W1/8vcmRCVDuDAQrp4b7zDejXNnSiVerL0?=
 =?us-ascii?Q?nJ7lIYNd4eW2zCw3/mJ69g8CV3qpndWxf9UeCl6jnzttpWCIZdxXE7jnk/vO?=
 =?us-ascii?Q?xBCNXkkUPl2cksMslnvhYus7xrpNcTE7vDkE9iPvkqV6AGP3gF3bJNv2S/GQ?=
 =?us-ascii?Q?hPyI3cGw1JwOR0HqWDiQXQuLaAh97CIVrV3tdB8CHkvVMt60MZEetq6Jrtcu?=
 =?us-ascii?Q?URuxu++Chb84Pcja4R3/gYiHyxV8LS8aIGnY+7K+6ruGBrSXyOw+eSCKxnsV?=
 =?us-ascii?Q?kDxMheZ0WoYq4QhLBERfGXgmu1wMOiInDDUN8TJSFz0I9z0aNabIKsC5AgIw?=
 =?us-ascii?Q?hxh8PGULa0PUbhbY3J2Hl2dU84R36098/XdoEAgpRAF0G5SDBzugnGxsDO1d?=
 =?us-ascii?Q?n4OdphZNJS9CJqgq7G5FNts8BIImZH66BU/9mTfAOeYAs91C7cThgkxPir6e?=
 =?us-ascii?Q?Pvqsu3PV+6ERKnzc9tQvFF8bBWz44m0vNDW4w2BTsMgTGdeeapsr/1Logy19?=
 =?us-ascii?Q?ccx+wcc1Oef7SZfMJEysTu3v7THYXPskoyurxMKsO2hmVpMyXFRymIgLioIf?=
 =?us-ascii?Q?98LVATKagdwxMWn41elgn3rgLh8nK5Oa7B91jBpjJMXXWic8P2HyCSCvx12R?=
 =?us-ascii?Q?r+f8rajrsXy4fyBF2NUQFnSujzsdPGvWqQIUBz/bcdXKvs6ktfRlrhLbGwG/?=
 =?us-ascii?Q?CfRUgWc4JRs/h9zTBr48qbpY1lZU3nUj5xDy6xPCbVu/x1ElUIRiQGAfY/38?=
 =?us-ascii?Q?mf0cVSTxTcAiAVjjYthphljDpFQjUKACaZfJDk4+NVyhd0pXG+bqril+3uRi?=
 =?us-ascii?Q?8LAfOZUxmPULHwAsg9w1vsTC8WdzB2yJLMoAj7anzNOw2iBZeREMzRE2B4+4?=
 =?us-ascii?Q?vXmxsGpxCTiWftiKBSctTGDgnpNgI8hGSxeZqc3jWDHpZhrFUOJsQWmOD/ka?=
 =?us-ascii?Q?oME591HUaYaSBJ/Lb59rWuLoDQQg1Av7Gvc0AvPwZ1eXFZGhxF0WDTv102/w?=
 =?us-ascii?Q?8h8FyISfhmUe3kjQ7QMp71HrhLtOHHBak0KMxmTHp7+GgXNsdnsEfJZMouPo?=
 =?us-ascii?Q?W78VCpLr7d0PzELS1nX318UDja1wm+iXssLE/LfLbebECz9qORQ0Qwo6iiMo?=
 =?us-ascii?Q?a0RlevH0IoWeH57yCT8mv4ymrbdNwQ7eG9YHDG374wLG6jGbJ7vECA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 06:06:11.9106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e4dd1ec3-4e87-4fd0-c38b-08ddde1d551c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A4.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7705

Support for parsing the topology on AMD/Hygon processors using CPUID
leaf 0xb was added in commit 3986a0a805e6 ("x86/CPU/AMD: Derive CPU
topology from CPUID function 0xB when available"). In an effort to keep
all the topology parsing bits in one place, this commit also introduced
a pseudo dependency on the TOPOEXT feature to parse the CPUID leaf 0xb.

TOPOEXT feature (CPUID 0x80000001 ECX[22]) advertises the support for
Cache Properties leaf 0x8000001d and the CPUID leaf 0x8000001e EAX for
"Extended APIC ID" however support for 0xb was introduced alongside the
x2APIC support not only on AMD [1], but also historically on x86 [2].

Similar to 0xb, the support for extended CPU topology leaf 0x80000026
too does not depend on the TOPOEXT feature. The support for these leaves
is expected to be confirmed by ensuring "leaf <= {extended_}cpuid_level"
and then parsing the level 0 of the respective leaf to confirm
ECX[15:8] (LevelType) is non-zero.

This has not been a problem on baremetal platforms since support for
TOPOEXT (Fam 0x15 and later) predates the support for CPUID leaf 0xb
(Fam 0x17[Zen2] and later), however, for AMD guests on QEMU, "x2apic"
feature can be enabled independent of the "topoext" feature where QEMU
expects topology and the initial APICID to be parsed using the CPUID
leaf 0xb (especially when number of cores > 255) which is populated
independent of the "topoext" feature flag.

Unconditionally call cpu_parse_topology_ext() on AMD and Hygon
processors to first parse the topology using the XTOPOEXT leaves before
using the TOPOEXT leaf.

Link: https://lore.kernel.org/lkml/1529686927-7665-1-git-send-email-suravee.suthikulpanit@amd.com/ [1]
Link: https://lore.kernel.org/lkml/20080818181435.523309000@linux-os.sc.intel.com/ [2]
Suggested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v2..v3:

o No changes.
---
 arch/x86/kernel/cpu/topology_amd.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index ac0ba8495eec..3d01675d94f5 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -179,18 +179,14 @@ static void topoext_fixup(struct topo_scan *tscan)
 
 static void parse_topology_amd(struct topo_scan *tscan)
 {
-	bool has_topoext = false;
-
 	/*
-	 * If the extended topology leaf 0x8000_001e is available
-	 * try to get SMT, CORE, TILE, and DIE shifts from extended
+	 * Try to get SMT, CORE, TILE, and DIE shifts from extended
 	 * CPUID leaf 0x8000_0026 on supported processors first. If
 	 * extended CPUID leaf 0x8000_0026 is not supported, try to
 	 * get SMT and CORE shift from leaf 0xb first, then try to
 	 * get the CORE shift from leaf 0x8000_0008.
 	 */
-	if (cpu_feature_enabled(X86_FEATURE_TOPOEXT))
-		has_topoext = cpu_parse_topology_ext(tscan);
+	bool has_topoext = cpu_parse_topology_ext(tscan);
 
 	if (cpu_feature_enabled(X86_FEATURE_AMD_HTR_CORES))
 		tscan->c->topo.cpu_type = cpuid_ebx(0x80000026);
-- 
2.34.1


