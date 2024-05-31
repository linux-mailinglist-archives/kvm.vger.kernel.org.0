Return-Path: <kvm+bounces-18471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 63FF18D5963
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 06:32:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E06CE1F252E8
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 04:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD4EB7EEFF;
	Fri, 31 May 2024 04:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="YdtV2+ic"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE397E567;
	Fri, 31 May 2024 04:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717129898; cv=fail; b=oiwWg1WTki9tTD/7ChMDcqxDVDk7PW54salZc6WFlmZ3DC7tabu2x5uc5bCqQy7GYv6RQEnnGPHjvgIFyPcd4pM1VzM2E0fGl7Yonvkj4Erk6FmDsKYbb51dq9zg3V62DraqTXT5pwD1XyT5Qjh6Dl7nwlF2g6y+B92dgcHbJ0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717129898; c=relaxed/simple;
	bh=q2kWjEzjA+DFFztsKOcNuZwc737C3ZFSHARsEA35SQU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tc3qN9Lv/mRWftPxvbkDa4Rm73bHaLlfEnudoH4eDKRLPzRVlW/0f4Z1ZRJ+HTvQrPBmh5WZ8YQZ+G4JRRikWhFdL5YMA0p5AaPiffaX40WJHI9LXAYxQdzjxhJPZ0KJweH28aczSqnyhm4GdW5jcBRONNGoRf5RzFDLGiFn1mI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=YdtV2+ic; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N0Rg2u78Qs+Pdu9xHrDaM11wbY3APrwUy8iGYhTOlaTJS1seWyeEkr7Yju5rPc7zatyPwcurb9QZXB+RDrrdqvw8PMOZlmjITRUxgZDzDIWXZZIPhSsl51A5eFc0VanipYiBh7KUUkpyA2rC+gSQzaMGzLaY6vOlRl/0M2NLBD6URb3t7fnkUJyAYdkreu/AZCll0PdPjMDPiWDbGwS6VsaHX6k9PKE/vY71zV4XdBUKxUoCCbM7PA/AD4w2NRRQL7xz1VvgmgYzyfIc8wuQvniZ/gQcpOpvfkMeDfZZvM9dAC/NXIp+BiOyi+FwG+cA6vwVKkN5WnfWZ/F/tvOdYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nI/Y21S2btVbZW0tEO8bOp8UBMffd+nyqWoSmXb8jPA=;
 b=PvntYHBYb/djQKpg948EbTgbGSvp8up/fU6aAi4/qiAh/BwkQirmzV3VL6ECEnXock4RUMVuZaIV4Jp3LpbpTBXsU/26OptApJY0VjVDZkrQosn8gCtEcWfBMbFUxfYcqtCtt4EnfdXRGHrWCB5R9YOMC9bt7QiC+O5NQEaUP89rCzdwC8lki+v9PVXe1d5YeBwu2aIpaBvM4JU3JPOADuGGbGeJHbpmWdp4YNw78b1NXnqpcILhRvIFC2yeKxHrM26J/wsNemEXsw6gwXkAOi6JbRXDayIVVEnoHc7WhD2Vmg4ZDukMQ87lj49F3X+jxU7Of89DuA267+40VMLqdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nI/Y21S2btVbZW0tEO8bOp8UBMffd+nyqWoSmXb8jPA=;
 b=YdtV2+icvcb8NWOUdBojYVpzLhXcl7rSzwNTDkqW86whYGvzqpSoZzgnsHiDK5017OZuIYJCrAdjx1jY+9EcCDQZOTZuwjAuOi55fC3AwTI8Bd9dXKxnvbcmBHWL/Spjkcn9cvXY0PAi/qoPRIC8Pto4PNHxPhqpD1c5ZIR68LI=
Received: from SJ0PR03CA0129.namprd03.prod.outlook.com (2603:10b6:a03:33c::14)
 by IA1PR12MB9030.namprd12.prod.outlook.com (2603:10b6:208:3f2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.22; Fri, 31 May
 2024 04:31:32 +0000
Received: from SJ1PEPF00002327.namprd03.prod.outlook.com
 (2603:10b6:a03:33c:cafe::cb) by SJ0PR03CA0129.outlook.office365.com
 (2603:10b6:a03:33c::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.24 via Frontend
 Transport; Fri, 31 May 2024 04:31:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00002327.mail.protection.outlook.com (10.167.242.90) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7633.15 via Frontend Transport; Fri, 31 May 2024 04:31:32 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 30 May
 2024 23:31:27 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v9 03/24] virt: sev-guest: Make payload a variable length array
Date: Fri, 31 May 2024 10:00:17 +0530
Message-ID: <20240531043038.3370793-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240531043038.3370793-1-nikunj@amd.com>
References: <20240531043038.3370793-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002327:EE_|IA1PR12MB9030:EE_
X-MS-Office365-Filtering-Correlation-Id: a9e83b7f-3fd3-4598-492b-08dc812a8c46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|376005|1800799015|36860700004|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ZEgA+AcN+OYaBeivLlD6CQ4Vo4j1eEpJhAecgM8XTmLCcwBVkn1nEXreP+wD?=
 =?us-ascii?Q?skVem+xGYZ3IkVlTT+jT4mPSBfNKTXmM5mbgyLtCbJ2M4y3ejhTtpDA7GxwL?=
 =?us-ascii?Q?aIdsh6gHo8UGd84op0/v2H5NF5jOQiBsSKQMzY4lXgzjmjJlV9ypMtmU7hMn?=
 =?us-ascii?Q?6XG1kNgYrMMiuy1+qFyy29jneFcnng7367c/WJ3pF/vhNSXtLmNOjVIjBZa/?=
 =?us-ascii?Q?InwXkg11tgdYFAMfoeXGSuKCjZvlZ8tSKKmwsS6YKwwy5fZxL/ZCPDuCmgHD?=
 =?us-ascii?Q?cUVVW+U1nu0anHFrckjVr8v9SCKjscMc/bgo/RPnVnIDJcNVVynl7wUpjGNc?=
 =?us-ascii?Q?AxQdWGoGz+snSKu0oazAgNELdYR7lfWWBzZiwAni0A3xFfY0Q1JbzqpPESYV?=
 =?us-ascii?Q?6qSvJNOem/AdegWrTbNAwcR1TjjTktP6f7lSx1FMHsPgjT2qzWlM+zsz2/H7?=
 =?us-ascii?Q?AfvRnhHWNprHXPQfa/nIxHajDCLe1PWVGaHrHS480nR+UFFwFGl1yHjxoc4+?=
 =?us-ascii?Q?2aTESyW5Y7+x7b0gMrKvYzUeX536BxC3L9ydQ0RJLQHmNpEJ3WJ0hOFGU/W0?=
 =?us-ascii?Q?kPjpqXSfwN+cb/FbeoTHseyi9z5ozDNZzk5nLO28AmhGaIfUjlkD257WJ+K1?=
 =?us-ascii?Q?tOmG9Ny+57AAhjd6AcDGI3P4yyDQE5AsotX5qiS4J2kRuqT2w6qrIyZdyrR+?=
 =?us-ascii?Q?CjgKRAJ4ss+E01WVKJOnSBHhhfYRfyrNzkgJtEZXPb6OIIvtDRNgqe4zGSiy?=
 =?us-ascii?Q?yrwLAVS0Q/hXdVbJ4BVqAbRGKbsx9g5zQYncggKPIIDKF/NFxP1kXtPj5ka7?=
 =?us-ascii?Q?T0zxgbc8APsdp3Ivvd/JikpN3Lctjk5v5LN0Ijxs/aYDQFsPn/R3j/u/jVXZ?=
 =?us-ascii?Q?fIT0o4IDbcuSlMobVUqYmUMh7PPtg8GxBfAMjI5tEZWKAUSL1QU7G4oKPGni?=
 =?us-ascii?Q?r1p1sVtJH0V7kANo8lPGU8qb0OWhPS7SZiHVBB67txXnC9gGljF+OuyC5tIC?=
 =?us-ascii?Q?tvn1JV5SWXRP78SgjM/3V2yQDCxWUbakLGu2Cpi49GuWHKxOAV+308IaiAQW?=
 =?us-ascii?Q?aUYNxo6nDC+O+cRcuc0hQLg9Ufob6xL3m1Dly5rSevx7iv7DIOByBMlDlBFn?=
 =?us-ascii?Q?F9Jc6c48vqOmBOUxIHIbmcL3VBUXGjUMZRjH+yX/3cWJdcjszqmMxlj8IIdf?=
 =?us-ascii?Q?jOkQ2E+9CkMPlFEB20MEoD70gW2yU9iwOg1e0jECbZ/kcIG1bzUjC+PbSJdi?=
 =?us-ascii?Q?/tIAoDopbfV9GlY56CRhfKqSxMb8OwdOUsFD8fGDNDR84r5gNdawv45gsAMx?=
 =?us-ascii?Q?nT6jkwgHGm2TJhJ9dK3To2g9Wl5ex4LCv4N2LP8NNLSxto8asSEO+NvfmmI1?=
 =?us-ascii?Q?Orzy8Zu7VvXlkJSMfRp9CIy+Ce8u?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(376005)(1800799015)(36860700004)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2024 04:31:32.0544
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9e83b7f-3fd3-4598-492b-08dc812a8c46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002327.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9030

Currently, guest message is PAGE_SIZE bytes and payload is hard-coded to
4000 bytes, assuming snp_guest_msg_hdr structure as 96 bytes.

Remove the structure size assumption and hard-coding of payload size and
instead use variable length array.

While at it, rename the local guest message variables for clarity.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.h |  5 +-
 drivers/virt/coco/sev-guest/sev-guest.c | 74 +++++++++++++++----------
 2 files changed, 48 insertions(+), 31 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.h b/drivers/virt/coco/sev-guest/sev-guest.h
index ceb798a404d6..97796f658fd3 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.h
+++ b/drivers/virt/coco/sev-guest/sev-guest.h
@@ -60,7 +60,10 @@ struct snp_guest_msg_hdr {
 
 struct snp_guest_msg {
 	struct snp_guest_msg_hdr hdr;
-	u8 payload[4000];
+	u8 payload[];
 } __packed;
 
+#define SNP_GUEST_MSG_SIZE 4096
+#define SNP_GUEST_MSG_PAYLOAD_SIZE (SNP_GUEST_MSG_SIZE - sizeof(struct snp_guest_msg))
+
 #endif /* __VIRT_SEVGUEST_H__ */
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 7e1bf2056b47..69bd817239d8 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -48,7 +48,7 @@ struct snp_guest_dev {
 	 * Avoid information leakage by double-buffering shared messages
 	 * in fields that are in regular encrypted memory.
 	 */
-	struct snp_guest_msg secret_request, secret_response;
+	struct snp_guest_msg *secret_request, *secret_response;
 
 	struct snp_secrets_page *secrets;
 	struct snp_req_data input;
@@ -171,40 +171,40 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 
 static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
 {
-	struct snp_guest_msg *resp = &snp_dev->secret_response;
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
-	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
+	struct snp_guest_msg *resp_msg = snp_dev->secret_response;
+	struct snp_guest_msg *req_msg = snp_dev->secret_request;
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
+	memcpy(resp_msg, snp_dev->response, SNP_GUEST_MSG_SIZE);
 
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
+	if (unlikely((resp_msg_hdr->msg_sz + ctx->authsize) > sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
-	memcpy(iv, &resp_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_hdr->msg_seqno)));
-	if (!aesgcm_decrypt(ctx, payload, resp->payload, resp_hdr->msg_sz,
-			    &resp_hdr->algo, AAD_LEN, iv, resp_hdr->authtag))
+	memcpy(iv, &resp_msg_hdr->msg_seqno, min(sizeof(iv), sizeof(resp_msg_hdr->msg_seqno)));
+	if (!aesgcm_decrypt(ctx, payload, resp_msg->payload, resp_msg_hdr->msg_sz,
+			    &resp_msg_hdr->algo, AAD_LEN, iv, resp_msg_hdr->authtag))
 		return -EBADMSG;
 
 	return 0;
@@ -213,12 +213,12 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
 static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
 			void *payload, size_t sz)
 {
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *hdr = &req->hdr;
+	struct snp_guest_msg *msg = snp_dev->secret_request;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
 	struct aesgcm_ctx *ctx = snp_dev->ctx;
 	u8 iv[GCM_AES_IV_SIZE] = {};
 
-	memset(req, 0, sizeof(*req));
+	memset(msg, 0, SNP_GUEST_MSG_SIZE);
 
 	hdr->algo = SNP_AEAD_AES_256_GCM;
 	hdr->hdr_version = MSG_HDR_VER;
@@ -236,11 +236,11 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	if (WARN_ON((sz + ctx->authsize) > sizeof(req->payload)))
+	if (WARN_ON((sz + ctx->authsize) > SNP_GUEST_MSG_PAYLOAD_SIZE))
 		return -EBADMSG;
 
 	memcpy(iv, &hdr->msg_seqno, min(sizeof(iv), sizeof(hdr->msg_seqno)));
-	aesgcm_encrypt(ctx, req->payload, payload, sz, &hdr->algo, AAD_LEN,
+	aesgcm_encrypt(ctx, msg->payload, payload, sz, &hdr->algo, AAD_LEN,
 		       iv, hdr->authtag);
 
 	return 0;
@@ -346,7 +346,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		return -EIO;
 
 	/* Clear shared memory's response for the host to populate. */
-	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
+	memset(snp_dev->response, 0, SNP_GUEST_MSG_SIZE);
 
 	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
 	rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
@@ -357,8 +357,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * Write the fully encrypted request to the shared unencrypted
 	 * request page.
 	 */
-	memcpy(snp_dev->request, &snp_dev->secret_request,
-	       sizeof(snp_dev->secret_request));
+	memcpy(snp_dev->request, &snp_dev->secret_request, SNP_GUEST_MSG_SIZE);
 
 	rc = __handle_guest_request(snp_dev, exit_code, rio);
 	if (rc) {
@@ -842,12 +841,21 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	snp_dev->dev = dev;
 	snp_dev->secrets = secrets;
 
+	/* Allocate secret request and response message for double buffering */
+	snp_dev->secret_request = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
+	if (!snp_dev->secret_request)
+		goto e_unmap;
+
+	snp_dev->secret_response = kzalloc(SNP_GUEST_MSG_SIZE, GFP_KERNEL);
+	if (!snp_dev->secret_response)
+		goto e_free_secret_req;
+
 	/* Allocate the shared page used for the request and response message. */
-	snp_dev->request = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
+	snp_dev->request = alloc_shared_pages(dev, SNP_GUEST_MSG_SIZE);
 	if (!snp_dev->request)
-		goto e_unmap;
+		goto e_free_secret_resp;
 
-	snp_dev->response = alloc_shared_pages(dev, sizeof(struct snp_guest_msg));
+	snp_dev->response = alloc_shared_pages(dev, SNP_GUEST_MSG_SIZE);
 	if (!snp_dev->response)
 		goto e_free_request;
 
@@ -890,9 +898,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 e_free_cert_data:
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
 e_free_response:
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
+	free_shared_pages(snp_dev->response, SNP_GUEST_MSG_SIZE);
 e_free_request:
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+	free_shared_pages(snp_dev->request, SNP_GUEST_MSG_SIZE);
+e_free_secret_resp:
+	kfree(snp_dev->secret_response);
+e_free_secret_req:
+	kfree(snp_dev->secret_request);
 e_unmap:
 	iounmap(mapping);
 	return ret;
@@ -903,8 +915,10 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
 	struct snp_guest_dev *snp_dev = platform_get_drvdata(pdev);
 
 	free_shared_pages(snp_dev->certs_data, SEV_FW_BLOB_MAX_SIZE);
-	free_shared_pages(snp_dev->response, sizeof(struct snp_guest_msg));
-	free_shared_pages(snp_dev->request, sizeof(struct snp_guest_msg));
+	free_shared_pages(snp_dev->response, SNP_GUEST_MSG_SIZE);
+	free_shared_pages(snp_dev->request, SNP_GUEST_MSG_SIZE);
+	kfree(snp_dev->secret_response);
+	kfree(snp_dev->secret_request);
 	kfree(snp_dev->ctx);
 	misc_deregister(&snp_dev->misc);
 }
-- 
2.34.1


