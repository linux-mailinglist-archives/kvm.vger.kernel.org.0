Return-Path: <kvm+bounces-22783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E744E9432D1
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 564FBB27174
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C88BA1C0DCF;
	Wed, 31 Jul 2024 15:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="45nZvLuB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A8D1C0DC0;
	Wed, 31 Jul 2024 15:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438559; cv=fail; b=tPxU43RVoO9+Ik09Dy1wkDlc9ap9c1s7IVTbhpu4Mj9GnHYG61YoDZRC5yY+meZawDihVjBv5/P7iRmo9ZWp7kLHN/RFZMGs26jFbFKffazaGxV0+cfRABEsQaUOGPggQX6qCZ/SiJft7XUvb77uefnTe9Fv5bxB0N1c0FTSyY8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438559; c=relaxed/simple;
	bh=bvJUM1mqFzgMX5bjaSkw8PYBb6VubsmBYjJlHwtDxak=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C2QiIgsGtSe2ChHac8Ie2t4otkc/NeXL3Y+YXX/zbD+n8BYEbdk6FvhIeGZJwVH6TR0soaXaV8zkLLvelJgG38GzJ9wO6SGofvEnlzvXhl4UmAWs88VAvNLrvfdFe/xvOGMRickykSwMxMnAohSzsF8TM1FygUm06jwCMxnvU8g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=45nZvLuB; arc=fail smtp.client-ip=40.107.237.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JzvBcekWAg47SVfKTCbr4ouC+BMsdKy7wIXdQq/GavJHBKvfN8uREFr2XKrLMxim+9smzTX7Yrz/5CV1+pLMAJLu/hMTDJEwytd/fdIvOWVOOl+BvGp0ydrVvQC+nsTCReIWYlzU/+C2bDwhS5zwAussM3zBtJVVOmvTf+4A2gw+vICILmCJphE3t8rlsprxwgVM+RJrocg9K6fGVUZDXJ7yXg3746fPw/AfzHpM9TxghXi95kqIytsvY+WdHHusIFANxntxhNCvpWwHTK2kHdatK8bXRwhrj3wRPW2qFhpuB80zs+yE+jeh/HppBPl1iT+d1XyRC1Pd3fSiTHPnoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LnoYFjOKQ5Yyx5ib4xxPC9vTTK5wLuOSbcJcFYeqLr8=;
 b=jGDHHesFuQY/uBzw6D7Tvd3eRsfP+hZs6hpfOxzGN58wzUhHHrh8k0CLca28BustA3XyN3gfpiUnwdbnOznmyhno1x9o6u11skrVMHM56e5hD1ovCRm1MYpR8zrl1kFa3APoxFs2WffbhUI+xc56BpYdtixV19u5QFpo9ATqLW+BfTz/ksCLrvPksRjvuUZopGjpCvedo4kTd2jpVZtiXXOmE4R4eBA4ML0yDozyBPIY2rL/eY6k6hwG9I10S+LJiscYzoovyWC6idx4+vLzWlJXtQ8VAwb84oeD2joAZnwozM3dbTapvCKciRA9nGtuO1CeEz23sgRzJgBruE12yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LnoYFjOKQ5Yyx5ib4xxPC9vTTK5wLuOSbcJcFYeqLr8=;
 b=45nZvLuB2u4jXGkiRbOr5usZUd4fJPpBuEvRi9sIhlDod5XX8kBVIJaKb/otxdwZwq5ZhVL3vLFdNZfeVOrg5soPD+5m5pqjgrRqHjqywuq8IlGG+DCsgJ7KX2WFLUZ6aAW3O0BZtwADBfz7egQPITWzRhBdLA94jcTTn78uPYs=
Received: from CH0PR03CA0310.namprd03.prod.outlook.com (2603:10b6:610:118::33)
 by PH7PR12MB7018.namprd12.prod.outlook.com (2603:10b6:510:1b8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Wed, 31 Jul
 2024 15:09:12 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::73) by CH0PR03CA0310.outlook.office365.com
 (2603:10b6:610:118::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.35 via Frontend
 Transport; Wed, 31 Jul 2024 15:09:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:09:11 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:09:06 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 11/20] x86/sev: Carve out and export SNP guest messaging init routines
Date: Wed, 31 Jul 2024 20:38:02 +0530
Message-ID: <20240731150811.156771-12-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|PH7PR12MB7018:EE_
X-MS-Office365-Filtering-Correlation-Id: 3031440e-b0e9-49f1-4480-08dcb172bbd5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|1800799024|36860700013|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QPKsoq/Hul8VjMuJhNKMIdcopj57uVbzPRXAJSVk2ksTTUwVFGKLm2PxSclC?=
 =?us-ascii?Q?zXuSDKjJt8bPyiJcJM5OpCuHNUWDzVTigyb51StGRzMT1fKldxV9jTHnz31q?=
 =?us-ascii?Q?6CfpKARNzqwRHofbkh4mO5IAaDrhDiOXYe+usGwbUtG6gx2LUJKajI+/QN0S?=
 =?us-ascii?Q?oK3aDUiu4+uoMEePY7pZxtORXqqsbR0i8PKu74p0ArsT5qCOq6VUUx8KehNH?=
 =?us-ascii?Q?3Sd4JIdMC6eeAqhz7RaaN525v5+Pez4ul/oNnimlTE/06REfLTDjPZ2ssGkc?=
 =?us-ascii?Q?Lbvjc27XNcxWT762XzX9ELRpBC6Axbg5nF8a49owrTqoOoLBzw1MX+mkdeVw?=
 =?us-ascii?Q?d9rX8BH5b72Ik2kY6UXuRXL9duEKFEf9gci2L9xhiVj4EgB78fVp9rI51812?=
 =?us-ascii?Q?EpKMKmCp8waudIGBYM7KpRqEmiysJStmYxAlTN1m4o/iWvPrC1JivqfUj5He?=
 =?us-ascii?Q?7LarMs3yoe73p64NFAhlWY98+G8RrXsY+F59dei/qIvBhHRStnBvXaJtN4rR?=
 =?us-ascii?Q?XAqti9WqcN2bMJ+HwfJE+mwq1B1TxFc0l2Pa3pKa9QUYCQ0HmW28LVzcQ8Rx?=
 =?us-ascii?Q?htyGyL0aUxnlwihxjwPn/hK6kUero5Y3xo9tvMDOrbpU56SsR6MoBQGEDymt?=
 =?us-ascii?Q?1HJynSlyNtAF6rWb2pSkY56e+oWRbZ5+lpSYeUfCcqPrPk1j1H/+WhkTnEO2?=
 =?us-ascii?Q?bTxj11yaQtCA4BIvMauu4/tOUFmt7D2ZeTcx3tVHUL6Yu7k9qbdE0B4aWfel?=
 =?us-ascii?Q?z6cJmYzCyLrV3wLQmIQZPgF3INzhs7n39wN98FnijnZj+1d8PJLNyJjO89IO?=
 =?us-ascii?Q?8HKHpNoqFk/6NNvzIVIzbzF2Aii/MknbvJlgjD83XnN56CFagPhXno31Anhs?=
 =?us-ascii?Q?S4n+nGEKfP29GtOAtFRRCoWCU9lsrghpYTnmCrkza3lUcMrdC0M2NYsDViT1?=
 =?us-ascii?Q?vvU3yJTQ8FigYwW3Q9UJr8hvLcyQvveyNHdtriTS0iJ4Qj9SMV98CVxzJuhX?=
 =?us-ascii?Q?dDxQFMX+C/whM2ZMAewOsAvl03iaXPKieNlK0rrJI1T/h20aRJ/akXk48lHY?=
 =?us-ascii?Q?97Tkyg5geF7sDr44290FmKyPbBV1cjtnLlFStxtMNruwInXyRxrLA4eijzFL?=
 =?us-ascii?Q?a9gSo5zBkKvmh4SQ9/GxFOnF2tAEQIb/wFdAxZcdr6XOf0fyPfk4A3l5muh3?=
 =?us-ascii?Q?eKi85eku9ZH3+ee9NE4430JIp89DPHkFNfosZ8kqyBmb9hBqoAAEVRMsRwzk?=
 =?us-ascii?Q?QC/LBXUkLSFwZ4/biZ6cTaxSCZInllKucxARMW35a7N5jkgZz9gOFbC3+keg?=
 =?us-ascii?Q?bMnDkx72ERWBeGjQyvC04VXUwOhj8FPfbYZJUm42KVdd5X5ALrsI6xpA5AP4?=
 =?us-ascii?Q?2+RX4RIz6Ipgt0XxV0NWnWgNOAlrbnUXzlq1ZHRkQq28brUiZKZXzs2xhFSH?=
 =?us-ascii?Q?DlgGpchfvxGgbIrNPmutIgWLKbYwZ8js?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(36860700013)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:09:11.4378
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3031440e-b0e9-49f1-4480-08dcb172bbd5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7018

Currently, the SEV guest driver is the only user of SNP guest messaging.
All routines for initializing SNP guest messaging are implemented within
the SEV guest driver. To add Secure TSC guest support, these initialization
routines need to be available during early boot.

Carve out common SNP guest messaging buffer allocations and message
initialization routines to core/sev.c and export them. These newly added
APIs set up the SNP message context (snp_msg_desc), which contains all the
necessary details for sending SNP guest messages.

At present, the SEV guest platform data structure is used to pass the
secrets page physical address to SEV guest driver. Since the secrets page
address is locally available to the initialization routine, use the cached
address. Remove the unused SEV guest platform data structure.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              |  71 ++++++++-
 arch/x86/coco/sev/core.c                | 133 +++++++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.c | 194 +++---------------------
 3 files changed, 213 insertions(+), 185 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 2e49c4a9e7fe..3812692ba3fe 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -14,6 +14,7 @@
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 #include <asm/coco.h>
+#include <asm/set_memory.h>
 
 #define GHCB_PROTOCOL_MIN	1ULL
 #define GHCB_PROTOCOL_MAX	2ULL
@@ -170,10 +171,6 @@ struct snp_guest_msg {
 	u8 payload[PAGE_SIZE - sizeof(struct snp_guest_msg_hdr)];
 } __packed;
 
-struct sev_guest_platform_data {
-	u64 secrets_gpa;
-};
-
 struct snp_guest_req {
 	void *req_buf;
 	size_t req_sz;
@@ -253,6 +250,7 @@ struct snp_msg_desc {
 
 	u32 *os_area_msg_seqno;
 	u8 *vmpck;
+	int vmpck_id;
 };
 
 /*
@@ -438,6 +436,63 @@ u64 sev_get_status(void);
 void sev_show_status(void);
 void snp_update_svsm_ca(void);
 
+static inline void free_shared_pages(void *buf, size_t sz)
+{
+	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
+	int ret;
+
+	if (!buf)
+		return;
+
+	ret = set_memory_encrypted((unsigned long)buf, npages);
+	if (ret) {
+		WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
+		return;
+	}
+
+	__free_pages(virt_to_page(buf), get_order(sz));
+}
+
+static inline void *alloc_shared_pages(size_t sz)
+{
+	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
+	struct page *page;
+	int ret;
+
+	page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(sz));
+	if (!page)
+		return NULL;
+
+	ret = set_memory_decrypted((unsigned long)page_address(page), npages);
+	if (ret) {
+		pr_err("failed to mark page shared, ret=%d\n", ret);
+		__free_pages(page, get_order(sz));
+		return NULL;
+	}
+
+	return page_address(page);
+}
+
+static inline bool is_vmpck_empty(struct snp_msg_desc *mdesc)
+{
+	char zero_key[VMPCK_KEY_LEN] = {0};
+
+	if (mdesc->vmpck)
+		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
+
+	return true;
+}
+
+int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id);
+struct snp_msg_desc *snp_msg_alloc(void);
+
+static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc)
+{
+	mdesc->vmpck = NULL;
+	mdesc->os_area_msg_seqno = NULL;
+	kfree(mdesc->ctx);
+}
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
@@ -474,6 +529,14 @@ static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
 static inline void snp_update_svsm_ca(void) { }
+static inline void free_shared_pages(void *buf, size_t sz) { }
+static inline void *alloc_shared_pages(size_t sz) { return NULL; }
+static inline bool is_vmpck_empty(struct snp_msg_desc *mdesc) { return false; }
+
+static inline int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id) { return -1; }
+static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
+
+static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index e6a3f3df4637..6787d0972a45 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -25,6 +25,7 @@
 #include <linux/psp-sev.h>
 #include <linux/dmi.h>
 #include <uapi/linux/sev-guest.h>
+#include <crypto/gcm.h>
 
 #include <asm/init.h>
 #include <asm/cpu_entry_area.h>
@@ -95,6 +96,8 @@ static u64 sev_hv_features __ro_after_init;
 /* Secrets page physical address from the CC blob */
 static u64 secrets_pa __ro_after_init;
 
+static struct snp_msg_desc *snp_mdesc;
+
 /* #VC handler runtime per-CPU data */
 struct sev_es_runtime_data {
 	struct ghcb ghcb_page;
@@ -2489,15 +2492,9 @@ static struct platform_device sev_guest_device = {
 
 static int __init snp_init_platform_device(void)
 {
-	struct sev_guest_platform_data data;
-
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	data.secrets_gpa = secrets_pa;
-	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
-		return -ENODEV;
-
 	if (platform_device_register(&sev_guest_device))
 		return -ENODEV;
 
@@ -2576,3 +2573,127 @@ static int __init sev_sysfs_init(void)
 }
 arch_initcall(sev_sysfs_init);
 #endif // CONFIG_SYSFS
+
+static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
+{
+	u8 *key = NULL;
+
+	switch (id) {
+	case 0:
+		*seqno = &secrets->os_area.msg_seqno_0;
+		key = secrets->vmpck0;
+		break;
+	case 1:
+		*seqno = &secrets->os_area.msg_seqno_1;
+		key = secrets->vmpck1;
+		break;
+	case 2:
+		*seqno = &secrets->os_area.msg_seqno_2;
+		key = secrets->vmpck2;
+		break;
+	case 3:
+		*seqno = &secrets->os_area.msg_seqno_3;
+		key = secrets->vmpck3;
+		break;
+	default:
+		break;
+	}
+
+	return key;
+}
+
+static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
+{
+	struct aesgcm_ctx *ctx;
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx)
+		return NULL;
+
+	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
+		pr_err("Crypto context initialization failed\n");
+		kfree(ctx);
+		return NULL;
+	}
+
+	return ctx;
+}
+
+int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id)
+{
+	/* Adjust the default VMPCK key based on the executing VMPL level */
+	if (vmpck_id == -1)
+		vmpck_id = snp_vmpl;
+
+	mdesc->vmpck = get_vmpck(vmpck_id, mdesc->secrets, &mdesc->os_area_msg_seqno);
+	if (!mdesc->vmpck) {
+		pr_err("Invalid VMPCK%d communication key\n", vmpck_id);
+		return -EINVAL;
+	}
+
+	/* Verify that VMPCK is not zero. */
+	if (is_vmpck_empty(mdesc)) {
+		pr_err("Empty VMPCK%d communication key\n", vmpck_id);
+		return -EINVAL;
+	}
+
+	mdesc->vmpck_id = vmpck_id;
+
+	mdesc->ctx = snp_init_crypto(mdesc->vmpck, VMPCK_KEY_LEN);
+	if (!mdesc->ctx)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_msg_init);
+
+struct snp_msg_desc *snp_msg_alloc(void)
+{
+	struct snp_msg_desc *mdesc;
+
+	if (snp_mdesc)
+		return snp_mdesc;
+
+	mdesc = kzalloc(sizeof(struct snp_msg_desc), GFP_KERNEL);
+	if (!mdesc)
+		return ERR_PTR(-ENOMEM);
+
+	mdesc->secrets = ioremap_encrypted(secrets_pa, PAGE_SIZE);
+	if (!mdesc->secrets)
+		return ERR_PTR(-ENODEV);
+
+	/* Ensure SNP guest messages do not span more than a page */
+	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
+
+	/* Allocate the shared page used for the request and response message. */
+	mdesc->request = alloc_shared_pages(sizeof(struct snp_guest_msg));
+	if (!mdesc->request)
+		goto e_unmap;
+
+	mdesc->response = alloc_shared_pages(sizeof(struct snp_guest_msg));
+	if (!mdesc->response)
+		goto e_free_request;
+
+	mdesc->certs_data = alloc_shared_pages(SEV_FW_BLOB_MAX_SIZE);
+	if (!mdesc->certs_data)
+		goto e_free_response;
+
+	/* initial the input address for guest request */
+	mdesc->input.req_gpa = __pa(mdesc->request);
+	mdesc->input.resp_gpa = __pa(mdesc->response);
+	mdesc->input.data_gpa = __pa(mdesc->certs_data);
+
+	snp_mdesc = mdesc;
+
+	return mdesc;
+
+e_free_response:
+	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
+e_free_request:
+	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
+e_unmap:
+	iounmap(mdesc->secrets);
+
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(snp_msg_alloc);
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 38ddabcd7ba3..40509fe18658 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -63,16 +63,6 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
-static bool is_vmpck_empty(struct snp_msg_desc *mdesc)
-{
-	char zero_key[VMPCK_KEY_LEN] = {0};
-
-	if (mdesc->vmpck)
-		return !memcmp(mdesc->vmpck, zero_key, VMPCK_KEY_LEN);
-
-	return true;
-}
-
 /*
  * If an error is received from the host or AMD Secure Processor (ASP) there
  * are two options. Either retry the exact same encrypted request or discontinue
@@ -93,7 +83,7 @@ static bool is_vmpck_empty(struct snp_msg_desc *mdesc)
 static void snp_disable_vmpck(struct snp_msg_desc *mdesc)
 {
 	pr_alert("Disabling VMPCK%d communication key to prevent IV reuse.\n",
-		  vmpck_id);
+		  mdesc->vmpck_id);
 	memzero_explicit(mdesc->vmpck, VMPCK_KEY_LEN);
 	mdesc->vmpck = NULL;
 }
@@ -147,23 +137,6 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
-{
-	struct aesgcm_ctx *ctx;
-
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
-	if (!ctx)
-		return NULL;
-
-	if (aesgcm_expandkey(ctx, key, keylen, AUTHTAG_LEN)) {
-		pr_err("Crypto context initialization failed\n");
-		kfree(ctx);
-		return NULL;
-	}
-
-	return ctx;
-}
-
 static int verify_and_dec_payload(struct snp_msg_desc *mdesc, struct snp_guest_req *req)
 {
 	struct snp_guest_msg *resp_msg = &mdesc->secret_response;
@@ -385,7 +358,7 @@ static int handle_guest_request(struct snp_msg_desc *mdesc, u64 exit_code,
 	struct snp_guest_req req = {
 		.msg_version	= rio->msg_version,
 		.msg_type	= type,
-		.vmpck_id	= vmpck_id,
+		.vmpck_id	= mdesc->vmpck_id,
 		.req_buf	= req_buf,
 		.req_sz		= req_sz,
 		.resp_buf	= resp_buf,
@@ -609,76 +582,11 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	return ret;
 }
 
-static void free_shared_pages(void *buf, size_t sz)
-{
-	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
-	int ret;
-
-	if (!buf)
-		return;
-
-	ret = set_memory_encrypted((unsigned long)buf, npages);
-	if (ret) {
-		WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
-		return;
-	}
-
-	__free_pages(virt_to_page(buf), get_order(sz));
-}
-
-static void *alloc_shared_pages(struct device *dev, size_t sz)
-{
-	unsigned int npages = PAGE_ALIGN(sz) >> PAGE_SHIFT;
-	struct page *page;
-	int ret;
-
-	page = alloc_pages(GFP_KERNEL_ACCOUNT, get_order(sz));
-	if (!page)
-		return NULL;
-
-	ret = set_memory_decrypted((unsigned long)page_address(page), npages);
-	if (ret) {
-		dev_err(dev, "failed to mark page shared, ret=%d\n", ret);
-		__free_pages(page, get_order(sz));
-		return NULL;
-	}
-
-	return page_address(page);
-}
-
 static const struct file_operations snp_guest_fops = {
 	.owner	= THIS_MODULE,
 	.unlocked_ioctl = snp_guest_ioctl,
 };
 
-static u8 *get_vmpck(int id, struct snp_secrets_page *secrets, u32 **seqno)
-{
-	u8 *key = NULL;
-
-	switch (id) {
-	case 0:
-		*seqno = &secrets->os_area.msg_seqno_0;
-		key = secrets->vmpck0;
-		break;
-	case 1:
-		*seqno = &secrets->os_area.msg_seqno_1;
-		key = secrets->vmpck1;
-		break;
-	case 2:
-		*seqno = &secrets->os_area.msg_seqno_2;
-		key = secrets->vmpck2;
-		break;
-	case 3:
-		*seqno = &secrets->os_area.msg_seqno_3;
-		key = secrets->vmpck3;
-		break;
-	default:
-		break;
-	}
-
-	return key;
-}
-
 struct snp_msg_report_resp_hdr {
 	u32 status;
 	u32 report_size;
@@ -978,130 +886,66 @@ static void unregister_sev_tsm(void *data)
 
 static int __init sev_guest_probe(struct platform_device *pdev)
 {
-	struct sev_guest_platform_data *data;
-	struct snp_secrets_page *secrets;
 	struct device *dev = &pdev->dev;
 	struct snp_guest_dev *snp_dev;
 	struct snp_msg_desc *mdesc;
 	struct miscdevice *misc;
-	void __iomem *mapping;
 	int ret;
 
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	if (!dev->platform_data)
-		return -ENODEV;
-
-	data = (struct sev_guest_platform_data *)dev->platform_data;
-	mapping = ioremap_encrypted(data->secrets_gpa, PAGE_SIZE);
-	if (!mapping)
-		return -ENODEV;
-
-	secrets = (__force void *)mapping;
-
-	ret = -ENOMEM;
 	snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
 	if (!snp_dev)
-		goto e_unmap;
-
-	mdesc = devm_kzalloc(&pdev->dev, sizeof(struct snp_msg_desc), GFP_KERNEL);
-	if (!mdesc)
-		goto e_unmap;
-
-	/* Adjust the default VMPCK key based on the executing VMPL level */
-	if (vmpck_id == -1)
-		vmpck_id = snp_vmpl;
+		return -ENOMEM;
 
-	ret = -EINVAL;
-	mdesc->vmpck = get_vmpck(vmpck_id, secrets, &mdesc->os_area_msg_seqno);
-	if (!mdesc->vmpck) {
-		dev_err(dev, "Invalid VMPCK%d communication key\n", vmpck_id);
-		goto e_unmap;
-	}
+	mdesc = snp_msg_alloc();
+	if (IS_ERR_OR_NULL(mdesc))
+		return -ENOMEM;
 
-	/* Verify that VMPCK is not zero. */
-	if (is_vmpck_empty(mdesc)) {
-		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
-		goto e_unmap;
-	}
+	ret = snp_msg_init(mdesc, vmpck_id);
+	if (ret)
+		return -EIO;
 
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
-	mdesc->secrets = secrets;
-
-	/* Ensure SNP guest messages do not span more than a page */
-	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
-
-	/* Allocate the shared page used for the request and response message. */
-	mdesc->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
-	if (!mdesc->request)
-		goto e_unmap;
-
-	mdesc->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
-	if (!mdesc->response)
-		goto e_free_request;
-
-	mdesc->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
-	if (!mdesc->certs_data)
-		goto e_free_response;
-
-	ret = -EIO;
-	mdesc->ctx = snp_init_crypto(mdesc->vmpck, VMPCK_KEY_LEN);
-	if (!mdesc->ctx)
-		goto e_free_cert_data;
 
 	misc = &snp_dev->misc;
 	misc->minor = MISC_DYNAMIC_MINOR;
 	misc->name = DEVICE_NAME;
 	misc->fops = &snp_guest_fops;
 
-	/* Initialize the input addresses for guest request */
-	mdesc->input.req_gpa = __pa(mdesc->request);
-	mdesc->input.resp_gpa = __pa(mdesc->response);
-	mdesc->input.data_gpa = __pa(mdesc->certs_data);
-
 	/* Set the privlevel_floor attribute based on the vmpck_id */
-	sev_tsm_ops.privlevel_floor = vmpck_id;
+	sev_tsm_ops.privlevel_floor = mdesc->vmpck_id;
 
 	ret = tsm_register(&sev_tsm_ops, snp_dev);
 	if (ret)
-		goto e_free_cert_data;
+		goto e_msg_init;
 
 	ret = devm_add_action_or_reset(&pdev->dev, unregister_sev_tsm, NULL);
 	if (ret)
-		goto e_free_cert_data;
+		goto e_msg_init;
 
 	ret =  misc_register(misc);
 	if (ret)
-		goto e_free_ctx;
+		goto e_msg_init;
 
 	snp_dev->msg_desc = mdesc;
-	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n", vmpck_id);
+	dev_info(dev, "Initialized SEV guest driver (using VMPCK%d communication key)\n",
+		 mdesc->vmpck_id);
 	return 0;
 
-e_free_ctx:
-	kfree(mdesc->ctx);
-e_free_cert_data:
-	free_shared_pages(mdesc->certs_data, SEV_FW_BLOB_MAX_SIZE);
-e_free_response:
-	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
-e_free_request:
-	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
-e_unmap:
-	iounmap(mapping);
+e_msg_init:
+	snp_msg_cleanup(mdesc);
+
 	return ret;
 }
 
 static void __exit sev_guest_remove(struct platform_device *pdev)
 {
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
-	struct snp_msg_desc *mdesc = snp_dev->msg_desc;
 
-	free_shared_pages(mdesc->certs_data, SEV_FW_BLOB_MAX_SIZE);
-	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
-	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
-	kfree(mdesc->ctx);
+	snp_msg_cleanup(snp_dev->msg_desc);
 	misc_deregister(&snp_dev->misc);
 }
 
-- 
2.34.1


