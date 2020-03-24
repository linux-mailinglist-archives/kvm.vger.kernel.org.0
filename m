Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB22190491
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 05:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725935AbgCXEqH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 00:46:07 -0400
Received: from mx2.suse.de ([195.135.220.15]:39304 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgCXEqH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 00:46:07 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id EE759AE1C;
        Tue, 24 Mar 2020 04:46:04 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     bigeasy@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dave@stgolabs.net
Subject: [PATCH -tip 0/4] kvm: Use rcuwait for vcpu blocking
Date:   Mon, 23 Mar 2020 21:44:49 -0700
Message-Id: <20200324044453.15733-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The following is an updated revision of the kvm vcpu to rcuwait conversion[0],
following the work on completions using simple waitqueues.

Changes from then:
  - patch 2: Make rcuwait_wake_up() propagate the return value from
    wake_up_process - Sebastian and Peter.

  - patch 3:
      o Added mips changes I missed.
      o Fixed broken compilation on power, adding the vcore bits that
        kvm-hv uses (a vcore blocking when all vcpus are blocked) - Paolo.
      o Use TASK_IDLE instead of TASK_INTERRUPTIBLE - Peter.

  - patch 4: fixed swait function name typo.

This has only been run tested on x86 but compile tested on mips, powerpc
and arm32. 

This series applies on top of current -tip, which has the required rcuwait
api extension.

[0] https://lore.kernel.org/lkml/20200320085527.23861-3-dave@stgolabs.net/

Thanks!

Davidlohr Bueso (4):
  rcuwait: Fix stale wake call name in comment
  rcuwait: Let rcuwait_wake_up() return whether or not a task was awoken
  kvm: Replace vcpu->swait with rcuwait
  sched/swait: Reword some of the main description

 arch/mips/kvm/mips.c                  |  6 ++----
 arch/powerpc/include/asm/kvm_book3s.h |  2 +-
 arch/powerpc/include/asm/kvm_host.h   |  2 +-
 arch/powerpc/kvm/book3s_hv.c          | 22 ++++++++--------------
 arch/powerpc/kvm/powerpc.c            |  2 +-
 arch/x86/kvm/lapic.c                  |  2 +-
 include/linux/kvm_host.h              | 10 +++++-----
 include/linux/rcuwait.h               |  2 +-
 include/linux/swait.h                 | 23 +++++------------------
 kernel/exit.c                         |  9 ++++++---
 virt/kvm/arm/arch_timer.c             |  2 +-
 virt/kvm/arm/arm.c                    |  9 +++++----
 virt/kvm/async_pf.c                   |  3 +--
 virt/kvm/kvm_main.c                   | 31 +++++++++++--------------------
 14 files changed, 49 insertions(+), 76 deletions(-)

--
2.16.4

