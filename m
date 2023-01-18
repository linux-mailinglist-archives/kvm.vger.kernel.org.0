Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBF66720FF
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 16:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbjARPUN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 10:20:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbjARPTy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 10:19:54 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2061.outbound.protection.outlook.com [40.107.223.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E36B859576
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 07:15:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbrOdf6aaaoCgN3s1GQXxXWV8/Po0I4SSZj+2kB92mlMMqmOhqoOvSLm5temZowPI0NWTh8nbUJsS4eI9yWDv874+jYyeCFpBSHazqn6BnZNebVvTgJ9Xj6QuypDkRhs1gHPRl1hsbcBzT6b7Tm4iLmG/2SJoZLIYtHJveeaVQP3ZN74fcHK2q/g9LQWR7S8Fp5IYJNV4ChOCWpsyCpQCbO/NRFwEj9Bf/rXVQvLMVTbcbo814WqAjspn3tCSGHkEQzWUQvFkzrO9Nx1wHFG4kghqWYS53VFt39YQ/BCVukMm4wW8wmtJCKqvSQsnVOqdTxwdNH98KlPml9mlBNVQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YAftXuRAuijm/Ezy3sQy894f1vRZc7yMerQeGIxItDs=;
 b=nHnrA5jKio2aeYiGzc3N6LGYx/Owdvq7a+lh5mcLJC3OzEybeKh76Wo6oYEWG/VcUbzNg5HD/f4N003lJMIfaVekuSpSQIG/zAopdEmC7SKCIj2ycuLUGI3s4yMFLRiZ3B5r2C2GJrySNix4ibEawHjjxUSr1DgitZtqXMt6VaL6i2aTN3g9mZbHBZJlEAU5TLxh5SKIFaNDBTdDn7+JQt2VSNLGqXx75yeqlyH82yLRFz7HLcZlWZoJMcZieAXCnDPanbm3AwgmHGcAHS6Tc3HyvjZwLTBz8FTuzRSt4AjYr8jR8GK8iguyZ1QiCG48qRcv7kEoq0LFOq9hKdHrgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YAftXuRAuijm/Ezy3sQy894f1vRZc7yMerQeGIxItDs=;
 b=G9g8CTJmtJWRh8Or3j4DZlGq34X++1wDsySRa7HwvuQdSDtWKQbZYscvO+lU/CeNbSh3UJP9pXzmWS/MvXJghQUKjg4N0ibM5ZDFMfdSJZU9MBVb0zKM/pG7bMTRgSAlQGQvEw05mj2eToIMw/yS3vxuhetxbvbB8BkDzdT0QdSzVORyMH8a4mq8l2OkFFtBzM/D7FMwKhF66j/8plhVNOLyYKlc7NcU/f9B+A3PTySNVtSoFmny+tepqb2R98tFG2l8BQEFQrTvv5osZIo4M4doixPmU50KpMd0vH+7XrPYyvTIDvRD/Qhx2aUZyNDercLChdjlyslOpFPlG40LFA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB6438.namprd12.prod.outlook.com (2603:10b6:8:ca::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.24; Wed, 18 Jan
 2023 15:15:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%9]) with mapi id 15.20.6002.013; Wed, 18 Jan 2023
 15:15:09 +0000
Date:   Wed, 18 Jan 2023 11:15:07 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        kevin.tian@intel.com, joao.m.martins@oracle.com, leonro@nvidia.com,
        diana.craciun@oss.nxp.com, eric.auger@redhat.com, maorg@nvidia.com,
        cohuck@redhat.com, shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V1 vfio 0/6] Move to use cgroups for userspace persistent
 allocations
Message-ID: <Y8gM+9ptO2umgPQf@nvidia.com>
References: <20230108154427.32609-1-yishaih@nvidia.com>
 <20230117163811.591b4d6f.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117163811.591b4d6f.alex.williamson@redhat.com>
X-ClientProxiedBy: BLAP220CA0016.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::21) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB6438:EE_
X-MS-Office365-Filtering-Correlation-Id: f18a5daa-31b2-42cd-aa2b-08daf966c994
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SLWdeLWKD/8veuaSylxBdvuoBonf2u52bsKRTQWI2GwGBzEhy8KoDmQkzHJPwldgRIh9PkRvIVsBP5j5ZwQ6ORznCi30JmYwYCjLqMPOVJgN4oKUp1JBfw2dYGqB3lzGTowFudFfyM/p2WHc2uNhWu686xgJCXwIs+wPBmjxVuiJHuZg0niO0WHF3Wn1moXAxb1i2BGGQyvDt525XE+MyzGAU25j8B0LHtw1sfXAhbxx1tHmAKnRdfnHYt7V6N/wok66nHhU19FaSCB+pElSisG6sE5pgd8m1MGVUHxfy/iH1qPC8bfI0a82FZFnbi6QQW0g3o4Et5XQYB1t1XQgyXeB3KZBHFNdb/CivPre12rsjglkSZ1pehF4VYDYq1vIDvIo5m+4G6rPCvBxcI+YmE9FgVcIRay5m0PCuXR66DqNpRxbZ+zLxCdrGZRAf6PDxKGWTmrQlWoFaDShivgfi+72LDCOO+jPqrFDPqBr1DL08u0Mp2Hngy1PNdKnGgzCdfvtYkYF3w3ZSbDk5b6iTzZJvmHASgOGtGt6DdQ5UBAGp83iE+EyrVNnGVX2d7L7NyHSarUZP+YqF1Mh0ftzyP0XzTrtk2uZUIU4BMcyy69jI8bVrhBkDo3xh6Ev0RF0bL7Eyd1KgobSrkJXcfHm39LyY231bRqdbmK+cdLk2GMmeCO4v2NJF7Le+pwIoeob
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(39860400002)(366004)(136003)(376002)(451199015)(38100700002)(316002)(66946007)(86362001)(66476007)(8936002)(5660300002)(2906002)(66556008)(4326008)(8676002)(41300700001)(2616005)(26005)(6512007)(186003)(83380400001)(6916009)(6486002)(6506007)(478600001)(36756003)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?um2e5GmKKVJoJZmoDEu1wr32tfjKEUdIfGt33QZKLizTMZ9TmiGeOnNED+bU?=
 =?us-ascii?Q?azBUsdAJPL9wiHCqAtcTuTreNYXc/kZYznAxVkZDxq4Myj1zcXwZ6rSqLfGl?=
 =?us-ascii?Q?njCx9rMPvo6H3U0qhffA89yHxTxRXtlBZh1QeZTdg1ckTUdFGMH9sxnBVpWD?=
 =?us-ascii?Q?jYr3txkeMz++aA5ubjnkfDfc/EdNpEQtV69YQkt7w8YFuOclsWbst9Wv2s0f?=
 =?us-ascii?Q?l8zltJ/XgMENOpRc2kKrSsxrczlSOVMJZP1pQTjgQvj//V93R4cApVFM+3Hf?=
 =?us-ascii?Q?zJT53s6zIIHJrXlzz1K2l+9QweL6oZMxPj/JLQxu17QiOTFk7I6+pMNR4zil?=
 =?us-ascii?Q?Khg53lXYNqOgx+WtU1UQV1FO33eUxV10xk3Ll33/QhQ2/Rrs9hr1jM33/3Gd?=
 =?us-ascii?Q?XmV1eTCYdSVXcw5p3jbWIuefuzNkW88SEIuPuTVZgyNSLCXTqsAK86G0F+3Z?=
 =?us-ascii?Q?0Yy1SYsPoxAPoY4sr843mZG3lafPxa7MOIV543PvSt9anO4dj19TtrnsMMGp?=
 =?us-ascii?Q?16HM+VXr6crwIqoX8e/B1e9KNFb2n8TSgIBQ9ipL8+nYgAbBTu24rJeTdKZI?=
 =?us-ascii?Q?SF+oKgYzpJO7vdvTSEbH6I7ZQGUI2BwzgT/iJi1wUb/gQOzf24tIsMOVMnIy?=
 =?us-ascii?Q?Zw/beS54d9uZ93CHRVLnpr7SPR6FotJlXjSzsUR6EOBfT6L+RkY7uPSXAweW?=
 =?us-ascii?Q?405XxXXwE1/VAoX67PBPioEoMGOvuT4ecHOwUn4Wq/p2jEgLuHev0A6eqNRb?=
 =?us-ascii?Q?dhr2zTbXW/SlillfNGNyePSOMn7Hdn8lRQNXyx0VGKXwxYmBgn908QN14jw6?=
 =?us-ascii?Q?oNcchTYtXhm5GaI+63FXlTRNvpGhwLKPwBXCO2FMAch7fmDG3XdVue3tnwIX?=
 =?us-ascii?Q?zU89ON2JJYXkxrYyj1El3P2T21DM8LxloyJclS8a0nRBWHpir9M3cObnc+CO?=
 =?us-ascii?Q?H9Exi/C+1TrVeAxE2aY2Y7X0NoacHQa90jX0cUOkv4Go/wWKhemJgiooVM1S?=
 =?us-ascii?Q?xl+ctBDQMpok18QIVU1zt2SfTP/RcuIoA1uqjjGjoBwdhJcSSsDkwLnp3NS2?=
 =?us-ascii?Q?0MOioE6ZkzqD+O5M2PlFK7LQ8V4U12Mf5I3Y7WNJE9DKjU+exsHtW3Lge8EC?=
 =?us-ascii?Q?DZX+thQJtAqIzk5J638e2mJBz1ErvJt6Rp6dZFnv4X81BhAenV0KGKmWUA66?=
 =?us-ascii?Q?XNjvDXAQPfgdrZ06jUQD3x1t3SIWbNIHYrJY/GaZnOMU7HkBzjHfqsI9ZoPK?=
 =?us-ascii?Q?PUWlYnjAIJsQTXWSbp0XsUrlX1Nk6+1GWpNzMN+T4zxscam92HPc6C7Eb6ik?=
 =?us-ascii?Q?Be57NUuKEHcQZ143Xrsr0wo4JUUYNcUEB2w8aB0ASj6d4DzBOu+LB+u59wfb?=
 =?us-ascii?Q?2bZCQiFFfZwYsnKRfVuW2AzdWj05F6vvm+SwJCSBcl8ehjrJq13fMs33lY+d?=
 =?us-ascii?Q?En9B86uEaT+svrpVW+uYdVw0Xc7Y3Adr2r8Rcq5o73aftjicNSgKYq6qj05U?=
 =?us-ascii?Q?CYnFuShsrm6cjXpzRSBr5KwIzNWreh/q4+hpZbCwpeM+QjgwxJN6PUGKjOOl?=
 =?us-ascii?Q?vfFYSnW2JJ7FBw+5ybLbwvGie2y3GZ/5/2HWlDMA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f18a5daa-31b2-42cd-aa2b-08daf966c994
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2023 15:15:09.2633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wALiTpbp0M5F0iQEWs8/23YT4snpUNMq0qTbyS3YEpgQ1fo5uW4Z0cvQd5d6B5T/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6438
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 17, 2023 at 04:38:11PM -0700, Alex Williamson wrote:

> The type1 IOMMU backend is notably absent here among the core files, any
> reason?

Mostly fear that charging alot of memory to the cgroup will become a
compatibility problem. I'd be happier if we go along the iommufd path
some more and get some field results from cgroup enablement before we
think about tackling type 1.

With this series in normal non-abusive cases this is probably only a
few pages of ram so it shouldn't be a problem. mlx5 needs huge amounts
of memory but it is new so anyone deploying a new mlx5 configuration
can set their cgroup accordingly.

If we fully do type 1 we are looking at alot of memory. eg a 1TB
guest will charge 2GB just in IOPTE structures at 4k page size. Maybe
that is enough to be a problem, I don't know.

> Potentially this removes the dma_avail issue as a means to
> prevent userspace from creating an arbitrarily large number of DMA
> mappings, right?

Yes, it is what iommufd did
 
> Are there any compatibility issues we should expect with this change to
> accounting otherwise?

Other than things might start hitting the limit, I don't think so?

Jason
