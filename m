Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2000E6FB9D7
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 23:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbjEHVfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 17:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjEHVe5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 17:34:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44209DE;
        Mon,  8 May 2023 14:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=y/NZkFjA2o+5kqY9Uzuitbn0zBukaZRP/fG6yHo/Mzw=; b=DR37JdMJecYKE8vH9MPmtZRs5A
        XWITmzNs1sn56eCXZ1sFUJPLFtuVOFvWlWkl3ZFUyDy0UY2QbuQQStdtz6WpGq0WKb/CpD83ravJF
        cAhzD4bfbpVZkKvODjERzxd8VjoOdK6VLJdKZb4Gq7oPEknGH875+hTYt4dBj/EmOp5mJ+6UQMdLJ
        HlSO+eI8jz7OO0U5xrrXvNYj4hxiqSA+4cYFFydfnPMPPtjkdnmHNghYo8gfCor4l3FWRl9d9WwS3
        BlPVYt3Z7qeJ2amRuFeQdKimGkygzER0E2GaTGbJjmTXqLL5SD0Q59vFCBFYZ1QrdQTlLpLfLyUS2
        XmDPsofA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pw8UY-00EW3i-Pu; Mon, 08 May 2023 21:33:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 66F03302188;
        Mon,  8 May 2023 23:33:48 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 320C42482941C; Mon,  8 May 2023 23:33:48 +0200 (CEST)
Message-ID: <20230508213147.515668092@infradead.org>
User-Agent: quilt/0.66
Date:   Mon, 08 May 2023 23:19:53 +0200
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
Subject: [RFC][PATCH 2/9] time/sched_clock: Provide sched_clock_noinstr()
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
prepare for things by providing a noinstr sched_clock_noinstr() function.

Specifically, preempt_enable_*() calls out to schedule(), which upsets
noinstr validation efforts.

As such, pull out the preempt_{dis,en}able_notrace() requirements from
the sched_clock_read() implementations by explicitly providing it in
the sched_clock() function.

This further requires said sched_clock_read() functions to be noinstr
themselves, for ARCH_WANTS_NO_INSTR users. See the next few patches.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/time/sched_clock.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/kernel/time/sched_clock.c
+++ b/kernel/time/sched_clock.c
@@ -64,7 +64,7 @@ static struct clock_data cd ____cachelin
 	.actual_read_sched_clock = jiffy_sched_clock_read,
 };
 
-static inline u64 notrace cyc_to_ns(u64 cyc, u32 mult, u32 shift)
+static __always_inline u64 cyc_to_ns(u64 cyc, u32 mult, u32 shift)
 {
 	return (cyc * mult) >> shift;
 }
@@ -80,23 +80,33 @@ notrace int sched_clock_read_retry(unsig
 	return raw_read_seqcount_latch_retry(&cd.seq, seq);
 }
 
-unsigned long long notrace sched_clock(void)
+unsigned long long noinstr sched_clock_noinstr(void)
 {
-	u64 cyc, res;
-	unsigned int seq;
 	struct clock_read_data *rd;
+	unsigned int seq;
+	u64 cyc, res;
 
 	do {
-		rd = sched_clock_read_begin(&seq);
+		seq = raw_read_seqcount_latch(&cd.seq);
+		rd = cd.read_data + (seq & 1);
 
 		cyc = (rd->read_sched_clock() - rd->epoch_cyc) &
 		      rd->sched_clock_mask;
 		res = rd->epoch_ns + cyc_to_ns(cyc, rd->mult, rd->shift);
-	} while (sched_clock_read_retry(seq));
+	} while (raw_read_seqcount_latch_retry(&cd.seq, seq));
 
 	return res;
 }
 
+unsigned long long notrace sched_clock(void)
+{
+	unsigned long long ns;
+	preempt_disable_notrace();
+	ns = sched_clock_noinstr();
+	preempt_enable_notrace();
+	return ns;
+}
+
 /*
  * Updating the data required to read the clock.
  *


