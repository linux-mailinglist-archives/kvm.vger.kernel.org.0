Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 894167CEB74
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:48:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjJRWsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjJRWsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:48:24 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60CEF113
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:48:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=COV6a0yq9lSeGbM6TGmYkSudsgABOjkNicioG9II/1vgfHRNcPThjCCthZxJn5WCYNlQiDYIVmdTdmjhuRRJrQ7N6KW0E8IHk6WLdM738LDhLjYGesBORJkKg/t5YSY7e7+TSe6hbs6mhZ4o3LjN3dU78QktcS75Or3rZSoNR0zcSzBqyUPsuprKJJr1Pt4PL2LqvDvC0/6fFsSItlPrBBgr+K9sEQOrMI0fo0wMXbCqajIyXY4FMAK5MgE6PZ3Es0TL9b+8I/dHEhGQ95vThosfFsxSUq9LlIoZpsxHNHEeorHPQpSXcvJGxZTkMAoADVtqb+jMNp1VphYfWlWEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gVF2r9ZBD8SlaOHWVZ1rKRasrwaLgSM1QmSxWcowcPo=;
 b=IefyNGYyRQuo83Pkyo3bqrBhD4ES930NMKPMKIaQEMK14ImmI9CD6ebIDEJUwaLFH9QNjIfvSWEe9lV0RaGgpJcoYAGBmfw/lHTEwm56s/1jFhCcG5AzTcdLomce6AS4azIhT/Ob9MQ6I6Lgq4ZEgEN5LKEPdff/O6o32KHvlt2g5lIP2/gkz/ag/7gB+LD25se8udwGwCmUlOiPfEd88mMvG5Gj9X4iZumzKk3F/ohdyGjUNNCWRvag3ifVh1ImUBj+thzYVkttH2TrwguQu3FoYEWaCQcOCbS/2F6wsxqjDE+gBo959wMcsswopCTQVF5jg/jLs9ZqAWCa5C3pqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gVF2r9ZBD8SlaOHWVZ1rKRasrwaLgSM1QmSxWcowcPo=;
 b=AITUK6GpgDArRq1x13Zu1RTPBedr5Vwxnr/iw1XPJHBYb+N5SlpiU5xp5Y315Zr2YcYNZFUkUIYQlHSdoDGcEbcCrwZly8V7y2Xi/VAAkVH4P2AzMNf84PAlmIK4zugIq330qNzgnAdJ/sPt85NehQzVq29Uh+pVIuiJ4xVAoDEyAH2pvhYmarlxPrY6LmbSXna2ysL6nvvv2wUXnfdSS2HpwuLb4XT+0eEHy/OECdjntGL020/OFqWjvYPqrtXs9UkASVV9itlfoIeHFk4WhZMEsTl5ZOodzcaA0d4Je2HiLYcG0/g1wwoyBMXN8D/5LIPXVFiMu/wjjm1C4KZDww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA1PR12MB6894.namprd12.prod.outlook.com (2603:10b6:806:24d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.34; Wed, 18 Oct
 2023 22:48:20 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:48:20 +0000
Date:   Wed, 18 Oct 2023 19:28:43 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Yi Liu <yi.l.liu@intel.com>, Yi Y Sun <yi.y.sun@intel.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH v4 06/18] iommufd: Add IOMMU_HWPT_SET_DIRTY
Message-ID: <20231018222843.GK3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-7-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-7-joao.m.martins@oracle.com>
X-ClientProxiedBy: BN9PR03CA0568.namprd03.prod.outlook.com
 (2603:10b6:408:138::33) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA1PR12MB6894:EE_
X-MS-Office365-Filtering-Correlation-Id: 796a2fdc-c25f-49a6-5bbe-08dbd02c5367
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+fTrW6z+GwySN7Y7WqZb64vjlCS4SmHCdvOArGJNBiqiOqVTdXpjGpauXeuFs/cDvUSZUzhIkdSDTekLxGxI9LXjh/u8/fKjVLv2+tNi+lfZ3dnGcg8P2sRJqgu965e6zCPucxdhe1/8C4dwz3JBEfVk3kux8DTqjlRsKTo68RLPMJROyz/s+WnjUjeJocJ01QrE4hPifZrnhEHnJXHSHgyLrYiceLekN0dv7mXrvLylxylF5pJpNa9wLu6lz5sV4YNrWRo6GhC+YrgEAG1PiSggIiic3jKX21qUiLUktDMmKBTQuoHJj7WGADr+cb+Xoy2/PJOHBLISqI4fnSUZcl6LnvkI5g+VqpZKSrkbWwJFixJWeZGWu/Tlc9WCDBrpN9q2xMt6pDXL6GLnuenb1Mp9CirEtnS28C1ApNGpWYZM8VWtiQOytqfWVPITfgwolnACBVYcaQr8G2hG6vI5egUhiJsPF38bELGozPK1k9KF+gbmTBeXE5zwV+P3Ztw09AFnlN8h/inDb8nBuyes2mZhh7TryuqAgB5p7vRTnjhe1RqrY5px/ncbagdRqYx/CwCRn5qLguRl2gASzdn7SOO/UceVwikYpiVteQjCTw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(376002)(346002)(136003)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(6486002)(66476007)(1076003)(86362001)(66556008)(478600001)(54906003)(26005)(6506007)(66946007)(6916009)(2616005)(6666004)(33656002)(5660300002)(8936002)(4326008)(8676002)(2906002)(41300700001)(6512007)(7416002)(36756003)(38100700002)(316002)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ewv+j3oxO7ImblIkmxKuzFJSyqGXNVYwZtL9TrcPsdWKYw10mzjpc10rBFI5?=
 =?us-ascii?Q?4PuERtWr5ANsYRNfoAaTMvZJn0p7g0xlwlWsg7LTYsmZZ9TCggAEUnZE5Mu2?=
 =?us-ascii?Q?XCqzD8EhAC4vExKkryLeEc7QadJYK/b/oVWsRP18aSLdDz53oIMb0UBNtt/z?=
 =?us-ascii?Q?4GkHqPwXku9AmbbPOdibiixc30TWVNFHMh6BjGPpo7/J3YzbsOJbLBY2sEoI?=
 =?us-ascii?Q?eLlhQhQIZYAJA6Qkt9bVUqxq/xj59N8vw111dlChSp8SSe3Wxluc5Y4KX33i?=
 =?us-ascii?Q?F8k9ZMambf56+8RmeNlgULZwlnyJaNrPYN5/2he+lEd4zBDSsWyNY5Rj1KMH?=
 =?us-ascii?Q?DSgss9RreRomciTus7Ci+TJSJ/czZgfprc5NAjIsf03blJtyrmPDMWlOzV9C?=
 =?us-ascii?Q?utT6qvZq/GpD+RZ8LwIXPn/7dNLhAsF8foHkLnY2csmT8wpl5FflDmp0NqLc?=
 =?us-ascii?Q?IkNzAW+7nvkfrKw+qXA9CgTC+g1t/7qDKS+s2Za/LuwdYnAYOA5m2phCmB26?=
 =?us-ascii?Q?2vrn+/B1VHilgwiD8THhTxv8y+HEKNZ/Jj3OGBXqZYUQpXZue/gP6y5clOVR?=
 =?us-ascii?Q?xNDrwRRL82gJ9KVVXZcDyXTJVrNo0PRLioSv2uWGT/1yhWpk5bBtfiN9vNB0?=
 =?us-ascii?Q?ukm9UWez6bh7MrWbceezipfNNXH3EcuaBtqC397t+DO2T1eQm6942J/qcw1X?=
 =?us-ascii?Q?rFQpZ9L8g3FL+ZBASM32zCKOKIOTBUtp3zH5kOfWp8XyVOJXBiIiOPaOarBm?=
 =?us-ascii?Q?Y97K1SASENxzxNTVf9/scZFi3ysgRZ9RoHXGfcCzsMlWYkqeLUr/KkE0rAGG?=
 =?us-ascii?Q?COqXloNmXmMftCNM3fs4GGchQzKP+jU2jUR3QBqIbZM9U2uBhsslyM2ao9tD?=
 =?us-ascii?Q?ZVsRlC5k262L4E46DKU9ozOaABGuQytrEBIfhgd368WiJtx3nMGbaNQ2g0F+?=
 =?us-ascii?Q?esCMPh3MRNLLmnnZArOHh7Eym4UaP+dFWJqMeg1HAdzGE5NqTtUdStmOzzsI?=
 =?us-ascii?Q?+GexDwwNDui4SIe1LWWuSm//ZEYQ4PQ26cLNlZJiLxYw20kHIaTvtO1kWBF3?=
 =?us-ascii?Q?1Bjx+Mh8NDdh8KmaxDY6IjT9G3L13KIAUzENts1rZ7D9XVg5UROyY7yCx1hH?=
 =?us-ascii?Q?BGb7k7kMb85bVDjWnJmriVJfi78rroE07N7TX8qMgMU5JTNLxHa2FexJuBUU?=
 =?us-ascii?Q?lKYoeNwAuc9wrHzYHGBIgWqZtp6Js2NVZQZr6oce/O9gnljVlpDKoEHlO57V?=
 =?us-ascii?Q?qrDu/cxhZcN/z5N9/cwakL5ivMhmvphq6WsuCj2OCXFBFoVBMyK9BIN5r6wP?=
 =?us-ascii?Q?ccwst/dUgd34VQnPOa4/y/13nun4Qv+/iKiX+swhMaTSA6O6rvFnqkWCLzOH?=
 =?us-ascii?Q?KRts/ccZsbNUou8U0A6IkBAW986P8UJp2A28lzGBBTLnORGG3VM7tPI8mAom?=
 =?us-ascii?Q?tKvYk1YKPiQHRHBzFd9GLBWEMdIa3Z9xkmHm8bd9oMs2PQu9JqWqAaV4VhY3?=
 =?us-ascii?Q?GW1Qf7IUjiKZGr3YwfcbaPK/Psa+D4HxPm4CGGHb5AHwK58ThgyiwHU5B0Dc?=
 =?us-ascii?Q?YYB3r084eS8PM+6ELU+ijc2nlCEhm93A3muKRH/C?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 796a2fdc-c25f-49a6-5bbe-08dbd02c5367
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:48:20.0555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r+tvnjIpf3kB4DzG1zkySV7fe/Dmu4tdu6YtPYt99PcsJABGG/w5pjc5bwmPSH9W
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6894
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:03PM +0100, Joao Martins wrote:
> Every IOMMU driver should be able to implement the needed iommu domain ops
> to control dirty tracking.
> 
> Connect a hw_pagetable to the IOMMU core dirty tracking ops, specifically
> the ability to enable/disable dirty tracking on an IOMMU domain
> (hw_pagetable id). To that end add an io_pagetable kernel API to toggle
> dirty tracking:
> 
> * iopt_set_dirty_tracking(iopt, [domain], state)
> 
> The intended caller of this is via the hw_pagetable object that is created.
> 
> Internally it will ensure the leftover dirty state is cleared /right
> before/ dirty tracking starts. This is also useful for iommu drivers which
> may decide that dirty tracking is always-enabled at boot without wanting to
> toggle dynamically via corresponding iommu domain op.
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/iommufd/hw_pagetable.c    | 24 +++++++++++
>  drivers/iommu/iommufd/io_pagetable.c    | 55 +++++++++++++++++++++++++
>  drivers/iommu/iommufd/iommufd_private.h | 12 ++++++
>  drivers/iommu/iommufd/main.c            |  3 ++
>  include/uapi/linux/iommufd.h            | 25 +++++++++++
>  5 files changed, 119 insertions(+)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
