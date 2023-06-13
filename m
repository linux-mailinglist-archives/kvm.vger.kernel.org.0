Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92C7B72E1E7
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 13:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240072AbjFMLqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 07:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbjFMLqN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 07:46:13 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 782D8BA;
        Tue, 13 Jun 2023 04:46:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+U3wsFgVQYA8G6fEM2Xos8lOzKVV8aU1esEuUs2V7bLN+tcYu+M6yGIZ+ytCyKemZv58/vHqKnJSV3QMr1bQPcSlggd2ap0P5BXQpqs7pSqPjBQalN1XkTKxgenWZCzecEVoxb16CXfgiFsBPjxRjF/ryGmY1B7e73n7Iz1hG+SvGMYW7bXOwgvqrC10AUVzig9VGutTnnvxEzRo/DBOEuCV3foI9smIMO041SS8X5bFWNOZ0YqhSKZBtinpun6438UV1XZZGfXUGAma4t2M0AL1NWUOEk3MH9fkpr7S6RmyF54TTXXbq+Mvo4iJPZz/XeDkKfefH0yelvymFqSJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Jr3Fo31H+YCvBb4dDOs/EfIGSmv+DlPDtX7g+aFApNw=;
 b=GcbFXX4WcWVo1kNOFWbilfX3F0QLAzL+WEC0PLcr7X8Q5pFON3eoezrIvzz1YVu+a2S7S2kMg39zPFHbbwhROheA4BdEkLouvr4hc3gllUIlEwI7T+/NHk1J4IjDNV3UfTzBDmmhrJXLktDDkvh2Msk3h3asV0eU9Y+iM4rWlQ+Xc6iCHZXKE5ztBYcSkVblwFnq/XJoKkyQWZk+mEtUnibFG0CkyXL3FwW5kOcFu3zAl6Ryf9PW3kRluflTjc8zfbPMrQ+x/AkEKweIt34mqq9a9Xat//fDEsfkIE5wmh3JlmHXfkt/N8Q+mtWoE4LlEFPtd5XP/8uXnRpXcmbMaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Jr3Fo31H+YCvBb4dDOs/EfIGSmv+DlPDtX7g+aFApNw=;
 b=cv6qe/CokualE+OoJLyE7EJfnjd2b6zYncHIbTYUGWmX3EHUI1rMGbL5k4hAL8jTE3JgxBrJCRZFX/UxvLJ8wnndKsTcvK0MI6eAghmkfBuijLGorFKdybhY1vZ9BF8Qib8yVkZd/GVqFxyGr6iNzXHAeyn6AYoX2DesArf2WCGPyFHcboa+ioPpV2F8pubxTlifaAlFe+YRl91qeHLqW/WzTftnwGsnMui1GyhafdW48Ryf1AAZo8tVarHZkkbeOKwSJ1dR6LB7NKS7yByosFeTTW3qIDPFDV0HgdJe+dsj52fc88HQqH1YeH1Kh6jOrIVrs54Oe+B/YqWKYfnNEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Tue, 13 Jun
 2023 11:46:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 11:46:10 +0000
Date:   Tue, 13 Jun 2023 08:46:09 -0300
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
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com, zhenzhong.duan@intel.com,
        clegoate@redhat.com
Subject: Re: [PATCH v7 4/9] iommufd: Add iommufd_ctx_has_group()
Message-ID: <ZIhXAXJiFJwe4r+X@nvidia.com>
References: <20230602121515.79374-1-yi.l.liu@intel.com>
 <20230602121515.79374-5-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121515.79374-5-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR16CA0051.namprd16.prod.outlook.com
 (2603:10b6:208:234::20) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5318:EE_
X-MS-Office365-Filtering-Correlation-Id: 82cb3a5f-888b-4e36-8f3f-08db6c03c856
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6MIaudHQHf2wh6qLmue1px3B4R7Z2YvXofiWNmH5kKF7Dqtp6UVlhTgZi7c1QGj2HYlkbC9skZOaKovbD8eKZdFFm9OXKayyGOK70d2pA+per38fEsV0emq24yNQACr0hZo2Xwr2UQgotV/6Z3mq7MMXHgIWjsOy3uDsTbyHFc74qzoBUWndNHudyxnxb2zzJPInBvH5qkdeO49wwBUj3dwqAoxvwEn3B20NkakJ1qSWKVKqnvluGIEWgtynusSGpCCDwt4tg0AAsUGRmFU5fR1OxGoP7KQ0RKa4DcPX/UCEk65kPD1nYSYFHAcu7HnFivf9mWKjzWSpNYiuyRChY0SIrnq6FpUjZPTdfORxGdDilc9x94T7hNDr5wXxeqir8vJOD7oZaRfiV0abOxx3ND/VF811cCdgvcqujCop38vg+EKDW9Y6KkChwySXkiIn9+YI8zYEzLPTRmZXLCa3KSGE3/YM5f7FlidmKTBhXDhvJjmcQoQYpgwag7qzVKKYguYhR8xsjb2Jh8eWmutK8umFwSgPPb+tJKwkNf/U9G9VCJ6z745BtAvYcd8feDWA1zJIr204rNR6AxtJh0V40qQ9KcpbkDL435JGcMPjVSYEaNElDZAUkvAd0PKoQJMHug+L0IMKFd2ttY3tc0R2h5DFUNKzSI3U+mFO6At4l2o=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199021)(36756003)(86362001)(4744005)(2906002)(7416002)(5660300002)(6486002)(186003)(6506007)(6512007)(26005)(478600001)(66946007)(66476007)(4326008)(66556008)(316002)(38100700002)(6916009)(2616005)(41300700001)(8936002)(8676002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/aWUF9wLwiFqg9HeYC9OCz0TKajBREDa3bEM9DKL+gIaeNkf3MWrS3kTAcYY?=
 =?us-ascii?Q?mDpG2NLV2qKytgj1Pnop2SFERO5e7897au3Ab0Z3veCEYnKzN2hK3k52bLcb?=
 =?us-ascii?Q?YsXoZMnr42cqh+W6Cut9J0rKDN27cwLQhDViDo4qPzEsYXtjOuVNNAs+HDkC?=
 =?us-ascii?Q?tu40/wf9OJgayjGNR9e40wN2sWOcPvNRIikm1GulBjeHrcnbtl0pBegOtxOW?=
 =?us-ascii?Q?L9LOfnn176G7cVgFQDkXva+qBPThwoJhSGCQZmZhc4l8VBiDMqfd9DdHjqeD?=
 =?us-ascii?Q?uciU5TQBjnoGgFvVaDmpv8c1hiwgHp1eRrDJNW/EKemPp7ZJ8CknaFV7wxzQ?=
 =?us-ascii?Q?JEsSbeB6PotFXeJ12Ft+tIdeca5YDtjoHNpSBUm5/i++yQwSQhY6utkMdjLu?=
 =?us-ascii?Q?036MWeugn6JpkKz2nJoFfGDXjLgRTS83Gqe7TxoH4VCRJzy0H0KlmxoIKET/?=
 =?us-ascii?Q?d5Bc162ROIxnFM5u9e66RHYdZKfwUTcIqsCdgOBzYMnB8sqZQDvWr6KmM6wE?=
 =?us-ascii?Q?7AbkEbbca0TihuoOtckOydTqbBXk5YwmBcrqhQOmc3dhtC3pXH9bnvWI1Pr/?=
 =?us-ascii?Q?v5X7WufLoVaJIPieqW/8W/ddhTcAwuw/dhVYdOV7gRTD0OrgenJLx6jy27yM?=
 =?us-ascii?Q?H3bC/KgTnRtQ60YdoDeX5oIf6dOPAZdmcqH0uUG7Y3oXP2kftNmBuyHdeJ4S?=
 =?us-ascii?Q?NTakAktPjNl65RYij8dkz2zA4MZZRBAuea/BEs71AyKzP8AbQ8eFuqmzSxp1?=
 =?us-ascii?Q?j+MEB24LN3Fl4HPwBjLcBIEsk7dZ9Mqsqj5lquKfeqAdS3HOdnC9bMumZjzM?=
 =?us-ascii?Q?cwexB1Uv9GI5iidDcVB1x9VUexyJzE9Ou6xJOfXVHINjf8mKW94XA/952jXc?=
 =?us-ascii?Q?d58tA4NuqBcUTweMb4w+9zQxLyYcXH5F3AVGBiJNBBw/+l1HokxElzVDu/mI?=
 =?us-ascii?Q?SJQp0waxMVxTI4NtrgMt6dLk+9aaBilbB88OdnjtiRMhnC17CAPA/22mJcas?=
 =?us-ascii?Q?2iwkKmE9YT8mJHsNSOrKgeo1OcaCskxATBW1rxqRGtdDXjifTuMa6OVxwMEf?=
 =?us-ascii?Q?xC3FayX0lxu5vc7bIA3SI2ItvShWiIBhiqMJQUzjw5b3Y+5L6fdEj9IoG287?=
 =?us-ascii?Q?EJc6lfPMK7bXFLVl5PRBaWOKqYhPO5KyceINtTKvtTGOAEGk1Y8pqxRavmhn?=
 =?us-ascii?Q?MPOzK32OVHFfPH2ePSofSKYMtDiU3/PtUT/K+Nl/gZ8FWfuEiJqYHnL8ytUX?=
 =?us-ascii?Q?iByLfD+RgAb/QDJgk30HgWQcpq3k0TFGXD4SzzPPc3DEI5/Z/5ARgWFoESuT?=
 =?us-ascii?Q?/1KCdgTP7HaP/ddt16ZFlyL+p6Ehj3vxXohDfs8hzHFF9XFGtLq5hiSsWrIR?=
 =?us-ascii?Q?pD8plc3bR7UZHrqppiU8EJpWvAkmmaL2Tj4Cn10KinW91By9E6Sv56zeAZNH?=
 =?us-ascii?Q?YLduh6Lk6eSFscYveN0lnbtj//Gdls6g5pjr9kyWaWr7zNLzotSbXpO8pdtw?=
 =?us-ascii?Q?f9ARnRkkltFkYGsHNZp5aNlfcllCZGs4fewGKIi/oZngeZIXlwhviiO41FX1?=
 =?us-ascii?Q?EhGjrke+WeWRFmrrra2z3Ds2QjHCl7ik5sTV6eQl?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82cb3a5f-888b-4e36-8f3f-08db6c03c856
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 11:46:10.6249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8V7v2ebeGwO9Gc5uHwgY/BNi34tMuvgX9i2v4gjZYT0OfxAM0j7BAyv4zrLTrGAC
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5318
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 02, 2023 at 05:15:10AM -0700, Yi Liu wrote:
> This adds the helper to check if any device within the given iommu_group
> has been bound with the iommufd_ctx. This is helpful for the checking on
> device ownership for the devices which have not been bound but cannot be
> bound to any other iommufd_ctx as the iommu_group has been bound.
> 
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/device.c | 30 ++++++++++++++++++++++++++++++
>  include/linux/iommufd.h        |  8 ++++++++
>  2 files changed, 38 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
