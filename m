Return-Path: <kvm+bounces-39060-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E0EEA430EF
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 00:32:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A3231791CA
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 23:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0576A20CCCC;
	Mon, 24 Feb 2025 23:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="d1BRQc9z"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EB3520C46A;
	Mon, 24 Feb 2025 23:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740439907; cv=fail; b=NDwBcvBByjG+pTkirAvcjOO4XCQMouRHVeU+E3cz0NljHlrWWV+ukLKNc46SHsb52nSdgx8euYthBsg9eVcrcISQTtGK9TLXnLbQxhWDrUS20pry7ExOl4lqpug5X/SeBrCRK51Y4Bendd5RV+80CVO6PEuLuAw8GO6nJ7Pt03g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740439907; c=relaxed/simple;
	bh=8BFbABLFoJzWgQb0x2au2qMscQJ3CwH/2vrpGcvrXBs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cbevdcHwKfxG4g1yF7N2U48NgmKSK+b6SERJwlxta/CsUrtF7eKgxqv/TbNBB5CKE2Epov9AbDiYjlnfxivTy9S5Rf9ZXSkLMkokrAq96vHuyRmJD8RVMtK2ha3pflPCt/TlcuWM/l+osiOAoBrO6YZ5JwV7BO312RhJLOsxXNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=d1BRQc9z; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k8JkEk5J0eCdxreP5cvX6hWSwL9a4iiHYDXLpedxHcTBTN6a0PAahBanXs4NcIEJt77cx5WHBKjbHWdJ6w/caXohathmhZZ0rqzdCqFjg6at1NpwZcq8TzPTWa4B2jc5aDYDzX5aZ19ggikqIDHNFmv/P1UxO57RzbjAZwKe6a2oQXWMBq22LCqQaE9W2brAFBA58W6Z3jyBDLdwafRWH4scR/UfZ1vO+VgO1KS7HcCiZOP9bf6nEQrDb5b/TQ2nAHZOXRePgWiuEFnCu2tWP6Dz7zL8RkbZ8Z1mZHIO2n4hPYOadV1CSRnRHIDyMC7oGjpYi4SOnsfwTFdwoQJtOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmK/k3vNcF5Ay0W3BxSIT70FlqapIsiRiTkpYMHx/90=;
 b=dKrthrfXwE1TwFgCinil+tz85C2CtHWdyXP37D76Mq4bkLS/pgV7Wxa6b4XquVQ0d5h2kGY5DVCIMndPtfrJE19ZMnBt7vT16L3NoJKLdXho7UjNFsr+vopVeopp/oiK8REjVWEhphH2YRACm2W53nilKy8T0FnqS0xYF3Wu2+KwBpmoI4VIIf2bQ2ubVgNBpBOnRphhIOmngGHmdorGKIDj73Fy4KVjSo5g34O7MA6RLhxXaIv0XilUXQme/nSC+8OIYG1oeHx9wG5Q288/ewpPVluNspn3p9PRQj2LlMdLLYVw6CcnRQbnN67KZw2/Fo6VMk+7SUYF9DrZFzB1qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmK/k3vNcF5Ay0W3BxSIT70FlqapIsiRiTkpYMHx/90=;
 b=d1BRQc9zRMlCvb42FVAkf63WpvgjnYgq5jY5fnR+6/tO5tPjcuOZ9Jw2x7k8xZjmrUHlBlgE6b82ExUoLvNXc2udlLgUXuCPWP4GiFt4Ots3VF3whQfMVLZw+/O2kVxDJ5LUaM9Py5UOkXDpK7prvhIhryfspREP59vwUNAO9RKhlyHM8z7a7USJgz1y8kQFQJGxDrLKba5d+kaP1lvfI0ZWG2xOhV9I7iUk0ptcC8pwEABdCoqxK+nqhcFc9KVgbf8fF6RFVmF05PYTcPatU0OnX7VD2cQXYwzxMuqI0KxTeA7JuhzaXb1gtWbM+sCFfuDueGS4D6/hus9SyaM4Fw==
Received: from BL1P222CA0014.NAMP222.PROD.OUTLOOK.COM (2603:10b6:208:2c7::19)
 by DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8466.19; Mon, 24 Feb 2025 23:31:32 +0000
Received: from MN1PEPF0000F0E5.namprd04.prod.outlook.com
 (2603:10b6:208:2c7:cafe::12) by BL1P222CA0014.outlook.office365.com
 (2603:10b6:208:2c7::19) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.21 via Frontend Transport; Mon,
 24 Feb 2025 23:31:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E5.mail.protection.outlook.com (10.167.242.43) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8489.16 via Frontend Transport; Mon, 24 Feb 2025 23:31:32 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 24 Feb
 2025 15:31:14 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Mon, 24 Feb
 2025 15:31:14 -0800
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.14 via Frontend
 Transport; Mon, 24 Feb 2025 15:31:10 -0800
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: <israelr@nvidia.com>, <stefanha@redhat.com>,
	<virtualization@lists.linux.dev>, <mst@redhat.com>,
	<linux-block@vger.kernel.org>
CC: <oren@nvidia.com>, <nitzanc@nvidia.com>, <dbenbasat@nvidia.com>,
	<smalin@nvidia.com>, <larora@nvidia.com>, <izach@nvidia.com>,
	<aaptel@nvidia.com>, <parav@nvidia.com>, <kvm@vger.kernel.org>, Max Gurtovoy
	<mgurtovoy@nvidia.com>
Subject: [PATCH 1/2] virtio_blk: add length check for device writable portion
Date: Tue, 25 Feb 2025 01:31:05 +0200
Message-ID: <20250224233106.8519-2-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20250224233106.8519-1-mgurtovoy@nvidia.com>
References: <20250224233106.8519-1-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E5:EE_|DS7PR12MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: af18babd-87bc-43e0-443e-08dd552b5f1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?56+vbkgQSuLMeRAqTOqGR0cRLu9M8JKB/zyyVtGYtPCZ0XEITsf36jQTY7lh?=
 =?us-ascii?Q?BDVp83yXPa6x7iJBv9+BYgyrxZU8ORkeeQp+W1RjVxPMbbiI0qwxvMQ0d7i0?=
 =?us-ascii?Q?P7jYBGkFgJCkpnHtKbT9IwGAYlTdlqmCU2M4pW+z760dxD8NtmdHURTz+jaP?=
 =?us-ascii?Q?YIIKlwx3bJts3wx5tCP9TE7UakrotyHNhVmukpC+PeEs01n0vRKYB1GRYwlB?=
 =?us-ascii?Q?foHk1TUOzkHySttLhY0SsHuxvkYp3z1YCiddrum5DVrIBuuNpQ9c5WADcrmi?=
 =?us-ascii?Q?jwqxnd3XcpwZHujhgTZIRmul7OJwf24894eyHivEns0THxhLIHFkg4ZDAIDn?=
 =?us-ascii?Q?W+TVKYgM1SgcV9xnUbZDr0fNwqgAsVB24WnL5qT+ZKF3y3OqKlUiSXd8NIZz?=
 =?us-ascii?Q?sOOwm1Td7iALvIwXPyzKXXdXbK7IwuWfOkn1hCJm4jLP0Tib7MZFO6dVHxQE?=
 =?us-ascii?Q?ZPAQKKZ4kJP/ig8fXT1O1GRTXRvW6F+XoJgkY1gWJJR3sFQHyrORpmabq23v?=
 =?us-ascii?Q?sXjmCJMhd3oXFe9Ft63R4Lqaocp5RV9C6dZ3zO2Ot1O4jHSEfG5h2w1f5NKo?=
 =?us-ascii?Q?hRQv9AvBiUwA/jrYcyxXTrBjOPLBKRnl5T5AX98RLv7SFu0mjF/NJpZCilVs?=
 =?us-ascii?Q?b4IZ/bFX2xyI1TpGUStMeXZd1KRqTfxtVXC2QvHokVUPO6LX9LMTpU1k2Cxu?=
 =?us-ascii?Q?3s+UbX6JhasT3MM/fyyZPBt0xNRIDEld4ludL0Z7vXT1Js3oglWySSf4gxdh?=
 =?us-ascii?Q?N4OWYxgLZvbq6VW84UzUt638qhFqQ0HbJ3PN8B19UiN0Xx75LMcSJtUh/Ubw?=
 =?us-ascii?Q?iLcYT5sLC94u44P7ODV163NVpMK2ggEPciXCPf0Tns0K87slCxz4nWorZjRQ?=
 =?us-ascii?Q?TH1R+9l+BDX/uhE8LYzUScKdggJZe/3yCiMs8n88r0RcD2dwKH4AyVeSWwwC?=
 =?us-ascii?Q?keg6mYu/MoVY88NrA0Wvn5cdt0Ptj3FvqkrXGLD8+WuuFw7FZp3RLoekG8V/?=
 =?us-ascii?Q?bMnfoNw/5Kj+z3PFBygZCSXbh9nu+5iDdKmpDsFO0ZrUoVbveqRNek1i6kiE?=
 =?us-ascii?Q?jd7slCTiucOOX7W333VyvAzMJpYs2bocGs7zWWT0Lk6RYFrAO7JKWRKz7ITD?=
 =?us-ascii?Q?/T6F7vDwR49lWz3qHt5zaCaBDHQChBxUc8/lQz5fbFOlAVk1hVgsr8HObBWW?=
 =?us-ascii?Q?svfHYxEapviVRbFBAaBnDZkArSUtNlmMFChbP6RK8llJ3lqWC1aSg49vebml?=
 =?us-ascii?Q?U+/by5fiUcbu0GXdmlU8XinjbxCPzcpn+mW27wl1EYb9sBzb1Z4oXPAlv6xp?=
 =?us-ascii?Q?4JvEXgzr08tcf8Zl4mR90X2q168ijvpfowSh76JoynykWj1pGGr5oEtKdunu?=
 =?us-ascii?Q?WSHVdSykVY1fdo9SfBPIwQPNi26fjiWgYapOGoIJR8ksq33CjC3IPIi+fazq?=
 =?us-ascii?Q?KFaWf8sTyS8G6PtERH9v32lYI+mNzQbGsRmYo93kfAGPqEwXfQ+xfBfe3P7T?=
 =?us-ascii?Q?Outfjsd4/sl4jqA=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(376014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 23:31:32.1933
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af18babd-87bc-43e0-443e-08dd552b5f1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E5.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6120

Add a safety check to ensure that the length of data written by the
device is at least as large the expected length. If this condition is
not met, it indicates a potential error in the device's response.

This change aligns with the virtio specification, which states:
"The driver MUST NOT make assumptions about data in device-writable
buffers beyond the first len bytes, and SHOULD ignore this data."

By setting an error status when len is insufficient, we ensure that the
driver does not process potentially invalid or incomplete data from the
device.

Reviewed-by: Aurelien Aptel <aaptel@nvidia.com>
Signed-off-by: Lokesh Arora <larora@nvidia.com>
Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 drivers/block/virtio_blk.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6a61ec35f426..58407cfee3ee 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -331,6 +331,20 @@ static inline u8 virtblk_vbr_status(struct virtblk_req *vbr)
 	return *((u8 *)&vbr->in_hdr + vbr->in_hdr_len - 1);
 }
 
+static inline void virtblk_vbr_set_err_status_upon_len_err(struct virtblk_req *vbr,
+		struct request *req, unsigned int len)
+{
+	unsigned int expected_len = vbr->in_hdr_len;
+
+	if (rq_dma_dir(req) == DMA_FROM_DEVICE)
+		expected_len += blk_rq_payload_bytes(req);
+
+	if (unlikely(len < expected_len)) {
+		u8 *status_ptr = (u8 *)&vbr->in_hdr + vbr->in_hdr_len - 1;
+		*status_ptr = VIRTIO_BLK_S_IOERR;
+	}
+}
+
 static inline void virtblk_request_done(struct request *req)
 {
 	struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
@@ -362,6 +376,9 @@ static void virtblk_done(struct virtqueue *vq)
 		while ((vbr = virtqueue_get_buf(vblk->vqs[qid].vq, &len)) != NULL) {
 			struct request *req = blk_mq_rq_from_pdu(vbr);
 
+			/* Check device writable portion length, and fail upon error */
+			virtblk_vbr_set_err_status_upon_len_err(vbr, req, len);
+
 			if (likely(!blk_should_fake_timeout(req->q)))
 				blk_mq_complete_request(req);
 			req_done = true;
@@ -1208,6 +1225,9 @@ static int virtblk_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	while ((vbr = virtqueue_get_buf(vq->vq, &len)) != NULL) {
 		struct request *req = blk_mq_rq_from_pdu(vbr);
 
+		/* Check device writable portion length, and fail upon error */
+		virtblk_vbr_set_err_status_upon_len_err(vbr, req, len);
+
 		found++;
 		if (!blk_mq_complete_request_remote(req) &&
 		    !blk_mq_add_to_batch(req, iob, virtblk_vbr_status(vbr),
-- 
2.18.1


