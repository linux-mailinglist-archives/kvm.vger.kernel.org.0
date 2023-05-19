Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41BCC7094EA
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbjESKeY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbjESKeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC23E6E;
        Fri, 19 May 2023 03:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=PdkNN+bEFxvrPVsYQm09x9UzPIqGPkz1+SOV54XiNcU=; b=T2SfA/ycuf9iIQR3nhN3Yoezbh
        Z+GZXjbbtDoSBbbCOqeaqVhsuf4EUgIZccbxHfFCy15IHy8j7dBIZUglCv6S0Zcc0TQAtkSlZ7v29
        n33ezqIIhYJAcMKsqdJekL8h5dSSKkY5gx+25HMi720JmqMpF6deZDaSpVD19BF0UEmdseoyMOLVe
        nKxQAk7K7k3pxR87/bEltU4rij6Wx7P5JhQrsvB8RzcEs2tYyN0jlu5F4hMhIO1KzIbY2HnKvoJQ2
        Tg19FWFf6e/85e9bUCZDNYr9mDz4gPJvj1kP/YSFdXb+kbultWmzECEohGZ4fpNxtxm14QYtNotiv
        lI8soIEQ==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzxPv-00FrWZ-2x;
        Fri, 19 May 2023 10:33:00 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 340BF30614A;
        Fri, 19 May 2023 12:32:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id DE3EC235EF0B2; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102715.775630881@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:21:07 +0200
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
Subject: [PATCH v2 09/13] clocksource: hyper-v: Adjust hv_read_tsc_page_tsc() to avoid special casing U64_MAX
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

Currently hv_read_tsc_page_tsc() (ab)uses the (valid) time value of
U64_MAX as an error return. This breaks the clean wrap-around of the
clock.

Modify the function signature to return a boolean state and provide
another u64 pointer to store the actual time on success. This obviates
the need to steal one time value and restores the full counter width.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/vdso/gettimeofday.h |   10 ++++++----
 arch/x86/kvm/x86.c                       |    7 +++----
 drivers/clocksource/hyperv_timer.c       |   16 +++++++++++-----
 include/clocksource/hyperv_timer.h       |   24 +++++++++---------------
 4 files changed, 29 insertions(+), 28 deletions(-)

--- a/arch/x86/include/asm/vdso/gettimeofday.h
+++ b/arch/x86/include/asm/vdso/gettimeofday.h
@@ -238,10 +238,12 @@ static u64 vread_pvclock(void)
 #ifdef CONFIG_HYPERV_TIMER
 static u64 vread_hvclock(void)
 {
-	u64 ret = hv_read_tsc_page(&hvclock_page);
-	if (likely(ret != U64_MAX))
-		ret &= S64_MAX;
-	return ret;
+	u64 tsc, time;
+
+	if (hv_read_tsc_page_tsc(&hvclock_page, &tsc, &time))
+		return time & S64_MAX;
+
+	return U64_MAX;
 }
 #endif
 
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2799,14 +2799,13 @@ static u64 read_tsc(void)
 static inline u64 vgettsc(struct pvclock_clock *clock, u64 *tsc_timestamp,
 			  int *mode)
 {
-	long v;
 	u64 tsc_pg_val;
+	long v;
 
 	switch (clock->vclock_mode) {
 	case VDSO_CLOCKMODE_HVCLOCK:
-		tsc_pg_val = hv_read_tsc_page_tsc(hv_get_tsc_page(),
-						  tsc_timestamp);
-		if (tsc_pg_val != U64_MAX) {
+		if (hv_read_tsc_page_tsc(hv_get_tsc_page(),
+					 tsc_timestamp, &tsc_pg_val)) {
 			/* TSC page valid */
 			*mode = VDSO_CLOCKMODE_HVCLOCK;
 			v = (tsc_pg_val - clock->cycle_last) &
--- a/drivers/clocksource/hyperv_timer.c
+++ b/drivers/clocksource/hyperv_timer.c
@@ -393,14 +393,20 @@ struct ms_hyperv_tsc_page *hv_get_tsc_pa
 }
 EXPORT_SYMBOL_GPL(hv_get_tsc_page);
 
-static u64 notrace read_hv_clock_tsc(void)
+static notrace u64 read_hv_clock_tsc(void)
 {
-	u64 current_tick = hv_read_tsc_page(hv_get_tsc_page());
+	u64 cur_tsc, time;
 
-	if (current_tick == U64_MAX)
-		current_tick = hv_get_register(HV_REGISTER_TIME_REF_COUNT);
+	/*
+	 * The Hyper-V Top-Level Function Spec (TLFS), section Timers,
+	 * subsection Refererence Counter, guarantees that the TSC and MSR
+	 * times are in sync and monotonic. Therefore we can fall back
+	 * to the MSR in case the TSC page indicates unavailability.
+	 */
+	if (!hv_read_tsc_page_tsc(tsc_page, &cur_tsc, &time))
+		time = hv_get_register(HV_REGISTER_TIME_REF_COUNT);
 
-	return current_tick;
+	return time;
 }
 
 static u64 notrace read_hv_clock_tsc_cs(struct clocksource *arg)
--- a/include/clocksource/hyperv_timer.h
+++ b/include/clocksource/hyperv_timer.h
@@ -38,8 +38,9 @@ extern void hv_remap_tsc_clocksource(voi
 extern unsigned long hv_get_tsc_pfn(void);
 extern struct ms_hyperv_tsc_page *hv_get_tsc_page(void);
 
-static inline notrace u64
-hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg, u64 *cur_tsc)
+static __always_inline bool
+hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg,
+		     u64 *cur_tsc, u64 *time)
 {
 	u64 scale, offset;
 	u32 sequence;
@@ -63,7 +64,7 @@ hv_read_tsc_page_tsc(const struct ms_hyp
 	do {
 		sequence = READ_ONCE(tsc_pg->tsc_sequence);
 		if (!sequence)
-			return U64_MAX;
+			return false;
 		/*
 		 * Make sure we read sequence before we read other values from
 		 * TSC page.
@@ -82,15 +83,8 @@ hv_read_tsc_page_tsc(const struct ms_hyp
 
 	} while (READ_ONCE(tsc_pg->tsc_sequence) != sequence);
 
-	return mul_u64_u64_shr(*cur_tsc, scale, 64) + offset;
-}
-
-static inline notrace u64
-hv_read_tsc_page(const struct ms_hyperv_tsc_page *tsc_pg)
-{
-	u64 cur_tsc;
-
-	return hv_read_tsc_page_tsc(tsc_pg, &cur_tsc);
+	*time = mul_u64_u64_shr(*cur_tsc, scale, 64) + offset;
+	return true;
 }
 
 #else /* CONFIG_HYPERV_TIMER */
@@ -104,10 +98,10 @@ static inline struct ms_hyperv_tsc_page
 	return NULL;
 }
 
-static inline u64 hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg,
-				       u64 *cur_tsc)
+static __always_inline bool
+hv_read_tsc_page_tsc(const struct ms_hyperv_tsc_page *tsc_pg, u64 *cur_tsc, u64 *time)
 {
-	return U64_MAX;
+	return false;
 }
 
 static inline int hv_stimer_cleanup(unsigned int cpu) { return 0; }


