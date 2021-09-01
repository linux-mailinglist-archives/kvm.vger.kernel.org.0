Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6332F3FD79D
	for <lists+kvm@lfdr.de>; Wed,  1 Sep 2021 12:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbhIAKZs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Sep 2021 06:25:48 -0400
Received: from mga03.intel.com ([134.134.136.65]:31593 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231903AbhIAKZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Sep 2021 06:25:47 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="218758489"
X-IronPort-AV: E=Sophos;i="5.84,369,1620716400"; 
   d="scan'208";a="218758489"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 03:24:50 -0700
X-IronPort-AV: E=Sophos;i="5.84,369,1620716400"; 
   d="scan'208";a="645686130"
Received: from zhibosun-mobl2.ccr.corp.intel.com (HELO localhost) ([10.255.31.93])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 03:24:40 -0700
Date:   Wed, 1 Sep 2021 18:24:37 +0800
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
Message-ID: <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 31, 2021 at 09:53:27PM -0700, Andy Lutomirski wrote:
> 
> 
> On Thu, Aug 26, 2021, at 7:31 PM, Yu Zhang wrote:
> > On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:
> 
> > Thanks a lot for this summary. A question about the requirement: do we or
> > do we not have plan to support assigned device to the protected VM?
> > 
> > If yes. The fd based solution may need change the VFIO interface as well(
> > though the fake swap entry solution need mess with VFIO too). Because:
> > 
> > 1> KVM uses VFIO when assigning devices into a VM.
> > 
> > 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
> > guest pages will have to be mapped in host IOMMU page table to host pages,
> > which are pinned during the whole life cycle fo the VM.
> > 
> > 3> IOMMU mapping is done during VM creation time by VFIO and IOMMU driver,
> > in vfio_dma_do_map().
> > 
> > 4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get the HPA
> > and pin the page. 
> > 
> > But if we are using fd based solution, not every GPA can have a HVA, thus
> > the current VFIO interface to map and pin the GPA(IOVA) wont work. And I
> > doubt if VFIO can be modified to support this easily.
> > 
> > 
> 
> Do you mean assigning a normal device to a protected VM or a hypothetical protected-MMIO device?
> 
> If the former, it should work more or less like with a non-protected VM. mmap the VFIO device, set up a memslot, and use it.  I'm not sure whether anyone will actually do this, but it should be possible, at least in principle.  Maybe someone will want to assign a NIC to a TDX guest.  An NVMe device with the understanding that the guest can't trust it wouldn't be entirely crazy ether.
> 
> If the latter, AFAIK there is no spec for how it would work even in principle. Presumably it wouldn't work quite like VFIO -- instead, the kernel could have a protection-virtual-io-fd mechanism, and that fd could be bound to a memslot in whatever way we settle on for binding secure memory to a memslot.
> 

Thanks Andy. I was asking the first scenario.

Well, I agree it is doable if someone really want some assigned
device in TD guest. As Kevin mentioned in his reply, HPA can be
generated, by extending VFIO with a new mapping protocol which
uses fd+offset, instead of HVA. 

Another issue is current TDX does not support DMA encryption, and
only shared GPA memory shall be mapped in the VT-d. So to support
this, KVM may need to work with VFIO to dynamically program host
IOPT(IOMMU Page Table) when TD guest notifies a shared GFN range(e.g.,
with a MAP_GPA TDVMCALL), instead of prepopulating the IOPT at VM
creation time, by mapping entire GFN ranges of a guest.

So my inclination would be to just disallow using of VFIO device in
TDX first, until we have real requirement(with above enabling work
finished). 

B.R.
Yu
