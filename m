Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09BAE3F90FD
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 01:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243796AbhHZXgt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 19:36:49 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:12672
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231509AbhHZXgs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 19:36:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOEeujhmq1cAL1QxQmFRlGkjE1prdT2Ip8Nj+sHwgMUdTqr7PcPkfi+MVrgl0x0LnC5ISoXqeD3zuWnXkyUSQpWKvKw0I8BU8mbYbon93Z/yiUfn0MB/qmsz8t/CnEf/ln+kgRDt39Ag41OwOxG6EwvCAqslfaa/t6rR21mO9waOKazP//70xqvZWckQ7Oin6yjywF3plVFWbVwtKt0RXt0evOca39IzOu2f8Ap3DJXnnWQsFuA+GeLwTsGlAVvIl9VnCa5OUSR6CGB0YMGhQ0SmzklvZZgPTuPV3gMxCOoJqVdMbFrjgJbsZ0uJ2yY//EYMN0UNX7YXZrzSPdr3Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A64SXhw5fZQyhCL4W4TYxsvGlOiN0yaR5KnfGx5+9Lg=;
 b=OGOaJGBrySiAbyQEjPMkNAbzG8uh+zlYDmv+weEavquxEuMOHSSifPNTaUve1Wkolw84H4Zg1hZmGtz9McxEDyBV1G85T5iyJJH4fCWQUHvbFQYxlsj+F3uq4VJY1e04TUxuyrFC1abjyGq74R3FRcKAu7LC23Y2KQ/Yc52QEN2h/LqCLZUV0PWN4Jt/2JPA73l1CPQxdGrAbnZoBaGEzSqydEqjwHRygRjEYo5H2KK2zhIAgWmn3pq//6t2eEXE8N49g2boKtqFYUtW1RQFNIcROz6q767erPViPCxL6LAPmPdLG3DoaDEXciYsLR8bGnKoUnq9gKmypb01Iy1TMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A64SXhw5fZQyhCL4W4TYxsvGlOiN0yaR5KnfGx5+9Lg=;
 b=gx5jexESmkxBlxnc1R8ZmD+AXjfjhJD8/6lKb8v4PJdm0qVKYtT3TINyOOn7k9chJEBKGCSCmjimxtpqfumHfXPgCUKOXSxH+MPC4zOxJC+lgwH0rXp1HdLqrFObd9H3mSyVw3VzOVb63Kz1GFHw/lUms4PSuxx+RwT+u/EA8fh/y3klWK98yWx0veaajAfK50z0MNG5KfI6ifp1o/1np5ymQrfanUUtFCe3K6vNg+pJlMjPgQwCJhbJBk+6Oh6Epxx3lftJpzJq37SN+DxK2qNPUsdQPc+CJsy/kY+DRRCku+HAQpVGhmHAWqzmIXP8u26eupguGBXL/EsTKR0yRQ==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5256.namprd12.prod.outlook.com (2603:10b6:208:319::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Thu, 26 Aug
 2021 23:35:59 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.027; Thu, 26 Aug 2021
 23:35:59 +0000
Date:   Thu, 26 Aug 2021 20:35:58 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 04/14] vfio: factor out a vfio_group_find_or_alloc helper
Message-ID: <20210826233558.GT1721383@nvidia.com>
References: <20210826133424.3362-1-hch@lst.de>
 <20210826133424.3362-5-hch@lst.de>
 <20210826135413.239e6d4e.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826135413.239e6d4e.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR0102CA0060.prod.exchangelabs.com
 (2603:10b6:208:25::37) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR0102CA0060.prod.exchangelabs.com (2603:10b6:208:25::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend Transport; Thu, 26 Aug 2021 23:35:59 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mJOuc-005VBD-D0; Thu, 26 Aug 2021 20:35:58 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c7fd572-e99b-4583-9ee9-08d968ea4235
X-MS-TrafficTypeDiagnostic: BL1PR12MB5256:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5256D1DEA9B7F002D6F209BFC2C79@BL1PR12MB5256.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JdqYphjxKgIn29Sopud+uZ01jR1NhxcAl6JmJvEdqD7MmoFnN5KqwLDfFnlUQrhDtW0OHPBqDHgnbRVOPSwgLgwghgjA2i2cr2SUimpr4ZZSWYJVVx5FD90z2xL0MKYYUfHfJbE7+aPMQvv/D5DhC9Nbl/t3AAoBPHkpabxgSr9wKaZSWV3yhj+pFNZHnB+c9yKicQTJ1N7RDI1RrcxQbsYu9Me84LBp94Z3U3lfsrQMYBUxCkEpCZAjZnxDfF4wYymnQTCm9yJwSNKMoZwDnlJcKKbiif9nc+O/kCH7G9CD2ucGNiK/0Ka1IlRZpQE0ZzzWLwysxAXJJ9PaiCeVDfVAg1sF2ZnRWdCqj7q6fVTycoMY6C3GlMe24Ph6VvbRxW5OUUyWJJBD3kvc2sH5oZGSAOuJGMtx9ExHMpcmZmO7CZ5qM9ZCccWxzmyoFNWwfffLmYPwjDQs0WdnES7InOjqbbrMHkXbzHAt36hQEqtFUB8yr8oV1+TT3bYyk7adsUafcmTk2opxUr4y0uL7vPkDAJ5aK5mkY53AbhRpzSLyIrP7p2Khj9neWiYJ9sHIg1ZEyoIkcfrPwGKlkarDgHAn95pghhsPBE+bu5e6gLy1t/qFjJPwH1wR+f9SK8faaClRXZjm9j8fIkMQ1KMwCA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(376002)(366004)(346002)(136003)(36756003)(83380400001)(2616005)(2906002)(9746002)(316002)(9786002)(54906003)(33656002)(426003)(8936002)(186003)(38100700002)(4326008)(478600001)(86362001)(26005)(66476007)(66556008)(1076003)(6916009)(5660300002)(66946007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?w9fBjK1hV5CEWzWbfl5veMbyxEjKSqZ5UBRpBpmf0dvku3szFsLbhiNuGD0t?=
 =?us-ascii?Q?sf4FGY5CEcRlVAhBvRZDMB1g/6FyHGqIssJcm/qukVtzUMhaCO7dDRGNqDol?=
 =?us-ascii?Q?SbzkFvvMw9E83uTp1Cz8ZDay9yRXC6dMpW9saW+rEMvDGNkXPGTdxKQVckEt?=
 =?us-ascii?Q?pwwROWVlqc5RHHjrRJkpHjXrE43quuM6H39s8Dr0bj/HYDwyWs358SyE68Tg?=
 =?us-ascii?Q?IvGQdV1pIw46JumyQZXATHPQtmdBRBJEmc7c/1TY8H5S97JS+31PzQCGDqe3?=
 =?us-ascii?Q?X24eSGKeN7TR7T5XddX+LuQbNjqjf+GkEhmHLdvNXsiyFjcCqZj5k8G+HqJH?=
 =?us-ascii?Q?fIImUkGPCAi5MNPOpWQtQc4GLwVMIHm2eR5RVTssd3c3Nv6C5VfKhHxxTQnC?=
 =?us-ascii?Q?lklsshyKciEvvxJkkKvW0EhM13IrBMMi8rr+wJW6NjWUsz0Sbsq3Cc4xr4DG?=
 =?us-ascii?Q?W8kT1LXdeaBXXW3YC2Aezaz2yDHxK21uaRZnfGHvxtME00E/HuDkhAEm6+7W?=
 =?us-ascii?Q?WJLpw5/yBij1gojkPgx7nBH9brWp0QsTwS7ARN7EkPoR0W6L73ZzCIfAYwRe?=
 =?us-ascii?Q?BsnfN0SklKK+Fh+qurKH63mR53Ob1BiMQczRrbH0tgUWdKGTG2k4BR0Tu40p?=
 =?us-ascii?Q?f4rBkLzRFcfalt5CLlOSTOKm0tp6KMe6N242P+z1/iY1XSF+2h9GwZQmrAnS?=
 =?us-ascii?Q?xoD1CjOvgLJyhgsK6GJImNXEzygPfsuaqCt4FHDB2mvfp0p/7wHuf0v+W9mB?=
 =?us-ascii?Q?yms2/GZ3qY658YMDhbMmSX2vIhXYlTw4r1i1VyZnYkRpSsJFxDIf/OlWZfqJ?=
 =?us-ascii?Q?/XvKOm/Gas8e/X5HEkitgduRNY2xzmT1goOA0fV0zFvf+NpHJBZBhSip55pV?=
 =?us-ascii?Q?ewpVIbiskNi/0xZYC50da0FboY8NlbulMZItBw3quLflDMra94WdN0sPr67w?=
 =?us-ascii?Q?qkaKlO89xM2HU9uns3x2DiCY1wGDAykQ9mV+AxgbDAWuUMtU71IC8g7YfoLt?=
 =?us-ascii?Q?DFUGpuMeQHtEM7Rc/r7VPzmD4lv+dN0XGxzgc0MZMKsPFZfZHwtCZHFv2eBE?=
 =?us-ascii?Q?vJejTyWEdc1Txpq6HnG8MlGogCEv+u/gt8i1+5DJSW+4yPzqUgo5cPAZrHst?=
 =?us-ascii?Q?EE2w8SRtEGVWFFeLFIGbvp1aF8tcykZl/0Pn0hJhT/O/LLuxUonhFhzfeVgp?=
 =?us-ascii?Q?Arb7gyq/vUW5J9yaNrTsnbOPJcUMVX/0+nu7UPuxVg7V3uVn3gp+Y+a7Yauj?=
 =?us-ascii?Q?zBImKoAZHRsh/QbNjvIuDuf+nAfT7fXtytAJrNtLtJvkyhIiwXmHq1QEz/ko?=
 =?us-ascii?Q?TmSxk0AKMlk9sjXgSD4ghF9r?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c7fd572-e99b-4583-9ee9-08d968ea4235
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2021 23:35:59.3784
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wTXIejXdsxs4Ko0XhQp/gvBZMBeoSIEvweyg8Lz+DcEjVmjua2Q4t0P2QatpIYIr
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5256
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 01:54:13PM -0600, Alex Williamson wrote:
> On Thu, 26 Aug 2021 15:34:14 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Factor out a helper to find or allocate the vfio_group to reduce the
> > spagetthi code in vfio_register_group_dev a little.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/vfio.c | 59 ++++++++++++++++++++++++++-------------------
> >  1 file changed, 34 insertions(+), 25 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index 18e4c7906d1b3f..852fe22125520d 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -823,10 +823,38 @@ void vfio_uninit_group_dev(struct vfio_device *device)
> >  }
> >  EXPORT_SYMBOL_GPL(vfio_uninit_group_dev);
> >  
> > +struct vfio_group *vfio_group_find_or_alloc(struct device *dev)
> > +{
> > +	struct iommu_group *iommu_group;
> > +	struct vfio_group *group;
> > +
> > +	iommu_group = vfio_iommu_group_get(dev);
> > +	if (!iommu_group)
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	/* a found vfio_group already holds a reference to the iommu_group */
> > +	group = vfio_group_get_from_iommu(iommu_group);
> > +	if (group)
> > +		goto out_put;
> > +
> > +	/* a newly created vfio_group keeps the reference. */
> > +	group = vfio_create_group(iommu_group);
> > +	if (IS_ERR(group))
> > +		goto out_put;
> > +	return group;
> > +
> > +out_put:
> > +#ifdef CONFIG_VFIO_NOIOMMU
> > +	if (iommu_group_get_iommudata(iommu_group) == &noiommu)
> > +		iommu_group_remove_device(dev);
> > +#endif
> 
> When we get here via the first goto above, it doesn't match the code
> we're removing below. 

If we are in noiommu mode then the group is a new singleton group and
vfio_group_get_from_iommu() cannot succeed, so the out_put cannot
trigger for the noiommu path.

This is all improved in patch 6 where the logic becomes clear:

+	iommu_group = iommu_group_get(dev);
+#ifdef CONFIG_VFIO_NOIOMMU
+	if (!iommu_group && noiommu && !iommu_present(dev->bus)) {
+		/*
+		 * With noiommu enabled, create an IOMMU group for devices that
+		 * don't already have one and don't have an iommu_ops on their
+		 * bus.  Taint the kernel because we're about to give a DMA
+		 * capable device to a user without IOMMU protection.
+		 */
+		group = vfio_noiommu_group_alloc(dev);
+		if (group) {
+			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
+			dev_warn(dev, "Adding kernel taint for vfio-noiommu group on device\n");
+		}
+		return group;

Eg we never do a pointless vfio_group_get_from_iommu() on a no-iommu
group in the first place, we just create everything directly.

It would be fine to add an extra label and then remove it in patch 6,
but it is also fine this way and properly cleaned by the end.

Jason
