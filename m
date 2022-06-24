Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D53559B61
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 16:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbiFXOSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 10:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231175AbiFXOSk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 10:18:40 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2085.outbound.protection.outlook.com [40.107.244.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0FD46B19;
        Fri, 24 Jun 2022 07:18:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GYTzuNMcS8yIpoZJKV7dvTWuqzmbAq2mLTWhTS2k3e/b2vLgG4IhgUzX1gLr2pkEIMrGj+M8iBCfaZ/EI7AF2Kk5PpI62Vrtp/tRS2Pkl78AQcSGul1vqaxCTJ+PfAUODM3aIG+5UBhoyZoMd9w9mcHOmtJSmn7mOa2K5RVC6vxaElMvSrGikOv6VCHkc4CY+8pXcry0H2WLa0eu6PT1qTq2xpwaBExtUPGwhb7MbrEUlAoxHKjCrGbchXfX0/7XJGQjqGoq5pxZH81sjdrVU7DxjTJqvFl7YAjX6fTX4UrAoMXuG/f+OFk0WqRjDw1aAg5iYFCXQG/dt8RbhkTLVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9kBaS26yPjMGmbS2QguQ6HlNapSgT2V6wqVLAUmoLUM=;
 b=Qhb2UXt+rK3TZ077oAwBzEsnAq4CbhXyilLNkTKTNERDAmFBuHSBUrZE6rqgz36sVvLI0WNVvOgzGfpOb7QVKVexcxc/IzQvswF8+OlMNJLjiQIDIVdjwyghWAw8ZvGAbfO4UsJW9PURAGtSFKJI7M2ZDizl2LZ9a3TzGau/NQ446nI0BvjTOHAKmPJ8F33UNg0xSQdolr6wRYAGS+jPWbMQKfgDzA9z9mu52w00WidB9EkTyW2lDjxQKvEaJK9KsQA6Fw5Zijel9NcKp1E6oKbUXe73a59ECLsdyT6dJSykUAssQpyiLOvinFlaSDFsrp3hXBOr7Pa+RbkZ5275GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9kBaS26yPjMGmbS2QguQ6HlNapSgT2V6wqVLAUmoLUM=;
 b=h3ykac/XknlGoAXfhSd70DDFlVZWHud6NUHthMGs52/PBePg2hZVRC+DT2HS3i4wGE/RPxcGnx4IxShtU7zpkSRn4pTVM94ljgDd4/eF/bkbZa35px97r1n0YHZLUV3UitZ/qtqGizqPl2siRcJEZDCuAgxiuc83ZCneqtKq/qkqDBnysbfVtJG5vrMLdvgEtJNf2+QAay83pxSY8pHpshmuI0jPUTQb+r9JxmT5h3hxDJHgs6sOMsFpmR3ThtAPutsJ3MvPImh+065S+EQIxGY/fvcvdiweXqGJig2qlDCy2nQlU70G8OPMGVT5u0sFb0+l8EEmLZiRQG9i9UMPXQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BYAPR12MB2965.namprd12.prod.outlook.com (2603:10b6:a03:ae::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Fri, 24 Jun
 2022 14:18:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ac35:7c4b:3282:abfb%3]) with mapi id 15.20.5373.016; Fri, 24 Jun 2022
 14:18:37 +0000
Date:   Fri, 24 Jun 2022 11:18:36 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Robin Murphy <robin.murphy@arm.com>, cohuck@redhat.com,
        iommu@lists.linux.dev, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] vfio/type1: Simplify bus_type determination
Message-ID: <20220624141836.GS4147@nvidia.com>
References: <b1d13cade281a7d8acbfd0f6a33dcd086207952c.1655898523.git.robin.murphy@arm.com>
 <20220622161721.469fc9eb.alex.williamson@redhat.com>
 <68263bd7-4528-7acb-b11f-6b1c6c8c72ef@arm.com>
 <20220623170044.1757267d.alex.williamson@redhat.com>
 <20220624015030.GJ4147@nvidia.com>
 <20220624081159.508baed3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220624081159.508baed3.alex.williamson@redhat.com>
X-ClientProxiedBy: BL0PR02CA0122.namprd02.prod.outlook.com
 (2603:10b6:208:35::27) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e8a78727-23ff-4b52-779a-08da55ec6df9
X-MS-TrafficTypeDiagnostic: BYAPR12MB2965:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zMLEeoWV8NMnYjq7bS69Hv7nKwq8b7uheO5Vd2BtrePc7rvL5nKPfq8UbRPtzOVcW197ZqwJb4NRofsQciLZwUMx9DdxIkjSqLvrrMW8mI7NFzXXN6hEbf/FMkRyYPjl+XHr+hM+G/IO+VM1/nZG5ze+zBbV4AnN+uR4/vvTq34WAQ1fitDhx9y5aSI2h0MRMXNzxVoZbB9cyxsyiyjkDctpsOMIwFdP/rjPQbiCBpWi/vEgh40bjjh49y7PVVB7MAunlJ0loU8JLDxgOqQnO/ODAxGI5po0+PbCSeCtOVxFgHZne2MuibTKdqjwzj2CxREWTjs4EE1TUwVkkIweDVNFKlrQTuc77uR35X1PI3IndqNcKwpIsVINus9j86YSwkuuuJ3XGj6us95sfNlHSjvw73zqL5sjKC+NGqI2LViHZgv4UYbfZrL5uoZHSdkO1nooUlQVWWylMyU5YbVaEEBGr2hYI6KIzii0YjMCvZH6ObogEEYnb3fBgx09rp4BBdI25mndRK+y0234tD0HeKljWoGL+2cb3N7giiu0XemtfiJpvibv9shiuat63HqjKNuEHB48RBq11JewwNT28KAcHSZUCeRjKvo8nS413dSSudDSCE6l135vtCxJD+CUlPlL5l5IAzqwbqkmcDtijKV8k/JhJ3oCjhqq3UsmhreuX5EU82CCQyAmo39Llbbr3oTSvZ/pmdIHHrsakQ4tdPpVStNIZTD61MHWQaXEBJQeLYmZ+D7xHGDSZ/vmM4EW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(376002)(366004)(396003)(136003)(2616005)(83380400001)(86362001)(5660300002)(186003)(38100700002)(1076003)(8936002)(6486002)(41300700001)(66946007)(66476007)(6506007)(2906002)(4326008)(26005)(6512007)(8676002)(33656002)(316002)(66556008)(36756003)(478600001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rL56UM8/YvIQy76OWo85sTTnSc/5KVnOlNjQT6JW6htQhy8bYLstb0oXhw2O?=
 =?us-ascii?Q?kh0wDK/szd8h8MM9lQfqxbKkjOXFfwnttjO22l0SasXTVleePwTIJW5H2OCI?=
 =?us-ascii?Q?RiPubRFsC8OtzFTPhPRYmvkjVUFw7kxuZ1XETmcNS3ctc7PleWb04l5UJV6w?=
 =?us-ascii?Q?az7CdD4oHV0novjxgc4qytUQvLiRzPZPAmoZM9PWz0vacRs2deyOBOiaHyYe?=
 =?us-ascii?Q?T7EueDDlQTkJXpEfScNdgyoaJbMoKsncvpPn9M3NQXAuOduEjcMiq1iH6cE+?=
 =?us-ascii?Q?S6n4dr6STTYRGtx8+DewXbZ+g8xvbRbYcQjGmXveP6/afGg4ln0taPVyxhDl?=
 =?us-ascii?Q?DubE9HcJlHBA8pqVJ1GjGG8nXf0nCzIV86srcmSAJLvMWiTmAEdGohcZxV2/?=
 =?us-ascii?Q?305lVgaRhx04H4zcK3TA7INTB/GpFPNIBfP3BhESa/u7+7FfVvRiJuE3XR8V?=
 =?us-ascii?Q?hdI1KV3vu4QYIp3vLxcN/FNDtIPh7gqB3CRMVatIgfcOz6dRiJVKBOTqTlIA?=
 =?us-ascii?Q?4kaZZSli+YyEtrmhnAoI6kauHtnNHI4nd2bYvmfuHSCN1rQE70UmQDAaysJ9?=
 =?us-ascii?Q?X6NJYdKjxb5fjpZhbgKFra3S6KLOm89VBmtd31nQUNpntqHCunPzEq5rqeVB?=
 =?us-ascii?Q?TNBMaSru4RG9CeD+r4g9HvYCJk36jwWR0uSqzY34dxbPtgU5bgwxsjyLneBp?=
 =?us-ascii?Q?zasbyMICdiVHNHuzCVB9OXzwJHboHRz326yrLDsknKglFKIxXExYaAjw0zG+?=
 =?us-ascii?Q?kpCM9H+ozkwzYhVQd43QDXY1POr9481I5Pad26SsWsoFmyxuzp4qP+xOSTa5?=
 =?us-ascii?Q?VS95Gb8TrIVgrrv1CgQI/mn8stW388Vk03AM44784GVWp9yYaOQ4qO5uDDOW?=
 =?us-ascii?Q?Mxe7XF3ghFDzJQipX3SZw2GIMJvdDsxq+83P2xfbFHSmCGR3y4xKLOfYOcFq?=
 =?us-ascii?Q?sCqLO1dZRBhIsGXH4uAaOo0qNeaQ2p31rdtYD9EqESUdbS4wxy+BEt5Pv1K7?=
 =?us-ascii?Q?MkHiNT6jQjid4IxtWyZc9Cf3SOPgr4ypBc9R+8OuY+jVio9rNvYJzuUg9k/5?=
 =?us-ascii?Q?OoU6h9Hk8lfXm/uDfR4XCfy4wgAPFD7gPxtvrL47W5mwHYSUXgXNzF9eTxae?=
 =?us-ascii?Q?A/j8w+mRYOAlAroV7DTzVff1oZccLg+O4xVuCYZtk+Je2Gv34IZqoucmijFT?=
 =?us-ascii?Q?GJnH8dNHxBs8wzFbxiLkCLkIU5zqk+Rj3mrMowmkJIaMDSAGjegWzUSF2xqP?=
 =?us-ascii?Q?vfEZDMQou3KOEMUxmEFEre3YhLrG38h5vR2ZbaIzy1/T8TBaa17eUZWPS8ti?=
 =?us-ascii?Q?secjI4sSTcY1nStauH+7YJ6K4+966fZEUB2qs+cd5YpP0XrhKR4SWDk8yoKh?=
 =?us-ascii?Q?vVQT49zETkc/uAYHi04CNtMkQ7LGr5dADeqTaGemQ6YV3fA6/v5HY7xBb/Ej?=
 =?us-ascii?Q?1DQzfKpRhdHr5A4IE4HvBr54YMusEy7n7Yt7jL/LhoYrGnrNqt2oA5RriHEh?=
 =?us-ascii?Q?SIeuE3ti3/YYarrPJ3s7KO7Q7L3+bIwGek2ny13iNNeubdZuxu6HtLwZkZ64?=
 =?us-ascii?Q?x50VzeKCv6zrcN7dFyPNIHkz6lSTDCN9JO+qSMdq?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8a78727-23ff-4b52-779a-08da55ec6df9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2022 14:18:37.3161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 303IY0Ya4NjW3fBJ5aqiyPkYUnghJTh/Euf2HX5HfxOpnz0R6fbMTbweKxwEVPTp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2965
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 24, 2022 at 08:11:59AM -0600, Alex Williamson wrote:
> On Thu, 23 Jun 2022 22:50:30 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Thu, Jun 23, 2022 at 05:00:44PM -0600, Alex Williamson wrote:
> > 
> > > > >> +struct vfio_device *vfio_device_get_from_iommu(struct iommu_group *iommu_group)
> > > > >> +{
> > > > >> +	struct vfio_group *group = vfio_group_get_from_iommu(iommu_group);
> > > > >> +	struct vfio_device *device;    
> > > > > 
> > > > > Check group for NULL.    
> > > > 
> > > > OK - FWIW in context this should only ever make sense to call with an 
> > > > iommu_group which has already been derived from a vfio_group, and I did 
> > > > initially consider a check with a WARN_ON(), but then decided that the 
> > > > unguarded dereference would be a sufficiently strong message. No problem 
> > > > with bringing that back to make it more defensive if that's what you prefer.  
> > > 
> > > A while down the road, that's a bit too much implicit knowledge of the
> > > intent and single purpose of this function just to simply avoid a test.  
> > 
> > I think we should just pass the 'struct vfio_group *' into the
> > attach_group op and have this API take that type in and forget the
> > vfio_group_get_from_iommu().
> 
> That's essentially what I'm suggesting, the vfio_group is passed as an
> opaque pointer which type1 can use for a
> vfio_group_for_each_vfio_device() type call.  Thanks,

I don't want to add a whole vfio_group_for_each_vfio_device()
machinery that isn't actually needed by anything.. This is all
internal, we don't need to design more than exactly what is needed.

At this point if we change the signature of the attach then we may as
well just pass in the representative vfio_device, that is probably
less LOC overall.

Jason
