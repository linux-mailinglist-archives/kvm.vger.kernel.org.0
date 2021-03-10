Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D433332A1
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 02:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231358AbhCJBE5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 20:04:57 -0500
Received: from mail-dm6nam11on2084.outbound.protection.outlook.com ([40.107.223.84]:62082
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229775AbhCJBE0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 20:04:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhlSSA3QncQBmmOXGLokZtYNjB7lAMRvE3rMA376UcsGIFB4cDxuPt1o/ZYvHn5nfR+4lHyjAanrPDRcKTGmqYVUqIZ1BcYeeW8U9bvl+EHoWVY7oMnrHzL3tvkPyoUml4zrj5Nik2ZmNSxqrbAlHYwDSEf+Vp2JIjpdL5eK0I+1xeSrh6YfM1L12s4Dzzy6kIu0OFa3ZBBeRleyClo7+9JMTvF0tHEyc/TeTewh4+48Pz+kkyRUNbDMfFPq5bjkKtHgDEKpCdIg3hAqM2jtf/4JCzVyG2GMrWLpByMiJjzweX1bU5/NKEjxdPZ9c3Qd5ZTTffkuJlgyuWsvhkQh0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCNjEJMKouoDjpSoUf0fqahuF8T1GUcYIn+9tVenw5Y=;
 b=ebNMXbpW/ftTlNBBKI12K/TBtEpCL1gElWHjAnqI6YrMEmfyL9Pzr6C6mqmSn7Sj7i0RtOlDB1PGiwYL9pVyLaFBHpflEkbP8wjeOMWbxbDC+AeQjetQwBTqj8GGvaNHxeBKEeIPppItMAMtSUfTv9G6Vyk3gmWl7b7TxaP5lPF7LvtAPArZogR1qRH6oueZgfsY9HJp0GB5PVLsh5h83Vl4Xllhwq1OLYk+atVHNiGYGd0GHS7vchplSOodVtWJpfGF9RaDAngWzpJ1qht0a6qB2dOmUtAcsBi85BmG8npsWbU5nSVlnRf4MD35j3S8p4gxFJl2ywhNzP/BkC3JNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MCNjEJMKouoDjpSoUf0fqahuF8T1GUcYIn+9tVenw5Y=;
 b=z27EX58jegRIOtX5EVXnLAyx9UhL7aFONd0OYUOgVRrdpnRkHFg0dKg4hxQKZSd1jpexZSC6fMlbi+BYk3/Y1rIWF2JbWLF6J5X/aBvEsRv+jSN32WFSepeU89pIYKQB7iQCVUa4kBktv9bkOHkIBOW/4NAxp7btDlYzVccT71k=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from MW2PR12MB2556.namprd12.prod.outlook.com (2603:10b6:907:a::11)
 by MWHPR12MB1150.namprd12.prod.outlook.com (2603:10b6:300:f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 01:04:23 +0000
Received: from MW2PR12MB2556.namprd12.prod.outlook.com
 ([fe80::cbc:a446:67a3:5092]) by MW2PR12MB2556.namprd12.prod.outlook.com
 ([fe80::cbc:a446:67a3:5092%6]) with mapi id 15.20.3912.028; Wed, 10 Mar 2021
 01:04:22 +0000
Subject: RE: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Babu Moger <babu.moger@amd.com>, Jim Mattson <jmattson@google.com>
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
 <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
 <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
 <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
Date:   Tue, 9 Mar 2021 19:04:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0201CA0020.namprd02.prod.outlook.com
 (2603:10b6:803:2b::30) To MW2PR12MB2556.namprd12.prod.outlook.com
 (2603:10b6:907:a::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0201CA0020.namprd02.prod.outlook.com (2603:10b6:803:2b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 01:04:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5e911f9-cb4a-4bb2-ed6e-08d8e3607103
X-MS-TrafficTypeDiagnostic: MWHPR12MB1150:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR12MB11509347C5AD0E177BD8C66195919@MWHPR12MB1150.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: grYuGiBFl8kEzF/Ryji2kx7Eop+RIJD2wPCYtTOH261nixF6hjyc+XSadt6EGBtQFL7z3Et5tL/UhYpI5JIS2M9ZAm2P+CsB90xEBo0h2ZzqtiabbU4ZbeaXgVPXXYKK9x13+sdLAQq9NNlzXKwwqQ5WlQTHfN4dOmDxeSoHMVS6mNzBdkzFJyQP52B2SSt7Mi0nn9JJC3tXn5sWghAwfQA7vVFYKUlMEqfNe7MikJWkXPYVDpw4+/CunfLFdJw0o0E8cNcX+K/4sqN9q5A4knlZK2lmZ1oNIeET5XEoCz7mwMG0JkRZ6GvSfOv0SjICLFkdnt8tCe6WatUiguNX6SO194/uGBkQB2J397RsEADzjpn0H3YzmX0g09zOel/P8QAO9qvvXqsNVS65ViFef2PhAtuDMZiRsCbkbm8AbvgCDnUksr1FhnSvcEbmWUv5VOnGZhSpRq11Rb1Tw3nDPaLRf0Z9PZPE5WvpNxDAHPnFOgrgVr/pG1XNiNyhx4iH/uPFYaBAt96L5JeQ5kpBXAUmUf52MwJUzwols1jOJGFODjUJsp0f0GqYJ4H2tqIr1/2HRPKjsQZGF4RD2uFxxspzETavVwS0Lo8Xyr9jsccNGLAiVqbQ+IEyDdji/QCM7i7QSsGoL0es94T59fAH8iy7be0zFXxQNHq23OoqSD2Wkm/Oi4WHEPcHZgQfsMuV
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2556.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39850400004)(136003)(376002)(396003)(31686004)(16576012)(44832011)(966005)(36756003)(66946007)(66476007)(31696002)(83380400001)(66556008)(316002)(186003)(86362001)(16526019)(54906003)(45080400002)(478600001)(26005)(110136005)(8936002)(7416002)(6486002)(4326008)(2616005)(52116002)(5660300002)(8676002)(956004)(2906002)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?pC2vJEUDPFA7Fr/hZvWlBHlV2+LuOn2uIinDCqHlz6NfIZl85ZzhihvN?=
 =?Windows-1252?Q?wm455c1eVtGsDeYuWC8FkLYLpHAzWGai3kXuX3vZjcar76agYz0ff6Pj?=
 =?Windows-1252?Q?K+BiGOI1O/LZY7xB0cJEM4CuRkQ2avwMsJvAnahs48MSZflTFYbpJivo?=
 =?Windows-1252?Q?oPC7W0C8u8wK42wMFAi5ebGF8M3BB0z2YF409EoQNBYjGi4mkqP4jE9y?=
 =?Windows-1252?Q?ulDo6cdSvd5wnVDGh9/dZLlkevmYQwb/Yw0fuiAydC+vQCFyGcyZ+7yQ?=
 =?Windows-1252?Q?qKMDYj01Sn100wR6HRxR/cwtahsUqAPAGQK3D2eL63Cyojyz2UNaVgv3?=
 =?Windows-1252?Q?yfY2aLQai4rGnl6Bdnnwja66n0q96RRNaRM1bxSaCQM9SRx/H7lYrqOe?=
 =?Windows-1252?Q?Jle67QgJtR/T9BuEZZjYfoj8fxwzKwBJMUrWi82zetv2e1X1P05AqqJV?=
 =?Windows-1252?Q?gX5vWTCXJUj4Qnwcg1cRfSg0b/xbr+AnZ7/rggArcbq+8oZYrhvRZnRa?=
 =?Windows-1252?Q?zaDsAKelgK56EHOE8vy59EHjL3Z8Ik0rgsTnMOVnxgyDgUPeoUaBLIcj?=
 =?Windows-1252?Q?GRvso5yVzvbRrsSnS0VRrk/dgiiGo6zzD79T37DFakFvSYd0wcnTbnIG?=
 =?Windows-1252?Q?f9sHCeuhX2sgSUUcBBhnHupki9RD8AIQ0wHY8bcg43h8V98u1iMrF3Yl?=
 =?Windows-1252?Q?D2eIObOmz0ZNQC+F0Xn868uSWqLWYZKisVOLjZkGzVziLS10fnTKnDeC?=
 =?Windows-1252?Q?K1k/EH4Ruuv4yTQCgZfnukOi+2U8mCFyKERv5rbVsFjoYkMz7c0/ZDe0?=
 =?Windows-1252?Q?bX3r2qgB2m7idthQ0jlWn5hsKKv1FDTZ6gtampoyc5nwwjAe1TSi/bd3?=
 =?Windows-1252?Q?f7MFJYNsMQso5aLAxBxCOXAHUQjbKiFR2tyH8nrrvrLWJcCfx7bEcQXp?=
 =?Windows-1252?Q?yFOlwQATabl0Cp9fI5XM6W1JuEv85Ch/G5BL9rOByfsvoUGY5+WUi8pK?=
 =?Windows-1252?Q?defbd6BqQnoWLjAEFyXlOGHVQz6fnVgd3zni5U2k0xufkmR9pU01wL9e?=
 =?Windows-1252?Q?gPVO6rurpstigujsKKZNy+PrTFGCmxL2VOD7hOqwsPuA4SumPpyFvLXZ?=
 =?Windows-1252?Q?IJ1WRZTQ2cEodXqfQj1/JpNFC+2FpejhBgULhAw9Zebatd24ijhDTUfN?=
 =?Windows-1252?Q?rIxpJeVrEjLguKsvXIcoG0rQ+Nb0vMjxvFhLr9LMrykclfFRT6RM4QrB?=
 =?Windows-1252?Q?f1utSjv+CxmyefD836sBLyL2nDc4HoEx9oD/f+oT3Ju//iac58+bo7NN?=
 =?Windows-1252?Q?lJZlzB3PLcg0fJER8/Ia4M4DJexEYUgCmr/GMjJvSO2dJWu+3KNW1H5+?=
 =?Windows-1252?Q?OPhUgsA8qYsybnK+3bbqyF5FfWMuoEDn/tTkdTOiS+trYXFMuEYRB6tv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5e911f9-cb4a-4bb2-ed6e-08d8e3607103
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2556.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 01:04:22.7682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /3VUQI/z7hGFck0hCL31BXzjZbcMWuSh94Uu1U/Vcbiz9BMVz3hdLZb/k9CtoVrk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1150
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Babu Moger <babu.moger@amd.com>
> Sent: Wednesday, February 24, 2021 4:17 PM
> To: Jim Mattson <jmattson@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; kvm list
> <kvm@vger.kernel.org>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> maintainers <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>; Ingo
> Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H . Peter
> Anvin <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>; Makarand
> Sonare <makarandsonare@google.com>; Sean Christopherson
> <seanjc@google.com>
> Subject: RE: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
> 
> 
> 
> > -----Original Message-----
> > From: Jim Mattson <jmattson@google.com>
> > Sent: Tuesday, February 23, 2021 6:14 PM
> > To: Moger, Babu <Babu.Moger@amd.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> > <vkuznets@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; kvm list
> > <kvm@vger.kernel.org>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> > maintainers <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>;
> > Ingo Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H .
> > Peter Anvin <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>;
> > Makarand Sonare <makarandsonare@google.com>; Sean Christopherson
> > <seanjc@google.com>
> > Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
> >
> > Any updates? What should we be telling customers with Debian 9 guests?
> > :-)
> 
> Found another problem with pcid feature om SVM. It is do with CR4 flags
> reset during bootup. Problem was showing up with kexec loading on VM.
> I am not sure if this is related to that. Will send the patch soon.

Tried to reproduce the problem on upstream kernel versions without any
success.  Tried v4.9-0 and v4.8-0. Both these upstream versions are
working fine. So "git bisect" on upstream is ruled out.

Debian kernel 4.10(tag 4.10~rc6-1~exp1) also works fine. It appears the
problem is on Debian 4.9 kernel. I am not sure how to run git bisect on
Debian kernel. Tried anyway. It is pointing to

47811c66356d875e76a6ca637a9d384779a659bb is the first bad commit
commit 47811c66356d875e76a6ca637a9d384779a659bb
Author: Ben Hutchings <benh@debian.org>
Date:   Mon Mar 8 01:17:32 2021 +0100

    Prepare to release linux (4.9.258-1).

It does not appear to be the right commit. I am out of ideas now.
hanks
Babu

> 
> >
> > On Fri, Jan 22, 2021 at 5:52 PM Babu Moger <babu.moger@amd.com>
> wrote:
> > >
> > >
> > >
> > > On 1/21/21 5:51 PM, Babu Moger wrote:
> > > >
> > > >
> > > > On 1/20/21 9:10 PM, Babu Moger wrote:
> > > >>
> > > >>
> > > >> On 1/20/21 3:45 PM, Babu Moger wrote:
> > > >>>
> > > >>>
> > > >>> On 1/20/21 3:14 PM, Jim Mattson wrote:
> > > >>>> On Tue, Jan 19, 2021 at 3:45 PM Babu Moger
> <babu.moger@amd.com>
> > wrote:
> > > >>>>>
> > > >>>>>
> > > >>>>>
> > > >>>>> On 1/19/21 5:01 PM, Jim Mattson wrote:
> > > >>>>>> On Mon, Sep 14, 2020 at 11:33 AM Babu Moger
> > <babu.moger@amd.com> wrote:
> > > >>>>>>
> > > >>>>>>> Thanks Paolo. Tested Guest/nested guest/kvm units tests.
> > > >>>>>>> Everything works as expected.
> > > >>>>>>
> > > >>>>>> Debian 9 does not like this patch set. As a kvm guest, it
> > > >>>>>> panics on a Milan CPU unless booted with 'nopcid'. Gmail
> > > >>>>>> mangles long lines, so please see the attached kernel log
> > > >>>>>> snippet. Debian 10 is fine, so I assume this is a guest bug.
> > > >>>>>>
> > > >>>>>
> > > >>>>> We had an issue with PCID feature earlier. This was showing
> > > >>>>> only with SEV guests. It is resolved recently. Do you think it
> > > >>>>> is not related
> > that?
> > > >>>>> Here are the patch set.
> > > >>>>>
> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2
> > > >>>>> F%25
> > > >>>>>
> > 2Flore.kernel.org%2Fkvm%2F160521930597.32054.4906933314022910996
> > > >>>>> .stgit%40bmoger-
> > ubuntu%2F&amp;data=04%7C01%7Cbabu.moger%40amd.co
> > > >>>>>
> >
> m%7C9558672ca21c4f6c2d5308d8d85919dc%7C3dd8961fe4884e608e11a82d9
> > > >>>>>
> >
> 94e183d%7C0%7C0%7C637497224490455772%7CUnknown%7CTWFpbGZsb3d
> 8
> > eyJ
> > > >>>>>
> >
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> > > >>>>>
> >
> 7C1000&amp;sdata=4QzTNHaYllwPd1U0kumq75dpwp7Rg0ZXsSQ631jMeqs%
> 3D
> > &
> > > >>>>> amp;reserved=0
> > > >>>>
> > > >>>> The Debian 9 release we tested is not an SEV guest.
> > > >>> ok. I have not tested Debian 9 before. I will try now. Will let
> > > >>> you know how it goes. thanks
> > > >>>
> > > >>
> > > >> I have reproduced the issue locally. Will investigate. thanks
> > > >>
> > > > Few updates.
> > > > 1. Like Jim mentioned earlier, this appears to be guest kernel issue.
> > > > Debian 9 runs the base kernel 4.9.0-14. Problem can be seen
> > > > consistently with this kernel.
> > > >
> > > > 2. This guest kernel(4.9.0-14) does not like the new feature INVPCID.
> > > >
> > > > 3. System comes up fine when invpcid feature is disabled with the
> > > > boot parameter "noinvpcid" and also with "nopcid". nopcid disables
> > > > both pcid and invpcid.
> > > >
> > > > 4. Upgraded the guest kernel to v5.0 and system comes up fine.
> > > >
> > > > 5. Also system comes up fine with latest guest kernel 5.11.0-rc4.
> > > >
> > > > I did not bisect further yet.
> > > > Babu
> > > > Thanks
> > >
> > >
> > > Some more update:
> > >  System comes up fine with kernel v4.9(checked out on upstream tag
> v4.9).
> > > So, I am assuming this is something specific to Debian 4.9.0-14 kernel.
> > >
> > > Note: I couldn't go back prior versions(v4.8 or earlier) due to
> > > compile issues.
> > > Thanks
> > > Babu
> > >
