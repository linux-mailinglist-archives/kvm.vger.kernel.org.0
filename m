Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D87D3CEE5F
	for <lists+kvm@lfdr.de>; Mon, 19 Jul 2021 23:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238679AbhGSUjf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jul 2021 16:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383760AbhGSSKJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jul 2021 14:10:09 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29213C06178A
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:38:17 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g3-20020a256b030000b0290551bbd99700so26748420ybc.6
        for <kvm@vger.kernel.org>; Mon, 19 Jul 2021 11:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fvZeuFhawOmKlopyx148igwfDYKa3P5KdvR9ULck4mI=;
        b=TeX8LKON226q4jIrJlx/WftDAJi2pY1OEqo3ZYuEZIlxxatjAaGewz4EyaxEKG/xTD
         MGQgvyGFusH9M/ADz/wyUqEaAavEcB2Bbyv56OseAIZOSxSIioZgaF83g7FDtp2qmXvG
         BZYpoS4ToO9PSDn+w18PdbkmmCL/tls1lwW4aKbY1GuW9ZH+dzE+T2Y4jol98qPwQv/m
         Y6ewFtdqJnknjFuL3jhd4DOBAkRj8WhzqFi8tyELP07VXyLkB0aFG+CzQ1Pavc3ZV77J
         9hmai6MbVT/A0q5jl7VxBr20c/onp/SoQzY3g+mi/e/IFVyYlRUMHXCGbhgieitI7FoX
         3ezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fvZeuFhawOmKlopyx148igwfDYKa3P5KdvR9ULck4mI=;
        b=cgExmCW/XqAeWPlJ/1nCtZot5S3vm4BUCjeME4S33s64Ak1+5GGlJMwr1sXsm7LIIh
         aPFolilX4bJV/JwZJFgs2Z8Bq7hHuuQYPwtznNJfT62ws1vZIzQigJYkkQzWZs+48TVd
         LWakVUgAqknZRGsQQaVXmNzUnOLC629NW8KuMDeX96gLMhHdGLUFmvPJXYIoSUWyaT3q
         17OUqHhrIw9PmatcaGXVVsTitovyHSWzTPN2Yg1i3VhXHLx375ZAS94R0upmdgUGNygJ
         LuUFyVu3FaMA4aqwFKcP99tBKY13aPh7Xy4VQhUzHTgmKRq2A1/P6Hb6C5Zq0aXv2n6V
         Zn1g==
X-Gm-Message-State: AOAM533DuyVl2GGd1MANw1g6zwoJPIAz6qB/9/xorASRwPKLRo7ABrS3
        UZTCQLtPZGh05Dayhqda9zP/s5VKwkbnNdh0M+semr78eYB9feF2K89HEBoLrWiALiMeUv7ZcQC
        uKUkjRZ70AN5RZ4h2CVSp2ZSOVfRL5d28OBWQV1LvCg/tm8l//kCIEZf+eQ==
X-Google-Smtp-Source: ABdhPJyapdJfkrJhAGeUmrTv3NNW6zX92Vh5gia+jhMDC3UybLIWyyFrENJ2cGQn91HP0UTm8SnlfJC2tQc=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:a369:: with SMTP id d96mr33538392ybi.463.1626720609797;
 Mon, 19 Jul 2021 11:50:09 -0700 (PDT)
Date:   Mon, 19 Jul 2021 18:49:46 +0000
In-Reply-To: <20210719184949.1385910-1-oupton@google.com>
Message-Id: <20210719184949.1385910-10-oupton@google.com>
Mime-Version: 1.0
References: <20210719184949.1385910-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 09/12] selftests: KVM: Add support for aarch64 to system_counter_offset_test
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
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM/arm64 now allows userspace to adjust the guest virtual counter-timer
via a vCPU device attribute. Test that changes to the virtual
counter-timer offset result in the correct view being presented to the
guest.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../selftests/kvm/include/aarch64/processor.h | 12 +++++
 .../kvm/system_counter_offset_test.c          | 54 ++++++++++++++++++-
 3 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 7bf2e5fb1d5a..d89908108c97 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -96,6 +96,7 @@ TEST_GEN_PROGS_aarch64 += kvm_page_table_test
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
index 7e9015770759..88ad997f5b69 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -53,7 +53,59 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
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
+	if (!_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				   KVM_ARM_VCPU_TIMER_OFFSET_VTIMER))
+		return;
+
+	print_skip("KVM_ARM_VCPU_TIMER_OFFSET_VTIMER not supported; skipping test");
+	exit(KSFT_SKIP);
+}
+
+static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
+{
+	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				KVM_ARM_VCPU_TIMER_OFFSET_VTIMER, &test->offset,
+				true);
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
2.32.0.402.g57bb445576-goog

