Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3371964C18C
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 01:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbiLNA7N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 19:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236535AbiLNA7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 19:59:11 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126B520F40
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 16:59:10 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so5411062pjm.2
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 16:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iFJYz9RAFRJ+ma2+igrLKsa/K85AMCF2nSwG0/0Is0I=;
        b=QBApAcl/A+aitPzndwPA9qXJhieD/pjgx4M9t9NTIehcfML4td7MICu9t4Oghq7QRj
         O44kHWV4flSd0eNwu+gXmtQJgGs0VAMocQLcobYnljcEwOTioPSnGVIlM4Fb7fzpE+1F
         vgkdvDMbf9BpRNwqJXkL9A0FimSByviQUn2bU5IIeMcf6SwTK/8NHfyqPrGx/GAt3Xd4
         XWGJWuEmhI1FCN2nUfSHNinJ5wsWsavN6g2h+rvxqCYZ2Kp/udfGcAO8iMsTcjS+BMjN
         aKKa079MIksRGv9HDWHpCWj5X3wyNjaaIgDEm8jC5sUEOPaaXoDNqz/hcEcKmDp3Zdvi
         B8lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iFJYz9RAFRJ+ma2+igrLKsa/K85AMCF2nSwG0/0Is0I=;
        b=uqZOnjsj3IJ1q3ZXmHD/pbqwtohFrssgcT7KshfQCLLwbZlkpVehfZsExcZyMUe1cw
         TjqFFdqOQZGMIInhb7ttr/h1a9/r4qb156MXHw8eefXGYlHAGQ1vA0qwLiKh5on0FaHz
         rTXD2QaUUbPLIaX3VJh4p8lZppgcEG1HoMOPB+kYA7XfMZpId2q+0PsKOI/OPRbo9Zbj
         42feHGu8dBFQeKUptKA8F0La6deK7AXUEnALnsculyXkYdOGfnjZQHjapCpYBg5bsh6s
         y+IS4VUe1JMTxk5tTy01QBDSGb0Sc+gnOkRvEarlSozL/b77fm9EJXl9x7ZU+hs/x1Jh
         DZyA==
X-Gm-Message-State: ANoB5pkXzadn/sR2HmC88mpWjT2BT3lc7otYt84lzAOXIRKSrAbTgXfR
        4r1wcjkBzSmiZiIFO3orfgKUaPP7TK3/Nwsm
X-Google-Smtp-Source: AA0mqf7DiM9yxhkc8iayJQKeyQPdq0/p962obUEkga171+9aT4Gp9yQFRhBQ3Hy1hO5shUG61Hj4yg==
X-Received: by 2002:a05:6a20:3d19:b0:a3:49d2:9504 with SMTP id y25-20020a056a203d1900b000a349d29504mr318777pzi.3.1670979549423;
        Tue, 13 Dec 2022 16:59:09 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n12-20020a170903110c00b0018c990ce7fesm466293plh.239.2022.12.13.16.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 16:59:08 -0800 (PST)
Date:   Wed, 14 Dec 2022 00:59:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     David Matlack <dmatlack@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Vipin Sharma <vipinsh@google.com>
Subject: Re: [PATCH 2/7] KVM: x86/MMU: Move rmap_iterator to rmap.h
Message-ID: <Y5kf2KI5oharI0xZ@google.com>
References: <20221206173601.549281-1-bgardon@google.com>
 <20221206173601.549281-3-bgardon@google.com>
 <Y5O+/1CYivRishFE@google.com>
 <CANgfPd8-i=B_c60MFn6symaqpUMXqu+HHJFDkQm8OuzOLnHQ+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8-i=B_c60MFn6symaqpUMXqu+HHJFDkQm8OuzOLnHQ+A@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 13, 2022, Ben Gardon wrote:
> On Fri, Dec 9, 2022 at 3:04 PM David Matlack <dmatlack@google.com> wrote:
> >
> > > +/*
> > > + * Used by the following functions to iterate through the sptes linked by a
> > > + * rmap.  All fields are private and not assumed to be used outside.
> > > + */
> > > +struct rmap_iterator {
> > > +     /* private fields */
> > > +     struct pte_list_desc *desc;     /* holds the sptep if not NULL */
> > > +     int pos;                        /* index of the sptep */
> > > +};
> > > +
> > > +u64 *rmap_get_first(struct kvm_rmap_head *rmap_head,
> > > +                 struct rmap_iterator *iter);
> > > +u64 *rmap_get_next(struct rmap_iterator *iter);
> > > +
> > > +#define for_each_rmap_spte(_rmap_head_, _iter_, _spte_)                      \
> > > +     for (_spte_ = rmap_get_first(_rmap_head_, _iter_);              \
> > > +          _spte_; _spte_ = rmap_get_next(_iter_))
> > > +
> >
> > I always found these function names and kvm_rmap_head confusing since

Heh, you definitely aren't the only one.

> > they are about iterating through the pte_list_desc data structure. The
> > rmap (gfn -> list of sptes) is a specific application of the
> > pte_list_desc structure, but not the only application. There's also
> > parent_ptes in struct kvm_mmu_page, which is not an rmap, just a plain
> > old list of ptes.
>
> > While you are refactoring this code, what do you think about doing the
> > following renames?
> >
> >   struct kvm_rmap_head  -> struct pte_list_head
> >   struct rmap_iterator  -> struct pte_list_iterator
> >   rmap_get_first()      -> pte_list_get_first()
> >   rmap_get_next()       -> pte_list_get_next()
> >   for_each_rmap_spte()  -> for_each_pte_list_entry()

I would strongly prefer to keep "spte" in this one regardless of what other naming
changes we do (see below).  Maybe just for_each_spte()?  IMO, "pte_list_entry"
unnecessarily obfuscates that it's a list of SPTEs.

> > Then we can reserve the term "rmap" just for the actual rmap
> > (slot->arch.rmap), and code that deals with sp->parent_ptes will become
> > a lot more clear IMO (because it will not longer mention rmap).
> >
> > e.g. We go from this:
> >
> >   struct rmap_iterator iter;
> >   u64 *sptep;
> >
> >   for_each_rmap_spte(&sp->parent_ptes, &iter, sptep) {
> >      ...
> >   }
> >
> > To this:
> >
> >   struct pte_list_iterator iter;
> >   u64 *sptep;
> >
> >   for_each_pte_list_entry(&sp->parent_ptes, &iter, sptep) {
> >      ...
> >   }
> 
> I like this suggestion, and I do think it'll make things more
> readable. It's going to be a huge patch to rename all the instances of
> kvm_rmap_head, but it's probably worth it.

I generally like this idea too, but tying into my above comment, before jumping
in I think we should figure out what end state we want, i.e. get the bikeshedding
out of the way now to hopefully avoid dragging out a series while various things
get nitpicked.

E.g. if we if we just rename the structs and their macros, then we'll end up with
things like

	static bool slot_rmap_write_protect(struct kvm *kvm,
					    struct pte_list_head *rmap_head,
					    const struct kvm_memory_slot *slot)
	{
		return rmap_write_protect(rmap_head, false);
	}

which isn't terrible, but there's still opportunity for cleanup, e.g.
rmap_write_protect() could easily be sptes_write_protect() or write_protect_sptes().

That will generate a naming conflict of sorts with pte_list_head if we don't also
rename that to spte_list_head.  And I think capturing that it's a list of SPTEs and
not guest PTEs will be helpful in general.

And if we rename pte_list_head, then we might as well commit 100% and use consisnent
nomenclature across the board, e.g. end up with

	static bool sptes_clear_dirty(struct kvm *kvm, struct sptes_list_head *head,
				      const struct kvm_memory_slot *slot)
	{
		u64 *sptep;
		struct spte_list_iterator iter;
		bool flush = false;

		for_each_spte(head, &iter, sptep) {
			if (spte_ad_need_write_protect(*sptep))
				flush |= spte_wrprot_for_clear_dirty(sptep);
			else
				flush |= spte_clear_dirty(sptep);
		}

		return flush;
	}

versus the current

	static bool __rmap_clear_dirty(struct kvm *kvm, struct kvm_rmap_head *rmap_head,
				       const struct kvm_memory_slot *slot)
	{
		u64 *sptep;
		struct rmap_iterator iter;
		bool flush = false;

		for_each_rmap_spte(rmap_head, &iter, sptep)
			if (spte_ad_need_write_protect(*sptep))
				flush |= spte_wrprot_for_clear_dirty(sptep);
			else
				flush |= spte_clear_dirty(sptep);

		return flush;
	}
