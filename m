Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 458156F6544
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 08:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjEDGvp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 02:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjEDGvn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 02:51:43 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C602728;
        Wed,  3 May 2023 23:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683183099; x=1714719099;
  h=message-id:date:subject:to:references:cc:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eBOsXmehHDTk/TaZe2P9g+7OF8qSaTa7inOTQGqmFww=;
  b=YEyXPYpw+cvc+fN2VvIcI+HmffrYeSi/CnwZvJ7+wokZkGy6ql7IGb0G
   4phw+/nXNWnQjlQSk3HmK+JbqxQvepaSJs0O2Js+laDxvBFUPHPBZN2WF
   rvZJxzv6TDomHim3GkR2j7uODWrzkr+hH+KT8iEJRPRCzQVeHQHTAFw7U
   4WkQctVjqatk5A6Wfx/R0tkxvRloTWLH1xOgo7NwGHUz7Zz4jKcHqDg+k
   AOudHoGh2x935M4oJArplW4kQuLctOMyZw5JU6V7NMjQuZ1Yubpr0D5qI
   Ctr7rC2c4RbF0/ItmHN2XyCZkUfPOyFlHWJFAEzV9sknRNr6DtvPmunT0
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="329207398"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="329207398"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2023 23:51:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10699"; a="690982228"
X-IronPort-AV: E=Sophos;i="5.99,249,1677571200"; 
   d="scan'208";a="690982228"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga007.jf.intel.com with ESMTP; 03 May 2023 23:51:38 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 23:51:38 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 3 May 2023 23:51:37 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 3 May 2023 23:51:37 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 3 May 2023 23:51:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RsopWOaHHECxaGUeTMpfHagVlBVPUQeQ7hvCdtBA33ZYXqkR9zVklJeB1rP0tbMul14CoorfcFgM5bT759zSLi+qvbR8BmTRTDHIr3Tb0NhEZWm5qkYZ4R6eutddJGsJQQtg69p7x8ibxEdsg7kEH1u4CdE5QEl8znTj+ALVV3KGXVmy8G/LAjbldpfnmlVQK/WC/TYVypqsmA39ltopRNJ1/vWFCIngR/jE5GcKaPoKWpQsr2t2Cr46qnu+AjrxE7MPJi2TVG/v1j+6EydgvDFkYjzJ2hoLaIDzLTIW/RbVB1Ym0IiIniBSAfn8Y84k2IrQDgFCZ9zLbmHJaNEVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GxCdTpqeHNipQqmWZHQ9buHeUnzSW1yquePzNJ0ht20=;
 b=feY+Als2V5peio3FAzu7T33V4iwGwxNAN1SVM6w+TiYn7ZCdltKDPIFs0TF1rchXIp0MBlbLnwAwzzc4FNONn18EXI011Iyho2eAtYytwmsvpqsCp6XNeKz1txuPvgKXmMPkJp8az7basZRfNvxA2SOFVk5L9raA41kx8L9+HWwCC5XXyppOBbEIzZsv2qfH0ueBtLn79e7IQbBe3ahxrzLiQSpzJDvSfYqoisR8jJ2D3IcEaIMEh0jHichFvspJwWsRiTE0K4AwAB2NFynWMDVDZxoDrc/yby5iBu8YXXinSQDgxQmU1/fuVw8hHYR0simxNK8T700SgvQzACGbMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CH3PR11MB7724.namprd11.prod.outlook.com (2603:10b6:610:123::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 06:51:35 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::1ff:c7e7:87de:6d97%5]) with mapi id 15.20.6363.026; Thu, 4 May 2023
 06:51:35 +0000
Message-ID: <7fbd23c3-403b-f7c4-27d9-f3368c299435@intel.com>
Date:   Thu, 4 May 2023 14:51:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 21/21] KVM:x86: Support CET supervisor shadow stack MSR
 access
Content-Language: en-US
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
References: <20230421134615.62539-1-weijiang.yang@intel.com>
 <20230421134615.62539-22-weijiang.yang@intel.com>
 <175c826d59f1ac77fa588908d3768ffc2e79268e.camel@intel.com>
 <c9747bd0-2a1e-a7ef-4775-b5ca7c00b24e@intel.com>
 <04be1306737a8db851874ff9283401d67edb34b8.camel@intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "john.allen@amd.com" <john.allen@amd.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <04be1306737a8db851874ff9283401d67edb34b8.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0193.apcprd06.prod.outlook.com (2603:1096:4:1::25)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CH3PR11MB7724:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ac88eb7-6230-4ecf-3836-08db4c6c0071
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jTV5kbXo9SacZ6KWQNQr/7ut2MKRgFnQTmdCxkTPvxXHKiuj4fdcwvIOb8ILPjzqpF2ij8k5mx6NlTrdPG39z3VhiP8LVPj8wbEXX/nmbsPwFN6PzQCMCAN1fi+oSo2NxkDFl+g0juMwNOXBHi8kQ4xyReVWwXdCNJDaoj1lAjkJMCQdhWxZnAnLGKVcv5loTF2HFCmhLJ1ChwPUlwzQIFHrIBu1GS6hN283F3B6Q3KnlcljeAUTKMJEwQv70r8y69/ymfeN3oFAE/UTt4OgVAPpeM/5F2FbSMunAJ3pBOo6TNjomrFn8QdeWnW8QJLZz32sK4DFhcoOjCgoyHhGvNixN5Q1FPD1PhIcBk2zfmj0OO9bKpAyBu9JOUR7OKT1StoUfl6VByDplfVe+Sg5bTZHyBz6iLT/E/iL8EGP4DO5FWNPiC7hHFGWVy5EGdmqjnosX1gJsmpTXQS2Io0btxffbEFCRD9N9pULCEkkUfXauQY0Qtq1R6Q+Mjmf/E7QG/WVm17WzNq6s+Xd1TNRyv0vdFbjRaygOCXGFHBsqwC611eFYU4FTDbg2iyD9+souapYmJdYvkUToNKLVAo1jqSlUF/bWgxMe6qw5uwPV6G20EnEECeRkqzZfOx5ZXBC6uZQtY/I1IC4CQSPoCVOeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(39860400002)(346002)(366004)(396003)(376002)(451199021)(41300700001)(83380400001)(2906002)(316002)(5660300002)(66556008)(478600001)(66476007)(38100700002)(4326008)(6636002)(86362001)(82960400001)(31696002)(54906003)(37006003)(6486002)(36756003)(6666004)(186003)(26005)(6512007)(6506007)(31686004)(53546011)(2616005)(966005)(8936002)(66946007)(6862004)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTVueTJFQzRBVU02ZWNQcTR0R3UwWEM1ZzFUNi9CQWRvV2ZvRGluMHNiQjVy?=
 =?utf-8?B?TjZhNkNXQ0hrQ3dsMGxBVHNFNFEveFNqeTVQWnZLT29kWUlpRytLUHNZOWoy?=
 =?utf-8?B?ZWJYWUlpYzYvVjdWWHhnRkRQUWtOaG1Lb1h3eXcvalhPYUYxSDljRUlrUm5R?=
 =?utf-8?B?Z2VLSFh6QWFncnFnM09TbnVJWnFLbHJZQmpZbTE0ZUpiUTFwUy93K0VJN0V5?=
 =?utf-8?B?bDBwUUhLbFd3UlFHU3lieEF6WVpodTVYQ1ZTUVFZK05UMG9mWFgxSzJmVVFQ?=
 =?utf-8?B?RjdZaHF5Y0RqbnhHK2FJY3RYTXNjNmtKTUNobDVCN0Yyd0YxN2xsSDUxZXJV?=
 =?utf-8?B?SWtQL2E3ZUpqOWJwQkJRVXpJbDFSbGozZmE3RnRzZHpBTlQ4VjZPOHdaTFJR?=
 =?utf-8?B?YUpXdkltSVhOblptWnJTM2R6SWtOWE15ME5kRVZPc2NpRkR2ZXlMZVZOY2Vv?=
 =?utf-8?B?RWZIbkRybE9nL0ZZT3k2dUx5d2hQSlB1cm1uT1JWaG55bGtpTXUrY1E2YVVp?=
 =?utf-8?B?aWlGN05XL2d0bFovNVp1Rjd1ZUhwRU1pYnBhRjFhY1R6N2ZGL1Q4WkNmWHFJ?=
 =?utf-8?B?TVlBTUJVa1pUZkt2bjFGZHVXWk5Ta3AzT2FzanVzR1Rqb3pVMlRXcks0UDFv?=
 =?utf-8?B?N05XbkZXM0VGMEs0bU5tS2xFYzRXSkhueUtlQTBGSVlxZ0pTdEtUWCtTVEwx?=
 =?utf-8?B?V29nUXp4QWhaSWFBRDlUdTFWMDdVTjVPb0tFaG9VMTVwdVdwMFg4ZjgvOUhW?=
 =?utf-8?B?cnEyWWxUeDNmNXBEc0sreG1xSU9ORktTTm8yMGR6RmtvQXJTMTd3RkxONGxF?=
 =?utf-8?B?Y056YVhZdEs5Q3luTDNlUzRWREx1NDEySTZBeUNXYkVUSVVyZ21xZ0sreGo3?=
 =?utf-8?B?Zy9uWjRXQ0huZmI4bCsybzRwcDZFYzNpenVMNnJJd1lpa1ZkTXRFMmlFQXN6?=
 =?utf-8?B?OFVvcGxxWFZmb2NLd1BHWVlwbHl4bGd4ZjZEM3VVOGpPSXY0MnczZ0lBbmZS?=
 =?utf-8?B?N2h6aGhvZ2tNbnlIeURSMmYxZW84M2FOSnd3aGpKMTFmL0VDNmpLTjlLZTRY?=
 =?utf-8?B?NE51WU1xdVNIMUJpU3NLY1U1aXk4d2hNbFpuQWxLdUx0Q0JJSUNNNUZ1c3V4?=
 =?utf-8?B?UUNaQTdoSEZZSWVXYmZNMHBjRjY5MDMwREFCN0RZc1dtNS8wbVZTb09EbDNO?=
 =?utf-8?B?Ujh5clA4RGErR0VvMzh5RXl2WXRyL05iVDQrcVNBT3crTThVY3doSkFVN0t5?=
 =?utf-8?B?dzB6VnF1RzZXV1hzRm5JeVNHWUtCOXI0ZVZXeVBpUythVHpyelZ0RWJuRm1M?=
 =?utf-8?B?b2ZYTXlGRkNXbG5rdnRvVzVZaGpaOGhSM05kMVdIZlFiYkU0VkFZYjByMFcz?=
 =?utf-8?B?ZUJhVWZzVzQ0NlcvQWl1aEV3bzNFUUNaKzAzU0Z6Z09DL0lIL2RKSTNCTGhw?=
 =?utf-8?B?ZnZHQUNHVzF6TXJkZloxekRZaUxONzJmN3RGQTRtMnFIcUZxWFo5Qm9qc1Jk?=
 =?utf-8?B?QlVYdXkxS3hGZ0s4WVFzVTFVUWlrY1FiL3lGenkyRGhNL29CVzlZeU1QWEhS?=
 =?utf-8?B?bGEybUxENFkvdlUrSFNYMWpweVRYbnozNS9yd1RvbEtxcytwMUg0RGg0TEJ3?=
 =?utf-8?B?YTI4eWdTandkM3UxaEppbXJXVWJRVTNKOUtvelQwRkJnZ3ZrbmkvRlpMNk80?=
 =?utf-8?B?anY5TnR3cFE0Ylg1Z093VkZwbWdTd2xjeVBGQm01WUdoMC93UjBVSDJaSWpG?=
 =?utf-8?B?TnFvYlNBeDhLRlFXL1Nic0QyS0hmU1JtZE1RMm9SWXZlbmNzMlBXcWV5cEdB?=
 =?utf-8?B?ejlBZS9vKzUyaTl6UHFhUlBWVTJGWUhkcmMySXgxSFg0UVJSVDBTcDNvcFli?=
 =?utf-8?B?L2d3ZXpjU1B1YTNxekRSbFFBS0tQWGE0ZHUvT3RZakM2SDY0MXJHVlgxV0cx?=
 =?utf-8?B?VHRDazVyVFd5djAzNitUekd1eGF0WjE1R1h5alJvdFV2Z3N6YVdtTUgrdS81?=
 =?utf-8?B?WUhBZGNRaEdQQnhGWFNhL2d5MGZGTGVWbEx4YUdMYVVSaytva1JaaUJGaFJa?=
 =?utf-8?B?NnBvOTV4dnVUakJqZGt5MHlmTGtYbFpKZFVFMHRQaEVtNTcxQ2tBaHh5QTVi?=
 =?utf-8?B?Q21FZXpuWlZDL09JK29qRng3SVVRcXM1NHZ3dVpUTmE0UHRWV01Hb05QNk92?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ac88eb7-6230-4ecf-3836-08db4c6c0071
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 06:51:35.3639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5EuoMJvL0U7EczBDSW87NXjGYRQ7AIT//zgupyP+YiPe6nlqT9M9OXEXfrK58WK02u9gVz9uZdcRmeSXBfJeeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7724
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/4/2023 12:17 PM, Edgecombe, Rick P wrote:
> On Thu, 2023-05-04 at 09:20 +0800, Yang, Weijiang wrote:
>> On 5/4/2023 1:07 AM, Edgecombe, Rick P wrote:
>>> On Fri, 2023-04-21 at 09:46 -0400, Yang Weijiang wrote:
>>>> +
>>>> +       incpt = !is_cet_state_supported(vcpu,
>>>> XFEATURE_MASK_CET_KERNEL);
>>>> +       incpt |= !guest_cpuid_has(vcpu, X86_FEATURE_SHSTK);
>>>> +
>>>> +       vmx_set_intercept_for_msr(vcpu, MSR_IA32_INT_SSP_TAB,
>>>> MSR_TYPE_RW, incpt);
>>>> +       vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL0_SSP,
>>>> MSR_TYPE_RW, incpt);
>>>> +       vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL1_SSP,
>>>> MSR_TYPE_RW, incpt);
>>>> +       vmx_set_intercept_for_msr(vcpu, MSR_IA32_PL2_SSP,
>>>> MSR_TYPE_RW, incpt);
>>>>     }
>>> Why is this tied to XFEATURE_MASK_CET_KERNEL? I don't know how the
>>> SVM
>>> side works, but the host kernel doesn't use this xfeature. Just not
>>> clear on what the intention is. Why not use
>>> kvm_cet_kernel_shstk_supported() again?
>> I don't know how SVM supports supervisor SHSTK either, here just
>> follows
>> the spec.
> What aspect of the spec is this?

I assumed the supervisor SHSTK states are backed via XSAVES/SRSTORS with

XFEATURE_MASK_CET_KERNEL set in XSS.  This is arguable since implementation

is not determined, but XSAVES is an efficient way to manage the states 
compared with

manually save/restore the MSRs.

>
>> to add the dependency check. Maybe you're right, I need to use
>> kvm_cet_kernel_shstk_supported()
>>
>> in my patch set and leave the work to SVM enabling patches. I'll
>> change
>> it, thanks!
> Oh, I see the the SVM patch [0] is adding XFEATURE_MASK_CET_KERNEL to
> kvm_caps.supported_xss as long as kvm_cpu_cap_has(X86_FEATURE_SHSTK).
> And it does not look to be checking XSS host support like how
> kvm_caps.supported_xss is set in your patch. It should depend on host
> support, right?

Yes, it should rely on host to back the states as long as the supervisor

SHSTK MSRs are implemented as XSAVES/XRSTORS managed.

> Is that the intent of kvm_caps.supported_xss?

Yes, it's used to indicate all host XSS supported guest features.

>
> Separate from all that, the code above is in VMX, so not sure how it
> affects SVM in any case.

I was confused a bit. Yes, the pass-through check is specific to VMX, 
there could

be other implementation in SVM.

>
> I might be confused here. The code just looked suspicious.
>
> [0]
> https://lore.kernel.org/kvm/20221012203910.204793-8-john.allen@amd.com/

IMO, above patch is not necessary as  kvm_caps.supported_xss is 
initialized in x86 part and

shared by both SVM and VMX.

