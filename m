Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B2D7A50BB
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbjIRRNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231394AbjIRRNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:13:41 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C4A90
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:13:35 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4009fdc224dso3125e9.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695057213; x=1695662013; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8NCRoQtasHBhaxbBJof29twbnK3J3FpNXqEPensTrQU=;
        b=k+xVY/UYy34DW9Sij4WkPswS8rzDpog6MBsUzSw+XHVXVDUQ4ShslsRo3NJ1owRpYU
         eA1EcvRvvr+rj/yCy93Zs+rmnI3BzXxb0GEHUmgDOSMd8n3tTXvGOdpF6xEIugIzlCMV
         FFCEpZp8dHFCliICJKDp7RmWRNPJ6SWke7WGY8EXu9q/sV/lsBqtHQLB5y2xRp6Vb83M
         kTzV4O1im60vHLHICOnak8HTMrp0PhOeOBJrKoR+Ufm4knAOkk7D6a3hbMNW7YxWxy+C
         q1XNixjC3/XlEOaKtPXiiMGhSlTXrBtqEZB+6RZMWUMZ4gi9g2NLUJuxRmNbLEeLGzfL
         V1fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695057213; x=1695662013;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8NCRoQtasHBhaxbBJof29twbnK3J3FpNXqEPensTrQU=;
        b=OPEu2ME/YWy7+yw5QVf6Gq6+PnK5oFnhDJjKVWcwHncOJMUGLm6fDzerMNjsvUFqbr
         pNqK++hXPuZFvtRW1Oix70kKt+oVirndR9emZpyQmSNts2YSEBnAA/WS9J/SRxhy727o
         F7Jko5Q0rsd2ffI2QSoHlPMLMk67WuBTL+llNZSU3atIQNaKdfyelGZd1BT+nawmbjDj
         Au/dkXZ8er5E1sDhSSpLW5vcjV8AYJwozrzTLdZq4kFZvlt+LHose35C/WrN/8Jm3f1t
         2X6Tkfmpv1+40ks1rpeagdvIlXT7aPatsczZFepNUSkWZZZ7YLlnh6Cy3zeu3CeOo2MF
         TqIg==
X-Gm-Message-State: AOJu0YwftOhCDYVUB/HCuUHUQneuSvzO8HJ5qGjDW3FyVQWPvTb/6PAJ
        lRdKG73a23Nr1+/7NVjuuLOj5zK7vophIOUbx5/KAw==
X-Google-Smtp-Source: AGHT+IEkRFchjpZqPNvI+IkS94xt8vvX5NVo36F/WMbxfNTZHxp7itGvCJT+AIT8wUnE3U2ITQL++aALeT4I/3XmYoI=
X-Received: by 2002:a05:600c:3acd:b0:400:c6de:6a20 with SMTP id
 d13-20020a05600c3acd00b00400c6de6a20mr181501wms.3.1695057213310; Mon, 18 Sep
 2023 10:13:33 -0700 (PDT)
MIME-Version: 1.0
From:   Jann Horn <jannh@google.com>
Date:   Mon, 18 Sep 2023 19:12:56 +0200
Message-ID: <CAG48ez0YBOUGnj+N_MBp2WCvp0BLk1o7n6uSH2nrj1z-qgf+0A@mail.gmail.com>
Subject: KVM nonblocking MMU notifier with KVM_GUEST_USES_PFN looks racy [but
 is currently unused]
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Michal Hocko <mhocko@suse.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

I haven't tested this and might be missing something, but I think that
the MMU notifier for KVM_GUEST_USES_PFN pfncache is currently a bit
broken. Except that nothing seems to actually use KVM_GUEST_USES_PFN,
so currently it's not actually a problem?

gfn_to_pfn_cache_invalidate_start() contains the following:

    /*
     * If the OOM reaper is active, then all vCPUs should have
     * been stopped already, so perform the request without
     * KVM_REQUEST_WAIT and be sad if any needed to be IPI'd.
     */
    if (!may_block)
      req &= ~KVM_REQUEST_WAIT;

    called = kvm_make_vcpus_request_mask(kvm, req, vcpu_bitmap);

    WARN_ON_ONCE(called && !may_block);

The comment explains that we rely on OOM reaping only happening when a
process is sufficiently far into being stopped that it is no longer
executing vCPUs, but from what I can tell, that's not what the caller
actually guarantees. Especially on the path from the
process_mrelease() syscall (if we're dealing with a process whose mm
is not shared with other processes), we only check that the target
process has SIGNAL_GROUP_EXIT set. From what I can tell, that does
imply that delivery of a fatal signal has begun, but doesn't even
imply that the CPU running the target process has been IPI'd, let
alone that the target process has died or anything like that.

But I also don't see any reason why
gfn_to_pfn_cache_invalidate_start() actually has to do anything
special for non-blocking invalidation - from what I can tell, nothing
in there can block, basically everything runs with preemption
disabled. The first half of the function holds a spinlock; the second
half is basically a call to kvm_make_vcpus_request_mask(), which
disables preemption across the whole function with
get_cpu()/put_cpu(). A synchronous IPI spins until the IPI has been
acked but that doesn't count as sleeping. (And the rest of the OOM
reaping code will do stuff like synchronous IPIs for its TLB flushes,
too.)

So maybe you/I can just rip out the special-casing of nonblocking mode
from gfn_to_pfn_cache_invalidate_start() to fix this?

Relevant call paths for the theoretical race:

sys_kill
  prepare_kill_siginfo
  kill_something_info
    kill_proc_info
      rcu_read_lock
      kill_pid_info
        rcu_read_lock
        group_send_sig_info [PIDTYPE_TGID]
          do_send_sig_info
            lock_task_sighand [task->sighand->siglock]
            send_signal_locked
              __send_signal_locked
                prepare_signal
                legacy_queue
                signalfd_notify
                sigaddset(&pending->signal, sig)
                complete_signal
                  signal->flags = SIGNAL_GROUP_EXIT [mrelease will
work starting here]
                  for each thread:
                    sigaddset(&t->pending.signal, SIGKILL)
                    signal_wake_up [IPI happens here]
            unlock_task_sighand [task->sighand->siglock]
        rcu_read_unlock
      rcu_read_unlock

sys_process_mrelease
  find_lock_task_mm
    spin_lock(&p->alloc_lock)
  task_will_free_mem
    SIGNAL_GROUP_EXIT suffices
    PF_EXITING suffices if singlethreaded?
  task_unlock
  mmap_read_lock_killable
  __oom_reap_task_mm
    for each private non-PFNMAP/MIXED VMA:
      tlb_gather_mmu
      mmu_notifier_invalidate_range_start_nonblock
        __mmu_notifier_invalidate_range_start
          mn_hlist_invalidate_range_start
            kvm_mmu_notifier_invalidate_range_start [as
ops->invalidate_range_start]
              gfn_to_pfn_cache_invalidate_start
                [loop over gfn_to_pfn_cache instances]
                  if overlap and KVM_GUEST_USES_PFN [UNUSED]: evict_vcpus=true
                [if evict_vcpus]
                  kvm_make_vcpus_request_mask
              __kvm_handle_hva_range
      unmap_page_range
      mmu_notifier_invalidate_range_end
      tlb_finish_mmu
  mmap_read_unlock
