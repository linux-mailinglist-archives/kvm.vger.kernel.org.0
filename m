Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400393C7A0E
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 01:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236794AbhGMXZj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 19:25:39 -0400
Received: from mail-bn1nam07on2066.outbound.protection.outlook.com ([40.107.212.66]:46151
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236702AbhGMXZj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 19:25:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IC1OClLXF6AIka3U6LE1agPue75WtaD/ZM0UNJYz/S2apiRz9awIfpWq3VkSiqwjIPhOiaRDkZipEfyMQSdiMaZlZ5FscbHkDZ2Kl2t6ofRhLNyRKVqbuL1p3EUFvOOTQSLAkkhH1rqVRJEUdPZ+3akTf51UbAFCPXY+Rl1f7g6VgmIdcZOdK04RhxtBkXP+ta7oVe5H88GLt1bGiVuQzPNc7TRU4AOUwnKHlRJt19jWhrtxSB2p5JFudYAB7jU9NigJi+k2OqUOZ6/goX7UD8mookpW/9BMvekKIUtLmb8ov3XpEMpwhdNyLGKJTBMUEoXAzz3TAfhEZxYZ+L9vaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbtX7nzpZiiiQrtaaoJOYtyhnL/2tzRikUf59h2d/gA=;
 b=TtQdyA2YQbZxXlh4clWhqj3+ibmLg5EUYTeF0QXjsSxH0g2Ki2ShJC0eY++gIpshS6p19//ehN6rCgEKdWAlhHQ1PQqarPt4FMD3nx6ci8bghdZsexe6cxESiTDpZLvIRYRn+AMxz2CFiLp0vwgIQ8PvwAujxhmpvzuYB12Z5mrNcrTjMm5SzjrNG6EeoL2xBBWJMDHaaDfnDgkMl9H0kjnjLgH88iXB1z70TjOjV4/LIJcXdcqYKrz3rSZ7xYRgu+/fBS6w3yY7W6jXL2jEN0vwTQV8yj2Ov6Kx2q3+EtWXZO6+76l1B/Xerfx6+r4rz34z1Vqi44bM2M6bn7fn8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RbtX7nzpZiiiQrtaaoJOYtyhnL/2tzRikUf59h2d/gA=;
 b=gSVtY7QiKRerocGNpy3lgDrzajEMhRAZzeNiFEw8RMt6kLDnKZpbip0ySfBizjX6c57gihsv86LjpbiUR+NnzFEFDRQ1O6E/4VfUazlWTBW3a+JBBgWgUHz90tI1qvO8QRu6nyt0tVCYTJDpWhSqJjVcycAv1O577mp2IM90iER56N3e+HkQeyfO0uSfa099s9IKw6SG6t99uKN15RTDX087akuz2XSFVbHCUwiQa7l6lA8FCz2MOLp9NK9Ww8hUKx2eE3o31XVtJjbyRv8gxJLh4FEKD35YVWBzBZHW5ifCCLmFVp9gyEc6dc5x8r4N+y6HeHD1VMZI9mNuBnez2Q==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5158.namprd12.prod.outlook.com (2603:10b6:208:31c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.22; Tue, 13 Jul
 2021 23:22:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.021; Tue, 13 Jul 2021
 23:22:47 +0000
Date:   Tue, 13 Jul 2021 20:22:44 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210713232244.GJ136586@nvidia.com>
References: <20210709155052.2881f561.alex.williamson@redhat.com>
 <BN9PR11MB54336FB9845649BB2D53022C8C159@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210712124150.2bf421d1.alex.williamson@redhat.com>
 <BL1PR11MB54299D9554D71F53D74E1E378C159@BL1PR11MB5429.namprd11.prod.outlook.com>
 <20210713125503.GC136586@nvidia.com>
 <20210713102607.3a886fee.alex.williamson@redhat.com>
 <20210713163249.GE136586@nvidia.com>
 <BN9PR11MB5433438C17AE123B9C7F83A68C149@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210713230258.GH136586@nvidia.com>
 <BN9PR11MB54331F80DA135AF3EAD025998C149@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB54331F80DA135AF3EAD025998C149@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: YTBPR01CA0031.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::44) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YTBPR01CA0031.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21 via Frontend Transport; Tue, 13 Jul 2021 23:22:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m3Rjg-0023lN-Sm; Tue, 13 Jul 2021 20:22:44 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4a8447fa-90e7-4441-3185-08d946551fd0
X-MS-TrafficTypeDiagnostic: BL1PR12MB5158:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB515835626C0134E76D7C95C1C2149@BL1PR12MB5158.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h8cJWv4LLI5Gtbb7fPRTEACrgMrkm5XKdA4v+aMBXPEVszk/HowIm3RuLPn6v7EKHNKKuhzNclj0QJl6hJY1l0+0CRWJqPe7zQkq57ss1tXHpFl3gA1rUgKShCYKPcDiIlfgCCCEIjqSg9qpfAxk9F1Lv2D2KQ4WB3pFrGGmZBb+hHYmkQCFtJV334v8VvuY1enISVr3Y/bkwWWXzhcAVM67x072Ys5IuBJ97wtnon8JmLsO3JHlGtcFawy/NdXzzH+8cqU2pwKPjqxyKhAjAN7LS/UZyQS2L/gjwUViQx35NbctFksn4ggcMaAuRGV0Kh/fhaW4iT0jQbU0khXYyVpycu5YKkFk7DC8J/tT4rhmdMaS8I/6Ji7tbHPN2u/++n9YuOq9RuOHgcvEWeGiGEZeKGUjQ19T2kifh9P7kHPNa1D+TQqvqDzAMuwKvR+9FAM5n+AB1cF4wMGfoh+QUjMsqGQIWPvdD6eHiy0MaxCno6zpScewtQhPx6anbtWmwe5eWwPvGl+kgk60nZ8HEJck6aZx7qPTsIBla7mJuX5hW+Ee5QOfpYjHLM1J+ZDAXwfUelDveWX1baILb3wd0CB6Q1fApXvD2pctYwrjv21Lic4dVFYe6ESIXFit092VlFTIqWkNFXI5uoJ7Q7r9fHlU37uFQVlcM5LmjPihFE0DYHJWxLAL46opSMSh7OXm/VCY35qJpBAMWgksk8O4VA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(38100700002)(36756003)(26005)(316002)(66556008)(2906002)(66476007)(5660300002)(54906003)(86362001)(4326008)(8936002)(2616005)(186003)(66946007)(478600001)(8676002)(7416002)(426003)(6916009)(9746002)(33656002)(9786002)(83380400001)(1076003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7dx34gx1Eheg9WR0zhC5gaPQQJTm+RQMzX4Raq9FqM68VTwj8j0V0TOkSbSe?=
 =?us-ascii?Q?yndo7K5DSEqtFHoVRe/HvNZldFdt0ndhYfuRdAX7geLo9n+QU9VwPCOvUvb1?=
 =?us-ascii?Q?siuhXuT4uQg/tUXUedZTaLiRVloUvnqFCzSMPsaJe3ekFdLNgPZhJpsYjRIR?=
 =?us-ascii?Q?dBXNHZ5N4D4fwsaooKtB3mEbvuUlylQhgwYmYCVpXC8kx3APeIv2HZubzesd?=
 =?us-ascii?Q?BMfcE85ELsCJ2gD9bvKlb82B7fvbUCVexQZrHrKU3uu9TJULmOQM4FuGogRA?=
 =?us-ascii?Q?5rjPjzBKu0+LrTHpdUult547CYxy2hpBRtzpFFsXU+hHn7ode+2DBM95er2s?=
 =?us-ascii?Q?rPPoKfoLJkncc1dr+8Yj5Ulzs3l5BxbP8kl68Zwr5s7uR6VyGO7AFQFdaYNp?=
 =?us-ascii?Q?6D43tM/YiYMMcU9nb6AwMVePfA1RiM4TxsZVMXWemtCXjySWxxEOdbqE5EPl?=
 =?us-ascii?Q?cvyAPqsQxQOB2e5pUtXV774jODiMeB+47sl8/9Q82wf0deC8WotHpOQMuOZn?=
 =?us-ascii?Q?FdMv/Q0O66sgUHdDoKNrpZ+ryIjD2oN626BUp0kmOaoOChUGJgBISWoVGWt5?=
 =?us-ascii?Q?Y54FAwJq3SmYlHU63ZbmA8hHEAnbcxVBCQYOznvYF/Bl+pH+xoRnrOMtgZ/d?=
 =?us-ascii?Q?2WyOZ48A03LwTuRMue7dscU1U85umNegk7mWA4dMm7wAeI5hFPI9v73ipKRo?=
 =?us-ascii?Q?uY2sWndzX8Rtv07U5evlDV6rpSJliA+igduCrbeT7t90JRMSsGaABB8LnKpq?=
 =?us-ascii?Q?uU9YOkvi4M/FZWU150p6B8RT+vA8zeG27KyWw6OzeKrJiwLzrHw1eB1uU4dR?=
 =?us-ascii?Q?KStJ73Ow/G6R0N27owsCo6cryWa4aaYM1NpdnWkr5pzzwMFnjZb5HwkXl7tz?=
 =?us-ascii?Q?1mjSEQl91ghXzKXIpdrbYDkPYXMF1cyyZr5+pkc/XJ9sXXZtQAmTkP2qEPHJ?=
 =?us-ascii?Q?7jzh1uJ6lOcuSZ3nzHQ/awiPF/AWTGTGmrxw07+OxBtmV9uJJdpK1MgioVU6?=
 =?us-ascii?Q?waM63Xhq0hXuYBS7/thb3q1hW4fVrTb+SB4gkgrG3MH9QT8V1joIg/A0iERO?=
 =?us-ascii?Q?3MM/LirYMGtCWweSAJrgzaCC2me0Y2ZQUGIu+tCHuVBMmmjuffRpwznYSmdh?=
 =?us-ascii?Q?xcYPzVrqMsPCcJuiqT2l5Ifnxnma3rbpUwWbTsMojsCy40BIkukU7vosChr7?=
 =?us-ascii?Q?+CxzmJLLCGZa3Mz0hqf5R4ZsX5NVxSRD05yC32Q+vsrbYGhXtYKxk2KRPvx8?=
 =?us-ascii?Q?JgnYbpdM8QdtzvscuHzuNopZAI8zxgcn5NJL00VgfzGD6BV8kTMiDN8puei5?=
 =?us-ascii?Q?PNJl84A5FWGlaT4lYbZmDI6Q?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a8447fa-90e7-4441-3185-08d946551fd0
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 23:22:47.1698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6eXiheuKR0vXelUzaz+StHG3jJI176JChFPenohfG051REhC69cvP9AEY0wKMzdD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5158
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 13, 2021 at 11:20:12PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, July 14, 2021 7:03 AM
> > 
> > On Tue, Jul 13, 2021 at 10:48:38PM +0000, Tian, Kevin wrote:
> > 
> > > We can still bind to the parent with cookie, but with
> > > iommu_register_ sw_device() IOMMU fd knows that this binding doesn't
> > > need to establish any security context via IOMMU API.
> > 
> > AFAIK there is no reason to involve the parent PCI or other device in
> > SW mode. The iommufd doesn't need to be aware of anything there.
> > 
> 
> Yes. but does it makes sense to have an unified model in IOMMU fd
> which always have a [struct device, cookie] with flags to indicate whether 
> the binding/attaching should be specially handled for sw mdev? Or
> are you suggesting that lacking of struct device is actually the indicator
> for such trick?

I think you've veered into such micro implementation details that it
is better to wait and see how things look.

The important point here is that whatever physical device is under a
SW mdev does not need to be passed to the iommufd because there is
nothing it can do with that information.

Jason
