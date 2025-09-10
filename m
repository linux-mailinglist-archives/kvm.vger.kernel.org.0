Return-Path: <kvm+bounces-57262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 685E5B52451
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 00:56:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7834CA06C71
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 22:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E1453128BC;
	Wed, 10 Sep 2025 22:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aZt03eIh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2074.outbound.protection.outlook.com [40.107.220.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1023FE7;
	Wed, 10 Sep 2025 22:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.74
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757544975; cv=fail; b=XAsU0+KVpR4wYLtQRE8NNl4LUlGYxTq9QUXWWjrJx3WWHQJfxl0zZUl+rBQBqU0g21hcsSuX7LIqdNw8z97X9gX9Twr4MIYAbLNOvScCXrv+7beCBh2g8f0fDQNo8jKCixCb+is37AY5YkIUYawt4y0YnnKpNvxLrU7wNScZu/8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757544975; c=relaxed/simple;
	bh=whqJXoUNZYkhQJyamXLdp6E7ROYyVLziNS0mG1ajZho=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SQp+QrVkVv/KbT/FgajtICYQzcFK55ai00ux02pmLnsaccxozHP38NbkYYBZT+ShxyZOljhiHrIWZCfCkxx/M1xqIZ2YorLcCfYLGd/4DEaPgq3TQ29SgNWgsgVqgmd7XMwangyQaw29257/slurbEnlNGjdKfJV28BmwkYGUAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aZt03eIh; arc=fail smtp.client-ip=40.107.220.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JOe+rBNdHfqakfaH8GD/gKa23o/1x8hOMoxbcGG7+XCOdsHPFXvPvLo0fVBBlRAZL1O9SGWNrhCL40RhGkyj3UZF4V9qdYyjPC64djVsYHoAbdj6HqQ5JO3hN7xanJABFyb2ePjmQ5frFmfm1zvhZFliParVMQj3/4enfyIX2//nP52QuNbmOLwezWZCH9wRgL/73/ODQT2E2QQgiLLxpq3Nl1c9lDc4NMqD5InXo8euP4AKU5LmrVV/f5FWZkFZdHx+DsLHW9des76ygsJpvJYUQlLJv38z8n9bceWOzSTNjMbwLHXTG0sXasjB8RFOOp5dz72eWhiBDBTlzF9ucw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qOeCvnflFduzgDsD58fTVtbS5ag0PrPKSTOqsrBAixs=;
 b=Bwun//Y2vRxA4dy+6ObeAjFA9AFeptFB4ipu7WhqaanrrUG6XkZBpTri0Pbf4mzl9NA2oQfE5UcojM+1fN5fzL5WgSgD0Jv+zX8fbVo74S7eAcMTcRbQT+kA0ZKtNab7tScphco/+7w05id4xaLYzP6KhAGcFtHCq4SdyQmcXNkL+pLjURiuDXtRlLxJ4R8NYoAbE8UOCNo6mvsKNj1jaZiPfZM9Dw2zVaSpmb3r/7+P1EEzMW/p/4OEAk0gC8QiWNCxKyC121GtYmxh8j58X8PfMNbpxYbCDPPmQTLWe8DZPD4hhUEJtHFDtAmuYpcfbVcmP9dWv5E0Nr2Wq3Y/Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qOeCvnflFduzgDsD58fTVtbS5ag0PrPKSTOqsrBAixs=;
 b=aZt03eIh+gy221NmJE8IhZgc1Xdvc8HmadurMpUFrJDgqrrnuAbo9VZrho0Lxx1P/q1IMRNnGa1Es9U6qC5CyM6lPwjBnYk7hvYQxc2x8nTjqU/gbZDhu35KRthU8LC4CWpNCMK5gwxzKJ1vHXhGPxr+R5jc6EM3LMKYhVyPEOs=
Received: from MN2PR18CA0014.namprd18.prod.outlook.com (2603:10b6:208:23c::19)
 by DM4PR12MB7695.namprd12.prod.outlook.com (2603:10b6:8:101::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 22:55:54 +0000
Received: from BL02EPF00021F6F.namprd02.prod.outlook.com
 (2603:10b6:208:23c:cafe::70) by MN2PR18CA0014.outlook.office365.com
 (2603:10b6:208:23c::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.16 via Frontend Transport; Wed,
 10 Sep 2025 22:55:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 BL02EPF00021F6F.mail.protection.outlook.com (10.167.249.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9115.13 via Frontend Transport; Wed, 10 Sep 2025 22:55:36 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 10 Sep
 2025 15:55:34 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<john.allen@amd.com>, <michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [PATCH v4 1/3] x86/sev: Add new dump_rmp parameter to snp_leak_pages() API
Date: Wed, 10 Sep 2025 22:55:24 +0000
Message-ID: <c6d2fbe31bd9e2638eaefaabe6d0ffc55f5886bd.1757543774.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1757543774.git.ashish.kalra@amd.com>
References: <cover.1757543774.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6F:EE_|DM4PR12MB7695:EE_
X-MS-Office365-Filtering-Correlation-Id: 9eccbaae-683a-4458-4c0d-08ddf0bd27f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|82310400026|376014|1800799024|36860700013|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YlO5Vnbo/oPEWgga8Y6efA9Xmx+cFFh5DukZgJltIGJ8tSsAf+iG2iSeLH97?=
 =?us-ascii?Q?oyfR8nrGvdkVdzhvYde8kiQELoEcvJfm7gvWe8H1vw6ij4Mnuw0Hn9EWvIgV?=
 =?us-ascii?Q?XI0D7Qs9aTmY/Vk9cTmJLj2X2r50dRa9q+M5Nl5FUF+CkycQwkuixjSdo3bi?=
 =?us-ascii?Q?BxcoF1la00GWH3mcR2n3QNFcqvoC4qRZVgBOUjJamjH6qBhlO++ZE5YIQE5Y?=
 =?us-ascii?Q?pLPGxZx+kLpFJc9sE4vpm7O4HmuGAW28xahww1x+bZd22rCzQOao3YAzbGV1?=
 =?us-ascii?Q?u60JB6eslGVk3tBDEkjyArhyqHQ6Wd4xdnJnlOthAcy0t45UB2+ynKHAyIt3?=
 =?us-ascii?Q?LbaUe6KCaIuYpTY0X+fm5NhDGlqTfaUIKp3FYf3mNKwctsP8vwEipAo7seBP?=
 =?us-ascii?Q?jmIF48IXCTfgybBw487b1kCQ/njrYezseR8rv3alhIZpesO0i8qQutjhpD/E?=
 =?us-ascii?Q?7z+ifzx/qP276z+rxBjX3XmjP1gs5iCH/fO/32cMzz7tPk4hV3qO0Fpmvg5t?=
 =?us-ascii?Q?Kwsdi1GyrNEvoitqHToPxYOSIp2DXz97ufC59QHfxRy8sxSgbsozADrLax3M?=
 =?us-ascii?Q?Huy4Ku2YbD9wtm+XJcDUWFo9CaS8S6uPzHsljoPtbqriCYPsGYDIshF9G2vn?=
 =?us-ascii?Q?YjhpVzO9mgAkpzhWyfmKizSgYgWXI/C/WW+FCzAvDDieu6udDmjKOPBbV7Gw?=
 =?us-ascii?Q?JYWCqSuwudH5hMOdKQpdC6vv6zf+qEwSwPPBBVB4QiebHEN577mHc8A2qotL?=
 =?us-ascii?Q?8yjaWfFitT1y5xGTXMfHHJlT1HJFCMAHpYr1c1HBS6jmUwuKvHFrCAMVOEPM?=
 =?us-ascii?Q?lwmzpGzjQupjwDZru++HNq48FSc46uzXK0Co98fH/27P2L+qv5lnc7N3qRdP?=
 =?us-ascii?Q?ddLtSuriGE938tl6nlIEldfDlrsdmo5jT5/+EXn3KWljM9+uAykzaFah0gdQ?=
 =?us-ascii?Q?g2+2DqSk4gD1caWLWMRsuhUxWccbzHZOYGZkzVDgNlHVUa7BwB82+D4zALw0?=
 =?us-ascii?Q?NLSzcTUQJogOEWpCz/d6nPDbF/7cAeHi+WlgdbiE/VjiGgVdgAoVpJobxX1Z?=
 =?us-ascii?Q?eDQvpY8GUR7Eh5vKPVGBhe2E+uo97qmpeL+j4t/Dpj9BRQUYsCLnbfwj9jxJ?=
 =?us-ascii?Q?wSBkImj2zsmzd0r/qGpeOaOCAAlm4GaQfgGFyoweW5CwY1nitkMhkZUps2lu?=
 =?us-ascii?Q?vbtGQOX1ZI+6dh2FdYzJ/44tT3XcSORMzcelyxBxyCi720d/838y1Wix6TMD?=
 =?us-ascii?Q?PTI5r6sJGTdWcYHwBtpyA2DRoVjrd4Cv7/ljUMlEJEcgGicB+eIkHgPRnb97?=
 =?us-ascii?Q?So9sqEGtmVLjwv1d8JvZK1/R4Kgbw2+0wI22EwfR/lzQMJHX0jBOlw2gYkhG?=
 =?us-ascii?Q?pyiqUfrCQP/MgBK1fp/VYbRof6FLDucxvW/tqv/vreo5VWEYRLjd2a8uAGfy?=
 =?us-ascii?Q?q+v1P7Kp58qxs6uwkj0Tc5C0w9N+3ZO1eaPhihniRttIw2lHCnDcr6dT9pnW?=
 =?us-ascii?Q?MSu87riSSLzsrV2hctS7Sy/q/zBXV19S7gtQiZ5nuXVMzrNV3ruSuW/UCw?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(82310400026)(376014)(1800799024)(36860700013)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 22:55:36.6180
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eccbaae-683a-4458-4c0d-08ddf0bd27f9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7695

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


