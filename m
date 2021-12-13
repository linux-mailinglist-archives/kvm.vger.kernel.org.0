Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 771BC472DAA
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 14:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbhLMNoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 08:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbhLMNoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 08:44:07 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079B5C061574
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 05:44:07 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id z18so18501292iof.5
        for <kvm@vger.kernel.org>; Mon, 13 Dec 2021 05:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OoK814t0mZyo5uPR3FR5PU/fdoX0t0s6jYldodX1yd8=;
        b=NYDfIAPPje62p+pTSMofVq3fOgVYtqdE0RSvLtq686Uaa7nKrUwrOAhJ4iF+Bj9cVo
         Rooh1KqRZPOkn9YzfEogLpfu9sTOJmzdbREN9YsL6yzoqfs53Lt+T+ZMB9qUZL6XSeCZ
         F9GQlfWUIEg5ySLiOrDNsciYJ3Q8EahunT4Ks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OoK814t0mZyo5uPR3FR5PU/fdoX0t0s6jYldodX1yd8=;
        b=VQJLNb28io+RzZL+aS6pvLMJI184TwRCi6SpACmDii5thIsRGtV1Qv9u//AJub4fEI
         NAT5W9nyc+lqsCaYrWDGSJB94mLq5RoI+KdqidFpkgMboWRN87TQkGm5EJl3XOHFwgll
         A/0e2yxa7/9Jq6yOVaeb0gb36vosRuzDpbWHRhB5ZqlyGYqWJ6BK6CBBGBKCWJ2tBjRt
         jCCZ+FXXNP8V74QhHFhcuL6YNtODE0YQMglQsvLHyWUNlAhGS6N88rbilXucvBDr9l+5
         94t1KOhjm/+o8nWLhdES4ydrHttxdhq/q10XcKC/Zv4XGCKR3r54eqHI1S9Z9iQSbwGi
         gWuQ==
X-Gm-Message-State: AOAM530HYoQRP6Z3PrMZe6gHsiNj2NmnHKtW4Ya+QZ1lh9deqrcic/XK
        eiFOnOH3mVoAm60cvVmhxDt7zqHbUatP/75Oa8P0Zw==
X-Google-Smtp-Source: ABdhPJwOpIKAWc/1RDhqRp35Miqinw+GNZbVy/Z/P6yo2rQI1QNYFYLVxkiex1sPzXGZOgowJ9EQZFobm/UHtexiYFg=
X-Received: by 2002:a5e:8514:: with SMTP id i20mr32223236ioj.95.1639403046172;
 Mon, 13 Dec 2021 05:44:06 -0800 (PST)
MIME-Version: 1.0
References: <20211213112514.78552-1-pbonzini@redhat.com>
In-Reply-To: <20211213112514.78552-1-pbonzini@redhat.com>
From:   Ignat Korchagin <ignat@cloudflare.com>
Date:   Mon, 13 Dec 2021 13:43:55 +0000
Message-ID: <CALrw=nEM6LEAD8LA1Bd15=8BK=TFwwwAMKy_DWRrDkD=r+1Tqg@mail.gmail.com>
Subject: Re: [PATCH 0/2] KVM: x86: Fix dangling page reference in TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>, bgardon@google.com,
        dmatlack@google.com, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unfortunately, this patchset does not fix the original issue reported in [1].

Still got the following stacktrace on the 5th run of the visorg

[   65.777066][ T2987] ------------[ cut here ]------------
[   65.788832][ T2987] WARNING: CPU: 2 PID: 2987 at
arch/x86/kvm/../../../virt/kvm/kvm_main.c:173
kvm_is_zone_device_pfn.part.0+0x9e/0xd0
[   65.813145][ T2987] Modules linked in:
[   65.821414][ T2987] CPU: 2 PID: 2987 Comm: exe Not tainted 5.16.0-rc4+ #23
[   65.835836][ T2987] Hardware name: QEMU Standard PC (Q35 + ICH9,
2009), BIOS 0.0.0 02/06/2015
[   65.854804][ T2987] RIP: 0010:kvm_is_zone_device_pfn.part.0+0x9e/0xd0
[   65.867500][ T2987] Code: 00 00 00 00 fc ff df 48 c1 ea 03 0f b6 14
02 48 89 e8 83 e0 07 83 c0 03 38 d0 7c 04 84 d2 75 0f 8b 43 34 85 c0
74 03 5b 5d c3 <0f> 0b 5b 5d c3 48 89 ef e8 d5 36 9e 00 eb e7 e8 de 36
9e 00 eb 9b
[   65.909924][ T2987] RSP: 0018:ffff888113e47288 EFLAGS: 00010246
[   65.923944][ T2987] RAX: 0000000000000000 RBX: ffffea0004969880
RCX: ffffffff9087289e
[   65.942453][ T2987] RDX: 0000000000000000 RSI: 0000000000000004
RDI: ffffea00049698b4
[   65.960703][ T2987] RBP: ffffea00049698b4 R08: 0000000000000000
R09: ffffea00049698b7
[   65.978929][ T2987] R10: fffff9400092d316 R11: 0000000008000000
R12: ffff88827ffda000
[   65.996858][ T2987] R13: 0600000125a62b77 R14: 0000000000000001
R15: 0000000000000001
[   66.014646][ T2987] FS:  0000000000000000(0000)
GS:ffff88822d300000(0000) knlGS:0000000000000000
[   66.035733][ T2987] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   66.050672][ T2987] CR2: 00007f40eae98008 CR3: 000000026c63e005
CR4: 0000000000172ee0
[   66.068551][ T2987] Call Trace:
[   66.076686][ T2987]  <TASK>
[   66.084543][ T2987]  kvm_set_pfn_dirty+0x120/0x1d0
[   66.095423][ T2987]  __handle_changed_spte+0x9e7/0xed0
[   66.107841][ T2987]  ? alloc_tdp_mmu_page+0x470/0x470
[   66.121447][ T2987]  __handle_changed_spte+0x6d2/0xed0
[   66.135648][ T2987]  ? alloc_tdp_mmu_page+0x470/0x470
[   66.148376][ T2987]  __handle_changed_spte+0x6d2/0xed0
[   66.160600][ T2987]  ? alloc_tdp_mmu_page+0x470/0x470
[   66.172627][ T2987]  __handle_changed_spte+0x6d2/0xed0
[   66.184815][ T2987]  ? alloc_tdp_mmu_page+0x470/0x470
[   66.196732][ T2987]  ? lock_release+0x700/0x700
[   66.208483][ T2987]  __tdp_mmu_set_spte+0x18c/0x9d0
[   66.223852][ T2987]  ? tdp_iter_next+0x205/0x640
[   66.235493][ T2987]  ? tdp_iter_start+0x26d/0x3f0
[   66.246130][ T2987]  zap_gfn_range+0x8b5/0x990
[   66.256505][ T2987]  ? zap_collapsible_spte_range+0x800/0x800
[   66.269919][ T2987]  ? lock_release+0x3b7/0x700
[   66.279630][ T2987]  ? kvm_tdp_mmu_put_root+0x1b6/0x2d0
[   66.292582][ T2987]  ? rwlock_bug.part.0+0x90/0x90
[   66.303611][ T2987]  kvm_tdp_mmu_put_root+0x1d1/0x2d0
[   66.315943][ T2987]  mmu_free_root_page+0x219/0x2c0
[   66.327581][ T2987]  ? ept_invlpg+0x740/0x740
[   66.337448][ T2987]  ? kvm_vcpu_write_tsc_offset+0xfd/0x370
[   66.350101][ T2987]  kvm_mmu_free_roots+0x275/0x490
[   66.361490][ T2987]  ? mmu_free_root_page+0x2c0/0x2c0
[   66.373656][ T2987]  ? do_raw_spin_unlock+0x54/0x220
[   66.385622][ T2987]  ? _raw_spin_unlock+0x29/0x40
[   66.396843][ T2987]  kvm_mmu_unload+0x1c/0xa0
[   66.407419][ T2987]  kvm_arch_destroy_vm+0x1fe/0x5e0
[   66.419178][ T2987]  ? mmu_notifier_unregister+0x276/0x330
[   66.431782][ T2987]  kvm_put_kvm+0x3f9/0xa70
[   66.442694][ T2987]  kvm_vcpu_release+0x4e/0x70
[   66.453070][ T2987]  __fput+0x204/0x8d0
[   66.462673][ T2987]  task_work_run+0xce/0x170
[   66.473106][ T2987]  do_exit+0xa37/0x23e0
[   66.482760][ T2987]  ? static_obj+0x61/0xc0
[   66.492643][ T2987]  ? lock_release+0x3b7/0x700
[   66.503069][ T2987]  ? mm_update_next_owner+0x6d0/0x6d0
[   66.514934][ T2987]  ? lock_downgrade+0x6d0/0x6d0
[   66.527491][ T2987]  ? do_raw_spin_lock+0x12b/0x270
[   66.538734][ T2987]  ? rwlock_bug.part.0+0x90/0x90
[   66.549815][ T2987]  do_group_exit+0xec/0x2a0
[   66.560548][ T2987]  get_signal+0x3e8/0x1f50
[   66.570826][ T2987]  arch_do_signal_or_restart+0x244/0x1820
[   66.583863][ T2987]  ? migrate_enable+0x1d6/0x240
[   66.594782][ T2987]  ? do_futex+0x229/0x340
[   66.604801][ T2987]  ? get_sigframe_size+0x10/0x10
[   66.616460][ T2987]  ? __seccomp_filter+0x19d/0xd90
[   66.627524][ T2987]  ? __x64_sys_futex+0x181/0x420
[   66.640458][ T2987]  ? do_futex+0x340/0x340
[   66.650659][ T2987]  exit_to_user_mode_prepare+0x12c/0x1c0
[   66.663419][ T2987]  syscall_exit_to_user_mode+0x19/0x50
[   66.675965][ T2987]  do_syscall_64+0x4d/0x90
[   66.685580][ T2987]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[   66.699743][ T2987] RIP: 0033:0x474703
[   66.708120][ T2987] Code: Unable to access opcode bytes at RIP 0x4746d9.
[   66.721675][ T2987] RSP: 002b:000000c0002f3d28 EFLAGS: 00000286
ORIG_RAX: 00000000000000ca
[   66.737633][ T2987] RAX: fffffffffffffe00 RBX: 000000c000308c00
RCX: 0000000000474703
[   66.752382][ T2987] RDX: 0000000000000000 RSI: 0000000000000080
RDI: 000000c000308d50
[   66.767496][ T2987] RBP: 000000c0002f3d70 R08: 0000000000000000
R09: 0000000000000000
[   66.782643][ T2987] R10: 0000000000000000 R11: 0000000000000286
R12: 0000000000000000
[   66.797659][ T2987] R13: 0000000000000000 R14: ffffffffffffffff
R15: 000000c00027b6c0
[   66.813540][ T2987]  </TASK>
[   66.819823][ T2987] irq event stamp: 17803
[   66.827863][ T2987] hardirqs last  enabled at (17813):
[<ffffffff90d26642>] __up_console_sem+0x52/0x60
[   66.845094][ T2987] hardirqs last disabled at (17822):
[<ffffffff90d26627>] __up_console_sem+0x37/0x60
[   66.862747][ T2987] softirqs last  enabled at (17702):
[<ffffffff90bd9903>] __irq_exit_rcu+0x113/0x170
[   66.880146][ T2987] softirqs last disabled at (17697):
[<ffffffff90bd9903>] __irq_exit_rcu+0x113/0x170
[   66.897521][ T2987] ---[ end trace 552e9049bda0ba46 ]---
[  442.873226][    C1] perf: interrupt took too long (4761 > 2500),
lowering kernel.perf_event_max_sample_rate to 42000

The only difference I noticed is the presence of __tdp_mmu_set_spte
between zap_gfn_range and __handle_changed_spte, which is absent from
the original stacktrace.

[1]: https://marc.info/?l=kvm&m=163822397323141&w=2

On Mon, Dec 13, 2021 at 11:25 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> kvm_tdp_mmu_zap_all is intended to visit all roots and zap their page
> tables, which flushes the accessed and dirty bits out to the Linux
> "struct page"s.  Missing some of the roots has catastrophic effects,
> because kvm_tdp_mmu_zap_all is called when the MMU notifier is being
> removed and any PTEs left behind might become dangling by the time
> kvm-arch_destroy_vm tears down the roots for good.
>
> Unfortunately that is exactly what kvm_tdp_mmu_zap_all is doing: it
> visits all roots via for_each_tdp_mmu_root_yield_safe, which in turn
> uses kvm_tdp_mmu_get_root to skip invalid roots.  If the current root is
> invalid at the time of kvm_tdp_mmu_zap_all, its page tables will remain
> in place but will later be zapped during kvm_arch_destroy_vm.
>
> To fix this, ensure that kvm_tdp_mmu_zap_all goes over all
> roots, including the invalid ones.  The easiest way to do so is for
> kvm_tdp_mmu_zap_all to do the same as kvm_mmu_zap_all_fast: invalidate
> all roots, and then zap the invalid roots.  The only difference is that
> there is no need to go through tdp_mmu_zap_spte_atomic.
>
> Paolo
>
> Paolo Bonzini (2):
>   KVM: x86: allow kvm_tdp_mmu_zap_invalidated_roots with write-locked
>     mmu_lock
>   KVM: x86: zap invalid roots in kvm_tdp_mmu_zap_all
>
>  arch/x86/kvm/mmu/mmu.c     |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c | 42 ++++++++++++++++++++------------------
>  arch/x86/kvm/mmu/tdp_mmu.h |  2 +-
>  3 files changed, 24 insertions(+), 22 deletions(-)
>
> --
> 2.31.1
>
