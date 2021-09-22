Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAC741493F
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbhIVMn3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:43:29 -0400
Received: from mail-dm6nam08on2065.outbound.protection.outlook.com ([40.107.102.65]:21344
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236104AbhIVMn0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:43:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cBKydNIOjkqLL6jbDtbCNb2Y3d9nQ6Jy4ViYLNbIqcLRjoOLKrSLqgNlo81vcurxJndv8yEaKkfBwpPWFrcIrziXGJsGbfMIbj7wC3xIOrCMWJ2ol31RScxaVDEDuasgdvJiERkHNrCaROQpLsIvFw2OKrw91ugIh50YrHjBv/7eB+fvTSL+z7BKOoc1YjXIMgLMrSPhXHbNSnN3f8oLNj6kVdJmROX+5XKTWPs5atN7/VYBe+DCILOigO4msNJrqBFYoVDFxCGJygtcMa2ZtuZyM2ttJ64sLOYIli2aqS2GYjQVm4C4FzJob23wAXiN0FrbOdChIZJUHKPVRkjd5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=QRtjpsfZZz5xxxBdjjuG0lt2duPOU/QeYsx2bpym50c=;
 b=jAefSQMFMJ5gZMiLMYFD8egOF9SMGalErrfUNtUVdM25sPPOJeExCWqjCEo0fjWUxTGml/A4Ap5qTHiWI+9LNzAk5O+hiVwMcsNOO8079i2bkCvfPGa4X25AKn5t62aU+ddthU7BIhIX16u5fOuMtlu8n0gFnVR5br1qhudqLrQYwJq2ye9dNzLojXsV2T7Qj54bGt4ZYn+K2m32HNTudN3DKjNZuZY1uzh+rsk0Ig4ywtJ7kquwg5C+OzZwssAAS71cW27l09LwGlmBhQnRdEVq8yNpEoIbVv6cmcOgsHR7lOjwyC+/aFwI2b03wWRxCDBt6V4DW7fvcZgrRXdZ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRtjpsfZZz5xxxBdjjuG0lt2duPOU/QeYsx2bpym50c=;
 b=qMgsPYijOnVKzy4qlsN7tBTLnga0633PxfGT7uz5tDYsinw0LA3euwEb2W1hycg8ixbOtnSfc1dAfxX5F0Mo2FcB3tOyYcZ8454cELh5HNL6jYY2dnRS/oPu+II8f9JDY25CCm22mQ55EuNbfOJATHzunnDMWkWQt8Olbl4RFmQ7u4B28rfr9uMrCtoHNy8rLuHBmzIx34rVZTTSCMTCFJGwuQbhFiDVZEtyvbQ6TeTbaBQ6IHf/TVODDpk4K7nM3ozjfaYJMnwro9M9PQpkm5kHJ21rQJojvMCXzr1d9441zvNV3ZIAnEyc+miLHeMe4UvNH4dLjoZfmTb6sACc5Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5317.namprd12.prod.outlook.com (2603:10b6:208:31f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 22 Sep
 2021 12:41:52 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 12:41:52 +0000
Date:   Wed, 22 Sep 2021 09:41:50 -0300
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
Subject: Re: [RFC 10/20] iommu/iommufd: Add IOMMU_DEVICE_GET_INFO
Message-ID: <20210922124150.GK327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-11-yi.l.liu@intel.com>
 <20210921174049.GV327412@nvidia.com>
 <BN9PR11MB5433D26EFA94F59756AF91838CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433D26EFA94F59756AF91838CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR10CA0034.namprd10.prod.outlook.com
 (2603:10b6:208:120::47) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR10CA0034.namprd10.prod.outlook.com (2603:10b6:208:120::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 12:41:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT1ZO-003wzB-Ja; Wed, 22 Sep 2021 09:41:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ddc5f4a-6299-4bc0-8c90-08d97dc65a85
X-MS-TrafficTypeDiagnostic: BL1PR12MB5317:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53171901459E1F0E108AB9F2C2A29@BL1PR12MB5317.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TgFcF1otN5bFpeRdxhszovGWtYzjZlcZBpTUOKQI4B6LRvC7kfS2Q7SdRqUPpRKpgd8gn+KRtr0RQgp4ovRMMN7jekX8MqhKlxLUfVTONvCuBwzpYQchAiwi7Q5vaO4WxKsuxGC4IzuM1eoBZ0wq4u3a6+yGs3Bcr6vbr79aKMb8xbFb46eZPRSne2RKbkFNnw+TKKNV5zCFCOE5DUEfTmy4T8mTJSHza6RChRz78HJEPKhDAghEUyYyn97jVhk7/EyMFQ02F6DHe2XJvT2b4+C1YpMHEPFTrDwC4xudZlyPV9yk6nrYotJbIE+FWz3fJww2cpoxKuN0XRAYpT3bSXYT84fZXJKKahYa/+CYbM9k8cy7rGLQmrzqkIj+nnboKYZKQJpY+5W0N+aLwRpzbPqyBgM1rkxmm4u0ex41F3UOb+KSJtsQc+c5SNJM1nB2NcoA8DIkbRILzMoq9ieEhEYL+F7pYKXRKQXqmanUdzuXw2Kf9y9NKjntb5dbnDnbFyiAJSPDMyH/DLTE+mk0imkIkV9Kw6Q51FTrI6kzP9Q0LuUabuRRN2T6uxnBARzE34+ojLfudK2LIW9SH8s3HqU5H7MMcOa1Fl0SMH7fyCuBpRaKV4+t/iijrh5AjjhOUK3DN/bHu2LG4SGtFaJ75WA8CEOXeQ1KIEARQcpfjgu8Go9hYFuNS08hX+3loOGq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(26005)(66556008)(66946007)(4326008)(38100700002)(5660300002)(426003)(186003)(36756003)(8676002)(2616005)(66476007)(1076003)(9746002)(86362001)(107886003)(33656002)(8936002)(2906002)(316002)(508600001)(9786002)(6916009)(54906003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jMs/whyJxuzWDodLVjXULPFrofBsKVkbbuNtHaGqTuBj7wWO0fhZtUjYjpKY?=
 =?us-ascii?Q?NkN89sKegQL8IzH65TUPUlzZK4eNrInpOVQhxX8vxVtSB6W64nbHkXYJNtTl?=
 =?us-ascii?Q?cwDIH9JTbygNIOa6Ngk0l9izzFtJx48XeWAdwUhsMDbQcIlJ5w+FJEvkLDSk?=
 =?us-ascii?Q?WuDgpIMfvpDdSsfO57POsWdvW0YVqRIl2jm+0RdLAHHE9Sr83F6Cn0QhsEfI?=
 =?us-ascii?Q?XDgVfXYy+rCxVRPE1gTZHDpsw6Op8yV6R4FZMqDtk5GXV0FeAaHCXogOs4ve?=
 =?us-ascii?Q?55vRYY9i31jD6DH2hCdRGclMK7GD6JgAPgpTwwhdVu7qp7U/cLtCUWrE0U2N?=
 =?us-ascii?Q?FD4g1A1JtpiapnY8V4RF1YsS3FxriOtEv71BoFw3WANDEHMyrNHDxiQWGbdI?=
 =?us-ascii?Q?CGaVxvxWGLfYEmdfAh3uleYKZsLtZB929zd7or5UQcRIqyyBdKT8qQCVZL6+?=
 =?us-ascii?Q?WRyPAoscMT2GckNm0JgcumXxEpswNEPjESX1vCW3BOkVuQbnHfSH9CV1tvYF?=
 =?us-ascii?Q?w5SvtNW6tKCjue3ueCQaFfLDpjDqQHVkRIcooNexJqN/vhzBPcNUDLmpeGXb?=
 =?us-ascii?Q?/+l1Vdb0wZKZsIUwqiusU6BORFhAo7BiLqkSHVDnR6sZw+fX+aZ7CVf45PKq?=
 =?us-ascii?Q?57P5+kzm6/VdTfg39DvqDBygEpYEqxQIUkGkjlEV62/g2XsdSsW8lUnCL0V3?=
 =?us-ascii?Q?mx4/LWtWKMQ5V/S+z4xXZd2BPWek7txCYXZe+DBVmYorl8Ft35LyOzC23XEm?=
 =?us-ascii?Q?u+pCbnDREv4jX6eY6TGm98h21SBh10oMIjsFcfRMwy73u2kTKeon5vH/iUbf?=
 =?us-ascii?Q?HGKTHLtaX7BsflbcV9YqUDxj91W46PFLWbqiRILmQ40DpP1SzTW2crPxr6uY?=
 =?us-ascii?Q?ov3ty1YrV8P0IjoN3u5sYDGTsqkJexWfQYEsNDk7VvZTOaSSqFiaKtPetZaV?=
 =?us-ascii?Q?lbZw8+02oKVMkGG+HuZ6mVRQgL18ZLPfK9QMxO7j6x5pzLuSMK40d862knyH?=
 =?us-ascii?Q?V6q6AlUNerNASUVKpHhLhgNq+XxEisqtYFQUccm9vmOrzutSo37/aSOUxXaD?=
 =?us-ascii?Q?2h/B1SyFRnpMll62HoTQg6Cv1+kiE8NFkC51skVBCqLctqzC34L/AVD2iCx2?=
 =?us-ascii?Q?UwRgyTRYEPpstRmaXCC6O+J4+15chyoZHfiQYu5OeGM57zYnCWIJ+QWSRCdn?=
 =?us-ascii?Q?BZh5umJ9PoCjaCZvHcqrELdf4OuNRPJelwV03y+Xa5+GDrMjtpj6bPiXrDWC?=
 =?us-ascii?Q?sknqerLARLNCOVN76Lh6hOh5Vb3K7+hMjJIMtwYgt3x/p3y17r45Szmc4dkT?=
 =?us-ascii?Q?zF33SrXKK18eL55PtXvxjeC9?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ddc5f4a-6299-4bc0-8c90-08d97dc65a85
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:41:52.8002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MQILrA01wVZRKx3pVaQfdjBkJ9xIDQ66DMQ0Vby3s1C8GX1DrrftHrhlAd0i3ntU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5317
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 03:30:09AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 1:41 AM
> > 
> > On Sun, Sep 19, 2021 at 02:38:38PM +0800, Liu Yi L wrote:
> > > After a device is bound to the iommufd, userspace can use this interface
> > > to query the underlying iommu capability and format info for this device.
> > > Based on this information the user then creates I/O address space in a
> > > compatible format with the to-be-attached devices.
> > >
> > > Device cookie which is registered at binding time is used to mark the
> > > device which is being queried here.
> > >
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > >  drivers/iommu/iommufd/iommufd.c | 68
> > +++++++++++++++++++++++++++++++++
> > >  include/uapi/linux/iommu.h      | 49 ++++++++++++++++++++++++
> > >  2 files changed, 117 insertions(+)
> > >
> > > diff --git a/drivers/iommu/iommufd/iommufd.c
> > b/drivers/iommu/iommufd/iommufd.c
> > > index e16ca21e4534..641f199f2d41 100644
> > > +++ b/drivers/iommu/iommufd/iommufd.c
> > > @@ -117,6 +117,71 @@ static int iommufd_fops_release(struct inode
> > *inode, struct file *filep)
> > >  	return 0;
> > >  }
> > >
> > > +static struct device *
> > > +iommu_find_device_from_cookie(struct iommufd_ctx *ictx, u64
> > dev_cookie)
> > > +{
> > 
> > We have an xarray ID for the device, why are we allowing userspace to
> > use the dev_cookie as input?
> > 
> > Userspace should always pass in the ID. The only place dev_cookie
> > should appear is if the kernel generates an event back to
> > userspace. Then the kernel should return both the ID and the
> > dev_cookie in the event to allow userspace to correlate it.
> > 
> 
> A little background.
> 
> In earlier design proposal we discussed two options. One is to return
> an kernel-allocated ID (label) to userspace. The other is to have user
> register a cookie and use it in iommufd uAPI. At that time the two
> options were discussed exclusively and the cookie one is preferred.
> 
> Now you instead recommended a mixed option. We can follow it for
> sure if nobody objects.

Either or for the return is fine, I'd return both just because it is
more flexable

But the cookie should never be an input from userspace, and the kernel
should never search for it. Locating the kernel object is what the ID
and xarray is for.

Jason
