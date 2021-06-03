Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DC539A038
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 13:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhFCLyM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 07:54:12 -0400
Received: from mail-bn1nam07on2073.outbound.protection.outlook.com ([40.107.212.73]:15841
        "EHLO NAM02-BN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229629AbhFCLyL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 07:54:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTZqBvyII4z9L8EWPzXXvSp6d5UnIEt+8QbgF5PvtuQ2UjHleiQEO1z8k2bYPRyYR/xoYkHyeafCHcC1PQ9RelnQ3Jw4hvsoA0BW9ppXDaTnpqbxhv5c+J2lFCf6oB8lM1dysdXdKdhQtzNZymqDZIY5Y2LDqSWy4uXZCN1K9r26XY1m1DBe3E0fDpPKDppjLhNj2QfXVpVJSS0uNuTuaBNrmSjT1pSDYRZkRYyoS6hsGDGMncX1RQlBkRyXMXe1+vtK2c5cQBYNaA6VsK98qnap2jVfRwRXzusuZZti0B7Zfmwe2/Sf55+eH2u6MAb5aCXBllHZoOtASr/70bsypA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfdo1JI8lwggwQ/aQjleEx2IvU2adaBBNvh7RvjON0I=;
 b=V6ePCxbmZKPdjksyIxn7NBMC7t8UnnVSXbf26Kzvzl+kqDrlvG4U3VAC0VhRdYdP7/XY66UxB4LwGTpVgbZ2zQDrglDVi8VWnKkJnCdPyRdgakHh1wRm7aEFAJ932xHoGG3G1MP4x6R0ofCb7yDp4+c9YDBe/LWb+3yS5nr4wft66/fY1wsTdrLeQ9vJAz+g0aW2PwoS3D4VXycTvmWex0+7VnGtIlv4O8rvSoO7pDBntx1N/2xj2cxXBdxMdwH3VwwfrpRcFEDyvCNz4p5b4B6V9Qh1FvuDKDiUKZDaYCpltGrNYgsPaIjp9mLdkGDYjhPn878BgbbMpzTD4aiBBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zfdo1JI8lwggwQ/aQjleEx2IvU2adaBBNvh7RvjON0I=;
 b=dB/YWf4/Du/d0eZzqer3B8UeC1CHoINDv6XR4ceqkRttboSDpiYuNZHWQzXbGwGe46K8S+u1Y2T3D6naqF4XuvCU33A2omKFdBJdA/rzI+C5+ntdYqLJWlE/KPK4TZPT0QQ0R2o76TSMn9giMIBr61Mu4QEUCXuASgK4UDaRUirnNsxvAZvTukzJhoJcv2RkuLI2zuqqM3JoXWobsf5gKFMm3Ljv2MyI/THev1Zj6Zrk1es4h5eeoMihtodf0QpGNpdioHFuzGxoB1k0cTbL4Slq8nqpGcuTphrO8Q67bq1B5GGupIs54ZINgw74B0PgsnsVR4xWJsj6WbeqNPI4XQ==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5363.namprd12.prod.outlook.com (2603:10b6:208:317::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Thu, 3 Jun
 2021 11:52:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.024; Thu, 3 Jun 2021
 11:52:25 +0000
Date:   Thu, 3 Jun 2021 08:52:24 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210603115224.GQ1002214@nvidia.com>
References: <MWHPR11MB1886422D4839B372C6AB245F8C239@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210528173538.GA3816344@nvidia.com>
 <YLcl+zaK6Y0gB54a@yekko>
 <20210602161648.GY1002214@nvidia.com>
 <YLhlCINGPGob4Nld@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLhlCINGPGob4Nld@yekko>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BLAPR03CA0090.namprd03.prod.outlook.com
 (2603:10b6:208:329::35) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BLAPR03CA0090.namprd03.prod.outlook.com (2603:10b6:208:329::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend Transport; Thu, 3 Jun 2021 11:52:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loltg-00145Z-Kf; Thu, 03 Jun 2021 08:52:24 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 15159c70-1470-4a5c-4e24-08d926860e2e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5363:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB53633D61724EF82E52FB8FF5C23C9@BL1PR12MB5363.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XodmQEzUirKZAUXr2IvKHEHBFwea2eKxMRz3/Ml0GKZ0vcuvthcNc8X5R/nufNq5RGDLJs33ZymznHPJNM4BE0oQeKW0IzMogJ4YpjI/RVY2YoDecbhfN1bJgxozwTal2KxqyU133eWdxClybS6aTLqwB3/NV3ANlsT1j2KnNNbgQI4DLVStAqh0/3FxCm9GX4earfsognbF1LOT+/oshfM6wMWBJy/KBcZnNW521VWxQajMt0hijfDto3OE+na0B+IMEU27b+ckBBFsSyOtTuMzcPZyBtTPoc0/Wodo2RTTA4qV77kCybamMABK+4uh51ZP0ZR7NOvPaZ5hRGhfAJ6PTP4km/GqjgC8/S7ccSNQaTx2KYMe/PzncxIK0fSnGh1mx2xMKdbRbvyj3OU/JfClH4yPbjondQK6xc+j23kdB2Gpl0KX0Zd/zRhSUUe2GkWr6melMvw4rok89EZlNDa6nFlQ/ydXoMpNn9Wsrn6cdQKqTcU0waz+8nWz9d4pcBKGEqZqQkXMjble+sSNYjl+ECs6+chZ8RD57YqZfu3H1fbLt7+OoLmPCKVhsT+K2UZnD7k1Gn2zyDt3HEYRWlF7wkiCGsVF8NYUtsisTgU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(39860400002)(346002)(9746002)(8676002)(8936002)(9786002)(66476007)(36756003)(2616005)(66946007)(426003)(6916009)(86362001)(83380400001)(5660300002)(66556008)(478600001)(4326008)(1076003)(2906002)(38100700002)(33656002)(186003)(26005)(7416002)(316002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XjNCsi3LGcJSh1Qs2Amz//HMjoIxnaodrzJFYYpegWoP6CigFDBy5mg0TaIv?=
 =?us-ascii?Q?zlfh3Iwszf86vwxqeDfXOPJUfxhNCAPVhMVxCKcxCH9tvClVSg9kEtplAGVL?=
 =?us-ascii?Q?YhjTulKEpsej9RdaefE213i6+VkRrmqPAhc3vkAyyy6qbjKjFMP91W0+7B5H?=
 =?us-ascii?Q?Y0YCm9f8K2wVcBBjOKcOXwMsoCAr3sgqm0yAB6O9dgllnnhyJtMydIKQL+DJ?=
 =?us-ascii?Q?fTHXHM9Y9X0/mJz41lwqJ8wBjRHMhM/AyHdsFBe2xqpk7ooM/CDc45NxrNya?=
 =?us-ascii?Q?Y3MFhhlDgtEs9XIxdUUu5g1p+nQXJzsMSB57LLo/LflVfYZiCmLlLLst/IGR?=
 =?us-ascii?Q?hIUbw6QpB5aUPRs8I0AkKEOupZUad4l+VS9kFRmYOToagpwH9Vqh5/EyPgY7?=
 =?us-ascii?Q?1JJVhTDDElHhTG+yTIf5jP3N95w9h2MOLsijoXc0tgrHGviWq7ga74k6xSin?=
 =?us-ascii?Q?2wLwmdu5DngOJDfFAf06C1ApjtfABuOAJFO1tJ5bbABrF+4SrK77syXKRAxu?=
 =?us-ascii?Q?Q1bO/tkl2iNvRcL9zuFDI1ItWEForUWDyKetEPk3OnLgXsQVhit1JWJK+geH?=
 =?us-ascii?Q?lPvN2WtVdRGm21PaHPbwsC7Sc4if3ILD4BD58wpqWgu6jn5uZFxZaXWPpFM/?=
 =?us-ascii?Q?wSPWAupYlMnjiHaQKh3tOHK3tqhsBXhsineCObjLqMZ1e1xyYGSLLU2mHWvY?=
 =?us-ascii?Q?1eXTNkLeVxA0Lv9+f0gtDZn8jwFhGC8IcHrbVxuJvBpfOdw6atQBjRjKB7Ok?=
 =?us-ascii?Q?XtWmnvU4jdsUsGkXM5L+Z9n1WU90hTJTb5k86uKyco8wLtzM2lLQA3WMLflS?=
 =?us-ascii?Q?jfMxl/uug5t3cCDr0jKWeJGPfxy1rMQIzgrMXGtRpyLKUxW6xadRakZXgLpz?=
 =?us-ascii?Q?0kM4kDwaRhTUr3jKwzsu8shUU6/06UXrcQrH9VVStNiBRRLD0DTKcwviMLAO?=
 =?us-ascii?Q?Kly4Ei7eG9gtLErpJYkF+disNYyr5pw0L+G7eWXtgf2PXno1fZziBWf8iaI6?=
 =?us-ascii?Q?NanRoFRUvVG29m4o2PtvnOCKk9S5lW6AR8tmmeUi/tYTIBjTO4RtTuJo7HNN?=
 =?us-ascii?Q?MKJ357bDRI0R9vKZUTzePK/kPKbelev3GK6zP22TqrAfpnzY+rrW/v4H4SpI?=
 =?us-ascii?Q?VZqEe6ToUwiJ8E3v6EAAycJFbLEEJGr51INEez5dxXyIJ0DNNn4BdbPFXTSt?=
 =?us-ascii?Q?8USye8E3sVQ5V8LNfq8B95fJcYva3jfQlp0bGVwEk5l/gYpF1AFy8zRUcqTN?=
 =?us-ascii?Q?BTrg5CCJV9mmT0WBlYUbk+WWfl4ccFo245Fvirn7zYZxhoPNUccca4MJV+Ve?=
 =?us-ascii?Q?ISW0rVukVyZMpZkN+0B1a6G+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15159c70-1470-4a5c-4e24-08d926860e2e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 11:52:25.6597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNQ0cdhvW9NK3CeF/1pA+vxue41gOzI2Rq8C6unKJNQ8KChvd7LjaunneL9j466z
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5363
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 03, 2021 at 03:13:44PM +1000, David Gibson wrote:

> > We can still consider it a single "address space" from the IOMMU
> > perspective. What has happened is that the address table is not just a
> > 64 bit IOVA, but an extended ~80 bit IOVA formed by "PASID, IOVA".
> 
> True.  This does complexify how we represent what IOVA ranges are
> valid, though.  I'll bet you most implementations don't actually
> implement a full 64-bit IOVA, which means we effectively have a large
> number of windows from (0..max IOVA) for each valid pasid.  This adds
> another reason I don't think my concept of IOVA windows is just a
> power specific thing.

Yes

Things rapidly get into weird hardware specific stuff though, the
request will be for things like:
  "ARM PASID&IO page table format from SMMU IP block vXX"

Which may have a bunch of (possibly very weird!) format specific data
to describe and/or configure it.

The uAPI needs to be suitably general here. :(

> > If we are already going in the direction of having the IOASID specify
> > the page table format and other details, specifying that the page
> > tabnle format is the 80 bit "PASID, IOVA" format is a fairly small
> > step.
> 
> Well, rather I think userspace needs to request what page table format
> it wants and the kernel tells it whether it can oblige or not.

Yes, this is what I ment.

Jason
