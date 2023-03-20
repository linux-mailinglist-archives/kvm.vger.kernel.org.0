Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC436C2109
	for <lists+kvm@lfdr.de>; Mon, 20 Mar 2023 20:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjCTTOu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Mar 2023 15:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjCTTOW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Mar 2023 15:14:22 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2083.outbound.protection.outlook.com [40.107.94.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D413430C;
        Mon, 20 Mar 2023 12:06:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EawYmCidvY1Ofzu+6LKc7CW8TxvcPzND3/+iA/5CN3EYhp/u/vCxvHMVIqp4BIjGGQ2GtuI5ijQD6cgMN6fWW+3zy9wj8lMckYTiRZNtaVTmgO+VktsUp8p2QgQN/CiOrKsqQrVhyJBxAFJOS3vK9RRO7wp1WCtN00t02SN7eU5ZzB3n9X1NFe+V8nvoOeCw8sDAAL+yGIKMnVIlDPdP+7q+cLhlOeOCAjejMYvUF6V9M8R/vt/ZfJbDOccQsAJo5qWPGDLvvNq+YKltSpNS7zkkInfA2Ew5W2pcJXg5LTdQb3vie+V4PIHRKGSUf/GQdeZTYj9aNWRbo35MhJQKxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sH273hnwC4GDEsKFruvuobGRQEWtZMP/oPxqSxzphBM=;
 b=jQ5f4PSo2i7pFz02AhKuV2y+wSHEHop0HeH1Eq9DHALvAX6OEjiaQCUk0jQr311ruLnOarFjYRYRJq6fwpMGLx6txdbB011IpylZPCYpms+kb6sqF5BW+ku7ckuI1rM0WLUE1JxfCs19NChUpXTeuPA/q4W2YgQkhXGnYUNsJ9f3UMYGCG2gi1QHkRwIbb7TNinSRAADBJ44ujTYJEETulyznkY6c7GjjQ2BqYkYR2PMwjq7hXPttYJy8hXSK3Gl0m+0HgvcbQ7DtMG2HwcISKWNAJzjs4lL0lqgxQHHI5K79IBxNoq2B/jU0a+Shi99c2wDg73flBeCdDVoo+rTBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sH273hnwC4GDEsKFruvuobGRQEWtZMP/oPxqSxzphBM=;
 b=oOWjVQK9YKYCJU6r+JQzH8n41ERpB2gT1U02yVq6pwlwim//crhnzKA+hdAKKAOH426BsbHEEWHHk0dCbyhBZBkJmkDNmJKpuA2mmBAs+BA4sNwBGwwmfzTKx1s6MN+O0fJ75g+BmMelY62ZvMs0/U4f5HStDzb56uZWHq+Cp/hgPWWH/GFtMaozTzgmjQAMVTnvuKItYuVkUKqW3YmhU7A0enWJRhrp6tLaZlILf1FDqDjNbqd8yFp75VMT8/5EUhVUNOsb7Z/+Kpc/p1clyaO5xaRLIGYjoTJHqBZrrNAkUdo2Bd7btgSIarUZplewuv1nYlAHBxkkR0WYuY9uMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4378.namprd12.prod.outlook.com (2603:10b6:303:52::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 19:05:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 19:05:42 +0000
Date:   Mon, 20 Mar 2023 16:05:39 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com
Subject: Re: [PATCH 4/7] vfio/pci: Renaming for accepting device fd in hot
 reset path
Message-ID: <ZBiugyb5DB/jCC3q@nvidia.com>
References: <20230316124156.12064-1-yi.l.liu@intel.com>
 <20230316124156.12064-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316124156.12064-5-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0269.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::34) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4378:EE_
X-MS-Office365-Filtering-Correlation-Id: 19395614-5f03-4a48-f5a7-08db29761993
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YYXeG2RTVWl7Jbid9YqlSJ5Wbe6K/2vvU47gOzVyfvse3cHbVGKixyPXQToLun+vL1+vo2uomPoIKOzJP/cpFw3Pd3j/MgkStZ5wegVUgRH2hgEsuRLWK3YLghpqb0nHgxzdFervTDvDLjt6BmuuyM3p2w2OWHG4MXbgOVWuvDqpt5kEQqsikUVymcJ671lStN+vBJQXUUCKaH+KCC+5iRCL+Fey5J9yJcMiYzQ1a9WnRh6winHbrLZ9jRXSpFjq7+Vo++UjTUpYSOTdYpqAQljKqkQiyUGzzRLr+kPdbBnIZfQ8tNMBxLUQakehrr/BYEE4myill+7OptVFq/DT+4HW9+zveh+oT+0AeRvBe0UJ8pBko/L/lo0d3cSHtn97vBtYO5ubR1cKyDlT1dKqrX5y45C3QxuvBsIGXZkFZ+kb7i481eL/jzVeDWyREretAbXNyXULbP6Lt/WPf4Zl/Tzt/9VrQ/tdZSvOl1RV2GkVBdEwwMpVe1lUy/YiJCD7K8uwdT1+0n/tLY2HsbdbLUNHSmwdiOejK7K8M9QM2pPcHh8fdx5rTK4rPEqodau5XIJ2tmP9hoW+WV9+mvfLrSHkdlllYb2TBsVJbKiSZpYj0GpgkEwUv+Hx/1ipsLAKNF5PVz452Yome98/H+bkaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(451199018)(6862004)(8936002)(7416002)(5660300002)(4744005)(41300700001)(36756003)(86362001)(38100700002)(2906002)(4326008)(6486002)(83380400001)(6666004)(478600001)(2616005)(186003)(26005)(6506007)(6512007)(316002)(66946007)(8676002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EOrU1lQchmSZzc3JGwpPSj5euPQZ4wMbJr3TjOhAkHX1GhonF7Hpi/xcO88i?=
 =?us-ascii?Q?jXt/05PjYrnlmnG2q6+gDZbUi02mA/ZyC+OvJXMK4MNoA4MIlsUjqtpnxbhk?=
 =?us-ascii?Q?eHrIQySXVhQHWBeyX8WZC9mGYUWBIpsTVXhcVvR1ouLzTrjLHKLIk7XcyKxJ?=
 =?us-ascii?Q?2FflyrVBgE7CtvPlR6jiolSGyn8oLfbp9abCZfBT8g3GKSXRyeh5s3SMupKC?=
 =?us-ascii?Q?Qb4/+7RgGlz8gMBep2g25fRxSboPCCkkKMVZT4tlPyDy41pnQ2Iz3lPrUKAQ?=
 =?us-ascii?Q?zwFV343nCcXAhkCBvEjOvzZpJdR5w+9UIZEHad76xoo22BLh5ckslZKya5b6?=
 =?us-ascii?Q?2fDKINlJRbtRtfLlDKpL/L/RQZhCM7aCiYG+2w+NHn/Csn/ncyqFvGvw96X7?=
 =?us-ascii?Q?+rl9gZyQ0K2hXL8wbnEwc6bCjNQXheIfPWVDzfT2Da/AKLSWEO6WL6BpB/s2?=
 =?us-ascii?Q?UKu4j2Wko8hZ+BQz5OIIF0EIxxZzPRkOPXiPAt/Yu2blwrC1m+K2r9TwyrS6?=
 =?us-ascii?Q?LyqaRZyq4EJVv14mMzljlsavzEA3e0KTFN4jz8GfrmKUruuzd+zddnscbOeQ?=
 =?us-ascii?Q?ieNWdODEZ2l2PTt3u+6PJhSOYRYWNN3dSqX5oDQrwyv/9iojQnIZA+h+y3Ca?=
 =?us-ascii?Q?V6vcgHKgqfyFTD2Oi7V7YdMDhYwNv1XH2w6BkssYDwuon+XTyZA0hDjL2W4I?=
 =?us-ascii?Q?n/zsVrQvCUEueVVaHosQZfwIicph90t50Z+zJT6/cOYqlmb8NP4ZUDrgCIis?=
 =?us-ascii?Q?+96/YHBSWh1ITwkqAUMDUloPqJae1c+5m6Nk0Xtx1a0gC9ncw2U2NBaFPPJb?=
 =?us-ascii?Q?nYXxnP/qtkDJcF8cnLvxtmAGIMMKQalmPpTWXt1yNc69ZeWvzP34qIB/aftO?=
 =?us-ascii?Q?SEXGZ7QJp7jy6OTiZ6C8z22Kfgo9ij+9mlss6YJroYxpoz3v4oMHFFUWJQMj?=
 =?us-ascii?Q?OhPKp3/NU41UbQDwQAKvxi2vOQLvGPm6tHlJOHgh1NlFIc3oL7ESRyiAhZgs?=
 =?us-ascii?Q?lD0aApKVWnT6+0iYGz6q447YZfDGgFJA/w9ZYm+cZX++p312DyLlG+kFVZTI?=
 =?us-ascii?Q?eIzzgcv4at02GpIM7mLhR5DGvZVZ0n46Oc/njRylIRLnZYSC/UyXvxgajnDi?=
 =?us-ascii?Q?3JfX3A8/bHdNiXgq/4gfIv2R8huEw5epOi7s+6fBfapsXt97izqVRcFL70Y3?=
 =?us-ascii?Q?ZafwbVTWd1VAKZOA4ivPkNcnakdhCcDTmiKygQQzkecBg418rZ55R6M59Lbp?=
 =?us-ascii?Q?9VyN3WYzsaZIZxW+y1PH5QNlkyWhsTfeH/Qu6+5x7HJ0FDxzEM4efvdYY4JQ?=
 =?us-ascii?Q?suwnN8ohy3oVpfXc4Nw+uEXjqBwj2CH2oMYnXj7cGa0PNkRNU2ZQ6QDG4+Yg?=
 =?us-ascii?Q?/oUZyExyGmuuwdY/ky/RcT3vE9QLbdXskNSR/dxxFe2QF+5FjJ3lcYqFYOvS?=
 =?us-ascii?Q?7Yn2/O6QY3ov0Xd7HGWMLEW8tB0I0roiNycEpehhwfN83BydxhD57O5Mr5CX?=
 =?us-ascii?Q?BoDL0KMNSc1qrnJjePz8mBr4R/ElhWjvx0YOfS7FCa9XVeYha1HYLEBDM0GG?=
 =?us-ascii?Q?jM0/q9Crewcm/7Un1t8te4c22Z4s5wooUctiqEWE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19395614-5f03-4a48-f5a7-08db29761993
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 19:05:41.7076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZgfc9HtiXzPD95WtVX6fEseyxtI6ZiU3SiqO/urckr4Fuxru2TBCwCcipglMn7B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4378
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 16, 2023 at 05:41:53AM -0700, Yi Liu wrote:
> No functional change is intended.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/pci/vfio_pci_core.c | 55 ++++++++++++++++----------------
>  1 file changed, 28 insertions(+), 27 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
