Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286E52FF91D
	for <lists+kvm@lfdr.de>; Fri, 22 Jan 2021 00:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbhAUXwC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 18:52:02 -0500
Received: from mail-eopbgr770080.outbound.protection.outlook.com ([40.107.77.80]:15619
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726101AbhAUXwA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Jan 2021 18:52:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9D5WJD7lrzwcJ3nsG8l5VIbsRvhG6QuvEf9JikoHMtKA991ebTzVtOL//TS3ZXz7RGFhlJ7iku+mSAWAwf8jrX4RBaGcyvc4iRq8mI87Wk9DDenx++Ygl6ExN8VEX5PX7vIMxQ+sEVZ4lSrnDVCibXhR0vXOzD9spMCz4itkDpbV0Ez9tpQarmNzm+SXFdriuCRX8umTTCRQ6q6vdAuf7yoLpq3QfzM/vBVY3xShlOyuqu9Rn64bW/UJxxt6jr6TYIDqqgPW22fbnI8dl+I88Ejd9EU/sehqe4DrS9pynF4RIKPHK4Tj14HXLt6WrP64+u8z2RsRhFeyME9rIY+Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmA9YpvtupZtkEPZd2rBFOuvIyWskg0ueNR0jUVca/k=;
 b=cVgrxWDogD+UuyuxJv5bJT3je8afvIucKLPCs3HdOYCbhwF7uHs1f1sYhaBOWIPejvX/6PnBYmZyZDBsn2kYzPp+jR4dfnjzWsYlLY9qHH3kpLtc/vdb4+lF+jm6FfAeEWf1zjOJkGw/+Um6EplZA12Ej+7FsORYwpNz9oU2wvel3zhMUMAaaP+j1tARTRQDMNJQahlcqRs4SWZSUBCikrs8duaX7lfbVs8Xfc1C+TlU7sWWeetVWgodnRa0MevlycKYTCIHvDO2KksQAr6yOasE0VobX//UwO2Y5lrSMovFaUXQba9k3mc/50iN5OXoK/UzhekEnUsy7fke1RFidw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YmA9YpvtupZtkEPZd2rBFOuvIyWskg0ueNR0jUVca/k=;
 b=xbMiRgTaivmTAdWPbvxcU+hWr3sh6t7wcHlGwnAKPyby0M2gpjNUeBoDpePw3qNYGeyyLHZMWF8dQC/9wQg2G6slE6R46s8wx+daIxD5HX/m771JImGf+18JUA2rKAfzDekuQbebSb87gtsxNQ0rnpQ/7o4rLejikMTObucZT8k=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SA0PR12MB4480.namprd12.prod.outlook.com (2603:10b6:806:99::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 21 Jan
 2021 23:51:12 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3784.012; Thu, 21 Jan 2021
 23:51:12 +0000
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
 <01cf2fd7-626e-c084-5a6a-1a53d111d9fa@amd.com>
Message-ID: <84f42bad-9fb0-8a76-7f9b-580898b634b9@amd.com>
Date:   Thu, 21 Jan 2021 17:51:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <01cf2fd7-626e-c084-5a6a-1a53d111d9fa@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA9PR13CA0166.namprd13.prod.outlook.com
 (2603:10b6:806:28::21) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SA9PR13CA0166.namprd13.prod.outlook.com (2603:10b6:806:28::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.6 via Frontend Transport; Thu, 21 Jan 2021 23:51:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e34d9bdb-cd94-4182-ece5-08d8be676ec9
X-MS-TrafficTypeDiagnostic: SA0PR12MB4480:
X-Microsoft-Antispam-PRVS: <SA0PR12MB44800EA1ECDAC2091F13E67B95A19@SA0PR12MB4480.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wUit9FSvsCslGSUW8/KThApcaWuCHpYmLdd6Yy6gqqcgC08wy5qbupYYEGrWIzoMkxpCsHOskH5G7GyLnKZmhb9w75VJNTxqfjoeUwVI1gPeHDBtZHX8fPm1yJMXPXpHZQ0/glKijBQgqG03cZn+6G9vj3QQC+5FFmGbKdM8SKM65698t7XPoseLtfhU/79RPfSemKcfi5WS9d4tws/BnYHxHlKms9rTGiNEptaDa8sgcNvElnDR2rGiZwM2nk0aEtIbRBkIgWLPIvRZCETHO1Gk5JlxkWAMQH76eafV32xWa3W03iwjT9deuDN7qufYom5EcY4katXQLmUydtMGVlhRUSdRBENZVH4r3TtbSqX5f3reHt03/AwPEsscW/mpCEHhHcLLBSI509bSOhQMh4sjlRaP9Ex5wx20OttSbaMCFXIOdnyko3VDx7gf2Y+te6QmbsuCVVr09Pt3cZMPBVpCseW5/6v7rSsWG9/uQsKPkG9TpVjE2IV5oM+T+KxjZRHH1vcRWnBSuEJDwKi3NB9oqYfEtOlKy6XPF1hA8synNsFm31iRGe21fVKhwdNL49q01vOa/x3aaBMG8Nilgs5VZbcPqc8c71EGEbTRMKnGrVzLYs2YPfkPOysLXK2AnYiFn5U5mBaEw9kZiLi8O2Yyoro8Lfd69sBgEM0mB4IqSg1mxE3E2uZGgrNp6Hsd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(366004)(39860400002)(136003)(36756003)(6486002)(6916009)(31696002)(8936002)(4326008)(83380400001)(44832011)(956004)(86362001)(45080400002)(2616005)(478600001)(966005)(66946007)(2906002)(8676002)(31686004)(66476007)(5660300002)(26005)(52116002)(16526019)(316002)(7416002)(16576012)(66556008)(54906003)(186003)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dm8zSnd0aDRSalRYcGNXbzBsbzA2aVlKTnlDMDdSaWR3V0U1Y1dzM2lWeHVY?=
 =?utf-8?B?NDBYZkl2aGZUKzlPQWJna2NkMThPRjZHS1FsTUtWUjRwZXJwRWlNOTgwR0tw?=
 =?utf-8?B?R1lWeXpmTkhjM0JyeVQ3Zk5ORXhka1BEUnJaM0FBdTBWRGdOcFNoSVNtVkNY?=
 =?utf-8?B?dmJFcXpaN3ByNytNandRQkpSY041empPaittZHFXVVFlVGFiVlEvMjM1SnQz?=
 =?utf-8?B?aFhMOU43c2MzSFIxckI1NFZxc3hES3IzL3FFTnRVeHZzRzJ2d0tPdms0NGoz?=
 =?utf-8?B?UE96RHJnMGxaWUhhMTFGUTZSOWhhUkRyTHBVYTB0TVpUT21SQStoTThtT0E3?=
 =?utf-8?B?S3pkeWFPUnZ6Qkk2dGVnaFJRcHNXLzJiOE0xRUxsY05PMjhOT1FNcHJVY0xh?=
 =?utf-8?B?MmZia3NPNFhBYjBjQURqRjRiK1NzVTZlTUFZZzZJM0M5ekt1bjZPTFM1ekZy?=
 =?utf-8?B?ZDB2MkdqazBwZktZb2JSclF3SFlwQ0FDTWI3ZWsyYUU4bitWZ2dxTGxxamFU?=
 =?utf-8?B?NlNEYSt5ZldwWEtyZTBkRmkybS9mTkRNTEdGd0tKb09sK0pXWFVRYXp5Qkpt?=
 =?utf-8?B?Ym9ITW8xWUhRaERRK1J0M05rQUxQcC9PWUVxbXZrckUxZ3NucGNtVDY3TW1T?=
 =?utf-8?B?TmNBbWs4NmlxSUNINkhNbFFMbWRDdUFQNG5LcXlrMWE4RUxHQ3RUSDlpRHVh?=
 =?utf-8?B?S1lDVjBUamw0UWg2MHJnQ3BBdGVrUFRmLzhWRUZpTWE2UWFSaHFBZ0lTVFd0?=
 =?utf-8?B?T2NaWkRUblFRNVVBV0tlMVpjYkg3b2FKSStISmFQLzV0ZTdlZEZ3UXFJTDNY?=
 =?utf-8?B?dUhrMHdDT3FEUytKTWdERU1XWHZXKzEyN3l3TGxBeGhiVVZiK3NpZjVwUnFJ?=
 =?utf-8?B?Tmp5QzZiM3NEYWYybk5aMU1ZZmxxUVhRR1l0ZHZnbXN6bnRJUmliZkZoT3Rh?=
 =?utf-8?B?UWdBZFAxMmsvbnVWWUJVekJlWnQzK2JGd1c0dTlFS2haNFZsc21XMzV2eWR1?=
 =?utf-8?B?QThZaVNuRU9TN1I2dURkUjY5ZWpCeC95UDBGRTJ1Y2UrRk1SMlc5M1RnazVo?=
 =?utf-8?B?VDZpV2hiL1RWbXlFbldpR1p5QU1nekRoTUNxVk9YYkZpeXFtT05JRXcxNjJF?=
 =?utf-8?B?UnBOVXpFNXcwTGdPK3A5QUVQOHpyaVlLNGpsVVdVMDEvb1BVU1J6dE5rOXRT?=
 =?utf-8?B?K283Rkp3S2VOQjVhQTFxM2k4a3pqai9mMnNlWk8yczhaMUN3MUNnZ2hhaXVY?=
 =?utf-8?B?d3lEVFcyVUhyTWFsS3RzTWsvaXFvemdJc0ZNelZueXVhUXhiNExyZ3Y3UUpY?=
 =?utf-8?Q?TpiK3oWMAGkBBUqWmFFRDjP2pg/eFAXhbW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e34d9bdb-cd94-4182-ece5-08d8be676ec9
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 23:51:12.4919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u39lX6SH9HjQXttnUS1tYMDPpia/Q280x1ANvYCQTeske+ausMe/uz/xdlGl22Ko
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4480
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/20/21 9:10 PM, Babu Moger wrote:
> 
> 
> On 1/20/21 3:45 PM, Babu Moger wrote:
>>
>>
>> On 1/20/21 3:14 PM, Jim Mattson wrote:
>>> On Tue, Jan 19, 2021 at 3:45 PM Babu Moger <babu.moger@amd.com> wrote:
>>>>
>>>>
>>>>
>>>> On 1/19/21 5:01 PM, Jim Mattson wrote:
>>>>> On Mon, Sep 14, 2020 at 11:33 AM Babu Moger <babu.moger@amd.com> wrote:
>>>>>
>>>>>> Thanks Paolo. Tested Guest/nested guest/kvm units tests. Everything works
>>>>>> as expected.
>>>>>
>>>>> Debian 9 does not like this patch set. As a kvm guest, it panics on a
>>>>> Milan CPU unless booted with 'nopcid'. Gmail mangles long lines, so
>>>>> please see the attached kernel log snippet. Debian 10 is fine, so I
>>>>> assume this is a guest bug.
>>>>>
>>>>
>>>> We had an issue with PCID feature earlier. This was showing only with SEV
>>>> guests. It is resolved recently. Do you think it is not related that?
>>>> Here are the patch set.
>>>> https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flore.kernel.org%2Fkvm%2F160521930597.32054.4906933314022910996.stgit%40bmoger-ubuntu%2F&amp;data=04%7C01%7CBabu.Moger%40amd.com%7C3009e5f7f32b4dbd4aee08d8bdc045c9%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637467980841376327%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C1000&amp;sdata=%2Bva7em372XD7uaCrSy3UBH6a9n8xaTTXWCAlA3gJX78%3D&amp;reserved=0
>>>
>>> The Debian 9 release we tested is not an SEV guest.
>> ok. I have not tested Debian 9 before. I will try now. Will let you know
>> how it goes. thanks
>>
> 
> I have reproduced the issue locally. Will investigate. thanks
> 
Few updates.
1. Like Jim mentioned earlier, this appears to be guest kernel issue.
Debian 9 runs the base kernel 4.9.0-14. Problem can be seen consistently
with this kernel.

2. This guest kernel(4.9.0-14) does not like the new feature INVPCID.

3. System comes up fine when invpcid feature is disabled with the boot
parameter "noinvpcid" and also with "nopcid". nopcid disables both pcid
and invpcid.

4. Upgraded the guest kernel to v5.0 and system comes up fine.

5. Also system comes up fine with latest guest kernel 5.11.0-rc4.

I did not bisect further yet.
Babu
Thanks
