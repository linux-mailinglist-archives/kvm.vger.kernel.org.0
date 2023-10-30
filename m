Return-Path: <kvm+bounces-43-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A058B7DB388
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 07:38:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2F041C20A6D
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 06:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35CB93D7F;
	Mon, 30 Oct 2023 06:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qh3ggaPU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B756D38
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 06:38:15 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89757C5;
	Sun, 29 Oct 2023 23:38:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMNWx9yAybSWrBz5aIM9CsV7ZDDpJaIg/yNVEICYNxlwdYfwd9XVqiQ6DBVDD3H/2wH/3t5/emhQ+Rgjmo0vOib+F005KH5OkLUt0UjJi4gDNURON54L2RRSaEbj7DpWdNhoKG/He+al+AUcH0/hTkKQqlke+3QtGQixsw8zf8OpePLlgWN1lSi9Mpo9ojxDvT7Oi8mAATnmqeS4XTXESdvpn//mkbm4AjVyePBTDi7dt8ocf0prgCxLnJweDmG+qALMhY7Ta4XkEd2M8IbBtBWpM48CXD3pwHwSGRjrtjEogfCWrtTX895PUBJZx9tTpb9T4RB1exJYgyX19G0RLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Qu8us0rJv+jhvwS7S6PeuVQ8D/EdSOW0XDH+MsZwZA=;
 b=YNU1+jspMKZUbX2B3DcUjOJS0XK9fBir7kcvvTfCQ9LhpogywjFdJ4KeO+6JzwHIqXZNM7atu3x6SN2qpUxz9iWZ8R3AmaX61n0dLC8iogMDehhyPfjZLL6mz/6vgpborFdhRFxfdVEExbFsr7DpJU6mAC/zLkjRinhN4KKVcVbFffzeAm9D1plNMQ7Mvccwvf8ygZjl3JtgQ7k9yyFTLBm/VCrtYJB2jTcchlIzP7krGZHYnebHQjmU7QkFFs3LiQS6MqCHkOua/6wkSjJI2Tv+FlbjPF2fJsVw50Xiecdmiye/o12h+MCrg6Iurwv8KdLO5i/6xWlsB6Lqi78FvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Qu8us0rJv+jhvwS7S6PeuVQ8D/EdSOW0XDH+MsZwZA=;
 b=qh3ggaPU1kGlylQThYb3BQshpdHB6Ehcpd1HqVj1GRSD16Zgi4O4hCelhrZDwY1kbdPIl787iRBeEOPxv9cyZDU74+ba3vMbfF3AobylsuaibktxNzTjsMeJTRLPA7nq91ZARpzR3tPmRU6WIYGW+xfiZo1q2YHDIYkdCPD0Wlg=
Received: from BL1PR13CA0299.namprd13.prod.outlook.com (2603:10b6:208:2bc::34)
 by PH7PR12MB7967.namprd12.prod.outlook.com (2603:10b6:510:273::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.27; Mon, 30 Oct
 2023 06:38:10 +0000
Received: from BL6PEPF0001AB78.namprd02.prod.outlook.com
 (2603:10b6:208:2bc:cafe::ae) by BL1PR13CA0299.outlook.office365.com
 (2603:10b6:208:2bc::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.14 via Frontend
 Transport; Mon, 30 Oct 2023 06:38:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB78.mail.protection.outlook.com (10.167.242.171) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6933.15 via Frontend Transport; Mon, 30 Oct 2023 06:38:10 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Mon, 30 Oct
 2023 01:38:05 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v5 04/14] virt: sev-guest: Add SNP guest request structure
Date: Mon, 30 Oct 2023 12:06:42 +0530
Message-ID: <20231030063652.68675-5-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB78:EE_|PH7PR12MB7967:EE_
X-MS-Office365-Filtering-Correlation-Id: c56b6afb-cb7e-4850-edd3-08dbd912c891
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OlSHF3ceySKs/QnFZXwl6spliWlPJ3QhY/HyQrc7RLS8vSgcaRJZEOxjlmZVn7usuHV/v8ARAb4vTtQXQr+22lAFRJWAILYxM8lEmjeTwUT05Sk71k6c+X5cKu1AayFxePDU3qiK2IhAzt5kvqXvOD5FiQUwnAp6pTR4Pe5eoHkDlaNb7OgzsGh9zZNjm2jEib+Jn1PztXHZ+G0U3SfGGq0fzGPHHyVZ5QiGIL5O3LivHN9WzFENEBgoxX7dTftldXm3KHF+YIPrsw783mMqTHNTg730AC0SzErMPKZJ9taeDCnNWo2GUzx9sBFAdyYFMQ0k/DmPShoib7c/xo9p4Zgwus0L60FiKVLYvjHj7oSwBU5BwwISTOdqwo0gnNnxRW9g3/Eay5fsUvZPwIukzmceI+9E4pssOI0FnlI6FFUHEMIUuSmO42R3rMiEjhJYa21+XLd0otDUyha4Y0LjbjlFPvJYoBerytHhNRtokXa28lpxb2gUvLC5an4nkmEossrUSPAgi4b1ueLayCWENHi8w6GcuWFq3WT+tQyOq/LUBO8AoZrrhcyL+46Fdm+NR2yg58wzMLWKcWdTbRirRf+iJlv2ZRkeAOjXsF0+x61FrLOiMOG1wGagpm+RmHyvJXA1X1Ulf1upjU9AA3lsUK31dOa+8kFjt+YvjaY6CnSqXkvDAEXmBA9XtD/XVmm8rO4XObvkmJ4VQNmVmcXKJlgGQZRJtWt46HreNg5YdIkvLSPPCeAJgUDKgYgIVSfVRTaOso/TwL4iw3WACHtjWA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(396003)(39860400002)(136003)(346002)(376002)(230922051799003)(186009)(451199024)(82310400011)(64100799003)(1800799009)(40470700004)(46966006)(36840700001)(82740400003)(83380400001)(40480700001)(40460700003)(47076005)(356005)(36860700001)(81166007)(478600001)(2906002)(30864003)(7416002)(6666004)(7696005)(8676002)(8936002)(4326008)(70586007)(70206006)(110136005)(316002)(54906003)(5660300002)(41300700001)(426003)(336012)(1076003)(16526019)(26005)(2616005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Oct 2023 06:38:10.0233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c56b6afb-cb7e-4850-edd3-08dbd912c891
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB78.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7967

Add a snp_guest_req structure to simplify the function arguments. The
structure will be used to call the SNP Guest message request API
instead of passing a long list of parameters.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 .../x86/include/asm}/sev-guest.h              |  11 ++
 arch/x86/include/asm/sev.h                    |   8 --
 arch/x86/kernel/sev.c                         |  15 ++-
 drivers/virt/coco/sev-guest/sev-guest.c       | 103 +++++++++++-------
 4 files changed, 84 insertions(+), 53 deletions(-)
 rename {drivers/virt/coco/sev-guest => arch/x86/include/asm}/sev-guest.h (80%)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/arch/x86/include/asm/sev-guest.h
similarity index 80%
rename from drivers/virt/coco/sev-guest/sev-guest.h
rename to arch/x86/include/asm/sev-guest.h
index ceb798a404d6..22ef97b55069 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ b/arch/x86/include/asm/sev-guest.h
@@ -63,4 +63,15 @@ struct snp_guest_msg {
 	u8 payload[4000];
 } __packed;
 
+struct snp_guest_req {
+	void *req_buf, *resp_buf, *data;
+	size_t req_sz, resp_sz, *data_npages;
+	u64 exit_code;
+	unsigned int vmpck_id;
+	u8 msg_version;
+	u8 msg_type;
+};
+
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio);
 #endif /* __VIRT_SEVGUEST_H__ */
diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 5b4a1ce3d368..78465a8c7dc6 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -97,8 +97,6 @@ extern bool handle_vc_boot_ghcb(struct pt_regs *regs);
 struct snp_req_data {
 	unsigned long req_gpa;
 	unsigned long resp_gpa;
-	unsigned long data_gpa;
-	unsigned int data_npages;
 };
 
 struct sev_guest_platform_data {
@@ -209,7 +207,6 @@ void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
@@ -233,11 +230,6 @@ static inline void snp_set_memory_private(unsigned long vaddr, unsigned long npa
 static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
-static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
-{
-	return -ENOTTY;
-}
-
 static inline void snp_accept_memory(phys_addr_t start, phys_addr_t end) { }
 static inline u64 snp_get_unsupported_features(u64 status) { return 0; }
 static inline u64 sev_get_status(void) { return 0; }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 6395bfd87b68..f8caf0a73052 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -28,6 +28,7 @@
 #include <asm/cpu_entry_area.h>
 #include <asm/stacktrace.h>
 #include <asm/sev.h>
+#include <asm/sev-guest.h>
 #include <asm/insn-eval.h>
 #include <asm/fpu/xcr.h>
 #include <asm/processor.h>
@@ -2167,15 +2168,21 @@ static int __init init_sev_config(char *str)
 }
 __setup("sev=", init_sev_config);
 
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
 	unsigned long flags;
 	struct ghcb *ghcb;
+	u64 exit_code;
 	int ret;
 
 	rio->exitinfo2 = SEV_RET_NO_FW_CALL;
+	if (!req)
+		return -EINVAL;
+
+	exit_code = req->exit_code;
 
 	/*
 	 * __sev_get_ghcb() needs to run with IRQs disabled because it is using
@@ -2192,8 +2199,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 	vc_ghcb_invalidate(ghcb);
 
 	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-		ghcb_set_rax(ghcb, input->data_gpa);
-		ghcb_set_rbx(ghcb, input->data_npages);
+		ghcb_set_rax(ghcb, __pa(req->data));
+		ghcb_set_rbx(ghcb, *req->data_npages);
 	}
 
 	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
@@ -2212,7 +2219,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
 		/* Number of expected pages are returned in RBX */
 		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-			input->data_npages = ghcb_get_rbx(ghcb);
+			*req->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
 		}
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 49bafd2e9f42..5801dd52ffdf 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -23,8 +23,7 @@
 
 #include <asm/svm.h>
 #include <asm/sev.h>
-
-#include "sev-guest.h"
+#include <asm/sev-guest.h>
 
 #define DEVICE_NAME	"sev-guest"
 
@@ -192,7 +191,7 @@ static int dec_payload(struct aesgcm_ctx *ctx, struct snp_guest_msg *msg,
 		return -EBADMSG;
 }
 
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req)
 {
 	struct snp_guest_msg *resp = &snp_dev->secret_response;
 	struct snp_guest_msg *req = &snp_dev->secret_request;
@@ -220,29 +219,28 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	 * If the message size is greater than our buffer length then return
 	 * an error.
 	 */
-	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
+	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp_sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
-	return dec_payload(ctx, resp, payload, resp_hdr->msg_sz);
+	return dec_payload(ctx, resp, guest_req->resp_buf, resp_hdr->msg_sz);
 }
 
-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
-			void *payload, size_t sz)
+static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *hdr = &req->hdr;
+	struct snp_guest_msg *msg = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
 
-	memset(req, 0, sizeof(*req));
+	memset(msg, 0, sizeof(*msg));
 
 	hdr->algo = SNP_AEAD_AES_256_GCM;
 	hdr->hdr_version = MSG_HDR_VER;
 	hdr->hdr_sz = sizeof(*hdr);
-	hdr->msg_type = type;
-	hdr->msg_version = version;
+	hdr->msg_type = req->msg_type;
+	hdr->msg_version = req->msg_version;
 	hdr->msg_seqno = seqno;
-	hdr->msg_vmpck = vmpck_id;
-	hdr->msg_sz = sz;
+	hdr->msg_vmpck = req->vmpck_id;
+	hdr->msg_sz = req->req_sz;
 
 	/* Verify the sequence number is non-zero */
 	if (!hdr->msg_seqno)
@@ -251,10 +249,10 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	return __enc_payload(snp_dev->ctx, req, payload, sz);
+	return __enc_payload(snp_dev->ctx, msg, req->req_buf, req->req_sz);
 }
 
-static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
 				  struct snp_guest_request_ioctl *rio)
 {
 	unsigned long req_start = jiffies;
@@ -269,7 +267,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * sequence number must be incremented or the VMPCK must be deleted to
 	 * prevent reuse of the IV.
 	 */
-	rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
+	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
 	switch (rc) {
 	case -ENOSPC:
 		/*
@@ -279,8 +277,8 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		 * order to increment the sequence number and thus avoid
 		 * IV reuse.
 		 */
-		override_npages = snp_dev->input.data_npages;
-		exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
+		override_npages = *req->data_npages;
+		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
 		/*
 		 * Override the error to inform callers the given extended
@@ -335,15 +333,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	}
 
 	if (override_npages)
-		snp_dev->input.data_npages = override_npages;
+		*req->data_npages = override_npages;
 
 	return rc;
 }
 
-static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
-				struct snp_guest_request_ioctl *rio, u8 type,
-				void *req_buf, size_t req_sz, void *resp_buf,
-				u32 resp_sz)
+static int snp_send_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
+				  struct snp_guest_request_ioctl *rio)
 {
 	u64 seqno;
 	int rc;
@@ -357,7 +353,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
 
 	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
-	rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
+	rc = enc_payload(snp_dev, seqno, req);
 	if (rc)
 		return rc;
 
@@ -368,7 +364,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memcpy(snp_dev->request, &snp_dev->secret_request,
 	       sizeof(snp_dev->secret_request));
 
-	rc = __handle_guest_request(snp_dev, exit_code, rio);
+	rc = __handle_guest_request(snp_dev, req, rio);
 	if (rc) {
 		if (rc == -EIO &&
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
@@ -377,12 +373,11 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		dev_alert(snp_dev->dev,
 			  "Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
 			  rc, rio->exitinfo2);
-
 		snp_disable_vmpck(snp_dev);
 		return rc;
 	}
 
-	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
+	rc = verify_and_dec_payload(snp_dev, req);
 	if (rc) {
 		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
 		snp_disable_vmpck(snp_dev);
@@ -394,6 +389,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
+	struct snp_guest_req guest_req = {0};
 	struct snp_report_resp *resp;
 	struct snp_report_req req;
 	int rc, resp_len;
@@ -416,9 +412,16 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	if (!resp)
 		return -ENOMEM;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_REPORT_REQ, &req, sizeof(req), resp->data,
-				  resp_len);
+	guest_req.msg_version = arg->msg_version;
+	guest_req.msg_type = SNP_MSG_REPORT_REQ;
+	guest_req.vmpck_id = vmpck_id;
+	guest_req.req_buf = &req;
+	guest_req.req_sz = sizeof(req);
+	guest_req.resp_buf = resp->data;
+	guest_req.resp_sz = resp_len;
+	guest_req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &guest_req, arg);
 	if (rc)
 		goto e_free;
 
@@ -433,6 +436,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
 	struct snp_derived_key_resp resp = {0};
+	struct snp_guest_req guest_req = {0};
 	struct snp_derived_key_req req;
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
@@ -455,8 +459,16 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	if (copy_from_user(&req, (void __user *)arg->req_data, sizeof(req)))
 		return -EFAULT;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_KEY_REQ, &req, sizeof(req), buf, resp_len);
+	guest_req.msg_version = arg->msg_version;
+	guest_req.msg_type = SNP_MSG_KEY_REQ;
+	guest_req.vmpck_id = vmpck_id;
+	guest_req.req_buf = &req;
+	guest_req.req_sz = sizeof(req);
+	guest_req.resp_buf = buf;
+	guest_req.resp_sz = resp_len;
+	guest_req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &guest_req, arg);
 	if (rc)
 		return rc;
 
@@ -472,9 +484,11 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 
 static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
+	struct snp_guest_req guest_req = {0};
 	struct snp_ext_report_req req;
 	struct snp_report_resp *resp;
-	int ret, npages = 0, resp_len;
+	int ret, resp_len;
+	size_t npages = 0;
 
 	lockdep_assert_held(&snp_dev->cmd_mutex);
 
@@ -514,14 +528,22 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	if (!resp)
 		return -ENOMEM;
 
-	snp_dev->input.data_npages = npages;
-	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg,
-				   SNP_MSG_REPORT_REQ, &req.data,
-				   sizeof(req.data), resp->data, resp_len);
+	guest_req.msg_version = arg->msg_version;
+	guest_req.msg_type = SNP_MSG_REPORT_REQ;
+	guest_req.vmpck_id = vmpck_id;
+	guest_req.req_buf = &req.data;
+	guest_req.req_sz = sizeof(req.data);
+	guest_req.resp_buf = resp->data;
+	guest_req.resp_sz = resp_len;
+	guest_req.exit_code = SVM_VMGEXIT_EXT_GUEST_REQUEST;
+	guest_req.data = snp_dev->certs_data;
+	guest_req.data_npages = &npages;
+
+	ret = snp_send_guest_request(snp_dev, &guest_req, arg);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
-		req.certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+		req.certs_len = npages << PAGE_SHIFT;
 
 		if (copy_to_user((void __user *)arg->req_data, &req, sizeof(req)))
 			ret = -EFAULT;
@@ -530,7 +552,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	if (ret)
 		goto e_free;
 
-	if (npages &&
+	if (npages && req.certs_len &&
 	    copy_to_user((void __user *)req.certs_address, snp_dev->certs_data,
 			 req.certs_len)) {
 		ret = -EFAULT;
@@ -734,7 +756,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	/* initial the input address for guest request */
 	snp_dev->input.req_gpa = __pa(snp_dev->request);
 	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
 
 	ret =  misc_register(misc);
 	if (ret)
-- 
2.34.1


