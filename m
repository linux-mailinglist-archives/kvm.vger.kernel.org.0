Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A0C3ECC11
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 02:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbhHPANh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Aug 2021 20:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbhHPANc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Aug 2021 20:13:32 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D82C0617AE
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:13:01 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id a24-20020a05620a067800b003c9e325c3b2so2046288qkh.2
        for <kvm@vger.kernel.org>; Sun, 15 Aug 2021 17:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1lYvkLvXMkZOW0Omv5DbnXGOEluFv2cT8dCWAkq6vrY=;
        b=ucoXmLaWopVhB4jndrMR345quHVgr2BI7iLJWrHy29tE2EOZcJZyRCkaNYoq+cCb1s
         nOS6S8Mo5cgsX5YvhwHLiVQNh3/pP6tRaAztg6MMwEkUJ1ZfqzukhcDfDdQS0bsR99la
         N6N3itdIeBBf1CxU4aoxMwyGoHsFUeqWmfTwzyXGX1ALxhANxsreVkv4GiHivCkAgMzv
         IBc87KPLN/5IsJt4WkC+P9dw4aVfsGiEqo3A6OIborROOWqmCBJoZTCYMX2+F0FZWQl1
         2hhsiQB4JVMYGPOFoaDPb34qTUO4z2df1RFV6BjoSiz6O6JsgLNHuFsrFiFyDJFtkLch
         zg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1lYvkLvXMkZOW0Omv5DbnXGOEluFv2cT8dCWAkq6vrY=;
        b=cXJsiW4XuSPgSXc8AO8sEr3j+rRfXis4XPjcnXtF17u45HneEO4n1tQP7rwLLnqbI/
         DXkMgj07DwQdZJIyZpHNxJFXtuAKqnPMHAVireejkfIP7GtzDf22C7h0MBKqSoEoU1hI
         1LPtIkQHhcUy78k1ngT1KAnZNtjhC7Sss1SzAT7IjnNFXScf59KX5QT5EMHTOCJhWtI4
         8pImMActcB+e1m8VSsnSF9ZNPx5WCxpsJWIlOw8xNyIaG5rA0LGeLu0KxftqJRGQcH9y
         jO+rTBGnHZhDIpGAZwFcIH2rUgnq4dQ53c/D72sgePMFh+I2FdzDJAwdQ6JETlGhGS64
         V8GQ==
X-Gm-Message-State: AOAM533JX8C6KJA6NWS4A0ys35YPb89Ufes1/THUb7RsBsu1Tbap8y08
        OPshLoEHU5z5cNnGZLSDK345AMOyKXGdEAfCz0G+dtgP+UrrYV5w5ICpircAnb1QCwRcpY5t4zS
        qpjawzLgWvXOP69cH6YXHlNb0TD43vvOkVTnRoLQAaP70Jq58PfTzB9M5cg==
X-Google-Smtp-Source: ABdhPJx2WNiG5Xm9EOAshaEpB0QvoPQw0RzciABjW2FV+0QygZ9dWPd5OcyKOs52q3Nfg8WF270Sk4LNSTM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a0c:e609:: with SMTP id z9mr13684667qvm.37.1629072780405;
 Sun, 15 Aug 2021 17:13:00 -0700 (PDT)
Date:   Mon, 16 Aug 2021 00:12:45 +0000
In-Reply-To: <20210816001246.3067312-1-oupton@google.com>
Message-Id: <20210816001246.3067312-9-oupton@google.com>
Mime-Version: 1.0
References: <20210816001246.3067312-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 8/9] selftests: KVM: Test physical counter offsetting
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

Test that userspace adjustment of the guest physical counter-timer
results in the correct view within the guest.

Cc: Andrew Jones <drjones@redhat.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Change-Id: I8a26e88df5c5bc03740c7f980c405b4d21b28be8
---
 .../selftests/kvm/include/aarch64/processor.h | 12 +++++++
 .../kvm/system_counter_offset_test.c          | 31 +++++++++++++++++--
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/aarch64/processor.h b/tools/testing/selftests/kvm/include/aarch64/processor.h
index 3168cdbae6ee..7f53d90e9512 100644
--- a/tools/testing/selftests/kvm/include/aarch64/processor.h
+++ b/tools/testing/selftests/kvm/include/aarch64/processor.h
@@ -141,4 +141,16 @@ static inline uint64_t read_cntvct_ordered(void)
 	return r;
 }
 
+static inline uint64_t read_cntpct_ordered(void)
+{
+	uint64_t r;
+
+	__asm__ __volatile__("isb\n\t"
+			     "mrs %0, cntpct_el0\n\t"
+			     "isb\n\t"
+			     : "=r"(r));
+
+	return r;
+}
+
 #endif /* SELFTEST_KVM_PROCESSOR_H */
diff --git a/tools/testing/selftests/kvm/system_counter_offset_test.c b/tools/testing/selftests/kvm/system_counter_offset_test.c
index ac933db83d03..2b8b4b84a273 100644
--- a/tools/testing/selftests/kvm/system_counter_offset_test.c
+++ b/tools/testing/selftests/kvm/system_counter_offset_test.c
@@ -57,6 +57,9 @@ static uint64_t host_read_guest_system_counter(struct test_case *test)
 
 enum arch_counter {
 	VIRTUAL,
+	PHYSICAL,
+	/* offset physical, read virtual */
+	PHYSICAL_READ_VIRTUAL,
 };
 
 struct test_case {
@@ -68,32 +71,54 @@ static struct test_case test_cases[] = {
 	{ .counter = VIRTUAL, .offset = 0 },
 	{ .counter = VIRTUAL, .offset = 180 * NSEC_PER_SEC },
 	{ .counter = VIRTUAL, .offset = -180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = 0 },
+	{ .counter = PHYSICAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL, .offset = -180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 0 },
+	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = 180 * NSEC_PER_SEC },
+	{ .counter = PHYSICAL_READ_VIRTUAL, .offset = -180 * NSEC_PER_SEC },
 };
 
 static void check_preconditions(struct kvm_vm *vm)
 {
-	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET))
+	if (vcpu_has_reg(vm, VCPU_ID, KVM_REG_ARM_TIMER_OFFSET) &&
+	    !_vcpu_has_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				   KVM_ARM_VCPU_TIMER_PHYS_OFFSET))
 		return;
 
-	print_skip("KVM_REG_ARM_TIMER_OFFSET not supported; skipping test");
+	print_skip("KVM_REG_ARM_TIMER_OFFSET|KVM_ARM_VCPU_TIMER_PHYS_OFFSET not supported; skipping test");
 	exit(KSFT_SKIP);
 }
 
 static void setup_system_counter(struct kvm_vm *vm, struct test_case *test)
 {
+	uint64_t cntvoff, cntpoff;
 	struct kvm_one_reg reg = {
 		.id = KVM_REG_ARM_TIMER_OFFSET,
-		.addr = (__u64)&test->offset,
+		.addr = (__u64)&cntvoff,
 	};
 
+	if (test->counter == VIRTUAL) {
+		cntvoff = test->offset;
+		cntpoff = 0;
+	} else {
+		cntvoff = 0;
+		cntpoff = test->offset;
+	}
+
 	vcpu_set_reg(vm, VCPU_ID, &reg);
+	vcpu_access_device_attr(vm, VCPU_ID, KVM_ARM_VCPU_TIMER_CTRL,
+				KVM_ARM_VCPU_TIMER_PHYS_OFFSET, &cntpoff, true);
 }
 
 static uint64_t guest_read_system_counter(struct test_case *test)
 {
 	switch (test->counter) {
 	case VIRTUAL:
+	case PHYSICAL_READ_VIRTUAL:
 		return read_cntvct_ordered();
+	case PHYSICAL:
+		return read_cntpct_ordered();
 	default:
 		GUEST_ASSERT(0);
 	}
-- 
2.33.0.rc1.237.g0d66db33f3-goog

