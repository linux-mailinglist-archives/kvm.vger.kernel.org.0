Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 258232D4E30
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 23:41:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388836AbgLIWkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 17:40:43 -0500
Received: from mail-bn8nam08on2077.outbound.protection.outlook.com ([40.107.100.77]:55521
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388245AbgLIWk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Dec 2020 17:40:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GGqf2iBR3h4v7BqQXw+oEIFqBUApJx5SJkDz9mZ9BQwTJS6pGoyOqsoQY4RuCg+QvWiG3f3nV2I/uJIycz1v/O9Om1+4+bDcSPDLN1GM3j1iLO9ESFifd/hIdHF+D8Anv2gajisaN7j5F70p/3ravwJbxi/9hwp0Tp0U2lDxIdjJu/NsIfFXtZzspNsuoEQlegTWzIwyLreEl1fUgyp8YJxD+ka+owoHAhygn/xqUjUdtOkhb6KzQ+1G+Cegg67Qfdft5kKJBzZJzObPlQHSF4kNk/lUxLmERiN6xTyj+dl8cWynzzEw9mUk5qlcSbc6lChym8wSx0Plt/J/Uy7HsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbUIlLsBpkYZFIdIIk74PxMOFo7yO6GRaTGg+jCmNng=;
 b=OftboyQzf00uKmB3bx+NzcR2HoZlNDJfiY4ZZFwu++sWJfBNcZ6xq34jE5pOW3lEKwalu/A3ioS/wl6oa+zu5IgJ7kxhlnJ4xp4v38n/j6zr/GuHjNEjrkUHhp7pGXVBEZXdeiBV+CoEjoIpjmrEiUljGaW01AlSgqqU1Y95vAXEXf/BkIEvY6O7Uhri383wyl4oyewxeICufRkBesTHsqNUIHfOEqVxHwrmUse+/ORvqKah4ouLvS5d1x7dKmtsZiNaX7iIKn41KNb+HG//8CpY1jUyWVKrgAfFU8lN3iIm/1U47hKjnDUPpSgVXGsusNepRwvrsjZJKL0VgiysLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qbUIlLsBpkYZFIdIIk74PxMOFo7yO6GRaTGg+jCmNng=;
 b=fWzEYOzyDzPYC8SrH6LpyOb7P3A4lla8s5DF44F622PH6rc1kuwQvprZSYHATUf7xrZ6M4Mrm3HcafaG3064cqVc70pzhWNKpxW05KqJ54j59FZ/weELIwClkmSjrrVdg2vYaucHTlx7nlVF+HOuI3ObOYCuJwtVypFu9Ny8AmQ=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2591.namprd12.prod.outlook.com (2603:10b6:802:30::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.23; Wed, 9 Dec
 2020 22:39:35 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::d877:baf6:9425:ece%3]) with mapi id 15.20.3654.012; Wed, 9 Dec 2020
 22:39:35 +0000
Subject: Re: [PATCH 1/2] x86/cpufeatures: Add the Virtual SPEC_CTRL feature
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        kyung.min.park@intel.com, LKML <linux-kernel@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        "H . Peter Anvin" <hpa@zytor.com>, mgross@linux.intel.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kim.phillips@amd.com,
        wei.huang2@amd.com
References: <160738054169.28590.5171339079028237631.stgit@bmoger-ubuntu>
 <160738067105.28590.10158084163761735153.stgit@bmoger-ubuntu>
 <CALMp9eTk6B2832EN8EhL51m8UqmHLTfeOjdKs8TvFSSAUxGk2Q@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <2e929c9a-9da9-e7da-9fd4-8e0ea2163a19@amd.com>
Date:   Wed, 9 Dec 2020 16:39:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eTk6B2832EN8EhL51m8UqmHLTfeOjdKs8TvFSSAUxGk2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR07CA0027.namprd07.prod.outlook.com
 (2603:10b6:610:20::40) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by CH2PR07CA0027.namprd07.prod.outlook.com (2603:10b6:610:20::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Wed, 9 Dec 2020 22:39:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8575c9d5-007e-4061-eac2-08d89c934e12
X-MS-TrafficTypeDiagnostic: SN1PR12MB2591:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB259187778B8777D8317264CD95CC0@SN1PR12MB2591.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cEWEnFXotWmvZYadkauTxxI522IJ6Svy0moxToL1cZBp2Oxn1FpcDVsTaKzzxGwg+PBTIM0ilw8AE6vFrt0brKRyrSFDeADyR9ip9xnh66ogAGF9TNqypE9rAUbNW4iF51bWPwaqJkWpMCar7nuHPPPYYz/nOXSF2t9W0cAQWZZ1v8pb4z7BFMWe1K8QYboK5Fu79PJYUeafrsyLfo2DwU2rXdb2yNr1krFFZz9F2N8kCrZ8SsO63bJYzD8GePKwnpr06q72GwBOJh8lDo7HgeS1E0/UPldUYSafF2SDbMGIXvgNbZgJZJtAxbXSSCc2N96cmU4uoywNppKKf4NnLTpwdbB3VG/OlMvQDWXVobDz2dRya+4Z82JrfZ9EwGsoyUKutxLkbV1ZOoRDaU8PBYbczHuVxB6ElB3B3f//HRr798qNUIL6Vy8hXa7Omo5R
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(376002)(366004)(8936002)(16526019)(26005)(52116002)(4326008)(53546011)(7416002)(34490700003)(2906002)(186003)(8676002)(54906003)(66556008)(16576012)(66476007)(44832011)(956004)(6916009)(66946007)(5660300002)(2616005)(31696002)(86362001)(6486002)(508600001)(31686004)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dlovcnBYY1kvblFHZ2ZuT2pwNHVOM1BSU3g4cmRjaWk2MEt2NzhQRmwzVEMz?=
 =?utf-8?B?NHpmN2ZWM2YyT1RJQ3dROVdyVk11eDZMME1oZkN6L3lKZUFuMVl4OHVtQVN1?=
 =?utf-8?B?bXo3eTZ3TTVCZ1JEYTVsbXYrSGszTHcvT0hxQTNhQTZnalAvek9YeWFuaGth?=
 =?utf-8?B?TW9CWDBCQkg4M3Ivd2ptcjBadXBQMFRiQUdLRjBKQUNCNVFuVnFhMGR1dis1?=
 =?utf-8?B?TXIwTVNaU2RvZmlwZXdOUlhpQzhRZDYwNTYvekl3Rm5haEFzRVFxdThlVkhU?=
 =?utf-8?B?Mmkxak50N3RNNGtVK01WTmtGMGxycHljbmRBUTN0bmRHWFZLdzVrWGQxenY5?=
 =?utf-8?B?M09TRnVKclBQZHBJR1h6UjVMVHY1UGtIWWVkSitqeDdFUXZZd1diSkpPREFZ?=
 =?utf-8?B?VVdpKzFyMHpGWjIyaXZaOUNVRTlnUm55NTNGT255MHNLRDdyV2N0L3JzTU1j?=
 =?utf-8?B?VmVEYkcva3FxcTBrUFNoYzFwTThvRmx2YnJBWU9xYWZHRWVmUld6OWxuTTBR?=
 =?utf-8?B?SkFiakZvRDQvTHdvbE9SWW5nb04vK3NaQkNXWi9GT3M3NUlCSUZGYVg4ZFNU?=
 =?utf-8?B?dzRwL2IzWkhxWjhsSUZWbFk3VTJubWd5Q2RqWjduNExteDFMYngyMnJmRXZa?=
 =?utf-8?B?bEZYa1Z3ZnMyR2lKcEtHbitRajY2TC83cDhFU2M0c0grOWh0VktTZFREbEly?=
 =?utf-8?B?QUROdTg1Qlh6NXlhYWpPZiswRUlKZ28yTE5uOXhtQ1l0K2FobThPVUs3SklN?=
 =?utf-8?B?MlRxYzQ2bVhWcEVQZEJhR0MyODFQNWQxSlhoSG9jcHJzankxRytnbHpjQk1S?=
 =?utf-8?B?RjZWejJOTWJBM3lxQ1daV1JXUGZJTVlmV040a0prTDJ3b205TFNMZE8rSHBr?=
 =?utf-8?B?cERYMmVZc2IzY05YQmdkaEJrK2tjek9YeXpEcXdVWmVoK2lIVC9EUEFUZ0xq?=
 =?utf-8?B?amllWXRNNGhaR0NwdHIyUkJFRzdIMWg2N0c4MDgvU1BkYWt0MHFaSklHWERn?=
 =?utf-8?B?WXc0QUFQV0N1L2xKT3NPZ2RoSzFUOE5HRVVXcHlvdTNTVjZ5ZzZGS2djdjlN?=
 =?utf-8?B?ZnJibFoyZE4zRHJOUkFLbDdEQXFPVmkyVnFOU2xscHBLU1NqaXBMclhlVmxa?=
 =?utf-8?B?ZGZCcUhMMnorb1BYNGpUU2RJSmphazIwWEx1OHJOd0tEWDRNbStYbHNwMU9H?=
 =?utf-8?B?MkFzTFpWQ2JaQ0NCS3hRMmNjM0NwVnZiQjZMVGxOenRmQVFUNFpHSnE1REZD?=
 =?utf-8?B?Ym1OWlpyaHdHRHY4YUp4V29wN09sU2JPd1FTSG9UYzNKZkpSZ2tadWtPZGNa?=
 =?utf-8?Q?mTIgwFvWCcffQCKGImWfpcH5eT5oorwACA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 22:39:35.5204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 8575c9d5-007e-4061-eac2-08d89c934e12
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIuAJg2NMPtcFCkREflAsZAl2yJWpOeylXDd5adnR4a1CtedH0dbjrAmJARFBq+o
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2591
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/7/20 5:22 PM, Jim Mattson wrote:
> On Mon, Dec 7, 2020 at 2:38 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>> Newer AMD processors have a feature to virtualize the use of the SPEC_CTRL
>> MSR. This feature is identified via CPUID 0x8000000A_EDX[20]. When present,
>> the SPEC_CTRL MSR is automatically virtualized and no longer requires
>> hypervisor intervention.
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>> ---
>>  arch/x86/include/asm/cpufeatures.h |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>> index dad350d42ecf..d649ac5ed7c7 100644
>> --- a/arch/x86/include/asm/cpufeatures.h
>> +++ b/arch/x86/include/asm/cpufeatures.h
>> @@ -335,6 +335,7 @@
>>  #define X86_FEATURE_AVIC               (15*32+13) /* Virtual Interrupt Controller */
>>  #define X86_FEATURE_V_VMSAVE_VMLOAD    (15*32+15) /* Virtual VMSAVE VMLOAD */
>>  #define X86_FEATURE_VGIF               (15*32+16) /* Virtual GIF */
>> +#define X86_FEATURE_V_SPEC_CTRL                (15*32+20) /* Virtual SPEC_CTRL */
> 
> Shouldn't this bit be reported by KVM_GET_SUPPORTED_CPUID when it's
> enumerated on the host?

Jim, I am not sure if this needs to be reported by
KVM_GET_SUPPORTED_CPUID. I dont see V_VMSAVE_VMLOAD or VGIF being reported
via KVM_GET_SUPPORTED_CPUID. Do you see the need for that?


>>  /* Intel-defined CPU features, CPUID level 0x00000007:0 (ECX), word 16 */
>>  #define X86_FEATURE_AVX512VBMI         (16*32+ 1) /* AVX512 Vector Bit Manipulation instructions*/
>>
