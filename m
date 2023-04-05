Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02A136D83FC
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbjDEQqP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjDEQqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:46:13 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8976010FA;
        Wed,  5 Apr 2023 09:46:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xnl58+E1QUO8a9DTXHijqWrbTFIZYsZg/oCZfV5QSkifpKa4JT0lq01sG4vs03zZ9FCG8q95Ru3NkDZp33ZYjoxfSolrhn3TAFqptojLogh3g2Sjszo6zTrLCgEiOkYXD0+wN5bCoHl/ioTsOMlt+1Jl/FiIiOwkGqRLh8QF9iguhvbCmZHOH+h1oWA/mTbCQXRwSzzuaMKNXNhqyU7SsOAAOtE3UZofpPe5IKOdtwf7kIILZl0Uujty46q1EXLa+sjE6e5ahLBveN94PpjnW3bDfB7XDm75btOUgvkzquhk36UVaF0CvIyS46Eb+CDBslIekaTK84bGUEDXk17ywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6kqM7g+8jgv6BMG22A/7sH8nXy6yk0HcgEwgWqf93GM=;
 b=iB1SAZrvbfHSso2Sa9WifFEXQVleMoYilM2VxIux0nlgOP1P8qPzDGLlwPHASrs1kyRLztYQsumT9O+iXVUsnH1R2SlcBBmFzX+lCx66w2q025S2qRrhnOzZfh5ElUt61uhT2DqaZFeWirZ1QeTFMNYh3NF6zZaSuHACJiAwgv7br5Qm314SRGFd3WRO+boQ0/yLYEd04NFE3Pgdaa5d/LBkpLsWAeZw/0QKAZOIykASNdSIucKoFVRSN0lBTMEdOCTZgRK8te4Z7+QBux28pwRAKXJHfgcyuv6U94tYPua/ObQpAdhY3L0oxIBIoW1lxYkj1RHqVd/DkrLLt1Dobg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6kqM7g+8jgv6BMG22A/7sH8nXy6yk0HcgEwgWqf93GM=;
 b=NbxYnV6dhbB84MABfS0tTkB/70UItWOsgdTQAlvtIbDaCkgTGno0iHxMd/5xWjL0AoENPL5ujTjl8uh5XkYntJRncVjEx1WEfyYx1kPaIPXYBoQjuVH8NqbYn8ixv6T4+dY92FTbbdENvwbdOS6/KKRX1sQ5rQXjD/UItwmLESbCVTd87ljBHDM5y0gPzVQIWQMsG+8QEK9qVHj79OhIDL4UnumXNc+jj97uM3tY+JAzr3YzvZ6wk3N+ZOl5hSxKwu1A1KuZQU/2FjTc+KRhR5c85MDz3fmA69mwnxJG6VT0um5pj77GHmrNfR8ftQyQCTvGbXTTFRrVZFR3UDj/zQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB7076.namprd12.prod.outlook.com (2603:10b6:806:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 16:46:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::6045:ad97:10b7:62a2%6]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 16:46:10 +0000
Date:   Wed, 5 Apr 2023 13:46:08 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>
Subject: Re: [PATCH v3 05/12] vfio/pci: Allow passing zero-length fd array in
 VFIO_DEVICE_PCI_HOT_RESET
Message-ID: <ZC2l0NJ9+sctAH12@nvidia.com>
References: <20230401144429.88673-1-yi.l.liu@intel.com>
 <20230401144429.88673-6-yi.l.liu@intel.com>
 <20230404141838.6a4efdd4.alex.williamson@redhat.com>
 <DS0PR11MB752919BC81CCCAB1A13998CAC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <DS0PR11MB7529730CD29F2BD13F1DD9AEC3909@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230405093646.337f0992.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405093646.337f0992.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P223CA0024.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB7076:EE_
X-MS-Office365-Filtering-Correlation-Id: 170c9fc9-a183-4b10-1448-08db35f54283
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w1lf9zIX72H1POxXdaIZLmOBLtvaNhq8M1dFm98YOjK5kMmjI7g0snaeyjuQK+0ZKBEZoPDHNpi241z0pYAwo+C1MdcZHzZhAFjPRLWvUALbY6lfYdGhduCkiBvGiNDW7eGen64BgljhQz43XFtsTYvHHBhFeWgsp7/c7nDZdjRsVFQIkHeTOLuiM//oS1nwK34+eHge/IjBb7JP2IxC4sJEptO2tXVFk0PasIVD3i2EQGA/BFO/htgOkSeOu4QDrrg3mzB6cORG1AR9l2JNrteRdJ6nrt7s/xZWmqZQeO2QsK8uJkrzgvYwyaA4UywI/b86B3pUKvhXP6cyq2AlccT4UnPIGgxs16NABz2OSMdUwOf+VKkNsE6vk7MYAadnAq2T/JKEo6oxQqYZYwWugHt9kPSVBlPXMUrHEuXWSQilGzueEqwMtTrW2ljWBMNtjE0ozkiEVAD6jSdHJrVVpHrDDztMi/nT7lNWeHu/5fAiNneTB4958ltT4wHLpX6HTRz5LGVr088Ex4aIzwNzhhzLj7aP1+GYxu8B65GqHuWRX1eDEGQ5kbXhntL3Hk0gocxPx/mdUMlzo/dBoTicuc9KdqqSd7C7Fsp47VD/+18=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(451199021)(478600001)(316002)(54906003)(8676002)(66476007)(6916009)(66946007)(66556008)(4326008)(6486002)(2906002)(5660300002)(38100700002)(41300700001)(7416002)(8936002)(86362001)(2616005)(6512007)(6506007)(26005)(186003)(36756003)(66899021)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BQwr5b+7NLrsaceN7E4GH9PBLUs0X3CLg89/TjUZlnC4PDG8IdAaqWP4qMjI?=
 =?us-ascii?Q?eI5+GLwmLJZ6kTXAD0JzsKRBZ2r7daxwJSvZYrjTNS4Ml9+vHUZ4bXR01+dL?=
 =?us-ascii?Q?Qe7KqkFIbkvXeD1m12d8Pj3SiOWDj7AYznBccv5REVtrgGZxbvJu68vHLM2v?=
 =?us-ascii?Q?Pu5qqravlSX0pS5cFDt9EkTDhDal7uUzQh6x3faZWRQw8LoLz4GIGhfXb0rB?=
 =?us-ascii?Q?cmqyBRvkRcrjuGohgON/ZY8+IdZ18qozk/J/IvmAe4zdNzOkrnoxLXgbLgZI?=
 =?us-ascii?Q?PDf5uwo+Yv0ZU+lS8N9BLPl++fbwMevIj+ba+utP28fqqroWKdmKgwPWTbtu?=
 =?us-ascii?Q?F2b7Pmh/+9M2C7NIYY3X6x8VlveeXnDQp/fnR6ImOOs5vlU1l+28Fs7aATyc?=
 =?us-ascii?Q?qoH38Vo2qQq23i7BXTK77a5PtnYOLOCpzBrTbpQMY62XQdMuBbKcUN9bgrOV?=
 =?us-ascii?Q?tkosJRQSybGKtCzk/fAxcmxRUrJnYcAa0AwayDLHSGjDiWzbUNgPJsb503Uj?=
 =?us-ascii?Q?RnzAQotFhDafshIshbrRzm94fO6S+DdMQE9eUAASjy6agHJc/iWqFyzR3UKv?=
 =?us-ascii?Q?KAMVHS/eBZHXQ8eu+TP/ozJM++NVP/DrXiXUyW9KaWXqw+4ctePi9RQd3wBR?=
 =?us-ascii?Q?lwovXdFc5danwxYAWCACOAALDIvBZbBxZZx+KgD6VvBPbi6+32S8D57oW9bI?=
 =?us-ascii?Q?KETVgb2nPYDS0LKi6aNr+0XXFfdxTCvShPBrSNnEWJd42Gk5dLOYMtJlDkuA?=
 =?us-ascii?Q?J2cw+azOsFKni2wiooL5TeZ3AP8x+9BHIiNi3266OCmitcvp8klhnJBApGec?=
 =?us-ascii?Q?u2WlSHdrK7Ykt5hYRtG9lpS+NYW15lp7Q/ufUWexcIEzOfbe3F1s6ieLL/Ss?=
 =?us-ascii?Q?2NXtJBucWj84Eux6nEdcWpROiTrboc2nGBqQi0NVUO+UZAVoEFecZBUN9gF0?=
 =?us-ascii?Q?CgX+T22p5m5xkQ/oM8mRN4wUZx+vI/WCzzHae2+/yweM3lRhnWGkuuRw4j90?=
 =?us-ascii?Q?wW9g+3Z8ogCcgHFpUCamB0ak8Y5lQ5Ak9N1TWDqZDRMx/vaX9Db67MyLu134?=
 =?us-ascii?Q?TzCnZgSbcP0vVZkj+ZY2S3I3qnr485ciN5VvG3rVYqPLXawCMyAntKUJw2ml?=
 =?us-ascii?Q?jHl5HVTbmItuaE4/hnpVJOjxO0jWxFJ2rAYfrJtQM5spaxUsnnN5yDqYzmne?=
 =?us-ascii?Q?Sw4B61OasnphhfkuAWHCQZhQfWs3U2pFiTv+lUEc95WeOEm8A2bsQzlvtvHw?=
 =?us-ascii?Q?TyIxIlp9FCrZMnIYpQAH//Ow2hisQ/+ra2PEznIzdvyCDHAIDAOaFT0Xl3Pz?=
 =?us-ascii?Q?ZGWRZOz5CDFCpPGXsNC9ED1Rhp7+j12iw06OZQ/3q9PHr6QGJ6AFi2KOE0Pm?=
 =?us-ascii?Q?w/KmkRZjOmhS3cH3ySvfudGSuAQbWOgIOh5ZOVdW6qhApIL8eFLJU1rCUeG9?=
 =?us-ascii?Q?QuzRFPYZRqMp9lgyiR/pqVsjoK6v/1A6jeghxKq2CmISa//f/t4rgkTXnz8m?=
 =?us-ascii?Q?yh+EmtiHIn76Hk464V8l8DQOaAeIqfa9ZsH+h7XLjtbNZnjpSRgM2jzfZ9Z1?=
 =?us-ascii?Q?tnBP1lfhbq2KlH9Q+Fg0vhUV1SWxc+huc74UGa+a?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 170c9fc9-a183-4b10-1448-08db35f54283
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 16:46:10.4144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2U+MB4tPvMjB6Ex1Ie3868I8ABtIsXEINBF9Bp/ClaQjna1WopdslzxK5TOX4Enl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7076
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 05, 2023 at 09:36:46AM -0600, Alex Williamson wrote:

> > If we don't support singletion dev_set hot-reset, noiommu devices in cdev
> > path shall fail the hot-reset if empty-fd array is provided. But we may just
> > document that empty-fd array does not work for noiommu. User should
> > use the device fd array.
> 
> I don't see any replies to my comment on 08/12 where I again question
> why we need an empty array option.

I was pressing we'd do empty-fd only and not do the device fd array at
all since it is such an ugly fit for the use cases we have.

But it is such a minor detail if you don't want it then take it out.

> This singleton dev-set notion seems equally unjustified.  Do we just
> need to deal with hot-reset being unsupported for no-iommu devices
> with iommufd?

It was to support no-iommu, if you want to de-support it then it can
go away too. AFAIK dpdk doesn't use this feature and it is the only
user we know of that has support for no-iommu so it is probably safe.

Jason
