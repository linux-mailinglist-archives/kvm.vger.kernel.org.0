Return-Path: <kvm+bounces-31733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 557489C6E5B
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 12:56:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 15FE2282056
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2024 11:56:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71E92204085;
	Wed, 13 Nov 2024 11:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RZcp7tcz"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2081.outbound.protection.outlook.com [40.107.95.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8802E200BB7
	for <kvm@vger.kernel.org>; Wed, 13 Nov 2024 11:53:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731498800; cv=fail; b=onyYNBoOuhq/32a8f8f+NS87q6IEx1GwGkFLrPOhJjaM5JpdkvJESKJg1eX/bBtzU5a5VKfjoaoLyUgwavkdmoOHCFyNdiZalT8Q0Hy9HSz6r667SUbBUSMUzb7pcW52GlQouQOo7hLl7SNwcbHjNkyK0y7yFzze8cQwdwxfIk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731498800; c=relaxed/simple;
	bh=d4NeShO7HPOXJm6RhFybNnlrrv0ukDGO62E8Td5I8JA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lwhLazqH+pLXIlfv7TuPHTodbC82km1OWhP1xBe9iejCgUJXO7l+kFfZxw6YZ5qv6RMkro1iEDEve/j535UL8jsiJ16JWg8RqGQCtyi++37xAFU7zilr7/6ho4IaRBJfLCdZ9aGvTZgIDbm3bddO2MM8kriEUqall8bDNDckNlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RZcp7tcz; arc=fail smtp.client-ip=40.107.95.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R45axS/SrM5KqTMfsqVjZABbk2NUX+qXm8wGCuLXZNSJ8RH4Q+jaoaIFVRSCtkIwOAkJwIXfYpv7ENKc3gswlhoXkaJWHOGJGj/s3nSoh0p+5gU+RpmmlpUkyObUBwFGlKHXTpwWWn0+p2aU4/FbfpKk6mgg17vzSI/KBGBL/09M8PeMk9oQfjdADV4cll6ld78E9VY5PAVeXiuxcRn4gExlhEKTFsJA4fjU9fDiVBaKOo3JnGdQCQo9S5kDCz5TFw6feaWsAGQUF3ya8Z8lPXpfgfXPt1QUZJmgzVDclVTU0jQKgPO5bd+owDwUjduCDBufTSZVetX5nrl268DPFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gaLxBHoEuZQusQH5NsyiMZLrFAryQDb/f8Y9Qhs/gFA=;
 b=kAtRblGZ+evkA3UatJzDhVfLGWTu+7133w44N6ithwxRUuPxZsnnnJ7CJ7DvyVWJya+iw4gZqA3ffjTQbwdS75k/c/Z8KKw5dFT23P8AZZqhq2krzYGAmaCjrIakkv667mdvldf5mWgY8i3gc+ChsH10t0rDoF+XUbOYrUq2yORFvCiafUdIcvs2GUNiOQC9pGiNU2rDNoyeqpJ2TzyBp5J0A8NZ+nuGZ9tRAyLrvL/i3UW034upm0XOTsBTMCpgotaU0X+FxH74vCAWngCENMJU/QA4gPj11nKvk9/BIfM6YOCDLYsNfwhD5ceDeZVs+m6GW0RfyUg2dzi7zhKtEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gaLxBHoEuZQusQH5NsyiMZLrFAryQDb/f8Y9Qhs/gFA=;
 b=RZcp7tczeF9T8Qemc6EMcyiBjew/dvOnsB8rnrQCx8eX6LkBQLYUKPOikSoyRUcH+SpUirT6dpEigNf/MWB/dP0M3ijoIG2SZcsXeRbzogTq171V7MMQTmJP25TuSAmoI2J5a3yFBDKB3hRNojaRnCrpHYsxZeI1ZJmgLRgxaEaLRoVIPb2obdsUcOY9j0Z+aORcQ/+arLSP4/wWBBgynbNLPBtAPcZpFiJLgLL9rLsw3YndeXsyO4UhHxtQdiLWLm6NJl5L9PN2OlpP5Cb4crMuKZTtzrMhvezyoaciPJdp117yUMseTyAJx8DnTZFSGLYKrCj1qA7fYOh2M+CazQ==
Received: from PH7P221CA0037.NAMP221.PROD.OUTLOOK.COM (2603:10b6:510:33c::9)
 by PH0PR12MB8126.namprd12.prod.outlook.com (2603:10b6:510:299::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Wed, 13 Nov
 2024 11:53:15 +0000
Received: from SA2PEPF000015CD.namprd03.prod.outlook.com
 (2603:10b6:510:33c:cafe::92) by PH7P221CA0037.outlook.office365.com
 (2603:10b6:510:33c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.16 via Frontend
 Transport; Wed, 13 Nov 2024 11:53:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SA2PEPF000015CD.mail.protection.outlook.com (10.167.241.203) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8158.14 via Frontend Transport; Wed, 13 Nov 2024 11:53:15 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:53:03 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Wed, 13 Nov
 2024 03:53:02 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.1544.4 via Frontend Transport; Wed, 13 Nov
 2024 03:52:59 -0800
From: Yishai Hadas <yishaih@nvidia.com>
To: <alex.williamson@redhat.com>, <mst@redhat.com>, <jasowang@redhat.com>,
	<jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
	<parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
	<joao.m.martins@oracle.com>, <leonro@nvidia.com>, <yishaih@nvidia.com>,
	<maorg@nvidia.com>
Subject: [PATCH V4 vfio 6/7] vfio/virtio: Add PRE_COPY support for live migration
Date: Wed, 13 Nov 2024 13:51:59 +0200
Message-ID: <20241113115200.209269-7-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20241113115200.209269-1-yishaih@nvidia.com>
References: <20241113115200.209269-1-yishaih@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SA2PEPF000015CD:EE_|PH0PR12MB8126:EE_
X-MS-Office365-Filtering-Correlation-Id: 19b8d9a5-c956-4f6e-f4ac-08dd03d9c217
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gpyejFN6oVGO+zoPgocJQBdbsZ2S2fVr/gJrolVxlK8d4SmzVRBYD/xVRRID?=
 =?us-ascii?Q?yrmjaTOUiCCKEekLCrpX4ljQBQPY0iEvf+1ixUOYIdwipZ71Uq2eKxGGraWY?=
 =?us-ascii?Q?2ulnNDPdgOK7vb8J3QwlCrL7Yh2ywX4UL6Kx33wsOKQCvmuVcNhYhYnHn4fN?=
 =?us-ascii?Q?MZ2aIiBgonRKTuKZ5mqYgRIJSlQZf//zBm7s15CYGl7VORaN4lzLLwlj0glk?=
 =?us-ascii?Q?b2D4e3ppCqjF+1odzvBDuEGjFyBXV1rHgERYNtZV0uyToxfVHlRBCkdjebQL?=
 =?us-ascii?Q?YL6W2hpt6/sw6Vc2vr79ArXpwIeHDl6//XceLHWLLcJVlB6K9odERgs4qC14?=
 =?us-ascii?Q?l4uHZoVn1Z+QYZLl02g7qGxqbbpsALCaZa8gqhPYtnWBmCrrVUxETZ6FBl78?=
 =?us-ascii?Q?iGiAhYG9ZPM3h+2drNkkG3akpeJs/UNh6AKl2swyYweq9f+W9P7RYk3KTXv9?=
 =?us-ascii?Q?AFYjH+TqXHp3bcYhfoxoxN23PNs7hI8z0vjbSwKKWeFWmkti9q8JHEJHWc8m?=
 =?us-ascii?Q?MLOWo50mSH5wD+swa+yRNvTvdtmUrd95rPQZ4tkPUAWZ12oajyvzViEvnjAk?=
 =?us-ascii?Q?AjMRRYYF+Z9lihzyDjckqyFWKNY65D3Cpgsm2d8DG5bGwkg6c+DH67boCHlS?=
 =?us-ascii?Q?6McE53QkHFSlEjQeusUfR2WQA3Nn1zkIIxhg9rHrlF+2QhWeW6AaJXpI36/M?=
 =?us-ascii?Q?nBo7cCACQYUU11oNnTBgwJe8ZdFoI2LeRbL7qAiOAl5DKbsh2NAYOIopbKTa?=
 =?us-ascii?Q?YYvJQtzPVNfGXXfblY5ti9aZiRIeCqN/68COR1Yu4jD9Y2SZFMG/gCtutvH5?=
 =?us-ascii?Q?kLetUfQhI9XkKex5HjLQV9qLTk4NO9PXP1g6E9YB6DSBd3YodW1PYXNw+hhw?=
 =?us-ascii?Q?P883cCraVMMaY5chVNsCRX/umvJg8sQwG3UmaObwmu3snyrQWGCeYGqKaGrH?=
 =?us-ascii?Q?CR0iEBaQcZO/ZxcWmfIhthhI1MHS3uOBjZMY3AR2FcOFJijoYx5Gd2lJOLYj?=
 =?us-ascii?Q?uCja0Ji/13Lm8dcEYMEpILHCaD5ths6YQcKX6xbJgDOArQYwtsHlP8WbfUiD?=
 =?us-ascii?Q?QtFm9zkEp+6K+C/JRihzzB0r2CRuwDuyzEVbOZbmZJZGGBYmAhE/vr084z9m?=
 =?us-ascii?Q?3SpX1xk2bevf6ETzKy6HlV70/MXxGjlczjQ8XrQ1GCe4Dxlcwffg/sglGRiu?=
 =?us-ascii?Q?SZp5bvdz5/Y7aqEB4ZLd9vPmjV6CysYiETHUfoSi1otmGbSsljrWk9l4sTnO?=
 =?us-ascii?Q?12Pc8RBPRk0hleBKZkI1TDDk2eNF7UO7SbVBDOURxhrFBTSFaE2ugnzsfYSE?=
 =?us-ascii?Q?F+LUCHVM3gT/tvqev71SGMgOxKSyZ23Yb1OUbfYANuX5eceT+5SFVeSOY+ju?=
 =?us-ascii?Q?Xf4tf7CnuNi1+/IrfGzz5Qrg54Zb5vHsVOqzRT8v6reygd9sUA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2024 11:53:15.4208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 19b8d9a5-c956-4f6e-f4ac-08dd03d9c217
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF000015CD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8126

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
index a0ce3ec2c734..aaada7abfffb 100644
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
@@ -159,6 +163,41 @@ virtiovf_pci_free_obj_id(struct virtiovf_pci_core_device *virtvdev, u32 obj_id)
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
@@ -345,6 +384,7 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
 {
 	struct virtiovf_migration_file *migf = filp->private_data;
 	struct virtiovf_data_buffer *vhca_buf;
+	bool first_loop_call = true;
 	bool end_of_data;
 	ssize_t done = 0;
 
@@ -362,6 +402,19 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
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
 
@@ -383,9 +436,101 @@ static ssize_t virtiovf_save_read(struct file *filp, char __user *buf, size_t le
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
 
@@ -429,7 +574,7 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
 	int nent;
 	int ret;
 
-	buf = virtiovf_alloc_data_buffer(migf, ctx_size);
+	buf = virtiovf_get_data_buffer(migf, ctx_size);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
 
@@ -464,7 +609,7 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
 		goto out;
 
 	buf->length = res_size;
-	header_buf = virtiovf_alloc_data_buffer(migf,
+	header_buf = virtiovf_get_data_buffer(migf,
 				sizeof(struct virtiovf_migration_header));
 	if (IS_ERR(header_buf)) {
 		ret = PTR_ERR(header_buf);
@@ -489,8 +634,43 @@ virtiovf_read_device_context_chunk(struct virtiovf_migration_file *migf,
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
@@ -541,6 +721,18 @@ virtiovf_pci_save_device_data(struct virtiovf_pci_core_device *virtvdev)
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
@@ -950,7 +1142,8 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
 		ret = virtio_pci_admin_mode_set(virtvdev->core_device.pdev,
 						BIT(VIRTIO_ADMIN_CMD_DEV_MODE_F_STOPPED));
 		if (ret)
@@ -958,7 +1151,8 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return NULL;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
+	if ((cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_PRE_COPY)) {
 		ret = virtio_pci_admin_mode_set(virtvdev->core_device.pdev, 0);
 		if (ret)
 			return ERR_PTR(ret);
@@ -968,7 +1162,7 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
 		struct virtiovf_migration_file *migf;
 
-		migf = virtiovf_pci_save_device_data(virtvdev);
+		migf = virtiovf_pci_save_device_data(virtvdev, false);
 		if (IS_ERR(migf))
 			return ERR_CAST(migf);
 		get_file(migf->filp);
@@ -976,7 +1170,9 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
 		return migf->filp;
 	}
 
-	if (cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) {
+	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new == VFIO_DEVICE_STATE_RUNNING) ||
+	    (cur == VFIO_DEVICE_STATE_PRE_COPY_P2P && new == VFIO_DEVICE_STATE_RUNNING_P2P)) {
 		virtiovf_disable_fds(virtvdev);
 		return NULL;
 	}
@@ -997,6 +1193,24 @@ virtiovf_pci_step_device_state_locked(struct virtiovf_pci_core_device *virtvdev,
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
@@ -1101,7 +1315,8 @@ void virtiovf_set_migratable(struct virtiovf_pci_core_device *virtvdev)
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


