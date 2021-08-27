Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1172E3F925D
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 04:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243007AbhH0Ccr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Aug 2021 22:32:47 -0400
Received: from mga07.intel.com ([134.134.136.100]:37472 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231154AbhH0Ccq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Aug 2021 22:32:46 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="281601373"
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="281601373"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 19:31:58 -0700
X-IronPort-AV: E=Sophos;i="5.84,355,1620716400"; 
   d="scan'208";a="528139305"
Received: from xumingcu-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.172.104])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2021 19:31:49 -0700
Date:   Fri, 27 Aug 2021 10:31:50 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
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
        Dave Hansen <dave.hansen@intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:
> On 24.08.21 02:52, Sean Christopherson wrote:
> > The goal of this RFC is to try and align KVM, mm, and anyone else with skin in the
> > game, on an acceptable direction for supporting guest private memory, e.g. for
> > Intel's TDX.  The TDX architectural effectively allows KVM guests to crash the
> > host if guest private memory is accessible to host userspace, and thus does not
> > play nice with KVM's existing approach of pulling the pfn and mapping level from
> > the host page tables.
> > 
> > This is by no means a complete patch; it's a rough sketch of the KVM changes that
> > would be needed.  The kernel side of things is completely omitted from the patch;
> > the design concept is below.
> > 
> > There's also fair bit of hand waving on implementation details that shouldn't
> > fundamentally change the overall ABI, e.g. how the backing store will ensure
> > there are no mappings when "converting" to guest private.
> > 
> 
> This is a lot of complexity and rather advanced approaches (not saying they
> are bad, just that we try to teach the whole stack something completely
> new).
> 
> 
> What I think would really help is a list of requirements, such that
> everybody is aware of what we actually want to achieve. Let me start:
> 
> GFN: Guest Frame Number
> EPFN: Encrypted Physical Frame Number
> 
> 
> 1) An EPFN must not get mapped into more than one VM: it belongs exactly to
> one VM. It must neither be shared between VMs between processes nor between
> VMs within a processes.
> 
> 
> 2) User space (well, and actually the kernel) must never access an EPFN:
> 
> - If we go for an fd, essentially all operations (read/write) have to
>   fail.
> - If we have to map an EPFN into user space page tables (e.g., to
>   simplify KVM), we could only allow fake swap entries such that "there
>   is something" but it cannot be  accessed and is flagged accordingly.
> - /proc/kcore and friends have to be careful as well and should not read
>   this memory. So there has to be a way to flag these pages.
> 
> 3) We need a way to express the GFN<->EPFN mapping and essentially assign an
> EPFN to a GFN.
> 
> 
> 4) Once we assigned a EPFN to a GFN, that assignment must not longer change.
> Further, an EPFN must not get assigned to multiple GFNs.
> 
> 
> 5) There has to be a way to "replace" encrypted parts by "shared" parts
>    and the other way around.
> 
> What else?

Thanks a lot for this summary. A question about the requirement: do we or
do we not have plan to support assigned device to the protected VM?

If yes. The fd based solution may need change the VFIO interface as well(
though the fake swap entry solution need mess with VFIO too). Because:

1> KVM uses VFIO when assigning devices into a VM.

2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
guest pages will have to be mapped in host IOMMU page table to host pages,
which are pinned during the whole life cycle fo the VM.

3> IOMMU mapping is done during VM creation time by VFIO and IOMMU driver,
in vfio_dma_do_map().

4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get the HPA
and pin the page. 

But if we are using fd based solution, not every GPA can have a HVA, thus
the current VFIO interface to map and pin the GPA(IOVA) wont work. And I
doubt if VFIO can be modified to support this easily.


B.R.
Yu
