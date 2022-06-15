Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF38054D243
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347463AbiFOUDt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245041AbiFOUDs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:03:48 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2088.outbound.protection.outlook.com [40.107.223.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CAE73151E;
        Wed, 15 Jun 2022 13:03:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WSc3EtacYzJQivpEdQ34OM+AGK5A5/leZNK34IZ0O/0ukbkJ7oKKZpDJNJ9nj3YTXIWljdIg3fuXRUgHljCTdSUmnTh+iONa/WewzQqdpx+xfYvFGT7fA11zJbyvDJt5p224lAUnXB6MGzKBLsBHJOSQr8YVDHGjg12b5wfTq72o2BNG/D0DkiJM66ZTVZt1W9wLEWxJtlNCFTPQ3Edbc5khmZJMK5+O0hP0hvSj0AIPabcLUnQHpraICT00WwWoRdwot1lyT24C5/VQ2egfKWBM+RO1QrGoC2M9tMvCPaFe9YbZmiwrOFghIRCQ7mBfBGMiT1Yjbz9yOL3dBg+o/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XJrAGvSDIhDRD8r0xgHhs7fmJb72grCxDlexGCvfwmA=;
 b=ZSnwYHUM6TAz0F8rbxbpswgMUOdDfUtm/eXha8RINR+W6s0mxTLqkY/EvuIolf451HbLUStrDFzeddH+C7b0q+Sg8gbk/HxnqJ8TWH5XrRgvi/cD4jBtghY3ZnLQcg72diIehM0GRNNGhKYUNqLrginv2tPwOFs61wRgr6zgyRCTqUi/i3ivgBRrVGy/AB1OQ+OWoHDMAF9s/X0b3hejFRff4VhHHyoC2q25CP6U5u8e16Pe4o8OMzf7VFsfBLIZobrIkZ+Y+8nc2j8HGHVx6JIOsorEIYpACkcXWsUkiygiYdlr7mtmVqlLRwegqbP9MLJon+eu+/ZXRGyPnwoQuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XJrAGvSDIhDRD8r0xgHhs7fmJb72grCxDlexGCvfwmA=;
 b=qWc3Nq4bVpcWVlJWIU6S0nufHqqcBNTDfYp8qhwUSCPpueYA6AfM4/kROcSrnBir3xHdeiKcNtKTrDMPkaRchM59s3536/WMaY185pBbSVkBFUt2BPIu8WxPOLnyZHLU8Hw9dk9faYNvv2eqLDpI41bRk+0UfPzOi5r/zl3e16ue1btvBiabYN4g+CL1Dblga4OMX1Ipi5siWY7yEWBFAIFkOiS/p/LaXA9h1UY1Sdat89TPbvp9GZLPvXMP8M1c/9vlmq89LOMl0g4yk+ITEM3Zuv6fPYxVClg/ZRBjDaTREs2rJgdEAMrsFjK4iwyHfxPyGly7czkIeTS9ad2qxw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by DM4PR12MB6040.namprd12.prod.outlook.com (2603:10b6:8:af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.19; Wed, 15 Jun
 2022 20:03:45 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:03:45 +0000
Message-ID: <fdfd02cf-07be-1cfd-85ca-ae2dbd8a8d84@nvidia.com>
Date:   Thu, 16 Jun 2022 01:33:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 04/13] vfio/mdev: remove mdev_{create,remove}_sysfs_files
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
 <20220614045428.278494-5-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-5-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0008.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:80::15) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cd22beb7-51ae-4115-8190-08da4f0a2712
X-MS-TrafficTypeDiagnostic: DM4PR12MB6040:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB6040639D7056797E00DBD53FDCAD9@DM4PR12MB6040.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J6nO2n6FcBwaZA3gFwI2amom9np4YiFIXJSB8MMGPstLm2yUJG4B11I8Ud187SFZyPjEAixRVS9KELL5u79jvX6HRxb9PexOVIZPmi0EykoIZ8UeVynJXiGKWeTjUj5p6qLglczw6cRzNPpobqYrjzk6kaUcleq+RKOyflGpPydnMh9lNxjq0VyGbxYfNZ2yyel/9VjrKxfssfLhmZbeDmy/Tu2pX11Yrtcb2Y322hT97ksYSsD5AQvkYS1+mF1nrjl4HFPPZLEY9eqNP6papRiXXe/rLAq7EjcfzGFk63xXimUEpopPKnFkdPdAKJbz1/5/b74QM5lG41gXPY7/Pp1Ti80Gs4415/YmDi4++PHonQTnVoJtBjgdBC031m7wQzycA1SnllcVBHQknj7DtuBi6FSVOUGq9nKWTH1UUji/aajops4PsnVeSzGeAcY3b87d5lhtM7nrfhmbClwyUFo57ar/HyP3hX3PMNsZNRnnN5W69aEhoD+V95G59Xk8AkNT1K41SDt5g9jw3snVT9uzEvlK5rqipR3HRb+U+P+ItWIlj9vYIedQLs9xBhAPNa0U+SJuYskoi6sIv8kUZ9jiuMdQWn6lkCqIhfXd9BX8F8GbnXtwGkEVYTYTT0g+2MP7BCQJCfFcC2pDCF6SncAD/N6fRMSuwLg1e3yUIF+XJh4ZLsnfMLTwrazaSs8h9xrXZeh9vMpM3g+Du1SWDH7GY9I66bndtA4dgogQbIY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(36756003)(86362001)(31686004)(8676002)(66476007)(7416002)(5660300002)(4326008)(6486002)(110136005)(66946007)(2906002)(66556008)(508600001)(2616005)(8936002)(26005)(6512007)(38100700002)(316002)(186003)(6506007)(6666004)(53546011)(55236004)(31696002)(107886003)(83380400001)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WjlSL3NNSXEyQno2dml0Q0NXWFJ6TmFzUkFQRkhodklnK3h2a1FTQzl5bW85?=
 =?utf-8?B?c01lUkR3RGxqMThhZzdTR2FuVlVLbDZZdlRpcUVmU0xxL3ZrTWMwSDM4MU9X?=
 =?utf-8?B?aUc0RzhoNFBjQ3hvejZvTjUvT3dvRUFaeHRtMVV5K1Q4UFpMTk1Vc1VsSjJN?=
 =?utf-8?B?SmMwRzVHVFNIWjg2SVhpbnpybWtzUm9lV3k1b0FjZmNwNTFpeVRrN3RrMHpy?=
 =?utf-8?B?WGZWUWJSNGFRQ3J5UGo2NzNzMWQra3hWKy92dTFBemJMc3hQNFhaamhSMUpR?=
 =?utf-8?B?MnpXWkJSekx2dG5hZzR4cUkzRUdmMGp1Q3pPUVNIL09RcUppaGgxbG5oei9V?=
 =?utf-8?B?VDJRYnVETzhwYVlZMFZoZlA4RHJxNjdQMElyaXNxc2I3c2s0VnIwQVdjTUV4?=
 =?utf-8?B?Y1lTQytVQmp0Y0xMZ0lybnc1dStjT1FXK2tVMkRaeVErdm1kdnZlUnRVaWlq?=
 =?utf-8?B?TW1QNGxKU1U5aHVjWFlnRGxINldFUjdkZFJCOFlhNU5qWk5VSW5GZHdXZ3dp?=
 =?utf-8?B?N05zU3pRZTRKU0k5d3FuVjQ3b1dubW9nbE82bXhTS3FHMldnZXdqTmZ1SCtr?=
 =?utf-8?B?dlg0WHFNRUVqdTRiR0VmZU51azdtaTk0V2hZanRYNzdqOHZmOGR6UGpUZHFi?=
 =?utf-8?B?ZHZHVWhFbzJkR3ozWG1NY1pYK2RLa1kwclk3TDhwNmF6TzF5MWRlQ3N3dFF2?=
 =?utf-8?B?WGt2SSthSDNlYllGRytPcWxXSVZQQllHbyt2MU9NNEZaSzhQQXFqQkRqZnl4?=
 =?utf-8?B?dHNhMzFEaU1ta1pMSGd4ZVdha1Rubml0ek8wU21SR3NFNnJ5N2V0OHI1T3hh?=
 =?utf-8?B?OWFmU21vTTFhZGg5ZVYxK2ZWNzJ5aWUwenRlM2l3Z0NQa2ZyTTYwNlBhMnZS?=
 =?utf-8?B?NnU5aW8rN043V1RoSUpkQkJsQjMySUNzeGx1SXpqd3p4LzBqTFpHSXgxV29v?=
 =?utf-8?B?UWhSN2JiMlJWOThFTzArNWFCS205L2lwdnhoZEZBc3ZjSzVyZit6TGtaY3ln?=
 =?utf-8?B?aElhNlpvaXd3UXp4UFJTWUl3N1JTOGhRaFlGU1dOak1VM2E1NWlVTW80cHJ1?=
 =?utf-8?B?cmtaSVEwMkRaOVl1K1JnN0Z1Y3Z0UkRrWnF4NTFFaFMrK1NMeDJydm1aMXV4?=
 =?utf-8?B?OWFUUzFPUTQ1S3Evdy9PMkJoaXYwZkNIZE15Y1JTT0hLY0M4cnF2aHl4YjVL?=
 =?utf-8?B?UjFTOVJoVU1nS0N5N01aMitjajFwYjJhWFJjZnZJK0tRa1lwOEhuVTB2Smwy?=
 =?utf-8?B?U0lOanhhS04rbi9JTDFjS1hWK1k0YkxXUGJMNitzcllyeThzMmlCSDRvU2l0?=
 =?utf-8?B?bStDYU5nZG4ydHhpdzV5bWZFMVVldHBESXR5MXdWRGwyeG1wMDRFejVzVXdx?=
 =?utf-8?B?dmV3VS9IYVUxU3l6SDVRWUN1V040d1k1Qi9Kbmt0UEZocTF3clNJUWp6c296?=
 =?utf-8?B?SzJMOTF5aDZxNkVvZlNIbHNRdklYVWpvVXFNanpKSjMwSTlsQ1pyK0JKVUJz?=
 =?utf-8?B?WEtidjhuUmFnMHZUT0V2cVJaTXZoeU5jSjI4R3lwdmZUQngzbjFwRjVPYlVr?=
 =?utf-8?B?OTBTWWZXakJlOWV0b1FSVDgzMlI1cXdRT0VRRS9BUERCdThSNzFFT0JXM0dx?=
 =?utf-8?B?TkxoL01UdGZmOU9BYlljdVBacnhRYUJQRVUwRG5aT2t2YkdBbi9lSW9JdFRQ?=
 =?utf-8?B?N3pTRXllaktkQ29xcktkc0l4b2RabmhFSWcybGlnYitvWlMzbEI3ZC81Sm1O?=
 =?utf-8?B?cklQeTVtRGJkdElleUpSOEpWV0UwWE9HUjkzUy9ST2VEN0N0bVVKMlJoTk91?=
 =?utf-8?B?Q1dKM3VzcWdOT1h2aWJJdkoyTWNGYTFLaUJCVTJtL3pRWFpvZEt3YVdyRjBF?=
 =?utf-8?B?ZGZaUGtOUklPSSsvRUN6S05SdGZHT2kyUkJHT0NIUXdjSnhDeUVnQ21ob3FT?=
 =?utf-8?B?cjhCb1VtM0F6ZzFwRXZQQ044b2xVcUZrdFJ0ckR4UEhEbEU1ZUVrUkx3Mko0?=
 =?utf-8?B?UUwwWGM3Q2M2NmdML2V0akt5eHlSdnhMOTRqMXAxdUtMcklhYUtBbHVLN2FP?=
 =?utf-8?B?QjBEejJNWnVhOCtvWlgvVFVvUlJUV3VVLzBBUHBVeTZLMHVqK3lTOEtZUzd2?=
 =?utf-8?B?U2doVkpCQzA4djNDSXdiaml0a2dzbDRxbDVyeDF1TWt6bVZNVnByUXFuTkp2?=
 =?utf-8?B?TjFLRmg3SkdBUlJDRkNIMVVhVHpJdGIyYi9Ld0h5ekFCb1JpRXN2cXc1Ylc4?=
 =?utf-8?B?WmR0TUFXSUNNNWZ6ZnVlR0ZOcVI3Z1E1Lys0eHJ1L05EL0ZLcDFHeEUrOEZh?=
 =?utf-8?B?MGx6L1VYckZrSUs3QUJTSHE1dlViN0V2TDdHTmc2bFdGeDM1czU0QT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd22beb7-51ae-4115-8190-08da4f0a2712
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:03:45.3418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyU8rzkMK8qCK1NQgSN8WLUgqJo7CQjz5KOtFfqCOzJRQbO4vd0ARii2K8aPemT8jb6JB/WQh1RzsBTr47AACw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6040
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


Does this change really required? When mdev was implemented we tried to 
keep all sysfs related stuff in mdev_sysfs.c file and I would still like 
to stick to that approach.

Thanks.
Kirti

On 6/14/2022 10:24 AM, Christoph Hellwig wrote:
> Just fold these two trivial helpers into their only callers.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   drivers/vfio/mdev/mdev_core.c    | 12 ++++++++++--
>   drivers/vfio/mdev/mdev_private.h |  3 ---
>   drivers/vfio/mdev/mdev_sysfs.c   | 28 ----------------------------
>   3 files changed, 10 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 71c7f4e521a74..fe4230b21993d 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -44,7 +44,8 @@ static void mdev_device_remove_common(struct mdev_device *mdev)
>   {
>   	struct mdev_parent *parent = mdev->type->parent;
>   
> -	mdev_remove_sysfs_files(mdev);
> +	sysfs_remove_link(&mdev->dev.kobj, "mdev_type");
> +	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev->dev));
>   	device_del(&mdev->dev);
>   	lockdep_assert_held(&parent->unreg_sem);
>   	/* Balances with device_initialize() */
> @@ -212,16 +213,23 @@ int mdev_device_create(struct mdev_type *type, const guid_t *uuid)
>   	if (ret)
>   		goto out_del;
>   
> -	ret = mdev_create_sysfs_files(mdev);
> +	ret = sysfs_create_link(type->devices_kobj, &mdev->dev.kobj,
> +				dev_name(&mdev->dev));
>   	if (ret)
>   		goto out_del;
>   
> +	ret = sysfs_create_link(&mdev->dev.kobj, &type->kobj, "mdev_type");
> +	if (ret)
> +		goto out_remove_type_link;
> +
>   	mdev->active = true;
>   	dev_dbg(&mdev->dev, "MDEV: created\n");
>   	up_read(&parent->unreg_sem);
>   
>   	return 0;
>   
> +out_remove_type_link:
> +	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev->dev));
>   out_del:
>   	device_del(&mdev->dev);
>   out_unlock:
> diff --git a/drivers/vfio/mdev/mdev_private.h b/drivers/vfio/mdev/mdev_private.h
> index 6980f504018f3..346b9ec320466 100644
> --- a/drivers/vfio/mdev/mdev_private.h
> +++ b/drivers/vfio/mdev/mdev_private.h
> @@ -20,9 +20,6 @@ extern const struct attribute_group *mdev_device_groups[];
>   #define to_mdev_type(_kobj)		\
>   	container_of(_kobj, struct mdev_type, kobj)
>   
> -int  mdev_create_sysfs_files(struct mdev_device *mdev);
> -void mdev_remove_sysfs_files(struct mdev_device *mdev);
> -
>   int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type);
>   void mdev_type_remove(struct mdev_type *type);
>   
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index 09745e8e120f9..dd81b91afcf7d 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -170,31 +170,3 @@ const struct attribute_group *mdev_device_groups[] = {
>   	&mdev_device_group,
>   	NULL
>   };
> -
> -int mdev_create_sysfs_files(struct mdev_device *mdev)
> -{
> -	struct mdev_type *type = mdev->type;
> -	struct kobject *kobj = &mdev->dev.kobj;
> -	int ret;
> -
> -	ret = sysfs_create_link(type->devices_kobj, kobj, dev_name(&mdev->dev));
> -	if (ret)
> -		return ret;
> -
> -	ret = sysfs_create_link(kobj, &type->kobj, "mdev_type");
> -	if (ret)
> -		goto type_link_failed;
> -	return ret;
> -
> -type_link_failed:
> -	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev->dev));
> -	return ret;
> -}
> -
> -void mdev_remove_sysfs_files(struct mdev_device *mdev)
> -{
> -	struct kobject *kobj = &mdev->dev.kobj;
> -
> -	sysfs_remove_link(kobj, "mdev_type");
> -	sysfs_remove_link(mdev->type->devices_kobj, dev_name(&mdev->dev));
> -}
