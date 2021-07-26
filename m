Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E62E63D66E0
	for <lists+kvm@lfdr.de>; Mon, 26 Jul 2021 20:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhGZSCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jul 2021 14:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbhGZSCp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jul 2021 14:02:45 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A13C061757
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 11:43:13 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id ie12-20020a17090b400cb029017320bd1351so1128352pjb.1
        for <kvm@vger.kernel.org>; Mon, 26 Jul 2021 11:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XF70JHPJp7a/I5hV/lLoxb2ss5wp1yJ7Rni1BB5YkuI=;
        b=fl9wff8XwRNg/uSrTucLMcQ1EIffjQmDBkhzRWf2F39kJ3PtcBzHVDnSwEu610JWOj
         vDDzIl3NVRKmI+SagJNZvWFrx/NHPAcvgAgjSlyUJkIhhMqqB7ZaQGR5wgLqRzPWUOtQ
         CrBfWsuq+iUQbgUeBRH+spfiBxwPuIDVyjEGqywpeXTR0XwqAiw5v5e0Hsr0O0TOt90I
         FNAOzr76IJgFACQ4/2onwCu3h4d0X8RfRG0Rzuyb8ec1PAhXI65vp4UyyasPAoRNMRNA
         tf2sihDm18LlG5c7S+LWiMW1tPoXbJUGuOimjiTaSQlND8lbwrm4peILK2uUGZVbMrig
         u91A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XF70JHPJp7a/I5hV/lLoxb2ss5wp1yJ7Rni1BB5YkuI=;
        b=ocj7/cmOPVSZW7bxiUSD2OS5EIFlPLOrbT8GItD4La+iMx54uuednbtl9zMzP74aPs
         njJ9rS6WRcakp09gBGX/W0tu1CqdV3Sjbv9J1gaIUS5BKFN9eZPhCBf0ZlRxlKqgZgmg
         08NKXZLNoZGi7vqGdfi8hq7lvl6GtBlbI8JQJiclTWPOZw7WnomVjSmoMajMr0XMGZx9
         pA769s0D5lw2D+mG0s9Nq8kS4eB6pO3CYpm9P1HdGzxURPYwJNLLskYpqV97McXPn3I3
         OITrEPk5gCzJAJprhayvstQYMQTZnSFYWW6sy46eY/oPq4IEWZMSJaJ9jZp6jbP146Qw
         WC9A==
X-Gm-Message-State: AOAM530XhGK8dzsBjLTbiAZfc3sdevpDRnnvTb9oVywJ1dCGT0qWfzgO
        ivvWrSWOH2qlaLNNsoaeMqmp2paRRyL/ZDUp
X-Google-Smtp-Source: ABdhPJwD54DFHUzSMFi1ewJOA/7zcOWx5lvV1gpfOgcfctHkwZqodsvS+CF51Ahwf3jD9026wZ2Ji+fcp/GaQQxD
X-Received: from nehir.kir.corp.google.com ([2620:15c:29:204:e222:115f:790c:cd0f])
 (user=erdemaktas job=sendgmr) by 2002:a62:36c5:0:b029:32b:83fa:3a3e with SMTP
 id d188-20020a6236c50000b029032b83fa3a3emr19403121pfa.52.1627324993074; Mon,
 26 Jul 2021 11:43:13 -0700 (PDT)
Date:   Mon, 26 Jul 2021 11:37:57 -0700
In-Reply-To: <20210726183816.1343022-1-erdemaktas@google.com>
Message-Id: <20210726183816.1343022-5-erdemaktas@google.com>
Mime-Version: 1.0
References: <20210726183816.1343022-1-erdemaktas@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [RFC PATCH 4/4] KVM: selftest: Adding test case for TDX port IO
From:   Erdem Aktas <erdemaktas@google.com>
To:     linux-kselftest@vger.kernel.org
Cc:     erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Peter Gonda <pgonda@google.com>, Marc Orr <marcorr@google.com>,
        Sagi Shahar <sagis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Ricardo Koller <ricarkol@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        David Matlack <dmatlack@google.com>,
        Like Xu <like.xu@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verifies TDVMCALL<INSTRUCTION.IO> READ and WRITE operations.

Signed-off-by: Erdem Aktas <erdemaktas@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Peter Gonda <pgonda@google.com>
Reviewed-by: Marc Orr <marcorr@google.com>
Reviewed-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/x86_64/tdx_vm_tests.c       | 107 ++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
index da7ea67b1..7b0b4b378 100644
--- a/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/tdx_vm_tests.c
@@ -88,6 +88,112 @@ void  verify_td_lifecycle(void)
 	kvm_vm_free(vm);
 	printf("\t ... PASSED\n");
 }
+
+/*
+ * Verifies IO functionality by writing a |value| to a predefined port.
+ * Verifies that the read value is |value| + 1 from the same port.
+ * If all the tests are passed then write a value to port TDX_TEST_PORT
+ */
+TDX_GUEST_FUNCTION(guest_io_exit)
+{
+	uint64_t data_out, data_in, delta;
+
+	data_out = 0xAB;
+	tdvmcall_io(TDX_TEST_PORT, 1, 1, &data_out);
+	tdvmcall_io(TDX_TEST_PORT, 1, 0, &data_in);
+	delta = data_in - data_out - 1;
+	tdvmcall_io(TDX_TEST_PORT, 1, 1, &delta);
+}
+
+void  verify_td_ioexit(void)
+{
+	struct kvm_vm *vm;
+	struct kvm_run *run;
+	uint32_t port_data;
+
+	printf("Verifying TD IO Exit:\n");
+	/* Create a TD VM with no memory.*/
+	vm = __vm_create(VM_MODE_DEFAULT, 0, O_RDWR, KVM_X86_TDX_VM);
+
+	/* Allocate TD guest memory and initialize the TD.*/
+	initialize_td(vm);
+
+	/* Initialize the TD vcpu and copy the test code to the guest memory.*/
+	vm_vcpu_add_tdx(vm, 0);
+
+	/* Setup and initialize VM memory */
+	prepare_source_image(vm, guest_io_exit,
+			     TDX_FUNCTION_SIZE(guest_io_exit), 0);
+	finalize_td_memory(vm);
+
+	run = vcpu_state(vm, 0);
+
+	/* Wait for guest to do a IO write */
+	vcpu_run(vm, 0);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT((run->exit_reason == KVM_EXIT_IO)
+		    && (run->io.port == TDX_TEST_PORT)
+		    && (run->io.size == 1)
+		    && (run->io.direction == 1),
+		    "Got an unexpected IO exit values: %u (%s) %d %d %d\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason),
+		    run->io.port, run->io.size, run->io.direction);
+	port_data = *(uint8_t *)((void *)run + run->io.data_offset);
+
+	printf("\t ... IO WRITE: OK\n");
+	/*
+	 * Wait for the guest to do a IO read. Provide the previos written data
+	 * + 1 back to the guest
+	 */
+	vcpu_run(vm, 0);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "Got exit_reason other than KVM_EXIT_IO: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO &&
+		    run->io.port == TDX_TEST_PORT &&
+		    run->io.size == 1 &&
+		    run->io.direction == 0,
+		    "Got an unexpected IO exit values: %u (%s) %d %d %d\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason),
+		    run->io.port, run->io.size, run->io.direction);
+	*(uint8_t *)((void *)run + run->io.data_offset) = port_data + 1;
+
+	printf("\t ... IO READ: OK\n");
+	/*
+	 * Wait for the guest to do a IO write to the TDX_TEST_PORT with the
+	 * value of 0. Any value other than 0 means, the guest has not able to
+	 * read/write values correctly.
+	 */
+	vcpu_run(vm, 0);
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
+		    "KVM_EXIT_IO is expected but got an exit_reason: %u (%s)\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason));
+
+	TEST_ASSERT(run->exit_reason == KVM_EXIT_IO &&
+		    run->io.port == TDX_TEST_PORT &&
+		    run->io.size == 1 &&
+		    run->io.direction == 1 &&
+		    *(uint32_t *)((void *)run + run->io.data_offset) == 0,
+		    "Got an unexpected IO exit values: %u (%s) %d %d %d %d\n",
+		    run->exit_reason,
+		    exit_reason_str(run->exit_reason),
+		    run->io.port, run->io.size, run->io.direction,
+		    *(uint32_t *)((void *)run + run->io.data_offset));
+
+	printf("\t ... IO verify read/write values: OK\n");
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
 int main(int argc, char **argv)
 {
 	if (!is_tdx_enabled()) {
@@ -97,6 +203,7 @@ int main(int argc, char **argv)
 	}
 
 	run_in_new_process(&verify_td_lifecycle);
+	run_in_new_process(&verify_td_ioexit);
 
 	return 0;
 }
-- 
2.32.0.432.gabb21c7263-goog

