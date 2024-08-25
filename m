Return-Path: <kvm+bounces-25007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1DB95E374
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 15:07:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA8861F21742
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 13:07:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2264154BFF;
	Sun, 25 Aug 2024 13:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lE7Sg4TW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2056.outbound.protection.outlook.com [40.107.93.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FA7D1EA91
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 13:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724591260; cv=fail; b=mnmQd4k5O1XvZ13wvCOvpAe7zVTfAl9ewYltLIupNTWpOsGGbObWlRzv3aZzxVBhFVNuQYBLa+85BSRU5+TZnj81vJ4mP5YVzYn2DYxDkUK+spDfEXRrkYLW4ZqTk3hDTI8VJ69DygeMTQ3opTy/LfgTHhpTSY2IlnKiHKoX8dc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724591260; c=relaxed/simple;
	bh=OVlLPcjuEDuPXWe/zRtKHUHHp794K+gaiOCF5ecj3S8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fqvInefeCyZW/aSmgHdwIUFFfgOJizsVFamjJ/76yPB6fRkSNRtq6mQ4SwGxWoTJ95X7E6vCObuZKQZRdNBnfeqNFPkZaEBQOL+7dEpFdsP3s829SnmsEe0glwNO5hxdbV3DgXWu9NHCYf38Z4EHOKbl2R0z5MQeJJoasLTd2rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lE7Sg4TW; arc=fail smtp.client-ip=40.107.93.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IEOweM7HNTWrM00mf5Gp6aK6dq7WleLvWu+zlgSokNbMV/uypW4fJjmNgcA722UTDWozQbLDw76svNJiOZ/XwPIdnZK7wjqUHVxLmdOwYquCzNTmRj++XhCIHCDDoXlNP6ukma0EMXEd2fzJO7nJMtngQrlvKXWGY7vCPo9P2uAsi+AexgKYpiu9r/WnxVNEBvPXqPBUU6w4XmCvDxUBkP5SP4SpDUYFeuZYLCmZTyGE0i9KhqYclSwrj7LKiC33PZVOwhkZHDX/ebQldEcp94/vzFofpYlLp7B3T8mbceBQpe6AJyfP4EMDLT+GSO7UTdDRgAA+4VlByIEFL4gG/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCxnFZRcI9rzYG6m9RhYRM3nnUpVJOv7D9ht+1EkLgw=;
 b=lvZoW+MAXCPPGVivhoZoObUAKdZFeV1LnEdVJti+BeRd8i2PoyJ5Z+aRyqC5LpNu9rlSyHum5Csy2Go1weEalZWxPRl4q9HpjRoRBTYpRAd5aHnfNnjb1nJpo0jv64HRbuC21i/LDUInos3/Lukrs8awMn9uEAfC60+1rudo69k3bAF3jTmaRmHyO7z2zgR1h+0IptWrRiK9kTlJJvHufFdYwUP+w/usJr7S3MfVf8ohtjJpPwplEfzkGG+rV8CFW9vmUuM6DHfceXfJ9mGipmOWTd0aJcwe788RQzP8PwyX0PYfUqg3YfmHMJKRjrBNgD/nubKKrFI/Gra++CNfJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCxnFZRcI9rzYG6m9RhYRM3nnUpVJOv7D9ht+1EkLgw=;
 b=lE7Sg4TWecf8dtBH5XQkmvOFCbkIPDyM3KLF+IUBESdpP6WknnevI5ILT2/2KYESYXDifqyFg6PHjq03ojcAAMlweCr+kC4dm9fzSjGgDLySYlmOdUCY+a6uZibzf5mfiAVwDTeWXOSg2j7jRlgM8+MDBn66DwxrShfvYb6/h7k4nFWAW+y7U9DKeQUkM5BUTRfz7iZts0p9ZKUjLnJwf8oDdVndtfaSIs4b/9O0ZgRPtEv0z89JCnQgOZFVU4B5Kn4vZ7QIbQ8+jf4+SYEgrNuFqLhAlSkPffmuEeA0r2C+ujK6iHTIIwLFUw/6/lLWdyGhxUWLhCMM9V7uIxS84A==
Received: from BY5PR20CA0033.namprd20.prod.outlook.com (2603:10b6:a03:1f4::46)
 by DS0PR12MB7804.namprd12.prod.outlook.com (2603:10b6:8:142::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.24; Sun, 25 Aug
 2024 13:07:34 +0000
Received: from SJ1PEPF00002322.namprd03.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::aa) by BY5PR20CA0033.outlook.office365.com
 (2603:10b6:a03:1f4::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23 via Frontend
 Transport; Sun, 25 Aug 2024 13:07:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ1PEPF00002322.mail.protection.outlook.com (10.167.242.84) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Sun, 25 Aug 2024 13:07:33 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 25 Aug
 2024 06:07:25 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 25 Aug
 2024 06:07:24 -0700
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 25 Aug 2024 06:07:21 -0700
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: <stefanha@redhat.com>, <virtualization@lists.linux.dev>, <mst@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
CC: <kvm@vger.kernel.org>, Jingbo Xu <jefflexu@linux.alibaba.com>,
	<pgootzen@nvidia.com>, <smalin@nvidia.com>, <larora@nvidia.com>,
	<ialroy@nvidia.com>, <oren@nvidia.com>, <izach@nvidia.com>, Max Gurtovoy
	<mgurtovoy@nvidia.com>
Subject: [PATCH v1 2/2] virtio_fs: add sysfs entries for queue information
Date: Sun, 25 Aug 2024 16:07:16 +0300
Message-ID: <20240825130716.9506-2-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20240825130716.9506-1-mgurtovoy@nvidia.com>
References: <20240825130716.9506-1-mgurtovoy@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00002322:EE_|DS0PR12MB7804:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fe7fb7f-9eef-46b7-eba7-08dcc506e25b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?FWlKHnteSl2sm2BD/DAdaUbWCeRSpS6gHDcws0Kf8msYbsgJob81bCf0mDel?=
 =?us-ascii?Q?pIlGCdws+pC4MuSDJKxEEM5MT0NW7LSkvEJg5kfdu4cmA/uGMHhFzk+yW+Tt?=
 =?us-ascii?Q?VN1eBeoa3Z9IsUqeSZbcLfWLewFVQec0Hkkc+hQeHynQebhgbbkgvB3kiCcy?=
 =?us-ascii?Q?66LteJ1flNcWDLRtWlbg7VqCeCKFYkDQWfbxiy1TA/F07qCdhOVSyWTj8ueW?=
 =?us-ascii?Q?z4t0op6IbJhmsW1ipb4dR30VZ5qxheHcBde+abwYe3BfRE0ZozP+qQ0LQDa5?=
 =?us-ascii?Q?40OS/NmfplcyNYoCA4eEquMwZwxOEQyKxQP5lSWDfPId3UHa+NH/36TNUTzz?=
 =?us-ascii?Q?me7H0dDIXEV0w4M+DG7YFbOwISkKPSg1yG+dkfxj9mmT+htBeRtHaTjc6es+?=
 =?us-ascii?Q?RQ3REzqamnZ65Z4CpVjhIpiksRiszs2noC4VBasDsvGLzTfmGx5roty1Y77D?=
 =?us-ascii?Q?eLoYQzSb9vYUwgd87ELT0/ILNAdDLHC/dMB3BqNuOjEqB23L38OilFVYmmXC?=
 =?us-ascii?Q?q1TxlEA6Q8rRV586bs8QQBlYxOYUn6ajQGb6UjsJTuUMJ19qSNRZboB0G3+O?=
 =?us-ascii?Q?hGqxjO2wFE/sxd8noPU4+9BS92zTXqzbCcPlYAv5VzcMcxPRQStOjMm711eI?=
 =?us-ascii?Q?I6lAQov3KKq4A5y0Ocl4vAyaqPnPldQam4IJPEPXGJp52m7KOGwGSi7ri0Rf?=
 =?us-ascii?Q?eFhPS6EjRXHB8sse0WGOh/Ns4HJUQAOraKJan1AuBryWSa9uuGi25UdIW4op?=
 =?us-ascii?Q?I2gXipCF2f6hYjBYvX8uiuxsHX9zBZPSPPLOunv8WRxVYUAGmfhmWb0DuyRw?=
 =?us-ascii?Q?IXu3opVrrq6bEDPFsILN0zqiZ6otOCFU/DBKSOH05cklw15eKl9zhXZ+AKZ5?=
 =?us-ascii?Q?UGTpuT2mwBvpgKNTNtcn0lUnwXtbSW7isNRIJQ6CS4BZUljwOowA84P+bON1?=
 =?us-ascii?Q?8ZWCCDwFF2ZDOOYsI7C3b8JyjNxiRB/xzt1E3nzhdxS/8mZlJHwiPxlSvv0m?=
 =?us-ascii?Q?Zy6ZbzowlWyO6kFtNeN3lZF5EABOOJEOpER/islb+vJefxvW59U8TbyttZFc?=
 =?us-ascii?Q?NflRTZ7LrETM3E1mpVwtIcvIm0TkWJRz/bMvUCCh2r7Z6PuwL3miZuipSVf5?=
 =?us-ascii?Q?A5IRYGx9rD1VKTf9wU4xNOFUggyapeYVky7J/UoPlNU6uJLRNg0uCofX+hYd?=
 =?us-ascii?Q?hMp7J3kti6h+InZ7HjAbQHJLrxmZcf8eJtpJtCGjAVwhj87i7CDNDruRsoSq?=
 =?us-ascii?Q?SI47vlR0JXbOpNAB5Odp2keKoNcy8GX/qBJHD1sL9hSafZ+zyjdGJHeFlkbO?=
 =?us-ascii?Q?qpPzLsQyT7t43MOz9cG/2yqYGKeH2Wx3A7jSPtSHN1eDouwkyJEm01K74CIr?=
 =?us-ascii?Q?2SZDV+HK/xcAFP4aZd+pnO0eyNKRLHCnmc/U8n83x1m8fCMa5BwRmVmjDUvB?=
 =?us-ascii?Q?9sXdUWX1tMxS1WPflDw7lYdBs+KMj6rE?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2024 13:07:33.7449
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fe7fb7f-9eef-46b7-eba7-08dcc506e25b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00002322.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7804

Introduce sysfs entries to provide visibility to the multiple queues
used by the Virtio FS device. This enhancement allows users to query
information about these queues.

Specifically, add two sysfs entries:
1. Queue name: Provides the name of each queue (e.g. hiprio/requests.8).
2. CPU list: Shows the list of CPUs that can process requests for each
queue.

The CPU list feature is inspired by similar functionality in the block
MQ layer, which provides analogous sysfs entries for block devices.

These new sysfs entries will improve observability and aid in debugging
and performance tuning of Virtio FS devices.

Reviewed-by: Idan Zach <izach@nvidia.com>
Reviewed-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 fs/fuse/virtio_fs.c | 147 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 139 insertions(+), 8 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index 43f7be1d7887..78f579463cca 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -56,12 +56,14 @@ struct virtio_fs_vq {
 	bool connected;
 	long in_flight;
 	struct completion in_flight_zero; /* No inflight requests */
+	struct kobject *kobj;
 	char name[VQ_NAME_LEN];
 } ____cacheline_aligned_in_smp;
 
 /* A virtio-fs device instance */
 struct virtio_fs {
 	struct kobject kobj;
+	struct kobject *mqs_kobj;
 	struct list_head list;    /* on virtio_fs_instances */
 	char *tag;
 	struct virtio_fs_vq *vqs;
@@ -200,6 +202,74 @@ static const struct kobj_type virtio_fs_ktype = {
 	.default_groups = virtio_fs_groups,
 };
 
+static struct virtio_fs_vq *virtio_fs_kobj_to_vq(struct virtio_fs *fs,
+		struct kobject *kobj)
+{
+	int i;
+
+	for (i = 0; i < fs->nvqs; i++) {
+		if (kobj == fs->vqs[i].kobj)
+			return &fs->vqs[i];
+	}
+	return NULL;
+}
+
+static ssize_t name_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct virtio_fs *fs = container_of(kobj->parent->parent, struct virtio_fs, kobj);
+	struct virtio_fs_vq *fsvq = virtio_fs_kobj_to_vq(fs, kobj);
+
+	if (!fsvq)
+		return -EINVAL;
+	return sysfs_emit(buf, "%s\n", fsvq->name);
+}
+
+static struct kobj_attribute virtio_fs_vq_name_attr = __ATTR_RO(name);
+
+static ssize_t cpu_list_show(struct kobject *kobj,
+		struct kobj_attribute *attr, char *buf)
+{
+	struct virtio_fs *fs = container_of(kobj->parent->parent, struct virtio_fs, kobj);
+	struct virtio_fs_vq *fsvq = virtio_fs_kobj_to_vq(fs, kobj);
+	unsigned int cpu, qid;
+	const size_t size = PAGE_SIZE - 1;
+	bool first = true;
+	int ret = 0, pos = 0;
+
+	if (!fsvq)
+		return -EINVAL;
+
+	qid = fsvq->vq->index;
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++) {
+		if (qid < VQ_REQUEST || (fs->mq_map[cpu] == qid - VQ_REQUEST)) {
+			if (first)
+				ret = snprintf(buf + pos, size - pos, "%u", cpu);
+			else
+				ret = snprintf(buf + pos, size - pos, ", %u", cpu);
+
+			if (ret >= size - pos)
+				break;
+			first = false;
+			pos += ret;
+		}
+	}
+	ret = snprintf(buf + pos, size + 1 - pos, "\n");
+	return pos + ret;
+}
+
+static struct kobj_attribute virtio_fs_vq_cpu_list_attr = __ATTR_RO(cpu_list);
+
+static struct attribute *virtio_fs_vq_attrs[] = {
+	&virtio_fs_vq_name_attr.attr,
+	&virtio_fs_vq_cpu_list_attr.attr,
+	NULL
+};
+
+static struct attribute_group virtio_fs_vq_attr_group = {
+	.attrs = virtio_fs_vq_attrs,
+};
+
 /* Make sure virtiofs_mutex is held */
 static void virtio_fs_put_locked(struct virtio_fs *fs)
 {
@@ -280,6 +350,50 @@ static void virtio_fs_start_all_queues(struct virtio_fs *fs)
 	}
 }
 
+static void virtio_fs_delete_queues_sysfs(struct virtio_fs *fs)
+{
+	struct virtio_fs_vq *fsvq;
+	int i;
+
+	for (i = 0; i < fs->nvqs; i++) {
+		fsvq = &fs->vqs[i];
+		kobject_put(fsvq->kobj);
+	}
+}
+
+static int virtio_fs_add_queues_sysfs(struct virtio_fs *fs)
+{
+	struct virtio_fs_vq *fsvq;
+	char buff[12];
+	int i, j, ret;
+
+	for (i = 0; i < fs->nvqs; i++) {
+		fsvq = &fs->vqs[i];
+
+		sprintf(buff, "%d", i);
+		fsvq->kobj = kobject_create_and_add(buff, fs->mqs_kobj);
+		if (!fs->mqs_kobj) {
+			ret = -ENOMEM;
+			goto out_del;
+		}
+
+		ret = sysfs_create_group(fsvq->kobj, &virtio_fs_vq_attr_group);
+		if (ret) {
+			kobject_put(fsvq->kobj);
+			goto out_del;
+		}
+	}
+
+	return 0;
+
+out_del:
+	for (j = 0; j < i; j++) {
+		fsvq = &fs->vqs[j];
+		kobject_put(fsvq->kobj);
+	}
+	return ret;
+}
+
 /* Add a new instance to the list or return -EEXIST if tag name exists*/
 static int virtio_fs_add_instance(struct virtio_device *vdev,
 				  struct virtio_fs *fs)
@@ -303,17 +417,22 @@ static int virtio_fs_add_instance(struct virtio_device *vdev,
 	 */
 	fs->kobj.kset = virtio_fs_kset;
 	ret = kobject_add(&fs->kobj, NULL, "%d", vdev->index);
-	if (ret < 0) {
-		mutex_unlock(&virtio_fs_mutex);
-		return ret;
+	if (ret < 0)
+		goto out_unlock;
+
+	fs->mqs_kobj = kobject_create_and_add("mqs", &fs->kobj);
+	if (!fs->mqs_kobj) {
+		ret = -ENOMEM;
+		goto out_del;
 	}
 
 	ret = sysfs_create_link(&fs->kobj, &vdev->dev.kobj, "device");
-	if (ret < 0) {
-		kobject_del(&fs->kobj);
-		mutex_unlock(&virtio_fs_mutex);
-		return ret;
-	}
+	if (ret < 0)
+		goto out_put;
+
+	ret = virtio_fs_add_queues_sysfs(fs);
+	if (ret)
+		goto out_remove;
 
 	list_add_tail(&fs->list, &virtio_fs_instances);
 
@@ -322,6 +441,16 @@ static int virtio_fs_add_instance(struct virtio_device *vdev,
 	kobject_uevent(&fs->kobj, KOBJ_ADD);
 
 	return 0;
+
+out_remove:
+	sysfs_remove_link(&fs->kobj, "device");
+out_put:
+	kobject_put(fs->mqs_kobj);
+out_del:
+	kobject_del(&fs->kobj);
+out_unlock:
+	mutex_unlock(&virtio_fs_mutex);
+	return ret;
 }
 
 /* Return the virtio_fs with a given tag, or NULL */
@@ -1050,7 +1179,9 @@ static void virtio_fs_remove(struct virtio_device *vdev)
 	mutex_lock(&virtio_fs_mutex);
 	/* This device is going away. No one should get new reference */
 	list_del_init(&fs->list);
+	virtio_fs_delete_queues_sysfs(fs);
 	sysfs_remove_link(&fs->kobj, "device");
+	kobject_put(fs->mqs_kobj);
 	kobject_del(&fs->kobj);
 	virtio_fs_stop_all_queues(fs);
 	virtio_fs_drain_all_queues_locked(fs);
-- 
2.18.1


