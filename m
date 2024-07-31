Return-Path: <kvm+bounces-22780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BCD09432C9
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:11:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A8631F21B20
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:11:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A6B01B3F1A;
	Wed, 31 Jul 2024 15:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i59uVKuj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2071.outbound.protection.outlook.com [40.107.212.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C4A51CABF;
	Wed, 31 Jul 2024 15:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.71
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438546; cv=fail; b=h+ShjHegbenC368GYvy7XlUWs+c2FBbj+x1nmhfSR/ZtvFNozP0mwGSjfQ5Hf7ObYCExioD/LdHEPYR689HVucgQMZlMBR4yDG8f5r7hYIw6kvgxP2mS/Cp/GfOA/4n81vbOqXvJ5qXjM/bq4S9t31AptA3GAWX7MrqJ4WyP0SA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438546; c=relaxed/simple;
	bh=1WS+0PXaNSz2aeUzqscIh2sY1ep25VTIh92vKblhI00=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZgpHejmGdJmVPuXmSootc4aIamx9x+LIh+9VyvYOGdsY9DQc3hkDZ+esYh0xrGE45wiHRddyJqsquwMmE15vjvyz5LB3S/riGwz7FnRGMJ06+nltggJZyyU/Vns9ZTZ2Vr2O6u13MH4rmBHN5KoVNdSI1zBvQ15IyHoeQ+OHTo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i59uVKuj; arc=fail smtp.client-ip=40.107.212.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bgmn0L10O9iEFJ2NpKxbo7dWoaX2DGW/1yBoaSUJW7faFy8pKFKSB5wI0gt6T0CJWoAYuzg12uIuMULvDfNjfj3wPj+D0PDma45pIyLx1mzTrp/HlsjFsCT+xnZi/cuWzT9CQ9C9m4jGvYQQGIGXvKNVb0js1LtoVJzA9G4MqdBrNoAhCN88h+rFTyFLWpKFH+hK5JUlrmOoVTlN+w5bT8nQOckyTWzRxLCKuBPHk7NpfL141AAOafHM1N6UmRsC9Ly0XaLaRVxeCTG01B9B1V5C7qnBIRfwRAbGzwqL3nqWT1ZT2Q4t9GYPB0ydLAElImNvuIIXK002hU+bSXaqwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zzfL2xIRi73ARgskJwg0WWUbHDsEvovJpoqRTOe/fXU=;
 b=vjTsTNYuLwh2cAcHqVy5xI7XHyta72FcaAy+YB6QMLSys6hFt5G7wqT0SUDssAqxpk8tx++bxbeQi8+jUBkW55YAWlIp9/LtXJ5Yj65drdHM0Jy8irzjkXpZBunGdP63gDB6hgY/or+s8gaLCOlis6TFCHqe4c6BIGLQyELGJ2/zqx4SMH1kw2R7fC4PNxumWGqRMApQTiIXiHnWPcBr3N8bjcCVa1cPKglNQBIwsum0NkTFEgJQmHU9XTab3/ThYKSRLIG+bAfSUUGeXmBBCB+wY6nqf8Pzbpo7Qazn26fBUuBf43yE60BYqbc6kF9dog031Mlducum3x9YTyYCdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zzfL2xIRi73ARgskJwg0WWUbHDsEvovJpoqRTOe/fXU=;
 b=i59uVKujsy6nN2ek212cPLS4F67zj15LF8oB0wNBTtUaG/WUXJhXdqkv9YNBzZRkdNA0z8x63AzuArq3Q/zMwC/7DJvwp9Lk4ycd/XwDff/oAG7OAwSZuRV5jVmtJlqzdEtr1BLY3oi7I9pmdvk4RgPuIW0HJVW3HfrhPTVApRk=
Received: from CH0PR03CA0301.namprd03.prod.outlook.com (2603:10b6:610:118::11)
 by PH7PR12MB5758.namprd12.prod.outlook.com (2603:10b6:510:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.19; Wed, 31 Jul
 2024 15:09:00 +0000
Received: from DS3PEPF0000C381.namprd04.prod.outlook.com
 (2603:10b6:610:118:cafe::66) by CH0PR03CA0301.outlook.office365.com
 (2603:10b6:610:118::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.34 via Frontend
 Transport; Wed, 31 Jul 2024 15:08:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C381.mail.protection.outlook.com (10.167.23.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:08:59 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:55 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 08/20] virt: sev-guest: Consolidate SNP guest messaging parameters to a struct
Date: Wed, 31 Jul 2024 20:37:59 +0530
Message-ID: <20240731150811.156771-9-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240731150811.156771-1-nikunj@amd.com>
References: <20240731150811.156771-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C381:EE_|PH7PR12MB5758:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e9388f3-b99d-4fb6-e4f3-08dcb172b4be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?einwppbntHhdovf2ArFPvQuwVyTIciAIyEK6VLjRqiL6ZwMDlPKvhbgv2HLA?=
 =?us-ascii?Q?hcxuaGQuntuumERFE3+ekI4Imo6SmcNB+VCoTCLQFXD03EMM5xVu6nQtUFLR?=
 =?us-ascii?Q?6Sp+klHCfIxNx4X8Sn1Dqb0ZuGEFPiU51706OrarmOciR/e79md23MBfv2sW?=
 =?us-ascii?Q?BPv7Kji210e/W6j+QtwVCpw2Z08TJvKIABzOExO8rmAO8mESV7o7pHM1y4Y7?=
 =?us-ascii?Q?VjOf+ySsy5sQcQjYZh05RRP+EpGOKlYCZEhei9MpzCH1WiRr0DPSTyglurf9?=
 =?us-ascii?Q?MyIp8ZAXvIx1cz7LDSLuFfM+NsGyRcIeHBweqcnl4xTsQBAPsxehMaD0TEKN?=
 =?us-ascii?Q?QnJm44L2Cp360IbP33lsGyKoxwNpcCCYd+H9agGnb6c2atvNqTrvvoubZyNU?=
 =?us-ascii?Q?FYzfuptqos3mCH2mbtBw7y5PuwlKnjizgQfgAcJI1EZfw7sABluVVXoH7i3D?=
 =?us-ascii?Q?H2seMpfx/JZ1xFtwEnf4p1sBy+mo99sHtN72cGOTRZ6OSzUBmTevy/g/bDIo?=
 =?us-ascii?Q?eb5KH7BffjMMl/npk/gvXhbs+B0j3OlCgb55a05nIOwBU6zNlMEj+YCmGTNv?=
 =?us-ascii?Q?6il4DDy4rJ1jMqpp7QQt3dZiJ/g0xT4ewFfFPqVN1ZxypE+fH++JCdy0SZh+?=
 =?us-ascii?Q?eo2PAFtzEnXQ7/ND0uuzGf/8E5wpIFldR7QQ2oHKJzfH7tJKCMjGEwhgjSFA?=
 =?us-ascii?Q?tQlkho2D4r/unYPzx5+t/wcPjb33ujgKXxp0sFqu+WNTTavQRuN92rgznCHA?=
 =?us-ascii?Q?Rer4laaed66UiNUhSXyFXc2dIGrZ6Wu+HYiyxPDkyUCAqZUcztCgteBA950W?=
 =?us-ascii?Q?Kiz4DhOlFZuNWIKg1HET0cXmNEqokTyNw17G/g6X4klvQwdJrFNelaivLvZk?=
 =?us-ascii?Q?dZnQay3lxaLhcudeMZr23t23U/QXviYqlYp1NucdVVgjAZIweP9AtXsfIpAF?=
 =?us-ascii?Q?X9w9VD686KbFeeJl7uAMd2nGVpfL0t1E+z3zmQ3hK00wiFojoYRRF8GUxV0w?=
 =?us-ascii?Q?iDqSSO8upghIbXM6YqUKG/bJjTvqES2zvr6YWUaiAecIVqryxHNuLlT6XPo2?=
 =?us-ascii?Q?Ff0ewta55RBVG7lIEHPuC26kUVr/BQVT53aRk5l3E1nURgp5OPiTbZ/j3rxw?=
 =?us-ascii?Q?z0I+li6GYxEflOJL0sqgpMn5bCz20VcMYsqJY/Miw1P540b2pizE8FARqyYQ?=
 =?us-ascii?Q?PjWnxx03JHhxGgS6buKufF5huKkbgkjv1LsH8Jt+JHoGw9ENEvE/aKsapgfR?=
 =?us-ascii?Q?lYz4MVni4ZsKsOlK3mje4wQxjAv+0D6GuJlz0VbxZ9jlQqNSosWyKoHuPm83?=
 =?us-ascii?Q?uiot23E9y6rXfShRf/iATn42wWe7OlpUyBB4howyHh5pGbNt/2j5UC9VBeWa?=
 =?us-ascii?Q?h9nZ1hbh8qPOnH/xvZbot7SEPeOL2Wg7oKpI5uZPikhzxyil3Zt0z+7UxHfM?=
 =?us-ascii?Q?npTaCgIHSvz7kA25CuF41NbnZ4lHFmQM?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:08:59.5471
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e9388f3-b99d-4fb6-e4f3-08dcb172b4be
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C381.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5758

Add a snp_guest_req structure to eliminate the need to pass a long list of
parameters. This structure will be used to call the SNP Guest message
request API, simplifying the function arguments.

Update the snp_issue_guest_request() prototype to include the new guest
request structure.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/sev.h              | 19 +++++++-
 arch/x86/coco/sev/core.c                |  9 ++--
 drivers/virt/coco/sev-guest/sev-guest.c | 62 ++++++++++++++++---------
 3 files changed, 61 insertions(+), 29 deletions(-)

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
index a0b64cfd4b8e..e6a3f3df4637 100644
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
index 39d90dd0b012..92734a2345a6 100644
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
@@ -392,6 +389,25 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	return 0;
 }
 
+static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+				struct snp_guest_request_ioctl *rio, u8 type,
+				void *req_buf, size_t req_sz, void *resp_buf,
+				u32 resp_sz)
+{
+	struct snp_guest_req req = {
+		.msg_version	= rio->msg_version,
+		.msg_type	= type,
+		.vmpck_id	= vmpck_id,
+		.req_buf	= req_buf,
+		.req_sz		= req_sz,
+		.resp_buf	= resp_buf,
+		.resp_sz	= resp_sz,
+		.exit_code	= exit_code,
+	};
+
+	return snp_send_guest_request(snp_dev, &req, rio);
+}
+
 struct snp_req_resp {
 	sockptr_t req_data;
 	sockptr_t resp_data;
@@ -1058,7 +1074,7 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	misc->name = DEVICE_NAME;
 	misc->fops = &snp_guest_fops;
 
-	/* initial the input address for guest request */
+	/* Initialize the input addresses for guest request */
 	snp_dev->input.req_gpa = __pa(snp_dev->request);
 	snp_dev->input.resp_gpa = __pa(snp_dev->response);
 	snp_dev->input.data_gpa = __pa(snp_dev->certs_data);
-- 
2.34.1


