Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5703DFD7A
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 10:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236898AbhHDI7H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 04:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236871AbhHDI7E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 04:59:04 -0400
Received: from mail-oi1-x24a.google.com (mail-oi1-x24a.google.com [IPv6:2607:f8b0:4864:20::24a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7AFC0613D5
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 01:58:52 -0700 (PDT)
Received: by mail-oi1-x24a.google.com with SMTP id n2-20020aca40020000b029025c9037b7faso815453oia.14
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 01:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wr2QUWPIrNr02r9ZSQ6a6WvFSF+P+rF7IWMFJFIeT5Q=;
        b=A2eaQevcuk1kE8kH+hNfVeiJGxQGIsvPPXH7dwJX1I1bqzmceDdLvtt3vtZsSlfHgS
         6uk2fnUUV1bWg9ui/diKwA4nuUWGnCfjSPratLEZd7BP/7MO8akAcoc9w+EQ/wtsAXAp
         ZyNGkKQCPzWCb6fjuunbxbUeHNOvYwMVhCRqWRcU2+VYhha6puKXBjme8zME+4pwl6Bk
         TcuhrWi5b2xsYj1XFDIS6BErZBNJ2MwSHwcl0Oh6rDaqMeEyEhpsccRugDvMtCKPZdV8
         RqjprVlUgFZUxBZHsKv+zbjtLGxLp/H0em+JFSda46mXMaNqevbjZdwKZHvUvVK5VorB
         lOwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wr2QUWPIrNr02r9ZSQ6a6WvFSF+P+rF7IWMFJFIeT5Q=;
        b=FZ6BVo4VRIe2pyK+uk3EAnKmaY0MtHJDJ3BKZQjkodm8Rn360arxF5OtNtxGrZzRzy
         KWxichFRPJc+2cM5MW2L1MmJ+tKAr0sAjY2YAAXkC4qi0u3lj0kwqbYbd1NUKXBOKkeC
         R2rSP6+B7h9M1xe9qIMTEfj+/bUmt/D0pCPDyY7WCD3yVuxyUPzRappRo6zYqALIu9XX
         Fd9LbTkqtmeq2pod5h2+Qy9S0vJuGqMyjRoHHS0j5LJ3u1Rgsk21Nk5crSrT+knsoZ5s
         ukfbi7hroINoRcZataZTQTIGKo6uyqG14xBQj4plHJwsvZ1Q65oo4HH6Ehxe+ZecfR+r
         lwPg==
X-Gm-Message-State: AOAM533/4JDzL+rMvn1RcMs23oZMbWVZt6fuo42lNeC43IGwUY8dICkf
        Dqm9tLo+cB4sgDdDYu2fp7uelpQ5N0ymubwU/5NIjtP2uaVTkx1zF6gqE3JVxx9ziFVsd5MwtDP
        g82ciEtuwLPRyE0CFRqovqedvN/RIu4qvMFhoCQ5GR/QzJxO/s9CX/Qt0uw==
X-Google-Smtp-Source: ABdhPJwV6z5/wOQcC6ysoCIBRHVz7QoiKO1NC+BeHz63h1lYVDEtDeBmgg3mO02si6II7kJcePnt4XlEnxs=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a9d:6d16:: with SMTP id o22mr5444656otp.336.1628067531365;
 Wed, 04 Aug 2021 01:58:51 -0700 (PDT)
Date:   Wed,  4 Aug 2021 08:58:13 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-16-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 15/21] selftests: KVM: Add support for aarch64 to system_counter_offset_test
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
index 9f7060c02668..fab42e7c23ee 100644
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
2.32.0.605.g8dce9f2422-goog

