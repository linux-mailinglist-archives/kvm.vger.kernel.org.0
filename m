Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1B6141A3
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 00:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiJaXYh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Oct 2022 19:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbiJaXYX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Oct 2022 19:24:23 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2056.outbound.protection.outlook.com [40.107.223.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38471116F;
        Mon, 31 Oct 2022 16:24:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XhbzylFyeYx9CdhoSx30Bq4qJDeXxJtCu/MTAcSafBYmI9H+65Fvny5oC4POXgLlBkNFkLQxhuV5/eRB4WkdWBmDg5UhcCsky/g9wJzGeojPY+g4d2XNWQNiSQp7r52UbsIJNdhPSAwUnkhrMfZpxcy2ZRSUjEKhciShSNx768DB3ON+A4c8UyST9YfcesnbXTX1Vi/qHwk1lIAb+X12OYpbfib9icwh+U7bBMUyCe70k04AGcVmwlylg0eW8/32hhhMzLFJIIcjr2BqjfFj1qwE5QP2wdASIP9Tulzd3EGJhXG9o/HD/iMgfhsgOyTBDTv1Idqkm3AAAvRAX4UEEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rfT+UhN1hCVxNARMVWehY2yYimz/SzErbhDNhnBYRNI=;
 b=NOcXXQB+tOkrR+Y5NBX7G0C9zsjdgl4K1dGeMSspmAUf0/tz8Lb/juXeU8ZhCmMo7WAB5xHCn+PQwaznKRNo9qyKnuLKLT4yezyFo8qc66Ap6l/rjVo7NywxdpGc2X0V72il1Ov/himagXuUd4lFzPLCxKj9wtfCkGx9TL/Kca1fy1NNFb/tEwAQ8eP0X1lgIgyLxLoNPNmL1rCkwxC968EtgoMooNhooZpOT1fegj11edOJ4j7uVXKn2XcRrDT7O0g1lDJ95pZz9RlWGF+g/XjVUKRP2S7WgLu5Pe4+hTfXf660VX3IftXUtcof8WvRDo7J2NGBO59cma+3g9/Zug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rfT+UhN1hCVxNARMVWehY2yYimz/SzErbhDNhnBYRNI=;
 b=D9vcslJrw388IPWUmjlt4b/67U9SKX5kw9DNy1tgjwyD88F6/UfUw6sM38r6ykUH/GEeFeJ2u7REwRE9HzrRrh13fj3BzfTfNURkNKtAc/E0zRapEuDkgEQ0/XehAu+uGpY/HQN8Ejj+CY5h6/TS2HJppu2HbayiztTG/GyGPRpUpWRoLBdH2u7o6eFUHA8M0Zrwxjxgo/hDPiC3nKHboWeORp+iWvHKxwakuMwvwRAkkn8U96haRPKUk9sSuoEm0RY0S6N0TtRuJ37iCroRdlegisdtteKxf7LtqlfdP/8Jjj3arTdcP2YN+QG3PE9k0elJdnGIgCRPmkPvevttVA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 23:24:15 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::7a81:a4e4:bb9c:d1de%6]) with mapi id 15.20.5769.015; Mon, 31 Oct 2022
 23:24:15 +0000
Date:   Mon, 31 Oct 2022 20:24:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     Alexander Gordeev <agordeev@linux.ibm.com>,
        David Airlie <airlied@gmail.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        dri-devel@lists.freedesktop.org,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, iommu@lists.linux.dev,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Longfang Liu <liulongfang@huawei.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Will Deacon <will@kernel.org>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>
Subject: Re: [PATCH 00/10] Connect VFIO to IOMMUFD
Message-ID: <Y2BZHZXJwxF5C4a8@nvidia.com>
References: <0-v1-4991695894d8+211-vfio_iommufd_jgg@nvidia.com>
 <39eb11ed-dbf2-822a-dc79-5b70a49c430b@intel.com>
 <Y1+9IB+DI9v+nD0P@nvidia.com>
 <d8a0352e-9e1d-5b01-7616-dccc73a172a6@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8a0352e-9e1d-5b01-7616-dccc73a172a6@intel.com>
X-ClientProxiedBy: CH2PR20CA0019.namprd20.prod.outlook.com
 (2603:10b6:610:58::29) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS7PR12MB6263:EE_
X-MS-Office365-Filtering-Correlation-Id: 370d6fd0-dc20-4fb8-e6d4-08dabb97069b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YsKVJ6EAyQEFJUvZL8Vm8ERFzpnUzVfRYY1+0TYXhDOLip1I4C2S0Mp8pYywGorJn6l4eArTs1s7l7vi1vUdcVguh9LpB6awEBLciH9woNHzbDIKqr07UKihdVpn2JyBVKoZ/9SLx14np3n5ciS17X19Vf+NDm8QUql1bwr2yVcK74cJuxOnss8DZ3zrH+lQdVrf1Lhh9N8hh/DDWmiIoQJjT0GbFRgJZx7w9clZ3EfrLmoBSVmsmnhijqXFpw2GESiTTwxQPGML6lYMcExIyhiKPPkJEVSQk8xbikCduTxpww6yxlyAPgSFj2n0xHiJj/DdquUzKyeziS5YwLEDUhhAybL/+HZDowtq3RumcjFOQTM/jZQ+54WTtosU8oz4ifp4k2yaowuyDKpJvWBD0L5aGvXsDnhZL9lLCj/q5/xlZInERJEhqb+yC0E1ZaEZJxceK0v1ndyLXcbMTj2xAq2PcMwDSeqvLR2wxRKvLknz6+Whs34N5+l28lISPkoKMdX0iOEeMnBGqHgiuiRbu1FXp5pDc/2PD9fQW+bbsu1PR+WOYUg4Sp9wokJz55q2WPzErcGW9kLvzVrZf+ZtMpQH66iXqSGSf6E2y3yUS6z2xKlDCwe6e75IweCGKfS+sj5PEcp+0DftyHve+Jp7zAcyWf8gA0Dfk31UUIdo+7F8gXin6dfN4HAY9XrVXuSFg4/VkkLNC7vZKgyBXgIlbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(366004)(396003)(451199015)(83380400001)(2906002)(38100700002)(478600001)(6916009)(66476007)(66556008)(66946007)(4326008)(8676002)(2616005)(186003)(41300700001)(7406005)(7416002)(86362001)(6486002)(5660300002)(36756003)(316002)(54906003)(6506007)(107886003)(6512007)(26005)(4744005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EJHEKWVKqiWAi5oxg3sgj0Z94NxHiaxXW5xKJ0MzpHKanJMnssRnRSsnfD10?=
 =?us-ascii?Q?PGJfmh0vOpw/Tz+Zf1CvlbjggkJDMmNRRBUaIgXCUiWMmOwpcDQofq4x5bfB?=
 =?us-ascii?Q?rJoVjhcDrGrhPH8+2j89Gts8x764cx83Z00BY5WZJMrS/YSvs0Ix8XkRxoLT?=
 =?us-ascii?Q?XnYOWqOxfq5+SS7ohtQjGfa1vAVUcU+Zv2B8qrZ8IAdkYwA0+LHloABChJWO?=
 =?us-ascii?Q?oAytzkW70WaEFQeXHBtzgj8xXz174+Sy22VyNfaN4KtgKwcR6cTgEXU3tutf?=
 =?us-ascii?Q?jmo1SrrFKDnIu8Jbvcpqh0N6xrBYHADDDGuiL2tSCGQOuW0JyilPAy147/FB?=
 =?us-ascii?Q?5mfChpLps77oRfV6IPfhLmRWAJfsBTsIkpVdDuVnd4fFObg5PaUCDHTgyrYr?=
 =?us-ascii?Q?9VG5aqRNN0G9nhZlSFxq6c/3vPiGILyv65F7xia0FQ3BolvG2o9czF6LbOIS?=
 =?us-ascii?Q?h03KwM0/Al7Vxs07BupqXTVU1oyZdwgVLOtgQ0K0T9PTHgAAVY7BTWYpaEE/?=
 =?us-ascii?Q?tjQUYDMXVNs/hTsuv5Jtx7aGLGEV4wKWoCfCn8oZJEG9yfkDI0kXGd+aGn10?=
 =?us-ascii?Q?CiGBTSo/pS5gVVdWNAaYivp+OFu8tah+uUetCxfWLcyKWvnAIpcNkZVm9nMe?=
 =?us-ascii?Q?VbyqSWhGtraZEHCic8aArB7UTa0R9A5TqeI28tW6hBXu/WXKR5Ezyuu6Mxlv?=
 =?us-ascii?Q?0L9vWclLGW52RR3NP0JZDHKRAspm94AixgJQT1zidIdfLnZh1zbohx+p7bGm?=
 =?us-ascii?Q?RuQ0BVrHOLcHaJCsVoVxn4AGgpP2tDjn1UF+ZsFFs6++3BUhBRqVlm5AkWFK?=
 =?us-ascii?Q?DQlOQHN8ZgzL3tK2zpcVnXlRxcIjw1mfPlYInzl0Mf9n2rFg7As0MEQ5cuKv?=
 =?us-ascii?Q?dbPNGD++QiBlekmpPNw90eUN0u5LZdbvaIrcfpNUmcxp7byEL3qzpWJET2QN?=
 =?us-ascii?Q?PnP4/Glc8fsrJXoW9cqMooZLJFVubBprumQVHH+GEj5wXUwc2UNOEfEdyBFN?=
 =?us-ascii?Q?kNZGmwFexcK+edCrRvY3B8yBJr6ulxLSArMW+jWfPM2n3S/Rdalg1OTN3OlN?=
 =?us-ascii?Q?lBlFa3U4Ls5zkGzVNMgi4C0ezEmxQGnAEUSLc707PoxJK94LURgWN6aizxkQ?=
 =?us-ascii?Q?Xxyrbca971pxDn3qdkhpwKD6N8/1AujKyJCfSkPGILwTj+vK+WwkXd0a/Khy?=
 =?us-ascii?Q?S4o6+SpS3/oUksUoR4DFlJdUI4xCKvL+j4mshi+MVDo59Tu64iBFOchvgaYd?=
 =?us-ascii?Q?fxEGyF1g8sifJ58E67MHXfZI3IljTvFNndsyEkaYKTliNiG+5dAMJoxtubDD?=
 =?us-ascii?Q?nQh90i6TcmhEvU8qo5/+2gSF4b1xSzEGxpEg/t540M9dXs2Vv83VvbYG/equ?=
 =?us-ascii?Q?M9MUWJz+CZKt4Oef1oiZNdHzPdkr6F7VlHKZ3F/L7uCLZrZpB3SaMb2wGA8K?=
 =?us-ascii?Q?ECsgRvf8aQ01EUg0A9n5LZwQWVgDm3R5sYaKtKCryMdJrpUXnbf2RRfQJhHo?=
 =?us-ascii?Q?n8dB8tbgygteUNjBqOdYohe/SvbhloKj8ccLk2xU0eL7ux14/BhxO0UvHnG+?=
 =?us-ascii?Q?rs3YwUu+M2fcIWvL14+SzZcM0KBcCMEgFThUrheS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 370d6fd0-dc20-4fb8-e6d4-08dabb97069b
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 23:24:15.4025
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vAxSics9McVZYP6+79aV0m3nd+2pVjVi83vK2DJIjEHyb+icTpeGBv3jE8q7tdjZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6263
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 08:25:39PM +0800, Yi Liu wrote:
> > There is something wrong with the test suite that it isn't covering
> > the above, I'm going to look into that today.
> 
> sounds to be the cause. I didn't see any significant change in vfio_main.c
> that may fail gvt. So should the iommufd changes. Then we will re-run the
> test after your update.:-)

I updated the github with all the changes made so far, it is worth
trying again!

Thanks,
Jason
