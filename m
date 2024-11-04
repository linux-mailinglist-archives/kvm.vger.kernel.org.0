Return-Path: <kvm+bounces-30493-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63D569BB0FA
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 11:24:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE5AC1F217F7
	for <lists+kvm@lfdr.de>; Mon,  4 Nov 2024 10:24:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D4F1B2184;
	Mon,  4 Nov 2024 10:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Sdgkg/Yb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2051.outbound.protection.outlook.com [40.107.94.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F135A1B0F2C
	for <kvm@vger.kernel.org>; Mon,  4 Nov 2024 10:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730715820; cv=fail; b=VUtRMyXE8A5FW3uid0ljMavmWYm7VUMkm/2HjTyi0dl/UmuiLE92yiESF0RdNSMEb14egKg6F2U4S1EpsMsvCVvYuEeDsVIYPPkSLk+QGqwsG4YPFmXOMijcHv6pJvq96Wx80Q0rXS15spZf3aPAobM6WBuegKImXh/P9uBj2K4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730715820; c=relaxed/simple;
	bh=7N275dp9hk343slFrmE2t3qm+V65uGIq7jVZvN4m/B8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tv79IUAOfo4VWi2A7d6oNq37h2eleJ7eUyCkUNFZeFL79X48+OTXud5LSDq3oi35Cv2pexoU+tNZEzWtfjqzhzd4sxOczoyiDJtmigvpyGolnihWaGCjqENULBy4aYIzR/ZN7EnyA4RX+IsIa5hyEPH2e2lSwkrrq3btfDdYDM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Sdgkg/Yb; arc=fail smtp.client-ip=40.107.94.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SYl+VyAuzXJbPttNcilhMfZN9TGGgIyN8MotRXw5AgIqLzYTew0pup+vRYZ79JoYr4reqGbHAOMN9pbWkr5wv/sQX/crN1sQYIy6viv8CmsGo1Wazs7/TxwpUv5s4txR+mvQArZHZ3LDc0lRSfpe620vzFT36RZI248LCeoumJTaR+osFlIO8OedlGqMN3csYfXgM1W/A79O4cBTaonPiCAox/3Yk2QnVnmV9dDKvP2KduJ+pOJNHirasfZcZ9ad7WFMAe5C4+Z1RPbk74f7CqpPACf+FpboDF9TL6LRqlVtqaefroAibTgQjh+PcHJW62XDsOG0DwH6wW9dzpdo2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1KJcg9YIFDlq3IijbnVjt2fVsllKzLGTqMtlgF9Ay8I=;
 b=xYGA7v7mN7fyYfKFFFRsKBDe30FFIl46C38rs0BuTmBjyab7JM5xEVULZCibl7B8TNFvTrtF16rN1bMfwabdkh6eia+OETXrKT4Rf+j+lUR6YN2N+xIeEa+aTo036SAl/WNtHl/sJNEXIzRJ2yrmIE1zKS046Pl5riO+IjrtoGFvZIsmDoYgrdyvhQCCR3p3wQeukvucdcsRyrGcH9+wXopkhiB2KglO/vf8nHeML8KkNNFYtXtupijyIT5Uu5Hid01kosJ1wZD3qqbvboPL4+/+vftF2U/hGNb4az97RZDyH4mE96Ou/G0ZOvtree5odg9G2owsmxv8gqwgdSu8mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1KJcg9YIFDlq3IijbnVjt2fVsllKzLGTqMtlgF9Ay8I=;
 b=Sdgkg/Ybeq+s3N24mTNz2rSXLduv0FtxPkGYcmg+3pUABiLUTb3Zq3Nm/SV3Hefj3gukYwoIQzu9s8XMTS91vpKgOq0mAWGCUkNvuOePZsHBW6O1X+Yj6buzTR6lm/Idon2shON+e2kkQjOMj3M4AxcQZ5WX8Xx0nyQHtE0EeZnQrIOwuQdgyPKLcAyffu+7Cp29o6oYtXMpwz9A5srrYMRHmVQ0Vd8y79glLkh2GQsIPedij/4ws7aSlzmlJqCCQrIZIpsX6ISi393U39uQv569z9zUH1fdJWJEFKNSNugC8gPlKmVm5j/UyK+TDHR7oPhmSmKnxyQ9Vbb/5WCQHg==
Received: from MN0P221CA0009.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:52a::27)
 by MN2PR12MB4141.namprd12.prod.outlook.com (2603:10b6:208:1d5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Mon, 4 Nov
 2024 10:23:33 +0000
Received: from BN1PEPF00004688.namprd05.prod.outlook.com
 (2603:10b6:208:52a:cafe::9) by MN0P221CA0009.outlook.office365.com
 (2603:10b6:208:52a::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31 via Frontend
 Transport; Mon, 4 Nov 2024 10:23:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN1PEPF00004688.mail.protection.outlook.com (10.167.243.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.17 via Frontend Transport; Mon, 4 Nov 2024 10:23:33 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Mon, 4 Nov 2024
 02:23:24 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.4; Mon, 4 Nov 2024 02:23:24 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Mon, 4 Nov 2024 02:23:21 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V1 vfio 6/7] vfio/virtio: Add PRE_COPY support for live migration
Date: Mon, 4 Nov 2024 12:21:30 +0200
Message-ID: <20241104102131.184193-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241104102131.184193-1-yishaih@nvidia.com>
References: <20241104102131.184193-1-yishaih@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004688:EE_|MN2PR12MB4141:EE_
X-MS-Office365-Filtering-Correlation-Id: 18797df1-c714-4d68-d269-08dcfcbabc9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S7J1Lnfys0n83CeL4BhcTaAdiBinagDEu7B6ucQpDXnhOdryTwhVBJL/3mYG?=
 =?us-ascii?Q?hKuo6Qg+yZD4n8vVYWKukWK/XcQM1kkWKdto66KziVYIhVKVuveyIcDJD1IW?=
 =?us-ascii?Q?9zdQ0H+00lKArnB+sIYQWuVPVm1lNvNH2dppPGnYFBWhkIwaNh1zWO8EdSMV?=
 =?us-ascii?Q?7J9TPEOVsrreSL6UGxxpFQfwhyWL0TrLFpPf4QO28c/e+9JXjiko6fpxozCG?=
 =?us-ascii?Q?N+XicanY7lShJXB5fzFMKZTFNDqlufjaR6YSlG3P8CzqDm846AEsFMU5mG85?=
 =?us-ascii?Q?1koR2tu3rryOtgACIVk6WFEeIsT6VV9c5IQEEEtTwUUUCb6Evry94tU4ifPt?=
 =?us-ascii?Q?Wlj1XgrzaedvR2DkhtOXxy0+hAv3cMr/P67Z2DwQBeqOtXyuKHusQ7d4ZZIx?=
 =?us-ascii?Q?vlKdGH71Afh7r6w1JmwjFmTCwiE/yeGamfY7KpUtBSAZmoZXIYIOpUC7fx6e?=
 =?us-ascii?Q?XaRrZiAwLhJPkACBfyvtYFXEuwpMV//dzkIjDvxl7ElxuOEeCPuY25EWGv95?=
 =?us-ascii?Q?2zE5FDBrb04E1Y48zD4oMuqC7Z/Egp76uAKg8a7e6zDsvrE/V87Hm6TtuIVp?=
 =?us-ascii?Q?52tjl+hW7xWk6sJ3Ttjfz5JhpksJRGaWgwAZAadKwOAKY7k1LQEbcNutNfH1?=
 =?us-ascii?Q?3kAYP0ycCrCkEpcLo33nUMgoS3gYOKvDyvA5rpL9HgDR1DE4PSWvwUWE1nL2?=
 =?us-ascii?Q?+PRs7KU5ri7UpuwGMqlk6tClshhq/RgrO432rSVoY91Ie6YxJ2rhICnkzvml?=
 =?us-ascii?Q?wGbrBuXCk+0n86gE6L/I4roUDVSuAYdZxIHi5bAeFZqXeKd7gXPT1gc6l5pN?=
 =?us-ascii?Q?lyDo6nuCVO+fPzOzOmNGiMnkO7+GADJrWcMHhAa0AfaHRcsuFFchkDY7Jkcx?=
 =?us-ascii?Q?wZBranr/sv9/F9pBjcOmHeyBfFYChBHImkX59ip6a6Rs9fY6Zh2suHtwizp+?=
 =?us-ascii?Q?D3/7y2xEYA6+YNXGHY8LsW0fK1CwmEdjBXWX7R9TkBFQZLqzH52ZUebTI0eP?=
 =?us-ascii?Q?3uiJ/ENZEJeMzPmD0fy+eQfQh/Tsx9leDlZ7rSonLJcwywysO9vaKeRukQES?=
 =?us-ascii?Q?C/u2Q73PGAHOWhWC+u84SfRrQLrfRBwtaI6rIyrQHFInXitbyWdNP+6t609p?=
 =?us-ascii?Q?IGnqMST38aUtLAqNDRN9A2g5JcJICzQfoGxnQJQuAXeIaRUFJdN3tPA0/Sp3?=
 =?us-ascii?Q?haa7nzhB6538UfJ+l6mw9pZALhQfSMQJZcQ4eswpZCt0SenQwC6AvWsgu7HP?=
 =?us-ascii?Q?K3vONI4WKPXxFnzW3roBraOG52M//7j3vE5y5UNa9LHKjGu0ELp8rEyeJnbW?=
 =?us-ascii?Q?1GIjBblIkiBnV5CqN26CFDMm+xgFOsmWN1dJfWzeSBVezfuNvxODTpTJcopE?=
 =?us-ascii?Q?xdeS42TH1hzaflCg+8NjtnCTyxYJ5zhDnBzdtpu+F/erbgs7Sg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2024 10:23:33.6247
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18797df1-c714-4d68-d269-08dcfcbabc9c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004688.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4141

Add PRE_COPY support for live migration.

This functionality may reduce the downtime upon STOP_COPY as of letting
the target machine to get some 'initial data' from the source once the
machine is still in its RUNNING state and let it prepares itself
pre-ahead to get the final STOP_COPY data.

As the Virtio specification does not support reading partial or
incremental device contexts. This means that during the PRE_COPY state,
the vfio-virtio driver reads the full device state.

As the device state can be changed and the benefit is highest when the
pre copy data closely matches the final data we read it in a rate
limiter mode and reporting no data available for some time interval
after the previous call.

With PRE_COPY enabled, we observed a downtime reduction of approximately
70-75% in various scenarios compared to when PRE_COPY was disabled,
while keeping the total migration time nearly the same.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/common.h  |   4 +
 drivers/vfio/pci/virtio/migrate.c | 233 +++++++++++++++++++++++++++++-
 2 files changed, 229 insertions(+), 8 deletions(-)

diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
index 3bdfb3ea1174..5704603f0f9d 100644
--- a/drivers/vfio/pci/virtio/common.h
+++ b/drivers/vfio/pci/virtio/common.h
@@ -10,6 +10,8 @@
 
 enum virtiovf_migf_state {
 	VIRTIOVF_MIGF_STATE_ERROR = 1,
+	VIRTIOVF_MIGF_STATE_PRECOPY = 2,
+	VIRTIOVF_MIGF_STATE_COMPLETE = 3,
 };
 
 enum virtiovf_load_state {
@@ -57,6 +59,8 @@ struct virtiovf_migration_file {
 	/* synchronize access to the file state */
 	struct mutex lock;
 	loff_t max_pos;
+	u64 pre_copy_initial_bytes;
+	struct ratelimit_state pre_copy_rl_state;
 	u64 record_size;
 	u32 record_tag;
 	u8 has_obj_id:1;
diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
index 2a9614c2ef07..cdb252f6fd80 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -26,6 +26,10 @@
 /* Initial target buffer size */
 #define VIRTIOVF_TARGET_INITIAL_BUF_SIZE SZ_1M
 
+static int
+virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
+				   u32 ctx_size);
+
 static struct page *
 virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
 			    unsigned long offset)
@@ -155,6 +159,41 @@ virtiovf_pci_free_obj_id(struct virtiovf_pci_core_device *virtvdev, u32 obj_id)
 			VIRTIO_RESOURCE_OBJ_DEV_PARTS, obj_id);
 }
 
+static struct virtiovf_data_buffer *
+virtiovf_get_data_buffer(struct virtiovf_migration_file *migf, size_t length)
+{
+	struct virtiovf_data_buffer *buf, *temp_buf;
+	struct list_head free_list;
+
+	INIT_LIST_HEAD(&free_list);
+
+	spin_lock_irq(&migf->list_lock);
+	list_for_each_entry_safe(buf, temp_buf, &migf->avail_list, buf_elm) {
+		list_del_init(&buf->buf_elm);
+		if (buf->allocated_length >= length) {
+			spin_unlock_irq(&migf->list_lock);
+			goto found;
+		}
+		/*
+		 * Prevent holding redundant buffers. Put in a free
+		 * list and call at the end not under the spin lock
+		 * (&migf->list_lock) to minimize its scope usage.
+		 */
+		list_add(&buf->buf_elm, &free_list);
+	}
+	spin_unlock_irq(&migf->list_lock);
+	buf = virtiovf_alloc_data_buffer(migf, length);
+
+found:
+	while ((temp_buf = list_first_entry_or_null(&free_list,
+				struct virtiovf_data_buffer, buf_elm))) {
+		list_del(&temp_buf->buf_elm);
+		virtiovf_free_data_buffer(temp_buf);
+	}
+
+	return buf;
+}
+
 static void virtiovf_clean_migf_resources(struct virtiovf_migration_file *migf)
 {
 	struct virtiovf_data_buffer *entry;
@@ -341,6 +380,7 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
 {
 	struct virtiovf_migration_file *migf = filp->private_data;
 	struct virtiovf_data_buffer *vhca_buf;
+	bool first_loop_call = true;
 	bool end_of_data;
 	ssize_t done = 0;
 
@@ -358,6 +398,19 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
 		ssize_t count;
 
 		vhca_buf = virtiovf_get_data_buff_from_pos(migf, *pos, &end_of_data);
+		if (first_loop_call) {
+			first_loop_call = false;
+			/* Temporary end of file as part of PRE_COPY */
+			if (end_of_data && migf->state == VIRTIOVF_MIGF_STATE_PRECOPY) {
+				done = -ENOMSG;
+				goto out_unlock;
+			}
+			if (end_of_data && migf->state != VIRTIOVF_MIGF_STATE_COMPLETE) {
+				done = -EINVAL;
+				goto out_unlock;
+			}
+		}
+
 		if (end_of_data)
 			goto out_unlock;
 
@@ -379,9 +432,104 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
 	return done;
 }
 
+static long virtiovf_precopy_ioctl(struct file *filp, unsigned int cmd,
+				   unsigned long arg)
+{
+	struct virtiovf_migration_file *migf = filp->private_data;
+	struct virtiovf_pci_core_device *virtvdev = migf->virtvdev;
+	struct vfio_precopy_info info = {};
+	loff_t *pos = &filp->f_pos;
+	bool end_of_data = false;
+	unsigned long minsz;
+	u32 ctx_size;
+	int ret;
+
+	if (cmd != VFIO_MIG_GET_PRECOPY_INFO)
+		return -ENOTTY;
+
+	minsz = offsetofend(struct vfio_precopy_info, dirty_bytes);
+	if (copy_from_user(&info, (void __user *)arg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz)
+		return -EINVAL;
+
+	mutex_lock(&virtvdev->state_mutex);
+	if (virtvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY &&
+	    virtvdev->mig_state != VFIO_DEVICE_STATE_PRE_COPY_P2P) {
+		ret = -EINVAL;
+		goto err_state_unlock;
+	}
+
+	/*
+	 * The virtio specification does not include a PRE_COPY concept.
+	 * Since we can expect the data to remain the same for a certain period,
+	 * we use a rate limiter mechanism before making a call to the device.
+	 */
+	if (!__ratelimit(&migf->pre_copy_rl_state)) {
+		/* Reporting no data available */
+		ret = 0;
+		goto done;
+	}
+
+	ret = virtio_pci_admin_dev_parts_metadata_get(virtvdev->core_device.pdev,
+				VIRTIO_RESOURCE_OBJ_DEV_PARTS, migf->obj_id,
+				VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE,
+				&ctx_size);
+	if (ret)
+		goto err_state_unlock;
+
+	mutex_lock(&migf->lock);
+	if (migf->state == VIRTIOVF_MIGF_STATE_ERROR) {
+		ret = -ENODEV;
+		goto err_migf_unlock;
+	}
+
+	if (migf->pre_copy_initial_bytes > *pos) {
+		info.initial_bytes = migf->pre_copy_initial_bytes - *pos;
+	} else {
+		info.dirty_bytes = migf->max_pos - *pos;
+		if (!info.dirty_bytes)
+			end_of_data = true;
+		info.dirty_bytes += ctx_size;
+	}
+
+	if (!end_of_data || !ctx_size) {
+		mutex_unlock(&migf->lock);
+		goto done;
+	}
+
+	mutex_unlock(&migf->lock);
+	/*
+	 * We finished transferring the current state and the device has a
+	 * dirty state, read a new state.
+	 */
+	ret = virtiovf_read_device_context_chunk(migf, ctx_size);
+	if (ret)
+		/*
+		 * The machine is running, and context size could be grow, so no reason to mark
+		 * the device state as VIRTIOVF_MIGF_STATE_ERROR.
+		 */
+		goto err_state_unlock;
+
+done:
+	virtiovf_state_mutex_unlock(virtvdev);
+	if (copy_to_user((void __user *)arg, &info, minsz))
+		return -EFAULT;
+	return 0;
+
+err_migf_unlock:
+	mutex_unlock(&migf->lock);
+err_state_unlock:
+	virtiovf_state_mutex_unlock(virtvdev);
+	return ret;
+}
+
 static const struct file_operations virtiovf_save_fops = {
 	.owner = THIS_MODULE,
 	.read = virtiovf_save_read,
+	.unlocked_ioctl = virtiovf_precopy_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.release = virtiovf_release_file,
 };
 
@@ -425,7 +573,7 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
 	int nent;
 	int ret;
 
-	buf = virtiovf_alloc_data_buffer(migf, ctx_size);
+	buf = virtiovf_get_data_buffer(migf, ctx_size);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
@@ -460,7 +608,7 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
 		goto out;
 
 	buf->length = res_size;
-	header_buf = virtiovf_alloc_data_buffer(migf,
+	header_buf = virtiovf_get_data_buffer(migf,
 				sizeof(struct virtiovf_migration_header));
 	if (IS_ERR(header_buf)) {
 		ret = PTR_ERR(header_buf);
@@ -485,8 +633,43 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
 	return ret;
 }
 
+static int
+virtiovf_pci_save_device_final_data(struct virtiovf_pci_core_device *virtvdev)
+{
+	struct virtiovf_migration_file *migf = virtvdev->saving_migf;
+	u32 ctx_size;
+	int ret;
+
+	if (migf->state == VIRTIOVF_MIGF_STATE_ERROR)
+		return -ENODEV;
+
+	ret = virtio_pci_admin_dev_parts_metadata_get(virtvdev->core_device.pdev,
+				VIRTIO_RESOURCE_OBJ_DEV_PARTS, migf->obj_id,
+				VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE,
+				&ctx_size);
+	if (ret)
+		goto err;
+
+	if (!ctx_size) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	ret = virtiovf_read_device_context_chunk(migf, ctx_size);
+	if (ret)
+		goto err;
+
+	migf->state = VIRTIOVF_MIGF_STATE_COMPLETE;
+	return 0;
+
+err:
+	migf->state = VIRTIOVF_MIGF_STATE_ERROR;
+	return ret;
+}
+
 static struct virtiovf_migration_file *
-virtiovf_pci_save_device_data(struct virtiovf_pci_core_device *virtvdev)
+virtiovf_pci_save_device_data(struct virtiovf_pci_core_device *virtvdev,
+			      bool pre_copy)
 {
 	struct virtiovf_migration_file *migf;
 	u32 ctx_size;
@@ -536,6 +719,17 @@ virtiovf_pci_save_device_data(struct virtiovf_pci_core_device *virtvdev)
 	if (ret)
 		goto out_clean;
 
+	if (pre_copy) {
+		migf->pre_copy_initial_bytes = migf->max_pos;
+		ratelimit_state_init(&migf->pre_copy_rl_state, 1 * HZ, 1);
+		/* Prevent any rate messages upon its usage */
+		ratelimit_set_flags(&migf->pre_copy_rl_state,
+				    RATELIMIT_MSG_ON_RELEASE);
+		migf->state = VIRTIOVF_MIGF_STATE_PRECOPY;
+	} else {
+		migf->state = VIRTIOVF_MIGF_STATE_COMPLETE;
+	}
+
 	return migf;
 
 out_clean:
@@ -948,7 +1142,8 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
 		ret = virtio_pci_admin_mode_set(virtvdev->core_device.pdev,
 						BIT(VIRTIO_ADMIN_CMD_DEV_MODE_F_STOPPED));
 		if (ret)
@@ -956,7 +1151,8 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_PRE_COPY)) {
 		ret = virtio_pci_admin_mode_set(virtvdev->core_device.pdev, 0);
 		if (ret)
 			return ERR_PTR(ret);
@@ -966,7 +1162,7 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
 		struct virtiovf_migration_file *migf;
 
-		migf = virtiovf_pci_save_device_data(virtvdev);
+		migf = virtiovf_pci_save_device_data(virtvdev, false);
 		if (IS_ERR(migf))
 			return ERR_CAST(migf);
 		get_file(migf->filp);
@@ -974,7 +1170,9 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return migf->filp;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
+	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
 		virtiovf_disable_fds(virtvdev);
 		return NULL;
 	}
@@ -995,6 +1193,24 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return NULL;
 	}
 
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_PRE_COPY) ||
+	    (cur == VFIO_DEVICE_STATE_RUNNING_P2P &&
+	     new == VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
+		struct virtiovf_migration_file *migf;
+
+		migf = virtiovf_pci_save_device_data(virtvdev, true);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		virtvdev->saving_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		ret = virtiovf_pci_save_device_final_data(virtvdev);
+		return ret ? ERR_PTR(ret) : NULL;
+	}
+
 	/*
 	 * vfio_mig_get_next_state() does not use arcs other than the above
 	 */
@@ -1098,7 +1314,8 @@ void virtiovf_set_migratable(struct virtiovf_pci_core_device *virtvdev)
 	spin_lock_init(&virtvdev->reset_lock);
 	virtvdev->core_device.vdev.migration_flags =
 		VFIO_MIGRATION_STOP_COPY |
-		VFIO_MIGRATION_P2P;
+		VFIO_MIGRATION_P2P |
+		VFIO_MIGRATION_PRE_COPY;
 	virtvdev->core_device.vdev.mig_ops = &virtvdev_pci_mig_ops;
 }
 
-- 
2.27.0


