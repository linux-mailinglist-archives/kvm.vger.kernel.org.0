Return-Path: <kvm+bounces-34589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C66EA025E3
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:48:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4E5ED1623B8
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:48:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17C4F1DE4F0;
	Mon,  6 Jan 2025 12:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Mjc0gNXT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7593F9FB;
	Mon,  6 Jan 2025 12:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167642; cv=fail; b=qVRRIf+msRbom61UDdrTCh8DKfBevGfz8dFcL52QS7g3UU11y9sNLIN05lNDupWWEqoM6xAJuHGgsF6VngGwKqbauEBg2qcROoddXJnSG7QoITBbs4HWunY0Vg/8WOZCeMvKaZ3WNGbXBmAQaKo3gK9YNpTSl3SawLHbvCgV1R4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167642; c=relaxed/simple;
	bh=MLUdooG10KvklRczGgsqsq42+OPuunc7LXIpxnOWMaE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eXoejcS4FuY8s4WkDJphazHQVLWjS4mNr1GQ+OnF5Qgj4UZMQHrr2jj9m+L+LKL4OHP/dWz8tW8/b0Xa/IG/TY4RbuKIgBlRjNQHi+OYqKnH9pbACESz2QZNjCfOcM9xnje2llbqIJTAAiDNPfLp+X46FpClN3vEq2mMAfrtiyE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Mjc0gNXT; arc=fail smtp.client-ip=40.107.223.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lIYYTFyE0JMOGUKHYbyhTFN2/zjKx8awBEQD4BHnKYaB36weD8NZ6hPeAUdHIf7pk6ZOKqTfgrISMwQkQEcqLoL/hdUYN8PzCj+gBIuWVh7VeT6AbHq6WvixBeUrYcvIQeljCaV8ePaCBoeYfEen4jFg6gBYZIUsotJXDpy+mF9EiIEIf0AJwTUimE1PmaWlALTRjammnhoehu0P/ZFfcQYMyEMCSAVagPUv37j9xL3F6vDW8UfLG+qqUPDAWzIX/wzJyngTSsYFYNjFfnoXmKT6J7bPpvG0r8FYNDa4f0syCNVmrWuHwWFa6sHxeCtdDbazTUpbsq0DpiSndvq/OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XESR3Jt0ZjK6zT3yKzmiAXPTpuEXQ8FsaxRuL87e6rY=;
 b=ZAVKRsJH6d9voxW6WQKep65PmGJM9q6uciUshQLPzj2/mdNjrgQt0YnA9cvMbx6Aj4/Cbya6GDrNUq4+EkvHwFoPv+cxisNj/IFrZg9HQZrjGy6xV73SArPZhVIPixi+h/s1P2iwLIY+KeYL7K6xfM4zQI6EaSiJLkasUeeJhGvcyZSkfpnXMzJOwicCV23ZjbNaAN5bEbSM8jZ6xP7TlgdSuGEiq2sQL8VfW6krdjVHpGgqN3Iy/dAG/ZjhNi6GakhiqjGzLwIpTTpgi9t7xStfpBvNiWU2l1zfM56CRrkBESPHN5iFFTVToL/rOMkGgyFBlWK3SFicLzKlXiSIrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XESR3Jt0ZjK6zT3yKzmiAXPTpuEXQ8FsaxRuL87e6rY=;
 b=Mjc0gNXT8xu4qZpTcCr9EzOxrquNi1G2chrvhRlU4+teoqEfE6QTMf4urIOLmVaL0T9ZhvooiJ2jPJZVAoVppzb2Hm9tgET6haqRyiV8PchXQ37TEMg3/hfjtwxssrHKi3PG9p1jX5F25Wuy8Z8oKnR2pLmTwsPKiRh3dGkV9qQ=
Received: from PH7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:510:33a::34)
 by CY8PR12MB8364.namprd12.prod.outlook.com (2603:10b6:930:7f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.17; Mon, 6 Jan
 2025 12:47:10 +0000
Received: from CY4PEPF0000EDD7.namprd03.prod.outlook.com
 (2603:10b6:510:33a:cafe::10) by PH7P222CA0013.outlook.office365.com
 (2603:10b6:510:33a::34) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.18 via Frontend Transport; Mon,
 6 Jan 2025 12:47:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD7.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:10 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:05 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 03/13] x86/sev: Carve out and export SNP guest messaging init routines
Date: Mon, 6 Jan 2025 18:16:23 +0530
Message-ID: <20250106124633.1418972-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250106124633.1418972-1-nikunj@amd.com>
References: <20250106124633.1418972-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD7:EE_|CY8PR12MB8364:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ab8236a-e80f-42a7-a6ab-08dd2e503c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zxJOA89hy2bahoHJqfalwMIGN4Lz17WfkhKqK9BKG9W8W8dXgTi8is2cltoq?=
 =?us-ascii?Q?psqKty8AGoElLsXktC48rj0rTve12l2H4vnsic/oG+MVShpvQTidNtcj6lkb?=
 =?us-ascii?Q?cFBi5sMIvZEq+tyPV/KXQVmUolqFFjOVn2nFRosyeEJuY9bBnTYcieiJdJZd?=
 =?us-ascii?Q?afdDk8unDJ5XyKfsORB2I4SSQ6bVYOe2V9FzO2NfVHMIQbmExnCSWVbWnpo/?=
 =?us-ascii?Q?SLuWj3DA8VKIQ6LpHcgJ1XHU5+nIZMcqyBVWx7AHdJ2nF7FxaDkno+8Rcg4w?=
 =?us-ascii?Q?8MSlnFRfW8Ikv3lDIfLe8v3HvuVDgH/2cJrZScdwVsUPvU2pz7yxqdcRj3ml?=
 =?us-ascii?Q?zC2gKh8rUJzRyCMed+erndSZcyu53A0MZLd9yblEYygkUl4Nt6XmVkClyhL0?=
 =?us-ascii?Q?JUHbrpufrm9FvOHIJ4e+OrFVFmJAVJti8lmoQ/UapGI7bJD/OdrvIROFPtsJ?=
 =?us-ascii?Q?K9grHOjZzCO6JpJe1uWsK1nmB8BIs7AXKuEfBuoQElKintQ4x11gTfhVj9ux?=
 =?us-ascii?Q?dvSOEWyHiAVCVxfHTdh5doOdq5j4DEzupBRA5BiEBiUBn54qRgmodBbkuEMr?=
 =?us-ascii?Q?hHOdKsSkpiX4crzV3RczYngfJ93RTVxX3LVdOxWRBcYfPMlDC1JBtjwc0sH9?=
 =?us-ascii?Q?1o2+qbLRqJQnrngJM/zrGvpOo2xOW4fw/EC40ldDVOEOCn72gXBQfjn7z6xP?=
 =?us-ascii?Q?PNptd8h+3VDE4jgQRZktYKF7pS0X8IH+bXIvgiCFsGQb13TvRku5w7MhH/qe?=
 =?us-ascii?Q?e2P5+wJbnlUrXYEXkP+dBxwOer2sBl5noFplpFGBi+gcNOHHp3PAQH2RkHuM?=
 =?us-ascii?Q?7uclGyA/IDGKGvl/tdLXqQ5NpcV/S62tgvnqHKOGkk6q9ihRglKJ0GohjeBa?=
 =?us-ascii?Q?JlQQheYLvedSSDAdFz5u5wyVS4/m3gn3HLZCL6HWmqfPdgZy2Cx2pIlISs0d?=
 =?us-ascii?Q?mJfuAvHIkUm2852dXNng6s5smNLMEGxbAwAFhnmeZVdREsTLswgobhbM84sk?=
 =?us-ascii?Q?EkHpjobrLnO2NL90CC5FwP1LMYsbNuP9nLplpXO3uDbWv/2Ml8k7JGmwiEU4?=
 =?us-ascii?Q?RfJeGMTFwfPjMt0b1JOaCOTAok0C5ECfmFJrk3w99Z6y/Qh/67/lJD2dyPz9?=
 =?us-ascii?Q?5vLzF2eBOqJZq0pLRKZd2RcrtDDSu7+tXWLglcsMqAEG1D8pPMgzQ5fTaHd5?=
 =?us-ascii?Q?BUskuWGta82dtgQFy8qCaAJenpd+MAJtUw9rkctyXnDAWFLRfcJ+grz7bReq?=
 =?us-ascii?Q?Vccc4Ux6StfKttRFb0gmTLZJFmr65/Dza34DgxFmCGIDEKMkVdoAeIgGaTj4?=
 =?us-ascii?Q?GZO65M2/vc7fVGMk0BKQaKuaspcMukCwXLZs+1RoGm6+IdRQguCCwII5oT/z?=
 =?us-ascii?Q?a99qsoVS5VxhtP+SVptD2xhApKGlzQEHPgQCzTfo2a6PSZZ5LT5BxGEHz7YF?=
 =?us-ascii?Q?71zMslO0eYDcfaI7KjFHYOdOZ7uJ+5Qe+t0EOWJBrT2R/sRR64wPLZ4Mk7RC?=
 =?us-ascii?Q?M645HuokJbChxD4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:10.0840
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab8236a-e80f-42a7-a6ab-08dd2e503c6d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD7.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8364

Currently, the sev-guest driver is the only user of SNP guest messaging.
All routines for initializing SNP guest messaging are implemented within
the sev-guest driver and are not available during early boot. In
preparation for adding Secure TSC guest support, carve out APIs to allocate
and initialize the guest messaging descriptor context and make it part of
coco/sev/core.c. As there is no user of sev_guest_platform_data anymore,
remove the structure.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              |  13 +-
 arch/x86/coco/sev/core.c                | 183 ++++++++++++++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.c | 185 +++---------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 5 files changed, 208 insertions(+), 175 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 91f08af31078..db08d0ac90be 100644
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
@@ -458,6 +456,10 @@ void set_pte_enc_mask(pte_t *kpte, unsigned long pfn, pgprot_t new_prot);
 void snp_kexec_finish(void);
 void snp_kexec_begin(void);
 
+int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id);
+struct snp_msg_desc *snp_msg_alloc(void);
+void snp_msg_free(struct snp_msg_desc *mdesc);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
@@ -498,6 +500,9 @@ static inline int prepare_pte_enc(struct pte_enc_desc *d) { return 0; }
 static inline void set_pte_enc_mask(pte_t *kpte, unsigned long pfn, pgprot_t new_prot) { }
 static inline void snp_kexec_finish(void) { }
 static inline void snp_kexec_begin(void) { }
+static inline int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id) { return -1; }
+static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
+static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 499b41953e3c..93627a21945d 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -25,6 +25,7 @@
 #include <linux/psp-sev.h>
 #include <linux/dmi.h>
 #include <uapi/linux/sev-guest.h>
+#include <crypto/gcm.h>
 
 #include <asm/init.h>
 #include <asm/cpu_entry_area.h>
@@ -2575,15 +2576,9 @@ static struct platform_device sev_guest_device = {
 
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
 
@@ -2662,3 +2657,179 @@ static int __init sev_sysfs_init(void)
 }
 arch_initcall(sev_sysfs_init);
 #endif // CONFIG_SYSFS
+
+static void free_shared_pages(void *buf, size_t sz)
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
+static void *alloc_shared_pages(size_t sz)
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
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
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
+	if (!memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
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
+	void __iomem *mem;
+
+	BUILD_BUG_ON(sizeof(struct snp_guest_msg) > PAGE_SIZE);
+
+	mdesc = kzalloc(sizeof(struct snp_msg_desc), GFP_KERNEL);
+	if (!mdesc)
+		return ERR_PTR(-ENOMEM);
+
+	mem = ioremap_encrypted(secrets_pa, PAGE_SIZE);
+	if (!mem)
+		goto e_free_mdesc;
+
+	mdesc->secrets = (__force struct snp_secrets_page *)mem;
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
+	return mdesc;
+
+e_free_response:
+	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
+e_free_request:
+	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
+e_unmap:
+	iounmap(mem);
+e_free_mdesc:
+	kfree(mdesc);
+
+	return ERR_PTR(-ENOMEM);
+}
+EXPORT_SYMBOL_GPL(snp_msg_alloc);
+
+void snp_msg_free(struct snp_msg_desc *mdesc)
+{
+	if (!mdesc)
+		return;
+
+	kfree(mdesc->ctx);
+	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->certs_data, SEV_FW_BLOB_MAX_SIZE);
+	iounmap((__force void __iomem *)mdesc->secrets);
+
+	memset(mdesc, 0, sizeof(*mdesc));
+	kfree(mdesc);
+}
+EXPORT_SYMBOL_GPL(snp_msg_free);
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 250ce92d816b..d0f7233b1430 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -83,7 +83,7 @@ static DEFINE_MUTEX(snp_cmd_mutex);
 static void snp_disable_vmpck(struct snp_msg_desc *mdesc)
 {
 	pr_alert("Disabling VMPCK%d communication key to prevent IV reuse.\n",
-		  vmpck_id);
+		  mdesc->vmpck_id);
 	memzero_explicit(mdesc->vmpck, VMPCK_KEY_LEN);
 	mdesc->vmpck = NULL;
 }
@@ -137,23 +137,6 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
-{
-	struct aesgcm_ctx *ctx;
-
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
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
@@ -404,7 +387,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 
 	req.msg_version = arg->msg_version;
 	req.msg_type = SNP_MSG_REPORT_REQ;
-	req.vmpck_id = vmpck_id;
+	req.vmpck_id = mdesc->vmpck_id;
 	req.req_buf = report_req;
 	req.req_sz = sizeof(*report_req);
 	req.resp_buf = report_resp->data;
@@ -451,7 +434,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 
 	req.msg_version = arg->msg_version;
 	req.msg_type = SNP_MSG_KEY_REQ;
-	req.vmpck_id = vmpck_id;
+	req.vmpck_id = mdesc->vmpck_id;
 	req.req_buf = derived_key_req;
 	req.req_sz = sizeof(*derived_key_req);
 	req.resp_buf = buf;
@@ -529,7 +512,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 
 	req.msg_version = arg->msg_version;
 	req.msg_type = SNP_MSG_REPORT_REQ;
-	req.vmpck_id = vmpck_id;
+	req.vmpck_id = mdesc->vmpck_id;
 	req.req_buf = &report_req->data;
 	req.req_sz = sizeof(report_req->data);
 	req.resp_buf = report_resp->data;
@@ -606,76 +589,11 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
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
@@ -969,13 +887,10 @@ static void unregister_sev_tsm(void *data)
 
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
@@ -983,115 +898,57 @@ static int __init sev_guest_probe(struct platform_device *pdev)
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
-	if (!memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
-		dev_err(dev, "Empty VMPCK%d communication key\n", vmpck_id);
-		goto e_unmap;
-	}
+	ret = snp_msg_init(mdesc, vmpck_id);
+	if (ret)
+		goto e_msg_init;
 
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
+	snp_msg_free(mdesc);
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
+	snp_msg_free(snp_dev->msg_desc);
 	misc_deregister(&snp_dev->misc);
 }
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e4e27d44dc2b..ba2ac635c2fc 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1559,6 +1559,7 @@ config AMD_MEM_ENCRYPT
 	select ARCH_HAS_CC_PLATFORM
 	select X86_MEM_ENCRYPT
 	select UNACCEPTED_MEMORY
+	select CRYPTO_LIB_AESGCM
 	help
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-guest/Kconfig
index 0b772bd921d8..a6405ab6c2c3 100644
--- a/drivers/virt/coco/sev-guest/Kconfig
+++ b/drivers/virt/coco/sev-guest/Kconfig
@@ -2,7 +2,6 @@ config SEV_GUEST
 	tristate "AMD SEV Guest driver"
 	default m
 	depends on AMD_MEM_ENCRYPT
-	select CRYPTO_LIB_AESGCM
 	select TSM_REPORTS
 	help
 	  SEV-SNP firmware provides the guest a mechanism to communicate with
-- 
2.34.1


