Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F633ECC0F
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhHPANf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbhHPANa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:13:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB62C0613C1
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:13:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a62-20020a254d410000b0290592f360b0ccso14953538ybb.14
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Mo5DGr28+n9iD41dMXxXDuMQdLOo6WPPoeyjsxZY9VA=;
        b=vEEOUVGfAVc2um+9rckN8TCJebHnpC49fB/suHi6NhcRJhm92InWkAPaxRIIq5Z6dG
         OYjq3aT2bc+yiASefJLXGtf22AKm7Jhv/RwMsNTCAeH4C8hiAmKQom9SN9uvQTA28D9V
         88PZIMcHvA0kQODCYk5iG4A56Yozi2FDXot2+JLTi6jIWYpbPdS9TFhOSctUOMJXX4Bm
         9zaVrNMOtcH/5zFgBroNV/6N5tJx1rZ8+HjXvv93nHcFh1TX3rFPPqQgUzhtkSSep7pj
         /z/vmpL6Y39kEMU53J/b244iVnOb4NxDhWpg8IGAoP0Bwrj0/7Xo+D1H9mmlO/W9sbb+
         0ENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Mo5DGr28+n9iD41dMXxXDuMQdLOo6WPPoeyjsxZY9VA=;
        b=b438D8lNC7UyELTbWEuKk+eBnUp2q55VV3cHniSTK7IsWYVJGSz4K+6AkE9+KiAYCV
         61c4CK66kzrq0cMGG5ltC99zd2XwAmEPZwfOpKVXtSeo/yiQraxKv9H87J6YjPmCbf+u
         b6k0VcMwV5LOSMyVOlXplJED4pIq+26wW1qVHkq8rYsSgpclUqUvf2ujcuU5Pq8ZwJlY
         A6CEeWz41Gi7fVHFMZDcxB/orCQiatmZ0FHilbnQLX6n9ZVSMtjQIPmA3qLA4qtsnyjC
         k1fMz6PC4JWv7NpbKo01zE78ZemkGQVDZyWv5gkowBRNUDI/zNKfbvdOlSeqD194OGXR
         4J3g==
X-Gm-Message-State: AOAM530dsJKiTWOBYd7PKQjHKoZEyYg4aetZ0ivfUaIMLFlNOByE++mf
        VfK03rIi3u9m3NJSKzJa3c2byhbsGDgfbdCijr/C+KQmXlhLD6TsMXcN/ANEMb4I6znUlBj5C6Y
        IMOz51s2YCjIhTOpPikZ5EbjsN/YY0Eg1AnfQcaWKyU1ppxABpraihy5HJw==
X-Google-Smtp-Source: ABdhPJzXHC3/0Ly0+ZPM9bFrtsB0V8DUl++e5d4rHoe6kt1DE0MaxEh+J8w0d9UH18WuCP1ITvcbO0Tgedk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:d8c7:: with SMTP id p190mr10287387ybg.481.1629072779249;
 Sun, 15 Aug 2021 17:12:59 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:44 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-8-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 7/9] selftests: KVM: Add support for aarch64 to system_counter_offset_test
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
 .../kvm/system_counter_offset_test.c          | 56 ++++++++++++++++++-
 3 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 2cb0a375c7db..a74d4876c69c 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -97,6 +97,7 @@ TEST_GEN_PROGS_aarch64 += kvm_page_table_test
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
 TEST_GEN_PROGS_aarch64 += kvm_binary_stats_test
+TEST_GEN_PROGS_aarch64 += system_counter_offset_test
 
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/resets
diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 27dc5c2e56b9..3168cdbae6ee 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -129,4 +129,16 @@ void vm_install_sync_handler(struct kvm_vm *vm,
 
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
index b337bbbfa41f..ac933db83d03 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -53,7 +53,61 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
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
+	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
+		return;
+
+	print_skip("KVM_REG_ARM_TIMER_OFFSET not supported; skipping test");
+	exit(KSFT_SKIP);
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
2.33.0.rc1.237.g0d66db33f3-goog

