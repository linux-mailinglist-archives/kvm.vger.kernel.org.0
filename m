Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A3B366B6D
	for <lists+kvm@lfdr.de>; Wed, 21 Apr 2021 14:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238938AbhDUNAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 09:00:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:57428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238694AbhDUNAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 09:00:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 61567ACC5;
        Wed, 21 Apr 2021 12:59:48 +0000 (UTC)
Subject: Re: [RFC Part2 PATCH 07/30] mm: add support to split the large THP
 based on RMP violation
To:     Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-8-brijesh.singh@amd.com>
 <0edd1350-4865-dd71-5c14-3d57c784d62d@intel.com>
 <86c9d9db-a881-efa4-c937-12fc62ce97e8@amd.com>
 <f8bf7e26-26dc-e19a-007c-40b26e0a0a45@intel.com>
From:   Vlastimil Babka <vbabka@suse.cz>
Message-ID: <55445efd-dc29-3693-a189-710c8a61dec2@suse.cz>
Date:   Wed, 21 Apr 2021 14:59:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <f8bf7e26-26dc-e19a-007c-40b26e0a0a45@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/25/21 4:59 PM, Dave Hansen wrote:
> On 3/25/21 8:24 AM, Brijesh Singh wrote:
>> On 3/25/21 9:48 AM, Dave Hansen wrote:
>>> On 3/24/21 10:04 AM, Brijesh Singh wrote:
>>>> When SEV-SNP is enabled globally in the system, a write from the hypervisor
>>>> can raise an RMP violation. We can resolve the RMP violation by splitting
>>>> the virtual address to a lower page level.
>>>>
>>>> e.g
>>>> - guest made a page shared in the RMP entry so that the hypervisor
>>>>   can write to it.
>>>> - the hypervisor has mapped the pfn as a large page. A write access
>>>>   will cause an RMP violation if one of the pages within the 2MB region
>>>>   is a guest private page.
>>>>
>>>> The above RMP violation can be resolved by simply splitting the large
>>>> page.
>>> What if the large page is provided by hugetlbfs?
>> I was not able to find a method to split the large pages in the
>> hugetlbfs. Unfortunately, at this time a VMM cannot use the backing
>> memory from the hugetlbfs pool. An SEV-SNP aware VMM can use either
>> transparent hugepage or small pages.
> 
> That's really, really nasty.  Especially since it might not be evident
> until long after boot and the guest is killed.

I'd assume a SNP-aware QEMU would be needed in the first place and thus this
QEMU would know not to use hugetlbfs?

> It's even nastier because hugetlbfs is actually a great fit for SEV-SNP
> memory.  It's physically contiguous, so it would keep you from having to

Maybe this could be solvable by remapping the hugetlbfs page with pte's when
needed (a guest wants to share 4k out of 2MB with the host temporarily). But
certainly never as flexibly as pte-mapped THP's as the complexity of that
(refcounting tail pages etc) is significant.

> fracture the direct map all the way down to 4k, it also can't be
> reclaimed (just like all SEV memory).

About that... the whitepaper I've seen [1] mentions support for swapping guest
pages. I'd expect the same mechanism could be used for their migration -
scattering 4kB unmovable SEV pages around would be terrible for fragmentation. I
assume neither swap or migration support is part of the patchset(s) yet?

> I think the minimal thing you can do here is to fail to add memory to
> the RMP in the first place if you can't split it.  That way, users will
> at least fail to _start_ their VM versus dying randomly for no good reason.
> 
> Even better would be to come up with a stronger contract between host
> and guest.  I really don't think the host should be exposed to random
> RMP faults on the direct map.  If the guest wants to share memory, then
> it needs to tell the host and give the host an opportunity to move the
> guest physical memory.  It might, for instance, sequester all the shared
> pages in a single spot to minimize direct map fragmentation.

Agreed, and the contract should be elaborated before going to implementation
details (patches). Could a malicious guest violate such contract unilaterally? I
guess not, because psmash is a hypervisor instruction? And if yes, the
RMP-specific page fault handlers would be used just to kill such guest, not to
fix things up during page fault.

> I'll let the other x86 folks chime in on this, but I really think this
> needs a different approach than what's being proposed.

Not an x86 folk, but agreed :)

[1]
https://www.amd.com/system/files/TechDocs/SEV-SNP-strengthening-vm-isolation-with-integrity-protection-and-more.pdf
