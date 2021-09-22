Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB961414B70
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235848AbhIVOMd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:12:33 -0400
Received: from mail-dm6nam10on2054.outbound.protection.outlook.com ([40.107.93.54]:28032
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233005AbhIVOMc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:12:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HyIgHcxmLlXVCYL1oOY12a82ay80riaL8DeBcTDWOk6ACzRUCU580DScj/l8R1pnonOpktJ7sESl07mcOHnWlLs+v/QeamgAnpsxkzlN/1xfrwtuWKe0U6ER4ldTlskoHQnOBUCuuBTxvwnyK6nvdgL/E9bRbqBszNcID2P4JExw8pEpvzsEwtorPiuhZo+mKgfPRU8tvmFbfSQm5RMrJ8CBmEFj15ceJlvpm9LfrzTVT0OvRqWfIzTsCnT6dSCco8YGyLJUEy6toWO/KxiqgHvu0CA6qXksQXskfqDC2loe1eEfC/FquGZFgg+tNkifwZzoCgRn2uYx2ydFuJ/nMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=AUE5Tzoh0h7VQ/yrK6yDIjtVHFABy9iMXBBcwxg1AO0=;
 b=Ma1GN3Q5wPtaGL/T64K/gxgvpOJcS4A4C6L8S6qAO2qU3NXtRRFM36s2ji/Oy84BOdBjieAgeGD46gyxqrEm4Nkmc5ub4EcYxSIAetNQs/J3UXbxh5j8FhTdqPNFBaddL4ThARlqNSRLwgYB1iA9vCM1I8MgLNm7GZq+Wp4Czna3RG1EAqBNefDdFyGHfdonAj0q2I24s6MQsWBjZlyqdtlV03AhBTpNltwWaHv48N0YctY4ItNj6jBeOrmb/sFt3st2xutQZ+F6m5FzwKvmuBFgX9r8GbVJ8qAWnNEKXaPifZVx03x4UXytVfPrQ1YE2+BBNmDc3M+B9ufKz1qjHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUE5Tzoh0h7VQ/yrK6yDIjtVHFABy9iMXBBcwxg1AO0=;
 b=iWN3DtDkTYr7Hwgo9RYNSq18U8DM3UdfSzq5jNhjGWtqKQyd0hjMrMaNHZS8bSCc7p97L1Ih9zNQbs7kwFv2A6PP5XSkHKknSX4gK7MpNYDEsq60DUskmo08WyP4BxHLfAKbrBGmD+5jRkO+TnksiLN3X0EACbTerD29tQdSUAu6GiVTcSHv73qWCZc0StLH05VfmsbJMEBzfS7Lf2dZQWwMVflrsW+l3SRpfp4SdpqHekQ0iuh+hzozUi9cgdRjlYjFUqRXIPZBVZHfQ1v5QO/CD5R2t81SCaYx9WZ1leggksudQ8gkRQEbz5tVTbgeP2fSjg7KmI7fSAQ3vIVj5g==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5238.namprd12.prod.outlook.com (2603:10b6:208:31e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 14:11:00 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 14:11:01 +0000
Date:   Wed, 22 Sep 2021 11:10:59 -0300
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
Subject: Re: [RFC 01/20] iommu/iommufd: Add /dev/iommu core
Message-ID: <20210922141059.GU327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-2-yi.l.liu@intel.com>
 <20210921154138.GM327412@nvidia.com>
 <BN9PR11MB543344B31D1AC7C8BC054E268CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210922124034.GJ327412@nvidia.com>
 <BN9PR11MB543342C7757E85E9C41733B48CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543342C7757E85E9C41733B48CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL0PR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:208:2d::14) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL0PR03CA0001.namprd03.prod.outlook.com (2603:10b6:208:2d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 14:11:00 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT2xf-003yZY-OR; Wed, 22 Sep 2021 11:10:59 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3f839040-9821-4803-4eca-08d97dd2ce28
X-MS-TrafficTypeDiagnostic: BL1PR12MB5238:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5238A9F6FCC4151D3D0E4B26C2A29@BL1PR12MB5238.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LCGW+z7xD8knpI6lKe8S/6WGdlaGTj2+/fiwVKfC8ZfkGfTj6VRG+Yu8NVsJMAzD/qqH/+Kmw8F7Gg29sBKWEUq7e70x4Y73gT+id8mUttnOk2tLoSYsq7RGp8k9v7/OerFJ4N5ejI7dzqXrECqKXfQY3GdxvfPoq2NDq712RdUHjkH/HpUGXHXBBWppVESgS9bsVnHB6jTOr1dzGbv64/8MTm5dgVjHW657R1Nif0tlHGjMKMzUF+b1/wNiK/oPb+4X4hslP52HyIDi/TIq1KGzOV6C58BiitJ7AZfFoR30YPD3kS1wdYgj4Uzcct3/v35GrQ+eKGgHFyIOy4prQtzufsxYp4Smp5iJBu5kwC/egzYiruPIxCcMh/K5P+7IV67smTeLrhXLPmkRNh/JHdKCcisKsVWOP+QjJo2m/8e1lCrelZ1XJvDcDR6r7hvL3uWdkFCB7drrzEkvJD67wAcHq4yDdZ7UK7n5yP24S675ProNql1ythJCGiNslPH8xc1tobFxQOahLxhmilMFl9oy6i2h5tJ2dXDOIhRBGihX2FMeOiHHUrBJZlt4g7Xpt5ryhavxlmZ4fvLbxN0MGezDkIbjpsJ9iem2yaBhMprnnA9R7+8G9A1vSwAOAXiHruRnZvCpO95v+qUgCfM4VrxEHxPTLnL3Cp0SPErLf3Sl+dgxXVO4kdYxugSlIO6Q
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(107886003)(316002)(38100700002)(86362001)(83380400001)(8676002)(66946007)(36756003)(33656002)(66476007)(508600001)(66556008)(6916009)(1076003)(2616005)(26005)(186003)(5660300002)(8936002)(4326008)(9786002)(54906003)(7416002)(9746002)(2906002)(426003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Sv0Yg0qQYOKGhG526Pl1gVlWJn0SryZ6/7AyuaybTWftFxuNqYC5puLycER2?=
 =?us-ascii?Q?qno4JiRk/GAGZuXbLeX+NH7FEqj1fecv2z8Eg0WqTSzZDkkHCGrvt+FMiDQt?=
 =?us-ascii?Q?Izc6BA/+qTfa8brB8q1effOTDV3VbM9Sj8Boveyd34kDqjJw7CrZZS9zqDZH?=
 =?us-ascii?Q?4lTdbYt9CvRhqwCALLGd/GT17G8qcCA7FFykP43Mkobuir+4h8lq5qxSVMno?=
 =?us-ascii?Q?AQKLtrJnF31/r7NCr7KITnY6U6S2H8bIRDA5azuFsiOSndLsqtd/ctL3TGLd?=
 =?us-ascii?Q?gH49Mow3eET3hE4Gg36aCrjU3Ahfx69NGib1RKVykeX45YgHrCydtbG9IFn6?=
 =?us-ascii?Q?WtiJi1CdKjYnbtPE/4DfrVkJ2jUetJPVathuFc6JaImhAeELk4Wr4lknvNsv?=
 =?us-ascii?Q?MV/oJqwlsmjt278Brpal+DiL2QBTc6Po4oTpSUHoYDxy5L8a417T+wfUxd1F?=
 =?us-ascii?Q?GpXG914XU09w45lRO25NdDQ5cdcSttGNlZn3DlfEIIchH6SfuZCEJoEh/zFf?=
 =?us-ascii?Q?adbmTxV/Gnq4Eq2TDfvLbyy75XNuf5CKLjVB88+GGlpHrJacdcYC70wnWK5F?=
 =?us-ascii?Q?3jao+EgL7+x5jBQztgZeSDDgNkZ6L2ot/QWezX4g1TiNMAiwS4FODUwCLv0T?=
 =?us-ascii?Q?sP+wheSMoRR82YeYz83oimdgF/46IyLj25rV9vEw0C6qkR2GgIxEa8qOItEp?=
 =?us-ascii?Q?+/pOqIvL55bzDL7okA7FDwcElcP42awbOo/L+PajjbbY6olO9rOMYlz+KqFp?=
 =?us-ascii?Q?/GuyQcCY9Oo0GBQ0et1y3m1QIjWYWxzLPCtbSM0IPJPsnW7aYDAL8i+3SChl?=
 =?us-ascii?Q?xOjlpQWeBC96/YtBD0OFTKQmXRy2WTxohvuTiGRb8DZGYVdU8vIB7jiArejY?=
 =?us-ascii?Q?Kg/Z0nurjtHUnaom/OLt2r8E0/bbR89SZ4euhUne9siTivXQHM8MPgTqlPzZ?=
 =?us-ascii?Q?UlpwTWlzHlBOTjEy+XohtXE2piPELmZkbCxO3Xt5BHzYpgL4qwJe6xy5g4gP?=
 =?us-ascii?Q?Fv6UtSfjc5vYacsixsb9OatbFtT7J0vB9x8nFIesXVW2f0NEVC5RCf0J3/RU?=
 =?us-ascii?Q?VHVgUFI2r0+qQVM7ZmKSgVvZ+e+N+lD0MRmI0TkDJk5691SFMmDP3B1eH4sP?=
 =?us-ascii?Q?CLByKrTuut/tpOo8tfYTZ2TUBkEbjCbjsZAi1Ga4JkNEQmXwFBzCokbCSjoH?=
 =?us-ascii?Q?SrLYNJoBPLScsr2+btHYeB9k5GDuQqQWEu6EZcnTat1EXhd1w6snBF2lbntm?=
 =?us-ascii?Q?4oqmAYJZXsnbMxNJUFVfLZSxBN3n1Mmcqe/Wqz871m9DUg351Vge4+vOTy+c?=
 =?us-ascii?Q?azPrb9EwAcadFct1vH9tugVz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f839040-9821-4803-4eca-08d97dd2ce28
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 14:11:00.7935
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1szKhCTWWTg/v6yFaT78oq0NATLnRG+j8vhjp9kod8e3VAlmtnkMgF1vrFTGJ2D
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5238
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 01:59:39PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 8:41 PM
> > 
> > On Wed, Sep 22, 2021 at 01:51:03AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > Sent: Tuesday, September 21, 2021 11:42 PM
> > > >
> > > >  - Delete the iommufd_ctx->lock. Use RCU to protect load, erase/alloc
> > does
> > > >    not need locking (order it properly too, it is in the wrong order), and
> > > >    don't check for duplicate devices or dev_cookie duplication, that
> > > >    is user error and is harmless to the kernel.
> > > >
> > >
> > > I'm confused here. yes it's user error, but we check so many user errors
> > > and then return -EINVAL, -EBUSY, etc. Why is this one special?
> > 
> > Because it is expensive to calculate and forces a complicated locking
> > scheme into the kernel. Without this check you don't need the locking
> > that spans so much code, and simple RCU becomes acceptable.
> 
> In case of duplication the kernel just uses the first entry which matches
> the device when sending an event to userspace?

Sure

Jason
