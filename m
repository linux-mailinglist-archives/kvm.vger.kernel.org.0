Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48CAF7CB017
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 18:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233987AbjJPQor (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 12:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344076AbjJPQod (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 12:44:33 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2076.outbound.protection.outlook.com [40.107.223.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B4E3D0BA
        for <kvm@vger.kernel.org>; Mon, 16 Oct 2023 09:35:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iyf6KLyA2F8xnR9zVrRSSbKg5vFK2OPp1OZ3K8a5l3zcnALBrIi7+cfsXrgQ2mw4bz2c8Xl7ZrL68tkcMgD3x/PN9G/OsI0xLWPuNCQBJ0bjOpOBMZ4Tiyulrx5QR7qpyCVx/O/1zvM8rw3LzPQNUPDPohhlWQPFJ/WznG+EPS4UKdyQKHoOzxk2xAZLLMPMSso66Su9QGP8sa+wiTYKwapqTOYsiRvpT76j9+sPCrhxNT+6labcKJTT3cf/bvnRLqUjmzaFICFeAo6MkwSANg2DuziNPgnRmWv0DIgZ9frkYhwYENomtUPvLjdXlr0SofIM9wbJGp9PUb5uhWerCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LqxwYfMu8P7a17C78LIpZSRDgB0Yt6V3y29sRjQeb1o=;
 b=K6ylcV8AGIeetzlCGMKo/HqnD0e8jgFrmd2uTH0ZieDiwtntiCkj2fG3UYtDyuuzqkq3HZhcUli7eGgUhuks5ZKP7HOP5vIM3UusN1LBvJXMdhXjWxtsJ9rXxEcWVRhSi2IgYeVWaZD9g6iVTMx3/isEpsCOxaW5R0vz+NycksPnaw+m6YX82Kd+C8rcWNTh8OfdHnZ9p+daTT/lauaSFp8NkXW7+RKBWnpTjhTgx32pbQBnNLYYUDY/+Yo4zqjyvUVkx0Ol7YuxQYmaDwPTdR8FsUNGQJXfC/xvwk6UR4I+oqedaotQF76xRfDldy/9JJDU0CjMPP8bAy9UQmzvMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LqxwYfMu8P7a17C78LIpZSRDgB0Yt6V3y29sRjQeb1o=;
 b=su31gEB5rbSgjvaGhhLyzPhenCNjH2t7UYe7/5FzzT/JY7D+bfNHe/mjpmkzCNBT7RSfa8fYvWQfhi+8o5+73U5ONnpHff27jhFRMlAQ7zzuBWKYbkuIPNxlZAp6gJ0JpPkccNPYR+MtcrOBC+6dJY0i46EnCJFmj7Worjl7JJKMZsGD5ORxFXDVXzR2ebvejRPtq42TCAsxbUFjCo3erdUXtzDEGNHI/MxJ8LbpV1TuHhcxb8caAVpSu9L4UI7iHw2dlxeBjGm0Jh+14ERZq4KefU0mO4XuvVBB0TkHWQ/MAZOBVSC3YbV8FA41a9bw0OVUnxSZNjj0cUhuXLkCkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB9447.namprd12.prod.outlook.com (2603:10b6:8:1b4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Mon, 16 Oct
 2023 16:34:58 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6863.046; Mon, 16 Oct 2023
 16:34:58 +0000
Date:   Mon, 16 Oct 2023 13:34:57 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v3 02/19] vfio: Move iova_bitmap into iommu core
Message-ID: <20231016163457.GV3952@nvidia.com>
References: <20231013154821.GX3952@nvidia.com>
 <8a70e930-b0ef-4495-9c02-8235bf025f05@oracle.com>
 <11453aad-5263-4cd2-ac03-97d85b06b68d@oracle.com>
 <20231013171628.GI3952@nvidia.com>
 <77579409-c318-4bba-8503-637f4653c220@oracle.com>
 <20231013144116.32c2c101.alex.williamson@redhat.com>
 <57e8b3ed-4831-40ff-a938-ee266da629c2@oracle.com>
 <20231013155134.6180386e.alex.williamson@redhat.com>
 <20231014000220.GK3952@nvidia.com>
 <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1d5b592e-bcb2-4553-b6d8-5043b52a37fa@oracle.com>
X-ClientProxiedBy: MN2PR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:208:c0::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB9447:EE_
X-MS-Office365-Filtering-Correlation-Id: a106f740-2872-4eee-37bd-08dbce65d63f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Bt+gB0C577yaCAHtVm/bAgy6GmbcTW3g8TAE4XY5Cp7h+URLGzcQPd7VS9K/z5iNaQ4PsEPFvuK4beDwsRNaw7ylEiQQedpOuQLyO9xmrNZgbpX8LMgMHkav1tdZoXX9rD2GDTnr2XRcHBH/JxtV9F5Sd49yEYz5i6d0DOKWlQQhzN6L29Wj0thfbTaKhyUPbKj1WrBo1e+4y7l5U1KymH6dfyCvdxCChcFqz6jfJ1rl+9/zF6ijwSSLzi40h6YgwHHvHH4WmeO7DPN2DQ2VWGYsJ3dCHerDkJK+8EgYOPAEOrAPj2ddbAk7U1fZoRBpcVw5YDPPXLmXez9AAC4sNo6zpzhT8plsm1abOja73gzCQoTwag6/AIB+YId5KXJccDbN5OG22EWINqSFK89yCgVdFC1YBPeazAvBiDaFjtamKWhXyJiv51YRrgYYu8fASA8mQraHUoloslOYDrjL6YwtzZmehdPJFP2GOk7h/X9om7/2Xe9KjtJJMNNCfvxGbVFqgshDnwplTKE0/1FHYdz49bDosMHlAWvLsA3ZjdwKTWupl+BbVrPjFwEys9qe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(39860400002)(366004)(346002)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(1076003)(2616005)(6512007)(7416002)(66946007)(66556008)(66476007)(8676002)(4326008)(54906003)(8936002)(316002)(6916009)(41300700001)(6506007)(5660300002)(478600001)(2906002)(6486002)(38100700002)(33656002)(86362001)(36756003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?a3oH3ItxJpgUyFm1WKYJm4I7jWci5NrfdYJUfmkPFHV5etnubR9UEy2EcGDk?=
 =?us-ascii?Q?E7PauXXEy6WSrv0E1SnltRK7qH57ehS9UVkLGRB+j0bIRP8W25C1FwCM8jIF?=
 =?us-ascii?Q?pKK88ffq/Pj0UH3bxu3JMacsjEO11TE6YGxsm91VSfTohAL5SujS/VmlgW8d?=
 =?us-ascii?Q?fZkWPMhDYeUkb151WWcwBUJHdlbg/I/1yfMb0nCvof12uWOk8SOqKMW7Y+y1?=
 =?us-ascii?Q?4+fpqifuabXr6VHd1nwDbGEY+vR6IOH1znzymaG7ran3g266ui0w0dACtuNw?=
 =?us-ascii?Q?iCzSnV3pIMy7Nii1cYW7BECeMKvbYnta1pZqn0s5usWV7qPT1KYPR/aAMgB+?=
 =?us-ascii?Q?WYy/JawWR01wHAWADWxwXaJsy7yUdNZ6oTdU8cGmVmH9fIr16SIEIus7SyMs?=
 =?us-ascii?Q?FhBW1mkHRkrm/JTetB+bfXOschApLV6/LHY30DRT62Dm/bXYyqacX4ixVur3?=
 =?us-ascii?Q?TeUEcq+NCG1CqcFUf5RMjSjx6Z0To2FNV9MIXFvZ0oIsmBRPbu4GUi7F5S3b?=
 =?us-ascii?Q?tm1HGF45MYRtNtzERvZdTtmjx85DvAb+xt94BXZPGPFWcrv1KhYlLHi5DfrA?=
 =?us-ascii?Q?S6cWugpOdNr1Kfe5mgRfa+rcUUL2gJWHGIJXjrQbNZL9PDU5CFC3cwwN7AJI?=
 =?us-ascii?Q?f4zd7UGxgc0opOrPMZSNQsVZ65W9+1cq6I3nm0iPgaCBXf94fVr8gwu0Mh2F?=
 =?us-ascii?Q?eoSbMiV/2rfznNYEV7F7O7THTL1V3yx2wICQLT9fcJKtBnlIEG4ZuxoE/r9O?=
 =?us-ascii?Q?LR0cADFDch4BDcfs8HpaUvjoTo+999dbYxrVI9QCsM+wHv0PuqDid6/YX1M5?=
 =?us-ascii?Q?DHXROiT4Si5YC42mgb1tx+/V5wjvDVYMSjVIGeN/62OV8jh2cQ+MdI+/7J/z?=
 =?us-ascii?Q?KReL0fXU5ddJbgi7rb7DvfDUVFjM6ZNFVUo2tnZTqbVJPcayJSy59HBw8Vtp?=
 =?us-ascii?Q?O3MZwqCZKU6qUdBBDH1wF2Ak0qJulPeBCC91A8hqn0HX21nQJglR9mEIKWK8?=
 =?us-ascii?Q?FaOnb0aGJ/lDM/+8amkXQZ36t8MoVDuNj4UeIg6/VGC0Z2PZsPblB606nu6e?=
 =?us-ascii?Q?vqvyedJdUNTrlLKp6ZoJGGfnZbmm2PZ4glpcTovwNvtbFY+LA56nCe8+vXBX?=
 =?us-ascii?Q?0/itBEP8cG5uctLpQkNIi5DrjvC0PkWcR6EY+DOeUKzeled3q3d9ikdSi9ss?=
 =?us-ascii?Q?Zz/c3eGWlwH49tjFojyIifR/PWT2RRe5/hnaFJD9pqOnh3Y5nkVUtXH3AMWY?=
 =?us-ascii?Q?bTywvFaGwdOIWcJgjnz/1rcFzGl55yby9l3KjnasbjGpq72TOKP1JtHdWjLb?=
 =?us-ascii?Q?2YWw9sParjJqZKQhQ1/N6cMVy20A/yK4rNnwBY3a+2Maar2CiKYT6V+htN9W?=
 =?us-ascii?Q?AIFpZQBWGjXTgCfXBuNaWn3a26o7N0f+sk9DuDINUkrxFvqntE51wIGEhEb9?=
 =?us-ascii?Q?tb6FzA85VfbVDRpWa6AW201/zrdG/t2wi8VQbfMFBQeDvaxFGx9AN3wPb+qa?=
 =?us-ascii?Q?+eay78UjfRYnjZKKAJhPYH0ce9ORh3jNOmVGI0t48m5XDyKrCUss0PYWKgr6?=
 =?us-ascii?Q?7epikmAomMnethDw1qMPzhe4zdMketBzVL+dh23/?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a106f740-2872-4eee-37bd-08dbce65d63f
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 16:34:58.5888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WKI8gTZHCbvJc47qefFvE5ZO2vyMfs/4GHjrt+FMuHPPvaB7OoFInqrAAbW+h6Em
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB9447
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 16, 2023 at 05:25:16PM +0100, Joao Martins wrote:
> >> I think Jason is describing this would eventually be in a built-in
> >> portion of IOMMUFD, but I think currently that built-in portion is
> >> IOMMU.  So until we have this IOMMUFD_DRIVER that enables that built-in
> >> portion, it seems unnecessarily disruptive to make VFIO select IOMMUFD
> >> to get this iova bitmap support.  Thanks,
> > 
> > Right, I'm saying Joao may as well make IOMMUFD_DRIVER right now for
> > this
> 
> So far I have this snip at the end.
> 
> Though given that there are struct iommu_domain changes that set a dirty_ops
> (which require iova-bitmap).

Drivers which set those ops need to select IOMMUFD_DRIVER..

Perhaps (at least for ARM) they should even be coded

 select IOMMUFD_DRIVER if IOMMUFD

And then #ifdef out the dirty tracking bits so embedded systems don't
get the bloat with !IOMMUFD

> diff --git a/drivers/iommu/iommufd/Kconfig b/drivers/iommu/iommufd/Kconfig
> index 99d4b075df49..96ec013d1192 100644
> --- a/drivers/iommu/iommufd/Kconfig
> +++ b/drivers/iommu/iommufd/Kconfig
> @@ -11,6 +11,13 @@ config IOMMUFD
> 
>           If you don't know what to do here, say N.
> 
> +config IOMMUFD_DRIVER
> +       bool "IOMMUFD provides iommu drivers supporting functions"
> +       default IOMMU_API
> +       help
> +         IOMMUFD will provides supporting data structures and helpers to IOMMU
> +         drivers.

It is not a 'user selectable' kconfig, just make it

config IOMMUFD_DRIVER
       tristate
       default n

ie the only way to get it is to build a driver that will consume it.

> diff --git a/drivers/iommu/iommufd/Makefile b/drivers/iommu/iommufd/Makefile
> index 8aeba81800c5..34b446146961 100644
> --- a/drivers/iommu/iommufd/Makefile
> +++ b/drivers/iommu/iommufd/Makefile
> @@ -11,3 +11,4 @@ iommufd-y := \
>  iommufd-$(CONFIG_IOMMUFD_TEST) += selftest.o
> 
>  obj-$(CONFIG_IOMMUFD) += iommufd.o
> +obj-$(CONFIG_IOMMUFD_DRIVER) += iova_bitmap.o

Right..

> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
> similarity index 100%
> rename from drivers/vfio/iova_bitmap.c
> rename to drivers/iommu/iommufd/iova_bitmap.c
> diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
> index 6bda6dbb4878..1db519cce815 100644
> --- a/drivers/vfio/Kconfig
> +++ b/drivers/vfio/Kconfig
> @@ -7,6 +7,7 @@ menuconfig VFIO
>         select VFIO_GROUP if SPAPR_TCE_IOMMU || IOMMUFD=n
>         select VFIO_DEVICE_CDEV if !VFIO_GROUP
>         select VFIO_CONTAINER if IOMMUFD=n
> +       select IOMMUFD_DRIVER

As discussed use a if (IS_ENABLED) here and just disable the
bitmap code if something else didn't enable it.

VFIO isn't a consumer of it

The question you are asking is on the driver side implementing it, and
it should be conditional if IOMMUFD is turned on.

Jason
