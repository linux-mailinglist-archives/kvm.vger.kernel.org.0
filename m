Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B4B3CBE94
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 23:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbhGPV3t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 17:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236794AbhGPV3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 17:29:46 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACC1C061766
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:49 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id u14-20020a05620a120eb02903b8bd5c7d95so1582977qkj.12
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 14:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fvZeuFhawOmKlopyx148igwfDYKa3P5KdvR9ULck4mI=;
        b=T6kgzXNgdlEhpFTlBC7oCPV3AZhgGf9UvTHZQrAryDOvdo81Ekqe0dxKYoc5zzrRyB
         I498uqSFuEApbss8TjuQc4oOz45sAvyR9soR94p0VAVpugK0z+fz+JPzE6FrNds9ve10
         iMLFM8O6ui5jvAcFXbBUjPk5fw4zFrG7uURBFuAvAXYrxldMZ0RwdziB4q/jrWgb23dg
         AMGm46cfYzLyz0gixesLXSVC8/8fKmbkQKrjlO2M00Ij65O2wGhKZSghr0jVxsXpM6As
         vIuFSx8EUsHfUCysly7QOWSUKskJc+ULyo/4d8c9ST8kCWzlhmfIANPsYaEWOp8VFak5
         uuqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fvZeuFhawOmKlopyx148igwfDYKa3P5KdvR9ULck4mI=;
        b=lB0Ec7MihDYJW/8l/+Zk/dnIya5lNerGvWYsHxXTRdsKEA26cuAQEVZ4k5BkJL5uyx
         M88qxT7yhO3DN9I8bH3ZAQgtGVR5WMRURzUvuVXBRGaP/AGoIVuXxtpNE5x4vTGBmj4N
         sLs1Y8h6xyOwi8mpnhezhqJejtGjQojlgwJ/krn337HVr57Ba9P3pP3X9xdBjGJ3ziP2
         mhO0pX4DQaH/Kjukm93CTFx5Gghat3TluGGndzfQ/p9vZm5sxClcOeMMOxxt1npdVrrs
         s6rSS/YPI/VPJ0EH42qQKP3dzRXn3XNkR7k8i+KAFcyY7IvmpGUh2X/fdioGnXoGHWTx
         qd+Q==
X-Gm-Message-State: AOAM532VdTYhamxCvANxhTgxEeeq7HcP30WIzFsPxJAlYHcfpMgCx/3A
        6EFztsloWSDu4APZy5nLFTPbVcICyzW2AMme1MgfwyWm+Oam2hJQU4LXDOweEZ398j2BzUTOy0w
        oeYpD03JHoLT13tBn7mfLabaJs+nrD+xKDq6Q/zjI9pFXiMD49bCkBCOwCQ==
X-Google-Smtp-Source: ABdhPJysgXNh4yRC7wxahxW0PYPXCoSlRF3VNDywe/+0SvUhKwasJT9fSwiLOkbGsOp5mSOBQoVxk7xM4N4=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:68d:: with SMTP id
 r13mr12330328qvz.36.1626470808572; Fri, 16 Jul 2021 14:26:48 -0700 (PDT)
Date:   Fri, 16 Jul 2021 21:26:26 +0000
In-Reply-To: <20210716212629.2232756-1-oupton@google.com>
Message-Id: <20210716212629.2232756-10-oupton@google.com>
Mime-Version: 1.0
References: <20210716212629.2232756-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v2 09/12] selftests: KVM: Add support for aarch64 to system_counter_offset_test
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

