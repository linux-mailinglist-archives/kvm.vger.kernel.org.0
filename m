Return-Path: <kvm+bounces-28205-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E5E80996562
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 11:30:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 412B0B2361C
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 09:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B501018EFF6;
	Wed,  9 Oct 2024 09:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="JYr3+w+P"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44D518E75F;
	Wed,  9 Oct 2024 09:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728466170; cv=fail; b=t+g/Kz0d60oNE/wfG0n5G1h10Z5bnW9e6IUzgVfl70AniCr+3SbzRLqwAqswBjGrj3KcmPoP8XaCdoce4EivGXmmEvZ5ro3k53od7bwJVWemW6MCElAcoOGqTGBO23xJniXiEzGEMk6ilUl2YX15rOu40EhK+ExsjzDMryeeqxs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728466170; c=relaxed/simple;
	bh=6g/dWL2kPRS4YcNAGWc5ZX5rWQWDb+DYofTAKO1x0MU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=vEHCbfkuztUEEwAS+lczuHM0l8S8RACqaTLj7e014iprscz7hNDBrHLeqfkS8hr/YylQq/MAu/DgIMHfd9euIfklG/rMVGt/ODKuQnzhWw6fQB3WFVoh/Z9kb8lZuRzyxVH4hF8rtmHuODXP0L/5AcHPH3WDI+6GDgkFr45G7eg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=JYr3+w+P; arc=fail smtp.client-ip=40.107.92.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QjOxrhXRRp2hRof1+TH5KIXs9o6fQRZJxnv4zpuq6CQKnt2vycH3GctqVLHFvWGwGHLzx2t6V+IbOQWquifhwS+6vFb/IEL9e28HezX64jXsxcCbvT/iXeLf3DG9lkVzkFNCp0CiBi1tHXJZNIVqCTzH4oCjsm2bvhwMG61WJtHqoAvLJnHAWiZKnzG8pyvhq8/9qkX/7yQ5yBKKtaE1tCXX5aNA2/gghfhGWrqz4H/JoRFP9NXJr5PrtGZVw5UB8itKt/5HIoA4vmJ4jxGQqHdlLsvpEix32mo7DR0N4H2q+J4YBT9Y47evTdWM3UDy7QX6dFPcQmmEdwKhEHS1rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cRu+bF09kp2DIEK4pQB0SZAwGukPN/Lvg7ZHWM2cycw=;
 b=zI5UKu2Jusjam07IgOjn5GqgX3wvBgXRP6/ZCNXTJIFVdtQw87kYbMtsDJsXiA0XV3nzJHxYSO+8NRgfwALInl91DoT6G5Kt66ti76ai4Y1N4ef5+bMRZ6XHvfNREoYxFF6Cj4p7/tGCEQzIqgD/3wWgNEM/tIOFKBqHWb9My/ugHsfhXY2Yt3mJboZ7cFVJwCGq+0GEiV1rphOzZBWdxF9ACsRChrWGRvhi7Lkb9xiGZMN3B8etyyykmqbFcTrRVn7/rZqlAI82xxdKZBW37zJrNeKyis4Sv2acrg2XK1p/4Tgv4fsU0r3uiYXtGKHJ67GmHJ7c/Y+xbZ11b8aWkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cRu+bF09kp2DIEK4pQB0SZAwGukPN/Lvg7ZHWM2cycw=;
 b=JYr3+w+PELzP4e2qau0ABUd8dDS338nomAEeR5C5XJ4n/WZsIl/57grrVekrEasvfQsabCS3YqP5fpkTlaKfp0BkWVCvCIVYsgLu1izwLPT2fMQcPtbo+q+Xg56gxlGvUYYcNlCzFW6CVp36Kt9C/37/8kUMHdMIrP59aA2V6hI=
Received: from BN9PR03CA0109.namprd03.prod.outlook.com (2603:10b6:408:fd::24)
 by SN7PR12MB6887.namprd12.prod.outlook.com (2603:10b6:806:261::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.16; Wed, 9 Oct
 2024 09:29:25 +0000
Received: from BL02EPF00021F6E.namprd02.prod.outlook.com
 (2603:10b6:408:fd:cafe::71) by BN9PR03CA0109.outlook.office365.com
 (2603:10b6:408:fd::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8048.18 via Frontend
 Transport; Wed, 9 Oct 2024 09:29:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF00021F6E.mail.protection.outlook.com (10.167.249.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8048.13 via Frontend Transport; Wed, 9 Oct 2024 09:29:25 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 9 Oct
 2024 04:29:21 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v12 04/19] virt: sev-guest: Consolidate SNP guest messaging parameters to a struct
Date: Wed, 9 Oct 2024 14:58:35 +0530
Message-ID: <20241009092850.197575-5-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241009092850.197575-1-nikunj@amd.com>
References: <20241009092850.197575-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF00021F6E:EE_|SN7PR12MB6887:EE_
X-MS-Office365-Filtering-Correlation-Id: ab4d0735-e3d3-46fd-2ccd-08dce844dd96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|36860700013|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GuxN8Ozxx/ksH4qQbuc/A95J6BEux6wiZ1FYBO6F4s+HS2pTAnzEbfhU9LRX?=
 =?us-ascii?Q?3s4qif4usjVk5vnHPnf4Jabn5btQxnG/g1deZthpSe4GgqyBFJriiNq51nXd?=
 =?us-ascii?Q?YwcutE1JXa9dlecwjF5MfB7ZRjfK/Q5HkhIeSny3+RJWpO+7WyQqn6FrrFqH?=
 =?us-ascii?Q?Y2ZcvbXg5/IG3diMEjWeSZXs9fLZwUaj4IszMHRITKFPAdNlyMw0+qV12TGj?=
 =?us-ascii?Q?SWaHOpNJ9P2VmVecYL/A5clmu7pL46eUqg0dBKll661idDsE6Jf+RcL56q2q?=
 =?us-ascii?Q?VHkzCSLEztcy3rq1s+bhmSYUYB1MytgJ1yjd3ZDJBsmD3KBjp2LW3/JdDam9?=
 =?us-ascii?Q?qwe/UocqO00lW7hITK8Gy1gQr9QeCK6OIKA6e5HXS32RuUhg2CTB2q4OQaNm?=
 =?us-ascii?Q?qI+hLBu4HUrd9whhco1FgVR3boGPtUS5l+oZT1fkchKpbbUCW4Nk8Q7KU9Jp?=
 =?us-ascii?Q?CZeILe5BJoF8kg5htrvuWMzwkzkQpRaU2z/a/gxcXXddyKC/nQO6DCWZcoRo?=
 =?us-ascii?Q?h19NSr0lp2Y23mWbxY0INh5P34bGuyi0Ift9OgA7v06gvXO4lFKIIq0JnijU?=
 =?us-ascii?Q?5YXBsFssdT8jMRE6VkRdMPJy3xC/vYv/ISpKjDomP0btr18lTaXqpJ8u851Y?=
 =?us-ascii?Q?6Oc+j27Q8V49fDp+FpnbgUKa5FCVfI+jlBAG4yIK4vkgpO3Dx+qd5LGGh7Cw?=
 =?us-ascii?Q?FYmUo9cW1LUPAfLJZr/riMsMawmz3P/XjHoiBQe/YXR+XsIhV6O3wcgp8/DH?=
 =?us-ascii?Q?4OU8zXjPkLKPYK1r6v0R9Bh1Zg31og9y/U/DRMsD7iaNgcWXE7mHRJLW4CO6?=
 =?us-ascii?Q?af1O43kTFIFoQNVtGlCxnYZ2U2VILJ2CijYkIrqQt7TnrhOnyEE2nMYQ2XhD?=
 =?us-ascii?Q?EC3Ztfj/H+orMk1O21ENFbv2yioV95+t7zPzYd+JpA+vhiYL1HqYBAMo1XJC?=
 =?us-ascii?Q?phkabFS1iJe58sqtni3+jPKiShy1zXPdowfKpYB5+4hlmvWo2vbpZz7hQZB5?=
 =?us-ascii?Q?QbW3ZAlV+vtgSYV0P4kyTmxS6GZCNWjq3H8xnJRziYvzMioo6r9S67qiPf06?=
 =?us-ascii?Q?R7qQS9JkLejtfCHoxmOrrM9D2aFvXz0wA9mT8GG5ZE4NuhaKoes/OEKvgBh2?=
 =?us-ascii?Q?L3pSWtF0kMJZKH9gm6gDigsYuyLWqO5Gje8P2jywa7yR5kGAlgGqekZXzGOf?=
 =?us-ascii?Q?OaAG1yaCMU5cIwobEsrET4+nQ6/RgcaKKeMMWcxKvFZ3VFBDKaBi0or+/22m?=
 =?us-ascii?Q?G1JAX9tDIR1u2FWyk1LWdE5xwO1kTmIHEJ3M4zGIQAJ4Z7FOr25A4ErSA/iu?=
 =?us-ascii?Q?hXu3STmNtyyTR014IQKfPi/WXZ2qZhAGupTd+oJ2CAGLcs9X3Nhemgkir4Cd?=
 =?us-ascii?Q?ZJZ6M8qiRgjJ5ImzsAfXGprp9u9A?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(7416014)(36860700013)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Oct 2024 09:29:25.2169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ab4d0735-e3d3-46fd-2ccd-08dce844dd96
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL02EPF00021F6E.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6887

Add a snp_guest_req structure to eliminate the need to pass a long list of
parameters. This structure will be used to call the SNP Guest message
request API, simplifying the function arguments.

Update the snp_issue_guest_request() prototype to include the new guest
request structure.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              | 19 +++++-
 arch/x86/coco/sev/core.c                |  9 +--
 drivers/virt/coco/sev-guest/sev-guest.c | 84 ++++++++++++++++---------
 3 files changed, 76 insertions(+), 36 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index e7977f76d77e..27fa1c9c3465 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -174,6 +174,19 @@ struct sev_guest_platform_data {
 	u64 secrets_gpa;
 };
 
+struct snp_guest_req {
+	void *req_buf;
+	size_t req_sz;
+
+	void *resp_buf;
+	size_t resp_sz;
+
+	u64 exit_code;
+	unsigned int vmpck_id;
+	u8 msg_version;
+	u8 msg_type;
+};
+
 /*
  * The secrets page contains 96-bytes of reserved field that can be used by
  * the guest OS. The guest OS uses the area to save the message sequence
@@ -395,7 +408,8 @@ void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __noreturn snp_abort(void);
 void snp_dmi_setup(void);
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio);
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio);
 int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call, struct svsm_attest_call *input);
 void snp_accept_memory(phys_addr_t start, phys_addr_t end);
 u64 snp_get_unsupported_features(u64 status);
@@ -425,7 +439,8 @@ static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
 static inline void snp_dmi_setup(void) { }
-static inline int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+static inline int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+					  struct snp_guest_request_ioctl *rio)
 {
 	return -ENOTTY;
 }
diff --git a/arch/x86/coco/sev/core.c b/arch/x86/coco/sev/core.c
index 1b0facfe658b..f40a2df38a84 100644
--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -2417,7 +2417,8 @@ int snp_issue_svsm_attest_req(u64 call_id, struct svsm_call *call,
 }
 EXPORT_SYMBOL_GPL(snp_issue_svsm_attest_req);
 
-int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct snp_guest_request_ioctl *rio)
+int snp_issue_guest_request(struct snp_guest_req *req, struct snp_req_data *input,
+			    struct snp_guest_request_ioctl *rio)
 {
 	struct ghcb_state state;
 	struct es_em_ctxt ctxt;
@@ -2441,12 +2442,12 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 
 	vc_ghcb_invalidate(ghcb);
 
-	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+	if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
 		ghcb_set_rax(ghcb, input->data_gpa);
 		ghcb_set_rbx(ghcb, input->data_npages);
 	}
 
-	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, exit_code, input->req_gpa, input->resp_gpa);
+	ret = sev_es_ghcb_hv_call(ghcb, &ctxt, req->exit_code, input->req_gpa, input->resp_gpa);
 	if (ret)
 		goto e_put;
 
@@ -2461,7 +2462,7 @@ int snp_issue_guest_request(u64 exit_code, struct snp_req_data *input, struct sn
 
 	case SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN):
 		/* Number of expected pages are returned in RBX */
-		if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
+		if (req->exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST) {
 			input->data_npages = ghcb_get_rbx(ghcb);
 			ret = -ENOSPC;
 			break;
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index a33daff516ed..2a1b542168b1 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -177,7 +177,7 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 	return ctx;
 }
 
-static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
+static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_req *req)
 {
 	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
 	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
@@ -206,20 +206,19 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 	 * If the message size is greater than our buffer length then return
 	 * an error.
 	 */
-	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > sz))
+	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > req->resp_sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
 	memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
-	if (!aesgcm_decrypt(ctx, payload, resp_msg->payload, resp_msg_hdr->msg_sz,
+	if (!aesgcm_decrypt(ctx, req->resp_buf, resp_msg->payload, resp_msg_hdr->msg_sz,
 			    &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
 		return -EBADMSG;
 
 	return 0;
 }
 
-static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
-			void *payload, size_t sz)
+static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, struct snp_guest_req *req)
 {
 	struct snp_guest_msg *msg = &snp_dev->secret_request;
 	struct snp_guest_msg_hdr *hdr = &msg->hdr;
@@ -231,11 +230,11 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
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
@@ -244,17 +243,17 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	if (WARN_ON((sz + ctx->authsize) > sizeof(msg->payload)))
+	if (WARN_ON((req->req_sz + ctx->authsize) > sizeof(msg->payload)))
 		return -EBADMSG;
 
 	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
-	aesgcm_encrypt(ctx, msg->payload, payload, sz, &hdr->algo, AAD_LEN,
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
@@ -269,7 +268,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * sequence number must be incremented or the VMPCK must be deleted to
 	 * prevent reuse of the IV.
 	 */
-	rc = snp_issue_guest_request(exit_code, &snp_dev->input, rio);
+	rc = snp_issue_guest_request(req, &snp_dev->input, rio);
 	switch (rc) {
 	case -ENOSPC:
 		/*
@@ -280,7 +279,7 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		 * IV reuse.
 		 */
 		override_npages = snp_dev->input.data_npages;
-		exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
+		req->exit_code	= SVM_VMGEXIT_GUEST_REQUEST;
 
 		/*
 		 * Override the error to inform callers the given extended
@@ -340,10 +339,8 @@ static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
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
@@ -357,7 +354,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
 
 	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
-	rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
+	rc = enc_payload(snp_dev, seqno, req);
 	if (rc)
 		return rc;
 
@@ -368,7 +365,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	memcpy(snp_dev->request, &snp_dev->secret_request,
 	       sizeof(snp_dev->secret_request));
 
-	rc = __handle_guest_request(snp_dev, exit_code, rio);
+	rc = __handle_guest_request(snp_dev, req, rio);
 	if (rc) {
 		if (rc == -EIO &&
 		    rio->exitinfo2 == SNP_GUEST_VMM_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN))
@@ -382,7 +379,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		return rc;
 	}
 
-	rc = verify_and_dec_payload(snp_dev, resp_buf, resp_sz);
+	rc = verify_and_dec_payload(snp_dev, req);
 	if (rc) {
 		dev_alert(snp_dev->dev, "Detected unexpected decode failure from ASP. rc: %d\n", rc);
 		snp_disable_vmpck(snp_dev);
@@ -401,6 +398,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 {
 	struct snp_report_req *report_req = &snp_dev->req.report;
 	struct snp_report_resp *report_resp;
+	struct snp_guest_req req = {};
 	int rc, resp_len;
 
 	lockdep_assert_held(&snp_cmd_mutex);
@@ -421,8 +419,16 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	if (!report_resp)
 		return -ENOMEM;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
-				  report_req, sizeof(*report_req), report_resp->data, resp_len);
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
 
@@ -438,6 +444,7 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 {
 	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
 	struct snp_derived_key_resp derived_key_resp = {0};
+	struct snp_guest_req req = {};
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
@@ -460,8 +467,16 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 			   sizeof(*derived_key_req)))
 		return -EFAULT;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_KEY_REQ,
-				  derived_key_req, sizeof(*derived_key_req), buf, resp_len);
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
 
@@ -482,6 +497,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 {
 	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
 	struct snp_report_resp *report_resp;
+	struct snp_guest_req req = {};
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
 
@@ -529,9 +545,17 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 		return -ENOMEM;
 
 	snp_dev->input.data_npages = npages;
-	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
-				   &report_req->data, sizeof(report_req->data),
-				   report_resp->data, resp_len);
+
+	req.msg_version = arg->msg_version;
+	req.msg_type = SNP_MSG_REPORT_REQ;
+	req.vmpck_id = vmpck_id;
+	req.req_buf = &report_req->data;
+	req.req_sz = sizeof(report_req->data);
+	req.resp_buf = report_resp->data;
+	req.resp_sz = resp_len;
+	req.exit_code = SVM_VMGEXIT_EXT_GUEST_REQUEST;
+
+	ret = snp_send_guest_request(snp_dev, &req, arg);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
@@ -1057,7 +1081,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	misc->name = DEVICE_NAME;
 	misc->fops = &snp_guest_fops;
 
-	/* initial the input address for guest request */
+	/* Initialize the input addresses for guest request */
 	snp_dev->input.req_gpa = __pa(snp_dev->request);
 	snp_dev->input.resp_gpa = __pa(snp_dev->response);
 	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
-- 
2.34.1


