Return-Path: <kvm+bounces-28208-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58C2999656A
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:31:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6966E281F99
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B605190074;
	Wed,  9 Oct 2024 09:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MX6J9orf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2082.outbound.protection.outlook.com [40.107.244.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EF118C924;
	Wed,  9 Oct 2024 09:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466183; cv=fail; b=HnG8QHyVUSgIHy6XRJTt9d8aUEoaC67elZk8/mF4d1HuCZOPF8OuTJ1YhODnFnI03uIPWSuwjTcVkQZ33MOGsqXtyrALoIQdbqWy0slzGziC6ln+dAeo/8Zm9iRmjAL2t+wvZczM+ESP6AcVclTNsOoqwJ8oCH0hgmp5+IYgjcE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466183; c=relaxed/simple;
	bh=9FtYHJDdjQ2b/4jkYDFLyiII/hORpMxkuuswJ+Ls5us=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U1d22FHGTi4XNqXP2XmYtgG3iY9juyboaSTKBF6liTysC+yxUiMlT53q+uK1KXin8B7JsRYED/OQleFrkpGsRjO3rYUACWyCJGWYXoD4CV8AkVnQ7Y3+zBLPd6EeF9y7WxrSo6rBh4Q5Y9Nrgal9HvxIXiFt4CxxIFAiCMk32ZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MX6J9orf; arc=fail smtp.client-ip=40.107.244.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Zw+jO06SnomSTvpD5c64pa+hCBIXtHOsH2K5Po8CGxBREtrn5F/osP6u2NrT2ZEBo+JAGfKiIrdjncQA+cAwdoRIyVR6i2O6Dr0RMA2QD2MreI1lmjDEp8SQ5kqbzney/ejjxJSkoXh2uy68mxZfr5IggJEuNwd2dVlNbtYeOc5eUng5ktAs9q4s+vUGwTyLsU6W9SilskExFCAXsrrA1iNEquM3zZ+qFjE+xGmvhP3TMXOC4g52W+UbTPTDDBtWnhS+xZ98nYA7HLDHZO/ZumJ80yqM2c3nmBWLtozZ98f2tETAZCkTbhRU9qfti53/zMjd5imLCx429lgeBZ7MFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wDe9R4PTkRjpBr9+zKgRN0Xh5Jd7nmYhHrry+4ArABQ=;
 b=O5o9PlMDBvVu67ZHJhVFwYEgNYNhqXFtL1EHE/48VbBUmIW81OdQ/XKho1dtmUUGq1nblrOQJUqoPUUxzYDohde/LLMQJ0Ht0sKx5t63bkTv2HefWBqtmG1urjhFDPrJlcGJjm1XdNEOBTkCp3/amYyxeMRvaRIPpJhIQEspAWzQ7B1ZaTjg1bx2x6+1jxmCyX3CevZ7O4gvaQT/JKWojNkmId/bCmKauXql3L3tJcz08ImDaE9QHjFsMs4uVrNHRvwD1o0fBTJ7Mgv+FXSGd4w2qUoV57ibytfTteJe0M0Sm3EaBBs3CGEswLtXAuL06TSEiZAZ6FUtuLAOHFaATQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wDe9R4PTkRjpBr9+zKgRN0Xh5Jd7nmYhHrry+4ArABQ=;
 b=MX6J9orf39q4pCpoVhSgyKBWEDZo1/Zb+H25nX/+BEoUEJAbU2BPZQlWQRKy0FWAPDU1mZUTAsGhOFAeQWigNZIoiYMws+PdKRXHJL+KZJSrKHiCdVxS/Z9VYf5iOAx/El+EsY0Wck+3fvps+TWq/nvnLuXwvHV9uGZYmo0FeEA=
Received: from MN0P220CA0017.NAMP220.PROD.OUTLOOK.COM (2603:10b6:208:52e::10)
 by SA3PR12MB9129.namprd12.prod.outlook.com (2603:10b6:806:397::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:29:36 +0000
Received: from BL02EPF00021F68.namprd02.prod.outlook.com
 (2603:10b6:208:52e:cafe::d5) by MN0P220CA0017.outlook.office365.com
 (2603:10b6:208:52e::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F68.mail.protection.outlook.com (10.167.249.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:36 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:32 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 07/19] x86/sev: Carve out and export SNP guest messaging init routines
Date: Wed, 9 Oct 2024 14:58:38 +0530
Message-ID: <20241009092850.197575-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F68:EE_|SA3PR12MB9129:EE_
X-MS-Office365-Filtering-Correlation-Id: d6571bf0-b95a-4036-b16d-08dce844e467
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|1800799024|7416014|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HGU4SEz8cECANmKXRd83mnHZ1cD8xBhI9+7DVOGuHrd7AkSaEbKAcjtfTqQd?=
 =?us-ascii?Q?NN1iBHMF5g/E5uU0nFfd//cKwomP8BfS3MN2Ew/t9rYWZptvecjJAWztY8Cj?=
 =?us-ascii?Q?Ogn+1QSOleyu5umjLGwqiPy32HAQgOjFnd63LPUiezwaz4ZB7jZsAxi2onv4?=
 =?us-ascii?Q?GaZU4LS1fRzA/hy8fp0Rnh3yhPhEJJFK78uED8dQA4utvUKqbB5Brmr7Orzj?=
 =?us-ascii?Q?J6iR2OYQd1q9/02FkdrsrfKbCRsnxqZ3N2zSZvtTMOCMgO4sIPYhUQyY3sZG?=
 =?us-ascii?Q?Xxd1BZIJ7yKu9cSVR1JwIoNcd012xwLp8v7mfKTutV/ZZX1OXTXMNyD1kTcn?=
 =?us-ascii?Q?Ev74qcl3yf/rK7Oe9jlzj6CGfbzNEVb8LvjzIo50tnpuhHhzgWKDHfVeokXe?=
 =?us-ascii?Q?y51YI3kfwHJZtB7gg9V6w8zYm41UapAnctYr83sLT7tMWzbK2VIU+0Qhe3bo?=
 =?us-ascii?Q?IyAHfa81kpkUmqpBHQ0rquZFRROtGgQwu52Kz85yHIiwFyM9RJHXFs9evgvR?=
 =?us-ascii?Q?82EZtpXv0j3jQA70zIVKv3CnKACYv006cKKKmloFd4k7GI6PZApYdKwdQ37n?=
 =?us-ascii?Q?08GJ02JPCsmNNAkbe410jO8HHOeuxWgZPzTGUXdTWV/UcbnVW5s1BoIXrViW?=
 =?us-ascii?Q?2/a+gtERMFN4w0XaJDxPenixXoGMKkOoDlq7EI51KWrQAQZ8ZAQP1zK06Ob6?=
 =?us-ascii?Q?4c8ak9dKAxvsbgG731t0gCCIxT07+9PulBUB1bPvJh0va41AHY7HjFx1an6F?=
 =?us-ascii?Q?oqWzat7XiySFYUyopjHjwdnomCCyNDd0bw0E/O5wtp+1awZSL733LvguGYHA?=
 =?us-ascii?Q?MsHr3Z29X1wUVqbPs6f8ai2PJfUindELjF6H7rIN6LYR9cZX58CcQ8QuNMX5?=
 =?us-ascii?Q?whIlwdSbyIp92WpSHFkhlee+cwat+cTyDZ0BR4TLgUO9qJ0rFIavszb+/LMg?=
 =?us-ascii?Q?KqTz6fJHKPgRDibZs46QkK6WQUmt6QvIEUXf/deBrWTkPBbxm0WVu0fwN5ZU?=
 =?us-ascii?Q?yq+TPYJlnhEAC8FSsco3pizIukH6b/hYBW4aMmYm0gp4nJniG0tFy1ob8ySE?=
 =?us-ascii?Q?ZjzoVzLq3oiJv37BHWTQgIYj4liTS7p5wadISiOUUcSBDHFbwLtWl3Ni5TDz?=
 =?us-ascii?Q?+89rQjpZeqyFLjmOAYyK5ZOKvB5KqK6PdQA1U+KTpet05U70+ZKBPRHPPGQK?=
 =?us-ascii?Q?o48/mzhm52jG/slKKI+968W9SIP7mk4/6rP0t9oBETq8vIpO4nKIiB1XAS0+?=
 =?us-ascii?Q?NdzhtXRX6Wob5gMLl5drWNf0mdGdfZG+R6IGC/GIJloAskSMH7QJLjfp7h1M?=
 =?us-ascii?Q?D/eqk2oDLmCTMuEZWgpVwcCe8Ou8cpB21Ad9RS7UJG7Y/Mq7Zmy5rgIh13cS?=
 =?us-ascii?Q?CQMOQef/CSnVCX21Yp8JwFfo08/3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(1800799024)(7416014)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:36.6407
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d6571bf0-b95a-4036-b16d-08dce844e467
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F68.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9129

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
 arch/x86/coco/sev/core.c                | 132 +++++++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.c | 195 +++---------------------
 3 files changed, 214 insertions(+), 184 deletions(-)

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
index f40a2df38a84..78be066a0452 100644
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
 
@@ -2576,3 +2573,126 @@ static int __init sev_sysfs_init(void)
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
+	mdesc->secrets = ioremap_encrypted(secrets_pa, PAGE_SIZE);
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
+	iounmap(mdesc->secrets);
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


