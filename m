Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B08A709502
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 12:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbjESKeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 06:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjESKeM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 06:34:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9358A10F5;
        Fri, 19 May 2023 03:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=YKwqF+BUvFX/eM4sVo4oYqYCF/ZGTA0lXMxYZ5TRTwg=; b=nThm858ZrHzNO23eD6wR31ciwE
        x58F2HwKZ7dRAXG6f+BjqKOAdxpfqCDGfd4O+9QOYCETZe6KwTkDvdcS+urMnFoDb0XAFn5cZf5Jb
        USmR2+R7fZRNW+sAUJOz8Qr7tfOZwBvKcJplaAvug3uZrKLsOVlJY1RLCfFVvjW022AFyKU60blBK
        /NYfGaPir9Wm8y6qd2NdN74E7cmTt19yBte5ieU75rebcHtSVqpFrNafD8uMhJKc9OdXa+OtkCRgK
        H+ZoX5Z72bDBHvE6ZQNpn5rZSXXufP8PR+5eAzIjGIZri6Qcz/K6n6SFWo1Wht92C2G7fBe18aXuB
        32XxWojg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pzxPv-00FrWQ-07;
        Fri, 19 May 2023 10:32:59 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 2B57C306146;
        Fri, 19 May 2023 12:32:56 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id D8C6A235EF0B1; Fri, 19 May 2023 12:32:55 +0200 (CEST)
Message-ID: <20230519102715.704767397@infradead.org>
User-Agent: quilt/0.66
Date:   Fri, 19 May 2023 12:21:06 +0200
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
Subject: [PATCH v2 08/13] x86/vdso: Fix gettimeofday masking
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

Because of how the virtual clocks use U64_MAX as an exception value
instead of a valid time, the clocks can no longer be assumed to wrap
cleanly. This is then compounded by arch_vdso_cycles_ok() rejecting
everything with the MSB/Sign-bit set.

Therefore, the effective mask becomes S64_MAX, and the comment with
vdso_calc_delta() that states the mask is U64_MAX and isn't optimized
out is just plain silly.

Now, the code has a negative filter -- to deal with TSC wobbles:

	if (cycles > last)

which is just plain wrong, because it should've been written as:

	if ((s64)(cycles - last) > 0)

to take wrapping into account, but per all the above, we don't
actually wrap on u64 anymore.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/vdso/gettimeofday.h |   39 ++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 11 deletions(-)

--- a/arch/x86/include/asm/vdso/gettimeofday.h
+++ b/arch/x86/include/asm/vdso/gettimeofday.h
@@ -231,14 +231,17 @@ static u64 vread_pvclock(void)
 		ret = __pvclock_read_cycles(pvti, rdtsc_ordered());
 	} while (pvclock_read_retry(pvti, version));
 
-	return ret;
+	return ret & S64_MAX;
 }
 #endif
 
 #ifdef CONFIG_HYPERV_TIMER
 static u64 vread_hvclock(void)
 {
-	return hv_read_tsc_page(&hvclock_page);
+	u64 ret = hv_read_tsc_page(&hvclock_page);
+	if (likely(ret != U64_MAX))
+		ret &= S64_MAX;
+	return ret;
 }
 #endif
 
@@ -246,7 +249,7 @@ static inline u64 __arch_get_hw_counter(
 					const struct vdso_data *vd)
 {
 	if (likely(clock_mode == VDSO_CLOCKMODE_TSC))
-		return (u64)rdtsc_ordered();
+		return (u64)rdtsc_ordered() & S64_MAX;
 	/*
 	 * For any memory-mapped vclock type, we need to make sure that gcc
 	 * doesn't cleverly hoist a load before the mode check.  Otherwise we
@@ -284,6 +287,9 @@ static inline bool arch_vdso_clocksource
  * which can be invalidated asynchronously and indicate invalidation by
  * returning U64_MAX, which can be effectively tested by checking for a
  * negative value after casting it to s64.
+ *
+ * This effectively forces a S64_MAX mask on the calculations, unlike the
+ * U64_MAX mask normally used by x86 clocksources.
  */
 static inline bool arch_vdso_cycles_ok(u64 cycles)
 {
@@ -303,18 +309,29 @@ static inline bool arch_vdso_cycles_ok(u
  * @last. If not then use @last, which is the base time of the current
  * conversion period.
  *
- * This variant also removes the masking of the subtraction because the
- * clocksource mask of all VDSO capable clocksources on x86 is U64_MAX
- * which would result in a pointless operation. The compiler cannot
- * optimize it away as the mask comes from the vdso data and is not compile
- * time constant.
+ * This variant also uses a custom mask because while the clocksource mask of
+ * all the VDSO capable clocksources on x86 is U64_MAX, the above code uses
+ * U64_MASK as an exception value, additionally arch_vdso_cycles_ok() above
+ * declares everything with the MSB/Sign-bit set as invalid. Therefore the
+ * effective mask is S64_MAX.
  */
 static __always_inline
 u64 vdso_calc_delta(u64 cycles, u64 last, u64 mask, u32 mult)
 {
-	if (cycles > last)
-		return (cycles - last) * mult;
-	return 0;
+	/*
+	 * Due to the MSB/Sign-bit being used as invald marker (see
+	 * arch_vdso_cycles_valid() above), the effective mask is S64_MAX.
+	 */
+	u64 delta = (cycles - last) & S64_MAX;
+
+	/*
+	 * Due to the above mentioned TSC wobbles, filter out negative motion.
+	 * Per the above masking, the effective sign bit is now bit 62.
+	 */
+	if (unlikely(delta & (1ULL << 62)))
+		return 0;
+
+	return delta * mult;
 }
 #define vdso_calc_delta vdso_calc_delta
 


