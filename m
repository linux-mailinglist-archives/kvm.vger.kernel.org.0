Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604383CA3D0
	for <lists+kvm@lfdr.de>; Thu, 15 Jul 2021 19:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233768AbhGORVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jul 2021 13:21:24 -0400
Received: from mail-mw2nam10on2044.outbound.protection.outlook.com ([40.107.94.44]:4033
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229786AbhGORVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jul 2021 13:21:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gRe/YahjxfC368AtvVekbaOHdw87qf+okCBBaBdY4JdQ/MjAAFR3L0O/3DjB4akgJc+/k1ElkrhyVK0YIKZINcC4UlkKA+IlOHng1+duA47FS6hgagNhlT5vu8VELgImUIN04JYrn0dHE8YIBqITnrobsiSFawqKBpqD/R4TESCfN5Y3/hxh0JaJFD4jUM4H0aw+nrgwzv3I2JjCdj+vpDii47LGFZi5dlRYCGoWnuQ/fRsJEgzHNT/lQn5NKVBlHvZcWQB60Ifmoi71D7KdLA+fDOnUAwcqLsgTMUyXauRnNYFu5IAF4eONB5TiHgK5BDmdCkzwRhZt+NhjJUHetQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFdfjgXpn7ic9hLGG/Q/JiOttTHqvmzOyKgW1RHbdtU=;
 b=oMEH2znCLyrJh8BkIHMDLz7GN8b33lxuLCaQNbifAAyDgRaeVrxX3lMliZnhuw6KAUeGJfBUogZ28zssu5OFDSRDIEYe20U+ndlxNVJk5BE89urimFqSKYQGi8uzqke95Btpu37//DgtVNpB+GIZpY7e2ubH3bkBkmgwEQ4bLuoCZbYNvxnqb0/lQVdWaBKkzVFduX0hFV4q86PT0rE8ctqNEVttNqT8vLNApbIVKDsDAo17X8eoz2k0L6ojIvunio3P5vyDlx8ELIDPxtq2Sho+8LGSbupxoGxkaikjUQ6CtPaI3r4llSJHZ0eRan6oovoVpshCfdgSpRzRYNfsLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DFdfjgXpn7ic9hLGG/Q/JiOttTHqvmzOyKgW1RHbdtU=;
 b=LDnm2Vl3Q46VCtsLDDrlX6JaCbApW25qnMGG/xXhZzJCoTTFaiWLVohuEeGLwcGiKisFvn8OrQo/gvsufp/P6T5LQv8fxyMwfk7kVQeKXqT92QVlvnBZJz3omY1l/XrI4GVtMk+icfNJKUD9H3RyFhjTyZqvIUnMcc98UOx3qruVNfVv7/tFX+gc2Yib7q23xywKElXWMTvwPd6m/Z0EHD16M4J3+e+Frif3hvFBNsl5I0VZAsQDbmnRt3SZ1kvGkzQsLv5RQje/F0TWsNrsKBGB+zgKQLSFOJ4n49MgpoX6eAqYguiE000zVt7tZUmXGOjO3LwIW1CY/E9J72KgSQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5540.namprd12.prod.outlook.com (2603:10b6:208:1cb::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 17:18:28 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d017:af2f:7049:5482%5]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 17:18:28 +0000
Date:   Thu, 15 Jul 2021 14:18:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Raj, Ashok" <ashok.raj@intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Shenming Lu <lushenming@huawei.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
Subject: Re: [RFC v2] /dev/iommu uAPI proposal
Message-ID: <20210715171826.GG543781@nvidia.com>
References: <BN9PR11MB5433B1E4AE5B0480369F97178C189@BN9PR11MB5433.namprd11.prod.outlook.com>
 <7ea349f8-8c53-e240-fe80-382954ba7f28@huawei.com>
 <BN9PR11MB5433A9B792441CAF21A183A38C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <a8edb2c1-9c9c-6204-072c-4f1604b7dace@huawei.com>
 <BN9PR11MB54336D6A8CAE31F951770A428C129@BN9PR11MB5433.namprd11.prod.outlook.com>
 <20210715124813.GC543781@nvidia.com>
 <20210715135757.GC590891@otc-nc-03>
 <20210715152325.GF543781@nvidia.com>
 <20210715162141.GA593686@otc-nc-03>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715162141.GA593686@otc-nc-03>
X-ClientProxiedBy: CH2PR12CA0027.namprd12.prod.outlook.com
 (2603:10b6:610:57::37) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR12CA0027.namprd12.prod.outlook.com (2603:10b6:610:57::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Thu, 15 Jul 2021 17:18:28 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1m450E-002jZj-Ux; Thu, 15 Jul 2021 14:18:26 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 27b25a49-4b9c-4774-d571-08d947b48fc6
X-MS-TrafficTypeDiagnostic: BL0PR12MB5540:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB55408F6FC0C90651F01A4255C2129@BL0PR12MB5540.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V2lZY/EffyBW30qahltZLLGnnz49Xr2CwjMT63X216ZzSBdnBhkL3j33i6sPY1bJI7EvBWfX+YXzarcjiLnFQNtaPBTT7ESipYzBykwtxOq62wudQlZl/En2BiR+jFHYIUwiWjnG/gb+BjtEzJQ7gX53sO1nOL3VYBbEBwxgdB93ELKlRlMvSfFH3V7dS/wpjnwXUNT/q38henJ7pVC27zts5kSGCr9vA8IiDmeaMtIZz/gLO6CMTBd0zExGbwZzX+2/M+O5Jq64tnrkpA6PlT1lSRPo79MKHnk3hxluYWRhgxrfWpuwfBb0NNtTNo4PR5RcX93NYg97DX3hxuRFJHj5hyednUb49+EFOCVbvvr6ziusblrGTMkAboTKeyfwyBuX2O/GlAIuCxlUVtTmOx47ze7HXFZ8DrEAGrA6cxZa0NPuhfTv1rzif66+X3TWAtWteUgndFmCA+aZP0Ty4G8BxtiOkprFsqehUIo6Hky9gOgVCUS6so6ujrsmDJvPPUhfjElw9hbSrx4stgF0L6h5lB+sTujyS1NiiT1zQDAtv32udLY2vGBynF3b/Md580LOEIqHh+h7NHppbF+Es1s7WGgzITc9byrBqSmdYa12JdjSS/jIP+MAAjtYzPSvlJ6ACzE31bJKLLq4dtdiexH6w4DRHhixTdKP+LoLsm/whFuJ8FnoQdQjH0Qzm/firOeQKzGDsRB2mK7M4YvkgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(426003)(4326008)(9786002)(9746002)(2616005)(8936002)(38100700002)(1076003)(478600001)(33656002)(8676002)(5660300002)(86362001)(36756003)(186003)(26005)(54906003)(316002)(2906002)(83380400001)(66476007)(66556008)(66946007)(7416002)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mBmeg97zzuHbpQGj7NlDUdIKj9OYKdFo0ah20IZYhoPXFIiJPeYbvUA2Lz10?=
 =?us-ascii?Q?rBDMOuHYeA71rcdd7qM0LRivUFhqw5KXqVlJP3wTQFAvEkc40MmNq42/Nzng?=
 =?us-ascii?Q?zPl1vTaL2wBIRcSiP7ewk3OWhn5KYBhcT6X/+JkmmvWdA0DRnCiADmUJAQg4?=
 =?us-ascii?Q?vdnipHcc2B1jd893ala0Ax4zIRSIMEoDzOMtCGjf75wLDXMZNmWc4foU5o29?=
 =?us-ascii?Q?KqQjDiLCS5EDGtUTOQ+y803JdpIze4p4Y7+/ml78TfBQjFDfN8FPUAk/KIgD?=
 =?us-ascii?Q?umL95oJ3evqCkX5HZAwLhs6dtC8Pln132wAnUpGi6rsZaMSX+AU0iuZbZm3L?=
 =?us-ascii?Q?GHGO1F5v142P98ErGUgXuShN2ZdabYRcehweU4jVTW/PN69U2g6yXOZymCug?=
 =?us-ascii?Q?kuEBJ55b/Qxo9GPCQjdMt6/MxI/f8kujRjuye0PMJd3aCbm+Sr7cMWw6/eDF?=
 =?us-ascii?Q?owsomyrgAZRsHQNpCdzMlb63fT+N6+DptqBwuXg9vVEZ/lXT5Bl5dsi/F3Sp?=
 =?us-ascii?Q?nc8mbjrffrVW5b6EZQIYxj9BTmmE1Tymd5irTnj24Ct7gKytgja0HgokDbBF?=
 =?us-ascii?Q?TkFZy1KSymqb6qEhgeVeZvedaRqG/0kwZT933IRM1CKqj3mNrH8iiOYeuwr7?=
 =?us-ascii?Q?ccVodFd0c7IHPYa+62lE2EXr/R6raPeq75C3py8nQV4Skgm4Gf82xAcmP4nX?=
 =?us-ascii?Q?trwpiJ/TufDg2gbPfxeKJBn+0a+fGI1pXQz8JWnI/bn17NQ1NbcAB2x2IXiU?=
 =?us-ascii?Q?hurtZPCdUepOAD4E/fxVGyZ50hijcxxp6QBrPgWrSmV4hdJUtmqZPwly/AFP?=
 =?us-ascii?Q?vrd2YCGpVmxROpJdgk1dqa2AYA2/2UxjPaSvNjcwM4PowoJp9gjDvnSuSttl?=
 =?us-ascii?Q?TcPjpcxL3cXl6fGfXkQDFw09AJkewFYHz8f9nSO3fLM146QLriGkMStGLVW+?=
 =?us-ascii?Q?co4ybGiBNByJOmnwYGtZG/oHoynEYYvVvTyoQy0/LWyP4wk/cZshuzse65pG?=
 =?us-ascii?Q?lNVjAj7WUj/N1y/AtrH4JXnkMjNK9qnEkGVQrfMyeHNwT1DJ7zgyXH4mrgIn?=
 =?us-ascii?Q?H5NzUndsizxNcZQm0iT8p9IyUo0yrAWZYD2Vn6p0Hk/Xuw5uZBQNaKWZQBKk?=
 =?us-ascii?Q?04s93t4wVDbwo8Q3g4Itzu7Nhq7/DFqpkVFE9DSq5v178Nu+4cF0F/bX4xyc?=
 =?us-ascii?Q?TDbNtVU/B6Fe7MeTXWe5c5UvF2EaegFJheAyaYRDZY2bgLzJ8RU1juZaNP0x?=
 =?us-ascii?Q?8UU6EmrBlPaCh1gjAuibM9zp3pVb1Q0P7HbolK64m3OpXuPvnKYpvamf5iTQ?=
 =?us-ascii?Q?jjuZOIQBiQYyJHaMvUOu0WZF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27b25a49-4b9c-4774-d571-08d947b48fc6
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 17:18:28.4321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CAQ49bA6e3dfnrix9i7rGiwgMgBxhh7VfmMjVp2RJQZUt36rlg8FoGWQI3ea3IhW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5540
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 15, 2021 at 09:21:41AM -0700, Raj, Ashok wrote:
> On Thu, Jul 15, 2021 at 12:23:25PM -0300, Jason Gunthorpe wrote:
> > On Thu, Jul 15, 2021 at 06:57:57AM -0700, Raj, Ashok wrote:
> > > On Thu, Jul 15, 2021 at 09:48:13AM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Jul 15, 2021 at 06:49:54AM +0000, Tian, Kevin wrote:
> > > > 
> > > > > No. You are right on this case. I don't think there is a way to 
> > > > > differentiate one mdev from the other if they come from the
> > > > > same parent and attached by the same guest process. In this
> > > > > case the fault could be reported on either mdev (e.g. the first
> > > > > matching one) to get it fixed in the guest.
> > > > 
> > > > If the IOMMU can't distinguish the two mdevs they are not isolated
> > > > and would have to share a group. Since group sharing is not supported
> > > > today this seems like a non-issue
> > > 
> > > Does this mean we have to prevent 2 mdev's from same pdev being assigned to
> > > the same guest? 
> > 
> > No, it means that the IOMMU layer has to be able to distinguish them.
> 
> Ok, the guest has no control over it, as it see 2 separate pci devices and
> thinks they are all different.
> 
> Only time when it can fail is during the bind operation. From guest
> perspective a bind in vIOMMU just turns into a write to local table and a
> invalidate will cause the host to update the real copy from the shadow.
> 
> There is no way to fail the bind? and Allocation of the PASID is also a
> separate operation and has no clue how its going to be used in the guest.

You can't attach the same RID to the same PASID twice. The IOMMU code
should prevent this.

As we've talked about several times, it seems to me the vIOMMU
interface is misdesigned for the requirements you have. The hypervisor
should have a role in allocating the PASID since there are invisible
hypervisor restrictions. This is one of them.

> Do we have any isolation requirements here? its the same process. So if the
> page-request it sent to guest and even if you report it for mdev1, after
> the PRQ is resolved by guest, the request from mdev2 from the same guest
> should simply work?

I think we already talked about this and said it should not be done.

Jason
