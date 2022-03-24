Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC5D4E5C5C
	for <lists+kvm@lfdr.de>; Thu, 24 Mar 2022 01:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346805AbiCXAfS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 20:35:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237377AbiCXAfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 20:35:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2088.outbound.protection.outlook.com [40.107.244.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ACF486E17
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 17:33:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTjaM64RyN8TanDNCYybRRqhiPp8YB7+5ABIorhDsP5JB+cvuTRQ5ggr9yDaxA+CUT9FKt11Zgg4hqQVfCIDmYQRzJYptbm24d1v+e3l2pKvP2bMuzMaOA0hcWp5K0NRr3bwnmh7YC1A81BMPJJ891+JzCvwT6BSpGEJENCQA82Z/6F5GzSHTUjyLE5vIKkb5RUgtwvtfzMgwv8fB4mGRb26p8Vm8RCa8636mzRUatboQEaiImZfYk9C5z6CObluqlKynDNGA93ILgqCcokjaiH/hfzz0bkEFklW1xiV2+F6RdNn1ZY58CPjH3btN4MYVgyKkp/sXKIMHbB+XUJfqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gTvv8Ft76zbg6Ek+SGWbAEMX593J51FgfzosdomK6vU=;
 b=F8ggEO2EUKWqjccKBphbT7W+7MQ2GHwh0XRlK6ysjU2/CqRMY1/eD3nJVPTiISWqrDf12VrV5Suu6hikym7SG+kHmnI5eV4siJMKkb+XXKphZLKQYMgro4fr+9aACGxjjZh3rttpnEDnrLGN7Ig8OJt+tbFslsufTrrDI3ktJGTD9dxfGLjdQQfXev8kxr31Ng6l6sC+p3yE9hnjZycO/DIM4exbITmc1bC5q7kpvugnz9oA/div1S1HojYXP5vs6YQRykn+jhCvuClRaV+wvdk3LWqNvfEhAiotyWAT7qPXLwYhPUl+dj4iYuEiYdLqplCcY85YF+JtptRNjhGlCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gTvv8Ft76zbg6Ek+SGWbAEMX593J51FgfzosdomK6vU=;
 b=gie+lEUuCVtLfbMz90X+dDVgiBIOh/74nBtQBoNQYHxur6BMReFHTLArgavm0XjJ4nwSYS5CbTzl/dJzDX77oVJgWnFuIlx3Yo5eeLYK6hZ39tadKpq4Zx7J5G1lYvlZfL229B6qsNeBwrJGkIUMlAefYPViJox4Lg4CMuY8tbP3G2G2eQmk351mt7QSEzMvC5V+9eWcU0tTeTS41ivnA4fXknUDFEmcqxVtOlOHQmAJa1qME0eKXblpsYGB+oVSWWD/60erxF9hk9lyDXs2KPyzYNOE9qZ7Jp4fU453PNmCgrmEPuHgZqwMDUYs6CGEYQHjMpYIKkMpm9ERhlpLQw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4762.namprd12.prod.outlook.com (2603:10b6:5:7b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.16; Thu, 24 Mar
 2022 00:33:44 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%6]) with mapi id 15.20.5102.017; Thu, 24 Mar 2022
 00:33:44 +0000
Date:   Wed, 23 Mar 2022 21:33:42 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Eric Auger <eric.auger@redhat.com>,
        iommu@lists.linux-foundation.org, Jason Wang <jasowang@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Niklas Schnelle <schnelle@linux.ibm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Yi Liu <yi.l.liu@intel.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: Re: [PATCH RFC 11/12] iommufd: vfio container FD ioctl compatibility
Message-ID: <20220324003342.GV11336@nvidia.com>
References: <0-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <11-v1-e79cd8d168e8+6-iommufd_jgg@nvidia.com>
 <20220323165125.5efd5976.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220323165125.5efd5976.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR01CA0020.prod.exchangelabs.com (2603:10b6:208:10c::33)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3e88ebb-4cb7-4e26-a257-08da0d2df3d7
X-MS-TrafficTypeDiagnostic: DM6PR12MB4762:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB476295CB65609C78512DCDA6C2199@DM6PR12MB4762.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BSScVDpbgNy0trT9bABQtZeVC3GUyFvl1v/ZZ/k5ydnrkq88G0EuyO9Vpw8eBn/Iyuwyfv/gDzJDSqvSvUMECwlbJ80qxpiesl9VyC0TMhs69SXI0WTtrVvi1Cm6ZoqPoPrkr1xatxqR1NLG0I/I5dSlTFrScBXGGZIeec6IcA3STYoqORwb4jyBPwqACehpU4tS56sx5q2NKkRrEEqp9+baolBWqWAR0t5UYVgg/vG++Qmomvd/wZgWZQXsvZvLp0QxbSEl66viN6uNx6lT8SWeRvtCkUh7lke/iizXmZYBBA31ZAf24TyzUZSL6Yzyz2GBoASF5eIAovXebcme9Clt3Qu4Jg/SW7aDLOxfz9qIro+p2/lKtK0fwkA/CzQTNcljtWoYcAb9KnRuELnelgv0C1FhrqzgIuV9C8hbYDL6bMs8pS135XHIba0mnvbH+P8hvHStioFMdQsq/+birNk6/qVZnAjwmX6tlWMrL+ijZapeV/g+Ex5Ujq00/SWj2NaNddfOvKsxPvLqwmIEMTfrebMdVs1bsi0V7OeHWLoWp0dSSw1AgCX2MG7sPg5JUTksAqN63Hj+tnSEpBoH5gse1M8MWDEDPaUHRLm1ckIqN+i4TXV5rOBPnyynRWhkwYwqNWfRsbT6rN26Xt+oVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(66556008)(6916009)(66476007)(66946007)(2616005)(26005)(186003)(36756003)(4326008)(8676002)(316002)(1076003)(6506007)(6512007)(33656002)(86362001)(6486002)(508600001)(2906002)(83380400001)(38100700002)(5660300002)(7416002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bz9YUfmaU5ZGeYl/Wki/MrIr2ykHl03H9KrgQjZFb3svAYs7WbiBxXeCF84W?=
 =?us-ascii?Q?CrusJqWtdH3x4gMUsj4mEIfsXJjmj56hPNs2c7HnVe72sETj3wBJ2wkMtOHU?=
 =?us-ascii?Q?VvIkMlyDzUDtOxnxfmVFLSctiv3ZfxU6C3Mkl+9g90BNYIlVaTJyZIvx7wuL?=
 =?us-ascii?Q?SjqZo+DxApXyRN31lVkDsQJ9IXcIYDcFnyPKL+L91mtqlMG7nuZd1BjzpuKM?=
 =?us-ascii?Q?WxG2IVAaj+UbO8Zj8bEDnvTILjSStb12pwludTKuB45nO2m918yqiyfMQLtH?=
 =?us-ascii?Q?BgvRl0nzaxjNWSnE3EVb3J+YkrGRXe8FCOnkVDivhvoRVqBUTw5lmWSsJCVq?=
 =?us-ascii?Q?qFdeDPrXwaQ4smTm+rMfYY2L10aG/wm9LnAUGMjBYwuPo2AvI/pR/hv80ElW?=
 =?us-ascii?Q?4YmMEKA0xSqv2068rRm6DQ04UDNQHXHe4EHi7eQWD9QAaUxf7+qvHQKweCRu?=
 =?us-ascii?Q?8UsAzmleTK1OIH/kFp0Laduvf6mGLsVcik8ZOCvssNBAQHE7Us1OKxPcEqnc?=
 =?us-ascii?Q?Ceoh3iaGVYzP6wceuysBE74CwxxrFLQQ8q35MnbeIaENLOzYnS6teWEL3z3n?=
 =?us-ascii?Q?Jp9PWOjqFHBlQ9myncHytnBiGxYORqWZpYDPOoWCfWDcVjxZzjOLB3zdCSMn?=
 =?us-ascii?Q?vawCQOzKYPFxOldYFtKx3DlQqBKTdpYv+iJas18BYBOIuBo8uRD/9CClMdWH?=
 =?us-ascii?Q?lVPfwMmRxnSksjrqCIGrfHlBq9ggABlXqa1+J5ZryN//6bEM1RdwlMC/02IX?=
 =?us-ascii?Q?rv7y+wemK57fA0oxbO4RrOndNjriZTvx8BptmMzVVhFSzChej+VpB+y9EHpE?=
 =?us-ascii?Q?vbvNY8hextNMsL6XDV5ldlaUChNSlGJVtrNkn+bcCQYSDaoVSl2T2ZobpxOe?=
 =?us-ascii?Q?RV5JcNR59/ngshIAniS8kng6WVddpeb1wql9DZen7jyGr0/I4FQWmVC8kNUF?=
 =?us-ascii?Q?63QPta8Q39N4M3+zggznjbTCQa+2aaJQHgWZZ8t7auFEz4IcCGBIyzugiI1C?=
 =?us-ascii?Q?tlyeg3SKzPpdUjwTQ845UtknXPTXuZAJtji6uTonUGC3rpVgvS9sI19NbT47?=
 =?us-ascii?Q?baPZHHl+Au8Yac/SIe8j6H0gsRnt5rj2wm5f+8yuk8a35rbWIwm8yPrTMqj9?=
 =?us-ascii?Q?oIxZyWYiY9tTZQHzrzLHAXRH8f7rt0WhvITB8zmzXBQmf9Zm5ZqUW1PpzKah?=
 =?us-ascii?Q?kUZLteSYtwbUk6CHP7EsN/SQKjYs1QbaA2NDQN5lrXrJNvjxpLXMKXb7GuYu?=
 =?us-ascii?Q?kFDKNvWp0d+Vqb9hrg1HCsGueFFhk6OgP31O+jGIQdctLoCCytTJBBrNhVbq?=
 =?us-ascii?Q?1uqI+DJ68JiGdvAcDF0SreQWZPQtZ+s2hvKpMO6SfrEHSGuigC3M0FoxY+xc?=
 =?us-ascii?Q?3AxM8wdcI2/bjOr0NIHvXBoX0kLk+aH7iMvKgcqzqQniEMP/Z2hPGKdjVx2k?=
 =?us-ascii?Q?iA4V53gL5RVIX63EQsQQDPFSGeO7rwBg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3e88ebb-4cb7-4e26-a257-08da0d2df3d7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2022 00:33:44.3593
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CJ0RdnMv5LUIz4/Z9Vp+nYKmMkTH833C43Blb3EiRlEdSJ9Qes1K4+yi02FYYHPR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4762
X-Spam-Status: No, score=0.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SORTED_RECIPS,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 23, 2022 at 04:51:25PM -0600, Alex Williamson wrote:

> My overall question here would be whether we can actually achieve a
> compatibility interface that has sufficient feature transparency that we
> can dump vfio code in favor of this interface, or will there be enough
> niche use cases that we need to keep type1 and vfio containers around
> through a deprecation process?

Other than SPAPR, I think we can.

> The locked memory differences for one seem like something that
> libvirt wouldn't want hidden

I'm first interested to have an understanding how this change becomes
a real problem in practice that requires libvirt to do something
different for vfio or iommufd. We can discuss in the other thread

If this is the make or break point then I think we can deal with it
either by going back to what vfio does now or perhaps some other
friendly compat approach..

> and we have questions regarding support for vaddr hijacking

I'm not sure what vaddr hijacking is? Do you mean
VFIO_DMA_MAP_FLAG_VADDR ? There is a comment that outlines my plan to
implement it in a functionally compatible way without the deadlock
problem. I estimate this as a small project.

> and different ideas how to implement dirty page tracking, 

I don't think this is compatibility. No kernel today triggers qemu to
use this feature as no kernel supports live migration. No existing
qemu will trigger this feature with new kernels that support live
migration v2. Therefore we can adjust qemu's dirty tracking at the
same time we enable migration v2 in qemu.

With Joao's work we are close to having a solid RFC to come with
something that can be fully implemented.

Hopefully we can agree to this soon enough that qemu can come with a
full package of migration v2 support including the dirty tracking
solution.

> not to mention the missing features that are currently well used,
> like p2p mappings, coherency tracking, mdev, etc.

I consider these all mandatory things, they won't be left out.

The reason they are not in the RFC is mostly because supporting them
requires work outside just this iommufd area, and I'd like this series
to remain self-contained.

I've already got a draft to add DMABUF support to VFIO PCI which
nicely solves the follow_pfn security problem, we want to do this for
another reason already. I'm waiting for some testing feedback before
posting it. Need some help from Daniel make the DMABUF revoke semantic
him and I have been talking about. In the worst case can copy the
follow_pfn approach.

Intel no-snoop is simple enough, just needs some Intel cleanup parts.

mdev will come along with the final VFIO integration, all the really
hard parts are done already. The VFIO integration is a medium sized
task overall.

So, I'm not ready to give up yet :)

> Where do we focus attention?  Is symlinking device files our proposal
> to userspace and is that something achievable, or do we want to use
> this compatibility interface as a means to test the interface and
> allow userspace to make use of it for transition, if their use cases
> allow it, perhaps eventually performing the symlink after deprecation
> and eventual removal of the vfio container and type1 code?  Thanks,

symlinking device files is definitely just a suggested way to expedite
testing.

Things like qemu that are learning to use iommufd-only features should
learn to directly open iommufd instead of vfio container to activate
those features.

Looking long down the road I don't think we want to have type 1 and
iommufd code forever. So, I would like to make an option to compile
out vfio container support entirely and have that option arrange for
iommufd to provide the container device node itself.

I think we can get there pretty quickly, or at least I haven't got
anything that is scaring me alot (beyond SPAPR of course)

For the dpdk/etcs of the world I think we are already there.

Jason
