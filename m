Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E435E1B35FB
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 06:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbgDVELp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 00:11:45 -0400
Received: from mx2.suse.de ([195.135.220.15]:59988 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgDVELp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 00:11:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8CB67AC46;
        Wed, 22 Apr 2020 04:11:42 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     bigeasy@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        joel@joelfernandes.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, dave@stgolabs.net
Subject: [PATCH v3 -tip 0/5] kvm: Use rcuwait for vcpu blocking
Date:   Tue, 21 Apr 2020 21:07:34 -0700
Message-Id: <20200422040739.18601-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following is an updated revision of the kvm vcpu to rcuwait conversion[0],
following the work on completions using simple waitqueues.

Changes from v2:
  - new patch 3 which adds prepare_to_rcuwait and finish_rcu helpers.
  - fixed broken sleep and tracepoint semantics in patch 4. (Marc and Paolo)
  
This has only been run tested on x86 but compile tested on mips, powerpc
and arm32. 

This series applies on top of current -tip.

[0] https://lore.kernel.org/lkml/20200320085527.23861-3-dave@stgolabs.net/

Thanks!

Davidlohr Bueso (5):
  rcuwait: Fix stale wake call name in comment
  rcuwait: Let rcuwait_wake_up() return whether or not a task was awoken
  rcuwait: Introduce prepare_to and finish_rcuwait
  kvm: Replace vcpu->swait with rcuwait
  sched/swait: Reword some of the main description

 arch/mips/kvm/mips.c                  |  6 ++----
 arch/powerpc/include/asm/kvm_book3s.h |  2 +-
 arch/powerpc/include/asm/kvm_host.h   |  2 +-
 arch/powerpc/kvm/book3s_hv.c          | 22 ++++++++--------------
 arch/powerpc/kvm/powerpc.c            |  2 +-
 arch/x86/kvm/lapic.c                  |  2 +-
 include/linux/kvm_host.h              | 10 +++++-----
 include/linux/rcuwait.h               | 23 +++++++++++++++++------
 include/linux/swait.h                 | 23 +++++------------------
 kernel/exit.c                         |  9 ++++++---
 virt/kvm/arm/arch_timer.c             |  2 +-
 virt/kvm/arm/arm.c                    |  9 +++++----
 virt/kvm/async_pf.c                   |  3 +--
 virt/kvm/kvm_main.c                   | 19 +++++++++----------
 14 files changed, 63 insertions(+), 71 deletions(-)

-- 
2.16.4

