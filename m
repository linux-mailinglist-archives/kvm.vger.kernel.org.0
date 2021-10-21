Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DC06436E56
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 01:30:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhJUXc5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 19:32:57 -0400
Received: from mail-dm6nam11on2049.outbound.protection.outlook.com ([40.107.223.49]:44128
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230500AbhJUXc4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 19:32:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fum4tDPa1VT/rGg+tfoGL1loNbgm9CgYi3uk935uslLVvaESXvy8q8EhGpmV/EfNeLlPJEtz/2ysFMdK6hVqVl9IqRh2CzBqL2uRiG/AbVvoNiSqeVl10wAMtBALY4WIGfl1BKLOJdSpYGMt4m6GfQmJV9h2+bU5a8TlqNd6fjyCqjRf5BvOpScVoRpKPgmeEQWr9Nc5hbgO86QdwABMVCgD2+F0PIlsVSovBllYyIju4rkRo+EdYjhaiOQPVVUs6IPNTS03dwcZRYcvf24KXFNheO3jNPn/OPgOGlJhT2sfLArmha1vZpHXEPs/igpH080pNczCvC2sRtR9q3W6Wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qb+qT1otgVwBCUEVAurEzIqCU+Lv4PtlTuiWolugM+M=;
 b=N7JAtf6wJo6MRAfRoBy0ywh55KKvm6SG7oVZsLfn+i+NIpglTlGTimmTXUvcQ36y7JM1PmcmctiXxEQm7yvTM2TtvJ+iqu6QReGy048EL8/2s8V1hVk7SBaLjTBuHLPJYjcD0g5TCzAJBVV7l24NIpIHHhTYjGPMNpuGgcusgZQRwy6puZfhNzf0I0RPnBUhpawgnRL+jCJ4CBdWWGETXNjezamJBwZKf3hjRCmphxMfmemsZdFtBxAp3IklvQDSzjx8KNdqPmGAyWN/PQWZUVy6oo37aRhUTnRZBKIA5P0VBGbUMWNLIrmCslEa2uTzkRwztRCGeQRqOz2ad4QmEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qb+qT1otgVwBCUEVAurEzIqCU+Lv4PtlTuiWolugM+M=;
 b=qjSX1ZXRKi7RfIUgOWYZgcsgrwchtRFnUGYSnNDEbbWCyk9u6APZ3jfvUsfP8SCyOcdVB4M4PWd/9wFYVfygPDrX/U7qv5y7wln4hJpo4YfjdhkwRxrZ1r6hX9p14wcoxryrM+lIwZLNgWt/n+aWrFLtdfkHIW+6Jf2EuYmAwBZfdf7LCCKiqezLgqFH46P0hmgDQThI5hpKcaWLbpzTQlTiQQIyOK3xDsOtu0ys3HID2WotSE71PMS3fmYu2WB9O8ChtjnX0LVRCFvi/4zvKgvrTn7X9lfO/r5r8xDR7u9DbqQmfAHx401pAgRIxoNQNLh26kO/ln0mIMfJLZlL/A==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5270.namprd12.prod.outlook.com (2603:10b6:208:31e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Thu, 21 Oct
 2021 23:30:38 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.018; Thu, 21 Oct 2021
 23:30:38 +0000
Date:   Thu, 21 Oct 2021 20:30:36 -0300
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
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20211021233036.GN2744544@nvidia.com>
References: <20210922234954.GB964074@nvidia.com>
 <BN9PR11MB5433409DF766AAEF1BB2CF258CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BN9PR11MB54333BDB1E58387FD9999DF18CA39@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210923114219.GG964074@nvidia.com>
 <BN9PR11MB5433519229319BA951CA97638CAA9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210930222355.GH964074@nvidia.com>
 <BN9PR11MB5433530032DC8400B71FCB788CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20211014154259.GT2744544@nvidia.com>
 <BN9PR11MB543327BB6D58AEF91AD2C9D18CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <BL1PR11MB5429973588E4FBCEC8F519A88CBF9@BL1PR11MB5429.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR11MB5429973588E4FBCEC8F519A88CBF9@BL1PR11MB5429.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR01CA0037.prod.exchangelabs.com (2603:10b6:208:23f::6)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0037.prod.exchangelabs.com (2603:10b6:208:23f::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15 via Frontend Transport; Thu, 21 Oct 2021 23:30:37 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mdhW8-000Sef-Js; Thu, 21 Oct 2021 20:30:36 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ece51d2-b68e-4640-460a-08d994eac9c3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5270:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5270F1A592A17E144DDD28EBC2BF9@BL1PR12MB5270.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uFuuIQ8lGtefoTz2OS+UbXODz9Q5McjpJifmUTy0Lpvs0Ju0INuy7ZbYToS2JeAxIaiQmoBgrjFBzInaREq9lxDZg139Bf7a26eEUfIumNHu0Cpc3WK0Cx1zBSarO6tZ7o90ldAsBM1babKwtTju8JkKcPNygHRCI7LsCjFCIT7l9lT4CifzUHFclixNVNfcVrpvpQ0GMpmIz3+WRcNDVNp8XVBlrAOfwpg2ZeRaaZYHzecj7gEgfF7HnBRpg36481DkR7PuXB0zvBD/VSmOgnoaLFqKRTrKqlwNuk/8jBCG9jpz8xMwcI/UYI/chuc6EBKlm7hA2XOFnAfsbq97ovq29ZTWUl/FPRrv24JaYluyFUCvXPJ9coSCOdXWYa8d4mI7Hj5MBfEipg7GEYcN1dPc//yDN8Zb4KTgmJ483UuiVO69x0ag9Xe8b+z87g/7f7VvFZik5M6LZ63Ic9b3vy2TEwT/i9MDm3pmcFVw9pT0MJhxqlJJq10FXnDjUBVNWcIleXbnnWK4iauW+txyWJpZL/fxuTSVLJxUf9w9HVZ9DmrNv5CvB02+7IxvYt7Dzg0aSS8K2dC7tHhKCMlcn+x1G8ixbIBxwBIKZaf4J++KocJHxvlH6rOrShtuCi0a88oIIXmH9YH3H1PCzSsxiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8936002)(186003)(1076003)(38100700002)(4326008)(36756003)(2906002)(26005)(9746002)(33656002)(426003)(2616005)(316002)(107886003)(86362001)(508600001)(8676002)(54906003)(5660300002)(66946007)(83380400001)(66556008)(9786002)(66476007)(7416002)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pppXH+4JniLnVQ+e9g81WPf6PXb5NWI81H0xQrYIDYnz1W9a8hEjlrkfWEKP?=
 =?us-ascii?Q?A3abSRBmfajUuUsAcDynFncMgNDaTpAr8WWu0+7S+Hzeyah3Yp1+kqF8/0Sh?=
 =?us-ascii?Q?8I3pqI4kR3+BEDWa6qvf1S3y3esGwBlFtoknxuy2cENbZukjmqaU4RxM5VhL?=
 =?us-ascii?Q?UYh5kWR4GGPO7TAlSzx+3Z8OqKWGixmokmEg2rq+VJaa2K8kgfIlJMK/4hbv?=
 =?us-ascii?Q?1l98ml9cXaH34rRZQnHw04DKbMOxX+67qFa13tqkEIMYAY4kTR4vY0HonLe+?=
 =?us-ascii?Q?OH0WFlH7WPGZ9TpTQZCoXgCtseKvK3zI3MW9TeEd5RA4c5C/EmMFJC+M2ZCt?=
 =?us-ascii?Q?0dMbZ2tr0A1MwT9o2CPXwphxAkE1tipvQ1fjEkTf6LvY696MiKJUJ5F6Ro9z?=
 =?us-ascii?Q?JkRxFudfbkP1vqCatdi68w6FHIbi6MYVwmBPZ5c/vJSXJyUfVqQ18Kk4J8aE?=
 =?us-ascii?Q?sJvKl5WzLrpYma1UCh9f22TZW3/+T9CFhWHawklAX2S7WLPVJ7B0GF6aqsZv?=
 =?us-ascii?Q?hA40atkUtFAJ1YSyfJg0TZPs4ZjQsZd7IjLxyPtJmGRidF9cSBB9Z9/IB3Vv?=
 =?us-ascii?Q?J+6xC0zuCWkfUcIqSZBoTtCLleNsWL57wB6f9tlXdOhHWJ4z3XxoAAoeOmJt?=
 =?us-ascii?Q?88DGUpDykGdf/CB2XCdphb+y9wfEWawyvgZKZoLKaInZ0l6t2wjdbodiI8d6?=
 =?us-ascii?Q?n+Zb3JYn0CosDSG1Ouz7i5nEDskcXQ7BQQistGX1YtwAyFNdV1ovZxajfYl5?=
 =?us-ascii?Q?OUr0syZTn4TDuNWasIg5UmSPpEm6zi3PbD+De4hIcK0bLoLwubX/AhaBivoN?=
 =?us-ascii?Q?j5oJPWOjHf3KYkTDrznNs4hbCo7avaBSHIKxAPw16X5c0HC/eSCl3E/1G9Ya?=
 =?us-ascii?Q?4ZUzBfzHx2A7tYLYxkmpdNLnKYPnFWB0Xkh8L7aR/1GGTk6HtcWqe/bkfPD4?=
 =?us-ascii?Q?dzAxWwwgM/XL3PJr3y++mRd+SaLE5HTttJt1bhgcFiGXRUbVUNCnUvOSW9nU?=
 =?us-ascii?Q?yfUxUhh+O738rEGjDaRkBXCNOwyThxhu83oOSYMVp3Q9ertz7QB+s/Uf4hHK?=
 =?us-ascii?Q?dDUuR3jCG8c/SvC0r6Cg7LXni+Pq7xgo0HGUnUTE1zu4hna96LCfROiZg2mg?=
 =?us-ascii?Q?VwCBhbO0cmPb41VNoco7d2bvc56mumx08fIk2AqsMfRcurYk4w0IuMM9XgDl?=
 =?us-ascii?Q?E5RLHQZBNqghQejtonUcFp9zBBemonQz9WFGXpMOeCO+qFqqcG21nIl9GNZR?=
 =?us-ascii?Q?zdOweeB64IZbtLSLiLogwsK1bRVx1TQdZviZJkcFmhp+yS5Ozm2n+6+Z1LQb?=
 =?us-ascii?Q?3in72SPpiNO0RY5M76HgJEPWQw3+FdGuAGnLK0VMe9BMJXCf/voDTp2PHECI?=
 =?us-ascii?Q?V7XtDbYc/rKGsCe1G4Fm/h6wVHOqxiuMzzW3QjrEGsAPH19rv9NRgwJqMOVS?=
 =?us-ascii?Q?sk7wlIEK1iM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ece51d2-b68e-4640-460a-08d994eac9c3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2021 23:30:38.0968
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jgg@nvidia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5270
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021 at 02:26:00AM +0000, Tian, Kevin wrote:

> But in reality only Intel integrated GPUs have this special no-snoop 
> trick (fixed knowledge), with a dedicated IOMMU which doesn't
> support enforce-snoop format at all. In this case there is no choice
> that the user can further make. 

huh? That is not true at all. no-snoop is a PCIe spec behavior, any
device can trigger it

What is true today is that only Intel GPU drivers are crazy enough to
use it on Linux without platform support.

> Also per Christoph's comment no-snoop is not an encouraged 
> usage overall.

I wouldn't say that, I think Christoph said using it without API
support through the DMA layer is very wrong.

DMA layer support could be added if there was interest, all the pieces
are there to do it.

> Given that I wonder whether the current vfio model better suites for
> this corner case, i.e. just let the kernel to handle instead of
> exposing it in uAPI. The simple policy (as vfio does) is to
> automatically set enforce-snoop when the target IOMMU supports it,
> otherwise enable vfio/kvm contract to handle no-snoop requirement.

IMHO you need to model it as the KVM people said - if KVM can execute
a real wbinvd in a VM then an ioctl shoudl be available to normal
userspace to run the same instruction.

So, figure out some rules to add a wbinvd ioctl to iommufd that makes
some kind of sense and logically kvm is just triggering that ioctl,
including whatever security model protects it.

I have no idea what security model makes sense for wbinvd, that is the
major question you have to answer.

And obviously none of this should be hidden behind a private API to
KVM.

> I don't see any interest in implementing an Intel GPU driver fully
> in userspace. If just talking about possibility, a separate uAPI can 
> be still introduced to allow the userspace to issue wbinvd as Paolo
> suggested.
> 
> One side-effect of doing so is that then we may have to support
> multiple domains per IOAS when Intel GPU and other devices are
> attached to the same IOAS.

I think we already said the IOAS should represent a single IO page
table layout?

So if there is a new for incompatible layouts then the IOAS should be
duplicated.

Otherwise, I also think the iommu core code should eventually learn to
share the io page table across HW instances. Eg ARM has a similar
efficiency issue if there are multiple SMMU HW blocks.

Jason
