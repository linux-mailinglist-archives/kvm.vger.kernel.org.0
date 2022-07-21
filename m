Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0427457CD86
	for <lists+kvm@lfdr.de>; Thu, 21 Jul 2022 16:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbiGUOZB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jul 2022 10:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbiGUOYq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jul 2022 10:24:46 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2062.outbound.protection.outlook.com [40.107.212.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2B586C34
        for <kvm@vger.kernel.org>; Thu, 21 Jul 2022 07:24:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TpSm50Yxy5ptBtu3vscDLM+0mA20nq3nZTqMvt1eSBKIRenAAa4162qrMmZ4B3SamHYJ8LRQURQae93R2T7ZgW3s7VeNcZvoDcUr+DzhgrpUP9I5LmctV2lYLQdEEXWnCLG6fywLE9EdZBSiUOvoNykmhIpaZ6bk2NrLE2ck7VJqPQ54BkJxaOUWB5jH7Qpm8LjX7wHEY+MAqcvAY/9RPGtGbbDSjRVsmUSi16qjRiSLjlJ9jzGhRvKMdwbsNq5KDigyiHezDc8QIfO/9eKerEkMGxRqlKuz28JMoTBf5scDJrSlvh7r+Hggsg2srBbj87FESiG38+0NC7Iq6V995g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1JYG3pQmBMp+BGETxUR935oIxFP/UUCE2z4IXEGCumY=;
 b=W7rnXnsIwaS/XIUtruzPd0bykOhvs6QRIIWhTqp3biEn42Mwe3luftAWWlIKFFaRo61muz11d2JnS4a1w7BbYD1YwfJFSWYX4Jm6OjxWC8MUSB6CQMsNt9zICzPhHRS3xsQyUmSx3Pd/q0VV+SqpBe389fuS9CZyhCCdSuF7dk3frLu0WKiafBR9qjlank5u3SsbY85pIlyUiQEMrhgzkW+sLEJrhbLKwGUM6eUbBaQxLe8oZebLSbcGM3OyiLwz8CMhpQ0PNVq8uUxsWofg49fyppdDMVI1277NXRTRP+Ys3mModNM+h4lWUALrU255854BmkzVt+tas5bVYJ472Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1JYG3pQmBMp+BGETxUR935oIxFP/UUCE2z4IXEGCumY=;
 b=N0apiMO2e1hE8Ivp8udN0cKvd2pFrYjzbIvd0tZq9s2mqcHlEBFj2uTJ66iMl7IyPjZRjV9T20Yd+cnBr03uRS9GqREzTvDkANJ2/USAFWIwbhltC0JxSxCcser6f4lIUeWz4wVSw4wqBysdxgIegu0WmweQWhbs28oUyt4QJTWl01Ajqi4AIr5HGfxHrFIwAYncX2BZUfJhS8JBjbcwa284Hjw2nMw0dVn76GzW0K6KxvcCA68wScN5Bhp3cFkDSkIbxYk41eZCaqqpYQWNN4ZAxgFUSyv+PaiHr9C06lskuMAkMRMzz0ruaZNVFr1NWe4WjyUarQvirGkmGvywZg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BL0PR12MB5523.namprd12.prod.outlook.com (2603:10b6:208:1ce::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 21 Jul
 2022 14:24:22 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5458.018; Thu, 21 Jul 2022
 14:24:22 +0000
Date:   Thu, 21 Jul 2022 11:24:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Eric Auger <eric.auger@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [PATCH RFC 00/19] IOMMUFD Dirty Tracking
Message-ID: <20220721142421.GB4609@nvidia.com>
References: <f5d1a20c-df6e-36b9-c336-dc0d06af67f3@oracle.com>
 <20220429123841.GV8364@nvidia.com>
 <BN9PR11MB5276DFBF612789265199200C8CC29@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220505140736.GQ49344@nvidia.com>
 <BN9PR11MB5276EACB65E108ECD4E206A38CC59@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220506114608.GZ49344@nvidia.com>
 <BN9PR11MB5276AE3C44453F889B100D448CC99@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220510134650.GB49344@nvidia.com>
 <BN9PR11MB527693A1F23B46FA9A26692A8CC89@BN9PR11MB5276.namprd11.prod.outlook.com>
 <b97658a2-2eb4-11d4-d957-e7d9d9eeb85b@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b97658a2-2eb4-11d4-d957-e7d9d9eeb85b@oracle.com>
X-ClientProxiedBy: BLAPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:208:32b::17) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1c1272f-005e-4693-339a-08da6b24b4c8
X-MS-TrafficTypeDiagnostic: BL0PR12MB5523:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZtkgQrhbdrjsaaG3SRLiLXoNc7XCsvkEmWJeF7LihBGy3zQtUxT4eTYtYKkZS7Q0PViMTm8kLCJNPApF4Ggkds/fi3rpb1h6/33G/3uCvgZjVB+gJk4D4iar6B6xwb3wTNXj26w+OsWxnbb1WJ0RZWttVSGbDS7kjYRLFZtWtZa+YL2qU57ICQkJHoiCZbeA4kb46fD6LeSclEc4Fb4B9LCDk0smhYmImeOjdsIEB01aBXCbJN06K/YAAFd/Gp9ucZ0mXBO7sfo2VLeW3d34kZIYSadXVofEIFkGVfmpFYmOVUWISoATP9ZOzYl7k/R1evCKkaSz0dQ1eNMGI8tLPunykyG5JtuUrpy4Lc3/d5owQ/er7+59Mp4KnWAbpJou2JF2xY3keuLuZO8ctRFI1CfeyjiNTSjBK+xouQLxNE+OLxtDuvthbu/tVvB2PLRy8xCLg0qcdcGXMEgtxZF+X9po2Yi00z0gwBi+4d9hyI7/FUM/QvspgAqxf7Z+9Lwa+Chdnp0sjuyBjX3cDNl5VP7GYAisV5CjW/eT8kduAruGMYh8kJFcVMKXdKvLhVqSZtySWIsBEWbiqhuCBJiCChTWUuomKqhwgOM8RbnTTThVFUONZCfHPKiE+AdamFMX6bYePJBQqKduTimE9q/iX5eQkPKXT3ZXyQOgFoe7YqIW4fjo4SIg7Fpk2D4+8MT+Lb8I+5EvhwSpozY2piMmWGvYz8U/XDV7wWLhgsnmSJoFVBkerhIcHiBJh+yJwfwywZktEi/DZ9D4MOZl+v/PJDqjdNggNtDqULrkKQ7BLbc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(1076003)(26005)(6506007)(6512007)(83380400001)(186003)(7416002)(478600001)(2616005)(2906002)(5660300002)(33656002)(36756003)(54906003)(6486002)(41300700001)(6916009)(316002)(86362001)(66946007)(4326008)(66556008)(8676002)(66476007)(8936002)(38100700002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Al/TVeNMWagHPM1RMs+P9dxFdmIg0G0tuhhT0VSx1Qdi4wcn6nEiMPIlJK3Q?=
 =?us-ascii?Q?bwq0R/MkiJfrbazySrCNd/04CVzqt9LGNYkm9fRQ8CFYVBQX+FZ73nK2xxRR?=
 =?us-ascii?Q?mzxiAqB/LKFn2qujRZFQ3P0+cUvJKL1i9XzGTNBlJvFft1kHpliMtZM71uB/?=
 =?us-ascii?Q?5bZkHuG7YxzQyKUqUfoqa2xzcrA62g7bobPeNWLcQG8RvyuO/Y7T+/1FK5R7?=
 =?us-ascii?Q?//tTolmdKzGsl/DH/5Dd9BnMy/FLxrvrkFHiuThJ/1gP8iEKxS6SvIiw0phf?=
 =?us-ascii?Q?ug1qq84cIOzi+Qw+8xvre5joHG7JYOC90i62aCPfrpurH7BGG3nxzIKNvT+m?=
 =?us-ascii?Q?Zw4Q3F06G63Ekwued+/6ELlAfptVh+vh7CFGs/tcooOZnb8/RjKhEGx0Kem1?=
 =?us-ascii?Q?hmXmhT9hgVmPv1luMDE9zQsOgJ/U5Sd3xw6pCn87DQSbUNzUQ0asmAJz8vn1?=
 =?us-ascii?Q?a3c5Qw6eRCkf4OSHVtcTJSnbnA5lnNJ8lUzXKdPYhg3NSkK5pqDeI6CzerG6?=
 =?us-ascii?Q?4ZxpxBRZf0csiDM/neGYasC6qBXk9wnshC8ySeT4fSGwEcRQLx5a2K7l7gYY?=
 =?us-ascii?Q?WjR1KuGN2fr98T3STZnAZ7+vDUFYu5EyOOgd0BeIrPEiGBtTQYAzPuaKqfBS?=
 =?us-ascii?Q?sl4rNtPSnWD8MPrXdyACnWHDcCGqKIpKLwNsrEZ9h19A22/gi6M+tAQe02aJ?=
 =?us-ascii?Q?MBkkpNBx4deJWExFZ5RjMzmLDNqMVgeCaaDu6GweWahR6RKpAttgEYNQC9ZR?=
 =?us-ascii?Q?J2bqC8FUE0oZCxBUJzUFB2yNYazk8KBKTUjMAdwTTGVFtvRi2lDa2MBYNW5l?=
 =?us-ascii?Q?ngOgHkXchffaeC6LRgaL03O5z4o62Lrdtdl5LjRioS1keHSn4r9+nKl3n4qZ?=
 =?us-ascii?Q?l52x3iEjlzdXtW/gkH7X2m0yeJqTK2dNz7nsV/ZHXb6G/L3GY7/FGjdg+B9C?=
 =?us-ascii?Q?o1a9iWatCnpwmgf2+unZAdJIpZseitmcB1pCfkMHEUejkgGgUHJfsr/kjsri?=
 =?us-ascii?Q?/p8ZBzZwVKgpVjp+heDNi48BhSlWfdW8FoI+yWPXAkivp4zo0BGkOAHfLCNt?=
 =?us-ascii?Q?jy1hB+MBbmUHXhsumk965VxvEqBgcxK2RYZVdwwSzMzYJdHgWhf7fCaDU0M6?=
 =?us-ascii?Q?ZHCrR5wGwO7vQoCGoti/EfuDoibVE/+c7OBU4OFVOipXpuC8nI2oQLaa8B//?=
 =?us-ascii?Q?B/Gy5qUc7jW+k4z2g8+HrJlstCW9FG6/AcOyS5lNrCGZrOI4INe7xe7tyLcN?=
 =?us-ascii?Q?ecqPArYZ/HxtBwMaz6n3b9NhTWF5V3v2rwcdcjsE0DOun+z0/ffcD79DK8aV?=
 =?us-ascii?Q?1I83B3Z6JsKttdBAQMTWAdGgaKWZVOksrprV59tjkkonvnKDZpY83Cq0swgO?=
 =?us-ascii?Q?Yk48h7YczjqBmgeOyRzSk5F00a2og5ndL5IfkekHS6RbBAlqVvjv4F3fdbCR?=
 =?us-ascii?Q?EkU03fKndpeJgdSB+GO4NLS1KxsUVqdelKXmxyDhMS1KaGe9wIaRb7RdEd3X?=
 =?us-ascii?Q?8Jwoa92sVLlLNKpzR96WOjfhzbsP0DHCuEdycLcZNhIXysCGUsDUo2UwOZ/p?=
 =?us-ascii?Q?xUZRkuTagqF7r6O6HuPD4EweAKSwv3SBJ3VNUz4t?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1c1272f-005e-4693-339a-08da6b24b4c8
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 14:24:22.4547
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QfwBYEUJbr3dL/JuO0pnE6hs2R7DaTg2utAWcZCNNrAFg726lvtUgGiDiKIOMUTz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5523
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 12, 2022 at 07:34:48PM +0100, Joao Martins wrote:

> > In general I saw three options here:
> > 
> > a) 'try and fail' when creating the domain. It succeeds only when
> > all iommus support tracking;
> > 
> > b) capability reported on iommu domain. The capability is reported true
> > only when all iommus support tracking. This allows domain property
> > to be set after domain is created. But there is no much gain of doing
> > so when comparing to a).
> > 
> > c) capability reported on device. future compatible for heterogenous
> > platform. domain property is specified at domain creation and domains
> > can have different properties based on tracking capability of attached
> > devices.
> > 
> > I'm inclined to c) as it is more aligned to Robin's cleanup effort on
> > iommu_capable() and iommu_present() in the iommu layer which
> > moves away from global manner to per-device style. Along with 
> > that direction I guess we want to discourage adding more APIs
> > assuming 'all iommus supporting certain capability' thing?
> > 
> 
> Not sure where we are left off on this one, so hopefully just for my own
> clarification on what we see is the path forward.

I prefer we stick to the APIs we know we already need.

We need an API to create an iommu_domain for a device with a bunch of
parameters. "I want dirty tracking" is a very reasonable parameter to
put here. This can support "try and fail" if we want.

We certainly need "c", somehow the userspace needs to know what inputs
the create domain call will accept - minimally it needs to know what
the IOMMU driver is under the device so it knows how to ask for a user
space page table. This could also report other paramters that are
interesting, like "device could support dirty tracking"

Having the domain set to dirty tracking also means that it will refuse
to attach to any device that doesn't have dirty tracking support (eg
if there are non-uniformity in the iommu) - this composes will with
the EMEDIUMTYPE work

So, I would only change from your proposal to move to the create
domain command. Which we should really pull out of one of the HW
branchs and lock down RSN..

Jason
