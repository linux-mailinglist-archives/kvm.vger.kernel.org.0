Return-Path: <kvm+bounces-29804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CECAE9B2464
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 06:37:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 36DF2B22C86
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 05:37:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7146D191461;
	Mon, 28 Oct 2024 05:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="MeqBMoC4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2076.outbound.protection.outlook.com [40.107.237.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B1218CBF9;
	Mon, 28 Oct 2024 05:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730093726; cv=fail; b=h537DjSvvK0im3mxcK1BXKx+TpzeiRREptf4CTfnYnSAoha3srV7F64YXchOby0WC1kTZcmWq0qcjH84xVOn3uWCFG6NMhCeVsXGg113cVhL/E/SLzyd/+63CW6EzW+k72ZpgQalrzIQ0+g4KGSm9yO0fZEnOAqUXWMzvAHQE5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730093726; c=relaxed/simple;
	bh=RHBmoHqM5ZGAiGvChT+X2KckG2N4x4w/n0lg6f+cjok=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KT0fZDzLvKo5oVroRybl/9o7xEf8XKplCrLVoNwYnCIIdwCIVR4QALF9JktXERPHcjclxv/Y9bYzmXJzLvwHZvCPxZNGgxo5hHO9kKZTgs4MH6btM99fVKB3T1tTUe9Hii7VUf/d56wKeQ91mQ6Qj10XbDW6geGrQ7Ocf2elUmI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=MeqBMoC4; arc=fail smtp.client-ip=40.107.237.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dIQiBO02q470w3eZL6RgJAWcWEwnO8/TW0PIUstnRISo7lG0fT0RpL3jGCg8QWcTNKI9s6qzxZ2BDMHXZLqrq8g3GAGy7mEvW4XuvSb49m5bQp6TTTsweaTWT/dXv/MKTyerYBWwoiQE9e1j7YFffBIf2pxQ3v4FwYwPlrTNuNi1eyNpJiTMzIEtPr8PAZdwmh8VayfMw78K2uQRdQe11WmMGly3rsB5kuKqvk2kGHPGih+L7iKEMcTOTERSoAM50XOcZ2CZwEkIOPSFtWVhXMYsX3yILiPHC9BqmUfpGGcnieYDGGRfrS1zRDlm/HoWMHjonPXySWy1EUNWw7b86w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1hDZP03aUpnP3mricDnRDxtyoyn6Nm7/c7XIhDSatWo=;
 b=ist5SylQmrBpR7ZdLR+fxo0UDMsAjy3fB/+gW7u4J1FAiltnH7N1TjU8te5bwMLcve3pCnuJWmOCYVyp4XqIRZmiXaRDKl5bJ8jggVbHFEsdVho+QuW9pLnMcLmasOXcPlRv9Pn6dDmx0+PSXDYYaXF0UhQAgT8gvh3dfgnwutVzkPVMKPJZiZ57yZ968iEztJZS6CgTnJVkQaz9qkXh1sqyhXoknFkSYvnjmx3kDN/Vf/fyftLfxNgMbikazI2Ll+Lk2XuSCsNHbE/1y5BbIQKXkkZVmnIv0Qdya+5Qu1bjHNs87ffSSgI9Vmt4J2yJmdn0gckBLtcOYTbC56gzkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1hDZP03aUpnP3mricDnRDxtyoyn6Nm7/c7XIhDSatWo=;
 b=MeqBMoC4F9qcDq7IGH4dxqPNUS18tMCPW4h9VJp1KMpn9FIuvFU/kIuZG0q4Az5bDEMF8c3y6+i8qb7t4Hc3YJKtp7tiJawnprONhaYHMhsjIbV3bnjd/4XtjN7nKIH0ZJ0wFBubMCod2nvUBwcc4pNNksRJFDUp5G0av0L5CRI=
Received: from BN9PR03CA0936.namprd03.prod.outlook.com (2603:10b6:408:108::11)
 by DM6PR12MB4436.namprd12.prod.outlook.com (2603:10b6:5:2a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.27; Mon, 28 Oct
 2024 05:35:17 +0000
Received: from BL6PEPF0001AB53.namprd02.prod.outlook.com
 (2603:10b6:408:108:cafe::15) by BN9PR03CA0936.outlook.office365.com
 (2603:10b6:408:108::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.28 via Frontend
 Transport; Mon, 28 Oct 2024 05:35:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB53.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8114.16 via Frontend Transport; Mon, 28 Oct 2024 05:35:16 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 28 Oct
 2024 00:35:12 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v14 02/13] x86/sev: Relocate SNP guest messaging routines to common code
Date: Mon, 28 Oct 2024 11:04:20 +0530
Message-ID: <20241028053431.3439593-3-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241028053431.3439593-1-nikunj@amd.com>
References: <20241028053431.3439593-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB53:EE_|DM6PR12MB4436:EE_
X-MS-Office365-Filtering-Correlation-Id: 511f1e36-f12d-49de-1875-08dcf7124de4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|7416014|376014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wE3TuORqziv9EFgMsDBt3gQE/eUGLU0nDrzLir9RuHbvkJ7ABOiSW03sRm7z?=
 =?us-ascii?Q?FtTt5TBeDr5QzNcibeidIn+MrB9IfyXsDYTvEXBNfcReytQ4Bp4ff1XKzSzF?=
 =?us-ascii?Q?MKn522vIhYEbJQUOeWCuNYvU5AQeHsmhAEyIcP9ZBBK3VWjFaMyq02nqstzk?=
 =?us-ascii?Q?3pwPcwRecBXBPULwz7kIpnQ3/qj4htElsHh7QntTDDnj648uQ5zz6SPpvgcC?=
 =?us-ascii?Q?OpihgZowOfrrf73OF0VT5M2nyy9gWumpbZ73DSkJR2S+kJMExrCwAxRQny+l?=
 =?us-ascii?Q?xW/WKqTyCcF3S3YdKWEFlh5T7wXcWNDNgf//1+r1QZWv2DahWaY/bvbpcOu0?=
 =?us-ascii?Q?+Z6jCtHoTg84iRd8ObJ8T3pXFBffpm7OokdjX+D6FqrYSx3GJUVueZYlzQ+B?=
 =?us-ascii?Q?pnSoI2o4piSBAZ2CnHV5KWjq0kkl2raV54J1V5dHe9Wqk8c08ZZyUBeaGUw1?=
 =?us-ascii?Q?jCxqx8MafKp3n5k0Y8Z/elJyeH/cCRC5k2hF0703DysorI5BmMomTMrinTve?=
 =?us-ascii?Q?c3w9N64y3ep69APqLPc8pDjuzyDWOD49786l2sZm1ejsK3b1KTQkNhrTMQj3?=
 =?us-ascii?Q?AioR2eA+kHUs2BMKC2xa4qqjkeL/QinBmOgy1PbAop0WmOWSMNi/UgJSba3j?=
 =?us-ascii?Q?QWlC+CeUVfxkBfbhW219Z4u/0duhLW2EpwK2VooltqN/2Ly/v1LUTKe+e3g0?=
 =?us-ascii?Q?SMZadT7B3Ld8iCfHejj0rYtXOpKBfiI2w4nizQDXl/NmOxnpEVmUmgC1LlZa?=
 =?us-ascii?Q?zEJLH4blal+PffclmJxPTKnlyq1/XNhjhnY9Xcx8cxHQklwfMgZDoGCY6Mn4?=
 =?us-ascii?Q?i6/SFRqbY0B53ubovZYINprGMlBRRjIiuR2vcbTUVXoIPZ5gdjch5nfA7V+j?=
 =?us-ascii?Q?lqKfcvGGVPuRx9maczWJiKSrqhh5bucOkOfrGT9O2WHs922hZ475prrBWBtG?=
 =?us-ascii?Q?kl+fmNeOYDj1qm6VgNfqCzsuvTwPcBhb7XzgjlQxkAVEKoHh44nMeLELB4pq?=
 =?us-ascii?Q?60VvddkynJWELCs8UQq+VGt/n1Eo6rSwpzzd4KqXJP/2dJCRUa4UdCsmRDhp?=
 =?us-ascii?Q?+gDO0LwnlUoxof+L+jYdZTb6TX4E639JX0T1l3GWQ4ZBObwxWOJjwWB4RMyy?=
 =?us-ascii?Q?PEDzdUjql3KT4uZglB4o88Grl3ZDmWOBbOMT3LOFERaaZKbfYu55FkCVRU3F?=
 =?us-ascii?Q?z/OVZJDiW5SLdKBOqJ0SmyP2NFXeC4gnksSnltmh3RDLLMCiWcvUy67No7GE?=
 =?us-ascii?Q?MgpgEOUkM6n9hIbbTXuTVCKanVf5IsQnZQF6Rkmzb3x2mSmI8oAHLtW2vjRW?=
 =?us-ascii?Q?O1JniyZLMXF8vj6zO1TiD+1eRyCJI9f11n6+PZkX1hc0/0ziS1NHCJi21FHL?=
 =?us-ascii?Q?/Pv6zvxEC8pqeeVQb0iCK7FPCya0HK8PdeJbA7b/98j1oiWgIQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(7416014)(376014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2024 05:35:16.7252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 511f1e36-f12d-49de-1875-08dcf7124de4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB53.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4436

At present, the SEV guest driver exclusively handles SNP guest messaging.
All routines for sending guest messages are embedded within the guest
driver. To support Secure TSC, SEV-SNP guests must communicate with the AMD
Security Processor during early boot. However, these guest messaging
functions are not accessible during early boot since they are currently
part of the guest driver.

Hence, relocate the core SNP guest messaging functions to SEV common code
and provide an API for sending SNP guest messages.

No functional change, but just an export symbol added for
sev_send_geust_message() and dropped the export symbol on
snp_issue_guest_request() and made it static.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              |  15 +-
 arch/x86/coco/sev/core.c                | 295 +++++++++++++++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.c | 292 -----------------------
 arch/x86/Kconfig                        |   1 +
 drivers/virt/coco/sev-guest/Kconfig     |   1 -
 5 files changed, 301 insertions(+), 303 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 63c30f4d44d7..2c542b9e8dbf 100644
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
@@ -427,8 +430,6 @@ void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __noreturn snp_abort(void);
 void snp_dmi_setup(void);
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio);
 int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
@@ -493,6 +494,9 @@ static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc)
 	kfree(mdesc->ctx);
 }
 
+int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio);
+
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
 #define snp_vmpl 0
@@ -515,11 +519,6 @@ static inline void snp_set_wakeup_secondary_cpu(void) { }
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
@@ -537,6 +536,8 @@ static inline int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id) { retur
 static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
 
 static inline void snp_msg_cleanup(struct snp_msg_desc *mdesc) { }
+static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
+					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 6ba13ae0b153..c96b742789c5 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2376,8 +2376,8 @@ int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
 }
 EXPORT_SYMBOL_GPL(snp_issue_svsm_attest_req);
 
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio)
+static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+				   struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2439,7 +2439,6 @@ int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *inpu
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(snp_issue_guest_request);
 
 static struct platform_device sev_guest_device = {
 	.name		= "sev-guest",
@@ -2653,3 +2652,293 @@ struct snp_msg_desc *snp_msg_alloc(void)
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(snp_msg_alloc);
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
+	if (is_vmpck_empty(mdesc)) {
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
+	memcpy(mdesc->request, &mdesc->secret_request,
+	       sizeof(mdesc->secret_request));
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
index 862fc74452ac..d64efc489686 100644
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
-	if (is_vmpck_empty(mdesc)) {
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
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2852fcd82cbd..6426b6d469a4 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1556,6 +1556,7 @@ config AMD_MEM_ENCRYPT
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


