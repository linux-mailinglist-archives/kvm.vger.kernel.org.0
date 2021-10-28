Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1F643E787
	for <lists+kvm@lfdr.de>; Thu, 28 Oct 2021 19:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhJ1R4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Oct 2021 13:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbhJ1R4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Oct 2021 13:56:05 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C98FC061570
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 10:53:38 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id b4so97782pgh.10
        for <kvm@vger.kernel.org>; Thu, 28 Oct 2021 10:53:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QUy7C3pMfYDSd+gJBLd/Qm4IQNiMMafgC3bCqMCwLnQ=;
        b=V2m484sBGMfAZF6ekWflWHuCH3mcIIF/yy1mokly1IVIxz5gdLick7wsTcm3QpHzsJ
         Fw5/ypXiO/a6ay8Hy3n8vh9aa2+wkILSk5Id7uRvN30yhTKosSzKa2UB8Q6jF941Vp+E
         bfvrquk+nS4d1tqzjMKYgIsD2ajVt20YYBKFPZhS66Yp4E4/r8L/XX+YMe1ikPXrmW5R
         dFHt6LPWU1mNxEsUMSTVsXiXkFMKpAj/YmmGLAF5asEZBY3EW1VWdaNmErr8icCFP9KP
         2c+1oQeNdgcfvj+LBulpjjHnFh5S5n9G99KOPuGwDYO9n5q2/YZ34rexiNMp3GlSJ9pC
         4bTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QUy7C3pMfYDSd+gJBLd/Qm4IQNiMMafgC3bCqMCwLnQ=;
        b=zG7ByasrYNvLiZtcyG1FXZWLEPzXc8/mC784TkYIopCCse2ZcW9b4Da5rYRuBvauDk
         hXryYLTQgvtSYLk5ZUVkukkeQh2V65eaH8ESWqXfFkFVoy/byjZMPnzf+FxAhIfgqqz8
         NeQQhe0X13Yo1SGMNr1LuaKxvzh75ZI61LObbvk9AZxRNO8RkoJ14Jt76ijNttQKZ4NZ
         m62nnQoAQ/FHZmjZ53wqzf8kt114ZG6k7MGMsFK3s7OyWL9Yz66pq/dHm73l8xXBpqN5
         jRJ0Rld5o3bMZu7QzlmWvWc4S1ezCbZCoYNJRv6RB1hZD2DXUuua9/QhrSDuWQFN6sxH
         qWTg==
X-Gm-Message-State: AOAM530I3QM4x5uf9xQhbG9Ts9XjwkxyTGKkoloeIcYVwU8f3PmUR++j
        V0k3Ym61bOnattA1JgmLXBVXCw==
X-Google-Smtp-Source: ABdhPJysal2B5WUWU6g4Fq6oWH9QJqhRYWjw3zX5PU6I51TK3Pouopi1BNPtDsvO/auEgxPwnSxrYQ==
X-Received: by 2002:aa7:8718:0:b0:47b:f2ca:2e59 with SMTP id b24-20020aa78718000000b0047bf2ca2e59mr5811730pfo.21.1635443617763;
        Thu, 28 Oct 2021 10:53:37 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g18sm4539825pfj.67.2021.10.28.10.53.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 10:53:37 -0700 (PDT)
Date:   Thu, 28 Oct 2021 17:53:33 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 13/13] KVM: Optimize overlapping memslots check
Message-ID: <YXrjnSKBhzG7JVLF@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <4f8718fc8da57ab799e95ef7c2060f8be0f2391f.1632171479.git.maciej.szmigiero@oracle.com>
 <YXhQEeNxi2+fAQPM@google.com>
 <4222ead3-f80f-0992-569f-9e1a7adbabcc@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4222ead3-f80f-0992-569f-9e1a7adbabcc@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Oct 27, 2021, Maciej S. Szmigiero wrote:
> On 26.10.2021 20:59, Sean Christopherson wrote:
> > > +		/* kvm_for_each_in_gfn_no_more() guarantees that cslot->base_gfn < nend */
> > > +		if (cend > nslot->base_gfn)
> > 
> > Hmm, IMO the need for this check means that kvm_for_each_memslot_in_gfn_range()
> > is flawed.  The user of kvm_for_each...() should not be responsible for skipping
> > memslots that do not actually overlap the requested range.  I.e. this function
> > should be no more than:
> > 
> > static bool kvm_check_memslot_overlap(struct kvm_memslots *slots,
> > 				      struct kvm_memory_slot *slot)
> > {
> > 	gfn_t start = slot->base_gfn;
> > 	gfn_t end = start + slot->npages;
> > 
> > 	kvm_for_each_memslot_in_gfn_range(&iter, slots, start, end) {
> > 		if (iter.slot->id != slot->id)
> > 			return true;
> > 	}
> > 
> > 	return false;
> > }
> > 
> > 
> > and I suspect kvm_zap_gfn_range() could be further simplified as well.
> > 
> > Looking back at the introduction of the helper, its comment's highlighting of
> > "possibily" now makes sense.
> > 
> >    /* Iterate over each memslot *possibly* intersecting [start, end) range */
> >    #define kvm_for_each_memslot_in_gfn_range(node, slots, start, end)	\
> > 
> > That's an unnecessarily bad API.  It's a very solvable problem for the iterator
> > helpers to advance until there's actually overlap, not doing so violates the
> > principle of least surprise, and unless I'm missing something, there's no use
> > case for an "approximate" iteration.
> 
> In principle this can be done, however this will complicate the gfn
> iterator logic - especially the kvm_memslot_iter_start() part, which
> will already get messier from open-coding kvm_memslots_gfn_upper_bound()
> there.

Hmm, no, this is trivial to handle, though admittedly a bit unpleasant.

/*
 * Note, kvm_memslot_iter_start() finds the first memslot that _may_ overlap
 * the range, it does not verify that there is actual overlap.  The check in
 * the loop body filters out the case where the highest memslot with a base_gfn
 * below start doesn't actually overlap.
 */
#define kvm_for_each_memslot_in_gfn_range(iter, node, slots, start, end) \
        for (kvm_memslot_iter_start(iter, node, slots, start, end);      \
             kvm_memslot_iter_is_valid(iter);                            \
             kvm_memslot_iter_next(node))                                \
		if (iter->slot->base_gfn + iter->slot->npages < start) { \
		} else



> At the same kvm_zap_gfn_range() will still need to do the memslot range
> <-> request range merging by itself as it does not want to process the
> whole returned memslot, but rather just the part that's actually
> overlapping its requested range.

That's purely coincidental though.  IMO, kvm_zap_gfn_range() would be well within
its rights to sanity the memslot, e.g.

	if (WARN_ON(memslot->base_gfn + memslot->npages < gfn_start))
		continue;
 
> In the worst case, the current code can return one memslot too much, so
> I don't think it's worth bringing additional complexity just to detect
> and skip it

I strongly disagree.  This is very much a case of one chunk of code that knows
the internal details of what it's doing taking on all the pain and complexity
so that users of the helper

> it's not that uncommon to design an API that needs extra checking from its
> caller to cover some corner cases.

That doesn't mean it's desirable.

> For example, see pthread_cond_wait() or kernel waitqueues with their
> spurious wakeups or atomic_compare_exchange_weak() from C11.
> And these are higher level APIs than a very limited internal KVM one
> with just two callers.

Two _existing_ callers.  Odds are very, very high that future usage of
kvm_for_each_memslot_in_gfn_range() will overlook the detail about the helper
not actually doing what it says it does.  That could be addressed to some extent
by renaming it kvm_for_each_memslot_in_gfn_range_approx() or whatever, but as
above this isn't difficult to handle, just gross.

> In case of kvm_zap_gfn_range() the necessary checking is already
> there and has to be kept due to the above range merging.
> 
> Also, a code that is simpler is easier to understand, maintain and
> so less prone to subtle bugs.

Heh, and IMO that's an argument for putting all the complexity into a single
location.  :-)
