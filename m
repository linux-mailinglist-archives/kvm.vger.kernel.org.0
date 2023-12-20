Return-Path: <kvm+bounces-4938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49CDA81A200
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 16:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD5EE1F213AB
	for <lists+kvm@lfdr.de>; Wed, 20 Dec 2023 15:16:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5782646428;
	Wed, 20 Dec 2023 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PqszZ9ci"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2071.outbound.protection.outlook.com [40.107.212.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D2541C97;
	Wed, 20 Dec 2023 15:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g55prcjTgE7LdsG3WdQVmxnIrEDikGjAlGj52+ZnjqX+No+r0X0QdlfDzynlfkMPFJJg/sCNE9wJ5RpM6pi91RvxXWBIwKgc1rWZjbHiLd9pzttjrGqk29NKOo4AwVuXC4mN3BsSALV083wgfqnSCFmYSj0U4SLgqpFRW9JYnpzlPyRvsj9/ki3sBeNxzMR/gMEl7uf+C2feXS/KUH+GiWFWoN2evGOntyhr8HDjRFCm4VTVI8N2qf2w3lObSciIutENDjUYbV3RgOu1drm1ee9RWTRoD4N8GRf4N8kvQ2ez+6J7Kj12SheaSvihvsLCPJsQMNVN8tQx+bjCjpcy2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dYdeg6Ryjtv1yw9xG6E4rfl+D6jT8Yj38igwBw/zfQs=;
 b=nYY796etvT3oxrED4rmogzkc1gkfWLA+8oj3/tbcmCocdwZavlc52XKHW4foxI2LbEF5R+1yfgh5iyeG6ucw+aeAN6yHUB441NsztFRm5jVcSb18sRSvCq4YqVBr62e32ZZXsg+UTyeoOTze9WPqQRCFT4faBwnhDXGTvM4YBNzsuLyWuZlv50q18kS10CwoB8eN/O9Hliu0KU8xzHcnmjuxUnt8D+568b8pzC73cw/yoqTvkF14o2Zyx9NCBw+JJJm/SCdr3hJ/46Bv4APObqaPEec84lGp+MzuOe82vMkrnBnWE2BlzJyCYjGRXXQ5TjICdcfN17aO9drWohHCVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dYdeg6Ryjtv1yw9xG6E4rfl+D6jT8Yj38igwBw/zfQs=;
 b=PqszZ9ci6Q48p8d12337RRgwi6pSladBw79B9GovDR71xWfzB3NRzENHaUK+HUGcA1I9hOkVksCFFNcIXvo3mCySepZzjZAmNtsvTCr+WcGZzHzLi3BdIy+csCFKSIBfCD+cUKKsMtr1z5Y/xKi0zWJxskBg+9aRff24pl0j+4Q=
Received: from DS7PR03CA0236.namprd03.prod.outlook.com (2603:10b6:5:3ba::31)
 by SA3PR12MB8764.namprd12.prod.outlook.com (2603:10b6:806:31f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Wed, 20 Dec
 2023 15:14:59 +0000
Received: from DS2PEPF0000343C.namprd02.prod.outlook.com
 (2603:10b6:5:3ba:cafe::10) by DS7PR03CA0236.outlook.office365.com
 (2603:10b6:5:3ba::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7113.18 via Frontend
 Transport; Wed, 20 Dec 2023 15:14:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343C.mail.protection.outlook.com (10.167.18.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7113.14 via Frontend Transport; Wed, 20 Dec 2023 15:14:59 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Wed, 20 Dec
 2023 09:14:54 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <bp@alien8.de>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <dionnaglaze@google.com>, <pgonda@google.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <nikunj@amd.com>
Subject: [PATCH v7 03/16] virt: sev-guest: Add SNP guest request structure
Date: Wed, 20 Dec 2023 20:43:45 +0530
Message-ID: <20231220151358.2147066-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231220151358.2147066-1-nikunj@amd.com>
References: <20231220151358.2147066-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343C:EE_|SA3PR12MB8764:EE_
X-MS-Office365-Filtering-Correlation-Id: feab269b-6bf2-4f3e-9abf-08dc016e6eb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nA7KP8HxC/28Jh2KJUIELiyE8FfRVPLliUhzJ9n72zkowyQeQw8KfJAETesofV+5AQbQRJvwj1x0NpHHX4RS0731sTZosm/flM8Mu0sO2R7u7UeV4wPYtDaiLH4SGi/7kQx6tIP2HMSeTKuXwZM2wWam9oGVEaOZvsI22nS8mkmuluwGJOZkezTAcbLZchDNrOhfsm8KiuVVo6CzFogR4DldFX0UpRY642PAC0Woy48rkzc4ILEaCnHTe4IG7UqLWFUCykbF/+q+OI/kHIyrY9Bo6ZXyS+rc11Ns1hjS2dPlNTABupB/pegWoB9Q8FdXh7trpt4Z5P5G1WuauB6uR/IKU/kasbXy4gRQPzH3PQVwgpBazz0cfQ5j2g53lkbR1E8ZegDkAy0CU4QSnKiJFN8ZHoVGw8BpmY9rwJ+RKr3QWKyQRWF7AxsgJGcX8ogcWC2BjOr8GymLvOSwroY0x680+ssr2oYFwe5g2JeTsDA9fP+oyHVSxseeb2U3s5yqfGhX1RhVs4atM82PGt402a7vvhGDEyl0LXIPZnUEaxSfKqtwtM83dPqxqfC1yYglT3sWh0/ifg0lJoBeLlb9sDeilQwFV1myOvDIvo0nEgisnf/2CK2q3YKq/htI5fD63gsakqTK4Bg15OAsNDjq6VHlTeDqGD+/P25fJc1dDxmXZowWfXTaZtGKv2o59W2Tu6R73dwuq3OJumLBk28Rq0mtt1aXezbWU+6R/DbMppb+0h+xA4jAA8GQ5V5hzjR2CxRqH1IGljpwVMp+Kg6o7g==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(376002)(396003)(136003)(230922051799003)(82310400011)(64100799003)(186009)(1800799012)(451199024)(40470700004)(36840700001)(46966006)(82740400003)(40480700001)(36756003)(356005)(81166007)(40460700003)(7696005)(478600001)(70586007)(6666004)(54906003)(70206006)(26005)(2616005)(16526019)(47076005)(426003)(83380400001)(336012)(1076003)(30864003)(110136005)(41300700001)(2906002)(7416002)(5660300002)(36860700001)(316002)(8936002)(8676002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2023 15:14:59.4477
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: feab269b-6bf2-4f3e-9abf-08dc016e6eb6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343C.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB8764

Add a snp_guest_req structure to simplify the function arguments. The
structure will be used to call the SNP Guest message request API
instead of passing a long list of parameters.

Update snp_issue_guest_request() prototype to include the new guest request
structure and move the prototype to sev_guest.h.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Tested-by: Peter Gonda <pgonda@google.com>
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
index c67285824e82..fd89aca22f6a 100644
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
@@ -2170,15 +2171,21 @@ static int __init init_sev_config(char *str)
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
@@ -2195,8 +2202,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 	vc_ghcb_invalidate(ghcb);
 
 	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-		ghcb_set_rax(ghcb, input->data_gpa);
-		ghcb_set_rbx(ghcb, input->data_npages);
+		ghcb_set_rax(ghcb, __pa(req->data));
+		ghcb_set_rbx(ghcb, req->data_npages);
 	}
 
 	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
@@ -2215,7 +2222,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
 		/* Number of expected pages are returned in RBX */
 		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-			input->data_npages = ghcb_get_rbx(ghcb);
+			req->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
 		}
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 469e10d9bf35..5cafbd1c42cb 100644
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
 
 	lockdep_assert_held(&snp_cmd_mutex);
 
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
@@ -868,7 +889,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	/* initial the input address for guest request */
 	snp_dev->input.req_gpa = __pa(snp_dev->request);
 	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
 
 	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
 	if (ret)
-- 
2.34.1


