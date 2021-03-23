Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B783464B5
	for <lists+kvm@lfdr.de>; Tue, 23 Mar 2021 17:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbhCWQPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Mar 2021 12:15:36 -0400
Received: from mail-bn7nam10on2089.outbound.protection.outlook.com ([40.107.92.89]:23521
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233141AbhCWQPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Mar 2021 12:15:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMgMbbwZyMOxYXdjPR+nTQiCqmxG3UOHpWjra6eSYBFELMZ/xOaaPqOUuRYOuIZZthbLQI+ZJKdIrRzHSrA51NatRc2P3aIamaoOrrcB50T2acoaiZQgLt3co3Gvqhlua2LVxf0hkr8ei9Ve/8eQkgPLDRccJlVjg+xPvS/Dl8TAOBe9YnG0JagORBhbwiI4hMTL5fGxpRd/dJzAXe+zti0/QXDLPYBSztYrkT+5j5G1QYg5VJ/YXom+Sf5AtdbJaKGtCG/QLcF/VCPxoBwiJhcr2w4E/okvgn+xAX18Eg2M0Mwd2t5RSlLo0jAK6sND+FEQej92Zw9W6ZKg6+kJbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tt2LG1l8OPQLTRf/lg3gHpfhqmd0UWli+Sw2vTVs5dE=;
 b=cTKzoLyUHDPoUMtjFdnUi4FeopyW+N3mG5AXREXAECC0TUgrijFsjUOXeQfLBu8xNL7o2xyeolPLai7rdw1hctxbdsw5/k/kLQghEZBrCB85efeDZAqun+QOCzSLGo9B69iClK23Tp8t1v8+kNfnc2zIW8D7n6vtK8QdobkZUmkmbVnwJWhuUWyJ5zR84lrkx07hvJs72IAl3flDD0dtErVXeQJOFNTl0u/a2AeFcv2ubl0eT8FcWmhyTvVdtoIIFkuPHr97ytuttxerl+MXX0dOQ+pxuKPezMsSUx9bgwxaIHOw8vLwq9m4cswo8jimlBUAVA2vlbo0wzl5Z1FlWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tt2LG1l8OPQLTRf/lg3gHpfhqmd0UWli+Sw2vTVs5dE=;
 b=Xdyq4i3IjnmZFdrbXqj237pTYhoLztrz42aExEWGg2HlsalRbyWLTfFy1jbTwVdMjDrVpuuzeLmSwXViOmnyk0fRTtwKchtpJTKnJO+k7d4Bq3+seIhIoe+2ydJpMbflmOa43Qbpc4R10JfFd9Rws6jLHmttutDG0cWbDiO5UZdwID8F3b2wewpXjYmoaQKg49MopY5x4LVECPnO9nOy5TJqfyCFCMusczTnm7z43gfKslA87sXoEO7oNTj5hqgyd2rDbHrqHBSPFW/QnepKEFdhaN6LWiUqJCC7hC01Rlv4W2ZKYRae+Ihtl9WsB6bKXqq5qe4DG3cswvjqjLqj+A==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Tue, 23 Mar
 2021 16:15:10 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3955.027; Tue, 23 Mar 2021
 16:15:10 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v3 12/14] vfio: Make vfio_device_ops pass a 'struct vfio_device *' instead of 'void *'
Date:   Tue, 23 Mar 2021 13:15:04 -0300
Message-Id: <12-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
In-Reply-To: <0-v3-225de1400dfc+4e074-vfio1_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: BL1PR13CA0162.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::17) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by BL1PR13CA0162.namprd13.prod.outlook.com (2603:10b6:208:2bd::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Tue, 23 Mar 2021 16:15:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lOjgQ-001aD8-S2; Tue, 23 Mar 2021 13:15:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65d06126-a500-402d-3bd6-08d8ee16d3e1
X-MS-TrafficTypeDiagnostic: DM6PR12MB4267:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4267D0170C4C6A7589DBFE66C2649@DM6PR12MB4267.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XgtK52l8c8g6qHUYjS5+ikwfG7fB6NlgzZgUVwQfXNzXaqfFzisnU+NeWluDx3TNiz5fl3+Ovynvuxn1d1Fia0bgDJD6aYJLQECsADB0PelZ/XrgvNMWNC7H7BA0TLkmECBZhs2TngUN2x+gHmILG7Zm5hWIDuH6/D2bADLATFoARQoS0yK8+1PdstbrHS+GvP+LuAJdC5TwM1xOBp+e4lfvxvTL5voCPfP93wR8nM8BqFi5YmwAGzgB97cYwo9+iJg5fMqFLrqF7w7Q1xi7piO0f7yKH8SP8fglSsDiuFq6xwxnIydV5t6RCf+3pzguun0qWaRT9I2InhdJmrKUhdlAuhuUuBCOyLDI9rIizCTamjGwVOgSqSdNYxNCU7kLb3Qyqm1QU+AvG0OevdeOHLfl0DlmqrHcMC7D/+EI2VNyt4q/zIDLvRBCVcFLSzU6oMHYIDLD/AKzcesM/SnRLp7IFyq65QzMt3tcUBCBe1amifNCuGc2jcQLvAcwltpraMrLzO8UD8aNjPmOwEHnzIqo0w/JuE0z5n3oVYT7UREE6DZaBlzxoMOOi2MjziSkHOedueNcdtTjU1BIX3KO8NRQ4c90YwfaELeLaCkCAMjHajcew5ia2gfDccOvMB6RkNFGVaJuREIghjhNhF0wr6P4Pr+l63o0ABek8AzpcJA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(376002)(136003)(396003)(366004)(5660300002)(66476007)(30864003)(2616005)(66946007)(66556008)(2906002)(186003)(7416002)(83380400001)(426003)(54906003)(110136005)(316002)(8936002)(478600001)(8676002)(107886003)(4326008)(26005)(9746002)(9786002)(86362001)(36756003)(38100700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?igIPDc3bKg98ng0x4NpCSUrMvKLRn/yUjPcW+Wg1ZtzNlR3ZurVvv/9yrvxW?=
 =?us-ascii?Q?dLpVxMMga33Te4Hck3unDk3kfbECxWQ8nTW6JAbq35zf89/5Sn7N3kbhQT5R?=
 =?us-ascii?Q?UmMmzoQCmLHfDAXGru/fgTdJZPdapgTt/MG+LB3cRzg41ZKK58hZn6I5YDlm?=
 =?us-ascii?Q?b4/hUFcdjC94/d2/m1XTDhd0v1XTKB5ADcO36itZzVAsAG0fpldyo3pFxIoi?=
 =?us-ascii?Q?RcKtnZlz7pctOPojvH1hQkMKhO2dqANsTcLyiICQeWxWdXHCJKbbtbQOOF/K?=
 =?us-ascii?Q?Z0rIKwoyJKszARHNFodr1jOemy9gm0077m8sv/zJfdvMWncE0fkAYBWvbpYP?=
 =?us-ascii?Q?KUrvxMCH1oWLq14vSTr0ghCyv4ByjFSsrK2F8k+FMFgA128CczLfC1N/wlUZ?=
 =?us-ascii?Q?ZabR4bp9H01ILCvikLZB7au1xQiDveJvhnpBbxBzdME3q9MzF0beds4WG42O?=
 =?us-ascii?Q?usnEzwafHsHonxQ2tC1CNcUqXRDuCKtalfGlGcvbylsOLEnShdjnyF5vBZdN?=
 =?us-ascii?Q?E7sbmgmkXqXIFbV7UDFZjoP6UFAf3WD+03GLOt3HVZ3WLT5n+lDaChNlVG0M?=
 =?us-ascii?Q?aUXtb9ukQFVVmzKzq3I1DJcq7L6BFJxlE/D+7Ad4GUylF9NHRXpKVzFF/73K?=
 =?us-ascii?Q?+CpULCc4m07y2tF/W6dgScut3iKV/sKYo6m/ykcyE1wqGo7iukVJsQxyxZyA?=
 =?us-ascii?Q?rncnvWLmkba9dJb9K3s56YOKMKt1Tbf95UnDBPSqPnKyzXJrjTP+RMiKM5Uz?=
 =?us-ascii?Q?LqBj4SiVpsCi6l0+R/wTLw7zuYULkJt+gS3z0pzXe/CySPD09Lzv4OZCD9te?=
 =?us-ascii?Q?Gl8o6IYJziycRW0aIbNaowkYE5oqYHGsNZQHRLh/Hiv+/Fut0wuB0jWYd6tm?=
 =?us-ascii?Q?egX1I/3Chb4nPizlmb/rdN5rhb1cx70zoOG6Uy32zo74PNUeypcEU+AYtoCS?=
 =?us-ascii?Q?+hjjsRDGsMu+cHmCuyhIab2afp55Tt6/Ild3Jq7AnYq1gJrXFiXt93UpQyTL?=
 =?us-ascii?Q?FJ3VlqbgGXDFbGy/dhpHz0X4L4NOzL6xF6hcEgl+pwlrM2CR0qOK6FDaEsgo?=
 =?us-ascii?Q?eEj5DLCcGBkwCEmIQCPAKXOSekLbTJOqSKIFweNDrrPPZb98p9GAeOqN+Mml?=
 =?us-ascii?Q?7z/i2AyJECgXgxYWG5q18h0cOLBtCeCMZW+c/Y3EegIpSU3rkTbjl7ECSzeH?=
 =?us-ascii?Q?8PlyHbuAJMY7RDTPtP3pKbN+1wyKIzOs6SGctehaWSRuAcMxtoUctnYJSUb4?=
 =?us-ascii?Q?lMiM+MHmXRvu18W5S/Tfo+fw5rLINs83TbxLG3O28aZyDosLfM7n57yNtL+g?=
 =?us-ascii?Q?IU4VGXHmyG/vaaMpABp/c9e1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65d06126-a500-402d-3bd6-08d8ee16d3e1
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2021 16:15:08.7308
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4iz6bnto2/xd70YE63StOOJ6sE2d9/g0tZdstdV/jRTIFUN2pIOjJ15wr8A5QI9B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the standard kernel pattern, the ops associated with a struct get
the struct pointer in for typesafety. The expected design is to use
container_of to cleanly go from the subsystem level type to the driver
level type without having any type erasure in a void *.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
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
index ad6c6feeeb4b2a..45f397c04a8959 100644
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
index 4043cc91f9524e..11b3e15403ba4f 100644
--- a/drivers/vfio/mdev/vfio_mdev.c
+++ b/drivers/vfio/mdev/vfio_mdev.c
@@ -21,10 +21,11 @@
 #define DRIVER_AUTHOR   "NVIDIA Corporation"
 #define DRIVER_DESC     "VFIO based driver for Mediated device"
 
-static int vfio_mdev_open(void *device_data)
+static int vfio_mdev_open(struct vfio_device *core_vdev)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
+
 	int ret;
 
 	if (unlikely(!parent->ops->open))
@@ -40,9 +41,9 @@ static int vfio_mdev_open(void *device_data)
 	return ret;
 }
 
-static void vfio_mdev_release(void *device_data)
+static void vfio_mdev_release(struct vfio_device *core_vdev)
 {
-	struct mdev_device *mdev = device_data;
+	struct mdev_device *mdev = to_mdev_device(core_vdev->dev);
 	struct mdev_parent *parent = mdev->parent;
 
 	if (likely(parent->ops->release))
@@ -51,10 +52,10 @@ static void vfio_mdev_release(void *device_data)
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
@@ -63,10 +64,10 @@ static long vfio_mdev_unlocked_ioctl(void *device_data,
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
@@ -75,10 +76,11 @@ static ssize_t vfio_mdev_read(void *device_data, char __user *buf,
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
@@ -87,9 +89,10 @@ static ssize_t vfio_mdev_write(void *device_data, const char __user *buf,
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
@@ -98,9 +101,9 @@ static int vfio_mdev_mmap(void *device_data, struct vm_area_struct *vma)
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
index a0ac20a499cf6c..5f1a782d1c65ae 100644
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
index 180b4ab02d115a..e6f5109fba4858 100644
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
2.31.0

