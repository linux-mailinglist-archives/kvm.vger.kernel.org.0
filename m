Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB366FB9FD
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 23:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234419AbjEHVhI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 17:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234248AbjEHVgt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 17:36:49 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0906746A1;
        Mon,  8 May 2023 14:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=YB2UOIFIw2gwCNTVh1j30XHP2RZzZzmzkIRobxbOGl0=; b=M2iOJBjKCa79Kv9g3tjWPVJtfy
        KhgiZrTa14XHFuWNlEPcmixkV04+wlzqZJejkStuJj9v7/L8doRfz+dSC1Hh4X+EV63Q7yEPMtx3l
        VvKERwRhkB0Pue0edXHPZLIi7dBrgCMV5plSt4V61wT3O4pNq41WMoOdff8iW+QCXNa4J6i4gdDkH
        3Op4X0qcSAppyJHS8/G/TRWwuJCq8ntWBm8EmEJdXZH5sXXGJTSYslQP651uTLAomLG6te6RB3kEf
        fQGbSryGVWIyKlWQBoAiJhJ7ytQTG0orrgOpToKdgeO4JFZc/HJEIrEESutvAqjUogdgXVL1c75a3
        ZUxEaSrA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pw8UZ-005J1E-1B;
        Mon, 08 May 2023 21:34:15 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A98C630613F;
        Mon,  8 May 2023 23:33:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 3EBFA24829429; Mon,  8 May 2023 23:33:48 +0200 (CEST)
Message-ID: <20230508213147.718633831@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 08 May 2023 23:19:56 +0200
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
Subject: [RFC][PATCH 5/9] loongarch: Provide noinstr sched_clock_read()
References: <20230508211951.901961964@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the intent to provide local_clock_noinstr(), a variant of
local_clock() that's safe to be called from noinstr code (with the
assumption that any such code will already be non-preemptible),
prepare for things by providing a noinstr sched_clock_read() function.

Specifically, preempt_enable_*() calls out to schedule(), which upsets
noinstr validation efforts.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/loongarch/include/asm/loongarch.h |    2 +-
 arch/loongarch/kernel/time.c           |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -1167,7 +1167,7 @@ static __always_inline void iocsr_write6
 
 #ifndef __ASSEMBLY__
 
-static inline u64 drdtime(void)
+static __always_inline u64 drdtime(void)
 {
 	int rID = 0;
 	u64 val = 0;
--- a/arch/loongarch/kernel/time.c
+++ b/arch/loongarch/kernel/time.c
@@ -190,9 +190,9 @@ static u64 read_const_counter(struct clo
 	return drdtime();
 }
 
-static u64 native_sched_clock(void)
+static noinstr u64 sched_clock_read(void)
 {
-	return read_const_counter(NULL);
+	return drdtime();
 }
 
 static struct clocksource clocksource_const = {
@@ -211,7 +211,7 @@ int __init constant_clocksource_init(voi
 
 	res = clocksource_register_hz(&clocksource_const, freq);
 
-	sched_clock_register(native_sched_clock, 64, freq);
+	sched_clock_register(sched_clock_read, 64, freq);
 
 	pr_info("Constant clock source device register\n");
 


