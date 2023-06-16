Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29727324FF
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 04:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232793AbjFPCCc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Jun 2023 22:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjFPCCa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Jun 2023 22:02:30 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5272135;
        Thu, 15 Jun 2023 19:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686880949; x=1718416949;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YE4Z4WeERRm/tnVgv/wXkyUxv1AiJaPZ8rjWbjhI/qs=;
  b=PMZLaJw1cELspHaYc0nrY/JyFmam8HGgYxH0X7r92IUhqvUwTpLLsSTU
   lP4OQg1hqDqmFTf3q2rFofs/jDevBlyT4415pf+bzbkTJsLnias7ne5kJ
   JV4ZlzMwm8RGdVw35RwA7hv02l66AbOgVlAMGuWCJ5WMueAyGTnipK9tr
   wArtRcvUqQYsi9cmmv+JNp9nVWHnW2kQijiGMFaUZBFxrDR3QgFal5UlJ
   bIo+ZnHAQESCPHu4TsAHAAcBaK23wwqrUNonlfU11N63YZg5l32qHuo/x
   KineYDwX2WZXGIeELdWux2dJEVb0/HXUZLULx0RquwLMRkyQUZLbGXJqD
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="343831494"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="343831494"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 19:02:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="706902253"
X-IronPort-AV: E=Sophos;i="6.00,246,1681196400"; 
   d="scan'208";a="706902253"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga007.jf.intel.com with ESMTP; 15 Jun 2023 19:02:26 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 19:02:26 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 19:02:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 19:02:25 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 19:02:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rmy0sPovc/V126D4RkiWm4ucJpbVPrDEJiHXPvvj7QX0ZDm2yIOMnWrW7x3/HvbXoKOzzzGSfP8u7KyGA5642SvwJ2OdNLybfO3hzb5pezIKAy7SvpnRW9LasSZNIIBldFoK8CUgysjbQ5WTqQZAB1jEVRhVxOacQzmQHCMVHbLtxMYvNxOgtlWzdV+Mu2XmfYXb3Bqj5iMVDop21jYgp4otP6quCUbMunFaaRMrQNzQ6HVC1qr1NaoaZZxNlOssd4VKbQGZUXWZNmUOHGwvhk4rYNToThmgu5MKR+DnwBZ27OfDKAXAFnSuMbtekM/FH6WxFWnxwQv82rvoPs5jiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XSeMsgNi+t2A3COZFJSMAzBAS/JeCGQmsTS//w5KdRE=;
 b=AbHCA95rYowjtUMxNSoG1fiCVh0aRgPLSUly9y/mfYUSSOzGCX9kZiD6Pxz43Tsci6b6jtebvqzQYfn5EGNhabYD8+jyXnjp/BZk9cUk2qqpVi/+6r1EnpDG+C/EaHP7qG4rTlkDpHFaVVKutiAEjMAqYFJHaNUyBfMJrLQPQgpptAVFgOjYmVLA6Xzs6vHDAPHJTEf9vSsfGIPIzB95wfpsffnqJ9CEEl2BzwzNLxkBJ4K+ZEkGIw0I7235XkvydJLljRTaYbXeg8Obfqwq+98LSPOLbgGC66wYPy/3/a9Yg0yw17FkBJ9jWZzwtTEOYITpcK2apJjQv6xhUO5c4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SN7PR11MB7993.namprd11.prod.outlook.com (2603:10b6:806:2e5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.27; Fri, 16 Jun
 2023 02:02:19 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4707:8818:a403:f7a9%6]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 02:02:19 +0000
Message-ID: <91a2447a-9d4b-1e2c-6925-86b1035ffee7@intel.com>
Date:   Fri, 16 Jun 2023 10:02:08 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 09/21] KVM:x86: Load guest FPU state when accessing
 xsaves-managed MSRs
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-10-weijiang.yang@intel.com>
 <ZIujqYFd3xR2oPwi@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZIujqYFd3xR2oPwi@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0038.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::20) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SN7PR11MB7993:EE_
X-MS-Office365-Filtering-Correlation-Id: 94998f4b-d984-4fc1-1eec-08db6e0db6f6
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: smej6mwhnk42In9OtRUCSS2uZMAJJf+yJyJDm/rrWiYWB557XlH20yQTJwdXdD/9+hUrss8mT9Bs8ODPJhHtQ9ng7DHImQ54SlnfkKc7eGazy0g19LeHyOJaaXUbUTjI510DAZlE2b1CbXG30WB25ohPPshyqX6P64yxIKLeVY18TyYDPVUXlL1Hv4nEYUQ3bb6tjpwdjrrxDdyFm8zts7xrQmqdLedck1cktx8gy+uR/EtHVAx+7Zv2vd7y6aeG4jmUJng/RZ/ZmvrPZWyKzz6+O4puJSh66yT4KdaZRit+lcq11HWWcMK6CUTkMw+1RybnyH+Dyc6wHh764UablL25ehvYtK98OlrVbiS1QsPJh4ecv0QLbEnHe1VQH/fFno92aHEcTyfLUVuFTZJpd+aF4o7JTBz/NiiAx/IsduwYv3AKbTtIWQ4uinQmtn72sRd+7/71NOfAR13mX2Np+1XdSR7FkEv2JncFyOSNTshb9Pc7y29LGN0cr3RZ2MliymPfVfMzbS37PEjx+E9CgZFkT64vGVHy9TofBLKTl1mqA+yPWKxNd+hIZNgh28Fs1HE/VvcX9Fyu2O4r2hgbr2EWV/56PPLlF8EUYAu7fR0XCjCQX3B5E6xxe9q5jNols/Rlot0uEgQasdOcbhn+bA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(366004)(39860400002)(376002)(451199021)(26005)(36756003)(6506007)(6512007)(186003)(478600001)(53546011)(6666004)(6486002)(4744005)(2906002)(316002)(41300700001)(86362001)(31696002)(82960400001)(31686004)(5660300002)(8676002)(8936002)(38100700002)(83380400001)(2616005)(66476007)(4326008)(66946007)(66556008)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHVqSnBONjBCZS9tejFrbEhQaHI4M2tydTJzVzA5Mno2Nk5taXJLSWZxa2ls?=
 =?utf-8?B?eVhoaWxJVGFUY2c3bDVkNWlwRlI2SlZyK2JOSWp1cTQ2UWVqNnI5WjdyMGFD?=
 =?utf-8?B?cHg3VEdweVVudG12bXdGZzBTenVKcG9iZjlZWTBia1RvSUNTeVVaL0RRUkJ0?=
 =?utf-8?B?VUluRURySFJkdE9NRXFOZFdycXRoOWhxamtVYmZzVm5vSnJrSGkvRHJRUzh2?=
 =?utf-8?B?d3d0SG8vY0IwSkpwQWNmMVgyVi9WMXYrdHVtb0RXM0FKS3A4QlBxQXF3WmMr?=
 =?utf-8?B?U3BPUWpCczEzYm9hVTFHS3N2Q1RTbk0ySHpCdHgxSllLYnV6bWJ3S2NrU0dl?=
 =?utf-8?B?cTVIenlCNDEzK1dHckFYTGlsWXpvWEVrei9aT2VKREJMNG5aTEFLWXBpd0JL?=
 =?utf-8?B?MmhNVzRYQTFWUnk0Mjg4VTZJeWdydFlYeHFReXpCUXdSMytYcC93MkJtbzEz?=
 =?utf-8?B?RDIyOE5wVWF6L05Ya3QyejArSFFMYVZQSC9TV1gzQTRVZ1JrNDlGNUV3YXp0?=
 =?utf-8?B?Y3BhTDl3b3EvNVJsZ0pNVCtuL1hZV3A4ZDQ0U0dnb21PallJQkYrQUtwekxo?=
 =?utf-8?B?amgybStLRUFNRXM0N01xaElZV0FCMThhTENWYXg5RmNtUFFhMklqbFp3R2lL?=
 =?utf-8?B?cjRqMG80VW1vVVJQRXFqVjJjeUFqYlRsRGpXUFM4WEs3bUR0N3JqTmhLeU5t?=
 =?utf-8?B?VENKamt4WS9lN09OdHhBL2dIZ1ZjOHVCRldGaTIwSVhVazY2OThFOFdXaWhR?=
 =?utf-8?B?UnVtNnVRaVQ2N2QvNkUzUjFxM2svei9LMFNicmhBd0dhR1ZiSE1sVUtEa08r?=
 =?utf-8?B?OE9VQ1lRMDRPT3RqVDE2OWh0VktSbEhCc0dyMjd1aENTWU9qeTNOTFlHQVR4?=
 =?utf-8?B?QktrUWErejZCVFQ4VDRxMnluNU1uNFMzWUxFeTl0R00wQkY3M1MyK0QyNVJs?=
 =?utf-8?B?OGxHZFRNMER6WG9ML1htTFg0a3RIOUlHQTByR2lpT3IrZExkemZzYmVaVzE3?=
 =?utf-8?B?VEE1Rll4S0FsV0VjUnNqOElVVGU5cWRlUmtDY0tQbzZsblVCVVB6aGJHQzN4?=
 =?utf-8?B?a0Evb2xIOXM2dFNwU3FHNVRyS3Q0cmRXUjM5VTFQOEt1OWdWQ2F1UmpFQWQx?=
 =?utf-8?B?Nld6UXMvcXVLN1JkZHJpSkFQUFU2aFpBR0FEenl2aFVnMHhFTU05WHY1UUJx?=
 =?utf-8?B?K25hd3VNcFR4WW5FaG1nWlROSjhlUHQwYU9wcHRKZURpMytsUG15aWE5WGwx?=
 =?utf-8?B?VkxqbkVvL3F5Zmk1bndXNVczMXEwL0VyRWtuMXYyb0VOODVuckRwaVZCZWtm?=
 =?utf-8?B?YmtBT29vaTVWNXFKcVIwSGQwZ1E3YWJ2SFJ3akZFR1lId3gveGRLNWc3NXMx?=
 =?utf-8?B?VHRlaUZXdHl6YkxFbGdxUXpNRG1zOW05WHJTdGdCSnhUZTlFTzVPT3A5b1g3?=
 =?utf-8?B?cjVRcUZlanI1enV4L0c4YVhvZDc1L1J0OHoxa0ZmNS85ZjZXaFJyKzlCNVli?=
 =?utf-8?B?ODJ4aG03enhSRXFYakdGVkR3RnkyUjFXUWppRDY1ZWJUdkFkVjJzb25mVFdz?=
 =?utf-8?B?dGdIcXdQZXdZcCtjZmN5VmJLQWpyNHZjTVlKY0xVMGpSczE1MDVmWi9FU0pS?=
 =?utf-8?B?NlF2R3JGQXJlNm5wNWRDQmgwUWlEV3laMnN0bmtlRGVFZEJuM0VyWHRXYVUw?=
 =?utf-8?B?WmNsUVhqUXRXbG93M3RoSmZUYTV0R0kxZFVYSFE1YnBsak1Mc2tMSGtFaDBB?=
 =?utf-8?B?MW9vNGZiRjJBZEppUHp0WUMrMGQyaGE3dzE3RVFlcXgwS0lzTTJHOWx6VHFM?=
 =?utf-8?B?OXN2OVpQeUdlZmVjL3FUTFdpWnd2RUdCNjJ1b3lnQ0VlRlVGcFM4NkdzQlpW?=
 =?utf-8?B?VnMrVUk2ZTVqTHRqRjBFZjlydkRoeU9NNzhDNmEvTEVVRmh2ek5Td0RHOW4w?=
 =?utf-8?B?QWM5Yk02NFR2Z3kzOXJOa3JHWmc5dzVpK3V0Ujh0a0ZuaWpRVTJoOVVLcWF5?=
 =?utf-8?B?ZEFOclRRSHN2NTFBTlJkR2NLQ0VvR2pDcUNBTFg3YlpoVld5MHQ5QS9aYmh3?=
 =?utf-8?B?RmZTWG53Q0VKK0ttRlREeWV4RWcxWFU0eDNPZ1hJOWtVbHJtNFdTbVh3RkRR?=
 =?utf-8?B?TzU4Tk9xSWFpUUdOVmV4anduNlh2NjFpRUwyMEpRUFNyMmYrWWk2U1Z4Ti8z?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94998f4b-d984-4fc1-1eec-08db6e0db6f6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 02:02:18.9725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FVy5eLH1o6YAx7iPg+AoLyPV82YoX7Yo8su+YUAzXhlms5D8RfiVXot9PltKpnitGSsR/47PMByk4YEAaMmZjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB7993
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 6/16/2023 7:50 AM, Sean Christopherson wrote:
> On Thu, May 11, 2023, Yang Weijiang wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Load the guest's FPU state if userspace is accessing MSRs whose values are
>> managed by XSAVES. Two MSR access helpers, i.e., kvm_{get,set}_xsave_msr(),
>> are introduced by a later patch to facilitate access to this kind of MSRs.
>>
>>
>> [...]
>>   
>>   #define KVM_X86_OP(func)					     \
>> @@ -4336,6 +4339,21 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   }
>>   EXPORT_SYMBOL_GPL(kvm_get_msr_common);
>>   
>> +static const u32 xsave_msrs[] = {
> Can you change this to "xstate_msrs"?
OK, will change it in next version.
>
>
>> +	MSR_IA32_U_CET, MSR_IA32_PL3_SSP,
>> +};
>> +
>> +static bool is_xsaves_msr(u32 index)
> And then is_xstate_msr().  The intent to is check if an MSR is managed as part of
> the xstate, not if the MSR is somehow related to XSAVE itself.
Make sense, will change it. Thanks!
