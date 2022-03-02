Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F32E04C9B0C
	for <lists+kvm@lfdr.de>; Wed,  2 Mar 2022 03:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236894AbiCBCOJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 21:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233599AbiCBCOI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 21:14:08 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F86DA6458
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 18:13:26 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p17so307243plo.9
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 18:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AEMZJRS8IqK9uNi4M2qX2/wELWJ9IFmUki7Kwk7iHP4=;
        b=Ekob+DJE0CC3Gv3pJRHwdNbi6IBC6alr3hYiaUe1W4JGBFWY2EGgAPFCfwX2GosM+j
         lpYwNhx8Idh5RR+v/yeda3ZHRiqYYH9gY1EpSF2dCq3h1ctDda9p2hvdnXODB6A0HhZx
         Zk60ovO3b9aVaN2ktCz8dYImebxHPIMEApY3bGdCcrn36DOPg0zZcOxjgjD8jcxjOfpr
         BI6/egavuDuaP6/NQV5oA1aRHM4UlXE5GOMeMA797hvlyaJ4CaAGcxlWYjF/D970rxS1
         BpOxmiZgQhMXHUGiSfmsiMGljMwRg7xBRCCd6m0t1b222fAJj79dCC1MzKn150HoiB0X
         vzFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AEMZJRS8IqK9uNi4M2qX2/wELWJ9IFmUki7Kwk7iHP4=;
        b=FQa0HT04/hxd2YJLwnnPstzIBmoA1RCbRii58/OuA1+YVIX3G8rfD9/MWpbL2t6XLQ
         v3We4Q0xngLkzsx7PIF5sNyF11cHuRFgTV79Q94EmnZHHeLq+npq8NGMqcZrk7qU4YOg
         BXA1jlHXId0rkQBk6t+221b126OLlBqmP5hLUVxotVAdLnhV6NntXQoT3Qe4TD7iND/P
         HPqNw6779eVigH2QuWCVx21ST6S9ATLb5pI1GA/2r9OQYf5Tl0Wb6RTxS84+BSQQPBDg
         GnDAGb3l3FJVZSIgiyiDqiXjqPNmtsLwKfFq8YvcTCFiGmh4hNGlm6Eze+fzgLJVd7xI
         ZiYg==
X-Gm-Message-State: AOAM531HUVgRm2CtYuUqmGOez49clIVVjZvODQ9GbfT43q7es3egNjCC
        oIXI4KOUEdHuCJAxIcQQWiEYZQ==
X-Google-Smtp-Source: ABdhPJwJrlt03GWVX9IYgUy6vuwXENTmjtTF9uAv8H842eEhRHR4T29Qu9+KEeH8ZepvUiJNXViaUA==
X-Received: by 2002:a17:90b:94e:b0:1bc:c99f:ede1 with SMTP id dw14-20020a17090b094e00b001bcc99fede1mr24857938pjb.49.1646187205310;
        Tue, 01 Mar 2022 18:13:25 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id oc3-20020a17090b1c0300b001bce36844c7sm3440320pjb.17.2022.03.01.18.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 18:13:24 -0800 (PST)
Date:   Wed, 2 Mar 2022 02:13:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: Re: [PATCH v3 20/28] KVM: x86/mmu: Allow yielding when zapping GFNs
 for defunct TDP MMU root
Message-ID: <Yh7SwAR/H5dPrqLN@google.com>
References: <20220226001546.360188-1-seanjc@google.com>
 <20220226001546.360188-21-seanjc@google.com>
 <28276890-c90c-e9a9-3cab-15264617ef5a@redhat.com>
 <Yh53V23gSJ6jphnS@google.com>
 <f444790d-3bc7-9870-576e-29f30354a63b@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f444790d-3bc7-9870-576e-29f30354a63b@redhat.com>
X-Spam-Status: No, score=-18.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

/facepalm

After typing up all of the below, I actually tried the novel idea of compiling
the code... and we can't do xchg() on role.invalid because it occupies a single
bit, it's not a standalone boolean.  I completely agree that the xchg() code is
far, far cleaner, but we'd have to sacrifice using a full byte for "smm" _and_
write some rather ugly code for retrieving a pointer to "invalid".

TL;DR: this

	smp_mb__after_atomic();

	if (root->role.invalid) {
		return;
	}

	root->role.invalid = true;

	smp_mb__before_atomic();

is just a weirdly open coded xchg() that operates on a single bit field.


On Tue, Mar 01, 2022, Paolo Bonzini wrote:
> On 3/1/22 20:43, Sean Christopherson wrote:
> > > and after spending quite some time I wonder if all this should just be
> > > 
> > >          if (refcount_dec_not_one(&root->tdp_mmu_root_count))
> > >                  return;
> > > 
> > > 	if (!xchg(&root->role.invalid, true) {
> > 
> > The refcount being '1' means there's another task currently using root, marking
> > the root invalid will mean checks on the root's validity are non-deterministic
> > for the other task.
> 
> Do you mean it's not possible to use refcount_dec_not_one, otherwise
> kvm_tdp_mmu_get_root is not guaranteed to reject the root?

Scratch my objection, KVM already assumes concurrent readers may or may not see
role.invalid as true.  I deliberately went that route so as to avoid having to
require specific ordering between checking role.invalid and getting a reference.

As my comment further down states, "allocating" a new root is the only flow that
absolutely cannot consume a soon-to-be-invalid root, and it takes mmu_lock for
write so it can't be running concurrently.

So, we don't need to rely on xchg() for barriers, the only consumers of the barriers
are kvm_tdp_mmu_put_root() and they'll obviously always do an atomic xchg().

Invalidating the root while it's refcount is >=1 is also ok, but I thinks that's
flawed for a different reason (see comments on refcount_set(..., 0)).

> > > 	 	tdp_mmu_zap_root(kvm, root, shared);
> > > 
> > > 		/*
> > > 		 * Do not assume the refcount is still 1: because
> > > 		 * tdp_mmu_zap_root can yield, a different task
> > > 		 * might have grabbed a reference to this root.
> > > 		 *
> > > 	        if (refcount_dec_not_one(&root->tdp_mmu_root_count))
> > 
> > This is wrong, _this_ task can't drop a reference taken by the other task.
> 
> This is essentially the "kvm_tdp_mmu_put_root(kvm, root, shared);" (or "goto
> beginning_of_function;") part of your patch.

Gah, I didn't read the code/comments for refcount_dec_not_one().  I assumed it
was "decrement and return true if the result is not '1'", not "decrement unless
the count is already '1', and return true if there was a decrement".  In hindsight,
the former makes no sense at all...

> > >          	        return;
> > > 	}
> > > 
> > > 	/*
> > > 	 * The root is invalid, and its reference count has reached
> > > 	 * zero.  It must have been zapped either in the "if" above or
> > > 	 * by someone else, and we're definitely the last thread to see
> > > 	 * it apart from RCU-protected page table walks.
> > > 	 */
> > > 	refcount_set(&root->tdp_mmu_root_count, 0);
> > 
> > Not sure what you intended here, KVM should never force a refcount to '0'.
> 
> It's turning a refcount_dec_not_one into a refcount_dec_and_test.  It seems
> legit to me, because the only refcount_inc_not_zero is in a write-side
> critical section.  If the refcount goes to zero on the read-side, the root
> is gone for good.

The issue is that by using refcount_dec_not_one() above, there's no guarantee that
this task is the last one to see it as kvm_tdp_mmu_get_root() can succeed and bump
the refcount between refcount_dec_not_one() and here.  Freeing the root would lead
to use-after-free because iterators (rightly) assuming that RCU protection isn't
needed once they have a reference.  RCU protection is needed only if the user of the
iterator wants to dereference page table memory.
 
> > xchg() is a very good idea.  The smp_mb_*() stuff was carried over from the previous
> > version where this sequence set another flag in addition to role.invalid.
> > 
> > Is this less funky (untested)?
> > 
> > 	/*
> > 	 * Invalidate the root to prevent it from being reused by a vCPU while
> > 	 * the root is being zapped, i.e. to allow yielding while zapping the
> > 	 * root (see below).
> > 	 *
> > 	 * Free the root if it's already invalid.  Invalid roots must be zapped
> > 	 * before their last reference is put, i.e. there's no work to be done,
> > 	 * and all roots must be invalidated before they're freed (this code).
> > 	 * Re-zapping invalid roots would put KVM into an infinite loop.
> > 	 *
> > 	 * Note, xchg() provides an implicit barrier to ensure role.invalid is
> > 	 * visible if a concurrent reader acquires a reference after the root's
> > 	 * refcount is reset.
> > 	 */
> > 	if (xchg(root->role.invalid, true))
> > 		spin_lock(&kvm->arch.tdp_mmu_pages_lock);
> > 		list_del_rcu(&root->link);
> > 		spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
> > 
> > 		call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
> > 		return;
> > 	}
> 
> Based on my own version, I guess you mean (without comments due to family
> NMI):
> 
>         if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
>                 return;
> 
> 	if (!xchg(&root->role.invalid, true) {
> 		refcount_set(&root->tdp_mmu_count, 1);
> 	 	tdp_mmu_zap_root(kvm, root, shared);
> 	        if (!refcount_dec_and_test(&root->tdp_mmu_root_count))
>         	        return;
> 	}
> 
>         spin_lock(&kvm->arch.tdp_mmu_pages_lock);
>         list_del_rcu(&root->link);
>         spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
>         call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);

That would work, though I'd prefer to recurse on kvm_tdp_mmu_put_root() instead
of open coding refcount_dec_and_test() so that we get coverage of the xchg()
doing the right thing.

I still slightly prefer having the "free" path be inside the xchg().  To me, even
though the "free" path is the only one that's guaranteed to be reached for every root, 
the fall-through to resetting the refcount and zapping the root is the "normal" path,
and the "free" path is the exception.
