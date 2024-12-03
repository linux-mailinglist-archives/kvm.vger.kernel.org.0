Return-Path: <kvm+bounces-32899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F9329E168C
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:01:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B7CCF164BDD
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C76381DE8AA;
	Tue,  3 Dec 2024 09:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bO5EwG/5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D477A1DE4F9;
	Tue,  3 Dec 2024 09:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216483; cv=fail; b=tgL0RH92TqTzxMWRnHDois6q9cbX5mR0vT+OCDRbD5X4mNXKEmCRYdYgwaOaBbgIszERDhLPH997WfT33iT8JHcQnD+53TnwvBXkIMvf4Ck717TegIZhFgREWgL34LDw9KL17XNwZDkQa4lIMbH0dMzKxYV3b38v+ApEY2DWUik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216483; c=relaxed/simple;
	bh=F+foVLc233A2V00/YJkLSr4JmHFptVGwLoedSWjJgm0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WVxGZrapgGgHuJovy1des9wAkxL/8AJYzxydHXWypDfdZyEZR5F3Y47/NzQwyxzESGmDXt970lqGqzMNbU7z2U7U9Mz9TKVdR3hEL2+x7TuclNfN39Hjxt+0U31miKlr5Zw2NUWaaHWoRUbR5YcnDl0id9iRoV7NPhhZwJmRmiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bO5EwG/5; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pa1/X/r8eEN66qM59l6Y5AUJlZryv6t5JF5wES1N8bRG9Mn393wmp0g0xOYlbcMJGD5qBEaZGturfwcGsuYQnncY6bsOz8et3/pNBmP1bxDQjDASjclAep/z6tsrkhoC6YWZSUScdZmhHLh6mFEtNF4Zydg4yMralR3YVmc7WIsYt0C3CDKEdrnd6EUB7Qhu3vcBFaTW1P8Y8vtEP3kCNiC00VOtfZdMvuNx2EaIgJn7Q3KH052mx5AG6l+vBTGLHtJsg6ZGBmGW6iIclVPL+XMZ07Yau+gtz0dhzpLO4USaYkWHu4mx1C5SYRvLqYuCJ1QxIScKG7AgeBtsff0plA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UWva6vLEW8BGE9aXbZ5/KZlsm+l2wyjAj2UdwU7eS8g=;
 b=cWK+2JwvHQWcL4Uk/ESRMyFBKP2ryzf60gb15Rd8M7+1iSpiYC5UuMC5B8/bT1bQJQ8TpzN1KgwIDL1CFCVBvxX9RvaaEKEjQQVmWRrJ1XIvGwpc4y+nsggCie8LeiriRtPkPYEEwLU93wArRNH1QdJj/B4xYSFYQhHhmB3PClCyS2h4oiLoHpyqZyCutOsgaWLHi+0or+0VIGG/McDAdkT9R687QN6WHuY+/7kT0eW7eFAka1PqH8XUzt8nDV/Rqzn5M5qpD7Efba4Wv0NhlqOxHyiFZnPIt5Na+h8ETTis8E9cS80x/M8lGOMAoi7phlVzYH0U6u0GrbQ0IqtHhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UWva6vLEW8BGE9aXbZ5/KZlsm+l2wyjAj2UdwU7eS8g=;
 b=bO5EwG/5x7/dsoQStL8BonVzw+FO5wtF13aWaxUG9o+82kqgWzgOxmDmm6tRunVXeGxyavZqQxvrjz0jbc+n4bCcQl4Fo6IlCPmNLTj/7reo8OCGImej7IwbFqPUBnUgnkuwdHv9QNyn6s3yjk8MaP3ZMyPMJR4u4Uuwy/cAJDU=
Received: from CH2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:610:50::12)
 by CY8PR12MB7218.namprd12.prod.outlook.com (2603:10b6:930:5a::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.14; Tue, 3 Dec
 2024 09:01:13 +0000
Received: from CH1PEPF0000A34C.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::df) by CH2PR16CA0002.outlook.office365.com
 (2603:10b6:610:50::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34C.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:12 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:08 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 01/13] x86/sev: Carve out and export SNP guest messaging init routines
Date: Tue, 3 Dec 2024 14:30:33 +0530
Message-ID: <20241203090045.942078-2-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241203090045.942078-1-nikunj@amd.com>
References: <20241203090045.942078-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34C:EE_|CY8PR12MB7218:EE_
X-MS-Office365-Filtering-Correlation-Id: 1efccd97-6b69-4b97-55d0-08dd13790989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tRcmu8TBonD+E0h3vGCdeScTji4Ql+LHX6fVjJOWecD4ejVClrBuRjeWawSR?=
 =?us-ascii?Q?dUGu1swARDSzQPE1Ca3I5PHhhdwhiYeDEDFd3amuQ4yUMwSzQYoWGXlsoMT3?=
 =?us-ascii?Q?vKXERAmWD8w84/bI6kw3qd2BEAq6DZsfkR8aDFB67vz03ms104EU4QBPdePY?=
 =?us-ascii?Q?wUYfln0DQMDvMynuX0u9x/K6LbnP7D5Ln2bqDKKKa/GV1dF4sJOWDOuF3xqh?=
 =?us-ascii?Q?q++tGisazUFRp0xY/PzXDrNEJHFOuKNxAGw2sFTuRiyTyHcARoHeLlkEAyyK?=
 =?us-ascii?Q?0dQ2HlhxbetNESYQaLiinuM78AlUMHVz60W9PndgeH/I42e57yry+Dayfwsf?=
 =?us-ascii?Q?JIDFsKr5Nf3/6Blh3+Mk2QWf5uTGT1iSGnzB7XT8co8MWZdsGwwe8Ew8/ZTj?=
 =?us-ascii?Q?Lr/BwHlTMiztZesGnLjr8XT9rrMzYL/WdOfKY9ZhL2eSYxKnTSTM/bOGrWAV?=
 =?us-ascii?Q?2whPns5l1fatitZGsHuqpkdksUVZDQYiC0z9smm/bElE9SAIfUQ8RENXjMA/?=
 =?us-ascii?Q?7fNCrBAuAqJOafhsFAYZn/ZVSMAk9is81AfWqBV4KZ3tMDdZAqZORpVMd6+z?=
 =?us-ascii?Q?yWPN5hYaGJeswU8r3zI7CMPHAq8q3nml4NlWe2c9Fgj7FIJ5BliS5IlZn3Oe?=
 =?us-ascii?Q?P2Tbot8zs0PPyziOpeOl+xejBw/oP27ez9pKt/NVmQkH61ZmClTi/QpEuXI6?=
 =?us-ascii?Q?HopjLdPt5FD1CeNj1tEFqMfLDgMJPlh/M2JMKzj3ZKqtuc69yJtZcw24lkwo?=
 =?us-ascii?Q?KEnf303zZg7fbAC+I7ghBJfBtygQTvB78VXQ8HZjBD0jzXlrqz4dFj8VW9jI?=
 =?us-ascii?Q?wG8Ism/K5ERAcRSBPJumeFrzGY+hgWV7L3U5Y5ollpXGrcgINb2g1FY/vA+s?=
 =?us-ascii?Q?kzLqLza23fXkNNAQC6zFkcdzCZONOPjeVKaucX9b3CYtrJznA3N0v+1yKf1O?=
 =?us-ascii?Q?Ql1IFKegamdtQLv//by5yGvOhpgoCDl0WVMkP0DKkRLISEvHTNt+H3K8H0K+?=
 =?us-ascii?Q?Lu7+xSuyk2FyYuZVa36TmDJz28KrTFYxXAERNzFpMcNoKCSvxKsY6ULsyH32?=
 =?us-ascii?Q?r1NvFUi5itM5bQJBmK6OkVSPZGUsGC0e2FyUgRFUlczdOnupDyGmUFuL+dOu?=
 =?us-ascii?Q?tPMp5bYfFuus1CzK4ICFsr5g4hvCNVQJG1xU7FwPYaucY451ru5k37AgRT+v?=
 =?us-ascii?Q?jUCAPDt6PZnrguVEXA2I2yXJv4bYKdpSa4xnCpiTgZXDZ3yxfCTCD65Beo5V?=
 =?us-ascii?Q?7cOKoMk8TtKiFC1yvbowRxtmTj3PTvKCE3FIBUXAtSLUlHpbn+8OcT99g9XF?=
 =?us-ascii?Q?YBoeqCfWxETqWJJrJehLhscR12tBfMiMz5I7eqgZXKjWRJUhGqY2uCQbc2TZ?=
 =?us-ascii?Q?mddUebf0Idi/5cSDSp00IXpGm0N8pZo8kx+a+wJ22DCsujMQ/F6MbjrFBvBx?=
 =?us-ascii?Q?DIB++b8o8TkQCtzjtXgXIZ4p+fSUhRgL?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:12.7508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1efccd97-6b69-4b97-55d0-08dd13790989
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7218

Currently, the sev-guest driver is the only user of SNP guest messaging.
All routines for initializing SNP guest messaging are implemented within
the sev-guest driver and are not available during early boot. In
prepratation for adding Secure TSC guest support, carve out APIs to
allocate and initialize guest messaging descriptor context and make it part
of coco/sev/core.c. As there is no user of sev_guest_platform_data anymore,
remove the structure.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              |  24 ++-
 arch/x86/coco/sev/core.c                | 183 +++++++++++++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.c | 197 +++---------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 5 files changed, 220 insertions(+), 186 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 91f08af31078..f78c94e29c74 100644
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
@@ -458,6 +456,20 @@ void set_pte_enc_mask(pte_t *kpte, unsigned long pfn, pgprot_t new_prot);
 void snp_kexec_finish(void);
 void snp_kexec_begin(void);
 
+static inline bool snp_is_vmpck_empty(struct snp_msg_desc *mdesc)
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
+void snp_msg_free(struct snp_msg_desc *mdesc);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
@@ -498,6 +510,10 @@ static inline int prepare_pte_enc(struct pte_enc_desc *d) { return 0; }
 static inline void set_pte_enc_mask(pte_t *kpte, unsigned long pfn, pgprot_t new_prot) { }
 static inline void snp_kexec_finish(void) { }
 static inline void snp_kexec_begin(void) { }
+static inline bool snp_is_vmpck_empty(struct snp_msg_desc *mdesc) { return false; }
+static inline int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id) { return -1; }
+static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
+static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index c5b0148b8c0a..3cc741eefd06 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -25,6 +25,7 @@
 #include <linux/psp-sev.h>
 #include <linux/dmi.h>
 #include <uapi/linux/sev-guest.h>
+#include <crypto/gcm.h>
 
 #include <asm/init.h>
 #include <asm/cpu_entry_area.h>
@@ -2580,15 +2581,9 @@ static struct platform_device sev_guest_device = {
 
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
 
@@ -2667,3 +2662,179 @@ static int __init sev_sysfs_init(void)
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
+	if (snp_is_vmpck_empty(mdesc)) {
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
+	mdesc->vmpck = NULL;
+	mdesc->os_area_msg_seqno = NULL;
+	kfree(mdesc->ctx);
+
+	free_shared_pages(mdesc->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(mdesc->request, sizeof(struct snp_guest_msg));
+	iounmap((__force void __iomem *)mdesc->secrets);
+	kfree(mdesc);
+}
+EXPORT_SYMBOL_GPL(snp_msg_free);
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index b699771be029..5268511bc9b8 100644
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
@@ -335,7 +308,7 @@ static int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_r
 	guard(mutex)(&snp_cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (is_vmpck_empty(mdesc)) {
+	if (snp_is_vmpck_empty(mdesc)) {
 		pr_err_ratelimited("VMPCK is disabled\n");
 		return -ENOTTY;
 	}
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
index 9d7bd0ae48c4..0f7e3acf37e3 100644
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


