Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF0C3450978
	for <lists+kvm@lfdr.de>; Mon, 15 Nov 2021 17:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235593AbhKOQWx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 11:22:53 -0500
Received: from mail-dm6nam12on2064.outbound.protection.outlook.com ([40.107.243.64]:34144
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236776AbhKOQVT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 11:21:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eSWofc28M5qtMllr0wWab+BGqyxctikJlKJdbvOqdgtdg+/zyeqzwe0M4AZGUfCjylHRt+DD7N1QOkmVKIrPiO5Wxrm9oLnby5JDRiWsflNRarA+bwFlqaKtBG/zKu5HV1yBhWn32LXac9uV3rZZ+TmfkSputbFm13w6NsoFc0vxdE+V58u4bmGE3HzDo51a3BJvTn+sKyKoDmdxKJ66/wFc0Ko7XNCSR0s3BWKG4NFIuvqX0fKbozsUdPeH9MJ7uV/ktNWbVOCcegOBuAP9a25cik01KUZIFItuu7ZeFqi/z9a1gme8pi7H8KXup9GKPuAlk6S9Z4JffDP+EXvWNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tivI8Qu5pG9d6fXLx/d5xWiunRbr4pYSWDPcWprdzfY=;
 b=Ei3BOGQdX8shBdFdBZCsHcgfPEYn3DMwFCIncgWChXnOHPg+weRXzLG79I9jtcfUOvvY7Ane8qrWrFNOyeiqZU7zFXuMjRmM6oh2/CfgV8yjdpXeLJ1PBK8gntrfAYSxtwNFlaszGI73mcjuAPdsQIEQHqI8EIdgBstGDlwZhQYi8Cf6NlUElK7c+WyTJaZSXfqjsVoaTtLBWyunstb6osgQ8slXkIEfcGzhT++vXphjZx/xGOa6ST9cQw9lIUEcMZMqBQpO/C7Bi6cNoJ+s7to4n9WmwWKzvVv9PeW9kAV66U+/RjSlPmkjw2bESGwtIs/Rt7g6YfkmCxgzWbOxRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tivI8Qu5pG9d6fXLx/d5xWiunRbr4pYSWDPcWprdzfY=;
 b=1YFw1l5s/Q4c6vP3a+nh+ahwg+0T347vT0BbUffcs5BIAnbIe63w9mx1E8QdcQGZKcdlDt1uo4YXozaR4joOxtCg8IhTPDt45Q7Dqxuy/28RkwIla1vxKgmhTeseHQpmkxj34V15xm2/3oTo8qIlGA7OuEH5XtZOXKCH40kUXzk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2638.namprd12.prod.outlook.com (2603:10b6:805:6f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Mon, 15 Nov
 2021 16:18:22 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4690.027; Mon, 15 Nov 2021
 16:18:22 +0000
Cc:     brijesh.singh@amd.com, Dave Hansen <dave.hansen@intel.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic>
 <YY7Qp8c/gTD1rT86@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <f2edf71e-f3b5-f8e3-a75e-e0f811fe6a14@amd.com>
Date:   Mon, 15 Nov 2021 10:18:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YY7Qp8c/gTD1rT86@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:208:120::28) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by MN2PR10CA0015.namprd10.prod.outlook.com (2603:10b6:208:120::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15 via Frontend Transport; Mon, 15 Nov 2021 16:18:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 94e6f560-b357-417a-91e5-08d9a8538b09
X-MS-TrafficTypeDiagnostic: SN6PR12MB2638:
X-Microsoft-Antispam-PRVS: <SN6PR12MB2638C951E520FFC3B63D03B9E5989@SN6PR12MB2638.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2+I3BgfQukXILTyiv6eLc3aKYIqKB+HM7LB6mJKrXMtZa3NbXUGkw3IcS4BRU0Rw7MMB/UUTuffYhelU4Rqg+U4Y05QIxdJiul+imVP5FF0AjZSWw1MgqDmRedKi/uSEepAQoEE/tJXESp472BKg/I0PTOKo76f+2FCkbz0ARM7ZbV0wzWl57MIJFNiyHt+t9LplFNVralqUSno8LEGgWeg3AS8SwpVl+CtPZsAbjxBROMeXL/muLsoaHJAlPh0tvBfaDyFO85I4+DfxwYR7uos6GpfVbPwdkxiJTKkQuuZ8bZcTrJJilNpBMEY66BDl2Cff0oe2qmcpbKMlUL7x/rOvBa4hCWcyFrV+wOtzavFcuom6ph2PC836jZimEIPdbNanWGTo70Bg5ScOKAgz9ZCU051Try4Qzh4o6aafS6k8bfasNsry6G8g55SyX5pBxNDwY8e84ATIxY2jqlTEwNww97bSZ3UU+gyBwYKu55BVENsB3bnYcMqXSSjHGV9CtXzjn2b2NlFwfhquVxpHBPDCqx+RW0KjgKqzMmIFKrT24krv7vVAr8H9+eC9Gwq1nJ/vG1Q5N0GKjsSgSbDJM1iEBoL4QcL/NaQ56vZzt493BOHzsQxlVNWkVMKu7BLqfwSzYsN5zMnrhnzUe+WBE8AwteTWk2E/u0RiCnehmckxqsAVw9+lxWQctu0Xg3+gFzjmA7JsA8kk6m+M9RSowh4R+/3/yx6DhnHS098CNKblgAOSkUqmSP2FJJaylJJ0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(38100700002)(8676002)(316002)(6486002)(53546011)(186003)(66946007)(66476007)(66556008)(110136005)(31686004)(956004)(31696002)(54906003)(2616005)(2906002)(508600001)(7416002)(8936002)(16576012)(86362001)(7406005)(5660300002)(4326008)(26005)(83380400001)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Y3hsT1ZYTnRQRXFSUFpPY25mT1pNQmQrVldpdHZic0xWK05FL25NdFpGcnpm?=
 =?utf-8?B?NlJyaFdCa2hycWpnWUtFdjI0MlhkQXJLSmxkTElDeitoU04zZEYxR2pKTzBS?=
 =?utf-8?B?NG1YYm52L1kvRGNIK0tlMVc5TzZRMFJiT0VSNmRpdFJ2Nis2NDFHcGFGdXE4?=
 =?utf-8?B?c0FvYnV2ajBrbUF6MGsvcE1XakRqaWdVQlFzZnVKaWFMd2lTK2Ywei9odEJ4?=
 =?utf-8?B?dlJCTXlYOGtuRTNkb0dZb1ZkMkFPMFFCZkhxUlFaV0NzR0dGWEdhYTY4UTdi?=
 =?utf-8?B?dVl4eEdrWVp3dWtBUU9yS09RdmZ1NGI2akpUbmNhQ3VBaG0xY3lrSnU3L2ho?=
 =?utf-8?B?ZmhtQ0xjY2dSMkhXMW5XUFIxMDRsU2kwK09SUi9Ra3NRRk1nZ0F6bU14aUE1?=
 =?utf-8?B?ODFsZ2txMnE3ZWd0VlAxYW1hS0ZRaTl2TXcyU2FZYUlhS1QrWXpNZ0dTR2lo?=
 =?utf-8?B?akFaYS85MkVkWjNsTm5YYm9xcFhPTE1iYWpvZEhvbldCSUEzNEpuSjczTHZQ?=
 =?utf-8?B?SHRTUUlHS3dYME05VjJoRWFHeXhzS3VrQkp5WGhlekZlYWJLbmZRaUhibVFC?=
 =?utf-8?B?TGFIbTdocXozbHlHMnkzc0VZUHRXcnRjbHM1aHRUNzFVNmFkNHRSZmJyYVlu?=
 =?utf-8?B?ZWZha2ZDNktjK2l4akxrcjFhcHV6aGg1ZFdIa2hPNmdQblhkK09WRURvOHdm?=
 =?utf-8?B?cE1Tdi9tcmpnRnlaQzR2Q2RXTndOYmpmaHZtREdHZ2lOdS91TUVEUlVhT3ZF?=
 =?utf-8?B?MG5CTG1JZi8rUGNxZzIrMkFhek1rdmZDQnV0dzUyVDRpaXJrUXYxRHlreXhC?=
 =?utf-8?B?Qm5BTEJEeFRhcExFRm9oRDJFV2tWSkREQzJOSkFGZW1icFE0VzdrbDY4SVZt?=
 =?utf-8?B?cllNRGRrU0xQb3ZKeUdwc2J5R0cvaXFkZDBlS1pHSnZmR29mQVNwalNTSXZD?=
 =?utf-8?B?MzE3ZWNINkRaaFpETGNnZWRabFl0S0ZIWjhyNkJhNU9mdlBmNkIyRW5VcWJa?=
 =?utf-8?B?cER5ZUZKS1F2RFUxYU5KQW15UjZZNktyUU5JVnRIaCtYVUsxY0Fma2lvV283?=
 =?utf-8?B?Y2k0TmFQb2lQb1ZOVmZobGp4YmVGak1UVW1VN0E5Zytsd1I0dE8yWFFOdnBR?=
 =?utf-8?B?dERFUzdxbkVkTjNWMVErbFBoa3QwVzhVc0tnZ0Y2M0MxbGlwKzVueU5iWHJw?=
 =?utf-8?B?cURBRUxrVGxYaW1XWXNQRWZjNFZVVkhta2VSVEZDY0R4bm5EeWxaRXdBcVlL?=
 =?utf-8?B?eVBKaGNWRDNLWnA4bG1xYXExNmxHQkIyYUYweUxiY2d0eEZTUDNsVjdIa01O?=
 =?utf-8?B?SzV1bjhtUTZxaDJNVVVOVW5pOWcvendLZEh2dFVMRUZJUG5ZYXNNR3NVdllj?=
 =?utf-8?B?eC9KWDlta1dZZ2tFR25OdWsyZWIyVEs5RWloL09OSEVkb1lrUnRkajR0L2RD?=
 =?utf-8?B?K1dqend2c2twOHZBQ3pLREVHNFdBY3lvNTdlY2xpUlNaUlNuK1hxbnU5Ykx6?=
 =?utf-8?B?Z1BJNXB6emZ5cTBITXplSS92d3FIRU5hYUpFSkFNMTc4NlYvcXdVckJhK0Z6?=
 =?utf-8?B?QVFrdUdwbXNaZG05R3c2VXBPa20zYmR5ZVZzblpDa1gxWExjWTJ6NDVRWmxz?=
 =?utf-8?B?NXhibzRFeE9nTmxMRVYrblZOWXNoaFA1cWJXdEl5ZGY4ejQ3MFVtOGlZSzlN?=
 =?utf-8?B?Sm1tclhzZ1kydWFjYnRhV0NRZUZpckZXR25USWUvbVRyU3l1VzFxaFlzckY0?=
 =?utf-8?B?dExhTjJOcGZhWEZPU09qTFhQRmpDcGdqV2YyS3FGTW0zZmZUTU5ZL0VxZzNO?=
 =?utf-8?B?YnN3Nm5MRFptM0Q3dGdUREdoU00vZDZLRUlPdzVIV1JVMUtncDJheFhuN2Za?=
 =?utf-8?B?SFRORFllSm41VjlqZnlTMlR1Q0RwVWtpZy9HWDVieG1XSTRpZjlZcUJzN2pj?=
 =?utf-8?B?N0JxRjViNG5Oek1JVzlwRTVMalZmSGhQV0VXTkpVTWx6dGYzZEMwU0RyZy9I?=
 =?utf-8?B?UVdmWlRGWnljZFFkb1poTHNYb3YyeXVoOXdPMGtkSW1Pa2cySEZWemNSdWRO?=
 =?utf-8?B?dkVyNitQa0IxbGpqSFJ3dCtOUEJ1Wlgrdm9HeDRoTHlGOStSMVZJaElMcURv?=
 =?utf-8?B?QU9Mb085OWhiWjFzSE9Sd2pYYlV2VXhJVTBPMDVhY3RQSG5tN25qbFVtZDJa?=
 =?utf-8?Q?UAwOsJyjwQTaO7zTAzMigbA=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 94e6f560-b357-417a-91e5-08d9a8538b09
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2021 16:18:21.9826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vhtTEh24lBUgAlfTI9N+vqElHQYsIDpGSrVUsKqkFj5f7JQw3+92mlyV91mJgOXw4r7uoGO6iDC/6XQSUSyZ5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2638
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 11/12/21 2:37 PM, Sean Christopherson wrote:
> On Fri, Nov 12, 2021, Borislav Petkov wrote:
>> On Fri, Nov 12, 2021 at 07:48:17PM +0000, Sean Christopherson wrote:
>>> Yes, but IMO inducing a fault in the guest because of _host_ bug is wrong.
>>

In the automatic change proposal, both the the host and a guest bug will 
cause a guest to get the #VC and then the guest can decide whether it 
wants to proceed or terminate. If it chooses to move, it can poison the 
page and log it for future examination.

>> What do you suggest instead?
> 
> Let userspace decide what is mapped shared and what is mapped private.  The kernel
> and KVM provide the APIs/infrastructure to do the actual conversions in a thread-safe
> fashion and also to enforce the current state, but userspace is the control plane.
> 
> It would require non-trivial changes in userspace if there are multiple processes
> accessing guest memory, e.g. Peter's networking daemon example, but it _is_ fully
> solvable.  The exit to userspace means all three components (guest, kernel,
> and userspace) have full knowledge of what is shared and what is private.  There
> is zero ambiguity:
> 
>    - if userspace accesses guest private memory, it gets SIGSEGV or whatever.
>    - if kernel accesses guest private memory, it does BUG/panic/oops[*]
>    - if guest accesses memory with the incorrect C/SHARED-bit, it gets killed.
> 
> This is the direction KVM TDX support is headed, though it's obviously still a WIP.
> 

Just curious, in this approach, how do you propose handling the host 
kexec/kdump? If a kexec/kdump occurs while the VM is still active, the 
new kernel will encounter the #PF (RMP violation) because some pages are 
still marked 'private' in the RMP table.



> And ideally, to avoid implicit conversions at any level, hardware vendors' ABIs
> define that:
> 
>    a) All convertible memory, i.e. RAM, starts as private.
>    b) Conversions between private and shared must be done via explicit hypercall.
> 
> Without (b), userspace and thus KVM have to treat guest accesses to the incorrect
> type as implicit conversions.
> 
> [*] Sadly, fully preventing kernel access to guest private is not possible with
>      TDX, especially if the direct map is left intact.  But maybe in the future
>      TDX will signal a fault instead of poisoning memory and leaving a #MC mine.
> 

thanks
