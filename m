Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDF16FB9D0
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 23:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbjEHVe7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 17:34:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbjEHVe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 17:34:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D705CC;
        Mon,  8 May 2023 14:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=2UuvzVvkJajpSRztAlbWQE/ujN4VBnGx7txBk9UwFEs=; b=KneIF4sIX1hMULcaWZ2QHQseOH
        2g0MVeiYasQ3hb/DQWVc4LIuYtwArZXQukDYTNn/60vn84poNQxzfX6ZYJLkO4eWYGtQRAq2h2if7
        1894SeywnNYoNqO1A9CSpliV+NkbiPjv6Rom4KvFbtpdGVg/i2TvfxseNX1MI0sW5lLGPu6uib8QL
        0wwd0wZNbkIK7JYS+DMjGeOheRRV+VgJ5lNgvkRCjwiFQnXIXuWyrJt8l9ZDM5i2yvADD/aH9eTE0
        i815ZD49VHy76hKDbEfOVg6wb4QNuyqYz7jN8xcax6kBKY+xyMIOjjXvRDB2G5XrKbcmHnQ1gWnOA
        wgjAfVxQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pw8UY-00EW3h-Pu; Mon, 08 May 2023 21:33:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 64B4130026A;
        Mon,  8 May 2023 23:33:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 273602482941B; Mon,  8 May 2023 23:33:48 +0200 (CEST)
Message-ID: <20230508211951.901961964@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 08 May 2023 23:19:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     bigeasy@linutronix.de
Cc:     mark.rutland@arm.com, maz@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, chenhuacai@kernel.org, kernel@xen0n.name,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        jgross@suse.com, boris.ostrovsky@oracle.com,
        daniel.lezcano@linaro.org, kys@microsoft.com,
        haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
        rafael@kernel.org, peterz@infradead.org, longman@redhat.com,
        boqun.feng@gmail.com, pmladek@suse.com, senozhatsky@chromium.org,
        rostedt@goodmis.org, john.ogness@linutronix.de,
        juri.lelli@redhat.com, vincent.guittot@linaro.org,
        dietmar.eggemann@arm.com, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, vschneid@redhat.com, jstultz@google.com,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RFC][PATCH 0/9] local_clock() vs noinstr
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all!

A recent commit of mine marked local_clock() as noinstr.

  776f22913b8e ("sched/clock: Make local_clock() noinstr")

Sadly both me and objtool missed the fact that this is subly broken; but
Sebastian tripped over it [*]:

| vmlinux.o: warning: objtool: native_sched_clock+0x97: call to preempt_schedule_notrace_thunk() leaves .noinstr.text section
| vmlinux.o: warning: objtool: kvm_clock_read+0x22: call to preempt_schedule_notrace_thunk() leaves .noinstr.text section
| vmlinux.o: warning: objtool: local_clock+0xb4: call to preempt_schedule_notrace_thunk() leaves .noinstr.text section

Specifically, local_clock() (and many of the sched_clock() implementation is
relies upon) use preempt_{dis,en}able_notrace() which obviously calls out to
schedule().

Now, noinstr code *should* never trigger this and already run in
non-preemptible code. Specifically entry code should have IRQs disabled while
__cpuidle code should have preemption disabled.

So while it is mostly harmless, I figured it wouldn't be too hard to clean this
up a little -- but that was ~10 patches. Anyway, here goes...

Compile tested only on x86_64/s390/arm64 -- I've just fed it to the
robots.

---
 arch/arm64/include/asm/arch_timer.h    |  8 +----
 arch/arm64/include/asm/io.h            | 12 +++----
 arch/loongarch/include/asm/loongarch.h |  2 +-
 arch/loongarch/kernel/time.c           |  6 ++--
 arch/s390/include/asm/timex.h          | 13 +++++---
 arch/s390/kernel/time.c                | 11 ++++++-
 arch/x86/kernel/kvmclock.c             |  4 +--
 arch/x86/kernel/tsc.c                  | 38 ++++++++++++++++-----
 arch/x86/xen/time.c                    |  3 +-
 drivers/clocksource/arm_arch_timer.c   | 60 ++++++++++++++++++++++++++--------
 drivers/clocksource/hyperv_timer.c     |  4 +--
 drivers/cpuidle/cpuidle.c              |  8 ++---
 drivers/cpuidle/poll_state.c           |  4 +--
 include/clocksource/hyperv_timer.h     |  4 +--
 include/linux/rbtree_latch.h           |  2 +-
 include/linux/sched/clock.h            | 17 +++++++++-
 include/linux/seqlock.h                | 15 +++++----
 kernel/printk/printk.c                 |  2 +-
 kernel/sched/clock.c                   | 19 +++++++----
 kernel/time/sched_clock.c              | 24 ++++++++++----
 kernel/time/timekeeping.c              |  4 +--
 21 files changed, 176 insertions(+), 84 deletions(-)


* https://lkml.kernel.org/r/20230309072724.3F6zRkvw@linutronix.de
  TL;DR: PREEMPT_DYNAMIC=n PREEMPT=y DEBUG_ENTRY=y

