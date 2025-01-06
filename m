Return-Path: <kvm+bounces-34590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 25859A025E5
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 13:48:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51077188314D
	for <lists+kvm@lfdr.de>; Mon,  6 Jan 2025 12:48:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 348282BD11;
	Mon,  6 Jan 2025 12:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y+mljzDM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2079.outbound.protection.outlook.com [40.107.101.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFD31DE4D0;
	Mon,  6 Jan 2025 12:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.79
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736167647; cv=fail; b=NdVKT3bd+2CG+S6Ty8NRNDxgJnxGb/oCrFZcgnKMTNlCWebnXPT4cvZQTsO1trnVFiREzHxeFyBsPL4N/PgyZC2no6Yvl8G8Ua7X3we9uHFa27xbiKW0TAIF5g2YXIDAncSeCMm/oSAQmwnyd/LO2ej0ja41ZdHPTgKaaXueu0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736167647; c=relaxed/simple;
	bh=/TCZKXkVqWHMDsD8vC5M602TUzxcI7VKpepTo5p/Xj8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qbjWlVI1Eelfmt+dsazA6ZTleOR09g1PoMYSnbDZurTG6ZdLmc6TJX+N6eqJ1Zj9kybptFqnKloGTreciUMv3blJimWWiozgRONO+2nz7z7Tlvjd+2YO3ZcW9dv+xo5ve0OtD9QUFOSqhPpKBdEFnzyjcBIO22rvera1KVEeWOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y+mljzDM; arc=fail smtp.client-ip=40.107.101.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=i2Gv5NsSevAXXkuSCSmnD3CYwLd6m0OlvN4DYGGhcI2v8MmKY1g+tHHD0tYhEyHrCFsrmcLfdYtLUOUICXY4kg6xovAnOABPORJVAxPRBtDA21Keju0J1XrFP3CULL1rlrlSa/mRZskyTKyMrgqwbIgBfLVjeduJsfUwcua6r6YxO8ASmZoVx3QL6sZklI57fYD0THYdtKdLCwgRpSNYVkc5YSEb6aLIlfLaBGzgbi8qBM+I5Nzorvw6GdK+ra+Tax+pKwu8VRSaxDHjKhqoy78pcyBxm6RNBaXtSf6TmA/OU76rNy1f+ZHNyFcieaQEvhBsd9gfYaNK7VtbMkj2KQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Oukpiw/NkamBItzy4a410XKJOQCNes4kqui0akUT6dg=;
 b=rzHyTlLEDGkmLE2rtDHLULHb3BBe9JNCFHtJoyyJLscYC1me/MC6W35M1ui6yCf/0BN19pshLkXWryBZHiFC0kfFOy7Jw3jfdlHyvSP8nM5x2ywafkER2jQtvzF+xihTNua+fHeoXsrpwH3BIfKC+I//yle/ldPDsXcJvzAWiiMs4FbVCqfncDWJFF/D9x5QupZ6DSF+0S7bq5ZFdM+TVfaCGWAA2V3f46ICT67lr9k+gV240qlUF8K5wggLbU5jW8XH3e4usGdk1WMoPHXLnh77LiEhDgmRoDTRAh9IKnACIS2mQs0WI18BSWX3KYPxdOjafQ2EG3U7Yj6ec6Zv6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oukpiw/NkamBItzy4a410XKJOQCNes4kqui0akUT6dg=;
 b=y+mljzDMAwi18DNincl41CDbUstMdz6VEnkKCHLxdaCAhpMEUEvgUkpTDpokJDm1tBz30eQFMLUZyu6yuRcG1RvTqBYwBplwrT5lVW8k+0d62cEjBH+G708yD0RyQVFKs4W0lX5r9sitjDqj+f3mbwfTxiFAVyUUPIYLlhiWq80=
Received: from PH7P221CA0030.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:32a::35)
 by PH0PR12MB7078.namprd12.prod.outlook.com (2603:10b6:510:21d::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.18; Mon, 6 Jan
 2025 12:47:16 +0000
Received: from CY4PEPF0000EDD2.namprd03.prod.outlook.com
 (2603:10b6:510:32a:cafe::51) by PH7P221CA0030.outlook.office365.com
 (2603:10b6:510:32a::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8314.17 via Frontend Transport; Mon,
 6 Jan 2025 12:47:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD2.mail.protection.outlook.com (10.167.241.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8335.7 via Frontend Transport; Mon, 6 Jan 2025 12:47:16 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 6 Jan
 2025 06:47:09 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>
CC: <kvm@vger.kernel.org>, <mingo@redhat.com>, <tglx@linutronix.de>,
	<dave.hansen@linux.intel.com>, <pgonda@google.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <nikunj@amd.com>, <francescolavra.fl@gmail.com>
Subject: [PATCH v16 04/13] x86/sev: Relocate SNP guest messaging routines to common code
Date: Mon, 6 Jan 2025 18:16:24 +0530
Message-ID: <20250106124633.1418972-5-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD2:EE_|PH0PR12MB7078:EE_
X-MS-Office365-Filtering-Correlation-Id: fc4363ef-792d-4f2e-91ba-08dd2e504038
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|7416014|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?f/2nx5xTshh+RrBdk6Pf6BAeWz1Rjj8wcZVz9lGWmaCCh3zDlC4xfmBWBQRs?=
 =?us-ascii?Q?ZRlKvnnCmN9Oa9MdOxJEjSW5ICfRV+p5cL+QOc/EzMmSDEmUStSpzNEwMq3f?=
 =?us-ascii?Q?XjQTt7tCyLypmTEV+PzqHz+iLf0g730HtPVQfLIg47Ob5MYGZjC0ypymvXDc?=
 =?us-ascii?Q?W1ci6JFsEKoFW07f7ut6Gem8p5e0Abi1W+SjPd2lwUrEeWKw6tbCiHvopVBD?=
 =?us-ascii?Q?f8fsqw00WnZeVTpQft4NTgqAKrllmLBHU3UBQuthdRJIOk9ivsojoPZ2/Zzp?=
 =?us-ascii?Q?Nv86s4WdW20t3k+hyQ2GOpXxXpiHQ9BFOLlnJ5TCLbm30odZB4GgvD4rWLSe?=
 =?us-ascii?Q?dUYFJYhEnxtutVA9ycdlOVjZaxoCqaLea6KZH/yRsh6hqxDcKI8WpRKCnK2Q?=
 =?us-ascii?Q?pVVHW8ufVCjmHVNFl2njsfiRFb6WjA5p8vw8xhll2Basc1ZByh/h9ptuyxZr?=
 =?us-ascii?Q?uO4c2jcyzCiIXOrJGWZ7b28w5AV+tE7XAj+f0UrddJEWWU63HiITEcpurwgf?=
 =?us-ascii?Q?zG55RSx0rYrVFvTVeTZ2vp+QKkSCRbR0s9ai4Ti0EKQPXbcEBa++KFnf5ATx?=
 =?us-ascii?Q?/c19wpRiLSejKXSNYA+Npg2kqr+eilM43YJeM+V2WHikVkJW3kGcOpFlYXv3?=
 =?us-ascii?Q?qoQlhXUJkMLkMg7I2TrFwlCdBvDEvmBs9mRQx+1UrjKTfrvIzGrSPZNTPHZN?=
 =?us-ascii?Q?DPS/kJ61zKKNVofx/UMgTnEKU84tzK4b0mQwBJfKKzjVKumovll7QpAB2PlB?=
 =?us-ascii?Q?YwVET86NyodH8HRpTgAdwysPyQBE4cGtwmmS6be5IalbuQQw+eg4GFhlwsgC?=
 =?us-ascii?Q?cB4QBOq6DyIcwq+nOcD2YR/+X1uY+UN19DvSECQbb+Cc7WWPhhAirXleIybp?=
 =?us-ascii?Q?IbuM7LCKpNDJXWD4yg3GM8WtP7uJfeDSVINhSVfOCGmHLIGPV98ri4WjjnDf?=
 =?us-ascii?Q?QdnQPKg7k5usKVRbh8XANcPE9hi3F5Wy+eIOAJmwu3FUvnHMsqWKLbpJ3PAA?=
 =?us-ascii?Q?ILAvFExXSgqxJJdayE9NyN7qSUc5Ep0Mbp9xS9eBGBXBLgdpHu/HHlgEm3VZ?=
 =?us-ascii?Q?9FyoOPz8Xui8z3Mc7rmC57i8KI4nfcZuh48jV82eaPnhzZboKyDi83CVRkjr?=
 =?us-ascii?Q?oK5tB00t7AAi5AEWBRqiBtLLM7G5NPqOEG3eIrdCgVhgzq/50WYZB3yZguRr?=
 =?us-ascii?Q?84WfBtQa6H5GS3RQgR76V6kHMT/Ok4epgBHf9/+thEter52zprfvsMxCjbbM?=
 =?us-ascii?Q?VGpXwScmKuOeQz3KRLjpXRzcJw/qnXElJla15JB1Psr4GPFfBBbwqUAYXpI7?=
 =?us-ascii?Q?SE217EYD3t/Q2Xlrvclcz1mGnzcJLUqrL5LIgiYY+YixMyJXB+w+YYq9MDH5?=
 =?us-ascii?Q?rii1n8UH8E5xu+SbAYxjgoGDj5hVx3CeUn2YS0fAIqFAUDiATBgZ8yFAljQ3?=
 =?us-ascii?Q?a2IePtEyjVbVDxySy+un+kc7kvjyT+OZZ1rCwvm2BPteF8rqIXVZqxHNW2Al?=
 =?us-ascii?Q?8xb/fIBhi9XcsIo=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(7416014)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2025 12:47:16.4470
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fc4363ef-792d-4f2e-91ba-08dd2e504038
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD2.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7078

At present, the SEV guest driver exclusively handles SNP guest messaging.
All routines for sending guest messages are embedded within the guest
driver. To support Secure TSC, SEV-SNP guests must communicate with the AMD
Security Processor during early boot. However, these guest messaging
functions are not accessible during early boot since they are currently
part of the guest driver.

Hence, relocate the core SNP guest messaging functions to SEV common code
and provide an API for sending SNP guest messages.

No functional change, but just an export symbol added for
snp_send_guest_request() and dropped the export symbol on
snp_issue_guest_request() and made it static.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              |  14 +-
 arch/x86/coco/sev/core.c                | 294 +++++++++++++++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.c | 292 -----------------------
 3 files changed, 298 insertions(+), 302 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index db08d0ac90be..0937ac7a96db 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -125,6 +125,9 @@ struct snp_req_data {
 #define AAD_LEN			48
 #define MSG_HDR_VER		1
 
+#define SNP_REQ_MAX_RETRY_DURATION      (60*HZ)
+#define SNP_REQ_RETRY_DELAY             (2*HZ)
+
 /* See SNP spec SNP_GUEST_REQUEST section for the structure */
 enum msg_type {
 	SNP_MSG_TYPE_INVALID = 0,
@@ -443,8 +446,6 @@ void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __noreturn snp_abort(void);
 void snp_dmi_setup(void);
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio);
 int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
@@ -459,6 +460,8 @@ void snp_kexec_begin(void);
 int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id);
 struct snp_msg_desc *snp_msg_alloc(void);
 void snp_msg_free(struct snp_msg_desc *mdesc);
+int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -482,11 +485,6 @@ static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
 static inline void snp_dmi_setup(void) { }
-static inline int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-					  struct snp_guest_request_ioctl *rio)
-{
-	return -ENOTTY;
-}
 static inline int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input)
 {
 	return -ENOTTY;
@@ -503,6 +501,8 @@ static inline void snp_kexec_begin(void) { }
 static inline int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id) { return -1; }
 static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
 static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
+static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
+					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 93627a21945d..feb145df6bf7 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2504,8 +2504,8 @@ int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
 }
 EXPORT_SYMBOL_GPL(snp_issue_svsm_attest_req);
 
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio)
+static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+				   struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2567,7 +2567,6 @@ int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *inpu
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(snp_issue_guest_request);
 
 static struct platform_device sev_guest_device = {
 	.name		= "sev-guest",
@@ -2833,3 +2832,292 @@ void snp_msg_free(struct snp_msg_desc *mdesc)
 	kfree(mdesc);
 }
 EXPORT_SYMBOL_GPL(snp_msg_free);
+
+/* Mutex to serialize the shared buffer access and command handling. */
+static DEFINE_MUTEX(snp_cmd_mutex);
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
+static void snp_disable_vmpck(struct snp_msg_desc *mdesc)
+{
+	pr_alert("Disabling VMPCK%d communication key to prevent IV reuse.\n",
+		  mdesc->vmpck_id);
+	memzero_explicit(mdesc->vmpck, VMPCK_KEY_LEN);
+	mdesc->vmpck = NULL;
+}
+
+static inline u64 __snp_get_msg_seqno(struct snp_msg_desc *mdesc)
+{
+	u64 count;
+
+	lockdep_assert_held(&snp_cmd_mutex);
+
+	/* Read the current message sequence counter from secrets pages */
+	count = *mdesc->os_area_msg_seqno;
+
+	return count + 1;
+}
+
+/* Return a non-zero on success */
+static u64 snp_get_msg_seqno(struct snp_msg_desc *mdesc)
+{
+	u64 count = __snp_get_msg_seqno(mdesc);
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
+		pr_err("request message sequence counter overflow\n");
+		return 0;
+	}
+
+	return count;
+}
+
+static void snp_inc_msg_seqno(struct snp_msg_desc *mdesc)
+{
+	/*
+	 * The counter is also incremented by the PSP, so increment it by 2
+	 * and save in secrets page.
+	 */
+	*mdesc->os_area_msg_seqno += 2;
+}
+
+static int verify_and_dec_payload(struct snp_msg_desc *mdesc, struct snp_guest_req *req)
+{
+	struct snp_guest_msg *resp_msg = &mdesc->secret_response;
+	struct snp_guest_msg *req_msg = &mdesc->secret_request;
+	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
+	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
+	struct aesgcm_ctx *ctx = mdesc->ctx;
+	u8 iv[GCM_AES_IV_SIZE] = {};
+
+	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
+		 resp_msg_hdr->msg_seqno, resp_msg_hdr->msg_type, resp_msg_hdr->msg_version,
+		 resp_msg_hdr->msg_sz);
+
+	/* Copy response from shared memory to encrypted memory. */
+	memcpy(resp_msg, mdesc->response, sizeof(*resp_msg));
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
+static int enc_payload(struct snp_msg_desc *mdesc, u64 seqno, struct snp_guest_req *req)
+{
+	struct snp_guest_msg *msg = &mdesc->secret_request;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
+	struct aesgcm_ctx *ctx = mdesc->ctx;
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
+static int __handle_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
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
+	rc = snp_issue_guest_request(req, &mdesc->input, rio);
+	switch (rc) {
+	case -ENOSPC:
+		/*
+		 * If the extended guest request fails due to having too
+		 * small of a certificate data buffer, retry the same
+		 * guest request without the extended data request in
+		 * order to increment the sequence number and thus avoid
+		 * IV reuse.
+		 */
+		override_npages = mdesc->input.data_npages;
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
+	snp_inc_msg_seqno(mdesc);
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
+		mdesc->input.data_npages = override_npages;
+
+	return rc;
+}
+
+int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio)
+{
+	u64 seqno;
+	int rc;
+
+	guard(mutex)(&snp_cmd_mutex);
+
+	/* Check if the VMPCK is not empty */
+	if (!mdesc->vmpck || !memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
+		pr_err_ratelimited("VMPCK is disabled\n");
+		return -ENOTTY;
+	}
+
+	/* Get message sequence and verify that its a non-zero */
+	seqno = snp_get_msg_seqno(mdesc);
+	if (!seqno)
+		return -EIO;
+
+	/* Clear shared memory's response for the host to populate. */
+	memset(mdesc->response, 0, sizeof(struct snp_guest_msg));
+
+	/* Encrypt the userspace provided payload in mdesc->secret_request. */
+	rc = enc_payload(mdesc, seqno, req);
+	if (rc)
+		return rc;
+
+	/*
+	 * Write the fully encrypted request to the shared unencrypted
+	 * request page.
+	 */
+	memcpy(mdesc->request, &mdesc->secret_request, sizeof(mdesc->secret_request));
+
+	rc = __handle_guest_request(mdesc, req, rio);
+	if (rc) {
+		if (rc == -EIO &&
+		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
+			return rc;
+
+		pr_alert("Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
+			 rc, rio->exitinfo2);
+
+		snp_disable_vmpck(mdesc);
+		return rc;
+	}
+
+	rc = verify_and_dec_payload(mdesc, req);
+	if (rc) {
+		pr_alert("Detected unexpected decode failure from ASP. rc: %d\n", rc);
+		snp_disable_vmpck(mdesc);
+		return rc;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(snp_send_guest_request);
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index d0f7233b1430..264b6523fe52 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -31,9 +31,6 @@
 
 #define DEVICE_NAME	"sev-guest"
 
-#define SNP_REQ_MAX_RETRY_DURATION	(60*HZ)
-#define SNP_REQ_RETRY_DELAY		(2*HZ)
-
 #define SVSM_MAX_RETRIES		3
 
 struct snp_guest_dev {
@@ -60,76 +57,6 @@ static int vmpck_id = -1;
 module_param(vmpck_id, int, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
-/* Mutex to serialize the shared buffer access and command handling. */
-static DEFINE_MUTEX(snp_cmd_mutex);
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
-static void snp_disable_vmpck(struct snp_msg_desc *mdesc)
-{
-	pr_alert("Disabling VMPCK%d communication key to prevent IV reuse.\n",
-		  mdesc->vmpck_id);
-	memzero_explicit(mdesc->vmpck, VMPCK_KEY_LEN);
-	mdesc->vmpck = NULL;
-}
-
-static inline u64 __snp_get_msg_seqno(struct snp_msg_desc *mdesc)
-{
-	u64 count;
-
-	lockdep_assert_held(&snp_cmd_mutex);
-
-	/* Read the current message sequence counter from secrets pages */
-	count = *mdesc->os_area_msg_seqno;
-
-	return count + 1;
-}
-
-/* Return a non-zero on success */
-static u64 snp_get_msg_seqno(struct snp_msg_desc *mdesc)
-{
-	u64 count = __snp_get_msg_seqno(mdesc);
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
-		pr_err("request message sequence counter overflow\n");
-		return 0;
-	}
-
-	return count;
-}
-
-static void snp_inc_msg_seqno(struct snp_msg_desc *mdesc)
-{
-	/*
-	 * The counter is also incremented by the PSP, so increment it by 2
-	 * and save in secrets page.
-	 */
-	*mdesc->os_area_msg_seqno += 2;
-}
-
 static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 {
 	struct miscdevice *dev = file->private_data;
@@ -137,225 +64,6 @@ static inline struct snp_guest_dev *to_snp_dev(struct file *file)
 	return container_of(dev, struct snp_guest_dev, misc);
 }
 
-static int verify_and_dec_payload(struct snp_msg_desc *mdesc, struct snp_guest_req *req)
-{
-	struct snp_guest_msg *resp_msg = &mdesc->secret_response;
-	struct snp_guest_msg *req_msg = &mdesc->secret_request;
-	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
-	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
-	struct aesgcm_ctx *ctx = mdesc->ctx;
-	u8 iv[GCM_AES_IV_SIZE] = {};
-
-	pr_debug("response [seqno %lld type %d version %d sz %d]\n",
-		 resp_msg_hdr->msg_seqno, resp_msg_hdr->msg_type, resp_msg_hdr->msg_version,
-		 resp_msg_hdr->msg_sz);
-
-	/* Copy response from shared memory to encrypted memory. */
-	memcpy(resp_msg, mdesc->response, sizeof(*resp_msg));
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
-static int enc_payload(struct snp_msg_desc *mdesc, u64 seqno, struct snp_guest_req *req)
-{
-	struct snp_guest_msg *msg = &mdesc->secret_request;
-	struct snp_guest_msg_hdr *hdr = &msg->hdr;
-	struct aesgcm_ctx *ctx = mdesc->ctx;
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
-static int __handle_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
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
-	rc = snp_issue_guest_request(req, &mdesc->input, rio);
-	switch (rc) {
-	case -ENOSPC:
-		/*
-		 * If the extended guest request fails due to having too
-		 * small of a certificate data buffer, retry the same
-		 * guest request without the extended data request in
-		 * order to increment the sequence number and thus avoid
-		 * IV reuse.
-		 */
-		override_npages = mdesc->input.data_npages;
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
-	snp_inc_msg_seqno(mdesc);
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
-		mdesc->input.data_npages = override_npages;
-
-	return rc;
-}
-
-static int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
-				  struct snp_guest_request_ioctl *rio)
-{
-	u64 seqno;
-	int rc;
-
-	guard(mutex)(&snp_cmd_mutex);
-
-	/* Check if the VMPCK is not empty */
-	if (!mdesc->vmpck || !memchr_inv(mdesc->vmpck, 0, VMPCK_KEY_LEN)) {
-		pr_err_ratelimited("VMPCK is disabled\n");
-		return -ENOTTY;
-	}
-
-	/* Get message sequence and verify that its a non-zero */
-	seqno = snp_get_msg_seqno(mdesc);
-	if (!seqno)
-		return -EIO;
-
-	/* Clear shared memory's response for the host to populate. */
-	memset(mdesc->response, 0, sizeof(struct snp_guest_msg));
-
-	/* Encrypt the userspace provided payload in mdesc->secret_request. */
-	rc = enc_payload(mdesc, seqno, req);
-	if (rc)
-		return rc;
-
-	/*
-	 * Write the fully encrypted request to the shared unencrypted
-	 * request page.
-	 */
-	memcpy(mdesc->request, &mdesc->secret_request,
-	       sizeof(mdesc->secret_request));
-
-	rc = __handle_guest_request(mdesc, req, rio);
-	if (rc) {
-		if (rc == -EIO &&
-		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
-			return rc;
-
-		pr_alert("Detected error from ASP request. rc: %d, exitinfo2: 0x%llx\n",
-			 rc, rio->exitinfo2);
-
-		snp_disable_vmpck(mdesc);
-		return rc;
-	}
-
-	rc = verify_and_dec_payload(mdesc, req);
-	if (rc) {
-		pr_alert("Detected unexpected decode failure from ASP. rc: %d\n", rc);
-		snp_disable_vmpck(mdesc);
-		return rc;
-	}
-
-	return 0;
-}
-
 struct snp_req_resp {
 	sockptr_t req_data;
 	sockptr_t resp_data;
-- 
2.34.1


