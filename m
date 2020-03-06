Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1761117C976
	for <lists+kvm@lfdr.de>; Sat,  7 Mar 2020 01:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgCGAMO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 19:12:14 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54691 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726314AbgCGAMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 19:12:14 -0500
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jAN4V-0007ar-Fm; Sat, 07 Mar 2020 01:12:04 +0100
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id B08E1FF8FB;
        Sat,  7 Mar 2020 01:12:02 +0100 (CET)
Message-Id: <20200306234204.847674001@linutronix.de>
User-Agent: quilt/0.65
Date:   Sat, 07 Mar 2020 00:42:04 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: [patch 0/2] x86/kvm: Sanitize async page fault
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi!

This emerged from the ongoing efforts to consolidate the entry code maze on
x86 along with the tracing and instrumentation induced violations of RCU
constraints.

While working on this I stumbled over the KVM async page fault handler and
kvm_async_pf_task_wait() in particular. It took me a while to realize that
the randomly sprinkled around rcu_irq_enter()/exit() invocations are just
cargo cult programming. Several patches "fixed" RCU splats by curing the
symptoms without realizing that the code is fundametally flawed from a
design perspective.

Aside of that Andy noticed that the way the async page fault handler is
implemented can be improved which in turn allows further simplification
vs. CR2 consistency and the general exception entry handling on x86.

I'm sending this out as a stand alone series against mainline, but I'd
prefer to take this along with the rest if the entry code rework.

If you look at the changelog then don't be afraid, most of the added lines
are comments which were painfully absent in the original code.

Thanks,

	tglx
---
 entry/entry_32.S       |    8 --
 entry/entry_64.S       |    4 -
 include/asm/kvm_para.h |   21 ++++-
 include/asm/x86_init.h |    2 
 kernel/kvm.c           |  193 +++++++++++++++++++++++++++++++++----------------
 kernel/traps.c         |    2 
 kernel/x86_init.c      |    1 
 kvm/mmu/mmu.c          |    2 
 mm/fault.c             |   19 ++++
 9 files changed, 171 insertions(+), 81 deletions(-)

