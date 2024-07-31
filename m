Return-Path: <kvm+bounces-22774-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3029432BD
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 17:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D32F11F218A6
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2024 15:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC761BD00C;
	Wed, 31 Jul 2024 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="AsDtIkr9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE67D1642B;
	Wed, 31 Jul 2024 15:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722438522; cv=fail; b=goYExKAfT+vI8Kgdpum8pWQprhATlOaQOOULmydxgCxlygl1LOozjsaCk4Qgqfx2z7buZJomSY3Sj4blvcs7l3OcuECSOn15EBSBieacsoXX73tVcINU6yCGAGyyUn7Bu0Uf6xYvqafZ+/UVTjStsu91C7Cnt4658pLjclK7nCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722438522; c=relaxed/simple;
	bh=fGJ+lIY/hPW1oEwvfYo4MYfbjZXSsjIAxaWtomyqg1w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JFQJr5pxG/3qtsZktUMtgsr/KKhFRE+RlMN3IQNVK8Gut92sNqUD272fv0MaX49eM2+Yk9eu5eBDsqZ3YF8KAjkehuAO5vOO5hqWV4ODsKhmdjdOQ/ozK43MXxEZYY6+lJQnZ4lr96JWscvgPvIf3PXF7NHhiZ0tuqr14twxP7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=AsDtIkr9; arc=fail smtp.client-ip=40.107.244.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1CO7Bv8usE0J5uEfTQXJvO9K/vKJ71PODmPo5yOyOZxmfYCCxventUFdpGwpEuS/mBnfOnN9MkNe7TzkXPzyb6Ujn876oZvqiDAYMrBbKsz9uaQa0+EOgRdswhvijfJuPR2QoTbZgEilAMGLQL/Dbyxfbkm7C/Ke5JVnwGxaTAufd5znbLwfe+El5cgarEdypUS1UfMnV56yV4mhNBywRJQ3ZqJhlGfQIDr8Cd1sx/U7dHd91oESQCXRaJltvfWidTz4HRR6LKcIoom4ybsOvGP7Wq8OVLYlNJ1FI3aWviQy4XskjuTNsNkm7bsecqY8exO4wsSTPjR8wuMTcfAdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dDIU+dN7hmPMFZLrMG6r1pt0eQllgDBIc7Y6ee0j0y8=;
 b=hY6q1HZxwpcxnI8zccSqU1ZQsYwL6lz++B+M98j+5VP6dNtVIp36wVQDQz2W3qtug8dWIaOXclAG8wlvTGF2BbYLGRrBFA7cMDOVisTVv92VawhI1OhQh+/7ArGGZ6iK3kcpFqQim+BawjYwk6tOAqv/LtXDF+Kyf1Us6GIlMlY8AVL/eWp+BcX0zIfp0i+KwngH37zUOeNh1Wh7n/ialbT/yifvrT674lH+kpmfB/eX949SyDj/z+eVP8JLa5o9mwKQ/xiVT+J0rOJFZQicWqo4lJwRHTGOUFD5AHViyLKC9Q75CPWMa4H7+/M0d9T87Lq9BEXaASQm6Iiq3UX0Qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dDIU+dN7hmPMFZLrMG6r1pt0eQllgDBIc7Y6ee0j0y8=;
 b=AsDtIkr9ZUlYde3aO9jyWGSrL0H7IrNOV+DXZuYaNi5qZy94NFh5p+zVYz0DdDhQ7P3qPMW4MpMeoVRvy+Ez2YzwF2z0LqDx9d/wyWDdp1ZUdj6qlibsmoqoEYdAnyEXQ8ECv8IopJghB2Wwmw0LRb8V71dFm6dTI56G0OKjLNo=
Received: from DM6PR07CA0089.namprd07.prod.outlook.com (2603:10b6:5:337::22)
 by MW3PR12MB4395.namprd12.prod.outlook.com (2603:10b6:303:5c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 31 Jul
 2024 15:08:38 +0000
Received: from DS3PEPF0000C37E.namprd04.prod.outlook.com
 (2603:10b6:5:337:cafe::9e) by DM6PR07CA0089.outlook.office365.com
 (2603:10b6:5:337::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.21 via Frontend
 Transport; Wed, 31 Jul 2024 15:08:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS3PEPF0000C37E.mail.protection.outlook.com (10.167.23.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7828.19 via Frontend Transport; Wed, 31 Jul 2024 15:08:36 +0000
Received: from gomati.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 31 Jul
 2024 10:08:32 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: <linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>, <bp@alien8.de>,
	<x86@kernel.org>, <kvm@vger.kernel.org>
CC: <mingo@redhat.com>, <tglx@linutronix.de>, <dave.hansen@linux.intel.com>,
	<pgonda@google.com>, <seanjc@google.com>, <pbonzini@redhat.com>,
	<nikunj@amd.com>
Subject: [PATCH v11 02/20] virt: sev-guest: Rename local guest message variables
Date: Wed, 31 Jul 2024 20:37:53 +0530
Message-ID: <20240731150811.156771-3-nikunj@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS3PEPF0000C37E:EE_|MW3PR12MB4395:EE_
X-MS-Office365-Filtering-Correlation-Id: 02d48060-03b5-44b4-bc8f-08dcb172a73f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|376014|7416014|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qVoHcJJBpurQu3A3VNqSlvPpy0D0zcI+rOPSilO1vJEveCBB1R7/XkoZzxIs?=
 =?us-ascii?Q?H3pjnamuooVED4vGpQ0MQzHLbxG2HzZ1g6Fh5ZyiQMqpRsXHECzwO84YR7xq?=
 =?us-ascii?Q?K9zi66lbkshSDqPtkcD4TDS8oM67uXeLn4Rm6Dyfu5V/TV8+UqBdiPvKJzSf?=
 =?us-ascii?Q?1gIk6R52CZRhPetmZx9mxxX866a4IZpF7iYQ52Z3oDn5Ne00jAPkymz4JRfK?=
 =?us-ascii?Q?wxZClz3Qoc0vq9A3+lxrd51G+y/kXwGzCEyZe+tj8Ir5KLFAzZp7SpXXIfNf?=
 =?us-ascii?Q?i0tldfcoLj28y3/vJMkNCU4Dpaob9xHT5YfGvFYKjEtXi6F+kgBtc8Q43eji?=
 =?us-ascii?Q?2Za7VuI6RfmY/2IgQXNsBr0dwuyFekbx/hu7Py9xjsX14BRJThOqb7TjVxt6?=
 =?us-ascii?Q?2bClRZsDGKdI/e/iS8MkTMkz0efAuPZqgDnU8jAsEMYNT1OsW0MnchVqt1Qr?=
 =?us-ascii?Q?Zq3GtuJaylkGKZgdTuIGQA7ATcyf6yJwSqmOorvqEn/P9jUX53VJOir9cR9o?=
 =?us-ascii?Q?4+m+io69DAqzMVOf5Q0GmhSKe0Ba36uVchUKa/5gZ+SjfPW0yzrtmojoOcl+?=
 =?us-ascii?Q?sM0FzMVaRdSY9nz4cb8nqM9hkrBhvDjkCk5N7ev9adLha19Iz1EYQsPec/c9?=
 =?us-ascii?Q?SvQy//0i2a0oH6h8ChZxGzkXWrGAaKHqGbMb6rdZ1HWaOqNqm6hrPskZBTYo?=
 =?us-ascii?Q?Oz3A1mrU8LQj+C+aQTw8OQrfV9hkhleiHk6MMxyWYOzUseAGp+lOqeOyDHw/?=
 =?us-ascii?Q?eY0iJi0m88vPJAtaiudWRneGK9GRNMLJRkd/WFiWOxrTvo02AkvWBJKMrKZY?=
 =?us-ascii?Q?mnmkPAA5i9FGYyZiEv7TlWcv+Q5I0UEm2tKTIe8lJhnxg/fMVfi9q+KBlEis?=
 =?us-ascii?Q?Ttv39CUFoDtEkthvqN0mQlz7crqgbWle1l4bi93+9rn4aKSZcHuz9beh2MYY?=
 =?us-ascii?Q?0h7gMSy8Kex0eW75NczydS0lbFPFFQXzlcPuUJEGwsqIwp+F9/O/7L/7y88v?=
 =?us-ascii?Q?RqomKDp5+zjvPgRnLejBxUXXfKhfCFhZAmOtGyeaICFNliduuGae7H73zUmH?=
 =?us-ascii?Q?/Vj16gwxMPmX017kz9VQZd9eIWuZUk5lbBaxaGJoH251z+VbRqWTsy9e1Vng?=
 =?us-ascii?Q?sX5MiBx2aTKt1jdlvVq1j72AH8aJbJDkpviGOntfIeDkbH64PNJ7aPVLVSfM?=
 =?us-ascii?Q?KLgy3mNartnIEUrGshlt3FM7ffFs3MqP2MOkGHJ49jpVzPXx3SBeEWrENIGJ?=
 =?us-ascii?Q?mVmdsvsCABMUWUhWf4X8n9irX2Z5AlXqfgUXBqOx71S0yZx6LcMIwl2xCoRb?=
 =?us-ascii?Q?Si09TcLsRpYcben2nmM0VghFPp+HTqvpCTVEYJRFxTniNgFREa/JyMhJWVCV?=
 =?us-ascii?Q?xis/wZzL20sYKO/MNedSBbB0nhOu7SQnWIARCKGN54//OED0jnsY0NPDcqBf?=
 =?us-ascii?Q?14ll8aYEM9CUVFUVf2pa4yVqNtMxYlSr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(376014)(7416014)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2024 15:08:36.9034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 02d48060-03b5-44b4-bc8f-08dcb172a73f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS3PEPF0000C37E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4395

Rename local guest message variables for more clarity

No functional change.

Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 117 ++++++++++++------------
 1 file changed, 59 insertions(+), 58 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 7d343f2c6ef8..a72fe1e959c2 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -291,45 +291,45 @@ static int dec_payload(struct snp_guest_dev *snp_dev, struct snp_guest_msg *msg,
 static int verify_and_dec_payload(struct snp_guest_dev *snp_dev, void *payload, u32 sz)
 {
 	struct snp_guest_crypto *crypto = snp_dev->crypto;
-	struct snp_guest_msg *resp = &snp_dev->secret_response;
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *req_hdr = &req->hdr;
-	struct snp_guest_msg_hdr *resp_hdr = &resp->hdr;
+	struct snp_guest_msg *resp_msg = &snp_dev->secret_response;
+	struct snp_guest_msg *req_msg = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *req_msg_hdr = &req_msg->hdr;
+	struct snp_guest_msg_hdr *resp_msg_hdr = &resp_msg->hdr;
 
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
-	if (unlikely((resp_hdr->msg_sz + crypto->a_len) > sz))
+	if (unlikely((resp_msg_hdr->msg_sz + crypto->a_len) > sz))
 		return -EBADMSG;
 
 	/* Decrypt the payload */
-	return dec_payload(snp_dev, resp, payload, resp_hdr->msg_sz + crypto->a_len);
+	return dec_payload(snp_dev, resp_msg, payload, resp_msg_hdr->msg_sz + crypto->a_len);
 }
 
 static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8 type,
 			void *payload, size_t sz)
 {
-	struct snp_guest_msg *req = &snp_dev->secret_request;
-	struct snp_guest_msg_hdr *hdr = &req->hdr;
+	struct snp_guest_msg *msg = &snp_dev->secret_request;
+	struct snp_guest_msg_hdr *hdr = &msg->hdr;
 
-	memset(req, 0, sizeof(*req));
+	memset(msg, 0, sizeof(*msg));
 
 	hdr->algo = SNP_AEAD_AES_256_GCM;
 	hdr->hdr_version = MSG_HDR_VER;
@@ -347,7 +347,7 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	pr_debug("request [seqno %lld type %d version %d sz %d]\n",
 		 hdr->msg_seqno, hdr->msg_type, hdr->msg_version, hdr->msg_sz);
 
-	return __enc_payload(snp_dev, req, payload, sz);
+	return __enc_payload(snp_dev, msg, payload, sz);
 }
 
 static int __handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
@@ -496,8 +496,8 @@ struct snp_req_resp {
 static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_ioctl *arg)
 {
 	struct snp_guest_crypto *crypto = snp_dev->crypto;
-	struct snp_report_req *req = &snp_dev->req.report;
-	struct snp_report_resp *resp;
+	struct snp_report_req *report_req = &snp_dev->req.report;
+	struct snp_report_resp *report_resp;
 	int rc, resp_len;
 
 	lockdep_assert_held(&snp_cmd_mutex);
@@ -505,7 +505,7 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	if (!arg->req_data || !arg->resp_data)
 		return -EINVAL;
 
-	if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+	if (copy_from_user(report_req, (void __user *)arg->req_data, sizeof(*report_req)))
 		return -EFAULT;
 
 	/*
@@ -513,30 +513,29 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + crypto->a_len;
-	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-	if (!resp)
+	resp_len = sizeof(report_resp->data) + crypto->a_len;
+	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+	if (!report_resp)
 		return -ENOMEM;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_REPORT_REQ, req, sizeof(*req), resp->data,
-				  resp_len);
+	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
+				  report_req, sizeof(*report_req), report_resp->data, resp_len);
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
+	struct snp_derived_key_req *derived_key_req = &snp_dev->req.derived_key;
 	struct snp_guest_crypto *crypto = snp_dev->crypto;
-	struct snp_derived_key_resp resp = {0};
+	struct snp_derived_key_resp derived_key_resp = {0};
 	int rc, resp_len;
 	/* Response data is 64 bytes and max authsize for GCM is 16 bytes. */
 	u8 buf[64 + 16];
@@ -551,25 +550,27 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp.data) + crypto->a_len;
+	resp_len = sizeof(derived_key_resp.data) + crypto->a_len;
 	if (sizeof(buf) < resp_len)
 		return -ENOMEM;
 
-	if (copy_from_user(req, (void __user *)arg->req_data, sizeof(*req)))
+	if (copy_from_user(derived_key_req, (void __user *)arg->req_data,
+			   sizeof(*derived_key_req)))
 		return -EFAULT;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
-				  SNP_MSG_KEY_REQ, req, sizeof(*req), buf, resp_len);
+	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg, SNP_MSG_KEY_REQ,
+				  derived_key_req, sizeof(*derived_key_req), buf, resp_len);
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
 
@@ -577,9 +578,9 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 			  struct snp_req_resp *io)
 
 {
-	struct snp_ext_report_req *req = &snp_dev->req.ext_report;
+	struct snp_ext_report_req *report_req = &snp_dev->req.ext_report;
 	struct snp_guest_crypto *crypto = snp_dev->crypto;
-	struct snp_report_resp *resp;
+	struct snp_report_resp *report_resp;
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
 
@@ -588,22 +589,22 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
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
 
@@ -613,45 +614,45 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 	 * the host. If host does not supply any certs in it, then copy
 	 * zeros to indicate that certificate data was not provided.
 	 */
-	memset(snp_dev->certs_data, 0, req->certs_len);
-	npages = req->certs_len >> PAGE_SHIFT;
+	memset(snp_dev->certs_data, 0, report_req->certs_len);
+	npages = report_req->certs_len >> PAGE_SHIFT;
 cmd:
 	/*
 	 * The intermediate response buffer is used while decrypting the
 	 * response payload. Make sure that it has enough space to cover the
 	 * authtag.
 	 */
-	resp_len = sizeof(resp->data) + crypto->a_len;
-	resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
-	if (!resp)
+	resp_len = sizeof(report_resp->data) + crypto->a_len;
+	report_resp = kzalloc(resp_len, GFP_KERNEL_ACCOUNT);
+	if (!report_resp)
 		return -ENOMEM;
 
 	snp_dev->input.data_npages = npages;
-	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg,
-				   SNP_MSG_REPORT_REQ, &req->data,
-				   sizeof(req->data), resp->data, resp_len);
+	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg, SNP_MSG_REPORT_REQ,
+				   &report_req->data, sizeof(report_req->data),
+				   report_resp->data, resp_len);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
-		req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
+		report_req->certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
 
-		if (copy_to_sockptr(io->req_data, req, sizeof(*req)))
+		if (copy_to_sockptr(io->req_data, report_req, sizeof(*report_req)))
 			ret = -EFAULT;
 	}
 
 	if (ret)
 		goto e_free;
 
-	if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, req->certs_len)) {
+	if (npages && copy_to_sockptr(certs_address, snp_dev->certs_data, report_req->certs_len)) {
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
 
-- 
2.34.1


