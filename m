Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04A33DDDAA
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 18:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232215AbhHBQ2E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 12:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232056AbhHBQ2C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 12:28:02 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933C7C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 09:27:52 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id z3so18923186plg.8
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 09:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dLY/RV+DX8bVmrTviT3LoTtSlEHS3TZcxw4DK1lirhA=;
        b=AgfkBZqexBqltyocuYrahyCMqecHNe2iL9cb9N5xymaz+uLKcR4S/SpUs4mCLB2RZ0
         /TUWtf5ZcAzJgZ8bTA4Q98I3FSD5HqgUlNwjCv5YBGEST9UWatoRYn3EXtI6TJdUDrde
         uWcH1kmbZk5OUowoFQgd+9BYqCupYpzO8YMq7F/e9QgEl9Vxpic+6kj++Vegc9rO5wSB
         RQMurY/UMfKGuQPeBsdX5fO6HkjMXhy4K2grpLLFzdJJjidTpRMEgOPoglbkQfYZfW/V
         R3Rm9Zfct7Jo+OzxKe5v2qqF+knfRV5MXk4FYz5SEMaP3c0cdXIerESrhIM1015UNkkx
         MdzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dLY/RV+DX8bVmrTviT3LoTtSlEHS3TZcxw4DK1lirhA=;
        b=spMgn3NaVN4ZWcYDR5RiaNVabWbaPdNA89xGNhR0Gm9kV3ueIcVA3wGeSf/dFuOrnE
         nQMPBJrZbti7GPshGioTj648QW52VUJoReYIGI7iahESU34jD+Pnl5aqHmHRnx7hyT2p
         n57oeckleoFjk+uqSKoauJJ0uffVo8xXmqyGVeFaMCiib1NYbwhGJmzCRfH1CDMuqjI3
         jwVdcaWmRH58ntv/RQm6KOxW8r7xZm3Dj9nZZlgpnj0svJksXRRMXsruJfZFrpqEw9Jm
         KPVpXKa5yFhcSUR8ozRZ0uo3MY5ZpGubUlHM5An6a+1NVlIoO2tvD5JwDzFkPfdh1sGp
         87xA==
X-Gm-Message-State: AOAM532BW06DAdkEZ0qtdF+toG9uG6kfidlrZeVPDbiRSf18PuboFB8X
        euzbPLnYwFDILdxPraEPRfUZdg==
X-Google-Smtp-Source: ABdhPJyXB/R2xmoxkQaNi83XjdYoJ/dpCZO2yXzM948b/YS1htX81tjksC9QhaS/TxzFhbyfyf6OtQ==
X-Received: by 2002:a62:79c9:0:b029:3aa:ef64:1569 with SMTP id u192-20020a6279c90000b02903aaef641569mr17746708pfc.8.1627921671952;
        Mon, 02 Aug 2021 09:27:51 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id z11sm2860894pfr.201.2021.08.02.09.27.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:27:51 -0700 (PDT)
Date:   Mon, 2 Aug 2021 16:27:47 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 1/6] KVM: Cache the least recently used slot index per
 vCPU
Message-ID: <YQgdA6Blu4vYToLM@google.com>
References: <20210730223707.4083785-1-dmatlack@google.com>
 <20210730223707.4083785-2-dmatlack@google.com>
 <b87b9f52-b763-856f-16f0-ecb668ba22c1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b87b9f52-b763-856f-16f0-ecb668ba22c1@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021 at 04:36:24PM +0200, Paolo Bonzini wrote:
> On 31/07/21 00:37, David Matlack wrote:
> > The memslot for a given gfn is looked up multiple times during page
> > fault handling. Avoid binary searching for it multiple times by caching
> > the least recently used slot. There is an existing VM-wide LRU slot but
> > that does not work well for cases where vCPUs are accessing memory in
> > different slots (see performance data below).
> > 
> > Another benefit of caching the least recently use slot (versus looking
> > up the slot once and passing around a pointer) is speeding up memslot
> > lookups *across* faults and during spte prefetching.
> > 
> > To measure the performance of this change I ran dirty_log_perf_test with
> > 64 vCPUs and 64 memslots and measured "Populate memory time" and
> > "Iteration 2 dirty memory time".  Tests were ran with eptad=N to force
> > dirty logging to use fast_page_fault so its performance could be
> > measured.
> > 
> > Config     | Metric                        | Before | After
> > ---------- | ----------------------------- | ------ | ------
> > tdp_mmu=Y  | Populate memory time          | 6.76s  | 5.47s
> > tdp_mmu=Y  | Iteration 2 dirty memory time | 2.83s  | 0.31s
> > tdp_mmu=N  | Populate memory time          | 20.4s  | 18.7s
> > tdp_mmu=N  | Iteration 2 dirty memory time | 2.65s  | 0.30s
> > 
> > The "Iteration 2 dirty memory time" results are especially compelling
> > because they are equivalent to running the same test with a single
> > memslot. In other words, fast_page_fault performance no longer scales
> > with the number of memslots.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> It's the *most* recently used slot index, of course. :)  That's true of
> lru_slot as well.

*facepalm*

I'll include a patch in v2 to fix the name of the existing lru_slot to
something like mru_slot or last_used_slot.

> 
> > +static inline struct kvm_memory_slot *get_slot(struct kvm_memslots *slots, int slot_index)
> > +{
> > +	if (slot_index < 0 || slot_index >= slots->used_slots)
> > +		return NULL;
> > +
> > +	return &slots->memslots[slot_index];
> > +}
> > +
> 
> Since there are plenty of arrays inside struct kvm_memory_slot*, do we want
> to protect this against speculative out-of-bounds accesses with
> array_index_nospec?

I'm not sure when it makes sense to use array_index_nospec. Perhaps this
is a good candidate since vcpu->lru_slot_index and the length of
memslots[] can both be controlled by userspace.

I'll play around with adding it to see if there are any performance
trade-offs.

> 
> > +static inline struct kvm_memory_slot *
> > +search_memslots(struct kvm_memslots *slots, gfn_t gfn)
> > +{
> > +	int slot_index = __search_memslots(slots, gfn);
> > +
> > +	return get_slot(slots, slot_index);
> >  }
> 
> Let's use this occasion to remove the duplication between __gfn_to_memslot
> and search_memslots; you can make search_memslots do the search and palce
> the LRU (ehm, MRU) code to __gfn_to_memslot only.  So:
> 
> - the new patch 1 (something like "make search_memslots search without LRU
> caching") is basically this series's patch 2, plus a tree-wide replacement
> of search_memslots with __gfn_to_memslot.
> 
> - the new patch 2 is this series's patch 1, except kvm_vcpu_gfn_to_memslot
> uses search_memslots instead of __search_memslots.  The comments in patch
> 2's commit message about the double misses move to this commit message.

Will do.

> 
> > +	if (slot)
> > +		vcpu->lru_slot_index = slot_index;
> 
> Let's call it lru_slot for consistency with the field of struct
> kvm_memory_slots.

I'll make sure the two have consistent names when I rename them to get
rid of "lru".

> 
> Paolo
> 
