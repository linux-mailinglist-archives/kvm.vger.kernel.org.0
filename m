Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D088F67CFAD
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 16:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbjAZPPw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 10:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjAZPPl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 10:15:41 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1016C460B0;
        Thu, 26 Jan 2023 07:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=eLqO1bA1ovJ6Tk3ye++iUoffczzuE9Es9NByP+7cFt8=; b=HfMc4m9Dr3GMuzid7iRyiLIvSz
        KcWcjJ+vXqxvH6l4bMC0kYM4TLvxE13XKgeiFngLSP/9uC2SCwPcg0yX6vwgoGJNssEBiRhX6b67J
        s2y50+62if5VJtHpjGNbnlB/vParYaoxFizVfooe0/2eCYroVVPDjeJiqh0oXqc7r910QLWj5uv29
        epzcJo21rMRwpLOlWQoHp6XaQ//OS128hlgMfSFFOa/9TdMxMDklWWJ1VQVOael72XRin5mgKFJeE
        r6qDmiz1TuhnJXPRWVYEMnfT49mFKRH0Gplmij47FlLlEIhTfnv+FfdZ8O3J3kDgGqggjpjB/Gouw
        I2INHJng==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pL3xH-002U1e-2W;
        Thu, 26 Jan 2023 15:14:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 26A49300577;
        Thu, 26 Jan 2023 16:14:53 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 064C52084C4A7; Thu, 26 Jan 2023 16:14:53 +0100 (CET)
Message-ID: <20230126150829.087606759@infradead.org>
User-Agent: quilt/0.66
Date:   Thu, 26 Jan 2023 16:08:29 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     mingo@kernel.org
Cc:     will@kernel.org, peterz@infradead.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, seanjc@google.com, pbonzini@redhat.com,
        jgross@suse.com, srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, lpieralisi@kernel.org,
        frederic@kernel.org, paulmck@kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, longman@redhat.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] A few more cpuidle vs rcu fixes
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

0-day robot reported graph-tracing made the cpuidle-vs-rcu rework go splat.

These patches appear to cure this, the ftrace selftest now runs to completion
without spamming scary messages to dmesg.

Since v1:

 - fixed recursive RCU splats
 - fixed psci thingies for arm (null)
 - improved the tracing WARN (rostedt)
 - fixed TRACE_PREEMPT_TOGGLE (null)

---
 arch/x86/include/asm/atomic64_32.h | 44 +++++++++++++++++++-------------------
 arch/x86/include/asm/atomic64_64.h | 36 +++++++++++++++----------------
 arch/x86/include/asm/kvmclock.h    |  2 +-
 arch/x86/include/asm/paravirt.h    |  2 +-
 arch/x86/include/asm/pvclock.h     |  3 ++-
 arch/x86/kernel/cpu/vmware.c       |  2 +-
 arch/x86/kernel/kvmclock.c         |  6 +++---
 arch/x86/kernel/pvclock.c          | 22 +++++++++++++------
 arch/x86/kernel/tsc.c              |  7 +++---
 arch/x86/xen/time.c                | 12 +++++++++--
 drivers/cpuidle/cpuidle.c          |  2 +-
 drivers/cpuidle/poll_state.c       |  2 --
 drivers/firmware/psci/psci.c       | 31 ++++++++++++++++-----------
 include/linux/context_tracking.h   | 27 +++++++++++++++++++++++
 include/linux/math64.h             |  4 ++--
 include/linux/sched/clock.h        |  8 +++----
 include/linux/trace_recursion.h    | 18 ++++++++++++++++
 kernel/locking/lockdep.c           |  3 +++
 kernel/panic.c                     |  5 +++++
 kernel/sched/clock.c               | 27 +++++++++++++++++------
 kernel/trace/trace_preemptirq.c    |  6 ++----
 lib/bug.c                          | 15 ++++++++++++-
 22 files changed, 192 insertions(+), 92 deletions(-)

