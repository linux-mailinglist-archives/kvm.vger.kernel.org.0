Return-Path: <kvm+bounces-29802-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 345309B2460
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:37:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 579081C20446
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0E4019007F;
	Mon, 28 Oct 2024 05:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="vwiEp3wF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF7A190059;
	Mon, 28 Oct 2024 05:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093722; cv=fail; b=sIrlXt6dm/ZeWuXAkUcdhySVgfVDWfZaSlB2I62lJATp1gIWP0PRp22igINz6473GI4rTbeLSJXQpLmXt7hc9oIn3f7FqjkWzR4vu9O3m/JvUXRUt8ZqtcRKKz6ktaa2dd1WF4fPcI828rwT6D84rzXqNOa9n3cS6uRV3Coe3FA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093722; c=relaxed/simple;
	bh=pME00bVnTJogCyHOxeOmNwbWSncjjDziRL7bZH4hGeY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iQRzsHGIQgbXHeRjQJbERbb1TwWiDJdBNMzMXwCXwAOePD2ejZbgnMarMtFd7NuHgEvuqz08sFleft70YL2Etgh+lEgnAQLL2Gzdd2hr8bq6mvY0oxyhpwAvKbrhohoNQ3wgIgJrgeLCa4CMMz6/8O5VR5/V8D662cPqQPPqkIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=vwiEp3wF; arc=fail smtp.client-ip=40.107.94.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PWntWVf9YcvrEgsFtA0/clIGQeIydS4XkCL68a7qnbphNN+O8dTH4YKCMcSNZD8E3synJnRJO3c9cB2goxGNJtmZtF+LSw99UsCW6ejmM4H1lI4TvvSmSDKCv5gPkzf4+8HordAuEeJkxZUy3HZnZ96q6Inmp6Pnww1219dAbgAwegy+IaF0y65v1uKzTX1BOMYHNNYmwdsWF1/ANjiOq7YKe2xUTPukXYKtut4+NheahWGnOqeD0jTeDqQYSg+2woXafWUqirhndHZsj49YbuUfGj63A5EV/dVd2hlyRA6T95uwMbO5+3by2pwScAf6VXLM8c2ozQ7eq/tP/jAScA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cgnZz6sBWYHCJXbdUT93V5kE72/4pEh6Tlp+77STnTw=;
 b=JcyKCZXw2S7/ldqH0H1crTDbvOEwBX3ceFA4iRY0y5SNOvtPC6nrvNYByHcale03zILMo+TsTRbAb0rCqqkgORcn4PMBAyCDK4/xKbPjPri34WEhD5H0p48BmvPHjBgMd0BZTkT6LUDs2fe5JQgmQcO7xRfxOvfk+3T+B2VgOnP2qALDaRAXpGd5cNrSKV3dkoppqRR46BVnVpnIZ+dLEVyt6JbrVW5/7Ipp327pAT1WGQysOfHkCFyOtwSknwymhe3MuT6BE3Tc+t7WyYfa9LRGMpVuTCuglIXLYXUGJmrIhxDuZ3Aq0UPKvdePfZB1DXdPa/1qUuSkwtLArynWjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cgnZz6sBWYHCJXbdUT93V5kE72/4pEh6Tlp+77STnTw=;
 b=vwiEp3wFuKtyo0j1ve5+uhCKWutNcexvxHCM+nH6jgDk7EXn115fxVyX8Wwz1cXPqJExz/OUfglA6dCgOK1ogd4Pvs1uPirbD15BfiAWUGxVhPClh+8ZwUO9qj2I2ePv9sPk2bsy/ML1x3OgnYevNanV/DPqOL61fnVSLnK4cG4=
Received: from BN9PR03CA0931.namprd03.prod.outlook.com (2603:10b6:408:108::6)
 by DM3PR12MB9413.namprd12.prod.outlook.com (2603:10b6:8:1af::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Mon, 28 Oct
 2024 05:35:13 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:408:108:cafe::df) by BN9PR03CA0931.outlook.office365.com
 (2603:10b6:408:108::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.29 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:12 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:08 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 01/13] x86/sev: Carve out and export SNP guest messaging init routines
Date: Mon, 28 Oct 2024 11:04:19 +0530
Message-ID: <20241028053431.3439593-2-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|DM3PR12MB9413:EE_
X-MS-Office365-Filtering-Correlation-Id: d8a68ac7-47ae-481a-463b-08dcf7124baa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?8qK8g8/rbq4XTJtYjEHxxghK46/ersWYT7VR1+TmnCfM7coIbrUb7LYyP8U7?=
 =?us-ascii?Q?IsyZy9aDNfajvWX9f1WmoMqzoHcEnwPon4IsRuLJQtYBfFx2BtxmfTXK9Ll2?=
 =?us-ascii?Q?qqQeq8mg2MG0DZamHLCBlSdDvcHhf8XeQ6+Bu0rH1z3cAIDPHAWZKjKBtssj?=
 =?us-ascii?Q?rnrLOMoXdaoovJIx4cZ7Bj3GhiOIaXVOV9nJotJtmgvlJ2/KCnrXyR0NGIF0?=
 =?us-ascii?Q?xl2WYbVDMBcRCRs/LMan5QTD6BGUYsSJrpoOgRjyKIFr07eiurD7OoWYL/0J?=
 =?us-ascii?Q?Axk6G3aZGBBryc7KCzgTJAKwfRn4XoS4noy1MD/gQJPwuV7GiPm/hLst6qws?=
 =?us-ascii?Q?aGnVQ/KNqW2bnNtpaD7kne+aB+0EQ/GX0pitcfYgibMctxx8wjCy6shrA7Za?=
 =?us-ascii?Q?n85j3dO8lZI4OMKoJdM8BSn0P2unZ5vJoOashzvZGRsadWWHtpRf/ort0E+I?=
 =?us-ascii?Q?DotkdwLEZwDhOk/c7np2hd+eLRHcGvTXjmS0YXi8SZlE46RpNXhsQ5gSAyKU?=
 =?us-ascii?Q?mbQKLEmGt8/wsJJ4uw0REINyOzQWFQ/h4SykPMWSaiwLPWLKvGQnZCz0nsF8?=
 =?us-ascii?Q?kYaxiqNxVWiEY0V8PnLVJp0FaFn8UHpVQErMnYJglzJUFmu5rx6SDavi8OIB?=
 =?us-ascii?Q?U1nEXrswzbWkJyW7FPFkD0bJrqHOxqPWuGuhLQ12vwRiB792YdpatKLPuzzj?=
 =?us-ascii?Q?TTjX1nwG0dm5yDEMLYu1ed9QjaBkXz9rcU/BqCweJiRBRlQ2Us0O3YjFZQao?=
 =?us-ascii?Q?cI2ATDk1Ri7th14fAx7nU45D4mhd4kjEFcsbuXsd0FrpmhjqSurUFI/d+k+Q?=
 =?us-ascii?Q?FRUdvwYoPFw3u8a870G/ivccgwgEUW7mJCNBqytv/kZtDWFfTB8cD+qySMsL?=
 =?us-ascii?Q?oAFP97cjkhR6PbnZqTLZl+3UDoaJg3asJ2ZkLEmM9AB/AWErzuD4BymSIJa1?=
 =?us-ascii?Q?sQI75yMU2p6zsvsI5QxxfR/GEK8vo3rYDZ440EQGQOJ6Yn8b+IW0xvuazMbh?=
 =?us-ascii?Q?x2f3PBYzNHyGZIeJtBO0beNVDFDLG80Na8nnYSq3ZPEiOON0yx25XGp7208A?=
 =?us-ascii?Q?L9U5sjRclfrmH6ZxnZX2MNwZPwSzljzpDjMSlXhF+SZusYdAtjdDV8snHFHZ?=
 =?us-ascii?Q?juFBuiOlE9obBXNkbR2Nr070YzooN2e8nzjhA49WILmVtUDVus0bgKs+Ckbq?=
 =?us-ascii?Q?k1yReVqwcQ+/du67anl3FqyCJ3rRl09D2vttT8u721k/2pYOUekAH/ewOty4?=
 =?us-ascii?Q?3OjcpNR6LVLDHE95gmpQ0YBq5X3ky/2Psy4JYxfVG3ARJ9RdniNmg2PSTeSS?=
 =?us-ascii?Q?bi+GcmXLAkImt9Wu4hp0yDJJ9UBXn2JtyXwtR1FEGqZNkcAfo1AC1UebQn72?=
 =?us-ascii?Q?WykZuJU9w5n6dlEe1X4ng2zd/8ALBzRCd4oTVlvtR+xpQIxz1Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:12.9283
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a68ac7-47ae-481a-463b-08dcf7124baa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PR12MB9413

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
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              |  71 ++++++++-
 arch/x86/coco/sev/core.c                | 133 +++++++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.c | 195 +++---------------------
 3 files changed, 215 insertions(+), 184 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 2e49c4a9e7fe..63c30f4d44d7 100644
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
+	static const char zero_key[VMPCK_KEY_LEN] = {0};
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
index c7b4270d0e18..6ba13ae0b153 100644
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
@@ -2445,15 +2448,9 @@ static struct platform_device sev_guest_device = {
 
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
 
@@ -2532,3 +2529,127 @@ static int __init sev_sysfs_init(void)
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
+	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
+
+	if (snp_mdesc)
+		return snp_mdesc;
+
+	mdesc = kzalloc(sizeof(struct snp_msg_desc), GFP_KERNEL);
+	if (!mdesc)
+		return ERR_PTR(-ENOMEM);
+
+	mdesc->secrets = (__force struct snp_secrets_page *)ioremap_encrypted(secrets_pa,
+									      PAGE_SIZE);
+	if (!mdesc->secrets)
+		return ERR_PTR(-ENODEV);
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
+	iounmap((__force void __iomem *)mdesc->secrets);
+
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(snp_msg_alloc);
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index fca5c45ed5cd..862fc74452ac 100644
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
@@ -414,7 +387,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 
 	req.msg_version = arg->msg_version;
 	req.msg_type = SNP_MSG_REPORT_REQ;
-	req.vmpck_id = vmpck_id;
+	req.vmpck_id = mdesc->vmpck_id;
 	req.req_buf = report_req;
 	req.req_sz = sizeof(*report_req);
 	req.resp_buf = report_resp->data;
@@ -461,7 +434,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 
 	req.msg_version = arg->msg_version;
 	req.msg_type = SNP_MSG_KEY_REQ;
-	req.vmpck_id = vmpck_id;
+	req.vmpck_id = mdesc->vmpck_id;
 	req.req_buf = derived_key_req;
 	req.req_sz = sizeof(*derived_key_req);
 	req.resp_buf = buf;
@@ -539,7 +512,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 
 	req.msg_version = arg->msg_version;
 	req.msg_type = SNP_MSG_REPORT_REQ;
-	req.vmpck_id = vmpck_id;
+	req.vmpck_id = mdesc->vmpck_id;
 	req.req_buf = &report_req->data;
 	req.req_sz = sizeof(report_req->data);
 	req.resp_buf = report_resp->data;
@@ -616,76 +589,11 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
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
@@ -979,13 +887,10 @@ static void unregister_sev_tsm(void *data)
 
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
 
 	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
@@ -993,115 +898,57 @@ static int __init sev_guest_probe(struct platform_device *pdev)
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


