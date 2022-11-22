Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97929634145
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 17:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234389AbiKVQQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 11:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbiKVQQK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 11:16:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D610E742DB
        for <kvm@vger.kernel.org>; Tue, 22 Nov 2022 08:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669133581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L7xXz0pgiyypcdQlzVuBrm4STd5l21ZBFq9WyQkYrCY=;
        b=TLLoc5TlmlgL2Ij5PekT8veNaVaWOnsdrgtMfWPkFYbJASjxh7p6su3ZN4nwB8h2tAfy+X
        wbATphOnKp2KLXhan3HNJtiS+AwbSL8njWo33sdQnWbrSMhU6ntPG+4u9+06nECb+Cl8tt
        AAtfj5ZudQ36PI0yxr8cCHyWbw9VvKw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-214-W1BTiL87N0WsGAayXJZxqQ-1; Tue, 22 Nov 2022 11:12:58 -0500
X-MC-Unique: W1BTiL87N0WsGAayXJZxqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 064A7185A794;
        Tue, 22 Nov 2022 16:12:58 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A3611121314;
        Tue, 22 Nov 2022 16:12:55 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nico Boehr <nrb@linux.ibm.com>,
        Cathy Avery <cavery@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: [kvm-unit-tests PATCH v3 27/27] x86: ipi_stress: add optional SVM support
Date:   Tue, 22 Nov 2022 18:11:52 +0200
Message-Id: <20221122161152.293072-28-mlevitsk@redhat.com>
In-Reply-To: <20221122161152.293072-1-mlevitsk@redhat.com>
References: <20221122161152.293072-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow some vCPUs to be in SVM nested mode while waiting for
an interrupt.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 x86/ipi_stress.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 78 insertions(+), 1 deletion(-)

diff --git a/x86/ipi_stress.c b/x86/ipi_stress.c
index dea3e605..1a4c5510 100644
--- a/x86/ipi_stress.c
+++ b/x86/ipi_stress.c
@@ -12,10 +12,12 @@
 #include "types.h"
 #include "alloc_page.h"
 #include "vmalloc.h"
+#include "svm_lib.h"
 #include "random.h"
 
 u64 num_iterations = 100000;
 float hlt_prob = 0.1;
+bool use_svm;
 volatile bool end_test;
 
 #define APIC_TIMER_PERIOD (1000*1000*1000)
@@ -25,6 +27,7 @@ struct cpu_test_state {
 	u64 last_isr_count;
 	struct random_state random;
 	int smp_id;
+	struct svm_vcpu vcpu;
 } *cpu_states;
 
 
@@ -71,6 +74,62 @@ static void wait_for_ipi(struct cpu_test_state *state)
 	assert(state->isr_count == old_count + 1);
 }
 
+#ifdef __x86_64__
+static void l2_guest_wait_for_ipi(struct cpu_test_state *state)
+{
+	wait_for_ipi(state);
+	asm volatile("vmmcall");
+}
+
+static void l2_guest_dummy(void)
+{
+	while (true)
+		asm volatile("vmmcall");
+}
+
+static void wait_for_ipi_in_l2(struct cpu_test_state *state)
+{
+	u64 old_count = state->isr_count;
+	struct svm_vcpu *vcpu = &state->vcpu;
+	bool poll_in_the_guest;
+
+	/*
+	 * if poll_in_the_guest is true, then the guest will run
+	 * with interrupts disabled and it will enable them for one instruction
+	 * (sometimes together with halting) until it receives an interrupts
+	 *
+	 * if poll_in_the_guest is false, the guest will always have
+	 * interrupts enabled and will usually receive the interrupt
+	 * right away, but in case it didn't we will run the guest again
+	 * until it does.
+	 *
+	 */
+	poll_in_the_guest = random_decision(&state->random, 50);
+
+	vcpu->regs.rdi = (u64)state;
+	vcpu->regs.rsp = (ulong)vcpu->stack;
+
+	vcpu->vmcb->save.rip = poll_in_the_guest ?
+			(ulong)l2_guest_wait_for_ipi :
+			(ulong)l2_guest_dummy;
+
+	if (!poll_in_the_guest)
+		vcpu->vmcb->save.rflags |= X86_EFLAGS_IF;
+	else
+		vcpu->vmcb->save.rflags &= ~X86_EFLAGS_IF;
+
+	do {
+		asm volatile("clgi;sti");
+		SVM_VMRUN(vcpu);
+		asm volatile("cli;stgi");
+		assert(vcpu->vmcb->control.exit_code == SVM_EXIT_VMMCALL);
+
+		if (poll_in_the_guest)
+			assert(old_count < state->isr_count);
+
+	} while (old_count == state->isr_count);
+}
+#endif
 
 static void vcpu_init(void *)
 {
@@ -85,6 +144,11 @@ static void vcpu_init(void *)
 	state->random = get_prng();
 	state->isr_count = 0;
 	state->smp_id = smp_id();
+
+#ifdef __x86_64__
+	if (use_svm)
+		svm_vcpu_init(&state->vcpu);
+#endif
 }
 
 static void vcpu_code(void *)
@@ -111,7 +175,12 @@ static void vcpu_code(void *)
 			break;
 
 		// wait for the IPI interrupt chain to come back to us
-		wait_for_ipi(state);
+#if __x86_64__
+		if (use_svm && random_decision(&state->random, 20))
+			wait_for_ipi_in_l2(state);
+		else
+#endif
+			wait_for_ipi(state);
 	}
 }
 
@@ -137,6 +206,14 @@ int main(int argc, void **argv)
 	setup_vm();
 	init_prng();
 
+#ifdef __x86_64__
+	if (this_cpu_has(X86_FEATURE_SVM)) {
+		use_svm = true;
+		if (!setup_svm())
+			use_svm = false;
+	}
+#endif
+
 	cpu_states = calloc(ncpus, sizeof(cpu_states[0]));
 
 	printf("found %d cpus\n", ncpus);
-- 
2.34.3

