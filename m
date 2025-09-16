Return-Path: <kvm+bounces-57790-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 665D1B5A3F3
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 23:29:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1CC55327163
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 21:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 469B52E92D0;
	Tue, 16 Sep 2025 21:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AmyXdrYd"
X-Original-To: kvm@vger.kernel.org
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010021.outbound.protection.outlook.com [40.93.198.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7824292B44;
	Tue, 16 Sep 2025 21:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758058175; cv=fail; b=YQYG/LI+6qJBjbREAH2e9rlaigQX4Yv9CPPVTfaj9FEJPXKgF+Zk2qnwolsWkOcrXgYbNMhZQVacWU3iK0tH30xb+KRWjKy70cUUQZMxYzOGbw1OBBc/2R1dOvHtcBNoHTf4cD3JE+XjuiEV7oHVwUWID/BeecxRlR7rX17dhQw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758058175; c=relaxed/simple;
	bh=u3imRzm3yQjZPY4O4GcvUAHp+nnQl0Ho8OuFDYezkjA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EFOPiGYm+7TTO4nJ2rb6syGFa7vmuKORD3R3jrUx7dTx1AJwKZtYuYHh1RoJT/sz1WekgEuHD5flhvWKPIyA6bpZDxhi/dJqaLoXjaqVGbGIfV7ZI8AIg8USc+2E+8v/2HccGXOnd74bf7SrUbrTourDIGCYltM+5idOjFG9dmc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AmyXdrYd; arc=fail smtp.client-ip=40.93.198.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vTWNmHwPRUBUMxhEO3M2uwfjoacHCfYqW0bsV/tYn5vssE2YY3xoP9s4pjOw2EXcxZOlKkmEjsl29GNY7ca+WJ22sTJkmGe5D4r9sAX4GEu1PPhXWy8pEzT0MMd4lFl9bHRygFlRmC/rE+ZqC1rLqJ8SqNiXC2NZxjnhJYkCOGcLwB0Me51A/KDgkgiu8Ub/kgxm8120b9Q0JcntKt/FKOz1C/9qtCciV6aYA2/HA9jPe8dJHtqQKHFnt05nUjjbzw6p9uXH0E1rbdHuaYL6tnuvqAU46M+wBtDEUa0xXZnBOKMXlmLr4Cn6uaripzTMKHW4EUKnpwuqO9YA0qd6QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w0RRlFrfmz7AqDTVlAlHdnHgf6rN+/EgZKRFWLqpAS8=;
 b=mfpENsv4MGkUB+Fu4WuxDDhivZQ4cQVNpeBu6Q4P4zTg46NHnM+rkoPuKYJ0ribTZet+InSFYzQDc4zxUVstlctMERgJ8JaBfXf9D5xc6LLaGcQhSIQ5ttf+5rD+yDP35/fihPlyluXZ/sNWITX45JlOMY5pWnOj0VV36b+YuA6weaSFwgPIB3BJad1WPlYqCiNLbwxO4RzINiWB0U8rIv3yJwBph9pd0yL7y6pQJbXObf9zJCzPAYNXwEPGhYz20npq7bsAvw5nZ8yOybOtqskGppyDqtmFDknacVumBgAHGsddH5idnqP6aARoru5rmTLJYlRppEBwCHs8PxB3Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w0RRlFrfmz7AqDTVlAlHdnHgf6rN+/EgZKRFWLqpAS8=;
 b=AmyXdrYdTQicxqbTAHUcxbpinPM1IIYXVKBkSut1Xq7WXrnraAJXDVRne4niOyMDLMZoQSArP2UIsQdT7dMHu/xGBnbMEfb1C7tiw4vDzK2qG1GsmpXOrduQiC5U9MfPRx6Kw4xGBQ8RFyKv8YGfFBmqzSYmo0VpBwQT5C8u6xA=
Received: from SJ0PR05CA0077.namprd05.prod.outlook.com (2603:10b6:a03:332::22)
 by MN2PR12MB4253.namprd12.prod.outlook.com (2603:10b6:208:1de::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 21:29:27 +0000
Received: from SA2PEPF000015CD.namprd03.prod.outlook.com
 (2603:10b6:a03:332:cafe::5e) by SJ0PR05CA0077.outlook.office365.com
 (2603:10b6:a03:332::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.11 via Frontend Transport; Tue,
 16 Sep 2025 21:29:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF000015CD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Tue, 16 Sep 2025 21:29:26 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 16 Sep
 2025 14:29:25 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v6 1/3] x86/sev: Add new dump_rmp parameter to snp_leak_pages() API
Date: Tue, 16 Sep 2025 21:29:04 +0000
Message-ID: <ff513f8fcf28a075f906a4ea8bacd92de225556d.1758057691.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1758057691.git.ashish.kalra@amd.com>
References: <cover.1758057691.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CD:EE_|MN2PR12MB4253:EE_
X-MS-Office365-Filtering-Correlation-Id: 6cd5566a-1f09-4237-f825-08ddf5681ce3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?No/qw20BQecXOASUhqy8BOhTHB1BzrDQFIGmgS8ByF7W5PL2S/RbV+7LaUrX?=
 =?us-ascii?Q?tUU2tpko4rVtubGAhj+CMcgxvfvLkRo/aLl+1kt5DGm5pdYVsjIhSJP1XqPv?=
 =?us-ascii?Q?y9C9ghiPjOG2wY79ql5NpFZmdy6QZSTxuuiIMY2hFEWXVKUPMZolZzLf6118?=
 =?us-ascii?Q?qG6pGuR0flfIs1uetLyQOHwg4naJWSCZ+hZRJru4XVIsYTsyavclUGHNWJ3Q?=
 =?us-ascii?Q?OWIFV5DBl9NhjebiOpCcwdY53KylYwmgTaQPfoSYhdss7AB4vfivIaflZzp7?=
 =?us-ascii?Q?LnklAFGFJH9UiIVb5Y4GK4/G/q9ztIP1FvlgQXoSi4hHy18YwpN0ingLyuqX?=
 =?us-ascii?Q?48Lnd6DzoH4aIfPcqJTHv8zEzGTKzlJKiJqnDb44BjyFm4W6VqgfsoWVZbE0?=
 =?us-ascii?Q?ER45kSFCd+m4wlJI2YAsLdhKdZEvw+quTVE+vpzSy+qpxSjV/KhJQ7LigShE?=
 =?us-ascii?Q?nXuJqJp1yfhIajIKGBEv1vei+XmWID/B/pNFMTv/kn3jD8HksjdDWhRS4rWs?=
 =?us-ascii?Q?BjMESDVD1N322URzhEwlIgX2AbNTKUe2wmSBXC/E03Rvwg2a2n8SnhK6YdRS?=
 =?us-ascii?Q?VL6Br0WOyLYzoFLK3xg9lb9uTKd2ROnKApR87uuUBhZbN2zsDeX6f+/EtZE4?=
 =?us-ascii?Q?2JqMgGsJBzVmDc6ISKCa9XcpH+zGR5+FnXlHqy4a8BWZaz+tnQclk21rKyvP?=
 =?us-ascii?Q?Le8kWVileotwvF9TC2CmTjs4Wofi1v0JFYJYOnEzdieSAlV6DhH7QB8LWCAt?=
 =?us-ascii?Q?EQet38SC+LllHo77NS2LT6u5jKNHoE5Mh3vJw4jvBZ4JsSilA62wtxEZOUtb?=
 =?us-ascii?Q?GF7CpWid+xL5Azn/U+JTl9s4l4AtiwnbYbYz/tkRuBo0dwUaCYCjOH/21Tm1?=
 =?us-ascii?Q?P/5C32S+00gf00e3pMfvU2nlCBwHU4XzQVUR+RKUM8eFNRGQzGfIWRmAl6+h?=
 =?us-ascii?Q?zTkCmsgHpd8WMLlcnA4t6hJ10Kpt6CGtcR/bqeKTG5/kMzAPtvtxn4oXt0QS?=
 =?us-ascii?Q?fnRLEbVmLUNGIpYHm4tqDICAr2zrOdc0a1b9dxg4/wSVNThGwc5JqPmHfdQU?=
 =?us-ascii?Q?gnMOmnVSoR8IlrQxkz66j0XBUeYEpFKRQXp/+wImYkVuQWtBQ86fw/43530Y?=
 =?us-ascii?Q?oYhJSlMDa29iegzMIs32BfJ2Iti+ze22Z6rfLeQ+V4IXMRRy0ULnH9Qeh6TU?=
 =?us-ascii?Q?UoYcMlG+csDSWLJieLjNgZ+eiHnGm1IECLZ9MVL7MjcIuaux+xRnkD49ET8l?=
 =?us-ascii?Q?etp+2CYeIXeL9I88ed/byohnnGucV9Au2F7FSRtZ20iYmmvV7v8HhXoHTwHG?=
 =?us-ascii?Q?UsVEClEPUUWzXwoUpVB4TpI6qx1UEMqW5Kr8OV5xpQNws9oMf/URHZhj8FDJ?=
 =?us-ascii?Q?rSYNopso773Fg5KqdM7Ni8Atsr2MF81AJYVaJAEj+sPy3Uru8uQiCgYgqdTZ?=
 =?us-ascii?Q?TNJsBRScX6npn/MexIHCMA45WYKlAyo1Vb1qPoN+ZEI7b64ZEbKqfI3VJfiT?=
 =?us-ascii?Q?dqiM3sdC7LWNTmspQAsmdR09tmBjWXHoYnkg43l2rFDhKL+zoE8tvNxA4w?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 21:29:26.5976
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cd5566a-1f09-4237-f825-08ddf5681ce3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4253

From: Ashish Kalra <ashish.kalra@amd.com>

When leaking certain page types, such as Hypervisor Fixed (HV_FIXED)
pages, it does not make sense to dump RMP contents for the 2MB range of
the page(s) being leaked. In the case of HV_FIXED pages, this is not an
error situation where the surrounding 2MB page RMP entries can provide
debug information.

Add new __snp_leak_pages() API with dump_rmp bool parameter to support
continue adding pages to the snp_leaked_pages_list but not issue
dump_rmpentry().

Make snp_leak_pages() a wrapper for the common case which also allows
existing users to continue to dump RMP entries.

Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Acked-by: Borislav Petkov (AMD) <bp@alien8.de>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h | 7 ++++++-
 arch/x86/virt/svm/sev.c    | 7 ++++---
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index da2cee884fce..0e6c0940100f 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -654,9 +654,13 @@ void snp_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
-void snp_leak_pages(u64 pfn, unsigned int npages);
+void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp);
 void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
+static inline void snp_leak_pages(u64 pfn, unsigned int pages)
+{
+	__snp_leak_pages(pfn, pages, true);
+}
 #else
 static inline bool snp_probe_rmptable_info(void) { return false; }
 static inline int snp_rmptable_init(void) { return -ENOSYS; }
@@ -669,6 +673,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
 	return -ENODEV;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
+static inline void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp) {}
 static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 942372e69b4d..ee643a6cd691 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -1029,7 +1029,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
 
-void snp_leak_pages(u64 pfn, unsigned int npages)
+void __snp_leak_pages(u64 pfn, unsigned int npages, bool dump_rmp)
 {
 	struct page *page = pfn_to_page(pfn);
 
@@ -1052,14 +1052,15 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
 		    (PageHead(page) && compound_nr(page) <= npages))
 			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
 
-		dump_rmpentry(pfn);
+		if (dump_rmp)
+			dump_rmpentry(pfn);
 		snp_nr_leaked_pages++;
 		pfn++;
 		page++;
 	}
 	spin_unlock(&snp_leaked_pages_list_lock);
 }
-EXPORT_SYMBOL_GPL(snp_leak_pages);
+EXPORT_SYMBOL_GPL(__snp_leak_pages);
 
 void kdump_sev_callback(void)
 {
-- 
2.34.1


