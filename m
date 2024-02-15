Return-Path: <kvm+bounces-8753-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1586A8561D0
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:38:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6E4E0B27E8C
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:34:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC56912E1E4;
	Thu, 15 Feb 2024 11:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Kr41TLsC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2044.outbound.protection.outlook.com [40.107.94.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47BB712DDBB;
	Thu, 15 Feb 2024 11:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996752; cv=fail; b=tlKIEZGGZyeBBL055WjPb+6GxwI8+1NGl7EEjbEu0LUCifXVvL9EnJpCxhjn3orfJQoJUbDVleUwx84JY19vo2VQ2xlAQrfAHZOT96amtdoNvv18/qlqNa6WHETNJ+I0ble3Cj0mR1YW4raxlAKRMKJ/omBh0AzOlLJwBY7U1nU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996752; c=relaxed/simple;
	bh=ES3ou2/ySrD5nji7ee2qX5J7+ESlRQeTJ2iKD08ENnU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g32jYgniz+4g1K8bSzoXCuG01YStNaffaV142RMiESb1l2Koomgt9U8DQWi10INLOR1j+wd3gbj1Pm3uPc5IAA56tFpWzyLb6SCrf0bt+Hk3F+QT4hlhCJeAptay/lst94ff20/0zSA3RINEJgs55r/+eM4Hv11Nho83TUZyq8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Kr41TLsC; arc=fail smtp.client-ip=40.107.94.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkEN+UiFNbKH7ufIYjSToVOTZ014tMsmrNOx7OUpvqmcywdZvKhN4dBgqPtbzyLld0AQD8CBR0pImErzpTHOqg18WcdcsIXAyP8GJ9LFNQiDS74itWyta0QmT2aekBuSjaNCjw1Xs3Ctn5zMfsPXPmzszwY0Bo4+FptVjBDSFPGr6SDRaxFChJh+/DLpapUg6nd8w7+VoAfekVJbhehXcXShgtBkk99y+RtIJl8rSvYWmgYCFzTYedM/Dg73dV02vkiUjyCUB09J5trroFLnOJhW2eMgwHWU8BKw/hYMM9yRkUOzmxexu3CSlx4EmbR4mo69PzQ42pFlUschCf1TAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcQIJhY9M+7DwHmxyKfWkBYuiOxXIdHht5tgSxuCRdk=;
 b=RUsaTdLlqr7FLghY5No3ZD3i8oNb8t1VykTp20C9L58DCHm5BVDt8TcSA5hU1OsfzvvfnbjwdpiS0LRuaKklLyu5lGU9QUbwj0TUzORr+u/bFBAkzhT5RosbWj7Mgrv70hzkjALsyQE8KdgRTpkIJVYIuk4Qpv67ZJ1GUcZ2Q787+oZVIZkHLkpmLVujWZYsq+/pqm9kZrfeESmLetlRVZ6VTgDaGqMUeSSikG0x7GIE/3VfY3RLls8FI9Pa2w6F1bGK1obfONchG8t9D5wmW40gaeFdyF3kBpucsDk3DU7iO8WxiewKXgvph1WcWFfbFXki4rsuzulSD/o7JNzWgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcQIJhY9M+7DwHmxyKfWkBYuiOxXIdHht5tgSxuCRdk=;
 b=Kr41TLsCpUFp3DVLu1Krqb+gWOXFRy8jjhsLAheS9KDnqqOrB5YvCGai5FD72oASflQEmvkRDbE+eVFViUhqf2LNpVou68JChc+w08rYrFM8Up+NbWFmXW266G6uEyIpYG8nWZI5o/PP/2zCrihLx68IQRJkcWYaLCONooTVyPM=
Received: from MN2PR02CA0017.namprd02.prod.outlook.com (2603:10b6:208:fc::30)
 by SJ2PR12MB8184.namprd12.prod.outlook.com (2603:10b6:a03:4f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.12; Thu, 15 Feb
 2024 11:32:24 +0000
Received: from BL02EPF0001A0FF.namprd03.prod.outlook.com
 (2603:10b6:208:fc:cafe::d0) by MN2PR02CA0017.outlook.office365.com
 (2603:10b6:208:fc::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FF.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:24 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:20 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 07/16] x86/sev: Move and reorganize sev guest request api
Date: Thu, 15 Feb 2024 17:01:19 +0530
Message-ID: <20240215113128.275608-8-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240215113128.275608-1-nikunj@amd.com>
References: <20240215113128.275608-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FF:EE_|SJ2PR12MB8184:EE_
X-MS-Office365-Filtering-Correlation-Id: 20fc1cbe-c33a-40b4-46bd-08dc2e19c7e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XvyNqVoP4q5qEWhdW4gfdjBAZ5jbJhdbsn7pR09l9+zP+/vK4Pcr5czQ03lxw/4+qSBLj10sG5yNHS07wSrMm61gCDtnf8JEGz6uu8Ryed1MiT6cZIp4Md77jRx8x2qLAAAsy4ce8hNLhiEE1am1z0Bm6FwxW0zNWrs7b0Al6T60B5rAyuZB4SHgRisRenuunuV063NFgs1BoF7hSjW0WGAGLgr/KOOWufdPK0eHUN8/ut6GqYHCE06C0EnGqpr94dvDin7o+PMqYXgpxF/C7mDnhAKFr9i+cbYD27QvJmI485bobMXy2zknMiVtzmKYxabi21KbtW8WW72zSJeuWjTXXD3DjDWn50wFF5vTBBuCSeM+6q+vjQPjY1f2u7qDKkntLyhUHky4oPoe4ddOFD/ftU1ZC8au9RmBlcWSzdb3w8PIhZadE8n+0ibMv+nP7NIAP2CIMhpqVhFqH3x9lt9HmuCE4qUguRvABoB6hRvNeTe7UP8BpH/FQb4trVvzVnVyNrzZwWqrI4WzK4m+7yrGmzkuGjLF2kZ4z4IH5KHmPlLXlYiKAN1SWkCztDV5YCV8mLXprm2S0dwykvQmGYTXltPrvocQAkocCpzTw0jhE0gvafQmy8kH+jj10SJ7ivHdsmnO1FchKXLOR6QfFFHZEcvBHx6sLHrmTQ4/obw=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(396003)(136003)(39860400002)(230922051799003)(230273577357003)(186009)(36860700004)(64100799003)(82310400011)(1800799012)(451199024)(46966006)(40470700004)(36756003)(4326008)(8936002)(8676002)(70206006)(70586007)(5660300002)(2906002)(7416002)(30864003)(83380400001)(81166007)(356005)(82740400003)(41300700001)(110136005)(1076003)(54906003)(316002)(16526019)(26005)(2616005)(478600001)(336012)(426003)(7696005)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:24.2010
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20fc1cbe-c33a-40b4-46bd-08dc2e19c7e2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0FF.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8184

For enabling Secure TSC, SEV-SNP guests need to communicate with the
AMD Security Processor early during boot. Many of the required
functions are implemented in the sev-guest driver and therefore not
available at early boot. Move the required functions and provide
API to the sev guest driver for sending guest message and vmpck
routines.

As there is no external caller for snp_issue_guest_request() anymore,
make it static and drop the prototype from the header.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
---
 arch/x86/Kconfig                        |   1 +
 arch/x86/include/asm/sev.h              | 111 +++++-
 arch/x86/kernel/sev.c                   | 459 ++++++++++++++++++++++-
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 drivers/virt/coco/sev-guest/sev-guest.c | 476 ++----------------------
 5 files changed, 561 insertions(+), 487 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 58d3593bc4f2..200fcf68b1e4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1534,6 +1534,7 @@ config AMD_MEM_ENCRYPT
 	select ARCH_HAS_CC_PLATFORM
 	select X86_MEM_ENCRYPT
 	select UNACCEPTED_MEMORY
+	select CRYPTO_LIB_AESGCM
 	help
 	  Say yes to enable support for the encryption of system memory.
 	  This requires an AMD processor that supports Secure Memory
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 8578b33d8fc4..d950a3ac5694 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -10,11 +10,13 @@
 
 #include <linux/types.h>
 #include <linux/sev-guest.h>
+#include <linux/miscdevice.h>
 
 #include <asm/insn.h>
 #include <asm/sev-common.h>
 #include <asm/bootparam.h>
 #include <asm/coco.h>
+#include <asm/set_memory.h>
 
 #define GHCB_PROTOCOL_MIN	1ULL
 #define GHCB_PROTOCOL_MAX	2ULL
@@ -107,16 +109,6 @@ struct rmp_state {
 
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
@@ -153,6 +145,9 @@ struct snp_secrets_page_layout {
 	u8 rsvd3[3840];
 } __packed;
 
+#define SNP_REQ_MAX_RETRY_DURATION    (60*HZ)
+#define SNP_REQ_RETRY_DELAY           (2*HZ)
+
 #define MAX_AUTHTAG_LEN		32
 #define AUTHTAG_LEN		16
 #define AAD_LEN			48
@@ -199,11 +194,49 @@ struct snp_guest_msg_hdr {
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
+	struct snp_guest_msg *request;
+	struct snp_guest_msg *response;
+
+	struct snp_secrets_page_layout *layout;
+	struct snp_req_data input;
+};
+
+struct snp_guest_dev {
+	struct device *dev;
+	struct miscdevice misc;
+
+	void *certs_data;
+	struct aesgcm_ctx *ctx;
+
+	/*
+	 * Avoid information leakage by double-buffering shared messages
+	 * in fields that are in regular encrypted memory
+	 */
+	struct snp_guest_msg secret_request;
+	struct snp_guest_msg secret_response;
+
+	struct sev_guest_platform_data *pdata;
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
@@ -289,14 +322,54 @@ void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
 void kdump_sev_callback(void);
 void snp_guest_cmd_lock(void);
 void snp_guest_cmd_unlock(void);
+bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id);
+bool snp_is_vmpck_empty(unsigned int vmpck_id);
+int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev);
+int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio);
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
+		pr_err("%s: failed to mark page shared, ret=%d\n", __func__, ret);
+		__free_pages(page, get_order(sz));
+		return NULL;
+	}
+
+	return page_address(page);
+}
 #else
 static inline void sev_es_ist_enter(struct pt_regs *regs) { }
 static inline void sev_es_ist_exit(void) { }
@@ -317,18 +390,20 @@ static inline void snp_set_memory_private(unsigned long vaddr, unsigned long npa
 static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
-static inline int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-					  struct snp_guest_request_ioctl *rio)
-{
-	return -ENOTTY;
-}
-
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
 static inline void kdump_sev_callback(void) { }
 static inline void snp_guest_cmd_lock(void) { }
 static inline void snp_guest_cmd_unlock(void) { }
+static inline bool snp_assign_vmpck(struct snp_guest_dev *dev,
+				    unsigned int vmpck_id) { return false; }
+static inline bool snp_is_vmpck_empty(unsigned int vmpck_id) { return true; }
+static inline int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev) { return 0; }
+static inline int snp_send_guest_request(struct snp_guest_dev *dev, struct snp_guest_req *req,
+					 struct snp_guest_request_ioctl *rio) { return 0; }
+static inline void free_shared_pages(void *buf, size_t sz) { }
+static inline void *alloc_shared_pages(size_t sz) { return NULL; }
 #endif
 
 #ifdef CONFIG_KVM_AMD_SEV
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index bc4a705d989c..a9c1efd6d4e3 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -24,6 +24,7 @@
 #include <linux/io.h>
 #include <linux/psp-sev.h>
 #include <uapi/linux/sev-guest.h>
+#include <crypto/gcm.h>
 
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
@@ -2170,8 +2171,8 @@ static int __init init_sev_config(char *str)
 }
 __setup("sev=", init_sev_config);
 
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio)
+static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+				   struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2233,7 +2234,6 @@ int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *inpu
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(snp_issue_guest_request);
 
 static struct platform_device sev_guest_device = {
 	.name		= "sev-guest",
@@ -2242,20 +2242,9 @@ static struct platform_device sev_guest_device = {
 
 static int __init snp_init_platform_device(void)
 {
-	struct sev_guest_platform_data data;
-
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return -ENODEV;
 
-	if (!secrets_pa) {
-		pr_err("SNP secrets page not found\n");
-		return -ENODEV;
-	}
-
-	data.secrets_gpa = secrets_pa;
-	if (platform_device_add_data(&sev_guest_device, &data, sizeof(data)))
-		return -ENODEV;
-
 	if (platform_device_register(&sev_guest_device))
 		return -ENODEV;
 
@@ -2273,3 +2262,445 @@ void kdump_sev_callback(void)
 	if (cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		wbinvd();
 }
+
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
+	pr_alert("Disabling vmpck_id %u to prevent IV reuse.\n", snp_dev->vmpck_id);
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
+		pr_err("VM communication key VMPCK%u is null\n", vmpck_id);
+		return NULL;
+	}
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
+	if (!ctx)
+		return NULL;
+
+	key = snp_get_vmpck(vmpck_id);
+	if (aesgcm_expandkey(ctx, key, VMPCK_KEY_LEN, AUTHTAG_LEN)) {
+		pr_err("Crypto context initialization failed\n");
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
+		pr_err("SNP secrets page not found\n");
+		return -ENODEV;
+	}
+
+	pdata = kzalloc(sizeof(struct sev_guest_platform_data), GFP_KERNEL);
+	if (!pdata) {
+		pr_err("Allocation of SNP guest platform data failed\n");
+		return -ENOMEM;
+	}
+
+	ret = -ENOMEM;
+	pdata->layout = (__force void *)ioremap_encrypted(secrets_pa, PAGE_SIZE);
+	if (!pdata->layout) {
+		pr_err("Failed to map SNP secrets page.\n");
+		goto e_free_pdata;
+	}
+
+	/* Allocate the shared page used for the request and response message. */
+	pdata->request = alloc_shared_pages(sizeof(struct snp_guest_msg));
+	if (!pdata->request)
+		goto e_unmap;
+
+	pdata->response = alloc_shared_pages(sizeof(struct snp_guest_msg));
+	if (!pdata->response)
+		goto e_free_request;
+
+	/*
+	 * Initialize snp command mutex that is used to serialize the shared
+	 * buffer access and use of the vmpck and message sequence number
+	 */
+	mutex_init(&snp_guest_cmd_mutex);
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
+		pr_err("SNP crypto context initialization failed\n");
+		platform_data = NULL;
+		goto e_free_response;
+	}
+
+	snp_dev->pdata = platform_data;
+
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
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+				  struct sev_guest_platform_data *pdata)
+{
+	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
+	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
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
+	memcpy(resp_msg, pdata->response, sizeof(*resp_msg));
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
+	struct snp_guest_msg *msg = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+	struct aesgcm_ctx *ctx = snp_dev->ctx;
+	u8 iv[GCM_AES_IV_SIZE] = {};
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
+	if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload)))
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
+		override_npages = req->data_npages;
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
+		req->data_npages = override_npages;
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
+	lockdep_assert_held(&snp_guest_cmd_mutex);
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
+	if (WARN_ON((vmpck_id + 1) > VMPCK_MAX_NUM))
+		return false;
+
+	dev->vmpck_id = vmpck_id;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(snp_assign_vmpck);
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
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index ba9ffaee647c..dc078fdb9039 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -30,125 +30,10 @@
 
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
-	struct snp_guest_msg secret_request, secret_response;
-
-	struct snp_secrets_page_layout *layout;
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
-	dev_alert(snp_dev->dev, "Disabling vmpck_id %u to prevent IV reuse.\n",
-		  snp_dev->vmpck_id);
-	memzero_explicit(key, VMPCK_KEY_LEN);
-}
-
-static inline u64 __snp_get_msg_seqno(struct snp_guest_dev *snp_dev)
-{
-	u32 *os_area_msg_seqno = snp_get_os_area_msg_seqno(snp_dev);
-	u64 count;
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
@@ -156,241 +41,6 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static struct aesgcm_ctx *snp_init_crypto(struct snp_guest_dev *snp_dev)
-{
-	struct aesgcm_ctx *ctx;
-	u8 *key;
-
-	if (snp_is_vmpck_empty(snp_dev)) {
-		pr_err("VM communication key VMPCK%u is null\n", vmpck_id);
-		return NULL;
-	}
-
-	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL_ACCOUNT);
-	if (!ctx)
-		return NULL;
-
-	key = snp_get_vmpck(snp_dev);
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
-	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
-	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
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
-	memcpy(resp_msg, snp_dev->response, sizeof(*resp_msg));
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
-	struct snp_guest_msg *msg = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-	struct aesgcm_ctx *ctx = snp_dev->ctx;
-	u8 iv[GCM_AES_IV_SIZE] = {};
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
-	if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload)))
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
 struct snp_req_resp {
 	sockptr_t req_data;
 	sockptr_t resp_data;
@@ -597,7 +247,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	snp_guest_cmd_lock();
 
 	/* Check if the VMPCK is not empty */
-	if (snp_is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev->vmpck_id)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		snp_guest_cmd_unlock();
 		return -ENOTTY;
@@ -632,58 +282,11 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
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
 
-static bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
-{
-	if (WARN_ON((vmpck_id + 1) > VMPCK_MAX_NUM))
-		return false;
-
-	dev->vmpck_id = vmpck_id;
-
-	return true;
-}
-
 struct snp_msg_report_resp_hdr {
 	u32 status;
 	u32 report_size;
@@ -715,7 +318,7 @@ static int sev_report_new(struct tsm_report *report, void *data)
 		return -ENOMEM;
 
 	/* Check if the VMPCK is not empty */
-	if (snp_is_vmpck_empty(snp_dev)) {
+	if (snp_is_vmpck_empty(snp_dev->vmpck_id)) {
 		dev_err_ratelimited(snp_dev->dev, "VMPCK is disabled\n");
 		return -ENOTTY;
 	}
@@ -812,75 +415,44 @@ static void unregister_sev_tsm(void *data)
 
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
 		dev_err(dev, "invalid vmpck id %u\n", vmpck_id);
-		goto e_unmap;
+		ret = -EINVAL;
+		goto e_free_snpdev;
 	}
 
-	/* Verify that VMPCK is not zero. */
-	if (snp_is_vmpck_empty(snp_dev)) {
-		dev_err(dev, "vmpck id %u is null\n", vmpck_id);
-		goto e_unmap;
+	if (snp_setup_psp_messaging(snp_dev)) {
+		dev_err(dev, "Unable to setup PSP messaging vmpck id %u\n", snp_dev->vmpck_id);
+		ret = -ENODEV;
+		goto e_free_snpdev;
 	}
 
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
-	if (!snp_dev->certs_data)
-		goto e_free_response;
-
-	ret = -EIO;
-	snp_dev->ctx = snp_init_crypto(snp_dev);
-	if (!snp_dev->ctx)
-		goto e_free_cert_data;
+	snp_dev->certs_data = alloc_shared_pages(SEV_FW_BLOB_MAX_SIZE);
+	if (!snp_dev->certs_data) {
+		ret = -ENOMEM;
+		goto e_free_ctx;
+	}
 
 	misc = &snp_dev->misc;
 	misc->minor = MISC_DYNAMIC_MINOR;
 	misc->name = DEVICE_NAME;
 	misc->fops = &snp_guest_fops;
 
-	/* initial the input address for guest request */
-	snp_dev->input.req_gpa = __pa(snp_dev->request);
-	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-
 	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
 	if (ret)
 		goto e_free_cert_data;
@@ -891,21 +463,18 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 
 	ret =  misc_register(misc);
 	if (ret)
-		goto e_free_ctx;
+		goto e_free_cert_data;
+
+	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %u)\n", snp_dev->vmpck_id);
 
-	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %u)\n", vmpck_id);
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
+e_free_ctx:
+	kfree(snp_dev->ctx);
+e_free_snpdev:
+	kfree(snp_dev);
 	return ret;
 }
 
@@ -914,10 +483,9 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
 	kfree(snp_dev->ctx);
 	misc_deregister(&snp_dev->misc);
+	kfree(snp_dev);
 }
 
 /*
-- 
2.34.1


