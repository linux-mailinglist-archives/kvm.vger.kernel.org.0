Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22B0B6697E2
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 14:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232671AbjAMNA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 08:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjAMNAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 08:00:23 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631C987F28;
        Fri, 13 Jan 2023 04:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=wkWLpFL+OkHTssqQlChcP/ogEtXFmexNorVbbHRu06Q=; b=bHmT5lUf9yDobKK0lXa6jdqy+3
        8c9xtr+i44TfoTJywqVGdyoIOIKfdpoFM3dBKAPmtbLstxjcFz7EgoH6fZ421qHHQtuqhysi4bcSK
        s5LrxgMPpagXC8aLCbDe50BbDDAL7wcwXndvwPIB7v71SJLeQQQLEHkArBJupHI+L/Kzu+wAzFDXe
        XR4UKkPivykXiME2tstLBKS7h9jiu77wu83XUYiSRxPySE/jQ2mg/d7YYy6IhZoptOn5L0CBe65zo
        wjhI+nJ5ncrl43OgK/jiLEnGvC6/y65JqBCiv9RFJUMhrf7OcyjyTG2d2slelOFH0MbcjMcaSKsa9
        Mi95KVUw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pGJRd-004Mhz-0t;
        Fri, 13 Jan 2023 12:46:05 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pGJRl-0002jm-HC; Fri, 13 Jan 2023 12:46:13 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org,
        rcu@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Waiman Long <longman@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>, seanjc@google.com,
        Joel Fernandes <joel@joelfernandes.org>,
        Matthew Wilcox <willy@infradead.org>,
        Michal Luczaj <mhal@rbox.co>
Subject: [PATCH 2/3] KVM: selftests: Use enum for test numbers in xen_shinfo_test
Date:   Fri, 13 Jan 2023 12:46:05 +0000
Message-Id: <20230113124606.10221-3-dwmw2@infradead.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230113124606.10221-1-dwmw2@infradead.org>
References: <20230113065955.815667-1-boqun.feng@gmail.com>
 <20230113124606.10221-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

The xen_shinfo_test started off with very few iterations, and the numbers
we used in GUEST_SYNC() were precisely mapped to the RUNSTATE_xxx values
anyway to start with.

It has since grown quite a few more tests, and it's kind of awful to be
handling them all as bare numbers. Especially when I want to add a new
test in the middle. Define an enum for the test stages, and use it both
in the guest code and the host switch statement.

No functional change, if I can count to 24.

Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 134 +++++++++++-------
 1 file changed, 83 insertions(+), 51 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 721f6a693799..644d614a9965 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -44,6 +44,36 @@
 #define EVTCHN_TEST2 66
 #define EVTCHN_TIMER 13
 
+enum {
+	TEST_INJECT_VECTOR = 0,
+	TEST_RUNSTATE_runnable,
+	TEST_RUNSTATE_blocked,
+	TEST_RUNSTATE_offline,
+	TEST_RUNSTATE_ADJUST,
+	TEST_RUNSTATE_DATA,
+	TEST_STEAL_TIME,
+	TEST_EVTCHN_MASKED,
+	TEST_EVTCHN_UNMASKED,
+	TEST_EVTCHN_SLOWPATH,
+	TEST_EVTCHN_SEND_IOCTL,
+	TEST_EVTCHN_HCALL,
+	TEST_EVTCHN_HCALL_EVENTFD,
+	TEST_TIMER_SETUP,
+	TEST_TIMER_WAIT,
+	TEST_TIMER_RESTORE,
+	TEST_POLL_READY,
+	TEST_POLL_TIMEOUT,
+	TEST_POLL_MASKED,
+	TEST_POLL_WAKE,
+	TEST_TIMER_PAST,
+	TEST_LOCKING_SEND_RACE,
+	TEST_LOCKING_POLL_RACE,
+	TEST_LOCKING_POLL_TIMEOUT,
+	TEST_DONE,
+
+	TEST_GUEST_SAW_IRQ,
+};
+
 #define XEN_HYPERCALL_MSR	0x40000000
 
 #define MIN_STEAL_TIME		50000
@@ -147,7 +177,7 @@ static void evtchn_handler(struct ex_regs *regs)
 	vi->evtchn_pending_sel = 0;
 	guest_saw_irq = true;
 
-	GUEST_SYNC(0x20);
+	GUEST_SYNC(TEST_GUEST_SAW_IRQ);
 }
 
 static void guest_wait_for_irq(void)
@@ -168,41 +198,41 @@ static void guest_code(void)
 	);
 
 	/* Trigger an interrupt injection */
-	GUEST_SYNC(0);
+	GUEST_SYNC(TEST_INJECT_VECTOR);
 
 	guest_wait_for_irq();
 
 	/* Test having the host set runstates manually */
-	GUEST_SYNC(RUNSTATE_runnable);
+	GUEST_SYNC(TEST_RUNSTATE_runnable);
 	GUEST_ASSERT(rs->time[RUNSTATE_runnable] != 0);
 	GUEST_ASSERT(rs->state == 0);
 
-	GUEST_SYNC(RUNSTATE_blocked);
+	GUEST_SYNC(TEST_RUNSTATE_blocked);
 	GUEST_ASSERT(rs->time[RUNSTATE_blocked] != 0);
 	GUEST_ASSERT(rs->state == 0);
 
-	GUEST_SYNC(RUNSTATE_offline);
+	GUEST_SYNC(TEST_RUNSTATE_offline);
 	GUEST_ASSERT(rs->time[RUNSTATE_offline] != 0);
 	GUEST_ASSERT(rs->state == 0);
 
 	/* Test runstate time adjust */
-	GUEST_SYNC(4);
+	GUEST_SYNC(TEST_RUNSTATE_ADJUST);
 	GUEST_ASSERT(rs->time[RUNSTATE_blocked] == 0x5a);
 	GUEST_ASSERT(rs->time[RUNSTATE_offline] == 0x6b6b);
 
 	/* Test runstate time set */
-	GUEST_SYNC(5);
+	GUEST_SYNC(TEST_RUNSTATE_DATA);
 	GUEST_ASSERT(rs->state_entry_time >= 0x8000);
 	GUEST_ASSERT(rs->time[RUNSTATE_runnable] == 0);
 	GUEST_ASSERT(rs->time[RUNSTATE_blocked] == 0x6b6b);
 	GUEST_ASSERT(rs->time[RUNSTATE_offline] == 0x5a);
 
 	/* sched_yield() should result in some 'runnable' time */
-	GUEST_SYNC(6);
+	GUEST_SYNC(TEST_STEAL_TIME);
 	GUEST_ASSERT(rs->time[RUNSTATE_runnable] >= MIN_STEAL_TIME);
 
 	/* Attempt to deliver a *masked* interrupt */
-	GUEST_SYNC(7);
+	GUEST_SYNC(TEST_EVTCHN_MASKED);
 
 	/* Wait until we see the bit set */
 	struct shared_info *si = (void *)SHINFO_VADDR;
@@ -210,21 +240,21 @@ static void guest_code(void)
 		__asm__ __volatile__ ("rep nop" : : : "memory");
 
 	/* Now deliver an *unmasked* interrupt */
-	GUEST_SYNC(8);
+	GUEST_SYNC(TEST_EVTCHN_UNMASKED);
 
 	guest_wait_for_irq();
 
 	/* Change memslots and deliver an interrupt */
-	GUEST_SYNC(9);
+	GUEST_SYNC(TEST_EVTCHN_SLOWPATH);
 
 	guest_wait_for_irq();
 
 	/* Deliver event channel with KVM_XEN_HVM_EVTCHN_SEND */
-	GUEST_SYNC(10);
+	GUEST_SYNC(TEST_EVTCHN_SEND_IOCTL);
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(11);
+	GUEST_SYNC(TEST_EVTCHN_HCALL);
 
 	/* Our turn. Deliver event channel (to ourselves) with
 	 * EVTCHNOP_send hypercall. */
@@ -240,7 +270,7 @@ static void guest_code(void)
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(12);
+	GUEST_SYNC(TEST_EVTCHN_HCALL_EVENTFD);
 
 	/* Deliver "outbound" event channel to an eventfd which
 	 * happens to be one of our own irqfds. */
@@ -255,7 +285,7 @@ static void guest_code(void)
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(13);
+	GUEST_SYNC(TEST_TIMER_SETUP);
 
 	/* Set a timer 100ms in the future. */
 	__asm__ __volatile__ ("vmcall" :
@@ -264,17 +294,17 @@ static void guest_code(void)
 			      "D" (rs->state_entry_time + 100000000));
 	GUEST_ASSERT(rax == 0);
 
-	GUEST_SYNC(14);
+	GUEST_SYNC(TEST_TIMER_WAIT);
 
 	/* Now wait for the timer */
 	guest_wait_for_irq();
 
-	GUEST_SYNC(15);
+	GUEST_SYNC(TEST_TIMER_RESTORE);
 
 	/* The host has 'restored' the timer. Just wait for it. */
 	guest_wait_for_irq();
 
-	GUEST_SYNC(16);
+	GUEST_SYNC(TEST_POLL_READY);
 
 	/* Poll for an event channel port which is already set */
 	u32 ports[1] = { EVTCHN_TIMER };
@@ -292,7 +322,7 @@ static void guest_code(void)
 
 	GUEST_ASSERT(rax == 0);
 
-	GUEST_SYNC(17);
+	GUEST_SYNC(TEST_POLL_TIMEOUT);
 
 	/* Poll for an unset port and wait for the timeout. */
 	p.timeout = 100000000;
@@ -304,7 +334,7 @@ static void guest_code(void)
 
 	GUEST_ASSERT(rax == 0);
 
-	GUEST_SYNC(18);
+	GUEST_SYNC(TEST_POLL_MASKED);
 
 	/* A timer will wake the masked port we're waiting on, while we poll */
 	p.timeout = 0;
@@ -316,7 +346,7 @@ static void guest_code(void)
 
 	GUEST_ASSERT(rax == 0);
 
-	GUEST_SYNC(19);
+	GUEST_SYNC(TEST_POLL_WAKE);
 
 	/* A timer wake an *unmasked* port which should wake us with an
 	 * actual interrupt, while we're polling on a different port. */
@@ -332,17 +362,17 @@ static void guest_code(void)
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(20);
+	GUEST_SYNC(TEST_TIMER_PAST);
 
 	/* Timer should have fired already */
 	guest_wait_for_irq();
 
-	GUEST_SYNC(21);
+	GUEST_SYNC(TEST_LOCKING_SEND_RACE);
 	/* Racing host ioctls */
 
 	guest_wait_for_irq();
 
-	GUEST_SYNC(22);
+	GUEST_SYNC(TEST_LOCKING_POLL_RACE);
 	/* Racing vmcall against host ioctl */
 
 	ports[0] = 0;
@@ -375,12 +405,12 @@ static void guest_code(void)
 	 * expiring while the event channel was invalid.
 	 */
 	if (!guest_saw_irq) {
-		GUEST_SYNC(23);
+		GUEST_SYNC(TEST_LOCKING_POLL_TIMEOUT);
 		goto wait_for_timer;
 	}
 	guest_saw_irq = false;
 
-	GUEST_SYNC(24);
+	GUEST_SYNC(TEST_DONE);
 }
 
 static int cmp_timespec(struct timespec *a, struct timespec *b)
@@ -439,6 +469,7 @@ int main(int argc, char *argv[])
 	bool verbose;
 	int ret;
 
+	printf("TEST_DONE is %d\n", TEST_DONE);
 	verbose = argc > 1 && (!strncmp(argv[1], "-v", 3) ||
 			       !strncmp(argv[1], "--verbose", 10));
 
@@ -649,25 +680,26 @@ int main(int argc, char *argv[])
 					    "runstate times don't add up");
 
 			switch (uc.args[1]) {
-			case 0:
+			case TEST_INJECT_VECTOR:
 				if (verbose)
 					printf("Delivering evtchn upcall\n");
 				evtchn_irq_expected = true;
 				vinfo->evtchn_upcall_pending = 1;
 				break;
 
-			case RUNSTATE_runnable...RUNSTATE_offline:
+			case TEST_RUNSTATE_runnable...TEST_RUNSTATE_offline:
 				TEST_ASSERT(!evtchn_irq_expected, "Event channel IRQ not seen");
 				if (!do_runstate_tests)
 					goto done;
 				if (verbose)
 					printf("Testing runstate %s\n", runstate_names[uc.args[1]]);
 				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT;
-				rst.u.runstate.state = uc.args[1];
+				rst.u.runstate.state = uc.args[1] + RUNSTATE_runnable -
+					TEST_RUNSTATE_runnable;
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &rst);
 				break;
 
-			case 4:
+			case TEST_RUNSTATE_ADJUST:
 				if (verbose)
 					printf("Testing RUNSTATE_ADJUST\n");
 				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADJUST;
@@ -682,7 +714,7 @@ int main(int argc, char *argv[])
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &rst);
 				break;
 
-			case 5:
+			case TEST_RUNSTATE_DATA:
 				if (verbose)
 					printf("Testing RUNSTATE_DATA\n");
 				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA;
@@ -694,7 +726,7 @@ int main(int argc, char *argv[])
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &rst);
 				break;
 
-			case 6:
+			case TEST_STEAL_TIME:
 				if (verbose)
 					printf("Testing steal time\n");
 				/* Yield until scheduler delay exceeds target */
@@ -704,7 +736,7 @@ int main(int argc, char *argv[])
 				} while (get_run_delay() < rundelay);
 				break;
 
-			case 7:
+			case TEST_EVTCHN_MASKED:
 				if (!do_eventfd_tests)
 					goto done;
 				if (verbose)
@@ -714,7 +746,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 8:
+			case TEST_EVTCHN_UNMASKED:
 				if (verbose)
 					printf("Testing unmasked event channel\n");
 				/* Unmask that, but deliver the other one */
@@ -725,7 +757,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 9:
+			case TEST_EVTCHN_SLOWPATH:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[1] = 0;
@@ -738,7 +770,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 10:
+			case TEST_EVTCHN_SEND_IOCTL:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				if (!do_evtchn_tests)
@@ -758,7 +790,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 11:
+			case TEST_EVTCHN_HCALL:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[1] = 0;
@@ -769,7 +801,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 12:
+			case TEST_EVTCHN_HCALL_EVENTFD:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[0] = 0;
@@ -780,7 +812,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 13:
+			case TEST_TIMER_SETUP:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[1] = 0;
@@ -789,7 +821,7 @@ int main(int argc, char *argv[])
 					printf("Testing guest oneshot timer\n");
 				break;
 
-			case 14:
+			case TEST_TIMER_WAIT:
 				memset(&tmr, 0, sizeof(tmr));
 				tmr.type = KVM_XEN_VCPU_ATTR_TYPE_TIMER;
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_GET_ATTR, &tmr);
@@ -803,7 +835,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 15:
+			case TEST_TIMER_RESTORE:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				shinfo->evtchn_pending[0] = 0;
@@ -817,7 +849,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 16:
+			case TEST_POLL_READY:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 
@@ -827,14 +859,14 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 17:
+			case TEST_POLL_TIMEOUT:
 				if (verbose)
 					printf("Testing SCHEDOP_poll timeout\n");
 				shinfo->evtchn_pending[0] = 0;
 				alarm(1);
 				break;
 
-			case 18:
+			case TEST_POLL_MASKED:
 				if (verbose)
 					printf("Testing SCHEDOP_poll wake on masked event\n");
 
@@ -843,7 +875,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 19:
+			case TEST_POLL_WAKE:
 				shinfo->evtchn_pending[0] = shinfo->evtchn_mask[0] = 0;
 				if (verbose)
 					printf("Testing SCHEDOP_poll wake on unmasked event\n");
@@ -860,7 +892,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 20:
+			case TEST_TIMER_PAST:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				/* Read timer and check it is no longer pending */
@@ -877,7 +909,7 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
-			case 21:
+			case TEST_LOCKING_SEND_RACE:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				alarm(0);
@@ -899,7 +931,7 @@ int main(int argc, char *argv[])
 					__vm_ioctl(vm, KVM_XEN_HVM_EVTCHN_SEND, &uxe);
 				break;
 
-			case 22:
+			case TEST_LOCKING_POLL_RACE:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 
@@ -914,7 +946,7 @@ int main(int argc, char *argv[])
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				break;
 
-			case 23:
+			case TEST_LOCKING_POLL_TIMEOUT:
 				/*
 				 * Optional and possibly repeated sync point.
 				 * Injecting the timer IRQ may fail if the
@@ -936,7 +968,7 @@ int main(int argc, char *argv[])
 							 SHINFO_RACE_TIMEOUT * 1000000000ULL;
 				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				break;
-			case 24:
+			case TEST_DONE:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 
@@ -947,7 +979,7 @@ int main(int argc, char *argv[])
 				TEST_ASSERT(ret == 0, "pthread_join() failed: %s", strerror(ret));
 				goto done;
 
-			case 0x20:
+			case TEST_GUEST_SAW_IRQ:
 				TEST_ASSERT(evtchn_irq_expected, "Unexpected event channel IRQ");
 				evtchn_irq_expected = false;
 				break;
-- 
2.35.3

