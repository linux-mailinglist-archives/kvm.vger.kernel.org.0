Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E644345913C
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 16:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbhKVP0t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 10:26:49 -0500
Received: from mail-sn1anam02on2076.outbound.protection.outlook.com ([40.107.96.76]:64749
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233449AbhKVP0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Nov 2021 10:26:49 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKHmwfEwLQmU/qeoehzVA7jPYCaqyAruxPhzVCmB2Neu2KeBoB06atjMP8FwYBD0n0Gnz4Xzp72bDXnwmR+izq+FFYmRFdaQzrOPjEGotkVz4wfPBYLc8BiS0crHSrSheMt7WZsJ12MEzXZPlJSQrz4Tvt12VYF952YCjNYQIaPdTX2aD6wge+8782U6fgsGpEMKJRLvNfR2bXu+RwjGKTByjNUfxSAd/VCdHIE3PGeB5EEncwahpmNS8YvjJdDTiH9V3ImD82VYvAhjpXtyFGHIEG78wkyiyVENqPT4OtKRHL3jmuYc7sTo+4YJ25HxkK4vQJyQm0ZAOlh9sO18lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oxGyQNIux0LSly6GGt9TFx0GnYrfVrg9Oy6X+1nlla0=;
 b=k9rcPxkYHj6UugKy3fpR3aj+i8dd4LyEBmdaUyd/NX+q2OVJZeYomvl16n8Q/OuPnapACco9dWEFkbhTccNLqfHYeE3JHSeTOq9TUzKCCLBIWTkkVZy56G/OWqgZng3PrTNh8stXxiDAMXA2sYWa8PJhy3+AIv8I3DdV1A5DAWFTh+ChN3A/TdBo+/dAMDABD/NHVqk1Uwe2c8P9h0X/LiCWw87n11nFPHaV5UVGEXzcxVvxw3CLEPle/hex7IL9YKm86PC226HCAfEHFZz/wxEwRkhtKUvu4dEWKGtQg2RSjE4Z/HKd11HbQJm3r9cYDXWD6k29crd0j+D7bdx4rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oxGyQNIux0LSly6GGt9TFx0GnYrfVrg9Oy6X+1nlla0=;
 b=KLng2ERdrSu6WPh+98J7e80AQ7EcNNvp85Dh6fIFjZiEPE6qfdCNWOL0kFbPD8SlYi+x5kJ57CwcCznoZp/nC8W3SGE2TwnyAsC7bBuaaF4VcL/WLdM7hqk6D872KhHwjysO91bm0nLHZEOMfpslowx774xO/HLq6hhxcnoe4fo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Mon, 22 Nov
 2021 15:23:41 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::e4da:b3ea:a3ec:761c%7]) with mapi id 15.20.4713.025; Mon, 22 Nov 2021
 15:23:40 +0000
Cc:     brijesh.singh@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
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
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Peter Gonda <pgonda@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
From:   Brijesh Singh <brijesh.singh@amd.com>
Message-ID: <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
Date:   Mon, 22 Nov 2021 09:23:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BL0PR02CA0058.namprd02.prod.outlook.com
 (2603:10b6:207:3d::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
Received: from [10.236.30.107] (165.204.77.1) by BL0PR02CA0058.namprd02.prod.outlook.com (2603:10b6:207:3d::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Mon, 22 Nov 2021 15:23:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c8f949bc-e0a2-419c-28ef-08d9adcc1029
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384912838E8F24520A36DE2E59F9@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6SqYNcaWw1LDrs9JhoyKQMSD6Yt5lD2QgKMydLLMdjPzp7XMsQUbrn4Qr2cPVUn1YmTTZBqu3B3lZzlF+uAndapyVLy71Nv5spojm6qES6BTsFFPBmyDfr/nyfSaHvw4aFaD1u01jpIvBupAfNgWhGkBhvfdTyAvECS1oZu5feIIw/kk43TP7D3NVxnEUYbcGsUmRnS+ERoS1If0ajcLEi6uuiHu9xX5+6bd9M5+pgWBQjbXEuyWKmCPBrGtNu3KKuBntjq1w698veJ5cpN82aU8uqWrXGBhtS7jBXaBgoKpLjf5s0mJQKUWL+pT7jI8i8SrJZk9Yw7uuTyjThlL+SvawKCv0Cy9DYqXteOk4YaIU6meleTQ3IddPSajoAVPzyaozztgj/4Yy/Pts/ktfA+lAkIMD9y8DF/KSfT9yFQckZruk7uxoxYkgKlcXOvJbb7Z/LphpfFE76412o+9WycPVxM44YDbMTcfv6v1veMuEpedXT8qy8Alst8XJKXwh7iD9BxCXfdsqU8Ae4fYv/KRlj0bQvnGvt3019kg1tkJ3g5VfBXjrc0OPu99X93dF/Dqvp8ORswLDNecb9sAjsrRANsmglNHlqkA85JSTKPRB5aBF4U0XvA5FeTA6zhnJeBndlgObRSEPiFWfRp4bpVnbYf4VdYySrzVXV3XS7KYJZNZ+IDT+KtWJuZHK/6PDfgf+0GH9yJg1JEQ8VIZcAssFQSGZ40fnj9babcRoSo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(508600001)(7406005)(2906002)(186003)(83380400001)(31686004)(316002)(30864003)(6916009)(44832011)(5660300002)(86362001)(26005)(38100700002)(66476007)(8936002)(7416002)(6486002)(53546011)(54906003)(2616005)(31696002)(66556008)(16576012)(36756003)(8676002)(4326008)(66946007)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WmlrN1VrYktOa1RoT2pORGd2YkVGeHJrOXFnaEkxOWNqaHJHZ3h4MjBhOHRq?=
 =?utf-8?B?VHdGY3pFbnh6Sys5OWpZR0lwNHJJN09lZE9QTXlCeW10Rkg5dm1SU2ZBUHpa?=
 =?utf-8?B?WGh1cC92RHg3TVV1L2N6OU5FOFZnZWV2cUhzdVpUSHZaUkYrOWNWWkpaMkox?=
 =?utf-8?B?NnZWaGFPSWhJVjN3V0hoNkdyNENKdDQ0UkFhaUtyaDViNGFxSzJldnJtbGxW?=
 =?utf-8?B?QXl5UnNRTU5TNWkyWjhVek1jQlNNKytsTjNTN2I3cW1WOVFmUFRYYzY4VjBT?=
 =?utf-8?B?bldIV1NuZzJRaGNjUWhPbGZnODdMeWJ1ZXFBbEZMTzQ4bE5PdE1kbjUzVndC?=
 =?utf-8?B?TzlWeXV2TEd4Y1BKenIxNE43TnRYMFA2QThmY0NGald6aU81aldXTzhTREpB?=
 =?utf-8?B?dEt0TU4wN0tyazBvWlZTREpVZi9Oc21ldDl2QUhLSktJaEsyNm1rRmMyUG9M?=
 =?utf-8?B?eEk2VzBoZDEveDdpem9QdS94b1gxZnJYNjlyOEhJSjk4cXdnUHdyTWk3blVE?=
 =?utf-8?B?WmE0a1FGYnh6eDNxVHBxY3JLeHEyRVliS1pEK3dCZ1FuME9ZMUhYYUZVcTBI?=
 =?utf-8?B?ZGE5Q0NZZTl2a0RQU01NU3ZVZ1ZDWlRuQXBBL09NZGFLMWNkMHg2Y3UyUDJ0?=
 =?utf-8?B?SFhCckZEWmdndFNyNStsWG85QXNwOVJkdzBoV1E3L3JuTllMbEtmY1VRdElv?=
 =?utf-8?B?WERZM0w5Rk44SWwrNjMyQ0NUTStPRlFIUWwzTmE4NTRYY0xlVUR3TkE1SFJs?=
 =?utf-8?B?MWRPT1pxVTJYRlp5NC9VRVdiWEdib1l1TnlJZ0tFRlR6SDhOc3h4aTFJK0NN?=
 =?utf-8?B?VXFQZTJRMUF1VEd1d0tiR1l1SCs3a05UWFgyenVWQzVraWdEK2c4TmNWRkJj?=
 =?utf-8?B?WjVuVExka01BRFJpVWdTNlZ2b2xYQ0c2cURWdFd3S3BFREZqNExzbUxjWm5H?=
 =?utf-8?B?WS9HbDVnQWVDNXFrTmxjbDg0dDErUUdLQ0dSWnlVSGFCZG1vQkkzOG9BOUsz?=
 =?utf-8?B?Ynl6Sk1USllKTzA1aWlSWGpzNUJ3T0tlM2RuajR0eWdldkR3YVNWRnlsYWRO?=
 =?utf-8?B?bkt6QnVCL1hlMVFoUXJHN0hkYzlIVTY2SHZDL2doN2h4RUU3TGw3dys4eFJ6?=
 =?utf-8?B?ZDltTzBxK2E1UktaNE9wQXMyNW1ncmtpelFDREhZdTcxQmFqQ01Cb2lLMEtH?=
 =?utf-8?B?Tk5reHA3MlQzbks4NVY0bThIRFAzdDIxbzVsY0FjNVpTZnVFMlJHeVRubnhZ?=
 =?utf-8?B?MlZsUktZL01MaEVkTTlKdFlHQmZXV2JXcGdWU2Y5eURNV3dWT1dYNmhMbmNV?=
 =?utf-8?B?SE9GVnZDZW01QWhxT1k4Z1JLbytwWjg1anNzek9ZR3pJOW55dHF1b0xWOFlN?=
 =?utf-8?B?UENIUlp2cFQxeEh6bnA0RmpHenY4NnU1RjRtUEw0Mk5XQVk5U3FiQU4zY3ZP?=
 =?utf-8?B?MUNpZTlKZmMrWFRGL2JhMmdiemRYQVNQcEdabDFmVGxVOUpMaVk1OFhqMGZ0?=
 =?utf-8?B?djltSWkvWEFENzBtVEtyb09yQmllNHAvdG80Y095djkyUEVjcThPeERobWtr?=
 =?utf-8?B?UWJXaWxFYURydnlZWmRNYUQrYkowdVQ4bW1RRWswK1FrZ0tGampkeXFYYXNk?=
 =?utf-8?B?K1NMTWUwRENYOHh6UGwvdWJzWmpISjBsVDN1SDgxZVBPNVB4UHNNRUFWbENw?=
 =?utf-8?B?eGx2R05wNGtmY1lUOFRRZU4yQWQvNDRHdk5kd29EY2RZdklrRVA2NFJBQ3Zu?=
 =?utf-8?B?RkYzM0FraklJUmdpOG1sOW9ldXdud0JEOWYwcS9LZWlNaFBFNGI0MEJETGdQ?=
 =?utf-8?B?VjJ5dXlTM2V3d3RnS29nMTB1eGZBOURMMGhUSTlqQnFuSE9sbUxFL2VQS3Ar?=
 =?utf-8?B?QmEyQ2ExcEVXZVhFNnZCaFFyM2duQlUxUU5IekdEZERET0pGSjQ1MUxzd212?=
 =?utf-8?B?L2wvckJZZzErbHNxYkJ1M09QUTU2QVdvZkdrNGpkQVVKVVlvaUluMVg2SWJo?=
 =?utf-8?B?eEFVVjcybk9IendTd25UNWhzWUVpVlZuaTdUcEtDYkNuLzlDTERrV2JmNm5R?=
 =?utf-8?B?U05qUE14UVgzTU1jaVc1SUNsVDVsQ0QwWVkya3orOE1MakMySThwMkpiWlJS?=
 =?utf-8?B?dzFpYUk2dWx5ZzhzenVqV24yQWlwc1FPNVh2MnNIWkpkRkhqQU8zbGw5RjhV?=
 =?utf-8?Q?Pfc/vBAajiZCPWLngIu9AYU=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8f949bc-e0a2-419c-28ef-08d9adcc1029
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 15:23:40.8480
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lOAe7vMuL6tAdS2dlchqlrYrRgnFP0eoR8+5CWyo9QHxFOLBTRSrflkv9OAI4pSE//yYrqp814Cy/8gZxbK4WA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On 11/12/21 9:43 AM, Peter Gonda wrote:
> Hi Brijesh,,
> 
> One high level discussion I'd like to have on these SNP KVM patches.
> 
> In these patches (V5) if a host userspace process writes a guest
> private page a SIGBUS is issued to that process. If the kernel writes
> a guest private page then the kernel panics due to the unhandled RMP
> fault page fault. This is an issue because not all writes into guest
> memory may come from a bug in the host. For instance a malicious or
> even buggy guest could easily point the host to writing a private page
> during the emulation of many virtual devices (virtio, NVMe, etc). For
> example if a well behaved guests behavior is to: start up a driver,
> select some pages to share with the guest, ask the host to convert
> them to shared, then use those pages for virtual device DMA, if a
> buggy guest forget the step to request the pages be converted to
> shared its easy to see how the host could rightfully write to private
> memory. I think we can better guarantee host reliability when running
> SNP guests without changing SNP’s security properties.
> 
> Here is an alternative to the current approach: On RMP violation (host
> or userspace) the page fault handler converts the page from private to
> shared to allow the write to continue. This pulls from s390’s error
> handling which does exactly this. See ‘arch_make_page_accessible()’.
> Additionally it adds less complexity to the SNP kernel patches, and
> requires no new ABI.
> 
> In the current (V5) KVM implementation if a userspace process
> generates an RMP violation (writes to guest private memory) the
> process receives a SIGBUS. At first glance, it would appear that
> user-space shouldn’t write to private memory. However, guaranteeing
> this in a generic fashion requires locking the RMP entries (via locks
> external to the RMP). Otherwise, a user-space process emulating a
> guest device IO may be vulnerable to having the guest memory
> (maliciously or by guest bug) converted to private while user-space
> emulation is happening. This results in a well behaved userspace
> process receiving a SIGBUS.
> 
> This proposal allows buggy and malicious guests to run under SNP
> without jeopardizing the reliability / safety of host processes. This
> is very important to a cloud service provider (CSP) since it’s common
> to have host wide daemons that write/read all guests, i.e. a single
> process could manage the networking for all VMs on the host. Crashing
> that singleton process kills networking for all VMs on the system.
> 
Thank you for starting the thread; based on the discussion, I am keeping 
the current implementation as-is and *not* going with the auto 
conversion from private to shared. To summarize what we are doing in the 
current SNP series:

- If userspace accesses guest private memory, it gets SIGBUS.
- If kernel accesses[*] guest private memory, it does panic.

[*] Kernel consults the RMP table for the page ownership before the 
access. If the page is shared, then it uses the locking mechanism to 
ensure that a guest will not be able to change the page ownership while 
kernel has it mapped.

thanks

> This proposal also allows for minimal changes to the kexec flow and
> kdump. The new kexec kernel can simply update private pages to shared
> as it encounters them during their boot. This avoids needing to
> propagate the RMP state from kernel to kernel. Of course this doesn’t
> preserve any running VMs but is still useful for kdump crash dumps or
> quicker rekerneling for development with kexec.
> 
> This proposal does cause guest memory corruption for some bugs but one
> of SEV-SNP’s goals extended from SEV-ES’s goals is for guest’s to be
> able to detect when its memory has been corrupted / replayed by the
> host. So SNP already has features for allowing guests to detect this
> kind of memory corruption. Additionally this is very similar to a page
> of memory generating a machine check because of 2-bit memory
> corruption. In other words SNP guests must be enlightened and ready
> for these kinds of errors.
> 
> For an SNP guest running under this proposal the flow would look like this:
> * Host gets a #PF because its trying to write to a private page.
> * Host #PF handler updates the page to shared.
> * Write continues normally.
> * Guest accesses memory (r/w).
> * Guest gets a #VC error because the page is not PVALIDATED
> * Guest is now in control. Guest can terminate because its memory has
> been corrupted. Guest could try and continue to log the error to its
> owner.
> 
> A similar approach was introduced in the SNP patches V1 and V2 for
> kernel page fault handling. The pushback around this convert to shared
> approach was largely focused around the idea that the kernel has all
> the information about which pages are shared vs private so it should
> be able to check shared status before write to pages. After V2 the
> patches were updated to not have a kernel page fault handler for RMP
> violations (other than dumping state during a panic). The current
> patches protect the host with new post_{map,unmap}_gfn() function that
> checks if a page is shared before mapping it, then locks the page
> shared until unmapped. Given the discussions on ‘[Part2,v5,39/45] KVM:
> SVM: Introduce ops for the post gfn map and unmap’ building a solution
> to do this is non trivial and adds new overheads to KVM. Additionally
> the current solution is local to the kernel. So a new ABI just now be
> created to allow the userspace VMM to access the kernel-side locks for
> this to work generically for the whole host. This is more complicated
> than this proposal and adding more lock holders seems like it could
> reduce performance further.
> 
> There are a couple corner cases with this approach. Under SNP guests
> can request their memory be changed into a VMSA. This VMSA page cannot
> be changed to shared while the vCPU associated with it is running. So
> KVM + the #PF handler will need something to kick vCPUs from running.
> Joerg believes that a possible fix for this could be a new MMU
> notifier in the kernel, then on the #PF we can go through the rmp and
> execute this vCPU kick callback.
> 
> Another corner case is the RMPUPDATE instruction is not guaranteed to
> succeed on first iteration. As noted above if the page is a VMSA it
> cannot be updated while the vCPU is running. Another issue is if the
> guest is running a RMPADJUST on a page it cannot be RMPUPDATED at that
> time. There is a lock for each RMP Entry so there is a race for these
> instructions. The vCPU kicking can solve this issue to be kicking all
> guest vCPUs which removes the chance for the race.
> 
> Since this proposal probably results in SNP guests terminating due to
> a page unexpectedly needing PVALIDATE. The approach could be
> simplified to just the KVM killing the guest. I think it's nicer to
> users to instead of unilaterally killing the guest allowing the
> unvalidated #VC exception to allow users to collect some additional
> debug information and any additional clean up work they would like to
> perform.
> 
> Thanks
> Peter
> 
> On Fri, Aug 20, 2021 at 9:59 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
>>
>> This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
>> changes required in a host OS for SEV-SNP support. The series builds upon
>> SEV-SNP Part-1.
>>
>> This series provides the basic building blocks to support booting the SEV-SNP
>> VMs, it does not cover all the security enhancement introduced by the SEV-SNP
>> such as interrupt protection.
>>
>> The CCP driver is enhanced to provide new APIs that use the SEV-SNP
>> specific commands defined in the SEV-SNP firmware specification. The KVM
>> driver uses those APIs to create and managed the SEV-SNP guests.
>>
>> The GHCB specification version 2 introduces new set of NAE's that is
>> used by the SEV-SNP guest to communicate with the hypervisor. The series
>> provides support to handle the following new NAE events:
>> - Register GHCB GPA
>> - Page State Change Request
>> - Hypevisor feature
>> - Guest message request
>>
>> The RMP check is enforced as soon as SEV-SNP is enabled. Not every memory
>> access requires an RMP check. In particular, the read accesses from the
>> hypervisor do not require RMP checks because the data confidentiality is
>> already protected via memory encryption. When hardware encounters an RMP
>> checks failure, it raises a page-fault exception. If RMP check failure
>> is due to the page-size mismatch, then split the large page to resolve
>> the fault.
>>
>> The series does not provide support for the interrupt security and migration
>> and those feature will be added after the base support.
>>
>> The series is based on the commit:
>>   SNP part1 commit and
>>   fa7a549d321a (kvm/next, next) KVM: x86: accept userspace interrupt only if no event is injected
>>
>> TODO:
>>    * Add support for command to ratelimit the guest message request.
>>
>> Changes since v4:
>>   * Move the RMP entry definition to x86 specific header file.
>>   * Move the dump RMP entry function to SEV specific file.
>>   * Use BIT_ULL while defining the #PF bit fields.
>>   * Add helper function to check the IOMMU support for SEV-SNP feature.
>>   * Add helper functions for the page state transition.
>>   * Map and unmap the pages from the direct map after page is added or
>>     removed in RMP table.
>>   * Enforce the minimum SEV-SNP firmware version.
>>   * Extend the LAUNCH_UPDATE to accept the base_gfn and remove the
>>     logic to calculate the gfn from the hva.
>>   * Add a check in LAUNCH_UPDATE to ensure that all the pages are
>>     shared before calling the PSP.
>>   * Mark the memory failure when failing to remove the page from the
>>     RMP table or clearing the immutable bit.
>>   * Exclude the encrypted hva range from the KSM.
>>   * Remove the gfn tracking during the kvm_gfn_map() and use SRCU to
>>     syncronize the PSC and gfn mapping.
>>   * Allow PSC on the registered hva range only.
>>   * Add support for the Preferred GPA VMGEXIT.
>>   * Simplify the PSC handling routines.
>>   * Use the static_call() for the newly added kvm_x86_ops.
>>   * Remove the long-lived GHCB map.
>>   * Move the snp enable module parameter to the end of the file.
>>   * Remove the kvm_x86_op for the RMP fault handling. Call the
>>     fault handler directly from the #NPF interception.
>>
>> Changes since v3:
>>   * Add support for extended guest message request.
>>   * Add ioctl to query the SNP Platform status.
>>   * Add ioctl to get and set the SNP config.
>>   * Add check to verify that memory reserved for the RMP covers the full system RAM.
>>   * Start the SNP specific commands from 256 instead of 255.
>>   * Multiple cleanup and fixes based on the review feedback.
>>
>> Changes since v2:
>>   * Add AP creation support.
>>   * Drop the patch to handle the RMP fault for the kernel address.
>>   * Add functions to track the write access from the hypervisor.
>>   * Do not enable the SNP feature when IOMMU is disabled or is in passthrough mode.
>>   * Dump the RMP entry on RMP violation for the debug.
>>   * Shorten the GHCB macro names.
>>   * Start the SNP_INIT command id from 255 to give some gap for the legacy SEV.
>>   * Sync the header with the latest 0.9 SNP spec.
>>
>> Changes since v1:
>>   * Add AP reset MSR protocol VMGEXIT NAE.
>>   * Add Hypervisor features VMGEXIT NAE.
>>   * Move the RMP table initialization and RMPUPDATE/PSMASH helper in
>>     arch/x86/kernel/sev.c.
>>   * Add support to map/unmap SEV legacy command buffer to firmware state when
>>     SNP is active.
>>   * Enhance PSP driver to provide helper to allocate/free memory used for the
>>     firmware context page.
>>   * Add support to handle RMP fault for the kernel address.
>>   * Add support to handle GUEST_REQUEST NAE event for attestation.
>>   * Rename RMP table lookup helper.
>>   * Drop typedef from rmpentry struct definition.
>>   * Drop SNP static key and use cpu_feature_enabled() to check whether SEV-SNP
>>     is active.
>>   * Multiple cleanup/fixes to address Boris review feedback.
>>
>> Brijesh Singh (40):
>>    x86/cpufeatures: Add SEV-SNP CPU feature
>>    iommu/amd: Introduce function to check SEV-SNP support
>>    x86/sev: Add the host SEV-SNP initialization support
>>    x86/sev: Add RMP entry lookup helpers
>>    x86/sev: Add helper functions for RMPUPDATE and PSMASH instruction
>>    x86/sev: Invalid pages from direct map when adding it to RMP table
>>    x86/traps: Define RMP violation #PF error code
>>    x86/fault: Add support to handle the RMP fault for user address
>>    x86/fault: Add support to dump RMP entry on fault
>>    crypto: ccp: shutdown SEV firmware on kexec
>>    crypto:ccp: Define the SEV-SNP commands
>>    crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP
>>    crypto:ccp: Provide APIs to issue SEV-SNP commands
>>    crypto: ccp: Handle the legacy TMR allocation when SNP is enabled
>>    crypto: ccp: Handle the legacy SEV command when SNP is enabled
>>    crypto: ccp: Add the SNP_PLATFORM_STATUS command
>>    crypto: ccp: Add the SNP_{SET,GET}_EXT_CONFIG command
>>    crypto: ccp: Provide APIs to query extended attestation report
>>    KVM: SVM: Provide the Hypervisor Feature support VMGEXIT
>>    KVM: SVM: Make AVIC backing, VMSA and VMCB memory allocation SNP safe
>>    KVM: SVM: Add initial SEV-SNP support
>>    KVM: SVM: Add KVM_SNP_INIT command
>>    KVM: SVM: Add KVM_SEV_SNP_LAUNCH_START command
>>    KVM: SVM: Add KVM_SEV_SNP_LAUNCH_UPDATE command
>>    KVM: SVM: Mark the private vma unmerable for SEV-SNP guests
>>    KVM: SVM: Add KVM_SEV_SNP_LAUNCH_FINISH command
>>    KVM: X86: Keep the NPT and RMP page level in sync
>>    KVM: x86: Introduce kvm_mmu_get_tdp_walk() for SEV-SNP use
>>    KVM: x86: Define RMP page fault error bits for #NPF
>>    KVM: x86: Update page-fault trace to log full 64-bit error code
>>    KVM: SVM: Do not use long-lived GHCB map while setting scratch area
>>    KVM: SVM: Remove the long-lived GHCB host map
>>    KVM: SVM: Add support to handle GHCB GPA register VMGEXIT
>>    KVM: SVM: Add support to handle MSR based Page State Change VMGEXIT
>>    KVM: SVM: Add support to handle Page State Change VMGEXIT
>>    KVM: SVM: Introduce ops for the post gfn map and unmap
>>    KVM: x86: Export the kvm_zap_gfn_range() for the SNP use
>>    KVM: SVM: Add support to handle the RMP nested page fault
>>    KVM: SVM: Provide support for SNP_GUEST_REQUEST NAE event
>>    KVM: SVM: Add module parameter to enable the SEV-SNP
>>
>> Sean Christopherson (2):
>>    KVM: x86/mmu: Move 'pfn' variable to caller of direct_page_fault()
>>    KVM: x86/mmu: Introduce kvm_mmu_map_tdp_page() for use by TDX and SNP
>>
>> Tom Lendacky (3):
>>    KVM: SVM: Add support to handle AP reset MSR protocol
>>    KVM: SVM: Use a VMSA physical address variable for populating VMCB
>>    KVM: SVM: Support SEV-SNP AP Creation NAE event
>>
>>   Documentation/virt/coco/sevguest.rst          |   55 +
>>   .../virt/kvm/amd-memory-encryption.rst        |  102 +
>>   arch/x86/include/asm/cpufeatures.h            |    1 +
>>   arch/x86/include/asm/disabled-features.h      |    8 +-
>>   arch/x86/include/asm/kvm-x86-ops.h            |    5 +
>>   arch/x86/include/asm/kvm_host.h               |   20 +
>>   arch/x86/include/asm/msr-index.h              |    6 +
>>   arch/x86/include/asm/sev-common.h             |   28 +
>>   arch/x86/include/asm/sev.h                    |   45 +
>>   arch/x86/include/asm/svm.h                    |    7 +
>>   arch/x86/include/asm/trap_pf.h                |   18 +-
>>   arch/x86/kernel/cpu/amd.c                     |    3 +-
>>   arch/x86/kernel/sev.c                         |  361 ++++
>>   arch/x86/kvm/lapic.c                          |    5 +-
>>   arch/x86/kvm/mmu.h                            |    7 +-
>>   arch/x86/kvm/mmu/mmu.c                        |   84 +-
>>   arch/x86/kvm/svm/sev.c                        | 1676 ++++++++++++++++-
>>   arch/x86/kvm/svm/svm.c                        |   62 +-
>>   arch/x86/kvm/svm/svm.h                        |   74 +-
>>   arch/x86/kvm/trace.h                          |   40 +-
>>   arch/x86/kvm/x86.c                            |   92 +-
>>   arch/x86/mm/fault.c                           |   84 +-
>>   drivers/crypto/ccp/sev-dev.c                  |  924 ++++++++-
>>   drivers/crypto/ccp/sev-dev.h                  |   17 +
>>   drivers/crypto/ccp/sp-pci.c                   |   12 +
>>   drivers/iommu/amd/init.c                      |   30 +
>>   include/linux/iommu.h                         |    9 +
>>   include/linux/mm.h                            |    6 +-
>>   include/linux/psp-sev.h                       |  346 ++++
>>   include/linux/sev.h                           |   32 +
>>   include/uapi/linux/kvm.h                      |   56 +
>>   include/uapi/linux/psp-sev.h                  |   60 +
>>   mm/memory.c                                   |   13 +
>>   tools/arch/x86/include/asm/cpufeatures.h      |    1 +
>>   34 files changed, 4088 insertions(+), 201 deletions(-)
>>   create mode 100644 include/linux/sev.h
>>
>> --
>> 2.17.1
>>
