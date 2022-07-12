Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688FE5729D3
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 01:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234053AbiGLXV7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 19:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbiGLXV6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 19:21:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A54B93F8
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 16:21:57 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id fz10so9557351pjb.2
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 16:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=X2APlglw3yLJ14lMDPnrKmONyrt3oBS6yGkesaXJOQU=;
        b=ZRsq7BeZYBbNuSrxsaGI49Wth/Uofc/HpqmU7uFH/Wg7XkbMccTmNa+ZE9YzSLswJN
         wmhCuhcQUTvYY7gaQJcRwmI2ZU4bAWHcTAhVjlZGVU2xUJSAmN1Lq29f0SnpxKvs8wPj
         bZbOX6AVwewBlPUOZeUVvQUHt9bc9NyG3EJy0xmsP2omaih0VzZAXq2LtyOOJoTHXFr6
         7QLyB+qimYNJO7vPtYRo/hwVdL2pto5vV8Iuog1lUxfiDHHvaFr3Idh187q+7Ha+Hq+X
         vRJlZXG5QrCY2UhXi+qZ97CLAt5+gTBdCvME78zj+601Q4XZ1KZcM0RP/z/Ywkbd34JZ
         w2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=X2APlglw3yLJ14lMDPnrKmONyrt3oBS6yGkesaXJOQU=;
        b=I1MjSYur/BbWudazHlQBZQvnVteBwRNPZCI2u/SwJtWQwGWM68akcOBOFrioKzj5Zz
         Xh2xmrOnK0cfQAFaTuFkRxVO2Y52mSLHrZ4gozv4iNMeDLZqQrIqkdWkL94rLHYZmCep
         +k1uoD8XQtbUuw99nOPuq1z5R28vihv4P1/GLSB9GS7jC6OgDdjrTkQ7nbnWBM6kM6Oy
         djzgCCX1oowHYO+1lCQC83zskzeMNc4jBgSizFWEX2mnAWBIjKloky3r9dJ/lh3ZZ3ZB
         GKkr0rZnvdnIJeJFs16+7dbNaLCO9gRK6uUPv6pjZnrxa5438uB1X5xLHJegMQinul3j
         JhLw==
X-Gm-Message-State: AJIora/ZvhGUiPFhNNxKrjfk7ikBa1OX8sRaiarebOJbtkjwqrflyTcd
        OFMNDejrM/DAL/X+XNXDx6JPBQ==
X-Google-Smtp-Source: AGRyM1ucZD0moIchI1Gk9GW7l3TSrIRfIF0avNOR8sVBut1RFZyj6955Ik3g98yvR7hz1M1r3EqGLA==
X-Received: by 2002:a17:902:a406:b0:16b:c816:6427 with SMTP id p6-20020a170902a40600b0016bc8166427mr330601plq.88.1657668116435;
        Tue, 12 Jul 2022 16:21:56 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id z4-20020a170902ccc400b001677fa34a07sm2715744ple.43.2022.07.12.16.21.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 16:21:55 -0700 (PDT)
Date:   Tue, 12 Jul 2022 23:21:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v2 9/9] KVM: x86/mmu: Promote pages in-place when
 disabling dirty logging
Message-ID: <Ys4CD/VHtbrBVi6a@google.com>
References: <20220321224358.1305530-1-bgardon@google.com>
 <20220321224358.1305530-10-bgardon@google.com>
 <YkH0O2Qh7lRizGtC@google.com>
 <CANgfPd8V_34TBb3m-JpmczZnY3t5aaFwHNZq1W0eknumbrXCRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8V_34TBb3m-JpmczZnY3t5aaFwHNZq1W0eknumbrXCRw@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022, Ben Gardon wrote:
> On Mon, Mar 28, 2022 at 10:45 AM David Matlack <dmatlack@google.com> wrote:
> >
> > On Mon, Mar 21, 2022 at 03:43:58PM -0700, Ben Gardon wrote:
> > > +{
> > > +     struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
> > > +     struct rsvd_bits_validate shadow_zero_check;
> > > +     bool map_writable;
> > > +     kvm_pfn_t pfn;
> > > +     u64 new_spte;
> > > +     u64 mt_mask;
> > > +
> > > +     /*
> > > +      * If addresses are being invalidated, don't do in-place promotion to
> > > +      * avoid accidentally mapping an invalidated address.
> > > +      */
> > > +     if (unlikely(kvm->mmu_notifier_count))
> > > +             return false;
> >
> > Why is this necessary? Seeing this makes me wonder if we need a similar
> > check for eager page splitting.
> 
> This is needed here, but not in the page splitting case, because we
> are potentially mapping new memory.

As written, it's required because KVM doesn't check that there's at least one
leaf SPTE for the range.  If KVM were to step down and find a leaf SPTE before
stepping back up to promote, then this check can be dropped because KVM zaps leaf
SPTEs during invalidate_range_start(), and the primary MMU must invalidate the
entire range covered by a huge page if it's splitting a huge page.

I'm inclined to go that route because it allows for a more unified path (with some
other prep work).  Having to find a leaf SPTE could increase the time to disable
dirty logging, but unless it's an order of magnitude or worse, I'm not sure we care
because walking SPTEs doesn't impact vCPUs (unlike actually zapping).

> > > +             /* Try to promote the constitutent pages to an lpage. */
> > > +             if (!is_last_spte(iter.old_spte, iter.level) &&
> > > +                 try_promote_lpage(kvm, slot, &iter))
> > >                       continue;
> >
> > If iter.old_spte is not a leaf, the only loop would always continue to
> > the next SPTE. Now we try to promote it and if that fails we run through
> > the rest of the loop. This seems broken. For example, in the next line
> > we end up grabbing the pfn of the non-leaf SPTE (which would be the PFN
> > of the TDP MMU page table?) and treat that as the PFN backing this GFN,
> > which is wrong.
> >
> > In the worst case we end up zapping an SPTE that we didn't need to, but
> > we should still fix up this code.

My thought to remedy this is to drop the @pfn argument to kvm_mmu_max_mapping_level().
It's used only for historical reasons, where KVM didn't walk the host page tables
to get the max mapping level and instead pulled THP information out of struct page.
I.e. KVM needed the pfn to get the page.

That would also allow KVM to use huge pages for things that aren't backed by
struct page (I know of at least one potential use case).

I _think_ we can do the below.  It's compile tested only at this point, and I
want to split some of the changes into separate patches, e.g. the WARN on the step-up
not going out-of-bounds.  I'll put this on the backburner for now, it's too late
for 5.20, and too many people are OOO :-)

	tdp_root_for_each_pte(iter, root, start, end) {
		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, true))
			continue;

		/*
		 * Step down until a PRESENT, leaf SPTE is found, even when
		 * promoting a parent shadow page.  Requiring a leaf SPTE
		 * ensures that KVM is not creating a new mapping while an MMU
		 * notifier invalidation is in-progress (KVM zaps only leaf
		 * SPTEs in response to MMU notifier invlidation events), and
		 * avoids doing work for shadow pages with no children.
		 */
		if (!is_shadow_present_pte(iter.old_spte) ||
		    !is_last_spte(iter.old_spte, iter.level))
			continue;

		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn,
							      PG_LEVEL_NUM);
		if (iter.level == max_mapping_level)
			continue;

		/*
		 * KVM zaps leaf SPTEs when handling MMU notifier invalidations,
		 * and the primary MMU is supposed to invalidate secondary MMUs
		 * _before_ zapping PTEs in the host page tables.  It should be
		 * impossible for a leaf SPTE to violate the host mapping level.
		 */
		if (WARN_ON_ONCE(max_mapping_level < iter.level))
			continue;

		/*
		 * The page can be remapped at a higher level, so step
		 * up to zap the parent SPTE.
		 */
		while (max_mapping_level > iter.level)
			tdp_iter_step_up(&iter);

		/*
		 * Stepping up should not cause the iter to go out of range of
		 * the memslot, the max mapping level is bounded by the memslot
		 * (among other things).
		 */
		if (WARN_ON_ONCE(iter.gfn < start || iter.gfn >= end))
			continue;

		/*
		 * Attempt to promote the non-leaf SPTE to a huge page.  If the
		 * promotion fails, zap the SPTE and let it be rebuilt on the
		 * next associated TDP page fault.
		 */
		if (!try_promote_to_huge_page(kvm, &rsvd_bits, slot, &iter))
			continue;

		/* Note, a successful atomic zap also does a remote TLB flush. */
		tdp_mmu_zap_spte_atomic(kvm, &iter);

		/*
		 * If the atomic zap fails, the iter will recurse back into
		 * the same subtree to retry.
		 */
	}

and then promotion shrinks a decent amount too as it's just getting the pfn,
memtype, and making the SPTE.

  static int try_promote_to_huge_page(struct kvm *kvm,
				      struct rsvd_bits_validate *rsvd_bits,
				      const struct kvm_memory_slot *slot,
				      struct tdp_iter *iter)
  {
	struct kvm_mmu_page *sp = sptep_to_sp(iter->sptep);
	kvm_pfn_t pfn;
	u64 new_spte;
	u8 mt_mask;
	int r;

	/*
	 * Treat the lookup as a write "fault", in-place promotion is used only
	 * when disabling dirty logging, which requires a writable memslot.
	 */
	pfn = __gfn_to_pfn_memslot(slot, iter->gfn, true, NULL, true, NULL, NULL);
	if (is_error_noslot_pfn(pfn))
		return -EINVAL;

	/*
	 * In some cases, a vCPU pointer is required to get the MT mask,
	 * however in most cases it can be generated without one. If a
	 * vCPU pointer is needed kvm_x86_try_get_mt_mask will fail.
	 * In that case, bail on in-place promotion.
	 */
	r = static_call(kvm_x86_try_get_mt_mask)(kvm, iter->gfn,
						 kvm_is_mmio_pfn(pfn), &mt_mask);
	if (r)
		return r;

	__make_spte(kvm, sp, slot, ACC_ALL, iter->gfn, pfn, 0, false, true,
		    true, mt_mask, rsvd_bits, &new_spte);

	return tdp_mmu_set_spte_atomic(kvm, iter, new_spte);
  }


