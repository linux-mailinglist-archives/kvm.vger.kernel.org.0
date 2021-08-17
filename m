Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3991E3EEB66
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 13:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhHQLMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 07:12:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34828 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236465AbhHQLMj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 07:12:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629198726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l1ZKPEe+d+1xXqSbyoFPiztcu2ZbCfI18Zlq2RsK9MY=;
        b=KmC8pNpsNMkRVc913M+RtjI/X9dX+PQ64PRSvW81NZCGWQVW+rpjXfP/qQqVCKWq7GfuI6
        3yte6SPuTnsWidJ7b7dUp0Bi7k0dsB7EF46N3tX6GIiDnfglHYqmMwTvyhaVUYxpWIkzNz
        l+IAUL4hoHLiE79fduHNc4g4Nhtg4FM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-14-dKoy_80QNUC3qfTZ3t0Ing-1; Tue, 17 Aug 2021 07:12:05 -0400
X-MC-Unique: dKoy_80QNUC3qfTZ3t0Ing-1
Received: by mail-wm1-f71.google.com with SMTP id m13-20020a7bcf2d000000b002e6cd9941a9so852639wmg.1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 04:12:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l1ZKPEe+d+1xXqSbyoFPiztcu2ZbCfI18Zlq2RsK9MY=;
        b=l0w2uzu6P5gsCgjhsSOJLPXfq+bqnmdDiT/cfSDJAvTr1YylNxdFcNJfzRJbXjdiuU
         4qBWZeHw1dQ1/hytCdsdyOBbdEFkUwhhylzOXQRt5E4AQrKYEhFJIgDPPyt1/OfMIeEu
         T8T2m3tjhda0mqJbf5SCm9p9ZSjq4W1P+9uVUAdp0Uf9LWTetMo5f4vLpREQglNi8itC
         xXDZtMnORXNvqNDipuk526OI4snQd7jBiQyGlHEPPD2dZ/6FFcaNqtlYZxkRvnC8ZJni
         8tRHLR6YF16QSUWX7ojrKtsCqhwhWUavyewEnZ+PPPPskmwwn7OEnhF8P7YMxtly/p4m
         MAcg==
X-Gm-Message-State: AOAM533/nwcO48q7AJMV8Z6GozY/K00/iSjcgtENgy72fEahvquAnKoP
        skeHxwbFL+4DezbsX1NvR4QnH1KIKrD7LYVx9+lDCBPMtAObqFCPHeQws+zUBUPtoG1p7M97Ifs
        OTNpbA1s7GC9u
X-Received: by 2002:a7b:ce0b:: with SMTP id m11mr2863091wmc.150.1629198723981;
        Tue, 17 Aug 2021 04:12:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz044WsexbG7BSLlUnDezV0L27JbaW/kW8ORaRW2463yTRpnptzL5OIzW19WK0PKdd3t6P5OQ==
X-Received: by 2002:a7b:ce0b:: with SMTP id m11mr2863067wmc.150.1629198723736;
        Tue, 17 Aug 2021 04:12:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id s17sm1851940wmj.12.2021.08.17.04.12.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 04:12:02 -0700 (PDT)
Subject: Re: [RFC PATCH 0/6] Pass memslot around during page fault handling
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <20210813203504.2742757-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6eb7d833-2e36-369d-5cd6-44e459f8506f@redhat.com>
Date:   Tue, 17 Aug 2021 13:12:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210813203504.2742757-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/21 22:34, David Matlack wrote:
> This series avoids kvm_vcpu_gfn_to_memslot() calls during page fault
> handling by passing around the memslot in struct kvm_page_fault. This
> idea came from Ben Gardon who authored an similar series in Google's
> kernel.
> 
> This series is an RFC because kvm_vcpu_gfn_to_memslot() calls are
> actually quite cheap after commit fe22ed827c5b ("KVM: Cache the last
> used slot index per vCPU") since we always hit the cache. However
> profiling shows there is still some time (1-2%) spent in
> kvm_vcpu_gfn_to_memslot() and that hot instructions are the memory loads
> for kvm->memslots[as_id] and slots->used_slots. This series eliminates
> this remaining overhead but at the cost of a bit of code churn.
> 
> Design
> ------
> 
> We can avoid the cost of kvm_vcpu_gfn_to_memslot() by looking up the
> slot once and passing it around. In fact this is quite easy to do now
> that KVM passes around struct kvm_page_fault to most of the page fault
> handling code.  We can store the slot there without changing most of the
> call sites.
> 
> The one exception to this is mmu_set_spte, which does not take a
> kvm_page_fault since it is also used during spte prefetching. There are
> three memslots lookups under mmu_set_spte:
> 
> mmu_set_spte
>    rmap_add
>      kvm_vcpu_gfn_to_memslot
>    rmap_recycle
>      kvm_vcpu_gfn_to_memslot
>    set_spte
>      make_spte
>        mmu_try_to_unsync_pages
>          kvm_page_track_is_active
>            kvm_vcpu_gfn_to_memslot
> 
> Avoiding these lookups requires plumbing the slot through all of the
> above functions. I explored creating a synthetic kvm_page_fault for
> prefetching so that kvm_page_fault could be passed to all of these
> functions instead, but that resulted in even more code churn.
> 
> Patches
> -------
> 
> Patches 1-2 are small cleanups related to the series.
> 
> Patches 3-4 pass the memslot through kvm_page_fault and use it where
> kvm_page_fault is already accessible.
> 
> Patches 5-6 plumb the memslot down into the guts of mmu_set_spte to
> avoid the remaining memslot lookups.
> 
> Performance
> -----------
> 
> I measured the performance using dirty_log_perf_test and taking the
> average "Populate memory time" over 10 runs. To help inform whether or
> not different parts of this series is worth the code churn I measured
> the performance of pages 1-4 and 1-6 separately.
> 
> Test                            | tdp_mmu | kvm/queue | Patches 1-4 | Patches 1-6
> ------------------------------- | ------- | --------- | ----------- | -----------
> ./dirty_log_perf_test -v64      | Y       | 5.22s     | 5.20s       | 5.20s
> ./dirty_log_perf_test -v64 -x64 | Y       | 5.23s     | 5.14s       | 5.14s
> ./dirty_log_perf_test -v64      | N       | 17.14s    | 16.39s      | 15.36s
> ./dirty_log_perf_test -v64 -x64 | N       | 17.17s    | 16.60s      | 15.31s
> 
> This series provides no performance improvement to the tdp_mmu but
> improves the legacy MMU page fault handling by about 10%.
> 
> David Matlack (6):
>    KVM: x86/mmu: Rename try_async_pf to kvm_faultin_pfn in comment
>    KVM: x86/mmu: Fold rmap_recycle into rmap_add
>    KVM: x86/mmu: Pass around the memslot in kvm_page_fault
>    KVM: x86/mmu: Avoid memslot lookup in page_fault_handle_page_track
>    KVM: x86/mmu: Avoid memslot lookup in rmap_add
>    KVM: x86/mmu: Avoid memslot lookup in mmu_try_to_unsync_pages
> 
>   arch/x86/include/asm/kvm_page_track.h |   4 +-
>   arch/x86/kvm/mmu.h                    |   5 +-
>   arch/x86/kvm/mmu/mmu.c                | 110 +++++++++-----------------
>   arch/x86/kvm/mmu/mmu_internal.h       |   3 +-
>   arch/x86/kvm/mmu/page_track.c         |   6 +-
>   arch/x86/kvm/mmu/paging_tmpl.h        |  18 ++++-
>   arch/x86/kvm/mmu/spte.c               |  11 +--
>   arch/x86/kvm/mmu/spte.h               |   9 ++-
>   arch/x86/kvm/mmu/tdp_mmu.c            |  12 +--
>   9 files changed, 80 insertions(+), 98 deletions(-)
> 

Queued patches 1-3, thanks.  For the others, see the reply to patch 6.

Paolo

