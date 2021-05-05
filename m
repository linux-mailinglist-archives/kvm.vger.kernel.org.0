Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB85373934
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 13:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhEELWU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 07:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232966AbhEELV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 07:21:59 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE21C061574;
        Wed,  5 May 2021 04:21:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=tFTwL6o0PRTgDF3sDbv4iznFpekqywIcuFXAm0D2u3A=; b=UcNIVRqvIsBnrwmqOrf1ixP2VZ
        5yDMNtw1pQeEkd6/RsG2mBKS/VmOCXgw3YpozA3ZKihPRBwj0xIXwHLvgj+1YutqTmJDWyFh6Cths
        awcTUYSJW56gS2Nde9/IJATm675rYvJaZf128B3U/CRBQ4498+RHhi8c2wrRC8nTEeKAS6Y4SYpyC
        gJDH95qZECBt24NwxKPhkMZq8x9otAa07tsf/9DVuMib2nedmjNCz8CEOf+kqHhxzn3np76lSqrT4
        4HTewKeNA7GSFSzXwPueB0Fzuk6KurihBRzcy8zx/tGudUOQfMqPzsjoxJVS3LAm961WfnfJWf6JG
        hIbMlPZw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1leFXm-000FR7-3b; Wed, 05 May 2021 11:18:44 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 26C18300103;
        Wed,  5 May 2021 13:18:15 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id EB2CE299E9866; Wed,  5 May 2021 13:18:14 +0200 (CEST)
Message-ID: <20210505111525.187225172@infradead.org>
User-Agent: quilt/0.66
Date:   Wed, 05 May 2021 12:59:44 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     tglx@linutronix.de, mingo@kernel.org, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
        rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
        bristot@redhat.com, bsingharora@gmail.com, pbonzini@redhat.com,
        maz@kernel.org
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        peterz@infradead.org, riel@surriel.com, hannes@cmpxchg.org
Subject: [PATCH 4/6] kvm: Select SCHED_INFO instead of TASK_DELAY_ACCT
References: <20210505105940.190490250@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AFAICT KVM only relies on SCHED_INFO. Nothing uses the p->delays data
that belongs to TASK_DELAY_ACCT.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/arm64/kvm/Kconfig |    5 +----
 arch/x86/kvm/Kconfig   |    5 +----
 2 files changed, 2 insertions(+), 8 deletions(-)

--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -20,8 +20,6 @@ if VIRTUALIZATION
 menuconfig KVM
 	bool "Kernel-based Virtual Machine (KVM) support"
 	depends on OF
-	# for TASKSTATS/TASK_DELAY_ACCT:
-	depends on NET && MULTIUSER
 	select MMU_NOTIFIER
 	select PREEMPT_NOTIFIERS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
@@ -38,8 +36,7 @@ menuconfig KVM
 	select IRQ_BYPASS_MANAGER
 	select HAVE_KVM_IRQ_BYPASS
 	select HAVE_KVM_VCPU_RUN_PID_CHANGE
-	select TASKSTATS
-	select TASK_DELAY_ACCT
+	select SCHED_INFO
 	help
 	  Support hosting virtualized guest machines.
 
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -22,8 +22,6 @@ config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
 	depends on HAVE_KVM
 	depends on HIGH_RES_TIMERS
-	# for TASKSTATS/TASK_DELAY_ACCT:
-	depends on NET && MULTIUSER
 	depends on X86_LOCAL_APIC
 	select PREEMPT_NOTIFIERS
 	select MMU_NOTIFIER
@@ -36,8 +34,7 @@ config KVM
 	select KVM_ASYNC_PF
 	select USER_RETURN_NOTIFIER
 	select KVM_MMIO
-	select TASKSTATS
-	select TASK_DELAY_ACCT
+	select SCHED_INFO
 	select PERF_EVENTS
 	select HAVE_KVM_MSI
 	select HAVE_KVM_CPU_RELAX_INTERCEPT


