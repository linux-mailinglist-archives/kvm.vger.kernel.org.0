Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1176311C031
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 23:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfLKW6K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 17:58:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:29417 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726411AbfLKW6K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 17:58:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576105086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=e3Wm5JTlb53KZ1u+Bwa4f4LhtK7QJrT+pxXCmOAirWE=;
        b=gsf3dtwcK2YViRr03xYuK3RgsuhE3o0yB/pBFO4dUJv9S79ZU3NIllicQQayFSQJJSCDvm
        Uurn5d71uQXgaOlXu+E9sdgmaeVTHQaJWT3IVLP8z4Uq/gGWDr96gG9h0/wQD3AP/55VhO
        j1TLTcJLFtTtfY6WoapcCLUhihJGcQA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-fNA5oqywO0OjC5CHVmDjhg-1; Wed, 11 Dec 2019 17:58:04 -0500
X-MC-Unique: fNA5oqywO0OjC5CHVmDjhg-1
Received: by mail-wm1-f69.google.com with SMTP id t17so49384wmi.7
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 14:58:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e3Wm5JTlb53KZ1u+Bwa4f4LhtK7QJrT+pxXCmOAirWE=;
        b=NSHuhDq+igHUqKih5NycH2kP7c/2wpL4jqWlmkcMx5Idg4zZfw8shW9oqmMW4lVZf6
         ks9MR5MTF+5g10VkvWkOtAcc7VURsTIh7/2c+0LCr2EvIc47oM82J0gyLDsz4P/WgRUU
         8i7feFlpJC6TQF8GBUhdnfgUHHRjF6qUVpRr4txHlZjHXQnQwlwT49g386EN7ricXygM
         sCDiiCcXVQFosXJGTVI6d28QDlUYJyLSIelJQgsZibMdmMX+LzaAGrT6PYjeuwnO7R5A
         ioW1qDu4jeJrc1D+sYvJyf3Sp7fPhXXU+Ccd8RDIpMsm+92KD93jvUsWJYpOSBkPFiM2
         MISw==
X-Gm-Message-State: APjAAAVBk82loO44rEpyknZqGXxRiwBmdnkwO4XLO57NRe6sN5cbPSm3
        SfaG/um81LJgXmKTmrTijlCI1LTj9LTFn8kPSMuCWdfpeWZx3tQKbLlIZdcaRZWyM2/sslPGs1r
        kncF76Ve4Uxdc
X-Received: by 2002:adf:c145:: with SMTP id w5mr2411302wre.205.1576105082169;
        Wed, 11 Dec 2019 14:58:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqwcA/NuCkTDFQafgyYpyml05eaqsK2Lvu3RXS5wKjURUWRuK6zdltKYziseNrB3JOInO9pfNw==
X-Received: by 2002:adf:c145:: with SMTP id w5mr2411218wre.205.1576105080970;
        Wed, 11 Dec 2019 14:58:00 -0800 (PST)
Received: from redhat.com (bzq-79-181-48-215.red.bezeqint.net. [79.181.48.215])
        by smtp.gmail.com with ESMTPSA id z12sm3940428wmd.16.2019.12.11.14.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 14:57:59 -0800 (PST)
Date:   Wed, 11 Dec 2019 17:57:52 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191211172713-mutt-send-email-mst@kernel.org>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
 <20191211063830-mutt-send-email-mst@kernel.org>
 <20191211205952.GA5091@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211205952.GA5091@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 11, 2019 at 03:59:52PM -0500, Peter Xu wrote:
> On Wed, Dec 11, 2019 at 07:53:48AM -0500, Michael S. Tsirkin wrote:
> > On Fri, Nov 29, 2019 at 04:34:54PM -0500, Peter Xu wrote:
> > > This patch is heavily based on previous work from Lei Cao
> > > <lei.cao@stratus.com> and Paolo Bonzini <pbonzini@redhat.com>. [1]
> > > 
> > > KVM currently uses large bitmaps to track dirty memory.  These bitmaps
> > > are copied to userspace when userspace queries KVM for its dirty page
> > > information.  The use of bitmaps is mostly sufficient for live
> > > migration, as large parts of memory are be dirtied from one log-dirty
> > > pass to another.  However, in a checkpointing system, the number of
> > > dirty pages is small and in fact it is often bounded---the VM is
> > > paused when it has dirtied a pre-defined number of pages. Traversing a
> > > large, sparsely populated bitmap to find set bits is time-consuming,
> > > as is copying the bitmap to user-space.
> > > 
> > > A similar issue will be there for live migration when the guest memory
> > > is huge while the page dirty procedure is trivial.  In that case for
> > > each dirty sync we need to pull the whole dirty bitmap to userspace
> > > and analyse every bit even if it's mostly zeros.
> > > 
> > > The preferred data structure for above scenarios is a dense list of
> > > guest frame numbers (GFN).  This patch series stores the dirty list in
> > > kernel memory that can be memory mapped into userspace to allow speedy
> > > harvesting.
> > > 
> > > We defined two new data structures:
> > > 
> > >   struct kvm_dirty_ring;
> > >   struct kvm_dirty_ring_indexes;
> > > 
> > > Firstly, kvm_dirty_ring is defined to represent a ring of dirty
> > > pages.  When dirty tracking is enabled, we can push dirty gfn onto the
> > > ring.
> > > 
> > > Secondly, kvm_dirty_ring_indexes is defined to represent the
> > > user/kernel interface of each ring.  Currently it contains two
> > > indexes: (1) avail_index represents where we should push our next
> > > PFN (written by kernel), while (2) fetch_index represents where the
> > > userspace should fetch the next dirty PFN (written by userspace).
> > > 
> > > One complete ring is composed by one kvm_dirty_ring plus its
> > > corresponding kvm_dirty_ring_indexes.
> > > 
> > > Currently, we have N+1 rings for each VM of N vcpus:
> > > 
> > >   - for each vcpu, we have 1 per-vcpu dirty ring,
> > >   - for each vm, we have 1 per-vm dirty ring
> > > 
> > > Please refer to the documentation update in this patch for more
> > > details.
> > > 
> > > Note that this patch implements the core logic of dirty ring buffer.
> > > It's still disabled for all archs for now.  Also, we'll address some
> > > of the other issues in follow up patches before it's firstly enabled
> > > on x86.
> > > 
> > > [1] https://patchwork.kernel.org/patch/10471409/
> > > 
> > > Signed-off-by: Lei Cao <lei.cao@stratus.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > Signed-off-by: Peter Xu <peterx@redhat.com>
> > 
> > 
> > Thanks, that's interesting.
> 
> Hi, Michael,
> 
> Thanks for reading the series.
> 
> > 
> > > ---
> > >  Documentation/virt/kvm/api.txt | 109 +++++++++++++++
> > >  arch/x86/kvm/Makefile          |   3 +-
> > >  include/linux/kvm_dirty_ring.h |  67 +++++++++
> > >  include/linux/kvm_host.h       |  33 +++++
> > >  include/linux/kvm_types.h      |   1 +
> > >  include/uapi/linux/kvm.h       |  36 +++++
> > >  virt/kvm/dirty_ring.c          | 156 +++++++++++++++++++++
> > >  virt/kvm/kvm_main.c            | 240 ++++++++++++++++++++++++++++++++-
> > >  8 files changed, 642 insertions(+), 3 deletions(-)
> > >  create mode 100644 include/linux/kvm_dirty_ring.h
> > >  create mode 100644 virt/kvm/dirty_ring.c
> > > 
> > > diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> > > index 49183add44e7..fa622c9a2eb8 100644
> > > --- a/Documentation/virt/kvm/api.txt
> > > +++ b/Documentation/virt/kvm/api.txt
> > > @@ -231,6 +231,7 @@ Based on their initialization different VMs may have different capabilities.
> > >  It is thus encouraged to use the vm ioctl to query for capabilities (available
> > >  with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)
> > >  
> > > +
> > >  4.5 KVM_GET_VCPU_MMAP_SIZE
> > >  
> > >  Capability: basic
> > > @@ -243,6 +244,18 @@ The KVM_RUN ioctl (cf.) communicates with userspace via a shared
> > >  memory region.  This ioctl returns the size of that region.  See the
> > >  KVM_RUN documentation for details.
> > >  
> > > +Besides the size of the KVM_RUN communication region, other areas of
> > > +the VCPU file descriptor can be mmap-ed, including:
> > > +
> > > +- if KVM_CAP_COALESCED_MMIO is available, a page at
> > > +  KVM_COALESCED_MMIO_PAGE_OFFSET * PAGE_SIZE; for historical reasons,
> > > +  this page is included in the result of KVM_GET_VCPU_MMAP_SIZE.
> > > +  KVM_CAP_COALESCED_MMIO is not documented yet.
> > > +
> > > +- if KVM_CAP_DIRTY_LOG_RING is available, a number of pages at
> > > +  KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE.  For more information on
> > > +  KVM_CAP_DIRTY_LOG_RING, see section 8.3.
> > > +
> > >  
> > >  4.6 KVM_SET_MEMORY_REGION
> > >  
> > 
> > PAGE_SIZE being which value? It's not always trivial for
> > userspace to know what's the PAGE_SIZE for the kernel ...
> 
> I thought it can be easily fetched from getpagesize() or
> sysconf(PAGE_SIZE)?  Especially considering that the document should
> be for kvm userspace, I'd say it should be common that a hypervisor
> process will need to know this probably in other tons of places.. no?
> 
> > 
> > 
> > > @@ -5358,6 +5371,7 @@ CPU when the exception is taken. If this virtual SError is taken to EL1 using
> > >  AArch64, this value will be reported in the ISS field of ESR_ELx.
> > >  
> > >  See KVM_CAP_VCPU_EVENTS for more details.
> > > +
> > >  8.20 KVM_CAP_HYPERV_SEND_IPI
> > >  
> > >  Architectures: x86
> > > @@ -5365,6 +5379,7 @@ Architectures: x86
> > >  This capability indicates that KVM supports paravirtualized Hyper-V IPI send
> > >  hypercalls:
> > >  HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
> > > +
> > >  8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
> > >  
> > >  Architecture: x86
> > > @@ -5378,3 +5393,97 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
> > >  flush hypercalls by Hyper-V) so userspace should disable KVM identification
> > >  in CPUID and only exposes Hyper-V identification. In this case, guest
> > >  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
> > > +
> > > +8.22 KVM_CAP_DIRTY_LOG_RING
> > > +
> > > +Architectures: x86
> > > +Parameters: args[0] - size of the dirty log ring
> > > +
> > > +KVM is capable of tracking dirty memory using ring buffers that are
> > > +mmaped into userspace; there is one dirty ring per vcpu and one global
> > > +ring per vm.
> > > +
> > > +One dirty ring has the following two major structures:
> > > +
> > > +struct kvm_dirty_ring {
> > > +	u16 dirty_index;
> > > +	u16 reset_index;
> > > +	u32 size;
> > > +	u32 soft_limit;
> > > +	spinlock_t lock;
> > > +	struct kvm_dirty_gfn *dirty_gfns;
> > > +};
> > > +
> > > +struct kvm_dirty_ring_indexes {
> > > +	__u32 avail_index; /* set by kernel */
> > > +	__u32 fetch_index; /* set by userspace */
> > 
> > Sticking these next to each other seems to guarantee cache conflicts.
> > 
> > Avail/Fetch seems to mimic Virtio's avail/used exactly.  I am not saying
> > you must reuse the code really, but I think you should take a hard look
> > at e.g. the virtio packed ring structure. We spent a bunch of time
> > optimizing it for cache utilization. It seems kernel is the driver,
> > making entries available, and userspace the device, using them.
> > Again let's not develop a thread about this, but I think
> > this is something to consider and discuss in future versions
> > of the patches.
> 
> I think I completely understand your concern.  We should avoid wasting
> time on those are already there.  I'm just afraid that it'll took even
> more time to use virtio for this use case while at last we don't
> really get much benefit out of it (e.g. most of the virtio features
> are not used).
> 
> Yeh let's not develop a thread for this topic - I will read more on
> virtio before my next post to see whether there's any chance we can
> share anything with virtio ring.
> 
> > 
> > 
> > > +};
> > > +
> > > +While for each of the dirty entry it's defined as:
> > > +
> > > +struct kvm_dirty_gfn {
> > 
> > What does GFN stand for?
> 
> It's guest frame number, iiuc.  I'm not the one who named this, but
> that's what I understand..
> 
> > 
> > > +        __u32 pad;
> > > +        __u32 slot; /* as_id | slot_id */
> > > +        __u64 offset;
> > > +};
> > 
> > offset of what? a 4K page right? Seems like a waste e.g. for
> > hugetlbfs... How about replacing pad with size instead?
> 
> As Paolo explained, it's the page frame number of the guest.  IIUC
> even for hugetlbfs we track dirty bits in 4k size.
> 
> > 
> > > +
> > > +The fields in kvm_dirty_ring will be only internal to KVM itself,
> > > +while the fields in kvm_dirty_ring_indexes will be exposed to
> > > +userspace to be either read or written.
> > 
> > I'm not sure what you are trying to say here. kvm_dirty_gfn
> > seems to be part of UAPI.
> 
> It was talking about kvm_dirty_ring, which is kvm internal and not
> exposed to uapi.  While kvm_dirty_gfn is exposed to the users.
> 
> > 
> > > +
> > > +The two indices in the ring buffer are free running counters.
> > > +
> > > +In pseudocode, processing the ring buffer looks like this:
> > > +
> > > +	idx = load-acquire(&ring->fetch_index);
> > > +	while (idx != ring->avail_index) {
> > > +		struct kvm_dirty_gfn *entry;
> > > +		entry = &ring->dirty_gfns[idx & (size - 1)];
> > > +		...
> > > +
> > > +		idx++;
> > > +	}
> > > +	ring->fetch_index = idx;
> > > +
> > > +Userspace calls KVM_ENABLE_CAP ioctl right after KVM_CREATE_VM ioctl
> > > +to enable this capability for the new guest and set the size of the
> > > +rings.  It is only allowed before creating any vCPU, and the size of
> > > +the ring must be a power of two.
> > 
> > All these seem like arbitrary limitations to me.
> 
> The dependency of vcpu is partly because we need to create per-vcpu
> ring, so it's easier that we don't allow it to change after that.
> 
> > 
> > Sizing the ring correctly might prove to be a challenge.
> > 
> > Thus I think there's value in resizing the rings
> > without destroying VCPU.
> 
> Do you have an example on when we could use this feature?

So e.g. start with a small ring, and if you see stalls too often
increase it? Otherwise I don't see how does one decide
on ring size.

>  My wild
> guess is that even if we try hard to allow resizing (assuming that
> won't bring more bugs, but I hightly doubt...), people may not use it
> at all.
> 
> The major scenario here is that kvm userspace will be collecting the
> dirty bits quickly, so the ring should not really get full easily.
> Then the ring size does not really matter much either, as long as it
> is bigger than some specific value to avoid vmexits due to full.

Exactly but I don't see how you are going to find that value
unless it's auto-tuning dynamically.

> How about we start with the simple that we don't allow it to change?
> We can do that when the requirement comes.
> 
> > 
> > Also, power of two just saves a branch here and there,
> > but wastes lots of memory. Just wrap the index around to
> > 0 and then users can select any size?
> 
> Same as above to postpone until we need it?

It's to save memory, don't we always need to do that?

> > 
> > 
> > 
> > >  The larger the ring buffer, the less
> > > +likely the ring is full and the VM is forced to exit to userspace. The
> > > +optimal size depends on the workload, but it is recommended that it be
> > > +at least 64 KiB (4096 entries).
> > 
> > OTOH larger buffers put lots of pressure on the system cache.
> > 
> > > +
> > > +After the capability is enabled, userspace can mmap the global ring
> > > +buffer (kvm_dirty_gfn[], offset KVM_DIRTY_LOG_PAGE_OFFSET) and the
> > > +indexes (kvm_dirty_ring_indexes, offset 0) from the VM file
> > > +descriptor.  The per-vcpu dirty ring instead is mmapped when the vcpu
> > > +is created, similar to the kvm_run struct (kvm_dirty_ring_indexes
> > > +locates inside kvm_run, while kvm_dirty_gfn[] at offset
> > > +KVM_DIRTY_LOG_PAGE_OFFSET).
> > > +
> > > +Just like for dirty page bitmaps, the buffer tracks writes to
> > > +all user memory regions for which the KVM_MEM_LOG_DIRTY_PAGES flag was
> > > +set in KVM_SET_USER_MEMORY_REGION.  Once a memory region is registered
> > > +with the flag set, userspace can start harvesting dirty pages from the
> > > +ring buffer.
> > > +
> > > +To harvest the dirty pages, userspace accesses the mmaped ring buffer
> > > +to read the dirty GFNs up to avail_index, and sets the fetch_index
> > > +accordingly.  This can be done when the guest is running or paused,
> > > +and dirty pages need not be collected all at once.  After processing
> > > +one or more entries in the ring buffer, userspace calls the VM ioctl
> > > +KVM_RESET_DIRTY_RINGS to notify the kernel that it has updated
> > > +fetch_index and to mark those pages clean.  Therefore, the ioctl
> > > +must be called *before* reading the content of the dirty pages.
> > > +
> > > +However, there is a major difference comparing to the
> > > +KVM_GET_DIRTY_LOG interface in that when reading the dirty ring from
> > > +userspace it's still possible that the kernel has not yet flushed the
> > > +hardware dirty buffers into the kernel buffer.  To achieve that, one
> > > +needs to kick the vcpu out for a hardware buffer flush (vmexit).
> > > +
> > > +If one of the ring buffers is full, the guest will exit to userspace
> > > +with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL, and the
> > > +KVM_RUN ioctl will return -EINTR. Once that happens, userspace
> > > +should pause all the vcpus, then harvest all the dirty pages and
> > > +rearm the dirty traps. It can unpause the guest after that.
> > 
> > This last item means that the performance impact of the feature is
> > really hard to predict. Can improve some workloads drastically. Or can
> > slow some down.
> > 
> > 
> > One solution could be to actually allow using this together with the
> > existing bitmap. Userspace can then decide whether it wants to block
> > VCPU on ring full, or just record ring full condition and recover by
> > bitmap scanning.
> 
> That's true, but again allowing mixture use of the two might bring
> extra complexity as well (especially when after adding
> KVM_CLEAR_DIRTY_LOG).
> 
> My understanding of this is that normally we do only want either one
> of them depending on the major workload and the configuration of the
> guest.

And again how does one know which to enable? No one has the
time to fine-tune gazillion parameters.

>  It's not trivial to try to provide a one-for-all solution.  So
> again I would hope we can start from easy, then we extend when we have
> better ideas on how to leverage the two interfaces when the ideas
> really come, and then we can justify whether it's worth it to work on
> that complexity.

It's less *coding* work to build a simple thing but it need much more *testing*.

IMHO a huge amount of benchmarking has to happen if you just want to
set this loose on users as default with these kind of
limitations. We need to be sure that even though in theory
it can be very bad, in practice it's actually good.
If it's auto-tuning then it's a much easier sell to upstream
even if there's a chance of some regressions.

> > 
> > 
> > > diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> > > index b19ef421084d..0acee817adfb 100644
> > > --- a/arch/x86/kvm/Makefile
> > > +++ b/arch/x86/kvm/Makefile
> > > @@ -5,7 +5,8 @@ ccflags-y += -Iarch/x86/kvm
> > >  KVM := ../../../virt/kvm
> > >  
> > >  kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
> > > -				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
> > > +				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
> > > +				$(KVM)/dirty_ring.o
> > >  kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
> > >  
> > >  kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
> > > diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> > > new file mode 100644
> > > index 000000000000..8335635b7ff7
> > > --- /dev/null
> > > +++ b/include/linux/kvm_dirty_ring.h
> > > @@ -0,0 +1,67 @@
> > > +#ifndef KVM_DIRTY_RING_H
> > > +#define KVM_DIRTY_RING_H
> > > +
> > > +/*
> > > + * struct kvm_dirty_ring is defined in include/uapi/linux/kvm.h.
> > > + *
> > > + * dirty_ring:  shared with userspace via mmap. It is the compact list
> > > + *              that holds the dirty pages.
> > > + * dirty_index: free running counter that points to the next slot in
> > > + *              dirty_ring->dirty_gfns  where a new dirty page should go.
> > > + * reset_index: free running counter that points to the next dirty page
> > > + *              in dirty_ring->dirty_gfns for which dirty trap needs to
> > > + *              be reenabled
> > > + * size:        size of the compact list, dirty_ring->dirty_gfns
> > > + * soft_limit:  when the number of dirty pages in the list reaches this
> > > + *              limit, vcpu that owns this ring should exit to userspace
> > > + *              to allow userspace to harvest all the dirty pages
> > > + * lock:        protects dirty_ring, only in use if this is the global
> > > + *              ring
> > > + *
> > > + * The number of dirty pages in the ring is calculated by,
> > > + * dirty_index - reset_index
> > > + *
> > > + * kernel increments dirty_ring->indices.avail_index after dirty index
> > > + * is incremented. When userspace harvests the dirty pages, it increments
> > > + * dirty_ring->indices.fetch_index up to dirty_ring->indices.avail_index.
> > > + * When kernel reenables dirty traps for the dirty pages, it increments
> > > + * reset_index up to dirty_ring->indices.fetch_index.
> > > + *
> > > + */
> > > +struct kvm_dirty_ring {
> > > +	u32 dirty_index;
> > > +	u32 reset_index;
> > > +	u32 size;
> > > +	u32 soft_limit;
> > > +	spinlock_t lock;
> > > +	struct kvm_dirty_gfn *dirty_gfns;
> > > +};
> > > +
> > > +u32 kvm_dirty_ring_get_rsvd_entries(void);
> > > +int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring);
> > > +
> > > +/*
> > > + * called with kvm->slots_lock held, returns the number of
> > > + * processed pages.
> > > + */
> > > +int kvm_dirty_ring_reset(struct kvm *kvm,
> > > +			 struct kvm_dirty_ring *ring,
> > > +			 struct kvm_dirty_ring_indexes *indexes);
> > > +
> > > +/*
> > > + * returns 0: successfully pushed
> > > + *         1: successfully pushed, soft limit reached,
> > > + *            vcpu should exit to userspace
> > > + *         -EBUSY: unable to push, dirty ring full.
> > > + */
> > > +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
> > > +			struct kvm_dirty_ring_indexes *indexes,
> > > +			u32 slot, u64 offset, bool lock);
> > > +
> > > +/* for use in vm_operations_struct */
> > > +struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 i);
> > > +
> > > +void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
> > > +bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring);
> > > +
> > > +#endif
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 498a39462ac1..7b747bc9ff3e 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -34,6 +34,7 @@
> > >  #include <linux/kvm_types.h>
> > >  
> > >  #include <asm/kvm_host.h>
> > > +#include <linux/kvm_dirty_ring.h>
> > >  
> > >  #ifndef KVM_MAX_VCPU_ID
> > >  #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
> > > @@ -146,6 +147,7 @@ static inline bool is_error_page(struct page *page)
> > >  #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
> > >  #define KVM_REQ_PENDING_TIMER     2
> > >  #define KVM_REQ_UNHALT            3
> > > +#define KVM_REQ_DIRTY_RING_FULL   4
> > >  #define KVM_REQUEST_ARCH_BASE     8
> > >  
> > >  #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
> > > @@ -321,6 +323,7 @@ struct kvm_vcpu {
> > >  	bool ready;
> > >  	struct kvm_vcpu_arch arch;
> > >  	struct dentry *debugfs_dentry;
> > > +	struct kvm_dirty_ring dirty_ring;
> > >  };
> > >  
> > >  static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
> > > @@ -501,6 +504,10 @@ struct kvm {
> > >  	struct srcu_struct srcu;
> > >  	struct srcu_struct irq_srcu;
> > >  	pid_t userspace_pid;
> > > +	/* Data structure to be exported by mmap(kvm->fd, 0) */
> > > +	struct kvm_vm_run *vm_run;
> > > +	u32 dirty_ring_size;
> > > +	struct kvm_dirty_ring vm_dirty_ring;
> > >  };
> > >  
> > >  #define kvm_err(fmt, ...) \
> > > @@ -832,6 +839,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
> > >  					gfn_t gfn_offset,
> > >  					unsigned long mask);
> > >  
> > > +void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask);
> > > +
> > >  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
> > >  				struct kvm_dirty_log *log);
> > >  int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
> > > @@ -1411,4 +1420,28 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
> > >  				uintptr_t data, const char *name,
> > >  				struct task_struct **thread_ptr);
> > >  
> > > +/*
> > > + * This defines how many reserved entries we want to keep before we
> > > + * kick the vcpu to the userspace to avoid dirty ring full.  This
> > > + * value can be tuned to higher if e.g. PML is enabled on the host.
> > > + */
> > > +#define  KVM_DIRTY_RING_RSVD_ENTRIES  64
> > > +
> > > +/* Max number of entries allowed for each kvm dirty ring */
> > > +#define  KVM_DIRTY_RING_MAX_ENTRIES  65536
> > > +
> > > +/*
> > > + * Arch needs to define these macro after implementing the dirty ring
> > > + * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
> > > + * starting page offset of the dirty ring structures,
> > 
> > Confused. Offset where? You set a default for everyone - where does arch
> > want to override it?
> 
> If arch defines KVM_DIRTY_LOG_PAGE_OFFSET then below will be a no-op,
> please see [1] on #ifndef.

So which arches need to override it? Why do you say they should?

> > 
> > > while
> > > + * KVM_DIRTY_RING_VERSION should be defined as >=1.  By default, this
> > > + * feature is off on all archs.
> > > + */
> > > +#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
> 
> [1]
> 
> > > +#define KVM_DIRTY_LOG_PAGE_OFFSET 0
> > > +#endif
> > > +#ifndef KVM_DIRTY_RING_VERSION
> > > +#define KVM_DIRTY_RING_VERSION 0
> > > +#endif
> > 
> > One way versioning, with no bits and negotiation
> > will make it hard to change down the road.
> > what's wrong with existing KVM capabilities that
> > you feel there's a need for dedicated versioning for this?
> 
> Frankly speaking I don't even think it'll change in the near
> future.. :)
> 
> Yeh kvm versioning could work too.  Here we can also return a zero
> just like the most of the caps (or KVM_DIRTY_LOG_PAGE_OFFSET as in the
> original patchset, but it's really helpless either because it's
> defined in uapi), but I just don't see how it helps...  So I returned
> a version number just in case we'd like to change the layout some day
> and when we don't want to bother introducing another cap bit for the
> same feature (like KVM_CAP_MANUAL_DIRTY_LOG_PROTECT and
> KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2).

I guess it's up to Paolo but really I don't see the point.
You can add a version later when it means something ...

> > 
> > > +
> > >  #endif
> > > diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> > > index 1c88e69db3d9..d9d03eea145a 100644
> > > --- a/include/linux/kvm_types.h
> > > +++ b/include/linux/kvm_types.h
> > > @@ -11,6 +11,7 @@ struct kvm_irq_routing_table;
> > >  struct kvm_memory_slot;
> > >  struct kvm_one_reg;
> > >  struct kvm_run;
> > > +struct kvm_vm_run;
> > >  struct kvm_userspace_memory_region;
> > >  struct kvm_vcpu;
> > >  struct kvm_vcpu_init;
> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index e6f17c8e2dba..0b88d76d6215 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
> > >  #define KVM_EXIT_IOAPIC_EOI       26
> > >  #define KVM_EXIT_HYPERV           27
> > >  #define KVM_EXIT_ARM_NISV         28
> > > +#define KVM_EXIT_DIRTY_RING_FULL  29
> > >  
> > >  /* For KVM_EXIT_INTERNAL_ERROR */
> > >  /* Emulate instruction failed. */
> > > @@ -247,6 +248,11 @@ struct kvm_hyperv_exit {
> > >  /* Encounter unexpected vm-exit reason */
> > >  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
> > >  
> > > +struct kvm_dirty_ring_indexes {
> > > +	__u32 avail_index; /* set by kernel */
> > > +	__u32 fetch_index; /* set by userspace */
> > > +};
> > > +
> > >  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
> > >  struct kvm_run {
> > >  	/* in */
> > > @@ -421,6 +427,13 @@ struct kvm_run {
> > >  		struct kvm_sync_regs regs;
> > >  		char padding[SYNC_REGS_SIZE_BYTES];
> > >  	} s;
> > > +
> > > +	struct kvm_dirty_ring_indexes vcpu_ring_indexes;
> > > +};
> > > +
> > > +/* Returned by mmap(kvm->fd, offset=0) */
> > > +struct kvm_vm_run {
> > > +	struct kvm_dirty_ring_indexes vm_ring_indexes;
> > >  };
> > >  
> > >  /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
> > > @@ -1009,6 +1022,7 @@ struct kvm_ppc_resize_hpt {
> > >  #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
> > >  #define KVM_CAP_ARM_NISV_TO_USER 177
> > >  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
> > > +#define KVM_CAP_DIRTY_LOG_RING 179
> > >  
> > >  #ifdef KVM_CAP_IRQ_ROUTING
> > >  
> > > @@ -1472,6 +1486,9 @@ struct kvm_enc_region {
> > >  /* Available with KVM_CAP_ARM_SVE */
> > >  #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
> > >  
> > > +/* Available with KVM_CAP_DIRTY_LOG_RING */
> > > +#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc3)
> > > +
> > >  /* Secure Encrypted Virtualization command */
> > >  enum sev_cmd_id {
> > >  	/* Guest initialization commands */
> > > @@ -1622,4 +1639,23 @@ struct kvm_hyperv_eventfd {
> > >  #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
> > >  #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
> > >  
> > > +/*
> > > + * The following are the requirements for supporting dirty log ring
> > > + * (by enabling KVM_DIRTY_LOG_PAGE_OFFSET).
> > > + *
> > > + * 1. Memory accesses by KVM should call kvm_vcpu_write_* instead
> > > + *    of kvm_write_* so that the global dirty ring is not filled up
> > > + *    too quickly.
> > > + * 2. kvm_arch_mmu_enable_log_dirty_pt_masked should be defined for
> > > + *    enabling dirty logging.
> > > + * 3. There should not be a separate step to synchronize hardware
> > > + *    dirty bitmap with KVM's.
> > > + */
> > > +
> > > +struct kvm_dirty_gfn {
> > > +	__u32 pad;
> > > +	__u32 slot;
> > > +	__u64 offset;
> > > +};
> > > +
> > >  #endif /* __LINUX_KVM_H */
> > > diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> > > new file mode 100644
> > > index 000000000000..9264891f3c32
> > > --- /dev/null
> > > +++ b/virt/kvm/dirty_ring.c
> > > @@ -0,0 +1,156 @@
> > > +#include <linux/kvm_host.h>
> > > +#include <linux/kvm.h>
> > > +#include <linux/vmalloc.h>
> > > +#include <linux/kvm_dirty_ring.h>
> > > +
> > > +u32 kvm_dirty_ring_get_rsvd_entries(void)
> > > +{
> > > +	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
> > > +}
> > > +
> > > +int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring)
> > > +{
> > > +	u32 size = kvm->dirty_ring_size;
> > > +
> > > +	ring->dirty_gfns = vmalloc(size);
> > 
> > So 1/2 a megabyte of kernel memory per VM that userspace locks up.
> > Do we really have to though? Why not get a userspace pointer,
> > write it with copy to user, and sidestep all this?
> 
> I'd say it won't be a big issue on locking 1/2M of host mem for a
> vm...
> Also note that if dirty ring is enabled, I plan to evaporate the
> dirty_bitmap in the next post. The old kvm->dirty_bitmap takes
> $GUEST_MEM/32K*2 mem.  E.g., for 64G guest it's 64G/32K*2=4M.  If with
> dirty ring of 8 vcpus, that could be 64K*8=0.5M, which could be even
> less memory used.

Right - I think Avi described the bitmap in kernel memory as one of
design mistakes. Why repeat that with the new design?

> > 
> > > +	if (!ring->dirty_gfns)
> > > +		return -ENOMEM;
> > > +	memset(ring->dirty_gfns, 0, size);
> > > +
> > > +	ring->size = size / sizeof(struct kvm_dirty_gfn);
> > > +	ring->soft_limit =
> > > +	    (kvm->dirty_ring_size / sizeof(struct kvm_dirty_gfn)) -
> > > +	    kvm_dirty_ring_get_rsvd_entries();
> > > +	ring->dirty_index = 0;
> > > +	ring->reset_index = 0;
> > > +	spin_lock_init(&ring->lock);
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +int kvm_dirty_ring_reset(struct kvm *kvm,
> > > +			 struct kvm_dirty_ring *ring,
> > > +			 struct kvm_dirty_ring_indexes *indexes)
> > > +{
> > > +	u32 cur_slot, next_slot;
> > > +	u64 cur_offset, next_offset;
> > > +	unsigned long mask;
> > > +	u32 fetch;
> > > +	int count = 0;
> > > +	struct kvm_dirty_gfn *entry;
> > > +
> > > +	fetch = READ_ONCE(indexes->fetch_index);
> > > +	if (fetch == ring->reset_index)
> > > +		return 0;
> > > +
> > > +	entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> > > +	/*
> > > +	 * The ring buffer is shared with userspace, which might mmap
> > > +	 * it and concurrently modify slot and offset.  Userspace must
> > > +	 * not be trusted!  READ_ONCE prevents the compiler from changing
> > > +	 * the values after they've been range-checked (the checks are
> > > +	 * in kvm_reset_dirty_gfn).
> > 
> > What it doesn't is prevent speculative attacks.  That's why things like
> > copy from user have a speculation barrier.  Instead of worrying about
> > that, unless it's really critical, I think you'd do well do just use
> > copy to/from user.
> 
> IMHO I would really hope these data be there without swapped out of
> memory, just like what we did with kvm->dirty_bitmap... it's on the
> hot path of mmu page fault, even we could be with mmu lock held if
> copy_to_user() page faulted.  But indeed I've no experience on
> avoiding speculative attacks, suggestions would be greatly welcomed on
> that.  In our case we do (index & (size - 1)), so is it still
> suffering from speculative attacks?

I don't say I understand everything in depth.
Just reacting to this:
	READ_ONCE prevents the compiler from changing
	the values after they've been range-checked (the checks are
	in kvm_reset_dirty_gfn)

so any range checks you do can be attacked.

And the safest way to avoid the attacks is to do what most
kernel does and use copy from/to user when you talk to
userspace. Avoid annoying things like bypassing SMAP too.


> > 
> > > +	 */
> > > +	smp_read_barrier_depends();
> > 
> > What depends on what here? Looks suspicious ...
> 
> Hmm, I think maybe it can be removed because the entry pointer
> reference below should be an ordering constraint already?
> 
> > 
> > > +	cur_slot = READ_ONCE(entry->slot);
> > > +	cur_offset = READ_ONCE(entry->offset);
> > > +	mask = 1;
> > > +	count++;
> > > +	ring->reset_index++;
> > > +	while (ring->reset_index != fetch) {
> > > +		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> > > +		smp_read_barrier_depends();
> > 
> > same concerns here
> > 
> > > +		next_slot = READ_ONCE(entry->slot);
> > > +		next_offset = READ_ONCE(entry->offset);
> > > +		ring->reset_index++;
> > > +		count++;
> > > +		/*
> > > +		 * Try to coalesce the reset operations when the guest is
> > > +		 * scanning pages in the same slot.
> > 
> > what does guest scanning mean?
> 
> My wild guess is that it means when the guest is accessing the pages
> continuously so the dirty gfns are continuous too.  Anyway I agree
> it's not clear, where I can try to rephrase.
> 
> > 
> > > +		 */
> > > +		if (next_slot == cur_slot) {
> > > +			int delta = next_offset - cur_offset;
> > > +
> > > +			if (delta >= 0 && delta < BITS_PER_LONG) {
> > > +				mask |= 1ull << delta;
> > > +				continue;
> > > +			}
> > > +
> > > +			/* Backwards visit, careful about overflows!  */
> > > +			if (delta > -BITS_PER_LONG && delta < 0 &&
> > > +			    (mask << -delta >> -delta) == mask) {
> > > +				cur_offset = next_offset;
> > > +				mask = (mask << -delta) | 1;
> > > +				continue;
> > > +			}
> > > +		}
> > > +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > > +		cur_slot = next_slot;
> > > +		cur_offset = next_offset;
> > > +		mask = 1;
> > > +	}
> > > +	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> > > +
> > > +	return count;
> > > +}
> > > +
> > > +static inline u32 kvm_dirty_ring_used(struct kvm_dirty_ring *ring)
> > > +{
> > > +	return ring->dirty_index - ring->reset_index;
> > > +}
> > > +
> > > +bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring)
> > > +{
> > > +	return kvm_dirty_ring_used(ring) >= ring->size;
> > > +}
> > > +
> > > +/*
> > > + * Returns:
> > > + *   >0 if we should kick the vcpu out,
> > > + *   =0 if the gfn pushed successfully, or,
> > > + *   <0 if error (e.g. ring full)
> > > + */
> > > +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
> > > +			struct kvm_dirty_ring_indexes *indexes,
> > > +			u32 slot, u64 offset, bool lock)
> > > +{
> > > +	int ret;
> > > +	struct kvm_dirty_gfn *entry;
> > > +
> > > +	if (lock)
> > > +		spin_lock(&ring->lock);
> > 
> > what's the story around locking here? Why is it safe
> > not to take the lock sometimes?
> 
> kvm_dirty_ring_push() will be with lock==true only when the per-vm
> ring is used.  For per-vcpu ring, because that will only happen with
> the vcpu context, then we don't need locks (so kvm_dirty_ring_push()
> is called with lock==false).
> 
> > 
> > > +
> > > +	if (kvm_dirty_ring_full(ring)) {
> > > +		ret = -EBUSY;
> > > +		goto out;
> > > +	}
> > > +
> > > +	entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
> > > +	entry->slot = slot;
> > > +	entry->offset = offset;
> > > +	smp_wmb();
> > > +	ring->dirty_index++;
> > > +	WRITE_ONCE(indexes->avail_index, ring->dirty_index);
> > > +	ret = kvm_dirty_ring_used(ring) >= ring->soft_limit;
> > > +	pr_info("%s: slot %u offset %llu used %u\n",
> > > +		__func__, slot, offset, kvm_dirty_ring_used(ring));
> > > +
> > > +out:
> > > +	if (lock)
> > > +		spin_unlock(&ring->lock);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > > +struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 i)
> > > +{
> > > +	return vmalloc_to_page((void *)ring->dirty_gfns + i * PAGE_SIZE);
> > > +}
> > > +
> > > +void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
> > > +{
> > > +	if (ring->dirty_gfns) {
> > > +		vfree(ring->dirty_gfns);
> > > +		ring->dirty_gfns = NULL;
> > > +	}
> > > +}
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 681452d288cd..8642c977629b 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -64,6 +64,8 @@
> > >  #define CREATE_TRACE_POINTS
> > >  #include <trace/events/kvm.h>
> > >  
> > > +#include <linux/kvm_dirty_ring.h>
> > > +
> > >  /* Worst case buffer size needed for holding an integer. */
> > >  #define ITOA_MAX_LEN 12
> > >  
> > > @@ -149,6 +151,10 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
> > >  				    struct kvm_vcpu *vcpu,
> > >  				    struct kvm_memory_slot *memslot,
> > >  				    gfn_t gfn);
> > > +static void mark_page_dirty_in_ring(struct kvm *kvm,
> > > +				    struct kvm_vcpu *vcpu,
> > > +				    struct kvm_memory_slot *slot,
> > > +				    gfn_t gfn);
> > >  
> > >  __visible bool kvm_rebooting;
> > >  EXPORT_SYMBOL_GPL(kvm_rebooting);
> > > @@ -359,11 +365,22 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
> > >  	vcpu->preempted = false;
> > >  	vcpu->ready = false;
> > >  
> > > +	if (kvm->dirty_ring_size) {
> > > +		r = kvm_dirty_ring_alloc(vcpu->kvm, &vcpu->dirty_ring);
> > > +		if (r) {
> > > +			kvm->dirty_ring_size = 0;
> > > +			goto fail_free_run;
> > > +		}
> > > +	}
> > > +
> > >  	r = kvm_arch_vcpu_init(vcpu);
> > >  	if (r < 0)
> > > -		goto fail_free_run;
> > > +		goto fail_free_ring;
> > >  	return 0;
> > >  
> > > +fail_free_ring:
> > > +	if (kvm->dirty_ring_size)
> > > +		kvm_dirty_ring_free(&vcpu->dirty_ring);
> > >  fail_free_run:
> > >  	free_page((unsigned long)vcpu->run);
> > >  fail:
> > > @@ -381,6 +398,8 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
> > >  	put_pid(rcu_dereference_protected(vcpu->pid, 1));
> > >  	kvm_arch_vcpu_uninit(vcpu);
> > >  	free_page((unsigned long)vcpu->run);
> > > +	if (vcpu->kvm->dirty_ring_size)
> > > +		kvm_dirty_ring_free(&vcpu->dirty_ring);
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
> > >  
> > > @@ -690,6 +709,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
> > >  	struct kvm *kvm = kvm_arch_alloc_vm();
> > >  	int r = -ENOMEM;
> > >  	int i;
> > > +	struct page *page;
> > >  
> > >  	if (!kvm)
> > >  		return ERR_PTR(-ENOMEM);
> > > @@ -705,6 +725,14 @@ static struct kvm *kvm_create_vm(unsigned long type)
> > >  
> > >  	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
> > >  
> > > +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> > > +	if (!page) {
> > > +		r = -ENOMEM;
> > > +		goto out_err_alloc_page;
> > > +	}
> > > +	kvm->vm_run = page_address(page);
> > 
> > So 4K with just 8 bytes used. Not as bad as 1/2Mbyte for the ring but
> > still. What is wrong with just a pointer and calling put_user?
> 
> I want to make it the start point for sharing fields between
> user/kernel per-vm.  Just like kvm_run for per-vcpu.

And why is doing that without get/put user a good idea?
If nothing else this bypasses SMAP, exploits can pass
data from userspace to kernel through that.

> IMHO it'll be awkward if we always introduce a new interface just to
> take a pointer of the userspace buffer and cache it...  I'd say so far
> I like the design of kvm_run and alike because it's efficient, easy to
> use, and easy for extensions.


Well kvm run at least isn't accessed when kernel is processing it.
And the structure there is dead simple, not a tricky lockless ring
with indices and things.

Again I might be wrong, eventually it's up to kvm maintainers.  But
really there's a standard thing all drivers do to talk to userspace, and
if there's no special reason to do otherwise I would do exactly it.

> > 
> > > +	BUILD_BUG_ON(sizeof(struct kvm_vm_run) > PAGE_SIZE);
> > > +
> > >  	if (init_srcu_struct(&kvm->srcu))
> > >  		goto out_err_no_srcu;
> > >  	if (init_srcu_struct(&kvm->irq_srcu))
> > > @@ -775,6 +803,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
> > >  out_err_no_irq_srcu:
> > >  	cleanup_srcu_struct(&kvm->srcu);
> > >  out_err_no_srcu:
> > > +	free_page((unsigned long)page);
> > > +	kvm->vm_run = NULL;
> > > +out_err_alloc_page:
> > >  	kvm_arch_free_vm(kvm);
> > >  	mmdrop(current->mm);
> > >  	return ERR_PTR(r);
> > > @@ -800,6 +831,15 @@ static void kvm_destroy_vm(struct kvm *kvm)
> > >  	int i;
> > >  	struct mm_struct *mm = kvm->mm;
> > >  
> > > +	if (kvm->dirty_ring_size) {
> > > +		kvm_dirty_ring_free(&kvm->vm_dirty_ring);
> > > +	}
> > > +
> > > +	if (kvm->vm_run) {
> > > +		free_page((unsigned long)kvm->vm_run);
> > > +		kvm->vm_run = NULL;
> > > +	}
> > > +
> > >  	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
> > >  	kvm_destroy_vm_debugfs(kvm);
> > >  	kvm_arch_sync_events(kvm);
> > > @@ -2301,7 +2341,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
> > >  {
> > >  	if (memslot && memslot->dirty_bitmap) {
> > >  		unsigned long rel_gfn = gfn - memslot->base_gfn;
> > > -
> > > +		mark_page_dirty_in_ring(kvm, vcpu, memslot, gfn);
> > >  		set_bit_le(rel_gfn, memslot->dirty_bitmap);
> > >  	}
> > >  }
> > > @@ -2649,6 +2689,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
> > >  }
> > >  EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
> > >  
> > > +static bool kvm_fault_in_dirty_ring(struct kvm *kvm, struct vm_fault *vmf)
> > > +{
> > > +	return (vmf->pgoff >= KVM_DIRTY_LOG_PAGE_OFFSET) &&
> > > +	    (vmf->pgoff < KVM_DIRTY_LOG_PAGE_OFFSET +
> > > +	     kvm->dirty_ring_size / PAGE_SIZE);
> > > +}
> > > +
> > >  static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
> > >  {
> > >  	struct kvm_vcpu *vcpu = vmf->vma->vm_file->private_data;
> > > @@ -2664,6 +2711,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
> > >  	else if (vmf->pgoff == KVM_COALESCED_MMIO_PAGE_OFFSET)
> > >  		page = virt_to_page(vcpu->kvm->coalesced_mmio_ring);
> > >  #endif
> > > +	else if (kvm_fault_in_dirty_ring(vcpu->kvm, vmf))
> > > +		page = kvm_dirty_ring_get_page(
> > > +		    &vcpu->dirty_ring,
> > > +		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
> > >  	else
> > >  		return kvm_arch_vcpu_fault(vcpu, vmf);
> > >  	get_page(page);
> > > @@ -3259,12 +3310,162 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> > >  #endif
> > >  	case KVM_CAP_NR_MEMSLOTS:
> > >  		return KVM_USER_MEM_SLOTS;
> > > +	case KVM_CAP_DIRTY_LOG_RING:
> > > +		/* Version will be zero if arch didn't implement it */
> > > +		return KVM_DIRTY_RING_VERSION;
> > >  	default:
> > >  		break;
> > >  	}
> > >  	return kvm_vm_ioctl_check_extension(kvm, arg);
> > >  }
> > >  
> > > +static void mark_page_dirty_in_ring(struct kvm *kvm,
> > > +				    struct kvm_vcpu *vcpu,
> > > +				    struct kvm_memory_slot *slot,
> > > +				    gfn_t gfn)
> > > +{
> > > +	u32 as_id = 0;
> > > +	u64 offset;
> > > +	int ret;
> > > +	struct kvm_dirty_ring *ring;
> > > +	struct kvm_dirty_ring_indexes *indexes;
> > > +	bool is_vm_ring;
> > > +
> > > +	if (!kvm->dirty_ring_size)
> > > +		return;
> > > +
> > > +	offset = gfn - slot->base_gfn;
> > > +
> > > +	if (vcpu) {
> > > +		as_id = kvm_arch_vcpu_memslots_id(vcpu);
> > > +	} else {
> > > +		as_id = 0;
> > > +		vcpu = kvm_get_running_vcpu();
> > > +	}
> > > +
> > > +	if (vcpu) {
> > > +		ring = &vcpu->dirty_ring;
> > > +		indexes = &vcpu->run->vcpu_ring_indexes;
> > > +		is_vm_ring = false;
> > > +	} else {
> > > +		/*
> > > +		 * Put onto per vm ring because no vcpu context.  Kick
> > > +		 * vcpu0 if ring is full.
> > 
> > What about tasks on vcpu 0? Do guests realize it's a bad idea to put
> > critical tasks there, they will be penalized disproportionally?
> 
> Reasonable question.  So far we can't avoid it because vcpu exit is
> the event mechanism to say "hey please collect dirty bits".  Maybe
> someway is better than this, but I'll need to rethink all these
> over...

Maybe signal an eventfd, and let userspace worry about deciding what to
do.

> > 
> > > +		 */
> > > +		vcpu = kvm->vcpus[0];
> > > +		ring = &kvm->vm_dirty_ring;
> > > +		indexes = &kvm->vm_run->vm_ring_indexes;
> > > +		is_vm_ring = true;
> > > +	}
> > > +
> > > +	ret = kvm_dirty_ring_push(ring, indexes,
> > > +				  (as_id << 16)|slot->id, offset,
> > > +				  is_vm_ring);
> > > +	if (ret < 0) {
> > > +		if (is_vm_ring)
> > > +			pr_warn_once("vcpu %d dirty log overflow\n",
> > > +				     vcpu->vcpu_id);
> > > +		else
> > > +			pr_warn_once("per-vm dirty log overflow\n");
> > > +		return;
> > > +	}
> > > +
> > > +	if (ret)
> > > +		kvm_make_request(KVM_REQ_DIRTY_RING_FULL, vcpu);
> > > +}
> > > +
> > > +void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
> > > +{
> > > +	struct kvm_memory_slot *memslot;
> > > +	int as_id, id;
> > > +
> > > +	as_id = slot >> 16;
> > > +	id = (u16)slot;
> > > +	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
> > > +		return;
> > > +
> > > +	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> > > +	if (offset >= memslot->npages)
> > > +		return;
> > > +
> > > +	spin_lock(&kvm->mmu_lock);
> > > +	/* FIXME: we should use a single AND operation, but there is no
> > > +	 * applicable atomic API.
> > > +	 */
> > > +	while (mask) {
> > > +		clear_bit_le(offset + __ffs(mask), memslot->dirty_bitmap);
> > > +		mask &= mask - 1;
> > > +	}
> > > +
> > > +	kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
> > > +	spin_unlock(&kvm->mmu_lock);
> > > +}
> > > +
> > > +static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
> > > +{
> > > +	int r;
> > > +
> > > +	/* the size should be power of 2 */
> > > +	if (!size || (size & (size - 1)))
> > > +		return -EINVAL;
> > > +
> > > +	/* Should be bigger to keep the reserved entries, or a page */
> > > +	if (size < kvm_dirty_ring_get_rsvd_entries() *
> > > +	    sizeof(struct kvm_dirty_gfn) || size < PAGE_SIZE)
> > > +		return -EINVAL;
> > > +
> > > +	if (size > KVM_DIRTY_RING_MAX_ENTRIES *
> > > +	    sizeof(struct kvm_dirty_gfn))
> > > +		return -E2BIG;
> > 
> > KVM_DIRTY_RING_MAX_ENTRIES is not part of UAPI.
> > So how does userspace know what's legal?
> > Do you expect it to just try?
> 
> Yep that's what I thought. :)
> 
> Please grep E2BIG in QEMU repo target/i386/kvm.c...  won't be hard to
> do imho..

I don't see anything except just failing. Do we really have something
trying to find a working value? What would even be a reasonable range?
Start from UINT_MAX and work down? In which increments?
This is just a ton of overhead for what could have been a
simple query.

> > More likely it will just copy the number from kernel and can
> > never ever make it smaller.
> 
> Not sure, but for sure I can probably move KVM_DIRTY_RING_MAX_ENTRIES
> to uapi too.
> 
> Thanks,

Won't help as you can't change it ever then.
You need it runtime discoverable.
Or again, keep it in userspace memory and then you don't
really care what size it is.


> -- 
> Peter Xu

