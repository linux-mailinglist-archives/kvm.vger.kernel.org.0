Return-Path: <kvm+bounces-3658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE71280661C
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 05:24:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5952E1F2177A
	for <lists+kvm@lfdr.de>; Wed,  6 Dec 2023 04:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC12FC0C;
	Wed,  6 Dec 2023 04:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="1YaWU1CF"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2054.outbound.protection.outlook.com [40.107.93.54])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FC9D3;
	Tue,  5 Dec 2023 20:24:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l54j/Y4y5y+MXCY9AK1kwG6w48U6ezSC2CeYstMZl0Fmak9Fool0C9iSbzF8/mTfKAmNR7BHeK2gg7HUQi2T97mGUq0LOP5qMqMC5VdeInzzcVnNVAXUxc7HT8EXrF1lTXUm5Avm3ncafHUbG02Oo56or1fZZa1XCSn0u9U/lLLAwiSE6l/OEGRA24iumbV8aPIzM1QmYh9PziSOekkcQRczjPOh0JeVfmzeL+4SDvbD7qUnb1vcGA+/YjTszhviPmgy1tf2X8PpD/Dbwd3ZP/dS4G0WYH7EAEtGlApskZejcFEM0ByCi9WhOKk4OEAkAINmlDAyfK5pj7qi7RZkfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1aUX/OlAYHqj9Jo3Q9LaDhaLTme4+EK+9qaxX7Wwlvc=;
 b=oEbsn3tePhX6lEKORSNQWyP2RirsiD4//F2ovCuLTgGA7QjgIB9JwjrMMmbFaPaNCWyEr+u1b0/Mgq/0B8Csj5hsj2Ui5+1YHpx8tLw5pC6t53LQY4EZAg7Vb9tdQW+vsSLdIhphrqgFTwV/2RLsT1S7waOG7tyvJ9w2WFMGwrG/6vthB7MHm1ck12+inffRVq4fW+hIudi1dHAp01iOBaZTrDeUhQ2jrVYRqm8RQkuTYy5xrMeRyDzcdwhESm+bEFe5h2W4s4DrEXf38r0RDxPK+6zp+u+f/njDq4/AnhW9hXwNvuInnILyShru5ga9pVsUIuAQ53iGP/BCIfABwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1aUX/OlAYHqj9Jo3Q9LaDhaLTme4+EK+9qaxX7Wwlvc=;
 b=1YaWU1CF0VsdG2dQDog2av83idAtq5GF1Ni2LvXqJ5LXMxug3kOkweK9rN9rQQHZb7jDWe1KFoBV4J9MjmV1HmI/cbVfCL+ex/rjQahowIk+Km1kPoIUaTnlTJ7FXTw4PWsbO6UEcJhv+7ODgKU+rwj5fCr6Dx4Glixq89T8raM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6309.namprd12.prod.outlook.com (2603:10b6:8:96::19) by
 MW4PR12MB7429.namprd12.prod.outlook.com (2603:10b6:303:21b::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7046.34; Wed, 6 Dec 2023 04:24:14 +0000
Received: from DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d320:6e6c:d4c4:7fda]) by DS7PR12MB6309.namprd12.prod.outlook.com
 ([fe80::d320:6e6c:d4c4:7fda%3]) with mapi id 15.20.7046.034; Wed, 6 Dec 2023
 04:24:14 +0000
Message-ID: <b95083a1-71f2-490d-8d08-eefb875bc3fc@amd.com>
Date: Wed, 6 Dec 2023 09:54:03 +0530
User-Agent: Mozilla Thunderbird
Reply-To: nikunj@amd.com
Subject: Re: [PATCH v6 07/16] x86/sev: Move and reorganize sev guest request
 api
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: linux-kernel@vger.kernel.org, thomas.lendacky@amd.com, x86@kernel.org,
 kvm@vger.kernel.org, bp@alien8.de, mingo@redhat.com, tglx@linutronix.de,
 dave.hansen@linux.intel.com, pgonda@google.com, seanjc@google.com,
 pbonzini@redhat.com
References: <20231128125959.1810039-1-nikunj@amd.com>
 <20231128125959.1810039-8-nikunj@amd.com>
 <CAAH4kHabej_mYshdBZsscpwfRASzD3U24+0wUNFLUUPubXDR+Q@mail.gmail.com>
Content-Language: en-US
From: "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <CAAH4kHabej_mYshdBZsscpwfRASzD3U24+0wUNFLUUPubXDR+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: PN2PR01CA0224.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:ea::19) To DS7PR12MB6309.namprd12.prod.outlook.com
 (2603:10b6:8:96::19)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6309:EE_|MW4PR12MB7429:EE_
X-MS-Office365-Filtering-Correlation-Id: 78a56e74-3558-47f0-5fa8-08dbf61333c3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	U0NsL5K+Eu0ZfvIqc++70hiaM5vtU5MzCanxK61oaNsOTjPscLmNBz+ZLpA1XxdpptHjfUcs+AYx3uGA7E0cBsOjNfTdhgxRLGmB0KYrnwWVjAvMfkstEN28B8EWqAwMFSVfQ0oBq5P7pLh9EySvvIzFdxE6SZ0Xj8SWXbO/1Brw4iAFF6fHem2rTxOg9I9mLrxz4B3psxmPADGRrY3yl6ztEcwccoTmv/IJ4keEPAMzz2ihCBcH4ikacSTOFdDmyXiW9kqaXsmDOSsI4wIap1eHvzq1b2UMvhMnDFdV2fevnkzR+/qcQez2gax3UPsZaNsHgIF7M97AXDw+bR67EbFXSvW6Xe0oVP3/dXlaHKVFGgM/j4BdHciJ6kACcmcF2U/5dot82aZOS0Fpjabj6XFCEdnll5bvfGXYMfw4BdZmAucIdHo5GK1HO4QAd/CDayHLiDVz/B3JJg7HpgQ7H1txCAWuhu//Km7fLNdOISzLsPqGb7Bl244ZnWBEUajs6LBlCQOq0pui54iGM8U7WThP+XzilGfpRsk5sQp2oQJjRioRfzQyGtdcszVS3tFTVAd9qF5u+W+xdE4pxg28Z0kxaZcUmiT2AA6hKnDcjbsYxWuKa7pJ8hqPLhrmdN4bTBYTgdiQ5BhdHEX0f9bVKg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6309.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(346002)(39860400002)(396003)(366004)(230922051799003)(451199024)(186009)(1800799012)(64100799003)(3450700001)(7416002)(2906002)(6666004)(4744005)(6486002)(478600001)(8936002)(4326008)(8676002)(66556008)(66476007)(66946007)(31696002)(316002)(6916009)(5660300002)(31686004)(38100700002)(26005)(6512007)(41300700001)(6506007)(53546011)(83380400001)(36756003)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?cmxDeDVYNVk1SE5JcjZSb0ordHMvZ1NDSTVPdFVzYU1CUkIyTXZtdGJvV0J5?=
 =?utf-8?B?ajVMUGhvd0pxMzIxL0tRS29FM2VGWE9ROFZuZHFtZ3RMNjB1cXRIM2RGNzM1?=
 =?utf-8?B?UUc4dlBmU1FSZGRuMFdzSWZxdkw0dCt0Y1ZjdUo1cFdFT0xBY0xQR05sMTRH?=
 =?utf-8?B?YzFxa3ZWT1pEMFBvcVhmTWExQjNuNGloZjE1VkxibHRjd1hLWVlQa2Vkalpn?=
 =?utf-8?B?ekxsMnIzeVpNSGhCZ1lwbnVDeWxwTGtxZDVER3N4SWJBWDRWUE1ISTVoTllo?=
 =?utf-8?B?Tlp5NndIazd2dFhoZWcyRmFybi81d3E5QTIyMCsweHBpbkovZCt4ditXQWUy?=
 =?utf-8?B?S0hhUDE0VUZ2ZGkxUTFBcDNpZHB1WDFLRGdPUGRDcVBhdVVNWTNKRmlzL0kz?=
 =?utf-8?B?NXpYeWNoUlo1d0xzVUVER1hFUGhGZ0ZRSjJ3RGNkNmRCaEg0MTlGL0U2L3FY?=
 =?utf-8?B?REhkb1RhWmlTdXJhODBYUWdhTmFFKzJwMlVDSUM5OVNVUkd6N3lhcHZWK3hp?=
 =?utf-8?B?ajc0bkhvZ2h1RVVjSUJRTWQyQWI2S1YyengrSTlXeFZYS2dRYkhzcm90K1hk?=
 =?utf-8?B?WitHbFMwcmp1eStHbmM1ZGUzUkM5UFNsTU9jS0g4YjFkOXlabVpxdHBYd0dn?=
 =?utf-8?B?TFFVYi9STkx3WlQxRjBmbjBmaFdNOGFjbUJBN0hYSGtSdlovQWlrdFQveFVj?=
 =?utf-8?B?TFp5dWpreERWQnRkRGpYQmRWN0hja3YzVDJoSHNKNENmMVZkRUliTmJWZ09N?=
 =?utf-8?B?VVZmNDAraFBmYm5KRXp0Si9vNXRCL09VaDJwS1BzQnhjRW9IeE9XZFFFdWZX?=
 =?utf-8?B?MVVoVm1mdENpNENscEJXWHlvMlF6Wld6WU9LN1RONmpSaTRuVVMvUDFkTkha?=
 =?utf-8?B?ek9iK2wrMy9YQWpCYkF4S21JVDk3a1U3SkNTVEc3b0JVTThDcGZwc1FlNWxs?=
 =?utf-8?B?eDNnODBVRVBLK0JwZDNwMW01dzNheXVST09ibXM0ZUU3LytRdEdFWFJYYVBz?=
 =?utf-8?B?UlZLK2NIVkpWaFFOcE1sQ1RCSW00aTh3emgxUmhrVGFzeXNiR1BwY2U3UVJR?=
 =?utf-8?B?c29ocXVYcjZvM0FkZ2ZoU1d1VWhtMFlhNEVhMTliNzYvSmxFV1Uyd3FIRTJZ?=
 =?utf-8?B?ZHhBQlpoeThVd29uRTJNZG43TWJzRXRTektLNzFRS2NpR1hpR2sxOVV2QVdX?=
 =?utf-8?B?elZEbnZ5dTZDOFBQeXZzU29wY3dXaFJoYXBaTEtRVjI5N0l3ZDd5ZjBzSE5y?=
 =?utf-8?B?S2hWR0NQajJkS0VnRGRvRFM5NklxcUFnYm9Mck14Qk5OVXZ5a05SUW1pNkh6?=
 =?utf-8?B?QllBenRrdEhma3JlWnZQQTkwMzNtenlxSXdFWGM1RzhTSUpWZ3Fpa1VhNGJq?=
 =?utf-8?B?MHNOWHhobi9UeGhXTlZlMmNQVUxtbzVhbTlwRXhxUURkelJOaDZsblpSeGVX?=
 =?utf-8?B?UHFGMW5Ic2RnMG9FWU5IaXBjWGRDWlo5a3RmWk9oUlpXZjVaaTU2RWswamsz?=
 =?utf-8?B?TDV1ajd6OTRidHl6bmhlZXdDL080WWNkcnp2Y0pFNC9kcTZkaEUzdFpmV29J?=
 =?utf-8?B?emdLWDdhSVFkRmg5eUNYSnRkcFhCbzJpMWhDUGFNY2xpTFgvNmNRcXZkR1VM?=
 =?utf-8?B?WTNIeXNGTUtXcjNPYUZtM09uWmVsb0hYd21GR05xVWd5aDc0SG5YSUY3NEdL?=
 =?utf-8?B?bmRSSTAyajBOWWsrbU85ZHRPMDBQczVERGRmTmkyazZlUE5yMERoWngyaXVC?=
 =?utf-8?B?M1I5TW8zVTFub1V4V3BIVSttS3plOU1CeWNNOE5aL1ZOb2RvU1I3TEx0ZHlE?=
 =?utf-8?B?N2FwajNBRHpUVWY5SGtZeEZLOWhBejNrV0Fab3E3ai82ZWtYWmZ3RTRtekxT?=
 =?utf-8?B?c1JKWkluZlF0ODlsY3hzUUQxWVhtT3NoQzNuZVVmMnNiV0dheVNQbkNSbTVt?=
 =?utf-8?B?TVdQL1JNaEV5ajFZN1N2QUlEajNMUkViVSsyYkNwZ3VMSlNSdVJFa0h0VStN?=
 =?utf-8?B?ekFucmt6ZVhKZURwKzJ0cXVXUUMxMDZnaW8zYzFSMXVmZzFmVzRTUkJpQ2th?=
 =?utf-8?B?aTZ1R1hBRHprb3BWR1UwYUNIN3lac1E2RENNQUNRQjVYaS9pa3JkUDh3NlJs?=
 =?utf-8?Q?Zhszqwh39goZ4Fy2aNAXUvN9P?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78a56e74-3558-47f0-5fa8-08dbf61333c3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6309.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2023 04:24:13.9608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6gtgNzvUv8z5UgnTTwdHJ13XyB7PF4KKpILHjC0Cm386/9RQ4Gqzm3HkTCPSVvUvZd9oK+fgK1nHe+SNdWcUjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7429

On 12/5/2023 10:43 PM, Dionna Amalie Glaze wrote:
> On Tue, Nov 28, 2023 at 5:01 AM Nikunj A Dadhania <nikunj@amd.com> wrote:
>>
>> +int snp_setup_psp_messaging(struct snp_guest_dev *snp_dev)
>> +{
>> +       struct sev_guest_platform_data *pdata;
>> +       int ret;
>> +
>> +       if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP)) {
> 
> Note that this may be going away in favor of an
> cpu_feature_enabled(X86_FEATURE_...) check given Kirill's "[PATCH]
> x86/coco, x86/sev: Use cpu_feature_enabled() to detect SEV guest
> flavor"

I do not see a conclusion on that yet, so we should wait.

>> +bool snp_assign_vmpck(struct snp_guest_dev *dev, unsigned int vmpck_id)
>> +{
>> +       if (WARN_ON(vmpck_id > 3))
> 
> This constant 3 should be #define'd, I believe.

Sure, I am working on few changes related to mutex per vmpck that Tom had suggested offline, that will also need a #define.

Thanks
Nikunj


