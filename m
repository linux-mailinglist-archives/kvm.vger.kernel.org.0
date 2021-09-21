Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D77D4136C6
	for <lists+kvm@lfdr.de>; Tue, 21 Sep 2021 17:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhIUP6i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 11:58:38 -0400
Received: from mail-mw2nam12on2062.outbound.protection.outlook.com ([40.107.244.62]:12385
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234238AbhIUP6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 11:58:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ld5V4puCy12FQpESwhoVFBz1sS/oWylPEGHab0WLDvO9aPbb2Z70McBWjVNsRsErl/FkxWVgZbAXlppNfK5CtwNZk4mS4E3BySVF/6CTLO28hPrgNT2pq7Yvn3qTrgX8Y7Sg1eS6G2oBP4xjOdM4lgU9e891oBrf2ez5rVC1fSlniNd08swe7/je6ZC+6G5teJR0a2cBWpCL8n3Dirh4PY4L955oMxPb6PHVJPBwrVT0FpkBjf1ckP+XhbKbnZOerhqDaYcUHdoLBedXIBxrikonFmRT9hOeYo9V1/JjmdeNsQs8DxMdDJwCcwWh9NZhFBUnaDfW1S1wkgNy5OvFTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=YeE/wp+mtbJjp2wLcRq1RoItRW/JQwjGelKZJcXiuwo=;
 b=Z5Jbe3RH+FepcUNm1e63+bGLBALnaVHJ9+T0GQEvuGcsPLOZt7pSmPzMdNjnt807KgkDF3PkQiPN68jDjyUb6BQuUTEcOwWUQTlacE/wK57GAAqxwDEpLiGqFd7uQ9BuZwC6ps9hq74Nrh+OzjiajqWKF8giXIE9Bq7FzNRw0RcXzJbMV/wlSPUdNj3FIS2n1A9l0ZPVjW6u9ygLDIuNxLme9FXM4i1EEHkvS8AaVjVu04YspeRbzZaykplchBP6dTFXQRNhe411wserPi4FnZ9sJmxAyfJMOfINyBThHWWjQYHztaEqQAAn3BN6DENwe3KlwT4jYIu99zji8QsSPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YeE/wp+mtbJjp2wLcRq1RoItRW/JQwjGelKZJcXiuwo=;
 b=Io+EmylyNk1RrT5hVUYSZqClvvxtngy5N5QNQrH1VD+xm8PyU12SLn5pKkOkltS+BpjTzNP1fDLfQw/lb4ydOIe65Hmt8CG3iaasvp9dY4UuuTX7JmfetYN6mGwL85QWZRB3Nb6P8p1SAW9Jk5/MIg0iiDB3f2VHfX+Gs0VRplHUjdOWVQQEcKwj4XkPzQa0OYKxL1m8uYzoZ3csRQVmieg+aBD+0Wx5s4cIGkX2wnHRWbxtKIzAFmuZq2HeqTV3fcuznhlPE2Ih6THpcvE5GE8W67I3Iq4u2J6Y4saec5IMr+TGo5+QVPmqSu158it2RJlpNlHvk9N0H3KOghFopA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Tue, 21 Sep
 2021 15:57:06 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Tue, 21 Sep 2021
 15:57:06 +0000
Date:   Tue, 21 Sep 2021 12:57:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Liu Yi L <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, hch@lst.de, jasowang@redhat.com,
        joro@8bytes.org, jean-philippe@linaro.org, kevin.tian@intel.com,
        parav@mellanox.com, lkml@metux.net, pbonzini@redhat.com,
        lushenming@huawei.com, eric.auger@redhat.com, corbet@lwn.net,
        ashok.raj@intel.com, yi.l.liu@linux.intel.com,
        jun.j.tian@intel.com, hao.wu@intel.com, dave.jiang@intel.com,
        jacob.jun.pan@linux.intel.com, kwankhede@nvidia.com,
        robin.murphy@arm.com, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, baolu.lu@linux.intel.com,
        david@gibson.dropbear.id.au, nicolinc@nvidia.com
Subject: Re: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Message-ID: <20210921155705.GN327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210919063848.1476776-3-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1P223CA0030.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1P223CA0030.NAMP223.PROD.OUTLOOK.COM (2603:10b6:208:2c4::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Tue, 21 Sep 2021 15:57:06 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mSi8n-003VKR-8T; Tue, 21 Sep 2021 12:57:05 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e199b9e9-4afd-4377-7241-08d97d1875ed
X-MS-TrafficTypeDiagnostic: BL1PR12MB5157:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5157E652627F4FFEB131DE6BC2A19@BL1PR12MB5157.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 32hB2pMeYGv1AYmZUisScEM3r6e7pZsTFaDBOPr1PDZSbU3C0DyfW5dyJDoctNLlb9/9hYzh10cZ5bK2iJ00pc8nqael2xC5uvJYI6bUe0qAOJqZkyZZt8XTsDp9rNC5p8CMFQ+l62z0OI8rfFFdszaGIRK1cxgmQpGXXO20mD64q03ow3D8ryxvP3MOi6ZYDy+asH0v6ElxvaJCpgwXpsf5IQ/Jba377YbScWillz+IW98yqr/cfDgBoddUCtofk3IjnNw25dyHQnDDI2PNloTO/gkaMg4C5YhVmlkwZfer8HaC4x/RPi5vm0XFjKXjiLDJxLk1gMJZPCSc85zsueObs0hivMZHr2A9CsH0r/Bgq/CUrInE8pFt0Xy+2Kpdt+Hx0loCYN7IvdoUzxBATl8CbwT4PWa4lE3ewQURWruVg+Bytokl+fJWhgZ5Pa1Q1IVIf3WddfePgUsRw4+6zQ8CVG58y34sn+88Bw9jobcwQHWE2ga7h99fzIGXFTvtD+QVNgYKlBBBboUBu6T1Ei0WCz0/JKPPuPIFBlAfKxYJz6S3sd2BdJ2NQ3rD4256KdvhgvVV9Aa4Mws2U3gQYvoO7H7aT4PAN9inl8SHHAhGqfyIZ06uCZq5gIcQq44hYwnUnl2C7PjolOCabsQ/FaAaJ05VI7LwfqKxIGKBsQB08WrRRHw2DBxck6o1m3Qb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(1076003)(508600001)(8936002)(426003)(66476007)(83380400001)(33656002)(66946007)(36756003)(8676002)(86362001)(66556008)(2616005)(6916009)(4326008)(2906002)(107886003)(5660300002)(186003)(7416002)(26005)(9746002)(9786002)(316002)(38100700002)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gmti37FuoC2EKgRQnxpQlAYYuqDRA6azyU7oowJr1IZ3d6zGYt83LhqWQR+F?=
 =?us-ascii?Q?M3Ohfg5Bev2kdB9uncMbhAdfkIWJjjnFZUHmrm3dQbaDZDrwCKYOi9NbQCnl?=
 =?us-ascii?Q?16eCUNzf2dPFH5MsoAmED/qxZS3gYnC0V0SX6bf042Og5h3jtc0twmDAFcSO?=
 =?us-ascii?Q?wXbdRwINtILG5XeOvO80MHjweo5ePq46jWoe3q2rzoXeDSvvmouaWGCPFLGK?=
 =?us-ascii?Q?/K+s1VAAg+E+enfGiEGbdsnf86qvncrSNWDjEChoKlFGrG9Snyuwv7kVkuGM?=
 =?us-ascii?Q?0ppvRxs1J6teq8eagb+YTdLinIkZeE/LgMEUcueT0Bl+dv5Of0218Pv4W86N?=
 =?us-ascii?Q?QV/aD2jb99DdJX0trs+Zcl2oaSH2DPnhq8uwQ31iDpO5stxhb/rH+5ro2XDk?=
 =?us-ascii?Q?hXRrqm36ZwWDH9qe2Zgpayg30C4Wpj+kQyORHiw5W9o/cn+83g2+Qty0mfiA?=
 =?us-ascii?Q?G48W8+QF8k5dkDgnOz+fqqxVQR/I3OnyGnchPU+362T3PgyRnjd7yK2geo+9?=
 =?us-ascii?Q?bsxwT2eK6P/ai2A0+QpH3rRAf0xljvQtzdF7+PzyJkeH4LClX94eTQ5aqE3T?=
 =?us-ascii?Q?vkQVfToTLNalQ03XAhg4xgZOd9aeyUS4SvbfU4MmYqFWF9uZV6p3Geaa17SQ?=
 =?us-ascii?Q?qwF+7od8icMUdqA6dvbGnYopthGnAYXVf0EXMSn3IV1FixLBvyO480o2jYvA?=
 =?us-ascii?Q?z9yzyJaO3PoonCwgyRHl6rpnegV46haRXZcgmKsFjXyL53tCegmYC5fxbU3i?=
 =?us-ascii?Q?GQZeiBufVdmEBh8RcqmQC95C36fELyNSBX0PG5ieYAkRmDsJ4zNBoSLgGJHJ?=
 =?us-ascii?Q?dAr372M1OmJZVXQImcwsRvjUvPzvZDm9V8YIALtxW61/FVnReCLjvvbohrkv?=
 =?us-ascii?Q?sYyAivdut97K0IwVt9dGrxUHMUBa80+CqgeXLSXCER/pswUbUFFja+X6m09H?=
 =?us-ascii?Q?1GSsY8cNPwL5/bhfPqOODe+jkwnJ0ELCPfD9EG8kqulA2mISLuyI6e0xAlcL?=
 =?us-ascii?Q?MR5vCgSCmZjcGa1NiMQgr1aLV122JXq5OB2InHiDnJ53oX+Wb3l90i87PPYV?=
 =?us-ascii?Q?UsIM7DMjZJ0fIDD0q8duc0aTqjVdsnydGs1z9N7Ka8uFXq73WeLTNjY4Onxa?=
 =?us-ascii?Q?Y3djJ7Foqyh1rbsrzbYVtsLcHZByA/dE06xWMmeFqhqHmLao9Gn8eG3+j9Qm?=
 =?us-ascii?Q?OhjLHir1oZZpPf44iR+eVbVqojGWlyTfxgXk2Gpb5M40GcZXMDGj4OOMCq06?=
 =?us-ascii?Q?lafQ3xNn07HVF8QYCiLqTndqAJ6f2R07sRzYTy0n91EzD+ORynbTq9C6N89a?=
 =?us-ascii?Q?soVdof+Z371VHxY3Qsf8+zQG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e199b9e9-4afd-4377-7241-08d97d1875ed
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2021 15:57:06.4960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mcZdEx7FzhclTIUnSzh2W1CRzugQKfqxsOK2sryBbm4QseiuHQfPa8No9w9V5IBd
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5157
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Sep 19, 2021 at 02:38:30PM +0800, Liu Yi L wrote:
> This patch introduces a new interface (/dev/vfio/devices/$DEVICE) for
> userspace to directly open a vfio device w/o relying on container/group
> (/dev/vfio/$GROUP). Anything related to group is now hidden behind
> iommufd (more specifically in iommu core by this RFC) in a device-centric
> manner.
> 
> In case a device is exposed in both legacy and new interfaces (see next
> patch for how to decide it), this patch also ensures that when the device
> is already opened via one interface then the other one must be blocked.
> 
> Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio.c  | 228 +++++++++++++++++++++++++++++++++++++++----
>  include/linux/vfio.h |   2 +
>  2 files changed, 213 insertions(+), 17 deletions(-)

> +static int vfio_init_device_class(void)
> +{
> +	int ret;
> +
> +	mutex_init(&vfio.device_lock);
> +	idr_init(&vfio.device_idr);
> +
> +	/* /dev/vfio/devices/$DEVICE */
> +	vfio.device_class = class_create(THIS_MODULE, "vfio-device");
> +	if (IS_ERR(vfio.device_class))
> +		return PTR_ERR(vfio.device_class);
> +
> +	vfio.device_class->devnode = vfio_device_devnode;
> +
> +	ret = alloc_chrdev_region(&vfio.device_devt, 0, MINORMASK + 1, "vfio-device");
> +	if (ret)
> +		goto err_alloc_chrdev;
> +
> +	cdev_init(&vfio.device_cdev, &vfio_device_fops);
> +	ret = cdev_add(&vfio.device_cdev, vfio.device_devt, MINORMASK + 1);
> +	if (ret)
> +		goto err_cdev_add;

Huh? This is not how cdevs are used. This patch needs rewriting.

The struct vfio_device should gain a 'struct device' and 'struct cdev'
as non-pointer members

vfio register path should end up doing cdev_device_add() for each
vfio_device

vfio_unregister path should do cdev_device_del()

No idr should be needed, an ida is used to allocate minor numbers

The struct device release function should trigger a kfree which
requires some reworking of the callers

vfio_init_group_dev() should do a device_initialize()
vfio_uninit_group_dev() should do a device_put()

The opened atomic is aweful. A newly created fd should start in a
state where it has a disabled fops

The only thing the disabled fops can do is register the device to the
iommu fd. When successfully registered the device gets the normal fops.

The registration steps should be done under a normal lock inside the
vfio_device. If a vfio_device is already registered then further
registration should fail.

Getting the device fd via the group fd triggers the same sequence as
above.

Jason
