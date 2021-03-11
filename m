Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F27337F4E
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 21:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCKU5R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Mar 2021 15:57:17 -0500
Received: from mail-dm6nam10on2059.outbound.protection.outlook.com ([40.107.93.59]:2689
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230341AbhCKU5H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Mar 2021 15:57:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OoH98O/u3snHsB1iL9RvzM41chXhOMMG2K3/jn50V4VLP9FSqh4e4emVuGzrSgBpVmg3ppSIMYnVqg5oNE2mvarawGdBfiNaWYsDOdv1SPsYa4cd4xgNxJjui3YpIo28/r6z0leEu+PDfU10nfTLrIO5RXuZcNTf7Wp6XADeh1XF0Pq9D+0Z2VfzwG5HIJIFdof+8pcWbNOhmUZPRH9ZRv1QxnU2xVTCcbS75A08XfgwOs455rpiQC4PPM6T6BdnwbsDHw7kLZtbYjD6mwuX8JE5aRU/kuLYp9YHPCm78+HoZcpq8aVwt5VKql4OR/xTG3smUcqUK2tF5fgy+rSe6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2Lq3YgcRdlf6Auj3smQD3kIB5u+xb18mnrgrCsmtUI=;
 b=gK3liFOdzCQJHovaqelkz+K15n+2QKdvvNmDvxjNag5O2J0pvzWXx79vdt7OuNj78OhAwOBL2oh2K4eSg4qizJeRcxvAFmPHG6cQr7VS7rrbHjU0+7H/Pdx/gONOgWvSTvYO0V8AkV22YPMFb0aMrTm3kWtsaJxb5GEAJqI0u7nXQriq7YHDSYi3mJz0NrSkrdquxeGHh+cukZEYZEIabsVplUF9YAhPAbruq7KvxsejR/Pjl0pB5zWa9B9uXM0n3NE0MLbdj6tsNx74W/If7L1gjmUwvytRlXSRM5zOdi2chJVr74w5m+wclcG/LnZ4WgpkGPEJLv8TmpEAitt86w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l2Lq3YgcRdlf6Auj3smQD3kIB5u+xb18mnrgrCsmtUI=;
 b=Y/DHvPlY2B+ZR87h3a5autOeaWxR1cp+iDtP6XVFWpWQf+tg0Jwjdhea9roucbghAdORDrKzm8SXJzat9ycZGh+XQZxN7DBU+iDDGxEZnC6arMHUYkJdZckRqRPBCv5g++l5i6JGDuEl4vx5Ius40ZBUCk5Mm6FUqtc69UgStGc=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4477.namprd12.prod.outlook.com (2603:10b6:806:92::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Thu, 11 Mar
 2021 20:57:06 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::20cf:9ae4:26fb:47b7%7]) with mapi id 15.20.3912.030; Thu, 11 Mar 2021
 20:57:06 +0000
Subject: Re: [PATCH v6 00/12] SVM cleanup and INVPCID feature support
To:     Borislav Petkov <bp@alien8.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Makarand Sonare <makarandsonare@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <032386c6-4b4c-2d3f-0f6a-3d6350363b3c@amd.com>
 <CALMp9eTTBcdADUYizO-ADXUfkydVGqRm0CSQUO92UHNnfQ-qFw@mail.gmail.com>
 <0ebda5c6-097e-20bb-d695-f444761fbb79@amd.com>
 <0d8f6573-f7f6-d355-966a-9086a00ef56c@amd.com>
 <1451b13e-c67f-8948-64ff-5c01cfb47ea7@redhat.com>
 <3929a987-5d09-6a0c-5131-ff6ffe2ae425@amd.com>
 <7a7428f4-26b3-f704-d00b-16bcf399fd1b@amd.com>
 <78cc2dc7-a2ee-35ac-dd47-8f3f8b62f261@redhat.com>
 <d7c6211b-05d3-ec3f-111a-f69f09201681@amd.com>
 <20210311200755.GE5829@zn.tnic> <20210311203206.GF5829@zn.tnic>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <2ca37e61-08db-3e47-f2b9-8a7de60757e6@amd.com>
Date:   Thu, 11 Mar 2021 14:57:04 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210311203206.GF5829@zn.tnic>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0150.namprd13.prod.outlook.com
 (2603:10b6:806:27::35) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SA9PR13CA0150.namprd13.prod.outlook.com (2603:10b6:806:27::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.11 via Frontend Transport; Thu, 11 Mar 2021 20:57:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2b8f6fb3-73f6-4438-bc14-08d8e4d03a15
X-MS-TrafficTypeDiagnostic: SA0PR12MB4477:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4477CC0630230D77EFD103EC95909@SA0PR12MB4477.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TjP1O6rQP8JnSHK3p2gU6OBTs7HHJyZsDlH5kuEduMQxFhbbLTku68gH5lzlhb0CI8CW9Rg+85Lp/u+XkMKr4VRKQqODhM2miITuDdAr0GUAD4hc9inHQSsiRr8DKUmgafDMdJPmlWBk/JRrzCHv1Ws8M371Xt0PX8JqJTv7CkGV8e0SUQ2/ok2AyBfQ1T0IaLzxl89o0ZH2ZGIz7vtNONA8UxM87TuPaUNIKssUJzdvt5g5E8mLxOOul0+Yxm4igumPGJFft9BFaRW6KF2plRh4S+AEbaxCUe0R0chbCkLyiWGkZnsv6g/pNNNvOzNdeaa/1+pKuI9Dd+wEzPUw3aRw8lr1H7LOk+iQ19FRutxrRw0OrwO1OLCdvNPAsHTFD8V/DlccbHwk7ykrrQAiSsZ9/9UENyAOi4amFh4TmR2ezuHECVxRawQjhtPNPt9L14EHFchZvJLKXEq1jtCIa0VO+TqBmbsm7tewJdvrxlv8OObfyTKhYowQNxOiaVRDns0Nb0Vglnr2E7R0M2DRdR4uj1KrDVhinsYIux951VrQCPzgYE9X9gzfAADSMXgY6LGcNfWpHEi1VK4JBPZbeza8brctCjXUkgM/EBKcs3Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(5660300002)(4326008)(316002)(16526019)(186003)(54906003)(26005)(66946007)(86362001)(478600001)(66556008)(6916009)(66476007)(31696002)(8936002)(6486002)(52116002)(8676002)(53546011)(16576012)(2616005)(956004)(2906002)(83380400001)(7416002)(31686004)(44832011)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?aWV5VUlhTW5ZN3R5SFZRdDBYRW40d254M3F0Yko5SEFWbkE5QnUxa0Fmd2Y0?=
 =?utf-8?B?Ykg1YVpaMitIazV6TXdadE1VSWNubXBLRTAyNUhCaGZvM1Q3M3cvYTczSEM0?=
 =?utf-8?B?ZFd3OHBDZGY3VTE5bXh6ZTlENko0RytQN2JwaWdhNUJrSURwR0N4UVB3SXlX?=
 =?utf-8?B?NVQxU1ZpMlUvMmdtZm1INk11TC91Q002cVprSnJzTGwyRFc1ODhKY2lSdUJj?=
 =?utf-8?B?dFE5M09iT1FialRZWW5yVGZZQ3dzcUEwZkFWVitpU0dqdHRaWXQrU05FQkZ5?=
 =?utf-8?B?Z0N2TTFBWnRncGZXYTFvS1pTcXNMUWl2RDlRVWdCWHBxbGU5Y1k4MWNNYVlO?=
 =?utf-8?B?WkJodElNTGtRSHdDM3lUa1hma2N3K0w0Wm8ydmZWVzJtVzZLUFhpWDZJVGNu?=
 =?utf-8?B?M3NuenBkQnZjQmwvY0Z4Q1YvL3I2c0plaDFGQmRJTVk0clFoUm5ROWZMSUEv?=
 =?utf-8?B?YXpFZkRtLzhjM1dKcGszOVZGOUNkU0pCYlQzMEVIQXcyTmpabHN0NG5YZnlE?=
 =?utf-8?B?dndSZC9CdC8wUitlejkwOCtlUVNlNGFKZnppbDgzSkV6MXBXR0JTMnhkc0wz?=
 =?utf-8?B?Q0FxK2Q3QnlKN1J4MkluVmxtdUI4SjJPcUR6UkluUW5Bc29yZFUwajFEZEVH?=
 =?utf-8?B?aUp2MGFjNjZhU01pTWRaMzVCRjJHdGNQdzBZcEp1bi9LOWtBbUhIWlB4SndP?=
 =?utf-8?B?eTBUWUE3cGNSR3VOaGlJR3RBWHJzVTNCQWhaV2pWZWpYV2JEUS92YXJsbnVh?=
 =?utf-8?B?VmtOdFh4Yit6WlRIa2ZhRFpHbFAzTUlJZWV1bmhTbG1naDZsK05maUdBY0xn?=
 =?utf-8?B?Q3Q5VTdCVWhyME91aFN5eGZ6YmhsQTNsRk5ZR0d6TTBvb2w2SzBoelU0UWRO?=
 =?utf-8?B?S0x6YkxmR0R1cGlVMUhKb3JVNkkvQVlITDRLRjBhaWYzYlpwVG91NTRjZ3Jt?=
 =?utf-8?B?VEFsWEFEeGV5RWVzQ2x4NzBxbTk1dTdLNWRFYmNrT3FjaW1xOVNVT1RKcFBQ?=
 =?utf-8?B?UVpQREFKdG4xTnZlc1NDdnhFci8yejdKTGg3d01mWHdJRWlidlcrVzhYR1FN?=
 =?utf-8?B?QUtXNVo0QVd3M3ZSako4dG9EUkErNEFpOS9uQUVGMkdqNzVidThvUzFJL3pX?=
 =?utf-8?B?a0lsNUVqZ21QRzd1NXJ6bTkzcU1ibmZSTllETi95MTVhUXprUnhQVlVpYkRq?=
 =?utf-8?B?WFZ1dGdRdUw5VGRCbUd2bFE0b0lGR3VoRGNHbm5laG50ZEMvZ2RibVMvazNi?=
 =?utf-8?B?WlVCMmtrSHhCL2dvQXpzY1h2cWthblJWSUx0WmdEM3FMRThJcG9kRDBYcklW?=
 =?utf-8?B?bGNsTHVoT0RtWDJUTGNxaHJ0SUJEdEJncktIdFVFdHY1cXFXdVJ6UXZBaWVV?=
 =?utf-8?B?MGFzekh6ZlFYV25VSGVoV01wanVhMDcxWTg4dEFoM2swU2pCZ1hXRjFGeUgz?=
 =?utf-8?B?VkxRc1lwU2lIby9BY2pOdlZPbi8welFaWlpmVTBUOUc2TFNtM0J3SFV1U2F3?=
 =?utf-8?B?TmxHakxKSEN0ekd0VVFvR2c4YUkxWlA4eFVYSmNEUGg4akxKbEdYZE9tdWlt?=
 =?utf-8?B?S015Sm1kU1hiOUVFa0hReUdkZ0owVjdZWTlYNGd1Qis5dXZwUjRUYW5HWUZx?=
 =?utf-8?B?RmJNRW8wMWh2cXhac05hWVBQcDlXTTVTT0N4SjEyRHpLNTlmeEcyRVBTamxj?=
 =?utf-8?B?SGlZZlB2NFFxdFZQYStxZHBLY3dCeHp6bzAxMXIzbi9vYnNzOEZaQ3BGREdP?=
 =?utf-8?Q?bDpsy7gDm3hNu6sPGZxw3aCD1OZn9J6zCs4TrWF?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b8f6fb3-73f6-4438-bc14-08d8e4d03a15
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2021 20:57:05.8994
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PmE8SckORG2bHAI+wdCbCi8rssGUu88RJNh3No76ya47V6XAFuVErAY+1nCmECsN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4477
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/11/21 2:32 PM, Borislav Petkov wrote:
> On Thu, Mar 11, 2021 at 09:07:55PM +0100, Borislav Petkov wrote:
>> On Wed, Mar 10, 2021 at 07:21:23PM -0600, Babu Moger wrote:
>>> # git bisect good
>>> 59094faf3f618b2d2b2a45acb916437d611cede6 is the first bad commit
>>> commit 59094faf3f618b2d2b2a45acb916437d611cede6
>>> Author: Borislav Petkov <bp@suse.de>
>>> Date:   Mon Dec 25 13:57:16 2017 +0100
>>>
>>>     x86/kaiser: Move feature detection up
>>
>> What is the reproducer?
>>
>> Boot latest 4.9 stable kernel in a SEV guest? Can you send guest
>> .config?
>>
>> Upthread is talking about PCID, so I'm guessing host needs to be Zen3
>> with PCID. Anything else?
> 
> That oops points to:
> 
> [    1.237515] kernel BUG at /build/linux-dqnRSc/linux-4.9.228/arch/x86/kernel/alternative.c:709!
> 
> which is:
> 
>         local_flush_tlb();
>         sync_core();
>         /* Could also do a CLFLUSH here to speed up CPU recovery; but
>            that causes hangs on some VIA CPUs. */
>         for (i = 0; i < len; i++)
>                 BUG_ON(((char *)addr)[i] != ((char *)opcode)[i]);	<---
>         local_irq_restore(flags);
>         return addr;
> 
> in text_poke() which basically says that the patching verification
> fails. And you have a local_flush_tlb() before that. And with PCID maybe
> it is not flushing properly or whatnot.
> 
> And deep down in the TLB flushing code, it does:
> 
>         if (kaiser_enabled)
>                 kaiser_flush_tlb_on_return_to_user();
> 
> and that uses PCID...
> 
> Anyway, needs more info.

Boris,
 It is related PCID and INVPCID combination. Few more details.
 1. System comes up fine with "noinvpid". So, it happens when invpcid is
enabled.
 2. Host is coming up fine. Problem is with the guest.
 3. Problem happens with Debian 9. Debian kernel version is 4.9.0-14.
 4. Debian 10 is fine.
 5. Upstream kernels are fine. Tried on v5.11 and it is working fine.
 6. Git bisect pointed to commit 47811c66356d875e76a6ca637a9d384779a659bb.

 Let me know if want me to try something else.
thanks
Babu


