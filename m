Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A56342C805
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 19:50:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238493AbhJMRwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 13:52:07 -0400
Received: from mail-bn8nam11on2049.outbound.protection.outlook.com ([40.107.236.49]:58690
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238914AbhJMRvS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 13:51:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNWDA36Ja8f9Fs576M8KOOmZsIj647I/rdz4sD/zSCmGcA5998yYWXpGXUG+3c5maYTQkcgpTuDjKr9Qc5wvkTDN3yUniebNUGOWSUHVgtceLPKeVldnAuhZLnulmK2MXRf4BWLjvh/84qufFzB9wDvhlix5SaaAb0FELVmnutf8mHFYzqi6ZbPA8ep2I+Vdjz9AbXfpOYJ06KjQBHtNeA33Z88x3t5ExnJScirMg9ZC48CINg9FsJn3gGstpvtZ0nC1S4qw0QqXaHjM+GVABaTb+eh9qNh+Kc0Vod1cVe997C5pF87fK3PAlmc5OyOFfaREm/gMfB8kCoZmAq6ePA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PJbF47jHXaEQxjgCjzAR8IziJBycHPmtbhD9qksHxL8=;
 b=PrjxhX06z13Z4kgtHE5C/9qCDt7bdPOGADh2XjkrJeGRpzfOVFANT8jJfH6Jy8jvJvKJCVcKvRgd6erxAK/JSqY67JuO61Mzvaq4V9pYh/UMUOeN21Jf4AhCqU54U4sr0KyIIzUNJ08tPLvDak4ObpL1UkRBw/JkTNO1UdM7d/7ZyufWAoHPF2Hv4kPEXwzo0gJ/nWomk6VSCL6wi838wWr8w5G5zg76LkzEKwldCevffn4f5SQI8mtLq99GtdbNwX+nQ8bjQaKSpHJTpoXjIs8mKLviM1rR0cHpFjSlLwYHQ9EKYqobrN1ttbC0FiFRogUqbfgAbK/u3WyuJnP3Yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJbF47jHXaEQxjgCjzAR8IziJBycHPmtbhD9qksHxL8=;
 b=2BkzmU4zqBcSFoXuut//IZQd7NL3QzDVLlOU5RLCxCBLzAZnql1gRaO8qzlFNqFCVueghwyG3r30pLAhTrK5/YGTPMoljO4mtWnZjs9n7cjHK75pX1xiZ/iTA8jiG4muxVuu1UuySGu+LfSuPmNQp/n2yO/EbLEqms7hb8uFLbc=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Wed, 13 Oct
 2021 17:49:11 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 17:49:11 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 37/45] KVM: SVM: Add support to handle MSR based
 Page State Change VMGEXIT
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-38-brijesh.singh@amd.com> <YWYCrQX4ZzwUVZCe@google.com>
 <a677423e-fa24-5b6a-785f-4cbdf0ebee37@amd.com> <YWcWW7eikkWSmCkH@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <b4067e4e-6901-265e-49f8-0142b52f5819@amd.com>
Date:   Wed, 13 Oct 2021 12:49:03 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YWcWW7eikkWSmCkH@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN4PR0601CA0015.namprd06.prod.outlook.com
 (2603:10b6:803:2f::25) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN4PR0601CA0015.namprd06.prod.outlook.com (2603:10b6:803:2f::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Wed, 13 Oct 2021 17:49:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4c5fa4c2-0248-4983-cfb1-08d98e71c378
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB2368CF73CD56C77965C69780E5B79@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Cz6XoYKW5W+NUcTtcjvoFczjd/+2LJV+H34sR46xM305orlcHLVmyrm0EjVBASS13atgTigOg9maHhhhgtGWbfAVUM7nth+ysJBjhFYuY+frhsFoLTtPNQxieV+T1yOXc+85xcElCIsRcyZryGbUvuZHbW0k+4kTBhxZPmiWYcYEwp6L7eGtrneYfrmHnxFrCAPzPgDdvQFTCfh/eU5nEeEdrBf8E6Ss/rLKB2Wnriod7Rrtem6k05mtr5JwCO1GGipRritLdIqmUJefFNC0Rv++of8ylcxG8YE+OcZlYp1sa5H17fuxnvISi6Mn8CTs1Exfv9arOrBgdFWzkeyT2hFMzI/HZH4D1OuVrUPU3gifnV4EmNmZKZAlz6OpTXbJKRhNncayzbjfag3/b1gZBKFwgiQ/j2DnMp1k+Aput1LhdMLEyQIpXbNQuSxCm3mgcmCO0A4pt4EXNaWgVDjLfH3a1bRtdIR/ZH6pAZGi3JI77VY32LUMQ/h/Fldo8k2XGTGxsbDBvASZtPERrZLteZaHljiIENxlPTA0Ol0eutD4pAv4ownK362u2iY830z4JhcxQ0Hx6Rc5JET4SVGVXjYAi1XG7udQFJr/llhFY3eTmvuva1zZI1kxI+k4zKG+0PdLxE708gGWmOvEgNiVtrsWJI2p5u4s49ZSKetF5n6PeUzfE/APMz8bEStcEeq+rDuJGDvxTnu2jgUYu0nHptYlsvwBk+VnDYc2GpQ+KlwMPHjxso978+uWjmoo9Ao8DC/2GV6LDHHW4Mz+1hWMTtDuoPUXoM9bWGr7waD59n3IKRe25SHMeHIiOiDXDhQ9xwYmFtI/kZJ5i/GhDOt5Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(4326008)(86362001)(7416002)(8676002)(31696002)(6512007)(966005)(66556008)(6916009)(7406005)(6486002)(83380400001)(31686004)(66476007)(6506007)(508600001)(6666004)(44832011)(36756003)(38100700002)(53546011)(2906002)(66946007)(956004)(8936002)(186003)(54906003)(316002)(26005)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0pVNk9Vck9Ha3B0WitldEJicGpwUndLSFlraVdtTUVOc2EwZHh4aW5XbFZO?=
 =?utf-8?B?VXBqZWplWEZ1UUZpbWZnYzNBL05VNTFaVkhleEFnVEdBUnllbE9DVldEbEhk?=
 =?utf-8?B?VjFxZTByc0QveGExbE80bzZ3aHA2NExuV3BVQWlnc0NWQU42cmFqWnZaYXNM?=
 =?utf-8?B?ZXE1YUtVYmtxcHZFd3R5Q2EzTFNyVFVzQk1iZW51OHZra0tKOUloWFl4Y2ZE?=
 =?utf-8?B?NXc5RHpWR0FjODFMZFdsSjZVU3RnMG93UjA0eHdDWkhoVmJqZnNiYzJoZWwv?=
 =?utf-8?B?dk9HUUZxdC80bjBsRlMvQlg3ZTl1OVJ0Sk9ONE1TMm0rTWVSZUFYM0NFcEx0?=
 =?utf-8?B?SjdWb21NZElvR1lXWkp6cWVJMjRTZ1lZNnFLNml5NWp4R3FTN0krSFByZEt3?=
 =?utf-8?B?TCtpM1o1T1hXTE8vSHA1UU8yTzhSL0hMSTBUY25EWlJ4RmM3T3FTRTBpZzNL?=
 =?utf-8?B?VFk1YjBJb0YxZDVmZytSeE5aWitGbk1wbW1tQy9qUTNIZ0YwOG1JSlFITGd4?=
 =?utf-8?B?Yk5QNHlHYXBCRkZhTUJmZm1rK2h2VWE0OVVtdjNJYm03NXk1YWxKY3hqbFF6?=
 =?utf-8?B?enJNbHl1N1o4ejlRZVVYR0I1MEtvR0llalRwZ294SjR0emNqSnB0STB5Q1J1?=
 =?utf-8?B?WUw3WDV5NmxCK3owZENwOSt4d2luNjJHNFFHQk5lbUh2eW5xTFBjVXVRYkUx?=
 =?utf-8?B?Y3M5N1NML3FxN3Fja3VzWmlDY0xFTzk2d2dVWERJMlh4ZEJzT3psK3NBZFVM?=
 =?utf-8?B?RmE1K1lnaGNTcG1xVGZwSG5rcmVZMkI3b3pTai9OWHE0WENDcE15VXhtTU5q?=
 =?utf-8?B?OGhEUGg1U2JhdTcwRXhGRWpacWl1SVQvdGluem5rU3hVZEZzbXZrL3hrSDUr?=
 =?utf-8?B?QmVMTUdwc2hpM0h4d3E0YjBHZyt5d1JGY3BNTWl6UzNRS2dQMERlYXNlbmNO?=
 =?utf-8?B?TURiTGdWUjgvZnhvTXZpVHNQdjhVUTI5Wmt0VGtEaXlSZ0ROMU1EZjhEK21M?=
 =?utf-8?B?SG9qRWJJRFQ0YkFDTFZlMlc0VUx1WDEvQ1Ura044ZE0raVVlQVJMSlNYZm03?=
 =?utf-8?B?UlVZeTY1ODIxMFZmWGQ5NlkybjI4cDh5eEx1dDVaZWROaDBpUE9CR0t3TGFB?=
 =?utf-8?B?Mjc5SlhlQ0wyMm9NTHlvVGRtMnRUWFhmTmh2WnBCUjFaVlI3aWZQVTlZQ3Mx?=
 =?utf-8?B?bVZFaU9vZXR5L1RZTlFRN1pvb1hQSkNyei9FMkJ3Qi8yWUNkS3lqa0E3ZXpy?=
 =?utf-8?B?Qjh4bUIxbzFwTGZ5NmpQa2RVNUdJcXdIcTJKeGZmOElTcTRrSGFrWEpmRWxV?=
 =?utf-8?B?M1JGemFEM0xIYmpBcTVpZlhOclp2TjNSYXhZSGZyK1NaZ1VtaVhJR25KQWZq?=
 =?utf-8?B?QnR1NDdQQnFZY21KTHRZN0VqQ0xjMGpXc0RjVzZXZUROajdzbnFKMHJrNWhs?=
 =?utf-8?B?WVpjY3VoUUw5VTFPY0J2VE02cHBSUVlHSUNHbmJOL3doMEVEL2c1V294Qmsr?=
 =?utf-8?B?Q2lCZUxmcm1QUHhCWkROdDA1ejNxWGhWaVlEV1VOakl1QkpESFo0UXVDdTJn?=
 =?utf-8?B?NWNWYmtaRUNINzE1YnRNeE52Wm5aRk9hakNKYitndTZac3RRdFZXVlNRbklk?=
 =?utf-8?B?aTd5WVhLeW1FNVZ1Q2lDMGFSaS8yQVcvVkJybVFoNjdrZzA0d2pWZWlxNXVn?=
 =?utf-8?B?NDNnbzBkZVNSQ3prZ2NwOGx6R1pzRTBEOVkyQlRzS1FsZ051aWpIZGlUUkNw?=
 =?utf-8?Q?mpgr4oqqXwLhBdaE7KJvqzfq5+sSbuLpm2yUOph?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c5fa4c2-0248-4983-cfb1-08d98e71c378
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 17:49:11.4327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0pswrodz6FM7rzrxzVgZzQtG83wqny/AaN97lPdWwP+T/APrZWbfnOpZVQfdOPTlct/SJLkxLu8JWH850X0eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/13/21 10:24 AM, Sean Christopherson wrote:
> On Wed, Oct 13, 2021, Brijesh Singh wrote:
>>> The more I look at this, the more strongly I feel that private <=> shared conversions
>>> belong in the MMU, and that KVM's SPTEs should be the single source of truth for
>>> shared vs. private.  E.g. add a SPTE_TDP_PRIVATE_MASK in the software available bits.
>>> I believe the only hiccup is the snafu where not zapping _all_ SPTEs on memslot
>>> deletion breaks QEMU+VFIO+GPU, i.e. KVM would lose its canonical info on unrelated
>>> memslot deletion.
>>>
>>> But that is a solvable problem.  Ideally the bug, wherever it is, would be root
>>> caused and fixed.  I believe Peter (and Marc?) is going to work on reproducing
>>> the bug.
>> We have been also setting up VM with Qemu + VFIO + GPU usecase to repro
>> the bug on AMD HW and so far we no luck in reproducing it. Will continue
>> stressing the system to recreate it. Lets hope that Peter (and Marc) can
>> easily recreate on Intel HW so that we can work towards fixing it.
> Are you trying on a modern kernel?  If so, double check that nx_huge_pages is off,
> turning that on caused the bug to disappear.  It should be off for AMD systems,
> but it's worth checking.

Yes, this is a recent kernel. I will double check the nx_huge_pages is off.


>>>> +		if (!rc) {
>>>> +			/*
>>>> +			 * This may happen if another vCPU unmapped the page
>>>> +			 * before we acquire the lock. Retry the PSC.
>>>> +			 */
>>>> +			write_unlock(&kvm->mmu_lock);
>>>> +			return 0;
>>> How will the caller (guest?) know to retry the PSC if KVM returns "success"?
>> If a guest is adhering to the GHCB spec then it will see that hypervisor
>> has not processed all the entry and it should retry the PSC.
> But AFAICT that information isn't passed to the guest.  Even in this single-page
> MSR-based case, the caller will say "all good" on a return of 0.
>
> The "full" path is more obvious, as the caller clearly continues to process
> entries unless there's an actual failure.
>
> +       for (; cur <= end; cur++) {
> +               entry = &info->entries[cur];
> +               gpa = gfn_to_gpa(entry->gfn);
> +               level = RMP_TO_X86_PG_LEVEL(entry->pagesize);
> +               op = entry->operation;
> +
> +               if (!IS_ALIGNED(gpa, page_level_size(level))) {
> +                       rc = PSC_INVALID_ENTRY;
> +                       goto out;
> +               }
> +
> +               rc = __snp_handle_page_state_change(vcpu, op, gpa, level);
> +               if (rc)
> +                       goto out;
> +       }
>
Please see the guest kernel patch #19 [1]. In spec there is no special
code for the retry. The guest will look at the PSC hdr to determine how
many entries were processed by the hypervisor (in this particular case a
0). And at time the guest can do whatever it wants. In the case of Linux
guest, we retry the PSC.

[1]
https://lore.kernel.org/linux-mm/20211008180453.462291-20-brijesh.singh@amd.com/

thanks

