Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E66EB54D275
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 22:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbiFOUYm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 16:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiFOUYl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 16:24:41 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34BE4FC43;
        Wed, 15 Jun 2022 13:24:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dcFAvRcFLf80awVkOD2k1urvHmH3Kk1ashPkY0HtPLkD6frUWFu+yQgMMRzJQ9aHiJ//3sBniviIcsstnphuRnAOwG3XOHpSkZBm38n4PFUpNXH/IBSjAv3htm64S1hKnwhS+sosWc/0DKg3DN0pyMMxTTbsTmKsbKplU5ORl7tDRmxcrTGkgpycobrk18qXfHy0Rc/tlyCnYvbB3oEgL9YZxivrM3NIBm60TxerKajoR/Juja+Kj0Q+5T16I6jznrLaWFEtwB4XCWdp5B7xX9Njs0kwPx515beGmP3f5d8f6qoypG0p+6g7wqyac+zzxWfCVC/obhB9CB8O3AsOmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2VgQZ64wfbjnqxALByftlNfD2Zom4fUfMiSrtYAus24=;
 b=ZMOmKxKfAl83gIOTqviR1brPIbwn1vmfPHzkcLvAe1fMapLWyOZUtSap25Gzh+e1k8KTdOoy11JPSl9bGmfjldGC+5enRBmLAZhJTNLZ50KvbwlVI1JqQHajFmJItZPCUoJg3vXGal6nsY8NyRGrbuzxEpg8QOOT10wqOoh2d3btZOnstoDyxp1y5wKjsKV+ciPjpxxADGZtANujrvultcfohGXGZm9rpMTqQW3NJe7pazAfZsXRTqzEfJ1Ggp8RINGCVAo7b3Ctqr0k9Ik/zFoI8vXNWaCwfCwZTRk/BWjkYiycQC0hq1eoQxZfv8W0Dx58CmKi9Jxa/2u32kX6QQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2VgQZ64wfbjnqxALByftlNfD2Zom4fUfMiSrtYAus24=;
 b=HAPVFPjhRSoTOFZ6NVzRDa0a8KbbhCt5Sn1WX7HnMR+CZMvFBq4iqlaJKFLXdtcIXX99IadB9bFj/uONo67tfsXpVJrNcRyx46w47VU3gvgkQuYzfkZH1iE8lSJCZY8ShJFDcG1eYpXrxYOnPwISKw95z//P2mI6oYmgt4tiu8fDmkRQA2oqr6AEJCIOsNXp5NV3P0u6n+KVX6KpTU+MqsiSrtibMjjBiOnu4TaueB+HgyL+5g21HHmh5k1holRRZBjNHLvkacgagjeNDCdqW5KJ2gl2wuEjbgAar3FjEjCz5YrPv8XQWtir3tEN0zkcJYdo8Njhm6EVm7e0WMMjeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4206.namprd12.prod.outlook.com (2603:10b6:208:1d5::18)
 by MWHPR12MB1279.namprd12.prod.outlook.com (2603:10b6:300:d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.15; Wed, 15 Jun
 2022 20:24:36 +0000
Received: from MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14]) by MN2PR12MB4206.namprd12.prod.outlook.com
 ([fe80::d5df:ac97:8e92:fc14%7]) with mapi id 15.20.5332.022; Wed, 15 Jun 2022
 20:24:35 +0000
Message-ID: <6599f9b0-c669-d9a0-91f9-e8d967b9ba7d@nvidia.com>
Date:   Thu, 16 Jun 2022 01:54:22 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 09/13] vfio/mdev: consolidate all the device_api sysfs
 into the core code
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
        Jason Gunthorpe <jgg@nvidia.com>, Neo Jia <cjia@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>,
        Dheeraj Nigam <dnigam@nvidia.com>
References: <20220614045428.278494-1-hch@lst.de>
 <20220614045428.278494-10-hch@lst.de>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
In-Reply-To: <20220614045428.278494-10-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA1PR0101CA0042.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::28) To MN2PR12MB4206.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a846863d-f546-40fe-f6d3-08da4f0d1065
X-MS-TrafficTypeDiagnostic: MWHPR12MB1279:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB1279A890B3DB1BA6A461BBB9DCAD9@MWHPR12MB1279.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cLhxryMQGFfnZTuA6B/0bEyxZ1Gyb/hmvm2EAWYg6dO3rnieITwHecvjHVyAfeeCtdLgyx1xdEXgWvYaNLzD6uafI+OB2dJhXityryRrZMUgWLv4nW93lfA1q6u76rnjfnZF44dw9mkirMHzb3c/BxBxwDkMqojhuWlPZ/Ehs1AbHIskY2VIJlkDbQ0y+Y543TVLxxzJrk3zhObl9d1TNJVp4YEKFdGJdiN5SN7wRoG1YW0A1PfxMsmrtZOmHhSoKwsiji1isjlVGb1aXy0iM7G/SNbrkdb5kVcv8432urrh5lkxT3dMh04rvDzueiNVLKVDPQdyOqMKOTkP+hQh6Osqt6tXb6BmreN7NEwN3GheB7V8pO2KNUE0GL8sjFe/xads0dv0UEkJAH7KEjwKJZpcGRttHczS3IhdwgL7tqb5eO9lTeWCDfvkwq17OSXVivOcbO5gcCtmVP/d3xCTgqXahawjj3UqTskD06jYyieeHSx63Wlia4TB6zYCj/rkYkvOQkmteOA26qj9eYyIMOrOpfvr76Pe09AdPPeSgGa3/H2czTauyCn19Du1raYllvhRVOiZS8AwL5dKKCdjkkBVkM41PYRqG9DGlpWqR+SIb/V+dK+kAGqUXcAmleEPkRk6+a7UO+HrJr2UtMI2sG5bZDfTrFu8tyc7vq0Z2VWxljXRz/E5ptShWZP8yBF230Epyksz9rWm9Vjb7HyVl31GSSB+UqIxFM/1xKXK5ck=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4206.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(83380400001)(6666004)(110136005)(54906003)(31686004)(186003)(7416002)(2906002)(30864003)(36756003)(4326008)(8936002)(5660300002)(66476007)(8676002)(6512007)(66946007)(316002)(55236004)(107886003)(86362001)(53546011)(6486002)(38100700002)(508600001)(6506007)(2616005)(26005)(31696002)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RmpaYk5zN2pOTEc1Qm1Rdm5VN0JvQ2pGR2szajlrenNzcjNveGxBS0kxQUdn?=
 =?utf-8?B?NjRnZUFWTWt3ZFNLdEtZVnRYdmNaZXJhYkwrajY2NVcwRTZzbHZHWDEyRFRT?=
 =?utf-8?B?SlF5cmlXQUFNOHE4YVdOZCtnejhQekpTdVowT0p3RktRV2FXS3NVQ0tiSWti?=
 =?utf-8?B?QWlkV0pNY2l1bGtITUdyclFGdFBPb01KRFd0Unc2YW1CakpLejM3RHlPb3hH?=
 =?utf-8?B?YVBENitYTWJaQ21naU1zTzZzR2o2cVBEZlIrMWdaLzJLMmkrS1A1SGR3R1Z4?=
 =?utf-8?B?WlBmYTVYSDFWVmJSQXFQWmVYbVFKNlllcHlwekVyMmJyUnlhNVBFNUVFRTdX?=
 =?utf-8?B?K0dudEs1V1NuTm0rZGRIQzU4WVpyT3ErU2tCUTdlOWp2WVFpZmJ5QjBaQVh5?=
 =?utf-8?B?eXVFVkU1dDdSNDRLUUJBYmFzMnVCL0JKQmluYktZTWVHMzBTcVNFVFYrWTly?=
 =?utf-8?B?Z1ZKV1JwbjdaY3F6R1RuRG8wYTBnZDRDaEVrVm9wVC8xTzZUZzNlNkl1bjVV?=
 =?utf-8?B?cmxPTkhML3JlOWwzelRpdDBHbGR4ODErTjhOcXQ2VUhYalNWNFJOcGtNQ2pM?=
 =?utf-8?B?WDVGWGxWL2Z2VVQ4bWEyK0MrN25kMXEzQkJWSlZuMm9tN0VKTkdkT0x3SjMx?=
 =?utf-8?B?dEtCM2tpUk95NkxUM0dHeklaVHE2VlRyQ2JrdS81WUN5NmVaclRBamRPSi95?=
 =?utf-8?B?SXJrbEM2bStJUWE4dDNkemZHZ2tVbGw1SzliM2N5WURqUWZ5ajBtNE5nWjFz?=
 =?utf-8?B?Yk5JWERrVC9jMWtRS25nTkV0QXhjdk9PVnEzQzV0WTRJT09HSG52L0VzMlFJ?=
 =?utf-8?B?aUJkVWY5cEh5UEZjd3FOZWZJVlN3VGJ0YXNCNllDalRQaVNEK01VWGczbG84?=
 =?utf-8?B?eU5tUU9nVG1mYnRiQnp4SXFqQldkOEpPdlRwSm9Lb2trT2xiaTQxTHVsTWVU?=
 =?utf-8?B?bzR5MEliRHp5UmZGdENSQkswU0pBZFhLMWlOZ1prVSs2SVZtUnhRNzUvMGpH?=
 =?utf-8?B?d1loSWRZNGFwMFBhcUdQQ3cvSCtKSUNVcXF2VmVBdUttZ3N2T1BUdGJjbzJv?=
 =?utf-8?B?YStvZ0hFZFpCK3RrTXZYTWZMNTNaNUJBcFl2MDA0ZHBBZUdSZHZURjBqNXNx?=
 =?utf-8?B?VGdsK1pVQklZZHc5YitIWmhUcUpIalJNMUlQeTBwUHFyQyt4LzZ3UEhOS3VM?=
 =?utf-8?B?S3BoRGxHVHBlOU1tTTZUYWwrbkdFSjBlYW5HZW8zNnNhbnF3TmQrMFZTcFRD?=
 =?utf-8?B?ZG85VlBUcy9sSVdmVHIzZlVUTGg3VnVvWVl1YU00MTN4UzBXODA4cU5Xb1VN?=
 =?utf-8?B?SWhOdDNVNXNpODk0YnlHR2VweTZIOTcyVnVwb2VWdzQ5cUM0cDBTUWU2K3hT?=
 =?utf-8?B?WHN0STZpbkRXaTlRTVE0blFzeWJoVi9hYzgvZHFReVY0NW1IeDlWV2R0YTNw?=
 =?utf-8?B?cEMxRmx2TGV3U3BjdklIcmgwVHhOT2F5SWVJS1Q3SXJIb1VlYVlrSGdxalJC?=
 =?utf-8?B?dWdmR0xWWEIxRkcyUkJKNlRhU2xZczVNTFBIU0FoQUJ3S2VPNDgwVndreTlE?=
 =?utf-8?B?Q3JmMGxwUHA3WFpjbVB5ZzVOd3JHV1RRYllTaFY4dmVTb21qaFllQW1rcXR5?=
 =?utf-8?B?Q29QeTNqdG50N2pYeldJNlpIVmZGYTBCWUVLQzlsbERaSnNxb01CWHQ2T2xB?=
 =?utf-8?B?UlR0N3liYUVuNlZHVk8xL3lxVWpwUEFIem5vZmhZbjFlbCtibndEbnFXWEE2?=
 =?utf-8?B?MHV1RWo1TjUxYWdOTVN4MGJaK2dHNTJQQWU3WU15aktUYThNS3FRdUNrM1ph?=
 =?utf-8?B?QTRhQ1lxUy9KUkdLTm96ak9IVTBsRnZqMmM3a2dpRlk1SEIyTDBCbnJ1UktU?=
 =?utf-8?B?NktGTFlnd0c0OFVVUUZ5cUhYK0pxZEJrRlFEblBOK1R0TWY0alV5dVFualhv?=
 =?utf-8?B?WWNNTHBqTnhtSXRFSVQ0MWc1dSt3Q01xQ3hhcmJXTi8xeG9mRmtoWVMzc25N?=
 =?utf-8?B?bmRnUzFKeUNVZ3ltdFlQZkJmU0J6UjNLU2xjY2RaSlVBQVZZQnJWQ3BOWEVD?=
 =?utf-8?B?eE9lQXVYRjJjdXgrZUN6MytNTmV4UjFYeDNIcHdHTVl0anFqVmw3QjFRM1la?=
 =?utf-8?B?UmJHbDNFbHN0L3hBMGZETjk1c1c0OGpuVktBM054OG1pV1MxM1BhNnFzRndE?=
 =?utf-8?B?RWlLb1BxZnUwZkVaMzdjaHdiVFkxNGprejhKSzlwd0Z0V1ZpK0Y1cU5lMFAy?=
 =?utf-8?B?Mk5yaVRZQjB0NTQ5NC9VaFVVOTc4Y0RoTVI2STJCdkxuNEtVSGpaR1VxMTNJ?=
 =?utf-8?B?N2JoWS9vb3NLUjNDT0NnWFVlQ2tOcHAySjJFU2RwV2I1Z0pPUXcvQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a846863d-f546-40fe-f6d3-08da4f0d1065
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4206.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 20:24:35.8381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qN5/9sON2WJbTkZBTDVOU+R+2OfDlOQzMQTP9CnyAmGL0H2MoR/op+cFiHRy46PxesdPw886/GTbV/Q/Uhw/1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1279
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
> From: Jason Gunthorpe <jgg@nvidia.com>
> 
> Every driver just emits a static string, simply feed it through the ops
> and provide a standard sysfs show function.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>

> ---
>   .../driver-api/vfio-mediated-device.rst       |  2 +-
>   drivers/gpu/drm/i915/gvt/kvmgt.c              |  9 +----
>   drivers/s390/cio/vfio_ccw_ops.c               | 11 ++----
>   drivers/s390/crypto/vfio_ap_ops.c             | 10 +-----
>   drivers/vfio/mdev/mdev_driver.c               |  4 ++-
>   drivers/vfio/mdev/mdev_sysfs.c                | 35 +++++++++++++------
>   include/linux/mdev.h                          |  7 ++--
>   samples/vfio-mdev/mbochs.c                    |  9 +----
>   samples/vfio-mdev/mdpy.c                      |  9 +----
>   samples/vfio-mdev/mtty.c                      | 10 +-----
>   10 files changed, 38 insertions(+), 68 deletions(-)
> 
> diff --git a/Documentation/driver-api/vfio-mediated-device.rst b/Documentation/driver-api/vfio-mediated-device.rst
> index 27247b3bdcb57..e9913bfb4393b 100644
> --- a/Documentation/driver-api/vfio-mediated-device.rst
> +++ b/Documentation/driver-api/vfio-mediated-device.rst
> @@ -204,7 +204,7 @@ Directories and files under the sysfs for Each Physical Device
>   
>   * device_api
>   
> -  This attribute should show which device API is being created, for example,
> +  This attribute shows which device API is being created, for example,
>     "vfio-pci" for a PCI device.
>   
>   * available_instances
> diff --git a/drivers/gpu/drm/i915/gvt/kvmgt.c b/drivers/gpu/drm/i915/gvt/kvmgt.c
> index 136f9c0df48b9..44a418d897377 100644
> --- a/drivers/gpu/drm/i915/gvt/kvmgt.c
> +++ b/drivers/gpu/drm/i915/gvt/kvmgt.c
> @@ -123,12 +123,6 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   	return sprintf(buf, "%u\n", type->avail_instance);
>   }
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -
>   static ssize_t description_show(struct mdev_type *mtype,
>   				struct mdev_type_attribute *attr, char *buf)
>   {
> @@ -151,13 +145,11 @@ static ssize_t name_show(struct mdev_type *mtype,
>   }
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
> -static MDEV_TYPE_ATTR_RO(device_api);
>   static MDEV_TYPE_ATTR_RO(description);
>   static MDEV_TYPE_ATTR_RO(name);
>   
>   static const struct attribute *gvt_type_attrs[] = {
>   	&mdev_type_attr_available_instances.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_description.attr,
>   	&mdev_type_attr_name.attr,
>   	NULL,
> @@ -1587,6 +1579,7 @@ static void intel_vgpu_remove(struct mdev_device *mdev)
>   }
>   
>   static struct mdev_driver intel_vgpu_mdev_driver = {
> +	.device_api	= VFIO_DEVICE_API_PCI_STRING,
>   	.driver = {
>   		.name		= "intel_vgpu_mdev",
>   		.owner		= THIS_MODULE,
> diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
> index 43d53736dfe3c..730d87a96a305 100644
> --- a/drivers/s390/cio/vfio_ccw_ops.c
> +++ b/drivers/s390/cio/vfio_ccw_ops.c
> @@ -77,13 +77,6 @@ static ssize_t name_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(name);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_CCW_STRING);
> -}
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static ssize_t available_instances_show(struct mdev_type *mtype,
>   					struct mdev_type_attribute *attr,
>   					char *buf)
> @@ -96,7 +89,6 @@ static MDEV_TYPE_ATTR_RO(available_instances);
>   
>   static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -636,6 +628,7 @@ static const struct vfio_device_ops vfio_ccw_dev_ops = {
>   };
>   
>   struct mdev_driver vfio_ccw_mdev_driver = {
> +	.device_api = VFIO_DEVICE_API_CCW_STRING,
>   	.driver = {
>   		.name = "vfio_ccw_mdev",
>   		.owner = THIS_MODULE,
> @@ -648,7 +641,7 @@ struct mdev_driver vfio_ccw_mdev_driver = {
>   
>   int vfio_ccw_mdev_reg(struct subchannel *sch)
>   {
> -	sprintf(sch->mdev_type.sysfs_name, "io");
> +	strcat(sch->mdev_type.sysfs_name, "io");
>   	sch->mdev_types[0] = &sch->mdev_type;
>   	return mdev_register_parent(&sch->parent, &sch->dev,
>   				    &vfio_ccw_mdev_driver, sch->mdev_types,
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index ff25858b2ebbe..da21fd60877fb 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -529,17 +529,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_AP_STRING);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static const struct attribute *vfio_ap_mdev_type_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1454,6 +1445,7 @@ static const struct vfio_device_ops vfio_ap_matrix_dev_ops = {
>   };
>   
>   static struct mdev_driver vfio_ap_matrix_driver = {
> +	.device_api = VFIO_DEVICE_API_AP_STRING,
>   	.driver = {
>   		.name = "vfio_ap_mdev",
>   		.owner = THIS_MODULE,
> diff --git a/drivers/vfio/mdev/mdev_driver.c b/drivers/vfio/mdev/mdev_driver.c
> index 5b3c94f4fb13d..60e8b9f6474e8 100644
> --- a/drivers/vfio/mdev/mdev_driver.c
> +++ b/drivers/vfio/mdev/mdev_driver.c
> @@ -55,8 +55,10 @@ struct bus_type mdev_bus_type = {
>    **/
>   int mdev_register_driver(struct mdev_driver *drv)
>   {
> -	if (!drv->types_attrs)
> +	if (!drv->types_attrs || !drv->device_api)
>   		return -EINVAL;
> +
> +	/* initialize common driver fields */
>   	drv->driver.bus = &mdev_bus_type;
>   	return driver_register(&drv->driver);
>   }
> diff --git a/drivers/vfio/mdev/mdev_sysfs.c b/drivers/vfio/mdev/mdev_sysfs.c
> index dd81b91afcf7d..20763f1aa9f5a 100644
> --- a/drivers/vfio/mdev/mdev_sysfs.c
> +++ b/drivers/vfio/mdev/mdev_sysfs.c
> @@ -72,9 +72,30 @@ static ssize_t create_store(struct mdev_type *mtype,
>   
>   	return count;
>   }
> -
>   static MDEV_TYPE_ATTR_WO(create);
>   
> +static ssize_t device_api_show(struct mdev_type *mtype,
> +			       struct mdev_type_attribute *attr, char *buf)
> +{
> +	return sysfs_emit(buf, "%s\n", mtype->parent->mdev_driver->device_api);
> +}
> +static MDEV_TYPE_ATTR_RO(device_api);
> +
> +static struct attribute *mdev_types_core_attrs[] = {
> +	&mdev_type_attr_create.attr,
> +	&mdev_type_attr_device_api.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group mdev_type_core_group = {
> +	.attrs = mdev_types_core_attrs,
> +};
> +
> +static const struct attribute_group *mdev_type_groups[] = {
> +	&mdev_type_core_group,
> +	NULL,
> +};
> +
>   static void mdev_type_release(struct kobject *kobj)
>   {
>   	struct mdev_type *type = to_mdev_type(kobj);
> @@ -84,8 +105,9 @@ static void mdev_type_release(struct kobject *kobj)
>   }
>   
>   static struct kobj_type mdev_type_ktype = {
> -	.sysfs_ops = &mdev_type_sysfs_ops,
> -	.release = mdev_type_release,
> +	.sysfs_ops	= &mdev_type_sysfs_ops,
> +	.release	= mdev_type_release,
> +	.default_groups	= mdev_type_groups,
>   };
>   
>   int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
> @@ -100,10 +122,6 @@ int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
>   	if (ret)
>   		return ret;
>   
> -	ret = sysfs_create_file(&type->kobj, &mdev_type_attr_create.attr);
> -	if (ret)
> -		goto attr_create_failed;
> -
>   	type->devices_kobj = kobject_create_and_add("devices", &type->kobj);
>   	if (!type->devices_kobj) {
>   		ret = -ENOMEM;
> @@ -118,8 +136,6 @@ int mdev_type_add(struct mdev_parent *parent, struct mdev_type *type)
>   attrs_failed:
>   	kobject_put(type->devices_kobj);
>   attr_devices_failed:
> -	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
> -attr_create_failed:
>   	kobject_del(&type->kobj);
>   	kobject_put(&type->kobj);
>   	return ret;
> @@ -130,7 +146,6 @@ void mdev_type_remove(struct mdev_type *type)
>   	sysfs_remove_files(&type->kobj, type->parent->mdev_driver->types_attrs);
>   
>   	kobject_put(type->devices_kobj);
> -	sysfs_remove_file(&type->kobj, &mdev_type_attr_create.attr);
>   	kobject_del(&type->kobj);
>   	kobject_put(&type->kobj);
>   }
> diff --git a/include/linux/mdev.h b/include/linux/mdev.h
> index ecf964d34f2ca..81e11e18b3e41 100644
> --- a/include/linux/mdev.h
> +++ b/include/linux/mdev.h
> @@ -61,11 +61,6 @@ struct mdev_type_attribute {
>   			 size_t count);
>   };
>   
> -#define MDEV_TYPE_ATTR(_name, _mode, _show, _store)		\
> -struct mdev_type_attribute mdev_type_attr_##_name =		\
> -	__ATTR(_name, _mode, _show, _store)
> -#define MDEV_TYPE_ATTR_RW(_name) \
> -	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RW(_name)
>   #define MDEV_TYPE_ATTR_RO(_name) \
>   	struct mdev_type_attribute mdev_type_attr_##_name = __ATTR_RO(_name)
>   #define MDEV_TYPE_ATTR_WO(_name) \
> @@ -73,12 +68,14 @@ struct mdev_type_attribute mdev_type_attr_##_name =		\
>   
>   /**
>    * struct mdev_driver - Mediated device driver
> + * @device_api:	String to return for the device_api sysfs
>    * @probe: called when new device created
>    * @remove: called when device removed
>    * @types_attrs: attributes to the type kobjects.
>    * @driver: device driver structure
>    **/
>   struct mdev_driver {
> +	const char *device_api;
>   	int (*probe)(struct mdev_device *dev);
>   	void (*remove)(struct mdev_device *dev);
>   	const struct attribute * const *types_attrs;
> diff --git a/samples/vfio-mdev/mbochs.c b/samples/vfio-mdev/mbochs.c
> index 1069f561cb012..199846f01de92 100644
> --- a/samples/vfio-mdev/mbochs.c
> +++ b/samples/vfio-mdev/mbochs.c
> @@ -1367,17 +1367,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1391,6 +1383,7 @@ static const struct vfio_device_ops mbochs_dev_ops = {
>   };
>   
>   static struct mdev_driver mbochs_driver = {
> +	.device_api = VFIO_DEVICE_API_PCI_STRING,
>   	.driver = {
>   		.name = "mbochs",
>   		.owner = THIS_MODULE,
> diff --git a/samples/vfio-mdev/mdpy.c b/samples/vfio-mdev/mdpy.c
> index 40b1c8a58157c..401a9a622673c 100644
> --- a/samples/vfio-mdev/mdpy.c
> +++ b/samples/vfio-mdev/mdpy.c
> @@ -678,17 +678,9 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   }
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
>   	&mdev_type_attr_description.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -701,6 +693,7 @@ static const struct vfio_device_ops mdpy_dev_ops = {
>   };
>   
>   static struct mdev_driver mdpy_driver = {
> +	.device_api = VFIO_DEVICE_API_PCI_STRING,
>   	.driver = {
>   		.name = "mdpy",
>   		.owner = THIS_MODULE,
> diff --git a/samples/vfio-mdev/mtty.c b/samples/vfio-mdev/mtty.c
> index 029a19ef8ce7b..2a470424628af 100644
> --- a/samples/vfio-mdev/mtty.c
> +++ b/samples/vfio-mdev/mtty.c
> @@ -1268,17 +1268,8 @@ static ssize_t available_instances_show(struct mdev_type *mtype,
>   
>   static MDEV_TYPE_ATTR_RO(available_instances);
>   
> -static ssize_t device_api_show(struct mdev_type *mtype,
> -			       struct mdev_type_attribute *attr, char *buf)
> -{
> -	return sprintf(buf, "%s\n", VFIO_DEVICE_API_PCI_STRING);
> -}
> -
> -static MDEV_TYPE_ATTR_RO(device_api);
> -
>   static const struct attribute *mdev_types_attrs[] = {
>   	&mdev_type_attr_name.attr,
> -	&mdev_type_attr_device_api.attr,
>   	&mdev_type_attr_available_instances.attr,
>   	NULL,
>   };
> @@ -1291,6 +1282,7 @@ static const struct vfio_device_ops mtty_dev_ops = {
>   };
>   
>   static struct mdev_driver mtty_driver = {
> +	.device_api = VFIO_DEVICE_API_PCI_STRING,
>   	.driver = {
>   		.name = "mtty",
>   		.owner = THIS_MODULE,
