Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140C360FCDA
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236593AbiJ0QTV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236560AbiJ0QS6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:18:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E4E196B5C
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666887536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QaDAbir+sBpdMoPRaLpYkTZYt9qrVnwqD4RdJh4hW+c=;
        b=KbDJzn0SwKuPPWGXKYNlDOcGZOriX+d27vusQF2DyB+okx5SdhJBP1f4lvvyxTMPNfUkLa
        g1iwzZkF49M5kJHb0IdRxq7bjhaiOzuE+sILac8Je7jFgtqxBwcVXN4NmGVepfDkX9mMr9
        yxOHb8MbclqGxHW0pTUtTgfSCYlE6H0=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-oPKGmDcSNq2tSVS_9m5HIQ-1; Thu, 27 Oct 2022 12:18:54 -0400
X-MC-Unique: oPKGmDcSNq2tSVS_9m5HIQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1E6433C0F66F;
        Thu, 27 Oct 2022 16:18:53 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECBAB17593;
        Thu, 27 Oct 2022 16:18:52 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mhal@rbox.co, seanjc@google.com
Subject: [PATCH 15/16] KVM: selftests: Add tests in xen_shinfo_test to detect lock races
Date:   Thu, 27 Oct 2022 12:18:48 -0400
Message-Id: <20221027161849.2989332-16-pbonzini@redhat.com>
In-Reply-To: <20221027161849.2989332-1-pbonzini@redhat.com>
References: <20221027161849.2989332-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
Message-Id: <20221013211234.1318131-16-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
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
2.31.1


