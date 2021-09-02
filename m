Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2963FEAAF
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 10:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244478AbhIBIgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 04:36:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:35783 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244387AbhIBIgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 04:36:03 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="304596704"
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="304596704"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 01:35:05 -0700
X-IronPort-AV: E=Sophos;i="5.84,371,1620716400"; 
   d="scan'208";a="499636365"
Received: from liuj4-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.173.176])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 01:34:56 -0700
Date:   Thu, 2 Sep 2021 16:34:53 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
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
Message-ID: <20210902083453.aeouc6fob53ydtc2@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
 <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
 <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org>
 <2b2740ec-fa89-e4c3-d175-824e439874a6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b2740ec-fa89-e4c3-d175-824e439874a6@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 01, 2021 at 06:27:20PM +0200, David Hildenbrand wrote:
> On 01.09.21 18:07, Andy Lutomirski wrote:
> > On 9/1/21 3:24 AM, Yu Zhang wrote:
> > > On Tue, Aug 31, 2021 at 09:53:27PM -0700, Andy Lutomirski wrote:
> > > > 
> > > > 
> > > > On Thu, Aug 26, 2021, at 7:31 PM, Yu Zhang wrote:
> > > > > On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:
> > > > 
> > > > > Thanks a lot for this summary. A question about the requirement: do we or
> > > > > do we not have plan to support assigned device to the protected VM?
> > > > > 
> > > > > If yes. The fd based solution may need change the VFIO interface as well(
> > > > > though the fake swap entry solution need mess with VFIO too). Because:
> > > > > 
> > > > > 1> KVM uses VFIO when assigning devices into a VM.
> > > > > 
> > > > > 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
> > > > > guest pages will have to be mapped in host IOMMU page table to host pages,
> > > > > which are pinned during the whole life cycle fo the VM.
> > > > > 
> > > > > 3> IOMMU mapping is done during VM creation time by VFIO and IOMMU driver,
> > > > > in vfio_dma_do_map().
> > > > > 
> > > > > 4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get the HPA
> > > > > and pin the page.
> > > > > 
> > > > > But if we are using fd based solution, not every GPA can have a HVA, thus
> > > > > the current VFIO interface to map and pin the GPA(IOVA) wont work. And I
> > > > > doubt if VFIO can be modified to support this easily.
> > > > > 
> > > > > 
> > > > 
> > > > Do you mean assigning a normal device to a protected VM or a hypothetical protected-MMIO device?
> > > > 
> > > > If the former, it should work more or less like with a non-protected VM. mmap the VFIO device, set up a memslot, and use it.  I'm not sure whether anyone will actually do this, but it should be possible, at least in principle.  Maybe someone will want to assign a NIC to a TDX guest.  An NVMe device with the understanding that the guest can't trust it wouldn't be entirely crazy ether.
> > > > 
> > > > If the latter, AFAIK there is no spec for how it would work even in principle. Presumably it wouldn't work quite like VFIO -- instead, the kernel could have a protection-virtual-io-fd mechanism, and that fd could be bound to a memslot in whatever way we settle on for binding secure memory to a memslot.
> > > > 
> > > 
> > > Thanks Andy. I was asking the first scenario.
> > > 
> > > Well, I agree it is doable if someone really want some assigned
> > > device in TD guest. As Kevin mentioned in his reply, HPA can be
> > > generated, by extending VFIO with a new mapping protocol which
> > > uses fd+offset, instead of HVA.
> > 
> > I'm confused.  I don't see why any new code is needed for this at all.
> > Every proposal I've seen for handling TDX memory continues to handle TDX
> > *shared* memory exactly like regular guest memory today.  The only
> > differences are that more hole punching will be needed, which will
> > require lightweight memslots (to have many of them), memslots with
> > holes, or mappings backing memslots with holes (which can be done with
> > munmap() on current kernels).
> > 
> > So you can literally just mmap a VFIO device and expect it to work,
> > exactly like it does right now.  Whether the guest will be willing to
> > use the device will depend on the guest security policy (all kinds of
> > patches about that are flying around), but if the guest tries to use it,
> > it really should just work.
> 
> ... but if you end up mapping private memory into IOMMU of the device and
> the device ends up accessing that memory, we're in the same position that
> the host might get capped, just like access from user space, no?

Well, according to the spec:

  - If the result of the translation results in a physical address with a TD
  private key ID, then the IOMMU will abort the transaction and report a VT-d
  DMA remapping failure.

  - If the GPA in the transaction that is input to the IOMMU is private (SHARED
  bit is 0), then the IOMMU may abort the transaction and report a VT-d DMA
  remapping failure.

So I guess mapping private GPAs in IOMMU is not that dangerous as mapping
into userspace. Though still wrong.

> 
> Sure, you can map only the complete duplicate shared-memory region into the
> IOMMU of the device, that would work. Shame vfio mostly always pins all
> guest memory and you essentially cannot punch holes into the shared memory
> anymore -- resulting in the worst case in a duplicate memory consumption for
> your VM.
> 
> So you'd actually want to map only the *currently* shared pieces into the
> IOMMU and update the mappings on demand. Having worked on something related,

Exactly. On demand mapping and page pinning for shared memory is necessary.

> I can only say that 64k individual mappings, and not being able to modify
> existing mappings except completely deleting them to replace with something
> new (!atomic), can be quite an issue for bigger VMs.

Do you mean atomicity in mapping/unmapping can hardly be guaranteed during
the shared <-> private transition? May I ask for elaboration? Thanks!

B.R.
Yu
