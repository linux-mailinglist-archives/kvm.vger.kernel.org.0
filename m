Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23C73635F38
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238381AbiKWNV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:21:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236616AbiKWNVH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:21:07 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2051.outbound.protection.outlook.com [40.107.220.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5711255E9
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 05:00:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7H1R6VgXXgDqenu9QROGrnDE18T0WOpV4hQpA1yFp677oskgPedqXhtq49KY2EVGKlIqA0IZNs8WQucxAiqTnon+qOWcH8ZHA8lBi8iUn866yBd3rYix/01lfvIhANKZz0YpxfT8QlbFRvI3kTHjJYwt9x5hIZWzwduRStI1Y8W46t+Vux6PKOgBOi7EnS86zG0HWw+/Gh2zKViaXF+O79cfLCR+Dsntf4atSJkgZ6PHTuAg5wwvSwBt3Ov5g3hpOalETQVTrcdKBi1CMdZCIMHp3HnIZKnFHZDnyNeDlpGUoRVv0T04l/QWr7hobvK8PJ2yjj/hckSBxGk1VO+3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YnY3rIG4zUweBISZnTL1mWe4cgkiFIekCKO7wMvZ+eY=;
 b=Qawyhi7fN1jvyQKDhzPOVUdarXo1ZRy/96ffJWfh17eCB7EoWtoP4Nh/8qdk3nlp03pxM5kERVVh30WRusGV1tnusXx420bJogeOMc4j+sZutzDuJswA5xRkLhCPOiT1VMy2J2MbVUQ0I/mZ5DYDZuvIafR2R4RXOpClZ4pMgGdD67HG/JznEVaL04EhYW3WWzu80Kd/WLTXlQPlWHccn5MjkdiSSWF7JaZqQeVhyLFwevDOjH4ar11i4PAZxiL2vr2iwrERYjNbBtP2hrtIXDn5ye1c0mOUQsQAB6aR7D+mX70gzGusXVFPS+HJe07ywAGPDLAwOY1h6qWE2UrYXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YnY3rIG4zUweBISZnTL1mWe4cgkiFIekCKO7wMvZ+eY=;
 b=rigXOPLzDgiDi0xxiUj1/Wp5+697Pfke6qwV9gvGlw85aNT3/wwpwO7WLHFSOb3FW2XhVeap4Yq7mfwewIxYm6T1Mmoe95GIU/PPpW9Ko13N4SxtsFCq3kU3Oh28mweJmXS8sbBWq9MD1EboI5mmbWDerFrCX7TfMhdK5j8Pj+Cn4Mx3laEl2PiIw7ojNHS/c7Y6oNh4KWbaNmG6gQZRHH6mY8HAsSvAyn9iDcGLq3US5SCNGYgsuWXoGN4wi9lgZBJ8T5TWNKKqWTnnqrL9znWQIlTfurltb3iZ4txLeOU5ZupxcWCH/H1DPiN1LMroDWV6DHPki1GmtDjSAUZ1SQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6919.namprd12.prod.outlook.com (2603:10b6:806:24e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 12:59:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 12:59:58 +0000
Date:   Wed, 23 Nov 2022 08:59:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Lixiao Yang <lixiao.yang@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, Yu He <yu.he@intel.com>
Subject: Re: [PATCH v3 00/11] Connect VFIO to IOMMUFD
Message-ID: <Y34ZTYah83eE1tm9@nvidia.com>
References: <0-v3-50561e12d92b+313-vfio_iommufd_jgg@nvidia.com>
 <b35d92c9-c10e-11c0-6cb2-df66f117c13f@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b35d92c9-c10e-11c0-6cb2-df66f117c13f@intel.com>
X-ClientProxiedBy: MN2PR02CA0008.namprd02.prod.outlook.com
 (2603:10b6:208:fc::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6919:EE_
X-MS-Office365-Filtering-Correlation-Id: 36df3e33-43c9-4108-d6b7-08dacd529fd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RrJDQYBNCRkDsRiUNjFkEwQZOuAEVK4nrO1EA3V966KJXr48XIUWDos9+jFnueFMkwe8O5VbxGej+jgwybFPifu/8FbTZQt4AbQzXQqCn9ZB9BodwCHu7Nn8vdnu6+NB7MguCWQZqbBUONkgGGxYKKgRjX/l8WGzDSSsrNvAxQbVh+3JU0Uh0AD7I2nr+WmthnM5b5lqyGiwUXq9KL8+HhmsiBJJus8h+HShS8IKftFUy+XuuypG0Kuj2/PF2vB7v13tfV+PwrkU9PECB1rdDJbEvrSWBUEF8VdIxNb8LvOWQWVQXBnA8Hn4HGbKz+BpHS2WRSfg5RUtL2H1zw5WKIhUAavwMTcw1DC6sMlBW5GezWVRBqqAo3Iz7FX8UGQWKYFCpb+XJRwck0OCKiZ4/SgEDAy9d3I26GuA+SLZJbMsQRauQL4AaEsXqPx3DcJUxAPlApAXNQHJfwY8vo8fFUPFSJYRNmBXc5KYVXJ0S9sytxXYqm3Xu68s25DkljeHtx51Sf/erJV9v/oluAi8XBBcjgZpKioL8zU5CPW7f+dshoaNUjsSWUaPvS9UKGWLmzQnuP4j751mjYmzTPb9+ykwS/Y8TSlT+4siowUkV9uGXE7lHl3HyUN91p/R2A6AY+XLe4xxj2164Vn2F/40mFKpKvcg5JhHj0ewscnzhIOxDd8SqNKq4tBvdpBoZCaMGFzJKwjlfyWKsUSVV5OLrXRjoD4UUi5Vee6jVSVn0Brw+Fmp7ZOZ1FdT+7vzrJSoHDIzZY2OriA5eqjB9NAdTA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(376002)(346002)(396003)(366004)(451199015)(8676002)(53546011)(6916009)(8936002)(36756003)(66946007)(6512007)(6506007)(66476007)(26005)(66556008)(478600001)(316002)(38100700002)(5660300002)(4326008)(86362001)(54906003)(83380400001)(966005)(6486002)(7416002)(41300700001)(186003)(2616005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RyTGeWltfo0S78N9JdCPi5Mrj8UjG0s0tg/ovF57SGs/9gtNe20m3NzKQjZb?=
 =?us-ascii?Q?EtisbzkiYKzFMkKmjmrsFVZqjSzr92w1vFRZwojkbJcLi5TwF7NTqc1dPnrN?=
 =?us-ascii?Q?Ya1uTFb1i/DD/qdDuC8Dn3l5yxGX9T7HnhJ61qjMxlTxpI9njZtme/mWJtpC?=
 =?us-ascii?Q?HSYT6fwG9GE9CJIlDliMtdfgoFvj3AhhsvoNZUt46r6uxsGT6FKt+brNdMEN?=
 =?us-ascii?Q?jcgUPTMl8343TKbJpqriJ+rOqRre0fN7oTksgzYJffgHLSLEtmhBFLY36pWc?=
 =?us-ascii?Q?2uBm07dt/kQfb+VUuni5BYj9JCYSUsMlefxZ+h8YGsRwLmChQ8tGFhvMedzr?=
 =?us-ascii?Q?Tezra1dWbZAmQBi+pNNBCM5ZZZQx4Fw84GnlfiEicec/yrg0F4oq7rgD0mUa?=
 =?us-ascii?Q?9Z8elPmCly7rttHZTxyZn6bNDy4smVq/5FFp5u+GoUzL1NuTIlhU+335Bl9l?=
 =?us-ascii?Q?ENfumS/cSwTAb2olwxangtosToj2vEgnjkzHpwoSI8FjLgV+wCOIuueaB0J9?=
 =?us-ascii?Q?XySZxHwajG5CF/4rTgcG4k9MNszOCb/JWFj0GM3Qcy4pF/NYxq/Rmrr1P9ke?=
 =?us-ascii?Q?78bA52uAacjOyR+UAoOgPL5i6UzbDL7lwy7XczHDt/B2hmNqWv/JUamYOJvA?=
 =?us-ascii?Q?91dWnFsPkK+NTBTIT7xHzz0FynBq9RRYsIfjssRjko+URhrQcCdkXoxTb/fC?=
 =?us-ascii?Q?RYLx7H31h4To7MCXri5cBxiz1P3nTjG31EpATVwcNRSyoFVHiP0YE8GSwoXv?=
 =?us-ascii?Q?dx/3SqGK5wNuZnBhmAKh1CrDHQX3syBkSQl9B5fMEmTcw2K4R731mpGCAr0a?=
 =?us-ascii?Q?rct+wVE0rXTvfKyWvRR+kBkx3BoB+8yxFgmsE/OGHEJp6D0g0kEYLasNAUtg?=
 =?us-ascii?Q?g/CDsjXjtQuUyc/AlyrhPY5Prcw48WqB7Pm7ISK0g9n9V719YjT2BTP70J2f?=
 =?us-ascii?Q?Jq3aObkHNou18uHwqRdevvtTwh1iB8ZuU6zkooiaYgWDje3Ah+wa1mwnq9CX?=
 =?us-ascii?Q?zi0PMGgKYQH/s1kBQ1HqpKnkDOOWRw7c/xL/1+GmyYewoGuigq0fD7dMbd+J?=
 =?us-ascii?Q?ZaCFBVlgyL10SA4v0+ymFpBX3IeLceGWr1TAdGBwQ5e2FVe9og904lIGNQjF?=
 =?us-ascii?Q?Uto4/LPjxXZha1dFxYauSBxr3i5tcTh6S+7fjGRngREfl/n54DlK+Q7jJSS7?=
 =?us-ascii?Q?w0eCB0QnSmIYUq1PPQ0RxAQeA+Uh9kgPm2zAXmfjT3eHAAAZBWHS26k3ftL/?=
 =?us-ascii?Q?Dbdr+IJ5KbYtvAbdIMgpvPuk6tOgmzPpLpxv/4MevLfceLN+RrpKNK9setlp?=
 =?us-ascii?Q?odtkWzkgmaUQtEGuXBgdI1qHbIY6f2D+0MTo4Xtpw5nMtGztn3F/CFxDJFBO?=
 =?us-ascii?Q?SXQJOHsbIGTWvlTX+5/IQ17vtqVyMWZXNNyTSwV3uAwIPEV0Nza0cZWJkTp4?=
 =?us-ascii?Q?yJaa8q/p1m+GkIXnpXPLTd+fRx5p2n2V/5/D3ttOAsOsH0NWdJOWuNb2E63D?=
 =?us-ascii?Q?3sH6wF9wEkzsLJOdg/Lgr1/CuET/tbY2pfOkB0t9GUVQkGqKWasCAZDw4maV?=
 =?us-ascii?Q?Jmd4y3ADMLYxh8lx8bY=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36df3e33-43c9-4108-d6b7-08dacd529fd8
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 12:59:58.0552
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wytirXxOU8tCTgEeA5RCVRtPNQ/9z/iqzfQ/oYehRNpbliWYBeL7OZlJL0Foz65S
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6919
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022 at 10:44:12AM +0800, Yi Liu wrote:
> Hi Jason,
> 
> On 2022/11/17 05:05, Jason Gunthorpe wrote:
> > This series provides an alternative container layer for VFIO implemented
> > using iommufd. This is optional, if CONFIG_IOMMUFD is not set then it will
> > not be compiled in.
> > 
> > At this point iommufd can be injected by passing in a iommfd FD to
> > VFIO_GROUP_SET_CONTAINER which will use the VFIO compat layer in iommufd
> > to obtain the compat IOAS and then connect up all the VFIO drivers as
> > appropriate.
> > 
> > This is temporary stopping point, a following series will provide a way to
> > directly open a VFIO device FD and directly connect it to IOMMUFD using
> > native ioctls that can expose the IOMMUFD features like hwpt, future
> > vPASID and dynamic attachment.
> > 
> > This series, in compat mode, has passed all the qemu tests we have
> > available, including the test suites for the Intel GVT mdev. Aside from
> > the temporary limitation with P2P memory this is belived to be fully
> > compatible with VFIO.
> > 
> > This is on github: https://github.com/jgunthorpe/linux/commits/vfio_iommufd
> > 
> > It requires the iommufd series:
> > 
> > https://lore.kernel.org/r/0-v5-4001c2997bd0+30c-iommufd_jgg@nvidia.com
> 
> gvtg test encountered broken display with below commit in your for-next
> branch.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jgg/iommufd.git/commit/?h=for-next&id=57f62422b6f0477afaddd2fc77a4bb9b94275f42
> 
> I noticed there are diffs in drivers/vfio/ and drivers/iommu/iommufd/
> between this commit and the last tested commit (37c9e6e44d77a). Seems
> to have regression due to the diffs.

Do you have something more to go on? I am checking the diff and not
getting any idea. The above also merges v6.1-rc5 into the tree, is
there a chance rc5 is the gvt problem?

Jason
