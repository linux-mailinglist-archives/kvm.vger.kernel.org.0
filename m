Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABE53B45AE
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhFYOik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 10:38:40 -0400
Received: from mail-mw2nam10on2064.outbound.protection.outlook.com ([40.107.94.64]:20832
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229940AbhFYOij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 10:38:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1nzON9ILXEaCxuJCI0yq9ejYOzlsCdFc1zzFV9iB3liMVxaQ6HAhUxb97iwyPG5cTpvoQWpa8DKYd383eTL+J/z/b2umlh/NFCN6BXDmuENT2NQF26QasVZlFColJxm43PM9xZbeuA06toGePmQB0xsKT/SPYXYJv2wSaDnp/J381MA5LXFM8rMd9WdPzqczpXXs25fdac8EJ1IhfWYVNE9dGUYmcSYB3NYg8y2/IL+8v88UL7JGFGHEMytQ1+Oj6C+eaDR/J4xbYKB/C39ySDMgX7dvyjgJ0q8Bu6BISi0pHUD3w1Dl44zuWiqJ2efdoCTVPaiwI0Bs2+fCD+4wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOyIbOl699TjlYnCWB7KFn411bbKptDy0onYdCb0QQ8=;
 b=BNXngiYHLi7UYPxRaUzeEViKTat1mvD2gpCno5T+JG991y+1Ly3qqu7H8Z8pPdsrjpchVoRNDzXqFCk2+d2SDXmPw2UK/Q+ulSWps+8KiZiWRCELXg+GIJLdHLXMZIoWZiY9fxeGulnXEwSsZdS5juZtQvNRuJ76XBONAs6mLJUtfKWk3p01bG15jcDkWBvvajolj9AcmM8igC/RKex/bDxBCycChOlQbKFk0jZiHGSQOLed4vpabaPWqJx3+aBGnv/KfYR3vjsN99Y8ZMmImjaQm7d68mh+6nU8alkmRYQho5hDdY22NzCuG0wLyBveckeXs+UBxlL391WgEAQ8mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOyIbOl699TjlYnCWB7KFn411bbKptDy0onYdCb0QQ8=;
 b=dJlPwco/i2WA3Zb9oe2FwL7kEKaLeyXG6PQ8y2tBcbFMiW9W3NE6LVo7w//kLVLEOCjvq9312dOyw6Qk+Th0feGK2J701zVyuYbSnaQ1ARzX0kYf1FBakldvUlW81dlxprjTzKwaODdRYiDKK7YqBpnKzbXZny1g8R5kaCB9FPMzXPFk3J+Cl1uzuytjJjj/nI5WQNXdvPbWuPExEvQUEQ03f7SQqs+E96uKe647GiRAYw+A+5MLeB7VeNzjiXsezPdv54GMwL7xB1IcRBjpwudyG/VWf+VLAzTYSIRh5be+RQ79RqavBtG1F+6Ipe5+mB+CzPRESv2UaEH1jZn+HQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5141.namprd12.prod.outlook.com (2603:10b6:208:309::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Fri, 25 Jun
 2021 14:36:17 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%8]) with mapi id 15.20.4264.023; Fri, 25 Jun 2021
 14:36:17 +0000
Date:   Fri, 25 Jun 2021 11:36:16 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>, Joerg Roedel <joro@8bytes.org>,
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
Message-ID: <20210625143616.GT2371267@nvidia.com>
References: <MWHPR11MB1886239C82D6B66A732830B88C309@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210615101215.4ba67c86.alex.williamson@redhat.com>
 <MWHPR11MB188692A6182B1292FADB3BDB8C0F9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210616133937.59050e1a.alex.williamson@redhat.com>
 <MWHPR11MB18865DF9C50F295820D038798C0E9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210617151452.08beadae.alex.williamson@redhat.com>
 <20210618001956.GA1987166@nvidia.com>
 <MWHPR11MB1886A17124605251DF394E888C0D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210618182306.GI1002214@nvidia.com>
 <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433B9C0577CF0BD8EFCC9BC8C069@BN9PR11MB5433.namprd11.prod.outlook.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR22CA0016.namprd22.prod.outlook.com
 (2603:10b6:208:238::21) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR22CA0016.namprd22.prod.outlook.com (2603:10b6:208:238::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18 via Frontend Transport; Fri, 25 Jun 2021 14:36:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lwmwK-00CZsu-9n; Fri, 25 Jun 2021 11:36:16 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4623085b-1004-4281-c59d-08d937e6976d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5141919F6011DC2A4ADEAAF0C2069@BL1PR12MB5141.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hhhSOARGWS+BRMOZVWQkWJXwADzMUCnU1pY2MwIBlaXdVqSpYfbY9kYKSeOc6rdCGGZa1LyAXBRq5NKi0LSUYNE0E2TJwI6E/eLZh8ZeO3WBtqhUOPRMtAHSO8Om/pHAxkxbJ5cRF46/9abfaXPEkjdHYen58u/FFt5Bewpx5CX10TJgccBDGtppzzflp6GNa/yT7QHfeS4Pe11DjPPBkUwYD79L8AxczzoIFpdo0jAQwWzP3rWAxXUHaQLiw63zZWGDcgr+0cI9tb51EO/OslJ3DcTwspHlPaGT5NEDUxSLYVUBFjWAGcwAKrtlOL7sz0e8D6itAsPqXXRGxzoHVAJADGUi420DMmkzSRPLwI+UmeWbv4YXItK/Zylnxs9K5NUbsqPFOaPxaLvCUFKWRcOCNXlgQXrJJzFmeIfuEt1TjM5fNv32MkxljtGA6qAQzdK/YCsLW0jMMFNXXKYafPGmfptq8r97HCrpGLeMbAnrxUd+GUUS8Yjw4p+kR6B83gjklmV69thAg4ohMfFFJMCqD5gt4Gi+ZGPkD6bSyJT4kOCh9tjVtTd/4XDCQyKDyuvh7mKBEIygRbnoxeEF4teZqQpdAVXknIGpjIft7s15ihq6Nu9mqKSz9ytjlWjvBm0s8JtLpa2q0rcDKy8eRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(9786002)(316002)(9746002)(6916009)(33656002)(54906003)(2906002)(7416002)(478600001)(86362001)(4326008)(83380400001)(38100700002)(426003)(26005)(5660300002)(66946007)(66476007)(66556008)(36756003)(8676002)(2616005)(1076003)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3CesEwvRv1tcs+Bfo8FUAZR0pf3wbGPmkJk3cYeVU9yrD/+lQkGvo2IxBfDL?=
 =?us-ascii?Q?oCyPGvod/Q+dyiPGGG/nBrOBWnOlafRNI0BMBthhP8f0vzCX48hrUhTeTApm?=
 =?us-ascii?Q?jxZReIQ4fpw2M520Tjzq8z92TthtLeTv7P++O61+uPaPE2SoqgXtEWoRAzma?=
 =?us-ascii?Q?DO9LFLlC688FgCNThzmLEr571VQXQ6S+o1ISyaFrGlOpoXlh7lJQNQjIzjwn?=
 =?us-ascii?Q?sRPr4qPa5yNr9zlZok//apFlXrL5B+QJkGEZ5yLLSgf3hqPksdsFX8WNMsoQ?=
 =?us-ascii?Q?4D9kGHNMeKonz51roaA53Uf0I42OW+u+gB2CGV7owp2YlnLkzjD8lLo6E2zk?=
 =?us-ascii?Q?7H/YEScq4awV3H7Y3o9NQULeS+gzhR4kQ7fTcgzl3/0w5EmzMVE6gD+C9NCH?=
 =?us-ascii?Q?fYTSvZHUwTcwK36Bcd6dschY/EEcFFD4alh/2vyhjxUzEsLNvv9WkBSE3N2O?=
 =?us-ascii?Q?VrEcgX+08t7iqfHGsInmfuTYxd0sln7uK+bVlI1U5PHWRCWP0C4FmSfSMFxB?=
 =?us-ascii?Q?ZiB/6Q9a94lT6RlMAix2awbP4BhTxZDGqb6uT1o6sofxR1jXdAjS0ytwI4+3?=
 =?us-ascii?Q?bXHK56A4uL4Hv3JeU+kHNwYzbewNoqvtoj3FeunDLPRTwM7jzsA8VSik+9Oj?=
 =?us-ascii?Q?mba0S3xjcRWeww5irJio/usbMcTdJFtgyDxOQVthg8OdM6I2z68Ih/kT/Wd7?=
 =?us-ascii?Q?h6uw+kJ0O9EsMYIOV2Vcy2ECGbwowmRgwONwY0NBXRHzVxjl6FejbyDhG4ox?=
 =?us-ascii?Q?WM4B3pQeGrnsTw5FohSClSfAolVOBvMNdWCXYzXodhXlAleHoProYQJ57B1S?=
 =?us-ascii?Q?avyTZZns1kqk9oinnT6xASrub3ADwy7ujxv4K3x9yWqdBo9TEXMlZ8al2i5E?=
 =?us-ascii?Q?uJd36G27+ldeWvLdAFzshvSO1pZxXR+Sob1REayMsc7fNsoFC+Y4hL79i7cj?=
 =?us-ascii?Q?t1rpwKHsAY400vxY7qjeF1/XJlaH54tSKNxy2ajkNUY5B1GM6jc2whj79yKf?=
 =?us-ascii?Q?hV6fP0WOpKdZetXgLuGPtZJCf0Abpo465NRlTCfJ5Dug8k4eBuO722w191w8?=
 =?us-ascii?Q?XSyTufY6gZiJ8htWvie/V9pP2iZu8coIhhey8+cvS/UZcd1pmyTGxLUGi7Mg?=
 =?us-ascii?Q?OSsfSeLNfqaJSIVTs+JJRRJVXIOw4TF4c4MQchO+VcH4Lvbito30SbeTL08K?=
 =?us-ascii?Q?Qwdz2bP6Vypow0MnX6BfmydyDTKEhXoOt7ntoffXqGWRjk0t+s/KVcjtyLmR?=
 =?us-ascii?Q?biuUagqKMKUHjRVqggq7b95zh4oYRULNrsU+s7VQwpWdJ+FstS9pcBiFau51?=
 =?us-ascii?Q?9ERw14mVZxmJo88L/H8CflGb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4623085b-1004-4281-c59d-08d937e6976d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2021 14:36:17.5261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cg58ErIFco73peroYGBhhu6nlbI4pKtoPcalY14o5jokXtFjCoZ2q2n6Zq+RBN1n
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5141
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 25, 2021 at 10:27:18AM +0000, Tian, Kevin wrote:

> -   When receiving the binding call for the 1st device in a group, iommu_fd 
>     calls iommu_group_set_block_dma(group, dev->driver) which does 
>     several things:

The whole problem here is trying to match this new world where we want
devices to be in charge of their own IOMMU configuration and the old
world where groups are in charge.

Inserting the group fd and then calling a device-centric
VFIO_GROUP_GET_DEVICE_FD_NEW doesn't solve this conflict, and isn't
necessary. We can always get the group back from the device at any
point in the sequence do to a group wide operation.

What I saw as the appeal of the sort of idea was to just completely
leave all the difficult multi-device-group scenarios behind on the old
group centric API and then we don't have to deal with them at all, or
least not right away.

I'd see some progression where iommu_fd only works with 1:1 groups at
the start. Other scenarios continue with the old API.

Then maybe groups where all devices use the same IOASID.

Then 1:N groups if the source device is reliably identifiable, this
requires iommu subystem work to attach domains to sub-group objects -
not sure it is worthwhile.

But at least we can talk about each step with well thought out patches

The only thing that needs to be done to get the 1:1 step is to broadly
define how the other two cases will work so we don't get into trouble
and set some way to exclude the problematic cases from even getting to
iommu_fd in the first place.

For instance if we go ahead and create /dev/vfio/device nodes we could
do this only if the group was 1:1, otherwise the group cdev has to be
used, along with its API.

>         a) Check group viability. A group is viable only when all devices in
>             the group are in one of below states:
> 
>                 * driver-less
>                 * bound to a driver which is same as dev->driver (vfio in this case)
>                 * bound to an otherwise allowed driver (same list as in vfio)

This really shouldn't use hardwired driver checks. Attached drivers
should generically indicate to the iommu layer that they are safe for
iommu_fd usage by calling some function around probe()

Thus a group must contain only iommu_fd safe drivers, or drivers-less
devices before any of it can be used. It is the more general
refactoring of what VFIO is doing.

>         c) The iommu layer also verifies group viability on BUS_NOTIFY_
>             BOUND_DRIVER event. BUG_ON if viability is broken while block_dma
>             is set.

And with this concept of iommu_fd safety being first-class maybe we
can somehow eliminate this gross BUG_ON (and the 100's of lines of
code that are used to create it) by denying probe to non-iommu-safe
drivers, somehow.

> -   Binding other devices in the group to iommu_fd just succeeds since 
>     the group is already in block_dma.

I think the rest of this more or less describes the device centric
logic for multi-device groups we've already talked about. I don't
think it benifits from having the group fd

Jason
