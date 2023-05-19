Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8327094F1
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjESKeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbjESKeU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55DB210C3;
        Fri, 19 May 2023 03:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=i8/RQiOFGVhuX3oCgXDWVh0oQbt/Cbzp/ltX/NfGGd0=; b=D4LJiuZl6kzCVn4vMC8lP792Br
        tNAZy6PqDUpZzRoNd/rNPkXt0ciJDb940fpNGE4K76cGofNO5mnpIAUlwWuC98fEtgV4R0PFWFXsi
        A5ZnNICp6f9Pgplfvg/WInMoh8LDZvMZ25lMirYbqQIulpctckJnfgFkPi8OAoXhi0nC+D3cpL9Y9
        TxVhDH78itXDcdxGi8hFHZQOQkMDVAFbo0IuljiCHKtXMdUZimM9wkYFvMeREFHHS+U2oJvbhmAdI
        3EBnyaKZd84pnM1i+2fk1H96xqHHC0Gg70mZloG4ubl14zB4pBKoHhsg8boTCYpAANt4ud26eMJDm
        o5laKIrw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pzxPw-006Uqb-0r; Fri, 19 May 2023 10:33:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id D733530008D;
        Fri, 19 May 2023 12:32:55 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id AF4AD235EF085; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102058.581557770@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:20:58 +0200
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
Subject: [PATCH v2 00/13] local_clock() vs noinstr
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi All,

latest version of the local_clock_noinstr() patches.

Most of the changes are in Hyper-V and x86/vdso/gettimeofday; Michael has been
very helpful navigating the Hyper-V spec and fixing their sched_clock
implementation.

---
 arch/arm64/include/asm/arch_timer.h      |  8 +----
 arch/arm64/include/asm/io.h              | 12 +++----
 arch/loongarch/include/asm/loongarch.h   |  2 +-
 arch/loongarch/kernel/time.c             |  6 ++--
 arch/s390/include/asm/timex.h            | 13 ++++---
 arch/s390/kernel/time.c                  |  5 +++
 arch/x86/include/asm/mshyperv.h          |  5 +++
 arch/x86/include/asm/vdso/gettimeofday.h | 41 ++++++++++++++++------
 arch/x86/kernel/kvmclock.c               |  4 +--
 arch/x86/kernel/tsc.c                    | 38 +++++++++++++++-----
 arch/x86/kvm/x86.c                       |  7 ++--
 arch/x86/xen/time.c                      |  3 +-
 drivers/clocksource/arm_arch_timer.c     | 60 ++++++++++++++++++++++++--------
 drivers/clocksource/hyperv_timer.c       | 44 ++++++++++++++---------
 drivers/cpuidle/cpuidle.c                |  8 ++---
 drivers/cpuidle/poll_state.c             |  4 +--
 include/clocksource/hyperv_timer.h       | 24 +++++--------
 include/linux/math64.h                   |  2 +-
 include/linux/rbtree_latch.h             |  2 +-
 include/linux/sched/clock.h              | 17 ++++++++-
 include/linux/seqlock.h                  | 15 ++++----
 kernel/printk/printk.c                   |  2 +-
 kernel/sched/clock.c                     | 19 ++++++----
 kernel/time/sched_clock.c                | 24 +++++++++----
 kernel/time/timekeeping.c                |  4 +--
 25 files changed, 242 insertions(+), 127 deletions(-)

