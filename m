Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4214F87B5
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 21:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237519AbiDGTKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 15:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbiDGTKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 15:10:33 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2081.outbound.protection.outlook.com [40.107.92.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920B1232D24
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 12:08:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fVikd7plE6MvNlYXMqjrStMcN63MeFfjFkh8U0BaYEK0RXQYOmAmb5fos7gy8r88J6pgwbwIzg+W1GfaNM1Jv/R8GW/UBNYzCtHoWo5Cj9xCiZc/C+MwbJxI1WQzyilCDeWcrFtehNz23Z08MlhowacGMaaPyQ7td+Cnj9DJ/JbOgkr2Uikn7GXPBFR99WuJxQxP3uVHO22XUQCbIprMVm2hB1QpmC8tj6OtqVOOQMXU1mqA4Eq9rGzGfgSSNvGxnSyaV7W8AQhrw9/wHce82S5muJP+us6+ZyQlEziiHrfqiriR1E44NTr/Pdv3xYuY5G7E1kpZQFRVkA6OiwrwPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jxASJizsrCn9W6xNht5bqMVXF7gC3fNcbRzt0jzeLwg=;
 b=Tmr09toUZ3D9qoq0K+El+Ni+HKGS1IEOwtGtc0jV1sOaThCqSd74gNXBn1wsam781/tMezkxufbCuUqbojhQLj7kd0xdTokUCgP9YTqANObPAti0oLyxEgZPy3Xc4xSoyser/ir+HbjiDt0J0bwPUmNJJ5N1wehYYWYKGJ4qMvhq/urf98x7dmvE4FsEK4aM6wjPZQZgcp5zTOlPQBYshqGsaKjlouIi5suIinOGMU9h0xHk40XjRHeRx/wLImcmTZngMzdbPz/ehlKxqKWwXIghP3TKAY4pgoE23Cp9hdnpVFUbd9rvTe8iKNcsqtF5oLk21Up8X6FQNGt+ti2EXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jxASJizsrCn9W6xNht5bqMVXF7gC3fNcbRzt0jzeLwg=;
 b=jn/QUgJJ/duGEjtEuWWu+sKoyRWwwiFipOZDPmHDSowm2+MwqfhAXJ0/RW3FXdEGHL0qI+R1XSAr7tmcvDRqT/kcYj9dsRNFm8NfkimmUBNTkx8HRziQs03YhRR6rbbmyS976nrZg3dqOfwePWy8WYm0tQDY6Ie6GCAJ3NL4OwnTyVwcHy9eSjbLtg4cCVnTXNbiuUj4nzKjscJPIw441bFIOawB4SCcXX974jroLyqo9IB93RrKan7V0EufETP1FjLtks77sgUv++yKImRrXgaBb2kpeApkuEVT/lbdJDnqIr70NCKHCvAYfFLdpqUh+JlM0UZPbirvagMmoCl/fQ==
Received: from BY5PR12MB3841.namprd12.prod.outlook.com (2603:10b6:a03:194::27)
 by MN0PR12MB5956.namprd12.prod.outlook.com (2603:10b6:208:37f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Thu, 7 Apr
 2022 19:08:30 +0000
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB3841.namprd12.prod.outlook.com (2603:10b6:a03:194::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.21; Thu, 7 Apr
 2022 19:08:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 19:08:28 +0000
Date:   Thu, 7 Apr 2022 16:08:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>, Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH v2 0/4] Make the iommu driver no-snoop block feature
 consistent
Message-ID: <20220407190824.GS2120790@nvidia.com>
References: <0-v2-f090ae795824+6ad-intel_no_snoop_jgg@nvidia.com>
 <f5acf507-b4ef-b393-159c-05ca04feb43d@arm.com>
 <20220407174326.GR2120790@nvidia.com>
 <77482321-2e39-fc7c-09b6-e929a851a80f@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77482321-2e39-fc7c-09b6-e929a851a80f@arm.com>
X-ClientProxiedBy: BY3PR10CA0025.namprd10.prod.outlook.com
 (2603:10b6:a03:255::30) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1549235e-ceeb-4e63-70f5-08da18c9ffd0
X-MS-TrafficTypeDiagnostic: BY5PR12MB3841:EE_|MN0PR12MB5956:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB384173B7AC08D636E5050C4EC2E69@BY5PR12MB3841.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uz7xymfURypiDEndU4fk4cW85zkiD7TrM3gfm/qtEgxGVBgEa5t+1oc0cWyqRqeswRmRLPqMRCn2L8zJ3XJYfomzPCQnH6IHxj/lVdd94zBo5K3n6OUZ8ZqTSWQ5ayzEhP0dU5cDHzxy3oSxzcuf+NbI7cLGdwwi+jEPFB97fUYQ5iA9wjlnDE6NgUQ4oLZ5eJsi4ujLab5V/4K5AG0mJl4sHh9r88hZMCoBRlEQ+EccZhqAJkMz1J8KfGYuRStLmx1IyJi6FqCdrEytGfJZ16I5fJljXeunc41BE0wJDS4UWItacgfr7ecnp5hwxjmpxAKJKdAM0BF2N9kDLmyOzt+fi8jW58P3kPbGjMu+0bWyk4bGLrEIBY1zZmRonz8XTjd6hrnQV8MTj0LaTY0uoyqfGLCO8LRQRb67/X6/JtepRtelLup+84MS7ibAuOaJ/yEznLDyM4Yb+VKqjtwfLA9x+HIpAJn7V4xEMHR8hy6m2gc+k1dnHkO0k2p4g8aB0H9vrGdvIGbIrN4EOqkB9qse0r0CCQtiFt6hMnavuxJz12fHfU9dh6S7yFFKNyx79Qx6zrA9wqBKwPoWqylydHDzuBU5WJj0O0IhUDgY+iR68tYNp4VZPuGMBhpRUwUCMbrLF1wP11o+YS60EUXouA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3841.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(36756003)(8936002)(6512007)(316002)(186003)(6666004)(6916009)(86362001)(26005)(83380400001)(66556008)(2616005)(5660300002)(508600001)(1076003)(38100700002)(33656002)(66946007)(2906002)(4326008)(66476007)(8676002)(7416002)(53546011)(6506007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D4RMAht0L3exhw4WcTLsbHTqUgrH8lVFusIlIbHNz67DDoQNewhdUGGRwtYe?=
 =?us-ascii?Q?mO9eVxGb/aYgJkeMpl3M/5v8Ry5AOdqTjbMZpJKKfNZ9RhkT3zRLC3RDLWfg?=
 =?us-ascii?Q?xFbjAl5n7Nh1OGchgGiA71AFSHHKAVeOyXAwpjYzOKt9LeEveVZ580SOORbo?=
 =?us-ascii?Q?sV1UhnhnoEJ6hl1QZrKkpnNkycY/jMGsoyzEDIQMj9uDBbp3gRNG4j5NKLLS?=
 =?us-ascii?Q?WLv3pbNkQC6KNVVkTE3/xPORs4UNY9y/34O5/AcIZLtILjo2I9r0BUJA3lHJ?=
 =?us-ascii?Q?i52wH+ctviksipuMF+LUUiUc9VTVOt1YKfR1gX35WPtT8ILrqB7fojBRs27E?=
 =?us-ascii?Q?pexu4D/f8a7RageUf7pN3od4zw8knkOKVkBdtk41FU39WPjr8XPPSxgQJaD8?=
 =?us-ascii?Q?1pXui3FButEEHHnnmXia45O3Rh69/uiQ5liuMrMw+cv7rMI5r4nl2ffiiKnD?=
 =?us-ascii?Q?F+Ki5flPTAKRoV0K6oo4jOVC4WLq8zNq6Yop3Cxgsy/dUBRQHYts4Uwlj1Cv?=
 =?us-ascii?Q?SX0pBiGu/GfsL4iT+8yJHOCHuHjhytRSVUVu7g5CxpEGbWB0s0SlBWdxNT3/?=
 =?us-ascii?Q?yLXJ6OUp3DZoBmBG7TjwtXydv9tNlnhZfuVDhnclOvgZYKq1NtuVyES/i5PY?=
 =?us-ascii?Q?6DycmR5/aa7yR/QfPI8Fz6Oj5Z36CavUJvXkUnX4qiBrssBVlgh2t4tLmLk6?=
 =?us-ascii?Q?/RL2X4qDDumVUCHQGWLMyCbDdSq38DY9JqI12FZjbmi0J9GWGvhpfb+vJftf?=
 =?us-ascii?Q?KPGcWT1NMpv0Y9OyKN9EiKE5OO8lBPJiPl3V6I41G5KFhjORLLSSqYKzGJ8m?=
 =?us-ascii?Q?bPMCdDHDJOyYa+aOeLw2J/5WauRUO5GZl6PWiWRmkxhPLzkOcfJDN7D/eA3/?=
 =?us-ascii?Q?7VPjUorsxASdp8JWk8QeQd8Fzc1s7k6A5+zxdxh9YPgM0bzm49glJ73H1cL6?=
 =?us-ascii?Q?SJMB+Q6kb8GdJRsf1LIgmWFPOPW4zmTpQIsGZzLH54gg9uNLOJ/EaGQqkXEF?=
 =?us-ascii?Q?XUPLBNEegJkKpmzkna45uTftSmj4FLxJzpCT3KU2cuiaEvJXGJw93asYVSkN?=
 =?us-ascii?Q?c3pP1yYWCYnQzGMW/bUElkV9Q9XFCpEJVsz7aBa+p9/ujXqh9xikafuBDADO?=
 =?us-ascii?Q?mi6sjRak/jf7CT52URNne0LWILj6q5wDXwi4QCc1Ji25ilQZnyv3WFAn0Edf?=
 =?us-ascii?Q?x+jYTTYR3p3BRKiG55O4U3N8ECI4G4SFsE553WKtdcLTxDxTcH8kpDpIf5yD?=
 =?us-ascii?Q?SOfVTzsVLqjuQFBHm9Ke8UUP+XTnBUi8kEORlrtMW8GQCsUQByYX9rNzlOlM?=
 =?us-ascii?Q?YgRjwyTvQwhXINmCxqsHy7wcGrfRJMBDtedU9SiPmWSrsw4SplifCJngo7wQ?=
 =?us-ascii?Q?i6+qmhYr1VtoVRa4KGZzb0tn4eewtZI7oDobbWJhRZJZwgaVXo44KMKJ9bMh?=
 =?us-ascii?Q?u69Qr5O6f42+cqAPTgt2NOXvSJqBFO3UZtdFXD6fN3Ilub/olfyvW00BBDGn?=
 =?us-ascii?Q?nNBfo/SKrGTqaolR/wbjy+BiOAgXBqMrMnRr58F9uhbK2RU5p28i+TM9wtrf?=
 =?us-ascii?Q?ay+GWNm4b2G8FWMJ5UGfhUJCDRQBh+V2jIr2wvDYyogfE48BWkAjONEAA/yj?=
 =?us-ascii?Q?Dj+oFh5u8u1gJK89KICGGqu0DszzsSMZF78I6Qll3cS+sxObsIdTBSQKq6UF?=
 =?us-ascii?Q?5JZL5PEqRA+5YFeUY2/4WAvCS9iDymjgOjDjhR7GZI5BgiQB8UqWyMmQ2d8O?=
 =?us-ascii?Q?8A84WbFpWw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1549235e-ceeb-4e63-70f5-08da18c9ffd0
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 19:08:28.6627
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W7VyaW2mV+Hc005Wolva5cmYsm8WOHZMLKPKLRkVMKAg/MJV8znuxDxK9cTCg0G1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5956
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

On Thu, Apr 07, 2022 at 07:02:03PM +0100, Robin Murphy wrote:
> On 2022-04-07 18:43, Jason Gunthorpe wrote:
> > On Thu, Apr 07, 2022 at 06:03:37PM +0100, Robin Murphy wrote:
> > > At a glance, this all looks about the right shape to me now, thanks!
> > 
> > Thanks!
> > 
> > > Ideally I'd hope patch #4 could go straight to device_iommu_capable() from
> > > my Thunderbolt series, but we can figure that out in a couple of weeks once
> > 
> > Yes, this does helps that because now the only iommu_capable call is
> > in a context where a device is available :)
> 
> Derp, of course I have *two* VFIO patches waiting, the other one touching
> the iommu_capable() calls (there's still IOMMU_CAP_INTR_REMAP, which, much
> as I hate it and would love to boot all that stuff over to
> drivers/irqchip,

Oh me too...

> it's not in my way so I'm leaving it be for now). I'll have to rebase that
> anyway, so merging this as-is is absolutely fine!

This might help your effort - after this series and this below there
are no 'bus' users of iommu_capable left at all.

From 55d72be40bc0a031711e318c8dd1cb60673d9eca Mon Sep 17 00:00:00 2001
From: Jason Gunthorpe <jgg@nvidia.com>
Date: Thu, 7 Apr 2022 16:00:50 -0300
Subject: [PATCH] vfio: Move the IOMMU_CAP_INTR_REMAP to a context with a
 struct device

This check is done to ensure that the device we want to use is fully
isolated and the platform does not allow the device's MemWr TLPs to
trigger unauthorized MSIs.

Instead of doing it in the container context where we only have a group,
move the check to open_device where we actually know the device.

This is still security safe as userspace cannot trigger an MemWr TLPs
without obtaining a device fd.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 drivers/vfio/vfio.c             |  9 +++++++++
 drivers/vfio/vfio.h             |  1 +
 drivers/vfio/vfio_iommu_type1.c | 28 +++++++++++++++++-----------
 3 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 9edad767cfdad3..8db5cea1dc1d75 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -1355,6 +1355,15 @@ static int vfio_group_get_device_fd(struct vfio_group *group, char *buf)
 	if (IS_ERR(device))
 		return PTR_ERR(device);
 
+	/* Confirm this device is compatible with the container */
+	if (group->type == VFIO_IOMMU &&
+	    group->container->iommu_driver->ops->device_ok) {
+		ret = group->container->iommu_driver->ops->device_ok(
+			group->container->iommu_data, device->dev);
+		if (ret)
+			goto err_device_put;
+	}
+
 	if (!try_module_get(device->dev->driver->owner)) {
 		ret = -ENODEV;
 		goto err_device_put;
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index a6713022115155..3db60de71d42eb 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -66,6 +66,7 @@ struct vfio_iommu_driver_ops {
 						   struct iommu_group *group);
 	void		(*notify)(void *iommu_data,
 				  enum vfio_iommu_notify_type event);
+	int		(*device_ok)(void *iommu_data, struct device *device);
 };
 
 int vfio_register_iommu_driver(const struct vfio_iommu_driver_ops *ops);
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index c13b9290e35759..5e966fb0ab9202 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2153,6 +2153,21 @@ static void vfio_iommu_iova_insert_copy(struct vfio_iommu *iommu,
 	list_splice_tail(iova_copy, iova);
 }
 
+static int vfio_iommu_device_ok(void *iommu_data, struct device *device)
+{
+	bool msi_remap;
+
+	msi_remap = irq_domain_check_msi_remap() ||
+		    iommu_capable(device->bus, IOMMU_CAP_INTR_REMAP);
+
+	if (!allow_unsafe_interrupts && !msi_remap) {
+		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
+			__func__);
+		return -EPERM;
+	}
+	return 0;
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 		struct iommu_group *iommu_group, enum vfio_group_type type)
 {
@@ -2160,7 +2175,7 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct vfio_iommu_group *group;
 	struct vfio_domain *domain, *d;
 	struct bus_type *bus = NULL;
-	bool resv_msi, msi_remap;
+	bool resv_msi;
 	phys_addr_t resv_msi_base = 0;
 	struct iommu_domain_geometry *geo;
 	LIST_HEAD(iova_copy);
@@ -2257,16 +2272,6 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	INIT_LIST_HEAD(&domain->group_list);
 	list_add(&group->next, &domain->group_list);
 
-	msi_remap = irq_domain_check_msi_remap() ||
-		    iommu_capable(bus, IOMMU_CAP_INTR_REMAP);
-
-	if (!allow_unsafe_interrupts && !msi_remap) {
-		pr_warn("%s: No interrupt remapping support.  Use the module param \"allow_unsafe_interrupts\" to enable VFIO IOMMU support on this platform\n",
-		       __func__);
-		ret = -EPERM;
-		goto out_detach;
-	}
-
 	/*
 	 * If the IOMMU can block non-coherent operations (ie PCIe TLPs with
 	 * no-snoop set) then VFIO always turns this feature on because on Intel
@@ -3159,6 +3164,7 @@ static const struct vfio_iommu_driver_ops vfio_iommu_driver_ops_type1 = {
 	.open			= vfio_iommu_type1_open,
 	.release		= vfio_iommu_type1_release,
 	.ioctl			= vfio_iommu_type1_ioctl,
+	.device_ok		= vfio_iommu_device_ok,
 	.attach_group		= vfio_iommu_type1_attach_group,
 	.detach_group		= vfio_iommu_type1_detach_group,
 	.pin_pages		= vfio_iommu_type1_pin_pages,
-- 
2.35.1

