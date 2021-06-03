Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76C1939A011
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 13:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbhFCLtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 07:49:16 -0400
Received: from mail-dm3nam07on2058.outbound.protection.outlook.com ([40.107.95.58]:61409
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229697AbhFCLtP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 07:49:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OnByn43VBKS2Qm7RgkKj3pV0WNjhcZdLqr9LQvYrw3h9Ttc5RW3ElrySabn+7gaS818Ez4MYgJhvZqGklWWeCuTf+wPDwNsEHOiptX/cxBJ83KcYGCPKNlp45bpS5BWgUZtss1sdOpfZwuY6Vgs4iPt6cBRJsQp7Hl+Yt2QvF2H6NEUwWwFGOol0XZk7cfN/dxQCxNl3QZLt8j8RfvO1nEhwSEQ3k40Qkjm5biIlo0nqyijBvhWlE3peiYTgEJVNUQBRnIy3XZKDqs4wqG2HVpt3uT4r6cJ6R4+OZyc3Hw0TBkbMoW+jtYNJyhnRK7cPzROLdraleHSVd9PRmGPrhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52pJuDjQm6hY4EURZ4nhxcr3EPEKz7SMYyxD+/AzA4M=;
 b=mbnwcTNmxPMcF1qs/6OrnFtRLtt2xGxUEUxLsnQQIXh8BYAr8Qk/Zl/DpqXd8JZEkja+7NzURtn5pWQmmOekf32uj7Xb4PlNCS4N3riAwxboEcv7Sr9mdRwhaTwak71LaN4NBxTYWRp+op4rUuh01btvR0j3VwuPaGNA77dtW3f+qeqzep2c/tv4CqAeoqr9oOvxGmy8ZEq/JSw49N/YpqBUY/H7Ovh2+uKrGLAOYF8nAlDG1CGrAcdqxySYlzE6mrf8/NjGJWAM9BmxiAMnSS0636q/AFa0Alpxczyp3UVgWaizycb9DFNEo9rM4yclr9WiHYTTJCvNHZ9VIuYwZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=52pJuDjQm6hY4EURZ4nhxcr3EPEKz7SMYyxD+/AzA4M=;
 b=cXVUas+nqotNwB656qxq02Ab9JzQjF7OqHYz9pbJtm9lWDyTAXLatShZ6tcGiGFuxIXEKUnAuNi3NR6pdVuQwFDgRvnn55qoXV1SFL6yT+69UY5nSucbzZtGUlizSrNTdCQWt0zP2VBf5PDs/G9xBoCS6+D1586GiKKCTVYj1QxoJStvYObYQWgyvRX5F/UHTkr+HIGmxDgXK3g3V1ODTt29K0x1lV+flItCdoNRy0F3zeKSXDWPYgQzZQGyYmOng6QWbwpsEH55EvzEJkLye1sdoW1wlVgNBkeHOhvnvpVWZWWEhOqmswuBQXVBAnRYpHYYgloSG6HHMF7hQTKF9w==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5189.namprd12.prod.outlook.com (2603:10b6:208:308::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 11:47:29 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 11:47:29 +0000
Date:   Thu, 3 Jun 2021 08:47:28 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603114728.GP1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <MWHPR11MB18866C362840EA2D45A402188C3E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210601174229.GP1002214@nvidia.com>
 <MWHPR11MB1886283575628D7A2F4BFFAB8C3D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210602160914.GX1002214@nvidia.com>
 <MWHPR11MB18861FA1636BFB66E5E563508C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YLhj9mi9J/f+rqkP@yekko>
 <MWHPR11MB1886E929BD1414817E9247898C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886E929BD1414817E9247898C3C9@MWHPR11MB1886.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL0PR0102CA0061.prod.exchangelabs.com
 (2603:10b6:208:25::38) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL0PR0102CA0061.prod.exchangelabs.com (2603:10b6:208:25::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 11:47:29 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lolou-0013zx-29; Thu, 03 Jun 2021 08:47:28 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cc82f7e-d59d-4e7f-3bd3-08d926855d97
X-MS-TrafficTypeDiagnostic: BL1PR12MB5189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB518975B45AFC7B51D88F36F8C23C9@BL1PR12MB5189.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C+qsBfeeoMqpPbBKOJGXhxnlXsE3Stldeix9qBTTb2iUMe6RpcmQGHXr1id3/S4MkQCuOIfmzk2IjFEZPhAz8DrzG6YBpiDqT6HUwsfYS2nEk+t9Ndo8av2yJHqseOH49/9Y4asNTFItwPXDh1DVR1kE0SZyif7neIBeHYu68wHF2Ymv7wbW2rR8Wu2/+VxmY0LCK84k+HdxMBlSPjBIW9A0r8FHz/ELt2FIaEYIGcAZdugkoQ1esgoKzp8r4SIl1Mx9QiJ+9/8zmF2yQIzTjX+b/at+Pr0LbsYh8dNxfHV0aq4B7ot4O5kqYfaCfllquayMoKFen0O7vQQEi2MyFFIKPbv1bLJCkyOPyjsFCCHE0fAqCbIuGFmGxCItimYLJw0oMeIiUe9PY0/9k35P4Jy3UYhzTqmsFraBqBKNGWrGApDJfnz6tEI0J+JhdT+1kS+2t+mfikHtdTDHaVAywo4edEZregJD4oakTB6eMwzRXuhTsdrV9F6g1yTSUZYMgMmhsCxuFPnOu14Z/cwT0ib1IE3gvOAvTHcBRiXsvtw6uYM3R80RLHMi4PJTv1SvS7yDEMySAQ31Z1OsNgz7V6dFiJv1OtHWFE/hXxt3s6A=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(1076003)(8676002)(9786002)(8936002)(7416002)(426003)(4326008)(2616005)(38100700002)(9746002)(478600001)(2906002)(66946007)(66476007)(66556008)(36756003)(54906003)(6916009)(316002)(26005)(33656002)(186003)(83380400001)(5660300002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6pr9Tu8eLewtymqHFg62fG4IUzEX4phHN0P2IyNcO8+kqEijcN6Tw1TXSluC?=
 =?us-ascii?Q?FBqlOOcYkwJK+uzkLD8xNy92QSPzDqYuayWXWB5I0BlKBZtevjx0WmKukkfu?=
 =?us-ascii?Q?xF8txMM8GKv78Miix15SYUFmFVW1dTFH/RYtS17NKl476ijHzSd26dm1tnV3?=
 =?us-ascii?Q?hfAz33m/zJ8HeB+4neAXHcej10/qJaNhBgSPV1aoP0Gwbbbn+1UbUbJPouLC?=
 =?us-ascii?Q?rYf/39ZWZdrjZtogInAUFNTeh1a9pWk8NyqB0YJEBaBzJSKDdW7wTLo7Pooc?=
 =?us-ascii?Q?Ks7iy+IOIHI1Qd/rfjri6Oh7F87lTQBrJ0z50V7S43p7g+xT/9johkOvK1YV?=
 =?us-ascii?Q?O+YJe3HKFUSq2EB9d2NPYIwc3GHu/RBgpwLtKdVUqp2kua6ez0ExKd4CUeZy?=
 =?us-ascii?Q?vWvAINitAJY6sZDFiUXPdL8LWAbsKg0468FrVg1MbkzrLU4re34LlA0gVx/3?=
 =?us-ascii?Q?488F52r0d6JvUtPojlcbyb/s0l3kYjfYNqGIt9x8Yir8u1CrAuKyzLyhjl2S?=
 =?us-ascii?Q?ZyDxR2BsDQLSWqBqROer5clUwN/v+9VicSq+YDeGTcICpDawUFRk9ORM2ttd?=
 =?us-ascii?Q?4Hw4Qz6KQ0FaMqkbWQczsAv42HCg/nhKBWusDbsd4u4/Y2ESIvo8L8ahfzzO?=
 =?us-ascii?Q?PPI7ZBlSoaIbOQ9h2p+rZlylxfM/5livnDaAZjKI8Wbc9AumdXe6pRIqr94D?=
 =?us-ascii?Q?Dr1gdbjzGQF68QpVN0kEzNxM17gtdio8o/gDmQxZecem9nWvFhXKCu00CrDT?=
 =?us-ascii?Q?2GSKjVXboiSc9uFeGkn7sVBdebQ6BIG3HAbv9Sk8kXwmTIpiVW/m+HKbFaO9?=
 =?us-ascii?Q?CkK0BiMph14N1b/LWYBCkv2ulqhLaw8tr5STc/V3FgGGrBLeWwXzldJ6wSja?=
 =?us-ascii?Q?P2HiVj4fgGTiBLUUbtcx1mDjUtvkT3jP6EV6R0PVx2PB3oVdgRT+1qJH4SRK?=
 =?us-ascii?Q?FSfXeRcwMNWWXPhmVpgBl9JvCHsM+eo6SuRJ8CqKJa8o75uMZQ2emt+NCyk7?=
 =?us-ascii?Q?jH6AMliCtdVFO8EYDI50yxaylovaYPXxXQgsaDWBj4pyB1u1q/e39K0HtS2X?=
 =?us-ascii?Q?P0YektOEJH0469KIi3SXBz5mdcIZnv7szot5BKAG5W6VqGKdNJF96E5rBxBc?=
 =?us-ascii?Q?8HfnCWA1UqD6OnKTAF5i3XWRvyXN/r/wM1hqMB1BS6TZ+kKiBLb0M+bvyNTl?=
 =?us-ascii?Q?kgeatm2gpL4oYzgaJ8xJedvz0YimtNP1NJJ09KvdMe3y2vTX2QZTNB0BsUZG?=
 =?us-ascii?Q?5k0wXgao9GeTEN6eRfcIfgKyenECDkjMRIeoOFCu5tkRMbRR4X8vEZTr1RTo?=
 =?us-ascii?Q?w+08iAEveGxfu5eemiKZE4r6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cc82f7e-d59d-4e7f-3bd3-08d926855d97
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 11:47:29.3698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CDcXRCtV5/PY3G+9hmAeZqiuQA0cXHO0xHn6E0ZFuRDf+7adE/nAGEJd8rycCTYF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5189
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 06:49:20AM +0000, Tian, Kevin wrote:
> > From: David Gibson
> > Sent: Thursday, June 3, 2021 1:09 PM
> [...]
> > > > In this way the SW mode is the same as a HW mode with an infinite
> > > > cache.
> > > >
> > > > The collaposed shadow page table is really just a cache.
> > > >
> > >
> > > OK. One additional thing is that we may need a 'caching_mode"
> > > thing reported by /dev/ioasid, indicating whether invalidation is
> > > required when changing non-present to present. For hardware
> > > nesting it's not reported as the hardware IOMMU will walk the
> > > guest page table in cases of iotlb miss. For software nesting
> > > caching_mode is reported so the user must issue invalidation
> > > upon any change in guest page table so the kernel can update
> > > the shadow page table timely.
> > 
> > For the fist cut, I'd have the API assume that invalidates are
> > *always* required.  Some bypass to avoid them in cases where they're
> > not needed can be an additional extension.
> > 
> 
> Isn't a typical TLB semantics is that non-present entries are not
> cached thus invalidation is not required when making non-present
> to present? It's true to both CPU TLB and IOMMU TLB. In reality
> I feel there are more usages built on hardware nesting than software
> nesting thus making default following hardware TLB behavior makes
> more sense...

From a modelling perspective it makes sense to have the most general
be the default and if an implementation can elide certain steps then
describing those as additional behaviors on the universal baseline is
cleaner

I'm surprised to hear your remarks about the not-present though,
how does the vIOMMU emulation work if there are not hypervisor
invalidation traps for not-present/present transitions?

Jason
