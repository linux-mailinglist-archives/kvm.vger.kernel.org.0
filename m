Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73B53421A35
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 00:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbhJDWlo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Oct 2021 18:41:44 -0400
Received: from mail-dm6nam08on2081.outbound.protection.outlook.com ([40.107.102.81]:1120
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234828AbhJDWln (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Oct 2021 18:41:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTBgnrHdhrpRrf+ogOSRbie1USsFxBsa7skGb2ZOCpCxzbgD3drwrZpUNer7JOZgtWbcoK0Nq0zT5cTTW77gD8IeAhriNsSzjhd82qCM4pg5xVqPIUY54UKJbROOjPe+2YtN9FtJkBCk19MsTcY3KkbqzsZBNC0Xxv0VoLRCgApsanW4zFq1wbQEEGOjbMVsLR5awQC/26Z74VcKxKYgvi4h6FYLTw/ohB2uNGWWxd+lPg+KD6Y2hnZwlrfT+/jw6DdYyH2qlvr9JyNbB0LBzPaN1plD2uLQsqJOr/l9ha8MLzO5q3xs+jhoS9rcM9Ec/jHOfAee3XKjw5hZRdukMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d4AK9whvlJC5yz40u1vu1a/CWZj9AUqh3DBSRjbFPGM=;
 b=DsZb7LaJumnc4nVa87DYMr3NqtzxL945RwlMTAIt/drpoibltGWZO4yHWurSbt0vxbr85ET8ZeAzo6xXTQlQ3nmccAm5nVqtY/LnyYlcK/a6pci9igPyQBjuR6ii6Us51LyAWCQ6QAhxvfWB0kioAQnqwtdeqMnBcmUFvCwA7ZQD9tZxZc7SYXmz79cQYJ8El8sO4BLHTWB6XFwmjy4SO+U1H1lXr70WnHHJWbFC5uLBy5KvVTdQoxj2hTp+CU3eXO8zaIXzWFVmucuFA8I391HXxdpzffdEwVvvgKH+Q2EmsiVzC/Uk0uT7aD5j57jD4YSb7P0fHiTgFG8XVHeamA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d4AK9whvlJC5yz40u1vu1a/CWZj9AUqh3DBSRjbFPGM=;
 b=iibiYiBwdudSrNRVvz7ZVn6g7+pitaqalkWnuNze8222j5mhZVeB0KLJH8VBpM/3Vh4/x9LYLc8viCX+VF+pD+2mNF7m9AwF+AYjFieEd2WmnWCyjDQh3hiTzUFWoFBsezeRLb14R1xSyEV3YcRlXvIu37EiwdB24gHJAxZEMSXAiBVz/YK+KtfN4drSZ5HJ5EazXWoh74oiP9ZEc6DJlHshL/Pdu3JsL/F7EVJIrmpZeSWss8TO8xiAshgJMPliTORESWRfr2xqTD9PslIptKpnWRtR+Yb4WHFcUtFeOtQqhQ1RXcIsR6/dj0JurBBCvvV1lKsExbmmH3TQh0MFcg==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5239.namprd12.prod.outlook.com (2603:10b6:208:315::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Mon, 4 Oct
 2021 22:39:53 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 22:39:53 +0000
Date:   Mon, 4 Oct 2021 19:39:50 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>, Liu Yi L <yi.l.liu@intel.com>
Subject: Re: [PATCH 4/5] vfio: Use a refcount_t instead of a kref in the
 vfio_group
Message-ID: <20211004223950.GP964074@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <4-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <20211004162551.2a37dfd0.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211004162551.2a37dfd0.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAPR03CA0091.namprd03.prod.outlook.com
 (2603:10b6:208:32a::6) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0091.namprd03.prod.outlook.com (2603:10b6:208:32a::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15 via Frontend Transport; Mon, 4 Oct 2021 22:39:52 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXWcg-00ArUG-QZ; Mon, 04 Oct 2021 19:39:50 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d4542ffb-ab55-48b6-198b-08d98787e1c5
X-MS-TrafficTypeDiagnostic: BL1PR12MB5239:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52390BD8BA1A5B5C8A03318DC2AE9@BL1PR12MB5239.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tq3jilq/tRFL9BqP1/1sTu81Wy2gdSWePsWhnapyGD3xSzAqyuuwq4pT9CJZiCm3VC58B3vPDx31kb9yMKLbFwUmjYSKvwyFyyu/A6u0Ys+r2poOPOkjVBxhJ8mRMn8uJdbUXECbWSyVzTH4K4HtUtkNjteJEj3KxJrsgo9FP5WYbk/r8COIym6LL7HBlgZGWeHBYhZllvkkFrf14BbNCiZMGBgoXX48P2R+pmmk0ri/emhF5GuvYdTEaSpWNFfr5oIO0kF2fBvWtaJtTcxigSnkf1EH9akVCyRf9tC8JlJfJ2i4bLsCC0ei08uBBPA/2qYnCsRxRRgzgqprxi/gk5DdRS/gX4zbKzsYq1aJDCUo0r9zQBsa1xxHsQtqKi3hjaLbuFXsLNHM5LBoZDkszSgs7bCnKTWgxfLXSlGSQ9sTHxUs2gDmPlRIoCgufLQHiy7xH0WDDsI6Ex/rKFWqq4zmL/QG2ajy8sEyYPRvm94X4+cP1DWuQAroLxzvTeVuldOjzrpTkOw2dkbo3toe3wa3dA3InwIl0E+CbVzfeXGfErd7jLZ/vJKCB1wsZ95hsIM6SO+eCI/BN49p4jFZNpJtkSD/hS8OoXajnva8jziDPBrKKei7oneCNH3ZdTBJfavwrJvjhULeISKttnjAici1YrMI2vqTIicjOcfUL+A0Z9C2HK5UEtNnmkLQ3YgjzkmQipMpNK+hgjwV4/Ecww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(1076003)(9746002)(66946007)(2906002)(66556008)(66476007)(2616005)(9786002)(4326008)(426003)(508600001)(83380400001)(8936002)(5660300002)(33656002)(186003)(54906003)(38100700002)(8676002)(316002)(26005)(36756003)(6916009)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D6W+DJxjxMKNIa+dqvg3bgjVqutsId9wyRH9RZopccl9InwKyZzktiXiyAkE?=
 =?us-ascii?Q?eVr3JOzZGrluzvWg8PxqwNKmXQdGBr+nfkchvQ+qKzsYJg8lkZ5GayvAl0B+?=
 =?us-ascii?Q?G1XoUrrqv/RG5B1/bnoZI4QZbKv1w96dA24Hk6IZx5eyATkqI+HLheBHwyJV?=
 =?us-ascii?Q?to6qaNV6vR5AjaHbhGqL7v4hLP98Z/jzZX6EP2d3O+oOTpShh0pumhtRAPL4?=
 =?us-ascii?Q?+UU0CghHabMEl3YSYFO3gLAEQgFG5NvLmomoTi6C5QXhM8rivleTj+xox/d4?=
 =?us-ascii?Q?P0f7eZp79DeFd7+54PG8viudaoWJSeI3arKfEgmdB/SKiF1eB7XXIrz347Pp?=
 =?us-ascii?Q?HO/4dzP/yJL22cRtCauaO8RiJFzNP/fWxYoUEt1yh38fos9p8wX9IuKMXba/?=
 =?us-ascii?Q?1tntCSBfrAIXDfpHYtf0XtVWQTYHmWOL2zWHC1EQzkrtCCILAadV/s37K749?=
 =?us-ascii?Q?BTKqUcbz7EwkCEnZg1dMFG+t4BWHA6GydopnVG7r7Qls8KS0Y07jxfC7Cxch?=
 =?us-ascii?Q?TlkZhWspQ4hnMOyY213KVU4Mo7xkiDG201moWhxDC46Sf2rOQ9YruSdJNzgx?=
 =?us-ascii?Q?WmgCtUhXESqHSmiqjkp4KEOeFPliWH42C3Lw6NZrxDTA+N7lErF5kkMKKJhU?=
 =?us-ascii?Q?nvE67tdqG1B5wtEhnC1TNLfT8cIVfqdlQrdGHUyFg0yt1+rnpOgm9qs1oX7Q?=
 =?us-ascii?Q?uztxKBGiaHNtTdug2JvI/JbUouZKsvaAZL2DcGePN/Lu0e0SxlMKxo7O44FF?=
 =?us-ascii?Q?chsuifnmN7UfffCxQl+sUusM7G8C39Qh5M/MTmpa54qjFaOIORxt8yPv2rc8?=
 =?us-ascii?Q?qwkbehJ6+/SkxvY8pSY0ibqV1FirWkEsGHqmEGhKbdtUiDfmwGwDIE0yHFGi?=
 =?us-ascii?Q?hB4OrLex12M2RmUQEC/UmhszUmgj0IHVG4il4zwkDEkRN+B9YHmGJ3Po9qK2?=
 =?us-ascii?Q?UPe1mgMA28yudw9BO2CWu6jcdROQG3UjdUBDvtvgDKuRcoMMm7xNL7hEO7fp?=
 =?us-ascii?Q?t8QU9YBp/am9kSgNXRxRecw1pEHZ4zmx5zQG3LZvW0/bB1+n2P3YIDKZgXuP?=
 =?us-ascii?Q?X6EUguD9U5MimW+xLjBfikWYzRlafw0xu1bKVRJbLiv02OKeiyOsnyCWy7fn?=
 =?us-ascii?Q?o9AuYQVi7pNqsg7JFF0YZGC7A3U7XMgifkytoOqckGOEwYFU3yqNEopy/1Ds?=
 =?us-ascii?Q?KvHkfgcFsMS8/u4KFn06D9bUCKFKwzMBZIM5MgOYxOqRRARaOiHN4hB9rzgL?=
 =?us-ascii?Q?GgHWoDH/cqD34pCwYW2aTrqb4FPlfLNQ0qKnGmaOfibN15RalwdP/XRgK1h+?=
 =?us-ascii?Q?ZRo+L88uyElqgvtBdMvGOJ8NIjHmtRayI6Bl8Ebiys5/Rw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4542ffb-ab55-48b6-198b-08d98787e1c5
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 22:39:52.9563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M1LX9wAJoYmniG/Pe8Ba5yQK9bMwLTUMBHElY28zk4PK14F8bueaeZ27vl2+A5MR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5239
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 04, 2021 at 04:25:51PM -0600, Alex Williamson wrote:
> On Fri,  1 Oct 2021 20:22:23 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > The next patch adds a struct device to the struct vfio_group, and it is
> > confusing/bad practice to have two krefs in the same struct. This kref is
> > controlling the period when the vfio_group is registered in sysfs, and
> > visible in the internal lookup. Switch it to a refcount_t instead.
> > 
> > The refcount_dec_and_mutex_lock() is still required because we need
> > atomicity of the list searches and sysfs presence.
> > 
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> >  drivers/vfio/vfio.c | 19 +++++++------------
> >  1 file changed, 7 insertions(+), 12 deletions(-)
> > 
> > diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> > index bf233943dc992f..dbe7edd88ce35c 100644
> > +++ b/drivers/vfio/vfio.c
> > @@ -69,7 +69,7 @@ struct vfio_unbound_dev {
> >  };
> >  
> >  struct vfio_group {
> > -	struct kref			kref;
> > +	refcount_t users;
> 
> Follow indenting for existing structs please.  The next patch even
> mixes following and changing formatting, so I'm not sure what rule is
> being used here.  Thanks,

Sure, I generally err toward nixing the vertical alignment. It
generally is a net harm to backporting and I don't care much for the
poor readability of 30 chars of whitespace between related
words.. I look over the patches again and check

Jason
