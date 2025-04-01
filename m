Return-Path: <kvm+bounces-42403-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF799A78374
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 22:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E23E188ECE9
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 20:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8969211711;
	Tue,  1 Apr 2025 20:46:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GQK+h8Gf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B9C1E0E0C
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 20:46:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743540410; cv=none; b=Fam+OGNalNp8CFD7QEuI+7MTfJ4rx3Kz84Y3UKuF8ZDGkjCeezUc3+Gn2UPAhjDx4ImLspPUyHIVBMwqmmRbYPCmHv8uZOaCeNRuxCvjAsjTMn1uDcatyfM0ToSXqGFUqa5nnEBGk2YrRyPDpa/rYKHBaWcA5ir3u2QYnmtiBk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743540410; c=relaxed/simple;
	bh=HguwUdRio9Y+H4KEWTlofD2YbvLXz+Jv8pweJItO0h0=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Ze9I+qMO21xrKHa2EriU0zsB754R+Dfer3P8+TYvRKnT0UdbbabI7wLBEahqEK8Lp29wy/DiZ3nnLtUwjz/EsnSCeqSTuFoTFtG1SvHlr6LKZ321WumzoQ3DQN+iZammnus96uGjfm82SdmjKB7g7eBYj8lZdCH7FdOLYYJF2a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GQK+h8Gf; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff4b130bb2so10774877a91.0
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 13:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743540408; x=1744145208; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MHpp6KQzpe5YT4W+dH4Yie0ZZwtXZwZK/jMYGNOWeg=;
        b=GQK+h8GfJAFn38LojnQONdRXGomd60Wn7D6+JLNdev+VT7Cqc0KAXRfuMQrcomWoPl
         EQM0grp80jTV0AtTPUGhI/6oo+d09w9oVALMgWF1i83/1C6FAIATHjAspWy+C6dRFmXD
         S2t1BKGH1Ta+H4YJOrTpEsgKTtu0veZqb3Qc5WWnni2m9kmQH9PECJ1C4qhkElsldDgU
         r4C7+EFMmzgtFVLhScWYU9CjBoMTiGrKyv6Gu55pfOYNJVJSdRcOSV/rDG9wado3LWyE
         Nty3LXCl868mFn61yuN0m5KcZ9+rW0iYU1kwPXIYqUPWXdgtR3RvXJUGXQLaUN7MUEQg
         gO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743540408; x=1744145208;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4MHpp6KQzpe5YT4W+dH4Yie0ZZwtXZwZK/jMYGNOWeg=;
        b=We620AZgrt/qt7LQjSr/gb9/zku24OxbjBzF/38bdcv8PWQgXOpTPqlCzKF7lNciLN
         bUh3DQ2IoRrPPgm7PiYiGM3jugkqMeJFsAz8avXxSFuM1CHsQUPI8yRbu6E/ztiGrwCE
         9ZThInje0qzmPBP2TOoqlDkxCoCr0D4JMptMxWnpUej/nCjrxaQniQgPOlz3inybxEdh
         GvDU2kS7NzHs4Kqv534DzzpRI8zVxhzel3V8HqtR5DTLl2U8vPFuAwN24mRFqrwTxM2z
         Cx8KVU2UJk905OzVR47sm3st5NHW2Q6Z4YkgOavMu1o962vmJ3LbJJoe4tp+P2ZjJkTD
         OhBQ==
X-Gm-Message-State: AOJu0YxtmVJ3+fJnpap5xXYc3vpQR1dOvrfzxYz9GcnLNrXryGc7kZrz
	YhClztvvViL4ftF9KAlojgHd1ETkPkT4rFZUkqvxMBMD/P4YGw3rH+Nf7WdzjZkN5+hj2bM1y8l
	KyA==
X-Google-Smtp-Source: AGHT+IHAsBNwKlX/xhMaBjKbVn5TdC1aApjFgyzFqGqs5j7Zym3fz03OLRDWDWGVCV86OCx3ObyBflUf12E=
X-Received: from pfbls13.prod.google.com ([2002:a05:6a00:740d:b0:737:5ee8:8403])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d51:b0:739:50c0:b3fe
 with SMTP id d2e1a72fcca58-73980380c52mr22298727b3a.8.1743540407837; Tue, 01
 Apr 2025 13:46:47 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  1 Apr 2025 13:44:12 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250401204425.904001-1-seanjc@google.com>
Subject: [PATCH 00/12] KVM: Make irqfd registration globally unique
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-riscv@lists.infradead.org, David Matlack <dmatlack@google.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Content-Type: text/plain; charset="UTF-8"

Xen folks, I Cc'd y'all because "sched/wait: Drop WQ_FLAG_EXCLUSIVE from
add_wait_queue_priority()" changes the behavior of add_wait_queue_priority(),
which Xen's privcmd uses.  Unless I've misread the code, the Xen behavior
isn't actually affected, but extra eyeballs and any testing you can provide
would be much appreciated.


Rework KVM's irqfd registration to require that an eventfd is bound to at
most one irqfd throughout the entire system.  KVM currently disallows
binding an eventfd to multiple irqfds for a single VM, but doesn't reject
attempts to bind an eventfd to multiple VMs.

This is obvious an ABI change, but I'm fairly confident that it won't
break userspace, because binding an eventfd to multiple irqfds hasn't
truly worked since commit e8dbf19508a1 ("kvm/eventfd: Use priority waitqueue
to catch events before userspace").  A somewhat undocumented, and perhaps
even unintentional, side effect of suppressing eventfd notifications for
userspace is that the priority+exclusive behavior also suppresses eventfd
notifications for any subsequent waiters, even if they are priority waiters.
I.e. only the first VM with an irqfd+eventfd binding will get notifications.

And for IRQ bypass, a.k.a. device posted interrupts, globally unique
bindings are a hard requirement (at least on x86; I assume other archs are
the same).  KVM and the IRQ bypass manager kinda sorta handle this, but in
the absolute worst way possible (IMO).  Instead of surfacing an error to
userspace, KVM silently ignores IRQ bypass registration errors.

The motivation for this series is to harden against userspace goofs.  AFAIK,
we (Google) have never actually had a bug where userspace tries to assign
an eventfd to multiple VMs, but the possibility has come up in more than one
bug investigation (our intra-host, a.k.a. copyless, migration scheme
transfers eventfds from the old to the new VM when updating the host VMM).

Sean Christopherson (12):
  KVM: Use a local struct to do the initial vfs_poll() on an irqfd
  KVM: Acquire SCRU lock outside of irqfds.lock during assignment
  KVM: Initialize irqfd waitqueue callback when adding to the queue
  KVM: Add irqfd to KVM's list via the vfs_poll() callback
  KVM: Add irqfd to eventfd's waitqueue while holding irqfds.lock
  sched/wait: Add a waitqueue helper for fully exclusive priority
    waiters
  KVM: Disallow binding multiple irqfds to an eventfd with a priority
    waiter
  sched/wait: Drop WQ_FLAG_EXCLUSIVE from add_wait_queue_priority()
  KVM: Drop sanity check that per-VM list of irqfds is unique
  KVM: selftests: Assert that eventfd() succeeds in Xen shinfo test
  KVM: selftests: Add utilities to create eventfds and do KVM_IRQFD
  KVM: selftests: Add a KVM_IRQFD test to verify uniqueness requirements

 include/linux/kvm_irqfd.h                     |   1 -
 include/linux/wait.h                          |   2 +
 kernel/sched/wait.c                           |  24 +++-
 tools/testing/selftests/kvm/Makefile.kvm      |   4 +
 tools/testing/selftests/kvm/arm64/vgic_irq.c  |  12 +-
 .../testing/selftests/kvm/include/kvm_util.h  |  40 ++++++
 tools/testing/selftests/kvm/irqfd_test.c      | 130 ++++++++++++++++++
 .../selftests/kvm/x86/xen_shinfo_test.c       |  21 +--
 virt/kvm/eventfd.c                            | 130 +++++++++++++-----
 9 files changed, 299 insertions(+), 65 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/irqfd_test.c


base-commit: 782f9feaa9517caf33186dcdd6b50a8f770ed29b
-- 
2.49.0.504.g3bcea36a83-goog


