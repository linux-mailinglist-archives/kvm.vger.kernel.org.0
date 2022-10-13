Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF885FE40C
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiJMVO5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbiJMVOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:14:00 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D151905FC
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:48 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id q18-20020aa79832000000b00562d921e30aso1784868pfl.4
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Dkze2MsJxqCmAbWDzZZK4VGavXQgqa2AUGiiGVa6HH8=;
        b=dZitK4lqU/S7tVoHB8Mi0JBvY83jA7BnacPckZSLugRBTK18I4x1RwkdgfzTmSC3hn
         udH1dus/1z2gLr0+/SkrgyETcBI2rYFPqWw3Ugj8ESy09L4AhX30XhBz143NL32L/+Y+
         nPk1wmmfLm7/ZlbmT+p3UaxDixhUXMWnXAaOheZ1bkUvnwLtBUkBPbkGk96caBpHEseU
         4LKFkINsOUoLIBwemofF9VjepfzobAoNTNcsU0nwoPOJcAzD2bHcY3GXWjCoE50jpcit
         joA1lC2tulYrEo/kTriQE8scZzL0HUNH7uC+Jfuz097eee1UFXhdyr6+/RGFF9jAiF/G
         LoRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Dkze2MsJxqCmAbWDzZZK4VGavXQgqa2AUGiiGVa6HH8=;
        b=rjjq1GrTpoA+OWSfIQeJ1SHbIYDMkiQcQxgPXpoatDxjxdz4k9bVqhtFbe5E7sOTer
         fyMMByQBK2jtF/J+w4HJbMmVwiLgTnSTJBg2bFXL5Is/cxbY9o5J6jD1uJ22WoUHZGtJ
         3Wbe7a1lGSQy3cNRcUjSvGJaesm63lJ8cW65wkAW4EqiiFnK3GUYDYC7uG1FsMkQS7B1
         cKXhnMdBSAvq0bw1yQP1nddXNcELBrs8ZrL+tzB/iSAqwn9WEAarCIT1+A0anoes37Nl
         aaBex76Tb2ObsId/fxgylgRMTQMKQkPXUVXOoOAAvrN+M5Sfh9P/exrB2Sn/6RBvh6ZD
         ZTlw==
X-Gm-Message-State: ACrzQf1MCuz1fPKA7hNQBTvSSzyIHl1SyhGmCTTc0ZHwT5XUctlPgBuO
        ZmFHiw79p9FtoK67zzYVEU4dsYesNI8=
X-Google-Smtp-Source: AMsMyM4vrnK/wcheMWW3HQKHNgeiPWMqXEmimKvHDB7d0xYox77M0n9vUcsCD7v60VP/Q3hfKZrGRvYn3ag=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:fe97:b0:20a:fee1:8f69 with SMTP id
 co23-20020a17090afe9700b0020afee18f69mr114235pjb.0.1665695584064; Thu, 13 Oct
 2022 14:13:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:33 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-16-seanjc@google.com>
Subject: [PATCH v2 15/16] KVM: selftests: Add tests in xen_shinfo_test to
 detect lock races
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Luczaj <mhal@rbox.co>

Tests for races between shinfo_cache (de)activation and hypercall+ioctl()
processing.  KVM has had bugs where activating the shared info cache
multiple times and/or with concurrent users results in lock corruption,
NULL pointer dereferences, and other fun.

For the timer injection testcase (#22), re-arm the timer until the IRQ
is successfully injected.  If the timer expires while the shared info
is deactivated (invalid), KVM will drop the event.

Signed-off-by: Michal Luczaj <mhal@rbox.co>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 140 ++++++++++++++++++
 1 file changed, 140 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 8a5cb800f50e..caa3f5ab9e10 100644
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
@@ -148,6 +154,7 @@ static void guest_wait_for_irq(void)
 static void guest_code(void)
 {
 	struct vcpu_runstate_info *rs = (void *)RUNSTATE_VADDR;
+	int i;
 
 	__asm__ __volatile__(
 		"sti\n"
@@ -325,6 +332,49 @@ static void guest_code(void)
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
+wait_for_timer:
+	/*
+	 * Poll for a timer wake event while the worker thread is mucking with
+	 * the shared info.  KVM XEN drops timer IRQs if the shared info is
+	 * invalid when the timer expires.  Arbitrarily poll 100 times before
+	 * giving up and asking the VMM to re-arm the timer.  100 polls should
+	 * consume enough time to beat on KVM without taking too long if the
+	 * timer IRQ is dropped due to an invalid event channel.
+	 */
+	for (i = 0; i < 100 && !guest_saw_irq; i++)
+		asm volatile("vmcall"
+			     : "=a" (rax)
+			     : "a" (__HYPERVISOR_sched_op),
+			       "D" (SCHEDOP_poll),
+			       "S" (&p)
+			     : "memory");
+
+	/*
+	 * Re-send the timer IRQ if it was (likely) dropped due to the timer
+	 * expiring while the event channel was invalid.
+	 */
+	if (!guest_saw_irq) {
+		GUEST_SYNC(23);
+		goto wait_for_timer;
+	}
+	guest_saw_irq = false;
+
+	GUEST_SYNC(24);
 }
 
 static int cmp_timespec(struct timespec *a, struct timespec *b)
@@ -352,11 +402,36 @@ static void handle_alrm(int sig)
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
@@ -785,6 +860,71 @@ int main(int argc, char *argv[])
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
+				/*
+				 * Optional and possibly repeated sync point.
+				 * Injecting the timer IRQ may fail if the
+				 * shinfo is invalid when the timer expires.
+				 * If the timer has expired but the IRQ hasn't
+				 * been delivered, rearm the timer and retry.
+				 */
+				vcpu_ioctl(vcpu, KVM_XEN_VCPU_GET_ATTR, &tmr);
+
+				/* Resume the guest if the timer is still pending. */
+				if (tmr.u.timer.expires_ns)
+					break;
+
+				/* All done if the IRQ was delivered. */
+				if (!evtchn_irq_expected)
+					break;
+
+				tmr.u.timer.expires_ns = rs->state_entry_time +
+							 SHINFO_RACE_TIMEOUT * 1000000000ULL;
+				vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				break;
+			case 24:
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
2.38.0.413.g74048e4d9e-goog

