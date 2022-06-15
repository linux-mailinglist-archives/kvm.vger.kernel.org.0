Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB90554D258
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346484AbiFOUL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238164AbiFOULZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:11:25 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2056.outbound.protection.outlook.com [40.107.236.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD34F4A90D;
        Wed, 15 Jun 2022 13:11:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FAjAQt9FdZD6UbjwJiLPYJL7if6qKhE+pUrSjARd8bp35VuNOQJr/EszOzahr2Mzr848LEBU00hg9GwZ1UafPKOyPALowOgq34dWuN6VrwXHI32UPP9Vqow7dI4+y3REdLP9vC0J+7DDAKetkHfMQ4gK8bYgDpbgUoOtExpvecPVTeoPWWp0FRuvdUiO+W61e31L/Hux+Gzbo4DgkXtm2TXGDoLH+ZUAMuatFpTnDIVkIi4ukRGaBRTNGNUYOd2ECdCg5G7yIO2xWzldatZt18AbsFLADHtGC2jBS2WxtKl0N54gcO6iFJ4dwdfOSjVmhT2/7lGaDJO4Con367nfVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r5X43oL8O5acZIn1H0a7wM/XLdWBxtDROeJJm0x62kM=;
 b=AbdMaLr5qpOjrAz2Z1cZE+v223TmLgrDixbL/aGQETP/awtfXv6MLjyTOXjR0sl0x1r9cO4LJai5cbQ/JUQS7Ut/YOZ0Tjt8WpwmcL9YEpARGQxhBW2qVkGiDVLsxvU7BgxAZ67kOw0W8t/zzXb/z1ii/dtYRb9aCay6OymSdt27i7DsP4sumwQAxgHFZOdbpOqnHXri2Ta2jYXWxH7rEhzxrKGIwyUEXb8/WTUwFLsIuKqt071ic01W5PzUD2Bbkzcs0VQoIuYXjfonOurKu8aja4ksKyJtfRj7uWDQEmo3vSYUDj17LgJWRlnknnHVcWskszfF/C1/vS2f19EPnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5X43oL8O5acZIn1H0a7wM/XLdWBxtDROeJJm0x62kM=;
 b=CAAosVe1ONfRNKMjLDB+1UUhuMAIF7NRH5sGxUs3JFLj45yoglHad+v7NBLKJve7vcoFm5IQhmkL8WvfAOMNF6V+Lknq9PMxMQcwcEsk20fEx/wW+cFO9L5PsCdoMhvn67wRTGqfdTw/oahAj3D9b9W3UxtzgglZg8oD7u698nl6vvJFyhfqRgSC+JPpxjQ2dFXkO0HrlOHHBV+xzowOAUz4t7n6i/PB1t04J5nsAIATB4TXCy1LancL+6UCx7RLxoKEPxvvrjfGJUeZC79AuUYMT0fDb6N9EVFM8rGoLe2Um8JdzOgy29UxrcV6GJ7dCM45NIQTi/omrTcwWVKWkw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by CY4PR12MB1128.namprd12.prod.outlook.com (2603:10b6:903:3e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Wed, 15 Jun
 2022 20:11:23 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:11:23 +0000
Message-ID: <33acfece-e55d-f827-9b02-91fd07d62182@nvidia.com>
Date:   Thu, 16 Jun 2022 01:41:09 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 07/13] vfio/mdev: remove mdev_parent_dev
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
 <20220614045428.278494-8-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR01CA0116.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::32) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 292a233d-0464-4a8d-ae0e-08da4f0b37ce
X-MS-TrafficTypeDiagnostic: CY4PR12MB1128:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB1128CCDD83EC76D640D05668DCAD9@CY4PR12MB1128.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vkFl/L9WdlMpF0qWJRl+2kR/D+0RyhagZZvo38fRSRf7GHYcCMdaH2fvG/Y7V+/4mOl3IWRs81ax7kteNSZrXWgG+xCKTLnlmHQHv05uQyiesDYQc9+qERwXPYG9MNWdoL4GSq9w9zs1zx6KbixPv/npMeiegWbavr42iPK5bSPxUTjrWi4vpopFfuL+CkWJ/pK5D3E3m229vvYoeNikRK6lzzBOZiKVMqbmJoRcG6R6UsvXJJQ9cVPzYmeLR4TOnAtdUDoDRipzeF1nTsR1Ae+4mwodMkxLVWigoN6BP8pmjlRZytvwslS99OVrIFmzyffh+Il8A+SaO7MOKpSA1Pw4UtPwTP7pKOxOPcUKr4rd9l1jv7t4a331xfqMBPOUY8rsXJr34MiD6kjQZ7u2lUTOc4ibsRraFcnoLXsdK9GPLOeSfmWumZfbntLkYhTBVGxDeQIrDqzCgTIOdk3KMpdvlaFog+D3hQsxfBTy75jpq6BM27e5cBUqh36G+5Chev1O1fU+76W4UFw3J2P28t7uXbxUc3jF/Y+nqZmtPpirs6bXriunqgTms6V4PiHgQLiJbLN8jNcwUa4PMnHZMotQ/YYzkr3QB/8He2PFrPILbnTO+2DN1uvM9lKxuCFWJxLb4adCBfSviw7FQHAPkCqRghnwj1oRQBa+nbxghSiiV8yjjV20gh26ElynzAp9Ufs54CuCw1bgtbOlkl9p4IzRzIdxy2as9SgeK/zX23bLvO7VkkfuCGUm3sDSlXZq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(7416002)(5660300002)(66946007)(66556008)(36756003)(86362001)(31696002)(186003)(8676002)(83380400001)(110136005)(316002)(4326008)(66476007)(31686004)(2906002)(8936002)(6486002)(508600001)(6512007)(55236004)(2616005)(6666004)(26005)(53546011)(38100700002)(54906003)(107886003)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Smt3SXErU2ZUdVB2cjltVTZjVHdWUjhncmo4RU1BMDVOd284VGxWRTZRNDBD?=
 =?utf-8?B?OUtFUzkzOFVEenlxZWQxTUFka2ZRek1CNldqQ2VjOHVqVGxzR1RxbEVXTUV5?=
 =?utf-8?B?TVg3WE9yR1VzeXpCOUxTV1N3T1prdEtNNjZHc3pFRHJFWk40TngwcU1iTVhW?=
 =?utf-8?B?clZXenNGNTV5SnlwNHpmcFNPd0FwbFdaTnFtU2s2M0xlb0lGd0xBVkFIcVd5?=
 =?utf-8?B?MThlaTJtMyszS1orMHFPU2NvcmxDNTdicFBpMzdLd3ZsVWdpMlNFZmVqWTMy?=
 =?utf-8?B?bTEzYS9hTzRzdVlQRDNsMk9EUDBLWDVXNm5wRG4rZWdOSUZLU3Q2d25zVFVP?=
 =?utf-8?B?SmZCZ2xubm42bUpIL2pZcGZ0aTE5Q1JRSTVuM0VOdUF3bFVMQ2xudFMyMVNZ?=
 =?utf-8?B?ZjJ4K0habUVvWk54dHFrK2lhWjQ0ZXI4TVNZUmFrMGdEc3ZkVHVFU0Q2OWNo?=
 =?utf-8?B?TkN4WGdQM3BUM3BFQVFscUEvK0ppQWRWRTljeEllaWt0bkxsdFg2R21tRXoy?=
 =?utf-8?B?eGFYYmdSR01wMStzNE10bjJFQk45Y2RVZVR5ZGJoZDIwU3JHcTB1T1JiT09N?=
 =?utf-8?B?cDFCQktNOVZlaERjbHJ0TzhxNFYxcGdXRUMwL21GK3JDQ3Rub0R6NXNhQW5Y?=
 =?utf-8?B?RlpsVWovMTl5NnNxd3g0b0pjNlpkZk9GdFppcDlYS3o2alcreVRzQU1nNTl3?=
 =?utf-8?B?NjR4ZDl0NEtkc1dPWkRiSHgxRmtQVUx3N2ZuVmdkdmdJMXV6N3d5WC96YkpM?=
 =?utf-8?B?allNM1YxRVhmM1RxVm5iTVVvbVM3cFhoNEdscWRzcHNFSXVDNy9aOVdPUlZY?=
 =?utf-8?B?a2E1a2o5VGp6UjFXMXZVd3pPK2pBQkVTTFVHM2hKelBldzVqVHRUcUI5cmYx?=
 =?utf-8?B?KzNuQitXQWFjT1VtVExhenVrYUNMcjl5WVlUNzZUMlZmeXk4Zk03WUVFbGFa?=
 =?utf-8?B?T1FwdFJaZlBQaEdxSXdURXNsd3Z6VW1GNEtxamJRVEpNcDRNYUIxSXgxei9i?=
 =?utf-8?B?eTJyZVNzTDhmKzdiRjFXZGlmYnk1TWQ5VzdTUUpQN1NaTkdORTFkS3RLWDZq?=
 =?utf-8?B?eDRtRW85cWt0NllwZHlyOHVKbDBXdm5ralZ0bkpJQ3dnaVNRczhuaC8yLzQ2?=
 =?utf-8?B?RCtZQzhPa2hCVFJraGlwQmZDeDYyVENteSs2WUlKRjc3Q0M1QnYyMkZJMEdQ?=
 =?utf-8?B?d3lNRVhwTjRUQkd1VEdLaC9XVXBVN2h5SmZ3aTdYMHg0anRyNDlUdzgwV1FT?=
 =?utf-8?B?N0UxWmtoUVZPY29EaFg1bGdhalpxcVdTTjlVUWhzd25rUEdBenVDbDJjVHFn?=
 =?utf-8?B?Yk84VS8rVll4czZIMVpzN3N1ZTMrQWxIaU1VUmhmVTZCYVdvMXl3VEJ1YjQx?=
 =?utf-8?B?ajhhZlVoOEVhaU4xSzNmUFNLWmhaNnhmQkYzN2wyL3dzRkxxMG1Wd0xCL1lD?=
 =?utf-8?B?dkVDaUVueGJHOXZBUFR6TDkzSHNtUURHVHdHa2FDMFpyYmg3d1FtY1lYSzZ1?=
 =?utf-8?B?RWxqR3NsUFNJM3JrSzVYYXd2ZC9hdEx2bG5US1FMeERnMUlraURwR2ZIOUMr?=
 =?utf-8?B?a3RmMXB6MFFLRmNwRXE5bEZrb2NsQWpIYjBlcFFIKzRUZmxaemF0TWdEM0k4?=
 =?utf-8?B?MDVxT1dBa3JackliS3hCZVQrZHBNai9YRHV1UTdMN0VCU3V5SXJLOEpscjdO?=
 =?utf-8?B?dU0vaGNEdzJQc2FsTmhJbmhUVUZxZEpVYWl5QmlHaE9vd0RMOW5YYXlpU2R5?=
 =?utf-8?B?M3Zqb0s0ZFNieCsybVRwZFRiUUUyWFp3Y3JLQ0x5S2hOOVV2WEpCU2lLMlRp?=
 =?utf-8?B?RTJYdFptV3cxam5kMTh0ODBpaTFGRldIRk9OaHdRcE9NcVE1b2xrbFcyK21x?=
 =?utf-8?B?YXJLRmhUdVdiY2tOWEhHUHZ0emRNNWJxc3NUSjlMTmFHd1ovTVNRd0Nvd1pO?=
 =?utf-8?B?QjNsYk5Na0RNdjVPUjh5T2xGYlBkMFRtWjV2QkhrQU52WlVac0ZwZmZ1bElT?=
 =?utf-8?B?aGtuSytua1h6SGFzR2VGdGlNQjZpNDBvbGpOMnlWd3JDQmhzdkx2WUxzVkFY?=
 =?utf-8?B?dENlbTViSnVSYlg5TERpVjVVK1FUZEFEWGFRbmVQUzUybHFoWHB1UUFQYnh6?=
 =?utf-8?B?WCttT0dQOU5KdnZseVFEdndpOUpXalRnTmovU3EydEJneE14M2YzeVhLOHl4?=
 =?utf-8?B?aE1JdnVBN1krNTZGdmlQTDl1SjQyU1hOWHJDdXFrRFNFNTZEM3o4TkoyNFh6?=
 =?utf-8?B?SGtzNXVTK09lSDhrSjFDNXNIS0Uwd2s4Z1NwUmpaSEhrUVNpL2ZvSWpBNTZO?=
 =?utf-8?B?MXJXN09IdDBXMU44clM3RWovWXBRNnA4alBNY0RmVkdWanpqOFlCK0RqQ3NB?=
 =?utf-8?Q?h0Tm4b+60BnDfBoE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292a233d-0464-4a8d-ae0e-08da4f0b37ce
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:11:22.9479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZuwpyxH9poR7edNrAMzXOKeOAdsWRbTi5n4zTQgD9TJmI1bo/Yy147XrXMnKDnVowSylY9h1ZQi4MmoIp2D/Bg==
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
>   Documentation/driver-api/vfio-mediated-device.rst | 3 ---
>   drivers/gpu/drm/i915/gvt/kvmgt.c                  | 2 +-
>   drivers/vfio/mdev/mdev_core.c                     | 6 ------
>   include/linux/mdev.h                              | 1 -
>   4 files changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index 599008bdc1dcb..27247b3bdcb57 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -202,9 +202,6 @@ Directories and files under the sysfs for Each Physical Device
>   
>   	sprintf(buf, "%s-%s", dev_driver_string(parent->dev), group->name);
>   
> -  (or using mdev_parent_dev(mdev) to arrive at the parent device outside
> -  of the core mdev code)
> -
>   * device_api
>   
>     This attribute should show which device API is being created, for example,
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 1c6b7e8bec4fb..136f9c0df48b9 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -1549,7 +1549,7 @@ static const struct vfio_device_ops intel_vgpu_dev_ops = {
>   
>   static int intel_vgpu_probe(struct mdev_device *mdev)
>   {
> -	struct device *pdev = mdev_parent_dev(mdev);
> +	struct device *pdev = mdev->type->parent->dev;
>   	struct intel_gvt *gvt = kdev_to_i915(pdev)->gvt;
>   	struct intel_vgpu_type *type =
>   		container_of(mdev->type, struct intel_vgpu_type, type);
> diff --git a/drivers/vfio/mdev/mdev_core.c b/drivers/vfio/mdev/mdev_core.c
> index 49a4a26787ce6..479ae5ed6c392 100644
> --- a/drivers/vfio/mdev/mdev_core.c
> +++ b/drivers/vfio/mdev/mdev_core.c
> @@ -23,12 +23,6 @@ static struct class_compat *mdev_bus_compat_class;
>   static LIST_HEAD(mdev_list);
>   static DEFINE_MUTEX(mdev_list_lock);
>   
> -struct device *mdev_parent_dev(struct mdev_device *mdev)
> -{
> -	return mdev->type->parent->dev;
> -}
> -EXPORT_SYMBOL(mdev_parent_dev);
> -
>   /*
>    * Used in mdev_type_attribute sysfs functions to return the parent struct
>    * device
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index dd11c142bf887..83c85a0247f25 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -100,7 +100,6 @@ void mdev_unregister_parent(struct mdev_parent *parent);
>   int mdev_register_driver(struct mdev_driver *drv);
>   void mdev_unregister_driver(struct mdev_driver *drv);
>   
> -struct device *mdev_parent_dev(struct mdev_device *mdev);
>   static inline struct device *mdev_dev(struct mdev_device *mdev)
>   {
>   	return &mdev->dev;
