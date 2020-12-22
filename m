Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C43062E0D24
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 17:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727317AbgLVQPe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 11:15:34 -0500
Received: from mail-eopbgr700054.outbound.protection.outlook.com ([40.107.70.54]:56513
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727040AbgLVQPd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Dec 2020 11:15:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PE2TEbTAljI7PknU7OuNdYIUBdEYDm5fN8c3BP2on9EQjWg7T9DPryypfZG1rh5bLw6dWpaUXP5RPqESU3iQxqXIr0QxWmGNDrwyV2S6J6lr9PTUuIc1jWbnBagxMKsuDkX4hGqkcGTSle3qGYm6OjoF8z95yvfGC0jbfueZl6eaFrscMdZINtNrmi7qDIUbPSKFwogR7zkDvxnx0DXQW4t050Hb0SyIafwhSg0NDNeoU9UV+rB6BuAzVcktMly0C58Oxci8Dil4AsgQDp/UD83IGDCmQpv/bsyMhboI/jstn2MuyIjFEebWAtNa3BvfzcAiczuu3bdStGtnrnVBqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4h89+PAemGRpFfPNz31gQ1zlrmXfOn+kJbczcYQlocw=;
 b=PfEAqgcEBEQ+4d0+XZi10MuE27Vl96P0uEQ0rO+1lTgt+3OIcVSvY9MvWrrJiyrLk7bA560Rj91Lgw1hSeexFvJZND8IE6/eqA8mM9aiA3hRRo8TNkz+enmOsGNvNxGRwSVdXR9EewptWKU0mfSzT8P3JlBt+GjU0E2Zg7y3fqugmTKW3aA+Xvf/cNG0N7PG7ycv05ML8kT8f/DbXUTY5r5S9sAhjauwqyotMT2Mi+0Jr5ebgrDmvLpveNXPeFnTXYP1TCQpam9+CSOgjxYkMQUGp0/kMW/47VwNB5nJIDh51LEqGd64Td7CUpqUrGUfQozIRa2imG0UqebRLwcJNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4h89+PAemGRpFfPNz31gQ1zlrmXfOn+kJbczcYQlocw=;
 b=En6vMrdlcDAOxAnwgkD4kYeAwC0C/BakQ7ThFxIJA4cI5pX28GHZV1GqG7j9HYs+s5tkpjByYLMgYh1PGMF99gWECV1e+wWaJvUIjzcfm0/iwmpY1o8dH5H3EYmmOpny6PbpB1gC7PArmZiDOQ7AD+zxDoE0CinSrwJbSYRDrco=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2383.namprd12.prod.outlook.com (2603:10b6:802:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27; Tue, 22 Dec
 2020 16:14:44 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 16:14:44 +0000
From:   Babu Moger <babu.moger@amd.com>
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
 <2e929c9a-9da9-e7da-9fd4-8e0ea2163a19@amd.com>
 <CALMp9eRzYoVqr0zm60+pkJbGF+t0ry8k7y=X=R1paDhUUPSVCw@mail.gmail.com>
Message-ID: <00fdc56a-5ac4-94a0-88b4-42e4cf46f083@amd.com>
Date:   Tue, 22 Dec 2020 10:14:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eRzYoVqr0zm60+pkJbGF+t0ry8k7y=X=R1paDhUUPSVCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0203.namprd13.prod.outlook.com
 (2603:10b6:806:26::28) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SA9PR13CA0203.namprd13.prod.outlook.com (2603:10b6:806:26::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.22 via Frontend Transport; Tue, 22 Dec 2020 16:14:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 96a1fd05-6071-477d-42d0-08d8a694b22d
X-MS-TrafficTypeDiagnostic: SN1PR12MB2383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2383D8561091ED871EC4273095DF0@SN1PR12MB2383.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jO7GqdvXEYlCHCpF1/1ivjjyrUshnOWUwSxKBnDK37Tp9IlSaw9PSyw9AR1wWrxpYlxVc/z2O1k2rUYe/RjTu2p2Y/vSXzNjlkjSOOl0kgTOATU2x64hPiZwkPsrA6ObmdzVoXmv3DKyrd4VFnaLjjg+ge/GEx33l3Men5LcQyXTNb0lMaQ5fBEP+hdfiPpal8bvI/LkPDIubfs2uvF9Sty5Zic8sunIM2plPWuoD1aPb/4EC54lSKVuuetNX6XZlmQySlMIW6LboX5CifE5PXj5wtvPODDdoj7+CPQ2x572EDdluEQMwK1XmjKXgj5huMDTVw7RCxZAKJaZRn6BHWU4F+UC7Dy5LAvY7ZhqtnOXAZrZ4pZjkZ6BIBAd2C1B5OrsafSvingzLXbPjdQjWnEB3wLKZFlKROz4EsdZ1ZrJsJNSk7rHdI4kyCup0PUWZyfzKo9KnZanCflSy69MTjxQfuUyye4P+dfZbU5suZI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(53546011)(7416002)(86362001)(31696002)(66556008)(66476007)(66946007)(4326008)(8936002)(6916009)(36756003)(316002)(16576012)(31686004)(54906003)(2906002)(52116002)(478600001)(6486002)(26005)(5660300002)(44832011)(186003)(16526019)(8676002)(2616005)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TG4vQ0hVc1hlaGtGWU1OMUJIdWh1QmprZCs5YnduTmpUTVdLZ3g2TlZla0w0?=
 =?utf-8?B?K3BMaGp0aWxmb2xEanRhdXFmZGpmcHd6K09BSmpvNlFpbUd1VkJuVnBjbjRP?=
 =?utf-8?B?bVBNNGQ2RDNOWSt1ZzNHUVc2VTRIK2ZBWWY4cnBPa1B3RU0xVHcvdS9jR1dL?=
 =?utf-8?B?L0Q0WmdYYVZueVJmUklGa0QzS0dTaTkwOG1EZy8yTkh4K0doa3BBWk54L3Nr?=
 =?utf-8?B?THdzZDMzdDJ5TlhYV3FhY3hxMDdjczYxOTVXWkR5UHF3K3R5UVhvQUg3RE8y?=
 =?utf-8?B?Y1o1aUlmUHp3OWRFamRzU3YzRCtrTkVLYk1ScitvTXorNmhoM2VudXBWQTZt?=
 =?utf-8?B?c2lEMU1COVV3czBqMXJycVFiZEdCNHRTaHJxMWF1cnRkL1VNWHc1bElvTE1l?=
 =?utf-8?B?Y2Z4TlRjS2FkOE9TRGp3aDlLVkxxWFBYU1NLOFk4TEtCVTdaRzhOblpKQjE2?=
 =?utf-8?B?aE0yTXgyT3JJNHM5N29pMjI3OXBpWnN1SjIzV3AzQlNiQjhVZkwxMVh4cDFO?=
 =?utf-8?B?dlRKL01hNXU0WmpWZWliNTB6SWJjQUx0Z016RncrZmR5WEhESVpWRmJjcUJN?=
 =?utf-8?B?UkpYQlRXeVdmd2xJaUQ3RkhLREFQc3lyTm9OeEZ1Y2xXQWxrUmxuVlc0WGpo?=
 =?utf-8?B?MWoxRTNWUFRMalVKQVNVaFo2R3pMMHJaa2p5OFBCeUo0VW9PMTdoWk43V011?=
 =?utf-8?B?RktEZ0hSdXRYK1JDcFhrK1hzVC9CWThyNlBFUlh5SHdpc3dnbGVpdjhZQkZK?=
 =?utf-8?B?UHY2S1FseTlzd0Y3NEJSUGpEL0orbEd5dVBBR3E0UW5EMGUwSUNPaS9YZE9p?=
 =?utf-8?B?T0RNaW5UaGQ3UEZSeS93bmJ1clV2b0duaEVFR200bkRQOFpyZW53WThDbXV3?=
 =?utf-8?B?ZzBoa2cxTWtFQUJOZVowZGlneHRZc0FMSjVka1lodHFkTnMwamFjZktHZS9G?=
 =?utf-8?B?aFYwVXE2bGE3UE5XMXJ3akVEOUVZVkhmNWsrbDBPaHhJVGVtNWtOTGdIbVdE?=
 =?utf-8?B?YTV3NHFIbm15UEtIS29Jay8vcGFjdzArSFlNM3dMNVVvMCt4cmRvc1piMkFj?=
 =?utf-8?B?SXl0Y0N2Um5Qb20rNDRjT3dyc0VVMUN0dHFZeW95Szl1MmUrTzlSZDRsU0V0?=
 =?utf-8?B?S0gzei83elhmbnVzejQvS0Rxcm4vQ1JmbDMrYlB6eW1HRmc4TWVzQUtLWXpp?=
 =?utf-8?B?STVibXJHZDBzanF2Q242MVd5ZEpVaUQ1ZUorM3ZpUml1WDFvdzBpQjloWU96?=
 =?utf-8?B?eHUzdXBYWU96bnRxcjZNZG5JSTNTOWthNmVOUzBpa2d0VWsyV2p1bUdJSkh3?=
 =?utf-8?Q?qCOluWEsHZ6EU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 16:14:44.5957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: 96a1fd05-6071-477d-42d0-08d8a694b22d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nKz8N6FruDGKnW0WAN08Di9LnMhGy9uPJZWdWJt2SdoUOu4g45lVROfVVfbbJwFk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2383
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/9/20 5:11 PM, Jim Mattson wrote:
> On Wed, Dec 9, 2020 at 2:39 PM Babu Moger <babu.moger@amd.com> wrote:
>>
>>
>>
>> On 12/7/20 5:22 PM, Jim Mattson wrote:
>>> On Mon, Dec 7, 2020 at 2:38 PM Babu Moger <babu.moger@amd.com> wrote:
>>>>
>>>> Newer AMD processors have a feature to virtualize the use of the SPEC_CTRL
>>>> MSR. This feature is identified via CPUID 0x8000000A_EDX[20]. When present,
>>>> the SPEC_CTRL MSR is automatically virtualized and no longer requires
>>>> hypervisor intervention.
>>>>
>>>> Signed-off-by: Babu Moger <babu.moger@amd.com>
>>>> ---
>>>>  arch/x86/include/asm/cpufeatures.h |    1 +
>>>>  1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
>>>> index dad350d42ecf..d649ac5ed7c7 100644
>>>> --- a/arch/x86/include/asm/cpufeatures.h
>>>> +++ b/arch/x86/include/asm/cpufeatures.h
>>>> @@ -335,6 +335,7 @@
>>>>  #define X86_FEATURE_AVIC               (15*32+13) /* Virtual Interrupt Controller */
>>>>  #define X86_FEATURE_V_VMSAVE_VMLOAD    (15*32+15) /* Virtual VMSAVE VMLOAD */
>>>>  #define X86_FEATURE_VGIF               (15*32+16) /* Virtual GIF */
>>>> +#define X86_FEATURE_V_SPEC_CTRL                (15*32+20) /* Virtual SPEC_CTRL */
>>>
>>> Shouldn't this bit be reported by KVM_GET_SUPPORTED_CPUID when it's
>>> enumerated on the host?
>>
>> Jim, I am not sure if this needs to be reported by
>> KVM_GET_SUPPORTED_CPUID. I dont see V_VMSAVE_VMLOAD or VGIF being reported
>> via KVM_GET_SUPPORTED_CPUID. Do you see the need for that?
> 
> Every little bit helps. No, it isn't *needed*. But then again, this
> entire patchset isn't *needed*, is it?
> 

Working on v2 of these patches. Saw this code comment(in
arch/x86/kvm/cpuid.c) on about exposing SVM features to the guest.


        /*
         * Hide all SVM features by default, SVM will set the cap bits for
         * features it emulates and/or exposes for L1.
         */
        kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);


Should we go ahead with the changes here?

Thanks
Babu
