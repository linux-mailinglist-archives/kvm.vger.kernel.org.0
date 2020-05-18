Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B921D731E
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 10:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgERIl2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 04:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726285AbgERIl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 04:41:28 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23864C061A0C;
        Mon, 18 May 2020 01:41:28 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id z6so1869711ooz.3;
        Mon, 18 May 2020 01:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oSrWGHIJnwl5plJgYtRqlGjz3pXTL9DsLqcdAW+1uCU=;
        b=QLh9x0+mo7WjOWixJEjS1rVML9oGzFMs5CsEWLB/IAEvmag0PSHrperdIn0zBrzDsl
         pYnhxRjvnxThDu9QSVaFngwkKp9eI+6iW6YLhG3OxZfyTsyDnrO+E2xvOX0KL3FOHTDa
         1lpVjRLz3hfkVg6M+f1T9IjjZAuLIS+lfYA1tvL2V3dDmXZlyeRA2XQX39WliK7a9rhY
         Wue6Dkzmsks2mNImdslYtyZUX+BBv6FTUXGLl6w4HDSIV2dTW9Wdl93m7uKwpn6HQrqz
         GIfiWvj3Bd1KiI59NikTKmr8N/utG6gjAbXoUwdHZJLRYQSFtxn71dbICsjxNAmFsGlZ
         PwqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oSrWGHIJnwl5plJgYtRqlGjz3pXTL9DsLqcdAW+1uCU=;
        b=GXG5fb2elcUr++icVayJKRLMdS8xJY3IpZ7LSXohFY7KztIA/ljeWIwKsMAy1bcTGu
         fnLHzAZa4hQtIuslDP/alnmXxrOPLN9LJSE8LFdtnPty8/FIsP66CZan/44/rZmOKBsN
         GxNNWtZlpz9RSQlCpjTsHftc1KpGTlvB1dWZBM+ZEs6gI91BjZUQxhl5+KvQL3aVXHnO
         Op5H6Za1WfAfQtxl0qGAvU9iatEwTMrsBIFd86ivX/9G5+5mVxwd6g46WplUBnP54Kl5
         Q79sI0OlOikOyJvj6ZeFgL7wUFCumZIDgyXfJbmP8QVV7v821AbSJENurm5NjA8khj5w
         ZdNA==
X-Gm-Message-State: AOAM532HHZXu2GUtEpgxEUSW1gxsB3qrRo2v4zUtUCm5kDw1J92jAIJN
        j8BQQ6yC4Cc2bZzxQF+hm7DineDu5ttHjavp1y0=
X-Google-Smtp-Source: ABdhPJycE+6a6o/J6arfnHwij8PJ1dF3Q16uX/Ocgj0cvyQxLFRu+werKa1BFDMJ3mqH450g1PA6nqpoX5OZok90G0I=
X-Received: by 2002:a4a:d355:: with SMTP id d21mr11985320oos.66.1589791287419;
 Mon, 18 May 2020 01:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200424054837.5138-1-dave@stgolabs.net> <20200424054837.5138-6-dave@stgolabs.net>
In-Reply-To: <20200424054837.5138-6-dave@stgolabs.net>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 18 May 2020 16:51:29 +0800
Message-ID: <CANRm+CwDGx57yOxXMF5VkkeJzwTAqrNQWsdDzfYHxJR3Oj_VFA@mail.gmail.com>
Subject: Re: [PATCH 5/5] kvm: Replace vcpu->swait with rcuwait
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Sebastian Sewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        will@kernel.org, joel@joelfernandes.org,
        LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Apr 2020 at 13:53, Davidlohr Bueso <dave@stgolabs.net> wrote:
>
> The use of any sort of waitqueue (simple or regular) for
> wait/waking vcpus has always been an overkill and semantically
> wrong. Because this is per-vcpu (which is blocked) there is
> only ever a single waiting vcpu, thus no need for any sort of
> queue.
>
> As such, make use of the rcuwait primitive, with the following
> considerations:
>
>   - rcuwait already provides the proper barriers that serialize
>   concurrent waiter and waker.
>
>   - Task wakeup is done in rcu read critical region, with a
>   stable task pointer.
>
>   - Because there is no concurrency among waiters, we need
>   not worry about rcuwait_wait_event() calls corrupting
>   the wait->task. As a consequence, this saves the locking
>   done in swait when modifying the queue. This also applies
>   to per-vcore wait for powerpc kvm-hv.
>
> The x86 tscdeadline_latency test mentioned in 8577370fb0cb
> ("KVM: Use simple waitqueue for vcpu->wq") shows that, on avg,
> latency is reduced by around 15-20% with this change.
>

This is splatting when I run linux guest on latest kvm/queue.

[24726.009187] =============================
[24726.009193] WARNING: suspicious RCU usage
[24726.009201] 5.7.0-rc2+ #3 Not tainted
[24726.009207] -----------------------------
[24726.009215] ./include/linux/rcuwait.h:34 suspicious
rcu_dereference_check() usage!
[24726.009222]
other info that might help us debug this:

[24726.009229]
rcu_scheduler_active = 2, debug_locks = 1
[24726.009237] 2 locks held by qemu-system-x86/6094:
[24726.009244]  #0: ffff88837b6cb990 (&vcpu->mutex){+.+.}-{3:3}, at:
kvm_vcpu_ioctl+0x191/0xbb0 [kvm]
[24726.009347]  #1: ffffc900036c2c68 (&kvm->srcu){....}-{0:0}, at:
kvm_arch_vcpu_ioctl_run+0x17f1/0x5680 [kvm]
[24726.009386]
stack backtrace:
[24726.009394] CPU: 5 PID: 6094 Comm: qemu-system-x86 Not tainted 5.7.0-rc2+ #3
[24726.009400] Hardware name: LENOVO ThinkCentre M8500t-N000/SHARKBAY,
BIOS FBKTC1AUS 02/16/2016
[24726.009405] Call Trace:
[24726.009418]  dump_stack+0x98/0xd5
[24726.009432]  lockdep_rcu_suspicious+0x123/0x170
[24726.009465]  kvm_vcpu_on_spin+0x46f/0x5d0 [kvm]
[24726.009497]  handle_pause+0x7e/0x3e0 [kvm_intel]
[24726.009517]  vmx_handle_exit+0x1fe/0x1000 [kvm_intel]
[24726.009547]  ? kvm_arch_vcpu_ioctl_run+0x17c5/0x5680 [kvm]
[24726.009586]  kvm_arch_vcpu_ioctl_run+0x18f5/0x5680 [kvm]
[24726.009595]  ? check_chain_key+0x26e/0x670
[24726.009651]  ? kvm_arch_vcpu_runnable+0x540/0x540 [kvm]
[24726.009667]  ? tomoyo_execute_permission+0x4b0/0x4b0
[24726.009677]  ? sched_clock+0x31/0x40
[24726.009726]  kvm_vcpu_ioctl+0x5d2/0xbb0 [kvm]
[24726.009754]  ? kvm_vcpu_ioctl+0x5d2/0xbb0 [kvm]
[24726.009786]  ? kvm_set_memory_region+0x90/0x90 [kvm]
[24726.009819]  ? __fget_files+0x2d4/0x420
[24726.009837]  ? do_dup2+0x660/0x660
[24726.009847]  ? lock_acquire+0x1e5/0x660
[24726.009864]  ? tomoyo_file_ioctl+0x19/0x20
[24726.009880]  ksys_ioctl+0x3d2/0x1390
[24726.009900]  ? generic_block_fiemap+0x70/0x70
[24726.009911]  ? rcu_read_lock_sched_held+0xb4/0xe0
[24726.009920]  ? rcu_read_lock_any_held.part.9+0x20/0x20
[24726.009935]  ? __x64_sys_futex+0x1a1/0x400
[24726.009943]  ? __kasan_check_write+0x14/0x20
[24726.009951]  ? switch_fpu_return+0x181/0x3e0
[24726.009963]  ? do_futex+0x14e0/0x14e0
[24726.009970]  ? lockdep_hardirqs_off+0x1df/0x2d0
[24726.009977]  ? syscall_return_slowpath+0x66/0x9d0
[24726.009987]  ? do_syscall_64+0x8e/0xae0
[24726.009995]  ? entry_SYSCALL_64_after_hwframe+0x49/0xb3
[24726.010012]  __x64_sys_ioctl+0x73/0xb0
[24726.010023]  do_syscall_64+0x108/0xae0
[24726.010032]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[24726.010042]  ? syscall_return_slowpath+0x9d0/0x9d0
[24726.010048]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[24726.010059]  ? trace_hardirqs_off_caller+0x28/0x1b0
[24726.010074]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[24726.010092]  entry_SYSCALL_64_after_hwframe+0x49/0xb3


[25372.530417] =============================
[25372.530420] WARNING: suspicious RCU usage
[25372.530425] 5.7.0-rc2+ #3 Not tainted
[25372.530428] -----------------------------
[25372.530432] ./include/linux/rcuwait.h:34 suspicious
rcu_dereference_check() usage!
[25372.530436]
other info that might help us debug this:

[25372.530440]
rcu_scheduler_active = 2, debug_locks = 1
[25372.530443] 1 lock held by qemu-system-x86/6433:
[25372.530447]  #0: ffff88837b6cb990 (&vcpu->mutex){+.+.}-{3:3}, at:
kvm_vcpu_ioctl+0x191/0xbb0 [kvm]
[25372.530483]
stack backtrace:
[25372.530487] CPU: 1 PID: 6433 Comm: qemu-system-x86 Not tainted 5.7.0-rc2+ #3
[25372.530491] Hardware name: LENOVO ThinkCentre M8500t-N000/SHARKBAY,
BIOS FBKTC1AUS 02/16/2016
[25372.530495] Call Trace:
[25372.530504]  dump_stack+0x98/0xd5
[25372.530513]  lockdep_rcu_suspicious+0x123/0x170
[25372.530547]  kvm_lapic_expired_hv_timer+0x1ad/0x1f0 [kvm]
[25372.530559]  vmx_vcpu_run+0x1892/0x2c60 [kvm_intel]
[25372.530568]  ? rcu_preempt_deferred_qs_handler+0x20/0x40
[25372.530579]  ? clear_atomic_switch_msr+0x970/0x970 [kvm_intel]
[25372.530586]  ? rcu_read_lock_any_held.part.9+0x20/0x20
[25372.530613]  kvm_arch_vcpu_ioctl_run+0x1579/0x5680 [kvm]
[25372.530619]  ? check_chain_key+0x26e/0x670
[25372.530654]  ? kvm_arch_vcpu_runnable+0x540/0x540 [kvm]
[25372.530665]  ? tomoyo_execute_permission+0x4b0/0x4b0
[25372.530671]  ? sched_clock+0x31/0x40
[25372.530678]  ? sched_clock_cpu+0x1b/0x1b0
[25372.530706]  kvm_vcpu_ioctl+0x5d2/0xbb0 [kvm]
[25372.530724]  ? kvm_vcpu_ioctl+0x5d2/0xbb0 [kvm]
[25372.530744]  ? kvm_set_memory_region+0x90/0x90 [kvm]
[25372.530764]  ? __fget_files+0x2d4/0x420
[25372.530775]  ? do_dup2+0x660/0x660
[25372.530779]  ? vfs_iter_write+0xb0/0xb0
[25372.530785]  ? rcu_read_lock_held+0xb4/0xc0
[25372.530795]  ? tomoyo_file_ioctl+0x19/0x20
[25372.530806]  ksys_ioctl+0x3d2/0x1390
[25372.530814]  ? do_dup2+0x660/0x660
[25372.530821]  ? generic_block_fiemap+0x70/0x70
[25372.530833]  ? __kasan_check_write+0x14/0x20
[25372.530838]  ? fput_many+0x20/0x140
[25372.530844]  ? fput+0x13/0x20
[25372.530848]  ? do_writev+0x175/0x320
[25372.530856]  ? lockdep_hardirqs_off+0x1df/0x2d0
[25372.530861]  ? syscall_return_slowpath+0x66/0x9d0
[25372.530867]  ? do_syscall_64+0x8e/0xae0
[25372.530872]  ? entry_SYSCALL_64_after_hwframe+0x49/0xb3
[25372.530883]  __x64_sys_ioctl+0x73/0xb0
[25372.530890]  do_syscall_64+0x108/0xae0
[25372.530894]  ? switch_fpu_return+0x181/0x3e0
[25372.530899]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[25372.530905]  ? syscall_return_slowpath+0x9d0/0x9d0
[25372.530908]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[25372.530917]  ? trace_hardirqs_off_caller+0x28/0x1b0
[25372.530926]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[25372.530937]  entry_SYSCALL_64_after_hwframe+0x49/0xb3
