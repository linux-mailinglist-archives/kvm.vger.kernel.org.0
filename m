Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C102440669
	for <lists+kvm@lfdr.de>; Sat, 30 Oct 2021 02:32:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhJ3Aeh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Oct 2021 20:34:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhJ3Aeg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Oct 2021 20:34:36 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCE03C061714
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 17:32:07 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t21so7838179plr.6
        for <kvm@vger.kernel.org>; Fri, 29 Oct 2021 17:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tfN/NZ9bKyA3ymAP3/RxrMfh6+uEmny6i5vUMe2cPU8=;
        b=C7fcPQiJRBEaAhNWBIA7kYZ8HHNl/QchUEZIHa+JwOgg1Mu2eJF4ud/0uuHAzoSgKx
         f7lbOdt9KZBZxV6NGhrpr/LBbrKIx2257W8SBXos+EaBCOnBTQR5zfY44kcW/zlyoDHP
         /HvSIoUmF/hgHce7rKx6MZawAPVuyWQIlc0TQJ5TszC3c1LKgxsC3Fg4YEVMUr2bgKHn
         Ahh+mx6GyZwQ7CcL0Ne4LPzCYqX530mLhAGT9/Fe9ZWZT8aqTroWGrQAeICb+CdxZa1b
         1DNVEUSQ8OYLU5IMswWyCjQbvlKtylRAV9bmy89qewoq2hHM7Guj0IkVzzWkE876XAol
         qV1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tfN/NZ9bKyA3ymAP3/RxrMfh6+uEmny6i5vUMe2cPU8=;
        b=VFVwuoT5pC0uo2E71yXiJV5t4o3ZbS0r872wsrpKHNwA4U7e9wqBNqhBvF149AmJ89
         M+TtjeuS54I5Tf83OUaPTgXwTe7p443AMAo2nqukfNPpVaD+/0g8/39w3xz60+8Fq3F9
         hrK4/W4wiXJkFeBbEMjt08jNyNpbou5AknQ8l/fZIPO/BdeIYLCPnVFn1Anju9nxtN5P
         jgn4RRkoWmuIUh8ScbvWygF/QKnsEJtI/1bD7dQI4V+dbSAsagJzNA6oth65VpxvXngD
         3iBb9jiwF8F18iLjo6+u2v2+/40AKcLcGgb+nBeCZAqZvAGxmZcaPi2jYwZvgbpjSWB5
         UHEw==
X-Gm-Message-State: AOAM531ppkYE0yupA3b+4n1wRcye+h1B+ndlaeP963Ypee5Xq5qc82wc
        tI+PPYB4p0yIk83sfoF3defCAw==
X-Google-Smtp-Source: ABdhPJyCn9GLlrncVFZ/FTBTXAmXjTaj0DZZZ2p4NowSrEFTteGtsBSUa8Qc3Ib5s/QTuyXp9PtMUg==
X-Received: by 2002:a17:90b:218:: with SMTP id fy24mr13099463pjb.187.1635553927061;
        Fri, 29 Oct 2021 17:32:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b4sm8625778pfl.60.2021.10.29.17.32.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Oct 2021 17:32:06 -0700 (PDT)
Date:   Sat, 30 Oct 2021 00:32:02 +0000
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
Message-ID: <YXySglMHYhHHVxm/@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <4f8718fc8da57ab799e95ef7c2060f8be0f2391f.1632171479.git.maciej.szmigiero@oracle.com>
 <YXhQEeNxi2+fAQPM@google.com>
 <4222ead3-f80f-0992-569f-9e1a7adbabcc@maciej.szmigiero.name>
 <YXrjnSKBhzG7JVLF@google.com>
 <4156d889-5320-ff78-9898-e065d8554c7d@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4156d889-5320-ff78-9898-e065d8554c7d@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 29, 2021, Maciej S. Szmigiero wrote:
> On 28.10.2021 19:53, Sean Christopherson wrote:
> > Hmm, no, this is trivial to handle, though admittedly a bit unpleasant.
> > 
> > /*
> >   * Note, kvm_memslot_iter_start() finds the first memslot that _may_ overlap
> >   * the range, it does not verify that there is actual overlap.  The check in
> >   * the loop body filters out the case where the highest memslot with a base_gfn
> >   * below start doesn't actually overlap.
> >   */
> > #define kvm_for_each_memslot_in_gfn_range(iter, node, slots, start, end) \
> >          for (kvm_memslot_iter_start(iter, node, slots, start, end);      \
> >               kvm_memslot_iter_is_valid(iter);                            \
> >               kvm_memslot_iter_next(node))                                \
> > 		if (iter->slot->base_gfn + iter->slot->npages < start) { \
> > 		} else
> 
> As you say, that's rather unpleasant, since we know that the first
> returned memslot is the only one that's possibly *not* overlapping
> (and then it only happens sometimes).
> Yet with the above change we'll pay the price of this check for every
> loop iteration (for every returned memslot).

I'm definitely not saying that it's the best/right/only way to handle this,
merely pointing out that it's not _that_ complex, modulo off-by-one bugs :-)

> That's definitely not optimizing for the most common case.

Meh, it's a nop for kvm_check_memslot_overlap() and completely in the noise for
kvm_zap_gfn_range().  Not saying I disagree that's a flawed way to handle this
just saying that even the quick-and-dirty solution is extremely unlikely to be
relevant to performance.

> Also, the above code has a bug - using a [start, end) notation compatible
> with what kvm_for_each_memslot_in_gfn_range() expects,  where [1, 4)
> means a range consisting of { 1, 2, 3 }, consider a tree consisting of the
> following two memslots: [1, 2), [3, 5)
> 
> When kvm_for_each_memslot_in_gfn_range() is then called to "return"
> memslots overlapping range [2, 4) it will "return" the [1, 2) memslot, too -
> even though it does *not*  actually overlap the requested range.
> 
> While this bug is easy to fix (just use "<=" instead of "<") it serves to
> underline that one has to be very careful with working with this type of
> code as it is very easy to introduce subtle mistakes here.

Yes, and that's exactly why I want to write this _once_.

> > Two _existing_ callers.  Odds are very, very high that future usage of
> > kvm_for_each_memslot_in_gfn_range() will overlook the detail about the helper
> > not actually doing what it says it does.  That could be addressed to some extent
> > by renaming it kvm_for_each_memslot_in_gfn_range_approx() or whatever, but as
> > above this isn't difficult to handle, just gross.
> 
> What kind of future users of this API do you envision?
> 
> I've pointed out above that adding this extra check means essentially
> optimizing for an uncommon case.

Usage similar to kvm_zap_gfn_range() where KVM wants to take action on a specific
gfn range.  I'm actually somewhat surprised that none of the other architectures
have a use case in their MMUs, though I don't know the story for things like
shadow paging that "necessitate" x86's behavior.

> One of the callers of this function already has the necessary code to
> reject non-overlapping memslots and have to keep it to calculate the
> effective overlapping range for each memslot.
> For the second caller (which, by the way, is called much less often than
> kvm_zap_gfn_range()) it's a matter of one extra condition.
> 
> > > In case of kvm_zap_gfn_range() the necessary checking is already
> > > there and has to be kept due to the above range merging.
> > > 
> > > Also, a code that is simpler is easier to understand, maintain and
> > > so less prone to subtle bugs.
> > 
> > Heh, and IMO that's an argument for putting all the complexity into a single
> > location.  :-)
> > 
> 
> If you absolutely insist then obviously I can change the code to return
> only memslots strictly overlapping the requested range in the next
> patchset version.

I feel pretty strongly that the risk vs. reward is heavily in favor of returning
only strictly overlapping memslots.  The risk being that a few years down the road
someone runs afoul of this and we end up with a bug in production.  The reward is
avoiding writing moderately complex code and at best shave a few uops in an x86
slooow path.  It's entirely possible there's never a third user, but IMO there
isn't enough reward to justify even the smallest amount of risk.

Paolo, any opinion?
