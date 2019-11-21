Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224BF104F73
	for <lists+kvm@lfdr.de>; Thu, 21 Nov 2019 10:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfKUJkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Nov 2019 04:40:05 -0500
Received: from foss.arm.com ([217.140.110.172]:53292 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfKUJkF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Nov 2019 04:40:05 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E87E3DA7;
        Thu, 21 Nov 2019 01:40:04 -0800 (PST)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.145.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7C8603F52E;
        Thu, 21 Nov 2019 01:40:04 -0800 (PST)
Date:   Thu, 21 Nov 2019 10:40:03 +0100
From:   Christoffer Dall <christoffer.dall@arm.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        borntraeger@de.ibm.com, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Memory regions and VMAs across architectures
Message-ID: <20191121094003.GB22554@e113682-lin.lund.arm.com>
References: <20191108111920.GD17608@e113682-lin.lund.arm.com>
 <20191120034448.GC25890@linux.intel.com>
 <20191120115216.GL8317@e113682-lin.lund.arm.com>
 <20191120152807.GA32572@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120152807.GA32572@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 20, 2019 at 07:28:07AM -0800, Sean Christopherson wrote:
> On Wed, Nov 20, 2019 at 12:52:16PM +0100, Christoffer Dall wrote:
> > On Tue, Nov 19, 2019 at 07:44:48PM -0800, Sean Christopherson wrote:
> > > On Fri, Nov 08, 2019 at 12:19:20PM +0100, Christoffer Dall wrote:
> > > > First, what prevents user space from messing around with the VMAs after
> > > > kvm_arch_prepare_memory_region() completes?  If nothing, then what is
> > > > the value of the cheks we perform wrt. to VMAs?
> > > 
> > > Arm's prepare_memory_region() holds mmap_sem and mmu_lock while processing
> > > the VMAs and populating the stage 2 page tables.  Holding mmap_sem prevents
> > > the VMAs from being invalidated while the stage 2 tables are populated,
> > > e.g. prevents racing with the mmu notifier.  The VMAs could be modified
> > > after prepare_memory_region(), but the mmu notifier will ensure they are
> > > unmapped from stage2 prior the the host change taking effect.  So I think
> > > you're safe (famous last words).
> > > 
> > 
> > So we for example check:
> > 
> > 	writeable = !(memslot->falgs & KVM_MEM_READONLY);
> > 	if (writeable && !(vma->vm_flags & VM_WRITE))
> > 		return -EPERM;
> > 
> > And yes, user space can then unmap the VMAs and MMU notifiers will
> > unmap the stage 2 entries, but user space can then create a new
> > read-only VMA covering the area of the memslot and the fault-handling
> > path will have to deal with this same check later.Only, the fault
> > handling path, via gfn_to_pfn_prot(), returns an address based on an
> > entirely different set of mechanics, than our prepare_memory_region,
> > which I think indicates we are doing something wrong somewhere, and we
> > should have a common path for faulting things in, for I/O, both if we do
> > this up-front or if we do this at fault time.
> 
> Unconditionally interpreting vm_pgoff as a physical address does not seem
> correct.  There are cases where that might be correct, e.g. if the backing
> (virtual) file is a flat representation of the address space, which appears
> to be the case on some architectures, e.g. for PCI handling.  But even then
> there should be some confirmation that the VMA is actually associated with
> such a file, otherwise KVM is at the mercy of userspace to do the right
> thing (unless there are other guarantees on arm I am unaware of).
> 
> > > > Second, why would arm/arm64 need special handling for I/O mappings
> > > > compared to other architectures, and how is this dealt with for
> > > > x86/s390/power/... ?
> > > 
> > > As Ard mentioned, it looks like an optimization.  The "passthrough"
> > > part from the changelog implies that VM_PFNMAP memory regions are exclusive
> > > to the guest.  Mapping the entire thing would be a nice boot optimization
> > > as it would save taking page faults on every page of the MMIO region.
> > > 
> > > As for how this is different from other archs... at least on x86, VM_PFNMAP
> > > isn't guaranteed to be passthrough or even MMIO, e.g. prefaulting the
> > > pages may actually trigger allocation, and remapping the addresses could be
> > > flat out wrong.
> > 
> > What does VM_PFNMAP mean on x86?  I didn't think we were relying on
> > anything architecture specific in their meaning in the arm code, and I
> > thought the VM_PFNMAP was a generic mm flag with generic mm meaning,
> > but I could be wrong here?
> 
> No, you're correct, VM_PFNMAP is a generic flag that state the VMA doesn't
> have an associated struct page and is being managed directly by something
> other than the core mmu.
> 
> But not having a struct page doesn't guarantee that the PFN is backed by
> MMIO, or that it is exclusive to the guest (although in practice this is
> probably the case 99.9999% of the time).  E.g. x86 supports having guest
> memory backed by regular ram that is hidden from the host kernel via
> 'mem=', which will show up as VM_PFNMAP.
> 
> > Is there any valid semantics for creating a memslot backed by a
> > VM_PFNMAP on x86, and if so, what are those?
> > 
> > Similarly, if you do map a device region straight to the guest on x86,
> > how is that handled?  (A pointer to the right place in the myriad of EPT
> > and shadow code in x86 would be much appreciated.)
> 
> There is no special handling in x86 for VM_PFNMAP memory, we rely on KVM's
> generic __gfn_to_pfn_memslot() to retrieve the PFN on demand, and use
> mmu_notifier_seq to ensure the stale PFNs (invalidated in the host) aren't
> inserted into the guest page tables.  Effectively the same thing arm does,
> sans the prepare_memory_region() shenanigans.

Thanks Sean, I'll have a look at reworking said shenanigans ;)

    Christoffer
