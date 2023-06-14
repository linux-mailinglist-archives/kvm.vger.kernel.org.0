Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6BE272FE39
	for <lists+kvm@lfdr.de>; Wed, 14 Jun 2023 14:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244112AbjFNMRj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 08:17:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235820AbjFNMRg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 08:17:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC2E21BF9;
        Wed, 14 Jun 2023 05:17:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GjeYzsjVLC0gLwf1GMvsJMBLzvHbFBNmgyCM7dzN1WpHCXpqFaP+6oZZEpudHsdbXqJw4nlGmxZfYU+3lETT5ZVSWFOgpNPVCB4e7vZKNuViU1MBd5WjsKaU9BkbbBjf7Ee3qy3io5t61vkJZEoo7C4s/3LeK2rK6Nl0Dr3KD+uNWOIhFpFjRDoNGPkrIMWzwEpg0LaTkX4CdwJYNvdjy8soJhi0TiTaSL96v7PrEbZXKs3VUaxUG16hN+5cDQaGfDYrPQJ+9v9cyDnbQ85DggnSCrlRojDpC84MCnuTu8ZJFwl+rIsNmJLNd/Q0l9pWsYJcb4TLbrzBj4qlFkgrcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHPEwP3TM05fww+zEesR06SmiFABnqpX/E7s/XAPuvk=;
 b=QRVbZ0nttsKXhND/RH4n1TOtG/+NBathC407ucp9A8TcijTj1fhyBvFGddVxoUEJbaMkMRA999vGB3MKWuHdWYM1xRLCD2LKH5q+Eip++3TfjIbAMZXPmkEcht++GJyivMCkWCCYGe6dlEekd1iS+ZmVpgCWY3epIww4o1zAZ2uJrKo5ijg+HKebL/s2iHRqQXlqfK0QoskJeB/mYNyZtf7xRaxHYZ9CKenxVdbxMp09HU6aSOQN7hu4H9oSgXBKufNf3pmJhdXl9TSkGBD6Ki3zu5OkeCnS4CllZu0mxj/Jrb+pzfhgqyvAYiKHK7aHk6QzyDNcU+eXG+DbKecSwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHPEwP3TM05fww+zEesR06SmiFABnqpX/E7s/XAPuvk=;
 b=POKqix+01s6toB0eX4MIFoQ3rPBamO4Df8yzWnu3IpSuZuV8pFTKt/dnhUs+k2lzGL5bEmfiv3WvM69uETrk5CKPhizwpxjn7yvePoythaMKxbRghTPbSZV7MuRM4sLdb3gW1YR7D06mALLRdfgP5L9Jrnpd9wxOHbfoB1mAjfA7ufk7mampWUKGPL5sJlA8JyC7pky8AY54wDzaLVA9ezFZRLhhlLl1B9qHzx5cxMeBl+oqIwwu6dLnEpM4CkIpRONUPIEFR5nw3VgM9CXJxjmODK4Sttz2hNfJJMcMYQNscZ3ipVO5Bd68P6IjajLwXXgHpIOe4b67J5sS6BzENQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB7306.namprd12.prod.outlook.com (2603:10b6:510:20a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.42; Wed, 14 Jun
 2023 12:17:32 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6477.037; Wed, 14 Jun 2023
 12:17:32 +0000
Date:   Wed, 14 Jun 2023 09:17:29 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v7 8/9] vfio/pci: Extend
 VFIO_DEVICE_GET_PCI_HOT_RESET_INFO for vfio device cdev
Message-ID: <ZImv2bl1COqA/8c1@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-9-yi.l.liu@intel.com>
 <ZIi0Bizk9qr1SgJ/@nvidia.com>
 <DS0PR11MB752932BD50E4F73FD7982DB0C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DS0PR11MB752932BD50E4F73FD7982DB0C35AA@DS0PR11MB7529.namprd11.prod.outlook.com>
X-ClientProxiedBy: BYAPR11CA0048.namprd11.prod.outlook.com
 (2603:10b6:a03:80::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB7306:EE_
X-MS-Office365-Filtering-Correlation-Id: b127cee2-a9ba-4edc-3617-08db6cd15468
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bkde4lyyjMSPiHGE+u9/LHQd8dkGgcXw7sFhGwTIMTWh7dKOl3WmhH4fe8klB7fhZm9TRAaMB6I8mMNfSYd1pcbe07C0JWBEaRsOKLG2+dV1lC5n6HfpG3dBGiGJ51lltGrhBAi11v0LeTb+PjeFDznDc0XuhQNrj1EOd8WL70YeFNaxFSEqNOlxS1VnTZpV/2Ub5OPWrDJ6W7kuWfq5qngno03xxrBXuRfeUfAHxfeuyP9/+ODFd7Z5Ld2SAiuXS6Y1VSzeFJYWJlf2WhPAKTy2y8P2EMMw1IWvPyPUZp+xjd+BDXYGgNJAXT31nSEn3Pj3WgbN/yj5MPdVb6cvHIUDkcIqLqSSQY4rjeFUQJ1QkncN2/4FrA2OUhpAXnWeId8ugLTpvgkzFJZ5S7ABCDogAvFS+Ml1eZHtCyS8Q0ON99c5Dz34jI3rN2MArW/XA9RXKpHnQMr/wyDmzirDzOQR7XqOhIS/K/Fv/MSk6eVhSbKwB4W/fh6r9RfHL8gqq29m+jTzURupP8EyOza9azqd5pOuToSIYe3mfGIzGEw4G3apnZlP6vYa0Avj+Pel
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199021)(26005)(6512007)(6506007)(186003)(2616005)(83380400001)(7416002)(6666004)(36756003)(6486002)(2906002)(8936002)(8676002)(478600001)(54906003)(41300700001)(5660300002)(86362001)(6916009)(38100700002)(4326008)(316002)(66946007)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rDrTN/8lbGI0y+Q+CMWAKY9BsXz6sXGM5uNjy7IGos2Mn13UoWOiMIAqdEHZ?=
 =?us-ascii?Q?/C4HqgZOFqot7AgV3bkXtINscXFaKL95aHOoYpPzyRaUvFQ6kcFj+UuoUOPN?=
 =?us-ascii?Q?7kGB/3FAIJ4KCJ/FeGzJIQlpiTjnGdKH1/SA6hHQXvMlMaV33Udvfwzlv7y2?=
 =?us-ascii?Q?7231PFW7uZGa3/UJrXvyj8b5gBweCO2tIAGKhWLInwotMzIyS6AfztU1fTf1?=
 =?us-ascii?Q?ukaZNpX2lW82EDzE9Gx48DA0ZIkfVgtFTBNJB7GbB9Cit1GCUW73ffQS8wcC?=
 =?us-ascii?Q?tbv+1T2lvOFP744KAROr19xD6m3ZM4Hl7NI3JV0v78Op+pBDF3E9yb6c7R9J?=
 =?us-ascii?Q?PcQU0xp2NPS32hMbvt+5Fpa9eU2QVzvYDLyxABhozxFrppFxz3gJ5a/ojfxn?=
 =?us-ascii?Q?qAZqR9pbDPHW7+WW3qSzzmy3PqoAcT70YNkfzriTca3a3bKRCCz17N7XpyNP?=
 =?us-ascii?Q?tom4AfouBJgpd7q82D6HIQyKZ1tshNZL0h3u9y1KMYkTG4ZpEJGs+Ee39krt?=
 =?us-ascii?Q?kwEFJEirol9OmaAuGUMFCTR/WR/bvW8l9wSrGPYyPnPHcfWASaqLauaYWB+p?=
 =?us-ascii?Q?vPJQ5XuTJk0qWz498pxajtFalFHbcd0ADHkSmBN5yBQenRH70htqDbDAVsqg?=
 =?us-ascii?Q?/+bLnSFohAlPKjXlsVIVtYmA6YH2F6/ou0vubDT9h4bynFmENGH84rgy87w4?=
 =?us-ascii?Q?t/bkBwyJjPrVSz/vvHtI81s10P1HXFe/CQCQcXKZxSSB7FckEWzfdBp7RMVO?=
 =?us-ascii?Q?9Y5jjIMlUE7QrLGdN4bSH6Dah75WIBZRRv9ao7Ca5wmLgOqOeEE/gZYtKBFo?=
 =?us-ascii?Q?7OF8iHD7Nt17iWJIeNKa/ZUgQEiHNs7oU6QinCzPboSoHhmaIUIFoidUjWC+?=
 =?us-ascii?Q?GOf39ls41VGJEyNJklp77vbKYu+a+9iqx4XCdlqDL5TSY0efW2YbYbj0J7ry?=
 =?us-ascii?Q?gdTw3v6LSP/ufX6DeagReRI6KCZ+9Y6wBSlKhjiWXw+ZCtkJmwkiTgcdq1jD?=
 =?us-ascii?Q?qp7UKaBXDBIJEkxY1kHmC0EIOppi/Vx0cDYpGjaI0cWhA91/kbquulHVAWXu?=
 =?us-ascii?Q?1P3X1ma5Dst0K4/P1IdAl15qC/dF0cDNXkkY9wbzVKGU3B6PMFnEc34VF2ST?=
 =?us-ascii?Q?ovYeRKNH+Y2r3h7HxnPfM5mLOHwm8E6iy+7HXZE5zOuw6D4ODMPUc+2DYmbk?=
 =?us-ascii?Q?Z2jL+dvIs+wn/b9yUeDH2Fpqh7PZpDKIdf1PkFVo+McJ8BNpo7J/MgTV5Uqq?=
 =?us-ascii?Q?uqh9+WrpH2B//cYMJcI2Aih08QwDvoUrbz0YDomdR+N0vu4ma6fTi2dr8g16?=
 =?us-ascii?Q?kQxB9SClSMqYpsWGivqviX4d8etf3gnQb+13LJNAz+/MSXRsVG3HPhfCilO8?=
 =?us-ascii?Q?lN9u3hR5VWFt4SuK12lvae1JI1sI9IdFjHC7kn1/Si8j4mMAr7aAM+kbgZZ2?=
 =?us-ascii?Q?ZmP9zdKySirzmy/0SzveFlJ6+qZXdaClysp7chVaGzOJUc8fzaLqjiy/ya9N?=
 =?us-ascii?Q?4uTBHFidfuKJurFM7TEWCGVe5nQxQlxVROt2ueFp5YuM9ZGdY8agvWz8g/pU?=
 =?us-ascii?Q?fTObXMH9a8ExMF48g7/RJbP+3nglmBWSi+yGvdpd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b127cee2-a9ba-4edc-3617-08db6cd15468
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 12:17:32.4385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RqZCbSTFn1GCjyMgEWQknLaP1yO/5v4kKQhIJZFsA6vkOdYU1M4ImxeQpodPcjLA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7306
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

On Wed, Jun 14, 2023 at 10:35:10AM +0000, Liu, Yi L wrote:

> > -	if (fill->cur == fill->max)
> > -		return -EAGAIN; /* Something changed, try again */
> > +	if (fill->devices_end >= fill->devices)
> > +		return -ENOSPC;
> 
> This should be fill->devices_end <= fill->devices. 

Yep

> Even it's corrected. The
> new code does not return -EAGAIN. 

Right, there is no EAGAIN. If the caller didn't provide enough space
the previous version returned ENOSPC:

> > -	if (hdr.argsz < sizeof(hdr) + (fill.max * sizeof(*devices))) {
> > -		ret = -ENOSPC;
> > -		hdr.count = fill.max;
> > -		goto reset_info_exit;
> > -	}

-EAGAIN basically means the kernel internally malfunctioned - eg it
allocated too little space for the actual size of devices. That is no
longer possible in this version so it should never return -EAGAIN.

> And if return -ENOSPC, the expected
> size should be returned. But I didn't see it. As the hunk below[1] is removed,
> seems no way to know how many memory it requires.

Yes, I missed that, it should keep counting

Like this then

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index b0eadafcbcf502..05c064896a7a94 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -775,19 +775,25 @@ static int vfio_pci_count_devs(struct pci_dev *pdev, void *data)
 }
 
 struct vfio_pci_fill_info {
-	int max;
-	int cur;
-	struct vfio_pci_dependent_device *devices;
+	struct vfio_pci_dependent_device __user *devices;
+	struct vfio_pci_dependent_device __user *devices_end;
 	struct vfio_device *vdev;
+	u32 count;
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
+	fill.count++;
+	if (fill->devices >= fill->devices_end)
+		return 0;
 
 	if (fill->flags & VFIO_PCI_HOT_RESET_FLAG_DEV_ID) {
 		struct iommufd_ctx *iommufd = vfio_iommufd_device_ictx(fill->vdev);
@@ -800,12 +806,12 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
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
@@ -814,13 +820,13 @@ static int vfio_pci_fill_devs(struct pci_dev *pdev, void *data)
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
 
@@ -1212,8 +1218,7 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
 	unsigned long minsz =
 		offsetofend(struct vfio_pci_hot_reset_info, count);
 	struct vfio_pci_hot_reset_info hdr;
-	struct vfio_pci_fill_info fill = { 0 };
-	struct vfio_pci_dependent_device *devices = NULL;
+	struct vfio_pci_fill_info fill = {};
 	bool slot = false;
 	int ret = 0;
 
@@ -1231,29 +1236,9 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
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
@@ -1264,29 +1249,17 @@ static int vfio_pci_ioctl_get_pci_hot_reset_info(
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
+	hdr.count = fill.count;
+	hdr.flags = fill.flags;
 	if (copy_to_user(arg, &hdr, minsz))
-		ret = -EFAULT;
+		return -EFAULT;
 
-	if (!ret) {
-		if (copy_to_user(&arg->devices, devices,
-				 hdr.count * sizeof(*devices)))
-			ret = -EFAULT;
-	}
-
-	kfree(devices);
-	return ret;
+	if (fill.count != fill.devices - arg->devices)
+		return -ENOSPC;
+	return 0;
 }
 
 static int
