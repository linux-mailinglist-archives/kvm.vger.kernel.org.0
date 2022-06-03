Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C351D53C31A
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 04:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240464AbiFCAs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jun 2022 20:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240477AbiFCArQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jun 2022 20:47:16 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F61637AB5
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 17:46:18 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id y66-20020a62ce45000000b0051bb4d19f5fso3209337pfg.18
        for <kvm@vger.kernel.org>; Thu, 02 Jun 2022 17:46:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=amHid4K7CeXzL2Cd0HrBIVoj06G0AcSIfRzEhS9x9Vo=;
        b=fqMVOzdSDB5o+Yy3MqLyLTS1VAuJsuiWmVMAcVC2A9ur/ssxIlekilpahr3az0N1Sd
         3cUTKq5WFYSQZHAKHOStN2xpVJRt2rJy0o6FhxIwvxAgqJmpwCkNHq9IQpexLCGzro2c
         cUk2d6uYPsjmyHUO16Gq+Zl6Jgk6LHatTZyphgZkypxY+k/bhiQLCOCDWkO9zhdhjfE7
         KGasqNnodvI7mtaIvniC6G5kr3JyWr/JP8FfvDhAETtMEMiEt86T2Zl3Y8+wLyTq0Mrx
         l6/CztzSf0yl+aN1W3mYZUE2YUxQFZ0GipYg8z3H9gUR/gWmoLU+kJl48j7lUjpmxYCH
         Nz3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=amHid4K7CeXzL2Cd0HrBIVoj06G0AcSIfRzEhS9x9Vo=;
        b=ovky4E497yYHGFIvs4/W5ULW/LF02utfwj2laVvxhzXXxqkxIz3chxujJd1f44uGwV
         5CZ8LgvnJFmLwxh3jq8RAq9+I540OfygZelZgnIJz7kiC5YcemYCHNW66FWTR8lKLpn9
         BtONNtLsjcWD480SFV7Xt82h2atpaBOZ3Ft84r06KCPKbwbG62xcYy6aZee3fUtFfOnP
         NazC21B6NFNPOAJmpXx5CNUmkvDOwl4MRYYSnKRLu3YUDzg1BoF9PmzPJw0VijXCH2au
         PTH+0Z0/JeOiKIy07DL0Y4MXEO/KMRaDWOfGwjEFxnB6FK9UYFDJNvkBluv7hQshfSwh
         IA/w==
X-Gm-Message-State: AOAM533jYvoHN4GOq5HYBtdxcxIOuZTdBEuqo4An47zk1j8Nonn9e+e6
        Aa7hpSwiNQCZxmiX9AVD9h4QoXfxWJo=
X-Google-Smtp-Source: ABdhPJzlkFDShxy7YeHDixEpEdzxg8e0KPSS1wQinqqhLFWF7Sa4M902WiEQR0Ygw/aeT9vsZNZo3xejH/Q=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:ba88:b0:164:1b2d:61b5 with SMTP id
 k8-20020a170902ba8800b001641b2d61b5mr7665933pls.27.1654217177988; Thu, 02 Jun
 2022 17:46:17 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  3 Jun 2022 00:42:36 +0000
In-Reply-To: <20220603004331.1523888-1-seanjc@google.com>
Message-Id: <20220603004331.1523888-90-seanjc@google.com>
Mime-Version: 1.0
References: <20220603004331.1523888-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v2 089/144] KVM: selftests: Convert xen_shinfo_test away from VCPU_ID
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Convert xen_shinfo_test to use vm_create_with_one_vcpu() and pass around a
'struct kvm_vcpu' object instead of using a global VCPU_ID.  Note, this is
a "functional" change in the sense that the test now creates a vCPU with
vcpu_id==0 instead of vcpu_id==5.  The non-zero VCPU_ID was 100% arbitrary
and added little to no validation coverage.  If testing non-zero vCPU IDs
is desirable for generic tests, that can be done in the future by tweaking
the VM creation helpers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/xen_shinfo_test.c    | 62 +++++++++----------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
index 7a51bb648fbb..5c0abaf0eb60 100644
--- a/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
+++ b/tools/testing/selftests/kvm/x86_64/xen_shinfo_test.c
@@ -18,8 +18,6 @@
 
 #include <sys/eventfd.h>
 
-#define VCPU_ID		5
-
 #define SHINFO_REGION_GVA	0xc0000000ULL
 #define SHINFO_REGION_GPA	0xc0000000ULL
 #define SHINFO_REGION_SLOT	10
@@ -42,8 +40,6 @@
 #define EVTCHN_TEST2 66
 #define EVTCHN_TIMER 13
 
-static struct kvm_vm *vm;
-
 #define XEN_HYPERCALL_MSR	0x40000000
 
 #define MIN_STEAL_TIME		50000
@@ -344,19 +340,22 @@ static int cmp_timespec(struct timespec *a, struct timespec *b)
 	else
 		return 0;
 }
-struct vcpu_info *vinfo;
+
+static struct vcpu_info *vinfo;
+static struct kvm_vcpu *vcpu;
 
 static void handle_alrm(int sig)
 {
 	if (vinfo)
 		printf("evtchn_upcall_pending 0x%x\n", vinfo->evtchn_upcall_pending);
-	vcpu_dump(stdout, vm, VCPU_ID, 0);
+	vcpu_dump(stdout, vcpu->vm, vcpu->id, 0);
 	TEST_FAIL("IRQ delivery timed out");
 }
 
 int main(int argc, char *argv[])
 {
 	struct timespec min_ts, max_ts, vm_ts;
+	struct kvm_vm *vm;
 	bool verbose;
 
 	verbose = argc > 1 && (!strncmp(argv[1], "-v", 3) ||
@@ -374,8 +373,7 @@ int main(int argc, char *argv[])
 
 	clock_gettime(CLOCK_REALTIME, &min_ts);
 
-	vm = vm_create_default(VCPU_ID, 0, (void *) guest_code);
-	vcpu_set_cpuid(vm, VCPU_ID, kvm_get_supported_cpuid());
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 
 	/* Map a region for the shared_info page */
 	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
@@ -425,13 +423,13 @@ int main(int argc, char *argv[])
 		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO,
 		.u.gpa = VCPU_INFO_ADDR,
 	};
-	vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &vi);
+	vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &vi);
 
 	struct kvm_xen_vcpu_attr pvclock = {
 		.type = KVM_XEN_VCPU_ATTR_TYPE_VCPU_TIME_INFO,
 		.u.gpa = PVTIME_ADDR,
 	};
-	vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &pvclock);
+	vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &pvclock);
 
 	struct kvm_xen_hvm_attr vec = {
 		.type = KVM_XEN_ATTR_TYPE_UPCALL_VECTOR,
@@ -440,7 +438,7 @@ int main(int argc, char *argv[])
 	vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &vec);
 
 	vm_init_descriptor_tables(vm);
-	vcpu_init_descriptor_tables(vm, VCPU_ID);
+	vcpu_init_descriptor_tables(vm, vcpu->id);
 	vm_install_exception_handler(vm, EVTCHN_VECTOR, evtchn_handler);
 
 	if (do_runstate_tests) {
@@ -448,7 +446,7 @@ int main(int argc, char *argv[])
 			.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_ADDR,
 			.u.gpa = RUNSTATE_ADDR,
 		};
-		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &st);
+		vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &st);
 	}
 
 	int irq_fd[2] = { -1, -1 };
@@ -468,13 +466,13 @@ int main(int argc, char *argv[])
 		irq_routes.entries[0].gsi = 32;
 		irq_routes.entries[0].type = KVM_IRQ_ROUTING_XEN_EVTCHN;
 		irq_routes.entries[0].u.xen_evtchn.port = EVTCHN_TEST1;
-		irq_routes.entries[0].u.xen_evtchn.vcpu = VCPU_ID;
+		irq_routes.entries[0].u.xen_evtchn.vcpu = vcpu->id;
 		irq_routes.entries[0].u.xen_evtchn.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
 
 		irq_routes.entries[1].gsi = 33;
 		irq_routes.entries[1].type = KVM_IRQ_ROUTING_XEN_EVTCHN;
 		irq_routes.entries[1].u.xen_evtchn.port = EVTCHN_TEST2;
-		irq_routes.entries[1].u.xen_evtchn.vcpu = VCPU_ID;
+		irq_routes.entries[1].u.xen_evtchn.vcpu = vcpu->id;
 		irq_routes.entries[1].u.xen_evtchn.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
 
 		vm_ioctl(vm, KVM_SET_GSI_ROUTING, &irq_routes);
@@ -508,14 +506,14 @@ int main(int argc, char *argv[])
 			.u.evtchn.type = EVTCHNSTAT_interdomain,
 			.u.evtchn.flags = 0,
 			.u.evtchn.deliver.port.port = EVTCHN_TEST1,
-			.u.evtchn.deliver.port.vcpu = VCPU_ID + 1,
+			.u.evtchn.deliver.port.vcpu = vcpu->id + 1,
 			.u.evtchn.deliver.port.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL,
 		};
 		vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &inj);
 
 		/* Test migration to a different vCPU */
 		inj.u.evtchn.flags = KVM_XEN_EVTCHN_UPDATE;
-		inj.u.evtchn.deliver.port.vcpu = VCPU_ID;
+		inj.u.evtchn.deliver.port.vcpu = vcpu->id;
 		vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &inj);
 
 		inj.u.evtchn.send_port = 197;
@@ -524,7 +522,7 @@ int main(int argc, char *argv[])
 		inj.u.evtchn.flags = 0;
 		vm_ioctl(vm, KVM_XEN_HVM_SET_ATTR, &inj);
 
-		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+		vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &tmr);
 	}
 	vinfo = addr_gpa2hva(vm, VCPU_INFO_VADDR);
 	vinfo->evtchn_upcall_pending = 0;
@@ -535,17 +533,17 @@ int main(int argc, char *argv[])
 	bool evtchn_irq_expected = false;
 
 	for (;;) {
-		volatile struct kvm_run *run = vcpu_state(vm, VCPU_ID);
+		volatile struct kvm_run *run = vcpu->run;
 		struct ucall uc;
 
-		vcpu_run(vm, VCPU_ID);
+		vcpu_run(vm, vcpu->id);
 
 		TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
 			    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
 			    run->exit_reason,
 			    exit_reason_str(run->exit_reason));
 
-		switch (get_ucall(vm, VCPU_ID, &uc)) {
+		switch (get_ucall(vm, vcpu->id, &uc)) {
 		case UCALL_ABORT:
 			TEST_FAIL("%s", (const char *)uc.args[0]);
 			/* NOT REACHED */
@@ -574,7 +572,7 @@ int main(int argc, char *argv[])
 					printf("Testing runstate %s\n", runstate_names[uc.args[1]]);
 				rst.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_CURRENT;
 				rst.u.runstate.state = uc.args[1];
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &rst);
 				break;
 
 			case 4:
@@ -589,7 +587,7 @@ int main(int argc, char *argv[])
 					0x6b6b - rs->time[RUNSTATE_offline];
 				rst.u.runstate.time_runnable = -rst.u.runstate.time_blocked -
 					rst.u.runstate.time_offline;
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &rst);
 				break;
 
 			case 5:
@@ -601,7 +599,7 @@ int main(int argc, char *argv[])
 				rst.u.runstate.state_entry_time = 0x6b6b + 0x5a;
 				rst.u.runstate.time_blocked = 0x6b6b;
 				rst.u.runstate.time_offline = 0x5a;
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &rst);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &rst);
 				break;
 
 			case 6:
@@ -660,7 +658,7 @@ int main(int argc, char *argv[])
 
 				struct kvm_irq_routing_xen_evtchn e;
 				e.port = EVTCHN_TEST2;
-				e.vcpu = VCPU_ID;
+				e.vcpu = vcpu->id;
 				e.priority = KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL;
 
 				vm_ioctl(vm, KVM_XEN_HVM_EVTCHN_SEND, &e);
@@ -702,7 +700,7 @@ int main(int argc, char *argv[])
 			case 14:
 				memset(&tmr, 0, sizeof(tmr));
 				tmr.type = KVM_XEN_VCPU_ATTR_TYPE_TIMER;
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &tmr);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_GET_ATTR, &tmr);
 				TEST_ASSERT(tmr.u.timer.port == EVTCHN_TIMER,
 					    "Timer port not returned");
 				TEST_ASSERT(tmr.u.timer.priority == KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL,
@@ -722,7 +720,7 @@ int main(int argc, char *argv[])
 					printf("Testing restored oneshot timer\n");
 
 				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				evtchn_irq_expected = true;
 				alarm(1);
 				break;
@@ -749,7 +747,7 @@ int main(int argc, char *argv[])
 					printf("Testing SCHEDOP_poll wake on masked event\n");
 
 				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000,
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				alarm(1);
 				break;
 
@@ -760,11 +758,11 @@ int main(int argc, char *argv[])
 
 				evtchn_irq_expected = true;
 				tmr.u.timer.expires_ns = rs->state_entry_time + 100000000;
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &tmr);
 
 				/* Read it back and check the pending time is reported correctly */
 				tmr.u.timer.expires_ns = 0;
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &tmr);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_GET_ATTR, &tmr);
 				TEST_ASSERT(tmr.u.timer.expires_ns == rs->state_entry_time + 100000000,
 					    "Timer not reported pending");
 				alarm(1);
@@ -774,7 +772,7 @@ int main(int argc, char *argv[])
 				TEST_ASSERT(!evtchn_irq_expected,
 					    "Expected event channel IRQ but it didn't happen");
 				/* Read timer and check it is no longer pending */
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &tmr);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_GET_ATTR, &tmr);
 				TEST_ASSERT(!tmr.u.timer.expires_ns, "Timer still reported pending");
 
 				shinfo->evtchn_pending[0] = 0;
@@ -783,7 +781,7 @@ int main(int argc, char *argv[])
 
 				evtchn_irq_expected = true;
 				tmr.u.timer.expires_ns = rs->state_entry_time - 100000000ULL;
-				vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_SET_ATTR, &tmr);
+				vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_SET_ATTR, &tmr);
 				alarm(1);
 				break;
 
@@ -853,7 +851,7 @@ int main(int argc, char *argv[])
 		struct kvm_xen_vcpu_attr rst = {
 			.type = KVM_XEN_VCPU_ATTR_TYPE_RUNSTATE_DATA,
 		};
-		vcpu_ioctl(vm, VCPU_ID, KVM_XEN_VCPU_GET_ATTR, &rst);
+		vcpu_ioctl(vm, vcpu->id, KVM_XEN_VCPU_GET_ATTR, &rst);
 
 		if (verbose) {
 			printf("Runstate: %s(%d), entry %" PRIu64 " ns\n",
-- 
2.36.1.255.ge46751e96f-goog

