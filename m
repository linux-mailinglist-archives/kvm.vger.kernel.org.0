Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F26F242C406
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 16:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237860AbhJMOyE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 10:54:04 -0400
Received: from mail-bn8nam08on2055.outbound.protection.outlook.com ([40.107.100.55]:49335
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234388AbhJMOxw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 10:53:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKHObj3k3GZF4GVDoZycAlD9MyTnJnEK6z+Re7r9WgwNoR1wz0ZVKS5Ghj01G4luaNkv5JSzl/A/0tdZLfKtYYCLOEzGR1KbsSWjoFM4SqM03EEy3zSUjZWhiBHsKh0Isy9KjbyR8rsNKkwemma8kO+rEidBhOUG28hk8JuMcSK+MWCZq6L+N7/WCPRjAQkC01s7TBsucQeigm+pBxEn8gZtWKvVh8QA+yeP+fGkEgKcZdROUzcPcFpRK92ShpGZfxztbJEQEGNeA12ePrfthTPjFnDfLxMPt5Qf9f+Svs/ux7lMKberG4/h6ZTK2BXp1Pmfm+f0csDUgIiKqrYI/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hW0kQKcvD9F8JU59wGZGSduE8mij7Sp7mv0OM2mak8Q=;
 b=K/cyyfo0vrq4Jxx8BmHEA5SBpAkUUl3cBQz+6awBoXWVJ84gBDE2Eo/ZytQ/DD67pi1I7txu8fgChzcb1d+hkLpPcnBqmPNX2LrY8gkEkZLdEl1GbiLgBUY72fu994IwWor/VWusxeBzNTf+3taY3GCzh/mjR/Y4mdD6zEzcqaAL/Qm8+mAtCoe+srKjALvMe7ijlMtHnspY2g05D4AdI8wBX/Oc1t+y114DVCR1kByiyyxL6dT/djaqzD8r1w3gLSXMrZLMsc9+YkRgsG8nv8XvaG17+uasdUewYOrEgmlefxOTR/Wjs4pFGa9JVlrjKWI0nmZpWnwRK2Fn+OYYEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hW0kQKcvD9F8JU59wGZGSduE8mij7Sp7mv0OM2mak8Q=;
 b=0emnqeS9EJAh7rleZ3yawjPYG0LB/htBBIbxi+PJbM9id9sxBKSn5aKLq60HxdLn+xA3upP3eDV5IVXVz4u7Q5pD+ufvVDHN57rQP/cQpalx8H6htYV5d9Sm6xMxPD/WNkMLd75QZXG3vyVBlySjt3rhMhzU4hiPnYrJYNS458E=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4512.namprd12.prod.outlook.com (2603:10b6:806:71::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.20; Wed, 13 Oct
 2021 14:51:46 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 14:51:46 +0000
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
Subject: Re: [PATCH Part2 v5 26/45] KVM: SVM: Mark the private vma unmerable
 for SEV-SNP guests
To:     Sean Christopherson <seanjc@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <20210820155918.7518-27-brijesh.singh@amd.com> <YWXYIWuK2T8Kejng@google.com>
 <2a8bf18e-1413-f884-15c4-0927f34ee3b9@amd.com> <YWbufTl2CKwJ2uzw@google.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <5eb61b30-e889-2299-678f-4edeada46c2d@amd.com>
Date:   Wed, 13 Oct 2021 09:51:41 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
In-Reply-To: <YWbufTl2CKwJ2uzw@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SN7PR04CA0112.namprd04.prod.outlook.com
 (2603:10b6:806:122::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from Brijeshs-MacBook-Pro.local (165.204.77.11) by SN7PR04CA0112.namprd04.prod.outlook.com (2603:10b6:806:122::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Wed, 13 Oct 2021 14:51:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44cd4168-41c7-4b3b-1093-08d98e58fa70
X-MS-TrafficTypeDiagnostic: SA0PR12MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4512FD67D8B3C06AA93A7A00E5B79@SA0PR12MB4512.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3SsSsdv0gViWsdaT5YuUV8XgxSEL44xZbGwYH5iVCHvuthybUbwN7dsjQ3S/L2Jm74lOoQcMM4J3nUZFG9u5LNaWMDJ4+6M9VB3jahs1/WrWx2DCR5+Q3D5DzAmwlJgaDwBYh1sQ7WidHZXjCYQgwu5KgPXPYltSWZtMVdC4EVe4XqHYOGxwIwne0l7WPQ+Sl1KfUEMG442RuzFl+iz+P4jckhqSjINJ6Meg9HbNAH0oMSJt+gwuTPgtF/fDzIDw6wdlxMdb7kg4ekC3PWnI+P5oB2MYf2IEQxTm4kvzHl6SjquYR01lefw/mVd3h+mItELrReiU++XrTtFP4mL/OTfXT/AaYLl6F9evJpQsCOfdVKPaqeObiI46gXFrr/yCKZPfAsuFL1fO0XIUwJdSDqcopHz5AZpLdWB9Qi1IErNf6NuTMEwbTWuMDTrYGrGYvtCDBXFtf2gXVM03SwcKklRUSa1X+Htwjkc90vRjv9nc5rJ7wvYTBscw5dhpPEZwguMX+RG/CcCAn5q+Z6uD5MLYr0HsnmLir8plbvNAWVeGIEORq2j/+idz6zEAk6RWKnIOjZUk6H2sd/HEXCoIeNJoZbXE4LKrVzBeSmKkqxwd4up+GFm1CnJ07Yd6wSkl+OiqzGr34jNDy8S7+/taEOqG6HROvjUa/Cpa4/Dv3yioOHgUwfz8AeGH9+UTlqkHI43vj0nXsrNktK2KHiD1CEJGfMxaE9DnMTDAytzpH33rrtFvQFSFSo0tKf85pour
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(54906003)(956004)(31686004)(508600001)(8936002)(66476007)(6916009)(83380400001)(2616005)(6486002)(66946007)(36756003)(31696002)(26005)(66556008)(5660300002)(6506007)(7416002)(7406005)(8676002)(316002)(6512007)(2906002)(53546011)(86362001)(4326008)(44832011)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YytxNFVkWDdpeStCU21yMG4zVGgzSlJlTFpLcTVBclMyOEFvMDA1MTIxYWE4?=
 =?utf-8?B?R1N1ckROVDNmdllOZVVMYkppeFNPbmRHOEcwTFNoaEpJOFMvNmxxd3kxeHM2?=
 =?utf-8?B?S2V6WFJIVTFVQnFSMGVNVHVZMEZuaExsUjBPODl1YWE0OXVPZ2xEUmlHOFVh?=
 =?utf-8?B?MFVHN0ppUk1LcXhkbUdXdGg3WXNjZ0NIdkFjT3hpcVppWDljTlROaVN0enBD?=
 =?utf-8?B?SHV6MnZ1YXk5TGJtQXp4N2UrR2JRclVmS1k4bDFCcHlqQ3dhRnRsdFNXQ0pC?=
 =?utf-8?B?cFZBM0I1OUZkbUJlbEJ1dFRxSlJpSktxZVpZbE5vVUlIdmg0VTlRL0NlU2RM?=
 =?utf-8?B?emxOajVZWFZ0VVkwb1JJWnczOWFwNmRJRWpwWmpMKys3NFdqc0NLOEFaSS9i?=
 =?utf-8?B?N1RhOFhjeW5YbkU1bEE2dmhTaFFUUWdZQzdBcktQelE2T2xsbTd3Z1h5SDVB?=
 =?utf-8?B?UUZMU1BMSzhacXZsWFpQNUxZZlpGNHBNY0xBSkdYYTNQQ240S1hwNVhCUnlK?=
 =?utf-8?B?YzdwaFFsREZ5bC9ZSHJ2T0ZqbjFZbEU4NW1IWktta051eDVteXZpL2Q0RzAz?=
 =?utf-8?B?TTVTMlpDLy9hNUJ4ek9SczFjVmZCR3UvbWxER1Z0bHRNMm0vZFYwQ0hodkhi?=
 =?utf-8?B?RFk3aE53VTdoamQzSUhQcFhETm5HYkhFTDkwWkUrV0ZmbG14aWVkdmNGMWpk?=
 =?utf-8?B?UXdoOExaSjEvWWVnaVdZSFZuelFzcm5QUnpEb3NrYnhNRjRXM0lBUVpVL2hW?=
 =?utf-8?B?M1dEeU1jak42OFZ1Z3FKMjh1K3llNkhIYTI3bzFOZ2VVVmhDZWFXOWlqdjNC?=
 =?utf-8?B?cE1Nb2lJeEo5TUhRZjFGN0dteXIyRkErQ0k5R05JU0kvUHQ4eGx2b3c3WHZC?=
 =?utf-8?B?OTQvSFh1L3RZeVNXMG4xckgxbmQ1UGxYcUU4OXRhMllBZTZRZTVEc2FqZ2VX?=
 =?utf-8?B?dW83cDlOc0cycFZTZ2dwZys3ZmxEQXNhTGpTQXhib01zV2kwSEF1VGo0aGNK?=
 =?utf-8?B?ejl1V0pyUmlGdklMM2FHYk9JcGJzOVpaa1hUQ1pIcTVzd1dPb0R0VjdtRGlZ?=
 =?utf-8?B?UW00M3AvbkZTZ0xrZ1ZkWWNkQ0JYL2k2VUJoRmZJS0pYdW1wMjVhN3p0ZzFq?=
 =?utf-8?B?QUgxNjdZeTRlcGpwNGtRbXZQQzZtdjhqUDY2Uk8yaUYwZWVXQlo4VDkxN2dl?=
 =?utf-8?B?MVQ1Vm0rZzdqMzNJV29SeEFQQ3JmalgyQk9XSnRmNVFGbjFVejdUamQzdWpj?=
 =?utf-8?B?TnlsakNhcWduWS9QcGxGT2R1dlRPZ2VHZHZXUkVMcmpXZ3Z0QUIyNUVjUk54?=
 =?utf-8?B?ejR0N1NTSEE2cGJ6OTYrVVhkUnBLN0ZaT1BXeDJtTXpDNWorTzRwcXkwSmY1?=
 =?utf-8?B?YmxZeUs1ZzQ2aXduZEt4L0drOXdTalRKOEFyY3k1Wi9IT0lvMUErUm5WcEJL?=
 =?utf-8?B?OUxzTTV4UE1aOC9XWUxXZytxSHgzSzNReHZzSkFLWjJZMXJ5bHcvdFVaUkN3?=
 =?utf-8?B?TmtQbDB5ZEtRQzhncnpTRFR5Q1FtbnlsRzZiSlB4bXY1ditXbXh6M3Q4YUVL?=
 =?utf-8?B?V0MvbzcvNXdTeWU1c2djK0lSd1E5QTJDVTRSOUVCNE4ya0tIaXQ1dlQwZFQ1?=
 =?utf-8?B?cXprUlI2L0IwKzF2dGYzSDJROVptemhOVVdNb0E0aUQ5UTZKcnpraFpnWDlD?=
 =?utf-8?B?TXd3YUVaTlhIZEs3YlVnTFdNdDlnaG10RzAzTk42NVJ3SnJDU25uZjY4WEF2?=
 =?utf-8?Q?wcbJiWPZjfNMX2IsZdgMqO2DjSkVHqoAthcGnbd?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44cd4168-41c7-4b3b-1093-08d98e58fa70
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 14:51:46.3078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JEHDY6qX4sjGiWce+mceYTtsicS6uncY7/TArkPKM1JlEoB9E+x9H/x3N6TK04UZrpw/51WBKYO1tZGtls69wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4512
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 10/13/21 7:34 AM, Sean Christopherson wrote:
> On Wed, Oct 13, 2021, Brijesh Singh wrote:
>> On 10/12/21 11:46 AM, Sean Christopherson wrote:
>>> On Fri, Aug 20, 2021, Brijesh Singh wrote:
>>>> When SEV-SNP is enabled, the guest private pages are added in the RMP
>>>> table; while adding the pages, the rmp_make_private() unmaps the pages
>>>> from the direct map. If KSM attempts to access those unmapped pages then
>>>> it will trigger #PF (page-not-present).
>>>>
>>>> Encrypted guest pages cannot be shared between the process, so an
>>>> userspace should not mark the region mergeable but to be safe, mark the
>>>> process vma unmerable before adding the pages in the RMP table.
>>> To be safe from what?  Does the !PRESENT #PF crash the kernel?
>> Yes, kernel crashes when KSM attempts to access to an unmaped pfn.
> Is this problem unique to nuking the direct map (patch 05), 

Yes. This problem didn't exist in previous series because we were not
nuking the page from direct map and KSM was able to read the memory just
fine. Now with the page removed from the direct map causes #PF
(not-present).


> or would it also be
> a problem (in the form of an RMP violation) if the direct map were demoted to 4k
> pages?
>  

No, this problem does happen due to the demotion. In previous series, we
were demoting the pages to 4k and everyone was happy (including ksm). In
the case of ksm, the page will *never* be merged because ciphertext for
two private pages will never be the same. Removing the pages from direct
map certainly brings additional complexity in the KVM and other places
in the kernel. From architecture point of view, there is actually no
need to mark the page *not present* in the direct map. I believe in TDX
that is must but for the SEV-SNP its not required at all. A hypervisor
can read the guest private pages just fine, only the write will cause an
RMP fault.


>> [...]
>>>> +	mmap_write_lock(kvm->mm);
>>>> +	ret = snp_mark_unmergable(kvm, params.uaddr, params.len);
>>>> +	mmap_write_unlock(kvm->mm);
>>> This does not, and practically speaking cannot, work.  There are multiple TOCTOU
>>> bugs, here and in __snp_handle_page_state_change().  Userspace can madvise() the
>>> range at any later point, munmap()/mmap() the entire range, mess with the memslots
>>> in the PSC case, and so on and so forth.  Relying on MADV_UNMERGEABLE for functional
>>> correctness simply cannot work in KVM, barring mmu_notifier and a big pile of code.
>> AFAICT, ksm does not exclude the unmapped pfn from its scan list. We
>> need to tell ksm somehow to exclude the unmapped pfn from its scan list.
>> I understand that if userspace is messing with us, we have an issue, but
>> it's a userspace bug ;) To fix it right, we need to enhance ksm to
>> exclude the pfn when it is getting unmapped from the direct map. I
>> believe that work can be done outside of the SNP series. I am okay to
>> drop snp_mark_unmerable(), and until then, we just run with KSM
>> disabled. Thoughts?
>>
>> thanks
