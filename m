Return-Path: <kvm+bounces-57624-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CCB62B5869B
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 23:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 885493B6169
	for <lists+kvm@lfdr.de>; Mon, 15 Sep 2025 21:22:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A666C2C029D;
	Mon, 15 Sep 2025 21:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="N3OeJBcO"
X-Original-To: kvm@vger.kernel.org
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012016.outbound.protection.outlook.com [52.101.53.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA1A1D432D;
	Mon, 15 Sep 2025 21:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.53.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757971338; cv=fail; b=hJoXZEG0jtouK3f//+GrhRFE10UC6TGAlArFkFq28OnKrabKOtLAlm1aIeQ5Y8Y8HhA4buleNkDHnEIjkQ0gu+V6wff5kh3uly/JB6BzsY+5NoKin6Xe2WolrayjiOKBNg8KfFOvvUIdJLUZby+BtHKprT6VjFnHRbcoW8ET7P0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757971338; c=relaxed/simple;
	bh=kUSJar7EhIZYN9XFi0x/z1r52Z1GYCuuPEQ6EnzQCJ0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=djxXkIZh9LAsGhNwKBGTvGJtnejtxAAEEIJsVw6bYKirzXgjGn9k1IwH3parvUQzCNFYQqIsV0EwB1x3mSbREYceQ04Dm7xvHs4EJV+IqurTI8wByK8pinpLiYyX+YBz5VwDo35olySbvABGunovN8inqwT7Q/V6466LCYx27PE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=N3OeJBcO; arc=fail smtp.client-ip=52.101.53.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QOqbXVAsF4o7rpsEQVgYc8QbL7jUgpjy43gTrvyxYobHWsjnfGNiiozsRGdG7y97LRc+5Z4F9A0Xf3gO6qXG2jgNIThoq9QD2yOYr/XJKOK8I32CCwDMBzStnAJOlKAf+uv3za0pFnxafX+t2Ai/8XuqIQBkxJdRH9yXz2hSuFIqcScJ4isB3HdWs5JSzITmx8BsovItXM5RAMyiT5moYXT24Ckpqp8YQaKD5zHWbJgoFv7bPJ0wFoLBRLFC0AfI/LD4c04540YIW29SVG1C+Dv+NYL0GPyfasHu5s/C0X0nHV2xNtr2MfIJTjAM+vZ/QIu4Dj8na+cNs1OB6cuZLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9WjG1A2eQCdnM1S0DYC0omtW0k1SY7GybNDQ5p5Qx4=;
 b=prBgkPnkwGs1M9ydUrKaDEinZi5MeTZVD6VU0VZ4NPa9Ityc3KUtcrDPI/LQ85oltdLWb+D7Yz1vPsnb6ahPNtvSdCZpdnq+mRg6H3GYyqtZDNwc7GZzv4NT3ABtEPV33PRvoMqOTAKv3NCpCsBuVTf2/gbcikcvJCNbwZijvAlL4KV9J1lZusRfC5T7YFrCea7jB/+sEBqYOssHuy8RLJCRV6hEtYuyZXx9lN20jU9iNlJ+AnIU7S6zm7HPemFyBEqfB5xI85oTIL1gjvr5Ab0vL2Y/k4oPnLY94SQXjyc752EZB9WwOIuvEDhffd+2FDw57CgDXJz9+9qd1yBHPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9WjG1A2eQCdnM1S0DYC0omtW0k1SY7GybNDQ5p5Qx4=;
 b=N3OeJBcOks+TaIXE92kOtXRvCj/iEHKefg96Y7eOtR2E62Gx24wF1JJO8bcF7yp+EOtiz2JOV1ZyrVdSdnaQbe0ZWv1E1CfjMZFoNrBh58RQKKe4KIn8NNo97FDgQvGDU7w9ghqzPL/pFCl2ROTW05ZFO53vuYPoKNwgS5UY4WA=
Received: from MN2PR04CA0010.namprd04.prod.outlook.com (2603:10b6:208:d4::23)
 by MN2PR12MB4079.namprd12.prod.outlook.com (2603:10b6:208:1d5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 21:22:14 +0000
Received: from BL6PEPF00022572.namprd02.prod.outlook.com
 (2603:10b6:208:d4:cafe::21) by MN2PR04CA0010.outlook.office365.com
 (2603:10b6:208:d4::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 21:22:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL6PEPF00022572.mail.protection.outlook.com (10.167.249.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Mon, 15 Sep 2025 21:22:13 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Sep
 2025 14:22:07 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v5 1/3] x86/sev: Add new dump_rmp parameter to snp_leak_pages() API
Date: Mon, 15 Sep 2025 21:21:58 +0000
Message-ID: <18ddcc5f41fb718820cf6324dc0f1ace2df683aa.1757969371.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757969371.git.ashish.kalra@amd.com>
References: <cover.1757969371.git.ashish.kalra@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF00022572:EE_|MN2PR12MB4079:EE_
X-MS-Office365-Filtering-Correlation-Id: 77964d7a-0852-493d-2dd5-08ddf49df06a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ryCBbwzAmKr6kbeTpKdG6oIIF6+SKoL8sf9zagjQ9HKSH7wbnYi+Z8ZbJV89?=
 =?us-ascii?Q?kdGD68kwCIGkHwYI0SsreBBGEZhKVmWvH3x39Wh7iMM+3H7Ix+qoDuGU2Z6y?=
 =?us-ascii?Q?kRhv+FnjGpIa5lyMn9Kly9wXxpZs1Mt75S3fA7ACkORlakYFPzEO9zsILWQz?=
 =?us-ascii?Q?BjV3xRO2QNvVPUeadvnarg4zJi5fFvj8mvW38KrcsiaC58j14HDZdU1ucPDq?=
 =?us-ascii?Q?YYZvfLrdLMlOY0uiLlBfnlw0h6mcwvme71G+mtNAfunyMON5I1/An5wh0+WW?=
 =?us-ascii?Q?h5oxCx5xUyk+Do+n7RX7OezIuNQ39S1LihhwybPktxaw1Lu3kwt9Gt/HGpnE?=
 =?us-ascii?Q?/bE8wKdaOWUUu8CjjfGXy3twfY/WC1s2EHSyUzzo3B1amxfwtoD+u5azZ8W+?=
 =?us-ascii?Q?jqyo0BxUEgNr8bORIkNnddhTQ8loc+OAYiqXxXkImZLNWemY9VRwi91g2uhD?=
 =?us-ascii?Q?hSCC2uRjgZFw/hSP59t/4WOAHbTrsiA3LqNJ8ijFYuUWF2c7yz/ROvBicN4Q?=
 =?us-ascii?Q?k3tPnNB9to1DIJTRUef+3FLBs2mrOr3gq4CRAWVJOU7AgBb8Mj5blnC6y4I5?=
 =?us-ascii?Q?J64EGiIqSThWuDeNCaVvtz1Q/Enqr0JdVysp05YhmtCS35awYJJChsUzvZaq?=
 =?us-ascii?Q?8R0lMSnoSrqJYD+o/o0LBcz1A04hZ852sHU+4kgS4wjDro0djPuywqt/7dq+?=
 =?us-ascii?Q?cx+XvBbiCz3Ah8luC2389G0bXAEPTEBiI8U7r8TcpA75ILj+9WBIiAKKqTbT?=
 =?us-ascii?Q?tSrXR+atdy0Y1LcQvBqUpQFpWVWwGw9o0z4bYhicaIpVxtSX6+8edq7nlN2j?=
 =?us-ascii?Q?DTbXstx1MmUjUqvLZd41+i1RMl0iNiDIYHQdDcgm9vR26AtwGrpjW87P6rv6?=
 =?us-ascii?Q?1mgHae7LK5yJhiDSnmZMILTbEihnlJqNzNVHQSf4una8B7YDskHBZeBdGm4w?=
 =?us-ascii?Q?S9Nr7ae48+6Y9ydg289s0PvGc9zBx19YHQKLrCmA5XeAlQM0t+LI8WUBm9xZ?=
 =?us-ascii?Q?aI7lK8mxVPZzM5/CETGkwG4rD6mvQvf8lQC9Pvs1Gh71wzMrsL6XW++rXbDa?=
 =?us-ascii?Q?mv3UvPbDWcqpS5wtLNNQywxEK807iy05/YV/rPhvGbogXcIq09wpmgWPa1Mr?=
 =?us-ascii?Q?6a9rquav+j1W2UB3bwuoHfJo/23n+Bvvo2ieEZlRt+QBQKmHo3NkvONEJQIE?=
 =?us-ascii?Q?3d8osTzOsLUbErSDGRZiVrMdRmCX9Y+ESAOgjbVPFkFXp5iJwpYYy+Qog3u/?=
 =?us-ascii?Q?k279u3Ck20mnEOqoaN9oXsnVaCdOnZokLLUMKmfofj2e/2YXdVl5fr63lPki?=
 =?us-ascii?Q?IoBApuQHXpHY8PkQiTNHY/6mMq0FD5UEXWaVxua/bGYh687T2uUtRqLkBbg+?=
 =?us-ascii?Q?pBdUcIWXpHNILVvJibIh2nicQdEVvaFJG2sVMTlNBM6Rz4tygXyHNG2c5G8/?=
 =?us-ascii?Q?ZZ5Pp+vt28kPSHYnlkOZzNe/k9pEJyUz+XdeY20nLIn8z8DT6w8GHLKOPu4/?=
 =?us-ascii?Q?KlvCWrvC0R7hek8aSrXQ4qpkXh0Ov2EcLVCi4ZvyYaZZpq7qVfMyatjedg?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 21:22:13.6575
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 77964d7a-0852-493d-2dd5-08ddf49df06a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF00022572.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4079

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
 arch/x86/include/asm/sev.h | 8 +++++++-
 arch/x86/virt/svm/sev.c    | 7 ++++---
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 00475b814ac4..7a1ae990b15f 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -635,10 +635,15 @@ void snp_dump_hva_rmpentry(unsigned long address);
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
+
 static inline void sev_evict_cache(void *va, int npages)
 {
 	volatile u8 val __always_unused;
@@ -668,6 +673,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
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


