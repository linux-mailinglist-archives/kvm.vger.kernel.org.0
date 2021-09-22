Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EADA4149D8
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 14:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236114AbhIVM5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 08:57:00 -0400
Received: from mail-dm3nam07on2048.outbound.protection.outlook.com ([40.107.95.48]:42593
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236001AbhIVM46 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 08:56:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgLsssc8iezayJ1pz7ce7iH8CcP1Pj5kvXvOupyq/0cH79in3080OVd0/8lX9R9WNp7gtp/I+pmhr3ILn2JpO+BGQIFgxQmWoKMAaltECfHS2KYiX4kk475AkQloTPA+ekdYqFl0vPtUNxhD9xhIXi28hAr1EeUxbc9/M0EDrCx2KHTkKq+bLeLCs/Hz00ApSEHbv2dMEGWMjd2Cw28n4vTpeSZV5n+yD9kMFEZD9Bgpp/0wt5AFlfv96liuzEq1V0/UG+NePv8LuSzCKPROwb72dqfNDmbys89mPPAlcz+TDhXjQ8O6Q8FuuSfkeSeGKKI0pWPrDIJEoLNmmJHXew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=swyX46AS4zjJUDJGgiepdvJhI/BdcF8/AmcAhZqUAho=;
 b=nBHinf8jztj4PdIjaJXNOeFQxbarvvOpEpaQDQBMo1QyTzkYsxpya1m9LJTrM8MsfF9YtTcKLW4bDk2f6I+98seTiRvLEGTz0CvTLUVoV0l8mz6BltNtWGbm0CrJXeztz7XaPTSse6v5e0tk7nLKrg2AWb/rNV1PLZMUXJkeKHfJkTZccerQvHerYOV/dnHgSTZVoQspxPEU6Z6Jks/QX0giMKbXePyw/+9uia4hClZAUe36GsJ4VTvp5aTxN+SsZ7cA37JMyADRudMtgcF1XqLXh3ctova73c6j9X/4KAHRbtjYa9BvJJZhhepJhObzvEeIO6HdS58dgRjwYStb5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=swyX46AS4zjJUDJGgiepdvJhI/BdcF8/AmcAhZqUAho=;
 b=ZvqInp487K6T9+N5KtFQYIUkv9/Rqq9y2WlymQf4ucciM0Zx/ow+Wq+xrD9wYz24xhpONslpFKzdLJfVfV4aOhxcIxKDwiT25v4BvTzLbWyQrK/TQtGnPSmdA+SjsMz41ZVfkb19ragIuseMiTOwHm/uxfH8r3MM6Oit1e8EynC2+u5ndpOZ7cpKuTsYFmivjahrj4tgwI0RSza4AYmo8AgnNu8bVW8Io6QlLVZhWXS127rYibUwSnxBQB56d94nfxxMnZAzrHZ3qUX/ppKAckbPp6IJEX+TrC4RbGGj5L80AYXDlGvW+NICTAdoYsEc0BXGUpftmEDFsL3ErqrpEA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5125.namprd12.prod.outlook.com (2603:10b6:208:309::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 12:55:27 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 12:55:26 +0000
Date:   Wed, 22 Sep 2021 09:55:25 -0300
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
Subject: Re: [RFC 12/20] iommu/iommufd: Add IOMMU_CHECK_EXTENSION
Message-ID: <20210922125525.GM327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-13-yi.l.liu@intel.com>
 <20210921174711.GX327412@nvidia.com>
 <BN9PR11MB54334A552C3E606F4394EF298CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB54334A552C3E606F4394EF298CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR03CA0027.namprd03.prod.outlook.com
 (2603:10b6:208:23a::32) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR03CA0027.namprd03.prod.outlook.com (2603:10b6:208:23a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 12:55:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT1mX-003xFq-Ma; Wed, 22 Sep 2021 09:55:25 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9e0872a9-d248-4e8f-b42f-08d97dc83fb0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5125:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51255E7AD6AB56D3F2FFC1ADC2A29@BL1PR12MB5125.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5HOTISk61gPj1nyOx/WRhNxi4Fwk7cjCY39RDaN9ITB6PCihnfnTWtpgUSiXK7NQZixQx0extfedAO0RRV4eo2KrstZtX7YqDUwDR7UVVKZ9xjkPQSkARVj/OVCSry5Wr4qXo4tNdGlJlkEOQL9ZSPuWTTbcRYJVYjTLgmMfG9t85GGnAPaJFrm2fjvMeu6AWE/QLSaYgWKkagNHQLLniFEnSqkhYz1lpuHLuWdewqN3BWMl07pHtQa2ZYwimzer4jRrJh545doy+iOG/nVN4yVJnw4JyyGY4oybdAYocJWyrOa6WVcI2ng9orJd+8Rz80oobVvsEVuiYY1QVSqkc7TajaGNdqRDvvPDn2Hbs6fcuDQ/MwY51R0yY61nXzJ/f9Jw1grMG6jc9CqIGRQLN95LzLNS12UkxN62fJTA01aZ135OjbrI47Og7LXkBDYoETeGnCX99RfeEFYy124lZ5zAbqGkrxH4zMMbMTmhJVxNmp5XrG7gpUd+fgoo8rSyxhQE/4G9pmuNx48YOOIeggfe6h4c634bsuMgWFocNcxUeWq3LUmzKhgomh+qSGAmrIKczAXQ/p3DXG40rJnAI3X/NatkY8acfp+enof8ji6ipbyqCCYrADfzTs+6szDEC0Cmg2g5/8XUtEPCRXj537PGnyQyJoPtprOxdJSoug4AHpjHBYy3nnTuimDDKzss
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(33656002)(107886003)(8676002)(8936002)(36756003)(186003)(5660300002)(1076003)(38100700002)(4326008)(508600001)(66946007)(66476007)(66556008)(2906002)(9746002)(426003)(7416002)(9786002)(26005)(316002)(86362001)(6916009)(54906003)(2616005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K2NLbDh5ckpGMWZhbW1TSmFQUnR3cUMyWmt1Q1dXU2pJRXh1bW5haDBQK0NH?=
 =?utf-8?B?NmpuWWN5aE10d3R0bk5FL2hURTg3cnRnN0dva3EzME4yeUdyWDRNV3lOQUlo?=
 =?utf-8?B?amM5NjFtVXREZ1RyVlhTZHZlNHF6UjJGeHJ5NVVQMlBoSnNZMXIxS1ZwU215?=
 =?utf-8?B?NVdlaUZJRnFmUmFHL09SejJpdC9JNkt5Q3owazl6NGg2RExMOVgxVzV0cjBS?=
 =?utf-8?B?U3A2cHRDRW55MUxqTDdBZW00emFuQ09XZEdmdmx5NHVtWi8yR21EV2M4eGht?=
 =?utf-8?B?RlRnOUgrbkpwMHlPajNzdHpBRkw5YzI5VlA0cjRKZ0lUQ1FpUmVUREx0SzNz?=
 =?utf-8?B?WmpEeE1wMmxwcjJqcmltK2FDU2c2KzUxY0V5emxxWTBJL3FqcWhLMTFCVVFW?=
 =?utf-8?B?WjUzTVRSdlZ3MU1FbGcrZTNtY0czaUVxa3dUUmxSK3REUHIvNWNCeXBzSmhW?=
 =?utf-8?B?ZCsrT0hkL2RGRGZPUlNwMHFYNWZkQUhRc0VLOTdGcDZvTXpKRWozbjFJYzJ5?=
 =?utf-8?B?dmhoT0tEYWVhdjhQRjd5QXNUSlBpdzgycDdZWTMrTk1ROG9vRjQrYlJLT01H?=
 =?utf-8?B?L1NHMjBMZmxqbXQycXBYL3QyRWFuTW90ZWZma0d2ZE54anljRUQrNmRXUmlN?=
 =?utf-8?B?WUloSWtQUHNHNUt5d05la2NJZDExQmJiU0lkcWZoc1VHc3hhdUdUUEM4aWtx?=
 =?utf-8?B?amhpRjFjTFBxVWF2UlJ0ZHdOUTdJbmp4bTIzbzFVanRBWTdMUWhrRDAyd3p0?=
 =?utf-8?B?YStKVjhWZlUwbjZkWDZJUEgyMWhtaU5GbEJ5YVpWV3Q3NEV0d0F4MmhvbXJ0?=
 =?utf-8?B?Zm9HSGdiQmhZeTR2TEpjajBjbXQ0Ymt4eERwcFcwRVYyN0hBcE5oaXIvNnd2?=
 =?utf-8?B?R1c4S3hOb0h3VVJkaHhvOFhYM2s4VlJjcjA3NWhXM3VuK1FORFdYa0liM3Rx?=
 =?utf-8?B?bFNHcDIrZnFISldFMUFHMjhRVXFtaU9ubnZTNjdTQ1A4ZEQ0OFZTUVVxU1FI?=
 =?utf-8?B?bms5dnlTdTc4c29CODZpUnlHckdhbzNCcmpTNUxpSkt4Tm9Jd0RTdzM5eWJr?=
 =?utf-8?B?TXk1aTU2TFNjNldxOVlVSzl6NE5rNldJeHg0NisrVUc0aHJyTVYxa25WcU9K?=
 =?utf-8?B?a3BCYk1ubk10b3Y4MHlFbUk5Uy94V0MrcmhCUUFLL3Rqak5iWUlxc1VNMW42?=
 =?utf-8?B?MXNLVVJuT1lCT3NHQ0NWWEw2d1JoZEQvTkltZ2VsK3Q5YXZDcWxnTTUxUlZL?=
 =?utf-8?B?bnd4RE1DdVNqUldYclRPQnM2MW5YMXZjWHRtTDMzVVhpRkt4MUtKRlNldFAv?=
 =?utf-8?B?dHVieFVva2NEQnNSTDZRVVRRcFFXaFQ1RUxiQVBMUFEzU3ZINWd4T2o2aHFw?=
 =?utf-8?B?ZFpzQ05wTkdGODNHYjVpZmFqdUw4TmpGVHBndDJnaGNnZ2FaaGI0MytDYkxu?=
 =?utf-8?B?eWxvMThieCtGNStuclBDT1VIUDQxZ21nRlZGTmJxV1Bpa21tR05EUWNXc1BS?=
 =?utf-8?B?Z3d3ckxjSUJzNlNFSmZnVnBMVWlBdlMxS0VTeTM5SUVONk1mM0dHQ3BZeDRV?=
 =?utf-8?B?czBSZGxrZ0UzV2lneXpUck8wL1NseGJsU0x5TW9KVThReDJzMkZyR3ZSTWtI?=
 =?utf-8?B?MzFZbFFkbzJGQ3F1eWt1QkpOeUkxRm5Ddlh5UjFWV2REM20ycTJIRS9LSkt5?=
 =?utf-8?B?N2JTOFV3T3ROdG55azYrUTlmVUFKOFY1M0ZEUVZqLzdLNVNXN2ZrbWRtQWpn?=
 =?utf-8?Q?+IGTg6MaXM7Txl1lMo5xfApZiBVhNsxYTHRhNz6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e0872a9-d248-4e8f-b42f-08d97dc83fb0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 12:55:26.8288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z2IgttDwjzRz+tQfy+5H5zhJEDQLoBclG5Rm7KGx9PmpaWxnZvHANWToJckTR83Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 03:41:50AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 1:47 AM
> > 
> > On Sun, Sep 19, 2021 at 02:38:40PM +0800, Liu Yi L wrote:
> > > As aforementioned, userspace should check extension for what formats
> > > can be specified when allocating an IOASID. This patch adds such
> > > interface for userspace. In this RFC, iommufd reports EXT_MAP_TYPE1V2
> > > support and no no-snoop support yet.
> > >
> > > Signed-off-by: Liu Yi L <yi.l.liu@intel.com>
> > >  drivers/iommu/iommufd/iommufd.c |  7 +++++++
> > >  include/uapi/linux/iommu.h      | 27 +++++++++++++++++++++++++++
> > >  2 files changed, 34 insertions(+)
> > >
> > > diff --git a/drivers/iommu/iommufd/iommufd.c
> > b/drivers/iommu/iommufd/iommufd.c
> > > index 4839f128b24a..e45d76359e34 100644
> > > +++ b/drivers/iommu/iommufd/iommufd.c
> > > @@ -306,6 +306,13 @@ static long iommufd_fops_unl_ioctl(struct file
> > *filep,
> > >  		return ret;
> > >
> > >  	switch (cmd) {
> > > +	case IOMMU_CHECK_EXTENSION:
> > > +		switch (arg) {
> > > +		case EXT_MAP_TYPE1V2:
> > > +			return 1;
> > > +		default:
> > > +			return 0;
> > > +		}
> > >  	case IOMMU_DEVICE_GET_INFO:
> > >  		ret = iommufd_get_device_info(ictx, arg);
> > >  		break;
> > > diff --git a/include/uapi/linux/iommu.h b/include/uapi/linux/iommu.h
> > > index 5cbd300eb0ee..49731be71213 100644
> > > +++ b/include/uapi/linux/iommu.h
> > > @@ -14,6 +14,33 @@
> > >  #define IOMMU_TYPE	(';')
> > >  #define IOMMU_BASE	100
> > >
> > > +/*
> > > + * IOMMU_CHECK_EXTENSION - _IO(IOMMU_TYPE, IOMMU_BASE + 0)
> > > + *
> > > + * Check whether an uAPI extension is supported.
> > > + *
> > > + * It's unlikely that all planned capabilities in IOMMU fd will be ready
> > > + * in one breath. User should check which uAPI extension is supported
> > > + * according to its intended usage.
> > > + *
> > > + * A rough list of possible extensions may include:
> > > + *
> > > + *	- EXT_MAP_TYPE1V2 for vfio type1v2 map semantics;
> > > + *	- EXT_DMA_NO_SNOOP for no-snoop DMA support;
> > > + *	- EXT_MAP_NEWTYPE for an enhanced map semantics;
> > > + *	- EXT_MULTIDEV_GROUP for 1:N iommu group;
> > > + *	- EXT_IOASID_NESTING for what the name stands;
> > > + *	- EXT_USER_PAGE_TABLE for user managed page table;
> > > + *	- EXT_USER_PASID_TABLE for user managed PASID table;
> > > + *	- EXT_DIRTY_TRACKING for tracking pages dirtied by DMA;
> > > + *	- ...
> > > + *
> > > + * Return: 0 if not supported, 1 if supported.
> > > + */
> > > +#define EXT_MAP_TYPE1V2		1
> > > +#define EXT_DMA_NO_SNOOP	2
> > > +#define IOMMU_CHECK_EXTENSION	_IO(IOMMU_TYPE,
> > IOMMU_BASE + 0)
> > 
> > I generally advocate for a 'try and fail' approach to discovering
> > compatibility.
> > 
> > If that doesn't work for the userspace then a query to return a
> > generic capability flag is the next best idea. Each flag should
> > clearly define what 'try and fail' it is talking about
> 
> We don't have strong preference here. Just follow what vfio does
> today. So Alex's opinion is appreciated here. 😊

This is a uAPI design, it should follow the current mainstream
thinking on how to build these things. There is a lot of old stuff in
vfio that doesn't match the modern thinking. IMHO.

> > TYPE1V2 seems like nonsense
> 
> just in case other mapping protocols are introduced in the future

Well, we should never, ever do that. Allowing PPC and evrything else
to split in VFIO has created a compelte disaster in userspace. HW
specific extensions should be modeled as extensions not a wholesale
replacement of everything.

I'd say this is part of the modern thinking on uAPI design.

What I want to strive for is the basic API is usable with all HW - and
is what something like DPDK can exclusively use.

An extended API with HW specific facets exists for qemu to use to
build a HW backed accelereated and featureful vIOMMU emulation.

The needs of qmeu should not trump the requirement for a universal
basic API.

Eg if we can't figure out a basic API version of the PPC range issue
then that should be punted to a PPC specific API.

Jason
