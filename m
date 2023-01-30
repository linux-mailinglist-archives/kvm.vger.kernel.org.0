Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A156805F6
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 07:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjA3Gdt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 01:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbjA3Gdr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 01:33:47 -0500
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B163E19F39;
        Sun, 29 Jan 2023 22:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675060424; x=1706596424;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rC8uQduW2atijLapafQipmf646eSrhZD2CLu3rN9hUw=;
  b=jMVaFeCTdgxcWbktGgF+IxyF4pfpmG+9xip1wPxZChX6LzTeXoBXZPt9
   fG/pB8191kUjxiZacC3A27F91n7ysUj2jhYy65+Hfqykd4+GIkyN43HJv
   vgyDmLSoEkeu6T9/zfKhWLVRB5t7U4Xj1JDDO4I4nlVEFk0gw0+yJigeA
   8MjNO5PhfCukMp/1340Y1ID2S10Ks1HZS9NC8YKrBYYsLpAzJrqDJO3k/
   PkwQGDVplKZPZZGdBxFouKJrZzAWxwVj0msU6aVdZiTlKgJROgw4mDcEA
   DYLkqNc1wozalWDGxtJNpqJhtVaCUWGs5SX++UiYn91OUX5pZvvuCZUBf
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="325182990"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="325182990"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2023 22:33:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="665968663"
X-IronPort-AV: E=Sophos;i="5.97,257,1669104000"; 
   d="scan'208";a="665968663"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga007.fm.intel.com with ESMTP; 29 Jan 2023 22:33:43 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 22:33:43 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sun, 29 Jan 2023 22:33:42 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sun, 29 Jan 2023 22:33:42 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.49) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sun, 29 Jan 2023 22:33:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqFbfNy7TFRCaWULBqnjTKNqfGrLJWbnaPTYLtAAA0+gsg3apMJrhC9Zdmpb1dHr01C0oPoXPfVwYuewv6NdjA3tWVsr7xz9FA5dSuuEJfmBPs0shcD10mxm1KJvZBfMX1LXAugHh1BYVzeJPHIPsb9PFW+V+OqUDfIumsPMHBwGMUxdnsX0jC7ennIV+N7mCwuHcqL2cvEnA3RX+bRmNDtDTWI0imesKn4XeQlUNy4BHIWsi5fKHcCmE+ixd7HzS0y/S+BSHgsaJYnJj4uQvojebZNYzTolmLYGiW2F23Sa/FSD03HgHoTIU81K6/fdOoJCG78ZwMpzQAkm3pfWnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fj76sGVVQoPUqyC4X/bBbksmVmRpXPXwqDqMNdoxzSE=;
 b=QWUDRyMdSxPlgQ/othBkwHM1dkK83cXQmKiWj0pbN5GN+uyzDhDALti9hdDPMaE7fEOkq4+o7MN+vstvZqr1yuLsvwY66zkyQXpMT+OtTGRe5qxB45Be7cqcok0Zgesc5nvQrFjcdnU9P2N4P4adHUN+jUhPKlRT8duNg1dK9veGyzU48NDRM3CJAtij0T91B7L9tJTncTh0mr9JBs2TT5GTHbU7A/dnaNtGfnhu+OVwxgtsRkW+i0ry07Oz20vvwjENkbaCB3rY16wFKLzhYVI+c6CtxEWC1DIbfY67RBXlfuf+PehXCcfm7uPONRPQSCrfmn7zH/kvApTDw0q41w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS0PR11MB7832.namprd11.prod.outlook.com (2603:10b6:8:f5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 06:33:40 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 06:33:40 +0000
Message-ID: <4e6dec2b-29af-7772-0427-a3c28cb2ab52@intel.com>
Date:   Mon, 30 Jan 2023 14:33:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 03/15] KVM: x86: Refresh CPUID on writes to
 MSR_IA32_XSS
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-4-weijiang.yang@intel.com> <Y9LZhsqxRjMjbK3s@google.com>
Content-Language: en-US
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9LZhsqxRjMjbK3s@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KL1PR01CA0031.apcprd01.prod.exchangelabs.com
 (2603:1096:820:1::19) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS0PR11MB7832:EE_
X-MS-Office365-Filtering-Correlation-Id: 7ce3342a-5503-4dcb-8ef7-08db028becdd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RQCPAv5erkaJrZ+365LLiVKAIqCcePQTBoMGepu5w5ysJ32CIpIaiNluWd6yrEvSC2gzE3DUZaKf0bjn9rC9zV/fwmbtODhWBPuMFug+5jNrLtsUIr2gI/WJ9KvCv4Cnk8U+Zh/BpxQV5tOohojE0sEFbZng9bUlH3rVabV2F1MPyF048WGf8tib1PizBkCVcCR+FN2sFMICVix0bmOR973dmiLcgtX7XA1f8LA0t+1h1g7wDV9FSMhFslFpGc9Hs9w4fTnFkGvootPGd4GjVq+FDKH3Y/J6F/S66iCf0Uz5r6JudFbBj1fpfWpOsK+mm8BPzEe5hgbbxlxIv1umOJcuku9jsMdXxZmsB6ltXBDy6YgUObW40JiMnHUCHXwBWcFDmg1yvaomZM5en9MxC6Umuawdsse/QbE12I7v1deE43HMhtDu33K4QkzcKL2pvY1iBk4uCrQCthSYuC6IuOTRRjEWD1eVnaqaZPMjCHfVjaTyiLgUuBxnD3PmLe7dFHvPPJogkJJOKbVmSoB7Rwc1WY8SCe+Kog4UzM+CKKilIW3aCVgKzrv+snzOCDH7TVTi1H6ntDToPCL69Co3Q4MT7GO+alEs/+zU0cboqmzAcg8p0LjX7aZpv7JEL4XZd7Oj9Q+VaX0YNCGwFVVF+vk1f28zepxrO5x7vgtwbuzydMPayl+59FJNuRlUQ5egXguIoJd/Jf3EqLw8Eeg0fPWnU/U/qe6X25J5kgcRpoU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199018)(86362001)(31696002)(82960400001)(38100700002)(36756003)(41300700001)(8936002)(5660300002)(316002)(66946007)(66556008)(66476007)(6916009)(4326008)(8676002)(2906002)(83380400001)(2616005)(6486002)(478600001)(6512007)(53546011)(6506007)(26005)(186003)(6666004)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MTRTVWxGTmdGVkUrblphNEdwYkRkVmp4UDB3V25wSVdvUkdFN1MwbDRRL3pC?=
 =?utf-8?B?MWxPMURiZHZJbWRUbVBkQm11NXZaN3lodkVNcW1hSTlqV3ZxcUJTM1ljdVRL?=
 =?utf-8?B?aXB5aEpPNEFkMjZaOXlLRWhmSlo3bXlRR2VnUU5KVHdBWWRRNjZiUVpvWVlO?=
 =?utf-8?B?MU5JQlJJNG5PazIzZytYNi9ENFhQSGJWMDdKNEJzbFUrUEtTRjNranlSZWhT?=
 =?utf-8?B?U0hndEg3Ym9qUjM4Rzlta0NzeWJjdmhkY3VMa0FVODVacVpYOW1hT2h1WWw4?=
 =?utf-8?B?RXJhVXBaWVJrd0lLUysvUjNLM2taM1l1VmU2MlJDTUpld0dlOHQxS09YMGg3?=
 =?utf-8?B?QkQ0UXVlRXJLT2NMcXRFNkdWb3NHbHFpYVpMRkhyZkF5WWRYS3pZaHN4UlVB?=
 =?utf-8?B?Q2M4QjRhNHBDR3ZQMThyOWU4RlhlYXBYMG9YWFdYZW9KcFFSaXdTZWVQM0RD?=
 =?utf-8?B?dFZxWGFrT29aeTBjLzFwcWRFRTRqVFRZV2JFQ2JaWlBnb2N3b2hKd0dlby95?=
 =?utf-8?B?dUQxcDlTN3ovUzNmc1VJSXNsZ3I1ZFdSVzRqazRmR2xXQ1E3Tks4NnlwVFRj?=
 =?utf-8?B?R0RHSHcraWNsSEVubUpUdkRDcDh4TElLc1VNaGxXUGNXanp5Umc0V1IzcEJZ?=
 =?utf-8?B?TWRvNjUvVzVRYzZoQm45SWo5eEdPSS9FeHk2Vmh1TC82bEVyTmVTWDc4M3NO?=
 =?utf-8?B?WHhKV1RmSUU0K2NxcVNwVWxDbTVDUlFLQTk4YWJMRGFEV29SRWFINXNBS2M2?=
 =?utf-8?B?VnpVOGF5dWVTTk9TdVZsWEgwb3lOdXZObW5OYXZLekxhc3NacGdOUGx5ZmUw?=
 =?utf-8?B?c0wxdkdLZUEwWHNCYU43aDV2NnR2OHRwQlNZL3FiZ280ekdNVlExSUtmbk1Y?=
 =?utf-8?B?VFFremxTV3cwMTY3UnhDaXZBc21UK2RCZ0RvUjc0d2Z5TUZxNDA3ZTQvQ1dw?=
 =?utf-8?B?Z3BWZExMY01iYU1KOWRIT1BYdFEyZWc2VFhsSnc2Y0JuQytOdFpKTzdsYktM?=
 =?utf-8?B?bmRLRldSdUE2QXhLRmJaTVA1S1pNQ01KOGh0dnd3aldleFB1cTZjYWw0QURT?=
 =?utf-8?B?TitDekhNTWc0cXdJa0dUWXJsZTVRQUVVTUlFSGNOdTd4QjIwSUhoNW44aWRw?=
 =?utf-8?B?Mkt1MnZ3dlZYOEI4MnlKMy9GL2JHdW0zNVJPbU8zeHFwSXJjdFBSZDhhM2RK?=
 =?utf-8?B?MVBOOWUxQ0lQSEp1MFQweFZUa1luQ0tGWFc0Y3RXSVcyQzd1K0YxZUVaNElx?=
 =?utf-8?B?OUdDdGxpL20ySVBWSG1QTHA5Z08wNVFIa0tGdC9mam10czE1cjh5cmpEeGpG?=
 =?utf-8?B?dHFQREZqVktVZm8wRlJpNjgvbVpFajZJM0tvS3B0K2VjME9OVncrZjZCUVpI?=
 =?utf-8?B?d0VQd0Q4WFZJZ0lOb2diM2UvL0pzUzJxZkJYQ3NrcXVxa0ZyK2RZd09aMll4?=
 =?utf-8?B?M0l5ODQwaTE2Vlh1WXg1MlM5RmlrWkZqSzRPWkdnOFQyQitWNFVnN09hSTdP?=
 =?utf-8?B?VTJVLzZsL01mNFpacWJLWE5ncmhuaisxdTJQNXNtcFlMS1ZaR3FNZXB2Njdo?=
 =?utf-8?B?SE9YOGZxSWc2cEkwNEJpMjJHNVl2U2JtRTN1Y2VoNDdsOWNuK2FJdm9wME04?=
 =?utf-8?B?M0svcFJrRWxhNmhORGpSYXg0azM5cUNoV3E2VmxpejdQSll5ZjRMZzdtZkhV?=
 =?utf-8?B?Y2JCdzVrbU5zRTVGcFp1VzVwL0Fpa3luWUpLU0hHOW9YczBQc3pZWTBlTkJy?=
 =?utf-8?B?RVVrZFBId0orR01ISlJvYVlndDFaUC9za2l0cmVGTTFwR3o4RTV3R3FPcXZv?=
 =?utf-8?B?Zy9VVjl4N2hsTU1TQWM3MlF0SmEvMUo0RDM4NXJGd3MzekVEOWd6UzB0Y2VP?=
 =?utf-8?B?VXVJTklYRSt2LzNoQ1BQRzg1eEVqekRMYWtBR0Q2T3VsSG1aTEpiSEZHakJa?=
 =?utf-8?B?S3dOUkR5OW9pcXN3TDF0V2dsYlV5M2hMamhlNXNQK3JPZkpRZkdWdnduVW9t?=
 =?utf-8?B?SWtWZm9WTWxqY29JMUtDYTE1bjNnUCt5THl0WDRiTkV3emd6eGRzUUdIVDFi?=
 =?utf-8?B?dDEzR3l6eTZSWVkwVngvODlFRWdrWkMrNUV2c09pTmhXRnA4WS9xMWlGM05h?=
 =?utf-8?B?SVc3NUVLdHRDTW5RanlQSjhzWkFjZWx0aUQ3d2ZhWE1nblorRUlsMmpSR2Jr?=
 =?utf-8?B?b0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ce3342a-5503-4dcb-8ef7-08db028becdd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 06:33:40.4146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xv28v5gbwW6CfA+oDTo0WP+fwWAYNIPct1ewr/8zXtiWVd4hd2ity3r6t114IVII9d7cTEiaXFSYyFZbqjJfmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7832
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 1/27/2023 3:50 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> Updated CPUID.0xD.0x1, which reports the current required storage size
>> of all features enabled via XCR0 | XSS, when the guest's XSS is modified.
>>
>> Note, KVM does not yet support any XSS based features, i.e. supported_xss
>> is guaranteed to be zero at this time.
>>
>> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> ---
>>   arch/x86/kvm/cpuid.c | 16 +++++++++++++---
>>   arch/x86/kvm/x86.c   |  6 ++++--
>>   2 files changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index 6b5912578edd..85e3df6217af 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -272,9 +272,19 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>>   		best->ebx = xstate_required_size(vcpu->arch.xcr0, false);
>>   
>>   	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>> -	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>> -		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>> +	if (best) {
>> +		if (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>> +		    cpuid_entry_has(best, X86_FEATURE_XSAVEC))  {
>> +			u64 xstate = vcpu->arch.xcr0 | vcpu->arch.ia32_xss;
>> +
>> +			best->ebx = xstate_required_size(xstate, true);
>> +		}
>> +
>> +		if (!cpuid_entry_has(best, X86_FEATURE_XSAVES)) {
>> +			best->ecx = 0;
>> +			best->edx = 0;
> ECX and EDX should be left alone, it is userspace's responsibility to provide a
> sane CPUID model.  E.g. KVM doesn't clear EBX or EDX in CPUID.0xD.0x1 when XSAVE
> is unsupported.


Thanks for review!

Sure, I'll remove it.



>
>> +		}
>> +	}
>>   
>>   	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>>   	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 16726b44061b..888a153e32bc 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3685,8 +3685,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		 */
>>   		if (data & ~kvm_caps.supported_xss)
>>   			return 1;
>> -		vcpu->arch.ia32_xss = data;
>> -		kvm_update_cpuid_runtime(vcpu);
>> +		if (vcpu->arch.ia32_xss != data) {
>> +			vcpu->arch.ia32_xss = data;
>> +			kvm_update_cpuid_runtime(vcpu);
>> +		}
>>   		break;
>>   	case MSR_SMI_COUNT:
>>   		if (!msr_info->host_initiated)
>> -- 
>> 2.27.0
>>
