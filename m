Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8B7970F081
	for <lists+kvm@lfdr.de>; Wed, 24 May 2023 10:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239861AbjEXIUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 May 2023 04:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239537AbjEXIUX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 May 2023 04:20:23 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD994189;
        Wed, 24 May 2023 01:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684916415; x=1716452415;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sbZXHlwO06WnbP8kTBRIzz41WtDfqsNlDzjdBBWqElE=;
  b=LtcZ+rjzS/7Qsi08HKI9889NSpzaPr2R6t+vbA19uc5Xy1Xet29rGTbx
   upr9kXpK1O8XUndKttmxjOpXVfsu9wLgOtL/V+fxufQA1LyN84R0SJdId
   9q/xhelfFoD6SMycKToz3xV6C64dCYvt7PsjPUa7NudAZj9yMADjGNPJO
   TheeznHsIImTPQnBGF0zj5mVwTRS9ILH9Mc3gHhuH2STpvI4sKzdnHbqx
   M8vMv8W0gdIiOrw6u2yR2NhAE4WDcXBHXSkoSmSLiPR4b/It7huOoyC/F
   06gCjHPtyqA9nTJUAGxJoZliHdUuNMYNZhvZ6voJV8JMgcfN6XrTicWI8
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="439848320"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="439848320"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 01:20:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10719"; a="950910589"
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="950910589"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 24 May 2023 01:19:51 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:19:50 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 01:19:50 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 01:19:50 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 01:19:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=icWaGbm84Lg4xb0En5aXCxdH5x3RW4pIJWown5oKs9bx3o6XMQ72uOU+rweSaIsYWyO0gLTmQuLj3rEjZMUprvXazt52vSMLQLQkc0wcJ/MXTPqkMZVw1El/wJOwY7Hag3RgZMnyy835KTy2cdeWy1UDrLQD/yZtGgHF1yG+CGl4iV/6o1Zva3l4h8eWlFkewLby5lc77tDOMu1v1XTI3CWjEt/0Xm62h7Qm2lFmFoatxUMwshlEPL4i83X4qMEof1a7qF5SvhHOARkcVxAHClH32rEnqatLbPKKL2+d7Ura66/IW4H13vjaQE0BG1TCoCFzV2KeqiWEYTnnpbYIRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5RPN749uBdpWtndYnD3WViCj5cEO3dEteDesCwv124=;
 b=ZIvDwJa6BUHQNVgllLuVGxj1pRxSZqxFj8UkovkOf74XzurRTYa/6ebBynFo6m13eXy6TBcZUK98QdJx6+k0WuM0OBgPjTOmdIXfESLNo2TUxRMQvKYdStXcuD0JoPlrzEB6julxWp8D4yVerKFRm3DFaQQQC2h+2PPr2LoP6drYVVYWRkB8+zJU5Tt4O/xZ1RtVOQmWxVmUld75TSq96ck+72Kqh4ohCperaTOSoRgsCyUNikDxrJPi8755s6VejBAGnwTJMqMkxJ+0jvpMrdBXiGLZ8WpDlTeuocMAswAZX4HezeRcgmSQoWF1r6ioFwKAv6mRVG0rrCF5Jz4GMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by BN9PR11MB5404.namprd11.prod.outlook.com (2603:10b6:408:11d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 08:19:42 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::4f96:4b14:c54e:6261%2]) with mapi id 15.20.6411.028; Wed, 24 May 2023
 08:19:42 +0000
Message-ID: <90eb3d2c-f692-b6d4-d1ba-2e63b4d11936@intel.com>
Date:   Wed, 24 May 2023 16:19:29 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v3 06/21] KVM:x86: Report XSS as to-be-saved if there are
 supported features
Content-Language: en-US
To:     Chao Gao <chao.gao@intel.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <peterz@infradead.org>,
        <rppt@kernel.org>, <binbin.wu@linux.intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-7-weijiang.yang@intel.com> <ZG23e/zYAiRlfrk9@chao-email>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZG23e/zYAiRlfrk9@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR01CA0198.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::7) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|BN9PR11MB5404:EE_
X-MS-Office365-Filtering-Correlation-Id: 43856248-d435-42b1-aeaf-08db5c2f9fd4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9sc88RBw2EN03ponHjQs7OVGLi++BpA7DB6NF7VrtiVGFXkdNoZq8XXUbbDBlCXB7NGTox/IoMqzGVdb3SwCW9hhDXduCgOXn3R8hckrqVc97m6XU14Knkq4Ua1Hw2YhQ92tAffNDIMVvtqNlQqTucDxX+XHkgX2e3NHsEzG/m7ITmXPLkO6yfjkxpMq09k9JW4SPFbfo6/rBd2eg9BAQwpuaa6aXFNVyopkqDFLjumUrfMyU1+thGUHriahxG7+2i6rxNVZMV1zzxr6WR3T/cKoY8ihmCArDleC99bVU0xMqOI2frfYrG2mJimu3+S0edUbZFeV2W4db13uw1b+5eia9evc8EAsTIBjho596g8yqyQSHCkIyxAHHT0FDtHmowEw8RvDlD+xF9M6JIaxor7LyuyVQWJOpJXFCN7pOQLnfQ7+iVEjJ1EYal3etLl+Vtrel+2w2M1IjMWWdJi+IL1whr0wzyM9OMncpCG2c0Q/EN6h3ENpXaWGh6pLdKsoepd8QzQVhZwvzYbLT4OPLTipxum8V9o1SIR8y9QW7yO1D0INK5uzMNxRjocrHHL+pQs8opLBFBVcMYkyandVsfsCEaH81/zs1NGlEzLlZx2nCDMKHRSeCJXezyRzfBPI8Jw/duHLylYJzgKDQuiLyQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(346002)(396003)(136003)(366004)(39860400002)(451199021)(316002)(82960400001)(478600001)(37006003)(38100700002)(6666004)(31686004)(4326008)(66946007)(66556008)(66476007)(6636002)(41300700001)(6486002)(86362001)(8936002)(8676002)(6862004)(31696002)(5660300002)(186003)(53546011)(6512007)(6506007)(26005)(36756003)(2616005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SGo1MVBPY20rN0I4WE52N1Rpcytzc2RuVFArNEVlRXBIQ3lxOXgraGl1NEdj?=
 =?utf-8?B?NWxPQ2FPS0N4MjZiTFphMGEwSWZOSFEwT2lXZllIVmhTZVVQeU5tbUN6R0x6?=
 =?utf-8?B?bXk5WVFGMENPcFY2ZGFMSGlkZXhFd1lEQ056RS9vMVZDc3BVMUdwU0tiQk1v?=
 =?utf-8?B?anRCdDBWakV3Z0ZxcjdWRkcrRHJhT29LWkJKTWRwYk5DQjNKcDVlK2FxTXdE?=
 =?utf-8?B?UHJEUE1JNmhJRGxSVW9yenhhek5lc2hJQ0RaRWVJNTU1VmM3R3BJN1h4SVVy?=
 =?utf-8?B?c05Za0J2R3Q1c1R0ZkxWbGlaQWJrejFtMUJjclBMRmg4TkRPeDA3VWNoVkNq?=
 =?utf-8?B?MTFBbElrNUpIQVpqVUxlS1d4NFhmeG5uOGJqMkd2SWtYN0JLMFRtYm1WYXgw?=
 =?utf-8?B?SmU0Y09qTEhZNnVibnQ0OVJRK1lBQzc4TElMVERETUVqR0JMbjJPZXBteGRy?=
 =?utf-8?B?MERlVlhaV3dSZ0g0eHhXZlJ2NEpUQTdBbEgzZWFyUmhPRmFWNzhWYkVVMlJY?=
 =?utf-8?B?OFFzK0lVRC9QcHZveWFSWVJ6YlZwTytlRHIxaDlNYnlOdWg2L3lqbWRlTi9Z?=
 =?utf-8?B?K0ZUMFlQa0pzcmJINXVUZ2lFTGpMbGtoa0hHaDdKcEdEV1VVSjNjYjRJYW45?=
 =?utf-8?B?RHJpbUE4RnlYSzZETmFRUDVMVDNBcDhuZnhvcC8rdjZ3UXNncjkrTjZxMU82?=
 =?utf-8?B?dzJNbUhRc2FvcVpRaDUzREhXU1lqZjVHSVA3NXF0SE0zbkNvVC81TFRCamZI?=
 =?utf-8?B?UWZ1L1RLVTJYeXU3OVVMNi9xbGhzUkNpbmRoVWFMNXp2dHdPVjFCcUtUdTJU?=
 =?utf-8?B?M2RtRCsrZTY5bzViOWZHRnFDYkNtWlpkcFJxYjBrNTM1MHlsTzJBQWk4R1Vj?=
 =?utf-8?B?Q1EzcUtOejJFZWF4aXFEOTF5TVlKN1VMMWFheWd2V3A0N3VpN1VYdU5PQzE5?=
 =?utf-8?B?TExOYWN1d3hNNlNBOUZwTlpoM0RQQXVRbjJPM1NYV2VrWHdWWlFkeXMvbXgx?=
 =?utf-8?B?QnpnSkVtLzIyQ1c3NHpiZHpwTlNjTC9xbjB1SThONTg4eEdyK2FJckllZ2VE?=
 =?utf-8?B?cTJqSXZFSlFYMVd1TXhBWVh2bkhQc0sxUENoeEEydTc4YlNGRHhVdDFQSTFX?=
 =?utf-8?B?cEdyWWZ2cDZPQUUxZnZXMDJhdFVrenJSQ3RQdHBZYWR3Qk1LUmlmbytlbFpy?=
 =?utf-8?B?Mm4rUGdFSXU2Ly9ZeStSbnpPV3JrNHJIYWhXZm1VaWFXWW8ydTg0WXdNazJh?=
 =?utf-8?B?Z1BmQklWRld5eVFnZ3E2cGhhWkNjaEEzY3NjTUl5N1pyNjhKWG4rVXQwVW4w?=
 =?utf-8?B?TGx2WEF3R09mcWRveWZOSDhWcXk1elhnNGFiVUx5RGZPWk0zQzhBdTgvTVBC?=
 =?utf-8?B?eVFtMDVteHhtZFFXVm9PR0wwTjkzTWNPVW13K1R1MWExM0lYdzBGREd3TUZy?=
 =?utf-8?B?OTRMSENYOGJlU0tIakpQQjVRSzE5bUdmUzhFQ2VHclBPRllBelE2eU1Tdjdl?=
 =?utf-8?B?S1pTQlpkVHdVQS82WmovODBUdG5FNk0xNGhhckZPNE1lbkRUenlEejdYY25x?=
 =?utf-8?B?emxYdHRiOXVLdFFzdUNVRU93L2d5ZDZnY25wSk1sZVRiZXlrSjZRTzREaTdQ?=
 =?utf-8?B?SitqNmZyazYyb1REU1ZVWkw3SGVMNU5LeWdkOUh0QkxoUUVGWXV4UGlMRkRB?=
 =?utf-8?B?d2VWUGZwYUdoVkNJQlM5dldJMWkrcmxKV2lSWEVsU2J1cU5rdnhlRk1nZlY3?=
 =?utf-8?B?OVNyTW9za0hTT2RENUJkOTdjQjB1Mk9JWUYyUG94aUxkdTBXQndFYjNtYlBj?=
 =?utf-8?B?NDN1RHVWbGd4cTk2WHJBSXVObFdjbit0UE9NWTRvamNmSHN2TldkR3hSMmw5?=
 =?utf-8?B?ZkhkMW41NUk4MWZPejRNT2xObTF5UXc1c0c0eHpGTnlOUVdaV0pOK0d0cFU1?=
 =?utf-8?B?OXBlY0pJUmhXWXJCUHM5VHp5TUtPMTBKSDlCQ2RoVk8rRjhWVzd6MGtoaWVO?=
 =?utf-8?B?eVE2cGNmbXBWUjNNWUFMMXFwM01qdmswUXVDZzJVbU42MGZiSlM2OUNvRmJt?=
 =?utf-8?B?bEIrcjNHbTBENFg1cjY2OEQ4VHd0RDZoaWdyOXBwSkVZQ1ZHcGFMNGlFSmR2?=
 =?utf-8?B?NFdmSG8xOXNmUzkzdEhScnhFREtBM0JoZEh5eG1SVVJVcy9IbVgvYVh2b2FQ?=
 =?utf-8?B?akE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 43856248-d435-42b1-aeaf-08db5c2f9fd4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 08:19:42.2509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihgAFiwtH+fRzd5fkjgKDzX3MUXuaNRtiVLpwZeYexwKctEbHxSN/qxHQINtikED7euu/Zb+mAx8cto3TNYjVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5404
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 5/24/2023 3:06 PM, Chao Gao wrote:
> On Thu, May 11, 2023 at 12:08:42AM -0400, Yang Weijiang wrote:
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> Add MSR_IA32_XSS to the list of MSRs reported to userspace if
>> supported_xss is non-zero, i.e. KVM supports at least one XSS based
>> feature.
> The changelog doesn't match what the patch does.
>
> Do you need to check if supported_xss is non-zero in kvm_probe_msr_to_save(),
> e.g.,
>          case MSR_IA32_XSS:
>                  if (!kvm_caps.supported_xss)
>                          return;
>                  break;

I looked back the history of this patch, there's similar check 
originally, however it's lost

during following rebases. I'll add it back. Thanks for pointing it out!

>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>> arch/x86/kvm/x86.c | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index e7f78fe79b32..33a780fe820b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1454,6 +1454,7 @@ static const u32 msrs_to_save_base[] = {
>> 	MSR_IA32_UMWAIT_CONTROL,
>>
>> 	MSR_IA32_XFD, MSR_IA32_XFD_ERR,
>> +	MSR_IA32_XSS,
>> };
>>
>> static const u32 msrs_to_save_pmu[] = {
>> -- 
>> 2.27.0
>>
