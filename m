Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE427645E00
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 16:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbiLGPw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 10:52:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiLGPwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 10:52:11 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE5D63D74;
        Wed,  7 Dec 2022 07:51:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670428302; x=1701964302;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vbYSxS1Ceji0zDYMwWachwh/WMw1as7TdPoy0yu61J8=;
  b=Ik23cWYxsgSctteJey49d3X676DnXety65JX5OBrWMO7VU2dIbADuyg+
   9qYCYX88lnzvkvTAmR9t7s1QSBveQ3BOb9n2raf3abOssyMJ/xoY2c2+A
   O5wAFJLk+Z+PST+RKAdIoCAFNxdnEKr1mKXje1KowDlrKkIPm9lk/Crcs
   JufQ6PjlkFlDS1cM1b6YoK0+MNDoEaKJQRNksOrBieQ9FovP7GIrlWMqv
   OHKjfvxzc/Qc3eQH0Sr21plJk3/qczNxstRqS2lqItTyVALDRfWI3MnMU
   UsMsx7wDtgeO0/beWcNvPQZL4PIZDN5FiVS3sLSYjFOviwOiMZ9cK5w1S
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="316937259"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="316937259"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 07:51:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="891847595"
X-IronPort-AV: E=Sophos;i="5.96,225,1665471600"; 
   d="scan'208";a="891847595"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 07 Dec 2022 07:51:33 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 07:51:33 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 07:51:32 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 07:51:32 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 07:51:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ewQMHboL7pMoS77yzDz0S3t7nucCvHPNuH69Nm3cbyNiDVzSLsVF8jS2MaXNy46wMbI9yhEgRv4o++RgeimMjCI7IzbKD0kaRRTN4vc9IcFYtx5btCYF9fK6bRK0H9PFWOAw4NAt86P5jo78/bB5ytVeLSX0iMxYuXx9bKY55efIQG8eYg0wMpZ5jYRlF8gvX/aNo41b3kN/ABQCcnpPjQ4E8jiqqZs04LYhQ/GJR8CTy3Cll+dvPTPkAGDIxGsNJAWo7ZPWs5uroyIhjcrMBOBxk5PJrObiiN0v0UBC9YAZ3GgDOlX9mVcNb7WWq7AKu2Fpljda7OzqFwQynyAFrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tY4EH0kMIMGKjsqSE02vE/dcg9KRok72UoIUPG6YgLk=;
 b=jYUCF9VgAbo2gVpp1QSnSfy+4h11T6/8cv4GFD+rsJf4LQfSXkMSMx7xvZiR4blMmGnzm/7/KVOJeX57BfNoStTkwu8dKqHhpgUMphD6QR7j5L5L12uevxRLPwmkl1XhQSiX2p8IoDj6t3qlvEO9waRCICBek7ONQRdQpQrVKqH12px3DV5J5KiwIx210k1jDnQio+C5FsYkWFLnhXEHoPhPwwZbESIA7EBqr8pa/ZwUXhKFF6TKxhbDBmSjocSZa1k02xNDEiiFgh+7saqfFdydxpJ+FH4ChmNUkpaFjg/SQPby8MDE9f8fazBtmjoCYZnvgGd1oZhq5yj9wjj/ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BN9PR11MB5499.namprd11.prod.outlook.com (2603:10b6:408:104::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 15:51:27 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%4]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 15:51:27 +0000
Message-ID: <02d4cf57-236d-ff0b-078a-d6ced6a2dcde@intel.com>
Date:   Wed, 7 Dec 2022 23:51:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH kvm-unit-tests] x86/pmu: Add Intel Guest Transactional
 (commited) cycles testcase
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20221207071506.15733-1-likexu@tencent.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20221207071506.15733-1-likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG3P274CA0006.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::18)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BN9PR11MB5499:EE_
X-MS-Office365-Filtering-Correlation-Id: 76f040ba-4ec6-48de-d747-08dad86ae67a
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O9VFjnLCXzGSIF3Spmhul2JH+Td6jFR4Fm3pUqJSIav6K5tEgYyS4fU6kCurrM083+G1sS2wOKLfRCDUEF+Y9PBPTnQ4RViS5osLo/xQRa0yyRHNBLW2P9fzun+0EU4rVeqpbO4DeLucCs7UuvaS7OfrnZT6n8db+x0YUtSmx4YZAFQ5bmczEuF3TxjFlmey8cCbw7aV1IgOSZd3PHr6mKjvyOSNAGH0HN86A6ZT1G0hevOzU5QvXuzfYG5AZq/aNDPOXPBiCgsku2CrZHhLxGeu6eF/87Af4J8I8v3U9UhbMK+664Y4LimHk11Jsj5iFWeM1VlnKVKeqL+AHjfMeANHa+Ky+XrFJsNPKbgMmGOJ7n4U9ecWduB3dvXasgTQBlHtK3NC43uiCIXTs0okiZDCAOjQhbTxZZfCLMku5c2Uj4M91LIs00YWpfoTVXNFJFDZzpHQ9iKGLBow8ZMTWwV+od3fclveejqG22WEDs/7FcdDaEWMIKugCAt4mKkwvXa0ta4MSVDsMMp5eGyiaTuAYwE3Z6DEafF6rG1gBv65Z+VBpIBiXJcdsg2Z8DY4sItmFbMr/CRN7t7bfaoCtzTcsCDkBNsefK5zZRxZc7+ntBpCEFgpAyxIqA4CaGPsz9fNgvowsG0E54n6hZLrvHNJGnrk+TYazAtTndec0OrQwEhkRa99x6N+/zMC+77FhI9y6uGAQTrxG+GLa6yz5iiqOpgAhpiV0P35NVGJLxc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199015)(36756003)(2616005)(6916009)(6666004)(26005)(478600001)(41300700001)(2906002)(6512007)(186003)(31696002)(86362001)(316002)(8676002)(4326008)(53546011)(66476007)(38100700002)(6486002)(82960400001)(66556008)(83380400001)(31686004)(66946007)(8936002)(5660300002)(6506007)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cnAwNkRTT3Z3Z0M4MkFSejBZSHlEWDcxWTRvZE1LMUx2ekE5RnBkNktKenBW?=
 =?utf-8?B?NFNzSm1ORmVYOVljUjZEQ2psejkyMUY5VjJ5MDFoaUlCd2tFcUZzaDhTSW5S?=
 =?utf-8?B?YkdSYmx1M3BrUzZQcE8zaUVKUTJSZ0tTVlJXMXg0U1BvVG1DWmlna1hZTERr?=
 =?utf-8?B?TzNKaThTbkx5ck10bGtOcWRPeEVkK0NnYnN1NWxRcEhmaGNZUWJta2tYV240?=
 =?utf-8?B?K0xaczVWNW1Ccmg0aDdDS2I4cmZJL3kxK2VTbmlZRGU3b1Vtams1VmlXMjVG?=
 =?utf-8?B?TXlNcG85NTRJZWN6eG55NGJtN0JLYzBVd2dMN0Y1MDdjczFBRmgxeUxMRFc1?=
 =?utf-8?B?eVJwU2dDV1N1QjQwV05FSWtXeWdTRE1QVmZUYmI2WmViaXdsSU9WUkFMSkVG?=
 =?utf-8?B?dlViWTNOd1U4K0N5c1VQTDZyTXRyeEEwbCtya1VLQ2RrMmlCSE1zQmFSTE53?=
 =?utf-8?B?ZmV4N1hlNnZjREFOcG1Gd0JLcVllVW1aRTB3MmZtem1WRVhoZjBuMGlTTWpi?=
 =?utf-8?B?N3dkTjI3VGJ5MEg1RGtQZ1lLOHQ3UTNZdEp6Tk85dDZhN1UyUFFVMzR3c2JB?=
 =?utf-8?B?eW1YNkZtdG0xeGRLWWtmS2l0N3VEWHVrTTNYMkkxaW9pLzhSMTl2dENYUkpE?=
 =?utf-8?B?eEpHUTYwcEJvTmZXeFVSc3oyd0hPL2VKUjRDRTNiUDlER1lsZVFYekdLTjBC?=
 =?utf-8?B?RVFTdFNNREZMNzhWcjY0RkJyTU43MXFwVlNYUEZINnBBTXFSRnNoaTJ2QXJZ?=
 =?utf-8?B?OE0zdHQyMXlLR0wxei9KSnVpa3lGVFZqbHFXYzFCck4zQXZxNXBBRG1PNGkr?=
 =?utf-8?B?MlVacnh0YnhwaDEvbVlTTURMcEJnUlR6TnBOREc1Y1lzbjNmQlp3NUVnVHgz?=
 =?utf-8?B?TVdoTnRkNkd1bk1HSk43T1UzVnp3S1NueHdNMkl6NnF2UWFqT1RzQWFLTnd3?=
 =?utf-8?B?dnJFTFBydzJ0L3IwRVlEMWJBVEpwWm9SZHgyTC95Q0RXVkoxdTRKVWhYRFZU?=
 =?utf-8?B?NGZCOGdPVFdEMWo1OE9GZmpsMmxvbkV6RzV3c09ONzV0UVdISHVIb2VRTXhr?=
 =?utf-8?B?L2FKVitOVDFSN0E2SWgyZDJncXlOUk9DNjRUYWFYbEY4VEsvclhDZFJVb1ph?=
 =?utf-8?B?d0o1V2dIRTkwTW9zVFl6UzNhMC9DSnFtVHE3anVLUTRObUw5RHRVRnZPaHlu?=
 =?utf-8?B?VFNweVhhcTc1TXBpcGw3TkdjVk1IQ29jYnUxenB5TjZzd09jMmJsQWhOcDVB?=
 =?utf-8?B?c3hBNzgzRUxsMEdLbms3bWJ6b2NFYWRwSFJkNFoxMG00YmQxd0lJcWhENEhM?=
 =?utf-8?B?N2NtQ3d0bm50RnVpc1lJYTV3SmN1NXBsZG9FeTJRSGFZQWFueXB4c3ZvcndS?=
 =?utf-8?B?Nm5pT0tNTE1TTENDMGE1YVdvV3Q2UEF4R0NGSm00Q0NCNnltMXI0RElsUlBF?=
 =?utf-8?B?RkZGK0gvTHJmY3puOGQyTk9WQlZVbk9TcllzRjlXd3R2YzRxSmJYT2JjcFda?=
 =?utf-8?B?ck85dXQrL29oYk9HVkNkeExSa3VPWXpBeTBMbkFXZU1sNVNUV01ocjNKSTBv?=
 =?utf-8?B?YVNQandUYjkyTlgwVm43ZC95QnlJc0FSSzg4V3plMHExckNYMFJPdDNlcFJC?=
 =?utf-8?B?UkZSWXhwNUZhSFNBVFZpbWZVOWx2SzdScXhsQkwyMlFvVThKUGVpU3U0UmF5?=
 =?utf-8?B?WmFOUHJTbHhYRkJqVlJrK0tqUkQ4NE80WXplS1gyeVAyQi80Sk5BVEpIQ0xJ?=
 =?utf-8?B?aFZVeis1L2ZIdFhPWUlDcjVqYXVkaUVHa3NyOEhXeUJKSnlnMDIrNUxuY3RM?=
 =?utf-8?B?TkZ6RVhPTnpQOENmR3pKZGdQaUFzVFg1QVQxenJRK2lZTE1SakRldEEwekh1?=
 =?utf-8?B?OGRLdGZ5QlB2UFI3M1ZvdURJTDJvMEY3czVZbkREbUtUOGZhelQrY3JoSFls?=
 =?utf-8?B?Y1RVOUVnQXZSYVJEaUIrR2dOeS9XamxaK09tbG5FWisxR3BxZjFBa0o3NlNC?=
 =?utf-8?B?RktrWldWMGlGQXhBMmRFblVNKzUzRHBmNzZuZTRsOVlQRmhwL1lYZUFsc0dK?=
 =?utf-8?B?MVVGRG5meXRsdEtRSDlQMWljVmxMSStVSnhsZGZSck1NMmRKVE5DcHZja0pW?=
 =?utf-8?Q?GgLG9Lu8vNtLOk9D+FUhDhULh?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 76f040ba-4ec6-48de-d747-08dad86ae67a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 15:51:27.4882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p1oZ9WYgpsq15zxVt6WBosapeody9+GOfUNOYDLvRTgXdHg3iup59VOVKtlPExUHAQky30wLhpXbGsQpEfiTCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5499
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/7/2022 3:15 PM, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
>
> On Intel platforms with TSX feature, pmu users in guest can collect
> the commited or total transactional cycles for a tsx-enabled workload,
> adding new test cases to cover them, as they are not strictly the same
> as normal hardware events from the KVM implementation point of view.
>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>   x86/pmu.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 72 insertions(+), 1 deletion(-)
>
> diff --git a/x86/pmu.c b/x86/pmu.c
> index 72c2c9c..d4c6813 100644
> --- a/x86/pmu.c
> +++ b/x86/pmu.c
> @@ -20,7 +20,7 @@
>   
>   typedef struct {
>   	uint32_t ctr;
> -	uint32_t config;
> +	uint64_t config;
>   	uint64_t count;
>   	int idx;
>   } pmu_counter_t;
> @@ -547,6 +547,76 @@ static void check_emulated_instr(void)
>   	report_prefix_pop();
>   }
>   
> +#define _XBEGIN_STARTED		(~0u)
> +
> +static inline int _xbegin(void)
> +{
> +	int ret = _XBEGIN_STARTED;
> +	asm volatile(".byte 0xc7,0xf8 ; .long 0" : "+a" (ret) :: "memory");
> +	return ret;
> +}
> +
> +static inline void _xend(void)
> +{
> +	asm volatile(".byte 0x0f,0x01,0xd5" ::: "memory");
> +}
> +
> +int *ptr;
> +
> +static void tsx_fault(void)
> +{
> +	int value = 0;
> +
> +	ptr = NULL;
> +	if(_xbegin() == _XBEGIN_STARTED) {
> +		value++;
> +		// causes abort
> +		*ptr = value;
> +		_xend();
> +	}
> +}
> +
> +static void tsx_normal(void)
> +{
> +	int value = 0;
> +
> +	if(_xbegin() == _XBEGIN_STARTED) {
> +		value++;
> +		_xend();
> +	}
> +}
> +
> +static void check_tsx_cycles(void)
> +{
> +	pmu_counter_t cnt;
> +	int i;
> +
> +	if (!this_cpu_has(X86_FEATURE_RTM) || !this_cpu_has(X86_FEATURE_HLE))
> +		return;
Since the test case is for xbegin/xend, HLE check may omit as it's for 
other X-instructions.
> +
> +	report_prefix_push("TSX cycles");
> +
> +	for (i = 0; i < pmu.nr_gp_counters; i++) {
> +		cnt.ctr = MSR_GP_COUNTERx(i);
> +
> +		if (i == 2)
> +			/* Transactional cycles commited only on gp counter 2 */
> +			cnt.config = EVNTSEL_OS | EVNTSEL_USR | 0x30000003c;
> +		else
> +			/* Transactional cycles */
> +			cnt.config = EVNTSEL_OS | EVNTSEL_USR | 0x10000003c;
> +
> +		start_event(&cnt);
> +		tsx_fault();
> +		tsx_normal();
> +		stop_event(&cnt);
> +
> +		report(cnt.count > 0, "gp cntr-%d", i);
The purpose is to collect total cycles, why not print out the data here 
for each GP counter?
> +	}
> +
> +	report_prefix_pop();
> +}
> +
>   static void check_counters(void)
>   {
>   	if (is_fep_available())
> @@ -559,6 +629,7 @@ static void check_counters(void)
>   	check_counter_overflow();
>   	check_gp_counter_cmask();
>   	check_running_counter_wrmsr();
> +	check_tsx_cycles();
>   }
>   
>   static void do_unsupported_width_counter_write(void *index)
