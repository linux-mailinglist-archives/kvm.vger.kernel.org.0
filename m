Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E07D3EB6
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 20:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjJWSNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 14:13:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjJWSND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 14:13:03 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2089.outbound.protection.outlook.com [40.107.93.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891E19D
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 11:13:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ivDgh8guIyizW+jO3iikIoqTJYOc96daon1OkFNNz/AI2v/bdsOJci5LzAq/zZx4p71HadU2t9NaruEbL9LBaBD6Ln0EdGG9x/AivfMKhtdRnj+AN/GVWOf6bg3p9yQSyoiPrNyy3VdHShCGiX4V4RNqQ44vAQyrQstIMEs0kYYWogk2VTzaSXSLAINOxcLA9Dt3+H7S0nFW9S9DL2sWDgGS4HnYELawmaOhHtTuTsGv2XldGPUFlrJxv189LqJexvhYTOLIdrF+ktPCwpJduNTz5ryy29h7f/ijg1aUsOuHhvXMjFzQ5m4CP/qJZEkAJLbEM8cmxON7Uoq5c7H15g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DJZCfRleZuevmGAv5Yk1TQ8WaqwahfWHdYXfFAb9Uog=;
 b=iynmhGd/dtmvWYHwA2igMwP9jYWUm1+1lyx6k2YwrNX61ppA2nmrySKFLO/O0EoS+AzY7ZqWVd4jR581bQnOJwbIqfQiD9/KwKGHPuL95xfyvdwp0clsfhAVoGqiGbas5mAmtaO3yYRvYKVdxP9U1z8rH1157+NglMlmhs7/EaBJ1vwRw1wWic90hGNTivemQ/qBhKnK3r6cdxkc7eWiyvB5+VXA7OkkrgHQVurwbDoMMb/wqtIia4euNS3ptA5hZTDhYQG5/gCFYLfW9VH7uhFCn2mBsAlKqvfvJNpVOlc+roLxfGpPxF9oXN6GYy3pzj084bY3PPhfBBkz1vtefQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DJZCfRleZuevmGAv5Yk1TQ8WaqwahfWHdYXfFAb9Uog=;
 b=TwgvXX8ybLO6UCb5bQ8ZSPgYweXHkQ3pTHmN2wOWZi3hxGH384h3G135tXLo3RKCmFtdiPUt09cMQsMuJkh5/55qibl4D/3vaE5g6qUzWbhBJZAUXqlaJ33ZyloZxzNG+4qirUbB5AXzusduPuoPhG/TumT+4LxHTXmzLpA7f+XMRZsiqvvv7okm5QTwtY87SB1Iht6G+WC3mq8z/t96koLgkmKw5eCFbsgr+5uW3SXw0jCyAICICBx4ghg/cYXv7nHY2d5laF/mBIAddeH8je9lUWrfFKe10kVk0MBd/TKyjbSP0vvotmMarhm4b4cV1H0ga/GQXLOxCM/aLbX6MQ==
Received: from CY5P221CA0039.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:4::15) by
 DS7PR12MB5719.namprd12.prod.outlook.com (2603:10b6:8:72::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6907.26; Mon, 23 Oct 2023 18:12:59 +0000
Received: from CY4PEPF0000FCC4.namprd03.prod.outlook.com
 (2603:10b6:930:4:cafe::7c) by CY5P221CA0039.outlook.office365.com
 (2603:10b6:930:4::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.34 via Frontend
 Transport; Mon, 23 Oct 2023 18:12:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 CY4PEPF0000FCC4.mail.protection.outlook.com (10.167.242.106) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6933.15 via Frontend Transport; Mon, 23 Oct 2023 18:12:59 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41; Mon, 23 Oct
 2023 11:12:50 -0700
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.41; Mon, 23 Oct 2023 11:12:49 -0700
Received: from Asurada-Nvidia (10.127.8.12) by mail.nvidia.com
 (10.126.190.180) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.41 via Frontend
 Transport; Mon, 23 Oct 2023 11:12:48 -0700
Date:   Mon, 23 Oct 2023 11:12:47 -0700
From:   Nicolin Chen <nicolinc@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
CC:     Jason Gunthorpe <jgg@nvidia.com>, <iommu@lists.linux.dev>,
        Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Zhenzhong Duan" <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 00/18] IOMMUFD Dirty Tracking
Message-ID: <ZTa3n+1WQWRLrhxo@Asurada-Nvidia>
References: <20231020222804.21850-1-joao.m.martins@oracle.com>
 <20231021162321.GK3952@nvidia.com>
 <ZTXOJGKefAwH70M4@Asurada-Nvidia>
 <4e7c8e8d-f22d-40e8-ad41-1e334bb78496@oracle.com>
 <f6f13ff9-ec92-4759-bd0a-9d17a87509cc@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f6f13ff9-ec92-4759-bd0a-9d17a87509cc@oracle.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC4:EE_|DS7PR12MB5719:EE_
X-MS-Office365-Filtering-Correlation-Id: 67be7250-5d11-488a-973d-08dbd3f3b076
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sRt532U+k2AC+zzzR0Q/RPZ3NX0ZvcZ2op73FHxA227mvt3ZLicAbJWH5ORNtP8bklQP9imfLMHk4Mp1Dz9BtNZpT9pJbXyoxa+I6zgX1JXM5bbGamkGZX+lAeFdXOqAqEz9OSn8uRZhlQQ/7Ox0WcdqUpR4qJmG9n9V5IM7fJDf2zrGMM8rje6HlCn8HdeYryDzlWAalDNUEgXkD0NxDLMsN2lu/UMj550e2cGN7LJsXeL3EfGQYhKeBUQ3t03Ajd28cwg0cajJY/UEHNd9DUKmHWe4+sbSSfVfCf3fxnwxz8isePlJxh5fh7pFezlKyd08wdCIPE1fHtSkEVlEN6YwbCrrjCPMcUqPh2cbKbtra8qVU/CLpJIwzpL5UsgayWvrYNNmMLISJzB5UxwJVpUWIDRALQgg9GMfl08ilkAQByfRMvA8Zyr1qQ1bedxlaBElQ6+h/F13rZxdSgFaNUlE5nzwKtifUjRv32tNacRVkDp16QldC2DUJpLo2qLP7zZXNjnwp7ROQgX8h0DYQx0tCtTDgHxwgztR0VfIaKLVEchx4lqURvaY8xJdi84W20YRDuKXEdS2Xs04nm5B0dIXajUGgqNOxPGT4xG4PDWCJzxy9ImNL8vY1wcZ3P91sFdnH24OFCpR0QCT3InVV7R5EGlH590Siu1SHsn9ZKvg3AEycA8pbRFnXYEzB8hL7xdZ5IUeLHN5J+t3eqQfFpyYXB/RD0RiBuoKseJmuiclgWe8h9hpGFaPkGYQTUUCnpiWeoduHm8lE8rld89waxywY/3X350KDaY9VwFs0JA=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(136003)(396003)(230922051799003)(82310400011)(451199024)(64100799003)(186009)(1800799009)(40470700004)(46966006)(36840700001)(7416002)(55016003)(2906002)(478600001)(40460700003)(41300700001)(5660300002)(8676002)(33716001)(8936002)(40480700001)(4326008)(70206006)(70586007)(54906003)(316002)(36860700001)(6916009)(7636003)(356005)(82740400003)(26005)(336012)(47076005)(426003)(9686003)(86362001)(14143004)(67856001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2023 18:12:59.3195
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67be7250-5d11-488a-973d-08dbd3f3b076
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000FCC4.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5719
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 23, 2023 at 12:49:55PM +0100, Joao Martins wrote:
> Here's an example down that avoids the kernel header dependency; imported from
> the arch-independent non-atomic bitops
> (include/asm-generic/bitops/generic-non-atomic.h)
> 
> diff --git a/tools/testing/selftests/iommu/iommufd.c
> b/tools/testing/selftests/iommu/iommufd.c
> index 96837369a0aa..026ff9f5c1f3 100644
> --- a/tools/testing/selftests/iommu/iommufd.c
> +++ b/tools/testing/selftests/iommu/iommufd.c
> @@ -12,7 +12,6 @@
>  static unsigned long HUGEPAGE_SIZE;
> 
>  #define MOCK_PAGE_SIZE (PAGE_SIZE / 2)
> -#define BITS_PER_BYTE 8
> 
>  static unsigned long get_huge_page_size(void)
>  {
> diff --git a/tools/testing/selftests/iommu/iommufd_utils.h
> b/tools/testing/selftests/iommu/iommufd_utils.h
> index 390563ff7935..6bbcab7fd6ab 100644
> --- a/tools/testing/selftests/iommu/iommufd_utils.h
> +++ b/tools/testing/selftests/iommu/iommufd_utils.h
> @@ -9,8 +9,6 @@
>  #include <sys/ioctl.h>
>  #include <stdint.h>
>  #include <assert.h>
> -#include <linux/bitmap.h>
> -#include <linux/bitops.h>
> 
>  #include "../kselftest_harness.h"
>  #include "../../../../drivers/iommu/iommufd/iommufd_test.h"
> @@ -18,6 +16,24 @@
>  /* Hack to make assertions more readable */
>  #define _IOMMU_TEST_CMD(x) IOMMU_TEST_CMD
> 
> +/* Imported from include/asm-generic/bitops/generic-non-atomic.h */
> +#define BITS_PER_BYTE 8
> +#define BITS_PER_LONG __BITS_PER_LONG
> +#define BIT_MASK(nr) (1UL << ((nr) % __BITS_PER_LONG))
> +#define BIT_WORD(nr) ((nr) / __BITS_PER_LONG)
> +
> +static inline void set_bit(unsigned int nr, unsigned long *addr)

The whole piece could fix the break, except this one. We'd need
__set_bit instead of set_bit.

Thanks
Nic

> +{
> +       unsigned long mask = BIT_MASK(nr);
> +       unsigned long *p = ((unsigned long *)addr) + BIT_WORD(nr);
> +
> +       *p  |= mask;
> +}
> +
> +static inline bool test_bit(unsigned int nr, unsigned long *addr)
> +{
> +       return 1UL & (addr[BIT_WORD(nr)] >> (nr & (BITS_PER_LONG-1)));
> +}
> +
>  static void *buffer;
>  static unsigned long BUFFER_SIZE;
> 
