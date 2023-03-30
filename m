Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 858EA6CFA6A
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 06:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjC3Ex2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 00:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjC3Ex0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 00:53:26 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E928040E8;
        Wed, 29 Mar 2023 21:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680152005; x=1711688005;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=nKH1YH/DqqQk2zQFRFkYjaIzsvKmuX0oes+ey+U+Pwk=;
  b=b7iag+il/IQUbg6reHBAnfJjFzndIcqpzUARYNLvI7pj+hyGKrCgXq5u
   duqZkIC58CT8/qyq5W5DaCbAz+bS+wZv/Ors0feTtYs0IWN5ZZhAZB4pG
   AD/D3a88hk0Qw5KA9SAS1z/vyvQSo7pPcglBnxWyv3ZjUfv2btay69uQk
   UYrIjkQLkcsEA1n5YMff0a3olceyCAzIpY9wFei8qYIDOV8ZY0VQp7Kvs
   pprSu89XUwRGAs28EGPa2O0Gio0lQq0c8QmQ66Fhk9ZHcKnhJ+XMDMSJ4
   yT4VGJpanrwAVKEtxiOBip2IO5R9oy2XF8rjwldM7wQUFPLdZgQ3xvn1L
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="341084520"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="341084520"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 21:53:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10664"; a="684539643"
X-IronPort-AV: E=Sophos;i="5.98,301,1673942400"; 
   d="scan'208";a="684539643"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 29 Mar 2023 21:53:25 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 21:53:24 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 21:53:24 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 21:53:24 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.43) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 21:53:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mR1uUs5TrmalPOd7d4ys/m2t0SevvvZgzvq0tONYgPDqVJkCmLT34hCGCuOR5UmZfpRX6rOT1WgcaDLW1GRWHi8Rz6extNUPvC+SZSkVTQHp9seCOCOiH/onVwuG2EKdMD1N9eJe0op364ajKlxPzib+VITTwaj8XijLgGfhQANRV7jCZhTIeFrcxwE7ShvrJz8Bs/16kFDmyOLZx/IzYwQAFODYgnnkxYlPmcDFX8LrJJM9YhAXF68GyfJsvIHxl5dLt1HdAON6iXESr4KdsN+SkYgk7SSxzdOQsymKDlZddXEnJSo2JKpGFtvs8OYmeqarr0TUo4eVmDSzzJzaug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qjPpsCAyZO1GUovH3FYDI2bRlnFDwEQ0wA06jj56BB4=;
 b=oHApUU6STSj6dOQfHCrTZjOZID5WNsg0kH3ZfES1tdCmGEjNPtL5u7+YkmdQrdgUy57vgC3+wGDYAOEX3RHrUu6tfZnEdrolUUTXTW3OETou00+r1aPBft2RjbvByqn2M2LTS8TSuFWHKkWdbu7NysfD+IM5+sHK77JEsjKJOmmK86435RAsd3lBA/EaRAn9FWc/byhwrx8GvHoiIEPPAIM9OwQTwCfK/BtZifGQu+i0FXDI3QKU5KxXs14kBE3cMHgUVbgZqRrldbwcHv5YI9RSFL3ngYuGxCdfz72/KRGDsiHsWSkdelBPZwt4ykVW3o9T+tEBZ8Q5RtPm6QRBKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CO1PR11MB5140.namprd11.prod.outlook.com (2603:10b6:303:9e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Thu, 30 Mar
 2023 04:53:20 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::47e1:d7b9:aab:dada%6]) with mapi id 15.20.6222.034; Thu, 30 Mar 2023
 04:53:20 +0000
Message-ID: <ecd28c71-6f3d-d5bb-cd39-ab80edc549ab@intel.com>
Date:   Thu, 30 Mar 2023 12:53:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [Patch v4 08/18] KVM: x86/mmu: Track unused
 mmu_shadowed_info_cache pages count via global counter
To:     Vipin Sharma <vipinsh@google.com>
CC:     <jmattson@google.com>, <mizhang@google.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <bgardon@google.com>, <dmatlack@google.com>
References: <20230306224127.1689967-1-vipinsh@google.com>
 <20230306224127.1689967-9-vipinsh@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20230306224127.1689967-9-vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0114.apcprd01.prod.exchangelabs.com
 (2603:1096:4:40::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CO1PR11MB5140:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d0cd2c3-474f-4c50-2a6e-08db30daae92
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b1meXaVVUsWnk00gpmlxiX/UQ/kaCuGJRvG9e0YwVrF6QjKevWyUjp1DMhmS9FU/F++Jbns4/M0ZcppUSiuT/CxPxG9En76B0C5dAUhkY9blcyZdlD90GWcgTrpdOy22pCMP6hPE3OIyzA37RvMDzBR5c6tl2Lw/ujTsWs4TQ0jkDhgnkXG3u5xf6hhHvBdWX54LTUu/hwAOthdBz8pJao24NHexEW+23Q2nzvaxdBkTCQPnbMeEAj66sySNon6IR3BLuv8ceBSaWqpTJvava5M7e/OssxaeTzLBtBlh1an85w2JuCxvbiOHmp0UntR3Frl6O6JK0qi+NDAmVKYyp/QovhMoeO5w9gtWfAZVj0g6ZvWMH1yzzbB57Ji8sjIRTVNrIwXLGMKNE2Ya6K+GolEk5rUJbJLjvRr3q6akyAnamcMs+vFCplpvG8xb0Jg+XcTRGkf14erUSdmTWs01phH44IOBQmG00N+cZ/M4nVMX7lCxuA7jiE+FK5dG15OIeoXQNYlqiqxAF4pLPyz5oh0hNKDhHRnJRJ8b54Vn3mnSvcshY8hRDzodxAlV58MvwCcvFSqbHAbtuWEcKF+/C1L8HiyXVYu3OCPMpmMvK4y7Ji2PhVipXy3HbW2mlpuugFNJMqgvlVxh1nNKuXcTQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199021)(86362001)(26005)(66556008)(4326008)(6916009)(8676002)(2906002)(82960400001)(41300700001)(66946007)(66476007)(316002)(186003)(6512007)(53546011)(83380400001)(2616005)(6506007)(31686004)(478600001)(6666004)(31696002)(6486002)(36756003)(38100700002)(5660300002)(8936002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlZabG1aVTJ2UlNteGhaczZVdGYwTUc0eU1Nakc4b0pqN1ZhNU1Gd2N6SmM1?=
 =?utf-8?B?aG1xNXhOTTFJNFZWdE5aYXJnUEdkTnZJbmxhUm9XK2ZaeHF5aWxVRFBFT1NE?=
 =?utf-8?B?c3Z1K0xPRXM5THNHTnZPOXRrNkNHVXBqNlc3T3RiajJRZjdSMUVjWk1ranBJ?=
 =?utf-8?B?akx5V21MemJ6SkRMWnpWcmNnNjI3YW5YeGdGSytxaktpVU5TQlVkNi9ob0FT?=
 =?utf-8?B?NXpCbXlOUWtGZzVkaW9XZEQrYVluOTYyYW5XaEJNNkRkQ21rZWFmZFVTdUl3?=
 =?utf-8?B?b011NU9vUzRmaTZyTk92NEEyRWpTSGxPcFdmSW9HaFcvbjlVOFgzcUI3d2p3?=
 =?utf-8?B?TkJxM0UwcCtuRGhEUWlkaCtiMXNvdjNFWEdhaDhuVm5HaHNEMWVZSUlUcHBt?=
 =?utf-8?B?cW53RGZkUDZOQ3NuWWh5VFNPQmFVWGkvWnBHTjFNb2JsczJTRHV4dlZDZ2ts?=
 =?utf-8?B?ajBPTG9QYVdzdnhJYXBzWDQ2a0grKzZ0SS9BelJkRHgwZ0U0RTNLMGs1d1lR?=
 =?utf-8?B?NTJjSDdOamJZYzBiUm0yT0lsTzlySS84bTBlZkhNVmlReEdDbldleThxSWdl?=
 =?utf-8?B?b1pQNmVPMFZTc0tzb3IyRENOS25XSS9RV2g3cVBqOGphdUpscFIzendaSmJz?=
 =?utf-8?B?NVBJSmYyUE1zUGpaNkVmWHdzWW1scDd6RnEweWxwWnozWlB4THR6ZWZjY1pN?=
 =?utf-8?B?dVFtdVdiRnJlZytCRlVMYkgyMk1wckpTVFFqSi9CUHJSdW1RZWhiNW9ra0VD?=
 =?utf-8?B?d3BMLy9yYUZQdm15ckZjT3VpZStUUW1ZTzM5YXNHbnNpbkM4UVY4N1VIK3Y0?=
 =?utf-8?B?NXFCNEFzNjZTMWoxd3UyaWs2bFVHVFNmb2lROWhRSjFEL3ZXUkE1YVlLOXhN?=
 =?utf-8?B?SHV1dEpOaHNkSXRVbGdOdjRDNWozNm5nbE9uTjhvM082S2hUYmM4aU91b0R6?=
 =?utf-8?B?dzJIVmdhWlZwNDZ6S2dWTWkxajVhZ0N4UDRXMEkzbHNwT05tb3h3TEs1Wnlp?=
 =?utf-8?B?THBUanh6WnkvRmg1Q2ttanpEZ1BpNE9TWWVvaVJ3VmNyZVFIWndZWXovbVdj?=
 =?utf-8?B?WXYvZEVicjBtZDVHdW9nUit0SW0wMnZydE14Q1ZyR081RFJyTVZ4Q0xSNC9Y?=
 =?utf-8?B?Q3grcGh3UVYybWJaa2JiZzlvNFFkWHBNQmJsbmh6Q1JDOTI3blVWSUdkWEZr?=
 =?utf-8?B?OXRYeHdQWmxGSWkvbGpEMWpGVU9JTUZuZDVxNlNXWlhHMEd4Ulc1YUlaMCta?=
 =?utf-8?B?VjdDVmJvQ3JmWjRXU1hzUlp4UGhDMEZmRXRMRGJEVnJrNDcwVWxFa1VaNkQ1?=
 =?utf-8?B?V0ZubVFxYXk4WlA3NlF5RVV0SmIwelluTk9HcHF6UGNwTk5reVFLMVVoRE5T?=
 =?utf-8?B?bjI1bDg2SUhoUVJ4b0tJbGNFaU5SUXNiOHVKTUc1Mi9mYnJmRUZFZkxUVkJw?=
 =?utf-8?B?RVc4QzNVakhtNnFEOUxNNk5YY0ZNSGN5NTluaGpCQVVkd0t5Z2RlNklwSXNF?=
 =?utf-8?B?bUs5Ym93cDdDc2Iza2pEZk1qdFRmRHFyQ2NQb1pvaFhWakFBYWZ3alZvNTdL?=
 =?utf-8?B?Y0todlMwY1BHWDNFK1F5QkRKSWJCZlpXMWdmNlBPUWs5K1pxck9Xdll2R2Zo?=
 =?utf-8?B?cytmTG9TTmljMytjTkNlNHR1U245ejQrWGJUTGtmcWlsTXlDZHdtMnB1SU0w?=
 =?utf-8?B?REtPZ010Y201UkppbnU3SHlBdGV4dmtsWVNWN1VEcHR1RDR6dWVqYjRvRmU3?=
 =?utf-8?B?SmFuNlpzY3pOQ09WakR6TXJIaDJlL2l1RCsxcWNCYThFWmpoWHh6cUlZL3M1?=
 =?utf-8?B?dzdKc2R0eFYyL1EwdTJTWVludjNOd1lnbEpta1pSbHZYdWhkSWJ1clduSWtT?=
 =?utf-8?B?UkdSeTBrNGUvZnJvVkdweElCNEpCQk1yWFcrT0xpRVJRS0xIS3hhVmRiMXRJ?=
 =?utf-8?B?UnRaU1lZMG1CUitrRksxcm9mejIvbUtXbHA5SjIzdysrdGc4NEZSK0Y5d3Rw?=
 =?utf-8?B?MTJpRU9ER2kzTVFjdTZ0MTNsTjhscTBXWnpLSS9xOGEwYTBaM1ZBcEJ0Vk8x?=
 =?utf-8?B?Y1g2cmJibmprZnQ3bkZObHo0S1pWbGR4OWRXOUdhZnJtVmpnejBPL3oyT3dw?=
 =?utf-8?B?TkpjaDZic0thSGlWUXUwRTV0Nmp5VkkyY24wanE5aS8vVWVnSk1oczcvL1Zp?=
 =?utf-8?B?Ync9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d0cd2c3-474f-4c50-2a6e-08db30daae92
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 04:53:19.7999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uj5G5jk+QJ9Vu/LJ7SJ96b3il3JuhYthndnRRwahBUXBE1FVGkOLrui4qVD5Pepfgw8N9EXOcAIv2645EyfCRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5140
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/7/2023 6:41 AM, Vipin Sharma wrote:
> Add unused pages in mmu_shadowed_info_cache to global MMU unused page
> cache counter i.e. kvm_total_unused_cached_pages. These pages will be
> freed by MMU shrinker in future commit.

This patch mainly renames some functions,  but the commit log doesn't 
reflect what

this patch does. Please change the commit log or squash the patch.


>
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 3 ++-
>   arch/x86/kvm/mmu/mmu.c          | 8 ++++----
>   2 files changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 4322c7020d5d..185719dbeb81 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -792,7 +792,8 @@ struct kvm_vcpu_arch {
>   	struct kvm_mmu_memory_cache mmu_page_header_cache;
>   
>   	/*
> -	 * Protect allocation and release of pages from mmu_shadow_page_cache.
> +	 * Protect allocation and release of pages from mmu_shadow_page_cache
> +	 * and mmu_shadowed_info_cache.
>   	 */
>   	struct mutex mmu_shadow_page_cache_lock;
>   
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 0a0962d8108b..b7ca31b5699c 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -715,8 +715,8 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
>   		return r;
>   
>   	if (maybe_indirect) {
> -		r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadowed_info_cache,
> -					       PT64_ROOT_MAX_LEVEL);
> +		r = mmu_topup_sp_memory_cache(&vcpu->arch.mmu_shadowed_info_cache,
> +					      PT64_ROOT_MAX_LEVEL);
>   		if (r)
>   			return r;
>   	}
> @@ -729,8 +729,8 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache);
>   	mutex_lock(&vcpu->arch.mmu_shadow_page_cache_lock);
>   	mmu_free_sp_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
> +	mmu_free_sp_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
>   	mutex_unlock(&vcpu->arch.mmu_shadow_page_cache_lock);
> -	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
>   	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
>   }
>   
> @@ -2197,7 +2197,7 @@ static struct kvm_mmu_page *kvm_mmu_alloc_shadow_page(struct kvm *kvm,
>   	sp = kvm_mmu_memory_cache_alloc(caches->page_header_cache);
>   	sp->spt = mmu_sp_memory_cache_alloc(caches->shadow_page_cache);
>   	if (!role.direct)
> -		sp->shadowed_translation = kvm_mmu_memory_cache_alloc(caches->shadowed_info_cache);
> +		sp->shadowed_translation = mmu_sp_memory_cache_alloc(caches->shadowed_info_cache);
>   
>   	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
>   
