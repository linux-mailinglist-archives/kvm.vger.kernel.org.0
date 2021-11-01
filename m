Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73ADE441B51
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 13:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhKAMwv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 08:52:51 -0400
Received: from mail-bn8nam08on2054.outbound.protection.outlook.com ([40.107.100.54]:60742
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232507AbhKAMwu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Nov 2021 08:52:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qo6X3KnmVM1rSXnPs3Aj0VKmAnLuIQpMvx+GxbgyR6QjHxeB+wdLo8UCtW8XXljJ/qG7LWPOHl2sI4vL7NHNj4FQBbNBMONyaUS7RDHbKoKCZLh5CBLejoWUX9D/2x4p8hM0hxCDb+Wv90I1rNgqdYtQLx9vd4ELqblmph2jGKDVLBfghtH0RXJjf+hsdXzIxcmkty22FpnSitK92PTJKS3xNk3ylUjLCuK0evZ8DMAeHKrtDS6qwMrGbuULt0JOD7G/cMBqclzB9kVpFArD80Dh0Dn2x06QiYMjAoLGzrnMRj3CrGYnN5jYaB3WyggPHivnVz6p8bpmlkjdh/Uqhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yt9URuhW/GvLJXp0GNfj+SuBk/2gzRu0efBf2GpG2Jk=;
 b=YVrLymaZSE5wEUiFu126mN3GXi6ouXBETcKoLMNXJk5IF4p33Vr319VgEAlQSvwp1ZKWkCL9RXJWo8nFTtxn32NqK/OaSW4hyHWwnfWG/ABd57+YlmG62sV1mg9YuDwpDAG4sPMT76JwyfTVdPNCW/Uin3ylkxyaXZzNW2tIZeHyudnV8mImpWiaa76Z9H+KM61yKXy4XvxxtoA6QIEornD3sIdjAkOrkMYtzt36pdihl4EUMWH9o0dwYmN2n6Dz0hKWorTw6AU3ER78Ggsd3J+wu/vqke+OHRwE65rv4atjbIN/SSYUkCmBezSq616vFrUZ4ppCrraaDjnJlAGQ1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yt9URuhW/GvLJXp0GNfj+SuBk/2gzRu0efBf2GpG2Jk=;
 b=J24u4d9pHphFve0ZBSAAMJefiZ5R298+a0/9DEzwQ0iZODrt9cDlpBw57CTFKIYpYveAkJWSPa9XiaJvGtZ7effX/7RzHK6Asb8eGp9dlOf92IGURdKtCxYzQA6nSsRKxrI8KhGGmEPvXT6+99yCqujULE4dmiW6xUs5E9rIcrudz78B6x+5uyOZHji34C54jwbYV/JgaDtVhgPbHeFNferRpqYuJ6NBamVOxb11gSkFfxZpQCgKxMPEmLTwTHqsenHlNQ8dVgUxyK1h7rogVnCOcFzXQhx98ukmuOOg6sSpZiOondkjv749OB1ooOo8IBhq7Lle2XfObV7niW36Wg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5127.namprd12.prod.outlook.com (2603:10b6:208:31b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Mon, 1 Nov
 2021 12:50:14 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4649.019; Mon, 1 Nov 2021
 12:50:14 +0000
Date:   Mon, 1 Nov 2021 09:50:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 02/20] vfio: Add device class for /dev/vfio/devices
Message-ID: <20211101125013.GL2744544@nvidia.com>
References: <PH0PR11MB56583D477B3977D92C2C1ADDC3839@PH0PR11MB5658.namprd11.prod.outlook.com>
 <20211025125309.GT2744544@nvidia.com>
 <PH0PR11MB56586D2EC89F282C915AF18DC3879@PH0PR11MB5658.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB56586D2EC89F282C915AF18DC3879@PH0PR11MB5658.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR02CA0119.namprd02.prod.outlook.com
 (2603:10b6:208:35::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR02CA0119.namprd02.prod.outlook.com (2603:10b6:208:35::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.14 via Frontend Transport; Mon, 1 Nov 2021 12:50:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mhWlR-004UCg-C9; Mon, 01 Nov 2021 09:50:13 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bef42638-0698-4caf-8fb7-08d99d362617
X-MS-TrafficTypeDiagnostic: BL1PR12MB5127:
X-Microsoft-Antispam-PRVS: <BL1PR12MB51277C40C3F8AAC40893664AC28A9@BL1PR12MB5127.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0QuMYZNy1Ici932E9b0mKvPGX8hIP4Y7QgWZlnXMsyC0z3xFliGD3Zp2J0rTN8XSdU9Abq4CrTt53KoRrIcBIfeEXrK9F7mg4eVSRcPuCheEsy7M51gwS5MoldYQbbOg28kBUE1jgBmBAleu51lmu0rp/Yy+FSGIrb4BRVH+tbBs2cmoAtO1tKb9s2yNsaQKmITzt6ExkEKdZkAQy+SCZqI3i1qN9I0e1NOYdbizgQ8iddnfLU0mGH5OAo1XSz+kw7s1SfrCEJ8x/stQ18jF5biR/0l6LJMAP4xB0stYou/57Ajp7HDEJRgD4KH0Y9hHSVX964ollBeZNf+ojATIojzhfgdxTUK+tJffQ3OE4ZFqEUUKk+yL+HthGcy+UHVghrVdqs9Z+aC9vnkMKqWJ/yA6bH7n7Yxg9jqm7PyMsm+qAnQp0iDPMpCVr8aRiWF+NEMXY2aEkYgOQEH6tUZhDUFmTbLXsAU1skGuespPTcUkW2oacDRCigaOxSyd4d63ipJ4s46Vty46u/gnhV2nl6MzJm1Z2zXhO4ei55rN1SbgO3TPwuMu+zsWBeklzK+F4Lm8Zs0n1XfNguwuBbNsfVvM7OgsTz2bmo3pU1SSbiv+Rj8L7c+hX0VUcOah21OzAt4Z0NsIF9Bcvy+C/ddKsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(66476007)(6916009)(66946007)(26005)(54906003)(508600001)(2616005)(316002)(186003)(66556008)(86362001)(2906002)(9746002)(83380400001)(7416002)(107886003)(1076003)(9786002)(8936002)(4326008)(8676002)(38100700002)(426003)(36756003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rz1sbf37qcHz5M/N1BDUI+Zr2dpe+HEbc9Ho7HGj24WOAH8N3DSopRgVBlei?=
 =?us-ascii?Q?RqH/OiQ3MNPEcO2jkm8UOQGXcLY8RyejdZy9hNoawhVZ1IHAIz7gQ4AaY9sY?=
 =?us-ascii?Q?QrlNbirb0hxZLpD6AVgUoQGkzpE70f4wzNdprSsT9IS5ogQHR8hoHMpX/Afp?=
 =?us-ascii?Q?aSDXwEdinkGr93nSwFX5M8gOD7QTzo0n6bXKXebQ0/xo/zKtVEmS7Rc+Ni9h?=
 =?us-ascii?Q?ZHfvqK5bznM0eZBInWMlXiCneHLaEE8FtofYyukV0UShFrsSLfWFfnfF+har?=
 =?us-ascii?Q?1RLA8FJ+EzXbtXSehwW4nRLyRI4cfZzYnFCKRQqS1y8LA9m3D19hIpT4TBWN?=
 =?us-ascii?Q?R2BsfpYoL546TK4C+JcsX/ggjfFQASUWJgSYplGQhc1v8dCgz34tOpym5dVq?=
 =?us-ascii?Q?VJSf93k44fC4pxA+QW1THAMEV3r5thne7/VLiP1LwzPRpdtRgTpS6jRiJfDx?=
 =?us-ascii?Q?PfxCX7JFpYKqUJHla50iqTvHbmqOZth9Qql9b9+wDZ/ztTge3JSUSXNgHY/p?=
 =?us-ascii?Q?549PG+WECzq0Ew1QalXqovweK9NhQi6Hfbxr/lVDkc/dil/J+XLsLGO6RAUq?=
 =?us-ascii?Q?LfuHRBC78YDAPJ8m1PDWHixTEBzhub1VXE6yqfqgNTjw/u09EfBN9LsICEEH?=
 =?us-ascii?Q?KbAY3rv8+SwWoQS+ALt3sb8qZ8TDWmQSCnbN90mkpAHlFaAWJjW4Owl7uhlk?=
 =?us-ascii?Q?FsjUPWa8tPhfjWaLFSKyrauO9HEw1FLm7gWnKr29rIashcMU4reNn05DGrcm?=
 =?us-ascii?Q?KA2IRUAd55hfTwnhWkjVB5T/VeRKcG3bUbIYLMMNz76f+jdUFmttaPXp8/DL?=
 =?us-ascii?Q?BVspS15TzmkK5kBh+57008yVVVVg88hu9xTXFpfWQ0TK1yMfE/cuoULLltBG?=
 =?us-ascii?Q?RwG94ux/xy0KxX3c5uvWNq72B0QU3LVmsku6Ak9WrlsX4Gf7xXT3Timm+UHp?=
 =?us-ascii?Q?RRigsENLpHKnnLhMlNOgoS3QB2W3a1Y5SZrjzuO/o+rJRmfCNe8TAeDjGbM6?=
 =?us-ascii?Q?RlN3dHwP4RsHyug8TPo92Y3Yq6sgHM9Cjwq9QhmsDMKx9yMFq6R0UVH3icUx?=
 =?us-ascii?Q?S8SpCkHtejXz5SCzRl/BKmTZNUMO5sJ9eocfOg/K7bKUfUIw3hf4fMcskHvH?=
 =?us-ascii?Q?8aOPOwIst+IcTPMBFEzwWbbqXrWEusV11MFzMmWvqMowJiUy4eMFc4sCKVUa?=
 =?us-ascii?Q?ijJyGIYZlaNNXNH58Pw3f8+EymBuW0TwWRU6KD3VU46KhSBo+SqXrJW6f9fx?=
 =?us-ascii?Q?T6KeeeKXYdX25pLxZkjIXcpWr5dv6WQe+46CemKqS4kXuA6mZoxF1x+LONhW?=
 =?us-ascii?Q?AlnROK3lXlGPgu7Y6cOjOZKeORA+vpUQtNCCaZ7MjbmAJ6GXktu+r9hSPJPx?=
 =?us-ascii?Q?m21XP1nds7W7PBqyLQZuC2rxBVHIvk+vH12q7YykgU0uBkb9OiLkH6f7NCqb?=
 =?us-ascii?Q?J8dai7zoz64jOg8p4bge80KCIDqrQ0kCCAt0YVVX+1iGG68Hd8bE6+mipYUJ?=
 =?us-ascii?Q?O7o7hlk1+5vg39qvXJUKkZqPpKxANMv1ri7Rm1qPRHvtwwOGfGDFPemlFS7E?=
 =?us-ascii?Q?pK2f4/gf0HBq+F9P2h8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bef42638-0698-4caf-8fb7-08d99d362617
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Nov 2021 12:50:14.5436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3sHB65Cw47XuY6hf5aTGEWdqKp4UhLFi9OiPqOmL+cPtOaFtfSURHKOOt2t1jLvx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5127
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021 at 09:47:27AM +0000, Liu, Yi L wrote:
> Hi Jason,
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Monday, October 25, 2021 8:53 PM
> > 
> > On Mon, Oct 25, 2021 at 06:28:09AM +0000, Liu, Yi L wrote:
> > >    thanks for the guiding. will also refer to your vfio_group_cdev series.
> > >
> > >    Need to double confirm here. Not quite following on the kfree. Is
> > >    this kfree to free the vfio_device structure? But now the
> > >    vfio_device pointer is provided by callers (e.g. vfio-pci). Do
> > >    you want to let vfio core allocate the vfio_device struct and
> > >    return the pointer to callers?
> > 
> > There are several common patterns for this problem, two that would be
> > suitable:
> > 
> > - Require each driver to provide a release op inside vfio_device_ops
> >   that does the kfree. Have the core provide a struct device release
> >   op that calls this one. Keep the kalloc/kfree in the drivers
> 
> this way sees to suit the existing vfio registration manner listed
> below. right? 

Not really, most drivers are just doing kfree. The need for release
comes if the drivers are doing more stuff.

> But device drivers needs to do the kfree in the
> newly added release op instead of doing it on their own (e.g.
> doing kfree in remove).

Yes

> > struct ib_device *_ib_alloc_device(size_t size);
> > #define ib_alloc_device(drv_struct, member)                                    \
> >         container_of(_ib_alloc_device(sizeof(struct drv_struct) +              \
> >                                       BUILD_BUG_ON_ZERO(offsetof(              \
> >                                               struct drv_struct, member))),    \
> >                      struct drv_struct, member)
> > 
> 
> thanks for the example. If this way, still requires driver to provide
> a release op inside vfio_device_ops. right?

No, it would optional. It would contain the stuff the driver is doing
before kfree()

For instance mdev looks like the only driver that cares:

	vfio_uninit_group_dev(&mdev_state->vdev);
	kfree(mdev_state->pages);
	kfree(mdev_state->vconfig);
	kfree(mdev_state);

pages/vconfig would logically be in a release function

On the other hand ccw needs to rcu free the vfio_device, so that would
have to be global overhead with this api design.

Jason
