Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C037C1B6D80
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 07:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgDXFwT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 01:52:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:36982 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725554AbgDXFwT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 01:52:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 801EBAD71;
        Fri, 24 Apr 2020 05:52:16 +0000 (UTC)
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     tglx@linutronix.de, pbonzini@redhat.com
Cc:     peterz@infradead.org, maz@kernel.org, bigeasy@linutronix.de,
        rostedt@goodmis.org, torvalds@linux-foundation.org,
        will@kernel.org, joel@joelfernandes.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dave@stgolabs.net
Subject: [PATCH v4 0/5] kvm: Use rcuwait for vcpu blocking
Date:   Thu, 23 Apr 2020 22:48:32 -0700
Message-Id: <20200424054837.5138-1-dave@stgolabs.net>
X-Mailer: git-send-email 2.16.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

The following is an updated (and hopefully final) revision of the kvm
vcpu to rcuwait conversion[0], following the work on completions using
simple waitqueues.

Patches 1-4 level up the rcuwait api with waitqueues.
Patch 5 converts kvm to use rcuwait.

Changes from v3:
  - picked up maz and peterz's acks for routing via kvm tree.
  - added new patch 4/5 which introduces rcuwait_active. This is to avoid
    directly calling rcu_dereference() to peek at the wait->task.
  - fixed breakage for arm in patch 4/5.
  - removed previous patch 5/5 which updates swait doc as peterz will
    keep it.

Changes from v2:
  - new patch 3 which adds prepare_to_rcuwait and finish_rcuwait helpers.
  - fixed broken sleep and tracepoint semantics in patch 4. (Marc and Paolo)
  
This has only been run tested on x86 but compile tested on mips, powerpc
and arm. It passes all tests from kvm-unit-tests[1].

This series applies on top of current kvm and tip trees.
Please consider for v5.8.

[0] https://lore.kernel.org/lkml/20200320085527.23861-3-dave@stgolabs.net/
[1] git://git.kernel.org/pub/scm/virt/kvm/kvm-unit-tests.git

Thanks!

Davidlohr Bueso (5):
  rcuwait: Fix stale wake call name in comment
  rcuwait: Let rcuwait_wake_up() return whether or not a task was awoken
  rcuwait: Introduce prepare_to and finish_rcuwait
  rcuwait: Introduce rcuwait_active()
  kvm: Replace vcpu->swait with rcuwait

 arch/mips/kvm/mips.c                  |  6 ++----
 arch/powerpc/include/asm/kvm_book3s.h |  2 +-
 arch/powerpc/include/asm/kvm_host.h   |  2 +-
 arch/powerpc/kvm/book3s_hv.c          | 22 ++++++++--------------
 arch/powerpc/kvm/powerpc.c            |  2 +-
 arch/x86/kvm/lapic.c                  |  2 +-
 include/linux/kvm_host.h              | 10 +++++-----
 include/linux/rcuwait.h               | 32 ++++++++++++++++++++++++++------
 kernel/exit.c                         |  9 ++++++---
 virt/kvm/arm/arch_timer.c             |  3 ++-
 virt/kvm/arm/arm.c                    |  9 +++++----
 virt/kvm/async_pf.c                   |  3 +--
 virt/kvm/kvm_main.c                   | 19 +++++++++----------
 13 files changed, 68 insertions(+), 53 deletions(-)

--
2.16.4

