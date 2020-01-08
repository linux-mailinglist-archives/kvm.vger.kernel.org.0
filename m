Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76DFF134A52
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 19:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgAHSPy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 13:15:54 -0500
Received: from mail-vk1-f195.google.com ([209.85.221.195]:45088 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727507AbgAHSPy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 13:15:54 -0500
Received: by mail-vk1-f195.google.com with SMTP id g7so1210201vkl.12
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 10:15:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PT2sy9N4j7bttbnR678lRlbR5HOc41PObNWQ4DVJkSo=;
        b=IlN0CyxRCKl71/4BD/3CBvYFt3boYd/tHHPBcGm95upMwO5kj9GyPWNcCHBsV59gL1
         zYmC8YHH7Ohk7UBSTn07fXeNnm6Po1bYVh6/MUePAemRFTYOFyd42JmsJsW7iFRy+HaS
         mZm+sdKMu0byN74OUQ4Jd9UAG3bkCQ/tNna4RV7GuCtxz605AUAFQAGl/bDLbVCELcrf
         PrjVitqVmmv1g5B6Oq2txCbsUZ+PVs9IUHAEY3ukqPY71oDwHTpUIa92bfP7+Rg/SS/t
         nWTPm7Ssk8AAzfEhLoixO6Ii6iWYoj6jzdjPKuu0DOwKABLKYi71iWrbIQ8zqvkCMAqT
         6/VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PT2sy9N4j7bttbnR678lRlbR5HOc41PObNWQ4DVJkSo=;
        b=c+VXzAKXcYV5El+Tes8ZLQa0r5BlFosgAaSrHpMVIHPxbXekQ1VdeefSZV1OOpFXAE
         W10f3nvvUChB4CD0Iw0Uu+9v5aBZMO1pxZi04isDz6TCUKd0WUrs+purvVojXTXChgBp
         heCDHkOWVFj4L0KmyrUC2k/o5RBNWMEjr9mgb+XEArBbmx85LhAm/PN1vwElCQUp3N3P
         4ds6TRwXVIOa0tNJlxu1/dPETLkxHa7pkPk/rBL+0WcIOGO8krPIcWNrx9ILmSxp+N78
         hYwEM5839GAiPKia6Rpjg1hBTtKIGfgQgWTOOKqWSozJtRc9JB1+Xj/aUNjpi2+1N5eu
         GVLg==
X-Gm-Message-State: APjAAAXmqQR6fQQBIqFeGz/pIM0fu1rnh8BlB2ZZAfOqVvIuepGYl2KP
        mSTtidoRgJyl9l2ag8M0SWhFs/1MgkElAlXe46LXlQ==
X-Google-Smtp-Source: APXvYqwdreGGAZ0QLeNr00DRMEa5rhbPS7fRtLf1Ck9K5mkSfbtAYchmiihcKGdwaHU06HnTD3UxenrucdXRGU2lXGc=
X-Received: by 2002:a1f:94c1:: with SMTP id w184mr3762369vkd.40.1578507352440;
 Wed, 08 Jan 2020 10:15:52 -0800 (PST)
MIME-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com> <20190926231824.149014-17-bgardon@google.com>
 <20200108172011.GB7096@xz-x1>
In-Reply-To: <20200108172011.GB7096@xz-x1>
From:   Ben Gardon <bgardon@google.com>
Date:   Wed, 8 Jan 2020 10:15:41 -0800
Message-ID: <CANgfPd9mjG_E9F+X6dpRgpsq=01uui2KX5JyNf_5PGgXJ9B9qw@mail.gmail.com>
Subject: Re: [RFC PATCH 16/28] kvm: mmu: Add direct MMU page fault handler
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 8, 2020 at 9:20 AM Peter Xu <peterx@redhat.com> wrote:
>
> On Thu, Sep 26, 2019 at 04:18:12PM -0700, Ben Gardon wrote:
>
> [...]
>
> > +static int handle_direct_page_fault(struct kvm_vcpu *vcpu,
> > +             unsigned long mmu_seq, int write, int map_writable, int level,
> > +             gpa_t gpa, gfn_t gfn, kvm_pfn_t pfn, bool prefault)
> > +{
> > +     struct direct_walk_iterator iter;
> > +     struct kvm_mmu_memory_cache *pf_pt_cache = &vcpu->arch.mmu_page_cache;
> > +     u64 *child_pt;
> > +     u64 new_pte;
> > +     int ret = RET_PF_RETRY;
> > +
> > +     direct_walk_iterator_setup_walk(&iter, vcpu->kvm,
> > +                     kvm_arch_vcpu_memslots_id(vcpu), gpa >> PAGE_SHIFT,
> > +                     (gpa >> PAGE_SHIFT) + 1, MMU_READ_LOCK);
> > +     while (direct_walk_iterator_next_pte(&iter)) {
> > +             if (iter.level == level) {
> > +                     ret = direct_page_fault_handle_target_level(vcpu,
> > +                                     write, map_writable, &iter, pfn,
> > +                                     prefault);
> > +
> > +                     break;
> > +             } else if (!is_present_direct_pte(iter.old_pte) ||
> > +                        is_large_pte(iter.old_pte)) {
> > +                     /*
> > +                      * The leaf PTE for this fault must be mapped at a
> > +                      * lower level, so a non-leaf PTE must be inserted into
> > +                      * the paging structure. If the assignment below
> > +                      * succeeds, it will add the non-leaf PTE and a new
> > +                      * page of page table memory. Then the iterator can
> > +                      * traverse into that new page. If the atomic compare/
> > +                      * exchange fails, the iterator will repeat the current
> > +                      * PTE, so the only thing this function must do
> > +                      * differently is return the page table memory to the
> > +                      * vCPU's fault cache.
> > +                      */
> > +                     child_pt = mmu_memory_cache_alloc(pf_pt_cache);
> > +                     new_pte = generate_nonleaf_pte(child_pt, false);
> > +
> > +                     if (!direct_walk_iterator_set_pte(&iter, new_pte))
> > +                             mmu_memory_cache_return(pf_pt_cache, child_pt);
> > +             }
> > +     }
>
> I have a question on how this will guarantee safe concurrency...
>
> As you mentioned previously somewhere, the design somehow mimics how
> the core mm works with process page tables, and IIUC here the rwlock
> works really like the mmap_sem that we have for the process mm.  So
> with the series now we can have multiple page fault happening with
> read lock held of the mmu_lock to reach here.

Ah, I'm sorry if I put that down somewhere. I think that comparing the
MMU rwlock in this series to the core mm mmap_sem was a mistake. I do
not understand the ways in which the core mm uses the mmap_sem enough
to make such a comparison. You're correct that with two faulting vCPUs
we could have page faults on the same address range happening in
parallel. I'll try to elaborate more on why that's safe.

> Then I'm imagining a case where both vcpu threads faulted on the same
> address range while when they wanted to do different things, like: (1)
> vcpu1 thread wanted to map this as a 2M huge page, while (2) vcpu2
> thread wanted to map this as a 4K page.

By vcpu thread, do you mean the page fault / EPT violation handler
wants to map memory at different levels?. As far as I understand,
vCPUs do not have any intent to map  a page at a certain level when
they take an EPT violation. The page fault handlers could certainly
want to map the memory at different levels. For example, if guest
memory was backed with 2M hugepages and one vCPU tried to do an
instruction fetch on an unmapped page while another tried to read it,
that should result in the page fault handler for the first vCPU trying
to map at 4K and the other trying to map at 2M, as in your example.

> Then is it possible that
> vcpu2 is faster so it firstly setup the pmd as a page table page (via
> direct_walk_iterator_set_pte above),

This is definitely possible

> then vcpu1 quickly overwrite it
> as a huge page (via direct_page_fault_handle_target_level, level=2),
> then I feel like the previous page table page that setup by vcpu2 can
> be lost unnoticed.

There are two possibilities here. 1.) vCPU2 saw vCPU1's modification
to the PTE during its walk. In this case, vCPU2 should not map the
memory at 2M. (I realize that in this example there is a discrepancy
as there's no NX hugepage support in this RFC. I need to add that in
the next version. In this case, vCPU1 would set a bit in the non-leaf
PTE to indicate it was split to allow X on a constituent 4K entry.)
2.) If vCPU2 did not see vCPU1's modification during its walk, it will
indeed try to map the memory at 2M. However in this case the atomic
cpmxchg on the PTE will fail because vCPU2 did not have the current
value of the PTE. In this case the PTE will be re-read and the walk
will continue or the page fault will be retried. When threads using
the direct walk iterator change PTEs with an atomic cmpxchg, they are
guaranteed to know what the value of the PTE was before the cmpxchg
and so that thread is then responsible for any cleanup associated with
the PTE modification - e.g. freeing pages of page table memory.

> I think general process page table does not have this issue is because
> it has per pmd lock so anyone who changes the pmd or beneath it will
> need to take that.  However here we don't have it, instead we only
> depend on the atomic ops, which seems to be not enough for this?

I think that atomic ops (plus rcu to ensure no use-after-free) are
enough in this case, but I could definitely be wrong. If your concern
about the race requires the NX hugepages stuff, I need to get on top
of sending out those patches. If you can think of a race that doesn't
require that, I'd be very excited to hear it.

> Thanks,
>
> > +     direct_walk_iterator_end_traversal(&iter);
> > +
> > +     /* If emulating, flush this vcpu's TLB. */
> > +     if (ret == RET_PF_EMULATE)
> > +             kvm_make_request(KVM_REQ_TLB_FLUSH, vcpu);
> > +
> > +     return ret;
> > +}
>
> --
> Peter Xu
>
