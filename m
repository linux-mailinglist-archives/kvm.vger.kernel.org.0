Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E5065A095
	for <lists+kvm@lfdr.de>; Sat, 31 Dec 2022 02:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbiLaB1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 20:27:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236085AbiLaB1b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 20:27:31 -0500
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B17A1DF2B
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 17:27:28 -0800 (PST)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1pBQeS-004pYb-EE; Sat, 31 Dec 2022 02:27:08 +0100
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=nlpVX1Sbmsf5z+yXMCFhtrvbAQrJwqCTOEWddreTX+o=; b=J4LnD1nJiK47slObC/Fh0UQdNn
        PUjCDt203nW+8hzPsU2f5kL7tfL/LlQ8d9/43AMuJbxf+GOYaYZf5zMbGR9zFt3Rr2CpoiVSuyk60
        fCzsyD9fTM7BlHPT9kG+/hXvwhNNXgJB9Ey2a2J784nE4KpTphHfnC3ZRtKZ8KzNCcMp58sYpvva7
        iyXlRodqb1QyxSMAB23eUs2yRhDFbdCDhWbLi7dpQmtHHNayQ7VQgYvckv9ciUlkTnMX7l3FWaFiF
        XXRBWhnQb10lF+oGs/Qq3du5Mr1DdPXMnGl1AtxpQXvaTuHhdEPzt5UJ16kLXxIAKlVZMKlFEfRnm
        DBr+o3EQ==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1pBQeQ-0000w3-M8; Sat, 31 Dec 2022 02:27:06 +0100
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1pBQeA-0005dz-NY; Sat, 31 Dec 2022 02:26:50 +0100
Message-ID: <15599980-bd2e-b6c2-1479-e1eef02da0b5@rbox.co>
Date:   Sat, 31 Dec 2022 02:26:49 +0100
MIME-Version: 1.0
User-Agent: Thunderbird
Subject: Re: [RFC] Catch dwmw2's deadlock
To:     Joel Fernandes <joel@joelfernandes.org>,
        David Woodhouse <dwmw2@infradead.org>
Cc:     Matthew Wilcox <willy@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>, rcu@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
References: <122f38e724aae9ae8ab474233da1ba19760c20d2.camel@infradead.org>
 <54057376-2A57-4D8B-B05D-DE768F506819@joelfernandes.org>
Content-Language: pl-PL, en-GB
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <54057376-2A57-4D8B-B05D-DE768F506819@joelfernandes.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/30/22 14:18, Joel Fernandes wrote:
> I think the patch from Matthew Wilcox will address it because the
> read side section already acquires the dep_map. So lockdep subsystem
> should be able to nail the dependency. (...)

Perhaps it's something misconfigured on my side, but I still don't see any
lockdep splats, just the usual task hang warning after 120s.

If that's any help, here's a crude selftest (actually a severed version of
xen_shinfo_test). Under current mainline 6.2.0-rc1 it results in exactly
the type of deadlocks described by David.

Michal

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 1750f91dd936..0f02a4fe9374 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -61,6 +61,7 @@ TEST_PROGS_x86_64 += x86_64/nx_huge_pages_test.sh
 # Compiled test targets
 TEST_GEN_PROGS_x86_64 = x86_64/cpuid_test
 TEST_GEN_PROGS_x86_64 += x86_64/cr4_cpuid_sync_test
+TEST_GEN_PROGS_x86_64 += x86_64/deadlocks_test
 TEST_GEN_PROGS_x86_64 += x86_64/get_msr_index_features
 TEST_GEN_PROGS_x86_64 += x86_64/exit_on_emulation_failure_test
 TEST_GEN_PROGS_x86_64 += x86_64/fix_hypercall_test
diff --git a/tools/testing/selftests/kvm/x86_64/deadlocks_test.c b/tools/testing/selftests/kvm/x86_64/deadlocks_test.c
new file mode 100644
index 000000000000..e6150a624905
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86_64/deadlocks_test.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include <stdio.h>
+#include <string.h>
+#include <pthread.h>
+
+#include "kvm_util.h"
+#include "processor.h"
+
+#define RACE_ITERATIONS			0x1000
+
+#define EVTCHN_PORT			1
+#define XEN_HYPERCALL_MSR		0x40000000
+
+#define EVTCHNSTAT_interdomain		2
+#define __HYPERVISOR_event_channel_op	32
+#define EVTCHNOP_send			4
+
+#define VCPU_INFO_REGION_GPA		0xc0000000ULL
+#define VCPU_INFO_REGION_SLOT		10
+
+struct evtchn_send {
+	u32 port;
+};
+
+static void evtchn_assign(struct kvm_vm *vm)
+{
+	struct kvm_xen_hvm_attr assign = {
+		.type = KVM_XEN_ATTR_TYPE_EVTCHN,
+		.u.evtchn = {
+			.flags = 0,
+			.send_port = EVTCHN_PORT,
+			.type = EVTCHNSTAT_interdomain,
+			.deliver.port = {
+				.port = EVTCHN_PORT,
+				.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL,
+				.vcpu = 0
+			}
+		}
+	};
+
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &assign);
+}
+
+static void *set_msr_filter(void *arg)
+{
+	struct kvm_vm *vm = (struct kvm_vm *)arg;
+
+	struct kvm_msr_filter filter = {
+		.flags = KVM_MSR_FILTER_DEFAULT_ALLOW,
+		.ranges = {}
+	};
+
+	for (;;) {
+		vm_ioctl(vm, KVM_X86_SET_MSR_FILTER, &filter);
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+static void *set_pmu_filter(void *arg)
+{
+	struct kvm_vm *vm = (struct kvm_vm *)arg;
+
+	struct kvm_pmu_event_filter filter = {
+		.action = KVM_PMU_EVENT_ALLOW,
+		.flags = 0,
+		.nevents = 0
+	};
+
+	for (;;) {
+		vm_ioctl(vm, KVM_SET_PMU_EVENT_FILTER, &filter);
+		pthread_testcancel();
+	}
+
+	return NULL;
+}
+
+static void guest_code(void)
+{
+	struct evtchn_send s = { .port = EVTCHN_PORT };
+
+	for (;;) {
+		asm volatile("vmcall"
+			     :
+			     : "a" (__HYPERVISOR_event_channel_op),
+			       "D" (EVTCHNOP_send),
+			       "S" (&s)
+			     : "memory");
+		GUEST_SYNC(0);
+	}
+}
+
+static void race_against(struct kvm_vcpu *vcpu, void *(*func)(void *))
+{
+	pthread_t thread;
+	int i, ret;
+
+	ret = pthread_create(&thread, NULL, func, (void *)vcpu->vm);
+	TEST_ASSERT(ret == 0, "pthread_create() failed: %s", strerror(ret));
+
+	for (i = 0; i < RACE_ITERATIONS; ++i) {
+		fprintf(stderr, ".");
+		vcpu_run(vcpu);
+	}
+	printf("\n");
+
+	ret = pthread_cancel(thread);
+	TEST_ASSERT(ret == 0, "pthread_cancel() failed: %s", strerror(ret));
+
+	ret = pthread_join(thread, 0);
+	TEST_ASSERT(ret == 0, "pthread_join() failed: %s", strerror(ret));
+}
+
+int main(int argc, char *argv[])
+{
+	unsigned int xen_caps;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	xen_caps = kvm_check_cap(KVM_CAP_XEN_HVM);
+	TEST_REQUIRE(xen_caps & KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL);
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vcpu_set_hv_cpuid(vcpu);
+
+	struct kvm_xen_hvm_attr ha = {
+		.type = KVM_XEN_ATTR_TYPE_SHARED_INFO,
+		.u.shared_info.gfn = KVM_XEN_INVALID_GFN,
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &ha);
+
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    VCPU_INFO_REGION_GPA, VCPU_INFO_REGION_SLOT, 1, 0);
+
+	struct kvm_xen_vcpu_attr vi = {
+		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO,
+		.u.gpa = VCPU_INFO_REGION_GPA,
+	};
+	vcpu_ioctl(vcpu, KVM_XEN_VCPU_SET_ATTR, &vi);
+
+	struct kvm_xen_hvm_config hvmc = {
+		.flags = KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL,
+		.msr = XEN_HYPERCALL_MSR
+	};
+	vm_ioctl(vm, KVM_XEN_HVM_CONFIG, &hvmc);
+
+	evtchn_assign(vm);
+
+	race_against(vcpu, set_msr_filter);
+	race_against(vcpu, set_pmu_filter);
+
+	kvm_vm_free(vm);
+	return 0;
+}
