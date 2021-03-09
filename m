Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1ACE333114
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 22:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhCIVjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 16:39:12 -0500
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:47776
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232048AbhCIVjC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 16:39:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lEuWKSHMqJ2+bW/n9B2M5R7aOlL/5oEuPr3XU2ib28clHJrSyRYrfgT82TKpukCqGRYYqFuzBXPqACXzpehk1fJZwKK0yGg+s6+1jvlN4KnMUHoFwUyRBBa1dtJK8YvRkCFDBnMHe/5OhgOPWT2Lppzip8HZJWAR2kURGoj1zxuVlbKHJ/acdZeJhsYBWmyOTQfnh/EItM4eC4xbFt5wQWx+9eKnBJc5SfPCIMvtjvJhl00lQGzClXQ7yntvETFTn9gmRMrm7/1CjwYrBa/CzhPSCg/6Ho+6VxwRFHkVSwpSPXzDL8sL6uqZ4KUfnQBwIqMiuYD/82W0iMA1x/Kt4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ja4Rw1nKMBPlQ64FJK7oT8v0G7KO90hHEc8D88K0Pvg=;
 b=NY2q+p/X/3WE4mgmcrFllhqHl4hbS1HHdbVxlJRliP8Ts0kjdKyIfDvQAimKvLnRLTCtYX651HplHZ6Ke/L8p0mUa9uDDHnkFD3mSkSK5lBsWRzEGQ5N+QKrcumDe+5QpHw5bid5UHqHUZxujf9P4yO9xj7o0wQcTa4KeFvQqZUYL361qC2xxLgHYIPpMhVDmQDcnL85+2DfW/y/AU3oyZB+kbTSX8Y08cR/PYs/vVfnmHDFi0oRDQaC409Bn5YpWo2INRrzKji5x7SdFxiSZrS/29tDFMiLSu59J+0RSPCjBAX3PM0UpGC0HQ9YUg64krTLNFeuv406YwoQp6rutw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ja4Rw1nKMBPlQ64FJK7oT8v0G7KO90hHEc8D88K0Pvg=;
 b=e3m6fIFEzVNVkcI67ipFzXmJd2bw2GUXcaXukX+H3UQICwY+LoXXC9sjM/knEDhTtwyZ5MFTQnoozs610tVeR5G44pKSMEyYv+9CS0iyEaAtmcsGBPWqB+kJrqmwIf9Utk+nhq50LgSmUO5ogKrLI7UWB4vGbeclqqp8VbUE1cxYYJiDZ4P2YKQAohIkrHnGoHmlDC6PPB+4i58UF+wM8sLfuNDhs0ZmPYU9GpjnEh2oNNZeZA6kI1+aXrvAMRprzq15Rne4vB9FzB5q2HCvv47NM3f8nVAjc1O9o2gbJdi5WMBfULQd2i3OzpCOIykAGQOQXsdiwejXqE98tzBT0A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1243.namprd12.prod.outlook.com (2603:10b6:3:74::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Tue, 9 Mar
 2021 21:38:58 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 21:38:58 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH 08/10] vfio: Make vfio_device_ops pass a 'struct vfio_device *' instead of 'void *'
Date:   Tue,  9 Mar 2021 17:38:50 -0400
Message-Id: <8-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR20CA0030.namprd20.prod.outlook.com
 (2603:10b6:208:e8::43) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR20CA0030.namprd20.prod.outlook.com (2603:10b6:208:e8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Tue, 9 Mar 2021 21:38:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lJk44-00AVJ7-UT; Tue, 09 Mar 2021 17:38:52 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 82523477-3a85-4d2a-8480-08d8e343bef8
X-MS-TrafficTypeDiagnostic: DM5PR12MB1243:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB12434ADE22873CC51F80E0A3C2929@DM5PR12MB1243.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d45jB1HFL4/20eNDiSb51KupqVIXKaUoQ2e4iWRt18aWsQ+L7f8VtEPcVC3ZIDQD+yXD3WHpxAmZeza8HP2W0tmBcxPZ1xNOc+qEKSoyBo9LpiOTrEh1rtPEdwd9WxoN1Jh5EhzVkNsUhPMyorAURSpzUWHF0NnMo64UGSxXhX5y2gZfuA1ZPhKNFRYq/0vcsNr1BgPmyydBjGYmBRfq9a/CdQ4sGVtbxVa7WnaWt6EylP1LAoun5gxXZZWkpbG9Z6pckB2iMDYDE3JT5PLcTG7bx+Oacr8NoPIeZjSx+farb5k418C3ZcZhzYzVDzSq3fP46kvdEpmXbWI3wD1VaD+FEndd4lxOWBA5hz7hsTxlS4eER8NrUI3nLwPGAulDt1a5O6bGA9v1PXFoBVXzmDjL3nxPiEPAdS7H//6UYZv7PFGXL+3VboDdaBvZe1wsFUPllFnUZ5EKzVBI4rvHfyGRYxVyzLBI48wRCW4LywThw093WTSYijQ3g6S8BNhvUWdMOW8adXDRZy02rZE+B5Yrb03ei95DL5j2vpfLNklqD6IkQvV+1p694zS7YWHS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(376002)(136003)(346002)(2616005)(83380400001)(426003)(66556008)(9786002)(66476007)(9746002)(107886003)(66946007)(30864003)(8936002)(186003)(2906002)(86362001)(8676002)(26005)(36756003)(7416002)(54906003)(4326008)(316002)(5660300002)(110136005)(478600001)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?wLlbvj/DNcOje4YqE4fO4n8+Bgy1FuEM5aEx5aWvbzimv2Jjxb157do5WYWq?=
 =?us-ascii?Q?0nn1TgCqGMoLTGZ57NzusGjb9Ul7a43+5daw3k/iAwQ+tRxNHgWTdc0bq8YG?=
 =?us-ascii?Q?bzs5sKjfqtnrO4VguX8LQAgf5JlJx2Z3SX4SkkygRZbZb1DnDQmsrJfjfTZI?=
 =?us-ascii?Q?orvIMZGwqMvILBFDp0F80+Y2SsH83q3JInc0DMlx3hjWPUnSUuyriZenzco3?=
 =?us-ascii?Q?C7IPLNRf7xgvUM2lM+HpSt1Mgf0kVJ5KStWZP7hirlkeiFnb0No/KYmISRiH?=
 =?us-ascii?Q?0tFrIW0p1V5oXoe+gQjW49jhcaMU/WnJuezSWZXWmz8k42+y2UV5f63WTZhU?=
 =?us-ascii?Q?C7hmreMpRjgCwNbSATRytcXDU+d/QSsUTXYJEIdTYcQLQK5niLtyTKq0OVku?=
 =?us-ascii?Q?fG7r1eJ2hMsHVqd2z0B1SAAQ8bWr+7cvjBx3H8R17WNMA5GfUh23fWCFJD1m?=
 =?us-ascii?Q?+SQzUSyaM5uXG8dYSc8I4CKdHj+fj0Dtzqh5lt6cHfYXDRvnHJe8Cde7X5e8?=
 =?us-ascii?Q?QrSQJ6yc9KjRwWozq3wOIpVU7WJWu6IyoaVmH7BHyjbTKINd+XG9HpRvJALJ?=
 =?us-ascii?Q?5Mdh+eWimWzaTBL4vg1f/GTH59vQlGZpIXx7z3ku+6umrwVlhdyjM+LFNKhZ?=
 =?us-ascii?Q?7ZCu2oumeH+oHwA7HHXpAB4exONw0fyAc8+WA/nf15cuozqSZcdl+cnMyKrJ?=
 =?us-ascii?Q?dQKK5rbBzp1van/PL1/DXU1NklGOjaJ7hdAiZU3akUS7jfrdqpASuuCWg468?=
 =?us-ascii?Q?/9yL7XJRO0T7LVlvHYA2pYtufJsozGuvo3K9h9x0bMT1bYTJBoCG9NlpRaKU?=
 =?us-ascii?Q?TM+HuNkulSSc6AF/VyHnbqG1ZcxfgfHSaqvPfSsieAofEysNbZMrhy8YJ5dP?=
 =?us-ascii?Q?GMiXzCCNBcJMF07w9sdqKulNIgjHOm2YsJvlJqKa0jYASydhuuKDtMJUm2RX?=
 =?us-ascii?Q?Q/rGgIG1Q96aNbIc563IRg6iGRsHH7j3hyqs0zCoQcwiIfnPmTZzDtb5TMqQ?=
 =?us-ascii?Q?lSulW30MlKaMcIFPh0BuVYfqx7Ug51CuZvrub/mMpf5OyjMz9NR1zfhCfUDo?=
 =?us-ascii?Q?fITmt+ed4p9S9fTFBbragL0uVH3m0lQpaSyZ0BBQAzcZ4nMPYsSY61FfEhyw?=
 =?us-ascii?Q?9Wmi3C83LGJAtHMuFkQ738Dqcf3q3USmgQr9GwWbJO7H/B94/w+18ix8toXw?=
 =?us-ascii?Q?7Xb3U7HTYO6opU50lvbGDFMobd4hC49AnUcYRVFZMo+bHy3jnePk+NMXLRmU?=
 =?us-ascii?Q?s3PN+HEg9c/2k9v+xjbxSpUUJR+awBa1nEzuLVAKYHtQtSnWfWrYBoAKWCPK?=
 =?us-ascii?Q?IMkHDzo+ypbTrc8wBCt6KFIlSqdMXql/o7NR9uNaW4CzUQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82523477-3a85-4d2a-8480-08d8e343bef8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2021 21:38:58.4234
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Thpu2J+bJBa1Ce6C7L+ncSzbDQaITCVU/J4VGtYGxvFLDJoJfupZcHp1OuTCkX5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1243
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the standard kernel pattern, the ops associated with a struct get
the struct pointer in for typesafety. The expected design is to use
container_of to cleanly go from the subsystem level type to the driver
level type without having any type erasure in a void *.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 Documentation/driver-api/vfio.rst            | 18 ++++----
 drivers/vfio/fsl-mc/vfio_fsl_mc.c            | 36 +++++++++------
 drivers/vfio/mdev/vfio_mdev.c                | 33 +++++++-------
 drivers/vfio/pci/vfio_pci.c                  | 47 ++++++++++++--------
 drivers/vfio/platform/vfio_platform_common.c | 33 ++++++++------
 drivers/vfio/vfio.c                          | 20 ++++-----
 include/linux/vfio.h                         | 16 +++----
 7 files changed, 117 insertions(+), 86 deletions(-)

diff --git a/Documentation/driver-api/vfio.rst b/Documentation/driver-api/vfio.rst
index d3a02300913a7f..3337f337293a32 100644
--- a/Documentation/driver-api/vfio.rst
+++ b/Documentation/driver-api/vfio.rst
@@ -269,20 +269,22 @@ ready before calling it. The driver provides an ops structure for callbacks
 similar to a file operations structure::
 
 	struct vfio_device_ops {
-		int	(*open)(void *device_data);
-		void	(*release)(void *device_data);
-		ssize_t	(*read)(void *device_data, char __user *buf,
+		int	(*open)(struct vfio_device *vdev);
+		void	(*release)(struct vfio_device *vdev);
+		ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
 				size_t count, loff_t *ppos);
-		ssize_t	(*write)(void *device_data, const char __user *buf,
+		ssize_t	(*write)(struct vfio_device *vdev,
+				 const char __user *buf,
 				 size_t size, loff_t *ppos);
-		long	(*ioctl)(void *device_data, unsigned int cmd,
+		long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
 				 unsigned long arg);
-		int	(*mmap)(void *device_data, struct vm_area_struct *vma);
+		int	(*mmap)(struct vfio_device *vdev,
+				struct vm_area_struct *vma);
 	};
 
-Each function is passed the device_data that was originally registered
+Each function is passed the vdev that was originally registered
 in the vfio_register_group_dev() call above.  This allows the bus driver
-an easy place to store its opaque, private data.  The open/release
+to obtain its private data using container_of().  The open/release
 callbacks are issued when a new file descriptor is created for a
 device (via VFIO_GROUP_GET_DEVICE_FD).  The ioctl interface provides
 a direct pass through for VFIO_DEVICE_* ioctls.  The read/write/mmap
diff --git a/drivers/vfio/fsl-mc/vfio_fsl_mc.c b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
index ddee6ed20c4523..74a5de1b791934 100644
--- a/drivers/vfio/fsl-mc/vfio_fsl_mc.c
+++ b/drivers/vfio/fsl-mc/vfio_fsl_mc.c
@@ -135,9 +135,10 @@ static void vfio_fsl_mc_regions_cleanup(struct vfio_fsl_mc_device *vdev)
 	kfree(vdev->regions);
 }
 
-static int vfio_fsl_mc_open(void *device_data)
+static int vfio_fsl_mc_open(struct vfio_device *core_vdev)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	int ret;
 
 	if (!try_module_get(THIS_MODULE))
@@ -161,9 +162,10 @@ static int vfio_fsl_mc_open(void *device_data)
 	return ret;
 }
 
-static void vfio_fsl_mc_release(void *device_data)
+static void vfio_fsl_mc_release(struct vfio_device *core_vdev)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	int ret;
 
 	mutex_lock(&vdev->reflck->lock);
@@ -197,11 +199,12 @@ static void vfio_fsl_mc_release(void *device_data)
 	module_put(THIS_MODULE);
 }
 
-static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
-			      unsigned long arg)
+static long vfio_fsl_mc_ioctl(struct vfio_device *core_vdev,
+			      unsigned int cmd, unsigned long arg)
 {
 	unsigned long minsz;
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
 
 	switch (cmd) {
@@ -327,10 +330,11 @@ static long vfio_fsl_mc_ioctl(void *device_data, unsigned int cmd,
 	}
 }
 
-static ssize_t vfio_fsl_mc_read(void *device_data, char __user *buf,
+static ssize_t vfio_fsl_mc_read(struct vfio_device *core_vdev, char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
 	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
@@ -404,10 +408,12 @@ static int vfio_fsl_mc_send_command(void __iomem *ioaddr, uint64_t *cmd_data)
 	return 0;
 }
 
-static ssize_t vfio_fsl_mc_write(void *device_data, const char __user *buf,
-				 size_t count, loff_t *ppos)
+static ssize_t vfio_fsl_mc_write(struct vfio_device *core_vdev,
+				 const char __user *buf, size_t count,
+				 loff_t *ppos)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	unsigned int index = VFIO_FSL_MC_OFFSET_TO_INDEX(*ppos);
 	loff_t off = *ppos & VFIO_FSL_MC_OFFSET_MASK;
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
@@ -468,9 +474,11 @@ static int vfio_fsl_mc_mmap_mmio(struct vfio_fsl_mc_region region,
 			       size, vma->vm_page_prot);
 }
 
-static int vfio_fsl_mc_mmap(void *device_data, struct vm_area_struct *vma)
+static int vfio_fsl_mc_mmap(struct vfio_device *core_vdev,
+			    struct vm_area_struct *vma)
 {
-	struct vfio_fsl_mc_device *vdev = device_data;
+	struct vfio_fsl_mc_device *vdev =
+		container_of(core_vdev, struct vfio_fsl_mc_device, vdev);
 	struct fsl_mc_device *mc_dev = vdev->mc_dev;
 	unsigned int index;
 
diff --git a/drivers/vfio/mdev/vfio_mdev.c b/drivers/vfio/mdev/vfio_mdev.c
index 4469aaf31b56cb..e7309caa99c71b 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -25,10 +25,11 @@ struct mdev_vfio_device {
 	struct vfio_device vdev;
 };
 
-static int vfio_mdev_open(void *device_data)
+static int vfio_mdev_open(struct vfio_device *core_vdev)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
+
 	int ret;
 
 	if (unlikely(!parent->ops->open))
@@ -44,9 +45,9 @@ static int vfio_mdev_open(void *device_data)
 	return ret;
 }
 
-static void vfio_mdev_release(void *device_data)
+static void vfio_mdev_release(struct vfio_device *core_vdev)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (likely(parent->ops->release))
@@ -55,10 +56,10 @@ static void vfio_mdev_release(void *device_data)
 	module_put(THIS_MODULE);
 }
 
-static long vfio_mdev_unlocked_ioctl(void *device_data,
+static long vfio_mdev_unlocked_ioctl(struct vfio_device *core_vdev,
 				     unsigned int cmd, unsigned long arg)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (unlikely(!parent->ops->ioctl))
@@ -67,10 +68,10 @@ static long vfio_mdev_unlocked_ioctl(void *device_data,
 	return parent->ops->ioctl(mdev, cmd, arg);
 }
 
-static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
+static ssize_t vfio_mdev_read(struct vfio_device *core_vdev, char __user *buf,
 			      size_t count, loff_t *ppos)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (unlikely(!parent->ops->read))
@@ -79,10 +80,11 @@ static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
 	return parent->ops->read(mdev, buf, count, ppos);
 }
 
-static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
-			       size_t count, loff_t *ppos)
+static ssize_t vfio_mdev_write(struct vfio_device *core_vdev,
+			       const char __user *buf, size_t count,
+			       loff_t *ppos)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (unlikely(!parent->ops->write))
@@ -91,9 +93,10 @@ static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
 	return parent->ops->write(mdev, buf, count, ppos);
 }
 
-static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
+static int vfio_mdev_mmap(struct vfio_device *core_vdev,
+			  struct vm_area_struct *vma)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (unlikely(!parent->ops->mmap))
@@ -102,9 +105,9 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
 	return parent->ops->mmap(mdev, vma);
 }
 
-static void vfio_mdev_request(void *device_data, unsigned int count)
+static void vfio_mdev_request(struct vfio_device *core_vdev, unsigned int count)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (parent->ops->request)
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index fae573c6f86bdf..af5696a96a76e0 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -553,9 +553,10 @@ static void vfio_pci_vf_token_user_add(struct vfio_pci_device *vdev, int val)
 	vfio_device_put(pf_dev);
 }
 
-static void vfio_pci_release(void *device_data)
+static void vfio_pci_release(struct vfio_device *core_vdev)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 
 	mutex_lock(&vdev->reflck->lock);
 
@@ -581,9 +582,10 @@ static void vfio_pci_release(void *device_data)
 	module_put(THIS_MODULE);
 }
 
-static int vfio_pci_open(void *device_data)
+static int vfio_pci_open(struct vfio_device *core_vdev)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	int ret = 0;
 
 	if (!try_module_get(THIS_MODULE))
@@ -797,10 +799,11 @@ struct vfio_devices {
 	int max_index;
 };
 
-static long vfio_pci_ioctl(void *device_data,
+static long vfio_pci_ioctl(struct vfio_device *core_vdev,
 			   unsigned int cmd, unsigned long arg)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	unsigned long minsz;
 
 	if (cmd == VFIO_DEVICE_GET_INFO) {
@@ -1402,11 +1405,10 @@ static long vfio_pci_ioctl(void *device_data,
 	return -ENOTTY;
 }
 
-static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
+static ssize_t vfio_pci_rw(struct vfio_pci_device *vdev, char __user *buf,
 			   size_t count, loff_t *ppos, bool iswrite)
 {
 	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(*ppos);
-	struct vfio_pci_device *vdev = device_data;
 
 	if (index >= VFIO_PCI_NUM_REGIONS + vdev->num_regions)
 		return -EINVAL;
@@ -1434,22 +1436,28 @@ static ssize_t vfio_pci_rw(void *device_data, char __user *buf,
 	return -EINVAL;
 }
 
-static ssize_t vfio_pci_read(void *device_data, char __user *buf,
+static ssize_t vfio_pci_read(struct vfio_device *core_vdev, char __user *buf,
 			     size_t count, loff_t *ppos)
 {
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
+
 	if (!count)
 		return 0;
 
-	return vfio_pci_rw(device_data, buf, count, ppos, false);
+	return vfio_pci_rw(vdev, buf, count, ppos, false);
 }
 
-static ssize_t vfio_pci_write(void *device_data, const char __user *buf,
+static ssize_t vfio_pci_write(struct vfio_device *core_vdev, const char __user *buf,
 			      size_t count, loff_t *ppos)
 {
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
+
 	if (!count)
 		return 0;
 
-	return vfio_pci_rw(device_data, (char __user *)buf, count, ppos, true);
+	return vfio_pci_rw(vdev, (char __user *)buf, count, ppos, true);
 }
 
 /* Return 1 on zap and vma_lock acquired, 0 on contention (only with @try) */
@@ -1646,9 +1654,10 @@ static const struct vm_operations_struct vfio_pci_mmap_ops = {
 	.fault = vfio_pci_mmap_fault,
 };
 
-static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
+static int vfio_pci_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
 	unsigned int index;
 	u64 phys_len, req_len, pgoff, req_start;
@@ -1714,9 +1723,10 @@ static int vfio_pci_mmap(void *device_data, struct vm_area_struct *vma)
 	return 0;
 }
 
-static void vfio_pci_request(void *device_data, unsigned int count)
+static void vfio_pci_request(struct vfio_device *core_vdev, unsigned int count)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	struct pci_dev *pdev = vdev->pdev;
 
 	mutex_lock(&vdev->igate);
@@ -1830,9 +1840,10 @@ static int vfio_pci_validate_vf_token(struct vfio_pci_device *vdev,
 
 #define VF_TOKEN_ARG "vf_token="
 
-static int vfio_pci_match(void *device_data, char *buf)
+static int vfio_pci_match(struct vfio_device *core_vdev, char *buf)
 {
-	struct vfio_pci_device *vdev = device_data;
+	struct vfio_pci_device *vdev =
+		container_of(core_vdev, struct vfio_pci_device, vdev);
 	bool vf_token = false;
 	uuid_t uuid;
 	int ret;
diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 6eb749250ee41c..f5f6b537084a67 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -218,9 +218,10 @@ static int vfio_platform_call_reset(struct vfio_platform_device *vdev,
 	return -EINVAL;
 }
 
-static void vfio_platform_release(void *device_data)
+static void vfio_platform_release(struct vfio_device *core_vdev)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 
 	mutex_lock(&driver_lock);
 
@@ -244,9 +245,10 @@ static void vfio_platform_release(void *device_data)
 	module_put(vdev->parent_module);
 }
 
-static int vfio_platform_open(void *device_data)
+static int vfio_platform_open(struct vfio_device *core_vdev)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 	int ret;
 
 	if (!try_module_get(vdev->parent_module))
@@ -293,10 +295,12 @@ static int vfio_platform_open(void *device_data)
 	return ret;
 }
 
-static long vfio_platform_ioctl(void *device_data,
+static long vfio_platform_ioctl(struct vfio_device *core_vdev,
 				unsigned int cmd, unsigned long arg)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
+
 	unsigned long minsz;
 
 	if (cmd == VFIO_DEVICE_GET_INFO) {
@@ -455,10 +459,11 @@ static ssize_t vfio_platform_read_mmio(struct vfio_platform_region *reg,
 	return -EFAULT;
 }
 
-static ssize_t vfio_platform_read(void *device_data, char __user *buf,
-				  size_t count, loff_t *ppos)
+static ssize_t vfio_platform_read(struct vfio_device *core_vdev,
+				  char __user *buf, size_t count, loff_t *ppos)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
 	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
 
@@ -531,10 +536,11 @@ static ssize_t vfio_platform_write_mmio(struct vfio_platform_region *reg,
 	return -EFAULT;
 }
 
-static ssize_t vfio_platform_write(void *device_data, const char __user *buf,
+static ssize_t vfio_platform_write(struct vfio_device *core_vdev, const char __user *buf,
 				   size_t count, loff_t *ppos)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 	unsigned int index = VFIO_PLATFORM_OFFSET_TO_INDEX(*ppos);
 	loff_t off = *ppos & VFIO_PLATFORM_OFFSET_MASK;
 
@@ -573,9 +579,10 @@ static int vfio_platform_mmap_mmio(struct vfio_platform_region region,
 			       req_len, vma->vm_page_prot);
 }
 
-static int vfio_platform_mmap(void *device_data, struct vm_area_struct *vma)
+static int vfio_platform_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma)
 {
-	struct vfio_platform_device *vdev = device_data;
+	struct vfio_platform_device *vdev =
+		container_of(core_vdev, struct vfio_platform_device, vdev);
 	unsigned int index;
 
 	index = vma->vm_pgoff >> (VFIO_PLATFORM_OFFSET_SHIFT - PAGE_SHIFT);
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 2d6d7cc1d1ebf9..01de47d1810b6b 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -832,7 +832,7 @@ static struct vfio_device *vfio_device_get_from_name(struct vfio_group *group,
 		int ret;
 
 		if (it->ops->match) {
-			ret = it->ops->match(it->device_data, buf);
+			ret = it->ops->match(it, buf);
 			if (ret < 0) {
 				device = ERR_PTR(ret);
 				break;
@@ -893,7 +893,7 @@ void vfio_unregister_group_dev(struct vfio_device *device)
 	rc = try_wait_for_completion(&device->comp);
 	while (rc <= 0) {
 		if (device->ops->request)
-			device->ops->request(device->device_data, i++);
+			device->ops->request(device, i++);
 
 		if (interrupted) {
 			rc = wait_for_completion_timeout(&device->comp,
@@ -1379,7 +1379,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
-	ret = device->ops->open(device->device_data);
+	ret = device->ops->open(device);
 	if (ret) {
 		vfio_device_put(device);
 		return ret;
@@ -1391,7 +1391,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	 */
 	ret = get_unused_fd_flags(O_CLOEXEC);
 	if (ret < 0) {
-		device->ops->release(device->device_data);
+		device->ops->release(device);
 		vfio_device_put(device);
 		return ret;
 	}
@@ -1401,7 +1401,7 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	if (IS_ERR(filep)) {
 		put_unused_fd(ret);
 		ret = PTR_ERR(filep);
-		device->ops->release(device->device_data);
+		device->ops->release(device);
 		vfio_device_put(device);
 		return ret;
 	}
@@ -1558,7 +1558,7 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
 {
 	struct vfio_device *device = filep->private_data;
 
-	device->ops->release(device->device_data);
+	device->ops->release(device);
 
 	vfio_group_try_dissolve_container(device->group);
 
@@ -1575,7 +1575,7 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	if (unlikely(!device->ops->ioctl))
 		return -EINVAL;
 
-	return device->ops->ioctl(device->device_data, cmd, arg);
+	return device->ops->ioctl(device, cmd, arg);
 }
 
 static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
@@ -1586,7 +1586,7 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 	if (unlikely(!device->ops->read))
 		return -EINVAL;
 
-	return device->ops->read(device->device_data, buf, count, ppos);
+	return device->ops->read(device, buf, count, ppos);
 }
 
 static ssize_t vfio_device_fops_write(struct file *filep,
@@ -1598,7 +1598,7 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 	if (unlikely(!device->ops->write))
 		return -EINVAL;
 
-	return device->ops->write(device->device_data, buf, count, ppos);
+	return device->ops->write(device, buf, count, ppos);
 }
 
 static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
@@ -1608,7 +1608,7 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
 
-	return device->ops->mmap(device->device_data, vma);
+	return device->ops->mmap(device, vma);
 }
 
 static const struct file_operations vfio_device_fops = {
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 4995faf51efeae..784c34c0a28763 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -44,17 +44,17 @@ struct vfio_device {
  */
 struct vfio_device_ops {
 	char	*name;
-	int	(*open)(void *device_data);
-	void	(*release)(void *device_data);
-	ssize_t	(*read)(void *device_data, char __user *buf,
+	int	(*open)(struct vfio_device *vdev);
+	void	(*release)(struct vfio_device *vdev);
+	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos);
-	ssize_t	(*write)(void *device_data, const char __user *buf,
+	ssize_t	(*write)(struct vfio_device *vdev, const char __user *buf,
 			 size_t count, loff_t *size);
-	long	(*ioctl)(void *device_data, unsigned int cmd,
+	long	(*ioctl)(struct vfio_device *vdev, unsigned int cmd,
 			 unsigned long arg);
-	int	(*mmap)(void *device_data, struct vm_area_struct *vma);
-	void	(*request)(void *device_data, unsigned int count);
-	int	(*match)(void *device_data, char *buf);
+	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
+	void	(*request)(struct vfio_device *vdev, unsigned int count);
+	int	(*match)(struct vfio_device *vdev, char *buf);
 };
 
 extern struct iommu_group *vfio_iommu_group_get(struct device *dev);
-- 
2.30.1

