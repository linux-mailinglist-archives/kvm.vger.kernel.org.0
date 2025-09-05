Return-Path: <kvm+bounces-56926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F2035B465CE
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 23:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0296A1888F97
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 21:40:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE3DA2FF173;
	Fri,  5 Sep 2025 21:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0pGEsTy4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2052.outbound.protection.outlook.com [40.107.95.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ED228000F;
	Fri,  5 Sep 2025 21:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757108239; cv=fail; b=f2Z4ANG2VQoQBlTFvXFyAJfYZu2IHmzl3nV/IwPVVjYupxB7rFWM9HG0suW98yhwSltDEIhjwxJ2z1w4795z9Eov7XnBWO+XLlxzJTzZ7mXH0flNa3ryd/IPbuewjIxkdUNWOR1dhXMbpTnBkKOzNwV62yeQ5o6KU8q0BvPRMoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757108239; c=relaxed/simple;
	bh=zCOhdVlLPgdE99Nq9ALqIkv+NyXipDRW6i2WwEE41+Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nORcoAeBfdA7wwo74RKf89kaQQk16zBUDfikOsIC8nxbB3k74XCy0Mxc7MKq+28CtQpCWc2rc513I2bfWw4xXXB/MV3oqWtQDBRwBxhbbfWEn0KU45HH0eF+R7051NhBvLW0tK3WPORUBrHHBkxu+kZH+o8c4JjXHqfRNNS/jJI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0pGEsTy4; arc=fail smtp.client-ip=40.107.95.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VGGy+dHvGi8XNqHIvEm6XPM3AF2eI8JajVpSbuFwJBTs4Z4dEWdwLTu3JUk+GTQvMNXMEP7AhjXFJsyVXfk0dOeb86WgvywaMmw8XUUSxjHrGp3C9zLu9OsAGzdmwjS/Dq4hyZ9mhTaVpj1ZdaTMUaj0/X3RItEVGGYktLihhTuHgmziWfT83EddHz8ByR/ldrov7tJBDin6WBw8jl2R0Cdvs/99EsrR9n23lQtor566U5n8R01f7Mi3B6ukm6fcpEHbjj8cWilFRtWqtQ/c4dG75OMW8jrTQ78OxouWma4EOzfP23TATjLW0Nld6eSwLpYnGsqtVIhv4kqUvCt5kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GKyjM31LMvaMPG1qpxRPFH7uoKJ1P00yPhmDt0nfjWw=;
 b=gFK7mEEfCF5iBQp2m2OfR7nkRGxYCN6gYSxHpXuFko43DbBioRs5SXq7/wGEbo8ViYeoWw5hzmQv1/uDvaSBBNlqKaA4dTlPDpZcOcLIvnkZbWwrkYZdR+VhpfHVhAOwmynAhPT1L+NuMgbHhgTDCwVNq3vW7Zx7bjZo3hpOlcazSPxFHTUqhhNrmY3OAxbS7X6V6VU4FsEHF7+cvcGW3ypLEALEkf7aMPTQFVPRMfAosG0/0fqXJ9/Y1ydSLJlG4pgBGfXbWep4WiY8stkPZQt3ER02HoyTuyYi8mZXDaCVIYKsw0NGaxMZnVs+yUu7GclBZG1XFKFfdhYZFafogg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=lwn.net smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKyjM31LMvaMPG1qpxRPFH7uoKJ1P00yPhmDt0nfjWw=;
 b=0pGEsTy4d1dEx2BaZtz2uzc0idX7/uPdIpTOXF6NqUWZFFmU3sUecq69JGiMK+FotXmpdb/BMeBYop4S3WbrULgmfxkV1djFKl7UDxgPvzCmXt39FOD2SwAWFNa6fGO2v3brEwP5I8lqX2CexhR4KP719Q8Z4Nxmw3FR/tYC3mc=
Received: from BY1P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:a03:59d::12)
 by PH0PR12MB7471.namprd12.prod.outlook.com (2603:10b6:510:1e9::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Fri, 5 Sep
 2025 21:37:12 +0000
Received: from SJ5PEPF000001F3.namprd05.prod.outlook.com
 (2603:10b6:a03:59d:cafe::b) by BY1P220CA0010.outlook.office365.com
 (2603:10b6:a03:59d::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.21 via Frontend Transport; Fri,
 5 Sep 2025 21:37:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F3.mail.protection.outlook.com (10.167.242.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9094.14 via Frontend Transport; Fri, 5 Sep 2025 21:37:11 +0000
Received: from satlexmb07.amd.com (10.181.42.216) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 5 Sep
 2025 16:37:05 -0500
Received: from bmoger-ubuntu.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.1748.10; Fri, 5 Sep
 2025 14:37:02 -0700
From: Babu Moger <babu.moger@amd.com>
To: <corbet@lwn.net>, <tony.luck@intel.com>, <reinette.chatre@intel.com>,
	<Dave.Martin@arm.com>, <james.morse@arm.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <babu.moger@amd.com>, <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <frederic@kernel.org>, <pmladek@suse.com>,
	<rostedt@goodmis.org>, <kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>,
	<seanjc@google.com>, <thomas.lendacky@amd.com>,
	<pawan.kumar.gupta@linux.intel.com>, <perry.yuan@amd.com>,
	<manali.shukla@amd.com>, <sohil.mehta@intel.com>, <xin@zytor.com>,
	<Neeraj.Upadhyay@amd.com>, <peterz@infradead.org>, <tiala@microsoft.com>,
	<mario.limonciello@amd.com>, <dapeng1.mi@linux.intel.com>,
	<michael.roth@amd.com>, <chang.seok.bae@intel.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<peternewman@google.com>, <eranian@google.com>, <gautham.shenoy@amd.com>
Subject: [PATCH v18 14/33] x86/resctrl: Add data structures and definitions for ABMC assignment
Date: Fri, 5 Sep 2025 16:34:13 -0500
Message-ID: <1eb6f7ba74f37757ebf3a45cfe84081b8e6cd89a.1757108044.git.babu.moger@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757108044.git.babu.moger@amd.com>
References: <cover.1757108044.git.babu.moger@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F3:EE_|PH0PR12MB7471:EE_
X-MS-Office365-Filtering-Correlation-Id: e543aa44-507d-46c1-1314-08ddecc45fc0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|82310400026|7416014|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?VG0rektVZU5rdzg1aU9USUY5bTY2L245aFhQWnlSamkxUUJQYnNHQ09zb09Y?=
 =?utf-8?B?L05UUFJBWFY0eW9aZUlIalBHOElVSzVYc0NWMFB1Nm55UVVETEpLazR6Rnlp?=
 =?utf-8?B?UEVTV3V5K3I2TmNiZDduek9FbVZacFd4ZVl4MW5iYXFwa05acllxUnF1cmN4?=
 =?utf-8?B?c2tRR1luZDg5d2l0N3A5dkk0M21EbE45OGhEUHlUcFZlZWJhUVRrLzQ3TlA1?=
 =?utf-8?B?WU9jVjgySkpOZnBjNTd5elJ1K2hUYXdiYjJuTTV5UExSNUhTbVdoMkVxQnlk?=
 =?utf-8?B?YlNqTFM4cklIQ2taVG5hdzlNc01VbXBlWG1Xb1J1aUNpYndqUCtQeGlJdTQ0?=
 =?utf-8?B?Rnh6ZFJIdmZjQ2NQKzBlK1FPdVBlaEFNTXZHaWtyY0M4dU1aZ25wcXVOMVYr?=
 =?utf-8?B?SE1YdFZ3Y3VESFNxWDkzOXpZK3h2T01xelNVckYzVXh6dWVrOUpNeTlMVVpz?=
 =?utf-8?B?b3pSZEw5cWhtcWFJQk5lVC9wWFhibHVtVGh6STFUeGhQNCt6MklwOUZpNVJB?=
 =?utf-8?B?ZkdMMy83SEpybWNYVlJ0eUxqU0lOTWRWN29obno4MHh6KzFqZHArdFplTWFS?=
 =?utf-8?B?K0FweDBTMUp6em40dFdGTUFrVVFUR2cwS1pndHZsZnJwRDNXUnVOTU9pb2tw?=
 =?utf-8?B?L0VkdzFYVjQrVkRXZXZ1TGE2dXJjWmZXSVJBVG1UUDhFempJNENrZWpJdkZy?=
 =?utf-8?B?MlB3R0JtNm1YdVFhSkc4K2FDN0xsbUcrZDdhVVRSbmN5Nlk0VTA0UzRXR28v?=
 =?utf-8?B?ZGE4MHlwYmZqRE8wV05kYmNaZW9ENWR0SThNN3ltcWwxVTY2aDk2MTZkb2VH?=
 =?utf-8?B?cGdzeEZGNU9Ldms1amsxMytYRG9XYTA2Y2xHZE9mTWM5aTZDSkVpUXNIYmd2?=
 =?utf-8?B?Vi81R3RhK2xTOWRLc3hRLzI3c3ZCNTFVeWt1Uk1Sc1FzQ2QyclRxNlMwUGx3?=
 =?utf-8?B?TlVFVDVLYXBZV2hNLzY3UC9QYURnSERVRnByazJzMitqcjM2N0c1TThIQUJX?=
 =?utf-8?B?Rk5QMWI5TWEwV0dNcjdRMSsyK3BaUzRtb1BMWVorN3VaUTZFYmNoa2Rzcm5t?=
 =?utf-8?B?MHVGUnpPU1NuZ25kMldkRnJ6WktISnpLd21ETDRDVWtxQ09pd1lKbkJqelJr?=
 =?utf-8?B?aGgxYURMd1BrQXpCMGQwVU9ZWC9mL0QrQUVlb3hZWjFSN0NnR2RiQkRUZnZF?=
 =?utf-8?B?WHdwTEVlQTQ5dXg0WnMzVkNvVEhLNE1KbERZUmp5QUZHRUV6eXBmVi9ndW9O?=
 =?utf-8?B?MDUxbmtWSHhyVlN2aWV2eFdhRXdXWEJIK0NOb2Z1a2tJdjYzTnRpMTVML2h1?=
 =?utf-8?B?bHllTE0rNWRYc2FBd2crVkpHYit1dm4xSnpVNkY3Z0pMUVpKNTZUclJkU3Qx?=
 =?utf-8?B?Vy83TWs2QWJidENMOUFOUm9MMVAzZkkvNlVHVHMrNnU5b09Wek1mTWxmSWt2?=
 =?utf-8?B?a0pkcU9tNU5vblFrbGVNcDZUcTJwM3BEU2RFa3MwMTkzRDFFRHphcVM5Q1RT?=
 =?utf-8?B?Q3hxK1BjR3Rza2wxMHI0MnIvd1RKdVB1MHJYcDYwT09tQ09GQ1JCRzVweTNm?=
 =?utf-8?B?dzlDQ3NoWVFndEp0bnkzbEZpS0YrU2J4N0p3VG0zcW44RG9jRzRPMzQyN1Z3?=
 =?utf-8?B?MjNTSU9QZlZ1NUs5dDlvWGlMWnQyOUd5SVRpbVcvL0QrUG9VZkx2M0pFYnBt?=
 =?utf-8?B?TjhWb0lzOTFCV0lONE9IaWlzREcwR1k2OWdSeHlxZTlqOG82M042NWNUbEYy?=
 =?utf-8?B?TFYvWGRxbkpNUElKMEZvN3RiOGk2NWorKzhPRFZyRGxZdDNiWU4vbXo5OGkr?=
 =?utf-8?B?eGJDM1N0WjMyRGdkcW5qWWxSY0ppajZ2ZWFHUmFDNnZCb2JIcTVUTis5NG1I?=
 =?utf-8?B?eHlaaWxqRjFZaG9hNkFIdGJqOXZVOEx0Q3lZOGhSR1o3czQvMUg1QXk0Y1Bl?=
 =?utf-8?B?bXJ5SGJVY0NiUm9YNjFjc2Q4cXEwSXRITmRqQXBNRXhJSEFTRFRIQ0IxVnlh?=
 =?utf-8?B?ODZiOThWeXB3PT0=?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(82310400026)(7416014)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 21:37:11.9303
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e543aa44-507d-46c1-1314-08ddecc45fc0
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7471

The ABMC feature allows users to assign a hardware counter to an RMID,
event pair and monitor bandwidth usage as long as it is assigned. The
hardware continues to track the assigned counter until it is explicitly
unassigned by the user.

The ABMC feature implements an MSR L3_QOS_ABMC_CFG (C000_03FDh).
ABMC counter assignment is done by setting the counter id, bandwidth
source (RMID) and bandwidth configuration.

Attempts to read or write the MSR when ABMC is not enabled will result
in a #GP(0) exception.

Introduce the data structures and definitions for MSR L3_QOS_ABMC_CFG
(0xC000_03FDh):
=========================================================================
Bits 	Mnemonic	Description			Access Reset
							Type   Value
=========================================================================
63 	CfgEn 		Configuration Enable 		R/W 	0

62 	CtrEn 		Enable/disable counting		R/W 	0

61:53 	– 		Reserved 			MBZ 	0

52:48 	CtrID 		Counter Identifier		R/W	0

47 	IsCOS		BwSrc field is a CLOSID		R/W	0
			(not an RMID)

46:44 	–		Reserved			MBZ	0

43:32	BwSrc		Bandwidth Source		R/W	0
			(RMID or CLOSID)

31:0	BwType		Bandwidth configuration		R/W	0
			tracked by the CtrID
==========================================================================

The ABMC feature details are documented in APM [1] available from [2].
[1] AMD64 Architecture Programmer's Manual Volume 2: System Programming
Publication # 24593 Revision 3.41 section 19.3.3.3 Assignable Bandwidth
Monitoring (ABMC).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206537 # [2]
Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
v18: No code changes. Updated the text about the Link.

v17: No changes.

v16: Added Reviewed-by tag.

v15: Minor changelog update.

v14: Removed BMEC reference internal.h.
     Updated the changelog and code documentation.

v13: Removed the Reviewed-by tag as there is commit log change to remove
     BMEC reference.

v12: No changes.

v11: No changes.

v10: No changes.

v9: Removed the references of L3_QOS_ABMC_DSC.
    Text changes about configuration in kernel doc.

v8: Update the configuration notes in kernel_doc.
    Few commit message update.

v7: Removed the reference of L3_QOS_ABMC_DSC as it is not used anymore.
    Moved the configuration notes to kernel_doc.
    Adjusted the tabs for l3_qos_abmc_cfg and checkpatch seems happy.

v6: Removed all the fs related changes.
    Added note on CfgEn,CtrEn.
    Removed the definitions which are not used.
    Removed cntr_id initialization.

v5: Moved assignment flags here (path 10/19 of v4).
    Added MON_CNTR_UNSET definition to initialize cntr_id's.
    More details in commit log.
    Renamed few fields in l3_qos_abmc_cfg for readability.

v4: Added more descriptions.
    Changed the name abmc_ctr_id to ctr_id.
    Added L3_QOS_ABMC_DSC. Used for reading the configuration.

v3: No changes.

v2: No changes.
---
 arch/x86/include/asm/msr-index.h       |  1 +
 arch/x86/kernel/cpu/resctrl/internal.h | 36 ++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 18222527b0ee..48230814098d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -1232,6 +1232,7 @@
 /* - AMD: */
 #define MSR_IA32_MBA_BW_BASE		0xc0000200
 #define MSR_IA32_SMBA_BW_BASE		0xc0000280
+#define MSR_IA32_L3_QOS_ABMC_CFG	0xc00003fd
 #define MSR_IA32_L3_QOS_EXT_CFG		0xc00003ff
 #define MSR_IA32_EVT_CFG_BASE		0xc0000400
 
diff --git a/arch/x86/kernel/cpu/resctrl/internal.h b/arch/x86/kernel/cpu/resctrl/internal.h
index a79a487e639c..6bf6042f11b6 100644
--- a/arch/x86/kernel/cpu/resctrl/internal.h
+++ b/arch/x86/kernel/cpu/resctrl/internal.h
@@ -164,6 +164,42 @@ union cpuid_0x10_x_edx {
 	unsigned int full;
 };
 
+/*
+ * ABMC counters are configured by writing to L3_QOS_ABMC_CFG.
+ *
+ * @bw_type		: Event configuration that represent the memory
+ *			  transactions being tracked by the @cntr_id.
+ * @bw_src		: Bandwidth source (RMID or CLOSID).
+ * @reserved1		: Reserved.
+ * @is_clos		: @bw_src field is a CLOSID (not an RMID).
+ * @cntr_id		: Counter identifier.
+ * @reserved		: Reserved.
+ * @cntr_en		: Counting enable bit.
+ * @cfg_en		: Configuration enable bit.
+ *
+ * Configuration and counting:
+ * Counter can be configured across multiple writes to MSR. Configuration
+ * is applied only when @cfg_en = 1. Counter @cntr_id is reset when the
+ * configuration is applied.
+ * @cfg_en = 1, @cntr_en = 0 : Apply @cntr_id configuration but do not
+ *                             count events.
+ * @cfg_en = 1, @cntr_en = 1 : Apply @cntr_id configuration and start
+ *                             counting events.
+ */
+union l3_qos_abmc_cfg {
+	struct {
+		unsigned long bw_type  :32,
+			      bw_src   :12,
+			      reserved1: 3,
+			      is_clos  : 1,
+			      cntr_id  : 5,
+			      reserved : 9,
+			      cntr_en  : 1,
+			      cfg_en   : 1;
+	} split;
+	unsigned long full;
+};
+
 void rdt_ctrl_update(void *arg);
 
 int rdt_get_mon_l3_config(struct rdt_resource *r);
-- 
2.34.1


