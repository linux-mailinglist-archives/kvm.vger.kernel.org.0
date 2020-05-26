Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3971DA34C
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 23:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgESVN3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 17:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725998AbgESVN2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 17:13:28 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4412C08C5C0;
        Tue, 19 May 2020 14:13:28 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jb9Y2-0001wp-Uy; Tue, 19 May 2020 23:13:15 +0200
Received: from nanos.tec.linutronix.de (localhost [IPv6:::1])
        by nanos.tec.linutronix.de (Postfix) with ESMTP id 75291100D00;
        Tue, 19 May 2020 23:13:14 +0200 (CEST)
Message-Id: <20200519203128.773151484@linutronix.de>
User-Agent: quilt/0.65
Date:   Tue, 19 May 2020 22:31:28 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juergen Gross <jgross@suse.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [patch 0/7] x86/KVM: Async #PF and instrumentation protection
Content-transfer-encoding: 8-bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Folks,

this series is the KVM side of the ongoing quest to confine instrumentation
to safe places and ensure that RCU and context tracking state is correct.

The async #PF changes are in the tip tree already as they conflict with the
entry code rework. The minimal set of commits to carry these have been
isolated and tagged:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git noinstr-x86-kvm-2020-05-16

Paolo, please pull this into your next branch to avoid conflicts in
next. The prerequisites for the following KVM specific changes come with
that tag so that you have no merge dependencies.

The tag has also been merged into

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/entry

where the x86 core #PF entry code changes will be queued soon as well.

The KVM specific patches which deal with the RCU and context tracking state
and the protection against instrumentation in sensitive places have been
split out from the larger entry/noinstr series:

  https://lore.kernel.org/r/20200505134112.272268764@linutronix.de

The patches deal with:

  - Placing the guest_enter/exit() calls at the correct place

  - Moving the sensitive VMENTER/EXIT code into the non-instrumentable code
    section.

  - Fixup the tracing code to comply with the non-instrumentation rules

  - Use native functions to access CR2 and the GS base MSR in the critical
    code pathes to prevent them from being instrumented.

The patches apply on top of

   git://git.kernel.org/pub/scm/linux/kernel/git/kvm/kvm.git next

with the noinstr-x86-kvm-2020-05-16 tag from the tip tree merged in.

For reference the whole lot is available from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/devel.git kvm/noinstr

Thanks,

	tglx

---
 include/asm/hardirq.h  |    4 +-
 include/asm/kvm_host.h |    8 +++++
 kvm/svm/svm.c          |   65 ++++++++++++++++++++++++++++++++++------
 kvm/svm/vmenter.S      |    2 -
 kvm/vmx/ops.h          |    4 ++
 kvm/vmx/vmenter.S      |    5 ++-
 kvm/vmx/vmx.c          |   78 ++++++++++++++++++++++++++++++++++++++-----------
 kvm/x86.c              |    4 --
 8 files changed, 137 insertions(+), 33 deletions(-)
