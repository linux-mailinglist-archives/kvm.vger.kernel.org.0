Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF7FE54D24E
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343917AbiFOUIj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346046AbiFOUIZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:08:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58B94990E;
        Wed, 15 Jun 2022 13:08:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wd9wHpbO6SPF3K8JoW5xy66juHW20tY+HGuieRqLmA+/nY8SMy6Mlh3QZkTrVbGTRJHFtr7p4KIKqb4zs1ApaL++nmNgA6U+VSu3FWYibLZfNZJWxp4Tt3bjOnCdgPHQPlL43mkD1i37ORvJc6WU0EvlVzU94FXHQLf90qz/ffH/gw7SUY1Vx4Hzt2gbyOWmY7jpoijqxG0ZtwMJDHRGwjRwHgEJqvkuIRJJYeby2AAOsHHgxRsoJSkELNt6kfSYO5iHoan/FuMPTl7J+TOw/GAeIfBq/O6g5dgI7VLpim39ODWDqG0ENN65EDPe7Mr0RK35jhxG0Bbf99zZlxJSxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Av7qepXznQN7/S7crS8exCPhX4AibySqs4Agzu3Z80A=;
 b=N7HJoPjUIsd0VKuBHQA8vcyzZFKl5IFImQSFWCWhP8gEjC54Tw8HHAoGx6vS1W5qLJ5rlBe+SNWf2BtYkoW0NYT4Ym2ubj5MVMjqm/vVO51siWvx2fRL25/pWFwWU7E7O0ExjJmp4VKd7KwVhdxo5Xg1bar+2XDOo3MAx3c6D0OgGL3Zc+NUPlIsrY0VcTbzmT8Z4rr5Ix6TfHlNaOtM7TbsSeCe+JLk63QhRMOyxqoBb1g41mN/si4epa+qY/2g9VK+RLLxTyUKCiwCb0jSygp1C7VFYzaRbxqCsOroWZZwc10QrEwpOsFj4twCVmqRO1D4MkYUOWBHwxoXxgkiNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Av7qepXznQN7/S7crS8exCPhX4AibySqs4Agzu3Z80A=;
 b=hvxKHO+YIlXfW7gLXgL5CvqE/LfrGthgJdfXh4Th32qxxiTwO9Bhw/fuhTXdca5z+TBKFbs1/s63DJEaO1dwKWO2iyEMV5tvkaBuI+sesvxS2T2/JzifCZHCstcD4g4DZwqSuvHLlR3x/7vSkgYk9x7LbUbCD6syAKzw1FcpBMAQpzMCKG4KwX6Eeo6qKEVzM7FyBk/m7fOEAmbHvQZv+++nV7+oLfc4tertD8+YWOPoR+cgpQssmVogmPR2OQaFPbDj90/9g8S2Hf+qdW2bOTCoOuQu4j5HLhxWQ8mYZ5SL3C5wmBziLbw3jk9sgP/dlFdLwh7AFbHeI1cCVu1XDA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by DM6PR12MB4617.namprd12.prod.outlook.com (2603:10b6:5:35::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.13; Wed, 15 Jun
 2022 20:08:23 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:08:23 +0000
Message-ID: <93a73ca7-616b-631c-c444-aa032ea372f5@nvidia.com>
Date:   Thu, 16 Jun 2022 01:38:08 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 06/13] vfio/mdev: unexport mdev_bus_type
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Kevin Tian <kevin.tian@intel.com>, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-7-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-7-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0058.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::20) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86a0eb96-de75-405f-4290-08da4f0acc99
X-MS-TrafficTypeDiagnostic: DM6PR12MB4617:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB46175C2442962FB198B764AFDCAD9@DM6PR12MB4617.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SFSaioLI7/denx09k4zXU09z9bOB3CpqT1qSHSFwD2WVy+DkDQp6n/2TTnUZ350cV/F0cBsfrfIAW3AJVBeQ9BlqNnHmr1N8b0aZmC3KRlDfXB9M7W/PRF6O7fptJYKvbbyRsce4C9jdFspcFbssyeuxBQI1yVO/33n2Uv5562Mg8Q10tqWlIkSihtXzVp6bZQ6X0zoRaZW0y3PUsulS3pxszCeyOJewkdTTBlj0H9zY7sxvQfCBbvlSaD6Dgy3MtXpMx23RHii7QsV/5OQOXSP1zLIZ9yhmNw91DeqDmgqmr9PON2lsDrtHtAuiy1GKxjEvKsyBI7/2c2fAatMAE0oaT4KoKuiIW17R2gtY3MW3q6p7RUOC0Xj2gq0C0TIVEOdvk1DFulZRZqC7oFAzvIVj++e2bv6T43Rv/XKG0OfXl4twTDTdDdcCZ6FoXv3wGQSAdcmE6xN5VS022juWuMxAinFQA4F/8sz6J4pt7KdFZRDKlS1oHWCSApE8of/efSphMiS7Wrab0CUdUG5HOQQmfe2alpHplOxvWShGwxha9ED3OuSsAQ3Rh4Bif6G1icT2p4ObBVOT6eFYCWCvMgwRRyHtBf08yWfVfz6M+ssm/fb8Lc21ejhboOKdzD/mjFkOqgHzh6WY8qifPsdqW1hLEg+40TQr1ZtoEhmA3hRBIn2qpbwiCA/HRgsFBuCUicNfgbnzF7Gi8QFHJor9mPwnQJVxrdHsStxAaINbo5U=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(38100700002)(2616005)(36756003)(54906003)(316002)(186003)(107886003)(31686004)(83380400001)(2906002)(508600001)(8936002)(7416002)(26005)(66946007)(66476007)(66556008)(8676002)(6486002)(6666004)(4326008)(55236004)(6506007)(31696002)(53546011)(110136005)(5660300002)(86362001)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dWhZT0ZjTFVmVVovN2d6cUJMMXVwQ3dudWZUTmZsWTNocGx3cjQ2d3I0MGN0?=
 =?utf-8?B?Sk9vWmhVVFFNVStJUzVhOXlydElJNTM1RUx1Qjk5NTNrL2FvMk1FZFZnZ2Ur?=
 =?utf-8?B?NGtjcjJ1VUllL0Fia3NnNFVkU0tXd0l2TWhXR3RndnZSYXIzc2xyWDNZTE1h?=
 =?utf-8?B?RmpWTFhFa2dabEcwMWg4M1o0S05IMXJ3cTI5c09ob0wwbzdRdEhCSTFHSXRI?=
 =?utf-8?B?YzZhcjFnZGtZL29FMCtDSGNyVUJYcDZxcjYzbDlPRUo3aVl1UWtoNDZkR3ha?=
 =?utf-8?B?aEtFZFlXVzZpT2VVL1ZzUHpFZ3lzdzR5U29uNFVXbEhtUlRvSWtRTS9OZTM3?=
 =?utf-8?B?Uld6MjBRMHZ4WUt2dkpKNnFWM2V4YWxObEsvakJrT0wxRmQ4ek56M1FvNUk5?=
 =?utf-8?B?ZEdzR3VsYXU2dVk4Q2lQWjZsNXhKL29YbmV5elhucXdpUFRIUXNoNUdqL2lN?=
 =?utf-8?B?RlhBcjUzWi9EYTUrL01GT2VBTGYvNWx0bmZoVy85bFR0ek9CZnVKS3kvMzla?=
 =?utf-8?B?aGR1VFBMMUZHTi90dk5sRVRuK0Qrd0UrcjVMWnE4VWRjZjFsRTZjSysvZWxC?=
 =?utf-8?B?U2JzU25CdEpocm9iKzV6MnM5RG91NVlTZU1ORU12eEhNOGJZY3RxSmgvVU1D?=
 =?utf-8?B?Qnp4ZlNsdGVZQWFaK3ZGU1k3REtZdGdzcExXTW10blM1cEVNdWQ4cmQ3Sjhn?=
 =?utf-8?B?UnY1YjA1eHBFSWN5VzQ5a1NLeldKVVJMeFVnRHdCZVBxRzU3WTcrd2dLSTZU?=
 =?utf-8?B?di9rOEQ3NFJ4T3RrN1gvQmg1MFRpbXZuU2pJRVc2YVM5am1yY1puUjFXcDc1?=
 =?utf-8?B?eXBnVGhkZG0xTmVDam14TStGMkxnUzhKdkpqdDl5TmFiMGJkT2FpRW1ZbTQv?=
 =?utf-8?B?N0cvZzY4WmxDZ3NheFU0YzdZSGlROU9sQy9HTmhOSlUyTE5neFk0SmhkemlP?=
 =?utf-8?B?Z3k3Q2hHbXhQL2UrbTZLRENRQnRzc1F3bStJSExaaTEySm11NFpMdjRFTFBE?=
 =?utf-8?B?MTlyTlVtQ2xwZllrRHdZSEs0Ky92cjZod2M5U0llTVpUekQ0eFdQbXIzRU95?=
 =?utf-8?B?akV3QTRicTQxR0hlUWRZYm5tR1ZaU2pLSkgrbU1LOC93Q0lKd1grU1RwT1ln?=
 =?utf-8?B?RDhoemk1VERNVWFISjBPeGk1bVhJSGtXZzM5OHFNY2RDeGpnWDg2dDVxYmNE?=
 =?utf-8?B?N0hZNGtaalR2WHVrQU9OQTZFZWRCcUNaL0tnK1pVUEJHMWhVc1FMOHJZT1E0?=
 =?utf-8?B?WTlYckV6cDRrRnkzdG1SN2tzK3FOSkpNODRxRnJaUklTbGpTN05ULzRJWUkv?=
 =?utf-8?B?Zk1MWWw0WXN3MURVTnlBWmgzY2FkNkljNWxtUzU1dndHWkc5WDBVVWZPTGJa?=
 =?utf-8?B?YUd2MTlrdklwdWFxUjZnbHF4YkdlYWQwTmk3VVpReEhldmFmQ3FwS1pJZVBh?=
 =?utf-8?B?Mnl2TGxzVndPeGJVMjJzQURNWXplcmFYRFFKQnpmbW9tTVlROXplOFMyeGlG?=
 =?utf-8?B?akFUbDd3UHZ1Nld1eXd4K25EWWNtNVBxcXB2UEM5bk5sYjcrY09zK1hiSllt?=
 =?utf-8?B?VlhNZUJLTEswMUVXWXE4RTNiOEVpTzFvS2prdUlsaXV3VnNGRkp2enozUmZS?=
 =?utf-8?B?UnlZcjUxY0cvK21WRllWT1lvb01yY1dMMTBNc0JqT01qQ2Z2UUVhTUJFSkFh?=
 =?utf-8?B?T3c5OW5ZdGlrVjFxMDE5QkNjd2MycVkxdUI1T29PamJ6RW1HQ2pxTUJ0K0FL?=
 =?utf-8?B?dVc2elJnL0hUT1JydEZhOTVLK1J0Nk85RFRLTHA1d1BXeXhRYWpYNFBPdkc2?=
 =?utf-8?B?L2JIWFpmKzNIY3lpZmtpcVNWbWtRUHI2Y2Q0R2k2QmxrOXJPcG50UGJzVUNt?=
 =?utf-8?B?OTJha0lEbjJmaThUWkQ0VEwyWmRxT2pCUXF2SjRoSktjUDNQRExSemdrdE5p?=
 =?utf-8?B?STg1dGtzdFkrbjB2a2V6dlhITVlOYXNqRklZUHUvOTRpMWVEVWh3ZCtLUUh1?=
 =?utf-8?B?NVFuUFcweWJndTNNRDhYaEUzRmxRTVJHNnZET0lzTTdvOUVVSnlrSDRrSVgw?=
 =?utf-8?B?VEl2bDFVRlFnQ00wYk50L2ZBa1ZXbEVRcHg5MjdnSFoxWnVBQ044RXhxUkw3?=
 =?utf-8?B?Y1RJaFhUOEFsSWp6cXJQMlR5Z2JzSFdVcEZqWGtrTjlCZlkxeGZ1MmpMNmFo?=
 =?utf-8?B?djAvZ2JVWGZ2TkdEZlk0L09BTCtqcjhST0hkekZQN2dUc3cwL1dXOTREcURz?=
 =?utf-8?B?QmM4bFEvQU5hVEJiMUJBM3F5MS9aV3g5d0gzS0NGbTZINnJrV2V2ZHlEckt6?=
 =?utf-8?B?RmRjZjV6MW1HZmFCOS9BL00zNHN5SmxnVjhSVFpTYmgvYzJTbElkZz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a0eb96-de75-405f-4290-08da4f0acc99
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:08:23.0802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a+3REphepA7EevqE2rQ+oZJ52YByHicueb9XQoWXEdOAyB4u7qpqUpWHdwbHlyaB4YAk32ZvWDUY0hWOdHNg1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4617
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/14/2022 10:24 AM, Christoph Hellwig wrote:
> mdev_bus_type is only used in mdev.ko now, so unexport it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>


> ---
>   drivers/vfio/mdev/mdev_driver.c  | 1 -
>   drivers/vfio/mdev/mdev_private.h | 1 +
>   include/linux/mdev.h             | 2 --
>   3 files changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
> index 1da1ecf76a0d5..5b3c94f4fb13d 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -46,7 +46,6 @@ struct bus_type mdev_bus_type = {
>   	.remove		= mdev_remove,
>   	.match		= mdev_match,
>   };
> -EXPORT_SYMBOL_GPL(mdev_bus_type);
>   
>   /**
>    * mdev_register_driver - register a new MDEV driver
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 346b9ec320466..62a98b78d929d 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -13,6 +13,7 @@
>   int  mdev_bus_register(void);
>   void mdev_bus_unregister(void);
>   
> +extern struct bus_type mdev_bus_type;
>   extern const struct attribute_group *mdev_device_groups[];
>   
>   #define to_mdev_type_attr(_attr)	\
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 409e86d343a05..dd11c142bf887 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -92,8 +92,6 @@ static inline const guid_t *mdev_uuid(struct mdev_device *mdev)
>   	return &mdev->uuid;
>   }
>   
> -extern struct bus_type mdev_bus_type;
> -
>   int mdev_register_parent(struct mdev_parent *parent, struct device *dev,
>   		struct mdev_driver *mdev_driver, struct mdev_type **types,
>   		unsigned int nr_types);
