Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34ACA363088
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 16:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbhDQOK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 10:10:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33359 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233008AbhDQOK2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 10:10:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618668601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jS6gcU0zW/ISDMDIvxFLcjXPgIR+GWA8fBcDp8K5zUU=;
        b=M9YFN3ZtB0nkj9P+sIvlZTpmKrl2FAw1X4zBiIovPzCOrKMLqIgvsL+HRKBzMa7ZxIiwVD
        JRB7y9R8u7ByoldNWU1rzd6NvxshKPCDmJBVFfI7eYx1nWn5XeYjqx18nRQsq5+7GXsdtk
        rKsUwAnQG3o7Af63qttRAO/TCzZn5Mw=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-GFCUdLFKOlqkcpMzRqnYTg-1; Sat, 17 Apr 2021 10:09:59 -0400
X-MC-Unique: GFCUdLFKOlqkcpMzRqnYTg-1
Received: by mail-qk1-f198.google.com with SMTP id e4-20020a37b5040000b02902df9a0070efso1104188qkf.18
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 07:09:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jS6gcU0zW/ISDMDIvxFLcjXPgIR+GWA8fBcDp8K5zUU=;
        b=GuFbOxjdK/tsf0k7v3F2imhdHOX7OZc+WVcRIgIwCDooCirnr81QZvose7cJC3ZFQN
         +MxTT9EblkCRMsx5TRlAf3R+6RN9tZTXyWXv9+rpsIBf7zhQ6JfSey8yl6DAgscW1eg4
         YVYSna4IcgxcR1ZLn1HmMhUd9VkwofAcSQVHP1qMdHax2VSo9SM2on1L1T8PbFKiH025
         4fRrmPUp+01mn+toGRQDxpRRGSFO3w/kalC5csOmpJbXVziy2Qk1Duhpx1IRszzk04UK
         EZwmra8wXoLgrV0snucoTrKuSt1VICEcdWxM1Jyjw18wd7EnVwCFnr7TDnIff9rhVpa+
         a0Cg==
X-Gm-Message-State: AOAM531F8cQammGSo2+Is+ktR72ruF07I71Vqyk5a4lKi2PlzGiYouk7
        2ko0buToqeBgoXH26h+gHvVDchsJAOfBy9xldPIwvxEKFiTR0TsqJgEYk7N4lhQ//Of0HHwQjNQ
        O+o6BDT6qeyK+
X-Received: by 2002:ac8:6711:: with SMTP id e17mr3846141qtp.139.1618668598934;
        Sat, 17 Apr 2021 07:09:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxwAwFY81d7batTgRNwYqmKQ0Wbywvgn18Mz3Drx+qUeJvOqgt2pxy8AbjoBogR7HfZLBKxkg==
X-Received: by 2002:ac8:6711:: with SMTP id e17mr3846119qtp.139.1618668598533;
        Sat, 17 Apr 2021 07:09:58 -0700 (PDT)
Received: from xz-x1 (bras-base-toroon474qw-grc-88-174-93-75-154.dsl.bell.ca. [174.93.75.154])
        by smtp.gmail.com with ESMTPSA id h7sm5618220qtj.15.2021.04.17.07.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 07:09:57 -0700 (PDT)
Date:   Sat, 17 Apr 2021 10:09:56 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v2] kvm/selftests: Fix race condition with dirty_log_test
Message-ID: <20210417140956.GV4440@xz-x1>
References: <20210413213641.23742-1-peterx@redhat.com>
 <f5f5f2c8-6edd-129d-b570-47d8eaca94c0@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5f5f2c8-6edd-129d-b570-47d8eaca94c0@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo,

Please hold-on with this patch since I got another report that this patch can
still trigger test failure if even heavier workload (e.g., "taskset -c 0
./dirty_log_test" plus another one or multiple "taskset -c 0 while :; do:;
done").  So I plan to do it in another way.  I tested longer yesterday but
haven't updated this patch yet.  More below.

On Sat, Apr 17, 2021 at 02:59:48PM +0200, Paolo Bonzini wrote:
> On 13/04/21 23:36, Peter Xu wrote:
> > This patch closes this race by allowing the main thread to give the vcpu thread
> > chance to do a VMENTER to complete that write operation.  It's done by adding a
> > vcpu loop counter (must be defined as volatile as main thread will do read
> > loop), then the main thread can guarantee the vcpu got at least another VMENTER
> > by making sure the guest_vcpu_loops increases by 2.
> > 
> > Dirty ring does not need this since dirty_ring_last_page would already help
> > avoid this specific race condition.
> 
> Just a nit, the comment and commit message should mention KVM_RUN rather
> than vmentry; it's possible to be preempted many times in vcpu_enter_guest
> without making progress, but those wouldn't return to userspace and thus
> would not update guest_vcpu_loops.

But what I really wanted to emphasize is the vmentry point rather than KVM_RUN,
e.g., KVM_RUN can return without an vmentry, while the vmentry is the exactly
point that data will be flushed.

> 
> Also, volatile is considered harmful even in userspace/test code[1].
> Technically rather than volatile one should use an atomic load (even a
> relaxed one), but in practice it's okay to use volatile too *for this
> specific use* (READ_ONCE/WRITE_ONCE are volatile reads and writes as well).
> If the selftests gained 32-bit support, one should not use volatile because
> neither reads or writes to uint64_t variables would be guaranteed to be
> atomic.

Indeed!  I'll start to use atomics.

Regarding why this patch won't really solve all race conditions... The problem
is I think one guest memory write operation (of this specific test) contains a
few micro-steps when page is during kvm dirty tracking (here I'm only
considering write-protect rather than pml but pml should be similar at least
when the log buffer is full):

  (1) Guest read 'iteration' number into register, prepare to write, page fault
  (2) Set dirty bit in either dirty bitmap or dirty ring
  (3) Return to guest, data written

When we verify the data, we assumed that all these steps are "atomic", say,
when (1) happened for this page, we assume (2) & (3) must have happened.  We
had some trick to workaround "un-atomicity" of above three steps, as this patch
wanted to fix atomicity of step (2)+(3) by explicitly letting the main thread
wait for at least one vmenter of vcpu thread, which should work.  However what
I overlooked is probably that we still have race when (1) and (2) can be
interrupted.

As an example of how step (1) and (2) got interrupted, I simply tried to trace
kvm_vcpu_mark_page_dirty() and dump stack for vmexit cases, then we can see at
least a bunch of cases where vcpu can be scheduled out even before setting the
dirty bit:

@out[
    __schedule+1742
    __schedule+1742
    __cond_resched+52
    kmem_cache_alloc+583
    kvm_mmu_topup_memory_cache+33
    direct_page_fault+237
    kvm_mmu_page_fault+103
    vmx_handle_exit+288
    vcpu_enter_guest+2460
    kvm_arch_vcpu_ioctl_run+325
    kvm_vcpu_ioctl+526
    __x64_sys_ioctl+131
    do_syscall_64+51
    entry_SYSCALL_64_after_hwframe+68
]: 4
@out[
    __schedule+1742
    __schedule+1742
    __cond_resched+52
    down_read+14
    get_user_pages_unlocked+90
    hva_to_pfn+206
    try_async_pf+132
    direct_page_fault+320
    kvm_mmu_page_fault+103
    vmx_handle_exit+288
    vcpu_enter_guest+2460
    kvm_arch_vcpu_ioctl_run+325
    kvm_vcpu_ioctl+526
    __x64_sys_ioctl+131
    do_syscall_64+51
    entry_SYSCALL_64_after_hwframe+68
]: 23
@out[
    __schedule+1742
    __schedule+1742
    __cond_resched+52
    __alloc_pages+663
    alloc_pages_vma+128
    wp_page_copy+773
    __handle_mm_fault+3155
    handle_mm_fault+151
    __get_user_pages+664
    get_user_pages_unlocked+197
    hva_to_pfn+206
    try_async_pf+132
    direct_page_fault+320
    kvm_mmu_page_fault+103
    vmx_handle_exit+288
    vcpu_enter_guest+2460
    kvm_arch_vcpu_ioctl_run+325
    kvm_vcpu_ioctl+526
    __x64_sys_ioctl+131
    do_syscall_64+51
    entry_SYSCALL_64_after_hwframe+68
]: 1406
@out[
    __schedule+1742
    __schedule+1742
    __cond_resched+52
    hva_to_pfn+157
    try_async_pf+132
    direct_page_fault+320
    kvm_mmu_page_fault+103
    vmx_handle_exit+288
    vcpu_enter_guest+2460
    kvm_arch_vcpu_ioctl_run+325
    kvm_vcpu_ioctl+526
    __x64_sys_ioctl+131
    do_syscall_64+51
    entry_SYSCALL_64_after_hwframe+68
]: 2579
@out[
    __schedule+1742
    __schedule+1742
    __cond_resched+52
    mmu_notifier_invalidate_range_start+9
    wp_page_copy+296
    __handle_mm_fault+3155
    handle_mm_fault+151
    __get_user_pages+664
    get_user_pages_unlocked+197
    hva_to_pfn+206
    try_async_pf+132
    direct_page_fault+320
    kvm_mmu_page_fault+103
    vmx_handle_exit+288
    vcpu_enter_guest+2460
    kvm_arch_vcpu_ioctl_run+325
    kvm_vcpu_ioctl+526
    __x64_sys_ioctl+131
    do_syscall_64+51
    entry_SYSCALL_64_after_hwframe+68
]: 3309
@out[
    __schedule+1742
    __schedule+1742
    __cond_resched+52
    __get_user_pages+530
    get_user_pages_unlocked+197
    hva_to_pfn+206
    try_async_pf+132
    direct_page_fault+320
    kvm_mmu_page_fault+103
    vmx_handle_exit+288
    vcpu_enter_guest+2460
    kvm_arch_vcpu_ioctl_run+325
    kvm_vcpu_ioctl+526
    __x64_sys_ioctl+131
    do_syscall_64+51
    entry_SYSCALL_64_after_hwframe+68
]: 4499

It means... it can always happen that the vcpu reads a very old "iteration"
value in step 1 and it doesn't set dirty bit (step 2) or write it to memory
(step 3) until, say, 1 year later.. :) Then the verify won't pass since the
main thread iteration has been much newer, then main thread shouts at us.

So far I don't see an easy way to guarantee all steps 1-3 atomicity (as this
patch only achieved steps 2-3), but to sync at the GUEST_SYNC() point of guest
code when we do verification of the dirty bits.  Drew mentioned something like
this previously in the bugzilla, I wanted to give it a shot with a lighter
sync, but seems not working.

Paolo, Drew, Sean - feel free to shoot if any of you have a better idea.

As I mentioned I tested v2 of this patch and so far no issue found.  I'll post
it later today, so maybe we can continue discuss there too (btw, I also found
another signal race there; so I'll post a series with 2 patches).

Thanks,

-- 
Peter Xu

