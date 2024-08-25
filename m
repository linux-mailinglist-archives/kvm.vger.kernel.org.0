Return-Path: <kvm+bounces-25006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CED7995E372
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 15:07:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F5B7281B5C
	for <lists+kvm@lfdr.de>; Sun, 25 Aug 2024 13:07:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D4BD13D296;
	Sun, 25 Aug 2024 13:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PB85qEEy"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1C81EA91
	for <kvm@vger.kernel.org>; Sun, 25 Aug 2024 13:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724591255; cv=fail; b=Pr02qxcSVhwf0uubDrEqYalyiTY9DQ95K0v03x7kljq5OX7KvGgSnDmDkMkeMUATC7Ou511DCZnONHu19K4rZwbhylmzhxDleIKYpsSGN1UKUMyynintdHJQX7fNh8VzzikbCS4JUOUAU8FAnrHvCJc8tC38+Zb5Yx7f4W7PFRw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724591255; c=relaxed/simple;
	bh=6RA3cZ9wqk+IyEgZh/qM853wCj3qG/OJ0Z0ZeT01StM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=FUnF0sbXpA3bQ1Cr+rPBykGSh6lZrFlUJvRpF9c0OPEziFXb/8uCYtBHlbw6jK3BD4/dDibXLOcdTHJptz4XyjC3ZCYlV9OnKbTKzuFY9VrDhjMzb8zej1+Hty+ZjUMdXXlOFusV1tgP22eWFUSIWeVqe4Wq0/kpE8lu7CEbkGc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PB85qEEy; arc=fail smtp.client-ip=40.107.220.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GTsXD6Izy6KcbSCT6SBq82h2ajA35ugVOhd2/xDrGfHppEXbSQbnoA+UekwSZrpYHsEAJWyjJjrMzBAxZMSoam4fkX9rJDbMwaHg3X+jQQVIK0cTCViWHMtbJ9F6WNKlpPw8zJvzAzhmCuLBc49NnxXyqE8kDv/dw2YZ2aD0B/hiKNlgiZsiO9A4rdQWqfSktzQibOCyjwrLjPuWjoQ6LBNd/vWtF58e1zwEDvtumJXElV6IOymGMkJPrZu0jMmQuqI331gtcQSVpUL+xd6fdn8t8gl3q5+BDF/Y7QDAUduom095Rp91aB3ocnbXXZd0pg1rH+w5/EFluLGvCzG0AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H9gWABf4g67c9S4WwIDp/jiX1KalTBbu+K2tukDO6V0=;
 b=lkKl19MnhZmYDh1D+jiEggPgh3hEUZUwiad+3ytqlNQcjzEtZnzR/uJlxoEkmnUT73yDKNC/Ix5OdANOW3t7l/2wJhGIpPI7F/7o+zYDVGFeizeyeCxeoq2HqB/fGNhF6IEVuNpCMcVhIuy2jjCQF1vhEeTTIcLBNCctuTGJope0Mgt0J6tWmUZvh0Ab1G44BXdMIYkZiow2+Gpycd4laFAVXNPrzUq/LVrhcDktORqPyNdagA4iTkW7pSqEKAmozXv1isY6TXHIuUR8cqq6gC1wA4DScokeOOAxbO5U8V9D0LBjbtfDodRGEBiGPg4P9yisz35VX0JQJl2JGQzBVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H9gWABf4g67c9S4WwIDp/jiX1KalTBbu+K2tukDO6V0=;
 b=PB85qEEyZFEURBagg8C4eT5MwL7or8f+prKW6wBu2nkjqU2bfd7plVpgKYJGaAPhhZjPnRJsznSJ7NsWkpBZ3crK9ai4CdOm5tIrITU9dy94+QYUhvuKNoJAW5jUh/dK22id+NJ6aKBmtRINItW2lKVOUZYKwhx6rvuYHgs9bLvpYmK7yzZ98s+RRPNaYhyquH8ETL6FavpIZghQnr1eogF8XV6zat+4ZoC0JGwOa5F0gEqlCtVqtUdneQWXsKIivBDV9sT56lGg/FgG0m+LbveIwGj1anPrzqRXZH31Ghx+f5vO2CNKE+lyRQWzGr4uGH0jYePRO0wei9b2OpTFFw==
Received: from BY5PR20CA0001.namprd20.prod.outlook.com (2603:10b6:a03:1f4::14)
 by PH8PR12MB6746.namprd12.prod.outlook.com (2603:10b6:510:1c1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23; Sun, 25 Aug
 2024 13:07:30 +0000
Received: from SJ1PEPF000023D3.namprd21.prod.outlook.com
 (2603:10b6:a03:1f4:cafe::91) by BY5PR20CA0001.outlook.office365.com
 (2603:10b6:a03:1f4::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.23 via Frontend
 Transport; Sun, 25 Aug 2024 13:07:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 SJ1PEPF000023D3.mail.protection.outlook.com (10.167.244.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7897.4 via Frontend Transport; Sun, 25 Aug 2024 13:07:30 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 25 Aug
 2024 06:07:21 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Sun, 25 Aug
 2024 06:07:20 -0700
Received: from r-arch-stor03.mtr.labs.mlnx (10.127.8.14) by mail.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server id 15.2.1544.4 via Frontend
 Transport; Sun, 25 Aug 2024 06:07:17 -0700
From: Max Gurtovoy <mgurtovoy@nvidia.com>
To: <stefanha@redhat.com>, <virtualization@lists.linux.dev>, <mst@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
CC: <kvm@vger.kernel.org>, Jingbo Xu <jefflexu@linux.alibaba.com>,
	<pgootzen@nvidia.com>, <smalin@nvidia.com>, <larora@nvidia.com>,
	<ialroy@nvidia.com>, <oren@nvidia.com>, <izach@nvidia.com>, Max Gurtovoy
	<mgurtovoy@nvidia.com>
Subject: [PATCH v1 1/2] virtio_fs: introduce virtio_fs_put_locked helper
Date: Sun, 25 Aug 2024 16:07:15 +0300
Message-ID: <20240825130716.9506-1-mgurtovoy@nvidia.com>
X-Mailer: git-send-email 2.18.1
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
X-MS-TrafficTypeDiagnostic: SJ1PEPF000023D3:EE_|PH8PR12MB6746:EE_
X-MS-Office365-Filtering-Correlation-Id: 039f907d-283f-4afd-c1e3-08dcc506e063
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NFoTJFoDhj6IasgVgDdAxoaEuh3ROc23+Ib/xPoUzG7GtPi0jFr+WhZ1dhxi?=
 =?us-ascii?Q?+NdAuFk8KfIhqtIl2OiBdZS9Y50OTECZhh0UDCypwd/XmKJsoNQd7NLzGR72?=
 =?us-ascii?Q?h6+Hpbab5UPV/bqCRo+AbPeirweoLB0hxGugTMVxYdP8UvMblt9YElHuj1Ex?=
 =?us-ascii?Q?MJrq2/eJor4E54zIuBphuDjvPYdm1FAfu+XMQ/trfEXpUyLqqE5Ec6yILlxa?=
 =?us-ascii?Q?2lQ3ZeCF/rynCqyLynkFcFcwzvgF992cjvTJfRRJNAbveEuRWMc4UCj9L0dS?=
 =?us-ascii?Q?gxzCTDqBd8O/LeNnlbbF2BkJrAeAkBF6DUCTz+ou4jsOwoaib456opncE5o7?=
 =?us-ascii?Q?Wn2DuokrHoyR8IiZEnCCyHP5KmdxHEFkTgWF21gBhrgNCy+xq5xb4b2KlOwP?=
 =?us-ascii?Q?szFHf+UzjI/7XHI1hOcRo2JYoSsoz6qVuKlvsX4bv+ldbgdP51Tv6iiS17qz?=
 =?us-ascii?Q?gbQx6zrpDOt4BCkF6Zopfg/i/trHXw31nPDzk8LTVQr3CAZzukwLc3I2USxD?=
 =?us-ascii?Q?Sq+rEDxxmugza1+5iBpMD+fcoplbqC7J/llooLmhgGnsFyq+WKFKxT3t8IhP?=
 =?us-ascii?Q?X+bb0K7voV9IOX2p+GgY5W5KFK5KC9kt7zh2R/+klNIX9ZqZP/OXw8AyYT0v?=
 =?us-ascii?Q?3wlDbkUK4AtyZhdxUcPbsZw80SVqHWvmaDe61nnx0Hzm0n8nz7KdFf0RPw+l?=
 =?us-ascii?Q?EbsgFmfShhJUFQJZlGCaoRk9gGtRegQBQBrJJRHUNxGhUcP6cFSpJdh8mayU?=
 =?us-ascii?Q?vD7f55d6K3nAUbYEW2i6eGilMhJXgOFjtaXfHg7oFBsZXE1MzOl+DAIBE0aJ?=
 =?us-ascii?Q?1p9/eZlIpMAQXc7vFtxVbU/fyWzqg6POom3F7uhli+gAHRPGKNXXP9TNr3fo?=
 =?us-ascii?Q?t6Bn6XpuDEx4MJP4nURBLgxE/f5E0vOYMxGZZ+xAozocBoljlQWOvOI2Bg2L?=
 =?us-ascii?Q?iQ/lP/YuzEdNr7Ijh096+E6PyvNB02vz2uBkVt+a0rHhV6/Evb/mCt+Kcyaz?=
 =?us-ascii?Q?derhYF0+07wJM6+7qsYZZoWwLo7snBdlL+2m58tcDFar79FNH5pLLDoBo2DR?=
 =?us-ascii?Q?nYeoDCyc1VitG4tlO5dQHv49Jbi3RUvZz8IMj/XkIsbmPGAC+8xaDDWO1geR?=
 =?us-ascii?Q?i9WO+ug4deRIsVqgnH54eoED9MZ9JOsDu+AwPfPihTdIsQflH9ZtyaRx9/i+?=
 =?us-ascii?Q?Sccf47L4NNdqUplpQHd8bSa4+eL+AY3C0uXaY457ShrrgqY3T5ntNS6w9z2u?=
 =?us-ascii?Q?B4hahAKp2odA/AsC1uf/kZFeripUWmlXrqjaV/Ci28DE5fd+Gok+RPN25VoV?=
 =?us-ascii?Q?JgMgVirzSyr3GlWmM/nvGbGF+uMCi54igCGpmmzxfVaqItDO3a8OP5bcbbM1?=
 =?us-ascii?Q?VKsc6JqNb3FSXVFTJzFOy1UqBTUG04/Sq4nZa0KU4L5HzL2n2efheLDdomaO?=
 =?us-ascii?Q?4BkFQ4EXr65k+5daJcnYLs0BQP6U7IKX?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2024 13:07:30.3627
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 039f907d-283f-4afd-c1e3-08dcc506e063
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF000023D3.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6746

Introduce a new helper function virtio_fs_put_locked to encapsulate the
common pattern of releasing a virtio_fs reference while holding a lock.
The existing virtio_fs_put helper will be used to release a virtio_fs
reference while not holding a lock.

Also add an assertion in case the lock is not taken when it should.

Reviewed-by: Idan Zach <izach@nvidia.com>
Reviewed-by: Shai Malin <smalin@nvidia.com>
Signed-off-by: Max Gurtovoy <mgurtovoy@nvidia.com>
---
 fs/fuse/virtio_fs.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/fuse/virtio_fs.c b/fs/fuse/virtio_fs.c
index dd5260141615..43f7be1d7887 100644
--- a/fs/fuse/virtio_fs.c
+++ b/fs/fuse/virtio_fs.c
@@ -201,18 +201,25 @@ static const struct kobj_type virtio_fs_ktype = {
 };
 
 /* Make sure virtiofs_mutex is held */
-static void virtio_fs_put(struct virtio_fs *fs)
+static void virtio_fs_put_locked(struct virtio_fs *fs)
 {
+	lockdep_assert_held(&virtio_fs_mutex);
+
 	kobject_put(&fs->kobj);
 }
 
+static void virtio_fs_put(struct virtio_fs *fs)
+{
+	mutex_lock(&virtio_fs_mutex);
+	virtio_fs_put_locked(fs);
+	mutex_unlock(&virtio_fs_mutex);
+}
+
 static void virtio_fs_fiq_release(struct fuse_iqueue *fiq)
 {
 	struct virtio_fs *vfs = fiq->priv;
 
-	mutex_lock(&virtio_fs_mutex);
 	virtio_fs_put(vfs);
-	mutex_unlock(&virtio_fs_mutex);
 }
 
 static void virtio_fs_drain_queue(struct virtio_fs_vq *fsvq)
@@ -1052,7 +1059,7 @@ static void virtio_fs_remove(struct virtio_device *vdev)
 
 	vdev->priv = NULL;
 	/* Put device reference on virtio_fs object */
-	virtio_fs_put(fs);
+	virtio_fs_put_locked(fs);
 	mutex_unlock(&virtio_fs_mutex);
 }
 
@@ -1596,9 +1603,7 @@ static int virtio_fs_get_tree(struct fs_context *fsc)
 
 out_err:
 	kfree(fc);
-	mutex_lock(&virtio_fs_mutex);
 	virtio_fs_put(fs);
-	mutex_unlock(&virtio_fs_mutex);
 	return err;
 }
 
-- 
2.18.1


