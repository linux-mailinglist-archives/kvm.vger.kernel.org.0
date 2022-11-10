Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58A086239D1
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 03:36:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiKJCgZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 21:36:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiKJCgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 21:36:23 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6C220344
        for <kvm@vger.kernel.org>; Wed,  9 Nov 2022 18:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668047782; x=1699583782;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wFDANNlpb9o1CKRJytHKYFKmy1fxRyYkLMJ5ZnW47xY=;
  b=Iu98DRzVi63SlHBjjm6eUTCqZ2tqH6qwqsrWRJFZdvp+vVMEwDVtkllr
   9LKx3v4YuJwi723Xak7UOHyPFNK/e1A6f7XsyK9Nctlz93oF7q0exWrSo
   PA8y8wIdOY/HP14C/k4XGsoq5y7yYyQ1vxzi1d3Xd59xEjHkj7A+WZbPT
   Fawgg4JTrvQ1SeqX+DHWjMJDi1yKeSGyf8cc5BZxmMtGWE655hVMy8BCR
   Og1xUUYcqPbx68MSovy0UdDN/yoYVPg4f2/epsSIS4EMSxvr36HsQnCrf
   ZLOxpVqjhRlAeiSHuK3eojOxcXrvOmw4T6KpVd4U0vgrjDRpcorOqGrnD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="312318103"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="312318103"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Nov 2022 18:36:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10526"; a="882173287"
X-IronPort-AV: E=Sophos;i="5.96,152,1665471600"; 
   d="scan'208";a="882173287"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 09 Nov 2022 18:36:22 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 18:36:21 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 9 Nov 2022 18:36:21 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 9 Nov 2022 18:36:21 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 9 Nov 2022 18:36:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHWw5qVfTvIoc+dDztOMAQYQIC2mTrg7mUvdbk11h9a2F8DS2noRdLaqDf8oIKaZ67IPfnxihEDeSCQJj93i4y/voIN9+neaKJqcbbRyY0iXbvhwvHJ+qUEJxWlqEaEszHme7MNzZu5IjbORMA3y/+kUX8RoDvnROI6CqoXbLbau8bZZGgTSJNxDQaNOPBX3Hlx07DmmrI4ddVx3l4pWWrYistjGj997S2uXJgwbROtxx6P3uJaXgkLoDTVjjurGAT/Ri4Doe1wbKSM73QcTpLg+g3UmlM0Zc4CQ9CFKrsRBsxhDKvSe9kuhJynOVk0Bzl4xYEG8bU85CQpi3gp8DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k7OFo+GxS+QClQpRquXZx8UdxfZW8Fj5DC2QD54NdYw=;
 b=nIveIc5O7dHf90v6s65aU2Ctrtrvbn7PBiCKvcfvC1ixwafQqcVcw2OGpR3s2nBX3KUm/Ey6g9P8+mSEXs6q/SrRnMYzdDmzlnChXA/tmQjPTDBb0Jxk+02GSc7bhi7Pn5PsNRAraaQoUHVlFaCBh+Qm/PmcgQZ0M88PoneTXNs25b4GHvaMgKRsizpx/lyPBQV57UKt5kdVhOcNUskrE+/ynbwm+RN/Yx96XzN7uc0haY13LHbtK946awfZ92pH1wCdoWm75e4G661nstMXernX8RQNleNTXcSQgeNa10ttGpxfNZsKKkJ5k72AEX3EHWKpKtryHj1IL1a+i6NNfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by IA1PR11MB7272.namprd11.prod.outlook.com (2603:10b6:208:428::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Thu, 10 Nov
 2022 02:36:19 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ad39:e00a:a7cb:4ada]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::ad39:e00a:a7cb:4ada%7]) with mapi id 15.20.5791.026; Thu, 10 Nov 2022
 02:36:19 +0000
Message-ID: <59d9d240-0fa7-b82e-59c0-4b56225095b1@intel.com>
Date:   Thu, 10 Nov 2022 10:36:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH v6 1/3] vfio: Fix container device registration life cycle
Content-Language: en-US
To:     Anthony DeRossi <ajderossi@gmail.com>, <kvm@vger.kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <kevin.tian@intel.com>, <abhsahu@nvidia.com>,
        <yishaih@nvidia.com>
References: <20221110014027.28780-1-ajderossi@gmail.com>
 <20221110014027.28780-2-ajderossi@gmail.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <20221110014027.28780-2-ajderossi@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0147.apcprd01.prod.exchangelabs.com
 (2603:1096:4:8f::27) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|IA1PR11MB7272:EE_
X-MS-Office365-Filtering-Correlation-Id: 793d7dec-9245-46eb-ce8a-08dac2c45906
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lySybyEjYLv8YQmkQNM2oPHgC+TE3mlSlRwT+P30QK8SxBPxAOGApA5vdmDrTVBcY1Xf5UW3Zg+fORu1KWnXHtuTPYCJHehAc9w/WA7E3OYGs6QZfsA6wyGWPskaJoFzOdLQy+7wOlcByyPYiXpstdxHEopAbMTcmOVr7bwWtmr0odBmd8l2zraBNUfTSjQ3qPALUPiT1QUCjKw8QUUbPml9ZjWW8rTwWf8jMYjPpiIbPtcYN9rmI5aYqDfrp6R0ba9gveMI7+zvrNoUO71g/3YFEld9u1c1dJ2DjZLRnTSHDLhQm/+Lp567C9mkYwn2jFArn/qnC8N4moV6RVDC4cYcxdVJBR9FRVup1z+akurAVkehU1b/EwBmsuhIjyr7dpjFkmyPV1qDBGeEKc5PA6k/iNls72GzGZzVsZ0ul3Dhs1vkaMFFWnuhjDj4uWUsXG0a4fvviDI85PJbinHRPhLNlj6r0ghY/CR7Jeb5L9VpDJyJoG+uqydOByC+gr19qlljPXuDszvhl2DGBPzk9aBdEt96P9FhCQHoIEw7i1HvBAIQIW/fXgDKRKgoJxDTiqDi1lYsmWt2bejDYcWUMlLwzcg73mdzpZVTIFtRZyUB8Eh9nJwu1/iJasfsLNj5mok5qPQgam45hTiK/ytk+mEt2EXLzHt35tYIH6BPt5BeO6S/pGFyFc5DDGIOzGwhn+qXJ/dAlSaPt5hhTOSOhufh1MwaOddLSeoWzkbCKV6WLojOav49uKHFXTSncZft9HWRxoMDQlaEuobQdexf68/zDXLsNWS7jxl+tqHo+bE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(376002)(136003)(39860400002)(346002)(451199015)(31696002)(38100700002)(86362001)(478600001)(83380400001)(6506007)(82960400001)(6512007)(53546011)(26005)(2616005)(41300700001)(186003)(66946007)(66556008)(66476007)(6486002)(8676002)(4326008)(2906002)(316002)(8936002)(5660300002)(31686004)(6666004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V05Vb01XbWJad3R3Tmg0ZUQxOGtlL00ycEdGeXJicUpOdjRIYlIvK0Y5bUNG?=
 =?utf-8?B?SW5jWkVZVkF6S3Rub2lVcGZnWTlibjRSdzRCcEgzelRkdDJaMkc4VHJKSDBY?=
 =?utf-8?B?L1JqMTVZcVNwdkZzNlc0OGJBN3FneUljbkJjUnI5Nzgva2FCL1RzVHMxVGtM?=
 =?utf-8?B?TjNpdnBDWVFKS0RlSUt5MDhKNkRwS2JQa3JIKyswMnBNNEE0V05QVE9kQVNu?=
 =?utf-8?B?WjBWblNLUHk1aVZhb3I2Z1dSNFBmc3FuUE93YXg3RitYNEpjcFhxbTJyd05I?=
 =?utf-8?B?RElmTEtwVi94T1FUd2ZuUnJuUnJUV2xRZ0tQSFVTRnJKb3ZacnhYZDlaZVQv?=
 =?utf-8?B?eU9Idnlpa0xjcDQvQWVJSitMUGU2SDlWZnIvZUJSdkVrR1FUNzV2ZSt5b0JH?=
 =?utf-8?B?UWVMcFlGbVlWMk9iS3NsM2lXZ3pNVGdFZnczQ1VCeE5LVzVWd2pWVGp6YXJX?=
 =?utf-8?B?YkdianZ5Q1pCWENBQWRMZ1dTQ2ZvMVcrU1RDaHhIbXZjR21HMVgrUHFYWCs0?=
 =?utf-8?B?N0xSMUZSNjl3OWFkRXJuOTFFclVsSFZiNVpDVngxVVI3djhINFNOTWhNY3lw?=
 =?utf-8?B?TmRLSjFLNW11emtpd0I2bmpIN0xsOGpPVmZkSUlqVnVzMVdaVW03am5qd3Y1?=
 =?utf-8?B?QmxzWFZXTUhSeDA3Tm9wUGgzQUEvV3FXR2JHS1NuOU1seUJmTnVTdEVRS2xj?=
 =?utf-8?B?TFpjdUdxb0FlaGVpcjVRRSs3Zmp2RzdBdFM4ZWdPL0hNZHRjOC9vZEpMZE5J?=
 =?utf-8?B?VmVSOWQxOUoybnZpYk5jRVB4V3VoUk9IdWJjMDRkS3FWd09KT0VPL21LeUtr?=
 =?utf-8?B?ZmZDS2hleURRWDZzaHBjaTZoUmFxRURvaXhNRytodStQcGVpZVpzcS9la3hm?=
 =?utf-8?B?a2xPd0hzOVk1RmlyZlBBd2taYm51MCsrdEVKMVB6K1YrUThabFVQaVRYS2VS?=
 =?utf-8?B?WFdRVUs0aGg0S1lxcHdSTFYzSHJIaHgzTlVzZVNSS092NFRaMkJ1TXBVWWpy?=
 =?utf-8?B?UENoYjF4MnE5RFRWcXQ5V1dhQWtnVllxWVBBdmdwY3VHMnFRMXUzeGZBYm5Z?=
 =?utf-8?B?bEI2RmZwSVRtbnNJdXNoM0hQekJnUW9IeUNmWFFRVG1GaDRIcDA4RjRIdEFU?=
 =?utf-8?B?Nm9ja3ZycENiTVkvY1lGc2VMeU9XU2VwZzlDdm4wNjdhTmV0Y0JITjdQQ0JM?=
 =?utf-8?B?cXYvQWZjMlFQR3pQZVI3Zk1MNTRaWnhoTTAzTFE2ZmRpb3BCYkxqOEo2Zjcr?=
 =?utf-8?B?dHpIbm0xRVk5dzJaVnR6bE9WRVV3YjBiUUdZUjFpTkt0NzhHSXVUL1ZCNm9E?=
 =?utf-8?B?bFFNRWlkS0gwQUFIOWtyYzRKQnZXRFFHMzVTK3pMdnEwYnVEOFFTTnZyMW1N?=
 =?utf-8?B?RUFKYmtFVGE2bFJYb1FjL2NzZEdxQ29lODlqbTlSdTJCSDhSMTllQ0lieUtu?=
 =?utf-8?B?dHdPRmdLK29RdDhVRExZTkk3bXBOa1huUlY4VDRwWXYxU2FjKzRWV25YRzBj?=
 =?utf-8?B?ZDNFWENucS9ha3ZHQ00yRm5hekxRaS9PQVpJeDVCM2IzWDJKd0lIOExETldq?=
 =?utf-8?B?ekVPdEdKd3V4aXM4bnp1cnVrUUFOSkJtR3FTalY2TmllNEo4dTBmbmNVUm80?=
 =?utf-8?B?Q3dFdHNUNHVGVmJrTHJSYjhlUTBlOUx6QmE5UmFocUprUStLN2JhMEdNY0JM?=
 =?utf-8?B?WldsM0NZV1JacGpkeURMSTRYZ2g0UWVaQ1kybUI2Q0huZkpBTHdwbnNwdEF2?=
 =?utf-8?B?Q1NpR2x5b3V3cENRRGJqZlRUMjlHOHVveUlWaklSZGF1bEVSU01mMWU0TVlW?=
 =?utf-8?B?Y1pxWUxYL2RDVjg3TXpqWWJUbGVZSHoya1ZFYzFPTUE2Tm1wY3kzRUdScVdm?=
 =?utf-8?B?M2Z3c3JhVnllUEExUTNMZXdkSHhUZDJ6T1MxWkVxcXRwZ3BVdzcwblN2NnlR?=
 =?utf-8?B?eGpCWHh1Z0xzQTRramxWWi9TbHdtS0tiZFVXK3kzYUw3VllOclBoRTlndVht?=
 =?utf-8?B?M0IyZDhvNEV5dDJVS0N0bTJqRVVBREJIMWFzS3RsZk1zL290WTl5VWhmRTlX?=
 =?utf-8?B?ZHNPcmllZG9USW1KbHlXUDJpWXBtWC9QWFlVVVUvYWNFL1pvUkYyaEgzTUVx?=
 =?utf-8?Q?w9M79/03Hd8JIvNJ4aKN21GoY?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 793d7dec-9245-46eb-ce8a-08dac2c45906
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 02:36:19.2311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /uIB2OKW5PEGur5rOUXFUhnc/kau2CAmPVbLj3C4Pdt765XpUteo4MrzJNBMQXGxRACL1/zPe2ybRVzKTdAhJQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7272
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/10 09:40, Anthony DeRossi wrote:
> In vfio_device_open(), vfio_device_container_register() is always called
> when open_count == 1. On error, vfio_device_container_unregister() is
> only called when open_count == 1 and close_device is set. This leaks a
> registration for devices without a close_device implementation.
> 
> In vfio_device_fops_release(), vfio_device_container_unregister() is
> called unconditionally. This can cause a device to be unregistered
> multiple times.
> 
> Treating container device registration/unregistration uniformly (always
> when open_count == 1) fixes both issues.
> 
> Fixes: ce4b4657ff18 ("vfio: Replace the DMA unmapping notifier with a callback")
> Signed-off-by: Anthony DeRossi <ajderossi@gmail.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
>   drivers/vfio/vfio_main.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)


Reviewed-by: Yi Liu <yi.l.liu@intel.com>

> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 2d168793d4e1..9a4af880e941 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -801,8 +801,9 @@ static struct file *vfio_device_open(struct vfio_device *device)
>   err_close_device:
>   	mutex_lock(&device->dev_set->lock);
>   	mutex_lock(&device->group->group_lock);
> -	if (device->open_count == 1 && device->ops->close_device) {
> -		device->ops->close_device(device);
> +	if (device->open_count == 1) {
> +		if (device->ops->close_device)
> +			device->ops->close_device(device);
>   
>   		vfio_device_container_unregister(device);
>   	}
> @@ -1017,10 +1018,12 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>   	mutex_lock(&device->dev_set->lock);
>   	vfio_assert_device_open(device);
>   	mutex_lock(&device->group->group_lock);
> -	if (device->open_count == 1 && device->ops->close_device)
> -		device->ops->close_device(device);
> +	if (device->open_count == 1) {
> +		if (device->ops->close_device)
> +			device->ops->close_device(device);
>   
> -	vfio_device_container_unregister(device);
> +		vfio_device_container_unregister(device);
> +	}
>   	mutex_unlock(&device->group->group_lock);
>   	device->open_count--;
>   	if (device->open_count == 0)

-- 
Regards,
Yi Liu
