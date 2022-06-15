Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9DE54D260
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347704AbiFOUNu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:13:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346198AbiFOUNt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:13:49 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2076.outbound.protection.outlook.com [40.107.236.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16B33EB96;
        Wed, 15 Jun 2022 13:13:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AmLlHzmboChI49zqQfFEFKrygYAY+t4xndPLwCUPR0vrL/1XyiRw5CRtG5AXlNvf+968AQ61z2LNy0x7WJtADEjTWRbqrWLcI6gYfPwvG5KDmyjAMMdh6KH5OdwomSqVEDMgcmGtNs05HuuHKeDR+wqC/GkuU203V73iLCG/fkwbx48n0po1kP2ENGUQfqjM+3brtqSroCS8EGVqGWC40kxa/lwhUxib4EaI6umj8THoKWbEzrpdeVBj4Kv620UjnHtDx8PCmSDTdtTnVlwivADi4yNwMoJaTlLqp0M85JhPvpaSNxs44JmITwy9TDBwew/HJVXcVK1uwApZogiSLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFF2Fh4jw6G9Xaihcl8Hx9DqDkeD/fvARhEn0PkJxoM=;
 b=Y1WvQFCL/Vkh1vdupCtF0AC8rPq5RnWVGsk3uv4Xfkt6llVD8Uag4p7niqV7tdJljTMjeUkSHj+AeRx5x5KZYDDoIodUdWZKBkCjK3TraFJ9fWvw5nRL+xCnYv2TQzWsOKvtsKC4EPydyOyTemsBZwiWvNfw/6ndGcD29uSQL7o/d6NkDcrYzwix76E0SFz77B+4cHG33m2pEQH7JREx66Sts0Dk8e1m6JZF8q/7mr3dAt8xBOquofaeWyyKq9mlxGh4Gu1RhFVbKP4fO/Zql0vLhRv5ba88MemAQabVJXlntgSA1pWIsahLBytgJh5VRRdsYuYHNMT5pQc64Gjq7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFF2Fh4jw6G9Xaihcl8Hx9DqDkeD/fvARhEn0PkJxoM=;
 b=kjzQbJ85zOMF1c9zwwvmm8SOEs9EurQBH6PyYA8fR+EdBZauyQNPk+d8vLnEtxK0Mbi1XIMvnhIZh3sdqlgiYoiRFXiz5y75jTg+f9tH6c/UxxPY/gI691TrJ3RbnyqqHvcCjUT61hGi0UOfK8XyJXGvzsOedQaVZwNqd+CGIA7XaUwtbCexRw2/e+EiL9bsViTC8jC3wV0hCt7QnjhJmc8qSRR0V6FXLMYwJrw7wreuLL4/NuftLoO3jaPZKilUb8pZ+o4o15pixSLouSDSfqqnSsQVGgOJOfKPF91M1np8bGTPlRnwlHKsgNaYDuoYdC/A/IwW9aerfteF79IB5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by CY4PR12MB1128.namprd12.prod.outlook.com (2603:10b6:903:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Wed, 15 Jun
 2022 20:13:45 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:13:45 +0000
Message-ID: <fe7726bb-ade6-2c27-62a0-78f0bad72a1f@nvidia.com>
Date:   Thu, 16 Jun 2022 01:43:25 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 08/13] vfio/mdev: remove mtype_get_parent_dev
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
 <20220614045428.278494-9-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0041.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:81::15) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: faa23bc0-97ca-4d4c-b314-08da4f0b8c8e
X-MS-TrafficTypeDiagnostic: CY4PR12MB1128:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1128B46F5D6E975E5F0E06DCDCAD9@CY4PR12MB1128.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pI9wTbgMRRLXPOYcAcDfsVn+KEQ5NNWJv52dUyyppbOIuDukEIo7P78t5qg90NbHIa47s1C+cqaaH3VU0xfj7AobYDLaMPe5HwR/Ro5kyoIGR4cKHmUKftxQBK9uLk31z6DUVzXMZfHeyafMxP6pw6/fA+R7FJcYp2HBp0dH0BQW4hcsOg5bEq6kpPVSXgPFE8C1HmPc010AiJOGPASjfViMuGacLxvCDB5njjO2WICvnj5ALHuBGPYI8sCOkoZRpdQmrKiffMBbCBpVmfdf6QVEq7PT3ufZ7D+AZrLZDA/4Jfs8YEhykdSmcGqig0XxPYHeVhH9y+9+E88MkuZKUIeFXcKw3B6qnMRS38X7H/nJGBkxEQB0SiHtPGysWAciw7bFKsFmWKPhVdpjqA0MdPpco9vgYQqCoqg6ouPvpO+WLp/leuqhj9lhu/iHlv8D/t4crSvzP5Uj5iFcimoBAtU7lzJ4u6+3s38X73XxVSs7XGUwakhxI0JVAvuc8yYxQGOEJoKuhgr+qmD4BxC0vbbPOMVuxrtGaZQ7JwGLbZPK1x//VgQSVA3sAhJeMHIRtki7rpYmie71FGVBFTv5H+allKwggDKIQwUfe5u8X2YKdMaWL47bDNyKBUQXLWVElLD5TvA2p7bPjKs0MODS7MxhgmZZFrI2ftGN3ygzBbLaa5h6ilTUNHqjaYLDXDBUD38QxgTosmquDE3GyAVmzNwvk3xgSaM2PifHqcz1oZs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(7416002)(5660300002)(66946007)(66556008)(36756003)(86362001)(31696002)(186003)(8676002)(83380400001)(110136005)(316002)(4326008)(66476007)(31686004)(2906002)(8936002)(6486002)(508600001)(6512007)(55236004)(2616005)(6666004)(26005)(53546011)(38100700002)(54906003)(107886003)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?amR5UGk2aCtNTisxUnYwaGkyRjdxRTFoTHFSZ1grNTk5Skl6Rkl4MHREQWs4?=
 =?utf-8?B?WU1uWXB4cXg1cnorZWNmQ2xwSHZZRnRoazV3aTh5Sk45Rm9qMjVodmw3VUxx?=
 =?utf-8?B?enFrUlM2aFZ0amxEV2RtcWZvZ1o2OFZrek1ZdzVBV21TUFo3ak1yOFhHeW9l?=
 =?utf-8?B?VCsxVGFMVlRmZzl6d3dWaU41UHlTOEJmQUZRZlZUcm9Qc1dhblFXWWxlME4w?=
 =?utf-8?B?QTJiVDB3L0srSytkOG12N1RqSFB3bCtpN2ZJUGo0Nkx1c0p6QWhCL3NyNjMz?=
 =?utf-8?B?VEwvNWRSSXI1bUVqVlVLMXBoNllSbGFxRTBqQzZxZWhnRzZlMTZrR2F2OGZp?=
 =?utf-8?B?em5POU44cTRYYmFnTGFEaEpQbHNaRHBhOEMzYTY2VjJONlRScjg4Y25LWDMy?=
 =?utf-8?B?WUk0SGxjdEVKS0IwSThsNG50cjNQVGphbmdqNDJvdS9HOSs0R2VJcTk3cXZV?=
 =?utf-8?B?WDhMbklwaEJ4WlBGOG1TZVZxa2I1Wm1mVWlsbGJ6ZmZ6eW9oM0RpVDNEalAv?=
 =?utf-8?B?RThHeWVpNnZjVkllSU9SK2dTbS9ZQUcyZXdzNXQ4a2t5KzZRTSs2Tno1TTNH?=
 =?utf-8?B?U3FmQzUxczYvT2Nqb3VYakxGTDk2RE5qNlVNQjFrbnMvL1RYQmVJTGp4WFox?=
 =?utf-8?B?dW9SbjVvc2NIa0ZSVjllSWNZYUQ2VlROT3ozeWxRSitHRUd5Yzk2aklmVW5J?=
 =?utf-8?B?Z1prOTJjYjdxcjNsOTVGUUpJdE0vY1FJQVJ1ejgrbG16NEpvNnd4YXU0TDVa?=
 =?utf-8?B?YVMyRFVUekhNYU9ocllSNnU3Y0JMdnZXVTFvZ21zQlAxQ1N6Sy9hU0VrM3A5?=
 =?utf-8?B?UDhYVTc3NXViYTFKZUJJcmpWSXYrbzlwd0xlUHlZN1RqbG5RVXhuN2FVVDBN?=
 =?utf-8?B?YmcwaEdQb3BHUkJsU29BRFJXc3lWc09wSjcvMmNlWk53SjhjbmR0aFV5aXhv?=
 =?utf-8?B?MTR3cHMvM0xzZmxISWpBTnNvbUM1UjJqUEJZRko1QWhrVCtuQm1SY0MrYmRw?=
 =?utf-8?B?NDhDYWlmZFF6RmdKb1ZFMXR6bGhsMDJ3OWFKUHUvOHBKaE1NdFd4Rk1PQ3gr?=
 =?utf-8?B?UmpPbnErai8yUE9DMjlsUVMxOS8yMm1XYlBBeGZ4TTNTdWtIdWxXcTFnVFY2?=
 =?utf-8?B?VTA4SURSYTVVZERQeHhDZFlpc3hJMWRrTk5YYzcyaUhDN05pNDg1RjZVU1lu?=
 =?utf-8?B?VmRBeG5zbnRZcTFjNGhJeHFOWEFWSXFJdmNtWFBSb0JYMlluTDdod3RWd2R1?=
 =?utf-8?B?ci9PNFJFK0hFZ05neXdXa0hDd0xHMURQOWgzclhVL251Q21uVkN1NVNwUE5i?=
 =?utf-8?B?cDBvK056dFVuT0hyM05wZXpwOXJ0RktzdTNiSTJVcktnZ2d2aWlndFkrQXJE?=
 =?utf-8?B?aXh4SkNmR1NIWDZMMW1mWTlKU3kwV2o5TVlKbzd0bXJXTDByTHErL3B3RnJD?=
 =?utf-8?B?WWVNSVRkYnRXK3dmRjZnTlFtOExHR2F1WWo1elk1VWtRYVdkN3dTNzlMZ1p4?=
 =?utf-8?B?NlpOaTRvOWZETWZJWUEwY3c4OGxoQUxnNTJ3TmVCSWZRYzdYVXUvT1JqNzMx?=
 =?utf-8?B?ZktWR01iaHdBYzV5dDVvU1UzSElMT296V3pGc2lrL3hkakZmTnQ4bnh1akJq?=
 =?utf-8?B?L1M5Tm1Sbk1Ga2QwbU5QNndmZFM4Tm0xamNNbXdVMTVWMHZ6M0FVVGtGZzFa?=
 =?utf-8?B?R1VWbnl1ZktkZ3lOcDVPUFlGaHdObVhkZFlPNVpNUmlIR3ZXYkxoUkVueCt1?=
 =?utf-8?B?RWhjbHl5TFJTQmFPbzU4WnRYNGlyd0E0SVYzOVJUWHFzVjVTb09kOGpaWXo1?=
 =?utf-8?B?LzB3a3gyTTZxc2twd281S25pdDcxbStMcm4xZ2E5ZWFxVFN1MjFwQ0JmQ3p1?=
 =?utf-8?B?eEVhMGNXcWU0WXBPazdnR2VONmN2YktCUnlOWjF1TkFWOCtNY3FDU2ZzZ09k?=
 =?utf-8?B?U3I4WitoaUdrWldhTW94Rk5uYWlSZXJOSHJTU2dKYXRMZUR3UkkxZC8rWVkz?=
 =?utf-8?B?K1BUZkQ2RHlBNkdLVjBNcHVZTm1ybFdDOHdVUm9pbHVpcjdNQ2o1WmUyMFlt?=
 =?utf-8?B?eUZnTjJzVDVYSFhnMytwMDM2SDZUczRaQXYwcVEzS3VicHgvZE9iWnF2M3Vp?=
 =?utf-8?B?NmNZcWJuVENWeWVwWjNMYkY1dXl3QnhKU1QwdXRMVER0UUl3UDBWam43YTdT?=
 =?utf-8?B?MHhTTEVrdWtiUHhGeXE2am9QbmsrdDIyVElBK042VldmSkEySDc1aVJZZlVh?=
 =?utf-8?B?b2oza3A5VHc1dk83ZEpTczZlZ3lFaWZWTGRIUVcyd0VnQXBjZk9LMWp4NEM2?=
 =?utf-8?B?Z0dGRElZcnY4dlJDOEwvei9BaFR1SGpLMXQ0cjJscEw3V21BVnQ2NWRNOWhq?=
 =?utf-8?Q?wbcw+5CIx4280yT8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: faa23bc0-97ca-4d4c-b314-08da4f0b8c8e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:13:45.0711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JfJxNiYVGOx5//yKa9iQLWhp6iYWLX5gqWeDZOzoW6Kj3qP8c/991q47si0VdniG1R6gxK0bPYQ07BUvlFuUDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1128
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
> Just open code the dereferences in the only user.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

> ---
>   drivers/s390/cio/vfio_ccw_ops.c |  3 +--
>   drivers/vfio/mdev/mdev_core.c   | 10 ----------
>   include/linux/mdev.h            |  2 --
>   3 files changed, 1 insertion(+), 14 deletions(-)
> 
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 25b8d42a522ac..43d53736dfe3c 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -88,8 +88,7 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
>   {
> -	struct vfio_ccw_private *private =
> -		dev_get_drvdata(mtype_get_parent_dev(mtype));
> +	struct vfio_ccw_private *private = dev_get_drvdata(mtype->parent->dev);
>   
>   	return sprintf(buf, "%d\n", atomic_read(&private->avail));
>   }
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 479ae5ed6c392..20513b7f6b5eb 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -23,16 +23,6 @@ static struct class_compat *mdev_bus_compat_class;
>   static LIST_HEAD(mdev_list);
>   static DEFINE_MUTEX(mdev_list_lock);
>   
> -/*
> - * Used in mdev_type_attribute sysfs functions to return the parent struct
> - * device
> - */
> -struct device *mtype_get_parent_dev(struct mdev_type *mtype)
> -{
> -	return mtype->parent->dev;
> -}
> -EXPORT_SYMBOL(mtype_get_parent_dev);
> -
>   /* Caller must hold parent unreg_sem read or write lock */
>   static void mdev_device_remove_common(struct mdev_device *mdev)
>   {
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index 83c85a0247f25..ecf964d34f2ca 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -51,8 +51,6 @@ static inline struct mdev_device *to_mdev_device(struct device *dev)
>   	return container_of(dev, struct mdev_device, dev);
>   }
>   
> -struct device *mtype_get_parent_dev(struct mdev_type *mtype);
> -
>   /* interface for exporting mdev supported type attributes */
>   struct mdev_type_attribute {
>   	struct attribute attr;
