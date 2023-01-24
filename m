Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC8EF679EBE
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:34:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbjAXQez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234366AbjAXQev (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:34:51 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 097C64A220;
        Tue, 24 Jan 2023 08:34:30 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6BF014B3;
        Tue, 24 Jan 2023 08:35:12 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.11.85])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B8FC83F5A1;
        Tue, 24 Jan 2023 08:34:25 -0800 (PST)
Date:   Tue, 24 Jan 2023 16:34:23 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@kernel.org, will@kernel.org, boqun.feng@gmail.com,
        tglx@linutronix.de, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, seanjc@google.com,
        pbonzini@redhat.com, jgross@suse.com, srivatsa@csail.mit.edu,
        amakhalov@vmware.com, pv-drivers@vmware.com, rostedt@goodmis.org,
        mhiramat@kernel.org, wanpengli@tencent.com, vkuznets@redhat.com,
        boris.ostrovsky@oracle.com, rafael@kernel.org,
        daniel.lezcano@linaro.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        bsegall@google.com, mgorman@suse.de, bristot@redhat.com,
        vschneid@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH 0/6] A few cpuidle vs rcu fixes
Message-ID: <Y9AIj1s5iPPki3dK@FVFF77S0Q05N>
References: <20230123205009.790550642@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230123205009.790550642@infradead.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Peter,

On Mon, Jan 23, 2023 at 09:50:09PM +0100, Peter Zijlstra wrote:
> 0-day robot reported graph-tracing made the cpuidle-vs-rcu rework go splat.

Do you have a link toe the splat somewhere?

I'm assuming that this is partially generic, and I'd like to make sure I test
the right thing on arm64. I'll throw my usual lockdep options at the ftrace
selftests...

Thanks,
Mark.

> 
> These patches appear to cure this, the ftrace selftest now runs to completion
> without spamming scary messages to dmesg.
> 
> ---
>  arch/x86/include/asm/atomic64_32.h | 44 +++++++++++++++++++-------------------
>  arch/x86/include/asm/atomic64_64.h | 36 +++++++++++++++----------------
>  arch/x86/include/asm/kvmclock.h    |  2 +-
>  arch/x86/include/asm/paravirt.h    |  2 +-
>  arch/x86/include/asm/pvclock.h     |  3 ++-
>  arch/x86/kernel/cpu/vmware.c       |  2 +-
>  arch/x86/kernel/ftrace.c           |  3 +++
>  arch/x86/kernel/kvmclock.c         |  6 +++---
>  arch/x86/kernel/pvclock.c          | 22 +++++++++++++------
>  arch/x86/kernel/tsc.c              |  7 +++---
>  arch/x86/xen/time.c                | 12 +++++++++--
>  drivers/cpuidle/cpuidle.c          |  2 +-
>  drivers/cpuidle/poll_state.c       |  2 --
>  include/linux/math64.h             |  4 ++--
>  include/linux/sched/clock.h        |  8 +++----
>  kernel/sched/clock.c               | 27 +++++++++++++++++------
>  16 files changed, 107 insertions(+), 75 deletions(-)
> 
> 
