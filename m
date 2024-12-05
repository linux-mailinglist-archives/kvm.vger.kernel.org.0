Return-Path: <kvm+bounces-33132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D1A19E556B
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 13:28:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D30CA16BC23
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2024 12:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61F852185A7;
	Thu,  5 Dec 2024 12:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="T96cM4Tq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2051.outbound.protection.outlook.com [40.107.92.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B02A32185A1
	for <kvm@vger.kernel.org>; Thu,  5 Dec 2024 12:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733401670; cv=fail; b=m1/WOtRvxGSY863JqYQsvQzFD7ifZLp6Rai3jW3hTKO+yHly8rfKHfuS2BEjJ8mmHpCLp4vzOMuYE2uEZCQak5j2unBz4rS2YyyK1CEbX2DdO1+TZw8PqTvpFnGejgUCbGLgfkpIFBvF/1NNPRo2x0yl9l6HCoKKEbeY4vWEGbA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733401670; c=relaxed/simple;
	bh=FdOKx8JYgbCde5yoFppFqOCkdmAvgdBTG8Y1hkJfrWc=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MQBUqJGhaL+UyJfZ4kYOPlwFkIc6W/t5SdjrSu6IXA8aPzpilIb6vafTzYCPJyrPZ1DV5GvRxusGt34cPUTQDIidwPCjdtWR6zfYcaxw8B9nAkjTH/InsmSGAGu3sPYPzLQMivWenH7uodT4Fr0/ubOgcxcinzJg083wcTdqoW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=T96cM4Tq; arc=fail smtp.client-ip=40.107.92.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FkxUUaWKfytWCkvUjR1EoA2isV0damnkh2WRRWLnctpbKQrBDLJewk+ug/OSZ5e3lCy/bxYQeN/nY171DMx0tMdqCvcvvfE4f1culMJCUcGFj/keEmp+Ox3DGH1eI3sOROqRUf7NNdnGO+OsUiOoOSzpmxFTCLo0MCw7m5ig3gPV3JJWr0hEudqFuDgmklZfkixirIw1t17xhzIwqp+HSjtTBewSz7Vz0nPsZyMHFS8lgleOZRAX+ffVpBhENoaIVAFZxiagM9qksTOz1HPEVzTX3l390ah7cgygoF1D3D0wEPfQMX/XYoRuIBQwaemSLLpmFk46Hs+EUTelgDteMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWn7r7/1wVL+TdKN02t55Bm9JwNekYolFDjy7PCZ5ks=;
 b=lqY8O6Y0FH4JgNBw7n6evhKT47L+pmbB6fleiu5WNTQ0CmUYImEM8/SIvU5mlqwc5R+e97huLk5xEobi2A/jRjKlf9xCeDB02Zr9IeatP2ZPQkBFAPMWHfGSxlmu9XTgJRi7oR1uT68mwCHdWoV460FO60/2rP6bWwr4iopK6epbpEvUfRFwKp1ZLl40eGvP046hFzZ+38/gaYq3pUaYQuW+qAtW5WLVhIMiMYfnWKU6v0/GbedThlDhdXxSLpzd/3bTOKA48znMsFkASHjbcDigb77GJ9joO58cxfDIVRv7qwuWjBuSVRPNYdnAmrOkwqJicxf8YUad94aAt3KQfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWn7r7/1wVL+TdKN02t55Bm9JwNekYolFDjy7PCZ5ks=;
 b=T96cM4TqxUx89szs8M3gEh6QZgwNjkCIFLw2yIY6M6yokyzHZz1EjW2rGG1RkAiI6y585Mb7VORyAvIt2An0LS/HXhTieSbZx6mNNKsOJ57BdJkrFEXbGip0DjbXC9bY2+sv6SUvOlH87S/6s2MBkyKSjy9ZObz50OsiD+9qGKSP8JDaywIdZx8/zyZoNQuX7ZI6K24xzeKOGwVMF3v+UPK9044Dz/QdsN9avjseHZjD82WGqngeIwnvFKkQAD6oPEe1mC6avXnKcPCO6QY6PO770LrLL+SUrD/hC6pCRf2xaes9J4bXIWz9z4Vm5rfInherQ8T2Nx4e2T4os5gCKA==
Received: from SJ0PR05CA0197.namprd05.prod.outlook.com (2603:10b6:a03:330::22)
 by DS7PR12MB6144.namprd12.prod.outlook.com (2603:10b6:8:98::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.11; Thu, 5 Dec 2024 12:27:42 +0000
Received: from SJ5PEPF00000208.namprd05.prod.outlook.com
 (2603:10b6:a03:330:cafe::fd) by SJ0PR05CA0197.outlook.office365.com
 (2603:10b6:a03:330::22) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8230.8 via Frontend Transport; Thu, 5
 Dec 2024 12:27:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ5PEPF00000208.mail.protection.outlook.com (10.167.244.41) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8230.7 via Frontend Transport; Thu, 5 Dec 2024 12:27:42 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 5 Dec 2024
 04:27:27 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 5 Dec 2024
 04:27:27 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Thu, 5 Dec
 2024 04:27:24 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
	<galshalom@nvidia.com>, <clg@redhat.com>, <yicui@redhat.com>
Subject: [PATCH V1] vfio/mlx5: Align the page tracking max message size with the device capability
Date: Thu, 5 Dec 2024 14:26:54 +0200
Message-ID: <20241205122654.235619-1-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000208:EE_|DS7PR12MB6144:EE_
X-MS-Office365-Filtering-Correlation-Id: 43de3748-84e8-466c-3ad5-08dd15283711
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TW5WUW5qdXJPdjQ4Z1ZzS0pyVWw0ZEppYW4rNnJlTlY5UTBXSnFUTEFBdUNK?=
 =?utf-8?B?NUZFTjMzandQOWZzNmRHOUh6blJDNUpvWkhRSWlTWjEzVTZNWVlaRW9RbjB0?=
 =?utf-8?B?S0t0OWp0R3NJbFpzL0VJbzJRZFRTeVA4a09EeC9qckVac0F0cmRvS3BYTWNX?=
 =?utf-8?B?ZnQxR3JvNmVjWm1uWEJvOUx6VGZIQ0xnR0lvLy9ocWVYc3BlL2E1ZndSaStJ?=
 =?utf-8?B?Uk1PVXlvSmtGVVk1UlJzeVpPTWNlRTY4Ti8zbk5PTWxKcTZ0YWRLZ1hkWDBX?=
 =?utf-8?B?VGlZN0RoRWJLVDN5QXE3YXpFOGtUSzhIN3cwZ1hmQzYwZU5sVEF5bzJmekpz?=
 =?utf-8?B?YmJSOTg4MmthOW95NTg4L3dJTmdWdU4zOFIvcTFFVHJkeTRZaGdRUXJHVzZj?=
 =?utf-8?B?NEJKRHFGWGZ5dEN1NlNNb3RyV0UzMDdDWXR3OUkvc1lvbWs2bHR1S2JNZktz?=
 =?utf-8?B?TlpvMS9xY1lVMjNrUkNhU0htRWkrWFZXNEREZ1hxQ3BzajRhRThSemZEYXlt?=
 =?utf-8?B?bnU5Wkd0dzFwSWhPQUFvRDIydVlzZ0VSWHlkNkhINHgxUGFpQVFDVUtLNzNS?=
 =?utf-8?B?QXBIS2NySHhQN252UEZ5NzBHMW16dUxPTEsyMEc1Z0I1eWREKzJFUlRIQ29j?=
 =?utf-8?B?RnNoREpYc3QyMjRxbVhORnpYMXR1anVHMkZ6VFJyWmt0NjM2WmdkVFJPRUdQ?=
 =?utf-8?B?V01jMWJFQ29wd05EUk9SZTJ1bGJDbS94clVhbkU0bURDWTlEbWxYT3lRQmw1?=
 =?utf-8?B?ZG4wZmQrYTNmSHJveVRMeVZrUHRDU0dIY1VBQ1M0ejZ0MmNvcUhBNWdjcm5U?=
 =?utf-8?B?MjNwSWQwZlVQcHpsNk9Mc3BxQ1Z0bFdwZFN3QWU4cUZ3QXBhTFVoOXBrMmpI?=
 =?utf-8?B?SmljcnY2dnZ5VnFLc3phZ2RhRWlnUm9xWDFvSHBhMm5jYmpGWUlrTkl0RVZs?=
 =?utf-8?B?VjBaQVpqaXVpay93c0ozRUR6eWpTZ2NzMU1UY3NUMGFqRzZFRUxkWlJXelcx?=
 =?utf-8?B?ZlhlSFVKN2FPdHlsbms0UHhGb3ZCbDltT1hkZVlKdzVPRVVGZkN1dURyUVNT?=
 =?utf-8?B?MHIwWTRhOHc2ckIrSDFGZTNTZHQvYjZ1bDRCbUErQ2cvdGdTd1UzUENyRzVT?=
 =?utf-8?B?K1RsWG9XUzlKa2l0L3l5c1FLUDJVMnZKQmw5dUd1V0ZrYjVDS3l0NlBvZUZ3?=
 =?utf-8?B?Z3RoZW9oK2pRbkI3S05lNnIvVWxFenVNSSt5QU9LN3BuYmlkN25DazgySDVo?=
 =?utf-8?B?cGpNV3lGQ290S3dybUJjOEFXWWIyTWRXQzhGNWwvaDlMZThCdWF0cWNyNW1z?=
 =?utf-8?B?enNZeVpmblNVQ2pQNVBlN2hGTTN4WTFwQ3FqWlFkck5Wdkx2bDlvNWQrdmwz?=
 =?utf-8?B?TFhhOHJ6dlA3ZEhhbGEzZjljVTcxYURJVkpPTGh6L2p3YU1WVnh0Z1V6NEQ4?=
 =?utf-8?B?MWRVWnhQQXFEdWZwRjIzcy95NGdhODgyeHh6dnQ2L1hqVGpxM1VmNjRRSnhQ?=
 =?utf-8?B?RlRPa3l2bmI5dEdSRzZEaDZmamxIMml1WjdSRWFJVFk0WUFZbGpiZlJjYzNv?=
 =?utf-8?B?Q1ZTYXJONWJUQUU4ZTByeW9VdlRNNnNBRlhBRHNYS29qcDhjT2lFS1pJcURU?=
 =?utf-8?B?RzNQVXNsMnRxMFN4R2wya3NRMk84bEZYckVweXp6OHRJV29hNndIc1QzRWRa?=
 =?utf-8?B?SG9qMGtPeHlIcEZlNXRPU3hyczkzUlo4Qzh1MGtSRHhyVEJzRlBic3VWQkw4?=
 =?utf-8?B?eFQ0ZTluRXkrZ29SYmZHSjd6cHdRQzlwY1U1Q1VQRkE1Q2Fqc2cxajJwNWFL?=
 =?utf-8?B?aEdKWW5hVDdtTzJZNitOOGhjcHFrZnpqWHI2cXNhaWZEd3NoMlN2R2xYYWNJ?=
 =?utf-8?B?L2JCczhvMUl6VjMrRVpBZFY0L3RaUXdKRk93Rko3ODMvdmJhc2lIWTNuQTZY?=
 =?utf-8?Q?zI4YU8UctqhStrAe6D2LIY8VzuZtU5oG?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2024 12:27:42.2135
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43de3748-84e8-466c-3ad5-08dd15283711
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000208.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6144

Align the page tracking maximum message size with the device's
capability instead of relying on PAGE_SIZE.

This adjustment resolves a mismatch on systems where PAGE_SIZE is 64K,
but the firmware only supports a maximum message size of 4K.

Now that we rely on the device's capability for max_message_size, we
must account for potential future increases in its value.

Key considerations include:
- Supporting message sizes that exceed a single system page (e.g., an 8K
  message on a 4K system).
- Ensuring the RQ size is adjusted to accommodate at least 4
  WQEs/messages, in line with the device specification.

The above has been addressed as part of the patch.

Fixes: 79c3cf279926 ("vfio/mlx5: Init QP based resources for dirty tracking")
Reviewed-by: Cédric Le Goater <clg@redhat.com>
Tested-by: Yingshun Cui <yicui@redhat.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
Changes from V0:
https://lore.kernel.org/kvm/20241125113249.155127-1-yishaih@nvidia.com/T/

- Rename 'page_start' to 'kaddr' as was suggested by Cédric.
- Add the Tested-by and Reviewed-by clauses.

 drivers/vfio/pci/mlx5/cmd.c | 47 +++++++++++++++++++++++++++----------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 7527e277c898..eb7387ee6ebd 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -1517,7 +1517,8 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	struct mlx5_vhca_qp *host_qp;
 	struct mlx5_vhca_qp *fw_qp;
 	struct mlx5_core_dev *mdev;
-	u32 max_msg_size = PAGE_SIZE;
+	u32 log_max_msg_size;
+	u32 max_msg_size;
 	u64 rq_size = SZ_2M;
 	u32 max_recv_wr;
 	int err;
@@ -1534,6 +1535,12 @@ int mlx5vf_start_page_tracker(struct vfio_device *vdev,
 	}
 
 	mdev = mvdev->mdev;
+	log_max_msg_size = MLX5_CAP_ADV_VIRTUALIZATION(mdev, pg_track_log_max_msg_size);
+	max_msg_size = (1ULL << log_max_msg_size);
+	/* The RQ must hold at least 4 WQEs/messages for successful QP creation */
+	if (rq_size < 4 * max_msg_size)
+		rq_size = 4 * max_msg_size;
+
 	memset(tracker, 0, sizeof(*tracker));
 	tracker->uar = mlx5_get_uars_page(mdev);
 	if (IS_ERR(tracker->uar)) {
@@ -1623,25 +1630,41 @@ set_report_output(u32 size, int index, struct mlx5_vhca_qp *qp,
 {
 	u32 entry_size = MLX5_ST_SZ_BYTES(page_track_report_entry);
 	u32 nent = size / entry_size;
+	u32 nent_in_page;
+	u32 nent_to_set;
 	struct page *page;
+	u32 page_offset;
+	u32 page_index;
+	u32 buf_offset;
+	void *kaddr;
 	u64 addr;
 	u64 *buf;
 	int i;
 
-	if (WARN_ON(index >= qp->recv_buf.npages ||
+	buf_offset = index * qp->max_msg_size;
+	if (WARN_ON(buf_offset + size >= qp->recv_buf.npages * PAGE_SIZE ||
 		    (nent > qp->max_msg_size / entry_size)))
 		return;
 
-	page = qp->recv_buf.page_list[index];
-	buf = kmap_local_page(page);
-	for (i = 0; i < nent; i++) {
-		addr = MLX5_GET(page_track_report_entry, buf + i,
-				dirty_address_low);
-		addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
-				      dirty_address_high) << 32;
-		iova_bitmap_set(dirty, addr, qp->tracked_page_size);
-	}
-	kunmap_local(buf);
+	do {
+		page_index = buf_offset / PAGE_SIZE;
+		page_offset = buf_offset % PAGE_SIZE;
+		nent_in_page = (PAGE_SIZE - page_offset) / entry_size;
+		page = qp->recv_buf.page_list[page_index];
+		kaddr = kmap_local_page(page);
+		buf = kaddr + page_offset;
+		nent_to_set = min(nent, nent_in_page);
+		for (i = 0; i < nent_to_set; i++) {
+			addr = MLX5_GET(page_track_report_entry, buf + i,
+					dirty_address_low);
+			addr |= (u64)MLX5_GET(page_track_report_entry, buf + i,
+					      dirty_address_high) << 32;
+			iova_bitmap_set(dirty, addr, qp->tracked_page_size);
+		}
+		kunmap_local(kaddr);
+		buf_offset += (nent_to_set * entry_size);
+		nent -= nent_to_set;
+	} while (nent);
 }
 
 static void
-- 
2.18.1


