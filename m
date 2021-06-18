Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1DE23AD20B
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 20:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234397AbhFRSZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 14:25:19 -0400
Received: from mail-mw2nam08on2047.outbound.protection.outlook.com ([40.107.101.47]:2581
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230175AbhFRSZT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Jun 2021 14:25:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gq2Yo8jsAi4ui6PQNWiNFziOA4A1OsAOvTBqGvnHxrs5pfYTHJiTczjdKyu+NZGHThkMEf+ZHPjuoCR1rnjqfleoGdgXKyhi3RIMYOWk8OZ1I6FiHzqwWTCjbdVVk0v77Dl0wvTa8G+2LyL11d+IGZkCTlG/sr66dnbhef91dhfJzB6eUR/OMIt35lXe4C8vxnctm2c14rPoKgceTcmIIIW2UhHJ+TOaQYOzfgBgLy/CgKHaXWOmgBoBeKm+cBSd8xKpm0B4nX6xz7Y/cBgNLGqUUtfF+4DQNy5KpT+FqFa4G6etYUKlMH5lTjhwgFxi7l9mMWqG2fQ6Rv1AwMf5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9lHp+ph22wScGanREMOKBstdL6zEIJG5jHovmKQ0IY=;
 b=cSan2vrAuHo4j9/Aq4g/CzDnb/AEmvaEKIIDM78vs7Dbsf31lx2vNgyfB0ZaPs+vB+otdGeK68bhikCzwstijjePtmN7nichfqznuGA5trMCE65Pi69GCSBdkmnJTGR0yskENKoACJFm/z/O5f/+IsjsjU4vOvQIFKc0WXTnEhuGe29eu7HU7/mmV7nSf/YE3UyNSfrTFVoJ7ZnnRh6zclw4ZOSBE4rW4EqjT9tsxH+3KYNcxg96er1zWPX480f9eXojGQpTgd1D80TjpPGQyPS2/dBEo9J47ofvDSIWAYuv/S0W3q3+fdCPGnI+/er5axbdHNtZA6xyooIex+DCiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O9lHp+ph22wScGanREMOKBstdL6zEIJG5jHovmKQ0IY=;
 b=TIfqTWfSu1myjR3brcckkb9wVRuwxfsOmNi/zNFwaZaxu6s/MfuKN7XKtmB2QhL6IyrO/nydi4y3nwcTyzOgU7XZD754iHP8BGyLdW2345Gz85cPw4SW7QpDOVlKSEWKOpwIMxa6+nB3bm3blsFKRhvOgHxSrLJh1LsW6vYC3hf94jlKIexQtmHdRKubRLqeOAICzCiKDCMqy3zsPyO1kA8vJ9Nwc4/j1kQ2Ua4eqaKJ3e18GOJKdMMZ7VVYnC0d28xSkjmBpkVPauOqQGn88c5gy05PC4X2j9sE59HxVaySFdqiitJ8BOC9kPBOUCFF0CLpb020imvXGAdH5bi1eg==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5094.namprd12.prod.outlook.com (2603:10b6:208:312::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Fri, 18 Jun
 2021 18:23:08 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4242.021; Fri, 18 Jun 2021
 18:23:08 +0000
Date:   Fri, 18 Jun 2021 15:23:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
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
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210618182306.GI1002214@nvidia.com>
References: <20210614140711.GI1002214@nvidia.com>
 <20210614102814.43ada8df.alex.williamson@redhat.com>
 <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0053.namprd13.prod.outlook.com
 (2603:10b6:208:257::28) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0053.namprd13.prod.outlook.com (2603:10b6:208:257::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.10 via Frontend Transport; Fri, 18 Jun 2021 18:23:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1luJ90-008dPE-Nu; Fri, 18 Jun 2021 15:23:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3806607e-5062-45c5-7c4e-08d932861ef8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB50947AC94671FE305C8FFDA8C20D9@BL1PR12MB5094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1CFR0LlLqQ15Gm820qTZ9aup/Y8MK2rC3337kGz5fKBZT8RyF+lNYBXvLKY0Ok6eB61d4ZL4LEGJ92GXZMb6msjy+b5zD3uGM2atY+7skttvjJyVwnE3sRE1SgGK/QF2ma2vwWfHFa+TFgTKqAUmtpl4C4GDiIRC2ES2Zjxdls5ekjWwJ4/8ICg0sKS6lkZ7yc/KNxsfCQguXbYp+eGANKekaMcA00unUvZQBfrquctGp9uq8te+tZETmULJhp9GTiH6DGJHauPUsI5il7KnvFKo/43Saj2Qhode9ZAkMnTndSmgowAC0mmeaUb4VAFS/9jJnlKa6iDUgAmEdY4cGTsGLvRyUQYZWh/LEja9bLlXn9LoS0ObFMKQ2eXJoLgpRdaQ9ComhwBMKpwJtxRlTQDaPZ2m3uABBKodHiqUdEgVRSSO6c50x5wKA7SFNIRMQNAhTTsJ68+z/uxzYCaeUr9O8n0GFbaLSOnIzNoixuXPqneFEfEoNgKkx9gJ/aL/bQly3aD6Cl4NclimzHA8MXyrWsM8Zinew2tlqBSqypXE/gRVy4vji5o5lufkoB5ZAOxKFRlUqK76pefGh0WTUlySzxClY7IuqCftp1wHxPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9786002)(9746002)(66476007)(8676002)(498600001)(8936002)(26005)(36756003)(4326008)(38100700002)(33656002)(2906002)(7416002)(186003)(83380400001)(5660300002)(66556008)(86362001)(2616005)(6916009)(1076003)(426003)(54906003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hkx+2mHgd0cmC/Xm3DCH2UzLv/ZhAZ01H6N0JhfMHNNrL6TpI5NZ39ui6kRH?=
 =?us-ascii?Q?+gc65yRh7ozMK/wqG90F21b8phUqkuuCZU/YROhEiE0eYSXTfFOIFuvQ07Du?=
 =?us-ascii?Q?SUma1mwhWakUnMskvGFvD/GeNJgTDlv1qohkx5ugi0M/1Kztu7sYUbQ7zgu8?=
 =?us-ascii?Q?mVX/ZeTRHiyKaPpqlW/PyaMeaL6CDAFnGBbwWWNRD5gWj9BAF7JsvSEwCjly?=
 =?us-ascii?Q?+9Fv+19ilu7C0/6DQ4tfDvCCe0FAfB4KEP0cxxBO3SwKBReiPKJZFMHhjaBD?=
 =?us-ascii?Q?4uGt/dVezaTeFLDSqh3PgVA8YQrqb54Kv/ByXM73/fkk4rhqzkB7CG/czsTe?=
 =?us-ascii?Q?ao8aITrZU74LxwbFmE8Foaj9ayKSpSdSgmtjpdbcDiC1GxtgpVPWL58sc/Qp?=
 =?us-ascii?Q?AriIyHUJRKRbj92UINYlYKWAW+DBQ4MYTSO7oTWKYsoxJYjvx+UfATcXgiGg?=
 =?us-ascii?Q?u1sN5uTg3753boubFWv7gO17NbXsutDqjS/IcsrQLQz99nWc45E2K/of5RSL?=
 =?us-ascii?Q?fvcmWEt5mBPdNW+xpu/ttqEV/4Ldu3FoPhqmRVZ7PhhqzBAM+q3O7ZTbWaE1?=
 =?us-ascii?Q?eWLAHow15j/P8Z6IFfuepCQLVi/Fm5W1QQsBA29v7HnHWBjwpAhN4YzbmATt?=
 =?us-ascii?Q?6CnXII1OwZIdoasTM9h6NDdg//vvOWfJqBAXYR29T1jJ1XUMa/32zYcocmpn?=
 =?us-ascii?Q?vyk6tQZAjpxZEtVPfermg+nyOexz+6LzHd967omXxzQJYnh4kfe12oQgRcGg?=
 =?us-ascii?Q?IlTtlWeFW12rTnAozjXXhyN5MttShZKdldpkavOJcbZsdEt6J+u79ByuyVvt?=
 =?us-ascii?Q?4bz1CEG9cKeNy/cWKo1cNgu/KFz0VGc/773UI0Yiu9MCpMpPcNcMxLT2WvpQ?=
 =?us-ascii?Q?AHjLU/nHWQnLzUZV1WnGqbIp/5lbr+7Wk7PCmw53FyeKLrsKt4+tWIzQQYXB?=
 =?us-ascii?Q?Oe9lnj+TEX87s1Y2S5ipi1m9P2dCuE5B+LzOeUtXBaG5LbhEdki9Uesiy8iT?=
 =?us-ascii?Q?tskXI0Q5VJEUubv9ut0I4pHfy86Nku54ZWzAt+ctrfbO3pX2X4eOO6ljKXz+?=
 =?us-ascii?Q?Ne/Zz0Biz2p245RYv6+Vzq74xQnKvc7QDxv19hmwicNnqGglvgFtTGOaVrNq?=
 =?us-ascii?Q?GB49Z9rXoaGtCF4OgPPyB7cBmODJ41D6swZaYT8h1itdTYFwnktLXM7qYpeN?=
 =?us-ascii?Q?CAeaISoXPlSeKJSU8i0mhXUV8JmStvzsyLBnoPM3kkRK8xfZ/wXRfUWk5rgV?=
 =?us-ascii?Q?r/rSFyLcC107B6ut1+Xk037YE3XugJcD9xiMK9HcLtFk5raJ+xXx44N0zzPn?=
 =?us-ascii?Q?bndcRTE+bgD5jp5wBxWMRv8l?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3806607e-5062-45c5-7c4e-08d932861ef8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2021 18:23:08.0245
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D//66HPAw+DZPNWogGq084n66QpLp3A+ACL7rS2Iyt52iM2DFck1zxvnvge5Tci/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5094
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 18, 2021 at 04:57:40PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, June 18, 2021 8:20 AM
> > 
> > On Thu, Jun 17, 2021 at 03:14:52PM -0600, Alex Williamson wrote:
> > 
> > > I've referred to this as a limitation of type1, that we can't put
> > > devices within the same group into different address spaces, such as
> > > behind separate vRoot-Ports in a vIOMMU config, but really, who cares?
> > > As isolation support improves we see fewer multi-device groups, this
> > > scenario becomes the exception.  Buy better hardware to use the devices
> > > independently.
> > 
> > This is basically my thinking too, but my conclusion is that we should
> > not continue to make groups central to the API.
> > 
> > As I've explained to David this is actually causing functional
> > problems and mess - and I don't see a clean way to keep groups central
> > but still have the device in control of what is happening. We need
> > this device <-> iommu connection to be direct to robustly model all
> > the things that are in the RFC.
> > 
> > To keep groups central someone needs to sketch out how to solve
> > today's mdev SW page table and mdev PASID issues in a clean
> > way. Device centric is my suggestion on how to make it clean, but I
> > haven't heard an alternative??
> > 
> > So, I view the purpose of this discussion to scope out what a
> > device-centric world looks like and then if we can securely fit in the
> > legacy non-isolated world on top of that clean future oriented
> > API. Then decide if it is work worth doing or not.
> > 
> > To my mind it looks like it is not so bad, granted not every detail is
> > clear, and no code has be sketched, but I don't see a big scary
> > blocker emerging. An extra ioctl or two, some special logic that
> > activates for >1 device groups that looks a lot like VFIO's current
> > logic..
> > 
> > At some level I would be perfectly fine if we made the group FD part
> > of the API for >1 device groups - except that complexifies every user
> > space implementation to deal with that. It doesn't feel like a good
> > trade off.
> > 
> 
> Would it be an acceptable tradeoff by leaving >1 device groups 
> supported only via legacy VFIO (which is anyway kept for backward 
> compatibility), if we think such scenario is being deprecated over 
> time (thus little value to add new features on it)? Then all new 
> sub-systems including vdpa and new vfio only support singleton 
> device group via /dev/iommu...

That might just be a great idea - userspace has to support those APIs
anyhow, if it can be made trivially obvious to use this fallback even
though /dev/iommu is available it is a great place to start. It also
means PASID/etc are naturally blocked off.

Maybe years down the road we will want to harmonize them, so I would
still sketch it out enough to be confident it could be implemented..

Jason
