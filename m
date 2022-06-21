Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 546C4552991
	for <lists+kvm@lfdr.de>; Tue, 21 Jun 2022 05:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343763AbiFUDAV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jun 2022 23:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234350AbiFUDAT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Jun 2022 23:00:19 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5B061BE84
        for <kvm@vger.kernel.org>; Mon, 20 Jun 2022 20:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655780418; x=1687316418;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+wcWzOlwsv0FaKXzLVAdgUJgY8uIdoNSQb1THndqcYc=;
  b=TQOu/F6Ki8/864gQyvqog+QlqPV2O2jQeyrgNwPZGIZq8Nj0jzQC2Dz7
   jFXw5Z3U4AUN0FLU6xYajpH6kbo6OOj8vPMDA00fnHRUqTnrHyMMk0jHn
   uHtyvAj+6M7kDVyThIMgGO/FKe4Z+t+MpQpFVWNgefMrJHoz2DJF/HF2f
   X6hqjfITj/taHRFEDZxbAIAPjYcxO7/einqw/X8iIWeWVvzmo30CAbQzc
   G8EZUEzKbrwI3zOutT+KHDHOjaLlI2wuKMZV7kh8QOOm/ijF/cHIW+Cb8
   y739GZpqYj12UdvGQK6e2x3vqro1Zivh1ZmR1pbWhqcv1c2nwv8vKKFcv
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10384"; a="263045023"
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="263045023"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 20:00:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,207,1650956400"; 
   d="scan'208";a="654941295"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 20 Jun 2022 20:00:17 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 20:00:16 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 20 Jun 2022 20:00:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 20 Jun 2022 20:00:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Mon, 20 Jun 2022 20:00:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKusd7xFaEZNskB61RJ5cFAoE5ciqA5H+yW37OLcsnxaDymC4m9Sc2dUbSmZ4xHF1u9uC2cp9F/q6GNkTqzUeX9PWcrM3YwkzesOmsSrrUTir800xABzd7HIXVO46kTRIezmR5ZscgLmsOkDCYAYlwK3tDqsvGE1ck7ZdrlUuSD7Mz5AvKGpNCS8qgoalj1xHy78LnEjz5ENsmFEIwcLoJ2BJM67v3NgJ1ys68IPf3Kz2LIcxkTz2jwkIdT61N1Ghbtn8b0MJAAVitgZWRQcMUlmqESrLIb9+xIDVEyfPUfeYfWudUlE9aPzMZiT3BqzCmpw35j1kFcLHj2nVE4JgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9LGcnY0tZjLtXIuAjj+7R6x5o5JtLDuhFfz8r9Yjfg=;
 b=GWwq68M1TL+CaFHQDcgA83u339iexuBf2CzhEEV+vWIPQ+CuosO4eShFk7CELhnrL/Mq6HkXs1NbTLMMKsotqmjs6IPi5NAryVUgG12+V2DvRu0AoXsvPuA5W+ky/eTF/0bVfeLAI6v2mf4A5BfAwY/kXVUNU5yhMiTHu/8cSEMoE2A09YWvUz/gs7CcdY9oefMojBLQdb2suhFt+es67ECrLRxkTav56HGxHdl+fGGZup2XDriHVjn5Ec+BjdpPOjtvtihoe6Y5NPcsxU/NnV71DDyvgGlXBgMheatYZtQZWjNZ9nIbKbu6vxeyVAnZb92armYj/bDq4aNAYrKS5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5658.namprd11.prod.outlook.com (2603:10b6:510:e2::23)
 by DS0PR11MB6445.namprd11.prod.outlook.com (2603:10b6:8:c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Tue, 21 Jun
 2022 03:00:14 +0000
Received: from PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::10cf:116a:e4c:f0f5]) by PH0PR11MB5658.namprd11.prod.outlook.com
 ([fe80::10cf:116a:e4c:f0f5%7]) with mapi id 15.20.5353.021; Tue, 21 Jun 2022
 03:00:14 +0000
Message-ID: <e0ee6ed6-51ee-8a6b-5bc6-307b0df503e7@intel.com>
Date:   Tue, 21 Jun 2022 10:59:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.7.0
Subject: Re: [Patch 1/1] vfio: Move "device->open_count--" out of group_rwsem
 in vfio_device_open()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "jgg@nvidia.com" <jgg@nvidia.com>
References: <20220620085459.200015-1-yi.l.liu@intel.com>
 <20220620085459.200015-2-yi.l.liu@intel.com>
 <98a0b35a-ff5d-419b-1eba-af6c565de244@linux.ibm.com>
 <39235b19-53e3-315a-b651-c4de4a31c508@intel.com>
 <BN9PR11MB52767FD0F8287BE29E0C660D8CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB52767FD0F8287BE29E0C660D8CB39@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MWHPR14CA0040.namprd14.prod.outlook.com
 (2603:10b6:300:12b::26) To PH0PR11MB5658.namprd11.prod.outlook.com
 (2603:10b6:510:e2::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a15165e-5458-4997-d1a2-08da533229b8
X-MS-TrafficTypeDiagnostic: DS0PR11MB6445:EE_
X-Microsoft-Antispam-PRVS: <DS0PR11MB64452EA183F3AC046041FD2EC3B39@DS0PR11MB6445.namprd11.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yKFM81eRJDjzONAr3/3/QrHeKXMCMbjaffBRtunN8df2rbsS2+t2nLjEozrnDSjow40FRD+YWigwwMoPGn/SeybgmJZpUKigCPFmbgsWGqOd9j7ew2ucgK8euMcPvYm0Xda398/mKy2sSh7R28TKCHyDHkOd01OGRkbsPbaCZiWjVM4+l9tUB07mdoHbbPzG9rzgX2Wwe8vE5fDck6wg5XMY+WwHcSY0vl3Qbn+SDmWM8fBecfSzyYFcqFhzRaFR0V5ajb8FGp4IW9CGdntSXk9L9pF3armIvjcZldItYLwdyRwKXdW0PntdA3JSuWlf8S31lRzGtLp232oHiuvPWM4hcvp1nplBXYhSsLhalRAc+meZICME36vQgHQiDMTExyvRXBC+kVLKRvruekXGb/FCLHmaqXIZQAu/k1MchhJLCD/iG9MeY1/Qz0+Ee5CKqpmggy+DhMXPczfXOTitQBDlP2M8UcAG+2ebsHE3uOnRFAFc90g9uoPMxZaFVUxAEl4kMQG2Wxae4cUWVj2Q54KRkOy+njIvNGZPTMMWx17LaIfAqRJRZLjtaJQYG925qxLSVTeS1JzL4uOAmhUVfdRnKvpUnF1afAt6gx//eGVzg5DJsgfTV60CYwDZgYamteMpva38tSBb5N5eGkDDLfhQhfub+OFKdbkX9yEOohC1bOTd8YKmDYNHcw1W5MNCGiFzog6bDxtD8Sx4LBk84/IeUc88xQaPtr1Ak22d6k8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5658.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(136003)(346002)(366004)(396003)(66476007)(8676002)(4326008)(110136005)(66556008)(6666004)(31696002)(54906003)(186003)(41300700001)(38100700002)(2616005)(8936002)(66946007)(82960400001)(2906002)(478600001)(36756003)(6486002)(86362001)(5660300002)(31686004)(26005)(83380400001)(53546011)(316002)(6512007)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YWgvT252MUl5cGhRS1lPZm9iaFJkU1ZQbFVwYk5OaEdBRmN0amhJM1BPbnVq?=
 =?utf-8?B?MEFzNnkxNnUyYXhmRjBKRE5tRkJBbi8xblZSV3E2ajhPQmJOYlA0WkV0WGpF?=
 =?utf-8?B?SUNIOVZoM1VBVWJOQ0kvamY2a292aWE4eWg4bURxWk5DLzNVZUFYa1lyVTQ5?=
 =?utf-8?B?dXQzU2NrQjd5aDd3VzBTY3I2U3ZoTzQ3Z3FxbEtWS1BhS1l6K0Rtc3Z5ZUxp?=
 =?utf-8?B?WFFCK056UWkwbHF6YmNJQ0RYanJwMGUzU1FkY2Rsb3NVM2c4aUF4NFozcnhp?=
 =?utf-8?B?Tk96WDd3Qy9STlJCTmVNamZlRW4wQnpaTDRncUFFb1BGek9FcTdqVE9KaW9j?=
 =?utf-8?B?Ly9oZ1NsbDErczhDYVJIWDQrZm1SaHRxSEVRSEJvWUdjZDNzSWM5UTRUcHlx?=
 =?utf-8?B?RFRZRFlYMFZNSmdPNW5aMkdWMit1djhKS1hzbTF2dU1FckVYTmpBWmI5VW5R?=
 =?utf-8?B?dzZSbzh6NkVoME1WcW03ams1dG8vc1hCd0FRZExURWNIT05ndWpQYlg0anpa?=
 =?utf-8?B?Wm5QZ1VjMEg3WXhEUXdlUjNTenRWcHovV05pbnpLdHNkTndOT0JFeE1mYTFR?=
 =?utf-8?B?REROWG9IbElWakZHUDVUOGNvRzJaRTl6TGhkWkI1aktRRFZIRHNDcXFGdDJk?=
 =?utf-8?B?aXE1QktZODg3QWZ3aW5CR3AzYlVBSi9JRVc4QXdscngvempGNTBBKzQ5OThV?=
 =?utf-8?B?RUowbm5WdENxd2tOSjZVV0k3Umk2YmE2M3FaNXczQVAwS1JDRDRMTDJjbW1r?=
 =?utf-8?B?UWdmenpqNlB3YnlGUEQ1WWJ2VjhITE5oRVlWU0ZTZTJHSHkyS3M5bXU5b3lq?=
 =?utf-8?B?S3JwZ0ZkaE50MjJWVlRrV0tPNzZKaG4vNHV0SjB1VTZJMVZ6OHNVanJXcit0?=
 =?utf-8?B?RVFqRHJDV0NuYTJYRmNoeE5WUFJkQU9WVGtjcUd5MExVRjhZMXltbGFadXk0?=
 =?utf-8?B?Y256OGhnNmhSRk94VmNvVnY5U01PdUxJQVkvckhSb05TOWI3UWlMTWhaK3Fx?=
 =?utf-8?B?Q2JNVm9IYTFpZXB1UzJJSDFqek1SUVI3WStybUYxYUFSa0xRdm43TG80dms3?=
 =?utf-8?B?MEtrU0VLU1lmRzNyR1o0L3VQMjB5WjVoWGk5TS9XSjhta1JqMHh1ZElVVHhV?=
 =?utf-8?B?SFBXckRmaVVReUNydmNvYzFraklvak1DT0JkeVVHU3pNVEVwWjJKRWVnNUlH?=
 =?utf-8?B?VzBvQklqeVl4WWNBcENpaXdmWm56WXpFVGhQMmRwT0o5VWU1eC9CS3N3UkhT?=
 =?utf-8?B?dU1QTFl5cUNmOEIvZXFQVldiMU14Wkl5L1ljQ29MTUszYU5qNVQrRW9LRlJP?=
 =?utf-8?B?dDg4M1J6dzdPSDE5RzBZcjNCTUFGbklQMEc0RS9mblZCcFNNVXBNRjMwQUxC?=
 =?utf-8?B?R3FrRGVzbVRkVjlKdFh4Y0N2THozMStJMC9WZGl3SWV2YjVCSmt5WGhXbi9D?=
 =?utf-8?B?aDlndk11UFlsWWhaN1dSc2czc215VGF4SkxkTzFGcUQ4d3YxeVBpanVMR2Z1?=
 =?utf-8?B?NUVaWDYzMlREdTVTRU4rdWYwUEp6a3ROdlIwdW5xUEQ0Ykc4SmNyR25HbGI1?=
 =?utf-8?B?dkdmcEdCTmZQV1hLV1pZSm9HZ3pFWmkwTU5xaVNqODNVSnNZQlpoY0JtZml3?=
 =?utf-8?B?Z2swZEFPcFF2dnJzSW5lb2Z4TmRUbkZSbUtQblV3eDFYNXZjcS9CT3cxdktm?=
 =?utf-8?B?d3VReE5yWFVEdkYxOTlQMk8xbXZpZlV3bHZZbHFVWDlmUTlQWVM1M0lGVDNk?=
 =?utf-8?B?eGpmSGdzT0NSL3NFTWpaWWpuZzYvNWl6OGI4MVNGK0NjalZSTzd5bFB2RURr?=
 =?utf-8?B?K0cyWVBzZlErS3lwQUliVHl0bW5hUUJ1NVZBQnE1UWlVQXQ5SXVickNnZGpN?=
 =?utf-8?B?TmhOaDhmU1RsVFpnM01pZUw1NVZwWXRYdjV2anhRUzFINUtlVzdZUGY5elBp?=
 =?utf-8?B?ekM4cmFScHYvMG9NVHdmV3pwTzZsVnJSTE5NSExSWDBuSkF5QjZ5ZXhZTjdw?=
 =?utf-8?B?NFVWZzErSC9pU2h1aEpGMmgvenBSYk42TEhoMG9DaVd2bVRzYnVXQjZhQ3Bz?=
 =?utf-8?B?c2U2eFdPNWM2L3R4aUdnaWlHOG9nUkdTSkZYcVZKT1JiR0xjY2VGbWVKU3F3?=
 =?utf-8?B?UEp1Vk9TTW5JcGgxeHVBVVdXb0E1TVBmRzZsVDJYWXZDRVVINFQ2QzBNMisx?=
 =?utf-8?B?RW16NU1OaGNub2hHdHdhcWtSSGppcDFxWjRGWk56Wk1iVXJMcVBvL1RmT3hq?=
 =?utf-8?B?SXh4UDE4a0FBeVdHeFIvbWw4SFRFNndLRnZxRFNXSnlVanRXd3FNNlY2NXEz?=
 =?utf-8?B?YXlEcll1L0tyNzI3eTVGMnVKOW5WbWxJWnYrL1pmbzFkNnJOUkF3UT09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a15165e-5458-4997-d1a2-08da533229b8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5658.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2022 03:00:14.2450
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YLBWiky6UJMtcgSDwle4wC0Gy71x3Qja+p8XTrBzZMEu+SRIlak8z4qjMsV5hgYmvWh379Tsc1lE/XdInh/4bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6445
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/6/21 10:49, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Tuesday, June 21, 2022 9:32 AM
>>
>> On 2022/6/21 04:13, Matthew Rosato wrote:
>>> On 6/20/22 4:54 AM, Yi Liu wrote:
>>>> No need to protect open_count with group_rwsem
>>>>
>>>> Fixes: 421cfe6596f6 ("vfio: remove VFIO_GROUP_NOTIFY_SET_KVM")
>>>>
>>>> cc: Matthew Rosato <mjrosato@linux.ibm.com>
>>>> cc: Jason Gunthorpe <jgg@nvidia.com>
>>>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
>>>
>>> Seems pretty harmless as-is, but you are correct group_rwsem can be
>> dropped
>>> earlier; we do not protect the count with group_rwsem elsewhere (see
>>> vfio_device_fops_release as a comparison, where we already drop
>> group_rwsem
>>> before open_count--)
>>
>> yes. this is exactly how I found it. Normally, I compare the err handling
>> path with the release function to see if they are aligned. :-)
> 
> In this case we don't need a FIX tag. It's kind of optimization.

ok.

>>
>>> FWIW, this change now also drops group_rswem before setting device-
>>> kvm =
>>> NULL, but that's also OK (again, just like vfio_device_fops_release) --
>>> While the setting of device->kvm before open_device is technically done
>>> while holding the group_rwsem, this is done to protect the group kvm
>> value
>>> we are copying from, and we should not be relying on that to protect the
>>> contents of device->kvm; instead we assume this value will not change until
>>> after the device is closed and while under the dev_set->lock.
>>
>> yes. set device->kvm to be NULL has no need to hold group_rwsem. BTW. I
>> also doubt whether the device->ops->open_device(device) and
>> device->ops->close_device(device) should be protected by group_rwsem or
>> not. seems not, right? group_rwsem protects the fields under vfio_group.
>> For the open_device/close_device() device->dev_set->lock is enough. Maybe
>> another nit fix.
>>
> 
> group->rwsem is to protect device->group->kvm from being changed
> by vfio_file_set_kvm() before it is copied to device->kvm.

yes. this is why vfio_device_open() holds the read lock of group_rwsem 
around the device->group->kvm copy. However, for the open_device(), 
callback, I don't think it is necessary to be protected by the group_rwsem
lock.

-- 
Regards,
Yi Liu
