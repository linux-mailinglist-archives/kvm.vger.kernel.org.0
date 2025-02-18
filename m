Return-Path: <kvm+bounces-38476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4FEEA3A769
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 20:29:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BB86166631
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2025 19:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 212861E8329;
	Tue, 18 Feb 2025 19:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K8OLu0ml"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB4721B9C4
	for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 19:29:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739906988; cv=none; b=QnByIAoD781s0vpAPshegCf65XCK+KxegWZA6PvJrMnz0lt8XeZ3tPAHuXF0qg5NfoWz+0Bvih9dlpd+3HFlBPmHc1OxGPghw9UiFVlw7/V8NP5n9svQ2lz/2njwCGWCNXLBcq9/OcqyuJJnjy402psq/7gqsKnsLBAI71TvCAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739906988; c=relaxed/simple;
	bh=Iyi0mkkbj829sYGj2VaDB/ZDTf8v5Q+yc6BRlMTdJbo=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ten3GVJ12/KKwDbrTxGE+zY9utfVSWlWJVMAgZThuP3u8NdhIQ3FCjJP9egTqYDLa9P0rEmntbBbASx1RfT3RFkr5pojazs2Skz0uBbXigj7MKQBmyF5VkmMO0ufwxCo+QtQjotMjvwhhQDU0XKTB4x6MYR4TEVFfRL73WjVguA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=K8OLu0ml; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739906985;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2XqglfLfBNjZUvkW/Dyb4ZzrcV/Lr4EbGt5iKUqOYU8=;
	b=K8OLu0mlO9xmjxE501ro2EVA8ysjQv5CeZZHApdy6XR6fUNdSNFjNey8cufHjTEB24yGO2
	7GSjevOEWHfZbqEXOx9N5YlafO+XYbUEzpoaPRhIWr4ZVMCBt86/RF6RtwKJ0vQWA9X2wo
	YL7lKFRQ/5tmlFHj6+lxHwoLKVkFTgs=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-622-BpU4VnuHO8WDBsrOLgekpQ-1; Tue, 18 Feb 2025 14:29:44 -0500
X-MC-Unique: BpU4VnuHO8WDBsrOLgekpQ-1
X-Mimecast-MFC-AGG-ID: BpU4VnuHO8WDBsrOLgekpQ_1739906983
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c0a46f1ec7so302934085a.2
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2025 11:29:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739906983; x=1740511783;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2XqglfLfBNjZUvkW/Dyb4ZzrcV/Lr4EbGt5iKUqOYU8=;
        b=EHzD8ZVmrTovGlDOju3hLLK6HbNCmcS7gjjyCvPW+ZfK6cl9lDyfzT1vpEB9sqCS7F
         VY1dhm16R01yVQQCmPs4zwOFitlgoFPOQCHJJ2rqHDXGHtP64zHfFl1b6bLLBQRfTNzp
         DwpZYK9uLOZB3Lpe1HC3UqPrFikwYFG+t1hZPCggRdYSdk9jVLUxEqwOxp1UHuhVxgl0
         83AgSSd/Ujgg1G/15o8DTpuMyTqKiUXloCfD5B1impjkDQ637uZMLHsMXjPdi2EYiM11
         dDYCXm7gKJR0etTGKLv3Jv9383sb4WEN7VdDOgn2v2u+tWoSt5W8sOa/R8hmD55bPQKr
         3SMQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5pj6RAF2cbviNAwQg3NMr4I+c0FBnpHmh360dIr95WywuJFyGEMR7rTq68Vsnro9jtGc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnlIbMM5VD19qQPrCrqSw/L9J2gt9yvcDiPpEuHcNfvN+3wa4d
	BU50sfIiv18+aeEW1hQbg3xlKnqMnaOfqlwB5A1JHNbxLP3ZbqMn6P7rR6ItX4tlfdRtmKiwkDI
	//EL6CVEQ+OkQVv1hKI10cykZri9aMw16SF89mbRZ+iE7BQP+7A==
X-Gm-Gg: ASbGnctwYqSquYPA0FZziT+wSRJF/z+OJGW2vJFxlnawp7uf/mayaVsyVCYLcx5h9YR
	Rj6Dhj01oNTy3HdGvH5Z1EdIzLofNPs0g3WyWl2pXnirzB2jzb9RX65sXAhz1AsGIqgZxgY+yKP
	HI7u0elXOnkb9D+R8vfcXo7ZzlsxCOKtm2o8tvzhGivO97rYn5E/0ePiHdsW8MXjntF9LM5960N
	WWCRlbTcxlB6nhoNkBfOalui3SQNMRFkCYAG5FaSuFdelr70SFrrkpMysfvqogGp3sV0eYUI0sN
	5NGb
X-Received: by 2002:a05:620a:4146:b0:7c0:5e82:8228 with SMTP id af79cd13be357-7c08a9a6346mr1971367985a.21.1739906983317;
        Tue, 18 Feb 2025 11:29:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGl+8v+Xj43jpMThJb5/HqXF7xZfzQHa0JE30wSeMgrl6wT/+uCV8Ncoyw1h1dz70J5H9xDvw==
X-Received: by 2002:a05:620a:4146:b0:7c0:5e82:8228 with SMTP id af79cd13be357-7c08a9a6346mr1971363385a.21.1739906982811;
        Tue, 18 Feb 2025 11:29:42 -0800 (PST)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c095bffcc6sm329046985a.3.2025.02.18.11.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 11:29:42 -0800 (PST)
Message-ID: <025b409c5ca44055a5f90d2c67e76af86617e222.camel@redhat.com>
Subject: Re: [PATCH v9 00/11] KVM: x86/mmu: Age sptes locklessly
From: Maxim Levitsky <mlevitsk@redhat.com>
To: James Houghton <jthoughton@google.com>, Sean Christopherson
	 <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: David Matlack <dmatlack@google.com>, David Rientjes
 <rientjes@google.com>,  Marc Zyngier <maz@kernel.org>, Oliver Upton
 <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao
 <yuzhao@google.com>, Axel Rasmussen <axelrasmussen@google.com>, 
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 18 Feb 2025 14:29:41 -0500
In-Reply-To: <20250204004038.1680123-1-jthoughton@google.com>
References: <20250204004038.1680123-1-jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2025-02-04 at 00:40 +0000, James Houghton wrote:
> By aging sptes locklessly with the TDP MMU and the shadow MMU, neither
> vCPUs nor reclaim (mmu_notifier_invalidate_range*) will get stuck
> waiting for aging. This contention reduction improves guest performance
> and saves a significant amount of Google Cloud's CPU usage, and it has
> valuable improvements for ChromeOS, as Yu has mentioned previously[1].
> 
> Please see v8[8] for some performance results using
> access_tracking_perf_test patched to use MGLRU.
> 
> Neither access_tracking_perf_test nor mmu_stress_test trigger any
> splats (with CONFIG_LOCKDEP=y) with the TDP MMU and with the shadow MMU.


Hi, I have a question about this patch series and about the access_tracking_perf_test:

Some time ago, I investigated a failure in access_tracking_perf_test which shows up in our CI.

The root cause was that 'folio_clear_idle' doesn't clear the idle bit when MGLRU is enabled,
and overall I got the impression that MGLRU is not compatible with idle page tracking.


I thought that this patch series and the 'mm: multi-gen LRU: Have secondary MMUs participate in MM_WALK' 
patch series could address this but the test still fails.


For the reference the exact problem is:

1. Idle bits for guest memory under test are set via /sys/kernel/mm/page_idle/bitmap

2. Guest dirties memory, which leads to A/D bits being set in the secondary mappings.

3. A NUMA autobalance code write protects the guest memory. KVM in response evicts the SPTE mappings with A/D bit set,
   and while doing so tells mm that pages were accessed using 'folio_mark_accessed' (via kvm_set_page_accessed (*) )
   but due to MLGRU the call doesn't clear the idle bit and thus all the traces of the guest access disappear
   and the kernel thinks that the page is still idle.

I can say that the root cause of this is that folio_mark_accessed doesn't do what it supposed to do.

Calling 'folio_clear_idle(folio);' in MLGRU case in folio_mark_accessed() 
will probably fix this but I don't have enough confidence
to say if this is all that is needed to fix this. 
If this is the case I can send a patch.


This patch makes the test pass (but only on 6.12 kernel and below, see below):

diff --git a/mm/swap.c b/mm/swap.c
index 59f30a981c6f..2013e1f4d572 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -460,7 +460,7 @@ void folio_mark_accessed(struct folio *folio)
 {
        if (lru_gen_enabled()) {
                folio_inc_refs(folio);
-               return;
+               goto clear_idle_bit;
        }
 
        if (!folio_test_referenced(folio)) {
@@ -485,6 +485,7 @@ void folio_mark_accessed(struct folio *folio)
                folio_clear_referenced(folio);
                workingset_activation(folio);
        }
+clear_idle_bit:
        if (folio_test_idle(folio))
                folio_clear_idle(folio);
 }


To always reproduce this, it is best to use a patch to make the test run in a loop, 
like below (although the test fails without this as well).


diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tools/testing/selftests/kvm/access_tracking_perf_test.c
index 3c7defd34f56..829774e325fa 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -131,6 +131,7 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
        uint64_t pages = vcpu_args->pages;
        uint64_t page;
        uint64_t still_idle = 0;
+       uint64_t failed_to_mark_idle = 0;
        uint64_t no_pfn = 0;
        int page_idle_fd;
        int pagemap_fd;
@@ -160,6 +161,14 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
                }
 
                mark_page_idle(page_idle_fd, pfn);
+
+
+                if (!is_page_idle(page_idle_fd, pfn)) {
+                        failed_to_mark_idle++;
+                        continue;
+                }
+
+
        }
 
        /*
@@ -183,16 +192,15 @@ static void mark_vcpu_memory_idle(struct kvm_vm *vm,
         * explicitly flush the TLB when aging SPTEs.  As a result, more pages
         * are cached and the guest won't see the "idle" bit cleared.
         */
-       if (still_idle >= pages / 10) {
+       //if (still_idle >= pages / 10) {
 #ifdef __x86_64__
-               TEST_ASSERT(this_cpu_has(X86_FEATURE_HYPERVISOR),
-                           "vCPU%d: Too many pages still idle (%lu out of %lu)",
-                           vcpu_idx, still_idle, pages);
+       //      TEST_ASSERT(this_cpu_has(X86_FEATURE_HYPERVISOR),
+       //                  "vCPU%d: Too many pages still idle (%lu out of %lu)",
+       //                  vcpu_idx, still_idle, pages);
 #endif
-               printf("WARNING: vCPU%d: Too many pages still idle (%lu out of %lu), "
-                      "this will affect performance results.\n",
-                      vcpu_idx, still_idle, pages);
-       }
+               printf("vCPU%d: idle pages: %lu out of %lu, failed to mark idle: %lu no pfn: %lu\n",
+                      vcpu_idx, still_idle, pages, failed_to_mark_idle, no_pfn);
+       //}
 
        close(page_idle_fd);
        close(pagemap_fd);
@@ -315,14 +323,16 @@ static void run_test(enum vm_guest_mode mode, void *arg)
        access_memory(vm, nr_vcpus, ACCESS_WRITE, "Populating memory");
 
        /* As a control, read and write to the populated memory first. */
-       access_memory(vm, nr_vcpus, ACCESS_WRITE, "Writing to populated memory");
-       access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from populated memory");
+       //access_memory(vm, nr_vcpus, ACCESS_WRITE, "Writing to populated memory");
+       //access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from populated memory");
 
        /* Repeat on memory that has been marked as idle. */
+again:
        mark_memory_idle(vm, nr_vcpus);
        access_memory(vm, nr_vcpus, ACCESS_WRITE, "Writing to idle memory");
-       mark_memory_idle(vm, nr_vcpus);
-       access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from idle memory");
+       //mark_memory_idle(vm, nr_vcpus);
+       //access_memory(vm, nr_vcpus, ACCESS_READ, "Reading from idle memory");
+       goto again;
 
        memstress_join_vcpu_threads(nr_vcpus);
        memstress_destroy_vm(vm);


With the above patch applied, you will notice after 4-6 iterations that the number of still idle
pages soars:

Populating memory             : 0.798882357s
vCPU0: idle pages: 0 out of 262144, failed to mark idle: 0 no pfn: 0
Mark memory idle              : 3.003939277s
Writing to idle memory        : 0.503653562s
vCPU0: idle pages: 0 out of 262144, failed to mark idle: 0 no pfn: 0
Mark memory idle              : 3.060128175s
Writing to idle memory        : 0.502705587s
vCPU0: idle pages: 2048 out of 262144, failed to mark idle: 0 no pfn: 0
Mark memory idle              : 3.039294079s
Writing to idle memory        : 0.092227612s
vCPU0: idle pages: 0 out of 262144, failed to mark idle: 0 no pfn: 0
Mark memory idle              : 3.046216234s
Writing to idle memory        : 0.295077724s
vCPU0: idle pages: 132558 out of 262144, failed to mark idle: 0 no pfn: 0
Mark memory idle              : 2.711946690s
Writing to idle memory        : 0.302882502s

...



(*) Turns out that since kernel 6.13, this code that sets accessed bit in the primary paging
structure, when the secondary was zapped was *removed*. I bisected this to commit:

66bc627e7fee KVM: x86/mmu: Don't mark "struct page" accessed when zapping SPTEs

So now the access_tracking_test is broken regardless of MGLRU.

Any ideas on how to fix all this mess?


Best regards,
	Maxim Levitsky


> 
> === Previous Versions ===
> 
> Since v8[8]:
>  - Re-added the kvm_handle_hva_range helpers and applied Sean's
>    kvm_{handle -> age}_hva_range rename.
>  - Renamed spte_has_volatile_bits() to spte_needs_atomic_write() and
>    removed its Accessed bit check. Undid change to
>    tdp_mmu_spte_need_atomic_write().
>  - Renamed KVM_MMU_NOTIFIER_{YOUNG -> AGING}_LOCKLESS.
>  - cpu_relax(), lockdep, preempt_disable(), and locking fixups for
>    per-rmap lock (thanks Lai and Sean).
>  - Renamed kvm_{has -> may_have}_shadow_mmu_sptes().
>  - Rebased onto latest kvm/next, including changing
>    for_each_tdp_mmu_root_rcu to use `types`.
>  - Dropped MGLRU changes from access_tracking_perf_test.
>  - Picked up Acked-bys from Yu. (thank you!)
> 
> Since v7[7]:
>  - Dropped MGLRU changes.
>  - Dropped DAMON cleanup.
>  - Dropped MMU notifier changes completely.
>  - Made shadow MMU aging *always* lockless, not just lockless when the
>    now-removed "fast_only" clear notifier was used.
>  - Given that the MGLRU changes no longer introduce a new MGLRU
>    capability, drop the new capability check from the selftest.
>  - Rebased on top of latest kvm-x86/next, including the x86 mmu changes
>    for marking pages as dirty.
> 
> Since v6[6]:
>  - Rebased on top of kvm-x86/next and Sean's lockless rmap walking
>    changes.
>  - Removed HAVE_KVM_MMU_NOTIFIER_YOUNG_FAST_ONLY (thanks DavidM).
>  - Split up kvm_age_gfn() / kvm_test_age_gfn() optimizations (thanks
>    DavidM and Sean).
>  - Improved new MMU notifier documentation (thanks DavidH).
>  - Dropped arm64 locking change.
>  - No longer retry for CAS failure in TDP MMU non-A/D case (thanks
>    Sean).
>  - Added some R-bys and A-bys.
> 
> Since v5[5]:
>  - Reworked test_clear_young_fast_only() into a new parameter for the
>    existing notifiers (thanks Sean).
>  - Added mmu_notifier.has_fast_aging to tell mm if calling fast-only
>    notifiers should be done.
>  - Added mm_has_fast_young_notifiers() to inform users if calling
>    fast-only notifier helpers is worthwhile (for look-around to use).
>  - Changed MGLRU to invoke a single notifier instead of two when
>    aging and doing look-around (thanks Yu).
>  - For KVM/x86, check indirect_shadow_pages > 0 instead of
>    kvm_memslots_have_rmaps() when collecting age information
>    (thanks Sean).
>  - For KVM/arm, some fixes from Oliver.
>  - Small fixes to access_tracking_perf_test.
>  - Added missing !MMU_NOTIFIER version of mmu_notifier_clear_young().
> 
> Since v4[4]:
>  - Removed Kconfig that controlled when aging was enabled. Aging will
>    be done whenever the architecture supports it (thanks Yu).
>  - Added a new MMU notifier, test_clear_young_fast_only(), specifically
>    for MGLRU to use.
>  - Add kvm_fast_{test_,}age_gfn, implemented by x86.
>  - Fix locking for clear_flush_young().
>  - Added KVM_MMU_NOTIFIER_YOUNG_LOCKLESS to clean up locking changes
>    (thanks Sean).
>  - Fix WARN_ON and other cleanup for the arm64 locking changes
>    (thanks Oliver).
> 
> Since v3[3]:
>  - Vastly simplified the series (thanks David). Removed mmu notifier
>    batching logic entirely.
>  - Cleaned up how locking is done for mmu_notifier_test/clear_young
>    (thanks David).
>  - Look-around is now only done when there are no secondary MMUs
>    subscribed to MMU notifiers.
>  - CONFIG_LRU_GEN_WALKS_SECONDARY_MMU has been added.
>  - Fixed the lockless implementation of kvm_{test,}age_gfn for x86
>    (thanks David).
>  - Added MGLRU functional and performance tests to
>    access_tracking_perf_test (thanks Axel).
>  - In v3, an mm would be completely ignored (for aging) if there was a
>    secondary MMU but support for secondary MMU walking was missing. Now,
>    missing secondary MMU walking support simply skips the notifier
>    calls (except for eviction).
>  - Added a sanity check for that range->lockless and range->on_lock are
>    never both provided for the memslot walk.
> 
> For the changes since v2[2], see v3.
> 
> Based on latest kvm/next.
> 
> [1]: https://lore.kernel.org/kvm/CAOUHufYS0XyLEf_V+q5SCW54Zy2aW5nL8CnSWreM8d1rX5NKYg@mail.gmail.com/
> [2]: https://lore.kernel.org/kvmarm/20230526234435.662652-1-yuzhao@google.com/
> [3]: https://lore.kernel.org/linux-mm/20240401232946.1837665-1-jthoughton@google.com/
> [4]: https://lore.kernel.org/linux-mm/20240529180510.2295118-1-jthoughton@google.com/
> [5]: https://lore.kernel.org/linux-mm/20240611002145.2078921-1-jthoughton@google.com/
> [6]: https://lore.kernel.org/linux-mm/20240724011037.3671523-1-jthoughton@google.com/
> [7]: https://lore.kernel.org/kvm/20240926013506.860253-1-jthoughton@google.com/
> [8]: https://lore.kernel.org/kvm/20241105184333.2305744-1-jthoughton@google.com/
> 
> James Houghton (7):
>   KVM: Rename kvm_handle_hva_range()
>   KVM: Add lockless memslot walk to KVM
>   KVM: x86/mmu: Factor out spte atomic bit clearing routine
>   KVM: x86/mmu: Relax locking for kvm_test_age_gfn() and kvm_age_gfn()
>   KVM: x86/mmu: Rename spte_has_volatile_bits() to
>     spte_needs_atomic_write()
>   KVM: x86/mmu: Skip shadow MMU test_young if TDP MMU reports page as
>     young
>   KVM: x86/mmu: Only check gfn age in shadow MMU if
>     indirect_shadow_pages > 0
> 
> Sean Christopherson (4):
>   KVM: x86/mmu: Refactor low level rmap helpers to prep for walking w/o
>     mmu_lock
>   KVM: x86/mmu: Add infrastructure to allow walking rmaps outside of
>     mmu_lock
>   KVM: x86/mmu: Add support for lockless walks of rmap SPTEs
>   KVM: x86/mmu: Support rmap walks without holding mmu_lock when aging
>     gfns
> 
>  Documentation/virt/kvm/locking.rst |   4 +-
>  arch/x86/include/asm/kvm_host.h    |   4 +-
>  arch/x86/kvm/Kconfig               |   1 +
>  arch/x86/kvm/mmu/mmu.c             | 364 +++++++++++++++++++++--------
>  arch/x86/kvm/mmu/spte.c            |  19 +-
>  arch/x86/kvm/mmu/spte.h            |   2 +-
>  arch/x86/kvm/mmu/tdp_iter.h        |  26 ++-
>  arch/x86/kvm/mmu/tdp_mmu.c         |  36 ++-
>  include/linux/kvm_host.h           |   1 +
>  virt/kvm/Kconfig                   |   2 +
>  virt/kvm/kvm_main.c                |  56 +++--
>  11 files changed, 364 insertions(+), 151 deletions(-)
> 
> 
> base-commit: f7bafceba76e9ab475b413578c1757ee18c3e44b





