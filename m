Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C5125BE85
	for <lists+kvm@lfdr.de>; Thu,  3 Sep 2020 11:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728305AbgICJfm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 05:35:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32197 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726109AbgICJfd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Sep 2020 05:35:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599125729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=R92Upxnr3H/DS/34/IC4k818RkZNNRAZ1LE4yO3sZDw=;
        b=Ttbh6DvKG8yBAodJSdeS3bD/fPUHHnS4DTxLBo9Wjd7rNUtbdEqwJHdmsrpmG75QZxP7Yk
        1VLUK8yKhogjuKdHkTbfNjcLrBsV3y87ShW2httvnuWD3bZbjeGUnENM673m5+Q+JgJAp7
        FqpgKCNxkTPtNwfAa9psT1/l6IJoj7I=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-_2GzLi4aPv-ujV_YTDQIPw-1; Thu, 03 Sep 2020 05:35:27 -0400
X-MC-Unique: _2GzLi4aPv-ujV_YTDQIPw-1
Received: by mail-wm1-f72.google.com with SMTP id u5so502025wme.3
        for <kvm@vger.kernel.org>; Thu, 03 Sep 2020 02:35:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=R92Upxnr3H/DS/34/IC4k818RkZNNRAZ1LE4yO3sZDw=;
        b=r/Mw0YV51vouyoemgbPu+MX90mi/PMWAg+Z4j+Anii5hARmAgStETbWTZxFOpJzlL3
         anZIEppjQ0JDJUrverU36C3OSY4K1cU7xr0RgcHHfqYWoeQi7OBdw1Na0A0dPS5oInf1
         oEz8HaflMovkExy8GlQZNAE7B4p2g2E+uVoC4Imwkv9oORG9Ys+KU2H1S+a6MuvyowWN
         DB7E5TAYOG4bI9GjJp3GmYfF3uBS5WD4E4mG43JENKDQU/Q8Ebiddr3k9FmeWpSZDkUW
         7Zfh11DVvfBCYiwYjLmzT3aTQAn7LuWZ98soHxpeTvBRzKmfL74y0zJ8I6gkyO6rgVNe
         b7Wg==
X-Gm-Message-State: AOAM532kNOrjddJFLVRWJQ5P1YQM+XBKypdMDa6RerzeEOoTW/YG816c
        R2RmQXc24IwJ/vGTY48YgBbnD503wiOtS47rLJwXHgYH0oFJKgNpoDOYDRpD/d2l4R/ArKYSG5E
        8oVNPnmaDA+AV
X-Received: by 2002:a5d:6343:: with SMTP id b3mr1541338wrw.179.1599125725921;
        Thu, 03 Sep 2020 02:35:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx2ljXOXR9hx1S2cziAVgDhmpBaRJO12qtAtV8Bk9nU0vaAKw2kNRlwzyxo31VO+Glw6vFcOw==
X-Received: by 2002:a5d:6343:: with SMTP id b3mr1541313wrw.179.1599125725600;
        Thu, 03 Sep 2020 02:35:25 -0700 (PDT)
Received: from redhat.com (bzq-79-177-107-202.red.bezeqint.net. [79.177.107.202])
        by smtp.gmail.com with ESMTPSA id f19sm3333920wmh.44.2020.09.03.02.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 02:35:24 -0700 (PDT)
Date:   Thu, 3 Sep 2020 05:35:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Julia Suvorova <jsuvorov@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] KVM: x86: introduce KVM_MEM_PCI_HOLE memory
Message-ID: <20200903053350-mutt-send-email-mst@kernel.org>
References: <20200807141232.402895-1-vkuznets@redhat.com>
 <20200807141232.402895-3-vkuznets@redhat.com>
 <20200814023139.GB4845@linux.intel.com>
 <87h7shwoh1.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7shwoh1.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 01, 2020 at 04:39:22PM +0200, Vitaly Kuznetsov wrote:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
> 
> > On Fri, Aug 07, 2020 at 04:12:31PM +0200, Vitaly Kuznetsov wrote:
> >> PCIe config space can (depending on the configuration) be quite big but
> >> usually is sparsely populated. Guest may scan it by accessing individual
> >> device's page which, when device is missing, is supposed to have 'pci
> >> hole' semantics: reads return '0xff' and writes get discarded. Compared
> >> to the already existing KVM_MEM_READONLY, VMM doesn't need to allocate
> >> real memory and stuff it with '0xff'.
> >> 
> >> Suggested-by: Michael S. Tsirkin <mst@redhat.com>
> >> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> >> ---
> >>  Documentation/virt/kvm/api.rst  | 18 ++++++++++-----
> >>  arch/x86/include/uapi/asm/kvm.h |  1 +
> >>  arch/x86/kvm/mmu/mmu.c          |  5 ++++-
> >>  arch/x86/kvm/mmu/paging_tmpl.h  |  3 +++
> >>  arch/x86/kvm/x86.c              | 10 ++++++---
> >>  include/linux/kvm_host.h        |  3 +++
> >>  include/uapi/linux/kvm.h        |  2 ++
> >>  virt/kvm/kvm_main.c             | 39 +++++++++++++++++++++++++++------
> >>  8 files changed, 64 insertions(+), 17 deletions(-)
> >> 
> >> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> >> index 644e5326aa50..dc4172352635 100644
> >> --- a/Documentation/virt/kvm/api.rst
> >> +++ b/Documentation/virt/kvm/api.rst
> >> @@ -1241,6 +1241,7 @@ yet and must be cleared on entry.
> >>    /* for kvm_memory_region::flags */
> >>    #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
> >>    #define KVM_MEM_READONLY	(1UL << 1)
> >> +  #define KVM_MEM_PCI_HOLE		(1UL << 2)
> >>  
> >>  This ioctl allows the user to create, modify or delete a guest physical
> >>  memory slot.  Bits 0-15 of "slot" specify the slot id and this value
> >> @@ -1268,12 +1269,17 @@ It is recommended that the lower 21 bits of guest_phys_addr and userspace_addr
> >>  be identical.  This allows large pages in the guest to be backed by large
> >>  pages in the host.
> >>  
> >> -The flags field supports two flags: KVM_MEM_LOG_DIRTY_PAGES and
> >> -KVM_MEM_READONLY.  The former can be set to instruct KVM to keep track of
> >> -writes to memory within the slot.  See KVM_GET_DIRTY_LOG ioctl to know how to
> >> -use it.  The latter can be set, if KVM_CAP_READONLY_MEM capability allows it,
> >> -to make a new slot read-only.  In this case, writes to this memory will be
> >> -posted to userspace as KVM_EXIT_MMIO exits.
> >> +The flags field supports the following flags: KVM_MEM_LOG_DIRTY_PAGES,
> >> +KVM_MEM_READONLY, KVM_MEM_PCI_HOLE:
> >> +- KVM_MEM_LOG_DIRTY_PAGES: log writes.  Use KVM_GET_DIRTY_LOG to retreive
> >> +  the log.
> >> +- KVM_MEM_READONLY: exit to userspace with KVM_EXIT_MMIO on writes.  Only
> >> +  available when KVM_CAP_READONLY_MEM is present.
> >> +- KVM_MEM_PCI_HOLE: always return 0xff on reads, exit to userspace with
> >> +  KVM_EXIT_MMIO on writes.  Only available when KVM_CAP_PCI_HOLE_MEM is
> >> +  present.  When setting the memory region 'userspace_addr' must be NULL.
> >> +  This flag is mutually exclusive with KVM_MEM_LOG_DIRTY_PAGES and with
> >> +  KVM_MEM_READONLY.
> >>  
> >>  When the KVM_CAP_SYNC_MMU capability is available, changes in the backing of
> >>  the memory region are automatically reflected into the guest.  For example, an
> >> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> >> index 17c5a038f42d..cf80a26d74f5 100644
> >> --- a/arch/x86/include/uapi/asm/kvm.h
> >> +++ b/arch/x86/include/uapi/asm/kvm.h
> >> @@ -48,6 +48,7 @@
> >>  #define __KVM_HAVE_XSAVE
> >>  #define __KVM_HAVE_XCRS
> >>  #define __KVM_HAVE_READONLY_MEM
> >> +#define __KVM_HAVE_PCI_HOLE_MEM
> >>  
> >>  /* Architectural interrupt line count. */
> >>  #define KVM_NR_INTERRUPTS 256
> >> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> >> index fef6956393f7..4a2a7fface1e 100644
> >> --- a/arch/x86/kvm/mmu/mmu.c
> >> +++ b/arch/x86/kvm/mmu/mmu.c
> >> @@ -3254,7 +3254,7 @@ static int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
> >>  		return PG_LEVEL_4K;
> >>  
> >>  	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, true);
> >> -	if (!slot)
> >> +	if (!slot || (slot->flags & KVM_MEM_PCI_HOLE))
> >
> > This is unnecessary since you're setting disallow_lpage in
> > kvm_alloc_memslot_metadata().
> >
> 
> Yea, redundant precaution, can be dropped.
> 
> >>  		return PG_LEVEL_4K;
> >>  
> >>  	max_level = min(max_level, max_huge_page_level);
> >> @@ -4105,6 +4105,9 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u32 error_code,
> >>  
> >>  	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> >>  
> >> +	if (!write && slot && (slot->flags & KVM_MEM_PCI_HOLE))
> >
> > I'm confused.  Why does this short circuit reads but not writes?
> >
> 
> The idea was that guests shouldn't normally write to these regions and
> we may want to catch them if they do. We can short circuit writes too by
> simply ignoring them.

Another point is that write by guests might need to set bits
in the root port error reporting cap.

> >> +		return RET_PF_EMULATE;
> >> +
> >>  	if (try_async_pf(vcpu, slot, prefault, gfn, gpa, &pfn, write,
> >>  			 &map_writable))
> >>  		return RET_PF_RETRY;
> >> diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
> >> index 5c6a895f67c3..27abd69e69f6 100644
> >> --- a/arch/x86/kvm/mmu/paging_tmpl.h
> >> +++ b/arch/x86/kvm/mmu/paging_tmpl.h
> >> @@ -836,6 +836,9 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gpa_t addr, u32 error_code,
> >>  
> >>  	slot = kvm_vcpu_gfn_to_memslot(vcpu, walker.gfn);
> >>  
> >> +	if (!write_fault && slot && (slot->flags & KVM_MEM_PCI_HOLE))
> >> +		return RET_PF_EMULATE;
> >> +
> >>  	if (try_async_pf(vcpu, slot, prefault, walker.gfn, addr, &pfn,
> >>  			 write_fault, &map_writable))
> >>  		return RET_PF_RETRY;
> >> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> >> index dc4370394ab8..538bc58a22db 100644
> >> --- a/arch/x86/kvm/x86.c
> >> +++ b/arch/x86/kvm/x86.c
> >> @@ -3515,6 +3515,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> >>  	case KVM_CAP_EXCEPTION_PAYLOAD:
> >>  	case KVM_CAP_SET_GUEST_DEBUG:
> >>  	case KVM_CAP_LAST_CPU:
> >> +	case KVM_CAP_PCI_HOLE_MEM:
> >>  		r = 1;
> >>  		break;
> >>  	case KVM_CAP_SYNC_REGS:
> >> @@ -10114,9 +10115,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
> >>  		ugfn = slot->userspace_addr >> PAGE_SHIFT;
> >>  		/*
> >>  		 * If the gfn and userspace address are not aligned wrt each
> >> -		 * other, disable large page support for this slot.
> >> +		 * other, disable large page support for this slot. Also,
> >> +		 * disable large page support for KVM_MEM_PCI_HOLE slots.
> >>  		 */
> >> -		if ((slot->base_gfn ^ ugfn) & (KVM_PAGES_PER_HPAGE(level) - 1)) {
> >> +		if ((slot->flags & KVM_MEM_PCI_HOLE) || ((slot->base_gfn ^ ugfn) &
> >> +				      (KVM_PAGES_PER_HPAGE(level) - 1))) {
> >>  			unsigned long j;
> >>  
> >>  			for (j = 0; j < lpages; ++j)
> >> @@ -10178,7 +10181,8 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
> >>  	 * Nothing to do for RO slots or CREATE/MOVE/DELETE of a slot.
> >>  	 * See comments below.
> >>  	 */
> >> -	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
> >> +	if ((change != KVM_MR_FLAGS_ONLY) ||
> >> +	    (new->flags & (KVM_MEM_READONLY | KVM_MEM_PCI_HOLE)))
> >>  		return;
> >>  
> >>  	/*
> >> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> >> index 989afcbe642f..de1faa64a8ef 100644
> >> --- a/include/linux/kvm_host.h
> >> +++ b/include/linux/kvm_host.h
> >> @@ -1081,6 +1081,9 @@ __gfn_to_memslot(struct kvm_memslots *slots, gfn_t gfn)
> >>  static inline unsigned long
> >>  __gfn_to_hva_memslot(struct kvm_memory_slot *slot, gfn_t gfn)
> >>  {
> >> +	/* Should never be called with a KVM_MEM_PCI_HOLE slot */
> >> +	BUG_ON(!slot->userspace_addr);
> >
> > So _technically_, userspace can hit this by allowing virtual address 0,
> > which is very much non-standard, but theoretically legal.  It'd probably be
> > better to use a value that can't possibly be a valid userspace_addr, e.g. a
> > non-canonical value.
> >
> 
> I think I had '!(slot->flags & KVM_MEM_PCI_HOLE)' check in a previous
> version, we can restore it (if needed) or drop the thing completely.
> 
> >> +
> >>  	return slot->userspace_addr + (gfn - slot->base_gfn) * PAGE_SIZE;
> >>  }
> >>  
> >
> > ...
> >
> >> @@ -2318,6 +2338,11 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> >>  	int r;
> >>  	unsigned long addr;
> >>  
> >> +	if (unlikely(slot && (slot->flags & KVM_MEM_PCI_HOLE))) {
> >> +		memset(data, 0xff, len);
> >> +		return 0;
> >> +	}
> >
> > This feels wrong, shouldn't we be treating PCI_HOLE as MMIO?  Given that
> > this is performance oriented, I would think we'd want to leverage the
> > GPA from the VMCS instead of doing a full translation.
> >
> > That brings up a potential alternative to adding a memslot flag.  What if
> > we instead add a KVM_MMIO_BUS device similar to coalesced MMIO?  I think
> > it'd be about the same amount of KVM code, and it would provide userspace
> > with more flexibility, e.g. I assume it would allow handling even writes
> > wholly within the kernel for certain ranges and/or use cases, and it'd
> > allow stuffing a value other than 0xff (though I have no idea if there is
> > a use case for this).
> 
> I was thinking about making this a bit more generic, like 'immutable'
> memory with a userspace-supplied values, e.g. userspace would be
> providing a region (e.g. a single page which will be mapped to by all
> pages of the slot) but then I failed to find a use-case for that. The
> PCI hole semantics seems to be the only one we actually need in the real
> life.
> 
> Overall, makeing these PCI holes 'special' memory regions (slots) and
> sticking to KVM_SET_USER_MEMORY_REGION feels natural to me. I also think
> it would be much easier to consume from QEMU side as we won't need to
> use a 'special' API when things change (e.g. a device gets added and we
> need to [un]punch a hole in the 'PCI hole' space).
> 
> >
> > Speaking of which, why do writes go to userspace in this series?
> >
> 
> No particular reason actually, if there is no need to catch such
> (stray?) writes we can simply short-circuit them to nop.  

With AER we might want to handle them I think.

> >> +
> >>  	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
> >>  	if (kvm_is_error_hva(addr))
> >>  		return -EFAULT;
> >> -- 
> >> 2.25.4
> >> 
> >
> 
> -- 
> Vitaly

