Return-Path: <kvm+bounces-62970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F3B7AC55CE1
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 06:25:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B3D364E25D5
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 05:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE462F3C3D;
	Thu, 13 Nov 2025 05:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oIotZ0Zm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C73219A89
	for <kvm@vger.kernel.org>; Thu, 13 Nov 2025 05:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763011503; cv=none; b=f9RVZzi1RXS9CUbOFqNXV/nSHbrcgfpWe2rthmEjc8HXbj2IRSjnwpW2aaqHmXb8jseCf2o3uzoGZHcgNqFsMs+NoHPnfJqelfQkBYS2o2AsnhTMMKoF6RbROamu1S1ThE3DzFGNWoTQsfDx5llOWkFXgn8HhLDcsAk1gAALh54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763011503; c=relaxed/simple;
	bh=JRpVSsu65muOPw+ZR6pM7QRh8sMT33lr34qzVyXY/os=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=OE3haGFRMYo7zNvAAMEN31BFUdf3udpkCxq1/UR8OK5GoylOEOyu/xDlAUis2XCu4F/33rqn71m8l93c9QYzTqoav36CKsTWCiBJojKogDUezMxgnbE7zsrIMVCnhsIld+W39yUfazPnyGdc5APRInqU2Lwdteh1Oqrf23aTKPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oIotZ0Zm; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-433795a17c1so22554085ab.2
        for <kvm@vger.kernel.org>; Wed, 12 Nov 2025 21:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763011500; x=1763616300; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ITLN6DrW4j9W1gRe4G0SjKiXKIkSq/9JXCq9e/dhlsU=;
        b=oIotZ0Zmc4l1Urzj7GBU4tH61lzIGODK17lVJI829OVJ95nQe/91NEh58fDDkXq/Ol
         9RUD8b6sm7hJH70M5+qtL2vH2O2zUBPruj59+y9WtuqoIrk7jfNcsHKX+3uXXQeAJI8n
         AZ83U1cgQ+Or74bdv2TIZlEWUnS6liarJ/tnCbDRAc+grcMB+/UQ9E0VlJInJGyhGk2a
         V/LgkTUzakjs843xQxhSOwcl/ARvV88bSa0hO5GizeKPrJ7ai3iZMRJMNlUX0goKFTa+
         08UMYlxZFqeLTwjz5xBf+TxOjzZbf8shThDJMK3zNRs5FGBdRuuINyhFJwqdZS8r3AiZ
         69ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763011500; x=1763616300;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ITLN6DrW4j9W1gRe4G0SjKiXKIkSq/9JXCq9e/dhlsU=;
        b=ihylQvzYPVJpJ2OpbMzymT2VUmSUYjZmxo0+JVEF2B0My6qIfb9x+RpOSJjyUD4LY5
         WXsiKKKYp1YvNysqvtKwF9cUsBaYdPeHfYdF3m2II0jhbmFG/h1JOJnp9yeajdMv5V9/
         uh/2DXW/7UTd70uAbTtt2XGzISoEImhI5t10+p56SACXIQKQ2Aql8mh6u8TychjE6yLx
         oRiFExs2RZe71cCe7DfyaLfCbqdSq8yLlUpiLQbTlWzQATN3pPkLg6x49o92r8sHHYJy
         YmdKDPaDya95jOsX/8Xjo6nHpl7QbUq6sEMxFtjc83XrVUS65aaQDydQVVLrTnEYGUxQ
         HV1Q==
X-Forwarded-Encrypted: i=1; AJvYcCUDUFNY/uXm7HtOfgT+UyF66QZyb43RLSI1TbYDCUNOhnuVSfdYI49LG+/nmtjB6nVFvPQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwbOQmYnyT3K3tB2jNlzvbI797wKvPSSsqoV/Oskm+Jg48ixuo/
	3NvPm2fcSydx0MsJhQ1oq28TK2s2mHDLHGYTXVfPinztTtoXicsrV6hD+14dM3Hqq8y/2azD00B
	F/+hz9wXdKQ==
X-Google-Smtp-Source: AGHT+IFL6UP4YmlKx250LyiOtTQeJ7J1ke7xQcOZuRjsBn2ACx0ONuYF1IJLK61YzRE922HtvlvNEGnRGSBI
X-Received: from jaa26.prod.google.com ([2002:a05:6638:ae1a:b0:5ad:7f49:aa05])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a92:c245:0:b0:433:78b8:943a
 with SMTP id e9e14a558f8ab-43473d15984mr90010315ab.10.1763011500033; Wed, 12
 Nov 2025 21:25:00 -0800 (PST)
Date: Thu, 13 Nov 2025 05:24:49 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251113052452.975081-1-rananta@google.com>
Subject: [PATCH 0/3] KVM: arm64: Reschedule as needed when destroying the
 stage-2 page-tables
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

When destroying a fully-mapped 128G VM abruptly, the following scheduler
warning is observed:

  sched: CPU 0 need_resched set for > 100018840 ns (100 ticks) without schedule
  CPU: 0 UID: 0 PID: 9617 Comm: kvm_page_table_ Tainted: G O 6.16.0-smp-DEV #3 NONE
  Tainted: [O]=OOT_MODULE
  Call trace:
      show_stack+0x20/0x38 (C)
      dump_stack_lvl+0x3c/0xb8
      dump_stack+0x18/0x30
      resched_latency_warn+0x7c/0x88
      sched_tick+0x1c4/0x268
      update_process_times+0xa8/0xd8
      tick_nohz_handler+0xc8/0x168
      __hrtimer_run_queues+0x11c/0x338
      hrtimer_interrupt+0x104/0x308
      arch_timer_handler_phys+0x40/0x58
      handle_percpu_devid_irq+0x8c/0x1b0
      generic_handle_domain_irq+0x48/0x78
      gic_handle_irq+0x1b8/0x408
      call_on_irq_stack+0x24/0x30
      do_interrupt_handler+0x54/0x78
      el1_interrupt+0x44/0x88
      el1h_64_irq_handler+0x18/0x28
      el1h_64_irq+0x84/0x88
      stage2_free_walker+0x30/0xa0 (P)
      __kvm_pgtable_walk+0x11c/0x258
      __kvm_pgtable_walk+0x180/0x258
      __kvm_pgtable_walk+0x180/0x258
      __kvm_pgtable_walk+0x180/0x258
      kvm_pgtable_walk+0xc4/0x140
      kvm_pgtable_stage2_destroy+0x5c/0xf0
      kvm_free_stage2_pgd+0x6c/0xe8
      kvm_uninit_stage2_mmu+0x24/0x48
      kvm_arch_flush_shadow_all+0x80/0xa0
      kvm_mmu_notifier_release+0x38/0x78
      __mmu_notifier_release+0x15c/0x250
      exit_mmap+0x68/0x400
      __mmput+0x38/0x1c8
      mmput+0x30/0x68
      exit_mm+0xd4/0x198
      do_exit+0x1a4/0xb00
      do_group_exit+0x8c/0x120
      get_signal+0x6d4/0x778
      do_signal+0x90/0x718
      do_notify_resume+0x70/0x170
      el0_svc+0x74/0xd8
      el0t_64_sync_handler+0x60/0xc8
      el0t_64_sync+0x1b0/0x1b8

The host kernel was running with CONFIG_PREEMPT_NONE=y, and since the
page-table walk operation takes considerable amount of time for a VM
with such a large number of PTEs mapped, the warning is seen.

To mitigate this, split the walk into smaller ranges, by checking for
cond_resched() between each range. Since the path is executed during
VM destruction, after the page-table structure is unlinked from the
KVM MMU, relying on cond_resched_rwlock_write() isn't necessary.

Patch-1 kills the assumption that the page-table hierarchy under the
table is free (in stage2_free_walker()). Instead, drop and clear the
references only on empty tables.

Patch-2 splits the kvm_pgtable_stage2_destroy() function into separate
'walk' and 'free PGD' parts.

Patch-3 leverages the split and performs the walk periodically over
smaller ranges and calls cond_resched() between them.

The series was originally posted and merged [1], but was later reverted
due to syzkaller catching a UAF bug [2]. This series fixes the issue, and
the original need_resched warning is addressed.

[1]: https://lore.kernel.org/all/175582091313.1266576.4329884314263043118.b4-ty@linux.dev/
[2]: https://lore.kernel.org/all/20250910180930.3679473-1-oliver.upton@linux.dev/ 

Oliver Upton (1):
  KVM: arm64: Only drop references on empty tables in stage2_free_walker

Raghavendra Rao Ananta (2):
  KVM: arm64: Split kvm_pgtable_stage2_destroy()
  KVM: arm64: Reschedule as needed when destroying the stage-2
    page-tables

 arch/arm64/include/asm/kvm_pgtable.h | 30 +++++++++++++
 arch/arm64/include/asm/kvm_pkvm.h    |  4 +-
 arch/arm64/kvm/hyp/pgtable.c         | 63 +++++++++++++++++++++++-----
 arch/arm64/kvm/mmu.c                 | 36 +++++++++++++++-
 arch/arm64/kvm/pkvm.c                | 11 ++++-
 5 files changed, 129 insertions(+), 15 deletions(-)


base-commit: dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa
-- 
2.51.2.1041.gc1ab5b90ca-goog


