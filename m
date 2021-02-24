Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03432324627
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 23:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234077AbhBXWSI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 17:18:08 -0500
Received: from mail-eopbgr750048.outbound.protection.outlook.com ([40.107.75.48]:64174
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233506AbhBXWSG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 17:18:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QYuuddhq6feCCeJXc9xFnVqgAgV2SZkzVxEPR2Uo9IV40L1R4eigFdIRcHJv1ongYRIfl3/MCZc5Maw04ijgi4O6DgOmBi8JgIcsTeEbHI3JmmpsaKoRNUKUqB0Q5AoTsE7NQ000SEYO4qtaNRX1d6l25YkOzPQJEfiGPkK3oQR/DsXsSD8Kc6snlEbdQDZ4eIFuyQA27duCQnUKh21W7eLUUBZk8kgaDHxiNyHEPZwMOIPm+oLm8aR3BIwcxJsl9vZkyyLCPJF3l/uN1NMn80LZfOWlf4WUnOU22Ohc6mq0NocPDZrx+RW5wUpuSKownqphitCzz4RbO+c1Sh0FXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83nVL9yuD1vAvtI181eubEGWASDmfxVc5Yj3KBTmIQU=;
 b=hiYdRZUGPZCGAFgfB8NseUb+B0BWdMQzOGVvlbk0sMD+LVcVWni/QmHW5nqnrrbCVV+BCMojmqGOZCFT/f/GgzQ0/HZ4XjkzlNw2Xf6OBji6gWu1gYQjHf28gb5gm6DW1d4L1yWdTKVulSZ3qL9puR73by1GI2Ku+Fd6twveRhXqs4jpVEo7P2pkvgesSuTHEaTmJ66FddINrj6y2DrJtyd0zAps82HWjf9TAXY33mVi4/nH+k1f9FwQWOeeR6plSNqn2Y+V6cA7X2JMCLqfLYriztMuHabs6fN5Z1Fg6faZ16JdvFZIsFKr544Esgm0ZdRf5sIq701QxIBTjvzYzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83nVL9yuD1vAvtI181eubEGWASDmfxVc5Yj3KBTmIQU=;
 b=dvATDrkKd/i37AWzY6sjO+YHapzOMGBMOgARR7WFiFJlq45pQrDt7tS/Yjo6c/LWxCTTnslyeZUKd5UF5tRmXdneC2SSO+3ZAc8iR3umH0tIIDZplP3JgiqahARvdpE3r17j2skF9qvM+iUeCQPOf0GAWzhw04BSbVSwaHPQbyE=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4350.namprd12.prod.outlook.com (2603:10b6:806:92::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Wed, 24 Feb
 2021 22:17:14 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3825.040; Wed, 24 Feb 2021
 22:17:14 +0000
Subject: RE: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
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
 <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
 <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
Date:   Wed, 24 Feb 2021 16:17:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR11CA0024.namprd11.prod.outlook.com
 (2603:10b6:806:6e::29) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SA9PR11CA0024.namprd11.prod.outlook.com (2603:10b6:806:6e::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Wed, 24 Feb 2021 22:17:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 955e52b5-118b-434d-78c8-08d8d911efbd
X-MS-TrafficTypeDiagnostic: SA0PR12MB4350:
X-MS-Exchange-MinimumUrlDomainAge: outlook.com#9687
X-Microsoft-Antispam-PRVS: <SA0PR12MB43505875A5901B873095120F959F9@SA0PR12MB4350.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p7l4Hn/ov0rLp0TGrtl44u0c7a8XljDuCmNqXTVSEw18LyAzQNzuCXr4q+hiS7F8Aexrrn6aH2shaz1VzNwI2Gf05pUGTiIsk/Pc0oG2xHTgY6Ze66ucnnLXJwmd6YjamFZ6HOr77vCDJVwWN04s0XLHrvqSbDTpVGoMZr0wF4yOFy+tmmDxrH3T3Yhw/u0F7HHZygnCNeCbbof9wKDgBImUKHj+u1wq1bK5JjYeIkznGPWZMzCMYor6jH+3r9KDXwUnyrA4kLvSgv88n6+HOmX3dJx0moLN11VgTP92XDRf30JMiIF7gzBrbdXzvqA1T19nDgKG6b39FNB4fRs99ZsTzyjji5Uuy/xBIOCjBhTP2+rk/h6hHl7wsmWayVZYPCwpm5P8C/uMD1XWPuF+PgE0xr+I/hhGZdm4meG/QomF8k2HDE3mcDJGCLTSM7+duZhFNw/X8eW9dj4HlJXq8smgvqo7H9311N5u0P1/U5tU0V2ks5pZuuT/9i8u801ciZ6nZiLHmVft1Uts6jMZDenBxVE41AfyPOappgbpMT9jl5CVwPbRIqq/AGLWZSdm9uPU8LwYKSZt3vp5G33ZJ+QUO6emjU3Xu2zQaDmSiw+DcynJbKqvvR9sRvnERzEF3DAYOhWLMgEGbaEMCFM+RSmWDCKzlds5PaLeWerSJuuH56xLe0mVcyIyC+5mDdaQ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(31686004)(966005)(45080400002)(478600001)(2906002)(8936002)(8676002)(83380400001)(52116002)(316002)(53546011)(6486002)(16576012)(86362001)(54906003)(7416002)(66946007)(5660300002)(4326008)(2616005)(956004)(16526019)(31696002)(186003)(26005)(6916009)(66476007)(36756003)(66556008)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?vo9qN+Mfh/8FsXNShcVuG6aJVoLhPznNfV12IvC0+5IDx4w+ARGtXQox?=
 =?Windows-1252?Q?qnGpRGX4gG7NQnbK60JIiofrfg5s84CFnfp8rmtbAhrcNMEcICgaQFGu?=
 =?Windows-1252?Q?BeHwAApevKfC1vIKGDoRAiNCD1Nv+9oo6rEPu3mF+vKlomA6VmaJ8bCo?=
 =?Windows-1252?Q?aR2RzggRlsyyR0QqV9x2XtuBgdTrPZamQxzxYP4v+2LUI2S4u9UFp2gq?=
 =?Windows-1252?Q?srBTOqzMkBeS8dCPErpNvlGkfRRhSuztx/h4SUIbWFFmw+g8aK7jPlNr?=
 =?Windows-1252?Q?j71CnQ1c/uzXhk0h7EixA0tljg+abicqBG00SV16GDTnMHDE3MJXoidt?=
 =?Windows-1252?Q?Te5w532uO+sud+HmL2xQpCPONQeZosbyFXvmZWCe5w3UgvfKvSIc0grI?=
 =?Windows-1252?Q?ppJFEvk0yy7k8zlG7t0+EVUqtG+KN4oH0ldq94RY7PbO8QMVvejphNXS?=
 =?Windows-1252?Q?HQIOPkTUXbbRYuqlu8KwLAg43VBhdw528D1bhm7QJ0O3bSW8ZBZTHuMB?=
 =?Windows-1252?Q?guBAIBJg1plTUG3gGcUjYeFx86SPq9ksln4M42xB0ytv50yTXC59cj59?=
 =?Windows-1252?Q?p+z3y+DFv0q1WpHJ8TACFgTh2XOgaXFUmQENvYbeiZ/HnYeRV3HZah9y?=
 =?Windows-1252?Q?6HPY16VZlfqCoANYEwJ/9xPGoztS17CTbdvpgo0rm8rQ7SfgF7EDFUTq?=
 =?Windows-1252?Q?1pzbm48qMpDFcL34zGvCt0a4WqxBjL7sIC56AJ+u0jnyd4JUvcqqTaAS?=
 =?Windows-1252?Q?3FxKbCI7610pIBNzFaoZdKp4ln7+9mhizzcs6XQh8NQMabgptU8ENImF?=
 =?Windows-1252?Q?a4MkJq5SZWqr2MRwQlnUdJWYxYwGlaWWoDBRcX1b8RPq8ZFpipB8shum?=
 =?Windows-1252?Q?s2omyXY+9kk2YSFqxfNiM3D6FHT+1arLfma+xFhI68gqblVpL5j+kjLw?=
 =?Windows-1252?Q?HPc5XyshdL0xMkMevThhd7ATcY3SLq6g+QnRMonaClWXYGPd0H0qKL+v?=
 =?Windows-1252?Q?ib0d+0W8oHxaJsHD535MHNHRaECHA+MItCWMq2e0yP4tdqKBTQU4Zrd0?=
 =?Windows-1252?Q?PZKnmwgkMN91T7JuJg6y1KXnEA0bMt4m6c7cOw+w4T1F4gkh77k2ZIEZ?=
 =?Windows-1252?Q?2fsuPKXF2+yH2DHB1DlpR+YmHuB3WX5DSm3l3+OYgzCk19yeIBkWBPOF?=
 =?Windows-1252?Q?ZWD8e+iuu4CGKPKIVByL8g3HMlGFE0AM/aPaUFcfkq/1J3JwySqql/tJ?=
 =?Windows-1252?Q?Ndljj6m1eEsJBvrqkEsvDblQMFajT+z4KTE3GEVkl6/vbCfzZOKVO9Dw?=
 =?Windows-1252?Q?Hx04/vfrP0AXA0LYWr6+vns7Q4szIHAWVK1NTRX1NO4NFSRUAkehq5Jp?=
 =?Windows-1252?Q?FMhjj5Rq/eplwR4AgdB3T9xy/3DRUymZrVX7kE6thdd6gkdRA3He9DTJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 955e52b5-118b-434d-78c8-08d8d911efbd
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2021 22:17:14.5191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IsZ6g+3cGzM26lJXP7nOA+pSi8dEVu8OPx/K03NObb7v3USNTNv5IICsm1cu/4bI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4350
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> -----Original Message-----
> From: Jim Mattson <jmattson@google.com>
> Sent: Tuesday, February 23, 2021 6:14 PM
> To: Moger, Babu <Babu.Moger@amd.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>; Vitaly Kuznetsov
> <vkuznets@redhat.com>; Wanpeng Li <wanpengli@tencent.com>; kvm list
> <kvm@vger.kernel.org>; Joerg Roedel <joro@8bytes.org>; the arch/x86
> maintainers <x86@kernel.org>; LKML <linux-kernel@vger.kernel.org>; Ingo
> Molnar <mingo@redhat.com>; Borislav Petkov <bp@alien8.de>; H . Peter Anvin
> <hpa@zytor.com>; Thomas Gleixner <tglx@linutronix.de>; Makarand Sonare
> <makarandsonare@google.com>; Sean Christopherson <seanjc@google.com>
> Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
> 
> Any updates? What should we be telling customers with Debian 9 guests? :-)

Found another problem with pcid feature om SVM. It is do with CR4 flags
reset during bootup. Problem was showing up with kexec loading on VM.
I am not sure if this is related to that. Will send the patch soon.

> 
> On Fri, Jan 22, 2021 at 5:52 PM Babu Moger <babu.moger@amd.com> wrote:
> >
> >
> >
> > On 1/21/21 5:51 PM, Babu Moger wrote:
> > >
> > >
> > > On 1/20/21 9:10 PM, Babu Moger wrote:
> > >>
> > >>
> > >> On 1/20/21 3:45 PM, Babu Moger wrote:
> > >>>
> > >>>
> > >>> On 1/20/21 3:14 PM, Jim Mattson wrote:
> > >>>> On Tue, Jan 19, 2021 at 3:45 PM Babu Moger <babu.moger@amd.com>
> wrote:
> > >>>>>
> > >>>>>
> > >>>>>
> > >>>>> On 1/19/21 5:01 PM, Jim Mattson wrote:
> > >>>>>> On Mon, Sep 14, 2020 at 11:33 AM Babu Moger
> <babu.moger@amd.com> wrote:
> > >>>>>>
> > >>>>>>> Thanks Paolo. Tested Guest/nested guest/kvm units tests.
> > >>>>>>> Everything works as expected.
> > >>>>>>
> > >>>>>> Debian 9 does not like this patch set. As a kvm guest, it
> > >>>>>> panics on a Milan CPU unless booted with 'nopcid'. Gmail
> > >>>>>> mangles long lines, so please see the attached kernel log
> > >>>>>> snippet. Debian 10 is fine, so I assume this is a guest bug.
> > >>>>>>
> > >>>>>
> > >>>>> We had an issue with PCID feature earlier. This was showing only
> > >>>>> with SEV guests. It is resolved recently. Do you think it is not related
> that?
> > >>>>> Here are the patch set.
> > >>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%
> > >>>>>
> 2Flore.kernel.org%2Fkvm%2F160521930597.32054.4906933314022910996
> > >>>>> .stgit%40bmoger-
> ubuntu%2F&amp;data=04%7C01%7Cbabu.moger%40amd.co
> > >>>>>
> m%7C9558672ca21c4f6c2d5308d8d85919dc%7C3dd8961fe4884e608e11a82d9
> > >>>>>
> 94e183d%7C0%7C0%7C637497224490455772%7CUnknown%7CTWFpbGZsb3d8
> eyJ
> > >>>>>
> WIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> > >>>>>
> 7C1000&amp;sdata=4QzTNHaYllwPd1U0kumq75dpwp7Rg0ZXsSQ631jMeqs%3D
> &
> > >>>>> amp;reserved=0
> > >>>>
> > >>>> The Debian 9 release we tested is not an SEV guest.
> > >>> ok. I have not tested Debian 9 before. I will try now. Will let
> > >>> you know how it goes. thanks
> > >>>
> > >>
> > >> I have reproduced the issue locally. Will investigate. thanks
> > >>
> > > Few updates.
> > > 1. Like Jim mentioned earlier, this appears to be guest kernel issue.
> > > Debian 9 runs the base kernel 4.9.0-14. Problem can be seen
> > > consistently with this kernel.
> > >
> > > 2. This guest kernel(4.9.0-14) does not like the new feature INVPCID.
> > >
> > > 3. System comes up fine when invpcid feature is disabled with the
> > > boot parameter "noinvpcid" and also with "nopcid". nopcid disables
> > > both pcid and invpcid.
> > >
> > > 4. Upgraded the guest kernel to v5.0 and system comes up fine.
> > >
> > > 5. Also system comes up fine with latest guest kernel 5.11.0-rc4.
> > >
> > > I did not bisect further yet.
> > > Babu
> > > Thanks
> >
> >
> > Some more update:
> >  System comes up fine with kernel v4.9(checked out on upstream tag v4.9).
> > So, I am assuming this is something specific to Debian 4.9.0-14 kernel.
> >
> > Note: I couldn't go back prior versions(v4.8 or earlier) due to
> > compile issues.
> > Thanks
> > Babu
> >
