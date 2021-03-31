Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 322D735045D
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 18:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbhCaQU0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 12:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbhCaQUZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 12:20:25 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EA3C061574
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 09:20:25 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id g15so14943703pfq.3
        for <kvm@vger.kernel.org>; Wed, 31 Mar 2021 09:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hbFgBS0tsmLZecdBb34MxnZHD2vsOnYlgFmBhEC+AGM=;
        b=W6gYHfyq+FLodOWhD9srXTh8aaio7ufLJGiEJEiMEepafRE4jD5CPt2u6zyCqNkmEf
         RBW97ptdPXvm5UekA+1t/rKsqmWK0oYE75ZvbG8qPcwUeH2CNY8N2JYzQdJbcC/FqLox
         DcD9DWu45srgtpcHvYUIYloa787DwMs9RQszqMJAGT7a/cdNDkSzvp8GETRb/h8dEjgP
         8s6cZSDU08hOz+njpFIAcEg7jI2UFPlQ/B0ogtWJ4tAdwpEoVAvBIo0c7kJY+qV4PKbI
         5JrEg5cZ6lg6SU1xy6TAmWN7lx027fNcjkiELq9jkPTEPVzyTbPPJIMZcf+zN1WRmx+V
         ubUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hbFgBS0tsmLZecdBb34MxnZHD2vsOnYlgFmBhEC+AGM=;
        b=ki0oScd46l/V1w0iFeM4+lB/J8Xz1DwxmCPTu7ZL/tljKhXHaDIRK27Q0ppB2tJWZg
         yWxyG4wTpKRfw68F5mZoNfQ3G2gpvcMT1AuPs5rnrzM+Ruj+LVUWaOwnIp2mrCPcz8qb
         /P7k6JelKTUDHAt3im0qNvVxbk8Vse6sJHoDfgg71MwwEaJpgKdzrftIxKhzMnz5M+Yp
         VxQx2vNXojkC0mvB/NGGt6zqtgFMxXnDnsGUWaloRpEyt/fmvX3yhDmHpqRb6pec4BrP
         0He9Nx9L1wp67uIgATJoA6j9J2h8JwD6BCJabrL3Ikr6/cl0rEksq7pZVfGB2W2zaFpK
         Bfig==
X-Gm-Message-State: AOAM532G8AelmdR0zbQyjxVDWUYXhyKiSR1qltL4eQ9Sad9+7nAszLZk
        r982b3EJ2ycclo8lSJzawLxLgg==
X-Google-Smtp-Source: ABdhPJyEnoIvLhWAi7NNGEWROpPtFz0kvkUm7Uq+sDDKk3AwLz6Jre1P4F3JOHb9hmWMRVWQ5USifw==
X-Received: by 2002:a65:428b:: with SMTP id j11mr3941343pgp.47.1617207624928;
        Wed, 31 Mar 2021 09:20:24 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h19sm2862436pfc.172.2021.03.31.09.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 09:20:24 -0700 (PDT)
Date:   Wed, 31 Mar 2021 16:20:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH 10/18] KVM: Move x86's MMU notifier memslot walkers to
 generic code
Message-ID: <YGShRP9E49p3vcos@google.com>
References: <20210326021957.1424875-1-seanjc@google.com>
 <20210326021957.1424875-11-seanjc@google.com>
 <ba3f7a9c-0b59-cbeb-5d46-4236cde2c51f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba3f7a9c-0b59-cbeb-5d46-4236cde2c51f@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 31, 2021, Paolo Bonzini wrote:
> On 26/03/21 03:19, Sean Christopherson wrote:
> > +#ifdef KVM_ARCH_WANT_NEW_MMU_NOTIFIER_APIS
> > +	kvm_handle_hva_range(mn, address, address + 1, pte, kvm_set_spte_gfn);
> > +#else
> >   	struct kvm *kvm = mmu_notifier_to_kvm(mn);
> >   	int idx;
> >  	trace_kvm_set_spte_hva(address);
> > 	idx = srcu_read_lock(&kvm->srcu);
> > 
> > 	KVM_MMU_LOCK(kvm);
> > 
> > 	kvm->mmu_notifier_seq++;
> > 
> > 	if (kvm_set_spte_hva(kvm, address, pte))
> > 		kvm_flush_remote_tlbs(kvm);
> > 
> >   	KVM_MMU_UNLOCK(kvm);
> >   	srcu_read_unlock(&kvm->srcu, idx);
> > +#endif
> 
> The kvm->mmu_notifier_seq is missing in the new API side.  I guess you can
> add an argument to __kvm_handle_hva_range and handle it also in patch 15
> ("KVM: Take mmu_lock when handling MMU notifier iff the hva hits a
> memslot").

Yikes.  Superb eyes!

That does bring up an oddity I discovered when digging into this.  Every call
to .change_pte() is bookended by .invalidate_range_{start,end}(), i.e. the above
missing kvm->mmu_notifier_seq++ is benign because kvm->mmu_notifier_count is
guaranteed to be non-zero.

I'm also fairly certain it means kvm_set_spte_gfn() is effectively dead code on
_all_ architectures.  x86 and MIPS are clearcut nops if the old SPTE is
not-present, and that's guaranteed due to the prior invalidation.  PPC simply
unmaps the SPTE, which again should be a nop due to the invalidation.  arm64 is
a bit murky, but if I'm reading the code correctly, it's also a nop because
kvm_pgtable_stage2_map() is called without a cache pointer, which I think means
it will map an entry if and only if an existing PTE was found.

I haven't actually tested the above analysis, e.g. by asserting that
kvm->mmu_notifier_count is indeed non-zero.  I'll do that sooner than later.
But, given the shortlog of commit:

  6bdb913f0a70 ("mm: wrap calls to set_pte_at_notify with invalidate_range_start
                 and invalidate_range_end")

I'm fairly confident my analysis is correct.  And if so, it also means that the
whole point of adding .change_pte() in the first place (for KSM, commit
828502d30073, "ksm: add mmu_notifier set_pte_at_notify()"), has since been lost.

When it was originally added, .change_pte() was a pure alternative to
invalidating the entry.

  void __mmu_notifier_change_pte(struct mm_struct *mm, unsigned long address,
                               pte_t pte)
  {
        struct mmu_notifier *mn;
        struct hlist_node *n;

        rcu_read_lock();
        hlist_for_each_entry_rcu(mn, n, &mm->mmu_notifier_mm->list, hlist) {
                if (mn->ops->change_pte)
                        mn->ops->change_pte(mn, mm, address, pte);
                /*
                 * Some drivers don't have change_pte,
                 * so we must call invalidate_page in that case.
                 */
                else if (mn->ops->invalidate_page)
                        mn->ops->invalidate_page(mn, mm, address);
        }
        rcu_read_unlock();
  }

The aforementioned commit 6bdb913f0a70 wrapped set_pte_at_notify() with
invalidate_range_{start,end}() so that .invalidate_page() implementations could
sleep.  But, no one noticed that in doing so, .change_pte() was completely
neutered.

Assuming all of the above is correct, I'm very tempted to rip out .change_pte()
entirely.  It's been dead weight for 8+ years and no one has complained about
KSM+KVM performance (I'd also be curious to know how much performance was gained
by shaving VM-Exits).  As KVM is the only user of .change_pte(), dropping it in
KVM would mean the entire MMU notifier could also go away.
