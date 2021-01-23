Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBA5301221
	for <lists+kvm@lfdr.de>; Sat, 23 Jan 2021 02:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbhAWBxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jan 2021 20:53:16 -0500
Received: from mail-bn8nam11on2082.outbound.protection.outlook.com ([40.107.236.82]:54432
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726344AbhAWBxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jan 2021 20:53:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=efH2ZNXwYA/h3GALZVXUeSCg4JgU+AhRgv0cYusYlHtK4DYkda/LShs7tcUYUaT3Nabf/Ya8gUedjxyoKIJVgV9BkYQIQ6UMZu9GjytI8jG4n4xr3sWYH5lA+NFWbHv10DoMHUvbCtE5lbPUqVJQpCQFWCI98ikYeRHOd5Bm0dvXsP91Z3+jlttf4aN7GL49NS99pg+uyHPC6h2TSl/ohti11919TUKnSyEk+Kld6Zrq7Zhofo+/OP/QZbsk2LP+OpkXv015zbndEZSWpeZgATFluAauCR6y+FSUKOTNrH8EoC13GNOU0oOGtz8NHWZv+QwY65lFpP4AltRKNPTskg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sazqkuL4gUrvgj7DtcgEk1zGWZAcGq3jw/IK3utYTq4=;
 b=hepLoJSSHz8FayKFgyxi7VTHmUYNgx9eVZZcpoKxFurrkgSx0LRARd21q9I/NwxGLg2vB3pRMN8e8EHozTwSf8SwQm18VnsWbchlqCdTF3ISij6chr9GEbywRbs1YXem/8h2pScDs9R/bbwm8hYoSRPpW2lFxQopK4XqNt2qOOYn3lnweewuT2/ZEg/O+7Z5BGSkuMGoG/sPpNpWpwQv/WaSa4Iw8mJlg5UFuSMpBg3SasPx6zQYbn7s4N8m+zIW48az73H+1IUuj2sxoqzvtJfGja3dAnscaPziuh2nDDNduVbsPE3wICVCgEOLnl365cmBJWKk88rWp0v4sG9ZXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sazqkuL4gUrvgj7DtcgEk1zGWZAcGq3jw/IK3utYTq4=;
 b=AhnK+LywwK7YlNY80jFCU+m/k8pbR66lN+SodS7F8P2FRja7Nvq0opd73c8nh3dIzYIxnWC8YeZ5fnjLXcJuFZqRgY0hLAvtdlhj8tEmqskwJxzUd9OjaOyJ523+nMOKhXMGtgxaSYo4FBXvCMRDx6YFps0NmD9mBcaeHFZ0JqM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN6PR12MB2734.namprd12.prod.outlook.com (2603:10b6:805:76::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Sat, 23 Jan
 2021 01:52:18 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 01:52:18 +0000
From:   Babu Moger <babu.moger@amd.com>
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
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
 <01cf2fd7-626e-c084-5a6a-1a53d111d9fa@amd.com>
 <84f42bad-9fb0-8a76-7f9b-580898b634b9@amd.com>
Message-ID: <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
Date:   Fri, 22 Jan 2021 19:52:17 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <84f42bad-9fb0-8a76-7f9b-580898b634b9@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0017.namprd04.prod.outlook.com
 (2603:10b6:803:21::27) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0401CA0017.namprd04.prod.outlook.com (2603:10b6:803:21::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12 via Frontend Transport; Sat, 23 Jan 2021 01:52:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cf0f8d0b-3c3f-460a-e421-08d8bf4183f6
X-MS-TrafficTypeDiagnostic: SN6PR12MB2734:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2734F9ED066E2A51ED9A836995BF9@SN6PR12MB2734.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gq8ei85YjV4juDge5xHTb6f4DUDpm6mjJP++vuOL3DiEgPziGery7LRp46M3Z3hRG57/fcZGtRBCpdCFqZ+UjQaU4/kC4Jn2VqRdzo/Qt82hoDaKN2K6KghNvj0ixz4qGBCbwVKrZXVKJRvHYXxG84IbCf0VK+jRImFXrOzkfH3sB46DoZZwNnOIDSyHZZOOrggDint5Ocg1dK3CIAsRE76yIUqwXrkr3wR0nNEWdczqERptmlC8f12I1ekBvhcD2JTdoHm8nagn44HLrmxk4OZgntPrxNZCXw899aJbj10OS8k7PUPkuVUnRvAZ7XAj4UIbrFGq9StOnc1hq3lktbWRBb1aWNAWJpt8F8VEq/VJp1mG1SYe+A/j3mYnjtSpVEn4k9ZvTuv5Za7GCVv5sppLgue3hKaqvcHw4q3BZsJIzo8g6rtq62ihYOzNYzWX3y5rHJ4XecWqdB9rR6tv5zvOH1ZDxltSj84PzRehNwbnCQZNkQGD8Ka5B7c3MrXMhdp5kRwrgEIteTeIwPKs9xITU+Q8uIcN1fVgpsWGYZh5Q9qHjebl7T+USv3KwbDm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(956004)(53546011)(2616005)(44832011)(36756003)(83380400001)(16526019)(5660300002)(31686004)(7416002)(86362001)(186003)(31696002)(966005)(66946007)(8676002)(66556008)(52116002)(2906002)(66476007)(26005)(478600001)(6916009)(6486002)(45080400002)(54906003)(316002)(8936002)(4326008)(16576012)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bENMajE3TW9Jd0h0NUQ0TlhRdS84R3lVR0twUWZVSEpWcGlLbE5QOHZYbXZJ?=
 =?utf-8?B?V2ZqVWkxdVlDMXRQT2RTWmJLdzhwN2c3dmFBa3pITURoOU1oSUlLbDR2aEty?=
 =?utf-8?B?aTFCVjRwaVNuZE5DSHl0OUROVjY0Si8xUmFBVWp1RDlXaWRDdUNoWks4dk9a?=
 =?utf-8?B?SDAwOFkyQzRWVGxWZFpIWVN4dk5jelBwNGhMbm1XZnZVQTNEWHlXYlpjZk1z?=
 =?utf-8?B?d2JMVFduSEF5dUI4VTBKdlpleW5RaDRmU0dka1J4NjdhQzFmZ1pHV0c0cWxk?=
 =?utf-8?B?TlZqT1lidzVBV0VYRWVZSDRTdkFINzgvTGRTd1d4WGhVY3hIYUpZN0tDVkxt?=
 =?utf-8?B?VWtvblZwNEpMdzBLdHdGN1JzVWF0ajRkL3EyT1R0RXpCS1FBMHFydDM0dENZ?=
 =?utf-8?B?RmwrdkNDL3FtQzIxVWhPY3FqenpGbmtwWnd4MnNlQUZSeW9xcTZiZG5mdy9i?=
 =?utf-8?B?U3dQeDBTRjhaVEhtTS9YcjJUV2xkSlprVCtMUG1GcmlzYlV3RUtaeHk2S3dF?=
 =?utf-8?B?WDVvay9SZ2gyTnQxclMwaWxXSEFhQW5MMFBXOWpaaDY3bTM1bkxRT1A0Q0pk?=
 =?utf-8?B?ZkNmVFNzSW1zQThFSHQ4UTZ0cXAzSHE1VkJTbDJRYUpQcjRsbFdCT1V4bFY3?=
 =?utf-8?B?RkVpVGlJajJORTh3dSt1Yis5RzN1S3V1SnA4a3QwUkM1L09ORUQ4eXhxVWhk?=
 =?utf-8?B?dE80K296ODQ0dlBiTytuU0VnYVhub2tyNFJUVGNoWjZOczJmTlRCaEM2emFj?=
 =?utf-8?B?K1UxQU5JOVpJU2lNWjBjSkpWVDQ5MkxVSURreXhUUEo3SjZtaktvMW03R2ls?=
 =?utf-8?B?R0ozZThxVWUzMXd1bFVwQStleGhhL0NpNzZmTmxSTlZJQ1JWdS9vN1NxdC9B?=
 =?utf-8?B?RXh5TTlLOEJ0cXdZbHlCMDR5bUUzSVlMczhZU2RqMG1UUzgzb3VRSnBFVlFh?=
 =?utf-8?B?by90VHZ4V3V1ajRxRGJoTXBSemYxZWduNDVSZVNkYkduZTN5SVRoMksxcGY2?=
 =?utf-8?B?RU51cWRabHp1NnMra0ZzMUIzQzlaSkQxWkpxei8vRVpqblU4QW5vZ3NhN3Ay?=
 =?utf-8?B?KzViK0t5aWRlKzRwYkRaQ1FhN2ZLdnhIZUxySlhoWEMvYlg4Y3FwZEpMdXY4?=
 =?utf-8?B?M1lnRm9ZRVgyY2tTbkN3RGtDZk04RTlZcjVMT2xTMXBWMHU5WEVabWQ3SGlW?=
 =?utf-8?B?Q05pQjE3ZEduMTd0cU1FMkw3Zkhtc2t1NWdvT3BFVkE5QjJjMldnVi9nUERR?=
 =?utf-8?B?QU9XVUlWR20yVklDbU9RYmFTZFhtUFg4WlNvYXNKRyt0eUtwNXY3NW1lZmJW?=
 =?utf-8?Q?66OIrp5XyrAVtJBpdZ/UZKyjbEoT8WXyjK?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf0f8d0b-3c3f-460a-e421-08d8bf4183f6
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 01:52:18.5027
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: orKI0xj6FzYm62CAd07KdgyhNhhfsZ32FMcdTc9cYsHikujx7s3TN31LAfOeO7ub
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2734
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/21/21 5:51 PM, Babu Moger wrote:
> 
> 
> On 1/20/21 9:10 PM, Babu Moger wrote:
>>
>>
>> On 1/20/21 3:45 PM, Babu Moger wrote:
>>>
>>>
>>> On 1/20/21 3:14 PM, Jim Mattson wrote:
>>>> On Tue, Jan 19, 2021 at 3:45 PM Babu Moger <babu.moger@amd.com> wrote:
>>>>>
>>>>>
>>>>>
>>>>> On 1/19/21 5:01 PM, Jim Mattson wrote:
>>>>>> On Mon, Sep 14, 2020 at 11:33 AM Babu Moger <babu.moger@amd.com> wrote:
>>>>>>
>>>>>>> Thanks Paolo. Tested Guest/nested guest/kvm units tests. Everything works
>>>>>>> as expected.
>>>>>>
>>>>>> Debian 9 does not like this patch set. As a kvm guest, it panics on a
>>>>>> Milan CPU unless booted with 'nopcid'. Gmail mangles long lines, so
>>>>>> please see the attached kernel log snippet. Debian 10 is fine, so I
>>>>>> assume this is a guest bug.
>>>>>>
>>>>>
>>>>> We had an issue with PCID feature earlier. This was showing only with SEV
>>>>> guests. It is resolved recently. Do you think it is not related that?
>>>>> Here are the patch set.
>>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F160521930597.32054.4906933314022910996.stgit%40bmoger-ubuntu%2F&amp;data=04%7C01%7CBabu.Moger%40amd.com%7C3009e5f7f32b4dbd4aee08d8bdc045c9%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637467980841376327%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=%2Bva7em372XD7uaCrSy3UBH6a9n8xaTTXWCAlA3gJX78%3D&amp;reserved=0
>>>>
>>>> The Debian 9 release we tested is not an SEV guest.
>>> ok. I have not tested Debian 9 before. I will try now. Will let you know
>>> how it goes. thanks
>>>
>>
>> I have reproduced the issue locally. Will investigate. thanks
>>
> Few updates.
> 1. Like Jim mentioned earlier, this appears to be guest kernel issue.
> Debian 9 runs the base kernel 4.9.0-14. Problem can be seen consistently
> with this kernel.
> 
> 2. This guest kernel(4.9.0-14) does not like the new feature INVPCID.
> 
> 3. System comes up fine when invpcid feature is disabled with the boot
> parameter "noinvpcid" and also with "nopcid". nopcid disables both pcid
> and invpcid.
> 
> 4. Upgraded the guest kernel to v5.0 and system comes up fine.
> 
> 5. Also system comes up fine with latest guest kernel 5.11.0-rc4.
> 
> I did not bisect further yet.
> Babu
> Thanks


Some more update:
 System comes up fine with kernel v4.9(checked out on upstream tag v4.9).
So, I am assuming this is something specific to Debian 4.9.0-14 kernel.

Note: I couldn't go back prior versions(v4.8 or earlier) due to compile
issues.
Thanks
Babu

