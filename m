Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A45DB63A4E8
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 10:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiK1J1T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 04:27:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiK1J1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 04:27:15 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F03419027
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 01:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669627632; x=1701163632;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Tfd4c8a4zVOlT6RZnrV3ssfefuOl9+z8xVf5LL9ua74=;
  b=YIdUtwIV3coL+XKtuvLU9zdQl65gbIKRPGp7LHHSmIKTdAUOu3DZPyrY
   nWfp10684bFz4Gy4ylFY7x+4PYMao9u2sv3ZSeMiMd+71dUlH19+AHhoQ
   sqQX0xPDRe83aPNN0rZ0rl3sh5WHiwhrLQaaHe6MoCHMhnoUgk2ErL3ms
   vS6bTuya9aq6/C6LPZ0G3e5Ru4OMbf+vKNxYQAKtmUIUvhon9oHqbScP+
   PD5qny2raOTPf1G5hgW/j6HsazPZNz0iIYQOnqwbigZKoBcWXkSXmwJVW
   7Q9EwbMUKfLLM7fv1v/nHZ/XZ0LCyOwRqm+ltBMgCsS5+QNI65sXzeIgt
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="376930126"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="376930126"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 01:27:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="675985045"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="675985045"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 28 Nov 2022 01:27:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:27:11 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:27:11 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 01:27:11 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 01:27:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekIXTf2Y1Fmrgq1HToo0YHBuwZjlgZ55hDGiXd5tdPQCyFSGbbzz8STVGT10HddI9V5YBcPRB/0UR7bIxDDYQjeE+0v1Na9nclaAMUR5IaDbOb1giaGVp0nmEuiJZ80UoGgWJ94z3/ZSt7VLa/q0hMp9jmK5YAahJO58Xi/MJ1MeNsMqx+PiZT80MO8/BaVoyKRaudUcDSZYXSF5bRMN/u1qZ0lZ4fxlnk2RETpzS2uoan9YOUYcoTG9mmV05ejqFYou2lBtQ6yUJf4Qi7bLavm5g6Cz9vih3f8aQgf5YF1INlBgzvosV/nuZp4o3TLU2o2OAhvyaE9yq9UjKD1fFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8IgGev7CyGvQUPDFzdjwkegNJu7UwCILvF9PbQXLls=;
 b=kbcnmw3c0QQcgpk4jV4wZfwJMVjiWxGDMe2sALQoa5V5JMa+tJc1XeBGT65EuFVmlInamw81GnRCxJL+TmKf2oCyTu/iIx95RGzWC5LVuzAd05sK1Rdcv/pfN5ifYAmP5tujSwlN0Un0+mEdu8QaWu1hWcS10q8lfj87IkVrovNXBwfInxk1b6Bh6OM5JiqPuvhaASJ4lPZns5CY/mSX2q90hkurhs8GbvoI4I3fzqdTEW8TV85B7c/bWDQMz7X1C+KSdverCnwk+1XQctczMqEXeq8GCkOD9wLcyJKIWv+ap72/+sbVcWRwCWNJMZ3NJnFtggdhRYaVsVi6BlaE7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by DS7PR11MB6013.namprd11.prod.outlook.com (2603:10b6:8:70::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:27:08 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::61c3:c221:e785:ce13%7]) with mapi id 15.20.5857.020; Mon, 28 Nov 2022
 09:27:07 +0000
Message-ID: <f5fc63d2-f1ce-194f-b3ef-83d5ac5c0d02@intel.com>
Date:   Mon, 28 Nov 2022 17:27:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [RFC v2 06/11] vfio: Move device open/close code to be helpfers
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>
CC:     "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20221124122702.26507-1-yi.l.liu@intel.com>
 <20221124122702.26507-7-yi.l.liu@intel.com>
 <BN9PR11MB527600CC442882CD40563FAC8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <BN9PR11MB527600CC442882CD40563FAC8C139@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0042.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::17) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|DS7PR11MB6013:EE_
X-MS-Office365-Filtering-Correlation-Id: 131d4243-6e91-46d8-d25f-08dad122b76d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ibuH/VqZjJ9rafXQKPsLc4CXK3XBWDt0u+DTu6pgRmN4HcHUr1tYEVogcfCaqgoEanZlwVoalc2R4HQAi4hXe334dQwKmnludlb9KCjJQ0AeIIF04QzV7NVhti+r2ez8qqr/aazTfk12I7L0yKduT5hs+7P1BC05GUD3LV9DCVNhBqjfo4OBWNJ7h0jbr4TY6NwJsscN2/UjHsGN8ztuC4S4FzHK1DO3U/GvLMa9mMl8Tde6TV1nmy9el4h65DCF0YwfMzpG5gfaatv23zc+xrpaAJysMLc/8+8mPuWO+057PHcb6ZcGCFFn87/Q6bbeWYsrmqICEb9RNTX4GXZczi/x55XFzeThbkyV/P6nQgvW2MDClIh20hVKwhXSrm8HM3llYzCBJXqfLZ+eAVkILQfZ/sYsuVz92YW4CUD1z1L1E2O76kMHmSxjznyKtRlnLhMLo5u8w9QM4FdOj74UJae7E+2UNS/HaLTAsLoR233M/qB8G1qUgyfMXpnMSEMSGAgum8vU2W2NEpLA/7ug+IuRzFXgrXpkdbFJz3hE5W+UxKhSgqlb5VyYxbP9dwHQhfJlYz7PKIAsOtXtS5z9QJAd58ZOlRCvyQ0nDup/PWz5X6pCIPbkKwtxfTVdzOwPYsFvLcfdBEcJXunfnWVdDNUjxYD8BHLOjAk+mvYEDjYVRiBax06Vj8PYlEMtRSFlEGlRLyrRrhQMRCBNtgzJfyh8Mw89uHZJaWzbZJu/3ic=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(346002)(39860400002)(396003)(451199015)(31686004)(8676002)(66556008)(66899015)(66476007)(41300700001)(110136005)(54906003)(316002)(4326008)(66946007)(5660300002)(8936002)(26005)(6666004)(6512007)(6506007)(478600001)(36756003)(186003)(53546011)(2906002)(6486002)(2616005)(31696002)(38100700002)(83380400001)(82960400001)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WisvUGF5bjB6UG5NNlRlcnVLc2NCRkQ2WnQwMTdFVHpndVpFcHBLZlRsNFV1?=
 =?utf-8?B?Z1VtWHN2bGE5eDJtRGIvQ1AxaEkrZE1KOUZOTTBmT1A5OHkyU296aks1cXN5?=
 =?utf-8?B?YTJNTVhsZW9HWUozSDZCdlUrUTd2cXlJZ1JFclV1cERHUGpBWU5ySXljWkY5?=
 =?utf-8?B?d2ZaRUFwWUtSVFZrODRPNWJ0bDZQN1RDM2JkQ2V4RjBERWtSajZCTUR6d29O?=
 =?utf-8?B?dHZXbDJLRUd6QU9sWEtRc3pwMnNvdDJlY1RUN0xDcmVOZWp5UnZ5TnJUTEpy?=
 =?utf-8?B?Mm5KSmFEcTVZZjhGYU9RdGRnak8rZm0zUWc0Z0NDUDcyK201M2hBVlFiU1NL?=
 =?utf-8?B?aUJJaGJKZVVTNFA0c1QwZ0pwdXFDOXRQMVVaeUFOWFRkeFVCUlY2b21oR0lq?=
 =?utf-8?B?YllaV3hNQlVydm9MWnVFbkZWNHhuR2xVVEt5WklHc1VIWm9CemZDeHFFUnlM?=
 =?utf-8?B?QW5tQTA4NVFuUTE1aUFyU21pUjFBVkNnLzZnMVYyMVpzWUJabWRDc25GOXRy?=
 =?utf-8?B?MUtGeWxVNW1YWGtTbTRTQ29WQlVLVTI0TERxTTBGMWNYenJNR0plYy9Henhw?=
 =?utf-8?B?bU1WZm5uSklFQ1VoZUJMZFIrU1l1S0V5RXVkSm00b3kwNHVXVng1R0pkMEEy?=
 =?utf-8?B?bWFsV2FvSWpnN003R1YxSldTSVFoa0ZXRlhxSklKSFU3bDdsZzNtK2VPV3po?=
 =?utf-8?B?M3Zwci9SV1lBUzlEemc5Rlp6Mkl0Mm1veTJaZ1N0VVgzMm9FdktWc01KbGhK?=
 =?utf-8?B?cU4wOTNMSG5zTXV1SVhjS0tCekZYUXhrRUpKL0NmV000WkRIejlNeXltcjk5?=
 =?utf-8?B?RG44OFpCcUdHSUVEbElZMFhicmxleERwallLTGo5N0dqY01pSTNyRFZSV091?=
 =?utf-8?B?RnREeGFXQ2lhdEpoTzNqeWh2QUw5aEFxV2hXcWlpRGMvdFV6ZGlZSFlUL21p?=
 =?utf-8?B?ZlJ2bEJod2dzZWlqemY2VGZjZGVZRjRCNms0ZXl0OUR3dTc2VzQxUnNHampU?=
 =?utf-8?B?UFhxelJzbGhzb2R2b0pGbjRwQ3hhMERPeCs3b1NwREQyb05yTkQveHJlSUVh?=
 =?utf-8?B?U2hzR1RUNWo2eTdvK09XZko2aDBuRUhlYWJ6MTVXUlNvd29lY0IvQXpoUnZ1?=
 =?utf-8?B?QTljZksvSHllYXdqQmVQdlVqU2ZyTXJiakJJWEdqOVptMHRrbGJGWGQxRUJE?=
 =?utf-8?B?OHBvWUVRdHNOSURORUg0Q3lYd25ITDZpNmxvUFVWNDVxdHBTUyt2Sk9CUW15?=
 =?utf-8?B?cFNkK1dVaVVzZnhXZFhHSFVEK3AyU2J3TGxXY2pEUXVzb0h5TGQ2UXE5bkoz?=
 =?utf-8?B?UG1BTnM0bjNHTFcySWlGaTIxQ2dHcDhJSlQyakhXYXN5VWdNSWNPWERZdnNI?=
 =?utf-8?B?VThUSXhpWXlGUUp5WnkrcHV5Ulh1RkhOZHF5TzRMcGlDYUlGVnFIRkpUM0xi?=
 =?utf-8?B?ek4ySEs2OVJZLzFjU1pxU24raSswekJkYTVFVUpUZTJMOWk3c1pjVjN3Vjg4?=
 =?utf-8?B?NmE2WC9aRVdtVjJ3ZHBLV3RsU1VGOEdHMzFXWWkwNmN3ejRXbVMzbi8yNXFT?=
 =?utf-8?B?VzIvWHVlT2lCWU9mcmFneWpLUG1wODJ3OUx4NzJhcmRvLzcxTUgvaUF2UFgr?=
 =?utf-8?B?bU1UOVhSOHhoSEhjNWl2WWhKTERPUEdJYkhReEhDYTBma2kzaGljLzRJSTdS?=
 =?utf-8?B?M3c0Vk5VNVF0UXM5VnQyRGs3LzZKcXJmWFhUNDVjb3ZEYXJVNmtaeEh2NnRu?=
 =?utf-8?B?d2xNb1labXlZVmhrL0daYysvQkFLbnVCaHRRZ1lxWXFJaUtnU29SUXRMN3Ni?=
 =?utf-8?B?ZEp3Ri9MS3pJZlp5V3Fyb2hnWXAzSEhNckI2VUR3VWxOcEhYZlB0S1FhWEta?=
 =?utf-8?B?b01zYzBjYm51T2xMeXdiSUg4NVpZdnVHS0ZrVWU3dmF5REF1MjdCZmtHTTZl?=
 =?utf-8?B?Wldkd3hBbFl1ZndqQldtMVNmb2owOFNXbjNBeTdWR09iQmVBZ2d1V0thdi9N?=
 =?utf-8?B?QnMrcWdNVlE5T2E4eWJPMWpYUVRWazl0UVU2SFRxbjU2Tk9aL0M1TjZNWEJH?=
 =?utf-8?B?R0RlNmpGdnIzSUsyM0c4eEhYT2lPQ2M5TEtRMUVkVHZJRzhpYXY1RVhXSGRY?=
 =?utf-8?Q?OQeeOUWJ+0RaMMTwB2N2gVTno?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 131d4243-6e91-46d8-d25f-08dad122b76d
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:27:07.7138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zErSgIq9fb8YbcZFFnMSv4wgcDoctt9qoGfMqQjR0iI2DUDWlZ2kh9//H+O5s7LzrIjyWZe/tYejPdIqjFyi0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6013
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/28 16:21, Tian, Kevin wrote:
>> From: Liu, Yi L <yi.l.liu@intel.com>
>> Sent: Thursday, November 24, 2022 8:27 PM
>>
>> This makes the device open and close be in paired helpers.
>>
>> vfio_device_open(), and vfio_device_close() handles the open_count, and
>> calls vfio_device_first_open(), and vfio_device_last_close() when
>> open_count condition is met. This also helps to avoid open code for device
>> in the vfio_group_ioctl_get_device_fd(), and prepares for further moving
> 
> I didn't get which 'open code' is referred to here:

it's the device->open_count things. but you are right, it's not in the
vfio_group_ioctl_get_device_fd().

>> @@ -918,7 +935,7 @@ static int vfio_group_ioctl_get_device_fd(struct
>> vfio_group *group,
>>   		goto err_put_device;
>>   	}
>>
>> -	filep = vfio_device_open(device);
>> +	filep = vfio_device_open_file(device);
> 
> it's simply a replacement of function calls.

so more accurate description is splitting the vfio_device_open() into
common vfio_device_open() which is paired with vfio_device_close(), and
another wrapper to deal with device open and device file open, which is
group path specific.

-- 
Regards,
Yi Liu
