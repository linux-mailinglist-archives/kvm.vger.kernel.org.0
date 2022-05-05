Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB9E51C96A
	for <lists+kvm@lfdr.de>; Thu,  5 May 2022 21:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385235AbiEETsn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 May 2022 15:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385209AbiEETsk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 May 2022 15:48:40 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 087895E165
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 12:45:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KnyWKpjBD3KWpv6bvEDjFKrxfMrfgyoOFhvLCBXAnPLt7FJ3QuGBdl0WY7yIx7H+swWL3m84QxnanEJGYSDbaJCHLQ8SeydSxsRftLDa7Mh1vs2h8QoiH9lBT7R0szZ+cNscf+InSnjkHxvHcwHzavq0APZT5fHuTGgATB4bSMNtEZJ622+QSHukyM5x4GlbnHhvPQJyvvao/ldHeWqiUPKRljFKHyCjUw+EIqHVRgzDmPBvzKSnP4zx8z4rMBx6dta8hUBxtEcm+6NmpkIJBMHbSWT/F51Ax8w3WWBWA4phClIcm7xNkD7E4rztt+Xjeymar54pTXwAysJNA/3yNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7CQ4mu+nuuzsue5+lyoAlF5XG4fLiZCggk13eS7Ce8k=;
 b=nyDL/PKmAxaBHRpJ1R2Hy0DmjaUVIrPaA4xRVIPTR8YEaTdnf4Sf7Nsr4rGeZ2hem62P8EDAvIA2SPDdIjMgseprThH3Cn5AiQJimfJiOLQCLbyaeEcev6N8+LvZtvQD/QjyaNpzzHta2Wfpd7wmQmn9MHJhzaESEVhreGZ4oeSW3LWodY5VF/deBoQT/eeSqrVC082AKzeRroKcne3sqefxDjP+sKcYSlgWT6zACdvYSyKmx1NnD+RDcTbjMKB/ApwuSC/MI57oEKJaBzPrR60QDK35WHDH/4hQs1b2+Fxwtm9WGTb38BtcM2ik9oTk032XBScMZZAIj4yBRclwlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7CQ4mu+nuuzsue5+lyoAlF5XG4fLiZCggk13eS7Ce8k=;
 b=k/hbLsy+CAugyNFtynF6TeyyRyFFDmAnVUgyVw06dGd2MROtLdWMQCop1+wBjY4QkjH09++6nIzS4GRk/kbsGrrGoDyqfOjI9rc9AHOtQ0cagdcIfD+qghANMT3PcxBLWDMLHPGD4/ZBMjY/VPoIOpec+f64ou+zEZzQ7rpZNG7ChvgWTcdhDxTegV1Nf5q0QMgy6btDjEYRTvg/jfgZqQ92Mwv2jsXtoLWwCL2yTilYmCQn94aUZBKdJv/G94f14drm6lqPAF7IsobGgKVSkSPsg3pxFIrVoTo7HvAS9bDBH+RyKGjqTXTm9ybJ6dU5m7B3iKPGdrxSrks3DiJy+w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN9PR12MB5164.namprd12.prod.outlook.com (2603:10b6:408:11d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Thu, 5 May
 2022 19:44:58 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 19:44:58 +0000
Date:   Thu, 5 May 2022 16:44:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org,
        "Jason J. Herne" <jjherne@linux.ibm.com>,
        "Tian, Kevin" <kevin.tian@intel.com>, kvm@vger.kernel.org,
        "Liu, Yi L" <yi.l.liu@intel.com>, zhenyuw@linux.intel.com,
        zhi.a.wang@intel.com
Subject: Re: [PATCH v3 0/7] Make the rest of the VFIO driver interface use
 vfio_device
Message-ID: <20220505194457.GY49344@nvidia.com>
References: <0-v3-e131a9b6b467+14b6-vfio_mdev_no_group_jgg@nvidia.com>
 <20220504174926.GA88353@nvidia.com>
 <20220505125614.0f927782.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505125614.0f927782.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28554fdc-836c-44f7-0a7f-08da2ecfbc71
X-MS-TrafficTypeDiagnostic: BN9PR12MB5164:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB516483C5B8693DB9D99EEEDAC2C29@BN9PR12MB5164.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aWNQEwzlYyNmx8VJzcpvRp6aprc9ZW3h1OAQbswTZRYVzMxdPP1oGzN4BTBO35h3ho/ek4bCAifVdSOFSrl3A/Um1TvwJMjuOjeTDjrddUVNQsgbMfPY2tPssIbcq8sPMGdJRac31QagGKBtAM/nZ4U2wZJfagP0j2DifhdMKVeUgRIFibvi8CYRGqKiESbPio2BHzogyt6vrtSz1SnTEkiThA7QMJ44HMFBbJeRd0GvFIHFfMc43OwpxW/1m0OsEAaDH7bN7rP5OBy22tjddkHYKGApE9tjGbT8tz68AxI8ePld95ZprRLR+6u0TJ/qszUbkxcZoXV79HLjd1DH4HhN4o2crE5HQzlWY/QQVePv6fDfkkpw4XJGbnMTMpKWNsF6y5fTppMgfEThjyh4LbVEKL2uIOBNvQzfBTM9/mBfKLU7tt/ep04lYWrePqCkZX46dbv0FphWCYpzuZvaJSJapHmfrq9hbu5RM4iyhDpQcmeuKY4PM/L/+mn6BIbN32jbjJv/V9CkWjhbHEBemxtMo02tImtLoEgDgNqL/2ep78pXrNqY6X92M0uN4bFpkZUqyLRl8TZc5pjl5QAHgrrSSYfwIa0TqIk+byKG6tXJagEO7CTGI6kAIyOqZFNWXVZMirKyh0hIEG/4fjfDk06vmy3R/QXb+qOCBE/YzDfiPUVEshhbc2E5fHVmqJEyn+i0OgTn8W/b7PDT1EsSDJF6SGQ2FPHOlCO8SVx+mFJyaRjdIlRgolSddj1dJgFKOcbdqSWo5pcnkeryXXxT/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(86362001)(38100700002)(6916009)(2616005)(6512007)(33656002)(1076003)(26005)(4326008)(66946007)(66556008)(66476007)(8676002)(316002)(83380400001)(6506007)(5660300002)(186003)(508600001)(8936002)(2906002)(966005)(6486002)(36756003)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kMQ/+2UGcWiclEcrukBpWupRFp6ueOHrjDMce8DLmjh7GnLd561t37kwUG26?=
 =?us-ascii?Q?eWeRUKckE4mSJESr9lcwskyehJFjwjDPl51/57jJXJhPivUqu2eP1UjH4mIY?=
 =?us-ascii?Q?LnJEfIyF6VOgh/kKf5OvSl5sq8FNe4Zhue9WG7sSC3HbJoh1AYmqw64cJFZC?=
 =?us-ascii?Q?Pgl0i9u1f0SwVEdki6y8LO2K6YCyekY50UQoYa1cZOc4bBMqOcd47slSnGaG?=
 =?us-ascii?Q?ps/JpTWMJ0pltfN0bUNm/gvYo/pUBB/FPaIQbMGJ74J1sTjEYEPKr7jgBNxf?=
 =?us-ascii?Q?OynSmIVkDNo9I5P0RWiK590HnvPmfn5CmjSzcyBwxOAyAJEyIjFSHsCVAUlO?=
 =?us-ascii?Q?4Fyth7qTrA98qQnD7W0LmnpkJFFJn52CepfEyUutYQFk5/roti81RY3VWbWf?=
 =?us-ascii?Q?XdGpdgc8xCZ4CCl7BQpc/5BKS5dK9M6ZW7P+uR3WzLg5LOzg3WiMHpbfZ28Z?=
 =?us-ascii?Q?z9Q/MbikB0CfbhaYE1AYdWzm7+Vvj3pD+gNLoyVdguh748ZH2oVD1Jr2jtPd?=
 =?us-ascii?Q?wO0crqHHZu66bwE3/sF4f4Mz2vPdQbtAh73vgl9d7EpgoUI5DGJAB2YByAUX?=
 =?us-ascii?Q?hmZVJ51tUjbkMeUQq/LQz3e1FKYhGKaCagvsGuOMYIeOB490iLo0zP1vEQ11?=
 =?us-ascii?Q?6+9FeETQIE7FuIl8QQg9EYDsXXZX3vku1WsCgmnsehF2IvWi9Qukea5rPS+S?=
 =?us-ascii?Q?bUeee0UAAB2OK4y/ZCg5ZJq0c+GBi81RAMCzbPlqZTsPoMvz1avBd8etI4e+?=
 =?us-ascii?Q?Fs8IDGjnbHewJHpit20LKwM17W4A/kYUkrvilENcjIbYMiOhFRFfwnbQGUBH?=
 =?us-ascii?Q?YWna8I5/AAjOl22t1ec3X+ElD4RchXcl7vDnOyURX8crzYhqWdsweYs1U3YS?=
 =?us-ascii?Q?aGLC1sraMg2bPDHGyARBnf2UTohcbxp+16dQi2CLrKvwiQYp464fAakrUOP/?=
 =?us-ascii?Q?nWPYLL4tHpHhlBQB6A6eT8OmN6uJqqYdh5thmCI+gxMj6DzjuxEBZ//37d8j?=
 =?us-ascii?Q?u3oCwBcaP4p4PLQ2VWp3dnicy+x+mrHmthMQJ8pwHkb0aFL3CtYfXk1i7/65?=
 =?us-ascii?Q?G4Ea31SFgIuB0HLI9dXsNQ91MTgRAU3UjuxUzE/yaXSI/vywmgW4zrXCoWfn?=
 =?us-ascii?Q?2h68cwljNS0w1Exe4xe0ryn9z3md9Ip3jl1kSU0dp2yLlrDLzC2bY4k3357z?=
 =?us-ascii?Q?MomCOrW6/67yvEismRYUr+5L6n1k/ryXNTCRiZtKULZo3Z0V3JcMpMxD03Sj?=
 =?us-ascii?Q?KN57VsFD9tW93bBNyBVViPoxnOI0ajKmc78vNCMR7L6uCN1NdLeliue30VXm?=
 =?us-ascii?Q?ulrXSAji+k5vtS6ZqaPr/GzRkzaj92Bgifvx44EibYT8sO1MshTQdzqOAzm4?=
 =?us-ascii?Q?Q+AlsB2wHFRIdL/C4j8TgIrzRvDnBbrbZ5KDi32ueFblUMEF4CJgIaWv/SWT?=
 =?us-ascii?Q?hjuwgMLHF+kQFe+DnnMMb9v8fqv32Z/WbJvAuvwYuQkA3/4UUbek1iPnLicy?=
 =?us-ascii?Q?2nDZyO///MbRIrJfFqtqHirSn0SMgS1aI3pwV9cdym4T52bHDvZERXXBo+gD?=
 =?us-ascii?Q?M/u4URDhO7urhsH4XyOG8JPjytiDNd/kHPxn9bqCR1FXuX4p3kNisCwaZtsb?=
 =?us-ascii?Q?80WCRWHpINTEATJQ1dpPgMKifCIqU9ThVV3urtdjvcTZdwbGs2iyPUPfSYh+?=
 =?us-ascii?Q?NpPrCGEwO/4qDB+2ShYEV+BpKih+9Z6eR+yM5IpzmgjJulecD/DjKui+QS5s?=
 =?us-ascii?Q?RQflRD9vRQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28554fdc-836c-44f7-0a7f-08da2ecfbc71
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2022 19:44:58.3166
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ykf4zU114SRiAQy855O28Aq5B1KYAL+yQB9N6f0gOC/FNc6fIAQ31pIH6yx4A+S3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5164
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 05, 2022 at 12:56:14PM -0600, Alex Williamson wrote:

> I wasn't cc'd on that version.  It looks to me like we'd still prefer
> to see acks from GVT-g maintainers, Zhenyu and Zhi.

Somehow the entire To line got wiped out, still unclear why. Maybe
get_maintainers had a bad time. I'm watching for this now

> Also, I was thinking of posting the below cleanup patch unless you'd
> prefer to roll it in.

If it is the style, I will roll it in

> Regarding your other outstanding patches, I think all of these depend
> on the IOMMU changes, please correct if there are any that can be
> queued with only the GVT-g topic branch dependency:
> 
> Subject: [PATCH v3 0/8] Remove vfio_group from the struct file facing VFIO API
> Date: Wed,  4 May 2022 16:14:38 -0300
> https://lore.kernel.org/all/0-v3-f7729924a7ea+25e33-vfio_kvm_no_group_jgg@nvidia.com/

This one applies cleanly without the iommu series, I just confirmed it.
 
> Subject: [PATCH] vfio: Delete container_q
> Date: Fri, 29 Apr 2022 15:46:17 -0300
> https://lore.kernel.org/all/0-v1-a1e8791d795b+6b-vfio_container_q_jgg@nvidia.com/

This one needs the iommu series

> And I'm waiting for a respin based on comments for:
> 
> Subject: [PATCH v3 0/2] Remove vfio_device_get_from_dev()
> Date: Wed,  4 May 2022 16:01:46 -0300
> https://lore.kernel.org/all/0-v3-4adf6c1b8e7c+170-vfio_get_from_dev_jgg@nvidia.com/

I will do this in a few hours hopefully

> If there are others I should be tracking, please let me know.  Thanks,

Nothing more for your tree, but FYI:

The enforced coherent series is going through Joerg's tree
https://lore.kernel.org/linux-iommu/0-v3-2cf356649677+a32-intel_no_snoop_jgg@nvidia.com/

The bug fix for the iommu series is pending Joerg:
https://lore.kernel.org/linux-iommu/0-v2-f62259511ac0+6-iommu_dma_block_jgg@nvidia.com/

I've got one more series to post which just needs a last pass over
now, maybe today, but that is looking grim again.

It is alot of series, it is hard to keep all this organized, thanks.

Jason
