Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFC8D51AD9C
	for <lists+kvm@lfdr.de>; Wed,  4 May 2022 21:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377485AbiEDTSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 May 2022 15:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344363AbiEDTSa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 May 2022 15:18:30 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2061.outbound.protection.outlook.com [40.107.212.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343F2488B4
        for <kvm@vger.kernel.org>; Wed,  4 May 2022 12:14:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bWuoTvb0qy4TBKy0jzAdIEE3ufDywFkAeJubWjDxLXygomXSuivuNRbI2g37hrkJykSDBCEzEoCcwe/80vFrX9k1whnfYgWFJXlEgR51UCRlRFLfgILqQ2CKcQnKc3qqZwd7NgVmHaZzh3HYn40lWi3/8fc6KhGbZybVpOWlpq1EEzovFFcsjsKmLDgi+7il6T51ShbbMroc5E0Nl+h3V5Jx37+WuHoc9WYJ61mI2VKEPVH07QKxWMa0E27k6siDt4z5luXBOM+fFMsDNKzcaVdoWP/0v1eyUgR8s1W46chQCvVQZXObFS6fAWZ41v76qdwENJimLIWSBeqzglsGBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=50x9oVbVyIeu1PAHm5jWPQDk2yo/u3AzRXF12mv9TXs=;
 b=lg+SawbXVpesXQ3mZcLmdmNPPKie0SUkMJm4cqql361AP9HfR33M4HA2c/PUSzE6Xr3gId6WyEfPa0HfQWVhv5WGU7yiwXZoNwG8OQ95a12ZWW6tfvbLY6ZjEfpV23qil061LKc002vgetAZkmwcfyHQR1k/7rNjEf4NJva3c6wscEObwecKyJIWrn6HqzjKEkVFb8EP/e8jdiuqXsL+pCkmMiRMfurRiMwN+zquJUOLQU+NyC7kt19jv9WqMEUXX4oScLb+bvu5pbJXdXhh6BUtKfKqJQLB109vJK8+b55zwAS9PnT7ZLocuftP5+ONmQ/lUXiQ469GvHPGfeU4Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=50x9oVbVyIeu1PAHm5jWPQDk2yo/u3AzRXF12mv9TXs=;
 b=FWkAN+98u5DS6804Lgk7WEMWbMQ91HECeweCNoE6Y9ERvNWgJRQFu/Ya7pdJXj3k81az8HgvjKOMX8PvCvx259T/0KlL7HYfzqj/0rFIO2hvjijwR0dMeai2BAwHIBQwtAojzy7bbHOFrr+twFqPXb5caSiKlNJnexLr64CtB5Y8uaAzXfpa1bj7QPYqQPe2cTfaJ2utVPQollMtWvfxCQPZqmnzJqI7vwtthQhZoOdmqlzFzhjRd9cWH1zog55FDcs6ZrS5CmYO1wW8KNf0HRgZHAu1wYIaWUsGr9wMRXHV2c5i+V+o8XzRCXHCuaERW+JxVpqDiIJD7Qn0V4buaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM5PR12MB2341.namprd12.prod.outlook.com (2603:10b6:4:b5::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.15; Wed, 4 May
 2022 19:14:50 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.025; Wed, 4 May 2022
 19:14:50 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Eric Auger <eric.auger@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Kevin Tian <kevin.tian@intel.com>, Yi Liu <yi.l.liu@intel.com>
Subject: [PATCH v3 8/8] vfio/pci: Use the struct file as the handle not the vfio_group
Date:   Wed,  4 May 2022 16:14:46 -0300
Message-Id: <8-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
In-Reply-To: <0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:208:23b::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e071d7e-e239-45c1-c743-08da2e025b24
X-MS-TrafficTypeDiagnostic: DM5PR12MB2341:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB23414431049E394DA38267B1C2C39@DM5PR12MB2341.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wl5iT870hq78AJDZhMqa29UQUIJ2HLpC0aelAGpvHLLI5+ig/vKLUjH/PAUIHHeOysjlCeMFhRSf79/Dw88Wpyj666KVDACMNvGcLQV/ax0LpC9MF0kAnW6NPR3IcF8z1RoUC/+sHX4BoNc7u9wbrOPCeIphbpBrZKqAss3HHHKbm/OGdAQQ4pATgIGI3eKPuhHUrHq/irKJckrZGPKDg1PQBYCydMlGK6n8rdBvcfHbOnLCvIzAxEeVxcUFBHcgy8+fwdHgE1YzWkdto1MEq7ZJK9xINYyJUf/cSrpRtdXgWX7+4avhSZ9veLl/uwgmjyjRcUk127Pu2GVd9MQnVuG2RQZF6lSVXWWJU0K1SaXMzBa6L0iNhfSE0yGDrvsWEQ+AzVmzDkjveHNJOIt3UnuGBJ650nOGCmpkzKXONLEFLXMuY93eHRAjqumIkfrj1pAWJaf59yKpVXdVf4LQPaeRPJir/ofBsaB35NS1DfULpczYsPEDbvw7cTAwf3pELFRWtfAh4+gqJGUmkgZ/jKA5Nxc5aa8BBzMqE8PirE6AuIw7O/FTgL8j/qHjCU14s00BroBL/sHY/BfmCF6eNsz6p+ZP7gY52CRohKZCaiD6cFrKJuDWY3VY+1FLkw1iyu5tWE3YbCyEiOTdoCdBX6t5shsIrnbc2+yXdaLA6U+bw8qIasR0vaaYl/QZQiTXK8ckZsQd/e2zWXEjJmoX3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(186003)(2616005)(66946007)(8676002)(6666004)(66476007)(6506007)(38100700002)(6512007)(4326008)(26005)(66556008)(6486002)(54906003)(316002)(83380400001)(110136005)(2906002)(86362001)(5660300002)(36756003)(8936002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1MpAbs78MMlo/coCsT53ULlBNzMI6+EJFAPHCQYFk9bM9+l4/ZhW3bB1EED5?=
 =?us-ascii?Q?A1KxyxlNvPatdGY8n9vy425dntNXkoD044oUr7Dnn6wKBejqcCHFZmkxT2bp?=
 =?us-ascii?Q?xrE9qWcE9fEbd667ELBrhg++IJGFFmj87MpodkJz1gfIbsJAK1L/MMgAaIOA?=
 =?us-ascii?Q?nxA43inIgWFbYLWvu1TjMp8EphkPzT25m63S7y5mKAHL+CZxoGknKC5uuy/I?=
 =?us-ascii?Q?UgZCmmqRuL43CogDJH+docLHW5pwUkp2y/7Z3o/sKwWJ43vcy/dQsrALjA73?=
 =?us-ascii?Q?f38l4aY/1jjDHNtNbmY1C/mHPnlWh/hsg+ssbGmPieh0iQYfI4ZaP1oY/6OY?=
 =?us-ascii?Q?eX3WhFrs7rXck0ISaLPw2N9+rubphR5qoqURS/vU0jrOH34unW8FmpZwcfE8?=
 =?us-ascii?Q?AqXJNFgN2jTpYVH0o2S3TBHdLPXdtJKjtURgBinfzGOFMCAyp8p06RGEwCoB?=
 =?us-ascii?Q?QwI6qPeBjAQoHfJzadHIum72s3dHPxUp/CCAfgmLNCocxYrDJk9p+VUVBytK?=
 =?us-ascii?Q?9fNStuL8ZBPSJX8p9RADfcpfdPv2OPN7di/CGxndkweg/PFJKMAzQZDhkupc?=
 =?us-ascii?Q?XqOj4VTA+8P9OsqINHzIbv0M57+7s5GrX+rzs5Buo9+ww9HhY9Ves5AP8/7r?=
 =?us-ascii?Q?5KBv10z9txmX6vKqk9TAk45zetCjvujlAnFS+MoCZ8lm1S4CJdk0Rohb2tNc?=
 =?us-ascii?Q?CPm5QoDUVFC1VDfa61pXdC47Ce52WvNZt2kmkLClqA0Pt8/H3BS43mxhEly9?=
 =?us-ascii?Q?dUUK33VCaSjeAv3XXuUflxEPsAVLqEXuTuoBUFFbIo3wQC/VOvOzs0+uDE8d?=
 =?us-ascii?Q?HmXgeRLYlEszKEzGMmlY2bgGjWY3MH3dKBEA7p54UiOP0jxUe3MdAq4Ge0IC?=
 =?us-ascii?Q?LIqB7oS+cz/Wcr/hMXfbCSIw+au57cBCgr/ZEFWU2eSFS23VH9CIMBpIt8Cy?=
 =?us-ascii?Q?9qrLUUoDkxp2qrdQc2U7iCym4MYThRBPLXC5UoTGbyj0K+qyGfO08s2vjZF8?=
 =?us-ascii?Q?5WVIqktL1IycuQPhzpj3wZjpCcMFo0PTtvsIvbtesc4kYf8nCd5QNwTH8/UI?=
 =?us-ascii?Q?i+exoJOF+hp+CAhOaUvgJJOHE2v0XoqJ6K4QIfZxc0GMpKWdM5gabBG2Rm/B?=
 =?us-ascii?Q?dnLWvtX6D6H0HuKR+xTFBG/cMN1qdn5yPm2eZUWUobto5qskfJZ0nwSgu4mT?=
 =?us-ascii?Q?g5YHdFBkGA+tKEvhK9LsKIJI4eT6ZCwzImBln34Ox2I3EcFkUW8DIWxsjViE?=
 =?us-ascii?Q?fnmWyh8Y5IK+MU1VIFXJdSxvYoGFdZJ3wZGENm0UcOlOS137RohrsF4sXgW2?=
 =?us-ascii?Q?eS65rbNIwk4m4qX4Ob2U+qWyOzRcJd20DnQHniV8yy/cjx4I2wP1h5yJ3Zs5?=
 =?us-ascii?Q?Dcq/1OIpYJ24Wc22iv6i8oZbZ0se3jCAGnGrR37XdCKRyv9u4szsgz3T/Zow?=
 =?us-ascii?Q?nOqHq2a9KqhPw1LOUP1wMuBrStvehlDItf+fabS1EUYBNEocGwVTkc7UqMzQ?=
 =?us-ascii?Q?jMAgpEF/OA/0DXPYA0b7RqieuOOLlwk0sLf0naLzm6JhFpDgkJQUlQZ4TKEJ?=
 =?us-ascii?Q?xepowPQnRAffJJIfxKDNm9DepEbI1fhSxGREdXH4RFKh+hIokhCY/TKCcTM7?=
 =?us-ascii?Q?Y/lALbceYEYhzTnGx5EFd/Ms0t/WH1z+jBzduHx53cHSqkoJ9e7E5XL+vWoe?=
 =?us-ascii?Q?8l3QlwYeemTyhCIOpXnwCPRY2ico5EiMhPcmmtsCl5Z/Yi+9iYmrIttIdZui?=
 =?us-ascii?Q?yDhiNK+4Uw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e071d7e-e239-45c1-c743-08da2e025b24
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2022 19:14:48.1857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yt7hUdiif3axiM6aeOP5sNZ6XZzqPEcEqR+FXeLHadXMQh02Y13rrZbN57v1mEQw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2341
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VFIO PCI does a security check as part of hot reset to prove that the user
has permission to manipulate all the devices that will be impacted by the
reset.

Use a new API vfio_file_has_dev() to perform this security check against
the struct file directly and remove the vfio_group from VFIO PCI.

Since VFIO PCI was the last user of vfio_group_get_external_user() and
vfio_group_put_external_user() remove it as well.

Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 42 +++++++++----------
 drivers/vfio/vfio.c              | 70 ++++++++------------------------
 include/linux/vfio.h             |  3 +-
 3 files changed, 40 insertions(+), 75 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 9778d713f546d2..c13432a917962d 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -556,7 +556,7 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 
 struct vfio_pci_group_info {
 	int count;
-	struct vfio_group **groups;
+	struct file **files;
 };
 
 static bool vfio_pci_dev_below_slot(struct pci_dev *pdev, struct pci_slot *slot)
@@ -1018,10 +1018,10 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 	} else if (cmd == VFIO_DEVICE_PCI_HOT_RESET) {
 		struct vfio_pci_hot_reset hdr;
 		int32_t *group_fds;
-		struct vfio_group **groups;
+		struct file **files;
 		struct vfio_pci_group_info info;
 		bool slot = false;
-		int group_idx, count = 0, ret = 0;
+		int file_idx, count = 0, ret = 0;
 
 		minsz = offsetofend(struct vfio_pci_hot_reset, count);
 
@@ -1054,17 +1054,17 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			return -EINVAL;
 
 		group_fds = kcalloc(hdr.count, sizeof(*group_fds), GFP_KERNEL);
-		groups = kcalloc(hdr.count, sizeof(*groups), GFP_KERNEL);
-		if (!group_fds || !groups) {
+		files = kcalloc(hdr.count, sizeof(*files), GFP_KERNEL);
+		if (!group_fds || !files) {
 			kfree(group_fds);
-			kfree(groups);
+			kfree(files);
 			return -ENOMEM;
 		}
 
 		if (copy_from_user(group_fds, (void __user *)(arg + minsz),
 				   hdr.count * sizeof(*group_fds))) {
 			kfree(group_fds);
-			kfree(groups);
+			kfree(files);
 			return -EFAULT;
 		}
 
@@ -1073,22 +1073,22 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 		 * user interface and store the group and iommu ID.  This
 		 * ensures the group is held across the reset.
 		 */
-		for (group_idx = 0; group_idx < hdr.count; group_idx++) {
-			struct vfio_group *group;
-			struct fd f = fdget(group_fds[group_idx]);
-			if (!f.file) {
+		for (file_idx = 0; file_idx < hdr.count; file_idx++) {
+			struct file *file = fget(group_fds[file_idx]);
+
+			if (!file) {
 				ret = -EBADF;
 				break;
 			}
 
-			group = vfio_group_get_external_user(f.file);
-			fdput(f);
-			if (IS_ERR(group)) {
-				ret = PTR_ERR(group);
+			/* Ensure the FD is a vfio group FD.*/
+			if (!vfio_file_iommu_group(file)) {
+				fput(file);
+				ret = -EINVAL;
 				break;
 			}
 
-			groups[group_idx] = group;
+			files[file_idx] = file;
 		}
 
 		kfree(group_fds);
@@ -1098,15 +1098,15 @@ long vfio_pci_core_ioctl(struct vfio_device *core_vdev, unsigned int cmd,
 			goto hot_reset_release;
 
 		info.count = hdr.count;
-		info.groups = groups;
+		info.files = files;
 
 		ret = vfio_pci_dev_set_hot_reset(vdev->vdev.dev_set, &info);
 
 hot_reset_release:
-		for (group_idx--; group_idx >= 0; group_idx--)
-			vfio_group_put_external_user(groups[group_idx]);
+		for (file_idx--; file_idx >= 0; file_idx--)
+			fput(files[file_idx]);
 
-		kfree(groups);
+		kfree(files);
 		return ret;
 	} else if (cmd == VFIO_DEVICE_IOEVENTFD) {
 		struct vfio_device_ioeventfd ioeventfd;
@@ -1962,7 +1962,7 @@ static bool vfio_dev_in_groups(struct vfio_pci_core_device *vdev,
 	unsigned int i;
 
 	for (i = 0; i < groups->count; i++)
-		if (groups->groups[i] == vdev->vdev.group)
+		if (vfio_file_has_dev(groups->files[i], &vdev->vdev))
 			return true;
 	return false;
 }
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index efb817c211fa89..035220a20b4d20 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1653,58 +1653,6 @@ static const struct file_operations vfio_device_fops = {
 	.mmap		= vfio_device_fops_mmap,
 };
 
-/*
- * External user API, exported by symbols to be linked dynamically.
- *
- * The protocol includes:
- *  1. do normal VFIO init operation:
- *	- opening a new container;
- *	- attaching group(s) to it;
- *	- setting an IOMMU driver for a container.
- * When IOMMU is set for a container, all groups in it are
- * considered ready to use by an external user.
- *
- * 2. User space passes a group fd to an external user.
- * The external user calls vfio_group_get_external_user()
- * to verify that:
- *	- the group is initialized;
- *	- IOMMU is set for it.
- * If both checks passed, vfio_group_get_external_user()
- * increments the container user counter to prevent
- * the VFIO group from disposal before KVM exits.
- *
- * 3. When the external KVM finishes, it calls
- * vfio_group_put_external_user() to release the VFIO group.
- * This call decrements the container user counter.
- */
-struct vfio_group *vfio_group_get_external_user(struct file *filep)
-{
-	struct vfio_group *group = filep->private_data;
-	int ret;
-
-	if (filep->f_op != &vfio_group_fops)
-		return ERR_PTR(-EINVAL);
-
-	ret = vfio_group_add_container_user(group);
-	if (ret)
-		return ERR_PTR(ret);
-
-	/*
-	 * Since the caller holds the fget on the file group->users must be >= 1
-	 */
-	vfio_group_get(group);
-
-	return group;
-}
-EXPORT_SYMBOL_GPL(vfio_group_get_external_user);
-
-void vfio_group_put_external_user(struct vfio_group *group)
-{
-	vfio_group_try_dissolve_container(group);
-	vfio_group_put(group);
-}
-EXPORT_SYMBOL_GPL(vfio_group_put_external_user);
-
 /**
  * vfio_file_iommu_group - Return the struct iommu_group for the vfio group file
  * @file: VFIO group file
@@ -1772,6 +1720,24 @@ void vfio_file_set_kvm(struct file *file, struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(vfio_file_set_kvm);
 
+/**
+ * vfio_file_has_dev - True if the VFIO file is a handle for device
+ * @file: VFIO file to check
+ * @device: Device that must be part of the file
+ *
+ * Returns true if given file has permission to manipulate the given device.
+ */
+bool vfio_file_has_dev(struct file *file, struct vfio_device *device)
+{
+	struct vfio_group *group = file->private_data;
+
+	if (file->f_op != &vfio_group_fops)
+		return false;
+
+	return group == device->group;
+}
+EXPORT_SYMBOL_GPL(vfio_file_has_dev);
+
 /*
  * Sub-module support
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index b32641e350157a..792b66e17f5069 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -138,11 +138,10 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 /*
  * External user API
  */
-extern struct vfio_group *vfio_group_get_external_user(struct file *filep);
-extern void vfio_group_put_external_user(struct vfio_group *group);
 extern struct iommu_group *vfio_file_iommu_group(struct file *file);
 extern bool vfio_file_enforced_coherent(struct file *file);
 extern void vfio_file_set_kvm(struct file *file, struct kvm *kvm);
+extern bool vfio_file_has_dev(struct file *file, struct vfio_device *device);
 
 #define VFIO_PIN_PAGES_MAX_ENTRIES	(PAGE_SIZE/sizeof(unsigned long))
 
-- 
2.36.0

