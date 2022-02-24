Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE964C2C10
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 13:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbiBXMtT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 07:49:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiBXMtM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 07:49:12 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E371DDFC8
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 04:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=0nVIPliNZyHIxNDQxCTRWJNwbf48Ug3s4gYRQhvB8B4=; b=hnQzIImsNDJ1jYs9SfN0A9zduN
        S8Ddw0ZY+YKtKNKuYp1CwlEbJc+i7ViROSVwbcZDLXYghj2l4xPIIQhORHrsyVJlszOyZVMtEXhit
        phQiB7/l0oUAmrl8iW2uRHcxJAyF0siMfosJ2WbqdUQ/YGhKuEo9QKiMTvjmQBLzu6vD4Z1BtZNOD
        asce30SKxHQSNTzEzoVVjjVj1rG60rX9DxKRk++jQThvwdRGtnFtnxTDPIBOa+WLiRu2QWR8RlH+q
        Sgw5H+2HQDA6YRpjm1xqLWk2+jhdNtc92HDTy+scWydqTe9G3jk2OTxSB9fx6r1Oig3Rui2An5SU7
        vNyOlWMA==;
Received: from [2001:8b0:10b:1:85c4:81a:fb42:714d] (helo=i7.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXl-00CcQ0-NP; Thu, 24 Feb 2022 12:48:25 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nNDXj-0000ux-PH; Thu, 24 Feb 2022 12:48:23 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Metin Kaya <metikaya@amazon.co.uk>,
        Paul Durrant <pdurrant@amazon.co.uk>
Subject: [PATCH v1 16/16] KVM: x86/xen: Add self tests for KVM_XEN_HVM_CONFIG_EVTCHN_SEND
Date:   Thu, 24 Feb 2022 12:48:19 +0000
Message-Id: <20220224124819.3315-17-dwmw2@infradead.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220224124819.3315-1-dwmw2@infradead.org>
References: <20220224124819.3315-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Woodhouse <dwmw@amazon.co.uk>

Test a combination of event channel send, poll and timer operations.
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 336 +++++++++++++++++-
 1 file changed, 323 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 376c611443cd..6c28846168bb 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -39,12 +39,36 @@
 
 #define EVTCHN_VECTOR	0x10
 
+#define EVTCHN_TEST1 15
+#define EVTCHN_TEST2 66
+#define EVTCHN_TIMER 13
+
 static struct kvm_vm *vm;
 
 #define XEN_HYPERCALL_MSR	0x40000000
 
 #define MIN_STEAL_TIME		50000
 
+#define __HYPERVISOR_set_timer_op	15
+#define __HYPERVISOR_sched_op		29
+#define __HYPERVISOR_event_channel_op	32
+
+#define SCHEDOP_poll			3
+
+#define EVTCHNOP_send			4
+
+#define EVTCHNSTAT_interdomain		2
+
+struct evtchn_send {
+	u32 port;
+};
+
+struct sched_poll {
+	u32 *ports;
+	unsigned int nr_ports;
+	u64 timeout;
+};
+
 struct pvclock_vcpu_time_info {
 	u32   version;
 	u32   pad0;
@@ -107,15 +131,25 @@ struct {
 	struct kvm_irq_routing_entry entries[2];
 } irq_routes;
 
+bool guest_saw_irq;
+
 static void evtchn_handler(struct ex_regs *regs)
 {
 	struct vcpu_info *vi = (void *)VCPU_INFO_VADDR;
 	vi->evtchn_upcall_pending = 0;
 	vi->evtchn_pending_sel = 0;
+	guest_saw_irq = true;
 
 	GUEST_SYNC(0x20);
 }
 
+static void guest_wait_for_irq(void)
+{
+	while (!guest_saw_irq)
+		__asm__ __volatile__ ("rep nop" : : : "memory");
+	guest_saw_irq = false;
+}
+
 static void guest_code(void)
 {
 	struct vcpu_runstate_info *rs = (void *)RUNSTATE_VADDR;
@@ -128,6 +162,8 @@ static void guest_code(void)
 	/* Trigger an interrupt injection */
 	GUEST_SYNC(0);
 
+	guest_wait_for_irq();
+
 	/* Test having the host set runstates manually */
 	GUEST_SYNC(RUNSTATE_runnable);
 	GUEST_ASSERT(rs->time[RUNSTATE_runnable] != 0);
@@ -168,14 +204,130 @@ static void guest_code(void)
 	/* Now deliver an *unmasked* interrupt */
 	GUEST_SYNC(8);
 
-	while (!si->evtchn_pending[1])
-		__asm__ __volatile__ ("rep nop" : : : "memory");
+	guest_wait_for_irq();
 
 	/* Change memslots and deliver an interrupt */
 	GUEST_SYNC(9);
 
-	for (;;)
-		__asm__ __volatile__ ("rep nop" : : : "memory");
+	guest_wait_for_irq();
+
+	/* Deliver event channel with KVM_XEN_HVM_EVTCHN_SEND */
+	GUEST_SYNC(10);
+
+	guest_wait_for_irq();
+
+	GUEST_SYNC(11);
+
+	/* Our turn. Deliver event channel (to ourselves) with
+	 * EVTCHNOP_send hypercall. */
+	unsigned long rax;
+	struct evtchn_send s = { .port = 127 };
+	__asm__ __volatile__ ("vmcall" :
+			      "=a" (rax) :
+			      "a" (__HYPERVISOR_event_channel_op),
+			      "D" (EVTCHNOP_send),
+			      "S" (&s));
+
+	GUEST_ASSERT(rax == 0);
+
+	guest_wait_for_irq();
+
+	GUEST_SYNC(12);
+
+	/* Deliver "outbound" event channel to an eventfd which
+	 * happens to be one of our own irqfds. */
+	s.port = 197;
+	__asm__ __volatile__ ("vmcall" :
+			      "=a" (rax) :
+			      "a" (__HYPERVISOR_event_channel_op),
+			      "D" (EVTCHNOP_send),
+			      "S" (&s));
+
+	GUEST_ASSERT(rax == 0);
+
+	guest_wait_for_irq();
+
+	GUEST_SYNC(13);
+
+	/* Set a timer 100ms in the future. */
+	__asm__ __volatile__ ("vmcall" :
+			      "=a" (rax) :
+			      "a" (__HYPERVISOR_set_timer_op),
+			      "D" (rs->state_entry_time + 100000000));
+	GUEST_ASSERT(rax == 0);
+
+	GUEST_SYNC(14);
+
+	/* Now wait for the timer */
+	guest_wait_for_irq();
+
+	GUEST_SYNC(15);
+
+	/* The host has 'restored' the timer. Just wait for it. */
+	guest_wait_for_irq();
+
+	GUEST_SYNC(16);
+
+	/* Poll for an event channel port which is already set */
+	u32 ports[1] = { EVTCHN_TIMER };
+	struct sched_poll p = {
+		.ports = ports,
+		.nr_ports = 1,
+		.timeout = 0,
+	};
+
+	__asm__ __volatile__ ("vmcall" :
+			      "=a" (rax) :
+			      "a" (__HYPERVISOR_sched_op),
+			      "D" (SCHEDOP_poll),
+			      "S" (&p));
+
+	GUEST_ASSERT(rax == 0);
+
+	GUEST_SYNC(17);
+
+	/* Poll for an unset port and wait for the timeout. */
+	p.timeout = 100000000;
+	__asm__ __volatile__ ("vmcall" :
+			      "=a" (rax) :
+			      "a" (__HYPERVISOR_sched_op),
+			      "D" (SCHEDOP_poll),
+			      "S" (&p));
+
+	GUEST_ASSERT(rax == 0);
+
+	GUEST_SYNC(18);
+
+	/* A host thread will wake the masked port we're waiting on,
+	 * while we poll */
+	p.timeout = 0;
+	__asm__ __volatile__ ("vmcall" :
+			      "=a" (rax) :
+			      "a" (__HYPERVISOR_sched_op),
+			      "D" (SCHEDOP_poll),
+			      "S" (&p));
+
+	GUEST_ASSERT(rax == 0);
+
+	GUEST_SYNC(19);
+
+#if 1
+	/* A host thread will wake an *unmasked* port which should wake
+	 * us with an actual interrupt. */
+	p.timeout = 0;
+	__asm__ __volatile__ ("vmcall" :
+			      "=a" (rax) :
+			      "a" (__HYPERVISOR_sched_op),
+			      "D" (SCHEDOP_poll),
+			      "S" (&p));
+
+	GUEST_ASSERT(rax == 0);
+
+	guest_wait_for_irq();
+#else
+	__asm__ __volatile__ ("hlt");
+#endif
+	GUEST_SYNC(20);
 }
 
 static int cmp_timespec(struct timespec *a, struct timespec *b)
@@ -191,9 +343,13 @@ static int cmp_timespec(struct timespec *a, struct timespec *b)
 	else
 		return 0;
 }
+struct vcpu_info *vinfo;
 
 static void handle_alrm(int sig)
 {
+	if (vinfo)
+		printf("evtchn_upcall_pending 0x%x\n", vinfo->evtchn_upcall_pending);
+	vcpu_dump(stdout, vm, VCPU_ID, 0);
 	TEST_FAIL("IRQ delivery timed out");
 }
 
@@ -213,6 +369,7 @@ int main(int argc, char *argv[])
 
 	bool do_runstate_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_RUNSTATE);
 	bool do_eventfd_tests = !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL);
+	bool do_evtchn_tests = do_eventfd_tests && !!(xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND);
 
 	clock_gettime(CLOCK_REALTIME, &min_ts);
 
@@ -236,7 +393,7 @@ int main(int argc, char *argv[])
 
 	/* Let the kernel know that we *will* use it for sending all
 	 * event channels, which lets it intercept SCHEDOP_poll */
-	if (xen_caps & KVM_XEN_HVM_CONFIG_EVTCHN_SEND)
+	if (do_evtchn_tests)
 		hvmc.flags |= KVM_XEN_HVM_CONFIG_EVTCHN_SEND;
 
 	vm_ioctl(vm, KVM_XEN_HVM_CONFIG, &hvmc);
@@ -301,7 +458,7 @@ int main(int argc, char *argv[])
 
 		/* Unexpected, but not a KVM failure */
 		if (irq_fd[0] == -1 || irq_fd[1] == -1)
-			do_eventfd_tests = false;
+			do_evtchn_tests = do_eventfd_tests = false;
 	}
 
 	if (do_eventfd_tests) {
@@ -309,13 +466,13 @@ int main(int argc, char *argv[])
 
 		irq_routes.entries[0].gsi = 32;
 		irq_routes.entries[0].type = KVM_IRQ_ROUTING_XEN_EVTCHN;
-		irq_routes.entries[0].u.xen_evtchn.port = 15;
+		irq_routes.entries[0].u.xen_evtchn.port = EVTCHN_TEST1;
 		irq_routes.entries[0].u.xen_evtchn.vcpu = VCPU_ID;
 		irq_routes.entries[0].u.xen_evtchn.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
 
 		irq_routes.entries[1].gsi = 33;
 		irq_routes.entries[1].type = KVM_IRQ_ROUTING_XEN_EVTCHN;
-		irq_routes.entries[1].u.xen_evtchn.port = 66;
+		irq_routes.entries[1].u.xen_evtchn.port = EVTCHN_TEST2;
 		irq_routes.entries[1].u.xen_evtchn.vcpu = VCPU_ID;
 		irq_routes.entries[1].u.xen_evtchn.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
 
@@ -336,7 +493,39 @@ int main(int argc, char *argv[])
 		sigaction(SIGALRM, &sa, NULL);
 	}
 
-	struct vcpu_info *vinfo = addr_gpa2hva(vm, VCPU_INFO_VADDR);
+	struct kvm_xen_vcpu_attr tmr = {
+		.type = KVM_XEN_VCPU_ATTR_TYPE_TIMER,
+		.u.timer.port = EVTCHN_TIMER,
+		.u.timer.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL,
+		.u.timer.expires_ns = 0
+	};
+
+	if (do_evtchn_tests) {
+		struct kvm_xen_hvm_attr inj = {
+			.type = KVM_XEN_ATTR_TYPE_EVTCHN,
+			.u.evtchn.send_port = 127,
+			.u.evtchn.type = EVTCHNSTAT_interdomain,
+			.u.evtchn.flags = 0,
+			.u.evtchn.deliver.port.port = EVTCHN_TEST1,
+			.u.evtchn.deliver.port.vcpu = VCPU_ID + 1,
+			.u.evtchn.deliver.port.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL,
+		};
+		vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &inj);
+
+		/* Test migration to a different vCPU */
+		inj.u.evtchn.flags = KVM_XEN_EVTCHN_UPDATE;
+		inj.u.evtchn.deliver.port.vcpu = VCPU_ID;
+		vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &inj);
+
+		inj.u.evtchn.send_port = 197;
+		inj.u.evtchn.deliver.eventfd.port = 0;
+		inj.u.evtchn.deliver.eventfd.fd = irq_fd[1];
+		inj.u.evtchn.flags = 0;
+		vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &inj);
+
+		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+	}
+	vinfo = addr_gpa2hva(vm, VCPU_INFO_VADDR);
 	vinfo->evtchn_upcall_pending = 0;
 
 	struct vcpu_runstate_info *rs = addr_gpa2hva(vm, RUNSTATE_ADDR);
@@ -429,7 +618,7 @@ int main(int argc, char *argv[])
 					goto done;
 				if (verbose)
 					printf("Testing masked event channel\n");
-				shinfo->evtchn_mask[0] = 0x8000;
+				shinfo->evtchn_mask[0] = 1UL << EVTCHN_TEST1;
 				eventfd_write(irq_fd[0], 1UL);
 				alarm(1);
 				break;
@@ -446,6 +635,9 @@ int main(int argc, char *argv[])
 				break;
 
 			case 9:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+				shinfo->evtchn_pending[1] = 0;
 				if (verbose)
 					printf("Testing event channel after memslot change\n");
 				vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
@@ -455,12 +647,129 @@ int main(int argc, char *argv[])
 				alarm(1);
 				break;
 
+			case 10:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+				if (!do_evtchn_tests)
+					goto done;
+
+				shinfo->evtchn_pending[0] = 0;
+				if (verbose)
+					printf("Testing injection with KVM_XEN_HVM_EVTCHN_SEND\n");
+
+				struct kvm_irq_routing_xen_evtchn e;
+				e.port = EVTCHN_TEST2;
+				e.vcpu = VCPU_ID;
+				e.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
+
+				vm_ioctl(vm, KVM_XEN_HVM_EVTCHN_SEND, &e);
+				evtchn_irq_expected = true;
+				alarm(1);
+				break;
+
+			case 11:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+				shinfo->evtchn_pending[1] = 0;
+
+				if (verbose)
+					printf("Testing guest EVTCHNOP_send direct to evtchn\n");
+				evtchn_irq_expected = true;
+				alarm(1);
+				break;
+
+			case 12:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+				shinfo->evtchn_pending[0] = 0;
+
+				if (verbose)
+					printf("Testing guest EVTCHNOP_send to eventfd\n");
+				evtchn_irq_expected = true;
+				alarm(1);
+				break;
+
+			case 13:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+				shinfo->evtchn_pending[1] = 0;
+
+				if (verbose)
+					printf("Testing guest oneshot timer\n");
+				break;
+
+			case 14:
+				memset(&tmr, 0, sizeof(tmr));
+				tmr.type = KVM_XEN_VCPU_ATTR_TYPE_TIMER,
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &tmr);
+				TEST_ASSERT(tmr.u.timer.port == EVTCHN_TIMER,
+					    "Timer port not returned");
+				TEST_ASSERT(tmr.u.timer.priority == KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL,
+					    "Timer priority not returned");
+				TEST_ASSERT(tmr.u.timer.expires_ns > rs->state_entry_time,
+					    "Timer expiry not returned");
+				evtchn_irq_expected = true;
+				alarm(1);
+				break;
+
+			case 15:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+				shinfo->evtchn_pending[0] = 0;
+
+				if (verbose)
+					printf("Testing restored oneshot timer\n");
+
+				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				evtchn_irq_expected = true;
+				alarm(1);
+				break;
+
+			case 16:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+
+				if (verbose)
+					printf("Testing SCHEDOP_poll with already pending event\n");
+				shinfo->evtchn_pending[0] = shinfo->evtchn_mask[0] = 1UL << EVTCHN_TIMER;
+				alarm(1);
+				break;
+
+			case 17:
+				if (verbose)
+					printf("Testing SCHEDOP_poll timeout\n");
+				shinfo->evtchn_pending[0] = 0;
+				alarm(1);
+				break;
+
+			case 18:
+				if (verbose)
+					printf("Testing SCHEDOP_poll wake on masked event\n");
+
+				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				break;
+
+			case 19:
+				shinfo->evtchn_pending[0] = shinfo->evtchn_mask[0] = 0;
+				if (verbose)
+					printf("Testing SCHEDOP_poll wake on unmasked event\n");
+
+				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
+				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				evtchn_irq_expected = true;
+				break;
+
+			case 20:
+				TEST_ASSERT(!evtchn_irq_expected,
+					    "Expected event channel IRQ but it didn't happen");
+				shinfo->evtchn_pending[1] = 0;
+				goto done;
+
 			case 0x20:
 				TEST_ASSERT(evtchn_irq_expected, "Unexpected event channel IRQ");
 				evtchn_irq_expected = false;
-				if (shinfo->evtchn_pending[1] &&
-				    shinfo->evtchn_pending[0])
-					goto done;
 				break;
 			}
 			break;
@@ -473,6 +782,7 @@ int main(int argc, char *argv[])
 	}
 
  done:
+	alarm(0);
 	clock_gettime(CLOCK_REALTIME, &max_ts);
 
 	/*
-- 
2.33.1

