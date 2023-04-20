Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3646E8BAB
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 09:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbjDTHsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 03:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjDTHsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 03:48:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2079.outbound.protection.outlook.com [40.107.92.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A57246A4;
        Thu, 20 Apr 2023 00:48:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrgLksOJBA+x4rIK5bVZoZrPW9V8HHBerPKKPgJ4xFvmDfz+tjC9a+XPBSMgLpR1ZnKzOWB5fxPrc8bh3lcG2rCiN2DPw0I7kPrDMk11vzzdkBntD69JKaBJ8od6a34P8tXKrqb4aTEHPPnjAuAWDFy1hpvFSWcJPavZvCW/Wnc+qmYNb4ExrJ+4hfeXoPNis0YIkI+eyqgYoi1yfi3YgPfW/Op3O0RGB60BUIx4ret6tDoQzYmkTO3NXjfzyXpWA6mZuTRupG0VumprO7ZTVHvk5qnVll6Mwz0+Qc9m+lfgG8Jg1szCZISWlspIxpnj81ceJ5Y1c+jXg4nsAcXlDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SB5IaaRV6DtyBHNYRvQgKfnE6ElEe6c/CS9kqoQICfg=;
 b=bkwCjBd4Tbmoxv9Vqhfc23g7gVgSazTVCfbYJvolixVjCrrtwu5Bo/iD8LhW2y/1OGkVV3Eqq8xz21deRsymNryIf4XpR/L+1edUHcTE6aSX4XaMHkz+3UJ0e9+07V2wMoeb2nkPW3pLcl1W9e0OM5nnPDkQjttA22sld72tbKEQtN6LbI/7sxpx7DkxDOuSgex9zb7bRPW52Dc66d7pwNl6OkovKE9OE9s7h1g/YQFMizmG+SkJe+nQVr95NseIGBmQwcegJehenxrvur3fL1pbzTGWEbH0JhZ23p7Ra1eYas3o1cmGAHSCigyzsdjI1zEeHo/1IaY0Zmztf1Pa+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SB5IaaRV6DtyBHNYRvQgKfnE6ElEe6c/CS9kqoQICfg=;
 b=Y+K0fNSbGmKNOTJ2LSfunrGdJkpVcyFlyY+VDs1qOjOAPQpHmZzC51jFLzYd+QrSy3lQ88suJN1yMvNzfUgOtQnfPUGa0K9dREDRt4AtnLQ30f25RGWeUhF2ROTAGGM78uA0y3C/QYlEFBsVzmzDC2mK8AdV7du21d2Ht4W3dEq1FhGdNPkSbeGzCDomA9gmM2ZGwZiEI5Tl6Q8FUjS0c5OAnIRdJjfDHs9qXxnE8Uw6sJZZjdf42YhfQnWHMoAv8k/PEegqrnKz+pF76pY5aBBpLd/ApX/0KE/R+uF8chY2ctTehP0nFjAOcmJqiZTgUJjIq745Q1Wr1/Ednc1nLg==
Received: from DM5PR07CA0063.namprd07.prod.outlook.com (2603:10b6:4:ad::28) by
 MW4PR12MB7166.namprd12.prod.outlook.com (2603:10b6:303:224::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6277.31; Thu, 20 Apr 2023 07:48:30 +0000
Received: from DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::43) by DM5PR07CA0063.outlook.office365.com
 (2603:10b6:4:ad::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.24 via Frontend
 Transport; Thu, 20 Apr 2023 07:48:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT022.mail.protection.outlook.com (10.13.172.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.25 via Frontend Transport; Thu, 20 Apr 2023 07:48:30 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 20 Apr 2023
 00:48:19 -0700
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 20 Apr
 2023 00:48:19 -0700
Received: from Asurada-Nvidia.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Thu, 20 Apr 2023 00:48:18 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     <jgg@nvidia.com>, <kevin.tian@intel.com>,
        <alex.williamson@redhat.com>
CC:     <robin.murphy@arm.com>, <eric.auger@redhat.com>,
        <yi.l.liu@intel.com>, <baolu.lu@linux.intel.com>,
        <will@kernel.org>, <joro@8bytes.org>,
        <shameerali.kolothum.thodi@huawei.com>, <jean-philippe@linaro.org>,
        <kvm@vger.kernel.org>, <iommu@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC v2 3/3] vfio: Add dev_data_len/uptr in struct vfio_device_bind_iommufd
Date:   Thu, 20 Apr 2023 00:47:47 -0700
Message-ID: <8232c5ea073d793d277f45036a6e61e0849b4202.1681976394.git.nicolinc@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681976394.git.nicolinc@nvidia.com>
References: <cover.1681976394.git.nicolinc@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT022:EE_|MW4PR12MB7166:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bdcb85b-4a6b-438e-3f31-08db4173a25e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdJFSWdmjtZWRXhvKqQpXGrqN3rXQ4di2zuNB+hsd+Ej4WHJuKymMckpBC8j5NeYKBFxJeKFAfHieLBFxrEpPSL7PmddvFkWi/GqlAnnAtCTBEIg6ruYhftZhPijgDjHHMNYTur1vqPeiwlsqULC1/ExAISPDFrqF0lwHY1NnDio1HRvWT5zmaU+mQ5beJP62GL4Xc67u13dl0scY5/JTAkGnfjFuuETVugBlKKp4yfyA2ak1vJ11SSkdTMt84B7751tEeiC+FQpv+LOjr1siIC4oYyHwl0xWzXZCtrh2j/EbU900uBBkAPh/6Ob5PmHmnvBTp+FTyu7a6g5lhomdojheBcg1mzWyUUKpQJruSMpkwhyrEIoAoHDx/sdC7TOkFJdGHKVIUE9xHDOZy0acMKEyIx+TExyAEFkdAf87bZdMt3FAPlXWJ8N4GEUTg01Hw0p4c2unYm5861TwDND7TfRtsOPNAM8dG8KN8H1g3LNZYSU/RR9Q8pstfz3Ya5JmoxJyrni35fZlwjXQD8tK6kIOcEo6D6cjgIryJnmqN0i7D7iWFr23pj1zGsCMnX6dc5heB9+EFkgF/aLyTA/GaQEtK3DEVgjCXXIc4ysO4drfZYslB4WEepoGlPV8TMCusLf9nGb0mVQH973Ka8OUyVbdYM/OkpklPFtOZWSlOwfw029S3WPl2bngKKGX3y08FBujzTK+I+50NmhpDfIsxgYjxdhlautexde8nST+tEGt1qY/8jPuHM/h8pzIvaDiXyXnlDjdz0bJID3+zbYWNuBlfq8oHg0ZfjdO09XuPI=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(396003)(376002)(346002)(451199021)(46966006)(36840700001)(40470700004)(36756003)(186003)(26005)(34020700004)(36860700001)(40460700003)(478600001)(82310400005)(6666004)(40480700001)(110136005)(4326008)(54906003)(8676002)(86362001)(316002)(7696005)(7636003)(70586007)(8936002)(70206006)(356005)(82740400003)(7416002)(41300700001)(2616005)(47076005)(2906002)(83380400001)(426003)(336012)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2023 07:48:30.2781
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bdcb85b-4a6b-438e-3f31-08db4173a25e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7166
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows user space to pass in an iommu specific device data with the
VFIO_DEVICE_BIND_IOMMUFD ioctl. The data is not mandatory. But it must be
provided if a non-zero data_len is passed along.

Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
---
 drivers/vfio/device_cdev.c | 19 +++++++++++++++++--
 drivers/vfio/iommufd.c     | 13 +++++++++++++
 include/linux/vfio.h       |  2 ++
 include/uapi/linux/vfio.h  | 13 +++++++++++++
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index b5824179cd48..70241d9c0fa9 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -104,9 +104,10 @@ static struct iommufd_ctx *vfio_get_iommufd_from_fd(int fd)
 long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 				    struct vfio_device_bind_iommufd __user *arg)
 {
+	uint32_t mask = VFIO_DEVICE_BIND_IOMMUFD_FLAG_DATA;
 	struct vfio_device *device = df->device;
 	struct vfio_device_bind_iommufd bind;
-	unsigned long minsz;
+	unsigned long minsz, datasz;
 	bool is_noiommu;
 	int ret;
 
@@ -117,9 +118,23 @@ long vfio_device_ioctl_bind_iommufd(struct vfio_device_file *df,
 	if (copy_from_user(&bind, arg, minsz))
 		return -EFAULT;
 
-	if (bind.argsz < minsz || bind.flags)
+	if (bind.argsz < minsz || bind.flags & ~mask)
 		return -EINVAL;
 
+	if (bind.flags & VFIO_DEVICE_BIND_IOMMUFD_FLAG_DATA) {
+		datasz = offsetofend(struct vfio_device_bind_iommufd,
+				     dev_data_len);
+		if (bind.argsz < datasz)
+			return -EINVAL;
+		if (copy_from_user((void *)&bind + minsz,
+				   (void __user *)arg + minsz, datasz - minsz))
+			return -EFAULT;
+		if (!bind.dev_data_uptr ^ !bind.dev_data_len)
+			return -EINVAL;
+		device->user_data = u64_to_user_ptr(bind.dev_data_uptr);
+		device->user_data_len = bind.dev_data_len;
+	}
+
 	/* BIND_IOMMUFD only allowed for cdev fds */
 	if (df->group)
 		return -EINVAL;
diff --git a/drivers/vfio/iommufd.c b/drivers/vfio/iommufd.c
index 16d6aac06180..0b985ccffcbe 100644
--- a/drivers/vfio/iommufd.c
+++ b/drivers/vfio/iommufd.c
@@ -91,6 +91,16 @@ int vfio_iommufd_physical_bind(struct vfio_device *vdev,
 	idev = iommufd_device_bind(ictx, vdev->dev, out_device_id);
 	if (IS_ERR(idev))
 		return PTR_ERR(idev);
+
+	if (vdev->user_data) {
+		int rc = iommufd_device_set_data(idev, vdev->user_data,
+						 vdev->user_data_len);
+		if (rc) {
+			iommufd_device_unbind(idev);
+			return rc;
+		}
+	}
+
 	vdev->iommufd_device = idev;
 	return 0;
 }
@@ -104,8 +114,11 @@ void vfio_iommufd_physical_unbind(struct vfio_device *vdev)
 		iommufd_device_detach(vdev->iommufd_device);
 		vdev->iommufd_attached = false;
 	}
+	iommufd_device_unset_data(vdev->iommufd_device);
 	iommufd_device_unbind(vdev->iommufd_device);
 	vdev->iommufd_device = NULL;
+	vdev->user_data = NULL;
+	vdev->user_data_len = 0;
 }
 EXPORT_SYMBOL_GPL(vfio_iommufd_physical_unbind);
 
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 46b313f8bfaf..e4bb63801472 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -68,6 +68,8 @@ struct vfio_device {
 #if IS_ENABLED(CONFIG_IOMMUFD)
 	struct iommufd_device *iommufd_device;
 	bool iommufd_attached;
+	void *user_data;
+	u32 user_data_len;
 #endif
 	bool noiommu;
 };
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 17c5a1dadd08..9cec823c2829 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -212,15 +212,28 @@ struct vfio_group_status {
  *		as long as the input @iommufd is valid. Otherwise, it is
  *		meaningless. devid is a handle for this device and can be
  *		used in IOMMUFD commands.
+ * @dev_data_uptr: User pointer of the device user data.
+ * @dev_data_len: Length of the device user data.
+ *
+ * A device user data is an iommu specific structure that must be defined in
+ * the include/uapi/linux/iommufd.h file. On some platform enabling the iommu
+ * nested translation configuration, a device behind the iommu, while working
+ * in a guest VM, needs to provide the host kernel a certain virtual ID in the
+ * guest VM. For example, ARM SMMUv3 requires a virtual Stream ID to sanity a
+ * cache invalidation command from the user space. User space wanting to pass a
+ * user data must set VFIO_DEVICE_BIND_IOMMUFD_FLAG_DATA flag.
  *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_bind_iommufd {
 	__u32		argsz;
 	__u32		flags;
+#define VFIO_DEVICE_BIND_IOMMUFD_FLAG_DATA		(1 << 0)
 	__s32		iommufd;
 #define VFIO_NOIOMMU_FD	(-1)
 	__u32		out_devid;
+	__aligned_u64	dev_data_uptr;
+	__u32		dev_data_len;
 };
 
 #define VFIO_DEVICE_BIND_IOMMUFD	_IO(VFIO_TYPE, VFIO_BASE + 19)
-- 
2.40.0

