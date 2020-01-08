Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A343134B21
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2020 20:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730241AbgAHTAP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jan 2020 14:00:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37918 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729669AbgAHTAO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jan 2020 14:00:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578510013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=VEfBM2bA1EDyaf2qQZapTw+J62mF3DzheUi0u1tcZtc=;
        b=QuD9ERO6f3xk7rm9q+/x+V5GqI9ypolA5/2xTicglNYDZg1ByZTOyRYbL6MPHMnBZNoETl
        Regk9HNOXaMJ+dWiDUBsJEE1SXLXyt7W4Gdkq+lFwaizIOvYxNiITaOoTchR2gXVX8xxUx
        32qnGVA1rhWETmpUUps8Caw3F7XCiag=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-AESwyVNDMoWArrli7Q6x_Q-1; Wed, 08 Jan 2020 14:00:12 -0500
X-MC-Unique: AESwyVNDMoWArrli7Q6x_Q-1
Received: by mail-qt1-f199.google.com with SMTP id m8so2589219qta.20
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2020 11:00:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VEfBM2bA1EDyaf2qQZapTw+J62mF3DzheUi0u1tcZtc=;
        b=tqA/ri61iXfKdMJ+ixU/FNjXZ4YaPZUK3+pQh/nnp2cohxEIuw0GHKK+zmYoFvlpge
         YxEhzYOPRNzN+RXE84l7dp+TLhy1stRsGZW8jNPSZvyfmY39bEUkrPBz4NAJU/emxEER
         Yu1RXXvb/Ow33eijc828j0CXFhE5BBY9mEjNdOX0htBAAxoCnlIdNNWXkDQWDLGT4REo
         E63fb/yh+/O41KYYDHd/GmS5/yiz9vjO4lsBx6DEslpPAl5aOycwWwfl8+i92BagjKYX
         1YLAF1DNJwCPCbs+DsMogLmmDeOsyOTd/5pRVsZgmbPwYU1aIdyUsKF+blExK8grM+iH
         JkUg==
X-Gm-Message-State: APjAAAVy61lSCFd8taKGyugRClESCoQVqu2Mjr/2rJjHoupKgi9fYCK6
        ugfT+C/5C+WbHF/msm7C7XK3s5u/OfjWCl7YkMJ+efQ1qQgruNhHzLJL2GakXBrmKpk+Xlp5fmb
        gUBvKP4ceKTLg
X-Received: by 2002:a37:693:: with SMTP id 141mr5721750qkg.134.1578510011164;
        Wed, 08 Jan 2020 11:00:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqyUdL3Y6iSBRhTAMOhXtix6XQlldUMiRAXjtEKkDiWN18P5wXyt6n384Mv8h0VfHGSznMaqvQ==
X-Received: by 2002:a37:693:: with SMTP id 141mr5721718qkg.134.1578510010786;
        Wed, 08 Jan 2020 11:00:10 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id r10sm1773671qkm.23.2020.01.08.11.00.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 11:00:10 -0800 (PST)
Date:   Wed, 8 Jan 2020 14:00:09 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [RFC PATCH 16/28] kvm: mmu: Add direct MMU page fault handler
Message-ID: <20200108190009.GD7096@xz-x1>
References: <20190926231824.149014-1-bgardon@google.com>
 <20190926231824.149014-17-bgardon@google.com>
 <20200108172011.GB7096@xz-x1>
 <CANgfPd9mjG_E9F+X6dpRgpsq=01uui2KX5JyNf_5PGgXJ9B9qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANgfPd9mjG_E9F+X6dpRgpsq=01uui2KX5JyNf_5PGgXJ9B9qw@mail.gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 08, 2020 at 10:15:41AM -0800, Ben Gardon wrote:
> On Wed, Jan 8, 2020 at 9:20 AM Peter Xu <peterx@redhat.com> wrote:
> >
> > On Thu, Sep 26, 2019 at 04:18:12PM -0700, Ben Gardon wrote:
> >
> > [...]
> >
> > > +static int handle_direct_page_fault(struct kvm_vcpu *vcpu,
> > > +             unsigned long mmu_seq, int write, int map_writable, int level,
> > > +             gpa_t gpa, gfn_t gfn, kvm_pfn_t pfn, bool prefault)
> > > +{
> > > +     struct direct_walk_iterator iter;
> > > +     struct kvm_mmu_memory_cache *pf_pt_cache = &vcpu->arch.mmu_page_cache;
> > > +     u64 *child_pt;
> > > +     u64 new_pte;
> > > +     int ret = RET_PF_RETRY;
> > > +
> > > +     direct_walk_iterator_setup_walk(&iter, vcpu->kvm,
> > > +                     kvm_arch_vcpu_memslots_id(vcpu), gpa >> PAGE_SHIFT,
> > > +                     (gpa >> PAGE_SHIFT) + 1, MMU_READ_LOCK);
> > > +     while (direct_walk_iterator_next_pte(&iter)) {
> > > +             if (iter.level == level) {
> > > +                     ret = direct_page_fault_handle_target_level(vcpu,
> > > +                                     write, map_writable, &iter, pfn,
> > > +                                     prefault);
> > > +
> > > +                     break;
> > > +             } else if (!is_present_direct_pte(iter.old_pte) ||
> > > +                        is_large_pte(iter.old_pte)) {
> > > +                     /*
> > > +                      * The leaf PTE for this fault must be mapped at a
> > > +                      * lower level, so a non-leaf PTE must be inserted into
> > > +                      * the paging structure. If the assignment below
> > > +                      * succeeds, it will add the non-leaf PTE and a new
> > > +                      * page of page table memory. Then the iterator can
> > > +                      * traverse into that new page. If the atomic compare/
> > > +                      * exchange fails, the iterator will repeat the current
> > > +                      * PTE, so the only thing this function must do
> > > +                      * differently is return the page table memory to the
> > > +                      * vCPU's fault cache.
> > > +                      */
> > > +                     child_pt = mmu_memory_cache_alloc(pf_pt_cache);
> > > +                     new_pte = generate_nonleaf_pte(child_pt, false);
> > > +
> > > +                     if (!direct_walk_iterator_set_pte(&iter, new_pte))
> > > +                             mmu_memory_cache_return(pf_pt_cache, child_pt);
> > > +             }
> > > +     }
> >
> > I have a question on how this will guarantee safe concurrency...
> >
> > As you mentioned previously somewhere, the design somehow mimics how
> > the core mm works with process page tables, and IIUC here the rwlock
> > works really like the mmap_sem that we have for the process mm.  So
> > with the series now we can have multiple page fault happening with
> > read lock held of the mmu_lock to reach here.
> 
> Ah, I'm sorry if I put that down somewhere. I think that comparing the
> MMU rwlock in this series to the core mm mmap_sem was a mistake. I do
> not understand the ways in which the core mm uses the mmap_sem enough
> to make such a comparison. You're correct that with two faulting vCPUs
> we could have page faults on the same address range happening in
> parallel. I'll try to elaborate more on why that's safe.
> 
> > Then I'm imagining a case where both vcpu threads faulted on the same
> > address range while when they wanted to do different things, like: (1)
> > vcpu1 thread wanted to map this as a 2M huge page, while (2) vcpu2
> > thread wanted to map this as a 4K page.
> 
> By vcpu thread, do you mean the page fault / EPT violation handler
> wants to map memory at different levels?. As far as I understand,
> vCPUs do not have any intent to map  a page at a certain level when
> they take an EPT violation. The page fault handlers could certainly
> want to map the memory at different levels. For example, if guest
> memory was backed with 2M hugepages and one vCPU tried to do an
> instruction fetch on an unmapped page while another tried to read it,
> that should result in the page fault handler for the first vCPU trying
> to map at 4K and the other trying to map at 2M, as in your example.
> 
> > Then is it possible that
> > vcpu2 is faster so it firstly setup the pmd as a page table page (via
> > direct_walk_iterator_set_pte above),
> 
> This is definitely possible
> 
> > then vcpu1 quickly overwrite it
> > as a huge page (via direct_page_fault_handle_target_level, level=2),
> > then I feel like the previous page table page that setup by vcpu2 can
> > be lost unnoticed.
> 
> There are two possibilities here. 1.) vCPU2 saw vCPU1's modification
> to the PTE during its walk. In this case, vCPU2 should not map the
> memory at 2M. (I realize that in this example there is a discrepancy
> as there's no NX hugepage support in this RFC. I need to add that in
> the next version. In this case, vCPU1 would set a bit in the non-leaf
> PTE to indicate it was split to allow X on a constituent 4K entry.)
> 2.) If vCPU2 did not see vCPU1's modification during its walk, it will
> indeed try to map the memory at 2M. However in this case the atomic
> cpmxchg on the PTE will fail because vCPU2 did not have the current
> value of the PTE. In this case the PTE will be re-read and the walk
> will continue or the page fault will be retried. When threads using
> the direct walk iterator change PTEs with an atomic cmpxchg, they are
> guaranteed to know what the value of the PTE was before the cmpxchg
> and so that thread is then responsible for any cleanup associated with
> the PTE modification - e.g. freeing pages of page table memory.
> 
> > I think general process page table does not have this issue is because
> > it has per pmd lock so anyone who changes the pmd or beneath it will
> > need to take that.  However here we don't have it, instead we only
> > depend on the atomic ops, which seems to be not enough for this?
> 
> I think that atomic ops (plus rcu to ensure no use-after-free) are
> enough in this case, but I could definitely be wrong. If your concern
> about the race requires the NX hugepages stuff, I need to get on top
> of sending out those patches. If you can think of a race that doesn't
> require that, I'd be very excited to hear it.

Actually nx_huge_pages is exactly the thing I thought about for this
case when I was trying to find a real scenario (because in most cases
even if vcpu1 & vcpu2 traps at the same address, they still seem to
map the pages in the same way).  But yes if you're even prepared for
that (so IIUC the 2M mapping will respect the 4K mappings in that
case) then it looks reasonable.

And I think I was wrong above in that the page should not be leaked
anyway, since I just noticed handle_changed_pte() should take care of
that, iiuc:

	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
		/*
		 * The level of the page table being freed is one level lower
		 * than the level at which it is mapped.
		 */
		child_level = level - 1;

		/*
		 * If there was a present non-leaf entry before, and now the
		 * entry points elsewhere, the lpage stats and dirty logging /
		 * access tracking status for all the entries the old pte
		 * pointed to must be updated and the page table pages it
		 * pointed to must be freed.
		 */
		handle_disconnected_pt(kvm, as_id, gfn, spte_to_pfn(old_pte),
				       child_level, vm_teardown,
				       disconnected_pts);
	}

With that, I don't have any other concerns so far.  Will wait for your
next version.

Thanks,

-- 
Peter Xu

