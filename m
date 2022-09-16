Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC075BA3A4
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 02:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbiIPA46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Sep 2022 20:56:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiIPA4v (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Sep 2022 20:56:51 -0400
Received: from mailtransmit05.runbox.com (mailtransmit05.runbox.com [IPv6:2a0c:5a00:149::26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9353A87093
        for <kvm@vger.kernel.org>; Thu, 15 Sep 2022 17:56:49 -0700 (PDT)
Received: from mailtransmit03.runbox ([10.9.9.163] helo=aibo.runbox.com)
        by mailtransmit05.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1oYzex-002MaJ-Fj; Fri, 16 Sep 2022 02:56:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector2; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From;
        bh=pVzXpaXDSDHEEaUsmfZGNgJPHujvG8xpnGs717iqlTg=; b=W8wILLDWuf1Egok34vV8uGzPkF
        PIxL5OxKH8augv4P20QEQOOV7UJKCL+wP/ed9EuRJS7Zowvv93cf4a26PwJMLYVKOOpt1PUP8i5xo
        /vnhVnD2kXAAinshFkEArgOGOBIKo+tjEhN19D/ockd+JGUQEv73XGk6MQ8T/0eqO54kJYZV5VZSY
        M4w9SkNxeTxJhAyJ0gKkyMdzhJuM93VD3uaE3gmthreneRMK2JSnB/qW0blqYv0WZWer25ARKU5s3
        321B4mbjGnLTukLq6t+ZRbelRjB/96vHdB9C6JG4/E7A60FXt7QGgOmrnhmnooTKlNa581Aolt2a4
        qo6b8Nzw==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit03.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1oYzex-00081N-7W; Fri, 16 Sep 2022 02:56:47 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1oYzel-0000xy-Cr; Fri, 16 Sep 2022 02:56:35 +0200
From:   Michal Luczaj <mhal@rbox.co>
To:     kvm@vger.kernel.org
Cc:     seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
        Michal Luczaj <mhal@rbox.co>
Subject: [RFC PATCH 4/4] KVM: x86/xen: Test shinfo_cache lock races
Date:   Fri, 16 Sep 2022 02:54:05 +0200
Message-Id: <20220916005405.2362180-5-mhal@rbox.co>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220916005405.2362180-1-mhal@rbox.co>
References: <20220916005405.2362180-1-mhal@rbox.co>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Tests for races between shinfo_cache initialization/destruction
(causing lock reinitialization) and hypercall/ioctl processing
(acquiring uninitialized lock, holding soon-to-be-corrupted lock).

Signed-off-by: Michal Luczaj <mhal@rbox.co>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 100 ++++++++++++++++++
 1 file changed, 100 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 8a5cb800f50e..8e251b2bfa62 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -15,9 +15,13 @@
 #include <time.h>
 #include <sched.h>
 #include <signal.h>
+#include <pthread.h>
 
 #include <sys/eventfd.h>
 
+/* Defined in include/linux/kvm_types.h */
+#define GPA_INVALID		(~(ulong)0)
+
 #define SHINFO_REGION_GVA	0xc0000000ULL
 #define SHINFO_REGION_GPA	0xc0000000ULL
 #define SHINFO_REGION_SLOT	10
@@ -44,6 +48,8 @@
 
 #define MIN_STEAL_TIME		50000
 
+#define SHINFO_RACE_TIMEOUT	2	/* seconds */
+
 #define __HYPERVISOR_set_timer_op	15
 #define __HYPERVISOR_sched_op		29
 #define __HYPERVISOR_event_channel_op	32
@@ -325,6 +331,32 @@ static void guest_code(void)
 	guest_wait_for_irq();
 
 	GUEST_SYNC(21);
+	/* Racing host ioctls */
+
+	guest_wait_for_irq();
+
+	GUEST_SYNC(22);
+	/* Racing vmcall against host ioctl */
+
+	ports[0] = 0;
+
+	p = (struct sched_poll) {
+		.ports = ports,
+		.nr_ports = 1,
+		.timeout = 0
+	};
+
+	do {
+		asm volatile("vmcall"
+			     : "=a" (rax)
+			     : "a" (__HYPERVISOR_sched_op),
+			       "D" (SCHEDOP_poll),
+			       "S" (&p)
+			     : "memory");
+	} while (!guest_saw_irq);
+	guest_saw_irq = false;
+
+	GUEST_SYNC(23);
 }
 
 static int cmp_timespec(struct timespec *a, struct timespec *b)
@@ -352,11 +384,36 @@ static void handle_alrm(int sig)
 	TEST_FAIL("IRQ delivery timed out");
 }
 
+static void *juggle_shinfo_state(void *arg)
+{
+	struct kvm_vm *vm = (struct kvm_vm *)arg;
+
+	struct kvm_xen_hvm_attr cache_init = {
+		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
+		.u.shared_info.gfn = SHINFO_REGION_GPA / PAGE_SIZE
+	};
+
+	struct kvm_xen_hvm_attr cache_destroy = {
+		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
+		.u.shared_info.gfn = GPA_INVALID
+	};
+
+	for (;;) {
+		__vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &cache_init);
+		__vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &cache_destroy);
+		pthread_testcancel();
+	};
+
+	return NULL;
+}
+
 int main(int argc, char *argv[])
 {
 	struct timespec min_ts, max_ts, vm_ts;
 	struct kvm_vm *vm;
+	pthread_t thread;
 	bool verbose;
+	int ret;
 
 	verbose = argc > 1 && (!strncmp(argv[1], "-v", 3) ||
 			       !strncmp(argv[1], "--verbose", 10));
@@ -785,6 +842,49 @@ int main(int argc, char *argv[])
 			case 21:
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
+				alarm(0);
+
+				if (verbose)
+					printf("Testing shinfo lock corruption (KVM_XEN_HVM_EVTCHN_SEND)\n");
+
+				ret = pthread_create(&thread, NULL, &juggle_shinfo_state, (void *)vm);
+				TEST_ASSERT(ret == 0, "pthread_create() failed: %s", strerror(ret));
+
+				struct kvm_irq_routing_xen_evtchn uxe = {
+					.port = 1,
+					.vcpu = vcpu->id,
+					.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL
+				};
+
+				evtchn_irq_expected = true;
+				for (time_t t = time(NULL) + SHINFO_RACE_TIMEOUT; time(NULL) < t;)
+					__vm_ioctl(vm, KVM_XEN_HVM_EVTCHN_SEND, &uxe);
+				break;
+
+			case 22:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+
+				if (verbose)
+					printf("Testing shinfo lock corruption (SCHEDOP_poll)\n");
+
+				shinfo->evtchn_pending[0] = 1;
+
+				evtchn_irq_expected = true;
+				tmr.u.timer.expires_ns = rs->state_entry_time +
+							 SHINFO_RACE_TIMEOUT * 1000000000ULL;
+				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				break;
+
+			case 23:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+
+				ret = pthread_cancel(thread);
+				TEST_ASSERT(ret == 0, "pthread_cancel() failed: %s", strerror(ret));
+
+				ret = pthread_join(thread, 0);
+				TEST_ASSERT(ret == 0, "pthread_join() failed: %s", strerror(ret));
 				goto done;
 
 			case 0x20:
-- 
2.37.2

