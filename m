Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB7ED3FDF97
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 18:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbhIAQR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 12:17:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41901 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245165AbhIAQR6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 1 Sep 2021 12:17:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630513021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2/XAbNnPYbzrcRQvqGw+pEXzeCPLNq2oeqtLtsfAKPg=;
        b=NybpK+7+xULzUDlAuxFx+CkXtixjaUqBC0KRmszjt6qLBBrvPEXlzH7cxBIz9UZBoeJpRC
        Qg6NXXaJCIEvEE3PJ5j7fxIRE6rBIOgIxfmUG2pbGwFyf7yh+QnSGKa9h84us3aHYDURlz
        vqi2aVOwUAK3zQXvn44YejVk6WtEBdI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-HlS6I0MKM8eZ2EYFjbVHvQ-1; Wed, 01 Sep 2021 12:17:00 -0400
X-MC-Unique: HlS6I0MKM8eZ2EYFjbVHvQ-1
Received: by mail-wm1-f69.google.com with SMTP id r4-20020a1c4404000000b002e728beb9fbso16957wma.9
        for <kvm@vger.kernel.org>; Wed, 01 Sep 2021 09:16:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=2/XAbNnPYbzrcRQvqGw+pEXzeCPLNq2oeqtLtsfAKPg=;
        b=k7UFVGKpeS3aMZpUQxT7vYHmpV52VyBEbfdJOCxzgW+tL1HNbVihM3QJdmqAP/AjDi
         VO+EsSXqfKoaZeucDU0qLnRqFaltMraAOz41PdjaTU0c00t6S8i/zwZi03crUWT+v/jK
         Cv5gVwBdk8VxWDQNB7jNPDCZmKPyT6aS1v4qBNMkOsH7QVZd3TTbhRjrUnEap9nr2FWG
         SuR1s0eGlmHU9wQdsRJj/QdbMZblf9yjhjYu+5arxrXkVZFn/e/SksWcfnpFdWJfnOWf
         eP+vtuIPbIyob81py/TAZhwmSF8bJXeTefcjtPPo2v0F1idmnDokw98BzEeTCwRVd4Nv
         tXwg==
X-Gm-Message-State: AOAM532ke4gFmhChI9E1AGfibVLdqQQcz0fnU/3WGbVWsO3yrs4cudxE
        vfnuxtmieYB08X7yP4kiXLAdp0PddEqgmTDPuGEdJYlPN7AYjt2WmpwsBfUceG6W4VyNblbbA5l
        04PJD9taHbFnd
X-Received: by 2002:a7b:c447:: with SMTP id l7mr200559wmi.15.1630513018790;
        Wed, 01 Sep 2021 09:16:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzYF6rA5+Zro3A6/Y9cMEw/zmLGA0hRdVvAS0OCw0bzhechI4gs19V7p58fUfMs6FTavtZ2ig==
X-Received: by 2002:a7b:c447:: with SMTP id l7mr200513wmi.15.1630513018514;
        Wed, 01 Sep 2021 09:16:58 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23f71.dip0.t-ipconnect.de. [79.242.63.113])
        by smtp.gmail.com with ESMTPSA id u16sm3034wmc.41.2021.09.01.09.16.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 09:16:57 -0700 (PDT)
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     Andy Lutomirski <luto@kernel.org>,
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
        Tom Lendacky <thomas.lendacky@amd.com>,
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
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <37d70069-b59f-04c7-f9af-a08af18d0339@redhat.com>
Date:   Wed, 1 Sep 2021 18:16:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <9ec3636a-6434-4c98-9d8d-addc82858c41@www.fastmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.09.21 17:54, Andy Lutomirski wrote:
> On Wed, Sep 1, 2021, at 1:09 AM, David Hildenbrand wrote:
>>>> Do we have to protect from that? How would KVM protect from user space
>>>> replacing private pages by shared pages in any of the models we discuss?
>>>
>>> The overarching rule is that KVM needs to guarantee a given pfn is never mapped[*]
>>> as both private and shared, where "shared" also incorporates any mapping from the
>>> host.  Essentially it boils down to the kernel ensuring that a pfn is unmapped
>>> before it's converted to/from private, and KVM ensuring that it honors any
>>> unmap notifications from the kernel, e.g. via mmu_notifier or via a direct callback
>>> as proposed in this RFC.
>>
>> Okay, so the fallocate(PUNCHHOLE) from user space could trigger the
>> respective unmapping and freeing of backing storage.
>>
>>>
>>> As it pertains to PUNCH_HOLE, the responsibilities are no different than when the
>>> backing-store is destroyed; the backing-store needs to notify downstream MMUs
>>> (a.k.a. KVM) to unmap the pfn(s) before freeing the associated memory.
>>
>> Right.
>>
>>>
>>> [*] Whether or not the kernel's direct mapping needs to be removed is debatable,
>>>       but my argument is that that behavior is not visible to userspace and thus
>>>       out of scope for this discussion, e.g. zapping/restoring the direct map can
>>>       be added/removed without impacting the userspace ABI.
>>
>> Right. Removing it shouldn't also be requited IMHO. There are other ways
>> to teach the kernel to not read/write some online pages (filter
>> /proc/kcore, disable hibernation, strict access checks for /dev/mem ...).
>>
>>>
>>>>>> Define "ordinary" user memory slots as overlay on top of "encrypted" memory
>>>>>> slots.  Inside KVM, bail out if you encounter such a VMA inside a normal
>>>>>> user memory slot. When creating a "encryped" user memory slot, require that
>>>>>> the whole VMA is covered at creation time. You know the VMA can't change
>>>>>> later.
>>>>>
>>>>> This can work for the basic use cases, but even then I'd strongly prefer not to
>>>>> tie memslot correctness to the VMAs.  KVM doesn't truly care what lies behind
>>>>> the virtual address of a memslot, and when it does care, it tends to do poorly,
>>>>> e.g. see the whole PFNMAP snafu.  KVM cares about the pfn<->gfn mappings, and
>>>>> that's reflected in the infrastructure.  E.g. KVM relies on the mmu_notifiers
>>>>> to handle mprotect()/munmap()/etc...
>>>>
>>>> Right, and for the existing use cases this worked. But encrypted memory
>>>> breaks many assumptions we once made ...
>>>>
>>>> I have somewhat mixed feelings about pages that are mapped into $WHATEVER
>>>> page tables but not actually mapped into user space page tables. There is no
>>>> way to reach these via the rmap.
>>>>
>>>> We have something like that already via vfio. And that is fundamentally
>>>> broken when it comes to mmu notifiers, page pinning, page migration, ...
>>>
>>> I'm not super familiar with VFIO internals, but the idea with the fd-based
>>> approach is that the backing-store would be in direct communication with KVM and
>>> would handle those operations through that direct channel.
>>
>> Right. The problem I am seeing is that e.g., try_to_unmap() might not be
>> able to actually fully unmap a page, because some non-synchronized KVM
>> MMU still maps a page. It would be great to evaluate how the fd
>> callbacks would fit into the whole picture, including the current rmap.
>>
>> I guess I'm missing the bigger picture how it all fits together on the
>> !KVM side.
> 
> The big picture is fundamentally a bit nasty.  Logically (ignoring the implementation details of rmap, mmu_notifier, etc), you can call try_to_unmap and end up with a page that is Just A Bunch Of Bytes (tm).  Then you can write it to disk, memcpy to another node, compress it, etc. When it gets faulted back in, you make sure the same bytes end up somewhere and put the PTEs back.
> 
> With guest-private memory, this doesn't work.  Forget about the implementation: you simply can't take a page of private memory, quiesce it so the guest can't access it without faulting, and turn it into Just A Bunch Of Bytes.  TDX does not have that capability.  (Any system with integrity-protected memory won't without having >PAGE_SIZE bytes or otherwise storing metadata, but TDX can't do this at all.)  SEV-ES *can* (I think -- I asked the lead architect), but that's not the same thing as saying it's a good idea.
> 
> So if you want to migrate a TDX page from one NUMA node to another, you need to do something different (I don't know all the details), you will have to ask Intel to explain how this might work in the future (it wasn't in the public docs last time I looked), but I'm fairly confident that it does not resemble try_to_unmap().
> 
> Even on SEV, where a page *can* be transformed into a Just A Bunch Of Bytes, the operation doesn't really look like try_to_unmap().  As I understand it, it's more of:
> 
> look up the one-and-only guest and GPA at which this page is mapped.
> tear down the NPT PTE.  (SEV, unlike TDX, uses paging structures in normal memory.)
> Ask the magic SEV mechanism to turn the page into swappable data
> Go to town.
> 
> This doesn't really resemble the current rmap + mmu_notifier code, and shoehorning this into mmu_notifier seems like it may be uglier and more code than implementing it more directly in the backing store.
> 
> If you actually just try_to_unmap() a SEV-ES page (and it worked, which it currently won't), you will have data corruption or cache incoherency.
> 
> If you want to swap a page on TDX, you can't.  Sorry, go directly to jail, do not collect $200.
> 
> So I think there are literally zero code paths that currently call try_to_unmap() that will actually work like that on TDX.  If we run out of memory on a TDX host, we can kill the guest completely and reclaim all of its memory (which probably also involves killing QEMU or whatever other user program is in charge), but that's really our only option.

try_to_unmap() would actually do the right thing I think. It's the users 
that access page content (migration, swapping) that need additional care 
to special-case these pages. Completely agree that these would be broken.


-- 
Thanks,

David / dhildenb

