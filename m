Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 585BC6788F1
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 21:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232769AbjAWU64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 15:58:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbjAWU6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 15:58:46 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB48912F3E;
        Mon, 23 Jan 2023 12:58:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Subject:Cc:To:From:Date:Message-ID:
        Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=uxgezMurEELpCVJJhX20ZUHEfgwrZWcqXDjzle4mol8=; b=beZJPCIEffSubL1uEDVNCpWWAv
        P0dQItdbWMXkLzvxqxN2izB1koNs5fAWWajHR2whTbqKJ6BCHjRsJxhiPEu78EZrEYO9VnUzNs1jV
        ISCv4kk2PMiS1y+R0god9Q2UshUhc3v+9E1D8c/KhMmjB3VcrO2lD+rGXzF9ErdSbJeUfypKgj/gA
        uGlpDbbAacQ59wsPz0YUScLGqeC92KD9yrgIa+OQNAEnr9+y9dkwjhEcoMbSrLGc9te1y5cfctcbZ
        UiRYbMe0Uh7uSmNQAD5X0ax22AZZpnQSUguxrDFywdb9EDSq/d75ve4YkvjKrlhktiiG/LSojvFy3
        ULB3MkPQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pK3sA-001dtn-07;
        Mon, 23 Jan 2023 20:57:02 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6266B300673;
        Mon, 23 Jan 2023 21:57:24 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id BEE12207579DF; Mon, 23 Jan 2023 21:57:24 +0100 (CET)
Message-ID: <20230123205009.790550642@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 23 Jan 2023 21:50:09 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     mingo@kernel.org
Cc:     will@kernel.org, peterz@infradead.org, boqun.feng@gmail.com,
        mark.rutland@arm.com, tglx@linutronix.de, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, pbonzini@redhat.com, jgross@suse.com,
        srivatsa@csail.mit.edu, amakhalov@vmware.com,
        pv-drivers@vmware.com, rostedt@goodmis.org, mhiramat@kernel.org,
        wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH 0/6] A few cpuidle vs rcu fixes
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

---
 arch/x86/include/asm/atomic64_32.h | 44 +++++++++++++++++++-------------------
 arch/x86/include/asm/atomic64_64.h | 36 +++++++++++++++----------------
 arch/x86/include/asm/kvmclock.h    |  2 +-
 arch/x86/include/asm/paravirt.h    |  2 +-
 arch/x86/include/asm/pvclock.h     |  3 ++-
 arch/x86/kernel/cpu/vmware.c       |  2 +-
 arch/x86/kernel/ftrace.c           |  3 +++
 arch/x86/kernel/kvmclock.c         |  6 +++---
 arch/x86/kernel/pvclock.c          | 22 +++++++++++++------
 arch/x86/kernel/tsc.c              |  7 +++---
 arch/x86/xen/time.c                | 12 +++++++++--
 drivers/cpuidle/cpuidle.c          |  2 +-
 drivers/cpuidle/poll_state.c       |  2 --
 include/linux/math64.h             |  4 ++--
 include/linux/sched/clock.h        |  8 +++----
 kernel/sched/clock.c               | 27 +++++++++++++++++------
 16 files changed, 107 insertions(+), 75 deletions(-)


