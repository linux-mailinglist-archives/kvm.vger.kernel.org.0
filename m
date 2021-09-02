Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1029C3FEA87
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 10:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244361AbhIBIUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 04:20:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:14140 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244184AbhIBIUd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 04:20:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="219035747"
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="219035747"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 01:19:34 -0700
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="532831032"
Received: from liuj4-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.173.176])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 01:19:25 -0700
Date:   Thu, 2 Sep 2021 16:19:23 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
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
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210902081923.lertnjsgnskegkmn@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
 <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
 <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 09:07:59AM -0700, Andy Lutomirski wrote:
> On 9/1/21 3:24 AM, Yu Zhang wrote:
> > On Tue, Aug 31, 2021 at 09:53:27PM -0700, Andy Lutomirski wrote:
> >>
> >>
> >> On Thu, Aug 26, 2021, at 7:31 PM, Yu Zhang wrote:
> >>> On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:
> >>
> >>> Thanks a lot for this summary. A question about the requirement: do we or
> >>> do we not have plan to support assigned device to the protected VM?
> >>>
> >>> If yes. The fd based solution may need change the VFIO interface as well(
> >>> though the fake swap entry solution need mess with VFIO too). Because:
> >>>
> >>> 1> KVM uses VFIO when assigning devices into a VM.
> >>>
> >>> 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
> >>> guest pages will have to be mapped in host IOMMU page table to host pages,
> >>> which are pinned during the whole life cycle fo the VM.
> >>>
> >>> 3> IOMMU mapping is done during VM creation time by VFIO and IOMMU driver,
> >>> in vfio_dma_do_map().
> >>>
> >>> 4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get the HPA
> >>> and pin the page. 
> >>>
> >>> But if we are using fd based solution, not every GPA can have a HVA, thus
> >>> the current VFIO interface to map and pin the GPA(IOVA) wont work. And I
> >>> doubt if VFIO can be modified to support this easily.
> >>>
> >>>
> >>
> >> Do you mean assigning a normal device to a protected VM or a hypothetical protected-MMIO device?
> >>
> >> If the former, it should work more or less like with a non-protected VM. mmap the VFIO device, set up a memslot, and use it.  I'm not sure whether anyone will actually do this, but it should be possible, at least in principle.  Maybe someone will want to assign a NIC to a TDX guest.  An NVMe device with the understanding that the guest can't trust it wouldn't be entirely crazy ether.
> >>
> >> If the latter, AFAIK there is no spec for how it would work even in principle. Presumably it wouldn't work quite like VFIO -- instead, the kernel could have a protection-virtual-io-fd mechanism, and that fd could be bound to a memslot in whatever way we settle on for binding secure memory to a memslot.
> >>
> > 
> > Thanks Andy. I was asking the first scenario.
> > 
> > Well, I agree it is doable if someone really want some assigned
> > device in TD guest. As Kevin mentioned in his reply, HPA can be
> > generated, by extending VFIO with a new mapping protocol which
> > uses fd+offset, instead of HVA. 
> 
> I'm confused.  I don't see why any new code is needed for this at all.
> Every proposal I've seen for handling TDX memory continues to handle TDX
> *shared* memory exactly like regular guest memory today.  The only
> differences are that more hole punching will be needed, which will
> require lightweight memslots (to have many of them), memslots with
> holes, or mappings backing memslots with holes (which can be done with
> munmap() on current kernels).

Thanks for pointing this out. And yes, for DMAs not capable of encryption(
which is the case in current TDX). GUP shall work as it is in VFIO. :)

> 
> So you can literally just mmap a VFIO device and expect it to work,
> exactly like it does right now.  Whether the guest will be willing to
> use the device will depend on the guest security policy (all kinds of
> patches about that are flying around), but if the guest tries to use it,
> it really should just work.
> 

But I think there's still problem. For now,

1> Qemu mmap()s all GPAs into its HVA space, when the VM is created.
2> With no idea which part of guest memory shall be shared, VFIO will just
set up the IOPT, by mapping whole GPA ranges in IOPT. 
3> And those GPAs are actually private ones, with no shared-bit set.

Later when guest tries to perform a DMA(using a shared GPA), IO page fault
shall happen.

> > 
> > Another issue is current TDX does not support DMA encryption, and
> > only shared GPA memory shall be mapped in the VT-d. So to support
> > this, KVM may need to work with VFIO to dynamically program host
> > IOPT(IOMMU Page Table) when TD guest notifies a shared GFN range(e.g.,
> > with a MAP_GPA TDVMCALL), instead of prepopulating the IOPT at VM
> > creation time, by mapping entire GFN ranges of a guest.
> 
> Given that there is no encrypted DMA support, shouldn't the only IOMMU
> mappings (real host-side IOMMU) that point at guest memory be for
> non-encrypted DMA?  I don't see how this interacts at all.  If the guest
> tries to MapGPA to turn a shared MMIO page into private, the host should
> fail the hypercall because the operation makes no sense.
> 
> It is indeed the case that, with a TDX guest, MapGPA shared->private to
> a page that was previously used for unencrypted DMA will need to avoid
> having IOPT entries to the new private page, but even that doesn't seem
> particularly bad.  The fd+special memslot proposal for private memory
> means that shared *backing store* pages never actually transition
> between shared and private without being completely freed.
> 
> As far as I can tell, the actual problem you're referring to is:
> 
> >>> 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
> >>> guest pages will have to be mapped in host IOMMU page table to host
> pages,
> >>> which are pinned during the whole life cycle fo the VM.

Yes. That's the primary concern. :)

> 
> In principle, you could actually initialize a TDX guest with all of its
> memory shared and all of it mapped in the host IOMMU.  When a guest
> turns some pages private, user code could punch a hole in the memslot,
> allocate private memory at that address, but leave the shared backing
> store in place and still mapped in the host IOMMU.  The result would be
> that guest-initiated DMA to the previously shared address would actually
> work but would hit pages that are invisible to the guest.  And a whole
> bunch of memory would be waste, but the whole system should stll work.

Do you mean to let VFIO & IOMMU to treat all guest memory as shared first,
and then just allocate the private pages in another backing store? I guess
that could work, but with the cost of allocating roughly 2x physical pages
of the guest RAM size. After all, the shared pages shall be only a small
part of guest memory.

If device assignment is desired in current TDX. My understanding of the 
enabling work would be like this:
1> Change qemu to not trigger VFIO_IOMMU_MAP_DMA for the TD, thus no IOPT
prepopulated, and no physical page allocated.
2> KVM forwards MapGPA(private -> shared) request to Qemu.
3> Qemu asks VFIO to pin and map the shared GPAs.

For private -> shared transitions, the memslot punching, IOPT unmapping,
and iotlb flushing are necessary. Possibly new interface between VFIO and
KVM is needed.

But actually I am not sure if people really want assigned device in current
TDX. Bottleneck of the performance should be the copying to/from swiotlb
buffers.

B.R.
Yu
