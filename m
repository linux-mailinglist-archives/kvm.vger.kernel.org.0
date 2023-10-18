Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3F417CEB26
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 00:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbjJRW0h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 18:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjJRW0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 18:26:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2066.outbound.protection.outlook.com [40.107.94.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 844AC95
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 15:26:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G6JRUvrC6lcjZUeJz7SBUkiZfkbCxr8AiXJC2iA4bC2a6LVVoeySWjKJMyAa0cYcSRuYco0LEH1FSiqrq6y5uondSqamvobcBIBz0IMory5ZI6rblWfasYEngTfPgb8IBKKUg0wqM6rCRboh6way3CM5INW8Z4fUH57ZL9NWhI0gCELKqkN8Uv9TViv3YOWmMmtGTVlD16TOpFon4BN6JonJf6o3RSYOhr7dmoc5Qt0HEbTj0Eumf4kGBhZErOrcUCc9uAqnExkcbQHoNwJwXD700J4SjslZPhTHFXHOMD0YipoVeivdK80uwaqXmsEKDQ44Y5/7G4pLHhulTcjSLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+T+Cnxmf2Tz0PsTCg91cH5NyMlPvuC3f+aX2EAmv0IU=;
 b=YN4taU512PoDNfzDeo12ZMnOsdpIf9gC0t0i4MdzQCm46fYG2+WASAkWc6MNVKR8f+ndauAw4OxaBJRKfS7hga3jPuwcRqYNJiiWve5nlPAeNaIxbtrHPxb46SXaxR4lgJNn9oIDzE+znOp2Zuft6yV+VxIu+Z9FYmssukMXJvx5UcGlNZZFVGR/YrFl6v+aAKAVdUTheVBIrRxmVUCT8bl8vHAr3aT+FvINi8TbksvCSNtavQ9xR1cOwcIvjnoo2zM3nbmpxiVQcfNPFkACwLiQsIByOVcKDtyhHd8tZimTNr7DN3ii5mQi0Dxt8TVaPrsMnhqfK9pX6FuDVqapXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+T+Cnxmf2Tz0PsTCg91cH5NyMlPvuC3f+aX2EAmv0IU=;
 b=f0sIlcwOqjYviAEHMzQf95UL5o+5tBZvMBCOet1M+ui2gliwkzo1eqDUUEOCYWZmE9e1PWLTdc9TM7anAVoCsfEJEgP8wRSe4J6hdiKRmGih4ap008R18i8u/niG5mDtaQUGsZ05ENFKoasYg6NIGdSTbSZOov2IbIAvuXPU1xkUslF7hlwr4ZdZFwUdbgpd5y4pnvK4cd8vDas83wmeDHsgsTkwtrsR9y3u/wGEAKRkpwpS0tkCc5MjOtkcR3j0kNRQbZC7iDla+sA0ZPgIkqBhRTEcDOVeWcCjwEit3UTkXR81cVTETxYkdm8GauxWzsk1CrHkt8Cvkv3TSLlTSQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by IA0PR12MB7697.namprd12.prod.outlook.com (2603:10b6:208:433::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36; Wed, 18 Oct
 2023 22:26:31 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::3f66:c2b6:59eb:78c2%6]) with mapi id 15.20.6886.034; Wed, 18 Oct 2023
 22:26:31 +0000
Date:   Wed, 18 Oct 2023 19:26:29 -0300
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
Subject: Re: [PATCH v4 05/18] iommufd: Add a flag to enforce dirty tracking
 on attach
Message-ID: <20231018222629.GI3952@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-6-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231018202715.69734-6-joao.m.martins@oracle.com>
X-ClientProxiedBy: BYAPR01CA0019.prod.exchangelabs.com (2603:10b6:a02:80::32)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|IA0PR12MB7697:EE_
X-MS-Office365-Filtering-Correlation-Id: c2904790-05c0-440b-8901-08dbd029479c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rbzVqM3XXMBQFD+nk+c+Bezb0LrEyZUN3y+CotGPHvXILbYL8pR+As4W5szAZ/zLfCxXndwpNpCcwbAbX5dHfT+x0CB1+/uXmsAQtQlCaOzRIciNEayh8VplFmSM6snqBhBDz2sKF/bkN1i46rgEvXI3Et+LDCFbUiZw5Zvvx9hAg5HSolk7Jk+ecv5FM+LToD0QaTCf4GJADa15VkGYToDknDzh24pzSDOO0ozNzvVEcBl3xtCMGZlyoFWZjvhMQbYgSjPZXmBuf/YVrF55NeJ1D4g5JLQOeexlTfRwynqbFz0T2faah1viCj4kyoU418WCAa5ZTkuqW10yDtJlPxp9lKUxnqCbYqG6SIdQHI4HWM98+ihqU09eZ/+7vDezoB9kn1pwm7KhjktskPyLMz8nLjFcJCmglY8Z1DjUwv/f2pmRZ4JA7qgtiL0wK4lmlXtVRunortWAvwUjxX8Gk9eWI9EvBmPj/+mGC736e4QhsU6NRdVt8gC4iKVAH2vclFucud9r+eLELrnNIWUWmL+0UJC2kmE6DQazY5I9bci6xiQUC91H9W8s2HeLhsnaPdAqOr8TaDAe9s+bGNXLZ2dha94EZF1NCrFCdzIvGDPFwRnH87P8yZ0zPusB+cyGYsE2VgFKVtQw9OZFtvm9AA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(39860400002)(396003)(366004)(376002)(136003)(230922051799003)(64100799003)(1800799009)(451199024)(186009)(5660300002)(66556008)(83380400001)(26005)(66946007)(478600001)(54906003)(966005)(6486002)(6916009)(6506007)(1076003)(316002)(6512007)(2906002)(4326008)(41300700001)(8676002)(36756003)(7416002)(33656002)(8936002)(86362001)(66476007)(38100700002)(2616005)(14143004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tSXwWr+wUQYHxbJrD9tMfBDY19YkRyzYv6jlneuzQ/inWzCY+kWBE81/I8Ch?=
 =?us-ascii?Q?NXUZXbawOn8abvcivsqDoY0C00wBnc3T8S1MRt3Xvg6KjbZLzU/3KjE7rY+D?=
 =?us-ascii?Q?voBCtg0s2yJeTlfQOQTV57olw00l02TqDqCJ5D9ppPlMLXCRDM27MsKfAClP?=
 =?us-ascii?Q?bnfS2vDBf9l9r65xCwYrBfyAVPZ6mx6Shd/uDYGdn39f6LsAG5oJDb8MIF78?=
 =?us-ascii?Q?9gzyKDiFrSx5HMJBIgQ5pvC7ngd1J1K74+OuAkVUw9GvG1kyAUoNM3KVHUAG?=
 =?us-ascii?Q?O1DHZZ9sqFy2sQpEhd1efjatOtGIWAeXC7wQIEpID4opWry2krAgd8DGXKnZ?=
 =?us-ascii?Q?ZCIt3UVFyp90urNxvy695IxNC7wZDhiLc+SUCQZPJsFSYJNAiG5/qAWmhHtB?=
 =?us-ascii?Q?jXib/D4zroavmqW14SdWnwScU1Ya41bpR6hBzGJz6cwDQxYc3Me4bxmSM2kY?=
 =?us-ascii?Q?4CXZLrcedVEMAF4kot8YKvrA6FiXLQB571hgRJlU4sAP72zNmpuwjKH4eGcG?=
 =?us-ascii?Q?JIZ4SkkCoS4+9mMTV3aL2y0OKpH8Moj+sZ+D8KLMxLaJeo+MRlLhu2iC+UDH?=
 =?us-ascii?Q?aLaRqcbLkNhQWN6g0zuZ+jbe+WSncPSfZWwzR47wSlFfruj2CcjfjyYE/HNH?=
 =?us-ascii?Q?vfIiBK4/oPIoxO/6lAD8N0R+7Q5Qfs6gueTGT0neGoKwdbsNsLPrubnQJCAx?=
 =?us-ascii?Q?qbTUM+SwCy6iFBf0KhzO/A0NCRGX85RoBC6pzDRVoBNN6sh1oXW3N9XCPj9H?=
 =?us-ascii?Q?pIAnWzCdsUxbfpuflUj7K89Au0uHxMoFruBaVNqU5QQyjaBBYMM6yVWrhTy3?=
 =?us-ascii?Q?tuswRF42CAdLh3Mcddh8aSKrN63ns/HCEfPz9O6c7miiWkz6xdbjBuxp515a?=
 =?us-ascii?Q?5uyzwWSKqU7uKUdoUyZbeAU119Wg2H+eZkx/2NcM4ZvNPSevVEVH0l+pGnTD?=
 =?us-ascii?Q?oBlb4E3E/knZz3qj0cZRyBYQRBvrh+sC5DVVO0hqt1m7W76dNrVbckmqTtW5?=
 =?us-ascii?Q?/M2o+Wqbw5yKQiC/nfIRtOa9U/yUS2jEgcKkqp9fbzJQJg5m6ExjHMA5/w0T?=
 =?us-ascii?Q?toDDRXFOXB0ZEHzAi6qCN5Jkyel52//QPBSHaOsjWx5jHGNJBx+sm8l6u2Qa?=
 =?us-ascii?Q?kISZbNo1oj0i33khqd+1HpDBShky+KSYZod+qPy6HT/bxwg/a0CReHw77/YE?=
 =?us-ascii?Q?sC91F5GvvXLnl7DVN0MWGZreofsqFJvuUR7VC7HlWq0KXFFAtD9pAD1Kyloy?=
 =?us-ascii?Q?usRDsWVEkejNjTGeNmsAZODbeIlgd5NT+/sQup7pB5rjGXPBeGPLyWEhqSOP?=
 =?us-ascii?Q?pdD4U4wspFT4QB3z99TUV/YK4bbVPKy2HH6CGnx83NGYYQAQD/YbC5hYtUgf?=
 =?us-ascii?Q?KIzwtybrCyY7txcWBI2rQm23k7N6dy1y2es4aP9K1MHiv7zROhqb0ALHAOtI?=
 =?us-ascii?Q?WmOYP4C+KAFJf5sy+n1MuV7RZh9zroiktTK7kzrgSp//bOuR7K3vzOnORgFv?=
 =?us-ascii?Q?u32UVnr0JeCQ3slR+cmU98cO5a+3e76b8DDOVyEE/6qtAVgLmp/gr4CmLG4G?=
 =?us-ascii?Q?r5KvkrXvbJ4zgp3U1eSpGTtDd26Jqk3HIt8XojGB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2904790-05c0-440b-8901-08dbd029479c
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2023 22:26:31.7745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: miQ+JWd/JAyB88yTtoKbLn4OODFhWwWwDf4AH/sjSHJyTAQVAYrlP7MyE3IrVcFV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7697
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 18, 2023 at 09:27:02PM +0100, Joao Martins wrote:
> Throughout IOMMU domain lifetime that wants to use dirty tracking, some
> guarantees are needed such that any device attached to the iommu_domain
> supports dirty tracking.
> 
> The idea is to handle a case where IOMMU in the system are assymetric
> feature-wise and thus the capability may not be supported for all devices.
> The enforcement is done by adding a flag into HWPT_ALLOC namely:
> 
> 	IOMMUFD_HWPT_ALLOC_ENFORCE_DIRTY
> 
> .. Passed in HWPT_ALLOC ioctl() flags. The enforcement is done by creating
> a iommu_domain via domain_alloc_user() and validating the requested flags
> with what the device IOMMU supports (and failing accordingly) advertised).
> Advertising the new IOMMU domain feature flag requires that the individual
> iommu driver capability is supported when a future device attachment
> happens.
> 
> Link: https://lore.kernel.org/kvm/20220721142421.GB4609@nvidia.com/
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>  drivers/iommu/iommufd/hw_pagetable.c | 4 +++-
>  include/uapi/linux/iommufd.h         | 3 +++
>  2 files changed, 6 insertions(+), 1 deletion(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
