Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCAD709508
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbjESKem (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231963AbjESKeV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE47B10E9;
        Fri, 19 May 2023 03:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=jRlOPCiGZ1QUnD3ip/ciK1dDyTis2uNLJ5A1APQzhgQ=; b=Dzv1GYHGnPXTBnG4o/Xs2ei8aB
        Q4Q6AnwKkhA4/hEfC+CyMGueM2yEEVQV5k5/e+DpKX7iQH+uIsaifb3r5hun1Lb7Ut3RbjPW/FK3q
        7GgHVmd0difqEDkcOUBcHAAh5c6uRhVnesPdDrMRNy/o6AnRENKyjOblNglpALQqDQc/2Nn6ie6+b
        ucFkxiKZvHRfSu80GKiNvsUh8ymS2G3cSlbSyOZ+URcvm9aZHO7ZGRSM/eu5b4omZrZLj+4rqNVY9
        AKoPw+lovjejVC3kt7P8jMHh8B13s8koFqJH7ULD9r3B+YQXXFeiaQspwGhIId5AKB0TqQ/qGFkBs
        ApoGTrcA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pzxPv-006UqQ-LP; Fri, 19 May 2023 10:33:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3C81430614C;
        Fri, 19 May 2023 12:32:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id E61E9235EF0B3; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102715.843039089@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:21:08 +0200
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
        linux-pm@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH v2 10/13] clocksource: hyper-v: Provide noinstr sched_clock()
References: <20230519102058.581557770@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

With the intent to provide local_clock_noinstr(), a variant of
local_clock() that's safe to be called from noinstr code (with the
assumption that any such code will already be non-preemptible),
prepare for things by making the Hyper-V TSC and MSR sched_clock
implementations noinstr.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Co-developed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/mshyperv.h    |    5 +++++
 drivers/clocksource/hyperv_timer.c |   32 ++++++++++++++++++--------------
 2 files changed, 23 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/mshyperv.h
+++ b/arch/x86/include/asm/mshyperv.h
@@ -257,6 +257,11 @@ void hv_set_register(unsigned int reg, u
 u64 hv_get_non_nested_register(unsigned int reg);
 void hv_set_non_nested_register(unsigned int reg, u64 value);
 
+static __always_inline u64 hv_raw_get_register(unsigned int reg)
+{
+	return __rdmsr(reg);
+}
+
 #else /* CONFIG_HYPERV */
 static inline void hyperv_init(void) {}
 static inline void hyperv_setup_mmu_ops(void) {}
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -365,6 +365,20 @@ void hv_stimer_global_cleanup(void)
 }
 EXPORT_SYMBOL_GPL(hv_stimer_global_cleanup);
 
+static __always_inline u64 read_hv_clock_msr(void)
+{
+	/*
+	 * Read the partition counter to get the current tick count. This count
+	 * is set to 0 when the partition is created and is incremented in 100
+	 * nanosecond units.
+	 *
+	 * Use hv_raw_get_register() because this function is used from
+	 * noinstr. Notable; while HV_REGISTER_TIME_REF_COUNT is a synthetic
+	 * register it doesn't need the GHCB path.
+	 */
+	return hv_raw_get_register(HV_REGISTER_TIME_REF_COUNT);
+}
+
 /*
  * Code and definitions for the Hyper-V clocksources.  Two
  * clocksources are defined: one that reads the Hyper-V defined MSR, and
@@ -393,7 +407,7 @@ struct ms_hyperv_tsc_page *hv_get_tsc_pa
 }
 EXPORT_SYMBOL_GPL(hv_get_tsc_page);
 
-static notrace u64 read_hv_clock_tsc(void)
+static __always_inline u64 read_hv_clock_tsc(void)
 {
 	u64 cur_tsc, time;
 
@@ -404,7 +418,7 @@ static notrace u64 read_hv_clock_tsc(voi
 	 * to the MSR in case the TSC page indicates unavailability.
 	 */
 	if (!hv_read_tsc_page_tsc(tsc_page, &cur_tsc, &time))
-		time = hv_get_register(HV_REGISTER_TIME_REF_COUNT);
+		time = read_hv_clock_msr();
 
 	return time;
 }
@@ -414,7 +428,7 @@ static u64 notrace read_hv_clock_tsc_cs(
 	return read_hv_clock_tsc();
 }
 
-static u64 notrace read_hv_sched_clock_tsc(void)
+static u64 noinstr read_hv_sched_clock_tsc(void)
 {
 	return (read_hv_clock_tsc() - hv_sched_clock_offset) *
 		(NSEC_PER_SEC / HV_CLOCK_HZ);
@@ -466,22 +480,12 @@ static struct clocksource hyperv_cs_tsc
 #endif
 };
 
-static u64 notrace read_hv_clock_msr(void)
-{
-	/*
-	 * Read the partition counter to get the current tick count. This count
-	 * is set to 0 when the partition is created and is incremented in
-	 * 100 nanosecond units.
-	 */
-	return hv_get_register(HV_REGISTER_TIME_REF_COUNT);
-}
-
 static u64 notrace read_hv_clock_msr_cs(struct clocksource *arg)
 {
 	return read_hv_clock_msr();
 }
 
-static u64 notrace read_hv_sched_clock_msr(void)
+static u64 noinstr read_hv_sched_clock_msr(void)
 {
 	return (read_hv_clock_msr() - hv_sched_clock_offset) *
 		(NSEC_PER_SEC / HV_CLOCK_HZ);


