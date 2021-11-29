Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFD0461BA8
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 17:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhK2QSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 11:18:52 -0500
Received: from mail-mw2nam12on2051.outbound.protection.outlook.com ([40.107.244.51]:47456
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245088AbhK2QQq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 11:16:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qw2VenD81CvsvdJQsuO94NcSy4SY5FdPdlvivp9n4PIW6JSdITXM5lBdEUdqeE2Wwrd/bnleENT1oT8iOwiYwexUZP25dDzNF1M8L3pt3Pe1Tn7KxUgV5Ej7FCKqQLpF09ZDAPaXGZxdyk4kCzYqEchUyAK7TG2gIoc+6WAO2PT742O/6bbMFogXoQ+vuXobDlpQQ396Hf9bktDqrsiJyJlTYw9So3Bbsri5+me47JmO3uulp0DGBc4UubLr36Eyjygf80BwkgC64+BSUfSOxeAoZttcdGOkAEDYmf+nihLhZFdsm4gMneEx7Jz/ViPUoAZtiU8wCj+FP7WklVXBng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6HLFArhKx2jXLFMKyFEmhMDwMmzNWOmTD9a5RqJRSRI=;
 b=gU7uPccv9ckUlz2f1iZcO5mstfsa37fGxaL1/jGKQ3GScuCfs60ChnnFzSifsVNASkheed5UwhUpjpGhuBlDYlPhNemQvoD1uAQlmJw1N6qzc6wv2GAqy0l58gh6MFRZcxipT9HbMJsHfqq7z1F6+nkEjzlHequsDiAJvuzmXmmdFlmQwb9AuSKJDbhifMxCbkbyzE+80q9IjXipKND8QrCXOu65uVjqrPpTmIOyzd4FQOgAyJ1tspHK1Loz5X8kzi5uBXJnQiNJH/MBCAc2pgeaNTDK2+jgapotfwGb8i4RUiX4o5T9QqVUQk9kplZbmXSEL6js3hLNVXtM1UEvkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6HLFArhKx2jXLFMKyFEmhMDwMmzNWOmTD9a5RqJRSRI=;
 b=Eor9wsws6begCEkNs3HhzdfVtTo8J+3VzKTD6esDEfUAQ0/CeDOsnO38DYNPHwdAkMxGereE2eDcmJw67WGVekGHtAuYWwvL9PieNLpfOtbJgq5O2aaMbidezNR8QkgJq9ubS5EOwBzUsob4gHwtkgM22GUuQDIxpFKb5NhtOXw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2686.namprd12.prod.outlook.com (2603:10b6:805:72::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.24; Mon, 29 Nov
 2021 16:13:21 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::35:281:b7f8:ed4c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::35:281:b7f8:ed4c%5]) with mapi id 15.20.4734.024; Mon, 29 Nov 2021
 16:13:21 +0000
Cc:     brijesh.singh@amd.com, Peter Gonda <pgonda@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
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
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Vlastimil Babka <vbabka@suse.cz>, Joerg Roedel <jroedel@suse.de>,
        Dave Hansen <dave.hansen@intel.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
 <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
 <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
 <d83e6668-bec4-8d1f-7f8a-085829146846@amd.com>
 <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com> <YZ5iWJuxjSCmZL5l@suse.de>
 <bd31abd4-c8a2-bdda-ea74-1c24b29beda7@intel.com> <YZ9gAMHdEo6nQ6a0@suse.de>
 <9503ac53-1323-eade-2863-df11a5f36b6a@amd.com>
 <7e368c50-ff94-d87e-e93f-bae044659152@suse.cz>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <bf96f5d1-1cc3-1d0c-fd70-ade00cb46671@amd.com>
Date:   Mon, 29 Nov 2021 10:13:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <7e368c50-ff94-d87e-e93f-bae044659152@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR0102CA0050.prod.exchangelabs.com
 (2603:10b6:208:25::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by BL0PR0102CA0050.prod.exchangelabs.com (2603:10b6:208:25::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend Transport; Mon, 29 Nov 2021 16:13:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 957639e1-19ca-438f-3f56-08d9b35329ad
X-MS-TrafficTypeDiagnostic: SN6PR12MB2686:
X-Microsoft-Antispam-PRVS: <SN6PR12MB26864C86B97BE3CD55AE6623E5669@SN6PR12MB2686.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1S/0ZSXMXnRJkml1RPK5I9ObYXNYtpSpYxISEp3i4Ey8DtwnGHai7zUFkUTGznWU1riYKoAd9UNmOKJbpVD3VZ1bkPHaWb1A6GA1oXoFjoCRYyWmiWxD07XL76j2pK7Jcf4WnDGFh0L2HCvQpNXZNkWcuM6sWAWnf5x5nSnqHQ0maGoVbwppw9km590S9p5Ka19cTjFTxNhZMxodG7wFPWnF9OGYoB49VYtUiIdy8gpYniD6OVLrHwh5QIDZ8N/W2/Op7epQvSjZsvMZ9Vw8YR+kWkETGx5pk33mfzclfx+71JYzOaISg6Q+wPVkeCtgUv+tseRVP00JMdP611uLHPhPmiQpD6zZTCo9xN80wkE/z4Suio1fE9mDRL5xww8vE8M4V5NP3uv7EwAcfcoQ8fw1bAn75FzcdrxaE2EPHxZgopgndCESuFv6yEP42hbOmDrF/Pjotcnc+wEmrFHOyfsyx1lVAnIgwaxnhABSUOx7qo7KIOrhE6Q3hvb0hYpKhSjQoERryGnR5fHl9/Uh6dQYxh1ijqE7kKxilqbjeTZvvIyLkfQrGJ785JdKWKppIbaq9cSiXbSm5TBlEjUvvcpdbCopTMRPa/c/C0AbY7XhbEKKwa+soFZ6eQqpRi47RM0HWyJWSoTkJCEI06dMpaANKcu9ijQXqbItllxdLGLGPHC5qi9f/mh/iR3sZwwKWpl1Zn9gGIAnS3mz8NuEVQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(16576012)(2906002)(54906003)(316002)(7416002)(7406005)(38100700002)(83380400001)(5660300002)(110136005)(508600001)(8936002)(53546011)(8676002)(31696002)(26005)(44832011)(36756003)(6486002)(31686004)(4326008)(956004)(66556008)(66476007)(66946007)(2616005)(186003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YnU3czl5OU9ndmdSWFZjZWFHQzE1ekFjK282T1ZVempqRy9keFg4Vm9BY0hH?=
 =?utf-8?B?NWdCQm52REVwRllBWnAxVjZIZmd3R2hGVzd5dWJMWWtsU0g5MmNOSXdIOTVm?=
 =?utf-8?B?eWVweUExUUdocFRBVWd4SFVTenpTRW1SdnNKb1VFU25vY0J5ZWEyd3pXbHpo?=
 =?utf-8?B?OVNkdjdoVkorLzZyMWZSZnhHT1FGTlNpRGloUy9TWHdZWmlRdWJBaHRzajNs?=
 =?utf-8?B?THp2WTNPSzlNdjliNWNidlZTWkJtRnJtN1ljajBBekx4YnpWT2k1V2JhUHdY?=
 =?utf-8?B?TGc0a1p0Y3Q4b0tnTU05RDVjbENZbEFMNDgya3Q2b0RXejJ2K2hvSVZKdGd5?=
 =?utf-8?B?Z1hzczVib1hWZFh4TU5zTFM0TDBSOS9FRjlNNTl0Z0QzS3RkMlpVYWNZOE5G?=
 =?utf-8?B?cU1XZ0lQVXcwVUczNG1tQWpVME1jRHNlWm5xNXllT2dGdzJGSmN0Q2lJRXNx?=
 =?utf-8?B?blhIYmgreTNBd0NOaE9mNzNzYnphZmZrQTZuSkxRWGI5NEdYQzZQanNuaW9a?=
 =?utf-8?B?SXpXOU9IQUI0dWxCWVg1c0FxMjZpM3RpSlBVbE9LOCtBZkhYTTdYTnZmT3p2?=
 =?utf-8?B?NUJFMlFEbHhUampibW1VT2F5M3R0MURyNUFTTkZnVWtSY2FqQjBXckdpNVFF?=
 =?utf-8?B?SENhbWxXRVBOZ25QMzg2NERvdWRydWdVQjl1NWIxVFFhOUtlWXg0Y280ZDFa?=
 =?utf-8?B?OTZpNFRieHhaR2wyWXMyRlZCTjFoT290UGM1SVgzS1d5WERCMkhnUE16WDlP?=
 =?utf-8?B?N2J6K05LSGtFZXduUzVLdDZGRHo5SVloTkdiRk52NTcrSFFoQWU1M1JLcjVU?=
 =?utf-8?B?OHlOSXNVWkxHMWc3WHA3czljTjUzUEkrSGFSNkdyRU9RVkQrSG9XcmpVKy9x?=
 =?utf-8?B?eldwL0dsSWkxYWxwSkIvRzVSTXdCRWdkWWt3akNSeWxGUHBpTFB2bTdpaGdX?=
 =?utf-8?B?Z1U1WDIwb2VTRkFld2ZUMmZoYmd5c1ZQWVRLaWNnSlFQbDc4K3A2SFFESUsy?=
 =?utf-8?B?QU1BWndOaGhpMzFVb3gzL29TaUdsM2F2MUVaV2hvYXR6NURmK1Frdyt4VTVn?=
 =?utf-8?B?b3lpdDcyWDJTeHBtMTYrRGlPYjhlc1VTNDFJTDBhL3B1WmpzbHRsazBmcktJ?=
 =?utf-8?B?WkRmcWxUeVZ6NC95NG1kaDNTOFRHZWVMVXZ2aHhSRWdkRmFZUGZBQ05NODZG?=
 =?utf-8?B?QS9MSGg0emZWV3RKbzczMmR5UUFLL2hMdW5LVUR6dm9BUVpGMkFKRjJhZlFO?=
 =?utf-8?B?enZQKzhaZEVYUFNNWmtMMnFsRDBWSCt4eGV6ZU00VUk0K3JVdExZMjQwb0xt?=
 =?utf-8?B?dU5xdEk0V2laRmU2bTI3LysyOGdvdHMzNVlqQnpzMkh2Zk9IRHZoOGJCb2ky?=
 =?utf-8?B?L0w1WWhEMXpiMUJ5Q1lQWHlRY3d0NWpYWHU4M0NRRXdTNEkrRG56Q2t4K293?=
 =?utf-8?B?Z3FoUzlWSElZblN5RURFd3ZBUmYrajFZWkhWVG5aWEVnTHJDWTFhUEl1SVpa?=
 =?utf-8?B?WWFaUnQ3WWZ2cGJuOWFRMkdDNnYzM2h4K2RLR051YkFZZHQzdmtSd3BPelFN?=
 =?utf-8?B?QTZEUnA3L05vTGxqUUtjeFhaYmZBU0d0WW8waHc4T0pIQzlwamFSNGdlTmh4?=
 =?utf-8?B?Q05HL3dSTGtKcElDYXVCOVIzd1I3SlRPOWlXTXA4R21Bd0VlRnBxdmcwaHFv?=
 =?utf-8?B?eEtjWlI0UVpLS2RtbmlKMm5XV29Oa0Y4SktITkFyYityQS93TmYrQWlDZzl4?=
 =?utf-8?B?ZHZqdE5lZVNCR0lLQ0RXUEpBbEx6VDhISHdwVCtjZ3BnMW1rMG1iNjFNeldv?=
 =?utf-8?B?NDFoOExEbVRLd2lzQWNLcThaTVNYU2lqZ0R4bGJOU29QeVh5OFNleEs2MTZm?=
 =?utf-8?B?c3JXbzZqOFVySndMVFp3Q2VxQ01Nd1JsSmdsMjYrUkdYWmtLeSttS1JFQnpn?=
 =?utf-8?B?TDRHc2dvc0QxNDFjRHhuUFlXVmJEWEY2SkJvQkZDQUVmd243QXlzWTZGVG1x?=
 =?utf-8?B?eGVmbjRMQ1RlQUFiWkFNTHZ5dWp0V1NJL21YTWI3TTB5OEpZMXM0clBHQzIr?=
 =?utf-8?B?anE0QWJXZERsZEJaTUUycFUvRUM0cG1sOGpRcEdON1FicTRjbDVtTWNsY25t?=
 =?utf-8?B?Y1RBQ2FnbTNqSnRXTzR4UENTT0FQRCtmVCtDbzhsYXhBOEY1VFUwZmloNkJJ?=
 =?utf-8?Q?1hbjacKWz+gY07RVk2nKblQ=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 957639e1-19ca-438f-3f56-08d9b35329ad
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2021 16:13:21.4811
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bErSQVYjybdhzklDicKaOheeBFJBsIEZWL3b8na79w+bIX5afENZm1/TDdgZou+vvyB86H7rlJ/pvB1J1+SfCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2686
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/29/21 8:58 AM, Vlastimil Babka wrote:
> On 11/29/21 15:44, Brijesh Singh wrote:
>>
>>
>> On 11/25/21 4:05 AM, Joerg Roedel wrote:
>>> On Wed, Nov 24, 2021 at 09:48:14AM -0800, Dave Hansen wrote:
>>>> That covers things like copy_from_user().  It does not account for
>>>> things where kernel mappings are used, like where a
>>>> get_user_pages()/kmap() is in play.
>>>
>>> The kmap case is guarded by KVM code, which locks the page first so that
>>> the guest can't change the page state, then checks the page state, and
>>> if it is shared does the kmap and the access.
>>
>>
>> The KVM use-case is well covered in the series, but I believe Dave is
>> highlighting what if the access happens outside of the KVM driver (such as a
>> ptrace() or others).
> 
> AFAIU ptrace() is a scenario where the userspace mapping is being gup-ped,
> not a kernel page being kmap()ed?
> 

Yes that is correct.

>> One possible approach to fix this is to enlighten the kmap/unmap().
>> Basically, move the per page locking mechanism used by the KVM in the
>> arch-specific code and have kmap/kunmap() call the arch hooks. The arch
>> hooks will do this:
>>
>> Before the map, check whether the page is added as a shared in the RMP
>> table. If not shared, then error.
>> Acquire a per-page map_lock.
>> Release the per-page map_lock on the kunmap().
>>
>> The current patch set provides helpers to change the page from private to
>> shared. Enhance the helpers to check for the per-page map_lock, if the
>> map_lock is held then do not allow changing the page from shared to private.
> 
> That could work for the kmap() context.
> What to do for the userspace context (host userspace)?
> - shared->private transition - page has to be unmapped from all userspace,
> elevated refcount (gup() in progress) can block this unmap until it goes
> away - could be doable

An unmap of the page from all the userspace process during the page 
state transition will be great. If we can somehow store the state 
information in the 'struct page' then it can be later used to make 
better decision. I am not sure that relying on the elevated refcount is 
the correct approach. e.g in the case of encrypted guests, the HV may 
pin the page to prevent it from migration.

Thoughts on how you want to approach unmaping the page from userspace 
page table?


> - still, what to do if host userspace then tries to access the unmapped
> page? SIGSEGV instead of SIGBUS and it can recover?
> 

Yes, SIGSEGV makes sense to me.


> 
> 
>> Thoughts ?
>>
>>>
>>> This should turn an RMP fault in the kernel which is not covered in the
>>> uaccess exception table into a fatal error.
>>>
>>> Regards,
>>>
> 
