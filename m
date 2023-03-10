Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2C96B4EF4
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 18:39:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbjCJRjE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 12:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjCJRjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 12:39:01 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::60b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69669FD29A;
        Fri, 10 Mar 2023 09:38:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QCUTUsJHElEaJZXaS5evioRVdNTVrwZ+W5iuDLJnCy/l7ZHLmf4ocKIAFZnPM6a3ZgXjdFrOauFhVmxCny+7p2lVP8Xh/bMRQ4VumhHFPdhAjCvlnxloSJ/rXvDfNvK7AX9NotjuCqDwAFWybk5qJQv7bFfjCqAezqVDCXK613LHfdHvyZApuXzq7302QKX3t5fA+XJiAYe2coWWPsiJf9zILEoFQQRY7nk01Y9psziMcrxhkxB7fgS5pwnlgdTmcAAZeeYgDTFka+op6Wxsou6dZR5AKy4uBEg7SaEiNlyB1R67K2nBtqOFVcelfRaKEhMTIKyFKIsxCbXfLEfm/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=67RGpMorlmt4f6QGWNeyR02h2xa8OYYTSP/Fd79a86U=;
 b=l2OPfWyYgsPcRcNIBKccOcQ/bpj6rSAiNAa/CrvgQ9fYpNtPbLUJ/bsHHahIhWI+0enQmmC1g8etTY+S8Zjtjyd1P1Dm7RPdIT/9ZQsnIUUJxJA/ZM3YUlZ+AHAnd79EN4zouulc8PGXMZ/cz86HrcfeYcnwdgpsM4kpPWDUFMuNmVz4WanQp+r2gXq59SSQeGbVS05ET0GAR5uOGQzTGcEkhj/iyTygFLA9ZReLAeuwyWrFeoITySB4ykSdvFcjo3SnFl3CzmoCwMeRtP10v7DOLQdaWtNrKGRo+uPNPxo3LFOMidGtbTftj7HNwZTww3QOhVOp/VEo06vW3mfu/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=67RGpMorlmt4f6QGWNeyR02h2xa8OYYTSP/Fd79a86U=;
 b=LutjfstVciYMFyUSvynnNT6X+YYqJWOkbJci6pKNT48yFSQPEmMz2ZqbNAVi6tBS91Tgdag1PM4BmMqO2CR/Pid7ezCj4Z0vaxcd7hWmw65d3PRkYIAa9bx5Pdg35Bsu2UL87IPyFzXVQpGgtNiRi52pIXkjhwnsH/80n4FoakxF3OC1sp6PVuwVU9exjaptn+W/NvATKyPdUvGNiR2QKmvFtZGqYY8bQ27ikBEqNeMzDtdxk1jlI83Hy4wgVA8Z/fPBvuFVyQzR2DVa7c6sNuMLpeHUaEJamtFYCmJ/5a2VTPl9KxAv04QSZRGYjrLrdzxadM1xZnNNtmOyqb3p1Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW3PR12MB4489.namprd12.prod.outlook.com (2603:10b6:303:5e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Fri, 10 Mar
 2023 17:37:52 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.017; Fri, 10 Mar 2023
 17:37:52 +0000
Date:   Fri, 10 Mar 2023 13:37:49 -0400
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
Subject: Re: [PATCH v1 3/5] vfio-iommufd: Make vfio_iommufd_emulated_bind()
 return iommufd_access ID
Message-ID: <ZAtq7aUu77ZrniMk@nvidia.com>
References: <20230308131340.459224-1-yi.l.liu@intel.com>
 <20230308131340.459224-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308131340.459224-4-yi.l.liu@intel.com>
X-ClientProxiedBy: SJ0PR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:a03:334::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW3PR12MB4489:EE_
X-MS-Office365-Filtering-Correlation-Id: d6e2e12d-2ff3-4786-f3c4-08db218e2cec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TPllTKukNka9QfMGu5mJb5+YkARbBhnFasqFE0V0rka/trz4l5RGlaX+LYBOTkE00PI+VcClP2WhZe6CSseIX4bSvyxDXOEE8Su+wH1u37Ag430O7B+OufNzXSlkRm7LBZnU68gd4NvtXWwfrVDtzTidxR8iIePjc3UN1YAanboews5fXSjLlDo5LvOgpnu6UMNL8MpRXM9/4Urae83KoyVvvBJy6b4oW3nfT11QqURFr+pZ91Mfq19auKmzC8kZuZdTN7ItS3337fcB1625dCpJQ4z/dNfFsrZ6mWpm9f5BTH/b/vaUr5TT96KnHrN04M6eLhrBLGmTgCPqNMvl2BZlVyU5rCUaWVqokbyi3pxSllqYuo5DqNZN/Q2mUXBIpHSWrotC3nox3wLxAhx5Pt+Q1MXC8Z6Qb7nwA+QdcudC2/jFbJxJvBQGmevvuPKqvMrOxuKp6QyIc9fYdns4dtGyDD3xgQwFqilHLLwjxI/QFDZNOU3oDLyPhuDKcSQdm3+HbVUiS4lUpMOCBaeXITzxM5yr+HrQRebyJ28lourizorIGijsAIbYuBrMiBodFCPA83CWhp552NbRm3EhTvs5wRkn9D4O/426leP5hSdsX6i1AnHAMSidTYCV7EabsZk26D8cc41KsX4o7pKuOw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(36756003)(186003)(6486002)(41300700001)(2616005)(6666004)(83380400001)(26005)(4326008)(6512007)(66946007)(66556008)(66476007)(8676002)(2906002)(6916009)(5660300002)(8936002)(7416002)(4744005)(86362001)(38100700002)(316002)(478600001)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rnCr1xX/qiMc+fWIn7MIF5m/58tUIbsRnDQi55Q4d3hM8XQOmvqAi+VoYgWV?=
 =?us-ascii?Q?yZ2kbeJLs1m8MBLhqVDc+Vsr5G+EED5H2tAXMRghVBY9FUbhjCbQ82nRlgDl?=
 =?us-ascii?Q?oYR5zTHu/aaiI7W4joo0s/RdVHKnarmWh4LONwDnknFBqU1xY9ae0T1WWgNS?=
 =?us-ascii?Q?X++I+77hRT424k/w2CCy1jkj+T7FRZzjNr3ALvOGbbbxszKvkUd/pNBs3E9U?=
 =?us-ascii?Q?bKrRND1W630QSgm9qnRF0Mg2mF88qnPGh8VBMQ35quSqrVlLQzLOAlxxPJL9?=
 =?us-ascii?Q?T0Db/ffbs+lvN9w2KfyPSm13K0aAUboV6QYs46w+gI+4GjwUiNUYsV5gffDs?=
 =?us-ascii?Q?He3h151bpV72ui/g0qoZruRO/FjjtYC41ln/laj2rLGjjcqYUHaNLfBwriop?=
 =?us-ascii?Q?ucQO6OGLtf4aqWfm9MjpNqGilC28r5N36qiEpE5k5ULbGl5dnq9hfnU8sTWy?=
 =?us-ascii?Q?eBnXeY/tbu55V7drwdIPmceUg/BW0hqe+pfO/zh9Xb9BPKkj1kI3+sGft8HU?=
 =?us-ascii?Q?VYAyXWBrz86wZ6KoE/8uIj0cie7S1uNXTPk8oakVbqsxKFqeAqgJt/Xeq4IE?=
 =?us-ascii?Q?8fyLMZd+aoIm9o/HEFmtWFZzFkL6+Zh23veiKFcyMrx0xxv4Ph4WnFgpQ6GV?=
 =?us-ascii?Q?lTDKB3SB/uVTdGFFu+urjMlWVtEKEtXsaKyQzB3PXf68ndedEcm4vlniK2E3?=
 =?us-ascii?Q?qQa6oNeFDcvP6A4BR9K9ZuCgoqyc2cpeRhPtVOtV61fkaI53YOE1PC0r1O74?=
 =?us-ascii?Q?V6EUd9/0P9GSpjFIJreL9MMTKXA/4BoIQ2131c9D6pvYpBIXiJgqFhxlRKfi?=
 =?us-ascii?Q?U6imfqNmjjz+RxEuxh7TlKSlX91/1Wc5UYCO4HtaZ+U2sedUc85H36YKkLcs?=
 =?us-ascii?Q?x1zW1nvkmnBtIDYC63wg4pqeqO14M50q9eNPBceWU6JOG9LVGmYwOlb8hksN?=
 =?us-ascii?Q?UhzFN+OqfMog7FyPWi2mmq4dcnRo/vfQfATexIWsGwUiVJPNAfFJs+pcXAQP?=
 =?us-ascii?Q?PR1Xp6mo2h0XoblnLxx8f78Dp/St2O2MiOtNpMj7tA1w7cuY+0Ypp2JqPa2v?=
 =?us-ascii?Q?Ej4zRv4EKToP849qv28jpnDHhQCpcGJYqrttHFLfjjc/Mf6cAm5rfl4oB+XO?=
 =?us-ascii?Q?bFAUiqnbapBWyGUbEhCmGtHMqv2yp7EbRZKUDv9Xl5+JhBZ8uYqBYCS8nKcf?=
 =?us-ascii?Q?K95ejRL6I+aLUE5uL9yO0F4ae046i9vwwSHrb/nFJ9p8B13CmP5iKydEKoyR?=
 =?us-ascii?Q?bjZV+H1xEbnJVsvkBu3fLsiRDth5f36OxSJIb1HOaenU02enXufWDi88kCrU?=
 =?us-ascii?Q?nTTe2weGWzojtsJHgvKYD6jHMko296JCd1iaPGVOMUBsAm7m0oenp8b7mVXo?=
 =?us-ascii?Q?26Dkrulqe8fNyT01izgoWKos7oEBfmVY757rcrqDmrTk3BiHvnGlzH9QKzJb?=
 =?us-ascii?Q?De9Jumm2mKrp6ztgBgxdhsWVVtStuteMgIkp+jYKBJ4UYC+ECeccu9hMeKib?=
 =?us-ascii?Q?CFpmmqABgoKELciqqRpfopk9Obv4pUwK8dPTYpoZFtPIjpEJEyM7isI4LvgA?=
 =?us-ascii?Q?9xHYIFB7MN65iuco9S1GlQakM7wbo4GZSyn3wa5T?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d6e2e12d-2ff3-4786-f3c4-08db218e2cec
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2023 17:37:52.7887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N1Xj7Fw/JLkOqNqd4Us27ZVW7cSiVQK3uUSENMEB1mqBMgAuiIhzWzFEISFSZz7k
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 08, 2023 at 05:13:38AM -0800, Yi Liu wrote:
> vfio device cdev needs to return iommufd_access ID to userspace if
> bind_iommufd succeeds.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommufd/device.c   | 4 +++-
>  drivers/iommu/iommufd/selftest.c | 3 ++-
>  drivers/vfio/iommufd.c           | 2 +-
>  include/linux/iommufd.h          | 2 +-
>  4 files changed, 7 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
