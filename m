Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D9E41CD68
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 22:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346732AbhI2U3E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 16:29:04 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:47456
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1346361AbhI2U3D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 16:29:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=drpsbvh7MgxDtxqID7hERTQGpeBlQxcmBxqHSrhSyy1aOI25E9LJAChvHlsUJZI3bOK22YCQ2D0C8Byb/nv+75UI0E6o2ObHrOXpoGhAxkqmz15PHaHdlzzp6T+hzY/V6ClVVG4RSnShuhoOlNJrv8FR2jzN8n0f0NMBfTEhqc9V0RGEcGzD67AfcxLVhW9cvXj7OI1zk1oDxc1PjO7pPPoeoA/yCnBfJBPBetAfY6GGAmvyUSUVTPSCeFE0118hM81HQj+l+D8jK+zD5OmEVTO0uQjWLDcB9ist0Ob6eO7jdg173Hsvn2uGpEV0WSF9aOSTk2iRY0wrPkER6+bZdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=tnVCBr+IG1flQYsroaP+yWpoMRSIE1BBjrR/tbxukJI=;
 b=LQapU9wFTyLtY6HFYP5hCXJsM9UNL8gWZXhRGjYe6dOjD4oQm8A3QSld+fc4zlL3sFWwXNpqJHOZtY+XAareBkmPfgDjVk8UzoLnvpli4PLcHm0B7OPutVIrlEp8vabdzIJNARlmEz1z4TFvrh/RKw6TDNQdCdi3roswbYTPfNwunPTad0OdfIYP6dcdZgsR523hoJZwkwoweg+4hwWHwZvdtPVvoJjwn6CG4W7CZqnpOLzMwop/kRHnocw7XEQumIKO/U3+/YMaM5paAKMkz76nvenkiMVEs/q0aou0NGlswupQt+vmHxU417Xv4P+3XKPj4QeRX59spNDLsi5olQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tnVCBr+IG1flQYsroaP+yWpoMRSIE1BBjrR/tbxukJI=;
 b=hl0FHs/ZEeqDy8m4l3UK8d/2d+8r2ml0pPOZJlvS2dEh2unPtoaQWr0aaPoP0sW9tQUwy1Kvj0Rqe519Nxj9h2mTFMTMbPujKqDssSG7enJh/Yw8Kql61F9A6Ikr+z4kjuDBUWoBtHmQUxy5AZWZDlenxMTK4FnHTEPd7nKY6QA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from MW3PR12MB4553.namprd12.prod.outlook.com (2603:10b6:303:2c::19)
 by MW2PR12MB2538.namprd12.prod.outlook.com (2603:10b6:907:5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.16; Wed, 29 Sep
 2021 20:27:17 +0000
Received: from MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::41ef:d712:79a2:30c1]) by MW3PR12MB4553.namprd12.prod.outlook.com
 ([fe80::41ef:d712:79a2:30c1%6]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 20:27:17 +0000
Subject: Re: [PATCH] KVM: x86: Expose Predictive Store Forwarding Disable
To:     Paolo Bonzini <pbonzini@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org
Cc:     hpa@zytor.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tony.luck@intel.com, peterz@infradead.org,
        kyung.min.park@intel.com, wei.huang2@amd.com, jgross@suse.com,
        andrew.cooper3@citrix.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <163244601049.30292.5855870305350227855.stgit@bmoger-ubuntu>
 <d1b1e0da-29f0-c443-6c86-9549bbe1c79d@redhat.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <44cef2e9-2ba1-82c6-60bf-c3fe4b5ed9ff@amd.com>
Date:   Wed, 29 Sep 2021 15:27:13 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <d1b1e0da-29f0-c443-6c86-9549bbe1c79d@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0229.namprd04.prod.outlook.com
 (2603:10b6:806:127::24) To MW3PR12MB4553.namprd12.prod.outlook.com
 (2603:10b6:303:2c::19)
MIME-Version: 1.0
Received: from [10.236.30.47] (165.204.77.1) by SN7PR04CA0229.namprd04.prod.outlook.com (2603:10b6:806:127::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.13 via Frontend Transport; Wed, 29 Sep 2021 20:27:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e89c0a14-ae88-4224-75fe-08d9838787be
X-MS-TrafficTypeDiagnostic: MW2PR12MB2538:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR12MB25380B930C15C25907A626B295A99@MW2PR12MB2538.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NQUl52N/IpIAYfrE/FKaY17pwThjWqYBdCisWm4ju0O3IbPbF7qr2IbzoiTTb35AxFhmoq0RnRipstl5StWyloXNMkBM/K3JM71Cn5PKdUuwWjS17zYmBfKrqi4JUP8H9TqOj/f1J/CPP3nTPQsQmPruBSZ3tFft/flmvcHfN3kb4uC8Q7Ws6pJsuP+P1MyibNJI6Mw19cryA923q3C+nCsjn8RQEscl5KkOuagWMUkvoxrlH8CYmP9uQSrLlxbolhkqUJsreZ7VN5ApJ0IVCsJOjK7uyGPYLR84qMJuSX2a/wINoSGXCZ5R0u+CfTrOlVLroAGXWfuP2QvKXKeWzPtmtbW5tMbCr6IjE1jCzjkMnP6mzfRDDKhP1/szHUHD3GzPDAItkPGySfeoQBWuB8Vb7dnoo+AAffkOBHvn5matdRTywCrNA6IE9jplzpcsqs2/avGHpCA7fcghNY2UmRvXpYSTasreDDLxBKsqzXlZLimbFrO01wjf0bl697r2kyD20ndtK7bVIfgQbWingXktTC5j2g0t6vLAykKv+zylCs6zEd3przOZiZZZx1pkEs7whWOUca2I4RBJp9RGVMyE0/hRafVL/a+MSIctYF6VammbSunw7gp33tw2F6id+swZnhxpQ3jErbk/COOdOnJ8cDTusjgPrEskL1SSMdHMQHM1c8+hrvLLF7vVg/2nu6RrDs2g40QLsbwbMlT6UITEisYueg2RopnRUfRjKXx3VLkqJ87NJUtnok/mFY0OS3O51f8WJb1BbsKrQ+Gfng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4553.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(38350700002)(38100700002)(2906002)(86362001)(6486002)(16576012)(508600001)(8676002)(36756003)(52116002)(5660300002)(8936002)(66476007)(66556008)(26005)(956004)(7416002)(44832011)(4326008)(53546011)(2616005)(31686004)(83380400001)(186003)(31696002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bnJoU3hLRFpDempDVGV4d1FDRloxdXdKWXliKy9LSUlsbVN2SWVSeVJDY2JX?=
 =?utf-8?B?NFhuck01WkQ5TklxOHRQZEVNNG43eDQrQmYwcHg0L3ZYcWorYTB2SURDMURQ?=
 =?utf-8?B?bjlZYVl5QUxWQmg2WXEvbVVxWnZ3blBxeTZjeStEQTQyMWY3RWdnVjFRUUVp?=
 =?utf-8?B?ekY2UkJSUmJQQk84aXhGbm9ydndqNVU5NTV4aTNGT0kyV3VhSmF3TTJLL3RY?=
 =?utf-8?B?eVNoYnNIcmlXZmxCazlsUkRqRDNFS3RXREh6Yks1eGU0cVJSTTU1aW83UWt1?=
 =?utf-8?B?bkpBeEhQcWtOY1NHRi9BME9GUTh0U0kxZ0hocERIZnA4cDBNcmtoaU1kWGxr?=
 =?utf-8?B?WkQwYkR0U3pTbGhwNGhTdDVvVWplcGtZb2VmeUQySE1ESmNvVzNobFNvN3R2?=
 =?utf-8?B?QnpoM3hjTUJ0SHAxYzJQR3oxaHhNY2V1WXFFdTFtNm51RE9wdzRkeU5IQUNR?=
 =?utf-8?B?VlFYN1N0d2pDSCswWHA1L1FrM2NQdlZ5bmFkMnVEQW9RRkRySTBMajhDanl0?=
 =?utf-8?B?dFNrUjgwb0UzSUN3cGlGY0tHWkZyaXl4QUtnTFdXYWcvc3U5dkRqQjhXOGFo?=
 =?utf-8?B?UWFmaXNKVlRHWmpybUV2Zkh5VXRFRkgxa1NiWWI3ZUkwVTZsc0FURnBaK2RD?=
 =?utf-8?B?ZXVCRzRTVHE2bnhVemgzZEhLcE4rYVpiUzkvTFZINjViOXdGSk5qMVV1T2JV?=
 =?utf-8?B?VE9PaFhiOGRoaStVM1VHVWVVWXN3Y3RPeDJmZTFuNmsyMUhhbXo3YjBQclg0?=
 =?utf-8?B?cno3TGUwSVF1U0ovbDRvcTBRS28wTjBYUGlDcTNCbENjVXhDV0N0Wi9NU1A3?=
 =?utf-8?B?dktiazgwTHpFSGpJV3dKYm5ERGtpZXROYVE5VDk5RHBrR3ZGU0lyY01VaEV3?=
 =?utf-8?B?Q2x4RzFFZi90MlZwQnQ2TE9JMk1BS3JOR3hmZGZJUDBPZjFpTklJZDVHZ2pS?=
 =?utf-8?B?ZEdwR2FlVFA4WDdDRCtldkJibThyQ0ZOdXpYTjQyd2pmNHRldzBjQ095T1pQ?=
 =?utf-8?B?L05kU2t1ZE5zaWtoRU9SSy9takRiWFMzc0pZVVU5UTBwa1AwQ1FrTmNMWjdH?=
 =?utf-8?B?RnBvUXJyajZDU216K0thc1dHbHQ1Wm5scW5kNXpHUGpPZlFQOWRBaUJjVFlB?=
 =?utf-8?B?TXFzTm5IYWZUWFh2bDdLbmxWZUlWcDR6cFA4ZmsxZVprWHcyOGJ6YnZVdU9k?=
 =?utf-8?B?NnV6Q0M2SVNpT0FRZzRLQjRraXZSM2M5S2pSNksweG1iYVlEd2syMTJjSnE2?=
 =?utf-8?B?ODdlbHNqS242ZS9lSHdXQndDdlVKeHN5MEs5SWFYSk8rWGJGeWRGeUJDSzcr?=
 =?utf-8?B?dkw0RGFibE0yOHNEQlNaT0hxYktyMTBxaEk3czlIRTFQUFlubGljbitiRXhn?=
 =?utf-8?B?UGlDRFBsWitKYUZ5bEkvbzFyNnhUT3dDWjQ4Uk45S2g5RlhKcTdNTm8za0tY?=
 =?utf-8?B?RTY3c0tTdjB0VVptN3VqN04zK3JqakhPdndwTFdta0NkRk9lUTg3KzFTM0to?=
 =?utf-8?B?TnFuNXNLQ0czQWVBa0pWSVdFcTFiaXRFckJjbjZjU0Yyb0xOUUhKTzJHSC81?=
 =?utf-8?B?TDBFaW56eXZKTE9aNVFBSUIyK3g3OEsreG9JNGxjby9uZU1DRGZHdldpenRl?=
 =?utf-8?B?YmVGM0xGeThBckNuampDOXpORjlkc3dJZUNTcjFMSGRSUGx3QTEwZVV5dTZh?=
 =?utf-8?B?ZE94VlNqUTJnbm1ZaGd6ZWh2c3NiVHVoMjNkbHkzSk5zbTVyNTRKRzJWak1V?=
 =?utf-8?Q?oPdxWGTJ4jpjpYdjCRBz1yy9v3ROw6On/GbV1w9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e89c0a14-ae88-4224-75fe-08d9838787be
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4553.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 20:27:17.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7JTtwJw3smyXGcDvC6UCjNxRV+1yAljWjd86C2x7ppNSp9MzYksS1ApUXKJg9EC4
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2538
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 9/28/21 11:04 AM, Paolo Bonzini wrote:
> On 24/09/21 03:15, Babu Moger wrote:
>>   arch/x86/include/asm/cpufeatures.h |    1 +
>>   arch/x86/kvm/cpuid.c               |    2 +-
>>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> Queued, with a private #define instead of the one in cpufeatures.h:

Thanks Paolo. Don't we need change in guest_has_spec_ctrl_msr?

> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index fe03bd978761..343a01a05058 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -53,9 +53,16 @@ static u32 xstate_required_size(u64 xstate_bv, bool
> compacted)
>      return ret;
>  }
>  
> +/*
> + * This one is tied to SSB in the user API, and not
> + * visible in /proc/cpuinfo.
> + */
> +#define KVM_X86_FEATURE_PSFD        (13*32+28) /* Predictive Store
> Forwarding Disable */
> +
>  #define F feature_bit
>  #define SF(name) (boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0)
>  
> +
>  static inline struct kvm_cpuid_entry2 *cpuid_entry2_find(
>      struct kvm_cpuid_entry2 *entries, int nent, u32 function, u32 index)
>  {
> @@ -500,7 +507,8 @@ void kvm_set_cpu_caps(void)
>      kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
>          F(CLZERO) | F(XSAVEERPTR) |
>          F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) |
> F(VIRT_SSBD) |
> -        F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON)
> +        F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON) |
> +        __feature_bit(KVM_X86_FEATURE_PSFD)
>      );
>  
>      /*
> 
> Paolo
> 

-- 
Thanks
Babu Moger
