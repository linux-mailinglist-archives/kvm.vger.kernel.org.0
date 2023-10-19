Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1EA37D00DB
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 19:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346324AbjJSRtH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 13:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345163AbjJSRtG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 13:49:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2088.outbound.protection.outlook.com [40.107.94.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46623112
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 10:49:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DbUQdiRWrLV6vJhfEX0wqyZVXgmUDfOvmCDwHv3Ce70hu6spO6rqHWWk6D6FcGXv4WVTu7fiB3h8cq2K8kuia0CfyO6ZDsUbVaugYpbMqjrNYvt4qoaXhGPeQEyhGx749j45+BSYsDfRXSDmwYUTMfGlu3Etva54vsAd/a1x7ldVU/QPe8t15EJZPjQrpu31PhFvitNgWlN42fexvMTJNZsOXU5Jrpxc/f/6qHyQnlXCv1TTPTWZfxi7E8ib0tD3XIjorR4BigSinrWkoohCfQjRivHiaOhR8cPX6ou1F+ZSVSgsz3nUV2MdtECcQnHRonjhqfi8UsSiFJYc9Z9UMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=81X9BSrLRN+WvMck3vd9WrkKXoewsdgEZXSstSIPu3M=;
 b=FRiWzIcXRqPqSPkc7NYAFSqNyKLGX2Sal6rgIIIfkkzeBkoVugCkI5BMkKKRC78/NOFyLyAZ2nknCmy+ALJ+i1jt3V071bN2sDwUngYjoodrIbHACE5+MXDnBLWHcA5/f/bOZXdjorzGAw5M3uGk6DJjak8TZw9HvP898ca7VrSze4BFjaHMWMyq66PK9XnSG7NTSzLNIBvJ8Uc/Vj6H+Z9QYhlzXyB/NC8+owd73YVbXN+IckUlvCPvsh3PeUqbrPFSHnJWWEZjIy+3VMhUJM+y+6mlskgY92uDjwbnF0zKbNWjjQJJeFt+NvaUZKZt5+/bqaa5Ow3eEnO3fGdA/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=81X9BSrLRN+WvMck3vd9WrkKXoewsdgEZXSstSIPu3M=;
 b=PECqzUNdLlqAA/+pjVVjYuOb5VMvi6015WdslDLawE89m3I8CHZhBjPDiger1y+psvL4HdYTgbHaGbaRTNihLK8xo1Y2Kxh6YOacGnfqfL6KI1V7K+NmfLFSjzGp0FY3Kno/TzUbmsbni2eHbkL+o6Gqh7HA38xBuNn7DGaHSMM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH0PR12MB7982.namprd12.prod.outlook.com (2603:10b6:510:28d::5)
 by CH0PR12MB5251.namprd12.prod.outlook.com (2603:10b6:610:d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.35; Thu, 19 Oct
 2023 17:49:01 +0000
Received: from PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::8859:6c1d:e46c:c1b2]) by PH0PR12MB7982.namprd12.prod.outlook.com
 ([fe80::8859:6c1d:e46c:c1b2%5]) with mapi id 15.20.6907.022; Thu, 19 Oct 2023
 17:49:01 +0000
Message-ID: <042fd4e7-b758-63d8-b4af-0eac38e5483f@amd.com>
Date:   Thu, 19 Oct 2023 10:48:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 03/18] iommufd/iova_bitmap: Move symbols to IOMMUFD
 namespace
Content-Language: en-US
To:     Joao Martins <joao.m.martins@oracle.com>, iommu@lists.linux.dev
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>,
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
        kvm@vger.kernel.org, Brett Creeley <brett.creeley@amd.com>,
        Yishai Hadas <yishaih@nvidia.com>
References: <20231018202715.69734-1-joao.m.martins@oracle.com>
 <20231018202715.69734-4-joao.m.martins@oracle.com>
From:   Brett Creeley <bcreeley@amd.com>
In-Reply-To: <20231018202715.69734-4-joao.m.martins@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:a03:331::9) To PH0PR12MB7982.namprd12.prod.outlook.com
 (2603:10b6:510:28d::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR12MB7982:EE_|CH0PR12MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: bd7a9b57-26b7-4b15-e505-08dbd0cbadc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zG0iYB18BefhEFbW1lMEniIiy7x9WIsxvBd7V+4Kx8DDWFPoZx5hyb6DXd+zumLdfUQurFt19G0+YNGmnC7+uifAsZs575XocK44xGRkKTriCYDaEeiuzeUNajs6LKcYAJgF5NG1rkR/0QcMtFGUFvoJENsIJlN64J55/rqsJa2HSsmZyAwunEkz4W6K4XuqnD78eK0Yzdi2eUGsItYKeUbw3xrdr8+nl2ILLh++KpeytnaaESZd/UeYAv5CfbJ8VtTju4c0Dr2PImjn5khcenhCICcVwPiPUs4c6qge+TmkGbevIzYHCxWSuqlAxh9y/F86mLqIdYthaNSZAKfL24t5MqOcAK39dVhYxHOARXCuTc/C4+s1yLGVLq9jqeXfihM5+moq+/yndqybo+DxGZop7N5RAZvlWpvuA2lyJQXZxnAaVyKhM+BxqhTVK7sZJyfOMKtZKXSjqBV2gFem+CTgxBw05lX7QeCHwJV3VVnYIroqxisyFXYq8aUDyzpbId4J8qBrZsEzUcJHhiofwBEQxMt7fOyQApVFDiIvxv9GtcwxJUDT86Lnzpd2K/3S7lP/pf/6I940hDOxaNvkwes4vxR2/Tgh3yJK0OSvFhvuXnighvbHt+chfNsyHU+ptEfSLjlXd4033jmRcEBMSQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB7982.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(136003)(396003)(376002)(366004)(346002)(230922051799003)(1800799009)(64100799003)(186009)(451199024)(6486002)(66476007)(38100700002)(478600001)(2906002)(66946007)(54906003)(6506007)(316002)(66556008)(6512007)(7416002)(8936002)(5660300002)(41300700001)(8676002)(2616005)(53546011)(83380400001)(26005)(36756003)(4326008)(31686004)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NE9hdHJJT2ROUkE2MzZPUWwvQVFYdEtYRFE4L09aWUJwYWFEbGFrRFUvTTkw?=
 =?utf-8?B?djJrNSszV0JyT2U3ZmdySVY2V0U0azJ4dWpHb1hRTGxoOXJvUDdEdUpCN0xa?=
 =?utf-8?B?NWY2Q0FNdG53b3Vzb2h1eE96SVp0STZvODZBQ1JGd2JHNXN1aFJVSjk4dmRi?=
 =?utf-8?B?U2cxN0lqUlhQSzRac1Z2RmJNVlBKUjJkeG1QYzl3U0pjN2ZtcHBEUG10QWls?=
 =?utf-8?B?QlhDUmFITFpXWGQ0cDNUeDNUNjdWaFJGR1lJREl6Tm10eHJRaGRGWjA1b3Fy?=
 =?utf-8?B?OXVTL3VIa01CbFBxR1dEWjk3a05VTHJmQ3p5RTZpUFBWWHdlNXlsTnZEbmFk?=
 =?utf-8?B?c3dWdkVjS25BTzVubDFhVTd2Q0hOTXk4OTRjUkgyRlRqcFNCaWVRdEpsOWxa?=
 =?utf-8?B?Q1QwWTNlekV6Y3NuT1FlRG9iWUtXZTNFTkd6QjdjVmdmejk1MUhzZXlVczhV?=
 =?utf-8?B?S0djMWNIakU0VTVqcmM1Z2VEb1ZzQm05ODFaajllUTBkVElWZjNEVEE4Zldv?=
 =?utf-8?B?bVZ6ZmpIbndFcTNjZHorcHNhRlBZdEkrQnY5TWJnN3JaclZTRnFTdEl3b0c4?=
 =?utf-8?B?T3pnYWtlZUN0Wnc4SFZYVWEyUmpkRjRXV3FHMjdJQjI2d294NkZCS00xamN6?=
 =?utf-8?B?d1pKa1NaTnJ3ay9RU2piV1RZZm1abjZuZTFHRTVKNkNGNDZVOXNGbzloT3By?=
 =?utf-8?B?aUdqb2R0OTBvWkw4Yitodml3TFhJRkNXdDRUZkZTdEEwMHZTRUhmT0hwcTAw?=
 =?utf-8?B?M0xXaTJ0QTdVdG5PS21naGNpNGJqaXh1dis0RGw2ZUxsNTgyMnZCWXRwcUc0?=
 =?utf-8?B?UEQyck5LcW9yZko4TllYS1NPQmp0UTBQYzZkeWdFV1BxalF1MFRoYlN0MkYr?=
 =?utf-8?B?bVNiUUtZWDRiTlV4UUREOFlVT2JZS2RmZVhpK2R0MnVSM1lQa25ZSVlHZFpq?=
 =?utf-8?B?MnhmOU1JTFhONkJBR3I5bjlQZjdJMTFHK2ppK1liM0NXMDVadWxNMVpzdkIr?=
 =?utf-8?B?Q2JYRFAyd2hIQWFPYXVnd2dZTm96b2RscUtNOE91L2Jmejg0QnJldjFBakpQ?=
 =?utf-8?B?M0lESWZsdXZqWk05OVdLajBkZWUxeXVtc2RYSVQrNjF1ajJHcHd4c3ZNakFk?=
 =?utf-8?B?Zzd1eGhzUEJ4eFVyWmtVYnFsbEF2Y1hPRWNCd2tSTDdXc25iQ2o4NEJsOHlL?=
 =?utf-8?B?aFpBWkpQbjY1SHkvbUFwazJDb2lnK2w5aGZwZk82dEVPQUs0SXI2Tkh0aTJJ?=
 =?utf-8?B?QTcreG5WT0k5b2RKSjl6OXd2aHlzQ25oTks3S1ZTaVJndVZJbldaVTJ1QU5K?=
 =?utf-8?B?dVQ5dHQxQXc0c1R1SkRtcjFxYmNsdDRid09Sd3JwUkVybWhQVWZtWVlZYWVz?=
 =?utf-8?B?RjZPVG9sRURDdnY4bksxc0ZUWElwZGNXL3Q1TmkzTW4rR21WT2x5VHNERVBS?=
 =?utf-8?B?Y3Rnc2dDcWpVUlBMVko4Qk04MC9jTW5xTTJoV2QzNnovbjJ1VjZ5TmVVRFZK?=
 =?utf-8?B?UkZiaGtxZWt4c1JCL09VRXNReGkyTU9vaER2RTVMYlVKRW9vUWxZVmpFZHEv?=
 =?utf-8?B?Q01MUDJZU1ZyK1hRdjZ3azVsVmp3Y0NERVU4RW52bm5WM1BEd3FuTEEzOGo0?=
 =?utf-8?B?RERZd2lMK3lkR0hrTGw4SkxKUVJvajBTYlBKQkhJbC9abFc1WHVhWHprSUdj?=
 =?utf-8?B?M1U3ZVhodlNLWmVEczZWS0wzZ01BRW9PcnVDeU9Jb3Q2c1pMcUNEWDdwNWtE?=
 =?utf-8?B?eHk5azBSeWI3TlBGQ2Q4ejBTUXhnYnBzWWJDdHduSjNUdDR5RjJKRU5WY3JR?=
 =?utf-8?B?eTNUZ2dNZ3Y2VmRQM2dsZzgxeE9qdkR6eEdnbFpCZFJSaHkvZ2NEcDU5MzRp?=
 =?utf-8?B?Wm9QL2YydXpxQjU4UHR3NzZobnlDRSszcEp0VXZxbkZDV0VvTUFzNStJTmJC?=
 =?utf-8?B?YTJhdnd3YWU0KytzckpzMEFaNFFYdCtiOUh5WnhlbjZTVHV3TW9rVUgwWkgv?=
 =?utf-8?B?Nk44Uit0ZXNTZFJjQXdPZGw4SEQrbnQvcmx0SUgrNGdpR1FVQ2J5UkMwTVNj?=
 =?utf-8?B?dEcwL0lJQVE2V2dGT0pGQjBNaWJnb2xtZFJmTTZDaEZVS09UdURobUJyQVhm?=
 =?utf-8?Q?HAdG92dOozGBlHsYPmdDOtfh2?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd7a9b57-26b7-4b15-e505-08dbd0cbadc5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB7982.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2023 17:49:01.6459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rGj5bHEZBP6CeEFFhestNAdqKScZxqHm/ix4x/KbYcYRRf0xpp4KhDYtVIMkxbrvCKN42IYjBtHvHaBNnntSwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5251
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/18/2023 1:27 PM, Joao Martins wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> 
> 
> Have the IOVA bitmap exported symbols adhere to the IOMMUFD symbol
> export convention i.e. using the IOMMUFD namespace. In doing so,
> import the namespace in the current users. This means VFIO and the
> vfio-pci drivers that use iova_bitmap_set().
> 
> Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> ---
>   drivers/iommu/iommufd/iova_bitmap.c | 8 ++++----
>   drivers/vfio/pci/mlx5/main.c        | 1 +
>   drivers/vfio/pci/pds/pci_drv.c      | 1 +
>   drivers/vfio/vfio_main.c            | 1 +
>   4 files changed, 7 insertions(+), 4 deletions(-)

Reviewed-by: Brett Creeley <brett.creeley@amd.com>

Thanks,

Brett

> 
> diff --git a/drivers/iommu/iommufd/iova_bitmap.c b/drivers/iommu/iommufd/iova_bitmap.c
> index f54b56388e00..0a92c9eeaf7f 100644
> --- a/drivers/iommu/iommufd/iova_bitmap.c
> +++ b/drivers/iommu/iommufd/iova_bitmap.c
> @@ -268,7 +268,7 @@ struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
>          iova_bitmap_free(bitmap);
>          return ERR_PTR(rc);
>   }
> -EXPORT_SYMBOL_GPL(iova_bitmap_alloc);
> +EXPORT_SYMBOL_NS_GPL(iova_bitmap_alloc, IOMMUFD);
> 
>   /**
>    * iova_bitmap_free() - Frees an IOVA bitmap object
> @@ -290,7 +290,7 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)
> 
>          kfree(bitmap);
>   }
> -EXPORT_SYMBOL_GPL(iova_bitmap_free);
> +EXPORT_SYMBOL_NS_GPL(iova_bitmap_free, IOMMUFD);
> 
>   /*
>    * Returns the remaining bitmap indexes from mapped_total_index to process for
> @@ -389,7 +389,7 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
> 
>          return ret;
>   }
> -EXPORT_SYMBOL_GPL(iova_bitmap_for_each);
> +EXPORT_SYMBOL_NS_GPL(iova_bitmap_for_each, IOMMUFD);
> 
>   /**
>    * iova_bitmap_set() - Records an IOVA range in bitmap
> @@ -423,4 +423,4 @@ void iova_bitmap_set(struct iova_bitmap *bitmap,
>                  cur_bit += nbits;
>          } while (cur_bit <= last_bit);
>   }
> -EXPORT_SYMBOL_GPL(iova_bitmap_set);
> +EXPORT_SYMBOL_NS_GPL(iova_bitmap_set, IOMMUFD);
> diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
> index 42ec574a8622..5cf2b491d15a 100644
> --- a/drivers/vfio/pci/mlx5/main.c
> +++ b/drivers/vfio/pci/mlx5/main.c
> @@ -1376,6 +1376,7 @@ static struct pci_driver mlx5vf_pci_driver = {
> 
>   module_pci_driver(mlx5vf_pci_driver);
> 
> +MODULE_IMPORT_NS(IOMMUFD);
>   MODULE_LICENSE("GPL");
>   MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");
>   MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
> diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
> index ab4b5958e413..dd8c00c895a2 100644
> --- a/drivers/vfio/pci/pds/pci_drv.c
> +++ b/drivers/vfio/pci/pds/pci_drv.c
> @@ -204,6 +204,7 @@ static struct pci_driver pds_vfio_pci_driver = {
> 
>   module_pci_driver(pds_vfio_pci_driver);
> 
> +MODULE_IMPORT_NS(IOMMUFD);
>   MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
>   MODULE_AUTHOR("Brett Creeley <brett.creeley@amd.com>");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 40732e8ed4c6..a96d97da367d 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -1693,6 +1693,7 @@ static void __exit vfio_cleanup(void)
>   module_init(vfio_init);
>   module_exit(vfio_cleanup);
> 
> +MODULE_IMPORT_NS(IOMMUFD);
>   MODULE_VERSION(DRIVER_VERSION);
>   MODULE_LICENSE("GPL v2");
>   MODULE_AUTHOR(DRIVER_AUTHOR);
> --
> 2.17.2
> 
