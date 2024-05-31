Return-Path: <kvm+bounces-18478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93E978D5971
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:34:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC5E21C23754
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:34:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817E17FBDF;
	Fri, 31 May 2024 04:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="RkEReduL"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2081.outbound.protection.outlook.com [40.107.220.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 266B57F7D5;
	Fri, 31 May 2024 04:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129997; cv=fail; b=IKiGalondzKOVHBnSjxQ6BK0lM1PybjlKO4vwd8kKaFv7i3BR6469LbjsUJWUPLS28azH6YhgxvITtbftKswaNyaXva5jI0bCJoZr5hixnDns9TaVvOlPoEkzvByq83Vz9X7EaQDrRa4OesMnzECb/gB4ZkfXjZ3C6CMy4kcrYY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129997; c=relaxed/simple;
	bh=BC7xgHNpGjcqmRYLLo5EjIjch7fW+caY/YpZh2nbc0Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hKJqqR76SetRQ56ncze7Jk5doFj8sck+mhbXJGKnQCFj3z7eYDAEAXgSTBQS8R+wjE3wOquTpwGc7JanmRZBWMz/Dm3wQkb3GPGO5Z/IpGnTUrfoaWODayNMja+RAp+l44LGnXdrMISKUQbr04hsxM+f20gqlr4cJlqiefacJHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=RkEReduL; arc=fail smtp.client-ip=40.107.220.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZoTHe8CCpoSV5ebtQ0XZU7se4qbkTmtOTmNYxjdQisIXErNe0wStkeHJxENqKCcXS8eabf2NqP4ckTW9wss5voj0TpW9LGtAk5Lvq7hcQst5mSbL1I8TsJFOIb2SV2g0umSCIlOs3X8Vowic8SdHi/V4cJ1i9+hIMXMM1EW+oc5c3yE0nYpggfJjZ1XnQ87+LgD/o1Z42oR3lXb6rPIgLVC8ZcP1qRatOszPhUpHlovc2dPbWUwxdFrCBT6clbI+8M7QGj1YBhcpTdyr75F7oIw1FLB1sev9Hd1i2OixtFelwQxOkj7ojxRj4xtiF3ABCXKlnhS+KT4pwkDOKVlWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i852oqO+ToQ0KaZAw0hJz2psiKVisEdtIHuHewtYISA=;
 b=n6c8wvpmaHr1M7ELkv57tHf02jv/FpjLlcHCCD1YwsNCjWhsmjqh+fKf3IBfWqXJnaTeZTt3sLFzHKas3JZNcbPVXM0D5m8vULJ61nWeUj0AL3+PFjIZMzg2CAciNfiN+CTa7GkWZ6JE/wkfe2iRG0ILSFq+INwiK4R4U8fIrE9NppnoSKVxdfzdpZvSPDNV686RIi7PMnO1EDwFzza1HAbK8WyP4gBN0sj2zDe36coyCM59ntlMdU6I5zIzCjaECR+p4MfaYmRNnkyWLpGFC/oiXiZ8l7zj30kn76UFBrefiIDyg9b58DkO4hVeUZhAoF7vg7szS8jGBGWfhdaCKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i852oqO+ToQ0KaZAw0hJz2psiKVisEdtIHuHewtYISA=;
 b=RkEReduLPr8LAmaY4mW0AWaZmZ4MWNsZ+TzylaYKAsdsL3+tNwb5zr4QBVDtrQGfPO9zW40C7TUHvgfhpHczFgbntNSTan/HIr/VRsiuWXYDaGWsFP5ZjwXualNFF5txrFHVT6Os/qcoZFYjcmFfHbvEwSRKlxkv99g3UyF0wcY=
Received: from DM6PR08CA0053.namprd08.prod.outlook.com (2603:10b6:5:1e0::27)
 by IA0PR12MB8695.namprd12.prod.outlook.com (2603:10b6:208:485::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.29; Fri, 31 May
 2024 04:33:11 +0000
Received: from DS3PEPF000099D9.namprd04.prod.outlook.com
 (2603:10b6:5:1e0:cafe::ba) by DM6PR08CA0053.outlook.office365.com
 (2603:10b6:5:1e0::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22 via Frontend
 Transport; Fri, 31 May 2024 04:33:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF000099D9.mail.protection.outlook.com (10.167.17.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:33:10 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:33:06 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 10/24] x86/sev: Move core SEV guest driver routines to common code
Date: Fri, 31 May 2024 10:00:24 +0530
Message-ID: <20240531043038.3370793-11-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF000099D9:EE_|IA0PR12MB8695:EE_
X-MS-Office365-Filtering-Correlation-Id: ddfefab4-2682-4540-f93c-08dc812ac706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|1800799015|7416005|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eCyHjWHmGcrxlREhc4lsxh05NsKzLVYpMCVB28HMOUa2uOrai693/sgC8Ntb?=
 =?us-ascii?Q?PSN+UWM88maNpTGlxprsyr9PFOSo+G+mInKHtzIR/n0VAWmh68KJV1p12N/D?=
 =?us-ascii?Q?6yomcwiASq72q9eXyXdmh1h4SH4h0Tmn80VgshjyXMZPwVyDydun/WOZ4cMj?=
 =?us-ascii?Q?U/PSLe5vftDI8it4cHk/cERwFpHzpp0tTxVP8BxZVEkpjXnj60W5TTMXSs97?=
 =?us-ascii?Q?ZXsQdZStsWvG4504RywglRbl0YOF8WDLbwdkMFog6D7XAf7CtlPO21AZuRd1?=
 =?us-ascii?Q?XX2IfYo8JZ8u4qe04SocGHKsj//BWVu8O6LEZULslH2BvxD55miE3guTYSkY?=
 =?us-ascii?Q?0KeSDQgWb+pXkAQrJdNmVNMGwEB9nShcelfDg3PnAlDAa7zRunnbdSWzGlRq?=
 =?us-ascii?Q?A+ii2AA8Dio9DwLqIZ9a3DL2FC6TwI47Ajz5vDFKLzkT36AHLyHER1ThBmGG?=
 =?us-ascii?Q?cbBRLOjrj3TKPq9qhMk5ROEGI8bwWGYa5KcblYKiW/u83rwuDq04X/KnktEb?=
 =?us-ascii?Q?m6FUt0Jz9QRMMDyriL8ycB7s/qWSKl7RrqzC46qLOayMAETOKqLsTH1o7F2H?=
 =?us-ascii?Q?hy2k9P8i4QBR+y740rY/PyR4PleKy8rWAkOmS58Ej7sFBuPpAip7xjr/jfYq?=
 =?us-ascii?Q?rZYV5rH8L9KNr2dgfnr8ZDBwSptQoVDTVkp8KCyqX/ndST6MxVr9z6SLb/eG?=
 =?us-ascii?Q?kYrBiFNI/f26HI82t0kpRwwqz9jfEwT/xjGpoyr8Vref7lnjj62h+3b8HJwp?=
 =?us-ascii?Q?8C3m0McZiHS6feu7O3VXqE29PtKYUYa5Lqti3wbCiDwMhoDUUHMKQD5SUHdz?=
 =?us-ascii?Q?2T7CkUwqDNVBrh5hMQE5LIksPQqj8cxecMDjcKWZ5e9UMC5dtDYTV8zGuBKX?=
 =?us-ascii?Q?t41PSqHVZzVdCz0Z+/zAppkRe/ravJuphBNEnxIGHU+IfECupjxiBFwS+/X5?=
 =?us-ascii?Q?btlFyzCJMdjdzyncDe7/mawQ4BG9UrCQj/rwWY9Hu4U87dHRqIv/HEoxb8k7?=
 =?us-ascii?Q?oEsxl0VvPyzLpDF7Q3msxqUIqd9p1bBlGR9ZXFj8AGlviIHogZBqYb6glDN1?=
 =?us-ascii?Q?tRYdk8EWGXsuDnB409DljrZSZvgkGAIB0jqkgHYoH1P1nlGcmsMiBJrJcHYE?=
 =?us-ascii?Q?tpDxcIRXe0alWQSOmj9G6iu7Bwbbs+6ZXeUxfpluLQO67zP5S/ESbS5KNXA1?=
 =?us-ascii?Q?PMLAtKxZ+4RQ3pAgbaqVE2imaKIwz0HjQScbHbihPu/qo4N6DweJdBnE9Oxs?=
 =?us-ascii?Q?3Q3/jfxk/A2obxPmy/L/NrqNx8UbCN9HSQbphDJyP6nnHLy1a2oO0SHLbdof?=
 =?us-ascii?Q?sIz7crZqehOkkZWm0jkakAABpKZrsNzxO/8g4krZBIg1Mkh1ZL6AbqcwXzZS?=
 =?us-ascii?Q?4QcLAQ1ZGS3wNCKc0bjEMN81Evrb?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(1800799015)(7416005)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:33:10.6719
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ddfefab4-2682-4540-f93c-08dc812ac706
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF000099D9.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8695

In order to enable Secure TSC, SEV-SNP guests need to communicate with the
AMD Security Processor during early boot. However, many of the necessary
SNP guest messaging functions are currently implemented in the SEV guest
driver and are not available during early boot. As a result, these core SNP
guest messaging functions need to be relocated to SEV common code. Later,
APIs will be provided to the SEV guest driver to initialize and send SNP
guest messages.

Some functions in sev.c are marked __maybe_unused to ensure compilation
does not break. Similarly, a few functions are stubbed out in SEV guest
driver.

This is pure code movement, SEV guest driver is broken after this patch.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              |  70 ++++
 arch/x86/kernel/sev.c                   | 393 +++++++++++++++++++++
 drivers/virt/coco/sev-guest/sev-guest.c | 442 +-----------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 5 files changed, 473 insertions(+), 434 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index d06b08f7043c..9c5bd8063491 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -10,10 +10,12 @@
 
 #include <linux/types.h>
 #include <linux/sev-guest.h>
+#include <linux/miscdevice.h>
 
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 #include <asm/coco.h>
+#include <asm/set_memory.h>
 
 #define GHCB_PROTOCOL_MIN	1ULL
 #define GHCB_PROTOCOL_MAX	2ULL
@@ -149,6 +151,9 @@ struct snp_secrets_page {
 	u8 rsvd3[3840];
 } __packed;
 
+#define SNP_REQ_MAX_RETRY_DURATION    (60*HZ)
+#define SNP_REQ_RETRY_DELAY           (2*HZ)
+
 #define MAX_AUTHTAG_LEN		32
 #define AUTHTAG_LEN		16
 #define AAD_LEN			48
@@ -203,6 +208,31 @@ struct snp_guest_msg {
 #define SNP_GUEST_MSG_SIZE 4096
 #define SNP_GUEST_MSG_PAYLOAD_SIZE (SNP_GUEST_MSG_SIZE - sizeof(struct snp_guest_msg))
 
+struct snp_guest_dev {
+	struct device *dev;
+	struct miscdevice misc;
+
+	void *certs_data;
+	struct aesgcm_ctx *ctx;
+	/* request and response are in unencrypted memory */
+	struct snp_guest_msg *request, *response;
+
+	/*
+	 * Avoid information leakage by double-buffering shared messages
+	 * in fields that are in regular encrypted memory.
+	 */
+	struct snp_guest_msg *secret_request, *secret_response;
+
+	struct snp_secrets_page *secrets;
+	struct snp_req_data input;
+	union {
+		struct snp_report_req report;
+		struct snp_derived_key_req derived_key;
+		struct snp_ext_report_req ext_report;
+	} req;
+	unsigned int vmpck_id;
+};
+
 struct snp_guest_req {
 	void *req_buf;
 	size_t req_sz;
@@ -294,6 +324,44 @@ void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void sev_show_status(void);
+
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
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -324,6 +392,8 @@ static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void sev_show_status(void) { }
+static inline void free_shared_pages(void *buf, size_t sz) { }
+static inline void *alloc_shared_pages(size_t sz) { return NULL; }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 8145bf123ac9..329ae107da4a 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -25,6 +25,7 @@
 #include <linux/psp-sev.h>
 #include <linux/dmi.h>
 #include <uapi/linux/sev-guest.h>
+#include <crypto/gcm.h>
 
 #include <asm/init.h>
 #include <asm/cpu_entry_area.h>
@@ -2300,3 +2301,395 @@ void sev_show_status(void)
 	}
 	pr_cont("\n");
 }
+
+/* Mutex to serialize the shared buffer access and command handling. */
+static DEFINE_MUTEX(snp_cmd_mutex);
+
+static inline u8 *get_vmpck(struct snp_guest_dev *snp_dev)
+{
+	return snp_dev->secrets->vmpck[snp_dev->vmpck_id];
+}
+
+static bool __maybe_unused assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
+{
+	if ((vmpck_id + 1) > VMPCK_MAX_NUM)
+		return false;
+
+	dev->vmpck_id = vmpck_id;
+
+	return true;
+}
+
+static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
+{
+	char zero_key[VMPCK_KEY_LEN] = {0};
+	u8 *key = get_vmpck(snp_dev);
+
+	return !memcmp(key, zero_key, VMPCK_KEY_LEN);
+}
+
+/*
+ * If an error is received from the host or AMD Secure Processor (ASP) there
+ * are two options. Either retry the exact same encrypted request or discontinue
+ * using the VMPCK.
+ *
+ * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
+ * encrypt the requests. The IV for this scheme is the sequence number. GCM
+ * cannot tolerate IV reuse.
+ *
+ * The ASP FW v1.51 only increments the sequence numbers on a successful
+ * guest<->ASP back and forth and only accepts messages at its exact sequence
+ * number.
+ *
+ * So if the sequence number were to be reused the encryption scheme is
+ * vulnerable. If the sequence number were incremented for a fresh IV the ASP
+ * will reject the request.
+ */
+static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
+{
+	u8 *key = get_vmpck(snp_dev);
+
+	if (is_vmpck_empty(snp_dev))
+		return;
+
+	dev_alert(snp_dev->dev, "Disabling VMPCK%u to prevent IV reuse.\n", snp_dev->vmpck_id);
+	memzero_explicit(key, VMPCK_KEY_LEN);
+}
+
+/* Return a non-zero on success */
+static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
+{
+	u64 count;
+
+	count = snp_dev->secrets->os_area.msg_seqno[snp_dev->vmpck_id] + 1;
+
+	/*
+	 * The message sequence counter for the SNP guest request is a  64-bit
+	 * value but the version 2 of GHCB specification defines a 32-bit storage
+	 * for it. If the counter exceeds the 32-bit value then return zero.
+	 * The caller should check the return value, but if the caller happens to
+	 * not check the value and use it, then the firmware treats zero as an
+	 * invalid number and will fail the  message request.
+	 */
+	if (count >= UINT_MAX) {
+		dev_err(snp_dev->dev, "request message sequence counter overflow\n");
+		return 0;
+	}
+
+	return count;
+}
+
+static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
+{
+	/*
+	 * The counter is also incremented by the PSP, so increment it by 2
+	 * and save in secrets page.
+	 */
+	snp_dev->secrets->os_area.msg_seqno[snp_dev->vmpck_id] += 2;
+}
+
+static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
+{
+	struct aesgcm_ctx *ctx;
+	u8 *key;
+
+	if (is_vmpck_empty(snp_dev)) {
+		pr_err("VM communication key VMPCK%u is invalid\n", snp_dev->vmpck_id);
+		return NULL;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx)
+		return NULL;
+
+	key = get_vmpck(snp_dev);
+	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
+		pr_err("Crypto context initialization failed\n");
+		kfree(ctx);
+		return NULL;
+	}
+
+	return ctx;
+}
+
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
+{
+	struct snp_guest_msg *resp_msg = snp_dev->secret_response;
+	struct snp_guest_msg *req_msg = snp_dev->secret_request;
+	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
+	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
+	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	u8 iv[GCM_AES_IV_SIZE] = {};
+
+	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
+		 resp_msg_hdr->msg_seqno, resp_msg_hdr->msg_type, resp_msg_hdr->msg_version,
+		 resp_msg_hdr->msg_sz);
+
+	/* Copy response from shared memory to encrypted memory. */
+	memcpy(resp_msg, snp_dev->response, SNP_GUEST_MSG_SIZE);
+
+	/* Verify that the sequence counter is incremented by 1 */
+	if (unlikely(resp_msg_hdr->msg_seqno != (req_msg_hdr->msg_seqno + 1)))
+		return -EBADMSG;
+
+	/* Verify response message type and version number. */
+	if (resp_msg_hdr->msg_type != (req_msg_hdr->msg_type + 1) ||
+	    resp_msg_hdr->msg_version != req_msg_hdr->msg_version)
+		return -EBADMSG;
+
+	/*
+	 * If the message size is greater than our buffer length then return
+	 * an error.
+	 */
+	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > req->resp_sz))
+		return -EBADMSG;
+
+	/* Decrypt the payload */
+	memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
+	if (!aesgcm_decrypt(ctx, req->resp_buf, resp_msg->payload, resp_msg_hdr->msg_sz,
+			    &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
+		return -EBADMSG;
+
+	return 0;
+}
+
+static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
+{
+	struct snp_guest_msg *msg = snp_dev->secret_request;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	u8 iv[GCM_AES_IV_SIZE] = {};
+
+	memset(msg, 0, SNP_GUEST_MSG_SIZE);
+
+	hdr->algo = SNP_AEAD_AES_256_GCM;
+	hdr->hdr_version = MSG_HDR_VER;
+	hdr->hdr_sz = sizeof(*hdr);
+	hdr->msg_type = req->msg_type;
+	hdr->msg_version = req->msg_version;
+	hdr->msg_seqno = seqno;
+	hdr->msg_vmpck = req->vmpck_id;
+	hdr->msg_sz = req->req_sz;
+
+	/* Verify the sequence number is non-zero */
+	if (!hdr->msg_seqno)
+		return -ENOSR;
+
+	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
+		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
+
+	if (WARN_ON((req->req_sz + ctx->authsize) > SNP_GUEST_MSG_PAYLOAD_SIZE))
+		return -EBADMSG;
+
+	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
+	aesgcm_encrypt(ctx, msg->payload, req->req_buf, req->req_sz, &hdr->algo,
+		       AAD_LEN, iv, hdr->authtag);
+
+	return 0;
+}
+
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+				  struct snp_guest_request_ioctl *rio)
+{
+	unsigned long req_start = jiffies;
+	unsigned int override_npages = 0;
+	u64 override_err = 0;
+	int rc;
+
+retry_request:
+	/*
+	 * Call firmware to process the request. In this function the encrypted
+	 * message enters shared memory with the host. So after this call the
+	 * sequence number must be incremented or the VMPCK must be deleted to
+	 * prevent reuse of the IV.
+	 */
+	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
+	switch (rc) {
+	case -ENOSPC:
+		/*
+		 * If the extended guest request fails due to having too
+		 * small of a certificate data buffer, retry the same
+		 * guest request without the extended data request in
+		 * order to increment the sequence number and thus avoid
+		 * IV reuse.
+		 */
+		override_npages = req->data_npages;
+		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
+
+		/*
+		 * Override the error to inform callers the given extended
+		 * request buffer size was too small and give the caller the
+		 * required buffer size.
+		 */
+		override_err = SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN);
+
+		/*
+		 * If this call to the firmware succeeds, the sequence number can
+		 * be incremented allowing for continued use of the VMPCK. If
+		 * there is an error reflected in the return value, this value
+		 * is checked further down and the result will be the deletion
+		 * of the VMPCK and the error code being propagated back to the
+		 * user as an ioctl() return code.
+		 */
+		goto retry_request;
+
+	/*
+	 * The host may return SNP_GUEST_VMM_ERR_BUSY if the request has been
+	 * throttled. Retry in the driver to avoid returning and reusing the
+	 * message sequence number on a different message.
+	 */
+	case -EAGAIN:
+		if (jiffies - req_start > SNP_REQ_MAX_RETRY_DURATION) {
+			rc = -ETIMEDOUT;
+			break;
+		}
+		schedule_timeout_killable(SNP_REQ_RETRY_DELAY);
+		goto retry_request;
+	}
+
+	/*
+	 * Increment the message sequence number. There is no harm in doing
+	 * this now because decryption uses the value stored in the response
+	 * structure and any failure will wipe the VMPCK, preventing further
+	 * use anyway.
+	 */
+	snp_inc_msg_seqno(snp_dev);
+
+	if (override_err) {
+		rio->exitinfo2 = override_err;
+
+		/*
+		 * If an extended guest request was issued and the supplied certificate
+		 * buffer was not large enough, a standard guest request was issued to
+		 * prevent IV reuse. If the standard request was successful, return -EIO
+		 * back to the caller as would have originally been returned.
+		 */
+		if (!rc && override_err == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
+			rc = -EIO;
+	}
+
+	if (override_npages)
+		req->data_npages = override_npages;
+
+	return rc;
+}
+
+static int __maybe_unused snp_send_guest_request(struct snp_guest_dev *snp_dev,
+						 struct snp_guest_req *req,
+						 struct snp_guest_request_ioctl *rio)
+{
+	u64 seqno;
+	int rc;
+
+	guard(mutex)(&snp_cmd_mutex);
+
+	/* Get message sequence and verify that its a non-zero */
+	seqno = snp_get_msg_seqno(snp_dev);
+	if (!seqno)
+		return -EIO;
+
+	/* Clear shared memory's response for the host to populate. */
+	memset(snp_dev->response, 0, SNP_GUEST_MSG_SIZE);
+
+	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
+	rc = enc_payload(snp_dev, seqno, req);
+	if (rc)
+		return rc;
+
+	/*
+	 * Write the fully encrypted request to the shared unencrypted
+	 * request page.
+	 */
+	memcpy(snp_dev->request, snp_dev->secret_request, SNP_GUEST_MSG_SIZE);
+
+	rc = __handle_guest_request(snp_dev, req, rio);
+	if (rc) {
+		if (rc == -EIO &&
+		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
+			return rc;
+
+		dev_alert(snp_dev->dev,
+			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
+			  rc, rio->exitinfo2);
+		snp_disable_vmpck(snp_dev);
+		return rc;
+	}
+
+	rc = verify_and_dec_payload(snp_dev, req);
+	if (rc) {
+		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n",
+			  rc);
+		snp_disable_vmpck(snp_dev);
+		return rc;
+	}
+
+	return 0;
+}
+
+static int __maybe_unused snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
+{
+	int ret = -ENOMEM;
+
+	snp_dev->secrets = (__force void *)ioremap_encrypted(secrets_gpa, PAGE_SIZE);
+	if (!snp_dev->secrets) {
+		pr_err("Failed to map SNP secrets page.\n");
+		return ret;
+	}
+
+	/* Allocate secret request and response message for double buffering */
+	snp_dev->secret_request = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
+	if (!snp_dev->secret_request)
+		goto e_unmap;
+
+	snp_dev->secret_response = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
+	if (!snp_dev->secret_response)
+		goto e_free_secret_req;
+
+	/* Allocate the shared page used for the request and response message. */
+	snp_dev->request = alloc_shared_pages(SNP_GUEST_MSG_SIZE);
+	if (!snp_dev->request)
+		goto e_free_secret_resp;
+
+	snp_dev->response = alloc_shared_pages(SNP_GUEST_MSG_SIZE);
+	if (!snp_dev->response)
+		goto e_free_request;
+
+	/* Initialize the input addresses for guest request */
+	snp_dev->input.req_gpa = __pa(snp_dev->request);
+	snp_dev->input.resp_gpa = __pa(snp_dev->response);
+
+	ret = -EIO;
+	snp_dev->ctx = snp_init_crypto(snp_dev);
+	if (!snp_dev->ctx) {
+		pr_err("SNP crypto context initialization failed\n");
+		goto e_free_response;
+	}
+
+	return 0;
+
+e_free_response:
+	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
+e_free_request:
+	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+e_free_secret_resp:
+	kfree(snp_dev->secret_response);
+e_free_secret_req:
+	kfree(snp_dev->secret_request);
+e_unmap:
+	iounmap(snp_dev->secrets);
+
+	return ret;
+}
+
+static void __maybe_unused snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
+{
+	if (!snp_dev)
+		return;
+
+	kfree(snp_dev->ctx);
+	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+	kfree(snp_dev->secret_response);
+	kfree(snp_dev->secret_request);
+	iounmap(snp_dev->secrets);
+}
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 0ec376f7edec..567b3684eae5 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -30,112 +30,14 @@
 
 #define DEVICE_NAME	"sev-guest"
 
-#define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
-#define SNP_REQ_RETRY_DELAY		(2*HZ)
-
-struct snp_guest_dev {
-	struct device *dev;
-	struct miscdevice misc;
-
-	void *certs_data;
-	struct aesgcm_ctx *ctx;
-	/* request and response are in unencrypted memory */
-	struct snp_guest_msg *request, *response;
-
-	/*
-	 * Avoid information leakage by double-buffering shared messages
-	 * in fields that are in regular encrypted memory.
-	 */
-	struct snp_guest_msg *secret_request, *secret_response;
-
-	struct snp_secrets_page *secrets;
-	struct snp_req_data input;
-	union {
-		struct snp_report_req report;
-		struct snp_derived_key_req derived_key;
-		struct snp_ext_report_req ext_report;
-	} req;
-	unsigned int vmpck_id;
-};
-
 static u32 vmpck_id;
 module_param(vmpck_id, uint, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
-/* Mutex to serialize the shared buffer access and command handling. */
-static DEFINE_MUTEX(snp_cmd_mutex);
-
-static inline u8 *get_vmpck(struct snp_guest_dev *snp_dev)
-{
-	return snp_dev->secrets->vmpck[snp_dev->vmpck_id];
-}
-
 static bool is_vmpck_empty(struct snp_guest_dev *snp_dev)
 {
-	char zero_key[VMPCK_KEY_LEN] = {0};
-	u8 *key = get_vmpck(snp_dev);
-
-	return !memcmp(key, zero_key, VMPCK_KEY_LEN);
-}
-
-/*
- * If an error is received from the host or AMD Secure Processor (ASP) there
- * are two options. Either retry the exact same encrypted request or discontinue
- * using the VMPCK.
- *
- * This is because in the current encryption scheme GHCB v2 uses AES-GCM to
- * encrypt the requests. The IV for this scheme is the sequence number. GCM
- * cannot tolerate IV reuse.
- *
- * The ASP FW v1.51 only increments the sequence numbers on a successful
- * guest<->ASP back and forth and only accepts messages at its exact sequence
- * number.
- *
- * So if the sequence number were to be reused the encryption scheme is
- * vulnerable. If the sequence number were incremented for a fresh IV the ASP
- * will reject the request.
- */
-static void snp_disable_vmpck(struct snp_guest_dev *snp_dev)
-{
-	u8 *key = get_vmpck(snp_dev);
-
-	if (is_vmpck_empty(snp_dev))
-		return;
-
-	dev_alert(snp_dev->dev, "Disabling VMPCK%u to prevent IV reuse.\n", snp_dev->vmpck_id);
-	memzero_explicit(key, VMPCK_KEY_LEN);
-}
-
-/* Return a non-zero on success */
-static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
-{
-	u64 count;
-
-	count = snp_dev->secrets->os_area.msg_seqno[snp_dev->vmpck_id] + 1;
-
-	/*
-	 * The message sequence counter for the SNP guest request is a  64-bit
-	 * value but the version 2 of GHCB specification defines a 32-bit storage
-	 * for it. If the counter exceeds the 32-bit value then return zero.
-	 * The caller should check the return value, but if the caller happens to
-	 * not check the value and use it, then the firmware treats zero as an
-	 * invalid number and will fail the  message request.
-	 */
-	if (count >= UINT_MAX) {
-		dev_err(snp_dev->dev, "request message sequence counter overflow\n");
-		return 0;
-	}
-
-	return count;
-}
-
-static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
-{
-	/*
-	 * The counter is also incremented by the PSP, so increment it by 2
-	 * and save in secrets page.
-	 */
-	snp_dev->secrets->os_area.msg_seqno[snp_dev->vmpck_id] += 2;
+	/* Place holder function to be removed after code movement */
+	return true;
 }
 
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
@@ -145,240 +47,11 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
-{
-	struct aesgcm_ctx *ctx;
-	u8 *key;
-
-	if (is_vmpck_empty(snp_dev)) {
-		pr_err("VM communication key VMPCK%u is invalid\n", snp_dev->vmpck_id);
-		return NULL;
-	}
-
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
-	if (!ctx)
-		return NULL;
-
-	key = get_vmpck(snp_dev);
-	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
-		pr_err("Crypto context initialization failed\n");
-		kfree(ctx);
-		return NULL;
-	}
-
-	return ctx;
-}
-
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
-{
-	struct snp_guest_msg *resp_msg = snp_dev->secret_response;
-	struct snp_guest_msg *req_msg = snp_dev->secret_request;
-	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
-	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
-	struct aesgcm_ctx *ctx = snp_dev->ctx;
-	u8 iv[GCM_AES_IV_SIZE] = {};
-
-	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
-		 resp_msg_hdr->msg_seqno, resp_msg_hdr->msg_type, resp_msg_hdr->msg_version,
-		 resp_msg_hdr->msg_sz);
-
-	/* Copy response from shared memory to encrypted memory. */
-	memcpy(resp_msg, snp_dev->response, SNP_GUEST_MSG_SIZE);
-
-	/* Verify that the sequence counter is incremented by 1 */
-	if (unlikely(resp_msg_hdr->msg_seqno != (req_msg_hdr->msg_seqno + 1)))
-		return -EBADMSG;
-
-	/* Verify response message type and version number. */
-	if (resp_msg_hdr->msg_type != (req_msg_hdr->msg_type + 1) ||
-	    resp_msg_hdr->msg_version != req_msg_hdr->msg_version)
-		return -EBADMSG;
-
-	/*
-	 * If the message size is greater than our buffer length then return
-	 * an error.
-	 */
-	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > req->resp_sz))
-		return -EBADMSG;
-
-	/* Decrypt the payload */
-	memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
-	if (!aesgcm_decrypt(ctx, req->resp_buf, resp_msg->payload, resp_msg_hdr->msg_sz,
-			    &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
-		return -EBADMSG;
-
-	return 0;
-}
-
-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
-{
-	struct snp_guest_msg *msg = snp_dev->secret_request;
-	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-	struct aesgcm_ctx *ctx = snp_dev->ctx;
-	u8 iv[GCM_AES_IV_SIZE] = {};
-
-	memset(msg, 0, SNP_GUEST_MSG_SIZE);
-
-	hdr->algo = SNP_AEAD_AES_256_GCM;
-	hdr->hdr_version = MSG_HDR_VER;
-	hdr->hdr_sz = sizeof(*hdr);
-	hdr->msg_type = req->msg_type;
-	hdr->msg_version = req->msg_version;
-	hdr->msg_seqno = seqno;
-	hdr->msg_vmpck = req->vmpck_id;
-	hdr->msg_sz = req->req_sz;
-
-	/* Verify the sequence number is non-zero */
-	if (!hdr->msg_seqno)
-		return -ENOSR;
-
-	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
-		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
-
-	if (WARN_ON((req->req_sz + ctx->authsize) > SNP_GUEST_MSG_PAYLOAD_SIZE))
-		return -EBADMSG;
-
-	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
-	aesgcm_encrypt(ctx, msg->payload, req->req_buf, req->req_sz, &hdr->algo,
-		       AAD_LEN, iv, hdr->authtag);
-
-	return 0;
-}
-
-static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
-				  struct snp_guest_request_ioctl *rio)
-{
-	unsigned long req_start = jiffies;
-	unsigned int override_npages = 0;
-	u64 override_err = 0;
-	int rc;
-
-retry_request:
-	/*
-	 * Call firmware to process the request. In this function the encrypted
-	 * message enters shared memory with the host. So after this call the
-	 * sequence number must be incremented or the VMPCK must be deleted to
-	 * prevent reuse of the IV.
-	 */
-	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
-	switch (rc) {
-	case -ENOSPC:
-		/*
-		 * If the extended guest request fails due to having too
-		 * small of a certificate data buffer, retry the same
-		 * guest request without the extended data request in
-		 * order to increment the sequence number and thus avoid
-		 * IV reuse.
-		 */
-		override_npages = req->data_npages;
-		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
-
-		/*
-		 * Override the error to inform callers the given extended
-		 * request buffer size was too small and give the caller the
-		 * required buffer size.
-		 */
-		override_err = SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN);
-
-		/*
-		 * If this call to the firmware succeeds, the sequence number can
-		 * be incremented allowing for continued use of the VMPCK. If
-		 * there is an error reflected in the return value, this value
-		 * is checked further down and the result will be the deletion
-		 * of the VMPCK and the error code being propagated back to the
-		 * user as an ioctl() return code.
-		 */
-		goto retry_request;
-
-	/*
-	 * The host may return SNP_GUEST_VMM_ERR_BUSY if the request has been
-	 * throttled. Retry in the driver to avoid returning and reusing the
-	 * message sequence number on a different message.
-	 */
-	case -EAGAIN:
-		if (jiffies - req_start > SNP_REQ_MAX_RETRY_DURATION) {
-			rc = -ETIMEDOUT;
-			break;
-		}
-		schedule_timeout_killable(SNP_REQ_RETRY_DELAY);
-		goto retry_request;
-	}
-
-	/*
-	 * Increment the message sequence number. There is no harm in doing
-	 * this now because decryption uses the value stored in the response
-	 * structure and any failure will wipe the VMPCK, preventing further
-	 * use anyway.
-	 */
-	snp_inc_msg_seqno(snp_dev);
-
-	if (override_err) {
-		rio->exitinfo2 = override_err;
-
-		/*
-		 * If an extended guest request was issued and the supplied certificate
-		 * buffer was not large enough, a standard guest request was issued to
-		 * prevent IV reuse. If the standard request was successful, return -EIO
-		 * back to the caller as would have originally been returned.
-		 */
-		if (!rc && override_err == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
-			rc = -EIO;
-	}
-
-	if (override_npages)
-		req->data_npages = override_npages;
-
-	return rc;
-}
-
 static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
 				  struct snp_guest_request_ioctl *rio)
 {
-	u64 seqno;
-	int rc;
-
-	guard(mutex)(&snp_cmd_mutex);
-
-	/* Get message sequence and verify that its a non-zero */
-	seqno = snp_get_msg_seqno(snp_dev);
-	if (!seqno)
-		return -EIO;
-
-	/* Clear shared memory's response for the host to populate. */
-	memset(snp_dev->response, 0, SNP_GUEST_MSG_SIZE);
-
-	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
-	rc = enc_payload(snp_dev, seqno, req);
-	if (rc)
-		return rc;
-
-	/*
-	 * Write the fully encrypted request to the shared unencrypted
-	 * request page.
-	 */
-	memcpy(snp_dev->request, snp_dev->secret_request, SNP_GUEST_MSG_SIZE);
-
-	rc = __handle_guest_request(snp_dev, req, rio);
-	if (rc) {
-		if (rc == -EIO &&
-		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
-			return rc;
-
-		dev_alert(snp_dev->dev,
-			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
-			  rc, rio->exitinfo2);
-		snp_disable_vmpck(snp_dev);
-		return rc;
-	}
-
-	rc = verify_and_dec_payload(snp_dev, req);
-	if (rc) {
-		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
-		snp_disable_vmpck(snp_dev);
-		return rc;
-	}
-
-	return 0;
+	/* Place holder function to be removed after code movement */
+	return -EIO;
 }
 
 struct snp_req_resp {
@@ -617,43 +290,6 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
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
-static void *alloc_shared_pages(size_t sz)
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
-		pr_err("failed to mark page shared, ret=%d\n", ret);
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
@@ -661,12 +297,8 @@ static const struct file_operations snp_guest_fops = {
 
 static bool assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
 {
-	if ((vmpck_id + 1) > VMPCK_MAX_NUM)
-		return false;
-
-	dev->vmpck_id = vmpck_id;
-
-	return true;
+	/* Place holder function to be removed after code movement */
+	return false;
 }
 
 struct snp_msg_report_resp_hdr {
@@ -793,70 +425,14 @@ static void unregister_sev_tsm(void *data)
 
 static int snp_guest_messaging_init(struct snp_guest_dev *snp_dev, u64 secrets_gpa)
 {
-	int ret = -ENOMEM;
-
-	snp_dev->secrets = (__force void *)ioremap_encrypted(secrets_gpa, PAGE_SIZE);
-	if (!snp_dev->secrets) {
-		pr_err("Failed to map SNP secrets page.\n");
-		return ret;
-	}
-
-	/* Allocate secret request and response message for double buffering */
-	snp_dev->secret_request = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
-	if (!snp_dev->secret_request)
-		goto e_unmap;
-
-	snp_dev->secret_response = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
-	if (!snp_dev->secret_response)
-		goto e_free_secret_req;
-
-	/* Allocate the shared page used for the request and response message. */
-	snp_dev->request = alloc_shared_pages(SNP_GUEST_MSG_SIZE);
-	if (!snp_dev->request)
-		goto e_free_secret_resp;
-
-	snp_dev->response = alloc_shared_pages(SNP_GUEST_MSG_SIZE);
-	if (!snp_dev->response)
-		goto e_free_request;
-
-	/* Initialize the input addresses for guest request */
-	snp_dev->input.req_gpa = __pa(snp_dev->request);
-	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-
-	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev);
-	if (!snp_dev->ctx) {
-		pr_err("SNP crypto context initialization failed\n");
-		goto e_free_response;
-	}
-
+	/* Place holder function to be removed after code movement */
 	return 0;
-
-e_free_response:
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
-e_free_request:
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
-e_free_secret_resp:
-	kfree(snp_dev->secret_response);
-e_free_secret_req:
-	kfree(snp_dev->secret_request);
-e_unmap:
-	iounmap(snp_dev->secrets);
-
-	return ret;
 }
 
 static void snp_guest_messaging_exit(struct snp_guest_dev *snp_dev)
 {
-	if (!snp_dev)
-		return;
-
-	kfree(snp_dev->ctx);
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
-	kfree(snp_dev->secret_response);
-	kfree(snp_dev->secret_request);
-	iounmap(snp_dev->secrets);
+	/* Place holder function to be removed after code movement */
+	return;
 }
 
 static int __init sev_guest_probe(struct platform_device *pdev)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1d7122a1883e..97814cccf0e8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1544,6 +1544,7 @@ config AMD_MEM_ENCRYPT
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


