Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF9C72EAD2
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 20:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbjFMSXM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 14:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236810AbjFMSXL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 14:23:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2049.outbound.protection.outlook.com [40.107.243.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AE910DE;
        Tue, 13 Jun 2023 11:23:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=igLfBGYzRjLAKGDMOYSE2BSK19TG3W4bkzKeI2Q0O3bms54G/sH2we7pY9OGWFI2gNYMPf2/fwMUI3sZILaYWqh4nQaQ0dnadZXQX+vHblybX6x1uIw0Xl169Hetq78sCJgtsV228WU9JdUnhWIDMl61Xl6jaI/JPZwnq8elFSa9zo2omh9HV4GnH/JA3grsp+/Ern1aGp9ByBqGu0yXUU559mPXUQ8HRhW7sGhLd9+E5YwfvOZWbdvz1/faRiX+lvl3TsrwVRAECoq9WIMumFvS3uc5d+eatOBKNXEN0szhPF95jaQatmDcCDljzoeVCvI6vTguS5FZdLOJohkLUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sk9QL3/SejptdUGxkdnPuUgJb+WlUs5J1SEq5vZVcQY=;
 b=Zmu53sid6MXRMhNhlWWRQskbXcRP+F94/MbfxCIKev4/s2LUBwVmaEJeV7wTaV+iN3K5YFI9y98F1XMaNrgVrrf1g0SEBGWKPuQ5nZHr+Uo91BvDO6RUkUkMbS6bd7dRueTTxoSkylfTBa7plYEKV4WsQgtcbRDkLginS9tKYvyKlRmXXqBU5CeVNwgvwmB5XnDmjt6L1kkEeIdM5Xv4meA3ckF3kVLaihiXNCQLee2Jglezdjd2MGUS3WAnIydbcBjEkBlpfK1Hd+k8iLLCPGcchbhhaXEE6q82gQ/uOvQkyfMxrXCsEr0HQwvPdc1Hh/obgxywZW8Gb1D5nypZZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sk9QL3/SejptdUGxkdnPuUgJb+WlUs5J1SEq5vZVcQY=;
 b=N1kLQBPavc88eOFxLsOMxoh4bY7sUDds7GpjEtfwVhpSkqsg+9sDQGOsmDGHPmsxrqvFFx9Azo/E8kS+TOpMzAji2UE+qLWxEmNIB5fhi24VAQqz2YbQg+0U0bB6oJWZ7ivZ29azWdKX73AdA2HRP9XpB6STXr7w7vt7cPSarzdfyAFxQTAG4vTAPoq27H+gtMLc3Fa6a8HnyrBhbQHj4jS50K3AkfB3XHSPjZGCMJoAkHBs6OmfG8TRgFrJSi0T1XMn6YxIRHR2fM9SwpTGpa70fyzLxNjYgaMFrk6nZLrqB4myrn/J5Akb0i7wkZ0RELS7A3StLyjwKdadiC4G+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB8055.namprd12.prod.outlook.com (2603:10b6:510:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.39; Tue, 13 Jun
 2023 18:23:05 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 18:23:05 +0000
Date:   Tue, 13 Jun 2023 15:23:02 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <ZIi0Bizk9qr1SgJ/@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-9-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121515.79374-9-yi.l.liu@intel.com>
X-ClientProxiedBy: CH0PR03CA0300.namprd03.prod.outlook.com
 (2603:10b6:610:e6::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB8055:EE_
X-MS-Office365-Filtering-Correlation-Id: 16883321-94a4-43b3-05c8-08db6c3b3a9c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QAkrqkWBtXw6mq2v9tgIXeV17D/UILW6uanmIV0AYLn0jdw1ZPoXZTIO3girg+Ru18z1arNhw9S/m46zul4RwCrQWoeO+WfAwJDO8QTi8UCM0mKUIcbAWsrx3r3htekV31XGKquhc0txFJV26uoapC38z/KZoFoLKzIaLbI3l9l0FerQRxIE9KVAGHcAJCUJVEHf7Zc6v1PQ1ceB/IlOeCYd9zHT+fYIAuGPGqkDUgIXn3iUD/Q/mKMOh9QYZU53A13mNbOXf+nkmAeS64oi+kZs1/XxGxhDYQl8aS3M900nIOmvXD04ulNvu3mI8G/hznIoXvGTEz64lHwwtxARWpRIK/plmw+tJH55NBa0oIMrdWeyGidMSk47sTwFdUSdvhwDrwu1lBNPvEeR9gJIHZgJvstoUiFg1QQjfWNHI6OJzkWANy93jT7g5p9hO6hnq7VlvXHKShQd+soR5ltHZP4ZJluq4s2b+G173j04mg9DTmZEjaGqW6ARTMfPlPKJfNhNaBcHA2xYqV+uM01Vui2i3VizdeZvPgVxXdxW6Qkt/Qy4RyTwioh6dqkvahKE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(451199021)(36756003)(2616005)(2906002)(86362001)(7416002)(6666004)(83380400001)(5660300002)(186003)(26005)(6512007)(6506007)(6486002)(478600001)(8676002)(66946007)(66556008)(316002)(41300700001)(66476007)(4326008)(6916009)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TbU49f1zFMSu1tu8MEXL69HQIjEHXCsIxOSVGtHbrqDBvkxkIJnLR7lpnZRf?=
 =?us-ascii?Q?4G1ekSs3REcLPRYp2bYbqI8XQzts9a/GsL5DANLD24xcpi8ELn1cIRai/qTv?=
 =?us-ascii?Q?49+fcXQYWo8RLr5jF//N1kiBnOPiXFM1QAyBRgOVKY3+iIqIsRwnB65lfo/v?=
 =?us-ascii?Q?Q00kKnzVHuR0FGk74zS3id+eV8aBp85aAsSWC3aXfPYLyQkfqZKs5aVKwUTM?=
 =?us-ascii?Q?dSiF7aZR4qTy98TgZ08evp8Aa/Es8YrREyHEPrWFvpUDzRs3iwxM2h0aYFVE?=
 =?us-ascii?Q?Te1NBw9kgrIyNUTgzD1XwUxtBD2J7Z/SCD4g4dh/e+yz6jXRkpDHVEvbgcQ8?=
 =?us-ascii?Q?qzq8teXenfFfZ0+0xQCl1fpuATcKztX62PWOSTTh6XLKD21fVTOFaA3JMMWo?=
 =?us-ascii?Q?6+jdah+Cag1THe63t5dFVUTFfJJAQjCOrYaQDNV2Sk+tS834bySjrKHBfRKy?=
 =?us-ascii?Q?Lb3SnGubpsMDoCv5iozoctFDf/HOvxYAxBA0PBJOiW1di8ayiqlfoFt7pqgp?=
 =?us-ascii?Q?H3wJaO3ZHg1FFM7WYPq9eZE4sd0ZT0U/Zb+odHOEub1NIwKV4cgRTc4yom7t?=
 =?us-ascii?Q?j5cZ9oaACox4YJ6K8jV9xpB0MDsmj8pI3zZpF/r32NBPU59Q0RcvLArLniz3?=
 =?us-ascii?Q?f76WrIxoTWohkSV4Kd1DQ0Mux576CRaj1jNORFf/nE9YmHEpZtOVrvXX/qQx?=
 =?us-ascii?Q?wqr9nsgqKNqV9IwKEVLcvcp/EoL/0y1TwexEqRR6ZzSG66NINjeuOQZnEFhZ?=
 =?us-ascii?Q?k8mnqZDNT5oBkYQMSun5pdD7LWIqWbWAMvLU3IHLLemswFOAvTmGuht/JmIs?=
 =?us-ascii?Q?AQzE9FuCW0YIYvgzqkYVaKqPc7Hof9AG6NUcUbBI03dTR7XYuqhniTbWLbq4?=
 =?us-ascii?Q?FQsnqBnmsyKa52CkF85xGr/z3Xs21vCTubD+9ggmhrINsxHkjsYvB7tfq9wb?=
 =?us-ascii?Q?UB7CtBqFXokTbfbxZzPwEL/UuY71ZFWPtUVceToBBObT1wUEmNC5kkTbMPWW?=
 =?us-ascii?Q?5jM2wRemI8B7GNE/s4p3YmXoWmuaJ76QGdDtUumtoxFmsKfQk4ybA04gAhn/?=
 =?us-ascii?Q?tr3zZVqWeJ7Yr9QEZi8tHGTmVZd617erVQ3Fg22UqEPT8UF/Lah3UvIGfkqp?=
 =?us-ascii?Q?VOQjNxchzxk7wnQGIQw4Bg4Yi53TfvofQZEVMIUgOnUFuHt8NoiHzEB5C6zM?=
 =?us-ascii?Q?X306cr56YQUzSs2juH/JMFkP6/UD7glBA99lc+KzupqMUkDychabtVDrnQ/s?=
 =?us-ascii?Q?gIpFIv9UhC5H8kdtKJDWSenm0KrtWrzJ0QBjRariipuVsFUBsHEKtwOmHtuK?=
 =?us-ascii?Q?VPptcERwL9wleQo6jQb2gFV3UPNvfADf1n7JkWjd+ZDezgjw2OYaIZO9pp8n?=
 =?us-ascii?Q?nKvQvCboQFuV9juBdTo9GqchV2B5MWM/GsVZ9ymi4mcqZN9EhIyvxVhec1Iy?=
 =?us-ascii?Q?cFmBNwFUImBECh9geup6iegeDqSnA8W+RVAhCrddADPKEHr+igGde9XTJF0N?=
 =?us-ascii?Q?Ws4w62J7X0yuHb0OkNTvdF4sNDB/rX6Qe5ZQX6DXkm6glvIoNlcEDjCGrpmr?=
 =?us-ascii?Q?2Wg00/lCgKk/heg2ph5CPFWTAC+kf5fAKqy+YSuk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16883321-94a4-43b3-05c8-08db6c3b3a9c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 18:23:05.2120
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RtsqVKGetko5z/Xl9E6LwKFdnirdnaXXwxVfbA4s4V+f0HWpICcR+H8VtZjWt3k2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8055
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:15:14AM -0700, Yi Liu wrote:
> This allows VFIO_DEVICE_GET_PCI_HOT_RESET_INFO ioctl use the iommufd_ctx
> of the cdev device to check the ownership of the other affected devices.
> 
> When VFIO_DEVICE_GET_PCI_HOT_RESET_INFO is called on an IOMMUFD managed
> device, the new flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID is reported to indicate
> the values returned are IOMMUFD devids rather than group IDs as used when
> accessing vfio devices through the conventional vfio group interface.
> Additionally the flag VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED will be reported
> in this mode if all of the devices affected by the hot-reset are owned by
> either virtue of being directly bound to the same iommufd context as the
> calling device, or implicitly owned via a shared IOMMU group.
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Suggested-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/iommufd.c           | 49 +++++++++++++++++++++++++++++++
>  drivers/vfio/pci/vfio_pci_core.c | 47 +++++++++++++++++++++++++-----
>  include/linux/vfio.h             | 16 ++++++++++
>  include/uapi/linux/vfio.h        | 50 +++++++++++++++++++++++++++++++-
>  4 files changed, 154 insertions(+), 8 deletions(-)

This could use some more fiddling, like we could copy each
vfio_pci_dependent_device to user memory inside the loop instead of
allocating an array.

Add another patch with something like this in it:

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b0eadafcbcf502..516e0fda74bec9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -775,19 +775,23 @@ static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
 }
 
 struct vfio_pci_fill_info {
-	int max;
-	int cur;
-	struct vfio_pci_dependent_device *devices;
+	struct vfio_pci_dependent_device __user *devices;
+	struct vfio_pci_dependent_device __user *devices_end;
 	struct vfio_device *vdev;
 	u32 flags;
 };
 
 static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 {
+	struct vfio_pci_dependent_device info = {
+		.segment = pci_domain_nr(pdev->bus),
+		.bus = pdev->bus->number,
+		.devfn = pdev->devfn,
+	};
 	struct vfio_pci_fill_info *fill = data;
 
-	if (fill->cur == fill->max)
-		return -EAGAIN; /* Something changed, try again */
+	if (fill->devices_end >= fill->devices)
+		return -ENOSPC;
 
 	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
 		struct iommufd_ctx *iommufd = vfio_iommufd_device_ictx(fill->vdev);
@@ -800,12 +804,12 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 		 */
 		vdev = vfio_find_device_in_devset(dev_set, &pdev->dev);
 		if (!vdev)
-			fill->devices[fill->cur].devid = VFIO_PCI_DEVID_NOT_OWNED;
+			info.devid = VFIO_PCI_DEVID_NOT_OWNED;
 		else
-			fill->devices[fill->cur].devid =
-				vfio_iommufd_device_hot_reset_devid(vdev, iommufd);
+			info.devid = vfio_iommufd_device_hot_reset_devid(
+				vdev, iommufd);
 		/* If devid is VFIO_PCI_DEVID_NOT_OWNED, clear owned flag. */
-		if (fill->devices[fill->cur].devid == VFIO_PCI_DEVID_NOT_OWNED)
+		if (info.devid == VFIO_PCI_DEVID_NOT_OWNED)
 			fill->flags &= ~VFIO_PCI_HOT_RESET_FLAG_DEV_ID_OWNED;
 	} else {
 		struct iommu_group *iommu_group;
@@ -814,13 +818,13 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
 		if (!iommu_group)
 			return -EPERM; /* Cannot reset non-isolated devices */
 
-		fill->devices[fill->cur].group_id = iommu_group_id(iommu_group);
+		info.group_id = iommu_group_id(iommu_group);
 		iommu_group_put(iommu_group);
 	}
-	fill->devices[fill->cur].segment = pci_domain_nr(pdev->bus);
-	fill->devices[fill->cur].bus = pdev->bus->number;
-	fill->devices[fill->cur].devfn = pdev->devfn;
-	fill->cur++;
+
+	if (copy_to_user(fill->devices, &info, sizeof(info)))
+		return -EFAULT;
+	fill->devices++;
 	return 0;
 }
 
@@ -1212,8 +1216,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	unsigned long minsz =
 		offsetofend(struct vfio_pci_hot_reset_info, count);
 	struct vfio_pci_hot_reset_info hdr;
-	struct vfio_pci_fill_info fill = { 0 };
-	struct vfio_pci_dependent_device *devices = NULL;
+	struct vfio_pci_fill_info fill = {};
 	bool slot = false;
 	int ret = 0;
 
@@ -1231,29 +1234,9 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	else if (pci_probe_reset_bus(vdev->pdev->bus))
 		return -ENODEV;
 
-	/* How many devices are affected? */
-	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_count_devs,
-					    &fill.max, slot);
-	if (ret)
-		return ret;
-
-	WARN_ON(!fill.max); /* Should always be at least one */
-
-	/*
-	 * If there's enough space, fill it now, otherwise return -ENOSPC and
-	 * the number of devices affected.
-	 */
-	if (hdr.argsz < sizeof(hdr) + (fill.max * sizeof(*devices))) {
-		ret = -ENOSPC;
-		hdr.count = fill.max;
-		goto reset_info_exit;
-	}
-
-	devices = kcalloc(fill.max, sizeof(*devices), GFP_KERNEL);
-	if (!devices)
-		return -ENOMEM;
-
-	fill.devices = devices;
+	fill.devices = arg->devices;
+	fill.devices_end = arg->devices +
+			   (hdr.argsz - sizeof(hdr)) / sizeof(arg->devices[0]);
 	fill.vdev = &vdev->vdev;
 
 	if (vfio_device_cdev_opened(&vdev->vdev))
@@ -1264,29 +1247,14 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	ret = vfio_pci_for_each_slot_or_bus(vdev->pdev, vfio_pci_fill_devs,
 					    &fill, slot);
 	mutex_unlock(&vdev->vdev.dev_set->lock);
+	if (ret)
+		return ret;
 
-	/*
-	 * If a device was removed between counting and filling, we may come up
-	 * short of fill.max.  If a device was added, we'll have a return of
-	 * -EAGAIN above.
-	 */
-	if (!ret) {
-		hdr.count = fill.cur;
-		hdr.flags = fill.flags;
-	}
-
-reset_info_exit:
+	hdr.count = fill.devices - arg->devices;
+	hdr.flags = fill.flags;
 	if (copy_to_user(arg, &hdr, minsz))
 		ret = -EFAULT;
-
-	if (!ret) {
-		if (copy_to_user(&arg->devices, devices,
-				 hdr.count * sizeof(*devices)))
-			ret = -EFAULT;
-	}
-
-	kfree(devices);
-	return ret;
+	return 0;
 }
 
 static int
