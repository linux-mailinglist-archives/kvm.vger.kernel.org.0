Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FA52FE03E
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 04:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbhAUDxu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 22:53:50 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:47935
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730968AbhAUDK6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jan 2021 22:10:58 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jvRyzb9Nb07mLqStYD/KJBtNS7hOdB+EjO7bfwNhAwlZrM+6QbawWhfM9ZUB31cm4sGdOnyG5tetHpcu64uz0hSkMn0y3moQ429sE0Es7rKpT97IA+dgn2B0jvWu+clryvMGlVHnErL2kK7d6lLvdz9Z4FUnT2MpQmQMuEe+FjSYifv+7aQhPj1I1FUdFwwTVfnDKle3Wb2h0jC68ps/A2YtSmkenCtdNu1JR7MHY6leOmt+gAoCu+tQzkE6Qp7QuIVD95qPhELzAXZ4Wu9mqGpcISOHZAWM59AEghrg5x8gVZQ0SVLcV7/Jzr3NoBZOxXnBjIImeqtF+OXEEmaA6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLOBEt9D1gwEnMlLPsv68tpGX8eDUHIyWC/NOKQJyqg=;
 b=GbWOkILZE4NLoX0H/czNbmtfMDDrlSwgtgT8y/+EHGQHKMXLVB3uqFb864CvSwK45uybj4200bAfdHWoxOk8fVTFW4GGHubqKbOEGbmQ2Wp/rQsfwCVI1UDBOmGDM87GQWZZFDEMqLKIbPooCR7alfC0BnwAG+7WA9BVB+bSaqUcqam27u1RJXezYkAKGX83yWN0mhQQzfvDN21zZ5+0gbY2VazlVl1f92PlOHbW7C+EMSu+CicOU0oxOCWyL4AW/dsKWeL89LusHS4yGcLigXKZ4clFw/Bq6aw2tlzEVKz1hQU0zFDDecGnDMiu71T+IN001CjMGCY68lPbG9azHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLOBEt9D1gwEnMlLPsv68tpGX8eDUHIyWC/NOKQJyqg=;
 b=pmar9VmUAGfxYljRiY1vb5g2s7yPBcwgxjSPCoH5gZ9Mz59pGuq8D8mFaIzIWCpGRR3XGFXs7sDSHORxiNwz6BOYUcQqS+MttqvstcvZMrGCA1I+w+Bfd3+CNhsf7zg95vmXb/O0DIbJlseJ9T/2M68X/nOGGtlDHdoUY5rKFaE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4528.namprd12.prod.outlook.com (2603:10b6:806:9e::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11; Thu, 21 Jan
 2021 03:10:05 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3784.012; Thu, 21 Jan 2021
 03:10:05 +0000
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
From:   Babu Moger <babu.moger@amd.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <159985237526.11252.1516487214307300610.stgit@bmoger-ubuntu>
 <83a96ca9-0810-6c07-2e45-5aa2da9b1ab0@redhat.com>
 <5df9b517-448f-d631-2222-6e78d6395ed9@amd.com>
 <CALMp9eRDSW66+XvbHVF4ohL7XhThoPoT0BrB0TcS0cgk=dkcBg@mail.gmail.com>
 <bb2315e3-1c24-c5ae-3947-27c5169a9d47@amd.com>
 <CALMp9eQBY50kZT6WdM-D2gmUgDZmCYTn+kxcxk8EQTg=SygLKA@mail.gmail.com>
 <21ee28c6-f693-e7c0-6d83-92daa9a46880@amd.com>
Message-ID: <01cf2fd7-626e-c084-5a6a-1a53d111d9fa@amd.com>
Date:   Wed, 20 Jan 2021 21:10:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <21ee28c6-f693-e7c0-6d83-92daa9a46880@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0029.namprd04.prod.outlook.com
 (2603:10b6:803:2a::15) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0401CA0029.namprd04.prod.outlook.com (2603:10b6:803:2a::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 03:10:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df08facb-0351-4201-ad23-08d8bdba0cb4
X-MS-TrafficTypeDiagnostic: SA0PR12MB4528:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4528C869F148F95E840DE04595A19@SA0PR12MB4528.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2V9E1GM/kYE30/mPo63H5CofsRyu5QhTI4g1KSDJTLOPDV+8jC6OpAgG9FgROlKGDHqFvMcR4xZtgNKP/zEDz0P9RGVxMMLG//xTPTOpxHCPkcBxv1OI0tg6chOwctWCVlMjfG2FF9kMDabVv+1cUh7NcdpaTl+Oyfz/EdgM/CUEPq8TrGsC6LTyLWUMMvEmYJJm5qz094LUQVxzclqvOrX7V1jOXpikMFVokxV7iKdHpUNdVc5+wCvRwLzLz2qAesKYxCSYUkLihy+IYViOuIVDRG3GI4fq1lVqczTpJ9QDOnVegJXM/n0q8Mt45ygwfpPKHoneDNOzAOI44uvUGW6si4x6D9JLuXlW7sPyd9OoiQlJHUDBBqHCIizYY0Gmn3GDuzyVSBsfVcZfGjBfYjAnStPwrdGk0t+3pSVjLgDJartum4goeGqi8pd2+VUAHpPKqnS8JuNs20/AxdPFvmoGGVa7MEL4p0AAtnUX5xlrlk+o6PTXWfrNByu97yfhHzLyl4fqQFOxYi+Xm4Rz1oOYzhomJA5hTGXwTIcU6G5s+qc6F9l9T29kD5n/nyeS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(31696002)(6486002)(54906003)(6916009)(7416002)(316002)(2906002)(52116002)(16576012)(5660300002)(478600001)(4326008)(31686004)(8676002)(45080400002)(966005)(44832011)(956004)(66946007)(66556008)(186003)(36756003)(8936002)(53546011)(66476007)(86362001)(16526019)(26005)(83380400001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZE9Ua2NWdWpmRXd5WjJwV3p2K3AzS2tJdGgreEZWM1hpNnBsRS9JcWFWUVpX?=
 =?utf-8?B?RkhRcnFwT0dFUWVKNU92eDQ5KzYxY0J5SmJlbnh5UVJmOFZFaFVjM1pPWXZw?=
 =?utf-8?B?aDAwNk5pMllGdDVlU2dMUUY5Rk9wVnhDZTJkaThZMFE3elZ2UXdmSzRkb09O?=
 =?utf-8?B?MURFaUR1OHIxMTV5Ykx5OE5Bd25laG56OWt1N1BjOGFaODVIQ3dnVXFITkw1?=
 =?utf-8?B?ajBVTForVzZFYWM0UjI4TnNzODNmZWFtNWVpcDNIWS9YNlBqTTFyQzB4M252?=
 =?utf-8?B?aVdSd1RjcWlIamlDdTBhMlp6em51TytlSW1USHNIcnBFckdoRXc3U05lRHNP?=
 =?utf-8?B?eHRVMTkrZTRnS3V0VGFiSU1rRlpwTWhUZVMzQXdDMEoyV3JDbmNGMVNaYS9F?=
 =?utf-8?B?S3hMdmwra1hDeDZ6WUQrS0lJV2hyb2krT21Jd0RTazF4akVEQUhwY21zL0Fy?=
 =?utf-8?B?dCsyVVZPazZRVndKcytrandDNzVwdjdZR2NvNFhhVEFnYXNERnVka3NWL2Fu?=
 =?utf-8?B?YUdBYjhJK21WaS9oS0tmN2JJVlowQmh6a0ZObi9qNFNTRzJwQ3hxVUtwNVpC?=
 =?utf-8?B?TGVMKytBU3VndkZPZlh1MWp4SmJOY24wanVoWUJNMFBaNjdnWWpvVXJHTVJ0?=
 =?utf-8?B?REEraGVUM0swY0ZQcEJFMmpYcW9hek43V0w5LzJMQXVuZVo3cWFtdTBvUDNQ?=
 =?utf-8?B?N2tXQzBzUVNFSWZmbEN3RWY0UXRkQmR6aXE4VnNLRHBlY1VYVGw0c01qNElN?=
 =?utf-8?B?aStpbytsUUJreEdZTVRGZmptRmZrclJ2dGVxSGxQNXZCYWpPQUhNNVZjZmZ3?=
 =?utf-8?B?OUVkL0NGYmdoYXpjU0NPU0x1cGFZQ215d01hM2tZN2U0a09kREhScDJNYmkz?=
 =?utf-8?B?L0xIQVo5ZUppMURrenRFMXoyTHZQdkNGWTl0YXIzcktNc29zUUFkYkN6MC9G?=
 =?utf-8?B?ZzUzekF3M1V5WjNqUERKZUNpQ0RUVC9KVEJnT1dSK3crMUNnY1R1RXJibUU4?=
 =?utf-8?B?VGZUb1cvUE1kZG1ZZThFMHJtYjhSeEpadWhYdjE3SCt1MEUrRnJaNFpCczQ5?=
 =?utf-8?B?YlVHbjBIUTlyTzVNNXVidUFIL0d0ajB6SjViYW1FSXZWRE9Fdiszd3lUbUJt?=
 =?utf-8?B?blgyc21UeURJRmlJdllQWjVEbUdxMlU3bENEcC9ZYnE1QlJUaWhOOVhPMERs?=
 =?utf-8?B?OURFaHFuajNtU3gzUmE3KzhMNDRmUjBJVWlPck8vVXZheGdmWGhaS1A2UGtw?=
 =?utf-8?B?UGVTUFNzVnVTK1lDclcwWDhFSGQvd1AzRGdkMU1XdHpQVnM3K09KaVd5OFFV?=
 =?utf-8?Q?w1kqpIuxDVD6856AbKTkFNSqpe345QggLp?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df08facb-0351-4201-ad23-08d8bdba0cb4
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 03:10:05.2136
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQGXRcrWSDWalChPDVDYamUSYvBPwZYiJhcuV+7LWYoNEMoF3wPxqF6dpFfyXLQX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4528
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/20/21 3:45 PM, Babu Moger wrote:
> 
> 
> On 1/20/21 3:14 PM, Jim Mattson wrote:
>> On Tue, Jan 19, 2021 at 3:45 PM Babu Moger <babu.moger@amd.com> wrote:
>>>
>>>
>>>
>>> On 1/19/21 5:01 PM, Jim Mattson wrote:
>>>> On Mon, Sep 14, 2020 at 11:33 AM Babu Moger <babu.moger@amd.com> wrote:
>>>>
>>>>> Thanks Paolo. Tested Guest/nested guest/kvm units tests. Everything works
>>>>> as expected.
>>>>
>>>> Debian 9 does not like this patch set. As a kvm guest, it panics on a
>>>> Milan CPU unless booted with 'nopcid'. Gmail mangles long lines, so
>>>> please see the attached kernel log snippet. Debian 10 is fine, so I
>>>> assume this is a guest bug.
>>>>
>>>
>>> We had an issue with PCID feature earlier. This was showing only with SEV
>>> guests. It is resolved recently. Do you think it is not related that?
>>> Here are the patch set.
>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F160521930597.32054.4906933314022910996.stgit%40bmoger-ubuntu%2F&amp;data=04%7C01%7CBabu.Moger%40amd.com%7C562d8b8ea61c41a61fe608d8bda0ae3b%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637467845105800757%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=l%2FhF%2FlDAqFN10SzDQ1L05FH1joXrLiuMwHAibBGHOqw%3D&amp;reserved=0
>>
>> The Debian 9 release we tested is not an SEV guest.
> ok. I have not tested Debian 9 before. I will try now. Will let you know
> how it goes. thanks
> 

I have reproduced the issue locally. Will investigate. thanks
