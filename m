Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10766CF39A
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 21:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjC2Ttc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 15:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjC2Tt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 15:49:28 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20620.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::620])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C7F899;
        Wed, 29 Mar 2023 12:48:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jh+IpcJGqKU37Fnqc0hPEG570RfzN0sVxfhoF3Q+MohQiTv7LKO/ahUoOcAS5QAHSnvJLJ/E19mo5cuCRj3NZyXgWEy6+5QdFuBlI0ZMELBclc8ryib1h99GeERfG/3OHlwltD+ENeyQoQXaxEkwPiUvL4eKmeZf5QiNTpXkROnxTYpJPdKyZjf1Lty3db1ewi155WaF1yKzF5mQ/3oTLF9aB5tzEriZuILwzYnl7Apv64YyVT8pR02K5GXObz3Lnu/aBsfsrORCaW/2tO0dI79loCIdjtLk7uI++mMiHwJ3yIgO1G/oyCCWXURztugQrN/S6L/NHarWWSQ9HBRvbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L/kCZ5yay1aMzcm+rEAw/fnnpkEhvQxypgSwexGJacA=;
 b=EK4gl6+mcfrF5WfGsQKzlBSe4JDyVp/SW4TX8FadmeX1iM5FpfkJVKOraE1SpdxLc7lRiO8EDNQKnFySD5nAx3EmBxotXJatzaks1Ybr5DzCJLtPTY5TX+05VOA3QrNiDUcQev8Zv6UcrX2MdLVdS7l/ChdDuLok2ia4VX5EDBfCaBpnuP8qn3mS4QNT/P8JBSaZCJe8r4dXUbORAjEJ596fJSDT7QEtE6yECd/LNVMUPGfYfZahvg9An4gL/+O7+gsKN6883a16lcfiWL5zh7TtuQbjXUwWmcdP+xkaGSZpUzHgnrtf5wV0iy4402V1SKYY9k3Ty7e9FAMCuMLbXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L/kCZ5yay1aMzcm+rEAw/fnnpkEhvQxypgSwexGJacA=;
 b=NK/SBPN8wCS2BkmLulOoryLeiiLZvSN9YiOsFFXrR+gsSF0REHOBlZ8ZKF8s2Z2/1ir5HExacBBw2BkUL5xIR9HTsFE6xklb/CqaHrpY0xnPR461Dfi5kbi48hQHteJkASc8t81YSgxqwVqnSDW/U1y+EuMdt/hq2xHq7BgvT6lVsmhZbrZJQAguo57+tL5CDYfE9M7XV7WS8nd3TaVMhCnlRAlCkSokBG4rOiEfEGCPljlIXPradN6j1ryGk9pfoihZhNhVl6tW2X1CrAmwCXF7J11PL9VHthDn4bygw6iHQBfNlYGVfF5zc4zHJoYNcBQqSp5VeWsULYF3cFKHJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN2PR12MB4343.namprd12.prod.outlook.com (2603:10b6:208:26f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 19:47:40 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Wed, 29 Mar 2023
 19:47:40 +0000
Date:   Wed, 29 Mar 2023 16:47:39 -0300
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
        yanting.jiang@intel.com
Subject: Re: [PATCH v3 0/6] vfio: Make emulated devices prepared for vfio
 device cdev
Message-ID: <ZCSV2+LbgeWD2bPa@nvidia.com>
References: <20230327093351.44505-1-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093351.44505-1-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0092.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::7) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN2PR12MB4343:EE_
X-MS-Office365-Filtering-Correlation-Id: 8f3a22b5-8f31-44b6-09fa-08db308e74c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dTQYjpvwAnSJcCD0ZVAG4YUo6/r5UrRgduXxWTovA/zDOCzh5m6nt3ujgWGkn5arR8H+OALsCExnUBlUwr/WrZiO+769cPyHcrD8fghToow80t5OjT5wQ1WFsH/fieSEueoVxhgNS+/DUrOoo+KxxKF3ksnu/XiJXrpFXe6fn0/y/LQ7laSxl9Kc742MCjWJCv8Ns91iSazP3n9whNX3fF+S0Zj/F50FB8lEtNQNzdtVKpisbGd7uE5O5DL6Xyq5841Px9C4PMWatHvB9CkIf57aaMJkgLa9TPDEwszvUMX3Gup2EuQPy4exGwLug8FYzHTbTQgplStIEBx5rucQPPSlxkGxjB01W78faYCIRmVoh90m53/g5eFnICoLpB8nRDyAJZdxwREWdcpHglPtNb4i2kzco6iwzR41EmAdVYK2EfOOn0+rURYT1XMESxuRo8C7stXHmeY1HAOwALpCrj17a6/ouPIxNBZDJPAXZT0HRovgHNy5a1/OsDmRGzwZCxacdnaKy4Y2J0irBAsGUX0F4H6x/qSS7AAD4Hx1t6TRC6RAAFpnPwzIzqky0OEGUs3eL4sAoD7nAy279AuCJseBcK00vIeBB1UWB3h9+nc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(451199021)(6506007)(26005)(6486002)(38100700002)(2616005)(186003)(2906002)(5660300002)(8936002)(7416002)(66556008)(6512007)(36756003)(478600001)(316002)(41300700001)(4326008)(6916009)(86362001)(8676002)(66946007)(66476007)(83380400001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I20oniJIKvDWoBFtpzLOdELGiuHt8wOSzXDr4+AdmB0d/A47r9UF08sdcIoE?=
 =?us-ascii?Q?VahV00brzGyK4MQLKm1f/uN0+fODaaIyl0I0uhkPvE7ynGlsMpBnoJanQTmK?=
 =?us-ascii?Q?z6yjF9zOALA30B/nWHX2upHX/uN/nq6P8Gp3vU83/hKWlWtUTs7VRRM1xfw8?=
 =?us-ascii?Q?3G8bLHGuOl7bEHqPOBk6lXP7I2oCHoq4y9nyfxMF1B82QWMEJ4G4/lVa4VEu?=
 =?us-ascii?Q?XW6FbxWgEtKsz5tTstGxVKtJgXIl2sOa5jqgYvmog07H8KxxcYi47cupxD+6?=
 =?us-ascii?Q?/Asl86itti/scyqauYw6wGiqeMKBtf0uoDGRTwJFMeFl6+KXU5XM1FCC2uq4?=
 =?us-ascii?Q?96iOVWt18XO00ai43Wo72XYZVs4aj4IsiJvInjYPqqhgU3ILO1vZGlIpdSie?=
 =?us-ascii?Q?ogEnpleiUre7q5xA0AmIf4vkHJlrFMvi1JKXerHy3OFJ26uG66tz1z2L3Ez2?=
 =?us-ascii?Q?gdqJISVblKE6dMt7aYIiiIKdlBnEzzJqE+++b5osRY5FSr4Xerx+WbKIDfy5?=
 =?us-ascii?Q?01dogWcNlkqnO8PCkZwVscA8nxa7dQhJ80v3Ka+7zWvSqOiy82kEEJOoovn/?=
 =?us-ascii?Q?w8QhYmOUmDGo56iKmTR8DbDe7p3C1Mz8VPmHJEZLCwmq5VLZ21Brrwiu06wy?=
 =?us-ascii?Q?jJX7udvSZBXfPmA729XxfI8XuJyFEr3v29D0I02liPiLORKmTPyho54aXzur?=
 =?us-ascii?Q?N7QtXXK9N58Ta2AcRdYd5vbjsv9mfUVOE94UAvzABfWg7w0l/8cSDTn4OA5K?=
 =?us-ascii?Q?7DkR5uuJTi7XmJO03qBeBPFxgrWgfKYrTOXixK4vEmEMnqn3stCDLG1SoGyM?=
 =?us-ascii?Q?Jvj09PGotFg+bOFhVJJ79gPUfTevr+LnIhKdFkuzTMLOiJgQrxZWM7H63kCp?=
 =?us-ascii?Q?d0rrobqAIZ2hELmvvFMO5i8Tj0yrEVI+8zVmeeXXfk1bZmouhsKf2xpicpDY?=
 =?us-ascii?Q?4cUQZl71qe64xOd2pj1nd/3BJXOa9JLGYSlqbctH9q5kCvEtrFAfAvyiGWsW?=
 =?us-ascii?Q?ZToDTunz5zfAvWxal8JL9XFILaLZeoV7V01LiXepWyAdnAbmrA7dEEFbZ4aQ?=
 =?us-ascii?Q?DBBAHmhKGMIeSx9doDY2H1Mi03IcAMwte8EkRaZWisY9pA/tcESHMJJJjSdT?=
 =?us-ascii?Q?LcWio2Xs+dJRrGp35cOzFiosqcy+BHujPGKBFcZq8T+1EAfq6E1o/YwcaUaN?=
 =?us-ascii?Q?ayzqj3xlYFjmw+BOQULv4Oklgh+/DBtE/xcKr81FJC5jykEtXwAj4j7QY3ZD?=
 =?us-ascii?Q?aE9eiw673b3EyEJu+7UqhZ+OCktaJvzKKQvI6xHARZP8ULlnbeJxl9r4fc13?=
 =?us-ascii?Q?1nyV3obf5dFYr+c6JW166l54Cmxz45Al519FEkiIVYbc9Khtva1xHF0pSPiR?=
 =?us-ascii?Q?reX86mjeMVc6YxPJpxu0bWTisROd65GqP4uBzYb1ddrFbwzBmE3tA2SodqlZ?=
 =?us-ascii?Q?kHvWhBWs+FmCaRVP3nZycGO+gbT6wMoh5WlVUH+2BYMtaOO4NlR6uUeJdkch?=
 =?us-ascii?Q?ovTroygHz/r3o5fFvP50lltQx5x3xeA+VXIMU6cTszC2kjKphqCYYNCX4PUx?=
 =?us-ascii?Q?zqSMgvMZDzARXuVGIz0PevjSaHLoZlez48yCpVO0?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f3a22b5-8f31-44b6-09fa-08db308e74c7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Mar 2023 19:47:40.8091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fmMspN1Sz29XW5X9QLqUBQK7/0k8DomHXsE8xg6WjLlH9IXOXClA1F4JeCgmSJPI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4343
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:33:45AM -0700, Yi Liu wrote:
> Nicolin Chen (1):
>   iommufd: Create access in vfio_iommufd_emulated_bind()
> 
> Yi Liu (5):
>   iommu/iommufd: Pass iommufd_ctx pointer in iommufd_get_ioas()
>   vfio-iommufd: No need to record iommufd_ctx in vfio_device
>   vfio-iommufd: Make vfio_iommufd_emulated_bind() return iommufd_access
>     ID
>   vfio/mdev: Uses the vfio emulated iommufd ops set in the mdev sample
>     drivers
>   vfio: Check the presence for iommufd callbacks in
>     __vfio_register_dev()
> 
>  drivers/iommu/iommufd/device.c          | 55 +++++++++++++++----------
>  drivers/iommu/iommufd/ioas.c            | 14 +++----
>  drivers/iommu/iommufd/iommufd_private.h |  4 +-
>  drivers/iommu/iommufd/selftest.c        | 14 ++++---
>  drivers/iommu/iommufd/vfio_compat.c     |  2 +-
>  drivers/vfio/iommufd.c                  | 37 ++++++++---------
>  drivers/vfio/vfio_main.c                |  5 ++-
>  include/linux/iommufd.h                 |  5 ++-
>  include/linux/vfio.h                    |  1 -
>  samples/vfio-mdev/mbochs.c              |  3 ++
>  samples/vfio-mdev/mdpy.c                |  3 ++
>  samples/vfio-mdev/mtty.c                |  3 ++
>  12 files changed, 85 insertions(+), 61 deletions(-)

It looks like most of this is iommufd so I will take it - Ok Alex?

The following cdev patch needs it so I'll stick it on its own branch
and we can sort it out after the reset series is done

Thanls,
Jason
