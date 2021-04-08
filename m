Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E987358BAB
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 19:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhDHRsJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 13:48:09 -0400
Received: from mail-dm6nam10on2055.outbound.protection.outlook.com ([40.107.93.55]:12421
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231676AbhDHRsI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 13:48:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WF7DdpS8NDcygnJli59sHXlHVVBoyUS/Qf/82CFqYa0bOSPiN2IsCt8Sh1lEW9alkl2XSbDOKrq229lVnMKwjcM0KCYIY7oXDSycsTeUU0/hDvQQWKuX3fJGBTEWWZBZMfanPPIIYCgXhVaoOY6Lj8uw3Olo1RsFB2b8jcMzI8Ftqol/w+55psaPRUoTaEy8e3m8WPpyE7UAc1FXAVRC6YOHUrR2UWPWXYdJkNf6McPsYf3gDbZSdZ993ZUE1MU13JEL0vjhm9BVujQ2/kzz/NSFeQT3DjsdXZ1usRU0vRsHSkGG6ITcrw0XvSC6MGcFXlQaLgvUWndnvCUzE6HnZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imuc4lRKm27U5s2RxrFJySbyDN+emkHpdRUzNnYJITs=;
 b=kJ8Q7BnT0D5/6uUEJ45b5+IzrpOoXiu71J8zusPtDVabZLHpS2g3Wt9iz5JtT5CwZcqufB88e5QbmAFUpqQl+cOIij5hYDB6KkQ7ZDqAlEFWUCYB6VC9OmJJQ54w4QsWAKCPBISumP3ZzMVhbG00GCadRyIIj+cuz4JDRzNVdxOidoSCeXddWtnNwJejtLqC7HvT9h3kL93lRGsJc9NCI1dVQBaBkzxu6674zVsL9qSrXP7/r//7yGgjneiV7I0A+xgVOR9SjOMhXC1pSdfi3xMq7liDGLfBemExhLGlsExa3QBZ7z+cIRHNx2gl/QpJDEpiToKNhuJ4xgKKTTGjyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imuc4lRKm27U5s2RxrFJySbyDN+emkHpdRUzNnYJITs=;
 b=dx6E2C+xcWm+RTEnQlin84c1r2ab0jGw5DRnD0j5MVJRS4JnrFyV0nmE3w5DRjX8GERDhLH0vWBzGyWrRuhcAxwNnabXIVlQMp65Yw7INWdGdFxHODQnrVnUWv4TW2+i1hPEB6CTW/C2ZW05d7iJsbybwT4AGj/7/jVSlp4LEEU=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.20; Thu, 8 Apr 2021 17:47:55 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::c9b6:a9ce:b253:db70%6]) with mapi id 15.20.3999.034; Thu, 8 Apr 2021
 17:47:55 +0000
Subject: Re: [PATCH v2] KVM: SVM: Make sure GHCB is mapped before updating
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <1ed85188bee4a602ffad9632cdf5b5b5c0f40957.1617900892.git.thomas.lendacky@amd.com>
 <YG85HxqEAVd9eEu/@google.com> <923548be-db20-7eea-33aa-571347a95526@amd.com>
 <YG8/WHFOPX6H1eJf@google.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <3c28c9bf-d14e-3f9b-0973-ba4a438aaa33@amd.com>
Date:   Thu, 8 Apr 2021 12:47:53 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
In-Reply-To: <YG8/WHFOPX6H1eJf@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA0PR11CA0013.namprd11.prod.outlook.com
 (2603:10b6:806:d3::18) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA0PR11CA0013.namprd11.prod.outlook.com (2603:10b6:806:d3::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 17:47:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8105867a-6404-4cc2-f6e4-08d8fab670c7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1449:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1449A89A075A0D1A95BB6191EC749@DM5PR12MB1449.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KwK34pVjgUpv+4kPzo+t+7TXtG8+NIb30uQp86ZQ2S+No6y0/zJQW7b2/n8HPwXK7B7AMCPCzrlUvNOrVPz2HxSrLvunxPIeO9Jbm9fnmT5CV6mFddF4p4SwAjeO2opLWW7RmJy61Wyuzz6aS0ceTmfYjgi3+4kQwbTvuvipnPvCE5Zt9y9o5VrAvimY/nugE2rETgWMNeIBopswKQStTkhkC53azOnVdnifaX9JrxlQoDh37PGBrJZiGK9n3aiGIDmdrtoSYEbh8NlHRO/i+CsZeKcO53t7z3iqRIjhKz82w/hbsGlG1+bviaVZoCnWfYS3lWtXfZ483iRKSZGrRzO/eoud1M6Ht0NQnnVmXUevgkXBqI6m5sJZRbHKwBlUWK45avnDOoyfotdNWEpi7tOxR6V38rDlQdCk7dwPvTRZ+uxUWBTCAngozh2NytjSg7SdsZ0HD19ERxP3ScGO/2K9dbamgsm2mZh+qFcRRLv/0Igm0u4grd53iuOfMVHNWG5fZX7Df1cL45zmJ1smQHB7KVv0lGZKF+PnuefOPM7D4qsBy+31gB9n1m4FoVOz49MXlNqq6FZzz1JJOJkQkwIv1duJXSXChgj7n84ePuPngbAmBOWIcTSztEylpSZU84ZcIDtUwj1BJcHNEZ9CArjJwNt8dKbNR/xfXxEE+sRnZNrBanOeV4lGTz6gOq22ErEoPkgDIhB7tkH9EjgGoAzB+Ut3P8HxpTGwkgZ5CL4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(346002)(376002)(39860400002)(366004)(316002)(6916009)(8676002)(31686004)(478600001)(66556008)(66476007)(66946007)(54906003)(6506007)(53546011)(6486002)(2906002)(16526019)(26005)(6512007)(186003)(36756003)(8936002)(86362001)(4326008)(5660300002)(31696002)(7416002)(2616005)(956004)(38100700001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VVJFVWNhY1pTRDRVa1N6TjNxcVNmclZLb2tna215bFVueTFvMklOTitxaEJP?=
 =?utf-8?B?RnRHUjdCdUduRUxLK0E5bC9XUnUrS3R2OGZPRXBIUVlDekM1ZXo3Y0dyTHIx?=
 =?utf-8?B?Ylk2dVlPZUFzWDZMdGNwY3NCd2pkbWJmQU5vU1JJMEZNdjFKVDJpdHdld29q?=
 =?utf-8?B?TUNpbVdEOVlIL3M1TThobk5pQlQ4TVVPWDEyUk1FUnRRRjJhMzdUcXhzb1JD?=
 =?utf-8?B?NWJSWTArUTJlRlRwRmdDdkNpVDRjTHJQVHM4L2VldlRPL2V0dnpkR0hFV2Fv?=
 =?utf-8?B?bzZhem1ZM2pGNDFXN0pIZDN1S0tQOHF1QzB0REN5V0pqS3FmbzlLZ0VyTHJ6?=
 =?utf-8?B?OUNpVGpFSDB6clIzNUVGTTdhT2JucmcrN2VHQk40cmszcUNYNXpwdXVxNTEv?=
 =?utf-8?B?ZXBjdEtabnFaU0h4MS9aL0trbDNOU0ViTS9QdktkRUNLaUdUbDRrenlidzQ3?=
 =?utf-8?B?d242NHU4TmQ0L2RvQXRIWGNoYmZzQ3dTNHlsS0FDdHhJdHZ5WjJTWXMvcEZY?=
 =?utf-8?B?ZVArTnlUWFlJNU5qRCt0Qld2OXYyeGNIM3lUSUVxZlpHTTlJZTBQM3ZWUWdJ?=
 =?utf-8?B?clJLcStxenZ3ZEZIUG81dk9jVGFPanp3T2VDc2t1d3Z5UEFMNmc1TU9vTG1M?=
 =?utf-8?B?YTI3bVh1RVFNUGsrSUtiWlJ0NTNGL3JSUG0xSzNQQmZFNW56eXNkWC9Fd2l3?=
 =?utf-8?B?QmF6QkZkejZnM1JJVThEVldGbWE5blpRL0hmcXdLcTBTd05yVmtBdFJTZXB3?=
 =?utf-8?B?Mjk3RURXNHdRd2s0c0ZZMHJya2tyKzVnM1pYS0ZFZHd5VCtpU3dmQS83NHJI?=
 =?utf-8?B?NlB5ampzNW91NnFlcjFEeTl3cU02VU5NcTV5VEZ6eVJSZ2JBR25haFl5Sm41?=
 =?utf-8?B?MzhvMURHUW16YkFlcnFDRnRsUTJTZDl1eDZHWHF5RWZHOGp3ZUlrRXRGNmZP?=
 =?utf-8?B?NWp5blBacWpwcFRabnd5VjdqSXg1dnNiMlVjaGhYN2RpSnE2KzE1dS9PeGRz?=
 =?utf-8?B?NFZHSWp2SmFNTk5PdGRPZzU0dWgzdzYzM1dYekJjSTVXOElZZk9LRm15ZFBk?=
 =?utf-8?B?U09aRUUyQzFvRGpRUTdFUVRvUWNDYU9mbm9WT1FGV1dhazNjODY4bkxQK0hI?=
 =?utf-8?B?OFpOT1ZRNHBDVlpRK3djMVRaMkM1TFhZdURkYUgvYUpma0E3N2lYdjQ4dm90?=
 =?utf-8?B?V056OXFHRUIrVmZ0eDVJM2xEeENYeXZVNkg0NDd2cTdMbnBsSWxzdTlnVE0y?=
 =?utf-8?B?bXJUMDFNTVBGN1BhaGcvSVhUZklGQUJ6NzkyckNwN3RKRzBnLytSZy9mdjUy?=
 =?utf-8?B?bXZyZkFLZ1FXd2FpeU9aYTZQalFpWVRubU5JMXlhSE9rUk1kZ3ZuSHpDT2po?=
 =?utf-8?B?ZTV6SlZnTkxlOUJMYmZkZmNhaFVGdGxTc1VZNEppUmNxWW5ZQ0lSZ1p4WEpR?=
 =?utf-8?B?bjZTWXF5NXNmYnZQTmQraHdpSkRlWFVxOHpJb0dnOS9vdE41VTBPRFFYcU1w?=
 =?utf-8?B?UzZPb2JmNUFwWTBDOE53cHl2QUhGcnlFaXNzTFdJUEV3YTErbklEZVV4TklO?=
 =?utf-8?B?VVZLZWh5UEZpV0NvM1Yydm1JVW1BYmxPWlVZeUhrSmNZN3V1T0FMTTNwVVdx?=
 =?utf-8?B?WWlXN09mM1FCL2x1YkZpUnFVTUFCWHZyTzdZcDdoWldkai9WWDVvdlZLY2Ra?=
 =?utf-8?B?elZ2MDVVbjhBQ1l0TGFOSjVmQ3QrVy8xdWJBUkRyLzVsdWRHVUpXUUFnUXBV?=
 =?utf-8?Q?MLB212EmXwqy7XBf1cvb3+YWSDSUb3wTNrm4g7/?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8105867a-6404-4cc2-f6e4-08d8fab670c7
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 17:47:55.7059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Beg0zGEnMCq73HNm82LobgYNnYibO7SwhEItufrPt0DiEAXh9Umwl4XnXbSaQ5SQErkYnIgklwVaKGglCYXmA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1449
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/8/21 12:37 PM, Sean Christopherson wrote:
> On Thu, Apr 08, 2021, Tom Lendacky wrote:
>> On 4/8/21 12:10 PM, Sean Christopherson wrote:
>>> On Thu, Apr 08, 2021, Tom Lendacky wrote:
>>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>>> index 83e00e524513..7ac67615c070 100644
>>>> --- a/arch/x86/kvm/svm/sev.c
>>>> +++ b/arch/x86/kvm/svm/sev.c
>>>> @@ -2105,5 +2105,8 @@ void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
>>>>  	 * the guest will set the CS and RIP. Set SW_EXIT_INFO_2 to a
>>>>  	 * non-zero value.
>>>>  	 */
>>>> +	if (WARN_ON_ONCE(!svm->ghcb))
>>>
>>> Isn't this guest triggerable?  I.e. send a SIPI without doing the reset hold?
>>> If so, this should not WARN.
>>
>> Yes, it is a guest triggerable event. But a guest shouldn't be doing that,
>> so I thought adding the WARN_ON_ONCE() just to detect it wasn't bad.
>> Definitely wouldn't want a WARN_ON().
> 
> WARNs are intended only for host issues, e.g. a malicious guest shouldn't be
> able to crash the host when running with panic_on_warn.
> 

Ah, yeah, forgot about panic_on_warn. I can go back to the original patch
or do a pr_warn_once(), any pref?

Thanks,
Tom
