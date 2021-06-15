Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634E83A72F4
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 02:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbhFOAZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 20:25:27 -0400
Received: from mail-pl1-f174.google.com ([209.85.214.174]:42519 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbhFOAZY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 20:25:24 -0400
Received: by mail-pl1-f174.google.com with SMTP id v13so7522499ple.9
        for <kvm@vger.kernel.org>; Mon, 14 Jun 2021 17:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2YM1uuj78vuybLy6AQ13wcF40mCCJqdUmsXNtwjjUfU=;
        b=N/au5QwOMaECa5aDc1efMCfKpk40YChkQujRr0F+IlSDm5rOebpK9FO/8MRrJHNUSM
         Cx7golH5CO8QkkdHVppbACqGJP0pEDbi0V2/evL5zxhfjdUYulQjODfZYIcfLV7ACUtN
         4lOAgR9PZD7GRvWmt0pAtDQDEAqDBtF7w9IKqRFduHsoJCZ1J6r/DIMUYKzg0/hFYH0u
         rmZnow+RwDO2S5QgTXlM+35fsMGw8sMgWjopP6p1TLuKuPLfvl3FK0zD7VvCCA4+6FDM
         NBFTj6oLNVfqiQeZunqy7wIMveupVtP6O/g1OSvilooh7ku1G0kcmUDuJ0TOawE4S/dn
         sCkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2YM1uuj78vuybLy6AQ13wcF40mCCJqdUmsXNtwjjUfU=;
        b=h/L3Wg4s8FArsH/UhaKkzDAPmVBxiLgH2x4hk4QQV3MYw3y1wJJ1c+D1sHGsGtNi/7
         6tTBXRwndyRDE1VqXxzViwys6XXTFh5jZhLPl39wrJjcuSXhj/dAfsQq6sxRxsFjnDy/
         icts/iAgnZLgncYR6k2UaNBa2J6Pssyiq43kxF7vdlEvqzx/WSt7tbDujX6vXBMNd3f1
         1txy+K2z0kvOSjmO0EzF3+zngAsy8x36QdfvuNAPoQ7h0EtuPjwR1HkKr8s7G7AXZTTh
         bVoc2UozF7p1BuqKX4wP3UQNLTF7DdiN/0YbPGU3hfduqU+Mwz1nercIqZLVe9QQdgAv
         H9Iw==
X-Gm-Message-State: AOAM531DivrhquCj56XwanNqKN7CExrJ8A2zJjfY5ELTYIhHC1AOI8Ba
        4WihasmbjpdQdDbkWNUDTwfn+A==
X-Google-Smtp-Source: ABdhPJx44/gdW5uTiWeZaXd7DE3hlkZWi6NSTCkW73L45o4oRJ9STX711Q8JKndIvnRUD0BFtn6M+A==
X-Received: by 2002:a17:902:d3ca:b029:104:ebfd:a554 with SMTP id w10-20020a170902d3cab0290104ebfda554mr867738plb.13.1623716527377;
        Mon, 14 Jun 2021 17:22:07 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y7sm9017032pfy.153.2021.06.14.17.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:22:06 -0700 (PDT)
Date:   Tue, 15 Jun 2021 00:22:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 5/8] KVM: x86/mmu: Also record spteps in shadow_page_walk
Message-ID: <YMfyq8NEt0E+LE5y@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <20210611235701.3941724-6-dmatlack@google.com>
 <YMffQriMoxWw2V1f@google.com>
 <YMfopaDSRKvlsH0Y@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMfopaDSRKvlsH0Y@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021, David Matlack wrote:
> On Mon, Jun 14, 2021 at 10:59:14PM +0000, Sean Christopherson wrote:
> > The two use cases (and the only common use cases I can see) have fairly different
> > requirements.  The MMIO check wants the SPTEs at _all_ levels, whereas the fast
> > page fault handler wants the SPTE _and_ its pointer at a single level.  So I
> > wonder if by providing a super generic API we'd actually increase complexity.
> > 
> > I.e. rather than provide a completely generic API, maybe it would be better to
> > have two distinct API.  That wouldn't fix the tdp_ptep_t issue, but it would at
> > least bound it to some degree and make the code more obvious.
> 
> Does the tdp_ptep_t issue go away if kvm_tdp_mmu_get_spte_lockless
> returns an rcu_dereference'd version of the pointer? See below.

Sort of?

> > u64 *kvm_tdp_mmu_get_spte_lockless(struct kvm_vcpu *vcpu, u64 addr, u64 *spte)
> > {
> > 	struct kvm_mmu *mmu = vcpu->arch.mmu;
> > 	gfn_t gfn = addr >> PAGE_SHIFT;
> > 	struct tdp_iter iter;
> > 	u64 *sptep = NULL;
> > 
> > 	*spte = 0ull;
> > 
> > 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> > 		/*
> > 		 * Here be a comment about the unfortunate differences between
> > 		 * the TDP MMU and the legacy MMU.
> > 		 */
> > 		sptep = (u64 * __force)iter.sptep;
> 
> Instead, should this be:
> 
> 		sptep = rcu_dereference(iter.sptep);
> 
> ?

It's not wrong per se, but it's cheating in some sense.

The problem is that it's not the pointer itself that's RCU-protected, rather it's
what it's pointing at (the page tables) that's RCU-protected.  E.g. if this were
reading the _value_, it would be a-ok to do:

	spte = READ_ONCE(*rcu_dereference(iter.sptep));

and return the value because the caller gets a copy of the RCU-protected data.

Reading multiple times from a single dereference is also ok, e.g. see
kvm_bitmap_or_dest_vcpus() and several other APIC helpers, but note how they all
take and release the RCU lock in a single block and don't return the protected
pointer to the caller.

Stripping the __rcu annotation without actually being able to guarantee that
the caller is going to do the right thing with the pointer is why I say it's
"cheating".  E.g. if the caller were to do:

  u64 get_spte_lockess_broken(...)
  {
	u64 *sptep;

	rcu_read_lock();
	sptep = kvm_tdp_mmu_get_spte_lockless(...);
	rcu_read_unlock();

	return READ_ONCE(*sptep);
  }

it would violate RCU but Sparse would be none the wiser.

The __force ugliness is also cheating, but it's also loudly stating that we're
intentionally cheating, hence the request for a comment.

> > 		*spte = iter.old_spte;
> > 	}
> > 	return sptep;
> > }
> > 
