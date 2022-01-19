Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F4249399A
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 12:37:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354198AbiASLgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 06:36:18 -0500
Received: from mail-bn8nam11on2050.outbound.protection.outlook.com ([40.107.236.50]:42465
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1354185AbiASLgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 06:36:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=js9clNMWYvAsW9e0G8zrTR0NUN7LnZRttWSDoYc+dwMYJxEDqP3shrprmZnccgSbB0sjSvYIpMLYRL+tT5/RKVgJGlkmjFarR1qe0HSeKCg55HH59jg3EDGS5EUsK/Vkg4F5XYFbbeYrZfzQXxl+g0huaqp4E9qnjuZ1ZoWsvVghqAEuobsj1pPh4GWknh0CWPZSXI7LGvI3cI0faRWGDdZUL2XQ2ZBUrOUhFbwK3qx5pN5SK8bo3ZINxhuWr7qI33z9q0n0VHNSCyA/RohT5P2XFE89l++ihKwFQeGfCJRk6zyXjbaAr9YXCLyW6iFpTKlqTk688S2kwqIdeDhPDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a7JtTCfvOo4hLUi5PRM3vizJMcqCVQoSiZWNF3taefA=;
 b=KOJ+CKCjJ5KW9qGlR4Q1NlrRbvBB+KPQl7stNYUU0KbrO6RYe01jx3JQWpE1Kzl51KrpS20tkjbInSk/dcQJtxx0SP4lSF1lE/jXamzEXr2i6iQC4NzpAUEJyL46EuNdrjFO3ryS9zJ2QO5ISvLGyfd1A38MWPTe2EWWUrVo+UVTuohQbi5GFC8hEQM+Re9KROSr6p2lr4HYSTq3ARKXR0i20NL/8ADr8M8s4b1G7adub1Bz6R7LW63GQ8NwlsUsso3+fIadQ/uIGG8H/AS6w/EzXFBfoWfBGzFUNSnN/AQW/WSBpO+sGHPr5m+W5xQ4rlx0RUFDJEv3F8V499r1DQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a7JtTCfvOo4hLUi5PRM3vizJMcqCVQoSiZWNF3taefA=;
 b=Yd7jLFq6EVguQmUBIBOoDrrRImAYK0VJ1guTa2iMO94Om8BByhY7G2Y+1O42znn3bzNhkbYjb3QblJPUEKiAwgw4gP+JM/efMZGcbKyvJ9Mb3YdKyFzXCoDTpSL+Zi7R7vV5da1DYz0lmaIHmA3dqHUq2vHJymmENesVnbvf3/w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB2470.namprd12.prod.outlook.com (2603:10b6:4:b4::39) by
 BN6PR1201MB0163.namprd12.prod.outlook.com (2603:10b6:405:56::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8; Wed, 19 Jan
 2022 11:36:10 +0000
Received: from DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc]) by DM5PR12MB2470.namprd12.prod.outlook.com
 ([fe80::f110:6f08:2156:15dc%7]) with mapi id 15.20.4909.008; Wed, 19 Jan 2022
 11:36:10 +0000
Message-ID: <8fecb51a-e3e8-b3ca-247b-6825e8ce433f@amd.com>
Date:   Wed, 19 Jan 2022 17:05:52 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Peter Gonda <pgonda@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Bharata B Rao <bharata@amd.com>
Subject: Re: [RFC PATCH 6/6] KVM: SVM: Pin SEV pages in MMU during
 sev_launch_update_data()
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
References: <20220118110621.62462-1-nikunj@amd.com>
 <20220118110621.62462-7-nikunj@amd.com>
 <010ef70c-31a2-2831-a2a7-950db14baf23@maciej.szmigiero.name>
 <28a005b7-9ae3-fe0d-b003-9aedba27dc85@maciej.szmigiero.name>
From:   "Nikunj A. Dadhania" <nikunj@amd.com>
In-Reply-To: <28a005b7-9ae3-fe0d-b003-9aedba27dc85@maciej.szmigiero.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BM1PR0101CA0054.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::16) To DM5PR12MB2470.namprd12.prod.outlook.com
 (2603:10b6:4:b4::39)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1eb35ba7-c5cf-41f7-3f53-08d9db3fe398
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0163:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB01630D79EF21D61311F02C7FE2599@BN6PR1201MB0163.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xp3QD7qicYnO2fpHbSGUu7HHOwxlcoWmYwOpVMVvIrvmTRr7I9Uz51jejFkcUzlgyXFkpmjqFsfSC976hD49adchYLP/Nzfouezv6F5ohhrvfdXrn9ocaIRpTWKWI1aG8ioaI9GdsIWNLwLmqiOI9yoJ30brkeUQj3PKEg3Fa0czSZHXv8r3BUdlMEjA4n3k6yf08TUedbk1rqBf/jCQZu0RXZRGptulfDIgRRYiWOhRZcSzZ5Fg7jsxSkmRNG8Gi0ksdhN+0A2D3Lj2cvNcbdJ2OwO0jadXVUHY1+kHiBWwQq0FgVjzakn5aB89Ai6V2Umj5ixgEL4dSE+TRv+cX11Z1PDBU/w2gmusJJXUKykbJAMTChgwyGUWuXSyTwElLV0Og7clY6oq3buc07AMY+QXJ5fOoPELEB/kgr9U1tNxp45M7vfrLbzEsqerp3eSpgFSZGrUmMhZHAyK7puVwVXed80kD3Csw1dAH2Pz0HXZdL9aiMoxToMP1+JkqR7Y2bpg5Qmji+MNheI7EfnMDzHLUJxDctXsDG48I3+/siYl8CXPYHvYtGC0THl2P6jndZ/LSpoHBPEiKyK/37dZ1G134YSggwyZ8Add81iuPoi0SXNtXYvH1bR3a12iI55k6DmPUA3F9mX2KCOduZJZXUG/ISPMjewJLhIota+uFAc0p71RBTFMPnq6LKRfxLyeGAAvTQme5J/umxwq+RaP/0pHlh18SdpaJ3vSM2u3yfox0JMAti7+iwwLjuTiQn3j
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB2470.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(36756003)(54906003)(4326008)(316002)(31686004)(26005)(508600001)(6666004)(6512007)(186003)(66476007)(66556008)(66946007)(8676002)(38100700002)(6916009)(53546011)(6506007)(6486002)(7416002)(2906002)(8936002)(2616005)(31696002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajFqQlc1VmdjWDhSSTM1d2x2UHBnZmgxYkJwSzU4dkNRMXV2bFREM0k5aWRz?=
 =?utf-8?B?VVd3MWNaZ2sveStYRFVvaWVGS0Q4bUo5M2hUcXVZWVhBUVAwVU5KTk90NFRo?=
 =?utf-8?B?cW5MWVFWb1hNbkZVcm4yZzJVZ21iZzdmRU8xdTZ4RXNuUnJycHhCUlNXdG1j?=
 =?utf-8?B?SEZXZHRrS0FBZHZVOGdyd2l1Y3lxdkttUEk2aVVCellJSjNmZWVLR0RyU3hY?=
 =?utf-8?B?SlozQ2lJcGxWYm9yTkJNaXJWWkdoeDA5MWxVZ0dmbjRXSEJjRStRMkNQNHRM?=
 =?utf-8?B?OXNCSFpiUlNYRGJ1RWtnWnBGbDQxLzI3a2hGNytTYVc4bXRqZUZQV3BRcUds?=
 =?utf-8?B?WFNTVlJ0MHRPMTF4OVU0UDdnWHpMZUxOa0NxM0R0YUQyZ3BldUZTMENaTU9D?=
 =?utf-8?B?aWRFZGZ5OTZMdXo5TTJMSDRNQjNRaXNIQm9wWWIzc05PWHdrSFVPWXRQMWlw?=
 =?utf-8?B?b1dhdXoybDc2MDh4V0VUd1lad2JxYThON01Ua2RWaFlxaXZEUTZNVUR3REhQ?=
 =?utf-8?B?WDJIMTlkTU5ycWZlV1M0TndmUWRuKy8xU3UyUktGQXhjNmt2K3NtZk12MXQz?=
 =?utf-8?B?bytjckNQQ0g0VHhrQ0VPM21UUGNBeXgrSUFwbFhNUFIwanp5cFQ5V3ZERzcz?=
 =?utf-8?B?OTRaMGNSM2d2WEVuTXZiRGR5TlVhRHQ2cHNlQ1d0TTZqSFVydzlrR1NnUzZV?=
 =?utf-8?B?NGMzKzIyUitqVUxUM1c5eHREdzMxVHJlZlUwRVozSWROcy90NWIzRDMvT05O?=
 =?utf-8?B?M2J2NHdXMzAyVFQ4b0VVUWNHbWpXbkp4RnFrSndzODdsRWpTV0Y1ZDJpWHJN?=
 =?utf-8?B?azEybTN3R1MvMWtKR0lwNTBvV2grQ3BKblZVQkRHNFJxdmhwZTJHSjJZekxZ?=
 =?utf-8?B?WUJyL2kxbWpUOTA2aUtsUjdseGJFeWZuWGlyZGdDdlg4dE9JUzhiOGsxQXlC?=
 =?utf-8?B?cUVSRDlQWURHQWFIQkxTRythaENpc2tZODhUMlpkN1gwNWVpYXBBVVh3V1lC?=
 =?utf-8?B?SHNQNklCSGZORU9NLy9uaFh4UXhaQlVrcE9KRWhlNTk4TnF4OVpZY3h3S3Ri?=
 =?utf-8?B?NjFVcEF2NEczaUIzczA4ZVZkZ2UxZ0F2NmNCY0RjVnduWnRUSnJ5VUJ1Sk9U?=
 =?utf-8?B?TERUNTFLRUhBVFNHZEV6Q1EyVUdVNWIydEwyN3oxRkJwY2d0SWVtYmN1TkF2?=
 =?utf-8?B?MVlEWHFhcmtrNmFQOWFlc2l4REF2UEM5WUJ0RVVZN1ArZ1o5UExMYkJGd1U4?=
 =?utf-8?B?a2s0S0FPT2VvYXJKQkRIc2sra1FLd2tMNSs1ZkV6SnM3ZkFSaExoWVpsbHhI?=
 =?utf-8?B?Wm9SdldCQW91eUd5VXd4KzIzR1pEY2F4MmllNmhiZkVQN0Y0SW05UUFSaFBn?=
 =?utf-8?B?SEI1Z1NZeFJJZmpuQUltMTZ0SWgrQ1R2R0NtdXM1UVlxZTFoNDg3aGE5aVBq?=
 =?utf-8?B?cHNNdHBhQ3VLZ0Z3TXpodytyVnV3WHhidjV6MHkrRjRRMmZ2ay8ySTNOak5Q?=
 =?utf-8?B?N0RxdWpOV3Jxdno5QkZGMmFZNWhoMTZZN2xtQnNHejFlTXZhRDFVRlc3OGxY?=
 =?utf-8?B?cXBJc2ovZWNEbUtjZG1LZkVtYmdwa3d6Tkl5eUFWQ3VEUGt4M1ZMYkJEVllh?=
 =?utf-8?B?TDA3a0QzMEdUTDU0RHUveFoxcjdQYmNJelpaSnJvSWd1eDc4MTQwd1ppZWhB?=
 =?utf-8?B?OGFpcUswc0RMSFM2dzMzRlcwR0tmK3p2dThXbnJSMEQ2RWhETHNBMjhRaTFI?=
 =?utf-8?B?WDZoS1o0Q3UrYVVoaVk1ZENRTDhkUk43VVFXMmoxNzAvRWFpeisvOXdlMWNG?=
 =?utf-8?B?N25kRGppRE5GeklHb04yS21ZdjE1ci9sUnFINW1wdThuVXdvaXk3akY5Z0pt?=
 =?utf-8?B?c2NvS1h2WFJ5UWZ5Q0JXKyt5MG9FSVV5Z2pvQjFvN3ZodmhYRVpYRFk5bCtQ?=
 =?utf-8?B?dEcyYS9qbEdUYlNsakRhb0NndVE3VCszVTV5NDBWY3FnY1NmWCtObnZLbHR1?=
 =?utf-8?B?TkN5RG0xUnF0emhzZTQ0THJCTmRJMFFMNHRjTXJSWStscW9WNUlROHRhblVW?=
 =?utf-8?B?ckRWK3pQZjRFMWowWUJXMVpYTzNtZmlqY0gwc3ZyLzkwcUsrRHRQd1F6S1J5?=
 =?utf-8?B?UFk5b3dIRkRwQVVNSTRXQnF6UW9mWE41M29YYTR5WXBFdFQ3OFN2ZVJnU0JL?=
 =?utf-8?Q?d3WVXW1DRlixRBuCFvaa35Q=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1eb35ba7-c5cf-41f7-3f53-08d9db3fe398
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB2470.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2022 11:36:10.2463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4z0lpd6WfuydvZYV64ramPw6GiJOqdISj8MVhScNZqaA2R+OiYG3HkGFqsvEK2SZb0Y5MzN85rVIqGrBWFNkuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0163
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/2022 10:59 PM, Maciej S. Szmigiero wrote:
> On 18.01.2022 16:00, Maciej S. Szmigiero wrote:
>> Hi Nikunj,
>>
>> On 18.01.2022 12:06, Nikunj A Dadhania wrote:
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>
>>> Pin the memory for the data being passed to launch_update_data()
>>> because it gets encrypted before the guest is first run and must
>>> not be moved which would corrupt it.
>>>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> [ * Changed hva_to_gva() to take an extra argument and return gpa_t.
>>>    * Updated sev_pin_memory_in_mmu() error handling.
>>>    * As pinning/unpining pages is handled within MMU, removed
>>>      {get,put}_user(). ]
>>> Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
>>> ---
>>>   arch/x86/kvm/svm/sev.c | 122 ++++++++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 119 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
>>> index 14aeccfc500b..1ae714e83a3c 100644
>>> --- a/arch/x86/kvm/svm/sev.c
>>> +++ b/arch/x86/kvm/svm/sev.c
>>> @@ -22,6 +22,7 @@
>>>   #include <asm/trapnr.h>
>>>   #include <asm/fpu/xcr.h>
>>> +#include "mmu.h"
>>>   #include "x86.h"
>>>   #include "svm.h"
>>>   #include "svm_ops.h"
>>> @@ -490,6 +491,110 @@ static unsigned long get_num_contig_pages(unsigned long idx,
>>>       return pages;
>>>   }
>>> +#define SEV_PFERR_RO (PFERR_USER_MASK)
>>> +#define SEV_PFERR_RW (PFERR_WRITE_MASK | PFERR_USER_MASK)
>>> +
>>> +static struct kvm_memory_slot *hva_to_memslot(struct kvm *kvm,
>>> +                          unsigned long hva)
>>> +{
>>> +    struct kvm_memslots *slots = kvm_memslots(kvm);
>>> +    struct kvm_memory_slot *memslot;
>>> +    int bkt;
>>> +
>>> +    kvm_for_each_memslot(memslot, bkt, slots) {
>>> +        if (hva >= memslot->userspace_addr &&
>>> +            hva < memslot->userspace_addr +
>>> +            (memslot->npages << PAGE_SHIFT))
>>> +            return memslot;
>>> +    }
>>> +
>>> +    return NULL;
>>> +}
>>
>> We have kvm_for_each_memslot_in_hva_range() now, please don't do a linear
>> search through memslots.
>> You might need to move the aforementioned macro from kvm_main.c to some
>> header file, though.
> 
> Besides performance considerations I can't see the code here taking into
> account the fact that a hva can map to multiple memslots (they an overlap
> in the host address space).

You are right I was returning at the first match, looks like if I switch to using 
kvm_for_each_memslot_in_hva_range() it should take care of overlapping hva, 
is this understanding correct ?

Regards
Nikunj
