Return-Path: <kvm+bounces-56733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C72B430E4
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 06:11:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 056937B86B2
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 04:09:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAEE26FA77;
	Thu,  4 Sep 2025 04:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q+yh2iog"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2391258CED;
	Thu,  4 Sep 2025 04:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756958929; cv=fail; b=C9uZGMTkGYtZpSAAWU8hzvGSyafvuT18qOdXkuIj1noJWNhMB00HOIAji542+09IZM56krqAvOFe0F8hMlgRGDLjpc9N1yl2TpIgl2bLd1d9XWiTpYzRGUpIZPT4G0clD7kUHRb2kNo1ZicyUH3VJzQpp2drPP3vP0ipcrQWUGg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756958929; c=relaxed/simple;
	bh=EhEhxtDd4+lqofVLump5Fu9L38P35M+Mc6h47XTW+xs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y+M5CPkZVkqEJjdpqRbloT8P6psVNXluWm/mRuWYGXT00gy17M2gjgdBn4xTppASaP/7ppfDgaiBOKD85x/eb4m52b6mak+ys7atrXQ/0FDEtzgKmx2DBT+1+k50ZPTsiv4TrO2p7fmo2oVAOXSHJh81noDlUc5E2JtCMXW9FXU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q+yh2iog; arc=fail smtp.client-ip=40.107.93.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LOMpIuch7dbtS9vxmkg7IAnAxtzAAh+gQRANSIDtbIxCSLoMM+zAS08P0Gepk7xGG4soKEPzkNTzsewAmgLsV84NSet5sm5zIsTVU/jgG8E+qwH8M7RvLyKoHL3L1dMYxYafrS5j198uX2TH2cBmPdwRoIDjw1pQlGXRDs6JMKK/Mxqx17+W3Aim/R9b0fUtmrgvbssJMzN7rAIkePxJGjn0qaqJWxvFMtUdh9N/NIdq1hd7H7FTY0rp4OWDdboDj3WrV7g095qpf6i0tOxJL7w76xDMGc+Vxxo/4/QKls7uTtkMJPEd8DBbHqzhXAFCOLwjea/mf9UkDjDbFYtORw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JePaWapvwsKekbtka54kAQ+t860eZBEn2CaYPVS0l9U=;
 b=m8OSeJMKM8LiQq0CBFSfwTxuudCJG55bDn7S6SI4s+AqnA/sEZmgkovx58dUu7lCD3o1QlVVz7lJSWvfWluClnDVGS1kddsaHXUNPBRGS+lstud/t2lBy79AaBZJ2bVH4jn7GCwfDaIclX7059Sm/Uxna+VM2uMmsDzja+dKm/GHDDaywsWfUwrSWWaIlxnu8YifMDHdY472MRtcfz/qudaa+C1tjPz3uXXczsZj2XYWUHIJj0SkVw8lQ8BYRrOOMf8p7oPOCCCnvm8jZrcJfi3nDUNksSSVMxYIYWZ/mVwQZ80/GKxgczwRTtEnqvoacqQg6PJ5EfdLy3bKgQH3qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JePaWapvwsKekbtka54kAQ+t860eZBEn2CaYPVS0l9U=;
 b=Q+yh2iog0UjCnZWV3agWzoIv/oSm7HcssGi6+taF2IqtqC0d18omlwdco9cuPrsbaFdo2zSc/aeBDld2+XdMtMGsfy4GOQXgwbG8f/p8WRipISgVOTKcMINNBjJKV1o+ZKyv/fahaVODZ4rrYuKX/ioqqPbbsvVZBP4vy8PwezBVkMoMOzgRVESbdomLoYsxBmNMJCWu5L/Ks3qhaxSwOGxVB1jzldgPueXrHiF55/2R2/gl4QHjG5YosxizRR6VSuvWOm2s8F+tzPGku6UTvlip/7ilMJDlS6iFzGsh4G16SKZts9WbBzpVA5Pcg7NLIKUUnqjliEA3DMTle1dQfA==
Received: from BYAPR03CA0036.namprd03.prod.outlook.com (2603:10b6:a02:a8::49)
 by IA1PR12MB9497.namprd12.prod.outlook.com (2603:10b6:208:593::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 04:08:42 +0000
Received: from SJ5PEPF000001D5.namprd05.prod.outlook.com
 (2603:10b6:a02:a8:cafe::7c) by BYAPR03CA0036.outlook.office365.com
 (2603:10b6:a02:a8::49) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.18 via Frontend Transport; Thu,
 4 Sep 2025 04:08:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SJ5PEPF000001D5.mail.protection.outlook.com (10.167.242.57) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.14 via Frontend Transport; Thu, 4 Sep 2025 04:08:42 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14; Wed, 3 Sep
 2025 21:08:34 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Wed, 3 Sep 2025 21:08:33 -0700
Received: from localhost.nvidia.com (10.127.8.12) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Wed, 3 Sep 2025 21:08:33 -0700
From: <ankita@nvidia.com>
To: <ankita@nvidia.com>, <jgg@nvidia.com>, <alex.williamson@redhat.com>,
	<yishaih@nvidia.com>, <skolothumtho@nvidia.com>, <kevin.tian@intel.com>,
	<yi.l.liu@intel.com>, <zhiw@nvidia.com>
CC: <aniketa@nvidia.com>, <cjia@nvidia.com>, <kwankhede@nvidia.com>,
	<targupta@nvidia.com>, <vsethi@nvidia.com>, <acurrid@nvidia.com>,
	<apopple@nvidia.com>, <jhubbard@nvidia.com>, <danw@nvidia.com>,
	<anuaggarwal@nvidia.com>, <mochs@nvidia.com>, <kjaju@nvidia.com>,
	<dnigam@nvidia.com>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [RFC 12/14] vfio/nvgrace-egm: Introduce ioctl to share retired pages
Date: Thu, 4 Sep 2025 04:08:26 +0000
Message-ID: <20250904040828.319452-13-ankita@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904040828.319452-1-ankita@nvidia.com>
References: <20250904040828.319452-1-ankita@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D5:EE_|IA1PR12MB9497:EE_
X-MS-Office365-Filtering-Correlation-Id: b22e721f-9603-4f2d-a422-08ddeb68bc0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?S8/h0LgUPGJ3xRy5zqnTqCbzBWiv2lUgpWu7WdLD6q2AZpE0g4qipvrE7H9k?=
 =?us-ascii?Q?JYaoKYW2RoWPNi+mURZIPyAq4LYcnLdtYyC+fRRTTMG4LvTwU3zaZurICHhH?=
 =?us-ascii?Q?B0QNPSrg3mKxVLFjIcOWghA/2q96px5Ev8xUVaSEuszshqnbVNzOjrlvZrnW?=
 =?us-ascii?Q?4yseP/oB9m51vyjU4Nr83Jans7dv5LjzWFrJLguzakqPWRHlAhIO3dCKzzx2?=
 =?us-ascii?Q?tHtynyxAqkvIbNKTEPsbBiz+PfIZuijY03tCCGqFyPo+nnrn9IIGiFLf9NBn?=
 =?us-ascii?Q?HosMqbEpaZWfhLMVQZFCUGz3NVfdV8LxIaMHALH8dBfCkvjeKe8v70Bs1sNy?=
 =?us-ascii?Q?zdTlwqsGZF9ZQnHYapjzTJdnHGLWuRX/a5bq4Oa6h1lbRP+kLCFksL95kDB0?=
 =?us-ascii?Q?wESuRjl15eGl8aqw6lLxS3DhU3Klu+DnHxL0sby+IU6djcJbPJZg3RAoCGO/?=
 =?us-ascii?Q?eU93mhcf+bC+r5n+/C4qRDEQpGlvKFXH/tvlgDtUNVYmEVrlx5z4xKkNK1QN?=
 =?us-ascii?Q?8VwyHuiorQl5/qZU3selv2GMPAadrZcBAbE3D55/EBOaCYYujBgE0XFLBZZC?=
 =?us-ascii?Q?bhZjXiq+ELKaQrfgKEQKbCqtg4cPbW+jf1f/Kmp5Ygb1T8uLa/offi4CiW0v?=
 =?us-ascii?Q?ZuEpyCj7Se6QhT5vOsbDl2DuijFemOYEA/nUJJTP/cRiIDLhcWsd0wsRlEjT?=
 =?us-ascii?Q?DPpLo/zLranNp9IIu0pPfI76P/C7g3hxxr3TMzJWW+emBu0oY4sUYu3Ws/Cv?=
 =?us-ascii?Q?fn9GGEsAUOiVKANJlzRQhRPVwXDpuDBHd3/xEA7XEk2pNX/T3ldAOM9bWuLl?=
 =?us-ascii?Q?WUk4DmQT8C6A5Gy6cKeHzNQyJqyS5+1xFfaK1qEgaXTkk73fN9REVVFr2udj?=
 =?us-ascii?Q?daK4seM6FrzFakJDF4wbTMmlMZhSC4VsoE1vVJmjL3xms+flP7Z1a1YPHdEy?=
 =?us-ascii?Q?zKmWhhtNGlJnbxOFTn+uP6RXATT94hpKT5mszJb9C64EYEMP33glt8raaLPh?=
 =?us-ascii?Q?MJBZ+yIFM6BCbx6NiHDgT5X608KiF4n51turMdpu7D7lZlbcpEag3JHFW9OY?=
 =?us-ascii?Q?oIVgQbQ7YT7tiZWgLtKksKNhd1NsRvY+h3SS7CIvOg9R1qej4UUW3uL16Gmk?=
 =?us-ascii?Q?VK6Yznp2j3hN01LrCD107gmSAZ2VAhP85iUUdMkj52NyePH1vQutjQuOR3xz?=
 =?us-ascii?Q?ylcOdKCGlNozOqq43suoxgMPS1s4Ej3/vCwp0aTfYRcV5fhtd2uxaRcK7sj0?=
 =?us-ascii?Q?Hb+ZuhEfQGqKQdvfFoK9NRFigGx9PEvI6tkR+ub02Rg8BCCsDlynzE0bIweu?=
 =?us-ascii?Q?TSv3kzOMC+HMqqZveB0EQZzo9UUI52msT5j+XspoubR3Y0Z4aT39fsBP1Gb2?=
 =?us-ascii?Q?0Lt4Qq9XRopy/Hi3kzaq/Ioa+6cX4pBwr7UDdxicTfmOiCjEldmjIBnGmy1l?=
 =?us-ascii?Q?cxWnnIcuMRy/lIguGjabufY426mkEo7Mmk824v9dcyC6IIMLhHsEd/t8YlAX?=
 =?us-ascii?Q?gpm9SdA4uVo748Ql5QH81U8L2TaZc66ITVZE?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013)(7053199007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 04:08:42.0134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b22e721f-9603-4f2d-a422-08ddeb68bc0a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D5.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB9497

From: Ankit Agrawal <ankita@nvidia.com>

nvgrace-egm module stores the list of retired page offsets to be made
available for usermode processes. Introduce an ioctl to share the
information with the userspace.

The ioctl is called by usermode apps such as QEMU to get the retired
page offsets. The usermode apps are expected to take appropriate action
to communicate the list to the VM.

Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
---
 MAINTAINERS                        |  1 +
 drivers/vfio/pci/nvgrace-gpu/egm.c | 67 ++++++++++++++++++++++++++++++
 include/uapi/linux/egm.h           | 26 ++++++++++++
 3 files changed, 94 insertions(+)
 create mode 100644 include/uapi/linux/egm.h

diff --git a/MAINTAINERS b/MAINTAINERS
index ec6bc10f346d..bd2d2d309d92 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -26481,6 +26481,7 @@ M:	Ankit Agrawal <ankita@nvidia.com>
 L:	kvm@vger.kernel.org
 S:	Supported
 F:	drivers/vfio/pci/nvgrace-gpu/egm.c
+F:	include/uapi/linux/egm.h
 
 VFIO PCI DEVICE SPECIFIC DRIVERS
 R:	Jason Gunthorpe <jgg@nvidia.com>
diff --git a/drivers/vfio/pci/nvgrace-gpu/egm.c b/drivers/vfio/pci/nvgrace-gpu/egm.c
index 7a026b4d98f7..2cb100e39c4b 100644
--- a/drivers/vfio/pci/nvgrace-gpu/egm.c
+++ b/drivers/vfio/pci/nvgrace-gpu/egm.c
@@ -5,6 +5,7 @@
 
 #include <linux/vfio_pci_core.h>
 #include <linux/nvgrace-egm.h>
+#include <linux/egm.h>
 
 #define MAX_EGM_NODES 4
 
@@ -90,11 +91,77 @@ static int nvgrace_egm_mmap(struct file *file, struct vm_area_struct *vma)
 			       vma->vm_page_prot);
 }
 
+static long nvgrace_egm_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	unsigned long minsz = offsetofend(struct egm_retired_pages_list, count);
+	struct egm_retired_pages_list info;
+	void __user *uarg = (void __user *)arg;
+	struct chardev *egm_chardev = file->private_data;
+
+	if (copy_from_user(&info, uarg, minsz))
+		return -EFAULT;
+
+	if (info.argsz < minsz || !egm_chardev)
+		return -EINVAL;
+
+	switch (cmd) {
+	case EGM_RETIRED_PAGES_LIST:
+		int ret;
+		unsigned long retired_page_struct_size = sizeof(struct egm_retired_pages_info);
+		struct egm_retired_pages_info tmp;
+		struct h_node *cur_page;
+		struct hlist_node *tmp_node;
+		unsigned long bkt;
+		int count = 0, index = 0;
+
+		hash_for_each_safe(egm_chardev->htbl, bkt, tmp_node, cur_page, node)
+			count++;
+
+		if (info.argsz < (minsz + count * retired_page_struct_size)) {
+			info.argsz = minsz + count * retired_page_struct_size;
+			info.count = 0;
+			goto done;
+		} else {
+			hash_for_each_safe(egm_chardev->htbl, bkt, tmp_node, cur_page, node) {
+				/*
+				 * This check fails if there was an ECC error
+				 * after the usermode app read the count of
+				 * bad pages through this ioctl.
+				 */
+				if (minsz + index * retired_page_struct_size >= info.argsz) {
+					info.argsz = minsz + index * retired_page_struct_size;
+					info.count = index;
+					goto done;
+				}
+
+				tmp.offset = cur_page->mem_offset;
+				tmp.size = PAGE_SIZE;
+
+				ret = copy_to_user(uarg + minsz +
+						   index * retired_page_struct_size,
+						   &tmp, retired_page_struct_size);
+				if (ret)
+					return -EFAULT;
+				index++;
+			}
+
+			info.count = index;
+		}
+		break;
+	default:
+		return -EINVAL;
+	}
+
+done:
+	return copy_to_user(uarg, &info, minsz) ? -EFAULT : 0;
+}
+
 static const struct file_operations file_ops = {
 	.owner = THIS_MODULE,
 	.open = nvgrace_egm_open,
 	.release = nvgrace_egm_release,
 	.mmap = nvgrace_egm_mmap,
+	.unlocked_ioctl = nvgrace_egm_ioctl,
 };
 
 static void egm_chardev_release(struct device *dev)
diff --git a/include/uapi/linux/egm.h b/include/uapi/linux/egm.h
new file mode 100644
index 000000000000..d157fbb5e305
--- /dev/null
+++ b/include/uapi/linux/egm.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (c) 2025, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#ifndef _UAPIEGM_H
+#define _UAPIEGM_H
+
+#define EGM_TYPE ('E')
+
+struct egm_retired_pages_info {
+	__aligned_u64 offset;
+	__aligned_u64 size;
+};
+
+struct egm_retired_pages_list {
+	__u32 argsz;
+	/* out */
+	__u32 count;
+	/* out */
+	struct egm_retired_pages_info retired_pages[];
+};
+
+#define EGM_RETIRED_PAGES_LIST     _IO(EGM_TYPE, 100)
+
+#endif /* _UAPIEGM_H */
-- 
2.34.1


