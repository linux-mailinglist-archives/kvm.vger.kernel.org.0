Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3053415440
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 01:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238564AbhIVXxo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 19:53:44 -0400
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:7425
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230412AbhIVXxn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 19:53:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JNDYd+c77vVZ9GXwDv1iRJx4shH9P/pdp6VTBAQAK7M6vMQsrloLT/bcpcjzeU5l8gZ2ekmSUpNVXiZRt1jUVNVaaBzlNBkjir+kB260NFZIjAxcGg99ctDpC/toaD7XRjFXgv2FwMGmYVYH52ks2i2N2PxwbBqlHum9B60djSUEnNRqNaqCgZv0lYX6SV+lO/5rB/sGb7Lfs5jUAM+Z3PECLx7GK15lKSjDF5/wqsuCFu8/XwdjLDPQiG0rstomjMAo3Jrld7UnA04var1ZIfHodLssEXeCXCoTSVbZpx9iRxaII96pMKh+D0iyysSoyd0OrWrKV437zwAccp9qSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=atJ18C3ejINjt6KryKzxDGMlgHXd1wicRB6JioNkDAE=;
 b=UKNvNMN/0QdkHHGRXbCACuS8qjBM+tga6x6lDuPza7qXT00qXhv4S3t22M6bg6W51bRtyz4/CRbiPmyde0jRxDLyIz4gYmYzK+mdPO43nonDa3qhc9UGTJGb/kPl2zGFVSzGp++K1PYF+NmUjIIDoLxJ4f613cmPPUvXPmAy+npxKoA3oUCWMBqphpRQI39Iezd+RGANEs7NTozh//uoJANXS6+Hwf9ycQ6iMm5D0+5dON7lJsOSoXYaGrcNGBEvy3oJPhwRPuDzLSY3PVzLiEgrYOZcfFvAHKl4xvH9oM5WV6SHObQwc/Hswb6XSTV9afL4ZQoVlBUz1Nf7Cq6cQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=atJ18C3ejINjt6KryKzxDGMlgHXd1wicRB6JioNkDAE=;
 b=mpfKxlD0CqWgaec24XPVE+NdHNH9zu1yUmeySlqCw8wVfMMa1nhw1Z3rRBMH5jCoV4KpNWG5lad6thkLzNDXStgPUkGQpNUz7tmsJqd7GYVNLx9xyYbf/FMsKuG5IC4AUEjXC5z14agpo9OzAYJHOwLOGHJGUBs827o+J1Bu2RFog5sn6jOkAeliA/0z/nE6ovFxQh2TCNLYjqZaj/1GhlDRTSyy8IpGJxaVokTso34arLzocYy88xBdu4TTuekiTKsEnp5L9f5MSLdY5vq9lLklwsgzvnwg4h9w3eE5gbuvSn3hgaw9r5nkRXp6DyjO1QOIYLo+vAtZ0JEPxDzDlA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5174.namprd12.prod.outlook.com (2603:10b6:208:31c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 23:52:09 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 23:52:09 +0000
Date:   Wed, 22 Sep 2021 20:52:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "hch@lst.de" <hch@lst.de>,
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
Subject: Re: [RFC 03/20] vfio: Add vfio_[un]register_device()
Message-ID: <20210922235208.GC964074@nvidia.com>
References: <20210919063848.1476776-4-yi.l.liu@intel.com>
 <20210921160108.GO327412@nvidia.com>
 <BN9PR11MB5433D4590BA725C79196E0248CA19@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922005337.GC327412@nvidia.com>
 <BN9PR11MB54338D108AF5A87614717EF98CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922122252.GG327412@nvidia.com>
 <20210922141036.5cd46b2b.alex.williamson@redhat.com>
 <BN9PR11MB543366158EA87572902EFF5E8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922164506.66976218.alex.williamson@redhat.com>
 <BL1PR11MB5429B107D90E3CDE21139CE98CA29@BL1PR11MB5429.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB5429B107D90E3CDE21139CE98CA29@BL1PR11MB5429.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR05CA0020.namprd05.prod.outlook.com
 (2603:10b6:208:91::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR05CA0020.namprd05.prod.outlook.com (2603:10b6:208:91::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.7 via Frontend Transport; Wed, 22 Sep 2021 23:52:08 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mTC24-004BpB-1C; Wed, 22 Sep 2021 20:52:08 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04beffb8-217e-4103-5023-08d97e23fd4e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5174:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5174E85F4C5DE0A0C0D19F11C2A29@BL1PR12MB5174.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Rn191CBPE6VDowXpqt3SqrsrVRAm5cZu5RfAwhBUGYYP6CaQIxnhp265nlB7KPk1FKUXCLIIN1MyXJ+FM4F+54tVWOiqayAjqLZIeFyeqSQwRJ4hlwiHA5XGJMrJmwZhQD763UPftsB7/ZTnyWYa7sGKD29q0jLkKgoSWntFaaM1NOuNDzDy+iCbFzeyGdH5tl1ndqo+QrSUBDat1L31H+JfL1DodNOiRRN9r5vhaj7xI1JkjaSxLcdTCm1GbtBmtPHoXvm/YQIq34YjnuMgEtQ/7ayQctaOfe6GcEd1iSlcFprUjdaUFC75prWQMBQiWTuuIaGZtq+o5aKw52qx8snhHAl/iyCoZVhASpuGCY8EhiibwFDp3sVU3Da+puCxn971qiLZu6WBTwMjZF8yk5UEORBkOlO0cPdNYGQGc/EY9Rv23nMy41U/ZyrdR6ltQmrl7DvnTK+XFUIUFNfqr59DkF/+VH4+yFPNww4lry0J6ZrgLNW23kCXrA9Sj41LnKicUgRLzX4ZWYLHL8PiVTMUFusYwjmXezn4V8RCsqnMU08rgrbkzzUWxJ57IbqKWQ0C7xeLFgM2MirWU4EZDAfEAKoAKbLV46kqztDlWE7nIivL+evSDndrHpFswbsExGmbwFrRekrfXTcOOL2jyhOskpy9vtV7QJwBWKzfglbkwkSicJeZLnXKIxeZzS16
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66476007)(8676002)(86362001)(2906002)(4744005)(66556008)(8936002)(186003)(5660300002)(26005)(2616005)(316002)(7416002)(6916009)(426003)(54906003)(36756003)(9786002)(9746002)(33656002)(66946007)(1076003)(107886003)(38100700002)(508600001)(4326008)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5J9KnmbvaN/a13q3pKoojadrgpMAQ9ZsmlzMnFIDTXVJ4BufjJV0hKn9YH5w?=
 =?us-ascii?Q?Rh98Nq/SLsbgKWNImKDvMP5PJtWTCT2oSOM7sMvU6WTpQ8ODhgTS+t9Ry7kn?=
 =?us-ascii?Q?KdS5ly9vHJonQuGjJKSERjsRMUabFPv/qnxsKS03do2y44uGXdLhXB5BY+3a?=
 =?us-ascii?Q?wzPajnt3NrBYRHjHF2QeHl8GhWatGghzDZJ5MAj8hYHYwk9bE9B+GiQ2HSt7?=
 =?us-ascii?Q?CJXDP1mUvPHV44RUQPl4NTZLWgbz97WaXcroDZe2n1EhqyMU3JRz6i98lKiU?=
 =?us-ascii?Q?xQQoafva9sGtcowk1sJjp3I7VB9KJbh0XdQih1ckmLddyzMfRyt4+73G8KkQ?=
 =?us-ascii?Q?bCfnFQRfp6vhZg0cQaAHtfoUlS/ECQgF8vxViq+gBymcbzsfwZt8uZCbZhAz?=
 =?us-ascii?Q?Ut2dY4E0gz7rMIBti3GvtV1F2bSrZn6vThUafEF4d57ja86r+5g41tjQA1H/?=
 =?us-ascii?Q?acb2LGhYwgK8AAay/6Dgg+PZo/VYCfqu/6iz6nhQro9pIOZGT+cCFoPSNyIa?=
 =?us-ascii?Q?4x79HxTMNk1bEOJQ3Yki6VjpnOfslrmUrY+svm5JLSZ19URgXlygr8KrfVWu?=
 =?us-ascii?Q?vPTPiDQGuzQMIM/nOpe5AefsvxI9oRtdKR6cFKoLBHgBhHr/IPz8SOqXN7pd?=
 =?us-ascii?Q?7pW07aQdgLiZPGrFlirx/HIhNYVoY2ieP6EmwLyb/cjqwDJzZSQWgulXVWs/?=
 =?us-ascii?Q?o/v2n+My+vrHT2TH1BzljCA9WLsycju7/pEn22+fqDETBUtPOMZNzojBUzet?=
 =?us-ascii?Q?0uDR5QpduvStbly2fEueymMxf+q9sRwuzPDNscAEYJleI6JLx/Wlo296fZzd?=
 =?us-ascii?Q?+8b8iqyVH4W6t/eh4qohu168r30PM4M0gI4E6+GCgXDq+79zb1AoJjAF0ohG?=
 =?us-ascii?Q?+qQvycVkoblO5imevKkPjx/ltRoNQ+DKRGSZ8SZeowxpitdh5X0GnPudNbk4?=
 =?us-ascii?Q?MIUbpdC9rhrNEkDEUi5hJmIkRfEG7hChVSMa97bDLln82zN2eaG+hi6i3Mny?=
 =?us-ascii?Q?Z7tvXEfEmiUGzUDMPxQAA1sgewkQgTglA17KQlt8T40j9pudqPy0THh8J9Hw?=
 =?us-ascii?Q?mIhPQBoehaUBEFEGwCORgVGSExVF2bZC1/WTvcgMmdrGSbyBCV7KpbPqJ/A7?=
 =?us-ascii?Q?yznRR8vcs/CqL+gAUUgJrH0oCHxUAcwfadLlDU3tCJ8cMRLVbEK8brFhFf2b?=
 =?us-ascii?Q?/tjKeofPAndnDliQmNGkKuE9w5kuG5foCLiTfKoEl3Qcx+lgKYam3z9NfUDY?=
 =?us-ascii?Q?LfQUUCwefy4V+tRYNQHe/HE8ORu2Q6lhkGPln4fGT9RHpDgOr7W+YaQ44hNU?=
 =?us-ascii?Q?RGjsXbNhFxTOpIptJJu35Jiq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04beffb8-217e-4103-5023-08d97e23fd4e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 23:52:09.1037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9Z49L+KopVcoPyfdWhzv1yEJfNwUmtshlEOSSicq2sdnoGMjSkcNEp9Fah7w0wIa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5174
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 11:45:33PM +0000, Tian, Kevin wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>

> btw I realized another related piece regarding to the new layout that
> Jason suggested, which have sys device node include a link to the vfio
> devnode:
> 
> 	/sys/bus/pci/devices/DDDD:BB:DD.F/vfio/vfioX/dev
> 
> This for sure requires specific vfio driver support to get the link
> established.

It doesn't. Just set the parent device of the vfio_device's struct
device to the physical struct device that vfio is already tracking -
ie the struct device providing the IOMMU. The driver core takes care
of everything else.

Jason
