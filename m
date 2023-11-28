Return-Path: <kvm+bounces-2601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C87F37FBABA
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:01:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E15D2824F9
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 13:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C09C256454;
	Tue, 28 Nov 2023 13:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="pxLQGkcB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C103D10E7;
	Tue, 28 Nov 2023 05:01:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cr1HB9WaYDX6DiQ6bYSXmPHJ6Bqam79WVaGNp27a16FuqMMCjlNjGiaFrG5hQpUVu1DMo6YqkINzIWPTctR+KKjPKdU2iimXSvxZOqmWv+aOwaPBZBZfr32QABY57BXBjxgQEksfuetcvuZNWXObhxebSLwnclBtjWQsFz8BOGvg+EwBT7d3PMp1g3XXSS8JnxxjSaubQ9OM0YNtWILUpj6Oyzl6fuplfUdzAFY3xc7zAO8WOb449+6+AKf4yA+sQ002yothf9OymaKSmoxhp7NjAAze2Tv4im/kADd1ogCcJAOs6HGHhYblswerxObTJnkBi0/knGJ3X7vAFs168A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tdX2rU3igqNNZEzIFxl9NSU7HuX8FeTjYmb90HQm29Y=;
 b=CXL18Z1MZ4h9oXc/UYxAUE1J2xdJzZmYk4+yT1RWAuis6+IzBXYU60vjUCUOEwxfD3P30DrXRoyqi8TSwfouYvBIQuiOrg84HZXynfykcZmXP6i95MY4hBu3NM3u8Pu+u7JJBEpSK1GY8ug6e7Y9dM48luDWpSAOsR67rUTLNMLcfl1p5hTl28ix0SQWRDTw6OY1YzPv/iQWTKXZ2gjT0sBgmkguY50lPP1Hb8tUzldf00qos5ar4E8pXpsjnoneUvHDu2rCJKLdBvAfsSCK9Lmnxpiw2sGYNtN4lpU5iC46i79yGni3xOYANsqUjYPjKajCfpGvLvnUsRTMZ2BqLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tdX2rU3igqNNZEzIFxl9NSU7HuX8FeTjYmb90HQm29Y=;
 b=pxLQGkcBUHEQdzIhlijfGVubzWeinbmYUlaCTSRZyNz4bafBVKc4Wu0YXrzimxYXQDCJY02TM1/Oa2Bt+XQfJgZ0YLzXpl9jsy0wgsClpbOU4yZVwg12ga2bZ2SJW4gy4VMp2FJKRvv4P9MrHp7xcoDjzqC4MPM3YdvFXnG7n2E=
Received: from CY8PR22CA0023.namprd22.prod.outlook.com (2603:10b6:930:45::28)
 by DM6PR12MB4042.namprd12.prod.outlook.com (2603:10b6:5:215::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29; Tue, 28 Nov
 2023 13:01:11 +0000
Received: from CY4PEPF0000EE31.namprd05.prod.outlook.com
 (2603:10b6:930:45:cafe::92) by CY8PR22CA0023.outlook.office365.com
 (2603:10b6:930:45::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7025.29 via Frontend
 Transport; Tue, 28 Nov 2023 13:01:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE31.mail.protection.outlook.com (10.167.242.37) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7046.17 via Frontend Transport; Tue, 28 Nov 2023 13:01:11 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Tue, 28 Nov
 2023 07:00:38 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v6 04/16] virt: sev-guest: Add SNP guest request structure
Date: Tue, 28 Nov 2023 18:29:47 +0530
Message-ID: <20231128125959.1810039-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128125959.1810039-1-nikunj@amd.com>
References: <20231128125959.1810039-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE31:EE_|DM6PR12MB4042:EE_
X-MS-Office365-Filtering-Correlation-Id: 8643a870-948c-49dd-ac97-08dbf0121864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XpUmS6re6BFnIzubrPJKCXLb8z1YyrglpWy2IED3pQPJzPn5mqvVpA5dKxaCIfequGYQfZIhityCzlbp6fsJxnrTxogPDQXlctYR4r5bHxcTtvJa13Aslg6S3bCAhuZxJLp23WSMv6uUpccmCABGKY3F/pomrajHtPHu7VdrcfvPEifisfkLlD+943LkKS++qA+WxZ+3YR14tu2QSeAIHeC28m3iAm2Ak5zKlZm2u6e8Bwo0lUpwVSOlpL8WzZHDdiD9ttuXEBOutYu8MAMLFFvcT03T7fLdXYOvndS7hIrEncbXRSRw9698Txqf67/6fSgkMyT0eScAc6+UfRnRdDLuhAv/fu7JtqhRGxqvkucGeDeXCNjnAaP0vdorHEe3Pd9PEcfWwfsl6wGuv0yLgm+ytk6NXsrn9KkH7X8bOlmoeHs2gPloc+FodTTBu9ggQvGYi34RHtVwmZ2SzexNJJWlHWLQ0fXt7VssJjloQQXsm325vnN49D5eTe166PlhZA+W36sxDcNGWJTVwZWJ+EG3OqhZCzPXo5nAoD6d2BfXBqpxpsZFe3eeaeK0727pF2FL82aQur7tbOKONZMTvip36LeJMFtTFqVfiMTAFEJ4jBgEAn3BAGqQE57Oi9w3lA41+ErNa9MIvhkaDzdWbTQKZliVWbUVRca52Ne/Zbhl7NSRWQaFKiGqgJ3F4nKUqVg1rD8V0OkXS3UxThN6o9BDhRfNIf0ht8YYCv0qyv1nil6Njl/crNmtmT/8ypfOtSwfaI0DBQSnMEX51yTaqw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(396003)(39860400002)(136003)(346002)(230922051799003)(451199024)(64100799003)(82310400011)(1800799012)(186009)(46966006)(40470700004)(36840700001)(36860700001)(36756003)(82740400003)(81166007)(356005)(40460700003)(41300700001)(8936002)(4326008)(8676002)(70586007)(54906003)(316002)(110136005)(70206006)(6666004)(7696005)(478600001)(5660300002)(7416002)(2906002)(30864003)(47076005)(40480700001)(426003)(336012)(1076003)(26005)(16526019)(2616005)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2023 13:01:11.1291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8643a870-948c-49dd-ac97-08dbf0121864
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE31.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4042

Add a snp_guest_req structure to simplify the function arguments. The
structure will be used to call the SNP Guest message request API
instead of passing a long list of parameters.

Update snp_issue_guest_request() prototype to include the new guest request
structure and move the prototype to sev_guest.h.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 .../x86/include/asm}/sev-guest.h              |  18 +++
 arch/x86/include/asm/sev.h                    |   8 --
 arch/x86/kernel/sev.c                         |  15 ++-
 drivers/virt/coco/sev-guest/sev-guest.c       | 108 +++++++++++-------
 4 files changed, 93 insertions(+), 56 deletions(-)
 rename {drivers/virt/coco/sev-guest => arch/x86/include/asm}/sev-guest.h (78%)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/arch/x86/include/asm/sev-guest.h
similarity index 78%
rename from drivers/virt/coco/sev-guest/sev-guest.h
rename to arch/x86/include/asm/sev-guest.h
index ceb798a404d6..27cc15ad6131 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ b/arch/x86/include/asm/sev-guest.h
@@ -63,4 +63,22 @@ struct snp_guest_msg {
 	u8 payload[4000];
 } __packed;
 
+struct snp_guest_req {
+	void *req_buf;
+	size_t req_sz;
+
+	void *resp_buf;
+	size_t resp_sz;
+
+	void *data;
+	size_t data_npages;
+
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
index 70472eebe719..01a400681529 100644
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
+		ghcb_set_rbx(ghcb, req->data_npages);
 	}
 
 	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
@@ -2212,7 +2219,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
 		/* Number of expected pages are returned in RBX */
 		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-			input->data_npages = ghcb_get_rbx(ghcb);
+			req->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
 		}
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 917c19e9e5ed..1579140d43ec 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -27,8 +27,7 @@
 
 #include <asm/svm.h>
 #include <asm/sev.h>
-
-#include "sev-guest.h"
+#include <asm/sev-guest.h>
 
 #define DEVICE_NAME	"sev-guest"
 
@@ -169,7 +168,7 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 	return ctx;
 }
 
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *guest_req)
 {
 	struct snp_guest_msg *resp = &snp_dev->secret_response;
 	struct snp_guest_msg *req = &snp_dev->secret_request;
@@ -198,36 +197,35 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	 * If the message size is greater than our buffer length then return
 	 * an error.
 	 */
-	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
+	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > guest_req->resp_sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
 	memcpy(iv, &resp_hdr->msg_seqno, sizeof(resp_hdr->msg_seqno));
-	if (!aesgcm_decrypt(ctx, payload, resp->payload, resp_hdr->msg_sz,
+	if (!aesgcm_decrypt(ctx, guest_req->resp_buf, resp->payload, resp_hdr->msg_sz,
 			    &resp_hdr->algo, AAD_LEN, iv, resp_hdr->authtag))
 		return -EBADMSG;
 
 	return 0;
 }
 
-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
-			void *payload, size_t sz)
+static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *hdr = &req->hdr;
+	struct snp_guest_msg *msg = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
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
@@ -236,17 +234,17 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
+	if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload)))
 		return -EBADMSG;
 
 	memcpy(iv, &hdr->msg_seqno, sizeof(hdr->msg_seqno));
-	aesgcm_encrypt(ctx, req->payload, payload, sz, &hdr->algo, AAD_LEN,
-		       iv, hdr->authtag);
+	aesgcm_encrypt(ctx, msg->payload, req->req_buf, req->req_sz, &hdr->algo,
+		       AAD_LEN, iv, hdr->authtag);
 
 	return 0;
 }
 
-static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+static int __handle_guest_request(struct snp_guest_dev *snp_dev, struct snp_guest_req *req,
 				  struct snp_guest_request_ioctl *rio)
 {
 	unsigned long req_start = jiffies;
@@ -261,7 +259,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * sequence number must be incremented or the VMPCK must be deleted to
 	 * prevent reuse of the IV.
 	 */
-	rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
+	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
 	switch (rc) {
 	case -ENOSPC:
 		/*
@@ -271,8 +269,8 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		 * order to increment the sequence number and thus avoid
 		 * IV reuse.
 		 */
-		override_npages = snp_dev->input.data_npages;
-		exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
+		override_npages = req->data_npages;
+		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
 		/*
 		 * Override the error to inform callers the given extended
@@ -327,15 +325,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	}
 
 	if (override_npages)
-		snp_dev->input.data_npages = override_npages;
+		req->data_npages = override_npages;
 
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
@@ -349,7 +345,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
 
 	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
-	rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
+	rc = enc_payload(snp_dev, seqno, req);
 	if (rc)
 		return rc;
 
@@ -360,7 +356,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memcpy(snp_dev->request, &snp_dev->secret_request,
 	       sizeof(snp_dev->secret_request));
 
-	rc = __handle_guest_request(snp_dev, exit_code, rio);
+	rc = __handle_guest_request(snp_dev, req, rio);
 	if (rc) {
 		if (rc == -EIO &&
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
@@ -369,12 +365,11 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
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
@@ -392,6 +387,7 @@ struct snp_req_resp {
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
 	struct snp_report_req *req = &snp_dev->req.report;
+	struct snp_guest_req guest_req = {0};
 	struct snp_report_resp *resp;
 	int rc, resp_len;
 
@@ -413,9 +409,16 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	if (!resp)
 		return -ENOMEM;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_REPORT_REQ, req, sizeof(*req), resp->data,
-				  resp_len);
+	guest_req.msg_version = arg->msg_version;
+	guest_req.msg_type = SNP_MSG_REPORT_REQ;
+	guest_req.vmpck_id = vmpck_id;
+	guest_req.req_buf = req;
+	guest_req.req_sz = sizeof(*req);
+	guest_req.resp_buf = resp->data;
+	guest_req.resp_sz = resp_len;
+	guest_req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &guest_req, arg);
 	if (rc)
 		goto e_free;
 
@@ -431,6 +434,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 {
 	struct snp_derived_key_req *req = &snp_dev->req.derived_key;
 	struct snp_derived_key_resp resp = {0};
+	struct snp_guest_req guest_req = {0};
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
@@ -452,8 +456,16 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
 		return -EFAULT;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_KEY_REQ, req, sizeof(*req), buf, resp_len);
+	guest_req.msg_version = arg->msg_version;
+	guest_req.msg_type = SNP_MSG_KEY_REQ;
+	guest_req.vmpck_id = vmpck_id;
+	guest_req.req_buf = req;
+	guest_req.req_sz = sizeof(*req);
+	guest_req.resp_buf = buf;
+	guest_req.resp_sz = resp_len;
+	guest_req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &guest_req, arg);
 	if (rc)
 		return rc;
 
@@ -472,9 +484,10 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 
 {
 	struct snp_ext_report_req *req = &snp_dev->req.ext_report;
+	struct snp_guest_req guest_req = {0};
 	struct snp_report_resp *resp;
-	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
+	int ret, resp_len;
 
 	lockdep_assert_held(&snp_dev->cmd_mutex);
 
@@ -507,7 +520,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * zeros to indicate that certificate data was not provided.
 	 */
 	memset(snp_dev->certs_data, 0, req->certs_len);
-	npages = req->certs_len >> PAGE_SHIFT;
+	guest_req.data_npages = req->certs_len >> PAGE_SHIFT;
 cmd:
 	/*
 	 * The intermediate response buffer is used while decrypting the
@@ -519,14 +532,21 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	if (!resp)
 		return -ENOMEM;
 
-	snp_dev->input.data_npages = npages;
-	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg,
-				   SNP_MSG_REPORT_REQ, &req->data,
-				   sizeof(req->data), resp->data, resp_len);
+	guest_req.msg_version = arg->msg_version;
+	guest_req.msg_type = SNP_MSG_REPORT_REQ;
+	guest_req.vmpck_id = vmpck_id;
+	guest_req.req_buf = &req->data;
+	guest_req.req_sz = sizeof(req->data);
+	guest_req.resp_buf = resp->data;
+	guest_req.resp_sz = resp_len;
+	guest_req.exit_code = SVM_VMGEXIT_EXT_GUEST_REQUEST;
+	guest_req.data = snp_dev->certs_data;
+
+	ret = snp_send_guest_request(snp_dev, &guest_req, arg);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
-		req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+		req->certs_len = guest_req.data_npages << PAGE_SHIFT;
 
 		if (copy_to_sockptr(io->req_data, req, sizeof(*req)))
 			ret = -EFAULT;
@@ -535,7 +555,8 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	if (ret)
 		goto e_free;
 
-	if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, req->certs_len)) {
+	if (guest_req.data_npages && req->certs_len &&
+	    copy_to_sockptr(certs_address, snp_dev->certs_data, req->certs_len)) {
 		ret = -EFAULT;
 		goto e_free;
 	}
@@ -869,7 +890,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	/* initial the input address for guest request */
 	snp_dev->input.req_gpa = __pa(snp_dev->request);
 	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
 
 	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
 	if (ret)
-- 
2.34.1


