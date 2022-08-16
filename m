Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0555952A7
	for <lists+kvm@lfdr.de>; Tue, 16 Aug 2022 08:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiHPGjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Aug 2022 02:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiHPGit (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Aug 2022 02:38:49 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82AB65851F
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 18:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660612861; x=1692148861;
  h=message-id:date:subject:to:references:from:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Fv3is62k4KAb65gQcge2OuRf3U7i9gGS6EGJIPqfvRc=;
  b=nVmIbMDBRbjDXQ3r8kMdFkDpglP3/+UtjDa5fiI7Gng30OWQwNg/aaji
   FLOB/pyH1tSibb56OzmgQlpCKOKk3mD0MXwdxtdfeGQROO2OaUWvw6cLZ
   AWnfUYlKkRnlZER82y1RNYIdfJUPKZ4/pBahv3Jz46bwvRNPK71DR1Lgl
   ZFzcyMlJwv1x7t9u9jaMdGdnPCE9ur6JX4Z27XnN/71aXdvgGul8PG7BM
   PNLDZBu9r3e1YsC2zjy0G4rsjfhA9l+Rs83AIc0Mwl0WERV14I8Cc/VCb
   0g9rjTK0tFuBYOvK7iSkh1kvuiAw7wfOAk3kOcTMeo4QcQJjY7k9L6QM9
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10440"; a="272488858"
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="272488858"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Aug 2022 18:21:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,239,1654585200"; 
   d="scan'208";a="782846507"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP; 15 Aug 2022 18:21:00 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 15 Aug 2022 18:21:00 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 15 Aug 2022 18:21:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 15 Aug 2022 18:21:00 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Mon, 15 Aug 2022 18:20:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aOTAE9xZf50pM72zDhDZrxYLIRTNhgb5WWsStV70MdhKS6iFQLjCpIYx1egUgAcnPW9iQxj0dsrH8h3OK2zzjJtDBq3KDHmX8UCUfzWqCbHNq+dX5d5nPlugmdn7vckXYnk30fQdwCFa/u/javbMFIUkGseYcdZ7tf6UzmxZvhamZN8uBejv7ZFWpENSjko6ryVMD6Iom/06LtMuCOZC1vveYmsEqPDDmiDtM6x2zanI3yq/Di5vZ07hAKIRIF2Sdkge1wBvvTAhSKIf4i5SIkMdlEr2AMZL1dt6mcj8c7cEpc88eIKS2jj1U8nPFc1A31LuqEegeDZ5CX127ZrWdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0nYZoNb6uaGyUHRS4OplrZ94G5fEAs+WnELAgUo71iI=;
 b=ncUrL8UdByQfZaNmMFz7xLUqD0gwW/0JcexEBeI40qhHFzpB/UDsouJgHc3NJVrA4JDfVP3AixlsKfrTTfc0YtPOFkSHDpRPDOERTC6iH6RhGhFTvz64TF1mToRkbzft8NHB8A7iBb41/M/Qpk1hT/p/4JiS4dD7Q38sbPBNUyR01+eEIK0aUxrzlSUJokiKZXOv/wFIlV44CqffGGlwSa2EYs2XOkaR4hZIvJKkXXf0dnar4j3EpAu3YtNQ+vZot13/+8ECI6xILywhd5eE0Rl3FU3uhUyJo8RQEv77Akc0cbZBTW819fpD55+p+7okxe5Bwm11ICABawVNa8ngfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by CO1PR11MB4868.namprd11.prod.outlook.com (2603:10b6:303:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Tue, 16 Aug
 2022 01:20:58 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d17a:b363:bea8:d12f]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::d17a:b363:bea8:d12f%9]) with mapi id 15.20.5504.028; Tue, 16 Aug 2022
 01:20:57 +0000
Message-ID: <1e4626c7-4eba-d1d6-a85d-6042acd64991@intel.com>
Date:   Tue, 16 Aug 2022 09:21:05 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.9.1
Subject: Re: [PATCH] vfio: Remove vfio_group dev_counter
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>
References: <0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <0-v1-efa4029ed93d+22-vfio_dev_counter_jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR04CA0201.apcprd04.prod.outlook.com
 (2603:1096:4:187::23) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa9363eb-48f5-4ad9-c0d5-08da7f259262
X-MS-TrafficTypeDiagnostic: CO1PR11MB4868:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4PkjV5G8kKky9q2IYgSMLfwjkTVQORU2WffzC9EM7kIrxgCMa77BkixxehggYpCwu0LjhfKen2DV6L9P/YO0eFTrLZUFV2B4W1jX7nHa0ADoV/lrzvuPwg/YxIJ8YIAyZjiXU+jdhGpDOsLTo834AZnL5Mhs45pge0eDKUi529yvjqOBKgiyUAomQsKC0VU8KHcCo7nvO277lTvV8c1PxQtP0umtS2Fa9+qpVtOCf58IIRobUb9Fn8dBnqnudW6xFNO7NST9iXXBPuJ4InU6ZQycaan87YXIL3l2zMaIvwyHv/MCnIHMXZEnWnFvABDBMB7GHEsvOcvGR6x2KM0njjLuaK1qumpXQn5EfgT1K1xKTimA6q6LbaisT77D6s8sSBoA1TEqCBqmqz0eh5MFY2fRFN0LJxI3wz7nLd64VTuKh6b8T4C0BAGNFP1uDpU4ziXsxu//6pW17VGYJiB/XGIloRFKxDOhmFovmJnaCV9v3/ZFxaLSf8xiLI7/LVN3EDWfP+tXZvfDFicAW+K8lilF7EG1rXuh3gsm62bOBzng9/Ok4GtxYLx68jvA5Tml4o8Zn+9EoUj1Go5nF0XShWbwbJjkVEx8iIYWY5prg5V5jzM+rYOqDchwGbS2ZUWmAd4odgD/gpJRvcfMlmpCkABcQb5mxstPY6IG2KohPKG6n4oG6JjXVnm6o/Kz6y8jZu8P0VPxLgKcUMPWI9e3IPaLzIUTDhiP8oPwhkC8cyZmyI2EifBiUg198QjiNrYQXIQeYqO87dvHs8NCKz7TTzA6iSC99wUg/HRydA5wN0r/v7spS4W5v70iY2FQ1rHZZUG9LXa3sNgbt/udLiCxyP8jV1AAB5j94nXkyWsJIY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(346002)(376002)(39860400002)(396003)(316002)(36756003)(6486002)(66946007)(966005)(66476007)(66556008)(31686004)(110136005)(8676002)(5660300002)(186003)(6512007)(26005)(31696002)(86362001)(41300700001)(478600001)(8936002)(2616005)(82960400001)(38100700002)(2906002)(53546011)(6666004)(6506007)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VERrL2Rwc1dLVzhQaWFtMHpMYTE0WGd3cHcvQ2RnL2xaaWczL2lkbjBaZ1BF?=
 =?utf-8?B?SE9yRkl4dVhTY0dva2lKdS9HTmVIWWkwZEdzYW9YQ0dZcWZwcXlRTVRiNDV6?=
 =?utf-8?B?WGwwRGdjT09tMkExREEyZWpBdjg3aHRldmdENEoxNGZXdGlIYUVMbTk1MnZZ?=
 =?utf-8?B?NHhKUzc0TzVodWdXaWtjek1talIwNWFIVGJxcFpsNnNzNXFHbGhqSEpmeE5R?=
 =?utf-8?B?OVFwbVpWbGVNeFZkTHRibmVWdWNoTEE2RlB3NndlcWZDbVN6SU1FTjhRTXBv?=
 =?utf-8?B?K1ZpaTNhZHZ0SnpFTitDUnRUcE1laUx0Rm1iaVU1VzcwSEw0aDY2NmVZOEYx?=
 =?utf-8?B?a3pDSWV3QjZxN1pCa0ZvV0JnYjFtVTdISEIzZCszaFZRNVFicitJRzlhcERt?=
 =?utf-8?B?d1NjWXFudGpVaUZ3SHQrVm5ZZFF4aUpOc1FFSUczSEJUaEN1VGtWRExRUUtI?=
 =?utf-8?B?QmJYbzhJTG01OWxodFdSQ20wYzY1QzBSY2xEUkFJandqYXpCL1hTaE9sdVR0?=
 =?utf-8?B?K2JVd1V4dk5vVXQrTmZwcEN1T1ZEakk5N0Qwc1hhT0FDbU9xcUQwZGkwMVFr?=
 =?utf-8?B?SzBqbGxRWDQvT0s2YkdGWHlzMzRQeXBKMDVQK3h0UkFVSWxmamxnZEppZHdP?=
 =?utf-8?B?a2NNN0pIMXFSaTA5d1JNMTJiSDRKS3lZR2JEbnFKSzFtcWFQVVk2bE5scFAx?=
 =?utf-8?B?MFFVWWNhUU5CUkVZWFFGajlKZkJCQ21oZmdWMUpaTTRUYS9QR211WGJJMmw4?=
 =?utf-8?B?clk2V0JmbWl1MG1KbHlLaE52eVBiQ0lqbnorOUpHNmthYmZjTVExam92cjlJ?=
 =?utf-8?B?a0tpU3E4ZG5XcEdnRkdvYUx1elEvR0xZTUh0RGViS2ZxRUZQYUFnL3AyMUwx?=
 =?utf-8?B?ZDBLOXQ0U3hDMUZ3dEI4MkRUdVQydHBoMWZQV3IwbkZyRTVFU3hPTjhkKzFN?=
 =?utf-8?B?V0xGUzZ5OWpBNjdGaWpjcWwrWk0vVlFGZ3lUZEZFSnVLVlk5cjdSckJJZkNk?=
 =?utf-8?B?cjQxOWhpRGdXb0ZDbGdnd3gya3V3ZTE3aklLTjR0YllWa29Gbnd4TCtlWlBI?=
 =?utf-8?B?bWxKdC84eUhpNG1HS2tKWm1aUGhhdS9qWGtiL2Q5a1pRaGdPYlEydmdTcHh4?=
 =?utf-8?B?VStsY0FwSVg3TWgrTHBTMlhRZTVuS2JQWHo5YUMxWG9rNjZWNXdUdE1HWVBI?=
 =?utf-8?B?Q1lRcFJuMnNjNFpUZk9pR2tJOU1vemkydFJFWU9Ha0Z6Nzg3K1J2YzR5ZlZP?=
 =?utf-8?B?dmRWNng2M2xRRXlrbWl2S0tVVXhVYTRpaStHTVJNTk94ejlHeHh0M3JiZ2VN?=
 =?utf-8?B?aDdFOExDK1FONFRFa3hRbE0rZFdDemgxLzNxL0ZwOUlKQkwvdzN6SkNDa0Rx?=
 =?utf-8?B?L2dWa0pBeXNvSkQzVGlvNDR4cFIycm9VcWZHV0F0QjB6aEpRckRBTVlZbE9X?=
 =?utf-8?B?bVZlMWR3MFQ3QkxuQnhVSUtmVE5RY1JETC92KzhsZVAyZWhNaVJxY2ZUQkti?=
 =?utf-8?B?SlhZczZGUG5JdFNzVHpJZC9PTm5rZWNSeDNWY00wMDA2YWIrWHlzT3p3aVhu?=
 =?utf-8?B?MSt2SFRmTysrMnhBVTdTYlpQbnZ2NEpNWU1CYVl6L2ZFYi9DTGQrc3JiZ1Y5?=
 =?utf-8?B?OWNTM0lyalZSUDQ2UTV3aS9uN1V0UGZwOEEwRHo5U0VBR2RXdk1HdXBpM1dF?=
 =?utf-8?B?ZDh2MHBrczZabHJVRlUyczVHbGdwWERQL2tuWGpUR2h2UzlRdUtsckh4SDNJ?=
 =?utf-8?B?U2IyQXdGV0RacFE4UE1pT1lxMGRtT3dFSUVSS0FzQkg4L0xRZ0s1WFpsSnEw?=
 =?utf-8?B?c29DT2wvTTIyQndCVGhhMVIzTkd3ZEd2dCtwNXgzTE9YTXVDZm9QenBFUlZv?=
 =?utf-8?B?SHMwMEF2eitkczBVenM4Y3cyeEw5NmhZMlpDazRpbEtWcUJBMFNHYlhTWDlr?=
 =?utf-8?B?RlhIbmpGUmY0VWpLcnBiUDgzSmxubGJzNUVRbG5jaytLZHJzNGlHUVVxNHFB?=
 =?utf-8?B?NlBYaWprL1BmSllVelloSEZ2L2E5V25UekIvNVliUHV2Mk1rREZodWRpSFRQ?=
 =?utf-8?B?bVlqVituMnVBTENlaUVhODV4bGgyaUNXR1ZyaVBlTXQxTUJxTXJWa1NnREx2?=
 =?utf-8?Q?rk3qo8GMf49PCX3Dt/+nq6oOZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fa9363eb-48f5-4ad9-c0d5-08da7f259262
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2022 01:20:57.7495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QC0eLcGliQ7yix904WMQqlDeuLsfRMjTYujjo2MJtA7VkqUgjrq5HqkHl6k5dCbRKlAPydYkwTlsALnW5tdk2g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4868
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Jason,

On 2022/8/16 00:50, Jason Gunthorpe wrote:
> This counts the number of devices attached to a vfio_group, ie the number
> of items in the group->device_list.

yes. This dev_counter is added to ensure only singleton vfio group supports
pin page. Although I don't think it is a good approach as it only counts 
the registered devices.

https://lore.kernel.org/kvm/1584035607-23166-8-git-send-email-kwankhede@nvidia.com/

> It is only read in vfio_pin_pages(), however that function already does
> vfio_assert_device_open(). Given an opened device has to already be
> properly setup with a group, this test and variable are redundant. Remove
> it.

But still have a doubt on your change. The vfio_assert_device_open() means
the input vfio_device is properly set up with a group. But it doesn't mean
the group is singleton. right? So your removal is not an apple to apple
replacement so far. Did I miss anything here? Perhaps this removal is good
cleanup but may be done with a different claim. :-)

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>   drivers/vfio/vfio_main.c | 6 ------
>   1 file changed, 6 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 7cb56c382c97a2..76a73890d853e6 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -74,7 +74,6 @@ struct vfio_group {
>   	struct list_head		vfio_next;
>   	struct list_head		container_next;
>   	enum vfio_group_type		type;
> -	unsigned int			dev_counter;
>   	struct rw_semaphore		group_rwsem;
>   	struct kvm			*kvm;
>   	struct file			*opened_file;
> @@ -608,7 +607,6 @@ static int __vfio_register_dev(struct vfio_device *device,
>   
>   	mutex_lock(&group->device_lock);
>   	list_add(&device->group_next, &group->device_list);
> -	group->dev_counter++;
>   	mutex_unlock(&group->device_lock);
>   
>   	return 0;
> @@ -696,7 +694,6 @@ void vfio_unregister_group_dev(struct vfio_device *device)
>   
>   	mutex_lock(&group->device_lock);
>   	list_del(&device->group_next);
> -	group->dev_counter--;
>   	mutex_unlock(&group->device_lock);
>   
>   	if (group->type == VFIO_NO_IOMMU || group->type == VFIO_EMULATED_IOMMU)
> @@ -1961,9 +1958,6 @@ int vfio_pin_pages(struct vfio_device *device, dma_addr_t iova,
>   	if (npage > VFIO_PIN_PAGES_MAX_ENTRIES)
>   		return -E2BIG;
>   
> -	if (group->dev_counter > 1)
> -		return -EINVAL;
> -
>   	/* group->container cannot change while a vfio device is open */
>   	container = group->container;
>   	driver = container->iommu_driver;
> 
> base-commit: 568035b01cfb107af8d2e4bd2fb9aea22cf5b868

-- 
Regards,
Yi Liu
