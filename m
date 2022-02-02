Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBD54A776F
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 19:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346478AbiBBSEV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 13:04:21 -0500
Received: from mail-bn7nam10on2088.outbound.protection.outlook.com ([40.107.92.88]:30304
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346420AbiBBSET (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 13:04:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeU5Apx9ae6nMAFvQVJDpwGu0h03is3KzaA3is8dCFz45iH4SYKNqNNSxAaETPCvhHwm5cFJJmWkhOFKUklPxl7q5rXqhKelojaTE9uUFGS0DCGY7zBrW1lzxSUPZGSp7Se0PlrBYrh9qJYUn0bhLygzsDjxUkBJhA3mtviDdyyOgB7Jfh6yMLJIUtJEqS5C1mWgMCdzk7LPNgCqcZTPepduD0UgtgQ24MCS35DZZDU6C+CwjriEUv8qd3M9sdhQucXyiO2OGz+OMwBBCtc3T5wVThzU6oiIl8LwnmwR6w14poO6V0z42sFKNL6r8xv9sioRA/htYVsAUmRkxxZtvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B9FTfZrD9yA6oCIbjRYOV+NHB+OFYUJ6wx2198JyTjU=;
 b=Wgqk1r3skSlYbBY28/t6LWIlvPhNWZ2iyLy5aLwtSRdZCvcI1/nKqLnDvf8Y7oXgZIubrZRFY+wYjVkxmk7IZZiXf5d76dNBjLa4GYVWRoXXcfpUFNVHk2V+Nf3LuK39677NQvE2GwjIXPyyzKPcO4WMYW/v+/NDYfYgrVTV2cTyq7TmKoKmzUGbvpgjjH/H5/0qUtOqJeAmg8pd2TE1GKgWBFqKZfbNKzPJBtIJo3PKJ+56FU7nZN2zeQzzgSjzDtcA8AzFUxP+KL5dg5+4rwSQxfNiYHG3OwrRc5ry6Tx2wH/h54neBkgbjeTm6K1iKOw5sKkYIWUejGvV8cruBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B9FTfZrD9yA6oCIbjRYOV+NHB+OFYUJ6wx2198JyTjU=;
 b=nVIwfgDfDec5EFI3H8FBc3BGEpvOWTSr2MjrSjypDmwXUrJo7Th+Ripin3/4ZXOGQgC93V+4TbnOPnY3ZT80C3w5LBZnlIodp5K+W4BndYE9VsQiGqH22nEgx4Yb1u5bPlhSF1fkmdX+A5WO4T6XoTs1kGgHbMhtTSYgpM3c1x5s8qUJeEuoLvHybj/UzypNvw4FH0nW7HSsqJ+LyRS4Jp+ZvToo090jSVa2/Tma/HcG+Xb01S39bIu3UU81p7MhtHRf/xEchqY7hFPf3u2sVZUAMp4oRfhskBnAsF7/DjifjvlWRSuBREmIbPhAJVo1kaRu3lkRTVNrV6lmFIAgfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB3044.namprd12.prod.outlook.com (2603:10b6:408:45::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Wed, 2 Feb
 2022 18:04:17 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 18:04:17 +0000
Date:   Wed, 2 Feb 2022 14:04:15 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220202180415.GA2562356@nvidia.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202103041.2b404d13.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202103041.2b404d13.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P223CA0007.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3c67e9f7-e2c3-47d3-9362-08d9e6766db9
X-MS-TrafficTypeDiagnostic: BN8PR12MB3044:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB304419992979D92B7BD76A52C2279@BN8PR12MB3044.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zK8Z1WrdXnqTG6BgAmqB0PxBhD8xDeN7mU6gC+tm50vbo8yhJIdqXAkcdRnJP9KWp7NySSA/SNpLgikkL1EfCCkF4/OiNG4VqXw6ng1I8SUmZbSg2lE2Na4mwqYcfiEE+01t2KbuV4rQOl7SSVU7mYLapwA19g5gydx4f186vdMkQ3DyIKfE8XiZlIMIzqpDhGoHa5wcFHt3c1kSOvWuHw4hzbBj292RSQRKFq2mEFFIBhTDggM47FVNJvsXonC4i3sU/O/WK8VfUOmAf1ZnFJE2Ukwwod0aUuGqLFMnb6vy3lItlDfIMeuuy/M5C0UYExYHPYWhiq0LRNgCYf0/N1Yc12d4CZUWTVu0sdevaG35L+M+d4chnVDw5uCmPq/w4eNbsN159FaXS6kzkOSlZy78NYHgt6grLWO5Jp36i+7+85E8s57O4ScD7Ir5RmNUbOFkpQJ8TbOxGEllb33z5iCtQOxsPLUr+5uGXySe+et2gqPncY92vIeQksYYZalpr60YqWgOux0DkIwFgCyFNrp3p97eyJlpmKae8M/Eirv7fidMEcijnuYYz5S9bT8pfqMDHocJS3d1kAtUJIodA88Ro5Q2K3h1ma7qQroomNfEO9jbD/FHfs1u3scH8gZUWK1ykfZrxkTDvBepTrO8XQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(316002)(86362001)(38100700002)(7416002)(33656002)(5660300002)(6512007)(1076003)(6916009)(83380400001)(8676002)(2616005)(6506007)(66476007)(4326008)(54906003)(8936002)(36756003)(186003)(66946007)(26005)(2906002)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tcdc5Z5Zc0cpuXXICTvvwbUsFgTv3Ep1lOsoikG0Ps8jTWyhBgnKoY7D7Hjq?=
 =?us-ascii?Q?YAWad2yv3BZ9hUT1R6jOJOTzShNGN1b2g4qQKjFoflXMqI7ZxGm30iM3QfrJ?=
 =?us-ascii?Q?nFn5EsBxZocEdv5Owr7Y9RUxQakisybzQNfgWJK169GZWq5HI2IZy9V63sOG?=
 =?us-ascii?Q?Vz5hpaL7Rn6eYqGqw4T829ICR6Xvl/bBj1wvyW1qzXelRJbXQG9IqKo+AHZY?=
 =?us-ascii?Q?zjR5T7NHeyud2bV4LZsHugmIbXFKYcyh+jPzOyBc5hUvzQmxxcJo1uguBDK8?=
 =?us-ascii?Q?KAOGXrO+dUhccC51Otfdw9LZvexiWoDpk96Jug3PU3R6a6mHZbS6hE5HBALc?=
 =?us-ascii?Q?QUESU9ECp1E/noXEBMjPwdIlICZXDOqkVXDmitxLv4DtH9WY1wiBiF6GR1+i?=
 =?us-ascii?Q?l4U1vwvdbYUFs1b8ohfWUuzuY0CLAznCAI5VlAfn2NyBDaoVZQgOG1h6wNXK?=
 =?us-ascii?Q?3Bkj7czmQu1NiEQJwxdPhT3G329tK8pvPcmzV56CDQJA4evrtmZ/6Wjg9J+J?=
 =?us-ascii?Q?6QBOHI1EYG6R7XMQAs5cxv7q0m6s5Y00/ukQawL9mDuCww23HNFh4BycbhO3?=
 =?us-ascii?Q?SFw8MV4Lgz0u9O/RVsLhib5HcjM4656pBlj1DFCXguutrYWz/wtJuULatyAG?=
 =?us-ascii?Q?u81po1+0h2IuXS+imMNQI7yNSxEotbnNd0m6Lq1h4fHLCDIr9QuWEGPtor/X?=
 =?us-ascii?Q?6NIByp+TG7h8QTAJMfo7MKo5ZiCkWIpupZOqEJwgCz9Zz7xhL6XRz96T9BBI?=
 =?us-ascii?Q?AiJ5xxpT5x+8I1pvoDtuhnY1J4Rw2wO7taV6LNoWKP+dtg1bWivg4oTxNVxK?=
 =?us-ascii?Q?orNVu05hpkZC051vHWFlOaVl40fCy4yCnhg6Ekns+ptDZySKY8rrX0wzPsLB?=
 =?us-ascii?Q?Nvijp9ukWWm2FgjQHyBDP1Q+ILPar+jwf2ryf1GDsqiTcKXPen2qC67WGmgM?=
 =?us-ascii?Q?yqzKsoa4MS7C9xAhY6ipqjJXBdtvAj6E/rOf6hGukHv5e54+h4JHLBDxA57F?=
 =?us-ascii?Q?mKmLbEmqWPmwH456V0Nlko5O3nlVP21v8i0As7bT0i/dF9/3rD+5r7IrKawB?=
 =?us-ascii?Q?PIEEgBEnvBAtpw2SzCydCTKzyuze2aFNUDhPRAUTZhLTjNNM7BYnA1nbOw0A?=
 =?us-ascii?Q?ZSmopJRAfmWJtFGI/4DSUuJtmT1jWB4UKUvz1hZtX6NRgVEx5K9l5DfAqm6L?=
 =?us-ascii?Q?NzVDGmuq+qIITFru/lXRRvr8v+bTtHuWDUH4PKU95RF0vZ0p0BYWbKNR34Bf?=
 =?us-ascii?Q?/ev+XKPR6Tgw2L0zu0hyS+QWoMEBUXjs0orU+o2ILoxdbiPU1ixpBMKhB7bk?=
 =?us-ascii?Q?1aboiyEU9dPgFdFSdlvl6pse+drqu4EKPKDR10JH4Uw2havCEkO/4/is8zx0?=
 =?us-ascii?Q?K+shbm8+9XWMWbYixcZtLmm7LN5wRedvWzdTelU2y6UVuDFMY6Q2U/qXYLS4?=
 =?us-ascii?Q?ttt6PGyHz1FUbzuO35WPuFyboJKC+oLK9nGzGaIndycIa18pv1/HXm62MkVd?=
 =?us-ascii?Q?+XhYPrhjgMhkDoWsHtcRzH6r7+O+lU73/rVt5dU0o8iR4pJGP7vLRoskaDgS?=
 =?us-ascii?Q?kseWf+42K/dombkgOZw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c67e9f7-e2c3-47d3-9362-08d9e6766db9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 18:04:17.2306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKWkhy2A4v1+o4Eg2wAOor4cNfS36jXRVJ6XNBb7WTu8pC8pJmR4c2/8f6D6kE3i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3044
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022 at 10:30:41AM -0700, Alex Williamson wrote:
> On Wed, 2 Feb 2022 14:34:52 +0000
> Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com> wrote:
> 
> > > From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> > 
> > > 
> > >    I see pf_qm_state_pre_save() but didn't understand why it wanted to
> > >    send the first 32 bytes in the PRECOPY mode? It is fine, but it
> > >    will add some complexity to continue to do this.  
> > 
> > That was mainly to do a quick verification between src and dst compatibility
> > before we start saving the state. I think probably we can delay that check
> > for later.
> 
> In the v1 migration scheme, this was considered good practice.  It
> shouldn't be limited to PRECOPY, as there's no requirement to use
> PRECOPY, but the earlier in the migration process that we can trigger a
> device or data stream compatibility fault, the better.  TBH, even in
> the case where a device doesn't support live dirty tracking for a
> PRECOPY phase, using it for compatibility testing continues to seem
> like good practice.

At least with our thinking here, we'd rather the device expose an
explicit compatibility data via get/test system calls so we can build
proper infrastructure around this.

Every device will have compatibility requirements and we can build
more shared common code this way. ie qemu can ideally fetch the data
before migration starts and do an exchange with the live migration
target to see if it is OK. Orchestration can inventory the systems,
and automation can select live migration targets that can actually
work.

If it is hidden inside the migration stream it is too invisible to be
fully useful.

This is something we've been talking about here but don't have much
concrete to say for mlx5 yet.

The device still has to self-protect itself against a corrupted
migration stream impacting integrity, of course.

IIRC qemu has a nice spot to put this in the existing protocol.

Just overall, now that PRECOPY is optional, we should avoid using it
without a good reason. The driver implementation does have a cost.

Thanks,
Jason
