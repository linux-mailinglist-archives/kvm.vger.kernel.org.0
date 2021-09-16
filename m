Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5332E40EA78
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 20:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345815AbhIPS6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 14:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343843AbhIPS5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 14:57:34 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84894C04A160
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:05 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id e22-20020a05620a209600b003d5ff97bff7so44943640qka.1
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 11:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7QjavrqBsU/MBAzScH1BwocaUHGDPl4uPFd2XGsDMvE=;
        b=W/jxVPF8UGJYGASTGhfD4cpXvhCNOyq5w8JBfeqZqbNuG2vNR362VcSh4btOMHC1y9
         oe1hix7aUqYGFOC3TNRTgzpgDaE5P6+YXpaqXLPSNjDqHsnvt9peNLYPYcADPy5/5A8M
         6/S6umn1c5cSrAwWCHmoXEJpZ+FFfmtfHxUkebqIeKunLfOkdsQrhKCrPTEVRxU1FP9u
         j9w/2KyUMMYxsVy1tPyjkjJUB3Z1Z/Yn1zxDe2WZVfzMGr0NPLDYcgDwzevUsCalGGIF
         TNCF2vYHowEZKwbqoQ7CrRFk3Tc+XYvTlRTUBFbC4oNn/h/fpePvNxmQWhlOK15PqtXr
         vRRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7QjavrqBsU/MBAzScH1BwocaUHGDPl4uPFd2XGsDMvE=;
        b=BCOPO6HacyXFqbSTd4nbknXIKjcKiRr3r/qKKwvqbhbif/Drw3rgXpW8ev3dgI6QZV
         rby50W8nhR21Sx1ubRN2j1pB7ObGpSD0TfMsO97W9ngCkFuzXjsoWL52iZ71BW4lljjE
         BZDFgeFqaMUepzd7Cltez7ZrokjU6WnVaZuhGIY6+ddknKKWVOp783CT3w2IeXhmfzTj
         1hTxyWet60Fpun6j0idA5EZrcKY/cfH4klgndlhFs+GC+W8q8P5UYQMrBQT93JVB+e7s
         +IQ1bxb4IGRvXbV00HJl2PljynjbZAzj3ybqZMZIG2/yV8BN/iPG2F0yLZawWIEWzJkn
         8gmw==
X-Gm-Message-State: AOAM531KPVq4Ysu8bU1/0RBhGBe8RKJ/Z1qIhVV8c/ItxWPwneFO8A7A
        m6QZIoPP8i+Y7nJSM36cNu4Gly2gnT+7CmGrGpd3EKxvmO7XzyM9/F0cVj/LpNCvST943Mv5LcK
        M0VysShkduKnIPKpNkBbKE/uw0Jcx5OMDVxTJTDju4QPFghtU06wajw+HVw==
X-Google-Smtp-Source: ABdhPJyEbuPS+wYh6ttOuY6erGnCSv4WLRJ1npvavUrNwz7P3JruTT8DOF+7Y2BrFtjDW2ZEfJYAF+ysuwg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:7b4:: with SMTP id
 v20mr7057215qvz.0.1631816164628; Thu, 16 Sep 2021 11:16:04 -0700 (PDT)
Date:   Thu, 16 Sep 2021 18:15:52 +0000
In-Reply-To: <20210916181555.973085-1-oupton@google.com>
Message-Id: <20210916181555.973085-7-oupton@google.com>
Mime-Version: 1.0
References: <20210916181555.973085-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 6/9] selftests: KVM: Add support for aarch64 to system_counter_offset_test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/arm64 now allows userspace to adjust the guest virtual counter-timer
via a vCPU register. Test that changes to the virtual counter-timer
offset result in the correct view being presented to the guest.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/aarch64/processor.h | 12 ++++
 .../kvm/system_counter_offset_test.c          | 64 ++++++++++++++++++-
 3 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 225803ac95bb..fd61d0063c50 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -98,6 +98,7 @@ TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
 TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
+TEST_GEN_PROGS_aarch64 += system_counter_offset_test
 
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/resets
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index c0273aefa63d..4c7472823df3 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -132,4 +132,16 @@ void vm_install_sync_handler(struct kvm_vm *vm,
 
 #define isb()	asm volatile("isb" : : : "memory")
 
+static inline uint64_t read_cntvct_ordered(void)
+{
+	uint64_t r;
+
+	__asm__ __volatile__("isb\n\t"
+			     "mrs %0, cntvct_el0\n\t"
+			     "isb\n\t"
+			     : "=r"(r));
+
+	return r;
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index b337bbbfa41f..7ea406fdd56f 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -53,7 +53,69 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
 	return rdtsc() + test->tsc_offset;
 }
 
-#else /* __x86_64__ */
+#elif __aarch64__ /* __x86_64__ */
+
+enum arch_counter {
+	VIRTUAL,
+};
+
+struct test_case {
+	enum arch_counter counter;
+	uint64_t offset;
+};
+
+static struct test_case test_cases[] = {
+	{ .counter = VIRTUAL, .offset = 0 },
+	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
+};
+
+static void check_preconditions(struct kvm_vm *vm)
+{
+	struct kvm_enable_cap cap = {
+		.cap = KVM_CAP_ARM_VTIMER_OFFSET,
+	};
+
+	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
+		return;
+
+	if (!kvm_check_cap(KVM_CAP_ARM_VTIMER_OFFSET)) {
+		print_skip("KVM_REG_ARM_TIMER_OFFSET not supported");
+		exit(KSFT_SKIP);
+	}
+
+	vm_enable_cap(vm, &cap);
+}
+
+static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
+{
+	struct kvm_one_reg reg = {
+		.id = KVM_REG_ARM_TIMER_OFFSET,
+		.addr = (__u64)&test->offset,
+	};
+
+	vcpu_set_reg(vm, VCPU_ID, &reg);
+}
+
+static uint64_t guest_read_system_counter(struct test_case *test)
+{
+	switch (test->counter) {
+	case VIRTUAL:
+		return read_cntvct_ordered();
+	default:
+		GUEST_ASSERT(0);
+	}
+
+	/* unreachable */
+	return 0;
+}
+
+static uint64_t host_read_guest_system_counter(struct test_case *test)
+{
+	return read_cntvct_ordered() - test->offset;
+}
+
+#else /* __aarch64__ */
 
 #error test not implemented for this architecture!
 
-- 
2.33.0.464.g1972c5931b-goog

