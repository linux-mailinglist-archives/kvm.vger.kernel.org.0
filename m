Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22033372DEF
	for <lists+kvm@lfdr.de>; Tue,  4 May 2021 18:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhEDQVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 May 2021 12:21:33 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:42405
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231523AbhEDQVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 May 2021 12:21:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8VuYBeLL7N51rNX0Yt0G7Wvl5YntHDstn9kGEnhtcOC2lNoxuZYZYSkavUAIX6VA1fEJghxVe60+SU0PqN5ZQigUCJOgZjjKraGVEcu1CxMUvmFB1P6B0rZxK7SUHBRjiTNtpwSSQUBderoGECxHmycAIgs+O1xPRU4Jc7SEEcAyjN6d1wZlGyjJoVTXouMEzNp91PPbWzCqx28KtpeD/pceYiYEFRDNJgfKTj0R/3w0Lv/7JBJAm/m+YkcR4Qzffs6REAlmmEht2FidRtmjzxOglx12myO9jpdOyNvciwP12DYob4BzXoRC/AxdQsy0doXP9pT5eSNrAb+wfYa+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx4Kbi1kwP6z8xRTQfv3MgNnUWKz/OQVE84sFnvSCtw=;
 b=fNCJRoUhlAd1GWVM+hJ1lwQ1Uo2XVo3TpRtf/ddqYOunXiGFe6KOLBfOvMFirijLTzQXkad+Vif2F7cXS61dh8g/vIOLeu8uo5owdmNtJ+wK8kHoyJ5C+sgKO/IE43yqKsmTJdzzRS7lbvBoSU5iRKzQ3LWDirQg5f+syYSgkvyjDqX4kHS8lYyLybFFytpkwtVAYWeWJJX35NmTI2JoIfVtMfjg+OPVowDy4mNyhm966NAC1o/PI9meMWn2ekAFd+Qcdtuy16ytvi/4JNQ2O0YLUpLe2HBClpS0nFguX7OhG067NlavQk5kHlfl9tU/SBNQLunCfokCdKnjtjypjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gx4Kbi1kwP6z8xRTQfv3MgNnUWKz/OQVE84sFnvSCtw=;
 b=dNEqT5zVGvDpKy6l5N5XCANQVa4h6SQtjDaJH6zJdfwGek09+p0jfE4nFU9OrQjPMdNFSg+Yfd+T7PiFz4kG948eeyL6I8tuj7uAps+7k+BF8dmWbkrEZf+BMYrJ6dtfVYTzwrhMubZ6ZAP0F3JXAgh2Fyf3yJrPO9P0nxoyAR4HmPdlp59Hh9AlIrxaT9FE+MlP1jd/+up2ts6G9Vbrf40vnIxpdvYiRpHxi2s0fmS94HpzeHZEpO84r4zrOjnEq0dcs8Z+UCKjfHrk18Domnt7dt5yC0HlxKkXzegT4JOnExz/B1UxR1floUhJOX3hqk6h87LhFCgO9SbhwO0EKA==
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB3827.namprd12.prod.outlook.com (2603:10b6:a03:1ab::16)
 by BY5PR12MB3921.namprd12.prod.outlook.com (2603:10b6:a03:1a2::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38; Tue, 4 May
 2021 16:20:36 +0000
Received: from BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::81ef:d824:43ae:aef5]) by BY5PR12MB3827.namprd12.prod.outlook.com
 ([fe80::81ef:d824:43ae:aef5%4]) with mapi id 15.20.4087.044; Tue, 4 May 2021
 16:20:36 +0000
Date:   Tue, 4 May 2021 13:20:34 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 09/13] vfio/mdev: Remove vfio_mdev.c
Message-ID: <20210504162034.GR1370958@nvidia.com>
References: <9-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060703.GA4973@lst.de>
 <YIkCVnTFmTHiX3xn@kroah.com>
 <20210428125321.GP1370958@nvidia.com>
 <20210429065315.GC2882@lst.de>
 <YIpYnz/isPaXsTYs@kroah.com>
 <20210503173220.GN1370958@nvidia.com>
 <20210504093857.GB24834@lst.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504093857.GB24834@lst.de>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR20CA0004.namprd20.prod.outlook.com
 (2603:10b6:208:e8::17) To BY5PR12MB3827.namprd12.prod.outlook.com
 (2603:10b6:a03:1ab::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR20CA0004.namprd20.prod.outlook.com (2603:10b6:208:e8::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38 via Frontend Transport; Tue, 4 May 2021 16:20:35 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ldxmk-000QzX-4S; Tue, 04 May 2021 13:20:34 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6feab4fa-debc-41e7-3e29-08d90f188c4d
X-MS-TrafficTypeDiagnostic: BY5PR12MB3921:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR12MB3921D3E52C8167A40C3A3AE0C25A9@BY5PR12MB3921.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/EHqEYqT6AVjYS+E4R7i5yvec94B9OrEPOx1Sf9f1q4kXnoFkOnRWOdhDD3El9IAtKJi9GJFPkDm9A30j9nY04mUwvfWMt45eluZ1pvv9A+SnKT7l+sp8sqqzZfipLRsOrWqBBGYNDBKCMsHAWX0a5wIZ0bXeJIbEnZAJbzd1MmENKiX/icKX00yUEEpRXeZyfiMDm7itjmIia1wFTBwQI6+YiGFVWfqCnDOGBF541a5nYLBddcRvG0A2kGI58Uxr/F5vbvLBUATZC0dJ8fUW9n3MKmdYDzeg85cIbKW6M3zFwstfLBYpC4B+12Y6xy3r93KPnUKmcjF6wHFonFNcCWxBfIBXK1ZddmEt9TWAzSND3IWLnkiKryQbdAnrwu8oW+QB0kCWtb9b9KIJ1+1OKqyakbTinahVA3+2xPM5tKqqW8hnRghVwWTqrnr4lTK/b/J0uHMcfcDRWfUgCKXYW6ymKqdtycI3l5YmwTXU+VdJHGHe1g9kbn2udegYjbvjw5F0E/D2S+dAZYmlykKe4S8uenKxa5P8pyNZhuWXANWU4w3Pom8trC6sIrJahlY0jzHLprvUnKOyHclksZP9+/rytEKQEWCoYCTE5qo/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB3827.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(136003)(366004)(39850400004)(8936002)(54906003)(5660300002)(426003)(33656002)(36756003)(7416002)(8676002)(83380400001)(1076003)(316002)(26005)(9786002)(2906002)(186003)(6916009)(66476007)(4326008)(9746002)(66556008)(66946007)(2616005)(107886003)(86362001)(38100700002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lNfsV2WK/DMmhRooB43rjIQORFzGYuotSqfFAUl5CH0Le/prbb/fJ7zm/DXS?=
 =?us-ascii?Q?iMxWm1tRyFWLnFF/t9bm3FlDtzi+lM9xifBmJeDaDrt23AWX5K16pe5XPc1I?=
 =?us-ascii?Q?aroNycS6fEzfMZKsWph17Dptuw+FCfnKYwA/BIrofTT45DZIZSfYu7Y7Py62?=
 =?us-ascii?Q?aGXmJcwqgy0iVE5nkIKm8ADE8g04m6zuZ78YQ9VWJuqBby71/iH6b/7kfg6N?=
 =?us-ascii?Q?C7fjeTTsVRXaRCI11rT8HPwLTjYlYHVj9oFLEux5WQVnNlhKnL0EAlN5eA5b?=
 =?us-ascii?Q?LAo5azNRv/MatT/2FR05AQCoAGgW6ti9Zg9rKUXtaF/PeCEPFfBslGopcJZ6?=
 =?us-ascii?Q?Lkf4cra6iRyJ2Pa0LNqDwpedncb19vAGqKwsTuEUZKroaInMDYixfeUcjRgo?=
 =?us-ascii?Q?1Nny7n9XqOL2b6Hvzaq3haigTQDcVNHqE5kwbKazSc/eJvxrSdU/uup08nop?=
 =?us-ascii?Q?By4dWmrq1cTs9+4nm2b928Pu79INQwEkURrBpIL1CYy5wB+Sv0sBMOLOOgYb?=
 =?us-ascii?Q?iJSH6pU7/LGAwrh3Vg2CASZGPLFq0AQnmvl1ylBpEgmkwe9lL8OkpwkhVlQp?=
 =?us-ascii?Q?5mdK1gD6puDDrqJ+kcv8EYvAS62RopGhASYUkMLQRDRjDD6AvQsJBrWWh+Nq?=
 =?us-ascii?Q?s4abCs5hNZfERAYSAig/Z7IDuAar0RNIX+hC7d5SVv9D/MftGY/Jq3RjD4IG?=
 =?us-ascii?Q?FwbpEaDU4RE/4mHs7IihD3jaE7r2L5mSUeWd97OZNJA5TMU0293+9j4qPkTq?=
 =?us-ascii?Q?200mnQS1dPlFhWDXby4Rh7EteqlzWhpxEaB4E20w4h/gQyFBUTbNldZmYGIa?=
 =?us-ascii?Q?pG0b1go7oOUug0vLprf1wlhsgfCvey4zk/L0wC8f56QCnxLtCNn6tdBLPJpL?=
 =?us-ascii?Q?hjBoRqFbrUDuSH2UXWCp8vyq03ScSkSQqBwD3ZZkBAnHUXy5zHpOh05DvS5O?=
 =?us-ascii?Q?Ct4mQX0IqFmn7u7RwBS5Zxjo32lUxMVpbtarQ0SEchQJvXx9iyGaPWywHAeW?=
 =?us-ascii?Q?FsWrwnWflOJe6NLgLYvMWm5rA3yGx5lbtOQtyS63PC8qaSRzfac8J6dDwT0l?=
 =?us-ascii?Q?iTFDXUceVptOo49D4YIMQotAYJB5n6ntQdPweoGzipqLBy+baCWwHZ870rnZ?=
 =?us-ascii?Q?Wf60fdFxFQGI7foid7+MlXBNd2sjfFJmMtc9xr1YyKrE+twERQMDbl2CwcJy?=
 =?us-ascii?Q?4yK/JBhqWxIu1ksiTDgR4nozq4Iqija5+lgJrrJJf0CtLB+8ucO7gfHrkVZI?=
 =?us-ascii?Q?+Og8Btleiit0v48etnOcq/xPYB+zJfQBQZ9uMtdrre/QE0n+262tnkb3bG4a?=
 =?us-ascii?Q?/plWb+ZKe7OiXW4q1wKKDssM?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6feab4fa-debc-41e7-3e29-08d90f188c4d
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB3827.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 16:20:35.9428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t+LRmERd6UBPPOKXuq5nlsa5vAn6wZi4znA3w3Pb1sBVWr9R37YWKkH/ZZReLPtt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB3921
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 04, 2021 at 11:38:57AM +0200, Christoph Hellwig wrote:
> On Mon, May 03, 2021 at 02:32:20PM -0300, Jason Gunthorpe wrote:
> > Since that is not agreeable I will shrink this patch series to remove
> > the ccw conversion that already has complex feedback and drop this
> > patch. I'll sadly shelve the rest of the work until something changes.
> 
> Please don't.  I'll happily takes on that this is the right work, and
> should not be damaged by a bad actor (Nvidia corporate that has been
> sneaking weird backdoors into Linux for a while) directing someone
> that now works for them through an acquisition.

If everyone can have a solid agreement on licensing for vfio-mdev
modules then it is fine from my perspective. IMHO that needs to be
settled outside this patch series. If it has to wait while that is
done, then fine.

I'm not being "directed" by NVIDIA. My limitation is I can't be
involved in licensing discussions, and frankly after 25 years of this
I'm tired of them anyhow.

This licensing topic in particular never seems to go anywhere. Half
the participants want EXPORT_SYMBOL() abolished and the other half
view it as an existential requirement. The whole thing is toxic to the
community.

> And we realy need to put Nvidia in the watchlist unfortunately as they
> have caused so much damage to Linux through all their crazy backdoors.

Well that seems impractical.

Check the lwn statistics. NVIDIA is fairly regularly the 10th largest
changeset contributor. We have > 100 people in Mellanox writing kernel
patches and we employ several kernel maintainers now. If the
NVIDIA/ARM purchase goes ahead it will be get even bigger.

All these big amalgamations of people seem to have their unique
challenges, and I'm not convinced NVIDIA is significantly more
damaging to the kernel than Intel, the Android world or other places.

So, let's not paint > 100 developers with such a broad brush please.

I prefer the optimistive view: Mellanox's continued open source
success will be inspiring.

Jason
