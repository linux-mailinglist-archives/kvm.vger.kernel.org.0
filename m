Return-Path: <kvm+bounces-31596-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EC73E9C50FD
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:42:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DAA11F23032
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 08:42:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66BF620E328;
	Tue, 12 Nov 2024 08:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rvjfPYEh"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7926A20DD4F
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 08:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731400744; cv=fail; b=P/pXoWWnis5p4M30pnZpJ8s58qXiPwLJkt3UCnIWgkpqxw+728jp9G+jUPVnmMoNKvLhWlcLUvaL8mqGOO5EVilUivt3kaExqNWaNqRFn1DZzR8wFTgrFHCtaPg11wHBxZJQ/7gc6t/vITyGw98NM2EPPR8Wt1JMcPWQTBl55BY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731400744; c=relaxed/simple;
	bh=sJuOYMXDIuSbq9w5xKvDGObmCVc6TuLJzcQfiZLPFq0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sYNWbyNOQewY/7fg0zZVFa835R+Zcl7Ix+DVzuBoLms+beyebBydX9GZHBlQwy1UAIJcds1NCki2V2ekZXO54azv2dmWPHFlEel8h7h6lZyRg6w1vSO37ZSVZ1P5DajOkd8MdLJskhRLUoSCmw+nN971QUYPTgx5wFThogMPGPM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rvjfPYEh; arc=fail smtp.client-ip=40.107.236.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fErCKTfbUpFh+8jO6kS0UdhDX49NHBhpX2AKMCorZJq71Wtwn9vLmE+3whvTBESXR289vk3iW/fwUsF5TSJdPG8kB63ZpviGOKzwoaqcGbxe8sNcWUrHU2GApOM5aSl4YqQX4ureNC6uw8+YFXY7tuJxvCPDYfPvUTxVdkxCyUP7oMX/5Bpad+A+jC9xiWEzjm2C5JnQPYVf+XF7NtSjpEY06FuUttsybGlCCx06nZohNm0tOPoIg8ZpgRUGvYKH3OJ+fZUS20w1YUPzQThjlByaGTkOadvUuyPh6uI3VgDSMEOlG+5m9Szh20nPRIrmQJjiHzIfBdpT9fkJNVjmfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nUgMiQEwGrniVi1wVBLHMqNuqqEeCW5GdVnih0vXrI0=;
 b=lgI6pv6PbK7y8QtnVFHJYmZAME21K5sQDRR7SzXoAkA8gIjP6nuhqgYPV9MiNGYoADMFXQQ/WmeMMM16TpcW1VQUGpIBv0FYJZzJJoFoqYt3Tl8SGiT1CRvLPlN+OVIUf3ZoCjNN8I5PhWBdZaPRpCy8Qjn+/VcwaQLPj69s3GViYcygTc7Pbmdy5sN3eoCKCmiZJRQVDQy71aQoy3U8Oo639TlJQp4Zat3IMc1fSIDO+8t7jgKWhjmRwfb6OrrsyEX9IXDqx5KTPFQeAWiqoisMGjOLUvxfRhE2D6m4qXsqHXkY2N1M+GkSRyjbsY/aJixUu3vDJO6vIT7m3WYUZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nUgMiQEwGrniVi1wVBLHMqNuqqEeCW5GdVnih0vXrI0=;
 b=rvjfPYEhoGKprehzhGTTujtn2kw/QVuEAmlf14Ysb1ZafaKz/3i+PFyclLtVkvvzWHiYazO5BsSRgieDTWzvay7vSmOtk1eufO5JlSj/aZ+MVZIVIur4hQ7Cs12mAjEZ8kmlJ074y29ZPXazWSbjIUXk9q9wLUfj5Pt4BPsB3UdvbnWl+X4yQ7KVHk4e98PP+nCvJvJyEqLfPWrDhjGD2HtxeDgcQv2pgfjx6Zi98gkbl8maxAorJsXpi00PjJQyG0x0uJNQsK87QHq90y6kys87tGu9ouaPzyl0aAdfTgvEEugASlyDn6Iwgm/geH91PUo91u8g0fvsizCl2kwITQ==
Received: from MN2PR03CA0003.namprd03.prod.outlook.com (2603:10b6:208:23a::8)
 by IA1PR12MB7734.namprd12.prod.outlook.com (2603:10b6:208:422::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Tue, 12 Nov
 2024 08:38:56 +0000
Received: from MN1PEPF0000F0E1.namprd04.prod.outlook.com
 (2603:10b6:208:23a:cafe::81) by MN2PR03CA0003.outlook.office365.com
 (2603:10b6:208:23a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28 via Frontend
 Transport; Tue, 12 Nov 2024 08:38:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 MN1PEPF0000F0E1.mail.protection.outlook.com (10.167.242.39) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Tue, 12 Nov 2024 08:38:55 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:40 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 12 Nov
 2024 00:38:39 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Tue, 12 Nov
 2024 00:38:36 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V3 vfio 6/7] vfio/virtio: Add PRE_COPY support for live migration
Date: Tue, 12 Nov 2024 10:37:28 +0200
Message-ID: <20241112083729.145005-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241112083729.145005-1-yishaih@nvidia.com>
References: <20241112083729.145005-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: MN1PEPF0000F0E1:EE_|IA1PR12MB7734:EE_
X-MS-Office365-Filtering-Correlation-Id: 28b5747f-aa6f-48ae-9d6a-08dd02f5720b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zT2Q1QBCQzkpvhAIHQYXb5rinp9IJxcok0kGEcIO5klbAmwZWiGC3zRCe2Au?=
 =?us-ascii?Q?F3OTQ3r1s2sGmWemkFnHeqk/ZBjiFNH/p4MbAVyDK+nRVwpaxS5P6MvymbKj?=
 =?us-ascii?Q?hTRX2fGkF3v1nVQql+BcDO4NtC7Sc7dGknbh1IUbflKKpZDfiC5Y/DEzxrTw?=
 =?us-ascii?Q?qgvShVSyF39BVENtqq4n/ocYclJqB9WQD5j9WDHF/h3CVQUcZW3HZ6PnPHdM?=
 =?us-ascii?Q?uBIyD5PgF8nauCoL560hPHBJ7I3eeLlA01qdmYFLrKhWyRu+pyLh767CfzKP?=
 =?us-ascii?Q?7ux9vk0VmRo78srywGLadfyMuCpAbKw7yb9koq9+TLSER+anh0n403YySDxL?=
 =?us-ascii?Q?YdAYW9auwjYvw0ZLRAiglgj890MmaxeToz8qB5hb6eAfHAE0OA4XvBtsdkEs?=
 =?us-ascii?Q?72cVFTS+xr+2n1IRfuLEVF/lhJQ0Q/6ffpWuAse0NdlksGk1HDJYoM/PYedA?=
 =?us-ascii?Q?9XDa1TulfNAVH6chKhdhugcIk8nLFPl+9zMUDjn/E+gJ5txQZKtz42MqlpwT?=
 =?us-ascii?Q?lfFr3c+/X9zk9WiD8qDRJsAKhL5ipw4QQP4JzMcochp0Nt8DhA0Z0mtrPpop?=
 =?us-ascii?Q?Co5tBWQ54PG/KaRpFeAuOdg5h7dbYShupYIIMtApihjy3tY7n3+kOdxbwV9R?=
 =?us-ascii?Q?wvxCHWkMTHhmn9fIiSfZvjRC6gYcZtkS5RLbIPQLIrWhHgD19z/c+RYH9av9?=
 =?us-ascii?Q?l10adJEmudIZvz9F3VMEbASwXVXTCoHDtSXpsQFQ5kjXJEa9AhHM70FiJXhw?=
 =?us-ascii?Q?u1ExMvHCdo/gdusqlBljuUL3CxUXQo/u2q7sgKgkYfzjOjhcxDwx0fTjRkUB?=
 =?us-ascii?Q?GH68oQNqip99VgEFtyanOwwfYIqrWBz/J/1ZjI8eGW/5dfk4bZXB51wA46wd?=
 =?us-ascii?Q?CtckLplo1NwgA2QeI5pzyzpYuRDXbXXg5j9ZBmqLjVIushqdnSeyrMJcVvf/?=
 =?us-ascii?Q?WnM+dZ8RNqbR9zxNs5M7V3RNmUaShKahWI2fIbauO1rf7OWDN4B7Iy1jgmhQ?=
 =?us-ascii?Q?avMutBnCwcliKPgMUUGAlAiTlThJEIFTljuootYHukscGBKL/5NI1f/gO8bZ?=
 =?us-ascii?Q?sFWL5nEmNXQk/PqIYFzckSU4sJMFqKiImqSuMmCDQn5lmcv8wzbI5SV0NP4R?=
 =?us-ascii?Q?/5notfwdGIhZOq6HlP77TB6oJGDK3tXYQeYNJKb8HjmhEDohIF5ojdoJIgDb?=
 =?us-ascii?Q?0BkqgpEqZ4TGhEm7aF3LaF/VIRz4DCHxyg/YMa14a9zstA5XxuRfCZEdpNyS?=
 =?us-ascii?Q?3a3x3sNd06+ay7tsIBcnlZKBrnAoExjqmpV5JTdiOxcAvdvW+536/CWMjS1b?=
 =?us-ascii?Q?08AJkRAttkL3Dn0iww6O4szwjE6r+kETeO6Ixo0YGPqOpipCEwxQ5F1H+gPh?=
 =?us-ascii?Q?mAz1Y5JqMR3NQ3llGdMHu/WqLcHzi0rIUkArx6BqwX8suVofhA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 08:38:55.8054
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28b5747f-aa6f-48ae-9d6a-08dd02f5720b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MN1PEPF0000F0E1.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7734

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
limiter mode.

This means we avoid reading new data from the device for a specified
time interval after the last read.

With PRE_COPY enabled, we observed a downtime reduction of approximately
70-75% in various scenarios compared to when PRE_COPY was disabled,
while keeping the total migration time nearly the same.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/common.h  |   4 +
 drivers/vfio/pci/virtio/migrate.c | 231 ++++++++++++++++++++++++++++--
 2 files changed, 227 insertions(+), 8 deletions(-)

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
index 3d5eaa1cbcdb..70fae7de11e9 100644
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
 
@@ -379,9 +432,101 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
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
+	u32 ctx_size = 0;
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
+	if (__ratelimit(&migf->pre_copy_rl_state)) {
+
+		ret = virtio_pci_admin_dev_parts_metadata_get(virtvdev->core_device.pdev,
+					VIRTIO_RESOURCE_OBJ_DEV_PARTS, migf->obj_id,
+					VIRTIO_ADMIN_CMD_DEV_PARTS_METADATA_TYPE_SIZE,
+					&ctx_size);
+		if (ret)
+			goto err_state_unlock;
+	}
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
 
@@ -425,7 +570,7 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
 	int nent;
 	int ret;
 
-	buf = virtiovf_alloc_data_buffer(migf, ctx_size);
+	buf = virtiovf_get_data_buffer(migf, ctx_size);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
@@ -460,7 +605,7 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
 		goto out;
 
 	buf->length = res_size;
-	header_buf = virtiovf_alloc_data_buffer(migf,
+	header_buf = virtiovf_get_data_buffer(migf,
 				sizeof(struct virtiovf_migration_header));
 	if (IS_ERR(header_buf)) {
 		ret = PTR_ERR(header_buf);
@@ -485,8 +630,43 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
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
@@ -536,6 +716,18 @@ virtiovf_pci_save_device_data(struct virtiovf_pci_core_device *virtvdev)
 	if (ret)
 		goto out_clean;
 
+	if (pre_copy) {
+		migf->pre_copy_initial_bytes = migf->max_pos;
+		/* Arbitrarily set the pre-copy rate limit to 1-second intervals */
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
@@ -948,7 +1140,8 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
 		ret = virtio_pci_admin_mode_set(virtvdev->core_device.pdev,
 						BIT(VIRTIO_ADMIN_CMD_DEV_MODE_F_STOPPED));
 		if (ret)
@@ -956,7 +1149,8 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_PRE_COPY)) {
 		ret = virtio_pci_admin_mode_set(virtvdev->core_device.pdev, 0);
 		if (ret)
 			return ERR_PTR(ret);
@@ -966,7 +1160,7 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
 		struct virtiovf_migration_file *migf;
 
-		migf = virtiovf_pci_save_device_data(virtvdev);
+		migf = virtiovf_pci_save_device_data(virtvdev, false);
 		if (IS_ERR(migf))
 			return ERR_CAST(migf);
 		get_file(migf->filp);
@@ -974,7 +1168,9 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return migf->filp;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
+	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
 		virtiovf_disable_fds(virtvdev);
 		return NULL;
 	}
@@ -995,6 +1191,24 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
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
@@ -1099,7 +1313,8 @@ void virtiovf_set_migratable(struct virtiovf_pci_core_device *virtvdev)
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


