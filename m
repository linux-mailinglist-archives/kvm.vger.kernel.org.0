Return-Path: <kvm+bounces-8749-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E36085619E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 12:33:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54F0A282E6B
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 11:33:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F11B12C543;
	Thu, 15 Feb 2024 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="g1849Ic6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2080.outbound.protection.outlook.com [40.107.95.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E1B12BF1E;
	Thu, 15 Feb 2024 11:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707996734; cv=fail; b=n1kgbmbjtbIW9MpQNyaZboHCi9gKjwdzdccBk1Xk5ElKwfNnMBiUveURCIIHjrbMiLASq0HexMmLTMc6fRRvQ9AwkA+h5+7O9uf3LQgRlhJEPAQSAMxIiiy99sqYN041BSbb5sGJlkvjs2nBuDMRyj4YccB41Bmqka+EppZDxaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707996734; c=relaxed/simple;
	bh=mF8P8ijnlrqp8hgzU29G2MbqeeRleR+bSW7002vG/BI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UVNUWCdQQTBwPYBa3w/Hv8qiip8JWWV5o1jHcB+nWrQyyPi/Wm0YBu4g7NibKmOiQjDoEA/+asAkUoJF0RSxm7DlS+thCRH2Vqq+Z09D44tCWgx7K0cC4uEZ0eYQ+GyVdnQZnf9QHujW8W6AhpIXQzqGP8uzAPiXqXIPZvZnfTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=g1849Ic6; arc=fail smtp.client-ip=40.107.95.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9mLp7U57Z2WQ5iU+MVreWRieBRwJat8n/AXDeG9fX0ha7o2lh3HfaBupbb9CZUKDyfYne8dAUFFPia7zyQ3RbB5f+MO+Ksc3WnxUzNautRBsiATlfYWz4yeQ2wBoJXdu7TCJSj4d8AoOfgyGGx6h8pmNflz36Nr2FT39G2LC0C5fWlB0ArBb5TpnE5quthfX59jVQjy71hHwrAz0XUM7JCc1vICaOLNN3q5gjo/UEiyirQCoRP5lF2JNT24KgRQErLXdYOawvRi9fOyrWLJXwokx8hGZNJg+P6AcdSQXnaLSOEwzC9RtKD/UEaNzY0HFoKxODyhk/vhYIcmCnSDvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3F30xTur/Lgne5Jwns3a/4I4U8DpG1mfzREe7lW7HrE=;
 b=a14fCBzB7Vmznx/pR6t0K0gwPK18Ha/YZyzUZ7D1zcvSZ0x1NGnBysX0CN0vQe3LB2RooYIt7NvGs7whKgcvuh2boD6iSihh9r6trbOdDsta9X+FGu5k8MpT0tKtDJNSUIkDKJE8e8kmCYVL5PZGFVZSTJDIfRpaAz0bIWlhLi5cSYE2ZtBbESnnZAWubc2nLIGo7kqI4Lc6iVp0rcQsn+WvrIo0P7z/4/F4ryeB52rubWNxphkf5J2ZuV3WKYidDqvB/pJYHnoOm8Oy2gjS+SsK2LHWzewOeHfO/dc88PlrAiyYKEEM9+5zAulBV7qxPPSNL+IQ5EGwWuhvnO1xbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3F30xTur/Lgne5Jwns3a/4I4U8DpG1mfzREe7lW7HrE=;
 b=g1849Ic62RGNQY0HXAlTmjM6UtgShsgFhnmlj0hM+is05p0JGgQAWXfrL8z+UnxCkveOlQyYEUkRtb5fHjM9Z0+gxf/3AmK53fhRdzKF0jSKn8ev4MEMxyXmOp1XWBQuSCKhipBH/02PqCsl//x9P419fwG8C3FvvFi1NCFDn6E=
Received: from BL0PR02CA0047.namprd02.prod.outlook.com (2603:10b6:207:3d::24)
 by CY8PR12MB7099.namprd12.prod.outlook.com (2603:10b6:930:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 11:32:09 +0000
Received: from BL02EPF0001A0F9.namprd03.prod.outlook.com
 (2603:10b6:207:3d:cafe::e4) by BL0PR02CA0047.outlook.office365.com
 (2603:10b6:207:3d::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39 via Frontend
 Transport; Thu, 15 Feb 2024 11:32:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0F9.mail.protection.outlook.com (10.167.242.100) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 11:32:09 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 05:32:05 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v8 03/16] virt: sev-guest: Add SNP guest request structure
Date: Thu, 15 Feb 2024 17:01:15 +0530
Message-ID: <20240215113128.275608-4-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0F9:EE_|CY8PR12MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: f810a732-8bd4-4ad1-a8e8-08dc2e19bf15
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	a2wEcmffhkeKtL4xEva0NOdMXDrScjvgpX+nqN8VRpaWs0YWSg6olL4pS0A5rycnYzcKrCZlIxzYe11cTQgBCo5BkUNy9iLQ99mAhWeNw18Id+UQXTT4vNss7HR3atXbXMXCe6+hXV+uxJCowf8CXCAnja5h8IpLq2yBpJN1OBU4Nr0Dw+O8y8H4hI2cdrVN01ZdkMw/xgTA5O/Mb6+zziuJGvIckKjxPmr42TQdrDft70wFTaAGrARUSdIiuaqiC1kyx1TdTSYPvWbToi5rTH5yYupJP4fSa984joTGM2708yY6ecFTokt+q8HYSrjg+hlVtPIqubkhaukYm4pzB0uJHA5pjAJ8EsWyJFiC4SsyHZXaaEVlKrfrIBUK290/ZYrzSjKTT+iiMhaAqQIeJ/wbhogjl9rGvUFgdsdJD8dFyAgDPs0uiW4niAkruoLy7zsgaebr63s+pMr9tVMJ8kzrQIpbdFTe+xFIqDt2+BZL5Sn4QVx9qgr2ogry+9bDfqFfvDAurY6S5/KPbGDzZTWVRBr56WYIFJZsMvk5OvALBRw0zcAP2x7lEFvDWHskrVWSAmGR8Cv9/F4EQxzoB6QzZQir5I+HrtsVszhMqEekT5Xa2VSGuQxVouMhHP6NOvDHzU03xIwHqMGDE5tVEw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(39860400002)(376002)(136003)(396003)(230922051799003)(1800799012)(451199024)(82310400011)(186009)(64100799003)(36860700004)(40470700004)(46966006)(8676002)(8936002)(5660300002)(30864003)(2906002)(4326008)(7416002)(36756003)(1076003)(336012)(110136005)(426003)(83380400001)(2616005)(26005)(82740400003)(356005)(81166007)(16526019)(316002)(54906003)(70586007)(70206006)(6666004)(7696005)(966005)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 11:32:09.4226
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f810a732-8bd4-4ad1-a8e8-08dc2e19bf15
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF0001A0F9.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7099

Add a snp_guest_req structure to simplify the function arguments. The
structure will be used to call the SNP Guest message request API
instead of passing a long list of parameters.

Update snp_issue_guest_request() prototype to include the new guest request
structure and move the prototype to sev.h.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 arch/x86/include/asm/sev.h              |  75 ++++++++-
 arch/x86/kernel/sev.c                   |  15 +-
 drivers/virt/coco/sev-guest/sev-guest.c | 195 +++++++++++++-----------
 drivers/virt/coco/sev-guest/sev-guest.h |  66 --------
 4 files changed, 187 insertions(+), 164 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index bed95e1f4d52..0c0b11af9f89 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -111,8 +111,6 @@ struct rmp_state {
 struct snp_req_data {
 	unsigned long req_gpa;
 	unsigned long resp_gpa;
-	unsigned long data_gpa;
-	unsigned int data_npages;
 };
 
 struct sev_guest_platform_data {
@@ -154,6 +152,73 @@ struct snp_secrets_page_layout {
 	u8 rsvd3[3840];
 } __packed;
 
+#define MAX_AUTHTAG_LEN		32
+#define AUTHTAG_LEN		16
+#define AAD_LEN			48
+#define MSG_HDR_VER		1
+
+/* See SNP spec SNP_GUEST_REQUEST section for the structure */
+enum msg_type {
+	SNP_MSG_TYPE_INVALID = 0,
+	SNP_MSG_CPUID_REQ,
+	SNP_MSG_CPUID_RSP,
+	SNP_MSG_KEY_REQ,
+	SNP_MSG_KEY_RSP,
+	SNP_MSG_REPORT_REQ,
+	SNP_MSG_REPORT_RSP,
+	SNP_MSG_EXPORT_REQ,
+	SNP_MSG_EXPORT_RSP,
+	SNP_MSG_IMPORT_REQ,
+	SNP_MSG_IMPORT_RSP,
+	SNP_MSG_ABSORB_REQ,
+	SNP_MSG_ABSORB_RSP,
+	SNP_MSG_VMRK_REQ,
+	SNP_MSG_VMRK_RSP,
+
+	SNP_MSG_TYPE_MAX
+};
+
+enum aead_algo {
+	SNP_AEAD_INVALID,
+	SNP_AEAD_AES_256_GCM,
+};
+
+struct snp_guest_msg_hdr {
+	u8 authtag[MAX_AUTHTAG_LEN];
+	u64 msg_seqno;
+	u8 rsvd1[8];
+	u8 algo;
+	u8 hdr_version;
+	u16 hdr_sz;
+	u8 msg_type;
+	u8 msg_version;
+	u16 msg_sz;
+	u32 rsvd2;
+	u8 msg_vmpck;
+	u8 rsvd3[35];
+} __packed;
+
+struct snp_guest_msg {
+	struct snp_guest_msg_hdr hdr;
+	u8 payload[4000];
+} __packed;
+
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
 #ifdef CONFIG_AMD_MEM_ENCRYPT
 extern void __sev_es_ist_enter(struct pt_regs *regs);
 extern void __sev_es_ist_exit(void);
@@ -223,7 +288,8 @@ void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
 u64 sev_get_status(void);
@@ -248,7 +314,8 @@ static inline void snp_set_memory_private(unsigned long vaddr, unsigned long npa
 static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
-static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+static inline int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+					  struct snp_guest_request_ioctl *rio)
 {
 	return -ENOTTY;
 }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 1ef7ae806a01..479b68e00a54 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2173,7 +2173,8 @@ static int __init init_sev_config(char *str)
 }
 __setup("sev=", init_sev_config);
 
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2197,12 +2198,12 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 
 	vc_ghcb_invalidate(ghcb);
 
-	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-		ghcb_set_rax(ghcb, input->data_gpa);
-		ghcb_set_rbx(ghcb, input->data_npages);
+	if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+		ghcb_set_rax(ghcb, __pa(req->data));
+		ghcb_set_rbx(ghcb, req->data_npages);
 	}
 
-	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, req->exit_code, input->req_gpa, input->resp_gpa);
 	if (ret)
 		goto e_put;
 
@@ -2217,8 +2218,8 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
 		/* Number of expected pages are returned in RBX */
-		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
-			input->data_npages = ghcb_get_rbx(ghcb);
+		if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+			req->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
 		}
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 01b565170729..596cec03f9eb 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -28,8 +28,6 @@
 #include <asm/svm.h>
 #include <asm/sev.h>
 
-#include "sev-guest.h"
-
 #define DEVICE_NAME	"sev-guest"
 
 #define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
@@ -169,65 +167,64 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 	return ctx;
 }
 
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
 {
-	struct snp_guest_msg *resp = &snp_dev->secret_response;
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
-	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
+	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
+	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
+	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
 	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
-		 resp_hdr->msg_seqno, resp_hdr->msg_type, resp_hdr->msg_version,
-		 resp_hdr->msg_sz);
+		 resp_msg_hdr->msg_seqno, resp_msg_hdr->msg_type, resp_msg_hdr->msg_version,
+		 resp_msg_hdr->msg_sz);
 
 	/* Copy response from shared memory to encrypted memory. */
-	memcpy(resp, snp_dev->response, sizeof(*resp));
+	memcpy(resp_msg, snp_dev->response, sizeof(*resp_msg));
 
 	/* Verify that the sequence counter is incremented by 1 */
-	if (unlikely(resp_hdr->msg_seqno != (req_hdr->msg_seqno + 1)))
+	if (unlikely(resp_msg_hdr->msg_seqno != (req_msg_hdr->msg_seqno + 1)))
 		return -EBADMSG;
 
 	/* Verify response message type and version number. */
-	if (resp_hdr->msg_type != (req_hdr->msg_type + 1) ||
-	    resp_hdr->msg_version != req_hdr->msg_version)
+	if (resp_msg_hdr->msg_type != (req_msg_hdr->msg_type + 1) ||
+	    resp_msg_hdr->msg_version != req_msg_hdr->msg_version)
 		return -EBADMSG;
 
 	/*
 	 * If the message size is greater than our buffer length then return
 	 * an error.
 	 */
-	if (unlikely((resp_hdr->msg_sz + ctx->authsize) > sz))
+	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > req->resp_sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
-	memcpy(iv, &resp_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_hdr->msg_seqno)));
-	if (!aesgcm_decrypt(ctx, payload, resp->payload, resp_hdr->msg_sz,
-			    &resp_hdr->algo, AAD_LEN, iv, resp_hdr->authtag))
+	memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
+	if (!aesgcm_decrypt(ctx, req->resp_buf, resp_msg->payload, resp_msg_hdr->msg_sz,
+			    &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
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
@@ -236,17 +233,17 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
+	if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload)))
 		return -EBADMSG;
 
 	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
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
@@ -261,7 +258,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * sequence number must be incremented or the VMPCK must be deleted to
 	 * prevent reuse of the IV.
 	 */
-	rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
+	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
 	switch (rc) {
 	case -ENOSPC:
 		/*
@@ -271,8 +268,8 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		 * order to increment the sequence number and thus avoid
 		 * IV reuse.
 		 */
-		override_npages = snp_dev->input.data_npages;
-		exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
+		override_npages = req->data_npages;
+		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
 		/*
 		 * Override the error to inform callers the given extended
@@ -327,15 +324,13 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
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
@@ -349,7 +344,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
 
 	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
-	rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
+	rc = enc_payload(snp_dev, seqno, req);
 	if (rc)
 		return rc;
 
@@ -360,7 +355,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memcpy(snp_dev->request, &snp_dev->secret_request,
 	       sizeof(snp_dev->secret_request));
 
-	rc = __handle_guest_request(snp_dev, exit_code, rio);
+	rc = __handle_guest_request(snp_dev, req, rio);
 	if (rc) {
 		if (rc == -EIO &&
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
@@ -369,12 +364,11 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
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
@@ -391,8 +385,9 @@ struct snp_req_resp {
 
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_report_req *req = &snp_dev->req.report;
-	struct snp_report_resp *resp;
+	struct snp_report_req *report_req = &snp_dev->req.report;
+	struct snp_guest_req req = {0};
+	struct snp_report_resp *report_resp;
 	int rc, resp_len;
 
 	lockdep_assert_held(&snp_cmd_mutex);
@@ -400,7 +395,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
-	if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+	if (copy_from_user(report_req, (void __user *)arg->req_data, sizeof(*report_req)))
 		return -EFAULT;
 
 	/*
@@ -408,29 +403,37 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
-	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-	if (!resp)
+	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+	if (!report_resp)
 		return -ENOMEM;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_REPORT_REQ, req, sizeof(*req), resp->data,
-				  resp_len);
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_REPORT_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = report_req;
+	req.req_sz = sizeof(*report_req);
+	req.resp_buf = report_resp->data;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &req, arg);
 	if (rc)
 		goto e_free;
 
-	if (copy_to_user((void __user *)arg->resp_data, resp, sizeof(*resp)))
+	if (copy_to_user((void __user *)arg->resp_data, report_resp, sizeof(*report_resp)))
 		rc = -EFAULT;
 
 e_free:
-	kfree(resp);
+	kfree(report_resp);
 	return rc;
 }
 
 static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
-	struct snp_derived_key_req *req = &snp_dev->req.derived_key;
-	struct snp_derived_key_resp resp = {0};
+	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
+	struct snp_derived_key_resp derived_key_resp = {0};
+	struct snp_guest_req req = {0};
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
@@ -445,25 +448,35 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp.data) + snp_dev->ctx->authsize;
+	resp_len = sizeof(derived_key_resp.data) + snp_dev->ctx->authsize;
 	if (sizeof(buf) < resp_len)
 		return -ENOMEM;
 
-	if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+	if (copy_from_user(derived_key_req, (void __user *)arg->req_data,
+			   sizeof(*derived_key_req)))
 		return -EFAULT;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_KEY_REQ, req, sizeof(*req), buf, resp_len);
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_KEY_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = derived_key_req;
+	req.req_sz = sizeof(*derived_key_req);
+	req.resp_buf = buf;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_GUEST_REQUEST;
+
+	rc = snp_send_guest_request(snp_dev, &req, arg);
 	if (rc)
 		return rc;
 
-	memcpy(resp.data, buf, sizeof(resp.data));
-	if (copy_to_user((void __user *)arg->resp_data, &resp, sizeof(resp)))
+	memcpy(derived_key_resp.data, buf, sizeof(derived_key_resp.data));
+	if (copy_to_user((void __user *)arg->resp_data, &derived_key_resp,
+			 sizeof(derived_key_resp)))
 		rc = -EFAULT;
 
 	/* The response buffer contains the sensitive data, explicitly clear it. */
 	memzero_explicit(buf, sizeof(buf));
-	memzero_explicit(&resp, sizeof(resp));
+	memzero_explicit(&derived_key_resp, sizeof(derived_key_resp));
 	return rc;
 }
 
@@ -471,32 +484,33 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 			  struct snp_req_resp *io)
 
 {
-	struct snp_ext_report_req *req = &snp_dev->req.ext_report;
-	struct snp_report_resp *resp;
-	int ret, npages = 0, resp_len;
+	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
+	struct snp_guest_req req = {0};
+	struct snp_report_resp *report_resp;
 	sockptr_t certs_address;
+	int ret, resp_len;
 
 	lockdep_assert_held(&snp_cmd_mutex);
 
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
 
-	if (copy_from_sockptr(req, io->req_data, sizeof(*req)))
+	if (copy_from_sockptr(report_req, io->req_data, sizeof(*report_req)))
 		return -EFAULT;
 
 	/* caller does not want certificate data */
-	if (!req->certs_len || !req->certs_address)
+	if (!report_req->certs_len || !report_req->certs_address)
 		goto cmd;
 
-	if (req->certs_len > SEV_FW_BLOB_MAX_SIZE ||
-	    !IS_ALIGNED(req->certs_len, PAGE_SIZE))
+	if (report_req->certs_len > SEV_FW_BLOB_MAX_SIZE ||
+	    !IS_ALIGNED(report_req->certs_len, PAGE_SIZE))
 		return -EINVAL;
 
 	if (sockptr_is_kernel(io->resp_data)) {
-		certs_address = KERNEL_SOCKPTR((void *)req->certs_address);
+		certs_address = KERNEL_SOCKPTR((void *)report_req->certs_address);
 	} else {
-		certs_address = USER_SOCKPTR((void __user *)req->certs_address);
-		if (!access_ok(certs_address.user, req->certs_len))
+		certs_address = USER_SOCKPTR((void __user *)report_req->certs_address);
+		if (!access_ok(certs_address.user, report_req->certs_len))
 			return -EFAULT;
 	}
 
@@ -506,45 +520,53 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * the host. If host does not supply any certs in it, then copy
 	 * zeros to indicate that certificate data was not provided.
 	 */
-	memset(snp_dev->certs_data, 0, req->certs_len);
-	npages = req->certs_len >> PAGE_SHIFT;
+	memset(snp_dev->certs_data, 0, report_req->certs_len);
+	req.data_npages = report_req->certs_len >> PAGE_SHIFT;
 cmd:
 	/*
 	 * The intermediate response buffer is used while decrypting the
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + snp_dev->ctx->authsize;
-	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-	if (!resp)
+	resp_len = sizeof(report_resp->data) + snp_dev->ctx->authsize;
+	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+	if (!report_resp)
 		return -ENOMEM;
 
-	snp_dev->input.data_npages = npages;
-	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg,
-				   SNP_MSG_REPORT_REQ, &req->data,
-				   sizeof(req->data), resp->data, resp_len);
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_REPORT_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = &report_req->data;
+	req.req_sz = sizeof(report_req->data);
+	req.resp_buf = report_resp->data;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_EXT_GUEST_REQUEST;
+	req.data = snp_dev->certs_data;
+
+	ret = snp_send_guest_request(snp_dev, &req, arg);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
-		req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+		report_req->certs_len = req.data_npages << PAGE_SHIFT;
 
-		if (copy_to_sockptr(io->req_data, req, sizeof(*req)))
+		if (copy_to_sockptr(io->req_data, report_req, sizeof(*report_req)))
 			ret = -EFAULT;
 	}
 
 	if (ret)
 		goto e_free;
 
-	if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, req->certs_len)) {
+	if (req.data_npages && report_req->certs_len &&
+	    copy_to_sockptr(certs_address, snp_dev->certs_data, report_req->certs_len)) {
 		ret = -EFAULT;
 		goto e_free;
 	}
 
-	if (copy_to_sockptr(io->resp_data, resp, sizeof(*resp)))
+	if (copy_to_sockptr(io->resp_data, report_resp, sizeof(*report_resp)))
 		ret = -EFAULT;
 
 e_free:
-	kfree(resp);
+	kfree(report_resp);
 	return ret;
 }
 
@@ -868,7 +890,6 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	/* initial the input address for guest request */
 	snp_dev->input.req_gpa = __pa(snp_dev->request);
 	snp_dev->input.resp_gpa = __pa(snp_dev->response);
-	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
 
 	ret = tsm_register(&sev_tsm_ops, snp_dev, &tsm_report_extra_type);
 	if (ret)
diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
deleted file mode 100644
index ceb798a404d6..000000000000
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ /dev/null
@@ -1,66 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-only */
-/*
- * Copyright (C) 2021 Advanced Micro Devices, Inc.
- *
- * Author: Brijesh Singh <brijesh.singh@amd.com>
- *
- * SEV-SNP API spec is available at https://developer.amd.com/sev
- */
-
-#ifndef __VIRT_SEVGUEST_H__
-#define __VIRT_SEVGUEST_H__
-
-#include <linux/types.h>
-
-#define MAX_AUTHTAG_LEN		32
-#define AUTHTAG_LEN		16
-#define AAD_LEN			48
-#define MSG_HDR_VER		1
-
-/* See SNP spec SNP_GUEST_REQUEST section for the structure */
-enum msg_type {
-	SNP_MSG_TYPE_INVALID = 0,
-	SNP_MSG_CPUID_REQ,
-	SNP_MSG_CPUID_RSP,
-	SNP_MSG_KEY_REQ,
-	SNP_MSG_KEY_RSP,
-	SNP_MSG_REPORT_REQ,
-	SNP_MSG_REPORT_RSP,
-	SNP_MSG_EXPORT_REQ,
-	SNP_MSG_EXPORT_RSP,
-	SNP_MSG_IMPORT_REQ,
-	SNP_MSG_IMPORT_RSP,
-	SNP_MSG_ABSORB_REQ,
-	SNP_MSG_ABSORB_RSP,
-	SNP_MSG_VMRK_REQ,
-	SNP_MSG_VMRK_RSP,
-
-	SNP_MSG_TYPE_MAX
-};
-
-enum aead_algo {
-	SNP_AEAD_INVALID,
-	SNP_AEAD_AES_256_GCM,
-};
-
-struct snp_guest_msg_hdr {
-	u8 authtag[MAX_AUTHTAG_LEN];
-	u64 msg_seqno;
-	u8 rsvd1[8];
-	u8 algo;
-	u8 hdr_version;
-	u16 hdr_sz;
-	u8 msg_type;
-	u8 msg_version;
-	u16 msg_sz;
-	u32 rsvd2;
-	u8 msg_vmpck;
-	u8 rsvd3[35];
-} __packed;
-
-struct snp_guest_msg {
-	struct snp_guest_msg_hdr hdr;
-	u8 payload[4000];
-} __packed;
-
-#endif /* __VIRT_SEVGUEST_H__ */
-- 
2.34.1


