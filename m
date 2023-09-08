Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D397985F6
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 12:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbjIHKi0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 06:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238720AbjIHKiZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 06:38:25 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2043.outbound.protection.outlook.com [40.107.6.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C95D1BF4;
        Fri,  8 Sep 2023 03:38:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YYfNCm1GWmXRSKw4Kczwn0xosElUo4YAVE/CcmSEQvifqmFbEQdKly53H6JbuHDCafhsO3XKG+LzzSfc+3qdJc/wUMqWiGsyA/VuyEobUAzzNXIzBrHfZIkYOe6fGk09u9lCMgaC4tf7bqlD6Iy6XO226AREKLw1Bc4SOZOKB+TJLPUzjHU64JqzEpI4twckLdMbguYIBX2kv/+ZRpgza2H0zYVpdPctvYKsS1sRhnkLqp6ZM6MS0s/aohBRttxY3dy9Otz77pcNCNMd6ufl80kcNBzAiF9R+1laX/5wLXZau4jjX77M/LIs/xVnZKd6Fyl9kWq8H3ahXnjd8nkv/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hM+q1SUyOGSIlOos2spTdXINEY6DUrX9OmlcldWwHdU=;
 b=TpavFk3J4z8B/zCKcwDCSV2pd0r/DozyeFsIOavo6blQuTL8jPSYNbj4CSjyUkRVz6XKhV2FQCFw8Md2orXeX8fcpNxHAKKh6jMF3bu+4T1FY4wMN+8Z7r60UEl7JGRJslxWq0apFLUF5fiikDxuhyx5H1EwevvTqyYSR+jOLQCGZWVCok4sczJm+yrQYm4H0t0nI0meebk9oRfrjmvQjgB79pNLtE9V4uzbTxiwVOO/XeCDrSxGh1rfTfEiXAghZO1NY2QEpgGTniFgI0ji0hJv8Auj7iBkAUArJDE2Y1EWIWnSb2QONmTiW8WR8Oqhqzr2fD+scaIaMwXoRtp0IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hM+q1SUyOGSIlOos2spTdXINEY6DUrX9OmlcldWwHdU=;
 b=ChvMR3XSiX5AKVQkEBAEf/oHH0J4gSBEAYh5fYpNzi1yMoMPUb9eeyL8RffeIWZMumlE1tWa+NYvP3OoL6w8ijbjD00P4iee0jeFW92gJEOMw3cPyn29+h+41EALyFRs9iJJ6Oda+HU8aG+VA9IuUua3Kb+hyZx13q3rH6dSfb1IiSZVZh43jpL+DSqRWaL37jEYdAdqelPd0pnwnx4fYuTv9KkS7P1CVcKYdZKc7obsiF0z5UDaOyd7PzKgLia++jhieeubL++7VBbS1GXgvjUwzBLH1cW5c+tzCtc18yGc3vddsAc8IzfIZYMbIBMbu3Gl6yPi/H9M63nX4Xj96Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com (2603:10a6:102:cc::8)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.28; Fri, 8 Sep
 2023 10:38:16 +0000
Received: from PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361]) by PA4PR04MB7790.eurprd04.prod.outlook.com
 ([fe80::274c:c30b:ac8c:2361%2]) with mapi id 15.20.6768.029; Fri, 8 Sep 2023
 10:38:16 +0000
Message-ID: <4dfb1174-cb9c-2405-6a8c-b0c6866a8fe1@suse.com>
Date:   Fri, 8 Sep 2023 13:38:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v13 06/22] x86/virt/tdx: Add SEAMCALL error printing for
 module initialization
Content-Language: en-US
To:     "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "Raj, Ashok" <ashok.raj@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <cover.1692962263.git.kai.huang@intel.com>
 <3b9ddfb377a944393b2a93f963cd902232a5ee33.1692962263.git.kai.huang@intel.com>
 <7523faad-23f0-2fcb-30e3-b0207d71e63f@suse.com>
 <4134057a145677de2779612920f3f903654c554f.camel@intel.com>
From:   Nikolay Borisov <nik.borisov@suse.com>
In-Reply-To: <4134057a145677de2779612920f3f903654c554f.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR03CA0017.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::29) To PA4PR04MB7790.eurprd04.prod.outlook.com
 (2603:10a6:102:cc::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PA4PR04MB7790:EE_|VI1PR04MB7119:EE_
X-MS-Office365-Filtering-Correlation-Id: bdf471c4-af8b-460a-0db1-08dbb057b605
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4y5kpjIohT1wyR2IlA7obkKneGyJ1LY2cRgpuC6fRDnexIj+1XkcIlb4l6lXbPlwgj4WSzhVLQ89FgCrB5A80YTdG1fth2JLXA+mtrFT6HJ5ju8YD76ZgqRcUpevfIxT4pXpGVeC1DWLedF3AHMFQuOLhVe+mzcpcVz3SpVxUhAd2GKsEF43VXCpkToVh+eLy+eBQRitzYyPGD9QnZZjRdwyFczMJzwL/o13zwoqrXk+AKR5hHS0A77vrdB/c2ULbdUgTjof/XMHYnWxONYUps3rvDcsEv/n09JWAQC+q5fF5R2tEoa+LnWeBHSVHeeCQwuvWPFPuL5h+gLHkaHJKYET1c2/wV8/imVYA5K+d+BconzM9U/C4L1Li6VfOkiZvcK/9NjGsz0sMWG/o5CUI3WA/AEdZS5fzl4yJit32F5GYxtWPDo7Z6fexCUK3tP1ni5fOW9WPfHbjPM57aP1jm7qTeSVX47CeNa8Ne75bcHlqIX/3cESeTdumFfl8X7Ne/3grzfspix0d+W6oWC/SwrvYzsw4cMa3X6fp11k7ruNBwIcOhetJAMnEydUraLZtHU7FEPCI1+UMxFEVwdLoRruKh5pozSW3LurKvKDWLev9UWoAbLWe8NHG4DE4IL1vu6q/AZy0Lgwr+GasASRNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB7790.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39850400004)(136003)(346002)(376002)(396003)(186009)(1800799009)(451199024)(66556008)(6666004)(2616005)(478600001)(6506007)(66946007)(54906003)(66476007)(110136005)(6486002)(316002)(8676002)(2906002)(26005)(8936002)(4326008)(6512007)(7416002)(86362001)(31696002)(36756003)(5660300002)(38100700002)(83380400001)(41300700001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ME5mNDhBa29haUhMOWdHQktmdXJZaDl1UXA5UDR4Z09MWnlLdVV4ZWM1Tk5o?=
 =?utf-8?B?ZVVEQVBsTmZnZDlSUTFnUGNMbTJuNVBZQjkxdEl5cXhPSDI4RUJ1TGVlUlI0?=
 =?utf-8?B?NHR2bzJzakFueEFjckNmdzlkajNZdlZhak1KM09ZblI4QnNXRlp5OTVqSHV5?=
 =?utf-8?B?c1I2bG1lSW1LNlRZRm11NHhlYzEwT1JjUFloR3dsNnBsTEh3d3R5MG1INzF6?=
 =?utf-8?B?NmQ4bStBdUpsZnJTdm9NTlJTTHZSa2Q1TitxcWd2OEJtbnh0Sm9FS3VMZmZH?=
 =?utf-8?B?OEU4ZzM4WkJiRmlkUnhTRU52NjFwcFpPemxYZkp0cS96Z2JCUDVNTzdjQmI0?=
 =?utf-8?B?VmU5K1VCeFdZa0c3Q2dud1pWZkdrdHhDazRCQndJMW9XTVhJQk5iWiswR3RT?=
 =?utf-8?B?a3JSTWJTa1JxUXNkbStCbEV3VHFHS0h2Zyt1K0dsc1hIUXM2MlEycUVWY1Fa?=
 =?utf-8?B?QitlSlorT1l3RGFhU283eHY1L0x3TmFxT1ZacUp3Z1hmU09ZYlVOdFRDYzNu?=
 =?utf-8?B?SzZhcS8yOGxCc2ZuaHNKU3I4OVVET3ZHbzFzM1Q5czVveDJMZDBSZmV5dTNu?=
 =?utf-8?B?Z01pMkI0WllvQmY3azh6bThWOUFKYlBBRmovL1dlQWk1RnhHay9ndlZnT3Jw?=
 =?utf-8?B?Ylo0SWQwY1JuS0hLWnpMN0taSVF4OFE4RmY0RlNXNHBsaVFKbnNnNHMyWnU0?=
 =?utf-8?B?eTc4U3RST2YwSXQwaXplZ0plM05XUzM2VGhiRm9yOSsvQjhSVGljMFdqbVFx?=
 =?utf-8?B?bG0rcjNpbytheWgvdlB2Q1hDYUZ3ZTRiWVFESFp3Z3I2eG1jWFJCdWtjTUcz?=
 =?utf-8?B?Wks5M1ZIakI2SmhvMURmRDdkK0VJTXZHcWVSWVkrRFNjbTdUamtSWWt4WGdG?=
 =?utf-8?B?UlZTZm1wd2orZ21OK1JaYU9rNEcxZTVrOWI2cDJmeWFxdHZKbmpvMmVFUldL?=
 =?utf-8?B?YjFKSmc0MGhZVzFJNlB1d3JnT2ZzRXdYNzlLYnBBQU5XN1BzMXRXUURvbnJ6?=
 =?utf-8?B?R3hTVysvMXFLNzBDd3F0RUU1b3Q2YnNVa1lnN2tvUmpSWk1BN2RlQmQrS1l5?=
 =?utf-8?B?SWltdVJ2MG1DeWphVHhHdlJwM3Y5MWxaSGI5Nk8xOGxsdU1JaUloNG5xN1Vv?=
 =?utf-8?B?anVaMUw2c1NjM3JaLzNnMUwrQ294NlBrVFJSN05pNkl0MnVCSUVRYVBpeHhJ?=
 =?utf-8?B?TVpzMVNiT3FhZ25vTGpNdjc3NHlNUHRtUjUzejNmMGlxY2F4dDJzTllzOUJY?=
 =?utf-8?B?V2pheGNnZE4zMUJ4MFFyOURIb0RnRktwMEFFS1h5RFluMW1yWm9tc0pVcUxw?=
 =?utf-8?B?NVNZaTBOVlRGdmpZOGk4dkFLdlYrNnFlT3NoV1c3NDBNTXIxNnVUaDlmNWZ0?=
 =?utf-8?B?dGpVa3IwWkQ5L2xORnQ0S1ZDVzhIM3pLck50NEEzYm9LQ25LRnFseVRXTE9G?=
 =?utf-8?B?RWpBS0ZRUld3V1dBQVV1VXBMMzZoaWt0SlEwc0ZVL2dxbHpxMFZ4N0NpZjhp?=
 =?utf-8?B?dTI3TEVTNWNObEt2cDYyK281ajkrc2VhUWFQWXpWWEJuMm4wK3h5UXp2MnBL?=
 =?utf-8?B?RTNjN1pnRm1zN0NvVTVwL01OSndZd1NPN0luTUJHMXkzZUNIMFFKd2crU0lR?=
 =?utf-8?B?T3pZTGJxdUtyR1ZWNVVDTTFqanlwcXpEYmpwR3pzbENmdVBTVnl5Y0FRdDhG?=
 =?utf-8?B?VU1iZUdYQ1c0dWJhV1dyamtjZDNkNmdMeHYzZlBQSGkyQktBclhzYXZCK2Q2?=
 =?utf-8?B?VzBJTHVxZ2FhSVQ4QXlLUlNQRHJ1V0padEV1SElLNXZ3SW1kMVFVREZEUzRp?=
 =?utf-8?B?TVZ1U0xmSWJLalpYRU1EWkNrUHNPQmk3WHB0MHEvdDlNSEJxK0p6Q1UwSVZh?=
 =?utf-8?B?U0xlRTFUL0lTNlR5MFYzOFg0VERhOURIR3RscWYycUhvdVgvZVU4RkJFS1RD?=
 =?utf-8?B?c3hNS0oydXVVMWRpWUNiSXpIUEV6bE1nTm9EeHR6cG9kTDhFK085cXpRcUFH?=
 =?utf-8?B?bmo1NU9uaklhUFd4ZE1oY3Ivc1ZoTXlmV2JvQ1RKSktaMzRHc3BDb3ZFSU1E?=
 =?utf-8?B?YmN3NUsrMnNqNlcvL21hUG1yYlRXVzBLOEFSbzkyY3dyM3ZxUittdDNWekhG?=
 =?utf-8?Q?GISGxfbplBJY4Fps8BrY9M1hz?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bdf471c4-af8b-460a-0db1-08dbb057b605
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB7790.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2023 10:38:16.6955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7h1v7WrBLoKe0UrB+6i+GQkbbf2LPoP9ojN1n4bKBaPAwU4+o99ICW174AexAjHzFNw0xNa0+TVsn2PMirmKzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8.09.23 г. 13:33 ч., Huang, Kai wrote:
> 
>>> +#define seamcall_err(__fn, __err, __args, __prerr_func)			\
>>> +	__prerr_func("SEAMCALL (0x%llx) failed: 0x%llx\n",		\
>>> +			((u64)__fn), ((u64)__err))
>>> +
>>> +#define SEAMCALL_REGS_FMT						\
>>> +	"RCX 0x%llx RDX 0x%llx R8 0x%llx R9 0x%llx R10 0x%llx R11 0x%llx\n"
>>> +
>>> +#define seamcall_err_ret(__fn, __err, __args, __prerr_func)		\
>>> +({									\
>>> +	seamcall_err((__fn), (__err), (__args), __prerr_func);		\
>>> +	__prerr_func(SEAMCALL_REGS_FMT,					\
>>> +			(__args)->rcx, (__args)->rdx, (__args)->r8,	\
>>> +			(__args)->r9, (__args)->r10, (__args)->r11);	\
>>> +})
>>> +
>>> +#define SEAMCALL_EXTRA_REGS_FMT	\
>>> +	"RBX 0x%llx RDI 0x%llx RSI 0x%llx R12 0x%llx R13 0x%llx R14 0x%llx R15 0x%llx"
>>> +
>>> +#define seamcall_err_saved_ret(__fn, __err, __args, __prerr_func)	\
>>> +({									\
>>> +	seamcall_err_ret(__fn, __err, __args, __prerr_func);		\
>>> +	__prerr_func(SEAMCALL_EXTRA_REGS_FMT,				\
>>> +			(__args)->rbx, (__args)->rdi, (__args)->rsi,	\
>>> +			(__args)->r12, (__args)->r13, (__args)->r14,	\
>>> +			(__args)->r15);					\
>>> +})
>>> +
>>> +static __always_inline bool seamcall_err_is_kernel_defined(u64 err)
>>> +{
>>> +	/* All kernel defined SEAMCALL error code have TDX_SW_ERROR set */
>>> +	return (err & TDX_SW_ERROR) == TDX_SW_ERROR;
>>> +}
>>> +
>>> +#define __SEAMCALL_PRERR(__seamcall_func, __fn, __args, __seamcall_err_func,	\
>>> +			__prerr_func)						\
>>> +({										\
>>> +	u64 ___sret = __seamcall_func((__fn), (__args));			\
>>> +										\
>>> +	/* Kernel defined error code has special meaning, leave to caller */	\
>>> +	if (!seamcall_err_is_kernel_defined((___sret)) &&			\
>>> +			___sret != TDX_SUCCESS)					\
>>> +		__seamcall_err_func((__fn), (___sret), (__args), __prerr_func);	\
>>> +										\
>>> +	___sret;								\
>>> +})
>>> +
>>> +#define SEAMCALL_PRERR(__seamcall_func, __fn, __args, __seamcall_err_func)	\
>>> +({										\
>>> +	u64 ___sret = __SEAMCALL_PRERR(__seamcall_func, __fn, __args,		\
>>> +			__seamcall_err_func, pr_err);	
>>
>> __SEAMCALL_PRERR seems to only ever be called with pr_err for as the
>> error function, can you just kill off that argument and always call pr_err.
> 
> Please see below.
> 
>> 			\
>>> +	int ___ret;								\
>>> +										\
>>> +	switch (___sret) {							\
>>> +	case TDX_SUCCESS:							\
>>> +		___ret = 0;							\
>>> +		break;								\
>>> +	case TDX_SEAMCALL_VMFAILINVALID:					\
>>> +		pr_err("SEAMCALL failed: TDX module not loaded.\n");		\
>>> +		___ret = -ENODEV;						\
>>> +		break;								\
>>> +	case TDX_SEAMCALL_GP:							\
>>> +		pr_err("SEAMCALL failed: TDX disabled by BIOS.\n");		\
>>> +		___ret = -EOPNOTSUPP;						\
>>> +		break;								\
>>> +	case TDX_SEAMCALL_UD:							\
>>> +		pr_err("SEAMCALL failed: CPU not in VMX operation.\n");		\
>>> +		___ret = -EACCES;						\
>>> +		break;								\
>>> +	default:								\
>>> +		___ret = -EIO;							\
>>> +	}									\
>>> +	___ret;									\
>>> +})
>>> +
>>> +#define seamcall_prerr(__fn, __args)						\
>>> +	SEAMCALL_PRERR(seamcall, (__fn), (__args), seamcall_err)
>>> +
>>> +#define seamcall_prerr_ret(__fn, __args)					\
>>> +	SEAMCALL_PRERR(seamcall_ret, (__fn), (__args), seamcall_err_ret)
>>> +
>>> +#define seamcall_prerr_saved_ret(__fn, __args)					\
>>> +	SEAMCALL_PRERR(seamcall_saved_ret, (__fn), (__args),			\
>>> +			seamcall_err_saved_ret)
>>
>>
>> The level of indirection which you add with those seamcal_err* function
>> is just mind boggling:
>>
>>
>> SEAMCALL_PRERR -> __SEAMCALL_PRERR -> __seamcall_err_func ->
>> __prerr_func and all of this so you can have a standardized string
>> printing. I see no value in having __SEAMCALL_PRERR as a separate macro,
>> simply inline it into SEAMCALL_PRERR, replace the prerr_func argument
>> with a direct call to pr_err.
> 
> Thanks for comments!
> 
> I was hoping __SEAMCALL_PRERR() can be used by KVM code but I guess I was over-
> thinking.  I can remove __SEAMCALL_PRERR() unless Isaku thinks it is useful to
> KVM.

Be that as it may, I think it warrants at least some mentioning in the 
changelog. Alternatively in the first iteration of those patches this 
can be omitted and then it can be introduced at the time the first users 
shows up. In any case, let's wait for the KVM people to comment.

> 
> However maybe it's better to keep __prerr_func in seamcall_err*() as KVM TDX
> patches use pr_err_ratelimited().  I am hoping KVM can use those to avoid
> duplication at some level.  Also, IMHO having __prerr_func in seamcall_err*()
> would make SEAMCALL_PRERR() more understandable because we can immediately see
> pr_err() is used by just looking at SEAMCALL_PRERR().
> 
> Anyway I am eager to hear comments from others too. :-)
> 
