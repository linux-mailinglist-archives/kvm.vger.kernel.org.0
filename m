Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D727402B40
	for <lists+kvm@lfdr.de>; Tue,  7 Sep 2021 17:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344807AbhIGPBZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Sep 2021 11:01:25 -0400
Received: from mail-dm6nam11on2087.outbound.protection.outlook.com ([40.107.223.87]:6369
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231590AbhIGPBY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Sep 2021 11:01:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPdG1xLjA+02tO8f69aSSoL7370QkIS4N0KV2ARat1hx7wbuFIt+WkjsBu2nNGGUJJ1VRT4KDvvFcfOv36nbMh6l/3sHQ2MXGtbnvdDa5VzKNk05xJRwCRpB6p4lWTPmsvXyVf0BgePl2fr5HcErsJqkGwZ5wZLW3mM2GKG9gmK9+iaqQ+2EDWipYI/cX0hXeIV/Gn9Bk3merTgM9iOGFU/0N13fbTAb82KeBctfJiulSaryMj+4N55YeQIqtaH7ClT8xkb9GMqc2jqpzlfJVb8nsh+c6HZ0z5G6UB1dHndpxdt8OXkF9Il5YE9LeDyQvbji7eumZpheskqAMBIIiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RcYbO+ZSLxnprEcV0Tv3ZfOOh6BiWrwVSSI/ZMXLl/A=;
 b=Dr6p6as+AIiZ4GGTQkMDgewC/e7W199Csc7EmMk00RScKawMnrwx3EpDuUDvcxVHofLOL9yHH6eGE39CG9Y2ZyE1gAJcLVzYR8NceiVotyPrVb4lXs/+t5v/ZkzXB6cOBqibLiOFkomd47rfsTGYEx06ekwFB3zzY6OXhrFa6UNpMH5sJKvc0XqhZBsRrxwSWIbx8IPZQOg1JxDZmfPJGZzNTJ78KP31/paAEc6/7a4OXLA7Xf4F1mzxRYIulFNdBoo1SkyOXiiN3XNoqH0ppvwVuHUPH0uFNcqEXPKtMqMipzmchhEWcBOpBycEZWdW5vqULuwsE2b2pp8jI0SH+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RcYbO+ZSLxnprEcV0Tv3ZfOOh6BiWrwVSSI/ZMXLl/A=;
 b=doA3verlCUNkgBbjRiBzS4Vyn0FE109AHTuvJwd82lF1M+45crrWQ/wKYiLMi0YvS3imI22oxnkwZUCH0XTv2bGybg4ziw8VPTQ/UclLn1xLRfr4q9thS/baZdCSQ5JYhOz7+kWwnjXmfps5WP+yQUeRJM9jPMuYaEF6iCeJFv0=
Authentication-Results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM4PR12MB5054.namprd12.prod.outlook.com (2603:10b6:5:389::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.21; Tue, 7 Sep
 2021 15:00:15 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::d560:d21:cd59:9418%6]) with mapi id 15.20.4478.025; Tue, 7 Sep 2021
 15:00:15 +0000
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     jejb@linux.ibm.com, Andy Lutomirski <luto@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <YSlkzLblHfiiPyVM@google.com>
 <61ea53ce-2ba7-70cc-950d-ca128bcb29c5@redhat.com>
 <YS6lIg6kjNPI1EgF@google.com>
 <f413cc20-66fc-cf1e-47ab-b8f099c89583@redhat.com>
 <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
 <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <f9fb2962-4b67-00e6-01e3-48a57d466932@amd.com>
Date:   Tue, 7 Sep 2021 10:00:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <bd22ef54224d15ee89130728c408f70da0516eaa.camel@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA9PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:806:a7::11) To DM4PR12MB5229.namprd12.prod.outlook.com
 (2603:10b6:5:398::12)
MIME-Version: 1.0
Received: from [10.236.30.241] (165.204.77.1) by SA9PR10CA0006.namprd10.prod.outlook.com (2603:10b6:806:a7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Tue, 7 Sep 2021 15:00:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3af2eed-abd0-418d-9086-08d9721032f5
X-MS-TrafficTypeDiagnostic: DM4PR12MB5054:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5054BD5074C19470090FF98DECD39@DM4PR12MB5054.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nmLeBmwZ6hMLHh16kqBDJK3zq61WY0LhrSYk006UIod49oThVFcSfOFtPesr95BSzBGMzA3fIQYxNzVPZLrJRD63BPgf22HfZNHKRiC1+e9EV7rLZkLeEgu0GpmHnr6jlliKfXlXuRcb8iIO4pOjjU0M+W87gGT83h/ZjO7XGWsk8mezKFNICLX8k1qQokCIPdNv6zyRYGSh5cCXJhxwcMucFXKb5AZvJeuJRu4Vx5027v3XGcsFmYi5JNiwEcc8fEkzS8uHHHQyFNIo3LMM2EIHpPXnn1qdiASdahNDBJlhSrb0RLe/bMOjD5UIomMnTx+OFMKEVpMiKJTQ7jSer9m4J+tRyq8AMrDrEWbhyuYa+W+EctHcaYDNiTRDB/J5Z3Zd2YWSf/dNha9FDTsb11yXwBNPgsmXgHiN3JfkXi5hfYSa5laPu3tDcyVhXjXeOU8r8CH6RMFNCD9ZtaK/oCzSqFPzrtlbtXKVdxiU3d4PrsNyZcLPbcQ1zABmH/hzUOAGuarFVE1vcpatAJOF7oUwCxJ3aJnmZvtnDPDtqoal11I+xIo65YB2EfaPKc2GLJNlzVHgQMKJqSDdUKd7zY5WZHShzPBxrbTemyA/az5vgVzDtaHL5t4H8OGFDn3Gr2wduqbr00o1jJhVaJns41Epq7uWt/mUxrCWlaURA25cFzkd/AlbYjZP+lyDWLHJfXmd3jXiGq1EHWZoiFVyEtZedE3oF2L+m6X8qWhaEco=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(366004)(136003)(39860400002)(38100700002)(2616005)(110136005)(956004)(16576012)(66476007)(7416002)(8936002)(7406005)(4326008)(2906002)(316002)(53546011)(8676002)(5660300002)(66946007)(31686004)(478600001)(36756003)(186003)(26005)(54906003)(6486002)(31696002)(86362001)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejRUSTZ1ZGtZTWMxUXkrb0hyTFVWMjI0SENweGZTbFM1UHpsa0FHSDhlQU0y?=
 =?utf-8?B?M1ZpMnNHaGhISERhQnFFQytBRk5VYTh6eVZQSHYyb0VyNUJSak12ZFYzTnN6?=
 =?utf-8?B?STZYckEzOUtuYWJWUytyNVdEejBma0I0ZVFxVkVKWUNISUVyM3Nud0oxbkNw?=
 =?utf-8?B?QVlScmhkZDZIY2xkTUNrV28wM21kNkJ0RURkc1d1RGp2ZStSQksrTFhoK1F1?=
 =?utf-8?B?V3VCZnZVOHRIUmlIMERPUnljOVczK2dUVnVHTVN5TStIUVVQSzFncXFUZDJO?=
 =?utf-8?B?YkdIOWNtT3JNUi9HdlNBcU9QZ3RaUXY3aWg1NDhuZHlOUG9iY0xaWEtjTVNK?=
 =?utf-8?B?V1FEUWJsNWM5VVJzTzh0Tmp6VExabHJBWlFpQVhtSFdWbW9CVEdMWEY5cUNt?=
 =?utf-8?B?OHdOaXNyOFM5dGpqcHdIczJTU0JSNHNHUWc1WFo0d1R6R05XQ0dzTUZTTHhL?=
 =?utf-8?B?YWFkVU5lZ0N6RDJRakJ3UUZjbWF5aW5OV2xnZ3FnTEZlbjlieXZEWDdTUlNR?=
 =?utf-8?B?R21KYjlYVmVNWnZES0tEWSs0cmtLakNYN2h4cElZb21tMmRZRlVONEhtVmVz?=
 =?utf-8?B?SGpRSzdGUGRjek55b2E2N1JmVGVweVFnQnZqNTh1K0YyYjQrc3NTc1RUekJz?=
 =?utf-8?B?U3gray9yanNjK2tpV0tFZUFob0hzdTBzaHBaU3FlQ2dEQzBDMTJsY01QWjNq?=
 =?utf-8?B?UnU2YXNuc1UwR2p1OTBmMStBNlVKR2tvcW0xWWZHS0F3VFN1ZVA4K0NlOERC?=
 =?utf-8?B?SzNIakU3dnJVNHpHS1NlZFV4UlNoNXJYY0lYV0g4R05XZWlnWnhEWlpSbExi?=
 =?utf-8?B?SVo0azFyeGVhaDg3K0x1QXFUNHZXYVoyOUZRMXRSMGl5eUNMRjRsZGZjanJC?=
 =?utf-8?B?Q2FqMFRRcDdMdnJsbzFHbnlFOW1ncUxZZzQrVnFDR2JjblRka09vRExrSG4w?=
 =?utf-8?B?dXluS3drUGl2THhTMWQ4SGY4ZzA5WFB2TVAxSkhTSHdrOGFnRkJENnJCZXVu?=
 =?utf-8?B?MVR4c3Y4NjMwc3VBUFZGdjR3RFBBUjQwMzlwUmdmSkMrNHR2WnNmVHMrclR0?=
 =?utf-8?B?RWpQbjVOdGhnSk5abmRMU252Q0pUOEo4YlBSTDRWUVhpeFdFeXNsc0VTUGdI?=
 =?utf-8?B?cE5VRVpYV1ZVMldJaXBSQ0lLSTBRRk91OWZ3NjNqQ1VFSjlZMkxqVFdCSmMz?=
 =?utf-8?B?RFNVUnMwNHhBTTZ0VERqd3RKSy83WlJMWjkwYzRNWndpOGd3NmQzRnRVZjJ4?=
 =?utf-8?B?cUlmeFFZc1BFUk9XNUQvQWlqWHUyTHBTbTFnM1RudWVUNzJjNlNGNDFNWS9T?=
 =?utf-8?B?RFNObGRwdUMrK25VYVhuM3RyRjk1QmNxRXpWaHpRZ2IwUmZkMkw2ZmY4OWdr?=
 =?utf-8?B?cVVUNXB6ZGNUK0dPQk85cWp6NU52NWExcWRJVUpvcGl3MHRLNkdiNlpHSFhN?=
 =?utf-8?B?WmpTUllJRDBBRUhZa1NxMHIrSzgxaXhWdUVMVmJkSDlkd3c1T3AwVTJEbHFY?=
 =?utf-8?B?SWJPVThlcEc2UUNrN0FianNMSTMxNzl0T20xbVpkQ0VnZkxMb1hhWDJQR3Fj?=
 =?utf-8?B?MU8rRmtWd0szZk5wUUhZMzdOMkNXWHhrTUpWQzM0Zm92OFgxMXd4cXVSSVBj?=
 =?utf-8?B?L2FKaW93OHM0VjZwUUlMTitjOWZLMkpLbkxaL3pYc0w1TnNPemJqaUErQm9F?=
 =?utf-8?B?VG1QZnhlaVU0SDJ3cUE4MU9XUVlub2VLWnJJRnVtQ29IZit5aDQ4R0F2eG1l?=
 =?utf-8?Q?OVQM1ZvkLfLiOJNH37uajoRZh3g4uOU/p2oy6Zf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3af2eed-abd0-418d-9086-08d9721032f5
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2021 15:00:15.3735
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zmo8ucCQufib9yEWRDqnY1BGJZ90RQ44RMw3omDkBHVUSdawfo+pmS9f7fDnbm2BupYeBmK1luLxA3roPgcX0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/1/21 11:18 AM, James Bottomley wrote:
> On Wed, 2021-09-01 at 08:54 -0700, Andy Lutomirski wrote:
> [...]
>> If you want to swap a page on TDX, you can't.  Sorry, go directly to
>> jail, do not collect $200.
> 
> Actually, even on SEV-ES you can't either.  You can read the encrypted
> page and write it out if you want, but unless you swap it back to the
> exact same physical memory location, the encryption key won't work.
> Since we don't guarantee this for swap, I think swap won't actually
> work for any confidential computing environment.

There are SEV/SEV-ES and SEV-SNP APIs to swap a page out and in. There is 
also an API to copy (for SEV/SEV-ES) or move (for SEV-SNP) a page in 
memory to help with balancing if needed.

These aren't currently implemented in the kernel, but can be. It requires 
the changes going in for live migration to recognize that a page is 
encrypted/private and invoke the APIs to transform the page before doing 
the operation.

Thanks,
Tom

> 
>> So I think there are literally zero code paths that currently call
>> try_to_unmap() that will actually work like that on TDX.  If we run
>> out of memory on a TDX host, we can kill the guest completely and
>> reclaim all of its memory (which probably also involves killing QEMU
>> or whatever other user program is in charge), but that's really our
>> only option.
> 
> I think our only option for swap is guest co-operation.  We're going to
> have to inflate a balloon or something in the guest and have the guest
> driver do some type of bounce of the page, where it becomes an
> unencrypted page in the guest (so the host can read it without the
> physical address keying of the encryption getting in the way) but
> actually encrypted with a swap transfer key known only to the guest.  I
> assume we can use the page acceptance infrastructure currently being
> discussed elsewhere to do swap back in as well ... the host provides
> the guest with the encrypted swap page and the guest has to decrypt it
> and place it in encrypted guest memory.
> 
> That way the swapped memory is securely encrypted, but can be swapped
> back in.
> 
> James
> 
> 
