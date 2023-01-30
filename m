Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C90680C37
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 12:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbjA3Lqy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 06:46:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbjA3Lqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 06:46:53 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19632B0A5;
        Mon, 30 Jan 2023 03:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675079210; x=1706615210;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eWVwEYNrXPywTn90rd7ihUJDqlXmXVgHAv+dpQvF3B8=;
  b=QCqsPabwg9c+ahpSuE4TNROZpGruNSzcWS7ys6RLagitzChgxHG2bpRf
   LtEWkOtLP5W0e/wvH9FzW2APsTXsT0lr0NmywaiI+9W1i6zSCxQP4gzfR
   1GJh1rXuokRV+IahqQiJUzYy6tcyg/A1jYJm2Zm5D6oJ+9D4YuuVVBcKr
   ndPgZLK4m/8ttTwCh/phmxHYijVe4bnAn2xp+qjVx+D1ThaYB29oc7FyG
   WEgAMivVSKN6OOFPRNJoIMypqvv16wEOy5Kq+HoUMVoQUr/oNJyTjsizi
   XDnLHejSw79plIrSAEh/5xghBkS5ddx73sydQG+8Oc9l8dM2a/c2HWdjU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="328811179"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="328811179"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 03:46:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="614002522"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="614002522"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga003.jf.intel.com with ESMTP; 30 Jan 2023 03:46:49 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 03:46:49 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 03:46:48 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 03:46:48 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 03:46:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VX1d/WsIbzLt9uFlbgzc7zPI0PR+seKLUUwAp68GAwt5ve0W8I8UL8z+fP9aAMiDB5n/gD1F5G6aaB8vFA7nWdsu+HKTAR3MHLE80Pa17ZD9bFdfwKPGfGxJnlHKg/NooiF27/5+ftIb/vMDsVarlsJrXuHFhxxzwG5yJyikuJXGHSeTSng11tTo2rtNJbpB3/6pmPGfTGZZDRiF4ePr5VKgDdgKgE24f+Sm9kDXyCvGVnXeC++y+53LVQ5x+6yFPPSRBzriuG0lP9jS8BVcJo3RDlIdqDWCcuDxFDxre/rBpJGsPH03cUqJ98l+AVvwN+fv0uWcz1+SJyztcfJjfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVqYt5tiGcTOF/7A2v63eQHXp2o/OsWEWJUROMJCtmo=;
 b=JbnxZZenBRKI6z0TVQM79vuFuniyd4STm5d960D/XbqvrF47o+LxNU2a9nljoxwUUhH61vtNoRDCBizefgcWfRpmtLZTm7Qn5oRd3inqx/yBAjRMlJUxRWaNQO+yCz8YUuigKzyJfgRhg5P8VWd32jjgdKuYrV4gPd8Z+/TMMib8/6ac9e0q0kl0OFx6mEUI1iuZLwMpycUBLYKtA8Vwvl6X4jZCt53R/k4rfYXZp+hbbjadzMhgaBB2NfJC6ii+wKQNpc7CCtWZ/Ce6dgToeDbb6n2BjZVB0FT0r5iVGRX2l7vHj6yoM47pznM7DW7o9nfoHnJQj+QUoH34v+GxUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by IA1PR11MB6076.namprd11.prod.outlook.com (2603:10b6:208:3d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.33; Mon, 30 Jan
 2023 11:46:46 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 11:46:46 +0000
Message-ID: <b34bff98-9f2d-539f-7ee9-7bba09a8269a@intel.com>
Date:   Mon, 30 Jan 2023 19:46:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-6-weijiang.yang@intel.com> <Y9QzLHNxS4K81SfU@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9QzLHNxS4K81SfU@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0214.apcprd06.prod.outlook.com
 (2603:1096:4:68::22) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|IA1PR11MB6076:EE_
X-MS-Office365-Filtering-Correlation-Id: 132c2e19-94c2-4fb8-fb1e-08db02b7aa41
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gNI5kvd+BLV37l7oU13mqOkPMrd73r9jw0bflrfsuBNtHMfyKAakt2KEt+WK38XQIz4zU108u/skeFTkIAG5eCCGoU0iaOU0s3F2Wrxx5/Rb2KBvGxCNK4N+40nOpPDk7McxeuA7SNqXFVh0GVkSGG0e4zKlyJXcaFFgwhnLLgCZ7Vu1xzxvCw1stLDXHxZSPhLkiqShFvxnNDGRPCO7O4T7lEOA9Wjh7L+Nx9rzL3aLyHiRvO4E0Tzg5NbIm9Nx2uzBBoHhvWMygqr0/4Czo7/9Rdsg2i/fDXryO61iJTnhf7m0GsnFGMo+RpgW5h9eajGXfq76TJhLK9WBKTyNyokOZJyJ+KFWhnGlmHXMGTPKdN8Dza7hYpbkHsQI3nKogRUoCEOCK0BJL99ePUTC2FmsyR8rzx+3ikZHlok10RddgDWjHnkJwRXPvIMU6i+CihMALYPntQM09zsonAEdQSGKjiVerfrkASdKV9L6xxtqWVeifpvl2pElIKOkqOsbFAW5Lf6g/tMmXN07f2iufXhUlKCfidUYTIxZuNH2HYmRh6zPyGms0OqWmH0RTibwLGVaxTG/mbn8brfnPrSJbB7U1l3pJvzOZzYd+5zCIdBJiouK/A/szzOOyuPOR1u7nzKQW71GPckqD6xzSNNJJX8OjC7xnCyXka+rAq3xy8g4MX7zpM+/DPrmiv2LGzEtpLGiVwN51VTwNnRWqkSk3hPxw3j/D5ZBDcszJRCiNsQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(346002)(136003)(396003)(39860400002)(366004)(451199018)(31686004)(186003)(6506007)(53546011)(478600001)(26005)(6512007)(8676002)(6486002)(6666004)(4326008)(6916009)(66476007)(2616005)(66556008)(82960400001)(66946007)(83380400001)(41300700001)(8936002)(86362001)(38100700002)(36756003)(2906002)(5660300002)(316002)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Rm9UUWI0ZjVrb3VraFlUSjdyOHpXS2RlZ0Q2NHpvR21sQ2RvZXI2UHlkRmZo?=
 =?utf-8?B?MWhaTHZNQS93bmhuR05rQkVzMlcyaWxQYlJxdlM3OEVKYnFQMWgzdDIwSUk4?=
 =?utf-8?B?bUFDQ25UdHRoU3JubXc1K0YvU3g3QkhFNVJjMjgzaC92RGttN1R2WUh3K2NY?=
 =?utf-8?B?bnJuSTZ5Vk1HTE4wNzh3Qm05d3VhUkVDdG1iS2lIRXBnazJobm5nSUxrWEdh?=
 =?utf-8?B?WUlhNHowRVBMR3dLN2orc1lMZnV6UmlrZmlKUUdROE8vN0pHMDl5NjZlUVhJ?=
 =?utf-8?B?Qnl4bWJNa3Z2ZGZwWlZ0NWxVL2tmNWpwQ0U1aHFMOXdDOStHOU1TdW9KSllF?=
 =?utf-8?B?bEd2K0FlNENNeThDQldzRE5QTmNIc3lCMTdjMlNoa3RGYWRXNncxUGVKdWh2?=
 =?utf-8?B?czB3bjdpdFJIUWhtc3FwYm8vMEU0ZzlNREx5ei85L20rRXRNN3kxODRYSEpC?=
 =?utf-8?B?NC9xRWxXTlBBSHRmYUtKUmlHeHNTK2FZeXR0V0V3Sk9kVmRsS3FUTjZDRFlR?=
 =?utf-8?B?MlFvdmtzb0JkTEEwWkROVmdScWtNa0VaZVlqY00zZkhweTJSaXByUnR5ODVO?=
 =?utf-8?B?RFYzditHdm5SOGxkcHFTKzRRZ3pWOEdLMG0vL1d0QmdxeEZPVW1mUktzTWt0?=
 =?utf-8?B?VW9vSUJqcFdPbTFpWUN6SFVhdTRSZlNQdzROaDVidkZMM0hrQ0pKTVEvTVoz?=
 =?utf-8?B?cGVjaEYvcDZHc0NvTllGb25seHlhMjlzamtHZkVrL2xyQlpIL1hxNzAya01Z?=
 =?utf-8?B?NFlqT1lxd2pWcC83ZklOL2c0dVZVb29qdWI0SG51UW5aODQ5eTQyekZvbXJs?=
 =?utf-8?B?NHl2bTVqTFlHM0QyeWdPMWl3cjBOcWQ2TnNXQ3JQWnRQaGJBcE1kbHJJL2VL?=
 =?utf-8?B?ZEtDNWpaTTJsUUhFb21DZ2ZNbzU4aVRkYlgvZC9yVVpTMm0rLy91TWY4ZllF?=
 =?utf-8?B?TXBjN0lBWFZQSXQyR2ZaUkJ0M0g1QmFuZmNQYjRQVlNsR25sZmh4RWVzWWdP?=
 =?utf-8?B?YW90eXlNRFZ5TWduelJvdlVtVktkUzcwMFZUcjVzZkNHZXM4K3ZyZG1ERjda?=
 =?utf-8?B?YTlkNkhSQVpodXUyNEY0WVVMOVdzZHRkNEtQS2owVmc0M1hEVmxaMHlsSXNP?=
 =?utf-8?B?bCtCeEdKa3U2a0YwTm9MaUYwb3hrL0YxSTRQZzZPK1FBY3c4NUJZRWtVWThz?=
 =?utf-8?B?Z1d5bzBmMmRSeFZEdnZuUjQza081bnVJNnhyN25va3d4cndHN2gxQjhTRm4x?=
 =?utf-8?B?OTV0elVLcXJ3Q0hEc3RxNzRyenRhT1pYZFVCK1VaQmN2cDJtOU1WV2wyYllp?=
 =?utf-8?B?SjNNa1EySzRSbjBnVGVoZ2F0YjJ2RW8vcFd4bmpVdlh1RFNCYzk3RXNPUUdk?=
 =?utf-8?B?RGlsQU9kQ2JRNUxHL1p6QklVdFpFZ2pFeGJuUHlNL2k0bzJGQ3dtbWx0eFR6?=
 =?utf-8?B?Y3MzSzlUbEJpcWZnQkVNWENQTjNzUmZvVHlwRjAvdGtmTkQxT0pvV1NzZnlU?=
 =?utf-8?B?K1hiTzFucVcvL2NueVFLR0wvTzBsbVE0bWRtVFJBb2p2anBEcm5RMStGbEJO?=
 =?utf-8?B?UkE2bmFLSDhBUXAzNzc2UXZhTUNFZHd3RkE5SUVmK2d4YzNlMWNtZkJ5K25m?=
 =?utf-8?B?TWR1Z1VuWHRHdGJ2SzM1WnIrREs5ZWI3RUhxNEp2bTFGWEtVREJkazZPOW8r?=
 =?utf-8?B?ekZiREt5c3FlYW1jQ3krMkZVQ1A4WS8yYzdhUUJjc1NGN2E1RTJHRFluNW90?=
 =?utf-8?B?dTBmSmNFOHBZVnVkU3BKY2V3a3lZVXkwTkRGOWNpUW0vZlhQdmlBcUZkYzVp?=
 =?utf-8?B?cm13VlFJM0grMWM2ZFRxeml2ZEk0RHY3VVJUb2JkeWVOQURSSEhmT01ROXhP?=
 =?utf-8?B?VkJzb0hMRElxL0pxK2V5a2dwY2VPRmd0TkZLRXN0LzMvMmxnbXZUMmlvZnlC?=
 =?utf-8?B?cmpZa0gxWUtGUXFKb2JTSlpCZUdaeWtTc3ZTM092SjdDay9BUm02NUl1UnlR?=
 =?utf-8?B?MVFUYy9LQ2RNR1JVY1pLWnVUQllQME9RRkhLdFUrcUx3UlkvSnREM3phWUZN?=
 =?utf-8?B?M2FBNGxqSWJ6UzFQY1hUL2F0ZEhzbGdReVpDbG5TSDQxeGlTTlNFcktOWHBZ?=
 =?utf-8?B?bGNjaDR5V3hPeFZ5WDV1Z0RMWnUxVmpncUZRVnpRUFM4bHhwdllKdkNQMGh1?=
 =?utf-8?B?enc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 132c2e19-94c2-4fb8-fb1e-08db02b7aa41
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 11:46:46.4759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: COppkF+nmjL+MI00t9Mg9J27/NFuV2xzMWYAACfBnXQLJG7ew9XQBtRdnKwn7k+R6J/eIzK5O1d/Fxl2iPr6AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6076
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/28/2023 4:25 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> [...]
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -571,6 +571,9 @@ struct kvm_pmu {
>>   	 * redundant check before cleanup if guest don't use vPMU at all.
>>   	 */
>>   	u8 event_count;
>> +
>> +	/* Guest arch lbr depth supported by KVM. */
>> +	u64 kvm_arch_lbr_depth;
> There is zero reason to store this separately.  KVM already records the allowed
> depth in kvm_vcpu.lbr_desc.records.nr.

kvm_vcpu.lbr_desc.records.nr alone cannot tell whether it's legacy lbr or arch-lbr unless

binding host arch-lbr checking.


>
>>   };
>>   
>>   struct kvm_pmu_ops;
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index 905673228932..0c78cb4b72be 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -178,6 +178,10 @@ static bool intel_pmu_is_valid_lbr_msr(struct kvm_vcpu *vcpu, u32 index)
>>   	    (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
>>   		return true;
>>   
>> +	if (index == MSR_ARCH_LBR_DEPTH)
>> +		return kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
> Like the previous patch, since intel_pmu_lbr_is_enabled() effectively serves as
> a generic kvm_cpu_cap_has(LBRS) check, this can be distilled to:
>
> 	if (cpu_feature_enabled(X86_FEATURE_ARCH_LBR)) {
> 		if (index == MSR_ARCH_LBR_DEPTH || index == MSR_ARCH_LBR_CTL)
> 			return true;
> 	} else {
> 		if (index == MSR_LBR_SELECT || index == MSR_LBR_TOS))
> 			return true;
> 	}


yes, exactly, thanks!


>> +		       guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR);
>> +
>>   	if ((index >= records->from && index < records->from + records->nr) ||
>>   	    (index >= records->to && index < records->to + records->nr))
>>   		return true;
>> @@ -345,6 +349,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   {
>>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>   	struct kvm_pmc *pmc;
>> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>>   	u32 msr = msr_info->index;
>>   
>>   	switch (msr) {
>> @@ -369,6 +374,9 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   	case MSR_PEBS_DATA_CFG:
>>   		msr_info->data = pmu->pebs_data_cfg;
>>   		return 0;
>> +	case MSR_ARCH_LBR_DEPTH:
>> +		msr_info->data = lbr_desc->records.nr;
>> +		return 0;
>>   	default:
>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> @@ -395,6 +403,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   {
>>   	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>>   	struct kvm_pmc *pmc;
>> +	struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>>   	u32 msr = msr_info->index;
>>   	u64 data = msr_info->data;
>>   	u64 reserved_bits, diff;
>> @@ -456,6 +465,24 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   			return 0;
>>   		}
>>   		break;
>> +	case MSR_ARCH_LBR_DEPTH:
>> +		if (!pmu->kvm_arch_lbr_depth && !msr_info->host_initiated)
> Don't invent a new check, just prevent KVM from reaching this path via the
> existing intel_pmu_lbr_is_enabled().

intel_pmu_lbr_is_enabled() only indicates LBR is on(either legacy or 
arch-lbr), but

MSR_ARCH_LBR_DEPTH is only for arch-lbr.

>
>> +			return 1;
>> +		/*
>> +		 * When guest/host depth are different, the handling would be tricky,
>> +		 * so only max depth is supported for both host and guest.
>> +		 */
> This semi-arbitrary restriction is fine because Intel's architecture allows KVM
> to enumerate support for a single depth, but somewhere in the changelog and/or
> code that actually needs to be state.  This blurb
>
>    In the first generation of Arch LBR, max entry size is 32,
>    host configures the max size and guest always honors the setting.
>
> makes it sound like KVM is relying on the guest to do the right thing, and this
> code looks like KVM is making up it's own behavior.

Will modify the change log.

>
>> +		if (data != pmu->kvm_arch_lbr_depth)
>> +			return 1;
>> +
>> +		lbr_desc->records.nr = data;
>> +		/*
>> +		 * Writing depth MSR from guest could either setting the
>> +		 * MSR or resetting the LBR records with the side-effect.
>> +		 */
>> +		if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
> Another check, really?  KVM shouldn't reach this point if KVM doesn't support
> Arch LBRs.  And if that isn't guarantee (honestly forgot what this series actually
> proposed at this point), then that's a bug, full stop.

Right, this check is unnecessary.


>
>> +			wrmsrl(MSR_ARCH_LBR_DEPTH, lbr_desc->records.nr);
> IIUC, this is subtly broken.  Piecing together all of the undocumented bits, my
> understanding is that arch LBRs piggyback KVM's existing LBR support, i.e. use a
> "virtual" perf event.

Yes.

> And like traditional LBR support, the host can steal control
> of the LBRs in IRQ context by disabling the perf event via IPI.  And since writes
> to MSR_ARCH_LBR_DEPTH purge LBR records, this needs to be treated as if it were a
> write to an LBR record, i.e. belongs in the IRQs disabled section of
> intel_pmu_handle_lbr_msrs_access().

I assume you're referring to host events preempt guest events. In that 
case, it's possible

guest operations interfere host events/data. But this series 
implementation focus on

"guest only" mode, i.e., it sets {Load|Clear}_LBR_CTL at VM entry/exit, 
that way, we don't

need to care about host preempt, the event data is saved/restored at 
event sched_{out|in}.


>
> If for some magical reason it's safe to access arch LBR MSRs without disabling IRQs
> and confirming perf event ownership, I want to see a very detailed changelog
> explaining exactly how that magic works.

Will change the commit log to explain more.


>
>> +		return 0;
>>   	default:
>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> @@ -506,6 +533,32 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
>>   	}
>>   }
>>   
>> +static bool cpuid_enable_lbr(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +	struct kvm_cpuid_entry2 *entry;
>> +	int depth_bit;
>> +
>> +	if (!kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR))
>> +		return !static_cpu_has(X86_FEATURE_ARCH_LBR) &&
>> +			cpuid_model_is_consistent(vcpu);
>> +
>> +	pmu->kvm_arch_lbr_depth = 0;
>> +	if (!guest_cpuid_has(vcpu, X86_FEATURE_ARCH_LBR))
>> +		return false;
>> +
>> +	entry = kvm_find_cpuid_entry(vcpu, 0x1C);
>> +	if (!entry)
>> +		return false;
>> +
>> +	depth_bit = fls(cpuid_eax(0x1C) & 0xff);
> This is unnecessarily fragile.  Get the LBR depth from perf, don't read CPUID and
> assume perf will always configured the max depth.,

Make sense, will refactor the function in next version.

>
> This enabling also belongs at the tail end of the series, i.e. KVM shouldn't let
> userspace enable LBRs until all the support pieces are in place.

OK.


>
>> +	if ((entry->eax & 0xff) != (1 << (depth_bit - 1)))
>> +		return false;
>> +
>> +	pmu->kvm_arch_lbr_depth = depth_bit * 8;
>> +	return true;
>> +}
>> +
[...]
