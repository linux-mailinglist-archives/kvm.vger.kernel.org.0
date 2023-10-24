Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6BA7D51D5
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 15:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234466AbjJXNcB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 09:32:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbjJXNbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 09:31:55 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2054.outbound.protection.outlook.com [40.107.105.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFA2B6EA1;
        Tue, 24 Oct 2023 06:31:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlnn9XHXcHO7TP1FF5nABix9uwYqYHnJXQrQnM3qcCgDvMbr8hrGyvXMkqF5B5xv5om2b1xo5uaHOs97eU99UZ2GS42czaSuiIvaIe6LSY1ld9IBh+C61CJHeJLAhZnetnDO4ql2JSfJD1vyYfeblo2ZCyjz+4eBpONjPmqdKK3ok/6Xe5vNkNPi4O6L0bCorPf5/fgZDAlHre43AKXv75Z0c0NwmyZ7UIn0aumdBWoIwykjfRJ2DKQWAe1VxSF9Zw4x61XwFz6bE3VMD2fAp7fD4JjrIzkSIIBlWB2mOM5XItHJvx+EHDdr/Y9MxhSQgQty/ejyJpMrqq7gICxjqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJ5g8nyeFghsGUj68Wsm16tiMipGttHU7AltL3V6rYA=;
 b=fMeEp1SFKsC+OYCFUWm7c3ee/3aDpLUI7vtp+vEsXWGpI5iq27qVVyDI8ZgJBK4QMDcJnXsq3QKR4qlaPgoVrsTRjhp5+Tu0OPx9YUdwbk88afAFWFX+rWOUcuf5CQY7R7Dt1h2MlNVRI2KuRxmtmsBr7/CVHb5Ve/Mvs9m1KzSX4iX9HrOZ/wrONadNc4kDu4XnGDkfCp3b6LnZT+XYQ+7XK0j6/BVnb3Qr3mnztelc7XxXg92rUM6YdqCfpVzq13V7LGMSD2e8z5zy5iYWRiYMIMkYG9z12BEbnqZaln55+aieWUcVGvoWrWn0NLU1ynlPhV82PiJcy7jEc13CDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJ5g8nyeFghsGUj68Wsm16tiMipGttHU7AltL3V6rYA=;
 b=vKN4gHee/gr4I8M6TyrH2PlnUqDhnWiA2IwDDr7dbEJ6Qo4MXrBpsm4Nu+HszaqKDwH00Cf2B4ZSAvtHatPV7tXHAgOxGsZqWPlX9Y24H2LVoUOy+6+GwrHuBF5uLr5CoBsxZgOO90IOOdYPlaalYA65rydIl4jGyp/VhVFwwVuQhKBQmls8qlS/5WfhygcDhnHtQBO6lbuMuhXniJtZSsAPFl9GGYISakZXtQnWzDEs94wFZkZof0pSI7ezZvFcCLtk1BXn25dxChneMgRhRQdSWYjImqNC84kvEqGnB3ncHtvVMyQtjOZbx7jq0EN5ntiBIpXNtRpvRfhR8CWKrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by PAXPR04MB8112.eurprd04.prod.outlook.com (2603:10a6:102:1cd::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6933.11; Tue, 24 Oct
 2023 13:31:50 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::edd3:f00:3088:6e61%4]) with mapi id 15.20.6933.011; Tue, 24 Oct 2023
 13:31:50 +0000
Message-ID: <91b1fbc8-7308-43d1-a27a-90dc21fa7f40@suse.com>
Date:   Tue, 24 Oct 2023 16:31:43 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 12/23] x86/virt/tdx: Allocate and set up PAMTs for
 TDMRs
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "Brown, Len" <len.brown@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <cover.1697532085.git.kai.huang@intel.com>
 <ac0e625f0a7a7207e1e7b52c75e9b48091a7f060.1697532085.git.kai.huang@intel.com>
 <33857df5-3639-4db4-acdd-7b692852b601@suse.com>
 <457f0b5366134c2b09d6312c32e5c84b123e7911.camel@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <457f0b5366134c2b09d6312c32e5c84b123e7911.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR2P278CA0016.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:46::10) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|PAXPR04MB8112:EE_
X-MS-Office365-Filtering-Correlation-Id: 440da009-8e08-4bc7-328e-08dbd4959359
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jUNvX0tQ30abpKfq8X3iDJP531MoJqFsRN2nmJwkGS3t94MZz/LSmGS9LPkTvqWqPah9OzWbTFP19uIiVf/l1zP98AtcOeWWZxfn8AmvFqu1KGtDmpYxRL5EZUKw9QGyDrjtlETmMnR3vHW8HG3U2wj6dFc/c1LvIIkmYjtyJSeCPPkqXysh2LES0xv6SOB2hTbQ7xgUraHTXGLScj7OnsYw6JseJGlfpdtQNaSacr1+Iw0LgW38bA2p6gc4ttjC6q4yiFbgF2jEtGzbtoSOOhN9h6V+T4AnVTUHRIAnmfm1W4DYEuQ6mJumg0YV1HvNX3V4ZT0eCNgHZjVtk/J+zceMgJLlTRrGWRSt5C5pLcEOJl8oWGweXJ77TUwKXsCfUEmJyZghwvOHOzaNkYfe2lr7+kBz9tqb7SI7a46Tf7yInbSCYoZZCvRhpCuXQIJSX9DSjyrb2DGXcJSZYl8XpJzytrjhqpO3nxNMeN1Rc9WBA9U7Pf+wimjGvU+NdKQ9LPysZWTRuWJBwflhtO2dliJySGsCBKDs/JLsLRFUXTck+CB+Zcih3k7fcBSsQbf4pNpyHQnnCFuIuoMRh2OAPeX8W7PbiEuElg1ddYtxikoL8+7eTNYuYxH15WVwQzjH3gBtqCK7cQ+vVopoTwrqPCKJggt19IZYIjBFKcWETOw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(366004)(136003)(346002)(376002)(230922051799003)(64100799003)(1800799009)(186009)(451199024)(36756003)(2616005)(6666004)(6486002)(6512007)(6506007)(38100700002)(316002)(110136005)(66476007)(66556008)(86362001)(31696002)(66946007)(54906003)(478600001)(83380400001)(31686004)(41300700001)(4326008)(8936002)(8676002)(7416002)(4001150100001)(2906002)(5660300002)(17423001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dXhIS2Q2SHhXNmZqQnJadk1QZ1JLb2tLa0NpMiszVzRIaktJajBwdTd2M2dO?=
 =?utf-8?B?YlRVa3h4Tnd4ck9CVllIMEJRVWFHeDQ1cWtDdlpyOUdpK0tkeWlmR1VzYmkw?=
 =?utf-8?B?d0RQaHpkV2hUWkxESVJwbk5UaGFicHhOOHhDNjhRQU1haS9WQnRSSUlYWjhi?=
 =?utf-8?B?V0piWGx2OVcydi83RWMwbVhPMUp5ZzVlTVJhaGRYNzNrS3Y4dHhvNGZNcXVH?=
 =?utf-8?B?aTJUZE1LdlJVMGdYZ0g2UVo4RUd4b21HWUhDZlJxWTBURk1sMHhiU2NCS0Yr?=
 =?utf-8?B?UU11MGkySTFWSzFtbzQrUmh1MHl5MkJUOVhvL0JrRUpneHVGUEt5V0ljeVpw?=
 =?utf-8?B?NmhlV2JVTldjdXJqK1g3Q1p2RHgvMHZyMy9WUGdsd29FWUo2Ym03R2tyZE1G?=
 =?utf-8?B?eWR1QUZmOHowZG1YRkhXZmhSTDhiZ3MvZ3lVK2gwaFVzaldSenFDQTJhejhY?=
 =?utf-8?B?R3NyZy9lVG1sWSs1cW1lb01hRjYwYzV4NDZOSlhuNit2bE5lMUYrRlhzWE9R?=
 =?utf-8?B?ay92TWI1Nm4zYnY5NlAvNzJ0UWxKdlJOdWtkSjJqdDNrNXpjUUhGTWtLeXdM?=
 =?utf-8?B?UDMrVzZ3Y3Z2eEdIRzB1V3g5bCtVSVg5QmRNMWF1UmNYNHFSakxsc01MNEVJ?=
 =?utf-8?B?T0NCVHNNOC9GaUZNaE1VWEhkZE9JSjIwOHQrSkQ4NmxlV0VYMS90ME5wNHky?=
 =?utf-8?B?SHhGWG12NWQrNFhLVTVQY1FlYy9MSjQ0ODQxK00vdHlvVXRwZWpuVTN2eUJx?=
 =?utf-8?B?NlFZcW8xckp5UkEwMzBCd1hDalpkUFh0M1o1R1FpY25IUlluaVhmRW10ZTh1?=
 =?utf-8?B?d2VCQjRUQ09mZGo2aWU2dVE2RGxiTnpPNXZrYjYzWCtVL0dxd3J5dndHZVRQ?=
 =?utf-8?B?RUo4bXRkbjZBRTRseDhCZW40UzVVMHcvWjBhemtYbHY3WnFhTGh3cDJaV0lj?=
 =?utf-8?B?aEkrVU13SmdrQUZlVFBuNmxja28xMWI2YnNFZXFoZUNXemdGVWZ0L0pveld2?=
 =?utf-8?B?WEhUakFBSVZITlJNcEdHeTlaZC8zSTR0NEtHY240NFBuUkpyOHNnUW05TmV1?=
 =?utf-8?B?NWRPVGFRaXhMNXFKNVJEa1lmWm1RcW52M3gvOU1qL2tMV3krR3A3SzJyeXpY?=
 =?utf-8?B?amU4SkFOb1RjSWgvM2dzL0ZjWUNsdnlaQXNMd0htS1RqTGt4ZnJ5N1pUWG9x?=
 =?utf-8?B?V2doMSs0aHVkTlhyeFFIT21tM1Y3VnZYWnF3bjRVOUNHRlFQN09JSTJUREhS?=
 =?utf-8?B?YkkxQzl6N0tXbmcrU1RGRmgrVjQxWnJDMFFtMjZmVS80S1RYSitWWWF6UlJw?=
 =?utf-8?B?WlFQZWRoQ1lZNVRTSzgwYkgxUGZaWUhHY0VCWCt4OGx0ZFZEK1FRTTZ2ZXhq?=
 =?utf-8?B?ODgyYStJRDlpeTVVaHo2aWxSSjd2TG9NcityZHRqRUd2S0dVTEIxS09mSk9m?=
 =?utf-8?B?dmtqVTR6aGdsLzd6UDI5R292ai9XWDZQV2xTWFVIR01pTnRsS1h6U3V1M2hL?=
 =?utf-8?B?V0NPU0l5eE03MHB2eEFJU3NSWThrM253ZndqaHZZTEtIY3VYY1BYQ3N5NEFv?=
 =?utf-8?B?eUh0SUQ4Qzh4V3hlbVNuOFAzZENMbzZQQmJGVC9xODd3dzhMYnFBL3lXSTgw?=
 =?utf-8?B?MXdkL2hYQWlHZmVzcVYrYUJja3oydldtWnl0ajdLRThibWRhL1BmYXdpdzZW?=
 =?utf-8?B?RXVHQTVCVFhtZ2VMQk04Nkcwc0oydFVGT3dNcWxLc1RMQnh0NDRCWmNRa0E1?=
 =?utf-8?B?aUtRZDBvbEk3RVRmNDk5aGJmTGFieFcxTXJqcEZXdUFRV3R0VzAwdXhWalph?=
 =?utf-8?B?R1cxWnpUM0hqeVlyTEhFeDIxNVFSdDhoY2hoK0xudEJSbytqd1JEMTJYYzZt?=
 =?utf-8?B?VXBpODVEZUIxZzhpL2FTVDR6TmhTSkk1cEh2dEFRMkI2WkhQL1NHeEtCTWZB?=
 =?utf-8?B?MnJOdVF6RmRyaTk2R2EzdUFWL1grQ2p6RkhmZkNtRlcxNnYraWtsZGg4bUJ0?=
 =?utf-8?B?c3JKUDlaZk80Y2FTZFRBUmw0NSsxTmtpVk9KQWg4djhOMm93MHhnTnBray9Y?=
 =?utf-8?B?RFVXdEh4SDdGd0w4SHVNVk9TdXdxd3ZKQ1FnbmFMZ25hVC96TVlmL2c5eUpK?=
 =?utf-8?B?UDJnaTJZNEhWKy9KWUtYZ3FFbWVoVGgwejBHNXl5bXFlMFVGaFpTZW5rMkgx?=
 =?utf-8?Q?YUZ2O2ik+fYHadgyl/0/COF9s4hIhgT/7fAetSkIwf/R?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 440da009-8e08-4bc7-328e-08dbd4959359
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 13:31:49.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oMJduQ0tqAv6g/7Ma258Te0lOgvgP8KPlG7Rbk7crNaRwwle95bzsGnIyky5gOeZZyqYUjpIAE6Y5WDwjwGuIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8112
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 24.10.23 г. 13:49 ч., Huang, Kai wrote:
> On Tue, 2023-10-24 at 08:53 +0300, Nikolay Borisov wrote:
>>
>> On 17.10.23 г. 13:14 ч., Kai Huang wrote:
>>
>> <snip>
>>
>>>    arch/x86/Kconfig                  |   1 +
>>>    arch/x86/include/asm/shared/tdx.h |   1 +
>>>    arch/x86/virt/vmx/tdx/tdx.c       | 215 +++++++++++++++++++++++++++++-
>>>    arch/x86/virt/vmx/tdx/tdx.h       |   1 +
>>>    4 files changed, 213 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
>>> index 864e43b008b1..ee4ac117aa3c 100644
>>> --- a/arch/x86/Kconfig
>>> +++ b/arch/x86/Kconfig
>>> @@ -1946,6 +1946,7 @@ config INTEL_TDX_HOST
>>>    	depends on KVM_INTEL
>>>    	depends on X86_X2APIC
>>>    	select ARCH_KEEP_MEMBLOCK
>>> +	depends on CONTIG_ALLOC
>>>    	help
>>>    	  Intel Trust Domain Extensions (TDX) protects guest VMs from malicious
>>>    	  host and certain physical attacks.  This option enables necessary TDX
>>> diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
>>> index abcca86b5af3..cb59fe329b00 100644
>>> --- a/arch/x86/include/asm/shared/tdx.h
>>> +++ b/arch/x86/include/asm/shared/tdx.h
>>> @@ -58,6 +58,7 @@
>>>    #define TDX_PS_4K	0
>>>    #define TDX_PS_2M	1
>>>    #define TDX_PS_1G	2
>>> +#define TDX_PS_NR	(TDX_PS_1G + 1)
>>
>> nit: I'd prefer if you those defines are turned into an enum and
>> subsequently this enum type can be used in the definition of
>> tdmr_get_pamt_sz(). However, at this point I consider this a
>> bikeshedding and you can do that iff you are going to respin the series
>> due to other feedback as well.
>>
>> <snip>
> 
> Thanks for comments.  But to be honest I don't get why enum is better, and I
> would like to leave this to future work if really needed.  Please note these
> TDX_PS_xx are also used by TDX guest code (see patch 2).

The reason being self-documenting code. In particular when looking at 
the signature of tdmr_get_pamt_sz if the 2nd argument was enum 
tdx_ps_size or some such it would be immediately evident what this 
parameter is all about. Right now it's just a plain int which can be 
anything. Indeed, this is mostly cosmetic so hence it's minor.
