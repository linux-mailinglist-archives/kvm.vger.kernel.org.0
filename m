Return-Path: <kvm+bounces-47-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E530B7DB38F
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:38:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 03E601C2099B
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:38:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3241DCA7D;
	Mon, 30 Oct 2023 06:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="u+Ogj+DH"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2266AA6
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:38:34 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2054.outbound.protection.outlook.com [40.107.237.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC00127;
	Sun, 29 Oct 2023 23:38:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsaG20PExSnZzE0l1p/6BwcGQ8sAveCdR7n0zxy4zBDM515NLhRVRmnrlopXd60h9DiKwd63XGjiizlC5ou5K2Z593rRcTKBxo3+QSqsz+Bti4YMp1+S93jMj/Vl+PsO/A/c0WP5OjUYrlqUxx7lTx+MYzpEVZcHXIlj/4SGnfwZI46I7khYjLwYT1yBv4tvGtbK6rkzFO9KtBJDJkWf/u80NYsL+qzHCv1VrdhgWW68VU2f/UReE8kIGenN8b/qDFKZHqUU5ynxca2WDKTd9m23fm3Ga72d9aRara+MTBfFAHLy9nQM/fb45IXFpQu1DqkHOTRY1Ec3pzMwYWDJxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=glpnaVMke0UMMMlcAQio2axbbmAODI6vARcRdyhp90I=;
 b=FjRd47w7Qpp0WtOQ6u2UxIl/oFPC04bK3z8dWtvh/4vq9fKdgC8iQckhuOzYso/FoJSaAbVnLpV9apyvkkuS3wPr1VY+zPpESj9YSdjdj6wyuYFYpbDaOsTmT7OG4K2ihIwjeFVb0EBjPgqIzS4y5JA32TglfADEdiZSIWC3mZ2pKdSO7Vj35ShJh8MfXXV1uRZ3C4JFkwd/WH+yiN1VW/5Gwe4BNe2TTrTaSlTM0rNW96eRL4v1qbWp1AOf/dmP/ylliKHWNb+3fhhJoVe+761J17A/9FLXfk6QPerp7DyNWARxR0H5VR7ua2GNkox+cysRAdnva0fhF39GuLHi/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=glpnaVMke0UMMMlcAQio2axbbmAODI6vARcRdyhp90I=;
 b=u+Ogj+DHTzFBPSQ2C2nZsnuPew0s0E6D7eou2cla1Oxj1yqQtQEpFT/TcM7PSR14nCleMASMNgNwyF0fDuTmF+HLpXqoqNJRbSm4eqq8Vb21PwaMkiy57eX9QyquVTma6i7aIGNUgLGzGNi6rBgR1DRcUPUBmeGhISfpymf4UeY=
Received: from BL0PR02CA0080.namprd02.prod.outlook.com (2603:10b6:208:51::21)
 by CH0PR12MB5219.namprd12.prod.outlook.com (2603:10b6:610:d2::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28; Mon, 30 Oct
 2023 06:38:24 +0000
Received: from BL6PEPF0001AB77.namprd02.prod.outlook.com
 (2603:10b6:208:51:cafe::fa) by BL0PR02CA0080.outlook.office365.com
 (2603:10b6:208:51::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.28 via Frontend
 Transport; Mon, 30 Oct 2023 06:38:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB77.mail.protection.outlook.com (10.167.242.170) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.15 via Frontend Transport; Mon, 30 Oct 2023 06:38:24 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:38:19 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 07/14] x86/sev: Move and reorganize sev guest request api
Date: Mon, 30 Oct 2023 12:06:45 +0530
Message-ID: <20231030063652.68675-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030063652.68675-1-nikunj@amd.com>
References: <20231030063652.68675-1-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB77:EE_|CH0PR12MB5219:EE_
X-MS-Office365-Filtering-Correlation-Id: 45237a59-2fbe-48ac-a89a-08dbd912d102
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	kuVncGA4jfftc5ZowrHvwBPBkTdEGtcS0xW2vamg9yTKzjL+7L0BncJxWFRrqmwVKAzxnFlI3MtMF3YdMj/ywCDGKEh7rksuN8zCZQBq5gVvVnxDhktofE8XmKjg3ikc7Wq1l2nZtJ2GNbywmP0zHYylraOXvigq/RdMXHMkFO8izKEvR206WaPGabwsFh9hSLd857GhgVrSE9Ypb+On58y7bcNpCIzJ3jv88UwABu+rSeZNOysJKMyesZ6o0R3pljEV4JMpfFHywtBQVGJTL8x1vIuls9t+AhUhnEOn7eoKVJDm5Vsst+xHtvf171HmomFEOvzXPdPaHZLjul7o35okdRrLa2rrXkH1b/JhA8FtF1hmi/8OF57yiDJW/V468YMLNnrV4Yt3ZF2Vzxpm1KTOLxJ0+bZz6O8lPXKQiZm6eJskRGx01my1qAv4rzH9k78eAgNOXk3HC/OP1/khzLiT+/BIYtPH1Qgk8xG23ljTF4lePta9o2GyHu1OfNtzniyW29uQHZMwL7DbNlECIw2fwYFmQlcFQWS/okiyYc+hGqBH5a/6tQqEdbFe+n2IjJuLPfP1kSWE4FkaJLetknuLYU0RpcvnEwTX7SetL7KkuU3c8DgUn378G7dhLmhmy84ATOTd3/5A7reBToYdMHcRmWCILavxPHNj5X9QxpXN1/+aVxBszTlBIOEz0a2XR39sr5RKNSMkToHvAr3f1du5cC6HQhYZtd4bwaa2FSxmcUx9W5AoS11GsL++FFnMgeDiXk02KZ+XjUtYYh3JWg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(396003)(376002)(136003)(230922051799003)(64100799003)(186009)(82310400011)(1800799009)(451199024)(40470700004)(36840700001)(46966006)(40480700001)(40460700003)(16526019)(26005)(1076003)(2616005)(478600001)(6666004)(7696005)(36860700001)(83380400001)(336012)(426003)(47076005)(7416002)(2906002)(30864003)(110136005)(70206006)(41300700001)(70586007)(5660300002)(4326008)(8936002)(8676002)(54906003)(316002)(356005)(81166007)(82740400003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:38:24.1839
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 45237a59-2fbe-48ac-a89a-08dbd912d102
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB77.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5219

For enabling Secure TSC, SEV-SNP guests need to communicate with the
AMD Security Processor early during boot. Many of the required
functions are implemented in the sev-guest driver and therefore not
available at early boot. Move the required functions and provide an
API to the driver to assign key and send guest request.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/sev-guest.h        |  84 +++-
 arch/x86/include/asm/sev.h              |  10 -
 arch/x86/kernel/sev.c                   | 466 ++++++++++++++++++++++-
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 drivers/virt/coco/sev-guest/sev-guest.c | 486 +-----------------------
 6 files changed, 555 insertions(+), 493 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 66bfabae8814..245a18f6910a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1509,6 +1509,7 @@ config AMD_MEM_ENCRYPT
 	select ARCH_HAS_CC_PLATFORM
 	select X86_MEM_ENCRYPT
 	select UNACCEPTED_MEMORY
+	select CRYPTO_LIB_AESGCM
 	help
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/arch/x86/include/asm/sev-guest.h b/arch/x86/include/asm/sev-guest.h
index 22ef97b55069..e6f94208173d 100644
--- a/arch/x86/include/asm/sev-guest.h
+++ b/arch/x86/include/asm/sev-guest.h
@@ -11,6 +11,11 @@
 #define __VIRT_SEVGUEST_H__
 
 #include <linux/types.h>
+#include <linux/miscdevice.h>
+#include <asm/sev.h>
+
+#define SNP_REQ_MAX_RETRY_DURATION    (60*HZ)
+#define SNP_REQ_RETRY_DELAY           (2*HZ)
 
 #define MAX_AUTHTAG_LEN		32
 #define AUTHTAG_LEN		16
@@ -58,11 +63,45 @@ struct snp_guest_msg_hdr {
 	u8 rsvd3[35];
 } __packed;
 
+/* SNP Guest message request */
+struct snp_req_data {
+	unsigned long req_gpa;
+	unsigned long resp_gpa;
+};
+
 struct snp_guest_msg {
 	struct snp_guest_msg_hdr hdr;
 	u8 payload[4000];
 } __packed;
 
+struct sev_guest_platform_data {
+	/* request and response are in unencrypted memory */
+	struct snp_guest_msg *request, *response;
+
+	struct snp_secrets_page_layout *layout;
+	struct snp_req_data input;
+};
+
+struct snp_guest_dev {
+	struct device *dev;
+	struct miscdevice misc;
+
+	/* Mutex to serialize the shared buffer access and command handling. */
+	struct mutex cmd_mutex;
+
+	void *certs_data;
+	struct aesgcm_ctx *ctx;
+
+	/*
+	 * Avoid information leakage by double-buffering shared messages
+	 * in fields that are in regular encrypted memory
+	 */
+	struct snp_guest_msg secret_request, secret_response;
+
+	struct sev_guest_platform_data *pdata;
+	unsigned int vmpck_id;
+};
+
 struct snp_guest_req {
 	void *req_buf, *resp_buf, *data;
 	size_t req_sz, resp_sz, *data_npages;
@@ -72,6 +111,47 @@ struct snp_guest_req {
 	u8 msg_type;
 };
 
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio);
+int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev);
+int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio);
+bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id);
+bool snp_is_vmpck_empty(unsigned int vmpck_id);
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
+		pr_err("%s: failed to mark page shared, ret=%d\n", __func__, ret);
+		__free_pages(page, get_order(sz));
+		return NULL;
+	}
+
+	return page_address(page);
+}
+
 #endif /* __VIRT_SEVGUEST_H__ */
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 78465a8c7dc6..783150458864 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -93,16 +93,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 
 #define RMPADJUST_VMSA_PAGE_BIT		BIT(16)
 
-/* SNP Guest message request */
-struct snp_req_data {
-	unsigned long req_gpa;
-	unsigned long resp_gpa;
-};
-
-struct sev_guest_platform_data {
-	u64 secrets_gpa;
-};
-
 /*
  * The secrets page contains 96-bytes of reserved field that can be used by
  * the guest OS. The guest OS uses the area to save the message sequence
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index fd3b822fa9e7..fb3b1feb1b84 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -24,6 +24,7 @@
 #include <linux/io.h>
 #include <linux/psp-sev.h>
 #include <uapi/linux/sev-guest.h>
+#include <crypto/gcm.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
@@ -941,6 +942,457 @@ static void snp_cleanup_vmsa(struct sev_es_save_area *vmsa)
 		free_page((unsigned long)vmsa);
 }
 
+static struct sev_guest_platform_data *platform_data;
+
+static inline u8 *snp_get_vmpck(unsigned int vmpck_id)
+{
+	if (!platform_data)
+		return NULL;
+
+	return platform_data->layout->vmpck0 + vmpck_id * VMPCK_KEY_LEN;
+}
+
+static inline u32 *snp_get_os_area_msg_seqno(unsigned int vmpck_id)
+{
+	if (!platform_data)
+		return NULL;
+
+	return &platform_data->layout->os_area.msg_seqno_0 + vmpck_id;
+}
+
+bool snp_is_vmpck_empty(unsigned int vmpck_id)
+{
+	char zero_key[VMPCK_KEY_LEN] = {0};
+	u8 *key = snp_get_vmpck(vmpck_id);
+
+	if (key)
+		return !memcmp(key, zero_key, VMPCK_KEY_LEN);
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(snp_is_vmpck_empty);
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
+	u8 *key = snp_get_vmpck(snp_dev->vmpck_id);
+
+	pr_alert("Disabling vmpck_id %d to prevent IV reuse.\n", snp_dev->vmpck_id);
+	memzero_explicit(key, VMPCK_KEY_LEN);
+}
+
+static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
+{
+	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev->vmpck_id);
+	u64 count;
+
+	if (!os_area_msg_seqno) {
+		pr_err("SNP unable to get message sequence counter\n");
+		return 0;
+	}
+
+	lockdep_assert_held(&snp_dev->cmd_mutex);
+
+	/* Read the current message sequence counter from secrets pages */
+	count = *os_area_msg_seqno;
+
+	return count + 1;
+}
+
+/* Return a non-zero on success */
+static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
+{
+	u64 count = __snp_get_msg_seqno(snp_dev);
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
+		pr_err("SNP request message sequence counter overflow\n");
+		return 0;
+	}
+
+	return count;
+}
+
+static void snp_inc_msg_seqno(struct snp_guest_dev *snp_dev)
+{
+	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev->vmpck_id);
+
+	if (!os_area_msg_seqno) {
+		pr_err("SNP unable to get message sequence counter\n");
+		return;
+	}
+
+	/*
+	 * The counter is also incremented by the PSP, so increment it by 2
+	 * and save in secrets page.
+	 */
+	*os_area_msg_seqno += 2;
+}
+
+static struct aesgcm_ctx *snp_init_crypto(unsigned int vmpck_id)
+{
+	struct aesgcm_ctx *ctx;
+	u8 *key;
+
+	if (snp_is_vmpck_empty(vmpck_id)) {
+		pr_err("SNP: vmpck id %d is null\n", vmpck_id);
+		return NULL;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx)
+		return NULL;
+
+	key = snp_get_vmpck(vmpck_id);
+	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
+		pr_err("SNP: crypto init failed\n");
+		kfree(ctx);
+		return NULL;
+	}
+
+	return ctx;
+}
+
+int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev)
+{
+	struct sev_guest_platform_data *pdata;
+	int ret;
+
+	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
+		pr_err("SNP not supported\n");
+		return 0;
+	}
+
+	if (platform_data) {
+		pr_debug("SNP platform data already initialized.\n");
+		goto create_ctx;
+	}
+
+	if (!secrets_pa) {
+		pr_err("SNP no secrets page\n");
+		return -ENODEV;
+	}
+
+	pdata = kzalloc(sizeof(struct sev_guest_platform_data), GFP_KERNEL);
+	if (!pdata) {
+		pr_err("SNP alloc failed\n");
+		return -ENOMEM;
+	}
+
+	pdata->layout = (__force void *)ioremap_encrypted(secrets_pa, PAGE_SIZE);
+	if (!pdata->layout) {
+		pr_err("Unable to locate AP jump table address: failed to map the SNP secrets page.\n");
+		goto e_free_pdata;
+	}
+
+	ret = -ENOMEM;
+	/* Allocate the shared page used for the request and response message. */
+	pdata->request = alloc_shared_pages(sizeof(struct snp_guest_msg));
+	if (!pdata->request)
+		goto e_unmap;
+
+	pdata->response = alloc_shared_pages(sizeof(struct snp_guest_msg));
+	if (!pdata->response)
+		goto e_free_request;
+
+	/* initial the input address for guest request */
+	pdata->input.req_gpa = __pa(pdata->request);
+	pdata->input.resp_gpa = __pa(pdata->response);
+	platform_data = pdata;
+
+create_ctx:
+	ret = -EIO;
+	snp_dev->ctx = snp_init_crypto(snp_dev->vmpck_id);
+	if (!snp_dev->ctx) {
+		pr_err("SNP init crypto failed\n");
+		platform_data = NULL;
+		goto e_free_response;
+	}
+
+	snp_dev->pdata = platform_data;
+	return 0;
+
+e_free_response:
+	free_shared_pages(pdata->response, sizeof(struct snp_guest_msg));
+e_free_request:
+	free_shared_pages(pdata->request, sizeof(struct snp_guest_msg));
+e_unmap:
+	iounmap(pdata->layout);
+e_free_pdata:
+	kfree(pdata);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(snp_setup_psp_messaging);
+
+static int __enc_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
+			 void *plaintext, size_t len)
+{
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+	u8 iv[GCM_AES_IV_SIZE] = {};
+
+	if (WARN_ON((hdr->msg_sz + ctx->authsize) > sizeof(msg->payload)))
+		return -EBADMSG;
+
+	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
+	aesgcm_encrypt(ctx, msg->payload, plaintext, len, &hdr->algo, AAD_LEN,
+		       iv, hdr->authtag);
+	return 0;
+}
+
+static int dec_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
+		       void *plaintext, size_t len)
+{
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+	u8 iv[GCM_AES_IV_SIZE] = {};
+
+	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
+	if (aesgcm_decrypt(ctx, plaintext, msg->payload, len, &hdr->algo,
+			   AAD_LEN, iv, hdr->authtag))
+		return 0;
+	else
+		return -EBADMSG;
+}
+
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req,
+				  struct sev_guest_platform_data *pdata)
+{
+	struct snp_guest_msg *resp = &snp_dev->secret_response;
+	struct snp_guest_msg *req = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
+	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
+	struct aesgcm_ctx *ctx = snp_dev->ctx;
+
+	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
+		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
+		 resp_hdr->msg_sz);
+
+	/* Copy response from shared memory to encrypted memory. */
+	memcpy(resp, pdata->response, sizeof(*resp));
+
+	/* Verify that the sequence counter is incremented by 1 */
+	if (unlikely(resp_hdr->msg_seqno != (req_hdr->msg_seqno + 1)))
+		return -EBADMSG;
+
+	/* Verify response message type and version number. */
+	if (resp_hdr->msg_type != (req_hdr->msg_type + 1) ||
+	    resp_hdr->msg_version != req_hdr->msg_version)
+		return -EBADMSG;
+
+	/*
+	 * If the message size is greater than our buffer length then return
+	 * an error.
+	 */
+	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp_sz))
+		return -EBADMSG;
+
+	return dec_payload(ctx, resp, guest_req->resp_buf, resp_hdr->msg_sz);
+}
+
+static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
+{
+	struct snp_guest_msg *msg = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+
+	memset(msg, 0, sizeof(*msg));
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
+	return __enc_payload(snp_dev->ctx, msg, req->req_buf, req->req_sz);
+}
+
+static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+				   struct snp_guest_request_ioctl *rio);
+
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+				  struct snp_guest_request_ioctl *rio,
+				  struct sev_guest_platform_data *pdata)
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
+	rc = snp_issue_guest_request(req, &pdata->input, rio);
+	switch (rc) {
+	case -ENOSPC:
+		/*
+		 * If the extended guest request fails due to having too
+		 * small of a certificate data buffer, retry the same
+		 * guest request without the extended data request in
+		 * order to increment the sequence number and thus avoid
+		 * IV reuse.
+		 */
+		override_npages = *req->data_npages;
+		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
+
+		/*
+		 * Override the error to inform callers the given extended
+		 * request buffer size was too small and give the caller the
+		 * required buffer size.
+		 */
+		override_err	= SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN);
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
+	 * The host may return SNP_GUEST_REQ_ERR_BUSY if the request has been
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
+		*req->data_npages = override_npages;
+
+	return rc;
+}
+
+int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio)
+{
+	struct sev_guest_platform_data *pdata;
+	u64 seqno;
+	int rc;
+
+	if (!snp_dev || !snp_dev->pdata || !req || !rio)
+		return -ENODEV;
+
+	pdata = snp_dev->pdata;
+
+	/* Get message sequence and verify that its a non-zero */
+	seqno = snp_get_msg_seqno(snp_dev);
+	if (!seqno)
+		return -EIO;
+
+	/* Clear shared memory's response for the host to populate. */
+	memset(pdata->response, 0, sizeof(struct snp_guest_msg));
+
+	/* Encrypt the userspace provided payload in pdata->secret_request. */
+	rc = enc_payload(snp_dev, seqno, req);
+	if (rc)
+		return rc;
+
+	/*
+	 * Write the fully encrypted request to the shared unencrypted
+	 * request page.
+	 */
+	memcpy(pdata->request, &snp_dev->secret_request, sizeof(snp_dev->secret_request));
+
+	rc = __handle_guest_request(snp_dev, req, rio, pdata);
+	if (rc) {
+		if (rc == -EIO &&
+		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
+			return rc;
+
+		pr_alert("Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
+			 rc, rio->exitinfo2);
+		snp_disable_vmpck(snp_dev);
+		return rc;
+	}
+
+	rc = verify_and_dec_payload(snp_dev, req, pdata);
+	if (rc) {
+		pr_alert("Detected unexpected decode failure from ASP. rc: %d\n", rc);
+		snp_disable_vmpck(snp_dev);
+		return rc;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_send_guest_request);
+
+bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
+{
+	if (WARN_ON(vmpck_id > 3))
+		return false;
+
+	dev->vmpck_id = vmpck_id;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(snp_assign_vmpck);
+
 static int wakeup_cpu_via_vmgexit(int apic_id, unsigned long start_ip)
 {
 	struct sev_es_save_area *cur_vmsa, *vmsa;
@@ -2150,8 +2602,8 @@ static int __init init_sev_config(char *str)
 }
 __setup("sev=", init_sev_config);
 
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio)
+static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+				   struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2218,7 +2670,6 @@ int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *inpu
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(snp_issue_guest_request);
 
 static struct platform_device sev_guest_device = {
 	.name		= "sev-guest",
@@ -2227,18 +2678,9 @@ static struct platform_device sev_guest_device = {
 
 static int __init snp_init_platform_device(void)
 {
-	struct sev_guest_platform_data data;
-
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	if (!secrets_pa)
-		return -ENODEV;
-
-	data.secrets_gpa = secrets_pa;
-	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
-		return -ENODEV;
-
 	if (platform_device_register(&sev_guest_device))
 		return -ENODEV;
 
diff --git a/drivers/virt/coco/sev-guest/Kconfig b/drivers/virt/coco/sev-guest/Kconfig
index bcc760bfb468..c130456ad401 100644
--- a/drivers/virt/coco/sev-guest/Kconfig
+++ b/drivers/virt/coco/sev-guest/Kconfig
@@ -2,7 +2,6 @@ config SEV_GUEST
 	tristate "AMD SEV Guest driver"
 	default m
 	depends on AMD_MEM_ENCRYPT
-	select CRYPTO_LIB_AESGCM
 	help
 	  SEV-SNP firmware provides the guest a mechanism to communicate with
 	  the PSP without risk from a malicious hypervisor who wishes to read,
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 4dd094c73e2f..062ff12b030e 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -27,32 +27,6 @@
 
 #define DEVICE_NAME	"sev-guest"
 
-#define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
-#define SNP_REQ_RETRY_DELAY		(2*HZ)
-
-struct snp_guest_dev {
-	struct device *dev;
-	struct miscdevice misc;
-
-	/* Mutex to serialize the shared buffer access and command handling. */
-	struct mutex cmd_mutex;
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
-	struct snp_guest_msg secret_request, secret_response;
-
-	struct snp_secrets_page_layout *layout;
-	struct snp_req_data input;
-	unsigned int vmpck_id;
-};
-
 static u32 vmpck_id;
 module_param(vmpck_id, uint, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
@@ -60,95 +34,6 @@ MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
-static inline u8 *snp_get_vmpck(struct snp_guest_dev *snp_dev)
-{
-	return snp_dev->layout->vmpck0 + snp_dev->vmpck_id * VMPCK_KEY_LEN;
-}
-
-static inline u32 *snp_get_os_area_msg_seqno(struct snp_guest_dev *snp_dev)
-{
-	return &snp_dev->layout->os_area.msg_seqno_0 + snp_dev->vmpck_id;
-}
-
-static bool snp_is_vmpck_empty(struct snp_guest_dev *snp_dev)
-{
-	char zero_key[VMPCK_KEY_LEN] = {0};
-	u8 *key = snp_get_vmpck(snp_dev);
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
-	u8 *key = snp_get_vmpck(snp_dev);
-
-	dev_alert(snp_dev->dev, "Disabling vmpck_id %d to prevent IV reuse.\n",
-		  snp_dev->vmpck_id);
-	memzero_explicit(key, VMPCK_KEY_LEN);
-}
-
-static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
-{
-	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
-	u64 count;
-
-	lockdep_assert_held(&snp_dev->cmd_mutex);
-
-	/* Read the current message sequence counter from secrets pages */
-	count = *os_area_msg_seqno;
-
-	return count + 1;
-}
-
-/* Return a non-zero on success */
-static u64 snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
-{
-	u64 count = __snp_get_msg_seqno(snp_dev);
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
-	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
-
-	/*
-	 * The counter is also incremented by the PSP, so increment it by 2
-	 * and save in secrets page.
-	 */
-	*os_area_msg_seqno += 2;
-}
-
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 {
 	struct miscdevice *dev = file->private_data;
@@ -156,255 +41,6 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
-{
-	struct aesgcm_ctx *ctx;
-	u8 *key;
-
-	if (snp_is_vmpck_empty(snp_dev)) {
-		pr_err("SNP: vmpck id %d is null\n", snp_dev->vmpck_id);
-		return NULL;
-	}
-
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
-	if (!ctx)
-		return NULL;
-
-	key = snp_get_vmpck(snp_dev);
-	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
-		pr_err("SNP: crypto init failed\n");
-		kfree(ctx);
-		return NULL;
-	}
-
-	return ctx;
-}
-
-static int __enc_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
-			 void *plaintext, size_t len)
-{
-	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-	u8 iv[GCM_AES_IV_SIZE] = {};
-
-	if (WARN_ON((hdr->msg_sz + ctx->authsize) > sizeof(msg->payload)))
-		return -EBADMSG;
-
-	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
-	aesgcm_encrypt(ctx, msg->payload, plaintext, len, &hdr->algo, AAD_LEN,
-		       iv, hdr->authtag);
-	return 0;
-}
-
-static int dec_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
-		       void *plaintext, size_t len)
-{
-	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-	u8 iv[GCM_AES_IV_SIZE] = {};
-
-	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
-	if (aesgcm_decrypt(ctx, plaintext, msg->payload, len, &hdr->algo,
-			   AAD_LEN, iv, hdr->authtag))
-		return 0;
-	else
-		return -EBADMSG;
-}
-
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req)
-{
-	struct snp_guest_msg *resp = &snp_dev->secret_response;
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
-	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
-	struct aesgcm_ctx *ctx = snp_dev->ctx;
-
-	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
-		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
-		 resp_hdr->msg_sz);
-
-	/* Copy response from shared memory to encrypted memory. */
-	memcpy(resp, snp_dev->response, sizeof(*resp));
-
-	/* Verify that the sequence counter is incremented by 1 */
-	if (unlikely(resp_hdr->msg_seqno != (req_hdr->msg_seqno + 1)))
-		return -EBADMSG;
-
-	/* Verify response message type and version number. */
-	if (resp_hdr->msg_type != (req_hdr->msg_type + 1) ||
-	    resp_hdr->msg_version != req_hdr->msg_version)
-		return -EBADMSG;
-
-	/*
-	 * If the message size is greater than our buffer length then return
-	 * an error.
-	 */
-	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp_sz))
-		return -EBADMSG;
-
-	/* Decrypt the payload */
-	return dec_payload(ctx, resp, guest_req->resp_buf, resp_hdr->msg_sz);
-}
-
-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
-{
-	struct snp_guest_msg *msg = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-
-	memset(msg, 0, sizeof(*msg));
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
-	return __enc_payload(snp_dev->ctx, msg, req->req_buf, req->req_sz);
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
-		override_npages = *req->data_npages;
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
-		*req->data_npages = override_npages;
-
-	return rc;
-}
-
-static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
-				  struct snp_guest_request_ioctl *rio)
-{
-	u64 seqno;
-	int rc;
-
-	/* Get message sequence and verify that its a non-zero */
-	seqno = snp_get_msg_seqno(snp_dev);
-	if (!seqno)
-		return -EIO;
-
-	/* Clear shared memory's response for the host to populate. */
-	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
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
-	memcpy(snp_dev->request, &snp_dev->secret_request,
-	       sizeof(snp_dev->secret_request));
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
-}
-
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
 	struct snp_guest_req guest_req = {0};
@@ -604,7 +240,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	mutex_lock(&snp_dev->cmd_mutex);
 
 	/* Check if the VMPCK is not empty */
-	if (snp_is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev->vmpck_id)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		mutex_unlock(&snp_dev->cmd_mutex);
 		return -ENOTTY;
@@ -632,147 +268,63 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
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
 
-bool snp_assign_vmpck(struct snp_guest_dev *dev, int vmpck_id)
-{
-	if (WARN_ON(vmpck_id > 3))
-		return false;
-
-	dev->vmpck_id = vmpck_id;
-
-	return true;
-}
-
 static int __init sev_guest_probe(struct platform_device *pdev)
 {
-	struct snp_secrets_page_layout *layout;
-	struct sev_guest_platform_data *data;
 	struct device *dev = &pdev->dev;
 	struct snp_guest_dev *snp_dev;
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
-	layout = (__force void *)mapping;
-
-	ret = -ENOMEM;
 	snp_dev = devm_kzalloc(&pdev->dev, sizeof(struct snp_guest_dev), GFP_KERNEL);
 	if (!snp_dev)
-		goto e_unmap;
+		return -ENOMEM;
 
-	ret = -EINVAL;
-	snp_dev->layout = layout;
 	if (!snp_assign_vmpck(snp_dev, vmpck_id)) {
 		dev_err(dev, "invalid vmpck id %d\n", vmpck_id);
-		goto e_unmap;
+		ret = -EINVAL;
+		goto e_free_snpdev;
 	}
 
-	/* Verify that VMPCK is not zero. */
-	if (snp_is_vmpck_empty(snp_dev)) {
-		dev_err(dev, "vmpck id %d is null\n", vmpck_id);
-		goto e_unmap;
+	if (snp_setup_psp_messaging(snp_dev)) {
+		dev_err(dev, "Unable to setup PSP messaging vmpck id %d\n", snp_dev->vmpck_id);
+		ret = -ENODEV;
+		goto e_free_snpdev;
 	}
 
 	mutex_init(&snp_dev->cmd_mutex);
 	platform_set_drvdata(pdev, snp_dev);
 	snp_dev->dev = dev;
 
-	/* Allocate the shared page used for the request and response message. */
-	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
-	if (!snp_dev->request)
-		goto e_unmap;
-
-	snp_dev->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
-	if (!snp_dev->response)
-		goto e_free_request;
-
-	snp_dev->certs_data = alloc_shared_pages(dev, SEV_FW_BLOB_MAX_SIZE);
+	snp_dev->certs_data = alloc_shared_pages(SEV_FW_BLOB_MAX_SIZE);
 	if (!snp_dev->certs_data)
-		goto e_free_response;
-
-	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev);
-	if (!snp_dev->ctx)
-		goto e_free_cert_data;
+		goto e_free_ctx;
 
 	misc = &snp_dev->misc;
 	misc->minor = MISC_DYNAMIC_MINOR;
 	misc->name = DEVICE_NAME;
 	misc->fops = &snp_guest_fops;
 
-	/* initial the input address for guest request */
-	snp_dev->input.req_gpa = __pa(snp_dev->request);
-	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-
 	ret =  misc_register(misc);
 	if (ret)
-		goto e_free_ctx;
+		goto e_free_cert_data;
 
-	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
+	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", snp_dev->vmpck_id);
 	return 0;
 
-e_free_ctx:
-	kfree(snp_dev->ctx);
 e_free_cert_data:
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
-e_free_response:
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
-e_free_request:
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
-e_unmap:
-	iounmap(mapping);
+ e_free_ctx:
+	kfree(snp_dev->ctx);
+e_free_snpdev:
+	kfree(snp_dev);
 	return ret;
 }
 
@@ -780,11 +332,9 @@ static int __exit sev_guest_remove(struct platform_device *pdev)
 {
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
-	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
-	kfree(snp_dev->ctx);
 	misc_deregister(&snp_dev->misc);
+	kfree(snp_dev->ctx);
+	kfree(snp_dev);
 
 	return 0;
 }
-- 
2.34.1


