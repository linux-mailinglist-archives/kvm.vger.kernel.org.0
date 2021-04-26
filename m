Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E591236BA6E
	for <lists+kvm@lfdr.de>; Mon, 26 Apr 2021 22:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241763AbhDZUBF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Apr 2021 16:01:05 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:3982
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241756AbhDZUBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Apr 2021 16:01:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hSeiOf/Taw+QuQLMMjxHIzIDSQaSOkHDIzsfv7x+MUl+FG2hYk/WWAy6MBxwcmwftaeKLyntq7/xkGoUB5QTKcT/NrPLjAowGAt/lQbDhRV3/dphWaY1jVoumxv2VQj4U40Vgd1ZdLlONR+iIYcXtgYakMxf6dh7wc3eXP6HSO9C2uFcb9Iq1lkkS3EOZF0zGjlDW8yhuOsQzPtxQvUo2g+VZZKITlDTsD1UY8F00wQCDa49MGyh11hjMm0I5Q/dUvy3D4xhWTuyOuHiycqZf3O4daDuepaWnLvXFeGgbzGEBHQ6mQbeZ2ALhc+5GJzYmCk5nLuIBsd5C7ychourtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85d1GGi5lVbNNIETRv7G4mAPZ6QwjFv2EPtHrVvtDg0=;
 b=caRMrUJlxOp8JOQKbXZRqLVu1AxL6LKUdWTMOLxUHpKNj5ACHlpSBpf+ZDgyROmwOVySTl7UJ8jGSOC64cEAe+iDvcvDqkfHu++Rq1u7LPDBMIRAi0CouHitOyYhhkPQ9l677RkbxzgMpnDtCNRbT8LuLPteAFUq0eOVQF4dTMp8SG9FSjz6YNroelhsaxhldWslua9fb2ylqAShBpdX5D7xgBBlxLCefckz1hRMhedhcsm/fh1KWNOlNW+u8XmbhVf564eC8krqrtgAgGNhVtq9acA1kvLS9t/T53gK88kI/W+igHWZhs//Be6YVPnRypMp3xrXQPYx/EHnbOzI+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=85d1GGi5lVbNNIETRv7G4mAPZ6QwjFv2EPtHrVvtDg0=;
 b=XmYE2N0Kt2NcoOjKOE88FrotgL60JM9z3o7rvytwxE9e9lcVFfbWr2ZktUh5lrZKrzFoNXTD97iqH9qpuG7ttcMWq2rsMtdQwTOrHfPM6+NOaDGpSmoSPzApGoPzhYTUmr3hc/HgzuL5K0En8AeQ8VpoyEJKNTJWuwkc0iy5JbaRhwFnIJOfXPaqDZnP3TN+I5kXGFC/bFvH9xwPhODeUwRIUrfZsZd36bWoeBpTAKjhfTmTIxLWT1ZscUaWxjyDaWZMjmBLxtP0x3Bjx6bQmforLJzLQOTxA1hLPqCAbSPYkVEq5d+DqnMK7RmSiVrUMEI31gaeeqOCxqnpioEtAA==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1659.namprd12.prod.outlook.com (2603:10b6:4:11::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Mon, 26 Apr
 2021 20:00:21 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4065.026; Mon, 26 Apr 2021
 20:00:21 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: [PATCH v2 13/13] vfio/mdev: Remove mdev drvdata
Date:   Mon, 26 Apr 2021 17:00:15 -0300
Message-Id: <13-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
In-Reply-To: <0-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
References: 
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0412.namprd13.prod.outlook.com
 (2603:10b6:208:2c2::27) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0412.namprd13.prod.outlook.com (2603:10b6:208:2c2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.16 via Frontend Transport; Mon, 26 Apr 2021 20:00:18 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lb7Oy-00DFZn-7n; Mon, 26 Apr 2021 17:00:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fba8a87b-8eb1-4d40-1612-08d908edea5e
X-MS-TrafficTypeDiagnostic: DM5PR12MB1659:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16594A376D94B0F75D3D7606C2429@DM5PR12MB1659.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:741;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6fqAB9UdJU1X83Ix06I2SuvpErxdmMRPWfjNZPFSkogjGPiySbVcYNcp/WdyxlXm05Wm+xVqhf9kBFEQxzGCY+8wojwQ3lVMHhBeKbXsbdu5ey7//N749hpWoR+dEhMa37m5RDgfurMcKgT+5xdawBs+NfRcUU9VO0q3z4KhQI2aNgDfIUZHqPaK8GGngnmSZ3HXuKhA2fZWsK5GYFd4iRynKNMlFvAxzCMxyYOsghsMMsjLz/KfhcGMzQjiGKse2IC5nAJ8fCbCHH29AGnKFFbmaA3iihUJcYbT41UUMdL9z9pC59ebuiWqPLNQ1/HjrDoEvhD7ME1eNp0PJNjysgPyEUc+SRQ27+lHC/5TWDKAU4QLn1Si3zR/czovHjui5d72p2PrEDK9cy4emEgZTHEzM+kNSgcoW9Qbea1KNHbsGjUzEGWExDS7G5sYUNmOjEkErXskUozBjGXi7qm9exeA1hzaZqE7xDINDRJd4RwNmhtNErUJxxTDibhehbRZqT+RBQEN918KgbujDzTGY2ztNSxADEOnYN+ohcPTej38RkzibWCDlrvDTcuJJD0tw2z77gkLbZQ0ZoPKm5rC1w1eJzpZOj1FrNIGjCzmmEE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(66946007)(36756003)(66556008)(66476007)(8676002)(2906002)(86362001)(6636002)(2616005)(8936002)(478600001)(426003)(83380400001)(5660300002)(4326008)(38100700002)(9786002)(107886003)(37006003)(9746002)(6862004)(186003)(316002)(54906003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fK0d5eY2IOujoOohcC1y5xlo/OjZf++BL3nXMSTU/hVhz6XKSqOg/67lJphB?=
 =?us-ascii?Q?9m/BK56e9ZbHI+mCth+0qnmGuGNLQqP77FMBWZ5yN4HFnkYZ/mMlhci0l4UP?=
 =?us-ascii?Q?9QmhsgRHjbSUNy2yaGuWnpNS/hVOtePs+CAIjXEc3Z7wYnnULmo/OkZpKvB9?=
 =?us-ascii?Q?4c0ESpLeC3ppzufmsBX0BxogqO4lRw5PIHCorcPRct+2TxPmv+0IxCbuVfUh?=
 =?us-ascii?Q?CfKSslIGREZFhiSlD8lL1JcTwR05qxjqkudH66k+qRfg47r3HTitaFvswRqM?=
 =?us-ascii?Q?aEM0lBZVgFx6blEyUHCnWI1LFCGQFtatMGT8EqbxLd1NOG+pSYCAGil5AECI?=
 =?us-ascii?Q?MRnTlBYOtXUsaDy5Z93aIeKXakVfU8VmtvavVk83h3qkwQxsiVy62StciKHO?=
 =?us-ascii?Q?7GQCWjOHmGrSBzLm0Kfy4dJcvC0M/KaRRNKvY4hkgUPqtS5yL4CPQA/MksEj?=
 =?us-ascii?Q?UREOdxvujN/QZ4l27rpWeBMhd9DHxGa/qxZXWPtWUhuOUo/TzDDCzjpFA51E?=
 =?us-ascii?Q?8lTLm4PaptPqcTSTs5KQzpZ8FdEjddN3R0BfFNDpIQsa+BrPbe/pyTX0ZONB?=
 =?us-ascii?Q?3Rlb4VQNyO6WkXWMArmdgkfs1Cimx+a8edkKkUuUqzCmCiZiJgCsyVVP9hVM?=
 =?us-ascii?Q?hqeNmohh9D2g1dvqDdDNUKEkouSEVSo4z7LQ+Us6y/kYlBfQdb5xhNlKYv9i?=
 =?us-ascii?Q?ejlUS5++dXSc+MNk+21yPS7pQeHgMjKErqX5HoJEJ3d7CAvL+yHu0ruRGvhp?=
 =?us-ascii?Q?cU/NCgxgTXszW4Ff/PhcCWkoNBBdnU8SS9hzWX3iy585L686Xk3nqdZTxzbP?=
 =?us-ascii?Q?Dkb8pSkhG5I01aHXDT9yjiN9DaHHugNMXpDE0p4L+rBtS26qZxzIN67YXFa5?=
 =?us-ascii?Q?g3S3fIkM7J8sDFoZIcdfqHATv0E1ElqSbI+IC7Z7FkfEC0dRWQ4CMC4jtdXk?=
 =?us-ascii?Q?Xem1PIPEmCIYlg25aFvoymrkuJKSiur/LY5X6JqDITAVSxb5rQD3wXssqHFc?=
 =?us-ascii?Q?cAJVNnaESRnqmvawJGH+n6gqBd5v6OBY3pQExwGN2cjhE5rs4eJtIB7kNHIq?=
 =?us-ascii?Q?cbFBo8lD8Vca4l7yHr0+q44butY2IkS89amNhJJbqctzmVEr7rvg28IyFEaq?=
 =?us-ascii?Q?n+Rt5nCgqsFBDKyPjY1lYJ3XoOKQghwWBSQmwkLkk4qLYxP0qy5JIfKgDuwc?=
 =?us-ascii?Q?xmE7hjEi3y6Q3/9GSzS1M7/0jgxEVsARpBHZ3h4vJ3f4M18DT1YVQpbNva+1?=
 =?us-ascii?Q?gGmDnqAkOJQ4MVFO3JwjTzwvoX8FaM7jjjgVrD/Q07J4zvBfcWZnzbqPRxWQ?=
 =?us-ascii?Q?WAcM7z0tCDj/1eEw3mMnRHN0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fba8a87b-8eb1-4d40-1612-08d908edea5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2021 20:00:18.3600
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p6P1Wa3IEdmf5D8EyBBKAdSNP6IT0aGVXAXenqOl/R7epzKyM2nyrfTiWMSqT+xd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1659
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is no longer used, remove it.

All usages were moved over to either use container_of() from a vfio_device
or to use dev_drvdata() directly on the mdev.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 include/linux/mdev.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/mdev.h b/include/linux/mdev.h
index af807c77c1e0f5..2c7267f1356d78 100644
--- a/include/linux/mdev.h
+++ b/include/linux/mdev.h
@@ -15,7 +15,6 @@ struct mdev_type;
 struct mdev_device {
 	struct device dev;
 	guid_t uuid;
-	void *driver_data;
 	struct list_head next;
 	struct mdev_type *type;
 	struct device *iommu_device;
@@ -87,14 +86,6 @@ struct mdev_driver {
 	struct device_driver driver;
 };
 
-static inline void *mdev_get_drvdata(struct mdev_device *mdev)
-{
-	return mdev->driver_data;
-}
-static inline void mdev_set_drvdata(struct mdev_device *mdev, void *data)
-{
-	mdev->driver_data = data;
-}
 static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
 {
 	return &mdev->uuid;
-- 
2.31.1

