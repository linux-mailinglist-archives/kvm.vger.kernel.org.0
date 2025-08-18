Return-Path: <kvm+bounces-54867-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 24EC8B29953
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 08:06:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 10D5E189E3D8
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 06:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77A4526FA5E;
	Mon, 18 Aug 2025 06:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FxFh1d9k"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2069.outbound.protection.outlook.com [40.107.93.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5E0271453;
	Mon, 18 Aug 2025 06:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755497155; cv=fail; b=g7cUbElEeNZvXEEnquqJrRdOzdhXLZ1JByTytRhWBOJlGIaDMD0GkKNM4F6wetigjoOUuL+fmnk4MiywoCT8ve5iBlOI90Hcu9RUU36OIg7unSrBa2cUsZKXdI54nS+41tL52x8VoG97qcenHwrPYHFoUHYC4zs69md6+ikguIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755497155; c=relaxed/simple;
	bh=hKy0Q4awVuoyYaPZdUoiHKTwArinXyTtV8KaEKqCTXM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=evxYqpOC9ReiJ8gmBJn62a4ULgDJLF0mUq9c+5WCwY9QIgrKB2f7zmdMYWkU6Y/eiyXBIK97662mg7fCo5Q1LJtVHIYxWe2nGzM7ij4osbN3HRBhgKPAR6uvaIQj1Pb2ZsXWzPtwtWth3jhNsoQKsJNLH8ymObUCwjhXkCrfL/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FxFh1d9k; arc=fail smtp.client-ip=40.107.93.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D8pjk8RQkjn/az5Y4ItXh33MzGgF9oQL+aXZRvJLg3cPCDzdxpP+hTAMOHQx1yxzlvY+Zz6SqiOG04VfyzV/1mV5fhDP8RWLbZ+V6AbbrxdWQwQPgREjILgxIo6My2LEjDhZp8PBjfDx7tm/+aqxmLLkxxJOqXTdrpOcZsmKy/Xoac53v0+vPSFiE1Z90b5d+0aVQ4CLXbLlEZeFvx32xq34gwPZ52RNvzVBqBJoRrxpb75/CVENrFJ6UbVxEgVORc4nSlSgZhOLPCywHDFxGtWtN1Rq68WLBQ2zVQqjH/CS2mKzKNYzqFcVEpRSBtq/ERm3AGUuugeEaGqGhSMt5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BFtHSeTWqCV9cAFv7TU2tMCCfF2Nv3ggF6jfIhDH/Xo=;
 b=jbWBzO2fmne6NFd6BRppUUBImypIuQ7N7oHah/C/GzQXPXzI3u6HG5/KqxcDKQqzwUkx2MqdgnUNAodKJ+/X5E1oGJisSHU+p1AfWc+LELw2a7B9j8SRYyioUrpFXG/woEJLqklEAB38Jvk38r6hkHcR9++ZwKaRiQZn+NFaVc/2zhdqS6k5b51Wr8MlHRkSu8RTQi2EaR+1m6Fvh12V8BUapoqV3u4OTd/uoGHSlz7Yp+crGv+t4mJ/sShr8HZ9Eeiy0DouwFxPz3Ng5mBofOmNiLnctIlEdg5vtMCIBnZ25p7E0emX46Am/HESrKp7zcmN/VRiMcmIZMWx6qyAsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BFtHSeTWqCV9cAFv7TU2tMCCfF2Nv3ggF6jfIhDH/Xo=;
 b=FxFh1d9kS5SvFULdd1naavOqDmvTHek+Sdq4JJHvyuTkV1I1FJTZrRWpK3xAb44ntiDloiuXTzxmgkOUVrxQessynVKBVjiTdPpWZ00mOCoxytEewKDODjP2dww8J5g2MhNZuB2SAuesVTb6guKRvC9Nuo2xJcWgIxJzwoNK27s=
Received: from BYAPR05CA0068.namprd05.prod.outlook.com (2603:10b6:a03:74::45)
 by DM6PR12MB4250.namprd12.prod.outlook.com (2603:10b6:5:21a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Mon, 18 Aug
 2025 06:05:50 +0000
Received: from SN1PEPF0002529D.namprd05.prod.outlook.com
 (2603:10b6:a03:74:cafe::f1) by BYAPR05CA0068.outlook.office365.com
 (2603:10b6:a03:74::45) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9052.12 via Frontend Transport; Mon,
 18 Aug 2025 06:05:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF0002529D.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 06:05:49 +0000
Received: from BLRKPRNAYAK.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 01:05:42 -0500
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
Subject: [PATCH v3 2/4] x86/cpu/topology: Use initial APICID from XTOPOEXT on AMD/HYGON
Date: Mon, 18 Aug 2025 06:04:33 +0000
Message-ID: <20250818060435.2452-3-kprateek.nayak@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529D:EE_|DM6PR12MB4250:EE_
X-MS-Office365-Filtering-Correlation-Id: 09f16e7e-17ce-4a8e-947d-08ddde1d47ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|7416014|376014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AdJ4XXq5lX2zMir3ZtNjNwU8FqPBA1anFAkrzD4swS/yR8PAfw8lBRfkVZFw?=
 =?us-ascii?Q?YL+LJ4nRIhuEs7wVwy4/L4KHlj95Bia+/WcM2YJQOylamYC2fzDh+tjzd5rN?=
 =?us-ascii?Q?6dFxHjlA6hrUGJNIoTPzJyXqiuByo15Pnz3xasLrHPeOP2nMKPGs2+X10gsr?=
 =?us-ascii?Q?7JECRUFm0HpgKYiMo3d7EPqT3PwahfxRwuBgj8kPd71GLGYNqnvLqqZhVcwH?=
 =?us-ascii?Q?lt8sPaetd3Mg7js6FEDR+yYqPQfbPmCy1tONIR1VomqgnXwP+HveGMN156km?=
 =?us-ascii?Q?vGls7yKL/SCExM0q4ne3MreNFgQ8mCpiRAHpnY2FLcCOhzYXZmXS9K/oZdIl?=
 =?us-ascii?Q?8pOvhfy0dRF0Yft4MXXtBlam5xCrrRKIhvP5FBJrcXUiwNYAE5ajS/1Cld83?=
 =?us-ascii?Q?oow0njXuLkYYxI9mw0VUaifnxilhfmzFflQhhnE2/6EPC47XhAyAeVXWeoWA?=
 =?us-ascii?Q?ZgWXcvUy5nL5BUkN+WC6YUBTQUa1ea+IeYfgEHGzCM7MP+Fy3EyYniw/Ia/h?=
 =?us-ascii?Q?tsijttVJ47i51INtvl7dpysyhiz085v+wkvW/wAzZKvVCPw0r0jDYqKW2Imf?=
 =?us-ascii?Q?vWKFJcI5YozSyjLk8rGGRPCIfCvQUIQ3vv15jMQQxAn9Ta8vvFKnWWGwmOZb?=
 =?us-ascii?Q?q6xnBjz1Wqj405p2FQARK/8RZcK4jJhboe4kGhLP2BxAhBbBvoZmiL9nak7p?=
 =?us-ascii?Q?dbGT/2rsoQzaavtz2Kpo5L9V44dYJMMmTYzOsm51tfeXGHxqDe640p0pVLut?=
 =?us-ascii?Q?x8INtssVPZmbAiYLwfB9WM1HmmtcW/a6yOrQPcmhek6piAzV+Z3X08Mxe9t2?=
 =?us-ascii?Q?cgLxQtafBH1Tq3NH3PntDvOTXJhM26IWFXYt7QAwHnaJ8PnDkx3ksQF7WKWp?=
 =?us-ascii?Q?gYReVtBGnAz9SCQFB7UtBoKgBrYxrKlYBMysb8+WI04Vki/GPPIRDRofCZJV?=
 =?us-ascii?Q?ORW8ZTPjKJSN9L58RLepDrwn5rv47KKTfnQf67OMzHaTM8iRSorNs/owMRLa?=
 =?us-ascii?Q?Y1a21Mj0xkxfXccZ3dX5ONuRbbxE3F/W91bZ+DdmrHn4s5+0HiaUSCWzsB9D?=
 =?us-ascii?Q?WNYXL4oKzo1o0/QKCPVFmQlLAdgICk7cGRZcWjdPxOfhdY+f3/D3bU+ToFwG?=
 =?us-ascii?Q?Co7P1ah+pU/vwi25eyj1zUKF0XlQJMdfHncCDV10DvVmOir51redb/b7LJs9?=
 =?us-ascii?Q?2LXpBEYKaGqWtw/j2D4jvxer6II+//Yip62adySbRMds+YONwkoUYbaIHU98?=
 =?us-ascii?Q?gFnGJAUiGHVZO4HlHagGsB82viMXwph7ewG6KKSc57OEEJ4hgVn/pY04rM6Y?=
 =?us-ascii?Q?ihsQt+W2gZ2lGiNG0+HJzNFzNIqYn7x7J9iF/xn0qgV/YUfGtH/mcELACXnM?=
 =?us-ascii?Q?SLi/8sKtFlnc3NJ1G4hGZeW/Y9485CXkGSHqaU6N9pfETuIF7iECNKBwFhDn?=
 =?us-ascii?Q?4A2UbzOVVvfIjkRqWE0S3+8gkyVu6FiGF0noFqZXAod9FU27MMRuWw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(7416014)(376014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 06:05:49.8058
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09f16e7e-17ce-4a8e-947d-08ddde1d47ee
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4250

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

Rely on the APICID parsed during cpu_parse_topology_ext() from CPUID
leaf 0x80000026 or 0xb and only use the APICID from leaf 0x8000001e if
cpu_parse_topology_ext() failed (has_topoext is false).

On platforms that support the 0xb leaf (Zen2 or later, AMD guests on
QEMU) or the extended leaf 0x80000026 (Zen4 or later), the
"initial_apicid" is now set to the value parsed from EDX[31:0].

On older AMD/Hygon platforms that does not support the 0xb leaf but
supports the TOPOEXT extension (Fam 0x15, 0x16, 0x17[Zen1], and Hygon),
the current behavior is retained where "initial_apicid" is set using
the 0x8000001e leaf.

Link: https://github.com/qemu/qemu/commit/35ac5dfbcaa4b [1]
Debugged-by: Naveen N Rao (AMD) <naveen@kernel.org>
Debugged-by: Sairaj Kodilkar <sarunkod@amd.com>
Fixes: c749ce393b8f ("x86/cpu: Use common topology code for AMD")
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
---
Changelog v2..v3:

o No changes.
---
 arch/x86/kernel/cpu/topology_amd.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/topology_amd.c b/arch/x86/kernel/cpu/topology_amd.c
index bb00dc6433eb..ac0ba8495eec 100644
--- a/arch/x86/kernel/cpu/topology_amd.c
+++ b/arch/x86/kernel/cpu/topology_amd.c
@@ -81,20 +81,28 @@ static bool parse_8000_001e(struct topo_scan *tscan, bool has_topoext)
 
 	cpuid_leaf(0x8000001e, &leaf);
 
-	tscan->c->topo.initial_apicid = leaf.ext_apic_id;
-
-	/*
-	 * If leaf 0xb is available, then the domain shifts are set
-	 * already and nothing to do here. Only valid for family >= 0x17.
-	 */
-	if (!has_topoext && tscan->c->x86 >= 0x17) {
+	if (!has_topoext) {
 		/*
-		 * Leaf 0x80000008 set the CORE domain shift already.
-		 * Update the SMT domain, but do not propagate it.
+		 * Prefer initial_apicid parsed from XTOPOLOGY leaf
+		 * 0x8000026 or 0xb if available. Otherwise prefer the
+		 * one from leaf 0x8000001e over 0x1.
 		 */
-		unsigned int nthreads = leaf.core_nthreads + 1;
+		tscan->c->topo.initial_apicid = leaf.ext_apic_id;
 
-		topology_update_dom(tscan, TOPO_SMT_DOMAIN, get_count_order(nthreads), nthreads);
+		/*
+		 * If XTOPOLOGY leaf is available, then the domain shifts are set
+		 * already and nothing to do here. Only valid for family >= 0x17.
+		 */
+		if (tscan->c->x86 >= 0x17) {
+			/*
+			 * Leaf 0x80000008 set the CORE domain shift already.
+			 * Update the SMT domain, but do not propagate it.
+			 */
+			unsigned int nthreads = leaf.core_nthreads + 1;
+
+			topology_update_dom(tscan, TOPO_SMT_DOMAIN,
+					    get_count_order(nthreads), nthreads);
+		}
 	}
 
 	store_node(tscan, leaf.nnodes_per_socket + 1, leaf.node_id);
-- 
2.34.1


