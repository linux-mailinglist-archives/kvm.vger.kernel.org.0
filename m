Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0896873B952
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 16:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbjFWOEP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 10:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjFWOEO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 10:04:14 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40532688;
        Fri, 23 Jun 2023 07:04:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSuj1EZqFa77QqfZw2R4d5Os9zSAjgKDhI19CqDVGMXCAUuu8ll9JVLs0xNg3s3YRN7n3/9smw+zWoIGr33jkeWRdAVN91P5F7t11T6o5bCGXh159/Mk64GkN43a4V7Ywj65shPWSm7JAFaj/vn30MZfXUvbMIdhMdL8KaJfYtsJ96y0MUSOT8YqaCIZuVwWXGtnLihknop1q4c+8IZhW4ZYBBUVLOpdiT7OPRJK2VVA2YhYZo2yzk34FtoX6x/jL94ZDXlebKrPiQaAyTMF1q7OxeJQM+gkTFVZWmMYQisZzuRHqdexkQ+gL/tGgoiRyKNm0ghUEG5Ol/kfub6HDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IaFrqgKS5+sWJCgeYLZ+Q/PIkOJpMIIFxkdCl1+jxzU=;
 b=QnwZJYCGGHabIjXOe5I4RXzrA+CKZGNR02uVmtq+ifS8bP+qCIWCZq+TNDs/5U6/ZA08A+qclWEUpE5jIPWyWJyy39/Jg5ZFx2oUFlBDfyCH6tg8E/6gGyuAOfGe+YobX4b3IGt24WtpmHon5HK1FWXfmzOPnTLKCgYrSb4qWDyDZOsW69AYUaWPxZa1MAB4CCfll5cq6/U5p6VYuVElrp4qZ6eHxC1LX9gfk4ChiPTQ27bnW2XbO5SIj6MXFqIv10jEcm14ZT57F1YtoxrIbpd/AbokXxeyyVDHulrQuQqV/763xAE935d7vkkjkxv491EGJ47ADTs4qJlvSQ/J8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IaFrqgKS5+sWJCgeYLZ+Q/PIkOJpMIIFxkdCl1+jxzU=;
 b=ZZCHaljQSlUGQE9ZIza1h90KQ275amM3YP1oZeyHb4EqiuL4Xx2SSPcRu4qBSZKVWLb71dSuYFF6AY16+6bXYE+48Rw2LScdNwk0PhWvuAP7Wli6OxOD/nK6bTqpMUHiHkYL7HH+5c+yWTyaiziuQ/aUXQLcHLoWtDoO6/ZfK74S993tYFbk+/OkSuRYSE2PmyWubYetwv8lzT1XAFl+ZSJT2AAafos1Ei/7No6Vvly7p/hiWEMQsiiIIGjG/OCh8t+viXbmAmd8Kum+zLah/Aul8Gxp4OkbrueGBQpf0P6eF11pwez1iRJKWzMGerVxpGMWvpzeQLlVhaL9Z1b5WA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM6PR12MB4354.namprd12.prod.outlook.com (2603:10b6:5:28f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.21; Fri, 23 Jun
 2023 14:04:10 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 14:04:10 +0000
Date:   Fri, 23 Jun 2023 11:04:09 -0300
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
Subject: Re: [PATCH v12 13/24] vfio-iommufd: Add detach_ioas support for
 physical VFIO devices
Message-ID: <ZJWmWf1R4bnAHGmm@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-14-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602121653.80017-14-yi.l.liu@intel.com>
X-ClientProxiedBy: CH2PR16CA0013.namprd16.prod.outlook.com
 (2603:10b6:610:50::23) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM6PR12MB4354:EE_
X-MS-Office365-Filtering-Correlation-Id: 95dfc60a-4a83-4188-f9e3-08db73f2b7aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t6oCnYHvTShyRcqED8Hzo1d+xcuTwkBg15Y5m8h0/WHoY1fi/6HCFSGA2rgl9qxTJa9aik/nvzMen3lgp54mCgIO7HcIrkuJChu3qMlCInEciPdYzDVX90fj3p3ihQx+YNbDeNmjpBsyaRkAQfGqGEVV6jL84I5PiZBxg3S8A2YqMpQrHXxY9RRIN9GlJOhXX6/eHEQMvWjBXaoelzoaXfR7YIoC+HkDhvfq+wSNlJXJtZaZ3Hmvlkzdgcs1wWXWEH72wRQcOJd02hTLp8wyTq84A8PidAlS7CkGRy+FXg6t+dlhWtBg4egHmTJKhopOoBcIGFO2KOV3Js8yGl5XywEKhPAP9N3Gq1LCVQo1Sty8ZEhVkqKTV0rOHjRtQhDinvxhuinCflARQ7dOmNouDEMDZ3Y8czlZJSOdHjDqGpZoI5w13/VDv2psuJzkH0eLF5V4GIfjvTyPf3GEbWk+AL5mqFJ47xgJ/NIeCn/4oC37Q+wCg+S6o9r9EQOCBpSiw8jTqOib1C7dJjl8nzd121XiyxfUy2inHKl5XCCyqiheCIF2IpVlpVgjr4Dn2Dr6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(451199021)(83380400001)(41300700001)(8676002)(8936002)(316002)(2616005)(186003)(38100700002)(6512007)(26005)(6506007)(6486002)(478600001)(36756003)(86362001)(4326008)(66946007)(6916009)(66556008)(66476007)(7416002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TRM6XLawlg2qhhxMxjw/HEaxXBiq18YabQHIQs7mYw8IQcQ25GL4PJcT7Bp7?=
 =?us-ascii?Q?yljI/yy+ae9lMTarinSTJnfsQuZH0fXFICfkjv4zDMkKeUjj0S4KBULiGO03?=
 =?us-ascii?Q?JRQgELm4gq0KmJmeC8zGExdtrdj5AAeLQaw+lkdg4/UKdbaYmO7y+ajSRG4Z?=
 =?us-ascii?Q?pzN7rPEKU2/HIsewDTEmxt9JVtLixOHUqWN8b2jNFL7rnZQwC2F8pgtZmwyI?=
 =?us-ascii?Q?nwDjxzoheHLendO3wsSD2wrXxMcTWcmHEr4VhvUHvlBXtbzJpxpjvH7DjDgx?=
 =?us-ascii?Q?ctMljx6phRH6eH4fzfRyEWRM6NTiRdkgGOufdflK4sWWzggaNmc1W1z6Dobo?=
 =?us-ascii?Q?en+007KjM+tr2BIkahOk9VFMEJdih0rXnqq75Wg/ERz7+YxrvQlhea3SzAWZ?=
 =?us-ascii?Q?xxUvwnMufZesbCz2cDkAPkI1vqA6/DQuM80PL/dQmNMtw6VNW4zNQ4Xt/ZJc?=
 =?us-ascii?Q?qodCgI21132gFZJoGozJ3KHBkY/jQ2NMg6ehtztL8GZC4AdVkSjDHdXBfGx/?=
 =?us-ascii?Q?xboIkV82kQ1GEot0BUUL7f2sO54zDG3rCMFt0USmBCC9Ik8AZp0fNb9V0HcP?=
 =?us-ascii?Q?pEEW3ElaK2/xelie3rFpSi2atoh7r7xl+TesjlWWBjrlO9ewHTFsectXR8zG?=
 =?us-ascii?Q?aDrHdMyt2w4TlcSuM6eOthlmCyHSTLN47lkYEhnP9SRoWOGl6pibXmss7N4f?=
 =?us-ascii?Q?xxACcQGC2Eo5IVtFTeo+oja+HcA2LF536mdiQx5hXcMhCNEBkW3MGoMxaVrM?=
 =?us-ascii?Q?Knj7EZiYbYu05JCvoSl/PHiwoWArapL3ndUBJ1BmpXxAMEaExJMgJbQmVZFE?=
 =?us-ascii?Q?L8PgEDlP+qE2h7gT6V3eLa70OV/zaDznIkYyw7gNmqw13c+j/uTlA4hno1kR?=
 =?us-ascii?Q?QlIe9oAikZJgVZVxcsSTJMU52zF/lDVeLQtm4CSe0dynyWkOrAOXPS2W7USy?=
 =?us-ascii?Q?siPsYW6iNhuVZUGxhZpkFFUjydkZbviLCwWfHCWsPXAIUqRA6nQC5f0lh2Vm?=
 =?us-ascii?Q?gYgO3dawXdJG3+8hO4BGNhNLL+XQhkrz84lJx3+mD7OVij9GV+vvwq7QTIUv?=
 =?us-ascii?Q?tY3dy370DVMFmrcPE69FTJRGNFC2zzVS/i+tjV+D1wY6M3e0OnEm22UDTKvV?=
 =?us-ascii?Q?MtVD2qnOPEokNp7Ih/QerAvs36jKfANtdaHwlk53zzUZVz1IT4XMscaIn20e?=
 =?us-ascii?Q?kB32JaBx4932LAXJDGV9AsN3svatwIYcqwlr9dsdH7HIeB2AJqkLGB6m7o4a?=
 =?us-ascii?Q?Q8oL5V0/+mG0plH7AdJY2P/ffz2Yz3WHF4YTuXZ99dCYAuER4g+NIGaa9y+2?=
 =?us-ascii?Q?jY526bFLummLEtLVr5HREv9otSqIMx+8bfsejgA3CbZLeKgo1CjbsUODFwH1?=
 =?us-ascii?Q?TnuQhZ5ZZRpzcbvfrC1JEXffxjDagRo9FOIMBRehIghxrDnXNGt0t2VlB610?=
 =?us-ascii?Q?Rw+yRzxBiwRKnanQXyMF5cfrSshKNtLdCIoyqEPyxgrO375h+odhRQ1Vp9hv?=
 =?us-ascii?Q?t6zhE9ZIiIGuamW9ye6Qjr2D5j4o133ZkU+wMkG8zHpA7g6UBRwLxgqcoPVk?=
 =?us-ascii?Q?LWHVjg1yfMnemlo7OeL/J53SgrWGJoRmAcAYO2h2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95dfc60a-4a83-4188-f9e3-08db73f2b7aa
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 14:04:10.5438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WE7L6IPSWb/myS4qSuFugT2AD82lgrmLnXsv8wkAZv5/P+5S33AmELywfoa6kxY9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4354
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

On Fri, Jun 02, 2023 at 05:16:42AM -0700, Yi Liu wrote:
> This prepares for adding DETACH ioctl for physical VFIO devices.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Tested-by: Terrence Xu <terrence.xu@intel.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
> Tested-by: Yanting Jiang <yanting.jiang@intel.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  Documentation/driver-api/vfio.rst             |  8 +++++---
>  drivers/vfio/fsl-mc/vfio_fsl_mc.c             |  1 +
>  drivers/vfio/iommufd.c                        | 20 +++++++++++++++++++
>  .../vfio/pci/hisilicon/hisi_acc_vfio_pci.c    |  2 ++
>  drivers/vfio/pci/mlx5/main.c                  |  1 +
>  drivers/vfio/pci/vfio_pci.c                   |  1 +
>  drivers/vfio/platform/vfio_amba.c             |  1 +
>  drivers/vfio/platform/vfio_platform.c         |  1 +
>  drivers/vfio/vfio_main.c                      |  3 ++-
>  include/linux/vfio.h                          |  8 +++++++-
>  10 files changed, 41 insertions(+), 5 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
