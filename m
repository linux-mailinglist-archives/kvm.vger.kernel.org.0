Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FB73349877
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 18:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhCYRlw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 13:41:52 -0400
Received: from mail-bn7nam10on2049.outbound.protection.outlook.com ([40.107.92.49]:11169
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229908AbhCYRlZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 13:41:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=khiSfh2Q7+bzx7yHGjHsOBAcCVvRahBrne2vWMUqLkrc5GKfgEkeTUFDMp+nsEk/Y6ju9BRc0lDmIZrJYtR19emfJqfuG2+57M1EKiksvTA8LdXbCw/4QImChvaq6kPyFlSpDp/EObfOWwdvs7FX+XnK7+FXl/YeaxJGrTRxW0BGnnx1g/GQGhf13GPoFvEwOOqPkz2Ea0XIZFC4FTfp87qbyfSZKdjyOTnrIPsmf/0OzsemaZDz7z6K9p//s0u49nNzBozxUtpLLvEtsVzqBULYAq1k2Bnha92bMJ7/C4KPzFp3KNsATYizfh/lVoL9gLCIA5pTKIxeyYI77UB6aA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVVMsjnf5oeJlM4SetG7iVvVW+DL1rXPg6UklaHAEsw=;
 b=fgjCO6bD5Zdq4CdxWLZEUpMAA3UpAHxUvVdJOmTA5LS4zlOHFTv9Hno9ZgPdbYtGveSb+kWyEDK+q0CF0XCeBL+ZqiHU+fxHveQ93lcYNNO4b/pPMSycGiJjQmXGvoHBkopeZkPKdFkj3P8mzEXcGgquoY491I4nWZOycF70VBVDAL4DPxW9WueuOwEIj7ve5QIg1obTDFr/ZnKzOilmcE23Pe5xFr4qhK6MAXnCvDdKuQWzBfrjyqQQhYujZLCxIScdxw072HBCJbnBwkZaXgaA9XAYl9XvygWZiAd/yOu+Ab4IRggC/Ptk3Y4Gnh3XC9M/HTwM0wdKRLD8Esqkwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SVVMsjnf5oeJlM4SetG7iVvVW+DL1rXPg6UklaHAEsw=;
 b=X9o1IYSD/0+dont1jbpp4yHl9PhOwDkrV4f0AwIfUl/jUbeh/ZzsLJDpLImwAYuwWWyMt0P8O9wYsBEMB4T/zpaBnr2bGDUH75QENJ6EWU+vpNAw8TF1Blte7B7FqrBSA9n//lru8drUwWM2iiqCABejTbrX93MuAdkMVN4GaMc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 17:41:23 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Thu, 25 Mar 2021
 17:41:23 +0000
Cc:     brijesh.singh@amd.com, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC Part2 PATCH 01/30] x86: Add the host SEV-SNP initialization
 support
To:     Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, kvm@vger.kernel.org, linux-crypto@vger.kernel.org
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-2-brijesh.singh@amd.com>
 <696b8d42-8825-9df5-54a3-fa55f2d0f421@intel.com>
 <7cbafc72-f740-59b0-01f8-cd926ab7e010@amd.com>
 <8411ae2b-1a4a-d124-ffcb-ff351adac90e@intel.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <cfe8e5ae-2e97-efda-cd2b-684c8184a4b6@amd.com>
Date:   Thu, 25 Mar 2021 12:41:21 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
In-Reply-To: <8411ae2b-1a4a-d124-ffcb-ff351adac90e@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [70.112.153.56]
X-ClientProxiedBy: SN6PR16CA0062.namprd16.prod.outlook.com
 (2603:10b6:805:ca::39) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Brijeshs-MacBook-Pro.local (70.112.153.56) by SN6PR16CA0062.namprd16.prod.outlook.com (2603:10b6:805:ca::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Thu, 25 Mar 2021 17:41:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1333092b-ce0b-40ce-1808-08d8efb5350b
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557D6ECBFA8DCECC6173786E5629@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1CavKi/cVVp+nvk1BliwnaHTQBA+CenRrfmZmq5oLYUWb1qKEzSo9/7tHsnvHf30cMRTDMndVxbUnmgFwhp55aJofnVP5OrlNK+zwORBs3w4VoujReLKDE7/uDsGKA7Ss2j70evwrxb0QboUqoIz64J0bj1cLyQhjs3mWSQc+WJu+HnqIojuI71pclb6LqCdFyKpo9iq8wFnHwAkHbR/eXl2g6rxhMnDeuBnBOcQCB8sz5pvwpl1EZy/LlPy387MM2Li1BGKCdYUB4gke4zOVdRLcdleHY1RGcfjAQEgtFgn0EsrLbu7gN3hu+ERmb1/8KgrZJLhdhKfoXLc1yMuxHc1tLStk6rcvUYlGBwoYUNfLUhKAbYlhVmprwcuzoVX1uoiEZzZvK8puavMtde5GVyoUWK+QjxiOTYr+6va+FN/OUG55T5hldK8whcZoK/x4780cQ9K5xbuggrq7m2TDHz7C3ICxbg4dahq3jOSmA9BeJDIRmseGPz4rphuSwqIwLZGN52wXGH1dG173XCPpR5PXjlg5nnorBphe/g9uRkMmHblgdw++gE6RNPWOAxolLvZQcvIjn6HR3oC76U9YMf8hbioxiq4mWILqVyeu6y4PaOsSkO8jKQBO3mS4FYYktLj40zN5NFLIq2frL//X7TLenPWLDoQwmf316FIv1feEp7LkHeocUpUbhmWrjxAdi1g5yFw6KYBg+KnWzYoD1coRVENyUQ/zDBH7M2ummQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(376002)(136003)(346002)(39860400002)(86362001)(54906003)(186003)(6512007)(4326008)(44832011)(31696002)(38100700001)(316002)(26005)(2616005)(53546011)(16526019)(31686004)(66476007)(5660300002)(83380400001)(52116002)(8936002)(478600001)(7416002)(6506007)(36756003)(66556008)(956004)(6486002)(8676002)(2906002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WWhtT0ZBRXVCRTBaVkE4Y2JKSll2bEhCY1dlZGFQU2p1emZ2M1Bqbi9yL3Jh?=
 =?utf-8?B?NjZocFgrNUlYcWgwb0lObGtrTGN0dlFYWlhMdmVmRVRISGhOclBXMTRuOWFv?=
 =?utf-8?B?c1Jtay8yR0FTWnJWOVB0SlMrM0NFTUVyOUk4MjJhek9TQmczRWQ3WmlZekor?=
 =?utf-8?B?RlBlclVyTTVSUFNGeUQ3dlQ5MzZGYncxTFp6Wldpcmx2MFQvSHZKd1U0SjJT?=
 =?utf-8?B?SUlldlI4emY1dXJBM1hGc3pBSW93VWJsZlZBRkhxSnlnOEludUo5U3JrNTE1?=
 =?utf-8?B?RmJKcHZYbW43ODUvZTNBNjN0akw3bTZzUW1ZejVDcFJxZnpreUUzdVFlNUdn?=
 =?utf-8?B?ZGtBQzdYUnNoSUNJMjJiZmNHZjczV1FLYnNTc2I4MTJ6WFpPS2g2UTZldnRX?=
 =?utf-8?B?QUdQa0ZkMms5ZXpPN3lublFSM2VBcXl1L2MzZWw2M3NRcEIxcGhKUTB0dDc1?=
 =?utf-8?B?V2wxZFJtRERmS1MyRUE3RVR2NUVXOUpFNi9IVzMyUUl6Z1pYR2tiRHdLbjBw?=
 =?utf-8?B?elFwdmZncDgxeDJqQkdKTHFGZ2toZkdSZEovVnZnWjVsdTdoUUlLSTE4TVlO?=
 =?utf-8?B?VFM3eWZUOTZKenBrbEJPcmtMS1NNSVVaUlJ1TUtOeTZJMm1zbVFtYVR5Ujli?=
 =?utf-8?B?dzV1cjNFMXpqeTIyaFVIdnYzejR2YWJMTUVvYlpnNUhhTEUrSENoemJHc1RD?=
 =?utf-8?B?b0I3NEh5TU5ERVJScGVqQnhvdFoxRGlybU9wbWs2Yk5DbGVSUWowNFB5Qndt?=
 =?utf-8?B?bnRjc2RreDhiY0NZSVNMZDVXbnlHUkQvWkQ5SmN2WGxyWEdJSjRMT0dyKzB0?=
 =?utf-8?B?RVNBSm5udXdyUzNFaDNVSGRnaXR4YVFJQmxzRU1UNEJEVTBiSngxNDJ0OEV6?=
 =?utf-8?B?R3hBSzJyK2xvM3FHbEpxN3pWWGNHR3kwbGZiM215T3pIWnQrNWVoRGE3NzJ6?=
 =?utf-8?B?dkJ5TGkrUm5lbFFOa0NNV3JtcExHVEpHL000dDJWS0pDcHZVTXZJMXhiRUR4?=
 =?utf-8?B?cWIwa2FDR2orNGhCVnNGNmk3K1hWN2NBUk9MS215ZzRCS2xZS1dPSHF3ZXU4?=
 =?utf-8?B?bWlOOXdMaTN0NDAvZ3ZSTXBGZTFkT0ZEVWNjbWF1dHNnckI1Rk84OFdXaHdZ?=
 =?utf-8?B?cHJVZkVKcjBwWlFlemJjVmpkY0dORG03Z0dkMU8rcnprMG9jeEZ0THFJU1Ry?=
 =?utf-8?B?ZHBweCsyVHhvYnhmSTdXeTBJSE9zalNrSE8weWhCekJ1WVdpOEprVTFmRzNi?=
 =?utf-8?B?UHBPa1dsUjBrQ0krVkN1MHY1aGE4T3NYNURhaXRjUmpWOGRoYTkxdGVSK2pk?=
 =?utf-8?B?WHBMaXN4N0RTTFhaUFBnMFkzdGdrL3BsaEFWK254eUNRN1pnZDBtQzB4V1h5?=
 =?utf-8?B?K2p3V0N2dFVseEJYS0JZUFBwdDZWbmxjRmtrcEpWOVB6SlpKTEtWTVM1VGwr?=
 =?utf-8?B?OTVXOWl3bkZWYUNNc0RxRkMxN05HOTZBSDB6RGl0eFpuUFBrMTBLdUZBVkh3?=
 =?utf-8?B?QTVjekYxVXJOSWtEL1U5TUEvWVQxUDFPQXJYNXZCNXhmaGo5cFBXbUpTWHl3?=
 =?utf-8?B?RW95ekdGbERxOVh2dm9lTmpYYXlSWFFwSWxJZzRjOTEvSnhjWEJjRmZmd3cw?=
 =?utf-8?B?LzR3SnhNRHB2WWVXMEhKZVdwQXBwVXF4emFKM25CU21YbmVDMUpIeldhd05h?=
 =?utf-8?B?Ni9LK2V0WU83OC91ZEdvekM5U1ZtR0JEU1N2cUkzWXVMemtEeWN3UmM4TnJG?=
 =?utf-8?Q?AM9zGbm1PB1Z/vL59SxpdvAhEhmFfQFvH2shmNg?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1333092b-ce0b-40ce-1808-08d8efb5350b
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 17:41:23.2802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cIMwj2XasJAi6jJ59N4UM9dFQO0eSSoMvti5RdCk/tPiOaJ70kdy6XQRlQONRqeMK406HUJp80tJ03SdwBCYhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/25/21 10:51 AM, Dave Hansen wrote:
> On 3/25/21 8:31 AM, Brijesh Singh wrote:
>> On 3/25/21 9:58 AM, Dave Hansen wrote:
>>>> +static int __init mem_encrypt_snp_init(void)
>>>> +{
>>>> +	if (!boot_cpu_has(X86_FEATURE_SEV_SNP))
>>>> +		return 1;
>>>> +
>>>> +	if (rmptable_init()) {
>>>> +		setup_clear_cpu_cap(X86_FEATURE_SEV_SNP);
>>>> +		return 1;
>>>> +	}
>>>> +
>>>> +	static_branch_enable(&snp_enable_key);
>>>> +
>>>> +	return 0;
>>>> +}
>>> Could you explain a bit why 'snp_enable_key' is needed in addition to
>>> X86_FEATURE_SEV_SNP?
>>
>> The X86_FEATURE_SEV_SNP indicates that hardware supports the feature --
>> this does not necessary means that SEV-SNP is enabled in the host.
> I think you're confusing the CPUID bit that initially populates
> X86_FEATURE_SEV_SNP with the X86_FEATURE bit.  We clear X86_FEATURE bits
> all the time for features that the kernel turns off, even while the
> hardware supports it.


Ah, yes I was getting mixed up. I will see if we can remove the
snp_key_enabled and use the feature check.


> Look at what we do in init_ia32_feat_ctl() for SGX, for instance.  We
> then go on to use X86_FEATURE_SGX at runtime to see if SGX was disabled,
> even though the hardware supports it.
>
>>> For a lot of features, we just use cpu_feature_enabled(), which does
>>> both compile-time and static_cpu_has().  This whole series seems to lack
>>> compile-time disables for the code that it adds, like the code it adds
>>> to arch/x86/mm/fault.c or even mm/memory.c.
>> Noted, I will add the #ifdef  to make sure that its compiled out when
>> the config does not have the AMD_MEM_ENCRYPTION enabled.
> IS_ENABLED() tends to be nicer for these things.
>
> Even better is if you coordinate these with your X86_FEATURE_SEV_SNP
> checks.  Then, put X86_FEATURE_SEV_SNP in disabled-features.h, and you
> can use cpu_feature_enabled(X86_FEATURE_SEV_SNP) as both a
> (statically-patched) runtime *AND* compile-time check without an
> explicit #ifdefs.

I will try improve this in v2 and will try IS_ENABLED().


