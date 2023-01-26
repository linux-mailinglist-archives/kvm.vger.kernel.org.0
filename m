Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4957267CF99
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 16:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232043AbjAZPPk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 10:15:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231952AbjAZPPi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 10:15:38 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC7B5C0F0;
        Thu, 26 Jan 2023 07:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Type:MIME-Version:References:
        Subject:Cc:To:From:Date:Message-ID:Sender:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:In-Reply-To;
        bh=LKrP1wtwDwtGfmqJdEblQavVdQZHYUX7Rw9EhYSY0po=; b=tJ7KRCSZonsBJNK0ODaA1eE1C1
        n727YqOhrfXU76hw15Bpd17NXo9uNPSGT0CA7UrrNT5L4l9pGO3lbXFBip6jtT3/B59UeWoTko2QR
        qb84FHcQDDdCmZBir+aqAV0lj/CqVS+40GvhCV1U0BmKOBcGjWVZeTeR4qDT0Sfiagb1af9JoGJOv
        OiA6BV9qbN0EooMWBslRFimVh9f3HsMoAhlP/Qu8DC8Bw1i/Ba2wwRBq8j96cGGWJae7XHaf0FyQh
        n0HoKdEPkIIXhjaGjYW4QBDOmnM0ECh716ZrDwhFrJ+fHegexZ8dtuOlt/cUzhya+SgnLyOwSmjTO
        vpdjbXKg==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pL3xn-006qUP-F5; Thu, 26 Jan 2023 15:14:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 89D09302E1F;
        Thu, 26 Jan 2023 16:14:54 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 0)
        id 1F1372084C4B1; Thu, 26 Jan 2023 16:14:53 +0100 (CET)
Message-ID: <20230126151323.643408110@infradead.org>
User-Agent: quilt/0.66
Date:   Thu, 26 Jan 2023 16:08:35 +0100
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
        linux-pm@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Uros Bizjak <ubizjak@gmail.com>
Subject: [PATCH v2 6/9] x86/pvclock: improve atomic update of last_value in pvclock_clocksource_read
References: <20230126150829.087606759@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Uros Bizjak <ubizjak@gmail.com>

Improve atomic update of last_value in pvclock_clocksource_read:

- Atomic update can be skipped if the "last_value" is already
  equal to "ret".

- The detection of atomic update failure is not correct. The value,
  returned by atomic64_cmpxchg should be compared to the old value
  from the location to be updated. If these two are the same, then
  atomic update succeeded and "last_value" location is updated to
  "ret" in an atomic way. Otherwise, the atomic update failed and
  it should be retried with the value from "last_value" - exactly
  what atomic64_try_cmpxchg does in a correct and more optimal way.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20230118202330.3740-1-ubizjak@gmail.com
---
 arch/x86/kernel/pvclock.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
index eda37df016f0..5a2a517dd61b 100644
--- a/arch/x86/kernel/pvclock.c
+++ b/arch/x86/kernel/pvclock.c
@@ -102,10 +102,9 @@ u64 pvclock_clocksource_read(struct pvclock_vcpu_time_info *src)
 	 */
 	last = atomic64_read(&last_value);
 	do {
-		if (ret < last)
+		if (ret <= last)
 			return last;
-		last = atomic64_cmpxchg(&last_value, last, ret);
-	} while (unlikely(last != ret));
+	} while (!atomic64_try_cmpxchg(&last_value, &last, ret));
 
 	return ret;
 }
-- 
2.39.0



