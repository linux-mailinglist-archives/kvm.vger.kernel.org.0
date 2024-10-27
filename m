Return-Path: <kvm+bounces-29760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4E79B1D1F
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 11:09:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 40467B213AC
	for <lists+kvm@lfdr.de>; Sun, 27 Oct 2024 10:09:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34CAE13B2B8;
	Sun, 27 Oct 2024 10:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="q6viJrRy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCE713D8A4
	for <kvm@vger.kernel.org>; Sun, 27 Oct 2024 10:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730023747; cv=fail; b=KpU167lYi7WO1QINvcFn8WXOSwrcaGJenyZugur9EobX/cGeWPT3z/Fw+OUZ6jXueaYAiyh5XwgX+xWXWoSwlZ10EzfioardK0JE/j8JkoW7hLyoL9rz2jdhQzp2PCfgqwwyKB8xMREkd4ZYvqiAxfD7FZXuZxB5ZZQYl01Vi24=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730023747; c=relaxed/simple;
	bh=NithwI9lqZMT2yMSu5AY/M9xgeX99wT0BsOgSFqZrVA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FMTtLOOG8sqoOydQTwkD70c3xvZVNwM2xiuS5xLqPQxN74uWpDSLU07+KNkYCEB7d3e0ad/q0ok5v31hGtMYnU7Hnm+6BvXY/dzgbqoPRuo7aIdBtRlNVjES96FWDpfoqNRxJWW0ekouJc+yjKTO9lOvwlu1uWAkv6jelcYHWos=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=q6viJrRy; arc=fail smtp.client-ip=40.107.243.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v0mrsd+XdNbir+y+th3e6UE+9NUwGFL97EztQ9kp8InE7jT4uIghPWgph6gKhOx9UqO9j1JlU/FqPyaQhKrBguw0E59grvPcF7QzQVopq/paK3fQ0hVDPvMeyTjyZ2Eh2pt38vj9lnVdyZDmAVHKa/l7Q/6qOlLRGwNaP98TtowMFOBd92B3KIn5sLmw2Xj0h4p+FXNddqas4EYFMC/fdwgytQaGsP3SYrUvKwUVugrmwBvO9NH6v80d5BrEHy94CKFdohffMfyq45fsMeF3fiRUIgE680ebUezDHIPOx1kpfajYswcyjF7I6D3vUe31qy7vDX1pLvxvwrw54ETSMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aucsb7yXmrn2MyiDvxsygKs2xdyO9YbH3ifOO1CWnIo=;
 b=CpjePqpJGaGtBtApt9MF85rHDJbqAM0IpDeZiPHAYyNvG/6cjsMy0yVnyAIYZ3Nl5UKLzerw7QuS+G2T+YxLwsrEu3+6Zk4fZj7RRtql3PqrEMBeni0XoJsZj3mn6EchejoNnUsDuDXgeXOjjW7UMVWoA1ZOFvp0rJg8qnZXgiCEAjTByHjTEt146p1siF/4KBbNBWd5o52tex8rIn/xWCEr0tKuhix0j5hMCy8gNYPs0aiAlsVrRc4s/4E8Dk+tcgb6qBAhrh8IV2FsAAW0fFJugpp0fUMiPeTJC8NX7zfo3eOHonofXVv8Ov0IvND5OEYsgaMQ3h5bTdGdsRs6Mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aucsb7yXmrn2MyiDvxsygKs2xdyO9YbH3ifOO1CWnIo=;
 b=q6viJrRyb3HUZ4gCcg59BPK6v7gHRbeA0QJniR1n+PJ05mM8pPmrkrEmiiVsSClTqbQPCy4qghLlk59oh+rxJO0aeSXe4ybjpRgQztw5UP+TqPbXZKydJ2tPIC0Ipzcc07xxO0vxvWQTzdA48zKu6wO6JmW/fBRBHigH36+aCVHhMtFU4Dmhe+0kJG4JCwj3we06daOJjED3G0hLApC1p/A86l4L4tEmfWZkzTax5ndDC8vZIo6MAd/rSCGyhctPqaucNXUYcymgxPoXABVMpQLePNvh5fua23f7PKo2oh9ntc+sYXEq2/wKtHIgO0tlRnu0BDMeRxXer/C+z7jdsQ==
Received: from MN2PR08CA0020.namprd08.prod.outlook.com (2603:10b6:208:239::25)
 by CYYPR12MB8870.namprd12.prod.outlook.com (2603:10b6:930:bb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.21; Sun, 27 Oct
 2024 10:09:01 +0000
Received: from BN2PEPF000055DE.namprd21.prod.outlook.com
 (2603:10b6:208:239:cafe::14) by MN2PR08CA0020.outlook.office365.com
 (2603:10b6:208:239::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.24 via Frontend
 Transport; Sun, 27 Oct 2024 10:09:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN2PEPF000055DE.mail.protection.outlook.com (10.167.245.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8137.0 via Frontend Transport; Sun, 27 Oct 2024 10:09:00 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:42 -0700
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 27 Oct
 2024 03:08:42 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Sun, 27 Oct
 2024 03:08:38 -0700
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH vfio 6/7] vfio/virtio: Add PRE_COPY support for live migration
Date: Sun, 27 Oct 2024 12:07:50 +0200
Message-ID: <20241027100751.219214-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241027100751.219214-1-yishaih@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN2PEPF000055DE:EE_|CYYPR12MB8870:EE_
X-MS-Office365-Filtering-Correlation-Id: e092544a-725a-433c-4664-08dcf66f60bd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|36860700013|1800799024|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0dMOkEuUzAQ4dbrmpUvw1zjOgfhPazL6dKIkaQh8VZV6M0YHXMDOIqKcrnHl?=
 =?us-ascii?Q?QMMOQrotfs18znbnucUuc1+kX4a3VqvcTmgoLjZzWUubhbQD4YiJIMQG7O2F?=
 =?us-ascii?Q?zGohPYAg4BMEu28yfW0T8+g+oj4a92mwjrQ2Bz6NnVvFm0Irlk8TG4kBnE/l?=
 =?us-ascii?Q?zyJR9NQkeZCIjUbKasnOd1xWYXaFybejdQV6Kj2+Z8l7DLtixc1RpkqG33IF?=
 =?us-ascii?Q?qRhnLEpirmHhEE8NGFlWtMFT8mDXtcOLqJXYZYXQWy12epqb+Qk2PoaSVg6m?=
 =?us-ascii?Q?/6Tpu8uFHJEU3VfDGYMSXNMK/M2HQBY67lTV8Rt5c3eHosYaEH4l3BtVwhxv?=
 =?us-ascii?Q?RpfrRu87xl/mWgyq2yjs+B/GR3TmbXDXt4l4lRLft14PIUDDSdWP348IGY53?=
 =?us-ascii?Q?UycGRUL3xd/GDTkyBvd4bHPdccK6+im5+v7gqmP8u7gKa9Vwk7gneLR7hOeg?=
 =?us-ascii?Q?tsvFOscfvyzeWzZ8v341moQrF7JA2QMFJuce+8XE+7cxXeSIQmJPp9Br/j0o?=
 =?us-ascii?Q?Rv7w6KVeUNQKDg6EPl+Lm3Ont/HMRlNTazrrXALdaTg9Qn4d/4IA+zfkCIB4?=
 =?us-ascii?Q?hxvQA3B1q+BWndEbiy6VirMcmOASGoQfdB1PT2+ct/k/kQ4DUUJCI8ggsuqh?=
 =?us-ascii?Q?RpMC9RoewvZS+EtGVoGIfAlfiINjfUPLU6DTsZS+ayGkWSNETCxWv77JhWgr?=
 =?us-ascii?Q?um9N1tGkW1TWysfg01x5KedVnItakBIlYZ5zFiqf7Z7/TLTsLIcG5LKarGp1?=
 =?us-ascii?Q?1zPjIGB4yoqwly0+7BeXvoudMrUE0M42EuMt/vvKsLr1mtgFtT3GaUJxTqrF?=
 =?us-ascii?Q?bKZTGRfnQsRs/l0fPUqhTPKFArrtRybEbdeZLWMlQq0nt2ngtgILktyBi8x4?=
 =?us-ascii?Q?yyC+6IaBB8WthLRXEsu8qxEY1Pcx0moW8cEEWg723b6O02m1BBe1Q0XK0kvZ?=
 =?us-ascii?Q?IP7VvJ3umrXn+3CZBTKKuYcJdVVu3+3s9PqfRVk3f5oI5CsTt253vAggw3O+?=
 =?us-ascii?Q?3PsfNUzS4tFdlQny5Ab/qznF9JaNFXBNEcBkEN/8qBBGD1LTp/h8RukHuFDY?=
 =?us-ascii?Q?xICt3L3dhH2gJ3vJ/ZemxnT2/91zfLKOfcIwg9L2PM23pOi7QfMLzlZ+a+Sr?=
 =?us-ascii?Q?o29URRV53vRgjEKsNex+9D17JlkInAQtsbEWULv7L6wK2qsvMmwgsx83m85v?=
 =?us-ascii?Q?MpHZQ21mHmlkQ9RbxRfaOPWzpz7HIbuxQStRiyl0Sx3CcRJp1G+b37iEVxgr?=
 =?us-ascii?Q?ClNeNU7Ehl2Kdm5UuwwZZeQiNc8pHUmSltFRKGvpegBpoZV3XCqZYPYNJNa6?=
 =?us-ascii?Q?Z6YZ7fCqVdUXpn7Qtjkw7t3wYwvlVdl+FKvWT11vj7m5HG46G0pdkqyUAgRE?=
 =?us-ascii?Q?EjqiLqANVnWDk8TD1NYxfP73V3Pb260DPcUfi54Jya8iaqyRMQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(36860700013)(1800799024)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2024 10:09:00.2400
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e092544a-725a-433c-4664-08dcf66f60bd
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF000055DE.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8870

Add PRE_COPY support for live migration.

This functionality may reduce the downtime upon STOP_COPY as of letting
the target machine to get some 'initial data' from the source once the
machine is still in its RUNNING state and let it prepares itself
pre-ahead to get the final STOP_COPY data.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/pci/virtio/common.h  |   4 +
 drivers/vfio/pci/virtio/migrate.c | 234 +++++++++++++++++++++++++++++-
 2 files changed, 231 insertions(+), 7 deletions(-)

diff --git a/drivers/vfio/pci/virtio/common.h b/drivers/vfio/pci/virtio/common.h
index 3bdfb3ea1174..37796e1d70bc 100644
--- a/drivers/vfio/pci/virtio/common.h
+++ b/drivers/vfio/pci/virtio/common.h
@@ -10,6 +10,8 @@
 
 enum virtiovf_migf_state {
 	VIRTIOVF_MIGF_STATE_ERROR = 1,
+	VIRTIOVF_MIGF_STATE_PRECOPY = 2,
+	VIRTIOVF_MIGF_STATE_COMPLETE = 3,
 };
 
 enum virtiovf_load_state {
@@ -57,6 +59,7 @@ struct virtiovf_migration_file {
 	/* synchronize access to the file state */
 	struct mutex lock;
 	loff_t max_pos;
+	u64 pre_copy_initial_bytes;
 	u64 record_size;
 	u32 record_tag;
 	u8 has_obj_id:1;
@@ -90,6 +93,7 @@ struct virtiovf_pci_core_device {
 	/* protect migration state */
 	struct mutex state_mutex;
 	enum vfio_device_mig_state mig_state;
+	u16 num_pre_copy_calls;
 	/* protect the reset_done flow */
 	spinlock_t reset_lock;
 	struct virtiovf_migration_file *resuming_migf;
diff --git a/drivers/vfio/pci/virtio/migrate.c b/drivers/vfio/pci/virtio/migrate.c
index 2a9614c2ef07..5ffcff3425c6 100644
--- a/drivers/vfio/pci/virtio/migrate.c
+++ b/drivers/vfio/pci/virtio/migrate.c
@@ -26,6 +26,12 @@
 /* Initial target buffer size */
 #define VIRTIOVF_TARGET_INITIAL_BUF_SIZE SZ_1M
 
+#define VIRTIOVF_MAX_PRE_COPY_CALLS 128
+
+static int
+virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
+				   u32 ctx_size);
+
 static struct page *
 virtiovf_get_migration_page(struct virtiovf_data_buffer *buf,
 			    unsigned long offset)
@@ -155,6 +161,41 @@ virtiovf_pci_free_obj_id(struct virtiovf_pci_core_device *virtvdev, u32 obj_id)
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
@@ -217,6 +258,7 @@ static void virtiovf_state_mutex_unlock(struct virtiovf_pci_core_device *virtvde
 		virtvdev->deferred_reset = false;
 		spin_unlock(&virtvdev->reset_lock);
 		virtvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+		virtvdev->num_pre_copy_calls = 0;
 		virtiovf_disable_fds(virtvdev);
 		goto again;
 	}
@@ -341,6 +383,7 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
 {
 	struct virtiovf_migration_file *migf = filp->private_data;
 	struct virtiovf_data_buffer *vhca_buf;
+	bool first_loop_call = true;
 	bool end_of_data;
 	ssize_t done = 0;
 
@@ -358,6 +401,19 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
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
 
@@ -379,9 +435,103 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
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
+	virtvdev->num_pre_copy_calls++;
+	/*
+	 * There is no PRE_COPY concept in virtio spec, prevent infinite calls
+	 * for a potenital same data.
+	 */
+	if (virtvdev->num_pre_copy_calls > VIRTIOVF_MAX_PRE_COPY_CALLS) {
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
 
@@ -425,7 +575,7 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
 	int nent;
 	int ret;
 
-	buf = virtiovf_alloc_data_buffer(migf, ctx_size);
+	buf = virtiovf_get_data_buffer(migf, ctx_size);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
@@ -460,7 +610,7 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
 		goto out;
 
 	buf->length = res_size;
-	header_buf = virtiovf_alloc_data_buffer(migf,
+	header_buf = virtiovf_get_data_buffer(migf,
 				sizeof(struct virtiovf_migration_header));
 	if (IS_ERR(header_buf)) {
 		ret = PTR_ERR(header_buf);
@@ -485,8 +635,43 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
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
@@ -536,6 +721,13 @@ virtiovf_pci_save_device_data(struct virtiovf_pci_core_device *virtvdev)
 	if (ret)
 		goto out_clean;
 
+	if (pre_copy) {
+		migf->pre_copy_initial_bytes = migf->max_pos;
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
@@ -974,6 +1168,13 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return migf->filp;
 	}
 
+	if ((cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
+		virtvdev->num_pre_copy_calls = 0;
+		virtiovf_disable_fds(virtvdev);
+		return NULL;
+	}
+
 	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
 		virtiovf_disable_fds(virtvdev);
 		return NULL;
@@ -995,6 +1196,24 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
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
@@ -1098,7 +1317,8 @@ void virtiovf_set_migratable(struct virtiovf_pci_core_device *virtvdev)
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


