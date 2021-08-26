Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562F43F8CAE
	for <lists+kvm@lfdr.de>; Thu, 26 Aug 2021 19:05:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243205AbhHZRGD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 13:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229986AbhHZRGC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 13:06:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F45060FD8;
        Thu, 26 Aug 2021 17:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629997514;
        bh=GMRc/UoL5G7CQp3zkPu976lrK1e8M+M7RbstoXHsrm0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=KiWfUX40fAezut8F6rVcyabKLXFDS3HF6Wqm165FrI/XgzWKtO/EdBl/FyadGLtD0
         ci03kqBcIFMJG64fCOVHOm963L1Cb1Lvg/GjKtA9/34v5JMiQcB69ZddM1/LTeMdYT
         uBw2wcV/m10vXVZpf3G1Q9+mpbYgiXeqjtR7nQ0QwTNHIgWqkVF++1hLcQBsO7q4T7
         Ex383NNR2rNq0W6EICSasneTv1rbgq78aYRxlEUUoeIl8jnuzzSHNsX7PNgWxamAON
         QopSX2nQIAxMCI2efWEmN4CFXvANM4YR2H1FuUip9/9ejETPalWbswZbmb9E4WISrt
         +SMAX7bmgB5mg==
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <40af9d25-c854-8846-fdab-13fe70b3b279@kernel.org>
Date:   Thu, 26 Aug 2021 10:05:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/26/21 3:15 AM, David Hildenbrand wrote:
> On 24.08.21 02:52, Sean Christopherson wrote:
>> The goal of this RFC is to try and align KVM, mm, and anyone else with
>> skin in the
>> game, on an acceptable direction for supporting guest private memory,
>> e.g. for
>> Intel's TDX.  The TDX architectural effectively allows KVM guests to
>> crash the
>> host if guest private memory is accessible to host userspace, and thus
>> does not
>> play nice with KVM's existing approach of pulling the pfn and mapping
>> level from
>> the host page tables.
>>
>> This is by no means a complete patch; it's a rough sketch of the KVM
>> changes that
>> would be needed.  The kernel side of things is completely omitted from
>> the patch;
>> the design concept is below.
>>
>> There's also fair bit of hand waving on implementation details that
>> shouldn't
>> fundamentally change the overall ABI, e.g. how the backing store will
>> ensure
>> there are no mappings when "converting" to guest private.
>>
> 
> This is a lot of complexity and rather advanced approaches (not saying
> they are bad, just that we try to teach the whole stack something
> completely new).
> 
> 
> What I think would really help is a list of requirements, such that
> everybody is aware of what we actually want to achieve. Let me start:
> 
> GFN: Guest Frame Number
> EPFN: Encrypted Physical Frame Number
> 
> 
> 1) An EPFN must not get mapped into more than one VM: it belongs exactly
> to one VM. It must neither be shared between VMs between processes nor
> between VMs within a processes.
> 
> 
> 2) User space (well, and actually the kernel) must never access an EPFN:
> 
> - If we go for an fd, essentially all operations (read/write) have to
>   fail.
> - If we have to map an EPFN into user space page tables (e.g., to
>   simplify KVM), we could only allow fake swap entries such that "there
>   is something" but it cannot be  accessed and is flagged accordingly.
> - /proc/kcore and friends have to be careful as well and should not read
>   this memory. So there has to be a way to flag these pages.
> 
> 3) We need a way to express the GFN<->EPFN mapping and essentially
> assign an EPFN to a GFN.
> 
> 
> 4) Once we assigned a EPFN to a GFN, that assignment must not longer
> change. Further, an EPFN must not get assigned to multiple GFNs.
> 
> 
> 5) There has to be a way to "replace" encrypted parts by "shared" parts
>    and the other way around.
> 
> What else?
> 
> 
> 
>> Background
>> ==========
>>
>> This is a loose continuation of Kirill's RFC[*] to support TDX guest
>> private
>> memory by tracking guest memory at the 'struct page' level.  This
>> proposal is the
>> result of several offline discussions that were prompted by Andy
>> Lutomirksi's
>> concerns with tracking via 'struct page':
>>
>>    1. The kernel wouldn't easily be able to enforce a 1:1 page:guest
>> association,
>>       let alone a 1:1 pfn:gfn mapping.
> 
> Well, it could with some help on higher layers. Someone has to do the
> tracking. Marking EPFNs as EPFNs can actually be very helpful,  e.g.,
> allow /proc/kcore to just not touch such pages. If we want to do all the
> tracking in the struct page is a different story.
> 
>>
>>    2. Does not work for memory that isn't backed by 'struct page',
>> e.g. if devices
>>       gain support for exposing encrypted memory regions to guests.
> 
> Let's keep it simple. If a struct page is right now what we need to
> properly track it, so be it. If not, good. But let's not make this a
> requirement right from the start if it's stuff for the far future.
> 
>>
>>    3. Does not help march toward page migration or swap support
>> (though it doesn't
>>       hurt either).
> 
> "Does not help towards world peace, (though it doesn't hurt either)".
> 
> Maybe let's ignore that for now, as it doesn't seem to be required to
> get something reasonable running.
> 
>>
>> [*]
>> https://lkml.kernel.org/r/20210416154106.23721-1-kirill.shutemov@linux.intel.com
>>
>>
>> Concept
>> =======
>>
>> Guest private memory must be backed by an "enlightened" file
>> descriptor, where
>> "enlightened" means the implementing subsystem supports a one-way
>> "conversion" to
>> guest private memory and provides bi-directional hooks to communicate
>> directly
>> with KVM.  Creating a private fd doesn't necessarily have to be a
>> conversion, e.g. it
>> could also be a flag provided at file creation, a property of the file
>> system itself,
>> etc...
> 
> Doesn't sound too crazy. Maybe even introducing memfd_encrypted() if
> extending the other ones turns out too complicated.
> 
>>
>> Before a private fd can be mapped into a KVM guest, it must be paired
>> 1:1 with a
>> KVM guest, i.e. multiple guests cannot share a fd.  At pairing, KVM
>> and the fd's
>> subsystem exchange a set of function pointers to allow KVM to call
>> into the subsystem,
>> e.g. to translate gfn->pfn, and vice versa to allow the subsystem to
>> call into KVM,
>> e.g. to invalidate/move/swap a gfn range.
>>
>> Mapping a private fd in host userspace is disallowed, i.e. there is
>> never a host
>> virtual address associated with the fd and thus no userspace page
>> tables pointing
>> at the private memory.
> 
> To keep the primary vs. secondary MMU thing working, I think it would
> actually be nice to go with special swap entries instead; it just keeps
> most things working as expected. But let's see where we end up.
> 
>>
>> Pinning _from KVM_ is not required.  If the backing store supports
>> page migration
>> and/or swap, it can query the KVM-provided function pointers to see if
>> KVM supports
>> the operation.  If the operation is not supported (this will be the
>> case initially
>> in KVM), the backing store is responsible for ensuring correct
>> functionality.
>>
>> Unmapping guest memory, e.g. to prevent use-after-free, is handled via
>> a callback
>> from the backing store to KVM.  KVM will employ techniques similar to
>> those it uses
>> for mmu_notifiers to ensure the guest cannot access freed memory.
>>
>> A key point is that, unlike similar failed proposals of the past, e.g.
>> /dev/mktme,
>> existing backing stores can be englightened, a from-scratch
>> implementations is not
>> required (though would obviously be possible as well).
> 
> Right. But if it's just a bad fit, let's do something new. Just like we
> did with memfd_secret.
> 
>>
>> One idea for extending existing backing stores, e.g. HugeTLBFS and
>> tmpfs, is
>> to add F_SEAL_GUEST, which would convert the entire file to guest
>> private memory
>> and either fail if the current size is non-zero or truncate the size
>> to zero.
> 
> While possible, I actually do have the feeling that we want eventually
> to have something new, as the semantics are just too different. But
> let's see.
> 
> 
>> KVM
>> ===
>>
>> Guest private memory is managed as a new address space, i.e. as a
>> different set of
>> memslots, similar to how KVM has a separate memory view for when a
>> guest vCPU is
>> executing in virtual SMM.  SMM is mutually exclusive with guest
>> private memory.
>>
>> The fd (the actual integer) is provided to KVM when a private memslot
>> is added
>> via KVM_SET_USER_MEMORY_REGION.  This is when the aforementioned
>> pairing occurs.
>>
>> By default, KVM memslot lookups will be "shared", only specific
>> touchpoints will
>> be modified to work with private memslots, e.g. guest page faults. 
>> All host
>> accesses to guest memory, e.g. for emulation, will thus look for
>> shared memory
>> and naturally fail without attempting copy_to/from_user() if the guest
>> attempts
>> to coerce KVM into access private memory.  Note, avoiding
>> copy_to/from_user() and
>> friends isn't strictly necessary, it's more of a happy side effect.
>>
>> A new KVM exit reason, e.g. KVM_EXIT_MEMORY_ERROR, and data struct in
>> vcpu->run
>> is added to propagate illegal accesses (see above) and implicit
>> conversions
>> to userspace (see below).  Note, the new exit reason + struct can also
>> be to
>> support several other feature requests in KVM[1][2].
>>
>> The guest may explicitly or implicity request KVM to map a
>> shared/private variant
>> of a GFN.  An explicit map request is done via hypercall (out of scope
>> for this
>> proposal as both TDX and SNP ABIs define such a hypercall).  An
>> implicit map request
>> is triggered simply by the guest accessing the shared/private variant,
>> which KVM
>> sees as a guest page fault (EPT violation or #NPF).  Ideally only
>> explicit requests
>> would be supported, but neither TDX nor SNP require this in their
>> guest<->host ABIs.
>>
>> For implicit or explicit mappings, if a memslot is found that fully
>> covers the
>> requested range (which is a single gfn for implicit mappings), KVM's
>> normal guest
>> page fault handling works with minimal modification.
>>
>> If a memslot is not found, for explicit mappings, KVM will exit to
>> userspace with
>> the aforementioned dedicated exit reason.  For implict _private_
>> mappings, KVM will
>> also immediately exit with the same dedicated reason.  For implicit
>> shared mappings,
>> an additional check is required to differentiate between emulated MMIO
>> and an
>> implicit private->shared conversion[*].  If there is an existing
>> private memslot
>> for the gfn, KVM will exit to userspace, otherwise KVM will treat the
>> access as an
>> emulated MMIO access and handle the page fault accordingly.
> 
> Do you mean some kind of overlay. "Ordinary" user memory regions overlay
> "private user memory regions"? So when marking something shared, you'd
> leave the private user memory region alone and only create a new
> "ordinary"user memory regions that references shared memory in QEMU
> (IOW, a different mapping)?
> 
> Reading below, I think you were not actually thinking about an overlay,
> but maybe overlays might actually be a nice concept to have instead.
> 
> 
>> Punching Holes
>> ==============
>>
>> The expected userspace memory model is that mapping requests will be
>> handled as
>> conversions, e.g. on a shared mapping request, first unmap the private
>> gfn range,
>> then map the shared gfn range.  A new KVM ioctl() will likely be
>> needed to allow
>> userspace to punch a hole in a memslot, as expressing such an
>> operation isn't
>> possible with KVM_SET_USER_MEMORY_REGION.  While userspace could
>> delete the
>> memslot, then recreate three new memslots, doing so would be
>> destructive to guest
>> data as unmapping guest private memory (from the EPT/NPT tables) is
>> destructive
>> to the data for both TDX and SEV-SNP guests.
> 
> If you'd treat it like an overlay, you'd not actually be punching holes.
> You'd only be creating/removing ordinary user memory regions when
> marking something shared/unshared.
> 
>>
>> Pros (vs. struct page)
>> ======================
>>
>> Easy to enforce 1:1 fd:guest pairing, as well as 1:1 gfn:pfn mapping.
>>
>> Userspace page tables are not populated, e.g. reduced memory
>> footprint, lower
>> probability of making private memory accessible to userspace.
> 
> Agreed to the first part, although I consider that a secondary concern.
> The second part, I'm not sure if that is really the case. Fake swap
> entries are just a marker.
> 
>>
>> Provides line of sight to supporting page migration and swap.
> 
> Again, let's leave that out for now. I think that's an kernel internal
> that will require quite some thought either way.
> 
>>
>> Provides line of sight to mapping MMIO pages into guest private memory.
> 
> That's an interesting thought. Would it work via overlays as well? Can
> you elaborate?
> 
>>
>> Cons (vs. struct page)
>> ======================
>>
>> Significantly more churn in KVM, e.g. to plumb 'private' through where
>> needed,
>> support memslot hole punching, etc...
>>
>> KVM's MMU gets another method of retrieving host pfn and page size.
>>
>> Requires enabling in every backing store that someone wants to support.
> 
> I think we will only care about anonymous memory eventually with
> huge/gigantic pages in the next years. Just to what memfd() is already
> limited. File-backed -- I don't know ... if at all, swapping ... in a
> couple of years ...
> 
>>
>> Because the NUMA APIs work on virtual addresses, new syscalls
>> fmove_pages(),
>> fbind(), etc... would be required to provide equivalents to existing NUMA
>> functionality (though those syscalls would likely be useful
>> irrespective of guest
>> private memory).
> 
> Right, that's because we don't have a VMA that describes all this. E.g.,
> mbind().
> 
>>
>> Washes (vs. struct page)
>> ========================
>>
>> A misbehaving guest that triggers a large number of shared memory
>> mappings will
>> consume a large number of memslots.  But, this is likely a wash as
>> similar effect
>> would happen with VMAs in the struct page approach.
> 
> Just cap it then to something sane. 32k which we have right now is crazy
> and only required in very special setups. You can just make QEMU
> override/set the KVM default.
> 
> 
> 
> 
> 
> My wild idea after reading everything so far (full of flaws, just want
> to mention it, maybe it gives some ideas):
> 
> Introduce memfd_encrypted().
> 
> Similar to like memfd_secret()
> - Most system calls will just fail.
> - Allow MAP_SHARED only.
> - Enforce VM_DONTDUMP and skip during fork().

This seems like it would work, but integrating it with the hugetlb
reserve mechanism might be rather messy.

> - File size can change exactly once, before any mmap. (IIRC)

Why is this needed?  Obviously if the file size can be reduced, then the
pages need to get removed safely, but this seems doable if there's a use
case.

> 
> Different to memfd_secret(), allow mapping each page of the fd exactly
> one time via mmap() into a single process.

This doesn't solve the case of multiple memslots pointing at the same
address.  It also doesn't help with future operations that need to map
from a memfd_encrypted() backing page to the GPA that maps it.

> You'll end up with a VMA that corresponds to the whole file in a single
> process only, and that cannot vanish, not even in parts.
> 
> Define "ordinary" user memory slots as overlay on top of "encrypted"
> memory slots.  Inside KVM, bail out if you encounter such a VMA inside a
> normal user memory slot. When creating a "encryped" user memory slot,
> require that the whole VMA is covered at creation time. You know the VMA
> can't change later.

Oof.  That's quite a requirement.  What's the point of the VMA once all
this is done?
