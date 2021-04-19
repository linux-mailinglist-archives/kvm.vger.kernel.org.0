Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B61363DF4
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 10:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbhDSIuF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 04:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238331AbhDSIuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 04:50:01 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61795C06174A;
        Mon, 19 Apr 2021 01:49:30 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id u80so1157134oia.0;
        Mon, 19 Apr 2021 01:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j08yIBwXLk5HTWZ6SAY1miLlwOHxJ1A2dFdxyi2DvcY=;
        b=ukeWmfzj4t9brWPWzsNE3efem5PCcXY6cXNQYcKhjpD9UkFz4br1NIN8f/JBbihNmc
         vYpUKm/Vr/B4dKqp2kH4f6bCVJejPqdAhqwyGlqZ+V5te749g4/JhajR6YKNGTZfHPE4
         9GAqcvd4JZc+6feJzwqc0YVM3+6G4G83pBQSCd2ZZ3rooz34mB/YLXy6ZS8PLGZh8Omx
         mFd0TiOioATJNxlJI2ajCidOxSN6ig9CoEKCLhG4SSrQkVZHB+uNTmYbGuntT3PFGI0J
         n+/n6yEnzHnvcEFp2rzTzc+KrdM8uac5ciHP738zzQ0p/eD208FmpVF7kZw4Z+kSIUDs
         cFJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j08yIBwXLk5HTWZ6SAY1miLlwOHxJ1A2dFdxyi2DvcY=;
        b=IawgxPcSOL7hRez6WTUtSjJsDdynYgS0MLpSRvgsXDbida/0s8YWlzv8R2Tk/vi3F/
         OQAsTCqSrMEo2PvjYXI6JBbN0/fbCnade3p4i66L+RDk3Oh4Q9gz+vWIlJZwbd/Pb/Ia
         kb26N4vKHhdrVw7N2o71+aS0kXIiuKXJ/azhx8sYYJlYFyUiTi05GdU8LPvS20UDvLAD
         gqx6ew6wHekOtMkxBZr5ARvBjCmpZOSq0NZFNzGw96b9VUvg3R/Y1PxE/uSKEuPfAWPB
         +hXIEgK7HOjMdU/AEGZtmcbgycvUFBaoPjIo1rMh5PoutX+7bys0Scpj10V6wQxDFYno
         dRwg==
X-Gm-Message-State: AOAM533RSaQPypaoCes8dPdMgQ5EkqQ7FSfAxJbarLi6rtm1dYZ2OWIW
        XqyXFcm+8dexopv2PN961h4XkIyQ4TcQ4lPKj30=
X-Google-Smtp-Source: ABdhPJy8F5yRINkAPts04KIndUObakf6+CqY0t8sQ3XggJcJX4zD4FAEWgQI/Ot5FoTZGR5pMwoWgxTwQHjcY6LtqVc=
X-Received: by 2002:a05:6808:5c5:: with SMTP id d5mr15029122oij.141.1618822169834;
 Mon, 19 Apr 2021 01:49:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210402005658.3024832-1-seanjc@google.com> <20210402005658.3024832-10-seanjc@google.com>
In-Reply-To: <20210402005658.3024832-10-seanjc@google.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 19 Apr 2021 16:49:20 +0800
Message-ID: <CANRm+Cwt9Xs=13r9E4YWOhcE6oEJXmVrkKrv_wQ5jMUkY8+Stw@mail.gmail.com>
Subject: Re: [PATCH v2 09/10] KVM: Don't take mmu_lock for range invalidation
 unless necessary
To:     Sean Christopherson <seanjc@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm <kvm@vger.kernel.org>, kvm-ppc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Apr 2021 at 08:59, Sean Christopherson <seanjc@google.com> wrote:
>
> Avoid taking mmu_lock for unrelated .invalidate_range_{start,end}()
> notifications.  Because mmu_notifier_count must be modified while holding
> mmu_lock for write, and must always be paired across start->end to stay
> balanced, lock elision must happen in both or none.  To meet that
> requirement, add a rwsem to prevent memslot updates across range_start()
> and range_end().
>
> Use a rwsem instead of a rwlock since most notifiers _allow_ blocking,
> and the lock will be endl across the entire start() ... end() sequence.
> If anything in the sequence sleeps, including the caller or a different
> notifier, holding the spinlock would be disastrous.
>
> For notifiers that _disallow_ blocking, e.g. OOM reaping, simply go down
> the slow path of unconditionally acquiring mmu_lock.  The sane
> alternative would be to try to acquire the lock and force the notifier
> to retry on failure.  But since OOM is currently the _only_ scenario
> where blocking is disallowed attempting to optimize a guest that has been
> marked for death is pointless.
>
> Unconditionally define and use mmu_notifier_slots_lock in the memslots
> code, purely to avoid more #ifdefs.  The overhead of acquiring the lock
> is negligible when the lock is uncontested, which will always be the case
> when the MMU notifiers are not used.
>
> Note, technically flag-only memslot updates could be allowed in parallel,
> but stalling a memslot update for a relatively short amount of time is
> not a scalability issue, and this is all more than complex enough.
>
> Based heavily on code from Ben Gardon.
>
> Suggested-by: Ben Gardon <bgardon@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

I saw this splatting:

 ======================================================
 WARNING: possible circular locking dependency detected
 5.12.0-rc3+ #6 Tainted: G           OE
 ------------------------------------------------------
 qemu-system-x86/3069 is trying to acquire lock:
 ffffffff9c775ca0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0},
at: __mmu_notifier_invalidate_range_end+0x5/0x190

 but task is already holding lock:
 ffffaff7410a9160 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3}, at:
kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3}:
        down_read+0x48/0x250
        kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]
        __mmu_notifier_invalidate_range_start+0xe8/0x260
        wp_page_copy+0x82b/0xa30
        do_wp_page+0xde/0x420
        __handle_mm_fault+0x935/0x1230
        handle_mm_fault+0x179/0x420
        do_user_addr_fault+0x1b3/0x690
        exc_page_fault+0x82/0x2b0
        asm_exc_page_fault+0x1e/0x30

 -> #0 (mmu_notifier_invalidate_range_start){+.+.}-{0:0}:
        __lock_acquire+0x110f/0x1980
        lock_acquire+0x1bc/0x400
        __mmu_notifier_invalidate_range_end+0x47/0x190
        wp_page_copy+0x796/0xa30
        do_wp_page+0xde/0x420
        __handle_mm_fault+0x935/0x1230
        handle_mm_fault+0x179/0x420
        do_user_addr_fault+0x1b3/0x690
        exc_page_fault+0x82/0x2b0
        asm_exc_page_fault+0x1e/0x30

 other info that might help us debug this:

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&kvm->mmu_notifier_slots_lock);
                                lock(mmu_notifier_invalidate_range_start);
                                lock(&kvm->mmu_notifier_slots_lock);
   lock(mmu_notifier_invalidate_range_start);

  *** DEADLOCK ***

 2 locks held by qemu-system-x86/3069:
  #0: ffff9e4269f8a9e0 (&mm->mmap_lock#2){++++}-{3:3}, at:
do_user_addr_fault+0x10e/0x690
  #1: ffffaff7410a9160 (&kvm->mmu_notifier_slots_lock){.+.+}-{3:3},
at: kvm_mmu_notifier_invalidate_range_start+0x36d/0x4f0 [kvm]

 stack backtrace:
 CPU: 0 PID: 3069 Comm: qemu-system-x86 Tainted: G           OE
5.12.0-rc3+ #6
 Hardware name: LENOVO ThinkCentre M8500t-N000/SHARKBAY, BIOS
FBKTC1AUS 02/16/2016
 Call Trace:
  dump_stack+0x87/0xb7
  print_circular_bug.isra.39+0x1b4/0x210
  check_noncircular+0x103/0x150
  __lock_acquire+0x110f/0x1980
  ? __lock_acquire+0x110f/0x1980
  lock_acquire+0x1bc/0x400
  ? __mmu_notifier_invalidate_range_end+0x5/0x190
  ? find_held_lock+0x40/0xb0
  __mmu_notifier_invalidate_range_end+0x47/0x190
  ? __mmu_notifier_invalidate_range_end+0x5/0x190
  wp_page_copy+0x796/0xa30
  do_wp_page+0xde/0x420
  __handle_mm_fault+0x935/0x1230
  handle_mm_fault+0x179/0x420
  do_user_addr_fault+0x1b3/0x690
  ? rcu_read_lock_sched_held+0x4f/0x80
  exc_page_fault+0x82/0x2b0
  ? asm_exc_page_fault+0x8/0x30
  asm_exc_page_fault+0x1e/0x30
 RIP: 0033:0x55f5bef2560f
