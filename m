Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23BD94D1F0A
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 18:26:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349111AbiCHR05 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 12:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236302AbiCHR0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 12:26:55 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4FF4854F9A
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 09:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646760357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YRPfiRwTtEopNwzDWJUlPDjWJaHcpl4Zzbb9h/ZTBp8=;
        b=IKro1xROErMgXnE8KEHFW70gJaq6XC3SkHDLFdwdK4iz0qU4fL6nUqQL2a+/HJMWUwcdEE
        PiAgRjb7vh66NkkWOcGln8hsa2eqGd8cGlEITYjj3hBJDedjUZMNXne+O+FfJJ+Mbn0UOZ
        MMYaofxyT6ahkWcDG/tU1SCfu9iDJHM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-oosS8mibNwWn12YsqUonFg-1; Tue, 08 Mar 2022 12:25:56 -0500
X-MC-Unique: oosS8mibNwWn12YsqUonFg-1
Received: by mail-wr1-f71.google.com with SMTP id w17-20020adfec51000000b001f068bc3342so3461444wrn.6
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 09:25:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=YRPfiRwTtEopNwzDWJUlPDjWJaHcpl4Zzbb9h/ZTBp8=;
        b=VIUjVfWqKDKE6PC9as1cu+kb5P3t5qj3o5p1VflAHG5D8EwS+j98+J4RYXFPgBLmHF
         nm/Xd7pdM2ulQinc2JGlSlq6CupuB0sGs/Gk6zBzprRgVv/J0tEQV5UBaychQkbfUSH3
         4RAxDNi0e3ouEWRK3h+3laI/G/R3BXS0PZilwa5ea1RISkbXFRFEDPhp4dfPSNol/TUT
         pPkOJVuSwU8iCfDc+gbVOQeHnFnQiKCeAFeeGFB1syOQgLwkV/r+aY/zBJb0+SXjxHG5
         EbzmO2tWS4jmyQXvqMgNgHbKq0xchEqdq9y3dPakQ2BCGo6o1OyQ/i/4dBXbAArV//E3
         nR5w==
X-Gm-Message-State: AOAM532e0ciUYqMIbNB3CKBzkH3iDAVDXTh7/zl0GJGAvAVYAJpi8N+p
        XC2qr5dhe+olHE69kukwTGg5SMejFzeMkVMznql2Grx9MuWaPFUyuRrBO48fP74ixlCvOKD+Aks
        hZz9RnKE/Gr0b
X-Received: by 2002:a05:600c:4fd6:b0:37f:2a37:87a3 with SMTP id o22-20020a05600c4fd600b0037f2a3787a3mr244502wmq.152.1646760354963;
        Tue, 08 Mar 2022 09:25:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxQCtyjD7JJnve06tSlsyJnaT1ZlcMSqcqPGm23ZRTGFdc091rphZBbYaPMuy0Qj+mhGHrQ8w==
X-Received: by 2002:a05:600c:4fd6:b0:37f:2a37:87a3 with SMTP id o22-20020a05600c4fd600b0037f2a3787a3mr244480wmq.152.1646760354638;
        Tue, 08 Mar 2022 09:25:54 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r5-20020a5d4945000000b001f06372fa9fsm21544371wrs.54.2022.03.08.09.25.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Mar 2022 09:25:53 -0800 (PST)
Message-ID: <d5b7d8f0-0f71-b6e5-5acd-d953486ee918@redhat.com>
Date:   Tue, 8 Mar 2022 18:25:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v4 00/30] KVM: x86/mmu: Overhaul TDP MMU zapping and
 flushing
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/3/22 20:38, Paolo Bonzini wrote:
> 
> Overhaul TDP MMU's handling of zapping and TLB flushing to reduce the
> number of TLB flushes, fix soft lockups and RCU stalls, avoid blocking
> vCPUs for long durations while zapping paging structure, and to clean up
> the zapping code.
> 
> The largest cleanup is to separate the flows for zapping roots (zap
> _everything_), zapping leaf SPTEs (zap guest mappings for whatever reason),
> and zapping a specific SP (NX recovery).  They're currently smushed into a
> single zap_gfn_range(), which was a good idea at the time, but became a
> mess when trying to handle the different rules, e.g. TLB flushes aren't
> needed when zapping a root because KVM can safely zap a root if and only
> if it's unreachable.
> 
> To solve the soft lockups, stalls, and vCPU performance issues:
> 
>   - Defer remote TLB flushes to the caller when zapping TDP MMU shadow
>     pages by relying on RCU to ensure the paging structure isn't freed
>     until all vCPUs have exited the guest.
> 
>   - Allowing yielding when zapping TDP MMU roots in response to the root's
>     last reference being put.  This requires a bit of trickery to ensure
>     the root is reachable via mmu_notifier, but it's not too gross.
> 
>   - Zap roots in two passes to avoid holding RCU for potential hundreds of
>     seconds when zapping guest with terabytes of memory that is backed
>     entirely by 4kb SPTEs.
> 
>   - Zap defunct roots asynchronously via the common work_queue so that a
>     vCPU doesn't get stuck doing the work if the vCPU happens to drop the
>     last reference to a root.
> 
> The selftest at the end allows populating a guest with the max amount of
> memory allowed by the underlying architecture.  The most I've tested is
> ~64tb (MAXPHYADDR=46) as I don't have easy access to a system with
> MAXPHYADDR=52.  The selftest compiles on arm64 and s390x, but otherwise
> hasn't been tested outside of x86-64.  It will hopefully do something
> useful as is, but there's a non-zero chance it won't get past init with
> a high max memory.  Running on x86 without the TDP MMU is comically slow.
> 
> Testing: passes kvm-unit-tests and guest installation tests on Intel.
> Haven't yet run AMD or selftests.
> 
> Thanks,
> 
> Paolo
> 
> v4:
> - collected reviews and typo fixes (plus some typo fixes of my own)
> 
> - new patches to simplify reader invariants: they are not allowed to
>    acquire references to invalid roots
> 
> - new version of "Allow yielding when zapping GFNs for defunct TDP MMU
>    root", simplifying the atomic a bit by 1) using xchg and relying on
>    its implicit memory barriers 2) relying on readers to have the same
>    behavior for the three stats refcount=0/valid, refcount=0/invalid,
>    refcount=1/invalid (see previous point)
> 
> - switch zapping of invalidated roots to asynchronous workers on a
>    per-VM workqueue, fixing a bug in v3 where the extra reference added
>    by kvm_tdp_mmu_put_root could be given back twice.  This also replaces
>    "KVM: x86/mmu: Use common iterator for walking invalid TDP MMU roots"
>    in v3, since it gets rid of next_invalidated_root() in a different way.
> 
> - because of the previous point, most of the logic in v3's "KVM: x86/mmu:
>    Zap defunct roots via asynchronous worker" moves to the earlier patch
>    "KVM: x86/mmu: Zap invalidated roots via asynchronous worker"
> 
> 
> v3:
> - Drop patches that were applied.
> - Rebase to latest kvm/queue.
> - Collect a review. [David]
> - Use helper instead of goto to zap roots in two passes. [David]
> - Add patches to disallow REMOVED "old" SPTE when atomically
>    setting SPTE.
> 
> Paolo Bonzini (5):
>    KVM: x86/mmu: only perform eager page splitting on valid roots
>    KVM: x86/mmu: do not allow readers to acquire references to invalid roots
>    KVM: x86/mmu: Zap invalidated roots via asynchronous worker
>    KVM: x86/mmu: Allow yielding when zapping GFNs for defunct TDP MMU root
>    KVM: x86/mmu: Zap defunct roots via asynchronous worker
> 
> Sean Christopherson (25):
>    KVM: x86/mmu: Check for present SPTE when clearing dirty bit in TDP MMU
>    KVM: x86/mmu: Fix wrong/misleading comments in TDP MMU fast zap
>    KVM: x86/mmu: Formalize TDP MMU's (unintended?) deferred TLB flush logic
>    KVM: x86/mmu: Document that zapping invalidated roots doesn't need to flush
>    KVM: x86/mmu: Require mmu_lock be held for write in unyielding root iter
>    KVM: x86/mmu: Check for !leaf=>leaf, not PFN change, in TDP MMU SP removal
>    KVM: x86/mmu: Batch TLB flushes from TDP MMU for MMU notifier change_spte
>    KVM: x86/mmu: Drop RCU after processing each root in MMU notifier hooks
>    KVM: x86/mmu: Add helpers to read/write TDP MMU SPTEs and document RCU
>    KVM: x86/mmu: WARN if old _or_ new SPTE is REMOVED in non-atomic path
>    KVM: x86/mmu: Refactor low-level TDP MMU set SPTE helper to take raw values
>    KVM: x86/mmu: Zap only the target TDP MMU shadow page in NX recovery
>    KVM: x86/mmu: Skip remote TLB flush when zapping all of TDP MMU
>    KVM: x86/mmu: Add dedicated helper to zap TDP MMU root shadow page
>    KVM: x86/mmu: Require mmu_lock be held for write to zap TDP MMU range
>    KVM: x86/mmu: Zap only TDP MMU leafs in kvm_zap_gfn_range()
>    KVM: x86/mmu: Do remote TLB flush before dropping RCU in TDP MMU resched
>    KVM: x86/mmu: Defer TLB flush to caller when freeing TDP MMU shadow pages
>    KVM: x86/mmu: Zap roots in two passes to avoid inducing RCU stalls
>    KVM: x86/mmu: Check for a REMOVED leaf SPTE before making the SPTE
>    KVM: x86/mmu: WARN on any attempt to atomically update REMOVED SPTE
>    KVM: selftests: Move raw KVM_SET_USER_MEMORY_REGION helper to utils
>    KVM: selftests: Split out helper to allocate guest mem via memfd
>    KVM: selftests: Define cpu_relax() helpers for s390 and x86
>    KVM: selftests: Add test to populate a VM with the max possible guest mem
> 
>   arch/x86/include/asm/kvm_host.h               |   2 +
>   arch/x86/kvm/mmu/mmu.c                        |  49 +-
>   arch/x86/kvm/mmu/mmu_internal.h               |  15 +-
>   arch/x86/kvm/mmu/tdp_iter.c                   |   6 +-
>   arch/x86/kvm/mmu/tdp_iter.h                   |  15 +-
>   arch/x86/kvm/mmu/tdp_mmu.c                    | 559 +++++++++++-------
>   arch/x86/kvm/mmu/tdp_mmu.h                    |  26 +-
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   3 +
>   .../selftests/kvm/include/kvm_util_base.h     |   5 +
>   .../selftests/kvm/include/s390x/processor.h   |   8 +
>   .../selftests/kvm/include/x86_64/processor.h  |   5 +
>   tools/testing/selftests/kvm/lib/kvm_util.c    |  66 ++-
>   .../selftests/kvm/max_guest_memory_test.c     | 292 +++++++++
>   .../selftests/kvm/set_memory_region_test.c    |  35 +-
>   15 files changed, 794 insertions(+), 293 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/max_guest_memory_test.c
> 


Queued, thanks.

Paolo

