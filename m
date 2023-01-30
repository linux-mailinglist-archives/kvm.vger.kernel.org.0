Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BE7680E00
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 13:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236662AbjA3Mqw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 07:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjA3Mqv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 07:46:51 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F2A28D05;
        Mon, 30 Jan 2023 04:46:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675082810; x=1706618810;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=F745zI1wFhVYGc2lduk30fJitXPaK2zqmXEIWJcGA5M=;
  b=QrxGn8WdqQ3cEtI/NdHkLhXqr+GU0Rhf6h5f1k4Sxysp9akX15VzwgI2
   2cRD9T7ZiVXMUlpP/7V86RzedzoU2DXImTglKDAZI1kFhCfJAUTVVS4jV
   KQv3A2DmNGJX61gMF1osf5R4xjfzKTkJIv9Z0ZEy6iLjCsN9qC84n6L7n
   x9Ms/e5PxqJ0OLoJQ09wI5lYNSNXvwf8QFNmrvn/xKoWN8yHbhfKvNABY
   aD0TpnllCO850vo5X95St/8pCjqUTXq/i/ARJMfeMEQ7+xEZ03DT0B1jg
   vSidOFQCuLLeq1w1JO8nIBzToAN1r0tx5zkGEomS1A2gkgZ6VyOOvU+P8
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="315506093"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="315506093"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2023 04:46:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10605"; a="657440338"
X-IronPort-AV: E=Sophos;i="5.97,258,1669104000"; 
   d="scan'208";a="657440338"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga007.jf.intel.com with ESMTP; 30 Jan 2023 04:46:49 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:46:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 30 Jan 2023 04:46:48 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 30 Jan 2023 04:46:48 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 30 Jan 2023 04:46:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aM17VcispjQ6rcNQxoGLxntnmKvlAzSOhy+f+DDhcivL73ajErBpNY54u//EhbOQyqsGhIVh0N/9REo7c+P7t4cOgS6t0ugLVRUCukdtIOXNp3LVDHFDB5UlyvtBEVbvsg0M6LKlzsDZYnZlQRpGTAYa/E3sbfzk5XxjSX+bfe/CX+nqYsnfTXg1yTnfwXrPMHuTd3Q/ZQaDrfGyQRcv+qMF6XD1wJqz6fU+fAGBHWUH1A5Ip7xcddAmi9G+Do4ZADFKee9W8z7C5aZVFbwfqs0nF3D5WNFkw6cJwRGGX6g0uCyto130hVH2LhTjbzJeF619f30SJShdP9C3e4yBqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rYiRiPHq6OpotcXg+1DRdZoNiJjp7Hb03pvkctG1Pow=;
 b=LL3o86AIEGr0F3Cs4HK5s5c89ifun7HLRRSApOcXVG0L6s/E+Z8iAw62dVuZvlwM0+n2hRWemO1e2fSII3FN9Ga6Fuq1KkSqe0v9GjsIUl/QueyMXhlJlhW9mQqUEiatxSk9tY9oPwqeOHZIn6WVh+5AY1GX3hXTxY9png3Kji+gTyXjFQRva0A7IF7D/asF3d3gSnZRxVR33PsayUk6ZTBBD3B1WoU8IPierwAzlluqO6vtjoV1DZ+moDy+Pl/TKehcMl4Y1YpS4sAg3uH62dsy5ZPWv9CFzBOT8eApAeZ/Nu3vHxTP7xd+PyufTIfo22Qdf/6KrwiCxbyuV06VtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH8PR11MB7117.namprd11.prod.outlook.com (2603:10b6:510:217::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 12:46:23 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::7d42:36a8:6101:4ccf%2]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 12:46:23 +0000
Message-ID: <f70ea782-c7d4-0997-88e0-c24768fd02a9@intel.com>
Date:   Mon, 30 Jan 2023 20:46:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 14/15] KVM: x86: Add Arch LBR data MSR access interface
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
CC:     <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <like.xu.linux@gmail.com>, <kan.liang@linux.intel.com>,
        <wei.w.wang@intel.com>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-15-weijiang.yang@intel.com>
 <Y9RMbq1FgygCPRrZ@google.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <Y9RMbq1FgygCPRrZ@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0083.apcprd02.prod.outlook.com
 (2603:1096:4:90::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH8PR11MB7117:EE_
X-MS-Office365-Filtering-Correlation-Id: 997ca5e8-db28-419f-ec03-08db02bffdea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1zi/W0M9mzUdWZ+DSpmJUtI9vwEziF9f/vAz1e1pll2ytQVfxf13dlSPJPpoaundGpr7IfxLZ5PpQwxX3z7kYjYxf/AIE3uJx9pCV7ZVvzMXw06UNCWuUCWocjlpU7IVL0QXEsgr3nTz0QgnJ6le0CPoMlG2rrSjTEehEj9k6U1reWnKJ8nJZLqzbHByDnka2YfSbmPLadBnIbyfd+fWsop5UatkriYDsnOY1StPFpLm/Wx8PArGIZBBE6TmxXcgSJXHHHrcMikiFJ9YsO8Oh8k/SCqoD/IhZrYXOrVqNZRfbZyZQy9SMLzJ1hiReAK5ux/gmXhzYH5rgr3Ir07SLByIUBPCzeIPBuRvY9jQRlNm/hCD1oSpM27908C8lOAWoTA45rKESDCrlUuC5EKkGJMT+6bBvMrrStjj7UUX+ckgkkLdBk0frSa2GkfO1iXKal2oIEllXGmbbCtFIapsDhp1421/Mw2kCy4JVQ2aHB4ybdgiWVWbsvMwFsUsLvHGNA5P7YCZl7elFCEZG1qkcd1HuxQbyh9cwlMqOuwu+GE1Wzk7FdbED7LI76w6xAmesgKf1NC6+fCgtP364aBOIt3x01ZIqe20C5RrTcuhVFtDUD49hPizv0b7ZEKxBXrl0WuIpr0bpkz2ZyarxA7z+M7lcrZ+CP8QOOpzNP4CU3oppWePxU67mxR4DEcdlQBc7zJcOmtOxVa7nCc5h3v8YCwJQPPJ5Z7GWqoudutEdnc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(366004)(39860400002)(396003)(376002)(451199018)(5660300002)(31686004)(41300700001)(316002)(2906002)(8936002)(66556008)(66476007)(6486002)(6916009)(66946007)(6666004)(186003)(6512007)(6506007)(478600001)(4326008)(53546011)(26005)(2616005)(8676002)(83380400001)(38100700002)(82960400001)(31696002)(36756003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?czcyaThBbFIzOS9rL1AxWHVHelkxbmlva09wZGQ5dlcwazIyeFVRUWY4a1Ry?=
 =?utf-8?B?ODRpSU1wQVY5UnVrbGVxUEdsSlFCRkhMSDN1TDlFWVFWLzR5NmdzeEJ0NnYy?=
 =?utf-8?B?L25wSDVxZiszWWZDamNTblJIaWJsRjU1cG9HK3J3ZXZFY2dhMXNEOXZDYmxs?=
 =?utf-8?B?aWRkWk9VSGJ0bUhYdmU4cklKbExXSjVMWFBYejQvaDluaFNwMjRxZEF3UnZM?=
 =?utf-8?B?ZW1IbVd5Mmg1a2E5bDJkVllNdk1iRFZnZXRRUm5rcnZTdkJTNE9pZW8wZmNN?=
 =?utf-8?B?dDd6bWowQnYwNEJQakJheTNWK2d5eXdBcU1zR1VFdlh4MCtEUFpYR0x2QStR?=
 =?utf-8?B?bm5zL05UQUM3V1VqbHovTUxwZnVhejl1and4a0hjL0xRRHBjUnU2UjBZRTdl?=
 =?utf-8?B?L1RXMGR3bXlTTFVmU3YyQmdjVllUQ0UrRk0wdXdnWEt1Q2pETW9qL3VGN1c2?=
 =?utf-8?B?U0E3VExVSW4ycEY3L05tUThyNXFUVkZQSXRpYWFLR1hEL3lhWktHc2U1cmdn?=
 =?utf-8?B?aGF6bHdtVTdORlUweHBiZ0NJQXpMb1E1RmJqM1VDMzZTWlpHdmtRRCtwRVhj?=
 =?utf-8?B?OWtpN0thTHlRMDZ0SmhYMW8ycEdQbkh0Z29ZNGdmendiTkpNcWpRS0lJT1BE?=
 =?utf-8?B?SnFNNGVwbzhNM2tybXM2QWxkYlRHL2FJS1hjS2E3SmEwdTRVMnhzV2d1dXor?=
 =?utf-8?B?VnpMYTdlQlU0R1lOaVo2WHRSL1VLWmhIUS82ZWhiQ2tiekY5TGc1ZnBJdG1T?=
 =?utf-8?B?ajltb3k0b0NzV0NmajhWdStNYU1telFXc082clZFNzVremY4Rk5CZnhlQkpE?=
 =?utf-8?B?K2JFakt1RlpEaUlWVUl2dHY3elliLzkwNE0wT2NJUiszbUp0cXhWMDltaVI2?=
 =?utf-8?B?QVArSTJCR3QxbzczUDdqMFpKMVNRTjNVTklNanRsNEFnQk9Qc1l0VmNJWEFB?=
 =?utf-8?B?MzlyL05oRUJGZ1RBcThvb3o5MWM1cXRtQ0pWK1dlNk9zQnp5Nlk1eFBhVTFs?=
 =?utf-8?B?cnM2NzNqbjl6NFZWbVQ3aEZTRitVK3RCZU1tRlk5dkZnS3hUOVNNQStvSG92?=
 =?utf-8?B?SGs4UjdlLzQrVExkUUh5ajZYTmNQU3Z4czNUcm9GaksvMHM5Y2dTK0tRcVJY?=
 =?utf-8?B?Q2trMUVhSjhVZWt3THFlQXFONkRPL3hzUEo0dmk2SWlyT1M3NVJ6aWpJMHVW?=
 =?utf-8?B?NHhPUHIvVnpZTldwZy93YlZteDFFNmNYSmFIcEdpWGUvZmt0QUJ1TXVZRUM1?=
 =?utf-8?B?QjIxSGNmYkt1bmp0emJmTjV3bWV0b3UyZVUzcGJSazBaaytza3JnNXBwbTY0?=
 =?utf-8?B?YlhqY1lSa3dINTl4SXV3MWJBdVFvOWZUZUE3THdFZjdNbnNJNE5QSjNMcE11?=
 =?utf-8?B?UlVQajJvSFNlbXJoV2xHaFpJREFaTHp6azk3QUFvTVJObldnMTBwdWs0RXdr?=
 =?utf-8?B?VjFpV3gzay84dDBIbk5nQTB3aGQ5WlRhUmVaSlA2cWZlR0NCMWpzR2ZnMmxN?=
 =?utf-8?B?bUNaWkZuQnp6YXdxQjJHazRBNXdLeEpoN0huaS9DdEZidWh0ZkdqSGc1eXl4?=
 =?utf-8?B?bjhnckp1M2FwbHU5NGhQMjZ1aTU4S1pCOEZUcTR2OHM0NTFGTms3bmNJQ2VK?=
 =?utf-8?B?cThrZVdxNG9TNVBSV2E4UzZkUjdBaC9xYzRqeXo1WkZldUZMWGM5bkpvUm1j?=
 =?utf-8?B?YkR4cHdrdXliMElsMEwxWGRraTBqRmx6dWhpRXliZEFNN3EvaHRydVVvYjdF?=
 =?utf-8?B?bFBVNm1heXFwSTlvZ0ovUGhycmp6SmRJNGwrVys2bUNIcnlJaC9Jc3NUczQ4?=
 =?utf-8?B?b1pUMTZRa281TWwwM2ZwM0JsU05vZ2lkVXNkNm9HcUxocVUzZ0JJaFphWXFv?=
 =?utf-8?B?Y0E0bUVKTHlYNnVRaWhkbzZybkdBbjh0Nm1ZdmRxZmJYKzVkQ1F4bHJtVUxz?=
 =?utf-8?B?OUx5SGsyOUI4WndMRjFnZU0vOVdkcyttblU3MkwwRmoyeEFIc0VzMDIzaDdT?=
 =?utf-8?B?YUc5ZFA1V3RyNjJURnhRNytscjRJbUJPeGVxamZwRlZrVmkyaGNaUUpwU0x5?=
 =?utf-8?B?a0dDbVFuakhyM3NlUXNqV09UTVpIMGRWYjZXUlQ0aXNYclN6cFg1WXdqcWRS?=
 =?utf-8?B?TXNNU1huSDI3VG43ajNodXgweEJLZWFlZmVwbCtqbWREbXFxWk9haC84MUpH?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 997ca5e8-db28-419f-ec03-08db02bffdea
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2023 12:46:22.8691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4F+jlX64Re+qx/MspEzPg58BHWM6TmuPq2uzpuezeDcVTe1eWilEJV8dSHR6lZClkaV/RNevzMyCCXCkY/wzag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7117
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


On 1/28/2023 6:13 AM, Sean Christopherson wrote:
> On Thu, Nov 24, 2022, Yang Weijiang wrote:
>> Arch LBR MSRs are xsave-supported, but they're operated as "independent"
>> xsave feature by PMU code, i.e., during thread/process context switch,
>> the MSRs are saved/restored with perf_event_task_sched_{in|out} instead
>> of generic kernel fpu switch code, i.e.,save_fpregs_to_fpstate() and
>> restore_fpregs_from_fpstate(). When vcpu guest/host fpu state swap happens,
>> Arch LBR MSRs are retained so they can be accessed directly.
>>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
>> ---
>>   arch/x86/kvm/vmx/pmu_intel.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
>> index b57944d5e7d8..241128972776 100644
>> --- a/arch/x86/kvm/vmx/pmu_intel.c
>> +++ b/arch/x86/kvm/vmx/pmu_intel.c
>> @@ -410,6 +410,11 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   			msr_info->data = vmcs_read64(GUEST_IA32_LBR_CTL);
>>   		}
>>   		return 0;
>> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
>> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
>> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
>> +		rdmsrl(msr_info->index, msr_info->data);
> I don't see how this is correct.  As called out in patch 5:
>
>   : If for some magical reason it's safe to access arch LBR MSRs without disabling
>   : IRQs and confirming perf event ownership, I want to see a very detailed changelog
>   : explaining exactly how that magic works.

The MSR lists here are just for live migration. When arch-lbr is active, 
these MSRs are passed through

to guest.


>
>> +		return 0;
>>   	default:
>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> @@ -528,6 +533,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>   		    (data & ARCH_LBR_CTL_LBREN))
>>   			intel_pmu_create_guest_lbr_event(vcpu);
>>   		return 0;
>> +	case MSR_ARCH_LBR_FROM_0 ... MSR_ARCH_LBR_FROM_0 + 31:
>> +	case MSR_ARCH_LBR_TO_0 ... MSR_ARCH_LBR_TO_0 + 31:
>> +	case MSR_ARCH_LBR_INFO_0 ... MSR_ARCH_LBR_INFO_0 + 31:
>> +		wrmsrl(msr_info->index, msr_info->data);
>> +		return 0;
>>   	default:
>>   		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
>>   		    (pmc = get_gp_pmc(pmu, msr, MSR_IA32_PMC0))) {
>> -- 
>> 2.27.0
>>
