Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB657AB5C8
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 18:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjIVQWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 12:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjIVQWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 12:22:48 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2053.outbound.protection.outlook.com [40.107.94.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2A9114
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 09:22:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ALstByxS7UsyBlBMxpZnti+qa88Mn78l1lFvJyd1wQ3qBuKRuEtYf1NMdmYAF521aSVniE0bWTHXPM22DbQaFpeKiS0ZpXD3nwu4XXQvEMhUW81iyOD6aTrylWEwQWnpyiEy3TaVQGXaAUolhv/h9ozLN2s1xyiB+28pGw6MpAaBALNEiFkMLPesyXyaWZvi8+KiKAXnVajcBqRdcE+qHCTyqutoVRgv+vkIzB3ehcMVB1o4l/J0N1mD/wJN+F6C3XUyeY7p+UyTAXwzUfjSjWQi9KiG1tK4YiDPb3b6uNVUBahKHbsSoQN0kQsedZRSzKC7Q7UB4BOZglGR+NNYGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMp33R6g9v5AMh0JnrCxrQKi+jbfW5Fo6Q4kueao+2E=;
 b=I0/mzJulBOqBsbDb8+ATJeqaq91lLU+bspesrf2CdXkU9ZhO2MdKWJoi5En51sAS5YkB7SQmo0acHTZrnyGBYsjlKOEZHqO+iO2zk8vWFTqJn6+l8UxPaQetlDJSE9Tn1ma/TSClfwBbRvutRtumGFKpiLbpWEoQxlJyCspXVNOO3GwMA2o1WpLHE0JeA+i4+fOiXFaMmr2b3Cwk7SX9T5S8O6awltKOnpWd1wVe2lV4mhA8UI1R9UpqNpFHar2aVrddNB71V3lqdRexOhlCXdEv13uhxgUfXzeUNrYkCar4d6ERu9j/r4AaLGHy0B4E3ugf0i5zD3JlBRPqZ/Mi7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMp33R6g9v5AMh0JnrCxrQKi+jbfW5Fo6Q4kueao+2E=;
 b=HCTv6+6DTnuB3pE2np/hZqSpzuynYKQ3imZ5Hg3proN1rJ8nYqmL703oN+tjjPVRJBnhlJQKMvlIUwMveD+pHJIL3Rjolp2ygiJ+gEV1Fq5naKS4Yu7x8vWLWVjm/X6X5ZyCje73sN6wrWdhwPqpw9bT8E0pcI36+qXJACD2d5/7oKN25gRHEkP2X+xCsjhHJ0Pa8L7YMNzfVH7sP804T34nt1HTIx0/9UkyV6rg8dp1cB4VtzURVziT+KDUclvWIfGHX519ehDetcSyDcgolJ+4pYAsRltBh+czS0k7eqSEFrzgQIZ96cF2IhYEjqf5LSA9EaXaBg8RJ8Mc3AHdog==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB5915.namprd12.prod.outlook.com (2603:10b6:8:68::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.26; Fri, 22 Sep
 2023 16:22:35 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Fri, 22 Sep 2023
 16:22:35 +0000
Date:   Fri, 22 Sep 2023 13:22:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Parav Pandit <parav@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        Feng Liu <feliu@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "joao.m.martins@oracle.com" <joao.m.martins@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922162233.GT13733@nvidia.com>
References: <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
 <20230922122246.GN13733@nvidia.com>
 <PH0PR12MB548127753F25C45B7EFF203DDCFFA@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20230922111132-mutt-send-email-mst@kernel.org>
 <20230922151534.GR13733@nvidia.com>
 <20230922113941-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230922113941-mutt-send-email-mst@kernel.org>
X-ClientProxiedBy: BL1PR13CA0269.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB5915:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bf7c40d-c973-4ebe-7dd2-08dbbb882132
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oR2XhzVz/Z/YzZ0Zs5ub6jJqwUkPVSaLZqlLKRXUC/yvnKBvzEwc0TxICIfDyOJHzKzCjZZGICTkNQ98iVGNPauzhhLbU8ulJ8U6EPUs7b5QqNBmns4dSyRsCMmfvK9zghj1tY/++643AOa2xna826rElC6yHO+eS18P3g0wvSqNd05G4tIsZpX9VDmCktY8qb6bC2FKcQ7usmkfe75f3wqktndoDceF1gYU74CWUnaL+FLp6rruwj2BTFed9E1KCbxpR2HEPJTWwFlFFnubNfZGb1kRnCeFlGCiY+gU3v1EOjdkSfJe6rnzOrYm9QMB0QZffuRkIHZkqhPAD4L+K6A1TsqMAmGSBMAKMmOOoWEfsngEQFiDHAQ4uO1qOYolEoBtFZHeCv5MsBYcO0t0b2Q6WldET6arN0JbLIXP8DVX5SBIOAobZa4emPk5egr1k6Tf9RPI67Is/EtYhJWBJ918Qssj0cx/FiWrZAnOIjHjBMEXDgBwZfwj/FPKdgKj9xWhGK2MYUUPGqGc5+FxuTICQMb86AbmZKjbA8d99oveF2H1WpvLhqUoOQw+MUpJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(39860400002)(366004)(346002)(136003)(451199024)(186009)(1800799009)(6486002)(86362001)(6506007)(66946007)(41300700001)(6512007)(54906003)(66476007)(38100700002)(66556008)(5660300002)(478600001)(6916009)(316002)(2616005)(8936002)(83380400001)(26005)(8676002)(107886003)(2906002)(36756003)(4326008)(1076003)(33656002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?611Uf/OldxlAQ437vaOp1FuElY1nYyUEYMdWZ1MYgVepVKBXvJxr5gWoiTzn?=
 =?us-ascii?Q?XVrXMd37mfBp4Ab+PADO1USd3Fzrz7A7/eocb1I0Qmz+1MLNY2WXzsWoKV6G?=
 =?us-ascii?Q?2oyytXJE2ZY5Rxtek6KgjIioWDQAlOu/bGoXU3Xhd/+onm/+VrCZzwrOdLNj?=
 =?us-ascii?Q?Q9AdTp8y+bQchEStM+GbJIOJBXduqz6l3WBP0oQARD47jcSEThtGeygYCb5s?=
 =?us-ascii?Q?rR7igQeGq6/kf1F6ORsEpFp0PjnJLSwK9WGhaQa9J+Sl5ocKDRL7MNp+o2Ph?=
 =?us-ascii?Q?2fqKBNPPMm1D394lPmJP32U0Bs02I7W80TcPB1TtPCI8Xf83+GofUVTd6OYK?=
 =?us-ascii?Q?jxyuPUWoBaTpZFG763b8awIrtFhk+3s3CBJ5EPFD6fH04sJEcOLjmBm0Qskd?=
 =?us-ascii?Q?dL08PGPbyJGd8SBl0ovaWdiXxygzuVmgH26XKP+ljaDNr2hGOrRaNX+abbC2?=
 =?us-ascii?Q?Yw6nQekUELoLfTLM4PsBMG8F/cc0LFidZG9DZxcVtE7H6+e9iMfvYRLavg1E?=
 =?us-ascii?Q?xWeDtfUOzECgmO6nFVywb1WmRh4cOaJf1XAbLreCNd2sEg/aRRxwMagWfJBW?=
 =?us-ascii?Q?hb0DKODKqLj4Lf0TpTVn1MrB95NzhIpOSUu2rp5mNfS5OTOKpjZ4uid7W4Gf?=
 =?us-ascii?Q?TYSxJKLwM7T3AlKjwg5ECrLD0asiiDfXznadzipCiJFAZ1mx5+X/lipULIT7?=
 =?us-ascii?Q?CXq9mo8xMkMHySq3UwHF0QF62Cj4vXrh371MUHYhktkQV0McNkTZQm4/xrOS?=
 =?us-ascii?Q?v+wB1DJYg1LBCH65o7aa5FrTwXoeNZJnlnBobIIcsDUG22RS3YdNhEXEtikP?=
 =?us-ascii?Q?ZKNvtPaDEHl8ObfYpejvsJiZVVg2rpSQG3JjE2ogpiLYWkrK2mpqBzIIk5nB?=
 =?us-ascii?Q?WNU+l1xEOO8dKt1cqOhHtlMzBqVG4T+8At46ctPbwPXHfPEqwCpKudxsOHJB?=
 =?us-ascii?Q?boX9mrz+V2nJuu2uTxkW+Ydqd5bPwQLPwMy6eCcqBE8CLX7ZbjHXe9OK/ugC?=
 =?us-ascii?Q?H+9GhRPRzf4U31V3QXCFRbGFGZEmf4Wldqo4eslxBoQpNtr6woak6mMblzVt?=
 =?us-ascii?Q?sc/ojiqnEmCqHAdk/esv7hlBoxq73AkP/QBY890N8vu1F7HvX+wTXEIOgJCO?=
 =?us-ascii?Q?q4Ratgp55tzFBIxgYsJwrKn2OGKzISl5RgN4xnAfcZlkTqa8ZciqhURqJf33?=
 =?us-ascii?Q?dRrQEOfDHgZ/SaD8Gueo0BWnHaqs8h7NEc98O4zdn0XeqYySeQOFJuI4/4tR?=
 =?us-ascii?Q?pwfrEj1yXiDaiP9rx5yN5e6Y3HqArTqF9l43S7v/q+N8tWIUqlJGkrDXYVT4?=
 =?us-ascii?Q?KVipZ+/+3EIRHFpHPB/z+oVuUHbBo4n4TAP4SL4o7Lqq0hRp56G5FGCFNCcA?=
 =?us-ascii?Q?HkxmcY91AWNkcgXSx9JwpEE998MS+mrVD1WJt1I2B1baOQM5D/O3+zXlkmYL?=
 =?us-ascii?Q?5sKNpQGQX1wY8UOZQKMpqX1xNfpk/CONuSUoA767y+QqmtWJxMii4WIdTZjv?=
 =?us-ascii?Q?FnihOH5C5WxHUpEAzeQKXiteHuf5IW2X22XXzfKj2yt/J4ntvY/xmpJNA/dZ?=
 =?us-ascii?Q?BSHHnEiv42T+xP3FaEB6CvKZu0swHuEDPCMVcTJr?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bf7c40d-c973-4ebe-7dd2-08dbbb882132
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 16:22:35.1427
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zuYmg16LUm8JdX8a5mq+DgcNO44J19FjToUeTHILYEx+h6Q1R/CdSp2oaV+3d6ZT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5915
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 11:40:58AM -0400, Michael S. Tsirkin wrote:
> On Fri, Sep 22, 2023 at 12:15:34PM -0300, Jason Gunthorpe wrote:
> > On Fri, Sep 22, 2023 at 11:13:18AM -0400, Michael S. Tsirkin wrote:
> > > On Fri, Sep 22, 2023 at 12:25:06PM +0000, Parav Pandit wrote:
> > > > 
> > > > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > > > Sent: Friday, September 22, 2023 5:53 PM
> > > > 
> > > > 
> > > > > > And what's more, using MMIO BAR0 then it can work for legacy.
> > > > > 
> > > > > Oh? How? Our team didn't think so.
> > > > 
> > > > It does not. It was already discussed.
> > > > The device reset in legacy is not synchronous.
> > > > The drivers do not wait for reset to complete; it was written for the sw backend.
> > > > Hence MMIO BAR0 is not the best option in real implementations.
> > > 
> > > Or maybe they made it synchronous in hardware, that's all.
> > > After all same is true for the IO BAR0 e.g. for the PF: IO writes
> > > are posted anyway.
> > 
> > IO writes are not posted in PCI.
> 
> Aha, I was confused. Thanks for the correction. I guess you just buffer
> subsequent transactions while reset is going on and reset quickly enough
> for it to be seemless then?

From a hardware perspective the CPU issues an non-posted IO write and
then it stops processing until the far side returns an IO completion.

Using that you can emulate what the SW virtio model did and delay the
CPU from restarting until the reset is completed.

Since MMIO is always posted, this is not possible to emulate directly
using MMIO.

Converting IO into non-posted admin commands is a fairly close
recreation to what actual HW would do.

Jason
