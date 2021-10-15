Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAB642EF63
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 13:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238311AbhJOLMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 07:12:06 -0400
Received: from mail-bn8nam08on2042.outbound.protection.outlook.com ([40.107.100.42]:12096
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238226AbhJOLMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 07:12:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1IG8E0ngL6Ucz65w1r77O5hbC4svrkTg7jah5Wi08NUN5+XwIea3d/KbEISj8AvYdxLliD11ZnqvOZuUnC9I4d9QfnNrXtJofW5PkN2mhkFz85GlGkSrBHxUWse0ktftaUa58/b94Bq1pgqy48wZdDDcBRx0yjiEdSQMkgkfGhEJfQclf+iXySDtxtEAXi0RQ0KQmuzk4dMtFLTOtLiUW+tAkyKDN6kOXL7Rt3bh9/+U4qejdDJ4aULM03owNsKgTYCcTZAp9xS/6nOKegRJ+6Pv6593AG2Va5D0zZCQnqx165j4LTW31HTJT/X2RUrQ+1wxFR/cF270TQ+B3Qwug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3EBmH5lH1HnWWgV0JHgltQzlBgJXyy+1NgHhW7vBDYc=;
 b=HfA/9xy0xA2yi7AAfMH4DuAPTQ2lHTuvP8w9AmCUJf45oqzWhC2Vuz/FTkjpzv4KqEVdhqAzAt9hhs0/kpbjs6KibUais9iD43sjZGTR5P3gxe1Whxiae8mgJIJvYHBcOA9b94EH6Fd6luEKq5Ew80ZLZUSgR90I2/B/8/2j0yF1Zl1Sgy3LyRg7XdvyPEO1ae9CSuVczkojkO+I0mUt+jlJWWZB8NLkJjAMW8ZkC8YL44sEg/tGvsKMklwjtFaxq4LUy4cRPvgvh+NCCoJJ1rI7NU5Q7qWK/foCoyEPc+NHuKuU7zlg2Pof7sw7qcaB3C5/4ZfSKd9/hRvCcTv3Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3EBmH5lH1HnWWgV0JHgltQzlBgJXyy+1NgHhW7vBDYc=;
 b=png8NIecrLuSZHtp83fm6ymLdoMo/vgD+/vaq6bpXvwOswtYjqpHhFgLdJ9GfdUsmT5rDBfPGVPq50z/s8H8BEw2EPGSKdVkVkWLp+Q3YO65DrRm4dcopQ5bc4XbgUnAWCOTYEUHzRoRktbt794NqDWsGakQDEMcrku6eI1ufWLXW8LI2hWSZNEh6pWo4/xoMnhyq8jE4CMx6NA939/WQlPsXVGhq2psGqW0EQoCrd5wOhKvafA8Ukst1zEGtxLeK4veZLjo9/HDrHiKlciG5EgFrHZFro5A9W+s38vzlncaE3RLVUQL/LOHiIMdsGio56jT2+YsmnnFZK+IKTtm3g==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5080.namprd12.prod.outlook.com (2603:10b6:208:30a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Fri, 15 Oct
 2021 11:09:57 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Fri, 15 Oct 2021
 11:09:57 +0000
Date:   Fri, 15 Oct 2021 08:09:56 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 06/20] iommu: Add iommu_device_init[exit]_user_dma
 interfaces
Message-ID: <20211015110956.GC2744544@nvidia.com>
References: <20210922123931.GI327412@nvidia.com>
 <BN9PR11MB5433CE19425E85E7F52093278CA79@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210927150928.GA1517957@nvidia.com>
 <BN9PR11MB54337B7F65B98C2335B806938CA89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210928115751.GK964074@nvidia.com>
 <9a314095-3db9-30fc-2ed9-4e46d385036d@linux.intel.com>
 <20210928140712.GL964074@nvidia.com>
 <BN9PR11MB5433B8CB2F1EA1A2D06586588CA99@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210929125902.GU964074@nvidia.com>
 <BN9PR11MB5433C616093C8DDA5A859C2F8CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433C616093C8DDA5A859C2F8CB99@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1P221CA0024.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::31) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1P221CA0024.NAMP221.PROD.OUTLOOK.COM (2603:10b6:208:2c5::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Fri, 15 Oct 2021 11:09:57 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mbL64-00FHpX-CK; Fri, 15 Oct 2021 08:09:56 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 390adfe9-b67f-4ecd-2571-08d98fcc529b
X-MS-TrafficTypeDiagnostic: BL1PR12MB5080:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB508097B2FB074B5319552952C2B99@BL1PR12MB5080.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wodUmSHv/eyBNM5btm1LLqc5Qli1q5dw5Ps5UsSgJ2s31AoSnTZ/G0phV5Z5cGITs0u6xcozBRAEX5grLx3D5zIXPg8EGfmnsGtz8C4IQPRfYwdhz/y52It6OWp1ZQD91pE9PXvDKEwiKg8YCZVT5k+L//chexgTVd2Vglf4ftHrr9hYDa9E7xydIiKv4V8U3+nroI2LNAsgA9NDwI6NWJkHb6OHOlOvN385NbyJ7agnY592/ZSzsNeDfILeqdsgP32DrheAmOiOvMOBmWaii4lgR6HoLAfLiWUSCDCWTLMkcXYH/y/iK7Ao3gGf2pWy5S+OB0ffndWMAK2hljWrWlgZA/h3lbE5V1YaVcd272pRmbZZpHnEUoXVomvZgxtF+0ltnFsgLqRc1SmFiv9e7fMxWMesFKHQNZ35Ift0BU2ITbYDruvHrrALMivF6vc9w6rqDSp6wxYk2EnPtbio/Us1YKImdDuD6h2Ayt0RfVcEU8sqSI0QkW23M9XJjreMXgZ0ydwnYZluTBg6Jvc320HO2Fx6doWfyeF7uLgp/ItWcrar1BHaFRkOp5CG95RfQIyXh7tdI8S9jdrs6p2MfGvgM1E8X58C3cig+1A3zs9tP5SCVrdUkRC2czI+493XRpIlj/ByEWnSOV45wi8vOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(6916009)(9746002)(2906002)(9786002)(316002)(36756003)(38100700002)(54906003)(86362001)(33656002)(508600001)(426003)(66556008)(7416002)(1076003)(107886003)(8936002)(5660300002)(186003)(66946007)(8676002)(26005)(66476007)(2616005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qub00jUJUs6zng9TKGjf4NT9VS50jbM97Osf/NC2ab2HsKawsnv5NjiwMXJk?=
 =?us-ascii?Q?tDnAHouVzc+DAe61gYJtrokxJBvHhqiKnATnj0dFsp97XFtKVKePqmHsffGm?=
 =?us-ascii?Q?CHpxFGCh0JNCdRhKhm0rblxUV6b7iRF1b5ANOL5K3Dv/PgJZDXYqSwA3rVZW?=
 =?us-ascii?Q?BZieAGbQLrO+f2Rv8MGiy0yGMrL18w3TGU2BANODNEy5erg8nPj3fHec7pUM?=
 =?us-ascii?Q?I2QA5cwFzozKwL7FD7tIFgduqDFgNuv73+b8ZoMLssCMvdaAXooq0EoPWM+R?=
 =?us-ascii?Q?E3Z2JcUrL9SobXyeGMyfu0IKcrqk9vtS8HHA9Zz93ZZ28ixVaxesu9Oqup/l?=
 =?us-ascii?Q?IGdSv39ib07YAmccjzZbfWb8pYKVZduRKaRuAwDwlts1Uicn6guwXVI2hPq7?=
 =?us-ascii?Q?LhwcQsCymhRvPoeVL8E7hvc0ZYDLFev5bY3IVfaScDkfm3iXR9s+DTrPiKwC?=
 =?us-ascii?Q?BIDa/lO8JNz1BJFrFo2N/Vk9WCS3TOMZp8pRIxwAI1OcCZgznXj0A/SgW7Ls?=
 =?us-ascii?Q?3FN6o+Wi4g9t0wX63AWnOZUApbzKdkFfFmM2f5OsSQSRYYV6pBac1PYq6EhE?=
 =?us-ascii?Q?IGFENI590pTzyD98LKDgZGuahWbogCvc9OfVb4nQm42/07olIVJahNQjvYBG?=
 =?us-ascii?Q?ho+9fBC7O4WTOpRhYl5yOREdMk+0W2HINj7J2DhXc4z4xmrnuIK4jJGZy0DK?=
 =?us-ascii?Q?CttfzIJVG1g2K+ItNf9+vhEnCMWqhZFMCw2t8WASZB6NwDzj7eR50eJYWIwf?=
 =?us-ascii?Q?KYVpGCH3YITBpLm8wmwJCoAdfpo4YmFsZZYnVcueDqZxALhD/Zp80Yq1P7N6?=
 =?us-ascii?Q?xI4pv5T900mbwWE3TCewdnOy21YwlasCZEZw0M64mlGDJvK0ntpncwXC6r8g?=
 =?us-ascii?Q?Z1DCuS9AfCFZr36ncHECk8ZsClj2o+CbSnMvhMInk6ntCw/qV07OgVAG7dGK?=
 =?us-ascii?Q?FWiWnnjgS1/wg92e9YgSEvQsxE/bFqyn6TpQ2JFdj88TOQGLMyI9e3GeOFan?=
 =?us-ascii?Q?UQa40/0V/I5lXGt/Jk41CNxDQzkdglJfNckGw7oI958381ilaGpzNTiF+OUO?=
 =?us-ascii?Q?76r20DcxoifXxq+yFubiNCBNFF0mc4lkAr38DT4K1uuJMdSynM131/y9V2T8?=
 =?us-ascii?Q?CQSKHX8tna5hUbNYuj7iIqaZ2snqyoyFO3mhv/1AI+rjciD43+pMm7HE1nNb?=
 =?us-ascii?Q?ZqsXDSIJj823pnvVRS0hmeqpzXN2Lb4TpQwV37mHC9ecwKta6/BjZdnaXfMs?=
 =?us-ascii?Q?oXfNcZEG3pgM3LVfAfPuzQJQbX304+99VFCxtQaK1CzfUznFYLXmycvqJNZi?=
 =?us-ascii?Q?Oy7hz85wLhQnRD8+yizuuEia?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 390adfe9-b67f-4ecd-2571-08d98fcc529b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2021 11:09:57.4094
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2I7or5PWkoOAXbQvCwn9d2OYV6LDbgP0T1XdB6c0IZEGTf2twLjWvx1PdYHFaJwK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021 at 01:29:16AM +0000, Tian, Kevin wrote:
> Hi, Jason,
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 29, 2021 8:59 PM
> > 
> > On Wed, Sep 29, 2021 at 12:38:35AM +0000, Tian, Kevin wrote:
> > 
> > > /* If set the driver must call iommu_XX as the first action in probe() or
> > >   * before it attempts to do DMA
> > >   */
> > >  bool suppress_dma_owner:1;
> > 
> > It is not "attempts to do DMA" but more "operates the physical device
> > in any away"
> > 
> > Not having ownership means another entity could be using user space
> > DMA to manipulate the device state and attack the integrity of the
> > kernel's programming of the device.
> > 
> 
> Does suppress_kernel_dma sounds better than suppress_dma_owner?
> We found the latter causing some confusion when doing internal
> code review. Somehow this flag represents "don't claim the kernel dma
> ownership during driver binding". suppress_dma_owner sounds the
> entire ownership is disabled...

If in doubt make it

suppress_iommu_whatever_the_api_is_that_isn't_called

> Another thing is about DMA_OWNER_SHARED, which is set to indicate 
> no dma at all. Thinking more we feel that this flag is meaningless. Its
> sole purpose is to show compatibility to any USER/KERNEL ownership, 
> and essentially the same semantics as a device which is not bound to
> any driver. So we plan to remove it then pci-stub just needs one line 
> change to set the suppress flag. But want to check with you first in case
> any oversight.

It sounds reasonable, but also makes it much harder to find the few
places that have this special relationship - ie we can't grep for
DMA_OWNER_SHARED anymore.

Jason
