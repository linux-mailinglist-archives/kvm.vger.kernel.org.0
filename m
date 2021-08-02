Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37BC63DDB2A
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 16:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbhHBOgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 10:36:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54762 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233925AbhHBOgk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 10:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627914990;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pi0jPmXjHdnxYHn6/PGFe7xx2Rs931mVC1UYp96hAi4=;
        b=AhIZftbUSL3PCGvGReruZeCwxwLfhaR9MnlLFG8/u2SP3urp63fpMwhEIhpHAcKyrXOnOh
        0PFYFJf/RIzkHEGoCeC/1D+cpame3/cbhM5zTy4Hx/heJO5h3mkmGYuWk7BW86CuAVkzcw
        2hbLVFAU2AzilbI5oIP4fRipbS2xtlw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-MWaSNZg0NcW6OqFAkhgyrA-1; Mon, 02 Aug 2021 10:36:27 -0400
X-MC-Unique: MWaSNZg0NcW6OqFAkhgyrA-1
Received: by mail-wm1-f72.google.com with SMTP id l12-20020a05600c1d0cb029024e389bb7f1so49806wms.0
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 07:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pi0jPmXjHdnxYHn6/PGFe7xx2Rs931mVC1UYp96hAi4=;
        b=Y9/OVurE/6zZnisVdizLBECW0BcUEwL8TfPdzT4PUU57DtFfRlZIZix8J2ndA2kQ38
         w2mtHNJZo0zWHhoekF2jzDkUb8Y6TJAlGLi87fWfaqW09OxpY7RCfF7/MjHdXP7I3Px8
         KkVN7hfRmiE6i2hg+sR5DmtMuDYlMixfW1dZrYeqNk+X83qdHegMtMmTXMK53JT4ON50
         vtOLYzpsrhZ68FY1C4p+cYUYrpF+er7LgPK1Qv62ZemVNmZrnoj2eZszKb5azb1dVdko
         9TXLD0cOENSFo55inlu8ec215hZGDDGTHpMVYeDnB/VDYbMgGxXELkpWzLpbJJuauRNf
         +2Rg==
X-Gm-Message-State: AOAM530miMeQa7NR01xVSvpQkBNtIddPfmDysYVMlQ1Z2vjfB89dD1va
        Fze/8pMUYzsqlHquPni139tzJeO894XOcS7YfVKcdt/ozlnbJMm7QZ60CZ02YN/1vhaRLgRDnXb
        P4L1rxtxR4VCC
X-Received: by 2002:adf:cd86:: with SMTP id q6mr17711540wrj.422.1627914986226;
        Mon, 02 Aug 2021 07:36:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx0VChUosWl7QFTIJWbwLeOCnEDEpN9Jfe8ahLba4o3j9mE1OYBAUtTAq1MPPHHBlxlG0SgVg==
X-Received: by 2002:adf:cd86:: with SMTP id q6mr17711523wrj.422.1627914986045;
        Mon, 02 Aug 2021 07:36:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id e3sm11539857wrw.51.2021.08.02.07.36.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 07:36:25 -0700 (PDT)
To:     David Matlack <dmatlack@google.com>, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210730223707.4083785-1-dmatlack@google.com>
 <20210730223707.4083785-2-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/6] KVM: Cache the least recently used slot index per
 vCPU
Message-ID: <b87b9f52-b763-856f-16f0-ecb668ba22c1@redhat.com>
Date:   Mon, 2 Aug 2021 16:36:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210730223707.4083785-2-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/07/21 00:37, David Matlack wrote:
> The memslot for a given gfn is looked up multiple times during page
> fault handling. Avoid binary searching for it multiple times by caching
> the least recently used slot. There is an existing VM-wide LRU slot but
> that does not work well for cases where vCPUs are accessing memory in
> different slots (see performance data below).
> 
> Another benefit of caching the least recently use slot (versus looking
> up the slot once and passing around a pointer) is speeding up memslot
> lookups *across* faults and during spte prefetching.
> 
> To measure the performance of this change I ran dirty_log_perf_test with
> 64 vCPUs and 64 memslots and measured "Populate memory time" and
> "Iteration 2 dirty memory time".  Tests were ran with eptad=N to force
> dirty logging to use fast_page_fault so its performance could be
> measured.
> 
> Config     | Metric                        | Before | After
> ---------- | ----------------------------- | ------ | ------
> tdp_mmu=Y  | Populate memory time          | 6.76s  | 5.47s
> tdp_mmu=Y  | Iteration 2 dirty memory time | 2.83s  | 0.31s
> tdp_mmu=N  | Populate memory time          | 20.4s  | 18.7s
> tdp_mmu=N  | Iteration 2 dirty memory time | 2.65s  | 0.30s
> 
> The "Iteration 2 dirty memory time" results are especially compelling
> because they are equivalent to running the same test with a single
> memslot. In other words, fast_page_fault performance no longer scales
> with the number of memslots.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>

It's the *most* recently used slot index, of course. :)  That's true of 
lru_slot as well.

> +static inline struct kvm_memory_slot *get_slot(struct kvm_memslots *slots, int slot_index)
> +{
> +	if (slot_index < 0 || slot_index >= slots->used_slots)
> +		return NULL;
> +
> +	return &slots->memslots[slot_index];
> +}
> +

Since there are plenty of arrays inside struct kvm_memory_slot*, do we 
want to protect this against speculative out-of-bounds accesses with 
array_index_nospec?

> +static inline struct kvm_memory_slot *
> +search_memslots(struct kvm_memslots *slots, gfn_t gfn)
> +{
> +	int slot_index = __search_memslots(slots, gfn);
> +
> +	return get_slot(slots, slot_index);
>  }

Let's use this occasion to remove the duplication between 
__gfn_to_memslot and search_memslots; you can make search_memslots do 
the search and palce the LRU (ehm, MRU) code to __gfn_to_memslot only.  So:

- the new patch 1 (something like "make search_memslots search without 
LRU caching") is basically this series's patch 2, plus a tree-wide 
replacement of search_memslots with __gfn_to_memslot.

- the new patch 2 is this series's patch 1, except 
kvm_vcpu_gfn_to_memslot uses search_memslots instead of 
__search_memslots.  The comments in patch 2's commit message about the 
double misses move to this commit message.

> +	if (slot)
> +		vcpu->lru_slot_index = slot_index;

Let's call it lru_slot for consistency with the field of struct 
kvm_memory_slots.

Paolo

