Return-Path: <kvm+bounces-32900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C2EF19E168E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 10:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 827D7285B80
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 09:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0E81DF976;
	Tue,  3 Dec 2024 09:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="a4lxIPlu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A44C1DEFF6;
	Tue,  3 Dec 2024 09:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733216490; cv=fail; b=JLGVSuhy/nmsZYgkSx96EhD3FxY/GYMB7Pu5jxbnq/FOJq1z5w2WedjsnPRH+SHGLd62IctthFmZQfi48WXDNOlAnLGOAcNzgdFbLvZP0+a+Dex7R0b2694WO3dAE3bWyuxS/ve4IFuGW3V+4mI8Sq0Mj5Mz+yXBXjKHZLE6B3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733216490; c=relaxed/simple;
	bh=eLog3o8vSBxUEAKEkvPNMlFe3ZhkGPS/y+UsBOYQQE8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hafFsStZeVtJgj2mEp9dZTdw6/e2D4eDxlrE+jtzBf53dfom8dfEDInEXVdx3+bJIBYjv4m3cwFS076vvPtqXljBhOxTgyb1B/jjqe0IOjqvKkmPEi7T0khVFY1igi1MUch6XBezlYaLoyVUVlrzBnKHoGcQt8dae01l65VqAnc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=a4lxIPlu; arc=fail smtp.client-ip=40.107.94.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QG2kdnEjqFoytAskyQeuzS2SucxhU+inbnN25NIsCOkWecgh4ifFpejnN9uEBHMqZH2CjfOab83CRKXt0cqBR0rrJGB3BVzmlAgs7E/k8BQLy3iEsbnj7rMLMXwlBa58gF3KNKtEu2TIbNTHy8MmEU/9zg1ozbuhqsP1Yf5QT5trESxgw1D99141j1xvUBAOJuhTm/OGaLUq8M+oPApaE/L8grjsmV20+YxbkTXIUjevdlKZU23GvwpPgZVVL+5+L+KJZo7AuBmH47jakqjFpqbOLnVLK/218u2LnmudY1/KGcGZYFrklHKGVzqG4Ge3mHZ6xI6fbrJaGuL3nOlngg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gX+/9Xiqg7oUVKQmndZaU4wqVbeedgI/ega53R01FuI=;
 b=e+DhDqqcKUfzzi7ovj8zhzxUFRtAu0cGjJzAdpg+lfRCfbjP1SX7dTY1SDWxWuAGfxyLEsbu84Vj01h/diRKoOuiFKE9XFY0ABdZ4yv4wWCOi6ne/Uf6yzPUX/g7hKEI5YNT9Ksk/AXVq/Nq2ecZkO8gbfaXswUfq2v5GUOJD+aM52Udoql9hC6uW9eBWGkYrZUNCgFs8ydz/LOZtx31zHNkRGuB78XuONL9E/1QGCcQv+uG/2rPE7metCXW+P5jDywHwSrWvu4yhQM5OLx/Rr0/zrfpJJdLSUYuSRRSBqrLaiU//6Sjg594to4cbxtjKof2y2ptlXRrtQgULEPrBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gX+/9Xiqg7oUVKQmndZaU4wqVbeedgI/ega53R01FuI=;
 b=a4lxIPluJwUb7rV/tvozRnIu3c9zcmLexeSsn89p1PslsMHg7ePRUWbLbGq0WcWFBuvpZI3zkiatSFeAEKIQ4h8HUWhyx4pa7hQ4gp3mtLPqTtcD1IezTgmCnRcwUqaDzOab/ilNaEgxvIxOMSdLPCckST4iqFgsW5ozQlFXd60=
Received: from CH2PR16CA0002.namprd16.prod.outlook.com (2603:10b6:610:50::12)
 by MW3PR12MB4412.namprd12.prod.outlook.com (2603:10b6:303:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.19; Tue, 3 Dec
 2024 09:01:17 +0000
Received: from CH1PEPF0000A34C.namprd04.prod.outlook.com
 (2603:10b6:610:50:cafe::bb) by CH2PR16CA0002.outlook.office365.com
 (2603:10b6:610:50::12) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8207.18 via Frontend Transport; Tue,
 3 Dec 2024 09:01:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34C.mail.protection.outlook.com (10.167.244.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8230.7 via Frontend Transport; Tue, 3 Dec 2024 09:01:16 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Tue, 3 Dec
 2024 03:01:12 -0600
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v15 02/13] x86/sev: Relocate SNP guest messaging routines to common code
Date: Tue, 3 Dec 2024 14:30:34 +0530
Message-ID: <20241203090045.942078-3-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34C:EE_|MW3PR12MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: ef4f31f3-c9a8-4179-3873-08dd13790bf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|36860700013|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FGa1sSWPimQE/NC3HktIBr5vBY+rEe5k9PYBAir/K9GBmJW6g42SgPysSOYY?=
 =?us-ascii?Q?FwQF6jM1ruQ+sagCNjnHGHj4kYPDlxhLSSRDRHZuQpXwO9Q/i5wvOuDfBoUY?=
 =?us-ascii?Q?StHh8UCdyZMjWWflW+afsQaj+ut5/+QVxste5mNGjGN+SuI9ZBRS4FD0c9Vv?=
 =?us-ascii?Q?dffM52fwY5qaqzBDgeFeJSzhyxW2eHOuiyO9lFiIQ9PXAuARNOjt1psNFr/A?=
 =?us-ascii?Q?FuLzx2iyu2cmOZvD7KXG1U7SOreJ4QsWTr6OhZJkivIGUvM4MeK9nzkLI+3x?=
 =?us-ascii?Q?xrh6/S1MCSIMa8snYcGmjAQffxHwySbXPFNqfrqSgdc4h4F8tf1I0YfITV33?=
 =?us-ascii?Q?SKR2Cd/Kr3c3xAf9Asot6yCh2Nu6ZHn8g65JpHWGC/oSWTsd0UZnTJa41eC6?=
 =?us-ascii?Q?KMsd+EM9q19Cq+1zPJ3U+UrILe0LoEBVpASQQy/YGb+9R8bFdl505i1tAitb?=
 =?us-ascii?Q?DkD/hqye8KyG4nsAkOT+IavWsLcAmqQUBC+ZxHarpdQGe8QcCRQBqdKXvmWs?=
 =?us-ascii?Q?R74YwxYtgwXAvI0G4Mm+IwCg2O+ZBx1cMLs+P3qmBRx7mDaAbKiQBmb6G9HI?=
 =?us-ascii?Q?RyhFCnnsQO9ce9lKW9yIqkUTierpUiZOnqgr7JvZD9jnT/vY2t0LBAcinouc?=
 =?us-ascii?Q?OTmZzyK/t85jTkbiLtxHRpvYx43FOOErfFx2QzzUTTrqyfUFDf8Owgr90N3k?=
 =?us-ascii?Q?yhZipMTAMucWk8Fv2zQ5Pg66YxuXE9Q2pwimveLOO9tgs8+6gxzsIfizUBGn?=
 =?us-ascii?Q?gXA6jhi44UZUIJtAiYHxMHYCrMVjtgi58ZfFANEub5pq1pbZkX+zc8QXAJWc?=
 =?us-ascii?Q?Is1M25K7zSPr3NKXLXYxQND48NyOjUNhRroibmax51qHIQHLp6+LAXxrjixd?=
 =?us-ascii?Q?4LyFlB7mM+W9o5Fy+s31Azc9RHtTTjvw8PjfjHjxf+bXi9T/8gBQQs1LRHZi?=
 =?us-ascii?Q?UTukUyUxUwCjJrh28DBSHemQ7zoLTZMiohTE/v8PFsW8j89DnqqkspP3l7qy?=
 =?us-ascii?Q?bC5upv25YsiNOcFumqYe5x1p8wpzOV/SD9d0i9t6j90AW/IMvej0IWmCZmif?=
 =?us-ascii?Q?Ixq4Mrb3Rv98VM7gelLgsuDaYcbl9q+1HvXnA4C0mMaxB7nGD5lWubcsquOR?=
 =?us-ascii?Q?Hvyb/UTurDtS7s3p300o4eGgBoPJB05GgotD4AHWImqVWLPcJRK+q2+m6uCj?=
 =?us-ascii?Q?G4JIebWoREJW2rB5C9SJqeVnoom7fH0JCAbJ8XCc5ZYG3olzinHGY6mMAhdz?=
 =?us-ascii?Q?1nI9afdlmjsa4f3103htsfpHNlFZZcEaAlftW50sETFJuzHAbt3oeGNpdF5N?=
 =?us-ascii?Q?2SjTtFtbhM4L/6h7ToPSdIOMWvS06nRaW5J8pNcRz+AmdJX8jw4pKtXmmvkT?=
 =?us-ascii?Q?zpDVneVBjziAOJS797jJd5hEjJF+JevZgUekL9RyonIZeZoQZXCci1HSXjjS?=
 =?us-ascii?Q?FSH2vcjo88WSJ3XLXmrAg4ScSpoPQ3fZ?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(36860700013)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Dec 2024 09:01:16.8287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef4f31f3-c9a8-4179-3873-08dd13790bf5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34C.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4412

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
 arch/x86/coco/sev/core.c                | 295 +++++++++++++++++++++++-
 drivers/virt/coco/sev-guest/sev-guest.c | 292 -----------------------
 3 files changed, 299 insertions(+), 302 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index f78c94e29c74..53f3048f484e 100644
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
@@ -469,6 +470,8 @@ static inline bool snp_is_vmpck_empty(struct snp_msg_desc *mdesc)
 int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id);
 struct snp_msg_desc *snp_msg_alloc(void);
 void snp_msg_free(struct snp_msg_desc *mdesc);
+int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
+			   struct snp_guest_request_ioctl *rio);
 
 #else	/* !CONFIG_AMD_MEM_ENCRYPT */
 
@@ -492,11 +495,6 @@ static inline void snp_set_wakeup_secondary_cpu(void) { }
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
@@ -514,6 +512,8 @@ static inline bool snp_is_vmpck_empty(struct snp_msg_desc *mdesc) { return false
 static inline int snp_msg_init(struct snp_msg_desc *mdesc, int vmpck_id) { return -1; }
 static inline struct snp_msg_desc *snp_msg_alloc(void) { return NULL; }
 static inline void snp_msg_free(struct snp_msg_desc *mdesc) { }
+static inline int snp_send_guest_request(struct snp_msg_desc *mdesc, struct snp_guest_req *req,
+					 struct snp_guest_request_ioctl *rio) { return -ENODEV; }
 
 #endif	/* CONFIG_AMD_MEM_ENCRYPT */
 
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 3cc741eefd06..a61898c7f114 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2509,8 +2509,8 @@ int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
 }
 EXPORT_SYMBOL_GPL(snp_issue_svsm_attest_req);
 
-int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
-			    struct snp_guest_request_ioctl *rio)
+static int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+				   struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2572,7 +2572,6 @@ int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *inpu
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(snp_issue_guest_request);
 
 static struct platform_device sev_guest_device = {
 	.name		= "sev-guest",
@@ -2838,3 +2837,293 @@ void snp_msg_free(struct snp_msg_desc *mdesc)
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
+	if (snp_is_vmpck_empty(mdesc)) {
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
+
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 5268511bc9b8..08706229e410 100644
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
-	if (snp_is_vmpck_empty(mdesc)) {
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


