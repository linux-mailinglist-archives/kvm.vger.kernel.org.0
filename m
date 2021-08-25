Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DD33F79E5
	for <lists+kvm@lfdr.de>; Wed, 25 Aug 2021 18:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhHYQJe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Aug 2021 12:09:34 -0400
Received: from mail-bn8nam11on2089.outbound.protection.outlook.com ([40.107.236.89]:36064
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240493AbhHYQJV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Aug 2021 12:09:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mACu4d7mqtjXpw7E86GwGeH6SUA362QyzrU03V2WOHgavxweMMztt/tV1+mI7lj95EhGa5TA+kJ+uPt39Hk9sYadYvVc08jagxNPXyX0/Z6ffX6nXW4wo1vpdSeMBsetD4gFLBAOhrIDYQ9Szjsn4joFAu4Wbn9EM8abNd6k7pNhmB71o7BXhs/fuf65KJZezRyJZ7nWE36xHN+wYQT9I41GDL/BjtcIyiddiiYWiksi9GJ5uugoqbvoJhIzSleijXpwRCaoyVsI9fNl4cKmHgp27r+cyB5Soh6zI9oztcm6groTBOhinyZKMzFQR95jwZ5/ER8gIcOlcljwpMdQYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZZH9z4vDS7n7dSohoSc9inIUaV+O5E71WLyFVdKlNA=;
 b=b1A87/kYYTaI5fzo2sBJ+a+T56p++i9pOiWimrwVF7/GSzRXGXYI2Usrq9uqDpo2kXdgpgHo0civSKwdnUftmtll4UZNLIxpeySG3HiU2cxRpHKQpRJutuG+RzzLvtLTTyJ9Hror/C7D2cErlnU2h9PBi33uwOy+I/i0j8yVi+ffF+CzRvjrF+/dsRAFOrmjhPyDY9hUKgxMr7Dg/m3+sAyRp5DpgN6STlQrZInucxck7t4kCR2p78/zsd1FHJyHQq8/zWCOnplxizwnDFV4FQLw0nfZQCStBligRxERgmZR+zeAx+5vk71tAgE9UdkDgBHBccZcP6PG4ACeZxPqkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GZZH9z4vDS7n7dSohoSc9inIUaV+O5E71WLyFVdKlNA=;
 b=Z6pMKamExxjubsRepYlmZbm1msX3CBZQ5Smh11beMhCU8h4CTX62KqETKzbInQb0GPWUkSGvlWIsCJ7CWgiqYZ1Pntu+psmcGEDzV7Uet0CRGJkeQP8YXe9XMA2kR3vYRRcCZN5x8IEWLnf2AgszJQQaCvGFelgEvZ/sttuPvyVUeOx+5F45pIbsHogZJc9ZsYcnqI2w8R5D8d0+MjAICCQQDXC5gw/KJuOYcHWYlrCQJSkZGmfg8xf4jBPzrnlfvR/wxCP2TbPAOMinh+QmjAA5l0M6K0+0Rk1JLxSipgWh/jIbGGmtWOSm2LTvjFWuse5Lb6ni08nvWkIW5jtFpg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5522.namprd12.prod.outlook.com (2603:10b6:208:17d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 25 Aug
 2021 16:08:34 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::1de1:52a9:cf66:f336%8]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 16:08:34 +0000
Date:   Wed, 25 Aug 2021 13:08:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH 01/14] vfio: Move vfio_iommu_group_get() to
 vfio_register_group_dev()
Message-ID: <20210825160832.GI1721383@nvidia.com>
References: <20210824144649.1488190-1-hch@lst.de>
 <20210824144649.1488190-2-hch@lst.de>
 <20210824142508.3a72fe4a.alex.williamson@redhat.com>
 <20210825124303.GA17334@lst.de>
 <20210825094819.1f433068.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210825094819.1f433068.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0035.prod.exchangelabs.com (2603:10b6:208:10c::48)
 To BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR01CA0035.prod.exchangelabs.com (2603:10b6:208:10c::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Wed, 25 Aug 2021 16:08:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mIvS4-004yP3-Co; Wed, 25 Aug 2021 13:08:32 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 753abe00-be5a-4a81-185b-08d967e29673
X-MS-TrafficTypeDiagnostic: BL0PR12MB5522:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55226CA5A8490211D6F2E837C2C69@BL0PR12MB5522.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ILHcpPWNcao1Zgnd9AcUJFiwJcjUumUgY3OWz3yEPOSPrk0trQkthqbm66cQ9DK6zWY8FtZrv119KNvqo+9FSliNcpx2bzIcbOsvZesRzVcB+5736N4M7PisOw2Pv8SRlMlv1h650YIpAqgxk12/nXX5Owza5lLJqRfdsB1FZecwMKFu8GXQV7+JB6nQX58EjLFAyYyTvqWSIlylHUj4p2LGS0RwBSjpicmIyhhUTY+CLOWGWHcAUnwme0qB1qsk4zwIwJrq5ad+Tgph+AFyM+oJ1KyGFPgnI3WAucM0CvU+2kYpTJ464aXLbYTaND0+u6zFni8vlVNasvYn3fD+FR2heTPJZxPCc6DlSHJ/MVmy8FpfcAJVWnXRvz7uSJagFv59NWQyi+uub/AGDnkN2JdZ05TKDnWYuqVjE0IazyQ5h7//oFwGeeVXvcP1jXyvRb9RZZy8HoRWdCbcPCNmgl/ibSShVMbudIia5E2PoLkiMTCik2WTqZbLLVHRTU+1pAl8F0bhMjbgnPPbvsGXLRravduFek+P1XsCsJJUFgoVgkhN29BXHxeyRkXoLgoXYxufs0eML+EvZyoBwQjZtTQrtEHD8svGGktJXdmlwTc9e4GK6V9EomcEF1hnnfe2CvIspcXhDzVDes6XEO7k6Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(396003)(376002)(39860400002)(366004)(36756003)(2906002)(9746002)(86362001)(9786002)(2616005)(186003)(54906003)(66556008)(5660300002)(107886003)(66476007)(6916009)(8676002)(316002)(1076003)(83380400001)(478600001)(4326008)(26005)(33656002)(38100700002)(8936002)(66946007)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vtI9WdeSeAuK0Oy71gJqhMrm3CWLuB73ldvcynGsjhDKOzmy2EcATCEBzraj?=
 =?us-ascii?Q?f39FOq8aSPsZDe4WZSCxSZOO6b3qWyUl8dOFxbwByy2QpGwBdG46RaHv576T?=
 =?us-ascii?Q?2HIfBhv4wdK45amXmDcOjtp9kmHaXRptPdt+UW+yt2NiYDuv7yHzaneVWc3R?=
 =?us-ascii?Q?V2zcRvRWRrsbnPlRfaQWv+7E6aHH666lzQD1K+umHuVsLoyoscQImZYjv8kh?=
 =?us-ascii?Q?ISO2+wVq9BeSDd7FjnPFZ+z+awKnlWdkfmxplN729poe9SehfaGwNoha9RYT?=
 =?us-ascii?Q?eeE9sphmJYj1t8POVUBzrSg7i/lciRpj0+7ZglQLcO5Zb1CJBejYkYCvThU/?=
 =?us-ascii?Q?UBwYKwPt/12Jh+3odivztGm+zBGlDXfm6nStvlMKTh/xvTvNnKkM7P65ymZa?=
 =?us-ascii?Q?TQKh/vF2uCDVsWkKoRn/UfXoNsLY2P/sDwdywpk3d6zAs6TRAri2hKMxOAYb?=
 =?us-ascii?Q?3AYqKcWHnI4dfCFinLCuMjzCRo8ZyTEpYFNophuhx4DZJkDL1oTJBBygNi1s?=
 =?us-ascii?Q?D2d5nwcCtJ60LPb64ycnlw0qI1ZLUUpe2m0bt39EapF3kKWqCDjOpnDKmv8r?=
 =?us-ascii?Q?IX1EECeVMLiwRWxTuSbgNQcXCY61eczQBG2szAl3F2WFmEoZoxXc7gOZjIkI?=
 =?us-ascii?Q?oQt5CVdp+luFwUQ/tU0f5Nd9iQDRF+WZFszAf/br9FYzmmIRC0JjClJS2ehQ?=
 =?us-ascii?Q?9Re/NionU6inuf4FXt5v5iW5Ukm19dD0FXn+qPzIJXertj/3fKq1OAVXCGt2?=
 =?us-ascii?Q?5GRJzVW/t09UxMf5cSdS7MoJHiKLS/AwLsM1hdVM9CBJA4nOj/5d97Hp28Zi?=
 =?us-ascii?Q?cfVoXPmw1NRq+DWU2NkAdfKpOgS63fm06e5Qi2fto4FFaENjG0ZB+Xgx56+v?=
 =?us-ascii?Q?km0NCh9U8F7DOaKaPriQtiv1ZXRbyqvzXtj9CtbRYV8LdjxSQI8MIbKxz27R?=
 =?us-ascii?Q?2ilPp5PVltDI3+B8JHA+Eq4asV8zutOCcpl121R1pbeB4o7JYfXIByygiBOU?=
 =?us-ascii?Q?OWB7RxHPDJQc+gsLWs/5aiN4HG27GeRAGaBfVgBPxyNTaqdN3126LAYDqkM/?=
 =?us-ascii?Q?Abu0iFFbI8d34FWRBDURb49/FqRUFCJ5CuyrBVy5iba0UEQDqbmxbUvztNFP?=
 =?us-ascii?Q?Ov9iVHrAQuxv7Ik1UxsCKkMbtevpMFIz+T7WjWOnJy2Jy3jwePe75Qg4IBWS?=
 =?us-ascii?Q?bYC8vYOTfLX94fhmlN/EGc5xiuSvD7Jehk9lLeOZuidmQ/XD3Nsk8ZQHFKXO?=
 =?us-ascii?Q?g5xVv2O7/el7l8I412umMiObz3rtyy82CcI/6m4RCJ7fufAMP70nJYwHakNG?=
 =?us-ascii?Q?UQ3kkDZGMKwrUjXtoiFZynmz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 753abe00-be5a-4a81-185b-08d967e29673
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 16:08:34.4096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rMR3YsR/Oqs7nL6seED0VyY8BqPVvHccSNAKpa+74EB3DDdmp+Bv/2w2J9PBQ28C
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5522
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 25, 2021 at 09:48:19AM -0600, Alex Williamson wrote:
> On Wed, 25 Aug 2021 14:43:03 +0200
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > On Tue, Aug 24, 2021 at 02:25:08PM -0600, Alex Williamson wrote:
> > > I think this turns into the patch below on top of Yishai's
> > > vfio-pci-core series.  Please verify.  If you'd like something
> > > different, please post an update.  Thanks,  
> > 
> > The change looks fine to me.  Does that mean you want me to rebase
> > on top of the above series?
> 
> I wish the answer here was more obvious, but we're still waiting for
> PCI and scripts/mod/ acks for that series.  I note however that while
> the functionality of other driver's having a userspace driver discovery
> mechanism hinges on patches 9 & 10 of Yishai's series, those patches
> can also be cleanly moved to the end of the series, or a follow-on
> series if necessary, and current vfio-pci binding continues to work.
> 
> Should we go ahead and get final reviews for {1-8,11-13} of Yishai's
> series to get them in my next branch so we have a consistent base to
> work from?  Thanks,

I see Bjorn has just now ack'd the PCI parts so I think it is also
fine to go ahead. A subsystem is ultimately responsible to define the
modalias format under its bus, the file2alias changes are supposed to
track it.

Also I'm looking at past changes to file2alias and I don't really see
many acks..

Thanks,
Jason
