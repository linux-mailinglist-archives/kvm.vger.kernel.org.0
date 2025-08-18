Return-Path: <kvm+bounces-54913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C47DB2B23D
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51959685999
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:18:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19C342264AD;
	Mon, 18 Aug 2025 20:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IFee1LGm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2061.outbound.protection.outlook.com [40.107.93.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AC922615;
	Mon, 18 Aug 2025 20:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755548326; cv=fail; b=boFAMEyBdA/0iim7QlTgrznSf2ebIuAyFOjRkAxlJ+4j0VOIh92HeKaFM3CxosDVv05GeNM13ZYttxZwxUwNarJgRKQIwb827+FL+j9+ehzRDbW7FBSPeZe6hyZn1cwFb0oLsWdGvt+I3vHw9TXa5rCYmJXLrulwlDyBUjJCcmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755548326; c=relaxed/simple;
	bh=IKGHAlhLpzLMeekciyHeTZc64xjJI8gaOUfECOVAQW0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPaOS6adtzwDgAXlj4bCULwSmUOrmTVThxOffkaE/2s9SyMsEU/if+wzBxWbG5jvwVm5yM+atxCxdVwJ/1Qwilb1ekkwwMEOKWaXqV0zvVrt19PQFh6+B98eqfHp7veWqR2IyKDArzuail2aqOtuXNEIJ9+VAggusWoq1CWeGJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IFee1LGm; arc=fail smtp.client-ip=40.107.93.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XgtuMIJ2hPRUVyM1RxIYlCzuoudjdT0E1upXSQNWw1AJTLlD5cSDfX1bt2f1oq7WEVtqh/RBdcFcTZD+tpY41iVRQvsOmB/yNSxLGgGXdxqc11c0M8WdAsx2UoBw5rS/mKUq15lY88xIY1gYQh+l9E+hQpQgBXLP5oyIQmtiHI0XQqMPLQw+dpT2w4Q/M/JKeKd4W6Qwe5C4Db9e6CU9dAHk5QkYxvBfCpSy2+LPH0wtHwJtJT8aTpHArSdVxy5GCli27GWiimkuwt6sG2nsU8FmJ/uMcc3+R0TSiVgy0jaJ/2ScvTfL9yfSReyj5wW3QuxOUR4wdBUMUzHPP2Ummw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z3Slit2iamgPUT/QQe6b0vhkqU9d8JUwTbhRQMNXBWM=;
 b=HGTcuoifnBTLPrsjeTHSAG5/ZsbD3exgzuZqTaOxrtws+K0oHB+qzdviN7L4opsIqltd8wTWIOqLNA87FoU7wYm97Q1aCxA/CeFKLl2QMiNLhbGfU0fAeAurNGuCw641g3w/EVd1eZ9jgJL+HlE0NpfmCBgIl75EshIqu7iDEU2xCyl+0gki9oixb6TksTZXjTGpnknJ8F0s6oxe/2AQ87Tc8jmWwVe9uoRUc9B2LWe8m2v5xN+9x3k1emapEqxS747FhuF+5lsL8G9e9HaUFhsS7kW2Ux3HuQaWwikBWvhY4P5YlCPwmP9/XO87ZMti3CVS1KYcfhQFX/E8nn5Ylg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linutronix.de smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z3Slit2iamgPUT/QQe6b0vhkqU9d8JUwTbhRQMNXBWM=;
 b=IFee1LGm0fAEcmXr9hnGywPH+CSQEh9ttxMCMQCkMZZCUWx2kPVCnQ5NivnaXXieEvfPzlse+MuxKqYtHE3dou0G96WdiU8JcSqUZMAGtwXszx3vwnatOQAdJo2eagK2nlZN0iNIsctP3NGj7BdMzIbYXVpST/SXB8vDiZUZrGY=
Received: from BN0PR08CA0009.namprd08.prod.outlook.com (2603:10b6:408:142::13)
 by DS7PR12MB5837.namprd12.prod.outlook.com (2603:10b6:8:78::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9031.24; Mon, 18 Aug 2025 20:18:38 +0000
Received: from BN2PEPF000044A2.namprd02.prod.outlook.com
 (2603:10b6:408:142:cafe::af) by BN0PR08CA0009.outlook.office365.com
 (2603:10b6:408:142::13) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9031.22 via Frontend Transport; Mon,
 18 Aug 2025 20:18:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF000044A2.mail.protection.outlook.com (10.167.243.153) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.9052.8 via Frontend Transport; Mon, 18 Aug 2025 20:18:38 +0000
Received: from purico-ed09host.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 18 Aug
 2025 15:18:36 -0500
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <thomas.lendacky@amd.com>,
	<herbert@gondor.apana.org.au>
CC: <nikunj@amd.com>, <davem@davemloft.net>, <aik@amd.com>, <ardb@kernel.org>,
	<michael.roth@amd.com>, <Neeraj.Upadhyay@amd.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Subject: [RESEND PATCH v2 1/3] x86/sev: Add new quiet parameter to snp_leak_pages() API
Date: Mon, 18 Aug 2025 20:18:26 +0000
Message-ID: <7f7cdb3268e95b7dfa924c3da16a201da0b095f3.1755548015.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1755548015.git.ashish.kalra@amd.com>
References: <cover.1755548015.git.ashish.kalra@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000044A2:EE_|DS7PR12MB5837:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ee29bae-e712-47a4-ad4d-08ddde946add
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T6dA0Wlk6d78TphWC842La0w0K4kS9JlEbycXsVA7yZST+cZIjffVikSQkLy?=
 =?us-ascii?Q?uog9dJvLNyMWITGOqX3dr0IgQ36MK8xzjhssJ83joS04QPm+HYv7PbJrYc9K?=
 =?us-ascii?Q?kzmUWrAeGlb/2dgDEZ13lAvS0ceX3nkGKjLWn/34J3ihOVFH9J+OKfjG9DJ+?=
 =?us-ascii?Q?utJ0o1fP9fQBOr7Pu2N91LKNog90kln2yjJnYRnLZbsIu8G2/smxI85oTAcE?=
 =?us-ascii?Q?WcdKWR6R0Hh0BJrwWTgU99A0NqZymQ/zLN0ot+ZQuJ4ytv3dnRmX36JFVUx5?=
 =?us-ascii?Q?RxjY9PT0sm1FuWO/T9hUWb+Nviwv4j44/8J0Fjdk5y++ypMtNY0HX75yNuRF?=
 =?us-ascii?Q?mPKq/MOIY38pJLAJDue/6GV9P7Q8RdEVUN+Bpi7q3pcEF9gu/i9+vMSXJmB0?=
 =?us-ascii?Q?IX7n/fd6p3WMTqDPg4J9tUJHFqaF1NASZNFcBFZcQ3bgPpRDpMLQjTY75iT6?=
 =?us-ascii?Q?U7uXiv7xRN7lWIAOhZDM/aTA6phfbSYWbe2cSe0jkcLnbkVTZwcdu3smOsFb?=
 =?us-ascii?Q?yWZKnaX33D88YoGV9eQ7Qcf2REPSio6kRKEn2TQ3MhyZu/fkMatvyTcoZdmd?=
 =?us-ascii?Q?kZD36yl15Q2x4Wo7MhW7hc8wuZBGozz6TAIvppMfpnKShW05qc3eSwpYsqFO?=
 =?us-ascii?Q?tXqyOKF/stefIG+qHgDPRAM2uochTbqi2r93sVSowPmO8q+AVV9q6A7/81bw?=
 =?us-ascii?Q?eC/koXhMMvBbli45oXTHaawC3SxAKgg3FMIt0FAfZXQMIvWTxzMyc8AT9cIl?=
 =?us-ascii?Q?idvAt7mB+DLs0Mpd2SFkfnp5a1unokNri7HoR9qgoZsRKBKj8DL+WRAg65TU?=
 =?us-ascii?Q?9FsNHfs0Ki82xpnJ3SYwcHsqPOWPG2coTjmMQdjcxPywXxxIR3c9ycs4SMX2?=
 =?us-ascii?Q?7mkbeRGsylBTM6flfD30uxbQX1xj2XAZmOQzljdv5cGElvc6O8v9nvtFuX1g?=
 =?us-ascii?Q?70uU9yxT9Tp1dv8L5oyCOFIR5mJPcdlvL9gbzjAItjXJHXZwAs3tHInwCaX8?=
 =?us-ascii?Q?qjVVeql4uBB57LgmIXmcyogQDuxsVmPwtDEEz5GScSoItt3ofoEkIZdBc3b0?=
 =?us-ascii?Q?n4Qp9k8ei8gX2ghZkYufmbLzbGQ8MC8Hk8J7r/PcaJmcbBv4KPme/Sts/a8S?=
 =?us-ascii?Q?+4tdN25KgoErIwZ75hxAq6qIZPne2jaAYC9yqnt6pmpuaXTbVooFIFL8K6lu?=
 =?us-ascii?Q?AM2awfiGMQyMnSoVsBb7u1tgj9gKDOzR0mjdJ4NvCLWsq1B7Lc+QLFuAooIv?=
 =?us-ascii?Q?SYnNcBWb7G3uQrsigOq+lSGr+UE3l6tUbhU7SUnWevPzP/RxbNF8dGJHP8ec?=
 =?us-ascii?Q?eldgi58FMhvyDqE8lasEIarlOFTHHgHWGGT7xGXn5cmmI2j/76eiKsGA8YgZ?=
 =?us-ascii?Q?SkUrvy+itXlbYx9pHyVPY4Zi9j/6Jz6dqbZB6v4Hnh9GfGVmanVBcNT9z88/?=
 =?us-ascii?Q?We1gWDmzNugLuxoXdTd4oEEAfOMyBLnwlUb20N+QHIQB4gV0djZcCAcIDUoE?=
 =?us-ascii?Q?iZPa/0JcQp4Bg0tDE8EcqHY/1UcMcr8Au4+bQSIX+dPlJjFx64uSOv8zFQ?=
 =?us-ascii?Q?=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2025 20:18:38.5500
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ee29bae-e712-47a4-ad4d-08ddde946add
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000044A2.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5837

From: Ashish Kalra <ashish.kalra@amd.com>

When leaking certain page types, such as Hypervisor Fixed (HV_FIXED)
pages, it does not make sense to dump RMP contents for the 2MB range of
the page(s) being leaked. In the case of HV_FIXED pages, this is not an
error situation where the surrounding 2MB page RMP entries can provide
debug information.

Add new quiet parameter to snp_leak_pages(), to continue adding pages
to the snp_leaked_pages_list but not issue dump_rmpentry().

All existing users pass quiet=false parameter maintaining current
behavior. No functional changes.

Suggested-by: Thomas Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 arch/x86/include/asm/sev.h   | 4 ++--
 arch/x86/kvm/svm/sev.c       | 4 ++--
 arch/x86/virt/svm/sev.c      | 5 +++--
 drivers/crypto/ccp/sev-dev.c | 2 +-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 02236962fdb1..8fc03f6c3026 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -616,7 +616,7 @@ void snp_dump_hva_rmpentry(unsigned long address);
 int psmash(u64 pfn);
 int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 asid, bool immutable);
 int rmp_make_shared(u64 pfn, enum pg_level level);
-void snp_leak_pages(u64 pfn, unsigned int npages);
+void snp_leak_pages(u64 pfn, unsigned int npages, bool quiet);
 void kdump_sev_callback(void);
 void snp_fixup_e820_tables(void);
 
@@ -649,7 +649,7 @@ static inline int rmp_make_private(u64 pfn, u64 gpa, enum pg_level level, u32 as
 	return -ENODEV;
 }
 static inline int rmp_make_shared(u64 pfn, enum pg_level level) { return -ENODEV; }
-static inline void snp_leak_pages(u64 pfn, unsigned int npages) {}
+static inline void snp_leak_pages(u64 pfn, unsigned int npages, bool quiet) {}
 static inline void kdump_sev_callback(void) { }
 static inline void snp_fixup_e820_tables(void) {}
 static inline void sev_evict_cache(void *va, int npages) {}
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 2fbdebf79fbb..a7db96a5f56d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -271,7 +271,7 @@ static void sev_decommission(unsigned int handle)
 static int kvm_rmp_make_shared(struct kvm *kvm, u64 pfn, enum pg_level level)
 {
 	if (KVM_BUG_ON(rmp_make_shared(pfn, level), kvm)) {
-		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT);
+		snp_leak_pages(pfn, page_level_size(level) >> PAGE_SHIFT, false);
 		return -EIO;
 	}
 
@@ -300,7 +300,7 @@ static int snp_page_reclaim(struct kvm *kvm, u64 pfn)
 	data.paddr = __sme_set(pfn << PAGE_SHIFT);
 	rc = sev_do_cmd(SEV_CMD_SNP_PAGE_RECLAIM, &data, &fw_err);
 	if (KVM_BUG(rc, kvm, "Failed to reclaim PFN %llx, rc %d fw_err %d", pfn, rc, fw_err)) {
-		snp_leak_pages(pfn, 1);
+		snp_leak_pages(pfn, 1, false);
 		return -EIO;
 	}
 
diff --git a/arch/x86/virt/svm/sev.c b/arch/x86/virt/svm/sev.c
index 942372e69b4d..d75659859a07 100644
--- a/arch/x86/virt/svm/sev.c
+++ b/arch/x86/virt/svm/sev.c
@@ -1029,7 +1029,7 @@ int rmp_make_shared(u64 pfn, enum pg_level level)
 }
 EXPORT_SYMBOL_GPL(rmp_make_shared);
 
-void snp_leak_pages(u64 pfn, unsigned int npages)
+void snp_leak_pages(u64 pfn, unsigned int npages, bool quiet)
 {
 	struct page *page = pfn_to_page(pfn);
 
@@ -1052,7 +1052,8 @@ void snp_leak_pages(u64 pfn, unsigned int npages)
 		    (PageHead(page) && compound_nr(page) <= npages))
 			list_add_tail(&page->buddy_list, &snp_leaked_pages_list);
 
-		dump_rmpentry(pfn);
+		if (!quiet)
+			dump_rmpentry(pfn);
 		snp_nr_leaked_pages++;
 		pfn++;
 		page++;
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 4f000dc2e639..203a43a2df63 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -408,7 +408,7 @@ static int snp_reclaim_pages(unsigned long paddr, unsigned int npages, bool lock
 	 * If there was a failure reclaiming the page then it is no longer safe
 	 * to release it back to the system; leak it instead.
 	 */
-	snp_leak_pages(__phys_to_pfn(paddr), npages - i);
+	snp_leak_pages(__phys_to_pfn(paddr), npages - i, false);
 	return ret;
 }
 
-- 
2.34.1


