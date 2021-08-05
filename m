Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9252D3E0FF4
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 10:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbhHEILW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Aug 2021 04:11:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39565 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235877AbhHEILU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Aug 2021 04:11:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628151066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mYqedqKfIiUibnkEHrQKTy4lpTPXpfEo+LIanl10hPg=;
        b=Ldu2RLwAFeC0P0UXfBEGsPpluHgeILpXMiYmUe5K69AeX/d0zVSJ3jZisp4QUNOFNipF0Z
        GwCrKJni29AEZ4dmthh9j94KLbGtbhXFWtgXVU6tKi5bk4sudb2zKVTecs5H+NmqIwjsY+
        C3rQKg6rkENv6Pif39KuSyhifRMDgsg=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-1TLMKbQEN7GyLR03Xbl_JA-1; Thu, 05 Aug 2021 04:11:03 -0400
X-MC-Unique: 1TLMKbQEN7GyLR03Xbl_JA-1
Received: by mail-ej1-f69.google.com with SMTP id ne21-20020a1709077b95b029057eb61c6fdfso1745526ejc.22
        for <kvm@vger.kernel.org>; Thu, 05 Aug 2021 01:11:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mYqedqKfIiUibnkEHrQKTy4lpTPXpfEo+LIanl10hPg=;
        b=dJE8eTy/o0+u3FgHSnnNKi4Xdvpq39/Wt+aWybqzHGdLlkG4Ujy+I/F1Dpw9fwM+ya
         /VGGRVoDUZf4CX7OIdQcf39hEs5+59rLaMIQfMO9VBtDXvMcQ7evuX77PUu7WoG9iLPG
         6JCb61I0CEV/8zjKNpyQWec+QZqD+32sIAFjKX/vfRht7MHFGBBc1HIzsO2/pJj3t1uw
         J/1Few6kvqMEpVAThCTPNjPZQOJUK96FqV/QEkL0NZGm8/jCDzJAF1HXMzt8S2C3iZT6
         h6YHWyi/lBu5E3hjwZm5f0WiWAVGgrTJ+v6r3g5L9OsNABzqfMNGR/ObEqmL7BnCRvGH
         Be3w==
X-Gm-Message-State: AOAM531DqSoc9on3wBA139HjYGgTVQis9f0DtLlrFhdrgvwYq5cgZ4u+
        7PG8MblJTZsH7IEml7Wr9zWqIe0tOl3bRFRRgexov/2NvxwOLMTP5GNQbGwtSeyAhirhgsmFpUb
        biRDt0ZcBdqoa
X-Received: by 2002:aa7:da19:: with SMTP id r25mr4954619eds.247.1628151062629;
        Thu, 05 Aug 2021 01:11:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaJA0TvoXpvAWSL/yCRIoTeNJGM0lZhY9jS7JaxFj3Fehbl2uGqQzkR9pTj5Tk7izwMPgUeg==
X-Received: by 2002:aa7:da19:: with SMTP id r25mr4954606eds.247.1628151062496;
        Thu, 05 Aug 2021 01:11:02 -0700 (PDT)
Received: from [192.168.10.118] ([93.56.169.140])
        by smtp.gmail.com with ESMTPSA id cz3sm1924356edb.11.2021.08.05.01.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Aug 2021 01:11:01 -0700 (PDT)
Subject: Re: [PATCH v2 0/7] Improve gfn-to-memslot performance during page
 faults
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
References: <20210804222844.1419481-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8a795ab3-d504-b0fd-447c-12117fb598c1@redhat.com>
Date:   Thu, 5 Aug 2021 10:11:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210804222844.1419481-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/21 00:28, David Matlack wrote:
> This series improves the performance of gfn-to-memslot lookups during
> page faults. Ben Gardon originally identified this performance gap and
> sufficiently addressed it in Google's kernel by reading the memslot once
> at the beginning of the page fault and passing around the pointer.
> 
> This series takes an alternative approach by introducing a per-vCPU
> cache of the least recently used memslot index. This avoids needing to
> binary search the existing memslots multiple times during a page fault.
> Unlike passing around the pointer, the cache has an additional benefit
> in that it speeds up gfn-to-memslot lookups *across* faults and during
> spte prefetching where the gfn changes.
> 
> This difference can be seen clearly when looking at the performance of
> fast_page_fault when multiple slots are in play:
> 
> Metric                        | Baseline     | Pass*    | Cache**
> ----------------------------- | ------------ | -------- | ----------
> Iteration 2 dirty memory time | 2.8s         | 1.6s     | 0.30s
> 
> * Pass: Lookup the memslot once per fault and pass it around.
> ** Cache: Cache the last used slot per vCPU (i.e. this series).
> 
> (Collected via ./dirty_log_perf_test -v64 -x64)
> 
> I plan to also send a follow-up series with a version of Ben's patches
> to pass the pointer to the memslot through the page fault handling code
> rather than looking it up multiple times. Even when applied on top of
> the cache series it has some performance improvements by avoiding a few
> extra memory accesses (mainly kvm->memslots[as_id] and
> slots->used_slots). But it will be a judgement call whether or not it's
> worth the code churn and complexity.

Queued, thanks.

Paolo

> v2:
>   * Rename lru to last_used [Paolo]
>   * Tree-wide replace search_memslots with __gfn_to_memslot [Paolo]
>   * Avoid speculation when accessesing slots->memslots [Paolo]
>   * Refactor tdp_set_spte_atomic to leverage vcpu->last_used_slot [Paolo]
>   * Add Paolo's Reviewed-by tags
>   * Fix build failures in mmu_audit.c [kernel test robot]
> 
> v1: https://lore.kernel.org/kvm/20210730223707.4083785-1-dmatlack@google.com/
> 
> David Matlack (7):
>    KVM: Rename lru_slot to last_used_slot
>    KVM: Move last_used_slot logic out of search_memslots
>    KVM: Cache the last used slot index per vCPU
>    KVM: x86/mmu: Leverage vcpu->last_used_slot in
>      tdp_mmu_map_handle_target_level
>    KVM: x86/mmu: Leverage vcpu->last_used_slot for rmap_add and
>      rmap_recycle
>    KVM: x86/mmu: Rename __gfn_to_rmap to gfn_to_rmap
>    KVM: selftests: Support multiple slots in dirty_log_perf_test
> 
>   arch/powerpc/kvm/book3s_64_vio.c              |  2 +-
>   arch/powerpc/kvm/book3s_64_vio_hv.c           |  2 +-
>   arch/s390/kvm/kvm-s390.c                      |  4 +-
>   arch/x86/kvm/mmu/mmu.c                        | 54 +++++++------
>   arch/x86/kvm/mmu/mmu_audit.c                  |  4 +-
>   arch/x86/kvm/mmu/tdp_mmu.c                    | 42 +++++++---
>   include/linux/kvm_host.h                      | 80 +++++++++++++++----
>   .../selftests/kvm/access_tracking_perf_test.c |  2 +-
>   .../selftests/kvm/demand_paging_test.c        |  2 +-
>   .../selftests/kvm/dirty_log_perf_test.c       | 76 +++++++++++++++---
>   .../selftests/kvm/include/perf_test_util.h    |  2 +-
>   .../selftests/kvm/lib/perf_test_util.c        | 20 +++--
>   .../kvm/memslot_modification_stress_test.c    |  2 +-
>   virt/kvm/kvm_main.c                           | 26 +++++-
>   14 files changed, 238 insertions(+), 80 deletions(-)
> 

