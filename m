Return-Path: <kvm+bounces-55597-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB18FB33855
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 09:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 760ED177D8F
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 07:58:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8E63299A94;
	Mon, 25 Aug 2025 07:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tSzE352A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071.outbound.protection.outlook.com [40.107.223.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F59B28A73A;
	Mon, 25 Aug 2025 07:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756108706; cv=fail; b=Yxfvi0BhPevr9GAoHIEU7YINqYbh4hAKAHqcdU1U/r0zXvOLZdFPFBa0199EOjYcLquob0DJzmNHbKoAYaM7RfXmn6lHT2IFnjJwWCWdo/af954P4LUGAgMLmhQK3fWgTSGmeH1/CJlLHfA7PY+DakvbUSe8WCF7lePhb8Ged4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756108706; c=relaxed/simple;
	bh=5YTQdeMaI9DurD1t8EX0y49ivXTMTfkw5pJyIfQTRsc=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UV9o26sfYzuI9+kIhXnSL6maaTI0vy6spMCqls/vDX2dnA6I1meKC1mxHoHyGAxcVKgrstNvpw7y3iYlV44GOVNJjNqFnSIZpnrr/VISXuujmk4xJZJkwJ9g41XMEmUmfvje8RVKJAjykf511Lszc6GKpTRq7QfcHTKLm2rgvCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tSzE352A; arc=fail smtp.client-ip=40.107.223.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KwCDo6GdIBqD/LGgSt/Qj7F2Wpxck19f8lonH9gnx77U5n3OrMPbDgYFWQAfL7c0Hg4IN8U/EdqyEJiAfWUq3X/E8ztLuQ+e3uahtfb1LVG3KIU4S3A5AM93fOecrNLaINBHfCt4h8mVq8c7UublECxNBIDJHQP0NvMSRhBslTZz8CPNSfmGOCNf8hFOv1Y6qZ+yrK9AQtkMMgFMnqdUdC/FDKKnYgrIAPce88B/RzxZagqwk5EZs8dwp9Cx8zp82jkBZG49wfBGRHIN6oY6rmg5N0pwThnXHEOEy7pCnq+L6pAzt/iwHeFosclqh7rNT8OOVXUMVVnx8m8zz4pILg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iueddIUyFu8PVbO61lHKpSv9sxbUhllSHgn51tlLGRE=;
 b=Pcg3BW8eIKKjGbk9Mg/mQtMrY6q+vL7kom+48SljU822d5FkW93oUi3tDDvdnAdNfP0AkVlI9MtkqTzJJBYFIcnHGDN0gqcw5vtitoTrV0AaD5CB7VkskN7FYwXHpcRvaCLh/R7Qb4i93nhP4pD4oauXBX0UMcngsui6PrdO0yBLeouY6PTtV/jUyRX+LKC0vayHzaeLK6PpzT2WshfFx2ey6xz5FDTlEwgnvPPEJQXBL+6c4P4gRFqwK8GwZZ9AeQONYg4sKOaM9YYZA/w8A4uIFMS7eTZ+r1z+P+DL4oSDsug1fF40gcucYWVRbVXc/dU0yRqV0mCiCIp9o3Ss5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iueddIUyFu8PVbO61lHKpSv9sxbUhllSHgn51tlLGRE=;
 b=tSzE352AMT4AV0gM3Y25VobidHKIrnQkkGnICDACAJeSDjI0Wbdo9TFKP/hgyrSlyvM3tmtPJUXgisYfk815/eg0vKmaVo6xqf+T3itgvsWTaA/FaYv7TAdgxcmHXLDdpJnxp+QyRHBDiiDSAEudOccVPgiqQXfM+6dSe6oIiX8=
Received: from SA1P222CA0074.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::20)
 by MW4PR12MB7333.namprd12.prod.outlook.com (2603:10b6:303:21b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Mon, 25 Aug
 2025 07:58:20 +0000
Received: from SA2PEPF00003AE7.namprd02.prod.outlook.com
 (2603:10b6:806:2c1:cafe::c9) by SA1P222CA0074.outlook.office365.com
 (2603:10b6:806:2c1::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.22 via Frontend Transport; Mon,
 25 Aug 2025 07:58:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00003AE7.mail.protection.outlook.com (10.167.248.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 25 Aug 2025 07:58:20 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 25 Aug
 2025 02:58:12 -0500
From: K Prateek Nayak <kprateek.nayak@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	<x86@kernel.org>
CC: Naveen rao <naveen.rao@amd.com>, Sairaj Kodilkar <sarunkod@amd.com>, "H.
 Peter Anvin" <hpa@zytor.com>, "Peter Zijlstra (Intel)"
	<peterz@infradead.org>, "Xin Li (Intel)" <xin@zytor.com>, Pawan Gupta
	<pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Mario Limonciello
	<mario.limonciello@amd.com>, "Gautham R. Shenoy" <gautham.shenoy@amd.com>,
	Babu Moger <babu.moger@amd.com>, Suravee Suthikulpanit
	<suravee.suthikulpanit@amd.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
	Naveen N Rao <naveen@kernel.org>, <stable@vger.kernel.org>
Subject: [PATCH v4 1/4] x86/cpu/topology: Use initial APIC ID from XTOPOLOGY leaf on AMD/HYGON
Date: Mon, 25 Aug 2025 07:57:29 +0000
Message-ID: <20250825075732.10694-2-kprateek.nayak@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250825075732.10694-1-kprateek.nayak@amd.com>
References: <20250825075732.10694-1-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE7:EE_|MW4PR12MB7333:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b305f79-04f4-469b-66c0-08dde3ad2861
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Vn42lhETOt2eEFi57SbaTi024fClt2YdxNvAtlXldqjpQrQ42hJFbhJABph4?=
 =?us-ascii?Q?8+GNf/0W30C7mB7db+fRgu6sNXA5W2DTDCVjJcOTYceHlHw6eRX0uLAruwvG?=
 =?us-ascii?Q?6Pkaf0N9/Yftmh9kF54LskCedUTodPW/fzdu1eCAisv6SbiQdmIk96N8fJg7?=
 =?us-ascii?Q?c+Vrx5WwschbA/JmXBvtGA4GunfC1XO7gYUtYOjTU5Y1fDguizXeTP3SooVe?=
 =?us-ascii?Q?U/t/txz3S7GxLXmhCBaZYU7F6w7aM+O+PfXLlxGMsQqpS3lDLQzqMZbaUTna?=
 =?us-ascii?Q?Jexdhc4nEiy5bwCeJIGJqn73frWechr+vFTPBIdE4xJy9qRNsbGK+4WArART?=
 =?us-ascii?Q?vG+F3+AknpUrIXrPQei4iArd8r0lTKAGOaQbVautDTN+OrXlZcqeCjoJn7Kf?=
 =?us-ascii?Q?o2c9RWAqPLU8++Ul4RR9mKypzFU1yJb56yXl2WLU1fKz6M6ERwxs13SddM1J?=
 =?us-ascii?Q?5VkRGKzHcqX7yhv040ZEP531fCeRsWg7fZw9kJddm0rL2IBhvFybBAmM1XF+?=
 =?us-ascii?Q?dNSBkh5bOJgSSuzVhya+HCu5yYA3Jzwy8q3pijdsBFKqt6LsUvYsC0nhGZNp?=
 =?us-ascii?Q?Nrk0E2uKgTGHRP5cv0W52ZgEGp82zwQQHIrKAY1yDezh4VhR2wYGVMIv6a2W?=
 =?us-ascii?Q?Xi0wZZr+M6Nlz/UyyI4Xo4IlwauLH0yBg7d+dEuww03cgwZpndoIZjVi779i?=
 =?us-ascii?Q?xx7hDOTDtls8S5v2uZfkGRRpswxOxzidXRFGcjPSUsE133BM9mWSvuROZEZs?=
 =?us-ascii?Q?8LNC1oUDuLi4T1IVAHMx8O+9MozDAMXgQR0jNWd5pGFb08Jd/s6fOw9xqT+a?=
 =?us-ascii?Q?iG+z1V+uKx2tqi4McfQnafUk2x6SQfbyWCBH16pKCW9Qn9Ok/c7J8CwBaMtv?=
 =?us-ascii?Q?egH1ITX8qcl3qd8TcnjhcIU0OFjBqRcx2wm8/DMYQotXY4zZuvDhAH6M8eTU?=
 =?us-ascii?Q?EH+2dwR34cJJYhrUrGbkBoHQhC/LL3E4hPYIMhaHcyepJVLkNiIhJMtt/UXW?=
 =?us-ascii?Q?qLXG9k/d8U3iHBy+/NCba7MaN3UlO3v/mZmo0dmBWCeWC75po8IcNnU8z2vI?=
 =?us-ascii?Q?tos9nJPYUYxHfCLA3cfLEBKCcu2MLYHLrnMg3oJMx9rHbP7DHSazhaFWoYsr?=
 =?us-ascii?Q?d0e2UrkVttpA/um2Z93IDTes/NLTM77CoBiSaSfESw1LbOXGLockmqcMD/k0?=
 =?us-ascii?Q?7K9YGsueIIcxGyWpyOGIpNj38opWuj8tnIjot8JN8TgfwwgPiAJENW4kWy1z?=
 =?us-ascii?Q?5J9mCBe1Jm4WyZ3vewFYTE39+zi/8kn+5HRTFfkgvkpYiThedftEqN7RMKkm?=
 =?us-ascii?Q?9oLaECuflgF9njImXjluODiCUqyJ8+SWVSWfPM/W7jXROmFAARludmWrvvHh?=
 =?us-ascii?Q?A5D4V2Sj0ipsunl4clfWFNo44LeCyTlOid/+t0mkdNPef2zcxkVJjpzcnt7h?=
 =?us-ascii?Q?7EPwjdE5iqX5Bqi+qHUy9rYj4W0gpqxNqbFkGHQw4CGt63gAXH7LPkcx7X83?=
 =?us-ascii?Q?3MP++0BN10DRpLLZMrV+oCDm/wqlwdN7TI/08DM2Iktn2K8TPa8bN8nDWQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2025 07:58:20.2144
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b305f79-04f4-469b-66c0-08dde3ad2861
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE7.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7333

Prior to the topology parsing rewrite and the switchover to the new
parsing logic for AMD processors in commit c749ce393b8f ("x86/cpu: Use
common topology code for AMD"), the "initial_apicid" on these platforms
was:

- First initialized to the LocalApicId from CPUID leaf 0x1 EBX[31:24].

- Then overwritten by the ExtendedLocalApicId in CPUID leaf 0xb
  EDX[31:0] on processors that supported topoext.

With the new parsing flow introduced in commit f7fb3b2dd92c ("x86/cpu:
Provide an AMD/HYGON specific topology parser"), parse_8000_001e() now
unconditionally overwrites the "initial_apicid" already parsed during
cpu_parse_topology_ext().

Although this has not been a problem on baremetal platforms, on
virtualized AMD guests that feature more than 255 cores, QEMU 0's out
the CPUID leaf 0x8000001e on CPUs with "CoreID" > 255 to prevent
collision of these IDs in EBX[7:0] which can only represent a maximum of
255 cores [1].

This results in the following FW_BUG being logged when booting a guest
with more than 255 cores:

    [Firmware Bug]: CPU 512: APIC ID mismatch. CPUID: 0x0000 APIC: 0x0200

AMD64 Architecture Programmer's Manual Volume 2: System Programming Pub.
24593 Rev. 3.42 [2] Section 16.12 "x2APIC_ID" mentions the Extended
Enumeration leaf 0x8000001e (which was later superseded by the extended
leaf 0x80000026) provides the full x2APIC ID under all circumstances
unlike the one reported by CPUID leaf 0x8000001e EAX which depends on
the mode in which APIC is configured.

Rely on the APIC ID parsed during cpu_parse_topology_ext() from CPUID
leaf 0x80000026 or 0xb and only use the APIC ID from leaf 0x8000001e if
cpu_parse_topology_ext() failed (has_topoext is false).

On platforms that support the 0xb leaf (Zen2 or later, AMD guests on
QEMU) or the extended leaf 0x80000026 (Zen4 or later), the
"initial_apicid" is now set to the value parsed from EDX[31:0].

On older AMD/Hygon platforms that does not support the 0xb leaf but
supports the TOPOEXT extension (Fam 0x15, 0x16, 0x17[Zen1], and Hygon),
the current behavior is retained where "initial_apicid" is set using
the 0x8000001e leaf.

Cc: stable@vger.kernel.org
Link: https://github.com/qemu/qemu/commit/35ac5dfbcaa4b [1]
Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 [2]
Debugged-by: Naveen N Rao (AMD) <naveen@kernel.org>
Debugged-by: Sairaj Kodilkar <sarunkod@amd.com>
Fixes: c749ce393b8f ("x86/cpu: Use common topology code for AMD")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v3..v4:

o Refreshed the diff based on Thomas' suggestion. The tags have been
  retained since there are no functional changes - only comments around
  the code has changed.

o Quoted relevant section of APM justifying the changes.

o Moved this patch up ahead.

o Cc'd stable.
---
 arch/x86/kernel/cpu/topology_amd.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index 843b1655ab45..827dd0dbb6e9 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -81,20 +81,25 @@ static bool parse_8000_001e(struct topo_scan *tscan, bool has_topoext)
 
 	cpuid_leaf(0x8000001e, &leaf);
 
-	tscan->c->topo.initial_apicid = leaf.ext_apic_id;
-
 	/*
-	 * If leaf 0xb is available, then the domain shifts are set
-	 * already and nothing to do here. Only valid for family >= 0x17.
+	 * If leaf 0xb/0x26 is available, then the APIC ID and the domain
+	 * shifts are set already.
 	 */
-	if (!has_topoext && tscan->c->x86 >= 0x17) {
+	if (!has_topoext) {
+		tscan->c->topo.initial_apicid = leaf.ext_apic_id;
+
 		/*
-		 * Leaf 0x80000008 set the CORE domain shift already.
-		 * Update the SMT domain, but do not propagate it.
+		 * Leaf 0x8000008 sets the CORE domain shift but not the
+		 * SMT domain shift. On CPUs with family >= 0x17, there
+		 * might be hyperthreads.
 		 */
-		unsigned int nthreads = leaf.core_nthreads + 1;
+		if (tscan->c->x86 >= 0x17) {
+			/* Update the SMT domain, but do not propagate it. */
+			unsigned int nthreads = leaf.core_nthreads + 1;
 
-		topology_update_dom(tscan, TOPO_SMT_DOMAIN, get_count_order(nthreads), nthreads);
+			topology_update_dom(tscan, TOPO_SMT_DOMAIN,
+					    get_count_order(nthreads), nthreads);
+		}
 	}
 
 	store_node(tscan, leaf.nnodes_per_socket + 1, leaf.node_id);
-- 
2.34.1


