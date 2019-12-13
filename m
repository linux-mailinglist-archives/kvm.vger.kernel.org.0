Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D82011EBCA
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 21:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfLMUXi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 15:23:38 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57053 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728696AbfLMUXh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Dec 2019 15:23:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576268614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KFi1+iHfXX8BVw0V5GxjJE7Cur6uzVwBSwcDe2st9I8=;
        b=IqYAIYqyHYCpYHeuTe0jeoIOT6Qll20TjasdaNDBASIc1uBKscvsRJzbMGhwmckpl4sG/U
        pmS7rvM6lp0M+7ilwsyxYXa5mJfgPBxHKWTtB9XKPRn73++CyPWfY9nNbre6djANh3SqG9
        q6AugVlCVAQ5cuJzeYV618gKk99YPfc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-374-SuqotmaUOtWUrQgs8dX5rQ-1; Fri, 13 Dec 2019 15:23:32 -0500
X-MC-Unique: SuqotmaUOtWUrQgs8dX5rQ-1
Received: by mail-qt1-f197.google.com with SMTP id d9so94667qtq.13
        for <kvm@vger.kernel.org>; Fri, 13 Dec 2019 12:23:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=KFi1+iHfXX8BVw0V5GxjJE7Cur6uzVwBSwcDe2st9I8=;
        b=XVA4OWcttLafjfdSsUA1izI5kqvTjrRApGSBd0zRfkImWNHUQkwV6pbfTzLXnmaDj1
         uQe9MUYuIFSGOjICUfxacaK01vkXZ/b4/Qp0JLmzSS8yl3vrZvQ8LfCw/IfTdZgZ9cwz
         B+0NDYb7gGFKl0xFdQFJQuzBp4Iklw9snieT+QjyPY3aP1ITVr3VXA/hceIwfK5nMdhl
         rldN89sjpnq2E66X22Au/LdLQ5qtgGq17JwSC9BoZqtMookBaMp5GxwWUpSZfbKaxU09
         x45UKUttVo1/7q5I9w4krAW9ad9aj3VO5KLJnI/wjJrCa9qJNxi46jxm9yWaFlOKRRqE
         KQ5g==
X-Gm-Message-State: APjAAAUG8XtveKU8f2zB7X1So0y15sUoMIbJ9EuTjW0M0hOQ1BzQQmgu
        2Lu7rHpYLuowc19XikkgEQ/CKSM1Kd6v3Plp/BPt2jR2OOVM04oXwFSB9lsZUdTu9snHbkKh7kS
        03c+lxwNLTBkX
X-Received: by 2002:ae9:ea06:: with SMTP id f6mr15821578qkg.246.1576268608655;
        Fri, 13 Dec 2019 12:23:28 -0800 (PST)
X-Google-Smtp-Source: APXvYqw1cQezBySpfuqV/RrZ/JucdSJevYXLJ0r2XAKJe8MizIMPJvB9xj/Te1zmKRYs4e5i3fCuzA==
X-Received: by 2002:ae9:ea06:: with SMTP id f6mr15821472qkg.246.1576268607557;
        Fri, 13 Dec 2019 12:23:27 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id w20sm849384qtj.4.2019.12.13.12.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 12:23:26 -0800 (PST)
Date:   Fri, 13 Dec 2019 15:23:24 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Christophe de Dinechin <christophe.de.dinechin@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191213202324.GI16429@xz-x1>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <m1lfrihj2n.fsf@dinechin.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <m1lfrihj2n.fsf@dinechin.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 06:24:00PM +0100, Christophe de Dinechin wrote:
> Peter Xu writes:
> 
> > This patch is heavily based on previous work from Lei Cao
> > <lei.cao@stratus.com> and Paolo Bonzini <pbonzini@redhat.com>. [1]
> >
> > KVM currently uses large bitmaps to track dirty memory.  These bitmaps
> > are copied to userspace when userspace queries KVM for its dirty page
> > information.  The use of bitmaps is mostly sufficient for live
> > migration, as large parts of memory are be dirtied from one log-dirty
> > pass to another.
> 
> That statement sort of concerns me. If large parts of memory are
> dirtied, won't this cause the rings to fill up quickly enough to cause a
> lot of churn between user-space and kernel?

We have cpu-throttle in the QEMU to explicitly provide some "churns"
just to slow the vcpu down.  If dirtying is heavy during migrations
then we might prefer some churns..  Also, this should not replace the
old dirty_bitmap, but it should be a new interface only.  Even if we
want to switch this as default we'll definitely still keep the old
interface when the user wants it in some scenarios.

> 
> See a possible suggestion to address that below.
> 
> > However, in a checkpointing system, the number of
> > dirty pages is small and in fact it is often bounded---the VM is
> > paused when it has dirtied a pre-defined number of pages. Traversing a
> > large, sparsely populated bitmap to find set bits is time-consuming,
> > as is copying the bitmap to user-space.
> >
> > A similar issue will be there for live migration when the guest memory
> > is huge while the page dirty procedure is trivial.  In that case for
> > each dirty sync we need to pull the whole dirty bitmap to userspace
> > and analyse every bit even if it's mostly zeros.
> >
> > The preferred data structure for above scenarios is a dense list of
> > guest frame numbers (GFN).  This patch series stores the dirty list in
> > kernel memory that can be memory mapped into userspace to allow speedy
> > harvesting.
> >
> > We defined two new data structures:
> >
> >   struct kvm_dirty_ring;
> >   struct kvm_dirty_ring_indexes;
> >
> > Firstly, kvm_dirty_ring is defined to represent a ring of dirty
> > pages.  When dirty tracking is enabled, we can push dirty gfn onto the
> > ring.
> >
> > Secondly, kvm_dirty_ring_indexes is defined to represent the
> > user/kernel interface of each ring.  Currently it contains two
> > indexes: (1) avail_index represents where we should push our next
> > PFN (written by kernel), while (2) fetch_index represents where the
> > userspace should fetch the next dirty PFN (written by userspace).
> >
> > One complete ring is composed by one kvm_dirty_ring plus its
> > corresponding kvm_dirty_ring_indexes.
> >
> > Currently, we have N+1 rings for each VM of N vcpus:
> >
> >   - for each vcpu, we have 1 per-vcpu dirty ring,
> >   - for each vm, we have 1 per-vm dirty ring
> >
> > Please refer to the documentation update in this patch for more
> > details.
> >
> > Note that this patch implements the core logic of dirty ring buffer.
> > It's still disabled for all archs for now.  Also, we'll address some
> > of the other issues in follow up patches before it's firstly enabled
> > on x86.
> >
> > [1] https://patchwork.kernel.org/patch/10471409/
> >
> > Signed-off-by: Lei Cao <lei.cao@stratus.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: Peter Xu <peterx@redhat.com>
> > ---
> >  Documentation/virt/kvm/api.txt | 109 +++++++++++++++
> >  arch/x86/kvm/Makefile          |   3 +-
> >  include/linux/kvm_dirty_ring.h |  67 +++++++++
> >  include/linux/kvm_host.h       |  33 +++++
> >  include/linux/kvm_types.h      |   1 +
> >  include/uapi/linux/kvm.h       |  36 +++++
> >  virt/kvm/dirty_ring.c          | 156 +++++++++++++++++++++
> >  virt/kvm/kvm_main.c            | 240 ++++++++++++++++++++++++++++++++-
> >  8 files changed, 642 insertions(+), 3 deletions(-)
> >  create mode 100644 include/linux/kvm_dirty_ring.h
> >  create mode 100644 virt/kvm/dirty_ring.c
> >
> > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > index 49183add44e7..fa622c9a2eb8 100644
> > --- a/Documentation/virt/kvm/api.txt
> > +++ b/Documentation/virt/kvm/api.txt
> > @@ -231,6 +231,7 @@ Based on their initialization different VMs may have different capabilities.
> >  It is thus encouraged to use the vm ioctl to query for capabilities (available
> >  with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)
> >
> > +
> >  4.5 KVM_GET_VCPU_MMAP_SIZE
> >
> >  Capability: basic
> > @@ -243,6 +244,18 @@ The KVM_RUN ioctl (cf.) communicates with userspace via a shared
> >  memory region.  This ioctl returns the size of that region.  See the
> >  KVM_RUN documentation for details.
> >
> > +Besides the size of the KVM_RUN communication region, other areas of
> > +the VCPU file descriptor can be mmap-ed, including:
> > +
> > +- if KVM_CAP_COALESCED_MMIO is available, a page at
> > +  KVM_COALESCED_MMIO_PAGE_OFFSET * PAGE_SIZE; for historical reasons,
> > +  this page is included in the result of KVM_GET_VCPU_MMAP_SIZE.
> > +  KVM_CAP_COALESCED_MMIO is not documented yet.
> 
> Does the above really belong to this patch?

Probably not..  But sure I can move that out in my next post.

> 
> > +
> > +- if KVM_CAP_DIRTY_LOG_RING is available, a number of pages at
> > +  KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE.  For more information on
> > +  KVM_CAP_DIRTY_LOG_RING, see section 8.3.
> > +
> >
> >  4.6 KVM_SET_MEMORY_REGION
> >
> > @@ -5358,6 +5371,7 @@ CPU when the exception is taken. If this virtual SError is taken to EL1 using
> >  AArch64, this value will be reported in the ISS field of ESR_ELx.
> >
> >  See KVM_CAP_VCPU_EVENTS for more details.
> > +
> >  8.20 KVM_CAP_HYPERV_SEND_IPI
> >
> >  Architectures: x86
> > @@ -5365,6 +5379,7 @@ Architectures: x86
> >  This capability indicates that KVM supports paravirtualized Hyper-V IPI send
> >  hypercalls:
> >  HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
> > +
> >  8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
> >
> >  Architecture: x86
> > @@ -5378,3 +5393,97 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
> >  flush hypercalls by Hyper-V) so userspace should disable KVM identification
> >  in CPUID and only exposes Hyper-V identification. In this case, guest
> >  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
> > +
> > +8.22 KVM_CAP_DIRTY_LOG_RING
> > +
> > +Architectures: x86
> > +Parameters: args[0] - size of the dirty log ring
> > +
> > +KVM is capable of tracking dirty memory using ring buffers that are
> > +mmaped into userspace; there is one dirty ring per vcpu and one global
> > +ring per vm.
> > +
> > +One dirty ring has the following two major structures:
> > +
> > +struct kvm_dirty_ring {
> > +	u16 dirty_index;
> > +	u16 reset_index;
> 
> What is the benefit of using u16 for that? That means with 4K pages, you
> can share at most 256M of dirty memory each time? That seems low to me,
> especially since it's sufficient to touch one byte in a page to dirty it.
> 
> Actually, this is not consistent with the definition in the code ;-)
> So I'll assume it's actually u32.

Yes it's u32 now.  Actually I believe at least Paolo would prefer u16
more. :)

I think even u16 would be mostly enough (if you see, the maximum
allowed value currently is 64K entries only, not a big one).  Again,
the thing is that the userspace should be collecting the dirty bits,
so the ring shouldn't reach full easily.  Even if it does, we should
probably let it stop for a while as explained above.  It'll be
inefficient only if we set it to a too-small value, imho.

> 
> > +	u32 size;
> > +	u32 soft_limit;
> > +	spinlock_t lock;
> > +	struct kvm_dirty_gfn *dirty_gfns;
> > +};
> > +
> > +struct kvm_dirty_ring_indexes {
> > +	__u32 avail_index; /* set by kernel */
> > +	__u32 fetch_index; /* set by userspace */
> > +};
> > +
> > +While for each of the dirty entry it's defined as:
> > +
> > +struct kvm_dirty_gfn {
> > +        __u32 pad;
> > +        __u32 slot; /* as_id | slot_id */
> > +        __u64 offset;
> > +};
> 
> Like other have suggested, I think we might used "pad" to store size
> information to be able to dirty large pages more efficiently.

As explained in the other thread, KVM should only trap dirty bits in
4K granularity, never in huge page sizes.

> 
> > +
> > +The fields in kvm_dirty_ring will be only internal to KVM itself,
> > +while the fields in kvm_dirty_ring_indexes will be exposed to
> > +userspace to be either read or written.
> 
> The sentence above is confusing when contrasted with the "set by kernel"
> comment above.

Maybe "kvm_dirty_ring_indexes will be exposed to both KVM and
userspace" to be clearer?

"set by kernel" means kernel will write to it, then the userspace will
still need to read from it.

> 
> > +
> > +The two indices in the ring buffer are free running counters.
> 
> Nit: this patch uses both "indices" and "indexes".
> Both are correct, but it would be nice to be consistent.

I'll respect the original patch to change everything into indices.

> 
> > +
> > +In pseudocode, processing the ring buffer looks like this:
> > +
> > +	idx = load-acquire(&ring->fetch_index);
> > +	while (idx != ring->avail_index) {
> > +		struct kvm_dirty_gfn *entry;
> > +		entry = &ring->dirty_gfns[idx & (size - 1)];
> > +		...
> > +
> > +		idx++;
> > +	}
> > +	ring->fetch_index = idx;
> > +
> > +Userspace calls KVM_ENABLE_CAP ioctl right after KVM_CREATE_VM ioctl
> > +to enable this capability for the new guest and set the size of the
> > +rings.  It is only allowed before creating any vCPU, and the size of
> > +the ring must be a power of two.  The larger the ring buffer, the less
> > +likely the ring is full and the VM is forced to exit to userspace. The
> > +optimal size depends on the workload, but it is recommended that it be
> > +at least 64 KiB (4096 entries).
> 
> Is there anything in the design that would preclude resizing the ring
> buffer at a later time? Presumably, you'd want a large ring while you
> are doing things like migrations, but it's mostly useless when you are
> not monitoring memory. So it would be nice to be able to call
> KVM_ENABLE_CAP at any time to adjust the size.

It'll be scary to me to have it be adjusted at any time...  Even
during pushing dirty gfns onto the ring?  We need to handle all these
complexities...

IMHO it really does not help that much to have such a feature, or I'd
appreciate we can allow to start from simple.

> 
> As I read the current code, one of the issue would be the mapping of the
> rings in case of a later extension where we added something beyond the
> rings. But I'm not sure that's a big deal at the moment.

I think we must define something to be sure that the ring mapped pages
will be limited, so we can still extend things.  IMHO that's why I
introduced the maximum allowed ring size.  That limits this.

> 
> > +
> > +After the capability is enabled, userspace can mmap the global ring
> > +buffer (kvm_dirty_gfn[], offset KVM_DIRTY_LOG_PAGE_OFFSET) and the
> > +indexes (kvm_dirty_ring_indexes, offset 0) from the VM file
> > +descriptor.  The per-vcpu dirty ring instead is mmapped when the vcpu
> > +is created, similar to the kvm_run struct (kvm_dirty_ring_indexes
> > +locates inside kvm_run, while kvm_dirty_gfn[] at offset
> > +KVM_DIRTY_LOG_PAGE_OFFSET).
> > +
> > +Just like for dirty page bitmaps, the buffer tracks writes to
> > +all user memory regions for which the KVM_MEM_LOG_DIRTY_PAGES flag was
> > +set in KVM_SET_USER_MEMORY_REGION.  Once a memory region is registered
> > +with the flag set, userspace can start harvesting dirty pages from the
> > +ring buffer.
> > +
> > +To harvest the dirty pages, userspace accesses the mmaped ring buffer
> > +to read the dirty GFNs up to avail_index, and sets the fetch_index
> > +accordingly.  This can be done when the guest is running or paused,
> > +and dirty pages need not be collected all at once.  After processing
> > +one or more entries in the ring buffer, userspace calls the VM ioctl
> > +KVM_RESET_DIRTY_RINGS to notify the kernel that it has updated
> > +fetch_index and to mark those pages clean.  Therefore, the ioctl
> > +must be called *before* reading the content of the dirty pages.
> 
> > +
> > +However, there is a major difference comparing to the
> > +KVM_GET_DIRTY_LOG interface in that when reading the dirty ring from
> > +userspace it's still possible that the kernel has not yet flushed the
> > +hardware dirty buffers into the kernel buffer.  To achieve that, one
> > +needs to kick the vcpu out for a hardware buffer flush (vmexit).
> 
> When you refer to "buffers", are you referring to the cache lines that
> contain the ring buffers, or to something else?
> 
> I'm a bit confused by this sentence. I think that you mean that a VCPU
> may still be running while you read its ring buffer, in which case the
> values in the ring buffer are not necessarily in memory yet, so not
> visible to a different CPU. But I wonder if you can't make this
> requirement to cause a vmexit unnecessary by carefully ordering the
> writes, to make sure that the fetch_index is updated only after the
> corresponding ring entries have been written to memory,
> 
> In other words, as seen by user-space, you would not care that the ring
> entries have not been flushed as long as the fetch_index itself is
> guaranteed to still be behind the not-flushed-yet entries.
> 
> (I would know how to do that on a different architecture, not sure for x86)

Sorry for not being clear, but.. Do you mean the "hardware dirty
buffers"?  For Intel, it could be PML.  Vmexits guarantee that even
PML buffers will be flushed to the dirty rings.  Nothing about cache
lines.

I used "hardware dirty buffer" only because this document is for KVM
in general, while PML is only one way to do such buffering.  I can add
"(for example, PML)" to make it clearer if you like.

> 
> > +
> > +If one of the ring buffers is full, the guest will exit to userspace
> > +with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL, and the
> > +KVM_RUN ioctl will return -EINTR. Once that happens, userspace
> > +should pause all the vcpus, then harvest all the dirty pages and
> > +rearm the dirty traps. It can unpause the guest after that.
> 
> Except for the condition above, why is it necessary to pause other VCPUs
> than the one being harvested?

This is a good question.  Paolo could correct me if I'm wrong.

Firstly I think this should rarely happen if the userspace is
collecting the dirty bits from time to time.  If it happens, we'll
need to call KVM_RESET_DIRTY_RINGS to reset all the rings.  Then the
question actually becomes to: Whether we'd like to have per-vcpu
KVM_RESET_DIRTY_RINGS?

So the answer is that it could be an overkill to do so.  The important
thing here is no matter what KVM_RESET_DIRTY_RINGS will need to change
the page tables and kick all VCPUs for TLB flushings.  If we must do
it, we'd better do it as rare as possible.  When we're with per-vcpu
ring resets, we'll do N*N vcpu kicks for the bad case (N kicks per
vcpu ring reset, and we've probably got N vcpus).  While if we stick
to the simple per-vm reset, it'll anyway kick all vcpus for tlb
flushing after all, then maybe it's easier to collect all of them
altogether and reset them altogether.

> 
> 
> > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > index b19ef421084d..0acee817adfb 100644
> > --- a/arch/x86/kvm/Makefile
> > +++ b/arch/x86/kvm/Makefile
> > @@ -5,7 +5,8 @@ ccflags-y += -Iarch/x86/kvm
> >  KVM := ../../../virt/kvm
> >
> >  kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
> > -				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
> > +				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
> > +				$(KVM)/dirty_ring.o
> >  kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
> >
> >  kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
> > diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> > new file mode 100644
> > index 000000000000..8335635b7ff7
> > --- /dev/null
> > +++ b/include/linux/kvm_dirty_ring.h
> > @@ -0,0 +1,67 @@
> > +#ifndef KVM_DIRTY_RING_H
> > +#define KVM_DIRTY_RING_H
> > +
> > +/*
> > + * struct kvm_dirty_ring is defined in include/uapi/linux/kvm.h.
> > + *
> > + * dirty_ring:  shared with userspace via mmap. It is the compact list
> > + *              that holds the dirty pages.
> > + * dirty_index: free running counter that points to the next slot in
> > + *              dirty_ring->dirty_gfns  where a new dirty page should go.
> > + * reset_index: free running counter that points to the next dirty page
> > + *              in dirty_ring->dirty_gfns for which dirty trap needs to
> > + *              be reenabled
> > + * size:        size of the compact list, dirty_ring->dirty_gfns
> > + * soft_limit:  when the number of dirty pages in the list reaches this
> > + *              limit, vcpu that owns this ring should exit to userspace
> > + *              to allow userspace to harvest all the dirty pages
> > + * lock:        protects dirty_ring, only in use if this is the global
> > + *              ring
> 
> If that's not used for vcpu rings, maybe move it out of kvm_dirty_ring?

Yeah we can.

> 
> > + *
> > + * The number of dirty pages in the ring is calculated by,
> > + * dirty_index - reset_index
> 
> Nit: the code calls it "used" (in kvm_dirty_ring_used). Maybe find an
> unambiguous terminology. What about "posted", as in
> 
> The number of posted dirty pages, i.e. the number of dirty pages in the
> ring, is calculated as dirty_index - reset_index by function
> kvm_dirty_ring_posted
> 
> (Replace "posted" by any adjective of your liking)

Sure.

(Or maybe I'll just try to remove these lines to avoid introducing any
 terminology as long as it's not very necessary... and after all
 similar things will be mentioned in the documents, and the code itself)

> 
> > + *
> > + * kernel increments dirty_ring->indices.avail_index after dirty index
> > + * is incremented. When userspace harvests the dirty pages, it increments
> > + * dirty_ring->indices.fetch_index up to dirty_ring->indices.avail_index.
> > + * When kernel reenables dirty traps for the dirty pages, it increments
> > + * reset_index up to dirty_ring->indices.fetch_index.
> 
> Userspace should not be trusted to be doing this, see below.
> 
> 
> > + *
> > + */
> > +struct kvm_dirty_ring {
> > +	u32 dirty_index;
> > +	u32 reset_index;
> > +	u32 size;
> > +	u32 soft_limit;
> > +	spinlock_t lock;
> > +	struct kvm_dirty_gfn *dirty_gfns;
> > +};
> > +
> > +u32 kvm_dirty_ring_get_rsvd_entries(void);
> > +int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring);
> > +
> > +/*
> > + * called with kvm->slots_lock held, returns the number of
> > + * processed pages.
> > + */
> > +int kvm_dirty_ring_reset(struct kvm *kvm,
> > +			 struct kvm_dirty_ring *ring,
> > +			 struct kvm_dirty_ring_indexes *indexes);
> > +
> > +/*
> > + * returns 0: successfully pushed
> > + *         1: successfully pushed, soft limit reached,
> > + *            vcpu should exit to userspace
> > + *         -EBUSY: unable to push, dirty ring full.
> > + */
> > +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
> > +			struct kvm_dirty_ring_indexes *indexes,
> > +			u32 slot, u64 offset, bool lock);
> > +
> > +/* for use in vm_operations_struct */
> > +struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 i);
> 
> Not very clear what 'i' means, seems to be a page offset based on call sites?

I'll rename it to "offset".

> 
> > +
> > +void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
> > +bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring);
> > +
> > +#endif
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 498a39462ac1..7b747bc9ff3e 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -34,6 +34,7 @@
> >  #include <linux/kvm_types.h>
> >
> >  #include <asm/kvm_host.h>
> > +#include <linux/kvm_dirty_ring.h>
> >
> >  #ifndef KVM_MAX_VCPU_ID
> >  #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
> > @@ -146,6 +147,7 @@ static inline bool is_error_page(struct page *page)
> >  #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> >  #define KVM_REQ_PENDING_TIMER     2
> >  #define KVM_REQ_UNHALT            3
> > +#define KVM_REQ_DIRTY_RING_FULL   4
> >  #define KVM_REQUEST_ARCH_BASE     8
> >
> >  #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
> > @@ -321,6 +323,7 @@ struct kvm_vcpu {
> >  	bool ready;
> >  	struct kvm_vcpu_arch arch;
> >  	struct dentry *debugfs_dentry;
> > +	struct kvm_dirty_ring dirty_ring;
> >  };
> >
> >  static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
> > @@ -501,6 +504,10 @@ struct kvm {
> >  	struct srcu_struct srcu;
> >  	struct srcu_struct irq_srcu;
> >  	pid_t userspace_pid;
> > +	/* Data structure to be exported by mmap(kvm->fd, 0) */
> > +	struct kvm_vm_run *vm_run;
> > +	u32 dirty_ring_size;
> > +	struct kvm_dirty_ring vm_dirty_ring;
> 
> If you remove the lock from struct kvm_dirty_ring, you could just put it there.

Ok.

> 
> >  };
> >
> >  #define kvm_err(fmt, ...) \
> > @@ -832,6 +839,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> >  					gfn_t gfn_offset,
> >  					unsigned long mask);
> >
> > +void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask);
> > +
> >  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
> >  				struct kvm_dirty_log *log);
> >  int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
> > @@ -1411,4 +1420,28 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
> >  				uintptr_t data, const char *name,
> >  				struct task_struct **thread_ptr);
> >
> > +/*
> > + * This defines how many reserved entries we want to keep before we
> > + * kick the vcpu to the userspace to avoid dirty ring full.  This
> > + * value can be tuned to higher if e.g. PML is enabled on the host.
> > + */
> > +#define  KVM_DIRTY_RING_RSVD_ENTRIES  64
> > +
> > +/* Max number of entries allowed for each kvm dirty ring */
> > +#define  KVM_DIRTY_RING_MAX_ENTRIES  65536
> > +
> > +/*
> > + * Arch needs to define these macro after implementing the dirty ring
> > + * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
> > + * starting page offset of the dirty ring structures, while
> > + * KVM_DIRTY_RING_VERSION should be defined as >=1.  By default, this
> > + * feature is off on all archs.
> > + */
> > +#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
> > +#define KVM_DIRTY_LOG_PAGE_OFFSET 0
> > +#endif
> > +#ifndef KVM_DIRTY_RING_VERSION
> > +#define KVM_DIRTY_RING_VERSION 0
> > +#endif
> > +
> >  #endif
> > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > index 1c88e69db3d9..d9d03eea145a 100644
> > --- a/include/linux/kvm_types.h
> > +++ b/include/linux/kvm_types.h
> > @@ -11,6 +11,7 @@ struct kvm_irq_routing_table;
> >  struct kvm_memory_slot;
> >  struct kvm_one_reg;
> >  struct kvm_run;
> > +struct kvm_vm_run;
> >  struct kvm_userspace_memory_region;
> >  struct kvm_vcpu;
> >  struct kvm_vcpu_init;
> > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > index e6f17c8e2dba..0b88d76d6215 100644
> > --- a/include/uapi/linux/kvm.h
> > +++ b/include/uapi/linux/kvm.h
> > @@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
> >  #define KVM_EXIT_IOAPIC_EOI       26
> >  #define KVM_EXIT_HYPERV           27
> >  #define KVM_EXIT_ARM_NISV         28
> > +#define KVM_EXIT_DIRTY_RING_FULL  29
> >
> >  /* For KVM_EXIT_INTERNAL_ERROR */
> >  /* Emulate instruction failed. */
> > @@ -247,6 +248,11 @@ struct kvm_hyperv_exit {
> >  /* Encounter unexpected vm-exit reason */
> >  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
> >
> > +struct kvm_dirty_ring_indexes {
> > +	__u32 avail_index; /* set by kernel */
> > +	__u32 fetch_index; /* set by userspace */
> > +};
> > +
> >  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
> >  struct kvm_run {
> >  	/* in */
> > @@ -421,6 +427,13 @@ struct kvm_run {
> >  		struct kvm_sync_regs regs;
> >  		char padding[SYNC_REGS_SIZE_BYTES];
> >  	} s;
> > +
> > +	struct kvm_dirty_ring_indexes vcpu_ring_indexes;
> > +};
> > +
> > +/* Returned by mmap(kvm->fd, offset=0) */
> > +struct kvm_vm_run {
> > +	struct kvm_dirty_ring_indexes vm_ring_indexes;
> >  };
> >
> >  /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
> > @@ -1009,6 +1022,7 @@ struct kvm_ppc_resize_hpt {
> >  #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
> >  #define KVM_CAP_ARM_NISV_TO_USER 177
> >  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
> > +#define KVM_CAP_DIRTY_LOG_RING 179
> >
> >  #ifdef KVM_CAP_IRQ_ROUTING
> >
> > @@ -1472,6 +1486,9 @@ struct kvm_enc_region {
> >  /* Available with KVM_CAP_ARM_SVE */
> >  #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
> >
> > +/* Available with KVM_CAP_DIRTY_LOG_RING */
> > +#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc3)
> > +
> >  /* Secure Encrypted Virtualization command */
> >  enum sev_cmd_id {
> >  	/* Guest initialization commands */
> > @@ -1622,4 +1639,23 @@ struct kvm_hyperv_eventfd {
> >  #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
> >  #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
> >
> > +/*
> > + * The following are the requirements for supporting dirty log ring
> > + * (by enabling KVM_DIRTY_LOG_PAGE_OFFSET).
> > + *
> > + * 1. Memory accesses by KVM should call kvm_vcpu_write_* instead
> > + *    of kvm_write_* so that the global dirty ring is not filled up
> > + *    too quickly.
> > + * 2. kvm_arch_mmu_enable_log_dirty_pt_masked should be defined for
> > + *    enabling dirty logging.
> > + * 3. There should not be a separate step to synchronize hardware
> > + *    dirty bitmap with KVM's.
> > + */
> > +
> > +struct kvm_dirty_gfn {
> > +	__u32 pad;
> > +	__u32 slot;
> > +	__u64 offset;
> > +};
> > +
> >  #endif /* __LINUX_KVM_H */
> > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > new file mode 100644
> > index 000000000000..9264891f3c32
> > --- /dev/null
> > +++ b/virt/kvm/dirty_ring.c
> > @@ -0,0 +1,156 @@
> > +#include <linux/kvm_host.h>
> > +#include <linux/kvm.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/kvm_dirty_ring.h>
> > +
> > +u32 kvm_dirty_ring_get_rsvd_entries(void)
> > +{
> > +	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
> > +}
> > +
> > +int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > +{
> > +	u32 size = kvm->dirty_ring_size;
> > +
> > +	ring->dirty_gfns = vmalloc(size);
> > +	if (!ring->dirty_gfns)
> > +		return -ENOMEM;
> > +	memset(ring->dirty_gfns, 0, size);
> > +
> > +	ring->size = size / sizeof(struct kvm_dirty_gfn);
> > +	ring->soft_limit =
> > +	    (kvm->dirty_ring_size / sizeof(struct kvm_dirty_gfn)) -
> > +	    kvm_dirty_ring_get_rsvd_entries();
> 
> Minor, but what about
> 
>        ring->soft_limit = ring->size - kvm_dirty_ring_get_rsvd_entries();

Yeah it's better.

> 
> 
> > +	ring->dirty_index = 0;
> > +	ring->reset_index = 0;
> > +	spin_lock_init(&ring->lock);
> > +
> > +	return 0;
> > +}
> > +
> > +int kvm_dirty_ring_reset(struct kvm *kvm,
> > +			 struct kvm_dirty_ring *ring,
> > +			 struct kvm_dirty_ring_indexes *indexes)
> > +{
> > +	u32 cur_slot, next_slot;
> > +	u64 cur_offset, next_offset;
> > +	unsigned long mask;
> > +	u32 fetch;
> > +	int count = 0;
> > +	struct kvm_dirty_gfn *entry;
> > +
> > +	fetch = READ_ONCE(indexes->fetch_index);
> 
> If I understand correctly, if a malicious user-space writes
> ring->reset_index + 1 into fetch_index, the loop below will execute 4
> billion times.
> 
> 
> > +	if (fetch == ring->reset_index)
> > +		return 0;
> 
> To protect against scenario above, I would have something like:
> 
> 	if (fetch - ring->reset_index >= ring->size)
> 		return -EINVAL;

Good point...  Actually I've got this in my latest branch already, but
still thanks for noticing this!

> 
> > +
> > +	entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> > +	/*
> > +	 * The ring buffer is shared with userspace, which might mmap
> > +	 * it and concurrently modify slot and offset.  Userspace must
> > +	 * not be trusted!  READ_ONCE prevents the compiler from changing
> > +	 * the values after they've been range-checked (the checks are
> > +	 * in kvm_reset_dirty_gfn).
> > +	 */
> > +	smp_read_barrier_depends();
> > +	cur_slot = READ_ONCE(entry->slot);
> > +	cur_offset = READ_ONCE(entry->offset);
> > +	mask = 1;
> > +	count++;
> > +	ring->reset_index++;

[1]

> > +	while (ring->reset_index != fetch) {
> > +		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> > +		smp_read_barrier_depends();
> > +		next_slot = READ_ONCE(entry->slot);
> > +		next_offset = READ_ONCE(entry->offset);
> > +		ring->reset_index++;
> > +		count++;
> > +		/*
> > +		 * Try to coalesce the reset operations when the guest is
> > +		 * scanning pages in the same slot.
> > +		 */
> > +		if (next_slot == cur_slot) {
> > +			int delta = next_offset - cur_offset;
> 
> Since you diff two u64, shouldn't that be an i64 rather than int?

I found there's no i64, so I'm using "long long".

> 
> > +
> > +			if (delta >= 0 && delta < BITS_PER_LONG) {
> > +				mask |= 1ull << delta;
> > +				continue;
> > +			}
> > +
> > +			/* Backwards visit, careful about overflows!  */
> > +			if (delta > -BITS_PER_LONG && delta < 0 &&
> > +			    (mask << -delta >> -delta) == mask) {
> > +				cur_offset = next_offset;
> > +				mask = (mask << -delta) | 1;
> > +				continue;
> > +			}
> > +		}
> > +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > +		cur_slot = next_slot;
> > +		cur_offset = next_offset;
> > +		mask = 1;
> > +	}
> > +	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> 
> So if you did not coalesce the last one, you call kvm_reset_dirty_gfn
> twice? Something smells weird about this loop ;-) I have a gut feeling
> that it could be done in a single while loop combined with the entry
> test, but I may be wrong.

It should be easy to save a few lines at [1] by introducing a boolean
"first_round".  I don't see it easy to avoid the kvm_reset_dirty_gfn()
call at the end though...

> 
> 
> > +
> > +	return count;
> > +}
> > +
> > +static inline u32 kvm_dirty_ring_used(struct kvm_dirty_ring *ring)
> > +{
> > +	return ring->dirty_index - ring->reset_index;
> > +}
> > +
> > +bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring)
> > +{
> > +	return kvm_dirty_ring_used(ring) >= ring->size;
> > +}
> > +
> > +/*
> > + * Returns:
> > + *   >0 if we should kick the vcpu out,
> > + *   =0 if the gfn pushed successfully, or,
> > + *   <0 if error (e.g. ring full)
> > + */
> > +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
> > +			struct kvm_dirty_ring_indexes *indexes,
> > +			u32 slot, u64 offset, bool lock)
> 
> Obviously, if you go with the suggestion to have a "lock" only in struct
> kvm, then you'd have to pass a lock ptr instead of a bool.

Paolo got a better solution on that.  That "lock" will be dropped.

> 
> > +{
> > +	int ret;
> > +	struct kvm_dirty_gfn *entry;
> > +
> > +	if (lock)
> > +		spin_lock(&ring->lock);
> > +
> > +	if (kvm_dirty_ring_full(ring)) {
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
> > +	entry->slot = slot;
> > +	entry->offset = offset;
> > +	smp_wmb();
> > +	ring->dirty_index++;
> > +	WRITE_ONCE(indexes->avail_index, ring->dirty_index);
> 
> Following up on comment about having to vmexit other VCPUs above:
> If you have a write barrier for the entry, and then a write once for the
> index, isn't that sufficient to ensure that another CPU will pick up the
> right values in the right order?

I think so.  I've replied above on the RESET issue.

> 
> 
> > +	ret = kvm_dirty_ring_used(ring) >= ring->soft_limit;
> > +	pr_info("%s: slot %u offset %llu used %u\n",
> > +		__func__, slot, offset, kvm_dirty_ring_used(ring));
> > +
> > +out:
> > +	if (lock)
> > +		spin_unlock(&ring->lock);
> > +
> > +	return ret;
> > +}
> > +
> > +struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 i)
> 
> Still don't like 'i' :-)
> 
> 
> (Stopped my review here for lack of time, decided to share what I had so far)

Thanks for your comments!

-- 
Peter Xu

