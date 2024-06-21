Return-Path: <kvm+bounces-20250-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F3489125AD
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 14:41:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 954721F24773
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F163015B13F;
	Fri, 21 Jun 2024 12:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AWPJ5RWq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2063.outbound.protection.outlook.com [40.107.92.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAD115A84D;
	Fri, 21 Jun 2024 12:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.63
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973583; cv=fail; b=YFxjja5Y2qDMe8RIKwBbFkB1Sm4t3B0lwTYHwDrh1yq4zG7o01RZgkHcWKfR0LWk6m4OcwMyDyakJN9dxib9gW7H1z8ISbcaS6BhcT6EMroe8WLQsgiTxVNLB9gfnm+2gbapzyqd9B0SHjhatz4CSg7AbbWhzRraECbv5d0Fwqs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973583; c=relaxed/simple;
	bh=eXsVicyoTZJzFjDsBeDEwJy6gb58WZKMczOYBJEKQuk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p/TOY54+RPfp27G6kBX6BFI9ZVhREerwJqhEapCxwA98cDMH9A1gBKO0HG3S4BdrhRKawLJvZ6huLrqT7WmzF5J7sgPgBL/v/6NqzQkH6KNzW3sLYIeQqOtkeuO4k3CuYVu4fv3rBrgJzyj8PvgqecXqetB9TF8UXxm8W1h/q7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AWPJ5RWq; arc=fail smtp.client-ip=40.107.92.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYFAi7TdIuGAtdXSmAEykIe41CCx8ShzS1mUGcAKP3tGJLgzBvQO2bwwgE7/WKvbmpZJUA/fwj09Ucou/qTl+1aEUz2idLdOYv7XGUXaxm67Uo65Ti4l3VUdOEtvyq2GDtD3g9JfJfbeyEBi3LSITtPso13wX9Psut9z6CZ1PQeDiaUiRwQy+Bfm/bQQeeZeXEW6dZ1ruEerARC0JgamxOU9bv1FkuBRh2SmalESrJokHZdo/wF3N9WvOushURzX74lLI2/OSw99E0n4SNJvunVvRkP3SjhvXE/O3lomiXF0yozqN/wFf6CE9xDXzEd0caD3dgEwWcN+EWPtndhJ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JhZyDfwcuWNEWOyGTq6F+CrJQ5uaP3r+uxgSi4KFk/I=;
 b=XZU107lvRUP9fc8hW9X3H+p0MPRrsjxsAr4Nea9lzaynL0X3muZf5Oxcq6r9BT51U/sSkiI+Jao0jFMID6wmJVZ6+F1EtQGA8McgKKYfqKX/JZZvWlaJpAaAsXtWDiYmCQM6sHscd6K9u5TYRXF5v1FU2SJIBQalIYUBD/n5Ln8sN8hd1IV0EV6bAwaP0XkLuHpmCsmof123WxqJUgoxaLCb9TlM+jh4qWVTIdQ74UnicNdcn8DvesO8yIKRep51wO61JCC6jR5vgF23wrAF5q+GOdLrMD53rJw7s2L9Q83OWLx9pfwNylgpYbDFvduqphWGbqD7iwDivgRSJt9s2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JhZyDfwcuWNEWOyGTq6F+CrJQ5uaP3r+uxgSi4KFk/I=;
 b=AWPJ5RWqmnq3R66F1XCfAO4Rorb5MbFBKJ1LoyXsJdnSR5ab5I3W1sMukLRucyma17TStyEwuFRRbD3MEXrc5/TS652rO7+4R7lKoo1NnJnoluyyKgsD+JeI5HXu6wdQUKr8Vv4nNqXd623JK2IGYkyMHU+ddkGzU3ptOIREBco=
Received: from PH8PR02CA0001.namprd02.prod.outlook.com (2603:10b6:510:2d0::19)
 by LV3PR12MB9143.namprd12.prod.outlook.com (2603:10b6:408:19e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.24; Fri, 21 Jun
 2024 12:39:37 +0000
Received: from SN1PEPF00036F43.namprd05.prod.outlook.com
 (2603:10b6:510:2d0:cafe::90) by PH8PR02CA0001.outlook.office365.com
 (2603:10b6:510:2d0::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 12:39:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F43.mail.protection.outlook.com (10.167.248.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 12:39:36 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 07:39:32 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v10 03/24] virt: sev-guest: Make payload a variable length array
Date: Fri, 21 Jun 2024 18:08:42 +0530
Message-ID: <20240621123903.2411843-4-nikunj@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240621123903.2411843-1-nikunj@amd.com>
References: <20240621123903.2411843-1-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F43:EE_|LV3PR12MB9143:EE_
X-MS-Office365-Filtering-Correlation-Id: 93ca2f98-6440-46c6-2fb7-08dc91ef3623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|82310400023|1800799021|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rGctCGrOIGBW2dI6NoNMRuX/KWwjB3KdcK7m3au3zy0f4gLBkluHVFduGN0V?=
 =?us-ascii?Q?lYInx113DB0KyZ5n8xbiChaJ6Xshdb5TsPJhclu2oCubhrTfGECjPOqD7QlF?=
 =?us-ascii?Q?xFupeTLGjErjNtydUF9/ZGwc+z4RbwsoFf49la6abf0si36OpujRXsp53aHG?=
 =?us-ascii?Q?/1XWZxsFxS5dyL91uWP5Zz62HZiqVOiKm5+RouAOfUdVsDF01kdEykn9UhoH?=
 =?us-ascii?Q?2TD+HPXu3eepVG6gT5aaWL7JVjkvq3eoScYAm4hIHwBFnY3JM6S3UfOxY7pU?=
 =?us-ascii?Q?ej8B8qmm9RnrmUuUiqpR0XSoDMOBHlEfCmR17qeiQGcjZ8bKqtmD/i+JNfua?=
 =?us-ascii?Q?QZCQwXK9TntyNjWbRBepQtXv2+9bLddoXH/enyOri4c7GTIxjzu7AoYUwHY6?=
 =?us-ascii?Q?as/tK1sxGB/ovo34JDpswvw2iN/EtToCZK3AUVCWiMw1e8I4a8vEQfas5nuc?=
 =?us-ascii?Q?j5MCJoK2MOSMg7M0ZEOPbaoiIujGWQ7M6AYj0SXGE9E3zC0ekvUAD4yoG9BK?=
 =?us-ascii?Q?+8XmHbs8zin24vYcwNjPX9ledh6qEmgn6m5qSMKj/L2Z9TKs7aeTRj1aFu9g?=
 =?us-ascii?Q?/fztfUcQazbeYfCKr4vO+Y1SIzEnCUJ3mFTdv5RczID4vihs1Hfp8fXccXAn?=
 =?us-ascii?Q?95hHEJ7JJx9wx5gs7SHuAyfeUd4QszzmIsYMLPlmujXi3zp0Mo4GnDlUVOXN?=
 =?us-ascii?Q?BIHALVn0k5chMWg1Nf07BZhfywHrzX2GJ7FdAkV96WBi0kjtsO19RZ+eRCrt?=
 =?us-ascii?Q?xG1k9KhSX6bZAVE/kw076PeLURa8kBCZbpHQTblykd4XZ6YJGlE2xuwanrS3?=
 =?us-ascii?Q?UeAkCL+ixJWGKQbJ4JTO3fXc9PPgH5QDHxEPgF9KAJbMqdTDYL+lGOpSezHj?=
 =?us-ascii?Q?RXetbSMAv7EA46dCE0pJ08rluEeX/2fv6TN0bT5wrJVWYBNIv+iI5goRPITt?=
 =?us-ascii?Q?F90F5CfbeUrM2g1deSqwtBeK0J2DBYtKBmcqeNbBZyzaW2o2+3+2J3aPaWOn?=
 =?us-ascii?Q?Q3Z3+gq3CM7mU3YpL499h5Etln4aawdoyi5pSRYXrlWi5I/x367bt5RtLZwB?=
 =?us-ascii?Q?x02elTWtkUSL86YZU8D5bX0zb5f+xGH0sQCsDbgE/Y8FODkD8MK7+INzSjW+?=
 =?us-ascii?Q?/pjiKUHQh+9SBI399P3I5SWkFWuJTZbKEWdfTudP3Zkn00pJEXQ4Os4F1Klx?=
 =?us-ascii?Q?L8JITlQwmQjXzho/H1i5XHD4HbAbRQRdbc9kxrpVTXRTjPO3dwJLJopXNLC0?=
 =?us-ascii?Q?EXNMUbLw1ZWKBIN2/D5r12aNx0pyVUWX+tLSpWP16H5ikxhOlzjeHkCRqddu?=
 =?us-ascii?Q?Tx+LILJB9y2k98M1dBn3JByqYKKYvvZtxKI3RqiLvwVCOCjrJciG0ELrR6uw?=
 =?us-ascii?Q?t1+BWvyjTtS1/RIdd4RPSIuGBRkh4Y4i6Hp6uxLc5UQkczNC6w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(82310400023)(1800799021)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 12:39:36.9379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 93ca2f98-6440-46c6-2fb7-08dc91ef3623
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F43.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR12MB9143

Currently, guest message is PAGE_SIZE bytes and payload is hard-coded to
4000 bytes, assuming snp_guest_msg_hdr structure as 96 bytes.

Remove the structure size assumption and hard-coding of payload size and
instead use variable length array.

While at it, rename the local guest message variables for clarity.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
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
index 831a32e522b2..e8cef42a211d 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -51,7 +51,7 @@ struct snp_guest_dev {
 	 * Avoid information leakage by double-buffering shared messages
 	 * in fields that are in regular encrypted memory.
 	 */
-	struct snp_guest_msg secret_request, secret_response;
+	struct snp_guest_msg *secret_request, *secret_response;
 
 	struct snp_secrets_page *secrets;
 	struct snp_req_data input;
@@ -181,40 +181,40 @@ static struct aesgcm_ctx *snp_init_crypto(u8 *key, size_t keylen)
 
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
@@ -223,12 +223,12 @@ static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload,
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
@@ -246,11 +246,11 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
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
@@ -356,7 +356,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		return -EIO;
 
 	/* Clear shared memory's response for the host to populate. */
-	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
+	memset(snp_dev->response, 0, SNP_GUEST_MSG_SIZE);
 
 	/* Encrypt the userspace provided payload in snp_dev->secret_request. */
 	rc = enc_payload(snp_dev, seqno, rio->msg_version, type, req_buf, req_sz);
@@ -367,8 +367,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * Write the fully encrypted request to the shared unencrypted
 	 * request page.
 	 */
-	memcpy(snp_dev->request, &snp_dev->secret_request,
-	       sizeof(snp_dev->secret_request));
+	memcpy(snp_dev->request, &snp_dev->secret_request, SNP_GUEST_MSG_SIZE);
 
 	rc = __handle_guest_request(snp_dev, exit_code, rio);
 	if (rc) {
@@ -1033,12 +1032,21 @@ static int __init sev_guest_probe(struct platform_device *pdev)
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
 
@@ -1084,9 +1092,13 @@ static int __init sev_guest_probe(struct platform_device *pdev)
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
@@ -1097,8 +1109,10 @@ static void __exit sev_guest_remove(struct platform_device *pdev)
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


