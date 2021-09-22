Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55D24149E9
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhIVNAN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:00:13 -0400
Received: from mail-bn8nam11on2067.outbound.protection.outlook.com ([40.107.236.67]:23674
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229731AbhIVNAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 09:00:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DMUM0QxYS3jSZZSaGahA0qrm+y6FIvol+eXw57EPW9cNOyTQEmMn/+iPWRE0kaDiF8Au88Po/NAerMqslTjjQD83dtA0l3y3dgDZPpa/eveZ3lvyd57+HF+1FvASLffvZG9NVNCNwuMd+v4cybx+242cAEjkgPEPm4DMpKJnY2KYsaSdPLmVj4EVys618NotPVKndLrVQZr7UjOYsj0x3qDiatRJ+TfqTiJhn+a8QdFe0fXa79EcgmQEEX+HY5AdtuCOFshcqheN/Sc8JceACCBZPsxu7qpvHLwylQROhYp2tPM4Igz/PT2ETxqi5jraDHT/z8HjjRuRcRWLj8cxfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=aTh8kRlmeD+akXL2PP+yoKqHM+iVeNJI+6pJLZQQyc4=;
 b=fkpou8ETSCsrMPiwWPydEx3RjZY0C4oZY/22gRYW4Yrs4MDr3LNTV2b0azOQb9jusDlU7TXcT7SsrxTMyEWq9khin2x3h21uqlGNm+VhgIdSDSpR8lm5sLh/+YCuwe27rgU1GiQYjUQX1l45jkraL+euFZSnR2ASHRr9tlNUX/7spEyXxEdg7UMRILthEJAD/h/Mt4xmp4AEr/0o+8Tp0KYcciTnHpn+t4S7QNu8JrdmuG3xzR/nEQe316OilZeAZfcuGf2jOACb/kVu2AP6NnKV+uASy+mJkXwymTE07fnXJqNpdRRn7UnzSlK/H+b9/PG17DbcAyG+YeLCV4HGWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aTh8kRlmeD+akXL2PP+yoKqHM+iVeNJI+6pJLZQQyc4=;
 b=lDCWr+PbU7riPP5+7Uhk10U0gpIZiLZ0SFiRFxHuHoBVwRx2kwHXUm/m/BfDSmr9uOd1TuTz+fc7gqcgVDvXexXeU0EIJpWKojFgI7/m2QA9JtKpS7BrfWkpof1kCUygSQPUmPxDGsM7nV9wFXUkVCUyclngKfNggYm5/tdJ1GGMGQBEAKV+l0agbjsLBeAGEibCxIqov98wjIKdXkQCH/TYv7jZEnRwvENmItijEqA4hm17zEKQW27KO/yTq2OzslsCtrwxbQVjBKCj7ZiJ8oi2IqFEBsXWfYCQXpz9aE+ArYshy3Qu6CaOPYP6lsNtd6FjXONzw79WwVF7/ZblbA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5349.namprd12.prod.outlook.com (2603:10b6:208:31f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 12:58:34 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 12:58:35 +0000
Date:   Wed, 22 Sep 2021 09:58:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
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
Subject: Re: [RFC 15/20] vfio/pci: Add VFIO_DEVICE_[DE]ATTACH_IOASID
Message-ID: <20210922125833.GO327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-16-yi.l.liu@intel.com>
 <20210921180417.GZ327412@nvidia.com>
 <BN9PR11MB543319F29F0260EBE2A9F3478CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543319F29F0260EBE2A9F3478CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0062.prod.exchangelabs.com (2603:10b6:208:23f::31)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0062.prod.exchangelabs.com (2603:10b6:208:23f::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16 via Frontend Transport; Wed, 22 Sep 2021 12:58:34 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT1pZ-003xJf-TI; Wed, 22 Sep 2021 09:58:33 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b3c258f-53ca-494a-48e1-08d97dc8afd3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5349:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5349920DE6EB55FFAD428819C2A29@BL1PR12MB5349.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EMXgv8NBb5KS3iqJn1zP4MJzd0EhtdIspkJDQUxZu6IkIXO+FuTEY36X4LOZMfWEbVzEcjoaUUqcSe5F2TPTwSYUtHDiOwbdV/eozcHllHLcduJ59+oDrpPtEZwq/3UOoOPLk7EYR4BYiQCMc1NRypwhL1odxu5qIQe6jMdUgtxa9wgMVvVdRAFu+iglI+HFpIFqdRBV3PZgSlRHF09jsAnw83LeeldkzpVa0LcnNQEIJYTVLILxz4n+auLmTzFu7POcCnezGLzrY07Wy+/SWKlrBRQnz5i1hzxR6ggppfZUdlMLDbrIzcgHM9F09n0sJ0vSw0kEKBTq4npkiVsbOPLSU9etzhYMX8f41bacsroRDSphBKXDdFDkJ1/eV5N0JD5hFNwEUOrya5NgPpxPXF4m8hrnTWh/WYfWfx/jVDRasVVTjs5zGDXmlYbtrQWQE+YtNFSJMjjsndq6lfRcv1b+3oLN0MMdDVxdzCqyhB4G2osQUaaEKiPgX31Yf7Fn9bhXVZeD6AQfzpM+MjwI+lT7Z8TI4ExrR96stJpYX4SvzV8FLv/pajuzGzQHV8yGiZSQYhXyLwq6IZoIlCXVMtWwCzU6wFS3kVV0wZuUQeMs2de0ddnGO85EySnYDi+echuGl3qOlf2LaaiJxmCLJUDj8oaCWyi+V9m3snBzhSJTglYSug8sT1y3dsMA1xgV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(38100700002)(86362001)(6916009)(2906002)(66946007)(36756003)(83380400001)(9786002)(26005)(316002)(508600001)(107886003)(9746002)(66556008)(426003)(2616005)(8936002)(8676002)(5660300002)(54906003)(33656002)(186003)(66476007)(4326008)(1076003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WikSZ4XZsjN4zOoaIL9NXpMjzRam1dSuvXP0Hvwrf1Ue3Z3yJvCByML0Bo3T?=
 =?us-ascii?Q?VHBwvDVz6Y4E3TNbMUdrgqjn2KAIGjM3TSU5+QcgxkpxT32Qneaekggy36jy?=
 =?us-ascii?Q?1GZnsxtieXUL7StrxDrOXp3J66a1dF5pJIhJwYKqc/rfwUMKfPkofWrGYiTt?=
 =?us-ascii?Q?wn9U0Q8+6IoNNMIaD15nce4Q1aOmwzlFqFT9xqoyNrqUejDpCVJq4f9Q4+vK?=
 =?us-ascii?Q?UbWJNcqR/qkT99rVRCw0DV1nRuMclvhIc1n9trlIfB6DCeNe6v+7O6OKekgA?=
 =?us-ascii?Q?8yOaluuCV8S4OpWFrfLTvajPJH6tc2dfVQJr53sT4EgQF8vb1cQUinHoiTEz?=
 =?us-ascii?Q?zVvu7qLUAzEyQQHaq78YmdcKkCu4Sg3k60xADUv+ybTI8NqhkjxfZW0HgJ40?=
 =?us-ascii?Q?8xDTdL4V0VG5BQsrvze4LHW0En+UakjckW6OjI14K/99QF8lgEduxsbaN1Ez?=
 =?us-ascii?Q?TPXuqyVvYhYPMui7ZO+rFhMowQzXYZQPVuUOA5HcPa2l1eUXCH8hF8yUTTHA?=
 =?us-ascii?Q?kbfDquKGIe+FgDFMcmA/rz/cHMgvIv1v69n4QYFyNkRy2mZv7Z9As/Rz3P1H?=
 =?us-ascii?Q?4UhS8lt9abKFkrHfC2o2eLgej0aC4QhI3AWMeGlb2KX8OLdSGKDCpedbJ9nh?=
 =?us-ascii?Q?5s9l+Oze7L814ubwySavktbh/xYoHdMk3T8f/h27AsjLXcggpYKTuDKRn/L3?=
 =?us-ascii?Q?4F1pUQH9g6IWCcFmYhuve2rg4Xtoye8yQ7VWgksYhmBD7jv5AEJwGVWFwsPR?=
 =?us-ascii?Q?6kbWjW3M3IRXuSXaN11pxpOm7/Zbt4IjZ9pDNRPIu7R+1uVXESHz+yQm6rRN?=
 =?us-ascii?Q?w1MfAO3U7r8KOHAXg/sgWAliuUE2k+g9ij4Lk793yg7bN74Q0c3NdTS8JdKM?=
 =?us-ascii?Q?oRz9lwTenVpm4XKj79xKgB4aaGCTLyVEkTun9MUuEnYtbR06gWfuZ/ZQORHv?=
 =?us-ascii?Q?SPjtXJSBYVeUyZlQq+U+DdIncdIsjqjRMUtUbRgn5FSfqphz0ptBool28jNw?=
 =?us-ascii?Q?+n1TXZaBNFuzSrpwblsQA2raMRQeiDcd3AH40cdgIyz+1ZtSOdL7PvJmgZVc?=
 =?us-ascii?Q?VRa+bzwxLUN4f6mGmyZ6OqPz2WDFAbQsWY8BpEhoNbGu0mEsxoDGln2bcGYG?=
 =?us-ascii?Q?Pjfl0+JwjLchj6cdtYalgrLM4P16X8EpTQtRb/2ePIhIP001EdqwOICWp5wV?=
 =?us-ascii?Q?u60fFY75e7keO+A/5swBBtdqdWcKgSCDa8/0l6ZK8SsTOwVKQvK3z15GtUiq?=
 =?us-ascii?Q?9LX+IyX+DH7+VF5kiLDdrRhRvovLDaacJ65yesRojDbiZS+m/OYRPiM0APh+?=
 =?us-ascii?Q?QaBPTQCpHdunc8QIvjwcdlxh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b3c258f-53ca-494a-48e1-08d97dc8afd3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:58:34.9065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ssr9+Z5DgeVLj6LDyl7czXlI6VRfbYT3Q4A8w74dh0c8GeXMs3gRiD2d0yH91dlV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5349
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 03:56:18AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 2:04 AM
> > 
> > On Sun, Sep 19, 2021 at 02:38:43PM +0800, Liu Yi L wrote:
> > > This patch adds interface for userspace to attach device to specified
> > > IOASID.
> > >
> > > Note:
> > > One device can only be attached to one IOASID in this version. This is
> > > on par with what vfio provides today. In the future this restriction can
> > > be relaxed when multiple I/O address spaces are supported per device
> > 
> > ?? In VFIO the container is the IOS and the container can be shared
> > with multiple devices. This needs to start at about the same
> > functionality.
> 
> a device can be only attached to one container. One container can be
> shared by multiple devices.
> 
> a device can be only attached to one IOASID. One IOASID can be shared
> by multiple devices.
> 
> it does start at the same functionality.
> 
> > 
> > > +	} else if (cmd == VFIO_DEVICE_ATTACH_IOASID) {
> > 
> > This should be in the core code, right? There is nothing PCI specific
> > here.
> > 
> 
> but if you insist on a pci-wrapper attach function, we still need something
> here (e.g. with .attach_ioasid() callback)?

I would like to stop adding ioctls to this switch, the core code
should decode the ioctl and call an per-ioctl op like every other
subsystem does..

If you do that then you could have an op

 .attach_ioasid = vfio_full_device_attach,

And that is it for driver changes.

Every driver that use type1 today should be updated to have the above
line and will work with iommufd. mdevs will not be updated and won't
work.

Jason
